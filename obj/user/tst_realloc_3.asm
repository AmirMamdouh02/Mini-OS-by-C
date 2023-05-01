
obj/user/tst_realloc_3:     file format elf32-i386


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
  800031:	e8 29 06 00 00       	call   80065f <libmain>
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
  80003d:	83 ec 40             	sub    $0x40,%esp
	int Mega = 1024*1024;
  800040:	c7 45 f0 00 00 10 00 	movl   $0x100000,-0x10(%ebp)
	int kilo = 1024;
  800047:	c7 45 ec 00 04 00 00 	movl   $0x400,-0x14(%ebp)
	void* ptr_allocations[5] = {0};
  80004e:	8d 55 c4             	lea    -0x3c(%ebp),%edx
  800051:	b9 05 00 00 00       	mov    $0x5,%ecx
  800056:	b8 00 00 00 00       	mov    $0x0,%eax
  80005b:	89 d7                	mov    %edx,%edi
  80005d:	f3 ab                	rep stos %eax,%es:(%edi)
	int freeFrames ;
	int usedDiskPages;
	cprintf("realloc: current evaluation = 00%");
  80005f:	83 ec 0c             	sub    $0xc,%esp
  800062:	68 c0 37 80 00       	push   $0x8037c0
  800067:	e8 e3 09 00 00       	call   800a4f <cprintf>
  80006c:	83 c4 10             	add    $0x10,%esp
	//[1] Allocate all
	{
		//Allocate 100 KB
		freeFrames = sys_calculate_free_frames() ;
  80006f:	e8 18 1e 00 00       	call   801e8c <sys_calculate_free_frames>
  800074:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800077:	e8 b0 1e 00 00       	call   801f2c <sys_pf_calculate_allocated_pages>
  80007c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = malloc(100*kilo - kilo);
  80007f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800082:	89 d0                	mov    %edx,%eax
  800084:	01 c0                	add    %eax,%eax
  800086:	01 d0                	add    %edx,%eax
  800088:	89 c2                	mov    %eax,%edx
  80008a:	c1 e2 05             	shl    $0x5,%edx
  80008d:	01 d0                	add    %edx,%eax
  80008f:	83 ec 0c             	sub    $0xc,%esp
  800092:	50                   	push   %eax
  800093:	e8 56 19 00 00       	call   8019ee <malloc>
  800098:	83 c4 10             	add    $0x10,%esp
  80009b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		if ((uint32) ptr_allocations[0] !=  (USER_HEAP_START)) panic("Wrong start address for the allocated space... ");
  80009e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8000a1:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  8000a6:	74 14                	je     8000bc <_main+0x84>
  8000a8:	83 ec 04             	sub    $0x4,%esp
  8000ab:	68 e4 37 80 00       	push   $0x8037e4
  8000b0:	6a 11                	push   $0x11
  8000b2:	68 14 38 80 00       	push   $0x803814
  8000b7:	e8 df 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256+1 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 1) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8000bc:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000bf:	e8 c8 1d 00 00       	call   801e8c <sys_calculate_free_frames>
  8000c4:	29 c3                	sub    %eax,%ebx
  8000c6:	89 d8                	mov    %ebx,%eax
  8000c8:	83 f8 01             	cmp    $0x1,%eax
  8000cb:	74 14                	je     8000e1 <_main+0xa9>
  8000cd:	83 ec 04             	sub    $0x4,%esp
  8000d0:	68 2c 38 80 00       	push   $0x80382c
  8000d5:	6a 13                	push   $0x13
  8000d7:	68 14 38 80 00       	push   $0x803814
  8000dc:	e8 ba 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are allocated in PageFile");
  8000e1:	e8 46 1e 00 00       	call   801f2c <sys_pf_calculate_allocated_pages>
  8000e6:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8000e9:	83 f8 19             	cmp    $0x19,%eax
  8000ec:	74 14                	je     800102 <_main+0xca>
  8000ee:	83 ec 04             	sub    $0x4,%esp
  8000f1:	68 98 38 80 00       	push   $0x803898
  8000f6:	6a 14                	push   $0x14
  8000f8:	68 14 38 80 00       	push   $0x803814
  8000fd:	e8 99 06 00 00       	call   80079b <_panic>

		//Allocate 20 KB
		freeFrames = sys_calculate_free_frames() ;
  800102:	e8 85 1d 00 00       	call   801e8c <sys_calculate_free_frames>
  800107:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80010a:	e8 1d 1e 00 00       	call   801f2c <sys_pf_calculate_allocated_pages>
  80010f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[1] = malloc(20*kilo-kilo);
  800112:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800115:	89 d0                	mov    %edx,%eax
  800117:	c1 e0 03             	shl    $0x3,%eax
  80011a:	01 d0                	add    %edx,%eax
  80011c:	01 c0                	add    %eax,%eax
  80011e:	01 d0                	add    %edx,%eax
  800120:	83 ec 0c             	sub    $0xc,%esp
  800123:	50                   	push   %eax
  800124:	e8 c5 18 00 00       	call   8019ee <malloc>
  800129:	83 c4 10             	add    $0x10,%esp
  80012c:	89 45 c8             	mov    %eax,-0x38(%ebp)
		if ((uint32) ptr_allocations[1] !=  (USER_HEAP_START + 100 * kilo)) panic("Wrong start address for the allocated space... ");
  80012f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800132:	89 c1                	mov    %eax,%ecx
  800134:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800137:	89 d0                	mov    %edx,%eax
  800139:	c1 e0 02             	shl    $0x2,%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800145:	01 d0                	add    %edx,%eax
  800147:	c1 e0 02             	shl    $0x2,%eax
  80014a:	05 00 00 00 80       	add    $0x80000000,%eax
  80014f:	39 c1                	cmp    %eax,%ecx
  800151:	74 14                	je     800167 <_main+0x12f>
  800153:	83 ec 04             	sub    $0x4,%esp
  800156:	68 e4 37 80 00       	push   $0x8037e4
  80015b:	6a 1a                	push   $0x1a
  80015d:	68 14 38 80 00       	push   $0x803814
  800162:	e8 34 06 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800167:	e8 20 1d 00 00       	call   801e8c <sys_calculate_free_frames>
  80016c:	89 c2                	mov    %eax,%edx
  80016e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800171:	39 c2                	cmp    %eax,%edx
  800173:	74 14                	je     800189 <_main+0x151>
  800175:	83 ec 04             	sub    $0x4,%esp
  800178:	68 2c 38 80 00       	push   $0x80382c
  80017d:	6a 1c                	push   $0x1c
  80017f:	68 14 38 80 00       	push   $0x803814
  800184:	e8 12 06 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 5) panic("Extra or less pages are allocated in PageFile");
  800189:	e8 9e 1d 00 00       	call   801f2c <sys_pf_calculate_allocated_pages>
  80018e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800191:	83 f8 05             	cmp    $0x5,%eax
  800194:	74 14                	je     8001aa <_main+0x172>
  800196:	83 ec 04             	sub    $0x4,%esp
  800199:	68 98 38 80 00       	push   $0x803898
  80019e:	6a 1d                	push   $0x1d
  8001a0:	68 14 38 80 00       	push   $0x803814
  8001a5:	e8 f1 05 00 00       	call   80079b <_panic>

		//Allocate 30 KB
		freeFrames = sys_calculate_free_frames() ;
  8001aa:	e8 dd 1c 00 00       	call   801e8c <sys_calculate_free_frames>
  8001af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001b2:	e8 75 1d 00 00       	call   801f2c <sys_pf_calculate_allocated_pages>
  8001b7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[2] = malloc(30 * kilo -kilo);
  8001ba:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001bd:	89 d0                	mov    %edx,%eax
  8001bf:	01 c0                	add    %eax,%eax
  8001c1:	01 d0                	add    %edx,%eax
  8001c3:	01 c0                	add    %eax,%eax
  8001c5:	01 d0                	add    %edx,%eax
  8001c7:	c1 e0 02             	shl    $0x2,%eax
  8001ca:	01 d0                	add    %edx,%eax
  8001cc:	83 ec 0c             	sub    $0xc,%esp
  8001cf:	50                   	push   %eax
  8001d0:	e8 19 18 00 00       	call   8019ee <malloc>
  8001d5:	83 c4 10             	add    $0x10,%esp
  8001d8:	89 45 cc             	mov    %eax,-0x34(%ebp)
		if ((uint32) ptr_allocations[2] !=  (USER_HEAP_START + 120 * kilo)) panic("Wrong start address for the allocated space... ");
  8001db:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8001de:	89 c1                	mov    %eax,%ecx
  8001e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8001e3:	89 d0                	mov    %edx,%eax
  8001e5:	01 c0                	add    %eax,%eax
  8001e7:	01 d0                	add    %edx,%eax
  8001e9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001f0:	01 d0                	add    %edx,%eax
  8001f2:	c1 e0 03             	shl    $0x3,%eax
  8001f5:	05 00 00 00 80       	add    $0x80000000,%eax
  8001fa:	39 c1                	cmp    %eax,%ecx
  8001fc:	74 14                	je     800212 <_main+0x1da>
  8001fe:	83 ec 04             	sub    $0x4,%esp
  800201:	68 e4 37 80 00       	push   $0x8037e4
  800206:	6a 23                	push   $0x23
  800208:	68 14 38 80 00       	push   $0x803814
  80020d:	e8 89 05 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800212:	e8 75 1c 00 00       	call   801e8c <sys_calculate_free_frames>
  800217:	89 c2                	mov    %eax,%edx
  800219:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80021c:	39 c2                	cmp    %eax,%edx
  80021e:	74 14                	je     800234 <_main+0x1fc>
  800220:	83 ec 04             	sub    $0x4,%esp
  800223:	68 2c 38 80 00       	push   $0x80382c
  800228:	6a 25                	push   $0x25
  80022a:	68 14 38 80 00       	push   $0x803814
  80022f:	e8 67 05 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 8) panic("Extra or less pages are allocated in PageFile");
  800234:	e8 f3 1c 00 00       	call   801f2c <sys_pf_calculate_allocated_pages>
  800239:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  80023c:	83 f8 08             	cmp    $0x8,%eax
  80023f:	74 14                	je     800255 <_main+0x21d>
  800241:	83 ec 04             	sub    $0x4,%esp
  800244:	68 98 38 80 00       	push   $0x803898
  800249:	6a 26                	push   $0x26
  80024b:	68 14 38 80 00       	push   $0x803814
  800250:	e8 46 05 00 00       	call   80079b <_panic>

		//Allocate 40 KB
		freeFrames = sys_calculate_free_frames() ;
  800255:	e8 32 1c 00 00       	call   801e8c <sys_calculate_free_frames>
  80025a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80025d:	e8 ca 1c 00 00       	call   801f2c <sys_pf_calculate_allocated_pages>
  800262:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[3] = malloc(40 * kilo -kilo);
  800265:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800268:	89 d0                	mov    %edx,%eax
  80026a:	c1 e0 03             	shl    $0x3,%eax
  80026d:	01 d0                	add    %edx,%eax
  80026f:	01 c0                	add    %eax,%eax
  800271:	01 d0                	add    %edx,%eax
  800273:	01 c0                	add    %eax,%eax
  800275:	01 d0                	add    %edx,%eax
  800277:	83 ec 0c             	sub    $0xc,%esp
  80027a:	50                   	push   %eax
  80027b:	e8 6e 17 00 00       	call   8019ee <malloc>
  800280:	83 c4 10             	add    $0x10,%esp
  800283:	89 45 d0             	mov    %eax,-0x30(%ebp)
		if ((uint32) ptr_allocations[3] !=  (USER_HEAP_START + 152 * kilo)) panic("Wrong start address for the allocated space... ");
  800286:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800289:	89 c1                	mov    %eax,%ecx
  80028b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80028e:	89 d0                	mov    %edx,%eax
  800290:	c1 e0 03             	shl    $0x3,%eax
  800293:	01 d0                	add    %edx,%eax
  800295:	01 c0                	add    %eax,%eax
  800297:	01 d0                	add    %edx,%eax
  800299:	c1 e0 03             	shl    $0x3,%eax
  80029c:	05 00 00 00 80       	add    $0x80000000,%eax
  8002a1:	39 c1                	cmp    %eax,%ecx
  8002a3:	74 14                	je     8002b9 <_main+0x281>
  8002a5:	83 ec 04             	sub    $0x4,%esp
  8002a8:	68 e4 37 80 00       	push   $0x8037e4
  8002ad:	6a 2c                	push   $0x2c
  8002af:	68 14 38 80 00       	push   $0x803814
  8002b4:	e8 e2 04 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 256 ) panic("Wrong allocation: ");
		if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8002b9:	e8 ce 1b 00 00       	call   801e8c <sys_calculate_free_frames>
  8002be:	89 c2                	mov    %eax,%edx
  8002c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002c3:	39 c2                	cmp    %eax,%edx
  8002c5:	74 14                	je     8002db <_main+0x2a3>
  8002c7:	83 ec 04             	sub    $0x4,%esp
  8002ca:	68 2c 38 80 00       	push   $0x80382c
  8002cf:	6a 2e                	push   $0x2e
  8002d1:	68 14 38 80 00       	push   $0x803814
  8002d6:	e8 c0 04 00 00       	call   80079b <_panic>
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 10) panic("Extra or less pages are allocated in PageFile");
  8002db:	e8 4c 1c 00 00       	call   801f2c <sys_pf_calculate_allocated_pages>
  8002e0:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8002e3:	83 f8 0a             	cmp    $0xa,%eax
  8002e6:	74 14                	je     8002fc <_main+0x2c4>
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	68 98 38 80 00       	push   $0x803898
  8002f0:	6a 2f                	push   $0x2f
  8002f2:	68 14 38 80 00       	push   $0x803814
  8002f7:	e8 9f 04 00 00       	call   80079b <_panic>


	}


	int cnt = 0;
  8002fc:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	//[2] Test Re-allocation
	{
		/*Reallocate the first array (100 KB) to the last hole*/

		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
  800303:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  800306:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  800309:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80030c:	89 d0                	mov    %edx,%eax
  80030e:	c1 e0 02             	shl    $0x2,%eax
  800311:	01 d0                	add    %edx,%eax
  800313:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80031a:	01 d0                	add    %edx,%eax
  80031c:	c1 e0 02             	shl    $0x2,%eax
  80031f:	c1 e8 02             	shr    $0x2,%eax
  800322:	48                   	dec    %eax
  800323:	89 45 d8             	mov    %eax,-0x28(%ebp)

		int i = 0;
  800326:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for (i=0; i < lastIndexOfInt1 ; i++)
  80032d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800334:	eb 17                	jmp    80034d <_main+0x315>
		{
			intArr[i] = i ;
  800336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800339:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800340:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800343:	01 c2                	add    %eax,%edx
  800345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800348:	89 02                	mov    %eax,(%edx)
		//Fill the first array with data
		int *intArr = (int*) ptr_allocations[0];
		int lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		int i = 0;
		for (i=0; i < lastIndexOfInt1 ; i++)
  80034a:	ff 45 f4             	incl   -0xc(%ebp)
  80034d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800350:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800353:	7c e1                	jl     800336 <_main+0x2fe>
		{
			intArr[i] = i ;
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  800355:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800358:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  80035b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80035e:	89 d0                	mov    %edx,%eax
  800360:	c1 e0 02             	shl    $0x2,%eax
  800363:	01 d0                	add    %edx,%eax
  800365:	c1 e0 02             	shl    $0x2,%eax
  800368:	c1 e8 02             	shr    $0x2,%eax
  80036b:	48                   	dec    %eax
  80036c:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  80036f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800376:	eb 17                	jmp    80038f <_main+0x357>
		{
			intArr[i] = i ;
  800378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80037b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800382:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800385:	01 c2                	add    %eax,%edx
  800387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80038a:	89 02                	mov    %eax,(%edx)

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80038c:	ff 45 f4             	incl   -0xc(%ebp)
  80038f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800392:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800395:	7c e1                	jl     800378 <_main+0x340>
		{
			intArr[i] = i ;
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800397:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80039a:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80039d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003a0:	89 d0                	mov    %edx,%eax
  8003a2:	01 c0                	add    %eax,%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ad:	01 d0                	add    %edx,%eax
  8003af:	01 c0                	add    %eax,%eax
  8003b1:	c1 e8 02             	shr    $0x2,%eax
  8003b4:	48                   	dec    %eax
  8003b5:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8003bf:	eb 17                	jmp    8003d8 <_main+0x3a0>
		{
			intArr[i] = i ;
  8003c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ce:	01 c2                	add    %eax,%edx
  8003d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003d3:	89 02                	mov    %eax,(%edx)

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003d5:	ff 45 f4             	incl   -0xc(%ebp)
  8003d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003db:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8003de:	7c e1                	jl     8003c1 <_main+0x389>
		{
			intArr[i] = i ;
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8003e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003e3:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8003e6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003e9:	89 d0                	mov    %edx,%eax
  8003eb:	c1 e0 02             	shl    $0x2,%eax
  8003ee:	01 d0                	add    %edx,%eax
  8003f0:	c1 e0 03             	shl    $0x3,%eax
  8003f3:	c1 e8 02             	shr    $0x2,%eax
  8003f6:	48                   	dec    %eax
  8003f7:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8003fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800401:	eb 17                	jmp    80041a <_main+0x3e2>
		{
			intArr[i] = i ;
  800403:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800406:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80040d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800410:	01 c2                	add    %eax,%edx
  800412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800415:	89 02                	mov    %eax,(%edx)

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800417:	ff 45 f4             	incl   -0xc(%ebp)
  80041a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041d:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800420:	7c e1                	jl     800403 <_main+0x3cb>
			intArr[i] = i ;
		}


		//Reallocate the first array to 200 KB [should be moved to after the fourth one]
		freeFrames = sys_calculate_free_frames() ;
  800422:	e8 65 1a 00 00       	call   801e8c <sys_calculate_free_frames>
  800427:	89 45 e8             	mov    %eax,-0x18(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80042a:	e8 fd 1a 00 00       	call   801f2c <sys_pf_calculate_allocated_pages>
  80042f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		ptr_allocations[0] = realloc(ptr_allocations[0], 200 * kilo - kilo);
  800432:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800435:	89 d0                	mov    %edx,%eax
  800437:	01 c0                	add    %eax,%eax
  800439:	01 d0                	add    %edx,%eax
  80043b:	89 c1                	mov    %eax,%ecx
  80043d:	c1 e1 05             	shl    $0x5,%ecx
  800440:	01 c8                	add    %ecx,%eax
  800442:	01 c0                	add    %eax,%eax
  800444:	01 d0                	add    %edx,%eax
  800446:	89 c2                	mov    %eax,%edx
  800448:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80044b:	83 ec 08             	sub    $0x8,%esp
  80044e:	52                   	push   %edx
  80044f:	50                   	push   %eax
  800450:	e8 b5 18 00 00       	call   801d0a <realloc>
  800455:	83 c4 10             	add    $0x10,%esp
  800458:	89 45 c4             	mov    %eax,-0x3c(%ebp)

		//[1] test return address & re-allocated space
		if ((uint32) ptr_allocations[0] != (USER_HEAP_START + 192 * kilo)) panic("Wrong start address for the re-allocated space... ");
  80045b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80045e:	89 c1                	mov    %eax,%ecx
  800460:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800463:	89 d0                	mov    %edx,%eax
  800465:	01 c0                	add    %eax,%eax
  800467:	01 d0                	add    %edx,%eax
  800469:	c1 e0 06             	shl    $0x6,%eax
  80046c:	05 00 00 00 80       	add    $0x80000000,%eax
  800471:	39 c1                	cmp    %eax,%ecx
  800473:	74 14                	je     800489 <_main+0x451>
  800475:	83 ec 04             	sub    $0x4,%esp
  800478:	68 c8 38 80 00       	push   $0x8038c8
  80047d:	6a 6b                	push   $0x6b
  80047f:	68 14 38 80 00       	push   $0x803814
  800484:	e8 12 03 00 00       	call   80079b <_panic>
		//if ((freeFrames - sys_calculate_free_frames()) != 64) panic("Wrong re-allocation");
		//if((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong re-allocation: either extra pages are re-allocated in memory or pages not allocated correctly on PageFile");
		if((sys_pf_calculate_allocated_pages() - usedDiskPages) != 25) panic("Extra or less pages are re-allocated in PageFile");
  800489:	e8 9e 1a 00 00       	call   801f2c <sys_pf_calculate_allocated_pages>
  80048e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800491:	83 f8 19             	cmp    $0x19,%eax
  800494:	74 14                	je     8004aa <_main+0x472>
  800496:	83 ec 04             	sub    $0x4,%esp
  800499:	68 fc 38 80 00       	push   $0x8038fc
  80049e:	6a 6e                	push   $0x6e
  8004a0:	68 14 38 80 00       	push   $0x803814
  8004a5:	e8 f1 02 00 00       	call   80079b <_panic>


		vcprintf("\b\b\b50%", NULL);
  8004aa:	83 ec 08             	sub    $0x8,%esp
  8004ad:	6a 00                	push   $0x0
  8004af:	68 2d 39 80 00       	push   $0x80392d
  8004b4:	e8 2b 05 00 00       	call   8009e4 <vcprintf>
  8004b9:	83 c4 10             	add    $0x10,%esp

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
  8004bc:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8004bf:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;
  8004c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004c5:	89 d0                	mov    %edx,%eax
  8004c7:	c1 e0 02             	shl    $0x2,%eax
  8004ca:	01 d0                	add    %edx,%eax
  8004cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 02             	shl    $0x2,%eax
  8004d8:	c1 e8 02             	shr    $0x2,%eax
  8004db:	48                   	dec    %eax
  8004dc:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8004df:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004e6:	eb 2d                	jmp    800515 <_main+0x4dd>
		{
			if(intArr[i] != i)
  8004e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004eb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004f2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004f5:	01 d0                	add    %edx,%eax
  8004f7:	8b 00                	mov    (%eax),%eax
  8004f9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8004fc:	74 14                	je     800512 <_main+0x4da>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 34 39 80 00       	push   $0x803934
  800506:	6a 7a                	push   $0x7a
  800508:	68 14 38 80 00       	push   $0x803814
  80050d:	e8 89 02 00 00       	call   80079b <_panic>

		//Fill the first array with data
		intArr = (int*) ptr_allocations[0];
		lastIndexOfInt1 = (100*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  800512:	ff 45 f4             	incl   -0xc(%ebp)
  800515:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800518:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  80051b:	7c cb                	jl     8004e8 <_main+0x4b0>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
  80051d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800520:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;
  800523:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800526:	89 d0                	mov    %edx,%eax
  800528:	c1 e0 02             	shl    $0x2,%eax
  80052b:	01 d0                	add    %edx,%eax
  80052d:	c1 e0 02             	shl    $0x2,%eax
  800530:	c1 e8 02             	shr    $0x2,%eax
  800533:	48                   	dec    %eax
  800534:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800537:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80053e:	eb 30                	jmp    800570 <_main+0x538>
		{
			if(intArr[i] != i)
  800540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800543:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80054a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80054d:	01 d0                	add    %edx,%eax
  80054f:	8b 00                	mov    (%eax),%eax
  800551:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800554:	74 17                	je     80056d <_main+0x535>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800556:	83 ec 04             	sub    $0x4,%esp
  800559:	68 34 39 80 00       	push   $0x803934
  80055e:	68 84 00 00 00       	push   $0x84
  800563:	68 14 38 80 00       	push   $0x803814
  800568:	e8 2e 02 00 00       	call   80079b <_panic>

		//Fill the second array with data
		intArr = (int*) ptr_allocations[1];
		lastIndexOfInt1 = (20*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80056d:	ff 45 f4             	incl   -0xc(%ebp)
  800570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800573:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800576:	7c c8                	jl     800540 <_main+0x508>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
  800578:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80057b:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;
  80057e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800581:	89 d0                	mov    %edx,%eax
  800583:	01 c0                	add    %eax,%eax
  800585:	01 d0                	add    %edx,%eax
  800587:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80058e:	01 d0                	add    %edx,%eax
  800590:	01 c0                	add    %eax,%eax
  800592:	c1 e8 02             	shr    $0x2,%eax
  800595:	48                   	dec    %eax
  800596:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  800599:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005a0:	eb 30                	jmp    8005d2 <_main+0x59a>
		{
			if(intArr[i] != i)
  8005a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005a5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005af:	01 d0                	add    %edx,%eax
  8005b1:	8b 00                	mov    (%eax),%eax
  8005b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8005b6:	74 17                	je     8005cf <_main+0x597>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  8005b8:	83 ec 04             	sub    $0x4,%esp
  8005bb:	68 34 39 80 00       	push   $0x803934
  8005c0:	68 8e 00 00 00       	push   $0x8e
  8005c5:	68 14 38 80 00       	push   $0x803814
  8005ca:	e8 cc 01 00 00       	call   80079b <_panic>

		//Fill the third array with data
		intArr = (int*) ptr_allocations[2];
		lastIndexOfInt1 = (30*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005cf:	ff 45 f4             	incl   -0xc(%ebp)
  8005d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005d5:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8005d8:	7c c8                	jl     8005a2 <_main+0x56a>
			if(intArr[i] != i)
				panic("Wrong re-allocation: stored values are wrongly changed!");
		}

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
  8005da:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8005dd:	89 45 dc             	mov    %eax,-0x24(%ebp)
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;
  8005e0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	c1 e0 03             	shl    $0x3,%eax
  8005ed:	c1 e8 02             	shr    $0x2,%eax
  8005f0:	48                   	dec    %eax
  8005f1:	89 45 d8             	mov    %eax,-0x28(%ebp)

		for (i=0; i < lastIndexOfInt1 ; i++)
  8005f4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8005fb:	eb 30                	jmp    80062d <_main+0x5f5>
		{
			if(intArr[i] != i)
  8005fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800600:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800607:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80060a:	01 d0                	add    %edx,%eax
  80060c:	8b 00                	mov    (%eax),%eax
  80060e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800611:	74 17                	je     80062a <_main+0x5f2>
				panic("Wrong re-allocation: stored values are wrongly changed!");
  800613:	83 ec 04             	sub    $0x4,%esp
  800616:	68 34 39 80 00       	push   $0x803934
  80061b:	68 98 00 00 00       	push   $0x98
  800620:	68 14 38 80 00       	push   $0x803814
  800625:	e8 71 01 00 00       	call   80079b <_panic>

		//Fill the fourth array with data
		intArr = (int*) ptr_allocations[3];
		lastIndexOfInt1 = (40*kilo)/sizeof(int) - 1;

		for (i=0; i < lastIndexOfInt1 ; i++)
  80062a:	ff 45 f4             	incl   -0xc(%ebp)
  80062d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800630:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  800633:	7c c8                	jl     8005fd <_main+0x5c5>
				panic("Wrong re-allocation: stored values are wrongly changed!");

		}


		vcprintf("\b\b\b100%\n", NULL);
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	6a 00                	push   $0x0
  80063a:	68 6c 39 80 00       	push   $0x80396c
  80063f:	e8 a0 03 00 00       	call   8009e4 <vcprintf>
  800644:	83 c4 10             	add    $0x10,%esp
	}



	cprintf("Congratulations!! test realloc [3] completed successfully.\n");
  800647:	83 ec 0c             	sub    $0xc,%esp
  80064a:	68 78 39 80 00       	push   $0x803978
  80064f:	e8 fb 03 00 00       	call   800a4f <cprintf>
  800654:	83 c4 10             	add    $0x10,%esp

	return;
  800657:	90                   	nop
}
  800658:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80065b:	5b                   	pop    %ebx
  80065c:	5f                   	pop    %edi
  80065d:	5d                   	pop    %ebp
  80065e:	c3                   	ret    

0080065f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80065f:	55                   	push   %ebp
  800660:	89 e5                	mov    %esp,%ebp
  800662:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800665:	e8 02 1b 00 00       	call   80216c <sys_getenvindex>
  80066a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80066d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800670:	89 d0                	mov    %edx,%eax
  800672:	c1 e0 03             	shl    $0x3,%eax
  800675:	01 d0                	add    %edx,%eax
  800677:	01 c0                	add    %eax,%eax
  800679:	01 d0                	add    %edx,%eax
  80067b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800682:	01 d0                	add    %edx,%eax
  800684:	c1 e0 04             	shl    $0x4,%eax
  800687:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80068c:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800691:	a1 20 50 80 00       	mov    0x805020,%eax
  800696:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80069c:	84 c0                	test   %al,%al
  80069e:	74 0f                	je     8006af <libmain+0x50>
		binaryname = myEnv->prog_name;
  8006a0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a5:	05 5c 05 00 00       	add    $0x55c,%eax
  8006aa:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8006af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8006b3:	7e 0a                	jle    8006bf <libmain+0x60>
		binaryname = argv[0];
  8006b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8006bf:	83 ec 08             	sub    $0x8,%esp
  8006c2:	ff 75 0c             	pushl  0xc(%ebp)
  8006c5:	ff 75 08             	pushl  0x8(%ebp)
  8006c8:	e8 6b f9 ff ff       	call   800038 <_main>
  8006cd:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8006d0:	e8 a4 18 00 00       	call   801f79 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8006d5:	83 ec 0c             	sub    $0xc,%esp
  8006d8:	68 cc 39 80 00       	push   $0x8039cc
  8006dd:	e8 6d 03 00 00       	call   800a4f <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8006e5:	a1 20 50 80 00       	mov    0x805020,%eax
  8006ea:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8006f0:	a1 20 50 80 00       	mov    0x805020,%eax
  8006f5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8006fb:	83 ec 04             	sub    $0x4,%esp
  8006fe:	52                   	push   %edx
  8006ff:	50                   	push   %eax
  800700:	68 f4 39 80 00       	push   $0x8039f4
  800705:	e8 45 03 00 00       	call   800a4f <cprintf>
  80070a:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80070d:	a1 20 50 80 00       	mov    0x805020,%eax
  800712:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800718:	a1 20 50 80 00       	mov    0x805020,%eax
  80071d:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800723:	a1 20 50 80 00       	mov    0x805020,%eax
  800728:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	68 1c 3a 80 00       	push   $0x803a1c
  800736:	e8 14 03 00 00       	call   800a4f <cprintf>
  80073b:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80073e:	a1 20 50 80 00       	mov    0x805020,%eax
  800743:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800749:	83 ec 08             	sub    $0x8,%esp
  80074c:	50                   	push   %eax
  80074d:	68 74 3a 80 00       	push   $0x803a74
  800752:	e8 f8 02 00 00       	call   800a4f <cprintf>
  800757:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80075a:	83 ec 0c             	sub    $0xc,%esp
  80075d:	68 cc 39 80 00       	push   $0x8039cc
  800762:	e8 e8 02 00 00       	call   800a4f <cprintf>
  800767:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80076a:	e8 24 18 00 00       	call   801f93 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80076f:	e8 19 00 00 00       	call   80078d <exit>
}
  800774:	90                   	nop
  800775:	c9                   	leave  
  800776:	c3                   	ret    

00800777 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80077d:	83 ec 0c             	sub    $0xc,%esp
  800780:	6a 00                	push   $0x0
  800782:	e8 b1 19 00 00       	call   802138 <sys_destroy_env>
  800787:	83 c4 10             	add    $0x10,%esp
}
  80078a:	90                   	nop
  80078b:	c9                   	leave  
  80078c:	c3                   	ret    

0080078d <exit>:

void
exit(void)
{
  80078d:	55                   	push   %ebp
  80078e:	89 e5                	mov    %esp,%ebp
  800790:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800793:	e8 06 1a 00 00       	call   80219e <sys_exit_env>
}
  800798:	90                   	nop
  800799:	c9                   	leave  
  80079a:	c3                   	ret    

0080079b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80079b:	55                   	push   %ebp
  80079c:	89 e5                	mov    %esp,%ebp
  80079e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8007a1:	8d 45 10             	lea    0x10(%ebp),%eax
  8007a4:	83 c0 04             	add    $0x4,%eax
  8007a7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8007aa:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007af:	85 c0                	test   %eax,%eax
  8007b1:	74 16                	je     8007c9 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8007b3:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8007b8:	83 ec 08             	sub    $0x8,%esp
  8007bb:	50                   	push   %eax
  8007bc:	68 88 3a 80 00       	push   $0x803a88
  8007c1:	e8 89 02 00 00       	call   800a4f <cprintf>
  8007c6:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8007c9:	a1 00 50 80 00       	mov    0x805000,%eax
  8007ce:	ff 75 0c             	pushl  0xc(%ebp)
  8007d1:	ff 75 08             	pushl  0x8(%ebp)
  8007d4:	50                   	push   %eax
  8007d5:	68 8d 3a 80 00       	push   $0x803a8d
  8007da:	e8 70 02 00 00       	call   800a4f <cprintf>
  8007df:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	83 ec 08             	sub    $0x8,%esp
  8007e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8007eb:	50                   	push   %eax
  8007ec:	e8 f3 01 00 00       	call   8009e4 <vcprintf>
  8007f1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8007f4:	83 ec 08             	sub    $0x8,%esp
  8007f7:	6a 00                	push   $0x0
  8007f9:	68 a9 3a 80 00       	push   $0x803aa9
  8007fe:	e8 e1 01 00 00       	call   8009e4 <vcprintf>
  800803:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800806:	e8 82 ff ff ff       	call   80078d <exit>

	// should not return here
	while (1) ;
  80080b:	eb fe                	jmp    80080b <_panic+0x70>

0080080d <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80080d:	55                   	push   %ebp
  80080e:	89 e5                	mov    %esp,%ebp
  800810:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800813:	a1 20 50 80 00       	mov    0x805020,%eax
  800818:	8b 50 74             	mov    0x74(%eax),%edx
  80081b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80081e:	39 c2                	cmp    %eax,%edx
  800820:	74 14                	je     800836 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800822:	83 ec 04             	sub    $0x4,%esp
  800825:	68 ac 3a 80 00       	push   $0x803aac
  80082a:	6a 26                	push   $0x26
  80082c:	68 f8 3a 80 00       	push   $0x803af8
  800831:	e8 65 ff ff ff       	call   80079b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800836:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80083d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800844:	e9 c2 00 00 00       	jmp    80090b <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	01 d0                	add    %edx,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	85 c0                	test   %eax,%eax
  80085c:	75 08                	jne    800866 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80085e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800861:	e9 a2 00 00 00       	jmp    800908 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800866:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80086d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800874:	eb 69                	jmp    8008df <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800876:	a1 20 50 80 00       	mov    0x805020,%eax
  80087b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800881:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800884:	89 d0                	mov    %edx,%eax
  800886:	01 c0                	add    %eax,%eax
  800888:	01 d0                	add    %edx,%eax
  80088a:	c1 e0 03             	shl    $0x3,%eax
  80088d:	01 c8                	add    %ecx,%eax
  80088f:	8a 40 04             	mov    0x4(%eax),%al
  800892:	84 c0                	test   %al,%al
  800894:	75 46                	jne    8008dc <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800896:	a1 20 50 80 00       	mov    0x805020,%eax
  80089b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008a1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8008a4:	89 d0                	mov    %edx,%eax
  8008a6:	01 c0                	add    %eax,%eax
  8008a8:	01 d0                	add    %edx,%eax
  8008aa:	c1 e0 03             	shl    $0x3,%eax
  8008ad:	01 c8                	add    %ecx,%eax
  8008af:	8b 00                	mov    (%eax),%eax
  8008b1:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8008b4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8008b7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8008bc:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8008be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008c1:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	01 c8                	add    %ecx,%eax
  8008cd:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8008cf:	39 c2                	cmp    %eax,%edx
  8008d1:	75 09                	jne    8008dc <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8008d3:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8008da:	eb 12                	jmp    8008ee <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008dc:	ff 45 e8             	incl   -0x18(%ebp)
  8008df:	a1 20 50 80 00       	mov    0x805020,%eax
  8008e4:	8b 50 74             	mov    0x74(%eax),%edx
  8008e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8008ea:	39 c2                	cmp    %eax,%edx
  8008ec:	77 88                	ja     800876 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8008ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8008f2:	75 14                	jne    800908 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8008f4:	83 ec 04             	sub    $0x4,%esp
  8008f7:	68 04 3b 80 00       	push   $0x803b04
  8008fc:	6a 3a                	push   $0x3a
  8008fe:	68 f8 3a 80 00       	push   $0x803af8
  800903:	e8 93 fe ff ff       	call   80079b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800908:	ff 45 f0             	incl   -0x10(%ebp)
  80090b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80090e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800911:	0f 8c 32 ff ff ff    	jl     800849 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800917:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80091e:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800925:	eb 26                	jmp    80094d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800927:	a1 20 50 80 00       	mov    0x805020,%eax
  80092c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800932:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800935:	89 d0                	mov    %edx,%eax
  800937:	01 c0                	add    %eax,%eax
  800939:	01 d0                	add    %edx,%eax
  80093b:	c1 e0 03             	shl    $0x3,%eax
  80093e:	01 c8                	add    %ecx,%eax
  800940:	8a 40 04             	mov    0x4(%eax),%al
  800943:	3c 01                	cmp    $0x1,%al
  800945:	75 03                	jne    80094a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800947:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80094a:	ff 45 e0             	incl   -0x20(%ebp)
  80094d:	a1 20 50 80 00       	mov    0x805020,%eax
  800952:	8b 50 74             	mov    0x74(%eax),%edx
  800955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800958:	39 c2                	cmp    %eax,%edx
  80095a:	77 cb                	ja     800927 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80095c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80095f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800962:	74 14                	je     800978 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800964:	83 ec 04             	sub    $0x4,%esp
  800967:	68 58 3b 80 00       	push   $0x803b58
  80096c:	6a 44                	push   $0x44
  80096e:	68 f8 3a 80 00       	push   $0x803af8
  800973:	e8 23 fe ff ff       	call   80079b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800978:	90                   	nop
  800979:	c9                   	leave  
  80097a:	c3                   	ret    

0080097b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800981:	8b 45 0c             	mov    0xc(%ebp),%eax
  800984:	8b 00                	mov    (%eax),%eax
  800986:	8d 48 01             	lea    0x1(%eax),%ecx
  800989:	8b 55 0c             	mov    0xc(%ebp),%edx
  80098c:	89 0a                	mov    %ecx,(%edx)
  80098e:	8b 55 08             	mov    0x8(%ebp),%edx
  800991:	88 d1                	mov    %dl,%cl
  800993:	8b 55 0c             	mov    0xc(%ebp),%edx
  800996:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80099a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80099d:	8b 00                	mov    (%eax),%eax
  80099f:	3d ff 00 00 00       	cmp    $0xff,%eax
  8009a4:	75 2c                	jne    8009d2 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8009a6:	a0 24 50 80 00       	mov    0x805024,%al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b1:	8b 12                	mov    (%edx),%edx
  8009b3:	89 d1                	mov    %edx,%ecx
  8009b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8009b8:	83 c2 08             	add    $0x8,%edx
  8009bb:	83 ec 04             	sub    $0x4,%esp
  8009be:	50                   	push   %eax
  8009bf:	51                   	push   %ecx
  8009c0:	52                   	push   %edx
  8009c1:	e8 05 14 00 00       	call   801dcb <sys_cputs>
  8009c6:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8009c9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8009d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d5:	8b 40 04             	mov    0x4(%eax),%eax
  8009d8:	8d 50 01             	lea    0x1(%eax),%edx
  8009db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009de:	89 50 04             	mov    %edx,0x4(%eax)
}
  8009e1:	90                   	nop
  8009e2:	c9                   	leave  
  8009e3:	c3                   	ret    

008009e4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8009ed:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8009f4:	00 00 00 
	b.cnt = 0;
  8009f7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8009fe:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800a01:	ff 75 0c             	pushl  0xc(%ebp)
  800a04:	ff 75 08             	pushl  0x8(%ebp)
  800a07:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a0d:	50                   	push   %eax
  800a0e:	68 7b 09 80 00       	push   $0x80097b
  800a13:	e8 11 02 00 00       	call   800c29 <vprintfmt>
  800a18:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800a1b:	a0 24 50 80 00       	mov    0x805024,%al
  800a20:	0f b6 c0             	movzbl %al,%eax
  800a23:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800a29:	83 ec 04             	sub    $0x4,%esp
  800a2c:	50                   	push   %eax
  800a2d:	52                   	push   %edx
  800a2e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800a34:	83 c0 08             	add    $0x8,%eax
  800a37:	50                   	push   %eax
  800a38:	e8 8e 13 00 00       	call   801dcb <sys_cputs>
  800a3d:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800a40:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800a47:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800a4d:	c9                   	leave  
  800a4e:	c3                   	ret    

00800a4f <cprintf>:

int cprintf(const char *fmt, ...) {
  800a4f:	55                   	push   %ebp
  800a50:	89 e5                	mov    %esp,%ebp
  800a52:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800a55:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800a5c:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a62:	8b 45 08             	mov    0x8(%ebp),%eax
  800a65:	83 ec 08             	sub    $0x8,%esp
  800a68:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6b:	50                   	push   %eax
  800a6c:	e8 73 ff ff ff       	call   8009e4 <vcprintf>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a7a:	c9                   	leave  
  800a7b:	c3                   	ret    

00800a7c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a7c:	55                   	push   %ebp
  800a7d:	89 e5                	mov    %esp,%ebp
  800a7f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a82:	e8 f2 14 00 00       	call   801f79 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a87:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a8a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a90:	83 ec 08             	sub    $0x8,%esp
  800a93:	ff 75 f4             	pushl  -0xc(%ebp)
  800a96:	50                   	push   %eax
  800a97:	e8 48 ff ff ff       	call   8009e4 <vcprintf>
  800a9c:	83 c4 10             	add    $0x10,%esp
  800a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800aa2:	e8 ec 14 00 00       	call   801f93 <sys_enable_interrupt>
	return cnt;
  800aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800aaa:	c9                   	leave  
  800aab:	c3                   	ret    

00800aac <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800aac:	55                   	push   %ebp
  800aad:	89 e5                	mov    %esp,%ebp
  800aaf:	53                   	push   %ebx
  800ab0:	83 ec 14             	sub    $0x14,%esp
  800ab3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab9:	8b 45 14             	mov    0x14(%ebp),%eax
  800abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800abf:	8b 45 18             	mov    0x18(%ebp),%eax
  800ac2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ac7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800aca:	77 55                	ja     800b21 <printnum+0x75>
  800acc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800acf:	72 05                	jb     800ad6 <printnum+0x2a>
  800ad1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800ad4:	77 4b                	ja     800b21 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800ad6:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ad9:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800adc:	8b 45 18             	mov    0x18(%ebp),%eax
  800adf:	ba 00 00 00 00       	mov    $0x0,%edx
  800ae4:	52                   	push   %edx
  800ae5:	50                   	push   %eax
  800ae6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae9:	ff 75 f0             	pushl  -0x10(%ebp)
  800aec:	e8 63 2a 00 00       	call   803554 <__udivdi3>
  800af1:	83 c4 10             	add    $0x10,%esp
  800af4:	83 ec 04             	sub    $0x4,%esp
  800af7:	ff 75 20             	pushl  0x20(%ebp)
  800afa:	53                   	push   %ebx
  800afb:	ff 75 18             	pushl  0x18(%ebp)
  800afe:	52                   	push   %edx
  800aff:	50                   	push   %eax
  800b00:	ff 75 0c             	pushl  0xc(%ebp)
  800b03:	ff 75 08             	pushl  0x8(%ebp)
  800b06:	e8 a1 ff ff ff       	call   800aac <printnum>
  800b0b:	83 c4 20             	add    $0x20,%esp
  800b0e:	eb 1a                	jmp    800b2a <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	ff 75 20             	pushl  0x20(%ebp)
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	ff d0                	call   *%eax
  800b1e:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800b21:	ff 4d 1c             	decl   0x1c(%ebp)
  800b24:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800b28:	7f e6                	jg     800b10 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800b2a:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800b2d:	bb 00 00 00 00       	mov    $0x0,%ebx
  800b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b35:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b38:	53                   	push   %ebx
  800b39:	51                   	push   %ecx
  800b3a:	52                   	push   %edx
  800b3b:	50                   	push   %eax
  800b3c:	e8 23 2b 00 00       	call   803664 <__umoddi3>
  800b41:	83 c4 10             	add    $0x10,%esp
  800b44:	05 d4 3d 80 00       	add    $0x803dd4,%eax
  800b49:	8a 00                	mov    (%eax),%al
  800b4b:	0f be c0             	movsbl %al,%eax
  800b4e:	83 ec 08             	sub    $0x8,%esp
  800b51:	ff 75 0c             	pushl  0xc(%ebp)
  800b54:	50                   	push   %eax
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
}
  800b5d:	90                   	nop
  800b5e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800b61:	c9                   	leave  
  800b62:	c3                   	ret    

00800b63 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800b63:	55                   	push   %ebp
  800b64:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b66:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b6a:	7e 1c                	jle    800b88 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6f:	8b 00                	mov    (%eax),%eax
  800b71:	8d 50 08             	lea    0x8(%eax),%edx
  800b74:	8b 45 08             	mov    0x8(%ebp),%eax
  800b77:	89 10                	mov    %edx,(%eax)
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8b 00                	mov    (%eax),%eax
  800b7e:	83 e8 08             	sub    $0x8,%eax
  800b81:	8b 50 04             	mov    0x4(%eax),%edx
  800b84:	8b 00                	mov    (%eax),%eax
  800b86:	eb 40                	jmp    800bc8 <getuint+0x65>
	else if (lflag)
  800b88:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b8c:	74 1e                	je     800bac <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b91:	8b 00                	mov    (%eax),%eax
  800b93:	8d 50 04             	lea    0x4(%eax),%edx
  800b96:	8b 45 08             	mov    0x8(%ebp),%eax
  800b99:	89 10                	mov    %edx,(%eax)
  800b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9e:	8b 00                	mov    (%eax),%eax
  800ba0:	83 e8 04             	sub    $0x4,%eax
  800ba3:	8b 00                	mov    (%eax),%eax
  800ba5:	ba 00 00 00 00       	mov    $0x0,%edx
  800baa:	eb 1c                	jmp    800bc8 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800bac:	8b 45 08             	mov    0x8(%ebp),%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	8d 50 04             	lea    0x4(%eax),%edx
  800bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb7:	89 10                	mov    %edx,(%eax)
  800bb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbc:	8b 00                	mov    (%eax),%eax
  800bbe:	83 e8 04             	sub    $0x4,%eax
  800bc1:	8b 00                	mov    (%eax),%eax
  800bc3:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800bc8:	5d                   	pop    %ebp
  800bc9:	c3                   	ret    

00800bca <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800bcd:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800bd1:	7e 1c                	jle    800bef <getint+0x25>
		return va_arg(*ap, long long);
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	8b 00                	mov    (%eax),%eax
  800bd8:	8d 50 08             	lea    0x8(%eax),%edx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	89 10                	mov    %edx,(%eax)
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	8b 00                	mov    (%eax),%eax
  800be5:	83 e8 08             	sub    $0x8,%eax
  800be8:	8b 50 04             	mov    0x4(%eax),%edx
  800beb:	8b 00                	mov    (%eax),%eax
  800bed:	eb 38                	jmp    800c27 <getint+0x5d>
	else if (lflag)
  800bef:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf3:	74 1a                	je     800c0f <getint+0x45>
		return va_arg(*ap, long);
  800bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf8:	8b 00                	mov    (%eax),%eax
  800bfa:	8d 50 04             	lea    0x4(%eax),%edx
  800bfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800c00:	89 10                	mov    %edx,(%eax)
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	8b 00                	mov    (%eax),%eax
  800c07:	83 e8 04             	sub    $0x4,%eax
  800c0a:	8b 00                	mov    (%eax),%eax
  800c0c:	99                   	cltd   
  800c0d:	eb 18                	jmp    800c27 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c12:	8b 00                	mov    (%eax),%eax
  800c14:	8d 50 04             	lea    0x4(%eax),%edx
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	89 10                	mov    %edx,(%eax)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8b 00                	mov    (%eax),%eax
  800c21:	83 e8 04             	sub    $0x4,%eax
  800c24:	8b 00                	mov    (%eax),%eax
  800c26:	99                   	cltd   
}
  800c27:	5d                   	pop    %ebp
  800c28:	c3                   	ret    

00800c29 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800c29:	55                   	push   %ebp
  800c2a:	89 e5                	mov    %esp,%ebp
  800c2c:	56                   	push   %esi
  800c2d:	53                   	push   %ebx
  800c2e:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c31:	eb 17                	jmp    800c4a <vprintfmt+0x21>
			if (ch == '\0')
  800c33:	85 db                	test   %ebx,%ebx
  800c35:	0f 84 af 03 00 00    	je     800fea <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800c3b:	83 ec 08             	sub    $0x8,%esp
  800c3e:	ff 75 0c             	pushl  0xc(%ebp)
  800c41:	53                   	push   %ebx
  800c42:	8b 45 08             	mov    0x8(%ebp),%eax
  800c45:	ff d0                	call   *%eax
  800c47:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 10             	mov    %edx,0x10(%ebp)
  800c53:	8a 00                	mov    (%eax),%al
  800c55:	0f b6 d8             	movzbl %al,%ebx
  800c58:	83 fb 25             	cmp    $0x25,%ebx
  800c5b:	75 d6                	jne    800c33 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800c5d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800c61:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800c68:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800c6f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c76:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c7d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c80:	8d 50 01             	lea    0x1(%eax),%edx
  800c83:	89 55 10             	mov    %edx,0x10(%ebp)
  800c86:	8a 00                	mov    (%eax),%al
  800c88:	0f b6 d8             	movzbl %al,%ebx
  800c8b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c8e:	83 f8 55             	cmp    $0x55,%eax
  800c91:	0f 87 2b 03 00 00    	ja     800fc2 <vprintfmt+0x399>
  800c97:	8b 04 85 f8 3d 80 00 	mov    0x803df8(,%eax,4),%eax
  800c9e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ca0:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800ca4:	eb d7                	jmp    800c7d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ca6:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800caa:	eb d1                	jmp    800c7d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cac:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800cb3:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800cb6:	89 d0                	mov    %edx,%eax
  800cb8:	c1 e0 02             	shl    $0x2,%eax
  800cbb:	01 d0                	add    %edx,%eax
  800cbd:	01 c0                	add    %eax,%eax
  800cbf:	01 d8                	add    %ebx,%eax
  800cc1:	83 e8 30             	sub    $0x30,%eax
  800cc4:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800cc7:	8b 45 10             	mov    0x10(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ccf:	83 fb 2f             	cmp    $0x2f,%ebx
  800cd2:	7e 3e                	jle    800d12 <vprintfmt+0xe9>
  800cd4:	83 fb 39             	cmp    $0x39,%ebx
  800cd7:	7f 39                	jg     800d12 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800cd9:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800cdc:	eb d5                	jmp    800cb3 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800cde:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce1:	83 c0 04             	add    $0x4,%eax
  800ce4:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 e8 04             	sub    $0x4,%eax
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800cf2:	eb 1f                	jmp    800d13 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800cf4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800cf8:	79 83                	jns    800c7d <vprintfmt+0x54>
				width = 0;
  800cfa:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800d01:	e9 77 ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800d06:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800d0d:	e9 6b ff ff ff       	jmp    800c7d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800d12:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800d13:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d17:	0f 89 60 ff ff ff    	jns    800c7d <vprintfmt+0x54>
				width = precision, precision = -1;
  800d1d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d20:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800d23:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800d2a:	e9 4e ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800d2f:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800d32:	e9 46 ff ff ff       	jmp    800c7d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800d37:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3a:	83 c0 04             	add    $0x4,%eax
  800d3d:	89 45 14             	mov    %eax,0x14(%ebp)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 e8 04             	sub    $0x4,%eax
  800d46:	8b 00                	mov    (%eax),%eax
  800d48:	83 ec 08             	sub    $0x8,%esp
  800d4b:	ff 75 0c             	pushl  0xc(%ebp)
  800d4e:	50                   	push   %eax
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	ff d0                	call   *%eax
  800d54:	83 c4 10             	add    $0x10,%esp
			break;
  800d57:	e9 89 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800d5c:	8b 45 14             	mov    0x14(%ebp),%eax
  800d5f:	83 c0 04             	add    $0x4,%eax
  800d62:	89 45 14             	mov    %eax,0x14(%ebp)
  800d65:	8b 45 14             	mov    0x14(%ebp),%eax
  800d68:	83 e8 04             	sub    $0x4,%eax
  800d6b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800d6d:	85 db                	test   %ebx,%ebx
  800d6f:	79 02                	jns    800d73 <vprintfmt+0x14a>
				err = -err;
  800d71:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800d73:	83 fb 64             	cmp    $0x64,%ebx
  800d76:	7f 0b                	jg     800d83 <vprintfmt+0x15a>
  800d78:	8b 34 9d 40 3c 80 00 	mov    0x803c40(,%ebx,4),%esi
  800d7f:	85 f6                	test   %esi,%esi
  800d81:	75 19                	jne    800d9c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d83:	53                   	push   %ebx
  800d84:	68 e5 3d 80 00       	push   $0x803de5
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	ff 75 08             	pushl  0x8(%ebp)
  800d8f:	e8 5e 02 00 00       	call   800ff2 <printfmt>
  800d94:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d97:	e9 49 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d9c:	56                   	push   %esi
  800d9d:	68 ee 3d 80 00       	push   $0x803dee
  800da2:	ff 75 0c             	pushl  0xc(%ebp)
  800da5:	ff 75 08             	pushl  0x8(%ebp)
  800da8:	e8 45 02 00 00       	call   800ff2 <printfmt>
  800dad:	83 c4 10             	add    $0x10,%esp
			break;
  800db0:	e9 30 02 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800db5:	8b 45 14             	mov    0x14(%ebp),%eax
  800db8:	83 c0 04             	add    $0x4,%eax
  800dbb:	89 45 14             	mov    %eax,0x14(%ebp)
  800dbe:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc1:	83 e8 04             	sub    $0x4,%eax
  800dc4:	8b 30                	mov    (%eax),%esi
  800dc6:	85 f6                	test   %esi,%esi
  800dc8:	75 05                	jne    800dcf <vprintfmt+0x1a6>
				p = "(null)";
  800dca:	be f1 3d 80 00       	mov    $0x803df1,%esi
			if (width > 0 && padc != '-')
  800dcf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dd3:	7e 6d                	jle    800e42 <vprintfmt+0x219>
  800dd5:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800dd9:	74 67                	je     800e42 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800ddb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800dde:	83 ec 08             	sub    $0x8,%esp
  800de1:	50                   	push   %eax
  800de2:	56                   	push   %esi
  800de3:	e8 0c 03 00 00       	call   8010f4 <strnlen>
  800de8:	83 c4 10             	add    $0x10,%esp
  800deb:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800dee:	eb 16                	jmp    800e06 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800df0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800df4:	83 ec 08             	sub    $0x8,%esp
  800df7:	ff 75 0c             	pushl  0xc(%ebp)
  800dfa:	50                   	push   %eax
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	ff d0                	call   *%eax
  800e00:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800e03:	ff 4d e4             	decl   -0x1c(%ebp)
  800e06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e0a:	7f e4                	jg     800df0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e0c:	eb 34                	jmp    800e42 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800e0e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800e12:	74 1c                	je     800e30 <vprintfmt+0x207>
  800e14:	83 fb 1f             	cmp    $0x1f,%ebx
  800e17:	7e 05                	jle    800e1e <vprintfmt+0x1f5>
  800e19:	83 fb 7e             	cmp    $0x7e,%ebx
  800e1c:	7e 12                	jle    800e30 <vprintfmt+0x207>
					putch('?', putdat);
  800e1e:	83 ec 08             	sub    $0x8,%esp
  800e21:	ff 75 0c             	pushl  0xc(%ebp)
  800e24:	6a 3f                	push   $0x3f
  800e26:	8b 45 08             	mov    0x8(%ebp),%eax
  800e29:	ff d0                	call   *%eax
  800e2b:	83 c4 10             	add    $0x10,%esp
  800e2e:	eb 0f                	jmp    800e3f <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800e30:	83 ec 08             	sub    $0x8,%esp
  800e33:	ff 75 0c             	pushl  0xc(%ebp)
  800e36:	53                   	push   %ebx
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3a:	ff d0                	call   *%eax
  800e3c:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800e3f:	ff 4d e4             	decl   -0x1c(%ebp)
  800e42:	89 f0                	mov    %esi,%eax
  800e44:	8d 70 01             	lea    0x1(%eax),%esi
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	0f be d8             	movsbl %al,%ebx
  800e4c:	85 db                	test   %ebx,%ebx
  800e4e:	74 24                	je     800e74 <vprintfmt+0x24b>
  800e50:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e54:	78 b8                	js     800e0e <vprintfmt+0x1e5>
  800e56:	ff 4d e0             	decl   -0x20(%ebp)
  800e59:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800e5d:	79 af                	jns    800e0e <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e5f:	eb 13                	jmp    800e74 <vprintfmt+0x24b>
				putch(' ', putdat);
  800e61:	83 ec 08             	sub    $0x8,%esp
  800e64:	ff 75 0c             	pushl  0xc(%ebp)
  800e67:	6a 20                	push   $0x20
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	ff d0                	call   *%eax
  800e6e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800e71:	ff 4d e4             	decl   -0x1c(%ebp)
  800e74:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e78:	7f e7                	jg     800e61 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e7a:	e9 66 01 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 e8             	pushl  -0x18(%ebp)
  800e85:	8d 45 14             	lea    0x14(%ebp),%eax
  800e88:	50                   	push   %eax
  800e89:	e8 3c fd ff ff       	call   800bca <getint>
  800e8e:	83 c4 10             	add    $0x10,%esp
  800e91:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e94:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e9a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e9d:	85 d2                	test   %edx,%edx
  800e9f:	79 23                	jns    800ec4 <vprintfmt+0x29b>
				putch('-', putdat);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	6a 2d                	push   $0x2d
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	ff d0                	call   *%eax
  800eae:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800eb1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800eb4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800eb7:	f7 d8                	neg    %eax
  800eb9:	83 d2 00             	adc    $0x0,%edx
  800ebc:	f7 da                	neg    %edx
  800ebe:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ec4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ecb:	e9 bc 00 00 00       	jmp    800f8c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ed0:	83 ec 08             	sub    $0x8,%esp
  800ed3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ed6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ed9:	50                   	push   %eax
  800eda:	e8 84 fc ff ff       	call   800b63 <getuint>
  800edf:	83 c4 10             	add    $0x10,%esp
  800ee2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ee8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800eef:	e9 98 00 00 00       	jmp    800f8c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ef4:	83 ec 08             	sub    $0x8,%esp
  800ef7:	ff 75 0c             	pushl  0xc(%ebp)
  800efa:	6a 58                	push   $0x58
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	ff d0                	call   *%eax
  800f01:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f04:	83 ec 08             	sub    $0x8,%esp
  800f07:	ff 75 0c             	pushl  0xc(%ebp)
  800f0a:	6a 58                	push   $0x58
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	ff d0                	call   *%eax
  800f11:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800f14:	83 ec 08             	sub    $0x8,%esp
  800f17:	ff 75 0c             	pushl  0xc(%ebp)
  800f1a:	6a 58                	push   $0x58
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	ff d0                	call   *%eax
  800f21:	83 c4 10             	add    $0x10,%esp
			break;
  800f24:	e9 bc 00 00 00       	jmp    800fe5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800f29:	83 ec 08             	sub    $0x8,%esp
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	6a 30                	push   $0x30
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	ff d0                	call   *%eax
  800f36:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800f39:	83 ec 08             	sub    $0x8,%esp
  800f3c:	ff 75 0c             	pushl  0xc(%ebp)
  800f3f:	6a 78                	push   $0x78
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	ff d0                	call   *%eax
  800f46:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800f49:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4c:	83 c0 04             	add    $0x4,%eax
  800f4f:	89 45 14             	mov    %eax,0x14(%ebp)
  800f52:	8b 45 14             	mov    0x14(%ebp),%eax
  800f55:	83 e8 04             	sub    $0x4,%eax
  800f58:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f5d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800f64:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800f6b:	eb 1f                	jmp    800f8c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800f6d:	83 ec 08             	sub    $0x8,%esp
  800f70:	ff 75 e8             	pushl  -0x18(%ebp)
  800f73:	8d 45 14             	lea    0x14(%ebp),%eax
  800f76:	50                   	push   %eax
  800f77:	e8 e7 fb ff ff       	call   800b63 <getuint>
  800f7c:	83 c4 10             	add    $0x10,%esp
  800f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f82:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f85:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f8c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f90:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f93:	83 ec 04             	sub    $0x4,%esp
  800f96:	52                   	push   %edx
  800f97:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f9a:	50                   	push   %eax
  800f9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800f9e:	ff 75 f0             	pushl  -0x10(%ebp)
  800fa1:	ff 75 0c             	pushl  0xc(%ebp)
  800fa4:	ff 75 08             	pushl  0x8(%ebp)
  800fa7:	e8 00 fb ff ff       	call   800aac <printnum>
  800fac:	83 c4 20             	add    $0x20,%esp
			break;
  800faf:	eb 34                	jmp    800fe5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800fb1:	83 ec 08             	sub    $0x8,%esp
  800fb4:	ff 75 0c             	pushl  0xc(%ebp)
  800fb7:	53                   	push   %ebx
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	ff d0                	call   *%eax
  800fbd:	83 c4 10             	add    $0x10,%esp
			break;
  800fc0:	eb 23                	jmp    800fe5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800fc2:	83 ec 08             	sub    $0x8,%esp
  800fc5:	ff 75 0c             	pushl  0xc(%ebp)
  800fc8:	6a 25                	push   $0x25
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	ff d0                	call   *%eax
  800fcf:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800fd2:	ff 4d 10             	decl   0x10(%ebp)
  800fd5:	eb 03                	jmp    800fda <vprintfmt+0x3b1>
  800fd7:	ff 4d 10             	decl   0x10(%ebp)
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	48                   	dec    %eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	3c 25                	cmp    $0x25,%al
  800fe2:	75 f3                	jne    800fd7 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800fe4:	90                   	nop
		}
	}
  800fe5:	e9 47 fc ff ff       	jmp    800c31 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800fea:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800feb:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800fee:	5b                   	pop    %ebx
  800fef:	5e                   	pop    %esi
  800ff0:	5d                   	pop    %ebp
  800ff1:	c3                   	ret    

00800ff2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ff2:	55                   	push   %ebp
  800ff3:	89 e5                	mov    %esp,%ebp
  800ff5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ff8:	8d 45 10             	lea    0x10(%ebp),%eax
  800ffb:	83 c0 04             	add    $0x4,%eax
  800ffe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801001:	8b 45 10             	mov    0x10(%ebp),%eax
  801004:	ff 75 f4             	pushl  -0xc(%ebp)
  801007:	50                   	push   %eax
  801008:	ff 75 0c             	pushl  0xc(%ebp)
  80100b:	ff 75 08             	pushl  0x8(%ebp)
  80100e:	e8 16 fc ff ff       	call   800c29 <vprintfmt>
  801013:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801016:	90                   	nop
  801017:	c9                   	leave  
  801018:	c3                   	ret    

00801019 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801019:	55                   	push   %ebp
  80101a:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	8b 40 08             	mov    0x8(%eax),%eax
  801022:	8d 50 01             	lea    0x1(%eax),%edx
  801025:	8b 45 0c             	mov    0xc(%ebp),%eax
  801028:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80102b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80102e:	8b 10                	mov    (%eax),%edx
  801030:	8b 45 0c             	mov    0xc(%ebp),%eax
  801033:	8b 40 04             	mov    0x4(%eax),%eax
  801036:	39 c2                	cmp    %eax,%edx
  801038:	73 12                	jae    80104c <sprintputch+0x33>
		*b->buf++ = ch;
  80103a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103d:	8b 00                	mov    (%eax),%eax
  80103f:	8d 48 01             	lea    0x1(%eax),%ecx
  801042:	8b 55 0c             	mov    0xc(%ebp),%edx
  801045:	89 0a                	mov    %ecx,(%edx)
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	88 10                	mov    %dl,(%eax)
}
  80104c:	90                   	nop
  80104d:	5d                   	pop    %ebp
  80104e:	c3                   	ret    

0080104f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80104f:	55                   	push   %ebp
  801050:	89 e5                	mov    %esp,%ebp
  801052:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80105b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	01 d0                	add    %edx,%eax
  801066:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801070:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801074:	74 06                	je     80107c <vsnprintf+0x2d>
  801076:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107a:	7f 07                	jg     801083 <vsnprintf+0x34>
		return -E_INVAL;
  80107c:	b8 03 00 00 00       	mov    $0x3,%eax
  801081:	eb 20                	jmp    8010a3 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801083:	ff 75 14             	pushl  0x14(%ebp)
  801086:	ff 75 10             	pushl  0x10(%ebp)
  801089:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80108c:	50                   	push   %eax
  80108d:	68 19 10 80 00       	push   $0x801019
  801092:	e8 92 fb ff ff       	call   800c29 <vprintfmt>
  801097:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80109a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80109d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8010a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8010a3:	c9                   	leave  
  8010a4:	c3                   	ret    

008010a5 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8010a5:	55                   	push   %ebp
  8010a6:	89 e5                	mov    %esp,%ebp
  8010a8:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8010ab:	8d 45 10             	lea    0x10(%ebp),%eax
  8010ae:	83 c0 04             	add    $0x4,%eax
  8010b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8010b4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8010ba:	50                   	push   %eax
  8010bb:	ff 75 0c             	pushl  0xc(%ebp)
  8010be:	ff 75 08             	pushl  0x8(%ebp)
  8010c1:	e8 89 ff ff ff       	call   80104f <vsnprintf>
  8010c6:	83 c4 10             	add    $0x10,%esp
  8010c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8010cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8010d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010de:	eb 06                	jmp    8010e6 <strlen+0x15>
		n++;
  8010e0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8010e3:	ff 45 08             	incl   0x8(%ebp)
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8a 00                	mov    (%eax),%al
  8010eb:	84 c0                	test   %al,%al
  8010ed:	75 f1                	jne    8010e0 <strlen+0xf>
		n++;
	return n;
  8010ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8010fa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801101:	eb 09                	jmp    80110c <strnlen+0x18>
		n++;
  801103:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801106:	ff 45 08             	incl   0x8(%ebp)
  801109:	ff 4d 0c             	decl   0xc(%ebp)
  80110c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801110:	74 09                	je     80111b <strnlen+0x27>
  801112:	8b 45 08             	mov    0x8(%ebp),%eax
  801115:	8a 00                	mov    (%eax),%al
  801117:	84 c0                	test   %al,%al
  801119:	75 e8                	jne    801103 <strnlen+0xf>
		n++;
	return n;
  80111b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80111e:	c9                   	leave  
  80111f:	c3                   	ret    

00801120 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801120:	55                   	push   %ebp
  801121:	89 e5                	mov    %esp,%ebp
  801123:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  80112c:	90                   	nop
  80112d:	8b 45 08             	mov    0x8(%ebp),%eax
  801130:	8d 50 01             	lea    0x1(%eax),%edx
  801133:	89 55 08             	mov    %edx,0x8(%ebp)
  801136:	8b 55 0c             	mov    0xc(%ebp),%edx
  801139:	8d 4a 01             	lea    0x1(%edx),%ecx
  80113c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80113f:	8a 12                	mov    (%edx),%dl
  801141:	88 10                	mov    %dl,(%eax)
  801143:	8a 00                	mov    (%eax),%al
  801145:	84 c0                	test   %al,%al
  801147:	75 e4                	jne    80112d <strcpy+0xd>
		/* do nothing */;
	return ret;
  801149:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80114c:	c9                   	leave  
  80114d:	c3                   	ret    

0080114e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80114e:	55                   	push   %ebp
  80114f:	89 e5                	mov    %esp,%ebp
  801151:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  80115a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801161:	eb 1f                	jmp    801182 <strncpy+0x34>
		*dst++ = *src;
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8d 50 01             	lea    0x1(%eax),%edx
  801169:	89 55 08             	mov    %edx,0x8(%ebp)
  80116c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80116f:	8a 12                	mov    (%edx),%dl
  801171:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	8a 00                	mov    (%eax),%al
  801178:	84 c0                	test   %al,%al
  80117a:	74 03                	je     80117f <strncpy+0x31>
			src++;
  80117c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80117f:	ff 45 fc             	incl   -0x4(%ebp)
  801182:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801185:	3b 45 10             	cmp    0x10(%ebp),%eax
  801188:	72 d9                	jb     801163 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80118a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80118d:	c9                   	leave  
  80118e:	c3                   	ret    

0080118f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80118f:	55                   	push   %ebp
  801190:	89 e5                	mov    %esp,%ebp
  801192:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80119b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80119f:	74 30                	je     8011d1 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8011a1:	eb 16                	jmp    8011b9 <strlcpy+0x2a>
			*dst++ = *src++;
  8011a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a6:	8d 50 01             	lea    0x1(%eax),%edx
  8011a9:	89 55 08             	mov    %edx,0x8(%ebp)
  8011ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8011af:	8d 4a 01             	lea    0x1(%edx),%ecx
  8011b2:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8011b5:	8a 12                	mov    (%edx),%dl
  8011b7:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8011b9:	ff 4d 10             	decl   0x10(%ebp)
  8011bc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c0:	74 09                	je     8011cb <strlcpy+0x3c>
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	8a 00                	mov    (%eax),%al
  8011c7:	84 c0                	test   %al,%al
  8011c9:	75 d8                	jne    8011a3 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8011cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ce:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8011d1:	8b 55 08             	mov    0x8(%ebp),%edx
  8011d4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d7:	29 c2                	sub    %eax,%edx
  8011d9:	89 d0                	mov    %edx,%eax
}
  8011db:	c9                   	leave  
  8011dc:	c3                   	ret    

008011dd <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8011dd:	55                   	push   %ebp
  8011de:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8011e0:	eb 06                	jmp    8011e8 <strcmp+0xb>
		p++, q++;
  8011e2:	ff 45 08             	incl   0x8(%ebp)
  8011e5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8011e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011eb:	8a 00                	mov    (%eax),%al
  8011ed:	84 c0                	test   %al,%al
  8011ef:	74 0e                	je     8011ff <strcmp+0x22>
  8011f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f4:	8a 10                	mov    (%eax),%dl
  8011f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	38 c2                	cmp    %al,%dl
  8011fd:	74 e3                	je     8011e2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f b6 d0             	movzbl %al,%edx
  801207:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	0f b6 c0             	movzbl %al,%eax
  80120f:	29 c2                	sub    %eax,%edx
  801211:	89 d0                	mov    %edx,%eax
}
  801213:	5d                   	pop    %ebp
  801214:	c3                   	ret    

00801215 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801218:	eb 09                	jmp    801223 <strncmp+0xe>
		n--, p++, q++;
  80121a:	ff 4d 10             	decl   0x10(%ebp)
  80121d:	ff 45 08             	incl   0x8(%ebp)
  801220:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801223:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801227:	74 17                	je     801240 <strncmp+0x2b>
  801229:	8b 45 08             	mov    0x8(%ebp),%eax
  80122c:	8a 00                	mov    (%eax),%al
  80122e:	84 c0                	test   %al,%al
  801230:	74 0e                	je     801240 <strncmp+0x2b>
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	8a 10                	mov    (%eax),%dl
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8a 00                	mov    (%eax),%al
  80123c:	38 c2                	cmp    %al,%dl
  80123e:	74 da                	je     80121a <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801240:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801244:	75 07                	jne    80124d <strncmp+0x38>
		return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 14                	jmp    801261 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80124d:	8b 45 08             	mov    0x8(%ebp),%eax
  801250:	8a 00                	mov    (%eax),%al
  801252:	0f b6 d0             	movzbl %al,%edx
  801255:	8b 45 0c             	mov    0xc(%ebp),%eax
  801258:	8a 00                	mov    (%eax),%al
  80125a:	0f b6 c0             	movzbl %al,%eax
  80125d:	29 c2                	sub    %eax,%edx
  80125f:	89 d0                	mov    %edx,%eax
}
  801261:	5d                   	pop    %ebp
  801262:	c3                   	ret    

00801263 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801263:	55                   	push   %ebp
  801264:	89 e5                	mov    %esp,%ebp
  801266:	83 ec 04             	sub    $0x4,%esp
  801269:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80126f:	eb 12                	jmp    801283 <strchr+0x20>
		if (*s == c)
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	8a 00                	mov    (%eax),%al
  801276:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801279:	75 05                	jne    801280 <strchr+0x1d>
			return (char *) s;
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	eb 11                	jmp    801291 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801280:	ff 45 08             	incl   0x8(%ebp)
  801283:	8b 45 08             	mov    0x8(%ebp),%eax
  801286:	8a 00                	mov    (%eax),%al
  801288:	84 c0                	test   %al,%al
  80128a:	75 e5                	jne    801271 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    

00801293 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 04             	sub    $0x4,%esp
  801299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80129f:	eb 0d                	jmp    8012ae <strfind+0x1b>
		if (*s == c)
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8012a9:	74 0e                	je     8012b9 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8012ab:	ff 45 08             	incl   0x8(%ebp)
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	8a 00                	mov    (%eax),%al
  8012b3:	84 c0                	test   %al,%al
  8012b5:	75 ea                	jne    8012a1 <strfind+0xe>
  8012b7:	eb 01                	jmp    8012ba <strfind+0x27>
		if (*s == c)
			break;
  8012b9:	90                   	nop
	return (char *) s;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012bd:	c9                   	leave  
  8012be:	c3                   	ret    

008012bf <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8012bf:	55                   	push   %ebp
  8012c0:	89 e5                	mov    %esp,%ebp
  8012c2:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8012c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8012d1:	eb 0e                	jmp    8012e1 <memset+0x22>
		*p++ = c;
  8012d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d6:	8d 50 01             	lea    0x1(%eax),%edx
  8012d9:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012df:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8012e1:	ff 4d f8             	decl   -0x8(%ebp)
  8012e4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8012e8:	79 e9                	jns    8012d3 <memset+0x14>
		*p++ = c;

	return v;
  8012ea:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ed:	c9                   	leave  
  8012ee:	c3                   	ret    

008012ef <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012f8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801301:	eb 16                	jmp    801319 <memcpy+0x2a>
		*d++ = *s++;
  801303:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801306:	8d 50 01             	lea    0x1(%eax),%edx
  801309:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801312:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801315:	8a 12                	mov    (%edx),%dl
  801317:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801319:	8b 45 10             	mov    0x10(%ebp),%eax
  80131c:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131f:	89 55 10             	mov    %edx,0x10(%ebp)
  801322:	85 c0                	test   %eax,%eax
  801324:	75 dd                	jne    801303 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801329:	c9                   	leave  
  80132a:	c3                   	ret    

0080132b <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  80132b:	55                   	push   %ebp
  80132c:	89 e5                	mov    %esp,%ebp
  80132e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80133d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801340:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801343:	73 50                	jae    801395 <memmove+0x6a>
  801345:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801350:	76 43                	jbe    801395 <memmove+0x6a>
		s += n;
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801358:	8b 45 10             	mov    0x10(%ebp),%eax
  80135b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80135e:	eb 10                	jmp    801370 <memmove+0x45>
			*--d = *--s;
  801360:	ff 4d f8             	decl   -0x8(%ebp)
  801363:	ff 4d fc             	decl   -0x4(%ebp)
  801366:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801369:	8a 10                	mov    (%eax),%dl
  80136b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80136e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801370:	8b 45 10             	mov    0x10(%ebp),%eax
  801373:	8d 50 ff             	lea    -0x1(%eax),%edx
  801376:	89 55 10             	mov    %edx,0x10(%ebp)
  801379:	85 c0                	test   %eax,%eax
  80137b:	75 e3                	jne    801360 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80137d:	eb 23                	jmp    8013a2 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80137f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801382:	8d 50 01             	lea    0x1(%eax),%edx
  801385:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801388:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80138b:	8d 4a 01             	lea    0x1(%edx),%ecx
  80138e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801391:	8a 12                	mov    (%edx),%dl
  801393:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801395:	8b 45 10             	mov    0x10(%ebp),%eax
  801398:	8d 50 ff             	lea    -0x1(%eax),%edx
  80139b:	89 55 10             	mov    %edx,0x10(%ebp)
  80139e:	85 c0                	test   %eax,%eax
  8013a0:	75 dd                	jne    80137f <memmove+0x54>
			*d++ = *s++;

	return dst;
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013a5:	c9                   	leave  
  8013a6:	c3                   	ret    

008013a7 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8013a7:	55                   	push   %ebp
  8013a8:	89 e5                	mov    %esp,%ebp
  8013aa:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8013ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8013b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b6:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8013b9:	eb 2a                	jmp    8013e5 <memcmp+0x3e>
		if (*s1 != *s2)
  8013bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013be:	8a 10                	mov    (%eax),%dl
  8013c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013c3:	8a 00                	mov    (%eax),%al
  8013c5:	38 c2                	cmp    %al,%dl
  8013c7:	74 16                	je     8013df <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8013c9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013cc:	8a 00                	mov    (%eax),%al
  8013ce:	0f b6 d0             	movzbl %al,%edx
  8013d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8013d4:	8a 00                	mov    (%eax),%al
  8013d6:	0f b6 c0             	movzbl %al,%eax
  8013d9:	29 c2                	sub    %eax,%edx
  8013db:	89 d0                	mov    %edx,%eax
  8013dd:	eb 18                	jmp    8013f7 <memcmp+0x50>
		s1++, s2++;
  8013df:	ff 45 fc             	incl   -0x4(%ebp)
  8013e2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8013e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8013e8:	8d 50 ff             	lea    -0x1(%eax),%edx
  8013eb:	89 55 10             	mov    %edx,0x10(%ebp)
  8013ee:	85 c0                	test   %eax,%eax
  8013f0:	75 c9                	jne    8013bb <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8013f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8013ff:	8b 55 08             	mov    0x8(%ebp),%edx
  801402:	8b 45 10             	mov    0x10(%ebp),%eax
  801405:	01 d0                	add    %edx,%eax
  801407:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80140a:	eb 15                	jmp    801421 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	0f b6 d0             	movzbl %al,%edx
  801414:	8b 45 0c             	mov    0xc(%ebp),%eax
  801417:	0f b6 c0             	movzbl %al,%eax
  80141a:	39 c2                	cmp    %eax,%edx
  80141c:	74 0d                	je     80142b <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80141e:	ff 45 08             	incl   0x8(%ebp)
  801421:	8b 45 08             	mov    0x8(%ebp),%eax
  801424:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801427:	72 e3                	jb     80140c <memfind+0x13>
  801429:	eb 01                	jmp    80142c <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80142b:	90                   	nop
	return (void *) s;
  80142c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80142f:	c9                   	leave  
  801430:	c3                   	ret    

00801431 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801431:	55                   	push   %ebp
  801432:	89 e5                	mov    %esp,%ebp
  801434:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801437:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80143e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801445:	eb 03                	jmp    80144a <strtol+0x19>
		s++;
  801447:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80144a:	8b 45 08             	mov    0x8(%ebp),%eax
  80144d:	8a 00                	mov    (%eax),%al
  80144f:	3c 20                	cmp    $0x20,%al
  801451:	74 f4                	je     801447 <strtol+0x16>
  801453:	8b 45 08             	mov    0x8(%ebp),%eax
  801456:	8a 00                	mov    (%eax),%al
  801458:	3c 09                	cmp    $0x9,%al
  80145a:	74 eb                	je     801447 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	8a 00                	mov    (%eax),%al
  801461:	3c 2b                	cmp    $0x2b,%al
  801463:	75 05                	jne    80146a <strtol+0x39>
		s++;
  801465:	ff 45 08             	incl   0x8(%ebp)
  801468:	eb 13                	jmp    80147d <strtol+0x4c>
	else if (*s == '-')
  80146a:	8b 45 08             	mov    0x8(%ebp),%eax
  80146d:	8a 00                	mov    (%eax),%al
  80146f:	3c 2d                	cmp    $0x2d,%al
  801471:	75 0a                	jne    80147d <strtol+0x4c>
		s++, neg = 1;
  801473:	ff 45 08             	incl   0x8(%ebp)
  801476:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80147d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801481:	74 06                	je     801489 <strtol+0x58>
  801483:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801487:	75 20                	jne    8014a9 <strtol+0x78>
  801489:	8b 45 08             	mov    0x8(%ebp),%eax
  80148c:	8a 00                	mov    (%eax),%al
  80148e:	3c 30                	cmp    $0x30,%al
  801490:	75 17                	jne    8014a9 <strtol+0x78>
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	40                   	inc    %eax
  801496:	8a 00                	mov    (%eax),%al
  801498:	3c 78                	cmp    $0x78,%al
  80149a:	75 0d                	jne    8014a9 <strtol+0x78>
		s += 2, base = 16;
  80149c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8014a0:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8014a7:	eb 28                	jmp    8014d1 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8014a9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014ad:	75 15                	jne    8014c4 <strtol+0x93>
  8014af:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b2:	8a 00                	mov    (%eax),%al
  8014b4:	3c 30                	cmp    $0x30,%al
  8014b6:	75 0c                	jne    8014c4 <strtol+0x93>
		s++, base = 8;
  8014b8:	ff 45 08             	incl   0x8(%ebp)
  8014bb:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8014c2:	eb 0d                	jmp    8014d1 <strtol+0xa0>
	else if (base == 0)
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	75 07                	jne    8014d1 <strtol+0xa0>
		base = 10;
  8014ca:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8014d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d4:	8a 00                	mov    (%eax),%al
  8014d6:	3c 2f                	cmp    $0x2f,%al
  8014d8:	7e 19                	jle    8014f3 <strtol+0xc2>
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8a 00                	mov    (%eax),%al
  8014df:	3c 39                	cmp    $0x39,%al
  8014e1:	7f 10                	jg     8014f3 <strtol+0xc2>
			dig = *s - '0';
  8014e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e6:	8a 00                	mov    (%eax),%al
  8014e8:	0f be c0             	movsbl %al,%eax
  8014eb:	83 e8 30             	sub    $0x30,%eax
  8014ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8014f1:	eb 42                	jmp    801535 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	3c 60                	cmp    $0x60,%al
  8014fa:	7e 19                	jle    801515 <strtol+0xe4>
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	3c 7a                	cmp    $0x7a,%al
  801503:	7f 10                	jg     801515 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801505:	8b 45 08             	mov    0x8(%ebp),%eax
  801508:	8a 00                	mov    (%eax),%al
  80150a:	0f be c0             	movsbl %al,%eax
  80150d:	83 e8 57             	sub    $0x57,%eax
  801510:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801513:	eb 20                	jmp    801535 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801515:	8b 45 08             	mov    0x8(%ebp),%eax
  801518:	8a 00                	mov    (%eax),%al
  80151a:	3c 40                	cmp    $0x40,%al
  80151c:	7e 39                	jle    801557 <strtol+0x126>
  80151e:	8b 45 08             	mov    0x8(%ebp),%eax
  801521:	8a 00                	mov    (%eax),%al
  801523:	3c 5a                	cmp    $0x5a,%al
  801525:	7f 30                	jg     801557 <strtol+0x126>
			dig = *s - 'A' + 10;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	8a 00                	mov    (%eax),%al
  80152c:	0f be c0             	movsbl %al,%eax
  80152f:	83 e8 37             	sub    $0x37,%eax
  801532:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801538:	3b 45 10             	cmp    0x10(%ebp),%eax
  80153b:	7d 19                	jge    801556 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80153d:	ff 45 08             	incl   0x8(%ebp)
  801540:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801543:	0f af 45 10          	imul   0x10(%ebp),%eax
  801547:	89 c2                	mov    %eax,%edx
  801549:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154c:	01 d0                	add    %edx,%eax
  80154e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801551:	e9 7b ff ff ff       	jmp    8014d1 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801556:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801557:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80155b:	74 08                	je     801565 <strtol+0x134>
		*endptr = (char *) s;
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	8b 55 08             	mov    0x8(%ebp),%edx
  801563:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801565:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801569:	74 07                	je     801572 <strtol+0x141>
  80156b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80156e:	f7 d8                	neg    %eax
  801570:	eb 03                	jmp    801575 <strtol+0x144>
  801572:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801575:	c9                   	leave  
  801576:	c3                   	ret    

00801577 <ltostr>:

void
ltostr(long value, char *str)
{
  801577:	55                   	push   %ebp
  801578:	89 e5                	mov    %esp,%ebp
  80157a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80157d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801584:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80158b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80158f:	79 13                	jns    8015a4 <ltostr+0x2d>
	{
		neg = 1;
  801591:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80159b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80159e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8015a1:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8015a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a7:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8015ac:	99                   	cltd   
  8015ad:	f7 f9                	idiv   %ecx
  8015af:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8015b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8015b5:	8d 50 01             	lea    0x1(%eax),%edx
  8015b8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8015bb:	89 c2                	mov    %eax,%edx
  8015bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c0:	01 d0                	add    %edx,%eax
  8015c2:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8015c5:	83 c2 30             	add    $0x30,%edx
  8015c8:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8015ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015cd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015d2:	f7 e9                	imul   %ecx
  8015d4:	c1 fa 02             	sar    $0x2,%edx
  8015d7:	89 c8                	mov    %ecx,%eax
  8015d9:	c1 f8 1f             	sar    $0x1f,%eax
  8015dc:	29 c2                	sub    %eax,%edx
  8015de:	89 d0                	mov    %edx,%eax
  8015e0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8015e3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8015e6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8015eb:	f7 e9                	imul   %ecx
  8015ed:	c1 fa 02             	sar    $0x2,%edx
  8015f0:	89 c8                	mov    %ecx,%eax
  8015f2:	c1 f8 1f             	sar    $0x1f,%eax
  8015f5:	29 c2                	sub    %eax,%edx
  8015f7:	89 d0                	mov    %edx,%eax
  8015f9:	c1 e0 02             	shl    $0x2,%eax
  8015fc:	01 d0                	add    %edx,%eax
  8015fe:	01 c0                	add    %eax,%eax
  801600:	29 c1                	sub    %eax,%ecx
  801602:	89 ca                	mov    %ecx,%edx
  801604:	85 d2                	test   %edx,%edx
  801606:	75 9c                	jne    8015a4 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801608:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80160f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801612:	48                   	dec    %eax
  801613:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801616:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80161a:	74 3d                	je     801659 <ltostr+0xe2>
		start = 1 ;
  80161c:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801623:	eb 34                	jmp    801659 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801625:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801628:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162b:	01 d0                	add    %edx,%eax
  80162d:	8a 00                	mov    (%eax),%al
  80162f:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801632:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801635:	8b 45 0c             	mov    0xc(%ebp),%eax
  801638:	01 c2                	add    %eax,%edx
  80163a:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80163d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801640:	01 c8                	add    %ecx,%eax
  801642:	8a 00                	mov    (%eax),%al
  801644:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801646:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801649:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164c:	01 c2                	add    %eax,%edx
  80164e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801651:	88 02                	mov    %al,(%edx)
		start++ ;
  801653:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801656:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801659:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80165c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165f:	7c c4                	jl     801625 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801661:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801664:	8b 45 0c             	mov    0xc(%ebp),%eax
  801667:	01 d0                	add    %edx,%eax
  801669:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80166c:	90                   	nop
  80166d:	c9                   	leave  
  80166e:	c3                   	ret    

0080166f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80166f:	55                   	push   %ebp
  801670:	89 e5                	mov    %esp,%ebp
  801672:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801675:	ff 75 08             	pushl  0x8(%ebp)
  801678:	e8 54 fa ff ff       	call   8010d1 <strlen>
  80167d:	83 c4 04             	add    $0x4,%esp
  801680:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801683:	ff 75 0c             	pushl  0xc(%ebp)
  801686:	e8 46 fa ff ff       	call   8010d1 <strlen>
  80168b:	83 c4 04             	add    $0x4,%esp
  80168e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801691:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801698:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80169f:	eb 17                	jmp    8016b8 <strcconcat+0x49>
		final[s] = str1[s] ;
  8016a1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a7:	01 c2                	add    %eax,%edx
  8016a9:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8016af:	01 c8                	add    %ecx,%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8016b5:	ff 45 fc             	incl   -0x4(%ebp)
  8016b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8016be:	7c e1                	jl     8016a1 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8016c0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8016c7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8016ce:	eb 1f                	jmp    8016ef <strcconcat+0x80>
		final[s++] = str2[i] ;
  8016d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d3:	8d 50 01             	lea    0x1(%eax),%edx
  8016d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016d9:	89 c2                	mov    %eax,%edx
  8016db:	8b 45 10             	mov    0x10(%ebp),%eax
  8016de:	01 c2                	add    %eax,%edx
  8016e0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8016e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016e6:	01 c8                	add    %ecx,%eax
  8016e8:	8a 00                	mov    (%eax),%al
  8016ea:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8016ec:	ff 45 f8             	incl   -0x8(%ebp)
  8016ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016f2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8016f5:	7c d9                	jl     8016d0 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8016f7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8016fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fd:	01 d0                	add    %edx,%eax
  8016ff:	c6 00 00             	movb   $0x0,(%eax)
}
  801702:	90                   	nop
  801703:	c9                   	leave  
  801704:	c3                   	ret    

00801705 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801705:	55                   	push   %ebp
  801706:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801708:	8b 45 14             	mov    0x14(%ebp),%eax
  80170b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801711:	8b 45 14             	mov    0x14(%ebp),%eax
  801714:	8b 00                	mov    (%eax),%eax
  801716:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80171d:	8b 45 10             	mov    0x10(%ebp),%eax
  801720:	01 d0                	add    %edx,%eax
  801722:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801728:	eb 0c                	jmp    801736 <strsplit+0x31>
			*string++ = 0;
  80172a:	8b 45 08             	mov    0x8(%ebp),%eax
  80172d:	8d 50 01             	lea    0x1(%eax),%edx
  801730:	89 55 08             	mov    %edx,0x8(%ebp)
  801733:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801736:	8b 45 08             	mov    0x8(%ebp),%eax
  801739:	8a 00                	mov    (%eax),%al
  80173b:	84 c0                	test   %al,%al
  80173d:	74 18                	je     801757 <strsplit+0x52>
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	8a 00                	mov    (%eax),%al
  801744:	0f be c0             	movsbl %al,%eax
  801747:	50                   	push   %eax
  801748:	ff 75 0c             	pushl  0xc(%ebp)
  80174b:	e8 13 fb ff ff       	call   801263 <strchr>
  801750:	83 c4 08             	add    $0x8,%esp
  801753:	85 c0                	test   %eax,%eax
  801755:	75 d3                	jne    80172a <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801757:	8b 45 08             	mov    0x8(%ebp),%eax
  80175a:	8a 00                	mov    (%eax),%al
  80175c:	84 c0                	test   %al,%al
  80175e:	74 5a                	je     8017ba <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801760:	8b 45 14             	mov    0x14(%ebp),%eax
  801763:	8b 00                	mov    (%eax),%eax
  801765:	83 f8 0f             	cmp    $0xf,%eax
  801768:	75 07                	jne    801771 <strsplit+0x6c>
		{
			return 0;
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
  80176f:	eb 66                	jmp    8017d7 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801771:	8b 45 14             	mov    0x14(%ebp),%eax
  801774:	8b 00                	mov    (%eax),%eax
  801776:	8d 48 01             	lea    0x1(%eax),%ecx
  801779:	8b 55 14             	mov    0x14(%ebp),%edx
  80177c:	89 0a                	mov    %ecx,(%edx)
  80177e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801785:	8b 45 10             	mov    0x10(%ebp),%eax
  801788:	01 c2                	add    %eax,%edx
  80178a:	8b 45 08             	mov    0x8(%ebp),%eax
  80178d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80178f:	eb 03                	jmp    801794 <strsplit+0x8f>
			string++;
  801791:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801794:	8b 45 08             	mov    0x8(%ebp),%eax
  801797:	8a 00                	mov    (%eax),%al
  801799:	84 c0                	test   %al,%al
  80179b:	74 8b                	je     801728 <strsplit+0x23>
  80179d:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a0:	8a 00                	mov    (%eax),%al
  8017a2:	0f be c0             	movsbl %al,%eax
  8017a5:	50                   	push   %eax
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	e8 b5 fa ff ff       	call   801263 <strchr>
  8017ae:	83 c4 08             	add    $0x8,%esp
  8017b1:	85 c0                	test   %eax,%eax
  8017b3:	74 dc                	je     801791 <strsplit+0x8c>
			string++;
	}
  8017b5:	e9 6e ff ff ff       	jmp    801728 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8017ba:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8017bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8017be:	8b 00                	mov    (%eax),%eax
  8017c0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8017c7:	8b 45 10             	mov    0x10(%ebp),%eax
  8017ca:	01 d0                	add    %edx,%eax
  8017cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8017d2:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8017d7:	c9                   	leave  
  8017d8:	c3                   	ret    

008017d9 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8017d9:	55                   	push   %ebp
  8017da:	89 e5                	mov    %esp,%ebp
  8017dc:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8017df:	a1 04 50 80 00       	mov    0x805004,%eax
  8017e4:	85 c0                	test   %eax,%eax
  8017e6:	74 1f                	je     801807 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8017e8:	e8 1d 00 00 00       	call   80180a <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8017ed:	83 ec 0c             	sub    $0xc,%esp
  8017f0:	68 50 3f 80 00       	push   $0x803f50
  8017f5:	e8 55 f2 ff ff       	call   800a4f <cprintf>
  8017fa:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8017fd:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801804:	00 00 00 
	}
}
  801807:	90                   	nop
  801808:	c9                   	leave  
  801809:	c3                   	ret    

0080180a <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80180a:	55                   	push   %ebp
  80180b:	89 e5                	mov    %esp,%ebp
  80180d:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801810:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801817:	00 00 00 
  80181a:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801821:	00 00 00 
  801824:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  80182b:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80182e:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801835:	00 00 00 
  801838:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  80183f:	00 00 00 
  801842:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801849:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  80184c:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801853:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801856:	c1 e8 0c             	shr    $0xc,%eax
  801859:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  80185e:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801865:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801868:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80186d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801872:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801877:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  80187e:	a1 20 51 80 00       	mov    0x805120,%eax
  801883:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801887:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  80188a:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801891:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801894:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801897:	01 d0                	add    %edx,%eax
  801899:	48                   	dec    %eax
  80189a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80189d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018a0:	ba 00 00 00 00       	mov    $0x0,%edx
  8018a5:	f7 75 e4             	divl   -0x1c(%ebp)
  8018a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8018ab:	29 d0                	sub    %edx,%eax
  8018ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8018b0:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8018b7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8018ba:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8018bf:	2d 00 10 00 00       	sub    $0x1000,%eax
  8018c4:	83 ec 04             	sub    $0x4,%esp
  8018c7:	6a 07                	push   $0x7
  8018c9:	ff 75 e8             	pushl  -0x18(%ebp)
  8018cc:	50                   	push   %eax
  8018cd:	e8 3d 06 00 00       	call   801f0f <sys_allocate_chunk>
  8018d2:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8018d5:	a1 20 51 80 00       	mov    0x805120,%eax
  8018da:	83 ec 0c             	sub    $0xc,%esp
  8018dd:	50                   	push   %eax
  8018de:	e8 b2 0c 00 00       	call   802595 <initialize_MemBlocksList>
  8018e3:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8018e6:	a1 4c 51 80 00       	mov    0x80514c,%eax
  8018eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8018ee:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018f2:	0f 84 f3 00 00 00    	je     8019eb <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8018f8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018fc:	75 14                	jne    801912 <initialize_dyn_block_system+0x108>
  8018fe:	83 ec 04             	sub    $0x4,%esp
  801901:	68 75 3f 80 00       	push   $0x803f75
  801906:	6a 36                	push   $0x36
  801908:	68 93 3f 80 00       	push   $0x803f93
  80190d:	e8 89 ee ff ff       	call   80079b <_panic>
  801912:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801915:	8b 00                	mov    (%eax),%eax
  801917:	85 c0                	test   %eax,%eax
  801919:	74 10                	je     80192b <initialize_dyn_block_system+0x121>
  80191b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80191e:	8b 00                	mov    (%eax),%eax
  801920:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801923:	8b 52 04             	mov    0x4(%edx),%edx
  801926:	89 50 04             	mov    %edx,0x4(%eax)
  801929:	eb 0b                	jmp    801936 <initialize_dyn_block_system+0x12c>
  80192b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80192e:	8b 40 04             	mov    0x4(%eax),%eax
  801931:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801936:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801939:	8b 40 04             	mov    0x4(%eax),%eax
  80193c:	85 c0                	test   %eax,%eax
  80193e:	74 0f                	je     80194f <initialize_dyn_block_system+0x145>
  801940:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801943:	8b 40 04             	mov    0x4(%eax),%eax
  801946:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801949:	8b 12                	mov    (%edx),%edx
  80194b:	89 10                	mov    %edx,(%eax)
  80194d:	eb 0a                	jmp    801959 <initialize_dyn_block_system+0x14f>
  80194f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801952:	8b 00                	mov    (%eax),%eax
  801954:	a3 48 51 80 00       	mov    %eax,0x805148
  801959:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80195c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801962:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801965:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80196c:	a1 54 51 80 00       	mov    0x805154,%eax
  801971:	48                   	dec    %eax
  801972:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801977:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80197a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801981:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801984:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  80198b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80198f:	75 14                	jne    8019a5 <initialize_dyn_block_system+0x19b>
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	68 a0 3f 80 00       	push   $0x803fa0
  801999:	6a 3e                	push   $0x3e
  80199b:	68 93 3f 80 00       	push   $0x803f93
  8019a0:	e8 f6 ed ff ff       	call   80079b <_panic>
  8019a5:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8019ab:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019ae:	89 10                	mov    %edx,(%eax)
  8019b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019b3:	8b 00                	mov    (%eax),%eax
  8019b5:	85 c0                	test   %eax,%eax
  8019b7:	74 0d                	je     8019c6 <initialize_dyn_block_system+0x1bc>
  8019b9:	a1 38 51 80 00       	mov    0x805138,%eax
  8019be:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8019c1:	89 50 04             	mov    %edx,0x4(%eax)
  8019c4:	eb 08                	jmp    8019ce <initialize_dyn_block_system+0x1c4>
  8019c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019c9:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8019ce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019d1:	a3 38 51 80 00       	mov    %eax,0x805138
  8019d6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8019d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8019e0:	a1 44 51 80 00       	mov    0x805144,%eax
  8019e5:	40                   	inc    %eax
  8019e6:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  8019eb:	90                   	nop
  8019ec:	c9                   	leave  
  8019ed:	c3                   	ret    

008019ee <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
  8019f1:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8019f4:	e8 e0 fd ff ff       	call   8017d9 <InitializeUHeap>
		if (size == 0) return NULL ;
  8019f9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8019fd:	75 07                	jne    801a06 <malloc+0x18>
  8019ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801a04:	eb 7f                	jmp    801a85 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801a06:	e8 d2 08 00 00       	call   8022dd <sys_isUHeapPlacementStrategyFIRSTFIT>
  801a0b:	85 c0                	test   %eax,%eax
  801a0d:	74 71                	je     801a80 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801a0f:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801a16:	8b 55 08             	mov    0x8(%ebp),%edx
  801a19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a1c:	01 d0                	add    %edx,%eax
  801a1e:	48                   	dec    %eax
  801a1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a25:	ba 00 00 00 00       	mov    $0x0,%edx
  801a2a:	f7 75 f4             	divl   -0xc(%ebp)
  801a2d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a30:	29 d0                	sub    %edx,%eax
  801a32:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801a35:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801a3c:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801a43:	76 07                	jbe    801a4c <malloc+0x5e>
					return NULL ;
  801a45:	b8 00 00 00 00       	mov    $0x0,%eax
  801a4a:	eb 39                	jmp    801a85 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801a4c:	83 ec 0c             	sub    $0xc,%esp
  801a4f:	ff 75 08             	pushl  0x8(%ebp)
  801a52:	e8 e6 0d 00 00       	call   80283d <alloc_block_FF>
  801a57:	83 c4 10             	add    $0x10,%esp
  801a5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801a5d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801a61:	74 16                	je     801a79 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801a63:	83 ec 0c             	sub    $0xc,%esp
  801a66:	ff 75 ec             	pushl  -0x14(%ebp)
  801a69:	e8 37 0c 00 00       	call   8026a5 <insert_sorted_allocList>
  801a6e:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801a71:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801a74:	8b 40 08             	mov    0x8(%eax),%eax
  801a77:	eb 0c                	jmp    801a85 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801a79:	b8 00 00 00 00       	mov    $0x0,%eax
  801a7e:	eb 05                	jmp    801a85 <malloc+0x97>
				}
		}
	return 0;
  801a80:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a85:	c9                   	leave  
  801a86:	c3                   	ret    

00801a87 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a87:	55                   	push   %ebp
  801a88:	89 e5                	mov    %esp,%ebp
  801a8a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a90:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801a93:	83 ec 08             	sub    $0x8,%esp
  801a96:	ff 75 f4             	pushl  -0xc(%ebp)
  801a99:	68 40 50 80 00       	push   $0x805040
  801a9e:	e8 cf 0b 00 00       	call   802672 <find_block>
  801aa3:	83 c4 10             	add    $0x10,%esp
  801aa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801aa9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aac:	8b 40 0c             	mov    0xc(%eax),%eax
  801aaf:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab5:	8b 40 08             	mov    0x8(%eax),%eax
  801ab8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801abb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801abf:	0f 84 a1 00 00 00    	je     801b66 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801ac5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ac9:	75 17                	jne    801ae2 <free+0x5b>
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	68 75 3f 80 00       	push   $0x803f75
  801ad3:	68 80 00 00 00       	push   $0x80
  801ad8:	68 93 3f 80 00       	push   $0x803f93
  801add:	e8 b9 ec ff ff       	call   80079b <_panic>
  801ae2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ae5:	8b 00                	mov    (%eax),%eax
  801ae7:	85 c0                	test   %eax,%eax
  801ae9:	74 10                	je     801afb <free+0x74>
  801aeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aee:	8b 00                	mov    (%eax),%eax
  801af0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801af3:	8b 52 04             	mov    0x4(%edx),%edx
  801af6:	89 50 04             	mov    %edx,0x4(%eax)
  801af9:	eb 0b                	jmp    801b06 <free+0x7f>
  801afb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801afe:	8b 40 04             	mov    0x4(%eax),%eax
  801b01:	a3 44 50 80 00       	mov    %eax,0x805044
  801b06:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b09:	8b 40 04             	mov    0x4(%eax),%eax
  801b0c:	85 c0                	test   %eax,%eax
  801b0e:	74 0f                	je     801b1f <free+0x98>
  801b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b13:	8b 40 04             	mov    0x4(%eax),%eax
  801b16:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801b19:	8b 12                	mov    (%edx),%edx
  801b1b:	89 10                	mov    %edx,(%eax)
  801b1d:	eb 0a                	jmp    801b29 <free+0xa2>
  801b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b22:	8b 00                	mov    (%eax),%eax
  801b24:	a3 40 50 80 00       	mov    %eax,0x805040
  801b29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801b32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b3c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801b41:	48                   	dec    %eax
  801b42:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801b47:	83 ec 0c             	sub    $0xc,%esp
  801b4a:	ff 75 f0             	pushl  -0x10(%ebp)
  801b4d:	e8 29 12 00 00       	call   802d7b <insert_sorted_with_merge_freeList>
  801b52:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801b55:	83 ec 08             	sub    $0x8,%esp
  801b58:	ff 75 ec             	pushl  -0x14(%ebp)
  801b5b:	ff 75 e8             	pushl  -0x18(%ebp)
  801b5e:	e8 74 03 00 00       	call   801ed7 <sys_free_user_mem>
  801b63:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801b66:	90                   	nop
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
  801b6c:	83 ec 38             	sub    $0x38,%esp
  801b6f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b72:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b75:	e8 5f fc ff ff       	call   8017d9 <InitializeUHeap>
	if (size == 0) return NULL ;
  801b7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b7e:	75 0a                	jne    801b8a <smalloc+0x21>
  801b80:	b8 00 00 00 00       	mov    $0x0,%eax
  801b85:	e9 b2 00 00 00       	jmp    801c3c <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801b8a:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801b91:	76 0a                	jbe    801b9d <smalloc+0x34>
		return NULL;
  801b93:	b8 00 00 00 00       	mov    $0x0,%eax
  801b98:	e9 9f 00 00 00       	jmp    801c3c <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801b9d:	e8 3b 07 00 00       	call   8022dd <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ba2:	85 c0                	test   %eax,%eax
  801ba4:	0f 84 8d 00 00 00    	je     801c37 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801baa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801bb1:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801bb8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bbe:	01 d0                	add    %edx,%eax
  801bc0:	48                   	dec    %eax
  801bc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801bc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bc7:	ba 00 00 00 00       	mov    $0x0,%edx
  801bcc:	f7 75 f0             	divl   -0x10(%ebp)
  801bcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd2:	29 d0                	sub    %edx,%eax
  801bd4:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801bd7:	83 ec 0c             	sub    $0xc,%esp
  801bda:	ff 75 e8             	pushl  -0x18(%ebp)
  801bdd:	e8 5b 0c 00 00       	call   80283d <alloc_block_FF>
  801be2:	83 c4 10             	add    $0x10,%esp
  801be5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801be8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bec:	75 07                	jne    801bf5 <smalloc+0x8c>
			return NULL;
  801bee:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf3:	eb 47                	jmp    801c3c <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801bf5:	83 ec 0c             	sub    $0xc,%esp
  801bf8:	ff 75 f4             	pushl  -0xc(%ebp)
  801bfb:	e8 a5 0a 00 00       	call   8026a5 <insert_sorted_allocList>
  801c00:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801c03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c06:	8b 40 08             	mov    0x8(%eax),%eax
  801c09:	89 c2                	mov    %eax,%edx
  801c0b:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801c0f:	52                   	push   %edx
  801c10:	50                   	push   %eax
  801c11:	ff 75 0c             	pushl  0xc(%ebp)
  801c14:	ff 75 08             	pushl  0x8(%ebp)
  801c17:	e8 46 04 00 00       	call   802062 <sys_createSharedObject>
  801c1c:	83 c4 10             	add    $0x10,%esp
  801c1f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801c22:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801c26:	78 08                	js     801c30 <smalloc+0xc7>
		return (void *)b->sva;
  801c28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c2b:	8b 40 08             	mov    0x8(%eax),%eax
  801c2e:	eb 0c                	jmp    801c3c <smalloc+0xd3>
		}else{
		return NULL;
  801c30:	b8 00 00 00 00       	mov    $0x0,%eax
  801c35:	eb 05                	jmp    801c3c <smalloc+0xd3>
			}

	}return NULL;
  801c37:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
  801c41:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c44:	e8 90 fb ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801c49:	e8 8f 06 00 00       	call   8022dd <sys_isUHeapPlacementStrategyFIRSTFIT>
  801c4e:	85 c0                	test   %eax,%eax
  801c50:	0f 84 ad 00 00 00    	je     801d03 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801c56:	83 ec 08             	sub    $0x8,%esp
  801c59:	ff 75 0c             	pushl  0xc(%ebp)
  801c5c:	ff 75 08             	pushl  0x8(%ebp)
  801c5f:	e8 28 04 00 00       	call   80208c <sys_getSizeOfSharedObject>
  801c64:	83 c4 10             	add    $0x10,%esp
  801c67:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801c6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801c6e:	79 0a                	jns    801c7a <sget+0x3c>
    {
    	return NULL;
  801c70:	b8 00 00 00 00       	mov    $0x0,%eax
  801c75:	e9 8e 00 00 00       	jmp    801d08 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801c7a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801c81:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c88:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c8e:	01 d0                	add    %edx,%eax
  801c90:	48                   	dec    %eax
  801c91:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c94:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c97:	ba 00 00 00 00       	mov    $0x0,%edx
  801c9c:	f7 75 ec             	divl   -0x14(%ebp)
  801c9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ca2:	29 d0                	sub    %edx,%eax
  801ca4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801ca7:	83 ec 0c             	sub    $0xc,%esp
  801caa:	ff 75 e4             	pushl  -0x1c(%ebp)
  801cad:	e8 8b 0b 00 00       	call   80283d <alloc_block_FF>
  801cb2:	83 c4 10             	add    $0x10,%esp
  801cb5:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801cb8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801cbc:	75 07                	jne    801cc5 <sget+0x87>
				return NULL;
  801cbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801cc3:	eb 43                	jmp    801d08 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801cc5:	83 ec 0c             	sub    $0xc,%esp
  801cc8:	ff 75 f0             	pushl  -0x10(%ebp)
  801ccb:	e8 d5 09 00 00       	call   8026a5 <insert_sorted_allocList>
  801cd0:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801cd3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cd6:	8b 40 08             	mov    0x8(%eax),%eax
  801cd9:	83 ec 04             	sub    $0x4,%esp
  801cdc:	50                   	push   %eax
  801cdd:	ff 75 0c             	pushl  0xc(%ebp)
  801ce0:	ff 75 08             	pushl  0x8(%ebp)
  801ce3:	e8 c1 03 00 00       	call   8020a9 <sys_getSharedObject>
  801ce8:	83 c4 10             	add    $0x10,%esp
  801ceb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801cee:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801cf2:	78 08                	js     801cfc <sget+0xbe>
			return (void *)b->sva;
  801cf4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cf7:	8b 40 08             	mov    0x8(%eax),%eax
  801cfa:	eb 0c                	jmp    801d08 <sget+0xca>
			}else{
			return NULL;
  801cfc:	b8 00 00 00 00       	mov    $0x0,%eax
  801d01:	eb 05                	jmp    801d08 <sget+0xca>
			}
    }}return NULL;
  801d03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
  801d0d:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d10:	e8 c4 fa ff ff       	call   8017d9 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801d15:	83 ec 04             	sub    $0x4,%esp
  801d18:	68 c4 3f 80 00       	push   $0x803fc4
  801d1d:	68 03 01 00 00       	push   $0x103
  801d22:	68 93 3f 80 00       	push   $0x803f93
  801d27:	e8 6f ea ff ff       	call   80079b <_panic>

00801d2c <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801d2c:	55                   	push   %ebp
  801d2d:	89 e5                	mov    %esp,%ebp
  801d2f:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801d32:	83 ec 04             	sub    $0x4,%esp
  801d35:	68 ec 3f 80 00       	push   $0x803fec
  801d3a:	68 17 01 00 00       	push   $0x117
  801d3f:	68 93 3f 80 00       	push   $0x803f93
  801d44:	e8 52 ea ff ff       	call   80079b <_panic>

00801d49 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801d49:	55                   	push   %ebp
  801d4a:	89 e5                	mov    %esp,%ebp
  801d4c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d4f:	83 ec 04             	sub    $0x4,%esp
  801d52:	68 10 40 80 00       	push   $0x804010
  801d57:	68 22 01 00 00       	push   $0x122
  801d5c:	68 93 3f 80 00       	push   $0x803f93
  801d61:	e8 35 ea ff ff       	call   80079b <_panic>

00801d66 <shrink>:

}
void shrink(uint32 newSize)
{
  801d66:	55                   	push   %ebp
  801d67:	89 e5                	mov    %esp,%ebp
  801d69:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d6c:	83 ec 04             	sub    $0x4,%esp
  801d6f:	68 10 40 80 00       	push   $0x804010
  801d74:	68 27 01 00 00       	push   $0x127
  801d79:	68 93 3f 80 00       	push   $0x803f93
  801d7e:	e8 18 ea ff ff       	call   80079b <_panic>

00801d83 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d83:	55                   	push   %ebp
  801d84:	89 e5                	mov    %esp,%ebp
  801d86:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d89:	83 ec 04             	sub    $0x4,%esp
  801d8c:	68 10 40 80 00       	push   $0x804010
  801d91:	68 2c 01 00 00       	push   $0x12c
  801d96:	68 93 3f 80 00       	push   $0x803f93
  801d9b:	e8 fb e9 ff ff       	call   80079b <_panic>

00801da0 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
  801da3:	57                   	push   %edi
  801da4:	56                   	push   %esi
  801da5:	53                   	push   %ebx
  801da6:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801da9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801daf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801db2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801db5:	8b 7d 18             	mov    0x18(%ebp),%edi
  801db8:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801dbb:	cd 30                	int    $0x30
  801dbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801dc0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801dc3:	83 c4 10             	add    $0x10,%esp
  801dc6:	5b                   	pop    %ebx
  801dc7:	5e                   	pop    %esi
  801dc8:	5f                   	pop    %edi
  801dc9:	5d                   	pop    %ebp
  801dca:	c3                   	ret    

00801dcb <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801dcb:	55                   	push   %ebp
  801dcc:	89 e5                	mov    %esp,%ebp
  801dce:	83 ec 04             	sub    $0x4,%esp
  801dd1:	8b 45 10             	mov    0x10(%ebp),%eax
  801dd4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801dd7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	52                   	push   %edx
  801de3:	ff 75 0c             	pushl  0xc(%ebp)
  801de6:	50                   	push   %eax
  801de7:	6a 00                	push   $0x0
  801de9:	e8 b2 ff ff ff       	call   801da0 <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
}
  801df1:	90                   	nop
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_cgetc>:

int
sys_cgetc(void)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 01                	push   $0x1
  801e03:	e8 98 ff ff ff       	call   801da0 <syscall>
  801e08:	83 c4 18             	add    $0x18,%esp
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801e10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e13:	8b 45 08             	mov    0x8(%ebp),%eax
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	52                   	push   %edx
  801e1d:	50                   	push   %eax
  801e1e:	6a 05                	push   $0x5
  801e20:	e8 7b ff ff ff       	call   801da0 <syscall>
  801e25:	83 c4 18             	add    $0x18,%esp
}
  801e28:	c9                   	leave  
  801e29:	c3                   	ret    

00801e2a <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801e2a:	55                   	push   %ebp
  801e2b:	89 e5                	mov    %esp,%ebp
  801e2d:	56                   	push   %esi
  801e2e:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801e2f:	8b 75 18             	mov    0x18(%ebp),%esi
  801e32:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e35:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e38:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3e:	56                   	push   %esi
  801e3f:	53                   	push   %ebx
  801e40:	51                   	push   %ecx
  801e41:	52                   	push   %edx
  801e42:	50                   	push   %eax
  801e43:	6a 06                	push   $0x6
  801e45:	e8 56 ff ff ff       	call   801da0 <syscall>
  801e4a:	83 c4 18             	add    $0x18,%esp
}
  801e4d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801e50:	5b                   	pop    %ebx
  801e51:	5e                   	pop    %esi
  801e52:	5d                   	pop    %ebp
  801e53:	c3                   	ret    

00801e54 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801e57:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	52                   	push   %edx
  801e64:	50                   	push   %eax
  801e65:	6a 07                	push   $0x7
  801e67:	e8 34 ff ff ff       	call   801da0 <syscall>
  801e6c:	83 c4 18             	add    $0x18,%esp
}
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	ff 75 0c             	pushl  0xc(%ebp)
  801e7d:	ff 75 08             	pushl  0x8(%ebp)
  801e80:	6a 08                	push   $0x8
  801e82:	e8 19 ff ff ff       	call   801da0 <syscall>
  801e87:	83 c4 18             	add    $0x18,%esp
}
  801e8a:	c9                   	leave  
  801e8b:	c3                   	ret    

00801e8c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e8c:	55                   	push   %ebp
  801e8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 09                	push   $0x9
  801e9b:	e8 00 ff ff ff       	call   801da0 <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 0a                	push   $0xa
  801eb4:	e8 e7 fe ff ff       	call   801da0 <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 0b                	push   $0xb
  801ecd:	e8 ce fe ff ff       	call   801da0 <syscall>
  801ed2:	83 c4 18             	add    $0x18,%esp
}
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	ff 75 0c             	pushl  0xc(%ebp)
  801ee3:	ff 75 08             	pushl  0x8(%ebp)
  801ee6:	6a 0f                	push   $0xf
  801ee8:	e8 b3 fe ff ff       	call   801da0 <syscall>
  801eed:	83 c4 18             	add    $0x18,%esp
	return;
  801ef0:	90                   	nop
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 00                	push   $0x0
  801efc:	ff 75 0c             	pushl  0xc(%ebp)
  801eff:	ff 75 08             	pushl  0x8(%ebp)
  801f02:	6a 10                	push   $0x10
  801f04:	e8 97 fe ff ff       	call   801da0 <syscall>
  801f09:	83 c4 18             	add    $0x18,%esp
	return ;
  801f0c:	90                   	nop
}
  801f0d:	c9                   	leave  
  801f0e:	c3                   	ret    

00801f0f <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801f0f:	55                   	push   %ebp
  801f10:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	ff 75 10             	pushl  0x10(%ebp)
  801f19:	ff 75 0c             	pushl  0xc(%ebp)
  801f1c:	ff 75 08             	pushl  0x8(%ebp)
  801f1f:	6a 11                	push   $0x11
  801f21:	e8 7a fe ff ff       	call   801da0 <syscall>
  801f26:	83 c4 18             	add    $0x18,%esp
	return ;
  801f29:	90                   	nop
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	6a 00                	push   $0x0
  801f39:	6a 0c                	push   $0xc
  801f3b:	e8 60 fe ff ff       	call   801da0 <syscall>
  801f40:	83 c4 18             	add    $0x18,%esp
}
  801f43:	c9                   	leave  
  801f44:	c3                   	ret    

00801f45 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801f45:	55                   	push   %ebp
  801f46:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 00                	push   $0x0
  801f50:	ff 75 08             	pushl  0x8(%ebp)
  801f53:	6a 0d                	push   $0xd
  801f55:	e8 46 fe ff ff       	call   801da0 <syscall>
  801f5a:	83 c4 18             	add    $0x18,%esp
}
  801f5d:	c9                   	leave  
  801f5e:	c3                   	ret    

00801f5f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801f5f:	55                   	push   %ebp
  801f60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801f62:	6a 00                	push   $0x0
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 0e                	push   $0xe
  801f6e:	e8 2d fe ff ff       	call   801da0 <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
}
  801f76:	90                   	nop
  801f77:	c9                   	leave  
  801f78:	c3                   	ret    

00801f79 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801f79:	55                   	push   %ebp
  801f7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 00                	push   $0x0
  801f84:	6a 00                	push   $0x0
  801f86:	6a 13                	push   $0x13
  801f88:	e8 13 fe ff ff       	call   801da0 <syscall>
  801f8d:	83 c4 18             	add    $0x18,%esp
}
  801f90:	90                   	nop
  801f91:	c9                   	leave  
  801f92:	c3                   	ret    

00801f93 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f93:	55                   	push   %ebp
  801f94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f96:	6a 00                	push   $0x0
  801f98:	6a 00                	push   $0x0
  801f9a:	6a 00                	push   $0x0
  801f9c:	6a 00                	push   $0x0
  801f9e:	6a 00                	push   $0x0
  801fa0:	6a 14                	push   $0x14
  801fa2:	e8 f9 fd ff ff       	call   801da0 <syscall>
  801fa7:	83 c4 18             	add    $0x18,%esp
}
  801faa:	90                   	nop
  801fab:	c9                   	leave  
  801fac:	c3                   	ret    

00801fad <sys_cputc>:


void
sys_cputc(const char c)
{
  801fad:	55                   	push   %ebp
  801fae:	89 e5                	mov    %esp,%ebp
  801fb0:	83 ec 04             	sub    $0x4,%esp
  801fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801fb9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fbd:	6a 00                	push   $0x0
  801fbf:	6a 00                	push   $0x0
  801fc1:	6a 00                	push   $0x0
  801fc3:	6a 00                	push   $0x0
  801fc5:	50                   	push   %eax
  801fc6:	6a 15                	push   $0x15
  801fc8:	e8 d3 fd ff ff       	call   801da0 <syscall>
  801fcd:	83 c4 18             	add    $0x18,%esp
}
  801fd0:	90                   	nop
  801fd1:	c9                   	leave  
  801fd2:	c3                   	ret    

00801fd3 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801fd3:	55                   	push   %ebp
  801fd4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801fd6:	6a 00                	push   $0x0
  801fd8:	6a 00                	push   $0x0
  801fda:	6a 00                	push   $0x0
  801fdc:	6a 00                	push   $0x0
  801fde:	6a 00                	push   $0x0
  801fe0:	6a 16                	push   $0x16
  801fe2:	e8 b9 fd ff ff       	call   801da0 <syscall>
  801fe7:	83 c4 18             	add    $0x18,%esp
}
  801fea:	90                   	nop
  801feb:	c9                   	leave  
  801fec:	c3                   	ret    

00801fed <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801fed:	55                   	push   %ebp
  801fee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ff3:	6a 00                	push   $0x0
  801ff5:	6a 00                	push   $0x0
  801ff7:	6a 00                	push   $0x0
  801ff9:	ff 75 0c             	pushl  0xc(%ebp)
  801ffc:	50                   	push   %eax
  801ffd:	6a 17                	push   $0x17
  801fff:	e8 9c fd ff ff       	call   801da0 <syscall>
  802004:	83 c4 18             	add    $0x18,%esp
}
  802007:	c9                   	leave  
  802008:	c3                   	ret    

00802009 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802009:	55                   	push   %ebp
  80200a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80200c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80200f:	8b 45 08             	mov    0x8(%ebp),%eax
  802012:	6a 00                	push   $0x0
  802014:	6a 00                	push   $0x0
  802016:	6a 00                	push   $0x0
  802018:	52                   	push   %edx
  802019:	50                   	push   %eax
  80201a:	6a 1a                	push   $0x1a
  80201c:	e8 7f fd ff ff       	call   801da0 <syscall>
  802021:	83 c4 18             	add    $0x18,%esp
}
  802024:	c9                   	leave  
  802025:	c3                   	ret    

00802026 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802026:	55                   	push   %ebp
  802027:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802029:	8b 55 0c             	mov    0xc(%ebp),%edx
  80202c:	8b 45 08             	mov    0x8(%ebp),%eax
  80202f:	6a 00                	push   $0x0
  802031:	6a 00                	push   $0x0
  802033:	6a 00                	push   $0x0
  802035:	52                   	push   %edx
  802036:	50                   	push   %eax
  802037:	6a 18                	push   $0x18
  802039:	e8 62 fd ff ff       	call   801da0 <syscall>
  80203e:	83 c4 18             	add    $0x18,%esp
}
  802041:	90                   	nop
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802047:	8b 55 0c             	mov    0xc(%ebp),%edx
  80204a:	8b 45 08             	mov    0x8(%ebp),%eax
  80204d:	6a 00                	push   $0x0
  80204f:	6a 00                	push   $0x0
  802051:	6a 00                	push   $0x0
  802053:	52                   	push   %edx
  802054:	50                   	push   %eax
  802055:	6a 19                	push   $0x19
  802057:	e8 44 fd ff ff       	call   801da0 <syscall>
  80205c:	83 c4 18             	add    $0x18,%esp
}
  80205f:	90                   	nop
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
  802065:	83 ec 04             	sub    $0x4,%esp
  802068:	8b 45 10             	mov    0x10(%ebp),%eax
  80206b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80206e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802071:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802075:	8b 45 08             	mov    0x8(%ebp),%eax
  802078:	6a 00                	push   $0x0
  80207a:	51                   	push   %ecx
  80207b:	52                   	push   %edx
  80207c:	ff 75 0c             	pushl  0xc(%ebp)
  80207f:	50                   	push   %eax
  802080:	6a 1b                	push   $0x1b
  802082:	e8 19 fd ff ff       	call   801da0 <syscall>
  802087:	83 c4 18             	add    $0x18,%esp
}
  80208a:	c9                   	leave  
  80208b:	c3                   	ret    

0080208c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80208c:	55                   	push   %ebp
  80208d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80208f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802092:	8b 45 08             	mov    0x8(%ebp),%eax
  802095:	6a 00                	push   $0x0
  802097:	6a 00                	push   $0x0
  802099:	6a 00                	push   $0x0
  80209b:	52                   	push   %edx
  80209c:	50                   	push   %eax
  80209d:	6a 1c                	push   $0x1c
  80209f:	e8 fc fc ff ff       	call   801da0 <syscall>
  8020a4:	83 c4 18             	add    $0x18,%esp
}
  8020a7:	c9                   	leave  
  8020a8:	c3                   	ret    

008020a9 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8020a9:	55                   	push   %ebp
  8020aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8020ac:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	51                   	push   %ecx
  8020ba:	52                   	push   %edx
  8020bb:	50                   	push   %eax
  8020bc:	6a 1d                	push   $0x1d
  8020be:	e8 dd fc ff ff       	call   801da0 <syscall>
  8020c3:	83 c4 18             	add    $0x18,%esp
}
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8020cb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d1:	6a 00                	push   $0x0
  8020d3:	6a 00                	push   $0x0
  8020d5:	6a 00                	push   $0x0
  8020d7:	52                   	push   %edx
  8020d8:	50                   	push   %eax
  8020d9:	6a 1e                	push   $0x1e
  8020db:	e8 c0 fc ff ff       	call   801da0 <syscall>
  8020e0:	83 c4 18             	add    $0x18,%esp
}
  8020e3:	c9                   	leave  
  8020e4:	c3                   	ret    

008020e5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8020e5:	55                   	push   %ebp
  8020e6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8020e8:	6a 00                	push   $0x0
  8020ea:	6a 00                	push   $0x0
  8020ec:	6a 00                	push   $0x0
  8020ee:	6a 00                	push   $0x0
  8020f0:	6a 00                	push   $0x0
  8020f2:	6a 1f                	push   $0x1f
  8020f4:	e8 a7 fc ff ff       	call   801da0 <syscall>
  8020f9:	83 c4 18             	add    $0x18,%esp
}
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802101:	8b 45 08             	mov    0x8(%ebp),%eax
  802104:	6a 00                	push   $0x0
  802106:	ff 75 14             	pushl  0x14(%ebp)
  802109:	ff 75 10             	pushl  0x10(%ebp)
  80210c:	ff 75 0c             	pushl  0xc(%ebp)
  80210f:	50                   	push   %eax
  802110:	6a 20                	push   $0x20
  802112:	e8 89 fc ff ff       	call   801da0 <syscall>
  802117:	83 c4 18             	add    $0x18,%esp
}
  80211a:	c9                   	leave  
  80211b:	c3                   	ret    

0080211c <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80211c:	55                   	push   %ebp
  80211d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80211f:	8b 45 08             	mov    0x8(%ebp),%eax
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	50                   	push   %eax
  80212b:	6a 21                	push   $0x21
  80212d:	e8 6e fc ff ff       	call   801da0 <syscall>
  802132:	83 c4 18             	add    $0x18,%esp
}
  802135:	90                   	nop
  802136:	c9                   	leave  
  802137:	c3                   	ret    

00802138 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802138:	55                   	push   %ebp
  802139:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80213b:	8b 45 08             	mov    0x8(%ebp),%eax
  80213e:	6a 00                	push   $0x0
  802140:	6a 00                	push   $0x0
  802142:	6a 00                	push   $0x0
  802144:	6a 00                	push   $0x0
  802146:	50                   	push   %eax
  802147:	6a 22                	push   $0x22
  802149:	e8 52 fc ff ff       	call   801da0 <syscall>
  80214e:	83 c4 18             	add    $0x18,%esp
}
  802151:	c9                   	leave  
  802152:	c3                   	ret    

00802153 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802153:	55                   	push   %ebp
  802154:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 00                	push   $0x0
  802160:	6a 02                	push   $0x2
  802162:	e8 39 fc ff ff       	call   801da0 <syscall>
  802167:	83 c4 18             	add    $0x18,%esp
}
  80216a:	c9                   	leave  
  80216b:	c3                   	ret    

0080216c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  80216c:	55                   	push   %ebp
  80216d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80216f:	6a 00                	push   $0x0
  802171:	6a 00                	push   $0x0
  802173:	6a 00                	push   $0x0
  802175:	6a 00                	push   $0x0
  802177:	6a 00                	push   $0x0
  802179:	6a 03                	push   $0x3
  80217b:	e8 20 fc ff ff       	call   801da0 <syscall>
  802180:	83 c4 18             	add    $0x18,%esp
}
  802183:	c9                   	leave  
  802184:	c3                   	ret    

00802185 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802185:	55                   	push   %ebp
  802186:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802188:	6a 00                	push   $0x0
  80218a:	6a 00                	push   $0x0
  80218c:	6a 00                	push   $0x0
  80218e:	6a 00                	push   $0x0
  802190:	6a 00                	push   $0x0
  802192:	6a 04                	push   $0x4
  802194:	e8 07 fc ff ff       	call   801da0 <syscall>
  802199:	83 c4 18             	add    $0x18,%esp
}
  80219c:	c9                   	leave  
  80219d:	c3                   	ret    

0080219e <sys_exit_env>:


void sys_exit_env(void)
{
  80219e:	55                   	push   %ebp
  80219f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8021a1:	6a 00                	push   $0x0
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	6a 00                	push   $0x0
  8021ab:	6a 23                	push   $0x23
  8021ad:	e8 ee fb ff ff       	call   801da0 <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
}
  8021b5:	90                   	nop
  8021b6:	c9                   	leave  
  8021b7:	c3                   	ret    

008021b8 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8021b8:	55                   	push   %ebp
  8021b9:	89 e5                	mov    %esp,%ebp
  8021bb:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8021be:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021c1:	8d 50 04             	lea    0x4(%eax),%edx
  8021c4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8021c7:	6a 00                	push   $0x0
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	52                   	push   %edx
  8021ce:	50                   	push   %eax
  8021cf:	6a 24                	push   $0x24
  8021d1:	e8 ca fb ff ff       	call   801da0 <syscall>
  8021d6:	83 c4 18             	add    $0x18,%esp
	return result;
  8021d9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8021dc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8021df:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8021e2:	89 01                	mov    %eax,(%ecx)
  8021e4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8021e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ea:	c9                   	leave  
  8021eb:	c2 04 00             	ret    $0x4

008021ee <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8021ee:	55                   	push   %ebp
  8021ef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8021f1:	6a 00                	push   $0x0
  8021f3:	6a 00                	push   $0x0
  8021f5:	ff 75 10             	pushl  0x10(%ebp)
  8021f8:	ff 75 0c             	pushl  0xc(%ebp)
  8021fb:	ff 75 08             	pushl  0x8(%ebp)
  8021fe:	6a 12                	push   $0x12
  802200:	e8 9b fb ff ff       	call   801da0 <syscall>
  802205:	83 c4 18             	add    $0x18,%esp
	return ;
  802208:	90                   	nop
}
  802209:	c9                   	leave  
  80220a:	c3                   	ret    

0080220b <sys_rcr2>:
uint32 sys_rcr2()
{
  80220b:	55                   	push   %ebp
  80220c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80220e:	6a 00                	push   $0x0
  802210:	6a 00                	push   $0x0
  802212:	6a 00                	push   $0x0
  802214:	6a 00                	push   $0x0
  802216:	6a 00                	push   $0x0
  802218:	6a 25                	push   $0x25
  80221a:	e8 81 fb ff ff       	call   801da0 <syscall>
  80221f:	83 c4 18             	add    $0x18,%esp
}
  802222:	c9                   	leave  
  802223:	c3                   	ret    

00802224 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802224:	55                   	push   %ebp
  802225:	89 e5                	mov    %esp,%ebp
  802227:	83 ec 04             	sub    $0x4,%esp
  80222a:	8b 45 08             	mov    0x8(%ebp),%eax
  80222d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802230:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 00                	push   $0x0
  80223c:	50                   	push   %eax
  80223d:	6a 26                	push   $0x26
  80223f:	e8 5c fb ff ff       	call   801da0 <syscall>
  802244:	83 c4 18             	add    $0x18,%esp
	return ;
  802247:	90                   	nop
}
  802248:	c9                   	leave  
  802249:	c3                   	ret    

0080224a <rsttst>:
void rsttst()
{
  80224a:	55                   	push   %ebp
  80224b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80224d:	6a 00                	push   $0x0
  80224f:	6a 00                	push   $0x0
  802251:	6a 00                	push   $0x0
  802253:	6a 00                	push   $0x0
  802255:	6a 00                	push   $0x0
  802257:	6a 28                	push   $0x28
  802259:	e8 42 fb ff ff       	call   801da0 <syscall>
  80225e:	83 c4 18             	add    $0x18,%esp
	return ;
  802261:	90                   	nop
}
  802262:	c9                   	leave  
  802263:	c3                   	ret    

00802264 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802264:	55                   	push   %ebp
  802265:	89 e5                	mov    %esp,%ebp
  802267:	83 ec 04             	sub    $0x4,%esp
  80226a:	8b 45 14             	mov    0x14(%ebp),%eax
  80226d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802270:	8b 55 18             	mov    0x18(%ebp),%edx
  802273:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802277:	52                   	push   %edx
  802278:	50                   	push   %eax
  802279:	ff 75 10             	pushl  0x10(%ebp)
  80227c:	ff 75 0c             	pushl  0xc(%ebp)
  80227f:	ff 75 08             	pushl  0x8(%ebp)
  802282:	6a 27                	push   $0x27
  802284:	e8 17 fb ff ff       	call   801da0 <syscall>
  802289:	83 c4 18             	add    $0x18,%esp
	return ;
  80228c:	90                   	nop
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <chktst>:
void chktst(uint32 n)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802292:	6a 00                	push   $0x0
  802294:	6a 00                	push   $0x0
  802296:	6a 00                	push   $0x0
  802298:	6a 00                	push   $0x0
  80229a:	ff 75 08             	pushl  0x8(%ebp)
  80229d:	6a 29                	push   $0x29
  80229f:	e8 fc fa ff ff       	call   801da0 <syscall>
  8022a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8022a7:	90                   	nop
}
  8022a8:	c9                   	leave  
  8022a9:	c3                   	ret    

008022aa <inctst>:

void inctst()
{
  8022aa:	55                   	push   %ebp
  8022ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8022ad:	6a 00                	push   $0x0
  8022af:	6a 00                	push   $0x0
  8022b1:	6a 00                	push   $0x0
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 2a                	push   $0x2a
  8022b9:	e8 e2 fa ff ff       	call   801da0 <syscall>
  8022be:	83 c4 18             	add    $0x18,%esp
	return ;
  8022c1:	90                   	nop
}
  8022c2:	c9                   	leave  
  8022c3:	c3                   	ret    

008022c4 <gettst>:
uint32 gettst()
{
  8022c4:	55                   	push   %ebp
  8022c5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	6a 00                	push   $0x0
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 2b                	push   $0x2b
  8022d3:	e8 c8 fa ff ff       	call   801da0 <syscall>
  8022d8:	83 c4 18             	add    $0x18,%esp
}
  8022db:	c9                   	leave  
  8022dc:	c3                   	ret    

008022dd <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8022dd:	55                   	push   %ebp
  8022de:	89 e5                	mov    %esp,%ebp
  8022e0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022e3:	6a 00                	push   $0x0
  8022e5:	6a 00                	push   $0x0
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 2c                	push   $0x2c
  8022ef:	e8 ac fa ff ff       	call   801da0 <syscall>
  8022f4:	83 c4 18             	add    $0x18,%esp
  8022f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  8022fa:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  8022fe:	75 07                	jne    802307 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802300:	b8 01 00 00 00       	mov    $0x1,%eax
  802305:	eb 05                	jmp    80230c <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802307:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80230c:	c9                   	leave  
  80230d:	c3                   	ret    

0080230e <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80230e:	55                   	push   %ebp
  80230f:	89 e5                	mov    %esp,%ebp
  802311:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802314:	6a 00                	push   $0x0
  802316:	6a 00                	push   $0x0
  802318:	6a 00                	push   $0x0
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 2c                	push   $0x2c
  802320:	e8 7b fa ff ff       	call   801da0 <syscall>
  802325:	83 c4 18             	add    $0x18,%esp
  802328:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  80232b:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80232f:	75 07                	jne    802338 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802331:	b8 01 00 00 00       	mov    $0x1,%eax
  802336:	eb 05                	jmp    80233d <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802338:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802345:	6a 00                	push   $0x0
  802347:	6a 00                	push   $0x0
  802349:	6a 00                	push   $0x0
  80234b:	6a 00                	push   $0x0
  80234d:	6a 00                	push   $0x0
  80234f:	6a 2c                	push   $0x2c
  802351:	e8 4a fa ff ff       	call   801da0 <syscall>
  802356:	83 c4 18             	add    $0x18,%esp
  802359:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  80235c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802360:	75 07                	jne    802369 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802362:	b8 01 00 00 00       	mov    $0x1,%eax
  802367:	eb 05                	jmp    80236e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802369:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802376:	6a 00                	push   $0x0
  802378:	6a 00                	push   $0x0
  80237a:	6a 00                	push   $0x0
  80237c:	6a 00                	push   $0x0
  80237e:	6a 00                	push   $0x0
  802380:	6a 2c                	push   $0x2c
  802382:	e8 19 fa ff ff       	call   801da0 <syscall>
  802387:	83 c4 18             	add    $0x18,%esp
  80238a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80238d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802391:	75 07                	jne    80239a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802393:	b8 01 00 00 00       	mov    $0x1,%eax
  802398:	eb 05                	jmp    80239f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80239a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80239f:	c9                   	leave  
  8023a0:	c3                   	ret    

008023a1 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8023a1:	55                   	push   %ebp
  8023a2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8023a4:	6a 00                	push   $0x0
  8023a6:	6a 00                	push   $0x0
  8023a8:	6a 00                	push   $0x0
  8023aa:	6a 00                	push   $0x0
  8023ac:	ff 75 08             	pushl  0x8(%ebp)
  8023af:	6a 2d                	push   $0x2d
  8023b1:	e8 ea f9 ff ff       	call   801da0 <syscall>
  8023b6:	83 c4 18             	add    $0x18,%esp
	return ;
  8023b9:	90                   	nop
}
  8023ba:	c9                   	leave  
  8023bb:	c3                   	ret    

008023bc <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8023bc:	55                   	push   %ebp
  8023bd:	89 e5                	mov    %esp,%ebp
  8023bf:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8023c0:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8023c3:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cc:	6a 00                	push   $0x0
  8023ce:	53                   	push   %ebx
  8023cf:	51                   	push   %ecx
  8023d0:	52                   	push   %edx
  8023d1:	50                   	push   %eax
  8023d2:	6a 2e                	push   $0x2e
  8023d4:	e8 c7 f9 ff ff       	call   801da0 <syscall>
  8023d9:	83 c4 18             	add    $0x18,%esp
}
  8023dc:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8023df:	c9                   	leave  
  8023e0:	c3                   	ret    

008023e1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8023e1:	55                   	push   %ebp
  8023e2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8023e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	6a 00                	push   $0x0
  8023ec:	6a 00                	push   $0x0
  8023ee:	6a 00                	push   $0x0
  8023f0:	52                   	push   %edx
  8023f1:	50                   	push   %eax
  8023f2:	6a 2f                	push   $0x2f
  8023f4:	e8 a7 f9 ff ff       	call   801da0 <syscall>
  8023f9:	83 c4 18             	add    $0x18,%esp
}
  8023fc:	c9                   	leave  
  8023fd:	c3                   	ret    

008023fe <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  8023fe:	55                   	push   %ebp
  8023ff:	89 e5                	mov    %esp,%ebp
  802401:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802404:	83 ec 0c             	sub    $0xc,%esp
  802407:	68 20 40 80 00       	push   $0x804020
  80240c:	e8 3e e6 ff ff       	call   800a4f <cprintf>
  802411:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802414:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80241b:	83 ec 0c             	sub    $0xc,%esp
  80241e:	68 4c 40 80 00       	push   $0x80404c
  802423:	e8 27 e6 ff ff       	call   800a4f <cprintf>
  802428:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80242b:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80242f:	a1 38 51 80 00       	mov    0x805138,%eax
  802434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802437:	eb 56                	jmp    80248f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802439:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80243d:	74 1c                	je     80245b <print_mem_block_lists+0x5d>
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 50 08             	mov    0x8(%eax),%edx
  802445:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802448:	8b 48 08             	mov    0x8(%eax),%ecx
  80244b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244e:	8b 40 0c             	mov    0xc(%eax),%eax
  802451:	01 c8                	add    %ecx,%eax
  802453:	39 c2                	cmp    %eax,%edx
  802455:	73 04                	jae    80245b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802457:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80245b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245e:	8b 50 08             	mov    0x8(%eax),%edx
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	8b 40 0c             	mov    0xc(%eax),%eax
  802467:	01 c2                	add    %eax,%edx
  802469:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246c:	8b 40 08             	mov    0x8(%eax),%eax
  80246f:	83 ec 04             	sub    $0x4,%esp
  802472:	52                   	push   %edx
  802473:	50                   	push   %eax
  802474:	68 61 40 80 00       	push   $0x804061
  802479:	e8 d1 e5 ff ff       	call   800a4f <cprintf>
  80247e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802481:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802484:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802487:	a1 40 51 80 00       	mov    0x805140,%eax
  80248c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802493:	74 07                	je     80249c <print_mem_block_lists+0x9e>
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 00                	mov    (%eax),%eax
  80249a:	eb 05                	jmp    8024a1 <print_mem_block_lists+0xa3>
  80249c:	b8 00 00 00 00       	mov    $0x0,%eax
  8024a1:	a3 40 51 80 00       	mov    %eax,0x805140
  8024a6:	a1 40 51 80 00       	mov    0x805140,%eax
  8024ab:	85 c0                	test   %eax,%eax
  8024ad:	75 8a                	jne    802439 <print_mem_block_lists+0x3b>
  8024af:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b3:	75 84                	jne    802439 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8024b5:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024b9:	75 10                	jne    8024cb <print_mem_block_lists+0xcd>
  8024bb:	83 ec 0c             	sub    $0xc,%esp
  8024be:	68 70 40 80 00       	push   $0x804070
  8024c3:	e8 87 e5 ff ff       	call   800a4f <cprintf>
  8024c8:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8024cb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8024d2:	83 ec 0c             	sub    $0xc,%esp
  8024d5:	68 94 40 80 00       	push   $0x804094
  8024da:	e8 70 e5 ff ff       	call   800a4f <cprintf>
  8024df:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8024e2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024e6:	a1 40 50 80 00       	mov    0x805040,%eax
  8024eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024ee:	eb 56                	jmp    802546 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8024f0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8024f4:	74 1c                	je     802512 <print_mem_block_lists+0x114>
  8024f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f9:	8b 50 08             	mov    0x8(%eax),%edx
  8024fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8024ff:	8b 48 08             	mov    0x8(%eax),%ecx
  802502:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802505:	8b 40 0c             	mov    0xc(%eax),%eax
  802508:	01 c8                	add    %ecx,%eax
  80250a:	39 c2                	cmp    %eax,%edx
  80250c:	73 04                	jae    802512 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80250e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 50 08             	mov    0x8(%eax),%edx
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 40 0c             	mov    0xc(%eax),%eax
  80251e:	01 c2                	add    %eax,%edx
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 40 08             	mov    0x8(%eax),%eax
  802526:	83 ec 04             	sub    $0x4,%esp
  802529:	52                   	push   %edx
  80252a:	50                   	push   %eax
  80252b:	68 61 40 80 00       	push   $0x804061
  802530:	e8 1a e5 ff ff       	call   800a4f <cprintf>
  802535:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802538:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80253e:	a1 48 50 80 00       	mov    0x805048,%eax
  802543:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802546:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254a:	74 07                	je     802553 <print_mem_block_lists+0x155>
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 00                	mov    (%eax),%eax
  802551:	eb 05                	jmp    802558 <print_mem_block_lists+0x15a>
  802553:	b8 00 00 00 00       	mov    $0x0,%eax
  802558:	a3 48 50 80 00       	mov    %eax,0x805048
  80255d:	a1 48 50 80 00       	mov    0x805048,%eax
  802562:	85 c0                	test   %eax,%eax
  802564:	75 8a                	jne    8024f0 <print_mem_block_lists+0xf2>
  802566:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256a:	75 84                	jne    8024f0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80256c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802570:	75 10                	jne    802582 <print_mem_block_lists+0x184>
  802572:	83 ec 0c             	sub    $0xc,%esp
  802575:	68 ac 40 80 00       	push   $0x8040ac
  80257a:	e8 d0 e4 ff ff       	call   800a4f <cprintf>
  80257f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802582:	83 ec 0c             	sub    $0xc,%esp
  802585:	68 20 40 80 00       	push   $0x804020
  80258a:	e8 c0 e4 ff ff       	call   800a4f <cprintf>
  80258f:	83 c4 10             	add    $0x10,%esp

}
  802592:	90                   	nop
  802593:	c9                   	leave  
  802594:	c3                   	ret    

00802595 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802595:	55                   	push   %ebp
  802596:	89 e5                	mov    %esp,%ebp
  802598:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80259b:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8025a2:	00 00 00 
  8025a5:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8025ac:	00 00 00 
  8025af:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8025b6:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8025b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8025c0:	e9 9e 00 00 00       	jmp    802663 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8025c5:	a1 50 50 80 00       	mov    0x805050,%eax
  8025ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cd:	c1 e2 04             	shl    $0x4,%edx
  8025d0:	01 d0                	add    %edx,%eax
  8025d2:	85 c0                	test   %eax,%eax
  8025d4:	75 14                	jne    8025ea <initialize_MemBlocksList+0x55>
  8025d6:	83 ec 04             	sub    $0x4,%esp
  8025d9:	68 d4 40 80 00       	push   $0x8040d4
  8025de:	6a 3d                	push   $0x3d
  8025e0:	68 f7 40 80 00       	push   $0x8040f7
  8025e5:	e8 b1 e1 ff ff       	call   80079b <_panic>
  8025ea:	a1 50 50 80 00       	mov    0x805050,%eax
  8025ef:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025f2:	c1 e2 04             	shl    $0x4,%edx
  8025f5:	01 d0                	add    %edx,%eax
  8025f7:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8025fd:	89 10                	mov    %edx,(%eax)
  8025ff:	8b 00                	mov    (%eax),%eax
  802601:	85 c0                	test   %eax,%eax
  802603:	74 18                	je     80261d <initialize_MemBlocksList+0x88>
  802605:	a1 48 51 80 00       	mov    0x805148,%eax
  80260a:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802610:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802613:	c1 e1 04             	shl    $0x4,%ecx
  802616:	01 ca                	add    %ecx,%edx
  802618:	89 50 04             	mov    %edx,0x4(%eax)
  80261b:	eb 12                	jmp    80262f <initialize_MemBlocksList+0x9a>
  80261d:	a1 50 50 80 00       	mov    0x805050,%eax
  802622:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802625:	c1 e2 04             	shl    $0x4,%edx
  802628:	01 d0                	add    %edx,%eax
  80262a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80262f:	a1 50 50 80 00       	mov    0x805050,%eax
  802634:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802637:	c1 e2 04             	shl    $0x4,%edx
  80263a:	01 d0                	add    %edx,%eax
  80263c:	a3 48 51 80 00       	mov    %eax,0x805148
  802641:	a1 50 50 80 00       	mov    0x805050,%eax
  802646:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802649:	c1 e2 04             	shl    $0x4,%edx
  80264c:	01 d0                	add    %edx,%eax
  80264e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802655:	a1 54 51 80 00       	mov    0x805154,%eax
  80265a:	40                   	inc    %eax
  80265b:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802660:	ff 45 f4             	incl   -0xc(%ebp)
  802663:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802666:	3b 45 08             	cmp    0x8(%ebp),%eax
  802669:	0f 82 56 ff ff ff    	jb     8025c5 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  80266f:	90                   	nop
  802670:	c9                   	leave  
  802671:	c3                   	ret    

00802672 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802672:	55                   	push   %ebp
  802673:	89 e5                	mov    %esp,%ebp
  802675:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802678:	8b 45 08             	mov    0x8(%ebp),%eax
  80267b:	8b 00                	mov    (%eax),%eax
  80267d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802680:	eb 18                	jmp    80269a <find_block+0x28>

		if(tmp->sva == va){
  802682:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802685:	8b 40 08             	mov    0x8(%eax),%eax
  802688:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80268b:	75 05                	jne    802692 <find_block+0x20>
			return tmp ;
  80268d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802690:	eb 11                	jmp    8026a3 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802692:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802695:	8b 00                	mov    (%eax),%eax
  802697:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  80269a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80269e:	75 e2                	jne    802682 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8026a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8026a3:	c9                   	leave  
  8026a4:	c3                   	ret    

008026a5 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8026a5:	55                   	push   %ebp
  8026a6:	89 e5                	mov    %esp,%ebp
  8026a8:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8026ab:	a1 40 50 80 00       	mov    0x805040,%eax
  8026b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8026b3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8026bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026bf:	75 65                	jne    802726 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8026c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026c5:	75 14                	jne    8026db <insert_sorted_allocList+0x36>
  8026c7:	83 ec 04             	sub    $0x4,%esp
  8026ca:	68 d4 40 80 00       	push   $0x8040d4
  8026cf:	6a 62                	push   $0x62
  8026d1:	68 f7 40 80 00       	push   $0x8040f7
  8026d6:	e8 c0 e0 ff ff       	call   80079b <_panic>
  8026db:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	89 10                	mov    %edx,(%eax)
  8026e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e9:	8b 00                	mov    (%eax),%eax
  8026eb:	85 c0                	test   %eax,%eax
  8026ed:	74 0d                	je     8026fc <insert_sorted_allocList+0x57>
  8026ef:	a1 40 50 80 00       	mov    0x805040,%eax
  8026f4:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f7:	89 50 04             	mov    %edx,0x4(%eax)
  8026fa:	eb 08                	jmp    802704 <insert_sorted_allocList+0x5f>
  8026fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ff:	a3 44 50 80 00       	mov    %eax,0x805044
  802704:	8b 45 08             	mov    0x8(%ebp),%eax
  802707:	a3 40 50 80 00       	mov    %eax,0x805040
  80270c:	8b 45 08             	mov    0x8(%ebp),%eax
  80270f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802716:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80271b:	40                   	inc    %eax
  80271c:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802721:	e9 14 01 00 00       	jmp    80283a <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802726:	8b 45 08             	mov    0x8(%ebp),%eax
  802729:	8b 50 08             	mov    0x8(%eax),%edx
  80272c:	a1 44 50 80 00       	mov    0x805044,%eax
  802731:	8b 40 08             	mov    0x8(%eax),%eax
  802734:	39 c2                	cmp    %eax,%edx
  802736:	76 65                	jbe    80279d <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802738:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80273c:	75 14                	jne    802752 <insert_sorted_allocList+0xad>
  80273e:	83 ec 04             	sub    $0x4,%esp
  802741:	68 10 41 80 00       	push   $0x804110
  802746:	6a 64                	push   $0x64
  802748:	68 f7 40 80 00       	push   $0x8040f7
  80274d:	e8 49 e0 ff ff       	call   80079b <_panic>
  802752:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802758:	8b 45 08             	mov    0x8(%ebp),%eax
  80275b:	89 50 04             	mov    %edx,0x4(%eax)
  80275e:	8b 45 08             	mov    0x8(%ebp),%eax
  802761:	8b 40 04             	mov    0x4(%eax),%eax
  802764:	85 c0                	test   %eax,%eax
  802766:	74 0c                	je     802774 <insert_sorted_allocList+0xcf>
  802768:	a1 44 50 80 00       	mov    0x805044,%eax
  80276d:	8b 55 08             	mov    0x8(%ebp),%edx
  802770:	89 10                	mov    %edx,(%eax)
  802772:	eb 08                	jmp    80277c <insert_sorted_allocList+0xd7>
  802774:	8b 45 08             	mov    0x8(%ebp),%eax
  802777:	a3 40 50 80 00       	mov    %eax,0x805040
  80277c:	8b 45 08             	mov    0x8(%ebp),%eax
  80277f:	a3 44 50 80 00       	mov    %eax,0x805044
  802784:	8b 45 08             	mov    0x8(%ebp),%eax
  802787:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80278d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802792:	40                   	inc    %eax
  802793:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802798:	e9 9d 00 00 00       	jmp    80283a <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80279d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8027a4:	e9 85 00 00 00       	jmp    80282e <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8027a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ac:	8b 50 08             	mov    0x8(%eax),%edx
  8027af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b2:	8b 40 08             	mov    0x8(%eax),%eax
  8027b5:	39 c2                	cmp    %eax,%edx
  8027b7:	73 6a                	jae    802823 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8027b9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bd:	74 06                	je     8027c5 <insert_sorted_allocList+0x120>
  8027bf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027c3:	75 14                	jne    8027d9 <insert_sorted_allocList+0x134>
  8027c5:	83 ec 04             	sub    $0x4,%esp
  8027c8:	68 34 41 80 00       	push   $0x804134
  8027cd:	6a 6b                	push   $0x6b
  8027cf:	68 f7 40 80 00       	push   $0x8040f7
  8027d4:	e8 c2 df ff ff       	call   80079b <_panic>
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 50 04             	mov    0x4(%eax),%edx
  8027df:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e2:	89 50 04             	mov    %edx,0x4(%eax)
  8027e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027eb:	89 10                	mov    %edx,(%eax)
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 40 04             	mov    0x4(%eax),%eax
  8027f3:	85 c0                	test   %eax,%eax
  8027f5:	74 0d                	je     802804 <insert_sorted_allocList+0x15f>
  8027f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fa:	8b 40 04             	mov    0x4(%eax),%eax
  8027fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802800:	89 10                	mov    %edx,(%eax)
  802802:	eb 08                	jmp    80280c <insert_sorted_allocList+0x167>
  802804:	8b 45 08             	mov    0x8(%ebp),%eax
  802807:	a3 40 50 80 00       	mov    %eax,0x805040
  80280c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280f:	8b 55 08             	mov    0x8(%ebp),%edx
  802812:	89 50 04             	mov    %edx,0x4(%eax)
  802815:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80281a:	40                   	inc    %eax
  80281b:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802820:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802821:	eb 17                	jmp    80283a <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80282b:	ff 45 f0             	incl   -0x10(%ebp)
  80282e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802831:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802834:	0f 8c 6f ff ff ff    	jl     8027a9 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80283a:	90                   	nop
  80283b:	c9                   	leave  
  80283c:	c3                   	ret    

0080283d <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80283d:	55                   	push   %ebp
  80283e:	89 e5                	mov    %esp,%ebp
  802840:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802843:	a1 38 51 80 00       	mov    0x805138,%eax
  802848:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80284b:	e9 7c 01 00 00       	jmp    8029cc <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	8b 40 0c             	mov    0xc(%eax),%eax
  802856:	3b 45 08             	cmp    0x8(%ebp),%eax
  802859:	0f 86 cf 00 00 00    	jbe    80292e <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80285f:	a1 48 51 80 00       	mov    0x805148,%eax
  802864:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802867:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80286a:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  80286d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802870:	8b 55 08             	mov    0x8(%ebp),%edx
  802873:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 50 08             	mov    0x8(%eax),%edx
  80287c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287f:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802882:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802885:	8b 40 0c             	mov    0xc(%eax),%eax
  802888:	2b 45 08             	sub    0x8(%ebp),%eax
  80288b:	89 c2                	mov    %eax,%edx
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	8b 50 08             	mov    0x8(%eax),%edx
  802899:	8b 45 08             	mov    0x8(%ebp),%eax
  80289c:	01 c2                	add    %eax,%edx
  80289e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a1:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8028a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028a8:	75 17                	jne    8028c1 <alloc_block_FF+0x84>
  8028aa:	83 ec 04             	sub    $0x4,%esp
  8028ad:	68 69 41 80 00       	push   $0x804169
  8028b2:	68 83 00 00 00       	push   $0x83
  8028b7:	68 f7 40 80 00       	push   $0x8040f7
  8028bc:	e8 da de ff ff       	call   80079b <_panic>
  8028c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c4:	8b 00                	mov    (%eax),%eax
  8028c6:	85 c0                	test   %eax,%eax
  8028c8:	74 10                	je     8028da <alloc_block_FF+0x9d>
  8028ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028cd:	8b 00                	mov    (%eax),%eax
  8028cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028d2:	8b 52 04             	mov    0x4(%edx),%edx
  8028d5:	89 50 04             	mov    %edx,0x4(%eax)
  8028d8:	eb 0b                	jmp    8028e5 <alloc_block_FF+0xa8>
  8028da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028dd:	8b 40 04             	mov    0x4(%eax),%eax
  8028e0:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8028e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028e8:	8b 40 04             	mov    0x4(%eax),%eax
  8028eb:	85 c0                	test   %eax,%eax
  8028ed:	74 0f                	je     8028fe <alloc_block_FF+0xc1>
  8028ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028f2:	8b 40 04             	mov    0x4(%eax),%eax
  8028f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8028f8:	8b 12                	mov    (%edx),%edx
  8028fa:	89 10                	mov    %edx,(%eax)
  8028fc:	eb 0a                	jmp    802908 <alloc_block_FF+0xcb>
  8028fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802901:	8b 00                	mov    (%eax),%eax
  802903:	a3 48 51 80 00       	mov    %eax,0x805148
  802908:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80290b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802911:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802914:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80291b:	a1 54 51 80 00       	mov    0x805154,%eax
  802920:	48                   	dec    %eax
  802921:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802926:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802929:	e9 ad 00 00 00       	jmp    8029db <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  80292e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802931:	8b 40 0c             	mov    0xc(%eax),%eax
  802934:	3b 45 08             	cmp    0x8(%ebp),%eax
  802937:	0f 85 87 00 00 00    	jne    8029c4 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  80293d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802941:	75 17                	jne    80295a <alloc_block_FF+0x11d>
  802943:	83 ec 04             	sub    $0x4,%esp
  802946:	68 69 41 80 00       	push   $0x804169
  80294b:	68 87 00 00 00       	push   $0x87
  802950:	68 f7 40 80 00       	push   $0x8040f7
  802955:	e8 41 de ff ff       	call   80079b <_panic>
  80295a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295d:	8b 00                	mov    (%eax),%eax
  80295f:	85 c0                	test   %eax,%eax
  802961:	74 10                	je     802973 <alloc_block_FF+0x136>
  802963:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802966:	8b 00                	mov    (%eax),%eax
  802968:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80296b:	8b 52 04             	mov    0x4(%edx),%edx
  80296e:	89 50 04             	mov    %edx,0x4(%eax)
  802971:	eb 0b                	jmp    80297e <alloc_block_FF+0x141>
  802973:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802976:	8b 40 04             	mov    0x4(%eax),%eax
  802979:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	8b 40 04             	mov    0x4(%eax),%eax
  802984:	85 c0                	test   %eax,%eax
  802986:	74 0f                	je     802997 <alloc_block_FF+0x15a>
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 40 04             	mov    0x4(%eax),%eax
  80298e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802991:	8b 12                	mov    (%edx),%edx
  802993:	89 10                	mov    %edx,(%eax)
  802995:	eb 0a                	jmp    8029a1 <alloc_block_FF+0x164>
  802997:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299a:	8b 00                	mov    (%eax),%eax
  80299c:	a3 38 51 80 00       	mov    %eax,0x805138
  8029a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ad:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029b4:	a1 44 51 80 00       	mov    0x805144,%eax
  8029b9:	48                   	dec    %eax
  8029ba:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	eb 17                	jmp    8029db <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8029c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c7:	8b 00                	mov    (%eax),%eax
  8029c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8029cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029d0:	0f 85 7a fe ff ff    	jne    802850 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8029d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8029db:	c9                   	leave  
  8029dc:	c3                   	ret    

008029dd <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8029dd:	55                   	push   %ebp
  8029de:	89 e5                	mov    %esp,%ebp
  8029e0:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8029e3:	a1 38 51 80 00       	mov    0x805138,%eax
  8029e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8029eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8029f2:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8029f9:	a1 38 51 80 00       	mov    0x805138,%eax
  8029fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a01:	e9 d0 00 00 00       	jmp    802ad6 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802a06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a09:	8b 40 0c             	mov    0xc(%eax),%eax
  802a0c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a0f:	0f 82 b8 00 00 00    	jb     802acd <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802a15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a18:	8b 40 0c             	mov    0xc(%eax),%eax
  802a1b:	2b 45 08             	sub    0x8(%ebp),%eax
  802a1e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802a21:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a24:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802a27:	0f 83 a1 00 00 00    	jae    802ace <alloc_block_BF+0xf1>
				differsize = differance ;
  802a2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802a30:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802a39:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a3d:	0f 85 8b 00 00 00    	jne    802ace <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802a43:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a47:	75 17                	jne    802a60 <alloc_block_BF+0x83>
  802a49:	83 ec 04             	sub    $0x4,%esp
  802a4c:	68 69 41 80 00       	push   $0x804169
  802a51:	68 a0 00 00 00       	push   $0xa0
  802a56:	68 f7 40 80 00       	push   $0x8040f7
  802a5b:	e8 3b dd ff ff       	call   80079b <_panic>
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	8b 00                	mov    (%eax),%eax
  802a65:	85 c0                	test   %eax,%eax
  802a67:	74 10                	je     802a79 <alloc_block_BF+0x9c>
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 00                	mov    (%eax),%eax
  802a6e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a71:	8b 52 04             	mov    0x4(%edx),%edx
  802a74:	89 50 04             	mov    %edx,0x4(%eax)
  802a77:	eb 0b                	jmp    802a84 <alloc_block_BF+0xa7>
  802a79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7c:	8b 40 04             	mov    0x4(%eax),%eax
  802a7f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a87:	8b 40 04             	mov    0x4(%eax),%eax
  802a8a:	85 c0                	test   %eax,%eax
  802a8c:	74 0f                	je     802a9d <alloc_block_BF+0xc0>
  802a8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a91:	8b 40 04             	mov    0x4(%eax),%eax
  802a94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a97:	8b 12                	mov    (%edx),%edx
  802a99:	89 10                	mov    %edx,(%eax)
  802a9b:	eb 0a                	jmp    802aa7 <alloc_block_BF+0xca>
  802a9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa0:	8b 00                	mov    (%eax),%eax
  802aa2:	a3 38 51 80 00       	mov    %eax,0x805138
  802aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aaa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aba:	a1 44 51 80 00       	mov    0x805144,%eax
  802abf:	48                   	dec    %eax
  802ac0:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	e9 0c 01 00 00       	jmp    802bd9 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802acd:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802ace:	a1 40 51 80 00       	mov    0x805140,%eax
  802ad3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ad6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ada:	74 07                	je     802ae3 <alloc_block_BF+0x106>
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	eb 05                	jmp    802ae8 <alloc_block_BF+0x10b>
  802ae3:	b8 00 00 00 00       	mov    $0x0,%eax
  802ae8:	a3 40 51 80 00       	mov    %eax,0x805140
  802aed:	a1 40 51 80 00       	mov    0x805140,%eax
  802af2:	85 c0                	test   %eax,%eax
  802af4:	0f 85 0c ff ff ff    	jne    802a06 <alloc_block_BF+0x29>
  802afa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802afe:	0f 85 02 ff ff ff    	jne    802a06 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802b04:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802b08:	0f 84 c6 00 00 00    	je     802bd4 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802b0e:	a1 48 51 80 00       	mov    0x805148,%eax
  802b13:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802b16:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b19:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802b1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b22:	8b 50 08             	mov    0x8(%eax),%edx
  802b25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b28:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b2e:	8b 40 0c             	mov    0xc(%eax),%eax
  802b31:	2b 45 08             	sub    0x8(%ebp),%eax
  802b34:	89 c2                	mov    %eax,%edx
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b3f:	8b 50 08             	mov    0x8(%eax),%edx
  802b42:	8b 45 08             	mov    0x8(%ebp),%eax
  802b45:	01 c2                	add    %eax,%edx
  802b47:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4a:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802b4d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b51:	75 17                	jne    802b6a <alloc_block_BF+0x18d>
  802b53:	83 ec 04             	sub    $0x4,%esp
  802b56:	68 69 41 80 00       	push   $0x804169
  802b5b:	68 af 00 00 00       	push   $0xaf
  802b60:	68 f7 40 80 00       	push   $0x8040f7
  802b65:	e8 31 dc ff ff       	call   80079b <_panic>
  802b6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b6d:	8b 00                	mov    (%eax),%eax
  802b6f:	85 c0                	test   %eax,%eax
  802b71:	74 10                	je     802b83 <alloc_block_BF+0x1a6>
  802b73:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b76:	8b 00                	mov    (%eax),%eax
  802b78:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b7b:	8b 52 04             	mov    0x4(%edx),%edx
  802b7e:	89 50 04             	mov    %edx,0x4(%eax)
  802b81:	eb 0b                	jmp    802b8e <alloc_block_BF+0x1b1>
  802b83:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b86:	8b 40 04             	mov    0x4(%eax),%eax
  802b89:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b8e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b91:	8b 40 04             	mov    0x4(%eax),%eax
  802b94:	85 c0                	test   %eax,%eax
  802b96:	74 0f                	je     802ba7 <alloc_block_BF+0x1ca>
  802b98:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b9b:	8b 40 04             	mov    0x4(%eax),%eax
  802b9e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ba1:	8b 12                	mov    (%edx),%edx
  802ba3:	89 10                	mov    %edx,(%eax)
  802ba5:	eb 0a                	jmp    802bb1 <alloc_block_BF+0x1d4>
  802ba7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	a3 48 51 80 00       	mov    %eax,0x805148
  802bb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bb4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bbd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc4:	a1 54 51 80 00       	mov    0x805154,%eax
  802bc9:	48                   	dec    %eax
  802bca:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802bcf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802bd2:	eb 05                	jmp    802bd9 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802bd4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802bd9:	c9                   	leave  
  802bda:	c3                   	ret    

00802bdb <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802bdb:	55                   	push   %ebp
  802bdc:	89 e5                	mov    %esp,%ebp
  802bde:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802be1:	a1 38 51 80 00       	mov    0x805138,%eax
  802be6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802be9:	e9 7c 01 00 00       	jmp    802d6a <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf1:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf4:	3b 45 08             	cmp    0x8(%ebp),%eax
  802bf7:	0f 86 cf 00 00 00    	jbe    802ccc <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802bfd:	a1 48 51 80 00       	mov    0x805148,%eax
  802c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802c05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c08:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802c0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802c11:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802c14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c17:	8b 50 08             	mov    0x8(%eax),%edx
  802c1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1d:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	8b 40 0c             	mov    0xc(%eax),%eax
  802c26:	2b 45 08             	sub    0x8(%ebp),%eax
  802c29:	89 c2                	mov    %eax,%edx
  802c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2e:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802c31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c34:	8b 50 08             	mov    0x8(%eax),%edx
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	01 c2                	add    %eax,%edx
  802c3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3f:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802c42:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802c46:	75 17                	jne    802c5f <alloc_block_NF+0x84>
  802c48:	83 ec 04             	sub    $0x4,%esp
  802c4b:	68 69 41 80 00       	push   $0x804169
  802c50:	68 c4 00 00 00       	push   $0xc4
  802c55:	68 f7 40 80 00       	push   $0x8040f7
  802c5a:	e8 3c db ff ff       	call   80079b <_panic>
  802c5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c62:	8b 00                	mov    (%eax),%eax
  802c64:	85 c0                	test   %eax,%eax
  802c66:	74 10                	je     802c78 <alloc_block_NF+0x9d>
  802c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c6b:	8b 00                	mov    (%eax),%eax
  802c6d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c70:	8b 52 04             	mov    0x4(%edx),%edx
  802c73:	89 50 04             	mov    %edx,0x4(%eax)
  802c76:	eb 0b                	jmp    802c83 <alloc_block_NF+0xa8>
  802c78:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7b:	8b 40 04             	mov    0x4(%eax),%eax
  802c7e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c83:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c86:	8b 40 04             	mov    0x4(%eax),%eax
  802c89:	85 c0                	test   %eax,%eax
  802c8b:	74 0f                	je     802c9c <alloc_block_NF+0xc1>
  802c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c90:	8b 40 04             	mov    0x4(%eax),%eax
  802c93:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c96:	8b 12                	mov    (%edx),%edx
  802c98:	89 10                	mov    %edx,(%eax)
  802c9a:	eb 0a                	jmp    802ca6 <alloc_block_NF+0xcb>
  802c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c9f:	8b 00                	mov    (%eax),%eax
  802ca1:	a3 48 51 80 00       	mov    %eax,0x805148
  802ca6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ca9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802caf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cb2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cb9:	a1 54 51 80 00       	mov    0x805154,%eax
  802cbe:	48                   	dec    %eax
  802cbf:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802cc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cc7:	e9 ad 00 00 00       	jmp    802d79 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd2:	3b 45 08             	cmp    0x8(%ebp),%eax
  802cd5:	0f 85 87 00 00 00    	jne    802d62 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802cdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cdf:	75 17                	jne    802cf8 <alloc_block_NF+0x11d>
  802ce1:	83 ec 04             	sub    $0x4,%esp
  802ce4:	68 69 41 80 00       	push   $0x804169
  802ce9:	68 c8 00 00 00       	push   $0xc8
  802cee:	68 f7 40 80 00       	push   $0x8040f7
  802cf3:	e8 a3 da ff ff       	call   80079b <_panic>
  802cf8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfb:	8b 00                	mov    (%eax),%eax
  802cfd:	85 c0                	test   %eax,%eax
  802cff:	74 10                	je     802d11 <alloc_block_NF+0x136>
  802d01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d04:	8b 00                	mov    (%eax),%eax
  802d06:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d09:	8b 52 04             	mov    0x4(%edx),%edx
  802d0c:	89 50 04             	mov    %edx,0x4(%eax)
  802d0f:	eb 0b                	jmp    802d1c <alloc_block_NF+0x141>
  802d11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d14:	8b 40 04             	mov    0x4(%eax),%eax
  802d17:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d1f:	8b 40 04             	mov    0x4(%eax),%eax
  802d22:	85 c0                	test   %eax,%eax
  802d24:	74 0f                	je     802d35 <alloc_block_NF+0x15a>
  802d26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d29:	8b 40 04             	mov    0x4(%eax),%eax
  802d2c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d2f:	8b 12                	mov    (%edx),%edx
  802d31:	89 10                	mov    %edx,(%eax)
  802d33:	eb 0a                	jmp    802d3f <alloc_block_NF+0x164>
  802d35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d38:	8b 00                	mov    (%eax),%eax
  802d3a:	a3 38 51 80 00       	mov    %eax,0x805138
  802d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d42:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d52:	a1 44 51 80 00       	mov    0x805144,%eax
  802d57:	48                   	dec    %eax
  802d58:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d60:	eb 17                	jmp    802d79 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	8b 00                	mov    (%eax),%eax
  802d67:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802d6a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d6e:	0f 85 7a fe ff ff    	jne    802bee <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802d74:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802d79:	c9                   	leave  
  802d7a:	c3                   	ret    

00802d7b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802d7b:	55                   	push   %ebp
  802d7c:	89 e5                	mov    %esp,%ebp
  802d7e:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802d81:	a1 38 51 80 00       	mov    0x805138,%eax
  802d86:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802d89:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d8e:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802d91:	a1 44 51 80 00       	mov    0x805144,%eax
  802d96:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802d99:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d9d:	75 68                	jne    802e07 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802d9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802da3:	75 17                	jne    802dbc <insert_sorted_with_merge_freeList+0x41>
  802da5:	83 ec 04             	sub    $0x4,%esp
  802da8:	68 d4 40 80 00       	push   $0x8040d4
  802dad:	68 da 00 00 00       	push   $0xda
  802db2:	68 f7 40 80 00       	push   $0x8040f7
  802db7:	e8 df d9 ff ff       	call   80079b <_panic>
  802dbc:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc5:	89 10                	mov    %edx,(%eax)
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	8b 00                	mov    (%eax),%eax
  802dcc:	85 c0                	test   %eax,%eax
  802dce:	74 0d                	je     802ddd <insert_sorted_with_merge_freeList+0x62>
  802dd0:	a1 38 51 80 00       	mov    0x805138,%eax
  802dd5:	8b 55 08             	mov    0x8(%ebp),%edx
  802dd8:	89 50 04             	mov    %edx,0x4(%eax)
  802ddb:	eb 08                	jmp    802de5 <insert_sorted_with_merge_freeList+0x6a>
  802ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  802de0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802de5:	8b 45 08             	mov    0x8(%ebp),%eax
  802de8:	a3 38 51 80 00       	mov    %eax,0x805138
  802ded:	8b 45 08             	mov    0x8(%ebp),%eax
  802df0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802df7:	a1 44 51 80 00       	mov    0x805144,%eax
  802dfc:	40                   	inc    %eax
  802dfd:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802e02:	e9 49 07 00 00       	jmp    803550 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802e07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e0a:	8b 50 08             	mov    0x8(%eax),%edx
  802e0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e10:	8b 40 0c             	mov    0xc(%eax),%eax
  802e13:	01 c2                	add    %eax,%edx
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	8b 40 08             	mov    0x8(%eax),%eax
  802e1b:	39 c2                	cmp    %eax,%edx
  802e1d:	73 77                	jae    802e96 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802e1f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e22:	8b 00                	mov    (%eax),%eax
  802e24:	85 c0                	test   %eax,%eax
  802e26:	75 6e                	jne    802e96 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802e28:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e2c:	74 68                	je     802e96 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802e2e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e32:	75 17                	jne    802e4b <insert_sorted_with_merge_freeList+0xd0>
  802e34:	83 ec 04             	sub    $0x4,%esp
  802e37:	68 10 41 80 00       	push   $0x804110
  802e3c:	68 e0 00 00 00       	push   $0xe0
  802e41:	68 f7 40 80 00       	push   $0x8040f7
  802e46:	e8 50 d9 ff ff       	call   80079b <_panic>
  802e4b:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802e51:	8b 45 08             	mov    0x8(%ebp),%eax
  802e54:	89 50 04             	mov    %edx,0x4(%eax)
  802e57:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5a:	8b 40 04             	mov    0x4(%eax),%eax
  802e5d:	85 c0                	test   %eax,%eax
  802e5f:	74 0c                	je     802e6d <insert_sorted_with_merge_freeList+0xf2>
  802e61:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802e66:	8b 55 08             	mov    0x8(%ebp),%edx
  802e69:	89 10                	mov    %edx,(%eax)
  802e6b:	eb 08                	jmp    802e75 <insert_sorted_with_merge_freeList+0xfa>
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	a3 38 51 80 00       	mov    %eax,0x805138
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e86:	a1 44 51 80 00       	mov    0x805144,%eax
  802e8b:	40                   	inc    %eax
  802e8c:	a3 44 51 80 00       	mov    %eax,0x805144
  802e91:	e9 ba 06 00 00       	jmp    803550 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	8b 50 0c             	mov    0xc(%eax),%edx
  802e9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9f:	8b 40 08             	mov    0x8(%eax),%eax
  802ea2:	01 c2                	add    %eax,%edx
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	8b 40 08             	mov    0x8(%eax),%eax
  802eaa:	39 c2                	cmp    %eax,%edx
  802eac:	73 78                	jae    802f26 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802eae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb1:	8b 40 04             	mov    0x4(%eax),%eax
  802eb4:	85 c0                	test   %eax,%eax
  802eb6:	75 6e                	jne    802f26 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802eb8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ebc:	74 68                	je     802f26 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802ebe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec2:	75 17                	jne    802edb <insert_sorted_with_merge_freeList+0x160>
  802ec4:	83 ec 04             	sub    $0x4,%esp
  802ec7:	68 d4 40 80 00       	push   $0x8040d4
  802ecc:	68 e6 00 00 00       	push   $0xe6
  802ed1:	68 f7 40 80 00       	push   $0x8040f7
  802ed6:	e8 c0 d8 ff ff       	call   80079b <_panic>
  802edb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	89 10                	mov    %edx,(%eax)
  802ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee9:	8b 00                	mov    (%eax),%eax
  802eeb:	85 c0                	test   %eax,%eax
  802eed:	74 0d                	je     802efc <insert_sorted_with_merge_freeList+0x181>
  802eef:	a1 38 51 80 00       	mov    0x805138,%eax
  802ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ef7:	89 50 04             	mov    %edx,0x4(%eax)
  802efa:	eb 08                	jmp    802f04 <insert_sorted_with_merge_freeList+0x189>
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	a3 38 51 80 00       	mov    %eax,0x805138
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f16:	a1 44 51 80 00       	mov    0x805144,%eax
  802f1b:	40                   	inc    %eax
  802f1c:	a3 44 51 80 00       	mov    %eax,0x805144
  802f21:	e9 2a 06 00 00       	jmp    803550 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802f26:	a1 38 51 80 00       	mov    0x805138,%eax
  802f2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2e:	e9 ed 05 00 00       	jmp    803520 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802f3b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f3f:	0f 84 a7 00 00 00    	je     802fec <insert_sorted_with_merge_freeList+0x271>
  802f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f48:	8b 50 0c             	mov    0xc(%eax),%edx
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	8b 40 08             	mov    0x8(%eax),%eax
  802f51:	01 c2                	add    %eax,%edx
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	8b 40 08             	mov    0x8(%eax),%eax
  802f59:	39 c2                	cmp    %eax,%edx
  802f5b:	0f 83 8b 00 00 00    	jae    802fec <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802f61:	8b 45 08             	mov    0x8(%ebp),%eax
  802f64:	8b 50 0c             	mov    0xc(%eax),%edx
  802f67:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6a:	8b 40 08             	mov    0x8(%eax),%eax
  802f6d:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802f6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f72:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802f75:	39 c2                	cmp    %eax,%edx
  802f77:	73 73                	jae    802fec <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802f79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f7d:	74 06                	je     802f85 <insert_sorted_with_merge_freeList+0x20a>
  802f7f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f83:	75 17                	jne    802f9c <insert_sorted_with_merge_freeList+0x221>
  802f85:	83 ec 04             	sub    $0x4,%esp
  802f88:	68 88 41 80 00       	push   $0x804188
  802f8d:	68 f0 00 00 00       	push   $0xf0
  802f92:	68 f7 40 80 00       	push   $0x8040f7
  802f97:	e8 ff d7 ff ff       	call   80079b <_panic>
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9f:	8b 10                	mov    (%eax),%edx
  802fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa4:	89 10                	mov    %edx,(%eax)
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	8b 00                	mov    (%eax),%eax
  802fab:	85 c0                	test   %eax,%eax
  802fad:	74 0b                	je     802fba <insert_sorted_with_merge_freeList+0x23f>
  802faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb2:	8b 00                	mov    (%eax),%eax
  802fb4:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb7:	89 50 04             	mov    %edx,0x4(%eax)
  802fba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fbd:	8b 55 08             	mov    0x8(%ebp),%edx
  802fc0:	89 10                	mov    %edx,(%eax)
  802fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802fc8:	89 50 04             	mov    %edx,0x4(%eax)
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	8b 00                	mov    (%eax),%eax
  802fd0:	85 c0                	test   %eax,%eax
  802fd2:	75 08                	jne    802fdc <insert_sorted_with_merge_freeList+0x261>
  802fd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd7:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802fdc:	a1 44 51 80 00       	mov    0x805144,%eax
  802fe1:	40                   	inc    %eax
  802fe2:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  802fe7:	e9 64 05 00 00       	jmp    803550 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802fec:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ff1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ff4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ff9:	8b 40 08             	mov    0x8(%eax),%eax
  802ffc:	01 c2                	add    %eax,%edx
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	8b 40 08             	mov    0x8(%eax),%eax
  803004:	39 c2                	cmp    %eax,%edx
  803006:	0f 85 b1 00 00 00    	jne    8030bd <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  80300c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803011:	85 c0                	test   %eax,%eax
  803013:	0f 84 a4 00 00 00    	je     8030bd <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  803019:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80301e:	8b 00                	mov    (%eax),%eax
  803020:	85 c0                	test   %eax,%eax
  803022:	0f 85 95 00 00 00    	jne    8030bd <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803028:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80302d:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803033:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803036:	8b 55 08             	mov    0x8(%ebp),%edx
  803039:	8b 52 0c             	mov    0xc(%edx),%edx
  80303c:	01 ca                	add    %ecx,%edx
  80303e:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  803041:	8b 45 08             	mov    0x8(%ebp),%eax
  803044:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  80304b:	8b 45 08             	mov    0x8(%ebp),%eax
  80304e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803055:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803059:	75 17                	jne    803072 <insert_sorted_with_merge_freeList+0x2f7>
  80305b:	83 ec 04             	sub    $0x4,%esp
  80305e:	68 d4 40 80 00       	push   $0x8040d4
  803063:	68 ff 00 00 00       	push   $0xff
  803068:	68 f7 40 80 00       	push   $0x8040f7
  80306d:	e8 29 d7 ff ff       	call   80079b <_panic>
  803072:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803078:	8b 45 08             	mov    0x8(%ebp),%eax
  80307b:	89 10                	mov    %edx,(%eax)
  80307d:	8b 45 08             	mov    0x8(%ebp),%eax
  803080:	8b 00                	mov    (%eax),%eax
  803082:	85 c0                	test   %eax,%eax
  803084:	74 0d                	je     803093 <insert_sorted_with_merge_freeList+0x318>
  803086:	a1 48 51 80 00       	mov    0x805148,%eax
  80308b:	8b 55 08             	mov    0x8(%ebp),%edx
  80308e:	89 50 04             	mov    %edx,0x4(%eax)
  803091:	eb 08                	jmp    80309b <insert_sorted_with_merge_freeList+0x320>
  803093:	8b 45 08             	mov    0x8(%ebp),%eax
  803096:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80309b:	8b 45 08             	mov    0x8(%ebp),%eax
  80309e:	a3 48 51 80 00       	mov    %eax,0x805148
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ad:	a1 54 51 80 00       	mov    0x805154,%eax
  8030b2:	40                   	inc    %eax
  8030b3:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  8030b8:	e9 93 04 00 00       	jmp    803550 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  8030bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c0:	8b 50 08             	mov    0x8(%eax),%edx
  8030c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c6:	8b 40 0c             	mov    0xc(%eax),%eax
  8030c9:	01 c2                	add    %eax,%edx
  8030cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ce:	8b 40 08             	mov    0x8(%eax),%eax
  8030d1:	39 c2                	cmp    %eax,%edx
  8030d3:	0f 85 ae 00 00 00    	jne    803187 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  8030d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8030dc:	8b 50 0c             	mov    0xc(%eax),%edx
  8030df:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e2:	8b 40 08             	mov    0x8(%eax),%eax
  8030e5:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  8030e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030ea:	8b 00                	mov    (%eax),%eax
  8030ec:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  8030ef:	39 c2                	cmp    %eax,%edx
  8030f1:	0f 84 90 00 00 00    	je     803187 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  8030f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fa:	8b 50 0c             	mov    0xc(%eax),%edx
  8030fd:	8b 45 08             	mov    0x8(%ebp),%eax
  803100:	8b 40 0c             	mov    0xc(%eax),%eax
  803103:	01 c2                	add    %eax,%edx
  803105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803108:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80310b:	8b 45 08             	mov    0x8(%ebp),%eax
  80310e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803115:	8b 45 08             	mov    0x8(%ebp),%eax
  803118:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80311f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803123:	75 17                	jne    80313c <insert_sorted_with_merge_freeList+0x3c1>
  803125:	83 ec 04             	sub    $0x4,%esp
  803128:	68 d4 40 80 00       	push   $0x8040d4
  80312d:	68 0b 01 00 00       	push   $0x10b
  803132:	68 f7 40 80 00       	push   $0x8040f7
  803137:	e8 5f d6 ff ff       	call   80079b <_panic>
  80313c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803142:	8b 45 08             	mov    0x8(%ebp),%eax
  803145:	89 10                	mov    %edx,(%eax)
  803147:	8b 45 08             	mov    0x8(%ebp),%eax
  80314a:	8b 00                	mov    (%eax),%eax
  80314c:	85 c0                	test   %eax,%eax
  80314e:	74 0d                	je     80315d <insert_sorted_with_merge_freeList+0x3e2>
  803150:	a1 48 51 80 00       	mov    0x805148,%eax
  803155:	8b 55 08             	mov    0x8(%ebp),%edx
  803158:	89 50 04             	mov    %edx,0x4(%eax)
  80315b:	eb 08                	jmp    803165 <insert_sorted_with_merge_freeList+0x3ea>
  80315d:	8b 45 08             	mov    0x8(%ebp),%eax
  803160:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	a3 48 51 80 00       	mov    %eax,0x805148
  80316d:	8b 45 08             	mov    0x8(%ebp),%eax
  803170:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803177:	a1 54 51 80 00       	mov    0x805154,%eax
  80317c:	40                   	inc    %eax
  80317d:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803182:	e9 c9 03 00 00       	jmp    803550 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803187:	8b 45 08             	mov    0x8(%ebp),%eax
  80318a:	8b 50 0c             	mov    0xc(%eax),%edx
  80318d:	8b 45 08             	mov    0x8(%ebp),%eax
  803190:	8b 40 08             	mov    0x8(%eax),%eax
  803193:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  803195:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803198:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  80319b:	39 c2                	cmp    %eax,%edx
  80319d:	0f 85 bb 00 00 00    	jne    80325e <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  8031a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8031a7:	0f 84 b1 00 00 00    	je     80325e <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  8031ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b0:	8b 40 04             	mov    0x4(%eax),%eax
  8031b3:	85 c0                	test   %eax,%eax
  8031b5:	0f 85 a3 00 00 00    	jne    80325e <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8031bb:	a1 38 51 80 00       	mov    0x805138,%eax
  8031c0:	8b 55 08             	mov    0x8(%ebp),%edx
  8031c3:	8b 52 08             	mov    0x8(%edx),%edx
  8031c6:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  8031c9:	a1 38 51 80 00       	mov    0x805138,%eax
  8031ce:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031d4:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8031d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8031da:	8b 52 0c             	mov    0xc(%edx),%edx
  8031dd:	01 ca                	add    %ecx,%edx
  8031df:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8031ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ef:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8031f6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031fa:	75 17                	jne    803213 <insert_sorted_with_merge_freeList+0x498>
  8031fc:	83 ec 04             	sub    $0x4,%esp
  8031ff:	68 d4 40 80 00       	push   $0x8040d4
  803204:	68 17 01 00 00       	push   $0x117
  803209:	68 f7 40 80 00       	push   $0x8040f7
  80320e:	e8 88 d5 ff ff       	call   80079b <_panic>
  803213:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803219:	8b 45 08             	mov    0x8(%ebp),%eax
  80321c:	89 10                	mov    %edx,(%eax)
  80321e:	8b 45 08             	mov    0x8(%ebp),%eax
  803221:	8b 00                	mov    (%eax),%eax
  803223:	85 c0                	test   %eax,%eax
  803225:	74 0d                	je     803234 <insert_sorted_with_merge_freeList+0x4b9>
  803227:	a1 48 51 80 00       	mov    0x805148,%eax
  80322c:	8b 55 08             	mov    0x8(%ebp),%edx
  80322f:	89 50 04             	mov    %edx,0x4(%eax)
  803232:	eb 08                	jmp    80323c <insert_sorted_with_merge_freeList+0x4c1>
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80323c:	8b 45 08             	mov    0x8(%ebp),%eax
  80323f:	a3 48 51 80 00       	mov    %eax,0x805148
  803244:	8b 45 08             	mov    0x8(%ebp),%eax
  803247:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80324e:	a1 54 51 80 00       	mov    0x805154,%eax
  803253:	40                   	inc    %eax
  803254:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803259:	e9 f2 02 00 00       	jmp    803550 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  80325e:	8b 45 08             	mov    0x8(%ebp),%eax
  803261:	8b 50 08             	mov    0x8(%eax),%edx
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	8b 40 0c             	mov    0xc(%eax),%eax
  80326a:	01 c2                	add    %eax,%edx
  80326c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80326f:	8b 40 08             	mov    0x8(%eax),%eax
  803272:	39 c2                	cmp    %eax,%edx
  803274:	0f 85 be 00 00 00    	jne    803338 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  80327a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327d:	8b 40 04             	mov    0x4(%eax),%eax
  803280:	8b 50 08             	mov    0x8(%eax),%edx
  803283:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803286:	8b 40 04             	mov    0x4(%eax),%eax
  803289:	8b 40 0c             	mov    0xc(%eax),%eax
  80328c:	01 c2                	add    %eax,%edx
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	8b 40 08             	mov    0x8(%eax),%eax
  803294:	39 c2                	cmp    %eax,%edx
  803296:	0f 84 9c 00 00 00    	je     803338 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  80329c:	8b 45 08             	mov    0x8(%ebp),%eax
  80329f:	8b 50 08             	mov    0x8(%eax),%edx
  8032a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a5:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  8032a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ab:	8b 50 0c             	mov    0xc(%eax),%edx
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8032b4:	01 c2                	add    %eax,%edx
  8032b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b9:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8032bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032bf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8032c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032c9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8032d0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032d4:	75 17                	jne    8032ed <insert_sorted_with_merge_freeList+0x572>
  8032d6:	83 ec 04             	sub    $0x4,%esp
  8032d9:	68 d4 40 80 00       	push   $0x8040d4
  8032de:	68 26 01 00 00       	push   $0x126
  8032e3:	68 f7 40 80 00       	push   $0x8040f7
  8032e8:	e8 ae d4 ff ff       	call   80079b <_panic>
  8032ed:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	89 10                	mov    %edx,(%eax)
  8032f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032fb:	8b 00                	mov    (%eax),%eax
  8032fd:	85 c0                	test   %eax,%eax
  8032ff:	74 0d                	je     80330e <insert_sorted_with_merge_freeList+0x593>
  803301:	a1 48 51 80 00       	mov    0x805148,%eax
  803306:	8b 55 08             	mov    0x8(%ebp),%edx
  803309:	89 50 04             	mov    %edx,0x4(%eax)
  80330c:	eb 08                	jmp    803316 <insert_sorted_with_merge_freeList+0x59b>
  80330e:	8b 45 08             	mov    0x8(%ebp),%eax
  803311:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803316:	8b 45 08             	mov    0x8(%ebp),%eax
  803319:	a3 48 51 80 00       	mov    %eax,0x805148
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803328:	a1 54 51 80 00       	mov    0x805154,%eax
  80332d:	40                   	inc    %eax
  80332e:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  803333:	e9 18 02 00 00       	jmp    803550 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803338:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80333b:	8b 50 0c             	mov    0xc(%eax),%edx
  80333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803341:	8b 40 08             	mov    0x8(%eax),%eax
  803344:	01 c2                	add    %eax,%edx
  803346:	8b 45 08             	mov    0x8(%ebp),%eax
  803349:	8b 40 08             	mov    0x8(%eax),%eax
  80334c:	39 c2                	cmp    %eax,%edx
  80334e:	0f 85 c4 01 00 00    	jne    803518 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	8b 50 0c             	mov    0xc(%eax),%edx
  80335a:	8b 45 08             	mov    0x8(%ebp),%eax
  80335d:	8b 40 08             	mov    0x8(%eax),%eax
  803360:	01 c2                	add    %eax,%edx
  803362:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803365:	8b 00                	mov    (%eax),%eax
  803367:	8b 40 08             	mov    0x8(%eax),%eax
  80336a:	39 c2                	cmp    %eax,%edx
  80336c:	0f 85 a6 01 00 00    	jne    803518 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  803372:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803376:	0f 84 9c 01 00 00    	je     803518 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  80337c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80337f:	8b 50 0c             	mov    0xc(%eax),%edx
  803382:	8b 45 08             	mov    0x8(%ebp),%eax
  803385:	8b 40 0c             	mov    0xc(%eax),%eax
  803388:	01 c2                	add    %eax,%edx
  80338a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80338d:	8b 00                	mov    (%eax),%eax
  80338f:	8b 40 0c             	mov    0xc(%eax),%eax
  803392:	01 c2                	add    %eax,%edx
  803394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803397:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  80339a:	8b 45 08             	mov    0x8(%ebp),%eax
  80339d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8033a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8033ae:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8033b2:	75 17                	jne    8033cb <insert_sorted_with_merge_freeList+0x650>
  8033b4:	83 ec 04             	sub    $0x4,%esp
  8033b7:	68 d4 40 80 00       	push   $0x8040d4
  8033bc:	68 32 01 00 00       	push   $0x132
  8033c1:	68 f7 40 80 00       	push   $0x8040f7
  8033c6:	e8 d0 d3 ff ff       	call   80079b <_panic>
  8033cb:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d4:	89 10                	mov    %edx,(%eax)
  8033d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d9:	8b 00                	mov    (%eax),%eax
  8033db:	85 c0                	test   %eax,%eax
  8033dd:	74 0d                	je     8033ec <insert_sorted_with_merge_freeList+0x671>
  8033df:	a1 48 51 80 00       	mov    0x805148,%eax
  8033e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8033e7:	89 50 04             	mov    %edx,0x4(%eax)
  8033ea:	eb 08                	jmp    8033f4 <insert_sorted_with_merge_freeList+0x679>
  8033ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ef:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f7:	a3 48 51 80 00       	mov    %eax,0x805148
  8033fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803406:	a1 54 51 80 00       	mov    0x805154,%eax
  80340b:	40                   	inc    %eax
  80340c:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803414:	8b 00                	mov    (%eax),%eax
  803416:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  80341d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803420:	8b 00                	mov    (%eax),%eax
  803422:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80342c:	8b 00                	mov    (%eax),%eax
  80342e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803431:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803435:	75 17                	jne    80344e <insert_sorted_with_merge_freeList+0x6d3>
  803437:	83 ec 04             	sub    $0x4,%esp
  80343a:	68 69 41 80 00       	push   $0x804169
  80343f:	68 36 01 00 00       	push   $0x136
  803444:	68 f7 40 80 00       	push   $0x8040f7
  803449:	e8 4d d3 ff ff       	call   80079b <_panic>
  80344e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803451:	8b 00                	mov    (%eax),%eax
  803453:	85 c0                	test   %eax,%eax
  803455:	74 10                	je     803467 <insert_sorted_with_merge_freeList+0x6ec>
  803457:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345a:	8b 00                	mov    (%eax),%eax
  80345c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80345f:	8b 52 04             	mov    0x4(%edx),%edx
  803462:	89 50 04             	mov    %edx,0x4(%eax)
  803465:	eb 0b                	jmp    803472 <insert_sorted_with_merge_freeList+0x6f7>
  803467:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80346a:	8b 40 04             	mov    0x4(%eax),%eax
  80346d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803472:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803475:	8b 40 04             	mov    0x4(%eax),%eax
  803478:	85 c0                	test   %eax,%eax
  80347a:	74 0f                	je     80348b <insert_sorted_with_merge_freeList+0x710>
  80347c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347f:	8b 40 04             	mov    0x4(%eax),%eax
  803482:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803485:	8b 12                	mov    (%edx),%edx
  803487:	89 10                	mov    %edx,(%eax)
  803489:	eb 0a                	jmp    803495 <insert_sorted_with_merge_freeList+0x71a>
  80348b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80348e:	8b 00                	mov    (%eax),%eax
  803490:	a3 38 51 80 00       	mov    %eax,0x805138
  803495:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803498:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80349e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034a8:	a1 44 51 80 00       	mov    0x805144,%eax
  8034ad:	48                   	dec    %eax
  8034ae:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8034b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8034b7:	75 17                	jne    8034d0 <insert_sorted_with_merge_freeList+0x755>
  8034b9:	83 ec 04             	sub    $0x4,%esp
  8034bc:	68 d4 40 80 00       	push   $0x8040d4
  8034c1:	68 37 01 00 00       	push   $0x137
  8034c6:	68 f7 40 80 00       	push   $0x8040f7
  8034cb:	e8 cb d2 ff ff       	call   80079b <_panic>
  8034d0:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8034d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034d9:	89 10                	mov    %edx,(%eax)
  8034db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034de:	8b 00                	mov    (%eax),%eax
  8034e0:	85 c0                	test   %eax,%eax
  8034e2:	74 0d                	je     8034f1 <insert_sorted_with_merge_freeList+0x776>
  8034e4:	a1 48 51 80 00       	mov    0x805148,%eax
  8034e9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8034ec:	89 50 04             	mov    %edx,0x4(%eax)
  8034ef:	eb 08                	jmp    8034f9 <insert_sorted_with_merge_freeList+0x77e>
  8034f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034f4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8034fc:	a3 48 51 80 00       	mov    %eax,0x805148
  803501:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803504:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80350b:	a1 54 51 80 00       	mov    0x805154,%eax
  803510:	40                   	inc    %eax
  803511:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803516:	eb 38                	jmp    803550 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803518:	a1 40 51 80 00       	mov    0x805140,%eax
  80351d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803520:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803524:	74 07                	je     80352d <insert_sorted_with_merge_freeList+0x7b2>
  803526:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803529:	8b 00                	mov    (%eax),%eax
  80352b:	eb 05                	jmp    803532 <insert_sorted_with_merge_freeList+0x7b7>
  80352d:	b8 00 00 00 00       	mov    $0x0,%eax
  803532:	a3 40 51 80 00       	mov    %eax,0x805140
  803537:	a1 40 51 80 00       	mov    0x805140,%eax
  80353c:	85 c0                	test   %eax,%eax
  80353e:	0f 85 ef f9 ff ff    	jne    802f33 <insert_sorted_with_merge_freeList+0x1b8>
  803544:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803548:	0f 85 e5 f9 ff ff    	jne    802f33 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  80354e:	eb 00                	jmp    803550 <insert_sorted_with_merge_freeList+0x7d5>
  803550:	90                   	nop
  803551:	c9                   	leave  
  803552:	c3                   	ret    
  803553:	90                   	nop

00803554 <__udivdi3>:
  803554:	55                   	push   %ebp
  803555:	57                   	push   %edi
  803556:	56                   	push   %esi
  803557:	53                   	push   %ebx
  803558:	83 ec 1c             	sub    $0x1c,%esp
  80355b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80355f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803563:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803567:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80356b:	89 ca                	mov    %ecx,%edx
  80356d:	89 f8                	mov    %edi,%eax
  80356f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803573:	85 f6                	test   %esi,%esi
  803575:	75 2d                	jne    8035a4 <__udivdi3+0x50>
  803577:	39 cf                	cmp    %ecx,%edi
  803579:	77 65                	ja     8035e0 <__udivdi3+0x8c>
  80357b:	89 fd                	mov    %edi,%ebp
  80357d:	85 ff                	test   %edi,%edi
  80357f:	75 0b                	jne    80358c <__udivdi3+0x38>
  803581:	b8 01 00 00 00       	mov    $0x1,%eax
  803586:	31 d2                	xor    %edx,%edx
  803588:	f7 f7                	div    %edi
  80358a:	89 c5                	mov    %eax,%ebp
  80358c:	31 d2                	xor    %edx,%edx
  80358e:	89 c8                	mov    %ecx,%eax
  803590:	f7 f5                	div    %ebp
  803592:	89 c1                	mov    %eax,%ecx
  803594:	89 d8                	mov    %ebx,%eax
  803596:	f7 f5                	div    %ebp
  803598:	89 cf                	mov    %ecx,%edi
  80359a:	89 fa                	mov    %edi,%edx
  80359c:	83 c4 1c             	add    $0x1c,%esp
  80359f:	5b                   	pop    %ebx
  8035a0:	5e                   	pop    %esi
  8035a1:	5f                   	pop    %edi
  8035a2:	5d                   	pop    %ebp
  8035a3:	c3                   	ret    
  8035a4:	39 ce                	cmp    %ecx,%esi
  8035a6:	77 28                	ja     8035d0 <__udivdi3+0x7c>
  8035a8:	0f bd fe             	bsr    %esi,%edi
  8035ab:	83 f7 1f             	xor    $0x1f,%edi
  8035ae:	75 40                	jne    8035f0 <__udivdi3+0x9c>
  8035b0:	39 ce                	cmp    %ecx,%esi
  8035b2:	72 0a                	jb     8035be <__udivdi3+0x6a>
  8035b4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035b8:	0f 87 9e 00 00 00    	ja     80365c <__udivdi3+0x108>
  8035be:	b8 01 00 00 00       	mov    $0x1,%eax
  8035c3:	89 fa                	mov    %edi,%edx
  8035c5:	83 c4 1c             	add    $0x1c,%esp
  8035c8:	5b                   	pop    %ebx
  8035c9:	5e                   	pop    %esi
  8035ca:	5f                   	pop    %edi
  8035cb:	5d                   	pop    %ebp
  8035cc:	c3                   	ret    
  8035cd:	8d 76 00             	lea    0x0(%esi),%esi
  8035d0:	31 ff                	xor    %edi,%edi
  8035d2:	31 c0                	xor    %eax,%eax
  8035d4:	89 fa                	mov    %edi,%edx
  8035d6:	83 c4 1c             	add    $0x1c,%esp
  8035d9:	5b                   	pop    %ebx
  8035da:	5e                   	pop    %esi
  8035db:	5f                   	pop    %edi
  8035dc:	5d                   	pop    %ebp
  8035dd:	c3                   	ret    
  8035de:	66 90                	xchg   %ax,%ax
  8035e0:	89 d8                	mov    %ebx,%eax
  8035e2:	f7 f7                	div    %edi
  8035e4:	31 ff                	xor    %edi,%edi
  8035e6:	89 fa                	mov    %edi,%edx
  8035e8:	83 c4 1c             	add    $0x1c,%esp
  8035eb:	5b                   	pop    %ebx
  8035ec:	5e                   	pop    %esi
  8035ed:	5f                   	pop    %edi
  8035ee:	5d                   	pop    %ebp
  8035ef:	c3                   	ret    
  8035f0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8035f5:	89 eb                	mov    %ebp,%ebx
  8035f7:	29 fb                	sub    %edi,%ebx
  8035f9:	89 f9                	mov    %edi,%ecx
  8035fb:	d3 e6                	shl    %cl,%esi
  8035fd:	89 c5                	mov    %eax,%ebp
  8035ff:	88 d9                	mov    %bl,%cl
  803601:	d3 ed                	shr    %cl,%ebp
  803603:	89 e9                	mov    %ebp,%ecx
  803605:	09 f1                	or     %esi,%ecx
  803607:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80360b:	89 f9                	mov    %edi,%ecx
  80360d:	d3 e0                	shl    %cl,%eax
  80360f:	89 c5                	mov    %eax,%ebp
  803611:	89 d6                	mov    %edx,%esi
  803613:	88 d9                	mov    %bl,%cl
  803615:	d3 ee                	shr    %cl,%esi
  803617:	89 f9                	mov    %edi,%ecx
  803619:	d3 e2                	shl    %cl,%edx
  80361b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80361f:	88 d9                	mov    %bl,%cl
  803621:	d3 e8                	shr    %cl,%eax
  803623:	09 c2                	or     %eax,%edx
  803625:	89 d0                	mov    %edx,%eax
  803627:	89 f2                	mov    %esi,%edx
  803629:	f7 74 24 0c          	divl   0xc(%esp)
  80362d:	89 d6                	mov    %edx,%esi
  80362f:	89 c3                	mov    %eax,%ebx
  803631:	f7 e5                	mul    %ebp
  803633:	39 d6                	cmp    %edx,%esi
  803635:	72 19                	jb     803650 <__udivdi3+0xfc>
  803637:	74 0b                	je     803644 <__udivdi3+0xf0>
  803639:	89 d8                	mov    %ebx,%eax
  80363b:	31 ff                	xor    %edi,%edi
  80363d:	e9 58 ff ff ff       	jmp    80359a <__udivdi3+0x46>
  803642:	66 90                	xchg   %ax,%ax
  803644:	8b 54 24 08          	mov    0x8(%esp),%edx
  803648:	89 f9                	mov    %edi,%ecx
  80364a:	d3 e2                	shl    %cl,%edx
  80364c:	39 c2                	cmp    %eax,%edx
  80364e:	73 e9                	jae    803639 <__udivdi3+0xe5>
  803650:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803653:	31 ff                	xor    %edi,%edi
  803655:	e9 40 ff ff ff       	jmp    80359a <__udivdi3+0x46>
  80365a:	66 90                	xchg   %ax,%ax
  80365c:	31 c0                	xor    %eax,%eax
  80365e:	e9 37 ff ff ff       	jmp    80359a <__udivdi3+0x46>
  803663:	90                   	nop

00803664 <__umoddi3>:
  803664:	55                   	push   %ebp
  803665:	57                   	push   %edi
  803666:	56                   	push   %esi
  803667:	53                   	push   %ebx
  803668:	83 ec 1c             	sub    $0x1c,%esp
  80366b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80366f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803673:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803677:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80367b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80367f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803683:	89 f3                	mov    %esi,%ebx
  803685:	89 fa                	mov    %edi,%edx
  803687:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80368b:	89 34 24             	mov    %esi,(%esp)
  80368e:	85 c0                	test   %eax,%eax
  803690:	75 1a                	jne    8036ac <__umoddi3+0x48>
  803692:	39 f7                	cmp    %esi,%edi
  803694:	0f 86 a2 00 00 00    	jbe    80373c <__umoddi3+0xd8>
  80369a:	89 c8                	mov    %ecx,%eax
  80369c:	89 f2                	mov    %esi,%edx
  80369e:	f7 f7                	div    %edi
  8036a0:	89 d0                	mov    %edx,%eax
  8036a2:	31 d2                	xor    %edx,%edx
  8036a4:	83 c4 1c             	add    $0x1c,%esp
  8036a7:	5b                   	pop    %ebx
  8036a8:	5e                   	pop    %esi
  8036a9:	5f                   	pop    %edi
  8036aa:	5d                   	pop    %ebp
  8036ab:	c3                   	ret    
  8036ac:	39 f0                	cmp    %esi,%eax
  8036ae:	0f 87 ac 00 00 00    	ja     803760 <__umoddi3+0xfc>
  8036b4:	0f bd e8             	bsr    %eax,%ebp
  8036b7:	83 f5 1f             	xor    $0x1f,%ebp
  8036ba:	0f 84 ac 00 00 00    	je     80376c <__umoddi3+0x108>
  8036c0:	bf 20 00 00 00       	mov    $0x20,%edi
  8036c5:	29 ef                	sub    %ebp,%edi
  8036c7:	89 fe                	mov    %edi,%esi
  8036c9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8036cd:	89 e9                	mov    %ebp,%ecx
  8036cf:	d3 e0                	shl    %cl,%eax
  8036d1:	89 d7                	mov    %edx,%edi
  8036d3:	89 f1                	mov    %esi,%ecx
  8036d5:	d3 ef                	shr    %cl,%edi
  8036d7:	09 c7                	or     %eax,%edi
  8036d9:	89 e9                	mov    %ebp,%ecx
  8036db:	d3 e2                	shl    %cl,%edx
  8036dd:	89 14 24             	mov    %edx,(%esp)
  8036e0:	89 d8                	mov    %ebx,%eax
  8036e2:	d3 e0                	shl    %cl,%eax
  8036e4:	89 c2                	mov    %eax,%edx
  8036e6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036ea:	d3 e0                	shl    %cl,%eax
  8036ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8036f0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8036f4:	89 f1                	mov    %esi,%ecx
  8036f6:	d3 e8                	shr    %cl,%eax
  8036f8:	09 d0                	or     %edx,%eax
  8036fa:	d3 eb                	shr    %cl,%ebx
  8036fc:	89 da                	mov    %ebx,%edx
  8036fe:	f7 f7                	div    %edi
  803700:	89 d3                	mov    %edx,%ebx
  803702:	f7 24 24             	mull   (%esp)
  803705:	89 c6                	mov    %eax,%esi
  803707:	89 d1                	mov    %edx,%ecx
  803709:	39 d3                	cmp    %edx,%ebx
  80370b:	0f 82 87 00 00 00    	jb     803798 <__umoddi3+0x134>
  803711:	0f 84 91 00 00 00    	je     8037a8 <__umoddi3+0x144>
  803717:	8b 54 24 04          	mov    0x4(%esp),%edx
  80371b:	29 f2                	sub    %esi,%edx
  80371d:	19 cb                	sbb    %ecx,%ebx
  80371f:	89 d8                	mov    %ebx,%eax
  803721:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803725:	d3 e0                	shl    %cl,%eax
  803727:	89 e9                	mov    %ebp,%ecx
  803729:	d3 ea                	shr    %cl,%edx
  80372b:	09 d0                	or     %edx,%eax
  80372d:	89 e9                	mov    %ebp,%ecx
  80372f:	d3 eb                	shr    %cl,%ebx
  803731:	89 da                	mov    %ebx,%edx
  803733:	83 c4 1c             	add    $0x1c,%esp
  803736:	5b                   	pop    %ebx
  803737:	5e                   	pop    %esi
  803738:	5f                   	pop    %edi
  803739:	5d                   	pop    %ebp
  80373a:	c3                   	ret    
  80373b:	90                   	nop
  80373c:	89 fd                	mov    %edi,%ebp
  80373e:	85 ff                	test   %edi,%edi
  803740:	75 0b                	jne    80374d <__umoddi3+0xe9>
  803742:	b8 01 00 00 00       	mov    $0x1,%eax
  803747:	31 d2                	xor    %edx,%edx
  803749:	f7 f7                	div    %edi
  80374b:	89 c5                	mov    %eax,%ebp
  80374d:	89 f0                	mov    %esi,%eax
  80374f:	31 d2                	xor    %edx,%edx
  803751:	f7 f5                	div    %ebp
  803753:	89 c8                	mov    %ecx,%eax
  803755:	f7 f5                	div    %ebp
  803757:	89 d0                	mov    %edx,%eax
  803759:	e9 44 ff ff ff       	jmp    8036a2 <__umoddi3+0x3e>
  80375e:	66 90                	xchg   %ax,%ax
  803760:	89 c8                	mov    %ecx,%eax
  803762:	89 f2                	mov    %esi,%edx
  803764:	83 c4 1c             	add    $0x1c,%esp
  803767:	5b                   	pop    %ebx
  803768:	5e                   	pop    %esi
  803769:	5f                   	pop    %edi
  80376a:	5d                   	pop    %ebp
  80376b:	c3                   	ret    
  80376c:	3b 04 24             	cmp    (%esp),%eax
  80376f:	72 06                	jb     803777 <__umoddi3+0x113>
  803771:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803775:	77 0f                	ja     803786 <__umoddi3+0x122>
  803777:	89 f2                	mov    %esi,%edx
  803779:	29 f9                	sub    %edi,%ecx
  80377b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80377f:	89 14 24             	mov    %edx,(%esp)
  803782:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803786:	8b 44 24 04          	mov    0x4(%esp),%eax
  80378a:	8b 14 24             	mov    (%esp),%edx
  80378d:	83 c4 1c             	add    $0x1c,%esp
  803790:	5b                   	pop    %ebx
  803791:	5e                   	pop    %esi
  803792:	5f                   	pop    %edi
  803793:	5d                   	pop    %ebp
  803794:	c3                   	ret    
  803795:	8d 76 00             	lea    0x0(%esi),%esi
  803798:	2b 04 24             	sub    (%esp),%eax
  80379b:	19 fa                	sbb    %edi,%edx
  80379d:	89 d1                	mov    %edx,%ecx
  80379f:	89 c6                	mov    %eax,%esi
  8037a1:	e9 71 ff ff ff       	jmp    803717 <__umoddi3+0xb3>
  8037a6:	66 90                	xchg   %ax,%ax
  8037a8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037ac:	72 ea                	jb     803798 <__umoddi3+0x134>
  8037ae:	89 d9                	mov    %ebx,%ecx
  8037b0:	e9 62 ff ff ff       	jmp    803717 <__umoddi3+0xb3>
