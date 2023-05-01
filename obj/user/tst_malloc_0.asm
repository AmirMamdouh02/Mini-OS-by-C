
obj/user/tst_malloc_0:     file format elf32-i386


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
  800031:	e8 a3 01 00 00       	call   8001d9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003e:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800049:	eb 29                	jmp    800074 <_main+0x3c>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004b:	a1 20 40 80 00       	mov    0x804020,%eax
  800050:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800056:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800059:	89 d0                	mov    %edx,%eax
  80005b:	01 c0                	add    %eax,%eax
  80005d:	01 d0                	add    %edx,%eax
  80005f:	c1 e0 03             	shl    $0x3,%eax
  800062:	01 c8                	add    %ecx,%eax
  800064:	8a 40 04             	mov    0x4(%eax),%al
  800067:	84 c0                	test   %al,%al
  800069:	74 06                	je     800071 <_main+0x39>
			{
				fullWS = 0;
  80006b:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  80006f:	eb 12                	jmp    800083 <_main+0x4b>
void _main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800071:	ff 45 f0             	incl   -0x10(%ebp)
  800074:	a1 20 40 80 00       	mov    0x804020,%eax
  800079:	8b 50 74             	mov    0x74(%eax),%edx
  80007c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80007f:	39 c2                	cmp    %eax,%edx
  800081:	77 c8                	ja     80004b <_main+0x13>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800083:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800087:	74 14                	je     80009d <_main+0x65>
  800089:	83 ec 04             	sub    $0x4,%esp
  80008c:	68 40 33 80 00       	push   $0x803340
  800091:	6a 14                	push   $0x14
  800093:	68 5c 33 80 00       	push   $0x80335c
  800098:	e8 78 02 00 00       	call   800315 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	if(STATIC_MEMBLOCK_ALLOC != 0)
		panic("STATIC_MEMBLOCK_ALLOC = 1 & it shall be 0. Go to 'inc/dynamic_allocator.h' and set STATIC_MEMBLOCK_ALLOC by 0. Then, repeat the test again.");

	int freeFrames_before = sys_calculate_free_frames() ;
  80009d:	e8 64 19 00 00       	call   801a06 <sys_calculate_free_frames>
  8000a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeDiskFrames_before = sys_pf_calculate_allocated_pages() ;
  8000a5:	e8 fc 19 00 00       	call   801aa6 <sys_pf_calculate_allocated_pages>
  8000aa:	89 45 e8             	mov    %eax,-0x18(%ebp)
	malloc(0);
  8000ad:	83 ec 0c             	sub    $0xc,%esp
  8000b0:	6a 00                	push   $0x0
  8000b2:	e8 b1 14 00 00       	call   801568 <malloc>
  8000b7:	83 c4 10             	add    $0x10,%esp
	int freeFrames_after = sys_calculate_free_frames() ;
  8000ba:	e8 47 19 00 00       	call   801a06 <sys_calculate_free_frames>
  8000bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freeDiskFrames_after = sys_pf_calculate_allocated_pages() ;
  8000c2:	e8 df 19 00 00       	call   801aa6 <sys_pf_calculate_allocated_pages>
  8000c7:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Check MAX_MEM_BLOCK_CNT
	if(MAX_MEM_BLOCK_CNT != ((0xA0000000-0x80000000)/4096))
  8000ca:	a1 20 41 80 00       	mov    0x804120,%eax
  8000cf:	3d 00 00 02 00       	cmp    $0x20000,%eax
  8000d4:	74 14                	je     8000ea <_main+0xb2>
	{
		panic("Wrong initialize: MAX_MEM_BLOCK_CNT is not set with the correct size of the array");
  8000d6:	83 ec 04             	sub    $0x4,%esp
  8000d9:	68 70 33 80 00       	push   $0x803370
  8000de:	6a 23                	push   $0x23
  8000e0:	68 5c 33 80 00       	push   $0x80335c
  8000e5:	e8 2b 02 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in AvailableMemBlocksList
	if (LIST_SIZE(&(AvailableMemBlocksList)) != MAX_MEM_BLOCK_CNT-1)
  8000ea:	a1 54 41 80 00       	mov    0x804154,%eax
  8000ef:	8b 15 20 41 80 00    	mov    0x804120,%edx
  8000f5:	4a                   	dec    %edx
  8000f6:	39 d0                	cmp    %edx,%eax
  8000f8:	74 14                	je     80010e <_main+0xd6>
	{
		panic("Wrong initialize: Wrong size for the AvailableMemBlocksList");
  8000fa:	83 ec 04             	sub    $0x4,%esp
  8000fd:	68 c4 33 80 00       	push   $0x8033c4
  800102:	6a 29                	push   $0x29
  800104:	68 5c 33 80 00       	push   $0x80335c
  800109:	e8 07 02 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in AllocMemBlocksList
	if (LIST_SIZE(&(AllocMemBlocksList)) != 0)
  80010e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  800113:	85 c0                	test   %eax,%eax
  800115:	74 14                	je     80012b <_main+0xf3>
	{
		panic("Wrong initialize: Wrong size for the AllocMemBlocksList");
  800117:	83 ec 04             	sub    $0x4,%esp
  80011a:	68 00 34 80 00       	push   $0x803400
  80011f:	6a 2f                	push   $0x2f
  800121:	68 5c 33 80 00       	push   $0x80335c
  800126:	e8 ea 01 00 00       	call   800315 <_panic>
	}

	//Check number of nodes in FreeMemBlocksList
	if (LIST_SIZE(&(FreeMemBlocksList)) != 1)
  80012b:	a1 44 41 80 00       	mov    0x804144,%eax
  800130:	83 f8 01             	cmp    $0x1,%eax
  800133:	74 14                	je     800149 <_main+0x111>
	{
		panic("Wrong initialize: Wrong size for the FreeMemBlocksList");
  800135:	83 ec 04             	sub    $0x4,%esp
  800138:	68 38 34 80 00       	push   $0x803438
  80013d:	6a 35                	push   $0x35
  80013f:	68 5c 33 80 00       	push   $0x80335c
  800144:	e8 cc 01 00 00       	call   800315 <_panic>
	}

	//Check content of FreeMemBlocksList
	struct MemBlock* block = LIST_FIRST(&FreeMemBlocksList);
  800149:	a1 38 41 80 00       	mov    0x804138,%eax
  80014e:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(block == NULL || block->size != (0xA0000000-0x80000000) || block->sva != 0x80000000)
  800151:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800155:	74 1a                	je     800171 <_main+0x139>
  800157:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80015a:	8b 40 0c             	mov    0xc(%eax),%eax
  80015d:	3d 00 00 00 20       	cmp    $0x20000000,%eax
  800162:	75 0d                	jne    800171 <_main+0x139>
  800164:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800167:	8b 40 08             	mov    0x8(%eax),%eax
  80016a:	3d 00 00 00 80       	cmp    $0x80000000,%eax
  80016f:	74 14                	je     800185 <_main+0x14d>
	{
		panic("Wrong initialize: Wrong content for the FreeMemBlocksList.");
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	68 70 34 80 00       	push   $0x803470
  800179:	6a 3c                	push   $0x3c
  80017b:	68 5c 33 80 00       	push   $0x80335c
  800180:	e8 90 01 00 00       	call   800315 <_panic>
	}

	//Check number of disk and memory frames
	if ((freeDiskFrames_after - freeDiskFrames_before) != 0) panic("Page file is changed while it's not expected to. (pages are wrongly allocated/de-allocated in PageFile)");
  800185:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800188:	3b 45 e8             	cmp    -0x18(%ebp),%eax
  80018b:	74 14                	je     8001a1 <_main+0x169>
  80018d:	83 ec 04             	sub    $0x4,%esp
  800190:	68 ac 34 80 00       	push   $0x8034ac
  800195:	6a 40                	push   $0x40
  800197:	68 5c 33 80 00       	push   $0x80335c
  80019c:	e8 74 01 00 00       	call   800315 <_panic>
	if ((freeFrames_before - freeFrames_after) != 512 + 1) panic("Wrong allocation: pages are not loaded successfully into memory %d", (freeFrames_before - freeFrames_after));
  8001a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a4:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001a7:	3d 01 02 00 00       	cmp    $0x201,%eax
  8001ac:	74 18                	je     8001c6 <_main+0x18e>
  8001ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001b1:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001b4:	50                   	push   %eax
  8001b5:	68 14 35 80 00       	push   $0x803514
  8001ba:	6a 41                	push   $0x41
  8001bc:	68 5c 33 80 00       	push   $0x80335c
  8001c1:	e8 4f 01 00 00       	call   800315 <_panic>

	/*=================================================*/

	cprintf("Congratulations!! test initialize_dyn_block_system of UHEAP completed successfully.\n");
  8001c6:	83 ec 0c             	sub    $0xc,%esp
  8001c9:	68 58 35 80 00       	push   $0x803558
  8001ce:	e8 f6 03 00 00       	call   8005c9 <cprintf>
  8001d3:	83 c4 10             	add    $0x10,%esp

	return;
  8001d6:	90                   	nop
}
  8001d7:	c9                   	leave  
  8001d8:	c3                   	ret    

008001d9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001d9:	55                   	push   %ebp
  8001da:	89 e5                	mov    %esp,%ebp
  8001dc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001df:	e8 02 1b 00 00       	call   801ce6 <sys_getenvindex>
  8001e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001ea:	89 d0                	mov    %edx,%eax
  8001ec:	c1 e0 03             	shl    $0x3,%eax
  8001ef:	01 d0                	add    %edx,%eax
  8001f1:	01 c0                	add    %eax,%eax
  8001f3:	01 d0                	add    %edx,%eax
  8001f5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001fc:	01 d0                	add    %edx,%eax
  8001fe:	c1 e0 04             	shl    $0x4,%eax
  800201:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800206:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80020b:	a1 20 40 80 00       	mov    0x804020,%eax
  800210:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800216:	84 c0                	test   %al,%al
  800218:	74 0f                	je     800229 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	05 5c 05 00 00       	add    $0x55c,%eax
  800224:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800229:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80022d:	7e 0a                	jle    800239 <libmain+0x60>
		binaryname = argv[0];
  80022f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800232:	8b 00                	mov    (%eax),%eax
  800234:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800239:	83 ec 08             	sub    $0x8,%esp
  80023c:	ff 75 0c             	pushl  0xc(%ebp)
  80023f:	ff 75 08             	pushl  0x8(%ebp)
  800242:	e8 f1 fd ff ff       	call   800038 <_main>
  800247:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80024a:	e8 a4 18 00 00       	call   801af3 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 c8 35 80 00       	push   $0x8035c8
  800257:	e8 6d 03 00 00       	call   8005c9 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80025f:	a1 20 40 80 00       	mov    0x804020,%eax
  800264:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80026a:	a1 20 40 80 00       	mov    0x804020,%eax
  80026f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800275:	83 ec 04             	sub    $0x4,%esp
  800278:	52                   	push   %edx
  800279:	50                   	push   %eax
  80027a:	68 f0 35 80 00       	push   $0x8035f0
  80027f:	e8 45 03 00 00       	call   8005c9 <cprintf>
  800284:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800287:	a1 20 40 80 00       	mov    0x804020,%eax
  80028c:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800292:	a1 20 40 80 00       	mov    0x804020,%eax
  800297:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80029d:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a2:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002a8:	51                   	push   %ecx
  8002a9:	52                   	push   %edx
  8002aa:	50                   	push   %eax
  8002ab:	68 18 36 80 00       	push   $0x803618
  8002b0:	e8 14 03 00 00       	call   8005c9 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002bd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002c3:	83 ec 08             	sub    $0x8,%esp
  8002c6:	50                   	push   %eax
  8002c7:	68 70 36 80 00       	push   $0x803670
  8002cc:	e8 f8 02 00 00       	call   8005c9 <cprintf>
  8002d1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002d4:	83 ec 0c             	sub    $0xc,%esp
  8002d7:	68 c8 35 80 00       	push   $0x8035c8
  8002dc:	e8 e8 02 00 00       	call   8005c9 <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002e4:	e8 24 18 00 00       	call   801b0d <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002e9:	e8 19 00 00 00       	call   800307 <exit>
}
  8002ee:	90                   	nop
  8002ef:	c9                   	leave  
  8002f0:	c3                   	ret    

008002f1 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002f7:	83 ec 0c             	sub    $0xc,%esp
  8002fa:	6a 00                	push   $0x0
  8002fc:	e8 b1 19 00 00       	call   801cb2 <sys_destroy_env>
  800301:	83 c4 10             	add    $0x10,%esp
}
  800304:	90                   	nop
  800305:	c9                   	leave  
  800306:	c3                   	ret    

00800307 <exit>:

void
exit(void)
{
  800307:	55                   	push   %ebp
  800308:	89 e5                	mov    %esp,%ebp
  80030a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80030d:	e8 06 1a 00 00       	call   801d18 <sys_exit_env>
}
  800312:	90                   	nop
  800313:	c9                   	leave  
  800314:	c3                   	ret    

00800315 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800315:	55                   	push   %ebp
  800316:	89 e5                	mov    %esp,%ebp
  800318:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80031b:	8d 45 10             	lea    0x10(%ebp),%eax
  80031e:	83 c0 04             	add    $0x4,%eax
  800321:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800324:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800329:	85 c0                	test   %eax,%eax
  80032b:	74 16                	je     800343 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80032d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800332:	83 ec 08             	sub    $0x8,%esp
  800335:	50                   	push   %eax
  800336:	68 84 36 80 00       	push   $0x803684
  80033b:	e8 89 02 00 00       	call   8005c9 <cprintf>
  800340:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800343:	a1 00 40 80 00       	mov    0x804000,%eax
  800348:	ff 75 0c             	pushl  0xc(%ebp)
  80034b:	ff 75 08             	pushl  0x8(%ebp)
  80034e:	50                   	push   %eax
  80034f:	68 89 36 80 00       	push   $0x803689
  800354:	e8 70 02 00 00       	call   8005c9 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80035c:	8b 45 10             	mov    0x10(%ebp),%eax
  80035f:	83 ec 08             	sub    $0x8,%esp
  800362:	ff 75 f4             	pushl  -0xc(%ebp)
  800365:	50                   	push   %eax
  800366:	e8 f3 01 00 00       	call   80055e <vcprintf>
  80036b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80036e:	83 ec 08             	sub    $0x8,%esp
  800371:	6a 00                	push   $0x0
  800373:	68 a5 36 80 00       	push   $0x8036a5
  800378:	e8 e1 01 00 00       	call   80055e <vcprintf>
  80037d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800380:	e8 82 ff ff ff       	call   800307 <exit>

	// should not return here
	while (1) ;
  800385:	eb fe                	jmp    800385 <_panic+0x70>

00800387 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800387:	55                   	push   %ebp
  800388:	89 e5                	mov    %esp,%ebp
  80038a:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80038d:	a1 20 40 80 00       	mov    0x804020,%eax
  800392:	8b 50 74             	mov    0x74(%eax),%edx
  800395:	8b 45 0c             	mov    0xc(%ebp),%eax
  800398:	39 c2                	cmp    %eax,%edx
  80039a:	74 14                	je     8003b0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80039c:	83 ec 04             	sub    $0x4,%esp
  80039f:	68 a8 36 80 00       	push   $0x8036a8
  8003a4:	6a 26                	push   $0x26
  8003a6:	68 f4 36 80 00       	push   $0x8036f4
  8003ab:	e8 65 ff ff ff       	call   800315 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003b0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003b7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003be:	e9 c2 00 00 00       	jmp    800485 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003c6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d0:	01 d0                	add    %edx,%eax
  8003d2:	8b 00                	mov    (%eax),%eax
  8003d4:	85 c0                	test   %eax,%eax
  8003d6:	75 08                	jne    8003e0 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003d8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003db:	e9 a2 00 00 00       	jmp    800482 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003e0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003e7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ee:	eb 69                	jmp    800459 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003f0:	a1 20 40 80 00       	mov    0x804020,%eax
  8003f5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003fb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003fe:	89 d0                	mov    %edx,%eax
  800400:	01 c0                	add    %eax,%eax
  800402:	01 d0                	add    %edx,%eax
  800404:	c1 e0 03             	shl    $0x3,%eax
  800407:	01 c8                	add    %ecx,%eax
  800409:	8a 40 04             	mov    0x4(%eax),%al
  80040c:	84 c0                	test   %al,%al
  80040e:	75 46                	jne    800456 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80041b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	01 c0                	add    %eax,%eax
  800422:	01 d0                	add    %edx,%eax
  800424:	c1 e0 03             	shl    $0x3,%eax
  800427:	01 c8                	add    %ecx,%eax
  800429:	8b 00                	mov    (%eax),%eax
  80042b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80042e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800431:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800436:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80043b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800442:	8b 45 08             	mov    0x8(%ebp),%eax
  800445:	01 c8                	add    %ecx,%eax
  800447:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800449:	39 c2                	cmp    %eax,%edx
  80044b:	75 09                	jne    800456 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80044d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800454:	eb 12                	jmp    800468 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800456:	ff 45 e8             	incl   -0x18(%ebp)
  800459:	a1 20 40 80 00       	mov    0x804020,%eax
  80045e:	8b 50 74             	mov    0x74(%eax),%edx
  800461:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800464:	39 c2                	cmp    %eax,%edx
  800466:	77 88                	ja     8003f0 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800468:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80046c:	75 14                	jne    800482 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80046e:	83 ec 04             	sub    $0x4,%esp
  800471:	68 00 37 80 00       	push   $0x803700
  800476:	6a 3a                	push   $0x3a
  800478:	68 f4 36 80 00       	push   $0x8036f4
  80047d:	e8 93 fe ff ff       	call   800315 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800482:	ff 45 f0             	incl   -0x10(%ebp)
  800485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800488:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80048b:	0f 8c 32 ff ff ff    	jl     8003c3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800491:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800498:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80049f:	eb 26                	jmp    8004c7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004a1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004ac:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004af:	89 d0                	mov    %edx,%eax
  8004b1:	01 c0                	add    %eax,%eax
  8004b3:	01 d0                	add    %edx,%eax
  8004b5:	c1 e0 03             	shl    $0x3,%eax
  8004b8:	01 c8                	add    %ecx,%eax
  8004ba:	8a 40 04             	mov    0x4(%eax),%al
  8004bd:	3c 01                	cmp    $0x1,%al
  8004bf:	75 03                	jne    8004c4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004c1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004c4:	ff 45 e0             	incl   -0x20(%ebp)
  8004c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8004cc:	8b 50 74             	mov    0x74(%eax),%edx
  8004cf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004d2:	39 c2                	cmp    %eax,%edx
  8004d4:	77 cb                	ja     8004a1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004d9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 54 37 80 00       	push   $0x803754
  8004e6:	6a 44                	push   $0x44
  8004e8:	68 f4 36 80 00       	push   $0x8036f4
  8004ed:	e8 23 fe ff ff       	call   800315 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004f2:	90                   	nop
  8004f3:	c9                   	leave  
  8004f4:	c3                   	ret    

008004f5 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004f5:	55                   	push   %ebp
  8004f6:	89 e5                	mov    %esp,%ebp
  8004f8:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004fe:	8b 00                	mov    (%eax),%eax
  800500:	8d 48 01             	lea    0x1(%eax),%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	89 0a                	mov    %ecx,(%edx)
  800508:	8b 55 08             	mov    0x8(%ebp),%edx
  80050b:	88 d1                	mov    %dl,%cl
  80050d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800510:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800514:	8b 45 0c             	mov    0xc(%ebp),%eax
  800517:	8b 00                	mov    (%eax),%eax
  800519:	3d ff 00 00 00       	cmp    $0xff,%eax
  80051e:	75 2c                	jne    80054c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800520:	a0 24 40 80 00       	mov    0x804024,%al
  800525:	0f b6 c0             	movzbl %al,%eax
  800528:	8b 55 0c             	mov    0xc(%ebp),%edx
  80052b:	8b 12                	mov    (%edx),%edx
  80052d:	89 d1                	mov    %edx,%ecx
  80052f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800532:	83 c2 08             	add    $0x8,%edx
  800535:	83 ec 04             	sub    $0x4,%esp
  800538:	50                   	push   %eax
  800539:	51                   	push   %ecx
  80053a:	52                   	push   %edx
  80053b:	e8 05 14 00 00       	call   801945 <sys_cputs>
  800540:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800543:	8b 45 0c             	mov    0xc(%ebp),%eax
  800546:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80054c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80054f:	8b 40 04             	mov    0x4(%eax),%eax
  800552:	8d 50 01             	lea    0x1(%eax),%edx
  800555:	8b 45 0c             	mov    0xc(%ebp),%eax
  800558:	89 50 04             	mov    %edx,0x4(%eax)
}
  80055b:	90                   	nop
  80055c:	c9                   	leave  
  80055d:	c3                   	ret    

0080055e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80055e:	55                   	push   %ebp
  80055f:	89 e5                	mov    %esp,%ebp
  800561:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800567:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80056e:	00 00 00 
	b.cnt = 0;
  800571:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800578:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80057b:	ff 75 0c             	pushl  0xc(%ebp)
  80057e:	ff 75 08             	pushl  0x8(%ebp)
  800581:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800587:	50                   	push   %eax
  800588:	68 f5 04 80 00       	push   $0x8004f5
  80058d:	e8 11 02 00 00       	call   8007a3 <vprintfmt>
  800592:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800595:	a0 24 40 80 00       	mov    0x804024,%al
  80059a:	0f b6 c0             	movzbl %al,%eax
  80059d:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005a3:	83 ec 04             	sub    $0x4,%esp
  8005a6:	50                   	push   %eax
  8005a7:	52                   	push   %edx
  8005a8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ae:	83 c0 08             	add    $0x8,%eax
  8005b1:	50                   	push   %eax
  8005b2:	e8 8e 13 00 00       	call   801945 <sys_cputs>
  8005b7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005ba:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005c1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005c7:	c9                   	leave  
  8005c8:	c3                   	ret    

008005c9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
  8005cc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005cf:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005d6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005df:	83 ec 08             	sub    $0x8,%esp
  8005e2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e5:	50                   	push   %eax
  8005e6:	e8 73 ff ff ff       	call   80055e <vcprintf>
  8005eb:	83 c4 10             	add    $0x10,%esp
  8005ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f4:	c9                   	leave  
  8005f5:	c3                   	ret    

008005f6 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005f6:	55                   	push   %ebp
  8005f7:	89 e5                	mov    %esp,%ebp
  8005f9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005fc:	e8 f2 14 00 00       	call   801af3 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800601:	8d 45 0c             	lea    0xc(%ebp),%eax
  800604:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800607:	8b 45 08             	mov    0x8(%ebp),%eax
  80060a:	83 ec 08             	sub    $0x8,%esp
  80060d:	ff 75 f4             	pushl  -0xc(%ebp)
  800610:	50                   	push   %eax
  800611:	e8 48 ff ff ff       	call   80055e <vcprintf>
  800616:	83 c4 10             	add    $0x10,%esp
  800619:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80061c:	e8 ec 14 00 00       	call   801b0d <sys_enable_interrupt>
	return cnt;
  800621:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800624:	c9                   	leave  
  800625:	c3                   	ret    

00800626 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800626:	55                   	push   %ebp
  800627:	89 e5                	mov    %esp,%ebp
  800629:	53                   	push   %ebx
  80062a:	83 ec 14             	sub    $0x14,%esp
  80062d:	8b 45 10             	mov    0x10(%ebp),%eax
  800630:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800633:	8b 45 14             	mov    0x14(%ebp),%eax
  800636:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800639:	8b 45 18             	mov    0x18(%ebp),%eax
  80063c:	ba 00 00 00 00       	mov    $0x0,%edx
  800641:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800644:	77 55                	ja     80069b <printnum+0x75>
  800646:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800649:	72 05                	jb     800650 <printnum+0x2a>
  80064b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80064e:	77 4b                	ja     80069b <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800650:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800653:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800656:	8b 45 18             	mov    0x18(%ebp),%eax
  800659:	ba 00 00 00 00       	mov    $0x0,%edx
  80065e:	52                   	push   %edx
  80065f:	50                   	push   %eax
  800660:	ff 75 f4             	pushl  -0xc(%ebp)
  800663:	ff 75 f0             	pushl  -0x10(%ebp)
  800666:	e8 65 2a 00 00       	call   8030d0 <__udivdi3>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	83 ec 04             	sub    $0x4,%esp
  800671:	ff 75 20             	pushl  0x20(%ebp)
  800674:	53                   	push   %ebx
  800675:	ff 75 18             	pushl  0x18(%ebp)
  800678:	52                   	push   %edx
  800679:	50                   	push   %eax
  80067a:	ff 75 0c             	pushl  0xc(%ebp)
  80067d:	ff 75 08             	pushl  0x8(%ebp)
  800680:	e8 a1 ff ff ff       	call   800626 <printnum>
  800685:	83 c4 20             	add    $0x20,%esp
  800688:	eb 1a                	jmp    8006a4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80068a:	83 ec 08             	sub    $0x8,%esp
  80068d:	ff 75 0c             	pushl  0xc(%ebp)
  800690:	ff 75 20             	pushl  0x20(%ebp)
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	ff d0                	call   *%eax
  800698:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80069b:	ff 4d 1c             	decl   0x1c(%ebp)
  80069e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006a2:	7f e6                	jg     80068a <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006a4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006a7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006b2:	53                   	push   %ebx
  8006b3:	51                   	push   %ecx
  8006b4:	52                   	push   %edx
  8006b5:	50                   	push   %eax
  8006b6:	e8 25 2b 00 00       	call   8031e0 <__umoddi3>
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	05 b4 39 80 00       	add    $0x8039b4,%eax
  8006c3:	8a 00                	mov    (%eax),%al
  8006c5:	0f be c0             	movsbl %al,%eax
  8006c8:	83 ec 08             	sub    $0x8,%esp
  8006cb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ce:	50                   	push   %eax
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	ff d0                	call   *%eax
  8006d4:	83 c4 10             	add    $0x10,%esp
}
  8006d7:	90                   	nop
  8006d8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006db:	c9                   	leave  
  8006dc:	c3                   	ret    

008006dd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006dd:	55                   	push   %ebp
  8006de:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e0:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006e4:	7e 1c                	jle    800702 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	8d 50 08             	lea    0x8(%eax),%edx
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	89 10                	mov    %edx,(%eax)
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	83 e8 08             	sub    $0x8,%eax
  8006fb:	8b 50 04             	mov    0x4(%eax),%edx
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	eb 40                	jmp    800742 <getuint+0x65>
	else if (lflag)
  800702:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800706:	74 1e                	je     800726 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800708:	8b 45 08             	mov    0x8(%ebp),%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	8d 50 04             	lea    0x4(%eax),%edx
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	89 10                	mov    %edx,(%eax)
  800715:	8b 45 08             	mov    0x8(%ebp),%eax
  800718:	8b 00                	mov    (%eax),%eax
  80071a:	83 e8 04             	sub    $0x4,%eax
  80071d:	8b 00                	mov    (%eax),%eax
  80071f:	ba 00 00 00 00       	mov    $0x0,%edx
  800724:	eb 1c                	jmp    800742 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	8d 50 04             	lea    0x4(%eax),%edx
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	89 10                	mov    %edx,(%eax)
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	8b 00                	mov    (%eax),%eax
  800738:	83 e8 04             	sub    $0x4,%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800747:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80074b:	7e 1c                	jle    800769 <getint+0x25>
		return va_arg(*ap, long long);
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	8b 00                	mov    (%eax),%eax
  800752:	8d 50 08             	lea    0x8(%eax),%edx
  800755:	8b 45 08             	mov    0x8(%ebp),%eax
  800758:	89 10                	mov    %edx,(%eax)
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	8b 00                	mov    (%eax),%eax
  80075f:	83 e8 08             	sub    $0x8,%eax
  800762:	8b 50 04             	mov    0x4(%eax),%edx
  800765:	8b 00                	mov    (%eax),%eax
  800767:	eb 38                	jmp    8007a1 <getint+0x5d>
	else if (lflag)
  800769:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80076d:	74 1a                	je     800789 <getint+0x45>
		return va_arg(*ap, long);
  80076f:	8b 45 08             	mov    0x8(%ebp),%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	8d 50 04             	lea    0x4(%eax),%edx
  800777:	8b 45 08             	mov    0x8(%ebp),%eax
  80077a:	89 10                	mov    %edx,(%eax)
  80077c:	8b 45 08             	mov    0x8(%ebp),%eax
  80077f:	8b 00                	mov    (%eax),%eax
  800781:	83 e8 04             	sub    $0x4,%eax
  800784:	8b 00                	mov    (%eax),%eax
  800786:	99                   	cltd   
  800787:	eb 18                	jmp    8007a1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800789:	8b 45 08             	mov    0x8(%ebp),%eax
  80078c:	8b 00                	mov    (%eax),%eax
  80078e:	8d 50 04             	lea    0x4(%eax),%edx
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	89 10                	mov    %edx,(%eax)
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	8b 00                	mov    (%eax),%eax
  80079b:	83 e8 04             	sub    $0x4,%eax
  80079e:	8b 00                	mov    (%eax),%eax
  8007a0:	99                   	cltd   
}
  8007a1:	5d                   	pop    %ebp
  8007a2:	c3                   	ret    

008007a3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007a3:	55                   	push   %ebp
  8007a4:	89 e5                	mov    %esp,%ebp
  8007a6:	56                   	push   %esi
  8007a7:	53                   	push   %ebx
  8007a8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007ab:	eb 17                	jmp    8007c4 <vprintfmt+0x21>
			if (ch == '\0')
  8007ad:	85 db                	test   %ebx,%ebx
  8007af:	0f 84 af 03 00 00    	je     800b64 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007b5:	83 ec 08             	sub    $0x8,%esp
  8007b8:	ff 75 0c             	pushl  0xc(%ebp)
  8007bb:	53                   	push   %ebx
  8007bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bf:	ff d0                	call   *%eax
  8007c1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007c4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007c7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ca:	89 55 10             	mov    %edx,0x10(%ebp)
  8007cd:	8a 00                	mov    (%eax),%al
  8007cf:	0f b6 d8             	movzbl %al,%ebx
  8007d2:	83 fb 25             	cmp    $0x25,%ebx
  8007d5:	75 d6                	jne    8007ad <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007d7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007db:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007e2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007e9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007f0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fa:	8d 50 01             	lea    0x1(%eax),%edx
  8007fd:	89 55 10             	mov    %edx,0x10(%ebp)
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f b6 d8             	movzbl %al,%ebx
  800805:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800808:	83 f8 55             	cmp    $0x55,%eax
  80080b:	0f 87 2b 03 00 00    	ja     800b3c <vprintfmt+0x399>
  800811:	8b 04 85 d8 39 80 00 	mov    0x8039d8(,%eax,4),%eax
  800818:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80081a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80081e:	eb d7                	jmp    8007f7 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800820:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800824:	eb d1                	jmp    8007f7 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800826:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80082d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800830:	89 d0                	mov    %edx,%eax
  800832:	c1 e0 02             	shl    $0x2,%eax
  800835:	01 d0                	add    %edx,%eax
  800837:	01 c0                	add    %eax,%eax
  800839:	01 d8                	add    %ebx,%eax
  80083b:	83 e8 30             	sub    $0x30,%eax
  80083e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800841:	8b 45 10             	mov    0x10(%ebp),%eax
  800844:	8a 00                	mov    (%eax),%al
  800846:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800849:	83 fb 2f             	cmp    $0x2f,%ebx
  80084c:	7e 3e                	jle    80088c <vprintfmt+0xe9>
  80084e:	83 fb 39             	cmp    $0x39,%ebx
  800851:	7f 39                	jg     80088c <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800853:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800856:	eb d5                	jmp    80082d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800858:	8b 45 14             	mov    0x14(%ebp),%eax
  80085b:	83 c0 04             	add    $0x4,%eax
  80085e:	89 45 14             	mov    %eax,0x14(%ebp)
  800861:	8b 45 14             	mov    0x14(%ebp),%eax
  800864:	83 e8 04             	sub    $0x4,%eax
  800867:	8b 00                	mov    (%eax),%eax
  800869:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80086c:	eb 1f                	jmp    80088d <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80086e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800872:	79 83                	jns    8007f7 <vprintfmt+0x54>
				width = 0;
  800874:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80087b:	e9 77 ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800880:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800887:	e9 6b ff ff ff       	jmp    8007f7 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80088c:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80088d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800891:	0f 89 60 ff ff ff    	jns    8007f7 <vprintfmt+0x54>
				width = precision, precision = -1;
  800897:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80089d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008a4:	e9 4e ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008a9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008ac:	e9 46 ff ff ff       	jmp    8007f7 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008b1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b4:	83 c0 04             	add    $0x4,%eax
  8008b7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8008bd:	83 e8 04             	sub    $0x4,%eax
  8008c0:	8b 00                	mov    (%eax),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	ff 75 0c             	pushl  0xc(%ebp)
  8008c8:	50                   	push   %eax
  8008c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cc:	ff d0                	call   *%eax
  8008ce:	83 c4 10             	add    $0x10,%esp
			break;
  8008d1:	e9 89 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d9:	83 c0 04             	add    $0x4,%eax
  8008dc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008df:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e2:	83 e8 04             	sub    $0x4,%eax
  8008e5:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008e7:	85 db                	test   %ebx,%ebx
  8008e9:	79 02                	jns    8008ed <vprintfmt+0x14a>
				err = -err;
  8008eb:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008ed:	83 fb 64             	cmp    $0x64,%ebx
  8008f0:	7f 0b                	jg     8008fd <vprintfmt+0x15a>
  8008f2:	8b 34 9d 20 38 80 00 	mov    0x803820(,%ebx,4),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 19                	jne    800916 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008fd:	53                   	push   %ebx
  8008fe:	68 c5 39 80 00       	push   $0x8039c5
  800903:	ff 75 0c             	pushl  0xc(%ebp)
  800906:	ff 75 08             	pushl  0x8(%ebp)
  800909:	e8 5e 02 00 00       	call   800b6c <printfmt>
  80090e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800911:	e9 49 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800916:	56                   	push   %esi
  800917:	68 ce 39 80 00       	push   $0x8039ce
  80091c:	ff 75 0c             	pushl  0xc(%ebp)
  80091f:	ff 75 08             	pushl  0x8(%ebp)
  800922:	e8 45 02 00 00       	call   800b6c <printfmt>
  800927:	83 c4 10             	add    $0x10,%esp
			break;
  80092a:	e9 30 02 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80092f:	8b 45 14             	mov    0x14(%ebp),%eax
  800932:	83 c0 04             	add    $0x4,%eax
  800935:	89 45 14             	mov    %eax,0x14(%ebp)
  800938:	8b 45 14             	mov    0x14(%ebp),%eax
  80093b:	83 e8 04             	sub    $0x4,%eax
  80093e:	8b 30                	mov    (%eax),%esi
  800940:	85 f6                	test   %esi,%esi
  800942:	75 05                	jne    800949 <vprintfmt+0x1a6>
				p = "(null)";
  800944:	be d1 39 80 00       	mov    $0x8039d1,%esi
			if (width > 0 && padc != '-')
  800949:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094d:	7e 6d                	jle    8009bc <vprintfmt+0x219>
  80094f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800953:	74 67                	je     8009bc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800955:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800958:	83 ec 08             	sub    $0x8,%esp
  80095b:	50                   	push   %eax
  80095c:	56                   	push   %esi
  80095d:	e8 0c 03 00 00       	call   800c6e <strnlen>
  800962:	83 c4 10             	add    $0x10,%esp
  800965:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800968:	eb 16                	jmp    800980 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80096a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80096e:	83 ec 08             	sub    $0x8,%esp
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	50                   	push   %eax
  800975:	8b 45 08             	mov    0x8(%ebp),%eax
  800978:	ff d0                	call   *%eax
  80097a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80097d:	ff 4d e4             	decl   -0x1c(%ebp)
  800980:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800984:	7f e4                	jg     80096a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800986:	eb 34                	jmp    8009bc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800988:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80098c:	74 1c                	je     8009aa <vprintfmt+0x207>
  80098e:	83 fb 1f             	cmp    $0x1f,%ebx
  800991:	7e 05                	jle    800998 <vprintfmt+0x1f5>
  800993:	83 fb 7e             	cmp    $0x7e,%ebx
  800996:	7e 12                	jle    8009aa <vprintfmt+0x207>
					putch('?', putdat);
  800998:	83 ec 08             	sub    $0x8,%esp
  80099b:	ff 75 0c             	pushl  0xc(%ebp)
  80099e:	6a 3f                	push   $0x3f
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	ff d0                	call   *%eax
  8009a5:	83 c4 10             	add    $0x10,%esp
  8009a8:	eb 0f                	jmp    8009b9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009aa:	83 ec 08             	sub    $0x8,%esp
  8009ad:	ff 75 0c             	pushl  0xc(%ebp)
  8009b0:	53                   	push   %ebx
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009b9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009bc:	89 f0                	mov    %esi,%eax
  8009be:	8d 70 01             	lea    0x1(%eax),%esi
  8009c1:	8a 00                	mov    (%eax),%al
  8009c3:	0f be d8             	movsbl %al,%ebx
  8009c6:	85 db                	test   %ebx,%ebx
  8009c8:	74 24                	je     8009ee <vprintfmt+0x24b>
  8009ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ce:	78 b8                	js     800988 <vprintfmt+0x1e5>
  8009d0:	ff 4d e0             	decl   -0x20(%ebp)
  8009d3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009d7:	79 af                	jns    800988 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009d9:	eb 13                	jmp    8009ee <vprintfmt+0x24b>
				putch(' ', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 20                	push   $0x20
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009eb:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ee:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009f2:	7f e7                	jg     8009db <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009f4:	e9 66 01 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ff:	8d 45 14             	lea    0x14(%ebp),%eax
  800a02:	50                   	push   %eax
  800a03:	e8 3c fd ff ff       	call   800744 <getint>
  800a08:	83 c4 10             	add    $0x10,%esp
  800a0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a14:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a17:	85 d2                	test   %edx,%edx
  800a19:	79 23                	jns    800a3e <vprintfmt+0x29b>
				putch('-', putdat);
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 0c             	pushl  0xc(%ebp)
  800a21:	6a 2d                	push   $0x2d
  800a23:	8b 45 08             	mov    0x8(%ebp),%eax
  800a26:	ff d0                	call   *%eax
  800a28:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a2e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a31:	f7 d8                	neg    %eax
  800a33:	83 d2 00             	adc    $0x0,%edx
  800a36:	f7 da                	neg    %edx
  800a38:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a3e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a45:	e9 bc 00 00 00       	jmp    800b06 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a50:	8d 45 14             	lea    0x14(%ebp),%eax
  800a53:	50                   	push   %eax
  800a54:	e8 84 fc ff ff       	call   8006dd <getuint>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a62:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a69:	e9 98 00 00 00       	jmp    800b06 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a6e:	83 ec 08             	sub    $0x8,%esp
  800a71:	ff 75 0c             	pushl  0xc(%ebp)
  800a74:	6a 58                	push   $0x58
  800a76:	8b 45 08             	mov    0x8(%ebp),%eax
  800a79:	ff d0                	call   *%eax
  800a7b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	6a 58                	push   $0x58
  800a86:	8b 45 08             	mov    0x8(%ebp),%eax
  800a89:	ff d0                	call   *%eax
  800a8b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			break;
  800a9e:	e9 bc 00 00 00       	jmp    800b5f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	6a 30                	push   $0x30
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ab3:	83 ec 08             	sub    $0x8,%esp
  800ab6:	ff 75 0c             	pushl  0xc(%ebp)
  800ab9:	6a 78                	push   $0x78
  800abb:	8b 45 08             	mov    0x8(%ebp),%eax
  800abe:	ff d0                	call   *%eax
  800ac0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac6:	83 c0 04             	add    $0x4,%eax
  800ac9:	89 45 14             	mov    %eax,0x14(%ebp)
  800acc:	8b 45 14             	mov    0x14(%ebp),%eax
  800acf:	83 e8 04             	sub    $0x4,%eax
  800ad2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ade:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ae5:	eb 1f                	jmp    800b06 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 e8             	pushl  -0x18(%ebp)
  800aed:	8d 45 14             	lea    0x14(%ebp),%eax
  800af0:	50                   	push   %eax
  800af1:	e8 e7 fb ff ff       	call   8006dd <getuint>
  800af6:	83 c4 10             	add    $0x10,%esp
  800af9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800afc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aff:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b06:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b0a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b0d:	83 ec 04             	sub    $0x4,%esp
  800b10:	52                   	push   %edx
  800b11:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b14:	50                   	push   %eax
  800b15:	ff 75 f4             	pushl  -0xc(%ebp)
  800b18:	ff 75 f0             	pushl  -0x10(%ebp)
  800b1b:	ff 75 0c             	pushl  0xc(%ebp)
  800b1e:	ff 75 08             	pushl  0x8(%ebp)
  800b21:	e8 00 fb ff ff       	call   800626 <printnum>
  800b26:	83 c4 20             	add    $0x20,%esp
			break;
  800b29:	eb 34                	jmp    800b5f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	53                   	push   %ebx
  800b32:	8b 45 08             	mov    0x8(%ebp),%eax
  800b35:	ff d0                	call   *%eax
  800b37:	83 c4 10             	add    $0x10,%esp
			break;
  800b3a:	eb 23                	jmp    800b5f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	6a 25                	push   $0x25
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	ff d0                	call   *%eax
  800b49:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b4c:	ff 4d 10             	decl   0x10(%ebp)
  800b4f:	eb 03                	jmp    800b54 <vprintfmt+0x3b1>
  800b51:	ff 4d 10             	decl   0x10(%ebp)
  800b54:	8b 45 10             	mov    0x10(%ebp),%eax
  800b57:	48                   	dec    %eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	3c 25                	cmp    $0x25,%al
  800b5c:	75 f3                	jne    800b51 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b5e:	90                   	nop
		}
	}
  800b5f:	e9 47 fc ff ff       	jmp    8007ab <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b64:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b65:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b68:	5b                   	pop    %ebx
  800b69:	5e                   	pop    %esi
  800b6a:	5d                   	pop    %ebp
  800b6b:	c3                   	ret    

00800b6c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b6c:	55                   	push   %ebp
  800b6d:	89 e5                	mov    %esp,%ebp
  800b6f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b72:	8d 45 10             	lea    0x10(%ebp),%eax
  800b75:	83 c0 04             	add    $0x4,%eax
  800b78:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b7e:	ff 75 f4             	pushl  -0xc(%ebp)
  800b81:	50                   	push   %eax
  800b82:	ff 75 0c             	pushl  0xc(%ebp)
  800b85:	ff 75 08             	pushl  0x8(%ebp)
  800b88:	e8 16 fc ff ff       	call   8007a3 <vprintfmt>
  800b8d:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b90:	90                   	nop
  800b91:	c9                   	leave  
  800b92:	c3                   	ret    

00800b93 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b93:	55                   	push   %ebp
  800b94:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	8b 40 08             	mov    0x8(%eax),%eax
  800b9c:	8d 50 01             	lea    0x1(%eax),%edx
  800b9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba8:	8b 10                	mov    (%eax),%edx
  800baa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bad:	8b 40 04             	mov    0x4(%eax),%eax
  800bb0:	39 c2                	cmp    %eax,%edx
  800bb2:	73 12                	jae    800bc6 <sprintputch+0x33>
		*b->buf++ = ch;
  800bb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb7:	8b 00                	mov    (%eax),%eax
  800bb9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	89 0a                	mov    %ecx,(%edx)
  800bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  800bc4:	88 10                	mov    %dl,(%eax)
}
  800bc6:	90                   	nop
  800bc7:	5d                   	pop    %ebp
  800bc8:	c3                   	ret    

00800bc9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bc9:	55                   	push   %ebp
  800bca:	89 e5                	mov    %esp,%ebp
  800bcc:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bd5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	01 d0                	add    %edx,%eax
  800be0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bee:	74 06                	je     800bf6 <vsnprintf+0x2d>
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	7f 07                	jg     800bfd <vsnprintf+0x34>
		return -E_INVAL;
  800bf6:	b8 03 00 00 00       	mov    $0x3,%eax
  800bfb:	eb 20                	jmp    800c1d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bfd:	ff 75 14             	pushl  0x14(%ebp)
  800c00:	ff 75 10             	pushl  0x10(%ebp)
  800c03:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c06:	50                   	push   %eax
  800c07:	68 93 0b 80 00       	push   $0x800b93
  800c0c:	e8 92 fb ff ff       	call   8007a3 <vprintfmt>
  800c11:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c17:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c25:	8d 45 10             	lea    0x10(%ebp),%eax
  800c28:	83 c0 04             	add    $0x4,%eax
  800c2b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c31:	ff 75 f4             	pushl  -0xc(%ebp)
  800c34:	50                   	push   %eax
  800c35:	ff 75 0c             	pushl  0xc(%ebp)
  800c38:	ff 75 08             	pushl  0x8(%ebp)
  800c3b:	e8 89 ff ff ff       	call   800bc9 <vsnprintf>
  800c40:	83 c4 10             	add    $0x10,%esp
  800c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c46:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c51:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c58:	eb 06                	jmp    800c60 <strlen+0x15>
		n++;
  800c5a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c5d:	ff 45 08             	incl   0x8(%ebp)
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 f1                	jne    800c5a <strlen+0xf>
		n++;
	return n;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7b:	eb 09                	jmp    800c86 <strnlen+0x18>
		n++;
  800c7d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c80:	ff 45 08             	incl   0x8(%ebp)
  800c83:	ff 4d 0c             	decl   0xc(%ebp)
  800c86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8a:	74 09                	je     800c95 <strnlen+0x27>
  800c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8f:	8a 00                	mov    (%eax),%al
  800c91:	84 c0                	test   %al,%al
  800c93:	75 e8                	jne    800c7d <strnlen+0xf>
		n++;
	return n;
  800c95:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800ca6:	90                   	nop
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	8d 50 01             	lea    0x1(%eax),%edx
  800cad:	89 55 08             	mov    %edx,0x8(%ebp)
  800cb0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cb6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cb9:	8a 12                	mov    (%edx),%dl
  800cbb:	88 10                	mov    %dl,(%eax)
  800cbd:	8a 00                	mov    (%eax),%al
  800cbf:	84 c0                	test   %al,%al
  800cc1:	75 e4                	jne    800ca7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cc3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc6:	c9                   	leave  
  800cc7:	c3                   	ret    

00800cc8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cc8:	55                   	push   %ebp
  800cc9:	89 e5                	mov    %esp,%ebp
  800ccb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cd4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cdb:	eb 1f                	jmp    800cfc <strncpy+0x34>
		*dst++ = *src;
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8d 50 01             	lea    0x1(%eax),%edx
  800ce3:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce9:	8a 12                	mov    (%edx),%dl
  800ceb:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	84 c0                	test   %al,%al
  800cf4:	74 03                	je     800cf9 <strncpy+0x31>
			src++;
  800cf6:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cf9:	ff 45 fc             	incl   -0x4(%ebp)
  800cfc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cff:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d02:	72 d9                	jb     800cdd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d04:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d07:	c9                   	leave  
  800d08:	c3                   	ret    

00800d09 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d09:	55                   	push   %ebp
  800d0a:	89 e5                	mov    %esp,%ebp
  800d0c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d15:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d19:	74 30                	je     800d4b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d1b:	eb 16                	jmp    800d33 <strlcpy+0x2a>
			*dst++ = *src++;
  800d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d20:	8d 50 01             	lea    0x1(%eax),%edx
  800d23:	89 55 08             	mov    %edx,0x8(%ebp)
  800d26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d29:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d2c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d2f:	8a 12                	mov    (%edx),%dl
  800d31:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d33:	ff 4d 10             	decl   0x10(%ebp)
  800d36:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d3a:	74 09                	je     800d45 <strlcpy+0x3c>
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	84 c0                	test   %al,%al
  800d43:	75 d8                	jne    800d1d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d45:	8b 45 08             	mov    0x8(%ebp),%eax
  800d48:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d51:	29 c2                	sub    %eax,%edx
  800d53:	89 d0                	mov    %edx,%eax
}
  800d55:	c9                   	leave  
  800d56:	c3                   	ret    

00800d57 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d57:	55                   	push   %ebp
  800d58:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d5a:	eb 06                	jmp    800d62 <strcmp+0xb>
		p++, q++;
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	8a 00                	mov    (%eax),%al
  800d67:	84 c0                	test   %al,%al
  800d69:	74 0e                	je     800d79 <strcmp+0x22>
  800d6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6e:	8a 10                	mov    (%eax),%dl
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	38 c2                	cmp    %al,%dl
  800d77:	74 e3                	je     800d5c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	8a 00                	mov    (%eax),%al
  800d7e:	0f b6 d0             	movzbl %al,%edx
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	0f b6 c0             	movzbl %al,%eax
  800d89:	29 c2                	sub    %eax,%edx
  800d8b:	89 d0                	mov    %edx,%eax
}
  800d8d:	5d                   	pop    %ebp
  800d8e:	c3                   	ret    

00800d8f <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d8f:	55                   	push   %ebp
  800d90:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d92:	eb 09                	jmp    800d9d <strncmp+0xe>
		n--, p++, q++;
  800d94:	ff 4d 10             	decl   0x10(%ebp)
  800d97:	ff 45 08             	incl   0x8(%ebp)
  800d9a:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da1:	74 17                	je     800dba <strncmp+0x2b>
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	74 0e                	je     800dba <strncmp+0x2b>
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	8a 10                	mov    (%eax),%dl
  800db1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db4:	8a 00                	mov    (%eax),%al
  800db6:	38 c2                	cmp    %al,%dl
  800db8:	74 da                	je     800d94 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dba:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dbe:	75 07                	jne    800dc7 <strncmp+0x38>
		return 0;
  800dc0:	b8 00 00 00 00       	mov    $0x0,%eax
  800dc5:	eb 14                	jmp    800ddb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f b6 d0             	movzbl %al,%edx
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f b6 c0             	movzbl %al,%eax
  800dd7:	29 c2                	sub    %eax,%edx
  800dd9:	89 d0                	mov    %edx,%eax
}
  800ddb:	5d                   	pop    %ebp
  800ddc:	c3                   	ret    

00800ddd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 04             	sub    $0x4,%esp
  800de3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de6:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800de9:	eb 12                	jmp    800dfd <strchr+0x20>
		if (*s == c)
  800deb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df3:	75 05                	jne    800dfa <strchr+0x1d>
			return (char *) s;
  800df5:	8b 45 08             	mov    0x8(%ebp),%eax
  800df8:	eb 11                	jmp    800e0b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dfa:	ff 45 08             	incl   0x8(%ebp)
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	84 c0                	test   %al,%al
  800e04:	75 e5                	jne    800deb <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e06:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 04             	sub    $0x4,%esp
  800e13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e16:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e19:	eb 0d                	jmp    800e28 <strfind+0x1b>
		if (*s == c)
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	8a 00                	mov    (%eax),%al
  800e20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e23:	74 0e                	je     800e33 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e25:	ff 45 08             	incl   0x8(%ebp)
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	84 c0                	test   %al,%al
  800e2f:	75 ea                	jne    800e1b <strfind+0xe>
  800e31:	eb 01                	jmp    800e34 <strfind+0x27>
		if (*s == c)
			break;
  800e33:	90                   	nop
	return (char *) s;
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e37:	c9                   	leave  
  800e38:	c3                   	ret    

00800e39 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e39:	55                   	push   %ebp
  800e3a:	89 e5                	mov    %esp,%ebp
  800e3c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e45:	8b 45 10             	mov    0x10(%ebp),%eax
  800e48:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e4b:	eb 0e                	jmp    800e5b <memset+0x22>
		*p++ = c;
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8d 50 01             	lea    0x1(%eax),%edx
  800e53:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e56:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e59:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e5b:	ff 4d f8             	decl   -0x8(%ebp)
  800e5e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e62:	79 e9                	jns    800e4d <memset+0x14>
		*p++ = c;

	return v;
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e67:	c9                   	leave  
  800e68:	c3                   	ret    

00800e69 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e69:	55                   	push   %ebp
  800e6a:	89 e5                	mov    %esp,%ebp
  800e6c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e72:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e7b:	eb 16                	jmp    800e93 <memcpy+0x2a>
		*d++ = *s++;
  800e7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e80:	8d 50 01             	lea    0x1(%eax),%edx
  800e83:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e86:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e89:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e8c:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e8f:	8a 12                	mov    (%edx),%dl
  800e91:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e93:	8b 45 10             	mov    0x10(%ebp),%eax
  800e96:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e99:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9c:	85 c0                	test   %eax,%eax
  800e9e:	75 dd                	jne    800e7d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ea0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ea3:	c9                   	leave  
  800ea4:	c3                   	ret    

00800ea5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ea5:	55                   	push   %ebp
  800ea6:	89 e5                	mov    %esp,%ebp
  800ea8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eab:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800eb7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eba:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ebd:	73 50                	jae    800f0f <memmove+0x6a>
  800ebf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eca:	76 43                	jbe    800f0f <memmove+0x6a>
		s += n;
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ed2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ed8:	eb 10                	jmp    800eea <memmove+0x45>
			*--d = *--s;
  800eda:	ff 4d f8             	decl   -0x8(%ebp)
  800edd:	ff 4d fc             	decl   -0x4(%ebp)
  800ee0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee3:	8a 10                	mov    (%eax),%dl
  800ee5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee8:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800eea:	8b 45 10             	mov    0x10(%ebp),%eax
  800eed:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ef0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef3:	85 c0                	test   %eax,%eax
  800ef5:	75 e3                	jne    800eda <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ef7:	eb 23                	jmp    800f1c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ef9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efc:	8d 50 01             	lea    0x1(%eax),%edx
  800eff:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f02:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f05:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f08:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0b:	8a 12                	mov    (%edx),%dl
  800f0d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f0f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f12:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f15:	89 55 10             	mov    %edx,0x10(%ebp)
  800f18:	85 c0                	test   %eax,%eax
  800f1a:	75 dd                	jne    800ef9 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1f:	c9                   	leave  
  800f20:	c3                   	ret    

00800f21 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f21:	55                   	push   %ebp
  800f22:	89 e5                	mov    %esp,%ebp
  800f24:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f30:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f33:	eb 2a                	jmp    800f5f <memcmp+0x3e>
		if (*s1 != *s2)
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	38 c2                	cmp    %al,%dl
  800f41:	74 16                	je     800f59 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f43:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	0f b6 d0             	movzbl %al,%edx
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	0f b6 c0             	movzbl %al,%eax
  800f53:	29 c2                	sub    %eax,%edx
  800f55:	89 d0                	mov    %edx,%eax
  800f57:	eb 18                	jmp    800f71 <memcmp+0x50>
		s1++, s2++;
  800f59:	ff 45 fc             	incl   -0x4(%ebp)
  800f5c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f5f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f62:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f65:	89 55 10             	mov    %edx,0x10(%ebp)
  800f68:	85 c0                	test   %eax,%eax
  800f6a:	75 c9                	jne    800f35 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f71:	c9                   	leave  
  800f72:	c3                   	ret    

00800f73 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f73:	55                   	push   %ebp
  800f74:	89 e5                	mov    %esp,%ebp
  800f76:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f79:	8b 55 08             	mov    0x8(%ebp),%edx
  800f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7f:	01 d0                	add    %edx,%eax
  800f81:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f84:	eb 15                	jmp    800f9b <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	0f b6 d0             	movzbl %al,%edx
  800f8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f91:	0f b6 c0             	movzbl %al,%eax
  800f94:	39 c2                	cmp    %eax,%edx
  800f96:	74 0d                	je     800fa5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fa1:	72 e3                	jb     800f86 <memfind+0x13>
  800fa3:	eb 01                	jmp    800fa6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fa5:	90                   	nop
	return (void *) s;
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fb1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fb8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fbf:	eb 03                	jmp    800fc4 <strtol+0x19>
		s++;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	3c 20                	cmp    $0x20,%al
  800fcb:	74 f4                	je     800fc1 <strtol+0x16>
  800fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd0:	8a 00                	mov    (%eax),%al
  800fd2:	3c 09                	cmp    $0x9,%al
  800fd4:	74 eb                	je     800fc1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd9:	8a 00                	mov    (%eax),%al
  800fdb:	3c 2b                	cmp    $0x2b,%al
  800fdd:	75 05                	jne    800fe4 <strtol+0x39>
		s++;
  800fdf:	ff 45 08             	incl   0x8(%ebp)
  800fe2:	eb 13                	jmp    800ff7 <strtol+0x4c>
	else if (*s == '-')
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 2d                	cmp    $0x2d,%al
  800feb:	75 0a                	jne    800ff7 <strtol+0x4c>
		s++, neg = 1;
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	74 06                	je     801003 <strtol+0x58>
  800ffd:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801001:	75 20                	jne    801023 <strtol+0x78>
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	3c 30                	cmp    $0x30,%al
  80100a:	75 17                	jne    801023 <strtol+0x78>
  80100c:	8b 45 08             	mov    0x8(%ebp),%eax
  80100f:	40                   	inc    %eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 78                	cmp    $0x78,%al
  801014:	75 0d                	jne    801023 <strtol+0x78>
		s += 2, base = 16;
  801016:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80101a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801021:	eb 28                	jmp    80104b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801023:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801027:	75 15                	jne    80103e <strtol+0x93>
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 30                	cmp    $0x30,%al
  801030:	75 0c                	jne    80103e <strtol+0x93>
		s++, base = 8;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80103c:	eb 0d                	jmp    80104b <strtol+0xa0>
	else if (base == 0)
  80103e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801042:	75 07                	jne    80104b <strtol+0xa0>
		base = 10;
  801044:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 2f                	cmp    $0x2f,%al
  801052:	7e 19                	jle    80106d <strtol+0xc2>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 39                	cmp    $0x39,%al
  80105b:	7f 10                	jg     80106d <strtol+0xc2>
			dig = *s - '0';
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f be c0             	movsbl %al,%eax
  801065:	83 e8 30             	sub    $0x30,%eax
  801068:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80106b:	eb 42                	jmp    8010af <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
  801070:	8a 00                	mov    (%eax),%al
  801072:	3c 60                	cmp    $0x60,%al
  801074:	7e 19                	jle    80108f <strtol+0xe4>
  801076:	8b 45 08             	mov    0x8(%ebp),%eax
  801079:	8a 00                	mov    (%eax),%al
  80107b:	3c 7a                	cmp    $0x7a,%al
  80107d:	7f 10                	jg     80108f <strtol+0xe4>
			dig = *s - 'a' + 10;
  80107f:	8b 45 08             	mov    0x8(%ebp),%eax
  801082:	8a 00                	mov    (%eax),%al
  801084:	0f be c0             	movsbl %al,%eax
  801087:	83 e8 57             	sub    $0x57,%eax
  80108a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108d:	eb 20                	jmp    8010af <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80108f:	8b 45 08             	mov    0x8(%ebp),%eax
  801092:	8a 00                	mov    (%eax),%al
  801094:	3c 40                	cmp    $0x40,%al
  801096:	7e 39                	jle    8010d1 <strtol+0x126>
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 5a                	cmp    $0x5a,%al
  80109f:	7f 30                	jg     8010d1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	0f be c0             	movsbl %al,%eax
  8010a9:	83 e8 37             	sub    $0x37,%eax
  8010ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010b2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010b5:	7d 19                	jge    8010d0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010b7:	ff 45 08             	incl   0x8(%ebp)
  8010ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010c1:	89 c2                	mov    %eax,%edx
  8010c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c6:	01 d0                	add    %edx,%eax
  8010c8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010cb:	e9 7b ff ff ff       	jmp    80104b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010d0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010d1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010d5:	74 08                	je     8010df <strtol+0x134>
		*endptr = (char *) s;
  8010d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010da:	8b 55 08             	mov    0x8(%ebp),%edx
  8010dd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010df:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010e3:	74 07                	je     8010ec <strtol+0x141>
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	f7 d8                	neg    %eax
  8010ea:	eb 03                	jmp    8010ef <strtol+0x144>
  8010ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ef:	c9                   	leave  
  8010f0:	c3                   	ret    

008010f1 <ltostr>:

void
ltostr(long value, char *str)
{
  8010f1:	55                   	push   %ebp
  8010f2:	89 e5                	mov    %esp,%ebp
  8010f4:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010fe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801105:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801109:	79 13                	jns    80111e <ltostr+0x2d>
	{
		neg = 1;
  80110b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801112:	8b 45 0c             	mov    0xc(%ebp),%eax
  801115:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801118:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80111b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80111e:	8b 45 08             	mov    0x8(%ebp),%eax
  801121:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801126:	99                   	cltd   
  801127:	f7 f9                	idiv   %ecx
  801129:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80112c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112f:	8d 50 01             	lea    0x1(%eax),%edx
  801132:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801135:	89 c2                	mov    %eax,%edx
  801137:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113a:	01 d0                	add    %edx,%eax
  80113c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80113f:	83 c2 30             	add    $0x30,%edx
  801142:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801144:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801147:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80114c:	f7 e9                	imul   %ecx
  80114e:	c1 fa 02             	sar    $0x2,%edx
  801151:	89 c8                	mov    %ecx,%eax
  801153:	c1 f8 1f             	sar    $0x1f,%eax
  801156:	29 c2                	sub    %eax,%edx
  801158:	89 d0                	mov    %edx,%eax
  80115a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80115d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801160:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801165:	f7 e9                	imul   %ecx
  801167:	c1 fa 02             	sar    $0x2,%edx
  80116a:	89 c8                	mov    %ecx,%eax
  80116c:	c1 f8 1f             	sar    $0x1f,%eax
  80116f:	29 c2                	sub    %eax,%edx
  801171:	89 d0                	mov    %edx,%eax
  801173:	c1 e0 02             	shl    $0x2,%eax
  801176:	01 d0                	add    %edx,%eax
  801178:	01 c0                	add    %eax,%eax
  80117a:	29 c1                	sub    %eax,%ecx
  80117c:	89 ca                	mov    %ecx,%edx
  80117e:	85 d2                	test   %edx,%edx
  801180:	75 9c                	jne    80111e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801182:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801189:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80118c:	48                   	dec    %eax
  80118d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801190:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801194:	74 3d                	je     8011d3 <ltostr+0xe2>
		start = 1 ;
  801196:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80119d:	eb 34                	jmp    8011d3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80119f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a5:	01 d0                	add    %edx,%eax
  8011a7:	8a 00                	mov    (%eax),%al
  8011a9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011ac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011af:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b2:	01 c2                	add    %eax,%edx
  8011b4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ba:	01 c8                	add    %ecx,%eax
  8011bc:	8a 00                	mov    (%eax),%al
  8011be:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011c0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c6:	01 c2                	add    %eax,%edx
  8011c8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011cb:	88 02                	mov    %al,(%edx)
		start++ ;
  8011cd:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011d0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d9:	7c c4                	jl     80119f <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011db:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011de:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
  8011ec:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ef:	ff 75 08             	pushl  0x8(%ebp)
  8011f2:	e8 54 fa ff ff       	call   800c4b <strlen>
  8011f7:	83 c4 04             	add    $0x4,%esp
  8011fa:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011fd:	ff 75 0c             	pushl  0xc(%ebp)
  801200:	e8 46 fa ff ff       	call   800c4b <strlen>
  801205:	83 c4 04             	add    $0x4,%esp
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80120b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801212:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801219:	eb 17                	jmp    801232 <strcconcat+0x49>
		final[s] = str1[s] ;
  80121b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121e:	8b 45 10             	mov    0x10(%ebp),%eax
  801221:	01 c2                	add    %eax,%edx
  801223:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	01 c8                	add    %ecx,%eax
  80122b:	8a 00                	mov    (%eax),%al
  80122d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80122f:	ff 45 fc             	incl   -0x4(%ebp)
  801232:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801235:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801238:	7c e1                	jl     80121b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80123a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801241:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801248:	eb 1f                	jmp    801269 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80124a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80124d:	8d 50 01             	lea    0x1(%eax),%edx
  801250:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801253:	89 c2                	mov    %eax,%edx
  801255:	8b 45 10             	mov    0x10(%ebp),%eax
  801258:	01 c2                	add    %eax,%edx
  80125a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	01 c8                	add    %ecx,%eax
  801262:	8a 00                	mov    (%eax),%al
  801264:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801266:	ff 45 f8             	incl   -0x8(%ebp)
  801269:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80126f:	7c d9                	jl     80124a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801271:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801274:	8b 45 10             	mov    0x10(%ebp),%eax
  801277:	01 d0                	add    %edx,%eax
  801279:	c6 00 00             	movb   $0x0,(%eax)
}
  80127c:	90                   	nop
  80127d:	c9                   	leave  
  80127e:	c3                   	ret    

0080127f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80127f:	55                   	push   %ebp
  801280:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80128b:	8b 45 14             	mov    0x14(%ebp),%eax
  80128e:	8b 00                	mov    (%eax),%eax
  801290:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801297:	8b 45 10             	mov    0x10(%ebp),%eax
  80129a:	01 d0                	add    %edx,%eax
  80129c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012a2:	eb 0c                	jmp    8012b0 <strsplit+0x31>
			*string++ = 0;
  8012a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a7:	8d 50 01             	lea    0x1(%eax),%edx
  8012aa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012ad:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	84 c0                	test   %al,%al
  8012b7:	74 18                	je     8012d1 <strsplit+0x52>
  8012b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bc:	8a 00                	mov    (%eax),%al
  8012be:	0f be c0             	movsbl %al,%eax
  8012c1:	50                   	push   %eax
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	e8 13 fb ff ff       	call   800ddd <strchr>
  8012ca:	83 c4 08             	add    $0x8,%esp
  8012cd:	85 c0                	test   %eax,%eax
  8012cf:	75 d3                	jne    8012a4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	74 5a                	je     801334 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012da:	8b 45 14             	mov    0x14(%ebp),%eax
  8012dd:	8b 00                	mov    (%eax),%eax
  8012df:	83 f8 0f             	cmp    $0xf,%eax
  8012e2:	75 07                	jne    8012eb <strsplit+0x6c>
		{
			return 0;
  8012e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8012e9:	eb 66                	jmp    801351 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	8d 48 01             	lea    0x1(%eax),%ecx
  8012f3:	8b 55 14             	mov    0x14(%ebp),%edx
  8012f6:	89 0a                	mov    %ecx,(%edx)
  8012f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801302:	01 c2                	add    %eax,%edx
  801304:	8b 45 08             	mov    0x8(%ebp),%eax
  801307:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801309:	eb 03                	jmp    80130e <strsplit+0x8f>
			string++;
  80130b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	84 c0                	test   %al,%al
  801315:	74 8b                	je     8012a2 <strsplit+0x23>
  801317:	8b 45 08             	mov    0x8(%ebp),%eax
  80131a:	8a 00                	mov    (%eax),%al
  80131c:	0f be c0             	movsbl %al,%eax
  80131f:	50                   	push   %eax
  801320:	ff 75 0c             	pushl  0xc(%ebp)
  801323:	e8 b5 fa ff ff       	call   800ddd <strchr>
  801328:	83 c4 08             	add    $0x8,%esp
  80132b:	85 c0                	test   %eax,%eax
  80132d:	74 dc                	je     80130b <strsplit+0x8c>
			string++;
	}
  80132f:	e9 6e ff ff ff       	jmp    8012a2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801334:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801335:	8b 45 14             	mov    0x14(%ebp),%eax
  801338:	8b 00                	mov    (%eax),%eax
  80133a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801341:	8b 45 10             	mov    0x10(%ebp),%eax
  801344:	01 d0                	add    %edx,%eax
  801346:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80134c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
  801356:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801359:	a1 04 40 80 00       	mov    0x804004,%eax
  80135e:	85 c0                	test   %eax,%eax
  801360:	74 1f                	je     801381 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801362:	e8 1d 00 00 00       	call   801384 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801367:	83 ec 0c             	sub    $0xc,%esp
  80136a:	68 30 3b 80 00       	push   $0x803b30
  80136f:	e8 55 f2 ff ff       	call   8005c9 <cprintf>
  801374:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801377:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80137e:	00 00 00 
	}
}
  801381:	90                   	nop
  801382:	c9                   	leave  
  801383:	c3                   	ret    

00801384 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801384:	55                   	push   %ebp
  801385:	89 e5                	mov    %esp,%ebp
  801387:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  80138a:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801391:	00 00 00 
  801394:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80139b:	00 00 00 
  80139e:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013a5:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8013a8:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013af:	00 00 00 
  8013b2:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013b9:	00 00 00 
  8013bc:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013c3:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  8013c6:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  8013cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013d0:	c1 e8 0c             	shr    $0xc,%eax
  8013d3:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  8013d8:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8013df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013e7:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013ec:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  8013f1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8013f8:	a1 20 41 80 00       	mov    0x804120,%eax
  8013fd:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801401:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801404:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80140b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80140e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801411:	01 d0                	add    %edx,%eax
  801413:	48                   	dec    %eax
  801414:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801417:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80141a:	ba 00 00 00 00       	mov    $0x0,%edx
  80141f:	f7 75 e4             	divl   -0x1c(%ebp)
  801422:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801425:	29 d0                	sub    %edx,%eax
  801427:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  80142a:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801431:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801434:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801439:	2d 00 10 00 00       	sub    $0x1000,%eax
  80143e:	83 ec 04             	sub    $0x4,%esp
  801441:	6a 07                	push   $0x7
  801443:	ff 75 e8             	pushl  -0x18(%ebp)
  801446:	50                   	push   %eax
  801447:	e8 3d 06 00 00       	call   801a89 <sys_allocate_chunk>
  80144c:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80144f:	a1 20 41 80 00       	mov    0x804120,%eax
  801454:	83 ec 0c             	sub    $0xc,%esp
  801457:	50                   	push   %eax
  801458:	e8 b2 0c 00 00       	call   80210f <initialize_MemBlocksList>
  80145d:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801460:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801465:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801468:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80146c:	0f 84 f3 00 00 00    	je     801565 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801472:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801476:	75 14                	jne    80148c <initialize_dyn_block_system+0x108>
  801478:	83 ec 04             	sub    $0x4,%esp
  80147b:	68 55 3b 80 00       	push   $0x803b55
  801480:	6a 36                	push   $0x36
  801482:	68 73 3b 80 00       	push   $0x803b73
  801487:	e8 89 ee ff ff       	call   800315 <_panic>
  80148c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80148f:	8b 00                	mov    (%eax),%eax
  801491:	85 c0                	test   %eax,%eax
  801493:	74 10                	je     8014a5 <initialize_dyn_block_system+0x121>
  801495:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801498:	8b 00                	mov    (%eax),%eax
  80149a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80149d:	8b 52 04             	mov    0x4(%edx),%edx
  8014a0:	89 50 04             	mov    %edx,0x4(%eax)
  8014a3:	eb 0b                	jmp    8014b0 <initialize_dyn_block_system+0x12c>
  8014a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014a8:	8b 40 04             	mov    0x4(%eax),%eax
  8014ab:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014b3:	8b 40 04             	mov    0x4(%eax),%eax
  8014b6:	85 c0                	test   %eax,%eax
  8014b8:	74 0f                	je     8014c9 <initialize_dyn_block_system+0x145>
  8014ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014bd:	8b 40 04             	mov    0x4(%eax),%eax
  8014c0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014c3:	8b 12                	mov    (%edx),%edx
  8014c5:	89 10                	mov    %edx,(%eax)
  8014c7:	eb 0a                	jmp    8014d3 <initialize_dyn_block_system+0x14f>
  8014c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014cc:	8b 00                	mov    (%eax),%eax
  8014ce:	a3 48 41 80 00       	mov    %eax,0x804148
  8014d3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014e6:	a1 54 41 80 00       	mov    0x804154,%eax
  8014eb:	48                   	dec    %eax
  8014ec:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  8014f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014f4:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8014fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014fe:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801505:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801509:	75 14                	jne    80151f <initialize_dyn_block_system+0x19b>
  80150b:	83 ec 04             	sub    $0x4,%esp
  80150e:	68 80 3b 80 00       	push   $0x803b80
  801513:	6a 3e                	push   $0x3e
  801515:	68 73 3b 80 00       	push   $0x803b73
  80151a:	e8 f6 ed ff ff       	call   800315 <_panic>
  80151f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801525:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801528:	89 10                	mov    %edx,(%eax)
  80152a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80152d:	8b 00                	mov    (%eax),%eax
  80152f:	85 c0                	test   %eax,%eax
  801531:	74 0d                	je     801540 <initialize_dyn_block_system+0x1bc>
  801533:	a1 38 41 80 00       	mov    0x804138,%eax
  801538:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80153b:	89 50 04             	mov    %edx,0x4(%eax)
  80153e:	eb 08                	jmp    801548 <initialize_dyn_block_system+0x1c4>
  801540:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801543:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801548:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80154b:	a3 38 41 80 00       	mov    %eax,0x804138
  801550:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801553:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80155a:	a1 44 41 80 00       	mov    0x804144,%eax
  80155f:	40                   	inc    %eax
  801560:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  801565:	90                   	nop
  801566:	c9                   	leave  
  801567:	c3                   	ret    

00801568 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801568:	55                   	push   %ebp
  801569:	89 e5                	mov    %esp,%ebp
  80156b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  80156e:	e8 e0 fd ff ff       	call   801353 <InitializeUHeap>
		if (size == 0) return NULL ;
  801573:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801577:	75 07                	jne    801580 <malloc+0x18>
  801579:	b8 00 00 00 00       	mov    $0x0,%eax
  80157e:	eb 7f                	jmp    8015ff <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801580:	e8 d2 08 00 00       	call   801e57 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801585:	85 c0                	test   %eax,%eax
  801587:	74 71                	je     8015fa <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801589:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801590:	8b 55 08             	mov    0x8(%ebp),%edx
  801593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801596:	01 d0                	add    %edx,%eax
  801598:	48                   	dec    %eax
  801599:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80159c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159f:	ba 00 00 00 00       	mov    $0x0,%edx
  8015a4:	f7 75 f4             	divl   -0xc(%ebp)
  8015a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015aa:	29 d0                	sub    %edx,%eax
  8015ac:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  8015af:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  8015b6:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8015bd:	76 07                	jbe    8015c6 <malloc+0x5e>
					return NULL ;
  8015bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8015c4:	eb 39                	jmp    8015ff <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  8015c6:	83 ec 0c             	sub    $0xc,%esp
  8015c9:	ff 75 08             	pushl  0x8(%ebp)
  8015cc:	e8 e6 0d 00 00       	call   8023b7 <alloc_block_FF>
  8015d1:	83 c4 10             	add    $0x10,%esp
  8015d4:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  8015d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015db:	74 16                	je     8015f3 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  8015dd:	83 ec 0c             	sub    $0xc,%esp
  8015e0:	ff 75 ec             	pushl  -0x14(%ebp)
  8015e3:	e8 37 0c 00 00       	call   80221f <insert_sorted_allocList>
  8015e8:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  8015eb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ee:	8b 40 08             	mov    0x8(%eax),%eax
  8015f1:	eb 0c                	jmp    8015ff <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8015f3:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f8:	eb 05                	jmp    8015ff <malloc+0x97>
				}
		}
	return 0;
  8015fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015ff:	c9                   	leave  
  801600:	c3                   	ret    

00801601 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801601:	55                   	push   %ebp
  801602:	89 e5                	mov    %esp,%ebp
  801604:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801607:	8b 45 08             	mov    0x8(%ebp),%eax
  80160a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  80160d:	83 ec 08             	sub    $0x8,%esp
  801610:	ff 75 f4             	pushl  -0xc(%ebp)
  801613:	68 40 40 80 00       	push   $0x804040
  801618:	e8 cf 0b 00 00       	call   8021ec <find_block>
  80161d:	83 c4 10             	add    $0x10,%esp
  801620:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801626:	8b 40 0c             	mov    0xc(%eax),%eax
  801629:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  80162c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162f:	8b 40 08             	mov    0x8(%eax),%eax
  801632:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801635:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801639:	0f 84 a1 00 00 00    	je     8016e0 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  80163f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801643:	75 17                	jne    80165c <free+0x5b>
  801645:	83 ec 04             	sub    $0x4,%esp
  801648:	68 55 3b 80 00       	push   $0x803b55
  80164d:	68 80 00 00 00       	push   $0x80
  801652:	68 73 3b 80 00       	push   $0x803b73
  801657:	e8 b9 ec ff ff       	call   800315 <_panic>
  80165c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165f:	8b 00                	mov    (%eax),%eax
  801661:	85 c0                	test   %eax,%eax
  801663:	74 10                	je     801675 <free+0x74>
  801665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801668:	8b 00                	mov    (%eax),%eax
  80166a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80166d:	8b 52 04             	mov    0x4(%edx),%edx
  801670:	89 50 04             	mov    %edx,0x4(%eax)
  801673:	eb 0b                	jmp    801680 <free+0x7f>
  801675:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801678:	8b 40 04             	mov    0x4(%eax),%eax
  80167b:	a3 44 40 80 00       	mov    %eax,0x804044
  801680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801683:	8b 40 04             	mov    0x4(%eax),%eax
  801686:	85 c0                	test   %eax,%eax
  801688:	74 0f                	je     801699 <free+0x98>
  80168a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80168d:	8b 40 04             	mov    0x4(%eax),%eax
  801690:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801693:	8b 12                	mov    (%edx),%edx
  801695:	89 10                	mov    %edx,(%eax)
  801697:	eb 0a                	jmp    8016a3 <free+0xa2>
  801699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169c:	8b 00                	mov    (%eax),%eax
  80169e:	a3 40 40 80 00       	mov    %eax,0x804040
  8016a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016b6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016bb:	48                   	dec    %eax
  8016bc:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  8016c1:	83 ec 0c             	sub    $0xc,%esp
  8016c4:	ff 75 f0             	pushl  -0x10(%ebp)
  8016c7:	e8 29 12 00 00       	call   8028f5 <insert_sorted_with_merge_freeList>
  8016cc:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  8016cf:	83 ec 08             	sub    $0x8,%esp
  8016d2:	ff 75 ec             	pushl  -0x14(%ebp)
  8016d5:	ff 75 e8             	pushl  -0x18(%ebp)
  8016d8:	e8 74 03 00 00       	call   801a51 <sys_free_user_mem>
  8016dd:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8016e0:	90                   	nop
  8016e1:	c9                   	leave  
  8016e2:	c3                   	ret    

008016e3 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  8016e3:	55                   	push   %ebp
  8016e4:	89 e5                	mov    %esp,%ebp
  8016e6:	83 ec 38             	sub    $0x38,%esp
  8016e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8016ec:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ef:	e8 5f fc ff ff       	call   801353 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016f4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016f8:	75 0a                	jne    801704 <smalloc+0x21>
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ff:	e9 b2 00 00 00       	jmp    8017b6 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801704:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80170b:	76 0a                	jbe    801717 <smalloc+0x34>
		return NULL;
  80170d:	b8 00 00 00 00       	mov    $0x0,%eax
  801712:	e9 9f 00 00 00       	jmp    8017b6 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801717:	e8 3b 07 00 00       	call   801e57 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80171c:	85 c0                	test   %eax,%eax
  80171e:	0f 84 8d 00 00 00    	je     8017b1 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801724:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  80172b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801732:	8b 55 0c             	mov    0xc(%ebp),%edx
  801735:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801738:	01 d0                	add    %edx,%eax
  80173a:	48                   	dec    %eax
  80173b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80173e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801741:	ba 00 00 00 00       	mov    $0x0,%edx
  801746:	f7 75 f0             	divl   -0x10(%ebp)
  801749:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174c:	29 d0                	sub    %edx,%eax
  80174e:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801751:	83 ec 0c             	sub    $0xc,%esp
  801754:	ff 75 e8             	pushl  -0x18(%ebp)
  801757:	e8 5b 0c 00 00       	call   8023b7 <alloc_block_FF>
  80175c:	83 c4 10             	add    $0x10,%esp
  80175f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801762:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801766:	75 07                	jne    80176f <smalloc+0x8c>
			return NULL;
  801768:	b8 00 00 00 00       	mov    $0x0,%eax
  80176d:	eb 47                	jmp    8017b6 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  80176f:	83 ec 0c             	sub    $0xc,%esp
  801772:	ff 75 f4             	pushl  -0xc(%ebp)
  801775:	e8 a5 0a 00 00       	call   80221f <insert_sorted_allocList>
  80177a:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  80177d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801780:	8b 40 08             	mov    0x8(%eax),%eax
  801783:	89 c2                	mov    %eax,%edx
  801785:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801789:	52                   	push   %edx
  80178a:	50                   	push   %eax
  80178b:	ff 75 0c             	pushl  0xc(%ebp)
  80178e:	ff 75 08             	pushl  0x8(%ebp)
  801791:	e8 46 04 00 00       	call   801bdc <sys_createSharedObject>
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  80179c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017a0:	78 08                	js     8017aa <smalloc+0xc7>
		return (void *)b->sva;
  8017a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a5:	8b 40 08             	mov    0x8(%eax),%eax
  8017a8:	eb 0c                	jmp    8017b6 <smalloc+0xd3>
		}else{
		return NULL;
  8017aa:	b8 00 00 00 00       	mov    $0x0,%eax
  8017af:	eb 05                	jmp    8017b6 <smalloc+0xd3>
			}

	}return NULL;
  8017b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
  8017bb:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017be:	e8 90 fb ff ff       	call   801353 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8017c3:	e8 8f 06 00 00       	call   801e57 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017c8:	85 c0                	test   %eax,%eax
  8017ca:	0f 84 ad 00 00 00    	je     80187d <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017d0:	83 ec 08             	sub    $0x8,%esp
  8017d3:	ff 75 0c             	pushl  0xc(%ebp)
  8017d6:	ff 75 08             	pushl  0x8(%ebp)
  8017d9:	e8 28 04 00 00       	call   801c06 <sys_getSizeOfSharedObject>
  8017de:	83 c4 10             	add    $0x10,%esp
  8017e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  8017e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017e8:	79 0a                	jns    8017f4 <sget+0x3c>
    {
    	return NULL;
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ef:	e9 8e 00 00 00       	jmp    801882 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  8017f4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  8017fb:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801802:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801805:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801808:	01 d0                	add    %edx,%eax
  80180a:	48                   	dec    %eax
  80180b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80180e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801811:	ba 00 00 00 00       	mov    $0x0,%edx
  801816:	f7 75 ec             	divl   -0x14(%ebp)
  801819:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80181c:	29 d0                	sub    %edx,%eax
  80181e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801821:	83 ec 0c             	sub    $0xc,%esp
  801824:	ff 75 e4             	pushl  -0x1c(%ebp)
  801827:	e8 8b 0b 00 00       	call   8023b7 <alloc_block_FF>
  80182c:	83 c4 10             	add    $0x10,%esp
  80182f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801832:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801836:	75 07                	jne    80183f <sget+0x87>
				return NULL;
  801838:	b8 00 00 00 00       	mov    $0x0,%eax
  80183d:	eb 43                	jmp    801882 <sget+0xca>
			}
			insert_sorted_allocList(b);
  80183f:	83 ec 0c             	sub    $0xc,%esp
  801842:	ff 75 f0             	pushl  -0x10(%ebp)
  801845:	e8 d5 09 00 00       	call   80221f <insert_sorted_allocList>
  80184a:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  80184d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801850:	8b 40 08             	mov    0x8(%eax),%eax
  801853:	83 ec 04             	sub    $0x4,%esp
  801856:	50                   	push   %eax
  801857:	ff 75 0c             	pushl  0xc(%ebp)
  80185a:	ff 75 08             	pushl  0x8(%ebp)
  80185d:	e8 c1 03 00 00       	call   801c23 <sys_getSharedObject>
  801862:	83 c4 10             	add    $0x10,%esp
  801865:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801868:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80186c:	78 08                	js     801876 <sget+0xbe>
			return (void *)b->sva;
  80186e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801871:	8b 40 08             	mov    0x8(%eax),%eax
  801874:	eb 0c                	jmp    801882 <sget+0xca>
			}else{
			return NULL;
  801876:	b8 00 00 00 00       	mov    $0x0,%eax
  80187b:	eb 05                	jmp    801882 <sget+0xca>
			}
    }}return NULL;
  80187d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80188a:	e8 c4 fa ff ff       	call   801353 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80188f:	83 ec 04             	sub    $0x4,%esp
  801892:	68 a4 3b 80 00       	push   $0x803ba4
  801897:	68 03 01 00 00       	push   $0x103
  80189c:	68 73 3b 80 00       	push   $0x803b73
  8018a1:	e8 6f ea ff ff       	call   800315 <_panic>

008018a6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
  8018a9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018ac:	83 ec 04             	sub    $0x4,%esp
  8018af:	68 cc 3b 80 00       	push   $0x803bcc
  8018b4:	68 17 01 00 00       	push   $0x117
  8018b9:	68 73 3b 80 00       	push   $0x803b73
  8018be:	e8 52 ea ff ff       	call   800315 <_panic>

008018c3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018c3:	55                   	push   %ebp
  8018c4:	89 e5                	mov    %esp,%ebp
  8018c6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018c9:	83 ec 04             	sub    $0x4,%esp
  8018cc:	68 f0 3b 80 00       	push   $0x803bf0
  8018d1:	68 22 01 00 00       	push   $0x122
  8018d6:	68 73 3b 80 00       	push   $0x803b73
  8018db:	e8 35 ea ff ff       	call   800315 <_panic>

008018e0 <shrink>:

}
void shrink(uint32 newSize)
{
  8018e0:	55                   	push   %ebp
  8018e1:	89 e5                	mov    %esp,%ebp
  8018e3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e6:	83 ec 04             	sub    $0x4,%esp
  8018e9:	68 f0 3b 80 00       	push   $0x803bf0
  8018ee:	68 27 01 00 00       	push   $0x127
  8018f3:	68 73 3b 80 00       	push   $0x803b73
  8018f8:	e8 18 ea ff ff       	call   800315 <_panic>

008018fd <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018fd:	55                   	push   %ebp
  8018fe:	89 e5                	mov    %esp,%ebp
  801900:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801903:	83 ec 04             	sub    $0x4,%esp
  801906:	68 f0 3b 80 00       	push   $0x803bf0
  80190b:	68 2c 01 00 00       	push   $0x12c
  801910:	68 73 3b 80 00       	push   $0x803b73
  801915:	e8 fb e9 ff ff       	call   800315 <_panic>

0080191a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
  80191d:	57                   	push   %edi
  80191e:	56                   	push   %esi
  80191f:	53                   	push   %ebx
  801920:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801923:	8b 45 08             	mov    0x8(%ebp),%eax
  801926:	8b 55 0c             	mov    0xc(%ebp),%edx
  801929:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80192f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801932:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801935:	cd 30                	int    $0x30
  801937:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80193a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80193d:	83 c4 10             	add    $0x10,%esp
  801940:	5b                   	pop    %ebx
  801941:	5e                   	pop    %esi
  801942:	5f                   	pop    %edi
  801943:	5d                   	pop    %ebp
  801944:	c3                   	ret    

00801945 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	83 ec 04             	sub    $0x4,%esp
  80194b:	8b 45 10             	mov    0x10(%ebp),%eax
  80194e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801951:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801955:	8b 45 08             	mov    0x8(%ebp),%eax
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	52                   	push   %edx
  80195d:	ff 75 0c             	pushl  0xc(%ebp)
  801960:	50                   	push   %eax
  801961:	6a 00                	push   $0x0
  801963:	e8 b2 ff ff ff       	call   80191a <syscall>
  801968:	83 c4 18             	add    $0x18,%esp
}
  80196b:	90                   	nop
  80196c:	c9                   	leave  
  80196d:	c3                   	ret    

0080196e <sys_cgetc>:

int
sys_cgetc(void)
{
  80196e:	55                   	push   %ebp
  80196f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 01                	push   $0x1
  80197d:	e8 98 ff ff ff       	call   80191a <syscall>
  801982:	83 c4 18             	add    $0x18,%esp
}
  801985:	c9                   	leave  
  801986:	c3                   	ret    

00801987 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80198a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	52                   	push   %edx
  801997:	50                   	push   %eax
  801998:	6a 05                	push   $0x5
  80199a:	e8 7b ff ff ff       	call   80191a <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
  8019a7:	56                   	push   %esi
  8019a8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019a9:	8b 75 18             	mov    0x18(%ebp),%esi
  8019ac:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019af:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b8:	56                   	push   %esi
  8019b9:	53                   	push   %ebx
  8019ba:	51                   	push   %ecx
  8019bb:	52                   	push   %edx
  8019bc:	50                   	push   %eax
  8019bd:	6a 06                	push   $0x6
  8019bf:	e8 56 ff ff ff       	call   80191a <syscall>
  8019c4:	83 c4 18             	add    $0x18,%esp
}
  8019c7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ca:	5b                   	pop    %ebx
  8019cb:	5e                   	pop    %esi
  8019cc:	5d                   	pop    %ebp
  8019cd:	c3                   	ret    

008019ce <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019ce:	55                   	push   %ebp
  8019cf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019d1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	52                   	push   %edx
  8019de:	50                   	push   %eax
  8019df:	6a 07                	push   $0x7
  8019e1:	e8 34 ff ff ff       	call   80191a <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	ff 75 0c             	pushl  0xc(%ebp)
  8019f7:	ff 75 08             	pushl  0x8(%ebp)
  8019fa:	6a 08                	push   $0x8
  8019fc:	e8 19 ff ff ff       	call   80191a <syscall>
  801a01:	83 c4 18             	add    $0x18,%esp
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 09                	push   $0x9
  801a15:	e8 00 ff ff ff       	call   80191a <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 0a                	push   $0xa
  801a2e:	e8 e7 fe ff ff       	call   80191a <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	c9                   	leave  
  801a37:	c3                   	ret    

00801a38 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a38:	55                   	push   %ebp
  801a39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	6a 0b                	push   $0xb
  801a47:	e8 ce fe ff ff       	call   80191a <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
}
  801a4f:	c9                   	leave  
  801a50:	c3                   	ret    

00801a51 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a51:	55                   	push   %ebp
  801a52:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	ff 75 0c             	pushl  0xc(%ebp)
  801a5d:	ff 75 08             	pushl  0x8(%ebp)
  801a60:	6a 0f                	push   $0xf
  801a62:	e8 b3 fe ff ff       	call   80191a <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
	return;
  801a6a:	90                   	nop
}
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	ff 75 0c             	pushl  0xc(%ebp)
  801a79:	ff 75 08             	pushl  0x8(%ebp)
  801a7c:	6a 10                	push   $0x10
  801a7e:	e8 97 fe ff ff       	call   80191a <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
	return ;
  801a86:	90                   	nop
}
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 00                	push   $0x0
  801a90:	ff 75 10             	pushl  0x10(%ebp)
  801a93:	ff 75 0c             	pushl  0xc(%ebp)
  801a96:	ff 75 08             	pushl  0x8(%ebp)
  801a99:	6a 11                	push   $0x11
  801a9b:	e8 7a fe ff ff       	call   80191a <syscall>
  801aa0:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa3:	90                   	nop
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 0c                	push   $0xc
  801ab5:	e8 60 fe ff ff       	call   80191a <syscall>
  801aba:	83 c4 18             	add    $0x18,%esp
}
  801abd:	c9                   	leave  
  801abe:	c3                   	ret    

00801abf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801abf:	55                   	push   %ebp
  801ac0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 00                	push   $0x0
  801ac6:	6a 00                	push   $0x0
  801ac8:	6a 00                	push   $0x0
  801aca:	ff 75 08             	pushl  0x8(%ebp)
  801acd:	6a 0d                	push   $0xd
  801acf:	e8 46 fe ff ff       	call   80191a <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 0e                	push   $0xe
  801ae8:	e8 2d fe ff ff       	call   80191a <syscall>
  801aed:	83 c4 18             	add    $0x18,%esp
}
  801af0:	90                   	nop
  801af1:	c9                   	leave  
  801af2:	c3                   	ret    

00801af3 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801af3:	55                   	push   %ebp
  801af4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 13                	push   $0x13
  801b02:	e8 13 fe ff ff       	call   80191a <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
}
  801b0a:	90                   	nop
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 14                	push   $0x14
  801b1c:	e8 f9 fd ff ff       	call   80191a <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	90                   	nop
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
  801b2a:	83 ec 04             	sub    $0x4,%esp
  801b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b30:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b33:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	50                   	push   %eax
  801b40:	6a 15                	push   $0x15
  801b42:	e8 d3 fd ff ff       	call   80191a <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	90                   	nop
  801b4b:	c9                   	leave  
  801b4c:	c3                   	ret    

00801b4d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b4d:	55                   	push   %ebp
  801b4e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b50:	6a 00                	push   $0x0
  801b52:	6a 00                	push   $0x0
  801b54:	6a 00                	push   $0x0
  801b56:	6a 00                	push   $0x0
  801b58:	6a 00                	push   $0x0
  801b5a:	6a 16                	push   $0x16
  801b5c:	e8 b9 fd ff ff       	call   80191a <syscall>
  801b61:	83 c4 18             	add    $0x18,%esp
}
  801b64:	90                   	nop
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	ff 75 0c             	pushl  0xc(%ebp)
  801b76:	50                   	push   %eax
  801b77:	6a 17                	push   $0x17
  801b79:	e8 9c fd ff ff       	call   80191a <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	c9                   	leave  
  801b82:	c3                   	ret    

00801b83 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b83:	55                   	push   %ebp
  801b84:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b89:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	52                   	push   %edx
  801b93:	50                   	push   %eax
  801b94:	6a 1a                	push   $0x1a
  801b96:	e8 7f fd ff ff       	call   80191a <syscall>
  801b9b:	83 c4 18             	add    $0x18,%esp
}
  801b9e:	c9                   	leave  
  801b9f:	c3                   	ret    

00801ba0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ba0:	55                   	push   %ebp
  801ba1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ba3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	52                   	push   %edx
  801bb0:	50                   	push   %eax
  801bb1:	6a 18                	push   $0x18
  801bb3:	e8 62 fd ff ff       	call   80191a <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	90                   	nop
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	52                   	push   %edx
  801bce:	50                   	push   %eax
  801bcf:	6a 19                	push   $0x19
  801bd1:	e8 44 fd ff ff       	call   80191a <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	90                   	nop
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
  801bdf:	83 ec 04             	sub    $0x4,%esp
  801be2:	8b 45 10             	mov    0x10(%ebp),%eax
  801be5:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801be8:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801beb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bef:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf2:	6a 00                	push   $0x0
  801bf4:	51                   	push   %ecx
  801bf5:	52                   	push   %edx
  801bf6:	ff 75 0c             	pushl  0xc(%ebp)
  801bf9:	50                   	push   %eax
  801bfa:	6a 1b                	push   $0x1b
  801bfc:	e8 19 fd ff ff       	call   80191a <syscall>
  801c01:	83 c4 18             	add    $0x18,%esp
}
  801c04:	c9                   	leave  
  801c05:	c3                   	ret    

00801c06 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c06:	55                   	push   %ebp
  801c07:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	52                   	push   %edx
  801c16:	50                   	push   %eax
  801c17:	6a 1c                	push   $0x1c
  801c19:	e8 fc fc ff ff       	call   80191a <syscall>
  801c1e:	83 c4 18             	add    $0x18,%esp
}
  801c21:	c9                   	leave  
  801c22:	c3                   	ret    

00801c23 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c23:	55                   	push   %ebp
  801c24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c26:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	51                   	push   %ecx
  801c34:	52                   	push   %edx
  801c35:	50                   	push   %eax
  801c36:	6a 1d                	push   $0x1d
  801c38:	e8 dd fc ff ff       	call   80191a <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c45:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c48:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	52                   	push   %edx
  801c52:	50                   	push   %eax
  801c53:	6a 1e                	push   $0x1e
  801c55:	e8 c0 fc ff ff       	call   80191a <syscall>
  801c5a:	83 c4 18             	add    $0x18,%esp
}
  801c5d:	c9                   	leave  
  801c5e:	c3                   	ret    

00801c5f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c5f:	55                   	push   %ebp
  801c60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 1f                	push   $0x1f
  801c6e:	e8 a7 fc ff ff       	call   80191a <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7e:	6a 00                	push   $0x0
  801c80:	ff 75 14             	pushl  0x14(%ebp)
  801c83:	ff 75 10             	pushl  0x10(%ebp)
  801c86:	ff 75 0c             	pushl  0xc(%ebp)
  801c89:	50                   	push   %eax
  801c8a:	6a 20                	push   $0x20
  801c8c:	e8 89 fc ff ff       	call   80191a <syscall>
  801c91:	83 c4 18             	add    $0x18,%esp
}
  801c94:	c9                   	leave  
  801c95:	c3                   	ret    

00801c96 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c96:	55                   	push   %ebp
  801c97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c99:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	50                   	push   %eax
  801ca5:	6a 21                	push   $0x21
  801ca7:	e8 6e fc ff ff       	call   80191a <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
}
  801caf:	90                   	nop
  801cb0:	c9                   	leave  
  801cb1:	c3                   	ret    

00801cb2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cb2:	55                   	push   %ebp
  801cb3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	50                   	push   %eax
  801cc1:	6a 22                	push   $0x22
  801cc3:	e8 52 fc ff ff       	call   80191a <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 02                	push   $0x2
  801cdc:	e8 39 fc ff ff       	call   80191a <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
}
  801ce4:	c9                   	leave  
  801ce5:	c3                   	ret    

00801ce6 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ce6:	55                   	push   %ebp
  801ce7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 03                	push   $0x3
  801cf5:	e8 20 fc ff ff       	call   80191a <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
}
  801cfd:	c9                   	leave  
  801cfe:	c3                   	ret    

00801cff <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cff:	55                   	push   %ebp
  801d00:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d02:	6a 00                	push   $0x0
  801d04:	6a 00                	push   $0x0
  801d06:	6a 00                	push   $0x0
  801d08:	6a 00                	push   $0x0
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 04                	push   $0x4
  801d0e:	e8 07 fc ff ff       	call   80191a <syscall>
  801d13:	83 c4 18             	add    $0x18,%esp
}
  801d16:	c9                   	leave  
  801d17:	c3                   	ret    

00801d18 <sys_exit_env>:


void sys_exit_env(void)
{
  801d18:	55                   	push   %ebp
  801d19:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 23                	push   $0x23
  801d27:	e8 ee fb ff ff       	call   80191a <syscall>
  801d2c:	83 c4 18             	add    $0x18,%esp
}
  801d2f:	90                   	nop
  801d30:	c9                   	leave  
  801d31:	c3                   	ret    

00801d32 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d32:	55                   	push   %ebp
  801d33:	89 e5                	mov    %esp,%ebp
  801d35:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d38:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d3b:	8d 50 04             	lea    0x4(%eax),%edx
  801d3e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	52                   	push   %edx
  801d48:	50                   	push   %eax
  801d49:	6a 24                	push   $0x24
  801d4b:	e8 ca fb ff ff       	call   80191a <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
	return result;
  801d53:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d56:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d59:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d5c:	89 01                	mov    %eax,(%ecx)
  801d5e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d61:	8b 45 08             	mov    0x8(%ebp),%eax
  801d64:	c9                   	leave  
  801d65:	c2 04 00             	ret    $0x4

00801d68 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d68:	55                   	push   %ebp
  801d69:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	ff 75 10             	pushl  0x10(%ebp)
  801d72:	ff 75 0c             	pushl  0xc(%ebp)
  801d75:	ff 75 08             	pushl  0x8(%ebp)
  801d78:	6a 12                	push   $0x12
  801d7a:	e8 9b fb ff ff       	call   80191a <syscall>
  801d7f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d82:	90                   	nop
}
  801d83:	c9                   	leave  
  801d84:	c3                   	ret    

00801d85 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d85:	55                   	push   %ebp
  801d86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 25                	push   $0x25
  801d94:	e8 81 fb ff ff       	call   80191a <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
}
  801d9c:	c9                   	leave  
  801d9d:	c3                   	ret    

00801d9e <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d9e:	55                   	push   %ebp
  801d9f:	89 e5                	mov    %esp,%ebp
  801da1:	83 ec 04             	sub    $0x4,%esp
  801da4:	8b 45 08             	mov    0x8(%ebp),%eax
  801da7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801daa:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	50                   	push   %eax
  801db7:	6a 26                	push   $0x26
  801db9:	e8 5c fb ff ff       	call   80191a <syscall>
  801dbe:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc1:	90                   	nop
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <rsttst>:
void rsttst()
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 28                	push   $0x28
  801dd3:	e8 42 fb ff ff       	call   80191a <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddb:	90                   	nop
}
  801ddc:	c9                   	leave  
  801ddd:	c3                   	ret    

00801dde <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dde:	55                   	push   %ebp
  801ddf:	89 e5                	mov    %esp,%ebp
  801de1:	83 ec 04             	sub    $0x4,%esp
  801de4:	8b 45 14             	mov    0x14(%ebp),%eax
  801de7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dea:	8b 55 18             	mov    0x18(%ebp),%edx
  801ded:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801df1:	52                   	push   %edx
  801df2:	50                   	push   %eax
  801df3:	ff 75 10             	pushl  0x10(%ebp)
  801df6:	ff 75 0c             	pushl  0xc(%ebp)
  801df9:	ff 75 08             	pushl  0x8(%ebp)
  801dfc:	6a 27                	push   $0x27
  801dfe:	e8 17 fb ff ff       	call   80191a <syscall>
  801e03:	83 c4 18             	add    $0x18,%esp
	return ;
  801e06:	90                   	nop
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <chktst>:
void chktst(uint32 n)
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e0c:	6a 00                	push   $0x0
  801e0e:	6a 00                	push   $0x0
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	ff 75 08             	pushl  0x8(%ebp)
  801e17:	6a 29                	push   $0x29
  801e19:	e8 fc fa ff ff       	call   80191a <syscall>
  801e1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e21:	90                   	nop
}
  801e22:	c9                   	leave  
  801e23:	c3                   	ret    

00801e24 <inctst>:

void inctst()
{
  801e24:	55                   	push   %ebp
  801e25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 2a                	push   $0x2a
  801e33:	e8 e2 fa ff ff       	call   80191a <syscall>
  801e38:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3b:	90                   	nop
}
  801e3c:	c9                   	leave  
  801e3d:	c3                   	ret    

00801e3e <gettst>:
uint32 gettst()
{
  801e3e:	55                   	push   %ebp
  801e3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e41:	6a 00                	push   $0x0
  801e43:	6a 00                	push   $0x0
  801e45:	6a 00                	push   $0x0
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 2b                	push   $0x2b
  801e4d:	e8 c8 fa ff ff       	call   80191a <syscall>
  801e52:	83 c4 18             	add    $0x18,%esp
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e57:	55                   	push   %ebp
  801e58:	89 e5                	mov    %esp,%ebp
  801e5a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 2c                	push   $0x2c
  801e69:	e8 ac fa ff ff       	call   80191a <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
  801e71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e74:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e78:	75 07                	jne    801e81 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7f:	eb 05                	jmp    801e86 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
  801e8b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 2c                	push   $0x2c
  801e9a:	e8 7b fa ff ff       	call   80191a <syscall>
  801e9f:	83 c4 18             	add    $0x18,%esp
  801ea2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ea5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ea9:	75 07                	jne    801eb2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801eab:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb0:	eb 05                	jmp    801eb7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
  801ebc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	6a 00                	push   $0x0
  801ec9:	6a 2c                	push   $0x2c
  801ecb:	e8 4a fa ff ff       	call   80191a <syscall>
  801ed0:	83 c4 18             	add    $0x18,%esp
  801ed3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ed6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eda:	75 07                	jne    801ee3 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801edc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee1:	eb 05                	jmp    801ee8 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ee3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ee8:	c9                   	leave  
  801ee9:	c3                   	ret    

00801eea <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801eea:	55                   	push   %ebp
  801eeb:	89 e5                	mov    %esp,%ebp
  801eed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ef0:	6a 00                	push   $0x0
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	6a 2c                	push   $0x2c
  801efc:	e8 19 fa ff ff       	call   80191a <syscall>
  801f01:	83 c4 18             	add    $0x18,%esp
  801f04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f07:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f0b:	75 07                	jne    801f14 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f12:	eb 05                	jmp    801f19 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f19:	c9                   	leave  
  801f1a:	c3                   	ret    

00801f1b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f1b:	55                   	push   %ebp
  801f1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	ff 75 08             	pushl  0x8(%ebp)
  801f29:	6a 2d                	push   $0x2d
  801f2b:	e8 ea f9 ff ff       	call   80191a <syscall>
  801f30:	83 c4 18             	add    $0x18,%esp
	return ;
  801f33:	90                   	nop
}
  801f34:	c9                   	leave  
  801f35:	c3                   	ret    

00801f36 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f36:	55                   	push   %ebp
  801f37:	89 e5                	mov    %esp,%ebp
  801f39:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f3a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f3d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f40:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f43:	8b 45 08             	mov    0x8(%ebp),%eax
  801f46:	6a 00                	push   $0x0
  801f48:	53                   	push   %ebx
  801f49:	51                   	push   %ecx
  801f4a:	52                   	push   %edx
  801f4b:	50                   	push   %eax
  801f4c:	6a 2e                	push   $0x2e
  801f4e:	e8 c7 f9 ff ff       	call   80191a <syscall>
  801f53:	83 c4 18             	add    $0x18,%esp
}
  801f56:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f59:	c9                   	leave  
  801f5a:	c3                   	ret    

00801f5b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f5b:	55                   	push   %ebp
  801f5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f61:	8b 45 08             	mov    0x8(%ebp),%eax
  801f64:	6a 00                	push   $0x0
  801f66:	6a 00                	push   $0x0
  801f68:	6a 00                	push   $0x0
  801f6a:	52                   	push   %edx
  801f6b:	50                   	push   %eax
  801f6c:	6a 2f                	push   $0x2f
  801f6e:	e8 a7 f9 ff ff       	call   80191a <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
}
  801f76:	c9                   	leave  
  801f77:	c3                   	ret    

00801f78 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f78:	55                   	push   %ebp
  801f79:	89 e5                	mov    %esp,%ebp
  801f7b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f7e:	83 ec 0c             	sub    $0xc,%esp
  801f81:	68 00 3c 80 00       	push   $0x803c00
  801f86:	e8 3e e6 ff ff       	call   8005c9 <cprintf>
  801f8b:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f8e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f95:	83 ec 0c             	sub    $0xc,%esp
  801f98:	68 2c 3c 80 00       	push   $0x803c2c
  801f9d:	e8 27 e6 ff ff       	call   8005c9 <cprintf>
  801fa2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fa5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fa9:	a1 38 41 80 00       	mov    0x804138,%eax
  801fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb1:	eb 56                	jmp    802009 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fb3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb7:	74 1c                	je     801fd5 <print_mem_block_lists+0x5d>
  801fb9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fbc:	8b 50 08             	mov    0x8(%eax),%edx
  801fbf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc2:	8b 48 08             	mov    0x8(%eax),%ecx
  801fc5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc8:	8b 40 0c             	mov    0xc(%eax),%eax
  801fcb:	01 c8                	add    %ecx,%eax
  801fcd:	39 c2                	cmp    %eax,%edx
  801fcf:	73 04                	jae    801fd5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fd1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd8:	8b 50 08             	mov    0x8(%eax),%edx
  801fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fde:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe1:	01 c2                	add    %eax,%edx
  801fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe6:	8b 40 08             	mov    0x8(%eax),%eax
  801fe9:	83 ec 04             	sub    $0x4,%esp
  801fec:	52                   	push   %edx
  801fed:	50                   	push   %eax
  801fee:	68 41 3c 80 00       	push   $0x803c41
  801ff3:	e8 d1 e5 ff ff       	call   8005c9 <cprintf>
  801ff8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802001:	a1 40 41 80 00       	mov    0x804140,%eax
  802006:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802009:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80200d:	74 07                	je     802016 <print_mem_block_lists+0x9e>
  80200f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802012:	8b 00                	mov    (%eax),%eax
  802014:	eb 05                	jmp    80201b <print_mem_block_lists+0xa3>
  802016:	b8 00 00 00 00       	mov    $0x0,%eax
  80201b:	a3 40 41 80 00       	mov    %eax,0x804140
  802020:	a1 40 41 80 00       	mov    0x804140,%eax
  802025:	85 c0                	test   %eax,%eax
  802027:	75 8a                	jne    801fb3 <print_mem_block_lists+0x3b>
  802029:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202d:	75 84                	jne    801fb3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80202f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802033:	75 10                	jne    802045 <print_mem_block_lists+0xcd>
  802035:	83 ec 0c             	sub    $0xc,%esp
  802038:	68 50 3c 80 00       	push   $0x803c50
  80203d:	e8 87 e5 ff ff       	call   8005c9 <cprintf>
  802042:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802045:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80204c:	83 ec 0c             	sub    $0xc,%esp
  80204f:	68 74 3c 80 00       	push   $0x803c74
  802054:	e8 70 e5 ff ff       	call   8005c9 <cprintf>
  802059:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80205c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802060:	a1 40 40 80 00       	mov    0x804040,%eax
  802065:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802068:	eb 56                	jmp    8020c0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80206a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80206e:	74 1c                	je     80208c <print_mem_block_lists+0x114>
  802070:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802073:	8b 50 08             	mov    0x8(%eax),%edx
  802076:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802079:	8b 48 08             	mov    0x8(%eax),%ecx
  80207c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80207f:	8b 40 0c             	mov    0xc(%eax),%eax
  802082:	01 c8                	add    %ecx,%eax
  802084:	39 c2                	cmp    %eax,%edx
  802086:	73 04                	jae    80208c <print_mem_block_lists+0x114>
			sorted = 0 ;
  802088:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80208c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208f:	8b 50 08             	mov    0x8(%eax),%edx
  802092:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802095:	8b 40 0c             	mov    0xc(%eax),%eax
  802098:	01 c2                	add    %eax,%edx
  80209a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209d:	8b 40 08             	mov    0x8(%eax),%eax
  8020a0:	83 ec 04             	sub    $0x4,%esp
  8020a3:	52                   	push   %edx
  8020a4:	50                   	push   %eax
  8020a5:	68 41 3c 80 00       	push   $0x803c41
  8020aa:	e8 1a e5 ff ff       	call   8005c9 <cprintf>
  8020af:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020b8:	a1 48 40 80 00       	mov    0x804048,%eax
  8020bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020c4:	74 07                	je     8020cd <print_mem_block_lists+0x155>
  8020c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c9:	8b 00                	mov    (%eax),%eax
  8020cb:	eb 05                	jmp    8020d2 <print_mem_block_lists+0x15a>
  8020cd:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d2:	a3 48 40 80 00       	mov    %eax,0x804048
  8020d7:	a1 48 40 80 00       	mov    0x804048,%eax
  8020dc:	85 c0                	test   %eax,%eax
  8020de:	75 8a                	jne    80206a <print_mem_block_lists+0xf2>
  8020e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e4:	75 84                	jne    80206a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020e6:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020ea:	75 10                	jne    8020fc <print_mem_block_lists+0x184>
  8020ec:	83 ec 0c             	sub    $0xc,%esp
  8020ef:	68 8c 3c 80 00       	push   $0x803c8c
  8020f4:	e8 d0 e4 ff ff       	call   8005c9 <cprintf>
  8020f9:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020fc:	83 ec 0c             	sub    $0xc,%esp
  8020ff:	68 00 3c 80 00       	push   $0x803c00
  802104:	e8 c0 e4 ff ff       	call   8005c9 <cprintf>
  802109:	83 c4 10             	add    $0x10,%esp

}
  80210c:	90                   	nop
  80210d:	c9                   	leave  
  80210e:	c3                   	ret    

0080210f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80210f:	55                   	push   %ebp
  802110:	89 e5                	mov    %esp,%ebp
  802112:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802115:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80211c:	00 00 00 
  80211f:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802126:	00 00 00 
  802129:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802130:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802133:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80213a:	e9 9e 00 00 00       	jmp    8021dd <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  80213f:	a1 50 40 80 00       	mov    0x804050,%eax
  802144:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802147:	c1 e2 04             	shl    $0x4,%edx
  80214a:	01 d0                	add    %edx,%eax
  80214c:	85 c0                	test   %eax,%eax
  80214e:	75 14                	jne    802164 <initialize_MemBlocksList+0x55>
  802150:	83 ec 04             	sub    $0x4,%esp
  802153:	68 b4 3c 80 00       	push   $0x803cb4
  802158:	6a 3d                	push   $0x3d
  80215a:	68 d7 3c 80 00       	push   $0x803cd7
  80215f:	e8 b1 e1 ff ff       	call   800315 <_panic>
  802164:	a1 50 40 80 00       	mov    0x804050,%eax
  802169:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216c:	c1 e2 04             	shl    $0x4,%edx
  80216f:	01 d0                	add    %edx,%eax
  802171:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802177:	89 10                	mov    %edx,(%eax)
  802179:	8b 00                	mov    (%eax),%eax
  80217b:	85 c0                	test   %eax,%eax
  80217d:	74 18                	je     802197 <initialize_MemBlocksList+0x88>
  80217f:	a1 48 41 80 00       	mov    0x804148,%eax
  802184:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80218a:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80218d:	c1 e1 04             	shl    $0x4,%ecx
  802190:	01 ca                	add    %ecx,%edx
  802192:	89 50 04             	mov    %edx,0x4(%eax)
  802195:	eb 12                	jmp    8021a9 <initialize_MemBlocksList+0x9a>
  802197:	a1 50 40 80 00       	mov    0x804050,%eax
  80219c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219f:	c1 e2 04             	shl    $0x4,%edx
  8021a2:	01 d0                	add    %edx,%eax
  8021a4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021a9:	a1 50 40 80 00       	mov    0x804050,%eax
  8021ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b1:	c1 e2 04             	shl    $0x4,%edx
  8021b4:	01 d0                	add    %edx,%eax
  8021b6:	a3 48 41 80 00       	mov    %eax,0x804148
  8021bb:	a1 50 40 80 00       	mov    0x804050,%eax
  8021c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c3:	c1 e2 04             	shl    $0x4,%edx
  8021c6:	01 d0                	add    %edx,%eax
  8021c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021cf:	a1 54 41 80 00       	mov    0x804154,%eax
  8021d4:	40                   	inc    %eax
  8021d5:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8021da:	ff 45 f4             	incl   -0xc(%ebp)
  8021dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021e3:	0f 82 56 ff ff ff    	jb     80213f <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8021e9:	90                   	nop
  8021ea:	c9                   	leave  
  8021eb:	c3                   	ret    

008021ec <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021ec:	55                   	push   %ebp
  8021ed:	89 e5                	mov    %esp,%ebp
  8021ef:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8021f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f5:	8b 00                	mov    (%eax),%eax
  8021f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8021fa:	eb 18                	jmp    802214 <find_block+0x28>

		if(tmp->sva == va){
  8021fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ff:	8b 40 08             	mov    0x8(%eax),%eax
  802202:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802205:	75 05                	jne    80220c <find_block+0x20>
			return tmp ;
  802207:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80220a:	eb 11                	jmp    80221d <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  80220c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80220f:	8b 00                	mov    (%eax),%eax
  802211:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802214:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802218:	75 e2                	jne    8021fc <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  80221a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80221d:	c9                   	leave  
  80221e:	c3                   	ret    

0080221f <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80221f:	55                   	push   %ebp
  802220:	89 e5                	mov    %esp,%ebp
  802222:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802225:	a1 40 40 80 00       	mov    0x804040,%eax
  80222a:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  80222d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802232:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802235:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802239:	75 65                	jne    8022a0 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  80223b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80223f:	75 14                	jne    802255 <insert_sorted_allocList+0x36>
  802241:	83 ec 04             	sub    $0x4,%esp
  802244:	68 b4 3c 80 00       	push   $0x803cb4
  802249:	6a 62                	push   $0x62
  80224b:	68 d7 3c 80 00       	push   $0x803cd7
  802250:	e8 c0 e0 ff ff       	call   800315 <_panic>
  802255:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	89 10                	mov    %edx,(%eax)
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	8b 00                	mov    (%eax),%eax
  802265:	85 c0                	test   %eax,%eax
  802267:	74 0d                	je     802276 <insert_sorted_allocList+0x57>
  802269:	a1 40 40 80 00       	mov    0x804040,%eax
  80226e:	8b 55 08             	mov    0x8(%ebp),%edx
  802271:	89 50 04             	mov    %edx,0x4(%eax)
  802274:	eb 08                	jmp    80227e <insert_sorted_allocList+0x5f>
  802276:	8b 45 08             	mov    0x8(%ebp),%eax
  802279:	a3 44 40 80 00       	mov    %eax,0x804044
  80227e:	8b 45 08             	mov    0x8(%ebp),%eax
  802281:	a3 40 40 80 00       	mov    %eax,0x804040
  802286:	8b 45 08             	mov    0x8(%ebp),%eax
  802289:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802290:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802295:	40                   	inc    %eax
  802296:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80229b:	e9 14 01 00 00       	jmp    8023b4 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  8022a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a3:	8b 50 08             	mov    0x8(%eax),%edx
  8022a6:	a1 44 40 80 00       	mov    0x804044,%eax
  8022ab:	8b 40 08             	mov    0x8(%eax),%eax
  8022ae:	39 c2                	cmp    %eax,%edx
  8022b0:	76 65                	jbe    802317 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  8022b2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b6:	75 14                	jne    8022cc <insert_sorted_allocList+0xad>
  8022b8:	83 ec 04             	sub    $0x4,%esp
  8022bb:	68 f0 3c 80 00       	push   $0x803cf0
  8022c0:	6a 64                	push   $0x64
  8022c2:	68 d7 3c 80 00       	push   $0x803cd7
  8022c7:	e8 49 e0 ff ff       	call   800315 <_panic>
  8022cc:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	89 50 04             	mov    %edx,0x4(%eax)
  8022d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022db:	8b 40 04             	mov    0x4(%eax),%eax
  8022de:	85 c0                	test   %eax,%eax
  8022e0:	74 0c                	je     8022ee <insert_sorted_allocList+0xcf>
  8022e2:	a1 44 40 80 00       	mov    0x804044,%eax
  8022e7:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ea:	89 10                	mov    %edx,(%eax)
  8022ec:	eb 08                	jmp    8022f6 <insert_sorted_allocList+0xd7>
  8022ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f1:	a3 40 40 80 00       	mov    %eax,0x804040
  8022f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f9:	a3 44 40 80 00       	mov    %eax,0x804044
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802307:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80230c:	40                   	inc    %eax
  80230d:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802312:	e9 9d 00 00 00       	jmp    8023b4 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802317:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80231e:	e9 85 00 00 00       	jmp    8023a8 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802323:	8b 45 08             	mov    0x8(%ebp),%eax
  802326:	8b 50 08             	mov    0x8(%eax),%edx
  802329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232c:	8b 40 08             	mov    0x8(%eax),%eax
  80232f:	39 c2                	cmp    %eax,%edx
  802331:	73 6a                	jae    80239d <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802333:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802337:	74 06                	je     80233f <insert_sorted_allocList+0x120>
  802339:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80233d:	75 14                	jne    802353 <insert_sorted_allocList+0x134>
  80233f:	83 ec 04             	sub    $0x4,%esp
  802342:	68 14 3d 80 00       	push   $0x803d14
  802347:	6a 6b                	push   $0x6b
  802349:	68 d7 3c 80 00       	push   $0x803cd7
  80234e:	e8 c2 df ff ff       	call   800315 <_panic>
  802353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802356:	8b 50 04             	mov    0x4(%eax),%edx
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	89 50 04             	mov    %edx,0x4(%eax)
  80235f:	8b 45 08             	mov    0x8(%ebp),%eax
  802362:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802365:	89 10                	mov    %edx,(%eax)
  802367:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236a:	8b 40 04             	mov    0x4(%eax),%eax
  80236d:	85 c0                	test   %eax,%eax
  80236f:	74 0d                	je     80237e <insert_sorted_allocList+0x15f>
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	8b 40 04             	mov    0x4(%eax),%eax
  802377:	8b 55 08             	mov    0x8(%ebp),%edx
  80237a:	89 10                	mov    %edx,(%eax)
  80237c:	eb 08                	jmp    802386 <insert_sorted_allocList+0x167>
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	a3 40 40 80 00       	mov    %eax,0x804040
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 55 08             	mov    0x8(%ebp),%edx
  80238c:	89 50 04             	mov    %edx,0x4(%eax)
  80238f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802394:	40                   	inc    %eax
  802395:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  80239a:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80239b:	eb 17                	jmp    8023b4 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	8b 00                	mov    (%eax),%eax
  8023a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8023a5:	ff 45 f0             	incl   -0x10(%ebp)
  8023a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023ab:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8023ae:	0f 8c 6f ff ff ff    	jl     802323 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8023b4:	90                   	nop
  8023b5:	c9                   	leave  
  8023b6:	c3                   	ret    

008023b7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023b7:	55                   	push   %ebp
  8023b8:	89 e5                	mov    %esp,%ebp
  8023ba:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  8023bd:	a1 38 41 80 00       	mov    0x804138,%eax
  8023c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  8023c5:	e9 7c 01 00 00       	jmp    802546 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023d3:	0f 86 cf 00 00 00    	jbe    8024a8 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8023d9:	a1 48 41 80 00       	mov    0x804148,%eax
  8023de:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  8023e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8023e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ed:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8023f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f3:	8b 50 08             	mov    0x8(%eax),%edx
  8023f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f9:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8023fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802402:	2b 45 08             	sub    0x8(%ebp),%eax
  802405:	89 c2                	mov    %eax,%edx
  802407:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240a:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	8b 50 08             	mov    0x8(%eax),%edx
  802413:	8b 45 08             	mov    0x8(%ebp),%eax
  802416:	01 c2                	add    %eax,%edx
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80241e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802422:	75 17                	jne    80243b <alloc_block_FF+0x84>
  802424:	83 ec 04             	sub    $0x4,%esp
  802427:	68 49 3d 80 00       	push   $0x803d49
  80242c:	68 83 00 00 00       	push   $0x83
  802431:	68 d7 3c 80 00       	push   $0x803cd7
  802436:	e8 da de ff ff       	call   800315 <_panic>
  80243b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243e:	8b 00                	mov    (%eax),%eax
  802440:	85 c0                	test   %eax,%eax
  802442:	74 10                	je     802454 <alloc_block_FF+0x9d>
  802444:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802447:	8b 00                	mov    (%eax),%eax
  802449:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80244c:	8b 52 04             	mov    0x4(%edx),%edx
  80244f:	89 50 04             	mov    %edx,0x4(%eax)
  802452:	eb 0b                	jmp    80245f <alloc_block_FF+0xa8>
  802454:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802457:	8b 40 04             	mov    0x4(%eax),%eax
  80245a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80245f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802462:	8b 40 04             	mov    0x4(%eax),%eax
  802465:	85 c0                	test   %eax,%eax
  802467:	74 0f                	je     802478 <alloc_block_FF+0xc1>
  802469:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80246c:	8b 40 04             	mov    0x4(%eax),%eax
  80246f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802472:	8b 12                	mov    (%edx),%edx
  802474:	89 10                	mov    %edx,(%eax)
  802476:	eb 0a                	jmp    802482 <alloc_block_FF+0xcb>
  802478:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247b:	8b 00                	mov    (%eax),%eax
  80247d:	a3 48 41 80 00       	mov    %eax,0x804148
  802482:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802485:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80248b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802495:	a1 54 41 80 00       	mov    0x804154,%eax
  80249a:	48                   	dec    %eax
  80249b:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  8024a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a3:	e9 ad 00 00 00       	jmp    802555 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024b1:	0f 85 87 00 00 00    	jne    80253e <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  8024b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024bb:	75 17                	jne    8024d4 <alloc_block_FF+0x11d>
  8024bd:	83 ec 04             	sub    $0x4,%esp
  8024c0:	68 49 3d 80 00       	push   $0x803d49
  8024c5:	68 87 00 00 00       	push   $0x87
  8024ca:	68 d7 3c 80 00       	push   $0x803cd7
  8024cf:	e8 41 de ff ff       	call   800315 <_panic>
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	8b 00                	mov    (%eax),%eax
  8024d9:	85 c0                	test   %eax,%eax
  8024db:	74 10                	je     8024ed <alloc_block_FF+0x136>
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	8b 00                	mov    (%eax),%eax
  8024e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024e5:	8b 52 04             	mov    0x4(%edx),%edx
  8024e8:	89 50 04             	mov    %edx,0x4(%eax)
  8024eb:	eb 0b                	jmp    8024f8 <alloc_block_FF+0x141>
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 40 04             	mov    0x4(%eax),%eax
  8024f3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	8b 40 04             	mov    0x4(%eax),%eax
  8024fe:	85 c0                	test   %eax,%eax
  802500:	74 0f                	je     802511 <alloc_block_FF+0x15a>
  802502:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802505:	8b 40 04             	mov    0x4(%eax),%eax
  802508:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80250b:	8b 12                	mov    (%edx),%edx
  80250d:	89 10                	mov    %edx,(%eax)
  80250f:	eb 0a                	jmp    80251b <alloc_block_FF+0x164>
  802511:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802514:	8b 00                	mov    (%eax),%eax
  802516:	a3 38 41 80 00       	mov    %eax,0x804138
  80251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802524:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802527:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80252e:	a1 44 41 80 00       	mov    0x804144,%eax
  802533:	48                   	dec    %eax
  802534:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	eb 17                	jmp    802555 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  80253e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802541:	8b 00                	mov    (%eax),%eax
  802543:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802546:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80254a:	0f 85 7a fe ff ff    	jne    8023ca <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802550:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802555:	c9                   	leave  
  802556:	c3                   	ret    

00802557 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802557:	55                   	push   %ebp
  802558:	89 e5                	mov    %esp,%ebp
  80255a:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  80255d:	a1 38 41 80 00       	mov    0x804138,%eax
  802562:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802565:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  80256c:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802573:	a1 38 41 80 00       	mov    0x804138,%eax
  802578:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80257b:	e9 d0 00 00 00       	jmp    802650 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 40 0c             	mov    0xc(%eax),%eax
  802586:	3b 45 08             	cmp    0x8(%ebp),%eax
  802589:	0f 82 b8 00 00 00    	jb     802647 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  80258f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802592:	8b 40 0c             	mov    0xc(%eax),%eax
  802595:	2b 45 08             	sub    0x8(%ebp),%eax
  802598:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  80259b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80259e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025a1:	0f 83 a1 00 00 00    	jae    802648 <alloc_block_BF+0xf1>
				differsize = differance ;
  8025a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025aa:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  8025ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  8025b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025b7:	0f 85 8b 00 00 00    	jne    802648 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  8025bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c1:	75 17                	jne    8025da <alloc_block_BF+0x83>
  8025c3:	83 ec 04             	sub    $0x4,%esp
  8025c6:	68 49 3d 80 00       	push   $0x803d49
  8025cb:	68 a0 00 00 00       	push   $0xa0
  8025d0:	68 d7 3c 80 00       	push   $0x803cd7
  8025d5:	e8 3b dd ff ff       	call   800315 <_panic>
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	8b 00                	mov    (%eax),%eax
  8025df:	85 c0                	test   %eax,%eax
  8025e1:	74 10                	je     8025f3 <alloc_block_BF+0x9c>
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	8b 00                	mov    (%eax),%eax
  8025e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025eb:	8b 52 04             	mov    0x4(%edx),%edx
  8025ee:	89 50 04             	mov    %edx,0x4(%eax)
  8025f1:	eb 0b                	jmp    8025fe <alloc_block_BF+0xa7>
  8025f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f6:	8b 40 04             	mov    0x4(%eax),%eax
  8025f9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 40 04             	mov    0x4(%eax),%eax
  802604:	85 c0                	test   %eax,%eax
  802606:	74 0f                	je     802617 <alloc_block_BF+0xc0>
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 40 04             	mov    0x4(%eax),%eax
  80260e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802611:	8b 12                	mov    (%edx),%edx
  802613:	89 10                	mov    %edx,(%eax)
  802615:	eb 0a                	jmp    802621 <alloc_block_BF+0xca>
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	8b 00                	mov    (%eax),%eax
  80261c:	a3 38 41 80 00       	mov    %eax,0x804138
  802621:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802624:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802634:	a1 44 41 80 00       	mov    0x804144,%eax
  802639:	48                   	dec    %eax
  80263a:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  80263f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802642:	e9 0c 01 00 00       	jmp    802753 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802647:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802648:	a1 40 41 80 00       	mov    0x804140,%eax
  80264d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802650:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802654:	74 07                	je     80265d <alloc_block_BF+0x106>
  802656:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802659:	8b 00                	mov    (%eax),%eax
  80265b:	eb 05                	jmp    802662 <alloc_block_BF+0x10b>
  80265d:	b8 00 00 00 00       	mov    $0x0,%eax
  802662:	a3 40 41 80 00       	mov    %eax,0x804140
  802667:	a1 40 41 80 00       	mov    0x804140,%eax
  80266c:	85 c0                	test   %eax,%eax
  80266e:	0f 85 0c ff ff ff    	jne    802580 <alloc_block_BF+0x29>
  802674:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802678:	0f 85 02 ff ff ff    	jne    802580 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  80267e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802682:	0f 84 c6 00 00 00    	je     80274e <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802688:	a1 48 41 80 00       	mov    0x804148,%eax
  80268d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802690:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802693:	8b 55 08             	mov    0x8(%ebp),%edx
  802696:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802699:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80269c:	8b 50 08             	mov    0x8(%eax),%edx
  80269f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a2:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  8026a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026a8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ab:	2b 45 08             	sub    0x8(%ebp),%eax
  8026ae:	89 c2                	mov    %eax,%edx
  8026b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b3:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  8026b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b9:	8b 50 08             	mov    0x8(%eax),%edx
  8026bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026bf:	01 c2                	add    %eax,%edx
  8026c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c4:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  8026c7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026cb:	75 17                	jne    8026e4 <alloc_block_BF+0x18d>
  8026cd:	83 ec 04             	sub    $0x4,%esp
  8026d0:	68 49 3d 80 00       	push   $0x803d49
  8026d5:	68 af 00 00 00       	push   $0xaf
  8026da:	68 d7 3c 80 00       	push   $0x803cd7
  8026df:	e8 31 dc ff ff       	call   800315 <_panic>
  8026e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e7:	8b 00                	mov    (%eax),%eax
  8026e9:	85 c0                	test   %eax,%eax
  8026eb:	74 10                	je     8026fd <alloc_block_BF+0x1a6>
  8026ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f0:	8b 00                	mov    (%eax),%eax
  8026f2:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026f5:	8b 52 04             	mov    0x4(%edx),%edx
  8026f8:	89 50 04             	mov    %edx,0x4(%eax)
  8026fb:	eb 0b                	jmp    802708 <alloc_block_BF+0x1b1>
  8026fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802700:	8b 40 04             	mov    0x4(%eax),%eax
  802703:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802708:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270b:	8b 40 04             	mov    0x4(%eax),%eax
  80270e:	85 c0                	test   %eax,%eax
  802710:	74 0f                	je     802721 <alloc_block_BF+0x1ca>
  802712:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802715:	8b 40 04             	mov    0x4(%eax),%eax
  802718:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80271b:	8b 12                	mov    (%edx),%edx
  80271d:	89 10                	mov    %edx,(%eax)
  80271f:	eb 0a                	jmp    80272b <alloc_block_BF+0x1d4>
  802721:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802724:	8b 00                	mov    (%eax),%eax
  802726:	a3 48 41 80 00       	mov    %eax,0x804148
  80272b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80272e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802734:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802737:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80273e:	a1 54 41 80 00       	mov    0x804154,%eax
  802743:	48                   	dec    %eax
  802744:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  802749:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274c:	eb 05                	jmp    802753 <alloc_block_BF+0x1fc>
	}

	return NULL;
  80274e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802753:	c9                   	leave  
  802754:	c3                   	ret    

00802755 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802755:	55                   	push   %ebp
  802756:	89 e5                	mov    %esp,%ebp
  802758:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  80275b:	a1 38 41 80 00       	mov    0x804138,%eax
  802760:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802763:	e9 7c 01 00 00       	jmp    8028e4 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	8b 40 0c             	mov    0xc(%eax),%eax
  80276e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802771:	0f 86 cf 00 00 00    	jbe    802846 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802777:	a1 48 41 80 00       	mov    0x804148,%eax
  80277c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  80277f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802782:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802785:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802788:	8b 55 08             	mov    0x8(%ebp),%edx
  80278b:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  80278e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802791:	8b 50 08             	mov    0x8(%eax),%edx
  802794:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802797:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  80279a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80279d:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a0:	2b 45 08             	sub    0x8(%ebp),%eax
  8027a3:	89 c2                	mov    %eax,%edx
  8027a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a8:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 50 08             	mov    0x8(%eax),%edx
  8027b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027b4:	01 c2                	add    %eax,%edx
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8027bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027c0:	75 17                	jne    8027d9 <alloc_block_NF+0x84>
  8027c2:	83 ec 04             	sub    $0x4,%esp
  8027c5:	68 49 3d 80 00       	push   $0x803d49
  8027ca:	68 c4 00 00 00       	push   $0xc4
  8027cf:	68 d7 3c 80 00       	push   $0x803cd7
  8027d4:	e8 3c db ff ff       	call   800315 <_panic>
  8027d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027dc:	8b 00                	mov    (%eax),%eax
  8027de:	85 c0                	test   %eax,%eax
  8027e0:	74 10                	je     8027f2 <alloc_block_NF+0x9d>
  8027e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e5:	8b 00                	mov    (%eax),%eax
  8027e7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027ea:	8b 52 04             	mov    0x4(%edx),%edx
  8027ed:	89 50 04             	mov    %edx,0x4(%eax)
  8027f0:	eb 0b                	jmp    8027fd <alloc_block_NF+0xa8>
  8027f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f5:	8b 40 04             	mov    0x4(%eax),%eax
  8027f8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802800:	8b 40 04             	mov    0x4(%eax),%eax
  802803:	85 c0                	test   %eax,%eax
  802805:	74 0f                	je     802816 <alloc_block_NF+0xc1>
  802807:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80280a:	8b 40 04             	mov    0x4(%eax),%eax
  80280d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802810:	8b 12                	mov    (%edx),%edx
  802812:	89 10                	mov    %edx,(%eax)
  802814:	eb 0a                	jmp    802820 <alloc_block_NF+0xcb>
  802816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802819:	8b 00                	mov    (%eax),%eax
  80281b:	a3 48 41 80 00       	mov    %eax,0x804148
  802820:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802823:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802829:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802833:	a1 54 41 80 00       	mov    0x804154,%eax
  802838:	48                   	dec    %eax
  802839:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  80283e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802841:	e9 ad 00 00 00       	jmp    8028f3 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 40 0c             	mov    0xc(%eax),%eax
  80284c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80284f:	0f 85 87 00 00 00    	jne    8028dc <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802855:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802859:	75 17                	jne    802872 <alloc_block_NF+0x11d>
  80285b:	83 ec 04             	sub    $0x4,%esp
  80285e:	68 49 3d 80 00       	push   $0x803d49
  802863:	68 c8 00 00 00       	push   $0xc8
  802868:	68 d7 3c 80 00       	push   $0x803cd7
  80286d:	e8 a3 da ff ff       	call   800315 <_panic>
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 00                	mov    (%eax),%eax
  802877:	85 c0                	test   %eax,%eax
  802879:	74 10                	je     80288b <alloc_block_NF+0x136>
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	8b 00                	mov    (%eax),%eax
  802880:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802883:	8b 52 04             	mov    0x4(%edx),%edx
  802886:	89 50 04             	mov    %edx,0x4(%eax)
  802889:	eb 0b                	jmp    802896 <alloc_block_NF+0x141>
  80288b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288e:	8b 40 04             	mov    0x4(%eax),%eax
  802891:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	8b 40 04             	mov    0x4(%eax),%eax
  80289c:	85 c0                	test   %eax,%eax
  80289e:	74 0f                	je     8028af <alloc_block_NF+0x15a>
  8028a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a3:	8b 40 04             	mov    0x4(%eax),%eax
  8028a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a9:	8b 12                	mov    (%edx),%edx
  8028ab:	89 10                	mov    %edx,(%eax)
  8028ad:	eb 0a                	jmp    8028b9 <alloc_block_NF+0x164>
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 00                	mov    (%eax),%eax
  8028b4:	a3 38 41 80 00       	mov    %eax,0x804138
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cc:	a1 44 41 80 00       	mov    0x804144,%eax
  8028d1:	48                   	dec    %eax
  8028d2:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  8028d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028da:	eb 17                	jmp    8028f3 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 00                	mov    (%eax),%eax
  8028e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  8028e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e8:	0f 85 7a fe ff ff    	jne    802768 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  8028ee:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8028f3:	c9                   	leave  
  8028f4:	c3                   	ret    

008028f5 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8028f5:	55                   	push   %ebp
  8028f6:	89 e5                	mov    %esp,%ebp
  8028f8:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  8028fb:	a1 38 41 80 00       	mov    0x804138,%eax
  802900:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802903:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802908:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  80290b:	a1 44 41 80 00       	mov    0x804144,%eax
  802910:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802913:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802917:	75 68                	jne    802981 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802919:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80291d:	75 17                	jne    802936 <insert_sorted_with_merge_freeList+0x41>
  80291f:	83 ec 04             	sub    $0x4,%esp
  802922:	68 b4 3c 80 00       	push   $0x803cb4
  802927:	68 da 00 00 00       	push   $0xda
  80292c:	68 d7 3c 80 00       	push   $0x803cd7
  802931:	e8 df d9 ff ff       	call   800315 <_panic>
  802936:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80293c:	8b 45 08             	mov    0x8(%ebp),%eax
  80293f:	89 10                	mov    %edx,(%eax)
  802941:	8b 45 08             	mov    0x8(%ebp),%eax
  802944:	8b 00                	mov    (%eax),%eax
  802946:	85 c0                	test   %eax,%eax
  802948:	74 0d                	je     802957 <insert_sorted_with_merge_freeList+0x62>
  80294a:	a1 38 41 80 00       	mov    0x804138,%eax
  80294f:	8b 55 08             	mov    0x8(%ebp),%edx
  802952:	89 50 04             	mov    %edx,0x4(%eax)
  802955:	eb 08                	jmp    80295f <insert_sorted_with_merge_freeList+0x6a>
  802957:	8b 45 08             	mov    0x8(%ebp),%eax
  80295a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80295f:	8b 45 08             	mov    0x8(%ebp),%eax
  802962:	a3 38 41 80 00       	mov    %eax,0x804138
  802967:	8b 45 08             	mov    0x8(%ebp),%eax
  80296a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802971:	a1 44 41 80 00       	mov    0x804144,%eax
  802976:	40                   	inc    %eax
  802977:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  80297c:	e9 49 07 00 00       	jmp    8030ca <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802981:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802984:	8b 50 08             	mov    0x8(%eax),%edx
  802987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80298a:	8b 40 0c             	mov    0xc(%eax),%eax
  80298d:	01 c2                	add    %eax,%edx
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	8b 40 08             	mov    0x8(%eax),%eax
  802995:	39 c2                	cmp    %eax,%edx
  802997:	73 77                	jae    802a10 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802999:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299c:	8b 00                	mov    (%eax),%eax
  80299e:	85 c0                	test   %eax,%eax
  8029a0:	75 6e                	jne    802a10 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  8029a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029a6:	74 68                	je     802a10 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  8029a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029ac:	75 17                	jne    8029c5 <insert_sorted_with_merge_freeList+0xd0>
  8029ae:	83 ec 04             	sub    $0x4,%esp
  8029b1:	68 f0 3c 80 00       	push   $0x803cf0
  8029b6:	68 e0 00 00 00       	push   $0xe0
  8029bb:	68 d7 3c 80 00       	push   $0x803cd7
  8029c0:	e8 50 d9 ff ff       	call   800315 <_panic>
  8029c5:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	89 50 04             	mov    %edx,0x4(%eax)
  8029d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d4:	8b 40 04             	mov    0x4(%eax),%eax
  8029d7:	85 c0                	test   %eax,%eax
  8029d9:	74 0c                	je     8029e7 <insert_sorted_with_merge_freeList+0xf2>
  8029db:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029e3:	89 10                	mov    %edx,(%eax)
  8029e5:	eb 08                	jmp    8029ef <insert_sorted_with_merge_freeList+0xfa>
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	a3 38 41 80 00       	mov    %eax,0x804138
  8029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a00:	a1 44 41 80 00       	mov    0x804144,%eax
  802a05:	40                   	inc    %eax
  802a06:	a3 44 41 80 00       	mov    %eax,0x804144
  802a0b:	e9 ba 06 00 00       	jmp    8030ca <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802a10:	8b 45 08             	mov    0x8(%ebp),%eax
  802a13:	8b 50 0c             	mov    0xc(%eax),%edx
  802a16:	8b 45 08             	mov    0x8(%ebp),%eax
  802a19:	8b 40 08             	mov    0x8(%eax),%eax
  802a1c:	01 c2                	add    %eax,%edx
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	8b 40 08             	mov    0x8(%eax),%eax
  802a24:	39 c2                	cmp    %eax,%edx
  802a26:	73 78                	jae    802aa0 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 40 04             	mov    0x4(%eax),%eax
  802a2e:	85 c0                	test   %eax,%eax
  802a30:	75 6e                	jne    802aa0 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802a32:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a36:	74 68                	je     802aa0 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802a38:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a3c:	75 17                	jne    802a55 <insert_sorted_with_merge_freeList+0x160>
  802a3e:	83 ec 04             	sub    $0x4,%esp
  802a41:	68 b4 3c 80 00       	push   $0x803cb4
  802a46:	68 e6 00 00 00       	push   $0xe6
  802a4b:	68 d7 3c 80 00       	push   $0x803cd7
  802a50:	e8 c0 d8 ff ff       	call   800315 <_panic>
  802a55:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5e:	89 10                	mov    %edx,(%eax)
  802a60:	8b 45 08             	mov    0x8(%ebp),%eax
  802a63:	8b 00                	mov    (%eax),%eax
  802a65:	85 c0                	test   %eax,%eax
  802a67:	74 0d                	je     802a76 <insert_sorted_with_merge_freeList+0x181>
  802a69:	a1 38 41 80 00       	mov    0x804138,%eax
  802a6e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a71:	89 50 04             	mov    %edx,0x4(%eax)
  802a74:	eb 08                	jmp    802a7e <insert_sorted_with_merge_freeList+0x189>
  802a76:	8b 45 08             	mov    0x8(%ebp),%eax
  802a79:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a81:	a3 38 41 80 00       	mov    %eax,0x804138
  802a86:	8b 45 08             	mov    0x8(%ebp),%eax
  802a89:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a90:	a1 44 41 80 00       	mov    0x804144,%eax
  802a95:	40                   	inc    %eax
  802a96:	a3 44 41 80 00       	mov    %eax,0x804144
  802a9b:	e9 2a 06 00 00       	jmp    8030ca <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802aa0:	a1 38 41 80 00       	mov    0x804138,%eax
  802aa5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802aa8:	e9 ed 05 00 00       	jmp    80309a <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802aad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab0:	8b 00                	mov    (%eax),%eax
  802ab2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802ab5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ab9:	0f 84 a7 00 00 00    	je     802b66 <insert_sorted_with_merge_freeList+0x271>
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ac5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac8:	8b 40 08             	mov    0x8(%eax),%eax
  802acb:	01 c2                	add    %eax,%edx
  802acd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad0:	8b 40 08             	mov    0x8(%eax),%eax
  802ad3:	39 c2                	cmp    %eax,%edx
  802ad5:	0f 83 8b 00 00 00    	jae    802b66 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	8b 50 0c             	mov    0xc(%eax),%edx
  802ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae4:	8b 40 08             	mov    0x8(%eax),%eax
  802ae7:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802ae9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aec:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802aef:	39 c2                	cmp    %eax,%edx
  802af1:	73 73                	jae    802b66 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802af3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802af7:	74 06                	je     802aff <insert_sorted_with_merge_freeList+0x20a>
  802af9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802afd:	75 17                	jne    802b16 <insert_sorted_with_merge_freeList+0x221>
  802aff:	83 ec 04             	sub    $0x4,%esp
  802b02:	68 68 3d 80 00       	push   $0x803d68
  802b07:	68 f0 00 00 00       	push   $0xf0
  802b0c:	68 d7 3c 80 00       	push   $0x803cd7
  802b11:	e8 ff d7 ff ff       	call   800315 <_panic>
  802b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b19:	8b 10                	mov    (%eax),%edx
  802b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1e:	89 10                	mov    %edx,(%eax)
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	8b 00                	mov    (%eax),%eax
  802b25:	85 c0                	test   %eax,%eax
  802b27:	74 0b                	je     802b34 <insert_sorted_with_merge_freeList+0x23f>
  802b29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2c:	8b 00                	mov    (%eax),%eax
  802b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b31:	89 50 04             	mov    %edx,0x4(%eax)
  802b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b37:	8b 55 08             	mov    0x8(%ebp),%edx
  802b3a:	89 10                	mov    %edx,(%eax)
  802b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b42:	89 50 04             	mov    %edx,0x4(%eax)
  802b45:	8b 45 08             	mov    0x8(%ebp),%eax
  802b48:	8b 00                	mov    (%eax),%eax
  802b4a:	85 c0                	test   %eax,%eax
  802b4c:	75 08                	jne    802b56 <insert_sorted_with_merge_freeList+0x261>
  802b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b51:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b56:	a1 44 41 80 00       	mov    0x804144,%eax
  802b5b:	40                   	inc    %eax
  802b5c:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802b61:	e9 64 05 00 00       	jmp    8030ca <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802b66:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b6b:	8b 50 0c             	mov    0xc(%eax),%edx
  802b6e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b73:	8b 40 08             	mov    0x8(%eax),%eax
  802b76:	01 c2                	add    %eax,%edx
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	8b 40 08             	mov    0x8(%eax),%eax
  802b7e:	39 c2                	cmp    %eax,%edx
  802b80:	0f 85 b1 00 00 00    	jne    802c37 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802b86:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b8b:	85 c0                	test   %eax,%eax
  802b8d:	0f 84 a4 00 00 00    	je     802c37 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802b93:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b98:	8b 00                	mov    (%eax),%eax
  802b9a:	85 c0                	test   %eax,%eax
  802b9c:	0f 85 95 00 00 00    	jne    802c37 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802ba2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ba7:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802bad:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802bb0:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb3:	8b 52 0c             	mov    0xc(%edx),%edx
  802bb6:	01 ca                	add    %ecx,%edx
  802bb8:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802bcf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd3:	75 17                	jne    802bec <insert_sorted_with_merge_freeList+0x2f7>
  802bd5:	83 ec 04             	sub    $0x4,%esp
  802bd8:	68 b4 3c 80 00       	push   $0x803cb4
  802bdd:	68 ff 00 00 00       	push   $0xff
  802be2:	68 d7 3c 80 00       	push   $0x803cd7
  802be7:	e8 29 d7 ff ff       	call   800315 <_panic>
  802bec:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	89 10                	mov    %edx,(%eax)
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	8b 00                	mov    (%eax),%eax
  802bfc:	85 c0                	test   %eax,%eax
  802bfe:	74 0d                	je     802c0d <insert_sorted_with_merge_freeList+0x318>
  802c00:	a1 48 41 80 00       	mov    0x804148,%eax
  802c05:	8b 55 08             	mov    0x8(%ebp),%edx
  802c08:	89 50 04             	mov    %edx,0x4(%eax)
  802c0b:	eb 08                	jmp    802c15 <insert_sorted_with_merge_freeList+0x320>
  802c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c10:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	a3 48 41 80 00       	mov    %eax,0x804148
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c27:	a1 54 41 80 00       	mov    0x804154,%eax
  802c2c:	40                   	inc    %eax
  802c2d:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802c32:	e9 93 04 00 00       	jmp    8030ca <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802c37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3a:	8b 50 08             	mov    0x8(%eax),%edx
  802c3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c40:	8b 40 0c             	mov    0xc(%eax),%eax
  802c43:	01 c2                	add    %eax,%edx
  802c45:	8b 45 08             	mov    0x8(%ebp),%eax
  802c48:	8b 40 08             	mov    0x8(%eax),%eax
  802c4b:	39 c2                	cmp    %eax,%edx
  802c4d:	0f 85 ae 00 00 00    	jne    802d01 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802c53:	8b 45 08             	mov    0x8(%ebp),%eax
  802c56:	8b 50 0c             	mov    0xc(%eax),%edx
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	8b 40 08             	mov    0x8(%eax),%eax
  802c5f:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802c61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c64:	8b 00                	mov    (%eax),%eax
  802c66:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802c69:	39 c2                	cmp    %eax,%edx
  802c6b:	0f 84 90 00 00 00    	je     802d01 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	8b 50 0c             	mov    0xc(%eax),%edx
  802c77:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c7d:	01 c2                	add    %eax,%edx
  802c7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c82:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802c85:	8b 45 08             	mov    0x8(%ebp),%eax
  802c88:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c99:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c9d:	75 17                	jne    802cb6 <insert_sorted_with_merge_freeList+0x3c1>
  802c9f:	83 ec 04             	sub    $0x4,%esp
  802ca2:	68 b4 3c 80 00       	push   $0x803cb4
  802ca7:	68 0b 01 00 00       	push   $0x10b
  802cac:	68 d7 3c 80 00       	push   $0x803cd7
  802cb1:	e8 5f d6 ff ff       	call   800315 <_panic>
  802cb6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbf:	89 10                	mov    %edx,(%eax)
  802cc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc4:	8b 00                	mov    (%eax),%eax
  802cc6:	85 c0                	test   %eax,%eax
  802cc8:	74 0d                	je     802cd7 <insert_sorted_with_merge_freeList+0x3e2>
  802cca:	a1 48 41 80 00       	mov    0x804148,%eax
  802ccf:	8b 55 08             	mov    0x8(%ebp),%edx
  802cd2:	89 50 04             	mov    %edx,0x4(%eax)
  802cd5:	eb 08                	jmp    802cdf <insert_sorted_with_merge_freeList+0x3ea>
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce2:	a3 48 41 80 00       	mov    %eax,0x804148
  802ce7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cf1:	a1 54 41 80 00       	mov    0x804154,%eax
  802cf6:	40                   	inc    %eax
  802cf7:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802cfc:	e9 c9 03 00 00       	jmp    8030ca <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d01:	8b 45 08             	mov    0x8(%ebp),%eax
  802d04:	8b 50 0c             	mov    0xc(%eax),%edx
  802d07:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0a:	8b 40 08             	mov    0x8(%eax),%eax
  802d0d:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802d0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d12:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d15:	39 c2                	cmp    %eax,%edx
  802d17:	0f 85 bb 00 00 00    	jne    802dd8 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802d1d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d21:	0f 84 b1 00 00 00    	je     802dd8 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802d27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2a:	8b 40 04             	mov    0x4(%eax),%eax
  802d2d:	85 c0                	test   %eax,%eax
  802d2f:	0f 85 a3 00 00 00    	jne    802dd8 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802d35:	a1 38 41 80 00       	mov    0x804138,%eax
  802d3a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d3d:	8b 52 08             	mov    0x8(%edx),%edx
  802d40:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802d43:	a1 38 41 80 00       	mov    0x804138,%eax
  802d48:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d4e:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802d51:	8b 55 08             	mov    0x8(%ebp),%edx
  802d54:	8b 52 0c             	mov    0xc(%edx),%edx
  802d57:	01 ca                	add    %ecx,%edx
  802d59:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d74:	75 17                	jne    802d8d <insert_sorted_with_merge_freeList+0x498>
  802d76:	83 ec 04             	sub    $0x4,%esp
  802d79:	68 b4 3c 80 00       	push   $0x803cb4
  802d7e:	68 17 01 00 00       	push   $0x117
  802d83:	68 d7 3c 80 00       	push   $0x803cd7
  802d88:	e8 88 d5 ff ff       	call   800315 <_panic>
  802d8d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d93:	8b 45 08             	mov    0x8(%ebp),%eax
  802d96:	89 10                	mov    %edx,(%eax)
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	8b 00                	mov    (%eax),%eax
  802d9d:	85 c0                	test   %eax,%eax
  802d9f:	74 0d                	je     802dae <insert_sorted_with_merge_freeList+0x4b9>
  802da1:	a1 48 41 80 00       	mov    0x804148,%eax
  802da6:	8b 55 08             	mov    0x8(%ebp),%edx
  802da9:	89 50 04             	mov    %edx,0x4(%eax)
  802dac:	eb 08                	jmp    802db6 <insert_sorted_with_merge_freeList+0x4c1>
  802dae:	8b 45 08             	mov    0x8(%ebp),%eax
  802db1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802db6:	8b 45 08             	mov    0x8(%ebp),%eax
  802db9:	a3 48 41 80 00       	mov    %eax,0x804148
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc8:	a1 54 41 80 00       	mov    0x804154,%eax
  802dcd:	40                   	inc    %eax
  802dce:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802dd3:	e9 f2 02 00 00       	jmp    8030ca <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddb:	8b 50 08             	mov    0x8(%eax),%edx
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	8b 40 0c             	mov    0xc(%eax),%eax
  802de4:	01 c2                	add    %eax,%edx
  802de6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de9:	8b 40 08             	mov    0x8(%eax),%eax
  802dec:	39 c2                	cmp    %eax,%edx
  802dee:	0f 85 be 00 00 00    	jne    802eb2 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df7:	8b 40 04             	mov    0x4(%eax),%eax
  802dfa:	8b 50 08             	mov    0x8(%eax),%edx
  802dfd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e00:	8b 40 04             	mov    0x4(%eax),%eax
  802e03:	8b 40 0c             	mov    0xc(%eax),%eax
  802e06:	01 c2                	add    %eax,%edx
  802e08:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0b:	8b 40 08             	mov    0x8(%eax),%eax
  802e0e:	39 c2                	cmp    %eax,%edx
  802e10:	0f 84 9c 00 00 00    	je     802eb2 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802e16:	8b 45 08             	mov    0x8(%ebp),%eax
  802e19:	8b 50 08             	mov    0x8(%eax),%edx
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 50 0c             	mov    0xc(%eax),%edx
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e2e:	01 c2                	add    %eax,%edx
  802e30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e33:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e4e:	75 17                	jne    802e67 <insert_sorted_with_merge_freeList+0x572>
  802e50:	83 ec 04             	sub    $0x4,%esp
  802e53:	68 b4 3c 80 00       	push   $0x803cb4
  802e58:	68 26 01 00 00       	push   $0x126
  802e5d:	68 d7 3c 80 00       	push   $0x803cd7
  802e62:	e8 ae d4 ff ff       	call   800315 <_panic>
  802e67:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e70:	89 10                	mov    %edx,(%eax)
  802e72:	8b 45 08             	mov    0x8(%ebp),%eax
  802e75:	8b 00                	mov    (%eax),%eax
  802e77:	85 c0                	test   %eax,%eax
  802e79:	74 0d                	je     802e88 <insert_sorted_with_merge_freeList+0x593>
  802e7b:	a1 48 41 80 00       	mov    0x804148,%eax
  802e80:	8b 55 08             	mov    0x8(%ebp),%edx
  802e83:	89 50 04             	mov    %edx,0x4(%eax)
  802e86:	eb 08                	jmp    802e90 <insert_sorted_with_merge_freeList+0x59b>
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	a3 48 41 80 00       	mov    %eax,0x804148
  802e98:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ea2:	a1 54 41 80 00       	mov    0x804154,%eax
  802ea7:	40                   	inc    %eax
  802ea8:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802ead:	e9 18 02 00 00       	jmp    8030ca <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb5:	8b 50 0c             	mov    0xc(%eax),%edx
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	8b 40 08             	mov    0x8(%eax),%eax
  802ebe:	01 c2                	add    %eax,%edx
  802ec0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec3:	8b 40 08             	mov    0x8(%eax),%eax
  802ec6:	39 c2                	cmp    %eax,%edx
  802ec8:	0f 85 c4 01 00 00    	jne    803092 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802ece:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed7:	8b 40 08             	mov    0x8(%eax),%eax
  802eda:	01 c2                	add    %eax,%edx
  802edc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edf:	8b 00                	mov    (%eax),%eax
  802ee1:	8b 40 08             	mov    0x8(%eax),%eax
  802ee4:	39 c2                	cmp    %eax,%edx
  802ee6:	0f 85 a6 01 00 00    	jne    803092 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802eec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ef0:	0f 84 9c 01 00 00    	je     803092 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	8b 50 0c             	mov    0xc(%eax),%edx
  802efc:	8b 45 08             	mov    0x8(%ebp),%eax
  802eff:	8b 40 0c             	mov    0xc(%eax),%eax
  802f02:	01 c2                	add    %eax,%edx
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 00                	mov    (%eax),%eax
  802f09:	8b 40 0c             	mov    0xc(%eax),%eax
  802f0c:	01 c2                	add    %eax,%edx
  802f0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f11:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802f14:	8b 45 08             	mov    0x8(%ebp),%eax
  802f17:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802f28:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f2c:	75 17                	jne    802f45 <insert_sorted_with_merge_freeList+0x650>
  802f2e:	83 ec 04             	sub    $0x4,%esp
  802f31:	68 b4 3c 80 00       	push   $0x803cb4
  802f36:	68 32 01 00 00       	push   $0x132
  802f3b:	68 d7 3c 80 00       	push   $0x803cd7
  802f40:	e8 d0 d3 ff ff       	call   800315 <_panic>
  802f45:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4e:	89 10                	mov    %edx,(%eax)
  802f50:	8b 45 08             	mov    0x8(%ebp),%eax
  802f53:	8b 00                	mov    (%eax),%eax
  802f55:	85 c0                	test   %eax,%eax
  802f57:	74 0d                	je     802f66 <insert_sorted_with_merge_freeList+0x671>
  802f59:	a1 48 41 80 00       	mov    0x804148,%eax
  802f5e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f61:	89 50 04             	mov    %edx,0x4(%eax)
  802f64:	eb 08                	jmp    802f6e <insert_sorted_with_merge_freeList+0x679>
  802f66:	8b 45 08             	mov    0x8(%ebp),%eax
  802f69:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	a3 48 41 80 00       	mov    %eax,0x804148
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f80:	a1 54 41 80 00       	mov    0x804154,%eax
  802f85:	40                   	inc    %eax
  802f86:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8e:	8b 00                	mov    (%eax),%eax
  802f90:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9a:	8b 00                	mov    (%eax),%eax
  802f9c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fa6:	8b 00                	mov    (%eax),%eax
  802fa8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802fab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802faf:	75 17                	jne    802fc8 <insert_sorted_with_merge_freeList+0x6d3>
  802fb1:	83 ec 04             	sub    $0x4,%esp
  802fb4:	68 49 3d 80 00       	push   $0x803d49
  802fb9:	68 36 01 00 00       	push   $0x136
  802fbe:	68 d7 3c 80 00       	push   $0x803cd7
  802fc3:	e8 4d d3 ff ff       	call   800315 <_panic>
  802fc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fcb:	8b 00                	mov    (%eax),%eax
  802fcd:	85 c0                	test   %eax,%eax
  802fcf:	74 10                	je     802fe1 <insert_sorted_with_merge_freeList+0x6ec>
  802fd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd4:	8b 00                	mov    (%eax),%eax
  802fd6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fd9:	8b 52 04             	mov    0x4(%edx),%edx
  802fdc:	89 50 04             	mov    %edx,0x4(%eax)
  802fdf:	eb 0b                	jmp    802fec <insert_sorted_with_merge_freeList+0x6f7>
  802fe1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe4:	8b 40 04             	mov    0x4(%eax),%eax
  802fe7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fef:	8b 40 04             	mov    0x4(%eax),%eax
  802ff2:	85 c0                	test   %eax,%eax
  802ff4:	74 0f                	je     803005 <insert_sorted_with_merge_freeList+0x710>
  802ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff9:	8b 40 04             	mov    0x4(%eax),%eax
  802ffc:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fff:	8b 12                	mov    (%edx),%edx
  803001:	89 10                	mov    %edx,(%eax)
  803003:	eb 0a                	jmp    80300f <insert_sorted_with_merge_freeList+0x71a>
  803005:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803008:	8b 00                	mov    (%eax),%eax
  80300a:	a3 38 41 80 00       	mov    %eax,0x804138
  80300f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803012:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803018:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803022:	a1 44 41 80 00       	mov    0x804144,%eax
  803027:	48                   	dec    %eax
  803028:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  80302d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803031:	75 17                	jne    80304a <insert_sorted_with_merge_freeList+0x755>
  803033:	83 ec 04             	sub    $0x4,%esp
  803036:	68 b4 3c 80 00       	push   $0x803cb4
  80303b:	68 37 01 00 00       	push   $0x137
  803040:	68 d7 3c 80 00       	push   $0x803cd7
  803045:	e8 cb d2 ff ff       	call   800315 <_panic>
  80304a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803050:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803053:	89 10                	mov    %edx,(%eax)
  803055:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803058:	8b 00                	mov    (%eax),%eax
  80305a:	85 c0                	test   %eax,%eax
  80305c:	74 0d                	je     80306b <insert_sorted_with_merge_freeList+0x776>
  80305e:	a1 48 41 80 00       	mov    0x804148,%eax
  803063:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803066:	89 50 04             	mov    %edx,0x4(%eax)
  803069:	eb 08                	jmp    803073 <insert_sorted_with_merge_freeList+0x77e>
  80306b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803073:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803076:	a3 48 41 80 00       	mov    %eax,0x804148
  80307b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80307e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803085:	a1 54 41 80 00       	mov    0x804154,%eax
  80308a:	40                   	inc    %eax
  80308b:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  803090:	eb 38                	jmp    8030ca <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803092:	a1 40 41 80 00       	mov    0x804140,%eax
  803097:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80309a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80309e:	74 07                	je     8030a7 <insert_sorted_with_merge_freeList+0x7b2>
  8030a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030a3:	8b 00                	mov    (%eax),%eax
  8030a5:	eb 05                	jmp    8030ac <insert_sorted_with_merge_freeList+0x7b7>
  8030a7:	b8 00 00 00 00       	mov    $0x0,%eax
  8030ac:	a3 40 41 80 00       	mov    %eax,0x804140
  8030b1:	a1 40 41 80 00       	mov    0x804140,%eax
  8030b6:	85 c0                	test   %eax,%eax
  8030b8:	0f 85 ef f9 ff ff    	jne    802aad <insert_sorted_with_merge_freeList+0x1b8>
  8030be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030c2:	0f 85 e5 f9 ff ff    	jne    802aad <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  8030c8:	eb 00                	jmp    8030ca <insert_sorted_with_merge_freeList+0x7d5>
  8030ca:	90                   	nop
  8030cb:	c9                   	leave  
  8030cc:	c3                   	ret    
  8030cd:	66 90                	xchg   %ax,%ax
  8030cf:	90                   	nop

008030d0 <__udivdi3>:
  8030d0:	55                   	push   %ebp
  8030d1:	57                   	push   %edi
  8030d2:	56                   	push   %esi
  8030d3:	53                   	push   %ebx
  8030d4:	83 ec 1c             	sub    $0x1c,%esp
  8030d7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030db:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030df:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030e3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030e7:	89 ca                	mov    %ecx,%edx
  8030e9:	89 f8                	mov    %edi,%eax
  8030eb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8030ef:	85 f6                	test   %esi,%esi
  8030f1:	75 2d                	jne    803120 <__udivdi3+0x50>
  8030f3:	39 cf                	cmp    %ecx,%edi
  8030f5:	77 65                	ja     80315c <__udivdi3+0x8c>
  8030f7:	89 fd                	mov    %edi,%ebp
  8030f9:	85 ff                	test   %edi,%edi
  8030fb:	75 0b                	jne    803108 <__udivdi3+0x38>
  8030fd:	b8 01 00 00 00       	mov    $0x1,%eax
  803102:	31 d2                	xor    %edx,%edx
  803104:	f7 f7                	div    %edi
  803106:	89 c5                	mov    %eax,%ebp
  803108:	31 d2                	xor    %edx,%edx
  80310a:	89 c8                	mov    %ecx,%eax
  80310c:	f7 f5                	div    %ebp
  80310e:	89 c1                	mov    %eax,%ecx
  803110:	89 d8                	mov    %ebx,%eax
  803112:	f7 f5                	div    %ebp
  803114:	89 cf                	mov    %ecx,%edi
  803116:	89 fa                	mov    %edi,%edx
  803118:	83 c4 1c             	add    $0x1c,%esp
  80311b:	5b                   	pop    %ebx
  80311c:	5e                   	pop    %esi
  80311d:	5f                   	pop    %edi
  80311e:	5d                   	pop    %ebp
  80311f:	c3                   	ret    
  803120:	39 ce                	cmp    %ecx,%esi
  803122:	77 28                	ja     80314c <__udivdi3+0x7c>
  803124:	0f bd fe             	bsr    %esi,%edi
  803127:	83 f7 1f             	xor    $0x1f,%edi
  80312a:	75 40                	jne    80316c <__udivdi3+0x9c>
  80312c:	39 ce                	cmp    %ecx,%esi
  80312e:	72 0a                	jb     80313a <__udivdi3+0x6a>
  803130:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803134:	0f 87 9e 00 00 00    	ja     8031d8 <__udivdi3+0x108>
  80313a:	b8 01 00 00 00       	mov    $0x1,%eax
  80313f:	89 fa                	mov    %edi,%edx
  803141:	83 c4 1c             	add    $0x1c,%esp
  803144:	5b                   	pop    %ebx
  803145:	5e                   	pop    %esi
  803146:	5f                   	pop    %edi
  803147:	5d                   	pop    %ebp
  803148:	c3                   	ret    
  803149:	8d 76 00             	lea    0x0(%esi),%esi
  80314c:	31 ff                	xor    %edi,%edi
  80314e:	31 c0                	xor    %eax,%eax
  803150:	89 fa                	mov    %edi,%edx
  803152:	83 c4 1c             	add    $0x1c,%esp
  803155:	5b                   	pop    %ebx
  803156:	5e                   	pop    %esi
  803157:	5f                   	pop    %edi
  803158:	5d                   	pop    %ebp
  803159:	c3                   	ret    
  80315a:	66 90                	xchg   %ax,%ax
  80315c:	89 d8                	mov    %ebx,%eax
  80315e:	f7 f7                	div    %edi
  803160:	31 ff                	xor    %edi,%edi
  803162:	89 fa                	mov    %edi,%edx
  803164:	83 c4 1c             	add    $0x1c,%esp
  803167:	5b                   	pop    %ebx
  803168:	5e                   	pop    %esi
  803169:	5f                   	pop    %edi
  80316a:	5d                   	pop    %ebp
  80316b:	c3                   	ret    
  80316c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803171:	89 eb                	mov    %ebp,%ebx
  803173:	29 fb                	sub    %edi,%ebx
  803175:	89 f9                	mov    %edi,%ecx
  803177:	d3 e6                	shl    %cl,%esi
  803179:	89 c5                	mov    %eax,%ebp
  80317b:	88 d9                	mov    %bl,%cl
  80317d:	d3 ed                	shr    %cl,%ebp
  80317f:	89 e9                	mov    %ebp,%ecx
  803181:	09 f1                	or     %esi,%ecx
  803183:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803187:	89 f9                	mov    %edi,%ecx
  803189:	d3 e0                	shl    %cl,%eax
  80318b:	89 c5                	mov    %eax,%ebp
  80318d:	89 d6                	mov    %edx,%esi
  80318f:	88 d9                	mov    %bl,%cl
  803191:	d3 ee                	shr    %cl,%esi
  803193:	89 f9                	mov    %edi,%ecx
  803195:	d3 e2                	shl    %cl,%edx
  803197:	8b 44 24 08          	mov    0x8(%esp),%eax
  80319b:	88 d9                	mov    %bl,%cl
  80319d:	d3 e8                	shr    %cl,%eax
  80319f:	09 c2                	or     %eax,%edx
  8031a1:	89 d0                	mov    %edx,%eax
  8031a3:	89 f2                	mov    %esi,%edx
  8031a5:	f7 74 24 0c          	divl   0xc(%esp)
  8031a9:	89 d6                	mov    %edx,%esi
  8031ab:	89 c3                	mov    %eax,%ebx
  8031ad:	f7 e5                	mul    %ebp
  8031af:	39 d6                	cmp    %edx,%esi
  8031b1:	72 19                	jb     8031cc <__udivdi3+0xfc>
  8031b3:	74 0b                	je     8031c0 <__udivdi3+0xf0>
  8031b5:	89 d8                	mov    %ebx,%eax
  8031b7:	31 ff                	xor    %edi,%edi
  8031b9:	e9 58 ff ff ff       	jmp    803116 <__udivdi3+0x46>
  8031be:	66 90                	xchg   %ax,%ax
  8031c0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031c4:	89 f9                	mov    %edi,%ecx
  8031c6:	d3 e2                	shl    %cl,%edx
  8031c8:	39 c2                	cmp    %eax,%edx
  8031ca:	73 e9                	jae    8031b5 <__udivdi3+0xe5>
  8031cc:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031cf:	31 ff                	xor    %edi,%edi
  8031d1:	e9 40 ff ff ff       	jmp    803116 <__udivdi3+0x46>
  8031d6:	66 90                	xchg   %ax,%ax
  8031d8:	31 c0                	xor    %eax,%eax
  8031da:	e9 37 ff ff ff       	jmp    803116 <__udivdi3+0x46>
  8031df:	90                   	nop

008031e0 <__umoddi3>:
  8031e0:	55                   	push   %ebp
  8031e1:	57                   	push   %edi
  8031e2:	56                   	push   %esi
  8031e3:	53                   	push   %ebx
  8031e4:	83 ec 1c             	sub    $0x1c,%esp
  8031e7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031eb:	8b 74 24 34          	mov    0x34(%esp),%esi
  8031ef:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031f3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8031f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8031fb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8031ff:	89 f3                	mov    %esi,%ebx
  803201:	89 fa                	mov    %edi,%edx
  803203:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803207:	89 34 24             	mov    %esi,(%esp)
  80320a:	85 c0                	test   %eax,%eax
  80320c:	75 1a                	jne    803228 <__umoddi3+0x48>
  80320e:	39 f7                	cmp    %esi,%edi
  803210:	0f 86 a2 00 00 00    	jbe    8032b8 <__umoddi3+0xd8>
  803216:	89 c8                	mov    %ecx,%eax
  803218:	89 f2                	mov    %esi,%edx
  80321a:	f7 f7                	div    %edi
  80321c:	89 d0                	mov    %edx,%eax
  80321e:	31 d2                	xor    %edx,%edx
  803220:	83 c4 1c             	add    $0x1c,%esp
  803223:	5b                   	pop    %ebx
  803224:	5e                   	pop    %esi
  803225:	5f                   	pop    %edi
  803226:	5d                   	pop    %ebp
  803227:	c3                   	ret    
  803228:	39 f0                	cmp    %esi,%eax
  80322a:	0f 87 ac 00 00 00    	ja     8032dc <__umoddi3+0xfc>
  803230:	0f bd e8             	bsr    %eax,%ebp
  803233:	83 f5 1f             	xor    $0x1f,%ebp
  803236:	0f 84 ac 00 00 00    	je     8032e8 <__umoddi3+0x108>
  80323c:	bf 20 00 00 00       	mov    $0x20,%edi
  803241:	29 ef                	sub    %ebp,%edi
  803243:	89 fe                	mov    %edi,%esi
  803245:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803249:	89 e9                	mov    %ebp,%ecx
  80324b:	d3 e0                	shl    %cl,%eax
  80324d:	89 d7                	mov    %edx,%edi
  80324f:	89 f1                	mov    %esi,%ecx
  803251:	d3 ef                	shr    %cl,%edi
  803253:	09 c7                	or     %eax,%edi
  803255:	89 e9                	mov    %ebp,%ecx
  803257:	d3 e2                	shl    %cl,%edx
  803259:	89 14 24             	mov    %edx,(%esp)
  80325c:	89 d8                	mov    %ebx,%eax
  80325e:	d3 e0                	shl    %cl,%eax
  803260:	89 c2                	mov    %eax,%edx
  803262:	8b 44 24 08          	mov    0x8(%esp),%eax
  803266:	d3 e0                	shl    %cl,%eax
  803268:	89 44 24 04          	mov    %eax,0x4(%esp)
  80326c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803270:	89 f1                	mov    %esi,%ecx
  803272:	d3 e8                	shr    %cl,%eax
  803274:	09 d0                	or     %edx,%eax
  803276:	d3 eb                	shr    %cl,%ebx
  803278:	89 da                	mov    %ebx,%edx
  80327a:	f7 f7                	div    %edi
  80327c:	89 d3                	mov    %edx,%ebx
  80327e:	f7 24 24             	mull   (%esp)
  803281:	89 c6                	mov    %eax,%esi
  803283:	89 d1                	mov    %edx,%ecx
  803285:	39 d3                	cmp    %edx,%ebx
  803287:	0f 82 87 00 00 00    	jb     803314 <__umoddi3+0x134>
  80328d:	0f 84 91 00 00 00    	je     803324 <__umoddi3+0x144>
  803293:	8b 54 24 04          	mov    0x4(%esp),%edx
  803297:	29 f2                	sub    %esi,%edx
  803299:	19 cb                	sbb    %ecx,%ebx
  80329b:	89 d8                	mov    %ebx,%eax
  80329d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032a1:	d3 e0                	shl    %cl,%eax
  8032a3:	89 e9                	mov    %ebp,%ecx
  8032a5:	d3 ea                	shr    %cl,%edx
  8032a7:	09 d0                	or     %edx,%eax
  8032a9:	89 e9                	mov    %ebp,%ecx
  8032ab:	d3 eb                	shr    %cl,%ebx
  8032ad:	89 da                	mov    %ebx,%edx
  8032af:	83 c4 1c             	add    $0x1c,%esp
  8032b2:	5b                   	pop    %ebx
  8032b3:	5e                   	pop    %esi
  8032b4:	5f                   	pop    %edi
  8032b5:	5d                   	pop    %ebp
  8032b6:	c3                   	ret    
  8032b7:	90                   	nop
  8032b8:	89 fd                	mov    %edi,%ebp
  8032ba:	85 ff                	test   %edi,%edi
  8032bc:	75 0b                	jne    8032c9 <__umoddi3+0xe9>
  8032be:	b8 01 00 00 00       	mov    $0x1,%eax
  8032c3:	31 d2                	xor    %edx,%edx
  8032c5:	f7 f7                	div    %edi
  8032c7:	89 c5                	mov    %eax,%ebp
  8032c9:	89 f0                	mov    %esi,%eax
  8032cb:	31 d2                	xor    %edx,%edx
  8032cd:	f7 f5                	div    %ebp
  8032cf:	89 c8                	mov    %ecx,%eax
  8032d1:	f7 f5                	div    %ebp
  8032d3:	89 d0                	mov    %edx,%eax
  8032d5:	e9 44 ff ff ff       	jmp    80321e <__umoddi3+0x3e>
  8032da:	66 90                	xchg   %ax,%ax
  8032dc:	89 c8                	mov    %ecx,%eax
  8032de:	89 f2                	mov    %esi,%edx
  8032e0:	83 c4 1c             	add    $0x1c,%esp
  8032e3:	5b                   	pop    %ebx
  8032e4:	5e                   	pop    %esi
  8032e5:	5f                   	pop    %edi
  8032e6:	5d                   	pop    %ebp
  8032e7:	c3                   	ret    
  8032e8:	3b 04 24             	cmp    (%esp),%eax
  8032eb:	72 06                	jb     8032f3 <__umoddi3+0x113>
  8032ed:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8032f1:	77 0f                	ja     803302 <__umoddi3+0x122>
  8032f3:	89 f2                	mov    %esi,%edx
  8032f5:	29 f9                	sub    %edi,%ecx
  8032f7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8032fb:	89 14 24             	mov    %edx,(%esp)
  8032fe:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803302:	8b 44 24 04          	mov    0x4(%esp),%eax
  803306:	8b 14 24             	mov    (%esp),%edx
  803309:	83 c4 1c             	add    $0x1c,%esp
  80330c:	5b                   	pop    %ebx
  80330d:	5e                   	pop    %esi
  80330e:	5f                   	pop    %edi
  80330f:	5d                   	pop    %ebp
  803310:	c3                   	ret    
  803311:	8d 76 00             	lea    0x0(%esi),%esi
  803314:	2b 04 24             	sub    (%esp),%eax
  803317:	19 fa                	sbb    %edi,%edx
  803319:	89 d1                	mov    %edx,%ecx
  80331b:	89 c6                	mov    %eax,%esi
  80331d:	e9 71 ff ff ff       	jmp    803293 <__umoddi3+0xb3>
  803322:	66 90                	xchg   %ax,%ax
  803324:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803328:	72 ea                	jb     803314 <__umoddi3+0x134>
  80332a:	89 d9                	mov    %ebx,%ecx
  80332c:	e9 62 ff ff ff       	jmp    803293 <__umoddi3+0xb3>
