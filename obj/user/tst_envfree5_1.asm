
obj/user/tst_envfree5_1:     file format elf32-i386


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
  800031:	e8 10 01 00 00       	call   800146 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	// Testing removing the shared variables
	// Testing scenario 5_1: Kill ONE program has shared variables and it free it
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 a0 32 80 00       	push   $0x8032a0
  80004a:	e8 01 16 00 00       	call   801650 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 10 19 00 00       	call   801973 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 a8 19 00 00       	call   801a13 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 b0 32 80 00       	push   $0x8032b0
  800079:	e8 b8 04 00 00       	call   800536 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 e3 32 80 00       	push   $0x8032e3
  800099:	e8 47 1b 00 00       	call   801be5 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a4:	83 ec 0c             	sub    $0xc,%esp
  8000a7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000aa:	e8 54 1b 00 00       	call   801c03 <sys_run_env>
  8000af:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000b2:	90                   	nop
  8000b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b6:	8b 00                	mov    (%eax),%eax
  8000b8:	83 f8 01             	cmp    $0x1,%eax
  8000bb:	75 f6                	jne    8000b3 <_main+0x7b>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000bd:	e8 b1 18 00 00       	call   801973 <sys_calculate_free_frames>
  8000c2:	83 ec 08             	sub    $0x8,%esp
  8000c5:	50                   	push   %eax
  8000c6:	68 ec 32 80 00       	push   $0x8032ec
  8000cb:	e8 66 04 00 00       	call   800536 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d3:	83 ec 0c             	sub    $0xc,%esp
  8000d6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d9:	e8 41 1b 00 00       	call   801c1f <sys_destroy_env>
  8000de:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000e1:	e8 8d 18 00 00       	call   801973 <sys_calculate_free_frames>
  8000e6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e9:	e8 25 19 00 00       	call   801a13 <sys_pf_calculate_allocated_pages>
  8000ee:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f7:	74 27                	je     800120 <_main+0xe8>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n", freeFrames_after);
  8000f9:	83 ec 08             	sub    $0x8,%esp
  8000fc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000ff:	68 20 33 80 00       	push   $0x803320
  800104:	e8 2d 04 00 00       	call   800536 <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp
		panic("env_free() does not work correctly... check it again.");
  80010c:	83 ec 04             	sub    $0x4,%esp
  80010f:	68 70 33 80 00       	push   $0x803370
  800114:	6a 1e                	push   $0x1e
  800116:	68 a6 33 80 00       	push   $0x8033a6
  80011b:	e8 62 01 00 00       	call   800282 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  800120:	83 ec 08             	sub    $0x8,%esp
  800123:	ff 75 e4             	pushl  -0x1c(%ebp)
  800126:	68 bc 33 80 00       	push   $0x8033bc
  80012b:	e8 06 04 00 00       	call   800536 <cprintf>
  800130:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_1 for envfree completed successfully.\n");
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	68 1c 34 80 00       	push   $0x80341c
  80013b:	e8 f6 03 00 00       	call   800536 <cprintf>
  800140:	83 c4 10             	add    $0x10,%esp
	return;
  800143:	90                   	nop
}
  800144:	c9                   	leave  
  800145:	c3                   	ret    

00800146 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80014c:	e8 02 1b 00 00       	call   801c53 <sys_getenvindex>
  800151:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800157:	89 d0                	mov    %edx,%eax
  800159:	c1 e0 03             	shl    $0x3,%eax
  80015c:	01 d0                	add    %edx,%eax
  80015e:	01 c0                	add    %eax,%eax
  800160:	01 d0                	add    %edx,%eax
  800162:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800169:	01 d0                	add    %edx,%eax
  80016b:	c1 e0 04             	shl    $0x4,%eax
  80016e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800173:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800178:	a1 20 40 80 00       	mov    0x804020,%eax
  80017d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800183:	84 c0                	test   %al,%al
  800185:	74 0f                	je     800196 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800187:	a1 20 40 80 00       	mov    0x804020,%eax
  80018c:	05 5c 05 00 00       	add    $0x55c,%eax
  800191:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800196:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80019a:	7e 0a                	jle    8001a6 <libmain+0x60>
		binaryname = argv[0];
  80019c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001a6:	83 ec 08             	sub    $0x8,%esp
  8001a9:	ff 75 0c             	pushl  0xc(%ebp)
  8001ac:	ff 75 08             	pushl  0x8(%ebp)
  8001af:	e8 84 fe ff ff       	call   800038 <_main>
  8001b4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b7:	e8 a4 18 00 00       	call   801a60 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001bc:	83 ec 0c             	sub    $0xc,%esp
  8001bf:	68 80 34 80 00       	push   $0x803480
  8001c4:	e8 6d 03 00 00       	call   800536 <cprintf>
  8001c9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001e2:	83 ec 04             	sub    $0x4,%esp
  8001e5:	52                   	push   %edx
  8001e6:	50                   	push   %eax
  8001e7:	68 a8 34 80 00       	push   $0x8034a8
  8001ec:	e8 45 03 00 00       	call   800536 <cprintf>
  8001f1:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f9:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80020a:	a1 20 40 80 00       	mov    0x804020,%eax
  80020f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800215:	51                   	push   %ecx
  800216:	52                   	push   %edx
  800217:	50                   	push   %eax
  800218:	68 d0 34 80 00       	push   $0x8034d0
  80021d:	e8 14 03 00 00       	call   800536 <cprintf>
  800222:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800230:	83 ec 08             	sub    $0x8,%esp
  800233:	50                   	push   %eax
  800234:	68 28 35 80 00       	push   $0x803528
  800239:	e8 f8 02 00 00       	call   800536 <cprintf>
  80023e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800241:	83 ec 0c             	sub    $0xc,%esp
  800244:	68 80 34 80 00       	push   $0x803480
  800249:	e8 e8 02 00 00       	call   800536 <cprintf>
  80024e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800251:	e8 24 18 00 00       	call   801a7a <sys_enable_interrupt>

	// exit gracefully
	exit();
  800256:	e8 19 00 00 00       	call   800274 <exit>
}
  80025b:	90                   	nop
  80025c:	c9                   	leave  
  80025d:	c3                   	ret    

0080025e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025e:	55                   	push   %ebp
  80025f:	89 e5                	mov    %esp,%ebp
  800261:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800264:	83 ec 0c             	sub    $0xc,%esp
  800267:	6a 00                	push   $0x0
  800269:	e8 b1 19 00 00       	call   801c1f <sys_destroy_env>
  80026e:	83 c4 10             	add    $0x10,%esp
}
  800271:	90                   	nop
  800272:	c9                   	leave  
  800273:	c3                   	ret    

00800274 <exit>:

void
exit(void)
{
  800274:	55                   	push   %ebp
  800275:	89 e5                	mov    %esp,%ebp
  800277:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80027a:	e8 06 1a 00 00       	call   801c85 <sys_exit_env>
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800288:	8d 45 10             	lea    0x10(%ebp),%eax
  80028b:	83 c0 04             	add    $0x4,%eax
  80028e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800291:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800296:	85 c0                	test   %eax,%eax
  800298:	74 16                	je     8002b0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80029a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80029f:	83 ec 08             	sub    $0x8,%esp
  8002a2:	50                   	push   %eax
  8002a3:	68 3c 35 80 00       	push   $0x80353c
  8002a8:	e8 89 02 00 00       	call   800536 <cprintf>
  8002ad:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002b0:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b5:	ff 75 0c             	pushl  0xc(%ebp)
  8002b8:	ff 75 08             	pushl  0x8(%ebp)
  8002bb:	50                   	push   %eax
  8002bc:	68 41 35 80 00       	push   $0x803541
  8002c1:	e8 70 02 00 00       	call   800536 <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8002cc:	83 ec 08             	sub    $0x8,%esp
  8002cf:	ff 75 f4             	pushl  -0xc(%ebp)
  8002d2:	50                   	push   %eax
  8002d3:	e8 f3 01 00 00       	call   8004cb <vcprintf>
  8002d8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002db:	83 ec 08             	sub    $0x8,%esp
  8002de:	6a 00                	push   $0x0
  8002e0:	68 5d 35 80 00       	push   $0x80355d
  8002e5:	e8 e1 01 00 00       	call   8004cb <vcprintf>
  8002ea:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ed:	e8 82 ff ff ff       	call   800274 <exit>

	// should not return here
	while (1) ;
  8002f2:	eb fe                	jmp    8002f2 <_panic+0x70>

008002f4 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f4:	55                   	push   %ebp
  8002f5:	89 e5                	mov    %esp,%ebp
  8002f7:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ff:	8b 50 74             	mov    0x74(%eax),%edx
  800302:	8b 45 0c             	mov    0xc(%ebp),%eax
  800305:	39 c2                	cmp    %eax,%edx
  800307:	74 14                	je     80031d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 60 35 80 00       	push   $0x803560
  800311:	6a 26                	push   $0x26
  800313:	68 ac 35 80 00       	push   $0x8035ac
  800318:	e8 65 ff ff ff       	call   800282 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800324:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80032b:	e9 c2 00 00 00       	jmp    8003f2 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800330:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800333:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80033a:	8b 45 08             	mov    0x8(%ebp),%eax
  80033d:	01 d0                	add    %edx,%eax
  80033f:	8b 00                	mov    (%eax),%eax
  800341:	85 c0                	test   %eax,%eax
  800343:	75 08                	jne    80034d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800345:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800348:	e9 a2 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80034d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800354:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80035b:	eb 69                	jmp    8003c6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035d:	a1 20 40 80 00       	mov    0x804020,%eax
  800362:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800368:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80036b:	89 d0                	mov    %edx,%eax
  80036d:	01 c0                	add    %eax,%eax
  80036f:	01 d0                	add    %edx,%eax
  800371:	c1 e0 03             	shl    $0x3,%eax
  800374:	01 c8                	add    %ecx,%eax
  800376:	8a 40 04             	mov    0x4(%eax),%al
  800379:	84 c0                	test   %al,%al
  80037b:	75 46                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037d:	a1 20 40 80 00       	mov    0x804020,%eax
  800382:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800388:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80038b:	89 d0                	mov    %edx,%eax
  80038d:	01 c0                	add    %eax,%eax
  80038f:	01 d0                	add    %edx,%eax
  800391:	c1 e0 03             	shl    $0x3,%eax
  800394:	01 c8                	add    %ecx,%eax
  800396:	8b 00                	mov    (%eax),%eax
  800398:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80039b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003af:	8b 45 08             	mov    0x8(%ebp),%eax
  8003b2:	01 c8                	add    %ecx,%eax
  8003b4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b6:	39 c2                	cmp    %eax,%edx
  8003b8:	75 09                	jne    8003c3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ba:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003c1:	eb 12                	jmp    8003d5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c3:	ff 45 e8             	incl   -0x18(%ebp)
  8003c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8003cb:	8b 50 74             	mov    0x74(%eax),%edx
  8003ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003d1:	39 c2                	cmp    %eax,%edx
  8003d3:	77 88                	ja     80035d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d9:	75 14                	jne    8003ef <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003db:	83 ec 04             	sub    $0x4,%esp
  8003de:	68 b8 35 80 00       	push   $0x8035b8
  8003e3:	6a 3a                	push   $0x3a
  8003e5:	68 ac 35 80 00       	push   $0x8035ac
  8003ea:	e8 93 fe ff ff       	call   800282 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ef:	ff 45 f0             	incl   -0x10(%ebp)
  8003f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f8:	0f 8c 32 ff ff ff    	jl     800330 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fe:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800405:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80040c:	eb 26                	jmp    800434 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040e:	a1 20 40 80 00       	mov    0x804020,%eax
  800413:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800419:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80041c:	89 d0                	mov    %edx,%eax
  80041e:	01 c0                	add    %eax,%eax
  800420:	01 d0                	add    %edx,%eax
  800422:	c1 e0 03             	shl    $0x3,%eax
  800425:	01 c8                	add    %ecx,%eax
  800427:	8a 40 04             	mov    0x4(%eax),%al
  80042a:	3c 01                	cmp    $0x1,%al
  80042c:	75 03                	jne    800431 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800431:	ff 45 e0             	incl   -0x20(%ebp)
  800434:	a1 20 40 80 00       	mov    0x804020,%eax
  800439:	8b 50 74             	mov    0x74(%eax),%edx
  80043c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043f:	39 c2                	cmp    %eax,%edx
  800441:	77 cb                	ja     80040e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800443:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800446:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800449:	74 14                	je     80045f <CheckWSWithoutLastIndex+0x16b>
		panic(
  80044b:	83 ec 04             	sub    $0x4,%esp
  80044e:	68 0c 36 80 00       	push   $0x80360c
  800453:	6a 44                	push   $0x44
  800455:	68 ac 35 80 00       	push   $0x8035ac
  80045a:	e8 23 fe ff ff       	call   800282 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045f:	90                   	nop
  800460:	c9                   	leave  
  800461:	c3                   	ret    

00800462 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800462:	55                   	push   %ebp
  800463:	89 e5                	mov    %esp,%ebp
  800465:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046b:	8b 00                	mov    (%eax),%eax
  80046d:	8d 48 01             	lea    0x1(%eax),%ecx
  800470:	8b 55 0c             	mov    0xc(%ebp),%edx
  800473:	89 0a                	mov    %ecx,(%edx)
  800475:	8b 55 08             	mov    0x8(%ebp),%edx
  800478:	88 d1                	mov    %dl,%cl
  80047a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800481:	8b 45 0c             	mov    0xc(%ebp),%eax
  800484:	8b 00                	mov    (%eax),%eax
  800486:	3d ff 00 00 00       	cmp    $0xff,%eax
  80048b:	75 2c                	jne    8004b9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048d:	a0 24 40 80 00       	mov    0x804024,%al
  800492:	0f b6 c0             	movzbl %al,%eax
  800495:	8b 55 0c             	mov    0xc(%ebp),%edx
  800498:	8b 12                	mov    (%edx),%edx
  80049a:	89 d1                	mov    %edx,%ecx
  80049c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049f:	83 c2 08             	add    $0x8,%edx
  8004a2:	83 ec 04             	sub    $0x4,%esp
  8004a5:	50                   	push   %eax
  8004a6:	51                   	push   %ecx
  8004a7:	52                   	push   %edx
  8004a8:	e8 05 14 00 00       	call   8018b2 <sys_cputs>
  8004ad:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bc:	8b 40 04             	mov    0x4(%eax),%eax
  8004bf:	8d 50 01             	lea    0x1(%eax),%edx
  8004c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c5:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c8:	90                   	nop
  8004c9:	c9                   	leave  
  8004ca:	c3                   	ret    

008004cb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004cb:	55                   	push   %ebp
  8004cc:	89 e5                	mov    %esp,%ebp
  8004ce:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004db:	00 00 00 
	b.cnt = 0;
  8004de:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e5:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e8:	ff 75 0c             	pushl  0xc(%ebp)
  8004eb:	ff 75 08             	pushl  0x8(%ebp)
  8004ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f4:	50                   	push   %eax
  8004f5:	68 62 04 80 00       	push   $0x800462
  8004fa:	e8 11 02 00 00       	call   800710 <vprintfmt>
  8004ff:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800502:	a0 24 40 80 00       	mov    0x804024,%al
  800507:	0f b6 c0             	movzbl %al,%eax
  80050a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800510:	83 ec 04             	sub    $0x4,%esp
  800513:	50                   	push   %eax
  800514:	52                   	push   %edx
  800515:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80051b:	83 c0 08             	add    $0x8,%eax
  80051e:	50                   	push   %eax
  80051f:	e8 8e 13 00 00       	call   8018b2 <sys_cputs>
  800524:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800527:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80052e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800534:	c9                   	leave  
  800535:	c3                   	ret    

00800536 <cprintf>:

int cprintf(const char *fmt, ...) {
  800536:	55                   	push   %ebp
  800537:	89 e5                	mov    %esp,%ebp
  800539:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80053c:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800543:	8d 45 0c             	lea    0xc(%ebp),%eax
  800546:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	83 ec 08             	sub    $0x8,%esp
  80054f:	ff 75 f4             	pushl  -0xc(%ebp)
  800552:	50                   	push   %eax
  800553:	e8 73 ff ff ff       	call   8004cb <vcprintf>
  800558:	83 c4 10             	add    $0x10,%esp
  80055b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800561:	c9                   	leave  
  800562:	c3                   	ret    

00800563 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800563:	55                   	push   %ebp
  800564:	89 e5                	mov    %esp,%ebp
  800566:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800569:	e8 f2 14 00 00       	call   801a60 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800571:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	ff 75 f4             	pushl  -0xc(%ebp)
  80057d:	50                   	push   %eax
  80057e:	e8 48 ff ff ff       	call   8004cb <vcprintf>
  800583:	83 c4 10             	add    $0x10,%esp
  800586:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800589:	e8 ec 14 00 00       	call   801a7a <sys_enable_interrupt>
	return cnt;
  80058e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800591:	c9                   	leave  
  800592:	c3                   	ret    

00800593 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800593:	55                   	push   %ebp
  800594:	89 e5                	mov    %esp,%ebp
  800596:	53                   	push   %ebx
  800597:	83 ec 14             	sub    $0x14,%esp
  80059a:	8b 45 10             	mov    0x10(%ebp),%eax
  80059d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005a0:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a6:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a9:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ae:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b1:	77 55                	ja     800608 <printnum+0x75>
  8005b3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b6:	72 05                	jb     8005bd <printnum+0x2a>
  8005b8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005bb:	77 4b                	ja     800608 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005bd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005c0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005cb:	52                   	push   %edx
  8005cc:	50                   	push   %eax
  8005cd:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d0:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d3:	e8 64 2a 00 00       	call   80303c <__udivdi3>
  8005d8:	83 c4 10             	add    $0x10,%esp
  8005db:	83 ec 04             	sub    $0x4,%esp
  8005de:	ff 75 20             	pushl  0x20(%ebp)
  8005e1:	53                   	push   %ebx
  8005e2:	ff 75 18             	pushl  0x18(%ebp)
  8005e5:	52                   	push   %edx
  8005e6:	50                   	push   %eax
  8005e7:	ff 75 0c             	pushl  0xc(%ebp)
  8005ea:	ff 75 08             	pushl  0x8(%ebp)
  8005ed:	e8 a1 ff ff ff       	call   800593 <printnum>
  8005f2:	83 c4 20             	add    $0x20,%esp
  8005f5:	eb 1a                	jmp    800611 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f7:	83 ec 08             	sub    $0x8,%esp
  8005fa:	ff 75 0c             	pushl  0xc(%ebp)
  8005fd:	ff 75 20             	pushl  0x20(%ebp)
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	ff d0                	call   *%eax
  800605:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800608:	ff 4d 1c             	decl   0x1c(%ebp)
  80060b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060f:	7f e6                	jg     8005f7 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800611:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800614:	bb 00 00 00 00       	mov    $0x0,%ebx
  800619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80061c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061f:	53                   	push   %ebx
  800620:	51                   	push   %ecx
  800621:	52                   	push   %edx
  800622:	50                   	push   %eax
  800623:	e8 24 2b 00 00       	call   80314c <__umoddi3>
  800628:	83 c4 10             	add    $0x10,%esp
  80062b:	05 74 38 80 00       	add    $0x803874,%eax
  800630:	8a 00                	mov    (%eax),%al
  800632:	0f be c0             	movsbl %al,%eax
  800635:	83 ec 08             	sub    $0x8,%esp
  800638:	ff 75 0c             	pushl  0xc(%ebp)
  80063b:	50                   	push   %eax
  80063c:	8b 45 08             	mov    0x8(%ebp),%eax
  80063f:	ff d0                	call   *%eax
  800641:	83 c4 10             	add    $0x10,%esp
}
  800644:	90                   	nop
  800645:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800648:	c9                   	leave  
  800649:	c3                   	ret    

0080064a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80064a:	55                   	push   %ebp
  80064b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800651:	7e 1c                	jle    80066f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800653:	8b 45 08             	mov    0x8(%ebp),%eax
  800656:	8b 00                	mov    (%eax),%eax
  800658:	8d 50 08             	lea    0x8(%eax),%edx
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	89 10                	mov    %edx,(%eax)
  800660:	8b 45 08             	mov    0x8(%ebp),%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	83 e8 08             	sub    $0x8,%eax
  800668:	8b 50 04             	mov    0x4(%eax),%edx
  80066b:	8b 00                	mov    (%eax),%eax
  80066d:	eb 40                	jmp    8006af <getuint+0x65>
	else if (lflag)
  80066f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800673:	74 1e                	je     800693 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800675:	8b 45 08             	mov    0x8(%ebp),%eax
  800678:	8b 00                	mov    (%eax),%eax
  80067a:	8d 50 04             	lea    0x4(%eax),%edx
  80067d:	8b 45 08             	mov    0x8(%ebp),%eax
  800680:	89 10                	mov    %edx,(%eax)
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	83 e8 04             	sub    $0x4,%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	ba 00 00 00 00       	mov    $0x0,%edx
  800691:	eb 1c                	jmp    8006af <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 50 04             	lea    0x4(%eax),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 10                	mov    %edx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 e8 04             	sub    $0x4,%eax
  8006a8:	8b 00                	mov    (%eax),%eax
  8006aa:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006af:	5d                   	pop    %ebp
  8006b0:	c3                   	ret    

008006b1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getint+0x25>
		return va_arg(*ap, long long);
  8006ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bd:	8b 00                	mov    (%eax),%eax
  8006bf:	8d 50 08             	lea    0x8(%eax),%edx
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	89 10                	mov    %edx,(%eax)
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	83 e8 08             	sub    $0x8,%eax
  8006cf:	8b 50 04             	mov    0x4(%eax),%edx
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	eb 38                	jmp    80070e <getint+0x5d>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1a                	je     8006f6 <getint+0x45>
		return va_arg(*ap, long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	99                   	cltd   
  8006f4:	eb 18                	jmp    80070e <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	8b 00                	mov    (%eax),%eax
  8006fb:	8d 50 04             	lea    0x4(%eax),%edx
  8006fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800701:	89 10                	mov    %edx,(%eax)
  800703:	8b 45 08             	mov    0x8(%ebp),%eax
  800706:	8b 00                	mov    (%eax),%eax
  800708:	83 e8 04             	sub    $0x4,%eax
  80070b:	8b 00                	mov    (%eax),%eax
  80070d:	99                   	cltd   
}
  80070e:	5d                   	pop    %ebp
  80070f:	c3                   	ret    

00800710 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	56                   	push   %esi
  800714:	53                   	push   %ebx
  800715:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800718:	eb 17                	jmp    800731 <vprintfmt+0x21>
			if (ch == '\0')
  80071a:	85 db                	test   %ebx,%ebx
  80071c:	0f 84 af 03 00 00    	je     800ad1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800722:	83 ec 08             	sub    $0x8,%esp
  800725:	ff 75 0c             	pushl  0xc(%ebp)
  800728:	53                   	push   %ebx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	ff d0                	call   *%eax
  80072e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800731:	8b 45 10             	mov    0x10(%ebp),%eax
  800734:	8d 50 01             	lea    0x1(%eax),%edx
  800737:	89 55 10             	mov    %edx,0x10(%ebp)
  80073a:	8a 00                	mov    (%eax),%al
  80073c:	0f b6 d8             	movzbl %al,%ebx
  80073f:	83 fb 25             	cmp    $0x25,%ebx
  800742:	75 d6                	jne    80071a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800744:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800748:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800756:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800764:	8b 45 10             	mov    0x10(%ebp),%eax
  800767:	8d 50 01             	lea    0x1(%eax),%edx
  80076a:	89 55 10             	mov    %edx,0x10(%ebp)
  80076d:	8a 00                	mov    (%eax),%al
  80076f:	0f b6 d8             	movzbl %al,%ebx
  800772:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800775:	83 f8 55             	cmp    $0x55,%eax
  800778:	0f 87 2b 03 00 00    	ja     800aa9 <vprintfmt+0x399>
  80077e:	8b 04 85 98 38 80 00 	mov    0x803898(,%eax,4),%eax
  800785:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800787:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80078b:	eb d7                	jmp    800764 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078d:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800791:	eb d1                	jmp    800764 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800793:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80079a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079d:	89 d0                	mov    %edx,%eax
  80079f:	c1 e0 02             	shl    $0x2,%eax
  8007a2:	01 d0                	add    %edx,%eax
  8007a4:	01 c0                	add    %eax,%eax
  8007a6:	01 d8                	add    %ebx,%eax
  8007a8:	83 e8 30             	sub    $0x30,%eax
  8007ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b1:	8a 00                	mov    (%eax),%al
  8007b3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b6:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b9:	7e 3e                	jle    8007f9 <vprintfmt+0xe9>
  8007bb:	83 fb 39             	cmp    $0x39,%ebx
  8007be:	7f 39                	jg     8007f9 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c3:	eb d5                	jmp    80079a <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c5:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c8:	83 c0 04             	add    $0x4,%eax
  8007cb:	89 45 14             	mov    %eax,0x14(%ebp)
  8007ce:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d1:	83 e8 04             	sub    $0x4,%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d9:	eb 1f                	jmp    8007fa <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007db:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007df:	79 83                	jns    800764 <vprintfmt+0x54>
				width = 0;
  8007e1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e8:	e9 77 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ed:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f4:	e9 6b ff ff ff       	jmp    800764 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f9:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007fa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fe:	0f 89 60 ff ff ff    	jns    800764 <vprintfmt+0x54>
				width = precision, precision = -1;
  800804:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800807:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80080a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800811:	e9 4e ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800816:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800819:	e9 46 ff ff ff       	jmp    800764 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081e:	8b 45 14             	mov    0x14(%ebp),%eax
  800821:	83 c0 04             	add    $0x4,%eax
  800824:	89 45 14             	mov    %eax,0x14(%ebp)
  800827:	8b 45 14             	mov    0x14(%ebp),%eax
  80082a:	83 e8 04             	sub    $0x4,%eax
  80082d:	8b 00                	mov    (%eax),%eax
  80082f:	83 ec 08             	sub    $0x8,%esp
  800832:	ff 75 0c             	pushl  0xc(%ebp)
  800835:	50                   	push   %eax
  800836:	8b 45 08             	mov    0x8(%ebp),%eax
  800839:	ff d0                	call   *%eax
  80083b:	83 c4 10             	add    $0x10,%esp
			break;
  80083e:	e9 89 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800843:	8b 45 14             	mov    0x14(%ebp),%eax
  800846:	83 c0 04             	add    $0x4,%eax
  800849:	89 45 14             	mov    %eax,0x14(%ebp)
  80084c:	8b 45 14             	mov    0x14(%ebp),%eax
  80084f:	83 e8 04             	sub    $0x4,%eax
  800852:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800854:	85 db                	test   %ebx,%ebx
  800856:	79 02                	jns    80085a <vprintfmt+0x14a>
				err = -err;
  800858:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80085a:	83 fb 64             	cmp    $0x64,%ebx
  80085d:	7f 0b                	jg     80086a <vprintfmt+0x15a>
  80085f:	8b 34 9d e0 36 80 00 	mov    0x8036e0(,%ebx,4),%esi
  800866:	85 f6                	test   %esi,%esi
  800868:	75 19                	jne    800883 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80086a:	53                   	push   %ebx
  80086b:	68 85 38 80 00       	push   $0x803885
  800870:	ff 75 0c             	pushl  0xc(%ebp)
  800873:	ff 75 08             	pushl  0x8(%ebp)
  800876:	e8 5e 02 00 00       	call   800ad9 <printfmt>
  80087b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087e:	e9 49 02 00 00       	jmp    800acc <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800883:	56                   	push   %esi
  800884:	68 8e 38 80 00       	push   $0x80388e
  800889:	ff 75 0c             	pushl  0xc(%ebp)
  80088c:	ff 75 08             	pushl  0x8(%ebp)
  80088f:	e8 45 02 00 00       	call   800ad9 <printfmt>
  800894:	83 c4 10             	add    $0x10,%esp
			break;
  800897:	e9 30 02 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80089c:	8b 45 14             	mov    0x14(%ebp),%eax
  80089f:	83 c0 04             	add    $0x4,%eax
  8008a2:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a5:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a8:	83 e8 04             	sub    $0x4,%eax
  8008ab:	8b 30                	mov    (%eax),%esi
  8008ad:	85 f6                	test   %esi,%esi
  8008af:	75 05                	jne    8008b6 <vprintfmt+0x1a6>
				p = "(null)";
  8008b1:	be 91 38 80 00       	mov    $0x803891,%esi
			if (width > 0 && padc != '-')
  8008b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ba:	7e 6d                	jle    800929 <vprintfmt+0x219>
  8008bc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008c0:	74 67                	je     800929 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c5:	83 ec 08             	sub    $0x8,%esp
  8008c8:	50                   	push   %eax
  8008c9:	56                   	push   %esi
  8008ca:	e8 0c 03 00 00       	call   800bdb <strnlen>
  8008cf:	83 c4 10             	add    $0x10,%esp
  8008d2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d5:	eb 16                	jmp    8008ed <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 0c             	pushl  0xc(%ebp)
  8008e1:	50                   	push   %eax
  8008e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e5:	ff d0                	call   *%eax
  8008e7:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008ea:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f1:	7f e4                	jg     8008d7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f3:	eb 34                	jmp    800929 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f5:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f9:	74 1c                	je     800917 <vprintfmt+0x207>
  8008fb:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fe:	7e 05                	jle    800905 <vprintfmt+0x1f5>
  800900:	83 fb 7e             	cmp    $0x7e,%ebx
  800903:	7e 12                	jle    800917 <vprintfmt+0x207>
					putch('?', putdat);
  800905:	83 ec 08             	sub    $0x8,%esp
  800908:	ff 75 0c             	pushl  0xc(%ebp)
  80090b:	6a 3f                	push   $0x3f
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
  800915:	eb 0f                	jmp    800926 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	53                   	push   %ebx
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800926:	ff 4d e4             	decl   -0x1c(%ebp)
  800929:	89 f0                	mov    %esi,%eax
  80092b:	8d 70 01             	lea    0x1(%eax),%esi
  80092e:	8a 00                	mov    (%eax),%al
  800930:	0f be d8             	movsbl %al,%ebx
  800933:	85 db                	test   %ebx,%ebx
  800935:	74 24                	je     80095b <vprintfmt+0x24b>
  800937:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80093b:	78 b8                	js     8008f5 <vprintfmt+0x1e5>
  80093d:	ff 4d e0             	decl   -0x20(%ebp)
  800940:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800944:	79 af                	jns    8008f5 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800946:	eb 13                	jmp    80095b <vprintfmt+0x24b>
				putch(' ', putdat);
  800948:	83 ec 08             	sub    $0x8,%esp
  80094b:	ff 75 0c             	pushl  0xc(%ebp)
  80094e:	6a 20                	push   $0x20
  800950:	8b 45 08             	mov    0x8(%ebp),%eax
  800953:	ff d0                	call   *%eax
  800955:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800958:	ff 4d e4             	decl   -0x1c(%ebp)
  80095b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095f:	7f e7                	jg     800948 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800961:	e9 66 01 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 e8             	pushl  -0x18(%ebp)
  80096c:	8d 45 14             	lea    0x14(%ebp),%eax
  80096f:	50                   	push   %eax
  800970:	e8 3c fd ff ff       	call   8006b1 <getint>
  800975:	83 c4 10             	add    $0x10,%esp
  800978:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80097b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800981:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800984:	85 d2                	test   %edx,%edx
  800986:	79 23                	jns    8009ab <vprintfmt+0x29b>
				putch('-', putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	6a 2d                	push   $0x2d
  800990:	8b 45 08             	mov    0x8(%ebp),%eax
  800993:	ff d0                	call   *%eax
  800995:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80099b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099e:	f7 d8                	neg    %eax
  8009a0:	83 d2 00             	adc    $0x0,%edx
  8009a3:	f7 da                	neg    %edx
  8009a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009ab:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009b2:	e9 bc 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b7:	83 ec 08             	sub    $0x8,%esp
  8009ba:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bd:	8d 45 14             	lea    0x14(%ebp),%eax
  8009c0:	50                   	push   %eax
  8009c1:	e8 84 fc ff ff       	call   80064a <getuint>
  8009c6:	83 c4 10             	add    $0x10,%esp
  8009c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d6:	e9 98 00 00 00       	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009db:	83 ec 08             	sub    $0x8,%esp
  8009de:	ff 75 0c             	pushl  0xc(%ebp)
  8009e1:	6a 58                	push   $0x58
  8009e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e6:	ff d0                	call   *%eax
  8009e8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 0c             	pushl  0xc(%ebp)
  8009f1:	6a 58                	push   $0x58
  8009f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f6:	ff d0                	call   *%eax
  8009f8:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 58                	push   $0x58
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			break;
  800a0b:	e9 bc 00 00 00       	jmp    800acc <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a10:	83 ec 08             	sub    $0x8,%esp
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	6a 30                	push   $0x30
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	ff d0                	call   *%eax
  800a1d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	6a 78                	push   $0x78
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	ff d0                	call   *%eax
  800a2d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a30:	8b 45 14             	mov    0x14(%ebp),%eax
  800a33:	83 c0 04             	add    $0x4,%eax
  800a36:	89 45 14             	mov    %eax,0x14(%ebp)
  800a39:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3c:	83 e8 04             	sub    $0x4,%eax
  800a3f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a4b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a52:	eb 1f                	jmp    800a73 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 e8             	pushl  -0x18(%ebp)
  800a5a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5d:	50                   	push   %eax
  800a5e:	e8 e7 fb ff ff       	call   80064a <getuint>
  800a63:	83 c4 10             	add    $0x10,%esp
  800a66:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a69:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a6c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a73:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a77:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a7a:	83 ec 04             	sub    $0x4,%esp
  800a7d:	52                   	push   %edx
  800a7e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a81:	50                   	push   %eax
  800a82:	ff 75 f4             	pushl  -0xc(%ebp)
  800a85:	ff 75 f0             	pushl  -0x10(%ebp)
  800a88:	ff 75 0c             	pushl  0xc(%ebp)
  800a8b:	ff 75 08             	pushl  0x8(%ebp)
  800a8e:	e8 00 fb ff ff       	call   800593 <printnum>
  800a93:	83 c4 20             	add    $0x20,%esp
			break;
  800a96:	eb 34                	jmp    800acc <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	53                   	push   %ebx
  800a9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa2:	ff d0                	call   *%eax
  800aa4:	83 c4 10             	add    $0x10,%esp
			break;
  800aa7:	eb 23                	jmp    800acc <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa9:	83 ec 08             	sub    $0x8,%esp
  800aac:	ff 75 0c             	pushl  0xc(%ebp)
  800aaf:	6a 25                	push   $0x25
  800ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab4:	ff d0                	call   *%eax
  800ab6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab9:	ff 4d 10             	decl   0x10(%ebp)
  800abc:	eb 03                	jmp    800ac1 <vprintfmt+0x3b1>
  800abe:	ff 4d 10             	decl   0x10(%ebp)
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	48                   	dec    %eax
  800ac5:	8a 00                	mov    (%eax),%al
  800ac7:	3c 25                	cmp    $0x25,%al
  800ac9:	75 f3                	jne    800abe <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800acb:	90                   	nop
		}
	}
  800acc:	e9 47 fc ff ff       	jmp    800718 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ad1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ad2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad5:	5b                   	pop    %ebx
  800ad6:	5e                   	pop    %esi
  800ad7:	5d                   	pop    %ebp
  800ad8:	c3                   	ret    

00800ad9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
  800adc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adf:	8d 45 10             	lea    0x10(%ebp),%eax
  800ae2:	83 c0 04             	add    $0x4,%eax
  800ae5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  800aeb:	ff 75 f4             	pushl  -0xc(%ebp)
  800aee:	50                   	push   %eax
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 16 fc ff ff       	call   800710 <vprintfmt>
  800afa:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afd:	90                   	nop
  800afe:	c9                   	leave  
  800aff:	c3                   	ret    

00800b00 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b00:	55                   	push   %ebp
  800b01:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b06:	8b 40 08             	mov    0x8(%eax),%eax
  800b09:	8d 50 01             	lea    0x1(%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b15:	8b 10                	mov    (%eax),%edx
  800b17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1a:	8b 40 04             	mov    0x4(%eax),%eax
  800b1d:	39 c2                	cmp    %eax,%edx
  800b1f:	73 12                	jae    800b33 <sprintputch+0x33>
		*b->buf++ = ch;
  800b21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b24:	8b 00                	mov    (%eax),%eax
  800b26:	8d 48 01             	lea    0x1(%eax),%ecx
  800b29:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b2c:	89 0a                	mov    %ecx,(%edx)
  800b2e:	8b 55 08             	mov    0x8(%ebp),%edx
  800b31:	88 10                	mov    %dl,(%eax)
}
  800b33:	90                   	nop
  800b34:	5d                   	pop    %ebp
  800b35:	c3                   	ret    

00800b36 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b36:	55                   	push   %ebp
  800b37:	89 e5                	mov    %esp,%ebp
  800b39:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b45:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	01 d0                	add    %edx,%eax
  800b4d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b5b:	74 06                	je     800b63 <vsnprintf+0x2d>
  800b5d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b61:	7f 07                	jg     800b6a <vsnprintf+0x34>
		return -E_INVAL;
  800b63:	b8 03 00 00 00       	mov    $0x3,%eax
  800b68:	eb 20                	jmp    800b8a <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b6a:	ff 75 14             	pushl  0x14(%ebp)
  800b6d:	ff 75 10             	pushl  0x10(%ebp)
  800b70:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b73:	50                   	push   %eax
  800b74:	68 00 0b 80 00       	push   $0x800b00
  800b79:	e8 92 fb ff ff       	call   800710 <vprintfmt>
  800b7e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b84:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b8a:	c9                   	leave  
  800b8b:	c3                   	ret    

00800b8c <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 89 ff ff ff       	call   800b36 <vsnprintf>
  800bad:	83 c4 10             	add    $0x10,%esp
  800bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb6:	c9                   	leave  
  800bb7:	c3                   	ret    

00800bb8 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb8:	55                   	push   %ebp
  800bb9:	89 e5                	mov    %esp,%ebp
  800bbb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc5:	eb 06                	jmp    800bcd <strlen+0x15>
		n++;
  800bc7:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bca:	ff 45 08             	incl   0x8(%ebp)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 f1                	jne    800bc7 <strlen+0xf>
		n++;
	return n;
  800bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be8:	eb 09                	jmp    800bf3 <strnlen+0x18>
		n++;
  800bea:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 4d 0c             	decl   0xc(%ebp)
  800bf3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf7:	74 09                	je     800c02 <strnlen+0x27>
  800bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfc:	8a 00                	mov    (%eax),%al
  800bfe:	84 c0                	test   %al,%al
  800c00:	75 e8                	jne    800bea <strnlen+0xf>
		n++;
	return n;
  800c02:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c13:	90                   	nop
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c20:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c23:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c26:	8a 12                	mov    (%edx),%dl
  800c28:	88 10                	mov    %dl,(%eax)
  800c2a:	8a 00                	mov    (%eax),%al
  800c2c:	84 c0                	test   %al,%al
  800c2e:	75 e4                	jne    800c14 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c30:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c33:	c9                   	leave  
  800c34:	c3                   	ret    

00800c35 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c35:	55                   	push   %ebp
  800c36:	89 e5                	mov    %esp,%ebp
  800c38:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c41:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c48:	eb 1f                	jmp    800c69 <strncpy+0x34>
		*dst++ = *src;
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	8d 50 01             	lea    0x1(%eax),%edx
  800c50:	89 55 08             	mov    %edx,0x8(%ebp)
  800c53:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c56:	8a 12                	mov    (%edx),%dl
  800c58:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	8a 00                	mov    (%eax),%al
  800c5f:	84 c0                	test   %al,%al
  800c61:	74 03                	je     800c66 <strncpy+0x31>
			src++;
  800c63:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c66:	ff 45 fc             	incl   -0x4(%ebp)
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6f:	72 d9                	jb     800c4a <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c71:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c74:	c9                   	leave  
  800c75:	c3                   	ret    

00800c76 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c76:	55                   	push   %ebp
  800c77:	89 e5                	mov    %esp,%ebp
  800c79:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c82:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c86:	74 30                	je     800cb8 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c88:	eb 16                	jmp    800ca0 <strlcpy+0x2a>
			*dst++ = *src++;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	8d 50 01             	lea    0x1(%eax),%edx
  800c90:	89 55 08             	mov    %edx,0x8(%ebp)
  800c93:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c99:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c9c:	8a 12                	mov    (%edx),%dl
  800c9e:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ca0:	ff 4d 10             	decl   0x10(%ebp)
  800ca3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca7:	74 09                	je     800cb2 <strlcpy+0x3c>
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	75 d8                	jne    800c8a <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cb2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb5:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb8:	8b 55 08             	mov    0x8(%ebp),%edx
  800cbb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbe:	29 c2                	sub    %eax,%edx
  800cc0:	89 d0                	mov    %edx,%eax
}
  800cc2:	c9                   	leave  
  800cc3:	c3                   	ret    

00800cc4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc4:	55                   	push   %ebp
  800cc5:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc7:	eb 06                	jmp    800ccf <strcmp+0xb>
		p++, q++;
  800cc9:	ff 45 08             	incl   0x8(%ebp)
  800ccc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	8a 00                	mov    (%eax),%al
  800cd4:	84 c0                	test   %al,%al
  800cd6:	74 0e                	je     800ce6 <strcmp+0x22>
  800cd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdb:	8a 10                	mov    (%eax),%dl
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	38 c2                	cmp    %al,%dl
  800ce4:	74 e3                	je     800cc9 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 00                	mov    (%eax),%al
  800ceb:	0f b6 d0             	movzbl %al,%edx
  800cee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf1:	8a 00                	mov    (%eax),%al
  800cf3:	0f b6 c0             	movzbl %al,%eax
  800cf6:	29 c2                	sub    %eax,%edx
  800cf8:	89 d0                	mov    %edx,%eax
}
  800cfa:	5d                   	pop    %ebp
  800cfb:	c3                   	ret    

00800cfc <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cfc:	55                   	push   %ebp
  800cfd:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cff:	eb 09                	jmp    800d0a <strncmp+0xe>
		n--, p++, q++;
  800d01:	ff 4d 10             	decl   0x10(%ebp)
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 17                	je     800d27 <strncmp+0x2b>
  800d10:	8b 45 08             	mov    0x8(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	74 0e                	je     800d27 <strncmp+0x2b>
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	8a 10                	mov    (%eax),%dl
  800d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	38 c2                	cmp    %al,%dl
  800d25:	74 da                	je     800d01 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d27:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2b:	75 07                	jne    800d34 <strncmp+0x38>
		return 0;
  800d2d:	b8 00 00 00 00       	mov    $0x0,%eax
  800d32:	eb 14                	jmp    800d48 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	0f b6 d0             	movzbl %al,%edx
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	8a 00                	mov    (%eax),%al
  800d41:	0f b6 c0             	movzbl %al,%eax
  800d44:	29 c2                	sub    %eax,%edx
  800d46:	89 d0                	mov    %edx,%eax
}
  800d48:	5d                   	pop    %ebp
  800d49:	c3                   	ret    

00800d4a <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d4a:	55                   	push   %ebp
  800d4b:	89 e5                	mov    %esp,%ebp
  800d4d:	83 ec 04             	sub    $0x4,%esp
  800d50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d53:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d56:	eb 12                	jmp    800d6a <strchr+0x20>
		if (*s == c)
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8a 00                	mov    (%eax),%al
  800d5d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d60:	75 05                	jne    800d67 <strchr+0x1d>
			return (char *) s;
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	eb 11                	jmp    800d78 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d67:	ff 45 08             	incl   0x8(%ebp)
  800d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	84 c0                	test   %al,%al
  800d71:	75 e5                	jne    800d58 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d73:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d78:	c9                   	leave  
  800d79:	c3                   	ret    

00800d7a <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d7a:	55                   	push   %ebp
  800d7b:	89 e5                	mov    %esp,%ebp
  800d7d:	83 ec 04             	sub    $0x4,%esp
  800d80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d83:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d86:	eb 0d                	jmp    800d95 <strfind+0x1b>
		if (*s == c)
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d90:	74 0e                	je     800da0 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8a 00                	mov    (%eax),%al
  800d9a:	84 c0                	test   %al,%al
  800d9c:	75 ea                	jne    800d88 <strfind+0xe>
  800d9e:	eb 01                	jmp    800da1 <strfind+0x27>
		if (*s == c)
			break;
  800da0:	90                   	nop
	return (char *) s;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da4:	c9                   	leave  
  800da5:	c3                   	ret    

00800da6 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da6:	55                   	push   %ebp
  800da7:	89 e5                	mov    %esp,%ebp
  800da9:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dac:	8b 45 08             	mov    0x8(%ebp),%eax
  800daf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800db2:	8b 45 10             	mov    0x10(%ebp),%eax
  800db5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db8:	eb 0e                	jmp    800dc8 <memset+0x22>
		*p++ = c;
  800dba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dbd:	8d 50 01             	lea    0x1(%eax),%edx
  800dc0:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc6:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc8:	ff 4d f8             	decl   -0x8(%ebp)
  800dcb:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcf:	79 e9                	jns    800dba <memset+0x14>
		*p++ = c;

	return v;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd4:	c9                   	leave  
  800dd5:	c3                   	ret    

00800dd6 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd6:	55                   	push   %ebp
  800dd7:	89 e5                	mov    %esp,%ebp
  800dd9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ddc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de8:	eb 16                	jmp    800e00 <memcpy+0x2a>
		*d++ = *s++;
  800dea:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ded:	8d 50 01             	lea    0x1(%eax),%edx
  800df0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dfc:	8a 12                	mov    (%edx),%dl
  800dfe:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e00:	8b 45 10             	mov    0x10(%ebp),%eax
  800e03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e06:	89 55 10             	mov    %edx,0x10(%ebp)
  800e09:	85 c0                	test   %eax,%eax
  800e0b:	75 dd                	jne    800dea <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e10:	c9                   	leave  
  800e11:	c3                   	ret    

00800e12 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e12:	55                   	push   %ebp
  800e13:	89 e5                	mov    %esp,%ebp
  800e15:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e24:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e27:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2a:	73 50                	jae    800e7c <memmove+0x6a>
  800e2c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e32:	01 d0                	add    %edx,%eax
  800e34:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e37:	76 43                	jbe    800e7c <memmove+0x6a>
		s += n;
  800e39:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3c:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e42:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e45:	eb 10                	jmp    800e57 <memmove+0x45>
			*--d = *--s;
  800e47:	ff 4d f8             	decl   -0x8(%ebp)
  800e4a:	ff 4d fc             	decl   -0x4(%ebp)
  800e4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e50:	8a 10                	mov    (%eax),%dl
  800e52:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e55:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e57:	8b 45 10             	mov    0x10(%ebp),%eax
  800e5a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e60:	85 c0                	test   %eax,%eax
  800e62:	75 e3                	jne    800e47 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e64:	eb 23                	jmp    800e89 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e66:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e69:	8d 50 01             	lea    0x1(%eax),%edx
  800e6c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e72:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e75:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e78:	8a 12                	mov    (%edx),%dl
  800e7a:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e7c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e82:	89 55 10             	mov    %edx,0x10(%ebp)
  800e85:	85 c0                	test   %eax,%eax
  800e87:	75 dd                	jne    800e66 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e9a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ea0:	eb 2a                	jmp    800ecc <memcmp+0x3e>
		if (*s1 != *s2)
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8a 10                	mov    (%eax),%dl
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	38 c2                	cmp    %al,%dl
  800eae:	74 16                	je     800ec6 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	0f b6 d0             	movzbl %al,%edx
  800eb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebb:	8a 00                	mov    (%eax),%al
  800ebd:	0f b6 c0             	movzbl %al,%eax
  800ec0:	29 c2                	sub    %eax,%edx
  800ec2:	89 d0                	mov    %edx,%eax
  800ec4:	eb 18                	jmp    800ede <memcmp+0x50>
		s1++, s2++;
  800ec6:	ff 45 fc             	incl   -0x4(%ebp)
  800ec9:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ecc:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecf:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed5:	85 c0                	test   %eax,%eax
  800ed7:	75 c9                	jne    800ea2 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ede:	c9                   	leave  
  800edf:	c3                   	ret    

00800ee0 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ee0:	55                   	push   %ebp
  800ee1:	89 e5                	mov    %esp,%ebp
  800ee3:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee6:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee9:	8b 45 10             	mov    0x10(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ef1:	eb 15                	jmp    800f08 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 d0             	movzbl %al,%edx
  800efb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efe:	0f b6 c0             	movzbl %al,%eax
  800f01:	39 c2                	cmp    %eax,%edx
  800f03:	74 0d                	je     800f12 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f05:	ff 45 08             	incl   0x8(%ebp)
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0b:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0e:	72 e3                	jb     800ef3 <memfind+0x13>
  800f10:	eb 01                	jmp    800f13 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f12:	90                   	nop
	return (void *) s;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f16:	c9                   	leave  
  800f17:	c3                   	ret    

00800f18 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f18:	55                   	push   %ebp
  800f19:	89 e5                	mov    %esp,%ebp
  800f1b:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f25:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2c:	eb 03                	jmp    800f31 <strtol+0x19>
		s++;
  800f2e:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f31:	8b 45 08             	mov    0x8(%ebp),%eax
  800f34:	8a 00                	mov    (%eax),%al
  800f36:	3c 20                	cmp    $0x20,%al
  800f38:	74 f4                	je     800f2e <strtol+0x16>
  800f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3d:	8a 00                	mov    (%eax),%al
  800f3f:	3c 09                	cmp    $0x9,%al
  800f41:	74 eb                	je     800f2e <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 2b                	cmp    $0x2b,%al
  800f4a:	75 05                	jne    800f51 <strtol+0x39>
		s++;
  800f4c:	ff 45 08             	incl   0x8(%ebp)
  800f4f:	eb 13                	jmp    800f64 <strtol+0x4c>
	else if (*s == '-')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2d                	cmp    $0x2d,%al
  800f58:	75 0a                	jne    800f64 <strtol+0x4c>
		s++, neg = 1;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f64:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f68:	74 06                	je     800f70 <strtol+0x58>
  800f6a:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6e:	75 20                	jne    800f90 <strtol+0x78>
  800f70:	8b 45 08             	mov    0x8(%ebp),%eax
  800f73:	8a 00                	mov    (%eax),%al
  800f75:	3c 30                	cmp    $0x30,%al
  800f77:	75 17                	jne    800f90 <strtol+0x78>
  800f79:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7c:	40                   	inc    %eax
  800f7d:	8a 00                	mov    (%eax),%al
  800f7f:	3c 78                	cmp    $0x78,%al
  800f81:	75 0d                	jne    800f90 <strtol+0x78>
		s += 2, base = 16;
  800f83:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f87:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8e:	eb 28                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f94:	75 15                	jne    800fab <strtol+0x93>
  800f96:	8b 45 08             	mov    0x8(%ebp),%eax
  800f99:	8a 00                	mov    (%eax),%al
  800f9b:	3c 30                	cmp    $0x30,%al
  800f9d:	75 0c                	jne    800fab <strtol+0x93>
		s++, base = 8;
  800f9f:	ff 45 08             	incl   0x8(%ebp)
  800fa2:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa9:	eb 0d                	jmp    800fb8 <strtol+0xa0>
	else if (base == 0)
  800fab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faf:	75 07                	jne    800fb8 <strtol+0xa0>
		base = 10;
  800fb1:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2f                	cmp    $0x2f,%al
  800fbf:	7e 19                	jle    800fda <strtol+0xc2>
  800fc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc4:	8a 00                	mov    (%eax),%al
  800fc6:	3c 39                	cmp    $0x39,%al
  800fc8:	7f 10                	jg     800fda <strtol+0xc2>
			dig = *s - '0';
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	0f be c0             	movsbl %al,%eax
  800fd2:	83 e8 30             	sub    $0x30,%eax
  800fd5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd8:	eb 42                	jmp    80101c <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fda:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	3c 60                	cmp    $0x60,%al
  800fe1:	7e 19                	jle    800ffc <strtol+0xe4>
  800fe3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe6:	8a 00                	mov    (%eax),%al
  800fe8:	3c 7a                	cmp    $0x7a,%al
  800fea:	7f 10                	jg     800ffc <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	0f be c0             	movsbl %al,%eax
  800ff4:	83 e8 57             	sub    $0x57,%eax
  800ff7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ffa:	eb 20                	jmp    80101c <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 40                	cmp    $0x40,%al
  801003:	7e 39                	jle    80103e <strtol+0x126>
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	3c 5a                	cmp    $0x5a,%al
  80100c:	7f 30                	jg     80103e <strtol+0x126>
			dig = *s - 'A' + 10;
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f be c0             	movsbl %al,%eax
  801016:	83 e8 37             	sub    $0x37,%eax
  801019:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80101c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101f:	3b 45 10             	cmp    0x10(%ebp),%eax
  801022:	7d 19                	jge    80103d <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801024:	ff 45 08             	incl   0x8(%ebp)
  801027:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102a:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102e:	89 c2                	mov    %eax,%edx
  801030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801033:	01 d0                	add    %edx,%eax
  801035:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801038:	e9 7b ff ff ff       	jmp    800fb8 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103d:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801042:	74 08                	je     80104c <strtol+0x134>
		*endptr = (char *) s;
  801044:	8b 45 0c             	mov    0xc(%ebp),%eax
  801047:	8b 55 08             	mov    0x8(%ebp),%edx
  80104a:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80104c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801050:	74 07                	je     801059 <strtol+0x141>
  801052:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801055:	f7 d8                	neg    %eax
  801057:	eb 03                	jmp    80105c <strtol+0x144>
  801059:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80105c:	c9                   	leave  
  80105d:	c3                   	ret    

0080105e <ltostr>:

void
ltostr(long value, char *str)
{
  80105e:	55                   	push   %ebp
  80105f:	89 e5                	mov    %esp,%ebp
  801061:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801064:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80106b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801072:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801076:	79 13                	jns    80108b <ltostr+0x2d>
	{
		neg = 1;
  801078:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801085:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801088:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801093:	99                   	cltd   
  801094:	f7 f9                	idiv   %ecx
  801096:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801099:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109c:	8d 50 01             	lea    0x1(%eax),%edx
  80109f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a2:	89 c2                	mov    %eax,%edx
  8010a4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a7:	01 d0                	add    %edx,%eax
  8010a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ac:	83 c2 30             	add    $0x30,%edx
  8010af:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b4:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b9:	f7 e9                	imul   %ecx
  8010bb:	c1 fa 02             	sar    $0x2,%edx
  8010be:	89 c8                	mov    %ecx,%eax
  8010c0:	c1 f8 1f             	sar    $0x1f,%eax
  8010c3:	29 c2                	sub    %eax,%edx
  8010c5:	89 d0                	mov    %edx,%eax
  8010c7:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010ca:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010cd:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010d2:	f7 e9                	imul   %ecx
  8010d4:	c1 fa 02             	sar    $0x2,%edx
  8010d7:	89 c8                	mov    %ecx,%eax
  8010d9:	c1 f8 1f             	sar    $0x1f,%eax
  8010dc:	29 c2                	sub    %eax,%edx
  8010de:	89 d0                	mov    %edx,%eax
  8010e0:	c1 e0 02             	shl    $0x2,%eax
  8010e3:	01 d0                	add    %edx,%eax
  8010e5:	01 c0                	add    %eax,%eax
  8010e7:	29 c1                	sub    %eax,%ecx
  8010e9:	89 ca                	mov    %ecx,%edx
  8010eb:	85 d2                	test   %edx,%edx
  8010ed:	75 9c                	jne    80108b <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	48                   	dec    %eax
  8010fa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801101:	74 3d                	je     801140 <ltostr+0xe2>
		start = 1 ;
  801103:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80110a:	eb 34                	jmp    801140 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80110c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801112:	01 d0                	add    %edx,%eax
  801114:	8a 00                	mov    (%eax),%al
  801116:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801119:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111f:	01 c2                	add    %eax,%edx
  801121:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 c8                	add    %ecx,%eax
  801129:	8a 00                	mov    (%eax),%al
  80112b:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801130:	8b 45 0c             	mov    0xc(%ebp),%eax
  801133:	01 c2                	add    %eax,%edx
  801135:	8a 45 eb             	mov    -0x15(%ebp),%al
  801138:	88 02                	mov    %al,(%edx)
		start++ ;
  80113a:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113d:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801146:	7c c4                	jl     80110c <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801148:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80114b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801153:	90                   	nop
  801154:	c9                   	leave  
  801155:	c3                   	ret    

00801156 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801156:	55                   	push   %ebp
  801157:	89 e5                	mov    %esp,%ebp
  801159:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80115c:	ff 75 08             	pushl  0x8(%ebp)
  80115f:	e8 54 fa ff ff       	call   800bb8 <strlen>
  801164:	83 c4 04             	add    $0x4,%esp
  801167:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80116a:	ff 75 0c             	pushl  0xc(%ebp)
  80116d:	e8 46 fa ff ff       	call   800bb8 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801178:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801186:	eb 17                	jmp    80119f <strcconcat+0x49>
		final[s] = str1[s] ;
  801188:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80118b:	8b 45 10             	mov    0x10(%ebp),%eax
  80118e:	01 c2                	add    %eax,%edx
  801190:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801193:	8b 45 08             	mov    0x8(%ebp),%eax
  801196:	01 c8                	add    %ecx,%eax
  801198:	8a 00                	mov    (%eax),%al
  80119a:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80119c:	ff 45 fc             	incl   -0x4(%ebp)
  80119f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a5:	7c e1                	jl     801188 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ae:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b5:	eb 1f                	jmp    8011d6 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ba:	8d 50 01             	lea    0x1(%eax),%edx
  8011bd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011c0:	89 c2                	mov    %eax,%edx
  8011c2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c5:	01 c2                	add    %eax,%edx
  8011c7:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cd:	01 c8                	add    %ecx,%eax
  8011cf:	8a 00                	mov    (%eax),%al
  8011d1:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d3:	ff 45 f8             	incl   -0x8(%ebp)
  8011d6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011dc:	7c d9                	jl     8011b7 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011de:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	01 d0                	add    %edx,%eax
  8011e6:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e9:	90                   	nop
  8011ea:	c9                   	leave  
  8011eb:	c3                   	ret    

008011ec <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011ec:	55                   	push   %ebp
  8011ed:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011fb:	8b 00                	mov    (%eax),%eax
  8011fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801204:	8b 45 10             	mov    0x10(%ebp),%eax
  801207:	01 d0                	add    %edx,%eax
  801209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120f:	eb 0c                	jmp    80121d <strsplit+0x31>
			*string++ = 0;
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	8d 50 01             	lea    0x1(%eax),%edx
  801217:	89 55 08             	mov    %edx,0x8(%ebp)
  80121a:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	84 c0                	test   %al,%al
  801224:	74 18                	je     80123e <strsplit+0x52>
  801226:	8b 45 08             	mov    0x8(%ebp),%eax
  801229:	8a 00                	mov    (%eax),%al
  80122b:	0f be c0             	movsbl %al,%eax
  80122e:	50                   	push   %eax
  80122f:	ff 75 0c             	pushl  0xc(%ebp)
  801232:	e8 13 fb ff ff       	call   800d4a <strchr>
  801237:	83 c4 08             	add    $0x8,%esp
  80123a:	85 c0                	test   %eax,%eax
  80123c:	75 d3                	jne    801211 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	8a 00                	mov    (%eax),%al
  801243:	84 c0                	test   %al,%al
  801245:	74 5a                	je     8012a1 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	83 f8 0f             	cmp    $0xf,%eax
  80124f:	75 07                	jne    801258 <strsplit+0x6c>
		{
			return 0;
  801251:	b8 00 00 00 00       	mov    $0x0,%eax
  801256:	eb 66                	jmp    8012be <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801258:	8b 45 14             	mov    0x14(%ebp),%eax
  80125b:	8b 00                	mov    (%eax),%eax
  80125d:	8d 48 01             	lea    0x1(%eax),%ecx
  801260:	8b 55 14             	mov    0x14(%ebp),%edx
  801263:	89 0a                	mov    %ecx,(%edx)
  801265:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126c:	8b 45 10             	mov    0x10(%ebp),%eax
  80126f:	01 c2                	add    %eax,%edx
  801271:	8b 45 08             	mov    0x8(%ebp),%eax
  801274:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801276:	eb 03                	jmp    80127b <strsplit+0x8f>
			string++;
  801278:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	8a 00                	mov    (%eax),%al
  801280:	84 c0                	test   %al,%al
  801282:	74 8b                	je     80120f <strsplit+0x23>
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	0f be c0             	movsbl %al,%eax
  80128c:	50                   	push   %eax
  80128d:	ff 75 0c             	pushl  0xc(%ebp)
  801290:	e8 b5 fa ff ff       	call   800d4a <strchr>
  801295:	83 c4 08             	add    $0x8,%esp
  801298:	85 c0                	test   %eax,%eax
  80129a:	74 dc                	je     801278 <strsplit+0x8c>
			string++;
	}
  80129c:	e9 6e ff ff ff       	jmp    80120f <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012a1:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	8b 00                	mov    (%eax),%eax
  8012a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b1:	01 d0                	add    %edx,%eax
  8012b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b9:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012be:	c9                   	leave  
  8012bf:	c3                   	ret    

008012c0 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012c0:	55                   	push   %ebp
  8012c1:	89 e5                	mov    %esp,%ebp
  8012c3:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012c6:	a1 04 40 80 00       	mov    0x804004,%eax
  8012cb:	85 c0                	test   %eax,%eax
  8012cd:	74 1f                	je     8012ee <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cf:	e8 1d 00 00 00       	call   8012f1 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d4:	83 ec 0c             	sub    $0xc,%esp
  8012d7:	68 f0 39 80 00       	push   $0x8039f0
  8012dc:	e8 55 f2 ff ff       	call   800536 <cprintf>
  8012e1:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e4:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012eb:	00 00 00 
	}
}
  8012ee:	90                   	nop
  8012ef:	c9                   	leave  
  8012f0:	c3                   	ret    

008012f1 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012f1:	55                   	push   %ebp
  8012f2:	89 e5                	mov    %esp,%ebp
  8012f4:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  8012f7:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012fe:	00 00 00 
  801301:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801308:	00 00 00 
  80130b:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801312:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801315:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80131c:	00 00 00 
  80131f:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801326:	00 00 00 
  801329:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801330:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801333:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  80133a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133d:	c1 e8 0c             	shr    $0xc,%eax
  801340:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801345:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80134c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801354:	2d 00 10 00 00       	sub    $0x1000,%eax
  801359:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  80135e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801365:	a1 20 41 80 00       	mov    0x804120,%eax
  80136a:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  80136e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801371:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801378:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80137b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80137e:	01 d0                	add    %edx,%eax
  801380:	48                   	dec    %eax
  801381:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801384:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801387:	ba 00 00 00 00       	mov    $0x0,%edx
  80138c:	f7 75 e4             	divl   -0x1c(%ebp)
  80138f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801392:	29 d0                	sub    %edx,%eax
  801394:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801397:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  80139e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a6:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013ab:	83 ec 04             	sub    $0x4,%esp
  8013ae:	6a 07                	push   $0x7
  8013b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8013b3:	50                   	push   %eax
  8013b4:	e8 3d 06 00 00       	call   8019f6 <sys_allocate_chunk>
  8013b9:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013bc:	a1 20 41 80 00       	mov    0x804120,%eax
  8013c1:	83 ec 0c             	sub    $0xc,%esp
  8013c4:	50                   	push   %eax
  8013c5:	e8 b2 0c 00 00       	call   80207c <initialize_MemBlocksList>
  8013ca:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8013cd:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013d2:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8013d5:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013d9:	0f 84 f3 00 00 00    	je     8014d2 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8013df:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013e3:	75 14                	jne    8013f9 <initialize_dyn_block_system+0x108>
  8013e5:	83 ec 04             	sub    $0x4,%esp
  8013e8:	68 15 3a 80 00       	push   $0x803a15
  8013ed:	6a 36                	push   $0x36
  8013ef:	68 33 3a 80 00       	push   $0x803a33
  8013f4:	e8 89 ee ff ff       	call   800282 <_panic>
  8013f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013fc:	8b 00                	mov    (%eax),%eax
  8013fe:	85 c0                	test   %eax,%eax
  801400:	74 10                	je     801412 <initialize_dyn_block_system+0x121>
  801402:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801405:	8b 00                	mov    (%eax),%eax
  801407:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80140a:	8b 52 04             	mov    0x4(%edx),%edx
  80140d:	89 50 04             	mov    %edx,0x4(%eax)
  801410:	eb 0b                	jmp    80141d <initialize_dyn_block_system+0x12c>
  801412:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801415:	8b 40 04             	mov    0x4(%eax),%eax
  801418:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80141d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801420:	8b 40 04             	mov    0x4(%eax),%eax
  801423:	85 c0                	test   %eax,%eax
  801425:	74 0f                	je     801436 <initialize_dyn_block_system+0x145>
  801427:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80142a:	8b 40 04             	mov    0x4(%eax),%eax
  80142d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801430:	8b 12                	mov    (%edx),%edx
  801432:	89 10                	mov    %edx,(%eax)
  801434:	eb 0a                	jmp    801440 <initialize_dyn_block_system+0x14f>
  801436:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801439:	8b 00                	mov    (%eax),%eax
  80143b:	a3 48 41 80 00       	mov    %eax,0x804148
  801440:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801443:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801449:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80144c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801453:	a1 54 41 80 00       	mov    0x804154,%eax
  801458:	48                   	dec    %eax
  801459:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  80145e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801461:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801468:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80146b:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801472:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801476:	75 14                	jne    80148c <initialize_dyn_block_system+0x19b>
  801478:	83 ec 04             	sub    $0x4,%esp
  80147b:	68 40 3a 80 00       	push   $0x803a40
  801480:	6a 3e                	push   $0x3e
  801482:	68 33 3a 80 00       	push   $0x803a33
  801487:	e8 f6 ed ff ff       	call   800282 <_panic>
  80148c:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801492:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801495:	89 10                	mov    %edx,(%eax)
  801497:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80149a:	8b 00                	mov    (%eax),%eax
  80149c:	85 c0                	test   %eax,%eax
  80149e:	74 0d                	je     8014ad <initialize_dyn_block_system+0x1bc>
  8014a0:	a1 38 41 80 00       	mov    0x804138,%eax
  8014a5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014a8:	89 50 04             	mov    %edx,0x4(%eax)
  8014ab:	eb 08                	jmp    8014b5 <initialize_dyn_block_system+0x1c4>
  8014ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014b0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014b8:	a3 38 41 80 00       	mov    %eax,0x804138
  8014bd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014c7:	a1 44 41 80 00       	mov    0x804144,%eax
  8014cc:	40                   	inc    %eax
  8014cd:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8014d2:	90                   	nop
  8014d3:	c9                   	leave  
  8014d4:	c3                   	ret    

008014d5 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014d5:	55                   	push   %ebp
  8014d6:	89 e5                	mov    %esp,%ebp
  8014d8:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8014db:	e8 e0 fd ff ff       	call   8012c0 <InitializeUHeap>
		if (size == 0) return NULL ;
  8014e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014e4:	75 07                	jne    8014ed <malloc+0x18>
  8014e6:	b8 00 00 00 00       	mov    $0x0,%eax
  8014eb:	eb 7f                	jmp    80156c <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8014ed:	e8 d2 08 00 00       	call   801dc4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	74 71                	je     801567 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  8014f6:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014fd:	8b 55 08             	mov    0x8(%ebp),%edx
  801500:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801503:	01 d0                	add    %edx,%eax
  801505:	48                   	dec    %eax
  801506:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150c:	ba 00 00 00 00       	mov    $0x0,%edx
  801511:	f7 75 f4             	divl   -0xc(%ebp)
  801514:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801517:	29 d0                	sub    %edx,%eax
  801519:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  80151c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801523:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80152a:	76 07                	jbe    801533 <malloc+0x5e>
					return NULL ;
  80152c:	b8 00 00 00 00       	mov    $0x0,%eax
  801531:	eb 39                	jmp    80156c <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801533:	83 ec 0c             	sub    $0xc,%esp
  801536:	ff 75 08             	pushl  0x8(%ebp)
  801539:	e8 e6 0d 00 00       	call   802324 <alloc_block_FF>
  80153e:	83 c4 10             	add    $0x10,%esp
  801541:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801544:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801548:	74 16                	je     801560 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  80154a:	83 ec 0c             	sub    $0xc,%esp
  80154d:	ff 75 ec             	pushl  -0x14(%ebp)
  801550:	e8 37 0c 00 00       	call   80218c <insert_sorted_allocList>
  801555:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801558:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80155b:	8b 40 08             	mov    0x8(%eax),%eax
  80155e:	eb 0c                	jmp    80156c <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	eb 05                	jmp    80156c <malloc+0x97>
				}
		}
	return 0;
  801567:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156c:	c9                   	leave  
  80156d:	c3                   	ret    

0080156e <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80156e:	55                   	push   %ebp
  80156f:	89 e5                	mov    %esp,%ebp
  801571:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801574:	8b 45 08             	mov    0x8(%ebp),%eax
  801577:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  80157a:	83 ec 08             	sub    $0x8,%esp
  80157d:	ff 75 f4             	pushl  -0xc(%ebp)
  801580:	68 40 40 80 00       	push   $0x804040
  801585:	e8 cf 0b 00 00       	call   802159 <find_block>
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801590:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801593:	8b 40 0c             	mov    0xc(%eax),%eax
  801596:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801599:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80159c:	8b 40 08             	mov    0x8(%eax),%eax
  80159f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8015a2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015a6:	0f 84 a1 00 00 00    	je     80164d <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8015ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015b0:	75 17                	jne    8015c9 <free+0x5b>
  8015b2:	83 ec 04             	sub    $0x4,%esp
  8015b5:	68 15 3a 80 00       	push   $0x803a15
  8015ba:	68 80 00 00 00       	push   $0x80
  8015bf:	68 33 3a 80 00       	push   $0x803a33
  8015c4:	e8 b9 ec ff ff       	call   800282 <_panic>
  8015c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015cc:	8b 00                	mov    (%eax),%eax
  8015ce:	85 c0                	test   %eax,%eax
  8015d0:	74 10                	je     8015e2 <free+0x74>
  8015d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d5:	8b 00                	mov    (%eax),%eax
  8015d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015da:	8b 52 04             	mov    0x4(%edx),%edx
  8015dd:	89 50 04             	mov    %edx,0x4(%eax)
  8015e0:	eb 0b                	jmp    8015ed <free+0x7f>
  8015e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e5:	8b 40 04             	mov    0x4(%eax),%eax
  8015e8:	a3 44 40 80 00       	mov    %eax,0x804044
  8015ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f0:	8b 40 04             	mov    0x4(%eax),%eax
  8015f3:	85 c0                	test   %eax,%eax
  8015f5:	74 0f                	je     801606 <free+0x98>
  8015f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fa:	8b 40 04             	mov    0x4(%eax),%eax
  8015fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801600:	8b 12                	mov    (%edx),%edx
  801602:	89 10                	mov    %edx,(%eax)
  801604:	eb 0a                	jmp    801610 <free+0xa2>
  801606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801609:	8b 00                	mov    (%eax),%eax
  80160b:	a3 40 40 80 00       	mov    %eax,0x804040
  801610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801613:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801619:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801623:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801628:	48                   	dec    %eax
  801629:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  80162e:	83 ec 0c             	sub    $0xc,%esp
  801631:	ff 75 f0             	pushl  -0x10(%ebp)
  801634:	e8 29 12 00 00       	call   802862 <insert_sorted_with_merge_freeList>
  801639:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  80163c:	83 ec 08             	sub    $0x8,%esp
  80163f:	ff 75 ec             	pushl  -0x14(%ebp)
  801642:	ff 75 e8             	pushl  -0x18(%ebp)
  801645:	e8 74 03 00 00       	call   8019be <sys_free_user_mem>
  80164a:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80164d:	90                   	nop
  80164e:	c9                   	leave  
  80164f:	c3                   	ret    

00801650 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801650:	55                   	push   %ebp
  801651:	89 e5                	mov    %esp,%ebp
  801653:	83 ec 38             	sub    $0x38,%esp
  801656:	8b 45 10             	mov    0x10(%ebp),%eax
  801659:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80165c:	e8 5f fc ff ff       	call   8012c0 <InitializeUHeap>
	if (size == 0) return NULL ;
  801661:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801665:	75 0a                	jne    801671 <smalloc+0x21>
  801667:	b8 00 00 00 00       	mov    $0x0,%eax
  80166c:	e9 b2 00 00 00       	jmp    801723 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801671:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801678:	76 0a                	jbe    801684 <smalloc+0x34>
		return NULL;
  80167a:	b8 00 00 00 00       	mov    $0x0,%eax
  80167f:	e9 9f 00 00 00       	jmp    801723 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801684:	e8 3b 07 00 00       	call   801dc4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801689:	85 c0                	test   %eax,%eax
  80168b:	0f 84 8d 00 00 00    	je     80171e <smalloc+0xce>
	struct MemBlock *b = NULL;
  801691:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801698:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80169f:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a5:	01 d0                	add    %edx,%eax
  8016a7:	48                   	dec    %eax
  8016a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b3:	f7 75 f0             	divl   -0x10(%ebp)
  8016b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b9:	29 d0                	sub    %edx,%eax
  8016bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8016be:	83 ec 0c             	sub    $0xc,%esp
  8016c1:	ff 75 e8             	pushl  -0x18(%ebp)
  8016c4:	e8 5b 0c 00 00       	call   802324 <alloc_block_FF>
  8016c9:	83 c4 10             	add    $0x10,%esp
  8016cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8016cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016d3:	75 07                	jne    8016dc <smalloc+0x8c>
			return NULL;
  8016d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016da:	eb 47                	jmp    801723 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8016dc:	83 ec 0c             	sub    $0xc,%esp
  8016df:	ff 75 f4             	pushl  -0xc(%ebp)
  8016e2:	e8 a5 0a 00 00       	call   80218c <insert_sorted_allocList>
  8016e7:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8016ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ed:	8b 40 08             	mov    0x8(%eax),%eax
  8016f0:	89 c2                	mov    %eax,%edx
  8016f2:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016f6:	52                   	push   %edx
  8016f7:	50                   	push   %eax
  8016f8:	ff 75 0c             	pushl  0xc(%ebp)
  8016fb:	ff 75 08             	pushl  0x8(%ebp)
  8016fe:	e8 46 04 00 00       	call   801b49 <sys_createSharedObject>
  801703:	83 c4 10             	add    $0x10,%esp
  801706:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801709:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80170d:	78 08                	js     801717 <smalloc+0xc7>
		return (void *)b->sva;
  80170f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801712:	8b 40 08             	mov    0x8(%eax),%eax
  801715:	eb 0c                	jmp    801723 <smalloc+0xd3>
		}else{
		return NULL;
  801717:	b8 00 00 00 00       	mov    $0x0,%eax
  80171c:	eb 05                	jmp    801723 <smalloc+0xd3>
			}

	}return NULL;
  80171e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801723:	c9                   	leave  
  801724:	c3                   	ret    

00801725 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801725:	55                   	push   %ebp
  801726:	89 e5                	mov    %esp,%ebp
  801728:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80172b:	e8 90 fb ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801730:	e8 8f 06 00 00       	call   801dc4 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801735:	85 c0                	test   %eax,%eax
  801737:	0f 84 ad 00 00 00    	je     8017ea <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80173d:	83 ec 08             	sub    $0x8,%esp
  801740:	ff 75 0c             	pushl  0xc(%ebp)
  801743:	ff 75 08             	pushl  0x8(%ebp)
  801746:	e8 28 04 00 00       	call   801b73 <sys_getSizeOfSharedObject>
  80174b:	83 c4 10             	add    $0x10,%esp
  80174e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801751:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801755:	79 0a                	jns    801761 <sget+0x3c>
    {
    	return NULL;
  801757:	b8 00 00 00 00       	mov    $0x0,%eax
  80175c:	e9 8e 00 00 00       	jmp    8017ef <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801761:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801768:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80176f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801772:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801775:	01 d0                	add    %edx,%eax
  801777:	48                   	dec    %eax
  801778:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80177b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80177e:	ba 00 00 00 00       	mov    $0x0,%edx
  801783:	f7 75 ec             	divl   -0x14(%ebp)
  801786:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801789:	29 d0                	sub    %edx,%eax
  80178b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  80178e:	83 ec 0c             	sub    $0xc,%esp
  801791:	ff 75 e4             	pushl  -0x1c(%ebp)
  801794:	e8 8b 0b 00 00       	call   802324 <alloc_block_FF>
  801799:	83 c4 10             	add    $0x10,%esp
  80179c:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  80179f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017a3:	75 07                	jne    8017ac <sget+0x87>
				return NULL;
  8017a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8017aa:	eb 43                	jmp    8017ef <sget+0xca>
			}
			insert_sorted_allocList(b);
  8017ac:	83 ec 0c             	sub    $0xc,%esp
  8017af:	ff 75 f0             	pushl  -0x10(%ebp)
  8017b2:	e8 d5 09 00 00       	call   80218c <insert_sorted_allocList>
  8017b7:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8017ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017bd:	8b 40 08             	mov    0x8(%eax),%eax
  8017c0:	83 ec 04             	sub    $0x4,%esp
  8017c3:	50                   	push   %eax
  8017c4:	ff 75 0c             	pushl  0xc(%ebp)
  8017c7:	ff 75 08             	pushl  0x8(%ebp)
  8017ca:	e8 c1 03 00 00       	call   801b90 <sys_getSharedObject>
  8017cf:	83 c4 10             	add    $0x10,%esp
  8017d2:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8017d5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017d9:	78 08                	js     8017e3 <sget+0xbe>
			return (void *)b->sva;
  8017db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017de:	8b 40 08             	mov    0x8(%eax),%eax
  8017e1:	eb 0c                	jmp    8017ef <sget+0xca>
			}else{
			return NULL;
  8017e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e8:	eb 05                	jmp    8017ef <sget+0xca>
			}
    }}return NULL;
  8017ea:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ef:	c9                   	leave  
  8017f0:	c3                   	ret    

008017f1 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017f1:	55                   	push   %ebp
  8017f2:	89 e5                	mov    %esp,%ebp
  8017f4:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017f7:	e8 c4 fa ff ff       	call   8012c0 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017fc:	83 ec 04             	sub    $0x4,%esp
  8017ff:	68 64 3a 80 00       	push   $0x803a64
  801804:	68 03 01 00 00       	push   $0x103
  801809:	68 33 3a 80 00       	push   $0x803a33
  80180e:	e8 6f ea ff ff       	call   800282 <_panic>

00801813 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801813:	55                   	push   %ebp
  801814:	89 e5                	mov    %esp,%ebp
  801816:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801819:	83 ec 04             	sub    $0x4,%esp
  80181c:	68 8c 3a 80 00       	push   $0x803a8c
  801821:	68 17 01 00 00       	push   $0x117
  801826:	68 33 3a 80 00       	push   $0x803a33
  80182b:	e8 52 ea ff ff       	call   800282 <_panic>

00801830 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801830:	55                   	push   %ebp
  801831:	89 e5                	mov    %esp,%ebp
  801833:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801836:	83 ec 04             	sub    $0x4,%esp
  801839:	68 b0 3a 80 00       	push   $0x803ab0
  80183e:	68 22 01 00 00       	push   $0x122
  801843:	68 33 3a 80 00       	push   $0x803a33
  801848:	e8 35 ea ff ff       	call   800282 <_panic>

0080184d <shrink>:

}
void shrink(uint32 newSize)
{
  80184d:	55                   	push   %ebp
  80184e:	89 e5                	mov    %esp,%ebp
  801850:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801853:	83 ec 04             	sub    $0x4,%esp
  801856:	68 b0 3a 80 00       	push   $0x803ab0
  80185b:	68 27 01 00 00       	push   $0x127
  801860:	68 33 3a 80 00       	push   $0x803a33
  801865:	e8 18 ea ff ff       	call   800282 <_panic>

0080186a <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80186a:	55                   	push   %ebp
  80186b:	89 e5                	mov    %esp,%ebp
  80186d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801870:	83 ec 04             	sub    $0x4,%esp
  801873:	68 b0 3a 80 00       	push   $0x803ab0
  801878:	68 2c 01 00 00       	push   $0x12c
  80187d:	68 33 3a 80 00       	push   $0x803a33
  801882:	e8 fb e9 ff ff       	call   800282 <_panic>

00801887 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801887:	55                   	push   %ebp
  801888:	89 e5                	mov    %esp,%ebp
  80188a:	57                   	push   %edi
  80188b:	56                   	push   %esi
  80188c:	53                   	push   %ebx
  80188d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801890:	8b 45 08             	mov    0x8(%ebp),%eax
  801893:	8b 55 0c             	mov    0xc(%ebp),%edx
  801896:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801899:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80189c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80189f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018a2:	cd 30                	int    $0x30
  8018a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018aa:	83 c4 10             	add    $0x10,%esp
  8018ad:	5b                   	pop    %ebx
  8018ae:	5e                   	pop    %esi
  8018af:	5f                   	pop    %edi
  8018b0:	5d                   	pop    %ebp
  8018b1:	c3                   	ret    

008018b2 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018b2:	55                   	push   %ebp
  8018b3:	89 e5                	mov    %esp,%ebp
  8018b5:	83 ec 04             	sub    $0x4,%esp
  8018b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8018bb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018be:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	52                   	push   %edx
  8018ca:	ff 75 0c             	pushl  0xc(%ebp)
  8018cd:	50                   	push   %eax
  8018ce:	6a 00                	push   $0x0
  8018d0:	e8 b2 ff ff ff       	call   801887 <syscall>
  8018d5:	83 c4 18             	add    $0x18,%esp
}
  8018d8:	90                   	nop
  8018d9:	c9                   	leave  
  8018da:	c3                   	ret    

008018db <sys_cgetc>:

int
sys_cgetc(void)
{
  8018db:	55                   	push   %ebp
  8018dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 00                	push   $0x0
  8018e8:	6a 01                	push   $0x1
  8018ea:	e8 98 ff ff ff       	call   801887 <syscall>
  8018ef:	83 c4 18             	add    $0x18,%esp
}
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 00                	push   $0x0
  801901:	6a 00                	push   $0x0
  801903:	52                   	push   %edx
  801904:	50                   	push   %eax
  801905:	6a 05                	push   $0x5
  801907:	e8 7b ff ff ff       	call   801887 <syscall>
  80190c:	83 c4 18             	add    $0x18,%esp
}
  80190f:	c9                   	leave  
  801910:	c3                   	ret    

00801911 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801911:	55                   	push   %ebp
  801912:	89 e5                	mov    %esp,%ebp
  801914:	56                   	push   %esi
  801915:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801916:	8b 75 18             	mov    0x18(%ebp),%esi
  801919:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80191c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80191f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	56                   	push   %esi
  801926:	53                   	push   %ebx
  801927:	51                   	push   %ecx
  801928:	52                   	push   %edx
  801929:	50                   	push   %eax
  80192a:	6a 06                	push   $0x6
  80192c:	e8 56 ff ff ff       	call   801887 <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801937:	5b                   	pop    %ebx
  801938:	5e                   	pop    %esi
  801939:	5d                   	pop    %ebp
  80193a:	c3                   	ret    

0080193b <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80193b:	55                   	push   %ebp
  80193c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80193e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801941:	8b 45 08             	mov    0x8(%ebp),%eax
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	52                   	push   %edx
  80194b:	50                   	push   %eax
  80194c:	6a 07                	push   $0x7
  80194e:	e8 34 ff ff ff       	call   801887 <syscall>
  801953:	83 c4 18             	add    $0x18,%esp
}
  801956:	c9                   	leave  
  801957:	c3                   	ret    

00801958 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801958:	55                   	push   %ebp
  801959:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	ff 75 0c             	pushl  0xc(%ebp)
  801964:	ff 75 08             	pushl  0x8(%ebp)
  801967:	6a 08                	push   $0x8
  801969:	e8 19 ff ff ff       	call   801887 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	c9                   	leave  
  801972:	c3                   	ret    

00801973 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801973:	55                   	push   %ebp
  801974:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801976:	6a 00                	push   $0x0
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	6a 09                	push   $0x9
  801982:	e8 00 ff ff ff       	call   801887 <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 0a                	push   $0xa
  80199b:	e8 e7 fe ff ff       	call   801887 <syscall>
  8019a0:	83 c4 18             	add    $0x18,%esp
}
  8019a3:	c9                   	leave  
  8019a4:	c3                   	ret    

008019a5 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019a5:	55                   	push   %ebp
  8019a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019a8:	6a 00                	push   $0x0
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 0b                	push   $0xb
  8019b4:	e8 ce fe ff ff       	call   801887 <syscall>
  8019b9:	83 c4 18             	add    $0x18,%esp
}
  8019bc:	c9                   	leave  
  8019bd:	c3                   	ret    

008019be <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019be:	55                   	push   %ebp
  8019bf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	ff 75 0c             	pushl  0xc(%ebp)
  8019ca:	ff 75 08             	pushl  0x8(%ebp)
  8019cd:	6a 0f                	push   $0xf
  8019cf:	e8 b3 fe ff ff       	call   801887 <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
	return;
  8019d7:	90                   	nop
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	ff 75 0c             	pushl  0xc(%ebp)
  8019e6:	ff 75 08             	pushl  0x8(%ebp)
  8019e9:	6a 10                	push   $0x10
  8019eb:	e8 97 fe ff ff       	call   801887 <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f3:	90                   	nop
}
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	ff 75 10             	pushl  0x10(%ebp)
  801a00:	ff 75 0c             	pushl  0xc(%ebp)
  801a03:	ff 75 08             	pushl  0x8(%ebp)
  801a06:	6a 11                	push   $0x11
  801a08:	e8 7a fe ff ff       	call   801887 <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a10:	90                   	nop
}
  801a11:	c9                   	leave  
  801a12:	c3                   	ret    

00801a13 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a13:	55                   	push   %ebp
  801a14:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 0c                	push   $0xc
  801a22:	e8 60 fe ff ff       	call   801887 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	ff 75 08             	pushl  0x8(%ebp)
  801a3a:	6a 0d                	push   $0xd
  801a3c:	e8 46 fe ff ff       	call   801887 <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
}
  801a44:	c9                   	leave  
  801a45:	c3                   	ret    

00801a46 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a46:	55                   	push   %ebp
  801a47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a49:	6a 00                	push   $0x0
  801a4b:	6a 00                	push   $0x0
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 0e                	push   $0xe
  801a55:	e8 2d fe ff ff       	call   801887 <syscall>
  801a5a:	83 c4 18             	add    $0x18,%esp
}
  801a5d:	90                   	nop
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 13                	push   $0x13
  801a6f:	e8 13 fe ff ff       	call   801887 <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
}
  801a77:	90                   	nop
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 14                	push   $0x14
  801a89:	e8 f9 fd ff ff       	call   801887 <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	90                   	nop
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	83 ec 04             	sub    $0x4,%esp
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aa0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 00                	push   $0x0
  801aaa:	6a 00                	push   $0x0
  801aac:	50                   	push   %eax
  801aad:	6a 15                	push   $0x15
  801aaf:	e8 d3 fd ff ff       	call   801887 <syscall>
  801ab4:	83 c4 18             	add    $0x18,%esp
}
  801ab7:	90                   	nop
  801ab8:	c9                   	leave  
  801ab9:	c3                   	ret    

00801aba <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aba:	55                   	push   %ebp
  801abb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801abd:	6a 00                	push   $0x0
  801abf:	6a 00                	push   $0x0
  801ac1:	6a 00                	push   $0x0
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 16                	push   $0x16
  801ac9:	e8 b9 fd ff ff       	call   801887 <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
}
  801ad1:	90                   	nop
  801ad2:	c9                   	leave  
  801ad3:	c3                   	ret    

00801ad4 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ad4:	55                   	push   %ebp
  801ad5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	ff 75 0c             	pushl  0xc(%ebp)
  801ae3:	50                   	push   %eax
  801ae4:	6a 17                	push   $0x17
  801ae6:	e8 9c fd ff ff       	call   801887 <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801af3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af6:	8b 45 08             	mov    0x8(%ebp),%eax
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	52                   	push   %edx
  801b00:	50                   	push   %eax
  801b01:	6a 1a                	push   $0x1a
  801b03:	e8 7f fd ff ff       	call   801887 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	52                   	push   %edx
  801b1d:	50                   	push   %eax
  801b1e:	6a 18                	push   $0x18
  801b20:	e8 62 fd ff ff       	call   801887 <syscall>
  801b25:	83 c4 18             	add    $0x18,%esp
}
  801b28:	90                   	nop
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	52                   	push   %edx
  801b3b:	50                   	push   %eax
  801b3c:	6a 19                	push   $0x19
  801b3e:	e8 44 fd ff ff       	call   801887 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	90                   	nop
  801b47:	c9                   	leave  
  801b48:	c3                   	ret    

00801b49 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b49:	55                   	push   %ebp
  801b4a:	89 e5                	mov    %esp,%ebp
  801b4c:	83 ec 04             	sub    $0x4,%esp
  801b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  801b52:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b55:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b58:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5f:	6a 00                	push   $0x0
  801b61:	51                   	push   %ecx
  801b62:	52                   	push   %edx
  801b63:	ff 75 0c             	pushl  0xc(%ebp)
  801b66:	50                   	push   %eax
  801b67:	6a 1b                	push   $0x1b
  801b69:	e8 19 fd ff ff       	call   801887 <syscall>
  801b6e:	83 c4 18             	add    $0x18,%esp
}
  801b71:	c9                   	leave  
  801b72:	c3                   	ret    

00801b73 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b73:	55                   	push   %ebp
  801b74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b76:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b79:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	52                   	push   %edx
  801b83:	50                   	push   %eax
  801b84:	6a 1c                	push   $0x1c
  801b86:	e8 fc fc ff ff       	call   801887 <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b93:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b96:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b99:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	51                   	push   %ecx
  801ba1:	52                   	push   %edx
  801ba2:	50                   	push   %eax
  801ba3:	6a 1d                	push   $0x1d
  801ba5:	e8 dd fc ff ff       	call   801887 <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	6a 00                	push   $0x0
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	52                   	push   %edx
  801bbf:	50                   	push   %eax
  801bc0:	6a 1e                	push   $0x1e
  801bc2:	e8 c0 fc ff ff       	call   801887 <syscall>
  801bc7:	83 c4 18             	add    $0x18,%esp
}
  801bca:	c9                   	leave  
  801bcb:	c3                   	ret    

00801bcc <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bcc:	55                   	push   %ebp
  801bcd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 1f                	push   $0x1f
  801bdb:	e8 a7 fc ff ff       	call   801887 <syscall>
  801be0:	83 c4 18             	add    $0x18,%esp
}
  801be3:	c9                   	leave  
  801be4:	c3                   	ret    

00801be5 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801be5:	55                   	push   %ebp
  801be6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	6a 00                	push   $0x0
  801bed:	ff 75 14             	pushl  0x14(%ebp)
  801bf0:	ff 75 10             	pushl  0x10(%ebp)
  801bf3:	ff 75 0c             	pushl  0xc(%ebp)
  801bf6:	50                   	push   %eax
  801bf7:	6a 20                	push   $0x20
  801bf9:	e8 89 fc ff ff       	call   801887 <syscall>
  801bfe:	83 c4 18             	add    $0x18,%esp
}
  801c01:	c9                   	leave  
  801c02:	c3                   	ret    

00801c03 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c03:	55                   	push   %ebp
  801c04:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c06:	8b 45 08             	mov    0x8(%ebp),%eax
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 00                	push   $0x0
  801c0f:	6a 00                	push   $0x0
  801c11:	50                   	push   %eax
  801c12:	6a 21                	push   $0x21
  801c14:	e8 6e fc ff ff       	call   801887 <syscall>
  801c19:	83 c4 18             	add    $0x18,%esp
}
  801c1c:	90                   	nop
  801c1d:	c9                   	leave  
  801c1e:	c3                   	ret    

00801c1f <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c1f:	55                   	push   %ebp
  801c20:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c22:	8b 45 08             	mov    0x8(%ebp),%eax
  801c25:	6a 00                	push   $0x0
  801c27:	6a 00                	push   $0x0
  801c29:	6a 00                	push   $0x0
  801c2b:	6a 00                	push   $0x0
  801c2d:	50                   	push   %eax
  801c2e:	6a 22                	push   $0x22
  801c30:	e8 52 fc ff ff       	call   801887 <syscall>
  801c35:	83 c4 18             	add    $0x18,%esp
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 02                	push   $0x2
  801c49:	e8 39 fc ff ff       	call   801887 <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c56:	6a 00                	push   $0x0
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 03                	push   $0x3
  801c62:	e8 20 fc ff ff       	call   801887 <syscall>
  801c67:	83 c4 18             	add    $0x18,%esp
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c6f:	6a 00                	push   $0x0
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 04                	push   $0x4
  801c7b:	e8 07 fc ff ff       	call   801887 <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	c9                   	leave  
  801c84:	c3                   	ret    

00801c85 <sys_exit_env>:


void sys_exit_env(void)
{
  801c85:	55                   	push   %ebp
  801c86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 23                	push   $0x23
  801c94:	e8 ee fb ff ff       	call   801887 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	90                   	nop
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
  801ca2:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ca5:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca8:	8d 50 04             	lea    0x4(%eax),%edx
  801cab:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	52                   	push   %edx
  801cb5:	50                   	push   %eax
  801cb6:	6a 24                	push   $0x24
  801cb8:	e8 ca fb ff ff       	call   801887 <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
	return result;
  801cc0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cc6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cc9:	89 01                	mov    %eax,(%ecx)
  801ccb:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cce:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd1:	c9                   	leave  
  801cd2:	c2 04 00             	ret    $0x4

00801cd5 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cd5:	55                   	push   %ebp
  801cd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	ff 75 10             	pushl  0x10(%ebp)
  801cdf:	ff 75 0c             	pushl  0xc(%ebp)
  801ce2:	ff 75 08             	pushl  0x8(%ebp)
  801ce5:	6a 12                	push   $0x12
  801ce7:	e8 9b fb ff ff       	call   801887 <syscall>
  801cec:	83 c4 18             	add    $0x18,%esp
	return ;
  801cef:	90                   	nop
}
  801cf0:	c9                   	leave  
  801cf1:	c3                   	ret    

00801cf2 <sys_rcr2>:
uint32 sys_rcr2()
{
  801cf2:	55                   	push   %ebp
  801cf3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	6a 00                	push   $0x0
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 25                	push   $0x25
  801d01:	e8 81 fb ff ff       	call   801887 <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	c9                   	leave  
  801d0a:	c3                   	ret    

00801d0b <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d0b:	55                   	push   %ebp
  801d0c:	89 e5                	mov    %esp,%ebp
  801d0e:	83 ec 04             	sub    $0x4,%esp
  801d11:	8b 45 08             	mov    0x8(%ebp),%eax
  801d14:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d17:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	50                   	push   %eax
  801d24:	6a 26                	push   $0x26
  801d26:	e8 5c fb ff ff       	call   801887 <syscall>
  801d2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2e:	90                   	nop
}
  801d2f:	c9                   	leave  
  801d30:	c3                   	ret    

00801d31 <rsttst>:
void rsttst()
{
  801d31:	55                   	push   %ebp
  801d32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 00                	push   $0x0
  801d3c:	6a 00                	push   $0x0
  801d3e:	6a 28                	push   $0x28
  801d40:	e8 42 fb ff ff       	call   801887 <syscall>
  801d45:	83 c4 18             	add    $0x18,%esp
	return ;
  801d48:	90                   	nop
}
  801d49:	c9                   	leave  
  801d4a:	c3                   	ret    

00801d4b <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d4b:	55                   	push   %ebp
  801d4c:	89 e5                	mov    %esp,%ebp
  801d4e:	83 ec 04             	sub    $0x4,%esp
  801d51:	8b 45 14             	mov    0x14(%ebp),%eax
  801d54:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d57:	8b 55 18             	mov    0x18(%ebp),%edx
  801d5a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d5e:	52                   	push   %edx
  801d5f:	50                   	push   %eax
  801d60:	ff 75 10             	pushl  0x10(%ebp)
  801d63:	ff 75 0c             	pushl  0xc(%ebp)
  801d66:	ff 75 08             	pushl  0x8(%ebp)
  801d69:	6a 27                	push   $0x27
  801d6b:	e8 17 fb ff ff       	call   801887 <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
	return ;
  801d73:	90                   	nop
}
  801d74:	c9                   	leave  
  801d75:	c3                   	ret    

00801d76 <chktst>:
void chktst(uint32 n)
{
  801d76:	55                   	push   %ebp
  801d77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 00                	push   $0x0
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	ff 75 08             	pushl  0x8(%ebp)
  801d84:	6a 29                	push   $0x29
  801d86:	e8 fc fa ff ff       	call   801887 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8e:	90                   	nop
}
  801d8f:	c9                   	leave  
  801d90:	c3                   	ret    

00801d91 <inctst>:

void inctst()
{
  801d91:	55                   	push   %ebp
  801d92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d94:	6a 00                	push   $0x0
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 2a                	push   $0x2a
  801da0:	e8 e2 fa ff ff       	call   801887 <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
	return ;
  801da8:	90                   	nop
}
  801da9:	c9                   	leave  
  801daa:	c3                   	ret    

00801dab <gettst>:
uint32 gettst()
{
  801dab:	55                   	push   %ebp
  801dac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 00                	push   $0x0
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 2b                	push   $0x2b
  801dba:	e8 c8 fa ff ff       	call   801887 <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
}
  801dc2:	c9                   	leave  
  801dc3:	c3                   	ret    

00801dc4 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dc4:	55                   	push   %ebp
  801dc5:	89 e5                	mov    %esp,%ebp
  801dc7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 2c                	push   $0x2c
  801dd6:	e8 ac fa ff ff       	call   801887 <syscall>
  801ddb:	83 c4 18             	add    $0x18,%esp
  801dde:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801de1:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801de5:	75 07                	jne    801dee <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801de7:	b8 01 00 00 00       	mov    $0x1,%eax
  801dec:	eb 05                	jmp    801df3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dee:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df3:	c9                   	leave  
  801df4:	c3                   	ret    

00801df5 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801df5:	55                   	push   %ebp
  801df6:	89 e5                	mov    %esp,%ebp
  801df8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 2c                	push   $0x2c
  801e07:	e8 7b fa ff ff       	call   801887 <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
  801e0f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e12:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e16:	75 07                	jne    801e1f <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e18:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1d:	eb 05                	jmp    801e24 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	6a 00                	push   $0x0
  801e36:	6a 2c                	push   $0x2c
  801e38:	e8 4a fa ff ff       	call   801887 <syscall>
  801e3d:	83 c4 18             	add    $0x18,%esp
  801e40:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e43:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e47:	75 07                	jne    801e50 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e49:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4e:	eb 05                	jmp    801e55 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e50:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e55:	c9                   	leave  
  801e56:	c3                   	ret    

00801e57 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801e69:	e8 19 fa ff ff       	call   801887 <syscall>
  801e6e:	83 c4 18             	add    $0x18,%esp
  801e71:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e74:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e78:	75 07                	jne    801e81 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e7a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7f:	eb 05                	jmp    801e86 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e86:	c9                   	leave  
  801e87:	c3                   	ret    

00801e88 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e88:	55                   	push   %ebp
  801e89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	6a 00                	push   $0x0
  801e91:	6a 00                	push   $0x0
  801e93:	ff 75 08             	pushl  0x8(%ebp)
  801e96:	6a 2d                	push   $0x2d
  801e98:	e8 ea f9 ff ff       	call   801887 <syscall>
  801e9d:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea0:	90                   	nop
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ea7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eaa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ead:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb3:	6a 00                	push   $0x0
  801eb5:	53                   	push   %ebx
  801eb6:	51                   	push   %ecx
  801eb7:	52                   	push   %edx
  801eb8:	50                   	push   %eax
  801eb9:	6a 2e                	push   $0x2e
  801ebb:	e8 c7 f9 ff ff       	call   801887 <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
}
  801ec3:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ecb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ece:	8b 45 08             	mov    0x8(%ebp),%eax
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 00                	push   $0x0
  801ed5:	6a 00                	push   $0x0
  801ed7:	52                   	push   %edx
  801ed8:	50                   	push   %eax
  801ed9:	6a 2f                	push   $0x2f
  801edb:	e8 a7 f9 ff ff       	call   801887 <syscall>
  801ee0:	83 c4 18             	add    $0x18,%esp
}
  801ee3:	c9                   	leave  
  801ee4:	c3                   	ret    

00801ee5 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ee5:	55                   	push   %ebp
  801ee6:	89 e5                	mov    %esp,%ebp
  801ee8:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eeb:	83 ec 0c             	sub    $0xc,%esp
  801eee:	68 c0 3a 80 00       	push   $0x803ac0
  801ef3:	e8 3e e6 ff ff       	call   800536 <cprintf>
  801ef8:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801efb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f02:	83 ec 0c             	sub    $0xc,%esp
  801f05:	68 ec 3a 80 00       	push   $0x803aec
  801f0a:	e8 27 e6 ff ff       	call   800536 <cprintf>
  801f0f:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f12:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f16:	a1 38 41 80 00       	mov    0x804138,%eax
  801f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f1e:	eb 56                	jmp    801f76 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f20:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f24:	74 1c                	je     801f42 <print_mem_block_lists+0x5d>
  801f26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f29:	8b 50 08             	mov    0x8(%eax),%edx
  801f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2f:	8b 48 08             	mov    0x8(%eax),%ecx
  801f32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f35:	8b 40 0c             	mov    0xc(%eax),%eax
  801f38:	01 c8                	add    %ecx,%eax
  801f3a:	39 c2                	cmp    %eax,%edx
  801f3c:	73 04                	jae    801f42 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f3e:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f45:	8b 50 08             	mov    0x8(%eax),%edx
  801f48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f4b:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4e:	01 c2                	add    %eax,%edx
  801f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f53:	8b 40 08             	mov    0x8(%eax),%eax
  801f56:	83 ec 04             	sub    $0x4,%esp
  801f59:	52                   	push   %edx
  801f5a:	50                   	push   %eax
  801f5b:	68 01 3b 80 00       	push   $0x803b01
  801f60:	e8 d1 e5 ff ff       	call   800536 <cprintf>
  801f65:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f6e:	a1 40 41 80 00       	mov    0x804140,%eax
  801f73:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f7a:	74 07                	je     801f83 <print_mem_block_lists+0x9e>
  801f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7f:	8b 00                	mov    (%eax),%eax
  801f81:	eb 05                	jmp    801f88 <print_mem_block_lists+0xa3>
  801f83:	b8 00 00 00 00       	mov    $0x0,%eax
  801f88:	a3 40 41 80 00       	mov    %eax,0x804140
  801f8d:	a1 40 41 80 00       	mov    0x804140,%eax
  801f92:	85 c0                	test   %eax,%eax
  801f94:	75 8a                	jne    801f20 <print_mem_block_lists+0x3b>
  801f96:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f9a:	75 84                	jne    801f20 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f9c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fa0:	75 10                	jne    801fb2 <print_mem_block_lists+0xcd>
  801fa2:	83 ec 0c             	sub    $0xc,%esp
  801fa5:	68 10 3b 80 00       	push   $0x803b10
  801faa:	e8 87 e5 ff ff       	call   800536 <cprintf>
  801faf:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fb2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fb9:	83 ec 0c             	sub    $0xc,%esp
  801fbc:	68 34 3b 80 00       	push   $0x803b34
  801fc1:	e8 70 e5 ff ff       	call   800536 <cprintf>
  801fc6:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fc9:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fcd:	a1 40 40 80 00       	mov    0x804040,%eax
  801fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd5:	eb 56                	jmp    80202d <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fd7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fdb:	74 1c                	je     801ff9 <print_mem_block_lists+0x114>
  801fdd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe0:	8b 50 08             	mov    0x8(%eax),%edx
  801fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe6:	8b 48 08             	mov    0x8(%eax),%ecx
  801fe9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fec:	8b 40 0c             	mov    0xc(%eax),%eax
  801fef:	01 c8                	add    %ecx,%eax
  801ff1:	39 c2                	cmp    %eax,%edx
  801ff3:	73 04                	jae    801ff9 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ff5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ff9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffc:	8b 50 08             	mov    0x8(%eax),%edx
  801fff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802002:	8b 40 0c             	mov    0xc(%eax),%eax
  802005:	01 c2                	add    %eax,%edx
  802007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200a:	8b 40 08             	mov    0x8(%eax),%eax
  80200d:	83 ec 04             	sub    $0x4,%esp
  802010:	52                   	push   %edx
  802011:	50                   	push   %eax
  802012:	68 01 3b 80 00       	push   $0x803b01
  802017:	e8 1a e5 ff ff       	call   800536 <cprintf>
  80201c:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80201f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802022:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802025:	a1 48 40 80 00       	mov    0x804048,%eax
  80202a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80202d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802031:	74 07                	je     80203a <print_mem_block_lists+0x155>
  802033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802036:	8b 00                	mov    (%eax),%eax
  802038:	eb 05                	jmp    80203f <print_mem_block_lists+0x15a>
  80203a:	b8 00 00 00 00       	mov    $0x0,%eax
  80203f:	a3 48 40 80 00       	mov    %eax,0x804048
  802044:	a1 48 40 80 00       	mov    0x804048,%eax
  802049:	85 c0                	test   %eax,%eax
  80204b:	75 8a                	jne    801fd7 <print_mem_block_lists+0xf2>
  80204d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802051:	75 84                	jne    801fd7 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802053:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802057:	75 10                	jne    802069 <print_mem_block_lists+0x184>
  802059:	83 ec 0c             	sub    $0xc,%esp
  80205c:	68 4c 3b 80 00       	push   $0x803b4c
  802061:	e8 d0 e4 ff ff       	call   800536 <cprintf>
  802066:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802069:	83 ec 0c             	sub    $0xc,%esp
  80206c:	68 c0 3a 80 00       	push   $0x803ac0
  802071:	e8 c0 e4 ff ff       	call   800536 <cprintf>
  802076:	83 c4 10             	add    $0x10,%esp

}
  802079:	90                   	nop
  80207a:	c9                   	leave  
  80207b:	c3                   	ret    

0080207c <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80207c:	55                   	push   %ebp
  80207d:	89 e5                	mov    %esp,%ebp
  80207f:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802082:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802089:	00 00 00 
  80208c:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802093:	00 00 00 
  802096:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80209d:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8020a0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020a7:	e9 9e 00 00 00       	jmp    80214a <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8020ac:	a1 50 40 80 00       	mov    0x804050,%eax
  8020b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b4:	c1 e2 04             	shl    $0x4,%edx
  8020b7:	01 d0                	add    %edx,%eax
  8020b9:	85 c0                	test   %eax,%eax
  8020bb:	75 14                	jne    8020d1 <initialize_MemBlocksList+0x55>
  8020bd:	83 ec 04             	sub    $0x4,%esp
  8020c0:	68 74 3b 80 00       	push   $0x803b74
  8020c5:	6a 3d                	push   $0x3d
  8020c7:	68 97 3b 80 00       	push   $0x803b97
  8020cc:	e8 b1 e1 ff ff       	call   800282 <_panic>
  8020d1:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d9:	c1 e2 04             	shl    $0x4,%edx
  8020dc:	01 d0                	add    %edx,%eax
  8020de:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020e4:	89 10                	mov    %edx,(%eax)
  8020e6:	8b 00                	mov    (%eax),%eax
  8020e8:	85 c0                	test   %eax,%eax
  8020ea:	74 18                	je     802104 <initialize_MemBlocksList+0x88>
  8020ec:	a1 48 41 80 00       	mov    0x804148,%eax
  8020f1:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020f7:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020fa:	c1 e1 04             	shl    $0x4,%ecx
  8020fd:	01 ca                	add    %ecx,%edx
  8020ff:	89 50 04             	mov    %edx,0x4(%eax)
  802102:	eb 12                	jmp    802116 <initialize_MemBlocksList+0x9a>
  802104:	a1 50 40 80 00       	mov    0x804050,%eax
  802109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210c:	c1 e2 04             	shl    $0x4,%edx
  80210f:	01 d0                	add    %edx,%eax
  802111:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802116:	a1 50 40 80 00       	mov    0x804050,%eax
  80211b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211e:	c1 e2 04             	shl    $0x4,%edx
  802121:	01 d0                	add    %edx,%eax
  802123:	a3 48 41 80 00       	mov    %eax,0x804148
  802128:	a1 50 40 80 00       	mov    0x804050,%eax
  80212d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802130:	c1 e2 04             	shl    $0x4,%edx
  802133:	01 d0                	add    %edx,%eax
  802135:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80213c:	a1 54 41 80 00       	mov    0x804154,%eax
  802141:	40                   	inc    %eax
  802142:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802147:	ff 45 f4             	incl   -0xc(%ebp)
  80214a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802150:	0f 82 56 ff ff ff    	jb     8020ac <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802156:	90                   	nop
  802157:	c9                   	leave  
  802158:	c3                   	ret    

00802159 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802159:	55                   	push   %ebp
  80215a:	89 e5                	mov    %esp,%ebp
  80215c:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  80215f:	8b 45 08             	mov    0x8(%ebp),%eax
  802162:	8b 00                	mov    (%eax),%eax
  802164:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802167:	eb 18                	jmp    802181 <find_block+0x28>

		if(tmp->sva == va){
  802169:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80216c:	8b 40 08             	mov    0x8(%eax),%eax
  80216f:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802172:	75 05                	jne    802179 <find_block+0x20>
			return tmp ;
  802174:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802177:	eb 11                	jmp    80218a <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802179:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80217c:	8b 00                	mov    (%eax),%eax
  80217e:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802181:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802185:	75 e2                	jne    802169 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802187:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80218a:	c9                   	leave  
  80218b:	c3                   	ret    

0080218c <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80218c:	55                   	push   %ebp
  80218d:	89 e5                	mov    %esp,%ebp
  80218f:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802192:	a1 40 40 80 00       	mov    0x804040,%eax
  802197:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  80219a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80219f:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8021a2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021a6:	75 65                	jne    80220d <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8021a8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ac:	75 14                	jne    8021c2 <insert_sorted_allocList+0x36>
  8021ae:	83 ec 04             	sub    $0x4,%esp
  8021b1:	68 74 3b 80 00       	push   $0x803b74
  8021b6:	6a 62                	push   $0x62
  8021b8:	68 97 3b 80 00       	push   $0x803b97
  8021bd:	e8 c0 e0 ff ff       	call   800282 <_panic>
  8021c2:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cb:	89 10                	mov    %edx,(%eax)
  8021cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d0:	8b 00                	mov    (%eax),%eax
  8021d2:	85 c0                	test   %eax,%eax
  8021d4:	74 0d                	je     8021e3 <insert_sorted_allocList+0x57>
  8021d6:	a1 40 40 80 00       	mov    0x804040,%eax
  8021db:	8b 55 08             	mov    0x8(%ebp),%edx
  8021de:	89 50 04             	mov    %edx,0x4(%eax)
  8021e1:	eb 08                	jmp    8021eb <insert_sorted_allocList+0x5f>
  8021e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e6:	a3 44 40 80 00       	mov    %eax,0x804044
  8021eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ee:	a3 40 40 80 00       	mov    %eax,0x804040
  8021f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021fd:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802202:	40                   	inc    %eax
  802203:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802208:	e9 14 01 00 00       	jmp    802321 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80220d:	8b 45 08             	mov    0x8(%ebp),%eax
  802210:	8b 50 08             	mov    0x8(%eax),%edx
  802213:	a1 44 40 80 00       	mov    0x804044,%eax
  802218:	8b 40 08             	mov    0x8(%eax),%eax
  80221b:	39 c2                	cmp    %eax,%edx
  80221d:	76 65                	jbe    802284 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80221f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802223:	75 14                	jne    802239 <insert_sorted_allocList+0xad>
  802225:	83 ec 04             	sub    $0x4,%esp
  802228:	68 b0 3b 80 00       	push   $0x803bb0
  80222d:	6a 64                	push   $0x64
  80222f:	68 97 3b 80 00       	push   $0x803b97
  802234:	e8 49 e0 ff ff       	call   800282 <_panic>
  802239:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	89 50 04             	mov    %edx,0x4(%eax)
  802245:	8b 45 08             	mov    0x8(%ebp),%eax
  802248:	8b 40 04             	mov    0x4(%eax),%eax
  80224b:	85 c0                	test   %eax,%eax
  80224d:	74 0c                	je     80225b <insert_sorted_allocList+0xcf>
  80224f:	a1 44 40 80 00       	mov    0x804044,%eax
  802254:	8b 55 08             	mov    0x8(%ebp),%edx
  802257:	89 10                	mov    %edx,(%eax)
  802259:	eb 08                	jmp    802263 <insert_sorted_allocList+0xd7>
  80225b:	8b 45 08             	mov    0x8(%ebp),%eax
  80225e:	a3 40 40 80 00       	mov    %eax,0x804040
  802263:	8b 45 08             	mov    0x8(%ebp),%eax
  802266:	a3 44 40 80 00       	mov    %eax,0x804044
  80226b:	8b 45 08             	mov    0x8(%ebp),%eax
  80226e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802274:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802279:	40                   	inc    %eax
  80227a:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80227f:	e9 9d 00 00 00       	jmp    802321 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802284:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80228b:	e9 85 00 00 00       	jmp    802315 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802290:	8b 45 08             	mov    0x8(%ebp),%eax
  802293:	8b 50 08             	mov    0x8(%eax),%edx
  802296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802299:	8b 40 08             	mov    0x8(%eax),%eax
  80229c:	39 c2                	cmp    %eax,%edx
  80229e:	73 6a                	jae    80230a <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8022a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a4:	74 06                	je     8022ac <insert_sorted_allocList+0x120>
  8022a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022aa:	75 14                	jne    8022c0 <insert_sorted_allocList+0x134>
  8022ac:	83 ec 04             	sub    $0x4,%esp
  8022af:	68 d4 3b 80 00       	push   $0x803bd4
  8022b4:	6a 6b                	push   $0x6b
  8022b6:	68 97 3b 80 00       	push   $0x803b97
  8022bb:	e8 c2 df ff ff       	call   800282 <_panic>
  8022c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c3:	8b 50 04             	mov    0x4(%eax),%edx
  8022c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c9:	89 50 04             	mov    %edx,0x4(%eax)
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022d2:	89 10                	mov    %edx,(%eax)
  8022d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d7:	8b 40 04             	mov    0x4(%eax),%eax
  8022da:	85 c0                	test   %eax,%eax
  8022dc:	74 0d                	je     8022eb <insert_sorted_allocList+0x15f>
  8022de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e1:	8b 40 04             	mov    0x4(%eax),%eax
  8022e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e7:	89 10                	mov    %edx,(%eax)
  8022e9:	eb 08                	jmp    8022f3 <insert_sorted_allocList+0x167>
  8022eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ee:	a3 40 40 80 00       	mov    %eax,0x804040
  8022f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f9:	89 50 04             	mov    %edx,0x4(%eax)
  8022fc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802301:	40                   	inc    %eax
  802302:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  802307:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802308:	eb 17                	jmp    802321 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  80230a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230d:	8b 00                	mov    (%eax),%eax
  80230f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802312:	ff 45 f0             	incl   -0x10(%ebp)
  802315:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802318:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80231b:	0f 8c 6f ff ff ff    	jl     802290 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802321:	90                   	nop
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
  802327:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  80232a:	a1 38 41 80 00       	mov    0x804138,%eax
  80232f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802332:	e9 7c 01 00 00       	jmp    8024b3 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233a:	8b 40 0c             	mov    0xc(%eax),%eax
  80233d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802340:	0f 86 cf 00 00 00    	jbe    802415 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802346:	a1 48 41 80 00       	mov    0x804148,%eax
  80234b:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  80234e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802351:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802354:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802357:	8b 55 08             	mov    0x8(%ebp),%edx
  80235a:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  80235d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802360:	8b 50 08             	mov    0x8(%eax),%edx
  802363:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802366:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 40 0c             	mov    0xc(%eax),%eax
  80236f:	2b 45 08             	sub    0x8(%ebp),%eax
  802372:	89 c2                	mov    %eax,%edx
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	8b 50 08             	mov    0x8(%eax),%edx
  802380:	8b 45 08             	mov    0x8(%ebp),%eax
  802383:	01 c2                	add    %eax,%edx
  802385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802388:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80238b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80238f:	75 17                	jne    8023a8 <alloc_block_FF+0x84>
  802391:	83 ec 04             	sub    $0x4,%esp
  802394:	68 09 3c 80 00       	push   $0x803c09
  802399:	68 83 00 00 00       	push   $0x83
  80239e:	68 97 3b 80 00       	push   $0x803b97
  8023a3:	e8 da de ff ff       	call   800282 <_panic>
  8023a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ab:	8b 00                	mov    (%eax),%eax
  8023ad:	85 c0                	test   %eax,%eax
  8023af:	74 10                	je     8023c1 <alloc_block_FF+0x9d>
  8023b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b4:	8b 00                	mov    (%eax),%eax
  8023b6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023b9:	8b 52 04             	mov    0x4(%edx),%edx
  8023bc:	89 50 04             	mov    %edx,0x4(%eax)
  8023bf:	eb 0b                	jmp    8023cc <alloc_block_FF+0xa8>
  8023c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c4:	8b 40 04             	mov    0x4(%eax),%eax
  8023c7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023cf:	8b 40 04             	mov    0x4(%eax),%eax
  8023d2:	85 c0                	test   %eax,%eax
  8023d4:	74 0f                	je     8023e5 <alloc_block_FF+0xc1>
  8023d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d9:	8b 40 04             	mov    0x4(%eax),%eax
  8023dc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023df:	8b 12                	mov    (%edx),%edx
  8023e1:	89 10                	mov    %edx,(%eax)
  8023e3:	eb 0a                	jmp    8023ef <alloc_block_FF+0xcb>
  8023e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	a3 48 41 80 00       	mov    %eax,0x804148
  8023ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802402:	a1 54 41 80 00       	mov    0x804154,%eax
  802407:	48                   	dec    %eax
  802408:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  80240d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802410:	e9 ad 00 00 00       	jmp    8024c2 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802415:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802418:	8b 40 0c             	mov    0xc(%eax),%eax
  80241b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241e:	0f 85 87 00 00 00    	jne    8024ab <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802424:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802428:	75 17                	jne    802441 <alloc_block_FF+0x11d>
  80242a:	83 ec 04             	sub    $0x4,%esp
  80242d:	68 09 3c 80 00       	push   $0x803c09
  802432:	68 87 00 00 00       	push   $0x87
  802437:	68 97 3b 80 00       	push   $0x803b97
  80243c:	e8 41 de ff ff       	call   800282 <_panic>
  802441:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802444:	8b 00                	mov    (%eax),%eax
  802446:	85 c0                	test   %eax,%eax
  802448:	74 10                	je     80245a <alloc_block_FF+0x136>
  80244a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244d:	8b 00                	mov    (%eax),%eax
  80244f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802452:	8b 52 04             	mov    0x4(%edx),%edx
  802455:	89 50 04             	mov    %edx,0x4(%eax)
  802458:	eb 0b                	jmp    802465 <alloc_block_FF+0x141>
  80245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245d:	8b 40 04             	mov    0x4(%eax),%eax
  802460:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802468:	8b 40 04             	mov    0x4(%eax),%eax
  80246b:	85 c0                	test   %eax,%eax
  80246d:	74 0f                	je     80247e <alloc_block_FF+0x15a>
  80246f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802472:	8b 40 04             	mov    0x4(%eax),%eax
  802475:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802478:	8b 12                	mov    (%edx),%edx
  80247a:	89 10                	mov    %edx,(%eax)
  80247c:	eb 0a                	jmp    802488 <alloc_block_FF+0x164>
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 00                	mov    (%eax),%eax
  802483:	a3 38 41 80 00       	mov    %eax,0x804138
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802494:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80249b:	a1 44 41 80 00       	mov    0x804144,%eax
  8024a0:	48                   	dec    %eax
  8024a1:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	eb 17                	jmp    8024c2 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8024ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ae:	8b 00                	mov    (%eax),%eax
  8024b0:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8024b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b7:	0f 85 7a fe ff ff    	jne    802337 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8024bd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024c2:	c9                   	leave  
  8024c3:	c3                   	ret    

008024c4 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024c4:	55                   	push   %ebp
  8024c5:	89 e5                	mov    %esp,%ebp
  8024c7:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8024ca:	a1 38 41 80 00       	mov    0x804138,%eax
  8024cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8024d2:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8024d9:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8024e0:	a1 38 41 80 00       	mov    0x804138,%eax
  8024e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e8:	e9 d0 00 00 00       	jmp    8025bd <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8024ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f0:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f6:	0f 82 b8 00 00 00    	jb     8025b4 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  8024fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802502:	2b 45 08             	sub    0x8(%ebp),%eax
  802505:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802508:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80250e:	0f 83 a1 00 00 00    	jae    8025b5 <alloc_block_BF+0xf1>
				differsize = differance ;
  802514:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802517:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802520:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802524:	0f 85 8b 00 00 00    	jne    8025b5 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  80252a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252e:	75 17                	jne    802547 <alloc_block_BF+0x83>
  802530:	83 ec 04             	sub    $0x4,%esp
  802533:	68 09 3c 80 00       	push   $0x803c09
  802538:	68 a0 00 00 00       	push   $0xa0
  80253d:	68 97 3b 80 00       	push   $0x803b97
  802542:	e8 3b dd ff ff       	call   800282 <_panic>
  802547:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254a:	8b 00                	mov    (%eax),%eax
  80254c:	85 c0                	test   %eax,%eax
  80254e:	74 10                	je     802560 <alloc_block_BF+0x9c>
  802550:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802553:	8b 00                	mov    (%eax),%eax
  802555:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802558:	8b 52 04             	mov    0x4(%edx),%edx
  80255b:	89 50 04             	mov    %edx,0x4(%eax)
  80255e:	eb 0b                	jmp    80256b <alloc_block_BF+0xa7>
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 40 04             	mov    0x4(%eax),%eax
  802566:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80256b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256e:	8b 40 04             	mov    0x4(%eax),%eax
  802571:	85 c0                	test   %eax,%eax
  802573:	74 0f                	je     802584 <alloc_block_BF+0xc0>
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	8b 40 04             	mov    0x4(%eax),%eax
  80257b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257e:	8b 12                	mov    (%edx),%edx
  802580:	89 10                	mov    %edx,(%eax)
  802582:	eb 0a                	jmp    80258e <alloc_block_BF+0xca>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 00                	mov    (%eax),%eax
  802589:	a3 38 41 80 00       	mov    %eax,0x804138
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802597:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a1:	a1 44 41 80 00       	mov    0x804144,%eax
  8025a6:	48                   	dec    %eax
  8025a7:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	e9 0c 01 00 00       	jmp    8026c0 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8025b4:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8025b5:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025bd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c1:	74 07                	je     8025ca <alloc_block_BF+0x106>
  8025c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c6:	8b 00                	mov    (%eax),%eax
  8025c8:	eb 05                	jmp    8025cf <alloc_block_BF+0x10b>
  8025ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cf:	a3 40 41 80 00       	mov    %eax,0x804140
  8025d4:	a1 40 41 80 00       	mov    0x804140,%eax
  8025d9:	85 c0                	test   %eax,%eax
  8025db:	0f 85 0c ff ff ff    	jne    8024ed <alloc_block_BF+0x29>
  8025e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e5:	0f 85 02 ff ff ff    	jne    8024ed <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  8025eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ef:	0f 84 c6 00 00 00    	je     8026bb <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  8025f5:	a1 48 41 80 00       	mov    0x804148,%eax
  8025fa:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  8025fd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802600:	8b 55 08             	mov    0x8(%ebp),%edx
  802603:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802609:	8b 50 08             	mov    0x8(%eax),%edx
  80260c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80260f:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802615:	8b 40 0c             	mov    0xc(%eax),%eax
  802618:	2b 45 08             	sub    0x8(%ebp),%eax
  80261b:	89 c2                	mov    %eax,%edx
  80261d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802620:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802626:	8b 50 08             	mov    0x8(%eax),%edx
  802629:	8b 45 08             	mov    0x8(%ebp),%eax
  80262c:	01 c2                	add    %eax,%edx
  80262e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802631:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802634:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802638:	75 17                	jne    802651 <alloc_block_BF+0x18d>
  80263a:	83 ec 04             	sub    $0x4,%esp
  80263d:	68 09 3c 80 00       	push   $0x803c09
  802642:	68 af 00 00 00       	push   $0xaf
  802647:	68 97 3b 80 00       	push   $0x803b97
  80264c:	e8 31 dc ff ff       	call   800282 <_panic>
  802651:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802654:	8b 00                	mov    (%eax),%eax
  802656:	85 c0                	test   %eax,%eax
  802658:	74 10                	je     80266a <alloc_block_BF+0x1a6>
  80265a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265d:	8b 00                	mov    (%eax),%eax
  80265f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802662:	8b 52 04             	mov    0x4(%edx),%edx
  802665:	89 50 04             	mov    %edx,0x4(%eax)
  802668:	eb 0b                	jmp    802675 <alloc_block_BF+0x1b1>
  80266a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266d:	8b 40 04             	mov    0x4(%eax),%eax
  802670:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802675:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802678:	8b 40 04             	mov    0x4(%eax),%eax
  80267b:	85 c0                	test   %eax,%eax
  80267d:	74 0f                	je     80268e <alloc_block_BF+0x1ca>
  80267f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802682:	8b 40 04             	mov    0x4(%eax),%eax
  802685:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802688:	8b 12                	mov    (%edx),%edx
  80268a:	89 10                	mov    %edx,(%eax)
  80268c:	eb 0a                	jmp    802698 <alloc_block_BF+0x1d4>
  80268e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802691:	8b 00                	mov    (%eax),%eax
  802693:	a3 48 41 80 00       	mov    %eax,0x804148
  802698:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80269b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026ab:	a1 54 41 80 00       	mov    0x804154,%eax
  8026b0:	48                   	dec    %eax
  8026b1:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8026b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b9:	eb 05                	jmp    8026c0 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8026bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026c0:	c9                   	leave  
  8026c1:	c3                   	ret    

008026c2 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8026c2:	55                   	push   %ebp
  8026c3:	89 e5                	mov    %esp,%ebp
  8026c5:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8026c8:	a1 38 41 80 00       	mov    0x804138,%eax
  8026cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8026d0:	e9 7c 01 00 00       	jmp    802851 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8026d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026de:	0f 86 cf 00 00 00    	jbe    8027b3 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8026e4:	a1 48 41 80 00       	mov    0x804148,%eax
  8026e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8026ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  8026f2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f8:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  8026fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fe:	8b 50 08             	mov    0x8(%eax),%edx
  802701:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802704:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	8b 40 0c             	mov    0xc(%eax),%eax
  80270d:	2b 45 08             	sub    0x8(%ebp),%eax
  802710:	89 c2                	mov    %eax,%edx
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	8b 50 08             	mov    0x8(%eax),%edx
  80271e:	8b 45 08             	mov    0x8(%ebp),%eax
  802721:	01 c2                	add    %eax,%edx
  802723:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802726:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802729:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80272d:	75 17                	jne    802746 <alloc_block_NF+0x84>
  80272f:	83 ec 04             	sub    $0x4,%esp
  802732:	68 09 3c 80 00       	push   $0x803c09
  802737:	68 c4 00 00 00       	push   $0xc4
  80273c:	68 97 3b 80 00       	push   $0x803b97
  802741:	e8 3c db ff ff       	call   800282 <_panic>
  802746:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802749:	8b 00                	mov    (%eax),%eax
  80274b:	85 c0                	test   %eax,%eax
  80274d:	74 10                	je     80275f <alloc_block_NF+0x9d>
  80274f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802752:	8b 00                	mov    (%eax),%eax
  802754:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802757:	8b 52 04             	mov    0x4(%edx),%edx
  80275a:	89 50 04             	mov    %edx,0x4(%eax)
  80275d:	eb 0b                	jmp    80276a <alloc_block_NF+0xa8>
  80275f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802762:	8b 40 04             	mov    0x4(%eax),%eax
  802765:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80276a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276d:	8b 40 04             	mov    0x4(%eax),%eax
  802770:	85 c0                	test   %eax,%eax
  802772:	74 0f                	je     802783 <alloc_block_NF+0xc1>
  802774:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802777:	8b 40 04             	mov    0x4(%eax),%eax
  80277a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80277d:	8b 12                	mov    (%edx),%edx
  80277f:	89 10                	mov    %edx,(%eax)
  802781:	eb 0a                	jmp    80278d <alloc_block_NF+0xcb>
  802783:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802786:	8b 00                	mov    (%eax),%eax
  802788:	a3 48 41 80 00       	mov    %eax,0x804148
  80278d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802790:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802796:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802799:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027a0:	a1 54 41 80 00       	mov    0x804154,%eax
  8027a5:	48                   	dec    %eax
  8027a6:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8027ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ae:	e9 ad 00 00 00       	jmp    802860 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8027b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027bc:	0f 85 87 00 00 00    	jne    802849 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8027c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c6:	75 17                	jne    8027df <alloc_block_NF+0x11d>
  8027c8:	83 ec 04             	sub    $0x4,%esp
  8027cb:	68 09 3c 80 00       	push   $0x803c09
  8027d0:	68 c8 00 00 00       	push   $0xc8
  8027d5:	68 97 3b 80 00       	push   $0x803b97
  8027da:	e8 a3 da ff ff       	call   800282 <_panic>
  8027df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e2:	8b 00                	mov    (%eax),%eax
  8027e4:	85 c0                	test   %eax,%eax
  8027e6:	74 10                	je     8027f8 <alloc_block_NF+0x136>
  8027e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027eb:	8b 00                	mov    (%eax),%eax
  8027ed:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027f0:	8b 52 04             	mov    0x4(%edx),%edx
  8027f3:	89 50 04             	mov    %edx,0x4(%eax)
  8027f6:	eb 0b                	jmp    802803 <alloc_block_NF+0x141>
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 40 04             	mov    0x4(%eax),%eax
  8027fe:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802803:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802806:	8b 40 04             	mov    0x4(%eax),%eax
  802809:	85 c0                	test   %eax,%eax
  80280b:	74 0f                	je     80281c <alloc_block_NF+0x15a>
  80280d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802810:	8b 40 04             	mov    0x4(%eax),%eax
  802813:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802816:	8b 12                	mov    (%edx),%edx
  802818:	89 10                	mov    %edx,(%eax)
  80281a:	eb 0a                	jmp    802826 <alloc_block_NF+0x164>
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 00                	mov    (%eax),%eax
  802821:	a3 38 41 80 00       	mov    %eax,0x804138
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802832:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802839:	a1 44 41 80 00       	mov    0x804144,%eax
  80283e:	48                   	dec    %eax
  80283f:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	eb 17                	jmp    802860 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802849:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284c:	8b 00                	mov    (%eax),%eax
  80284e:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802851:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802855:	0f 85 7a fe ff ff    	jne    8026d5 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  80285b:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802860:	c9                   	leave  
  802861:	c3                   	ret    

00802862 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802862:	55                   	push   %ebp
  802863:	89 e5                	mov    %esp,%ebp
  802865:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802868:	a1 38 41 80 00       	mov    0x804138,%eax
  80286d:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802870:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802875:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802878:	a1 44 41 80 00       	mov    0x804144,%eax
  80287d:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802880:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802884:	75 68                	jne    8028ee <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802886:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80288a:	75 17                	jne    8028a3 <insert_sorted_with_merge_freeList+0x41>
  80288c:	83 ec 04             	sub    $0x4,%esp
  80288f:	68 74 3b 80 00       	push   $0x803b74
  802894:	68 da 00 00 00       	push   $0xda
  802899:	68 97 3b 80 00       	push   $0x803b97
  80289e:	e8 df d9 ff ff       	call   800282 <_panic>
  8028a3:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ac:	89 10                	mov    %edx,(%eax)
  8028ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b1:	8b 00                	mov    (%eax),%eax
  8028b3:	85 c0                	test   %eax,%eax
  8028b5:	74 0d                	je     8028c4 <insert_sorted_with_merge_freeList+0x62>
  8028b7:	a1 38 41 80 00       	mov    0x804138,%eax
  8028bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8028bf:	89 50 04             	mov    %edx,0x4(%eax)
  8028c2:	eb 08                	jmp    8028cc <insert_sorted_with_merge_freeList+0x6a>
  8028c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cf:	a3 38 41 80 00       	mov    %eax,0x804138
  8028d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028de:	a1 44 41 80 00       	mov    0x804144,%eax
  8028e3:	40                   	inc    %eax
  8028e4:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  8028e9:	e9 49 07 00 00       	jmp    803037 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  8028ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f1:	8b 50 08             	mov    0x8(%eax),%edx
  8028f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f7:	8b 40 0c             	mov    0xc(%eax),%eax
  8028fa:	01 c2                	add    %eax,%edx
  8028fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ff:	8b 40 08             	mov    0x8(%eax),%eax
  802902:	39 c2                	cmp    %eax,%edx
  802904:	73 77                	jae    80297d <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802906:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802909:	8b 00                	mov    (%eax),%eax
  80290b:	85 c0                	test   %eax,%eax
  80290d:	75 6e                	jne    80297d <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  80290f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802913:	74 68                	je     80297d <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802915:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802919:	75 17                	jne    802932 <insert_sorted_with_merge_freeList+0xd0>
  80291b:	83 ec 04             	sub    $0x4,%esp
  80291e:	68 b0 3b 80 00       	push   $0x803bb0
  802923:	68 e0 00 00 00       	push   $0xe0
  802928:	68 97 3b 80 00       	push   $0x803b97
  80292d:	e8 50 d9 ff ff       	call   800282 <_panic>
  802932:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802938:	8b 45 08             	mov    0x8(%ebp),%eax
  80293b:	89 50 04             	mov    %edx,0x4(%eax)
  80293e:	8b 45 08             	mov    0x8(%ebp),%eax
  802941:	8b 40 04             	mov    0x4(%eax),%eax
  802944:	85 c0                	test   %eax,%eax
  802946:	74 0c                	je     802954 <insert_sorted_with_merge_freeList+0xf2>
  802948:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80294d:	8b 55 08             	mov    0x8(%ebp),%edx
  802950:	89 10                	mov    %edx,(%eax)
  802952:	eb 08                	jmp    80295c <insert_sorted_with_merge_freeList+0xfa>
  802954:	8b 45 08             	mov    0x8(%ebp),%eax
  802957:	a3 38 41 80 00       	mov    %eax,0x804138
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802964:	8b 45 08             	mov    0x8(%ebp),%eax
  802967:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296d:	a1 44 41 80 00       	mov    0x804144,%eax
  802972:	40                   	inc    %eax
  802973:	a3 44 41 80 00       	mov    %eax,0x804144
  802978:	e9 ba 06 00 00       	jmp    803037 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  80297d:	8b 45 08             	mov    0x8(%ebp),%eax
  802980:	8b 50 0c             	mov    0xc(%eax),%edx
  802983:	8b 45 08             	mov    0x8(%ebp),%eax
  802986:	8b 40 08             	mov    0x8(%eax),%eax
  802989:	01 c2                	add    %eax,%edx
  80298b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298e:	8b 40 08             	mov    0x8(%eax),%eax
  802991:	39 c2                	cmp    %eax,%edx
  802993:	73 78                	jae    802a0d <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802995:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802998:	8b 40 04             	mov    0x4(%eax),%eax
  80299b:	85 c0                	test   %eax,%eax
  80299d:	75 6e                	jne    802a0d <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  80299f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029a3:	74 68                	je     802a0d <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8029a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029a9:	75 17                	jne    8029c2 <insert_sorted_with_merge_freeList+0x160>
  8029ab:	83 ec 04             	sub    $0x4,%esp
  8029ae:	68 74 3b 80 00       	push   $0x803b74
  8029b3:	68 e6 00 00 00       	push   $0xe6
  8029b8:	68 97 3b 80 00       	push   $0x803b97
  8029bd:	e8 c0 d8 ff ff       	call   800282 <_panic>
  8029c2:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	89 10                	mov    %edx,(%eax)
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	8b 00                	mov    (%eax),%eax
  8029d2:	85 c0                	test   %eax,%eax
  8029d4:	74 0d                	je     8029e3 <insert_sorted_with_merge_freeList+0x181>
  8029d6:	a1 38 41 80 00       	mov    0x804138,%eax
  8029db:	8b 55 08             	mov    0x8(%ebp),%edx
  8029de:	89 50 04             	mov    %edx,0x4(%eax)
  8029e1:	eb 08                	jmp    8029eb <insert_sorted_with_merge_freeList+0x189>
  8029e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	a3 38 41 80 00       	mov    %eax,0x804138
  8029f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fd:	a1 44 41 80 00       	mov    0x804144,%eax
  802a02:	40                   	inc    %eax
  802a03:	a3 44 41 80 00       	mov    %eax,0x804144
  802a08:	e9 2a 06 00 00       	jmp    803037 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802a0d:	a1 38 41 80 00       	mov    0x804138,%eax
  802a12:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a15:	e9 ed 05 00 00       	jmp    803007 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802a1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1d:	8b 00                	mov    (%eax),%eax
  802a1f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802a22:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a26:	0f 84 a7 00 00 00    	je     802ad3 <insert_sorted_with_merge_freeList+0x271>
  802a2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2f:	8b 50 0c             	mov    0xc(%eax),%edx
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	8b 40 08             	mov    0x8(%eax),%eax
  802a38:	01 c2                	add    %eax,%edx
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	8b 40 08             	mov    0x8(%eax),%eax
  802a40:	39 c2                	cmp    %eax,%edx
  802a42:	0f 83 8b 00 00 00    	jae    802ad3 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802a48:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4b:	8b 50 0c             	mov    0xc(%eax),%edx
  802a4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a51:	8b 40 08             	mov    0x8(%eax),%eax
  802a54:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802a56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a59:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802a5c:	39 c2                	cmp    %eax,%edx
  802a5e:	73 73                	jae    802ad3 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802a60:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a64:	74 06                	je     802a6c <insert_sorted_with_merge_freeList+0x20a>
  802a66:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a6a:	75 17                	jne    802a83 <insert_sorted_with_merge_freeList+0x221>
  802a6c:	83 ec 04             	sub    $0x4,%esp
  802a6f:	68 28 3c 80 00       	push   $0x803c28
  802a74:	68 f0 00 00 00       	push   $0xf0
  802a79:	68 97 3b 80 00       	push   $0x803b97
  802a7e:	e8 ff d7 ff ff       	call   800282 <_panic>
  802a83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a86:	8b 10                	mov    (%eax),%edx
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	89 10                	mov    %edx,(%eax)
  802a8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a90:	8b 00                	mov    (%eax),%eax
  802a92:	85 c0                	test   %eax,%eax
  802a94:	74 0b                	je     802aa1 <insert_sorted_with_merge_freeList+0x23f>
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	8b 00                	mov    (%eax),%eax
  802a9b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9e:	89 50 04             	mov    %edx,0x4(%eax)
  802aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa4:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa7:	89 10                	mov    %edx,(%eax)
  802aa9:	8b 45 08             	mov    0x8(%ebp),%eax
  802aac:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aaf:	89 50 04             	mov    %edx,0x4(%eax)
  802ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab5:	8b 00                	mov    (%eax),%eax
  802ab7:	85 c0                	test   %eax,%eax
  802ab9:	75 08                	jne    802ac3 <insert_sorted_with_merge_freeList+0x261>
  802abb:	8b 45 08             	mov    0x8(%ebp),%eax
  802abe:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ac3:	a1 44 41 80 00       	mov    0x804144,%eax
  802ac8:	40                   	inc    %eax
  802ac9:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802ace:	e9 64 05 00 00       	jmp    803037 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802ad3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ad8:	8b 50 0c             	mov    0xc(%eax),%edx
  802adb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ae0:	8b 40 08             	mov    0x8(%eax),%eax
  802ae3:	01 c2                	add    %eax,%edx
  802ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae8:	8b 40 08             	mov    0x8(%eax),%eax
  802aeb:	39 c2                	cmp    %eax,%edx
  802aed:	0f 85 b1 00 00 00    	jne    802ba4 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802af3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802af8:	85 c0                	test   %eax,%eax
  802afa:	0f 84 a4 00 00 00    	je     802ba4 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802b00:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	85 c0                	test   %eax,%eax
  802b09:	0f 85 95 00 00 00    	jne    802ba4 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802b0f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b14:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b1a:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  802b20:	8b 52 0c             	mov    0xc(%edx),%edx
  802b23:	01 ca                	add    %ecx,%edx
  802b25:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802b28:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802b32:	8b 45 08             	mov    0x8(%ebp),%eax
  802b35:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802b3c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b40:	75 17                	jne    802b59 <insert_sorted_with_merge_freeList+0x2f7>
  802b42:	83 ec 04             	sub    $0x4,%esp
  802b45:	68 74 3b 80 00       	push   $0x803b74
  802b4a:	68 ff 00 00 00       	push   $0xff
  802b4f:	68 97 3b 80 00       	push   $0x803b97
  802b54:	e8 29 d7 ff ff       	call   800282 <_panic>
  802b59:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b62:	89 10                	mov    %edx,(%eax)
  802b64:	8b 45 08             	mov    0x8(%ebp),%eax
  802b67:	8b 00                	mov    (%eax),%eax
  802b69:	85 c0                	test   %eax,%eax
  802b6b:	74 0d                	je     802b7a <insert_sorted_with_merge_freeList+0x318>
  802b6d:	a1 48 41 80 00       	mov    0x804148,%eax
  802b72:	8b 55 08             	mov    0x8(%ebp),%edx
  802b75:	89 50 04             	mov    %edx,0x4(%eax)
  802b78:	eb 08                	jmp    802b82 <insert_sorted_with_merge_freeList+0x320>
  802b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b82:	8b 45 08             	mov    0x8(%ebp),%eax
  802b85:	a3 48 41 80 00       	mov    %eax,0x804148
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b94:	a1 54 41 80 00       	mov    0x804154,%eax
  802b99:	40                   	inc    %eax
  802b9a:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802b9f:	e9 93 04 00 00       	jmp    803037 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	8b 50 08             	mov    0x8(%eax),%edx
  802baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bad:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb0:	01 c2                	add    %eax,%edx
  802bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb5:	8b 40 08             	mov    0x8(%eax),%eax
  802bb8:	39 c2                	cmp    %eax,%edx
  802bba:	0f 85 ae 00 00 00    	jne    802c6e <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	8b 50 0c             	mov    0xc(%eax),%edx
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	8b 40 08             	mov    0x8(%eax),%eax
  802bcc:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	8b 00                	mov    (%eax),%eax
  802bd3:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802bd6:	39 c2                	cmp    %eax,%edx
  802bd8:	0f 84 90 00 00 00    	je     802c6e <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be1:	8b 50 0c             	mov    0xc(%eax),%edx
  802be4:	8b 45 08             	mov    0x8(%ebp),%eax
  802be7:	8b 40 0c             	mov    0xc(%eax),%eax
  802bea:	01 c2                	add    %eax,%edx
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c0a:	75 17                	jne    802c23 <insert_sorted_with_merge_freeList+0x3c1>
  802c0c:	83 ec 04             	sub    $0x4,%esp
  802c0f:	68 74 3b 80 00       	push   $0x803b74
  802c14:	68 0b 01 00 00       	push   $0x10b
  802c19:	68 97 3b 80 00       	push   $0x803b97
  802c1e:	e8 5f d6 ff ff       	call   800282 <_panic>
  802c23:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c29:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2c:	89 10                	mov    %edx,(%eax)
  802c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c31:	8b 00                	mov    (%eax),%eax
  802c33:	85 c0                	test   %eax,%eax
  802c35:	74 0d                	je     802c44 <insert_sorted_with_merge_freeList+0x3e2>
  802c37:	a1 48 41 80 00       	mov    0x804148,%eax
  802c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c3f:	89 50 04             	mov    %edx,0x4(%eax)
  802c42:	eb 08                	jmp    802c4c <insert_sorted_with_merge_freeList+0x3ea>
  802c44:	8b 45 08             	mov    0x8(%ebp),%eax
  802c47:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4f:	a3 48 41 80 00       	mov    %eax,0x804148
  802c54:	8b 45 08             	mov    0x8(%ebp),%eax
  802c57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5e:	a1 54 41 80 00       	mov    0x804154,%eax
  802c63:	40                   	inc    %eax
  802c64:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802c69:	e9 c9 03 00 00       	jmp    803037 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c71:	8b 50 0c             	mov    0xc(%eax),%edx
  802c74:	8b 45 08             	mov    0x8(%ebp),%eax
  802c77:	8b 40 08             	mov    0x8(%eax),%eax
  802c7a:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802c7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7f:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802c82:	39 c2                	cmp    %eax,%edx
  802c84:	0f 85 bb 00 00 00    	jne    802d45 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802c8a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8e:	0f 84 b1 00 00 00    	je     802d45 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 40 04             	mov    0x4(%eax),%eax
  802c9a:	85 c0                	test   %eax,%eax
  802c9c:	0f 85 a3 00 00 00    	jne    802d45 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ca2:	a1 38 41 80 00       	mov    0x804138,%eax
  802ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  802caa:	8b 52 08             	mov    0x8(%edx),%edx
  802cad:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802cb0:	a1 38 41 80 00       	mov    0x804138,%eax
  802cb5:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cbb:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802cbe:	8b 55 08             	mov    0x8(%ebp),%edx
  802cc1:	8b 52 0c             	mov    0xc(%edx),%edx
  802cc4:	01 ca                	add    %ecx,%edx
  802cc6:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802cc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802cdd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ce1:	75 17                	jne    802cfa <insert_sorted_with_merge_freeList+0x498>
  802ce3:	83 ec 04             	sub    $0x4,%esp
  802ce6:	68 74 3b 80 00       	push   $0x803b74
  802ceb:	68 17 01 00 00       	push   $0x117
  802cf0:	68 97 3b 80 00       	push   $0x803b97
  802cf5:	e8 88 d5 ff ff       	call   800282 <_panic>
  802cfa:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	89 10                	mov    %edx,(%eax)
  802d05:	8b 45 08             	mov    0x8(%ebp),%eax
  802d08:	8b 00                	mov    (%eax),%eax
  802d0a:	85 c0                	test   %eax,%eax
  802d0c:	74 0d                	je     802d1b <insert_sorted_with_merge_freeList+0x4b9>
  802d0e:	a1 48 41 80 00       	mov    0x804148,%eax
  802d13:	8b 55 08             	mov    0x8(%ebp),%edx
  802d16:	89 50 04             	mov    %edx,0x4(%eax)
  802d19:	eb 08                	jmp    802d23 <insert_sorted_with_merge_freeList+0x4c1>
  802d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d23:	8b 45 08             	mov    0x8(%ebp),%eax
  802d26:	a3 48 41 80 00       	mov    %eax,0x804148
  802d2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d35:	a1 54 41 80 00       	mov    0x804154,%eax
  802d3a:	40                   	inc    %eax
  802d3b:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d40:	e9 f2 02 00 00       	jmp    803037 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	8b 50 08             	mov    0x8(%eax),%edx
  802d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d51:	01 c2                	add    %eax,%edx
  802d53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d56:	8b 40 08             	mov    0x8(%eax),%eax
  802d59:	39 c2                	cmp    %eax,%edx
  802d5b:	0f 85 be 00 00 00    	jne    802e1f <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 40 04             	mov    0x4(%eax),%eax
  802d67:	8b 50 08             	mov    0x8(%eax),%edx
  802d6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6d:	8b 40 04             	mov    0x4(%eax),%eax
  802d70:	8b 40 0c             	mov    0xc(%eax),%eax
  802d73:	01 c2                	add    %eax,%edx
  802d75:	8b 45 08             	mov    0x8(%ebp),%eax
  802d78:	8b 40 08             	mov    0x8(%eax),%eax
  802d7b:	39 c2                	cmp    %eax,%edx
  802d7d:	0f 84 9c 00 00 00    	je     802e1f <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	8b 50 08             	mov    0x8(%eax),%edx
  802d89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8c:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802d8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d92:	8b 50 0c             	mov    0xc(%eax),%edx
  802d95:	8b 45 08             	mov    0x8(%ebp),%eax
  802d98:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9b:	01 c2                	add    %eax,%edx
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802dad:	8b 45 08             	mov    0x8(%ebp),%eax
  802db0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802db7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbb:	75 17                	jne    802dd4 <insert_sorted_with_merge_freeList+0x572>
  802dbd:	83 ec 04             	sub    $0x4,%esp
  802dc0:	68 74 3b 80 00       	push   $0x803b74
  802dc5:	68 26 01 00 00       	push   $0x126
  802dca:	68 97 3b 80 00       	push   $0x803b97
  802dcf:	e8 ae d4 ff ff       	call   800282 <_panic>
  802dd4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dda:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddd:	89 10                	mov    %edx,(%eax)
  802ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  802de2:	8b 00                	mov    (%eax),%eax
  802de4:	85 c0                	test   %eax,%eax
  802de6:	74 0d                	je     802df5 <insert_sorted_with_merge_freeList+0x593>
  802de8:	a1 48 41 80 00       	mov    0x804148,%eax
  802ded:	8b 55 08             	mov    0x8(%ebp),%edx
  802df0:	89 50 04             	mov    %edx,0x4(%eax)
  802df3:	eb 08                	jmp    802dfd <insert_sorted_with_merge_freeList+0x59b>
  802df5:	8b 45 08             	mov    0x8(%ebp),%eax
  802df8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802e00:	a3 48 41 80 00       	mov    %eax,0x804148
  802e05:	8b 45 08             	mov    0x8(%ebp),%eax
  802e08:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0f:	a1 54 41 80 00       	mov    0x804154,%eax
  802e14:	40                   	inc    %eax
  802e15:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802e1a:	e9 18 02 00 00       	jmp    803037 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802e1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e22:	8b 50 0c             	mov    0xc(%eax),%edx
  802e25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e28:	8b 40 08             	mov    0x8(%eax),%eax
  802e2b:	01 c2                	add    %eax,%edx
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	8b 40 08             	mov    0x8(%eax),%eax
  802e33:	39 c2                	cmp    %eax,%edx
  802e35:	0f 85 c4 01 00 00    	jne    802fff <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	8b 40 08             	mov    0x8(%eax),%eax
  802e47:	01 c2                	add    %eax,%edx
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	8b 00                	mov    (%eax),%eax
  802e4e:	8b 40 08             	mov    0x8(%eax),%eax
  802e51:	39 c2                	cmp    %eax,%edx
  802e53:	0f 85 a6 01 00 00    	jne    802fff <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802e59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5d:	0f 84 9c 01 00 00    	je     802fff <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802e63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e66:	8b 50 0c             	mov    0xc(%eax),%edx
  802e69:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6f:	01 c2                	add    %eax,%edx
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 00                	mov    (%eax),%eax
  802e76:	8b 40 0c             	mov    0xc(%eax),%eax
  802e79:	01 c2                	add    %eax,%edx
  802e7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7e:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802e81:	8b 45 08             	mov    0x8(%ebp),%eax
  802e84:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802e95:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e99:	75 17                	jne    802eb2 <insert_sorted_with_merge_freeList+0x650>
  802e9b:	83 ec 04             	sub    $0x4,%esp
  802e9e:	68 74 3b 80 00       	push   $0x803b74
  802ea3:	68 32 01 00 00       	push   $0x132
  802ea8:	68 97 3b 80 00       	push   $0x803b97
  802ead:	e8 d0 d3 ff ff       	call   800282 <_panic>
  802eb2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	89 10                	mov    %edx,(%eax)
  802ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec0:	8b 00                	mov    (%eax),%eax
  802ec2:	85 c0                	test   %eax,%eax
  802ec4:	74 0d                	je     802ed3 <insert_sorted_with_merge_freeList+0x671>
  802ec6:	a1 48 41 80 00       	mov    0x804148,%eax
  802ecb:	8b 55 08             	mov    0x8(%ebp),%edx
  802ece:	89 50 04             	mov    %edx,0x4(%eax)
  802ed1:	eb 08                	jmp    802edb <insert_sorted_with_merge_freeList+0x679>
  802ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802edb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ede:	a3 48 41 80 00       	mov    %eax,0x804148
  802ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eed:	a1 54 41 80 00       	mov    0x804154,%eax
  802ef2:	40                   	inc    %eax
  802ef3:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802ef8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efb:	8b 00                	mov    (%eax),%eax
  802efd:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802f04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f07:	8b 00                	mov    (%eax),%eax
  802f09:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802f10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f13:	8b 00                	mov    (%eax),%eax
  802f15:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802f18:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f1c:	75 17                	jne    802f35 <insert_sorted_with_merge_freeList+0x6d3>
  802f1e:	83 ec 04             	sub    $0x4,%esp
  802f21:	68 09 3c 80 00       	push   $0x803c09
  802f26:	68 36 01 00 00       	push   $0x136
  802f2b:	68 97 3b 80 00       	push   $0x803b97
  802f30:	e8 4d d3 ff ff       	call   800282 <_panic>
  802f35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f38:	8b 00                	mov    (%eax),%eax
  802f3a:	85 c0                	test   %eax,%eax
  802f3c:	74 10                	je     802f4e <insert_sorted_with_merge_freeList+0x6ec>
  802f3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f41:	8b 00                	mov    (%eax),%eax
  802f43:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f46:	8b 52 04             	mov    0x4(%edx),%edx
  802f49:	89 50 04             	mov    %edx,0x4(%eax)
  802f4c:	eb 0b                	jmp    802f59 <insert_sorted_with_merge_freeList+0x6f7>
  802f4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f51:	8b 40 04             	mov    0x4(%eax),%eax
  802f54:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f5c:	8b 40 04             	mov    0x4(%eax),%eax
  802f5f:	85 c0                	test   %eax,%eax
  802f61:	74 0f                	je     802f72 <insert_sorted_with_merge_freeList+0x710>
  802f63:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f66:	8b 40 04             	mov    0x4(%eax),%eax
  802f69:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f6c:	8b 12                	mov    (%edx),%edx
  802f6e:	89 10                	mov    %edx,(%eax)
  802f70:	eb 0a                	jmp    802f7c <insert_sorted_with_merge_freeList+0x71a>
  802f72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f75:	8b 00                	mov    (%eax),%eax
  802f77:	a3 38 41 80 00       	mov    %eax,0x804138
  802f7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f85:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f88:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8f:	a1 44 41 80 00       	mov    0x804144,%eax
  802f94:	48                   	dec    %eax
  802f95:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  802f9a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f9e:	75 17                	jne    802fb7 <insert_sorted_with_merge_freeList+0x755>
  802fa0:	83 ec 04             	sub    $0x4,%esp
  802fa3:	68 74 3b 80 00       	push   $0x803b74
  802fa8:	68 37 01 00 00       	push   $0x137
  802fad:	68 97 3b 80 00       	push   $0x803b97
  802fb2:	e8 cb d2 ff ff       	call   800282 <_panic>
  802fb7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fbd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc0:	89 10                	mov    %edx,(%eax)
  802fc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc5:	8b 00                	mov    (%eax),%eax
  802fc7:	85 c0                	test   %eax,%eax
  802fc9:	74 0d                	je     802fd8 <insert_sorted_with_merge_freeList+0x776>
  802fcb:	a1 48 41 80 00       	mov    0x804148,%eax
  802fd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fd3:	89 50 04             	mov    %edx,0x4(%eax)
  802fd6:	eb 08                	jmp    802fe0 <insert_sorted_with_merge_freeList+0x77e>
  802fd8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fdb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fe0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe3:	a3 48 41 80 00       	mov    %eax,0x804148
  802fe8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802feb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff2:	a1 54 41 80 00       	mov    0x804154,%eax
  802ff7:	40                   	inc    %eax
  802ff8:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  802ffd:	eb 38                	jmp    803037 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802fff:	a1 40 41 80 00       	mov    0x804140,%eax
  803004:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803007:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80300b:	74 07                	je     803014 <insert_sorted_with_merge_freeList+0x7b2>
  80300d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803010:	8b 00                	mov    (%eax),%eax
  803012:	eb 05                	jmp    803019 <insert_sorted_with_merge_freeList+0x7b7>
  803014:	b8 00 00 00 00       	mov    $0x0,%eax
  803019:	a3 40 41 80 00       	mov    %eax,0x804140
  80301e:	a1 40 41 80 00       	mov    0x804140,%eax
  803023:	85 c0                	test   %eax,%eax
  803025:	0f 85 ef f9 ff ff    	jne    802a1a <insert_sorted_with_merge_freeList+0x1b8>
  80302b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302f:	0f 85 e5 f9 ff ff    	jne    802a1a <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803035:	eb 00                	jmp    803037 <insert_sorted_with_merge_freeList+0x7d5>
  803037:	90                   	nop
  803038:	c9                   	leave  
  803039:	c3                   	ret    
  80303a:	66 90                	xchg   %ax,%ax

0080303c <__udivdi3>:
  80303c:	55                   	push   %ebp
  80303d:	57                   	push   %edi
  80303e:	56                   	push   %esi
  80303f:	53                   	push   %ebx
  803040:	83 ec 1c             	sub    $0x1c,%esp
  803043:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803047:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80304b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80304f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803053:	89 ca                	mov    %ecx,%edx
  803055:	89 f8                	mov    %edi,%eax
  803057:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80305b:	85 f6                	test   %esi,%esi
  80305d:	75 2d                	jne    80308c <__udivdi3+0x50>
  80305f:	39 cf                	cmp    %ecx,%edi
  803061:	77 65                	ja     8030c8 <__udivdi3+0x8c>
  803063:	89 fd                	mov    %edi,%ebp
  803065:	85 ff                	test   %edi,%edi
  803067:	75 0b                	jne    803074 <__udivdi3+0x38>
  803069:	b8 01 00 00 00       	mov    $0x1,%eax
  80306e:	31 d2                	xor    %edx,%edx
  803070:	f7 f7                	div    %edi
  803072:	89 c5                	mov    %eax,%ebp
  803074:	31 d2                	xor    %edx,%edx
  803076:	89 c8                	mov    %ecx,%eax
  803078:	f7 f5                	div    %ebp
  80307a:	89 c1                	mov    %eax,%ecx
  80307c:	89 d8                	mov    %ebx,%eax
  80307e:	f7 f5                	div    %ebp
  803080:	89 cf                	mov    %ecx,%edi
  803082:	89 fa                	mov    %edi,%edx
  803084:	83 c4 1c             	add    $0x1c,%esp
  803087:	5b                   	pop    %ebx
  803088:	5e                   	pop    %esi
  803089:	5f                   	pop    %edi
  80308a:	5d                   	pop    %ebp
  80308b:	c3                   	ret    
  80308c:	39 ce                	cmp    %ecx,%esi
  80308e:	77 28                	ja     8030b8 <__udivdi3+0x7c>
  803090:	0f bd fe             	bsr    %esi,%edi
  803093:	83 f7 1f             	xor    $0x1f,%edi
  803096:	75 40                	jne    8030d8 <__udivdi3+0x9c>
  803098:	39 ce                	cmp    %ecx,%esi
  80309a:	72 0a                	jb     8030a6 <__udivdi3+0x6a>
  80309c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8030a0:	0f 87 9e 00 00 00    	ja     803144 <__udivdi3+0x108>
  8030a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8030ab:	89 fa                	mov    %edi,%edx
  8030ad:	83 c4 1c             	add    $0x1c,%esp
  8030b0:	5b                   	pop    %ebx
  8030b1:	5e                   	pop    %esi
  8030b2:	5f                   	pop    %edi
  8030b3:	5d                   	pop    %ebp
  8030b4:	c3                   	ret    
  8030b5:	8d 76 00             	lea    0x0(%esi),%esi
  8030b8:	31 ff                	xor    %edi,%edi
  8030ba:	31 c0                	xor    %eax,%eax
  8030bc:	89 fa                	mov    %edi,%edx
  8030be:	83 c4 1c             	add    $0x1c,%esp
  8030c1:	5b                   	pop    %ebx
  8030c2:	5e                   	pop    %esi
  8030c3:	5f                   	pop    %edi
  8030c4:	5d                   	pop    %ebp
  8030c5:	c3                   	ret    
  8030c6:	66 90                	xchg   %ax,%ax
  8030c8:	89 d8                	mov    %ebx,%eax
  8030ca:	f7 f7                	div    %edi
  8030cc:	31 ff                	xor    %edi,%edi
  8030ce:	89 fa                	mov    %edi,%edx
  8030d0:	83 c4 1c             	add    $0x1c,%esp
  8030d3:	5b                   	pop    %ebx
  8030d4:	5e                   	pop    %esi
  8030d5:	5f                   	pop    %edi
  8030d6:	5d                   	pop    %ebp
  8030d7:	c3                   	ret    
  8030d8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030dd:	89 eb                	mov    %ebp,%ebx
  8030df:	29 fb                	sub    %edi,%ebx
  8030e1:	89 f9                	mov    %edi,%ecx
  8030e3:	d3 e6                	shl    %cl,%esi
  8030e5:	89 c5                	mov    %eax,%ebp
  8030e7:	88 d9                	mov    %bl,%cl
  8030e9:	d3 ed                	shr    %cl,%ebp
  8030eb:	89 e9                	mov    %ebp,%ecx
  8030ed:	09 f1                	or     %esi,%ecx
  8030ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030f3:	89 f9                	mov    %edi,%ecx
  8030f5:	d3 e0                	shl    %cl,%eax
  8030f7:	89 c5                	mov    %eax,%ebp
  8030f9:	89 d6                	mov    %edx,%esi
  8030fb:	88 d9                	mov    %bl,%cl
  8030fd:	d3 ee                	shr    %cl,%esi
  8030ff:	89 f9                	mov    %edi,%ecx
  803101:	d3 e2                	shl    %cl,%edx
  803103:	8b 44 24 08          	mov    0x8(%esp),%eax
  803107:	88 d9                	mov    %bl,%cl
  803109:	d3 e8                	shr    %cl,%eax
  80310b:	09 c2                	or     %eax,%edx
  80310d:	89 d0                	mov    %edx,%eax
  80310f:	89 f2                	mov    %esi,%edx
  803111:	f7 74 24 0c          	divl   0xc(%esp)
  803115:	89 d6                	mov    %edx,%esi
  803117:	89 c3                	mov    %eax,%ebx
  803119:	f7 e5                	mul    %ebp
  80311b:	39 d6                	cmp    %edx,%esi
  80311d:	72 19                	jb     803138 <__udivdi3+0xfc>
  80311f:	74 0b                	je     80312c <__udivdi3+0xf0>
  803121:	89 d8                	mov    %ebx,%eax
  803123:	31 ff                	xor    %edi,%edi
  803125:	e9 58 ff ff ff       	jmp    803082 <__udivdi3+0x46>
  80312a:	66 90                	xchg   %ax,%ax
  80312c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803130:	89 f9                	mov    %edi,%ecx
  803132:	d3 e2                	shl    %cl,%edx
  803134:	39 c2                	cmp    %eax,%edx
  803136:	73 e9                	jae    803121 <__udivdi3+0xe5>
  803138:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80313b:	31 ff                	xor    %edi,%edi
  80313d:	e9 40 ff ff ff       	jmp    803082 <__udivdi3+0x46>
  803142:	66 90                	xchg   %ax,%ax
  803144:	31 c0                	xor    %eax,%eax
  803146:	e9 37 ff ff ff       	jmp    803082 <__udivdi3+0x46>
  80314b:	90                   	nop

0080314c <__umoddi3>:
  80314c:	55                   	push   %ebp
  80314d:	57                   	push   %edi
  80314e:	56                   	push   %esi
  80314f:	53                   	push   %ebx
  803150:	83 ec 1c             	sub    $0x1c,%esp
  803153:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803157:	8b 74 24 34          	mov    0x34(%esp),%esi
  80315b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80315f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803163:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803167:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80316b:	89 f3                	mov    %esi,%ebx
  80316d:	89 fa                	mov    %edi,%edx
  80316f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803173:	89 34 24             	mov    %esi,(%esp)
  803176:	85 c0                	test   %eax,%eax
  803178:	75 1a                	jne    803194 <__umoddi3+0x48>
  80317a:	39 f7                	cmp    %esi,%edi
  80317c:	0f 86 a2 00 00 00    	jbe    803224 <__umoddi3+0xd8>
  803182:	89 c8                	mov    %ecx,%eax
  803184:	89 f2                	mov    %esi,%edx
  803186:	f7 f7                	div    %edi
  803188:	89 d0                	mov    %edx,%eax
  80318a:	31 d2                	xor    %edx,%edx
  80318c:	83 c4 1c             	add    $0x1c,%esp
  80318f:	5b                   	pop    %ebx
  803190:	5e                   	pop    %esi
  803191:	5f                   	pop    %edi
  803192:	5d                   	pop    %ebp
  803193:	c3                   	ret    
  803194:	39 f0                	cmp    %esi,%eax
  803196:	0f 87 ac 00 00 00    	ja     803248 <__umoddi3+0xfc>
  80319c:	0f bd e8             	bsr    %eax,%ebp
  80319f:	83 f5 1f             	xor    $0x1f,%ebp
  8031a2:	0f 84 ac 00 00 00    	je     803254 <__umoddi3+0x108>
  8031a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8031ad:	29 ef                	sub    %ebp,%edi
  8031af:	89 fe                	mov    %edi,%esi
  8031b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031b5:	89 e9                	mov    %ebp,%ecx
  8031b7:	d3 e0                	shl    %cl,%eax
  8031b9:	89 d7                	mov    %edx,%edi
  8031bb:	89 f1                	mov    %esi,%ecx
  8031bd:	d3 ef                	shr    %cl,%edi
  8031bf:	09 c7                	or     %eax,%edi
  8031c1:	89 e9                	mov    %ebp,%ecx
  8031c3:	d3 e2                	shl    %cl,%edx
  8031c5:	89 14 24             	mov    %edx,(%esp)
  8031c8:	89 d8                	mov    %ebx,%eax
  8031ca:	d3 e0                	shl    %cl,%eax
  8031cc:	89 c2                	mov    %eax,%edx
  8031ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031d2:	d3 e0                	shl    %cl,%eax
  8031d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031dc:	89 f1                	mov    %esi,%ecx
  8031de:	d3 e8                	shr    %cl,%eax
  8031e0:	09 d0                	or     %edx,%eax
  8031e2:	d3 eb                	shr    %cl,%ebx
  8031e4:	89 da                	mov    %ebx,%edx
  8031e6:	f7 f7                	div    %edi
  8031e8:	89 d3                	mov    %edx,%ebx
  8031ea:	f7 24 24             	mull   (%esp)
  8031ed:	89 c6                	mov    %eax,%esi
  8031ef:	89 d1                	mov    %edx,%ecx
  8031f1:	39 d3                	cmp    %edx,%ebx
  8031f3:	0f 82 87 00 00 00    	jb     803280 <__umoddi3+0x134>
  8031f9:	0f 84 91 00 00 00    	je     803290 <__umoddi3+0x144>
  8031ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  803203:	29 f2                	sub    %esi,%edx
  803205:	19 cb                	sbb    %ecx,%ebx
  803207:	89 d8                	mov    %ebx,%eax
  803209:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80320d:	d3 e0                	shl    %cl,%eax
  80320f:	89 e9                	mov    %ebp,%ecx
  803211:	d3 ea                	shr    %cl,%edx
  803213:	09 d0                	or     %edx,%eax
  803215:	89 e9                	mov    %ebp,%ecx
  803217:	d3 eb                	shr    %cl,%ebx
  803219:	89 da                	mov    %ebx,%edx
  80321b:	83 c4 1c             	add    $0x1c,%esp
  80321e:	5b                   	pop    %ebx
  80321f:	5e                   	pop    %esi
  803220:	5f                   	pop    %edi
  803221:	5d                   	pop    %ebp
  803222:	c3                   	ret    
  803223:	90                   	nop
  803224:	89 fd                	mov    %edi,%ebp
  803226:	85 ff                	test   %edi,%edi
  803228:	75 0b                	jne    803235 <__umoddi3+0xe9>
  80322a:	b8 01 00 00 00       	mov    $0x1,%eax
  80322f:	31 d2                	xor    %edx,%edx
  803231:	f7 f7                	div    %edi
  803233:	89 c5                	mov    %eax,%ebp
  803235:	89 f0                	mov    %esi,%eax
  803237:	31 d2                	xor    %edx,%edx
  803239:	f7 f5                	div    %ebp
  80323b:	89 c8                	mov    %ecx,%eax
  80323d:	f7 f5                	div    %ebp
  80323f:	89 d0                	mov    %edx,%eax
  803241:	e9 44 ff ff ff       	jmp    80318a <__umoddi3+0x3e>
  803246:	66 90                	xchg   %ax,%ax
  803248:	89 c8                	mov    %ecx,%eax
  80324a:	89 f2                	mov    %esi,%edx
  80324c:	83 c4 1c             	add    $0x1c,%esp
  80324f:	5b                   	pop    %ebx
  803250:	5e                   	pop    %esi
  803251:	5f                   	pop    %edi
  803252:	5d                   	pop    %ebp
  803253:	c3                   	ret    
  803254:	3b 04 24             	cmp    (%esp),%eax
  803257:	72 06                	jb     80325f <__umoddi3+0x113>
  803259:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80325d:	77 0f                	ja     80326e <__umoddi3+0x122>
  80325f:	89 f2                	mov    %esi,%edx
  803261:	29 f9                	sub    %edi,%ecx
  803263:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803267:	89 14 24             	mov    %edx,(%esp)
  80326a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80326e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803272:	8b 14 24             	mov    (%esp),%edx
  803275:	83 c4 1c             	add    $0x1c,%esp
  803278:	5b                   	pop    %ebx
  803279:	5e                   	pop    %esi
  80327a:	5f                   	pop    %edi
  80327b:	5d                   	pop    %ebp
  80327c:	c3                   	ret    
  80327d:	8d 76 00             	lea    0x0(%esi),%esi
  803280:	2b 04 24             	sub    (%esp),%eax
  803283:	19 fa                	sbb    %edi,%edx
  803285:	89 d1                	mov    %edx,%ecx
  803287:	89 c6                	mov    %eax,%esi
  803289:	e9 71 ff ff ff       	jmp    8031ff <__umoddi3+0xb3>
  80328e:	66 90                	xchg   %ax,%ax
  803290:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803294:	72 ea                	jb     803280 <__umoddi3+0x134>
  803296:	89 d9                	mov    %ebx,%ecx
  803298:	e9 62 ff ff ff       	jmp    8031ff <__umoddi3+0xb3>
