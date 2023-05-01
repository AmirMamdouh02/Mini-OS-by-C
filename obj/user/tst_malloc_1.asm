
obj/user/tst_malloc_1:     file format elf32-i386


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
  800031:	e8 6f 05 00 00       	call   8005a5 <libmain>
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
  80003c:	83 ec 74             	sub    $0x74,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 50 80 00       	mov    0x805020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 50 80 00       	mov    0x805020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 00 37 80 00       	push   $0x803700
  800092:	6a 14                	push   $0x14
  800094:	68 1c 37 80 00       	push   $0x80371c
  800099:	e8 43 06 00 00       	call   8006e1 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 8c 18 00 00       	call   801934 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/


	int Mega = 1024*1024;
  8000ab:	c7 45 ec 00 00 10 00 	movl   $0x100000,-0x14(%ebp)
	int kilo = 1024;
  8000b2:	c7 45 e8 00 04 00 00 	movl   $0x400,-0x18(%ebp)
	//int sizeOfMemBlocksArray = ROUNDUP(((USER_HEAP_MAX-USER_HEAP_START)/PAGE_SIZE) * sizeof(struct MemBlock), PAGE_SIZE) ;
	void* ptr_allocations[20] = {0};
  8000b9:	8d 55 90             	lea    -0x70(%ebp),%edx
  8000bc:	b9 14 00 00 00       	mov    $0x14,%ecx
  8000c1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000c6:	89 d7                	mov    %edx,%edi
  8000c8:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 03 1d 00 00       	call   801dd2 <sys_calculate_free_frames>
  8000cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000d2:	e8 9b 1d 00 00       	call   801e72 <sys_pf_calculate_allocated_pages>
  8000d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8000da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000dd:	01 c0                	add    %eax,%eax
  8000df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	50                   	push   %eax
  8000e6:	e8 49 18 00 00       	call   801934 <malloc>
  8000eb:	83 c4 10             	add    $0x10,%esp
  8000ee:	89 45 90             	mov    %eax,-0x70(%ebp)
		if ((uint32) ptr_allocations[0] <  (USER_HEAP_START) || (uint32) ptr_allocations[0] > (USER_HEAP_START + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8000f1:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000f4:	85 c0                	test   %eax,%eax
  8000f6:	79 0a                	jns    800102 <_main+0xca>
  8000f8:	8b 45 90             	mov    -0x70(%ebp),%eax
  8000fb:	3d 00 10 00 80       	cmp    $0x80001000,%eax
  800100:	76 14                	jbe    800116 <_main+0xde>
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	68 30 37 80 00       	push   $0x803730
  80010a:	6a 23                	push   $0x23
  80010c:	68 1c 37 80 00       	push   $0x80371c
  800111:	e8 cb 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512+1 ) panic("Wrong allocation: ");
		//cprintf("freeFrames - sys_calculate_free_frames() = %d\n", freeFrames - sys_calculate_free_frames()) ;
		//cprintf("Expected = %d\n", (1 + sizeOfMemBlocksArray/PAGE_SIZE));
		if ((freeFrames - sys_calculate_free_frames()) != 0) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800116:	e8 b7 1c 00 00       	call   801dd2 <sys_calculate_free_frames>
  80011b:	89 c2                	mov    %eax,%edx
  80011d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800120:	39 c2                	cmp    %eax,%edx
  800122:	74 14                	je     800138 <_main+0x100>
  800124:	83 ec 04             	sub    $0x4,%esp
  800127:	68 60 37 80 00       	push   $0x803760
  80012c:	6a 27                	push   $0x27
  80012e:	68 1c 37 80 00       	push   $0x80371c
  800133:	e8 a9 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800138:	e8 35 1d 00 00       	call   801e72 <sys_pf_calculate_allocated_pages>
  80013d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800140:	74 14                	je     800156 <_main+0x11e>
  800142:	83 ec 04             	sub    $0x4,%esp
  800145:	68 cc 37 80 00       	push   $0x8037cc
  80014a:	6a 28                	push   $0x28
  80014c:	68 1c 37 80 00       	push   $0x80371c
  800151:	e8 8b 05 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800156:	e8 77 1c 00 00       	call   801dd2 <sys_calculate_free_frames>
  80015b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80015e:	e8 0f 1d 00 00       	call   801e72 <sys_pf_calculate_allocated_pages>
  800163:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800169:	01 c0                	add    %eax,%eax
  80016b:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	50                   	push   %eax
  800172:	e8 bd 17 00 00       	call   801934 <malloc>
  800177:	83 c4 10             	add    $0x10,%esp
  80017a:	89 45 94             	mov    %eax,-0x6c(%ebp)
		if ((uint32) ptr_allocations[1] < (USER_HEAP_START + 2*Mega) || (uint32) ptr_allocations[1] > (USER_HEAP_START + 2*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80017d:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800180:	89 c2                	mov    %eax,%edx
  800182:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800185:	01 c0                	add    %eax,%eax
  800187:	05 00 00 00 80       	add    $0x80000000,%eax
  80018c:	39 c2                	cmp    %eax,%edx
  80018e:	72 13                	jb     8001a3 <_main+0x16b>
  800190:	8b 45 94             	mov    -0x6c(%ebp),%eax
  800193:	89 c2                	mov    %eax,%edx
  800195:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800198:	01 c0                	add    %eax,%eax
  80019a:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  80019f:	39 c2                	cmp    %eax,%edx
  8001a1:	76 14                	jbe    8001b7 <_main+0x17f>
  8001a3:	83 ec 04             	sub    $0x4,%esp
  8001a6:	68 30 37 80 00       	push   $0x803730
  8001ab:	6a 2d                	push   $0x2d
  8001ad:	68 1c 37 80 00       	push   $0x80371c
  8001b2:	e8 2a 05 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 512 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8001b7:	e8 16 1c 00 00       	call   801dd2 <sys_calculate_free_frames>
  8001bc:	89 c2                	mov    %eax,%edx
  8001be:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001c1:	39 c2                	cmp    %eax,%edx
  8001c3:	74 14                	je     8001d9 <_main+0x1a1>
  8001c5:	83 ec 04             	sub    $0x4,%esp
  8001c8:	68 60 37 80 00       	push   $0x803760
  8001cd:	6a 2f                	push   $0x2f
  8001cf:	68 1c 37 80 00       	push   $0x80371c
  8001d4:	e8 08 05 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8001d9:	e8 94 1c 00 00       	call   801e72 <sys_pf_calculate_allocated_pages>
  8001de:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 cc 37 80 00       	push   $0x8037cc
  8001eb:	6a 30                	push   $0x30
  8001ed:	68 1c 37 80 00       	push   $0x80371c
  8001f2:	e8 ea 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8001f7:	e8 d6 1b 00 00       	call   801dd2 <sys_calculate_free_frames>
  8001fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8001ff:	e8 6e 1c 00 00       	call   801e72 <sys_pf_calculate_allocated_pages>
  800204:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[2] = malloc(3*kilo);
  800207:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80020a:	89 c2                	mov    %eax,%edx
  80020c:	01 d2                	add    %edx,%edx
  80020e:	01 d0                	add    %edx,%eax
  800210:	83 ec 0c             	sub    $0xc,%esp
  800213:	50                   	push   %eax
  800214:	e8 1b 17 00 00       	call   801934 <malloc>
  800219:	83 c4 10             	add    $0x10,%esp
  80021c:	89 45 98             	mov    %eax,-0x68(%ebp)
		if ((uint32) ptr_allocations[2] < (USER_HEAP_START + 4*Mega) || (uint32) ptr_allocations[2] > (USER_HEAP_START + 4*Mega + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80021f:	8b 45 98             	mov    -0x68(%ebp),%eax
  800222:	89 c2                	mov    %eax,%edx
  800224:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800227:	c1 e0 02             	shl    $0x2,%eax
  80022a:	05 00 00 00 80       	add    $0x80000000,%eax
  80022f:	39 c2                	cmp    %eax,%edx
  800231:	72 14                	jb     800247 <_main+0x20f>
  800233:	8b 45 98             	mov    -0x68(%ebp),%eax
  800236:	89 c2                	mov    %eax,%edx
  800238:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80023b:	c1 e0 02             	shl    $0x2,%eax
  80023e:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800243:	39 c2                	cmp    %eax,%edx
  800245:	76 14                	jbe    80025b <_main+0x223>
  800247:	83 ec 04             	sub    $0x4,%esp
  80024a:	68 30 37 80 00       	push   $0x803730
  80024f:	6a 35                	push   $0x35
  800251:	68 1c 37 80 00       	push   $0x80371c
  800256:	e8 86 04 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1+1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  80025b:	e8 72 1b 00 00       	call   801dd2 <sys_calculate_free_frames>
  800260:	89 c2                	mov    %eax,%edx
  800262:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800265:	39 c2                	cmp    %eax,%edx
  800267:	74 14                	je     80027d <_main+0x245>
  800269:	83 ec 04             	sub    $0x4,%esp
  80026c:	68 60 37 80 00       	push   $0x803760
  800271:	6a 37                	push   $0x37
  800273:	68 1c 37 80 00       	push   $0x80371c
  800278:	e8 64 04 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  80027d:	e8 f0 1b 00 00       	call   801e72 <sys_pf_calculate_allocated_pages>
  800282:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800285:	74 14                	je     80029b <_main+0x263>
  800287:	83 ec 04             	sub    $0x4,%esp
  80028a:	68 cc 37 80 00       	push   $0x8037cc
  80028f:	6a 38                	push   $0x38
  800291:	68 1c 37 80 00       	push   $0x80371c
  800296:	e8 46 04 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80029b:	e8 32 1b 00 00       	call   801dd2 <sys_calculate_free_frames>
  8002a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8002a3:	e8 ca 1b 00 00       	call   801e72 <sys_pf_calculate_allocated_pages>
  8002a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[3] = malloc(3*kilo);
  8002ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ae:	89 c2                	mov    %eax,%edx
  8002b0:	01 d2                	add    %edx,%edx
  8002b2:	01 d0                	add    %edx,%eax
  8002b4:	83 ec 0c             	sub    $0xc,%esp
  8002b7:	50                   	push   %eax
  8002b8:	e8 77 16 00 00       	call   801934 <malloc>
  8002bd:	83 c4 10             	add    $0x10,%esp
  8002c0:	89 45 9c             	mov    %eax,-0x64(%ebp)
		if ((uint32) ptr_allocations[3] < (USER_HEAP_START + 4*Mega + 4*kilo) || (uint32) ptr_allocations[3] > (USER_HEAP_START + 4*Mega + 4*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8002c3:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002c6:	89 c2                	mov    %eax,%edx
  8002c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cb:	c1 e0 02             	shl    $0x2,%eax
  8002ce:	89 c1                	mov    %eax,%ecx
  8002d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002d3:	c1 e0 02             	shl    $0x2,%eax
  8002d6:	01 c8                	add    %ecx,%eax
  8002d8:	05 00 00 00 80       	add    $0x80000000,%eax
  8002dd:	39 c2                	cmp    %eax,%edx
  8002df:	72 1e                	jb     8002ff <_main+0x2c7>
  8002e1:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8002e4:	89 c2                	mov    %eax,%edx
  8002e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002e9:	c1 e0 02             	shl    $0x2,%eax
  8002ec:	89 c1                	mov    %eax,%ecx
  8002ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002f1:	c1 e0 02             	shl    $0x2,%eax
  8002f4:	01 c8                	add    %ecx,%eax
  8002f6:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8002fb:	39 c2                	cmp    %eax,%edx
  8002fd:	76 14                	jbe    800313 <_main+0x2db>
  8002ff:	83 ec 04             	sub    $0x4,%esp
  800302:	68 30 37 80 00       	push   $0x803730
  800307:	6a 3d                	push   $0x3d
  800309:	68 1c 37 80 00       	push   $0x80371c
  80030e:	e8 ce 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 1 ) panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  800313:	e8 ba 1a 00 00       	call   801dd2 <sys_calculate_free_frames>
  800318:	89 c2                	mov    %eax,%edx
  80031a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80031d:	39 c2                	cmp    %eax,%edx
  80031f:	74 14                	je     800335 <_main+0x2fd>
  800321:	83 ec 04             	sub    $0x4,%esp
  800324:	68 60 37 80 00       	push   $0x803760
  800329:	6a 3f                	push   $0x3f
  80032b:	68 1c 37 80 00       	push   $0x80371c
  800330:	e8 ac 03 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800335:	e8 38 1b 00 00       	call   801e72 <sys_pf_calculate_allocated_pages>
  80033a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  80033d:	74 14                	je     800353 <_main+0x31b>
  80033f:	83 ec 04             	sub    $0x4,%esp
  800342:	68 cc 37 80 00       	push   $0x8037cc
  800347:	6a 40                	push   $0x40
  800349:	68 1c 37 80 00       	push   $0x80371c
  80034e:	e8 8e 03 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  800353:	e8 7a 1a 00 00       	call   801dd2 <sys_calculate_free_frames>
  800358:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80035b:	e8 12 1b 00 00       	call   801e72 <sys_pf_calculate_allocated_pages>
  800360:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[4] = malloc(7*kilo);
  800363:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800366:	89 d0                	mov    %edx,%eax
  800368:	01 c0                	add    %eax,%eax
  80036a:	01 d0                	add    %edx,%eax
  80036c:	01 c0                	add    %eax,%eax
  80036e:	01 d0                	add    %edx,%eax
  800370:	83 ec 0c             	sub    $0xc,%esp
  800373:	50                   	push   %eax
  800374:	e8 bb 15 00 00       	call   801934 <malloc>
  800379:	83 c4 10             	add    $0x10,%esp
  80037c:	89 45 a0             	mov    %eax,-0x60(%ebp)
		if ((uint32) ptr_allocations[4] < (USER_HEAP_START + 4*Mega + 8*kilo) || (uint32) ptr_allocations[4] > (USER_HEAP_START + 4*Mega + 8*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80037f:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800382:	89 c2                	mov    %eax,%edx
  800384:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800387:	c1 e0 02             	shl    $0x2,%eax
  80038a:	89 c1                	mov    %eax,%ecx
  80038c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80038f:	c1 e0 03             	shl    $0x3,%eax
  800392:	01 c8                	add    %ecx,%eax
  800394:	05 00 00 00 80       	add    $0x80000000,%eax
  800399:	39 c2                	cmp    %eax,%edx
  80039b:	72 1e                	jb     8003bb <_main+0x383>
  80039d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8003a0:	89 c2                	mov    %eax,%edx
  8003a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8003a5:	c1 e0 02             	shl    $0x2,%eax
  8003a8:	89 c1                	mov    %eax,%ecx
  8003aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ad:	c1 e0 03             	shl    $0x3,%eax
  8003b0:	01 c8                	add    %ecx,%eax
  8003b2:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  8003b7:	39 c2                	cmp    %eax,%edx
  8003b9:	76 14                	jbe    8003cf <_main+0x397>
  8003bb:	83 ec 04             	sub    $0x4,%esp
  8003be:	68 30 37 80 00       	push   $0x803730
  8003c3:	6a 45                	push   $0x45
  8003c5:	68 1c 37 80 00       	push   $0x80371c
  8003ca:	e8 12 03 00 00       	call   8006e1 <_panic>
		//		if ((freeFrames - sys_calculate_free_frames()) != 2)panic("Wrong allocation: ");
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: either extra pages are allocated in memory or pages not allocated correctly on PageFile");
  8003cf:	e8 fe 19 00 00       	call   801dd2 <sys_calculate_free_frames>
  8003d4:	89 c2                	mov    %eax,%edx
  8003d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003d9:	39 c2                	cmp    %eax,%edx
  8003db:	74 14                	je     8003f1 <_main+0x3b9>
  8003dd:	83 ec 04             	sub    $0x4,%esp
  8003e0:	68 60 37 80 00       	push   $0x803760
  8003e5:	6a 47                	push   $0x47
  8003e7:	68 1c 37 80 00       	push   $0x80371c
  8003ec:	e8 f0 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8003f1:	e8 7c 1a 00 00       	call   801e72 <sys_pf_calculate_allocated_pages>
  8003f6:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8003f9:	74 14                	je     80040f <_main+0x3d7>
  8003fb:	83 ec 04             	sub    $0x4,%esp
  8003fe:	68 cc 37 80 00       	push   $0x8037cc
  800403:	6a 48                	push   $0x48
  800405:	68 1c 37 80 00       	push   $0x80371c
  80040a:	e8 d2 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  80040f:	e8 be 19 00 00       	call   801dd2 <sys_calculate_free_frames>
  800414:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800417:	e8 56 1a 00 00       	call   801e72 <sys_pf_calculate_allocated_pages>
  80041c:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[5] = malloc(3*Mega-kilo);
  80041f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800422:	89 c2                	mov    %eax,%edx
  800424:	01 d2                	add    %edx,%edx
  800426:	01 d0                	add    %edx,%eax
  800428:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80042b:	83 ec 0c             	sub    $0xc,%esp
  80042e:	50                   	push   %eax
  80042f:	e8 00 15 00 00       	call   801934 <malloc>
  800434:	83 c4 10             	add    $0x10,%esp
  800437:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		if ((uint32) ptr_allocations[5] < (USER_HEAP_START + 4*Mega + 16*kilo) || (uint32) ptr_allocations[5] > (USER_HEAP_START + 4*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  80043a:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80043d:	89 c2                	mov    %eax,%edx
  80043f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800442:	c1 e0 02             	shl    $0x2,%eax
  800445:	89 c1                	mov    %eax,%ecx
  800447:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044a:	c1 e0 04             	shl    $0x4,%eax
  80044d:	01 c8                	add    %ecx,%eax
  80044f:	05 00 00 00 80       	add    $0x80000000,%eax
  800454:	39 c2                	cmp    %eax,%edx
  800456:	72 1e                	jb     800476 <_main+0x43e>
  800458:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  80045b:	89 c2                	mov    %eax,%edx
  80045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800460:	c1 e0 02             	shl    $0x2,%eax
  800463:	89 c1                	mov    %eax,%ecx
  800465:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800468:	c1 e0 04             	shl    $0x4,%eax
  80046b:	01 c8                	add    %ecx,%eax
  80046d:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800472:	39 c2                	cmp    %eax,%edx
  800474:	76 14                	jbe    80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 30 37 80 00       	push   $0x803730
  80047e:	6a 4d                	push   $0x4d
  800480:	68 1c 37 80 00       	push   $0x80371c
  800485:	e8 57 02 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80048a:	e8 43 19 00 00       	call   801dd2 <sys_calculate_free_frames>
  80048f:	89 c2                	mov    %eax,%edx
  800491:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800494:	39 c2                	cmp    %eax,%edx
  800496:	74 14                	je     8004ac <_main+0x474>
  800498:	83 ec 04             	sub    $0x4,%esp
  80049b:	68 fa 37 80 00       	push   $0x8037fa
  8004a0:	6a 4e                	push   $0x4e
  8004a2:	68 1c 37 80 00       	push   $0x80371c
  8004a7:	e8 35 02 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  8004ac:	e8 c1 19 00 00       	call   801e72 <sys_pf_calculate_allocated_pages>
  8004b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004b4:	74 14                	je     8004ca <_main+0x492>
  8004b6:	83 ec 04             	sub    $0x4,%esp
  8004b9:	68 cc 37 80 00       	push   $0x8037cc
  8004be:	6a 4f                	push   $0x4f
  8004c0:	68 1c 37 80 00       	push   $0x80371c
  8004c5:	e8 17 02 00 00       	call   8006e1 <_panic>

		freeFrames = sys_calculate_free_frames() ;
  8004ca:	e8 03 19 00 00       	call   801dd2 <sys_calculate_free_frames>
  8004cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8004d2:	e8 9b 19 00 00       	call   801e72 <sys_pf_calculate_allocated_pages>
  8004d7:	89 45 e0             	mov    %eax,-0x20(%ebp)
		ptr_allocations[6] = malloc(2*Mega-kilo);
  8004da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8004dd:	01 c0                	add    %eax,%eax
  8004df:	2b 45 e8             	sub    -0x18(%ebp),%eax
  8004e2:	83 ec 0c             	sub    $0xc,%esp
  8004e5:	50                   	push   %eax
  8004e6:	e8 49 14 00 00       	call   801934 <malloc>
  8004eb:	83 c4 10             	add    $0x10,%esp
  8004ee:	89 45 a8             	mov    %eax,-0x58(%ebp)
		if ((uint32) ptr_allocations[6] < (USER_HEAP_START + 7*Mega + 16*kilo) || (uint32) ptr_allocations[6] > (USER_HEAP_START + 7*Mega + 16*kilo + PAGE_SIZE)) panic("Wrong start address for the allocated space... ");
  8004f1:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004f4:	89 c1                	mov    %eax,%ecx
  8004f6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004f9:	89 d0                	mov    %edx,%eax
  8004fb:	01 c0                	add    %eax,%eax
  8004fd:	01 d0                	add    %edx,%eax
  8004ff:	01 c0                	add    %eax,%eax
  800501:	01 d0                	add    %edx,%eax
  800503:	89 c2                	mov    %eax,%edx
  800505:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800508:	c1 e0 04             	shl    $0x4,%eax
  80050b:	01 d0                	add    %edx,%eax
  80050d:	05 00 00 00 80       	add    $0x80000000,%eax
  800512:	39 c1                	cmp    %eax,%ecx
  800514:	72 25                	jb     80053b <_main+0x503>
  800516:	8b 45 a8             	mov    -0x58(%ebp),%eax
  800519:	89 c1                	mov    %eax,%ecx
  80051b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80051e:	89 d0                	mov    %edx,%eax
  800520:	01 c0                	add    %eax,%eax
  800522:	01 d0                	add    %edx,%eax
  800524:	01 c0                	add    %eax,%eax
  800526:	01 d0                	add    %edx,%eax
  800528:	89 c2                	mov    %eax,%edx
  80052a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80052d:	c1 e0 04             	shl    $0x4,%eax
  800530:	01 d0                	add    %edx,%eax
  800532:	2d 00 f0 ff 7f       	sub    $0x7ffff000,%eax
  800537:	39 c1                	cmp    %eax,%ecx
  800539:	76 14                	jbe    80054f <_main+0x517>
  80053b:	83 ec 04             	sub    $0x4,%esp
  80053e:	68 30 37 80 00       	push   $0x803730
  800543:	6a 54                	push   $0x54
  800545:	68 1c 37 80 00       	push   $0x80371c
  80054a:	e8 92 01 00 00       	call   8006e1 <_panic>
		if ((freeFrames - sys_calculate_free_frames()) != 0 ) panic("Wrong allocation: ");
  80054f:	e8 7e 18 00 00       	call   801dd2 <sys_calculate_free_frames>
  800554:	89 c2                	mov    %eax,%edx
  800556:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800559:	39 c2                	cmp    %eax,%edx
  80055b:	74 14                	je     800571 <_main+0x539>
  80055d:	83 ec 04             	sub    $0x4,%esp
  800560:	68 fa 37 80 00       	push   $0x8037fa
  800565:	6a 55                	push   $0x55
  800567:	68 1c 37 80 00       	push   $0x80371c
  80056c:	e8 70 01 00 00       	call   8006e1 <_panic>
		if ((sys_pf_calculate_allocated_pages() - usedDiskPages) != 0) panic("Extra or less pages are allocated in PageFile");
  800571:	e8 fc 18 00 00       	call   801e72 <sys_pf_calculate_allocated_pages>
  800576:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800579:	74 14                	je     80058f <_main+0x557>
  80057b:	83 ec 04             	sub    $0x4,%esp
  80057e:	68 cc 37 80 00       	push   $0x8037cc
  800583:	6a 56                	push   $0x56
  800585:	68 1c 37 80 00       	push   $0x80371c
  80058a:	e8 52 01 00 00       	call   8006e1 <_panic>
	}

	cprintf("Congratulations!! test malloc (1) completed successfully.\n");
  80058f:	83 ec 0c             	sub    $0xc,%esp
  800592:	68 10 38 80 00       	push   $0x803810
  800597:	e8 f9 03 00 00       	call   800995 <cprintf>
  80059c:	83 c4 10             	add    $0x10,%esp

	return;
  80059f:	90                   	nop
}
  8005a0:	8b 7d fc             	mov    -0x4(%ebp),%edi
  8005a3:	c9                   	leave  
  8005a4:	c3                   	ret    

008005a5 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005a5:	55                   	push   %ebp
  8005a6:	89 e5                	mov    %esp,%ebp
  8005a8:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005ab:	e8 02 1b 00 00       	call   8020b2 <sys_getenvindex>
  8005b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005b6:	89 d0                	mov    %edx,%eax
  8005b8:	c1 e0 03             	shl    $0x3,%eax
  8005bb:	01 d0                	add    %edx,%eax
  8005bd:	01 c0                	add    %eax,%eax
  8005bf:	01 d0                	add    %edx,%eax
  8005c1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005c8:	01 d0                	add    %edx,%eax
  8005ca:	c1 e0 04             	shl    $0x4,%eax
  8005cd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005d2:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005d7:	a1 20 50 80 00       	mov    0x805020,%eax
  8005dc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8005e2:	84 c0                	test   %al,%al
  8005e4:	74 0f                	je     8005f5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8005e6:	a1 20 50 80 00       	mov    0x805020,%eax
  8005eb:	05 5c 05 00 00       	add    $0x55c,%eax
  8005f0:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8005f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8005f9:	7e 0a                	jle    800605 <libmain+0x60>
		binaryname = argv[0];
  8005fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005fe:	8b 00                	mov    (%eax),%eax
  800600:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 08             	pushl  0x8(%ebp)
  80060e:	e8 25 fa ff ff       	call   800038 <_main>
  800613:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800616:	e8 a4 18 00 00       	call   801ebf <sys_disable_interrupt>
	cprintf("**************************************\n");
  80061b:	83 ec 0c             	sub    $0xc,%esp
  80061e:	68 64 38 80 00       	push   $0x803864
  800623:	e8 6d 03 00 00       	call   800995 <cprintf>
  800628:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80062b:	a1 20 50 80 00       	mov    0x805020,%eax
  800630:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800636:	a1 20 50 80 00       	mov    0x805020,%eax
  80063b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	52                   	push   %edx
  800645:	50                   	push   %eax
  800646:	68 8c 38 80 00       	push   $0x80388c
  80064b:	e8 45 03 00 00       	call   800995 <cprintf>
  800650:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800653:	a1 20 50 80 00       	mov    0x805020,%eax
  800658:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80065e:	a1 20 50 80 00       	mov    0x805020,%eax
  800663:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800669:	a1 20 50 80 00       	mov    0x805020,%eax
  80066e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800674:	51                   	push   %ecx
  800675:	52                   	push   %edx
  800676:	50                   	push   %eax
  800677:	68 b4 38 80 00       	push   $0x8038b4
  80067c:	e8 14 03 00 00       	call   800995 <cprintf>
  800681:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800684:	a1 20 50 80 00       	mov    0x805020,%eax
  800689:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80068f:	83 ec 08             	sub    $0x8,%esp
  800692:	50                   	push   %eax
  800693:	68 0c 39 80 00       	push   $0x80390c
  800698:	e8 f8 02 00 00       	call   800995 <cprintf>
  80069d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006a0:	83 ec 0c             	sub    $0xc,%esp
  8006a3:	68 64 38 80 00       	push   $0x803864
  8006a8:	e8 e8 02 00 00       	call   800995 <cprintf>
  8006ad:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006b0:	e8 24 18 00 00       	call   801ed9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006b5:	e8 19 00 00 00       	call   8006d3 <exit>
}
  8006ba:	90                   	nop
  8006bb:	c9                   	leave  
  8006bc:	c3                   	ret    

008006bd <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006bd:	55                   	push   %ebp
  8006be:	89 e5                	mov    %esp,%ebp
  8006c0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006c3:	83 ec 0c             	sub    $0xc,%esp
  8006c6:	6a 00                	push   $0x0
  8006c8:	e8 b1 19 00 00       	call   80207e <sys_destroy_env>
  8006cd:	83 c4 10             	add    $0x10,%esp
}
  8006d0:	90                   	nop
  8006d1:	c9                   	leave  
  8006d2:	c3                   	ret    

008006d3 <exit>:

void
exit(void)
{
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006d9:	e8 06 1a 00 00       	call   8020e4 <sys_exit_env>
}
  8006de:	90                   	nop
  8006df:	c9                   	leave  
  8006e0:	c3                   	ret    

008006e1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8006e1:	55                   	push   %ebp
  8006e2:	89 e5                	mov    %esp,%ebp
  8006e4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8006e7:	8d 45 10             	lea    0x10(%ebp),%eax
  8006ea:	83 c0 04             	add    $0x4,%eax
  8006ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8006f0:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006f5:	85 c0                	test   %eax,%eax
  8006f7:	74 16                	je     80070f <_panic+0x2e>
		cprintf("%s: ", argv0);
  8006f9:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8006fe:	83 ec 08             	sub    $0x8,%esp
  800701:	50                   	push   %eax
  800702:	68 20 39 80 00       	push   $0x803920
  800707:	e8 89 02 00 00       	call   800995 <cprintf>
  80070c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80070f:	a1 00 50 80 00       	mov    0x805000,%eax
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	ff 75 08             	pushl  0x8(%ebp)
  80071a:	50                   	push   %eax
  80071b:	68 25 39 80 00       	push   $0x803925
  800720:	e8 70 02 00 00       	call   800995 <cprintf>
  800725:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800728:	8b 45 10             	mov    0x10(%ebp),%eax
  80072b:	83 ec 08             	sub    $0x8,%esp
  80072e:	ff 75 f4             	pushl  -0xc(%ebp)
  800731:	50                   	push   %eax
  800732:	e8 f3 01 00 00       	call   80092a <vcprintf>
  800737:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80073a:	83 ec 08             	sub    $0x8,%esp
  80073d:	6a 00                	push   $0x0
  80073f:	68 41 39 80 00       	push   $0x803941
  800744:	e8 e1 01 00 00       	call   80092a <vcprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80074c:	e8 82 ff ff ff       	call   8006d3 <exit>

	// should not return here
	while (1) ;
  800751:	eb fe                	jmp    800751 <_panic+0x70>

00800753 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800753:	55                   	push   %ebp
  800754:	89 e5                	mov    %esp,%ebp
  800756:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800759:	a1 20 50 80 00       	mov    0x805020,%eax
  80075e:	8b 50 74             	mov    0x74(%eax),%edx
  800761:	8b 45 0c             	mov    0xc(%ebp),%eax
  800764:	39 c2                	cmp    %eax,%edx
  800766:	74 14                	je     80077c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800768:	83 ec 04             	sub    $0x4,%esp
  80076b:	68 44 39 80 00       	push   $0x803944
  800770:	6a 26                	push   $0x26
  800772:	68 90 39 80 00       	push   $0x803990
  800777:	e8 65 ff ff ff       	call   8006e1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80077c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800783:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80078a:	e9 c2 00 00 00       	jmp    800851 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80078f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800792:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800799:	8b 45 08             	mov    0x8(%ebp),%eax
  80079c:	01 d0                	add    %edx,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	85 c0                	test   %eax,%eax
  8007a2:	75 08                	jne    8007ac <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007a4:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007a7:	e9 a2 00 00 00       	jmp    80084e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007ac:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007b3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ba:	eb 69                	jmp    800825 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007bc:	a1 20 50 80 00       	mov    0x805020,%eax
  8007c1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ca:	89 d0                	mov    %edx,%eax
  8007cc:	01 c0                	add    %eax,%eax
  8007ce:	01 d0                	add    %edx,%eax
  8007d0:	c1 e0 03             	shl    $0x3,%eax
  8007d3:	01 c8                	add    %ecx,%eax
  8007d5:	8a 40 04             	mov    0x4(%eax),%al
  8007d8:	84 c0                	test   %al,%al
  8007da:	75 46                	jne    800822 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007dc:	a1 20 50 80 00       	mov    0x805020,%eax
  8007e1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007e7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ea:	89 d0                	mov    %edx,%eax
  8007ec:	01 c0                	add    %eax,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	c1 e0 03             	shl    $0x3,%eax
  8007f3:	01 c8                	add    %ecx,%eax
  8007f5:	8b 00                	mov    (%eax),%eax
  8007f7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8007fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8007fd:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800802:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800807:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	01 c8                	add    %ecx,%eax
  800813:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800815:	39 c2                	cmp    %eax,%edx
  800817:	75 09                	jne    800822 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800819:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800820:	eb 12                	jmp    800834 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800822:	ff 45 e8             	incl   -0x18(%ebp)
  800825:	a1 20 50 80 00       	mov    0x805020,%eax
  80082a:	8b 50 74             	mov    0x74(%eax),%edx
  80082d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800830:	39 c2                	cmp    %eax,%edx
  800832:	77 88                	ja     8007bc <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800834:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800838:	75 14                	jne    80084e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80083a:	83 ec 04             	sub    $0x4,%esp
  80083d:	68 9c 39 80 00       	push   $0x80399c
  800842:	6a 3a                	push   $0x3a
  800844:	68 90 39 80 00       	push   $0x803990
  800849:	e8 93 fe ff ff       	call   8006e1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80084e:	ff 45 f0             	incl   -0x10(%ebp)
  800851:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800854:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800857:	0f 8c 32 ff ff ff    	jl     80078f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80085d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800864:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80086b:	eb 26                	jmp    800893 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80086d:	a1 20 50 80 00       	mov    0x805020,%eax
  800872:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800878:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80087b:	89 d0                	mov    %edx,%eax
  80087d:	01 c0                	add    %eax,%eax
  80087f:	01 d0                	add    %edx,%eax
  800881:	c1 e0 03             	shl    $0x3,%eax
  800884:	01 c8                	add    %ecx,%eax
  800886:	8a 40 04             	mov    0x4(%eax),%al
  800889:	3c 01                	cmp    $0x1,%al
  80088b:	75 03                	jne    800890 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80088d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800890:	ff 45 e0             	incl   -0x20(%ebp)
  800893:	a1 20 50 80 00       	mov    0x805020,%eax
  800898:	8b 50 74             	mov    0x74(%eax),%edx
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	39 c2                	cmp    %eax,%edx
  8008a0:	77 cb                	ja     80086d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008a5:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008a8:	74 14                	je     8008be <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008aa:	83 ec 04             	sub    $0x4,%esp
  8008ad:	68 f0 39 80 00       	push   $0x8039f0
  8008b2:	6a 44                	push   $0x44
  8008b4:	68 90 39 80 00       	push   $0x803990
  8008b9:	e8 23 fe ff ff       	call   8006e1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008be:	90                   	nop
  8008bf:	c9                   	leave  
  8008c0:	c3                   	ret    

008008c1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008c1:	55                   	push   %ebp
  8008c2:	89 e5                	mov    %esp,%ebp
  8008c4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ca:	8b 00                	mov    (%eax),%eax
  8008cc:	8d 48 01             	lea    0x1(%eax),%ecx
  8008cf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008d2:	89 0a                	mov    %ecx,(%edx)
  8008d4:	8b 55 08             	mov    0x8(%ebp),%edx
  8008d7:	88 d1                	mov    %dl,%cl
  8008d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008dc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8008e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008e3:	8b 00                	mov    (%eax),%eax
  8008e5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8008ea:	75 2c                	jne    800918 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8008ec:	a0 24 50 80 00       	mov    0x805024,%al
  8008f1:	0f b6 c0             	movzbl %al,%eax
  8008f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f7:	8b 12                	mov    (%edx),%edx
  8008f9:	89 d1                	mov    %edx,%ecx
  8008fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fe:	83 c2 08             	add    $0x8,%edx
  800901:	83 ec 04             	sub    $0x4,%esp
  800904:	50                   	push   %eax
  800905:	51                   	push   %ecx
  800906:	52                   	push   %edx
  800907:	e8 05 14 00 00       	call   801d11 <sys_cputs>
  80090c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80090f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800912:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800918:	8b 45 0c             	mov    0xc(%ebp),%eax
  80091b:	8b 40 04             	mov    0x4(%eax),%eax
  80091e:	8d 50 01             	lea    0x1(%eax),%edx
  800921:	8b 45 0c             	mov    0xc(%ebp),%eax
  800924:	89 50 04             	mov    %edx,0x4(%eax)
}
  800927:	90                   	nop
  800928:	c9                   	leave  
  800929:	c3                   	ret    

0080092a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80092a:	55                   	push   %ebp
  80092b:	89 e5                	mov    %esp,%ebp
  80092d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800933:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80093a:	00 00 00 
	b.cnt = 0;
  80093d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800944:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	ff 75 08             	pushl  0x8(%ebp)
  80094d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800953:	50                   	push   %eax
  800954:	68 c1 08 80 00       	push   $0x8008c1
  800959:	e8 11 02 00 00       	call   800b6f <vprintfmt>
  80095e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800961:	a0 24 50 80 00       	mov    0x805024,%al
  800966:	0f b6 c0             	movzbl %al,%eax
  800969:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80096f:	83 ec 04             	sub    $0x4,%esp
  800972:	50                   	push   %eax
  800973:	52                   	push   %edx
  800974:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80097a:	83 c0 08             	add    $0x8,%eax
  80097d:	50                   	push   %eax
  80097e:	e8 8e 13 00 00       	call   801d11 <sys_cputs>
  800983:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800986:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  80098d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800993:	c9                   	leave  
  800994:	c3                   	ret    

00800995 <cprintf>:

int cprintf(const char *fmt, ...) {
  800995:	55                   	push   %ebp
  800996:	89 e5                	mov    %esp,%ebp
  800998:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80099b:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8009a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ab:	83 ec 08             	sub    $0x8,%esp
  8009ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8009b1:	50                   	push   %eax
  8009b2:	e8 73 ff ff ff       	call   80092a <vcprintf>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009c0:	c9                   	leave  
  8009c1:	c3                   	ret    

008009c2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009c2:	55                   	push   %ebp
  8009c3:	89 e5                	mov    %esp,%ebp
  8009c5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009c8:	e8 f2 14 00 00       	call   801ebf <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009cd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d6:	83 ec 08             	sub    $0x8,%esp
  8009d9:	ff 75 f4             	pushl  -0xc(%ebp)
  8009dc:	50                   	push   %eax
  8009dd:	e8 48 ff ff ff       	call   80092a <vcprintf>
  8009e2:	83 c4 10             	add    $0x10,%esp
  8009e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8009e8:	e8 ec 14 00 00       	call   801ed9 <sys_enable_interrupt>
	return cnt;
  8009ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009f0:	c9                   	leave  
  8009f1:	c3                   	ret    

008009f2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8009f2:	55                   	push   %ebp
  8009f3:	89 e5                	mov    %esp,%ebp
  8009f5:	53                   	push   %ebx
  8009f6:	83 ec 14             	sub    $0x14,%esp
  8009f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009fc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a05:	8b 45 18             	mov    0x18(%ebp),%eax
  800a08:	ba 00 00 00 00       	mov    $0x0,%edx
  800a0d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a10:	77 55                	ja     800a67 <printnum+0x75>
  800a12:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a15:	72 05                	jb     800a1c <printnum+0x2a>
  800a17:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a1a:	77 4b                	ja     800a67 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a1c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a1f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a22:	8b 45 18             	mov    0x18(%ebp),%eax
  800a25:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2a:	52                   	push   %edx
  800a2b:	50                   	push   %eax
  800a2c:	ff 75 f4             	pushl  -0xc(%ebp)
  800a2f:	ff 75 f0             	pushl  -0x10(%ebp)
  800a32:	e8 65 2a 00 00       	call   80349c <__udivdi3>
  800a37:	83 c4 10             	add    $0x10,%esp
  800a3a:	83 ec 04             	sub    $0x4,%esp
  800a3d:	ff 75 20             	pushl  0x20(%ebp)
  800a40:	53                   	push   %ebx
  800a41:	ff 75 18             	pushl  0x18(%ebp)
  800a44:	52                   	push   %edx
  800a45:	50                   	push   %eax
  800a46:	ff 75 0c             	pushl  0xc(%ebp)
  800a49:	ff 75 08             	pushl  0x8(%ebp)
  800a4c:	e8 a1 ff ff ff       	call   8009f2 <printnum>
  800a51:	83 c4 20             	add    $0x20,%esp
  800a54:	eb 1a                	jmp    800a70 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	ff 75 20             	pushl  0x20(%ebp)
  800a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a62:	ff d0                	call   *%eax
  800a64:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a67:	ff 4d 1c             	decl   0x1c(%ebp)
  800a6a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a6e:	7f e6                	jg     800a56 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a70:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a73:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a7e:	53                   	push   %ebx
  800a7f:	51                   	push   %ecx
  800a80:	52                   	push   %edx
  800a81:	50                   	push   %eax
  800a82:	e8 25 2b 00 00       	call   8035ac <__umoddi3>
  800a87:	83 c4 10             	add    $0x10,%esp
  800a8a:	05 54 3c 80 00       	add    $0x803c54,%eax
  800a8f:	8a 00                	mov    (%eax),%al
  800a91:	0f be c0             	movsbl %al,%eax
  800a94:	83 ec 08             	sub    $0x8,%esp
  800a97:	ff 75 0c             	pushl  0xc(%ebp)
  800a9a:	50                   	push   %eax
  800a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9e:	ff d0                	call   *%eax
  800aa0:	83 c4 10             	add    $0x10,%esp
}
  800aa3:	90                   	nop
  800aa4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aa7:	c9                   	leave  
  800aa8:	c3                   	ret    

00800aa9 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aa9:	55                   	push   %ebp
  800aaa:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800aac:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ab0:	7e 1c                	jle    800ace <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab5:	8b 00                	mov    (%eax),%eax
  800ab7:	8d 50 08             	lea    0x8(%eax),%edx
  800aba:	8b 45 08             	mov    0x8(%ebp),%eax
  800abd:	89 10                	mov    %edx,(%eax)
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	8b 00                	mov    (%eax),%eax
  800ac4:	83 e8 08             	sub    $0x8,%eax
  800ac7:	8b 50 04             	mov    0x4(%eax),%edx
  800aca:	8b 00                	mov    (%eax),%eax
  800acc:	eb 40                	jmp    800b0e <getuint+0x65>
	else if (lflag)
  800ace:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ad2:	74 1e                	je     800af2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	8d 50 04             	lea    0x4(%eax),%edx
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	89 10                	mov    %edx,(%eax)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	83 e8 04             	sub    $0x4,%eax
  800ae9:	8b 00                	mov    (%eax),%eax
  800aeb:	ba 00 00 00 00       	mov    $0x0,%edx
  800af0:	eb 1c                	jmp    800b0e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800af2:	8b 45 08             	mov    0x8(%ebp),%eax
  800af5:	8b 00                	mov    (%eax),%eax
  800af7:	8d 50 04             	lea    0x4(%eax),%edx
  800afa:	8b 45 08             	mov    0x8(%ebp),%eax
  800afd:	89 10                	mov    %edx,(%eax)
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	8b 00                	mov    (%eax),%eax
  800b04:	83 e8 04             	sub    $0x4,%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b0e:	5d                   	pop    %ebp
  800b0f:	c3                   	ret    

00800b10 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b10:	55                   	push   %ebp
  800b11:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b13:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b17:	7e 1c                	jle    800b35 <getint+0x25>
		return va_arg(*ap, long long);
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 50 08             	lea    0x8(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 10                	mov    %edx,(%eax)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	83 e8 08             	sub    $0x8,%eax
  800b2e:	8b 50 04             	mov    0x4(%eax),%edx
  800b31:	8b 00                	mov    (%eax),%eax
  800b33:	eb 38                	jmp    800b6d <getint+0x5d>
	else if (lflag)
  800b35:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b39:	74 1a                	je     800b55 <getint+0x45>
		return va_arg(*ap, long);
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	8d 50 04             	lea    0x4(%eax),%edx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	89 10                	mov    %edx,(%eax)
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8b 00                	mov    (%eax),%eax
  800b4d:	83 e8 04             	sub    $0x4,%eax
  800b50:	8b 00                	mov    (%eax),%eax
  800b52:	99                   	cltd   
  800b53:	eb 18                	jmp    800b6d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 50 04             	lea    0x4(%eax),%edx
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	89 10                	mov    %edx,(%eax)
  800b62:	8b 45 08             	mov    0x8(%ebp),%eax
  800b65:	8b 00                	mov    (%eax),%eax
  800b67:	83 e8 04             	sub    $0x4,%eax
  800b6a:	8b 00                	mov    (%eax),%eax
  800b6c:	99                   	cltd   
}
  800b6d:	5d                   	pop    %ebp
  800b6e:	c3                   	ret    

00800b6f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b6f:	55                   	push   %ebp
  800b70:	89 e5                	mov    %esp,%ebp
  800b72:	56                   	push   %esi
  800b73:	53                   	push   %ebx
  800b74:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b77:	eb 17                	jmp    800b90 <vprintfmt+0x21>
			if (ch == '\0')
  800b79:	85 db                	test   %ebx,%ebx
  800b7b:	0f 84 af 03 00 00    	je     800f30 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800b81:	83 ec 08             	sub    $0x8,%esp
  800b84:	ff 75 0c             	pushl  0xc(%ebp)
  800b87:	53                   	push   %ebx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	ff d0                	call   *%eax
  800b8d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	8d 50 01             	lea    0x1(%eax),%edx
  800b96:	89 55 10             	mov    %edx,0x10(%ebp)
  800b99:	8a 00                	mov    (%eax),%al
  800b9b:	0f b6 d8             	movzbl %al,%ebx
  800b9e:	83 fb 25             	cmp    $0x25,%ebx
  800ba1:	75 d6                	jne    800b79 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800ba3:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800ba7:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bb5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bbc:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800bc3:	8b 45 10             	mov    0x10(%ebp),%eax
  800bc6:	8d 50 01             	lea    0x1(%eax),%edx
  800bc9:	89 55 10             	mov    %edx,0x10(%ebp)
  800bcc:	8a 00                	mov    (%eax),%al
  800bce:	0f b6 d8             	movzbl %al,%ebx
  800bd1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bd4:	83 f8 55             	cmp    $0x55,%eax
  800bd7:	0f 87 2b 03 00 00    	ja     800f08 <vprintfmt+0x399>
  800bdd:	8b 04 85 78 3c 80 00 	mov    0x803c78(,%eax,4),%eax
  800be4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800be6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800bea:	eb d7                	jmp    800bc3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800bec:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800bf0:	eb d1                	jmp    800bc3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800bf2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800bf9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800bfc:	89 d0                	mov    %edx,%eax
  800bfe:	c1 e0 02             	shl    $0x2,%eax
  800c01:	01 d0                	add    %edx,%eax
  800c03:	01 c0                	add    %eax,%eax
  800c05:	01 d8                	add    %ebx,%eax
  800c07:	83 e8 30             	sub    $0x30,%eax
  800c0a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800c10:	8a 00                	mov    (%eax),%al
  800c12:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c15:	83 fb 2f             	cmp    $0x2f,%ebx
  800c18:	7e 3e                	jle    800c58 <vprintfmt+0xe9>
  800c1a:	83 fb 39             	cmp    $0x39,%ebx
  800c1d:	7f 39                	jg     800c58 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c1f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c22:	eb d5                	jmp    800bf9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c24:	8b 45 14             	mov    0x14(%ebp),%eax
  800c27:	83 c0 04             	add    $0x4,%eax
  800c2a:	89 45 14             	mov    %eax,0x14(%ebp)
  800c2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c30:	83 e8 04             	sub    $0x4,%eax
  800c33:	8b 00                	mov    (%eax),%eax
  800c35:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c38:	eb 1f                	jmp    800c59 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c3a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c3e:	79 83                	jns    800bc3 <vprintfmt+0x54>
				width = 0;
  800c40:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c47:	e9 77 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c4c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c53:	e9 6b ff ff ff       	jmp    800bc3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c58:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c59:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c5d:	0f 89 60 ff ff ff    	jns    800bc3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c63:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c66:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c69:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c70:	e9 4e ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c75:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c78:	e9 46 ff ff ff       	jmp    800bc3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800c80:	83 c0 04             	add    $0x4,%eax
  800c83:	89 45 14             	mov    %eax,0x14(%ebp)
  800c86:	8b 45 14             	mov    0x14(%ebp),%eax
  800c89:	83 e8 04             	sub    $0x4,%eax
  800c8c:	8b 00                	mov    (%eax),%eax
  800c8e:	83 ec 08             	sub    $0x8,%esp
  800c91:	ff 75 0c             	pushl  0xc(%ebp)
  800c94:	50                   	push   %eax
  800c95:	8b 45 08             	mov    0x8(%ebp),%eax
  800c98:	ff d0                	call   *%eax
  800c9a:	83 c4 10             	add    $0x10,%esp
			break;
  800c9d:	e9 89 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ca2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca5:	83 c0 04             	add    $0x4,%eax
  800ca8:	89 45 14             	mov    %eax,0x14(%ebp)
  800cab:	8b 45 14             	mov    0x14(%ebp),%eax
  800cae:	83 e8 04             	sub    $0x4,%eax
  800cb1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cb3:	85 db                	test   %ebx,%ebx
  800cb5:	79 02                	jns    800cb9 <vprintfmt+0x14a>
				err = -err;
  800cb7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cb9:	83 fb 64             	cmp    $0x64,%ebx
  800cbc:	7f 0b                	jg     800cc9 <vprintfmt+0x15a>
  800cbe:	8b 34 9d c0 3a 80 00 	mov    0x803ac0(,%ebx,4),%esi
  800cc5:	85 f6                	test   %esi,%esi
  800cc7:	75 19                	jne    800ce2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800cc9:	53                   	push   %ebx
  800cca:	68 65 3c 80 00       	push   $0x803c65
  800ccf:	ff 75 0c             	pushl  0xc(%ebp)
  800cd2:	ff 75 08             	pushl  0x8(%ebp)
  800cd5:	e8 5e 02 00 00       	call   800f38 <printfmt>
  800cda:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cdd:	e9 49 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ce2:	56                   	push   %esi
  800ce3:	68 6e 3c 80 00       	push   $0x803c6e
  800ce8:	ff 75 0c             	pushl  0xc(%ebp)
  800ceb:	ff 75 08             	pushl  0x8(%ebp)
  800cee:	e8 45 02 00 00       	call   800f38 <printfmt>
  800cf3:	83 c4 10             	add    $0x10,%esp
			break;
  800cf6:	e9 30 02 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800cfb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cfe:	83 c0 04             	add    $0x4,%eax
  800d01:	89 45 14             	mov    %eax,0x14(%ebp)
  800d04:	8b 45 14             	mov    0x14(%ebp),%eax
  800d07:	83 e8 04             	sub    $0x4,%eax
  800d0a:	8b 30                	mov    (%eax),%esi
  800d0c:	85 f6                	test   %esi,%esi
  800d0e:	75 05                	jne    800d15 <vprintfmt+0x1a6>
				p = "(null)";
  800d10:	be 71 3c 80 00       	mov    $0x803c71,%esi
			if (width > 0 && padc != '-')
  800d15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d19:	7e 6d                	jle    800d88 <vprintfmt+0x219>
  800d1b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d1f:	74 67                	je     800d88 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d21:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d24:	83 ec 08             	sub    $0x8,%esp
  800d27:	50                   	push   %eax
  800d28:	56                   	push   %esi
  800d29:	e8 0c 03 00 00       	call   80103a <strnlen>
  800d2e:	83 c4 10             	add    $0x10,%esp
  800d31:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d34:	eb 16                	jmp    800d4c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d36:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d3a:	83 ec 08             	sub    $0x8,%esp
  800d3d:	ff 75 0c             	pushl  0xc(%ebp)
  800d40:	50                   	push   %eax
  800d41:	8b 45 08             	mov    0x8(%ebp),%eax
  800d44:	ff d0                	call   *%eax
  800d46:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d49:	ff 4d e4             	decl   -0x1c(%ebp)
  800d4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d50:	7f e4                	jg     800d36 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d52:	eb 34                	jmp    800d88 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d54:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d58:	74 1c                	je     800d76 <vprintfmt+0x207>
  800d5a:	83 fb 1f             	cmp    $0x1f,%ebx
  800d5d:	7e 05                	jle    800d64 <vprintfmt+0x1f5>
  800d5f:	83 fb 7e             	cmp    $0x7e,%ebx
  800d62:	7e 12                	jle    800d76 <vprintfmt+0x207>
					putch('?', putdat);
  800d64:	83 ec 08             	sub    $0x8,%esp
  800d67:	ff 75 0c             	pushl  0xc(%ebp)
  800d6a:	6a 3f                	push   $0x3f
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	ff d0                	call   *%eax
  800d71:	83 c4 10             	add    $0x10,%esp
  800d74:	eb 0f                	jmp    800d85 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d76:	83 ec 08             	sub    $0x8,%esp
  800d79:	ff 75 0c             	pushl  0xc(%ebp)
  800d7c:	53                   	push   %ebx
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	ff d0                	call   *%eax
  800d82:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d85:	ff 4d e4             	decl   -0x1c(%ebp)
  800d88:	89 f0                	mov    %esi,%eax
  800d8a:	8d 70 01             	lea    0x1(%eax),%esi
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f be d8             	movsbl %al,%ebx
  800d92:	85 db                	test   %ebx,%ebx
  800d94:	74 24                	je     800dba <vprintfmt+0x24b>
  800d96:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800d9a:	78 b8                	js     800d54 <vprintfmt+0x1e5>
  800d9c:	ff 4d e0             	decl   -0x20(%ebp)
  800d9f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800da3:	79 af                	jns    800d54 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800da5:	eb 13                	jmp    800dba <vprintfmt+0x24b>
				putch(' ', putdat);
  800da7:	83 ec 08             	sub    $0x8,%esp
  800daa:	ff 75 0c             	pushl  0xc(%ebp)
  800dad:	6a 20                	push   $0x20
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
  800db2:	ff d0                	call   *%eax
  800db4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800db7:	ff 4d e4             	decl   -0x1c(%ebp)
  800dba:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dbe:	7f e7                	jg     800da7 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dc0:	e9 66 01 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800dc5:	83 ec 08             	sub    $0x8,%esp
  800dc8:	ff 75 e8             	pushl  -0x18(%ebp)
  800dcb:	8d 45 14             	lea    0x14(%ebp),%eax
  800dce:	50                   	push   %eax
  800dcf:	e8 3c fd ff ff       	call   800b10 <getint>
  800dd4:	83 c4 10             	add    $0x10,%esp
  800dd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dda:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ddd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800de0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800de3:	85 d2                	test   %edx,%edx
  800de5:	79 23                	jns    800e0a <vprintfmt+0x29b>
				putch('-', putdat);
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	ff 75 0c             	pushl  0xc(%ebp)
  800ded:	6a 2d                	push   $0x2d
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	ff d0                	call   *%eax
  800df4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800df7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800dfa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800dfd:	f7 d8                	neg    %eax
  800dff:	83 d2 00             	adc    $0x0,%edx
  800e02:	f7 da                	neg    %edx
  800e04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e11:	e9 bc 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e16:	83 ec 08             	sub    $0x8,%esp
  800e19:	ff 75 e8             	pushl  -0x18(%ebp)
  800e1c:	8d 45 14             	lea    0x14(%ebp),%eax
  800e1f:	50                   	push   %eax
  800e20:	e8 84 fc ff ff       	call   800aa9 <getuint>
  800e25:	83 c4 10             	add    $0x10,%esp
  800e28:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e2b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e2e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e35:	e9 98 00 00 00       	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e3a:	83 ec 08             	sub    $0x8,%esp
  800e3d:	ff 75 0c             	pushl  0xc(%ebp)
  800e40:	6a 58                	push   $0x58
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	ff d0                	call   *%eax
  800e47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	6a 58                	push   $0x58
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	ff d0                	call   *%eax
  800e57:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e5a:	83 ec 08             	sub    $0x8,%esp
  800e5d:	ff 75 0c             	pushl  0xc(%ebp)
  800e60:	6a 58                	push   $0x58
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
  800e65:	ff d0                	call   *%eax
  800e67:	83 c4 10             	add    $0x10,%esp
			break;
  800e6a:	e9 bc 00 00 00       	jmp    800f2b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e6f:	83 ec 08             	sub    $0x8,%esp
  800e72:	ff 75 0c             	pushl  0xc(%ebp)
  800e75:	6a 30                	push   $0x30
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	ff d0                	call   *%eax
  800e7c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 78                	push   $0x78
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800e8f:	8b 45 14             	mov    0x14(%ebp),%eax
  800e92:	83 c0 04             	add    $0x4,%eax
  800e95:	89 45 14             	mov    %eax,0x14(%ebp)
  800e98:	8b 45 14             	mov    0x14(%ebp),%eax
  800e9b:	83 e8 04             	sub    $0x4,%eax
  800e9e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ea0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ea3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eaa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eb1:	eb 1f                	jmp    800ed2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800eb3:	83 ec 08             	sub    $0x8,%esp
  800eb6:	ff 75 e8             	pushl  -0x18(%ebp)
  800eb9:	8d 45 14             	lea    0x14(%ebp),%eax
  800ebc:	50                   	push   %eax
  800ebd:	e8 e7 fb ff ff       	call   800aa9 <getuint>
  800ec2:	83 c4 10             	add    $0x10,%esp
  800ec5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ecb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ed2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ed9:	83 ec 04             	sub    $0x4,%esp
  800edc:	52                   	push   %edx
  800edd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ee0:	50                   	push   %eax
  800ee1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ee4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ee7:	ff 75 0c             	pushl  0xc(%ebp)
  800eea:	ff 75 08             	pushl  0x8(%ebp)
  800eed:	e8 00 fb ff ff       	call   8009f2 <printnum>
  800ef2:	83 c4 20             	add    $0x20,%esp
			break;
  800ef5:	eb 34                	jmp    800f2b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ef7:	83 ec 08             	sub    $0x8,%esp
  800efa:	ff 75 0c             	pushl  0xc(%ebp)
  800efd:	53                   	push   %ebx
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	ff d0                	call   *%eax
  800f03:	83 c4 10             	add    $0x10,%esp
			break;
  800f06:	eb 23                	jmp    800f2b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f08:	83 ec 08             	sub    $0x8,%esp
  800f0b:	ff 75 0c             	pushl  0xc(%ebp)
  800f0e:	6a 25                	push   $0x25
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	ff d0                	call   *%eax
  800f15:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f18:	ff 4d 10             	decl   0x10(%ebp)
  800f1b:	eb 03                	jmp    800f20 <vprintfmt+0x3b1>
  800f1d:	ff 4d 10             	decl   0x10(%ebp)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	48                   	dec    %eax
  800f24:	8a 00                	mov    (%eax),%al
  800f26:	3c 25                	cmp    $0x25,%al
  800f28:	75 f3                	jne    800f1d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f2a:	90                   	nop
		}
	}
  800f2b:	e9 47 fc ff ff       	jmp    800b77 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f30:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f31:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f34:	5b                   	pop    %ebx
  800f35:	5e                   	pop    %esi
  800f36:	5d                   	pop    %ebp
  800f37:	c3                   	ret    

00800f38 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f38:	55                   	push   %ebp
  800f39:	89 e5                	mov    %esp,%ebp
  800f3b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f3e:	8d 45 10             	lea    0x10(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	ff 75 f4             	pushl  -0xc(%ebp)
  800f4d:	50                   	push   %eax
  800f4e:	ff 75 0c             	pushl  0xc(%ebp)
  800f51:	ff 75 08             	pushl  0x8(%ebp)
  800f54:	e8 16 fc ff ff       	call   800b6f <vprintfmt>
  800f59:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f5c:	90                   	nop
  800f5d:	c9                   	leave  
  800f5e:	c3                   	ret    

00800f5f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f5f:	55                   	push   %ebp
  800f60:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	8b 40 08             	mov    0x8(%eax),%eax
  800f68:	8d 50 01             	lea    0x1(%eax),%edx
  800f6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f71:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f74:	8b 10                	mov    (%eax),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	8b 40 04             	mov    0x4(%eax),%eax
  800f7c:	39 c2                	cmp    %eax,%edx
  800f7e:	73 12                	jae    800f92 <sprintputch+0x33>
		*b->buf++ = ch;
  800f80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f83:	8b 00                	mov    (%eax),%eax
  800f85:	8d 48 01             	lea    0x1(%eax),%ecx
  800f88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f8b:	89 0a                	mov    %ecx,(%edx)
  800f8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f90:	88 10                	mov    %dl,(%eax)
}
  800f92:	90                   	nop
  800f93:	5d                   	pop    %ebp
  800f94:	c3                   	ret    

00800f95 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800f95:	55                   	push   %ebp
  800f96:	89 e5                	mov    %esp,%ebp
  800f98:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fa1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	01 d0                	add    %edx,%eax
  800fac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800faf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fba:	74 06                	je     800fc2 <vsnprintf+0x2d>
  800fbc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fc0:	7f 07                	jg     800fc9 <vsnprintf+0x34>
		return -E_INVAL;
  800fc2:	b8 03 00 00 00       	mov    $0x3,%eax
  800fc7:	eb 20                	jmp    800fe9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800fc9:	ff 75 14             	pushl  0x14(%ebp)
  800fcc:	ff 75 10             	pushl  0x10(%ebp)
  800fcf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800fd2:	50                   	push   %eax
  800fd3:	68 5f 0f 80 00       	push   $0x800f5f
  800fd8:	e8 92 fb ff ff       	call   800b6f <vprintfmt>
  800fdd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800fe0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fe3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800fe9:	c9                   	leave  
  800fea:	c3                   	ret    

00800feb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800feb:	55                   	push   %ebp
  800fec:	89 e5                	mov    %esp,%ebp
  800fee:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ff1:	8d 45 10             	lea    0x10(%ebp),%eax
  800ff4:	83 c0 04             	add    $0x4,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ffa:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffd:	ff 75 f4             	pushl  -0xc(%ebp)
  801000:	50                   	push   %eax
  801001:	ff 75 0c             	pushl  0xc(%ebp)
  801004:	ff 75 08             	pushl  0x8(%ebp)
  801007:	e8 89 ff ff ff       	call   800f95 <vsnprintf>
  80100c:	83 c4 10             	add    $0x10,%esp
  80100f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801012:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801015:	c9                   	leave  
  801016:	c3                   	ret    

00801017 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801017:	55                   	push   %ebp
  801018:	89 e5                	mov    %esp,%ebp
  80101a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80101d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801024:	eb 06                	jmp    80102c <strlen+0x15>
		n++;
  801026:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801029:	ff 45 08             	incl   0x8(%ebp)
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	8a 00                	mov    (%eax),%al
  801031:	84 c0                	test   %al,%al
  801033:	75 f1                	jne    801026 <strlen+0xf>
		n++;
	return n;
  801035:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801038:	c9                   	leave  
  801039:	c3                   	ret    

0080103a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80103a:	55                   	push   %ebp
  80103b:	89 e5                	mov    %esp,%ebp
  80103d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801040:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801047:	eb 09                	jmp    801052 <strnlen+0x18>
		n++;
  801049:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80104c:	ff 45 08             	incl   0x8(%ebp)
  80104f:	ff 4d 0c             	decl   0xc(%ebp)
  801052:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801056:	74 09                	je     801061 <strnlen+0x27>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	84 c0                	test   %al,%al
  80105f:	75 e8                	jne    801049 <strnlen+0xf>
		n++;
	return n;
  801061:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801064:	c9                   	leave  
  801065:	c3                   	ret    

00801066 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801066:	55                   	push   %ebp
  801067:	89 e5                	mov    %esp,%ebp
  801069:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801072:	90                   	nop
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
  801076:	8d 50 01             	lea    0x1(%eax),%edx
  801079:	89 55 08             	mov    %edx,0x8(%ebp)
  80107c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80107f:	8d 4a 01             	lea    0x1(%edx),%ecx
  801082:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801085:	8a 12                	mov    (%edx),%dl
  801087:	88 10                	mov    %dl,(%eax)
  801089:	8a 00                	mov    (%eax),%al
  80108b:	84 c0                	test   %al,%al
  80108d:	75 e4                	jne    801073 <strcpy+0xd>
		/* do nothing */;
	return ret;
  80108f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801092:	c9                   	leave  
  801093:	c3                   	ret    

00801094 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801094:	55                   	push   %ebp
  801095:	89 e5                	mov    %esp,%ebp
  801097:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80109a:	8b 45 08             	mov    0x8(%ebp),%eax
  80109d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010a7:	eb 1f                	jmp    8010c8 <strncpy+0x34>
		*dst++ = *src;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8d 50 01             	lea    0x1(%eax),%edx
  8010af:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010b5:	8a 12                	mov    (%edx),%dl
  8010b7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	84 c0                	test   %al,%al
  8010c0:	74 03                	je     8010c5 <strncpy+0x31>
			src++;
  8010c2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010c5:	ff 45 fc             	incl   -0x4(%ebp)
  8010c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010cb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010ce:	72 d9                	jb     8010a9 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010d0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010d3:	c9                   	leave  
  8010d4:	c3                   	ret    

008010d5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010d5:	55                   	push   %ebp
  8010d6:	89 e5                	mov    %esp,%ebp
  8010d8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010db:	8b 45 08             	mov    0x8(%ebp),%eax
  8010de:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8010e1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010e5:	74 30                	je     801117 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8010e7:	eb 16                	jmp    8010ff <strlcpy+0x2a>
			*dst++ = *src++;
  8010e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ec:	8d 50 01             	lea    0x1(%eax),%edx
  8010ef:	89 55 08             	mov    %edx,0x8(%ebp)
  8010f2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f5:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010f8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010fb:	8a 12                	mov    (%edx),%dl
  8010fd:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8010ff:	ff 4d 10             	decl   0x10(%ebp)
  801102:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801106:	74 09                	je     801111 <strlcpy+0x3c>
  801108:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110b:	8a 00                	mov    (%eax),%al
  80110d:	84 c0                	test   %al,%al
  80110f:	75 d8                	jne    8010e9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801111:	8b 45 08             	mov    0x8(%ebp),%eax
  801114:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801117:	8b 55 08             	mov    0x8(%ebp),%edx
  80111a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80111d:	29 c2                	sub    %eax,%edx
  80111f:	89 d0                	mov    %edx,%eax
}
  801121:	c9                   	leave  
  801122:	c3                   	ret    

00801123 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801123:	55                   	push   %ebp
  801124:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801126:	eb 06                	jmp    80112e <strcmp+0xb>
		p++, q++;
  801128:	ff 45 08             	incl   0x8(%ebp)
  80112b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80112e:	8b 45 08             	mov    0x8(%ebp),%eax
  801131:	8a 00                	mov    (%eax),%al
  801133:	84 c0                	test   %al,%al
  801135:	74 0e                	je     801145 <strcmp+0x22>
  801137:	8b 45 08             	mov    0x8(%ebp),%eax
  80113a:	8a 10                	mov    (%eax),%dl
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8a 00                	mov    (%eax),%al
  801141:	38 c2                	cmp    %al,%dl
  801143:	74 e3                	je     801128 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801145:	8b 45 08             	mov    0x8(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	0f b6 d0             	movzbl %al,%edx
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	8a 00                	mov    (%eax),%al
  801152:	0f b6 c0             	movzbl %al,%eax
  801155:	29 c2                	sub    %eax,%edx
  801157:	89 d0                	mov    %edx,%eax
}
  801159:	5d                   	pop    %ebp
  80115a:	c3                   	ret    

0080115b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80115b:	55                   	push   %ebp
  80115c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80115e:	eb 09                	jmp    801169 <strncmp+0xe>
		n--, p++, q++;
  801160:	ff 4d 10             	decl   0x10(%ebp)
  801163:	ff 45 08             	incl   0x8(%ebp)
  801166:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801169:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80116d:	74 17                	je     801186 <strncmp+0x2b>
  80116f:	8b 45 08             	mov    0x8(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	84 c0                	test   %al,%al
  801176:	74 0e                	je     801186 <strncmp+0x2b>
  801178:	8b 45 08             	mov    0x8(%ebp),%eax
  80117b:	8a 10                	mov    (%eax),%dl
  80117d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801180:	8a 00                	mov    (%eax),%al
  801182:	38 c2                	cmp    %al,%dl
  801184:	74 da                	je     801160 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801186:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118a:	75 07                	jne    801193 <strncmp+0x38>
		return 0;
  80118c:	b8 00 00 00 00       	mov    $0x0,%eax
  801191:	eb 14                	jmp    8011a7 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	8a 00                	mov    (%eax),%al
  801198:	0f b6 d0             	movzbl %al,%edx
  80119b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119e:	8a 00                	mov    (%eax),%al
  8011a0:	0f b6 c0             	movzbl %al,%eax
  8011a3:	29 c2                	sub    %eax,%edx
  8011a5:	89 d0                	mov    %edx,%eax
}
  8011a7:	5d                   	pop    %ebp
  8011a8:	c3                   	ret    

008011a9 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011a9:	55                   	push   %ebp
  8011aa:	89 e5                	mov    %esp,%ebp
  8011ac:	83 ec 04             	sub    $0x4,%esp
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011b5:	eb 12                	jmp    8011c9 <strchr+0x20>
		if (*s == c)
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011bf:	75 05                	jne    8011c6 <strchr+0x1d>
			return (char *) s;
  8011c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c4:	eb 11                	jmp    8011d7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011c6:	ff 45 08             	incl   0x8(%ebp)
  8011c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	84 c0                	test   %al,%al
  8011d0:	75 e5                	jne    8011b7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011d7:	c9                   	leave  
  8011d8:	c3                   	ret    

008011d9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011d9:	55                   	push   %ebp
  8011da:	89 e5                	mov    %esp,%ebp
  8011dc:	83 ec 04             	sub    $0x4,%esp
  8011df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011e5:	eb 0d                	jmp    8011f4 <strfind+0x1b>
		if (*s == c)
  8011e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ea:	8a 00                	mov    (%eax),%al
  8011ec:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011ef:	74 0e                	je     8011ff <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8011f1:	ff 45 08             	incl   0x8(%ebp)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	84 c0                	test   %al,%al
  8011fb:	75 ea                	jne    8011e7 <strfind+0xe>
  8011fd:	eb 01                	jmp    801200 <strfind+0x27>
		if (*s == c)
			break;
  8011ff:	90                   	nop
	return (char *) s;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801203:	c9                   	leave  
  801204:	c3                   	ret    

00801205 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801205:	55                   	push   %ebp
  801206:	89 e5                	mov    %esp,%ebp
  801208:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801217:	eb 0e                	jmp    801227 <memset+0x22>
		*p++ = c;
  801219:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80121c:	8d 50 01             	lea    0x1(%eax),%edx
  80121f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801222:	8b 55 0c             	mov    0xc(%ebp),%edx
  801225:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801227:	ff 4d f8             	decl   -0x8(%ebp)
  80122a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80122e:	79 e9                	jns    801219 <memset+0x14>
		*p++ = c;

	return v;
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801233:	c9                   	leave  
  801234:	c3                   	ret    

00801235 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801235:	55                   	push   %ebp
  801236:	89 e5                	mov    %esp,%ebp
  801238:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80123b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801241:	8b 45 08             	mov    0x8(%ebp),%eax
  801244:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801247:	eb 16                	jmp    80125f <memcpy+0x2a>
		*d++ = *s++;
  801249:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80124c:	8d 50 01             	lea    0x1(%eax),%edx
  80124f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801252:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801255:	8d 4a 01             	lea    0x1(%edx),%ecx
  801258:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80125b:	8a 12                	mov    (%edx),%dl
  80125d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80125f:	8b 45 10             	mov    0x10(%ebp),%eax
  801262:	8d 50 ff             	lea    -0x1(%eax),%edx
  801265:	89 55 10             	mov    %edx,0x10(%ebp)
  801268:	85 c0                	test   %eax,%eax
  80126a:	75 dd                	jne    801249 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801277:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127d:	8b 45 08             	mov    0x8(%ebp),%eax
  801280:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801283:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801286:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801289:	73 50                	jae    8012db <memmove+0x6a>
  80128b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80128e:	8b 45 10             	mov    0x10(%ebp),%eax
  801291:	01 d0                	add    %edx,%eax
  801293:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801296:	76 43                	jbe    8012db <memmove+0x6a>
		s += n;
  801298:	8b 45 10             	mov    0x10(%ebp),%eax
  80129b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  80129e:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a1:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012a4:	eb 10                	jmp    8012b6 <memmove+0x45>
			*--d = *--s;
  8012a6:	ff 4d f8             	decl   -0x8(%ebp)
  8012a9:	ff 4d fc             	decl   -0x4(%ebp)
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012af:	8a 10                	mov    (%eax),%dl
  8012b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012b4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b9:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012bc:	89 55 10             	mov    %edx,0x10(%ebp)
  8012bf:	85 c0                	test   %eax,%eax
  8012c1:	75 e3                	jne    8012a6 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012c3:	eb 23                	jmp    8012e8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012ce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012d1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012d4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012d7:	8a 12                	mov    (%edx),%dl
  8012d9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012e1:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	75 dd                	jne    8012c5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8012e8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012eb:	c9                   	leave  
  8012ec:	c3                   	ret    

008012ed <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8012ed:	55                   	push   %ebp
  8012ee:	89 e5                	mov    %esp,%ebp
  8012f0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8012f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8012f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012fc:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8012ff:	eb 2a                	jmp    80132b <memcmp+0x3e>
		if (*s1 != *s2)
  801301:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801304:	8a 10                	mov    (%eax),%dl
  801306:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801309:	8a 00                	mov    (%eax),%al
  80130b:	38 c2                	cmp    %al,%dl
  80130d:	74 16                	je     801325 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80130f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801312:	8a 00                	mov    (%eax),%al
  801314:	0f b6 d0             	movzbl %al,%edx
  801317:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f b6 c0             	movzbl %al,%eax
  80131f:	29 c2                	sub    %eax,%edx
  801321:	89 d0                	mov    %edx,%eax
  801323:	eb 18                	jmp    80133d <memcmp+0x50>
		s1++, s2++;
  801325:	ff 45 fc             	incl   -0x4(%ebp)
  801328:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80132b:	8b 45 10             	mov    0x10(%ebp),%eax
  80132e:	8d 50 ff             	lea    -0x1(%eax),%edx
  801331:	89 55 10             	mov    %edx,0x10(%ebp)
  801334:	85 c0                	test   %eax,%eax
  801336:	75 c9                	jne    801301 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801338:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80133d:	c9                   	leave  
  80133e:	c3                   	ret    

0080133f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80133f:	55                   	push   %ebp
  801340:	89 e5                	mov    %esp,%ebp
  801342:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801345:	8b 55 08             	mov    0x8(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801350:	eb 15                	jmp    801367 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	8a 00                	mov    (%eax),%al
  801357:	0f b6 d0             	movzbl %al,%edx
  80135a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135d:	0f b6 c0             	movzbl %al,%eax
  801360:	39 c2                	cmp    %eax,%edx
  801362:	74 0d                	je     801371 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801364:	ff 45 08             	incl   0x8(%ebp)
  801367:	8b 45 08             	mov    0x8(%ebp),%eax
  80136a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80136d:	72 e3                	jb     801352 <memfind+0x13>
  80136f:	eb 01                	jmp    801372 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801371:	90                   	nop
	return (void *) s;
  801372:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801375:	c9                   	leave  
  801376:	c3                   	ret    

00801377 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801377:	55                   	push   %ebp
  801378:	89 e5                	mov    %esp,%ebp
  80137a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80137d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801384:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80138b:	eb 03                	jmp    801390 <strtol+0x19>
		s++;
  80138d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	3c 20                	cmp    $0x20,%al
  801397:	74 f4                	je     80138d <strtol+0x16>
  801399:	8b 45 08             	mov    0x8(%ebp),%eax
  80139c:	8a 00                	mov    (%eax),%al
  80139e:	3c 09                	cmp    $0x9,%al
  8013a0:	74 eb                	je     80138d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a5:	8a 00                	mov    (%eax),%al
  8013a7:	3c 2b                	cmp    $0x2b,%al
  8013a9:	75 05                	jne    8013b0 <strtol+0x39>
		s++;
  8013ab:	ff 45 08             	incl   0x8(%ebp)
  8013ae:	eb 13                	jmp    8013c3 <strtol+0x4c>
	else if (*s == '-')
  8013b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b3:	8a 00                	mov    (%eax),%al
  8013b5:	3c 2d                	cmp    $0x2d,%al
  8013b7:	75 0a                	jne    8013c3 <strtol+0x4c>
		s++, neg = 1;
  8013b9:	ff 45 08             	incl   0x8(%ebp)
  8013bc:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013c7:	74 06                	je     8013cf <strtol+0x58>
  8013c9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013cd:	75 20                	jne    8013ef <strtol+0x78>
  8013cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d2:	8a 00                	mov    (%eax),%al
  8013d4:	3c 30                	cmp    $0x30,%al
  8013d6:	75 17                	jne    8013ef <strtol+0x78>
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	40                   	inc    %eax
  8013dc:	8a 00                	mov    (%eax),%al
  8013de:	3c 78                	cmp    $0x78,%al
  8013e0:	75 0d                	jne    8013ef <strtol+0x78>
		s += 2, base = 16;
  8013e2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8013e6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8013ed:	eb 28                	jmp    801417 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8013ef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013f3:	75 15                	jne    80140a <strtol+0x93>
  8013f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f8:	8a 00                	mov    (%eax),%al
  8013fa:	3c 30                	cmp    $0x30,%al
  8013fc:	75 0c                	jne    80140a <strtol+0x93>
		s++, base = 8;
  8013fe:	ff 45 08             	incl   0x8(%ebp)
  801401:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801408:	eb 0d                	jmp    801417 <strtol+0xa0>
	else if (base == 0)
  80140a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80140e:	75 07                	jne    801417 <strtol+0xa0>
		base = 10;
  801410:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	3c 2f                	cmp    $0x2f,%al
  80141e:	7e 19                	jle    801439 <strtol+0xc2>
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	8a 00                	mov    (%eax),%al
  801425:	3c 39                	cmp    $0x39,%al
  801427:	7f 10                	jg     801439 <strtol+0xc2>
			dig = *s - '0';
  801429:	8b 45 08             	mov    0x8(%ebp),%eax
  80142c:	8a 00                	mov    (%eax),%al
  80142e:	0f be c0             	movsbl %al,%eax
  801431:	83 e8 30             	sub    $0x30,%eax
  801434:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801437:	eb 42                	jmp    80147b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	3c 60                	cmp    $0x60,%al
  801440:	7e 19                	jle    80145b <strtol+0xe4>
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	3c 7a                	cmp    $0x7a,%al
  801449:	7f 10                	jg     80145b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	83 e8 57             	sub    $0x57,%eax
  801456:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801459:	eb 20                	jmp    80147b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	3c 40                	cmp    $0x40,%al
  801462:	7e 39                	jle    80149d <strtol+0x126>
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	3c 5a                	cmp    $0x5a,%al
  80146b:	7f 30                	jg     80149d <strtol+0x126>
			dig = *s - 'A' + 10;
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	0f be c0             	movsbl %al,%eax
  801475:	83 e8 37             	sub    $0x37,%eax
  801478:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80147b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80147e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801481:	7d 19                	jge    80149c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801483:	ff 45 08             	incl   0x8(%ebp)
  801486:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801489:	0f af 45 10          	imul   0x10(%ebp),%eax
  80148d:	89 c2                	mov    %eax,%edx
  80148f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801492:	01 d0                	add    %edx,%eax
  801494:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801497:	e9 7b ff ff ff       	jmp    801417 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80149c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80149d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014a1:	74 08                	je     8014ab <strtol+0x134>
		*endptr = (char *) s;
  8014a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014a9:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014ab:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014af:	74 07                	je     8014b8 <strtol+0x141>
  8014b1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014b4:	f7 d8                	neg    %eax
  8014b6:	eb 03                	jmp    8014bb <strtol+0x144>
  8014b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014bb:	c9                   	leave  
  8014bc:	c3                   	ret    

008014bd <ltostr>:

void
ltostr(long value, char *str)
{
  8014bd:	55                   	push   %ebp
  8014be:	89 e5                	mov    %esp,%ebp
  8014c0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014c3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014ca:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d5:	79 13                	jns    8014ea <ltostr+0x2d>
	{
		neg = 1;
  8014d7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8014de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8014e4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8014e7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8014f2:	99                   	cltd   
  8014f3:	f7 f9                	idiv   %ecx
  8014f5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8014f8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014fb:	8d 50 01             	lea    0x1(%eax),%edx
  8014fe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801501:	89 c2                	mov    %eax,%edx
  801503:	8b 45 0c             	mov    0xc(%ebp),%eax
  801506:	01 d0                	add    %edx,%eax
  801508:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80150b:	83 c2 30             	add    $0x30,%edx
  80150e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801510:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801513:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801518:	f7 e9                	imul   %ecx
  80151a:	c1 fa 02             	sar    $0x2,%edx
  80151d:	89 c8                	mov    %ecx,%eax
  80151f:	c1 f8 1f             	sar    $0x1f,%eax
  801522:	29 c2                	sub    %eax,%edx
  801524:	89 d0                	mov    %edx,%eax
  801526:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801529:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80152c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801531:	f7 e9                	imul   %ecx
  801533:	c1 fa 02             	sar    $0x2,%edx
  801536:	89 c8                	mov    %ecx,%eax
  801538:	c1 f8 1f             	sar    $0x1f,%eax
  80153b:	29 c2                	sub    %eax,%edx
  80153d:	89 d0                	mov    %edx,%eax
  80153f:	c1 e0 02             	shl    $0x2,%eax
  801542:	01 d0                	add    %edx,%eax
  801544:	01 c0                	add    %eax,%eax
  801546:	29 c1                	sub    %eax,%ecx
  801548:	89 ca                	mov    %ecx,%edx
  80154a:	85 d2                	test   %edx,%edx
  80154c:	75 9c                	jne    8014ea <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80154e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801555:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801558:	48                   	dec    %eax
  801559:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80155c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801560:	74 3d                	je     80159f <ltostr+0xe2>
		start = 1 ;
  801562:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801569:	eb 34                	jmp    80159f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80156b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80156e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801571:	01 d0                	add    %edx,%eax
  801573:	8a 00                	mov    (%eax),%al
  801575:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80157b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80157e:	01 c2                	add    %eax,%edx
  801580:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801583:	8b 45 0c             	mov    0xc(%ebp),%eax
  801586:	01 c8                	add    %ecx,%eax
  801588:	8a 00                	mov    (%eax),%al
  80158a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80158c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80158f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801592:	01 c2                	add    %eax,%edx
  801594:	8a 45 eb             	mov    -0x15(%ebp),%al
  801597:	88 02                	mov    %al,(%edx)
		start++ ;
  801599:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80159c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80159f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015a5:	7c c4                	jl     80156b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015a7:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ad:	01 d0                	add    %edx,%eax
  8015af:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015b2:	90                   	nop
  8015b3:	c9                   	leave  
  8015b4:	c3                   	ret    

008015b5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015b5:	55                   	push   %ebp
  8015b6:	89 e5                	mov    %esp,%ebp
  8015b8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015bb:	ff 75 08             	pushl  0x8(%ebp)
  8015be:	e8 54 fa ff ff       	call   801017 <strlen>
  8015c3:	83 c4 04             	add    $0x4,%esp
  8015c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015c9:	ff 75 0c             	pushl  0xc(%ebp)
  8015cc:	e8 46 fa ff ff       	call   801017 <strlen>
  8015d1:	83 c4 04             	add    $0x4,%esp
  8015d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015d7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8015de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8015e5:	eb 17                	jmp    8015fe <strcconcat+0x49>
		final[s] = str1[s] ;
  8015e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8015ea:	8b 45 10             	mov    0x10(%ebp),%eax
  8015ed:	01 c2                	add    %eax,%edx
  8015ef:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f5:	01 c8                	add    %ecx,%eax
  8015f7:	8a 00                	mov    (%eax),%al
  8015f9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8015fb:	ff 45 fc             	incl   -0x4(%ebp)
  8015fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801601:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801604:	7c e1                	jl     8015e7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801606:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80160d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801614:	eb 1f                	jmp    801635 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801616:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801619:	8d 50 01             	lea    0x1(%eax),%edx
  80161c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80161f:	89 c2                	mov    %eax,%edx
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	01 c2                	add    %eax,%edx
  801626:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80162c:	01 c8                	add    %ecx,%eax
  80162e:	8a 00                	mov    (%eax),%al
  801630:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801632:	ff 45 f8             	incl   -0x8(%ebp)
  801635:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801638:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80163b:	7c d9                	jl     801616 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80163d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801640:	8b 45 10             	mov    0x10(%ebp),%eax
  801643:	01 d0                	add    %edx,%eax
  801645:	c6 00 00             	movb   $0x0,(%eax)
}
  801648:	90                   	nop
  801649:	c9                   	leave  
  80164a:	c3                   	ret    

0080164b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80164b:	55                   	push   %ebp
  80164c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80164e:	8b 45 14             	mov    0x14(%ebp),%eax
  801651:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801657:	8b 45 14             	mov    0x14(%ebp),%eax
  80165a:	8b 00                	mov    (%eax),%eax
  80165c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801663:	8b 45 10             	mov    0x10(%ebp),%eax
  801666:	01 d0                	add    %edx,%eax
  801668:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80166e:	eb 0c                	jmp    80167c <strsplit+0x31>
			*string++ = 0;
  801670:	8b 45 08             	mov    0x8(%ebp),%eax
  801673:	8d 50 01             	lea    0x1(%eax),%edx
  801676:	89 55 08             	mov    %edx,0x8(%ebp)
  801679:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80167c:	8b 45 08             	mov    0x8(%ebp),%eax
  80167f:	8a 00                	mov    (%eax),%al
  801681:	84 c0                	test   %al,%al
  801683:	74 18                	je     80169d <strsplit+0x52>
  801685:	8b 45 08             	mov    0x8(%ebp),%eax
  801688:	8a 00                	mov    (%eax),%al
  80168a:	0f be c0             	movsbl %al,%eax
  80168d:	50                   	push   %eax
  80168e:	ff 75 0c             	pushl  0xc(%ebp)
  801691:	e8 13 fb ff ff       	call   8011a9 <strchr>
  801696:	83 c4 08             	add    $0x8,%esp
  801699:	85 c0                	test   %eax,%eax
  80169b:	75 d3                	jne    801670 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80169d:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a0:	8a 00                	mov    (%eax),%al
  8016a2:	84 c0                	test   %al,%al
  8016a4:	74 5a                	je     801700 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016a6:	8b 45 14             	mov    0x14(%ebp),%eax
  8016a9:	8b 00                	mov    (%eax),%eax
  8016ab:	83 f8 0f             	cmp    $0xf,%eax
  8016ae:	75 07                	jne    8016b7 <strsplit+0x6c>
		{
			return 0;
  8016b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b5:	eb 66                	jmp    80171d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8016ba:	8b 00                	mov    (%eax),%eax
  8016bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8016bf:	8b 55 14             	mov    0x14(%ebp),%edx
  8016c2:	89 0a                	mov    %ecx,(%edx)
  8016c4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ce:	01 c2                	add    %eax,%edx
  8016d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016d5:	eb 03                	jmp    8016da <strsplit+0x8f>
			string++;
  8016d7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 8b                	je     80166e <strsplit+0x23>
  8016e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016e6:	8a 00                	mov    (%eax),%al
  8016e8:	0f be c0             	movsbl %al,%eax
  8016eb:	50                   	push   %eax
  8016ec:	ff 75 0c             	pushl  0xc(%ebp)
  8016ef:	e8 b5 fa ff ff       	call   8011a9 <strchr>
  8016f4:	83 c4 08             	add    $0x8,%esp
  8016f7:	85 c0                	test   %eax,%eax
  8016f9:	74 dc                	je     8016d7 <strsplit+0x8c>
			string++;
	}
  8016fb:	e9 6e ff ff ff       	jmp    80166e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801700:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801701:	8b 45 14             	mov    0x14(%ebp),%eax
  801704:	8b 00                	mov    (%eax),%eax
  801706:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80170d:	8b 45 10             	mov    0x10(%ebp),%eax
  801710:	01 d0                	add    %edx,%eax
  801712:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801718:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80171d:	c9                   	leave  
  80171e:	c3                   	ret    

0080171f <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80171f:	55                   	push   %ebp
  801720:	89 e5                	mov    %esp,%ebp
  801722:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801725:	a1 04 50 80 00       	mov    0x805004,%eax
  80172a:	85 c0                	test   %eax,%eax
  80172c:	74 1f                	je     80174d <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80172e:	e8 1d 00 00 00       	call   801750 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801733:	83 ec 0c             	sub    $0xc,%esp
  801736:	68 d0 3d 80 00       	push   $0x803dd0
  80173b:	e8 55 f2 ff ff       	call   800995 <cprintf>
  801740:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801743:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  80174a:	00 00 00 
	}
}
  80174d:	90                   	nop
  80174e:	c9                   	leave  
  80174f:	c3                   	ret    

00801750 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801750:	55                   	push   %ebp
  801751:	89 e5                	mov    %esp,%ebp
  801753:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801756:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80175d:	00 00 00 
  801760:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801767:	00 00 00 
  80176a:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801771:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801774:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  80177b:	00 00 00 
  80177e:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801785:	00 00 00 
  801788:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  80178f:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801792:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801799:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80179c:	c1 e8 0c             	shr    $0xc,%eax
  80179f:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  8017a4:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8017ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ae:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017b3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017b8:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  8017bd:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8017c4:	a1 20 51 80 00       	mov    0x805120,%eax
  8017c9:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8017cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8017d0:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8017d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8017da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017dd:	01 d0                	add    %edx,%eax
  8017df:	48                   	dec    %eax
  8017e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8017e3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017e6:	ba 00 00 00 00       	mov    $0x0,%edx
  8017eb:	f7 75 e4             	divl   -0x1c(%ebp)
  8017ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8017f1:	29 d0                	sub    %edx,%eax
  8017f3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8017f6:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8017fd:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801800:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801805:	2d 00 10 00 00       	sub    $0x1000,%eax
  80180a:	83 ec 04             	sub    $0x4,%esp
  80180d:	6a 07                	push   $0x7
  80180f:	ff 75 e8             	pushl  -0x18(%ebp)
  801812:	50                   	push   %eax
  801813:	e8 3d 06 00 00       	call   801e55 <sys_allocate_chunk>
  801818:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80181b:	a1 20 51 80 00       	mov    0x805120,%eax
  801820:	83 ec 0c             	sub    $0xc,%esp
  801823:	50                   	push   %eax
  801824:	e8 b2 0c 00 00       	call   8024db <initialize_MemBlocksList>
  801829:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  80182c:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801831:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801834:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801838:	0f 84 f3 00 00 00    	je     801931 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  80183e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801842:	75 14                	jne    801858 <initialize_dyn_block_system+0x108>
  801844:	83 ec 04             	sub    $0x4,%esp
  801847:	68 f5 3d 80 00       	push   $0x803df5
  80184c:	6a 36                	push   $0x36
  80184e:	68 13 3e 80 00       	push   $0x803e13
  801853:	e8 89 ee ff ff       	call   8006e1 <_panic>
  801858:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80185b:	8b 00                	mov    (%eax),%eax
  80185d:	85 c0                	test   %eax,%eax
  80185f:	74 10                	je     801871 <initialize_dyn_block_system+0x121>
  801861:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801864:	8b 00                	mov    (%eax),%eax
  801866:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801869:	8b 52 04             	mov    0x4(%edx),%edx
  80186c:	89 50 04             	mov    %edx,0x4(%eax)
  80186f:	eb 0b                	jmp    80187c <initialize_dyn_block_system+0x12c>
  801871:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801874:	8b 40 04             	mov    0x4(%eax),%eax
  801877:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80187c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80187f:	8b 40 04             	mov    0x4(%eax),%eax
  801882:	85 c0                	test   %eax,%eax
  801884:	74 0f                	je     801895 <initialize_dyn_block_system+0x145>
  801886:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801889:	8b 40 04             	mov    0x4(%eax),%eax
  80188c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80188f:	8b 12                	mov    (%edx),%edx
  801891:	89 10                	mov    %edx,(%eax)
  801893:	eb 0a                	jmp    80189f <initialize_dyn_block_system+0x14f>
  801895:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801898:	8b 00                	mov    (%eax),%eax
  80189a:	a3 48 51 80 00       	mov    %eax,0x805148
  80189f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018a8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018ab:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018b2:	a1 54 51 80 00       	mov    0x805154,%eax
  8018b7:	48                   	dec    %eax
  8018b8:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  8018bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018c0:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8018c7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018ca:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8018d1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8018d5:	75 14                	jne    8018eb <initialize_dyn_block_system+0x19b>
  8018d7:	83 ec 04             	sub    $0x4,%esp
  8018da:	68 20 3e 80 00       	push   $0x803e20
  8018df:	6a 3e                	push   $0x3e
  8018e1:	68 13 3e 80 00       	push   $0x803e13
  8018e6:	e8 f6 ed ff ff       	call   8006e1 <_panic>
  8018eb:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8018f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018f4:	89 10                	mov    %edx,(%eax)
  8018f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018f9:	8b 00                	mov    (%eax),%eax
  8018fb:	85 c0                	test   %eax,%eax
  8018fd:	74 0d                	je     80190c <initialize_dyn_block_system+0x1bc>
  8018ff:	a1 38 51 80 00       	mov    0x805138,%eax
  801904:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801907:	89 50 04             	mov    %edx,0x4(%eax)
  80190a:	eb 08                	jmp    801914 <initialize_dyn_block_system+0x1c4>
  80190c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80190f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801914:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801917:	a3 38 51 80 00       	mov    %eax,0x805138
  80191c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80191f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801926:	a1 44 51 80 00       	mov    0x805144,%eax
  80192b:	40                   	inc    %eax
  80192c:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801931:	90                   	nop
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
  801937:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  80193a:	e8 e0 fd ff ff       	call   80171f <InitializeUHeap>
		if (size == 0) return NULL ;
  80193f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801943:	75 07                	jne    80194c <malloc+0x18>
  801945:	b8 00 00 00 00       	mov    $0x0,%eax
  80194a:	eb 7f                	jmp    8019cb <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80194c:	e8 d2 08 00 00       	call   802223 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801951:	85 c0                	test   %eax,%eax
  801953:	74 71                	je     8019c6 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801955:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80195c:	8b 55 08             	mov    0x8(%ebp),%edx
  80195f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801962:	01 d0                	add    %edx,%eax
  801964:	48                   	dec    %eax
  801965:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801968:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80196b:	ba 00 00 00 00       	mov    $0x0,%edx
  801970:	f7 75 f4             	divl   -0xc(%ebp)
  801973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801976:	29 d0                	sub    %edx,%eax
  801978:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  80197b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801982:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801989:	76 07                	jbe    801992 <malloc+0x5e>
					return NULL ;
  80198b:	b8 00 00 00 00       	mov    $0x0,%eax
  801990:	eb 39                	jmp    8019cb <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801992:	83 ec 0c             	sub    $0xc,%esp
  801995:	ff 75 08             	pushl  0x8(%ebp)
  801998:	e8 e6 0d 00 00       	call   802783 <alloc_block_FF>
  80199d:	83 c4 10             	add    $0x10,%esp
  8019a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  8019a3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019a7:	74 16                	je     8019bf <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  8019a9:	83 ec 0c             	sub    $0xc,%esp
  8019ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8019af:	e8 37 0c 00 00       	call   8025eb <insert_sorted_allocList>
  8019b4:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  8019b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019ba:	8b 40 08             	mov    0x8(%eax),%eax
  8019bd:	eb 0c                	jmp    8019cb <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8019bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8019c4:	eb 05                	jmp    8019cb <malloc+0x97>
				}
		}
	return 0;
  8019c6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019cb:	c9                   	leave  
  8019cc:	c3                   	ret    

008019cd <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8019d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8019d9:	83 ec 08             	sub    $0x8,%esp
  8019dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8019df:	68 40 50 80 00       	push   $0x805040
  8019e4:	e8 cf 0b 00 00       	call   8025b8 <find_block>
  8019e9:	83 c4 10             	add    $0x10,%esp
  8019ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8019ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8019f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8019f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019fb:	8b 40 08             	mov    0x8(%eax),%eax
  8019fe:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801a01:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a05:	0f 84 a1 00 00 00    	je     801aac <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801a0b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a0f:	75 17                	jne    801a28 <free+0x5b>
  801a11:	83 ec 04             	sub    $0x4,%esp
  801a14:	68 f5 3d 80 00       	push   $0x803df5
  801a19:	68 80 00 00 00       	push   $0x80
  801a1e:	68 13 3e 80 00       	push   $0x803e13
  801a23:	e8 b9 ec ff ff       	call   8006e1 <_panic>
  801a28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2b:	8b 00                	mov    (%eax),%eax
  801a2d:	85 c0                	test   %eax,%eax
  801a2f:	74 10                	je     801a41 <free+0x74>
  801a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a34:	8b 00                	mov    (%eax),%eax
  801a36:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a39:	8b 52 04             	mov    0x4(%edx),%edx
  801a3c:	89 50 04             	mov    %edx,0x4(%eax)
  801a3f:	eb 0b                	jmp    801a4c <free+0x7f>
  801a41:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a44:	8b 40 04             	mov    0x4(%eax),%eax
  801a47:	a3 44 50 80 00       	mov    %eax,0x805044
  801a4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a4f:	8b 40 04             	mov    0x4(%eax),%eax
  801a52:	85 c0                	test   %eax,%eax
  801a54:	74 0f                	je     801a65 <free+0x98>
  801a56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a59:	8b 40 04             	mov    0x4(%eax),%eax
  801a5c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a5f:	8b 12                	mov    (%edx),%edx
  801a61:	89 10                	mov    %edx,(%eax)
  801a63:	eb 0a                	jmp    801a6f <free+0xa2>
  801a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a68:	8b 00                	mov    (%eax),%eax
  801a6a:	a3 40 50 80 00       	mov    %eax,0x805040
  801a6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a72:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801a78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801a82:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801a87:	48                   	dec    %eax
  801a88:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801a8d:	83 ec 0c             	sub    $0xc,%esp
  801a90:	ff 75 f0             	pushl  -0x10(%ebp)
  801a93:	e8 29 12 00 00       	call   802cc1 <insert_sorted_with_merge_freeList>
  801a98:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801a9b:	83 ec 08             	sub    $0x8,%esp
  801a9e:	ff 75 ec             	pushl  -0x14(%ebp)
  801aa1:	ff 75 e8             	pushl  -0x18(%ebp)
  801aa4:	e8 74 03 00 00       	call   801e1d <sys_free_user_mem>
  801aa9:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801aac:	90                   	nop
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
  801ab2:	83 ec 38             	sub    $0x38,%esp
  801ab5:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab8:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801abb:	e8 5f fc ff ff       	call   80171f <InitializeUHeap>
	if (size == 0) return NULL ;
  801ac0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801ac4:	75 0a                	jne    801ad0 <smalloc+0x21>
  801ac6:	b8 00 00 00 00       	mov    $0x0,%eax
  801acb:	e9 b2 00 00 00       	jmp    801b82 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801ad0:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801ad7:	76 0a                	jbe    801ae3 <smalloc+0x34>
		return NULL;
  801ad9:	b8 00 00 00 00       	mov    $0x0,%eax
  801ade:	e9 9f 00 00 00       	jmp    801b82 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801ae3:	e8 3b 07 00 00       	call   802223 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ae8:	85 c0                	test   %eax,%eax
  801aea:	0f 84 8d 00 00 00    	je     801b7d <smalloc+0xce>
	struct MemBlock *b = NULL;
  801af0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801af7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801afe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b04:	01 d0                	add    %edx,%eax
  801b06:	48                   	dec    %eax
  801b07:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b0d:	ba 00 00 00 00       	mov    $0x0,%edx
  801b12:	f7 75 f0             	divl   -0x10(%ebp)
  801b15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b18:	29 d0                	sub    %edx,%eax
  801b1a:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801b1d:	83 ec 0c             	sub    $0xc,%esp
  801b20:	ff 75 e8             	pushl  -0x18(%ebp)
  801b23:	e8 5b 0c 00 00       	call   802783 <alloc_block_FF>
  801b28:	83 c4 10             	add    $0x10,%esp
  801b2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801b2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b32:	75 07                	jne    801b3b <smalloc+0x8c>
			return NULL;
  801b34:	b8 00 00 00 00       	mov    $0x0,%eax
  801b39:	eb 47                	jmp    801b82 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801b3b:	83 ec 0c             	sub    $0xc,%esp
  801b3e:	ff 75 f4             	pushl  -0xc(%ebp)
  801b41:	e8 a5 0a 00 00       	call   8025eb <insert_sorted_allocList>
  801b46:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b4c:	8b 40 08             	mov    0x8(%eax),%eax
  801b4f:	89 c2                	mov    %eax,%edx
  801b51:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801b55:	52                   	push   %edx
  801b56:	50                   	push   %eax
  801b57:	ff 75 0c             	pushl  0xc(%ebp)
  801b5a:	ff 75 08             	pushl  0x8(%ebp)
  801b5d:	e8 46 04 00 00       	call   801fa8 <sys_createSharedObject>
  801b62:	83 c4 10             	add    $0x10,%esp
  801b65:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801b68:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801b6c:	78 08                	js     801b76 <smalloc+0xc7>
		return (void *)b->sva;
  801b6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b71:	8b 40 08             	mov    0x8(%eax),%eax
  801b74:	eb 0c                	jmp    801b82 <smalloc+0xd3>
		}else{
		return NULL;
  801b76:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7b:	eb 05                	jmp    801b82 <smalloc+0xd3>
			}

	}return NULL;
  801b7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801b8a:	e8 90 fb ff ff       	call   80171f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801b8f:	e8 8f 06 00 00       	call   802223 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b94:	85 c0                	test   %eax,%eax
  801b96:	0f 84 ad 00 00 00    	je     801c49 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801b9c:	83 ec 08             	sub    $0x8,%esp
  801b9f:	ff 75 0c             	pushl  0xc(%ebp)
  801ba2:	ff 75 08             	pushl  0x8(%ebp)
  801ba5:	e8 28 04 00 00       	call   801fd2 <sys_getSizeOfSharedObject>
  801baa:	83 c4 10             	add    $0x10,%esp
  801bad:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801bb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bb4:	79 0a                	jns    801bc0 <sget+0x3c>
    {
    	return NULL;
  801bb6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bbb:	e9 8e 00 00 00       	jmp    801c4e <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801bc0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801bc7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801bce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801bd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801bd4:	01 d0                	add    %edx,%eax
  801bd6:	48                   	dec    %eax
  801bd7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801bda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801bdd:	ba 00 00 00 00       	mov    $0x0,%edx
  801be2:	f7 75 ec             	divl   -0x14(%ebp)
  801be5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801be8:	29 d0                	sub    %edx,%eax
  801bea:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801bed:	83 ec 0c             	sub    $0xc,%esp
  801bf0:	ff 75 e4             	pushl  -0x1c(%ebp)
  801bf3:	e8 8b 0b 00 00       	call   802783 <alloc_block_FF>
  801bf8:	83 c4 10             	add    $0x10,%esp
  801bfb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801bfe:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c02:	75 07                	jne    801c0b <sget+0x87>
				return NULL;
  801c04:	b8 00 00 00 00       	mov    $0x0,%eax
  801c09:	eb 43                	jmp    801c4e <sget+0xca>
			}
			insert_sorted_allocList(b);
  801c0b:	83 ec 0c             	sub    $0xc,%esp
  801c0e:	ff 75 f0             	pushl  -0x10(%ebp)
  801c11:	e8 d5 09 00 00       	call   8025eb <insert_sorted_allocList>
  801c16:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801c19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c1c:	8b 40 08             	mov    0x8(%eax),%eax
  801c1f:	83 ec 04             	sub    $0x4,%esp
  801c22:	50                   	push   %eax
  801c23:	ff 75 0c             	pushl  0xc(%ebp)
  801c26:	ff 75 08             	pushl  0x8(%ebp)
  801c29:	e8 c1 03 00 00       	call   801fef <sys_getSharedObject>
  801c2e:	83 c4 10             	add    $0x10,%esp
  801c31:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801c34:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c38:	78 08                	js     801c42 <sget+0xbe>
			return (void *)b->sva;
  801c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3d:	8b 40 08             	mov    0x8(%eax),%eax
  801c40:	eb 0c                	jmp    801c4e <sget+0xca>
			}else{
			return NULL;
  801c42:	b8 00 00 00 00       	mov    $0x0,%eax
  801c47:	eb 05                	jmp    801c4e <sget+0xca>
			}
    }}return NULL;
  801c49:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
  801c53:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c56:	e8 c4 fa ff ff       	call   80171f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c5b:	83 ec 04             	sub    $0x4,%esp
  801c5e:	68 44 3e 80 00       	push   $0x803e44
  801c63:	68 03 01 00 00       	push   $0x103
  801c68:	68 13 3e 80 00       	push   $0x803e13
  801c6d:	e8 6f ea ff ff       	call   8006e1 <_panic>

00801c72 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801c72:	55                   	push   %ebp
  801c73:	89 e5                	mov    %esp,%ebp
  801c75:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801c78:	83 ec 04             	sub    $0x4,%esp
  801c7b:	68 6c 3e 80 00       	push   $0x803e6c
  801c80:	68 17 01 00 00       	push   $0x117
  801c85:	68 13 3e 80 00       	push   $0x803e13
  801c8a:	e8 52 ea ff ff       	call   8006e1 <_panic>

00801c8f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801c8f:	55                   	push   %ebp
  801c90:	89 e5                	mov    %esp,%ebp
  801c92:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801c95:	83 ec 04             	sub    $0x4,%esp
  801c98:	68 90 3e 80 00       	push   $0x803e90
  801c9d:	68 22 01 00 00       	push   $0x122
  801ca2:	68 13 3e 80 00       	push   $0x803e13
  801ca7:	e8 35 ea ff ff       	call   8006e1 <_panic>

00801cac <shrink>:

}
void shrink(uint32 newSize)
{
  801cac:	55                   	push   %ebp
  801cad:	89 e5                	mov    %esp,%ebp
  801caf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cb2:	83 ec 04             	sub    $0x4,%esp
  801cb5:	68 90 3e 80 00       	push   $0x803e90
  801cba:	68 27 01 00 00       	push   $0x127
  801cbf:	68 13 3e 80 00       	push   $0x803e13
  801cc4:	e8 18 ea ff ff       	call   8006e1 <_panic>

00801cc9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
  801ccc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ccf:	83 ec 04             	sub    $0x4,%esp
  801cd2:	68 90 3e 80 00       	push   $0x803e90
  801cd7:	68 2c 01 00 00       	push   $0x12c
  801cdc:	68 13 3e 80 00       	push   $0x803e13
  801ce1:	e8 fb e9 ff ff       	call   8006e1 <_panic>

00801ce6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
  801ce9:	57                   	push   %edi
  801cea:	56                   	push   %esi
  801ceb:	53                   	push   %ebx
  801cec:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801cef:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cfb:	8b 7d 18             	mov    0x18(%ebp),%edi
  801cfe:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d01:	cd 30                	int    $0x30
  801d03:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d06:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d09:	83 c4 10             	add    $0x10,%esp
  801d0c:	5b                   	pop    %ebx
  801d0d:	5e                   	pop    %esi
  801d0e:	5f                   	pop    %edi
  801d0f:	5d                   	pop    %ebp
  801d10:	c3                   	ret    

00801d11 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 04             	sub    $0x4,%esp
  801d17:	8b 45 10             	mov    0x10(%ebp),%eax
  801d1a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d1d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	52                   	push   %edx
  801d29:	ff 75 0c             	pushl  0xc(%ebp)
  801d2c:	50                   	push   %eax
  801d2d:	6a 00                	push   $0x0
  801d2f:	e8 b2 ff ff ff       	call   801ce6 <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
}
  801d37:	90                   	nop
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_cgetc>:

int
sys_cgetc(void)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 01                	push   $0x1
  801d49:	e8 98 ff ff ff       	call   801ce6 <syscall>
  801d4e:	83 c4 18             	add    $0x18,%esp
}
  801d51:	c9                   	leave  
  801d52:	c3                   	ret    

00801d53 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d53:	55                   	push   %ebp
  801d54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d59:	8b 45 08             	mov    0x8(%ebp),%eax
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	52                   	push   %edx
  801d63:	50                   	push   %eax
  801d64:	6a 05                	push   $0x5
  801d66:	e8 7b ff ff ff       	call   801ce6 <syscall>
  801d6b:	83 c4 18             	add    $0x18,%esp
}
  801d6e:	c9                   	leave  
  801d6f:	c3                   	ret    

00801d70 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801d70:	55                   	push   %ebp
  801d71:	89 e5                	mov    %esp,%ebp
  801d73:	56                   	push   %esi
  801d74:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801d75:	8b 75 18             	mov    0x18(%ebp),%esi
  801d78:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	56                   	push   %esi
  801d85:	53                   	push   %ebx
  801d86:	51                   	push   %ecx
  801d87:	52                   	push   %edx
  801d88:	50                   	push   %eax
  801d89:	6a 06                	push   $0x6
  801d8b:	e8 56 ff ff ff       	call   801ce6 <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
}
  801d93:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801d96:	5b                   	pop    %ebx
  801d97:	5e                   	pop    %esi
  801d98:	5d                   	pop    %ebp
  801d99:	c3                   	ret    

00801d9a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801d9d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801da0:	8b 45 08             	mov    0x8(%ebp),%eax
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	52                   	push   %edx
  801daa:	50                   	push   %eax
  801dab:	6a 07                	push   $0x7
  801dad:	e8 34 ff ff ff       	call   801ce6 <syscall>
  801db2:	83 c4 18             	add    $0x18,%esp
}
  801db5:	c9                   	leave  
  801db6:	c3                   	ret    

00801db7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801db7:	55                   	push   %ebp
  801db8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801dba:	6a 00                	push   $0x0
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	ff 75 0c             	pushl  0xc(%ebp)
  801dc3:	ff 75 08             	pushl  0x8(%ebp)
  801dc6:	6a 08                	push   $0x8
  801dc8:	e8 19 ff ff ff       	call   801ce6 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 00                	push   $0x0
  801ddb:	6a 00                	push   $0x0
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 09                	push   $0x9
  801de1:	e8 00 ff ff ff       	call   801ce6 <syscall>
  801de6:	83 c4 18             	add    $0x18,%esp
}
  801de9:	c9                   	leave  
  801dea:	c3                   	ret    

00801deb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801deb:	55                   	push   %ebp
  801dec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 0a                	push   $0xa
  801dfa:	e8 e7 fe ff ff       	call   801ce6 <syscall>
  801dff:	83 c4 18             	add    $0x18,%esp
}
  801e02:	c9                   	leave  
  801e03:	c3                   	ret    

00801e04 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e04:	55                   	push   %ebp
  801e05:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 0b                	push   $0xb
  801e13:	e8 ce fe ff ff       	call   801ce6 <syscall>
  801e18:	83 c4 18             	add    $0x18,%esp
}
  801e1b:	c9                   	leave  
  801e1c:	c3                   	ret    

00801e1d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e1d:	55                   	push   %ebp
  801e1e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	ff 75 0c             	pushl  0xc(%ebp)
  801e29:	ff 75 08             	pushl  0x8(%ebp)
  801e2c:	6a 0f                	push   $0xf
  801e2e:	e8 b3 fe ff ff       	call   801ce6 <syscall>
  801e33:	83 c4 18             	add    $0x18,%esp
	return;
  801e36:	90                   	nop
}
  801e37:	c9                   	leave  
  801e38:	c3                   	ret    

00801e39 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e39:	55                   	push   %ebp
  801e3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	ff 75 0c             	pushl  0xc(%ebp)
  801e45:	ff 75 08             	pushl  0x8(%ebp)
  801e48:	6a 10                	push   $0x10
  801e4a:	e8 97 fe ff ff       	call   801ce6 <syscall>
  801e4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e52:	90                   	nop
}
  801e53:	c9                   	leave  
  801e54:	c3                   	ret    

00801e55 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e55:	55                   	push   %ebp
  801e56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	ff 75 10             	pushl  0x10(%ebp)
  801e5f:	ff 75 0c             	pushl  0xc(%ebp)
  801e62:	ff 75 08             	pushl  0x8(%ebp)
  801e65:	6a 11                	push   $0x11
  801e67:	e8 7a fe ff ff       	call   801ce6 <syscall>
  801e6c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e6f:	90                   	nop
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801e75:	6a 00                	push   $0x0
  801e77:	6a 00                	push   $0x0
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 0c                	push   $0xc
  801e81:	e8 60 fe ff ff       	call   801ce6 <syscall>
  801e86:	83 c4 18             	add    $0x18,%esp
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	ff 75 08             	pushl  0x8(%ebp)
  801e99:	6a 0d                	push   $0xd
  801e9b:	e8 46 fe ff ff       	call   801ce6 <syscall>
  801ea0:	83 c4 18             	add    $0x18,%esp
}
  801ea3:	c9                   	leave  
  801ea4:	c3                   	ret    

00801ea5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ea5:	55                   	push   %ebp
  801ea6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 0e                	push   $0xe
  801eb4:	e8 2d fe ff ff       	call   801ce6 <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
}
  801ebc:	90                   	nop
  801ebd:	c9                   	leave  
  801ebe:	c3                   	ret    

00801ebf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ebf:	55                   	push   %ebp
  801ec0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 13                	push   $0x13
  801ece:	e8 13 fe ff ff       	call   801ce6 <syscall>
  801ed3:	83 c4 18             	add    $0x18,%esp
}
  801ed6:	90                   	nop
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 00                	push   $0x0
  801ee4:	6a 00                	push   $0x0
  801ee6:	6a 14                	push   $0x14
  801ee8:	e8 f9 fd ff ff       	call   801ce6 <syscall>
  801eed:	83 c4 18             	add    $0x18,%esp
}
  801ef0:	90                   	nop
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 04             	sub    $0x4,%esp
  801ef9:	8b 45 08             	mov    0x8(%ebp),%eax
  801efc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801eff:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	50                   	push   %eax
  801f0c:	6a 15                	push   $0x15
  801f0e:	e8 d3 fd ff ff       	call   801ce6 <syscall>
  801f13:	83 c4 18             	add    $0x18,%esp
}
  801f16:	90                   	nop
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	6a 16                	push   $0x16
  801f28:	e8 b9 fd ff ff       	call   801ce6 <syscall>
  801f2d:	83 c4 18             	add    $0x18,%esp
}
  801f30:	90                   	nop
  801f31:	c9                   	leave  
  801f32:	c3                   	ret    

00801f33 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f33:	55                   	push   %ebp
  801f34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	6a 00                	push   $0x0
  801f3b:	6a 00                	push   $0x0
  801f3d:	6a 00                	push   $0x0
  801f3f:	ff 75 0c             	pushl  0xc(%ebp)
  801f42:	50                   	push   %eax
  801f43:	6a 17                	push   $0x17
  801f45:	e8 9c fd ff ff       	call   801ce6 <syscall>
  801f4a:	83 c4 18             	add    $0x18,%esp
}
  801f4d:	c9                   	leave  
  801f4e:	c3                   	ret    

00801f4f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f4f:	55                   	push   %ebp
  801f50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f55:	8b 45 08             	mov    0x8(%ebp),%eax
  801f58:	6a 00                	push   $0x0
  801f5a:	6a 00                	push   $0x0
  801f5c:	6a 00                	push   $0x0
  801f5e:	52                   	push   %edx
  801f5f:	50                   	push   %eax
  801f60:	6a 1a                	push   $0x1a
  801f62:	e8 7f fd ff ff       	call   801ce6 <syscall>
  801f67:	83 c4 18             	add    $0x18,%esp
}
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f72:	8b 45 08             	mov    0x8(%ebp),%eax
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	52                   	push   %edx
  801f7c:	50                   	push   %eax
  801f7d:	6a 18                	push   $0x18
  801f7f:	e8 62 fd ff ff       	call   801ce6 <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
}
  801f87:	90                   	nop
  801f88:	c9                   	leave  
  801f89:	c3                   	ret    

00801f8a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801f8a:	55                   	push   %ebp
  801f8b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f90:	8b 45 08             	mov    0x8(%ebp),%eax
  801f93:	6a 00                	push   $0x0
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	52                   	push   %edx
  801f9a:	50                   	push   %eax
  801f9b:	6a 19                	push   $0x19
  801f9d:	e8 44 fd ff ff       	call   801ce6 <syscall>
  801fa2:	83 c4 18             	add    $0x18,%esp
}
  801fa5:	90                   	nop
  801fa6:	c9                   	leave  
  801fa7:	c3                   	ret    

00801fa8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fa8:	55                   	push   %ebp
  801fa9:	89 e5                	mov    %esp,%ebp
  801fab:	83 ec 04             	sub    $0x4,%esp
  801fae:	8b 45 10             	mov    0x10(%ebp),%eax
  801fb1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801fb4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801fb7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fbe:	6a 00                	push   $0x0
  801fc0:	51                   	push   %ecx
  801fc1:	52                   	push   %edx
  801fc2:	ff 75 0c             	pushl  0xc(%ebp)
  801fc5:	50                   	push   %eax
  801fc6:	6a 1b                	push   $0x1b
  801fc8:	e8 19 fd ff ff       	call   801ce6 <syscall>
  801fcd:	83 c4 18             	add    $0x18,%esp
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801fd5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdb:	6a 00                	push   $0x0
  801fdd:	6a 00                	push   $0x0
  801fdf:	6a 00                	push   $0x0
  801fe1:	52                   	push   %edx
  801fe2:	50                   	push   %eax
  801fe3:	6a 1c                	push   $0x1c
  801fe5:	e8 fc fc ff ff       	call   801ce6 <syscall>
  801fea:	83 c4 18             	add    $0x18,%esp
}
  801fed:	c9                   	leave  
  801fee:	c3                   	ret    

00801fef <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801fef:	55                   	push   %ebp
  801ff0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ff2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ff5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	6a 00                	push   $0x0
  801ffd:	6a 00                	push   $0x0
  801fff:	51                   	push   %ecx
  802000:	52                   	push   %edx
  802001:	50                   	push   %eax
  802002:	6a 1d                	push   $0x1d
  802004:	e8 dd fc ff ff       	call   801ce6 <syscall>
  802009:	83 c4 18             	add    $0x18,%esp
}
  80200c:	c9                   	leave  
  80200d:	c3                   	ret    

0080200e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80200e:	55                   	push   %ebp
  80200f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  802011:	8b 55 0c             	mov    0xc(%ebp),%edx
  802014:	8b 45 08             	mov    0x8(%ebp),%eax
  802017:	6a 00                	push   $0x0
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	52                   	push   %edx
  80201e:	50                   	push   %eax
  80201f:	6a 1e                	push   $0x1e
  802021:	e8 c0 fc ff ff       	call   801ce6 <syscall>
  802026:	83 c4 18             	add    $0x18,%esp
}
  802029:	c9                   	leave  
  80202a:	c3                   	ret    

0080202b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80202b:	55                   	push   %ebp
  80202c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80202e:	6a 00                	push   $0x0
  802030:	6a 00                	push   $0x0
  802032:	6a 00                	push   $0x0
  802034:	6a 00                	push   $0x0
  802036:	6a 00                	push   $0x0
  802038:	6a 1f                	push   $0x1f
  80203a:	e8 a7 fc ff ff       	call   801ce6 <syscall>
  80203f:	83 c4 18             	add    $0x18,%esp
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802047:	8b 45 08             	mov    0x8(%ebp),%eax
  80204a:	6a 00                	push   $0x0
  80204c:	ff 75 14             	pushl  0x14(%ebp)
  80204f:	ff 75 10             	pushl  0x10(%ebp)
  802052:	ff 75 0c             	pushl  0xc(%ebp)
  802055:	50                   	push   %eax
  802056:	6a 20                	push   $0x20
  802058:	e8 89 fc ff ff       	call   801ce6 <syscall>
  80205d:	83 c4 18             	add    $0x18,%esp
}
  802060:	c9                   	leave  
  802061:	c3                   	ret    

00802062 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802062:	55                   	push   %ebp
  802063:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802065:	8b 45 08             	mov    0x8(%ebp),%eax
  802068:	6a 00                	push   $0x0
  80206a:	6a 00                	push   $0x0
  80206c:	6a 00                	push   $0x0
  80206e:	6a 00                	push   $0x0
  802070:	50                   	push   %eax
  802071:	6a 21                	push   $0x21
  802073:	e8 6e fc ff ff       	call   801ce6 <syscall>
  802078:	83 c4 18             	add    $0x18,%esp
}
  80207b:	90                   	nop
  80207c:	c9                   	leave  
  80207d:	c3                   	ret    

0080207e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  80207e:	55                   	push   %ebp
  80207f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802081:	8b 45 08             	mov    0x8(%ebp),%eax
  802084:	6a 00                	push   $0x0
  802086:	6a 00                	push   $0x0
  802088:	6a 00                	push   $0x0
  80208a:	6a 00                	push   $0x0
  80208c:	50                   	push   %eax
  80208d:	6a 22                	push   $0x22
  80208f:	e8 52 fc ff ff       	call   801ce6 <syscall>
  802094:	83 c4 18             	add    $0x18,%esp
}
  802097:	c9                   	leave  
  802098:	c3                   	ret    

00802099 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802099:	55                   	push   %ebp
  80209a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80209c:	6a 00                	push   $0x0
  80209e:	6a 00                	push   $0x0
  8020a0:	6a 00                	push   $0x0
  8020a2:	6a 00                	push   $0x0
  8020a4:	6a 00                	push   $0x0
  8020a6:	6a 02                	push   $0x2
  8020a8:	e8 39 fc ff ff       	call   801ce6 <syscall>
  8020ad:	83 c4 18             	add    $0x18,%esp
}
  8020b0:	c9                   	leave  
  8020b1:	c3                   	ret    

008020b2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020b2:	55                   	push   %ebp
  8020b3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020b5:	6a 00                	push   $0x0
  8020b7:	6a 00                	push   $0x0
  8020b9:	6a 00                	push   $0x0
  8020bb:	6a 00                	push   $0x0
  8020bd:	6a 00                	push   $0x0
  8020bf:	6a 03                	push   $0x3
  8020c1:	e8 20 fc ff ff       	call   801ce6 <syscall>
  8020c6:	83 c4 18             	add    $0x18,%esp
}
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8020ce:	6a 00                	push   $0x0
  8020d0:	6a 00                	push   $0x0
  8020d2:	6a 00                	push   $0x0
  8020d4:	6a 00                	push   $0x0
  8020d6:	6a 00                	push   $0x0
  8020d8:	6a 04                	push   $0x4
  8020da:	e8 07 fc ff ff       	call   801ce6 <syscall>
  8020df:	83 c4 18             	add    $0x18,%esp
}
  8020e2:	c9                   	leave  
  8020e3:	c3                   	ret    

008020e4 <sys_exit_env>:


void sys_exit_env(void)
{
  8020e4:	55                   	push   %ebp
  8020e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8020e7:	6a 00                	push   $0x0
  8020e9:	6a 00                	push   $0x0
  8020eb:	6a 00                	push   $0x0
  8020ed:	6a 00                	push   $0x0
  8020ef:	6a 00                	push   $0x0
  8020f1:	6a 23                	push   $0x23
  8020f3:	e8 ee fb ff ff       	call   801ce6 <syscall>
  8020f8:	83 c4 18             	add    $0x18,%esp
}
  8020fb:	90                   	nop
  8020fc:	c9                   	leave  
  8020fd:	c3                   	ret    

008020fe <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8020fe:	55                   	push   %ebp
  8020ff:	89 e5                	mov    %esp,%ebp
  802101:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802104:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802107:	8d 50 04             	lea    0x4(%eax),%edx
  80210a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	52                   	push   %edx
  802114:	50                   	push   %eax
  802115:	6a 24                	push   $0x24
  802117:	e8 ca fb ff ff       	call   801ce6 <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
	return result;
  80211f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  802122:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802125:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802128:	89 01                	mov    %eax,(%ecx)
  80212a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80212d:	8b 45 08             	mov    0x8(%ebp),%eax
  802130:	c9                   	leave  
  802131:	c2 04 00             	ret    $0x4

00802134 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802137:	6a 00                	push   $0x0
  802139:	6a 00                	push   $0x0
  80213b:	ff 75 10             	pushl  0x10(%ebp)
  80213e:	ff 75 0c             	pushl  0xc(%ebp)
  802141:	ff 75 08             	pushl  0x8(%ebp)
  802144:	6a 12                	push   $0x12
  802146:	e8 9b fb ff ff       	call   801ce6 <syscall>
  80214b:	83 c4 18             	add    $0x18,%esp
	return ;
  80214e:	90                   	nop
}
  80214f:	c9                   	leave  
  802150:	c3                   	ret    

00802151 <sys_rcr2>:
uint32 sys_rcr2()
{
  802151:	55                   	push   %ebp
  802152:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802154:	6a 00                	push   $0x0
  802156:	6a 00                	push   $0x0
  802158:	6a 00                	push   $0x0
  80215a:	6a 00                	push   $0x0
  80215c:	6a 00                	push   $0x0
  80215e:	6a 25                	push   $0x25
  802160:	e8 81 fb ff ff       	call   801ce6 <syscall>
  802165:	83 c4 18             	add    $0x18,%esp
}
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	83 ec 04             	sub    $0x4,%esp
  802170:	8b 45 08             	mov    0x8(%ebp),%eax
  802173:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802176:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80217a:	6a 00                	push   $0x0
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	50                   	push   %eax
  802183:	6a 26                	push   $0x26
  802185:	e8 5c fb ff ff       	call   801ce6 <syscall>
  80218a:	83 c4 18             	add    $0x18,%esp
	return ;
  80218d:	90                   	nop
}
  80218e:	c9                   	leave  
  80218f:	c3                   	ret    

00802190 <rsttst>:
void rsttst()
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 28                	push   $0x28
  80219f:	e8 42 fb ff ff       	call   801ce6 <syscall>
  8021a4:	83 c4 18             	add    $0x18,%esp
	return ;
  8021a7:	90                   	nop
}
  8021a8:	c9                   	leave  
  8021a9:	c3                   	ret    

008021aa <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021aa:	55                   	push   %ebp
  8021ab:	89 e5                	mov    %esp,%ebp
  8021ad:	83 ec 04             	sub    $0x4,%esp
  8021b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8021b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021b6:	8b 55 18             	mov    0x18(%ebp),%edx
  8021b9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021bd:	52                   	push   %edx
  8021be:	50                   	push   %eax
  8021bf:	ff 75 10             	pushl  0x10(%ebp)
  8021c2:	ff 75 0c             	pushl  0xc(%ebp)
  8021c5:	ff 75 08             	pushl  0x8(%ebp)
  8021c8:	6a 27                	push   $0x27
  8021ca:	e8 17 fb ff ff       	call   801ce6 <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
	return ;
  8021d2:	90                   	nop
}
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <chktst>:
void chktst(uint32 n)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 00                	push   $0x0
  8021dc:	6a 00                	push   $0x0
  8021de:	6a 00                	push   $0x0
  8021e0:	ff 75 08             	pushl  0x8(%ebp)
  8021e3:	6a 29                	push   $0x29
  8021e5:	e8 fc fa ff ff       	call   801ce6 <syscall>
  8021ea:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ed:	90                   	nop
}
  8021ee:	c9                   	leave  
  8021ef:	c3                   	ret    

008021f0 <inctst>:

void inctst()
{
  8021f0:	55                   	push   %ebp
  8021f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8021f3:	6a 00                	push   $0x0
  8021f5:	6a 00                	push   $0x0
  8021f7:	6a 00                	push   $0x0
  8021f9:	6a 00                	push   $0x0
  8021fb:	6a 00                	push   $0x0
  8021fd:	6a 2a                	push   $0x2a
  8021ff:	e8 e2 fa ff ff       	call   801ce6 <syscall>
  802204:	83 c4 18             	add    $0x18,%esp
	return ;
  802207:	90                   	nop
}
  802208:	c9                   	leave  
  802209:	c3                   	ret    

0080220a <gettst>:
uint32 gettst()
{
  80220a:	55                   	push   %ebp
  80220b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80220d:	6a 00                	push   $0x0
  80220f:	6a 00                	push   $0x0
  802211:	6a 00                	push   $0x0
  802213:	6a 00                	push   $0x0
  802215:	6a 00                	push   $0x0
  802217:	6a 2b                	push   $0x2b
  802219:	e8 c8 fa ff ff       	call   801ce6 <syscall>
  80221e:	83 c4 18             	add    $0x18,%esp
}
  802221:	c9                   	leave  
  802222:	c3                   	ret    

00802223 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802223:	55                   	push   %ebp
  802224:	89 e5                	mov    %esp,%ebp
  802226:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802229:	6a 00                	push   $0x0
  80222b:	6a 00                	push   $0x0
  80222d:	6a 00                	push   $0x0
  80222f:	6a 00                	push   $0x0
  802231:	6a 00                	push   $0x0
  802233:	6a 2c                	push   $0x2c
  802235:	e8 ac fa ff ff       	call   801ce6 <syscall>
  80223a:	83 c4 18             	add    $0x18,%esp
  80223d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802240:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802244:	75 07                	jne    80224d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802246:	b8 01 00 00 00       	mov    $0x1,%eax
  80224b:	eb 05                	jmp    802252 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80224d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802252:	c9                   	leave  
  802253:	c3                   	ret    

00802254 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802254:	55                   	push   %ebp
  802255:	89 e5                	mov    %esp,%ebp
  802257:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80225a:	6a 00                	push   $0x0
  80225c:	6a 00                	push   $0x0
  80225e:	6a 00                	push   $0x0
  802260:	6a 00                	push   $0x0
  802262:	6a 00                	push   $0x0
  802264:	6a 2c                	push   $0x2c
  802266:	e8 7b fa ff ff       	call   801ce6 <syscall>
  80226b:	83 c4 18             	add    $0x18,%esp
  80226e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802271:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802275:	75 07                	jne    80227e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802277:	b8 01 00 00 00       	mov    $0x1,%eax
  80227c:	eb 05                	jmp    802283 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80227e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802283:	c9                   	leave  
  802284:	c3                   	ret    

00802285 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802285:	55                   	push   %ebp
  802286:	89 e5                	mov    %esp,%ebp
  802288:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80228b:	6a 00                	push   $0x0
  80228d:	6a 00                	push   $0x0
  80228f:	6a 00                	push   $0x0
  802291:	6a 00                	push   $0x0
  802293:	6a 00                	push   $0x0
  802295:	6a 2c                	push   $0x2c
  802297:	e8 4a fa ff ff       	call   801ce6 <syscall>
  80229c:	83 c4 18             	add    $0x18,%esp
  80229f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022a2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022a6:	75 07                	jne    8022af <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022a8:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ad:	eb 05                	jmp    8022b4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022af:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022b4:	c9                   	leave  
  8022b5:	c3                   	ret    

008022b6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022b6:	55                   	push   %ebp
  8022b7:	89 e5                	mov    %esp,%ebp
  8022b9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022bc:	6a 00                	push   $0x0
  8022be:	6a 00                	push   $0x0
  8022c0:	6a 00                	push   $0x0
  8022c2:	6a 00                	push   $0x0
  8022c4:	6a 00                	push   $0x0
  8022c6:	6a 2c                	push   $0x2c
  8022c8:	e8 19 fa ff ff       	call   801ce6 <syscall>
  8022cd:	83 c4 18             	add    $0x18,%esp
  8022d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8022d3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8022d7:	75 07                	jne    8022e0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8022d9:	b8 01 00 00 00       	mov    $0x1,%eax
  8022de:	eb 05                	jmp    8022e5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8022e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022e5:	c9                   	leave  
  8022e6:	c3                   	ret    

008022e7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8022e7:	55                   	push   %ebp
  8022e8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8022ea:	6a 00                	push   $0x0
  8022ec:	6a 00                	push   $0x0
  8022ee:	6a 00                	push   $0x0
  8022f0:	6a 00                	push   $0x0
  8022f2:	ff 75 08             	pushl  0x8(%ebp)
  8022f5:	6a 2d                	push   $0x2d
  8022f7:	e8 ea f9 ff ff       	call   801ce6 <syscall>
  8022fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8022ff:	90                   	nop
}
  802300:	c9                   	leave  
  802301:	c3                   	ret    

00802302 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  802302:	55                   	push   %ebp
  802303:	89 e5                	mov    %esp,%ebp
  802305:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802306:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802309:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80230c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	6a 00                	push   $0x0
  802314:	53                   	push   %ebx
  802315:	51                   	push   %ecx
  802316:	52                   	push   %edx
  802317:	50                   	push   %eax
  802318:	6a 2e                	push   $0x2e
  80231a:	e8 c7 f9 ff ff       	call   801ce6 <syscall>
  80231f:	83 c4 18             	add    $0x18,%esp
}
  802322:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802325:	c9                   	leave  
  802326:	c3                   	ret    

00802327 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802327:	55                   	push   %ebp
  802328:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80232a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	6a 00                	push   $0x0
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	52                   	push   %edx
  802337:	50                   	push   %eax
  802338:	6a 2f                	push   $0x2f
  80233a:	e8 a7 f9 ff ff       	call   801ce6 <syscall>
  80233f:	83 c4 18             	add    $0x18,%esp
}
  802342:	c9                   	leave  
  802343:	c3                   	ret    

00802344 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802344:	55                   	push   %ebp
  802345:	89 e5                	mov    %esp,%ebp
  802347:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80234a:	83 ec 0c             	sub    $0xc,%esp
  80234d:	68 a0 3e 80 00       	push   $0x803ea0
  802352:	e8 3e e6 ff ff       	call   800995 <cprintf>
  802357:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80235a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802361:	83 ec 0c             	sub    $0xc,%esp
  802364:	68 cc 3e 80 00       	push   $0x803ecc
  802369:	e8 27 e6 ff ff       	call   800995 <cprintf>
  80236e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802371:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802375:	a1 38 51 80 00       	mov    0x805138,%eax
  80237a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80237d:	eb 56                	jmp    8023d5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80237f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802383:	74 1c                	je     8023a1 <print_mem_block_lists+0x5d>
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	8b 50 08             	mov    0x8(%eax),%edx
  80238b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238e:	8b 48 08             	mov    0x8(%eax),%ecx
  802391:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802394:	8b 40 0c             	mov    0xc(%eax),%eax
  802397:	01 c8                	add    %ecx,%eax
  802399:	39 c2                	cmp    %eax,%edx
  80239b:	73 04                	jae    8023a1 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80239d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a4:	8b 50 08             	mov    0x8(%eax),%edx
  8023a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ad:	01 c2                	add    %eax,%edx
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	8b 40 08             	mov    0x8(%eax),%eax
  8023b5:	83 ec 04             	sub    $0x4,%esp
  8023b8:	52                   	push   %edx
  8023b9:	50                   	push   %eax
  8023ba:	68 e1 3e 80 00       	push   $0x803ee1
  8023bf:	e8 d1 e5 ff ff       	call   800995 <cprintf>
  8023c4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8023c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023cd:	a1 40 51 80 00       	mov    0x805140,%eax
  8023d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023d9:	74 07                	je     8023e2 <print_mem_block_lists+0x9e>
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 00                	mov    (%eax),%eax
  8023e0:	eb 05                	jmp    8023e7 <print_mem_block_lists+0xa3>
  8023e2:	b8 00 00 00 00       	mov    $0x0,%eax
  8023e7:	a3 40 51 80 00       	mov    %eax,0x805140
  8023ec:	a1 40 51 80 00       	mov    0x805140,%eax
  8023f1:	85 c0                	test   %eax,%eax
  8023f3:	75 8a                	jne    80237f <print_mem_block_lists+0x3b>
  8023f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023f9:	75 84                	jne    80237f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8023fb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8023ff:	75 10                	jne    802411 <print_mem_block_lists+0xcd>
  802401:	83 ec 0c             	sub    $0xc,%esp
  802404:	68 f0 3e 80 00       	push   $0x803ef0
  802409:	e8 87 e5 ff ff       	call   800995 <cprintf>
  80240e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802411:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802418:	83 ec 0c             	sub    $0xc,%esp
  80241b:	68 14 3f 80 00       	push   $0x803f14
  802420:	e8 70 e5 ff ff       	call   800995 <cprintf>
  802425:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802428:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80242c:	a1 40 50 80 00       	mov    0x805040,%eax
  802431:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802434:	eb 56                	jmp    80248c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802436:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80243a:	74 1c                	je     802458 <print_mem_block_lists+0x114>
  80243c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243f:	8b 50 08             	mov    0x8(%eax),%edx
  802442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802445:	8b 48 08             	mov    0x8(%eax),%ecx
  802448:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244b:	8b 40 0c             	mov    0xc(%eax),%eax
  80244e:	01 c8                	add    %ecx,%eax
  802450:	39 c2                	cmp    %eax,%edx
  802452:	73 04                	jae    802458 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802454:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	8b 50 08             	mov    0x8(%eax),%edx
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 40 0c             	mov    0xc(%eax),%eax
  802464:	01 c2                	add    %eax,%edx
  802466:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802469:	8b 40 08             	mov    0x8(%eax),%eax
  80246c:	83 ec 04             	sub    $0x4,%esp
  80246f:	52                   	push   %edx
  802470:	50                   	push   %eax
  802471:	68 e1 3e 80 00       	push   $0x803ee1
  802476:	e8 1a e5 ff ff       	call   800995 <cprintf>
  80247b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802484:	a1 48 50 80 00       	mov    0x805048,%eax
  802489:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80248c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802490:	74 07                	je     802499 <print_mem_block_lists+0x155>
  802492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802495:	8b 00                	mov    (%eax),%eax
  802497:	eb 05                	jmp    80249e <print_mem_block_lists+0x15a>
  802499:	b8 00 00 00 00       	mov    $0x0,%eax
  80249e:	a3 48 50 80 00       	mov    %eax,0x805048
  8024a3:	a1 48 50 80 00       	mov    0x805048,%eax
  8024a8:	85 c0                	test   %eax,%eax
  8024aa:	75 8a                	jne    802436 <print_mem_block_lists+0xf2>
  8024ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b0:	75 84                	jne    802436 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024b2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024b6:	75 10                	jne    8024c8 <print_mem_block_lists+0x184>
  8024b8:	83 ec 0c             	sub    $0xc,%esp
  8024bb:	68 2c 3f 80 00       	push   $0x803f2c
  8024c0:	e8 d0 e4 ff ff       	call   800995 <cprintf>
  8024c5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8024c8:	83 ec 0c             	sub    $0xc,%esp
  8024cb:	68 a0 3e 80 00       	push   $0x803ea0
  8024d0:	e8 c0 e4 ff ff       	call   800995 <cprintf>
  8024d5:	83 c4 10             	add    $0x10,%esp

}
  8024d8:	90                   	nop
  8024d9:	c9                   	leave  
  8024da:	c3                   	ret    

008024db <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8024db:	55                   	push   %ebp
  8024dc:	89 e5                	mov    %esp,%ebp
  8024de:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8024e1:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8024e8:	00 00 00 
  8024eb:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8024f2:	00 00 00 
  8024f5:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8024fc:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8024ff:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802506:	e9 9e 00 00 00       	jmp    8025a9 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  80250b:	a1 50 50 80 00       	mov    0x805050,%eax
  802510:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802513:	c1 e2 04             	shl    $0x4,%edx
  802516:	01 d0                	add    %edx,%eax
  802518:	85 c0                	test   %eax,%eax
  80251a:	75 14                	jne    802530 <initialize_MemBlocksList+0x55>
  80251c:	83 ec 04             	sub    $0x4,%esp
  80251f:	68 54 3f 80 00       	push   $0x803f54
  802524:	6a 3d                	push   $0x3d
  802526:	68 77 3f 80 00       	push   $0x803f77
  80252b:	e8 b1 e1 ff ff       	call   8006e1 <_panic>
  802530:	a1 50 50 80 00       	mov    0x805050,%eax
  802535:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802538:	c1 e2 04             	shl    $0x4,%edx
  80253b:	01 d0                	add    %edx,%eax
  80253d:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802543:	89 10                	mov    %edx,(%eax)
  802545:	8b 00                	mov    (%eax),%eax
  802547:	85 c0                	test   %eax,%eax
  802549:	74 18                	je     802563 <initialize_MemBlocksList+0x88>
  80254b:	a1 48 51 80 00       	mov    0x805148,%eax
  802550:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802556:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802559:	c1 e1 04             	shl    $0x4,%ecx
  80255c:	01 ca                	add    %ecx,%edx
  80255e:	89 50 04             	mov    %edx,0x4(%eax)
  802561:	eb 12                	jmp    802575 <initialize_MemBlocksList+0x9a>
  802563:	a1 50 50 80 00       	mov    0x805050,%eax
  802568:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256b:	c1 e2 04             	shl    $0x4,%edx
  80256e:	01 d0                	add    %edx,%eax
  802570:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802575:	a1 50 50 80 00       	mov    0x805050,%eax
  80257a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257d:	c1 e2 04             	shl    $0x4,%edx
  802580:	01 d0                	add    %edx,%eax
  802582:	a3 48 51 80 00       	mov    %eax,0x805148
  802587:	a1 50 50 80 00       	mov    0x805050,%eax
  80258c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258f:	c1 e2 04             	shl    $0x4,%edx
  802592:	01 d0                	add    %edx,%eax
  802594:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259b:	a1 54 51 80 00       	mov    0x805154,%eax
  8025a0:	40                   	inc    %eax
  8025a1:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8025a6:	ff 45 f4             	incl   -0xc(%ebp)
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025af:	0f 82 56 ff ff ff    	jb     80250b <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8025b5:	90                   	nop
  8025b6:	c9                   	leave  
  8025b7:	c3                   	ret    

008025b8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025b8:	55                   	push   %ebp
  8025b9:	89 e5                	mov    %esp,%ebp
  8025bb:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8025be:	8b 45 08             	mov    0x8(%ebp),%eax
  8025c1:	8b 00                	mov    (%eax),%eax
  8025c3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8025c6:	eb 18                	jmp    8025e0 <find_block+0x28>

		if(tmp->sva == va){
  8025c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025cb:	8b 40 08             	mov    0x8(%eax),%eax
  8025ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8025d1:	75 05                	jne    8025d8 <find_block+0x20>
			return tmp ;
  8025d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025d6:	eb 11                	jmp    8025e9 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8025d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8025db:	8b 00                	mov    (%eax),%eax
  8025dd:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8025e0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8025e4:	75 e2                	jne    8025c8 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8025e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8025e9:	c9                   	leave  
  8025ea:	c3                   	ret    

008025eb <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8025eb:	55                   	push   %ebp
  8025ec:	89 e5                	mov    %esp,%ebp
  8025ee:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8025f1:	a1 40 50 80 00       	mov    0x805040,%eax
  8025f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8025f9:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8025fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802601:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802605:	75 65                	jne    80266c <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802607:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80260b:	75 14                	jne    802621 <insert_sorted_allocList+0x36>
  80260d:	83 ec 04             	sub    $0x4,%esp
  802610:	68 54 3f 80 00       	push   $0x803f54
  802615:	6a 62                	push   $0x62
  802617:	68 77 3f 80 00       	push   $0x803f77
  80261c:	e8 c0 e0 ff ff       	call   8006e1 <_panic>
  802621:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802627:	8b 45 08             	mov    0x8(%ebp),%eax
  80262a:	89 10                	mov    %edx,(%eax)
  80262c:	8b 45 08             	mov    0x8(%ebp),%eax
  80262f:	8b 00                	mov    (%eax),%eax
  802631:	85 c0                	test   %eax,%eax
  802633:	74 0d                	je     802642 <insert_sorted_allocList+0x57>
  802635:	a1 40 50 80 00       	mov    0x805040,%eax
  80263a:	8b 55 08             	mov    0x8(%ebp),%edx
  80263d:	89 50 04             	mov    %edx,0x4(%eax)
  802640:	eb 08                	jmp    80264a <insert_sorted_allocList+0x5f>
  802642:	8b 45 08             	mov    0x8(%ebp),%eax
  802645:	a3 44 50 80 00       	mov    %eax,0x805044
  80264a:	8b 45 08             	mov    0x8(%ebp),%eax
  80264d:	a3 40 50 80 00       	mov    %eax,0x805040
  802652:	8b 45 08             	mov    0x8(%ebp),%eax
  802655:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80265c:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802661:	40                   	inc    %eax
  802662:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802667:	e9 14 01 00 00       	jmp    802780 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80266c:	8b 45 08             	mov    0x8(%ebp),%eax
  80266f:	8b 50 08             	mov    0x8(%eax),%edx
  802672:	a1 44 50 80 00       	mov    0x805044,%eax
  802677:	8b 40 08             	mov    0x8(%eax),%eax
  80267a:	39 c2                	cmp    %eax,%edx
  80267c:	76 65                	jbe    8026e3 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80267e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802682:	75 14                	jne    802698 <insert_sorted_allocList+0xad>
  802684:	83 ec 04             	sub    $0x4,%esp
  802687:	68 90 3f 80 00       	push   $0x803f90
  80268c:	6a 64                	push   $0x64
  80268e:	68 77 3f 80 00       	push   $0x803f77
  802693:	e8 49 e0 ff ff       	call   8006e1 <_panic>
  802698:	8b 15 44 50 80 00    	mov    0x805044,%edx
  80269e:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a1:	89 50 04             	mov    %edx,0x4(%eax)
  8026a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026a7:	8b 40 04             	mov    0x4(%eax),%eax
  8026aa:	85 c0                	test   %eax,%eax
  8026ac:	74 0c                	je     8026ba <insert_sorted_allocList+0xcf>
  8026ae:	a1 44 50 80 00       	mov    0x805044,%eax
  8026b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b6:	89 10                	mov    %edx,(%eax)
  8026b8:	eb 08                	jmp    8026c2 <insert_sorted_allocList+0xd7>
  8026ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bd:	a3 40 50 80 00       	mov    %eax,0x805040
  8026c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8026c5:	a3 44 50 80 00       	mov    %eax,0x805044
  8026ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8026cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d3:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8026d8:	40                   	inc    %eax
  8026d9:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8026de:	e9 9d 00 00 00       	jmp    802780 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8026e3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8026ea:	e9 85 00 00 00       	jmp    802774 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	8b 50 08             	mov    0x8(%eax),%edx
  8026f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f8:	8b 40 08             	mov    0x8(%eax),%eax
  8026fb:	39 c2                	cmp    %eax,%edx
  8026fd:	73 6a                	jae    802769 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8026ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802703:	74 06                	je     80270b <insert_sorted_allocList+0x120>
  802705:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802709:	75 14                	jne    80271f <insert_sorted_allocList+0x134>
  80270b:	83 ec 04             	sub    $0x4,%esp
  80270e:	68 b4 3f 80 00       	push   $0x803fb4
  802713:	6a 6b                	push   $0x6b
  802715:	68 77 3f 80 00       	push   $0x803f77
  80271a:	e8 c2 df ff ff       	call   8006e1 <_panic>
  80271f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802722:	8b 50 04             	mov    0x4(%eax),%edx
  802725:	8b 45 08             	mov    0x8(%ebp),%eax
  802728:	89 50 04             	mov    %edx,0x4(%eax)
  80272b:	8b 45 08             	mov    0x8(%ebp),%eax
  80272e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802731:	89 10                	mov    %edx,(%eax)
  802733:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802736:	8b 40 04             	mov    0x4(%eax),%eax
  802739:	85 c0                	test   %eax,%eax
  80273b:	74 0d                	je     80274a <insert_sorted_allocList+0x15f>
  80273d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802740:	8b 40 04             	mov    0x4(%eax),%eax
  802743:	8b 55 08             	mov    0x8(%ebp),%edx
  802746:	89 10                	mov    %edx,(%eax)
  802748:	eb 08                	jmp    802752 <insert_sorted_allocList+0x167>
  80274a:	8b 45 08             	mov    0x8(%ebp),%eax
  80274d:	a3 40 50 80 00       	mov    %eax,0x805040
  802752:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802755:	8b 55 08             	mov    0x8(%ebp),%edx
  802758:	89 50 04             	mov    %edx,0x4(%eax)
  80275b:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802760:	40                   	inc    %eax
  802761:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802766:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802767:	eb 17                	jmp    802780 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 00                	mov    (%eax),%eax
  80276e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802771:	ff 45 f0             	incl   -0x10(%ebp)
  802774:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802777:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80277a:	0f 8c 6f ff ff ff    	jl     8026ef <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802780:	90                   	nop
  802781:	c9                   	leave  
  802782:	c3                   	ret    

00802783 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802783:	55                   	push   %ebp
  802784:	89 e5                	mov    %esp,%ebp
  802786:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802789:	a1 38 51 80 00       	mov    0x805138,%eax
  80278e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802791:	e9 7c 01 00 00       	jmp    802912 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802796:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802799:	8b 40 0c             	mov    0xc(%eax),%eax
  80279c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80279f:	0f 86 cf 00 00 00    	jbe    802874 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8027a5:	a1 48 51 80 00       	mov    0x805148,%eax
  8027aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  8027ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8027b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b6:	8b 55 08             	mov    0x8(%ebp),%edx
  8027b9:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	8b 50 08             	mov    0x8(%eax),%edx
  8027c2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c5:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8027c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ce:	2b 45 08             	sub    0x8(%ebp),%eax
  8027d1:	89 c2                	mov    %eax,%edx
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8027d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dc:	8b 50 08             	mov    0x8(%eax),%edx
  8027df:	8b 45 08             	mov    0x8(%ebp),%eax
  8027e2:	01 c2                	add    %eax,%edx
  8027e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e7:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8027ea:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027ee:	75 17                	jne    802807 <alloc_block_FF+0x84>
  8027f0:	83 ec 04             	sub    $0x4,%esp
  8027f3:	68 e9 3f 80 00       	push   $0x803fe9
  8027f8:	68 83 00 00 00       	push   $0x83
  8027fd:	68 77 3f 80 00       	push   $0x803f77
  802802:	e8 da de ff ff       	call   8006e1 <_panic>
  802807:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280a:	8b 00                	mov    (%eax),%eax
  80280c:	85 c0                	test   %eax,%eax
  80280e:	74 10                	je     802820 <alloc_block_FF+0x9d>
  802810:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802813:	8b 00                	mov    (%eax),%eax
  802815:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802818:	8b 52 04             	mov    0x4(%edx),%edx
  80281b:	89 50 04             	mov    %edx,0x4(%eax)
  80281e:	eb 0b                	jmp    80282b <alloc_block_FF+0xa8>
  802820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802823:	8b 40 04             	mov    0x4(%eax),%eax
  802826:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80282b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282e:	8b 40 04             	mov    0x4(%eax),%eax
  802831:	85 c0                	test   %eax,%eax
  802833:	74 0f                	je     802844 <alloc_block_FF+0xc1>
  802835:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802838:	8b 40 04             	mov    0x4(%eax),%eax
  80283b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80283e:	8b 12                	mov    (%edx),%edx
  802840:	89 10                	mov    %edx,(%eax)
  802842:	eb 0a                	jmp    80284e <alloc_block_FF+0xcb>
  802844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	a3 48 51 80 00       	mov    %eax,0x805148
  80284e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802851:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802857:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802861:	a1 54 51 80 00       	mov    0x805154,%eax
  802866:	48                   	dec    %eax
  802867:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  80286c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286f:	e9 ad 00 00 00       	jmp    802921 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	8b 40 0c             	mov    0xc(%eax),%eax
  80287a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80287d:	0f 85 87 00 00 00    	jne    80290a <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802883:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802887:	75 17                	jne    8028a0 <alloc_block_FF+0x11d>
  802889:	83 ec 04             	sub    $0x4,%esp
  80288c:	68 e9 3f 80 00       	push   $0x803fe9
  802891:	68 87 00 00 00       	push   $0x87
  802896:	68 77 3f 80 00       	push   $0x803f77
  80289b:	e8 41 de ff ff       	call   8006e1 <_panic>
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 00                	mov    (%eax),%eax
  8028a5:	85 c0                	test   %eax,%eax
  8028a7:	74 10                	je     8028b9 <alloc_block_FF+0x136>
  8028a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ac:	8b 00                	mov    (%eax),%eax
  8028ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028b1:	8b 52 04             	mov    0x4(%edx),%edx
  8028b4:	89 50 04             	mov    %edx,0x4(%eax)
  8028b7:	eb 0b                	jmp    8028c4 <alloc_block_FF+0x141>
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 40 04             	mov    0x4(%eax),%eax
  8028bf:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8028c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c7:	8b 40 04             	mov    0x4(%eax),%eax
  8028ca:	85 c0                	test   %eax,%eax
  8028cc:	74 0f                	je     8028dd <alloc_block_FF+0x15a>
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 40 04             	mov    0x4(%eax),%eax
  8028d4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d7:	8b 12                	mov    (%edx),%edx
  8028d9:	89 10                	mov    %edx,(%eax)
  8028db:	eb 0a                	jmp    8028e7 <alloc_block_FF+0x164>
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 00                	mov    (%eax),%eax
  8028e2:	a3 38 51 80 00       	mov    %eax,0x805138
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028fa:	a1 44 51 80 00       	mov    0x805144,%eax
  8028ff:	48                   	dec    %eax
  802900:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802905:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802908:	eb 17                	jmp    802921 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  80290a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290d:	8b 00                	mov    (%eax),%eax
  80290f:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802912:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802916:	0f 85 7a fe ff ff    	jne    802796 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  80291c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802921:	c9                   	leave  
  802922:	c3                   	ret    

00802923 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802923:	55                   	push   %ebp
  802924:	89 e5                	mov    %esp,%ebp
  802926:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802929:	a1 38 51 80 00       	mov    0x805138,%eax
  80292e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802931:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802938:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80293f:	a1 38 51 80 00       	mov    0x805138,%eax
  802944:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802947:	e9 d0 00 00 00       	jmp    802a1c <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  80294c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294f:	8b 40 0c             	mov    0xc(%eax),%eax
  802952:	3b 45 08             	cmp    0x8(%ebp),%eax
  802955:	0f 82 b8 00 00 00    	jb     802a13 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  80295b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295e:	8b 40 0c             	mov    0xc(%eax),%eax
  802961:	2b 45 08             	sub    0x8(%ebp),%eax
  802964:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802967:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80296a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80296d:	0f 83 a1 00 00 00    	jae    802a14 <alloc_block_BF+0xf1>
				differsize = differance ;
  802973:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802976:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802979:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80297f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802983:	0f 85 8b 00 00 00    	jne    802a14 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802989:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80298d:	75 17                	jne    8029a6 <alloc_block_BF+0x83>
  80298f:	83 ec 04             	sub    $0x4,%esp
  802992:	68 e9 3f 80 00       	push   $0x803fe9
  802997:	68 a0 00 00 00       	push   $0xa0
  80299c:	68 77 3f 80 00       	push   $0x803f77
  8029a1:	e8 3b dd ff ff       	call   8006e1 <_panic>
  8029a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a9:	8b 00                	mov    (%eax),%eax
  8029ab:	85 c0                	test   %eax,%eax
  8029ad:	74 10                	je     8029bf <alloc_block_BF+0x9c>
  8029af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b2:	8b 00                	mov    (%eax),%eax
  8029b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029b7:	8b 52 04             	mov    0x4(%edx),%edx
  8029ba:	89 50 04             	mov    %edx,0x4(%eax)
  8029bd:	eb 0b                	jmp    8029ca <alloc_block_BF+0xa7>
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	8b 40 04             	mov    0x4(%eax),%eax
  8029c5:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8029ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cd:	8b 40 04             	mov    0x4(%eax),%eax
  8029d0:	85 c0                	test   %eax,%eax
  8029d2:	74 0f                	je     8029e3 <alloc_block_BF+0xc0>
  8029d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d7:	8b 40 04             	mov    0x4(%eax),%eax
  8029da:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029dd:	8b 12                	mov    (%edx),%edx
  8029df:	89 10                	mov    %edx,(%eax)
  8029e1:	eb 0a                	jmp    8029ed <alloc_block_BF+0xca>
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	8b 00                	mov    (%eax),%eax
  8029e8:	a3 38 51 80 00       	mov    %eax,0x805138
  8029ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a00:	a1 44 51 80 00       	mov    0x805144,%eax
  802a05:	48                   	dec    %eax
  802a06:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	e9 0c 01 00 00       	jmp    802b1f <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802a13:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802a14:	a1 40 51 80 00       	mov    0x805140,%eax
  802a19:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a1c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a20:	74 07                	je     802a29 <alloc_block_BF+0x106>
  802a22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a25:	8b 00                	mov    (%eax),%eax
  802a27:	eb 05                	jmp    802a2e <alloc_block_BF+0x10b>
  802a29:	b8 00 00 00 00       	mov    $0x0,%eax
  802a2e:	a3 40 51 80 00       	mov    %eax,0x805140
  802a33:	a1 40 51 80 00       	mov    0x805140,%eax
  802a38:	85 c0                	test   %eax,%eax
  802a3a:	0f 85 0c ff ff ff    	jne    80294c <alloc_block_BF+0x29>
  802a40:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a44:	0f 85 02 ff ff ff    	jne    80294c <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802a4a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a4e:	0f 84 c6 00 00 00    	je     802b1a <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802a54:	a1 48 51 80 00       	mov    0x805148,%eax
  802a59:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802a5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a62:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a68:	8b 50 08             	mov    0x8(%eax),%edx
  802a6b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a6e:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802a71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a74:	8b 40 0c             	mov    0xc(%eax),%eax
  802a77:	2b 45 08             	sub    0x8(%ebp),%eax
  802a7a:	89 c2                	mov    %eax,%edx
  802a7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a7f:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a85:	8b 50 08             	mov    0x8(%eax),%edx
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	01 c2                	add    %eax,%edx
  802a8d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a90:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802a93:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a97:	75 17                	jne    802ab0 <alloc_block_BF+0x18d>
  802a99:	83 ec 04             	sub    $0x4,%esp
  802a9c:	68 e9 3f 80 00       	push   $0x803fe9
  802aa1:	68 af 00 00 00       	push   $0xaf
  802aa6:	68 77 3f 80 00       	push   $0x803f77
  802aab:	e8 31 dc ff ff       	call   8006e1 <_panic>
  802ab0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ab3:	8b 00                	mov    (%eax),%eax
  802ab5:	85 c0                	test   %eax,%eax
  802ab7:	74 10                	je     802ac9 <alloc_block_BF+0x1a6>
  802ab9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802abc:	8b 00                	mov    (%eax),%eax
  802abe:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ac1:	8b 52 04             	mov    0x4(%edx),%edx
  802ac4:	89 50 04             	mov    %edx,0x4(%eax)
  802ac7:	eb 0b                	jmp    802ad4 <alloc_block_BF+0x1b1>
  802ac9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802acc:	8b 40 04             	mov    0x4(%eax),%eax
  802acf:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802ad4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ad7:	8b 40 04             	mov    0x4(%eax),%eax
  802ada:	85 c0                	test   %eax,%eax
  802adc:	74 0f                	je     802aed <alloc_block_BF+0x1ca>
  802ade:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ae1:	8b 40 04             	mov    0x4(%eax),%eax
  802ae4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ae7:	8b 12                	mov    (%edx),%edx
  802ae9:	89 10                	mov    %edx,(%eax)
  802aeb:	eb 0a                	jmp    802af7 <alloc_block_BF+0x1d4>
  802aed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af0:	8b 00                	mov    (%eax),%eax
  802af2:	a3 48 51 80 00       	mov    %eax,0x805148
  802af7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b00:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b03:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b0a:	a1 54 51 80 00       	mov    0x805154,%eax
  802b0f:	48                   	dec    %eax
  802b10:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802b15:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b18:	eb 05                	jmp    802b1f <alloc_block_BF+0x1fc>
	}

	return NULL;
  802b1a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b1f:	c9                   	leave  
  802b20:	c3                   	ret    

00802b21 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802b21:	55                   	push   %ebp
  802b22:	89 e5                	mov    %esp,%ebp
  802b24:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802b27:	a1 38 51 80 00       	mov    0x805138,%eax
  802b2c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802b2f:	e9 7c 01 00 00       	jmp    802cb0 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	8b 40 0c             	mov    0xc(%eax),%eax
  802b3a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b3d:	0f 86 cf 00 00 00    	jbe    802c12 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802b43:	a1 48 51 80 00       	mov    0x805148,%eax
  802b48:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802b4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802b51:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b54:	8b 55 08             	mov    0x8(%ebp),%edx
  802b57:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802b5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5d:	8b 50 08             	mov    0x8(%eax),%edx
  802b60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b63:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802b66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b69:	8b 40 0c             	mov    0xc(%eax),%eax
  802b6c:	2b 45 08             	sub    0x8(%ebp),%eax
  802b6f:	89 c2                	mov    %eax,%edx
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802b77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b7a:	8b 50 08             	mov    0x8(%eax),%edx
  802b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b80:	01 c2                	add    %eax,%edx
  802b82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b85:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802b88:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802b8c:	75 17                	jne    802ba5 <alloc_block_NF+0x84>
  802b8e:	83 ec 04             	sub    $0x4,%esp
  802b91:	68 e9 3f 80 00       	push   $0x803fe9
  802b96:	68 c4 00 00 00       	push   $0xc4
  802b9b:	68 77 3f 80 00       	push   $0x803f77
  802ba0:	e8 3c db ff ff       	call   8006e1 <_panic>
  802ba5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba8:	8b 00                	mov    (%eax),%eax
  802baa:	85 c0                	test   %eax,%eax
  802bac:	74 10                	je     802bbe <alloc_block_NF+0x9d>
  802bae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bb1:	8b 00                	mov    (%eax),%eax
  802bb3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bb6:	8b 52 04             	mov    0x4(%edx),%edx
  802bb9:	89 50 04             	mov    %edx,0x4(%eax)
  802bbc:	eb 0b                	jmp    802bc9 <alloc_block_NF+0xa8>
  802bbe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bc1:	8b 40 04             	mov    0x4(%eax),%eax
  802bc4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcc:	8b 40 04             	mov    0x4(%eax),%eax
  802bcf:	85 c0                	test   %eax,%eax
  802bd1:	74 0f                	je     802be2 <alloc_block_NF+0xc1>
  802bd3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd6:	8b 40 04             	mov    0x4(%eax),%eax
  802bd9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bdc:	8b 12                	mov    (%edx),%edx
  802bde:	89 10                	mov    %edx,(%eax)
  802be0:	eb 0a                	jmp    802bec <alloc_block_NF+0xcb>
  802be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be5:	8b 00                	mov    (%eax),%eax
  802be7:	a3 48 51 80 00       	mov    %eax,0x805148
  802bec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802bf5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bff:	a1 54 51 80 00       	mov    0x805154,%eax
  802c04:	48                   	dec    %eax
  802c05:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802c0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c0d:	e9 ad 00 00 00       	jmp    802cbf <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c15:	8b 40 0c             	mov    0xc(%eax),%eax
  802c18:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c1b:	0f 85 87 00 00 00    	jne    802ca8 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802c21:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c25:	75 17                	jne    802c3e <alloc_block_NF+0x11d>
  802c27:	83 ec 04             	sub    $0x4,%esp
  802c2a:	68 e9 3f 80 00       	push   $0x803fe9
  802c2f:	68 c8 00 00 00       	push   $0xc8
  802c34:	68 77 3f 80 00       	push   $0x803f77
  802c39:	e8 a3 da ff ff       	call   8006e1 <_panic>
  802c3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c41:	8b 00                	mov    (%eax),%eax
  802c43:	85 c0                	test   %eax,%eax
  802c45:	74 10                	je     802c57 <alloc_block_NF+0x136>
  802c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4a:	8b 00                	mov    (%eax),%eax
  802c4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c4f:	8b 52 04             	mov    0x4(%edx),%edx
  802c52:	89 50 04             	mov    %edx,0x4(%eax)
  802c55:	eb 0b                	jmp    802c62 <alloc_block_NF+0x141>
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 40 04             	mov    0x4(%eax),%eax
  802c5d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	8b 40 04             	mov    0x4(%eax),%eax
  802c68:	85 c0                	test   %eax,%eax
  802c6a:	74 0f                	je     802c7b <alloc_block_NF+0x15a>
  802c6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6f:	8b 40 04             	mov    0x4(%eax),%eax
  802c72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c75:	8b 12                	mov    (%edx),%edx
  802c77:	89 10                	mov    %edx,(%eax)
  802c79:	eb 0a                	jmp    802c85 <alloc_block_NF+0x164>
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 00                	mov    (%eax),%eax
  802c80:	a3 38 51 80 00       	mov    %eax,0x805138
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c98:	a1 44 51 80 00       	mov    0x805144,%eax
  802c9d:	48                   	dec    %eax
  802c9e:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802ca3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca6:	eb 17                	jmp    802cbf <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	8b 00                	mov    (%eax),%eax
  802cad:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802cb0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cb4:	0f 85 7a fe ff ff    	jne    802b34 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802cba:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802cbf:	c9                   	leave  
  802cc0:	c3                   	ret    

00802cc1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cc1:	55                   	push   %ebp
  802cc2:	89 e5                	mov    %esp,%ebp
  802cc4:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802cc7:	a1 38 51 80 00       	mov    0x805138,%eax
  802ccc:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802ccf:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802cd4:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802cd7:	a1 44 51 80 00       	mov    0x805144,%eax
  802cdc:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802cdf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ce3:	75 68                	jne    802d4d <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802ce5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce9:	75 17                	jne    802d02 <insert_sorted_with_merge_freeList+0x41>
  802ceb:	83 ec 04             	sub    $0x4,%esp
  802cee:	68 54 3f 80 00       	push   $0x803f54
  802cf3:	68 da 00 00 00       	push   $0xda
  802cf8:	68 77 3f 80 00       	push   $0x803f77
  802cfd:	e8 df d9 ff ff       	call   8006e1 <_panic>
  802d02:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d08:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0b:	89 10                	mov    %edx,(%eax)
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d10:	8b 00                	mov    (%eax),%eax
  802d12:	85 c0                	test   %eax,%eax
  802d14:	74 0d                	je     802d23 <insert_sorted_with_merge_freeList+0x62>
  802d16:	a1 38 51 80 00       	mov    0x805138,%eax
  802d1b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d1e:	89 50 04             	mov    %edx,0x4(%eax)
  802d21:	eb 08                	jmp    802d2b <insert_sorted_with_merge_freeList+0x6a>
  802d23:	8b 45 08             	mov    0x8(%ebp),%eax
  802d26:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	a3 38 51 80 00       	mov    %eax,0x805138
  802d33:	8b 45 08             	mov    0x8(%ebp),%eax
  802d36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d3d:	a1 44 51 80 00       	mov    0x805144,%eax
  802d42:	40                   	inc    %eax
  802d43:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802d48:	e9 49 07 00 00       	jmp    803496 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802d4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d50:	8b 50 08             	mov    0x8(%eax),%edx
  802d53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d56:	8b 40 0c             	mov    0xc(%eax),%eax
  802d59:	01 c2                	add    %eax,%edx
  802d5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5e:	8b 40 08             	mov    0x8(%eax),%eax
  802d61:	39 c2                	cmp    %eax,%edx
  802d63:	73 77                	jae    802ddc <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802d65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d68:	8b 00                	mov    (%eax),%eax
  802d6a:	85 c0                	test   %eax,%eax
  802d6c:	75 6e                	jne    802ddc <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802d6e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d72:	74 68                	je     802ddc <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802d74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d78:	75 17                	jne    802d91 <insert_sorted_with_merge_freeList+0xd0>
  802d7a:	83 ec 04             	sub    $0x4,%esp
  802d7d:	68 90 3f 80 00       	push   $0x803f90
  802d82:	68 e0 00 00 00       	push   $0xe0
  802d87:	68 77 3f 80 00       	push   $0x803f77
  802d8c:	e8 50 d9 ff ff       	call   8006e1 <_panic>
  802d91:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	89 50 04             	mov    %edx,0x4(%eax)
  802d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802da0:	8b 40 04             	mov    0x4(%eax),%eax
  802da3:	85 c0                	test   %eax,%eax
  802da5:	74 0c                	je     802db3 <insert_sorted_with_merge_freeList+0xf2>
  802da7:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802dac:	8b 55 08             	mov    0x8(%ebp),%edx
  802daf:	89 10                	mov    %edx,(%eax)
  802db1:	eb 08                	jmp    802dbb <insert_sorted_with_merge_freeList+0xfa>
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	a3 38 51 80 00       	mov    %eax,0x805138
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dcc:	a1 44 51 80 00       	mov    0x805144,%eax
  802dd1:	40                   	inc    %eax
  802dd2:	a3 44 51 80 00       	mov    %eax,0x805144
  802dd7:	e9 ba 06 00 00       	jmp    803496 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	8b 50 0c             	mov    0xc(%eax),%edx
  802de2:	8b 45 08             	mov    0x8(%ebp),%eax
  802de5:	8b 40 08             	mov    0x8(%eax),%eax
  802de8:	01 c2                	add    %eax,%edx
  802dea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ded:	8b 40 08             	mov    0x8(%eax),%eax
  802df0:	39 c2                	cmp    %eax,%edx
  802df2:	73 78                	jae    802e6c <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	8b 40 04             	mov    0x4(%eax),%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	75 6e                	jne    802e6c <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802dfe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e02:	74 68                	je     802e6c <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802e04:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e08:	75 17                	jne    802e21 <insert_sorted_with_merge_freeList+0x160>
  802e0a:	83 ec 04             	sub    $0x4,%esp
  802e0d:	68 54 3f 80 00       	push   $0x803f54
  802e12:	68 e6 00 00 00       	push   $0xe6
  802e17:	68 77 3f 80 00       	push   $0x803f77
  802e1c:	e8 c0 d8 ff ff       	call   8006e1 <_panic>
  802e21:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	89 10                	mov    %edx,(%eax)
  802e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2f:	8b 00                	mov    (%eax),%eax
  802e31:	85 c0                	test   %eax,%eax
  802e33:	74 0d                	je     802e42 <insert_sorted_with_merge_freeList+0x181>
  802e35:	a1 38 51 80 00       	mov    0x805138,%eax
  802e3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3d:	89 50 04             	mov    %edx,0x4(%eax)
  802e40:	eb 08                	jmp    802e4a <insert_sorted_with_merge_freeList+0x189>
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4d:	a3 38 51 80 00       	mov    %eax,0x805138
  802e52:	8b 45 08             	mov    0x8(%ebp),%eax
  802e55:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5c:	a1 44 51 80 00       	mov    0x805144,%eax
  802e61:	40                   	inc    %eax
  802e62:	a3 44 51 80 00       	mov    %eax,0x805144
  802e67:	e9 2a 06 00 00       	jmp    803496 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802e6c:	a1 38 51 80 00       	mov    0x805138,%eax
  802e71:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e74:	e9 ed 05 00 00       	jmp    803466 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7c:	8b 00                	mov    (%eax),%eax
  802e7e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802e81:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e85:	0f 84 a7 00 00 00    	je     802f32 <insert_sorted_with_merge_freeList+0x271>
  802e8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e94:	8b 40 08             	mov    0x8(%eax),%eax
  802e97:	01 c2                	add    %eax,%edx
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	8b 40 08             	mov    0x8(%eax),%eax
  802e9f:	39 c2                	cmp    %eax,%edx
  802ea1:	0f 83 8b 00 00 00    	jae    802f32 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	8b 50 0c             	mov    0xc(%eax),%edx
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	8b 40 08             	mov    0x8(%eax),%eax
  802eb3:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802eb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb8:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802ebb:	39 c2                	cmp    %eax,%edx
  802ebd:	73 73                	jae    802f32 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802ebf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec3:	74 06                	je     802ecb <insert_sorted_with_merge_freeList+0x20a>
  802ec5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec9:	75 17                	jne    802ee2 <insert_sorted_with_merge_freeList+0x221>
  802ecb:	83 ec 04             	sub    $0x4,%esp
  802ece:	68 08 40 80 00       	push   $0x804008
  802ed3:	68 f0 00 00 00       	push   $0xf0
  802ed8:	68 77 3f 80 00       	push   $0x803f77
  802edd:	e8 ff d7 ff ff       	call   8006e1 <_panic>
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	8b 10                	mov    (%eax),%edx
  802ee7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eea:	89 10                	mov    %edx,(%eax)
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	8b 00                	mov    (%eax),%eax
  802ef1:	85 c0                	test   %eax,%eax
  802ef3:	74 0b                	je     802f00 <insert_sorted_with_merge_freeList+0x23f>
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	8b 00                	mov    (%eax),%eax
  802efa:	8b 55 08             	mov    0x8(%ebp),%edx
  802efd:	89 50 04             	mov    %edx,0x4(%eax)
  802f00:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f03:	8b 55 08             	mov    0x8(%ebp),%edx
  802f06:	89 10                	mov    %edx,(%eax)
  802f08:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f0e:	89 50 04             	mov    %edx,0x4(%eax)
  802f11:	8b 45 08             	mov    0x8(%ebp),%eax
  802f14:	8b 00                	mov    (%eax),%eax
  802f16:	85 c0                	test   %eax,%eax
  802f18:	75 08                	jne    802f22 <insert_sorted_with_merge_freeList+0x261>
  802f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1d:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f22:	a1 44 51 80 00       	mov    0x805144,%eax
  802f27:	40                   	inc    %eax
  802f28:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  802f2d:	e9 64 05 00 00       	jmp    803496 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802f32:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f37:	8b 50 0c             	mov    0xc(%eax),%edx
  802f3a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f3f:	8b 40 08             	mov    0x8(%eax),%eax
  802f42:	01 c2                	add    %eax,%edx
  802f44:	8b 45 08             	mov    0x8(%ebp),%eax
  802f47:	8b 40 08             	mov    0x8(%eax),%eax
  802f4a:	39 c2                	cmp    %eax,%edx
  802f4c:	0f 85 b1 00 00 00    	jne    803003 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802f52:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f57:	85 c0                	test   %eax,%eax
  802f59:	0f 84 a4 00 00 00    	je     803003 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802f5f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	0f 85 95 00 00 00    	jne    803003 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802f6e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f73:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802f79:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802f7c:	8b 55 08             	mov    0x8(%ebp),%edx
  802f7f:	8b 52 0c             	mov    0xc(%edx),%edx
  802f82:	01 ca                	add    %ecx,%edx
  802f84:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802f91:	8b 45 08             	mov    0x8(%ebp),%eax
  802f94:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802f9b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f9f:	75 17                	jne    802fb8 <insert_sorted_with_merge_freeList+0x2f7>
  802fa1:	83 ec 04             	sub    $0x4,%esp
  802fa4:	68 54 3f 80 00       	push   $0x803f54
  802fa9:	68 ff 00 00 00       	push   $0xff
  802fae:	68 77 3f 80 00       	push   $0x803f77
  802fb3:	e8 29 d7 ff ff       	call   8006e1 <_panic>
  802fb8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc1:	89 10                	mov    %edx,(%eax)
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	85 c0                	test   %eax,%eax
  802fca:	74 0d                	je     802fd9 <insert_sorted_with_merge_freeList+0x318>
  802fcc:	a1 48 51 80 00       	mov    0x805148,%eax
  802fd1:	8b 55 08             	mov    0x8(%ebp),%edx
  802fd4:	89 50 04             	mov    %edx,0x4(%eax)
  802fd7:	eb 08                	jmp    802fe1 <insert_sorted_with_merge_freeList+0x320>
  802fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	a3 48 51 80 00       	mov    %eax,0x805148
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff3:	a1 54 51 80 00       	mov    0x805154,%eax
  802ff8:	40                   	inc    %eax
  802ff9:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  802ffe:	e9 93 04 00 00       	jmp    803496 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  803003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803006:	8b 50 08             	mov    0x8(%eax),%edx
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	8b 40 0c             	mov    0xc(%eax),%eax
  80300f:	01 c2                	add    %eax,%edx
  803011:	8b 45 08             	mov    0x8(%ebp),%eax
  803014:	8b 40 08             	mov    0x8(%eax),%eax
  803017:	39 c2                	cmp    %eax,%edx
  803019:	0f 85 ae 00 00 00    	jne    8030cd <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  80301f:	8b 45 08             	mov    0x8(%ebp),%eax
  803022:	8b 50 0c             	mov    0xc(%eax),%edx
  803025:	8b 45 08             	mov    0x8(%ebp),%eax
  803028:	8b 40 08             	mov    0x8(%eax),%eax
  80302b:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  80302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803030:	8b 00                	mov    (%eax),%eax
  803032:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803035:	39 c2                	cmp    %eax,%edx
  803037:	0f 84 90 00 00 00    	je     8030cd <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	8b 50 0c             	mov    0xc(%eax),%edx
  803043:	8b 45 08             	mov    0x8(%ebp),%eax
  803046:	8b 40 0c             	mov    0xc(%eax),%eax
  803049:	01 c2                	add    %eax,%edx
  80304b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304e:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803051:	8b 45 08             	mov    0x8(%ebp),%eax
  803054:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80305b:	8b 45 08             	mov    0x8(%ebp),%eax
  80305e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803065:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803069:	75 17                	jne    803082 <insert_sorted_with_merge_freeList+0x3c1>
  80306b:	83 ec 04             	sub    $0x4,%esp
  80306e:	68 54 3f 80 00       	push   $0x803f54
  803073:	68 0b 01 00 00       	push   $0x10b
  803078:	68 77 3f 80 00       	push   $0x803f77
  80307d:	e8 5f d6 ff ff       	call   8006e1 <_panic>
  803082:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803088:	8b 45 08             	mov    0x8(%ebp),%eax
  80308b:	89 10                	mov    %edx,(%eax)
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	8b 00                	mov    (%eax),%eax
  803092:	85 c0                	test   %eax,%eax
  803094:	74 0d                	je     8030a3 <insert_sorted_with_merge_freeList+0x3e2>
  803096:	a1 48 51 80 00       	mov    0x805148,%eax
  80309b:	8b 55 08             	mov    0x8(%ebp),%edx
  80309e:	89 50 04             	mov    %edx,0x4(%eax)
  8030a1:	eb 08                	jmp    8030ab <insert_sorted_with_merge_freeList+0x3ea>
  8030a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a6:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8030ae:	a3 48 51 80 00       	mov    %eax,0x805148
  8030b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030b6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030bd:	a1 54 51 80 00       	mov    0x805154,%eax
  8030c2:	40                   	inc    %eax
  8030c3:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8030c8:	e9 c9 03 00 00       	jmp    803496 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8030cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d0:	8b 50 0c             	mov    0xc(%eax),%edx
  8030d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d6:	8b 40 08             	mov    0x8(%eax),%eax
  8030d9:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  8030db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030de:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8030e1:	39 c2                	cmp    %eax,%edx
  8030e3:	0f 85 bb 00 00 00    	jne    8031a4 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  8030e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ed:	0f 84 b1 00 00 00    	je     8031a4 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  8030f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f6:	8b 40 04             	mov    0x4(%eax),%eax
  8030f9:	85 c0                	test   %eax,%eax
  8030fb:	0f 85 a3 00 00 00    	jne    8031a4 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  803101:	a1 38 51 80 00       	mov    0x805138,%eax
  803106:	8b 55 08             	mov    0x8(%ebp),%edx
  803109:	8b 52 08             	mov    0x8(%edx),%edx
  80310c:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  80310f:	a1 38 51 80 00       	mov    0x805138,%eax
  803114:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80311a:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80311d:	8b 55 08             	mov    0x8(%ebp),%edx
  803120:	8b 52 0c             	mov    0xc(%edx),%edx
  803123:	01 ca                	add    %ecx,%edx
  803125:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803128:	8b 45 08             	mov    0x8(%ebp),%eax
  80312b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80313c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803140:	75 17                	jne    803159 <insert_sorted_with_merge_freeList+0x498>
  803142:	83 ec 04             	sub    $0x4,%esp
  803145:	68 54 3f 80 00       	push   $0x803f54
  80314a:	68 17 01 00 00       	push   $0x117
  80314f:	68 77 3f 80 00       	push   $0x803f77
  803154:	e8 88 d5 ff ff       	call   8006e1 <_panic>
  803159:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80315f:	8b 45 08             	mov    0x8(%ebp),%eax
  803162:	89 10                	mov    %edx,(%eax)
  803164:	8b 45 08             	mov    0x8(%ebp),%eax
  803167:	8b 00                	mov    (%eax),%eax
  803169:	85 c0                	test   %eax,%eax
  80316b:	74 0d                	je     80317a <insert_sorted_with_merge_freeList+0x4b9>
  80316d:	a1 48 51 80 00       	mov    0x805148,%eax
  803172:	8b 55 08             	mov    0x8(%ebp),%edx
  803175:	89 50 04             	mov    %edx,0x4(%eax)
  803178:	eb 08                	jmp    803182 <insert_sorted_with_merge_freeList+0x4c1>
  80317a:	8b 45 08             	mov    0x8(%ebp),%eax
  80317d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803182:	8b 45 08             	mov    0x8(%ebp),%eax
  803185:	a3 48 51 80 00       	mov    %eax,0x805148
  80318a:	8b 45 08             	mov    0x8(%ebp),%eax
  80318d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803194:	a1 54 51 80 00       	mov    0x805154,%eax
  803199:	40                   	inc    %eax
  80319a:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80319f:	e9 f2 02 00 00       	jmp    803496 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	8b 50 08             	mov    0x8(%eax),%edx
  8031aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ad:	8b 40 0c             	mov    0xc(%eax),%eax
  8031b0:	01 c2                	add    %eax,%edx
  8031b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b5:	8b 40 08             	mov    0x8(%eax),%eax
  8031b8:	39 c2                	cmp    %eax,%edx
  8031ba:	0f 85 be 00 00 00    	jne    80327e <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  8031c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031c3:	8b 40 04             	mov    0x4(%eax),%eax
  8031c6:	8b 50 08             	mov    0x8(%eax),%edx
  8031c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031cc:	8b 40 04             	mov    0x4(%eax),%eax
  8031cf:	8b 40 0c             	mov    0xc(%eax),%eax
  8031d2:	01 c2                	add    %eax,%edx
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	8b 40 08             	mov    0x8(%eax),%eax
  8031da:	39 c2                	cmp    %eax,%edx
  8031dc:	0f 84 9c 00 00 00    	je     80327e <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  8031e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e5:	8b 50 08             	mov    0x8(%eax),%edx
  8031e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031eb:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  8031ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f1:	8b 50 0c             	mov    0xc(%eax),%edx
  8031f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8031fa:	01 c2                	add    %eax,%edx
  8031fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031ff:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803202:	8b 45 08             	mov    0x8(%ebp),%eax
  803205:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803216:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80321a:	75 17                	jne    803233 <insert_sorted_with_merge_freeList+0x572>
  80321c:	83 ec 04             	sub    $0x4,%esp
  80321f:	68 54 3f 80 00       	push   $0x803f54
  803224:	68 26 01 00 00       	push   $0x126
  803229:	68 77 3f 80 00       	push   $0x803f77
  80322e:	e8 ae d4 ff ff       	call   8006e1 <_panic>
  803233:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803239:	8b 45 08             	mov    0x8(%ebp),%eax
  80323c:	89 10                	mov    %edx,(%eax)
  80323e:	8b 45 08             	mov    0x8(%ebp),%eax
  803241:	8b 00                	mov    (%eax),%eax
  803243:	85 c0                	test   %eax,%eax
  803245:	74 0d                	je     803254 <insert_sorted_with_merge_freeList+0x593>
  803247:	a1 48 51 80 00       	mov    0x805148,%eax
  80324c:	8b 55 08             	mov    0x8(%ebp),%edx
  80324f:	89 50 04             	mov    %edx,0x4(%eax)
  803252:	eb 08                	jmp    80325c <insert_sorted_with_merge_freeList+0x59b>
  803254:	8b 45 08             	mov    0x8(%ebp),%eax
  803257:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	a3 48 51 80 00       	mov    %eax,0x805148
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80326e:	a1 54 51 80 00       	mov    0x805154,%eax
  803273:	40                   	inc    %eax
  803274:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  803279:	e9 18 02 00 00       	jmp    803496 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  80327e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803281:	8b 50 0c             	mov    0xc(%eax),%edx
  803284:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803287:	8b 40 08             	mov    0x8(%eax),%eax
  80328a:	01 c2                	add    %eax,%edx
  80328c:	8b 45 08             	mov    0x8(%ebp),%eax
  80328f:	8b 40 08             	mov    0x8(%eax),%eax
  803292:	39 c2                	cmp    %eax,%edx
  803294:	0f 85 c4 01 00 00    	jne    80345e <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  80329a:	8b 45 08             	mov    0x8(%ebp),%eax
  80329d:	8b 50 0c             	mov    0xc(%eax),%edx
  8032a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a3:	8b 40 08             	mov    0x8(%eax),%eax
  8032a6:	01 c2                	add    %eax,%edx
  8032a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ab:	8b 00                	mov    (%eax),%eax
  8032ad:	8b 40 08             	mov    0x8(%eax),%eax
  8032b0:	39 c2                	cmp    %eax,%edx
  8032b2:	0f 85 a6 01 00 00    	jne    80345e <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  8032b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032bc:	0f 84 9c 01 00 00    	je     80345e <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  8032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c5:	8b 50 0c             	mov    0xc(%eax),%edx
  8032c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8032ce:	01 c2                	add    %eax,%edx
  8032d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032d3:	8b 00                	mov    (%eax),%eax
  8032d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8032d8:	01 c2                	add    %eax,%edx
  8032da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032dd:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8032e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8032ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8032f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032f8:	75 17                	jne    803311 <insert_sorted_with_merge_freeList+0x650>
  8032fa:	83 ec 04             	sub    $0x4,%esp
  8032fd:	68 54 3f 80 00       	push   $0x803f54
  803302:	68 32 01 00 00       	push   $0x132
  803307:	68 77 3f 80 00       	push   $0x803f77
  80330c:	e8 d0 d3 ff ff       	call   8006e1 <_panic>
  803311:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803317:	8b 45 08             	mov    0x8(%ebp),%eax
  80331a:	89 10                	mov    %edx,(%eax)
  80331c:	8b 45 08             	mov    0x8(%ebp),%eax
  80331f:	8b 00                	mov    (%eax),%eax
  803321:	85 c0                	test   %eax,%eax
  803323:	74 0d                	je     803332 <insert_sorted_with_merge_freeList+0x671>
  803325:	a1 48 51 80 00       	mov    0x805148,%eax
  80332a:	8b 55 08             	mov    0x8(%ebp),%edx
  80332d:	89 50 04             	mov    %edx,0x4(%eax)
  803330:	eb 08                	jmp    80333a <insert_sorted_with_merge_freeList+0x679>
  803332:	8b 45 08             	mov    0x8(%ebp),%eax
  803335:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80333a:	8b 45 08             	mov    0x8(%ebp),%eax
  80333d:	a3 48 51 80 00       	mov    %eax,0x805148
  803342:	8b 45 08             	mov    0x8(%ebp),%eax
  803345:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80334c:	a1 54 51 80 00       	mov    0x805154,%eax
  803351:	40                   	inc    %eax
  803352:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803357:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335a:	8b 00                	mov    (%eax),%eax
  80335c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803366:	8b 00                	mov    (%eax),%eax
  803368:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  80336f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803372:	8b 00                	mov    (%eax),%eax
  803374:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803377:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80337b:	75 17                	jne    803394 <insert_sorted_with_merge_freeList+0x6d3>
  80337d:	83 ec 04             	sub    $0x4,%esp
  803380:	68 e9 3f 80 00       	push   $0x803fe9
  803385:	68 36 01 00 00       	push   $0x136
  80338a:	68 77 3f 80 00       	push   $0x803f77
  80338f:	e8 4d d3 ff ff       	call   8006e1 <_panic>
  803394:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803397:	8b 00                	mov    (%eax),%eax
  803399:	85 c0                	test   %eax,%eax
  80339b:	74 10                	je     8033ad <insert_sorted_with_merge_freeList+0x6ec>
  80339d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033a0:	8b 00                	mov    (%eax),%eax
  8033a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033a5:	8b 52 04             	mov    0x4(%edx),%edx
  8033a8:	89 50 04             	mov    %edx,0x4(%eax)
  8033ab:	eb 0b                	jmp    8033b8 <insert_sorted_with_merge_freeList+0x6f7>
  8033ad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033b0:	8b 40 04             	mov    0x4(%eax),%eax
  8033b3:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033bb:	8b 40 04             	mov    0x4(%eax),%eax
  8033be:	85 c0                	test   %eax,%eax
  8033c0:	74 0f                	je     8033d1 <insert_sorted_with_merge_freeList+0x710>
  8033c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033c5:	8b 40 04             	mov    0x4(%eax),%eax
  8033c8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033cb:	8b 12                	mov    (%edx),%edx
  8033cd:	89 10                	mov    %edx,(%eax)
  8033cf:	eb 0a                	jmp    8033db <insert_sorted_with_merge_freeList+0x71a>
  8033d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d4:	8b 00                	mov    (%eax),%eax
  8033d6:	a3 38 51 80 00       	mov    %eax,0x805138
  8033db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033de:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8033e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033e7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033ee:	a1 44 51 80 00       	mov    0x805144,%eax
  8033f3:	48                   	dec    %eax
  8033f4:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8033f9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033fd:	75 17                	jne    803416 <insert_sorted_with_merge_freeList+0x755>
  8033ff:	83 ec 04             	sub    $0x4,%esp
  803402:	68 54 3f 80 00       	push   $0x803f54
  803407:	68 37 01 00 00       	push   $0x137
  80340c:	68 77 3f 80 00       	push   $0x803f77
  803411:	e8 cb d2 ff ff       	call   8006e1 <_panic>
  803416:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80341c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341f:	89 10                	mov    %edx,(%eax)
  803421:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803424:	8b 00                	mov    (%eax),%eax
  803426:	85 c0                	test   %eax,%eax
  803428:	74 0d                	je     803437 <insert_sorted_with_merge_freeList+0x776>
  80342a:	a1 48 51 80 00       	mov    0x805148,%eax
  80342f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803432:	89 50 04             	mov    %edx,0x4(%eax)
  803435:	eb 08                	jmp    80343f <insert_sorted_with_merge_freeList+0x77e>
  803437:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80343a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80343f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803442:	a3 48 51 80 00       	mov    %eax,0x805148
  803447:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80344a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803451:	a1 54 51 80 00       	mov    0x805154,%eax
  803456:	40                   	inc    %eax
  803457:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  80345c:	eb 38                	jmp    803496 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80345e:	a1 40 51 80 00       	mov    0x805140,%eax
  803463:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803466:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80346a:	74 07                	je     803473 <insert_sorted_with_merge_freeList+0x7b2>
  80346c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80346f:	8b 00                	mov    (%eax),%eax
  803471:	eb 05                	jmp    803478 <insert_sorted_with_merge_freeList+0x7b7>
  803473:	b8 00 00 00 00       	mov    $0x0,%eax
  803478:	a3 40 51 80 00       	mov    %eax,0x805140
  80347d:	a1 40 51 80 00       	mov    0x805140,%eax
  803482:	85 c0                	test   %eax,%eax
  803484:	0f 85 ef f9 ff ff    	jne    802e79 <insert_sorted_with_merge_freeList+0x1b8>
  80348a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80348e:	0f 85 e5 f9 ff ff    	jne    802e79 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803494:	eb 00                	jmp    803496 <insert_sorted_with_merge_freeList+0x7d5>
  803496:	90                   	nop
  803497:	c9                   	leave  
  803498:	c3                   	ret    
  803499:	66 90                	xchg   %ax,%ax
  80349b:	90                   	nop

0080349c <__udivdi3>:
  80349c:	55                   	push   %ebp
  80349d:	57                   	push   %edi
  80349e:	56                   	push   %esi
  80349f:	53                   	push   %ebx
  8034a0:	83 ec 1c             	sub    $0x1c,%esp
  8034a3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8034a7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8034ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8034af:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8034b3:	89 ca                	mov    %ecx,%edx
  8034b5:	89 f8                	mov    %edi,%eax
  8034b7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8034bb:	85 f6                	test   %esi,%esi
  8034bd:	75 2d                	jne    8034ec <__udivdi3+0x50>
  8034bf:	39 cf                	cmp    %ecx,%edi
  8034c1:	77 65                	ja     803528 <__udivdi3+0x8c>
  8034c3:	89 fd                	mov    %edi,%ebp
  8034c5:	85 ff                	test   %edi,%edi
  8034c7:	75 0b                	jne    8034d4 <__udivdi3+0x38>
  8034c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8034ce:	31 d2                	xor    %edx,%edx
  8034d0:	f7 f7                	div    %edi
  8034d2:	89 c5                	mov    %eax,%ebp
  8034d4:	31 d2                	xor    %edx,%edx
  8034d6:	89 c8                	mov    %ecx,%eax
  8034d8:	f7 f5                	div    %ebp
  8034da:	89 c1                	mov    %eax,%ecx
  8034dc:	89 d8                	mov    %ebx,%eax
  8034de:	f7 f5                	div    %ebp
  8034e0:	89 cf                	mov    %ecx,%edi
  8034e2:	89 fa                	mov    %edi,%edx
  8034e4:	83 c4 1c             	add    $0x1c,%esp
  8034e7:	5b                   	pop    %ebx
  8034e8:	5e                   	pop    %esi
  8034e9:	5f                   	pop    %edi
  8034ea:	5d                   	pop    %ebp
  8034eb:	c3                   	ret    
  8034ec:	39 ce                	cmp    %ecx,%esi
  8034ee:	77 28                	ja     803518 <__udivdi3+0x7c>
  8034f0:	0f bd fe             	bsr    %esi,%edi
  8034f3:	83 f7 1f             	xor    $0x1f,%edi
  8034f6:	75 40                	jne    803538 <__udivdi3+0x9c>
  8034f8:	39 ce                	cmp    %ecx,%esi
  8034fa:	72 0a                	jb     803506 <__udivdi3+0x6a>
  8034fc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803500:	0f 87 9e 00 00 00    	ja     8035a4 <__udivdi3+0x108>
  803506:	b8 01 00 00 00       	mov    $0x1,%eax
  80350b:	89 fa                	mov    %edi,%edx
  80350d:	83 c4 1c             	add    $0x1c,%esp
  803510:	5b                   	pop    %ebx
  803511:	5e                   	pop    %esi
  803512:	5f                   	pop    %edi
  803513:	5d                   	pop    %ebp
  803514:	c3                   	ret    
  803515:	8d 76 00             	lea    0x0(%esi),%esi
  803518:	31 ff                	xor    %edi,%edi
  80351a:	31 c0                	xor    %eax,%eax
  80351c:	89 fa                	mov    %edi,%edx
  80351e:	83 c4 1c             	add    $0x1c,%esp
  803521:	5b                   	pop    %ebx
  803522:	5e                   	pop    %esi
  803523:	5f                   	pop    %edi
  803524:	5d                   	pop    %ebp
  803525:	c3                   	ret    
  803526:	66 90                	xchg   %ax,%ax
  803528:	89 d8                	mov    %ebx,%eax
  80352a:	f7 f7                	div    %edi
  80352c:	31 ff                	xor    %edi,%edi
  80352e:	89 fa                	mov    %edi,%edx
  803530:	83 c4 1c             	add    $0x1c,%esp
  803533:	5b                   	pop    %ebx
  803534:	5e                   	pop    %esi
  803535:	5f                   	pop    %edi
  803536:	5d                   	pop    %ebp
  803537:	c3                   	ret    
  803538:	bd 20 00 00 00       	mov    $0x20,%ebp
  80353d:	89 eb                	mov    %ebp,%ebx
  80353f:	29 fb                	sub    %edi,%ebx
  803541:	89 f9                	mov    %edi,%ecx
  803543:	d3 e6                	shl    %cl,%esi
  803545:	89 c5                	mov    %eax,%ebp
  803547:	88 d9                	mov    %bl,%cl
  803549:	d3 ed                	shr    %cl,%ebp
  80354b:	89 e9                	mov    %ebp,%ecx
  80354d:	09 f1                	or     %esi,%ecx
  80354f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803553:	89 f9                	mov    %edi,%ecx
  803555:	d3 e0                	shl    %cl,%eax
  803557:	89 c5                	mov    %eax,%ebp
  803559:	89 d6                	mov    %edx,%esi
  80355b:	88 d9                	mov    %bl,%cl
  80355d:	d3 ee                	shr    %cl,%esi
  80355f:	89 f9                	mov    %edi,%ecx
  803561:	d3 e2                	shl    %cl,%edx
  803563:	8b 44 24 08          	mov    0x8(%esp),%eax
  803567:	88 d9                	mov    %bl,%cl
  803569:	d3 e8                	shr    %cl,%eax
  80356b:	09 c2                	or     %eax,%edx
  80356d:	89 d0                	mov    %edx,%eax
  80356f:	89 f2                	mov    %esi,%edx
  803571:	f7 74 24 0c          	divl   0xc(%esp)
  803575:	89 d6                	mov    %edx,%esi
  803577:	89 c3                	mov    %eax,%ebx
  803579:	f7 e5                	mul    %ebp
  80357b:	39 d6                	cmp    %edx,%esi
  80357d:	72 19                	jb     803598 <__udivdi3+0xfc>
  80357f:	74 0b                	je     80358c <__udivdi3+0xf0>
  803581:	89 d8                	mov    %ebx,%eax
  803583:	31 ff                	xor    %edi,%edi
  803585:	e9 58 ff ff ff       	jmp    8034e2 <__udivdi3+0x46>
  80358a:	66 90                	xchg   %ax,%ax
  80358c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803590:	89 f9                	mov    %edi,%ecx
  803592:	d3 e2                	shl    %cl,%edx
  803594:	39 c2                	cmp    %eax,%edx
  803596:	73 e9                	jae    803581 <__udivdi3+0xe5>
  803598:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80359b:	31 ff                	xor    %edi,%edi
  80359d:	e9 40 ff ff ff       	jmp    8034e2 <__udivdi3+0x46>
  8035a2:	66 90                	xchg   %ax,%ax
  8035a4:	31 c0                	xor    %eax,%eax
  8035a6:	e9 37 ff ff ff       	jmp    8034e2 <__udivdi3+0x46>
  8035ab:	90                   	nop

008035ac <__umoddi3>:
  8035ac:	55                   	push   %ebp
  8035ad:	57                   	push   %edi
  8035ae:	56                   	push   %esi
  8035af:	53                   	push   %ebx
  8035b0:	83 ec 1c             	sub    $0x1c,%esp
  8035b3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8035b7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8035bb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8035bf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8035c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8035c7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8035cb:	89 f3                	mov    %esi,%ebx
  8035cd:	89 fa                	mov    %edi,%edx
  8035cf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8035d3:	89 34 24             	mov    %esi,(%esp)
  8035d6:	85 c0                	test   %eax,%eax
  8035d8:	75 1a                	jne    8035f4 <__umoddi3+0x48>
  8035da:	39 f7                	cmp    %esi,%edi
  8035dc:	0f 86 a2 00 00 00    	jbe    803684 <__umoddi3+0xd8>
  8035e2:	89 c8                	mov    %ecx,%eax
  8035e4:	89 f2                	mov    %esi,%edx
  8035e6:	f7 f7                	div    %edi
  8035e8:	89 d0                	mov    %edx,%eax
  8035ea:	31 d2                	xor    %edx,%edx
  8035ec:	83 c4 1c             	add    $0x1c,%esp
  8035ef:	5b                   	pop    %ebx
  8035f0:	5e                   	pop    %esi
  8035f1:	5f                   	pop    %edi
  8035f2:	5d                   	pop    %ebp
  8035f3:	c3                   	ret    
  8035f4:	39 f0                	cmp    %esi,%eax
  8035f6:	0f 87 ac 00 00 00    	ja     8036a8 <__umoddi3+0xfc>
  8035fc:	0f bd e8             	bsr    %eax,%ebp
  8035ff:	83 f5 1f             	xor    $0x1f,%ebp
  803602:	0f 84 ac 00 00 00    	je     8036b4 <__umoddi3+0x108>
  803608:	bf 20 00 00 00       	mov    $0x20,%edi
  80360d:	29 ef                	sub    %ebp,%edi
  80360f:	89 fe                	mov    %edi,%esi
  803611:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803615:	89 e9                	mov    %ebp,%ecx
  803617:	d3 e0                	shl    %cl,%eax
  803619:	89 d7                	mov    %edx,%edi
  80361b:	89 f1                	mov    %esi,%ecx
  80361d:	d3 ef                	shr    %cl,%edi
  80361f:	09 c7                	or     %eax,%edi
  803621:	89 e9                	mov    %ebp,%ecx
  803623:	d3 e2                	shl    %cl,%edx
  803625:	89 14 24             	mov    %edx,(%esp)
  803628:	89 d8                	mov    %ebx,%eax
  80362a:	d3 e0                	shl    %cl,%eax
  80362c:	89 c2                	mov    %eax,%edx
  80362e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803632:	d3 e0                	shl    %cl,%eax
  803634:	89 44 24 04          	mov    %eax,0x4(%esp)
  803638:	8b 44 24 08          	mov    0x8(%esp),%eax
  80363c:	89 f1                	mov    %esi,%ecx
  80363e:	d3 e8                	shr    %cl,%eax
  803640:	09 d0                	or     %edx,%eax
  803642:	d3 eb                	shr    %cl,%ebx
  803644:	89 da                	mov    %ebx,%edx
  803646:	f7 f7                	div    %edi
  803648:	89 d3                	mov    %edx,%ebx
  80364a:	f7 24 24             	mull   (%esp)
  80364d:	89 c6                	mov    %eax,%esi
  80364f:	89 d1                	mov    %edx,%ecx
  803651:	39 d3                	cmp    %edx,%ebx
  803653:	0f 82 87 00 00 00    	jb     8036e0 <__umoddi3+0x134>
  803659:	0f 84 91 00 00 00    	je     8036f0 <__umoddi3+0x144>
  80365f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803663:	29 f2                	sub    %esi,%edx
  803665:	19 cb                	sbb    %ecx,%ebx
  803667:	89 d8                	mov    %ebx,%eax
  803669:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80366d:	d3 e0                	shl    %cl,%eax
  80366f:	89 e9                	mov    %ebp,%ecx
  803671:	d3 ea                	shr    %cl,%edx
  803673:	09 d0                	or     %edx,%eax
  803675:	89 e9                	mov    %ebp,%ecx
  803677:	d3 eb                	shr    %cl,%ebx
  803679:	89 da                	mov    %ebx,%edx
  80367b:	83 c4 1c             	add    $0x1c,%esp
  80367e:	5b                   	pop    %ebx
  80367f:	5e                   	pop    %esi
  803680:	5f                   	pop    %edi
  803681:	5d                   	pop    %ebp
  803682:	c3                   	ret    
  803683:	90                   	nop
  803684:	89 fd                	mov    %edi,%ebp
  803686:	85 ff                	test   %edi,%edi
  803688:	75 0b                	jne    803695 <__umoddi3+0xe9>
  80368a:	b8 01 00 00 00       	mov    $0x1,%eax
  80368f:	31 d2                	xor    %edx,%edx
  803691:	f7 f7                	div    %edi
  803693:	89 c5                	mov    %eax,%ebp
  803695:	89 f0                	mov    %esi,%eax
  803697:	31 d2                	xor    %edx,%edx
  803699:	f7 f5                	div    %ebp
  80369b:	89 c8                	mov    %ecx,%eax
  80369d:	f7 f5                	div    %ebp
  80369f:	89 d0                	mov    %edx,%eax
  8036a1:	e9 44 ff ff ff       	jmp    8035ea <__umoddi3+0x3e>
  8036a6:	66 90                	xchg   %ax,%ax
  8036a8:	89 c8                	mov    %ecx,%eax
  8036aa:	89 f2                	mov    %esi,%edx
  8036ac:	83 c4 1c             	add    $0x1c,%esp
  8036af:	5b                   	pop    %ebx
  8036b0:	5e                   	pop    %esi
  8036b1:	5f                   	pop    %edi
  8036b2:	5d                   	pop    %ebp
  8036b3:	c3                   	ret    
  8036b4:	3b 04 24             	cmp    (%esp),%eax
  8036b7:	72 06                	jb     8036bf <__umoddi3+0x113>
  8036b9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8036bd:	77 0f                	ja     8036ce <__umoddi3+0x122>
  8036bf:	89 f2                	mov    %esi,%edx
  8036c1:	29 f9                	sub    %edi,%ecx
  8036c3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8036c7:	89 14 24             	mov    %edx,(%esp)
  8036ca:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036ce:	8b 44 24 04          	mov    0x4(%esp),%eax
  8036d2:	8b 14 24             	mov    (%esp),%edx
  8036d5:	83 c4 1c             	add    $0x1c,%esp
  8036d8:	5b                   	pop    %ebx
  8036d9:	5e                   	pop    %esi
  8036da:	5f                   	pop    %edi
  8036db:	5d                   	pop    %ebp
  8036dc:	c3                   	ret    
  8036dd:	8d 76 00             	lea    0x0(%esi),%esi
  8036e0:	2b 04 24             	sub    (%esp),%eax
  8036e3:	19 fa                	sbb    %edi,%edx
  8036e5:	89 d1                	mov    %edx,%ecx
  8036e7:	89 c6                	mov    %eax,%esi
  8036e9:	e9 71 ff ff ff       	jmp    80365f <__umoddi3+0xb3>
  8036ee:	66 90                	xchg   %ax,%ax
  8036f0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8036f4:	72 ea                	jb     8036e0 <__umoddi3+0x134>
  8036f6:	89 d9                	mov    %ebx,%ecx
  8036f8:	e9 62 ff ff ff       	jmp    80365f <__umoddi3+0xb3>
