
obj/user/tst_envfree4:     file format elf32-i386


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
  800031:	e8 0d 01 00 00       	call   800143 <libmain>
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
	// Testing scenario 4: Freeing the allocated semaphores
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 a0 32 80 00       	push   $0x8032a0
  80004a:	e8 fe 15 00 00       	call   80164d <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 0d 19 00 00       	call   801970 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 a5 19 00 00       	call   801a10 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 b0 32 80 00       	push   $0x8032b0
  800079:	e8 b5 04 00 00       	call   800533 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tsem1", 100,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	6a 64                	push   $0x64
  800091:	68 e3 32 80 00       	push   $0x8032e3
  800096:	e8 47 1b 00 00       	call   801be2 <sys_create_env>
  80009b:	83 c4 10             	add    $0x10,%esp
  80009e:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sys_run_env(envIdProcessA);
  8000a1:	83 ec 0c             	sub    $0xc,%esp
  8000a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8000a7:	e8 54 1b 00 00       	call   801c00 <sys_run_env>
  8000ac:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 1) ;
  8000af:	90                   	nop
  8000b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000b3:	8b 00                	mov    (%eax),%eax
  8000b5:	83 f8 01             	cmp    $0x1,%eax
  8000b8:	75 f6                	jne    8000b0 <_main+0x78>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ba:	e8 b1 18 00 00       	call   801970 <sys_calculate_free_frames>
  8000bf:	83 ec 08             	sub    $0x8,%esp
  8000c2:	50                   	push   %eax
  8000c3:	68 ec 32 80 00       	push   $0x8032ec
  8000c8:	e8 66 04 00 00       	call   800533 <cprintf>
  8000cd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	ff 75 e8             	pushl  -0x18(%ebp)
  8000d6:	e8 41 1b 00 00       	call   801c1c <sys_destroy_env>
  8000db:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  8000de:	e8 8d 18 00 00       	call   801970 <sys_calculate_free_frames>
  8000e3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  8000e6:	e8 25 19 00 00       	call   801a10 <sys_pf_calculate_allocated_pages>
  8000eb:	89 45 e0             	mov    %eax,-0x20(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  8000ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8000f4:	74 27                	je     80011d <_main+0xe5>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  8000f6:	83 ec 08             	sub    $0x8,%esp
  8000f9:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000fc:	68 20 33 80 00       	push   $0x803320
  800101:	e8 2d 04 00 00       	call   800533 <cprintf>
  800106:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800109:	83 ec 04             	sub    $0x4,%esp
  80010c:	68 70 33 80 00       	push   $0x803370
  800111:	6a 1f                	push   $0x1f
  800113:	68 a6 33 80 00       	push   $0x8033a6
  800118:	e8 62 01 00 00       	call   80027f <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	ff 75 e4             	pushl  -0x1c(%ebp)
  800123:	68 bc 33 80 00       	push   $0x8033bc
  800128:	e8 06 04 00 00       	call   800533 <cprintf>
  80012d:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 4 for envfree completed successfully.\n");
  800130:	83 ec 0c             	sub    $0xc,%esp
  800133:	68 1c 34 80 00       	push   $0x80341c
  800138:	e8 f6 03 00 00       	call   800533 <cprintf>
  80013d:	83 c4 10             	add    $0x10,%esp
	return;
  800140:	90                   	nop
}
  800141:	c9                   	leave  
  800142:	c3                   	ret    

00800143 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800143:	55                   	push   %ebp
  800144:	89 e5                	mov    %esp,%ebp
  800146:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800149:	e8 02 1b 00 00       	call   801c50 <sys_getenvindex>
  80014e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800151:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800154:	89 d0                	mov    %edx,%eax
  800156:	c1 e0 03             	shl    $0x3,%eax
  800159:	01 d0                	add    %edx,%eax
  80015b:	01 c0                	add    %eax,%eax
  80015d:	01 d0                	add    %edx,%eax
  80015f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800166:	01 d0                	add    %edx,%eax
  800168:	c1 e0 04             	shl    $0x4,%eax
  80016b:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800170:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800175:	a1 20 40 80 00       	mov    0x804020,%eax
  80017a:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800180:	84 c0                	test   %al,%al
  800182:	74 0f                	je     800193 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800184:	a1 20 40 80 00       	mov    0x804020,%eax
  800189:	05 5c 05 00 00       	add    $0x55c,%eax
  80018e:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800193:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800197:	7e 0a                	jle    8001a3 <libmain+0x60>
		binaryname = argv[0];
  800199:	8b 45 0c             	mov    0xc(%ebp),%eax
  80019c:	8b 00                	mov    (%eax),%eax
  80019e:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001a3:	83 ec 08             	sub    $0x8,%esp
  8001a6:	ff 75 0c             	pushl  0xc(%ebp)
  8001a9:	ff 75 08             	pushl  0x8(%ebp)
  8001ac:	e8 87 fe ff ff       	call   800038 <_main>
  8001b1:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001b4:	e8 a4 18 00 00       	call   801a5d <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b9:	83 ec 0c             	sub    $0xc,%esp
  8001bc:	68 80 34 80 00       	push   $0x803480
  8001c1:	e8 6d 03 00 00       	call   800533 <cprintf>
  8001c6:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ce:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d9:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001df:	83 ec 04             	sub    $0x4,%esp
  8001e2:	52                   	push   %edx
  8001e3:	50                   	push   %eax
  8001e4:	68 a8 34 80 00       	push   $0x8034a8
  8001e9:	e8 45 03 00 00       	call   800533 <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800207:	a1 20 40 80 00       	mov    0x804020,%eax
  80020c:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800212:	51                   	push   %ecx
  800213:	52                   	push   %edx
  800214:	50                   	push   %eax
  800215:	68 d0 34 80 00       	push   $0x8034d0
  80021a:	e8 14 03 00 00       	call   800533 <cprintf>
  80021f:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800222:	a1 20 40 80 00       	mov    0x804020,%eax
  800227:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80022d:	83 ec 08             	sub    $0x8,%esp
  800230:	50                   	push   %eax
  800231:	68 28 35 80 00       	push   $0x803528
  800236:	e8 f8 02 00 00       	call   800533 <cprintf>
  80023b:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80023e:	83 ec 0c             	sub    $0xc,%esp
  800241:	68 80 34 80 00       	push   $0x803480
  800246:	e8 e8 02 00 00       	call   800533 <cprintf>
  80024b:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80024e:	e8 24 18 00 00       	call   801a77 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800253:	e8 19 00 00 00       	call   800271 <exit>
}
  800258:	90                   	nop
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800261:	83 ec 0c             	sub    $0xc,%esp
  800264:	6a 00                	push   $0x0
  800266:	e8 b1 19 00 00       	call   801c1c <sys_destroy_env>
  80026b:	83 c4 10             	add    $0x10,%esp
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <exit>:

void
exit(void)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800277:	e8 06 1a 00 00       	call   801c82 <sys_exit_env>
}
  80027c:	90                   	nop
  80027d:	c9                   	leave  
  80027e:	c3                   	ret    

0080027f <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80027f:	55                   	push   %ebp
  800280:	89 e5                	mov    %esp,%ebp
  800282:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800285:	8d 45 10             	lea    0x10(%ebp),%eax
  800288:	83 c0 04             	add    $0x4,%eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80028e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800293:	85 c0                	test   %eax,%eax
  800295:	74 16                	je     8002ad <_panic+0x2e>
		cprintf("%s: ", argv0);
  800297:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80029c:	83 ec 08             	sub    $0x8,%esp
  80029f:	50                   	push   %eax
  8002a0:	68 3c 35 80 00       	push   $0x80353c
  8002a5:	e8 89 02 00 00       	call   800533 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ad:	a1 00 40 80 00       	mov    0x804000,%eax
  8002b2:	ff 75 0c             	pushl  0xc(%ebp)
  8002b5:	ff 75 08             	pushl  0x8(%ebp)
  8002b8:	50                   	push   %eax
  8002b9:	68 41 35 80 00       	push   $0x803541
  8002be:	e8 70 02 00 00       	call   800533 <cprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c9:	83 ec 08             	sub    $0x8,%esp
  8002cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8002cf:	50                   	push   %eax
  8002d0:	e8 f3 01 00 00       	call   8004c8 <vcprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d8:	83 ec 08             	sub    $0x8,%esp
  8002db:	6a 00                	push   $0x0
  8002dd:	68 5d 35 80 00       	push   $0x80355d
  8002e2:	e8 e1 01 00 00       	call   8004c8 <vcprintf>
  8002e7:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002ea:	e8 82 ff ff ff       	call   800271 <exit>

	// should not return here
	while (1) ;
  8002ef:	eb fe                	jmp    8002ef <_panic+0x70>

008002f1 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002f1:	55                   	push   %ebp
  8002f2:	89 e5                	mov    %esp,%ebp
  8002f4:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002f7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fc:	8b 50 74             	mov    0x74(%eax),%edx
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	39 c2                	cmp    %eax,%edx
  800304:	74 14                	je     80031a <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800306:	83 ec 04             	sub    $0x4,%esp
  800309:	68 60 35 80 00       	push   $0x803560
  80030e:	6a 26                	push   $0x26
  800310:	68 ac 35 80 00       	push   $0x8035ac
  800315:	e8 65 ff ff ff       	call   80027f <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800321:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800328:	e9 c2 00 00 00       	jmp    8003ef <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80032d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800330:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800337:	8b 45 08             	mov    0x8(%ebp),%eax
  80033a:	01 d0                	add    %edx,%eax
  80033c:	8b 00                	mov    (%eax),%eax
  80033e:	85 c0                	test   %eax,%eax
  800340:	75 08                	jne    80034a <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800342:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800345:	e9 a2 00 00 00       	jmp    8003ec <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80034a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800351:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800358:	eb 69                	jmp    8003c3 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80035a:	a1 20 40 80 00       	mov    0x804020,%eax
  80035f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800365:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800368:	89 d0                	mov    %edx,%eax
  80036a:	01 c0                	add    %eax,%eax
  80036c:	01 d0                	add    %edx,%eax
  80036e:	c1 e0 03             	shl    $0x3,%eax
  800371:	01 c8                	add    %ecx,%eax
  800373:	8a 40 04             	mov    0x4(%eax),%al
  800376:	84 c0                	test   %al,%al
  800378:	75 46                	jne    8003c0 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80037a:	a1 20 40 80 00       	mov    0x804020,%eax
  80037f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800385:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800388:	89 d0                	mov    %edx,%eax
  80038a:	01 c0                	add    %eax,%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	c1 e0 03             	shl    $0x3,%eax
  800391:	01 c8                	add    %ecx,%eax
  800393:	8b 00                	mov    (%eax),%eax
  800395:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800398:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80039b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003a0:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003a5:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b3:	39 c2                	cmp    %eax,%edx
  8003b5:	75 09                	jne    8003c0 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003b7:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003be:	eb 12                	jmp    8003d2 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003c0:	ff 45 e8             	incl   -0x18(%ebp)
  8003c3:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c8:	8b 50 74             	mov    0x74(%eax),%edx
  8003cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003ce:	39 c2                	cmp    %eax,%edx
  8003d0:	77 88                	ja     80035a <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003d2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003d6:	75 14                	jne    8003ec <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003d8:	83 ec 04             	sub    $0x4,%esp
  8003db:	68 b8 35 80 00       	push   $0x8035b8
  8003e0:	6a 3a                	push   $0x3a
  8003e2:	68 ac 35 80 00       	push   $0x8035ac
  8003e7:	e8 93 fe ff ff       	call   80027f <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003ec:	ff 45 f0             	incl   -0x10(%ebp)
  8003ef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f2:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003f5:	0f 8c 32 ff ff ff    	jl     80032d <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003fb:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800402:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800409:	eb 26                	jmp    800431 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80040b:	a1 20 40 80 00       	mov    0x804020,%eax
  800410:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800416:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800419:	89 d0                	mov    %edx,%eax
  80041b:	01 c0                	add    %eax,%eax
  80041d:	01 d0                	add    %edx,%eax
  80041f:	c1 e0 03             	shl    $0x3,%eax
  800422:	01 c8                	add    %ecx,%eax
  800424:	8a 40 04             	mov    0x4(%eax),%al
  800427:	3c 01                	cmp    $0x1,%al
  800429:	75 03                	jne    80042e <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80042b:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042e:	ff 45 e0             	incl   -0x20(%ebp)
  800431:	a1 20 40 80 00       	mov    0x804020,%eax
  800436:	8b 50 74             	mov    0x74(%eax),%edx
  800439:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80043c:	39 c2                	cmp    %eax,%edx
  80043e:	77 cb                	ja     80040b <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800440:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800443:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800446:	74 14                	je     80045c <CheckWSWithoutLastIndex+0x16b>
		panic(
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	68 0c 36 80 00       	push   $0x80360c
  800450:	6a 44                	push   $0x44
  800452:	68 ac 35 80 00       	push   $0x8035ac
  800457:	e8 23 fe ff ff       	call   80027f <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80045c:	90                   	nop
  80045d:	c9                   	leave  
  80045e:	c3                   	ret    

0080045f <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80045f:	55                   	push   %ebp
  800460:	89 e5                	mov    %esp,%ebp
  800462:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800465:	8b 45 0c             	mov    0xc(%ebp),%eax
  800468:	8b 00                	mov    (%eax),%eax
  80046a:	8d 48 01             	lea    0x1(%eax),%ecx
  80046d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800470:	89 0a                	mov    %ecx,(%edx)
  800472:	8b 55 08             	mov    0x8(%ebp),%edx
  800475:	88 d1                	mov    %dl,%cl
  800477:	8b 55 0c             	mov    0xc(%ebp),%edx
  80047a:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80047e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800481:	8b 00                	mov    (%eax),%eax
  800483:	3d ff 00 00 00       	cmp    $0xff,%eax
  800488:	75 2c                	jne    8004b6 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80048a:	a0 24 40 80 00       	mov    0x804024,%al
  80048f:	0f b6 c0             	movzbl %al,%eax
  800492:	8b 55 0c             	mov    0xc(%ebp),%edx
  800495:	8b 12                	mov    (%edx),%edx
  800497:	89 d1                	mov    %edx,%ecx
  800499:	8b 55 0c             	mov    0xc(%ebp),%edx
  80049c:	83 c2 08             	add    $0x8,%edx
  80049f:	83 ec 04             	sub    $0x4,%esp
  8004a2:	50                   	push   %eax
  8004a3:	51                   	push   %ecx
  8004a4:	52                   	push   %edx
  8004a5:	e8 05 14 00 00       	call   8018af <sys_cputs>
  8004aa:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b9:	8b 40 04             	mov    0x4(%eax),%eax
  8004bc:	8d 50 01             	lea    0x1(%eax),%edx
  8004bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c2:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004c5:	90                   	nop
  8004c6:	c9                   	leave  
  8004c7:	c3                   	ret    

008004c8 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c8:	55                   	push   %ebp
  8004c9:	89 e5                	mov    %esp,%ebp
  8004cb:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004d1:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d8:	00 00 00 
	b.cnt = 0;
  8004db:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004e2:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004e5:	ff 75 0c             	pushl  0xc(%ebp)
  8004e8:	ff 75 08             	pushl  0x8(%ebp)
  8004eb:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f1:	50                   	push   %eax
  8004f2:	68 5f 04 80 00       	push   $0x80045f
  8004f7:	e8 11 02 00 00       	call   80070d <vprintfmt>
  8004fc:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004ff:	a0 24 40 80 00       	mov    0x804024,%al
  800504:	0f b6 c0             	movzbl %al,%eax
  800507:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80050d:	83 ec 04             	sub    $0x4,%esp
  800510:	50                   	push   %eax
  800511:	52                   	push   %edx
  800512:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800518:	83 c0 08             	add    $0x8,%eax
  80051b:	50                   	push   %eax
  80051c:	e8 8e 13 00 00       	call   8018af <sys_cputs>
  800521:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800524:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80052b:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800531:	c9                   	leave  
  800532:	c3                   	ret    

00800533 <cprintf>:

int cprintf(const char *fmt, ...) {
  800533:	55                   	push   %ebp
  800534:	89 e5                	mov    %esp,%ebp
  800536:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800539:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800540:	8d 45 0c             	lea    0xc(%ebp),%eax
  800543:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800546:	8b 45 08             	mov    0x8(%ebp),%eax
  800549:	83 ec 08             	sub    $0x8,%esp
  80054c:	ff 75 f4             	pushl  -0xc(%ebp)
  80054f:	50                   	push   %eax
  800550:	e8 73 ff ff ff       	call   8004c8 <vcprintf>
  800555:	83 c4 10             	add    $0x10,%esp
  800558:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80055b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80055e:	c9                   	leave  
  80055f:	c3                   	ret    

00800560 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800566:	e8 f2 14 00 00       	call   801a5d <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80056b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80056e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800571:	8b 45 08             	mov    0x8(%ebp),%eax
  800574:	83 ec 08             	sub    $0x8,%esp
  800577:	ff 75 f4             	pushl  -0xc(%ebp)
  80057a:	50                   	push   %eax
  80057b:	e8 48 ff ff ff       	call   8004c8 <vcprintf>
  800580:	83 c4 10             	add    $0x10,%esp
  800583:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800586:	e8 ec 14 00 00       	call   801a77 <sys_enable_interrupt>
	return cnt;
  80058b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80058e:	c9                   	leave  
  80058f:	c3                   	ret    

00800590 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	53                   	push   %ebx
  800594:	83 ec 14             	sub    $0x14,%esp
  800597:	8b 45 10             	mov    0x10(%ebp),%eax
  80059a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80059d:	8b 45 14             	mov    0x14(%ebp),%eax
  8005a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005a3:	8b 45 18             	mov    0x18(%ebp),%eax
  8005a6:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ab:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ae:	77 55                	ja     800605 <printnum+0x75>
  8005b0:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005b3:	72 05                	jb     8005ba <printnum+0x2a>
  8005b5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b8:	77 4b                	ja     800605 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ba:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005bd:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005c0:	8b 45 18             	mov    0x18(%ebp),%eax
  8005c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c8:	52                   	push   %edx
  8005c9:	50                   	push   %eax
  8005ca:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cd:	ff 75 f0             	pushl  -0x10(%ebp)
  8005d0:	e8 63 2a 00 00       	call   803038 <__udivdi3>
  8005d5:	83 c4 10             	add    $0x10,%esp
  8005d8:	83 ec 04             	sub    $0x4,%esp
  8005db:	ff 75 20             	pushl  0x20(%ebp)
  8005de:	53                   	push   %ebx
  8005df:	ff 75 18             	pushl  0x18(%ebp)
  8005e2:	52                   	push   %edx
  8005e3:	50                   	push   %eax
  8005e4:	ff 75 0c             	pushl  0xc(%ebp)
  8005e7:	ff 75 08             	pushl  0x8(%ebp)
  8005ea:	e8 a1 ff ff ff       	call   800590 <printnum>
  8005ef:	83 c4 20             	add    $0x20,%esp
  8005f2:	eb 1a                	jmp    80060e <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005f4:	83 ec 08             	sub    $0x8,%esp
  8005f7:	ff 75 0c             	pushl  0xc(%ebp)
  8005fa:	ff 75 20             	pushl  0x20(%ebp)
  8005fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800600:	ff d0                	call   *%eax
  800602:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800605:	ff 4d 1c             	decl   0x1c(%ebp)
  800608:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80060c:	7f e6                	jg     8005f4 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80060e:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800611:	bb 00 00 00 00       	mov    $0x0,%ebx
  800616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800619:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80061c:	53                   	push   %ebx
  80061d:	51                   	push   %ecx
  80061e:	52                   	push   %edx
  80061f:	50                   	push   %eax
  800620:	e8 23 2b 00 00       	call   803148 <__umoddi3>
  800625:	83 c4 10             	add    $0x10,%esp
  800628:	05 74 38 80 00       	add    $0x803874,%eax
  80062d:	8a 00                	mov    (%eax),%al
  80062f:	0f be c0             	movsbl %al,%eax
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	50                   	push   %eax
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	ff d0                	call   *%eax
  80063e:	83 c4 10             	add    $0x10,%esp
}
  800641:	90                   	nop
  800642:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800645:	c9                   	leave  
  800646:	c3                   	ret    

00800647 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800647:	55                   	push   %ebp
  800648:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80064a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80064e:	7e 1c                	jle    80066c <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	8b 00                	mov    (%eax),%eax
  800655:	8d 50 08             	lea    0x8(%eax),%edx
  800658:	8b 45 08             	mov    0x8(%ebp),%eax
  80065b:	89 10                	mov    %edx,(%eax)
  80065d:	8b 45 08             	mov    0x8(%ebp),%eax
  800660:	8b 00                	mov    (%eax),%eax
  800662:	83 e8 08             	sub    $0x8,%eax
  800665:	8b 50 04             	mov    0x4(%eax),%edx
  800668:	8b 00                	mov    (%eax),%eax
  80066a:	eb 40                	jmp    8006ac <getuint+0x65>
	else if (lflag)
  80066c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800670:	74 1e                	je     800690 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	8d 50 04             	lea    0x4(%eax),%edx
  80067a:	8b 45 08             	mov    0x8(%ebp),%eax
  80067d:	89 10                	mov    %edx,(%eax)
  80067f:	8b 45 08             	mov    0x8(%ebp),%eax
  800682:	8b 00                	mov    (%eax),%eax
  800684:	83 e8 04             	sub    $0x4,%eax
  800687:	8b 00                	mov    (%eax),%eax
  800689:	ba 00 00 00 00       	mov    $0x0,%edx
  80068e:	eb 1c                	jmp    8006ac <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	8d 50 04             	lea    0x4(%eax),%edx
  800698:	8b 45 08             	mov    0x8(%ebp),%eax
  80069b:	89 10                	mov    %edx,(%eax)
  80069d:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a0:	8b 00                	mov    (%eax),%eax
  8006a2:	83 e8 04             	sub    $0x4,%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ac:	5d                   	pop    %ebp
  8006ad:	c3                   	ret    

008006ae <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b5:	7e 1c                	jle    8006d3 <getint+0x25>
		return va_arg(*ap, long long);
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	8d 50 08             	lea    0x8(%eax),%edx
  8006bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c2:	89 10                	mov    %edx,(%eax)
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	83 e8 08             	sub    $0x8,%eax
  8006cc:	8b 50 04             	mov    0x4(%eax),%edx
  8006cf:	8b 00                	mov    (%eax),%eax
  8006d1:	eb 38                	jmp    80070b <getint+0x5d>
	else if (lflag)
  8006d3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006d7:	74 1a                	je     8006f3 <getint+0x45>
		return va_arg(*ap, long);
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	8d 50 04             	lea    0x4(%eax),%edx
  8006e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e4:	89 10                	mov    %edx,(%eax)
  8006e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e9:	8b 00                	mov    (%eax),%eax
  8006eb:	83 e8 04             	sub    $0x4,%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	99                   	cltd   
  8006f1:	eb 18                	jmp    80070b <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	8b 00                	mov    (%eax),%eax
  8006f8:	8d 50 04             	lea    0x4(%eax),%edx
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	89 10                	mov    %edx,(%eax)
  800700:	8b 45 08             	mov    0x8(%ebp),%eax
  800703:	8b 00                	mov    (%eax),%eax
  800705:	83 e8 04             	sub    $0x4,%eax
  800708:	8b 00                	mov    (%eax),%eax
  80070a:	99                   	cltd   
}
  80070b:	5d                   	pop    %ebp
  80070c:	c3                   	ret    

0080070d <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80070d:	55                   	push   %ebp
  80070e:	89 e5                	mov    %esp,%ebp
  800710:	56                   	push   %esi
  800711:	53                   	push   %ebx
  800712:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800715:	eb 17                	jmp    80072e <vprintfmt+0x21>
			if (ch == '\0')
  800717:	85 db                	test   %ebx,%ebx
  800719:	0f 84 af 03 00 00    	je     800ace <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80071f:	83 ec 08             	sub    $0x8,%esp
  800722:	ff 75 0c             	pushl  0xc(%ebp)
  800725:	53                   	push   %ebx
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	ff d0                	call   *%eax
  80072b:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80072e:	8b 45 10             	mov    0x10(%ebp),%eax
  800731:	8d 50 01             	lea    0x1(%eax),%edx
  800734:	89 55 10             	mov    %edx,0x10(%ebp)
  800737:	8a 00                	mov    (%eax),%al
  800739:	0f b6 d8             	movzbl %al,%ebx
  80073c:	83 fb 25             	cmp    $0x25,%ebx
  80073f:	75 d6                	jne    800717 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800741:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800745:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80074c:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800753:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80075a:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800761:	8b 45 10             	mov    0x10(%ebp),%eax
  800764:	8d 50 01             	lea    0x1(%eax),%edx
  800767:	89 55 10             	mov    %edx,0x10(%ebp)
  80076a:	8a 00                	mov    (%eax),%al
  80076c:	0f b6 d8             	movzbl %al,%ebx
  80076f:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800772:	83 f8 55             	cmp    $0x55,%eax
  800775:	0f 87 2b 03 00 00    	ja     800aa6 <vprintfmt+0x399>
  80077b:	8b 04 85 98 38 80 00 	mov    0x803898(,%eax,4),%eax
  800782:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800784:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800788:	eb d7                	jmp    800761 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80078a:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80078e:	eb d1                	jmp    800761 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800790:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800797:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80079a:	89 d0                	mov    %edx,%eax
  80079c:	c1 e0 02             	shl    $0x2,%eax
  80079f:	01 d0                	add    %edx,%eax
  8007a1:	01 c0                	add    %eax,%eax
  8007a3:	01 d8                	add    %ebx,%eax
  8007a5:	83 e8 30             	sub    $0x30,%eax
  8007a8:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ae:	8a 00                	mov    (%eax),%al
  8007b0:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007b3:	83 fb 2f             	cmp    $0x2f,%ebx
  8007b6:	7e 3e                	jle    8007f6 <vprintfmt+0xe9>
  8007b8:	83 fb 39             	cmp    $0x39,%ebx
  8007bb:	7f 39                	jg     8007f6 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007bd:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007c0:	eb d5                	jmp    800797 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c5:	83 c0 04             	add    $0x4,%eax
  8007c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8007cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8007ce:	83 e8 04             	sub    $0x4,%eax
  8007d1:	8b 00                	mov    (%eax),%eax
  8007d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007d6:	eb 1f                	jmp    8007f7 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007dc:	79 83                	jns    800761 <vprintfmt+0x54>
				width = 0;
  8007de:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007e5:	e9 77 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007ea:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007f1:	e9 6b ff ff ff       	jmp    800761 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007f6:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fb:	0f 89 60 ff ff ff    	jns    800761 <vprintfmt+0x54>
				width = precision, precision = -1;
  800801:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800804:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800807:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80080e:	e9 4e ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800813:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800816:	e9 46 ff ff ff       	jmp    800761 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80081b:	8b 45 14             	mov    0x14(%ebp),%eax
  80081e:	83 c0 04             	add    $0x4,%eax
  800821:	89 45 14             	mov    %eax,0x14(%ebp)
  800824:	8b 45 14             	mov    0x14(%ebp),%eax
  800827:	83 e8 04             	sub    $0x4,%eax
  80082a:	8b 00                	mov    (%eax),%eax
  80082c:	83 ec 08             	sub    $0x8,%esp
  80082f:	ff 75 0c             	pushl  0xc(%ebp)
  800832:	50                   	push   %eax
  800833:	8b 45 08             	mov    0x8(%ebp),%eax
  800836:	ff d0                	call   *%eax
  800838:	83 c4 10             	add    $0x10,%esp
			break;
  80083b:	e9 89 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800840:	8b 45 14             	mov    0x14(%ebp),%eax
  800843:	83 c0 04             	add    $0x4,%eax
  800846:	89 45 14             	mov    %eax,0x14(%ebp)
  800849:	8b 45 14             	mov    0x14(%ebp),%eax
  80084c:	83 e8 04             	sub    $0x4,%eax
  80084f:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800851:	85 db                	test   %ebx,%ebx
  800853:	79 02                	jns    800857 <vprintfmt+0x14a>
				err = -err;
  800855:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800857:	83 fb 64             	cmp    $0x64,%ebx
  80085a:	7f 0b                	jg     800867 <vprintfmt+0x15a>
  80085c:	8b 34 9d e0 36 80 00 	mov    0x8036e0(,%ebx,4),%esi
  800863:	85 f6                	test   %esi,%esi
  800865:	75 19                	jne    800880 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800867:	53                   	push   %ebx
  800868:	68 85 38 80 00       	push   $0x803885
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	ff 75 08             	pushl  0x8(%ebp)
  800873:	e8 5e 02 00 00       	call   800ad6 <printfmt>
  800878:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80087b:	e9 49 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800880:	56                   	push   %esi
  800881:	68 8e 38 80 00       	push   $0x80388e
  800886:	ff 75 0c             	pushl  0xc(%ebp)
  800889:	ff 75 08             	pushl  0x8(%ebp)
  80088c:	e8 45 02 00 00       	call   800ad6 <printfmt>
  800891:	83 c4 10             	add    $0x10,%esp
			break;
  800894:	e9 30 02 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800899:	8b 45 14             	mov    0x14(%ebp),%eax
  80089c:	83 c0 04             	add    $0x4,%eax
  80089f:	89 45 14             	mov    %eax,0x14(%ebp)
  8008a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008a5:	83 e8 04             	sub    $0x4,%eax
  8008a8:	8b 30                	mov    (%eax),%esi
  8008aa:	85 f6                	test   %esi,%esi
  8008ac:	75 05                	jne    8008b3 <vprintfmt+0x1a6>
				p = "(null)";
  8008ae:	be 91 38 80 00       	mov    $0x803891,%esi
			if (width > 0 && padc != '-')
  8008b3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b7:	7e 6d                	jle    800926 <vprintfmt+0x219>
  8008b9:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008bd:	74 67                	je     800926 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c2:	83 ec 08             	sub    $0x8,%esp
  8008c5:	50                   	push   %eax
  8008c6:	56                   	push   %esi
  8008c7:	e8 0c 03 00 00       	call   800bd8 <strnlen>
  8008cc:	83 c4 10             	add    $0x10,%esp
  8008cf:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008d2:	eb 16                	jmp    8008ea <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008d4:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d8:	83 ec 08             	sub    $0x8,%esp
  8008db:	ff 75 0c             	pushl  0xc(%ebp)
  8008de:	50                   	push   %eax
  8008df:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e2:	ff d0                	call   *%eax
  8008e4:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008e7:	ff 4d e4             	decl   -0x1c(%ebp)
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7f e4                	jg     8008d4 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008f0:	eb 34                	jmp    800926 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008f2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008f6:	74 1c                	je     800914 <vprintfmt+0x207>
  8008f8:	83 fb 1f             	cmp    $0x1f,%ebx
  8008fb:	7e 05                	jle    800902 <vprintfmt+0x1f5>
  8008fd:	83 fb 7e             	cmp    $0x7e,%ebx
  800900:	7e 12                	jle    800914 <vprintfmt+0x207>
					putch('?', putdat);
  800902:	83 ec 08             	sub    $0x8,%esp
  800905:	ff 75 0c             	pushl  0xc(%ebp)
  800908:	6a 3f                	push   $0x3f
  80090a:	8b 45 08             	mov    0x8(%ebp),%eax
  80090d:	ff d0                	call   *%eax
  80090f:	83 c4 10             	add    $0x10,%esp
  800912:	eb 0f                	jmp    800923 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	ff 75 0c             	pushl  0xc(%ebp)
  80091a:	53                   	push   %ebx
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800923:	ff 4d e4             	decl   -0x1c(%ebp)
  800926:	89 f0                	mov    %esi,%eax
  800928:	8d 70 01             	lea    0x1(%eax),%esi
  80092b:	8a 00                	mov    (%eax),%al
  80092d:	0f be d8             	movsbl %al,%ebx
  800930:	85 db                	test   %ebx,%ebx
  800932:	74 24                	je     800958 <vprintfmt+0x24b>
  800934:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800938:	78 b8                	js     8008f2 <vprintfmt+0x1e5>
  80093a:	ff 4d e0             	decl   -0x20(%ebp)
  80093d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800941:	79 af                	jns    8008f2 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800943:	eb 13                	jmp    800958 <vprintfmt+0x24b>
				putch(' ', putdat);
  800945:	83 ec 08             	sub    $0x8,%esp
  800948:	ff 75 0c             	pushl  0xc(%ebp)
  80094b:	6a 20                	push   $0x20
  80094d:	8b 45 08             	mov    0x8(%ebp),%eax
  800950:	ff d0                	call   *%eax
  800952:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800955:	ff 4d e4             	decl   -0x1c(%ebp)
  800958:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095c:	7f e7                	jg     800945 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80095e:	e9 66 01 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 e8             	pushl  -0x18(%ebp)
  800969:	8d 45 14             	lea    0x14(%ebp),%eax
  80096c:	50                   	push   %eax
  80096d:	e8 3c fd ff ff       	call   8006ae <getint>
  800972:	83 c4 10             	add    $0x10,%esp
  800975:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800978:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80097b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80097e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800981:	85 d2                	test   %edx,%edx
  800983:	79 23                	jns    8009a8 <vprintfmt+0x29b>
				putch('-', putdat);
  800985:	83 ec 08             	sub    $0x8,%esp
  800988:	ff 75 0c             	pushl  0xc(%ebp)
  80098b:	6a 2d                	push   $0x2d
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	ff d0                	call   *%eax
  800992:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800995:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800998:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80099b:	f7 d8                	neg    %eax
  80099d:	83 d2 00             	adc    $0x0,%edx
  8009a0:	f7 da                	neg    %edx
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009af:	e9 bc 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ba:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bd:	50                   	push   %eax
  8009be:	e8 84 fc ff ff       	call   800647 <getuint>
  8009c3:	83 c4 10             	add    $0x10,%esp
  8009c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009cc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009d3:	e9 98 00 00 00       	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d8:	83 ec 08             	sub    $0x8,%esp
  8009db:	ff 75 0c             	pushl  0xc(%ebp)
  8009de:	6a 58                	push   $0x58
  8009e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e3:	ff d0                	call   *%eax
  8009e5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 0c             	pushl  0xc(%ebp)
  8009ee:	6a 58                	push   $0x58
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 0c             	pushl  0xc(%ebp)
  8009fe:	6a 58                	push   $0x58
  800a00:	8b 45 08             	mov    0x8(%ebp),%eax
  800a03:	ff d0                	call   *%eax
  800a05:	83 c4 10             	add    $0x10,%esp
			break;
  800a08:	e9 bc 00 00 00       	jmp    800ac9 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a0d:	83 ec 08             	sub    $0x8,%esp
  800a10:	ff 75 0c             	pushl  0xc(%ebp)
  800a13:	6a 30                	push   $0x30
  800a15:	8b 45 08             	mov    0x8(%ebp),%eax
  800a18:	ff d0                	call   *%eax
  800a1a:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a1d:	83 ec 08             	sub    $0x8,%esp
  800a20:	ff 75 0c             	pushl  0xc(%ebp)
  800a23:	6a 78                	push   $0x78
  800a25:	8b 45 08             	mov    0x8(%ebp),%eax
  800a28:	ff d0                	call   *%eax
  800a2a:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a2d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a30:	83 c0 04             	add    $0x4,%eax
  800a33:	89 45 14             	mov    %eax,0x14(%ebp)
  800a36:	8b 45 14             	mov    0x14(%ebp),%eax
  800a39:	83 e8 04             	sub    $0x4,%eax
  800a3c:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a41:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a48:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a4f:	eb 1f                	jmp    800a70 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a51:	83 ec 08             	sub    $0x8,%esp
  800a54:	ff 75 e8             	pushl  -0x18(%ebp)
  800a57:	8d 45 14             	lea    0x14(%ebp),%eax
  800a5a:	50                   	push   %eax
  800a5b:	e8 e7 fb ff ff       	call   800647 <getuint>
  800a60:	83 c4 10             	add    $0x10,%esp
  800a63:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a66:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a69:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a70:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a74:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	52                   	push   %edx
  800a7b:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a7e:	50                   	push   %eax
  800a7f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a82:	ff 75 f0             	pushl  -0x10(%ebp)
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	ff 75 08             	pushl  0x8(%ebp)
  800a8b:	e8 00 fb ff ff       	call   800590 <printnum>
  800a90:	83 c4 20             	add    $0x20,%esp
			break;
  800a93:	eb 34                	jmp    800ac9 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	53                   	push   %ebx
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			break;
  800aa4:	eb 23                	jmp    800ac9 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	6a 25                	push   $0x25
  800aae:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab1:	ff d0                	call   *%eax
  800ab3:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ab6:	ff 4d 10             	decl   0x10(%ebp)
  800ab9:	eb 03                	jmp    800abe <vprintfmt+0x3b1>
  800abb:	ff 4d 10             	decl   0x10(%ebp)
  800abe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac1:	48                   	dec    %eax
  800ac2:	8a 00                	mov    (%eax),%al
  800ac4:	3c 25                	cmp    $0x25,%al
  800ac6:	75 f3                	jne    800abb <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac8:	90                   	nop
		}
	}
  800ac9:	e9 47 fc ff ff       	jmp    800715 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ace:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800acf:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ad2:	5b                   	pop    %ebx
  800ad3:	5e                   	pop    %esi
  800ad4:	5d                   	pop    %ebp
  800ad5:	c3                   	ret    

00800ad6 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ad6:	55                   	push   %ebp
  800ad7:	89 e5                	mov    %esp,%ebp
  800ad9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800adc:	8d 45 10             	lea    0x10(%ebp),%eax
  800adf:	83 c0 04             	add    $0x4,%eax
  800ae2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ae5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae8:	ff 75 f4             	pushl  -0xc(%ebp)
  800aeb:	50                   	push   %eax
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	ff 75 08             	pushl  0x8(%ebp)
  800af2:	e8 16 fc ff ff       	call   80070d <vprintfmt>
  800af7:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800afa:	90                   	nop
  800afb:	c9                   	leave  
  800afc:	c3                   	ret    

00800afd <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800afd:	55                   	push   %ebp
  800afe:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b03:	8b 40 08             	mov    0x8(%eax),%eax
  800b06:	8d 50 01             	lea    0x1(%eax),%edx
  800b09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0c:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b12:	8b 10                	mov    (%eax),%edx
  800b14:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b17:	8b 40 04             	mov    0x4(%eax),%eax
  800b1a:	39 c2                	cmp    %eax,%edx
  800b1c:	73 12                	jae    800b30 <sprintputch+0x33>
		*b->buf++ = ch;
  800b1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	8d 48 01             	lea    0x1(%eax),%ecx
  800b26:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b29:	89 0a                	mov    %ecx,(%edx)
  800b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800b2e:	88 10                	mov    %dl,(%eax)
}
  800b30:	90                   	nop
  800b31:	5d                   	pop    %ebp
  800b32:	c3                   	ret    

00800b33 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b33:	55                   	push   %ebp
  800b34:	89 e5                	mov    %esp,%ebp
  800b36:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b39:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b45:	8b 45 08             	mov    0x8(%ebp),%eax
  800b48:	01 d0                	add    %edx,%eax
  800b4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b54:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b58:	74 06                	je     800b60 <vsnprintf+0x2d>
  800b5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5e:	7f 07                	jg     800b67 <vsnprintf+0x34>
		return -E_INVAL;
  800b60:	b8 03 00 00 00       	mov    $0x3,%eax
  800b65:	eb 20                	jmp    800b87 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b67:	ff 75 14             	pushl  0x14(%ebp)
  800b6a:	ff 75 10             	pushl  0x10(%ebp)
  800b6d:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b70:	50                   	push   %eax
  800b71:	68 fd 0a 80 00       	push   $0x800afd
  800b76:	e8 92 fb ff ff       	call   80070d <vprintfmt>
  800b7b:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b81:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b84:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b87:	c9                   	leave  
  800b88:	c3                   	ret    

00800b89 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b89:	55                   	push   %ebp
  800b8a:	89 e5                	mov    %esp,%ebp
  800b8c:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b8f:	8d 45 10             	lea    0x10(%ebp),%eax
  800b92:	83 c0 04             	add    $0x4,%eax
  800b95:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b98:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9b:	ff 75 f4             	pushl  -0xc(%ebp)
  800b9e:	50                   	push   %eax
  800b9f:	ff 75 0c             	pushl  0xc(%ebp)
  800ba2:	ff 75 08             	pushl  0x8(%ebp)
  800ba5:	e8 89 ff ff ff       	call   800b33 <vsnprintf>
  800baa:	83 c4 10             	add    $0x10,%esp
  800bad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bb3:	c9                   	leave  
  800bb4:	c3                   	ret    

00800bb5 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bb5:	55                   	push   %ebp
  800bb6:	89 e5                	mov    %esp,%ebp
  800bb8:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc2:	eb 06                	jmp    800bca <strlen+0x15>
		n++;
  800bc4:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bc7:	ff 45 08             	incl   0x8(%ebp)
  800bca:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcd:	8a 00                	mov    (%eax),%al
  800bcf:	84 c0                	test   %al,%al
  800bd1:	75 f1                	jne    800bc4 <strlen+0xf>
		n++;
	return n;
  800bd3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bde:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800be5:	eb 09                	jmp    800bf0 <strnlen+0x18>
		n++;
  800be7:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bea:	ff 45 08             	incl   0x8(%ebp)
  800bed:	ff 4d 0c             	decl   0xc(%ebp)
  800bf0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bf4:	74 09                	je     800bff <strnlen+0x27>
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	8a 00                	mov    (%eax),%al
  800bfb:	84 c0                	test   %al,%al
  800bfd:	75 e8                	jne    800be7 <strnlen+0xf>
		n++;
	return n;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c10:	90                   	nop
  800c11:	8b 45 08             	mov    0x8(%ebp),%eax
  800c14:	8d 50 01             	lea    0x1(%eax),%edx
  800c17:	89 55 08             	mov    %edx,0x8(%ebp)
  800c1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c1d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c20:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c23:	8a 12                	mov    (%edx),%dl
  800c25:	88 10                	mov    %dl,(%eax)
  800c27:	8a 00                	mov    (%eax),%al
  800c29:	84 c0                	test   %al,%al
  800c2b:	75 e4                	jne    800c11 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c2d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c30:	c9                   	leave  
  800c31:	c3                   	ret    

00800c32 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c32:	55                   	push   %ebp
  800c33:	89 e5                	mov    %esp,%ebp
  800c35:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c38:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c3e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c45:	eb 1f                	jmp    800c66 <strncpy+0x34>
		*dst++ = *src;
  800c47:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4a:	8d 50 01             	lea    0x1(%eax),%edx
  800c4d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c50:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c53:	8a 12                	mov    (%edx),%dl
  800c55:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5a:	8a 00                	mov    (%eax),%al
  800c5c:	84 c0                	test   %al,%al
  800c5e:	74 03                	je     800c63 <strncpy+0x31>
			src++;
  800c60:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c63:	ff 45 fc             	incl   -0x4(%ebp)
  800c66:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c69:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c6c:	72 d9                	jb     800c47 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c6e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c71:	c9                   	leave  
  800c72:	c3                   	ret    

00800c73 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c73:	55                   	push   %ebp
  800c74:	89 e5                	mov    %esp,%ebp
  800c76:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c83:	74 30                	je     800cb5 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c85:	eb 16                	jmp    800c9d <strlcpy+0x2a>
			*dst++ = *src++;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	8d 50 01             	lea    0x1(%eax),%edx
  800c8d:	89 55 08             	mov    %edx,0x8(%ebp)
  800c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c93:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c96:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c99:	8a 12                	mov    (%edx),%dl
  800c9b:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c9d:	ff 4d 10             	decl   0x10(%ebp)
  800ca0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ca4:	74 09                	je     800caf <strlcpy+0x3c>
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	75 d8                	jne    800c87 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	29 c2                	sub    %eax,%edx
  800cbd:	89 d0                	mov    %edx,%eax
}
  800cbf:	c9                   	leave  
  800cc0:	c3                   	ret    

00800cc1 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cc1:	55                   	push   %ebp
  800cc2:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cc4:	eb 06                	jmp    800ccc <strcmp+0xb>
		p++, q++;
  800cc6:	ff 45 08             	incl   0x8(%ebp)
  800cc9:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	84 c0                	test   %al,%al
  800cd3:	74 0e                	je     800ce3 <strcmp+0x22>
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 10                	mov    (%eax),%dl
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	38 c2                	cmp    %al,%dl
  800ce1:	74 e3                	je     800cc6 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f b6 d0             	movzbl %al,%edx
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	0f b6 c0             	movzbl %al,%eax
  800cf3:	29 c2                	sub    %eax,%edx
  800cf5:	89 d0                	mov    %edx,%eax
}
  800cf7:	5d                   	pop    %ebp
  800cf8:	c3                   	ret    

00800cf9 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf9:	55                   	push   %ebp
  800cfa:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cfc:	eb 09                	jmp    800d07 <strncmp+0xe>
		n--, p++, q++;
  800cfe:	ff 4d 10             	decl   0x10(%ebp)
  800d01:	ff 45 08             	incl   0x8(%ebp)
  800d04:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d07:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0b:	74 17                	je     800d24 <strncmp+0x2b>
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	74 0e                	je     800d24 <strncmp+0x2b>
  800d16:	8b 45 08             	mov    0x8(%ebp),%eax
  800d19:	8a 10                	mov    (%eax),%dl
  800d1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	38 c2                	cmp    %al,%dl
  800d22:	74 da                	je     800cfe <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d24:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d28:	75 07                	jne    800d31 <strncmp+0x38>
		return 0;
  800d2a:	b8 00 00 00 00       	mov    $0x0,%eax
  800d2f:	eb 14                	jmp    800d45 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f b6 d0             	movzbl %al,%edx
  800d39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f b6 c0             	movzbl %al,%eax
  800d41:	29 c2                	sub    %eax,%edx
  800d43:	89 d0                	mov    %edx,%eax
}
  800d45:	5d                   	pop    %ebp
  800d46:	c3                   	ret    

00800d47 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d47:	55                   	push   %ebp
  800d48:	89 e5                	mov    %esp,%ebp
  800d4a:	83 ec 04             	sub    $0x4,%esp
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d53:	eb 12                	jmp    800d67 <strchr+0x20>
		if (*s == c)
  800d55:	8b 45 08             	mov    0x8(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d5d:	75 05                	jne    800d64 <strchr+0x1d>
			return (char *) s;
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	eb 11                	jmp    800d75 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d64:	ff 45 08             	incl   0x8(%ebp)
  800d67:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6a:	8a 00                	mov    (%eax),%al
  800d6c:	84 c0                	test   %al,%al
  800d6e:	75 e5                	jne    800d55 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
  800d7a:	83 ec 04             	sub    $0x4,%esp
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d83:	eb 0d                	jmp    800d92 <strfind+0x1b>
		if (*s == c)
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d8d:	74 0e                	je     800d9d <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d8f:	ff 45 08             	incl   0x8(%ebp)
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	84 c0                	test   %al,%al
  800d99:	75 ea                	jne    800d85 <strfind+0xe>
  800d9b:	eb 01                	jmp    800d9e <strfind+0x27>
		if (*s == c)
			break;
  800d9d:	90                   	nop
	return (char *) s;
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800daf:	8b 45 10             	mov    0x10(%ebp),%eax
  800db2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800db5:	eb 0e                	jmp    800dc5 <memset+0x22>
		*p++ = c;
  800db7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dba:	8d 50 01             	lea    0x1(%eax),%edx
  800dbd:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc3:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dc5:	ff 4d f8             	decl   -0x8(%ebp)
  800dc8:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dcc:	79 e9                	jns    800db7 <memset+0x14>
		*p++ = c;

	return v;
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd1:	c9                   	leave  
  800dd2:	c3                   	ret    

00800dd3 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dd3:	55                   	push   %ebp
  800dd4:	89 e5                	mov    %esp,%ebp
  800dd6:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ddc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
  800de2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800de5:	eb 16                	jmp    800dfd <memcpy+0x2a>
		*d++ = *s++;
  800de7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dea:	8d 50 01             	lea    0x1(%eax),%edx
  800ded:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800df0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800df3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800df6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df9:	8a 12                	mov    (%edx),%dl
  800dfb:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dfd:	8b 45 10             	mov    0x10(%ebp),%eax
  800e00:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e03:	89 55 10             	mov    %edx,0x10(%ebp)
  800e06:	85 c0                	test   %eax,%eax
  800e08:	75 dd                	jne    800de7 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e0a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0d:	c9                   	leave  
  800e0e:	c3                   	ret    

00800e0f <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e0f:	55                   	push   %ebp
  800e10:	89 e5                	mov    %esp,%ebp
  800e12:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e18:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e27:	73 50                	jae    800e79 <memmove+0x6a>
  800e29:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2f:	01 d0                	add    %edx,%eax
  800e31:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e34:	76 43                	jbe    800e79 <memmove+0x6a>
		s += n;
  800e36:	8b 45 10             	mov    0x10(%ebp),%eax
  800e39:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e3c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3f:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e42:	eb 10                	jmp    800e54 <memmove+0x45>
			*--d = *--s;
  800e44:	ff 4d f8             	decl   -0x8(%ebp)
  800e47:	ff 4d fc             	decl   -0x4(%ebp)
  800e4a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e4d:	8a 10                	mov    (%eax),%dl
  800e4f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e52:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e54:	8b 45 10             	mov    0x10(%ebp),%eax
  800e57:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5d:	85 c0                	test   %eax,%eax
  800e5f:	75 e3                	jne    800e44 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e61:	eb 23                	jmp    800e86 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e66:	8d 50 01             	lea    0x1(%eax),%edx
  800e69:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e6c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e72:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e75:	8a 12                	mov    (%edx),%dl
  800e77:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e79:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7c:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e7f:	89 55 10             	mov    %edx,0x10(%ebp)
  800e82:	85 c0                	test   %eax,%eax
  800e84:	75 dd                	jne    800e63 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e89:	c9                   	leave  
  800e8a:	c3                   	ret    

00800e8b <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e8b:	55                   	push   %ebp
  800e8c:	89 e5                	mov    %esp,%ebp
  800e8e:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9a:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e9d:	eb 2a                	jmp    800ec9 <memcmp+0x3e>
		if (*s1 != *s2)
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea2:	8a 10                	mov    (%eax),%dl
  800ea4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea7:	8a 00                	mov    (%eax),%al
  800ea9:	38 c2                	cmp    %al,%dl
  800eab:	74 16                	je     800ec3 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ead:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	0f b6 d0             	movzbl %al,%edx
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	0f b6 c0             	movzbl %al,%eax
  800ebd:	29 c2                	sub    %eax,%edx
  800ebf:	89 d0                	mov    %edx,%eax
  800ec1:	eb 18                	jmp    800edb <memcmp+0x50>
		s1++, s2++;
  800ec3:	ff 45 fc             	incl   -0x4(%ebp)
  800ec6:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ecf:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed2:	85 c0                	test   %eax,%eax
  800ed4:	75 c9                	jne    800e9f <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ed6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ee3:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee9:	01 d0                	add    %edx,%eax
  800eeb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eee:	eb 15                	jmp    800f05 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8a 00                	mov    (%eax),%al
  800ef5:	0f b6 d0             	movzbl %al,%edx
  800ef8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efb:	0f b6 c0             	movzbl %al,%eax
  800efe:	39 c2                	cmp    %eax,%edx
  800f00:	74 0d                	je     800f0f <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f02:	ff 45 08             	incl   0x8(%ebp)
  800f05:	8b 45 08             	mov    0x8(%ebp),%eax
  800f08:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f0b:	72 e3                	jb     800ef0 <memfind+0x13>
  800f0d:	eb 01                	jmp    800f10 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f0f:	90                   	nop
	return (void *) s;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f13:	c9                   	leave  
  800f14:	c3                   	ret    

00800f15 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f15:	55                   	push   %ebp
  800f16:	89 e5                	mov    %esp,%ebp
  800f18:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f22:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f29:	eb 03                	jmp    800f2e <strtol+0x19>
		s++;
  800f2b:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	3c 20                	cmp    $0x20,%al
  800f35:	74 f4                	je     800f2b <strtol+0x16>
  800f37:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3a:	8a 00                	mov    (%eax),%al
  800f3c:	3c 09                	cmp    $0x9,%al
  800f3e:	74 eb                	je     800f2b <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 2b                	cmp    $0x2b,%al
  800f47:	75 05                	jne    800f4e <strtol+0x39>
		s++;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	eb 13                	jmp    800f61 <strtol+0x4c>
	else if (*s == '-')
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	8a 00                	mov    (%eax),%al
  800f53:	3c 2d                	cmp    $0x2d,%al
  800f55:	75 0a                	jne    800f61 <strtol+0x4c>
		s++, neg = 1;
  800f57:	ff 45 08             	incl   0x8(%ebp)
  800f5a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f61:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f65:	74 06                	je     800f6d <strtol+0x58>
  800f67:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f6b:	75 20                	jne    800f8d <strtol+0x78>
  800f6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	3c 30                	cmp    $0x30,%al
  800f74:	75 17                	jne    800f8d <strtol+0x78>
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	40                   	inc    %eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 78                	cmp    $0x78,%al
  800f7e:	75 0d                	jne    800f8d <strtol+0x78>
		s += 2, base = 16;
  800f80:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f84:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f8b:	eb 28                	jmp    800fb5 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f91:	75 15                	jne    800fa8 <strtol+0x93>
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	8a 00                	mov    (%eax),%al
  800f98:	3c 30                	cmp    $0x30,%al
  800f9a:	75 0c                	jne    800fa8 <strtol+0x93>
		s++, base = 8;
  800f9c:	ff 45 08             	incl   0x8(%ebp)
  800f9f:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fa6:	eb 0d                	jmp    800fb5 <strtol+0xa0>
	else if (base == 0)
  800fa8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fac:	75 07                	jne    800fb5 <strtol+0xa0>
		base = 10;
  800fae:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 2f                	cmp    $0x2f,%al
  800fbc:	7e 19                	jle    800fd7 <strtol+0xc2>
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	3c 39                	cmp    $0x39,%al
  800fc5:	7f 10                	jg     800fd7 <strtol+0xc2>
			dig = *s - '0';
  800fc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fca:	8a 00                	mov    (%eax),%al
  800fcc:	0f be c0             	movsbl %al,%eax
  800fcf:	83 e8 30             	sub    $0x30,%eax
  800fd2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd5:	eb 42                	jmp    801019 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 60                	cmp    $0x60,%al
  800fde:	7e 19                	jle    800ff9 <strtol+0xe4>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	8a 00                	mov    (%eax),%al
  800fe5:	3c 7a                	cmp    $0x7a,%al
  800fe7:	7f 10                	jg     800ff9 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fec:	8a 00                	mov    (%eax),%al
  800fee:	0f be c0             	movsbl %al,%eax
  800ff1:	83 e8 57             	sub    $0x57,%eax
  800ff4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ff7:	eb 20                	jmp    801019 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffc:	8a 00                	mov    (%eax),%al
  800ffe:	3c 40                	cmp    $0x40,%al
  801000:	7e 39                	jle    80103b <strtol+0x126>
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	8a 00                	mov    (%eax),%al
  801007:	3c 5a                	cmp    $0x5a,%al
  801009:	7f 30                	jg     80103b <strtol+0x126>
			dig = *s - 'A' + 10;
  80100b:	8b 45 08             	mov    0x8(%ebp),%eax
  80100e:	8a 00                	mov    (%eax),%al
  801010:	0f be c0             	movsbl %al,%eax
  801013:	83 e8 37             	sub    $0x37,%eax
  801016:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80101c:	3b 45 10             	cmp    0x10(%ebp),%eax
  80101f:	7d 19                	jge    80103a <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801021:	ff 45 08             	incl   0x8(%ebp)
  801024:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801027:	0f af 45 10          	imul   0x10(%ebp),%eax
  80102b:	89 c2                	mov    %eax,%edx
  80102d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801030:	01 d0                	add    %edx,%eax
  801032:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801035:	e9 7b ff ff ff       	jmp    800fb5 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80103a:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80103b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80103f:	74 08                	je     801049 <strtol+0x134>
		*endptr = (char *) s;
  801041:	8b 45 0c             	mov    0xc(%ebp),%eax
  801044:	8b 55 08             	mov    0x8(%ebp),%edx
  801047:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801049:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80104d:	74 07                	je     801056 <strtol+0x141>
  80104f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801052:	f7 d8                	neg    %eax
  801054:	eb 03                	jmp    801059 <strtol+0x144>
  801056:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801059:	c9                   	leave  
  80105a:	c3                   	ret    

0080105b <ltostr>:

void
ltostr(long value, char *str)
{
  80105b:	55                   	push   %ebp
  80105c:	89 e5                	mov    %esp,%ebp
  80105e:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801061:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801068:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80106f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801073:	79 13                	jns    801088 <ltostr+0x2d>
	{
		neg = 1;
  801075:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80107c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107f:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801082:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801085:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801088:	8b 45 08             	mov    0x8(%ebp),%eax
  80108b:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801090:	99                   	cltd   
  801091:	f7 f9                	idiv   %ecx
  801093:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801096:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801099:	8d 50 01             	lea    0x1(%eax),%edx
  80109c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80109f:	89 c2                	mov    %eax,%edx
  8010a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010a4:	01 d0                	add    %edx,%eax
  8010a6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a9:	83 c2 30             	add    $0x30,%edx
  8010ac:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ae:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010b1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010b6:	f7 e9                	imul   %ecx
  8010b8:	c1 fa 02             	sar    $0x2,%edx
  8010bb:	89 c8                	mov    %ecx,%eax
  8010bd:	c1 f8 1f             	sar    $0x1f,%eax
  8010c0:	29 c2                	sub    %eax,%edx
  8010c2:	89 d0                	mov    %edx,%eax
  8010c4:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ca:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010cf:	f7 e9                	imul   %ecx
  8010d1:	c1 fa 02             	sar    $0x2,%edx
  8010d4:	89 c8                	mov    %ecx,%eax
  8010d6:	c1 f8 1f             	sar    $0x1f,%eax
  8010d9:	29 c2                	sub    %eax,%edx
  8010db:	89 d0                	mov    %edx,%eax
  8010dd:	c1 e0 02             	shl    $0x2,%eax
  8010e0:	01 d0                	add    %edx,%eax
  8010e2:	01 c0                	add    %eax,%eax
  8010e4:	29 c1                	sub    %eax,%ecx
  8010e6:	89 ca                	mov    %ecx,%edx
  8010e8:	85 d2                	test   %edx,%edx
  8010ea:	75 9c                	jne    801088 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010f3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f6:	48                   	dec    %eax
  8010f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010fa:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010fe:	74 3d                	je     80113d <ltostr+0xe2>
		start = 1 ;
  801100:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801107:	eb 34                	jmp    80113d <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801109:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110f:	01 d0                	add    %edx,%eax
  801111:	8a 00                	mov    (%eax),%al
  801113:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801116:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c2                	add    %eax,%edx
  80111e:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801121:	8b 45 0c             	mov    0xc(%ebp),%eax
  801124:	01 c8                	add    %ecx,%eax
  801126:	8a 00                	mov    (%eax),%al
  801128:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80112a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	01 c2                	add    %eax,%edx
  801132:	8a 45 eb             	mov    -0x15(%ebp),%al
  801135:	88 02                	mov    %al,(%edx)
		start++ ;
  801137:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80113a:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80113d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801143:	7c c4                	jl     801109 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801145:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801150:	90                   	nop
  801151:	c9                   	leave  
  801152:	c3                   	ret    

00801153 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801153:	55                   	push   %ebp
  801154:	89 e5                	mov    %esp,%ebp
  801156:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801159:	ff 75 08             	pushl  0x8(%ebp)
  80115c:	e8 54 fa ff ff       	call   800bb5 <strlen>
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801167:	ff 75 0c             	pushl  0xc(%ebp)
  80116a:	e8 46 fa ff ff       	call   800bb5 <strlen>
  80116f:	83 c4 04             	add    $0x4,%esp
  801172:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801175:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80117c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801183:	eb 17                	jmp    80119c <strcconcat+0x49>
		final[s] = str1[s] ;
  801185:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801188:	8b 45 10             	mov    0x10(%ebp),%eax
  80118b:	01 c2                	add    %eax,%edx
  80118d:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801190:	8b 45 08             	mov    0x8(%ebp),%eax
  801193:	01 c8                	add    %ecx,%eax
  801195:	8a 00                	mov    (%eax),%al
  801197:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801199:	ff 45 fc             	incl   -0x4(%ebp)
  80119c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80119f:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011a2:	7c e1                	jl     801185 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011a4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011ab:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011b2:	eb 1f                	jmp    8011d3 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ba:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011d0:	ff 45 f8             	incl   -0x8(%ebp)
  8011d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d9:	7c d9                	jl     8011b4 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011db:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011de:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e1:	01 d0                	add    %edx,%eax
  8011e3:	c6 00 00             	movb   $0x0,(%eax)
}
  8011e6:	90                   	nop
  8011e7:	c9                   	leave  
  8011e8:	c3                   	ret    

008011e9 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e9:	55                   	push   %ebp
  8011ea:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011f5:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f8:	8b 00                	mov    (%eax),%eax
  8011fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801201:	8b 45 10             	mov    0x10(%ebp),%eax
  801204:	01 d0                	add    %edx,%eax
  801206:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120c:	eb 0c                	jmp    80121a <strsplit+0x31>
			*string++ = 0;
  80120e:	8b 45 08             	mov    0x8(%ebp),%eax
  801211:	8d 50 01             	lea    0x1(%eax),%edx
  801214:	89 55 08             	mov    %edx,0x8(%ebp)
  801217:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121a:	8b 45 08             	mov    0x8(%ebp),%eax
  80121d:	8a 00                	mov    (%eax),%al
  80121f:	84 c0                	test   %al,%al
  801221:	74 18                	je     80123b <strsplit+0x52>
  801223:	8b 45 08             	mov    0x8(%ebp),%eax
  801226:	8a 00                	mov    (%eax),%al
  801228:	0f be c0             	movsbl %al,%eax
  80122b:	50                   	push   %eax
  80122c:	ff 75 0c             	pushl  0xc(%ebp)
  80122f:	e8 13 fb ff ff       	call   800d47 <strchr>
  801234:	83 c4 08             	add    $0x8,%esp
  801237:	85 c0                	test   %eax,%eax
  801239:	75 d3                	jne    80120e <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80123b:	8b 45 08             	mov    0x8(%ebp),%eax
  80123e:	8a 00                	mov    (%eax),%al
  801240:	84 c0                	test   %al,%al
  801242:	74 5a                	je     80129e <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	83 f8 0f             	cmp    $0xf,%eax
  80124c:	75 07                	jne    801255 <strsplit+0x6c>
		{
			return 0;
  80124e:	b8 00 00 00 00       	mov    $0x0,%eax
  801253:	eb 66                	jmp    8012bb <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	8d 48 01             	lea    0x1(%eax),%ecx
  80125d:	8b 55 14             	mov    0x14(%ebp),%edx
  801260:	89 0a                	mov    %ecx,(%edx)
  801262:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801269:	8b 45 10             	mov    0x10(%ebp),%eax
  80126c:	01 c2                	add    %eax,%edx
  80126e:	8b 45 08             	mov    0x8(%ebp),%eax
  801271:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801273:	eb 03                	jmp    801278 <strsplit+0x8f>
			string++;
  801275:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	84 c0                	test   %al,%al
  80127f:	74 8b                	je     80120c <strsplit+0x23>
  801281:	8b 45 08             	mov    0x8(%ebp),%eax
  801284:	8a 00                	mov    (%eax),%al
  801286:	0f be c0             	movsbl %al,%eax
  801289:	50                   	push   %eax
  80128a:	ff 75 0c             	pushl  0xc(%ebp)
  80128d:	e8 b5 fa ff ff       	call   800d47 <strchr>
  801292:	83 c4 08             	add    $0x8,%esp
  801295:	85 c0                	test   %eax,%eax
  801297:	74 dc                	je     801275 <strsplit+0x8c>
			string++;
	}
  801299:	e9 6e ff ff ff       	jmp    80120c <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80129e:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80129f:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a2:	8b 00                	mov    (%eax),%eax
  8012a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ab:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ae:	01 d0                	add    %edx,%eax
  8012b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012b6:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012c3:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c8:	85 c0                	test   %eax,%eax
  8012ca:	74 1f                	je     8012eb <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012cc:	e8 1d 00 00 00       	call   8012ee <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012d1:	83 ec 0c             	sub    $0xc,%esp
  8012d4:	68 f0 39 80 00       	push   $0x8039f0
  8012d9:	e8 55 f2 ff ff       	call   800533 <cprintf>
  8012de:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012e1:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012e8:	00 00 00 
	}
}
  8012eb:	90                   	nop
  8012ec:	c9                   	leave  
  8012ed:	c3                   	ret    

008012ee <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ee:	55                   	push   %ebp
  8012ef:	89 e5                	mov    %esp,%ebp
  8012f1:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  8012f4:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012fb:	00 00 00 
  8012fe:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801305:	00 00 00 
  801308:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80130f:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801312:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801319:	00 00 00 
  80131c:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801323:	00 00 00 
  801326:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80132d:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801330:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801337:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80133a:	c1 e8 0c             	shr    $0xc,%eax
  80133d:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801342:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80134c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801351:	2d 00 10 00 00       	sub    $0x1000,%eax
  801356:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  80135b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801362:	a1 20 41 80 00       	mov    0x804120,%eax
  801367:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  80136b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  80136e:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801375:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801378:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80137b:	01 d0                	add    %edx,%eax
  80137d:	48                   	dec    %eax
  80137e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801381:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801384:	ba 00 00 00 00       	mov    $0x0,%edx
  801389:	f7 75 e4             	divl   -0x1c(%ebp)
  80138c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80138f:	29 d0                	sub    %edx,%eax
  801391:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801394:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  80139b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80139e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013a8:	83 ec 04             	sub    $0x4,%esp
  8013ab:	6a 07                	push   $0x7
  8013ad:	ff 75 e8             	pushl  -0x18(%ebp)
  8013b0:	50                   	push   %eax
  8013b1:	e8 3d 06 00 00       	call   8019f3 <sys_allocate_chunk>
  8013b6:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013b9:	a1 20 41 80 00       	mov    0x804120,%eax
  8013be:	83 ec 0c             	sub    $0xc,%esp
  8013c1:	50                   	push   %eax
  8013c2:	e8 b2 0c 00 00       	call   802079 <initialize_MemBlocksList>
  8013c7:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8013ca:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8013d2:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013d6:	0f 84 f3 00 00 00    	je     8014cf <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8013dc:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013e0:	75 14                	jne    8013f6 <initialize_dyn_block_system+0x108>
  8013e2:	83 ec 04             	sub    $0x4,%esp
  8013e5:	68 15 3a 80 00       	push   $0x803a15
  8013ea:	6a 36                	push   $0x36
  8013ec:	68 33 3a 80 00       	push   $0x803a33
  8013f1:	e8 89 ee ff ff       	call   80027f <_panic>
  8013f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013f9:	8b 00                	mov    (%eax),%eax
  8013fb:	85 c0                	test   %eax,%eax
  8013fd:	74 10                	je     80140f <initialize_dyn_block_system+0x121>
  8013ff:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801402:	8b 00                	mov    (%eax),%eax
  801404:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801407:	8b 52 04             	mov    0x4(%edx),%edx
  80140a:	89 50 04             	mov    %edx,0x4(%eax)
  80140d:	eb 0b                	jmp    80141a <initialize_dyn_block_system+0x12c>
  80140f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801412:	8b 40 04             	mov    0x4(%eax),%eax
  801415:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80141a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80141d:	8b 40 04             	mov    0x4(%eax),%eax
  801420:	85 c0                	test   %eax,%eax
  801422:	74 0f                	je     801433 <initialize_dyn_block_system+0x145>
  801424:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801427:	8b 40 04             	mov    0x4(%eax),%eax
  80142a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80142d:	8b 12                	mov    (%edx),%edx
  80142f:	89 10                	mov    %edx,(%eax)
  801431:	eb 0a                	jmp    80143d <initialize_dyn_block_system+0x14f>
  801433:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801436:	8b 00                	mov    (%eax),%eax
  801438:	a3 48 41 80 00       	mov    %eax,0x804148
  80143d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801446:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801449:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801450:	a1 54 41 80 00       	mov    0x804154,%eax
  801455:	48                   	dec    %eax
  801456:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  80145b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80145e:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801465:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801468:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  80146f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801473:	75 14                	jne    801489 <initialize_dyn_block_system+0x19b>
  801475:	83 ec 04             	sub    $0x4,%esp
  801478:	68 40 3a 80 00       	push   $0x803a40
  80147d:	6a 3e                	push   $0x3e
  80147f:	68 33 3a 80 00       	push   $0x803a33
  801484:	e8 f6 ed ff ff       	call   80027f <_panic>
  801489:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80148f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801492:	89 10                	mov    %edx,(%eax)
  801494:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801497:	8b 00                	mov    (%eax),%eax
  801499:	85 c0                	test   %eax,%eax
  80149b:	74 0d                	je     8014aa <initialize_dyn_block_system+0x1bc>
  80149d:	a1 38 41 80 00       	mov    0x804138,%eax
  8014a2:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014a5:	89 50 04             	mov    %edx,0x4(%eax)
  8014a8:	eb 08                	jmp    8014b2 <initialize_dyn_block_system+0x1c4>
  8014aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014ad:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014b5:	a3 38 41 80 00       	mov    %eax,0x804138
  8014ba:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014c4:	a1 44 41 80 00       	mov    0x804144,%eax
  8014c9:	40                   	inc    %eax
  8014ca:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8014cf:	90                   	nop
  8014d0:	c9                   	leave  
  8014d1:	c3                   	ret    

008014d2 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014d2:	55                   	push   %ebp
  8014d3:	89 e5                	mov    %esp,%ebp
  8014d5:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8014d8:	e8 e0 fd ff ff       	call   8012bd <InitializeUHeap>
		if (size == 0) return NULL ;
  8014dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014e1:	75 07                	jne    8014ea <malloc+0x18>
  8014e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e8:	eb 7f                	jmp    801569 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8014ea:	e8 d2 08 00 00       	call   801dc1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ef:	85 c0                	test   %eax,%eax
  8014f1:	74 71                	je     801564 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  8014f3:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8014fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801500:	01 d0                	add    %edx,%eax
  801502:	48                   	dec    %eax
  801503:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801509:	ba 00 00 00 00       	mov    $0x0,%edx
  80150e:	f7 75 f4             	divl   -0xc(%ebp)
  801511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801514:	29 d0                	sub    %edx,%eax
  801516:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801519:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801520:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801527:	76 07                	jbe    801530 <malloc+0x5e>
					return NULL ;
  801529:	b8 00 00 00 00       	mov    $0x0,%eax
  80152e:	eb 39                	jmp    801569 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801530:	83 ec 0c             	sub    $0xc,%esp
  801533:	ff 75 08             	pushl  0x8(%ebp)
  801536:	e8 e6 0d 00 00       	call   802321 <alloc_block_FF>
  80153b:	83 c4 10             	add    $0x10,%esp
  80153e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801541:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801545:	74 16                	je     80155d <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801547:	83 ec 0c             	sub    $0xc,%esp
  80154a:	ff 75 ec             	pushl  -0x14(%ebp)
  80154d:	e8 37 0c 00 00       	call   802189 <insert_sorted_allocList>
  801552:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801555:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801558:	8b 40 08             	mov    0x8(%eax),%eax
  80155b:	eb 0c                	jmp    801569 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  80155d:	b8 00 00 00 00       	mov    $0x0,%eax
  801562:	eb 05                	jmp    801569 <malloc+0x97>
				}
		}
	return 0;
  801564:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801571:	8b 45 08             	mov    0x8(%ebp),%eax
  801574:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801577:	83 ec 08             	sub    $0x8,%esp
  80157a:	ff 75 f4             	pushl  -0xc(%ebp)
  80157d:	68 40 40 80 00       	push   $0x804040
  801582:	e8 cf 0b 00 00       	call   802156 <find_block>
  801587:	83 c4 10             	add    $0x10,%esp
  80158a:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  80158d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801590:	8b 40 0c             	mov    0xc(%eax),%eax
  801593:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801599:	8b 40 08             	mov    0x8(%eax),%eax
  80159c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  80159f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015a3:	0f 84 a1 00 00 00    	je     80164a <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8015a9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015ad:	75 17                	jne    8015c6 <free+0x5b>
  8015af:	83 ec 04             	sub    $0x4,%esp
  8015b2:	68 15 3a 80 00       	push   $0x803a15
  8015b7:	68 80 00 00 00       	push   $0x80
  8015bc:	68 33 3a 80 00       	push   $0x803a33
  8015c1:	e8 b9 ec ff ff       	call   80027f <_panic>
  8015c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c9:	8b 00                	mov    (%eax),%eax
  8015cb:	85 c0                	test   %eax,%eax
  8015cd:	74 10                	je     8015df <free+0x74>
  8015cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d2:	8b 00                	mov    (%eax),%eax
  8015d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d7:	8b 52 04             	mov    0x4(%edx),%edx
  8015da:	89 50 04             	mov    %edx,0x4(%eax)
  8015dd:	eb 0b                	jmp    8015ea <free+0x7f>
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e2:	8b 40 04             	mov    0x4(%eax),%eax
  8015e5:	a3 44 40 80 00       	mov    %eax,0x804044
  8015ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ed:	8b 40 04             	mov    0x4(%eax),%eax
  8015f0:	85 c0                	test   %eax,%eax
  8015f2:	74 0f                	je     801603 <free+0x98>
  8015f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f7:	8b 40 04             	mov    0x4(%eax),%eax
  8015fa:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015fd:	8b 12                	mov    (%edx),%edx
  8015ff:	89 10                	mov    %edx,(%eax)
  801601:	eb 0a                	jmp    80160d <free+0xa2>
  801603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801606:	8b 00                	mov    (%eax),%eax
  801608:	a3 40 40 80 00       	mov    %eax,0x804040
  80160d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801610:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801619:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801620:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801625:	48                   	dec    %eax
  801626:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  80162b:	83 ec 0c             	sub    $0xc,%esp
  80162e:	ff 75 f0             	pushl  -0x10(%ebp)
  801631:	e8 29 12 00 00       	call   80285f <insert_sorted_with_merge_freeList>
  801636:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801639:	83 ec 08             	sub    $0x8,%esp
  80163c:	ff 75 ec             	pushl  -0x14(%ebp)
  80163f:	ff 75 e8             	pushl  -0x18(%ebp)
  801642:	e8 74 03 00 00       	call   8019bb <sys_free_user_mem>
  801647:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80164a:	90                   	nop
  80164b:	c9                   	leave  
  80164c:	c3                   	ret    

0080164d <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  80164d:	55                   	push   %ebp
  80164e:	89 e5                	mov    %esp,%ebp
  801650:	83 ec 38             	sub    $0x38,%esp
  801653:	8b 45 10             	mov    0x10(%ebp),%eax
  801656:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801659:	e8 5f fc ff ff       	call   8012bd <InitializeUHeap>
	if (size == 0) return NULL ;
  80165e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801662:	75 0a                	jne    80166e <smalloc+0x21>
  801664:	b8 00 00 00 00       	mov    $0x0,%eax
  801669:	e9 b2 00 00 00       	jmp    801720 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  80166e:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801675:	76 0a                	jbe    801681 <smalloc+0x34>
		return NULL;
  801677:	b8 00 00 00 00       	mov    $0x0,%eax
  80167c:	e9 9f 00 00 00       	jmp    801720 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801681:	e8 3b 07 00 00       	call   801dc1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801686:	85 c0                	test   %eax,%eax
  801688:	0f 84 8d 00 00 00    	je     80171b <smalloc+0xce>
	struct MemBlock *b = NULL;
  80168e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801695:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80169c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80169f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a2:	01 d0                	add    %edx,%eax
  8016a4:	48                   	dec    %eax
  8016a5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8016b0:	f7 75 f0             	divl   -0x10(%ebp)
  8016b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016b6:	29 d0                	sub    %edx,%eax
  8016b8:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8016bb:	83 ec 0c             	sub    $0xc,%esp
  8016be:	ff 75 e8             	pushl  -0x18(%ebp)
  8016c1:	e8 5b 0c 00 00       	call   802321 <alloc_block_FF>
  8016c6:	83 c4 10             	add    $0x10,%esp
  8016c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8016cc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016d0:	75 07                	jne    8016d9 <smalloc+0x8c>
			return NULL;
  8016d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d7:	eb 47                	jmp    801720 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8016d9:	83 ec 0c             	sub    $0xc,%esp
  8016dc:	ff 75 f4             	pushl  -0xc(%ebp)
  8016df:	e8 a5 0a 00 00       	call   802189 <insert_sorted_allocList>
  8016e4:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8016e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016ea:	8b 40 08             	mov    0x8(%eax),%eax
  8016ed:	89 c2                	mov    %eax,%edx
  8016ef:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016f3:	52                   	push   %edx
  8016f4:	50                   	push   %eax
  8016f5:	ff 75 0c             	pushl  0xc(%ebp)
  8016f8:	ff 75 08             	pushl  0x8(%ebp)
  8016fb:	e8 46 04 00 00       	call   801b46 <sys_createSharedObject>
  801700:	83 c4 10             	add    $0x10,%esp
  801703:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801706:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80170a:	78 08                	js     801714 <smalloc+0xc7>
		return (void *)b->sva;
  80170c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80170f:	8b 40 08             	mov    0x8(%eax),%eax
  801712:	eb 0c                	jmp    801720 <smalloc+0xd3>
		}else{
		return NULL;
  801714:	b8 00 00 00 00       	mov    $0x0,%eax
  801719:	eb 05                	jmp    801720 <smalloc+0xd3>
			}

	}return NULL;
  80171b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801720:	c9                   	leave  
  801721:	c3                   	ret    

00801722 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801722:	55                   	push   %ebp
  801723:	89 e5                	mov    %esp,%ebp
  801725:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801728:	e8 90 fb ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80172d:	e8 8f 06 00 00       	call   801dc1 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801732:	85 c0                	test   %eax,%eax
  801734:	0f 84 ad 00 00 00    	je     8017e7 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80173a:	83 ec 08             	sub    $0x8,%esp
  80173d:	ff 75 0c             	pushl  0xc(%ebp)
  801740:	ff 75 08             	pushl  0x8(%ebp)
  801743:	e8 28 04 00 00       	call   801b70 <sys_getSizeOfSharedObject>
  801748:	83 c4 10             	add    $0x10,%esp
  80174b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  80174e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801752:	79 0a                	jns    80175e <sget+0x3c>
    {
    	return NULL;
  801754:	b8 00 00 00 00       	mov    $0x0,%eax
  801759:	e9 8e 00 00 00       	jmp    8017ec <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  80175e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801765:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80176c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80176f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801772:	01 d0                	add    %edx,%eax
  801774:	48                   	dec    %eax
  801775:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80177b:	ba 00 00 00 00       	mov    $0x0,%edx
  801780:	f7 75 ec             	divl   -0x14(%ebp)
  801783:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801786:	29 d0                	sub    %edx,%eax
  801788:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  80178b:	83 ec 0c             	sub    $0xc,%esp
  80178e:	ff 75 e4             	pushl  -0x1c(%ebp)
  801791:	e8 8b 0b 00 00       	call   802321 <alloc_block_FF>
  801796:	83 c4 10             	add    $0x10,%esp
  801799:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  80179c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017a0:	75 07                	jne    8017a9 <sget+0x87>
				return NULL;
  8017a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a7:	eb 43                	jmp    8017ec <sget+0xca>
			}
			insert_sorted_allocList(b);
  8017a9:	83 ec 0c             	sub    $0xc,%esp
  8017ac:	ff 75 f0             	pushl  -0x10(%ebp)
  8017af:	e8 d5 09 00 00       	call   802189 <insert_sorted_allocList>
  8017b4:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8017b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ba:	8b 40 08             	mov    0x8(%eax),%eax
  8017bd:	83 ec 04             	sub    $0x4,%esp
  8017c0:	50                   	push   %eax
  8017c1:	ff 75 0c             	pushl  0xc(%ebp)
  8017c4:	ff 75 08             	pushl  0x8(%ebp)
  8017c7:	e8 c1 03 00 00       	call   801b8d <sys_getSharedObject>
  8017cc:	83 c4 10             	add    $0x10,%esp
  8017cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8017d2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017d6:	78 08                	js     8017e0 <sget+0xbe>
			return (void *)b->sva;
  8017d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017db:	8b 40 08             	mov    0x8(%eax),%eax
  8017de:	eb 0c                	jmp    8017ec <sget+0xca>
			}else{
			return NULL;
  8017e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e5:	eb 05                	jmp    8017ec <sget+0xca>
			}
    }}return NULL;
  8017e7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017ec:	c9                   	leave  
  8017ed:	c3                   	ret    

008017ee <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017ee:	55                   	push   %ebp
  8017ef:	89 e5                	mov    %esp,%ebp
  8017f1:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017f4:	e8 c4 fa ff ff       	call   8012bd <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017f9:	83 ec 04             	sub    $0x4,%esp
  8017fc:	68 64 3a 80 00       	push   $0x803a64
  801801:	68 03 01 00 00       	push   $0x103
  801806:	68 33 3a 80 00       	push   $0x803a33
  80180b:	e8 6f ea ff ff       	call   80027f <_panic>

00801810 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801810:	55                   	push   %ebp
  801811:	89 e5                	mov    %esp,%ebp
  801813:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801816:	83 ec 04             	sub    $0x4,%esp
  801819:	68 8c 3a 80 00       	push   $0x803a8c
  80181e:	68 17 01 00 00       	push   $0x117
  801823:	68 33 3a 80 00       	push   $0x803a33
  801828:	e8 52 ea ff ff       	call   80027f <_panic>

0080182d <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
  801830:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801833:	83 ec 04             	sub    $0x4,%esp
  801836:	68 b0 3a 80 00       	push   $0x803ab0
  80183b:	68 22 01 00 00       	push   $0x122
  801840:	68 33 3a 80 00       	push   $0x803a33
  801845:	e8 35 ea ff ff       	call   80027f <_panic>

0080184a <shrink>:

}
void shrink(uint32 newSize)
{
  80184a:	55                   	push   %ebp
  80184b:	89 e5                	mov    %esp,%ebp
  80184d:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801850:	83 ec 04             	sub    $0x4,%esp
  801853:	68 b0 3a 80 00       	push   $0x803ab0
  801858:	68 27 01 00 00       	push   $0x127
  80185d:	68 33 3a 80 00       	push   $0x803a33
  801862:	e8 18 ea ff ff       	call   80027f <_panic>

00801867 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801867:	55                   	push   %ebp
  801868:	89 e5                	mov    %esp,%ebp
  80186a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80186d:	83 ec 04             	sub    $0x4,%esp
  801870:	68 b0 3a 80 00       	push   $0x803ab0
  801875:	68 2c 01 00 00       	push   $0x12c
  80187a:	68 33 3a 80 00       	push   $0x803a33
  80187f:	e8 fb e9 ff ff       	call   80027f <_panic>

00801884 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
  801887:	57                   	push   %edi
  801888:	56                   	push   %esi
  801889:	53                   	push   %ebx
  80188a:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80188d:	8b 45 08             	mov    0x8(%ebp),%eax
  801890:	8b 55 0c             	mov    0xc(%ebp),%edx
  801893:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801896:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801899:	8b 7d 18             	mov    0x18(%ebp),%edi
  80189c:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80189f:	cd 30                	int    $0x30
  8018a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018a7:	83 c4 10             	add    $0x10,%esp
  8018aa:	5b                   	pop    %ebx
  8018ab:	5e                   	pop    %esi
  8018ac:	5f                   	pop    %edi
  8018ad:	5d                   	pop    %ebp
  8018ae:	c3                   	ret    

008018af <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018af:	55                   	push   %ebp
  8018b0:	89 e5                	mov    %esp,%ebp
  8018b2:	83 ec 04             	sub    $0x4,%esp
  8018b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018bb:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	52                   	push   %edx
  8018c7:	ff 75 0c             	pushl  0xc(%ebp)
  8018ca:	50                   	push   %eax
  8018cb:	6a 00                	push   $0x0
  8018cd:	e8 b2 ff ff ff       	call   801884 <syscall>
  8018d2:	83 c4 18             	add    $0x18,%esp
}
  8018d5:	90                   	nop
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 00                	push   $0x0
  8018e5:	6a 01                	push   $0x1
  8018e7:	e8 98 ff ff ff       	call   801884 <syscall>
  8018ec:	83 c4 18             	add    $0x18,%esp
}
  8018ef:	c9                   	leave  
  8018f0:	c3                   	ret    

008018f1 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	52                   	push   %edx
  801901:	50                   	push   %eax
  801902:	6a 05                	push   $0x5
  801904:	e8 7b ff ff ff       	call   801884 <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	c9                   	leave  
  80190d:	c3                   	ret    

0080190e <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	56                   	push   %esi
  801912:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801913:	8b 75 18             	mov    0x18(%ebp),%esi
  801916:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801919:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80191c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191f:	8b 45 08             	mov    0x8(%ebp),%eax
  801922:	56                   	push   %esi
  801923:	53                   	push   %ebx
  801924:	51                   	push   %ecx
  801925:	52                   	push   %edx
  801926:	50                   	push   %eax
  801927:	6a 06                	push   $0x6
  801929:	e8 56 ff ff ff       	call   801884 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
}
  801931:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801934:	5b                   	pop    %ebx
  801935:	5e                   	pop    %esi
  801936:	5d                   	pop    %ebp
  801937:	c3                   	ret    

00801938 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801938:	55                   	push   %ebp
  801939:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80193b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193e:	8b 45 08             	mov    0x8(%ebp),%eax
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	6a 00                	push   $0x0
  801947:	52                   	push   %edx
  801948:	50                   	push   %eax
  801949:	6a 07                	push   $0x7
  80194b:	e8 34 ff ff ff       	call   801884 <syscall>
  801950:	83 c4 18             	add    $0x18,%esp
}
  801953:	c9                   	leave  
  801954:	c3                   	ret    

00801955 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801955:	55                   	push   %ebp
  801956:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801958:	6a 00                	push   $0x0
  80195a:	6a 00                	push   $0x0
  80195c:	6a 00                	push   $0x0
  80195e:	ff 75 0c             	pushl  0xc(%ebp)
  801961:	ff 75 08             	pushl  0x8(%ebp)
  801964:	6a 08                	push   $0x8
  801966:	e8 19 ff ff ff       	call   801884 <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 09                	push   $0x9
  80197f:	e8 00 ff ff ff       	call   801884 <syscall>
  801984:	83 c4 18             	add    $0x18,%esp
}
  801987:	c9                   	leave  
  801988:	c3                   	ret    

00801989 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801989:	55                   	push   %ebp
  80198a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80198c:	6a 00                	push   $0x0
  80198e:	6a 00                	push   $0x0
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	6a 0a                	push   $0xa
  801998:	e8 e7 fe ff ff       	call   801884 <syscall>
  80199d:	83 c4 18             	add    $0x18,%esp
}
  8019a0:	c9                   	leave  
  8019a1:	c3                   	ret    

008019a2 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 0b                	push   $0xb
  8019b1:	e8 ce fe ff ff       	call   801884 <syscall>
  8019b6:	83 c4 18             	add    $0x18,%esp
}
  8019b9:	c9                   	leave  
  8019ba:	c3                   	ret    

008019bb <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019bb:	55                   	push   %ebp
  8019bc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	6a 00                	push   $0x0
  8019c4:	ff 75 0c             	pushl  0xc(%ebp)
  8019c7:	ff 75 08             	pushl  0x8(%ebp)
  8019ca:	6a 0f                	push   $0xf
  8019cc:	e8 b3 fe ff ff       	call   801884 <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
	return;
  8019d4:	90                   	nop
}
  8019d5:	c9                   	leave  
  8019d6:	c3                   	ret    

008019d7 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019d7:	55                   	push   %ebp
  8019d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019da:	6a 00                	push   $0x0
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	ff 75 0c             	pushl  0xc(%ebp)
  8019e3:	ff 75 08             	pushl  0x8(%ebp)
  8019e6:	6a 10                	push   $0x10
  8019e8:	e8 97 fe ff ff       	call   801884 <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f0:	90                   	nop
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	ff 75 10             	pushl  0x10(%ebp)
  8019fd:	ff 75 0c             	pushl  0xc(%ebp)
  801a00:	ff 75 08             	pushl  0x8(%ebp)
  801a03:	6a 11                	push   $0x11
  801a05:	e8 7a fe ff ff       	call   801884 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a0d:	90                   	nop
}
  801a0e:	c9                   	leave  
  801a0f:	c3                   	ret    

00801a10 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a10:	55                   	push   %ebp
  801a11:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 0c                	push   $0xc
  801a1f:	e8 60 fe ff ff       	call   801884 <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	6a 00                	push   $0x0
  801a34:	ff 75 08             	pushl  0x8(%ebp)
  801a37:	6a 0d                	push   $0xd
  801a39:	e8 46 fe ff ff       	call   801884 <syscall>
  801a3e:	83 c4 18             	add    $0x18,%esp
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 0e                	push   $0xe
  801a52:	e8 2d fe ff ff       	call   801884 <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
}
  801a5a:	90                   	nop
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 13                	push   $0x13
  801a6c:	e8 13 fe ff ff       	call   801884 <syscall>
  801a71:	83 c4 18             	add    $0x18,%esp
}
  801a74:	90                   	nop
  801a75:	c9                   	leave  
  801a76:	c3                   	ret    

00801a77 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a77:	55                   	push   %ebp
  801a78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 00                	push   $0x0
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 14                	push   $0x14
  801a86:	e8 f9 fd ff ff       	call   801884 <syscall>
  801a8b:	83 c4 18             	add    $0x18,%esp
}
  801a8e:	90                   	nop
  801a8f:	c9                   	leave  
  801a90:	c3                   	ret    

00801a91 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a91:	55                   	push   %ebp
  801a92:	89 e5                	mov    %esp,%ebp
  801a94:	83 ec 04             	sub    $0x4,%esp
  801a97:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a9d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	50                   	push   %eax
  801aaa:	6a 15                	push   $0x15
  801aac:	e8 d3 fd ff ff       	call   801884 <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
}
  801ab4:	90                   	nop
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 16                	push   $0x16
  801ac6:	e8 b9 fd ff ff       	call   801884 <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	90                   	nop
  801acf:	c9                   	leave  
  801ad0:	c3                   	ret    

00801ad1 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ad1:	55                   	push   %ebp
  801ad2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	6a 00                	push   $0x0
  801add:	ff 75 0c             	pushl  0xc(%ebp)
  801ae0:	50                   	push   %eax
  801ae1:	6a 17                	push   $0x17
  801ae3:	e8 9c fd ff ff       	call   801884 <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	c9                   	leave  
  801aec:	c3                   	ret    

00801aed <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801aed:	55                   	push   %ebp
  801aee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801af0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801af3:	8b 45 08             	mov    0x8(%ebp),%eax
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	52                   	push   %edx
  801afd:	50                   	push   %eax
  801afe:	6a 1a                	push   $0x1a
  801b00:	e8 7f fd ff ff       	call   801884 <syscall>
  801b05:	83 c4 18             	add    $0x18,%esp
}
  801b08:	c9                   	leave  
  801b09:	c3                   	ret    

00801b0a <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b0a:	55                   	push   %ebp
  801b0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b10:	8b 45 08             	mov    0x8(%ebp),%eax
  801b13:	6a 00                	push   $0x0
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	52                   	push   %edx
  801b1a:	50                   	push   %eax
  801b1b:	6a 18                	push   $0x18
  801b1d:	e8 62 fd ff ff       	call   801884 <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	90                   	nop
  801b26:	c9                   	leave  
  801b27:	c3                   	ret    

00801b28 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b28:	55                   	push   %ebp
  801b29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	52                   	push   %edx
  801b38:	50                   	push   %eax
  801b39:	6a 19                	push   $0x19
  801b3b:	e8 44 fd ff ff       	call   801884 <syscall>
  801b40:	83 c4 18             	add    $0x18,%esp
}
  801b43:	90                   	nop
  801b44:	c9                   	leave  
  801b45:	c3                   	ret    

00801b46 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b46:	55                   	push   %ebp
  801b47:	89 e5                	mov    %esp,%ebp
  801b49:	83 ec 04             	sub    $0x4,%esp
  801b4c:	8b 45 10             	mov    0x10(%ebp),%eax
  801b4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b52:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b55:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b59:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5c:	6a 00                	push   $0x0
  801b5e:	51                   	push   %ecx
  801b5f:	52                   	push   %edx
  801b60:	ff 75 0c             	pushl  0xc(%ebp)
  801b63:	50                   	push   %eax
  801b64:	6a 1b                	push   $0x1b
  801b66:	e8 19 fd ff ff       	call   801884 <syscall>
  801b6b:	83 c4 18             	add    $0x18,%esp
}
  801b6e:	c9                   	leave  
  801b6f:	c3                   	ret    

00801b70 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b70:	55                   	push   %ebp
  801b71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b73:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b76:	8b 45 08             	mov    0x8(%ebp),%eax
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	52                   	push   %edx
  801b80:	50                   	push   %eax
  801b81:	6a 1c                	push   $0x1c
  801b83:	e8 fc fc ff ff       	call   801884 <syscall>
  801b88:	83 c4 18             	add    $0x18,%esp
}
  801b8b:	c9                   	leave  
  801b8c:	c3                   	ret    

00801b8d <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b8d:	55                   	push   %ebp
  801b8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b90:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b96:	8b 45 08             	mov    0x8(%ebp),%eax
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	51                   	push   %ecx
  801b9e:	52                   	push   %edx
  801b9f:	50                   	push   %eax
  801ba0:	6a 1d                	push   $0x1d
  801ba2:	e8 dd fc ff ff       	call   801884 <syscall>
  801ba7:	83 c4 18             	add    $0x18,%esp
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801baf:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	52                   	push   %edx
  801bbc:	50                   	push   %eax
  801bbd:	6a 1e                	push   $0x1e
  801bbf:	e8 c0 fc ff ff       	call   801884 <syscall>
  801bc4:	83 c4 18             	add    $0x18,%esp
}
  801bc7:	c9                   	leave  
  801bc8:	c3                   	ret    

00801bc9 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bc9:	55                   	push   %ebp
  801bca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 00                	push   $0x0
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 1f                	push   $0x1f
  801bd8:	e8 a7 fc ff ff       	call   801884 <syscall>
  801bdd:	83 c4 18             	add    $0x18,%esp
}
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	6a 00                	push   $0x0
  801bea:	ff 75 14             	pushl  0x14(%ebp)
  801bed:	ff 75 10             	pushl  0x10(%ebp)
  801bf0:	ff 75 0c             	pushl  0xc(%ebp)
  801bf3:	50                   	push   %eax
  801bf4:	6a 20                	push   $0x20
  801bf6:	e8 89 fc ff ff       	call   801884 <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c03:	8b 45 08             	mov    0x8(%ebp),%eax
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	50                   	push   %eax
  801c0f:	6a 21                	push   $0x21
  801c11:	e8 6e fc ff ff       	call   801884 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	90                   	nop
  801c1a:	c9                   	leave  
  801c1b:	c3                   	ret    

00801c1c <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c1c:	55                   	push   %ebp
  801c1d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	50                   	push   %eax
  801c2b:	6a 22                	push   $0x22
  801c2d:	e8 52 fc ff ff       	call   801884 <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 02                	push   $0x2
  801c46:	e8 39 fc ff ff       	call   801884 <syscall>
  801c4b:	83 c4 18             	add    $0x18,%esp
}
  801c4e:	c9                   	leave  
  801c4f:	c3                   	ret    

00801c50 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c50:	55                   	push   %ebp
  801c51:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c53:	6a 00                	push   $0x0
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 03                	push   $0x3
  801c5f:	e8 20 fc ff ff       	call   801884 <syscall>
  801c64:	83 c4 18             	add    $0x18,%esp
}
  801c67:	c9                   	leave  
  801c68:	c3                   	ret    

00801c69 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c69:	55                   	push   %ebp
  801c6a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 04                	push   $0x4
  801c78:	e8 07 fc ff ff       	call   801884 <syscall>
  801c7d:	83 c4 18             	add    $0x18,%esp
}
  801c80:	c9                   	leave  
  801c81:	c3                   	ret    

00801c82 <sys_exit_env>:


void sys_exit_env(void)
{
  801c82:	55                   	push   %ebp
  801c83:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c85:	6a 00                	push   $0x0
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 23                	push   $0x23
  801c91:	e8 ee fb ff ff       	call   801884 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
}
  801c99:	90                   	nop
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ca2:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca5:	8d 50 04             	lea    0x4(%eax),%edx
  801ca8:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	52                   	push   %edx
  801cb2:	50                   	push   %eax
  801cb3:	6a 24                	push   $0x24
  801cb5:	e8 ca fb ff ff       	call   801884 <syscall>
  801cba:	83 c4 18             	add    $0x18,%esp
	return result;
  801cbd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cc3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cc6:	89 01                	mov    %eax,(%ecx)
  801cc8:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  801cce:	c9                   	leave  
  801ccf:	c2 04 00             	ret    $0x4

00801cd2 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	ff 75 10             	pushl  0x10(%ebp)
  801cdc:	ff 75 0c             	pushl  0xc(%ebp)
  801cdf:	ff 75 08             	pushl  0x8(%ebp)
  801ce2:	6a 12                	push   $0x12
  801ce4:	e8 9b fb ff ff       	call   801884 <syscall>
  801ce9:	83 c4 18             	add    $0x18,%esp
	return ;
  801cec:	90                   	nop
}
  801ced:	c9                   	leave  
  801cee:	c3                   	ret    

00801cef <sys_rcr2>:
uint32 sys_rcr2()
{
  801cef:	55                   	push   %ebp
  801cf0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 25                	push   $0x25
  801cfe:	e8 81 fb ff ff       	call   801884 <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
}
  801d06:	c9                   	leave  
  801d07:	c3                   	ret    

00801d08 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d08:	55                   	push   %ebp
  801d09:	89 e5                	mov    %esp,%ebp
  801d0b:	83 ec 04             	sub    $0x4,%esp
  801d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d11:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d14:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	6a 00                	push   $0x0
  801d1e:	6a 00                	push   $0x0
  801d20:	50                   	push   %eax
  801d21:	6a 26                	push   $0x26
  801d23:	e8 5c fb ff ff       	call   801884 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2b:	90                   	nop
}
  801d2c:	c9                   	leave  
  801d2d:	c3                   	ret    

00801d2e <rsttst>:
void rsttst()
{
  801d2e:	55                   	push   %ebp
  801d2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d31:	6a 00                	push   $0x0
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	6a 28                	push   $0x28
  801d3d:	e8 42 fb ff ff       	call   801884 <syscall>
  801d42:	83 c4 18             	add    $0x18,%esp
	return ;
  801d45:	90                   	nop
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
  801d4b:	83 ec 04             	sub    $0x4,%esp
  801d4e:	8b 45 14             	mov    0x14(%ebp),%eax
  801d51:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d54:	8b 55 18             	mov    0x18(%ebp),%edx
  801d57:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d5b:	52                   	push   %edx
  801d5c:	50                   	push   %eax
  801d5d:	ff 75 10             	pushl  0x10(%ebp)
  801d60:	ff 75 0c             	pushl  0xc(%ebp)
  801d63:	ff 75 08             	pushl  0x8(%ebp)
  801d66:	6a 27                	push   $0x27
  801d68:	e8 17 fb ff ff       	call   801884 <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
	return ;
  801d70:	90                   	nop
}
  801d71:	c9                   	leave  
  801d72:	c3                   	ret    

00801d73 <chktst>:
void chktst(uint32 n)
{
  801d73:	55                   	push   %ebp
  801d74:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	ff 75 08             	pushl  0x8(%ebp)
  801d81:	6a 29                	push   $0x29
  801d83:	e8 fc fa ff ff       	call   801884 <syscall>
  801d88:	83 c4 18             	add    $0x18,%esp
	return ;
  801d8b:	90                   	nop
}
  801d8c:	c9                   	leave  
  801d8d:	c3                   	ret    

00801d8e <inctst>:

void inctst()
{
  801d8e:	55                   	push   %ebp
  801d8f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d91:	6a 00                	push   $0x0
  801d93:	6a 00                	push   $0x0
  801d95:	6a 00                	push   $0x0
  801d97:	6a 00                	push   $0x0
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 2a                	push   $0x2a
  801d9d:	e8 e2 fa ff ff       	call   801884 <syscall>
  801da2:	83 c4 18             	add    $0x18,%esp
	return ;
  801da5:	90                   	nop
}
  801da6:	c9                   	leave  
  801da7:	c3                   	ret    

00801da8 <gettst>:
uint32 gettst()
{
  801da8:	55                   	push   %ebp
  801da9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dab:	6a 00                	push   $0x0
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 2b                	push   $0x2b
  801db7:	e8 c8 fa ff ff       	call   801884 <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
}
  801dbf:	c9                   	leave  
  801dc0:	c3                   	ret    

00801dc1 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dc1:	55                   	push   %ebp
  801dc2:	89 e5                	mov    %esp,%ebp
  801dc4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 2c                	push   $0x2c
  801dd3:	e8 ac fa ff ff       	call   801884 <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
  801ddb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dde:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801de2:	75 07                	jne    801deb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801de4:	b8 01 00 00 00       	mov    $0x1,%eax
  801de9:	eb 05                	jmp    801df0 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801deb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801df0:	c9                   	leave  
  801df1:	c3                   	ret    

00801df2 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801df2:	55                   	push   %ebp
  801df3:	89 e5                	mov    %esp,%ebp
  801df5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 2c                	push   $0x2c
  801e04:	e8 7b fa ff ff       	call   801884 <syscall>
  801e09:	83 c4 18             	add    $0x18,%esp
  801e0c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e0f:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e13:	75 07                	jne    801e1c <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e15:	b8 01 00 00 00       	mov    $0x1,%eax
  801e1a:	eb 05                	jmp    801e21 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e21:	c9                   	leave  
  801e22:	c3                   	ret    

00801e23 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e23:	55                   	push   %ebp
  801e24:	89 e5                	mov    %esp,%ebp
  801e26:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 2c                	push   $0x2c
  801e35:	e8 4a fa ff ff       	call   801884 <syscall>
  801e3a:	83 c4 18             	add    $0x18,%esp
  801e3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e40:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e44:	75 07                	jne    801e4d <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e46:	b8 01 00 00 00       	mov    $0x1,%eax
  801e4b:	eb 05                	jmp    801e52 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e4d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e52:	c9                   	leave  
  801e53:	c3                   	ret    

00801e54 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e54:	55                   	push   %ebp
  801e55:	89 e5                	mov    %esp,%ebp
  801e57:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 2c                	push   $0x2c
  801e66:	e8 19 fa ff ff       	call   801884 <syscall>
  801e6b:	83 c4 18             	add    $0x18,%esp
  801e6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e71:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e75:	75 07                	jne    801e7e <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e77:	b8 01 00 00 00       	mov    $0x1,%eax
  801e7c:	eb 05                	jmp    801e83 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e7e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e83:	c9                   	leave  
  801e84:	c3                   	ret    

00801e85 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e85:	55                   	push   %ebp
  801e86:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e88:	6a 00                	push   $0x0
  801e8a:	6a 00                	push   $0x0
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	ff 75 08             	pushl  0x8(%ebp)
  801e93:	6a 2d                	push   $0x2d
  801e95:	e8 ea f9 ff ff       	call   801884 <syscall>
  801e9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9d:	90                   	nop
}
  801e9e:	c9                   	leave  
  801e9f:	c3                   	ret    

00801ea0 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ea0:	55                   	push   %ebp
  801ea1:	89 e5                	mov    %esp,%ebp
  801ea3:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ea4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ea7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801eaa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ead:	8b 45 08             	mov    0x8(%ebp),%eax
  801eb0:	6a 00                	push   $0x0
  801eb2:	53                   	push   %ebx
  801eb3:	51                   	push   %ecx
  801eb4:	52                   	push   %edx
  801eb5:	50                   	push   %eax
  801eb6:	6a 2e                	push   $0x2e
  801eb8:	e8 c7 f9 ff ff       	call   801884 <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
}
  801ec0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ec3:	c9                   	leave  
  801ec4:	c3                   	ret    

00801ec5 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ec5:	55                   	push   %ebp
  801ec6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ec8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  801ece:	6a 00                	push   $0x0
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	52                   	push   %edx
  801ed5:	50                   	push   %eax
  801ed6:	6a 2f                	push   $0x2f
  801ed8:	e8 a7 f9 ff ff       	call   801884 <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
  801ee5:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ee8:	83 ec 0c             	sub    $0xc,%esp
  801eeb:	68 c0 3a 80 00       	push   $0x803ac0
  801ef0:	e8 3e e6 ff ff       	call   800533 <cprintf>
  801ef5:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ef8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801eff:	83 ec 0c             	sub    $0xc,%esp
  801f02:	68 ec 3a 80 00       	push   $0x803aec
  801f07:	e8 27 e6 ff ff       	call   800533 <cprintf>
  801f0c:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f0f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f13:	a1 38 41 80 00       	mov    0x804138,%eax
  801f18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f1b:	eb 56                	jmp    801f73 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f21:	74 1c                	je     801f3f <print_mem_block_lists+0x5d>
  801f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f26:	8b 50 08             	mov    0x8(%eax),%edx
  801f29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2c:	8b 48 08             	mov    0x8(%eax),%ecx
  801f2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f32:	8b 40 0c             	mov    0xc(%eax),%eax
  801f35:	01 c8                	add    %ecx,%eax
  801f37:	39 c2                	cmp    %eax,%edx
  801f39:	73 04                	jae    801f3f <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f3b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f42:	8b 50 08             	mov    0x8(%eax),%edx
  801f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f48:	8b 40 0c             	mov    0xc(%eax),%eax
  801f4b:	01 c2                	add    %eax,%edx
  801f4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f50:	8b 40 08             	mov    0x8(%eax),%eax
  801f53:	83 ec 04             	sub    $0x4,%esp
  801f56:	52                   	push   %edx
  801f57:	50                   	push   %eax
  801f58:	68 01 3b 80 00       	push   $0x803b01
  801f5d:	e8 d1 e5 ff ff       	call   800533 <cprintf>
  801f62:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f68:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f6b:	a1 40 41 80 00       	mov    0x804140,%eax
  801f70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f77:	74 07                	je     801f80 <print_mem_block_lists+0x9e>
  801f79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7c:	8b 00                	mov    (%eax),%eax
  801f7e:	eb 05                	jmp    801f85 <print_mem_block_lists+0xa3>
  801f80:	b8 00 00 00 00       	mov    $0x0,%eax
  801f85:	a3 40 41 80 00       	mov    %eax,0x804140
  801f8a:	a1 40 41 80 00       	mov    0x804140,%eax
  801f8f:	85 c0                	test   %eax,%eax
  801f91:	75 8a                	jne    801f1d <print_mem_block_lists+0x3b>
  801f93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f97:	75 84                	jne    801f1d <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f99:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f9d:	75 10                	jne    801faf <print_mem_block_lists+0xcd>
  801f9f:	83 ec 0c             	sub    $0xc,%esp
  801fa2:	68 10 3b 80 00       	push   $0x803b10
  801fa7:	e8 87 e5 ff ff       	call   800533 <cprintf>
  801fac:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801faf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fb6:	83 ec 0c             	sub    $0xc,%esp
  801fb9:	68 34 3b 80 00       	push   $0x803b34
  801fbe:	e8 70 e5 ff ff       	call   800533 <cprintf>
  801fc3:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fc6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fca:	a1 40 40 80 00       	mov    0x804040,%eax
  801fcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd2:	eb 56                	jmp    80202a <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fd4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fd8:	74 1c                	je     801ff6 <print_mem_block_lists+0x114>
  801fda:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdd:	8b 50 08             	mov    0x8(%eax),%edx
  801fe0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe3:	8b 48 08             	mov    0x8(%eax),%ecx
  801fe6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe9:	8b 40 0c             	mov    0xc(%eax),%eax
  801fec:	01 c8                	add    %ecx,%eax
  801fee:	39 c2                	cmp    %eax,%edx
  801ff0:	73 04                	jae    801ff6 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801ff2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff9:	8b 50 08             	mov    0x8(%eax),%edx
  801ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fff:	8b 40 0c             	mov    0xc(%eax),%eax
  802002:	01 c2                	add    %eax,%edx
  802004:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802007:	8b 40 08             	mov    0x8(%eax),%eax
  80200a:	83 ec 04             	sub    $0x4,%esp
  80200d:	52                   	push   %edx
  80200e:	50                   	push   %eax
  80200f:	68 01 3b 80 00       	push   $0x803b01
  802014:	e8 1a e5 ff ff       	call   800533 <cprintf>
  802019:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80201c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802022:	a1 48 40 80 00       	mov    0x804048,%eax
  802027:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80202a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202e:	74 07                	je     802037 <print_mem_block_lists+0x155>
  802030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802033:	8b 00                	mov    (%eax),%eax
  802035:	eb 05                	jmp    80203c <print_mem_block_lists+0x15a>
  802037:	b8 00 00 00 00       	mov    $0x0,%eax
  80203c:	a3 48 40 80 00       	mov    %eax,0x804048
  802041:	a1 48 40 80 00       	mov    0x804048,%eax
  802046:	85 c0                	test   %eax,%eax
  802048:	75 8a                	jne    801fd4 <print_mem_block_lists+0xf2>
  80204a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204e:	75 84                	jne    801fd4 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802050:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802054:	75 10                	jne    802066 <print_mem_block_lists+0x184>
  802056:	83 ec 0c             	sub    $0xc,%esp
  802059:	68 4c 3b 80 00       	push   $0x803b4c
  80205e:	e8 d0 e4 ff ff       	call   800533 <cprintf>
  802063:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802066:	83 ec 0c             	sub    $0xc,%esp
  802069:	68 c0 3a 80 00       	push   $0x803ac0
  80206e:	e8 c0 e4 ff ff       	call   800533 <cprintf>
  802073:	83 c4 10             	add    $0x10,%esp

}
  802076:	90                   	nop
  802077:	c9                   	leave  
  802078:	c3                   	ret    

00802079 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802079:	55                   	push   %ebp
  80207a:	89 e5                	mov    %esp,%ebp
  80207c:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80207f:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802086:	00 00 00 
  802089:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802090:	00 00 00 
  802093:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80209a:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80209d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020a4:	e9 9e 00 00 00       	jmp    802147 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8020a9:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ae:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b1:	c1 e2 04             	shl    $0x4,%edx
  8020b4:	01 d0                	add    %edx,%eax
  8020b6:	85 c0                	test   %eax,%eax
  8020b8:	75 14                	jne    8020ce <initialize_MemBlocksList+0x55>
  8020ba:	83 ec 04             	sub    $0x4,%esp
  8020bd:	68 74 3b 80 00       	push   $0x803b74
  8020c2:	6a 3d                	push   $0x3d
  8020c4:	68 97 3b 80 00       	push   $0x803b97
  8020c9:	e8 b1 e1 ff ff       	call   80027f <_panic>
  8020ce:	a1 50 40 80 00       	mov    0x804050,%eax
  8020d3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020d6:	c1 e2 04             	shl    $0x4,%edx
  8020d9:	01 d0                	add    %edx,%eax
  8020db:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020e1:	89 10                	mov    %edx,(%eax)
  8020e3:	8b 00                	mov    (%eax),%eax
  8020e5:	85 c0                	test   %eax,%eax
  8020e7:	74 18                	je     802101 <initialize_MemBlocksList+0x88>
  8020e9:	a1 48 41 80 00       	mov    0x804148,%eax
  8020ee:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020f4:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020f7:	c1 e1 04             	shl    $0x4,%ecx
  8020fa:	01 ca                	add    %ecx,%edx
  8020fc:	89 50 04             	mov    %edx,0x4(%eax)
  8020ff:	eb 12                	jmp    802113 <initialize_MemBlocksList+0x9a>
  802101:	a1 50 40 80 00       	mov    0x804050,%eax
  802106:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802109:	c1 e2 04             	shl    $0x4,%edx
  80210c:	01 d0                	add    %edx,%eax
  80210e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802113:	a1 50 40 80 00       	mov    0x804050,%eax
  802118:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211b:	c1 e2 04             	shl    $0x4,%edx
  80211e:	01 d0                	add    %edx,%eax
  802120:	a3 48 41 80 00       	mov    %eax,0x804148
  802125:	a1 50 40 80 00       	mov    0x804050,%eax
  80212a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212d:	c1 e2 04             	shl    $0x4,%edx
  802130:	01 d0                	add    %edx,%eax
  802132:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802139:	a1 54 41 80 00       	mov    0x804154,%eax
  80213e:	40                   	inc    %eax
  80213f:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802144:	ff 45 f4             	incl   -0xc(%ebp)
  802147:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80214a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80214d:	0f 82 56 ff ff ff    	jb     8020a9 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802153:	90                   	nop
  802154:	c9                   	leave  
  802155:	c3                   	ret    

00802156 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  80215c:	8b 45 08             	mov    0x8(%ebp),%eax
  80215f:	8b 00                	mov    (%eax),%eax
  802161:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802164:	eb 18                	jmp    80217e <find_block+0x28>

		if(tmp->sva == va){
  802166:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802169:	8b 40 08             	mov    0x8(%eax),%eax
  80216c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80216f:	75 05                	jne    802176 <find_block+0x20>
			return tmp ;
  802171:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802174:	eb 11                	jmp    802187 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802176:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802179:	8b 00                	mov    (%eax),%eax
  80217b:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  80217e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802182:	75 e2                	jne    802166 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802184:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802187:	c9                   	leave  
  802188:	c3                   	ret    

00802189 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802189:	55                   	push   %ebp
  80218a:	89 e5                	mov    %esp,%ebp
  80218c:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  80218f:	a1 40 40 80 00       	mov    0x804040,%eax
  802194:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802197:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80219c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  80219f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021a3:	75 65                	jne    80220a <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8021a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a9:	75 14                	jne    8021bf <insert_sorted_allocList+0x36>
  8021ab:	83 ec 04             	sub    $0x4,%esp
  8021ae:	68 74 3b 80 00       	push   $0x803b74
  8021b3:	6a 62                	push   $0x62
  8021b5:	68 97 3b 80 00       	push   $0x803b97
  8021ba:	e8 c0 e0 ff ff       	call   80027f <_panic>
  8021bf:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	89 10                	mov    %edx,(%eax)
  8021ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cd:	8b 00                	mov    (%eax),%eax
  8021cf:	85 c0                	test   %eax,%eax
  8021d1:	74 0d                	je     8021e0 <insert_sorted_allocList+0x57>
  8021d3:	a1 40 40 80 00       	mov    0x804040,%eax
  8021d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8021db:	89 50 04             	mov    %edx,0x4(%eax)
  8021de:	eb 08                	jmp    8021e8 <insert_sorted_allocList+0x5f>
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	a3 44 40 80 00       	mov    %eax,0x804044
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	a3 40 40 80 00       	mov    %eax,0x804040
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021fa:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ff:	40                   	inc    %eax
  802200:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802205:	e9 14 01 00 00       	jmp    80231e <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80220a:	8b 45 08             	mov    0x8(%ebp),%eax
  80220d:	8b 50 08             	mov    0x8(%eax),%edx
  802210:	a1 44 40 80 00       	mov    0x804044,%eax
  802215:	8b 40 08             	mov    0x8(%eax),%eax
  802218:	39 c2                	cmp    %eax,%edx
  80221a:	76 65                	jbe    802281 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80221c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802220:	75 14                	jne    802236 <insert_sorted_allocList+0xad>
  802222:	83 ec 04             	sub    $0x4,%esp
  802225:	68 b0 3b 80 00       	push   $0x803bb0
  80222a:	6a 64                	push   $0x64
  80222c:	68 97 3b 80 00       	push   $0x803b97
  802231:	e8 49 e0 ff ff       	call   80027f <_panic>
  802236:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	89 50 04             	mov    %edx,0x4(%eax)
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	8b 40 04             	mov    0x4(%eax),%eax
  802248:	85 c0                	test   %eax,%eax
  80224a:	74 0c                	je     802258 <insert_sorted_allocList+0xcf>
  80224c:	a1 44 40 80 00       	mov    0x804044,%eax
  802251:	8b 55 08             	mov    0x8(%ebp),%edx
  802254:	89 10                	mov    %edx,(%eax)
  802256:	eb 08                	jmp    802260 <insert_sorted_allocList+0xd7>
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	a3 40 40 80 00       	mov    %eax,0x804040
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	a3 44 40 80 00       	mov    %eax,0x804044
  802268:	8b 45 08             	mov    0x8(%ebp),%eax
  80226b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802271:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802276:	40                   	inc    %eax
  802277:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80227c:	e9 9d 00 00 00       	jmp    80231e <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802281:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802288:	e9 85 00 00 00       	jmp    802312 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  80228d:	8b 45 08             	mov    0x8(%ebp),%eax
  802290:	8b 50 08             	mov    0x8(%eax),%edx
  802293:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802296:	8b 40 08             	mov    0x8(%eax),%eax
  802299:	39 c2                	cmp    %eax,%edx
  80229b:	73 6a                	jae    802307 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  80229d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022a1:	74 06                	je     8022a9 <insert_sorted_allocList+0x120>
  8022a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022a7:	75 14                	jne    8022bd <insert_sorted_allocList+0x134>
  8022a9:	83 ec 04             	sub    $0x4,%esp
  8022ac:	68 d4 3b 80 00       	push   $0x803bd4
  8022b1:	6a 6b                	push   $0x6b
  8022b3:	68 97 3b 80 00       	push   $0x803b97
  8022b8:	e8 c2 df ff ff       	call   80027f <_panic>
  8022bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c0:	8b 50 04             	mov    0x4(%eax),%edx
  8022c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c6:	89 50 04             	mov    %edx,0x4(%eax)
  8022c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022cf:	89 10                	mov    %edx,(%eax)
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d4:	8b 40 04             	mov    0x4(%eax),%eax
  8022d7:	85 c0                	test   %eax,%eax
  8022d9:	74 0d                	je     8022e8 <insert_sorted_allocList+0x15f>
  8022db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022de:	8b 40 04             	mov    0x4(%eax),%eax
  8022e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e4:	89 10                	mov    %edx,(%eax)
  8022e6:	eb 08                	jmp    8022f0 <insert_sorted_allocList+0x167>
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	a3 40 40 80 00       	mov    %eax,0x804040
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f6:	89 50 04             	mov    %edx,0x4(%eax)
  8022f9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022fe:	40                   	inc    %eax
  8022ff:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  802304:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802305:	eb 17                	jmp    80231e <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802307:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230a:	8b 00                	mov    (%eax),%eax
  80230c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80230f:	ff 45 f0             	incl   -0x10(%ebp)
  802312:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802315:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802318:	0f 8c 6f ff ff ff    	jl     80228d <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80231e:	90                   	nop
  80231f:	c9                   	leave  
  802320:	c3                   	ret    

00802321 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802321:	55                   	push   %ebp
  802322:	89 e5                	mov    %esp,%ebp
  802324:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802327:	a1 38 41 80 00       	mov    0x804138,%eax
  80232c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80232f:	e9 7c 01 00 00       	jmp    8024b0 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802334:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802337:	8b 40 0c             	mov    0xc(%eax),%eax
  80233a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233d:	0f 86 cf 00 00 00    	jbe    802412 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802343:	a1 48 41 80 00       	mov    0x804148,%eax
  802348:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  80234b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234e:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802351:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802354:	8b 55 08             	mov    0x8(%ebp),%edx
  802357:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	8b 50 08             	mov    0x8(%eax),%edx
  802360:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802363:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802369:	8b 40 0c             	mov    0xc(%eax),%eax
  80236c:	2b 45 08             	sub    0x8(%ebp),%eax
  80236f:	89 c2                	mov    %eax,%edx
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237a:	8b 50 08             	mov    0x8(%eax),%edx
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	01 c2                	add    %eax,%edx
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802388:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80238c:	75 17                	jne    8023a5 <alloc_block_FF+0x84>
  80238e:	83 ec 04             	sub    $0x4,%esp
  802391:	68 09 3c 80 00       	push   $0x803c09
  802396:	68 83 00 00 00       	push   $0x83
  80239b:	68 97 3b 80 00       	push   $0x803b97
  8023a0:	e8 da de ff ff       	call   80027f <_panic>
  8023a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a8:	8b 00                	mov    (%eax),%eax
  8023aa:	85 c0                	test   %eax,%eax
  8023ac:	74 10                	je     8023be <alloc_block_FF+0x9d>
  8023ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b1:	8b 00                	mov    (%eax),%eax
  8023b3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023b6:	8b 52 04             	mov    0x4(%edx),%edx
  8023b9:	89 50 04             	mov    %edx,0x4(%eax)
  8023bc:	eb 0b                	jmp    8023c9 <alloc_block_FF+0xa8>
  8023be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c1:	8b 40 04             	mov    0x4(%eax),%eax
  8023c4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023cc:	8b 40 04             	mov    0x4(%eax),%eax
  8023cf:	85 c0                	test   %eax,%eax
  8023d1:	74 0f                	je     8023e2 <alloc_block_FF+0xc1>
  8023d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d6:	8b 40 04             	mov    0x4(%eax),%eax
  8023d9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023dc:	8b 12                	mov    (%edx),%edx
  8023de:	89 10                	mov    %edx,(%eax)
  8023e0:	eb 0a                	jmp    8023ec <alloc_block_FF+0xcb>
  8023e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e5:	8b 00                	mov    (%eax),%eax
  8023e7:	a3 48 41 80 00       	mov    %eax,0x804148
  8023ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ef:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023ff:	a1 54 41 80 00       	mov    0x804154,%eax
  802404:	48                   	dec    %eax
  802405:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  80240a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240d:	e9 ad 00 00 00       	jmp    8024bf <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802412:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802415:	8b 40 0c             	mov    0xc(%eax),%eax
  802418:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241b:	0f 85 87 00 00 00    	jne    8024a8 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802421:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802425:	75 17                	jne    80243e <alloc_block_FF+0x11d>
  802427:	83 ec 04             	sub    $0x4,%esp
  80242a:	68 09 3c 80 00       	push   $0x803c09
  80242f:	68 87 00 00 00       	push   $0x87
  802434:	68 97 3b 80 00       	push   $0x803b97
  802439:	e8 41 de ff ff       	call   80027f <_panic>
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 00                	mov    (%eax),%eax
  802443:	85 c0                	test   %eax,%eax
  802445:	74 10                	je     802457 <alloc_block_FF+0x136>
  802447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244a:	8b 00                	mov    (%eax),%eax
  80244c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80244f:	8b 52 04             	mov    0x4(%edx),%edx
  802452:	89 50 04             	mov    %edx,0x4(%eax)
  802455:	eb 0b                	jmp    802462 <alloc_block_FF+0x141>
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	8b 40 04             	mov    0x4(%eax),%eax
  80245d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 40 04             	mov    0x4(%eax),%eax
  802468:	85 c0                	test   %eax,%eax
  80246a:	74 0f                	je     80247b <alloc_block_FF+0x15a>
  80246c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246f:	8b 40 04             	mov    0x4(%eax),%eax
  802472:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802475:	8b 12                	mov    (%edx),%edx
  802477:	89 10                	mov    %edx,(%eax)
  802479:	eb 0a                	jmp    802485 <alloc_block_FF+0x164>
  80247b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247e:	8b 00                	mov    (%eax),%eax
  802480:	a3 38 41 80 00       	mov    %eax,0x804138
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802498:	a1 44 41 80 00       	mov    0x804144,%eax
  80249d:	48                   	dec    %eax
  80249e:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	eb 17                	jmp    8024bf <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 00                	mov    (%eax),%eax
  8024ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8024b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024b4:	0f 85 7a fe ff ff    	jne    802334 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8024ba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024bf:	c9                   	leave  
  8024c0:	c3                   	ret    

008024c1 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024c1:	55                   	push   %ebp
  8024c2:	89 e5                	mov    %esp,%ebp
  8024c4:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8024c7:	a1 38 41 80 00       	mov    0x804138,%eax
  8024cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8024cf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8024d6:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8024dd:	a1 38 41 80 00       	mov    0x804138,%eax
  8024e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e5:	e9 d0 00 00 00       	jmp    8025ba <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8024ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024f3:	0f 82 b8 00 00 00    	jb     8025b1 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  8024f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ff:	2b 45 08             	sub    0x8(%ebp),%eax
  802502:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802505:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802508:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80250b:	0f 83 a1 00 00 00    	jae    8025b2 <alloc_block_BF+0xf1>
				differsize = differance ;
  802511:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802514:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802517:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251a:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80251d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802521:	0f 85 8b 00 00 00    	jne    8025b2 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802527:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80252b:	75 17                	jne    802544 <alloc_block_BF+0x83>
  80252d:	83 ec 04             	sub    $0x4,%esp
  802530:	68 09 3c 80 00       	push   $0x803c09
  802535:	68 a0 00 00 00       	push   $0xa0
  80253a:	68 97 3b 80 00       	push   $0x803b97
  80253f:	e8 3b dd ff ff       	call   80027f <_panic>
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 00                	mov    (%eax),%eax
  802549:	85 c0                	test   %eax,%eax
  80254b:	74 10                	je     80255d <alloc_block_BF+0x9c>
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 00                	mov    (%eax),%eax
  802552:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802555:	8b 52 04             	mov    0x4(%edx),%edx
  802558:	89 50 04             	mov    %edx,0x4(%eax)
  80255b:	eb 0b                	jmp    802568 <alloc_block_BF+0xa7>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 40 04             	mov    0x4(%eax),%eax
  802563:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	8b 40 04             	mov    0x4(%eax),%eax
  80256e:	85 c0                	test   %eax,%eax
  802570:	74 0f                	je     802581 <alloc_block_BF+0xc0>
  802572:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802575:	8b 40 04             	mov    0x4(%eax),%eax
  802578:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80257b:	8b 12                	mov    (%edx),%edx
  80257d:	89 10                	mov    %edx,(%eax)
  80257f:	eb 0a                	jmp    80258b <alloc_block_BF+0xca>
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	8b 00                	mov    (%eax),%eax
  802586:	a3 38 41 80 00       	mov    %eax,0x804138
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80259e:	a1 44 41 80 00       	mov    0x804144,%eax
  8025a3:	48                   	dec    %eax
  8025a4:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	e9 0c 01 00 00       	jmp    8026bd <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8025b1:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8025b2:	a1 40 41 80 00       	mov    0x804140,%eax
  8025b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025be:	74 07                	je     8025c7 <alloc_block_BF+0x106>
  8025c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c3:	8b 00                	mov    (%eax),%eax
  8025c5:	eb 05                	jmp    8025cc <alloc_block_BF+0x10b>
  8025c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8025cc:	a3 40 41 80 00       	mov    %eax,0x804140
  8025d1:	a1 40 41 80 00       	mov    0x804140,%eax
  8025d6:	85 c0                	test   %eax,%eax
  8025d8:	0f 85 0c ff ff ff    	jne    8024ea <alloc_block_BF+0x29>
  8025de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e2:	0f 85 02 ff ff ff    	jne    8024ea <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  8025e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ec:	0f 84 c6 00 00 00    	je     8026b8 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  8025f2:	a1 48 41 80 00       	mov    0x804148,%eax
  8025f7:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  8025fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025fd:	8b 55 08             	mov    0x8(%ebp),%edx
  802600:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802603:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802606:	8b 50 08             	mov    0x8(%eax),%edx
  802609:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80260c:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  80260f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802612:	8b 40 0c             	mov    0xc(%eax),%eax
  802615:	2b 45 08             	sub    0x8(%ebp),%eax
  802618:	89 c2                	mov    %eax,%edx
  80261a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261d:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802623:	8b 50 08             	mov    0x8(%eax),%edx
  802626:	8b 45 08             	mov    0x8(%ebp),%eax
  802629:	01 c2                	add    %eax,%edx
  80262b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262e:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802631:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802635:	75 17                	jne    80264e <alloc_block_BF+0x18d>
  802637:	83 ec 04             	sub    $0x4,%esp
  80263a:	68 09 3c 80 00       	push   $0x803c09
  80263f:	68 af 00 00 00       	push   $0xaf
  802644:	68 97 3b 80 00       	push   $0x803b97
  802649:	e8 31 dc ff ff       	call   80027f <_panic>
  80264e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802651:	8b 00                	mov    (%eax),%eax
  802653:	85 c0                	test   %eax,%eax
  802655:	74 10                	je     802667 <alloc_block_BF+0x1a6>
  802657:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265a:	8b 00                	mov    (%eax),%eax
  80265c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80265f:	8b 52 04             	mov    0x4(%edx),%edx
  802662:	89 50 04             	mov    %edx,0x4(%eax)
  802665:	eb 0b                	jmp    802672 <alloc_block_BF+0x1b1>
  802667:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266a:	8b 40 04             	mov    0x4(%eax),%eax
  80266d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802672:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802675:	8b 40 04             	mov    0x4(%eax),%eax
  802678:	85 c0                	test   %eax,%eax
  80267a:	74 0f                	je     80268b <alloc_block_BF+0x1ca>
  80267c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80267f:	8b 40 04             	mov    0x4(%eax),%eax
  802682:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802685:	8b 12                	mov    (%edx),%edx
  802687:	89 10                	mov    %edx,(%eax)
  802689:	eb 0a                	jmp    802695 <alloc_block_BF+0x1d4>
  80268b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80268e:	8b 00                	mov    (%eax),%eax
  802690:	a3 48 41 80 00       	mov    %eax,0x804148
  802695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802698:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80269e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a8:	a1 54 41 80 00       	mov    0x804154,%eax
  8026ad:	48                   	dec    %eax
  8026ae:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8026b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b6:	eb 05                	jmp    8026bd <alloc_block_BF+0x1fc>
	}

	return NULL;
  8026b8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026bd:	c9                   	leave  
  8026be:	c3                   	ret    

008026bf <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8026bf:	55                   	push   %ebp
  8026c0:	89 e5                	mov    %esp,%ebp
  8026c2:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8026c5:	a1 38 41 80 00       	mov    0x804138,%eax
  8026ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8026cd:	e9 7c 01 00 00       	jmp    80284e <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8026d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d5:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026db:	0f 86 cf 00 00 00    	jbe    8027b0 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8026e1:	a1 48 41 80 00       	mov    0x804148,%eax
  8026e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8026e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ec:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  8026ef:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f5:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  8026f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026fb:	8b 50 08             	mov    0x8(%eax),%edx
  8026fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802701:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802707:	8b 40 0c             	mov    0xc(%eax),%eax
  80270a:	2b 45 08             	sub    0x8(%ebp),%eax
  80270d:	89 c2                	mov    %eax,%edx
  80270f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802712:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	8b 50 08             	mov    0x8(%eax),%edx
  80271b:	8b 45 08             	mov    0x8(%ebp),%eax
  80271e:	01 c2                	add    %eax,%edx
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802726:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80272a:	75 17                	jne    802743 <alloc_block_NF+0x84>
  80272c:	83 ec 04             	sub    $0x4,%esp
  80272f:	68 09 3c 80 00       	push   $0x803c09
  802734:	68 c4 00 00 00       	push   $0xc4
  802739:	68 97 3b 80 00       	push   $0x803b97
  80273e:	e8 3c db ff ff       	call   80027f <_panic>
  802743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802746:	8b 00                	mov    (%eax),%eax
  802748:	85 c0                	test   %eax,%eax
  80274a:	74 10                	je     80275c <alloc_block_NF+0x9d>
  80274c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80274f:	8b 00                	mov    (%eax),%eax
  802751:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802754:	8b 52 04             	mov    0x4(%edx),%edx
  802757:	89 50 04             	mov    %edx,0x4(%eax)
  80275a:	eb 0b                	jmp    802767 <alloc_block_NF+0xa8>
  80275c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275f:	8b 40 04             	mov    0x4(%eax),%eax
  802762:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802767:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276a:	8b 40 04             	mov    0x4(%eax),%eax
  80276d:	85 c0                	test   %eax,%eax
  80276f:	74 0f                	je     802780 <alloc_block_NF+0xc1>
  802771:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802774:	8b 40 04             	mov    0x4(%eax),%eax
  802777:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80277a:	8b 12                	mov    (%edx),%edx
  80277c:	89 10                	mov    %edx,(%eax)
  80277e:	eb 0a                	jmp    80278a <alloc_block_NF+0xcb>
  802780:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802783:	8b 00                	mov    (%eax),%eax
  802785:	a3 48 41 80 00       	mov    %eax,0x804148
  80278a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802793:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802796:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80279d:	a1 54 41 80 00       	mov    0x804154,%eax
  8027a2:	48                   	dec    %eax
  8027a3:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8027a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ab:	e9 ad 00 00 00       	jmp    80285d <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8027b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b9:	0f 85 87 00 00 00    	jne    802846 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8027bf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027c3:	75 17                	jne    8027dc <alloc_block_NF+0x11d>
  8027c5:	83 ec 04             	sub    $0x4,%esp
  8027c8:	68 09 3c 80 00       	push   $0x803c09
  8027cd:	68 c8 00 00 00       	push   $0xc8
  8027d2:	68 97 3b 80 00       	push   $0x803b97
  8027d7:	e8 a3 da ff ff       	call   80027f <_panic>
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 00                	mov    (%eax),%eax
  8027e1:	85 c0                	test   %eax,%eax
  8027e3:	74 10                	je     8027f5 <alloc_block_NF+0x136>
  8027e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e8:	8b 00                	mov    (%eax),%eax
  8027ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ed:	8b 52 04             	mov    0x4(%edx),%edx
  8027f0:	89 50 04             	mov    %edx,0x4(%eax)
  8027f3:	eb 0b                	jmp    802800 <alloc_block_NF+0x141>
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 40 04             	mov    0x4(%eax),%eax
  8027fb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	8b 40 04             	mov    0x4(%eax),%eax
  802806:	85 c0                	test   %eax,%eax
  802808:	74 0f                	je     802819 <alloc_block_NF+0x15a>
  80280a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280d:	8b 40 04             	mov    0x4(%eax),%eax
  802810:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802813:	8b 12                	mov    (%edx),%edx
  802815:	89 10                	mov    %edx,(%eax)
  802817:	eb 0a                	jmp    802823 <alloc_block_NF+0x164>
  802819:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281c:	8b 00                	mov    (%eax),%eax
  80281e:	a3 38 41 80 00       	mov    %eax,0x804138
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802836:	a1 44 41 80 00       	mov    0x804144,%eax
  80283b:	48                   	dec    %eax
  80283c:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	eb 17                	jmp    80285d <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 00                	mov    (%eax),%eax
  80284b:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  80284e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802852:	0f 85 7a fe ff ff    	jne    8026d2 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802858:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80285d:	c9                   	leave  
  80285e:	c3                   	ret    

0080285f <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80285f:	55                   	push   %ebp
  802860:	89 e5                	mov    %esp,%ebp
  802862:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802865:	a1 38 41 80 00       	mov    0x804138,%eax
  80286a:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  80286d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802872:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802875:	a1 44 41 80 00       	mov    0x804144,%eax
  80287a:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  80287d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802881:	75 68                	jne    8028eb <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802883:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802887:	75 17                	jne    8028a0 <insert_sorted_with_merge_freeList+0x41>
  802889:	83 ec 04             	sub    $0x4,%esp
  80288c:	68 74 3b 80 00       	push   $0x803b74
  802891:	68 da 00 00 00       	push   $0xda
  802896:	68 97 3b 80 00       	push   $0x803b97
  80289b:	e8 df d9 ff ff       	call   80027f <_panic>
  8028a0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a9:	89 10                	mov    %edx,(%eax)
  8028ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ae:	8b 00                	mov    (%eax),%eax
  8028b0:	85 c0                	test   %eax,%eax
  8028b2:	74 0d                	je     8028c1 <insert_sorted_with_merge_freeList+0x62>
  8028b4:	a1 38 41 80 00       	mov    0x804138,%eax
  8028b9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028bc:	89 50 04             	mov    %edx,0x4(%eax)
  8028bf:	eb 08                	jmp    8028c9 <insert_sorted_with_merge_freeList+0x6a>
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cc:	a3 38 41 80 00       	mov    %eax,0x804138
  8028d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028db:	a1 44 41 80 00       	mov    0x804144,%eax
  8028e0:	40                   	inc    %eax
  8028e1:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  8028e6:	e9 49 07 00 00       	jmp    803034 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  8028eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ee:	8b 50 08             	mov    0x8(%eax),%edx
  8028f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028f7:	01 c2                	add    %eax,%edx
  8028f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fc:	8b 40 08             	mov    0x8(%eax),%eax
  8028ff:	39 c2                	cmp    %eax,%edx
  802901:	73 77                	jae    80297a <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802903:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802906:	8b 00                	mov    (%eax),%eax
  802908:	85 c0                	test   %eax,%eax
  80290a:	75 6e                	jne    80297a <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  80290c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802910:	74 68                	je     80297a <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802912:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802916:	75 17                	jne    80292f <insert_sorted_with_merge_freeList+0xd0>
  802918:	83 ec 04             	sub    $0x4,%esp
  80291b:	68 b0 3b 80 00       	push   $0x803bb0
  802920:	68 e0 00 00 00       	push   $0xe0
  802925:	68 97 3b 80 00       	push   $0x803b97
  80292a:	e8 50 d9 ff ff       	call   80027f <_panic>
  80292f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802935:	8b 45 08             	mov    0x8(%ebp),%eax
  802938:	89 50 04             	mov    %edx,0x4(%eax)
  80293b:	8b 45 08             	mov    0x8(%ebp),%eax
  80293e:	8b 40 04             	mov    0x4(%eax),%eax
  802941:	85 c0                	test   %eax,%eax
  802943:	74 0c                	je     802951 <insert_sorted_with_merge_freeList+0xf2>
  802945:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80294a:	8b 55 08             	mov    0x8(%ebp),%edx
  80294d:	89 10                	mov    %edx,(%eax)
  80294f:	eb 08                	jmp    802959 <insert_sorted_with_merge_freeList+0xfa>
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	a3 38 41 80 00       	mov    %eax,0x804138
  802959:	8b 45 08             	mov    0x8(%ebp),%eax
  80295c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80296a:	a1 44 41 80 00       	mov    0x804144,%eax
  80296f:	40                   	inc    %eax
  802970:	a3 44 41 80 00       	mov    %eax,0x804144
  802975:	e9 ba 06 00 00       	jmp    803034 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  80297a:	8b 45 08             	mov    0x8(%ebp),%eax
  80297d:	8b 50 0c             	mov    0xc(%eax),%edx
  802980:	8b 45 08             	mov    0x8(%ebp),%eax
  802983:	8b 40 08             	mov    0x8(%eax),%eax
  802986:	01 c2                	add    %eax,%edx
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 40 08             	mov    0x8(%eax),%eax
  80298e:	39 c2                	cmp    %eax,%edx
  802990:	73 78                	jae    802a0a <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802992:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802995:	8b 40 04             	mov    0x4(%eax),%eax
  802998:	85 c0                	test   %eax,%eax
  80299a:	75 6e                	jne    802a0a <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  80299c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029a0:	74 68                	je     802a0a <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8029a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029a6:	75 17                	jne    8029bf <insert_sorted_with_merge_freeList+0x160>
  8029a8:	83 ec 04             	sub    $0x4,%esp
  8029ab:	68 74 3b 80 00       	push   $0x803b74
  8029b0:	68 e6 00 00 00       	push   $0xe6
  8029b5:	68 97 3b 80 00       	push   $0x803b97
  8029ba:	e8 c0 d8 ff ff       	call   80027f <_panic>
  8029bf:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c8:	89 10                	mov    %edx,(%eax)
  8029ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cd:	8b 00                	mov    (%eax),%eax
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	74 0d                	je     8029e0 <insert_sorted_with_merge_freeList+0x181>
  8029d3:	a1 38 41 80 00       	mov    0x804138,%eax
  8029d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029db:	89 50 04             	mov    %edx,0x4(%eax)
  8029de:	eb 08                	jmp    8029e8 <insert_sorted_with_merge_freeList+0x189>
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029eb:	a3 38 41 80 00       	mov    %eax,0x804138
  8029f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029fa:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ff:	40                   	inc    %eax
  802a00:	a3 44 41 80 00       	mov    %eax,0x804144
  802a05:	e9 2a 06 00 00       	jmp    803034 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802a0a:	a1 38 41 80 00       	mov    0x804138,%eax
  802a0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a12:	e9 ed 05 00 00       	jmp    803004 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802a17:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1a:	8b 00                	mov    (%eax),%eax
  802a1c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802a1f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a23:	0f 84 a7 00 00 00    	je     802ad0 <insert_sorted_with_merge_freeList+0x271>
  802a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2c:	8b 50 0c             	mov    0xc(%eax),%edx
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	8b 40 08             	mov    0x8(%eax),%eax
  802a35:	01 c2                	add    %eax,%edx
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	8b 40 08             	mov    0x8(%eax),%eax
  802a3d:	39 c2                	cmp    %eax,%edx
  802a3f:	0f 83 8b 00 00 00    	jae    802ad0 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802a45:	8b 45 08             	mov    0x8(%ebp),%eax
  802a48:	8b 50 0c             	mov    0xc(%eax),%edx
  802a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4e:	8b 40 08             	mov    0x8(%eax),%eax
  802a51:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802a53:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a56:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802a59:	39 c2                	cmp    %eax,%edx
  802a5b:	73 73                	jae    802ad0 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802a5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a61:	74 06                	je     802a69 <insert_sorted_with_merge_freeList+0x20a>
  802a63:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a67:	75 17                	jne    802a80 <insert_sorted_with_merge_freeList+0x221>
  802a69:	83 ec 04             	sub    $0x4,%esp
  802a6c:	68 28 3c 80 00       	push   $0x803c28
  802a71:	68 f0 00 00 00       	push   $0xf0
  802a76:	68 97 3b 80 00       	push   $0x803b97
  802a7b:	e8 ff d7 ff ff       	call   80027f <_panic>
  802a80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a83:	8b 10                	mov    (%eax),%edx
  802a85:	8b 45 08             	mov    0x8(%ebp),%eax
  802a88:	89 10                	mov    %edx,(%eax)
  802a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8d:	8b 00                	mov    (%eax),%eax
  802a8f:	85 c0                	test   %eax,%eax
  802a91:	74 0b                	je     802a9e <insert_sorted_with_merge_freeList+0x23f>
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	8b 00                	mov    (%eax),%eax
  802a98:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9b:	89 50 04             	mov    %edx,0x4(%eax)
  802a9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa1:	8b 55 08             	mov    0x8(%ebp),%edx
  802aa4:	89 10                	mov    %edx,(%eax)
  802aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aac:	89 50 04             	mov    %edx,0x4(%eax)
  802aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab2:	8b 00                	mov    (%eax),%eax
  802ab4:	85 c0                	test   %eax,%eax
  802ab6:	75 08                	jne    802ac0 <insert_sorted_with_merge_freeList+0x261>
  802ab8:	8b 45 08             	mov    0x8(%ebp),%eax
  802abb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ac0:	a1 44 41 80 00       	mov    0x804144,%eax
  802ac5:	40                   	inc    %eax
  802ac6:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802acb:	e9 64 05 00 00       	jmp    803034 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802ad0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ad5:	8b 50 0c             	mov    0xc(%eax),%edx
  802ad8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802add:	8b 40 08             	mov    0x8(%eax),%eax
  802ae0:	01 c2                	add    %eax,%edx
  802ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae5:	8b 40 08             	mov    0x8(%eax),%eax
  802ae8:	39 c2                	cmp    %eax,%edx
  802aea:	0f 85 b1 00 00 00    	jne    802ba1 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802af0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802af5:	85 c0                	test   %eax,%eax
  802af7:	0f 84 a4 00 00 00    	je     802ba1 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802afd:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b02:	8b 00                	mov    (%eax),%eax
  802b04:	85 c0                	test   %eax,%eax
  802b06:	0f 85 95 00 00 00    	jne    802ba1 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802b0c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b11:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b17:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1d:	8b 52 0c             	mov    0xc(%edx),%edx
  802b20:	01 ca                	add    %ecx,%edx
  802b22:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802b25:	8b 45 08             	mov    0x8(%ebp),%eax
  802b28:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b32:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802b39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b3d:	75 17                	jne    802b56 <insert_sorted_with_merge_freeList+0x2f7>
  802b3f:	83 ec 04             	sub    $0x4,%esp
  802b42:	68 74 3b 80 00       	push   $0x803b74
  802b47:	68 ff 00 00 00       	push   $0xff
  802b4c:	68 97 3b 80 00       	push   $0x803b97
  802b51:	e8 29 d7 ff ff       	call   80027f <_panic>
  802b56:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	89 10                	mov    %edx,(%eax)
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	8b 00                	mov    (%eax),%eax
  802b66:	85 c0                	test   %eax,%eax
  802b68:	74 0d                	je     802b77 <insert_sorted_with_merge_freeList+0x318>
  802b6a:	a1 48 41 80 00       	mov    0x804148,%eax
  802b6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b72:	89 50 04             	mov    %edx,0x4(%eax)
  802b75:	eb 08                	jmp    802b7f <insert_sorted_with_merge_freeList+0x320>
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	a3 48 41 80 00       	mov    %eax,0x804148
  802b87:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b91:	a1 54 41 80 00       	mov    0x804154,%eax
  802b96:	40                   	inc    %eax
  802b97:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802b9c:	e9 93 04 00 00       	jmp    803034 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802ba1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba4:	8b 50 08             	mov    0x8(%eax),%edx
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 40 0c             	mov    0xc(%eax),%eax
  802bad:	01 c2                	add    %eax,%edx
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	8b 40 08             	mov    0x8(%eax),%eax
  802bb5:	39 c2                	cmp    %eax,%edx
  802bb7:	0f 85 ae 00 00 00    	jne    802c6b <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	8b 50 0c             	mov    0xc(%eax),%edx
  802bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc6:	8b 40 08             	mov    0x8(%eax),%eax
  802bc9:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802bcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bce:	8b 00                	mov    (%eax),%eax
  802bd0:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802bd3:	39 c2                	cmp    %eax,%edx
  802bd5:	0f 84 90 00 00 00    	je     802c6b <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	8b 50 0c             	mov    0xc(%eax),%edx
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	8b 40 0c             	mov    0xc(%eax),%eax
  802be7:	01 c2                	add    %eax,%edx
  802be9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bec:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802bef:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802bf9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c07:	75 17                	jne    802c20 <insert_sorted_with_merge_freeList+0x3c1>
  802c09:	83 ec 04             	sub    $0x4,%esp
  802c0c:	68 74 3b 80 00       	push   $0x803b74
  802c11:	68 0b 01 00 00       	push   $0x10b
  802c16:	68 97 3b 80 00       	push   $0x803b97
  802c1b:	e8 5f d6 ff ff       	call   80027f <_panic>
  802c20:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	89 10                	mov    %edx,(%eax)
  802c2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2e:	8b 00                	mov    (%eax),%eax
  802c30:	85 c0                	test   %eax,%eax
  802c32:	74 0d                	je     802c41 <insert_sorted_with_merge_freeList+0x3e2>
  802c34:	a1 48 41 80 00       	mov    0x804148,%eax
  802c39:	8b 55 08             	mov    0x8(%ebp),%edx
  802c3c:	89 50 04             	mov    %edx,0x4(%eax)
  802c3f:	eb 08                	jmp    802c49 <insert_sorted_with_merge_freeList+0x3ea>
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c49:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4c:	a3 48 41 80 00       	mov    %eax,0x804148
  802c51:	8b 45 08             	mov    0x8(%ebp),%eax
  802c54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c5b:	a1 54 41 80 00       	mov    0x804154,%eax
  802c60:	40                   	inc    %eax
  802c61:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802c66:	e9 c9 03 00 00       	jmp    803034 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6e:	8b 50 0c             	mov    0xc(%eax),%edx
  802c71:	8b 45 08             	mov    0x8(%ebp),%eax
  802c74:	8b 40 08             	mov    0x8(%eax),%eax
  802c77:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802c79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7c:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802c7f:	39 c2                	cmp    %eax,%edx
  802c81:	0f 85 bb 00 00 00    	jne    802d42 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802c87:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8b:	0f 84 b1 00 00 00    	je     802d42 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 40 04             	mov    0x4(%eax),%eax
  802c97:	85 c0                	test   %eax,%eax
  802c99:	0f 85 a3 00 00 00    	jne    802d42 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802c9f:	a1 38 41 80 00       	mov    0x804138,%eax
  802ca4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca7:	8b 52 08             	mov    0x8(%edx),%edx
  802caa:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802cad:	a1 38 41 80 00       	mov    0x804138,%eax
  802cb2:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cb8:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802cbb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cbe:	8b 52 0c             	mov    0xc(%edx),%edx
  802cc1:	01 ca                	add    %ecx,%edx
  802cc3:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802cda:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cde:	75 17                	jne    802cf7 <insert_sorted_with_merge_freeList+0x498>
  802ce0:	83 ec 04             	sub    $0x4,%esp
  802ce3:	68 74 3b 80 00       	push   $0x803b74
  802ce8:	68 17 01 00 00       	push   $0x117
  802ced:	68 97 3b 80 00       	push   $0x803b97
  802cf2:	e8 88 d5 ff ff       	call   80027f <_panic>
  802cf7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	89 10                	mov    %edx,(%eax)
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	8b 00                	mov    (%eax),%eax
  802d07:	85 c0                	test   %eax,%eax
  802d09:	74 0d                	je     802d18 <insert_sorted_with_merge_freeList+0x4b9>
  802d0b:	a1 48 41 80 00       	mov    0x804148,%eax
  802d10:	8b 55 08             	mov    0x8(%ebp),%edx
  802d13:	89 50 04             	mov    %edx,0x4(%eax)
  802d16:	eb 08                	jmp    802d20 <insert_sorted_with_merge_freeList+0x4c1>
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	a3 48 41 80 00       	mov    %eax,0x804148
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d32:	a1 54 41 80 00       	mov    0x804154,%eax
  802d37:	40                   	inc    %eax
  802d38:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d3d:	e9 f2 02 00 00       	jmp    803034 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802d42:	8b 45 08             	mov    0x8(%ebp),%eax
  802d45:	8b 50 08             	mov    0x8(%eax),%edx
  802d48:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4e:	01 c2                	add    %eax,%edx
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	8b 40 08             	mov    0x8(%eax),%eax
  802d56:	39 c2                	cmp    %eax,%edx
  802d58:	0f 85 be 00 00 00    	jne    802e1c <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802d5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d61:	8b 40 04             	mov    0x4(%eax),%eax
  802d64:	8b 50 08             	mov    0x8(%eax),%edx
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 40 04             	mov    0x4(%eax),%eax
  802d6d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d70:	01 c2                	add    %eax,%edx
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	8b 40 08             	mov    0x8(%eax),%eax
  802d78:	39 c2                	cmp    %eax,%edx
  802d7a:	0f 84 9c 00 00 00    	je     802e1c <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	8b 50 08             	mov    0x8(%eax),%edx
  802d86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d89:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	8b 50 0c             	mov    0xc(%eax),%edx
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	8b 40 0c             	mov    0xc(%eax),%eax
  802d98:	01 c2                	add    %eax,%edx
  802d9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9d:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802da0:	8b 45 08             	mov    0x8(%ebp),%eax
  802da3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802daa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dad:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802db4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db8:	75 17                	jne    802dd1 <insert_sorted_with_merge_freeList+0x572>
  802dba:	83 ec 04             	sub    $0x4,%esp
  802dbd:	68 74 3b 80 00       	push   $0x803b74
  802dc2:	68 26 01 00 00       	push   $0x126
  802dc7:	68 97 3b 80 00       	push   $0x803b97
  802dcc:	e8 ae d4 ff ff       	call   80027f <_panic>
  802dd1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	89 10                	mov    %edx,(%eax)
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	8b 00                	mov    (%eax),%eax
  802de1:	85 c0                	test   %eax,%eax
  802de3:	74 0d                	je     802df2 <insert_sorted_with_merge_freeList+0x593>
  802de5:	a1 48 41 80 00       	mov    0x804148,%eax
  802dea:	8b 55 08             	mov    0x8(%ebp),%edx
  802ded:	89 50 04             	mov    %edx,0x4(%eax)
  802df0:	eb 08                	jmp    802dfa <insert_sorted_with_merge_freeList+0x59b>
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	a3 48 41 80 00       	mov    %eax,0x804148
  802e02:	8b 45 08             	mov    0x8(%ebp),%eax
  802e05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e0c:	a1 54 41 80 00       	mov    0x804154,%eax
  802e11:	40                   	inc    %eax
  802e12:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802e17:	e9 18 02 00 00       	jmp    803034 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	8b 50 0c             	mov    0xc(%eax),%edx
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 40 08             	mov    0x8(%eax),%eax
  802e28:	01 c2                	add    %eax,%edx
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	8b 40 08             	mov    0x8(%eax),%eax
  802e30:	39 c2                	cmp    %eax,%edx
  802e32:	0f 85 c4 01 00 00    	jne    802ffc <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	8b 50 0c             	mov    0xc(%eax),%edx
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	8b 40 08             	mov    0x8(%eax),%eax
  802e44:	01 c2                	add    %eax,%edx
  802e46:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e49:	8b 00                	mov    (%eax),%eax
  802e4b:	8b 40 08             	mov    0x8(%eax),%eax
  802e4e:	39 c2                	cmp    %eax,%edx
  802e50:	0f 85 a6 01 00 00    	jne    802ffc <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802e56:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e5a:	0f 84 9c 01 00 00    	je     802ffc <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	8b 50 0c             	mov    0xc(%eax),%edx
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6c:	01 c2                	add    %eax,%edx
  802e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e71:	8b 00                	mov    (%eax),%eax
  802e73:	8b 40 0c             	mov    0xc(%eax),%eax
  802e76:	01 c2                	add    %eax,%edx
  802e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7b:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802e88:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802e92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e96:	75 17                	jne    802eaf <insert_sorted_with_merge_freeList+0x650>
  802e98:	83 ec 04             	sub    $0x4,%esp
  802e9b:	68 74 3b 80 00       	push   $0x803b74
  802ea0:	68 32 01 00 00       	push   $0x132
  802ea5:	68 97 3b 80 00       	push   $0x803b97
  802eaa:	e8 d0 d3 ff ff       	call   80027f <_panic>
  802eaf:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	89 10                	mov    %edx,(%eax)
  802eba:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebd:	8b 00                	mov    (%eax),%eax
  802ebf:	85 c0                	test   %eax,%eax
  802ec1:	74 0d                	je     802ed0 <insert_sorted_with_merge_freeList+0x671>
  802ec3:	a1 48 41 80 00       	mov    0x804148,%eax
  802ec8:	8b 55 08             	mov    0x8(%ebp),%edx
  802ecb:	89 50 04             	mov    %edx,0x4(%eax)
  802ece:	eb 08                	jmp    802ed8 <insert_sorted_with_merge_freeList+0x679>
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	a3 48 41 80 00       	mov    %eax,0x804148
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eea:	a1 54 41 80 00       	mov    0x804154,%eax
  802eef:	40                   	inc    %eax
  802ef0:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802ef5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef8:	8b 00                	mov    (%eax),%eax
  802efa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f04:	8b 00                	mov    (%eax),%eax
  802f06:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f10:	8b 00                	mov    (%eax),%eax
  802f12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802f15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f19:	75 17                	jne    802f32 <insert_sorted_with_merge_freeList+0x6d3>
  802f1b:	83 ec 04             	sub    $0x4,%esp
  802f1e:	68 09 3c 80 00       	push   $0x803c09
  802f23:	68 36 01 00 00       	push   $0x136
  802f28:	68 97 3b 80 00       	push   $0x803b97
  802f2d:	e8 4d d3 ff ff       	call   80027f <_panic>
  802f32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f35:	8b 00                	mov    (%eax),%eax
  802f37:	85 c0                	test   %eax,%eax
  802f39:	74 10                	je     802f4b <insert_sorted_with_merge_freeList+0x6ec>
  802f3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f3e:	8b 00                	mov    (%eax),%eax
  802f40:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f43:	8b 52 04             	mov    0x4(%edx),%edx
  802f46:	89 50 04             	mov    %edx,0x4(%eax)
  802f49:	eb 0b                	jmp    802f56 <insert_sorted_with_merge_freeList+0x6f7>
  802f4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4e:	8b 40 04             	mov    0x4(%eax),%eax
  802f51:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f56:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f59:	8b 40 04             	mov    0x4(%eax),%eax
  802f5c:	85 c0                	test   %eax,%eax
  802f5e:	74 0f                	je     802f6f <insert_sorted_with_merge_freeList+0x710>
  802f60:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f63:	8b 40 04             	mov    0x4(%eax),%eax
  802f66:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f69:	8b 12                	mov    (%edx),%edx
  802f6b:	89 10                	mov    %edx,(%eax)
  802f6d:	eb 0a                	jmp    802f79 <insert_sorted_with_merge_freeList+0x71a>
  802f6f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f72:	8b 00                	mov    (%eax),%eax
  802f74:	a3 38 41 80 00       	mov    %eax,0x804138
  802f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f85:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f8c:	a1 44 41 80 00       	mov    0x804144,%eax
  802f91:	48                   	dec    %eax
  802f92:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  802f97:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f9b:	75 17                	jne    802fb4 <insert_sorted_with_merge_freeList+0x755>
  802f9d:	83 ec 04             	sub    $0x4,%esp
  802fa0:	68 74 3b 80 00       	push   $0x803b74
  802fa5:	68 37 01 00 00       	push   $0x137
  802faa:	68 97 3b 80 00       	push   $0x803b97
  802faf:	e8 cb d2 ff ff       	call   80027f <_panic>
  802fb4:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fba:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fbd:	89 10                	mov    %edx,(%eax)
  802fbf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc2:	8b 00                	mov    (%eax),%eax
  802fc4:	85 c0                	test   %eax,%eax
  802fc6:	74 0d                	je     802fd5 <insert_sorted_with_merge_freeList+0x776>
  802fc8:	a1 48 41 80 00       	mov    0x804148,%eax
  802fcd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fd0:	89 50 04             	mov    %edx,0x4(%eax)
  802fd3:	eb 08                	jmp    802fdd <insert_sorted_with_merge_freeList+0x77e>
  802fd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe0:	a3 48 41 80 00       	mov    %eax,0x804148
  802fe5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fef:	a1 54 41 80 00       	mov    0x804154,%eax
  802ff4:	40                   	inc    %eax
  802ff5:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  802ffa:	eb 38                	jmp    803034 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802ffc:	a1 40 41 80 00       	mov    0x804140,%eax
  803001:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803004:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803008:	74 07                	je     803011 <insert_sorted_with_merge_freeList+0x7b2>
  80300a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300d:	8b 00                	mov    (%eax),%eax
  80300f:	eb 05                	jmp    803016 <insert_sorted_with_merge_freeList+0x7b7>
  803011:	b8 00 00 00 00       	mov    $0x0,%eax
  803016:	a3 40 41 80 00       	mov    %eax,0x804140
  80301b:	a1 40 41 80 00       	mov    0x804140,%eax
  803020:	85 c0                	test   %eax,%eax
  803022:	0f 85 ef f9 ff ff    	jne    802a17 <insert_sorted_with_merge_freeList+0x1b8>
  803028:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80302c:	0f 85 e5 f9 ff ff    	jne    802a17 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803032:	eb 00                	jmp    803034 <insert_sorted_with_merge_freeList+0x7d5>
  803034:	90                   	nop
  803035:	c9                   	leave  
  803036:	c3                   	ret    
  803037:	90                   	nop

00803038 <__udivdi3>:
  803038:	55                   	push   %ebp
  803039:	57                   	push   %edi
  80303a:	56                   	push   %esi
  80303b:	53                   	push   %ebx
  80303c:	83 ec 1c             	sub    $0x1c,%esp
  80303f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803043:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803047:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80304b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80304f:	89 ca                	mov    %ecx,%edx
  803051:	89 f8                	mov    %edi,%eax
  803053:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803057:	85 f6                	test   %esi,%esi
  803059:	75 2d                	jne    803088 <__udivdi3+0x50>
  80305b:	39 cf                	cmp    %ecx,%edi
  80305d:	77 65                	ja     8030c4 <__udivdi3+0x8c>
  80305f:	89 fd                	mov    %edi,%ebp
  803061:	85 ff                	test   %edi,%edi
  803063:	75 0b                	jne    803070 <__udivdi3+0x38>
  803065:	b8 01 00 00 00       	mov    $0x1,%eax
  80306a:	31 d2                	xor    %edx,%edx
  80306c:	f7 f7                	div    %edi
  80306e:	89 c5                	mov    %eax,%ebp
  803070:	31 d2                	xor    %edx,%edx
  803072:	89 c8                	mov    %ecx,%eax
  803074:	f7 f5                	div    %ebp
  803076:	89 c1                	mov    %eax,%ecx
  803078:	89 d8                	mov    %ebx,%eax
  80307a:	f7 f5                	div    %ebp
  80307c:	89 cf                	mov    %ecx,%edi
  80307e:	89 fa                	mov    %edi,%edx
  803080:	83 c4 1c             	add    $0x1c,%esp
  803083:	5b                   	pop    %ebx
  803084:	5e                   	pop    %esi
  803085:	5f                   	pop    %edi
  803086:	5d                   	pop    %ebp
  803087:	c3                   	ret    
  803088:	39 ce                	cmp    %ecx,%esi
  80308a:	77 28                	ja     8030b4 <__udivdi3+0x7c>
  80308c:	0f bd fe             	bsr    %esi,%edi
  80308f:	83 f7 1f             	xor    $0x1f,%edi
  803092:	75 40                	jne    8030d4 <__udivdi3+0x9c>
  803094:	39 ce                	cmp    %ecx,%esi
  803096:	72 0a                	jb     8030a2 <__udivdi3+0x6a>
  803098:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80309c:	0f 87 9e 00 00 00    	ja     803140 <__udivdi3+0x108>
  8030a2:	b8 01 00 00 00       	mov    $0x1,%eax
  8030a7:	89 fa                	mov    %edi,%edx
  8030a9:	83 c4 1c             	add    $0x1c,%esp
  8030ac:	5b                   	pop    %ebx
  8030ad:	5e                   	pop    %esi
  8030ae:	5f                   	pop    %edi
  8030af:	5d                   	pop    %ebp
  8030b0:	c3                   	ret    
  8030b1:	8d 76 00             	lea    0x0(%esi),%esi
  8030b4:	31 ff                	xor    %edi,%edi
  8030b6:	31 c0                	xor    %eax,%eax
  8030b8:	89 fa                	mov    %edi,%edx
  8030ba:	83 c4 1c             	add    $0x1c,%esp
  8030bd:	5b                   	pop    %ebx
  8030be:	5e                   	pop    %esi
  8030bf:	5f                   	pop    %edi
  8030c0:	5d                   	pop    %ebp
  8030c1:	c3                   	ret    
  8030c2:	66 90                	xchg   %ax,%ax
  8030c4:	89 d8                	mov    %ebx,%eax
  8030c6:	f7 f7                	div    %edi
  8030c8:	31 ff                	xor    %edi,%edi
  8030ca:	89 fa                	mov    %edi,%edx
  8030cc:	83 c4 1c             	add    $0x1c,%esp
  8030cf:	5b                   	pop    %ebx
  8030d0:	5e                   	pop    %esi
  8030d1:	5f                   	pop    %edi
  8030d2:	5d                   	pop    %ebp
  8030d3:	c3                   	ret    
  8030d4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030d9:	89 eb                	mov    %ebp,%ebx
  8030db:	29 fb                	sub    %edi,%ebx
  8030dd:	89 f9                	mov    %edi,%ecx
  8030df:	d3 e6                	shl    %cl,%esi
  8030e1:	89 c5                	mov    %eax,%ebp
  8030e3:	88 d9                	mov    %bl,%cl
  8030e5:	d3 ed                	shr    %cl,%ebp
  8030e7:	89 e9                	mov    %ebp,%ecx
  8030e9:	09 f1                	or     %esi,%ecx
  8030eb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030ef:	89 f9                	mov    %edi,%ecx
  8030f1:	d3 e0                	shl    %cl,%eax
  8030f3:	89 c5                	mov    %eax,%ebp
  8030f5:	89 d6                	mov    %edx,%esi
  8030f7:	88 d9                	mov    %bl,%cl
  8030f9:	d3 ee                	shr    %cl,%esi
  8030fb:	89 f9                	mov    %edi,%ecx
  8030fd:	d3 e2                	shl    %cl,%edx
  8030ff:	8b 44 24 08          	mov    0x8(%esp),%eax
  803103:	88 d9                	mov    %bl,%cl
  803105:	d3 e8                	shr    %cl,%eax
  803107:	09 c2                	or     %eax,%edx
  803109:	89 d0                	mov    %edx,%eax
  80310b:	89 f2                	mov    %esi,%edx
  80310d:	f7 74 24 0c          	divl   0xc(%esp)
  803111:	89 d6                	mov    %edx,%esi
  803113:	89 c3                	mov    %eax,%ebx
  803115:	f7 e5                	mul    %ebp
  803117:	39 d6                	cmp    %edx,%esi
  803119:	72 19                	jb     803134 <__udivdi3+0xfc>
  80311b:	74 0b                	je     803128 <__udivdi3+0xf0>
  80311d:	89 d8                	mov    %ebx,%eax
  80311f:	31 ff                	xor    %edi,%edi
  803121:	e9 58 ff ff ff       	jmp    80307e <__udivdi3+0x46>
  803126:	66 90                	xchg   %ax,%ax
  803128:	8b 54 24 08          	mov    0x8(%esp),%edx
  80312c:	89 f9                	mov    %edi,%ecx
  80312e:	d3 e2                	shl    %cl,%edx
  803130:	39 c2                	cmp    %eax,%edx
  803132:	73 e9                	jae    80311d <__udivdi3+0xe5>
  803134:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803137:	31 ff                	xor    %edi,%edi
  803139:	e9 40 ff ff ff       	jmp    80307e <__udivdi3+0x46>
  80313e:	66 90                	xchg   %ax,%ax
  803140:	31 c0                	xor    %eax,%eax
  803142:	e9 37 ff ff ff       	jmp    80307e <__udivdi3+0x46>
  803147:	90                   	nop

00803148 <__umoddi3>:
  803148:	55                   	push   %ebp
  803149:	57                   	push   %edi
  80314a:	56                   	push   %esi
  80314b:	53                   	push   %ebx
  80314c:	83 ec 1c             	sub    $0x1c,%esp
  80314f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803153:	8b 74 24 34          	mov    0x34(%esp),%esi
  803157:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80315b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80315f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803163:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803167:	89 f3                	mov    %esi,%ebx
  803169:	89 fa                	mov    %edi,%edx
  80316b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80316f:	89 34 24             	mov    %esi,(%esp)
  803172:	85 c0                	test   %eax,%eax
  803174:	75 1a                	jne    803190 <__umoddi3+0x48>
  803176:	39 f7                	cmp    %esi,%edi
  803178:	0f 86 a2 00 00 00    	jbe    803220 <__umoddi3+0xd8>
  80317e:	89 c8                	mov    %ecx,%eax
  803180:	89 f2                	mov    %esi,%edx
  803182:	f7 f7                	div    %edi
  803184:	89 d0                	mov    %edx,%eax
  803186:	31 d2                	xor    %edx,%edx
  803188:	83 c4 1c             	add    $0x1c,%esp
  80318b:	5b                   	pop    %ebx
  80318c:	5e                   	pop    %esi
  80318d:	5f                   	pop    %edi
  80318e:	5d                   	pop    %ebp
  80318f:	c3                   	ret    
  803190:	39 f0                	cmp    %esi,%eax
  803192:	0f 87 ac 00 00 00    	ja     803244 <__umoddi3+0xfc>
  803198:	0f bd e8             	bsr    %eax,%ebp
  80319b:	83 f5 1f             	xor    $0x1f,%ebp
  80319e:	0f 84 ac 00 00 00    	je     803250 <__umoddi3+0x108>
  8031a4:	bf 20 00 00 00       	mov    $0x20,%edi
  8031a9:	29 ef                	sub    %ebp,%edi
  8031ab:	89 fe                	mov    %edi,%esi
  8031ad:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031b1:	89 e9                	mov    %ebp,%ecx
  8031b3:	d3 e0                	shl    %cl,%eax
  8031b5:	89 d7                	mov    %edx,%edi
  8031b7:	89 f1                	mov    %esi,%ecx
  8031b9:	d3 ef                	shr    %cl,%edi
  8031bb:	09 c7                	or     %eax,%edi
  8031bd:	89 e9                	mov    %ebp,%ecx
  8031bf:	d3 e2                	shl    %cl,%edx
  8031c1:	89 14 24             	mov    %edx,(%esp)
  8031c4:	89 d8                	mov    %ebx,%eax
  8031c6:	d3 e0                	shl    %cl,%eax
  8031c8:	89 c2                	mov    %eax,%edx
  8031ca:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031ce:	d3 e0                	shl    %cl,%eax
  8031d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031d4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031d8:	89 f1                	mov    %esi,%ecx
  8031da:	d3 e8                	shr    %cl,%eax
  8031dc:	09 d0                	or     %edx,%eax
  8031de:	d3 eb                	shr    %cl,%ebx
  8031e0:	89 da                	mov    %ebx,%edx
  8031e2:	f7 f7                	div    %edi
  8031e4:	89 d3                	mov    %edx,%ebx
  8031e6:	f7 24 24             	mull   (%esp)
  8031e9:	89 c6                	mov    %eax,%esi
  8031eb:	89 d1                	mov    %edx,%ecx
  8031ed:	39 d3                	cmp    %edx,%ebx
  8031ef:	0f 82 87 00 00 00    	jb     80327c <__umoddi3+0x134>
  8031f5:	0f 84 91 00 00 00    	je     80328c <__umoddi3+0x144>
  8031fb:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031ff:	29 f2                	sub    %esi,%edx
  803201:	19 cb                	sbb    %ecx,%ebx
  803203:	89 d8                	mov    %ebx,%eax
  803205:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803209:	d3 e0                	shl    %cl,%eax
  80320b:	89 e9                	mov    %ebp,%ecx
  80320d:	d3 ea                	shr    %cl,%edx
  80320f:	09 d0                	or     %edx,%eax
  803211:	89 e9                	mov    %ebp,%ecx
  803213:	d3 eb                	shr    %cl,%ebx
  803215:	89 da                	mov    %ebx,%edx
  803217:	83 c4 1c             	add    $0x1c,%esp
  80321a:	5b                   	pop    %ebx
  80321b:	5e                   	pop    %esi
  80321c:	5f                   	pop    %edi
  80321d:	5d                   	pop    %ebp
  80321e:	c3                   	ret    
  80321f:	90                   	nop
  803220:	89 fd                	mov    %edi,%ebp
  803222:	85 ff                	test   %edi,%edi
  803224:	75 0b                	jne    803231 <__umoddi3+0xe9>
  803226:	b8 01 00 00 00       	mov    $0x1,%eax
  80322b:	31 d2                	xor    %edx,%edx
  80322d:	f7 f7                	div    %edi
  80322f:	89 c5                	mov    %eax,%ebp
  803231:	89 f0                	mov    %esi,%eax
  803233:	31 d2                	xor    %edx,%edx
  803235:	f7 f5                	div    %ebp
  803237:	89 c8                	mov    %ecx,%eax
  803239:	f7 f5                	div    %ebp
  80323b:	89 d0                	mov    %edx,%eax
  80323d:	e9 44 ff ff ff       	jmp    803186 <__umoddi3+0x3e>
  803242:	66 90                	xchg   %ax,%ax
  803244:	89 c8                	mov    %ecx,%eax
  803246:	89 f2                	mov    %esi,%edx
  803248:	83 c4 1c             	add    $0x1c,%esp
  80324b:	5b                   	pop    %ebx
  80324c:	5e                   	pop    %esi
  80324d:	5f                   	pop    %edi
  80324e:	5d                   	pop    %ebp
  80324f:	c3                   	ret    
  803250:	3b 04 24             	cmp    (%esp),%eax
  803253:	72 06                	jb     80325b <__umoddi3+0x113>
  803255:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803259:	77 0f                	ja     80326a <__umoddi3+0x122>
  80325b:	89 f2                	mov    %esi,%edx
  80325d:	29 f9                	sub    %edi,%ecx
  80325f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803263:	89 14 24             	mov    %edx,(%esp)
  803266:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80326a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80326e:	8b 14 24             	mov    (%esp),%edx
  803271:	83 c4 1c             	add    $0x1c,%esp
  803274:	5b                   	pop    %ebx
  803275:	5e                   	pop    %esi
  803276:	5f                   	pop    %edi
  803277:	5d                   	pop    %ebp
  803278:	c3                   	ret    
  803279:	8d 76 00             	lea    0x0(%esi),%esi
  80327c:	2b 04 24             	sub    (%esp),%eax
  80327f:	19 fa                	sbb    %edi,%edx
  803281:	89 d1                	mov    %edx,%ecx
  803283:	89 c6                	mov    %eax,%esi
  803285:	e9 71 ff ff ff       	jmp    8031fb <__umoddi3+0xb3>
  80328a:	66 90                	xchg   %ax,%ax
  80328c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803290:	72 ea                	jb     80327c <__umoddi3+0x134>
  803292:	89 d9                	mov    %ebx,%ecx
  803294:	e9 62 ff ff ff       	jmp    8031fb <__umoddi3+0xb3>
