
obj/user/tst_envfree3:     file format elf32-i386


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
  800031:	e8 5f 01 00 00       	call   800195 <libmain>
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
	// Testing scenario 3: Freeing the allocated shared variables [covers: smalloc (1 env) & sget (multiple envs)]
	// Testing removing the shared variables
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 c0 33 80 00       	push   $0x8033c0
  80004a:	e8 50 16 00 00       	call   80169f <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 5f 19 00 00       	call   8019c2 <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 f7 19 00 00       	call   801a62 <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 d0 33 80 00       	push   $0x8033d0
  800079:	e8 07 05 00 00       	call   800585 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr1", 2000,(myEnv->SecondListSize), 50);
  800081:	a1 20 40 80 00       	mov    0x804020,%eax
  800086:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80008c:	6a 32                	push   $0x32
  80008e:	50                   	push   %eax
  80008f:	68 d0 07 00 00       	push   $0x7d0
  800094:	68 03 34 80 00       	push   $0x803403
  800099:	e8 96 1b 00 00       	call   801c34 <sys_create_env>
  80009e:	83 c4 10             	add    $0x10,%esp
  8000a1:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr2", 2000,(myEnv->SecondListSize), 50);
  8000a4:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a9:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000af:	6a 32                	push   $0x32
  8000b1:	50                   	push   %eax
  8000b2:	68 d0 07 00 00       	push   $0x7d0
  8000b7:	68 0c 34 80 00       	push   $0x80340c
  8000bc:	e8 73 1b 00 00       	call   801c34 <sys_create_env>
  8000c1:	83 c4 10             	add    $0x10,%esp
  8000c4:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000c7:	83 ec 0c             	sub    $0xc,%esp
  8000ca:	ff 75 e8             	pushl  -0x18(%ebp)
  8000cd:	e8 80 1b 00 00       	call   801c52 <sys_run_env>
  8000d2:	83 c4 10             	add    $0x10,%esp
	env_sleep(5000) ;
  8000d5:	83 ec 0c             	sub    $0xc,%esp
  8000d8:	68 88 13 00 00       	push   $0x1388
  8000dd:	e8 a7 2f 00 00       	call   803089 <env_sleep>
  8000e2:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000e5:	83 ec 0c             	sub    $0xc,%esp
  8000e8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000eb:	e8 62 1b 00 00       	call   801c52 <sys_run_env>
  8000f0:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000f3:	90                   	nop
  8000f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000f7:	8b 00                	mov    (%eax),%eax
  8000f9:	83 f8 02             	cmp    $0x2,%eax
  8000fc:	75 f6                	jne    8000f4 <_main+0xbc>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000fe:	e8 bf 18 00 00       	call   8019c2 <sys_calculate_free_frames>
  800103:	83 ec 08             	sub    $0x8,%esp
  800106:	50                   	push   %eax
  800107:	68 18 34 80 00       	push   $0x803418
  80010c:	e8 74 04 00 00       	call   800585 <cprintf>
  800111:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	ff 75 e8             	pushl  -0x18(%ebp)
  80011a:	e8 4f 1b 00 00       	call   801c6e <sys_destroy_env>
  80011f:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  800122:	83 ec 0c             	sub    $0xc,%esp
  800125:	ff 75 e4             	pushl  -0x1c(%ebp)
  800128:	e8 41 1b 00 00       	call   801c6e <sys_destroy_env>
  80012d:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  800130:	e8 8d 18 00 00       	call   8019c2 <sys_calculate_free_frames>
  800135:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800138:	e8 25 19 00 00       	call   801a62 <sys_pf_calculate_allocated_pages>
  80013d:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  800140:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800143:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800146:	74 27                	je     80016f <_main+0x137>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	ff 75 e0             	pushl  -0x20(%ebp)
  80014e:	68 4c 34 80 00       	push   $0x80344c
  800153:	e8 2d 04 00 00       	call   800585 <cprintf>
  800158:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  80015b:	83 ec 04             	sub    $0x4,%esp
  80015e:	68 9c 34 80 00       	push   $0x80349c
  800163:	6a 23                	push   $0x23
  800165:	68 d2 34 80 00       	push   $0x8034d2
  80016a:	e8 62 01 00 00       	call   8002d1 <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80016f:	83 ec 08             	sub    $0x8,%esp
  800172:	ff 75 e0             	pushl  -0x20(%ebp)
  800175:	68 e8 34 80 00       	push   $0x8034e8
  80017a:	e8 06 04 00 00       	call   800585 <cprintf>
  80017f:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 3 for envfree completed successfully.\n");
  800182:	83 ec 0c             	sub    $0xc,%esp
  800185:	68 48 35 80 00       	push   $0x803548
  80018a:	e8 f6 03 00 00       	call   800585 <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp
	return;
  800192:	90                   	nop
}
  800193:	c9                   	leave  
  800194:	c3                   	ret    

00800195 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800195:	55                   	push   %ebp
  800196:	89 e5                	mov    %esp,%ebp
  800198:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80019b:	e8 02 1b 00 00       	call   801ca2 <sys_getenvindex>
  8001a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001a6:	89 d0                	mov    %edx,%eax
  8001a8:	c1 e0 03             	shl    $0x3,%eax
  8001ab:	01 d0                	add    %edx,%eax
  8001ad:	01 c0                	add    %eax,%eax
  8001af:	01 d0                	add    %edx,%eax
  8001b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001b8:	01 d0                	add    %edx,%eax
  8001ba:	c1 e0 04             	shl    $0x4,%eax
  8001bd:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001c2:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001c7:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cc:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001d2:	84 c0                	test   %al,%al
  8001d4:	74 0f                	je     8001e5 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001d6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001db:	05 5c 05 00 00       	add    $0x55c,%eax
  8001e0:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001e9:	7e 0a                	jle    8001f5 <libmain+0x60>
		binaryname = argv[0];
  8001eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ee:	8b 00                	mov    (%eax),%eax
  8001f0:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001f5:	83 ec 08             	sub    $0x8,%esp
  8001f8:	ff 75 0c             	pushl  0xc(%ebp)
  8001fb:	ff 75 08             	pushl  0x8(%ebp)
  8001fe:	e8 35 fe ff ff       	call   800038 <_main>
  800203:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800206:	e8 a4 18 00 00       	call   801aaf <sys_disable_interrupt>
	cprintf("**************************************\n");
  80020b:	83 ec 0c             	sub    $0xc,%esp
  80020e:	68 ac 35 80 00       	push   $0x8035ac
  800213:	e8 6d 03 00 00       	call   800585 <cprintf>
  800218:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80021b:	a1 20 40 80 00       	mov    0x804020,%eax
  800220:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800226:	a1 20 40 80 00       	mov    0x804020,%eax
  80022b:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800231:	83 ec 04             	sub    $0x4,%esp
  800234:	52                   	push   %edx
  800235:	50                   	push   %eax
  800236:	68 d4 35 80 00       	push   $0x8035d4
  80023b:	e8 45 03 00 00       	call   800585 <cprintf>
  800240:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800243:	a1 20 40 80 00       	mov    0x804020,%eax
  800248:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80024e:	a1 20 40 80 00       	mov    0x804020,%eax
  800253:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800259:	a1 20 40 80 00       	mov    0x804020,%eax
  80025e:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800264:	51                   	push   %ecx
  800265:	52                   	push   %edx
  800266:	50                   	push   %eax
  800267:	68 fc 35 80 00       	push   $0x8035fc
  80026c:	e8 14 03 00 00       	call   800585 <cprintf>
  800271:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800274:	a1 20 40 80 00       	mov    0x804020,%eax
  800279:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80027f:	83 ec 08             	sub    $0x8,%esp
  800282:	50                   	push   %eax
  800283:	68 54 36 80 00       	push   $0x803654
  800288:	e8 f8 02 00 00       	call   800585 <cprintf>
  80028d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800290:	83 ec 0c             	sub    $0xc,%esp
  800293:	68 ac 35 80 00       	push   $0x8035ac
  800298:	e8 e8 02 00 00       	call   800585 <cprintf>
  80029d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002a0:	e8 24 18 00 00       	call   801ac9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002a5:	e8 19 00 00 00       	call   8002c3 <exit>
}
  8002aa:	90                   	nop
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002b3:	83 ec 0c             	sub    $0xc,%esp
  8002b6:	6a 00                	push   $0x0
  8002b8:	e8 b1 19 00 00       	call   801c6e <sys_destroy_env>
  8002bd:	83 c4 10             	add    $0x10,%esp
}
  8002c0:	90                   	nop
  8002c1:	c9                   	leave  
  8002c2:	c3                   	ret    

008002c3 <exit>:

void
exit(void)
{
  8002c3:	55                   	push   %ebp
  8002c4:	89 e5                	mov    %esp,%ebp
  8002c6:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002c9:	e8 06 1a 00 00       	call   801cd4 <sys_exit_env>
}
  8002ce:	90                   	nop
  8002cf:	c9                   	leave  
  8002d0:	c3                   	ret    

008002d1 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002d1:	55                   	push   %ebp
  8002d2:	89 e5                	mov    %esp,%ebp
  8002d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8002da:	83 c0 04             	add    $0x4,%eax
  8002dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002e0:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002e5:	85 c0                	test   %eax,%eax
  8002e7:	74 16                	je     8002ff <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002e9:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ee:	83 ec 08             	sub    $0x8,%esp
  8002f1:	50                   	push   %eax
  8002f2:	68 68 36 80 00       	push   $0x803668
  8002f7:	e8 89 02 00 00       	call   800585 <cprintf>
  8002fc:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002ff:	a1 00 40 80 00       	mov    0x804000,%eax
  800304:	ff 75 0c             	pushl  0xc(%ebp)
  800307:	ff 75 08             	pushl  0x8(%ebp)
  80030a:	50                   	push   %eax
  80030b:	68 6d 36 80 00       	push   $0x80366d
  800310:	e8 70 02 00 00       	call   800585 <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800318:	8b 45 10             	mov    0x10(%ebp),%eax
  80031b:	83 ec 08             	sub    $0x8,%esp
  80031e:	ff 75 f4             	pushl  -0xc(%ebp)
  800321:	50                   	push   %eax
  800322:	e8 f3 01 00 00       	call   80051a <vcprintf>
  800327:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80032a:	83 ec 08             	sub    $0x8,%esp
  80032d:	6a 00                	push   $0x0
  80032f:	68 89 36 80 00       	push   $0x803689
  800334:	e8 e1 01 00 00       	call   80051a <vcprintf>
  800339:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80033c:	e8 82 ff ff ff       	call   8002c3 <exit>

	// should not return here
	while (1) ;
  800341:	eb fe                	jmp    800341 <_panic+0x70>

00800343 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800343:	55                   	push   %ebp
  800344:	89 e5                	mov    %esp,%ebp
  800346:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800349:	a1 20 40 80 00       	mov    0x804020,%eax
  80034e:	8b 50 74             	mov    0x74(%eax),%edx
  800351:	8b 45 0c             	mov    0xc(%ebp),%eax
  800354:	39 c2                	cmp    %eax,%edx
  800356:	74 14                	je     80036c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800358:	83 ec 04             	sub    $0x4,%esp
  80035b:	68 8c 36 80 00       	push   $0x80368c
  800360:	6a 26                	push   $0x26
  800362:	68 d8 36 80 00       	push   $0x8036d8
  800367:	e8 65 ff ff ff       	call   8002d1 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80036c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800373:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80037a:	e9 c2 00 00 00       	jmp    800441 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80037f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800382:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800389:	8b 45 08             	mov    0x8(%ebp),%eax
  80038c:	01 d0                	add    %edx,%eax
  80038e:	8b 00                	mov    (%eax),%eax
  800390:	85 c0                	test   %eax,%eax
  800392:	75 08                	jne    80039c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800394:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800397:	e9 a2 00 00 00       	jmp    80043e <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80039c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003a3:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003aa:	eb 69                	jmp    800415 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003b7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003ba:	89 d0                	mov    %edx,%eax
  8003bc:	01 c0                	add    %eax,%eax
  8003be:	01 d0                	add    %edx,%eax
  8003c0:	c1 e0 03             	shl    $0x3,%eax
  8003c3:	01 c8                	add    %ecx,%eax
  8003c5:	8a 40 04             	mov    0x4(%eax),%al
  8003c8:	84 c0                	test   %al,%al
  8003ca:	75 46                	jne    800412 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d1:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003d7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003da:	89 d0                	mov    %edx,%eax
  8003dc:	01 c0                	add    %eax,%eax
  8003de:	01 d0                	add    %edx,%eax
  8003e0:	c1 e0 03             	shl    $0x3,%eax
  8003e3:	01 c8                	add    %ecx,%eax
  8003e5:	8b 00                	mov    (%eax),%eax
  8003e7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003ea:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003f2:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f7:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800401:	01 c8                	add    %ecx,%eax
  800403:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800405:	39 c2                	cmp    %eax,%edx
  800407:	75 09                	jne    800412 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800409:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800410:	eb 12                	jmp    800424 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800412:	ff 45 e8             	incl   -0x18(%ebp)
  800415:	a1 20 40 80 00       	mov    0x804020,%eax
  80041a:	8b 50 74             	mov    0x74(%eax),%edx
  80041d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800420:	39 c2                	cmp    %eax,%edx
  800422:	77 88                	ja     8003ac <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800424:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800428:	75 14                	jne    80043e <CheckWSWithoutLastIndex+0xfb>
			panic(
  80042a:	83 ec 04             	sub    $0x4,%esp
  80042d:	68 e4 36 80 00       	push   $0x8036e4
  800432:	6a 3a                	push   $0x3a
  800434:	68 d8 36 80 00       	push   $0x8036d8
  800439:	e8 93 fe ff ff       	call   8002d1 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80043e:	ff 45 f0             	incl   -0x10(%ebp)
  800441:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800444:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800447:	0f 8c 32 ff ff ff    	jl     80037f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80044d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800454:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80045b:	eb 26                	jmp    800483 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80045d:	a1 20 40 80 00       	mov    0x804020,%eax
  800462:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800468:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80046b:	89 d0                	mov    %edx,%eax
  80046d:	01 c0                	add    %eax,%eax
  80046f:	01 d0                	add    %edx,%eax
  800471:	c1 e0 03             	shl    $0x3,%eax
  800474:	01 c8                	add    %ecx,%eax
  800476:	8a 40 04             	mov    0x4(%eax),%al
  800479:	3c 01                	cmp    $0x1,%al
  80047b:	75 03                	jne    800480 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80047d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800480:	ff 45 e0             	incl   -0x20(%ebp)
  800483:	a1 20 40 80 00       	mov    0x804020,%eax
  800488:	8b 50 74             	mov    0x74(%eax),%edx
  80048b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80048e:	39 c2                	cmp    %eax,%edx
  800490:	77 cb                	ja     80045d <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800492:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800495:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800498:	74 14                	je     8004ae <CheckWSWithoutLastIndex+0x16b>
		panic(
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 38 37 80 00       	push   $0x803738
  8004a2:	6a 44                	push   $0x44
  8004a4:	68 d8 36 80 00       	push   $0x8036d8
  8004a9:	e8 23 fe ff ff       	call   8002d1 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004ae:	90                   	nop
  8004af:	c9                   	leave  
  8004b0:	c3                   	ret    

008004b1 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004b1:	55                   	push   %ebp
  8004b2:	89 e5                	mov    %esp,%ebp
  8004b4:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	8b 00                	mov    (%eax),%eax
  8004bc:	8d 48 01             	lea    0x1(%eax),%ecx
  8004bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c2:	89 0a                	mov    %ecx,(%edx)
  8004c4:	8b 55 08             	mov    0x8(%ebp),%edx
  8004c7:	88 d1                	mov    %dl,%cl
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	8b 00                	mov    (%eax),%eax
  8004d5:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004da:	75 2c                	jne    800508 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004dc:	a0 24 40 80 00       	mov    0x804024,%al
  8004e1:	0f b6 c0             	movzbl %al,%eax
  8004e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e7:	8b 12                	mov    (%edx),%edx
  8004e9:	89 d1                	mov    %edx,%ecx
  8004eb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ee:	83 c2 08             	add    $0x8,%edx
  8004f1:	83 ec 04             	sub    $0x4,%esp
  8004f4:	50                   	push   %eax
  8004f5:	51                   	push   %ecx
  8004f6:	52                   	push   %edx
  8004f7:	e8 05 14 00 00       	call   801901 <sys_cputs>
  8004fc:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800502:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050b:	8b 40 04             	mov    0x4(%eax),%eax
  80050e:	8d 50 01             	lea    0x1(%eax),%edx
  800511:	8b 45 0c             	mov    0xc(%ebp),%eax
  800514:	89 50 04             	mov    %edx,0x4(%eax)
}
  800517:	90                   	nop
  800518:	c9                   	leave  
  800519:	c3                   	ret    

0080051a <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80051a:	55                   	push   %ebp
  80051b:	89 e5                	mov    %esp,%ebp
  80051d:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800523:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80052a:	00 00 00 
	b.cnt = 0;
  80052d:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800534:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800537:	ff 75 0c             	pushl  0xc(%ebp)
  80053a:	ff 75 08             	pushl  0x8(%ebp)
  80053d:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800543:	50                   	push   %eax
  800544:	68 b1 04 80 00       	push   $0x8004b1
  800549:	e8 11 02 00 00       	call   80075f <vprintfmt>
  80054e:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800551:	a0 24 40 80 00       	mov    0x804024,%al
  800556:	0f b6 c0             	movzbl %al,%eax
  800559:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80055f:	83 ec 04             	sub    $0x4,%esp
  800562:	50                   	push   %eax
  800563:	52                   	push   %edx
  800564:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80056a:	83 c0 08             	add    $0x8,%eax
  80056d:	50                   	push   %eax
  80056e:	e8 8e 13 00 00       	call   801901 <sys_cputs>
  800573:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800576:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80057d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800583:	c9                   	leave  
  800584:	c3                   	ret    

00800585 <cprintf>:

int cprintf(const char *fmt, ...) {
  800585:	55                   	push   %ebp
  800586:	89 e5                	mov    %esp,%ebp
  800588:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80058b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800592:	8d 45 0c             	lea    0xc(%ebp),%eax
  800595:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800598:	8b 45 08             	mov    0x8(%ebp),%eax
  80059b:	83 ec 08             	sub    $0x8,%esp
  80059e:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a1:	50                   	push   %eax
  8005a2:	e8 73 ff ff ff       	call   80051a <vcprintf>
  8005a7:	83 c4 10             	add    $0x10,%esp
  8005aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005b0:	c9                   	leave  
  8005b1:	c3                   	ret    

008005b2 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005b2:	55                   	push   %ebp
  8005b3:	89 e5                	mov    %esp,%ebp
  8005b5:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005b8:	e8 f2 14 00 00       	call   801aaf <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005bd:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005c0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c6:	83 ec 08             	sub    $0x8,%esp
  8005c9:	ff 75 f4             	pushl  -0xc(%ebp)
  8005cc:	50                   	push   %eax
  8005cd:	e8 48 ff ff ff       	call   80051a <vcprintf>
  8005d2:	83 c4 10             	add    $0x10,%esp
  8005d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005d8:	e8 ec 14 00 00       	call   801ac9 <sys_enable_interrupt>
	return cnt;
  8005dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005e0:	c9                   	leave  
  8005e1:	c3                   	ret    

008005e2 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	53                   	push   %ebx
  8005e6:	83 ec 14             	sub    $0x14,%esp
  8005e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ef:	8b 45 14             	mov    0x14(%ebp),%eax
  8005f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005f5:	8b 45 18             	mov    0x18(%ebp),%eax
  8005f8:	ba 00 00 00 00       	mov    $0x0,%edx
  8005fd:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800600:	77 55                	ja     800657 <printnum+0x75>
  800602:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800605:	72 05                	jb     80060c <printnum+0x2a>
  800607:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80060a:	77 4b                	ja     800657 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  80060c:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80060f:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800612:	8b 45 18             	mov    0x18(%ebp),%eax
  800615:	ba 00 00 00 00       	mov    $0x0,%edx
  80061a:	52                   	push   %edx
  80061b:	50                   	push   %eax
  80061c:	ff 75 f4             	pushl  -0xc(%ebp)
  80061f:	ff 75 f0             	pushl  -0x10(%ebp)
  800622:	e8 19 2b 00 00       	call   803140 <__udivdi3>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	83 ec 04             	sub    $0x4,%esp
  80062d:	ff 75 20             	pushl  0x20(%ebp)
  800630:	53                   	push   %ebx
  800631:	ff 75 18             	pushl  0x18(%ebp)
  800634:	52                   	push   %edx
  800635:	50                   	push   %eax
  800636:	ff 75 0c             	pushl  0xc(%ebp)
  800639:	ff 75 08             	pushl  0x8(%ebp)
  80063c:	e8 a1 ff ff ff       	call   8005e2 <printnum>
  800641:	83 c4 20             	add    $0x20,%esp
  800644:	eb 1a                	jmp    800660 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	ff 75 20             	pushl  0x20(%ebp)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	ff d0                	call   *%eax
  800654:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800657:	ff 4d 1c             	decl   0x1c(%ebp)
  80065a:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80065e:	7f e6                	jg     800646 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800660:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800663:	bb 00 00 00 00       	mov    $0x0,%ebx
  800668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80066b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80066e:	53                   	push   %ebx
  80066f:	51                   	push   %ecx
  800670:	52                   	push   %edx
  800671:	50                   	push   %eax
  800672:	e8 d9 2b 00 00       	call   803250 <__umoddi3>
  800677:	83 c4 10             	add    $0x10,%esp
  80067a:	05 b4 39 80 00       	add    $0x8039b4,%eax
  80067f:	8a 00                	mov    (%eax),%al
  800681:	0f be c0             	movsbl %al,%eax
  800684:	83 ec 08             	sub    $0x8,%esp
  800687:	ff 75 0c             	pushl  0xc(%ebp)
  80068a:	50                   	push   %eax
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	ff d0                	call   *%eax
  800690:	83 c4 10             	add    $0x10,%esp
}
  800693:	90                   	nop
  800694:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800697:	c9                   	leave  
  800698:	c3                   	ret    

00800699 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800699:	55                   	push   %ebp
  80069a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80069c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a0:	7e 1c                	jle    8006be <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a5:	8b 00                	mov    (%eax),%eax
  8006a7:	8d 50 08             	lea    0x8(%eax),%edx
  8006aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ad:	89 10                	mov    %edx,(%eax)
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	83 e8 08             	sub    $0x8,%eax
  8006b7:	8b 50 04             	mov    0x4(%eax),%edx
  8006ba:	8b 00                	mov    (%eax),%eax
  8006bc:	eb 40                	jmp    8006fe <getuint+0x65>
	else if (lflag)
  8006be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c2:	74 1e                	je     8006e2 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	8d 50 04             	lea    0x4(%eax),%edx
  8006cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cf:	89 10                	mov    %edx,(%eax)
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	83 e8 04             	sub    $0x4,%eax
  8006d9:	8b 00                	mov    (%eax),%eax
  8006db:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e0:	eb 1c                	jmp    8006fe <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e5:	8b 00                	mov    (%eax),%eax
  8006e7:	8d 50 04             	lea    0x4(%eax),%edx
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	89 10                	mov    %edx,(%eax)
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	8b 00                	mov    (%eax),%eax
  8006f4:	83 e8 04             	sub    $0x4,%eax
  8006f7:	8b 00                	mov    (%eax),%eax
  8006f9:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006fe:	5d                   	pop    %ebp
  8006ff:	c3                   	ret    

00800700 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800700:	55                   	push   %ebp
  800701:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800703:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800707:	7e 1c                	jle    800725 <getint+0x25>
		return va_arg(*ap, long long);
  800709:	8b 45 08             	mov    0x8(%ebp),%eax
  80070c:	8b 00                	mov    (%eax),%eax
  80070e:	8d 50 08             	lea    0x8(%eax),%edx
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	89 10                	mov    %edx,(%eax)
  800716:	8b 45 08             	mov    0x8(%ebp),%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	83 e8 08             	sub    $0x8,%eax
  80071e:	8b 50 04             	mov    0x4(%eax),%edx
  800721:	8b 00                	mov    (%eax),%eax
  800723:	eb 38                	jmp    80075d <getint+0x5d>
	else if (lflag)
  800725:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800729:	74 1a                	je     800745 <getint+0x45>
		return va_arg(*ap, long);
  80072b:	8b 45 08             	mov    0x8(%ebp),%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	8d 50 04             	lea    0x4(%eax),%edx
  800733:	8b 45 08             	mov    0x8(%ebp),%eax
  800736:	89 10                	mov    %edx,(%eax)
  800738:	8b 45 08             	mov    0x8(%ebp),%eax
  80073b:	8b 00                	mov    (%eax),%eax
  80073d:	83 e8 04             	sub    $0x4,%eax
  800740:	8b 00                	mov    (%eax),%eax
  800742:	99                   	cltd   
  800743:	eb 18                	jmp    80075d <getint+0x5d>
	else
		return va_arg(*ap, int);
  800745:	8b 45 08             	mov    0x8(%ebp),%eax
  800748:	8b 00                	mov    (%eax),%eax
  80074a:	8d 50 04             	lea    0x4(%eax),%edx
  80074d:	8b 45 08             	mov    0x8(%ebp),%eax
  800750:	89 10                	mov    %edx,(%eax)
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	8b 00                	mov    (%eax),%eax
  800757:	83 e8 04             	sub    $0x4,%eax
  80075a:	8b 00                	mov    (%eax),%eax
  80075c:	99                   	cltd   
}
  80075d:	5d                   	pop    %ebp
  80075e:	c3                   	ret    

0080075f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80075f:	55                   	push   %ebp
  800760:	89 e5                	mov    %esp,%ebp
  800762:	56                   	push   %esi
  800763:	53                   	push   %ebx
  800764:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800767:	eb 17                	jmp    800780 <vprintfmt+0x21>
			if (ch == '\0')
  800769:	85 db                	test   %ebx,%ebx
  80076b:	0f 84 af 03 00 00    	je     800b20 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800771:	83 ec 08             	sub    $0x8,%esp
  800774:	ff 75 0c             	pushl  0xc(%ebp)
  800777:	53                   	push   %ebx
  800778:	8b 45 08             	mov    0x8(%ebp),%eax
  80077b:	ff d0                	call   *%eax
  80077d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800780:	8b 45 10             	mov    0x10(%ebp),%eax
  800783:	8d 50 01             	lea    0x1(%eax),%edx
  800786:	89 55 10             	mov    %edx,0x10(%ebp)
  800789:	8a 00                	mov    (%eax),%al
  80078b:	0f b6 d8             	movzbl %al,%ebx
  80078e:	83 fb 25             	cmp    $0x25,%ebx
  800791:	75 d6                	jne    800769 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800793:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800797:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80079e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007a5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007ac:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007b3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007b6:	8d 50 01             	lea    0x1(%eax),%edx
  8007b9:	89 55 10             	mov    %edx,0x10(%ebp)
  8007bc:	8a 00                	mov    (%eax),%al
  8007be:	0f b6 d8             	movzbl %al,%ebx
  8007c1:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007c4:	83 f8 55             	cmp    $0x55,%eax
  8007c7:	0f 87 2b 03 00 00    	ja     800af8 <vprintfmt+0x399>
  8007cd:	8b 04 85 d8 39 80 00 	mov    0x8039d8(,%eax,4),%eax
  8007d4:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007d6:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007da:	eb d7                	jmp    8007b3 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007dc:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007e0:	eb d1                	jmp    8007b3 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007e2:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ec:	89 d0                	mov    %edx,%eax
  8007ee:	c1 e0 02             	shl    $0x2,%eax
  8007f1:	01 d0                	add    %edx,%eax
  8007f3:	01 c0                	add    %eax,%eax
  8007f5:	01 d8                	add    %ebx,%eax
  8007f7:	83 e8 30             	sub    $0x30,%eax
  8007fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800800:	8a 00                	mov    (%eax),%al
  800802:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800805:	83 fb 2f             	cmp    $0x2f,%ebx
  800808:	7e 3e                	jle    800848 <vprintfmt+0xe9>
  80080a:	83 fb 39             	cmp    $0x39,%ebx
  80080d:	7f 39                	jg     800848 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80080f:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800812:	eb d5                	jmp    8007e9 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800814:	8b 45 14             	mov    0x14(%ebp),%eax
  800817:	83 c0 04             	add    $0x4,%eax
  80081a:	89 45 14             	mov    %eax,0x14(%ebp)
  80081d:	8b 45 14             	mov    0x14(%ebp),%eax
  800820:	83 e8 04             	sub    $0x4,%eax
  800823:	8b 00                	mov    (%eax),%eax
  800825:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800828:	eb 1f                	jmp    800849 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80082a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80082e:	79 83                	jns    8007b3 <vprintfmt+0x54>
				width = 0;
  800830:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800837:	e9 77 ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  80083c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800843:	e9 6b ff ff ff       	jmp    8007b3 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800848:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800849:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084d:	0f 89 60 ff ff ff    	jns    8007b3 <vprintfmt+0x54>
				width = precision, precision = -1;
  800853:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800856:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800859:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800860:	e9 4e ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800865:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800868:	e9 46 ff ff ff       	jmp    8007b3 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80086d:	8b 45 14             	mov    0x14(%ebp),%eax
  800870:	83 c0 04             	add    $0x4,%eax
  800873:	89 45 14             	mov    %eax,0x14(%ebp)
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 e8 04             	sub    $0x4,%eax
  80087c:	8b 00                	mov    (%eax),%eax
  80087e:	83 ec 08             	sub    $0x8,%esp
  800881:	ff 75 0c             	pushl  0xc(%ebp)
  800884:	50                   	push   %eax
  800885:	8b 45 08             	mov    0x8(%ebp),%eax
  800888:	ff d0                	call   *%eax
  80088a:	83 c4 10             	add    $0x10,%esp
			break;
  80088d:	e9 89 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800892:	8b 45 14             	mov    0x14(%ebp),%eax
  800895:	83 c0 04             	add    $0x4,%eax
  800898:	89 45 14             	mov    %eax,0x14(%ebp)
  80089b:	8b 45 14             	mov    0x14(%ebp),%eax
  80089e:	83 e8 04             	sub    $0x4,%eax
  8008a1:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008a3:	85 db                	test   %ebx,%ebx
  8008a5:	79 02                	jns    8008a9 <vprintfmt+0x14a>
				err = -err;
  8008a7:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008a9:	83 fb 64             	cmp    $0x64,%ebx
  8008ac:	7f 0b                	jg     8008b9 <vprintfmt+0x15a>
  8008ae:	8b 34 9d 20 38 80 00 	mov    0x803820(,%ebx,4),%esi
  8008b5:	85 f6                	test   %esi,%esi
  8008b7:	75 19                	jne    8008d2 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008b9:	53                   	push   %ebx
  8008ba:	68 c5 39 80 00       	push   $0x8039c5
  8008bf:	ff 75 0c             	pushl  0xc(%ebp)
  8008c2:	ff 75 08             	pushl  0x8(%ebp)
  8008c5:	e8 5e 02 00 00       	call   800b28 <printfmt>
  8008ca:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008cd:	e9 49 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008d2:	56                   	push   %esi
  8008d3:	68 ce 39 80 00       	push   $0x8039ce
  8008d8:	ff 75 0c             	pushl  0xc(%ebp)
  8008db:	ff 75 08             	pushl  0x8(%ebp)
  8008de:	e8 45 02 00 00       	call   800b28 <printfmt>
  8008e3:	83 c4 10             	add    $0x10,%esp
			break;
  8008e6:	e9 30 02 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ee:	83 c0 04             	add    $0x4,%eax
  8008f1:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f7:	83 e8 04             	sub    $0x4,%eax
  8008fa:	8b 30                	mov    (%eax),%esi
  8008fc:	85 f6                	test   %esi,%esi
  8008fe:	75 05                	jne    800905 <vprintfmt+0x1a6>
				p = "(null)";
  800900:	be d1 39 80 00       	mov    $0x8039d1,%esi
			if (width > 0 && padc != '-')
  800905:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800909:	7e 6d                	jle    800978 <vprintfmt+0x219>
  80090b:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  80090f:	74 67                	je     800978 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800911:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800914:	83 ec 08             	sub    $0x8,%esp
  800917:	50                   	push   %eax
  800918:	56                   	push   %esi
  800919:	e8 0c 03 00 00       	call   800c2a <strnlen>
  80091e:	83 c4 10             	add    $0x10,%esp
  800921:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800924:	eb 16                	jmp    80093c <vprintfmt+0x1dd>
					putch(padc, putdat);
  800926:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80092a:	83 ec 08             	sub    $0x8,%esp
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	50                   	push   %eax
  800931:	8b 45 08             	mov    0x8(%ebp),%eax
  800934:	ff d0                	call   *%eax
  800936:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800939:	ff 4d e4             	decl   -0x1c(%ebp)
  80093c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800940:	7f e4                	jg     800926 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800942:	eb 34                	jmp    800978 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800944:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800948:	74 1c                	je     800966 <vprintfmt+0x207>
  80094a:	83 fb 1f             	cmp    $0x1f,%ebx
  80094d:	7e 05                	jle    800954 <vprintfmt+0x1f5>
  80094f:	83 fb 7e             	cmp    $0x7e,%ebx
  800952:	7e 12                	jle    800966 <vprintfmt+0x207>
					putch('?', putdat);
  800954:	83 ec 08             	sub    $0x8,%esp
  800957:	ff 75 0c             	pushl  0xc(%ebp)
  80095a:	6a 3f                	push   $0x3f
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	ff d0                	call   *%eax
  800961:	83 c4 10             	add    $0x10,%esp
  800964:	eb 0f                	jmp    800975 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800966:	83 ec 08             	sub    $0x8,%esp
  800969:	ff 75 0c             	pushl  0xc(%ebp)
  80096c:	53                   	push   %ebx
  80096d:	8b 45 08             	mov    0x8(%ebp),%eax
  800970:	ff d0                	call   *%eax
  800972:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800975:	ff 4d e4             	decl   -0x1c(%ebp)
  800978:	89 f0                	mov    %esi,%eax
  80097a:	8d 70 01             	lea    0x1(%eax),%esi
  80097d:	8a 00                	mov    (%eax),%al
  80097f:	0f be d8             	movsbl %al,%ebx
  800982:	85 db                	test   %ebx,%ebx
  800984:	74 24                	je     8009aa <vprintfmt+0x24b>
  800986:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80098a:	78 b8                	js     800944 <vprintfmt+0x1e5>
  80098c:	ff 4d e0             	decl   -0x20(%ebp)
  80098f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800993:	79 af                	jns    800944 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800995:	eb 13                	jmp    8009aa <vprintfmt+0x24b>
				putch(' ', putdat);
  800997:	83 ec 08             	sub    $0x8,%esp
  80099a:	ff 75 0c             	pushl  0xc(%ebp)
  80099d:	6a 20                	push   $0x20
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	ff d0                	call   *%eax
  8009a4:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009a7:	ff 4d e4             	decl   -0x1c(%ebp)
  8009aa:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ae:	7f e7                	jg     800997 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009b0:	e9 66 01 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009b5:	83 ec 08             	sub    $0x8,%esp
  8009b8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009bb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009be:	50                   	push   %eax
  8009bf:	e8 3c fd ff ff       	call   800700 <getint>
  8009c4:	83 c4 10             	add    $0x10,%esp
  8009c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009ca:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d3:	85 d2                	test   %edx,%edx
  8009d5:	79 23                	jns    8009fa <vprintfmt+0x29b>
				putch('-', putdat);
  8009d7:	83 ec 08             	sub    $0x8,%esp
  8009da:	ff 75 0c             	pushl  0xc(%ebp)
  8009dd:	6a 2d                	push   $0x2d
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	ff d0                	call   *%eax
  8009e4:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ed:	f7 d8                	neg    %eax
  8009ef:	83 d2 00             	adc    $0x0,%edx
  8009f2:	f7 da                	neg    %edx
  8009f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009f7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009fa:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a01:	e9 bc 00 00 00       	jmp    800ac2 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a06:	83 ec 08             	sub    $0x8,%esp
  800a09:	ff 75 e8             	pushl  -0x18(%ebp)
  800a0c:	8d 45 14             	lea    0x14(%ebp),%eax
  800a0f:	50                   	push   %eax
  800a10:	e8 84 fc ff ff       	call   800699 <getuint>
  800a15:	83 c4 10             	add    $0x10,%esp
  800a18:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a1e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a25:	e9 98 00 00 00       	jmp    800ac2 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a2a:	83 ec 08             	sub    $0x8,%esp
  800a2d:	ff 75 0c             	pushl  0xc(%ebp)
  800a30:	6a 58                	push   $0x58
  800a32:	8b 45 08             	mov    0x8(%ebp),%eax
  800a35:	ff d0                	call   *%eax
  800a37:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a3a:	83 ec 08             	sub    $0x8,%esp
  800a3d:	ff 75 0c             	pushl  0xc(%ebp)
  800a40:	6a 58                	push   $0x58
  800a42:	8b 45 08             	mov    0x8(%ebp),%eax
  800a45:	ff d0                	call   *%eax
  800a47:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a4a:	83 ec 08             	sub    $0x8,%esp
  800a4d:	ff 75 0c             	pushl  0xc(%ebp)
  800a50:	6a 58                	push   $0x58
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	ff d0                	call   *%eax
  800a57:	83 c4 10             	add    $0x10,%esp
			break;
  800a5a:	e9 bc 00 00 00       	jmp    800b1b <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a5f:	83 ec 08             	sub    $0x8,%esp
  800a62:	ff 75 0c             	pushl  0xc(%ebp)
  800a65:	6a 30                	push   $0x30
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	ff d0                	call   *%eax
  800a6c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a6f:	83 ec 08             	sub    $0x8,%esp
  800a72:	ff 75 0c             	pushl  0xc(%ebp)
  800a75:	6a 78                	push   $0x78
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	ff d0                	call   *%eax
  800a7c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a7f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a82:	83 c0 04             	add    $0x4,%eax
  800a85:	89 45 14             	mov    %eax,0x14(%ebp)
  800a88:	8b 45 14             	mov    0x14(%ebp),%eax
  800a8b:	83 e8 04             	sub    $0x4,%eax
  800a8e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a90:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a93:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a9a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800aa1:	eb 1f                	jmp    800ac2 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa9:	8d 45 14             	lea    0x14(%ebp),%eax
  800aac:	50                   	push   %eax
  800aad:	e8 e7 fb ff ff       	call   800699 <getuint>
  800ab2:	83 c4 10             	add    $0x10,%esp
  800ab5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800abb:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ac2:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ac6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ac9:	83 ec 04             	sub    $0x4,%esp
  800acc:	52                   	push   %edx
  800acd:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ad0:	50                   	push   %eax
  800ad1:	ff 75 f4             	pushl  -0xc(%ebp)
  800ad4:	ff 75 f0             	pushl  -0x10(%ebp)
  800ad7:	ff 75 0c             	pushl  0xc(%ebp)
  800ada:	ff 75 08             	pushl  0x8(%ebp)
  800add:	e8 00 fb ff ff       	call   8005e2 <printnum>
  800ae2:	83 c4 20             	add    $0x20,%esp
			break;
  800ae5:	eb 34                	jmp    800b1b <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ae7:	83 ec 08             	sub    $0x8,%esp
  800aea:	ff 75 0c             	pushl  0xc(%ebp)
  800aed:	53                   	push   %ebx
  800aee:	8b 45 08             	mov    0x8(%ebp),%eax
  800af1:	ff d0                	call   *%eax
  800af3:	83 c4 10             	add    $0x10,%esp
			break;
  800af6:	eb 23                	jmp    800b1b <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 25                	push   $0x25
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b08:	ff 4d 10             	decl   0x10(%ebp)
  800b0b:	eb 03                	jmp    800b10 <vprintfmt+0x3b1>
  800b0d:	ff 4d 10             	decl   0x10(%ebp)
  800b10:	8b 45 10             	mov    0x10(%ebp),%eax
  800b13:	48                   	dec    %eax
  800b14:	8a 00                	mov    (%eax),%al
  800b16:	3c 25                	cmp    $0x25,%al
  800b18:	75 f3                	jne    800b0d <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b1a:	90                   	nop
		}
	}
  800b1b:	e9 47 fc ff ff       	jmp    800767 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b20:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b21:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b24:	5b                   	pop    %ebx
  800b25:	5e                   	pop    %esi
  800b26:	5d                   	pop    %ebp
  800b27:	c3                   	ret    

00800b28 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b28:	55                   	push   %ebp
  800b29:	89 e5                	mov    %esp,%ebp
  800b2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800b31:	83 c0 04             	add    $0x4,%eax
  800b34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b37:	8b 45 10             	mov    0x10(%ebp),%eax
  800b3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b3d:	50                   	push   %eax
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	ff 75 08             	pushl  0x8(%ebp)
  800b44:	e8 16 fc ff ff       	call   80075f <vprintfmt>
  800b49:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b4c:	90                   	nop
  800b4d:	c9                   	leave  
  800b4e:	c3                   	ret    

00800b4f <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b4f:	55                   	push   %ebp
  800b50:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 40 08             	mov    0x8(%eax),%eax
  800b58:	8d 50 01             	lea    0x1(%eax),%edx
  800b5b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5e:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b64:	8b 10                	mov    (%eax),%edx
  800b66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b69:	8b 40 04             	mov    0x4(%eax),%eax
  800b6c:	39 c2                	cmp    %eax,%edx
  800b6e:	73 12                	jae    800b82 <sprintputch+0x33>
		*b->buf++ = ch;
  800b70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b73:	8b 00                	mov    (%eax),%eax
  800b75:	8d 48 01             	lea    0x1(%eax),%ecx
  800b78:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7b:	89 0a                	mov    %ecx,(%edx)
  800b7d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b80:	88 10                	mov    %dl,(%eax)
}
  800b82:	90                   	nop
  800b83:	5d                   	pop    %ebp
  800b84:	c3                   	ret    

00800b85 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b85:	55                   	push   %ebp
  800b86:	89 e5                	mov    %esp,%ebp
  800b88:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b94:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b97:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9a:	01 d0                	add    %edx,%eax
  800b9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b9f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ba6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800baa:	74 06                	je     800bb2 <vsnprintf+0x2d>
  800bac:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bb0:	7f 07                	jg     800bb9 <vsnprintf+0x34>
		return -E_INVAL;
  800bb2:	b8 03 00 00 00       	mov    $0x3,%eax
  800bb7:	eb 20                	jmp    800bd9 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bb9:	ff 75 14             	pushl  0x14(%ebp)
  800bbc:	ff 75 10             	pushl  0x10(%ebp)
  800bbf:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bc2:	50                   	push   %eax
  800bc3:	68 4f 0b 80 00       	push   $0x800b4f
  800bc8:	e8 92 fb ff ff       	call   80075f <vprintfmt>
  800bcd:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bd3:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bd6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bd9:	c9                   	leave  
  800bda:	c3                   	ret    

00800bdb <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bdb:	55                   	push   %ebp
  800bdc:	89 e5                	mov    %esp,%ebp
  800bde:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800be1:	8d 45 10             	lea    0x10(%ebp),%eax
  800be4:	83 c0 04             	add    $0x4,%eax
  800be7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bea:	8b 45 10             	mov    0x10(%ebp),%eax
  800bed:	ff 75 f4             	pushl  -0xc(%ebp)
  800bf0:	50                   	push   %eax
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	ff 75 08             	pushl  0x8(%ebp)
  800bf7:	e8 89 ff ff ff       	call   800b85 <vsnprintf>
  800bfc:	83 c4 10             	add    $0x10,%esp
  800bff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c05:	c9                   	leave  
  800c06:	c3                   	ret    

00800c07 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c07:	55                   	push   %ebp
  800c08:	89 e5                	mov    %esp,%ebp
  800c0a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c14:	eb 06                	jmp    800c1c <strlen+0x15>
		n++;
  800c16:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c19:	ff 45 08             	incl   0x8(%ebp)
  800c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	84 c0                	test   %al,%al
  800c23:	75 f1                	jne    800c16 <strlen+0xf>
		n++;
	return n;
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c37:	eb 09                	jmp    800c42 <strnlen+0x18>
		n++;
  800c39:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c3c:	ff 45 08             	incl   0x8(%ebp)
  800c3f:	ff 4d 0c             	decl   0xc(%ebp)
  800c42:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c46:	74 09                	je     800c51 <strnlen+0x27>
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	84 c0                	test   %al,%al
  800c4f:	75 e8                	jne    800c39 <strnlen+0xf>
		n++;
	return n;
  800c51:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c62:	90                   	nop
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8d 50 01             	lea    0x1(%eax),%edx
  800c69:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
  800c79:	8a 00                	mov    (%eax),%al
  800c7b:	84 c0                	test   %al,%al
  800c7d:	75 e4                	jne    800c63 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c7f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c97:	eb 1f                	jmp    800cb8 <strncpy+0x34>
		*dst++ = *src;
  800c99:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9c:	8d 50 01             	lea    0x1(%eax),%edx
  800c9f:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca5:	8a 12                	mov    (%edx),%dl
  800ca7:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8a 00                	mov    (%eax),%al
  800cae:	84 c0                	test   %al,%al
  800cb0:	74 03                	je     800cb5 <strncpy+0x31>
			src++;
  800cb2:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800cb5:	ff 45 fc             	incl   -0x4(%ebp)
  800cb8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cbb:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cbe:	72 d9                	jb     800c99 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cc0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cc3:	c9                   	leave  
  800cc4:	c3                   	ret    

00800cc5 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cc5:	55                   	push   %ebp
  800cc6:	89 e5                	mov    %esp,%ebp
  800cc8:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ccb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cd5:	74 30                	je     800d07 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cd7:	eb 16                	jmp    800cef <strlcpy+0x2a>
			*dst++ = *src++;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	8d 50 01             	lea    0x1(%eax),%edx
  800cdf:	89 55 08             	mov    %edx,0x8(%ebp)
  800ce2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ce5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ce8:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ceb:	8a 12                	mov    (%edx),%dl
  800ced:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cef:	ff 4d 10             	decl   0x10(%ebp)
  800cf2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cf6:	74 09                	je     800d01 <strlcpy+0x3c>
  800cf8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfb:	8a 00                	mov    (%eax),%al
  800cfd:	84 c0                	test   %al,%al
  800cff:	75 d8                	jne    800cd9 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d01:	8b 45 08             	mov    0x8(%ebp),%eax
  800d04:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d07:	8b 55 08             	mov    0x8(%ebp),%edx
  800d0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d0d:	29 c2                	sub    %eax,%edx
  800d0f:	89 d0                	mov    %edx,%eax
}
  800d11:	c9                   	leave  
  800d12:	c3                   	ret    

00800d13 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d13:	55                   	push   %ebp
  800d14:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d16:	eb 06                	jmp    800d1e <strcmp+0xb>
		p++, q++;
  800d18:	ff 45 08             	incl   0x8(%ebp)
  800d1b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	74 0e                	je     800d35 <strcmp+0x22>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 e3                	je     800d18 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d35:	8b 45 08             	mov    0x8(%ebp),%eax
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	0f b6 d0             	movzbl %al,%edx
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	8a 00                	mov    (%eax),%al
  800d42:	0f b6 c0             	movzbl %al,%eax
  800d45:	29 c2                	sub    %eax,%edx
  800d47:	89 d0                	mov    %edx,%eax
}
  800d49:	5d                   	pop    %ebp
  800d4a:	c3                   	ret    

00800d4b <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d4b:	55                   	push   %ebp
  800d4c:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d4e:	eb 09                	jmp    800d59 <strncmp+0xe>
		n--, p++, q++;
  800d50:	ff 4d 10             	decl   0x10(%ebp)
  800d53:	ff 45 08             	incl   0x8(%ebp)
  800d56:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5d:	74 17                	je     800d76 <strncmp+0x2b>
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	74 0e                	je     800d76 <strncmp+0x2b>
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 10                	mov    (%eax),%dl
  800d6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d70:	8a 00                	mov    (%eax),%al
  800d72:	38 c2                	cmp    %al,%dl
  800d74:	74 da                	je     800d50 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d76:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d7a:	75 07                	jne    800d83 <strncmp+0x38>
		return 0;
  800d7c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d81:	eb 14                	jmp    800d97 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d83:	8b 45 08             	mov    0x8(%ebp),%eax
  800d86:	8a 00                	mov    (%eax),%al
  800d88:	0f b6 d0             	movzbl %al,%edx
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	8a 00                	mov    (%eax),%al
  800d90:	0f b6 c0             	movzbl %al,%eax
  800d93:	29 c2                	sub    %eax,%edx
  800d95:	89 d0                	mov    %edx,%eax
}
  800d97:	5d                   	pop    %ebp
  800d98:	c3                   	ret    

00800d99 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d99:	55                   	push   %ebp
  800d9a:	89 e5                	mov    %esp,%ebp
  800d9c:	83 ec 04             	sub    $0x4,%esp
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800da5:	eb 12                	jmp    800db9 <strchr+0x20>
		if (*s == c)
  800da7:	8b 45 08             	mov    0x8(%ebp),%eax
  800daa:	8a 00                	mov    (%eax),%al
  800dac:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800daf:	75 05                	jne    800db6 <strchr+0x1d>
			return (char *) s;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	eb 11                	jmp    800dc7 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800db6:	ff 45 08             	incl   0x8(%ebp)
  800db9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbc:	8a 00                	mov    (%eax),%al
  800dbe:	84 c0                	test   %al,%al
  800dc0:	75 e5                	jne    800da7 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dc2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dc7:	c9                   	leave  
  800dc8:	c3                   	ret    

00800dc9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dc9:	55                   	push   %ebp
  800dca:	89 e5                	mov    %esp,%ebp
  800dcc:	83 ec 04             	sub    $0x4,%esp
  800dcf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd2:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dd5:	eb 0d                	jmp    800de4 <strfind+0x1b>
		if (*s == c)
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	8a 00                	mov    (%eax),%al
  800ddc:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ddf:	74 0e                	je     800def <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800de1:	ff 45 08             	incl   0x8(%ebp)
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	8a 00                	mov    (%eax),%al
  800de9:	84 c0                	test   %al,%al
  800deb:	75 ea                	jne    800dd7 <strfind+0xe>
  800ded:	eb 01                	jmp    800df0 <strfind+0x27>
		if (*s == c)
			break;
  800def:	90                   	nop
	return (char *) s;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800df3:	c9                   	leave  
  800df4:	c3                   	ret    

00800df5 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800df5:	55                   	push   %ebp
  800df6:	89 e5                	mov    %esp,%ebp
  800df8:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e01:	8b 45 10             	mov    0x10(%ebp),%eax
  800e04:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e07:	eb 0e                	jmp    800e17 <memset+0x22>
		*p++ = c;
  800e09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e0c:	8d 50 01             	lea    0x1(%eax),%edx
  800e0f:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e15:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e17:	ff 4d f8             	decl   -0x8(%ebp)
  800e1a:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e1e:	79 e9                	jns    800e09 <memset+0x14>
		*p++ = c;

	return v;
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e23:	c9                   	leave  
  800e24:	c3                   	ret    

00800e25 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e25:	55                   	push   %ebp
  800e26:	89 e5                	mov    %esp,%ebp
  800e28:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e37:	eb 16                	jmp    800e4f <memcpy+0x2a>
		*d++ = *s++;
  800e39:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e3c:	8d 50 01             	lea    0x1(%eax),%edx
  800e3f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e42:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e45:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e48:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e4b:	8a 12                	mov    (%edx),%dl
  800e4d:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800e52:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e55:	89 55 10             	mov    %edx,0x10(%ebp)
  800e58:	85 c0                	test   %eax,%eax
  800e5a:	75 dd                	jne    800e39 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e5c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e5f:	c9                   	leave  
  800e60:	c3                   	ret    

00800e61 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e61:	55                   	push   %ebp
  800e62:	89 e5                	mov    %esp,%ebp
  800e64:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e67:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e73:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e76:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e79:	73 50                	jae    800ecb <memmove+0x6a>
  800e7b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e81:	01 d0                	add    %edx,%eax
  800e83:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e86:	76 43                	jbe    800ecb <memmove+0x6a>
		s += n;
  800e88:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e8e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e91:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e94:	eb 10                	jmp    800ea6 <memmove+0x45>
			*--d = *--s;
  800e96:	ff 4d f8             	decl   -0x8(%ebp)
  800e99:	ff 4d fc             	decl   -0x4(%ebp)
  800e9c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9f:	8a 10                	mov    (%eax),%dl
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eac:	89 55 10             	mov    %edx,0x10(%ebp)
  800eaf:	85 c0                	test   %eax,%eax
  800eb1:	75 e3                	jne    800e96 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800eb3:	eb 23                	jmp    800ed8 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8d 50 01             	lea    0x1(%eax),%edx
  800ebb:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ebe:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ec1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ec4:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ec7:	8a 12                	mov    (%edx),%dl
  800ec9:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ecb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ece:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ed1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ed4:	85 c0                	test   %eax,%eax
  800ed6:	75 dd                	jne    800eb5 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800edb:	c9                   	leave  
  800edc:	c3                   	ret    

00800edd <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800edd:	55                   	push   %ebp
  800ede:	89 e5                	mov    %esp,%ebp
  800ee0:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eef:	eb 2a                	jmp    800f1b <memcmp+0x3e>
		if (*s1 != *s2)
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	38 c2                	cmp    %al,%dl
  800efd:	74 16                	je     800f15 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f02:	8a 00                	mov    (%eax),%al
  800f04:	0f b6 d0             	movzbl %al,%edx
  800f07:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	29 c2                	sub    %eax,%edx
  800f11:	89 d0                	mov    %edx,%eax
  800f13:	eb 18                	jmp    800f2d <memcmp+0x50>
		s1++, s2++;
  800f15:	ff 45 fc             	incl   -0x4(%ebp)
  800f18:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f21:	89 55 10             	mov    %edx,0x10(%ebp)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 c9                	jne    800ef1 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f28:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f2d:	c9                   	leave  
  800f2e:	c3                   	ret    

00800f2f <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f2f:	55                   	push   %ebp
  800f30:	89 e5                	mov    %esp,%ebp
  800f32:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f35:	8b 55 08             	mov    0x8(%ebp),%edx
  800f38:	8b 45 10             	mov    0x10(%ebp),%eax
  800f3b:	01 d0                	add    %edx,%eax
  800f3d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f40:	eb 15                	jmp    800f57 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f42:	8b 45 08             	mov    0x8(%ebp),%eax
  800f45:	8a 00                	mov    (%eax),%al
  800f47:	0f b6 d0             	movzbl %al,%edx
  800f4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f4d:	0f b6 c0             	movzbl %al,%eax
  800f50:	39 c2                	cmp    %eax,%edx
  800f52:	74 0d                	je     800f61 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f54:	ff 45 08             	incl   0x8(%ebp)
  800f57:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5a:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f5d:	72 e3                	jb     800f42 <memfind+0x13>
  800f5f:	eb 01                	jmp    800f62 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f61:	90                   	nop
	return (void *) s;
  800f62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f65:	c9                   	leave  
  800f66:	c3                   	ret    

00800f67 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f67:	55                   	push   %ebp
  800f68:	89 e5                	mov    %esp,%ebp
  800f6a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f6d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f74:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f7b:	eb 03                	jmp    800f80 <strtol+0x19>
		s++;
  800f7d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f80:	8b 45 08             	mov    0x8(%ebp),%eax
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	3c 20                	cmp    $0x20,%al
  800f87:	74 f4                	je     800f7d <strtol+0x16>
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	3c 09                	cmp    $0x9,%al
  800f90:	74 eb                	je     800f7d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f92:	8b 45 08             	mov    0x8(%ebp),%eax
  800f95:	8a 00                	mov    (%eax),%al
  800f97:	3c 2b                	cmp    $0x2b,%al
  800f99:	75 05                	jne    800fa0 <strtol+0x39>
		s++;
  800f9b:	ff 45 08             	incl   0x8(%ebp)
  800f9e:	eb 13                	jmp    800fb3 <strtol+0x4c>
	else if (*s == '-')
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	3c 2d                	cmp    $0x2d,%al
  800fa7:	75 0a                	jne    800fb3 <strtol+0x4c>
		s++, neg = 1;
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fb7:	74 06                	je     800fbf <strtol+0x58>
  800fb9:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fbd:	75 20                	jne    800fdf <strtol+0x78>
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	3c 30                	cmp    $0x30,%al
  800fc6:	75 17                	jne    800fdf <strtol+0x78>
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	40                   	inc    %eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 78                	cmp    $0x78,%al
  800fd0:	75 0d                	jne    800fdf <strtol+0x78>
		s += 2, base = 16;
  800fd2:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fd6:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fdd:	eb 28                	jmp    801007 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	75 15                	jne    800ffa <strtol+0x93>
  800fe5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe8:	8a 00                	mov    (%eax),%al
  800fea:	3c 30                	cmp    $0x30,%al
  800fec:	75 0c                	jne    800ffa <strtol+0x93>
		s++, base = 8;
  800fee:	ff 45 08             	incl   0x8(%ebp)
  800ff1:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ff8:	eb 0d                	jmp    801007 <strtol+0xa0>
	else if (base == 0)
  800ffa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffe:	75 07                	jne    801007 <strtol+0xa0>
		base = 10;
  801000:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
  80100a:	8a 00                	mov    (%eax),%al
  80100c:	3c 2f                	cmp    $0x2f,%al
  80100e:	7e 19                	jle    801029 <strtol+0xc2>
  801010:	8b 45 08             	mov    0x8(%ebp),%eax
  801013:	8a 00                	mov    (%eax),%al
  801015:	3c 39                	cmp    $0x39,%al
  801017:	7f 10                	jg     801029 <strtol+0xc2>
			dig = *s - '0';
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	0f be c0             	movsbl %al,%eax
  801021:	83 e8 30             	sub    $0x30,%eax
  801024:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801027:	eb 42                	jmp    80106b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801029:	8b 45 08             	mov    0x8(%ebp),%eax
  80102c:	8a 00                	mov    (%eax),%al
  80102e:	3c 60                	cmp    $0x60,%al
  801030:	7e 19                	jle    80104b <strtol+0xe4>
  801032:	8b 45 08             	mov    0x8(%ebp),%eax
  801035:	8a 00                	mov    (%eax),%al
  801037:	3c 7a                	cmp    $0x7a,%al
  801039:	7f 10                	jg     80104b <strtol+0xe4>
			dig = *s - 'a' + 10;
  80103b:	8b 45 08             	mov    0x8(%ebp),%eax
  80103e:	8a 00                	mov    (%eax),%al
  801040:	0f be c0             	movsbl %al,%eax
  801043:	83 e8 57             	sub    $0x57,%eax
  801046:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801049:	eb 20                	jmp    80106b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80104b:	8b 45 08             	mov    0x8(%ebp),%eax
  80104e:	8a 00                	mov    (%eax),%al
  801050:	3c 40                	cmp    $0x40,%al
  801052:	7e 39                	jle    80108d <strtol+0x126>
  801054:	8b 45 08             	mov    0x8(%ebp),%eax
  801057:	8a 00                	mov    (%eax),%al
  801059:	3c 5a                	cmp    $0x5a,%al
  80105b:	7f 30                	jg     80108d <strtol+0x126>
			dig = *s - 'A' + 10;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	8a 00                	mov    (%eax),%al
  801062:	0f be c0             	movsbl %al,%eax
  801065:	83 e8 37             	sub    $0x37,%eax
  801068:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801071:	7d 19                	jge    80108c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801073:	ff 45 08             	incl   0x8(%ebp)
  801076:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801079:	0f af 45 10          	imul   0x10(%ebp),%eax
  80107d:	89 c2                	mov    %eax,%edx
  80107f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801082:	01 d0                	add    %edx,%eax
  801084:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801087:	e9 7b ff ff ff       	jmp    801007 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80108c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80108d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801091:	74 08                	je     80109b <strtol+0x134>
		*endptr = (char *) s;
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	8b 55 08             	mov    0x8(%ebp),%edx
  801099:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80109b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80109f:	74 07                	je     8010a8 <strtol+0x141>
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	f7 d8                	neg    %eax
  8010a6:	eb 03                	jmp    8010ab <strtol+0x144>
  8010a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010ab:	c9                   	leave  
  8010ac:	c3                   	ret    

008010ad <ltostr>:

void
ltostr(long value, char *str)
{
  8010ad:	55                   	push   %ebp
  8010ae:	89 e5                	mov    %esp,%ebp
  8010b0:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010ba:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010c5:	79 13                	jns    8010da <ltostr+0x2d>
	{
		neg = 1;
  8010c7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010d1:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010d4:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010d7:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010da:	8b 45 08             	mov    0x8(%ebp),%eax
  8010dd:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010e2:	99                   	cltd   
  8010e3:	f7 f9                	idiv   %ecx
  8010e5:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010eb:	8d 50 01             	lea    0x1(%eax),%edx
  8010ee:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010f1:	89 c2                	mov    %eax,%edx
  8010f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010fb:	83 c2 30             	add    $0x30,%edx
  8010fe:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801100:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801103:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801108:	f7 e9                	imul   %ecx
  80110a:	c1 fa 02             	sar    $0x2,%edx
  80110d:	89 c8                	mov    %ecx,%eax
  80110f:	c1 f8 1f             	sar    $0x1f,%eax
  801112:	29 c2                	sub    %eax,%edx
  801114:	89 d0                	mov    %edx,%eax
  801116:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801119:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801121:	f7 e9                	imul   %ecx
  801123:	c1 fa 02             	sar    $0x2,%edx
  801126:	89 c8                	mov    %ecx,%eax
  801128:	c1 f8 1f             	sar    $0x1f,%eax
  80112b:	29 c2                	sub    %eax,%edx
  80112d:	89 d0                	mov    %edx,%eax
  80112f:	c1 e0 02             	shl    $0x2,%eax
  801132:	01 d0                	add    %edx,%eax
  801134:	01 c0                	add    %eax,%eax
  801136:	29 c1                	sub    %eax,%ecx
  801138:	89 ca                	mov    %ecx,%edx
  80113a:	85 d2                	test   %edx,%edx
  80113c:	75 9c                	jne    8010da <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80113e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801145:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801148:	48                   	dec    %eax
  801149:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80114c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801150:	74 3d                	je     80118f <ltostr+0xe2>
		start = 1 ;
  801152:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801159:	eb 34                	jmp    80118f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80115b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	01 d0                	add    %edx,%eax
  801163:	8a 00                	mov    (%eax),%al
  801165:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801173:	8b 45 0c             	mov    0xc(%ebp),%eax
  801176:	01 c8                	add    %ecx,%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80117c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 c2                	add    %eax,%edx
  801184:	8a 45 eb             	mov    -0x15(%ebp),%al
  801187:	88 02                	mov    %al,(%edx)
		start++ ;
  801189:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80118c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80118f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801192:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801195:	7c c4                	jl     80115b <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801197:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	01 d0                	add    %edx,%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011a2:	90                   	nop
  8011a3:	c9                   	leave  
  8011a4:	c3                   	ret    

008011a5 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011a5:	55                   	push   %ebp
  8011a6:	89 e5                	mov    %esp,%ebp
  8011a8:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 54 fa ff ff       	call   800c07 <strlen>
  8011b3:	83 c4 04             	add    $0x4,%esp
  8011b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011b9:	ff 75 0c             	pushl  0xc(%ebp)
  8011bc:	e8 46 fa ff ff       	call   800c07 <strlen>
  8011c1:	83 c4 04             	add    $0x4,%esp
  8011c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ce:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011d5:	eb 17                	jmp    8011ee <strcconcat+0x49>
		final[s] = str1[s] ;
  8011d7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011da:	8b 45 10             	mov    0x10(%ebp),%eax
  8011dd:	01 c2                	add    %eax,%edx
  8011df:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e5:	01 c8                	add    %ecx,%eax
  8011e7:	8a 00                	mov    (%eax),%al
  8011e9:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011eb:	ff 45 fc             	incl   -0x4(%ebp)
  8011ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011f4:	7c e1                	jl     8011d7 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011f6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801204:	eb 1f                	jmp    801225 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80120f:	89 c2                	mov    %eax,%edx
  801211:	8b 45 10             	mov    0x10(%ebp),%eax
  801214:	01 c2                	add    %eax,%edx
  801216:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801219:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121c:	01 c8                	add    %ecx,%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801222:	ff 45 f8             	incl   -0x8(%ebp)
  801225:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801228:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122b:	7c d9                	jl     801206 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80122d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801230:	8b 45 10             	mov    0x10(%ebp),%eax
  801233:	01 d0                	add    %edx,%eax
  801235:	c6 00 00             	movb   $0x0,(%eax)
}
  801238:	90                   	nop
  801239:	c9                   	leave  
  80123a:	c3                   	ret    

0080123b <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80123b:	55                   	push   %ebp
  80123c:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80123e:	8b 45 14             	mov    0x14(%ebp),%eax
  801241:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801253:	8b 45 10             	mov    0x10(%ebp),%eax
  801256:	01 d0                	add    %edx,%eax
  801258:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80125e:	eb 0c                	jmp    80126c <strsplit+0x31>
			*string++ = 0;
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	8d 50 01             	lea    0x1(%eax),%edx
  801266:	89 55 08             	mov    %edx,0x8(%ebp)
  801269:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80126c:	8b 45 08             	mov    0x8(%ebp),%eax
  80126f:	8a 00                	mov    (%eax),%al
  801271:	84 c0                	test   %al,%al
  801273:	74 18                	je     80128d <strsplit+0x52>
  801275:	8b 45 08             	mov    0x8(%ebp),%eax
  801278:	8a 00                	mov    (%eax),%al
  80127a:	0f be c0             	movsbl %al,%eax
  80127d:	50                   	push   %eax
  80127e:	ff 75 0c             	pushl  0xc(%ebp)
  801281:	e8 13 fb ff ff       	call   800d99 <strchr>
  801286:	83 c4 08             	add    $0x8,%esp
  801289:	85 c0                	test   %eax,%eax
  80128b:	75 d3                	jne    801260 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	84 c0                	test   %al,%al
  801294:	74 5a                	je     8012f0 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801296:	8b 45 14             	mov    0x14(%ebp),%eax
  801299:	8b 00                	mov    (%eax),%eax
  80129b:	83 f8 0f             	cmp    $0xf,%eax
  80129e:	75 07                	jne    8012a7 <strsplit+0x6c>
		{
			return 0;
  8012a0:	b8 00 00 00 00       	mov    $0x0,%eax
  8012a5:	eb 66                	jmp    80130d <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012aa:	8b 00                	mov    (%eax),%eax
  8012ac:	8d 48 01             	lea    0x1(%eax),%ecx
  8012af:	8b 55 14             	mov    0x14(%ebp),%edx
  8012b2:	89 0a                	mov    %ecx,(%edx)
  8012b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	01 c2                	add    %eax,%edx
  8012c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c3:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012c5:	eb 03                	jmp    8012ca <strsplit+0x8f>
			string++;
  8012c7:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	84 c0                	test   %al,%al
  8012d1:	74 8b                	je     80125e <strsplit+0x23>
  8012d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d6:	8a 00                	mov    (%eax),%al
  8012d8:	0f be c0             	movsbl %al,%eax
  8012db:	50                   	push   %eax
  8012dc:	ff 75 0c             	pushl  0xc(%ebp)
  8012df:	e8 b5 fa ff ff       	call   800d99 <strchr>
  8012e4:	83 c4 08             	add    $0x8,%esp
  8012e7:	85 c0                	test   %eax,%eax
  8012e9:	74 dc                	je     8012c7 <strsplit+0x8c>
			string++;
	}
  8012eb:	e9 6e ff ff ff       	jmp    80125e <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012f0:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8012f4:	8b 00                	mov    (%eax),%eax
  8012f6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	01 d0                	add    %edx,%eax
  801302:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801308:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801315:	a1 04 40 80 00       	mov    0x804004,%eax
  80131a:	85 c0                	test   %eax,%eax
  80131c:	74 1f                	je     80133d <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80131e:	e8 1d 00 00 00       	call   801340 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801323:	83 ec 0c             	sub    $0xc,%esp
  801326:	68 30 3b 80 00       	push   $0x803b30
  80132b:	e8 55 f2 ff ff       	call   800585 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801333:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80133a:	00 00 00 
	}
}
  80133d:	90                   	nop
  80133e:	c9                   	leave  
  80133f:	c3                   	ret    

00801340 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801340:	55                   	push   %ebp
  801341:	89 e5                	mov    %esp,%ebp
  801343:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801346:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80134d:	00 00 00 
  801350:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801357:	00 00 00 
  80135a:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801361:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801364:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80136b:	00 00 00 
  80136e:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801375:	00 00 00 
  801378:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80137f:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801382:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80138c:	c1 e8 0c             	shr    $0xc,%eax
  80138f:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801394:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80139b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80139e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013a3:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013a8:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  8013ad:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8013b4:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b9:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8013bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8013c0:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8013c7:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013cd:	01 d0                	add    %edx,%eax
  8013cf:	48                   	dec    %eax
  8013d0:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013d6:	ba 00 00 00 00       	mov    $0x0,%edx
  8013db:	f7 75 e4             	divl   -0x1c(%ebp)
  8013de:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013e1:	29 d0                	sub    %edx,%eax
  8013e3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8013e6:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8013ed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013f0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f5:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013fa:	83 ec 04             	sub    $0x4,%esp
  8013fd:	6a 07                	push   $0x7
  8013ff:	ff 75 e8             	pushl  -0x18(%ebp)
  801402:	50                   	push   %eax
  801403:	e8 3d 06 00 00       	call   801a45 <sys_allocate_chunk>
  801408:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80140b:	a1 20 41 80 00       	mov    0x804120,%eax
  801410:	83 ec 0c             	sub    $0xc,%esp
  801413:	50                   	push   %eax
  801414:	e8 b2 0c 00 00       	call   8020cb <initialize_MemBlocksList>
  801419:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  80141c:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801421:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801424:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801428:	0f 84 f3 00 00 00    	je     801521 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  80142e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801432:	75 14                	jne    801448 <initialize_dyn_block_system+0x108>
  801434:	83 ec 04             	sub    $0x4,%esp
  801437:	68 55 3b 80 00       	push   $0x803b55
  80143c:	6a 36                	push   $0x36
  80143e:	68 73 3b 80 00       	push   $0x803b73
  801443:	e8 89 ee ff ff       	call   8002d1 <_panic>
  801448:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80144b:	8b 00                	mov    (%eax),%eax
  80144d:	85 c0                	test   %eax,%eax
  80144f:	74 10                	je     801461 <initialize_dyn_block_system+0x121>
  801451:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801454:	8b 00                	mov    (%eax),%eax
  801456:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801459:	8b 52 04             	mov    0x4(%edx),%edx
  80145c:	89 50 04             	mov    %edx,0x4(%eax)
  80145f:	eb 0b                	jmp    80146c <initialize_dyn_block_system+0x12c>
  801461:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801464:	8b 40 04             	mov    0x4(%eax),%eax
  801467:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80146c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80146f:	8b 40 04             	mov    0x4(%eax),%eax
  801472:	85 c0                	test   %eax,%eax
  801474:	74 0f                	je     801485 <initialize_dyn_block_system+0x145>
  801476:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801479:	8b 40 04             	mov    0x4(%eax),%eax
  80147c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80147f:	8b 12                	mov    (%edx),%edx
  801481:	89 10                	mov    %edx,(%eax)
  801483:	eb 0a                	jmp    80148f <initialize_dyn_block_system+0x14f>
  801485:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801488:	8b 00                	mov    (%eax),%eax
  80148a:	a3 48 41 80 00       	mov    %eax,0x804148
  80148f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801492:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801498:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80149b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014a2:	a1 54 41 80 00       	mov    0x804154,%eax
  8014a7:	48                   	dec    %eax
  8014a8:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  8014ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014b0:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8014b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014ba:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8014c1:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014c5:	75 14                	jne    8014db <initialize_dyn_block_system+0x19b>
  8014c7:	83 ec 04             	sub    $0x4,%esp
  8014ca:	68 80 3b 80 00       	push   $0x803b80
  8014cf:	6a 3e                	push   $0x3e
  8014d1:	68 73 3b 80 00       	push   $0x803b73
  8014d6:	e8 f6 ed ff ff       	call   8002d1 <_panic>
  8014db:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8014e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014e4:	89 10                	mov    %edx,(%eax)
  8014e6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014e9:	8b 00                	mov    (%eax),%eax
  8014eb:	85 c0                	test   %eax,%eax
  8014ed:	74 0d                	je     8014fc <initialize_dyn_block_system+0x1bc>
  8014ef:	a1 38 41 80 00       	mov    0x804138,%eax
  8014f4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014f7:	89 50 04             	mov    %edx,0x4(%eax)
  8014fa:	eb 08                	jmp    801504 <initialize_dyn_block_system+0x1c4>
  8014fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014ff:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801504:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801507:	a3 38 41 80 00       	mov    %eax,0x804138
  80150c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80150f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801516:	a1 44 41 80 00       	mov    0x804144,%eax
  80151b:	40                   	inc    %eax
  80151c:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  801521:	90                   	nop
  801522:	c9                   	leave  
  801523:	c3                   	ret    

00801524 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801524:	55                   	push   %ebp
  801525:	89 e5                	mov    %esp,%ebp
  801527:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  80152a:	e8 e0 fd ff ff       	call   80130f <InitializeUHeap>
		if (size == 0) return NULL ;
  80152f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801533:	75 07                	jne    80153c <malloc+0x18>
  801535:	b8 00 00 00 00       	mov    $0x0,%eax
  80153a:	eb 7f                	jmp    8015bb <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80153c:	e8 d2 08 00 00       	call   801e13 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801541:	85 c0                	test   %eax,%eax
  801543:	74 71                	je     8015b6 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801545:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80154c:	8b 55 08             	mov    0x8(%ebp),%edx
  80154f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801552:	01 d0                	add    %edx,%eax
  801554:	48                   	dec    %eax
  801555:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801558:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80155b:	ba 00 00 00 00       	mov    $0x0,%edx
  801560:	f7 75 f4             	divl   -0xc(%ebp)
  801563:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801566:	29 d0                	sub    %edx,%eax
  801568:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  80156b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801572:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801579:	76 07                	jbe    801582 <malloc+0x5e>
					return NULL ;
  80157b:	b8 00 00 00 00       	mov    $0x0,%eax
  801580:	eb 39                	jmp    8015bb <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801582:	83 ec 0c             	sub    $0xc,%esp
  801585:	ff 75 08             	pushl  0x8(%ebp)
  801588:	e8 e6 0d 00 00       	call   802373 <alloc_block_FF>
  80158d:	83 c4 10             	add    $0x10,%esp
  801590:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801593:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801597:	74 16                	je     8015af <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801599:	83 ec 0c             	sub    $0xc,%esp
  80159c:	ff 75 ec             	pushl  -0x14(%ebp)
  80159f:	e8 37 0c 00 00       	call   8021db <insert_sorted_allocList>
  8015a4:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  8015a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015aa:	8b 40 08             	mov    0x8(%eax),%eax
  8015ad:	eb 0c                	jmp    8015bb <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8015af:	b8 00 00 00 00       	mov    $0x0,%eax
  8015b4:	eb 05                	jmp    8015bb <malloc+0x97>
				}
		}
	return 0;
  8015b6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8015c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8015c9:	83 ec 08             	sub    $0x8,%esp
  8015cc:	ff 75 f4             	pushl  -0xc(%ebp)
  8015cf:	68 40 40 80 00       	push   $0x804040
  8015d4:	e8 cf 0b 00 00       	call   8021a8 <find_block>
  8015d9:	83 c4 10             	add    $0x10,%esp
  8015dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e2:	8b 40 0c             	mov    0xc(%eax),%eax
  8015e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8015e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015eb:	8b 40 08             	mov    0x8(%eax),%eax
  8015ee:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8015f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015f5:	0f 84 a1 00 00 00    	je     80169c <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8015fb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015ff:	75 17                	jne    801618 <free+0x5b>
  801601:	83 ec 04             	sub    $0x4,%esp
  801604:	68 55 3b 80 00       	push   $0x803b55
  801609:	68 80 00 00 00       	push   $0x80
  80160e:	68 73 3b 80 00       	push   $0x803b73
  801613:	e8 b9 ec ff ff       	call   8002d1 <_panic>
  801618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161b:	8b 00                	mov    (%eax),%eax
  80161d:	85 c0                	test   %eax,%eax
  80161f:	74 10                	je     801631 <free+0x74>
  801621:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801624:	8b 00                	mov    (%eax),%eax
  801626:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801629:	8b 52 04             	mov    0x4(%edx),%edx
  80162c:	89 50 04             	mov    %edx,0x4(%eax)
  80162f:	eb 0b                	jmp    80163c <free+0x7f>
  801631:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801634:	8b 40 04             	mov    0x4(%eax),%eax
  801637:	a3 44 40 80 00       	mov    %eax,0x804044
  80163c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163f:	8b 40 04             	mov    0x4(%eax),%eax
  801642:	85 c0                	test   %eax,%eax
  801644:	74 0f                	je     801655 <free+0x98>
  801646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801649:	8b 40 04             	mov    0x4(%eax),%eax
  80164c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80164f:	8b 12                	mov    (%edx),%edx
  801651:	89 10                	mov    %edx,(%eax)
  801653:	eb 0a                	jmp    80165f <free+0xa2>
  801655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801658:	8b 00                	mov    (%eax),%eax
  80165a:	a3 40 40 80 00       	mov    %eax,0x804040
  80165f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801662:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801668:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80166b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801672:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801677:	48                   	dec    %eax
  801678:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  80167d:	83 ec 0c             	sub    $0xc,%esp
  801680:	ff 75 f0             	pushl  -0x10(%ebp)
  801683:	e8 29 12 00 00       	call   8028b1 <insert_sorted_with_merge_freeList>
  801688:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  80168b:	83 ec 08             	sub    $0x8,%esp
  80168e:	ff 75 ec             	pushl  -0x14(%ebp)
  801691:	ff 75 e8             	pushl  -0x18(%ebp)
  801694:	e8 74 03 00 00       	call   801a0d <sys_free_user_mem>
  801699:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80169c:	90                   	nop
  80169d:	c9                   	leave  
  80169e:	c3                   	ret    

0080169f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  80169f:	55                   	push   %ebp
  8016a0:	89 e5                	mov    %esp,%ebp
  8016a2:	83 ec 38             	sub    $0x38,%esp
  8016a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a8:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016ab:	e8 5f fc ff ff       	call   80130f <InitializeUHeap>
	if (size == 0) return NULL ;
  8016b0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016b4:	75 0a                	jne    8016c0 <smalloc+0x21>
  8016b6:	b8 00 00 00 00       	mov    $0x0,%eax
  8016bb:	e9 b2 00 00 00       	jmp    801772 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8016c0:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8016c7:	76 0a                	jbe    8016d3 <smalloc+0x34>
		return NULL;
  8016c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ce:	e9 9f 00 00 00       	jmp    801772 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016d3:	e8 3b 07 00 00       	call   801e13 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016d8:	85 c0                	test   %eax,%eax
  8016da:	0f 84 8d 00 00 00    	je     80176d <smalloc+0xce>
	struct MemBlock *b = NULL;
  8016e0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8016e7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016ee:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f4:	01 d0                	add    %edx,%eax
  8016f6:	48                   	dec    %eax
  8016f7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016fd:	ba 00 00 00 00       	mov    $0x0,%edx
  801702:	f7 75 f0             	divl   -0x10(%ebp)
  801705:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801708:	29 d0                	sub    %edx,%eax
  80170a:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  80170d:	83 ec 0c             	sub    $0xc,%esp
  801710:	ff 75 e8             	pushl  -0x18(%ebp)
  801713:	e8 5b 0c 00 00       	call   802373 <alloc_block_FF>
  801718:	83 c4 10             	add    $0x10,%esp
  80171b:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  80171e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801722:	75 07                	jne    80172b <smalloc+0x8c>
			return NULL;
  801724:	b8 00 00 00 00       	mov    $0x0,%eax
  801729:	eb 47                	jmp    801772 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  80172b:	83 ec 0c             	sub    $0xc,%esp
  80172e:	ff 75 f4             	pushl  -0xc(%ebp)
  801731:	e8 a5 0a 00 00       	call   8021db <insert_sorted_allocList>
  801736:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801739:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80173c:	8b 40 08             	mov    0x8(%eax),%eax
  80173f:	89 c2                	mov    %eax,%edx
  801741:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801745:	52                   	push   %edx
  801746:	50                   	push   %eax
  801747:	ff 75 0c             	pushl  0xc(%ebp)
  80174a:	ff 75 08             	pushl  0x8(%ebp)
  80174d:	e8 46 04 00 00       	call   801b98 <sys_createSharedObject>
  801752:	83 c4 10             	add    $0x10,%esp
  801755:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801758:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80175c:	78 08                	js     801766 <smalloc+0xc7>
		return (void *)b->sva;
  80175e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801761:	8b 40 08             	mov    0x8(%eax),%eax
  801764:	eb 0c                	jmp    801772 <smalloc+0xd3>
		}else{
		return NULL;
  801766:	b8 00 00 00 00       	mov    $0x0,%eax
  80176b:	eb 05                	jmp    801772 <smalloc+0xd3>
			}

	}return NULL;
  80176d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801772:	c9                   	leave  
  801773:	c3                   	ret    

00801774 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801774:	55                   	push   %ebp
  801775:	89 e5                	mov    %esp,%ebp
  801777:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80177a:	e8 90 fb ff ff       	call   80130f <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80177f:	e8 8f 06 00 00       	call   801e13 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801784:	85 c0                	test   %eax,%eax
  801786:	0f 84 ad 00 00 00    	je     801839 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80178c:	83 ec 08             	sub    $0x8,%esp
  80178f:	ff 75 0c             	pushl  0xc(%ebp)
  801792:	ff 75 08             	pushl  0x8(%ebp)
  801795:	e8 28 04 00 00       	call   801bc2 <sys_getSizeOfSharedObject>
  80179a:	83 c4 10             	add    $0x10,%esp
  80179d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  8017a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017a4:	79 0a                	jns    8017b0 <sget+0x3c>
    {
    	return NULL;
  8017a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8017ab:	e9 8e 00 00 00       	jmp    80183e <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  8017b0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  8017b7:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c4:	01 d0                	add    %edx,%eax
  8017c6:	48                   	dec    %eax
  8017c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8017d2:	f7 75 ec             	divl   -0x14(%ebp)
  8017d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017d8:	29 d0                	sub    %edx,%eax
  8017da:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8017dd:	83 ec 0c             	sub    $0xc,%esp
  8017e0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017e3:	e8 8b 0b 00 00       	call   802373 <alloc_block_FF>
  8017e8:	83 c4 10             	add    $0x10,%esp
  8017eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8017ee:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017f2:	75 07                	jne    8017fb <sget+0x87>
				return NULL;
  8017f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f9:	eb 43                	jmp    80183e <sget+0xca>
			}
			insert_sorted_allocList(b);
  8017fb:	83 ec 0c             	sub    $0xc,%esp
  8017fe:	ff 75 f0             	pushl  -0x10(%ebp)
  801801:	e8 d5 09 00 00       	call   8021db <insert_sorted_allocList>
  801806:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801809:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80180c:	8b 40 08             	mov    0x8(%eax),%eax
  80180f:	83 ec 04             	sub    $0x4,%esp
  801812:	50                   	push   %eax
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	ff 75 08             	pushl  0x8(%ebp)
  801819:	e8 c1 03 00 00       	call   801bdf <sys_getSharedObject>
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801824:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801828:	78 08                	js     801832 <sget+0xbe>
			return (void *)b->sva;
  80182a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80182d:	8b 40 08             	mov    0x8(%eax),%eax
  801830:	eb 0c                	jmp    80183e <sget+0xca>
			}else{
			return NULL;
  801832:	b8 00 00 00 00       	mov    $0x0,%eax
  801837:	eb 05                	jmp    80183e <sget+0xca>
			}
    }}return NULL;
  801839:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801846:	e8 c4 fa ff ff       	call   80130f <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80184b:	83 ec 04             	sub    $0x4,%esp
  80184e:	68 a4 3b 80 00       	push   $0x803ba4
  801853:	68 03 01 00 00       	push   $0x103
  801858:	68 73 3b 80 00       	push   $0x803b73
  80185d:	e8 6f ea ff ff       	call   8002d1 <_panic>

00801862 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801862:	55                   	push   %ebp
  801863:	89 e5                	mov    %esp,%ebp
  801865:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801868:	83 ec 04             	sub    $0x4,%esp
  80186b:	68 cc 3b 80 00       	push   $0x803bcc
  801870:	68 17 01 00 00       	push   $0x117
  801875:	68 73 3b 80 00       	push   $0x803b73
  80187a:	e8 52 ea ff ff       	call   8002d1 <_panic>

0080187f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801885:	83 ec 04             	sub    $0x4,%esp
  801888:	68 f0 3b 80 00       	push   $0x803bf0
  80188d:	68 22 01 00 00       	push   $0x122
  801892:	68 73 3b 80 00       	push   $0x803b73
  801897:	e8 35 ea ff ff       	call   8002d1 <_panic>

0080189c <shrink>:

}
void shrink(uint32 newSize)
{
  80189c:	55                   	push   %ebp
  80189d:	89 e5                	mov    %esp,%ebp
  80189f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a2:	83 ec 04             	sub    $0x4,%esp
  8018a5:	68 f0 3b 80 00       	push   $0x803bf0
  8018aa:	68 27 01 00 00       	push   $0x127
  8018af:	68 73 3b 80 00       	push   $0x803b73
  8018b4:	e8 18 ea ff ff       	call   8002d1 <_panic>

008018b9 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018b9:	55                   	push   %ebp
  8018ba:	89 e5                	mov    %esp,%ebp
  8018bc:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018bf:	83 ec 04             	sub    $0x4,%esp
  8018c2:	68 f0 3b 80 00       	push   $0x803bf0
  8018c7:	68 2c 01 00 00       	push   $0x12c
  8018cc:	68 73 3b 80 00       	push   $0x803b73
  8018d1:	e8 fb e9 ff ff       	call   8002d1 <_panic>

008018d6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
  8018d9:	57                   	push   %edi
  8018da:	56                   	push   %esi
  8018db:	53                   	push   %ebx
  8018dc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018e8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018eb:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018ee:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018f1:	cd 30                	int    $0x30
  8018f3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018f9:	83 c4 10             	add    $0x10,%esp
  8018fc:	5b                   	pop    %ebx
  8018fd:	5e                   	pop    %esi
  8018fe:	5f                   	pop    %edi
  8018ff:	5d                   	pop    %ebp
  801900:	c3                   	ret    

00801901 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801901:	55                   	push   %ebp
  801902:	89 e5                	mov    %esp,%ebp
  801904:	83 ec 04             	sub    $0x4,%esp
  801907:	8b 45 10             	mov    0x10(%ebp),%eax
  80190a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80190d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	52                   	push   %edx
  801919:	ff 75 0c             	pushl  0xc(%ebp)
  80191c:	50                   	push   %eax
  80191d:	6a 00                	push   $0x0
  80191f:	e8 b2 ff ff ff       	call   8018d6 <syscall>
  801924:	83 c4 18             	add    $0x18,%esp
}
  801927:	90                   	nop
  801928:	c9                   	leave  
  801929:	c3                   	ret    

0080192a <sys_cgetc>:

int
sys_cgetc(void)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 01                	push   $0x1
  801939:	e8 98 ff ff ff       	call   8018d6 <syscall>
  80193e:	83 c4 18             	add    $0x18,%esp
}
  801941:	c9                   	leave  
  801942:	c3                   	ret    

00801943 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801943:	55                   	push   %ebp
  801944:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801946:	8b 55 0c             	mov    0xc(%ebp),%edx
  801949:	8b 45 08             	mov    0x8(%ebp),%eax
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	52                   	push   %edx
  801953:	50                   	push   %eax
  801954:	6a 05                	push   $0x5
  801956:	e8 7b ff ff ff       	call   8018d6 <syscall>
  80195b:	83 c4 18             	add    $0x18,%esp
}
  80195e:	c9                   	leave  
  80195f:	c3                   	ret    

00801960 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801960:	55                   	push   %ebp
  801961:	89 e5                	mov    %esp,%ebp
  801963:	56                   	push   %esi
  801964:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801965:	8b 75 18             	mov    0x18(%ebp),%esi
  801968:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80196b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80196e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801971:	8b 45 08             	mov    0x8(%ebp),%eax
  801974:	56                   	push   %esi
  801975:	53                   	push   %ebx
  801976:	51                   	push   %ecx
  801977:	52                   	push   %edx
  801978:	50                   	push   %eax
  801979:	6a 06                	push   $0x6
  80197b:	e8 56 ff ff ff       	call   8018d6 <syscall>
  801980:	83 c4 18             	add    $0x18,%esp
}
  801983:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801986:	5b                   	pop    %ebx
  801987:	5e                   	pop    %esi
  801988:	5d                   	pop    %ebp
  801989:	c3                   	ret    

0080198a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80198a:	55                   	push   %ebp
  80198b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80198d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801990:	8b 45 08             	mov    0x8(%ebp),%eax
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	52                   	push   %edx
  80199a:	50                   	push   %eax
  80199b:	6a 07                	push   $0x7
  80199d:	e8 34 ff ff ff       	call   8018d6 <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	ff 75 0c             	pushl  0xc(%ebp)
  8019b3:	ff 75 08             	pushl  0x8(%ebp)
  8019b6:	6a 08                	push   $0x8
  8019b8:	e8 19 ff ff ff       	call   8018d6 <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	c9                   	leave  
  8019c1:	c3                   	ret    

008019c2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019c2:	55                   	push   %ebp
  8019c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 00                	push   $0x0
  8019cf:	6a 09                	push   $0x9
  8019d1:	e8 00 ff ff ff       	call   8018d6 <syscall>
  8019d6:	83 c4 18             	add    $0x18,%esp
}
  8019d9:	c9                   	leave  
  8019da:	c3                   	ret    

008019db <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019db:	55                   	push   %ebp
  8019dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 00                	push   $0x0
  8019e8:	6a 0a                	push   $0xa
  8019ea:	e8 e7 fe ff ff       	call   8018d6 <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 0b                	push   $0xb
  801a03:	e8 ce fe ff ff       	call   8018d6 <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
}
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	6a 00                	push   $0x0
  801a16:	ff 75 0c             	pushl  0xc(%ebp)
  801a19:	ff 75 08             	pushl  0x8(%ebp)
  801a1c:	6a 0f                	push   $0xf
  801a1e:	e8 b3 fe ff ff       	call   8018d6 <syscall>
  801a23:	83 c4 18             	add    $0x18,%esp
	return;
  801a26:	90                   	nop
}
  801a27:	c9                   	leave  
  801a28:	c3                   	ret    

00801a29 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a29:	55                   	push   %ebp
  801a2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	ff 75 0c             	pushl  0xc(%ebp)
  801a35:	ff 75 08             	pushl  0x8(%ebp)
  801a38:	6a 10                	push   $0x10
  801a3a:	e8 97 fe ff ff       	call   8018d6 <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a42:	90                   	nop
}
  801a43:	c9                   	leave  
  801a44:	c3                   	ret    

00801a45 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a45:	55                   	push   %ebp
  801a46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	ff 75 10             	pushl  0x10(%ebp)
  801a4f:	ff 75 0c             	pushl  0xc(%ebp)
  801a52:	ff 75 08             	pushl  0x8(%ebp)
  801a55:	6a 11                	push   $0x11
  801a57:	e8 7a fe ff ff       	call   8018d6 <syscall>
  801a5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5f:	90                   	nop
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 0c                	push   $0xc
  801a71:	e8 60 fe ff ff       	call   8018d6 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
}
  801a79:	c9                   	leave  
  801a7a:	c3                   	ret    

00801a7b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a7b:	55                   	push   %ebp
  801a7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a7e:	6a 00                	push   $0x0
  801a80:	6a 00                	push   $0x0
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	ff 75 08             	pushl  0x8(%ebp)
  801a89:	6a 0d                	push   $0xd
  801a8b:	e8 46 fe ff ff       	call   8018d6 <syscall>
  801a90:	83 c4 18             	add    $0x18,%esp
}
  801a93:	c9                   	leave  
  801a94:	c3                   	ret    

00801a95 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a95:	55                   	push   %ebp
  801a96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 0e                	push   $0xe
  801aa4:	e8 2d fe ff ff       	call   8018d6 <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	90                   	nop
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 13                	push   $0x13
  801abe:	e8 13 fe ff ff       	call   8018d6 <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	90                   	nop
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 14                	push   $0x14
  801ad8:	e8 f9 fd ff ff       	call   8018d6 <syscall>
  801add:	83 c4 18             	add    $0x18,%esp
}
  801ae0:	90                   	nop
  801ae1:	c9                   	leave  
  801ae2:	c3                   	ret    

00801ae3 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ae3:	55                   	push   %ebp
  801ae4:	89 e5                	mov    %esp,%ebp
  801ae6:	83 ec 04             	sub    $0x4,%esp
  801ae9:	8b 45 08             	mov    0x8(%ebp),%eax
  801aec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aef:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	50                   	push   %eax
  801afc:	6a 15                	push   $0x15
  801afe:	e8 d3 fd ff ff       	call   8018d6 <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
}
  801b06:	90                   	nop
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b0c:	6a 00                	push   $0x0
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 16                	push   $0x16
  801b18:	e8 b9 fd ff ff       	call   8018d6 <syscall>
  801b1d:	83 c4 18             	add    $0x18,%esp
}
  801b20:	90                   	nop
  801b21:	c9                   	leave  
  801b22:	c3                   	ret    

00801b23 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b23:	55                   	push   %ebp
  801b24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	ff 75 0c             	pushl  0xc(%ebp)
  801b32:	50                   	push   %eax
  801b33:	6a 17                	push   $0x17
  801b35:	e8 9c fd ff ff       	call   8018d6 <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b45:	8b 45 08             	mov    0x8(%ebp),%eax
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	52                   	push   %edx
  801b4f:	50                   	push   %eax
  801b50:	6a 1a                	push   $0x1a
  801b52:	e8 7f fd ff ff       	call   8018d6 <syscall>
  801b57:	83 c4 18             	add    $0x18,%esp
}
  801b5a:	c9                   	leave  
  801b5b:	c3                   	ret    

00801b5c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b5c:	55                   	push   %ebp
  801b5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b62:	8b 45 08             	mov    0x8(%ebp),%eax
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	52                   	push   %edx
  801b6c:	50                   	push   %eax
  801b6d:	6a 18                	push   $0x18
  801b6f:	e8 62 fd ff ff       	call   8018d6 <syscall>
  801b74:	83 c4 18             	add    $0x18,%esp
}
  801b77:	90                   	nop
  801b78:	c9                   	leave  
  801b79:	c3                   	ret    

00801b7a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b7a:	55                   	push   %ebp
  801b7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b80:	8b 45 08             	mov    0x8(%ebp),%eax
  801b83:	6a 00                	push   $0x0
  801b85:	6a 00                	push   $0x0
  801b87:	6a 00                	push   $0x0
  801b89:	52                   	push   %edx
  801b8a:	50                   	push   %eax
  801b8b:	6a 19                	push   $0x19
  801b8d:	e8 44 fd ff ff       	call   8018d6 <syscall>
  801b92:	83 c4 18             	add    $0x18,%esp
}
  801b95:	90                   	nop
  801b96:	c9                   	leave  
  801b97:	c3                   	ret    

00801b98 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b98:	55                   	push   %ebp
  801b99:	89 e5                	mov    %esp,%ebp
  801b9b:	83 ec 04             	sub    $0x4,%esp
  801b9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801ba1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ba4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ba7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bab:	8b 45 08             	mov    0x8(%ebp),%eax
  801bae:	6a 00                	push   $0x0
  801bb0:	51                   	push   %ecx
  801bb1:	52                   	push   %edx
  801bb2:	ff 75 0c             	pushl  0xc(%ebp)
  801bb5:	50                   	push   %eax
  801bb6:	6a 1b                	push   $0x1b
  801bb8:	e8 19 fd ff ff       	call   8018d6 <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	52                   	push   %edx
  801bd2:	50                   	push   %eax
  801bd3:	6a 1c                	push   $0x1c
  801bd5:	e8 fc fc ff ff       	call   8018d6 <syscall>
  801bda:	83 c4 18             	add    $0x18,%esp
}
  801bdd:	c9                   	leave  
  801bde:	c3                   	ret    

00801bdf <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bdf:	55                   	push   %ebp
  801be0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801be2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801be5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be8:	8b 45 08             	mov    0x8(%ebp),%eax
  801beb:	6a 00                	push   $0x0
  801bed:	6a 00                	push   $0x0
  801bef:	51                   	push   %ecx
  801bf0:	52                   	push   %edx
  801bf1:	50                   	push   %eax
  801bf2:	6a 1d                	push   $0x1d
  801bf4:	e8 dd fc ff ff       	call   8018d6 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	52                   	push   %edx
  801c0e:	50                   	push   %eax
  801c0f:	6a 1e                	push   $0x1e
  801c11:	e8 c0 fc ff ff       	call   8018d6 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 1f                	push   $0x1f
  801c2a:	e8 a7 fc ff ff       	call   8018d6 <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c37:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3a:	6a 00                	push   $0x0
  801c3c:	ff 75 14             	pushl  0x14(%ebp)
  801c3f:	ff 75 10             	pushl  0x10(%ebp)
  801c42:	ff 75 0c             	pushl  0xc(%ebp)
  801c45:	50                   	push   %eax
  801c46:	6a 20                	push   $0x20
  801c48:	e8 89 fc ff ff       	call   8018d6 <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
}
  801c50:	c9                   	leave  
  801c51:	c3                   	ret    

00801c52 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c52:	55                   	push   %ebp
  801c53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c55:	8b 45 08             	mov    0x8(%ebp),%eax
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	50                   	push   %eax
  801c61:	6a 21                	push   $0x21
  801c63:	e8 6e fc ff ff       	call   8018d6 <syscall>
  801c68:	83 c4 18             	add    $0x18,%esp
}
  801c6b:	90                   	nop
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c71:	8b 45 08             	mov    0x8(%ebp),%eax
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	50                   	push   %eax
  801c7d:	6a 22                	push   $0x22
  801c7f:	e8 52 fc ff ff       	call   8018d6 <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 00                	push   $0x0
  801c96:	6a 02                	push   $0x2
  801c98:	e8 39 fc ff ff       	call   8018d6 <syscall>
  801c9d:	83 c4 18             	add    $0x18,%esp
}
  801ca0:	c9                   	leave  
  801ca1:	c3                   	ret    

00801ca2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ca2:	55                   	push   %ebp
  801ca3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 00                	push   $0x0
  801caf:	6a 03                	push   $0x3
  801cb1:	e8 20 fc ff ff       	call   8018d6 <syscall>
  801cb6:	83 c4 18             	add    $0x18,%esp
}
  801cb9:	c9                   	leave  
  801cba:	c3                   	ret    

00801cbb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cbb:	55                   	push   %ebp
  801cbc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 04                	push   $0x4
  801cca:	e8 07 fc ff ff       	call   8018d6 <syscall>
  801ccf:	83 c4 18             	add    $0x18,%esp
}
  801cd2:	c9                   	leave  
  801cd3:	c3                   	ret    

00801cd4 <sys_exit_env>:


void sys_exit_env(void)
{
  801cd4:	55                   	push   %ebp
  801cd5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cd7:	6a 00                	push   $0x0
  801cd9:	6a 00                	push   $0x0
  801cdb:	6a 00                	push   $0x0
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 23                	push   $0x23
  801ce3:	e8 ee fb ff ff       	call   8018d6 <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
}
  801ceb:	90                   	nop
  801cec:	c9                   	leave  
  801ced:	c3                   	ret    

00801cee <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cee:	55                   	push   %ebp
  801cef:	89 e5                	mov    %esp,%ebp
  801cf1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cf4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cf7:	8d 50 04             	lea    0x4(%eax),%edx
  801cfa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cfd:	6a 00                	push   $0x0
  801cff:	6a 00                	push   $0x0
  801d01:	6a 00                	push   $0x0
  801d03:	52                   	push   %edx
  801d04:	50                   	push   %eax
  801d05:	6a 24                	push   $0x24
  801d07:	e8 ca fb ff ff       	call   8018d6 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
	return result;
  801d0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d18:	89 01                	mov    %eax,(%ecx)
  801d1a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d20:	c9                   	leave  
  801d21:	c2 04 00             	ret    $0x4

00801d24 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	ff 75 10             	pushl  0x10(%ebp)
  801d2e:	ff 75 0c             	pushl  0xc(%ebp)
  801d31:	ff 75 08             	pushl  0x8(%ebp)
  801d34:	6a 12                	push   $0x12
  801d36:	e8 9b fb ff ff       	call   8018d6 <syscall>
  801d3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3e:	90                   	nop
}
  801d3f:	c9                   	leave  
  801d40:	c3                   	ret    

00801d41 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d41:	55                   	push   %ebp
  801d42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	6a 25                	push   $0x25
  801d50:	e8 81 fb ff ff       	call   8018d6 <syscall>
  801d55:	83 c4 18             	add    $0x18,%esp
}
  801d58:	c9                   	leave  
  801d59:	c3                   	ret    

00801d5a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d5a:	55                   	push   %ebp
  801d5b:	89 e5                	mov    %esp,%ebp
  801d5d:	83 ec 04             	sub    $0x4,%esp
  801d60:	8b 45 08             	mov    0x8(%ebp),%eax
  801d63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d66:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	50                   	push   %eax
  801d73:	6a 26                	push   $0x26
  801d75:	e8 5c fb ff ff       	call   8018d6 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7d:	90                   	nop
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <rsttst>:
void rsttst()
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 28                	push   $0x28
  801d8f:	e8 42 fb ff ff       	call   8018d6 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
	return ;
  801d97:	90                   	nop
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
  801d9d:	83 ec 04             	sub    $0x4,%esp
  801da0:	8b 45 14             	mov    0x14(%ebp),%eax
  801da3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801da6:	8b 55 18             	mov    0x18(%ebp),%edx
  801da9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dad:	52                   	push   %edx
  801dae:	50                   	push   %eax
  801daf:	ff 75 10             	pushl  0x10(%ebp)
  801db2:	ff 75 0c             	pushl  0xc(%ebp)
  801db5:	ff 75 08             	pushl  0x8(%ebp)
  801db8:	6a 27                	push   $0x27
  801dba:	e8 17 fb ff ff       	call   8018d6 <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc2:	90                   	nop
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <chktst>:
void chktst(uint32 n)
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	ff 75 08             	pushl  0x8(%ebp)
  801dd3:	6a 29                	push   $0x29
  801dd5:	e8 fc fa ff ff       	call   8018d6 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddd:	90                   	nop
}
  801dde:	c9                   	leave  
  801ddf:	c3                   	ret    

00801de0 <inctst>:

void inctst()
{
  801de0:	55                   	push   %ebp
  801de1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 2a                	push   $0x2a
  801def:	e8 e2 fa ff ff       	call   8018d6 <syscall>
  801df4:	83 c4 18             	add    $0x18,%esp
	return ;
  801df7:	90                   	nop
}
  801df8:	c9                   	leave  
  801df9:	c3                   	ret    

00801dfa <gettst>:
uint32 gettst()
{
  801dfa:	55                   	push   %ebp
  801dfb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 2b                	push   $0x2b
  801e09:	e8 c8 fa ff ff       	call   8018d6 <syscall>
  801e0e:	83 c4 18             	add    $0x18,%esp
}
  801e11:	c9                   	leave  
  801e12:	c3                   	ret    

00801e13 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e13:	55                   	push   %ebp
  801e14:	89 e5                	mov    %esp,%ebp
  801e16:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 2c                	push   $0x2c
  801e25:	e8 ac fa ff ff       	call   8018d6 <syscall>
  801e2a:	83 c4 18             	add    $0x18,%esp
  801e2d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e30:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e34:	75 07                	jne    801e3d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e36:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3b:	eb 05                	jmp    801e42 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e3d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
  801e47:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 2c                	push   $0x2c
  801e56:	e8 7b fa ff ff       	call   8018d6 <syscall>
  801e5b:	83 c4 18             	add    $0x18,%esp
  801e5e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e61:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e65:	75 07                	jne    801e6e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e67:	b8 01 00 00 00       	mov    $0x1,%eax
  801e6c:	eb 05                	jmp    801e73 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e6e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e73:	c9                   	leave  
  801e74:	c3                   	ret    

00801e75 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e75:	55                   	push   %ebp
  801e76:	89 e5                	mov    %esp,%ebp
  801e78:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 2c                	push   $0x2c
  801e87:	e8 4a fa ff ff       	call   8018d6 <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
  801e8f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e92:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e96:	75 07                	jne    801e9f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e98:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9d:	eb 05                	jmp    801ea4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea4:	c9                   	leave  
  801ea5:	c3                   	ret    

00801ea6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ea6:	55                   	push   %ebp
  801ea7:	89 e5                	mov    %esp,%ebp
  801ea9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 2c                	push   $0x2c
  801eb8:	e8 19 fa ff ff       	call   8018d6 <syscall>
  801ebd:	83 c4 18             	add    $0x18,%esp
  801ec0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ec3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ec7:	75 07                	jne    801ed0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ec9:	b8 01 00 00 00       	mov    $0x1,%eax
  801ece:	eb 05                	jmp    801ed5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ed0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	ff 75 08             	pushl  0x8(%ebp)
  801ee5:	6a 2d                	push   $0x2d
  801ee7:	e8 ea f9 ff ff       	call   8018d6 <syscall>
  801eec:	83 c4 18             	add    $0x18,%esp
	return ;
  801eef:	90                   	nop
}
  801ef0:	c9                   	leave  
  801ef1:	c3                   	ret    

00801ef2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ef2:	55                   	push   %ebp
  801ef3:	89 e5                	mov    %esp,%ebp
  801ef5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ef6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ef9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801efc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eff:	8b 45 08             	mov    0x8(%ebp),%eax
  801f02:	6a 00                	push   $0x0
  801f04:	53                   	push   %ebx
  801f05:	51                   	push   %ecx
  801f06:	52                   	push   %edx
  801f07:	50                   	push   %eax
  801f08:	6a 2e                	push   $0x2e
  801f0a:	e8 c7 f9 ff ff       	call   8018d6 <syscall>
  801f0f:	83 c4 18             	add    $0x18,%esp
}
  801f12:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f15:	c9                   	leave  
  801f16:	c3                   	ret    

00801f17 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f17:	55                   	push   %ebp
  801f18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	6a 00                	push   $0x0
  801f22:	6a 00                	push   $0x0
  801f24:	6a 00                	push   $0x0
  801f26:	52                   	push   %edx
  801f27:	50                   	push   %eax
  801f28:	6a 2f                	push   $0x2f
  801f2a:	e8 a7 f9 ff ff       	call   8018d6 <syscall>
  801f2f:	83 c4 18             	add    $0x18,%esp
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f3a:	83 ec 0c             	sub    $0xc,%esp
  801f3d:	68 00 3c 80 00       	push   $0x803c00
  801f42:	e8 3e e6 ff ff       	call   800585 <cprintf>
  801f47:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f4a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f51:	83 ec 0c             	sub    $0xc,%esp
  801f54:	68 2c 3c 80 00       	push   $0x803c2c
  801f59:	e8 27 e6 ff ff       	call   800585 <cprintf>
  801f5e:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f61:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f65:	a1 38 41 80 00       	mov    0x804138,%eax
  801f6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6d:	eb 56                	jmp    801fc5 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f6f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f73:	74 1c                	je     801f91 <print_mem_block_lists+0x5d>
  801f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f78:	8b 50 08             	mov    0x8(%eax),%edx
  801f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f7e:	8b 48 08             	mov    0x8(%eax),%ecx
  801f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f84:	8b 40 0c             	mov    0xc(%eax),%eax
  801f87:	01 c8                	add    %ecx,%eax
  801f89:	39 c2                	cmp    %eax,%edx
  801f8b:	73 04                	jae    801f91 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f8d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f94:	8b 50 08             	mov    0x8(%eax),%edx
  801f97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9d:	01 c2                	add    %eax,%edx
  801f9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa2:	8b 40 08             	mov    0x8(%eax),%eax
  801fa5:	83 ec 04             	sub    $0x4,%esp
  801fa8:	52                   	push   %edx
  801fa9:	50                   	push   %eax
  801faa:	68 41 3c 80 00       	push   $0x803c41
  801faf:	e8 d1 e5 ff ff       	call   800585 <cprintf>
  801fb4:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fbd:	a1 40 41 80 00       	mov    0x804140,%eax
  801fc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fc9:	74 07                	je     801fd2 <print_mem_block_lists+0x9e>
  801fcb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fce:	8b 00                	mov    (%eax),%eax
  801fd0:	eb 05                	jmp    801fd7 <print_mem_block_lists+0xa3>
  801fd2:	b8 00 00 00 00       	mov    $0x0,%eax
  801fd7:	a3 40 41 80 00       	mov    %eax,0x804140
  801fdc:	a1 40 41 80 00       	mov    0x804140,%eax
  801fe1:	85 c0                	test   %eax,%eax
  801fe3:	75 8a                	jne    801f6f <print_mem_block_lists+0x3b>
  801fe5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe9:	75 84                	jne    801f6f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801feb:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fef:	75 10                	jne    802001 <print_mem_block_lists+0xcd>
  801ff1:	83 ec 0c             	sub    $0xc,%esp
  801ff4:	68 50 3c 80 00       	push   $0x803c50
  801ff9:	e8 87 e5 ff ff       	call   800585 <cprintf>
  801ffe:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802001:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802008:	83 ec 0c             	sub    $0xc,%esp
  80200b:	68 74 3c 80 00       	push   $0x803c74
  802010:	e8 70 e5 ff ff       	call   800585 <cprintf>
  802015:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802018:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80201c:	a1 40 40 80 00       	mov    0x804040,%eax
  802021:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802024:	eb 56                	jmp    80207c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802026:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80202a:	74 1c                	je     802048 <print_mem_block_lists+0x114>
  80202c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202f:	8b 50 08             	mov    0x8(%eax),%edx
  802032:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802035:	8b 48 08             	mov    0x8(%eax),%ecx
  802038:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203b:	8b 40 0c             	mov    0xc(%eax),%eax
  80203e:	01 c8                	add    %ecx,%eax
  802040:	39 c2                	cmp    %eax,%edx
  802042:	73 04                	jae    802048 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802044:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80204b:	8b 50 08             	mov    0x8(%eax),%edx
  80204e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802051:	8b 40 0c             	mov    0xc(%eax),%eax
  802054:	01 c2                	add    %eax,%edx
  802056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802059:	8b 40 08             	mov    0x8(%eax),%eax
  80205c:	83 ec 04             	sub    $0x4,%esp
  80205f:	52                   	push   %edx
  802060:	50                   	push   %eax
  802061:	68 41 3c 80 00       	push   $0x803c41
  802066:	e8 1a e5 ff ff       	call   800585 <cprintf>
  80206b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80206e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802071:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802074:	a1 48 40 80 00       	mov    0x804048,%eax
  802079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80207c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802080:	74 07                	je     802089 <print_mem_block_lists+0x155>
  802082:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802085:	8b 00                	mov    (%eax),%eax
  802087:	eb 05                	jmp    80208e <print_mem_block_lists+0x15a>
  802089:	b8 00 00 00 00       	mov    $0x0,%eax
  80208e:	a3 48 40 80 00       	mov    %eax,0x804048
  802093:	a1 48 40 80 00       	mov    0x804048,%eax
  802098:	85 c0                	test   %eax,%eax
  80209a:	75 8a                	jne    802026 <print_mem_block_lists+0xf2>
  80209c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a0:	75 84                	jne    802026 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020a2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020a6:	75 10                	jne    8020b8 <print_mem_block_lists+0x184>
  8020a8:	83 ec 0c             	sub    $0xc,%esp
  8020ab:	68 8c 3c 80 00       	push   $0x803c8c
  8020b0:	e8 d0 e4 ff ff       	call   800585 <cprintf>
  8020b5:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020b8:	83 ec 0c             	sub    $0xc,%esp
  8020bb:	68 00 3c 80 00       	push   $0x803c00
  8020c0:	e8 c0 e4 ff ff       	call   800585 <cprintf>
  8020c5:	83 c4 10             	add    $0x10,%esp

}
  8020c8:	90                   	nop
  8020c9:	c9                   	leave  
  8020ca:	c3                   	ret    

008020cb <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020cb:	55                   	push   %ebp
  8020cc:	89 e5                	mov    %esp,%ebp
  8020ce:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8020d1:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020d8:	00 00 00 
  8020db:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020e2:	00 00 00 
  8020e5:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020ec:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8020ef:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020f6:	e9 9e 00 00 00       	jmp    802199 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8020fb:	a1 50 40 80 00       	mov    0x804050,%eax
  802100:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802103:	c1 e2 04             	shl    $0x4,%edx
  802106:	01 d0                	add    %edx,%eax
  802108:	85 c0                	test   %eax,%eax
  80210a:	75 14                	jne    802120 <initialize_MemBlocksList+0x55>
  80210c:	83 ec 04             	sub    $0x4,%esp
  80210f:	68 b4 3c 80 00       	push   $0x803cb4
  802114:	6a 3d                	push   $0x3d
  802116:	68 d7 3c 80 00       	push   $0x803cd7
  80211b:	e8 b1 e1 ff ff       	call   8002d1 <_panic>
  802120:	a1 50 40 80 00       	mov    0x804050,%eax
  802125:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802128:	c1 e2 04             	shl    $0x4,%edx
  80212b:	01 d0                	add    %edx,%eax
  80212d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802133:	89 10                	mov    %edx,(%eax)
  802135:	8b 00                	mov    (%eax),%eax
  802137:	85 c0                	test   %eax,%eax
  802139:	74 18                	je     802153 <initialize_MemBlocksList+0x88>
  80213b:	a1 48 41 80 00       	mov    0x804148,%eax
  802140:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802146:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802149:	c1 e1 04             	shl    $0x4,%ecx
  80214c:	01 ca                	add    %ecx,%edx
  80214e:	89 50 04             	mov    %edx,0x4(%eax)
  802151:	eb 12                	jmp    802165 <initialize_MemBlocksList+0x9a>
  802153:	a1 50 40 80 00       	mov    0x804050,%eax
  802158:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80215b:	c1 e2 04             	shl    $0x4,%edx
  80215e:	01 d0                	add    %edx,%eax
  802160:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802165:	a1 50 40 80 00       	mov    0x804050,%eax
  80216a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216d:	c1 e2 04             	shl    $0x4,%edx
  802170:	01 d0                	add    %edx,%eax
  802172:	a3 48 41 80 00       	mov    %eax,0x804148
  802177:	a1 50 40 80 00       	mov    0x804050,%eax
  80217c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217f:	c1 e2 04             	shl    $0x4,%edx
  802182:	01 d0                	add    %edx,%eax
  802184:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80218b:	a1 54 41 80 00       	mov    0x804154,%eax
  802190:	40                   	inc    %eax
  802191:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802196:	ff 45 f4             	incl   -0xc(%ebp)
  802199:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80219c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80219f:	0f 82 56 ff ff ff    	jb     8020fb <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8021a5:	90                   	nop
  8021a6:	c9                   	leave  
  8021a7:	c3                   	ret    

008021a8 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021a8:	55                   	push   %ebp
  8021a9:	89 e5                	mov    %esp,%ebp
  8021ab:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8021ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b1:	8b 00                	mov    (%eax),%eax
  8021b3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8021b6:	eb 18                	jmp    8021d0 <find_block+0x28>

		if(tmp->sva == va){
  8021b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021bb:	8b 40 08             	mov    0x8(%eax),%eax
  8021be:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021c1:	75 05                	jne    8021c8 <find_block+0x20>
			return tmp ;
  8021c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021c6:	eb 11                	jmp    8021d9 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8021c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021cb:	8b 00                	mov    (%eax),%eax
  8021cd:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8021d0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021d4:	75 e2                	jne    8021b8 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8021d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021d9:	c9                   	leave  
  8021da:	c3                   	ret    

008021db <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021db:	55                   	push   %ebp
  8021dc:	89 e5                	mov    %esp,%ebp
  8021de:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8021e1:	a1 40 40 80 00       	mov    0x804040,%eax
  8021e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8021e9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8021f1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021f5:	75 65                	jne    80225c <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8021f7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021fb:	75 14                	jne    802211 <insert_sorted_allocList+0x36>
  8021fd:	83 ec 04             	sub    $0x4,%esp
  802200:	68 b4 3c 80 00       	push   $0x803cb4
  802205:	6a 62                	push   $0x62
  802207:	68 d7 3c 80 00       	push   $0x803cd7
  80220c:	e8 c0 e0 ff ff       	call   8002d1 <_panic>
  802211:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	89 10                	mov    %edx,(%eax)
  80221c:	8b 45 08             	mov    0x8(%ebp),%eax
  80221f:	8b 00                	mov    (%eax),%eax
  802221:	85 c0                	test   %eax,%eax
  802223:	74 0d                	je     802232 <insert_sorted_allocList+0x57>
  802225:	a1 40 40 80 00       	mov    0x804040,%eax
  80222a:	8b 55 08             	mov    0x8(%ebp),%edx
  80222d:	89 50 04             	mov    %edx,0x4(%eax)
  802230:	eb 08                	jmp    80223a <insert_sorted_allocList+0x5f>
  802232:	8b 45 08             	mov    0x8(%ebp),%eax
  802235:	a3 44 40 80 00       	mov    %eax,0x804044
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	a3 40 40 80 00       	mov    %eax,0x804040
  802242:	8b 45 08             	mov    0x8(%ebp),%eax
  802245:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80224c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802251:	40                   	inc    %eax
  802252:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802257:	e9 14 01 00 00       	jmp    802370 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80225c:	8b 45 08             	mov    0x8(%ebp),%eax
  80225f:	8b 50 08             	mov    0x8(%eax),%edx
  802262:	a1 44 40 80 00       	mov    0x804044,%eax
  802267:	8b 40 08             	mov    0x8(%eax),%eax
  80226a:	39 c2                	cmp    %eax,%edx
  80226c:	76 65                	jbe    8022d3 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80226e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802272:	75 14                	jne    802288 <insert_sorted_allocList+0xad>
  802274:	83 ec 04             	sub    $0x4,%esp
  802277:	68 f0 3c 80 00       	push   $0x803cf0
  80227c:	6a 64                	push   $0x64
  80227e:	68 d7 3c 80 00       	push   $0x803cd7
  802283:	e8 49 e0 ff ff       	call   8002d1 <_panic>
  802288:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80228e:	8b 45 08             	mov    0x8(%ebp),%eax
  802291:	89 50 04             	mov    %edx,0x4(%eax)
  802294:	8b 45 08             	mov    0x8(%ebp),%eax
  802297:	8b 40 04             	mov    0x4(%eax),%eax
  80229a:	85 c0                	test   %eax,%eax
  80229c:	74 0c                	je     8022aa <insert_sorted_allocList+0xcf>
  80229e:	a1 44 40 80 00       	mov    0x804044,%eax
  8022a3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022a6:	89 10                	mov    %edx,(%eax)
  8022a8:	eb 08                	jmp    8022b2 <insert_sorted_allocList+0xd7>
  8022aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ad:	a3 40 40 80 00       	mov    %eax,0x804040
  8022b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b5:	a3 44 40 80 00       	mov    %eax,0x804044
  8022ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8022bd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022c3:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022c8:	40                   	inc    %eax
  8022c9:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8022ce:	e9 9d 00 00 00       	jmp    802370 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8022d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8022da:	e9 85 00 00 00       	jmp    802364 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8022df:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e2:	8b 50 08             	mov    0x8(%eax),%edx
  8022e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e8:	8b 40 08             	mov    0x8(%eax),%eax
  8022eb:	39 c2                	cmp    %eax,%edx
  8022ed:	73 6a                	jae    802359 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8022ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022f3:	74 06                	je     8022fb <insert_sorted_allocList+0x120>
  8022f5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022f9:	75 14                	jne    80230f <insert_sorted_allocList+0x134>
  8022fb:	83 ec 04             	sub    $0x4,%esp
  8022fe:	68 14 3d 80 00       	push   $0x803d14
  802303:	6a 6b                	push   $0x6b
  802305:	68 d7 3c 80 00       	push   $0x803cd7
  80230a:	e8 c2 df ff ff       	call   8002d1 <_panic>
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	8b 50 04             	mov    0x4(%eax),%edx
  802315:	8b 45 08             	mov    0x8(%ebp),%eax
  802318:	89 50 04             	mov    %edx,0x4(%eax)
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802321:	89 10                	mov    %edx,(%eax)
  802323:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802326:	8b 40 04             	mov    0x4(%eax),%eax
  802329:	85 c0                	test   %eax,%eax
  80232b:	74 0d                	je     80233a <insert_sorted_allocList+0x15f>
  80232d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802330:	8b 40 04             	mov    0x4(%eax),%eax
  802333:	8b 55 08             	mov    0x8(%ebp),%edx
  802336:	89 10                	mov    %edx,(%eax)
  802338:	eb 08                	jmp    802342 <insert_sorted_allocList+0x167>
  80233a:	8b 45 08             	mov    0x8(%ebp),%eax
  80233d:	a3 40 40 80 00       	mov    %eax,0x804040
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	8b 55 08             	mov    0x8(%ebp),%edx
  802348:	89 50 04             	mov    %edx,0x4(%eax)
  80234b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802350:	40                   	inc    %eax
  802351:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  802356:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802357:	eb 17                	jmp    802370 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802359:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235c:	8b 00                	mov    (%eax),%eax
  80235e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802361:	ff 45 f0             	incl   -0x10(%ebp)
  802364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802367:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80236a:	0f 8c 6f ff ff ff    	jl     8022df <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802370:	90                   	nop
  802371:	c9                   	leave  
  802372:	c3                   	ret    

00802373 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802373:	55                   	push   %ebp
  802374:	89 e5                	mov    %esp,%ebp
  802376:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802379:	a1 38 41 80 00       	mov    0x804138,%eax
  80237e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802381:	e9 7c 01 00 00       	jmp    802502 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802386:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802389:	8b 40 0c             	mov    0xc(%eax),%eax
  80238c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80238f:	0f 86 cf 00 00 00    	jbe    802464 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802395:	a1 48 41 80 00       	mov    0x804148,%eax
  80239a:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  80239d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023a0:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8023a3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8023a9:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	8b 50 08             	mov    0x8(%eax),%edx
  8023b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b5:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8023b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bb:	8b 40 0c             	mov    0xc(%eax),%eax
  8023be:	2b 45 08             	sub    0x8(%ebp),%eax
  8023c1:	89 c2                	mov    %eax,%edx
  8023c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c6:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	8b 50 08             	mov    0x8(%eax),%edx
  8023cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d2:	01 c2                	add    %eax,%edx
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8023da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023de:	75 17                	jne    8023f7 <alloc_block_FF+0x84>
  8023e0:	83 ec 04             	sub    $0x4,%esp
  8023e3:	68 49 3d 80 00       	push   $0x803d49
  8023e8:	68 83 00 00 00       	push   $0x83
  8023ed:	68 d7 3c 80 00       	push   $0x803cd7
  8023f2:	e8 da de ff ff       	call   8002d1 <_panic>
  8023f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023fa:	8b 00                	mov    (%eax),%eax
  8023fc:	85 c0                	test   %eax,%eax
  8023fe:	74 10                	je     802410 <alloc_block_FF+0x9d>
  802400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802403:	8b 00                	mov    (%eax),%eax
  802405:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802408:	8b 52 04             	mov    0x4(%edx),%edx
  80240b:	89 50 04             	mov    %edx,0x4(%eax)
  80240e:	eb 0b                	jmp    80241b <alloc_block_FF+0xa8>
  802410:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802413:	8b 40 04             	mov    0x4(%eax),%eax
  802416:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80241b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241e:	8b 40 04             	mov    0x4(%eax),%eax
  802421:	85 c0                	test   %eax,%eax
  802423:	74 0f                	je     802434 <alloc_block_FF+0xc1>
  802425:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802428:	8b 40 04             	mov    0x4(%eax),%eax
  80242b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80242e:	8b 12                	mov    (%edx),%edx
  802430:	89 10                	mov    %edx,(%eax)
  802432:	eb 0a                	jmp    80243e <alloc_block_FF+0xcb>
  802434:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802437:	8b 00                	mov    (%eax),%eax
  802439:	a3 48 41 80 00       	mov    %eax,0x804148
  80243e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802441:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802447:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802451:	a1 54 41 80 00       	mov    0x804154,%eax
  802456:	48                   	dec    %eax
  802457:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  80245c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245f:	e9 ad 00 00 00       	jmp    802511 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 40 0c             	mov    0xc(%eax),%eax
  80246a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80246d:	0f 85 87 00 00 00    	jne    8024fa <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802473:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802477:	75 17                	jne    802490 <alloc_block_FF+0x11d>
  802479:	83 ec 04             	sub    $0x4,%esp
  80247c:	68 49 3d 80 00       	push   $0x803d49
  802481:	68 87 00 00 00       	push   $0x87
  802486:	68 d7 3c 80 00       	push   $0x803cd7
  80248b:	e8 41 de ff ff       	call   8002d1 <_panic>
  802490:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802493:	8b 00                	mov    (%eax),%eax
  802495:	85 c0                	test   %eax,%eax
  802497:	74 10                	je     8024a9 <alloc_block_FF+0x136>
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 00                	mov    (%eax),%eax
  80249e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a1:	8b 52 04             	mov    0x4(%edx),%edx
  8024a4:	89 50 04             	mov    %edx,0x4(%eax)
  8024a7:	eb 0b                	jmp    8024b4 <alloc_block_FF+0x141>
  8024a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ac:	8b 40 04             	mov    0x4(%eax),%eax
  8024af:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	74 0f                	je     8024cd <alloc_block_FF+0x15a>
  8024be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c1:	8b 40 04             	mov    0x4(%eax),%eax
  8024c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024c7:	8b 12                	mov    (%edx),%edx
  8024c9:	89 10                	mov    %edx,(%eax)
  8024cb:	eb 0a                	jmp    8024d7 <alloc_block_FF+0x164>
  8024cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d0:	8b 00                	mov    (%eax),%eax
  8024d2:	a3 38 41 80 00       	mov    %eax,0x804138
  8024d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ea:	a1 44 41 80 00       	mov    0x804144,%eax
  8024ef:	48                   	dec    %eax
  8024f0:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8024f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f8:	eb 17                	jmp    802511 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8024fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fd:	8b 00                	mov    (%eax),%eax
  8024ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802502:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802506:	0f 85 7a fe ff ff    	jne    802386 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  80250c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
  802516:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802519:	a1 38 41 80 00       	mov    0x804138,%eax
  80251e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802521:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802528:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80252f:	a1 38 41 80 00       	mov    0x804138,%eax
  802534:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802537:	e9 d0 00 00 00       	jmp    80260c <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 40 0c             	mov    0xc(%eax),%eax
  802542:	3b 45 08             	cmp    0x8(%ebp),%eax
  802545:	0f 82 b8 00 00 00    	jb     802603 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  80254b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254e:	8b 40 0c             	mov    0xc(%eax),%eax
  802551:	2b 45 08             	sub    0x8(%ebp),%eax
  802554:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802557:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80255a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80255d:	0f 83 a1 00 00 00    	jae    802604 <alloc_block_BF+0xf1>
				differsize = differance ;
  802563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802566:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80256f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802573:	0f 85 8b 00 00 00    	jne    802604 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802579:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80257d:	75 17                	jne    802596 <alloc_block_BF+0x83>
  80257f:	83 ec 04             	sub    $0x4,%esp
  802582:	68 49 3d 80 00       	push   $0x803d49
  802587:	68 a0 00 00 00       	push   $0xa0
  80258c:	68 d7 3c 80 00       	push   $0x803cd7
  802591:	e8 3b dd ff ff       	call   8002d1 <_panic>
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	8b 00                	mov    (%eax),%eax
  80259b:	85 c0                	test   %eax,%eax
  80259d:	74 10                	je     8025af <alloc_block_BF+0x9c>
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	8b 00                	mov    (%eax),%eax
  8025a4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a7:	8b 52 04             	mov    0x4(%edx),%edx
  8025aa:	89 50 04             	mov    %edx,0x4(%eax)
  8025ad:	eb 0b                	jmp    8025ba <alloc_block_BF+0xa7>
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 40 04             	mov    0x4(%eax),%eax
  8025b5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	8b 40 04             	mov    0x4(%eax),%eax
  8025c0:	85 c0                	test   %eax,%eax
  8025c2:	74 0f                	je     8025d3 <alloc_block_BF+0xc0>
  8025c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c7:	8b 40 04             	mov    0x4(%eax),%eax
  8025ca:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cd:	8b 12                	mov    (%edx),%edx
  8025cf:	89 10                	mov    %edx,(%eax)
  8025d1:	eb 0a                	jmp    8025dd <alloc_block_BF+0xca>
  8025d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d6:	8b 00                	mov    (%eax),%eax
  8025d8:	a3 38 41 80 00       	mov    %eax,0x804138
  8025dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025f0:	a1 44 41 80 00       	mov    0x804144,%eax
  8025f5:	48                   	dec    %eax
  8025f6:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	e9 0c 01 00 00       	jmp    80270f <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802603:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802604:	a1 40 41 80 00       	mov    0x804140,%eax
  802609:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80260c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802610:	74 07                	je     802619 <alloc_block_BF+0x106>
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	8b 00                	mov    (%eax),%eax
  802617:	eb 05                	jmp    80261e <alloc_block_BF+0x10b>
  802619:	b8 00 00 00 00       	mov    $0x0,%eax
  80261e:	a3 40 41 80 00       	mov    %eax,0x804140
  802623:	a1 40 41 80 00       	mov    0x804140,%eax
  802628:	85 c0                	test   %eax,%eax
  80262a:	0f 85 0c ff ff ff    	jne    80253c <alloc_block_BF+0x29>
  802630:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802634:	0f 85 02 ff ff ff    	jne    80253c <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  80263a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80263e:	0f 84 c6 00 00 00    	je     80270a <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802644:	a1 48 41 80 00       	mov    0x804148,%eax
  802649:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  80264c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80264f:	8b 55 08             	mov    0x8(%ebp),%edx
  802652:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802655:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802658:	8b 50 08             	mov    0x8(%eax),%edx
  80265b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265e:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802661:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802664:	8b 40 0c             	mov    0xc(%eax),%eax
  802667:	2b 45 08             	sub    0x8(%ebp),%eax
  80266a:	89 c2                	mov    %eax,%edx
  80266c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266f:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802672:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802675:	8b 50 08             	mov    0x8(%eax),%edx
  802678:	8b 45 08             	mov    0x8(%ebp),%eax
  80267b:	01 c2                	add    %eax,%edx
  80267d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802680:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802683:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802687:	75 17                	jne    8026a0 <alloc_block_BF+0x18d>
  802689:	83 ec 04             	sub    $0x4,%esp
  80268c:	68 49 3d 80 00       	push   $0x803d49
  802691:	68 af 00 00 00       	push   $0xaf
  802696:	68 d7 3c 80 00       	push   $0x803cd7
  80269b:	e8 31 dc ff ff       	call   8002d1 <_panic>
  8026a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a3:	8b 00                	mov    (%eax),%eax
  8026a5:	85 c0                	test   %eax,%eax
  8026a7:	74 10                	je     8026b9 <alloc_block_BF+0x1a6>
  8026a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ac:	8b 00                	mov    (%eax),%eax
  8026ae:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026b1:	8b 52 04             	mov    0x4(%edx),%edx
  8026b4:	89 50 04             	mov    %edx,0x4(%eax)
  8026b7:	eb 0b                	jmp    8026c4 <alloc_block_BF+0x1b1>
  8026b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026bc:	8b 40 04             	mov    0x4(%eax),%eax
  8026bf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c7:	8b 40 04             	mov    0x4(%eax),%eax
  8026ca:	85 c0                	test   %eax,%eax
  8026cc:	74 0f                	je     8026dd <alloc_block_BF+0x1ca>
  8026ce:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026d1:	8b 40 04             	mov    0x4(%eax),%eax
  8026d4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026d7:	8b 12                	mov    (%edx),%edx
  8026d9:	89 10                	mov    %edx,(%eax)
  8026db:	eb 0a                	jmp    8026e7 <alloc_block_BF+0x1d4>
  8026dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e0:	8b 00                	mov    (%eax),%eax
  8026e2:	a3 48 41 80 00       	mov    %eax,0x804148
  8026e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ea:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026fa:	a1 54 41 80 00       	mov    0x804154,%eax
  8026ff:	48                   	dec    %eax
  802700:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  802705:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802708:	eb 05                	jmp    80270f <alloc_block_BF+0x1fc>
	}

	return NULL;
  80270a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80270f:	c9                   	leave  
  802710:	c3                   	ret    

00802711 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802711:	55                   	push   %ebp
  802712:	89 e5                	mov    %esp,%ebp
  802714:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802717:	a1 38 41 80 00       	mov    0x804138,%eax
  80271c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  80271f:	e9 7c 01 00 00       	jmp    8028a0 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802724:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802727:	8b 40 0c             	mov    0xc(%eax),%eax
  80272a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80272d:	0f 86 cf 00 00 00    	jbe    802802 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802733:	a1 48 41 80 00       	mov    0x804148,%eax
  802738:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  80273b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273e:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802741:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802744:	8b 55 08             	mov    0x8(%ebp),%edx
  802747:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	8b 50 08             	mov    0x8(%eax),%edx
  802750:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802753:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802759:	8b 40 0c             	mov    0xc(%eax),%eax
  80275c:	2b 45 08             	sub    0x8(%ebp),%eax
  80275f:	89 c2                	mov    %eax,%edx
  802761:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802764:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802767:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276a:	8b 50 08             	mov    0x8(%eax),%edx
  80276d:	8b 45 08             	mov    0x8(%ebp),%eax
  802770:	01 c2                	add    %eax,%edx
  802772:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802775:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802778:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80277c:	75 17                	jne    802795 <alloc_block_NF+0x84>
  80277e:	83 ec 04             	sub    $0x4,%esp
  802781:	68 49 3d 80 00       	push   $0x803d49
  802786:	68 c4 00 00 00       	push   $0xc4
  80278b:	68 d7 3c 80 00       	push   $0x803cd7
  802790:	e8 3c db ff ff       	call   8002d1 <_panic>
  802795:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802798:	8b 00                	mov    (%eax),%eax
  80279a:	85 c0                	test   %eax,%eax
  80279c:	74 10                	je     8027ae <alloc_block_NF+0x9d>
  80279e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a1:	8b 00                	mov    (%eax),%eax
  8027a3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027a6:	8b 52 04             	mov    0x4(%edx),%edx
  8027a9:	89 50 04             	mov    %edx,0x4(%eax)
  8027ac:	eb 0b                	jmp    8027b9 <alloc_block_NF+0xa8>
  8027ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b1:	8b 40 04             	mov    0x4(%eax),%eax
  8027b4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bc:	8b 40 04             	mov    0x4(%eax),%eax
  8027bf:	85 c0                	test   %eax,%eax
  8027c1:	74 0f                	je     8027d2 <alloc_block_NF+0xc1>
  8027c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c6:	8b 40 04             	mov    0x4(%eax),%eax
  8027c9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027cc:	8b 12                	mov    (%edx),%edx
  8027ce:	89 10                	mov    %edx,(%eax)
  8027d0:	eb 0a                	jmp    8027dc <alloc_block_NF+0xcb>
  8027d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	a3 48 41 80 00       	mov    %eax,0x804148
  8027dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ef:	a1 54 41 80 00       	mov    0x804154,%eax
  8027f4:	48                   	dec    %eax
  8027f5:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8027fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fd:	e9 ad 00 00 00       	jmp    8028af <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 40 0c             	mov    0xc(%eax),%eax
  802808:	3b 45 08             	cmp    0x8(%ebp),%eax
  80280b:	0f 85 87 00 00 00    	jne    802898 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802811:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802815:	75 17                	jne    80282e <alloc_block_NF+0x11d>
  802817:	83 ec 04             	sub    $0x4,%esp
  80281a:	68 49 3d 80 00       	push   $0x803d49
  80281f:	68 c8 00 00 00       	push   $0xc8
  802824:	68 d7 3c 80 00       	push   $0x803cd7
  802829:	e8 a3 da ff ff       	call   8002d1 <_panic>
  80282e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802831:	8b 00                	mov    (%eax),%eax
  802833:	85 c0                	test   %eax,%eax
  802835:	74 10                	je     802847 <alloc_block_NF+0x136>
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80283f:	8b 52 04             	mov    0x4(%edx),%edx
  802842:	89 50 04             	mov    %edx,0x4(%eax)
  802845:	eb 0b                	jmp    802852 <alloc_block_NF+0x141>
  802847:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284a:	8b 40 04             	mov    0x4(%eax),%eax
  80284d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	8b 40 04             	mov    0x4(%eax),%eax
  802858:	85 c0                	test   %eax,%eax
  80285a:	74 0f                	je     80286b <alloc_block_NF+0x15a>
  80285c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285f:	8b 40 04             	mov    0x4(%eax),%eax
  802862:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802865:	8b 12                	mov    (%edx),%edx
  802867:	89 10                	mov    %edx,(%eax)
  802869:	eb 0a                	jmp    802875 <alloc_block_NF+0x164>
  80286b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286e:	8b 00                	mov    (%eax),%eax
  802870:	a3 38 41 80 00       	mov    %eax,0x804138
  802875:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802878:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802881:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802888:	a1 44 41 80 00       	mov    0x804144,%eax
  80288d:	48                   	dec    %eax
  80288e:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802893:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802896:	eb 17                	jmp    8028af <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802898:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289b:	8b 00                	mov    (%eax),%eax
  80289d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  8028a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a4:	0f 85 7a fe ff ff    	jne    802724 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  8028aa:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8028af:	c9                   	leave  
  8028b0:	c3                   	ret    

008028b1 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8028b1:	55                   	push   %ebp
  8028b2:	89 e5                	mov    %esp,%ebp
  8028b4:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  8028b7:	a1 38 41 80 00       	mov    0x804138,%eax
  8028bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8028bf:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028c4:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8028c7:	a1 44 41 80 00       	mov    0x804144,%eax
  8028cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8028cf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028d3:	75 68                	jne    80293d <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8028d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028d9:	75 17                	jne    8028f2 <insert_sorted_with_merge_freeList+0x41>
  8028db:	83 ec 04             	sub    $0x4,%esp
  8028de:	68 b4 3c 80 00       	push   $0x803cb4
  8028e3:	68 da 00 00 00       	push   $0xda
  8028e8:	68 d7 3c 80 00       	push   $0x803cd7
  8028ed:	e8 df d9 ff ff       	call   8002d1 <_panic>
  8028f2:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fb:	89 10                	mov    %edx,(%eax)
  8028fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802900:	8b 00                	mov    (%eax),%eax
  802902:	85 c0                	test   %eax,%eax
  802904:	74 0d                	je     802913 <insert_sorted_with_merge_freeList+0x62>
  802906:	a1 38 41 80 00       	mov    0x804138,%eax
  80290b:	8b 55 08             	mov    0x8(%ebp),%edx
  80290e:	89 50 04             	mov    %edx,0x4(%eax)
  802911:	eb 08                	jmp    80291b <insert_sorted_with_merge_freeList+0x6a>
  802913:	8b 45 08             	mov    0x8(%ebp),%eax
  802916:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80291b:	8b 45 08             	mov    0x8(%ebp),%eax
  80291e:	a3 38 41 80 00       	mov    %eax,0x804138
  802923:	8b 45 08             	mov    0x8(%ebp),%eax
  802926:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80292d:	a1 44 41 80 00       	mov    0x804144,%eax
  802932:	40                   	inc    %eax
  802933:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  802938:	e9 49 07 00 00       	jmp    803086 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  80293d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802940:	8b 50 08             	mov    0x8(%eax),%edx
  802943:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802946:	8b 40 0c             	mov    0xc(%eax),%eax
  802949:	01 c2                	add    %eax,%edx
  80294b:	8b 45 08             	mov    0x8(%ebp),%eax
  80294e:	8b 40 08             	mov    0x8(%eax),%eax
  802951:	39 c2                	cmp    %eax,%edx
  802953:	73 77                	jae    8029cc <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802958:	8b 00                	mov    (%eax),%eax
  80295a:	85 c0                	test   %eax,%eax
  80295c:	75 6e                	jne    8029cc <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  80295e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802962:	74 68                	je     8029cc <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802964:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802968:	75 17                	jne    802981 <insert_sorted_with_merge_freeList+0xd0>
  80296a:	83 ec 04             	sub    $0x4,%esp
  80296d:	68 f0 3c 80 00       	push   $0x803cf0
  802972:	68 e0 00 00 00       	push   $0xe0
  802977:	68 d7 3c 80 00       	push   $0x803cd7
  80297c:	e8 50 d9 ff ff       	call   8002d1 <_panic>
  802981:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	89 50 04             	mov    %edx,0x4(%eax)
  80298d:	8b 45 08             	mov    0x8(%ebp),%eax
  802990:	8b 40 04             	mov    0x4(%eax),%eax
  802993:	85 c0                	test   %eax,%eax
  802995:	74 0c                	je     8029a3 <insert_sorted_with_merge_freeList+0xf2>
  802997:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80299c:	8b 55 08             	mov    0x8(%ebp),%edx
  80299f:	89 10                	mov    %edx,(%eax)
  8029a1:	eb 08                	jmp    8029ab <insert_sorted_with_merge_freeList+0xfa>
  8029a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a6:	a3 38 41 80 00       	mov    %eax,0x804138
  8029ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ae:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029bc:	a1 44 41 80 00       	mov    0x804144,%eax
  8029c1:	40                   	inc    %eax
  8029c2:	a3 44 41 80 00       	mov    %eax,0x804144
  8029c7:	e9 ba 06 00 00       	jmp    803086 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	8b 50 0c             	mov    0xc(%eax),%edx
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	8b 40 08             	mov    0x8(%eax),%eax
  8029d8:	01 c2                	add    %eax,%edx
  8029da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029dd:	8b 40 08             	mov    0x8(%eax),%eax
  8029e0:	39 c2                	cmp    %eax,%edx
  8029e2:	73 78                	jae    802a5c <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8029e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e7:	8b 40 04             	mov    0x4(%eax),%eax
  8029ea:	85 c0                	test   %eax,%eax
  8029ec:	75 6e                	jne    802a5c <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8029ee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029f2:	74 68                	je     802a5c <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8029f4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029f8:	75 17                	jne    802a11 <insert_sorted_with_merge_freeList+0x160>
  8029fa:	83 ec 04             	sub    $0x4,%esp
  8029fd:	68 b4 3c 80 00       	push   $0x803cb4
  802a02:	68 e6 00 00 00       	push   $0xe6
  802a07:	68 d7 3c 80 00       	push   $0x803cd7
  802a0c:	e8 c0 d8 ff ff       	call   8002d1 <_panic>
  802a11:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	89 10                	mov    %edx,(%eax)
  802a1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1f:	8b 00                	mov    (%eax),%eax
  802a21:	85 c0                	test   %eax,%eax
  802a23:	74 0d                	je     802a32 <insert_sorted_with_merge_freeList+0x181>
  802a25:	a1 38 41 80 00       	mov    0x804138,%eax
  802a2a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a2d:	89 50 04             	mov    %edx,0x4(%eax)
  802a30:	eb 08                	jmp    802a3a <insert_sorted_with_merge_freeList+0x189>
  802a32:	8b 45 08             	mov    0x8(%ebp),%eax
  802a35:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3d:	a3 38 41 80 00       	mov    %eax,0x804138
  802a42:	8b 45 08             	mov    0x8(%ebp),%eax
  802a45:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a4c:	a1 44 41 80 00       	mov    0x804144,%eax
  802a51:	40                   	inc    %eax
  802a52:	a3 44 41 80 00       	mov    %eax,0x804144
  802a57:	e9 2a 06 00 00       	jmp    803086 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802a5c:	a1 38 41 80 00       	mov    0x804138,%eax
  802a61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a64:	e9 ed 05 00 00       	jmp    803056 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6c:	8b 00                	mov    (%eax),%eax
  802a6e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802a71:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a75:	0f 84 a7 00 00 00    	je     802b22 <insert_sorted_with_merge_freeList+0x271>
  802a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7e:	8b 50 0c             	mov    0xc(%eax),%edx
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 40 08             	mov    0x8(%eax),%eax
  802a87:	01 c2                	add    %eax,%edx
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	8b 40 08             	mov    0x8(%eax),%eax
  802a8f:	39 c2                	cmp    %eax,%edx
  802a91:	0f 83 8b 00 00 00    	jae    802b22 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	8b 50 0c             	mov    0xc(%eax),%edx
  802a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa0:	8b 40 08             	mov    0x8(%eax),%eax
  802aa3:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802aa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aa8:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802aab:	39 c2                	cmp    %eax,%edx
  802aad:	73 73                	jae    802b22 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802aaf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ab3:	74 06                	je     802abb <insert_sorted_with_merge_freeList+0x20a>
  802ab5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab9:	75 17                	jne    802ad2 <insert_sorted_with_merge_freeList+0x221>
  802abb:	83 ec 04             	sub    $0x4,%esp
  802abe:	68 68 3d 80 00       	push   $0x803d68
  802ac3:	68 f0 00 00 00       	push   $0xf0
  802ac8:	68 d7 3c 80 00       	push   $0x803cd7
  802acd:	e8 ff d7 ff ff       	call   8002d1 <_panic>
  802ad2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad5:	8b 10                	mov    (%eax),%edx
  802ad7:	8b 45 08             	mov    0x8(%ebp),%eax
  802ada:	89 10                	mov    %edx,(%eax)
  802adc:	8b 45 08             	mov    0x8(%ebp),%eax
  802adf:	8b 00                	mov    (%eax),%eax
  802ae1:	85 c0                	test   %eax,%eax
  802ae3:	74 0b                	je     802af0 <insert_sorted_with_merge_freeList+0x23f>
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 00                	mov    (%eax),%eax
  802aea:	8b 55 08             	mov    0x8(%ebp),%edx
  802aed:	89 50 04             	mov    %edx,0x4(%eax)
  802af0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af3:	8b 55 08             	mov    0x8(%ebp),%edx
  802af6:	89 10                	mov    %edx,(%eax)
  802af8:	8b 45 08             	mov    0x8(%ebp),%eax
  802afb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802afe:	89 50 04             	mov    %edx,0x4(%eax)
  802b01:	8b 45 08             	mov    0x8(%ebp),%eax
  802b04:	8b 00                	mov    (%eax),%eax
  802b06:	85 c0                	test   %eax,%eax
  802b08:	75 08                	jne    802b12 <insert_sorted_with_merge_freeList+0x261>
  802b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b12:	a1 44 41 80 00       	mov    0x804144,%eax
  802b17:	40                   	inc    %eax
  802b18:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802b1d:	e9 64 05 00 00       	jmp    803086 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802b22:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b27:	8b 50 0c             	mov    0xc(%eax),%edx
  802b2a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b2f:	8b 40 08             	mov    0x8(%eax),%eax
  802b32:	01 c2                	add    %eax,%edx
  802b34:	8b 45 08             	mov    0x8(%ebp),%eax
  802b37:	8b 40 08             	mov    0x8(%eax),%eax
  802b3a:	39 c2                	cmp    %eax,%edx
  802b3c:	0f 85 b1 00 00 00    	jne    802bf3 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802b42:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b47:	85 c0                	test   %eax,%eax
  802b49:	0f 84 a4 00 00 00    	je     802bf3 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802b4f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b54:	8b 00                	mov    (%eax),%eax
  802b56:	85 c0                	test   %eax,%eax
  802b58:	0f 85 95 00 00 00    	jne    802bf3 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802b5e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b63:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b69:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b6c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6f:	8b 52 0c             	mov    0xc(%edx),%edx
  802b72:	01 ca                	add    %ecx,%edx
  802b74:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802b81:	8b 45 08             	mov    0x8(%ebp),%eax
  802b84:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802b8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b8f:	75 17                	jne    802ba8 <insert_sorted_with_merge_freeList+0x2f7>
  802b91:	83 ec 04             	sub    $0x4,%esp
  802b94:	68 b4 3c 80 00       	push   $0x803cb4
  802b99:	68 ff 00 00 00       	push   $0xff
  802b9e:	68 d7 3c 80 00       	push   $0x803cd7
  802ba3:	e8 29 d7 ff ff       	call   8002d1 <_panic>
  802ba8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	89 10                	mov    %edx,(%eax)
  802bb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb6:	8b 00                	mov    (%eax),%eax
  802bb8:	85 c0                	test   %eax,%eax
  802bba:	74 0d                	je     802bc9 <insert_sorted_with_merge_freeList+0x318>
  802bbc:	a1 48 41 80 00       	mov    0x804148,%eax
  802bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc4:	89 50 04             	mov    %edx,0x4(%eax)
  802bc7:	eb 08                	jmp    802bd1 <insert_sorted_with_merge_freeList+0x320>
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd4:	a3 48 41 80 00       	mov    %eax,0x804148
  802bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802be3:	a1 54 41 80 00       	mov    0x804154,%eax
  802be8:	40                   	inc    %eax
  802be9:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802bee:	e9 93 04 00 00       	jmp    803086 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802bf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf6:	8b 50 08             	mov    0x8(%eax),%edx
  802bf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bff:	01 c2                	add    %eax,%edx
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	8b 40 08             	mov    0x8(%eax),%eax
  802c07:	39 c2                	cmp    %eax,%edx
  802c09:	0f 85 ae 00 00 00    	jne    802cbd <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c12:	8b 50 0c             	mov    0xc(%eax),%edx
  802c15:	8b 45 08             	mov    0x8(%ebp),%eax
  802c18:	8b 40 08             	mov    0x8(%eax),%eax
  802c1b:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802c1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802c25:	39 c2                	cmp    %eax,%edx
  802c27:	0f 84 90 00 00 00    	je     802cbd <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c30:	8b 50 0c             	mov    0xc(%eax),%edx
  802c33:	8b 45 08             	mov    0x8(%ebp),%eax
  802c36:	8b 40 0c             	mov    0xc(%eax),%eax
  802c39:	01 c2                	add    %eax,%edx
  802c3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3e:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c59:	75 17                	jne    802c72 <insert_sorted_with_merge_freeList+0x3c1>
  802c5b:	83 ec 04             	sub    $0x4,%esp
  802c5e:	68 b4 3c 80 00       	push   $0x803cb4
  802c63:	68 0b 01 00 00       	push   $0x10b
  802c68:	68 d7 3c 80 00       	push   $0x803cd7
  802c6d:	e8 5f d6 ff ff       	call   8002d1 <_panic>
  802c72:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	89 10                	mov    %edx,(%eax)
  802c7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c80:	8b 00                	mov    (%eax),%eax
  802c82:	85 c0                	test   %eax,%eax
  802c84:	74 0d                	je     802c93 <insert_sorted_with_merge_freeList+0x3e2>
  802c86:	a1 48 41 80 00       	mov    0x804148,%eax
  802c8b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c8e:	89 50 04             	mov    %edx,0x4(%eax)
  802c91:	eb 08                	jmp    802c9b <insert_sorted_with_merge_freeList+0x3ea>
  802c93:	8b 45 08             	mov    0x8(%ebp),%eax
  802c96:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9e:	a3 48 41 80 00       	mov    %eax,0x804148
  802ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cad:	a1 54 41 80 00       	mov    0x804154,%eax
  802cb2:	40                   	inc    %eax
  802cb3:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802cb8:	e9 c9 03 00 00       	jmp    803086 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc0:	8b 50 0c             	mov    0xc(%eax),%edx
  802cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc6:	8b 40 08             	mov    0x8(%eax),%eax
  802cc9:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802cd1:	39 c2                	cmp    %eax,%edx
  802cd3:	0f 85 bb 00 00 00    	jne    802d94 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802cd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cdd:	0f 84 b1 00 00 00    	je     802d94 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 40 04             	mov    0x4(%eax),%eax
  802ce9:	85 c0                	test   %eax,%eax
  802ceb:	0f 85 a3 00 00 00    	jne    802d94 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802cf1:	a1 38 41 80 00       	mov    0x804138,%eax
  802cf6:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf9:	8b 52 08             	mov    0x8(%edx),%edx
  802cfc:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802cff:	a1 38 41 80 00       	mov    0x804138,%eax
  802d04:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d0a:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802d0d:	8b 55 08             	mov    0x8(%ebp),%edx
  802d10:	8b 52 0c             	mov    0xc(%edx),%edx
  802d13:	01 ca                	add    %ecx,%edx
  802d15:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d22:	8b 45 08             	mov    0x8(%ebp),%eax
  802d25:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d2c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d30:	75 17                	jne    802d49 <insert_sorted_with_merge_freeList+0x498>
  802d32:	83 ec 04             	sub    $0x4,%esp
  802d35:	68 b4 3c 80 00       	push   $0x803cb4
  802d3a:	68 17 01 00 00       	push   $0x117
  802d3f:	68 d7 3c 80 00       	push   $0x803cd7
  802d44:	e8 88 d5 ff ff       	call   8002d1 <_panic>
  802d49:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	89 10                	mov    %edx,(%eax)
  802d54:	8b 45 08             	mov    0x8(%ebp),%eax
  802d57:	8b 00                	mov    (%eax),%eax
  802d59:	85 c0                	test   %eax,%eax
  802d5b:	74 0d                	je     802d6a <insert_sorted_with_merge_freeList+0x4b9>
  802d5d:	a1 48 41 80 00       	mov    0x804148,%eax
  802d62:	8b 55 08             	mov    0x8(%ebp),%edx
  802d65:	89 50 04             	mov    %edx,0x4(%eax)
  802d68:	eb 08                	jmp    802d72 <insert_sorted_with_merge_freeList+0x4c1>
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	a3 48 41 80 00       	mov    %eax,0x804148
  802d7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d84:	a1 54 41 80 00       	mov    0x804154,%eax
  802d89:	40                   	inc    %eax
  802d8a:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d8f:	e9 f2 02 00 00       	jmp    803086 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802d94:	8b 45 08             	mov    0x8(%ebp),%eax
  802d97:	8b 50 08             	mov    0x8(%eax),%edx
  802d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9d:	8b 40 0c             	mov    0xc(%eax),%eax
  802da0:	01 c2                	add    %eax,%edx
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 40 08             	mov    0x8(%eax),%eax
  802da8:	39 c2                	cmp    %eax,%edx
  802daa:	0f 85 be 00 00 00    	jne    802e6e <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802db0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db3:	8b 40 04             	mov    0x4(%eax),%eax
  802db6:	8b 50 08             	mov    0x8(%eax),%edx
  802db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbc:	8b 40 04             	mov    0x4(%eax),%eax
  802dbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802dc2:	01 c2                	add    %eax,%edx
  802dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc7:	8b 40 08             	mov    0x8(%eax),%eax
  802dca:	39 c2                	cmp    %eax,%edx
  802dcc:	0f 84 9c 00 00 00    	je     802e6e <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd5:	8b 50 08             	mov    0x8(%eax),%edx
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de1:	8b 50 0c             	mov    0xc(%eax),%edx
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dea:	01 c2                	add    %eax,%edx
  802dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802def:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e0a:	75 17                	jne    802e23 <insert_sorted_with_merge_freeList+0x572>
  802e0c:	83 ec 04             	sub    $0x4,%esp
  802e0f:	68 b4 3c 80 00       	push   $0x803cb4
  802e14:	68 26 01 00 00       	push   $0x126
  802e19:	68 d7 3c 80 00       	push   $0x803cd7
  802e1e:	e8 ae d4 ff ff       	call   8002d1 <_panic>
  802e23:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	89 10                	mov    %edx,(%eax)
  802e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e31:	8b 00                	mov    (%eax),%eax
  802e33:	85 c0                	test   %eax,%eax
  802e35:	74 0d                	je     802e44 <insert_sorted_with_merge_freeList+0x593>
  802e37:	a1 48 41 80 00       	mov    0x804148,%eax
  802e3c:	8b 55 08             	mov    0x8(%ebp),%edx
  802e3f:	89 50 04             	mov    %edx,0x4(%eax)
  802e42:	eb 08                	jmp    802e4c <insert_sorted_with_merge_freeList+0x59b>
  802e44:	8b 45 08             	mov    0x8(%ebp),%eax
  802e47:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4f:	a3 48 41 80 00       	mov    %eax,0x804148
  802e54:	8b 45 08             	mov    0x8(%ebp),%eax
  802e57:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e5e:	a1 54 41 80 00       	mov    0x804154,%eax
  802e63:	40                   	inc    %eax
  802e64:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802e69:	e9 18 02 00 00       	jmp    803086 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e71:	8b 50 0c             	mov    0xc(%eax),%edx
  802e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e77:	8b 40 08             	mov    0x8(%eax),%eax
  802e7a:	01 c2                	add    %eax,%edx
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	8b 40 08             	mov    0x8(%eax),%eax
  802e82:	39 c2                	cmp    %eax,%edx
  802e84:	0f 85 c4 01 00 00    	jne    80304e <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802e8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	8b 40 08             	mov    0x8(%eax),%eax
  802e96:	01 c2                	add    %eax,%edx
  802e98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9b:	8b 00                	mov    (%eax),%eax
  802e9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ea0:	39 c2                	cmp    %eax,%edx
  802ea2:	0f 85 a6 01 00 00    	jne    80304e <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802ea8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eac:	0f 84 9c 01 00 00    	je     80304e <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802eb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb5:	8b 50 0c             	mov    0xc(%eax),%edx
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	8b 40 0c             	mov    0xc(%eax),%eax
  802ebe:	01 c2                	add    %eax,%edx
  802ec0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec3:	8b 00                	mov    (%eax),%eax
  802ec5:	8b 40 0c             	mov    0xc(%eax),%eax
  802ec8:	01 c2                	add    %eax,%edx
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802eda:	8b 45 08             	mov    0x8(%ebp),%eax
  802edd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802ee4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ee8:	75 17                	jne    802f01 <insert_sorted_with_merge_freeList+0x650>
  802eea:	83 ec 04             	sub    $0x4,%esp
  802eed:	68 b4 3c 80 00       	push   $0x803cb4
  802ef2:	68 32 01 00 00       	push   $0x132
  802ef7:	68 d7 3c 80 00       	push   $0x803cd7
  802efc:	e8 d0 d3 ff ff       	call   8002d1 <_panic>
  802f01:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	89 10                	mov    %edx,(%eax)
  802f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0f:	8b 00                	mov    (%eax),%eax
  802f11:	85 c0                	test   %eax,%eax
  802f13:	74 0d                	je     802f22 <insert_sorted_with_merge_freeList+0x671>
  802f15:	a1 48 41 80 00       	mov    0x804148,%eax
  802f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  802f1d:	89 50 04             	mov    %edx,0x4(%eax)
  802f20:	eb 08                	jmp    802f2a <insert_sorted_with_merge_freeList+0x679>
  802f22:	8b 45 08             	mov    0x8(%ebp),%eax
  802f25:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2d:	a3 48 41 80 00       	mov    %eax,0x804148
  802f32:	8b 45 08             	mov    0x8(%ebp),%eax
  802f35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f3c:	a1 54 41 80 00       	mov    0x804154,%eax
  802f41:	40                   	inc    %eax
  802f42:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4a:	8b 00                	mov    (%eax),%eax
  802f4c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802f53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f56:	8b 00                	mov    (%eax),%eax
  802f58:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	8b 00                	mov    (%eax),%eax
  802f64:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802f67:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f6b:	75 17                	jne    802f84 <insert_sorted_with_merge_freeList+0x6d3>
  802f6d:	83 ec 04             	sub    $0x4,%esp
  802f70:	68 49 3d 80 00       	push   $0x803d49
  802f75:	68 36 01 00 00       	push   $0x136
  802f7a:	68 d7 3c 80 00       	push   $0x803cd7
  802f7f:	e8 4d d3 ff ff       	call   8002d1 <_panic>
  802f84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f87:	8b 00                	mov    (%eax),%eax
  802f89:	85 c0                	test   %eax,%eax
  802f8b:	74 10                	je     802f9d <insert_sorted_with_merge_freeList+0x6ec>
  802f8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f90:	8b 00                	mov    (%eax),%eax
  802f92:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f95:	8b 52 04             	mov    0x4(%edx),%edx
  802f98:	89 50 04             	mov    %edx,0x4(%eax)
  802f9b:	eb 0b                	jmp    802fa8 <insert_sorted_with_merge_freeList+0x6f7>
  802f9d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa0:	8b 40 04             	mov    0x4(%eax),%eax
  802fa3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fa8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fab:	8b 40 04             	mov    0x4(%eax),%eax
  802fae:	85 c0                	test   %eax,%eax
  802fb0:	74 0f                	je     802fc1 <insert_sorted_with_merge_freeList+0x710>
  802fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb5:	8b 40 04             	mov    0x4(%eax),%eax
  802fb8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fbb:	8b 12                	mov    (%edx),%edx
  802fbd:	89 10                	mov    %edx,(%eax)
  802fbf:	eb 0a                	jmp    802fcb <insert_sorted_with_merge_freeList+0x71a>
  802fc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc4:	8b 00                	mov    (%eax),%eax
  802fc6:	a3 38 41 80 00       	mov    %eax,0x804138
  802fcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fd4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fde:	a1 44 41 80 00       	mov    0x804144,%eax
  802fe3:	48                   	dec    %eax
  802fe4:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  802fe9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fed:	75 17                	jne    803006 <insert_sorted_with_merge_freeList+0x755>
  802fef:	83 ec 04             	sub    $0x4,%esp
  802ff2:	68 b4 3c 80 00       	push   $0x803cb4
  802ff7:	68 37 01 00 00       	push   $0x137
  802ffc:	68 d7 3c 80 00       	push   $0x803cd7
  803001:	e8 cb d2 ff ff       	call   8002d1 <_panic>
  803006:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80300c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80300f:	89 10                	mov    %edx,(%eax)
  803011:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803014:	8b 00                	mov    (%eax),%eax
  803016:	85 c0                	test   %eax,%eax
  803018:	74 0d                	je     803027 <insert_sorted_with_merge_freeList+0x776>
  80301a:	a1 48 41 80 00       	mov    0x804148,%eax
  80301f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803022:	89 50 04             	mov    %edx,0x4(%eax)
  803025:	eb 08                	jmp    80302f <insert_sorted_with_merge_freeList+0x77e>
  803027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80302f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803032:	a3 48 41 80 00       	mov    %eax,0x804148
  803037:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80303a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803041:	a1 54 41 80 00       	mov    0x804154,%eax
  803046:	40                   	inc    %eax
  803047:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  80304c:	eb 38                	jmp    803086 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80304e:	a1 40 41 80 00       	mov    0x804140,%eax
  803053:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803056:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80305a:	74 07                	je     803063 <insert_sorted_with_merge_freeList+0x7b2>
  80305c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80305f:	8b 00                	mov    (%eax),%eax
  803061:	eb 05                	jmp    803068 <insert_sorted_with_merge_freeList+0x7b7>
  803063:	b8 00 00 00 00       	mov    $0x0,%eax
  803068:	a3 40 41 80 00       	mov    %eax,0x804140
  80306d:	a1 40 41 80 00       	mov    0x804140,%eax
  803072:	85 c0                	test   %eax,%eax
  803074:	0f 85 ef f9 ff ff    	jne    802a69 <insert_sorted_with_merge_freeList+0x1b8>
  80307a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80307e:	0f 85 e5 f9 ff ff    	jne    802a69 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803084:	eb 00                	jmp    803086 <insert_sorted_with_merge_freeList+0x7d5>
  803086:	90                   	nop
  803087:	c9                   	leave  
  803088:	c3                   	ret    

00803089 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803089:	55                   	push   %ebp
  80308a:	89 e5                	mov    %esp,%ebp
  80308c:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80308f:	8b 55 08             	mov    0x8(%ebp),%edx
  803092:	89 d0                	mov    %edx,%eax
  803094:	c1 e0 02             	shl    $0x2,%eax
  803097:	01 d0                	add    %edx,%eax
  803099:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030a0:	01 d0                	add    %edx,%eax
  8030a2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030a9:	01 d0                	add    %edx,%eax
  8030ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030b2:	01 d0                	add    %edx,%eax
  8030b4:	c1 e0 04             	shl    $0x4,%eax
  8030b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8030ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030c1:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030c4:	83 ec 0c             	sub    $0xc,%esp
  8030c7:	50                   	push   %eax
  8030c8:	e8 21 ec ff ff       	call   801cee <sys_get_virtual_time>
  8030cd:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030d0:	eb 41                	jmp    803113 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030d2:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030d5:	83 ec 0c             	sub    $0xc,%esp
  8030d8:	50                   	push   %eax
  8030d9:	e8 10 ec ff ff       	call   801cee <sys_get_virtual_time>
  8030de:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030e1:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030e4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030e7:	29 c2                	sub    %eax,%edx
  8030e9:	89 d0                	mov    %edx,%eax
  8030eb:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030ee:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030f4:	89 d1                	mov    %edx,%ecx
  8030f6:	29 c1                	sub    %eax,%ecx
  8030f8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030fe:	39 c2                	cmp    %eax,%edx
  803100:	0f 97 c0             	seta   %al
  803103:	0f b6 c0             	movzbl %al,%eax
  803106:	29 c1                	sub    %eax,%ecx
  803108:	89 c8                	mov    %ecx,%eax
  80310a:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80310d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803110:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803113:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803116:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803119:	72 b7                	jb     8030d2 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  80311b:	90                   	nop
  80311c:	c9                   	leave  
  80311d:	c3                   	ret    

0080311e <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80311e:	55                   	push   %ebp
  80311f:	89 e5                	mov    %esp,%ebp
  803121:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803124:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  80312b:	eb 03                	jmp    803130 <busy_wait+0x12>
  80312d:	ff 45 fc             	incl   -0x4(%ebp)
  803130:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803133:	3b 45 08             	cmp    0x8(%ebp),%eax
  803136:	72 f5                	jb     80312d <busy_wait+0xf>
	return i;
  803138:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80313b:	c9                   	leave  
  80313c:	c3                   	ret    
  80313d:	66 90                	xchg   %ax,%ax
  80313f:	90                   	nop

00803140 <__udivdi3>:
  803140:	55                   	push   %ebp
  803141:	57                   	push   %edi
  803142:	56                   	push   %esi
  803143:	53                   	push   %ebx
  803144:	83 ec 1c             	sub    $0x1c,%esp
  803147:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80314b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80314f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803153:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803157:	89 ca                	mov    %ecx,%edx
  803159:	89 f8                	mov    %edi,%eax
  80315b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80315f:	85 f6                	test   %esi,%esi
  803161:	75 2d                	jne    803190 <__udivdi3+0x50>
  803163:	39 cf                	cmp    %ecx,%edi
  803165:	77 65                	ja     8031cc <__udivdi3+0x8c>
  803167:	89 fd                	mov    %edi,%ebp
  803169:	85 ff                	test   %edi,%edi
  80316b:	75 0b                	jne    803178 <__udivdi3+0x38>
  80316d:	b8 01 00 00 00       	mov    $0x1,%eax
  803172:	31 d2                	xor    %edx,%edx
  803174:	f7 f7                	div    %edi
  803176:	89 c5                	mov    %eax,%ebp
  803178:	31 d2                	xor    %edx,%edx
  80317a:	89 c8                	mov    %ecx,%eax
  80317c:	f7 f5                	div    %ebp
  80317e:	89 c1                	mov    %eax,%ecx
  803180:	89 d8                	mov    %ebx,%eax
  803182:	f7 f5                	div    %ebp
  803184:	89 cf                	mov    %ecx,%edi
  803186:	89 fa                	mov    %edi,%edx
  803188:	83 c4 1c             	add    $0x1c,%esp
  80318b:	5b                   	pop    %ebx
  80318c:	5e                   	pop    %esi
  80318d:	5f                   	pop    %edi
  80318e:	5d                   	pop    %ebp
  80318f:	c3                   	ret    
  803190:	39 ce                	cmp    %ecx,%esi
  803192:	77 28                	ja     8031bc <__udivdi3+0x7c>
  803194:	0f bd fe             	bsr    %esi,%edi
  803197:	83 f7 1f             	xor    $0x1f,%edi
  80319a:	75 40                	jne    8031dc <__udivdi3+0x9c>
  80319c:	39 ce                	cmp    %ecx,%esi
  80319e:	72 0a                	jb     8031aa <__udivdi3+0x6a>
  8031a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031a4:	0f 87 9e 00 00 00    	ja     803248 <__udivdi3+0x108>
  8031aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8031af:	89 fa                	mov    %edi,%edx
  8031b1:	83 c4 1c             	add    $0x1c,%esp
  8031b4:	5b                   	pop    %ebx
  8031b5:	5e                   	pop    %esi
  8031b6:	5f                   	pop    %edi
  8031b7:	5d                   	pop    %ebp
  8031b8:	c3                   	ret    
  8031b9:	8d 76 00             	lea    0x0(%esi),%esi
  8031bc:	31 ff                	xor    %edi,%edi
  8031be:	31 c0                	xor    %eax,%eax
  8031c0:	89 fa                	mov    %edi,%edx
  8031c2:	83 c4 1c             	add    $0x1c,%esp
  8031c5:	5b                   	pop    %ebx
  8031c6:	5e                   	pop    %esi
  8031c7:	5f                   	pop    %edi
  8031c8:	5d                   	pop    %ebp
  8031c9:	c3                   	ret    
  8031ca:	66 90                	xchg   %ax,%ax
  8031cc:	89 d8                	mov    %ebx,%eax
  8031ce:	f7 f7                	div    %edi
  8031d0:	31 ff                	xor    %edi,%edi
  8031d2:	89 fa                	mov    %edi,%edx
  8031d4:	83 c4 1c             	add    $0x1c,%esp
  8031d7:	5b                   	pop    %ebx
  8031d8:	5e                   	pop    %esi
  8031d9:	5f                   	pop    %edi
  8031da:	5d                   	pop    %ebp
  8031db:	c3                   	ret    
  8031dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031e1:	89 eb                	mov    %ebp,%ebx
  8031e3:	29 fb                	sub    %edi,%ebx
  8031e5:	89 f9                	mov    %edi,%ecx
  8031e7:	d3 e6                	shl    %cl,%esi
  8031e9:	89 c5                	mov    %eax,%ebp
  8031eb:	88 d9                	mov    %bl,%cl
  8031ed:	d3 ed                	shr    %cl,%ebp
  8031ef:	89 e9                	mov    %ebp,%ecx
  8031f1:	09 f1                	or     %esi,%ecx
  8031f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031f7:	89 f9                	mov    %edi,%ecx
  8031f9:	d3 e0                	shl    %cl,%eax
  8031fb:	89 c5                	mov    %eax,%ebp
  8031fd:	89 d6                	mov    %edx,%esi
  8031ff:	88 d9                	mov    %bl,%cl
  803201:	d3 ee                	shr    %cl,%esi
  803203:	89 f9                	mov    %edi,%ecx
  803205:	d3 e2                	shl    %cl,%edx
  803207:	8b 44 24 08          	mov    0x8(%esp),%eax
  80320b:	88 d9                	mov    %bl,%cl
  80320d:	d3 e8                	shr    %cl,%eax
  80320f:	09 c2                	or     %eax,%edx
  803211:	89 d0                	mov    %edx,%eax
  803213:	89 f2                	mov    %esi,%edx
  803215:	f7 74 24 0c          	divl   0xc(%esp)
  803219:	89 d6                	mov    %edx,%esi
  80321b:	89 c3                	mov    %eax,%ebx
  80321d:	f7 e5                	mul    %ebp
  80321f:	39 d6                	cmp    %edx,%esi
  803221:	72 19                	jb     80323c <__udivdi3+0xfc>
  803223:	74 0b                	je     803230 <__udivdi3+0xf0>
  803225:	89 d8                	mov    %ebx,%eax
  803227:	31 ff                	xor    %edi,%edi
  803229:	e9 58 ff ff ff       	jmp    803186 <__udivdi3+0x46>
  80322e:	66 90                	xchg   %ax,%ax
  803230:	8b 54 24 08          	mov    0x8(%esp),%edx
  803234:	89 f9                	mov    %edi,%ecx
  803236:	d3 e2                	shl    %cl,%edx
  803238:	39 c2                	cmp    %eax,%edx
  80323a:	73 e9                	jae    803225 <__udivdi3+0xe5>
  80323c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80323f:	31 ff                	xor    %edi,%edi
  803241:	e9 40 ff ff ff       	jmp    803186 <__udivdi3+0x46>
  803246:	66 90                	xchg   %ax,%ax
  803248:	31 c0                	xor    %eax,%eax
  80324a:	e9 37 ff ff ff       	jmp    803186 <__udivdi3+0x46>
  80324f:	90                   	nop

00803250 <__umoddi3>:
  803250:	55                   	push   %ebp
  803251:	57                   	push   %edi
  803252:	56                   	push   %esi
  803253:	53                   	push   %ebx
  803254:	83 ec 1c             	sub    $0x1c,%esp
  803257:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80325b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80325f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803263:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803267:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80326b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80326f:	89 f3                	mov    %esi,%ebx
  803271:	89 fa                	mov    %edi,%edx
  803273:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803277:	89 34 24             	mov    %esi,(%esp)
  80327a:	85 c0                	test   %eax,%eax
  80327c:	75 1a                	jne    803298 <__umoddi3+0x48>
  80327e:	39 f7                	cmp    %esi,%edi
  803280:	0f 86 a2 00 00 00    	jbe    803328 <__umoddi3+0xd8>
  803286:	89 c8                	mov    %ecx,%eax
  803288:	89 f2                	mov    %esi,%edx
  80328a:	f7 f7                	div    %edi
  80328c:	89 d0                	mov    %edx,%eax
  80328e:	31 d2                	xor    %edx,%edx
  803290:	83 c4 1c             	add    $0x1c,%esp
  803293:	5b                   	pop    %ebx
  803294:	5e                   	pop    %esi
  803295:	5f                   	pop    %edi
  803296:	5d                   	pop    %ebp
  803297:	c3                   	ret    
  803298:	39 f0                	cmp    %esi,%eax
  80329a:	0f 87 ac 00 00 00    	ja     80334c <__umoddi3+0xfc>
  8032a0:	0f bd e8             	bsr    %eax,%ebp
  8032a3:	83 f5 1f             	xor    $0x1f,%ebp
  8032a6:	0f 84 ac 00 00 00    	je     803358 <__umoddi3+0x108>
  8032ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8032b1:	29 ef                	sub    %ebp,%edi
  8032b3:	89 fe                	mov    %edi,%esi
  8032b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032b9:	89 e9                	mov    %ebp,%ecx
  8032bb:	d3 e0                	shl    %cl,%eax
  8032bd:	89 d7                	mov    %edx,%edi
  8032bf:	89 f1                	mov    %esi,%ecx
  8032c1:	d3 ef                	shr    %cl,%edi
  8032c3:	09 c7                	or     %eax,%edi
  8032c5:	89 e9                	mov    %ebp,%ecx
  8032c7:	d3 e2                	shl    %cl,%edx
  8032c9:	89 14 24             	mov    %edx,(%esp)
  8032cc:	89 d8                	mov    %ebx,%eax
  8032ce:	d3 e0                	shl    %cl,%eax
  8032d0:	89 c2                	mov    %eax,%edx
  8032d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032d6:	d3 e0                	shl    %cl,%eax
  8032d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032e0:	89 f1                	mov    %esi,%ecx
  8032e2:	d3 e8                	shr    %cl,%eax
  8032e4:	09 d0                	or     %edx,%eax
  8032e6:	d3 eb                	shr    %cl,%ebx
  8032e8:	89 da                	mov    %ebx,%edx
  8032ea:	f7 f7                	div    %edi
  8032ec:	89 d3                	mov    %edx,%ebx
  8032ee:	f7 24 24             	mull   (%esp)
  8032f1:	89 c6                	mov    %eax,%esi
  8032f3:	89 d1                	mov    %edx,%ecx
  8032f5:	39 d3                	cmp    %edx,%ebx
  8032f7:	0f 82 87 00 00 00    	jb     803384 <__umoddi3+0x134>
  8032fd:	0f 84 91 00 00 00    	je     803394 <__umoddi3+0x144>
  803303:	8b 54 24 04          	mov    0x4(%esp),%edx
  803307:	29 f2                	sub    %esi,%edx
  803309:	19 cb                	sbb    %ecx,%ebx
  80330b:	89 d8                	mov    %ebx,%eax
  80330d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803311:	d3 e0                	shl    %cl,%eax
  803313:	89 e9                	mov    %ebp,%ecx
  803315:	d3 ea                	shr    %cl,%edx
  803317:	09 d0                	or     %edx,%eax
  803319:	89 e9                	mov    %ebp,%ecx
  80331b:	d3 eb                	shr    %cl,%ebx
  80331d:	89 da                	mov    %ebx,%edx
  80331f:	83 c4 1c             	add    $0x1c,%esp
  803322:	5b                   	pop    %ebx
  803323:	5e                   	pop    %esi
  803324:	5f                   	pop    %edi
  803325:	5d                   	pop    %ebp
  803326:	c3                   	ret    
  803327:	90                   	nop
  803328:	89 fd                	mov    %edi,%ebp
  80332a:	85 ff                	test   %edi,%edi
  80332c:	75 0b                	jne    803339 <__umoddi3+0xe9>
  80332e:	b8 01 00 00 00       	mov    $0x1,%eax
  803333:	31 d2                	xor    %edx,%edx
  803335:	f7 f7                	div    %edi
  803337:	89 c5                	mov    %eax,%ebp
  803339:	89 f0                	mov    %esi,%eax
  80333b:	31 d2                	xor    %edx,%edx
  80333d:	f7 f5                	div    %ebp
  80333f:	89 c8                	mov    %ecx,%eax
  803341:	f7 f5                	div    %ebp
  803343:	89 d0                	mov    %edx,%eax
  803345:	e9 44 ff ff ff       	jmp    80328e <__umoddi3+0x3e>
  80334a:	66 90                	xchg   %ax,%ax
  80334c:	89 c8                	mov    %ecx,%eax
  80334e:	89 f2                	mov    %esi,%edx
  803350:	83 c4 1c             	add    $0x1c,%esp
  803353:	5b                   	pop    %ebx
  803354:	5e                   	pop    %esi
  803355:	5f                   	pop    %edi
  803356:	5d                   	pop    %ebp
  803357:	c3                   	ret    
  803358:	3b 04 24             	cmp    (%esp),%eax
  80335b:	72 06                	jb     803363 <__umoddi3+0x113>
  80335d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803361:	77 0f                	ja     803372 <__umoddi3+0x122>
  803363:	89 f2                	mov    %esi,%edx
  803365:	29 f9                	sub    %edi,%ecx
  803367:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80336b:	89 14 24             	mov    %edx,(%esp)
  80336e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803372:	8b 44 24 04          	mov    0x4(%esp),%eax
  803376:	8b 14 24             	mov    (%esp),%edx
  803379:	83 c4 1c             	add    $0x1c,%esp
  80337c:	5b                   	pop    %ebx
  80337d:	5e                   	pop    %esi
  80337e:	5f                   	pop    %edi
  80337f:	5d                   	pop    %ebp
  803380:	c3                   	ret    
  803381:	8d 76 00             	lea    0x0(%esi),%esi
  803384:	2b 04 24             	sub    (%esp),%eax
  803387:	19 fa                	sbb    %edi,%edx
  803389:	89 d1                	mov    %edx,%ecx
  80338b:	89 c6                	mov    %eax,%esi
  80338d:	e9 71 ff ff ff       	jmp    803303 <__umoddi3+0xb3>
  803392:	66 90                	xchg   %ax,%ax
  803394:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803398:	72 ea                	jb     803384 <__umoddi3+0x134>
  80339a:	89 d9                	mov    %ebx,%ecx
  80339c:	e9 62 ff ff ff       	jmp    803303 <__umoddi3+0xb3>
