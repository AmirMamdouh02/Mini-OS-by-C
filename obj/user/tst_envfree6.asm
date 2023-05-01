
obj/user/tst_envfree6:     file format elf32-i386


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
  800031:	e8 5c 01 00 00       	call   800192 <libmain>
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
	// Testing scenario 6: Semaphores & shared variables
	// Testing removing the shared variables and semaphores
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 a0 33 80 00       	push   $0x8033a0
  80004a:	e8 4d 16 00 00       	call   80169c <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 5c 19 00 00       	call   8019bf <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 f4 19 00 00       	call   801a5f <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 b0 33 80 00       	push   $0x8033b0
  800079:	e8 04 05 00 00       	call   800582 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000, (myEnv->SecondListSize),50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 e3 33 80 00       	push   $0x8033e3
  800099:	e8 93 1b 00 00       	call   801c31 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_midterm", 20,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	6a 14                	push   $0x14
  8000b4:	68 ec 33 80 00       	push   $0x8033ec
  8000b9:	e8 73 1b 00 00       	call   801c31 <sys_create_env>
  8000be:	83 c4 10             	add    $0x10,%esp
  8000c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c4:	83 ec 0c             	sub    $0xc,%esp
  8000c7:	ff 75 e8             	pushl  -0x18(%ebp)
  8000ca:	e8 80 1b 00 00       	call   801c4f <sys_run_env>
  8000cf:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 10 27 00 00       	push   $0x2710
  8000da:	e8 a7 2f 00 00       	call   803086 <env_sleep>
  8000df:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000e8:	e8 62 1b 00 00       	call   801c4f <sys_run_env>
  8000ed:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f0:	90                   	nop
  8000f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f4:	8b 00                	mov    (%eax),%eax
  8000f6:	83 f8 02             	cmp    $0x2,%eax
  8000f9:	75 f6                	jne    8000f1 <_main+0xb9>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fb:	e8 bf 18 00 00       	call   8019bf <sys_calculate_free_frames>
  800100:	83 ec 08             	sub    $0x8,%esp
  800103:	50                   	push   %eax
  800104:	68 f8 33 80 00       	push   $0x8033f8
  800109:	e8 74 04 00 00       	call   800582 <cprintf>
  80010e:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800111:	83 ec 0c             	sub    $0xc,%esp
  800114:	ff 75 e8             	pushl  -0x18(%ebp)
  800117:	e8 4f 1b 00 00       	call   801c6b <sys_destroy_env>
  80011c:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	ff 75 e4             	pushl  -0x1c(%ebp)
  800125:	e8 41 1b 00 00       	call   801c6b <sys_destroy_env>
  80012a:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80012d:	e8 8d 18 00 00       	call   8019bf <sys_calculate_free_frames>
  800132:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800135:	e8 25 19 00 00       	call   801a5f <sys_pf_calculate_allocated_pages>
  80013a:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80013d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800140:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800143:	74 27                	je     80016c <_main+0x134>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800145:	83 ec 08             	sub    $0x8,%esp
  800148:	ff 75 e0             	pushl  -0x20(%ebp)
  80014b:	68 2c 34 80 00       	push   $0x80342c
  800150:	e8 2d 04 00 00       	call   800582 <cprintf>
  800155:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800158:	83 ec 04             	sub    $0x4,%esp
  80015b:	68 7c 34 80 00       	push   $0x80347c
  800160:	6a 23                	push   $0x23
  800162:	68 b2 34 80 00       	push   $0x8034b2
  800167:	e8 62 01 00 00       	call   8002ce <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016c:	83 ec 08             	sub    $0x8,%esp
  80016f:	ff 75 e0             	pushl  -0x20(%ebp)
  800172:	68 c8 34 80 00       	push   $0x8034c8
  800177:	e8 06 04 00 00       	call   800582 <cprintf>
  80017c:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 6 for envfree completed successfully.\n");
  80017f:	83 ec 0c             	sub    $0xc,%esp
  800182:	68 28 35 80 00       	push   $0x803528
  800187:	e8 f6 03 00 00       	call   800582 <cprintf>
  80018c:	83 c4 10             	add    $0x10,%esp
	return;
  80018f:	90                   	nop
}
  800190:	c9                   	leave  
  800191:	c3                   	ret    

00800192 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800192:	55                   	push   %ebp
  800193:	89 e5                	mov    %esp,%ebp
  800195:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800198:	e8 02 1b 00 00       	call   801c9f <sys_getenvindex>
  80019d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a3:	89 d0                	mov    %edx,%eax
  8001a5:	c1 e0 03             	shl    $0x3,%eax
  8001a8:	01 d0                	add    %edx,%eax
  8001aa:	01 c0                	add    %eax,%eax
  8001ac:	01 d0                	add    %edx,%eax
  8001ae:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b5:	01 d0                	add    %edx,%eax
  8001b7:	c1 e0 04             	shl    $0x4,%eax
  8001ba:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001bf:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c9:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001cf:	84 c0                	test   %al,%al
  8001d1:	74 0f                	je     8001e2 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d8:	05 5c 05 00 00       	add    $0x55c,%eax
  8001dd:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e6:	7e 0a                	jle    8001f2 <libmain+0x60>
		binaryname = argv[0];
  8001e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001eb:	8b 00                	mov    (%eax),%eax
  8001ed:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001f2:	83 ec 08             	sub    $0x8,%esp
  8001f5:	ff 75 0c             	pushl  0xc(%ebp)
  8001f8:	ff 75 08             	pushl  0x8(%ebp)
  8001fb:	e8 38 fe ff ff       	call   800038 <_main>
  800200:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800203:	e8 a4 18 00 00       	call   801aac <sys_disable_interrupt>
	cprintf("**************************************\n");
  800208:	83 ec 0c             	sub    $0xc,%esp
  80020b:	68 8c 35 80 00       	push   $0x80358c
  800210:	e8 6d 03 00 00       	call   800582 <cprintf>
  800215:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800218:	a1 20 40 80 00       	mov    0x804020,%eax
  80021d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800223:	a1 20 40 80 00       	mov    0x804020,%eax
  800228:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80022e:	83 ec 04             	sub    $0x4,%esp
  800231:	52                   	push   %edx
  800232:	50                   	push   %eax
  800233:	68 b4 35 80 00       	push   $0x8035b4
  800238:	e8 45 03 00 00       	call   800582 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800240:	a1 20 40 80 00       	mov    0x804020,%eax
  800245:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800256:	a1 20 40 80 00       	mov    0x804020,%eax
  80025b:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800261:	51                   	push   %ecx
  800262:	52                   	push   %edx
  800263:	50                   	push   %eax
  800264:	68 dc 35 80 00       	push   $0x8035dc
  800269:	e8 14 03 00 00       	call   800582 <cprintf>
  80026e:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800271:	a1 20 40 80 00       	mov    0x804020,%eax
  800276:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027c:	83 ec 08             	sub    $0x8,%esp
  80027f:	50                   	push   %eax
  800280:	68 34 36 80 00       	push   $0x803634
  800285:	e8 f8 02 00 00       	call   800582 <cprintf>
  80028a:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80028d:	83 ec 0c             	sub    $0xc,%esp
  800290:	68 8c 35 80 00       	push   $0x80358c
  800295:	e8 e8 02 00 00       	call   800582 <cprintf>
  80029a:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80029d:	e8 24 18 00 00       	call   801ac6 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a2:	e8 19 00 00 00       	call   8002c0 <exit>
}
  8002a7:	90                   	nop
  8002a8:	c9                   	leave  
  8002a9:	c3                   	ret    

008002aa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002aa:	55                   	push   %ebp
  8002ab:	89 e5                	mov    %esp,%ebp
  8002ad:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b0:	83 ec 0c             	sub    $0xc,%esp
  8002b3:	6a 00                	push   $0x0
  8002b5:	e8 b1 19 00 00       	call   801c6b <sys_destroy_env>
  8002ba:	83 c4 10             	add    $0x10,%esp
}
  8002bd:	90                   	nop
  8002be:	c9                   	leave  
  8002bf:	c3                   	ret    

008002c0 <exit>:

void
exit(void)
{
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c6:	e8 06 1a 00 00       	call   801cd1 <sys_exit_env>
}
  8002cb:	90                   	nop
  8002cc:	c9                   	leave  
  8002cd:	c3                   	ret    

008002ce <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002ce:	55                   	push   %ebp
  8002cf:	89 e5                	mov    %esp,%ebp
  8002d1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d4:	8d 45 10             	lea    0x10(%ebp),%eax
  8002d7:	83 c0 04             	add    $0x4,%eax
  8002da:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002dd:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002e2:	85 c0                	test   %eax,%eax
  8002e4:	74 16                	je     8002fc <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e6:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002eb:	83 ec 08             	sub    $0x8,%esp
  8002ee:	50                   	push   %eax
  8002ef:	68 48 36 80 00       	push   $0x803648
  8002f4:	e8 89 02 00 00       	call   800582 <cprintf>
  8002f9:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002fc:	a1 00 40 80 00       	mov    0x804000,%eax
  800301:	ff 75 0c             	pushl  0xc(%ebp)
  800304:	ff 75 08             	pushl  0x8(%ebp)
  800307:	50                   	push   %eax
  800308:	68 4d 36 80 00       	push   $0x80364d
  80030d:	e8 70 02 00 00       	call   800582 <cprintf>
  800312:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800315:	8b 45 10             	mov    0x10(%ebp),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	ff 75 f4             	pushl  -0xc(%ebp)
  80031e:	50                   	push   %eax
  80031f:	e8 f3 01 00 00       	call   800517 <vcprintf>
  800324:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800327:	83 ec 08             	sub    $0x8,%esp
  80032a:	6a 00                	push   $0x0
  80032c:	68 69 36 80 00       	push   $0x803669
  800331:	e8 e1 01 00 00       	call   800517 <vcprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800339:	e8 82 ff ff ff       	call   8002c0 <exit>

	// should not return here
	while (1) ;
  80033e:	eb fe                	jmp    80033e <_panic+0x70>

00800340 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800340:	55                   	push   %ebp
  800341:	89 e5                	mov    %esp,%ebp
  800343:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800346:	a1 20 40 80 00       	mov    0x804020,%eax
  80034b:	8b 50 74             	mov    0x74(%eax),%edx
  80034e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800351:	39 c2                	cmp    %eax,%edx
  800353:	74 14                	je     800369 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	68 6c 36 80 00       	push   $0x80366c
  80035d:	6a 26                	push   $0x26
  80035f:	68 b8 36 80 00       	push   $0x8036b8
  800364:	e8 65 ff ff ff       	call   8002ce <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800369:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800370:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800377:	e9 c2 00 00 00       	jmp    80043e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80037c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80037f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800386:	8b 45 08             	mov    0x8(%ebp),%eax
  800389:	01 d0                	add    %edx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	85 c0                	test   %eax,%eax
  80038f:	75 08                	jne    800399 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800391:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800394:	e9 a2 00 00 00       	jmp    80043b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800399:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003a7:	eb 69                	jmp    800412 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003a9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ae:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003b4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003b7:	89 d0                	mov    %edx,%eax
  8003b9:	01 c0                	add    %eax,%eax
  8003bb:	01 d0                	add    %edx,%eax
  8003bd:	c1 e0 03             	shl    $0x3,%eax
  8003c0:	01 c8                	add    %ecx,%eax
  8003c2:	8a 40 04             	mov    0x4(%eax),%al
  8003c5:	84 c0                	test   %al,%al
  8003c7:	75 46                	jne    80040f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ce:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d7:	89 d0                	mov    %edx,%eax
  8003d9:	01 c0                	add    %eax,%eax
  8003db:	01 d0                	add    %edx,%eax
  8003dd:	c1 e0 03             	shl    $0x3,%eax
  8003e0:	01 c8                	add    %ecx,%eax
  8003e2:	8b 00                	mov    (%eax),%eax
  8003e4:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003e7:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ea:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003ef:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f4:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fe:	01 c8                	add    %ecx,%eax
  800400:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800402:	39 c2                	cmp    %eax,%edx
  800404:	75 09                	jne    80040f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800406:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80040d:	eb 12                	jmp    800421 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040f:	ff 45 e8             	incl   -0x18(%ebp)
  800412:	a1 20 40 80 00       	mov    0x804020,%eax
  800417:	8b 50 74             	mov    0x74(%eax),%edx
  80041a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	77 88                	ja     8003a9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800421:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800425:	75 14                	jne    80043b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800427:	83 ec 04             	sub    $0x4,%esp
  80042a:	68 c4 36 80 00       	push   $0x8036c4
  80042f:	6a 3a                	push   $0x3a
  800431:	68 b8 36 80 00       	push   $0x8036b8
  800436:	e8 93 fe ff ff       	call   8002ce <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043b:	ff 45 f0             	incl   -0x10(%ebp)
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800444:	0f 8c 32 ff ff ff    	jl     80037c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80044a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800451:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800458:	eb 26                	jmp    800480 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80045a:	a1 20 40 80 00       	mov    0x804020,%eax
  80045f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800465:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800468:	89 d0                	mov    %edx,%eax
  80046a:	01 c0                	add    %eax,%eax
  80046c:	01 d0                	add    %edx,%eax
  80046e:	c1 e0 03             	shl    $0x3,%eax
  800471:	01 c8                	add    %ecx,%eax
  800473:	8a 40 04             	mov    0x4(%eax),%al
  800476:	3c 01                	cmp    $0x1,%al
  800478:	75 03                	jne    80047d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80047a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80047d:	ff 45 e0             	incl   -0x20(%ebp)
  800480:	a1 20 40 80 00       	mov    0x804020,%eax
  800485:	8b 50 74             	mov    0x74(%eax),%edx
  800488:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048b:	39 c2                	cmp    %eax,%edx
  80048d:	77 cb                	ja     80045a <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80048f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800492:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800495:	74 14                	je     8004ab <CheckWSWithoutLastIndex+0x16b>
		panic(
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	68 18 37 80 00       	push   $0x803718
  80049f:	6a 44                	push   $0x44
  8004a1:	68 b8 36 80 00       	push   $0x8036b8
  8004a6:	e8 23 fe ff ff       	call   8002ce <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ab:	90                   	nop
  8004ac:	c9                   	leave  
  8004ad:	c3                   	ret    

008004ae <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004ae:	55                   	push   %ebp
  8004af:	89 e5                	mov    %esp,%ebp
  8004b1:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b7:	8b 00                	mov    (%eax),%eax
  8004b9:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004bf:	89 0a                	mov    %ecx,(%edx)
  8004c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c4:	88 d1                	mov    %dl,%cl
  8004c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c9:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004d7:	75 2c                	jne    800505 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004d9:	a0 24 40 80 00       	mov    0x804024,%al
  8004de:	0f b6 c0             	movzbl %al,%eax
  8004e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e4:	8b 12                	mov    (%edx),%edx
  8004e6:	89 d1                	mov    %edx,%ecx
  8004e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004eb:	83 c2 08             	add    $0x8,%edx
  8004ee:	83 ec 04             	sub    $0x4,%esp
  8004f1:	50                   	push   %eax
  8004f2:	51                   	push   %ecx
  8004f3:	52                   	push   %edx
  8004f4:	e8 05 14 00 00       	call   8018fe <sys_cputs>
  8004f9:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004fc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800505:	8b 45 0c             	mov    0xc(%ebp),%eax
  800508:	8b 40 04             	mov    0x4(%eax),%eax
  80050b:	8d 50 01             	lea    0x1(%eax),%edx
  80050e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800511:	89 50 04             	mov    %edx,0x4(%eax)
}
  800514:	90                   	nop
  800515:	c9                   	leave  
  800516:	c3                   	ret    

00800517 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800517:	55                   	push   %ebp
  800518:	89 e5                	mov    %esp,%ebp
  80051a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800520:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800527:	00 00 00 
	b.cnt = 0;
  80052a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800531:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800534:	ff 75 0c             	pushl  0xc(%ebp)
  800537:	ff 75 08             	pushl  0x8(%ebp)
  80053a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800540:	50                   	push   %eax
  800541:	68 ae 04 80 00       	push   $0x8004ae
  800546:	e8 11 02 00 00       	call   80075c <vprintfmt>
  80054b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80054e:	a0 24 40 80 00       	mov    0x804024,%al
  800553:	0f b6 c0             	movzbl %al,%eax
  800556:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80055c:	83 ec 04             	sub    $0x4,%esp
  80055f:	50                   	push   %eax
  800560:	52                   	push   %edx
  800561:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800567:	83 c0 08             	add    $0x8,%eax
  80056a:	50                   	push   %eax
  80056b:	e8 8e 13 00 00       	call   8018fe <sys_cputs>
  800570:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800573:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80057a:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <cprintf>:

int cprintf(const char *fmt, ...) {
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800588:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80058f:	8d 45 0c             	lea    0xc(%ebp),%eax
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	83 ec 08             	sub    $0x8,%esp
  80059b:	ff 75 f4             	pushl  -0xc(%ebp)
  80059e:	50                   	push   %eax
  80059f:	e8 73 ff ff ff       	call   800517 <vcprintf>
  8005a4:	83 c4 10             	add    $0x10,%esp
  8005a7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005ad:	c9                   	leave  
  8005ae:	c3                   	ret    

008005af <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005af:	55                   	push   %ebp
  8005b0:	89 e5                	mov    %esp,%ebp
  8005b2:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b5:	e8 f2 14 00 00       	call   801aac <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005ba:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c3:	83 ec 08             	sub    $0x8,%esp
  8005c6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c9:	50                   	push   %eax
  8005ca:	e8 48 ff ff ff       	call   800517 <vcprintf>
  8005cf:	83 c4 10             	add    $0x10,%esp
  8005d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005d5:	e8 ec 14 00 00       	call   801ac6 <sys_enable_interrupt>
	return cnt;
  8005da:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005dd:	c9                   	leave  
  8005de:	c3                   	ret    

008005df <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005df:	55                   	push   %ebp
  8005e0:	89 e5                	mov    %esp,%ebp
  8005e2:	53                   	push   %ebx
  8005e3:	83 ec 14             	sub    $0x14,%esp
  8005e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ec:	8b 45 14             	mov    0x14(%ebp),%eax
  8005ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fa:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005fd:	77 55                	ja     800654 <printnum+0x75>
  8005ff:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800602:	72 05                	jb     800609 <printnum+0x2a>
  800604:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800607:	77 4b                	ja     800654 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800609:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80060c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80060f:	8b 45 18             	mov    0x18(%ebp),%eax
  800612:	ba 00 00 00 00       	mov    $0x0,%edx
  800617:	52                   	push   %edx
  800618:	50                   	push   %eax
  800619:	ff 75 f4             	pushl  -0xc(%ebp)
  80061c:	ff 75 f0             	pushl  -0x10(%ebp)
  80061f:	e8 18 2b 00 00       	call   80313c <__udivdi3>
  800624:	83 c4 10             	add    $0x10,%esp
  800627:	83 ec 04             	sub    $0x4,%esp
  80062a:	ff 75 20             	pushl  0x20(%ebp)
  80062d:	53                   	push   %ebx
  80062e:	ff 75 18             	pushl  0x18(%ebp)
  800631:	52                   	push   %edx
  800632:	50                   	push   %eax
  800633:	ff 75 0c             	pushl  0xc(%ebp)
  800636:	ff 75 08             	pushl  0x8(%ebp)
  800639:	e8 a1 ff ff ff       	call   8005df <printnum>
  80063e:	83 c4 20             	add    $0x20,%esp
  800641:	eb 1a                	jmp    80065d <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	ff 75 20             	pushl  0x20(%ebp)
  80064c:	8b 45 08             	mov    0x8(%ebp),%eax
  80064f:	ff d0                	call   *%eax
  800651:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800654:	ff 4d 1c             	decl   0x1c(%ebp)
  800657:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80065b:	7f e6                	jg     800643 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80065d:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800660:	bb 00 00 00 00       	mov    $0x0,%ebx
  800665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800668:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80066b:	53                   	push   %ebx
  80066c:	51                   	push   %ecx
  80066d:	52                   	push   %edx
  80066e:	50                   	push   %eax
  80066f:	e8 d8 2b 00 00       	call   80324c <__umoddi3>
  800674:	83 c4 10             	add    $0x10,%esp
  800677:	05 94 39 80 00       	add    $0x803994,%eax
  80067c:	8a 00                	mov    (%eax),%al
  80067e:	0f be c0             	movsbl %al,%eax
  800681:	83 ec 08             	sub    $0x8,%esp
  800684:	ff 75 0c             	pushl  0xc(%ebp)
  800687:	50                   	push   %eax
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	ff d0                	call   *%eax
  80068d:	83 c4 10             	add    $0x10,%esp
}
  800690:	90                   	nop
  800691:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800694:	c9                   	leave  
  800695:	c3                   	ret    

00800696 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800696:	55                   	push   %ebp
  800697:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800699:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80069d:	7e 1c                	jle    8006bb <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80069f:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a2:	8b 00                	mov    (%eax),%eax
  8006a4:	8d 50 08             	lea    0x8(%eax),%edx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	89 10                	mov    %edx,(%eax)
  8006ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8006af:	8b 00                	mov    (%eax),%eax
  8006b1:	83 e8 08             	sub    $0x8,%eax
  8006b4:	8b 50 04             	mov    0x4(%eax),%edx
  8006b7:	8b 00                	mov    (%eax),%eax
  8006b9:	eb 40                	jmp    8006fb <getuint+0x65>
	else if (lflag)
  8006bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006bf:	74 1e                	je     8006df <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c4:	8b 00                	mov    (%eax),%eax
  8006c6:	8d 50 04             	lea    0x4(%eax),%edx
  8006c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cc:	89 10                	mov    %edx,(%eax)
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	83 e8 04             	sub    $0x4,%eax
  8006d6:	8b 00                	mov    (%eax),%eax
  8006d8:	ba 00 00 00 00       	mov    $0x0,%edx
  8006dd:	eb 1c                	jmp    8006fb <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006df:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e2:	8b 00                	mov    (%eax),%eax
  8006e4:	8d 50 04             	lea    0x4(%eax),%edx
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	89 10                	mov    %edx,(%eax)
  8006ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ef:	8b 00                	mov    (%eax),%eax
  8006f1:	83 e8 04             	sub    $0x4,%eax
  8006f4:	8b 00                	mov    (%eax),%eax
  8006f6:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fb:	5d                   	pop    %ebp
  8006fc:	c3                   	ret    

008006fd <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800700:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800704:	7e 1c                	jle    800722 <getint+0x25>
		return va_arg(*ap, long long);
  800706:	8b 45 08             	mov    0x8(%ebp),%eax
  800709:	8b 00                	mov    (%eax),%eax
  80070b:	8d 50 08             	lea    0x8(%eax),%edx
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	89 10                	mov    %edx,(%eax)
  800713:	8b 45 08             	mov    0x8(%ebp),%eax
  800716:	8b 00                	mov    (%eax),%eax
  800718:	83 e8 08             	sub    $0x8,%eax
  80071b:	8b 50 04             	mov    0x4(%eax),%edx
  80071e:	8b 00                	mov    (%eax),%eax
  800720:	eb 38                	jmp    80075a <getint+0x5d>
	else if (lflag)
  800722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800726:	74 1a                	je     800742 <getint+0x45>
		return va_arg(*ap, long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	99                   	cltd   
  800740:	eb 18                	jmp    80075a <getint+0x5d>
	else
		return va_arg(*ap, int);
  800742:	8b 45 08             	mov    0x8(%ebp),%eax
  800745:	8b 00                	mov    (%eax),%eax
  800747:	8d 50 04             	lea    0x4(%eax),%edx
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	89 10                	mov    %edx,(%eax)
  80074f:	8b 45 08             	mov    0x8(%ebp),%eax
  800752:	8b 00                	mov    (%eax),%eax
  800754:	83 e8 04             	sub    $0x4,%eax
  800757:	8b 00                	mov    (%eax),%eax
  800759:	99                   	cltd   
}
  80075a:	5d                   	pop    %ebp
  80075b:	c3                   	ret    

0080075c <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075c:	55                   	push   %ebp
  80075d:	89 e5                	mov    %esp,%ebp
  80075f:	56                   	push   %esi
  800760:	53                   	push   %ebx
  800761:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800764:	eb 17                	jmp    80077d <vprintfmt+0x21>
			if (ch == '\0')
  800766:	85 db                	test   %ebx,%ebx
  800768:	0f 84 af 03 00 00    	je     800b1d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80076e:	83 ec 08             	sub    $0x8,%esp
  800771:	ff 75 0c             	pushl  0xc(%ebp)
  800774:	53                   	push   %ebx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	ff d0                	call   *%eax
  80077a:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077d:	8b 45 10             	mov    0x10(%ebp),%eax
  800780:	8d 50 01             	lea    0x1(%eax),%edx
  800783:	89 55 10             	mov    %edx,0x10(%ebp)
  800786:	8a 00                	mov    (%eax),%al
  800788:	0f b6 d8             	movzbl %al,%ebx
  80078b:	83 fb 25             	cmp    $0x25,%ebx
  80078e:	75 d6                	jne    800766 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800790:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800794:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80079b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007a9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b3:	8d 50 01             	lea    0x1(%eax),%edx
  8007b6:	89 55 10             	mov    %edx,0x10(%ebp)
  8007b9:	8a 00                	mov    (%eax),%al
  8007bb:	0f b6 d8             	movzbl %al,%ebx
  8007be:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c1:	83 f8 55             	cmp    $0x55,%eax
  8007c4:	0f 87 2b 03 00 00    	ja     800af5 <vprintfmt+0x399>
  8007ca:	8b 04 85 b8 39 80 00 	mov    0x8039b8(,%eax,4),%eax
  8007d1:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d3:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007d7:	eb d7                	jmp    8007b0 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007d9:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007dd:	eb d1                	jmp    8007b0 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007df:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007e9:	89 d0                	mov    %edx,%eax
  8007eb:	c1 e0 02             	shl    $0x2,%eax
  8007ee:	01 d0                	add    %edx,%eax
  8007f0:	01 c0                	add    %eax,%eax
  8007f2:	01 d8                	add    %ebx,%eax
  8007f4:	83 e8 30             	sub    $0x30,%eax
  8007f7:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8007fd:	8a 00                	mov    (%eax),%al
  8007ff:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800802:	83 fb 2f             	cmp    $0x2f,%ebx
  800805:	7e 3e                	jle    800845 <vprintfmt+0xe9>
  800807:	83 fb 39             	cmp    $0x39,%ebx
  80080a:	7f 39                	jg     800845 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80080f:	eb d5                	jmp    8007e6 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800811:	8b 45 14             	mov    0x14(%ebp),%eax
  800814:	83 c0 04             	add    $0x4,%eax
  800817:	89 45 14             	mov    %eax,0x14(%ebp)
  80081a:	8b 45 14             	mov    0x14(%ebp),%eax
  80081d:	83 e8 04             	sub    $0x4,%eax
  800820:	8b 00                	mov    (%eax),%eax
  800822:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800825:	eb 1f                	jmp    800846 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800827:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082b:	79 83                	jns    8007b0 <vprintfmt+0x54>
				width = 0;
  80082d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800834:	e9 77 ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800839:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800840:	e9 6b ff ff ff       	jmp    8007b0 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800845:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800846:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084a:	0f 89 60 ff ff ff    	jns    8007b0 <vprintfmt+0x54>
				width = precision, precision = -1;
  800850:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800853:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800856:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80085d:	e9 4e ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800862:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800865:	e9 46 ff ff ff       	jmp    8007b0 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086a:	8b 45 14             	mov    0x14(%ebp),%eax
  80086d:	83 c0 04             	add    $0x4,%eax
  800870:	89 45 14             	mov    %eax,0x14(%ebp)
  800873:	8b 45 14             	mov    0x14(%ebp),%eax
  800876:	83 e8 04             	sub    $0x4,%eax
  800879:	8b 00                	mov    (%eax),%eax
  80087b:	83 ec 08             	sub    $0x8,%esp
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	50                   	push   %eax
  800882:	8b 45 08             	mov    0x8(%ebp),%eax
  800885:	ff d0                	call   *%eax
  800887:	83 c4 10             	add    $0x10,%esp
			break;
  80088a:	e9 89 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80088f:	8b 45 14             	mov    0x14(%ebp),%eax
  800892:	83 c0 04             	add    $0x4,%eax
  800895:	89 45 14             	mov    %eax,0x14(%ebp)
  800898:	8b 45 14             	mov    0x14(%ebp),%eax
  80089b:	83 e8 04             	sub    $0x4,%eax
  80089e:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a0:	85 db                	test   %ebx,%ebx
  8008a2:	79 02                	jns    8008a6 <vprintfmt+0x14a>
				err = -err;
  8008a4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a6:	83 fb 64             	cmp    $0x64,%ebx
  8008a9:	7f 0b                	jg     8008b6 <vprintfmt+0x15a>
  8008ab:	8b 34 9d 00 38 80 00 	mov    0x803800(,%ebx,4),%esi
  8008b2:	85 f6                	test   %esi,%esi
  8008b4:	75 19                	jne    8008cf <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b6:	53                   	push   %ebx
  8008b7:	68 a5 39 80 00       	push   $0x8039a5
  8008bc:	ff 75 0c             	pushl  0xc(%ebp)
  8008bf:	ff 75 08             	pushl  0x8(%ebp)
  8008c2:	e8 5e 02 00 00       	call   800b25 <printfmt>
  8008c7:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008ca:	e9 49 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008cf:	56                   	push   %esi
  8008d0:	68 ae 39 80 00       	push   $0x8039ae
  8008d5:	ff 75 0c             	pushl  0xc(%ebp)
  8008d8:	ff 75 08             	pushl  0x8(%ebp)
  8008db:	e8 45 02 00 00       	call   800b25 <printfmt>
  8008e0:	83 c4 10             	add    $0x10,%esp
			break;
  8008e3:	e9 30 02 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8008eb:	83 c0 04             	add    $0x4,%eax
  8008ee:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f4:	83 e8 04             	sub    $0x4,%eax
  8008f7:	8b 30                	mov    (%eax),%esi
  8008f9:	85 f6                	test   %esi,%esi
  8008fb:	75 05                	jne    800902 <vprintfmt+0x1a6>
				p = "(null)";
  8008fd:	be b1 39 80 00       	mov    $0x8039b1,%esi
			if (width > 0 && padc != '-')
  800902:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800906:	7e 6d                	jle    800975 <vprintfmt+0x219>
  800908:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80090c:	74 67                	je     800975 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80090e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800911:	83 ec 08             	sub    $0x8,%esp
  800914:	50                   	push   %eax
  800915:	56                   	push   %esi
  800916:	e8 0c 03 00 00       	call   800c27 <strnlen>
  80091b:	83 c4 10             	add    $0x10,%esp
  80091e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800921:	eb 16                	jmp    800939 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800923:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800927:	83 ec 08             	sub    $0x8,%esp
  80092a:	ff 75 0c             	pushl  0xc(%ebp)
  80092d:	50                   	push   %eax
  80092e:	8b 45 08             	mov    0x8(%ebp),%eax
  800931:	ff d0                	call   *%eax
  800933:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800936:	ff 4d e4             	decl   -0x1c(%ebp)
  800939:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80093d:	7f e4                	jg     800923 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80093f:	eb 34                	jmp    800975 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800941:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800945:	74 1c                	je     800963 <vprintfmt+0x207>
  800947:	83 fb 1f             	cmp    $0x1f,%ebx
  80094a:	7e 05                	jle    800951 <vprintfmt+0x1f5>
  80094c:	83 fb 7e             	cmp    $0x7e,%ebx
  80094f:	7e 12                	jle    800963 <vprintfmt+0x207>
					putch('?', putdat);
  800951:	83 ec 08             	sub    $0x8,%esp
  800954:	ff 75 0c             	pushl  0xc(%ebp)
  800957:	6a 3f                	push   $0x3f
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
  800961:	eb 0f                	jmp    800972 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800963:	83 ec 08             	sub    $0x8,%esp
  800966:	ff 75 0c             	pushl  0xc(%ebp)
  800969:	53                   	push   %ebx
  80096a:	8b 45 08             	mov    0x8(%ebp),%eax
  80096d:	ff d0                	call   *%eax
  80096f:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800972:	ff 4d e4             	decl   -0x1c(%ebp)
  800975:	89 f0                	mov    %esi,%eax
  800977:	8d 70 01             	lea    0x1(%eax),%esi
  80097a:	8a 00                	mov    (%eax),%al
  80097c:	0f be d8             	movsbl %al,%ebx
  80097f:	85 db                	test   %ebx,%ebx
  800981:	74 24                	je     8009a7 <vprintfmt+0x24b>
  800983:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800987:	78 b8                	js     800941 <vprintfmt+0x1e5>
  800989:	ff 4d e0             	decl   -0x20(%ebp)
  80098c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800990:	79 af                	jns    800941 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800992:	eb 13                	jmp    8009a7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800994:	83 ec 08             	sub    $0x8,%esp
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	6a 20                	push   $0x20
  80099c:	8b 45 08             	mov    0x8(%ebp),%eax
  80099f:	ff d0                	call   *%eax
  8009a1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a4:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ab:	7f e7                	jg     800994 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009ad:	e9 66 01 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b2:	83 ec 08             	sub    $0x8,%esp
  8009b5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009bb:	50                   	push   %eax
  8009bc:	e8 3c fd ff ff       	call   8006fd <getint>
  8009c1:	83 c4 10             	add    $0x10,%esp
  8009c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d0:	85 d2                	test   %edx,%edx
  8009d2:	79 23                	jns    8009f7 <vprintfmt+0x29b>
				putch('-', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 2d                	push   $0x2d
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ea:	f7 d8                	neg    %eax
  8009ec:	83 d2 00             	adc    $0x0,%edx
  8009ef:	f7 da                	neg    %edx
  8009f1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009f7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009fe:	e9 bc 00 00 00       	jmp    800abf <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a03:	83 ec 08             	sub    $0x8,%esp
  800a06:	ff 75 e8             	pushl  -0x18(%ebp)
  800a09:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0c:	50                   	push   %eax
  800a0d:	e8 84 fc ff ff       	call   800696 <getuint>
  800a12:	83 c4 10             	add    $0x10,%esp
  800a15:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a18:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a1b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a22:	e9 98 00 00 00       	jmp    800abf <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a27:	83 ec 08             	sub    $0x8,%esp
  800a2a:	ff 75 0c             	pushl  0xc(%ebp)
  800a2d:	6a 58                	push   $0x58
  800a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a32:	ff d0                	call   *%eax
  800a34:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a37:	83 ec 08             	sub    $0x8,%esp
  800a3a:	ff 75 0c             	pushl  0xc(%ebp)
  800a3d:	6a 58                	push   $0x58
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	ff d0                	call   *%eax
  800a44:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a47:	83 ec 08             	sub    $0x8,%esp
  800a4a:	ff 75 0c             	pushl  0xc(%ebp)
  800a4d:	6a 58                	push   $0x58
  800a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a52:	ff d0                	call   *%eax
  800a54:	83 c4 10             	add    $0x10,%esp
			break;
  800a57:	e9 bc 00 00 00       	jmp    800b18 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a5c:	83 ec 08             	sub    $0x8,%esp
  800a5f:	ff 75 0c             	pushl  0xc(%ebp)
  800a62:	6a 30                	push   $0x30
  800a64:	8b 45 08             	mov    0x8(%ebp),%eax
  800a67:	ff d0                	call   *%eax
  800a69:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	6a 78                	push   $0x78
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	ff d0                	call   *%eax
  800a79:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a7c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a7f:	83 c0 04             	add    $0x4,%eax
  800a82:	89 45 14             	mov    %eax,0x14(%ebp)
  800a85:	8b 45 14             	mov    0x14(%ebp),%eax
  800a88:	83 e8 04             	sub    $0x4,%eax
  800a8b:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a90:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a97:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a9e:	eb 1f                	jmp    800abf <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa0:	83 ec 08             	sub    $0x8,%esp
  800aa3:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa6:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa9:	50                   	push   %eax
  800aaa:	e8 e7 fb ff ff       	call   800696 <getuint>
  800aaf:	83 c4 10             	add    $0x10,%esp
  800ab2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ab8:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800abf:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac6:	83 ec 04             	sub    $0x4,%esp
  800ac9:	52                   	push   %edx
  800aca:	ff 75 e4             	pushl  -0x1c(%ebp)
  800acd:	50                   	push   %eax
  800ace:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad1:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	ff 75 08             	pushl  0x8(%ebp)
  800ada:	e8 00 fb ff ff       	call   8005df <printnum>
  800adf:	83 c4 20             	add    $0x20,%esp
			break;
  800ae2:	eb 34                	jmp    800b18 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	53                   	push   %ebx
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			break;
  800af3:	eb 23                	jmp    800b18 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af5:	83 ec 08             	sub    $0x8,%esp
  800af8:	ff 75 0c             	pushl  0xc(%ebp)
  800afb:	6a 25                	push   $0x25
  800afd:	8b 45 08             	mov    0x8(%ebp),%eax
  800b00:	ff d0                	call   *%eax
  800b02:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b05:	ff 4d 10             	decl   0x10(%ebp)
  800b08:	eb 03                	jmp    800b0d <vprintfmt+0x3b1>
  800b0a:	ff 4d 10             	decl   0x10(%ebp)
  800b0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800b10:	48                   	dec    %eax
  800b11:	8a 00                	mov    (%eax),%al
  800b13:	3c 25                	cmp    $0x25,%al
  800b15:	75 f3                	jne    800b0a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b17:	90                   	nop
		}
	}
  800b18:	e9 47 fc ff ff       	jmp    800764 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b1d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b1e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b21:	5b                   	pop    %ebx
  800b22:	5e                   	pop    %esi
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b2b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b2e:	83 c0 04             	add    $0x4,%eax
  800b31:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b34:	8b 45 10             	mov    0x10(%ebp),%eax
  800b37:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3a:	50                   	push   %eax
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 16 fc ff ff       	call   80075c <vprintfmt>
  800b46:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b49:	90                   	nop
  800b4a:	c9                   	leave  
  800b4b:	c3                   	ret    

00800b4c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b4c:	55                   	push   %ebp
  800b4d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b52:	8b 40 08             	mov    0x8(%eax),%eax
  800b55:	8d 50 01             	lea    0x1(%eax),%edx
  800b58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5b:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b61:	8b 10                	mov    (%eax),%edx
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8b 40 04             	mov    0x4(%eax),%eax
  800b69:	39 c2                	cmp    %eax,%edx
  800b6b:	73 12                	jae    800b7f <sprintputch+0x33>
		*b->buf++ = ch;
  800b6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b70:	8b 00                	mov    (%eax),%eax
  800b72:	8d 48 01             	lea    0x1(%eax),%ecx
  800b75:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b78:	89 0a                	mov    %ecx,(%edx)
  800b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  800b7d:	88 10                	mov    %dl,(%eax)
}
  800b7f:	90                   	nop
  800b80:	5d                   	pop    %ebp
  800b81:	c3                   	ret    

00800b82 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b91:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b94:	8b 45 08             	mov    0x8(%ebp),%eax
  800b97:	01 d0                	add    %edx,%eax
  800b99:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ba7:	74 06                	je     800baf <vsnprintf+0x2d>
  800ba9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bad:	7f 07                	jg     800bb6 <vsnprintf+0x34>
		return -E_INVAL;
  800baf:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb4:	eb 20                	jmp    800bd6 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb6:	ff 75 14             	pushl  0x14(%ebp)
  800bb9:	ff 75 10             	pushl  0x10(%ebp)
  800bbc:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bbf:	50                   	push   %eax
  800bc0:	68 4c 0b 80 00       	push   $0x800b4c
  800bc5:	e8 92 fb ff ff       	call   80075c <vprintfmt>
  800bca:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd0:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd6:	c9                   	leave  
  800bd7:	c3                   	ret    

00800bd8 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bd8:	55                   	push   %ebp
  800bd9:	89 e5                	mov    %esp,%ebp
  800bdb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bde:	8d 45 10             	lea    0x10(%ebp),%eax
  800be1:	83 c0 04             	add    $0x4,%eax
  800be4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800be7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bea:	ff 75 f4             	pushl  -0xc(%ebp)
  800bed:	50                   	push   %eax
  800bee:	ff 75 0c             	pushl  0xc(%ebp)
  800bf1:	ff 75 08             	pushl  0x8(%ebp)
  800bf4:	e8 89 ff ff ff       	call   800b82 <vsnprintf>
  800bf9:	83 c4 10             	add    $0x10,%esp
  800bfc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bff:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c02:	c9                   	leave  
  800c03:	c3                   	ret    

00800c04 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c04:	55                   	push   %ebp
  800c05:	89 e5                	mov    %esp,%ebp
  800c07:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c11:	eb 06                	jmp    800c19 <strlen+0x15>
		n++;
  800c13:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c16:	ff 45 08             	incl   0x8(%ebp)
  800c19:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1c:	8a 00                	mov    (%eax),%al
  800c1e:	84 c0                	test   %al,%al
  800c20:	75 f1                	jne    800c13 <strlen+0xf>
		n++;
	return n;
  800c22:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c25:	c9                   	leave  
  800c26:	c3                   	ret    

00800c27 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c27:	55                   	push   %ebp
  800c28:	89 e5                	mov    %esp,%ebp
  800c2a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c2d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c34:	eb 09                	jmp    800c3f <strnlen+0x18>
		n++;
  800c36:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c39:	ff 45 08             	incl   0x8(%ebp)
  800c3c:	ff 4d 0c             	decl   0xc(%ebp)
  800c3f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c43:	74 09                	je     800c4e <strnlen+0x27>
  800c45:	8b 45 08             	mov    0x8(%ebp),%eax
  800c48:	8a 00                	mov    (%eax),%al
  800c4a:	84 c0                	test   %al,%al
  800c4c:	75 e8                	jne    800c36 <strnlen+0xf>
		n++;
	return n;
  800c4e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c51:	c9                   	leave  
  800c52:	c3                   	ret    

00800c53 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c53:	55                   	push   %ebp
  800c54:	89 e5                	mov    %esp,%ebp
  800c56:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c5f:	90                   	nop
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8d 50 01             	lea    0x1(%eax),%edx
  800c66:	89 55 08             	mov    %edx,0x8(%ebp)
  800c69:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c6f:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c72:	8a 12                	mov    (%edx),%dl
  800c74:	88 10                	mov    %dl,(%eax)
  800c76:	8a 00                	mov    (%eax),%al
  800c78:	84 c0                	test   %al,%al
  800c7a:	75 e4                	jne    800c60 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c7c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7f:	c9                   	leave  
  800c80:	c3                   	ret    

00800c81 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c81:	55                   	push   %ebp
  800c82:	89 e5                	mov    %esp,%ebp
  800c84:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c87:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c8d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c94:	eb 1f                	jmp    800cb5 <strncpy+0x34>
		*dst++ = *src;
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
  800c99:	8d 50 01             	lea    0x1(%eax),%edx
  800c9c:	89 55 08             	mov    %edx,0x8(%ebp)
  800c9f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca2:	8a 12                	mov    (%edx),%dl
  800ca4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca9:	8a 00                	mov    (%eax),%al
  800cab:	84 c0                	test   %al,%al
  800cad:	74 03                	je     800cb2 <strncpy+0x31>
			src++;
  800caf:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb2:	ff 45 fc             	incl   -0x4(%ebp)
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cbb:	72 d9                	jb     800c96 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc0:	c9                   	leave  
  800cc1:	c3                   	ret    

00800cc2 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc2:	55                   	push   %ebp
  800cc3:	89 e5                	mov    %esp,%ebp
  800cc5:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ccb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd2:	74 30                	je     800d04 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd4:	eb 16                	jmp    800cec <strlcpy+0x2a>
			*dst++ = *src++;
  800cd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd9:	8d 50 01             	lea    0x1(%eax),%edx
  800cdc:	89 55 08             	mov    %edx,0x8(%ebp)
  800cdf:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce2:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce5:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ce8:	8a 12                	mov    (%edx),%dl
  800cea:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cec:	ff 4d 10             	decl   0x10(%ebp)
  800cef:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf3:	74 09                	je     800cfe <strlcpy+0x3c>
  800cf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	84 c0                	test   %al,%al
  800cfc:	75 d8                	jne    800cd6 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d04:	8b 55 08             	mov    0x8(%ebp),%edx
  800d07:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0a:	29 c2                	sub    %eax,%edx
  800d0c:	89 d0                	mov    %edx,%eax
}
  800d0e:	c9                   	leave  
  800d0f:	c3                   	ret    

00800d10 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d10:	55                   	push   %ebp
  800d11:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d13:	eb 06                	jmp    800d1b <strcmp+0xb>
		p++, q++;
  800d15:	ff 45 08             	incl   0x8(%ebp)
  800d18:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	8a 00                	mov    (%eax),%al
  800d20:	84 c0                	test   %al,%al
  800d22:	74 0e                	je     800d32 <strcmp+0x22>
  800d24:	8b 45 08             	mov    0x8(%ebp),%eax
  800d27:	8a 10                	mov    (%eax),%dl
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	38 c2                	cmp    %al,%dl
  800d30:	74 e3                	je     800d15 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8a 00                	mov    (%eax),%al
  800d37:	0f b6 d0             	movzbl %al,%edx
  800d3a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3d:	8a 00                	mov    (%eax),%al
  800d3f:	0f b6 c0             	movzbl %al,%eax
  800d42:	29 c2                	sub    %eax,%edx
  800d44:	89 d0                	mov    %edx,%eax
}
  800d46:	5d                   	pop    %ebp
  800d47:	c3                   	ret    

00800d48 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d48:	55                   	push   %ebp
  800d49:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d4b:	eb 09                	jmp    800d56 <strncmp+0xe>
		n--, p++, q++;
  800d4d:	ff 4d 10             	decl   0x10(%ebp)
  800d50:	ff 45 08             	incl   0x8(%ebp)
  800d53:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	74 17                	je     800d73 <strncmp+0x2b>
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	74 0e                	je     800d73 <strncmp+0x2b>
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8a 10                	mov    (%eax),%dl
  800d6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6d:	8a 00                	mov    (%eax),%al
  800d6f:	38 c2                	cmp    %al,%dl
  800d71:	74 da                	je     800d4d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d73:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d77:	75 07                	jne    800d80 <strncmp+0x38>
		return 0;
  800d79:	b8 00 00 00 00       	mov    $0x0,%eax
  800d7e:	eb 14                	jmp    800d94 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	0f b6 d0             	movzbl %al,%edx
  800d88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	0f b6 c0             	movzbl %al,%eax
  800d90:	29 c2                	sub    %eax,%edx
  800d92:	89 d0                	mov    %edx,%eax
}
  800d94:	5d                   	pop    %ebp
  800d95:	c3                   	ret    

00800d96 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d96:	55                   	push   %ebp
  800d97:	89 e5                	mov    %esp,%ebp
  800d99:	83 ec 04             	sub    $0x4,%esp
  800d9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d9f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da2:	eb 12                	jmp    800db6 <strchr+0x20>
		if (*s == c)
  800da4:	8b 45 08             	mov    0x8(%ebp),%eax
  800da7:	8a 00                	mov    (%eax),%al
  800da9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dac:	75 05                	jne    800db3 <strchr+0x1d>
			return (char *) s;
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	eb 11                	jmp    800dc4 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db3:	ff 45 08             	incl   0x8(%ebp)
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	84 c0                	test   %al,%al
  800dbd:	75 e5                	jne    800da4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc4:	c9                   	leave  
  800dc5:	c3                   	ret    

00800dc6 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc6:	55                   	push   %ebp
  800dc7:	89 e5                	mov    %esp,%ebp
  800dc9:	83 ec 04             	sub    $0x4,%esp
  800dcc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dcf:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd2:	eb 0d                	jmp    800de1 <strfind+0x1b>
		if (*s == c)
  800dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddc:	74 0e                	je     800dec <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dde:	ff 45 08             	incl   0x8(%ebp)
  800de1:	8b 45 08             	mov    0x8(%ebp),%eax
  800de4:	8a 00                	mov    (%eax),%al
  800de6:	84 c0                	test   %al,%al
  800de8:	75 ea                	jne    800dd4 <strfind+0xe>
  800dea:	eb 01                	jmp    800ded <strfind+0x27>
		if (*s == c)
			break;
  800dec:	90                   	nop
	return (char *) s;
  800ded:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dfe:	8b 45 10             	mov    0x10(%ebp),%eax
  800e01:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e04:	eb 0e                	jmp    800e14 <memset+0x22>
		*p++ = c;
  800e06:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e09:	8d 50 01             	lea    0x1(%eax),%edx
  800e0c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e0f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e12:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e14:	ff 4d f8             	decl   -0x8(%ebp)
  800e17:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e1b:	79 e9                	jns    800e06 <memset+0x14>
		*p++ = c;

	return v;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e20:	c9                   	leave  
  800e21:	c3                   	ret    

00800e22 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e22:	55                   	push   %ebp
  800e23:	89 e5                	mov    %esp,%ebp
  800e25:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e34:	eb 16                	jmp    800e4c <memcpy+0x2a>
		*d++ = *s++;
  800e36:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e39:	8d 50 01             	lea    0x1(%eax),%edx
  800e3c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e3f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e42:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e45:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e48:	8a 12                	mov    (%edx),%dl
  800e4a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 dd                	jne    800e36 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5c:	c9                   	leave  
  800e5d:	c3                   	ret    

00800e5e <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e5e:	55                   	push   %ebp
  800e5f:	89 e5                	mov    %esp,%ebp
  800e61:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e70:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e73:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e76:	73 50                	jae    800ec8 <memmove+0x6a>
  800e78:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7e:	01 d0                	add    %edx,%eax
  800e80:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e83:	76 43                	jbe    800ec8 <memmove+0x6a>
		s += n;
  800e85:	8b 45 10             	mov    0x10(%ebp),%eax
  800e88:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e91:	eb 10                	jmp    800ea3 <memmove+0x45>
			*--d = *--s;
  800e93:	ff 4d f8             	decl   -0x8(%ebp)
  800e96:	ff 4d fc             	decl   -0x4(%ebp)
  800e99:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9c:	8a 10                	mov    (%eax),%dl
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ea3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ea9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eac:	85 c0                	test   %eax,%eax
  800eae:	75 e3                	jne    800e93 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb0:	eb 23                	jmp    800ed5 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb5:	8d 50 01             	lea    0x1(%eax),%edx
  800eb8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ebe:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ec4:	8a 12                	mov    (%edx),%dl
  800ec6:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ece:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed1:	85 c0                	test   %eax,%eax
  800ed3:	75 dd                	jne    800eb2 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ed5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ed8:	c9                   	leave  
  800ed9:	c3                   	ret    

00800eda <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800eda:	55                   	push   %ebp
  800edb:	89 e5                	mov    %esp,%ebp
  800edd:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee9:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eec:	eb 2a                	jmp    800f18 <memcmp+0x3e>
		if (*s1 != *s2)
  800eee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef1:	8a 10                	mov    (%eax),%dl
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	38 c2                	cmp    %al,%dl
  800efa:	74 16                	je     800f12 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800efc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	0f b6 d0             	movzbl %al,%edx
  800f04:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f07:	8a 00                	mov    (%eax),%al
  800f09:	0f b6 c0             	movzbl %al,%eax
  800f0c:	29 c2                	sub    %eax,%edx
  800f0e:	89 d0                	mov    %edx,%eax
  800f10:	eb 18                	jmp    800f2a <memcmp+0x50>
		s1++, s2++;
  800f12:	ff 45 fc             	incl   -0x4(%ebp)
  800f15:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f18:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1b:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f1e:	89 55 10             	mov    %edx,0x10(%ebp)
  800f21:	85 c0                	test   %eax,%eax
  800f23:	75 c9                	jne    800eee <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2a:	c9                   	leave  
  800f2b:	c3                   	ret    

00800f2c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f2c:	55                   	push   %ebp
  800f2d:	89 e5                	mov    %esp,%ebp
  800f2f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f32:	8b 55 08             	mov    0x8(%ebp),%edx
  800f35:	8b 45 10             	mov    0x10(%ebp),%eax
  800f38:	01 d0                	add    %edx,%eax
  800f3a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f3d:	eb 15                	jmp    800f54 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	0f b6 d0             	movzbl %al,%edx
  800f47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4a:	0f b6 c0             	movzbl %al,%eax
  800f4d:	39 c2                	cmp    %eax,%edx
  800f4f:	74 0d                	je     800f5e <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f51:	ff 45 08             	incl   0x8(%ebp)
  800f54:	8b 45 08             	mov    0x8(%ebp),%eax
  800f57:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f5a:	72 e3                	jb     800f3f <memfind+0x13>
  800f5c:	eb 01                	jmp    800f5f <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f5e:	90                   	nop
	return (void *) s;
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f62:	c9                   	leave  
  800f63:	c3                   	ret    

00800f64 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f64:	55                   	push   %ebp
  800f65:	89 e5                	mov    %esp,%ebp
  800f67:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f6a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f71:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f78:	eb 03                	jmp    800f7d <strtol+0x19>
		s++;
  800f7a:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f80:	8a 00                	mov    (%eax),%al
  800f82:	3c 20                	cmp    $0x20,%al
  800f84:	74 f4                	je     800f7a <strtol+0x16>
  800f86:	8b 45 08             	mov    0x8(%ebp),%eax
  800f89:	8a 00                	mov    (%eax),%al
  800f8b:	3c 09                	cmp    $0x9,%al
  800f8d:	74 eb                	je     800f7a <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	3c 2b                	cmp    $0x2b,%al
  800f96:	75 05                	jne    800f9d <strtol+0x39>
		s++;
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	eb 13                	jmp    800fb0 <strtol+0x4c>
	else if (*s == '-')
  800f9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa0:	8a 00                	mov    (%eax),%al
  800fa2:	3c 2d                	cmp    $0x2d,%al
  800fa4:	75 0a                	jne    800fb0 <strtol+0x4c>
		s++, neg = 1;
  800fa6:	ff 45 08             	incl   0x8(%ebp)
  800fa9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb4:	74 06                	je     800fbc <strtol+0x58>
  800fb6:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fba:	75 20                	jne    800fdc <strtol+0x78>
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 30                	cmp    $0x30,%al
  800fc3:	75 17                	jne    800fdc <strtol+0x78>
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	40                   	inc    %eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 78                	cmp    $0x78,%al
  800fcd:	75 0d                	jne    800fdc <strtol+0x78>
		s += 2, base = 16;
  800fcf:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fd3:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fda:	eb 28                	jmp    801004 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fdc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe0:	75 15                	jne    800ff7 <strtol+0x93>
  800fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe5:	8a 00                	mov    (%eax),%al
  800fe7:	3c 30                	cmp    $0x30,%al
  800fe9:	75 0c                	jne    800ff7 <strtol+0x93>
		s++, base = 8;
  800feb:	ff 45 08             	incl   0x8(%ebp)
  800fee:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ff5:	eb 0d                	jmp    801004 <strtol+0xa0>
	else if (base == 0)
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	75 07                	jne    801004 <strtol+0xa0>
		base = 10;
  800ffd:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 2f                	cmp    $0x2f,%al
  80100b:	7e 19                	jle    801026 <strtol+0xc2>
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	8a 00                	mov    (%eax),%al
  801012:	3c 39                	cmp    $0x39,%al
  801014:	7f 10                	jg     801026 <strtol+0xc2>
			dig = *s - '0';
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	8a 00                	mov    (%eax),%al
  80101b:	0f be c0             	movsbl %al,%eax
  80101e:	83 e8 30             	sub    $0x30,%eax
  801021:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801024:	eb 42                	jmp    801068 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801026:	8b 45 08             	mov    0x8(%ebp),%eax
  801029:	8a 00                	mov    (%eax),%al
  80102b:	3c 60                	cmp    $0x60,%al
  80102d:	7e 19                	jle    801048 <strtol+0xe4>
  80102f:	8b 45 08             	mov    0x8(%ebp),%eax
  801032:	8a 00                	mov    (%eax),%al
  801034:	3c 7a                	cmp    $0x7a,%al
  801036:	7f 10                	jg     801048 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801038:	8b 45 08             	mov    0x8(%ebp),%eax
  80103b:	8a 00                	mov    (%eax),%al
  80103d:	0f be c0             	movsbl %al,%eax
  801040:	83 e8 57             	sub    $0x57,%eax
  801043:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801046:	eb 20                	jmp    801068 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 40                	cmp    $0x40,%al
  80104f:	7e 39                	jle    80108a <strtol+0x126>
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 5a                	cmp    $0x5a,%al
  801058:	7f 30                	jg     80108a <strtol+0x126>
			dig = *s - 'A' + 10;
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	0f be c0             	movsbl %al,%eax
  801062:	83 e8 37             	sub    $0x37,%eax
  801065:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106b:	3b 45 10             	cmp    0x10(%ebp),%eax
  80106e:	7d 19                	jge    801089 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801070:	ff 45 08             	incl   0x8(%ebp)
  801073:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801076:	0f af 45 10          	imul   0x10(%ebp),%eax
  80107a:	89 c2                	mov    %eax,%edx
  80107c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80107f:	01 d0                	add    %edx,%eax
  801081:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801084:	e9 7b ff ff ff       	jmp    801004 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801089:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80108a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80108e:	74 08                	je     801098 <strtol+0x134>
		*endptr = (char *) s;
  801090:	8b 45 0c             	mov    0xc(%ebp),%eax
  801093:	8b 55 08             	mov    0x8(%ebp),%edx
  801096:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801098:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109c:	74 07                	je     8010a5 <strtol+0x141>
  80109e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a1:	f7 d8                	neg    %eax
  8010a3:	eb 03                	jmp    8010a8 <strtol+0x144>
  8010a5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010a8:	c9                   	leave  
  8010a9:	c3                   	ret    

008010aa <ltostr>:

void
ltostr(long value, char *str)
{
  8010aa:	55                   	push   %ebp
  8010ab:	89 e5                	mov    %esp,%ebp
  8010ad:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010b7:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010be:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c2:	79 13                	jns    8010d7 <ltostr+0x2d>
	{
		neg = 1;
  8010c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ce:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d1:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010d4:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010df:	99                   	cltd   
  8010e0:	f7 f9                	idiv   %ecx
  8010e2:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f8:	83 c2 30             	add    $0x30,%edx
  8010fb:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010fd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801100:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801105:	f7 e9                	imul   %ecx
  801107:	c1 fa 02             	sar    $0x2,%edx
  80110a:	89 c8                	mov    %ecx,%eax
  80110c:	c1 f8 1f             	sar    $0x1f,%eax
  80110f:	29 c2                	sub    %eax,%edx
  801111:	89 d0                	mov    %edx,%eax
  801113:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801116:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801119:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80111e:	f7 e9                	imul   %ecx
  801120:	c1 fa 02             	sar    $0x2,%edx
  801123:	89 c8                	mov    %ecx,%eax
  801125:	c1 f8 1f             	sar    $0x1f,%eax
  801128:	29 c2                	sub    %eax,%edx
  80112a:	89 d0                	mov    %edx,%eax
  80112c:	c1 e0 02             	shl    $0x2,%eax
  80112f:	01 d0                	add    %edx,%eax
  801131:	01 c0                	add    %eax,%eax
  801133:	29 c1                	sub    %eax,%ecx
  801135:	89 ca                	mov    %ecx,%edx
  801137:	85 d2                	test   %edx,%edx
  801139:	75 9c                	jne    8010d7 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	48                   	dec    %eax
  801146:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801149:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80114d:	74 3d                	je     80118c <ltostr+0xe2>
		start = 1 ;
  80114f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801156:	eb 34                	jmp    80118c <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801158:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115e:	01 d0                	add    %edx,%eax
  801160:	8a 00                	mov    (%eax),%al
  801162:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801165:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801168:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116b:	01 c2                	add    %eax,%edx
  80116d:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801170:	8b 45 0c             	mov    0xc(%ebp),%eax
  801173:	01 c8                	add    %ecx,%eax
  801175:	8a 00                	mov    (%eax),%al
  801177:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801179:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117f:	01 c2                	add    %eax,%edx
  801181:	8a 45 eb             	mov    -0x15(%ebp),%al
  801184:	88 02                	mov    %al,(%edx)
		start++ ;
  801186:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801189:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80118f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801192:	7c c4                	jl     801158 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801194:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 d0                	add    %edx,%eax
  80119c:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80119f:	90                   	nop
  8011a0:	c9                   	leave  
  8011a1:	c3                   	ret    

008011a2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a2:	55                   	push   %ebp
  8011a3:	89 e5                	mov    %esp,%ebp
  8011a5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011a8:	ff 75 08             	pushl  0x8(%ebp)
  8011ab:	e8 54 fa ff ff       	call   800c04 <strlen>
  8011b0:	83 c4 04             	add    $0x4,%esp
  8011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b6:	ff 75 0c             	pushl  0xc(%ebp)
  8011b9:	e8 46 fa ff ff       	call   800c04 <strlen>
  8011be:	83 c4 04             	add    $0x4,%esp
  8011c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d2:	eb 17                	jmp    8011eb <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011da:	01 c2                	add    %eax,%edx
  8011dc:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	01 c8                	add    %ecx,%eax
  8011e4:	8a 00                	mov    (%eax),%al
  8011e6:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011e8:	ff 45 fc             	incl   -0x4(%ebp)
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f1:	7c e1                	jl     8011d4 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fa:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801201:	eb 1f                	jmp    801222 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801203:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801206:	8d 50 01             	lea    0x1(%eax),%edx
  801209:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120c:	89 c2                	mov    %eax,%edx
  80120e:	8b 45 10             	mov    0x10(%ebp),%eax
  801211:	01 c2                	add    %eax,%edx
  801213:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801216:	8b 45 0c             	mov    0xc(%ebp),%eax
  801219:	01 c8                	add    %ecx,%eax
  80121b:	8a 00                	mov    (%eax),%al
  80121d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80121f:	ff 45 f8             	incl   -0x8(%ebp)
  801222:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801225:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801228:	7c d9                	jl     801203 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122d:	8b 45 10             	mov    0x10(%ebp),%eax
  801230:	01 d0                	add    %edx,%eax
  801232:	c6 00 00             	movb   $0x0,(%eax)
}
  801235:	90                   	nop
  801236:	c9                   	leave  
  801237:	c3                   	ret    

00801238 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801238:	55                   	push   %ebp
  801239:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123b:	8b 45 14             	mov    0x14(%ebp),%eax
  80123e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801244:	8b 45 14             	mov    0x14(%ebp),%eax
  801247:	8b 00                	mov    (%eax),%eax
  801249:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801250:	8b 45 10             	mov    0x10(%ebp),%eax
  801253:	01 d0                	add    %edx,%eax
  801255:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125b:	eb 0c                	jmp    801269 <strsplit+0x31>
			*string++ = 0;
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8d 50 01             	lea    0x1(%eax),%edx
  801263:	89 55 08             	mov    %edx,0x8(%ebp)
  801266:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801269:	8b 45 08             	mov    0x8(%ebp),%eax
  80126c:	8a 00                	mov    (%eax),%al
  80126e:	84 c0                	test   %al,%al
  801270:	74 18                	je     80128a <strsplit+0x52>
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	0f be c0             	movsbl %al,%eax
  80127a:	50                   	push   %eax
  80127b:	ff 75 0c             	pushl  0xc(%ebp)
  80127e:	e8 13 fb ff ff       	call   800d96 <strchr>
  801283:	83 c4 08             	add    $0x8,%esp
  801286:	85 c0                	test   %eax,%eax
  801288:	75 d3                	jne    80125d <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128a:	8b 45 08             	mov    0x8(%ebp),%eax
  80128d:	8a 00                	mov    (%eax),%al
  80128f:	84 c0                	test   %al,%al
  801291:	74 5a                	je     8012ed <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	83 f8 0f             	cmp    $0xf,%eax
  80129b:	75 07                	jne    8012a4 <strsplit+0x6c>
		{
			return 0;
  80129d:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a2:	eb 66                	jmp    80130a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a4:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a7:	8b 00                	mov    (%eax),%eax
  8012a9:	8d 48 01             	lea    0x1(%eax),%ecx
  8012ac:	8b 55 14             	mov    0x14(%ebp),%edx
  8012af:	89 0a                	mov    %ecx,(%edx)
  8012b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bb:	01 c2                	add    %eax,%edx
  8012bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c0:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c2:	eb 03                	jmp    8012c7 <strsplit+0x8f>
			string++;
  8012c4:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	8a 00                	mov    (%eax),%al
  8012cc:	84 c0                	test   %al,%al
  8012ce:	74 8b                	je     80125b <strsplit+0x23>
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	0f be c0             	movsbl %al,%eax
  8012d8:	50                   	push   %eax
  8012d9:	ff 75 0c             	pushl  0xc(%ebp)
  8012dc:	e8 b5 fa ff ff       	call   800d96 <strchr>
  8012e1:	83 c4 08             	add    $0x8,%esp
  8012e4:	85 c0                	test   %eax,%eax
  8012e6:	74 dc                	je     8012c4 <strsplit+0x8c>
			string++;
	}
  8012e8:	e9 6e ff ff ff       	jmp    80125b <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012ed:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012ee:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f1:	8b 00                	mov    (%eax),%eax
  8012f3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012fd:	01 d0                	add    %edx,%eax
  8012ff:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801305:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130a:	c9                   	leave  
  80130b:	c3                   	ret    

0080130c <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80130c:	55                   	push   %ebp
  80130d:	89 e5                	mov    %esp,%ebp
  80130f:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801312:	a1 04 40 80 00       	mov    0x804004,%eax
  801317:	85 c0                	test   %eax,%eax
  801319:	74 1f                	je     80133a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80131b:	e8 1d 00 00 00       	call   80133d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801320:	83 ec 0c             	sub    $0xc,%esp
  801323:	68 10 3b 80 00       	push   $0x803b10
  801328:	e8 55 f2 ff ff       	call   800582 <cprintf>
  80132d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801330:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801337:	00 00 00 
	}
}
  80133a:	90                   	nop
  80133b:	c9                   	leave  
  80133c:	c3                   	ret    

0080133d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80133d:	55                   	push   %ebp
  80133e:	89 e5                	mov    %esp,%ebp
  801340:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801343:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80134a:	00 00 00 
  80134d:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801354:	00 00 00 
  801357:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80135e:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801361:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801368:	00 00 00 
  80136b:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801372:	00 00 00 
  801375:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80137c:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  80137f:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801389:	c1 e8 0c             	shr    $0xc,%eax
  80138c:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801391:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801398:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013a5:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  8013aa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8013b1:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b6:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8013ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8013bd:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8013c4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013ca:	01 d0                	add    %edx,%eax
  8013cc:	48                   	dec    %eax
  8013cd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d3:	ba 00 00 00 00       	mov    $0x0,%edx
  8013d8:	f7 75 e4             	divl   -0x1c(%ebp)
  8013db:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013de:	29 d0                	sub    %edx,%eax
  8013e0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8013e3:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8013ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f2:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	6a 07                	push   $0x7
  8013fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8013ff:	50                   	push   %eax
  801400:	e8 3d 06 00 00       	call   801a42 <sys_allocate_chunk>
  801405:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801408:	a1 20 41 80 00       	mov    0x804120,%eax
  80140d:	83 ec 0c             	sub    $0xc,%esp
  801410:	50                   	push   %eax
  801411:	e8 b2 0c 00 00       	call   8020c8 <initialize_MemBlocksList>
  801416:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801419:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80141e:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801421:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801425:	0f 84 f3 00 00 00    	je     80151e <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  80142b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80142f:	75 14                	jne    801445 <initialize_dyn_block_system+0x108>
  801431:	83 ec 04             	sub    $0x4,%esp
  801434:	68 35 3b 80 00       	push   $0x803b35
  801439:	6a 36                	push   $0x36
  80143b:	68 53 3b 80 00       	push   $0x803b53
  801440:	e8 89 ee ff ff       	call   8002ce <_panic>
  801445:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801448:	8b 00                	mov    (%eax),%eax
  80144a:	85 c0                	test   %eax,%eax
  80144c:	74 10                	je     80145e <initialize_dyn_block_system+0x121>
  80144e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801451:	8b 00                	mov    (%eax),%eax
  801453:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801456:	8b 52 04             	mov    0x4(%edx),%edx
  801459:	89 50 04             	mov    %edx,0x4(%eax)
  80145c:	eb 0b                	jmp    801469 <initialize_dyn_block_system+0x12c>
  80145e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801461:	8b 40 04             	mov    0x4(%eax),%eax
  801464:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801469:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80146c:	8b 40 04             	mov    0x4(%eax),%eax
  80146f:	85 c0                	test   %eax,%eax
  801471:	74 0f                	je     801482 <initialize_dyn_block_system+0x145>
  801473:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801476:	8b 40 04             	mov    0x4(%eax),%eax
  801479:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80147c:	8b 12                	mov    (%edx),%edx
  80147e:	89 10                	mov    %edx,(%eax)
  801480:	eb 0a                	jmp    80148c <initialize_dyn_block_system+0x14f>
  801482:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801485:	8b 00                	mov    (%eax),%eax
  801487:	a3 48 41 80 00       	mov    %eax,0x804148
  80148c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80148f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801495:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801498:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80149f:	a1 54 41 80 00       	mov    0x804154,%eax
  8014a4:	48                   	dec    %eax
  8014a5:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  8014aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014ad:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8014b4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014b7:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8014be:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014c2:	75 14                	jne    8014d8 <initialize_dyn_block_system+0x19b>
  8014c4:	83 ec 04             	sub    $0x4,%esp
  8014c7:	68 60 3b 80 00       	push   $0x803b60
  8014cc:	6a 3e                	push   $0x3e
  8014ce:	68 53 3b 80 00       	push   $0x803b53
  8014d3:	e8 f6 ed ff ff       	call   8002ce <_panic>
  8014d8:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8014de:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014e1:	89 10                	mov    %edx,(%eax)
  8014e3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	85 c0                	test   %eax,%eax
  8014ea:	74 0d                	je     8014f9 <initialize_dyn_block_system+0x1bc>
  8014ec:	a1 38 41 80 00       	mov    0x804138,%eax
  8014f1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014f4:	89 50 04             	mov    %edx,0x4(%eax)
  8014f7:	eb 08                	jmp    801501 <initialize_dyn_block_system+0x1c4>
  8014f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014fc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801501:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801504:	a3 38 41 80 00       	mov    %eax,0x804138
  801509:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80150c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801513:	a1 44 41 80 00       	mov    0x804144,%eax
  801518:	40                   	inc    %eax
  801519:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  80151e:	90                   	nop
  80151f:	c9                   	leave  
  801520:	c3                   	ret    

00801521 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801521:	55                   	push   %ebp
  801522:	89 e5                	mov    %esp,%ebp
  801524:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801527:	e8 e0 fd ff ff       	call   80130c <InitializeUHeap>
		if (size == 0) return NULL ;
  80152c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801530:	75 07                	jne    801539 <malloc+0x18>
  801532:	b8 00 00 00 00       	mov    $0x0,%eax
  801537:	eb 7f                	jmp    8015b8 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801539:	e8 d2 08 00 00       	call   801e10 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80153e:	85 c0                	test   %eax,%eax
  801540:	74 71                	je     8015b3 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801542:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801549:	8b 55 08             	mov    0x8(%ebp),%edx
  80154c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80154f:	01 d0                	add    %edx,%eax
  801551:	48                   	dec    %eax
  801552:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801555:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801558:	ba 00 00 00 00       	mov    $0x0,%edx
  80155d:	f7 75 f4             	divl   -0xc(%ebp)
  801560:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801563:	29 d0                	sub    %edx,%eax
  801565:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801568:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  80156f:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801576:	76 07                	jbe    80157f <malloc+0x5e>
					return NULL ;
  801578:	b8 00 00 00 00       	mov    $0x0,%eax
  80157d:	eb 39                	jmp    8015b8 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  80157f:	83 ec 0c             	sub    $0xc,%esp
  801582:	ff 75 08             	pushl  0x8(%ebp)
  801585:	e8 e6 0d 00 00       	call   802370 <alloc_block_FF>
  80158a:	83 c4 10             	add    $0x10,%esp
  80158d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801590:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801594:	74 16                	je     8015ac <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801596:	83 ec 0c             	sub    $0xc,%esp
  801599:	ff 75 ec             	pushl  -0x14(%ebp)
  80159c:	e8 37 0c 00 00       	call   8021d8 <insert_sorted_allocList>
  8015a1:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  8015a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015a7:	8b 40 08             	mov    0x8(%eax),%eax
  8015aa:	eb 0c                	jmp    8015b8 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8015ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b1:	eb 05                	jmp    8015b8 <malloc+0x97>
				}
		}
	return 0;
  8015b3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015b8:	c9                   	leave  
  8015b9:	c3                   	ret    

008015ba <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015ba:	55                   	push   %ebp
  8015bb:	89 e5                	mov    %esp,%ebp
  8015bd:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8015c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8015c6:	83 ec 08             	sub    $0x8,%esp
  8015c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8015cc:	68 40 40 80 00       	push   $0x804040
  8015d1:	e8 cf 0b 00 00       	call   8021a5 <find_block>
  8015d6:	83 c4 10             	add    $0x10,%esp
  8015d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8015dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015df:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e2:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8015e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e8:	8b 40 08             	mov    0x8(%eax),%eax
  8015eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8015ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015f2:	0f 84 a1 00 00 00    	je     801699 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8015f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015fc:	75 17                	jne    801615 <free+0x5b>
  8015fe:	83 ec 04             	sub    $0x4,%esp
  801601:	68 35 3b 80 00       	push   $0x803b35
  801606:	68 80 00 00 00       	push   $0x80
  80160b:	68 53 3b 80 00       	push   $0x803b53
  801610:	e8 b9 ec ff ff       	call   8002ce <_panic>
  801615:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801618:	8b 00                	mov    (%eax),%eax
  80161a:	85 c0                	test   %eax,%eax
  80161c:	74 10                	je     80162e <free+0x74>
  80161e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801621:	8b 00                	mov    (%eax),%eax
  801623:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801626:	8b 52 04             	mov    0x4(%edx),%edx
  801629:	89 50 04             	mov    %edx,0x4(%eax)
  80162c:	eb 0b                	jmp    801639 <free+0x7f>
  80162e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801631:	8b 40 04             	mov    0x4(%eax),%eax
  801634:	a3 44 40 80 00       	mov    %eax,0x804044
  801639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163c:	8b 40 04             	mov    0x4(%eax),%eax
  80163f:	85 c0                	test   %eax,%eax
  801641:	74 0f                	je     801652 <free+0x98>
  801643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801646:	8b 40 04             	mov    0x4(%eax),%eax
  801649:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80164c:	8b 12                	mov    (%edx),%edx
  80164e:	89 10                	mov    %edx,(%eax)
  801650:	eb 0a                	jmp    80165c <free+0xa2>
  801652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801655:	8b 00                	mov    (%eax),%eax
  801657:	a3 40 40 80 00       	mov    %eax,0x804040
  80165c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80165f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801665:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801668:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80166f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801674:	48                   	dec    %eax
  801675:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  80167a:	83 ec 0c             	sub    $0xc,%esp
  80167d:	ff 75 f0             	pushl  -0x10(%ebp)
  801680:	e8 29 12 00 00       	call   8028ae <insert_sorted_with_merge_freeList>
  801685:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801688:	83 ec 08             	sub    $0x8,%esp
  80168b:	ff 75 ec             	pushl  -0x14(%ebp)
  80168e:	ff 75 e8             	pushl  -0x18(%ebp)
  801691:	e8 74 03 00 00       	call   801a0a <sys_free_user_mem>
  801696:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801699:	90                   	nop
  80169a:	c9                   	leave  
  80169b:	c3                   	ret    

0080169c <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  80169c:	55                   	push   %ebp
  80169d:	89 e5                	mov    %esp,%ebp
  80169f:	83 ec 38             	sub    $0x38,%esp
  8016a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a5:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016a8:	e8 5f fc ff ff       	call   80130c <InitializeUHeap>
	if (size == 0) return NULL ;
  8016ad:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b1:	75 0a                	jne    8016bd <smalloc+0x21>
  8016b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b8:	e9 b2 00 00 00       	jmp    80176f <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8016bd:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8016c4:	76 0a                	jbe    8016d0 <smalloc+0x34>
		return NULL;
  8016c6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cb:	e9 9f 00 00 00       	jmp    80176f <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016d0:	e8 3b 07 00 00       	call   801e10 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016d5:	85 c0                	test   %eax,%eax
  8016d7:	0f 84 8d 00 00 00    	je     80176a <smalloc+0xce>
	struct MemBlock *b = NULL;
  8016dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8016e4:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f1:	01 d0                	add    %edx,%eax
  8016f3:	48                   	dec    %eax
  8016f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ff:	f7 75 f0             	divl   -0x10(%ebp)
  801702:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801705:	29 d0                	sub    %edx,%eax
  801707:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  80170a:	83 ec 0c             	sub    $0xc,%esp
  80170d:	ff 75 e8             	pushl  -0x18(%ebp)
  801710:	e8 5b 0c 00 00       	call   802370 <alloc_block_FF>
  801715:	83 c4 10             	add    $0x10,%esp
  801718:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  80171b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80171f:	75 07                	jne    801728 <smalloc+0x8c>
			return NULL;
  801721:	b8 00 00 00 00       	mov    $0x0,%eax
  801726:	eb 47                	jmp    80176f <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801728:	83 ec 0c             	sub    $0xc,%esp
  80172b:	ff 75 f4             	pushl  -0xc(%ebp)
  80172e:	e8 a5 0a 00 00       	call   8021d8 <insert_sorted_allocList>
  801733:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801739:	8b 40 08             	mov    0x8(%eax),%eax
  80173c:	89 c2                	mov    %eax,%edx
  80173e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801742:	52                   	push   %edx
  801743:	50                   	push   %eax
  801744:	ff 75 0c             	pushl  0xc(%ebp)
  801747:	ff 75 08             	pushl  0x8(%ebp)
  80174a:	e8 46 04 00 00       	call   801b95 <sys_createSharedObject>
  80174f:	83 c4 10             	add    $0x10,%esp
  801752:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801755:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801759:	78 08                	js     801763 <smalloc+0xc7>
		return (void *)b->sva;
  80175b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80175e:	8b 40 08             	mov    0x8(%eax),%eax
  801761:	eb 0c                	jmp    80176f <smalloc+0xd3>
		}else{
		return NULL;
  801763:	b8 00 00 00 00       	mov    $0x0,%eax
  801768:	eb 05                	jmp    80176f <smalloc+0xd3>
			}

	}return NULL;
  80176a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80176f:	c9                   	leave  
  801770:	c3                   	ret    

00801771 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801777:	e8 90 fb ff ff       	call   80130c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80177c:	e8 8f 06 00 00       	call   801e10 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801781:	85 c0                	test   %eax,%eax
  801783:	0f 84 ad 00 00 00    	je     801836 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801789:	83 ec 08             	sub    $0x8,%esp
  80178c:	ff 75 0c             	pushl  0xc(%ebp)
  80178f:	ff 75 08             	pushl  0x8(%ebp)
  801792:	e8 28 04 00 00       	call   801bbf <sys_getSizeOfSharedObject>
  801797:	83 c4 10             	add    $0x10,%esp
  80179a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  80179d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017a1:	79 0a                	jns    8017ad <sget+0x3c>
    {
    	return NULL;
  8017a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017a8:	e9 8e 00 00 00       	jmp    80183b <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  8017ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  8017b4:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c1:	01 d0                	add    %edx,%eax
  8017c3:	48                   	dec    %eax
  8017c4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017ca:	ba 00 00 00 00       	mov    $0x0,%edx
  8017cf:	f7 75 ec             	divl   -0x14(%ebp)
  8017d2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017d5:	29 d0                	sub    %edx,%eax
  8017d7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8017da:	83 ec 0c             	sub    $0xc,%esp
  8017dd:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017e0:	e8 8b 0b 00 00       	call   802370 <alloc_block_FF>
  8017e5:	83 c4 10             	add    $0x10,%esp
  8017e8:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8017eb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017ef:	75 07                	jne    8017f8 <sget+0x87>
				return NULL;
  8017f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f6:	eb 43                	jmp    80183b <sget+0xca>
			}
			insert_sorted_allocList(b);
  8017f8:	83 ec 0c             	sub    $0xc,%esp
  8017fb:	ff 75 f0             	pushl  -0x10(%ebp)
  8017fe:	e8 d5 09 00 00       	call   8021d8 <insert_sorted_allocList>
  801803:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801806:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801809:	8b 40 08             	mov    0x8(%eax),%eax
  80180c:	83 ec 04             	sub    $0x4,%esp
  80180f:	50                   	push   %eax
  801810:	ff 75 0c             	pushl  0xc(%ebp)
  801813:	ff 75 08             	pushl  0x8(%ebp)
  801816:	e8 c1 03 00 00       	call   801bdc <sys_getSharedObject>
  80181b:	83 c4 10             	add    $0x10,%esp
  80181e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801821:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801825:	78 08                	js     80182f <sget+0xbe>
			return (void *)b->sva;
  801827:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182a:	8b 40 08             	mov    0x8(%eax),%eax
  80182d:	eb 0c                	jmp    80183b <sget+0xca>
			}else{
			return NULL;
  80182f:	b8 00 00 00 00       	mov    $0x0,%eax
  801834:	eb 05                	jmp    80183b <sget+0xca>
			}
    }}return NULL;
  801836:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183b:	c9                   	leave  
  80183c:	c3                   	ret    

0080183d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80183d:	55                   	push   %ebp
  80183e:	89 e5                	mov    %esp,%ebp
  801840:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801843:	e8 c4 fa ff ff       	call   80130c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	68 84 3b 80 00       	push   $0x803b84
  801850:	68 03 01 00 00       	push   $0x103
  801855:	68 53 3b 80 00       	push   $0x803b53
  80185a:	e8 6f ea ff ff       	call   8002ce <_panic>

0080185f <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	68 ac 3b 80 00       	push   $0x803bac
  80186d:	68 17 01 00 00       	push   $0x117
  801872:	68 53 3b 80 00       	push   $0x803b53
  801877:	e8 52 ea ff ff       	call   8002ce <_panic>

0080187c <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801882:	83 ec 04             	sub    $0x4,%esp
  801885:	68 d0 3b 80 00       	push   $0x803bd0
  80188a:	68 22 01 00 00       	push   $0x122
  80188f:	68 53 3b 80 00       	push   $0x803b53
  801894:	e8 35 ea ff ff       	call   8002ce <_panic>

00801899 <shrink>:

}
void shrink(uint32 newSize)
{
  801899:	55                   	push   %ebp
  80189a:	89 e5                	mov    %esp,%ebp
  80189c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80189f:	83 ec 04             	sub    $0x4,%esp
  8018a2:	68 d0 3b 80 00       	push   $0x803bd0
  8018a7:	68 27 01 00 00       	push   $0x127
  8018ac:	68 53 3b 80 00       	push   $0x803b53
  8018b1:	e8 18 ea ff ff       	call   8002ce <_panic>

008018b6 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018b6:	55                   	push   %ebp
  8018b7:	89 e5                	mov    %esp,%ebp
  8018b9:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018bc:	83 ec 04             	sub    $0x4,%esp
  8018bf:	68 d0 3b 80 00       	push   $0x803bd0
  8018c4:	68 2c 01 00 00       	push   $0x12c
  8018c9:	68 53 3b 80 00       	push   $0x803b53
  8018ce:	e8 fb e9 ff ff       	call   8002ce <_panic>

008018d3 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018d3:	55                   	push   %ebp
  8018d4:	89 e5                	mov    %esp,%ebp
  8018d6:	57                   	push   %edi
  8018d7:	56                   	push   %esi
  8018d8:	53                   	push   %ebx
  8018d9:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018e8:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018eb:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018ee:	cd 30                	int    $0x30
  8018f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018f6:	83 c4 10             	add    $0x10,%esp
  8018f9:	5b                   	pop    %ebx
  8018fa:	5e                   	pop    %esi
  8018fb:	5f                   	pop    %edi
  8018fc:	5d                   	pop    %ebp
  8018fd:	c3                   	ret    

008018fe <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
  801901:	83 ec 04             	sub    $0x4,%esp
  801904:	8b 45 10             	mov    0x10(%ebp),%eax
  801907:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80190a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80190e:	8b 45 08             	mov    0x8(%ebp),%eax
  801911:	6a 00                	push   $0x0
  801913:	6a 00                	push   $0x0
  801915:	52                   	push   %edx
  801916:	ff 75 0c             	pushl  0xc(%ebp)
  801919:	50                   	push   %eax
  80191a:	6a 00                	push   $0x0
  80191c:	e8 b2 ff ff ff       	call   8018d3 <syscall>
  801921:	83 c4 18             	add    $0x18,%esp
}
  801924:	90                   	nop
  801925:	c9                   	leave  
  801926:	c3                   	ret    

00801927 <sys_cgetc>:

int
sys_cgetc(void)
{
  801927:	55                   	push   %ebp
  801928:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80192a:	6a 00                	push   $0x0
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	6a 00                	push   $0x0
  801932:	6a 00                	push   $0x0
  801934:	6a 01                	push   $0x1
  801936:	e8 98 ff ff ff       	call   8018d3 <syscall>
  80193b:	83 c4 18             	add    $0x18,%esp
}
  80193e:	c9                   	leave  
  80193f:	c3                   	ret    

00801940 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801940:	55                   	push   %ebp
  801941:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801943:	8b 55 0c             	mov    0xc(%ebp),%edx
  801946:	8b 45 08             	mov    0x8(%ebp),%eax
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	52                   	push   %edx
  801950:	50                   	push   %eax
  801951:	6a 05                	push   $0x5
  801953:	e8 7b ff ff ff       	call   8018d3 <syscall>
  801958:	83 c4 18             	add    $0x18,%esp
}
  80195b:	c9                   	leave  
  80195c:	c3                   	ret    

0080195d <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80195d:	55                   	push   %ebp
  80195e:	89 e5                	mov    %esp,%ebp
  801960:	56                   	push   %esi
  801961:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801962:	8b 75 18             	mov    0x18(%ebp),%esi
  801965:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801968:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80196e:	8b 45 08             	mov    0x8(%ebp),%eax
  801971:	56                   	push   %esi
  801972:	53                   	push   %ebx
  801973:	51                   	push   %ecx
  801974:	52                   	push   %edx
  801975:	50                   	push   %eax
  801976:	6a 06                	push   $0x6
  801978:	e8 56 ff ff ff       	call   8018d3 <syscall>
  80197d:	83 c4 18             	add    $0x18,%esp
}
  801980:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801983:	5b                   	pop    %ebx
  801984:	5e                   	pop    %esi
  801985:	5d                   	pop    %ebp
  801986:	c3                   	ret    

00801987 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801987:	55                   	push   %ebp
  801988:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80198a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80198d:	8b 45 08             	mov    0x8(%ebp),%eax
  801990:	6a 00                	push   $0x0
  801992:	6a 00                	push   $0x0
  801994:	6a 00                	push   $0x0
  801996:	52                   	push   %edx
  801997:	50                   	push   %eax
  801998:	6a 07                	push   $0x7
  80199a:	e8 34 ff ff ff       	call   8018d3 <syscall>
  80199f:	83 c4 18             	add    $0x18,%esp
}
  8019a2:	c9                   	leave  
  8019a3:	c3                   	ret    

008019a4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019a4:	55                   	push   %ebp
  8019a5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 00                	push   $0x0
  8019ad:	ff 75 0c             	pushl  0xc(%ebp)
  8019b0:	ff 75 08             	pushl  0x8(%ebp)
  8019b3:	6a 08                	push   $0x8
  8019b5:	e8 19 ff ff ff       	call   8018d3 <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 09                	push   $0x9
  8019ce:	e8 00 ff ff ff       	call   8018d3 <syscall>
  8019d3:	83 c4 18             	add    $0x18,%esp
}
  8019d6:	c9                   	leave  
  8019d7:	c3                   	ret    

008019d8 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019d8:	55                   	push   %ebp
  8019d9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 0a                	push   $0xa
  8019e7:	e8 e7 fe ff ff       	call   8018d3 <syscall>
  8019ec:	83 c4 18             	add    $0x18,%esp
}
  8019ef:	c9                   	leave  
  8019f0:	c3                   	ret    

008019f1 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019f1:	55                   	push   %ebp
  8019f2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 0b                	push   $0xb
  801a00:	e8 ce fe ff ff       	call   8018d3 <syscall>
  801a05:	83 c4 18             	add    $0x18,%esp
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	ff 75 0c             	pushl  0xc(%ebp)
  801a16:	ff 75 08             	pushl  0x8(%ebp)
  801a19:	6a 0f                	push   $0xf
  801a1b:	e8 b3 fe ff ff       	call   8018d3 <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
	return;
  801a23:	90                   	nop
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	ff 75 0c             	pushl  0xc(%ebp)
  801a32:	ff 75 08             	pushl  0x8(%ebp)
  801a35:	6a 10                	push   $0x10
  801a37:	e8 97 fe ff ff       	call   8018d3 <syscall>
  801a3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a3f:	90                   	nop
}
  801a40:	c9                   	leave  
  801a41:	c3                   	ret    

00801a42 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a42:	55                   	push   %ebp
  801a43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	ff 75 10             	pushl  0x10(%ebp)
  801a4c:	ff 75 0c             	pushl  0xc(%ebp)
  801a4f:	ff 75 08             	pushl  0x8(%ebp)
  801a52:	6a 11                	push   $0x11
  801a54:	e8 7a fe ff ff       	call   8018d3 <syscall>
  801a59:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5c:	90                   	nop
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 00                	push   $0x0
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 0c                	push   $0xc
  801a6e:	e8 60 fe ff ff       	call   8018d3 <syscall>
  801a73:	83 c4 18             	add    $0x18,%esp
}
  801a76:	c9                   	leave  
  801a77:	c3                   	ret    

00801a78 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a78:	55                   	push   %ebp
  801a79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	ff 75 08             	pushl  0x8(%ebp)
  801a86:	6a 0d                	push   $0xd
  801a88:	e8 46 fe ff ff       	call   8018d3 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	c9                   	leave  
  801a91:	c3                   	ret    

00801a92 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a92:	55                   	push   %ebp
  801a93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 0e                	push   $0xe
  801aa1:	e8 2d fe ff ff       	call   8018d3 <syscall>
  801aa6:	83 c4 18             	add    $0x18,%esp
}
  801aa9:	90                   	nop
  801aaa:	c9                   	leave  
  801aab:	c3                   	ret    

00801aac <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801aac:	55                   	push   %ebp
  801aad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801aaf:	6a 00                	push   $0x0
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 13                	push   $0x13
  801abb:	e8 13 fe ff ff       	call   8018d3 <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
}
  801ac3:	90                   	nop
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 14                	push   $0x14
  801ad5:	e8 f9 fd ff ff       	call   8018d3 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	90                   	nop
  801ade:	c9                   	leave  
  801adf:	c3                   	ret    

00801ae0 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ae0:	55                   	push   %ebp
  801ae1:	89 e5                	mov    %esp,%ebp
  801ae3:	83 ec 04             	sub    $0x4,%esp
  801ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aec:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	50                   	push   %eax
  801af9:	6a 15                	push   $0x15
  801afb:	e8 d3 fd ff ff       	call   8018d3 <syscall>
  801b00:	83 c4 18             	add    $0x18,%esp
}
  801b03:	90                   	nop
  801b04:	c9                   	leave  
  801b05:	c3                   	ret    

00801b06 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b06:	55                   	push   %ebp
  801b07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	6a 16                	push   $0x16
  801b15:	e8 b9 fd ff ff       	call   8018d3 <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	90                   	nop
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b23:	8b 45 08             	mov    0x8(%ebp),%eax
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	ff 75 0c             	pushl  0xc(%ebp)
  801b2f:	50                   	push   %eax
  801b30:	6a 17                	push   $0x17
  801b32:	e8 9c fd ff ff       	call   8018d3 <syscall>
  801b37:	83 c4 18             	add    $0x18,%esp
}
  801b3a:	c9                   	leave  
  801b3b:	c3                   	ret    

00801b3c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b3c:	55                   	push   %ebp
  801b3d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b3f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b42:	8b 45 08             	mov    0x8(%ebp),%eax
  801b45:	6a 00                	push   $0x0
  801b47:	6a 00                	push   $0x0
  801b49:	6a 00                	push   $0x0
  801b4b:	52                   	push   %edx
  801b4c:	50                   	push   %eax
  801b4d:	6a 1a                	push   $0x1a
  801b4f:	e8 7f fd ff ff       	call   8018d3 <syscall>
  801b54:	83 c4 18             	add    $0x18,%esp
}
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b5c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	52                   	push   %edx
  801b69:	50                   	push   %eax
  801b6a:	6a 18                	push   $0x18
  801b6c:	e8 62 fd ff ff       	call   8018d3 <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
}
  801b74:	90                   	nop
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b7a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	52                   	push   %edx
  801b87:	50                   	push   %eax
  801b88:	6a 19                	push   $0x19
  801b8a:	e8 44 fd ff ff       	call   8018d3 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	90                   	nop
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
  801b98:	83 ec 04             	sub    $0x4,%esp
  801b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  801b9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ba1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ba4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bab:	6a 00                	push   $0x0
  801bad:	51                   	push   %ecx
  801bae:	52                   	push   %edx
  801baf:	ff 75 0c             	pushl  0xc(%ebp)
  801bb2:	50                   	push   %eax
  801bb3:	6a 1b                	push   $0x1b
  801bb5:	e8 19 fd ff ff       	call   8018d3 <syscall>
  801bba:	83 c4 18             	add    $0x18,%esp
}
  801bbd:	c9                   	leave  
  801bbe:	c3                   	ret    

00801bbf <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bbf:	55                   	push   %ebp
  801bc0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bc2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	52                   	push   %edx
  801bcf:	50                   	push   %eax
  801bd0:	6a 1c                	push   $0x1c
  801bd2:	e8 fc fc ff ff       	call   8018d3 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bdf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	51                   	push   %ecx
  801bed:	52                   	push   %edx
  801bee:	50                   	push   %eax
  801bef:	6a 1d                	push   $0x1d
  801bf1:	e8 dd fc ff ff       	call   8018d3 <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	c9                   	leave  
  801bfa:	c3                   	ret    

00801bfb <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bfb:	55                   	push   %ebp
  801bfc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c01:	8b 45 08             	mov    0x8(%ebp),%eax
  801c04:	6a 00                	push   $0x0
  801c06:	6a 00                	push   $0x0
  801c08:	6a 00                	push   $0x0
  801c0a:	52                   	push   %edx
  801c0b:	50                   	push   %eax
  801c0c:	6a 1e                	push   $0x1e
  801c0e:	e8 c0 fc ff ff       	call   8018d3 <syscall>
  801c13:	83 c4 18             	add    $0x18,%esp
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	6a 1f                	push   $0x1f
  801c27:	e8 a7 fc ff ff       	call   8018d3 <syscall>
  801c2c:	83 c4 18             	add    $0x18,%esp
}
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c34:	8b 45 08             	mov    0x8(%ebp),%eax
  801c37:	6a 00                	push   $0x0
  801c39:	ff 75 14             	pushl  0x14(%ebp)
  801c3c:	ff 75 10             	pushl  0x10(%ebp)
  801c3f:	ff 75 0c             	pushl  0xc(%ebp)
  801c42:	50                   	push   %eax
  801c43:	6a 20                	push   $0x20
  801c45:	e8 89 fc ff ff       	call   8018d3 <syscall>
  801c4a:	83 c4 18             	add    $0x18,%esp
}
  801c4d:	c9                   	leave  
  801c4e:	c3                   	ret    

00801c4f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c4f:	55                   	push   %ebp
  801c50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c52:	8b 45 08             	mov    0x8(%ebp),%eax
  801c55:	6a 00                	push   $0x0
  801c57:	6a 00                	push   $0x0
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	50                   	push   %eax
  801c5e:	6a 21                	push   $0x21
  801c60:	e8 6e fc ff ff       	call   8018d3 <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	90                   	nop
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	50                   	push   %eax
  801c7a:	6a 22                	push   $0x22
  801c7c:	e8 52 fc ff ff       	call   8018d3 <syscall>
  801c81:	83 c4 18             	add    $0x18,%esp
}
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	6a 00                	push   $0x0
  801c8f:	6a 00                	push   $0x0
  801c91:	6a 00                	push   $0x0
  801c93:	6a 02                	push   $0x2
  801c95:	e8 39 fc ff ff       	call   8018d3 <syscall>
  801c9a:	83 c4 18             	add    $0x18,%esp
}
  801c9d:	c9                   	leave  
  801c9e:	c3                   	ret    

00801c9f <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c9f:	55                   	push   %ebp
  801ca0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 03                	push   $0x3
  801cae:	e8 20 fc ff ff       	call   8018d3 <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
}
  801cb6:	c9                   	leave  
  801cb7:	c3                   	ret    

00801cb8 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cb8:	55                   	push   %ebp
  801cb9:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 04                	push   $0x4
  801cc7:	e8 07 fc ff ff       	call   8018d3 <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
}
  801ccf:	c9                   	leave  
  801cd0:	c3                   	ret    

00801cd1 <sys_exit_env>:


void sys_exit_env(void)
{
  801cd1:	55                   	push   %ebp
  801cd2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 23                	push   $0x23
  801ce0:	e8 ee fb ff ff       	call   8018d3 <syscall>
  801ce5:	83 c4 18             	add    $0x18,%esp
}
  801ce8:	90                   	nop
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
  801cee:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cf1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf4:	8d 50 04             	lea    0x4(%eax),%edx
  801cf7:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	52                   	push   %edx
  801d01:	50                   	push   %eax
  801d02:	6a 24                	push   $0x24
  801d04:	e8 ca fb ff ff       	call   8018d3 <syscall>
  801d09:	83 c4 18             	add    $0x18,%esp
	return result;
  801d0c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d0f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d12:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d15:	89 01                	mov    %eax,(%ecx)
  801d17:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d1d:	c9                   	leave  
  801d1e:	c2 04 00             	ret    $0x4

00801d21 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d21:	55                   	push   %ebp
  801d22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	ff 75 10             	pushl  0x10(%ebp)
  801d2b:	ff 75 0c             	pushl  0xc(%ebp)
  801d2e:	ff 75 08             	pushl  0x8(%ebp)
  801d31:	6a 12                	push   $0x12
  801d33:	e8 9b fb ff ff       	call   8018d3 <syscall>
  801d38:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3b:	90                   	nop
}
  801d3c:	c9                   	leave  
  801d3d:	c3                   	ret    

00801d3e <sys_rcr2>:
uint32 sys_rcr2()
{
  801d3e:	55                   	push   %ebp
  801d3f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 25                	push   $0x25
  801d4d:	e8 81 fb ff ff       	call   8018d3 <syscall>
  801d52:	83 c4 18             	add    $0x18,%esp
}
  801d55:	c9                   	leave  
  801d56:	c3                   	ret    

00801d57 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d57:	55                   	push   %ebp
  801d58:	89 e5                	mov    %esp,%ebp
  801d5a:	83 ec 04             	sub    $0x4,%esp
  801d5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d60:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d63:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	6a 00                	push   $0x0
  801d6d:	6a 00                	push   $0x0
  801d6f:	50                   	push   %eax
  801d70:	6a 26                	push   $0x26
  801d72:	e8 5c fb ff ff       	call   8018d3 <syscall>
  801d77:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7a:	90                   	nop
}
  801d7b:	c9                   	leave  
  801d7c:	c3                   	ret    

00801d7d <rsttst>:
void rsttst()
{
  801d7d:	55                   	push   %ebp
  801d7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	6a 28                	push   $0x28
  801d8c:	e8 42 fb ff ff       	call   8018d3 <syscall>
  801d91:	83 c4 18             	add    $0x18,%esp
	return ;
  801d94:	90                   	nop
}
  801d95:	c9                   	leave  
  801d96:	c3                   	ret    

00801d97 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d97:	55                   	push   %ebp
  801d98:	89 e5                	mov    %esp,%ebp
  801d9a:	83 ec 04             	sub    $0x4,%esp
  801d9d:	8b 45 14             	mov    0x14(%ebp),%eax
  801da0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801da3:	8b 55 18             	mov    0x18(%ebp),%edx
  801da6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801daa:	52                   	push   %edx
  801dab:	50                   	push   %eax
  801dac:	ff 75 10             	pushl  0x10(%ebp)
  801daf:	ff 75 0c             	pushl  0xc(%ebp)
  801db2:	ff 75 08             	pushl  0x8(%ebp)
  801db5:	6a 27                	push   $0x27
  801db7:	e8 17 fb ff ff       	call   8018d3 <syscall>
  801dbc:	83 c4 18             	add    $0x18,%esp
	return ;
  801dbf:	90                   	nop
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <chktst>:
void chktst(uint32 n)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	ff 75 08             	pushl  0x8(%ebp)
  801dd0:	6a 29                	push   $0x29
  801dd2:	e8 fc fa ff ff       	call   8018d3 <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dda:	90                   	nop
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <inctst>:

void inctst()
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 2a                	push   $0x2a
  801dec:	e8 e2 fa ff ff       	call   8018d3 <syscall>
  801df1:	83 c4 18             	add    $0x18,%esp
	return ;
  801df4:	90                   	nop
}
  801df5:	c9                   	leave  
  801df6:	c3                   	ret    

00801df7 <gettst>:
uint32 gettst()
{
  801df7:	55                   	push   %ebp
  801df8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dfa:	6a 00                	push   $0x0
  801dfc:	6a 00                	push   $0x0
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 2b                	push   $0x2b
  801e06:	e8 c8 fa ff ff       	call   8018d3 <syscall>
  801e0b:	83 c4 18             	add    $0x18,%esp
}
  801e0e:	c9                   	leave  
  801e0f:	c3                   	ret    

00801e10 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e10:	55                   	push   %ebp
  801e11:	89 e5                	mov    %esp,%ebp
  801e13:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 2c                	push   $0x2c
  801e22:	e8 ac fa ff ff       	call   8018d3 <syscall>
  801e27:	83 c4 18             	add    $0x18,%esp
  801e2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e2d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e31:	75 07                	jne    801e3a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e33:	b8 01 00 00 00       	mov    $0x1,%eax
  801e38:	eb 05                	jmp    801e3f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
  801e44:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 2c                	push   $0x2c
  801e53:	e8 7b fa ff ff       	call   8018d3 <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
  801e5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e5e:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e62:	75 07                	jne    801e6b <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e64:	b8 01 00 00 00       	mov    $0x1,%eax
  801e69:	eb 05                	jmp    801e70 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e70:	c9                   	leave  
  801e71:	c3                   	ret    

00801e72 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e72:	55                   	push   %ebp
  801e73:	89 e5                	mov    %esp,%ebp
  801e75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 2c                	push   $0x2c
  801e84:	e8 4a fa ff ff       	call   8018d3 <syscall>
  801e89:	83 c4 18             	add    $0x18,%esp
  801e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e8f:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e93:	75 07                	jne    801e9c <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e95:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9a:	eb 05                	jmp    801ea1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea1:	c9                   	leave  
  801ea2:	c3                   	ret    

00801ea3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ea3:	55                   	push   %ebp
  801ea4:	89 e5                	mov    %esp,%ebp
  801ea6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 2c                	push   $0x2c
  801eb5:	e8 19 fa ff ff       	call   8018d3 <syscall>
  801eba:	83 c4 18             	add    $0x18,%esp
  801ebd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ec0:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ec4:	75 07                	jne    801ecd <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ec6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ecb:	eb 05                	jmp    801ed2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ecd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	ff 75 08             	pushl  0x8(%ebp)
  801ee2:	6a 2d                	push   $0x2d
  801ee4:	e8 ea f9 ff ff       	call   8018d3 <syscall>
  801ee9:	83 c4 18             	add    $0x18,%esp
	return ;
  801eec:	90                   	nop
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
  801ef2:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ef3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801efc:	8b 45 08             	mov    0x8(%ebp),%eax
  801eff:	6a 00                	push   $0x0
  801f01:	53                   	push   %ebx
  801f02:	51                   	push   %ecx
  801f03:	52                   	push   %edx
  801f04:	50                   	push   %eax
  801f05:	6a 2e                	push   $0x2e
  801f07:	e8 c7 f9 ff ff       	call   8018d3 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
}
  801f0f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f12:	c9                   	leave  
  801f13:	c3                   	ret    

00801f14 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	52                   	push   %edx
  801f24:	50                   	push   %eax
  801f25:	6a 2f                	push   $0x2f
  801f27:	e8 a7 f9 ff ff       	call   8018d3 <syscall>
  801f2c:	83 c4 18             	add    $0x18,%esp
}
  801f2f:	c9                   	leave  
  801f30:	c3                   	ret    

00801f31 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f37:	83 ec 0c             	sub    $0xc,%esp
  801f3a:	68 e0 3b 80 00       	push   $0x803be0
  801f3f:	e8 3e e6 ff ff       	call   800582 <cprintf>
  801f44:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f47:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f4e:	83 ec 0c             	sub    $0xc,%esp
  801f51:	68 0c 3c 80 00       	push   $0x803c0c
  801f56:	e8 27 e6 ff ff       	call   800582 <cprintf>
  801f5b:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f5e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f62:	a1 38 41 80 00       	mov    0x804138,%eax
  801f67:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6a:	eb 56                	jmp    801fc2 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f6c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f70:	74 1c                	je     801f8e <print_mem_block_lists+0x5d>
  801f72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f75:	8b 50 08             	mov    0x8(%eax),%edx
  801f78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7b:	8b 48 08             	mov    0x8(%eax),%ecx
  801f7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f81:	8b 40 0c             	mov    0xc(%eax),%eax
  801f84:	01 c8                	add    %ecx,%eax
  801f86:	39 c2                	cmp    %eax,%edx
  801f88:	73 04                	jae    801f8e <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f8a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f91:	8b 50 08             	mov    0x8(%eax),%edx
  801f94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f97:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9a:	01 c2                	add    %eax,%edx
  801f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9f:	8b 40 08             	mov    0x8(%eax),%eax
  801fa2:	83 ec 04             	sub    $0x4,%esp
  801fa5:	52                   	push   %edx
  801fa6:	50                   	push   %eax
  801fa7:	68 21 3c 80 00       	push   $0x803c21
  801fac:	e8 d1 e5 ff ff       	call   800582 <cprintf>
  801fb1:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fba:	a1 40 41 80 00       	mov    0x804140,%eax
  801fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc6:	74 07                	je     801fcf <print_mem_block_lists+0x9e>
  801fc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcb:	8b 00                	mov    (%eax),%eax
  801fcd:	eb 05                	jmp    801fd4 <print_mem_block_lists+0xa3>
  801fcf:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd4:	a3 40 41 80 00       	mov    %eax,0x804140
  801fd9:	a1 40 41 80 00       	mov    0x804140,%eax
  801fde:	85 c0                	test   %eax,%eax
  801fe0:	75 8a                	jne    801f6c <print_mem_block_lists+0x3b>
  801fe2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe6:	75 84                	jne    801f6c <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fe8:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fec:	75 10                	jne    801ffe <print_mem_block_lists+0xcd>
  801fee:	83 ec 0c             	sub    $0xc,%esp
  801ff1:	68 30 3c 80 00       	push   $0x803c30
  801ff6:	e8 87 e5 ff ff       	call   800582 <cprintf>
  801ffb:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ffe:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802005:	83 ec 0c             	sub    $0xc,%esp
  802008:	68 54 3c 80 00       	push   $0x803c54
  80200d:	e8 70 e5 ff ff       	call   800582 <cprintf>
  802012:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802015:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802019:	a1 40 40 80 00       	mov    0x804040,%eax
  80201e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802021:	eb 56                	jmp    802079 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802023:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802027:	74 1c                	je     802045 <print_mem_block_lists+0x114>
  802029:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202c:	8b 50 08             	mov    0x8(%eax),%edx
  80202f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802032:	8b 48 08             	mov    0x8(%eax),%ecx
  802035:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802038:	8b 40 0c             	mov    0xc(%eax),%eax
  80203b:	01 c8                	add    %ecx,%eax
  80203d:	39 c2                	cmp    %eax,%edx
  80203f:	73 04                	jae    802045 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802041:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802045:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802048:	8b 50 08             	mov    0x8(%eax),%edx
  80204b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204e:	8b 40 0c             	mov    0xc(%eax),%eax
  802051:	01 c2                	add    %eax,%edx
  802053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802056:	8b 40 08             	mov    0x8(%eax),%eax
  802059:	83 ec 04             	sub    $0x4,%esp
  80205c:	52                   	push   %edx
  80205d:	50                   	push   %eax
  80205e:	68 21 3c 80 00       	push   $0x803c21
  802063:	e8 1a e5 ff ff       	call   800582 <cprintf>
  802068:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80206b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802071:	a1 48 40 80 00       	mov    0x804048,%eax
  802076:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802079:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207d:	74 07                	je     802086 <print_mem_block_lists+0x155>
  80207f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802082:	8b 00                	mov    (%eax),%eax
  802084:	eb 05                	jmp    80208b <print_mem_block_lists+0x15a>
  802086:	b8 00 00 00 00       	mov    $0x0,%eax
  80208b:	a3 48 40 80 00       	mov    %eax,0x804048
  802090:	a1 48 40 80 00       	mov    0x804048,%eax
  802095:	85 c0                	test   %eax,%eax
  802097:	75 8a                	jne    802023 <print_mem_block_lists+0xf2>
  802099:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80209d:	75 84                	jne    802023 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80209f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020a3:	75 10                	jne    8020b5 <print_mem_block_lists+0x184>
  8020a5:	83 ec 0c             	sub    $0xc,%esp
  8020a8:	68 6c 3c 80 00       	push   $0x803c6c
  8020ad:	e8 d0 e4 ff ff       	call   800582 <cprintf>
  8020b2:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020b5:	83 ec 0c             	sub    $0xc,%esp
  8020b8:	68 e0 3b 80 00       	push   $0x803be0
  8020bd:	e8 c0 e4 ff ff       	call   800582 <cprintf>
  8020c2:	83 c4 10             	add    $0x10,%esp

}
  8020c5:	90                   	nop
  8020c6:	c9                   	leave  
  8020c7:	c3                   	ret    

008020c8 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020c8:	55                   	push   %ebp
  8020c9:	89 e5                	mov    %esp,%ebp
  8020cb:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8020ce:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020d5:	00 00 00 
  8020d8:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020df:	00 00 00 
  8020e2:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020e9:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8020ec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020f3:	e9 9e 00 00 00       	jmp    802196 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8020f8:	a1 50 40 80 00       	mov    0x804050,%eax
  8020fd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802100:	c1 e2 04             	shl    $0x4,%edx
  802103:	01 d0                	add    %edx,%eax
  802105:	85 c0                	test   %eax,%eax
  802107:	75 14                	jne    80211d <initialize_MemBlocksList+0x55>
  802109:	83 ec 04             	sub    $0x4,%esp
  80210c:	68 94 3c 80 00       	push   $0x803c94
  802111:	6a 3d                	push   $0x3d
  802113:	68 b7 3c 80 00       	push   $0x803cb7
  802118:	e8 b1 e1 ff ff       	call   8002ce <_panic>
  80211d:	a1 50 40 80 00       	mov    0x804050,%eax
  802122:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802125:	c1 e2 04             	shl    $0x4,%edx
  802128:	01 d0                	add    %edx,%eax
  80212a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802130:	89 10                	mov    %edx,(%eax)
  802132:	8b 00                	mov    (%eax),%eax
  802134:	85 c0                	test   %eax,%eax
  802136:	74 18                	je     802150 <initialize_MemBlocksList+0x88>
  802138:	a1 48 41 80 00       	mov    0x804148,%eax
  80213d:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802143:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802146:	c1 e1 04             	shl    $0x4,%ecx
  802149:	01 ca                	add    %ecx,%edx
  80214b:	89 50 04             	mov    %edx,0x4(%eax)
  80214e:	eb 12                	jmp    802162 <initialize_MemBlocksList+0x9a>
  802150:	a1 50 40 80 00       	mov    0x804050,%eax
  802155:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802158:	c1 e2 04             	shl    $0x4,%edx
  80215b:	01 d0                	add    %edx,%eax
  80215d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802162:	a1 50 40 80 00       	mov    0x804050,%eax
  802167:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216a:	c1 e2 04             	shl    $0x4,%edx
  80216d:	01 d0                	add    %edx,%eax
  80216f:	a3 48 41 80 00       	mov    %eax,0x804148
  802174:	a1 50 40 80 00       	mov    0x804050,%eax
  802179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217c:	c1 e2 04             	shl    $0x4,%edx
  80217f:	01 d0                	add    %edx,%eax
  802181:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802188:	a1 54 41 80 00       	mov    0x804154,%eax
  80218d:	40                   	inc    %eax
  80218e:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802193:	ff 45 f4             	incl   -0xc(%ebp)
  802196:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802199:	3b 45 08             	cmp    0x8(%ebp),%eax
  80219c:	0f 82 56 ff ff ff    	jb     8020f8 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8021a2:	90                   	nop
  8021a3:	c9                   	leave  
  8021a4:	c3                   	ret    

008021a5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021a5:	55                   	push   %ebp
  8021a6:	89 e5                	mov    %esp,%ebp
  8021a8:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8021ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ae:	8b 00                	mov    (%eax),%eax
  8021b0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8021b3:	eb 18                	jmp    8021cd <find_block+0x28>

		if(tmp->sva == va){
  8021b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b8:	8b 40 08             	mov    0x8(%eax),%eax
  8021bb:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021be:	75 05                	jne    8021c5 <find_block+0x20>
			return tmp ;
  8021c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c3:	eb 11                	jmp    8021d6 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8021c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c8:	8b 00                	mov    (%eax),%eax
  8021ca:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8021cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021d1:	75 e2                	jne    8021b5 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8021d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021d6:	c9                   	leave  
  8021d7:	c3                   	ret    

008021d8 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8021de:	a1 40 40 80 00       	mov    0x804040,%eax
  8021e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8021e6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021eb:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8021ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021f2:	75 65                	jne    802259 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8021f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021f8:	75 14                	jne    80220e <insert_sorted_allocList+0x36>
  8021fa:	83 ec 04             	sub    $0x4,%esp
  8021fd:	68 94 3c 80 00       	push   $0x803c94
  802202:	6a 62                	push   $0x62
  802204:	68 b7 3c 80 00       	push   $0x803cb7
  802209:	e8 c0 e0 ff ff       	call   8002ce <_panic>
  80220e:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802214:	8b 45 08             	mov    0x8(%ebp),%eax
  802217:	89 10                	mov    %edx,(%eax)
  802219:	8b 45 08             	mov    0x8(%ebp),%eax
  80221c:	8b 00                	mov    (%eax),%eax
  80221e:	85 c0                	test   %eax,%eax
  802220:	74 0d                	je     80222f <insert_sorted_allocList+0x57>
  802222:	a1 40 40 80 00       	mov    0x804040,%eax
  802227:	8b 55 08             	mov    0x8(%ebp),%edx
  80222a:	89 50 04             	mov    %edx,0x4(%eax)
  80222d:	eb 08                	jmp    802237 <insert_sorted_allocList+0x5f>
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	a3 44 40 80 00       	mov    %eax,0x804044
  802237:	8b 45 08             	mov    0x8(%ebp),%eax
  80223a:	a3 40 40 80 00       	mov    %eax,0x804040
  80223f:	8b 45 08             	mov    0x8(%ebp),%eax
  802242:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802249:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80224e:	40                   	inc    %eax
  80224f:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802254:	e9 14 01 00 00       	jmp    80236d <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802259:	8b 45 08             	mov    0x8(%ebp),%eax
  80225c:	8b 50 08             	mov    0x8(%eax),%edx
  80225f:	a1 44 40 80 00       	mov    0x804044,%eax
  802264:	8b 40 08             	mov    0x8(%eax),%eax
  802267:	39 c2                	cmp    %eax,%edx
  802269:	76 65                	jbe    8022d0 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80226b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80226f:	75 14                	jne    802285 <insert_sorted_allocList+0xad>
  802271:	83 ec 04             	sub    $0x4,%esp
  802274:	68 d0 3c 80 00       	push   $0x803cd0
  802279:	6a 64                	push   $0x64
  80227b:	68 b7 3c 80 00       	push   $0x803cb7
  802280:	e8 49 e0 ff ff       	call   8002ce <_panic>
  802285:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80228b:	8b 45 08             	mov    0x8(%ebp),%eax
  80228e:	89 50 04             	mov    %edx,0x4(%eax)
  802291:	8b 45 08             	mov    0x8(%ebp),%eax
  802294:	8b 40 04             	mov    0x4(%eax),%eax
  802297:	85 c0                	test   %eax,%eax
  802299:	74 0c                	je     8022a7 <insert_sorted_allocList+0xcf>
  80229b:	a1 44 40 80 00       	mov    0x804044,%eax
  8022a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a3:	89 10                	mov    %edx,(%eax)
  8022a5:	eb 08                	jmp    8022af <insert_sorted_allocList+0xd7>
  8022a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022aa:	a3 40 40 80 00       	mov    %eax,0x804040
  8022af:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b2:	a3 44 40 80 00       	mov    %eax,0x804044
  8022b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022c5:	40                   	inc    %eax
  8022c6:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8022cb:	e9 9d 00 00 00       	jmp    80236d <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8022d0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8022d7:	e9 85 00 00 00       	jmp    802361 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8022dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022df:	8b 50 08             	mov    0x8(%eax),%edx
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	8b 40 08             	mov    0x8(%eax),%eax
  8022e8:	39 c2                	cmp    %eax,%edx
  8022ea:	73 6a                	jae    802356 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8022ec:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f0:	74 06                	je     8022f8 <insert_sorted_allocList+0x120>
  8022f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022f6:	75 14                	jne    80230c <insert_sorted_allocList+0x134>
  8022f8:	83 ec 04             	sub    $0x4,%esp
  8022fb:	68 f4 3c 80 00       	push   $0x803cf4
  802300:	6a 6b                	push   $0x6b
  802302:	68 b7 3c 80 00       	push   $0x803cb7
  802307:	e8 c2 df ff ff       	call   8002ce <_panic>
  80230c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230f:	8b 50 04             	mov    0x4(%eax),%edx
  802312:	8b 45 08             	mov    0x8(%ebp),%eax
  802315:	89 50 04             	mov    %edx,0x4(%eax)
  802318:	8b 45 08             	mov    0x8(%ebp),%eax
  80231b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80231e:	89 10                	mov    %edx,(%eax)
  802320:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802323:	8b 40 04             	mov    0x4(%eax),%eax
  802326:	85 c0                	test   %eax,%eax
  802328:	74 0d                	je     802337 <insert_sorted_allocList+0x15f>
  80232a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232d:	8b 40 04             	mov    0x4(%eax),%eax
  802330:	8b 55 08             	mov    0x8(%ebp),%edx
  802333:	89 10                	mov    %edx,(%eax)
  802335:	eb 08                	jmp    80233f <insert_sorted_allocList+0x167>
  802337:	8b 45 08             	mov    0x8(%ebp),%eax
  80233a:	a3 40 40 80 00       	mov    %eax,0x804040
  80233f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802342:	8b 55 08             	mov    0x8(%ebp),%edx
  802345:	89 50 04             	mov    %edx,0x4(%eax)
  802348:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80234d:	40                   	inc    %eax
  80234e:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  802353:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802354:	eb 17                	jmp    80236d <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802356:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802359:	8b 00                	mov    (%eax),%eax
  80235b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80235e:	ff 45 f0             	incl   -0x10(%ebp)
  802361:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802364:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802367:	0f 8c 6f ff ff ff    	jl     8022dc <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80236d:	90                   	nop
  80236e:	c9                   	leave  
  80236f:	c3                   	ret    

00802370 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802370:	55                   	push   %ebp
  802371:	89 e5                	mov    %esp,%ebp
  802373:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802376:	a1 38 41 80 00       	mov    0x804138,%eax
  80237b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80237e:	e9 7c 01 00 00       	jmp    8024ff <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802383:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802386:	8b 40 0c             	mov    0xc(%eax),%eax
  802389:	3b 45 08             	cmp    0x8(%ebp),%eax
  80238c:	0f 86 cf 00 00 00    	jbe    802461 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802392:	a1 48 41 80 00       	mov    0x804148,%eax
  802397:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  80239a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80239d:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8023a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a6:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8023a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ac:	8b 50 08             	mov    0x8(%eax),%edx
  8023af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b2:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	8b 40 0c             	mov    0xc(%eax),%eax
  8023bb:	2b 45 08             	sub    0x8(%ebp),%eax
  8023be:	89 c2                	mov    %eax,%edx
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	8b 50 08             	mov    0x8(%eax),%edx
  8023cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8023cf:	01 c2                	add    %eax,%edx
  8023d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d4:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8023d7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023db:	75 17                	jne    8023f4 <alloc_block_FF+0x84>
  8023dd:	83 ec 04             	sub    $0x4,%esp
  8023e0:	68 29 3d 80 00       	push   $0x803d29
  8023e5:	68 83 00 00 00       	push   $0x83
  8023ea:	68 b7 3c 80 00       	push   $0x803cb7
  8023ef:	e8 da de ff ff       	call   8002ce <_panic>
  8023f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f7:	8b 00                	mov    (%eax),%eax
  8023f9:	85 c0                	test   %eax,%eax
  8023fb:	74 10                	je     80240d <alloc_block_FF+0x9d>
  8023fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802400:	8b 00                	mov    (%eax),%eax
  802402:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802405:	8b 52 04             	mov    0x4(%edx),%edx
  802408:	89 50 04             	mov    %edx,0x4(%eax)
  80240b:	eb 0b                	jmp    802418 <alloc_block_FF+0xa8>
  80240d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802410:	8b 40 04             	mov    0x4(%eax),%eax
  802413:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802418:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241b:	8b 40 04             	mov    0x4(%eax),%eax
  80241e:	85 c0                	test   %eax,%eax
  802420:	74 0f                	je     802431 <alloc_block_FF+0xc1>
  802422:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802425:	8b 40 04             	mov    0x4(%eax),%eax
  802428:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80242b:	8b 12                	mov    (%edx),%edx
  80242d:	89 10                	mov    %edx,(%eax)
  80242f:	eb 0a                	jmp    80243b <alloc_block_FF+0xcb>
  802431:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802434:	8b 00                	mov    (%eax),%eax
  802436:	a3 48 41 80 00       	mov    %eax,0x804148
  80243b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802444:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802447:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80244e:	a1 54 41 80 00       	mov    0x804154,%eax
  802453:	48                   	dec    %eax
  802454:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  802459:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245c:	e9 ad 00 00 00       	jmp    80250e <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	8b 40 0c             	mov    0xc(%eax),%eax
  802467:	3b 45 08             	cmp    0x8(%ebp),%eax
  80246a:	0f 85 87 00 00 00    	jne    8024f7 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802470:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802474:	75 17                	jne    80248d <alloc_block_FF+0x11d>
  802476:	83 ec 04             	sub    $0x4,%esp
  802479:	68 29 3d 80 00       	push   $0x803d29
  80247e:	68 87 00 00 00       	push   $0x87
  802483:	68 b7 3c 80 00       	push   $0x803cb7
  802488:	e8 41 de ff ff       	call   8002ce <_panic>
  80248d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802490:	8b 00                	mov    (%eax),%eax
  802492:	85 c0                	test   %eax,%eax
  802494:	74 10                	je     8024a6 <alloc_block_FF+0x136>
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	8b 00                	mov    (%eax),%eax
  80249b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80249e:	8b 52 04             	mov    0x4(%edx),%edx
  8024a1:	89 50 04             	mov    %edx,0x4(%eax)
  8024a4:	eb 0b                	jmp    8024b1 <alloc_block_FF+0x141>
  8024a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a9:	8b 40 04             	mov    0x4(%eax),%eax
  8024ac:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 40 04             	mov    0x4(%eax),%eax
  8024b7:	85 c0                	test   %eax,%eax
  8024b9:	74 0f                	je     8024ca <alloc_block_FF+0x15a>
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	8b 40 04             	mov    0x4(%eax),%eax
  8024c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c4:	8b 12                	mov    (%edx),%edx
  8024c6:	89 10                	mov    %edx,(%eax)
  8024c8:	eb 0a                	jmp    8024d4 <alloc_block_FF+0x164>
  8024ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cd:	8b 00                	mov    (%eax),%eax
  8024cf:	a3 38 41 80 00       	mov    %eax,0x804138
  8024d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024e7:	a1 44 41 80 00       	mov    0x804144,%eax
  8024ec:	48                   	dec    %eax
  8024ed:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8024f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f5:	eb 17                	jmp    80250e <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8024f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fa:	8b 00                	mov    (%eax),%eax
  8024fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8024ff:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802503:	0f 85 7a fe ff ff    	jne    802383 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802509:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80250e:	c9                   	leave  
  80250f:	c3                   	ret    

00802510 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802510:	55                   	push   %ebp
  802511:	89 e5                	mov    %esp,%ebp
  802513:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802516:	a1 38 41 80 00       	mov    0x804138,%eax
  80251b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  80251e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802525:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80252c:	a1 38 41 80 00       	mov    0x804138,%eax
  802531:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802534:	e9 d0 00 00 00       	jmp    802609 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 40 0c             	mov    0xc(%eax),%eax
  80253f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802542:	0f 82 b8 00 00 00    	jb     802600 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802548:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254b:	8b 40 0c             	mov    0xc(%eax),%eax
  80254e:	2b 45 08             	sub    0x8(%ebp),%eax
  802551:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802554:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802557:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80255a:	0f 83 a1 00 00 00    	jae    802601 <alloc_block_BF+0xf1>
				differsize = differance ;
  802560:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802563:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80256c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802570:	0f 85 8b 00 00 00    	jne    802601 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802576:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257a:	75 17                	jne    802593 <alloc_block_BF+0x83>
  80257c:	83 ec 04             	sub    $0x4,%esp
  80257f:	68 29 3d 80 00       	push   $0x803d29
  802584:	68 a0 00 00 00       	push   $0xa0
  802589:	68 b7 3c 80 00       	push   $0x803cb7
  80258e:	e8 3b dd ff ff       	call   8002ce <_panic>
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	85 c0                	test   %eax,%eax
  80259a:	74 10                	je     8025ac <alloc_block_BF+0x9c>
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 00                	mov    (%eax),%eax
  8025a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a4:	8b 52 04             	mov    0x4(%edx),%edx
  8025a7:	89 50 04             	mov    %edx,0x4(%eax)
  8025aa:	eb 0b                	jmp    8025b7 <alloc_block_BF+0xa7>
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	8b 40 04             	mov    0x4(%eax),%eax
  8025b2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 40 04             	mov    0x4(%eax),%eax
  8025bd:	85 c0                	test   %eax,%eax
  8025bf:	74 0f                	je     8025d0 <alloc_block_BF+0xc0>
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	8b 40 04             	mov    0x4(%eax),%eax
  8025c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ca:	8b 12                	mov    (%edx),%edx
  8025cc:	89 10                	mov    %edx,(%eax)
  8025ce:	eb 0a                	jmp    8025da <alloc_block_BF+0xca>
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 00                	mov    (%eax),%eax
  8025d5:	a3 38 41 80 00       	mov    %eax,0x804138
  8025da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025ed:	a1 44 41 80 00       	mov    0x804144,%eax
  8025f2:	48                   	dec    %eax
  8025f3:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	e9 0c 01 00 00       	jmp    80270c <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802600:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802601:	a1 40 41 80 00       	mov    0x804140,%eax
  802606:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802609:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260d:	74 07                	je     802616 <alloc_block_BF+0x106>
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 00                	mov    (%eax),%eax
  802614:	eb 05                	jmp    80261b <alloc_block_BF+0x10b>
  802616:	b8 00 00 00 00       	mov    $0x0,%eax
  80261b:	a3 40 41 80 00       	mov    %eax,0x804140
  802620:	a1 40 41 80 00       	mov    0x804140,%eax
  802625:	85 c0                	test   %eax,%eax
  802627:	0f 85 0c ff ff ff    	jne    802539 <alloc_block_BF+0x29>
  80262d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802631:	0f 85 02 ff ff ff    	jne    802539 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802637:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80263b:	0f 84 c6 00 00 00    	je     802707 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802641:	a1 48 41 80 00       	mov    0x804148,%eax
  802646:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802649:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80264c:	8b 55 08             	mov    0x8(%ebp),%edx
  80264f:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802652:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802655:	8b 50 08             	mov    0x8(%eax),%edx
  802658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265b:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  80265e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802661:	8b 40 0c             	mov    0xc(%eax),%eax
  802664:	2b 45 08             	sub    0x8(%ebp),%eax
  802667:	89 c2                	mov    %eax,%edx
  802669:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266c:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  80266f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802672:	8b 50 08             	mov    0x8(%eax),%edx
  802675:	8b 45 08             	mov    0x8(%ebp),%eax
  802678:	01 c2                	add    %eax,%edx
  80267a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267d:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802680:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802684:	75 17                	jne    80269d <alloc_block_BF+0x18d>
  802686:	83 ec 04             	sub    $0x4,%esp
  802689:	68 29 3d 80 00       	push   $0x803d29
  80268e:	68 af 00 00 00       	push   $0xaf
  802693:	68 b7 3c 80 00       	push   $0x803cb7
  802698:	e8 31 dc ff ff       	call   8002ce <_panic>
  80269d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a0:	8b 00                	mov    (%eax),%eax
  8026a2:	85 c0                	test   %eax,%eax
  8026a4:	74 10                	je     8026b6 <alloc_block_BF+0x1a6>
  8026a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a9:	8b 00                	mov    (%eax),%eax
  8026ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ae:	8b 52 04             	mov    0x4(%edx),%edx
  8026b1:	89 50 04             	mov    %edx,0x4(%eax)
  8026b4:	eb 0b                	jmp    8026c1 <alloc_block_BF+0x1b1>
  8026b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b9:	8b 40 04             	mov    0x4(%eax),%eax
  8026bc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c4:	8b 40 04             	mov    0x4(%eax),%eax
  8026c7:	85 c0                	test   %eax,%eax
  8026c9:	74 0f                	je     8026da <alloc_block_BF+0x1ca>
  8026cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ce:	8b 40 04             	mov    0x4(%eax),%eax
  8026d1:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026d4:	8b 12                	mov    (%edx),%edx
  8026d6:	89 10                	mov    %edx,(%eax)
  8026d8:	eb 0a                	jmp    8026e4 <alloc_block_BF+0x1d4>
  8026da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026dd:	8b 00                	mov    (%eax),%eax
  8026df:	a3 48 41 80 00       	mov    %eax,0x804148
  8026e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026f7:	a1 54 41 80 00       	mov    0x804154,%eax
  8026fc:	48                   	dec    %eax
  8026fd:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  802702:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802705:	eb 05                	jmp    80270c <alloc_block_BF+0x1fc>
	}

	return NULL;
  802707:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80270c:	c9                   	leave  
  80270d:	c3                   	ret    

0080270e <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  80270e:	55                   	push   %ebp
  80270f:	89 e5                	mov    %esp,%ebp
  802711:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802714:	a1 38 41 80 00       	mov    0x804138,%eax
  802719:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  80271c:	e9 7c 01 00 00       	jmp    80289d <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802721:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802724:	8b 40 0c             	mov    0xc(%eax),%eax
  802727:	3b 45 08             	cmp    0x8(%ebp),%eax
  80272a:	0f 86 cf 00 00 00    	jbe    8027ff <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802730:	a1 48 41 80 00       	mov    0x804148,%eax
  802735:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  80273e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802741:	8b 55 08             	mov    0x8(%ebp),%edx
  802744:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	8b 50 08             	mov    0x8(%eax),%edx
  80274d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802750:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 40 0c             	mov    0xc(%eax),%eax
  802759:	2b 45 08             	sub    0x8(%ebp),%eax
  80275c:	89 c2                	mov    %eax,%edx
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802764:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802767:	8b 50 08             	mov    0x8(%eax),%edx
  80276a:	8b 45 08             	mov    0x8(%ebp),%eax
  80276d:	01 c2                	add    %eax,%edx
  80276f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802772:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802775:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802779:	75 17                	jne    802792 <alloc_block_NF+0x84>
  80277b:	83 ec 04             	sub    $0x4,%esp
  80277e:	68 29 3d 80 00       	push   $0x803d29
  802783:	68 c4 00 00 00       	push   $0xc4
  802788:	68 b7 3c 80 00       	push   $0x803cb7
  80278d:	e8 3c db ff ff       	call   8002ce <_panic>
  802792:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802795:	8b 00                	mov    (%eax),%eax
  802797:	85 c0                	test   %eax,%eax
  802799:	74 10                	je     8027ab <alloc_block_NF+0x9d>
  80279b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279e:	8b 00                	mov    (%eax),%eax
  8027a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027a3:	8b 52 04             	mov    0x4(%edx),%edx
  8027a6:	89 50 04             	mov    %edx,0x4(%eax)
  8027a9:	eb 0b                	jmp    8027b6 <alloc_block_NF+0xa8>
  8027ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ae:	8b 40 04             	mov    0x4(%eax),%eax
  8027b1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b9:	8b 40 04             	mov    0x4(%eax),%eax
  8027bc:	85 c0                	test   %eax,%eax
  8027be:	74 0f                	je     8027cf <alloc_block_NF+0xc1>
  8027c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c3:	8b 40 04             	mov    0x4(%eax),%eax
  8027c6:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027c9:	8b 12                	mov    (%edx),%edx
  8027cb:	89 10                	mov    %edx,(%eax)
  8027cd:	eb 0a                	jmp    8027d9 <alloc_block_NF+0xcb>
  8027cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d2:	8b 00                	mov    (%eax),%eax
  8027d4:	a3 48 41 80 00       	mov    %eax,0x804148
  8027d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ec:	a1 54 41 80 00       	mov    0x804154,%eax
  8027f1:	48                   	dec    %eax
  8027f2:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8027f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fa:	e9 ad 00 00 00       	jmp    8028ac <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	8b 40 0c             	mov    0xc(%eax),%eax
  802805:	3b 45 08             	cmp    0x8(%ebp),%eax
  802808:	0f 85 87 00 00 00    	jne    802895 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  80280e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802812:	75 17                	jne    80282b <alloc_block_NF+0x11d>
  802814:	83 ec 04             	sub    $0x4,%esp
  802817:	68 29 3d 80 00       	push   $0x803d29
  80281c:	68 c8 00 00 00       	push   $0xc8
  802821:	68 b7 3c 80 00       	push   $0x803cb7
  802826:	e8 a3 da ff ff       	call   8002ce <_panic>
  80282b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282e:	8b 00                	mov    (%eax),%eax
  802830:	85 c0                	test   %eax,%eax
  802832:	74 10                	je     802844 <alloc_block_NF+0x136>
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	8b 00                	mov    (%eax),%eax
  802839:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283c:	8b 52 04             	mov    0x4(%edx),%edx
  80283f:	89 50 04             	mov    %edx,0x4(%eax)
  802842:	eb 0b                	jmp    80284f <alloc_block_NF+0x141>
  802844:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802847:	8b 40 04             	mov    0x4(%eax),%eax
  80284a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 40 04             	mov    0x4(%eax),%eax
  802855:	85 c0                	test   %eax,%eax
  802857:	74 0f                	je     802868 <alloc_block_NF+0x15a>
  802859:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285c:	8b 40 04             	mov    0x4(%eax),%eax
  80285f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802862:	8b 12                	mov    (%edx),%edx
  802864:	89 10                	mov    %edx,(%eax)
  802866:	eb 0a                	jmp    802872 <alloc_block_NF+0x164>
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	8b 00                	mov    (%eax),%eax
  80286d:	a3 38 41 80 00       	mov    %eax,0x804138
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802885:	a1 44 41 80 00       	mov    0x804144,%eax
  80288a:	48                   	dec    %eax
  80288b:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802890:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802893:	eb 17                	jmp    8028ac <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802895:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802898:	8b 00                	mov    (%eax),%eax
  80289a:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  80289d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a1:	0f 85 7a fe ff ff    	jne    802721 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  8028a7:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8028ac:	c9                   	leave  
  8028ad:	c3                   	ret    

008028ae <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8028ae:	55                   	push   %ebp
  8028af:	89 e5                	mov    %esp,%ebp
  8028b1:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  8028b4:	a1 38 41 80 00       	mov    0x804138,%eax
  8028b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8028bc:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8028c4:	a1 44 41 80 00       	mov    0x804144,%eax
  8028c9:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8028cc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028d0:	75 68                	jne    80293a <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8028d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028d6:	75 17                	jne    8028ef <insert_sorted_with_merge_freeList+0x41>
  8028d8:	83 ec 04             	sub    $0x4,%esp
  8028db:	68 94 3c 80 00       	push   $0x803c94
  8028e0:	68 da 00 00 00       	push   $0xda
  8028e5:	68 b7 3c 80 00       	push   $0x803cb7
  8028ea:	e8 df d9 ff ff       	call   8002ce <_panic>
  8028ef:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f8:	89 10                	mov    %edx,(%eax)
  8028fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fd:	8b 00                	mov    (%eax),%eax
  8028ff:	85 c0                	test   %eax,%eax
  802901:	74 0d                	je     802910 <insert_sorted_with_merge_freeList+0x62>
  802903:	a1 38 41 80 00       	mov    0x804138,%eax
  802908:	8b 55 08             	mov    0x8(%ebp),%edx
  80290b:	89 50 04             	mov    %edx,0x4(%eax)
  80290e:	eb 08                	jmp    802918 <insert_sorted_with_merge_freeList+0x6a>
  802910:	8b 45 08             	mov    0x8(%ebp),%eax
  802913:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802918:	8b 45 08             	mov    0x8(%ebp),%eax
  80291b:	a3 38 41 80 00       	mov    %eax,0x804138
  802920:	8b 45 08             	mov    0x8(%ebp),%eax
  802923:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292a:	a1 44 41 80 00       	mov    0x804144,%eax
  80292f:	40                   	inc    %eax
  802930:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  802935:	e9 49 07 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  80293a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293d:	8b 50 08             	mov    0x8(%eax),%edx
  802940:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802943:	8b 40 0c             	mov    0xc(%eax),%eax
  802946:	01 c2                	add    %eax,%edx
  802948:	8b 45 08             	mov    0x8(%ebp),%eax
  80294b:	8b 40 08             	mov    0x8(%eax),%eax
  80294e:	39 c2                	cmp    %eax,%edx
  802950:	73 77                	jae    8029c9 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802952:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	85 c0                	test   %eax,%eax
  802959:	75 6e                	jne    8029c9 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  80295b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80295f:	74 68                	je     8029c9 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802961:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802965:	75 17                	jne    80297e <insert_sorted_with_merge_freeList+0xd0>
  802967:	83 ec 04             	sub    $0x4,%esp
  80296a:	68 d0 3c 80 00       	push   $0x803cd0
  80296f:	68 e0 00 00 00       	push   $0xe0
  802974:	68 b7 3c 80 00       	push   $0x803cb7
  802979:	e8 50 d9 ff ff       	call   8002ce <_panic>
  80297e:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802984:	8b 45 08             	mov    0x8(%ebp),%eax
  802987:	89 50 04             	mov    %edx,0x4(%eax)
  80298a:	8b 45 08             	mov    0x8(%ebp),%eax
  80298d:	8b 40 04             	mov    0x4(%eax),%eax
  802990:	85 c0                	test   %eax,%eax
  802992:	74 0c                	je     8029a0 <insert_sorted_with_merge_freeList+0xf2>
  802994:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802999:	8b 55 08             	mov    0x8(%ebp),%edx
  80299c:	89 10                	mov    %edx,(%eax)
  80299e:	eb 08                	jmp    8029a8 <insert_sorted_with_merge_freeList+0xfa>
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	a3 38 41 80 00       	mov    %eax,0x804138
  8029a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ab:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029b9:	a1 44 41 80 00       	mov    0x804144,%eax
  8029be:	40                   	inc    %eax
  8029bf:	a3 44 41 80 00       	mov    %eax,0x804144
  8029c4:	e9 ba 06 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cc:	8b 50 0c             	mov    0xc(%eax),%edx
  8029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d2:	8b 40 08             	mov    0x8(%eax),%eax
  8029d5:	01 c2                	add    %eax,%edx
  8029d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029da:	8b 40 08             	mov    0x8(%eax),%eax
  8029dd:	39 c2                	cmp    %eax,%edx
  8029df:	73 78                	jae    802a59 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	8b 40 04             	mov    0x4(%eax),%eax
  8029e7:	85 c0                	test   %eax,%eax
  8029e9:	75 6e                	jne    802a59 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8029eb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029ef:	74 68                	je     802a59 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8029f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f5:	75 17                	jne    802a0e <insert_sorted_with_merge_freeList+0x160>
  8029f7:	83 ec 04             	sub    $0x4,%esp
  8029fa:	68 94 3c 80 00       	push   $0x803c94
  8029ff:	68 e6 00 00 00       	push   $0xe6
  802a04:	68 b7 3c 80 00       	push   $0x803cb7
  802a09:	e8 c0 d8 ff ff       	call   8002ce <_panic>
  802a0e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	89 10                	mov    %edx,(%eax)
  802a19:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1c:	8b 00                	mov    (%eax),%eax
  802a1e:	85 c0                	test   %eax,%eax
  802a20:	74 0d                	je     802a2f <insert_sorted_with_merge_freeList+0x181>
  802a22:	a1 38 41 80 00       	mov    0x804138,%eax
  802a27:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2a:	89 50 04             	mov    %edx,0x4(%eax)
  802a2d:	eb 08                	jmp    802a37 <insert_sorted_with_merge_freeList+0x189>
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	a3 38 41 80 00       	mov    %eax,0x804138
  802a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a49:	a1 44 41 80 00       	mov    0x804144,%eax
  802a4e:	40                   	inc    %eax
  802a4f:	a3 44 41 80 00       	mov    %eax,0x804144
  802a54:	e9 2a 06 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802a59:	a1 38 41 80 00       	mov    0x804138,%eax
  802a5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a61:	e9 ed 05 00 00       	jmp    803053 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802a6e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a72:	0f 84 a7 00 00 00    	je     802b1f <insert_sorted_with_merge_freeList+0x271>
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 50 0c             	mov    0xc(%eax),%edx
  802a7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a81:	8b 40 08             	mov    0x8(%eax),%eax
  802a84:	01 c2                	add    %eax,%edx
  802a86:	8b 45 08             	mov    0x8(%ebp),%eax
  802a89:	8b 40 08             	mov    0x8(%eax),%eax
  802a8c:	39 c2                	cmp    %eax,%edx
  802a8e:	0f 83 8b 00 00 00    	jae    802b1f <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	8b 50 0c             	mov    0xc(%eax),%edx
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	8b 40 08             	mov    0x8(%eax),%eax
  802aa0:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802aa2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa5:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802aa8:	39 c2                	cmp    %eax,%edx
  802aaa:	73 73                	jae    802b1f <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802aac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab0:	74 06                	je     802ab8 <insert_sorted_with_merge_freeList+0x20a>
  802ab2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab6:	75 17                	jne    802acf <insert_sorted_with_merge_freeList+0x221>
  802ab8:	83 ec 04             	sub    $0x4,%esp
  802abb:	68 48 3d 80 00       	push   $0x803d48
  802ac0:	68 f0 00 00 00       	push   $0xf0
  802ac5:	68 b7 3c 80 00       	push   $0x803cb7
  802aca:	e8 ff d7 ff ff       	call   8002ce <_panic>
  802acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad2:	8b 10                	mov    (%eax),%edx
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	89 10                	mov    %edx,(%eax)
  802ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  802adc:	8b 00                	mov    (%eax),%eax
  802ade:	85 c0                	test   %eax,%eax
  802ae0:	74 0b                	je     802aed <insert_sorted_with_merge_freeList+0x23f>
  802ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae5:	8b 00                	mov    (%eax),%eax
  802ae7:	8b 55 08             	mov    0x8(%ebp),%edx
  802aea:	89 50 04             	mov    %edx,0x4(%eax)
  802aed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af0:	8b 55 08             	mov    0x8(%ebp),%edx
  802af3:	89 10                	mov    %edx,(%eax)
  802af5:	8b 45 08             	mov    0x8(%ebp),%eax
  802af8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802afb:	89 50 04             	mov    %edx,0x4(%eax)
  802afe:	8b 45 08             	mov    0x8(%ebp),%eax
  802b01:	8b 00                	mov    (%eax),%eax
  802b03:	85 c0                	test   %eax,%eax
  802b05:	75 08                	jne    802b0f <insert_sorted_with_merge_freeList+0x261>
  802b07:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b0f:	a1 44 41 80 00       	mov    0x804144,%eax
  802b14:	40                   	inc    %eax
  802b15:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802b1a:	e9 64 05 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802b1f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b24:	8b 50 0c             	mov    0xc(%eax),%edx
  802b27:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b2c:	8b 40 08             	mov    0x8(%eax),%eax
  802b2f:	01 c2                	add    %eax,%edx
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
  802b34:	8b 40 08             	mov    0x8(%eax),%eax
  802b37:	39 c2                	cmp    %eax,%edx
  802b39:	0f 85 b1 00 00 00    	jne    802bf0 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802b3f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b44:	85 c0                	test   %eax,%eax
  802b46:	0f 84 a4 00 00 00    	je     802bf0 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802b4c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b51:	8b 00                	mov    (%eax),%eax
  802b53:	85 c0                	test   %eax,%eax
  802b55:	0f 85 95 00 00 00    	jne    802bf0 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802b5b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b60:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b66:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b69:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6c:	8b 52 0c             	mov    0xc(%edx),%edx
  802b6f:	01 ca                	add    %ecx,%edx
  802b71:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802b74:	8b 45 08             	mov    0x8(%ebp),%eax
  802b77:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b81:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802b88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b8c:	75 17                	jne    802ba5 <insert_sorted_with_merge_freeList+0x2f7>
  802b8e:	83 ec 04             	sub    $0x4,%esp
  802b91:	68 94 3c 80 00       	push   $0x803c94
  802b96:	68 ff 00 00 00       	push   $0xff
  802b9b:	68 b7 3c 80 00       	push   $0x803cb7
  802ba0:	e8 29 d7 ff ff       	call   8002ce <_panic>
  802ba5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bab:	8b 45 08             	mov    0x8(%ebp),%eax
  802bae:	89 10                	mov    %edx,(%eax)
  802bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb3:	8b 00                	mov    (%eax),%eax
  802bb5:	85 c0                	test   %eax,%eax
  802bb7:	74 0d                	je     802bc6 <insert_sorted_with_merge_freeList+0x318>
  802bb9:	a1 48 41 80 00       	mov    0x804148,%eax
  802bbe:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc1:	89 50 04             	mov    %edx,0x4(%eax)
  802bc4:	eb 08                	jmp    802bce <insert_sorted_with_merge_freeList+0x320>
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	a3 48 41 80 00       	mov    %eax,0x804148
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be0:	a1 54 41 80 00       	mov    0x804154,%eax
  802be5:	40                   	inc    %eax
  802be6:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802beb:	e9 93 04 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802bf0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf3:	8b 50 08             	mov    0x8(%eax),%edx
  802bf6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bfc:	01 c2                	add    %eax,%edx
  802bfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802c01:	8b 40 08             	mov    0x8(%eax),%eax
  802c04:	39 c2                	cmp    %eax,%edx
  802c06:	0f 85 ae 00 00 00    	jne    802cba <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802c0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0f:	8b 50 0c             	mov    0xc(%eax),%edx
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	8b 40 08             	mov    0x8(%eax),%eax
  802c18:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802c1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1d:	8b 00                	mov    (%eax),%eax
  802c1f:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802c22:	39 c2                	cmp    %eax,%edx
  802c24:	0f 84 90 00 00 00    	je     802cba <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802c2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2d:	8b 50 0c             	mov    0xc(%eax),%edx
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	8b 40 0c             	mov    0xc(%eax),%eax
  802c36:	01 c2                	add    %eax,%edx
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802c3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c41:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802c48:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c52:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c56:	75 17                	jne    802c6f <insert_sorted_with_merge_freeList+0x3c1>
  802c58:	83 ec 04             	sub    $0x4,%esp
  802c5b:	68 94 3c 80 00       	push   $0x803c94
  802c60:	68 0b 01 00 00       	push   $0x10b
  802c65:	68 b7 3c 80 00       	push   $0x803cb7
  802c6a:	e8 5f d6 ff ff       	call   8002ce <_panic>
  802c6f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c75:	8b 45 08             	mov    0x8(%ebp),%eax
  802c78:	89 10                	mov    %edx,(%eax)
  802c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7d:	8b 00                	mov    (%eax),%eax
  802c7f:	85 c0                	test   %eax,%eax
  802c81:	74 0d                	je     802c90 <insert_sorted_with_merge_freeList+0x3e2>
  802c83:	a1 48 41 80 00       	mov    0x804148,%eax
  802c88:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8b:	89 50 04             	mov    %edx,0x4(%eax)
  802c8e:	eb 08                	jmp    802c98 <insert_sorted_with_merge_freeList+0x3ea>
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	a3 48 41 80 00       	mov    %eax,0x804148
  802ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802caa:	a1 54 41 80 00       	mov    0x804154,%eax
  802caf:	40                   	inc    %eax
  802cb0:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802cb5:	e9 c9 03 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802cba:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbd:	8b 50 0c             	mov    0xc(%eax),%edx
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	8b 40 08             	mov    0x8(%eax),%eax
  802cc6:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802cce:	39 c2                	cmp    %eax,%edx
  802cd0:	0f 85 bb 00 00 00    	jne    802d91 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802cd6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cda:	0f 84 b1 00 00 00    	je     802d91 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	8b 40 04             	mov    0x4(%eax),%eax
  802ce6:	85 c0                	test   %eax,%eax
  802ce8:	0f 85 a3 00 00 00    	jne    802d91 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802cee:	a1 38 41 80 00       	mov    0x804138,%eax
  802cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf6:	8b 52 08             	mov    0x8(%edx),%edx
  802cf9:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802cfc:	a1 38 41 80 00       	mov    0x804138,%eax
  802d01:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d07:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802d0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0d:	8b 52 0c             	mov    0xc(%edx),%edx
  802d10:	01 ca                	add    %ecx,%edx
  802d12:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802d15:	8b 45 08             	mov    0x8(%ebp),%eax
  802d18:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d22:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d2d:	75 17                	jne    802d46 <insert_sorted_with_merge_freeList+0x498>
  802d2f:	83 ec 04             	sub    $0x4,%esp
  802d32:	68 94 3c 80 00       	push   $0x803c94
  802d37:	68 17 01 00 00       	push   $0x117
  802d3c:	68 b7 3c 80 00       	push   $0x803cb7
  802d41:	e8 88 d5 ff ff       	call   8002ce <_panic>
  802d46:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4f:	89 10                	mov    %edx,(%eax)
  802d51:	8b 45 08             	mov    0x8(%ebp),%eax
  802d54:	8b 00                	mov    (%eax),%eax
  802d56:	85 c0                	test   %eax,%eax
  802d58:	74 0d                	je     802d67 <insert_sorted_with_merge_freeList+0x4b9>
  802d5a:	a1 48 41 80 00       	mov    0x804148,%eax
  802d5f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d62:	89 50 04             	mov    %edx,0x4(%eax)
  802d65:	eb 08                	jmp    802d6f <insert_sorted_with_merge_freeList+0x4c1>
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d72:	a3 48 41 80 00       	mov    %eax,0x804148
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d81:	a1 54 41 80 00       	mov    0x804154,%eax
  802d86:	40                   	inc    %eax
  802d87:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d8c:	e9 f2 02 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	8b 50 08             	mov    0x8(%eax),%edx
  802d97:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9d:	01 c2                	add    %eax,%edx
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	8b 40 08             	mov    0x8(%eax),%eax
  802da5:	39 c2                	cmp    %eax,%edx
  802da7:	0f 85 be 00 00 00    	jne    802e6b <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db0:	8b 40 04             	mov    0x4(%eax),%eax
  802db3:	8b 50 08             	mov    0x8(%eax),%edx
  802db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db9:	8b 40 04             	mov    0x4(%eax),%eax
  802dbc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dbf:	01 c2                	add    %eax,%edx
  802dc1:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc4:	8b 40 08             	mov    0x8(%eax),%eax
  802dc7:	39 c2                	cmp    %eax,%edx
  802dc9:	0f 84 9c 00 00 00    	je     802e6b <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	8b 50 08             	mov    0x8(%eax),%edx
  802dd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd8:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dde:	8b 50 0c             	mov    0xc(%eax),%edx
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	8b 40 0c             	mov    0xc(%eax),%eax
  802de7:	01 c2                	add    %eax,%edx
  802de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dec:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802def:	8b 45 08             	mov    0x8(%ebp),%eax
  802df2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802df9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e03:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e07:	75 17                	jne    802e20 <insert_sorted_with_merge_freeList+0x572>
  802e09:	83 ec 04             	sub    $0x4,%esp
  802e0c:	68 94 3c 80 00       	push   $0x803c94
  802e11:	68 26 01 00 00       	push   $0x126
  802e16:	68 b7 3c 80 00       	push   $0x803cb7
  802e1b:	e8 ae d4 ff ff       	call   8002ce <_panic>
  802e20:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e26:	8b 45 08             	mov    0x8(%ebp),%eax
  802e29:	89 10                	mov    %edx,(%eax)
  802e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2e:	8b 00                	mov    (%eax),%eax
  802e30:	85 c0                	test   %eax,%eax
  802e32:	74 0d                	je     802e41 <insert_sorted_with_merge_freeList+0x593>
  802e34:	a1 48 41 80 00       	mov    0x804148,%eax
  802e39:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3c:	89 50 04             	mov    %edx,0x4(%eax)
  802e3f:	eb 08                	jmp    802e49 <insert_sorted_with_merge_freeList+0x59b>
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e49:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4c:	a3 48 41 80 00       	mov    %eax,0x804148
  802e51:	8b 45 08             	mov    0x8(%ebp),%eax
  802e54:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5b:	a1 54 41 80 00       	mov    0x804154,%eax
  802e60:	40                   	inc    %eax
  802e61:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802e66:	e9 18 02 00 00       	jmp    803083 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802e6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6e:	8b 50 0c             	mov    0xc(%eax),%edx
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 40 08             	mov    0x8(%eax),%eax
  802e77:	01 c2                	add    %eax,%edx
  802e79:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7c:	8b 40 08             	mov    0x8(%eax),%eax
  802e7f:	39 c2                	cmp    %eax,%edx
  802e81:	0f 85 c4 01 00 00    	jne    80304b <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	8b 50 0c             	mov    0xc(%eax),%edx
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	8b 40 08             	mov    0x8(%eax),%eax
  802e93:	01 c2                	add    %eax,%edx
  802e95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e98:	8b 00                	mov    (%eax),%eax
  802e9a:	8b 40 08             	mov    0x8(%eax),%eax
  802e9d:	39 c2                	cmp    %eax,%edx
  802e9f:	0f 85 a6 01 00 00    	jne    80304b <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802ea5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ea9:	0f 84 9c 01 00 00    	je     80304b <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb2:	8b 50 0c             	mov    0xc(%eax),%edx
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebb:	01 c2                	add    %eax,%edx
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	8b 00                	mov    (%eax),%eax
  802ec2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec5:	01 c2                	add    %eax,%edx
  802ec7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eca:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802ecd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eda:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802ee1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee5:	75 17                	jne    802efe <insert_sorted_with_merge_freeList+0x650>
  802ee7:	83 ec 04             	sub    $0x4,%esp
  802eea:	68 94 3c 80 00       	push   $0x803c94
  802eef:	68 32 01 00 00       	push   $0x132
  802ef4:	68 b7 3c 80 00       	push   $0x803cb7
  802ef9:	e8 d0 d3 ff ff       	call   8002ce <_panic>
  802efe:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f04:	8b 45 08             	mov    0x8(%ebp),%eax
  802f07:	89 10                	mov    %edx,(%eax)
  802f09:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0c:	8b 00                	mov    (%eax),%eax
  802f0e:	85 c0                	test   %eax,%eax
  802f10:	74 0d                	je     802f1f <insert_sorted_with_merge_freeList+0x671>
  802f12:	a1 48 41 80 00       	mov    0x804148,%eax
  802f17:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1a:	89 50 04             	mov    %edx,0x4(%eax)
  802f1d:	eb 08                	jmp    802f27 <insert_sorted_with_merge_freeList+0x679>
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f27:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2a:	a3 48 41 80 00       	mov    %eax,0x804148
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f39:	a1 54 41 80 00       	mov    0x804154,%eax
  802f3e:	40                   	inc    %eax
  802f3f:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	8b 00                	mov    (%eax),%eax
  802f49:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f53:	8b 00                	mov    (%eax),%eax
  802f55:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802f5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5f:	8b 00                	mov    (%eax),%eax
  802f61:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802f64:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f68:	75 17                	jne    802f81 <insert_sorted_with_merge_freeList+0x6d3>
  802f6a:	83 ec 04             	sub    $0x4,%esp
  802f6d:	68 29 3d 80 00       	push   $0x803d29
  802f72:	68 36 01 00 00       	push   $0x136
  802f77:	68 b7 3c 80 00       	push   $0x803cb7
  802f7c:	e8 4d d3 ff ff       	call   8002ce <_panic>
  802f81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f84:	8b 00                	mov    (%eax),%eax
  802f86:	85 c0                	test   %eax,%eax
  802f88:	74 10                	je     802f9a <insert_sorted_with_merge_freeList+0x6ec>
  802f8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f8d:	8b 00                	mov    (%eax),%eax
  802f8f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f92:	8b 52 04             	mov    0x4(%edx),%edx
  802f95:	89 50 04             	mov    %edx,0x4(%eax)
  802f98:	eb 0b                	jmp    802fa5 <insert_sorted_with_merge_freeList+0x6f7>
  802f9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9d:	8b 40 04             	mov    0x4(%eax),%eax
  802fa0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa8:	8b 40 04             	mov    0x4(%eax),%eax
  802fab:	85 c0                	test   %eax,%eax
  802fad:	74 0f                	je     802fbe <insert_sorted_with_merge_freeList+0x710>
  802faf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb2:	8b 40 04             	mov    0x4(%eax),%eax
  802fb5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fb8:	8b 12                	mov    (%edx),%edx
  802fba:	89 10                	mov    %edx,(%eax)
  802fbc:	eb 0a                	jmp    802fc8 <insert_sorted_with_merge_freeList+0x71a>
  802fbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc1:	8b 00                	mov    (%eax),%eax
  802fc3:	a3 38 41 80 00       	mov    %eax,0x804138
  802fc8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fcb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fdb:	a1 44 41 80 00       	mov    0x804144,%eax
  802fe0:	48                   	dec    %eax
  802fe1:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  802fe6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fea:	75 17                	jne    803003 <insert_sorted_with_merge_freeList+0x755>
  802fec:	83 ec 04             	sub    $0x4,%esp
  802fef:	68 94 3c 80 00       	push   $0x803c94
  802ff4:	68 37 01 00 00       	push   $0x137
  802ff9:	68 b7 3c 80 00       	push   $0x803cb7
  802ffe:	e8 cb d2 ff ff       	call   8002ce <_panic>
  803003:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803009:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80300c:	89 10                	mov    %edx,(%eax)
  80300e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803011:	8b 00                	mov    (%eax),%eax
  803013:	85 c0                	test   %eax,%eax
  803015:	74 0d                	je     803024 <insert_sorted_with_merge_freeList+0x776>
  803017:	a1 48 41 80 00       	mov    0x804148,%eax
  80301c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80301f:	89 50 04             	mov    %edx,0x4(%eax)
  803022:	eb 08                	jmp    80302c <insert_sorted_with_merge_freeList+0x77e>
  803024:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803027:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80302c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302f:	a3 48 41 80 00       	mov    %eax,0x804148
  803034:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803037:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80303e:	a1 54 41 80 00       	mov    0x804154,%eax
  803043:	40                   	inc    %eax
  803044:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  803049:	eb 38                	jmp    803083 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80304b:	a1 40 41 80 00       	mov    0x804140,%eax
  803050:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803053:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803057:	74 07                	je     803060 <insert_sorted_with_merge_freeList+0x7b2>
  803059:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	eb 05                	jmp    803065 <insert_sorted_with_merge_freeList+0x7b7>
  803060:	b8 00 00 00 00       	mov    $0x0,%eax
  803065:	a3 40 41 80 00       	mov    %eax,0x804140
  80306a:	a1 40 41 80 00       	mov    0x804140,%eax
  80306f:	85 c0                	test   %eax,%eax
  803071:	0f 85 ef f9 ff ff    	jne    802a66 <insert_sorted_with_merge_freeList+0x1b8>
  803077:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307b:	0f 85 e5 f9 ff ff    	jne    802a66 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803081:	eb 00                	jmp    803083 <insert_sorted_with_merge_freeList+0x7d5>
  803083:	90                   	nop
  803084:	c9                   	leave  
  803085:	c3                   	ret    

00803086 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803086:	55                   	push   %ebp
  803087:	89 e5                	mov    %esp,%ebp
  803089:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80308c:	8b 55 08             	mov    0x8(%ebp),%edx
  80308f:	89 d0                	mov    %edx,%eax
  803091:	c1 e0 02             	shl    $0x2,%eax
  803094:	01 d0                	add    %edx,%eax
  803096:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80309d:	01 d0                	add    %edx,%eax
  80309f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030a6:	01 d0                	add    %edx,%eax
  8030a8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030af:	01 d0                	add    %edx,%eax
  8030b1:	c1 e0 04             	shl    $0x4,%eax
  8030b4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8030b7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030be:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030c1:	83 ec 0c             	sub    $0xc,%esp
  8030c4:	50                   	push   %eax
  8030c5:	e8 21 ec ff ff       	call   801ceb <sys_get_virtual_time>
  8030ca:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030cd:	eb 41                	jmp    803110 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030cf:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030d2:	83 ec 0c             	sub    $0xc,%esp
  8030d5:	50                   	push   %eax
  8030d6:	e8 10 ec ff ff       	call   801ceb <sys_get_virtual_time>
  8030db:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030de:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e4:	29 c2                	sub    %eax,%edx
  8030e6:	89 d0                	mov    %edx,%eax
  8030e8:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f1:	89 d1                	mov    %edx,%ecx
  8030f3:	29 c1                	sub    %eax,%ecx
  8030f5:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030f8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030fb:	39 c2                	cmp    %eax,%edx
  8030fd:	0f 97 c0             	seta   %al
  803100:	0f b6 c0             	movzbl %al,%eax
  803103:	29 c1                	sub    %eax,%ecx
  803105:	89 c8                	mov    %ecx,%eax
  803107:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80310a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80310d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803110:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803113:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803116:	72 b7                	jb     8030cf <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803118:	90                   	nop
  803119:	c9                   	leave  
  80311a:	c3                   	ret    

0080311b <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80311b:	55                   	push   %ebp
  80311c:	89 e5                	mov    %esp,%ebp
  80311e:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803121:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803128:	eb 03                	jmp    80312d <busy_wait+0x12>
  80312a:	ff 45 fc             	incl   -0x4(%ebp)
  80312d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803130:	3b 45 08             	cmp    0x8(%ebp),%eax
  803133:	72 f5                	jb     80312a <busy_wait+0xf>
	return i;
  803135:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803138:	c9                   	leave  
  803139:	c3                   	ret    
  80313a:	66 90                	xchg   %ax,%ax

0080313c <__udivdi3>:
  80313c:	55                   	push   %ebp
  80313d:	57                   	push   %edi
  80313e:	56                   	push   %esi
  80313f:	53                   	push   %ebx
  803140:	83 ec 1c             	sub    $0x1c,%esp
  803143:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803147:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80314b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80314f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803153:	89 ca                	mov    %ecx,%edx
  803155:	89 f8                	mov    %edi,%eax
  803157:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80315b:	85 f6                	test   %esi,%esi
  80315d:	75 2d                	jne    80318c <__udivdi3+0x50>
  80315f:	39 cf                	cmp    %ecx,%edi
  803161:	77 65                	ja     8031c8 <__udivdi3+0x8c>
  803163:	89 fd                	mov    %edi,%ebp
  803165:	85 ff                	test   %edi,%edi
  803167:	75 0b                	jne    803174 <__udivdi3+0x38>
  803169:	b8 01 00 00 00       	mov    $0x1,%eax
  80316e:	31 d2                	xor    %edx,%edx
  803170:	f7 f7                	div    %edi
  803172:	89 c5                	mov    %eax,%ebp
  803174:	31 d2                	xor    %edx,%edx
  803176:	89 c8                	mov    %ecx,%eax
  803178:	f7 f5                	div    %ebp
  80317a:	89 c1                	mov    %eax,%ecx
  80317c:	89 d8                	mov    %ebx,%eax
  80317e:	f7 f5                	div    %ebp
  803180:	89 cf                	mov    %ecx,%edi
  803182:	89 fa                	mov    %edi,%edx
  803184:	83 c4 1c             	add    $0x1c,%esp
  803187:	5b                   	pop    %ebx
  803188:	5e                   	pop    %esi
  803189:	5f                   	pop    %edi
  80318a:	5d                   	pop    %ebp
  80318b:	c3                   	ret    
  80318c:	39 ce                	cmp    %ecx,%esi
  80318e:	77 28                	ja     8031b8 <__udivdi3+0x7c>
  803190:	0f bd fe             	bsr    %esi,%edi
  803193:	83 f7 1f             	xor    $0x1f,%edi
  803196:	75 40                	jne    8031d8 <__udivdi3+0x9c>
  803198:	39 ce                	cmp    %ecx,%esi
  80319a:	72 0a                	jb     8031a6 <__udivdi3+0x6a>
  80319c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031a0:	0f 87 9e 00 00 00    	ja     803244 <__udivdi3+0x108>
  8031a6:	b8 01 00 00 00       	mov    $0x1,%eax
  8031ab:	89 fa                	mov    %edi,%edx
  8031ad:	83 c4 1c             	add    $0x1c,%esp
  8031b0:	5b                   	pop    %ebx
  8031b1:	5e                   	pop    %esi
  8031b2:	5f                   	pop    %edi
  8031b3:	5d                   	pop    %ebp
  8031b4:	c3                   	ret    
  8031b5:	8d 76 00             	lea    0x0(%esi),%esi
  8031b8:	31 ff                	xor    %edi,%edi
  8031ba:	31 c0                	xor    %eax,%eax
  8031bc:	89 fa                	mov    %edi,%edx
  8031be:	83 c4 1c             	add    $0x1c,%esp
  8031c1:	5b                   	pop    %ebx
  8031c2:	5e                   	pop    %esi
  8031c3:	5f                   	pop    %edi
  8031c4:	5d                   	pop    %ebp
  8031c5:	c3                   	ret    
  8031c6:	66 90                	xchg   %ax,%ax
  8031c8:	89 d8                	mov    %ebx,%eax
  8031ca:	f7 f7                	div    %edi
  8031cc:	31 ff                	xor    %edi,%edi
  8031ce:	89 fa                	mov    %edi,%edx
  8031d0:	83 c4 1c             	add    $0x1c,%esp
  8031d3:	5b                   	pop    %ebx
  8031d4:	5e                   	pop    %esi
  8031d5:	5f                   	pop    %edi
  8031d6:	5d                   	pop    %ebp
  8031d7:	c3                   	ret    
  8031d8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031dd:	89 eb                	mov    %ebp,%ebx
  8031df:	29 fb                	sub    %edi,%ebx
  8031e1:	89 f9                	mov    %edi,%ecx
  8031e3:	d3 e6                	shl    %cl,%esi
  8031e5:	89 c5                	mov    %eax,%ebp
  8031e7:	88 d9                	mov    %bl,%cl
  8031e9:	d3 ed                	shr    %cl,%ebp
  8031eb:	89 e9                	mov    %ebp,%ecx
  8031ed:	09 f1                	or     %esi,%ecx
  8031ef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031f3:	89 f9                	mov    %edi,%ecx
  8031f5:	d3 e0                	shl    %cl,%eax
  8031f7:	89 c5                	mov    %eax,%ebp
  8031f9:	89 d6                	mov    %edx,%esi
  8031fb:	88 d9                	mov    %bl,%cl
  8031fd:	d3 ee                	shr    %cl,%esi
  8031ff:	89 f9                	mov    %edi,%ecx
  803201:	d3 e2                	shl    %cl,%edx
  803203:	8b 44 24 08          	mov    0x8(%esp),%eax
  803207:	88 d9                	mov    %bl,%cl
  803209:	d3 e8                	shr    %cl,%eax
  80320b:	09 c2                	or     %eax,%edx
  80320d:	89 d0                	mov    %edx,%eax
  80320f:	89 f2                	mov    %esi,%edx
  803211:	f7 74 24 0c          	divl   0xc(%esp)
  803215:	89 d6                	mov    %edx,%esi
  803217:	89 c3                	mov    %eax,%ebx
  803219:	f7 e5                	mul    %ebp
  80321b:	39 d6                	cmp    %edx,%esi
  80321d:	72 19                	jb     803238 <__udivdi3+0xfc>
  80321f:	74 0b                	je     80322c <__udivdi3+0xf0>
  803221:	89 d8                	mov    %ebx,%eax
  803223:	31 ff                	xor    %edi,%edi
  803225:	e9 58 ff ff ff       	jmp    803182 <__udivdi3+0x46>
  80322a:	66 90                	xchg   %ax,%ax
  80322c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803230:	89 f9                	mov    %edi,%ecx
  803232:	d3 e2                	shl    %cl,%edx
  803234:	39 c2                	cmp    %eax,%edx
  803236:	73 e9                	jae    803221 <__udivdi3+0xe5>
  803238:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80323b:	31 ff                	xor    %edi,%edi
  80323d:	e9 40 ff ff ff       	jmp    803182 <__udivdi3+0x46>
  803242:	66 90                	xchg   %ax,%ax
  803244:	31 c0                	xor    %eax,%eax
  803246:	e9 37 ff ff ff       	jmp    803182 <__udivdi3+0x46>
  80324b:	90                   	nop

0080324c <__umoddi3>:
  80324c:	55                   	push   %ebp
  80324d:	57                   	push   %edi
  80324e:	56                   	push   %esi
  80324f:	53                   	push   %ebx
  803250:	83 ec 1c             	sub    $0x1c,%esp
  803253:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803257:	8b 74 24 34          	mov    0x34(%esp),%esi
  80325b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80325f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803263:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803267:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80326b:	89 f3                	mov    %esi,%ebx
  80326d:	89 fa                	mov    %edi,%edx
  80326f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803273:	89 34 24             	mov    %esi,(%esp)
  803276:	85 c0                	test   %eax,%eax
  803278:	75 1a                	jne    803294 <__umoddi3+0x48>
  80327a:	39 f7                	cmp    %esi,%edi
  80327c:	0f 86 a2 00 00 00    	jbe    803324 <__umoddi3+0xd8>
  803282:	89 c8                	mov    %ecx,%eax
  803284:	89 f2                	mov    %esi,%edx
  803286:	f7 f7                	div    %edi
  803288:	89 d0                	mov    %edx,%eax
  80328a:	31 d2                	xor    %edx,%edx
  80328c:	83 c4 1c             	add    $0x1c,%esp
  80328f:	5b                   	pop    %ebx
  803290:	5e                   	pop    %esi
  803291:	5f                   	pop    %edi
  803292:	5d                   	pop    %ebp
  803293:	c3                   	ret    
  803294:	39 f0                	cmp    %esi,%eax
  803296:	0f 87 ac 00 00 00    	ja     803348 <__umoddi3+0xfc>
  80329c:	0f bd e8             	bsr    %eax,%ebp
  80329f:	83 f5 1f             	xor    $0x1f,%ebp
  8032a2:	0f 84 ac 00 00 00    	je     803354 <__umoddi3+0x108>
  8032a8:	bf 20 00 00 00       	mov    $0x20,%edi
  8032ad:	29 ef                	sub    %ebp,%edi
  8032af:	89 fe                	mov    %edi,%esi
  8032b1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032b5:	89 e9                	mov    %ebp,%ecx
  8032b7:	d3 e0                	shl    %cl,%eax
  8032b9:	89 d7                	mov    %edx,%edi
  8032bb:	89 f1                	mov    %esi,%ecx
  8032bd:	d3 ef                	shr    %cl,%edi
  8032bf:	09 c7                	or     %eax,%edi
  8032c1:	89 e9                	mov    %ebp,%ecx
  8032c3:	d3 e2                	shl    %cl,%edx
  8032c5:	89 14 24             	mov    %edx,(%esp)
  8032c8:	89 d8                	mov    %ebx,%eax
  8032ca:	d3 e0                	shl    %cl,%eax
  8032cc:	89 c2                	mov    %eax,%edx
  8032ce:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032d2:	d3 e0                	shl    %cl,%eax
  8032d4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032d8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032dc:	89 f1                	mov    %esi,%ecx
  8032de:	d3 e8                	shr    %cl,%eax
  8032e0:	09 d0                	or     %edx,%eax
  8032e2:	d3 eb                	shr    %cl,%ebx
  8032e4:	89 da                	mov    %ebx,%edx
  8032e6:	f7 f7                	div    %edi
  8032e8:	89 d3                	mov    %edx,%ebx
  8032ea:	f7 24 24             	mull   (%esp)
  8032ed:	89 c6                	mov    %eax,%esi
  8032ef:	89 d1                	mov    %edx,%ecx
  8032f1:	39 d3                	cmp    %edx,%ebx
  8032f3:	0f 82 87 00 00 00    	jb     803380 <__umoddi3+0x134>
  8032f9:	0f 84 91 00 00 00    	je     803390 <__umoddi3+0x144>
  8032ff:	8b 54 24 04          	mov    0x4(%esp),%edx
  803303:	29 f2                	sub    %esi,%edx
  803305:	19 cb                	sbb    %ecx,%ebx
  803307:	89 d8                	mov    %ebx,%eax
  803309:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80330d:	d3 e0                	shl    %cl,%eax
  80330f:	89 e9                	mov    %ebp,%ecx
  803311:	d3 ea                	shr    %cl,%edx
  803313:	09 d0                	or     %edx,%eax
  803315:	89 e9                	mov    %ebp,%ecx
  803317:	d3 eb                	shr    %cl,%ebx
  803319:	89 da                	mov    %ebx,%edx
  80331b:	83 c4 1c             	add    $0x1c,%esp
  80331e:	5b                   	pop    %ebx
  80331f:	5e                   	pop    %esi
  803320:	5f                   	pop    %edi
  803321:	5d                   	pop    %ebp
  803322:	c3                   	ret    
  803323:	90                   	nop
  803324:	89 fd                	mov    %edi,%ebp
  803326:	85 ff                	test   %edi,%edi
  803328:	75 0b                	jne    803335 <__umoddi3+0xe9>
  80332a:	b8 01 00 00 00       	mov    $0x1,%eax
  80332f:	31 d2                	xor    %edx,%edx
  803331:	f7 f7                	div    %edi
  803333:	89 c5                	mov    %eax,%ebp
  803335:	89 f0                	mov    %esi,%eax
  803337:	31 d2                	xor    %edx,%edx
  803339:	f7 f5                	div    %ebp
  80333b:	89 c8                	mov    %ecx,%eax
  80333d:	f7 f5                	div    %ebp
  80333f:	89 d0                	mov    %edx,%eax
  803341:	e9 44 ff ff ff       	jmp    80328a <__umoddi3+0x3e>
  803346:	66 90                	xchg   %ax,%ax
  803348:	89 c8                	mov    %ecx,%eax
  80334a:	89 f2                	mov    %esi,%edx
  80334c:	83 c4 1c             	add    $0x1c,%esp
  80334f:	5b                   	pop    %ebx
  803350:	5e                   	pop    %esi
  803351:	5f                   	pop    %edi
  803352:	5d                   	pop    %ebp
  803353:	c3                   	ret    
  803354:	3b 04 24             	cmp    (%esp),%eax
  803357:	72 06                	jb     80335f <__umoddi3+0x113>
  803359:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80335d:	77 0f                	ja     80336e <__umoddi3+0x122>
  80335f:	89 f2                	mov    %esi,%edx
  803361:	29 f9                	sub    %edi,%ecx
  803363:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803367:	89 14 24             	mov    %edx,(%esp)
  80336a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80336e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803372:	8b 14 24             	mov    (%esp),%edx
  803375:	83 c4 1c             	add    $0x1c,%esp
  803378:	5b                   	pop    %ebx
  803379:	5e                   	pop    %esi
  80337a:	5f                   	pop    %edi
  80337b:	5d                   	pop    %ebp
  80337c:	c3                   	ret    
  80337d:	8d 76 00             	lea    0x0(%esi),%esi
  803380:	2b 04 24             	sub    (%esp),%eax
  803383:	19 fa                	sbb    %edi,%edx
  803385:	89 d1                	mov    %edx,%ecx
  803387:	89 c6                	mov    %eax,%esi
  803389:	e9 71 ff ff ff       	jmp    8032ff <__umoddi3+0xb3>
  80338e:	66 90                	xchg   %ax,%ax
  803390:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803394:	72 ea                	jb     803380 <__umoddi3+0x134>
  803396:	89 d9                	mov    %ebx,%ecx
  803398:	e9 62 ff ff ff       	jmp    8032ff <__umoddi3+0xb3>
