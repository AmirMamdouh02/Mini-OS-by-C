
obj/user/tst_realloc_2:     file format elf32-i386


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
  800031:	e8 b7 12 00 00       	call   8012ed <libmain>
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
  800040:	c7 45 e8 00 00 10 00 	movl   $0x100000,-0x18(%ebp)
	int kilo = 1024;
  800047:	c7 45 e4 00 04 00 00 	movl   $0x400,-0x1c(%ebp)
	void* ptr_allocations[20] = {0};
  80004e:	8d 95 78 ff ff ff    	lea    -0x88(%ebp),%edx
  800054:	b9 14 00 00 00       	mov    $0x14,%ecx
  800059:	b8 00 00 00 00       	mov    $0x0,%eax
  80005e:	89 d7                	mov    %edx,%edi
  800060:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  800062:	83 ec 0c             	sub    $0xc,%esp
  800065:	68 60 44 80 00       	push   $0x804460
  80006a:	e8 6e 16 00 00       	call   8016dd <cprintf>
  80006f:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800072:	e8 a3 2a 00 00       	call   802b1a <sys_calculate_free_frames>
  800077:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80007a:	e8 3b 2b 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  80007f:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = malloc(1*Mega-kilo);
  800082:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800085:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800088:	83 ec 0c             	sub    $0xc,%esp
  80008b:	50                   	push   %eax
  80008c:	e8 eb 25 00 00       	call   80267c <malloc>
  800091:	83 c4 10             	add    $0x10,%esp
  800094:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009a:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8000a0:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a5:	74 14                	je     8000bb <_main+0x83>
  8000a7:	83 ec 04             	sub    $0x4,%esp
  8000aa:	68 84 44 80 00       	push   $0x804484
  8000af:	6a 11                	push   $0x11
  8000b1:	68 b4 44 80 00       	push   $0x8044b4
  8000b6:	e8 6e 13 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bb:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8000be:	e8 57 2a 00 00       	call   802b1a <sys_calculate_free_frames>
  8000c3:	29 c3                	sub    %eax,%ebx
  8000c5:	89 d8                	mov    %ebx,%eax
  8000c7:	83 f8 01             	cmp    $0x1,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 cc 44 80 00       	push   $0x8044cc
  8000d4:	6a 13                	push   $0x13
  8000d6:	68 b4 44 80 00       	push   $0x8044b4
  8000db:	e8 49 13 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  8000e0:	e8 d5 2a 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  8000e5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8000e8:	3d 00 01 00 00       	cmp    $0x100,%eax
  8000ed:	74 14                	je     800103 <_main+0xcb>
  8000ef:	83 ec 04             	sub    $0x4,%esp
  8000f2:	68 38 45 80 00       	push   $0x804538
  8000f7:	6a 14                	push   $0x14
  8000f9:	68 b4 44 80 00       	push   $0x8044b4
  8000fe:	e8 26 13 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800103:	e8 12 2a 00 00       	call   802b1a <sys_calculate_free_frames>
  800108:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010b:	e8 aa 2a 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800110:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[1] = malloc(1*Mega-kilo);
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	50                   	push   %eax
  80011d:	e8 5a 25 00 00       	call   80267c <malloc>
  800122:	83 c4 10             	add    $0x10,%esp
  800125:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 1*Mega)) panic("Wrong start address for the allocated space... ");
  80012b:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800131:	89 c2                	mov    %eax,%edx
  800133:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800136:	05 00 00 00 80       	add    $0x80000000,%eax
  80013b:	39 c2                	cmp    %eax,%edx
  80013d:	74 14                	je     800153 <_main+0x11b>
  80013f:	83 ec 04             	sub    $0x4,%esp
  800142:	68 84 44 80 00       	push   $0x804484
  800147:	6a 1a                	push   $0x1a
  800149:	68 b4 44 80 00       	push   $0x8044b4
  80014e:	e8 d6 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800153:	e8 c2 29 00 00       	call   802b1a <sys_calculate_free_frames>
  800158:	89 c2                	mov    %eax,%edx
  80015a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80015d:	39 c2                	cmp    %eax,%edx
  80015f:	74 14                	je     800175 <_main+0x13d>
  800161:	83 ec 04             	sub    $0x4,%esp
  800164:	68 cc 44 80 00       	push   $0x8044cc
  800169:	6a 1c                	push   $0x1c
  80016b:	68 b4 44 80 00       	push   $0x8044b4
  800170:	e8 b4 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800175:	e8 40 2a 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  80017a:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80017d:	3d 00 01 00 00       	cmp    $0x100,%eax
  800182:	74 14                	je     800198 <_main+0x160>
  800184:	83 ec 04             	sub    $0x4,%esp
  800187:	68 38 45 80 00       	push   $0x804538
  80018c:	6a 1d                	push   $0x1d
  80018e:	68 b4 44 80 00       	push   $0x8044b4
  800193:	e8 91 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800198:	e8 7d 29 00 00       	call   802b1a <sys_calculate_free_frames>
  80019d:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001a0:	e8 15 2a 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  8001a5:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[2] = malloc(1*Mega-kilo);
  8001a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ab:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001ae:	83 ec 0c             	sub    $0xc,%esp
  8001b1:	50                   	push   %eax
  8001b2:	e8 c5 24 00 00       	call   80267c <malloc>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 80             	mov    %eax,-0x80(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the allocated space... ");
  8001bd:	8b 45 80             	mov    -0x80(%ebp),%eax
  8001c0:	89 c2                	mov    %eax,%edx
  8001c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8001cc:	39 c2                	cmp    %eax,%edx
  8001ce:	74 14                	je     8001e4 <_main+0x1ac>
  8001d0:	83 ec 04             	sub    $0x4,%esp
  8001d3:	68 84 44 80 00       	push   $0x804484
  8001d8:	6a 23                	push   $0x23
  8001da:	68 b4 44 80 00       	push   $0x8044b4
  8001df:	e8 45 12 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001e4:	e8 31 29 00 00       	call   802b1a <sys_calculate_free_frames>
  8001e9:	89 c2                	mov    %eax,%edx
  8001eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001ee:	39 c2                	cmp    %eax,%edx
  8001f0:	74 14                	je     800206 <_main+0x1ce>
  8001f2:	83 ec 04             	sub    $0x4,%esp
  8001f5:	68 cc 44 80 00       	push   $0x8044cc
  8001fa:	6a 25                	push   $0x25
  8001fc:	68 b4 44 80 00       	push   $0x8044b4
  800201:	e8 23 12 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  800206:	e8 af 29 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  80020b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80020e:	3d 00 01 00 00       	cmp    $0x100,%eax
  800213:	74 14                	je     800229 <_main+0x1f1>
  800215:	83 ec 04             	sub    $0x4,%esp
  800218:	68 38 45 80 00       	push   $0x804538
  80021d:	6a 26                	push   $0x26
  80021f:	68 b4 44 80 00       	push   $0x8044b4
  800224:	e8 00 12 00 00       	call   801429 <_panic>

		//Allocate 1 MB
		freeFrames = sys_calculate_free_frames() ;
  800229:	e8 ec 28 00 00       	call   802b1a <sys_calculate_free_frames>
  80022e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800231:	e8 84 29 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800236:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[3] = malloc(1*Mega-kilo);
  800239:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80023c:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023f:	83 ec 0c             	sub    $0xc,%esp
  800242:	50                   	push   %eax
  800243:	e8 34 24 00 00       	call   80267c <malloc>
  800248:	83 c4 10             	add    $0x10,%esp
  80024b:	89 45 84             	mov    %eax,-0x7c(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 3*Mega)) panic("Wrong start address for the allocated space... ");
  80024e:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800251:	89 c1                	mov    %eax,%ecx
  800253:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800256:	89 c2                	mov    %eax,%edx
  800258:	01 d2                	add    %edx,%edx
  80025a:	01 d0                	add    %edx,%eax
  80025c:	05 00 00 00 80       	add    $0x80000000,%eax
  800261:	39 c1                	cmp    %eax,%ecx
  800263:	74 14                	je     800279 <_main+0x241>
  800265:	83 ec 04             	sub    $0x4,%esp
  800268:	68 84 44 80 00       	push   $0x804484
  80026d:	6a 2c                	push   $0x2c
  80026f:	68 b4 44 80 00       	push   $0x8044b4
  800274:	e8 b0 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800279:	e8 9c 28 00 00       	call   802b1a <sys_calculate_free_frames>
  80027e:	89 c2                	mov    %eax,%edx
  800280:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800283:	39 c2                	cmp    %eax,%edx
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 cc 44 80 00       	push   $0x8044cc
  80028f:	6a 2e                	push   $0x2e
  800291:	68 b4 44 80 00       	push   $0x8044b4
  800296:	e8 8e 11 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are allocated in PageFile");
  80029b:	e8 1a 29 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  8002a0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8002a3:	3d 00 01 00 00       	cmp    $0x100,%eax
  8002a8:	74 14                	je     8002be <_main+0x286>
  8002aa:	83 ec 04             	sub    $0x4,%esp
  8002ad:	68 38 45 80 00       	push   $0x804538
  8002b2:	6a 2f                	push   $0x2f
  8002b4:	68 b4 44 80 00       	push   $0x8044b4
  8002b9:	e8 6b 11 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  8002be:	e8 57 28 00 00       	call   802b1a <sys_calculate_free_frames>
  8002c3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002c6:	e8 ef 28 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  8002cb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[4] = malloc(2*Mega-kilo);
  8002ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d1:	01 c0                	add    %eax,%eax
  8002d3:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002d6:	83 ec 0c             	sub    $0xc,%esp
  8002d9:	50                   	push   %eax
  8002da:	e8 9d 23 00 00       	call   80267c <malloc>
  8002df:	83 c4 10             	add    $0x10,%esp
  8002e2:	89 45 88             	mov    %eax,-0x78(%ebp)
		if ((uint32) ptr_allocations[4] !=  (USER_HEAP_START + 4*Mega)) panic("Wrong start address for the allocated space... ");
  8002e5:	8b 45 88             	mov    -0x78(%ebp),%eax
  8002e8:	89 c2                	mov    %eax,%edx
  8002ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ed:	c1 e0 02             	shl    $0x2,%eax
  8002f0:	05 00 00 00 80       	add    $0x80000000,%eax
  8002f5:	39 c2                	cmp    %eax,%edx
  8002f7:	74 14                	je     80030d <_main+0x2d5>
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	68 84 44 80 00       	push   $0x804484
  800301:	6a 35                	push   $0x35
  800303:	68 b4 44 80 00       	push   $0x8044b4
  800308:	e8 1c 11 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80030d:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800310:	e8 05 28 00 00       	call   802b1a <sys_calculate_free_frames>
  800315:	29 c3                	sub    %eax,%ebx
  800317:	89 d8                	mov    %ebx,%eax
  800319:	83 f8 01             	cmp    $0x1,%eax
  80031c:	74 14                	je     800332 <_main+0x2fa>
  80031e:	83 ec 04             	sub    $0x4,%esp
  800321:	68 cc 44 80 00       	push   $0x8044cc
  800326:	6a 37                	push   $0x37
  800328:	68 b4 44 80 00       	push   $0x8044b4
  80032d:	e8 f7 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800332:	e8 83 28 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800337:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80033a:	3d 00 02 00 00       	cmp    $0x200,%eax
  80033f:	74 14                	je     800355 <_main+0x31d>
  800341:	83 ec 04             	sub    $0x4,%esp
  800344:	68 38 45 80 00       	push   $0x804538
  800349:	6a 38                	push   $0x38
  80034b:	68 b4 44 80 00       	push   $0x8044b4
  800350:	e8 d4 10 00 00       	call   801429 <_panic>

		//Allocate 2 MB
		freeFrames = sys_calculate_free_frames() ;
  800355:	e8 c0 27 00 00       	call   802b1a <sys_calculate_free_frames>
  80035a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035d:	e8 58 28 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800362:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[5] = malloc(2*Mega-kilo);
  800365:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	50                   	push   %eax
  800371:	e8 06 23 00 00       	call   80267c <malloc>
  800376:	83 c4 10             	add    $0x10,%esp
  800379:	89 45 8c             	mov    %eax,-0x74(%ebp)
		if ((uint32) ptr_allocations[5] !=  (USER_HEAP_START + 6*Mega)) panic("Wrong start address for the allocated space... ");
  80037c:	8b 45 8c             	mov    -0x74(%ebp),%eax
  80037f:	89 c1                	mov    %eax,%ecx
  800381:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800384:	89 d0                	mov    %edx,%eax
  800386:	01 c0                	add    %eax,%eax
  800388:	01 d0                	add    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	05 00 00 00 80       	add    $0x80000000,%eax
  800391:	39 c1                	cmp    %eax,%ecx
  800393:	74 14                	je     8003a9 <_main+0x371>
  800395:	83 ec 04             	sub    $0x4,%esp
  800398:	68 84 44 80 00       	push   $0x804484
  80039d:	6a 3e                	push   $0x3e
  80039f:	68 b4 44 80 00       	push   $0x8044b4
  8003a4:	e8 80 10 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003a9:	e8 6c 27 00 00       	call   802b1a <sys_calculate_free_frames>
  8003ae:	89 c2                	mov    %eax,%edx
  8003b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	74 14                	je     8003cb <_main+0x393>
  8003b7:	83 ec 04             	sub    $0x4,%esp
  8003ba:	68 cc 44 80 00       	push   $0x8044cc
  8003bf:	6a 40                	push   $0x40
  8003c1:	68 b4 44 80 00       	push   $0x8044b4
  8003c6:	e8 5e 10 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  8003cb:	e8 ea 27 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  8003d0:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8003d3:	3d 00 02 00 00       	cmp    $0x200,%eax
  8003d8:	74 14                	je     8003ee <_main+0x3b6>
  8003da:	83 ec 04             	sub    $0x4,%esp
  8003dd:	68 38 45 80 00       	push   $0x804538
  8003e2:	6a 41                	push   $0x41
  8003e4:	68 b4 44 80 00       	push   $0x8044b4
  8003e9:	e8 3b 10 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  8003ee:	e8 27 27 00 00       	call   802b1a <sys_calculate_free_frames>
  8003f3:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8003f6:	e8 bf 27 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  8003fb:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[6] = malloc(3*Mega-kilo);
  8003fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800401:	89 c2                	mov    %eax,%edx
  800403:	01 d2                	add    %edx,%edx
  800405:	01 d0                	add    %edx,%eax
  800407:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80040a:	83 ec 0c             	sub    $0xc,%esp
  80040d:	50                   	push   %eax
  80040e:	e8 69 22 00 00       	call   80267c <malloc>
  800413:	83 c4 10             	add    $0x10,%esp
  800416:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[6] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800419:	8b 45 90             	mov    -0x70(%ebp),%eax
  80041c:	89 c2                	mov    %eax,%edx
  80041e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800421:	c1 e0 03             	shl    $0x3,%eax
  800424:	05 00 00 00 80       	add    $0x80000000,%eax
  800429:	39 c2                	cmp    %eax,%edx
  80042b:	74 14                	je     800441 <_main+0x409>
  80042d:	83 ec 04             	sub    $0x4,%esp
  800430:	68 84 44 80 00       	push   $0x804484
  800435:	6a 47                	push   $0x47
  800437:	68 b4 44 80 00       	push   $0x8044b4
  80043c:	e8 e8 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800441:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800444:	e8 d1 26 00 00       	call   802b1a <sys_calculate_free_frames>
  800449:	29 c3                	sub    %eax,%ebx
  80044b:	89 d8                	mov    %ebx,%eax
  80044d:	83 f8 01             	cmp    $0x1,%eax
  800450:	74 14                	je     800466 <_main+0x42e>
  800452:	83 ec 04             	sub    $0x4,%esp
  800455:	68 cc 44 80 00       	push   $0x8044cc
  80045a:	6a 49                	push   $0x49
  80045c:	68 b4 44 80 00       	push   $0x8044b4
  800461:	e8 c3 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800466:	e8 4f 27 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  80046b:	2b 45 dc             	sub    -0x24(%ebp),%eax
  80046e:	3d 00 03 00 00       	cmp    $0x300,%eax
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 38 45 80 00       	push   $0x804538
  80047d:	6a 4a                	push   $0x4a
  80047f:	68 b4 44 80 00       	push   $0x8044b4
  800484:	e8 a0 0f 00 00       	call   801429 <_panic>

		//Allocate 3 MB
		freeFrames = sys_calculate_free_frames() ;
  800489:	e8 8c 26 00 00       	call   802b1a <sys_calculate_free_frames>
  80048e:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800491:	e8 24 27 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800496:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = malloc(3*Mega-kilo);
  800499:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80049c:	89 c2                	mov    %eax,%edx
  80049e:	01 d2                	add    %edx,%edx
  8004a0:	01 d0                	add    %edx,%eax
  8004a2:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8004a5:	83 ec 0c             	sub    $0xc,%esp
  8004a8:	50                   	push   %eax
  8004a9:	e8 ce 21 00 00       	call   80267c <malloc>
  8004ae:	83 c4 10             	add    $0x10,%esp
  8004b1:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[7] !=  (USER_HEAP_START + 11*Mega)) panic("Wrong start address for the allocated space... ");
  8004b4:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8004b7:	89 c1                	mov    %eax,%ecx
  8004b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004bc:	89 d0                	mov    %edx,%eax
  8004be:	c1 e0 02             	shl    $0x2,%eax
  8004c1:	01 d0                	add    %edx,%eax
  8004c3:	01 c0                	add    %eax,%eax
  8004c5:	01 d0                	add    %edx,%eax
  8004c7:	05 00 00 00 80       	add    $0x80000000,%eax
  8004cc:	39 c1                	cmp    %eax,%ecx
  8004ce:	74 14                	je     8004e4 <_main+0x4ac>
  8004d0:	83 ec 04             	sub    $0x4,%esp
  8004d3:	68 84 44 80 00       	push   $0x804484
  8004d8:	6a 50                	push   $0x50
  8004da:	68 b4 44 80 00       	push   $0x8044b4
  8004df:	e8 45 0f 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8004e4:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  8004e7:	e8 2e 26 00 00       	call   802b1a <sys_calculate_free_frames>
  8004ec:	29 c3                	sub    %eax,%ebx
  8004ee:	89 d8                	mov    %ebx,%eax
  8004f0:	83 f8 01             	cmp    $0x1,%eax
  8004f3:	74 14                	je     800509 <_main+0x4d1>
  8004f5:	83 ec 04             	sub    $0x4,%esp
  8004f8:	68 cc 44 80 00       	push   $0x8044cc
  8004fd:	6a 52                	push   $0x52
  8004ff:	68 b4 44 80 00       	push   $0x8044b4
  800504:	e8 20 0f 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 768) panic("Extra or less pages are allocated in PageFile");
  800509:	e8 ac 26 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  80050e:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800511:	3d 00 03 00 00       	cmp    $0x300,%eax
  800516:	74 14                	je     80052c <_main+0x4f4>
  800518:	83 ec 04             	sub    $0x4,%esp
  80051b:	68 38 45 80 00       	push   $0x804538
  800520:	6a 53                	push   $0x53
  800522:	68 b4 44 80 00       	push   $0x8044b4
  800527:	e8 fd 0e 00 00       	call   801429 <_panic>

		//Allocate the remaining space in user heap
		freeFrames = sys_calculate_free_frames() ;
  80052c:	e8 e9 25 00 00       	call   802b1a <sys_calculate_free_frames>
  800531:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800534:	e8 81 26 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800539:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[8] = malloc((USER_HEAP_MAX - USER_HEAP_START) - 14 * Mega - kilo);
  80053c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80053f:	89 d0                	mov    %edx,%eax
  800541:	01 c0                	add    %eax,%eax
  800543:	01 d0                	add    %edx,%eax
  800545:	01 c0                	add    %eax,%eax
  800547:	01 d0                	add    %edx,%eax
  800549:	01 c0                	add    %eax,%eax
  80054b:	f7 d8                	neg    %eax
  80054d:	89 c2                	mov    %eax,%edx
  80054f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800552:	29 c2                	sub    %eax,%edx
  800554:	89 d0                	mov    %edx,%eax
  800556:	05 00 00 00 20       	add    $0x20000000,%eax
  80055b:	83 ec 0c             	sub    $0xc,%esp
  80055e:	50                   	push   %eax
  80055f:	e8 18 21 00 00       	call   80267c <malloc>
  800564:	83 c4 10             	add    $0x10,%esp
  800567:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[8] !=  (USER_HEAP_START + 14*Mega)) panic("Wrong start address for the allocated space... ");
  80056a:	8b 45 98             	mov    -0x68(%ebp),%eax
  80056d:	89 c1                	mov    %eax,%ecx
  80056f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800572:	89 d0                	mov    %edx,%eax
  800574:	01 c0                	add    %eax,%eax
  800576:	01 d0                	add    %edx,%eax
  800578:	01 c0                	add    %eax,%eax
  80057a:	01 d0                	add    %edx,%eax
  80057c:	01 c0                	add    %eax,%eax
  80057e:	05 00 00 00 80       	add    $0x80000000,%eax
  800583:	39 c1                	cmp    %eax,%ecx
  800585:	74 14                	je     80059b <_main+0x563>
  800587:	83 ec 04             	sub    $0x4,%esp
  80058a:	68 84 44 80 00       	push   $0x804484
  80058f:	6a 59                	push   $0x59
  800591:	68 b4 44 80 00       	push   $0x8044b4
  800596:	e8 8e 0e 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 768 + 1) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 124) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80059b:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  80059e:	e8 77 25 00 00       	call   802b1a <sys_calculate_free_frames>
  8005a3:	29 c3                	sub    %eax,%ebx
  8005a5:	89 d8                	mov    %ebx,%eax
  8005a7:	83 f8 7c             	cmp    $0x7c,%eax
  8005aa:	74 14                	je     8005c0 <_main+0x588>
  8005ac:	83 ec 04             	sub    $0x4,%esp
  8005af:	68 cc 44 80 00       	push   $0x8044cc
  8005b4:	6a 5b                	push   $0x5b
  8005b6:	68 b4 44 80 00       	push   $0x8044b4
  8005bb:	e8 69 0e 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 127488) panic("Extra or less pages are allocated in PageFile");
  8005c0:	e8 f5 25 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  8005c5:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8005c8:	3d 00 f2 01 00       	cmp    $0x1f200,%eax
  8005cd:	74 14                	je     8005e3 <_main+0x5ab>
  8005cf:	83 ec 04             	sub    $0x4,%esp
  8005d2:	68 38 45 80 00       	push   $0x804538
  8005d7:	6a 5c                	push   $0x5c
  8005d9:	68 b4 44 80 00       	push   $0x8044b4
  8005de:	e8 46 0e 00 00       	call   801429 <_panic>
	}

	//[2] Free some to create holes
	{
		//1 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8005e3:	e8 32 25 00 00       	call   802b1a <sys_calculate_free_frames>
  8005e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8005eb:	e8 ca 25 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  8005f0:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[1]);
  8005f3:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  8005f9:	83 ec 0c             	sub    $0xc,%esp
  8005fc:	50                   	push   %eax
  8005fd:	e8 13 21 00 00       	call   802715 <free>
  800602:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800605:	e8 b0 25 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  80060a:	8b 55 dc             	mov    -0x24(%ebp),%edx
  80060d:	29 c2                	sub    %eax,%edx
  80060f:	89 d0                	mov    %edx,%eax
  800611:	3d 00 01 00 00       	cmp    $0x100,%eax
  800616:	74 14                	je     80062c <_main+0x5f4>
  800618:	83 ec 04             	sub    $0x4,%esp
  80061b:	68 68 45 80 00       	push   $0x804568
  800620:	6a 67                	push   $0x67
  800622:	68 b4 44 80 00       	push   $0x8044b4
  800627:	e8 fd 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  80062c:	e8 e9 24 00 00       	call   802b1a <sys_calculate_free_frames>
  800631:	89 c2                	mov    %eax,%edx
  800633:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800636:	39 c2                	cmp    %eax,%edx
  800638:	74 14                	je     80064e <_main+0x616>
  80063a:	83 ec 04             	sub    $0x4,%esp
  80063d:	68 a4 45 80 00       	push   $0x8045a4
  800642:	6a 68                	push   $0x68
  800644:	68 b4 44 80 00       	push   $0x8044b4
  800649:	e8 db 0d 00 00       	call   801429 <_panic>

		//2 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  80064e:	e8 c7 24 00 00       	call   802b1a <sys_calculate_free_frames>
  800653:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800656:	e8 5f 25 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  80065b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[4]);
  80065e:	8b 45 88             	mov    -0x78(%ebp),%eax
  800661:	83 ec 0c             	sub    $0xc,%esp
  800664:	50                   	push   %eax
  800665:	e8 ab 20 00 00       	call   802715 <free>
  80066a:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 512) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 512) panic("Wrong free: Extra or less pages are removed from PageFile");
  80066d:	e8 48 25 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800672:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800675:	29 c2                	sub    %eax,%edx
  800677:	89 d0                	mov    %edx,%eax
  800679:	3d 00 02 00 00       	cmp    $0x200,%eax
  80067e:	74 14                	je     800694 <_main+0x65c>
  800680:	83 ec 04             	sub    $0x4,%esp
  800683:	68 68 45 80 00       	push   $0x804568
  800688:	6a 6f                	push   $0x6f
  80068a:	68 b4 44 80 00       	push   $0x8044b4
  80068f:	e8 95 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800694:	e8 81 24 00 00       	call   802b1a <sys_calculate_free_frames>
  800699:	89 c2                	mov    %eax,%edx
  80069b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80069e:	39 c2                	cmp    %eax,%edx
  8006a0:	74 14                	je     8006b6 <_main+0x67e>
  8006a2:	83 ec 04             	sub    $0x4,%esp
  8006a5:	68 a4 45 80 00       	push   $0x8045a4
  8006aa:	6a 70                	push   $0x70
  8006ac:	68 b4 44 80 00       	push   $0x8044b4
  8006b1:	e8 73 0d 00 00       	call   801429 <_panic>

		//3 MB Hole
		freeFrames = sys_calculate_free_frames() ;
  8006b6:	e8 5f 24 00 00       	call   802b1a <sys_calculate_free_frames>
  8006bb:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8006be:	e8 f7 24 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  8006c3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[6]);
  8006c6:	8b 45 90             	mov    -0x70(%ebp),%eax
  8006c9:	83 ec 0c             	sub    $0xc,%esp
  8006cc:	50                   	push   %eax
  8006cd:	e8 43 20 00 00       	call   802715 <free>
  8006d2:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 768) panic("Wrong free: Extra or less pages are removed from PageFile");
  8006d5:	e8 e0 24 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  8006da:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8006dd:	29 c2                	sub    %eax,%edx
  8006df:	89 d0                	mov    %edx,%eax
  8006e1:	3d 00 03 00 00       	cmp    $0x300,%eax
  8006e6:	74 14                	je     8006fc <_main+0x6c4>
  8006e8:	83 ec 04             	sub    $0x4,%esp
  8006eb:	68 68 45 80 00       	push   $0x804568
  8006f0:	6a 77                	push   $0x77
  8006f2:	68 b4 44 80 00       	push   $0x8044b4
  8006f7:	e8 2d 0d 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  8006fc:	e8 19 24 00 00       	call   802b1a <sys_calculate_free_frames>
  800701:	89 c2                	mov    %eax,%edx
  800703:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800706:	39 c2                	cmp    %eax,%edx
  800708:	74 14                	je     80071e <_main+0x6e6>
  80070a:	83 ec 04             	sub    $0x4,%esp
  80070d:	68 a4 45 80 00       	push   $0x8045a4
  800712:	6a 78                	push   $0x78
  800714:	68 b4 44 80 00       	push   $0x8044b4
  800719:	e8 0b 0d 00 00       	call   801429 <_panic>
//		free(ptr_allocations[8]);
//		//if ((sys_calculate_free_frames() - freeFrames) != 768) panic("Wrong free: ");
//		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 127488) panic("Wrong free: Extra or less pages are removed from PageFile");
//		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
	}
	int cnt = 0;
  80071e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	//Bypass the PAGE FAULT on <MOVB immediate, reg> instruction by setting its length
	//and continue executing the remaining code
	sys_bypassPageFault(3);
  800725:	83 ec 0c             	sub    $0xc,%esp
  800728:	6a 03                	push   $0x3
  80072a:	e8 83 27 00 00       	call   802eb2 <sys_bypassPageFault>
  80072f:	83 c4 10             	add    $0x10,%esp

	//[3] Test Re-allocation
	{
		/*CASE1: Re-allocate with size = 0*/

		char *byteArr = (char *) ptr_allocations[0];
  800732:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800738:	89 45 d8             	mov    %eax,-0x28(%ebp)

		//Reallocate with size = 0 [delete it]
		freeFrames = sys_calculate_free_frames() ;
  80073b:	e8 da 23 00 00       	call   802b1a <sys_calculate_free_frames>
  800740:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800743:	e8 72 24 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800748:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 0);
  80074b:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  800751:	83 ec 08             	sub    $0x8,%esp
  800754:	6a 00                	push   $0x0
  800756:	50                   	push   %eax
  800757:	e8 3c 22 00 00       	call   802998 <realloc>
  80075c:	83 c4 10             	add    $0x10,%esp
  80075f:	89 85 78 ff ff ff    	mov    %eax,-0x88(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != 0) panic("Wrong start address for the re-allocated space...it should return NULL!");
  800765:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  80076b:	85 c0                	test   %eax,%eax
  80076d:	74 17                	je     800786 <_main+0x74e>
  80076f:	83 ec 04             	sub    $0x4,%esp
  800772:	68 f0 45 80 00       	push   $0x8045f0
  800777:	68 94 00 00 00       	push   $0x94
  80077c:	68 b4 44 80 00       	push   $0x8044b4
  800781:	e8 a3 0c 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800786:	e8 8f 23 00 00       	call   802b1a <sys_calculate_free_frames>
  80078b:	89 c2                	mov    %eax,%edx
  80078d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800790:	39 c2                	cmp    %eax,%edx
  800792:	74 17                	je     8007ab <_main+0x773>
  800794:	83 ec 04             	sub    $0x4,%esp
  800797:	68 38 46 80 00       	push   $0x804638
  80079c:	68 96 00 00 00       	push   $0x96
  8007a1:	68 b4 44 80 00       	push   $0x8044b4
  8007a6:	e8 7e 0c 00 00       	call   801429 <_panic>
		if((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8007ab:	e8 0a 24 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  8007b0:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8007b3:	29 c2                	sub    %eax,%edx
  8007b5:	89 d0                	mov    %edx,%eax
  8007b7:	3d 00 01 00 00       	cmp    $0x100,%eax
  8007bc:	74 17                	je     8007d5 <_main+0x79d>
  8007be:	83 ec 04             	sub    $0x4,%esp
  8007c1:	68 a8 46 80 00       	push   $0x8046a8
  8007c6:	68 97 00 00 00       	push   $0x97
  8007cb:	68 b4 44 80 00       	push   $0x8044b4
  8007d0:	e8 54 0c 00 00       	call   801429 <_panic>

		//[2] test memory access
		byteArr[0] = 10;
  8007d5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007d8:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[0])) panic("successful access to re-allocated space with size 0!! it should not be succeeded");
  8007db:	e8 b9 26 00 00       	call   802e99 <sys_rcr2>
  8007e0:	89 c2                	mov    %eax,%edx
  8007e2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8007e5:	39 c2                	cmp    %eax,%edx
  8007e7:	74 17                	je     800800 <_main+0x7c8>
  8007e9:	83 ec 04             	sub    $0x4,%esp
  8007ec:	68 dc 46 80 00       	push   $0x8046dc
  8007f1:	68 9b 00 00 00       	push   $0x9b
  8007f6:	68 b4 44 80 00       	push   $0x8044b4
  8007fb:	e8 29 0c 00 00       	call   801429 <_panic>
		byteArr[(1*Mega-kilo)/sizeof(char) - 1] = 10;
  800800:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800803:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800806:	8d 50 ff             	lea    -0x1(%eax),%edx
  800809:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80080c:	01 d0                	add    %edx,%eax
  80080e:	c6 00 0a             	movb   $0xa,(%eax)
		if (sys_rcr2() != (uint32)&(byteArr[(1*Mega-kilo)/sizeof(char) - 1])) panic("successful access to reallocated space of size 0!! it should not be succeeded");
  800811:	e8 83 26 00 00       	call   802e99 <sys_rcr2>
  800816:	89 c2                	mov    %eax,%edx
  800818:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80081b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80081e:	8d 48 ff             	lea    -0x1(%eax),%ecx
  800821:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800824:	01 c8                	add    %ecx,%eax
  800826:	39 c2                	cmp    %eax,%edx
  800828:	74 17                	je     800841 <_main+0x809>
  80082a:	83 ec 04             	sub    $0x4,%esp
  80082d:	68 30 47 80 00       	push   $0x804730
  800832:	68 9d 00 00 00       	push   $0x9d
  800837:	68 b4 44 80 00       	push   $0x8044b4
  80083c:	e8 e8 0b 00 00       	call   801429 <_panic>

		//set it to 0 again to cancel the bypassing option
		sys_bypassPageFault(0);
  800841:	83 ec 0c             	sub    $0xc,%esp
  800844:	6a 00                	push   $0x0
  800846:	e8 67 26 00 00       	call   802eb2 <sys_bypassPageFault>
  80084b:	83 c4 10             	add    $0x10,%esp

		vcprintf("\b\b\b20%", NULL);
  80084e:	83 ec 08             	sub    $0x8,%esp
  800851:	6a 00                	push   $0x0
  800853:	68 7e 47 80 00       	push   $0x80477e
  800858:	e8 15 0e 00 00       	call   801672 <vcprintf>
  80085d:	83 c4 10             	add    $0x10,%esp

		/*CASE2: Re-allocate with address = NULL*/

		//new allocation with size = 2.5 MB, should be placed in 3rd hole
		freeFrames = sys_calculate_free_frames() ;
  800860:	e8 b5 22 00 00       	call   802b1a <sys_calculate_free_frames>
  800865:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800868:	e8 4d 23 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  80086d:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(NULL, 2*Mega + 510*kilo);
  800870:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800873:	89 d0                	mov    %edx,%eax
  800875:	c1 e0 08             	shl    $0x8,%eax
  800878:	29 d0                	sub    %edx,%eax
  80087a:	89 c2                	mov    %eax,%edx
  80087c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	01 c0                	add    %eax,%eax
  800883:	83 ec 08             	sub    $0x8,%esp
  800886:	50                   	push   %eax
  800887:	6a 00                	push   $0x0
  800889:	e8 0a 21 00 00       	call   802998 <realloc>
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] !=  (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the allocated space... ");
  800894:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800897:	89 c2                	mov    %eax,%edx
  800899:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80089c:	c1 e0 03             	shl    $0x3,%eax
  80089f:	05 00 00 00 80       	add    $0x80000000,%eax
  8008a4:	39 c2                	cmp    %eax,%edx
  8008a6:	74 17                	je     8008bf <_main+0x887>
  8008a8:	83 ec 04             	sub    $0x4,%esp
  8008ab:	68 84 44 80 00       	push   $0x804484
  8008b0:	68 aa 00 00 00       	push   $0xaa
  8008b5:	68 b4 44 80 00       	push   $0x8044b4
  8008ba:	e8 6a 0b 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 640) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  8008bf:	e8 56 22 00 00       	call   802b1a <sys_calculate_free_frames>
  8008c4:	89 c2                	mov    %eax,%edx
  8008c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c9:	39 c2                	cmp    %eax,%edx
  8008cb:	74 17                	je     8008e4 <_main+0x8ac>
  8008cd:	83 ec 04             	sub    $0x4,%esp
  8008d0:	68 38 46 80 00       	push   $0x804638
  8008d5:	68 ac 00 00 00       	push   $0xac
  8008da:	68 b4 44 80 00       	push   $0x8044b4
  8008df:	e8 45 0b 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 640) panic("Extra or less pages are re-allocated in PageFile");
  8008e4:	e8 d1 22 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  8008e9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8008ec:	3d 80 02 00 00       	cmp    $0x280,%eax
  8008f1:	74 17                	je     80090a <_main+0x8d2>
  8008f3:	83 ec 04             	sub    $0x4,%esp
  8008f6:	68 a8 46 80 00       	push   $0x8046a8
  8008fb:	68 ad 00 00 00       	push   $0xad
  800900:	68 b4 44 80 00       	push   $0x8044b4
  800905:	e8 1f 0b 00 00       	call   801429 <_panic>

		//Fill it with data
		int *intArr = (int*) ptr_allocations[10];
  80090a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80090d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int lastIndexOfInt1 = (2*Mega + 510*kilo)/sizeof(int) - 1;
  800910:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800913:	89 d0                	mov    %edx,%eax
  800915:	c1 e0 08             	shl    $0x8,%eax
  800918:	29 d0                	sub    %edx,%eax
  80091a:	89 c2                	mov    %eax,%edx
  80091c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80091f:	01 d0                	add    %edx,%eax
  800921:	01 c0                	add    %eax,%eax
  800923:	c1 e8 02             	shr    $0x2,%eax
  800926:	48                   	dec    %eax
  800927:	89 45 d0             	mov    %eax,-0x30(%ebp)

		int i = 0;
  80092a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  800931:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800938:	eb 17                	jmp    800951 <_main+0x919>
		{
			intArr[i] = i;
  80093a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80093d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800944:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800947:	01 c2                	add    %eax,%edx
  800949:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094c:	89 02                	mov    %eax,(%edx)
//		{
//			intArr[i] = i ;
//		}

		//fill the first 100 elements
		for(i = 0; i < 100; i++)
  80094e:	ff 45 f0             	incl   -0x10(%ebp)
  800951:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800955:	7e e3                	jle    80093a <_main+0x902>
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800957:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80095a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80095d:	eb 17                	jmp    800976 <_main+0x93e>
		{
			intArr[i] = i;
  80095f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800962:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800969:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80096c:	01 c2                	add    %eax,%edx
  80096e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800971:	89 02                	mov    %eax,(%edx)
			intArr[i] = i;
		}


		//fill the last 100 element
		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  800973:	ff 4d f0             	decl   -0x10(%ebp)
  800976:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800979:	83 e8 63             	sub    $0x63,%eax
  80097c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80097f:	7e de                	jle    80095f <_main+0x927>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800981:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800988:	eb 33                	jmp    8009bd <_main+0x985>
		{
			cnt++;
  80098a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800997:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80099a:	01 d0                	add    %edx,%eax
  80099c:	8b 00                	mov    (%eax),%eax
  80099e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009a1:	74 17                	je     8009ba <_main+0x982>
  8009a3:	83 ec 04             	sub    $0x4,%esp
  8009a6:	68 88 47 80 00       	push   $0x804788
  8009ab:	68 ca 00 00 00       	push   $0xca
  8009b0:	68 b4 44 80 00       	push   $0x8044b4
  8009b5:	e8 6f 0a 00 00       	call   801429 <_panic>
		{
			intArr[i] = i;
		}

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  8009ba:	ff 45 f0             	incl   -0x10(%ebp)
  8009bd:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8009c1:	7e c7                	jle    80098a <_main+0x952>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009c3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	eb 33                	jmp    8009fe <_main+0x9c6>
		{
			cnt++;
  8009cb:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8009ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8009d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8009db:	01 d0                	add    %edx,%eax
  8009dd:	8b 00                	mov    (%eax),%eax
  8009df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8009e2:	74 17                	je     8009fb <_main+0x9c3>
  8009e4:	83 ec 04             	sub    $0x4,%esp
  8009e7:	68 88 47 80 00       	push   $0x804788
  8009ec:	68 d0 00 00 00       	push   $0xd0
  8009f1:	68 b4 44 80 00       	push   $0x8044b4
  8009f6:	e8 2e 0a 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i >= lastIndexOfInt1 - 99; i--)
  8009fb:	ff 4d f0             	decl   -0x10(%ebp)
  8009fe:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800a01:	83 e8 63             	sub    $0x63,%eax
  800a04:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a07:	7e c2                	jle    8009cb <_main+0x993>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		vcprintf("\b\b\b40%", NULL);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	6a 00                	push   $0x0
  800a0e:	68 c0 47 80 00       	push   $0x8047c0
  800a13:	e8 5a 0c 00 00       	call   801672 <vcprintf>
  800a18:	83 c4 10             	add    $0x10,%esp

		/*CASE3: Re-allocate in the existing internal fragment (no additional pages are required)*/

		//Reallocate last allocation with 1 extra KB [should be placed in the existing 2 KB internal fragment]
		freeFrames = sys_calculate_free_frames() ;
  800a1b:	e8 fa 20 00 00       	call   802b1a <sys_calculate_free_frames>
  800a20:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800a23:	e8 92 21 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800a28:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = realloc(ptr_allocations[10], 2*Mega + 510*kilo + kilo);
  800a2b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800a2e:	89 d0                	mov    %edx,%eax
  800a30:	c1 e0 08             	shl    $0x8,%eax
  800a33:	29 d0                	sub    %edx,%eax
  800a35:	89 c2                	mov    %eax,%edx
  800a37:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a3a:	01 d0                	add    %edx,%eax
  800a3c:	01 c0                	add    %eax,%eax
  800a3e:	89 c2                	mov    %eax,%edx
  800a40:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800a43:	01 d0                	add    %edx,%eax
  800a45:	89 c2                	mov    %eax,%edx
  800a47:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	52                   	push   %edx
  800a4e:	50                   	push   %eax
  800a4f:	e8 44 1f 00 00       	call   802998 <realloc>
  800a54:	83 c4 10             	add    $0x10,%esp
  800a57:	89 45 a0             	mov    %eax,-0x60(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START + 8*Mega)) panic("Wrong start address for the re-allocated space... ");
  800a5a:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800a5d:	89 c2                	mov    %eax,%edx
  800a5f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800a62:	c1 e0 03             	shl    $0x3,%eax
  800a65:	05 00 00 00 80       	add    $0x80000000,%eax
  800a6a:	39 c2                	cmp    %eax,%edx
  800a6c:	74 17                	je     800a85 <_main+0xa4d>
  800a6e:	83 ec 04             	sub    $0x4,%esp
  800a71:	68 c8 47 80 00       	push   $0x8047c8
  800a76:	68 dc 00 00 00       	push   $0xdc
  800a7b:	68 b4 44 80 00       	push   $0x8044b4
  800a80:	e8 a4 09 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");

		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800a85:	e8 90 20 00 00       	call   802b1a <sys_calculate_free_frames>
  800a8a:	89 c2                	mov    %eax,%edx
  800a8c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a8f:	39 c2                	cmp    %eax,%edx
  800a91:	74 17                	je     800aaa <_main+0xa72>
  800a93:	83 ec 04             	sub    $0x4,%esp
  800a96:	68 38 46 80 00       	push   $0x804638
  800a9b:	68 df 00 00 00       	push   $0xdf
  800aa0:	68 b4 44 80 00       	push   $0x8044b4
  800aa5:	e8 7f 09 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800aaa:	e8 0b 21 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800aaf:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800ab2:	74 17                	je     800acb <_main+0xa93>
  800ab4:	83 ec 04             	sub    $0x4,%esp
  800ab7:	68 a8 46 80 00       	push   $0x8046a8
  800abc:	68 e0 00 00 00       	push   $0xe0
  800ac1:	68 b4 44 80 00       	push   $0x8044b4
  800ac6:	e8 5e 09 00 00       	call   801429 <_panic>

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;
  800acb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ace:	89 d0                	mov    %edx,%eax
  800ad0:	c1 e0 08             	shl    $0x8,%eax
  800ad3:	29 d0                	sub    %edx,%eax
  800ad5:	89 c2                	mov    %eax,%edx
  800ad7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ada:	01 d0                	add    %edx,%eax
  800adc:	01 c0                	add    %eax,%eax
  800ade:	89 c2                	mov    %eax,%edx
  800ae0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800ae3:	01 d0                	add    %edx,%eax
  800ae5:	c1 e8 02             	shr    $0x2,%eax
  800ae8:	48                   	dec    %eax
  800ae9:	89 45 cc             	mov    %eax,-0x34(%ebp)

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800aec:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800aef:	40                   	inc    %eax
  800af0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af3:	eb 17                	jmp    800b0c <_main+0xad4>
		{
			intArr[i] = i ;
  800af5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800af8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800aff:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b02:	01 c2                	add    %eax,%edx
  800b04:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b07:	89 02                	mov    %eax,(%edx)
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		int lastIndexOfInt2 = (2*Mega + 510*kilo + kilo)/sizeof(int) - 1;

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800b09:	ff 45 f0             	incl   -0x10(%ebp)
  800b0c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b0f:	83 c0 65             	add    $0x65,%eax
  800b12:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b15:	7f de                	jg     800af5 <_main+0xabd>
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b17:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1d:	eb 17                	jmp    800b36 <_main+0xafe>
		{
			intArr[i] = i ;
  800b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b22:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b29:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b2c:	01 c2                	add    %eax,%edx
  800b2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b31:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}


		for (i=lastIndexOfInt2 ; i >= lastIndexOfInt2 - 99 ; i--)
  800b33:	ff 4d f0             	decl   -0x10(%ebp)
  800b36:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800b39:	83 e8 63             	sub    $0x63,%eax
  800b3c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b3f:	7e de                	jle    800b1f <_main+0xae7>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b48:	eb 33                	jmp    800b7d <_main+0xb45>
		{
			cnt++;
  800b4a:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b50:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b57:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b5a:	01 d0                	add    %edx,%eax
  800b5c:	8b 00                	mov    (%eax),%eax
  800b5e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800b61:	74 17                	je     800b7a <_main+0xb42>
  800b63:	83 ec 04             	sub    $0x4,%esp
  800b66:	68 88 47 80 00       	push   $0x804788
  800b6b:	68 f4 00 00 00       	push   $0xf4
  800b70:	68 b4 44 80 00       	push   $0x8044b4
  800b75:	e8 af 08 00 00       	call   801429 <_panic>
		{
			intArr[i] = i ;
		}


		for (i=0; i < 100 ; i++)
  800b7a:	ff 45 f0             	incl   -0x10(%ebp)
  800b7d:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800b81:	7e c7                	jle    800b4a <_main+0xb12>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800b83:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b86:	48                   	dec    %eax
  800b87:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8a:	eb 33                	jmp    800bbf <_main+0xb87>
		{
			cnt++;
  800b8c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800b8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b92:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b99:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800b9c:	01 d0                	add    %edx,%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ba3:	74 17                	je     800bbc <_main+0xb84>
  800ba5:	83 ec 04             	sub    $0x4,%esp
  800ba8:	68 88 47 80 00       	push   $0x804788
  800bad:	68 f9 00 00 00       	push   $0xf9
  800bb2:	68 b4 44 80 00       	push   $0x8044b4
  800bb7:	e8 6d 08 00 00       	call   801429 <_panic>
		for (i=0; i < 100 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
  800bbc:	ff 4d f0             	decl   -0x10(%ebp)
  800bbf:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bc2:	83 e8 63             	sub    $0x63,%eax
  800bc5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bc8:	7e c2                	jle    800b8c <_main+0xb54>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800bca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800bcd:	40                   	inc    %eax
  800bce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd1:	eb 33                	jmp    800c06 <_main+0xbce>
		{
			cnt++;
  800bd3:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800bd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bd9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800be0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800be3:	01 d0                	add    %edx,%eax
  800be5:	8b 00                	mov    (%eax),%eax
  800be7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bea:	74 17                	je     800c03 <_main+0xbcb>
  800bec:	83 ec 04             	sub    $0x4,%esp
  800bef:	68 88 47 80 00       	push   $0x804788
  800bf4:	68 fe 00 00 00       	push   $0xfe
  800bf9:	68 b4 44 80 00       	push   $0x8044b4
  800bfe:	e8 26 08 00 00       	call   801429 <_panic>
		for (i=lastIndexOfInt1 - 1; i >= lastIndexOfInt1 - 99 ; i--)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  800c03:	ff 45 f0             	incl   -0x10(%ebp)
  800c06:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c09:	83 c0 65             	add    $0x65,%eax
  800c0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c0f:	7f c2                	jg     800bd3 <_main+0xb9b>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c11:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c17:	eb 33                	jmp    800c4c <_main+0xc14>
		{
			cnt++;
  800c19:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800c1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800c26:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800c29:	01 d0                	add    %edx,%eax
  800c2b:	8b 00                	mov    (%eax),%eax
  800c2d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c30:	74 17                	je     800c49 <_main+0xc11>
  800c32:	83 ec 04             	sub    $0x4,%esp
  800c35:	68 88 47 80 00       	push   $0x804788
  800c3a:	68 03 01 00 00       	push   $0x103
  800c3f:	68 b4 44 80 00       	push   $0x8044b4
  800c44:	e8 e0 07 00 00       	call   801429 <_panic>
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}
		for (i=lastIndexOfInt2; i >= lastIndexOfInt2 - 99 ; i--)
  800c49:	ff 4d f0             	decl   -0x10(%ebp)
  800c4c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  800c4f:	83 e8 63             	sub    $0x63,%eax
  800c52:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800c55:	7e c2                	jle    800c19 <_main+0xbe1>
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}


		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  800c57:	e8 be 1e 00 00       	call   802b1a <sys_calculate_free_frames>
  800c5c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800c5f:	e8 56 1f 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800c64:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[10]);
  800c67:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800c6a:	83 ec 0c             	sub    $0xc,%esp
  800c6d:	50                   	push   %eax
  800c6e:	e8 a2 1a 00 00       	call   802715 <free>
  800c73:	83 c4 10             	add    $0x10,%esp

		//if ((sys_calculate_free_frames() - freeFrames) != 640) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 640) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800c76:	e8 3f 1f 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800c7b:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800c7e:	29 c2                	sub    %eax,%edx
  800c80:	89 d0                	mov    %edx,%eax
  800c82:	3d 80 02 00 00       	cmp    $0x280,%eax
  800c87:	74 17                	je     800ca0 <_main+0xc68>
  800c89:	83 ec 04             	sub    $0x4,%esp
  800c8c:	68 fc 47 80 00       	push   $0x8047fc
  800c91:	68 0d 01 00 00       	push   $0x10d
  800c96:	68 b4 44 80 00       	push   $0x8044b4
  800c9b:	e8 89 07 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800ca0:	e8 75 1e 00 00       	call   802b1a <sys_calculate_free_frames>
  800ca5:	89 c2                	mov    %eax,%edx
  800ca7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800caa:	29 c2                	sub    %eax,%edx
  800cac:	89 d0                	mov    %edx,%eax
  800cae:	83 f8 03             	cmp    $0x3,%eax
  800cb1:	74 17                	je     800cca <_main+0xc92>
  800cb3:	83 ec 04             	sub    $0x4,%esp
  800cb6:	68 50 48 80 00       	push   $0x804850
  800cbb:	68 0e 01 00 00       	push   $0x10e
  800cc0:	68 b4 44 80 00       	push   $0x8044b4
  800cc5:	e8 5f 07 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b60%", NULL);
  800cca:	83 ec 08             	sub    $0x8,%esp
  800ccd:	6a 00                	push   $0x0
  800ccf:	68 b4 48 80 00       	push   $0x8048b4
  800cd4:	e8 99 09 00 00       	call   801672 <vcprintf>
  800cd9:	83 c4 10             	add    $0x10,%esp

		/*CASE4: Re-allocate that can NOT fit in any free fragment*/

		//Fill 3rd allocation with data
		intArr = (int*) ptr_allocations[2];
  800cdc:	8b 45 80             	mov    -0x80(%ebp),%eax
  800cdf:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;
  800ce2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ce5:	c1 e8 02             	shr    $0x2,%eax
  800ce8:	48                   	dec    %eax
  800ce9:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  800cec:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800cf3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800cfa:	eb 17                	jmp    800d13 <_main+0xcdb>
		{
			intArr[i] = i ;
  800cfc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800cff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d06:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d09:	01 c2                	add    %eax,%edx
  800d0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d0e:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (1*Mega)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 element
		for (i=0; i < 100 ; i++)
  800d10:	ff 45 f0             	incl   -0x10(%ebp)
  800d13:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800d17:	7e e3                	jle    800cfc <_main+0xcc4>
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d19:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d1c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d1f:	eb 17                	jmp    800d38 <_main+0xd00>
		{
			intArr[i] = i;
  800d21:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d24:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800d2b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800d2e:	01 c2                	add    %eax,%edx
  800d30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d33:	89 02                	mov    %eax,(%edx)
		{
			intArr[i] = i ;
		}

		//filling the last 100 element
		for(int i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800d35:	ff 4d ec             	decl   -0x14(%ebp)
  800d38:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d3b:	83 e8 64             	sub    $0x64,%eax
  800d3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800d41:	7c de                	jl     800d21 <_main+0xce9>
		{
			intArr[i] = i;
		}

		//Reallocate it to large size that can't be fit in any free segment
		freeFrames = sys_calculate_free_frames() ;
  800d43:	e8 d2 1d 00 00       	call   802b1a <sys_calculate_free_frames>
  800d48:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800d4b:	e8 6a 1e 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800d50:	89 45 dc             	mov    %eax,-0x24(%ebp)
		void* origAddress = ptr_allocations[2];
  800d53:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d56:	89 45 c8             	mov    %eax,-0x38(%ebp)
		ptr_allocations[2] = realloc(ptr_allocations[2], (USER_HEAP_MAX - USER_HEAP_START - 13*Mega));
  800d59:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800d5c:	89 d0                	mov    %edx,%eax
  800d5e:	01 c0                	add    %eax,%eax
  800d60:	01 d0                	add    %edx,%eax
  800d62:	c1 e0 02             	shl    $0x2,%eax
  800d65:	01 d0                	add    %edx,%eax
  800d67:	f7 d8                	neg    %eax
  800d69:	8d 90 00 00 00 20    	lea    0x20000000(%eax),%edx
  800d6f:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d72:	83 ec 08             	sub    $0x8,%esp
  800d75:	52                   	push   %edx
  800d76:	50                   	push   %eax
  800d77:	e8 1c 1c 00 00       	call   802998 <realloc>
  800d7c:	83 c4 10             	add    $0x10,%esp
  800d7f:	89 45 80             	mov    %eax,-0x80(%ebp)

		//cprintf("%x\n", ptr_allocations[2]);
		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[2] != 0) panic("Wrong start address for the re-allocated space... ");
  800d82:	8b 45 80             	mov    -0x80(%ebp),%eax
  800d85:	85 c0                	test   %eax,%eax
  800d87:	74 17                	je     800da0 <_main+0xd68>
  800d89:	83 ec 04             	sub    $0x4,%esp
  800d8c:	68 c8 47 80 00       	push   $0x8047c8
  800d91:	68 2d 01 00 00       	push   $0x12d
  800d96:	68 b4 44 80 00       	push   $0x8044b4
  800d9b:	e8 89 06 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
  800da0:	e8 75 1d 00 00       	call   802b1a <sys_calculate_free_frames>
  800da5:	89 c2                	mov    %eax,%edx
  800da7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800daa:	39 c2                	cmp    %eax,%edx
  800dac:	74 17                	je     800dc5 <_main+0xd8d>
  800dae:	83 ec 04             	sub    $0x4,%esp
  800db1:	68 38 46 80 00       	push   $0x804638
  800db6:	68 2f 01 00 00       	push   $0x12f
  800dbb:	68 b4 44 80 00       	push   $0x8044b4
  800dc0:	e8 64 06 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");
  800dc5:	e8 f0 1d 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800dca:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800dcd:	74 17                	je     800de6 <_main+0xdae>
  800dcf:	83 ec 04             	sub    $0x4,%esp
  800dd2:	68 a8 46 80 00       	push   $0x8046a8
  800dd7:	68 30 01 00 00       	push   $0x130
  800ddc:	68 b4 44 80 00       	push   $0x8044b4
  800de1:	e8 43 06 00 00       	call   801429 <_panic>

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800de6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800ded:	eb 33                	jmp    800e22 <_main+0xdea>
		{
			cnt++;
  800def:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800df2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800df5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800dfc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800dff:	01 d0                	add    %edx,%eax
  800e01:	8b 00                	mov    (%eax),%eax
  800e03:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e06:	74 17                	je     800e1f <_main+0xde7>
  800e08:	83 ec 04             	sub    $0x4,%esp
  800e0b:	68 88 47 80 00       	push   $0x804788
  800e10:	68 36 01 00 00       	push   $0x136
  800e15:	68 b4 44 80 00       	push   $0x8044b4
  800e1a:	e8 0a 06 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are re-allocated in PageFile");

		//[2] test memory access
		for (i=0; i < 100 ; i++)
  800e1f:	ff 45 f0             	incl   -0x10(%ebp)
  800e22:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  800e26:	7e c7                	jle    800def <_main+0xdb7>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e28:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2e:	eb 33                	jmp    800e63 <_main+0xe2b>
		{
			cnt++;
  800e30:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  800e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e36:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800e3d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	8b 00                	mov    (%eax),%eax
  800e44:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e47:	74 17                	je     800e60 <_main+0xe28>
  800e49:	83 ec 04             	sub    $0x4,%esp
  800e4c:	68 88 47 80 00       	push   $0x804788
  800e51:	68 3c 01 00 00       	push   $0x13c
  800e56:	68 b4 44 80 00       	push   $0x8044b4
  800e5b:	e8 c9 05 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  800e60:	ff 4d f0             	decl   -0x10(%ebp)
  800e63:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800e66:	83 e8 64             	sub    $0x64,%eax
  800e69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800e6c:	7c c2                	jl     800e30 <_main+0xdf8>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after FAILURE expansion
		freeFrames = sys_calculate_free_frames() ;
  800e6e:	e8 a7 1c 00 00       	call   802b1a <sys_calculate_free_frames>
  800e73:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800e76:	e8 3f 1d 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800e7b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(origAddress);
  800e7e:	83 ec 0c             	sub    $0xc,%esp
  800e81:	ff 75 c8             	pushl  -0x38(%ebp)
  800e84:	e8 8c 18 00 00       	call   802715 <free>
  800e89:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  800e8c:	e8 29 1d 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800e91:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800e94:	29 c2                	sub    %eax,%edx
  800e96:	89 d0                	mov    %edx,%eax
  800e98:	3d 00 01 00 00       	cmp    $0x100,%eax
  800e9d:	74 17                	je     800eb6 <_main+0xe7e>
  800e9f:	83 ec 04             	sub    $0x4,%esp
  800ea2:	68 fc 47 80 00       	push   $0x8047fc
  800ea7:	68 44 01 00 00       	push   $0x144
  800eac:	68 b4 44 80 00       	push   $0x8044b4
  800eb1:	e8 73 05 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 2 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");
  800eb6:	e8 5f 1c 00 00       	call   802b1a <sys_calculate_free_frames>
  800ebb:	89 c2                	mov    %eax,%edx
  800ebd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	83 f8 03             	cmp    $0x3,%eax
  800ec7:	74 17                	je     800ee0 <_main+0xea8>
  800ec9:	83 ec 04             	sub    $0x4,%esp
  800ecc:	68 50 48 80 00       	push   $0x804850
  800ed1:	68 45 01 00 00       	push   $0x145
  800ed6:	68 b4 44 80 00       	push   $0x8044b4
  800edb:	e8 49 05 00 00       	call   801429 <_panic>

		vcprintf("\b\b\b80%", NULL);
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	6a 00                	push   $0x0
  800ee5:	68 bb 48 80 00       	push   $0x8048bb
  800eea:	e8 83 07 00 00       	call   801672 <vcprintf>
  800eef:	83 c4 10             	add    $0x10,%esp
		/*CASE5: Re-allocate that test FIRST FIT strategy*/

		//[1] create 4 MB hole at beginning of the heap

		//Take 2 MB from currently 3 MB hole at beginning of the heap
		freeFrames = sys_calculate_free_frames() ;
  800ef2:	e8 23 1c 00 00       	call   802b1a <sys_calculate_free_frames>
  800ef7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800efa:	e8 bb 1c 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800eff:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[10] = malloc(2*Mega-kilo);
  800f02:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f05:	01 c0                	add    %eax,%eax
  800f07:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800f0a:	83 ec 0c             	sub    $0xc,%esp
  800f0d:	50                   	push   %eax
  800f0e:	e8 69 17 00 00       	call   80267c <malloc>
  800f13:	83 c4 10             	add    $0x10,%esp
  800f16:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[10] != (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  800f19:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800f1c:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  800f21:	74 17                	je     800f3a <_main+0xf02>
  800f23:	83 ec 04             	sub    $0x4,%esp
  800f26:	68 84 44 80 00       	push   $0x804484
  800f2b:	68 51 01 00 00       	push   $0x151
  800f30:	68 b4 44 80 00       	push   $0x8044b4
  800f35:	e8 ef 04 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800f3a:	e8 db 1b 00 00       	call   802b1a <sys_calculate_free_frames>
  800f3f:	89 c2                	mov    %eax,%edx
  800f41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f44:	39 c2                	cmp    %eax,%edx
  800f46:	74 17                	je     800f5f <_main+0xf27>
  800f48:	83 ec 04             	sub    $0x4,%esp
  800f4b:	68 cc 44 80 00       	push   $0x8044cc
  800f50:	68 53 01 00 00       	push   $0x153
  800f55:	68 b4 44 80 00       	push   $0x8044b4
  800f5a:	e8 ca 04 00 00       	call   801429 <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 512) panic("Extra or less pages are allocated in PageFile");
  800f5f:	e8 56 1c 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800f64:	2b 45 dc             	sub    -0x24(%ebp),%eax
  800f67:	3d 00 02 00 00       	cmp    $0x200,%eax
  800f6c:	74 17                	je     800f85 <_main+0xf4d>
  800f6e:	83 ec 04             	sub    $0x4,%esp
  800f71:	68 38 45 80 00       	push   $0x804538
  800f76:	68 54 01 00 00       	push   $0x154
  800f7b:	68 b4 44 80 00       	push   $0x8044b4
  800f80:	e8 a4 04 00 00       	call   801429 <_panic>

		//remove 1 MB allocation between 1 MB hole and 2 MB hole to create 4 MB hole
		freeFrames = sys_calculate_free_frames() ;
  800f85:	e8 90 1b 00 00       	call   802b1a <sys_calculate_free_frames>
  800f8a:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800f8d:	e8 28 1c 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800f92:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[3]);
  800f95:	8b 45 84             	mov    -0x7c(%ebp),%eax
  800f98:	83 ec 0c             	sub    $0xc,%esp
  800f9b:	50                   	push   %eax
  800f9c:	e8 74 17 00 00       	call   802715 <free>
  800fa1:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 256) panic("Wrong free: ");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 256) panic("Wrong free: Extra or less pages are removed from PageFile");
  800fa4:	e8 11 1c 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  800fa9:	8b 55 dc             	mov    -0x24(%ebp),%edx
  800fac:	29 c2                	sub    %eax,%edx
  800fae:	89 d0                	mov    %edx,%eax
  800fb0:	3d 00 01 00 00       	cmp    $0x100,%eax
  800fb5:	74 17                	je     800fce <_main+0xf96>
  800fb7:	83 ec 04             	sub    $0x4,%esp
  800fba:	68 68 45 80 00       	push   $0x804568
  800fbf:	68 5b 01 00 00       	push   $0x15b
  800fc4:	68 b4 44 80 00       	push   $0x8044b4
  800fc9:	e8 5b 04 00 00       	call   801429 <_panic>
		if ((sys_calculate_free_frames() - freeFrames) != 0) panic("Wrong free: WS pages in memory and/or page tables are not freed correctly");
  800fce:	e8 47 1b 00 00       	call   802b1a <sys_calculate_free_frames>
  800fd3:	89 c2                	mov    %eax,%edx
  800fd5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fd8:	39 c2                	cmp    %eax,%edx
  800fda:	74 17                	je     800ff3 <_main+0xfbb>
  800fdc:	83 ec 04             	sub    $0x4,%esp
  800fdf:	68 a4 45 80 00       	push   $0x8045a4
  800fe4:	68 5c 01 00 00       	push   $0x15c
  800fe9:	68 b4 44 80 00       	push   $0x8044b4
  800fee:	e8 36 04 00 00       	call   801429 <_panic>
		{
			//allocate 1 page after each 3 MB
			sys_allocateMem(i, PAGE_SIZE) ;
		}*/

		malloc(5*Mega-kilo);
  800ff3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ff6:	89 d0                	mov    %edx,%eax
  800ff8:	c1 e0 02             	shl    $0x2,%eax
  800ffb:	01 d0                	add    %edx,%eax
  800ffd:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801000:	83 ec 0c             	sub    $0xc,%esp
  801003:	50                   	push   %eax
  801004:	e8 73 16 00 00       	call   80267c <malloc>
  801009:	83 c4 10             	add    $0x10,%esp

		//Fill last 3MB allocation with data
		intArr = (int*) ptr_allocations[7];
  80100c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80100f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;
  801012:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801015:	89 c2                	mov    %eax,%edx
  801017:	01 d2                	add    %edx,%edx
  801019:	01 d0                	add    %edx,%eax
  80101b:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80101e:	c1 e8 02             	shr    $0x2,%eax
  801021:	48                   	dec    %eax
  801022:	89 45 d0             	mov    %eax,-0x30(%ebp)

		i = 0;
  801025:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  80102c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  801033:	eb 17                	jmp    80104c <_main+0x1014>
		{
			intArr[i] = i ;
  801035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801038:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80103f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801042:	01 c2                	add    %eax,%edx
  801044:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801047:	89 02                	mov    %eax,(%edx)
		intArr = (int*) ptr_allocations[7];
		lastIndexOfInt1 = (3*Mega-kilo)/sizeof(int) - 1;

		i = 0;
		//filling the first 100 elements of the last 3 mega
		for (i=0; i < 100 ; i++)
  801049:	ff 45 f0             	incl   -0x10(%ebp)
  80104c:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  801050:	7e e3                	jle    801035 <_main+0xffd>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  801052:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801055:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801058:	eb 17                	jmp    801071 <_main+0x1039>
		{
			intArr[i] = i;
  80105a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80105d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801064:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801067:	01 c2                	add    %eax,%edx
  801069:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80106c:	89 02                	mov    %eax,(%edx)
		for (i=0; i < 100 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt1; i > lastIndexOfInt1 - 100; i--)
  80106e:	ff 4d f0             	decl   -0x10(%ebp)
  801071:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801074:	83 e8 64             	sub    $0x64,%eax
  801077:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80107a:	7c de                	jl     80105a <_main+0x1022>
		{
			intArr[i] = i;
		}

		//Reallocate it to 4 MB, so that it can only fit at the 1st fragment
		freeFrames = sys_calculate_free_frames() ;
  80107c:	e8 99 1a 00 00       	call   802b1a <sys_calculate_free_frames>
  801081:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801084:	e8 31 1b 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  801089:	89 45 dc             	mov    %eax,-0x24(%ebp)
		ptr_allocations[7] = realloc(ptr_allocations[7], 4*Mega-kilo);
  80108c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80108f:	c1 e0 02             	shl    $0x2,%eax
  801092:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80109a:	83 ec 08             	sub    $0x8,%esp
  80109d:	52                   	push   %edx
  80109e:	50                   	push   %eax
  80109f:	e8 f4 18 00 00       	call   802998 <realloc>
  8010a4:	83 c4 10             	add    $0x10,%esp
  8010a7:	89 45 94             	mov    %eax,-0x6c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[7] != (USER_HEAP_START + 2*Mega)) panic("Wrong start address for the re-allocated space... ");
  8010aa:	8b 45 94             	mov    -0x6c(%ebp),%eax
  8010ad:	89 c2                	mov    %eax,%edx
  8010af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010b2:	01 c0                	add    %eax,%eax
  8010b4:	05 00 00 00 80       	add    $0x80000000,%eax
  8010b9:	39 c2                	cmp    %eax,%edx
  8010bb:	74 17                	je     8010d4 <_main+0x109c>
  8010bd:	83 ec 04             	sub    $0x4,%esp
  8010c0:	68 c8 47 80 00       	push   $0x8047c8
  8010c5:	68 7d 01 00 00       	push   $0x17d
  8010ca:	68 b4 44 80 00       	push   $0x8044b4
  8010cf:	e8 55 03 00 00       	call   801429 <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 - 1) panic("Wrong re-allocation");
		//if((sys_calculate_free_frames() - freeFrames) != 2 + 2) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 256) panic("Extra or less pages are re-allocated in PageFile");
  8010d4:	e8 e1 1a 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  8010d9:	2b 45 dc             	sub    -0x24(%ebp),%eax
  8010dc:	3d 00 01 00 00       	cmp    $0x100,%eax
  8010e1:	74 17                	je     8010fa <_main+0x10c2>
  8010e3:	83 ec 04             	sub    $0x4,%esp
  8010e6:	68 a8 46 80 00       	push   $0x8046a8
  8010eb:	68 80 01 00 00       	push   $0x180
  8010f0:	68 b4 44 80 00       	push   $0x8044b4
  8010f5:	e8 2f 03 00 00       	call   801429 <_panic>


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
  8010fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8010fd:	c1 e0 02             	shl    $0x2,%eax
  801100:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  801103:	c1 e8 02             	shr    $0x2,%eax
  801106:	48                   	dec    %eax
  801107:	89 45 cc             	mov    %eax,-0x34(%ebp)
		intArr = (int*) ptr_allocations[7];
  80110a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80110d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801110:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801113:	40                   	inc    %eax
  801114:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801117:	eb 17                	jmp    801130 <_main+0x10f8>
		{
			intArr[i] = i ;
  801119:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80111c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801123:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801126:	01 c2                	add    %eax,%edx
  801128:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80112b:	89 02                	mov    %eax,(%edx)


		//[2] test memory access
		lastIndexOfInt2 = (4*Mega-kilo)/sizeof(int) - 1;
		intArr = (int*) ptr_allocations[7];
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  80112d:	ff 45 f0             	incl   -0x10(%ebp)
  801130:	8b 45 d0             	mov    -0x30(%ebp),%eax
  801133:	83 c0 65             	add    $0x65,%eax
  801136:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801139:	7f de                	jg     801119 <_main+0x10e1>
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80113b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80113e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801141:	eb 17                	jmp    80115a <_main+0x1122>
		{
			intArr[i] = i;
  801143:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801146:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80114d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801150:	01 c2                	add    %eax,%edx
  801152:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801155:	89 02                	mov    %eax,(%edx)
		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
		{
			intArr[i] = i ;
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801157:	ff 4d f0             	decl   -0x10(%ebp)
  80115a:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80115d:	83 e8 64             	sub    $0x64,%eax
  801160:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801163:	7c de                	jl     801143 <_main+0x110b>
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  801165:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80116c:	eb 33                	jmp    8011a1 <_main+0x1169>
		{
			cnt++;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  801171:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801174:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80117b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80117e:	01 d0                	add    %edx,%eax
  801180:	8b 00                	mov    (%eax),%eax
  801182:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801185:	74 17                	je     80119e <_main+0x1166>
  801187:	83 ec 04             	sub    $0x4,%esp
  80118a:	68 88 47 80 00       	push   $0x804788
  80118f:	68 93 01 00 00       	push   $0x193
  801194:	68 b4 44 80 00       	push   $0x8044b4
  801199:	e8 8b 02 00 00       	call   801429 <_panic>
		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
		{
			intArr[i] = i;
		}

		for (i=0; i < 100 ; i++)
  80119e:	ff 45 f0             	incl   -0x10(%ebp)
  8011a1:	83 7d f0 63          	cmpl   $0x63,-0x10(%ebp)
  8011a5:	7e c7                	jle    80116e <_main+0x1136>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011a7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011ad:	eb 33                	jmp    8011e2 <_main+0x11aa>
		{
			cnt++;
  8011af:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011bc:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8011bf:	01 d0                	add    %edx,%eax
  8011c1:	8b 00                	mov    (%eax),%eax
  8011c3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011c6:	74 17                	je     8011df <_main+0x11a7>
  8011c8:	83 ec 04             	sub    $0x4,%esp
  8011cb:	68 88 47 80 00       	push   $0x804788
  8011d0:	68 99 01 00 00       	push   $0x199
  8011d5:	68 b4 44 80 00       	push   $0x8044b4
  8011da:	e8 4a 02 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1; i > lastIndexOfInt1 - 100 ; i--)
  8011df:	ff 4d f0             	decl   -0x10(%ebp)
  8011e2:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011e5:	83 e8 64             	sub    $0x64,%eax
  8011e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011eb:	7c c2                	jl     8011af <_main+0x1177>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  8011ed:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8011f0:	40                   	inc    %eax
  8011f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011f4:	eb 33                	jmp    801229 <_main+0x11f1>
		{
			cnt++;
  8011f6:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  8011f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011fc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801203:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  801206:	01 d0                	add    %edx,%eax
  801208:	8b 00                	mov    (%eax),%eax
  80120a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80120d:	74 17                	je     801226 <_main+0x11ee>
  80120f:	83 ec 04             	sub    $0x4,%esp
  801212:	68 88 47 80 00       	push   $0x804788
  801217:	68 9f 01 00 00       	push   $0x19f
  80121c:	68 b4 44 80 00       	push   $0x8044b4
  801221:	e8 03 02 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for (i=lastIndexOfInt1 + 1; i < lastIndexOfInt1 + 101 ; i++)
  801226:	ff 45 f0             	incl   -0x10(%ebp)
  801229:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80122c:	83 c0 65             	add    $0x65,%eax
  80122f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801232:	7f c2                	jg     8011f6 <_main+0x11be>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  801234:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801237:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80123a:	eb 33                	jmp    80126f <_main+0x1237>
		{
			cnt++;
  80123c:	ff 45 f4             	incl   -0xc(%ebp)
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
  80123f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801242:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801249:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  80124c:	01 d0                	add    %edx,%eax
  80124e:	8b 00                	mov    (%eax),%eax
  801250:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801253:	74 17                	je     80126c <_main+0x1234>
  801255:	83 ec 04             	sub    $0x4,%esp
  801258:	68 88 47 80 00       	push   $0x804788
  80125d:	68 a5 01 00 00       	push   $0x1a5
  801262:	68 b4 44 80 00       	push   $0x8044b4
  801267:	e8 bd 01 00 00       	call   801429 <_panic>
		{
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		for(i = lastIndexOfInt2; i > lastIndexOfInt2 - 100; i--)
  80126c:	ff 4d f0             	decl   -0x10(%ebp)
  80126f:	8b 45 cc             	mov    -0x34(%ebp),%eax
  801272:	83 e8 64             	sub    $0x64,%eax
  801275:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801278:	7c c2                	jl     80123c <_main+0x1204>
			cnt++;
			if (intArr[i] != i) panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//[3] test freeing it after expansion
		freeFrames = sys_calculate_free_frames() ;
  80127a:	e8 9b 18 00 00       	call   802b1a <sys_calculate_free_frames>
  80127f:	89 45 e0             	mov    %eax,-0x20(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  801282:	e8 33 19 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  801287:	89 45 dc             	mov    %eax,-0x24(%ebp)
		free(ptr_allocations[7]);
  80128a:	8b 45 94             	mov    -0x6c(%ebp),%eax
  80128d:	83 ec 0c             	sub    $0xc,%esp
  801290:	50                   	push   %eax
  801291:	e8 7f 14 00 00       	call   802715 <free>
  801296:	83 c4 10             	add    $0x10,%esp
		//if ((sys_calculate_free_frames() - freeFrames) != 1024) panic("Wrong free of the re-allocated space");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 1024) panic("Wrong free of the re-allocated space: Extra or less pages are removed from PageFile");
  801299:	e8 1c 19 00 00       	call   802bba <sys_pf_calculate_allocated_pages>
  80129e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  8012a1:	29 c2                	sub    %eax,%edx
  8012a3:	89 d0                	mov    %edx,%eax
  8012a5:	3d 00 04 00 00       	cmp    $0x400,%eax
  8012aa:	74 17                	je     8012c3 <_main+0x128b>
  8012ac:	83 ec 04             	sub    $0x4,%esp
  8012af:	68 fc 47 80 00       	push   $0x8047fc
  8012b4:	68 ad 01 00 00       	push   $0x1ad
  8012b9:	68 b4 44 80 00       	push   $0x8044b4
  8012be:	e8 66 01 00 00       	call   801429 <_panic>
		//if ((sys_calculate_free_frames() - freeFrames) != 4 + 1) panic("Wrong free of the re-allocated space: WS pages in memory and/or page tables are not freed correctly");

		vcprintf("\b\b\b100%\n", NULL);
  8012c3:	83 ec 08             	sub    $0x8,%esp
  8012c6:	6a 00                	push   $0x0
  8012c8:	68 c2 48 80 00       	push   $0x8048c2
  8012cd:	e8 a0 03 00 00       	call   801672 <vcprintf>
  8012d2:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [2] completed successfully.\n");
  8012d5:	83 ec 0c             	sub    $0xc,%esp
  8012d8:	68 cc 48 80 00       	push   $0x8048cc
  8012dd:	e8 fb 03 00 00       	call   8016dd <cprintf>
  8012e2:	83 c4 10             	add    $0x10,%esp

	return;
  8012e5:	90                   	nop
}
  8012e6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012e9:	5b                   	pop    %ebx
  8012ea:	5f                   	pop    %edi
  8012eb:	5d                   	pop    %ebp
  8012ec:	c3                   	ret    

008012ed <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8012f3:	e8 02 1b 00 00       	call   802dfa <sys_getenvindex>
  8012f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8012fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012fe:	89 d0                	mov    %edx,%eax
  801300:	c1 e0 03             	shl    $0x3,%eax
  801303:	01 d0                	add    %edx,%eax
  801305:	01 c0                	add    %eax,%eax
  801307:	01 d0                	add    %edx,%eax
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	01 d0                	add    %edx,%eax
  801312:	c1 e0 04             	shl    $0x4,%eax
  801315:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80131a:	a3 20 60 80 00       	mov    %eax,0x806020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80131f:	a1 20 60 80 00       	mov    0x806020,%eax
  801324:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80132a:	84 c0                	test   %al,%al
  80132c:	74 0f                	je     80133d <libmain+0x50>
		binaryname = myEnv->prog_name;
  80132e:	a1 20 60 80 00       	mov    0x806020,%eax
  801333:	05 5c 05 00 00       	add    $0x55c,%eax
  801338:	a3 00 60 80 00       	mov    %eax,0x806000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80133d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801341:	7e 0a                	jle    80134d <libmain+0x60>
		binaryname = argv[0];
  801343:	8b 45 0c             	mov    0xc(%ebp),%eax
  801346:	8b 00                	mov    (%eax),%eax
  801348:	a3 00 60 80 00       	mov    %eax,0x806000

	// call user main routine
	_main(argc, argv);
  80134d:	83 ec 08             	sub    $0x8,%esp
  801350:	ff 75 0c             	pushl  0xc(%ebp)
  801353:	ff 75 08             	pushl  0x8(%ebp)
  801356:	e8 dd ec ff ff       	call   800038 <_main>
  80135b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80135e:	e8 a4 18 00 00       	call   802c07 <sys_disable_interrupt>
	cprintf("**************************************\n");
  801363:	83 ec 0c             	sub    $0xc,%esp
  801366:	68 20 49 80 00       	push   $0x804920
  80136b:	e8 6d 03 00 00       	call   8016dd <cprintf>
  801370:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  801373:	a1 20 60 80 00       	mov    0x806020,%eax
  801378:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80137e:	a1 20 60 80 00       	mov    0x806020,%eax
  801383:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  801389:	83 ec 04             	sub    $0x4,%esp
  80138c:	52                   	push   %edx
  80138d:	50                   	push   %eax
  80138e:	68 48 49 80 00       	push   $0x804948
  801393:	e8 45 03 00 00       	call   8016dd <cprintf>
  801398:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80139b:	a1 20 60 80 00       	mov    0x806020,%eax
  8013a0:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8013a6:	a1 20 60 80 00       	mov    0x806020,%eax
  8013ab:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8013b1:	a1 20 60 80 00       	mov    0x806020,%eax
  8013b6:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8013bc:	51                   	push   %ecx
  8013bd:	52                   	push   %edx
  8013be:	50                   	push   %eax
  8013bf:	68 70 49 80 00       	push   $0x804970
  8013c4:	e8 14 03 00 00       	call   8016dd <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8013cc:	a1 20 60 80 00       	mov    0x806020,%eax
  8013d1:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8013d7:	83 ec 08             	sub    $0x8,%esp
  8013da:	50                   	push   %eax
  8013db:	68 c8 49 80 00       	push   $0x8049c8
  8013e0:	e8 f8 02 00 00       	call   8016dd <cprintf>
  8013e5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8013e8:	83 ec 0c             	sub    $0xc,%esp
  8013eb:	68 20 49 80 00       	push   $0x804920
  8013f0:	e8 e8 02 00 00       	call   8016dd <cprintf>
  8013f5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8013f8:	e8 24 18 00 00       	call   802c21 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8013fd:	e8 19 00 00 00       	call   80141b <exit>
}
  801402:	90                   	nop
  801403:	c9                   	leave  
  801404:	c3                   	ret    

00801405 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  801405:	55                   	push   %ebp
  801406:	89 e5                	mov    %esp,%ebp
  801408:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80140b:	83 ec 0c             	sub    $0xc,%esp
  80140e:	6a 00                	push   $0x0
  801410:	e8 b1 19 00 00       	call   802dc6 <sys_destroy_env>
  801415:	83 c4 10             	add    $0x10,%esp
}
  801418:	90                   	nop
  801419:	c9                   	leave  
  80141a:	c3                   	ret    

0080141b <exit>:

void
exit(void)
{
  80141b:	55                   	push   %ebp
  80141c:	89 e5                	mov    %esp,%ebp
  80141e:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  801421:	e8 06 1a 00 00       	call   802e2c <sys_exit_env>
}
  801426:	90                   	nop
  801427:	c9                   	leave  
  801428:	c3                   	ret    

00801429 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  801429:	55                   	push   %ebp
  80142a:	89 e5                	mov    %esp,%ebp
  80142c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80142f:	8d 45 10             	lea    0x10(%ebp),%eax
  801432:	83 c0 04             	add    $0x4,%eax
  801435:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  801438:	a1 5c 61 80 00       	mov    0x80615c,%eax
  80143d:	85 c0                	test   %eax,%eax
  80143f:	74 16                	je     801457 <_panic+0x2e>
		cprintf("%s: ", argv0);
  801441:	a1 5c 61 80 00       	mov    0x80615c,%eax
  801446:	83 ec 08             	sub    $0x8,%esp
  801449:	50                   	push   %eax
  80144a:	68 dc 49 80 00       	push   $0x8049dc
  80144f:	e8 89 02 00 00       	call   8016dd <cprintf>
  801454:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  801457:	a1 00 60 80 00       	mov    0x806000,%eax
  80145c:	ff 75 0c             	pushl  0xc(%ebp)
  80145f:	ff 75 08             	pushl  0x8(%ebp)
  801462:	50                   	push   %eax
  801463:	68 e1 49 80 00       	push   $0x8049e1
  801468:	e8 70 02 00 00       	call   8016dd <cprintf>
  80146d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  801470:	8b 45 10             	mov    0x10(%ebp),%eax
  801473:	83 ec 08             	sub    $0x8,%esp
  801476:	ff 75 f4             	pushl  -0xc(%ebp)
  801479:	50                   	push   %eax
  80147a:	e8 f3 01 00 00       	call   801672 <vcprintf>
  80147f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  801482:	83 ec 08             	sub    $0x8,%esp
  801485:	6a 00                	push   $0x0
  801487:	68 fd 49 80 00       	push   $0x8049fd
  80148c:	e8 e1 01 00 00       	call   801672 <vcprintf>
  801491:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  801494:	e8 82 ff ff ff       	call   80141b <exit>

	// should not return here
	while (1) ;
  801499:	eb fe                	jmp    801499 <_panic+0x70>

0080149b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80149b:	55                   	push   %ebp
  80149c:	89 e5                	mov    %esp,%ebp
  80149e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8014a1:	a1 20 60 80 00       	mov    0x806020,%eax
  8014a6:	8b 50 74             	mov    0x74(%eax),%edx
  8014a9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014ac:	39 c2                	cmp    %eax,%edx
  8014ae:	74 14                	je     8014c4 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8014b0:	83 ec 04             	sub    $0x4,%esp
  8014b3:	68 00 4a 80 00       	push   $0x804a00
  8014b8:	6a 26                	push   $0x26
  8014ba:	68 4c 4a 80 00       	push   $0x804a4c
  8014bf:	e8 65 ff ff ff       	call   801429 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8014c4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8014cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8014d2:	e9 c2 00 00 00       	jmp    801599 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8014d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	01 d0                	add    %edx,%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	75 08                	jne    8014f4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8014ec:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8014ef:	e9 a2 00 00 00       	jmp    801596 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8014f4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8014fb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  801502:	eb 69                	jmp    80156d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  801504:	a1 20 60 80 00       	mov    0x806020,%eax
  801509:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80150f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801512:	89 d0                	mov    %edx,%eax
  801514:	01 c0                	add    %eax,%eax
  801516:	01 d0                	add    %edx,%eax
  801518:	c1 e0 03             	shl    $0x3,%eax
  80151b:	01 c8                	add    %ecx,%eax
  80151d:	8a 40 04             	mov    0x4(%eax),%al
  801520:	84 c0                	test   %al,%al
  801522:	75 46                	jne    80156a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  801524:	a1 20 60 80 00       	mov    0x806020,%eax
  801529:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80152f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801532:	89 d0                	mov    %edx,%eax
  801534:	01 c0                	add    %eax,%eax
  801536:	01 d0                	add    %edx,%eax
  801538:	c1 e0 03             	shl    $0x3,%eax
  80153b:	01 c8                	add    %ecx,%eax
  80153d:	8b 00                	mov    (%eax),%eax
  80153f:	89 45 dc             	mov    %eax,-0x24(%ebp)
  801542:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801545:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80154a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80154c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  801556:	8b 45 08             	mov    0x8(%ebp),%eax
  801559:	01 c8                	add    %ecx,%eax
  80155b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80155d:	39 c2                	cmp    %eax,%edx
  80155f:	75 09                	jne    80156a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  801561:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  801568:	eb 12                	jmp    80157c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80156a:	ff 45 e8             	incl   -0x18(%ebp)
  80156d:	a1 20 60 80 00       	mov    0x806020,%eax
  801572:	8b 50 74             	mov    0x74(%eax),%edx
  801575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801578:	39 c2                	cmp    %eax,%edx
  80157a:	77 88                	ja     801504 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80157c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801580:	75 14                	jne    801596 <CheckWSWithoutLastIndex+0xfb>
			panic(
  801582:	83 ec 04             	sub    $0x4,%esp
  801585:	68 58 4a 80 00       	push   $0x804a58
  80158a:	6a 3a                	push   $0x3a
  80158c:	68 4c 4a 80 00       	push   $0x804a4c
  801591:	e8 93 fe ff ff       	call   801429 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  801596:	ff 45 f0             	incl   -0x10(%ebp)
  801599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80159f:	0f 8c 32 ff ff ff    	jl     8014d7 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8015a5:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015ac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8015b3:	eb 26                	jmp    8015db <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8015b5:	a1 20 60 80 00       	mov    0x806020,%eax
  8015ba:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8015c0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8015c3:	89 d0                	mov    %edx,%eax
  8015c5:	01 c0                	add    %eax,%eax
  8015c7:	01 d0                	add    %edx,%eax
  8015c9:	c1 e0 03             	shl    $0x3,%eax
  8015cc:	01 c8                	add    %ecx,%eax
  8015ce:	8a 40 04             	mov    0x4(%eax),%al
  8015d1:	3c 01                	cmp    $0x1,%al
  8015d3:	75 03                	jne    8015d8 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8015d5:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8015d8:	ff 45 e0             	incl   -0x20(%ebp)
  8015db:	a1 20 60 80 00       	mov    0x806020,%eax
  8015e0:	8b 50 74             	mov    0x74(%eax),%edx
  8015e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8015e6:	39 c2                	cmp    %eax,%edx
  8015e8:	77 cb                	ja     8015b5 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8015ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015ed:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8015f0:	74 14                	je     801606 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8015f2:	83 ec 04             	sub    $0x4,%esp
  8015f5:	68 ac 4a 80 00       	push   $0x804aac
  8015fa:	6a 44                	push   $0x44
  8015fc:	68 4c 4a 80 00       	push   $0x804a4c
  801601:	e8 23 fe ff ff       	call   801429 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  801606:	90                   	nop
  801607:	c9                   	leave  
  801608:	c3                   	ret    

00801609 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  801609:	55                   	push   %ebp
  80160a:	89 e5                	mov    %esp,%ebp
  80160c:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80160f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801612:	8b 00                	mov    (%eax),%eax
  801614:	8d 48 01             	lea    0x1(%eax),%ecx
  801617:	8b 55 0c             	mov    0xc(%ebp),%edx
  80161a:	89 0a                	mov    %ecx,(%edx)
  80161c:	8b 55 08             	mov    0x8(%ebp),%edx
  80161f:	88 d1                	mov    %dl,%cl
  801621:	8b 55 0c             	mov    0xc(%ebp),%edx
  801624:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	8b 00                	mov    (%eax),%eax
  80162d:	3d ff 00 00 00       	cmp    $0xff,%eax
  801632:	75 2c                	jne    801660 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  801634:	a0 24 60 80 00       	mov    0x806024,%al
  801639:	0f b6 c0             	movzbl %al,%eax
  80163c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80163f:	8b 12                	mov    (%edx),%edx
  801641:	89 d1                	mov    %edx,%ecx
  801643:	8b 55 0c             	mov    0xc(%ebp),%edx
  801646:	83 c2 08             	add    $0x8,%edx
  801649:	83 ec 04             	sub    $0x4,%esp
  80164c:	50                   	push   %eax
  80164d:	51                   	push   %ecx
  80164e:	52                   	push   %edx
  80164f:	e8 05 14 00 00       	call   802a59 <sys_cputs>
  801654:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  801657:	8b 45 0c             	mov    0xc(%ebp),%eax
  80165a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  801660:	8b 45 0c             	mov    0xc(%ebp),%eax
  801663:	8b 40 04             	mov    0x4(%eax),%eax
  801666:	8d 50 01             	lea    0x1(%eax),%edx
  801669:	8b 45 0c             	mov    0xc(%ebp),%eax
  80166c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80166f:	90                   	nop
  801670:	c9                   	leave  
  801671:	c3                   	ret    

00801672 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  801672:	55                   	push   %ebp
  801673:	89 e5                	mov    %esp,%ebp
  801675:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80167b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  801682:	00 00 00 
	b.cnt = 0;
  801685:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80168c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80168f:	ff 75 0c             	pushl  0xc(%ebp)
  801692:	ff 75 08             	pushl  0x8(%ebp)
  801695:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80169b:	50                   	push   %eax
  80169c:	68 09 16 80 00       	push   $0x801609
  8016a1:	e8 11 02 00 00       	call   8018b7 <vprintfmt>
  8016a6:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8016a9:	a0 24 60 80 00       	mov    0x806024,%al
  8016ae:	0f b6 c0             	movzbl %al,%eax
  8016b1:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8016b7:	83 ec 04             	sub    $0x4,%esp
  8016ba:	50                   	push   %eax
  8016bb:	52                   	push   %edx
  8016bc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8016c2:	83 c0 08             	add    $0x8,%eax
  8016c5:	50                   	push   %eax
  8016c6:	e8 8e 13 00 00       	call   802a59 <sys_cputs>
  8016cb:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8016ce:	c6 05 24 60 80 00 00 	movb   $0x0,0x806024
	return b.cnt;
  8016d5:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8016db:	c9                   	leave  
  8016dc:	c3                   	ret    

008016dd <cprintf>:

int cprintf(const char *fmt, ...) {
  8016dd:	55                   	push   %ebp
  8016de:	89 e5                	mov    %esp,%ebp
  8016e0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8016e3:	c6 05 24 60 80 00 01 	movb   $0x1,0x806024
	va_start(ap, fmt);
  8016ea:	8d 45 0c             	lea    0xc(%ebp),%eax
  8016ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8016f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f3:	83 ec 08             	sub    $0x8,%esp
  8016f6:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f9:	50                   	push   %eax
  8016fa:	e8 73 ff ff ff       	call   801672 <vcprintf>
  8016ff:	83 c4 10             	add    $0x10,%esp
  801702:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801708:	c9                   	leave  
  801709:	c3                   	ret    

0080170a <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80170a:	55                   	push   %ebp
  80170b:	89 e5                	mov    %esp,%ebp
  80170d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801710:	e8 f2 14 00 00       	call   802c07 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  801715:	8d 45 0c             	lea    0xc(%ebp),%eax
  801718:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80171b:	8b 45 08             	mov    0x8(%ebp),%eax
  80171e:	83 ec 08             	sub    $0x8,%esp
  801721:	ff 75 f4             	pushl  -0xc(%ebp)
  801724:	50                   	push   %eax
  801725:	e8 48 ff ff ff       	call   801672 <vcprintf>
  80172a:	83 c4 10             	add    $0x10,%esp
  80172d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  801730:	e8 ec 14 00 00       	call   802c21 <sys_enable_interrupt>
	return cnt;
  801735:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
  80173d:	53                   	push   %ebx
  80173e:	83 ec 14             	sub    $0x14,%esp
  801741:	8b 45 10             	mov    0x10(%ebp),%eax
  801744:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801747:	8b 45 14             	mov    0x14(%ebp),%eax
  80174a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80174d:	8b 45 18             	mov    0x18(%ebp),%eax
  801750:	ba 00 00 00 00       	mov    $0x0,%edx
  801755:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  801758:	77 55                	ja     8017af <printnum+0x75>
  80175a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80175d:	72 05                	jb     801764 <printnum+0x2a>
  80175f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801762:	77 4b                	ja     8017af <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  801764:	8b 45 1c             	mov    0x1c(%ebp),%eax
  801767:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80176a:	8b 45 18             	mov    0x18(%ebp),%eax
  80176d:	ba 00 00 00 00       	mov    $0x0,%edx
  801772:	52                   	push   %edx
  801773:	50                   	push   %eax
  801774:	ff 75 f4             	pushl  -0xc(%ebp)
  801777:	ff 75 f0             	pushl  -0x10(%ebp)
  80177a:	e8 65 2a 00 00       	call   8041e4 <__udivdi3>
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	83 ec 04             	sub    $0x4,%esp
  801785:	ff 75 20             	pushl  0x20(%ebp)
  801788:	53                   	push   %ebx
  801789:	ff 75 18             	pushl  0x18(%ebp)
  80178c:	52                   	push   %edx
  80178d:	50                   	push   %eax
  80178e:	ff 75 0c             	pushl  0xc(%ebp)
  801791:	ff 75 08             	pushl  0x8(%ebp)
  801794:	e8 a1 ff ff ff       	call   80173a <printnum>
  801799:	83 c4 20             	add    $0x20,%esp
  80179c:	eb 1a                	jmp    8017b8 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80179e:	83 ec 08             	sub    $0x8,%esp
  8017a1:	ff 75 0c             	pushl  0xc(%ebp)
  8017a4:	ff 75 20             	pushl  0x20(%ebp)
  8017a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017aa:	ff d0                	call   *%eax
  8017ac:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8017af:	ff 4d 1c             	decl   0x1c(%ebp)
  8017b2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8017b6:	7f e6                	jg     80179e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8017b8:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8017bb:	bb 00 00 00 00       	mov    $0x0,%ebx
  8017c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c6:	53                   	push   %ebx
  8017c7:	51                   	push   %ecx
  8017c8:	52                   	push   %edx
  8017c9:	50                   	push   %eax
  8017ca:	e8 25 2b 00 00       	call   8042f4 <__umoddi3>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	05 14 4d 80 00       	add    $0x804d14,%eax
  8017d7:	8a 00                	mov    (%eax),%al
  8017d9:	0f be c0             	movsbl %al,%eax
  8017dc:	83 ec 08             	sub    $0x8,%esp
  8017df:	ff 75 0c             	pushl  0xc(%ebp)
  8017e2:	50                   	push   %eax
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	ff d0                	call   *%eax
  8017e8:	83 c4 10             	add    $0x10,%esp
}
  8017eb:	90                   	nop
  8017ec:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8017f4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8017f8:	7e 1c                	jle    801816 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8017fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fd:	8b 00                	mov    (%eax),%eax
  8017ff:	8d 50 08             	lea    0x8(%eax),%edx
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	89 10                	mov    %edx,(%eax)
  801807:	8b 45 08             	mov    0x8(%ebp),%eax
  80180a:	8b 00                	mov    (%eax),%eax
  80180c:	83 e8 08             	sub    $0x8,%eax
  80180f:	8b 50 04             	mov    0x4(%eax),%edx
  801812:	8b 00                	mov    (%eax),%eax
  801814:	eb 40                	jmp    801856 <getuint+0x65>
	else if (lflag)
  801816:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80181a:	74 1e                	je     80183a <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80181c:	8b 45 08             	mov    0x8(%ebp),%eax
  80181f:	8b 00                	mov    (%eax),%eax
  801821:	8d 50 04             	lea    0x4(%eax),%edx
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	89 10                	mov    %edx,(%eax)
  801829:	8b 45 08             	mov    0x8(%ebp),%eax
  80182c:	8b 00                	mov    (%eax),%eax
  80182e:	83 e8 04             	sub    $0x4,%eax
  801831:	8b 00                	mov    (%eax),%eax
  801833:	ba 00 00 00 00       	mov    $0x0,%edx
  801838:	eb 1c                	jmp    801856 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80183a:	8b 45 08             	mov    0x8(%ebp),%eax
  80183d:	8b 00                	mov    (%eax),%eax
  80183f:	8d 50 04             	lea    0x4(%eax),%edx
  801842:	8b 45 08             	mov    0x8(%ebp),%eax
  801845:	89 10                	mov    %edx,(%eax)
  801847:	8b 45 08             	mov    0x8(%ebp),%eax
  80184a:	8b 00                	mov    (%eax),%eax
  80184c:	83 e8 04             	sub    $0x4,%eax
  80184f:	8b 00                	mov    (%eax),%eax
  801851:	ba 00 00 00 00       	mov    $0x0,%edx
}
  801856:	5d                   	pop    %ebp
  801857:	c3                   	ret    

00801858 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80185b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80185f:	7e 1c                	jle    80187d <getint+0x25>
		return va_arg(*ap, long long);
  801861:	8b 45 08             	mov    0x8(%ebp),%eax
  801864:	8b 00                	mov    (%eax),%eax
  801866:	8d 50 08             	lea    0x8(%eax),%edx
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	89 10                	mov    %edx,(%eax)
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	8b 00                	mov    (%eax),%eax
  801873:	83 e8 08             	sub    $0x8,%eax
  801876:	8b 50 04             	mov    0x4(%eax),%edx
  801879:	8b 00                	mov    (%eax),%eax
  80187b:	eb 38                	jmp    8018b5 <getint+0x5d>
	else if (lflag)
  80187d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801881:	74 1a                	je     80189d <getint+0x45>
		return va_arg(*ap, long);
  801883:	8b 45 08             	mov    0x8(%ebp),%eax
  801886:	8b 00                	mov    (%eax),%eax
  801888:	8d 50 04             	lea    0x4(%eax),%edx
  80188b:	8b 45 08             	mov    0x8(%ebp),%eax
  80188e:	89 10                	mov    %edx,(%eax)
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	8b 00                	mov    (%eax),%eax
  801895:	83 e8 04             	sub    $0x4,%eax
  801898:	8b 00                	mov    (%eax),%eax
  80189a:	99                   	cltd   
  80189b:	eb 18                	jmp    8018b5 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80189d:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a0:	8b 00                	mov    (%eax),%eax
  8018a2:	8d 50 04             	lea    0x4(%eax),%edx
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	89 10                	mov    %edx,(%eax)
  8018aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ad:	8b 00                	mov    (%eax),%eax
  8018af:	83 e8 04             	sub    $0x4,%eax
  8018b2:	8b 00                	mov    (%eax),%eax
  8018b4:	99                   	cltd   
}
  8018b5:	5d                   	pop    %ebp
  8018b6:	c3                   	ret    

008018b7 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	56                   	push   %esi
  8018bb:	53                   	push   %ebx
  8018bc:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018bf:	eb 17                	jmp    8018d8 <vprintfmt+0x21>
			if (ch == '\0')
  8018c1:	85 db                	test   %ebx,%ebx
  8018c3:	0f 84 af 03 00 00    	je     801c78 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8018c9:	83 ec 08             	sub    $0x8,%esp
  8018cc:	ff 75 0c             	pushl  0xc(%ebp)
  8018cf:	53                   	push   %ebx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	ff d0                	call   *%eax
  8018d5:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8018d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018db:	8d 50 01             	lea    0x1(%eax),%edx
  8018de:	89 55 10             	mov    %edx,0x10(%ebp)
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	0f b6 d8             	movzbl %al,%ebx
  8018e6:	83 fb 25             	cmp    $0x25,%ebx
  8018e9:	75 d6                	jne    8018c1 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8018eb:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8018ef:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8018f6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8018fd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  801904:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80190b:	8b 45 10             	mov    0x10(%ebp),%eax
  80190e:	8d 50 01             	lea    0x1(%eax),%edx
  801911:	89 55 10             	mov    %edx,0x10(%ebp)
  801914:	8a 00                	mov    (%eax),%al
  801916:	0f b6 d8             	movzbl %al,%ebx
  801919:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80191c:	83 f8 55             	cmp    $0x55,%eax
  80191f:	0f 87 2b 03 00 00    	ja     801c50 <vprintfmt+0x399>
  801925:	8b 04 85 38 4d 80 00 	mov    0x804d38(,%eax,4),%eax
  80192c:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80192e:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  801932:	eb d7                	jmp    80190b <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  801934:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  801938:	eb d1                	jmp    80190b <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80193a:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  801941:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801944:	89 d0                	mov    %edx,%eax
  801946:	c1 e0 02             	shl    $0x2,%eax
  801949:	01 d0                	add    %edx,%eax
  80194b:	01 c0                	add    %eax,%eax
  80194d:	01 d8                	add    %ebx,%eax
  80194f:	83 e8 30             	sub    $0x30,%eax
  801952:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  801955:	8b 45 10             	mov    0x10(%ebp),%eax
  801958:	8a 00                	mov    (%eax),%al
  80195a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80195d:	83 fb 2f             	cmp    $0x2f,%ebx
  801960:	7e 3e                	jle    8019a0 <vprintfmt+0xe9>
  801962:	83 fb 39             	cmp    $0x39,%ebx
  801965:	7f 39                	jg     8019a0 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  801967:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80196a:	eb d5                	jmp    801941 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80196c:	8b 45 14             	mov    0x14(%ebp),%eax
  80196f:	83 c0 04             	add    $0x4,%eax
  801972:	89 45 14             	mov    %eax,0x14(%ebp)
  801975:	8b 45 14             	mov    0x14(%ebp),%eax
  801978:	83 e8 04             	sub    $0x4,%eax
  80197b:	8b 00                	mov    (%eax),%eax
  80197d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  801980:	eb 1f                	jmp    8019a1 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  801982:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801986:	79 83                	jns    80190b <vprintfmt+0x54>
				width = 0;
  801988:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80198f:	e9 77 ff ff ff       	jmp    80190b <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801994:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80199b:	e9 6b ff ff ff       	jmp    80190b <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8019a0:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8019a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8019a5:	0f 89 60 ff ff ff    	jns    80190b <vprintfmt+0x54>
				width = precision, precision = -1;
  8019ab:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8019ae:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8019b1:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8019b8:	e9 4e ff ff ff       	jmp    80190b <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8019bd:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8019c0:	e9 46 ff ff ff       	jmp    80190b <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8019c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8019c8:	83 c0 04             	add    $0x4,%eax
  8019cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8019ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8019d1:	83 e8 04             	sub    $0x4,%eax
  8019d4:	8b 00                	mov    (%eax),%eax
  8019d6:	83 ec 08             	sub    $0x8,%esp
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	50                   	push   %eax
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	ff d0                	call   *%eax
  8019e2:	83 c4 10             	add    $0x10,%esp
			break;
  8019e5:	e9 89 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8019ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8019ed:	83 c0 04             	add    $0x4,%eax
  8019f0:	89 45 14             	mov    %eax,0x14(%ebp)
  8019f3:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f6:	83 e8 04             	sub    $0x4,%eax
  8019f9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8019fb:	85 db                	test   %ebx,%ebx
  8019fd:	79 02                	jns    801a01 <vprintfmt+0x14a>
				err = -err;
  8019ff:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801a01:	83 fb 64             	cmp    $0x64,%ebx
  801a04:	7f 0b                	jg     801a11 <vprintfmt+0x15a>
  801a06:	8b 34 9d 80 4b 80 00 	mov    0x804b80(,%ebx,4),%esi
  801a0d:	85 f6                	test   %esi,%esi
  801a0f:	75 19                	jne    801a2a <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801a11:	53                   	push   %ebx
  801a12:	68 25 4d 80 00       	push   $0x804d25
  801a17:	ff 75 0c             	pushl  0xc(%ebp)
  801a1a:	ff 75 08             	pushl  0x8(%ebp)
  801a1d:	e8 5e 02 00 00       	call   801c80 <printfmt>
  801a22:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801a25:	e9 49 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801a2a:	56                   	push   %esi
  801a2b:	68 2e 4d 80 00       	push   $0x804d2e
  801a30:	ff 75 0c             	pushl  0xc(%ebp)
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	e8 45 02 00 00       	call   801c80 <printfmt>
  801a3b:	83 c4 10             	add    $0x10,%esp
			break;
  801a3e:	e9 30 02 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  801a43:	8b 45 14             	mov    0x14(%ebp),%eax
  801a46:	83 c0 04             	add    $0x4,%eax
  801a49:	89 45 14             	mov    %eax,0x14(%ebp)
  801a4c:	8b 45 14             	mov    0x14(%ebp),%eax
  801a4f:	83 e8 04             	sub    $0x4,%eax
  801a52:	8b 30                	mov    (%eax),%esi
  801a54:	85 f6                	test   %esi,%esi
  801a56:	75 05                	jne    801a5d <vprintfmt+0x1a6>
				p = "(null)";
  801a58:	be 31 4d 80 00       	mov    $0x804d31,%esi
			if (width > 0 && padc != '-')
  801a5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a61:	7e 6d                	jle    801ad0 <vprintfmt+0x219>
  801a63:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  801a67:	74 67                	je     801ad0 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  801a69:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a6c:	83 ec 08             	sub    $0x8,%esp
  801a6f:	50                   	push   %eax
  801a70:	56                   	push   %esi
  801a71:	e8 0c 03 00 00       	call   801d82 <strnlen>
  801a76:	83 c4 10             	add    $0x10,%esp
  801a79:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  801a7c:	eb 16                	jmp    801a94 <vprintfmt+0x1dd>
					putch(padc, putdat);
  801a7e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  801a82:	83 ec 08             	sub    $0x8,%esp
  801a85:	ff 75 0c             	pushl  0xc(%ebp)
  801a88:	50                   	push   %eax
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	ff d0                	call   *%eax
  801a8e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801a91:	ff 4d e4             	decl   -0x1c(%ebp)
  801a94:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801a98:	7f e4                	jg     801a7e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801a9a:	eb 34                	jmp    801ad0 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801a9c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801aa0:	74 1c                	je     801abe <vprintfmt+0x207>
  801aa2:	83 fb 1f             	cmp    $0x1f,%ebx
  801aa5:	7e 05                	jle    801aac <vprintfmt+0x1f5>
  801aa7:	83 fb 7e             	cmp    $0x7e,%ebx
  801aaa:	7e 12                	jle    801abe <vprintfmt+0x207>
					putch('?', putdat);
  801aac:	83 ec 08             	sub    $0x8,%esp
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	6a 3f                	push   $0x3f
  801ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab7:	ff d0                	call   *%eax
  801ab9:	83 c4 10             	add    $0x10,%esp
  801abc:	eb 0f                	jmp    801acd <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801abe:	83 ec 08             	sub    $0x8,%esp
  801ac1:	ff 75 0c             	pushl  0xc(%ebp)
  801ac4:	53                   	push   %ebx
  801ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac8:	ff d0                	call   *%eax
  801aca:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801acd:	ff 4d e4             	decl   -0x1c(%ebp)
  801ad0:	89 f0                	mov    %esi,%eax
  801ad2:	8d 70 01             	lea    0x1(%eax),%esi
  801ad5:	8a 00                	mov    (%eax),%al
  801ad7:	0f be d8             	movsbl %al,%ebx
  801ada:	85 db                	test   %ebx,%ebx
  801adc:	74 24                	je     801b02 <vprintfmt+0x24b>
  801ade:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ae2:	78 b8                	js     801a9c <vprintfmt+0x1e5>
  801ae4:	ff 4d e0             	decl   -0x20(%ebp)
  801ae7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801aeb:	79 af                	jns    801a9c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801aed:	eb 13                	jmp    801b02 <vprintfmt+0x24b>
				putch(' ', putdat);
  801aef:	83 ec 08             	sub    $0x8,%esp
  801af2:	ff 75 0c             	pushl  0xc(%ebp)
  801af5:	6a 20                	push   $0x20
  801af7:	8b 45 08             	mov    0x8(%ebp),%eax
  801afa:	ff d0                	call   *%eax
  801afc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801aff:	ff 4d e4             	decl   -0x1c(%ebp)
  801b02:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b06:	7f e7                	jg     801aef <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801b08:	e9 66 01 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801b0d:	83 ec 08             	sub    $0x8,%esp
  801b10:	ff 75 e8             	pushl  -0x18(%ebp)
  801b13:	8d 45 14             	lea    0x14(%ebp),%eax
  801b16:	50                   	push   %eax
  801b17:	e8 3c fd ff ff       	call   801858 <getint>
  801b1c:	83 c4 10             	add    $0x10,%esp
  801b1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b22:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801b25:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b28:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b2b:	85 d2                	test   %edx,%edx
  801b2d:	79 23                	jns    801b52 <vprintfmt+0x29b>
				putch('-', putdat);
  801b2f:	83 ec 08             	sub    $0x8,%esp
  801b32:	ff 75 0c             	pushl  0xc(%ebp)
  801b35:	6a 2d                	push   $0x2d
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	ff d0                	call   *%eax
  801b3c:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  801b3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b42:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801b45:	f7 d8                	neg    %eax
  801b47:	83 d2 00             	adc    $0x0,%edx
  801b4a:	f7 da                	neg    %edx
  801b4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b4f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  801b52:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b59:	e9 bc 00 00 00       	jmp    801c1a <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  801b5e:	83 ec 08             	sub    $0x8,%esp
  801b61:	ff 75 e8             	pushl  -0x18(%ebp)
  801b64:	8d 45 14             	lea    0x14(%ebp),%eax
  801b67:	50                   	push   %eax
  801b68:	e8 84 fc ff ff       	call   8017f1 <getuint>
  801b6d:	83 c4 10             	add    $0x10,%esp
  801b70:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801b73:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  801b76:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  801b7d:	e9 98 00 00 00       	jmp    801c1a <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  801b82:	83 ec 08             	sub    $0x8,%esp
  801b85:	ff 75 0c             	pushl  0xc(%ebp)
  801b88:	6a 58                	push   $0x58
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	ff d0                	call   *%eax
  801b8f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801b92:	83 ec 08             	sub    $0x8,%esp
  801b95:	ff 75 0c             	pushl  0xc(%ebp)
  801b98:	6a 58                	push   $0x58
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	ff d0                	call   *%eax
  801b9f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801ba2:	83 ec 08             	sub    $0x8,%esp
  801ba5:	ff 75 0c             	pushl  0xc(%ebp)
  801ba8:	6a 58                	push   $0x58
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	ff d0                	call   *%eax
  801baf:	83 c4 10             	add    $0x10,%esp
			break;
  801bb2:	e9 bc 00 00 00       	jmp    801c73 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801bb7:	83 ec 08             	sub    $0x8,%esp
  801bba:	ff 75 0c             	pushl  0xc(%ebp)
  801bbd:	6a 30                	push   $0x30
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	ff d0                	call   *%eax
  801bc4:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801bc7:	83 ec 08             	sub    $0x8,%esp
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	6a 78                	push   $0x78
  801bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd2:	ff d0                	call   *%eax
  801bd4:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801bd7:	8b 45 14             	mov    0x14(%ebp),%eax
  801bda:	83 c0 04             	add    $0x4,%eax
  801bdd:	89 45 14             	mov    %eax,0x14(%ebp)
  801be0:	8b 45 14             	mov    0x14(%ebp),%eax
  801be3:	83 e8 04             	sub    $0x4,%eax
  801be6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801be8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801beb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801bf2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801bf9:	eb 1f                	jmp    801c1a <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801bfb:	83 ec 08             	sub    $0x8,%esp
  801bfe:	ff 75 e8             	pushl  -0x18(%ebp)
  801c01:	8d 45 14             	lea    0x14(%ebp),%eax
  801c04:	50                   	push   %eax
  801c05:	e8 e7 fb ff ff       	call   8017f1 <getuint>
  801c0a:	83 c4 10             	add    $0x10,%esp
  801c0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801c10:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801c13:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801c1a:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801c1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c21:	83 ec 04             	sub    $0x4,%esp
  801c24:	52                   	push   %edx
  801c25:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c28:	50                   	push   %eax
  801c29:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2c:	ff 75 f0             	pushl  -0x10(%ebp)
  801c2f:	ff 75 0c             	pushl  0xc(%ebp)
  801c32:	ff 75 08             	pushl  0x8(%ebp)
  801c35:	e8 00 fb ff ff       	call   80173a <printnum>
  801c3a:	83 c4 20             	add    $0x20,%esp
			break;
  801c3d:	eb 34                	jmp    801c73 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  801c3f:	83 ec 08             	sub    $0x8,%esp
  801c42:	ff 75 0c             	pushl  0xc(%ebp)
  801c45:	53                   	push   %ebx
  801c46:	8b 45 08             	mov    0x8(%ebp),%eax
  801c49:	ff d0                	call   *%eax
  801c4b:	83 c4 10             	add    $0x10,%esp
			break;
  801c4e:	eb 23                	jmp    801c73 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  801c50:	83 ec 08             	sub    $0x8,%esp
  801c53:	ff 75 0c             	pushl  0xc(%ebp)
  801c56:	6a 25                	push   $0x25
  801c58:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5b:	ff d0                	call   *%eax
  801c5d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  801c60:	ff 4d 10             	decl   0x10(%ebp)
  801c63:	eb 03                	jmp    801c68 <vprintfmt+0x3b1>
  801c65:	ff 4d 10             	decl   0x10(%ebp)
  801c68:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6b:	48                   	dec    %eax
  801c6c:	8a 00                	mov    (%eax),%al
  801c6e:	3c 25                	cmp    $0x25,%al
  801c70:	75 f3                	jne    801c65 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  801c72:	90                   	nop
		}
	}
  801c73:	e9 47 fc ff ff       	jmp    8018bf <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  801c78:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  801c79:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801c7c:	5b                   	pop    %ebx
  801c7d:	5e                   	pop    %esi
  801c7e:	5d                   	pop    %ebp
  801c7f:	c3                   	ret    

00801c80 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  801c80:	55                   	push   %ebp
  801c81:	89 e5                	mov    %esp,%ebp
  801c83:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  801c86:	8d 45 10             	lea    0x10(%ebp),%eax
  801c89:	83 c0 04             	add    $0x4,%eax
  801c8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801c8f:	8b 45 10             	mov    0x10(%ebp),%eax
  801c92:	ff 75 f4             	pushl  -0xc(%ebp)
  801c95:	50                   	push   %eax
  801c96:	ff 75 0c             	pushl  0xc(%ebp)
  801c99:	ff 75 08             	pushl  0x8(%ebp)
  801c9c:	e8 16 fc ff ff       	call   8018b7 <vprintfmt>
  801ca1:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801ca4:	90                   	nop
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cad:	8b 40 08             	mov    0x8(%eax),%eax
  801cb0:	8d 50 01             	lea    0x1(%eax),%edx
  801cb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cb6:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801cb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cbc:	8b 10                	mov    (%eax),%edx
  801cbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cc1:	8b 40 04             	mov    0x4(%eax),%eax
  801cc4:	39 c2                	cmp    %eax,%edx
  801cc6:	73 12                	jae    801cda <sprintputch+0x33>
		*b->buf++ = ch;
  801cc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ccb:	8b 00                	mov    (%eax),%eax
  801ccd:	8d 48 01             	lea    0x1(%eax),%ecx
  801cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd3:	89 0a                	mov    %ecx,(%edx)
  801cd5:	8b 55 08             	mov    0x8(%ebp),%edx
  801cd8:	88 10                	mov    %dl,(%eax)
}
  801cda:	90                   	nop
  801cdb:	5d                   	pop    %ebp
  801cdc:	c3                   	ret    

00801cdd <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801cdd:	55                   	push   %ebp
  801cde:	89 e5                	mov    %esp,%ebp
  801ce0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ce6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ce9:	8b 45 0c             	mov    0xc(%ebp),%eax
  801cec:	8d 50 ff             	lea    -0x1(%eax),%edx
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	01 d0                	add    %edx,%eax
  801cf4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801cf7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801cfe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d02:	74 06                	je     801d0a <vsnprintf+0x2d>
  801d04:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d08:	7f 07                	jg     801d11 <vsnprintf+0x34>
		return -E_INVAL;
  801d0a:	b8 03 00 00 00       	mov    $0x3,%eax
  801d0f:	eb 20                	jmp    801d31 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801d11:	ff 75 14             	pushl  0x14(%ebp)
  801d14:	ff 75 10             	pushl  0x10(%ebp)
  801d17:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801d1a:	50                   	push   %eax
  801d1b:	68 a7 1c 80 00       	push   $0x801ca7
  801d20:	e8 92 fb ff ff       	call   8018b7 <vprintfmt>
  801d25:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801d28:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d2b:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801d2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801d31:	c9                   	leave  
  801d32:	c3                   	ret    

00801d33 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801d33:	55                   	push   %ebp
  801d34:	89 e5                	mov    %esp,%ebp
  801d36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801d39:	8d 45 10             	lea    0x10(%ebp),%eax
  801d3c:	83 c0 04             	add    $0x4,%eax
  801d3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801d42:	8b 45 10             	mov    0x10(%ebp),%eax
  801d45:	ff 75 f4             	pushl  -0xc(%ebp)
  801d48:	50                   	push   %eax
  801d49:	ff 75 0c             	pushl  0xc(%ebp)
  801d4c:	ff 75 08             	pushl  0x8(%ebp)
  801d4f:	e8 89 ff ff ff       	call   801cdd <vsnprintf>
  801d54:	83 c4 10             	add    $0x10,%esp
  801d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801d5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d5d:	c9                   	leave  
  801d5e:	c3                   	ret    

00801d5f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801d5f:	55                   	push   %ebp
  801d60:	89 e5                	mov    %esp,%ebp
  801d62:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801d65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d6c:	eb 06                	jmp    801d74 <strlen+0x15>
		n++;
  801d6e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801d71:	ff 45 08             	incl   0x8(%ebp)
  801d74:	8b 45 08             	mov    0x8(%ebp),%eax
  801d77:	8a 00                	mov    (%eax),%al
  801d79:	84 c0                	test   %al,%al
  801d7b:	75 f1                	jne    801d6e <strlen+0xf>
		n++;
	return n;
  801d7d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
  801d85:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801d8f:	eb 09                	jmp    801d9a <strnlen+0x18>
		n++;
  801d91:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801d94:	ff 45 08             	incl   0x8(%ebp)
  801d97:	ff 4d 0c             	decl   0xc(%ebp)
  801d9a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d9e:	74 09                	je     801da9 <strnlen+0x27>
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	8a 00                	mov    (%eax),%al
  801da5:	84 c0                	test   %al,%al
  801da7:	75 e8                	jne    801d91 <strnlen+0xf>
		n++;
	return n;
  801da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dac:	c9                   	leave  
  801dad:	c3                   	ret    

00801dae <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801dae:	55                   	push   %ebp
  801daf:	89 e5                	mov    %esp,%ebp
  801db1:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801db4:	8b 45 08             	mov    0x8(%ebp),%eax
  801db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801dba:	90                   	nop
  801dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dbe:	8d 50 01             	lea    0x1(%eax),%edx
  801dc1:	89 55 08             	mov    %edx,0x8(%ebp)
  801dc4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc7:	8d 4a 01             	lea    0x1(%edx),%ecx
  801dca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801dcd:	8a 12                	mov    (%edx),%dl
  801dcf:	88 10                	mov    %dl,(%eax)
  801dd1:	8a 00                	mov    (%eax),%al
  801dd3:	84 c0                	test   %al,%al
  801dd5:	75 e4                	jne    801dbb <strcpy+0xd>
		/* do nothing */;
	return ret;
  801dd7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801dda:	c9                   	leave  
  801ddb:	c3                   	ret    

00801ddc <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801ddc:	55                   	push   %ebp
  801ddd:	89 e5                	mov    %esp,%ebp
  801ddf:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801de2:	8b 45 08             	mov    0x8(%ebp),%eax
  801de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801de8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801def:	eb 1f                	jmp    801e10 <strncpy+0x34>
		*dst++ = *src;
  801df1:	8b 45 08             	mov    0x8(%ebp),%eax
  801df4:	8d 50 01             	lea    0x1(%eax),%edx
  801df7:	89 55 08             	mov    %edx,0x8(%ebp)
  801dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dfd:	8a 12                	mov    (%edx),%dl
  801dff:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801e01:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e04:	8a 00                	mov    (%eax),%al
  801e06:	84 c0                	test   %al,%al
  801e08:	74 03                	je     801e0d <strncpy+0x31>
			src++;
  801e0a:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801e0d:	ff 45 fc             	incl   -0x4(%ebp)
  801e10:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e13:	3b 45 10             	cmp    0x10(%ebp),%eax
  801e16:	72 d9                	jb     801df1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801e18:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
  801e20:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801e23:	8b 45 08             	mov    0x8(%ebp),%eax
  801e26:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801e29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e2d:	74 30                	je     801e5f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801e2f:	eb 16                	jmp    801e47 <strlcpy+0x2a>
			*dst++ = *src++;
  801e31:	8b 45 08             	mov    0x8(%ebp),%eax
  801e34:	8d 50 01             	lea    0x1(%eax),%edx
  801e37:	89 55 08             	mov    %edx,0x8(%ebp)
  801e3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801e40:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801e43:	8a 12                	mov    (%edx),%dl
  801e45:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801e47:	ff 4d 10             	decl   0x10(%ebp)
  801e4a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801e4e:	74 09                	je     801e59 <strlcpy+0x3c>
  801e50:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e53:	8a 00                	mov    (%eax),%al
  801e55:	84 c0                	test   %al,%al
  801e57:	75 d8                	jne    801e31 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801e59:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801e5f:	8b 55 08             	mov    0x8(%ebp),%edx
  801e62:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801e65:	29 c2                	sub    %eax,%edx
  801e67:	89 d0                	mov    %edx,%eax
}
  801e69:	c9                   	leave  
  801e6a:	c3                   	ret    

00801e6b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801e6b:	55                   	push   %ebp
  801e6c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801e6e:	eb 06                	jmp    801e76 <strcmp+0xb>
		p++, q++;
  801e70:	ff 45 08             	incl   0x8(%ebp)
  801e73:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801e76:	8b 45 08             	mov    0x8(%ebp),%eax
  801e79:	8a 00                	mov    (%eax),%al
  801e7b:	84 c0                	test   %al,%al
  801e7d:	74 0e                	je     801e8d <strcmp+0x22>
  801e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e82:	8a 10                	mov    (%eax),%dl
  801e84:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e87:	8a 00                	mov    (%eax),%al
  801e89:	38 c2                	cmp    %al,%dl
  801e8b:	74 e3                	je     801e70 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801e90:	8a 00                	mov    (%eax),%al
  801e92:	0f b6 d0             	movzbl %al,%edx
  801e95:	8b 45 0c             	mov    0xc(%ebp),%eax
  801e98:	8a 00                	mov    (%eax),%al
  801e9a:	0f b6 c0             	movzbl %al,%eax
  801e9d:	29 c2                	sub    %eax,%edx
  801e9f:	89 d0                	mov    %edx,%eax
}
  801ea1:	5d                   	pop    %ebp
  801ea2:	c3                   	ret    

00801ea3 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801ea6:	eb 09                	jmp    801eb1 <strncmp+0xe>
		n--, p++, q++;
  801ea8:	ff 4d 10             	decl   0x10(%ebp)
  801eab:	ff 45 08             	incl   0x8(%ebp)
  801eae:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801eb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801eb5:	74 17                	je     801ece <strncmp+0x2b>
  801eb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eba:	8a 00                	mov    (%eax),%al
  801ebc:	84 c0                	test   %al,%al
  801ebe:	74 0e                	je     801ece <strncmp+0x2b>
  801ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec3:	8a 10                	mov    (%eax),%dl
  801ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ec8:	8a 00                	mov    (%eax),%al
  801eca:	38 c2                	cmp    %al,%dl
  801ecc:	74 da                	je     801ea8 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801ece:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801ed2:	75 07                	jne    801edb <strncmp+0x38>
		return 0;
  801ed4:	b8 00 00 00 00       	mov    $0x0,%eax
  801ed9:	eb 14                	jmp    801eef <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801edb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ede:	8a 00                	mov    (%eax),%al
  801ee0:	0f b6 d0             	movzbl %al,%edx
  801ee3:	8b 45 0c             	mov    0xc(%ebp),%eax
  801ee6:	8a 00                	mov    (%eax),%al
  801ee8:	0f b6 c0             	movzbl %al,%eax
  801eeb:	29 c2                	sub    %eax,%edx
  801eed:	89 d0                	mov    %edx,%eax
}
  801eef:	5d                   	pop    %ebp
  801ef0:	c3                   	ret    

00801ef1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801ef1:	55                   	push   %ebp
  801ef2:	89 e5                	mov    %esp,%ebp
  801ef4:	83 ec 04             	sub    $0x4,%esp
  801ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  801efa:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801efd:	eb 12                	jmp    801f11 <strchr+0x20>
		if (*s == c)
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	8a 00                	mov    (%eax),%al
  801f04:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f07:	75 05                	jne    801f0e <strchr+0x1d>
			return (char *) s;
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	eb 11                	jmp    801f1f <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801f0e:	ff 45 08             	incl   0x8(%ebp)
  801f11:	8b 45 08             	mov    0x8(%ebp),%eax
  801f14:	8a 00                	mov    (%eax),%al
  801f16:	84 c0                	test   %al,%al
  801f18:	75 e5                	jne    801eff <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801f1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f1f:	c9                   	leave  
  801f20:	c3                   	ret    

00801f21 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801f21:	55                   	push   %ebp
  801f22:	89 e5                	mov    %esp,%ebp
  801f24:	83 ec 04             	sub    $0x4,%esp
  801f27:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f2a:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801f2d:	eb 0d                	jmp    801f3c <strfind+0x1b>
		if (*s == c)
  801f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  801f32:	8a 00                	mov    (%eax),%al
  801f34:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801f37:	74 0e                	je     801f47 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801f39:	ff 45 08             	incl   0x8(%ebp)
  801f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3f:	8a 00                	mov    (%eax),%al
  801f41:	84 c0                	test   %al,%al
  801f43:	75 ea                	jne    801f2f <strfind+0xe>
  801f45:	eb 01                	jmp    801f48 <strfind+0x27>
		if (*s == c)
			break;
  801f47:	90                   	nop
	return (char *) s;
  801f48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f4b:	c9                   	leave  
  801f4c:	c3                   	ret    

00801f4d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801f4d:	55                   	push   %ebp
  801f4e:	89 e5                	mov    %esp,%ebp
  801f50:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801f53:	8b 45 08             	mov    0x8(%ebp),%eax
  801f56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801f59:	8b 45 10             	mov    0x10(%ebp),%eax
  801f5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801f5f:	eb 0e                	jmp    801f6f <memset+0x22>
		*p++ = c;
  801f61:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801f64:	8d 50 01             	lea    0x1(%eax),%edx
  801f67:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801f6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f6d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801f6f:	ff 4d f8             	decl   -0x8(%ebp)
  801f72:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801f76:	79 e9                	jns    801f61 <memset+0x14>
		*p++ = c;

	return v;
  801f78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801f7b:	c9                   	leave  
  801f7c:	c3                   	ret    

00801f7d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801f7d:	55                   	push   %ebp
  801f7e:	89 e5                	mov    %esp,%ebp
  801f80:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801f83:	8b 45 0c             	mov    0xc(%ebp),%eax
  801f86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801f89:	8b 45 08             	mov    0x8(%ebp),%eax
  801f8c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801f8f:	eb 16                	jmp    801fa7 <memcpy+0x2a>
		*d++ = *s++;
  801f91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f94:	8d 50 01             	lea    0x1(%eax),%edx
  801f97:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801f9a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f9d:	8d 4a 01             	lea    0x1(%edx),%ecx
  801fa0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801fa3:	8a 12                	mov    (%edx),%dl
  801fa5:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801fa7:	8b 45 10             	mov    0x10(%ebp),%eax
  801faa:	8d 50 ff             	lea    -0x1(%eax),%edx
  801fad:	89 55 10             	mov    %edx,0x10(%ebp)
  801fb0:	85 c0                	test   %eax,%eax
  801fb2:	75 dd                	jne    801f91 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801fb4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801fb7:	c9                   	leave  
  801fb8:	c3                   	ret    

00801fb9 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801fb9:	55                   	push   %ebp
  801fba:	89 e5                	mov    %esp,%ebp
  801fbc:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801fbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  801fc2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fce:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fd1:	73 50                	jae    802023 <memmove+0x6a>
  801fd3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801fd6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fd9:	01 d0                	add    %edx,%eax
  801fdb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801fde:	76 43                	jbe    802023 <memmove+0x6a>
		s += n;
  801fe0:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801fe6:	8b 45 10             	mov    0x10(%ebp),%eax
  801fe9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801fec:	eb 10                	jmp    801ffe <memmove+0x45>
			*--d = *--s;
  801fee:	ff 4d f8             	decl   -0x8(%ebp)
  801ff1:	ff 4d fc             	decl   -0x4(%ebp)
  801ff4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ff7:	8a 10                	mov    (%eax),%dl
  801ff9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801ffc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801ffe:	8b 45 10             	mov    0x10(%ebp),%eax
  802001:	8d 50 ff             	lea    -0x1(%eax),%edx
  802004:	89 55 10             	mov    %edx,0x10(%ebp)
  802007:	85 c0                	test   %eax,%eax
  802009:	75 e3                	jne    801fee <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80200b:	eb 23                	jmp    802030 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80200d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802010:	8d 50 01             	lea    0x1(%eax),%edx
  802013:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802016:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802019:	8d 4a 01             	lea    0x1(%edx),%ecx
  80201c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80201f:	8a 12                	mov    (%edx),%dl
  802021:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  802023:	8b 45 10             	mov    0x10(%ebp),%eax
  802026:	8d 50 ff             	lea    -0x1(%eax),%edx
  802029:	89 55 10             	mov    %edx,0x10(%ebp)
  80202c:	85 c0                	test   %eax,%eax
  80202e:	75 dd                	jne    80200d <memmove+0x54>
			*d++ = *s++;

	return dst;
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
}
  802033:	c9                   	leave  
  802034:	c3                   	ret    

00802035 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  802035:	55                   	push   %ebp
  802036:	89 e5                	mov    %esp,%ebp
  802038:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80203b:	8b 45 08             	mov    0x8(%ebp),%eax
  80203e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  802041:	8b 45 0c             	mov    0xc(%ebp),%eax
  802044:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  802047:	eb 2a                	jmp    802073 <memcmp+0x3e>
		if (*s1 != *s2)
  802049:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80204c:	8a 10                	mov    (%eax),%dl
  80204e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802051:	8a 00                	mov    (%eax),%al
  802053:	38 c2                	cmp    %al,%dl
  802055:	74 16                	je     80206d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  802057:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80205a:	8a 00                	mov    (%eax),%al
  80205c:	0f b6 d0             	movzbl %al,%edx
  80205f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802062:	8a 00                	mov    (%eax),%al
  802064:	0f b6 c0             	movzbl %al,%eax
  802067:	29 c2                	sub    %eax,%edx
  802069:	89 d0                	mov    %edx,%eax
  80206b:	eb 18                	jmp    802085 <memcmp+0x50>
		s1++, s2++;
  80206d:	ff 45 fc             	incl   -0x4(%ebp)
  802070:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  802073:	8b 45 10             	mov    0x10(%ebp),%eax
  802076:	8d 50 ff             	lea    -0x1(%eax),%edx
  802079:	89 55 10             	mov    %edx,0x10(%ebp)
  80207c:	85 c0                	test   %eax,%eax
  80207e:	75 c9                	jne    802049 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  802080:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802085:	c9                   	leave  
  802086:	c3                   	ret    

00802087 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  802087:	55                   	push   %ebp
  802088:	89 e5                	mov    %esp,%ebp
  80208a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80208d:	8b 55 08             	mov    0x8(%ebp),%edx
  802090:	8b 45 10             	mov    0x10(%ebp),%eax
  802093:	01 d0                	add    %edx,%eax
  802095:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  802098:	eb 15                	jmp    8020af <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80209a:	8b 45 08             	mov    0x8(%ebp),%eax
  80209d:	8a 00                	mov    (%eax),%al
  80209f:	0f b6 d0             	movzbl %al,%edx
  8020a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8020a5:	0f b6 c0             	movzbl %al,%eax
  8020a8:	39 c2                	cmp    %eax,%edx
  8020aa:	74 0d                	je     8020b9 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8020ac:	ff 45 08             	incl   0x8(%ebp)
  8020af:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b2:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8020b5:	72 e3                	jb     80209a <memfind+0x13>
  8020b7:	eb 01                	jmp    8020ba <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8020b9:	90                   	nop
	return (void *) s;
  8020ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8020bd:	c9                   	leave  
  8020be:	c3                   	ret    

008020bf <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8020bf:	55                   	push   %ebp
  8020c0:	89 e5                	mov    %esp,%ebp
  8020c2:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8020c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8020cc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020d3:	eb 03                	jmp    8020d8 <strtol+0x19>
		s++;
  8020d5:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8020d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020db:	8a 00                	mov    (%eax),%al
  8020dd:	3c 20                	cmp    $0x20,%al
  8020df:	74 f4                	je     8020d5 <strtol+0x16>
  8020e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e4:	8a 00                	mov    (%eax),%al
  8020e6:	3c 09                	cmp    $0x9,%al
  8020e8:	74 eb                	je     8020d5 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8020ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ed:	8a 00                	mov    (%eax),%al
  8020ef:	3c 2b                	cmp    $0x2b,%al
  8020f1:	75 05                	jne    8020f8 <strtol+0x39>
		s++;
  8020f3:	ff 45 08             	incl   0x8(%ebp)
  8020f6:	eb 13                	jmp    80210b <strtol+0x4c>
	else if (*s == '-')
  8020f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020fb:	8a 00                	mov    (%eax),%al
  8020fd:	3c 2d                	cmp    $0x2d,%al
  8020ff:	75 0a                	jne    80210b <strtol+0x4c>
		s++, neg = 1;
  802101:	ff 45 08             	incl   0x8(%ebp)
  802104:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80210b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80210f:	74 06                	je     802117 <strtol+0x58>
  802111:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  802115:	75 20                	jne    802137 <strtol+0x78>
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	8a 00                	mov    (%eax),%al
  80211c:	3c 30                	cmp    $0x30,%al
  80211e:	75 17                	jne    802137 <strtol+0x78>
  802120:	8b 45 08             	mov    0x8(%ebp),%eax
  802123:	40                   	inc    %eax
  802124:	8a 00                	mov    (%eax),%al
  802126:	3c 78                	cmp    $0x78,%al
  802128:	75 0d                	jne    802137 <strtol+0x78>
		s += 2, base = 16;
  80212a:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80212e:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  802135:	eb 28                	jmp    80215f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  802137:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80213b:	75 15                	jne    802152 <strtol+0x93>
  80213d:	8b 45 08             	mov    0x8(%ebp),%eax
  802140:	8a 00                	mov    (%eax),%al
  802142:	3c 30                	cmp    $0x30,%al
  802144:	75 0c                	jne    802152 <strtol+0x93>
		s++, base = 8;
  802146:	ff 45 08             	incl   0x8(%ebp)
  802149:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  802150:	eb 0d                	jmp    80215f <strtol+0xa0>
	else if (base == 0)
  802152:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  802156:	75 07                	jne    80215f <strtol+0xa0>
		base = 10;
  802158:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	8a 00                	mov    (%eax),%al
  802164:	3c 2f                	cmp    $0x2f,%al
  802166:	7e 19                	jle    802181 <strtol+0xc2>
  802168:	8b 45 08             	mov    0x8(%ebp),%eax
  80216b:	8a 00                	mov    (%eax),%al
  80216d:	3c 39                	cmp    $0x39,%al
  80216f:	7f 10                	jg     802181 <strtol+0xc2>
			dig = *s - '0';
  802171:	8b 45 08             	mov    0x8(%ebp),%eax
  802174:	8a 00                	mov    (%eax),%al
  802176:	0f be c0             	movsbl %al,%eax
  802179:	83 e8 30             	sub    $0x30,%eax
  80217c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80217f:	eb 42                	jmp    8021c3 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	8a 00                	mov    (%eax),%al
  802186:	3c 60                	cmp    $0x60,%al
  802188:	7e 19                	jle    8021a3 <strtol+0xe4>
  80218a:	8b 45 08             	mov    0x8(%ebp),%eax
  80218d:	8a 00                	mov    (%eax),%al
  80218f:	3c 7a                	cmp    $0x7a,%al
  802191:	7f 10                	jg     8021a3 <strtol+0xe4>
			dig = *s - 'a' + 10;
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	8a 00                	mov    (%eax),%al
  802198:	0f be c0             	movsbl %al,%eax
  80219b:	83 e8 57             	sub    $0x57,%eax
  80219e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8021a1:	eb 20                	jmp    8021c3 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8021a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a6:	8a 00                	mov    (%eax),%al
  8021a8:	3c 40                	cmp    $0x40,%al
  8021aa:	7e 39                	jle    8021e5 <strtol+0x126>
  8021ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8021af:	8a 00                	mov    (%eax),%al
  8021b1:	3c 5a                	cmp    $0x5a,%al
  8021b3:	7f 30                	jg     8021e5 <strtol+0x126>
			dig = *s - 'A' + 10;
  8021b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b8:	8a 00                	mov    (%eax),%al
  8021ba:	0f be c0             	movsbl %al,%eax
  8021bd:	83 e8 37             	sub    $0x37,%eax
  8021c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8021c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c6:	3b 45 10             	cmp    0x10(%ebp),%eax
  8021c9:	7d 19                	jge    8021e4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8021cb:	ff 45 08             	incl   0x8(%ebp)
  8021ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021d1:	0f af 45 10          	imul   0x10(%ebp),%eax
  8021d5:	89 c2                	mov    %eax,%edx
  8021d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021da:	01 d0                	add    %edx,%eax
  8021dc:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8021df:	e9 7b ff ff ff       	jmp    80215f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8021e4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8021e5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8021e9:	74 08                	je     8021f3 <strtol+0x134>
		*endptr = (char *) s;
  8021eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8021ee:	8b 55 08             	mov    0x8(%ebp),%edx
  8021f1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8021f3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021f7:	74 07                	je     802200 <strtol+0x141>
  8021f9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021fc:	f7 d8                	neg    %eax
  8021fe:	eb 03                	jmp    802203 <strtol+0x144>
  802200:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  802203:	c9                   	leave  
  802204:	c3                   	ret    

00802205 <ltostr>:

void
ltostr(long value, char *str)
{
  802205:	55                   	push   %ebp
  802206:	89 e5                	mov    %esp,%ebp
  802208:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80220b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  802212:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  802219:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80221d:	79 13                	jns    802232 <ltostr+0x2d>
	{
		neg = 1;
  80221f:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  802226:	8b 45 0c             	mov    0xc(%ebp),%eax
  802229:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80222c:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80222f:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80223a:	99                   	cltd   
  80223b:	f7 f9                	idiv   %ecx
  80223d:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  802240:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802243:	8d 50 01             	lea    0x1(%eax),%edx
  802246:	89 55 f8             	mov    %edx,-0x8(%ebp)
  802249:	89 c2                	mov    %eax,%edx
  80224b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80224e:	01 d0                	add    %edx,%eax
  802250:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802253:	83 c2 30             	add    $0x30,%edx
  802256:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  802258:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80225b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802260:	f7 e9                	imul   %ecx
  802262:	c1 fa 02             	sar    $0x2,%edx
  802265:	89 c8                	mov    %ecx,%eax
  802267:	c1 f8 1f             	sar    $0x1f,%eax
  80226a:	29 c2                	sub    %eax,%edx
  80226c:	89 d0                	mov    %edx,%eax
  80226e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  802271:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802274:	b8 67 66 66 66       	mov    $0x66666667,%eax
  802279:	f7 e9                	imul   %ecx
  80227b:	c1 fa 02             	sar    $0x2,%edx
  80227e:	89 c8                	mov    %ecx,%eax
  802280:	c1 f8 1f             	sar    $0x1f,%eax
  802283:	29 c2                	sub    %eax,%edx
  802285:	89 d0                	mov    %edx,%eax
  802287:	c1 e0 02             	shl    $0x2,%eax
  80228a:	01 d0                	add    %edx,%eax
  80228c:	01 c0                	add    %eax,%eax
  80228e:	29 c1                	sub    %eax,%ecx
  802290:	89 ca                	mov    %ecx,%edx
  802292:	85 d2                	test   %edx,%edx
  802294:	75 9c                	jne    802232 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  802296:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80229d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8022a0:	48                   	dec    %eax
  8022a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8022a4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022a8:	74 3d                	je     8022e7 <ltostr+0xe2>
		start = 1 ;
  8022aa:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8022b1:	eb 34                	jmp    8022e7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8022b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022b9:	01 d0                	add    %edx,%eax
  8022bb:	8a 00                	mov    (%eax),%al
  8022bd:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8022c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022c6:	01 c2                	add    %eax,%edx
  8022c8:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8022cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022ce:	01 c8                	add    %ecx,%eax
  8022d0:	8a 00                	mov    (%eax),%al
  8022d2:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8022d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8022d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022da:	01 c2                	add    %eax,%edx
  8022dc:	8a 45 eb             	mov    -0x15(%ebp),%al
  8022df:	88 02                	mov    %al,(%edx)
		start++ ;
  8022e1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8022e4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8022e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ea:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8022ed:	7c c4                	jl     8022b3 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8022ef:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8022f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8022f5:	01 d0                	add    %edx,%eax
  8022f7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8022fa:	90                   	nop
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  802303:	ff 75 08             	pushl  0x8(%ebp)
  802306:	e8 54 fa ff ff       	call   801d5f <strlen>
  80230b:	83 c4 04             	add    $0x4,%esp
  80230e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  802311:	ff 75 0c             	pushl  0xc(%ebp)
  802314:	e8 46 fa ff ff       	call   801d5f <strlen>
  802319:	83 c4 04             	add    $0x4,%esp
  80231c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80231f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  802326:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80232d:	eb 17                	jmp    802346 <strcconcat+0x49>
		final[s] = str1[s] ;
  80232f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802332:	8b 45 10             	mov    0x10(%ebp),%eax
  802335:	01 c2                	add    %eax,%edx
  802337:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	01 c8                	add    %ecx,%eax
  80233f:	8a 00                	mov    (%eax),%al
  802341:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  802343:	ff 45 fc             	incl   -0x4(%ebp)
  802346:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802349:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80234c:	7c e1                	jl     80232f <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80234e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  802355:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80235c:	eb 1f                	jmp    80237d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80235e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802361:	8d 50 01             	lea    0x1(%eax),%edx
  802364:	89 55 fc             	mov    %edx,-0x4(%ebp)
  802367:	89 c2                	mov    %eax,%edx
  802369:	8b 45 10             	mov    0x10(%ebp),%eax
  80236c:	01 c2                	add    %eax,%edx
  80236e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  802371:	8b 45 0c             	mov    0xc(%ebp),%eax
  802374:	01 c8                	add    %ecx,%eax
  802376:	8a 00                	mov    (%eax),%al
  802378:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80237a:	ff 45 f8             	incl   -0x8(%ebp)
  80237d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802380:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802383:	7c d9                	jl     80235e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  802385:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802388:	8b 45 10             	mov    0x10(%ebp),%eax
  80238b:	01 d0                	add    %edx,%eax
  80238d:	c6 00 00             	movb   $0x0,(%eax)
}
  802390:	90                   	nop
  802391:	c9                   	leave  
  802392:	c3                   	ret    

00802393 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  802393:	55                   	push   %ebp
  802394:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  802396:	8b 45 14             	mov    0x14(%ebp),%eax
  802399:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80239f:	8b 45 14             	mov    0x14(%ebp),%eax
  8023a2:	8b 00                	mov    (%eax),%eax
  8023a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8023ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8023ae:	01 d0                	add    %edx,%eax
  8023b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023b6:	eb 0c                	jmp    8023c4 <strsplit+0x31>
			*string++ = 0;
  8023b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bb:	8d 50 01             	lea    0x1(%eax),%edx
  8023be:	89 55 08             	mov    %edx,0x8(%ebp)
  8023c1:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8023c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c7:	8a 00                	mov    (%eax),%al
  8023c9:	84 c0                	test   %al,%al
  8023cb:	74 18                	je     8023e5 <strsplit+0x52>
  8023cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d0:	8a 00                	mov    (%eax),%al
  8023d2:	0f be c0             	movsbl %al,%eax
  8023d5:	50                   	push   %eax
  8023d6:	ff 75 0c             	pushl  0xc(%ebp)
  8023d9:	e8 13 fb ff ff       	call   801ef1 <strchr>
  8023de:	83 c4 08             	add    $0x8,%esp
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	75 d3                	jne    8023b8 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8023e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e8:	8a 00                	mov    (%eax),%al
  8023ea:	84 c0                	test   %al,%al
  8023ec:	74 5a                	je     802448 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8023ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8023f1:	8b 00                	mov    (%eax),%eax
  8023f3:	83 f8 0f             	cmp    $0xf,%eax
  8023f6:	75 07                	jne    8023ff <strsplit+0x6c>
		{
			return 0;
  8023f8:	b8 00 00 00 00       	mov    $0x0,%eax
  8023fd:	eb 66                	jmp    802465 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8023ff:	8b 45 14             	mov    0x14(%ebp),%eax
  802402:	8b 00                	mov    (%eax),%eax
  802404:	8d 48 01             	lea    0x1(%eax),%ecx
  802407:	8b 55 14             	mov    0x14(%ebp),%edx
  80240a:	89 0a                	mov    %ecx,(%edx)
  80240c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802413:	8b 45 10             	mov    0x10(%ebp),%eax
  802416:	01 c2                	add    %eax,%edx
  802418:	8b 45 08             	mov    0x8(%ebp),%eax
  80241b:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80241d:	eb 03                	jmp    802422 <strsplit+0x8f>
			string++;
  80241f:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  802422:	8b 45 08             	mov    0x8(%ebp),%eax
  802425:	8a 00                	mov    (%eax),%al
  802427:	84 c0                	test   %al,%al
  802429:	74 8b                	je     8023b6 <strsplit+0x23>
  80242b:	8b 45 08             	mov    0x8(%ebp),%eax
  80242e:	8a 00                	mov    (%eax),%al
  802430:	0f be c0             	movsbl %al,%eax
  802433:	50                   	push   %eax
  802434:	ff 75 0c             	pushl  0xc(%ebp)
  802437:	e8 b5 fa ff ff       	call   801ef1 <strchr>
  80243c:	83 c4 08             	add    $0x8,%esp
  80243f:	85 c0                	test   %eax,%eax
  802441:	74 dc                	je     80241f <strsplit+0x8c>
			string++;
	}
  802443:	e9 6e ff ff ff       	jmp    8023b6 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  802448:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  802449:	8b 45 14             	mov    0x14(%ebp),%eax
  80244c:	8b 00                	mov    (%eax),%eax
  80244e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802455:	8b 45 10             	mov    0x10(%ebp),%eax
  802458:	01 d0                	add    %edx,%eax
  80245a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  802460:	b8 01 00 00 00       	mov    $0x1,%eax
}
  802465:	c9                   	leave  
  802466:	c3                   	ret    

00802467 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  802467:	55                   	push   %ebp
  802468:	89 e5                	mov    %esp,%ebp
  80246a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80246d:	a1 04 60 80 00       	mov    0x806004,%eax
  802472:	85 c0                	test   %eax,%eax
  802474:	74 1f                	je     802495 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  802476:	e8 1d 00 00 00       	call   802498 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80247b:	83 ec 0c             	sub    $0xc,%esp
  80247e:	68 90 4e 80 00       	push   $0x804e90
  802483:	e8 55 f2 ff ff       	call   8016dd <cprintf>
  802488:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80248b:	c7 05 04 60 80 00 00 	movl   $0x0,0x806004
  802492:	00 00 00 
	}
}
  802495:	90                   	nop
  802496:	c9                   	leave  
  802497:	c3                   	ret    

00802498 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  802498:	55                   	push   %ebp
  802499:	89 e5                	mov    %esp,%ebp
  80249b:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  80249e:	c7 05 40 60 80 00 00 	movl   $0x0,0x806040
  8024a5:	00 00 00 
  8024a8:	c7 05 44 60 80 00 00 	movl   $0x0,0x806044
  8024af:	00 00 00 
  8024b2:	c7 05 4c 60 80 00 00 	movl   $0x0,0x80604c
  8024b9:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8024bc:	c7 05 38 61 80 00 00 	movl   $0x0,0x806138
  8024c3:	00 00 00 
  8024c6:	c7 05 3c 61 80 00 00 	movl   $0x0,0x80613c
  8024cd:	00 00 00 
  8024d0:	c7 05 44 61 80 00 00 	movl   $0x0,0x806144
  8024d7:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  8024da:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	c1 e8 0c             	shr    $0xc,%eax
  8024e7:	a3 20 61 80 00       	mov    %eax,0x806120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  8024ec:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8024f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8024fb:	2d 00 10 00 00       	sub    $0x1000,%eax
  802500:	a3 50 60 80 00       	mov    %eax,0x806050
		uint32 MEMsize=sizeof(struct MemBlock);
  802505:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  80250c:	a1 20 61 80 00       	mov    0x806120,%eax
  802511:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  802515:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  802518:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80251f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802525:	01 d0                	add    %edx,%eax
  802527:	48                   	dec    %eax
  802528:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80252b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80252e:	ba 00 00 00 00       	mov    $0x0,%edx
  802533:	f7 75 e4             	divl   -0x1c(%ebp)
  802536:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802539:	29 d0                	sub    %edx,%eax
  80253b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  80253e:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  802545:	8b 45 dc             	mov    -0x24(%ebp),%eax
  802548:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80254d:	2d 00 10 00 00       	sub    $0x1000,%eax
  802552:	83 ec 04             	sub    $0x4,%esp
  802555:	6a 07                	push   $0x7
  802557:	ff 75 e8             	pushl  -0x18(%ebp)
  80255a:	50                   	push   %eax
  80255b:	e8 3d 06 00 00       	call   802b9d <sys_allocate_chunk>
  802560:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  802563:	a1 20 61 80 00       	mov    0x806120,%eax
  802568:	83 ec 0c             	sub    $0xc,%esp
  80256b:	50                   	push   %eax
  80256c:	e8 b2 0c 00 00       	call   803223 <initialize_MemBlocksList>
  802571:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  802574:	a1 4c 61 80 00       	mov    0x80614c,%eax
  802579:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  80257c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  802580:	0f 84 f3 00 00 00    	je     802679 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  802586:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80258a:	75 14                	jne    8025a0 <initialize_dyn_block_system+0x108>
  80258c:	83 ec 04             	sub    $0x4,%esp
  80258f:	68 b5 4e 80 00       	push   $0x804eb5
  802594:	6a 36                	push   $0x36
  802596:	68 d3 4e 80 00       	push   $0x804ed3
  80259b:	e8 89 ee ff ff       	call   801429 <_panic>
  8025a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025a3:	8b 00                	mov    (%eax),%eax
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	74 10                	je     8025b9 <initialize_dyn_block_system+0x121>
  8025a9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025ac:	8b 00                	mov    (%eax),%eax
  8025ae:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8025b1:	8b 52 04             	mov    0x4(%edx),%edx
  8025b4:	89 50 04             	mov    %edx,0x4(%eax)
  8025b7:	eb 0b                	jmp    8025c4 <initialize_dyn_block_system+0x12c>
  8025b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025bc:	8b 40 04             	mov    0x4(%eax),%eax
  8025bf:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8025c4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025c7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ca:	85 c0                	test   %eax,%eax
  8025cc:	74 0f                	je     8025dd <initialize_dyn_block_system+0x145>
  8025ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025d1:	8b 40 04             	mov    0x4(%eax),%eax
  8025d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8025d7:	8b 12                	mov    (%edx),%edx
  8025d9:	89 10                	mov    %edx,(%eax)
  8025db:	eb 0a                	jmp    8025e7 <initialize_dyn_block_system+0x14f>
  8025dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025e0:	8b 00                	mov    (%eax),%eax
  8025e2:	a3 48 61 80 00       	mov    %eax,0x806148
  8025e7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8025f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025fa:	a1 54 61 80 00       	mov    0x806154,%eax
  8025ff:	48                   	dec    %eax
  802600:	a3 54 61 80 00       	mov    %eax,0x806154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  802605:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802608:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  80260f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802612:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  802619:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80261d:	75 14                	jne    802633 <initialize_dyn_block_system+0x19b>
  80261f:	83 ec 04             	sub    $0x4,%esp
  802622:	68 e0 4e 80 00       	push   $0x804ee0
  802627:	6a 3e                	push   $0x3e
  802629:	68 d3 4e 80 00       	push   $0x804ed3
  80262e:	e8 f6 ed ff ff       	call   801429 <_panic>
  802633:	8b 15 38 61 80 00    	mov    0x806138,%edx
  802639:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80263c:	89 10                	mov    %edx,(%eax)
  80263e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802641:	8b 00                	mov    (%eax),%eax
  802643:	85 c0                	test   %eax,%eax
  802645:	74 0d                	je     802654 <initialize_dyn_block_system+0x1bc>
  802647:	a1 38 61 80 00       	mov    0x806138,%eax
  80264c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80264f:	89 50 04             	mov    %edx,0x4(%eax)
  802652:	eb 08                	jmp    80265c <initialize_dyn_block_system+0x1c4>
  802654:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802657:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80265c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80265f:	a3 38 61 80 00       	mov    %eax,0x806138
  802664:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802667:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80266e:	a1 44 61 80 00       	mov    0x806144,%eax
  802673:	40                   	inc    %eax
  802674:	a3 44 61 80 00       	mov    %eax,0x806144

				}


}
  802679:	90                   	nop
  80267a:	c9                   	leave  
  80267b:	c3                   	ret    

0080267c <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80267c:	55                   	push   %ebp
  80267d:	89 e5                	mov    %esp,%ebp
  80267f:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  802682:	e8 e0 fd ff ff       	call   802467 <InitializeUHeap>
		if (size == 0) return NULL ;
  802687:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80268b:	75 07                	jne    802694 <malloc+0x18>
  80268d:	b8 00 00 00 00       	mov    $0x0,%eax
  802692:	eb 7f                	jmp    802713 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  802694:	e8 d2 08 00 00       	call   802f6b <sys_isUHeapPlacementStrategyFIRSTFIT>
  802699:	85 c0                	test   %eax,%eax
  80269b:	74 71                	je     80270e <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  80269d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8026a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026aa:	01 d0                	add    %edx,%eax
  8026ac:	48                   	dec    %eax
  8026ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8026b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b3:	ba 00 00 00 00       	mov    $0x0,%edx
  8026b8:	f7 75 f4             	divl   -0xc(%ebp)
  8026bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026be:	29 d0                	sub    %edx,%eax
  8026c0:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  8026c3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  8026ca:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8026d1:	76 07                	jbe    8026da <malloc+0x5e>
					return NULL ;
  8026d3:	b8 00 00 00 00       	mov    $0x0,%eax
  8026d8:	eb 39                	jmp    802713 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  8026da:	83 ec 0c             	sub    $0xc,%esp
  8026dd:	ff 75 08             	pushl  0x8(%ebp)
  8026e0:	e8 e6 0d 00 00       	call   8034cb <alloc_block_FF>
  8026e5:	83 c4 10             	add    $0x10,%esp
  8026e8:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  8026eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026ef:	74 16                	je     802707 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  8026f1:	83 ec 0c             	sub    $0xc,%esp
  8026f4:	ff 75 ec             	pushl  -0x14(%ebp)
  8026f7:	e8 37 0c 00 00       	call   803333 <insert_sorted_allocList>
  8026fc:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  8026ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802702:	8b 40 08             	mov    0x8(%eax),%eax
  802705:	eb 0c                	jmp    802713 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  802707:	b8 00 00 00 00       	mov    $0x0,%eax
  80270c:	eb 05                	jmp    802713 <malloc+0x97>
				}
		}
	return 0;
  80270e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802713:	c9                   	leave  
  802714:	c3                   	ret    

00802715 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  802715:	55                   	push   %ebp
  802716:	89 e5                	mov    %esp,%ebp
  802718:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  802721:	83 ec 08             	sub    $0x8,%esp
  802724:	ff 75 f4             	pushl  -0xc(%ebp)
  802727:	68 40 60 80 00       	push   $0x806040
  80272c:	e8 cf 0b 00 00       	call   803300 <find_block>
  802731:	83 c4 10             	add    $0x10,%esp
  802734:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  802737:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273a:	8b 40 0c             	mov    0xc(%eax),%eax
  80273d:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  802740:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802743:	8b 40 08             	mov    0x8(%eax),%eax
  802746:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  802749:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80274d:	0f 84 a1 00 00 00    	je     8027f4 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  802753:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802757:	75 17                	jne    802770 <free+0x5b>
  802759:	83 ec 04             	sub    $0x4,%esp
  80275c:	68 b5 4e 80 00       	push   $0x804eb5
  802761:	68 80 00 00 00       	push   $0x80
  802766:	68 d3 4e 80 00       	push   $0x804ed3
  80276b:	e8 b9 ec ff ff       	call   801429 <_panic>
  802770:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802773:	8b 00                	mov    (%eax),%eax
  802775:	85 c0                	test   %eax,%eax
  802777:	74 10                	je     802789 <free+0x74>
  802779:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80277c:	8b 00                	mov    (%eax),%eax
  80277e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  802781:	8b 52 04             	mov    0x4(%edx),%edx
  802784:	89 50 04             	mov    %edx,0x4(%eax)
  802787:	eb 0b                	jmp    802794 <free+0x7f>
  802789:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80278c:	8b 40 04             	mov    0x4(%eax),%eax
  80278f:	a3 44 60 80 00       	mov    %eax,0x806044
  802794:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802797:	8b 40 04             	mov    0x4(%eax),%eax
  80279a:	85 c0                	test   %eax,%eax
  80279c:	74 0f                	je     8027ad <free+0x98>
  80279e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a1:	8b 40 04             	mov    0x4(%eax),%eax
  8027a4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8027a7:	8b 12                	mov    (%edx),%edx
  8027a9:	89 10                	mov    %edx,(%eax)
  8027ab:	eb 0a                	jmp    8027b7 <free+0xa2>
  8027ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b0:	8b 00                	mov    (%eax),%eax
  8027b2:	a3 40 60 80 00       	mov    %eax,0x806040
  8027b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027c3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ca:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8027cf:	48                   	dec    %eax
  8027d0:	a3 4c 60 80 00       	mov    %eax,0x80604c
			insert_sorted_with_merge_freeList(block);
  8027d5:	83 ec 0c             	sub    $0xc,%esp
  8027d8:	ff 75 f0             	pushl  -0x10(%ebp)
  8027db:	e8 29 12 00 00       	call   803a09 <insert_sorted_with_merge_freeList>
  8027e0:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  8027e3:	83 ec 08             	sub    $0x8,%esp
  8027e6:	ff 75 ec             	pushl  -0x14(%ebp)
  8027e9:	ff 75 e8             	pushl  -0x18(%ebp)
  8027ec:	e8 74 03 00 00       	call   802b65 <sys_free_user_mem>
  8027f1:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8027f4:	90                   	nop
  8027f5:	c9                   	leave  
  8027f6:	c3                   	ret    

008027f7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  8027f7:	55                   	push   %ebp
  8027f8:	89 e5                	mov    %esp,%ebp
  8027fa:	83 ec 38             	sub    $0x38,%esp
  8027fd:	8b 45 10             	mov    0x10(%ebp),%eax
  802800:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802803:	e8 5f fc ff ff       	call   802467 <InitializeUHeap>
	if (size == 0) return NULL ;
  802808:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80280c:	75 0a                	jne    802818 <smalloc+0x21>
  80280e:	b8 00 00 00 00       	mov    $0x0,%eax
  802813:	e9 b2 00 00 00       	jmp    8028ca <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  802818:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80281f:	76 0a                	jbe    80282b <smalloc+0x34>
		return NULL;
  802821:	b8 00 00 00 00       	mov    $0x0,%eax
  802826:	e9 9f 00 00 00       	jmp    8028ca <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80282b:	e8 3b 07 00 00       	call   802f6b <sys_isUHeapPlacementStrategyFIRSTFIT>
  802830:	85 c0                	test   %eax,%eax
  802832:	0f 84 8d 00 00 00    	je     8028c5 <smalloc+0xce>
	struct MemBlock *b = NULL;
  802838:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  80283f:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  802846:	8b 55 0c             	mov    0xc(%ebp),%edx
  802849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80284c:	01 d0                	add    %edx,%eax
  80284e:	48                   	dec    %eax
  80284f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  802852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802855:	ba 00 00 00 00       	mov    $0x0,%edx
  80285a:	f7 75 f0             	divl   -0x10(%ebp)
  80285d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802860:	29 d0                	sub    %edx,%eax
  802862:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  802865:	83 ec 0c             	sub    $0xc,%esp
  802868:	ff 75 e8             	pushl  -0x18(%ebp)
  80286b:	e8 5b 0c 00 00       	call   8034cb <alloc_block_FF>
  802870:	83 c4 10             	add    $0x10,%esp
  802873:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  802876:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80287a:	75 07                	jne    802883 <smalloc+0x8c>
			return NULL;
  80287c:	b8 00 00 00 00       	mov    $0x0,%eax
  802881:	eb 47                	jmp    8028ca <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  802883:	83 ec 0c             	sub    $0xc,%esp
  802886:	ff 75 f4             	pushl  -0xc(%ebp)
  802889:	e8 a5 0a 00 00       	call   803333 <insert_sorted_allocList>
  80288e:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  802891:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802894:	8b 40 08             	mov    0x8(%eax),%eax
  802897:	89 c2                	mov    %eax,%edx
  802899:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80289d:	52                   	push   %edx
  80289e:	50                   	push   %eax
  80289f:	ff 75 0c             	pushl  0xc(%ebp)
  8028a2:	ff 75 08             	pushl  0x8(%ebp)
  8028a5:	e8 46 04 00 00       	call   802cf0 <sys_createSharedObject>
  8028aa:	83 c4 10             	add    $0x10,%esp
  8028ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  8028b0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8028b4:	78 08                	js     8028be <smalloc+0xc7>
		return (void *)b->sva;
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 40 08             	mov    0x8(%eax),%eax
  8028bc:	eb 0c                	jmp    8028ca <smalloc+0xd3>
		}else{
		return NULL;
  8028be:	b8 00 00 00 00       	mov    $0x0,%eax
  8028c3:	eb 05                	jmp    8028ca <smalloc+0xd3>
			}

	}return NULL;
  8028c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8028ca:	c9                   	leave  
  8028cb:	c3                   	ret    

008028cc <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8028cc:	55                   	push   %ebp
  8028cd:	89 e5                	mov    %esp,%ebp
  8028cf:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8028d2:	e8 90 fb ff ff       	call   802467 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8028d7:	e8 8f 06 00 00       	call   802f6b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8028dc:	85 c0                	test   %eax,%eax
  8028de:	0f 84 ad 00 00 00    	je     802991 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8028e4:	83 ec 08             	sub    $0x8,%esp
  8028e7:	ff 75 0c             	pushl  0xc(%ebp)
  8028ea:	ff 75 08             	pushl  0x8(%ebp)
  8028ed:	e8 28 04 00 00       	call   802d1a <sys_getSizeOfSharedObject>
  8028f2:	83 c4 10             	add    $0x10,%esp
  8028f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  8028f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028fc:	79 0a                	jns    802908 <sget+0x3c>
    {
    	return NULL;
  8028fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802903:	e9 8e 00 00 00       	jmp    802996 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  802908:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  80290f:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802916:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802919:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80291c:	01 d0                	add    %edx,%eax
  80291e:	48                   	dec    %eax
  80291f:	89 45 e8             	mov    %eax,-0x18(%ebp)
  802922:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802925:	ba 00 00 00 00       	mov    $0x0,%edx
  80292a:	f7 75 ec             	divl   -0x14(%ebp)
  80292d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802930:	29 d0                	sub    %edx,%eax
  802932:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  802935:	83 ec 0c             	sub    $0xc,%esp
  802938:	ff 75 e4             	pushl  -0x1c(%ebp)
  80293b:	e8 8b 0b 00 00       	call   8034cb <alloc_block_FF>
  802940:	83 c4 10             	add    $0x10,%esp
  802943:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  802946:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80294a:	75 07                	jne    802953 <sget+0x87>
				return NULL;
  80294c:	b8 00 00 00 00       	mov    $0x0,%eax
  802951:	eb 43                	jmp    802996 <sget+0xca>
			}
			insert_sorted_allocList(b);
  802953:	83 ec 0c             	sub    $0xc,%esp
  802956:	ff 75 f0             	pushl  -0x10(%ebp)
  802959:	e8 d5 09 00 00       	call   803333 <insert_sorted_allocList>
  80295e:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  802961:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802964:	8b 40 08             	mov    0x8(%eax),%eax
  802967:	83 ec 04             	sub    $0x4,%esp
  80296a:	50                   	push   %eax
  80296b:	ff 75 0c             	pushl  0xc(%ebp)
  80296e:	ff 75 08             	pushl  0x8(%ebp)
  802971:	e8 c1 03 00 00       	call   802d37 <sys_getSharedObject>
  802976:	83 c4 10             	add    $0x10,%esp
  802979:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  80297c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  802980:	78 08                	js     80298a <sget+0xbe>
			return (void *)b->sva;
  802982:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802985:	8b 40 08             	mov    0x8(%eax),%eax
  802988:	eb 0c                	jmp    802996 <sget+0xca>
			}else{
			return NULL;
  80298a:	b8 00 00 00 00       	mov    $0x0,%eax
  80298f:	eb 05                	jmp    802996 <sget+0xca>
			}
    }}return NULL;
  802991:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802996:	c9                   	leave  
  802997:	c3                   	ret    

00802998 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802998:	55                   	push   %ebp
  802999:	89 e5                	mov    %esp,%ebp
  80299b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80299e:	e8 c4 fa ff ff       	call   802467 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8029a3:	83 ec 04             	sub    $0x4,%esp
  8029a6:	68 04 4f 80 00       	push   $0x804f04
  8029ab:	68 03 01 00 00       	push   $0x103
  8029b0:	68 d3 4e 80 00       	push   $0x804ed3
  8029b5:	e8 6f ea ff ff       	call   801429 <_panic>

008029ba <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8029ba:	55                   	push   %ebp
  8029bb:	89 e5                	mov    %esp,%ebp
  8029bd:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8029c0:	83 ec 04             	sub    $0x4,%esp
  8029c3:	68 2c 4f 80 00       	push   $0x804f2c
  8029c8:	68 17 01 00 00       	push   $0x117
  8029cd:	68 d3 4e 80 00       	push   $0x804ed3
  8029d2:	e8 52 ea ff ff       	call   801429 <_panic>

008029d7 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8029d7:	55                   	push   %ebp
  8029d8:	89 e5                	mov    %esp,%ebp
  8029da:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8029dd:	83 ec 04             	sub    $0x4,%esp
  8029e0:	68 50 4f 80 00       	push   $0x804f50
  8029e5:	68 22 01 00 00       	push   $0x122
  8029ea:	68 d3 4e 80 00       	push   $0x804ed3
  8029ef:	e8 35 ea ff ff       	call   801429 <_panic>

008029f4 <shrink>:

}
void shrink(uint32 newSize)
{
  8029f4:	55                   	push   %ebp
  8029f5:	89 e5                	mov    %esp,%ebp
  8029f7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8029fa:	83 ec 04             	sub    $0x4,%esp
  8029fd:	68 50 4f 80 00       	push   $0x804f50
  802a02:	68 27 01 00 00       	push   $0x127
  802a07:	68 d3 4e 80 00       	push   $0x804ed3
  802a0c:	e8 18 ea ff ff       	call   801429 <_panic>

00802a11 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802a11:	55                   	push   %ebp
  802a12:	89 e5                	mov    %esp,%ebp
  802a14:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802a17:	83 ec 04             	sub    $0x4,%esp
  802a1a:	68 50 4f 80 00       	push   $0x804f50
  802a1f:	68 2c 01 00 00       	push   $0x12c
  802a24:	68 d3 4e 80 00       	push   $0x804ed3
  802a29:	e8 fb e9 ff ff       	call   801429 <_panic>

00802a2e <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  802a2e:	55                   	push   %ebp
  802a2f:	89 e5                	mov    %esp,%ebp
  802a31:	57                   	push   %edi
  802a32:	56                   	push   %esi
  802a33:	53                   	push   %ebx
  802a34:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802a3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802a40:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802a43:	8b 7d 18             	mov    0x18(%ebp),%edi
  802a46:	8b 75 1c             	mov    0x1c(%ebp),%esi
  802a49:	cd 30                	int    $0x30
  802a4b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  802a4e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  802a51:	83 c4 10             	add    $0x10,%esp
  802a54:	5b                   	pop    %ebx
  802a55:	5e                   	pop    %esi
  802a56:	5f                   	pop    %edi
  802a57:	5d                   	pop    %ebp
  802a58:	c3                   	ret    

00802a59 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  802a59:	55                   	push   %ebp
  802a5a:	89 e5                	mov    %esp,%ebp
  802a5c:	83 ec 04             	sub    $0x4,%esp
  802a5f:	8b 45 10             	mov    0x10(%ebp),%eax
  802a62:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  802a65:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802a69:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6c:	6a 00                	push   $0x0
  802a6e:	6a 00                	push   $0x0
  802a70:	52                   	push   %edx
  802a71:	ff 75 0c             	pushl  0xc(%ebp)
  802a74:	50                   	push   %eax
  802a75:	6a 00                	push   $0x0
  802a77:	e8 b2 ff ff ff       	call   802a2e <syscall>
  802a7c:	83 c4 18             	add    $0x18,%esp
}
  802a7f:	90                   	nop
  802a80:	c9                   	leave  
  802a81:	c3                   	ret    

00802a82 <sys_cgetc>:

int
sys_cgetc(void)
{
  802a82:	55                   	push   %ebp
  802a83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802a85:	6a 00                	push   $0x0
  802a87:	6a 00                	push   $0x0
  802a89:	6a 00                	push   $0x0
  802a8b:	6a 00                	push   $0x0
  802a8d:	6a 00                	push   $0x0
  802a8f:	6a 01                	push   $0x1
  802a91:	e8 98 ff ff ff       	call   802a2e <syscall>
  802a96:	83 c4 18             	add    $0x18,%esp
}
  802a99:	c9                   	leave  
  802a9a:	c3                   	ret    

00802a9b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802a9b:	55                   	push   %ebp
  802a9c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802a9e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa4:	6a 00                	push   $0x0
  802aa6:	6a 00                	push   $0x0
  802aa8:	6a 00                	push   $0x0
  802aaa:	52                   	push   %edx
  802aab:	50                   	push   %eax
  802aac:	6a 05                	push   $0x5
  802aae:	e8 7b ff ff ff       	call   802a2e <syscall>
  802ab3:	83 c4 18             	add    $0x18,%esp
}
  802ab6:	c9                   	leave  
  802ab7:	c3                   	ret    

00802ab8 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802ab8:	55                   	push   %ebp
  802ab9:	89 e5                	mov    %esp,%ebp
  802abb:	56                   	push   %esi
  802abc:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802abd:	8b 75 18             	mov    0x18(%ebp),%esi
  802ac0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802ac3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802ac6:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	56                   	push   %esi
  802acd:	53                   	push   %ebx
  802ace:	51                   	push   %ecx
  802acf:	52                   	push   %edx
  802ad0:	50                   	push   %eax
  802ad1:	6a 06                	push   $0x6
  802ad3:	e8 56 ff ff ff       	call   802a2e <syscall>
  802ad8:	83 c4 18             	add    $0x18,%esp
}
  802adb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802ade:	5b                   	pop    %ebx
  802adf:	5e                   	pop    %esi
  802ae0:	5d                   	pop    %ebp
  802ae1:	c3                   	ret    

00802ae2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802ae2:	55                   	push   %ebp
  802ae3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802ae5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aeb:	6a 00                	push   $0x0
  802aed:	6a 00                	push   $0x0
  802aef:	6a 00                	push   $0x0
  802af1:	52                   	push   %edx
  802af2:	50                   	push   %eax
  802af3:	6a 07                	push   $0x7
  802af5:	e8 34 ff ff ff       	call   802a2e <syscall>
  802afa:	83 c4 18             	add    $0x18,%esp
}
  802afd:	c9                   	leave  
  802afe:	c3                   	ret    

00802aff <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802aff:	55                   	push   %ebp
  802b00:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802b02:	6a 00                	push   $0x0
  802b04:	6a 00                	push   $0x0
  802b06:	6a 00                	push   $0x0
  802b08:	ff 75 0c             	pushl  0xc(%ebp)
  802b0b:	ff 75 08             	pushl  0x8(%ebp)
  802b0e:	6a 08                	push   $0x8
  802b10:	e8 19 ff ff ff       	call   802a2e <syscall>
  802b15:	83 c4 18             	add    $0x18,%esp
}
  802b18:	c9                   	leave  
  802b19:	c3                   	ret    

00802b1a <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802b1a:	55                   	push   %ebp
  802b1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802b1d:	6a 00                	push   $0x0
  802b1f:	6a 00                	push   $0x0
  802b21:	6a 00                	push   $0x0
  802b23:	6a 00                	push   $0x0
  802b25:	6a 00                	push   $0x0
  802b27:	6a 09                	push   $0x9
  802b29:	e8 00 ff ff ff       	call   802a2e <syscall>
  802b2e:	83 c4 18             	add    $0x18,%esp
}
  802b31:	c9                   	leave  
  802b32:	c3                   	ret    

00802b33 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802b33:	55                   	push   %ebp
  802b34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802b36:	6a 00                	push   $0x0
  802b38:	6a 00                	push   $0x0
  802b3a:	6a 00                	push   $0x0
  802b3c:	6a 00                	push   $0x0
  802b3e:	6a 00                	push   $0x0
  802b40:	6a 0a                	push   $0xa
  802b42:	e8 e7 fe ff ff       	call   802a2e <syscall>
  802b47:	83 c4 18             	add    $0x18,%esp
}
  802b4a:	c9                   	leave  
  802b4b:	c3                   	ret    

00802b4c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  802b4c:	55                   	push   %ebp
  802b4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802b4f:	6a 00                	push   $0x0
  802b51:	6a 00                	push   $0x0
  802b53:	6a 00                	push   $0x0
  802b55:	6a 00                	push   $0x0
  802b57:	6a 00                	push   $0x0
  802b59:	6a 0b                	push   $0xb
  802b5b:	e8 ce fe ff ff       	call   802a2e <syscall>
  802b60:	83 c4 18             	add    $0x18,%esp
}
  802b63:	c9                   	leave  
  802b64:	c3                   	ret    

00802b65 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802b65:	55                   	push   %ebp
  802b66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  802b68:	6a 00                	push   $0x0
  802b6a:	6a 00                	push   $0x0
  802b6c:	6a 00                	push   $0x0
  802b6e:	ff 75 0c             	pushl  0xc(%ebp)
  802b71:	ff 75 08             	pushl  0x8(%ebp)
  802b74:	6a 0f                	push   $0xf
  802b76:	e8 b3 fe ff ff       	call   802a2e <syscall>
  802b7b:	83 c4 18             	add    $0x18,%esp
	return;
  802b7e:	90                   	nop
}
  802b7f:	c9                   	leave  
  802b80:	c3                   	ret    

00802b81 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802b81:	55                   	push   %ebp
  802b82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802b84:	6a 00                	push   $0x0
  802b86:	6a 00                	push   $0x0
  802b88:	6a 00                	push   $0x0
  802b8a:	ff 75 0c             	pushl  0xc(%ebp)
  802b8d:	ff 75 08             	pushl  0x8(%ebp)
  802b90:	6a 10                	push   $0x10
  802b92:	e8 97 fe ff ff       	call   802a2e <syscall>
  802b97:	83 c4 18             	add    $0x18,%esp
	return ;
  802b9a:	90                   	nop
}
  802b9b:	c9                   	leave  
  802b9c:	c3                   	ret    

00802b9d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802b9d:	55                   	push   %ebp
  802b9e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  802ba0:	6a 00                	push   $0x0
  802ba2:	6a 00                	push   $0x0
  802ba4:	ff 75 10             	pushl  0x10(%ebp)
  802ba7:	ff 75 0c             	pushl  0xc(%ebp)
  802baa:	ff 75 08             	pushl  0x8(%ebp)
  802bad:	6a 11                	push   $0x11
  802baf:	e8 7a fe ff ff       	call   802a2e <syscall>
  802bb4:	83 c4 18             	add    $0x18,%esp
	return ;
  802bb7:	90                   	nop
}
  802bb8:	c9                   	leave  
  802bb9:	c3                   	ret    

00802bba <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802bba:	55                   	push   %ebp
  802bbb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802bbd:	6a 00                	push   $0x0
  802bbf:	6a 00                	push   $0x0
  802bc1:	6a 00                	push   $0x0
  802bc3:	6a 00                	push   $0x0
  802bc5:	6a 00                	push   $0x0
  802bc7:	6a 0c                	push   $0xc
  802bc9:	e8 60 fe ff ff       	call   802a2e <syscall>
  802bce:	83 c4 18             	add    $0x18,%esp
}
  802bd1:	c9                   	leave  
  802bd2:	c3                   	ret    

00802bd3 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802bd3:	55                   	push   %ebp
  802bd4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802bd6:	6a 00                	push   $0x0
  802bd8:	6a 00                	push   $0x0
  802bda:	6a 00                	push   $0x0
  802bdc:	6a 00                	push   $0x0
  802bde:	ff 75 08             	pushl  0x8(%ebp)
  802be1:	6a 0d                	push   $0xd
  802be3:	e8 46 fe ff ff       	call   802a2e <syscall>
  802be8:	83 c4 18             	add    $0x18,%esp
}
  802beb:	c9                   	leave  
  802bec:	c3                   	ret    

00802bed <sys_scarce_memory>:

void sys_scarce_memory()
{
  802bed:	55                   	push   %ebp
  802bee:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  802bf0:	6a 00                	push   $0x0
  802bf2:	6a 00                	push   $0x0
  802bf4:	6a 00                	push   $0x0
  802bf6:	6a 00                	push   $0x0
  802bf8:	6a 00                	push   $0x0
  802bfa:	6a 0e                	push   $0xe
  802bfc:	e8 2d fe ff ff       	call   802a2e <syscall>
  802c01:	83 c4 18             	add    $0x18,%esp
}
  802c04:	90                   	nop
  802c05:	c9                   	leave  
  802c06:	c3                   	ret    

00802c07 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802c07:	55                   	push   %ebp
  802c08:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802c0a:	6a 00                	push   $0x0
  802c0c:	6a 00                	push   $0x0
  802c0e:	6a 00                	push   $0x0
  802c10:	6a 00                	push   $0x0
  802c12:	6a 00                	push   $0x0
  802c14:	6a 13                	push   $0x13
  802c16:	e8 13 fe ff ff       	call   802a2e <syscall>
  802c1b:	83 c4 18             	add    $0x18,%esp
}
  802c1e:	90                   	nop
  802c1f:	c9                   	leave  
  802c20:	c3                   	ret    

00802c21 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802c21:	55                   	push   %ebp
  802c22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802c24:	6a 00                	push   $0x0
  802c26:	6a 00                	push   $0x0
  802c28:	6a 00                	push   $0x0
  802c2a:	6a 00                	push   $0x0
  802c2c:	6a 00                	push   $0x0
  802c2e:	6a 14                	push   $0x14
  802c30:	e8 f9 fd ff ff       	call   802a2e <syscall>
  802c35:	83 c4 18             	add    $0x18,%esp
}
  802c38:	90                   	nop
  802c39:	c9                   	leave  
  802c3a:	c3                   	ret    

00802c3b <sys_cputc>:


void
sys_cputc(const char c)
{
  802c3b:	55                   	push   %ebp
  802c3c:	89 e5                	mov    %esp,%ebp
  802c3e:	83 ec 04             	sub    $0x4,%esp
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  802c47:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802c4b:	6a 00                	push   $0x0
  802c4d:	6a 00                	push   $0x0
  802c4f:	6a 00                	push   $0x0
  802c51:	6a 00                	push   $0x0
  802c53:	50                   	push   %eax
  802c54:	6a 15                	push   $0x15
  802c56:	e8 d3 fd ff ff       	call   802a2e <syscall>
  802c5b:	83 c4 18             	add    $0x18,%esp
}
  802c5e:	90                   	nop
  802c5f:	c9                   	leave  
  802c60:	c3                   	ret    

00802c61 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802c61:	55                   	push   %ebp
  802c62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802c64:	6a 00                	push   $0x0
  802c66:	6a 00                	push   $0x0
  802c68:	6a 00                	push   $0x0
  802c6a:	6a 00                	push   $0x0
  802c6c:	6a 00                	push   $0x0
  802c6e:	6a 16                	push   $0x16
  802c70:	e8 b9 fd ff ff       	call   802a2e <syscall>
  802c75:	83 c4 18             	add    $0x18,%esp
}
  802c78:	90                   	nop
  802c79:	c9                   	leave  
  802c7a:	c3                   	ret    

00802c7b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  802c7b:	55                   	push   %ebp
  802c7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c81:	6a 00                	push   $0x0
  802c83:	6a 00                	push   $0x0
  802c85:	6a 00                	push   $0x0
  802c87:	ff 75 0c             	pushl  0xc(%ebp)
  802c8a:	50                   	push   %eax
  802c8b:	6a 17                	push   $0x17
  802c8d:	e8 9c fd ff ff       	call   802a2e <syscall>
  802c92:	83 c4 18             	add    $0x18,%esp
}
  802c95:	c9                   	leave  
  802c96:	c3                   	ret    

00802c97 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802c97:	55                   	push   %ebp
  802c98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802c9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	6a 00                	push   $0x0
  802ca2:	6a 00                	push   $0x0
  802ca4:	6a 00                	push   $0x0
  802ca6:	52                   	push   %edx
  802ca7:	50                   	push   %eax
  802ca8:	6a 1a                	push   $0x1a
  802caa:	e8 7f fd ff ff       	call   802a2e <syscall>
  802caf:	83 c4 18             	add    $0x18,%esp
}
  802cb2:	c9                   	leave  
  802cb3:	c3                   	ret    

00802cb4 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802cb4:	55                   	push   %ebp
  802cb5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802cb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	6a 00                	push   $0x0
  802cbf:	6a 00                	push   $0x0
  802cc1:	6a 00                	push   $0x0
  802cc3:	52                   	push   %edx
  802cc4:	50                   	push   %eax
  802cc5:	6a 18                	push   $0x18
  802cc7:	e8 62 fd ff ff       	call   802a2e <syscall>
  802ccc:	83 c4 18             	add    $0x18,%esp
}
  802ccf:	90                   	nop
  802cd0:	c9                   	leave  
  802cd1:	c3                   	ret    

00802cd2 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802cd2:	55                   	push   %ebp
  802cd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802cd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  802cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdb:	6a 00                	push   $0x0
  802cdd:	6a 00                	push   $0x0
  802cdf:	6a 00                	push   $0x0
  802ce1:	52                   	push   %edx
  802ce2:	50                   	push   %eax
  802ce3:	6a 19                	push   $0x19
  802ce5:	e8 44 fd ff ff       	call   802a2e <syscall>
  802cea:	83 c4 18             	add    $0x18,%esp
}
  802ced:	90                   	nop
  802cee:	c9                   	leave  
  802cef:	c3                   	ret    

00802cf0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802cf0:	55                   	push   %ebp
  802cf1:	89 e5                	mov    %esp,%ebp
  802cf3:	83 ec 04             	sub    $0x4,%esp
  802cf6:	8b 45 10             	mov    0x10(%ebp),%eax
  802cf9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802cfc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802cff:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	6a 00                	push   $0x0
  802d08:	51                   	push   %ecx
  802d09:	52                   	push   %edx
  802d0a:	ff 75 0c             	pushl  0xc(%ebp)
  802d0d:	50                   	push   %eax
  802d0e:	6a 1b                	push   $0x1b
  802d10:	e8 19 fd ff ff       	call   802a2e <syscall>
  802d15:	83 c4 18             	add    $0x18,%esp
}
  802d18:	c9                   	leave  
  802d19:	c3                   	ret    

00802d1a <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802d1a:	55                   	push   %ebp
  802d1b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802d1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	6a 00                	push   $0x0
  802d25:	6a 00                	push   $0x0
  802d27:	6a 00                	push   $0x0
  802d29:	52                   	push   %edx
  802d2a:	50                   	push   %eax
  802d2b:	6a 1c                	push   $0x1c
  802d2d:	e8 fc fc ff ff       	call   802a2e <syscall>
  802d32:	83 c4 18             	add    $0x18,%esp
}
  802d35:	c9                   	leave  
  802d36:	c3                   	ret    

00802d37 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  802d37:	55                   	push   %ebp
  802d38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  802d3a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802d3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	6a 00                	push   $0x0
  802d45:	6a 00                	push   $0x0
  802d47:	51                   	push   %ecx
  802d48:	52                   	push   %edx
  802d49:	50                   	push   %eax
  802d4a:	6a 1d                	push   $0x1d
  802d4c:	e8 dd fc ff ff       	call   802a2e <syscall>
  802d51:	83 c4 18             	add    $0x18,%esp
}
  802d54:	c9                   	leave  
  802d55:	c3                   	ret    

00802d56 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802d56:	55                   	push   %ebp
  802d57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802d59:	8b 55 0c             	mov    0xc(%ebp),%edx
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	6a 00                	push   $0x0
  802d61:	6a 00                	push   $0x0
  802d63:	6a 00                	push   $0x0
  802d65:	52                   	push   %edx
  802d66:	50                   	push   %eax
  802d67:	6a 1e                	push   $0x1e
  802d69:	e8 c0 fc ff ff       	call   802a2e <syscall>
  802d6e:	83 c4 18             	add    $0x18,%esp
}
  802d71:	c9                   	leave  
  802d72:	c3                   	ret    

00802d73 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802d73:	55                   	push   %ebp
  802d74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802d76:	6a 00                	push   $0x0
  802d78:	6a 00                	push   $0x0
  802d7a:	6a 00                	push   $0x0
  802d7c:	6a 00                	push   $0x0
  802d7e:	6a 00                	push   $0x0
  802d80:	6a 1f                	push   $0x1f
  802d82:	e8 a7 fc ff ff       	call   802a2e <syscall>
  802d87:	83 c4 18             	add    $0x18,%esp
}
  802d8a:	c9                   	leave  
  802d8b:	c3                   	ret    

00802d8c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802d8c:	55                   	push   %ebp
  802d8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d92:	6a 00                	push   $0x0
  802d94:	ff 75 14             	pushl  0x14(%ebp)
  802d97:	ff 75 10             	pushl  0x10(%ebp)
  802d9a:	ff 75 0c             	pushl  0xc(%ebp)
  802d9d:	50                   	push   %eax
  802d9e:	6a 20                	push   $0x20
  802da0:	e8 89 fc ff ff       	call   802a2e <syscall>
  802da5:	83 c4 18             	add    $0x18,%esp
}
  802da8:	c9                   	leave  
  802da9:	c3                   	ret    

00802daa <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802daa:	55                   	push   %ebp
  802dab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	6a 00                	push   $0x0
  802db2:	6a 00                	push   $0x0
  802db4:	6a 00                	push   $0x0
  802db6:	6a 00                	push   $0x0
  802db8:	50                   	push   %eax
  802db9:	6a 21                	push   $0x21
  802dbb:	e8 6e fc ff ff       	call   802a2e <syscall>
  802dc0:	83 c4 18             	add    $0x18,%esp
}
  802dc3:	90                   	nop
  802dc4:	c9                   	leave  
  802dc5:	c3                   	ret    

00802dc6 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802dc6:	55                   	push   %ebp
  802dc7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcc:	6a 00                	push   $0x0
  802dce:	6a 00                	push   $0x0
  802dd0:	6a 00                	push   $0x0
  802dd2:	6a 00                	push   $0x0
  802dd4:	50                   	push   %eax
  802dd5:	6a 22                	push   $0x22
  802dd7:	e8 52 fc ff ff       	call   802a2e <syscall>
  802ddc:	83 c4 18             	add    $0x18,%esp
}
  802ddf:	c9                   	leave  
  802de0:	c3                   	ret    

00802de1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802de1:	55                   	push   %ebp
  802de2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802de4:	6a 00                	push   $0x0
  802de6:	6a 00                	push   $0x0
  802de8:	6a 00                	push   $0x0
  802dea:	6a 00                	push   $0x0
  802dec:	6a 00                	push   $0x0
  802dee:	6a 02                	push   $0x2
  802df0:	e8 39 fc ff ff       	call   802a2e <syscall>
  802df5:	83 c4 18             	add    $0x18,%esp
}
  802df8:	c9                   	leave  
  802df9:	c3                   	ret    

00802dfa <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802dfa:	55                   	push   %ebp
  802dfb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802dfd:	6a 00                	push   $0x0
  802dff:	6a 00                	push   $0x0
  802e01:	6a 00                	push   $0x0
  802e03:	6a 00                	push   $0x0
  802e05:	6a 00                	push   $0x0
  802e07:	6a 03                	push   $0x3
  802e09:	e8 20 fc ff ff       	call   802a2e <syscall>
  802e0e:	83 c4 18             	add    $0x18,%esp
}
  802e11:	c9                   	leave  
  802e12:	c3                   	ret    

00802e13 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802e13:	55                   	push   %ebp
  802e14:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802e16:	6a 00                	push   $0x0
  802e18:	6a 00                	push   $0x0
  802e1a:	6a 00                	push   $0x0
  802e1c:	6a 00                	push   $0x0
  802e1e:	6a 00                	push   $0x0
  802e20:	6a 04                	push   $0x4
  802e22:	e8 07 fc ff ff       	call   802a2e <syscall>
  802e27:	83 c4 18             	add    $0x18,%esp
}
  802e2a:	c9                   	leave  
  802e2b:	c3                   	ret    

00802e2c <sys_exit_env>:


void sys_exit_env(void)
{
  802e2c:	55                   	push   %ebp
  802e2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802e2f:	6a 00                	push   $0x0
  802e31:	6a 00                	push   $0x0
  802e33:	6a 00                	push   $0x0
  802e35:	6a 00                	push   $0x0
  802e37:	6a 00                	push   $0x0
  802e39:	6a 23                	push   $0x23
  802e3b:	e8 ee fb ff ff       	call   802a2e <syscall>
  802e40:	83 c4 18             	add    $0x18,%esp
}
  802e43:	90                   	nop
  802e44:	c9                   	leave  
  802e45:	c3                   	ret    

00802e46 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802e46:	55                   	push   %ebp
  802e47:	89 e5                	mov    %esp,%ebp
  802e49:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802e4c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e4f:	8d 50 04             	lea    0x4(%eax),%edx
  802e52:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802e55:	6a 00                	push   $0x0
  802e57:	6a 00                	push   $0x0
  802e59:	6a 00                	push   $0x0
  802e5b:	52                   	push   %edx
  802e5c:	50                   	push   %eax
  802e5d:	6a 24                	push   $0x24
  802e5f:	e8 ca fb ff ff       	call   802a2e <syscall>
  802e64:	83 c4 18             	add    $0x18,%esp
	return result;
  802e67:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802e6a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802e6d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802e70:	89 01                	mov    %eax,(%ecx)
  802e72:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	c9                   	leave  
  802e79:	c2 04 00             	ret    $0x4

00802e7c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802e7c:	55                   	push   %ebp
  802e7d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802e7f:	6a 00                	push   $0x0
  802e81:	6a 00                	push   $0x0
  802e83:	ff 75 10             	pushl  0x10(%ebp)
  802e86:	ff 75 0c             	pushl  0xc(%ebp)
  802e89:	ff 75 08             	pushl  0x8(%ebp)
  802e8c:	6a 12                	push   $0x12
  802e8e:	e8 9b fb ff ff       	call   802a2e <syscall>
  802e93:	83 c4 18             	add    $0x18,%esp
	return ;
  802e96:	90                   	nop
}
  802e97:	c9                   	leave  
  802e98:	c3                   	ret    

00802e99 <sys_rcr2>:
uint32 sys_rcr2()
{
  802e99:	55                   	push   %ebp
  802e9a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802e9c:	6a 00                	push   $0x0
  802e9e:	6a 00                	push   $0x0
  802ea0:	6a 00                	push   $0x0
  802ea2:	6a 00                	push   $0x0
  802ea4:	6a 00                	push   $0x0
  802ea6:	6a 25                	push   $0x25
  802ea8:	e8 81 fb ff ff       	call   802a2e <syscall>
  802ead:	83 c4 18             	add    $0x18,%esp
}
  802eb0:	c9                   	leave  
  802eb1:	c3                   	ret    

00802eb2 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802eb2:	55                   	push   %ebp
  802eb3:	89 e5                	mov    %esp,%ebp
  802eb5:	83 ec 04             	sub    $0x4,%esp
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802ebe:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802ec2:	6a 00                	push   $0x0
  802ec4:	6a 00                	push   $0x0
  802ec6:	6a 00                	push   $0x0
  802ec8:	6a 00                	push   $0x0
  802eca:	50                   	push   %eax
  802ecb:	6a 26                	push   $0x26
  802ecd:	e8 5c fb ff ff       	call   802a2e <syscall>
  802ed2:	83 c4 18             	add    $0x18,%esp
	return ;
  802ed5:	90                   	nop
}
  802ed6:	c9                   	leave  
  802ed7:	c3                   	ret    

00802ed8 <rsttst>:
void rsttst()
{
  802ed8:	55                   	push   %ebp
  802ed9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802edb:	6a 00                	push   $0x0
  802edd:	6a 00                	push   $0x0
  802edf:	6a 00                	push   $0x0
  802ee1:	6a 00                	push   $0x0
  802ee3:	6a 00                	push   $0x0
  802ee5:	6a 28                	push   $0x28
  802ee7:	e8 42 fb ff ff       	call   802a2e <syscall>
  802eec:	83 c4 18             	add    $0x18,%esp
	return ;
  802eef:	90                   	nop
}
  802ef0:	c9                   	leave  
  802ef1:	c3                   	ret    

00802ef2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802ef2:	55                   	push   %ebp
  802ef3:	89 e5                	mov    %esp,%ebp
  802ef5:	83 ec 04             	sub    $0x4,%esp
  802ef8:	8b 45 14             	mov    0x14(%ebp),%eax
  802efb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802efe:	8b 55 18             	mov    0x18(%ebp),%edx
  802f01:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802f05:	52                   	push   %edx
  802f06:	50                   	push   %eax
  802f07:	ff 75 10             	pushl  0x10(%ebp)
  802f0a:	ff 75 0c             	pushl  0xc(%ebp)
  802f0d:	ff 75 08             	pushl  0x8(%ebp)
  802f10:	6a 27                	push   $0x27
  802f12:	e8 17 fb ff ff       	call   802a2e <syscall>
  802f17:	83 c4 18             	add    $0x18,%esp
	return ;
  802f1a:	90                   	nop
}
  802f1b:	c9                   	leave  
  802f1c:	c3                   	ret    

00802f1d <chktst>:
void chktst(uint32 n)
{
  802f1d:	55                   	push   %ebp
  802f1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802f20:	6a 00                	push   $0x0
  802f22:	6a 00                	push   $0x0
  802f24:	6a 00                	push   $0x0
  802f26:	6a 00                	push   $0x0
  802f28:	ff 75 08             	pushl  0x8(%ebp)
  802f2b:	6a 29                	push   $0x29
  802f2d:	e8 fc fa ff ff       	call   802a2e <syscall>
  802f32:	83 c4 18             	add    $0x18,%esp
	return ;
  802f35:	90                   	nop
}
  802f36:	c9                   	leave  
  802f37:	c3                   	ret    

00802f38 <inctst>:

void inctst()
{
  802f38:	55                   	push   %ebp
  802f39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802f3b:	6a 00                	push   $0x0
  802f3d:	6a 00                	push   $0x0
  802f3f:	6a 00                	push   $0x0
  802f41:	6a 00                	push   $0x0
  802f43:	6a 00                	push   $0x0
  802f45:	6a 2a                	push   $0x2a
  802f47:	e8 e2 fa ff ff       	call   802a2e <syscall>
  802f4c:	83 c4 18             	add    $0x18,%esp
	return ;
  802f4f:	90                   	nop
}
  802f50:	c9                   	leave  
  802f51:	c3                   	ret    

00802f52 <gettst>:
uint32 gettst()
{
  802f52:	55                   	push   %ebp
  802f53:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802f55:	6a 00                	push   $0x0
  802f57:	6a 00                	push   $0x0
  802f59:	6a 00                	push   $0x0
  802f5b:	6a 00                	push   $0x0
  802f5d:	6a 00                	push   $0x0
  802f5f:	6a 2b                	push   $0x2b
  802f61:	e8 c8 fa ff ff       	call   802a2e <syscall>
  802f66:	83 c4 18             	add    $0x18,%esp
}
  802f69:	c9                   	leave  
  802f6a:	c3                   	ret    

00802f6b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802f6b:	55                   	push   %ebp
  802f6c:	89 e5                	mov    %esp,%ebp
  802f6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802f71:	6a 00                	push   $0x0
  802f73:	6a 00                	push   $0x0
  802f75:	6a 00                	push   $0x0
  802f77:	6a 00                	push   $0x0
  802f79:	6a 00                	push   $0x0
  802f7b:	6a 2c                	push   $0x2c
  802f7d:	e8 ac fa ff ff       	call   802a2e <syscall>
  802f82:	83 c4 18             	add    $0x18,%esp
  802f85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802f88:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802f8c:	75 07                	jne    802f95 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802f8e:	b8 01 00 00 00       	mov    $0x1,%eax
  802f93:	eb 05                	jmp    802f9a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802f95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802f9a:	c9                   	leave  
  802f9b:	c3                   	ret    

00802f9c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802f9c:	55                   	push   %ebp
  802f9d:	89 e5                	mov    %esp,%ebp
  802f9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802fa2:	6a 00                	push   $0x0
  802fa4:	6a 00                	push   $0x0
  802fa6:	6a 00                	push   $0x0
  802fa8:	6a 00                	push   $0x0
  802faa:	6a 00                	push   $0x0
  802fac:	6a 2c                	push   $0x2c
  802fae:	e8 7b fa ff ff       	call   802a2e <syscall>
  802fb3:	83 c4 18             	add    $0x18,%esp
  802fb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802fb9:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802fbd:	75 07                	jne    802fc6 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802fbf:	b8 01 00 00 00       	mov    $0x1,%eax
  802fc4:	eb 05                	jmp    802fcb <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802fc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fcb:	c9                   	leave  
  802fcc:	c3                   	ret    

00802fcd <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802fcd:	55                   	push   %ebp
  802fce:	89 e5                	mov    %esp,%ebp
  802fd0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802fd3:	6a 00                	push   $0x0
  802fd5:	6a 00                	push   $0x0
  802fd7:	6a 00                	push   $0x0
  802fd9:	6a 00                	push   $0x0
  802fdb:	6a 00                	push   $0x0
  802fdd:	6a 2c                	push   $0x2c
  802fdf:	e8 4a fa ff ff       	call   802a2e <syscall>
  802fe4:	83 c4 18             	add    $0x18,%esp
  802fe7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802fea:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802fee:	75 07                	jne    802ff7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802ff0:	b8 01 00 00 00       	mov    $0x1,%eax
  802ff5:	eb 05                	jmp    802ffc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802ff7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ffc:	c9                   	leave  
  802ffd:	c3                   	ret    

00802ffe <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802ffe:	55                   	push   %ebp
  802fff:	89 e5                	mov    %esp,%ebp
  803001:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  803004:	6a 00                	push   $0x0
  803006:	6a 00                	push   $0x0
  803008:	6a 00                	push   $0x0
  80300a:	6a 00                	push   $0x0
  80300c:	6a 00                	push   $0x0
  80300e:	6a 2c                	push   $0x2c
  803010:	e8 19 fa ff ff       	call   802a2e <syscall>
  803015:	83 c4 18             	add    $0x18,%esp
  803018:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80301b:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80301f:	75 07                	jne    803028 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  803021:	b8 01 00 00 00       	mov    $0x1,%eax
  803026:	eb 05                	jmp    80302d <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  803028:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80302d:	c9                   	leave  
  80302e:	c3                   	ret    

0080302f <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  80302f:	55                   	push   %ebp
  803030:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  803032:	6a 00                	push   $0x0
  803034:	6a 00                	push   $0x0
  803036:	6a 00                	push   $0x0
  803038:	6a 00                	push   $0x0
  80303a:	ff 75 08             	pushl  0x8(%ebp)
  80303d:	6a 2d                	push   $0x2d
  80303f:	e8 ea f9 ff ff       	call   802a2e <syscall>
  803044:	83 c4 18             	add    $0x18,%esp
	return ;
  803047:	90                   	nop
}
  803048:	c9                   	leave  
  803049:	c3                   	ret    

0080304a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80304a:	55                   	push   %ebp
  80304b:	89 e5                	mov    %esp,%ebp
  80304d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  80304e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  803051:	8b 4d 10             	mov    0x10(%ebp),%ecx
  803054:	8b 55 0c             	mov    0xc(%ebp),%edx
  803057:	8b 45 08             	mov    0x8(%ebp),%eax
  80305a:	6a 00                	push   $0x0
  80305c:	53                   	push   %ebx
  80305d:	51                   	push   %ecx
  80305e:	52                   	push   %edx
  80305f:	50                   	push   %eax
  803060:	6a 2e                	push   $0x2e
  803062:	e8 c7 f9 ff ff       	call   802a2e <syscall>
  803067:	83 c4 18             	add    $0x18,%esp
}
  80306a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80306d:	c9                   	leave  
  80306e:	c3                   	ret    

0080306f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  80306f:	55                   	push   %ebp
  803070:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  803072:	8b 55 0c             	mov    0xc(%ebp),%edx
  803075:	8b 45 08             	mov    0x8(%ebp),%eax
  803078:	6a 00                	push   $0x0
  80307a:	6a 00                	push   $0x0
  80307c:	6a 00                	push   $0x0
  80307e:	52                   	push   %edx
  80307f:	50                   	push   %eax
  803080:	6a 2f                	push   $0x2f
  803082:	e8 a7 f9 ff ff       	call   802a2e <syscall>
  803087:	83 c4 18             	add    $0x18,%esp
}
  80308a:	c9                   	leave  
  80308b:	c3                   	ret    

0080308c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80308c:	55                   	push   %ebp
  80308d:	89 e5                	mov    %esp,%ebp
  80308f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  803092:	83 ec 0c             	sub    $0xc,%esp
  803095:	68 60 4f 80 00       	push   $0x804f60
  80309a:	e8 3e e6 ff ff       	call   8016dd <cprintf>
  80309f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8030a2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8030a9:	83 ec 0c             	sub    $0xc,%esp
  8030ac:	68 8c 4f 80 00       	push   $0x804f8c
  8030b1:	e8 27 e6 ff ff       	call   8016dd <cprintf>
  8030b6:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8030b9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8030bd:	a1 38 61 80 00       	mov    0x806138,%eax
  8030c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030c5:	eb 56                	jmp    80311d <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8030c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8030cb:	74 1c                	je     8030e9 <print_mem_block_lists+0x5d>
  8030cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d0:	8b 50 08             	mov    0x8(%eax),%edx
  8030d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d6:	8b 48 08             	mov    0x8(%eax),%ecx
  8030d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030df:	01 c8                	add    %ecx,%eax
  8030e1:	39 c2                	cmp    %eax,%edx
  8030e3:	73 04                	jae    8030e9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8030e5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8030e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ec:	8b 50 08             	mov    0x8(%eax),%edx
  8030ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8030f5:	01 c2                	add    %eax,%edx
  8030f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fa:	8b 40 08             	mov    0x8(%eax),%eax
  8030fd:	83 ec 04             	sub    $0x4,%esp
  803100:	52                   	push   %edx
  803101:	50                   	push   %eax
  803102:	68 a1 4f 80 00       	push   $0x804fa1
  803107:	e8 d1 e5 ff ff       	call   8016dd <cprintf>
  80310c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80310f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803112:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  803115:	a1 40 61 80 00       	mov    0x806140,%eax
  80311a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80311d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803121:	74 07                	je     80312a <print_mem_block_lists+0x9e>
  803123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803126:	8b 00                	mov    (%eax),%eax
  803128:	eb 05                	jmp    80312f <print_mem_block_lists+0xa3>
  80312a:	b8 00 00 00 00       	mov    $0x0,%eax
  80312f:	a3 40 61 80 00       	mov    %eax,0x806140
  803134:	a1 40 61 80 00       	mov    0x806140,%eax
  803139:	85 c0                	test   %eax,%eax
  80313b:	75 8a                	jne    8030c7 <print_mem_block_lists+0x3b>
  80313d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803141:	75 84                	jne    8030c7 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  803143:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  803147:	75 10                	jne    803159 <print_mem_block_lists+0xcd>
  803149:	83 ec 0c             	sub    $0xc,%esp
  80314c:	68 b0 4f 80 00       	push   $0x804fb0
  803151:	e8 87 e5 ff ff       	call   8016dd <cprintf>
  803156:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  803159:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  803160:	83 ec 0c             	sub    $0xc,%esp
  803163:	68 d4 4f 80 00       	push   $0x804fd4
  803168:	e8 70 e5 ff ff       	call   8016dd <cprintf>
  80316d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  803170:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  803174:	a1 40 60 80 00       	mov    0x806040,%eax
  803179:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80317c:	eb 56                	jmp    8031d4 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80317e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803182:	74 1c                	je     8031a0 <print_mem_block_lists+0x114>
  803184:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803187:	8b 50 08             	mov    0x8(%eax),%edx
  80318a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80318d:	8b 48 08             	mov    0x8(%eax),%ecx
  803190:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803193:	8b 40 0c             	mov    0xc(%eax),%eax
  803196:	01 c8                	add    %ecx,%eax
  803198:	39 c2                	cmp    %eax,%edx
  80319a:	73 04                	jae    8031a0 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80319c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8031a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a3:	8b 50 08             	mov    0x8(%eax),%edx
  8031a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031a9:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ac:	01 c2                	add    %eax,%edx
  8031ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b1:	8b 40 08             	mov    0x8(%eax),%eax
  8031b4:	83 ec 04             	sub    $0x4,%esp
  8031b7:	52                   	push   %edx
  8031b8:	50                   	push   %eax
  8031b9:	68 a1 4f 80 00       	push   $0x804fa1
  8031be:	e8 1a e5 ff ff       	call   8016dd <cprintf>
  8031c3:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8031c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8031cc:	a1 48 60 80 00       	mov    0x806048,%eax
  8031d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8031d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031d8:	74 07                	je     8031e1 <print_mem_block_lists+0x155>
  8031da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031dd:	8b 00                	mov    (%eax),%eax
  8031df:	eb 05                	jmp    8031e6 <print_mem_block_lists+0x15a>
  8031e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8031e6:	a3 48 60 80 00       	mov    %eax,0x806048
  8031eb:	a1 48 60 80 00       	mov    0x806048,%eax
  8031f0:	85 c0                	test   %eax,%eax
  8031f2:	75 8a                	jne    80317e <print_mem_block_lists+0xf2>
  8031f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031f8:	75 84                	jne    80317e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8031fa:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8031fe:	75 10                	jne    803210 <print_mem_block_lists+0x184>
  803200:	83 ec 0c             	sub    $0xc,%esp
  803203:	68 ec 4f 80 00       	push   $0x804fec
  803208:	e8 d0 e4 ff ff       	call   8016dd <cprintf>
  80320d:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  803210:	83 ec 0c             	sub    $0xc,%esp
  803213:	68 60 4f 80 00       	push   $0x804f60
  803218:	e8 c0 e4 ff ff       	call   8016dd <cprintf>
  80321d:	83 c4 10             	add    $0x10,%esp

}
  803220:	90                   	nop
  803221:	c9                   	leave  
  803222:	c3                   	ret    

00803223 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  803223:	55                   	push   %ebp
  803224:	89 e5                	mov    %esp,%ebp
  803226:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  803229:	c7 05 48 61 80 00 00 	movl   $0x0,0x806148
  803230:	00 00 00 
  803233:	c7 05 4c 61 80 00 00 	movl   $0x0,0x80614c
  80323a:	00 00 00 
  80323d:	c7 05 54 61 80 00 00 	movl   $0x0,0x806154
  803244:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  803247:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80324e:	e9 9e 00 00 00       	jmp    8032f1 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  803253:	a1 50 60 80 00       	mov    0x806050,%eax
  803258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80325b:	c1 e2 04             	shl    $0x4,%edx
  80325e:	01 d0                	add    %edx,%eax
  803260:	85 c0                	test   %eax,%eax
  803262:	75 14                	jne    803278 <initialize_MemBlocksList+0x55>
  803264:	83 ec 04             	sub    $0x4,%esp
  803267:	68 14 50 80 00       	push   $0x805014
  80326c:	6a 3d                	push   $0x3d
  80326e:	68 37 50 80 00       	push   $0x805037
  803273:	e8 b1 e1 ff ff       	call   801429 <_panic>
  803278:	a1 50 60 80 00       	mov    0x806050,%eax
  80327d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803280:	c1 e2 04             	shl    $0x4,%edx
  803283:	01 d0                	add    %edx,%eax
  803285:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80328b:	89 10                	mov    %edx,(%eax)
  80328d:	8b 00                	mov    (%eax),%eax
  80328f:	85 c0                	test   %eax,%eax
  803291:	74 18                	je     8032ab <initialize_MemBlocksList+0x88>
  803293:	a1 48 61 80 00       	mov    0x806148,%eax
  803298:	8b 15 50 60 80 00    	mov    0x806050,%edx
  80329e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8032a1:	c1 e1 04             	shl    $0x4,%ecx
  8032a4:	01 ca                	add    %ecx,%edx
  8032a6:	89 50 04             	mov    %edx,0x4(%eax)
  8032a9:	eb 12                	jmp    8032bd <initialize_MemBlocksList+0x9a>
  8032ab:	a1 50 60 80 00       	mov    0x806050,%eax
  8032b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032b3:	c1 e2 04             	shl    $0x4,%edx
  8032b6:	01 d0                	add    %edx,%eax
  8032b8:	a3 4c 61 80 00       	mov    %eax,0x80614c
  8032bd:	a1 50 60 80 00       	mov    0x806050,%eax
  8032c2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032c5:	c1 e2 04             	shl    $0x4,%edx
  8032c8:	01 d0                	add    %edx,%eax
  8032ca:	a3 48 61 80 00       	mov    %eax,0x806148
  8032cf:	a1 50 60 80 00       	mov    0x806050,%eax
  8032d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032d7:	c1 e2 04             	shl    $0x4,%edx
  8032da:	01 d0                	add    %edx,%eax
  8032dc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032e3:	a1 54 61 80 00       	mov    0x806154,%eax
  8032e8:	40                   	inc    %eax
  8032e9:	a3 54 61 80 00       	mov    %eax,0x806154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8032ee:	ff 45 f4             	incl   -0xc(%ebp)
  8032f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8032f7:	0f 82 56 ff ff ff    	jb     803253 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8032fd:	90                   	nop
  8032fe:	c9                   	leave  
  8032ff:	c3                   	ret    

00803300 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  803300:	55                   	push   %ebp
  803301:	89 e5                	mov    %esp,%ebp
  803303:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  803306:	8b 45 08             	mov    0x8(%ebp),%eax
  803309:	8b 00                	mov    (%eax),%eax
  80330b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80330e:	eb 18                	jmp    803328 <find_block+0x28>

		if(tmp->sva == va){
  803310:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803313:	8b 40 08             	mov    0x8(%eax),%eax
  803316:	3b 45 0c             	cmp    0xc(%ebp),%eax
  803319:	75 05                	jne    803320 <find_block+0x20>
			return tmp ;
  80331b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80331e:	eb 11                	jmp    803331 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  803320:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803323:	8b 00                	mov    (%eax),%eax
  803325:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  803328:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80332c:	75 e2                	jne    803310 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  80332e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803331:	c9                   	leave  
  803332:	c3                   	ret    

00803333 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  803333:	55                   	push   %ebp
  803334:	89 e5                	mov    %esp,%ebp
  803336:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  803339:	a1 40 60 80 00       	mov    0x806040,%eax
  80333e:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  803341:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803346:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  803349:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80334d:	75 65                	jne    8033b4 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  80334f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803353:	75 14                	jne    803369 <insert_sorted_allocList+0x36>
  803355:	83 ec 04             	sub    $0x4,%esp
  803358:	68 14 50 80 00       	push   $0x805014
  80335d:	6a 62                	push   $0x62
  80335f:	68 37 50 80 00       	push   $0x805037
  803364:	e8 c0 e0 ff ff       	call   801429 <_panic>
  803369:	8b 15 40 60 80 00    	mov    0x806040,%edx
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	89 10                	mov    %edx,(%eax)
  803374:	8b 45 08             	mov    0x8(%ebp),%eax
  803377:	8b 00                	mov    (%eax),%eax
  803379:	85 c0                	test   %eax,%eax
  80337b:	74 0d                	je     80338a <insert_sorted_allocList+0x57>
  80337d:	a1 40 60 80 00       	mov    0x806040,%eax
  803382:	8b 55 08             	mov    0x8(%ebp),%edx
  803385:	89 50 04             	mov    %edx,0x4(%eax)
  803388:	eb 08                	jmp    803392 <insert_sorted_allocList+0x5f>
  80338a:	8b 45 08             	mov    0x8(%ebp),%eax
  80338d:	a3 44 60 80 00       	mov    %eax,0x806044
  803392:	8b 45 08             	mov    0x8(%ebp),%eax
  803395:	a3 40 60 80 00       	mov    %eax,0x806040
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033a4:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8033a9:	40                   	inc    %eax
  8033aa:	a3 4c 60 80 00       	mov    %eax,0x80604c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8033af:	e9 14 01 00 00       	jmp    8034c8 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  8033b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b7:	8b 50 08             	mov    0x8(%eax),%edx
  8033ba:	a1 44 60 80 00       	mov    0x806044,%eax
  8033bf:	8b 40 08             	mov    0x8(%eax),%eax
  8033c2:	39 c2                	cmp    %eax,%edx
  8033c4:	76 65                	jbe    80342b <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  8033c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033ca:	75 14                	jne    8033e0 <insert_sorted_allocList+0xad>
  8033cc:	83 ec 04             	sub    $0x4,%esp
  8033cf:	68 50 50 80 00       	push   $0x805050
  8033d4:	6a 64                	push   $0x64
  8033d6:	68 37 50 80 00       	push   $0x805037
  8033db:	e8 49 e0 ff ff       	call   801429 <_panic>
  8033e0:	8b 15 44 60 80 00    	mov    0x806044,%edx
  8033e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e9:	89 50 04             	mov    %edx,0x4(%eax)
  8033ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ef:	8b 40 04             	mov    0x4(%eax),%eax
  8033f2:	85 c0                	test   %eax,%eax
  8033f4:	74 0c                	je     803402 <insert_sorted_allocList+0xcf>
  8033f6:	a1 44 60 80 00       	mov    0x806044,%eax
  8033fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8033fe:	89 10                	mov    %edx,(%eax)
  803400:	eb 08                	jmp    80340a <insert_sorted_allocList+0xd7>
  803402:	8b 45 08             	mov    0x8(%ebp),%eax
  803405:	a3 40 60 80 00       	mov    %eax,0x806040
  80340a:	8b 45 08             	mov    0x8(%ebp),%eax
  80340d:	a3 44 60 80 00       	mov    %eax,0x806044
  803412:	8b 45 08             	mov    0x8(%ebp),%eax
  803415:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80341b:	a1 4c 60 80 00       	mov    0x80604c,%eax
  803420:	40                   	inc    %eax
  803421:	a3 4c 60 80 00       	mov    %eax,0x80604c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  803426:	e9 9d 00 00 00       	jmp    8034c8 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80342b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803432:	e9 85 00 00 00       	jmp    8034bc <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  803437:	8b 45 08             	mov    0x8(%ebp),%eax
  80343a:	8b 50 08             	mov    0x8(%eax),%edx
  80343d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803440:	8b 40 08             	mov    0x8(%eax),%eax
  803443:	39 c2                	cmp    %eax,%edx
  803445:	73 6a                	jae    8034b1 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  803447:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80344b:	74 06                	je     803453 <insert_sorted_allocList+0x120>
  80344d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803451:	75 14                	jne    803467 <insert_sorted_allocList+0x134>
  803453:	83 ec 04             	sub    $0x4,%esp
  803456:	68 74 50 80 00       	push   $0x805074
  80345b:	6a 6b                	push   $0x6b
  80345d:	68 37 50 80 00       	push   $0x805037
  803462:	e8 c2 df ff ff       	call   801429 <_panic>
  803467:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346a:	8b 50 04             	mov    0x4(%eax),%edx
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	89 50 04             	mov    %edx,0x4(%eax)
  803473:	8b 45 08             	mov    0x8(%ebp),%eax
  803476:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803479:	89 10                	mov    %edx,(%eax)
  80347b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80347e:	8b 40 04             	mov    0x4(%eax),%eax
  803481:	85 c0                	test   %eax,%eax
  803483:	74 0d                	je     803492 <insert_sorted_allocList+0x15f>
  803485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803488:	8b 40 04             	mov    0x4(%eax),%eax
  80348b:	8b 55 08             	mov    0x8(%ebp),%edx
  80348e:	89 10                	mov    %edx,(%eax)
  803490:	eb 08                	jmp    80349a <insert_sorted_allocList+0x167>
  803492:	8b 45 08             	mov    0x8(%ebp),%eax
  803495:	a3 40 60 80 00       	mov    %eax,0x806040
  80349a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80349d:	8b 55 08             	mov    0x8(%ebp),%edx
  8034a0:	89 50 04             	mov    %edx,0x4(%eax)
  8034a3:	a1 4c 60 80 00       	mov    0x80604c,%eax
  8034a8:	40                   	inc    %eax
  8034a9:	a3 4c 60 80 00       	mov    %eax,0x80604c
    	    			break;
  8034ae:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8034af:	eb 17                	jmp    8034c8 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  8034b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b4:	8b 00                	mov    (%eax),%eax
  8034b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8034b9:	ff 45 f0             	incl   -0x10(%ebp)
  8034bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034bf:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8034c2:	0f 8c 6f ff ff ff    	jl     803437 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8034c8:	90                   	nop
  8034c9:	c9                   	leave  
  8034ca:	c3                   	ret    

008034cb <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8034cb:	55                   	push   %ebp
  8034cc:	89 e5                	mov    %esp,%ebp
  8034ce:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  8034d1:	a1 38 61 80 00       	mov    0x806138,%eax
  8034d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  8034d9:	e9 7c 01 00 00       	jmp    80365a <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  8034de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034e1:	8b 40 0c             	mov    0xc(%eax),%eax
  8034e4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8034e7:	0f 86 cf 00 00 00    	jbe    8035bc <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8034ed:	a1 48 61 80 00       	mov    0x806148,%eax
  8034f2:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  8034f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8034f8:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8034fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8034fe:	8b 55 08             	mov    0x8(%ebp),%edx
  803501:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  803504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803507:	8b 50 08             	mov    0x8(%eax),%edx
  80350a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80350d:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  803510:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803513:	8b 40 0c             	mov    0xc(%eax),%eax
  803516:	2b 45 08             	sub    0x8(%ebp),%eax
  803519:	89 c2                	mov    %eax,%edx
  80351b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351e:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  803521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803524:	8b 50 08             	mov    0x8(%eax),%edx
  803527:	8b 45 08             	mov    0x8(%ebp),%eax
  80352a:	01 c2                	add    %eax,%edx
  80352c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80352f:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  803532:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803536:	75 17                	jne    80354f <alloc_block_FF+0x84>
  803538:	83 ec 04             	sub    $0x4,%esp
  80353b:	68 a9 50 80 00       	push   $0x8050a9
  803540:	68 83 00 00 00       	push   $0x83
  803545:	68 37 50 80 00       	push   $0x805037
  80354a:	e8 da de ff ff       	call   801429 <_panic>
  80354f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803552:	8b 00                	mov    (%eax),%eax
  803554:	85 c0                	test   %eax,%eax
  803556:	74 10                	je     803568 <alloc_block_FF+0x9d>
  803558:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80355b:	8b 00                	mov    (%eax),%eax
  80355d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803560:	8b 52 04             	mov    0x4(%edx),%edx
  803563:	89 50 04             	mov    %edx,0x4(%eax)
  803566:	eb 0b                	jmp    803573 <alloc_block_FF+0xa8>
  803568:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80356b:	8b 40 04             	mov    0x4(%eax),%eax
  80356e:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803573:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803576:	8b 40 04             	mov    0x4(%eax),%eax
  803579:	85 c0                	test   %eax,%eax
  80357b:	74 0f                	je     80358c <alloc_block_FF+0xc1>
  80357d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803580:	8b 40 04             	mov    0x4(%eax),%eax
  803583:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803586:	8b 12                	mov    (%edx),%edx
  803588:	89 10                	mov    %edx,(%eax)
  80358a:	eb 0a                	jmp    803596 <alloc_block_FF+0xcb>
  80358c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80358f:	8b 00                	mov    (%eax),%eax
  803591:	a3 48 61 80 00       	mov    %eax,0x806148
  803596:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803599:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80359f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8035a9:	a1 54 61 80 00       	mov    0x806154,%eax
  8035ae:	48                   	dec    %eax
  8035af:	a3 54 61 80 00       	mov    %eax,0x806154
                    return newBlock ;
  8035b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8035b7:	e9 ad 00 00 00       	jmp    803669 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  8035bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8035c2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8035c5:	0f 85 87 00 00 00    	jne    803652 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  8035cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035cf:	75 17                	jne    8035e8 <alloc_block_FF+0x11d>
  8035d1:	83 ec 04             	sub    $0x4,%esp
  8035d4:	68 a9 50 80 00       	push   $0x8050a9
  8035d9:	68 87 00 00 00       	push   $0x87
  8035de:	68 37 50 80 00       	push   $0x805037
  8035e3:	e8 41 de ff ff       	call   801429 <_panic>
  8035e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035eb:	8b 00                	mov    (%eax),%eax
  8035ed:	85 c0                	test   %eax,%eax
  8035ef:	74 10                	je     803601 <alloc_block_FF+0x136>
  8035f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035f4:	8b 00                	mov    (%eax),%eax
  8035f6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8035f9:	8b 52 04             	mov    0x4(%edx),%edx
  8035fc:	89 50 04             	mov    %edx,0x4(%eax)
  8035ff:	eb 0b                	jmp    80360c <alloc_block_FF+0x141>
  803601:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803604:	8b 40 04             	mov    0x4(%eax),%eax
  803607:	a3 3c 61 80 00       	mov    %eax,0x80613c
  80360c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80360f:	8b 40 04             	mov    0x4(%eax),%eax
  803612:	85 c0                	test   %eax,%eax
  803614:	74 0f                	je     803625 <alloc_block_FF+0x15a>
  803616:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803619:	8b 40 04             	mov    0x4(%eax),%eax
  80361c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80361f:	8b 12                	mov    (%edx),%edx
  803621:	89 10                	mov    %edx,(%eax)
  803623:	eb 0a                	jmp    80362f <alloc_block_FF+0x164>
  803625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803628:	8b 00                	mov    (%eax),%eax
  80362a:	a3 38 61 80 00       	mov    %eax,0x806138
  80362f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803632:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80363b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803642:	a1 44 61 80 00       	mov    0x806144,%eax
  803647:	48                   	dec    %eax
  803648:	a3 44 61 80 00       	mov    %eax,0x806144
                        return  pointertempp;
  80364d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803650:	eb 17                	jmp    803669 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  803652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803655:	8b 00                	mov    (%eax),%eax
  803657:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  80365a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80365e:	0f 85 7a fe ff ff    	jne    8034de <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  803664:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803669:	c9                   	leave  
  80366a:	c3                   	ret    

0080366b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80366b:	55                   	push   %ebp
  80366c:	89 e5                	mov    %esp,%ebp
  80366e:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  803671:	a1 38 61 80 00       	mov    0x806138,%eax
  803676:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  803679:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  803680:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  803687:	a1 38 61 80 00       	mov    0x806138,%eax
  80368c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80368f:	e9 d0 00 00 00       	jmp    803764 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  803694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803697:	8b 40 0c             	mov    0xc(%eax),%eax
  80369a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80369d:	0f 82 b8 00 00 00    	jb     80375b <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  8036a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8036a9:	2b 45 08             	sub    0x8(%ebp),%eax
  8036ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  8036af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036b2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8036b5:	0f 83 a1 00 00 00    	jae    80375c <alloc_block_BF+0xf1>
				differsize = differance ;
  8036bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8036be:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  8036c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  8036c7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8036cb:	0f 85 8b 00 00 00    	jne    80375c <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  8036d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d5:	75 17                	jne    8036ee <alloc_block_BF+0x83>
  8036d7:	83 ec 04             	sub    $0x4,%esp
  8036da:	68 a9 50 80 00       	push   $0x8050a9
  8036df:	68 a0 00 00 00       	push   $0xa0
  8036e4:	68 37 50 80 00       	push   $0x805037
  8036e9:	e8 3b dd ff ff       	call   801429 <_panic>
  8036ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036f1:	8b 00                	mov    (%eax),%eax
  8036f3:	85 c0                	test   %eax,%eax
  8036f5:	74 10                	je     803707 <alloc_block_BF+0x9c>
  8036f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036fa:	8b 00                	mov    (%eax),%eax
  8036fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8036ff:	8b 52 04             	mov    0x4(%edx),%edx
  803702:	89 50 04             	mov    %edx,0x4(%eax)
  803705:	eb 0b                	jmp    803712 <alloc_block_BF+0xa7>
  803707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80370a:	8b 40 04             	mov    0x4(%eax),%eax
  80370d:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803715:	8b 40 04             	mov    0x4(%eax),%eax
  803718:	85 c0                	test   %eax,%eax
  80371a:	74 0f                	je     80372b <alloc_block_BF+0xc0>
  80371c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371f:	8b 40 04             	mov    0x4(%eax),%eax
  803722:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803725:	8b 12                	mov    (%edx),%edx
  803727:	89 10                	mov    %edx,(%eax)
  803729:	eb 0a                	jmp    803735 <alloc_block_BF+0xca>
  80372b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80372e:	8b 00                	mov    (%eax),%eax
  803730:	a3 38 61 80 00       	mov    %eax,0x806138
  803735:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803738:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80373e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803741:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803748:	a1 44 61 80 00       	mov    0x806144,%eax
  80374d:	48                   	dec    %eax
  80374e:	a3 44 61 80 00       	mov    %eax,0x806144
					return elementiterator;
  803753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803756:	e9 0c 01 00 00       	jmp    803867 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  80375b:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80375c:	a1 40 61 80 00       	mov    0x806140,%eax
  803761:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803764:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803768:	74 07                	je     803771 <alloc_block_BF+0x106>
  80376a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80376d:	8b 00                	mov    (%eax),%eax
  80376f:	eb 05                	jmp    803776 <alloc_block_BF+0x10b>
  803771:	b8 00 00 00 00       	mov    $0x0,%eax
  803776:	a3 40 61 80 00       	mov    %eax,0x806140
  80377b:	a1 40 61 80 00       	mov    0x806140,%eax
  803780:	85 c0                	test   %eax,%eax
  803782:	0f 85 0c ff ff ff    	jne    803694 <alloc_block_BF+0x29>
  803788:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80378c:	0f 85 02 ff ff ff    	jne    803694 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  803792:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  803796:	0f 84 c6 00 00 00    	je     803862 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  80379c:	a1 48 61 80 00       	mov    0x806148,%eax
  8037a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  8037a4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8037aa:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  8037ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037b0:	8b 50 08             	mov    0x8(%eax),%edx
  8037b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037b6:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  8037b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8037bf:	2b 45 08             	sub    0x8(%ebp),%eax
  8037c2:	89 c2                	mov    %eax,%edx
  8037c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037c7:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  8037ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037cd:	8b 50 08             	mov    0x8(%eax),%edx
  8037d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8037d3:	01 c2                	add    %eax,%edx
  8037d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8037d8:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  8037db:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8037df:	75 17                	jne    8037f8 <alloc_block_BF+0x18d>
  8037e1:	83 ec 04             	sub    $0x4,%esp
  8037e4:	68 a9 50 80 00       	push   $0x8050a9
  8037e9:	68 af 00 00 00       	push   $0xaf
  8037ee:	68 37 50 80 00       	push   $0x805037
  8037f3:	e8 31 dc ff ff       	call   801429 <_panic>
  8037f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8037fb:	8b 00                	mov    (%eax),%eax
  8037fd:	85 c0                	test   %eax,%eax
  8037ff:	74 10                	je     803811 <alloc_block_BF+0x1a6>
  803801:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803804:	8b 00                	mov    (%eax),%eax
  803806:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803809:	8b 52 04             	mov    0x4(%edx),%edx
  80380c:	89 50 04             	mov    %edx,0x4(%eax)
  80380f:	eb 0b                	jmp    80381c <alloc_block_BF+0x1b1>
  803811:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803814:	8b 40 04             	mov    0x4(%eax),%eax
  803817:	a3 4c 61 80 00       	mov    %eax,0x80614c
  80381c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80381f:	8b 40 04             	mov    0x4(%eax),%eax
  803822:	85 c0                	test   %eax,%eax
  803824:	74 0f                	je     803835 <alloc_block_BF+0x1ca>
  803826:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803829:	8b 40 04             	mov    0x4(%eax),%eax
  80382c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80382f:	8b 12                	mov    (%edx),%edx
  803831:	89 10                	mov    %edx,(%eax)
  803833:	eb 0a                	jmp    80383f <alloc_block_BF+0x1d4>
  803835:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803838:	8b 00                	mov    (%eax),%eax
  80383a:	a3 48 61 80 00       	mov    %eax,0x806148
  80383f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803842:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803848:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80384b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803852:	a1 54 61 80 00       	mov    0x806154,%eax
  803857:	48                   	dec    %eax
  803858:	a3 54 61 80 00       	mov    %eax,0x806154
		return blockToUpdate;
  80385d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803860:	eb 05                	jmp    803867 <alloc_block_BF+0x1fc>
	}

	return NULL;
  803862:	b8 00 00 00 00       	mov    $0x0,%eax
}
  803867:	c9                   	leave  
  803868:	c3                   	ret    

00803869 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  803869:	55                   	push   %ebp
  80386a:	89 e5                	mov    %esp,%ebp
  80386c:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  80386f:	a1 38 61 80 00       	mov    0x806138,%eax
  803874:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  803877:	e9 7c 01 00 00       	jmp    8039f8 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  80387c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80387f:	8b 40 0c             	mov    0xc(%eax),%eax
  803882:	3b 45 08             	cmp    0x8(%ebp),%eax
  803885:	0f 86 cf 00 00 00    	jbe    80395a <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80388b:	a1 48 61 80 00       	mov    0x806148,%eax
  803890:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  803893:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803896:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  803899:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80389c:	8b 55 08             	mov    0x8(%ebp),%edx
  80389f:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  8038a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038a5:	8b 50 08             	mov    0x8(%eax),%edx
  8038a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038ab:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  8038ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8038b4:	2b 45 08             	sub    0x8(%ebp),%eax
  8038b7:	89 c2                	mov    %eax,%edx
  8038b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038bc:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  8038bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038c2:	8b 50 08             	mov    0x8(%eax),%edx
  8038c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8038c8:	01 c2                	add    %eax,%edx
  8038ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8038cd:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8038d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8038d4:	75 17                	jne    8038ed <alloc_block_NF+0x84>
  8038d6:	83 ec 04             	sub    $0x4,%esp
  8038d9:	68 a9 50 80 00       	push   $0x8050a9
  8038de:	68 c4 00 00 00       	push   $0xc4
  8038e3:	68 37 50 80 00       	push   $0x805037
  8038e8:	e8 3c db ff ff       	call   801429 <_panic>
  8038ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038f0:	8b 00                	mov    (%eax),%eax
  8038f2:	85 c0                	test   %eax,%eax
  8038f4:	74 10                	je     803906 <alloc_block_NF+0x9d>
  8038f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8038f9:	8b 00                	mov    (%eax),%eax
  8038fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8038fe:	8b 52 04             	mov    0x4(%edx),%edx
  803901:	89 50 04             	mov    %edx,0x4(%eax)
  803904:	eb 0b                	jmp    803911 <alloc_block_NF+0xa8>
  803906:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803909:	8b 40 04             	mov    0x4(%eax),%eax
  80390c:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803911:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803914:	8b 40 04             	mov    0x4(%eax),%eax
  803917:	85 c0                	test   %eax,%eax
  803919:	74 0f                	je     80392a <alloc_block_NF+0xc1>
  80391b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80391e:	8b 40 04             	mov    0x4(%eax),%eax
  803921:	8b 55 ec             	mov    -0x14(%ebp),%edx
  803924:	8b 12                	mov    (%edx),%edx
  803926:	89 10                	mov    %edx,(%eax)
  803928:	eb 0a                	jmp    803934 <alloc_block_NF+0xcb>
  80392a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80392d:	8b 00                	mov    (%eax),%eax
  80392f:	a3 48 61 80 00       	mov    %eax,0x806148
  803934:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803937:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80393d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803940:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803947:	a1 54 61 80 00       	mov    0x806154,%eax
  80394c:	48                   	dec    %eax
  80394d:	a3 54 61 80 00       	mov    %eax,0x806154
	                    return newBlock ;
  803952:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803955:	e9 ad 00 00 00       	jmp    803a07 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  80395a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80395d:	8b 40 0c             	mov    0xc(%eax),%eax
  803960:	3b 45 08             	cmp    0x8(%ebp),%eax
  803963:	0f 85 87 00 00 00    	jne    8039f0 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  803969:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80396d:	75 17                	jne    803986 <alloc_block_NF+0x11d>
  80396f:	83 ec 04             	sub    $0x4,%esp
  803972:	68 a9 50 80 00       	push   $0x8050a9
  803977:	68 c8 00 00 00       	push   $0xc8
  80397c:	68 37 50 80 00       	push   $0x805037
  803981:	e8 a3 da ff ff       	call   801429 <_panic>
  803986:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803989:	8b 00                	mov    (%eax),%eax
  80398b:	85 c0                	test   %eax,%eax
  80398d:	74 10                	je     80399f <alloc_block_NF+0x136>
  80398f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803992:	8b 00                	mov    (%eax),%eax
  803994:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803997:	8b 52 04             	mov    0x4(%edx),%edx
  80399a:	89 50 04             	mov    %edx,0x4(%eax)
  80399d:	eb 0b                	jmp    8039aa <alloc_block_NF+0x141>
  80399f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039a2:	8b 40 04             	mov    0x4(%eax),%eax
  8039a5:	a3 3c 61 80 00       	mov    %eax,0x80613c
  8039aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ad:	8b 40 04             	mov    0x4(%eax),%eax
  8039b0:	85 c0                	test   %eax,%eax
  8039b2:	74 0f                	je     8039c3 <alloc_block_NF+0x15a>
  8039b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039b7:	8b 40 04             	mov    0x4(%eax),%eax
  8039ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8039bd:	8b 12                	mov    (%edx),%edx
  8039bf:	89 10                	mov    %edx,(%eax)
  8039c1:	eb 0a                	jmp    8039cd <alloc_block_NF+0x164>
  8039c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039c6:	8b 00                	mov    (%eax),%eax
  8039c8:	a3 38 61 80 00       	mov    %eax,0x806138
  8039cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8039d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8039e0:	a1 44 61 80 00       	mov    0x806144,%eax
  8039e5:	48                   	dec    %eax
  8039e6:	a3 44 61 80 00       	mov    %eax,0x806144
	                        return  updated;
  8039eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039ee:	eb 17                	jmp    803a07 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  8039f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8039f3:	8b 00                	mov    (%eax),%eax
  8039f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  8039f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8039fc:	0f 85 7a fe ff ff    	jne    80387c <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  803a02:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803a07:	c9                   	leave  
  803a08:	c3                   	ret    

00803a09 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803a09:	55                   	push   %ebp
  803a0a:	89 e5                	mov    %esp,%ebp
  803a0c:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  803a0f:	a1 38 61 80 00       	mov    0x806138,%eax
  803a14:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  803a17:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  803a1f:	a1 44 61 80 00       	mov    0x806144,%eax
  803a24:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  803a27:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803a2b:	75 68                	jne    803a95 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  803a2d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803a31:	75 17                	jne    803a4a <insert_sorted_with_merge_freeList+0x41>
  803a33:	83 ec 04             	sub    $0x4,%esp
  803a36:	68 14 50 80 00       	push   $0x805014
  803a3b:	68 da 00 00 00       	push   $0xda
  803a40:	68 37 50 80 00       	push   $0x805037
  803a45:	e8 df d9 ff ff       	call   801429 <_panic>
  803a4a:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803a50:	8b 45 08             	mov    0x8(%ebp),%eax
  803a53:	89 10                	mov    %edx,(%eax)
  803a55:	8b 45 08             	mov    0x8(%ebp),%eax
  803a58:	8b 00                	mov    (%eax),%eax
  803a5a:	85 c0                	test   %eax,%eax
  803a5c:	74 0d                	je     803a6b <insert_sorted_with_merge_freeList+0x62>
  803a5e:	a1 38 61 80 00       	mov    0x806138,%eax
  803a63:	8b 55 08             	mov    0x8(%ebp),%edx
  803a66:	89 50 04             	mov    %edx,0x4(%eax)
  803a69:	eb 08                	jmp    803a73 <insert_sorted_with_merge_freeList+0x6a>
  803a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a6e:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803a73:	8b 45 08             	mov    0x8(%ebp),%eax
  803a76:	a3 38 61 80 00       	mov    %eax,0x806138
  803a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  803a7e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803a85:	a1 44 61 80 00       	mov    0x806144,%eax
  803a8a:	40                   	inc    %eax
  803a8b:	a3 44 61 80 00       	mov    %eax,0x806144



	}
	}
	}
  803a90:	e9 49 07 00 00       	jmp    8041de <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  803a95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a98:	8b 50 08             	mov    0x8(%eax),%edx
  803a9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803a9e:	8b 40 0c             	mov    0xc(%eax),%eax
  803aa1:	01 c2                	add    %eax,%edx
  803aa3:	8b 45 08             	mov    0x8(%ebp),%eax
  803aa6:	8b 40 08             	mov    0x8(%eax),%eax
  803aa9:	39 c2                	cmp    %eax,%edx
  803aab:	73 77                	jae    803b24 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  803aad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803ab0:	8b 00                	mov    (%eax),%eax
  803ab2:	85 c0                	test   %eax,%eax
  803ab4:	75 6e                	jne    803b24 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  803ab6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803aba:	74 68                	je     803b24 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  803abc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ac0:	75 17                	jne    803ad9 <insert_sorted_with_merge_freeList+0xd0>
  803ac2:	83 ec 04             	sub    $0x4,%esp
  803ac5:	68 50 50 80 00       	push   $0x805050
  803aca:	68 e0 00 00 00       	push   $0xe0
  803acf:	68 37 50 80 00       	push   $0x805037
  803ad4:	e8 50 d9 ff ff       	call   801429 <_panic>
  803ad9:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  803adf:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae2:	89 50 04             	mov    %edx,0x4(%eax)
  803ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  803ae8:	8b 40 04             	mov    0x4(%eax),%eax
  803aeb:	85 c0                	test   %eax,%eax
  803aed:	74 0c                	je     803afb <insert_sorted_with_merge_freeList+0xf2>
  803aef:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803af4:	8b 55 08             	mov    0x8(%ebp),%edx
  803af7:	89 10                	mov    %edx,(%eax)
  803af9:	eb 08                	jmp    803b03 <insert_sorted_with_merge_freeList+0xfa>
  803afb:	8b 45 08             	mov    0x8(%ebp),%eax
  803afe:	a3 38 61 80 00       	mov    %eax,0x806138
  803b03:	8b 45 08             	mov    0x8(%ebp),%eax
  803b06:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803b0e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803b14:	a1 44 61 80 00       	mov    0x806144,%eax
  803b19:	40                   	inc    %eax
  803b1a:	a3 44 61 80 00       	mov    %eax,0x806144
  803b1f:	e9 ba 06 00 00       	jmp    8041de <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  803b24:	8b 45 08             	mov    0x8(%ebp),%eax
  803b27:	8b 50 0c             	mov    0xc(%eax),%edx
  803b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b2d:	8b 40 08             	mov    0x8(%eax),%eax
  803b30:	01 c2                	add    %eax,%edx
  803b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b35:	8b 40 08             	mov    0x8(%eax),%eax
  803b38:	39 c2                	cmp    %eax,%edx
  803b3a:	73 78                	jae    803bb4 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  803b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803b3f:	8b 40 04             	mov    0x4(%eax),%eax
  803b42:	85 c0                	test   %eax,%eax
  803b44:	75 6e                	jne    803bb4 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  803b46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803b4a:	74 68                	je     803bb4 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  803b4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803b50:	75 17                	jne    803b69 <insert_sorted_with_merge_freeList+0x160>
  803b52:	83 ec 04             	sub    $0x4,%esp
  803b55:	68 14 50 80 00       	push   $0x805014
  803b5a:	68 e6 00 00 00       	push   $0xe6
  803b5f:	68 37 50 80 00       	push   $0x805037
  803b64:	e8 c0 d8 ff ff       	call   801429 <_panic>
  803b69:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  803b72:	89 10                	mov    %edx,(%eax)
  803b74:	8b 45 08             	mov    0x8(%ebp),%eax
  803b77:	8b 00                	mov    (%eax),%eax
  803b79:	85 c0                	test   %eax,%eax
  803b7b:	74 0d                	je     803b8a <insert_sorted_with_merge_freeList+0x181>
  803b7d:	a1 38 61 80 00       	mov    0x806138,%eax
  803b82:	8b 55 08             	mov    0x8(%ebp),%edx
  803b85:	89 50 04             	mov    %edx,0x4(%eax)
  803b88:	eb 08                	jmp    803b92 <insert_sorted_with_merge_freeList+0x189>
  803b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b8d:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803b92:	8b 45 08             	mov    0x8(%ebp),%eax
  803b95:	a3 38 61 80 00       	mov    %eax,0x806138
  803b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  803b9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803ba4:	a1 44 61 80 00       	mov    0x806144,%eax
  803ba9:	40                   	inc    %eax
  803baa:	a3 44 61 80 00       	mov    %eax,0x806144
  803baf:	e9 2a 06 00 00       	jmp    8041de <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803bb4:	a1 38 61 80 00       	mov    0x806138,%eax
  803bb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803bbc:	e9 ed 05 00 00       	jmp    8041ae <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  803bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bc4:	8b 00                	mov    (%eax),%eax
  803bc6:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  803bc9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803bcd:	0f 84 a7 00 00 00    	je     803c7a <insert_sorted_with_merge_freeList+0x271>
  803bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bd6:	8b 50 0c             	mov    0xc(%eax),%edx
  803bd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803bdc:	8b 40 08             	mov    0x8(%eax),%eax
  803bdf:	01 c2                	add    %eax,%edx
  803be1:	8b 45 08             	mov    0x8(%ebp),%eax
  803be4:	8b 40 08             	mov    0x8(%eax),%eax
  803be7:	39 c2                	cmp    %eax,%edx
  803be9:	0f 83 8b 00 00 00    	jae    803c7a <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  803bef:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf2:	8b 50 0c             	mov    0xc(%eax),%edx
  803bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  803bf8:	8b 40 08             	mov    0x8(%eax),%eax
  803bfb:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  803bfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803c00:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  803c03:	39 c2                	cmp    %eax,%edx
  803c05:	73 73                	jae    803c7a <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  803c07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803c0b:	74 06                	je     803c13 <insert_sorted_with_merge_freeList+0x20a>
  803c0d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803c11:	75 17                	jne    803c2a <insert_sorted_with_merge_freeList+0x221>
  803c13:	83 ec 04             	sub    $0x4,%esp
  803c16:	68 c8 50 80 00       	push   $0x8050c8
  803c1b:	68 f0 00 00 00       	push   $0xf0
  803c20:	68 37 50 80 00       	push   $0x805037
  803c25:	e8 ff d7 ff ff       	call   801429 <_panic>
  803c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c2d:	8b 10                	mov    (%eax),%edx
  803c2f:	8b 45 08             	mov    0x8(%ebp),%eax
  803c32:	89 10                	mov    %edx,(%eax)
  803c34:	8b 45 08             	mov    0x8(%ebp),%eax
  803c37:	8b 00                	mov    (%eax),%eax
  803c39:	85 c0                	test   %eax,%eax
  803c3b:	74 0b                	je     803c48 <insert_sorted_with_merge_freeList+0x23f>
  803c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c40:	8b 00                	mov    (%eax),%eax
  803c42:	8b 55 08             	mov    0x8(%ebp),%edx
  803c45:	89 50 04             	mov    %edx,0x4(%eax)
  803c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803c4b:	8b 55 08             	mov    0x8(%ebp),%edx
  803c4e:	89 10                	mov    %edx,(%eax)
  803c50:	8b 45 08             	mov    0x8(%ebp),%eax
  803c53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803c56:	89 50 04             	mov    %edx,0x4(%eax)
  803c59:	8b 45 08             	mov    0x8(%ebp),%eax
  803c5c:	8b 00                	mov    (%eax),%eax
  803c5e:	85 c0                	test   %eax,%eax
  803c60:	75 08                	jne    803c6a <insert_sorted_with_merge_freeList+0x261>
  803c62:	8b 45 08             	mov    0x8(%ebp),%eax
  803c65:	a3 3c 61 80 00       	mov    %eax,0x80613c
  803c6a:	a1 44 61 80 00       	mov    0x806144,%eax
  803c6f:	40                   	inc    %eax
  803c70:	a3 44 61 80 00       	mov    %eax,0x806144

		         break;
  803c75:	e9 64 05 00 00       	jmp    8041de <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  803c7a:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803c7f:	8b 50 0c             	mov    0xc(%eax),%edx
  803c82:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803c87:	8b 40 08             	mov    0x8(%eax),%eax
  803c8a:	01 c2                	add    %eax,%edx
  803c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  803c8f:	8b 40 08             	mov    0x8(%eax),%eax
  803c92:	39 c2                	cmp    %eax,%edx
  803c94:	0f 85 b1 00 00 00    	jne    803d4b <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  803c9a:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803c9f:	85 c0                	test   %eax,%eax
  803ca1:	0f 84 a4 00 00 00    	je     803d4b <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  803ca7:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803cac:	8b 00                	mov    (%eax),%eax
  803cae:	85 c0                	test   %eax,%eax
  803cb0:	0f 85 95 00 00 00    	jne    803d4b <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803cb6:	a1 3c 61 80 00       	mov    0x80613c,%eax
  803cbb:	8b 15 3c 61 80 00    	mov    0x80613c,%edx
  803cc1:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803cc4:	8b 55 08             	mov    0x8(%ebp),%edx
  803cc7:	8b 52 0c             	mov    0xc(%edx),%edx
  803cca:	01 ca                	add    %ecx,%edx
  803ccc:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  803ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  803cd2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  803cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  803cdc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803ce3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803ce7:	75 17                	jne    803d00 <insert_sorted_with_merge_freeList+0x2f7>
  803ce9:	83 ec 04             	sub    $0x4,%esp
  803cec:	68 14 50 80 00       	push   $0x805014
  803cf1:	68 ff 00 00 00       	push   $0xff
  803cf6:	68 37 50 80 00       	push   $0x805037
  803cfb:	e8 29 d7 ff ff       	call   801429 <_panic>
  803d00:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803d06:	8b 45 08             	mov    0x8(%ebp),%eax
  803d09:	89 10                	mov    %edx,(%eax)
  803d0b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d0e:	8b 00                	mov    (%eax),%eax
  803d10:	85 c0                	test   %eax,%eax
  803d12:	74 0d                	je     803d21 <insert_sorted_with_merge_freeList+0x318>
  803d14:	a1 48 61 80 00       	mov    0x806148,%eax
  803d19:	8b 55 08             	mov    0x8(%ebp),%edx
  803d1c:	89 50 04             	mov    %edx,0x4(%eax)
  803d1f:	eb 08                	jmp    803d29 <insert_sorted_with_merge_freeList+0x320>
  803d21:	8b 45 08             	mov    0x8(%ebp),%eax
  803d24:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803d29:	8b 45 08             	mov    0x8(%ebp),%eax
  803d2c:	a3 48 61 80 00       	mov    %eax,0x806148
  803d31:	8b 45 08             	mov    0x8(%ebp),%eax
  803d34:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803d3b:	a1 54 61 80 00       	mov    0x806154,%eax
  803d40:	40                   	inc    %eax
  803d41:	a3 54 61 80 00       	mov    %eax,0x806154

	break;
  803d46:	e9 93 04 00 00       	jmp    8041de <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  803d4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d4e:	8b 50 08             	mov    0x8(%eax),%edx
  803d51:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d54:	8b 40 0c             	mov    0xc(%eax),%eax
  803d57:	01 c2                	add    %eax,%edx
  803d59:	8b 45 08             	mov    0x8(%ebp),%eax
  803d5c:	8b 40 08             	mov    0x8(%eax),%eax
  803d5f:	39 c2                	cmp    %eax,%edx
  803d61:	0f 85 ae 00 00 00    	jne    803e15 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  803d67:	8b 45 08             	mov    0x8(%ebp),%eax
  803d6a:	8b 50 0c             	mov    0xc(%eax),%edx
  803d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  803d70:	8b 40 08             	mov    0x8(%eax),%eax
  803d73:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  803d75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d78:	8b 00                	mov    (%eax),%eax
  803d7a:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803d7d:	39 c2                	cmp    %eax,%edx
  803d7f:	0f 84 90 00 00 00    	je     803e15 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  803d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d88:	8b 50 0c             	mov    0xc(%eax),%edx
  803d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  803d8e:	8b 40 0c             	mov    0xc(%eax),%eax
  803d91:	01 c2                	add    %eax,%edx
  803d93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803d96:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803d99:	8b 45 08             	mov    0x8(%ebp),%eax
  803d9c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803da3:	8b 45 08             	mov    0x8(%ebp),%eax
  803da6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803dad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803db1:	75 17                	jne    803dca <insert_sorted_with_merge_freeList+0x3c1>
  803db3:	83 ec 04             	sub    $0x4,%esp
  803db6:	68 14 50 80 00       	push   $0x805014
  803dbb:	68 0b 01 00 00       	push   $0x10b
  803dc0:	68 37 50 80 00       	push   $0x805037
  803dc5:	e8 5f d6 ff ff       	call   801429 <_panic>
  803dca:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd3:	89 10                	mov    %edx,(%eax)
  803dd5:	8b 45 08             	mov    0x8(%ebp),%eax
  803dd8:	8b 00                	mov    (%eax),%eax
  803dda:	85 c0                	test   %eax,%eax
  803ddc:	74 0d                	je     803deb <insert_sorted_with_merge_freeList+0x3e2>
  803dde:	a1 48 61 80 00       	mov    0x806148,%eax
  803de3:	8b 55 08             	mov    0x8(%ebp),%edx
  803de6:	89 50 04             	mov    %edx,0x4(%eax)
  803de9:	eb 08                	jmp    803df3 <insert_sorted_with_merge_freeList+0x3ea>
  803deb:	8b 45 08             	mov    0x8(%ebp),%eax
  803dee:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803df3:	8b 45 08             	mov    0x8(%ebp),%eax
  803df6:	a3 48 61 80 00       	mov    %eax,0x806148
  803dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  803dfe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803e05:	a1 54 61 80 00       	mov    0x806154,%eax
  803e0a:	40                   	inc    %eax
  803e0b:	a3 54 61 80 00       	mov    %eax,0x806154

		break;
  803e10:	e9 c9 03 00 00       	jmp    8041de <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803e15:	8b 45 08             	mov    0x8(%ebp),%eax
  803e18:	8b 50 0c             	mov    0xc(%eax),%edx
  803e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  803e1e:	8b 40 08             	mov    0x8(%eax),%eax
  803e21:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  803e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e26:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803e29:	39 c2                	cmp    %eax,%edx
  803e2b:	0f 85 bb 00 00 00    	jne    803eec <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  803e31:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803e35:	0f 84 b1 00 00 00    	je     803eec <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  803e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803e3e:	8b 40 04             	mov    0x4(%eax),%eax
  803e41:	85 c0                	test   %eax,%eax
  803e43:	0f 85 a3 00 00 00    	jne    803eec <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803e49:	a1 38 61 80 00       	mov    0x806138,%eax
  803e4e:	8b 55 08             	mov    0x8(%ebp),%edx
  803e51:	8b 52 08             	mov    0x8(%edx),%edx
  803e54:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  803e57:	a1 38 61 80 00       	mov    0x806138,%eax
  803e5c:	8b 15 38 61 80 00    	mov    0x806138,%edx
  803e62:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803e65:	8b 55 08             	mov    0x8(%ebp),%edx
  803e68:	8b 52 0c             	mov    0xc(%edx),%edx
  803e6b:	01 ca                	add    %ecx,%edx
  803e6d:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803e70:	8b 45 08             	mov    0x8(%ebp),%eax
  803e73:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  803e7d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803e88:	75 17                	jne    803ea1 <insert_sorted_with_merge_freeList+0x498>
  803e8a:	83 ec 04             	sub    $0x4,%esp
  803e8d:	68 14 50 80 00       	push   $0x805014
  803e92:	68 17 01 00 00       	push   $0x117
  803e97:	68 37 50 80 00       	push   $0x805037
  803e9c:	e8 88 d5 ff ff       	call   801429 <_panic>
  803ea1:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  803eaa:	89 10                	mov    %edx,(%eax)
  803eac:	8b 45 08             	mov    0x8(%ebp),%eax
  803eaf:	8b 00                	mov    (%eax),%eax
  803eb1:	85 c0                	test   %eax,%eax
  803eb3:	74 0d                	je     803ec2 <insert_sorted_with_merge_freeList+0x4b9>
  803eb5:	a1 48 61 80 00       	mov    0x806148,%eax
  803eba:	8b 55 08             	mov    0x8(%ebp),%edx
  803ebd:	89 50 04             	mov    %edx,0x4(%eax)
  803ec0:	eb 08                	jmp    803eca <insert_sorted_with_merge_freeList+0x4c1>
  803ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ec5:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803eca:	8b 45 08             	mov    0x8(%ebp),%eax
  803ecd:	a3 48 61 80 00       	mov    %eax,0x806148
  803ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ed5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803edc:	a1 54 61 80 00       	mov    0x806154,%eax
  803ee1:	40                   	inc    %eax
  803ee2:	a3 54 61 80 00       	mov    %eax,0x806154

		break;
  803ee7:	e9 f2 02 00 00       	jmp    8041de <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  803eec:	8b 45 08             	mov    0x8(%ebp),%eax
  803eef:	8b 50 08             	mov    0x8(%eax),%edx
  803ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  803ef5:	8b 40 0c             	mov    0xc(%eax),%eax
  803ef8:	01 c2                	add    %eax,%edx
  803efa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803efd:	8b 40 08             	mov    0x8(%eax),%eax
  803f00:	39 c2                	cmp    %eax,%edx
  803f02:	0f 85 be 00 00 00    	jne    803fc6 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f0b:	8b 40 04             	mov    0x4(%eax),%eax
  803f0e:	8b 50 08             	mov    0x8(%eax),%edx
  803f11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f14:	8b 40 04             	mov    0x4(%eax),%eax
  803f17:	8b 40 0c             	mov    0xc(%eax),%eax
  803f1a:	01 c2                	add    %eax,%edx
  803f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f1f:	8b 40 08             	mov    0x8(%eax),%eax
  803f22:	39 c2                	cmp    %eax,%edx
  803f24:	0f 84 9c 00 00 00    	je     803fc6 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  803f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f2d:	8b 50 08             	mov    0x8(%eax),%edx
  803f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f33:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  803f36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f39:	8b 50 0c             	mov    0xc(%eax),%edx
  803f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f3f:	8b 40 0c             	mov    0xc(%eax),%eax
  803f42:	01 c2                	add    %eax,%edx
  803f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803f47:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  803f4d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803f54:	8b 45 08             	mov    0x8(%ebp),%eax
  803f57:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803f5e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803f62:	75 17                	jne    803f7b <insert_sorted_with_merge_freeList+0x572>
  803f64:	83 ec 04             	sub    $0x4,%esp
  803f67:	68 14 50 80 00       	push   $0x805014
  803f6c:	68 26 01 00 00       	push   $0x126
  803f71:	68 37 50 80 00       	push   $0x805037
  803f76:	e8 ae d4 ff ff       	call   801429 <_panic>
  803f7b:	8b 15 48 61 80 00    	mov    0x806148,%edx
  803f81:	8b 45 08             	mov    0x8(%ebp),%eax
  803f84:	89 10                	mov    %edx,(%eax)
  803f86:	8b 45 08             	mov    0x8(%ebp),%eax
  803f89:	8b 00                	mov    (%eax),%eax
  803f8b:	85 c0                	test   %eax,%eax
  803f8d:	74 0d                	je     803f9c <insert_sorted_with_merge_freeList+0x593>
  803f8f:	a1 48 61 80 00       	mov    0x806148,%eax
  803f94:	8b 55 08             	mov    0x8(%ebp),%edx
  803f97:	89 50 04             	mov    %edx,0x4(%eax)
  803f9a:	eb 08                	jmp    803fa4 <insert_sorted_with_merge_freeList+0x59b>
  803f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  803f9f:	a3 4c 61 80 00       	mov    %eax,0x80614c
  803fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  803fa7:	a3 48 61 80 00       	mov    %eax,0x806148
  803fac:	8b 45 08             	mov    0x8(%ebp),%eax
  803faf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803fb6:	a1 54 61 80 00       	mov    0x806154,%eax
  803fbb:	40                   	inc    %eax
  803fbc:	a3 54 61 80 00       	mov    %eax,0x806154

		break;//8
  803fc1:	e9 18 02 00 00       	jmp    8041de <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803fc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fc9:	8b 50 0c             	mov    0xc(%eax),%edx
  803fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803fcf:	8b 40 08             	mov    0x8(%eax),%eax
  803fd2:	01 c2                	add    %eax,%edx
  803fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  803fd7:	8b 40 08             	mov    0x8(%eax),%eax
  803fda:	39 c2                	cmp    %eax,%edx
  803fdc:	0f 85 c4 01 00 00    	jne    8041a6 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  803fe5:	8b 50 0c             	mov    0xc(%eax),%edx
  803fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  803feb:	8b 40 08             	mov    0x8(%eax),%eax
  803fee:	01 c2                	add    %eax,%edx
  803ff0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803ff3:	8b 00                	mov    (%eax),%eax
  803ff5:	8b 40 08             	mov    0x8(%eax),%eax
  803ff8:	39 c2                	cmp    %eax,%edx
  803ffa:	0f 85 a6 01 00 00    	jne    8041a6 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  804000:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  804004:	0f 84 9c 01 00 00    	je     8041a6 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  80400a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80400d:	8b 50 0c             	mov    0xc(%eax),%edx
  804010:	8b 45 08             	mov    0x8(%ebp),%eax
  804013:	8b 40 0c             	mov    0xc(%eax),%eax
  804016:	01 c2                	add    %eax,%edx
  804018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80401b:	8b 00                	mov    (%eax),%eax
  80401d:	8b 40 0c             	mov    0xc(%eax),%eax
  804020:	01 c2                	add    %eax,%edx
  804022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  804025:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  804028:	8b 45 08             	mov    0x8(%ebp),%eax
  80402b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  804032:	8b 45 08             	mov    0x8(%ebp),%eax
  804035:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  80403c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  804040:	75 17                	jne    804059 <insert_sorted_with_merge_freeList+0x650>
  804042:	83 ec 04             	sub    $0x4,%esp
  804045:	68 14 50 80 00       	push   $0x805014
  80404a:	68 32 01 00 00       	push   $0x132
  80404f:	68 37 50 80 00       	push   $0x805037
  804054:	e8 d0 d3 ff ff       	call   801429 <_panic>
  804059:	8b 15 48 61 80 00    	mov    0x806148,%edx
  80405f:	8b 45 08             	mov    0x8(%ebp),%eax
  804062:	89 10                	mov    %edx,(%eax)
  804064:	8b 45 08             	mov    0x8(%ebp),%eax
  804067:	8b 00                	mov    (%eax),%eax
  804069:	85 c0                	test   %eax,%eax
  80406b:	74 0d                	je     80407a <insert_sorted_with_merge_freeList+0x671>
  80406d:	a1 48 61 80 00       	mov    0x806148,%eax
  804072:	8b 55 08             	mov    0x8(%ebp),%edx
  804075:	89 50 04             	mov    %edx,0x4(%eax)
  804078:	eb 08                	jmp    804082 <insert_sorted_with_merge_freeList+0x679>
  80407a:	8b 45 08             	mov    0x8(%ebp),%eax
  80407d:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804082:	8b 45 08             	mov    0x8(%ebp),%eax
  804085:	a3 48 61 80 00       	mov    %eax,0x806148
  80408a:	8b 45 08             	mov    0x8(%ebp),%eax
  80408d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804094:	a1 54 61 80 00       	mov    0x806154,%eax
  804099:	40                   	inc    %eax
  80409a:	a3 54 61 80 00       	mov    %eax,0x806154
	    ptr->prev_next_info.le_next->sva = 0;
  80409f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040a2:	8b 00                	mov    (%eax),%eax
  8040a4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  8040ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040ae:	8b 00                	mov    (%eax),%eax
  8040b0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  8040b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8040ba:	8b 00                	mov    (%eax),%eax
  8040bc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  8040bf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8040c3:	75 17                	jne    8040dc <insert_sorted_with_merge_freeList+0x6d3>
  8040c5:	83 ec 04             	sub    $0x4,%esp
  8040c8:	68 a9 50 80 00       	push   $0x8050a9
  8040cd:	68 36 01 00 00       	push   $0x136
  8040d2:	68 37 50 80 00       	push   $0x805037
  8040d7:	e8 4d d3 ff ff       	call   801429 <_panic>
  8040dc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040df:	8b 00                	mov    (%eax),%eax
  8040e1:	85 c0                	test   %eax,%eax
  8040e3:	74 10                	je     8040f5 <insert_sorted_with_merge_freeList+0x6ec>
  8040e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040e8:	8b 00                	mov    (%eax),%eax
  8040ea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8040ed:	8b 52 04             	mov    0x4(%edx),%edx
  8040f0:	89 50 04             	mov    %edx,0x4(%eax)
  8040f3:	eb 0b                	jmp    804100 <insert_sorted_with_merge_freeList+0x6f7>
  8040f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8040f8:	8b 40 04             	mov    0x4(%eax),%eax
  8040fb:	a3 3c 61 80 00       	mov    %eax,0x80613c
  804100:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804103:	8b 40 04             	mov    0x4(%eax),%eax
  804106:	85 c0                	test   %eax,%eax
  804108:	74 0f                	je     804119 <insert_sorted_with_merge_freeList+0x710>
  80410a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80410d:	8b 40 04             	mov    0x4(%eax),%eax
  804110:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  804113:	8b 12                	mov    (%edx),%edx
  804115:	89 10                	mov    %edx,(%eax)
  804117:	eb 0a                	jmp    804123 <insert_sorted_with_merge_freeList+0x71a>
  804119:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80411c:	8b 00                	mov    (%eax),%eax
  80411e:	a3 38 61 80 00       	mov    %eax,0x806138
  804123:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804126:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80412c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80412f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804136:	a1 44 61 80 00       	mov    0x806144,%eax
  80413b:	48                   	dec    %eax
  80413c:	a3 44 61 80 00       	mov    %eax,0x806144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  804141:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  804145:	75 17                	jne    80415e <insert_sorted_with_merge_freeList+0x755>
  804147:	83 ec 04             	sub    $0x4,%esp
  80414a:	68 14 50 80 00       	push   $0x805014
  80414f:	68 37 01 00 00       	push   $0x137
  804154:	68 37 50 80 00       	push   $0x805037
  804159:	e8 cb d2 ff ff       	call   801429 <_panic>
  80415e:	8b 15 48 61 80 00    	mov    0x806148,%edx
  804164:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804167:	89 10                	mov    %edx,(%eax)
  804169:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80416c:	8b 00                	mov    (%eax),%eax
  80416e:	85 c0                	test   %eax,%eax
  804170:	74 0d                	je     80417f <insert_sorted_with_merge_freeList+0x776>
  804172:	a1 48 61 80 00       	mov    0x806148,%eax
  804177:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80417a:	89 50 04             	mov    %edx,0x4(%eax)
  80417d:	eb 08                	jmp    804187 <insert_sorted_with_merge_freeList+0x77e>
  80417f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804182:	a3 4c 61 80 00       	mov    %eax,0x80614c
  804187:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80418a:	a3 48 61 80 00       	mov    %eax,0x806148
  80418f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  804192:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  804199:	a1 54 61 80 00       	mov    0x806154,%eax
  80419e:	40                   	inc    %eax
  80419f:	a3 54 61 80 00       	mov    %eax,0x806154

	    break;//9
  8041a4:	eb 38                	jmp    8041de <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8041a6:	a1 40 61 80 00       	mov    0x806140,%eax
  8041ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8041ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8041b2:	74 07                	je     8041bb <insert_sorted_with_merge_freeList+0x7b2>
  8041b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8041b7:	8b 00                	mov    (%eax),%eax
  8041b9:	eb 05                	jmp    8041c0 <insert_sorted_with_merge_freeList+0x7b7>
  8041bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8041c0:	a3 40 61 80 00       	mov    %eax,0x806140
  8041c5:	a1 40 61 80 00       	mov    0x806140,%eax
  8041ca:	85 c0                	test   %eax,%eax
  8041cc:	0f 85 ef f9 ff ff    	jne    803bc1 <insert_sorted_with_merge_freeList+0x1b8>
  8041d2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8041d6:	0f 85 e5 f9 ff ff    	jne    803bc1 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  8041dc:	eb 00                	jmp    8041de <insert_sorted_with_merge_freeList+0x7d5>
  8041de:	90                   	nop
  8041df:	c9                   	leave  
  8041e0:	c3                   	ret    
  8041e1:	66 90                	xchg   %ax,%ax
  8041e3:	90                   	nop

008041e4 <__udivdi3>:
  8041e4:	55                   	push   %ebp
  8041e5:	57                   	push   %edi
  8041e6:	56                   	push   %esi
  8041e7:	53                   	push   %ebx
  8041e8:	83 ec 1c             	sub    $0x1c,%esp
  8041eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8041ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8041f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8041f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8041fb:	89 ca                	mov    %ecx,%edx
  8041fd:	89 f8                	mov    %edi,%eax
  8041ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  804203:	85 f6                	test   %esi,%esi
  804205:	75 2d                	jne    804234 <__udivdi3+0x50>
  804207:	39 cf                	cmp    %ecx,%edi
  804209:	77 65                	ja     804270 <__udivdi3+0x8c>
  80420b:	89 fd                	mov    %edi,%ebp
  80420d:	85 ff                	test   %edi,%edi
  80420f:	75 0b                	jne    80421c <__udivdi3+0x38>
  804211:	b8 01 00 00 00       	mov    $0x1,%eax
  804216:	31 d2                	xor    %edx,%edx
  804218:	f7 f7                	div    %edi
  80421a:	89 c5                	mov    %eax,%ebp
  80421c:	31 d2                	xor    %edx,%edx
  80421e:	89 c8                	mov    %ecx,%eax
  804220:	f7 f5                	div    %ebp
  804222:	89 c1                	mov    %eax,%ecx
  804224:	89 d8                	mov    %ebx,%eax
  804226:	f7 f5                	div    %ebp
  804228:	89 cf                	mov    %ecx,%edi
  80422a:	89 fa                	mov    %edi,%edx
  80422c:	83 c4 1c             	add    $0x1c,%esp
  80422f:	5b                   	pop    %ebx
  804230:	5e                   	pop    %esi
  804231:	5f                   	pop    %edi
  804232:	5d                   	pop    %ebp
  804233:	c3                   	ret    
  804234:	39 ce                	cmp    %ecx,%esi
  804236:	77 28                	ja     804260 <__udivdi3+0x7c>
  804238:	0f bd fe             	bsr    %esi,%edi
  80423b:	83 f7 1f             	xor    $0x1f,%edi
  80423e:	75 40                	jne    804280 <__udivdi3+0x9c>
  804240:	39 ce                	cmp    %ecx,%esi
  804242:	72 0a                	jb     80424e <__udivdi3+0x6a>
  804244:	3b 44 24 08          	cmp    0x8(%esp),%eax
  804248:	0f 87 9e 00 00 00    	ja     8042ec <__udivdi3+0x108>
  80424e:	b8 01 00 00 00       	mov    $0x1,%eax
  804253:	89 fa                	mov    %edi,%edx
  804255:	83 c4 1c             	add    $0x1c,%esp
  804258:	5b                   	pop    %ebx
  804259:	5e                   	pop    %esi
  80425a:	5f                   	pop    %edi
  80425b:	5d                   	pop    %ebp
  80425c:	c3                   	ret    
  80425d:	8d 76 00             	lea    0x0(%esi),%esi
  804260:	31 ff                	xor    %edi,%edi
  804262:	31 c0                	xor    %eax,%eax
  804264:	89 fa                	mov    %edi,%edx
  804266:	83 c4 1c             	add    $0x1c,%esp
  804269:	5b                   	pop    %ebx
  80426a:	5e                   	pop    %esi
  80426b:	5f                   	pop    %edi
  80426c:	5d                   	pop    %ebp
  80426d:	c3                   	ret    
  80426e:	66 90                	xchg   %ax,%ax
  804270:	89 d8                	mov    %ebx,%eax
  804272:	f7 f7                	div    %edi
  804274:	31 ff                	xor    %edi,%edi
  804276:	89 fa                	mov    %edi,%edx
  804278:	83 c4 1c             	add    $0x1c,%esp
  80427b:	5b                   	pop    %ebx
  80427c:	5e                   	pop    %esi
  80427d:	5f                   	pop    %edi
  80427e:	5d                   	pop    %ebp
  80427f:	c3                   	ret    
  804280:	bd 20 00 00 00       	mov    $0x20,%ebp
  804285:	89 eb                	mov    %ebp,%ebx
  804287:	29 fb                	sub    %edi,%ebx
  804289:	89 f9                	mov    %edi,%ecx
  80428b:	d3 e6                	shl    %cl,%esi
  80428d:	89 c5                	mov    %eax,%ebp
  80428f:	88 d9                	mov    %bl,%cl
  804291:	d3 ed                	shr    %cl,%ebp
  804293:	89 e9                	mov    %ebp,%ecx
  804295:	09 f1                	or     %esi,%ecx
  804297:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80429b:	89 f9                	mov    %edi,%ecx
  80429d:	d3 e0                	shl    %cl,%eax
  80429f:	89 c5                	mov    %eax,%ebp
  8042a1:	89 d6                	mov    %edx,%esi
  8042a3:	88 d9                	mov    %bl,%cl
  8042a5:	d3 ee                	shr    %cl,%esi
  8042a7:	89 f9                	mov    %edi,%ecx
  8042a9:	d3 e2                	shl    %cl,%edx
  8042ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8042af:	88 d9                	mov    %bl,%cl
  8042b1:	d3 e8                	shr    %cl,%eax
  8042b3:	09 c2                	or     %eax,%edx
  8042b5:	89 d0                	mov    %edx,%eax
  8042b7:	89 f2                	mov    %esi,%edx
  8042b9:	f7 74 24 0c          	divl   0xc(%esp)
  8042bd:	89 d6                	mov    %edx,%esi
  8042bf:	89 c3                	mov    %eax,%ebx
  8042c1:	f7 e5                	mul    %ebp
  8042c3:	39 d6                	cmp    %edx,%esi
  8042c5:	72 19                	jb     8042e0 <__udivdi3+0xfc>
  8042c7:	74 0b                	je     8042d4 <__udivdi3+0xf0>
  8042c9:	89 d8                	mov    %ebx,%eax
  8042cb:	31 ff                	xor    %edi,%edi
  8042cd:	e9 58 ff ff ff       	jmp    80422a <__udivdi3+0x46>
  8042d2:	66 90                	xchg   %ax,%ax
  8042d4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8042d8:	89 f9                	mov    %edi,%ecx
  8042da:	d3 e2                	shl    %cl,%edx
  8042dc:	39 c2                	cmp    %eax,%edx
  8042de:	73 e9                	jae    8042c9 <__udivdi3+0xe5>
  8042e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8042e3:	31 ff                	xor    %edi,%edi
  8042e5:	e9 40 ff ff ff       	jmp    80422a <__udivdi3+0x46>
  8042ea:	66 90                	xchg   %ax,%ax
  8042ec:	31 c0                	xor    %eax,%eax
  8042ee:	e9 37 ff ff ff       	jmp    80422a <__udivdi3+0x46>
  8042f3:	90                   	nop

008042f4 <__umoddi3>:
  8042f4:	55                   	push   %ebp
  8042f5:	57                   	push   %edi
  8042f6:	56                   	push   %esi
  8042f7:	53                   	push   %ebx
  8042f8:	83 ec 1c             	sub    $0x1c,%esp
  8042fb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8042ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  804303:	8b 7c 24 38          	mov    0x38(%esp),%edi
  804307:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80430b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80430f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  804313:	89 f3                	mov    %esi,%ebx
  804315:	89 fa                	mov    %edi,%edx
  804317:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80431b:	89 34 24             	mov    %esi,(%esp)
  80431e:	85 c0                	test   %eax,%eax
  804320:	75 1a                	jne    80433c <__umoddi3+0x48>
  804322:	39 f7                	cmp    %esi,%edi
  804324:	0f 86 a2 00 00 00    	jbe    8043cc <__umoddi3+0xd8>
  80432a:	89 c8                	mov    %ecx,%eax
  80432c:	89 f2                	mov    %esi,%edx
  80432e:	f7 f7                	div    %edi
  804330:	89 d0                	mov    %edx,%eax
  804332:	31 d2                	xor    %edx,%edx
  804334:	83 c4 1c             	add    $0x1c,%esp
  804337:	5b                   	pop    %ebx
  804338:	5e                   	pop    %esi
  804339:	5f                   	pop    %edi
  80433a:	5d                   	pop    %ebp
  80433b:	c3                   	ret    
  80433c:	39 f0                	cmp    %esi,%eax
  80433e:	0f 87 ac 00 00 00    	ja     8043f0 <__umoddi3+0xfc>
  804344:	0f bd e8             	bsr    %eax,%ebp
  804347:	83 f5 1f             	xor    $0x1f,%ebp
  80434a:	0f 84 ac 00 00 00    	je     8043fc <__umoddi3+0x108>
  804350:	bf 20 00 00 00       	mov    $0x20,%edi
  804355:	29 ef                	sub    %ebp,%edi
  804357:	89 fe                	mov    %edi,%esi
  804359:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80435d:	89 e9                	mov    %ebp,%ecx
  80435f:	d3 e0                	shl    %cl,%eax
  804361:	89 d7                	mov    %edx,%edi
  804363:	89 f1                	mov    %esi,%ecx
  804365:	d3 ef                	shr    %cl,%edi
  804367:	09 c7                	or     %eax,%edi
  804369:	89 e9                	mov    %ebp,%ecx
  80436b:	d3 e2                	shl    %cl,%edx
  80436d:	89 14 24             	mov    %edx,(%esp)
  804370:	89 d8                	mov    %ebx,%eax
  804372:	d3 e0                	shl    %cl,%eax
  804374:	89 c2                	mov    %eax,%edx
  804376:	8b 44 24 08          	mov    0x8(%esp),%eax
  80437a:	d3 e0                	shl    %cl,%eax
  80437c:	89 44 24 04          	mov    %eax,0x4(%esp)
  804380:	8b 44 24 08          	mov    0x8(%esp),%eax
  804384:	89 f1                	mov    %esi,%ecx
  804386:	d3 e8                	shr    %cl,%eax
  804388:	09 d0                	or     %edx,%eax
  80438a:	d3 eb                	shr    %cl,%ebx
  80438c:	89 da                	mov    %ebx,%edx
  80438e:	f7 f7                	div    %edi
  804390:	89 d3                	mov    %edx,%ebx
  804392:	f7 24 24             	mull   (%esp)
  804395:	89 c6                	mov    %eax,%esi
  804397:	89 d1                	mov    %edx,%ecx
  804399:	39 d3                	cmp    %edx,%ebx
  80439b:	0f 82 87 00 00 00    	jb     804428 <__umoddi3+0x134>
  8043a1:	0f 84 91 00 00 00    	je     804438 <__umoddi3+0x144>
  8043a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8043ab:	29 f2                	sub    %esi,%edx
  8043ad:	19 cb                	sbb    %ecx,%ebx
  8043af:	89 d8                	mov    %ebx,%eax
  8043b1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8043b5:	d3 e0                	shl    %cl,%eax
  8043b7:	89 e9                	mov    %ebp,%ecx
  8043b9:	d3 ea                	shr    %cl,%edx
  8043bb:	09 d0                	or     %edx,%eax
  8043bd:	89 e9                	mov    %ebp,%ecx
  8043bf:	d3 eb                	shr    %cl,%ebx
  8043c1:	89 da                	mov    %ebx,%edx
  8043c3:	83 c4 1c             	add    $0x1c,%esp
  8043c6:	5b                   	pop    %ebx
  8043c7:	5e                   	pop    %esi
  8043c8:	5f                   	pop    %edi
  8043c9:	5d                   	pop    %ebp
  8043ca:	c3                   	ret    
  8043cb:	90                   	nop
  8043cc:	89 fd                	mov    %edi,%ebp
  8043ce:	85 ff                	test   %edi,%edi
  8043d0:	75 0b                	jne    8043dd <__umoddi3+0xe9>
  8043d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8043d7:	31 d2                	xor    %edx,%edx
  8043d9:	f7 f7                	div    %edi
  8043db:	89 c5                	mov    %eax,%ebp
  8043dd:	89 f0                	mov    %esi,%eax
  8043df:	31 d2                	xor    %edx,%edx
  8043e1:	f7 f5                	div    %ebp
  8043e3:	89 c8                	mov    %ecx,%eax
  8043e5:	f7 f5                	div    %ebp
  8043e7:	89 d0                	mov    %edx,%eax
  8043e9:	e9 44 ff ff ff       	jmp    804332 <__umoddi3+0x3e>
  8043ee:	66 90                	xchg   %ax,%ax
  8043f0:	89 c8                	mov    %ecx,%eax
  8043f2:	89 f2                	mov    %esi,%edx
  8043f4:	83 c4 1c             	add    $0x1c,%esp
  8043f7:	5b                   	pop    %ebx
  8043f8:	5e                   	pop    %esi
  8043f9:	5f                   	pop    %edi
  8043fa:	5d                   	pop    %ebp
  8043fb:	c3                   	ret    
  8043fc:	3b 04 24             	cmp    (%esp),%eax
  8043ff:	72 06                	jb     804407 <__umoddi3+0x113>
  804401:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  804405:	77 0f                	ja     804416 <__umoddi3+0x122>
  804407:	89 f2                	mov    %esi,%edx
  804409:	29 f9                	sub    %edi,%ecx
  80440b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80440f:	89 14 24             	mov    %edx,(%esp)
  804412:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  804416:	8b 44 24 04          	mov    0x4(%esp),%eax
  80441a:	8b 14 24             	mov    (%esp),%edx
  80441d:	83 c4 1c             	add    $0x1c,%esp
  804420:	5b                   	pop    %ebx
  804421:	5e                   	pop    %esi
  804422:	5f                   	pop    %edi
  804423:	5d                   	pop    %ebp
  804424:	c3                   	ret    
  804425:	8d 76 00             	lea    0x0(%esi),%esi
  804428:	2b 04 24             	sub    (%esp),%eax
  80442b:	19 fa                	sbb    %edi,%edx
  80442d:	89 d1                	mov    %edx,%ecx
  80442f:	89 c6                	mov    %eax,%esi
  804431:	e9 71 ff ff ff       	jmp    8043a7 <__umoddi3+0xb3>
  804436:	66 90                	xchg   %ax,%ax
  804438:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80443c:	72 ea                	jb     804428 <__umoddi3+0x134>
  80443e:	89 d9                	mov    %ebx,%ecx
  804440:	e9 62 ff ff ff       	jmp    8043a7 <__umoddi3+0xb3>
