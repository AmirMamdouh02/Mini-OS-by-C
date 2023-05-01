
obj/user/tst_envfree5_2:     file format elf32-i386


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
  800031:	e8 4b 01 00 00       	call   800181 <libmain>
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
	// Testing scenario 5_2: Kill programs have already shared variables and they free it [include scenario 5_1]
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 a0 33 80 00       	push   $0x8033a0
  80004a:	e8 3c 16 00 00       	call   80168b <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*numOfFinished = 0 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	int freeFrames_before = sys_calculate_free_frames() ;
  80005e:	e8 4b 19 00 00       	call   8019ae <sys_calculate_free_frames>
  800063:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int usedDiskPages_before = sys_pf_calculate_allocated_pages() ;
  800066:	e8 e3 19 00 00       	call   801a4e <sys_pf_calculate_allocated_pages>
  80006b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("\n---# of free frames before running programs = %d\n", freeFrames_before);
  80006e:	83 ec 08             	sub    $0x8,%esp
  800071:	ff 75 f0             	pushl  -0x10(%ebp)
  800074:	68 b0 33 80 00       	push   $0x8033b0
  800079:	e8 f3 04 00 00       	call   800571 <cprintf>
  80007e:	83 c4 10             	add    $0x10,%esp

	int32 envIdProcessA = sys_create_env("ef_tshr4", 2000,100, 50);
  800081:	6a 32                	push   $0x32
  800083:	6a 64                	push   $0x64
  800085:	68 d0 07 00 00       	push   $0x7d0
  80008a:	68 e3 33 80 00       	push   $0x8033e3
  80008f:	e8 8c 1b 00 00       	call   801c20 <sys_create_env>
  800094:	83 c4 10             	add    $0x10,%esp
  800097:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int32 envIdProcessB = sys_create_env("ef_tshr5", 2000,100, 50);
  80009a:	6a 32                	push   $0x32
  80009c:	6a 64                	push   $0x64
  80009e:	68 d0 07 00 00       	push   $0x7d0
  8000a3:	68 ec 33 80 00       	push   $0x8033ec
  8000a8:	e8 73 1b 00 00       	call   801c20 <sys_create_env>
  8000ad:	83 c4 10             	add    $0x10,%esp
  8000b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	sys_run_env(envIdProcessA);
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8000b9:	e8 80 1b 00 00       	call   801c3e <sys_run_env>
  8000be:	83 c4 10             	add    $0x10,%esp
	env_sleep(15000);
  8000c1:	83 ec 0c             	sub    $0xc,%esp
  8000c4:	68 98 3a 00 00       	push   $0x3a98
  8000c9:	e8 a7 2f 00 00       	call   803075 <env_sleep>
  8000ce:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  8000d1:	83 ec 0c             	sub    $0xc,%esp
  8000d4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8000d7:	e8 62 1b 00 00       	call   801c3e <sys_run_env>
  8000dc:	83 c4 10             	add    $0x10,%esp

	while (*numOfFinished != 2) ;
  8000df:	90                   	nop
  8000e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000e3:	8b 00                	mov    (%eax),%eax
  8000e5:	83 f8 02             	cmp    $0x2,%eax
  8000e8:	75 f6                	jne    8000e0 <_main+0xa8>
	cprintf("\n---# of free frames after running programs = %d\n", sys_calculate_free_frames());
  8000ea:	e8 bf 18 00 00       	call   8019ae <sys_calculate_free_frames>
  8000ef:	83 ec 08             	sub    $0x8,%esp
  8000f2:	50                   	push   %eax
  8000f3:	68 f8 33 80 00       	push   $0x8033f8
  8000f8:	e8 74 04 00 00       	call   800571 <cprintf>
  8000fd:	83 c4 10             	add    $0x10,%esp

	sys_destroy_env(envIdProcessA);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 e8             	pushl  -0x18(%ebp)
  800106:	e8 4f 1b 00 00       	call   801c5a <sys_destroy_env>
  80010b:	83 c4 10             	add    $0x10,%esp
	sys_destroy_env(envIdProcessB);
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	ff 75 e4             	pushl  -0x1c(%ebp)
  800114:	e8 41 1b 00 00       	call   801c5a <sys_destroy_env>
  800119:	83 c4 10             	add    $0x10,%esp

	//Checking the number of frames after killing the created environments
	int freeFrames_after = sys_calculate_free_frames() ;
  80011c:	e8 8d 18 00 00       	call   8019ae <sys_calculate_free_frames>
  800121:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int usedDiskPages_after = sys_pf_calculate_allocated_pages() ;
  800124:	e8 25 19 00 00       	call   801a4e <sys_pf_calculate_allocated_pages>
  800129:	89 45 dc             	mov    %eax,-0x24(%ebp)

	if ((freeFrames_after - freeFrames_before) != 0) {
  80012c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80012f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800132:	74 27                	je     80015b <_main+0x123>
		cprintf("\n---# of free frames after closing running programs not as before running = %d\n",
  800134:	83 ec 08             	sub    $0x8,%esp
  800137:	ff 75 e0             	pushl  -0x20(%ebp)
  80013a:	68 2c 34 80 00       	push   $0x80342c
  80013f:	e8 2d 04 00 00       	call   800571 <cprintf>
  800144:	83 c4 10             	add    $0x10,%esp
				freeFrames_after);
		panic("env_free() does not work correctly... check it again.");
  800147:	83 ec 04             	sub    $0x4,%esp
  80014a:	68 7c 34 80 00       	push   $0x80347c
  80014f:	6a 23                	push   $0x23
  800151:	68 b2 34 80 00       	push   $0x8034b2
  800156:	e8 62 01 00 00       	call   8002bd <_panic>
	}

	cprintf("\n---# of free frames after closing running programs returned back to be as before running = %d\n", freeFrames_after);
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	ff 75 e0             	pushl  -0x20(%ebp)
  800161:	68 c8 34 80 00       	push   $0x8034c8
  800166:	e8 06 04 00 00       	call   800571 <cprintf>
  80016b:	83 c4 10             	add    $0x10,%esp

	cprintf("\n\nCongratulations!! test scenario 5_2 for envfree completed successfully.\n");
  80016e:	83 ec 0c             	sub    $0xc,%esp
  800171:	68 28 35 80 00       	push   $0x803528
  800176:	e8 f6 03 00 00       	call   800571 <cprintf>
  80017b:	83 c4 10             	add    $0x10,%esp
	return;
  80017e:	90                   	nop
}
  80017f:	c9                   	leave  
  800180:	c3                   	ret    

00800181 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800181:	55                   	push   %ebp
  800182:	89 e5                	mov    %esp,%ebp
  800184:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800187:	e8 02 1b 00 00       	call   801c8e <sys_getenvindex>
  80018c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80018f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800192:	89 d0                	mov    %edx,%eax
  800194:	c1 e0 03             	shl    $0x3,%eax
  800197:	01 d0                	add    %edx,%eax
  800199:	01 c0                	add    %eax,%eax
  80019b:	01 d0                	add    %edx,%eax
  80019d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001a4:	01 d0                	add    %edx,%eax
  8001a6:	c1 e0 04             	shl    $0x4,%eax
  8001a9:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001ae:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001b3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b8:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001be:	84 c0                	test   %al,%al
  8001c0:	74 0f                	je     8001d1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001c2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c7:	05 5c 05 00 00       	add    $0x55c,%eax
  8001cc:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001d1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001d5:	7e 0a                	jle    8001e1 <libmain+0x60>
		binaryname = argv[0];
  8001d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001da:	8b 00                	mov    (%eax),%eax
  8001dc:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001e1:	83 ec 08             	sub    $0x8,%esp
  8001e4:	ff 75 0c             	pushl  0xc(%ebp)
  8001e7:	ff 75 08             	pushl  0x8(%ebp)
  8001ea:	e8 49 fe ff ff       	call   800038 <_main>
  8001ef:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001f2:	e8 a4 18 00 00       	call   801a9b <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f7:	83 ec 0c             	sub    $0xc,%esp
  8001fa:	68 8c 35 80 00       	push   $0x80358c
  8001ff:	e8 6d 03 00 00       	call   800571 <cprintf>
  800204:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800207:	a1 20 40 80 00       	mov    0x804020,%eax
  80020c:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800212:	a1 20 40 80 00       	mov    0x804020,%eax
  800217:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80021d:	83 ec 04             	sub    $0x4,%esp
  800220:	52                   	push   %edx
  800221:	50                   	push   %eax
  800222:	68 b4 35 80 00       	push   $0x8035b4
  800227:	e8 45 03 00 00       	call   800571 <cprintf>
  80022c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80022f:	a1 20 40 80 00       	mov    0x804020,%eax
  800234:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80023a:	a1 20 40 80 00       	mov    0x804020,%eax
  80023f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800245:	a1 20 40 80 00       	mov    0x804020,%eax
  80024a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800250:	51                   	push   %ecx
  800251:	52                   	push   %edx
  800252:	50                   	push   %eax
  800253:	68 dc 35 80 00       	push   $0x8035dc
  800258:	e8 14 03 00 00       	call   800571 <cprintf>
  80025d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800260:	a1 20 40 80 00       	mov    0x804020,%eax
  800265:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80026b:	83 ec 08             	sub    $0x8,%esp
  80026e:	50                   	push   %eax
  80026f:	68 34 36 80 00       	push   $0x803634
  800274:	e8 f8 02 00 00       	call   800571 <cprintf>
  800279:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80027c:	83 ec 0c             	sub    $0xc,%esp
  80027f:	68 8c 35 80 00       	push   $0x80358c
  800284:	e8 e8 02 00 00       	call   800571 <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80028c:	e8 24 18 00 00       	call   801ab5 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800291:	e8 19 00 00 00       	call   8002af <exit>
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80029f:	83 ec 0c             	sub    $0xc,%esp
  8002a2:	6a 00                	push   $0x0
  8002a4:	e8 b1 19 00 00       	call   801c5a <sys_destroy_env>
  8002a9:	83 c4 10             	add    $0x10,%esp
}
  8002ac:	90                   	nop
  8002ad:	c9                   	leave  
  8002ae:	c3                   	ret    

008002af <exit>:

void
exit(void)
{
  8002af:	55                   	push   %ebp
  8002b0:	89 e5                	mov    %esp,%ebp
  8002b2:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002b5:	e8 06 1a 00 00       	call   801cc0 <sys_exit_env>
}
  8002ba:	90                   	nop
  8002bb:	c9                   	leave  
  8002bc:	c3                   	ret    

008002bd <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002bd:	55                   	push   %ebp
  8002be:	89 e5                	mov    %esp,%ebp
  8002c0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002c3:	8d 45 10             	lea    0x10(%ebp),%eax
  8002c6:	83 c0 04             	add    $0x4,%eax
  8002c9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002cc:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002d1:	85 c0                	test   %eax,%eax
  8002d3:	74 16                	je     8002eb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002d5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	50                   	push   %eax
  8002de:	68 48 36 80 00       	push   $0x803648
  8002e3:	e8 89 02 00 00       	call   800571 <cprintf>
  8002e8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002eb:	a1 00 40 80 00       	mov    0x804000,%eax
  8002f0:	ff 75 0c             	pushl  0xc(%ebp)
  8002f3:	ff 75 08             	pushl  0x8(%ebp)
  8002f6:	50                   	push   %eax
  8002f7:	68 4d 36 80 00       	push   $0x80364d
  8002fc:	e8 70 02 00 00       	call   800571 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800304:	8b 45 10             	mov    0x10(%ebp),%eax
  800307:	83 ec 08             	sub    $0x8,%esp
  80030a:	ff 75 f4             	pushl  -0xc(%ebp)
  80030d:	50                   	push   %eax
  80030e:	e8 f3 01 00 00       	call   800506 <vcprintf>
  800313:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800316:	83 ec 08             	sub    $0x8,%esp
  800319:	6a 00                	push   $0x0
  80031b:	68 69 36 80 00       	push   $0x803669
  800320:	e8 e1 01 00 00       	call   800506 <vcprintf>
  800325:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800328:	e8 82 ff ff ff       	call   8002af <exit>

	// should not return here
	while (1) ;
  80032d:	eb fe                	jmp    80032d <_panic+0x70>

0080032f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800335:	a1 20 40 80 00       	mov    0x804020,%eax
  80033a:	8b 50 74             	mov    0x74(%eax),%edx
  80033d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800340:	39 c2                	cmp    %eax,%edx
  800342:	74 14                	je     800358 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800344:	83 ec 04             	sub    $0x4,%esp
  800347:	68 6c 36 80 00       	push   $0x80366c
  80034c:	6a 26                	push   $0x26
  80034e:	68 b8 36 80 00       	push   $0x8036b8
  800353:	e8 65 ff ff ff       	call   8002bd <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800358:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80035f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800366:	e9 c2 00 00 00       	jmp    80042d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80036b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80036e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800375:	8b 45 08             	mov    0x8(%ebp),%eax
  800378:	01 d0                	add    %edx,%eax
  80037a:	8b 00                	mov    (%eax),%eax
  80037c:	85 c0                	test   %eax,%eax
  80037e:	75 08                	jne    800388 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800380:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800383:	e9 a2 00 00 00       	jmp    80042a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800388:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80038f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800396:	eb 69                	jmp    800401 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800398:	a1 20 40 80 00       	mov    0x804020,%eax
  80039d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003a6:	89 d0                	mov    %edx,%eax
  8003a8:	01 c0                	add    %eax,%eax
  8003aa:	01 d0                	add    %edx,%eax
  8003ac:	c1 e0 03             	shl    $0x3,%eax
  8003af:	01 c8                	add    %ecx,%eax
  8003b1:	8a 40 04             	mov    0x4(%eax),%al
  8003b4:	84 c0                	test   %al,%al
  8003b6:	75 46                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b8:	a1 20 40 80 00       	mov    0x804020,%eax
  8003bd:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003c3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003c6:	89 d0                	mov    %edx,%eax
  8003c8:	01 c0                	add    %eax,%eax
  8003ca:	01 d0                	add    %edx,%eax
  8003cc:	c1 e0 03             	shl    $0x3,%eax
  8003cf:	01 c8                	add    %ecx,%eax
  8003d1:	8b 00                	mov    (%eax),%eax
  8003d3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003de:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8003ed:	01 c8                	add    %ecx,%eax
  8003ef:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003f1:	39 c2                	cmp    %eax,%edx
  8003f3:	75 09                	jne    8003fe <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003f5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003fc:	eb 12                	jmp    800410 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fe:	ff 45 e8             	incl   -0x18(%ebp)
  800401:	a1 20 40 80 00       	mov    0x804020,%eax
  800406:	8b 50 74             	mov    0x74(%eax),%edx
  800409:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80040c:	39 c2                	cmp    %eax,%edx
  80040e:	77 88                	ja     800398 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800410:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800414:	75 14                	jne    80042a <CheckWSWithoutLastIndex+0xfb>
			panic(
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 c4 36 80 00       	push   $0x8036c4
  80041e:	6a 3a                	push   $0x3a
  800420:	68 b8 36 80 00       	push   $0x8036b8
  800425:	e8 93 fe ff ff       	call   8002bd <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80042a:	ff 45 f0             	incl   -0x10(%ebp)
  80042d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800430:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800433:	0f 8c 32 ff ff ff    	jl     80036b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800439:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800440:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800447:	eb 26                	jmp    80046f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800449:	a1 20 40 80 00       	mov    0x804020,%eax
  80044e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800454:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800457:	89 d0                	mov    %edx,%eax
  800459:	01 c0                	add    %eax,%eax
  80045b:	01 d0                	add    %edx,%eax
  80045d:	c1 e0 03             	shl    $0x3,%eax
  800460:	01 c8                	add    %ecx,%eax
  800462:	8a 40 04             	mov    0x4(%eax),%al
  800465:	3c 01                	cmp    $0x1,%al
  800467:	75 03                	jne    80046c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800469:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	ff 45 e0             	incl   -0x20(%ebp)
  80046f:	a1 20 40 80 00       	mov    0x804020,%eax
  800474:	8b 50 74             	mov    0x74(%eax),%edx
  800477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047a:	39 c2                	cmp    %eax,%edx
  80047c:	77 cb                	ja     800449 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80047e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800481:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800484:	74 14                	je     80049a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800486:	83 ec 04             	sub    $0x4,%esp
  800489:	68 18 37 80 00       	push   $0x803718
  80048e:	6a 44                	push   $0x44
  800490:	68 b8 36 80 00       	push   $0x8036b8
  800495:	e8 23 fe ff ff       	call   8002bd <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80049a:	90                   	nop
  80049b:	c9                   	leave  
  80049c:	c3                   	ret    

0080049d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80049d:	55                   	push   %ebp
  80049e:	89 e5                	mov    %esp,%ebp
  8004a0:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	8d 48 01             	lea    0x1(%eax),%ecx
  8004ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ae:	89 0a                	mov    %ecx,(%edx)
  8004b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8004b3:	88 d1                	mov    %dl,%cl
  8004b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b8:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004bf:	8b 00                	mov    (%eax),%eax
  8004c1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004c6:	75 2c                	jne    8004f4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c8:	a0 24 40 80 00       	mov    0x804024,%al
  8004cd:	0f b6 c0             	movzbl %al,%eax
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	8b 12                	mov    (%edx),%edx
  8004d5:	89 d1                	mov    %edx,%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	83 c2 08             	add    $0x8,%edx
  8004dd:	83 ec 04             	sub    $0x4,%esp
  8004e0:	50                   	push   %eax
  8004e1:	51                   	push   %ecx
  8004e2:	52                   	push   %edx
  8004e3:	e8 05 14 00 00       	call   8018ed <sys_cputs>
  8004e8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f7:	8b 40 04             	mov    0x4(%eax),%eax
  8004fa:	8d 50 01             	lea    0x1(%eax),%edx
  8004fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800500:	89 50 04             	mov    %edx,0x4(%eax)
}
  800503:	90                   	nop
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80050f:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800516:	00 00 00 
	b.cnt = 0;
  800519:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800520:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800523:	ff 75 0c             	pushl  0xc(%ebp)
  800526:	ff 75 08             	pushl  0x8(%ebp)
  800529:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80052f:	50                   	push   %eax
  800530:	68 9d 04 80 00       	push   $0x80049d
  800535:	e8 11 02 00 00       	call   80074b <vprintfmt>
  80053a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80053d:	a0 24 40 80 00       	mov    0x804024,%al
  800542:	0f b6 c0             	movzbl %al,%eax
  800545:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80054b:	83 ec 04             	sub    $0x4,%esp
  80054e:	50                   	push   %eax
  80054f:	52                   	push   %edx
  800550:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800556:	83 c0 08             	add    $0x8,%eax
  800559:	50                   	push   %eax
  80055a:	e8 8e 13 00 00       	call   8018ed <sys_cputs>
  80055f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800562:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800569:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <cprintf>:

int cprintf(const char *fmt, ...) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800577:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80057e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800581:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	83 ec 08             	sub    $0x8,%esp
  80058a:	ff 75 f4             	pushl  -0xc(%ebp)
  80058d:	50                   	push   %eax
  80058e:	e8 73 ff ff ff       	call   800506 <vcprintf>
  800593:	83 c4 10             	add    $0x10,%esp
  800596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800599:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059c:	c9                   	leave  
  80059d:	c3                   	ret    

0080059e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80059e:	55                   	push   %ebp
  80059f:	89 e5                	mov    %esp,%ebp
  8005a1:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005a4:	e8 f2 14 00 00       	call   801a9b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005af:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b2:	83 ec 08             	sub    $0x8,%esp
  8005b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b8:	50                   	push   %eax
  8005b9:	e8 48 ff ff ff       	call   800506 <vcprintf>
  8005be:	83 c4 10             	add    $0x10,%esp
  8005c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005c4:	e8 ec 14 00 00       	call   801ab5 <sys_enable_interrupt>
	return cnt;
  8005c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005cc:	c9                   	leave  
  8005cd:	c3                   	ret    

008005ce <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005ce:	55                   	push   %ebp
  8005cf:	89 e5                	mov    %esp,%ebp
  8005d1:	53                   	push   %ebx
  8005d2:	83 ec 14             	sub    $0x14,%esp
  8005d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005db:	8b 45 14             	mov    0x14(%ebp),%eax
  8005de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005e1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005e4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ec:	77 55                	ja     800643 <printnum+0x75>
  8005ee:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005f1:	72 05                	jb     8005f8 <printnum+0x2a>
  8005f3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005f6:	77 4b                	ja     800643 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005fb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005fe:	8b 45 18             	mov    0x18(%ebp),%eax
  800601:	ba 00 00 00 00       	mov    $0x0,%edx
  800606:	52                   	push   %edx
  800607:	50                   	push   %eax
  800608:	ff 75 f4             	pushl  -0xc(%ebp)
  80060b:	ff 75 f0             	pushl  -0x10(%ebp)
  80060e:	e8 19 2b 00 00       	call   80312c <__udivdi3>
  800613:	83 c4 10             	add    $0x10,%esp
  800616:	83 ec 04             	sub    $0x4,%esp
  800619:	ff 75 20             	pushl  0x20(%ebp)
  80061c:	53                   	push   %ebx
  80061d:	ff 75 18             	pushl  0x18(%ebp)
  800620:	52                   	push   %edx
  800621:	50                   	push   %eax
  800622:	ff 75 0c             	pushl  0xc(%ebp)
  800625:	ff 75 08             	pushl  0x8(%ebp)
  800628:	e8 a1 ff ff ff       	call   8005ce <printnum>
  80062d:	83 c4 20             	add    $0x20,%esp
  800630:	eb 1a                	jmp    80064c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800632:	83 ec 08             	sub    $0x8,%esp
  800635:	ff 75 0c             	pushl  0xc(%ebp)
  800638:	ff 75 20             	pushl  0x20(%ebp)
  80063b:	8b 45 08             	mov    0x8(%ebp),%eax
  80063e:	ff d0                	call   *%eax
  800640:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800643:	ff 4d 1c             	decl   0x1c(%ebp)
  800646:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80064a:	7f e6                	jg     800632 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80064c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80064f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800657:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80065a:	53                   	push   %ebx
  80065b:	51                   	push   %ecx
  80065c:	52                   	push   %edx
  80065d:	50                   	push   %eax
  80065e:	e8 d9 2b 00 00       	call   80323c <__umoddi3>
  800663:	83 c4 10             	add    $0x10,%esp
  800666:	05 94 39 80 00       	add    $0x803994,%eax
  80066b:	8a 00                	mov    (%eax),%al
  80066d:	0f be c0             	movsbl %al,%eax
  800670:	83 ec 08             	sub    $0x8,%esp
  800673:	ff 75 0c             	pushl  0xc(%ebp)
  800676:	50                   	push   %eax
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	ff d0                	call   *%eax
  80067c:	83 c4 10             	add    $0x10,%esp
}
  80067f:	90                   	nop
  800680:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800683:	c9                   	leave  
  800684:	c3                   	ret    

00800685 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800685:	55                   	push   %ebp
  800686:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800688:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80068c:	7e 1c                	jle    8006aa <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80068e:	8b 45 08             	mov    0x8(%ebp),%eax
  800691:	8b 00                	mov    (%eax),%eax
  800693:	8d 50 08             	lea    0x8(%eax),%edx
  800696:	8b 45 08             	mov    0x8(%ebp),%eax
  800699:	89 10                	mov    %edx,(%eax)
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	8b 00                	mov    (%eax),%eax
  8006a0:	83 e8 08             	sub    $0x8,%eax
  8006a3:	8b 50 04             	mov    0x4(%eax),%edx
  8006a6:	8b 00                	mov    (%eax),%eax
  8006a8:	eb 40                	jmp    8006ea <getuint+0x65>
	else if (lflag)
  8006aa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006ae:	74 1e                	je     8006ce <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	8b 00                	mov    (%eax),%eax
  8006b5:	8d 50 04             	lea    0x4(%eax),%edx
  8006b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bb:	89 10                	mov    %edx,(%eax)
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	8b 00                	mov    (%eax),%eax
  8006c2:	83 e8 04             	sub    $0x4,%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006cc:	eb 1c                	jmp    8006ea <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	8d 50 04             	lea    0x4(%eax),%edx
  8006d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d9:	89 10                	mov    %edx,(%eax)
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	8b 00                	mov    (%eax),%eax
  8006e0:	83 e8 04             	sub    $0x4,%eax
  8006e3:	8b 00                	mov    (%eax),%eax
  8006e5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006ea:	5d                   	pop    %ebp
  8006eb:	c3                   	ret    

008006ec <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006ec:	55                   	push   %ebp
  8006ed:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006ef:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f3:	7e 1c                	jle    800711 <getint+0x25>
		return va_arg(*ap, long long);
  8006f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	8d 50 08             	lea    0x8(%eax),%edx
  8006fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800700:	89 10                	mov    %edx,(%eax)
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	8b 00                	mov    (%eax),%eax
  800707:	83 e8 08             	sub    $0x8,%eax
  80070a:	8b 50 04             	mov    0x4(%eax),%edx
  80070d:	8b 00                	mov    (%eax),%eax
  80070f:	eb 38                	jmp    800749 <getint+0x5d>
	else if (lflag)
  800711:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800715:	74 1a                	je     800731 <getint+0x45>
		return va_arg(*ap, long);
  800717:	8b 45 08             	mov    0x8(%ebp),%eax
  80071a:	8b 00                	mov    (%eax),%eax
  80071c:	8d 50 04             	lea    0x4(%eax),%edx
  80071f:	8b 45 08             	mov    0x8(%ebp),%eax
  800722:	89 10                	mov    %edx,(%eax)
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	8b 00                	mov    (%eax),%eax
  800729:	83 e8 04             	sub    $0x4,%eax
  80072c:	8b 00                	mov    (%eax),%eax
  80072e:	99                   	cltd   
  80072f:	eb 18                	jmp    800749 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800731:	8b 45 08             	mov    0x8(%ebp),%eax
  800734:	8b 00                	mov    (%eax),%eax
  800736:	8d 50 04             	lea    0x4(%eax),%edx
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	89 10                	mov    %edx,(%eax)
  80073e:	8b 45 08             	mov    0x8(%ebp),%eax
  800741:	8b 00                	mov    (%eax),%eax
  800743:	83 e8 04             	sub    $0x4,%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	99                   	cltd   
}
  800749:	5d                   	pop    %ebp
  80074a:	c3                   	ret    

0080074b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80074b:	55                   	push   %ebp
  80074c:	89 e5                	mov    %esp,%ebp
  80074e:	56                   	push   %esi
  80074f:	53                   	push   %ebx
  800750:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800753:	eb 17                	jmp    80076c <vprintfmt+0x21>
			if (ch == '\0')
  800755:	85 db                	test   %ebx,%ebx
  800757:	0f 84 af 03 00 00    	je     800b0c <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80076c:	8b 45 10             	mov    0x10(%ebp),%eax
  80076f:	8d 50 01             	lea    0x1(%eax),%edx
  800772:	89 55 10             	mov    %edx,0x10(%ebp)
  800775:	8a 00                	mov    (%eax),%al
  800777:	0f b6 d8             	movzbl %al,%ebx
  80077a:	83 fb 25             	cmp    $0x25,%ebx
  80077d:	75 d6                	jne    800755 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80077f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800783:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80078a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800791:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800798:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80079f:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a2:	8d 50 01             	lea    0x1(%eax),%edx
  8007a5:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a8:	8a 00                	mov    (%eax),%al
  8007aa:	0f b6 d8             	movzbl %al,%ebx
  8007ad:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007b0:	83 f8 55             	cmp    $0x55,%eax
  8007b3:	0f 87 2b 03 00 00    	ja     800ae4 <vprintfmt+0x399>
  8007b9:	8b 04 85 b8 39 80 00 	mov    0x8039b8(,%eax,4),%eax
  8007c0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007c2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007c6:	eb d7                	jmp    80079f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007cc:	eb d1                	jmp    80079f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007d5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d8:	89 d0                	mov    %edx,%eax
  8007da:	c1 e0 02             	shl    $0x2,%eax
  8007dd:	01 d0                	add    %edx,%eax
  8007df:	01 c0                	add    %eax,%eax
  8007e1:	01 d8                	add    %ebx,%eax
  8007e3:	83 e8 30             	sub    $0x30,%eax
  8007e6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ec:	8a 00                	mov    (%eax),%al
  8007ee:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007f1:	83 fb 2f             	cmp    $0x2f,%ebx
  8007f4:	7e 3e                	jle    800834 <vprintfmt+0xe9>
  8007f6:	83 fb 39             	cmp    $0x39,%ebx
  8007f9:	7f 39                	jg     800834 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007fe:	eb d5                	jmp    8007d5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 c0 04             	add    $0x4,%eax
  800806:	89 45 14             	mov    %eax,0x14(%ebp)
  800809:	8b 45 14             	mov    0x14(%ebp),%eax
  80080c:	83 e8 04             	sub    $0x4,%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800814:	eb 1f                	jmp    800835 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800816:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80081a:	79 83                	jns    80079f <vprintfmt+0x54>
				width = 0;
  80081c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800823:	e9 77 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800828:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80082f:	e9 6b ff ff ff       	jmp    80079f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800834:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800835:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800839:	0f 89 60 ff ff ff    	jns    80079f <vprintfmt+0x54>
				width = precision, precision = -1;
  80083f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800842:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800845:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80084c:	e9 4e ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800851:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800854:	e9 46 ff ff ff       	jmp    80079f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800859:	8b 45 14             	mov    0x14(%ebp),%eax
  80085c:	83 c0 04             	add    $0x4,%eax
  80085f:	89 45 14             	mov    %eax,0x14(%ebp)
  800862:	8b 45 14             	mov    0x14(%ebp),%eax
  800865:	83 e8 04             	sub    $0x4,%eax
  800868:	8b 00                	mov    (%eax),%eax
  80086a:	83 ec 08             	sub    $0x8,%esp
  80086d:	ff 75 0c             	pushl  0xc(%ebp)
  800870:	50                   	push   %eax
  800871:	8b 45 08             	mov    0x8(%ebp),%eax
  800874:	ff d0                	call   *%eax
  800876:	83 c4 10             	add    $0x10,%esp
			break;
  800879:	e9 89 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 c0 04             	add    $0x4,%eax
  800884:	89 45 14             	mov    %eax,0x14(%ebp)
  800887:	8b 45 14             	mov    0x14(%ebp),%eax
  80088a:	83 e8 04             	sub    $0x4,%eax
  80088d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80088f:	85 db                	test   %ebx,%ebx
  800891:	79 02                	jns    800895 <vprintfmt+0x14a>
				err = -err;
  800893:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800895:	83 fb 64             	cmp    $0x64,%ebx
  800898:	7f 0b                	jg     8008a5 <vprintfmt+0x15a>
  80089a:	8b 34 9d 00 38 80 00 	mov    0x803800(,%ebx,4),%esi
  8008a1:	85 f6                	test   %esi,%esi
  8008a3:	75 19                	jne    8008be <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008a5:	53                   	push   %ebx
  8008a6:	68 a5 39 80 00       	push   $0x8039a5
  8008ab:	ff 75 0c             	pushl  0xc(%ebp)
  8008ae:	ff 75 08             	pushl  0x8(%ebp)
  8008b1:	e8 5e 02 00 00       	call   800b14 <printfmt>
  8008b6:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b9:	e9 49 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008be:	56                   	push   %esi
  8008bf:	68 ae 39 80 00       	push   $0x8039ae
  8008c4:	ff 75 0c             	pushl  0xc(%ebp)
  8008c7:	ff 75 08             	pushl  0x8(%ebp)
  8008ca:	e8 45 02 00 00       	call   800b14 <printfmt>
  8008cf:	83 c4 10             	add    $0x10,%esp
			break;
  8008d2:	e9 30 02 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008da:	83 c0 04             	add    $0x4,%eax
  8008dd:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 e8 04             	sub    $0x4,%eax
  8008e6:	8b 30                	mov    (%eax),%esi
  8008e8:	85 f6                	test   %esi,%esi
  8008ea:	75 05                	jne    8008f1 <vprintfmt+0x1a6>
				p = "(null)";
  8008ec:	be b1 39 80 00       	mov    $0x8039b1,%esi
			if (width > 0 && padc != '-')
  8008f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008f5:	7e 6d                	jle    800964 <vprintfmt+0x219>
  8008f7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008fb:	74 67                	je     800964 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800900:	83 ec 08             	sub    $0x8,%esp
  800903:	50                   	push   %eax
  800904:	56                   	push   %esi
  800905:	e8 0c 03 00 00       	call   800c16 <strnlen>
  80090a:	83 c4 10             	add    $0x10,%esp
  80090d:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800910:	eb 16                	jmp    800928 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800912:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800916:	83 ec 08             	sub    $0x8,%esp
  800919:	ff 75 0c             	pushl  0xc(%ebp)
  80091c:	50                   	push   %eax
  80091d:	8b 45 08             	mov    0x8(%ebp),%eax
  800920:	ff d0                	call   *%eax
  800922:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800925:	ff 4d e4             	decl   -0x1c(%ebp)
  800928:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80092c:	7f e4                	jg     800912 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80092e:	eb 34                	jmp    800964 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800930:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800934:	74 1c                	je     800952 <vprintfmt+0x207>
  800936:	83 fb 1f             	cmp    $0x1f,%ebx
  800939:	7e 05                	jle    800940 <vprintfmt+0x1f5>
  80093b:	83 fb 7e             	cmp    $0x7e,%ebx
  80093e:	7e 12                	jle    800952 <vprintfmt+0x207>
					putch('?', putdat);
  800940:	83 ec 08             	sub    $0x8,%esp
  800943:	ff 75 0c             	pushl  0xc(%ebp)
  800946:	6a 3f                	push   $0x3f
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	ff d0                	call   *%eax
  80094d:	83 c4 10             	add    $0x10,%esp
  800950:	eb 0f                	jmp    800961 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800952:	83 ec 08             	sub    $0x8,%esp
  800955:	ff 75 0c             	pushl  0xc(%ebp)
  800958:	53                   	push   %ebx
  800959:	8b 45 08             	mov    0x8(%ebp),%eax
  80095c:	ff d0                	call   *%eax
  80095e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800961:	ff 4d e4             	decl   -0x1c(%ebp)
  800964:	89 f0                	mov    %esi,%eax
  800966:	8d 70 01             	lea    0x1(%eax),%esi
  800969:	8a 00                	mov    (%eax),%al
  80096b:	0f be d8             	movsbl %al,%ebx
  80096e:	85 db                	test   %ebx,%ebx
  800970:	74 24                	je     800996 <vprintfmt+0x24b>
  800972:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800976:	78 b8                	js     800930 <vprintfmt+0x1e5>
  800978:	ff 4d e0             	decl   -0x20(%ebp)
  80097b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80097f:	79 af                	jns    800930 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800981:	eb 13                	jmp    800996 <vprintfmt+0x24b>
				putch(' ', putdat);
  800983:	83 ec 08             	sub    $0x8,%esp
  800986:	ff 75 0c             	pushl  0xc(%ebp)
  800989:	6a 20                	push   $0x20
  80098b:	8b 45 08             	mov    0x8(%ebp),%eax
  80098e:	ff d0                	call   *%eax
  800990:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800993:	ff 4d e4             	decl   -0x1c(%ebp)
  800996:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80099a:	7f e7                	jg     800983 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80099c:	e9 66 01 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009a1:	83 ec 08             	sub    $0x8,%esp
  8009a4:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a7:	8d 45 14             	lea    0x14(%ebp),%eax
  8009aa:	50                   	push   %eax
  8009ab:	e8 3c fd ff ff       	call   8006ec <getint>
  8009b0:	83 c4 10             	add    $0x10,%esp
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009bf:	85 d2                	test   %edx,%edx
  8009c1:	79 23                	jns    8009e6 <vprintfmt+0x29b>
				putch('-', putdat);
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	6a 2d                	push   $0x2d
  8009cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ce:	ff d0                	call   *%eax
  8009d0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d9:	f7 d8                	neg    %eax
  8009db:	83 d2 00             	adc    $0x0,%edx
  8009de:	f7 da                	neg    %edx
  8009e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009e6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009ed:	e9 bc 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009f2:	83 ec 08             	sub    $0x8,%esp
  8009f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f8:	8d 45 14             	lea    0x14(%ebp),%eax
  8009fb:	50                   	push   %eax
  8009fc:	e8 84 fc ff ff       	call   800685 <getuint>
  800a01:	83 c4 10             	add    $0x10,%esp
  800a04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a07:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a0a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a11:	e9 98 00 00 00       	jmp    800aae <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a16:	83 ec 08             	sub    $0x8,%esp
  800a19:	ff 75 0c             	pushl  0xc(%ebp)
  800a1c:	6a 58                	push   $0x58
  800a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a21:	ff d0                	call   *%eax
  800a23:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a26:	83 ec 08             	sub    $0x8,%esp
  800a29:	ff 75 0c             	pushl  0xc(%ebp)
  800a2c:	6a 58                	push   $0x58
  800a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a31:	ff d0                	call   *%eax
  800a33:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a36:	83 ec 08             	sub    $0x8,%esp
  800a39:	ff 75 0c             	pushl  0xc(%ebp)
  800a3c:	6a 58                	push   $0x58
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	ff d0                	call   *%eax
  800a43:	83 c4 10             	add    $0x10,%esp
			break;
  800a46:	e9 bc 00 00 00       	jmp    800b07 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a4b:	83 ec 08             	sub    $0x8,%esp
  800a4e:	ff 75 0c             	pushl  0xc(%ebp)
  800a51:	6a 30                	push   $0x30
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	ff d0                	call   *%eax
  800a58:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 0c             	pushl  0xc(%ebp)
  800a61:	6a 78                	push   $0x78
  800a63:	8b 45 08             	mov    0x8(%ebp),%eax
  800a66:	ff d0                	call   *%eax
  800a68:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a6b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6e:	83 c0 04             	add    $0x4,%eax
  800a71:	89 45 14             	mov    %eax,0x14(%ebp)
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	83 e8 04             	sub    $0x4,%eax
  800a7a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a86:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a8d:	eb 1f                	jmp    800aae <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 e8             	pushl  -0x18(%ebp)
  800a95:	8d 45 14             	lea    0x14(%ebp),%eax
  800a98:	50                   	push   %eax
  800a99:	e8 e7 fb ff ff       	call   800685 <getuint>
  800a9e:	83 c4 10             	add    $0x10,%esp
  800aa1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aae:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ab2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab5:	83 ec 04             	sub    $0x4,%esp
  800ab8:	52                   	push   %edx
  800ab9:	ff 75 e4             	pushl  -0x1c(%ebp)
  800abc:	50                   	push   %eax
  800abd:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ac3:	ff 75 0c             	pushl  0xc(%ebp)
  800ac6:	ff 75 08             	pushl  0x8(%ebp)
  800ac9:	e8 00 fb ff ff       	call   8005ce <printnum>
  800ace:	83 c4 20             	add    $0x20,%esp
			break;
  800ad1:	eb 34                	jmp    800b07 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	53                   	push   %ebx
  800ada:	8b 45 08             	mov    0x8(%ebp),%eax
  800add:	ff d0                	call   *%eax
  800adf:	83 c4 10             	add    $0x10,%esp
			break;
  800ae2:	eb 23                	jmp    800b07 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ae4:	83 ec 08             	sub    $0x8,%esp
  800ae7:	ff 75 0c             	pushl  0xc(%ebp)
  800aea:	6a 25                	push   $0x25
  800aec:	8b 45 08             	mov    0x8(%ebp),%eax
  800aef:	ff d0                	call   *%eax
  800af1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800af4:	ff 4d 10             	decl   0x10(%ebp)
  800af7:	eb 03                	jmp    800afc <vprintfmt+0x3b1>
  800af9:	ff 4d 10             	decl   0x10(%ebp)
  800afc:	8b 45 10             	mov    0x10(%ebp),%eax
  800aff:	48                   	dec    %eax
  800b00:	8a 00                	mov    (%eax),%al
  800b02:	3c 25                	cmp    $0x25,%al
  800b04:	75 f3                	jne    800af9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b06:	90                   	nop
		}
	}
  800b07:	e9 47 fc ff ff       	jmp    800753 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b0c:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b10:	5b                   	pop    %ebx
  800b11:	5e                   	pop    %esi
  800b12:	5d                   	pop    %ebp
  800b13:	c3                   	ret    

00800b14 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b14:	55                   	push   %ebp
  800b15:	89 e5                	mov    %esp,%ebp
  800b17:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b1a:	8d 45 10             	lea    0x10(%ebp),%eax
  800b1d:	83 c0 04             	add    $0x4,%eax
  800b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b23:	8b 45 10             	mov    0x10(%ebp),%eax
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	50                   	push   %eax
  800b2a:	ff 75 0c             	pushl  0xc(%ebp)
  800b2d:	ff 75 08             	pushl  0x8(%ebp)
  800b30:	e8 16 fc ff ff       	call   80074b <vprintfmt>
  800b35:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b38:	90                   	nop
  800b39:	c9                   	leave  
  800b3a:	c3                   	ret    

00800b3b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b3b:	55                   	push   %ebp
  800b3c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b41:	8b 40 08             	mov    0x8(%eax),%eax
  800b44:	8d 50 01             	lea    0x1(%eax),%edx
  800b47:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b50:	8b 10                	mov    (%eax),%edx
  800b52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b55:	8b 40 04             	mov    0x4(%eax),%eax
  800b58:	39 c2                	cmp    %eax,%edx
  800b5a:	73 12                	jae    800b6e <sprintputch+0x33>
		*b->buf++ = ch;
  800b5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b5f:	8b 00                	mov    (%eax),%eax
  800b61:	8d 48 01             	lea    0x1(%eax),%ecx
  800b64:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b67:	89 0a                	mov    %ecx,(%edx)
  800b69:	8b 55 08             	mov    0x8(%ebp),%edx
  800b6c:	88 10                	mov    %dl,(%eax)
}
  800b6e:	90                   	nop
  800b6f:	5d                   	pop    %ebp
  800b70:	c3                   	ret    

00800b71 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b71:	55                   	push   %ebp
  800b72:	89 e5                	mov    %esp,%ebp
  800b74:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b80:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	01 d0                	add    %edx,%eax
  800b88:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b8b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b92:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b96:	74 06                	je     800b9e <vsnprintf+0x2d>
  800b98:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b9c:	7f 07                	jg     800ba5 <vsnprintf+0x34>
		return -E_INVAL;
  800b9e:	b8 03 00 00 00       	mov    $0x3,%eax
  800ba3:	eb 20                	jmp    800bc5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ba5:	ff 75 14             	pushl  0x14(%ebp)
  800ba8:	ff 75 10             	pushl  0x10(%ebp)
  800bab:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bae:	50                   	push   %eax
  800baf:	68 3b 0b 80 00       	push   $0x800b3b
  800bb4:	e8 92 fb ff ff       	call   80074b <vprintfmt>
  800bb9:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bbc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bbf:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bc5:	c9                   	leave  
  800bc6:	c3                   	ret    

00800bc7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc7:	55                   	push   %ebp
  800bc8:	89 e5                	mov    %esp,%ebp
  800bca:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bcd:	8d 45 10             	lea    0x10(%ebp),%eax
  800bd0:	83 c0 04             	add    $0x4,%eax
  800bd3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bdc:	50                   	push   %eax
  800bdd:	ff 75 0c             	pushl  0xc(%ebp)
  800be0:	ff 75 08             	pushl  0x8(%ebp)
  800be3:	e8 89 ff ff ff       	call   800b71 <vsnprintf>
  800be8:	83 c4 10             	add    $0x10,%esp
  800beb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bee:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c00:	eb 06                	jmp    800c08 <strlen+0x15>
		n++;
  800c02:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c05:	ff 45 08             	incl   0x8(%ebp)
  800c08:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0b:	8a 00                	mov    (%eax),%al
  800c0d:	84 c0                	test   %al,%al
  800c0f:	75 f1                	jne    800c02 <strlen+0xf>
		n++;
	return n;
  800c11:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c14:	c9                   	leave  
  800c15:	c3                   	ret    

00800c16 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c16:	55                   	push   %ebp
  800c17:	89 e5                	mov    %esp,%ebp
  800c19:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c1c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c23:	eb 09                	jmp    800c2e <strnlen+0x18>
		n++;
  800c25:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c28:	ff 45 08             	incl   0x8(%ebp)
  800c2b:	ff 4d 0c             	decl   0xc(%ebp)
  800c2e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c32:	74 09                	je     800c3d <strnlen+0x27>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 e8                	jne    800c25 <strnlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c4e:	90                   	nop
  800c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c52:	8d 50 01             	lea    0x1(%eax),%edx
  800c55:	89 55 08             	mov    %edx,0x8(%ebp)
  800c58:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c5b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c5e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c61:	8a 12                	mov    (%edx),%dl
  800c63:	88 10                	mov    %dl,(%eax)
  800c65:	8a 00                	mov    (%eax),%al
  800c67:	84 c0                	test   %al,%al
  800c69:	75 e4                	jne    800c4f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c6b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6e:	c9                   	leave  
  800c6f:	c3                   	ret    

00800c70 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c70:	55                   	push   %ebp
  800c71:	89 e5                	mov    %esp,%ebp
  800c73:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c7c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c83:	eb 1f                	jmp    800ca4 <strncpy+0x34>
		*dst++ = *src;
  800c85:	8b 45 08             	mov    0x8(%ebp),%eax
  800c88:	8d 50 01             	lea    0x1(%eax),%edx
  800c8b:	89 55 08             	mov    %edx,0x8(%ebp)
  800c8e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c98:	8a 00                	mov    (%eax),%al
  800c9a:	84 c0                	test   %al,%al
  800c9c:	74 03                	je     800ca1 <strncpy+0x31>
			src++;
  800c9e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ca1:	ff 45 fc             	incl   -0x4(%ebp)
  800ca4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca7:	3b 45 10             	cmp    0x10(%ebp),%eax
  800caa:	72 d9                	jb     800c85 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800caf:	c9                   	leave  
  800cb0:	c3                   	ret    

00800cb1 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cb1:	55                   	push   %ebp
  800cb2:	89 e5                	mov    %esp,%ebp
  800cb4:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc1:	74 30                	je     800cf3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cc3:	eb 16                	jmp    800cdb <strlcpy+0x2a>
			*dst++ = *src++;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc8:	8d 50 01             	lea    0x1(%eax),%edx
  800ccb:	89 55 08             	mov    %edx,0x8(%ebp)
  800cce:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd7:	8a 12                	mov    (%edx),%dl
  800cd9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cdb:	ff 4d 10             	decl   0x10(%ebp)
  800cde:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce2:	74 09                	je     800ced <strlcpy+0x3c>
  800ce4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce7:	8a 00                	mov    (%eax),%al
  800ce9:	84 c0                	test   %al,%al
  800ceb:	75 d8                	jne    800cc5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ced:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cf3:	8b 55 08             	mov    0x8(%ebp),%edx
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	29 c2                	sub    %eax,%edx
  800cfb:	89 d0                	mov    %edx,%eax
}
  800cfd:	c9                   	leave  
  800cfe:	c3                   	ret    

00800cff <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cff:	55                   	push   %ebp
  800d00:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d02:	eb 06                	jmp    800d0a <strcmp+0xb>
		p++, q++;
  800d04:	ff 45 08             	incl   0x8(%ebp)
  800d07:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0d:	8a 00                	mov    (%eax),%al
  800d0f:	84 c0                	test   %al,%al
  800d11:	74 0e                	je     800d21 <strcmp+0x22>
  800d13:	8b 45 08             	mov    0x8(%ebp),%eax
  800d16:	8a 10                	mov    (%eax),%dl
  800d18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d1b:	8a 00                	mov    (%eax),%al
  800d1d:	38 c2                	cmp    %al,%dl
  800d1f:	74 e3                	je     800d04 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d21:	8b 45 08             	mov    0x8(%ebp),%eax
  800d24:	8a 00                	mov    (%eax),%al
  800d26:	0f b6 d0             	movzbl %al,%edx
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 c0             	movzbl %al,%eax
  800d31:	29 c2                	sub    %eax,%edx
  800d33:	89 d0                	mov    %edx,%eax
}
  800d35:	5d                   	pop    %ebp
  800d36:	c3                   	ret    

00800d37 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d37:	55                   	push   %ebp
  800d38:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d3a:	eb 09                	jmp    800d45 <strncmp+0xe>
		n--, p++, q++;
  800d3c:	ff 4d 10             	decl   0x10(%ebp)
  800d3f:	ff 45 08             	incl   0x8(%ebp)
  800d42:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d45:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d49:	74 17                	je     800d62 <strncmp+0x2b>
  800d4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4e:	8a 00                	mov    (%eax),%al
  800d50:	84 c0                	test   %al,%al
  800d52:	74 0e                	je     800d62 <strncmp+0x2b>
  800d54:	8b 45 08             	mov    0x8(%ebp),%eax
  800d57:	8a 10                	mov    (%eax),%dl
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	38 c2                	cmp    %al,%dl
  800d60:	74 da                	je     800d3c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d62:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d66:	75 07                	jne    800d6f <strncmp+0x38>
		return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
  800d6d:	eb 14                	jmp    800d83 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d72:	8a 00                	mov    (%eax),%al
  800d74:	0f b6 d0             	movzbl %al,%edx
  800d77:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	0f b6 c0             	movzbl %al,%eax
  800d7f:	29 c2                	sub    %eax,%edx
  800d81:	89 d0                	mov    %edx,%eax
}
  800d83:	5d                   	pop    %ebp
  800d84:	c3                   	ret    

00800d85 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d85:	55                   	push   %ebp
  800d86:	89 e5                	mov    %esp,%ebp
  800d88:	83 ec 04             	sub    $0x4,%esp
  800d8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d91:	eb 12                	jmp    800da5 <strchr+0x20>
		if (*s == c)
  800d93:	8b 45 08             	mov    0x8(%ebp),%eax
  800d96:	8a 00                	mov    (%eax),%al
  800d98:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9b:	75 05                	jne    800da2 <strchr+0x1d>
			return (char *) s;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	eb 11                	jmp    800db3 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800da2:	ff 45 08             	incl   0x8(%ebp)
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8a 00                	mov    (%eax),%al
  800daa:	84 c0                	test   %al,%al
  800dac:	75 e5                	jne    800d93 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dae:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800db3:	c9                   	leave  
  800db4:	c3                   	ret    

00800db5 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800db5:	55                   	push   %ebp
  800db6:	89 e5                	mov    %esp,%ebp
  800db8:	83 ec 04             	sub    $0x4,%esp
  800dbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dbe:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dc1:	eb 0d                	jmp    800dd0 <strfind+0x1b>
		if (*s == c)
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dcb:	74 0e                	je     800ddb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dcd:	ff 45 08             	incl   0x8(%ebp)
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	8a 00                	mov    (%eax),%al
  800dd5:	84 c0                	test   %al,%al
  800dd7:	75 ea                	jne    800dc3 <strfind+0xe>
  800dd9:	eb 01                	jmp    800ddc <strfind+0x27>
		if (*s == c)
			break;
  800ddb:	90                   	nop
	return (char *) s;
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ded:	8b 45 10             	mov    0x10(%ebp),%eax
  800df0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800df3:	eb 0e                	jmp    800e03 <memset+0x22>
		*p++ = c;
  800df5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df8:	8d 50 01             	lea    0x1(%eax),%edx
  800dfb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dfe:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e01:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e03:	ff 4d f8             	decl   -0x8(%ebp)
  800e06:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e0a:	79 e9                	jns    800df5 <memset+0x14>
		*p++ = c;

	return v;
  800e0c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0f:	c9                   	leave  
  800e10:	c3                   	ret    

00800e11 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e11:	55                   	push   %ebp
  800e12:	89 e5                	mov    %esp,%ebp
  800e14:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e17:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e23:	eb 16                	jmp    800e3b <memcpy+0x2a>
		*d++ = *s++;
  800e25:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e28:	8d 50 01             	lea    0x1(%eax),%edx
  800e2b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e2e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e31:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e34:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e37:	8a 12                	mov    (%edx),%dl
  800e39:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e3b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e41:	89 55 10             	mov    %edx,0x10(%ebp)
  800e44:	85 c0                	test   %eax,%eax
  800e46:	75 dd                	jne    800e25 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e4b:	c9                   	leave  
  800e4c:	c3                   	ret    

00800e4d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e4d:	55                   	push   %ebp
  800e4e:	89 e5                	mov    %esp,%ebp
  800e50:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e53:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e62:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e65:	73 50                	jae    800eb7 <memmove+0x6a>
  800e67:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e6a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6d:	01 d0                	add    %edx,%eax
  800e6f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e72:	76 43                	jbe    800eb7 <memmove+0x6a>
		s += n;
  800e74:	8b 45 10             	mov    0x10(%ebp),%eax
  800e77:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e7d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e80:	eb 10                	jmp    800e92 <memmove+0x45>
			*--d = *--s;
  800e82:	ff 4d f8             	decl   -0x8(%ebp)
  800e85:	ff 4d fc             	decl   -0x4(%ebp)
  800e88:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8b:	8a 10                	mov    (%eax),%dl
  800e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e90:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e92:	8b 45 10             	mov    0x10(%ebp),%eax
  800e95:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e98:	89 55 10             	mov    %edx,0x10(%ebp)
  800e9b:	85 c0                	test   %eax,%eax
  800e9d:	75 e3                	jne    800e82 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e9f:	eb 23                	jmp    800ec4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ea1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea4:	8d 50 01             	lea    0x1(%eax),%edx
  800ea7:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800eaa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ead:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eb0:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eb3:	8a 12                	mov    (%edx),%dl
  800eb5:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eba:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ebd:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec0:	85 c0                	test   %eax,%eax
  800ec2:	75 dd                	jne    800ea1 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec7:	c9                   	leave  
  800ec8:	c3                   	ret    

00800ec9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec9:	55                   	push   %ebp
  800eca:	89 e5                	mov    %esp,%ebp
  800ecc:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ecf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ed5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800edb:	eb 2a                	jmp    800f07 <memcmp+0x3e>
		if (*s1 != *s2)
  800edd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee0:	8a 10                	mov    (%eax),%dl
  800ee2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	38 c2                	cmp    %al,%dl
  800ee9:	74 16                	je     800f01 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800eeb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eee:	8a 00                	mov    (%eax),%al
  800ef0:	0f b6 d0             	movzbl %al,%edx
  800ef3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef6:	8a 00                	mov    (%eax),%al
  800ef8:	0f b6 c0             	movzbl %al,%eax
  800efb:	29 c2                	sub    %eax,%edx
  800efd:	89 d0                	mov    %edx,%eax
  800eff:	eb 18                	jmp    800f19 <memcmp+0x50>
		s1++, s2++;
  800f01:	ff 45 fc             	incl   -0x4(%ebp)
  800f04:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f07:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f0d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f10:	85 c0                	test   %eax,%eax
  800f12:	75 c9                	jne    800edd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f19:	c9                   	leave  
  800f1a:	c3                   	ret    

00800f1b <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f1b:	55                   	push   %ebp
  800f1c:	89 e5                	mov    %esp,%ebp
  800f1e:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f21:	8b 55 08             	mov    0x8(%ebp),%edx
  800f24:	8b 45 10             	mov    0x10(%ebp),%eax
  800f27:	01 d0                	add    %edx,%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f2c:	eb 15                	jmp    800f43 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f31:	8a 00                	mov    (%eax),%al
  800f33:	0f b6 d0             	movzbl %al,%edx
  800f36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f39:	0f b6 c0             	movzbl %al,%eax
  800f3c:	39 c2                	cmp    %eax,%edx
  800f3e:	74 0d                	je     800f4d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f40:	ff 45 08             	incl   0x8(%ebp)
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f49:	72 e3                	jb     800f2e <memfind+0x13>
  800f4b:	eb 01                	jmp    800f4e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f4d:	90                   	nop
	return (void *) s;
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f51:	c9                   	leave  
  800f52:	c3                   	ret    

00800f53 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f53:	55                   	push   %ebp
  800f54:	89 e5                	mov    %esp,%ebp
  800f56:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f59:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f60:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f67:	eb 03                	jmp    800f6c <strtol+0x19>
		s++;
  800f69:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	3c 20                	cmp    $0x20,%al
  800f73:	74 f4                	je     800f69 <strtol+0x16>
  800f75:	8b 45 08             	mov    0x8(%ebp),%eax
  800f78:	8a 00                	mov    (%eax),%al
  800f7a:	3c 09                	cmp    $0x9,%al
  800f7c:	74 eb                	je     800f69 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 2b                	cmp    $0x2b,%al
  800f85:	75 05                	jne    800f8c <strtol+0x39>
		s++;
  800f87:	ff 45 08             	incl   0x8(%ebp)
  800f8a:	eb 13                	jmp    800f9f <strtol+0x4c>
	else if (*s == '-')
  800f8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8f:	8a 00                	mov    (%eax),%al
  800f91:	3c 2d                	cmp    $0x2d,%al
  800f93:	75 0a                	jne    800f9f <strtol+0x4c>
		s++, neg = 1;
  800f95:	ff 45 08             	incl   0x8(%ebp)
  800f98:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f9f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa3:	74 06                	je     800fab <strtol+0x58>
  800fa5:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa9:	75 20                	jne    800fcb <strtol+0x78>
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	8a 00                	mov    (%eax),%al
  800fb0:	3c 30                	cmp    $0x30,%al
  800fb2:	75 17                	jne    800fcb <strtol+0x78>
  800fb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb7:	40                   	inc    %eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	3c 78                	cmp    $0x78,%al
  800fbc:	75 0d                	jne    800fcb <strtol+0x78>
		s += 2, base = 16;
  800fbe:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fc2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc9:	eb 28                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	75 15                	jne    800fe6 <strtol+0x93>
  800fd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd4:	8a 00                	mov    (%eax),%al
  800fd6:	3c 30                	cmp    $0x30,%al
  800fd8:	75 0c                	jne    800fe6 <strtol+0x93>
		s++, base = 8;
  800fda:	ff 45 08             	incl   0x8(%ebp)
  800fdd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fe4:	eb 0d                	jmp    800ff3 <strtol+0xa0>
	else if (base == 0)
  800fe6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fea:	75 07                	jne    800ff3 <strtol+0xa0>
		base = 10;
  800fec:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800ff3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff6:	8a 00                	mov    (%eax),%al
  800ff8:	3c 2f                	cmp    $0x2f,%al
  800ffa:	7e 19                	jle    801015 <strtol+0xc2>
  800ffc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fff:	8a 00                	mov    (%eax),%al
  801001:	3c 39                	cmp    $0x39,%al
  801003:	7f 10                	jg     801015 <strtol+0xc2>
			dig = *s - '0';
  801005:	8b 45 08             	mov    0x8(%ebp),%eax
  801008:	8a 00                	mov    (%eax),%al
  80100a:	0f be c0             	movsbl %al,%eax
  80100d:	83 e8 30             	sub    $0x30,%eax
  801010:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801013:	eb 42                	jmp    801057 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801015:	8b 45 08             	mov    0x8(%ebp),%eax
  801018:	8a 00                	mov    (%eax),%al
  80101a:	3c 60                	cmp    $0x60,%al
  80101c:	7e 19                	jle    801037 <strtol+0xe4>
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 7a                	cmp    $0x7a,%al
  801025:	7f 10                	jg     801037 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801027:	8b 45 08             	mov    0x8(%ebp),%eax
  80102a:	8a 00                	mov    (%eax),%al
  80102c:	0f be c0             	movsbl %al,%eax
  80102f:	83 e8 57             	sub    $0x57,%eax
  801032:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801035:	eb 20                	jmp    801057 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
  80103a:	8a 00                	mov    (%eax),%al
  80103c:	3c 40                	cmp    $0x40,%al
  80103e:	7e 39                	jle    801079 <strtol+0x126>
  801040:	8b 45 08             	mov    0x8(%ebp),%eax
  801043:	8a 00                	mov    (%eax),%al
  801045:	3c 5a                	cmp    $0x5a,%al
  801047:	7f 30                	jg     801079 <strtol+0x126>
			dig = *s - 'A' + 10;
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	0f be c0             	movsbl %al,%eax
  801051:	83 e8 37             	sub    $0x37,%eax
  801054:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801057:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80105a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80105d:	7d 19                	jge    801078 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80105f:	ff 45 08             	incl   0x8(%ebp)
  801062:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801065:	0f af 45 10          	imul   0x10(%ebp),%eax
  801069:	89 c2                	mov    %eax,%edx
  80106b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80106e:	01 d0                	add    %edx,%eax
  801070:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801073:	e9 7b ff ff ff       	jmp    800ff3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801078:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801079:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80107d:	74 08                	je     801087 <strtol+0x134>
		*endptr = (char *) s;
  80107f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801082:	8b 55 08             	mov    0x8(%ebp),%edx
  801085:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801087:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80108b:	74 07                	je     801094 <strtol+0x141>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801090:	f7 d8                	neg    %eax
  801092:	eb 03                	jmp    801097 <strtol+0x144>
  801094:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801097:	c9                   	leave  
  801098:	c3                   	ret    

00801099 <ltostr>:

void
ltostr(long value, char *str)
{
  801099:	55                   	push   %ebp
  80109a:	89 e5                	mov    %esp,%ebp
  80109c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80109f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010ad:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010b1:	79 13                	jns    8010c6 <ltostr+0x2d>
	{
		neg = 1;
  8010b3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010bd:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010c0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010c3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010ce:	99                   	cltd   
  8010cf:	f7 f9                	idiv   %ecx
  8010d1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010d4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d7:	8d 50 01             	lea    0x1(%eax),%edx
  8010da:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010dd:	89 c2                	mov    %eax,%edx
  8010df:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e2:	01 d0                	add    %edx,%eax
  8010e4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e7:	83 c2 30             	add    $0x30,%edx
  8010ea:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010ec:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010ef:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010f4:	f7 e9                	imul   %ecx
  8010f6:	c1 fa 02             	sar    $0x2,%edx
  8010f9:	89 c8                	mov    %ecx,%eax
  8010fb:	c1 f8 1f             	sar    $0x1f,%eax
  8010fe:	29 c2                	sub    %eax,%edx
  801100:	89 d0                	mov    %edx,%eax
  801102:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801105:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801108:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80110d:	f7 e9                	imul   %ecx
  80110f:	c1 fa 02             	sar    $0x2,%edx
  801112:	89 c8                	mov    %ecx,%eax
  801114:	c1 f8 1f             	sar    $0x1f,%eax
  801117:	29 c2                	sub    %eax,%edx
  801119:	89 d0                	mov    %edx,%eax
  80111b:	c1 e0 02             	shl    $0x2,%eax
  80111e:	01 d0                	add    %edx,%eax
  801120:	01 c0                	add    %eax,%eax
  801122:	29 c1                	sub    %eax,%ecx
  801124:	89 ca                	mov    %ecx,%edx
  801126:	85 d2                	test   %edx,%edx
  801128:	75 9c                	jne    8010c6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80112a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801131:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801134:	48                   	dec    %eax
  801135:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801138:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80113c:	74 3d                	je     80117b <ltostr+0xe2>
		start = 1 ;
  80113e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801145:	eb 34                	jmp    80117b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801147:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80114a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114d:	01 d0                	add    %edx,%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801154:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 c2                	add    %eax,%edx
  80115c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	01 c8                	add    %ecx,%eax
  801164:	8a 00                	mov    (%eax),%al
  801166:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801168:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80116b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116e:	01 c2                	add    %eax,%edx
  801170:	8a 45 eb             	mov    -0x15(%ebp),%al
  801173:	88 02                	mov    %al,(%edx)
		start++ ;
  801175:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801178:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80117b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80117e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801181:	7c c4                	jl     801147 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801183:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801186:	8b 45 0c             	mov    0xc(%ebp),%eax
  801189:	01 d0                	add    %edx,%eax
  80118b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80118e:	90                   	nop
  80118f:	c9                   	leave  
  801190:	c3                   	ret    

00801191 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801191:	55                   	push   %ebp
  801192:	89 e5                	mov    %esp,%ebp
  801194:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801197:	ff 75 08             	pushl  0x8(%ebp)
  80119a:	e8 54 fa ff ff       	call   800bf3 <strlen>
  80119f:	83 c4 04             	add    $0x4,%esp
  8011a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011a5:	ff 75 0c             	pushl  0xc(%ebp)
  8011a8:	e8 46 fa ff ff       	call   800bf3 <strlen>
  8011ad:	83 c4 04             	add    $0x4,%esp
  8011b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011c1:	eb 17                	jmp    8011da <strcconcat+0x49>
		final[s] = str1[s] ;
  8011c3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c9:	01 c2                	add    %eax,%edx
  8011cb:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d1:	01 c8                	add    %ecx,%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d7:	ff 45 fc             	incl   -0x4(%ebp)
  8011da:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011e0:	7c e1                	jl     8011c3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011f0:	eb 1f                	jmp    801211 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011f2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011f5:	8d 50 01             	lea    0x1(%eax),%edx
  8011f8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011fb:	89 c2                	mov    %eax,%edx
  8011fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801200:	01 c2                	add    %eax,%edx
  801202:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801205:	8b 45 0c             	mov    0xc(%ebp),%eax
  801208:	01 c8                	add    %ecx,%eax
  80120a:	8a 00                	mov    (%eax),%al
  80120c:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80120e:	ff 45 f8             	incl   -0x8(%ebp)
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801217:	7c d9                	jl     8011f2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801219:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80121c:	8b 45 10             	mov    0x10(%ebp),%eax
  80121f:	01 d0                	add    %edx,%eax
  801221:	c6 00 00             	movb   $0x0,(%eax)
}
  801224:	90                   	nop
  801225:	c9                   	leave  
  801226:	c3                   	ret    

00801227 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80122a:	8b 45 14             	mov    0x14(%ebp),%eax
  80122d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801233:	8b 45 14             	mov    0x14(%ebp),%eax
  801236:	8b 00                	mov    (%eax),%eax
  801238:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80123f:	8b 45 10             	mov    0x10(%ebp),%eax
  801242:	01 d0                	add    %edx,%eax
  801244:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80124a:	eb 0c                	jmp    801258 <strsplit+0x31>
			*string++ = 0;
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8d 50 01             	lea    0x1(%eax),%edx
  801252:	89 55 08             	mov    %edx,0x8(%ebp)
  801255:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801258:	8b 45 08             	mov    0x8(%ebp),%eax
  80125b:	8a 00                	mov    (%eax),%al
  80125d:	84 c0                	test   %al,%al
  80125f:	74 18                	je     801279 <strsplit+0x52>
  801261:	8b 45 08             	mov    0x8(%ebp),%eax
  801264:	8a 00                	mov    (%eax),%al
  801266:	0f be c0             	movsbl %al,%eax
  801269:	50                   	push   %eax
  80126a:	ff 75 0c             	pushl  0xc(%ebp)
  80126d:	e8 13 fb ff ff       	call   800d85 <strchr>
  801272:	83 c4 08             	add    $0x8,%esp
  801275:	85 c0                	test   %eax,%eax
  801277:	75 d3                	jne    80124c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	84 c0                	test   %al,%al
  801280:	74 5a                	je     8012dc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801282:	8b 45 14             	mov    0x14(%ebp),%eax
  801285:	8b 00                	mov    (%eax),%eax
  801287:	83 f8 0f             	cmp    $0xf,%eax
  80128a:	75 07                	jne    801293 <strsplit+0x6c>
		{
			return 0;
  80128c:	b8 00 00 00 00       	mov    $0x0,%eax
  801291:	eb 66                	jmp    8012f9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	8b 00                	mov    (%eax),%eax
  801298:	8d 48 01             	lea    0x1(%eax),%ecx
  80129b:	8b 55 14             	mov    0x14(%ebp),%edx
  80129e:	89 0a                	mov    %ecx,(%edx)
  8012a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012aa:	01 c2                	add    %eax,%edx
  8012ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8012af:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b1:	eb 03                	jmp    8012b6 <strsplit+0x8f>
			string++;
  8012b3:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b9:	8a 00                	mov    (%eax),%al
  8012bb:	84 c0                	test   %al,%al
  8012bd:	74 8b                	je     80124a <strsplit+0x23>
  8012bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c2:	8a 00                	mov    (%eax),%al
  8012c4:	0f be c0             	movsbl %al,%eax
  8012c7:	50                   	push   %eax
  8012c8:	ff 75 0c             	pushl  0xc(%ebp)
  8012cb:	e8 b5 fa ff ff       	call   800d85 <strchr>
  8012d0:	83 c4 08             	add    $0x8,%esp
  8012d3:	85 c0                	test   %eax,%eax
  8012d5:	74 dc                	je     8012b3 <strsplit+0x8c>
			string++;
	}
  8012d7:	e9 6e ff ff ff       	jmp    80124a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012dc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e0:	8b 00                	mov    (%eax),%eax
  8012e2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ec:	01 d0                	add    %edx,%eax
  8012ee:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012f4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f9:	c9                   	leave  
  8012fa:	c3                   	ret    

008012fb <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012fb:	55                   	push   %ebp
  8012fc:	89 e5                	mov    %esp,%ebp
  8012fe:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801301:	a1 04 40 80 00       	mov    0x804004,%eax
  801306:	85 c0                	test   %eax,%eax
  801308:	74 1f                	je     801329 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80130a:	e8 1d 00 00 00       	call   80132c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80130f:	83 ec 0c             	sub    $0xc,%esp
  801312:	68 10 3b 80 00       	push   $0x803b10
  801317:	e8 55 f2 ff ff       	call   800571 <cprintf>
  80131c:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80131f:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801326:	00 00 00 
	}
}
  801329:	90                   	nop
  80132a:	c9                   	leave  
  80132b:	c3                   	ret    

0080132c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80132c:	55                   	push   %ebp
  80132d:	89 e5                	mov    %esp,%ebp
  80132f:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801332:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801339:	00 00 00 
  80133c:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801343:	00 00 00 
  801346:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80134d:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801350:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801357:	00 00 00 
  80135a:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801361:	00 00 00 
  801364:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80136b:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  80136e:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801375:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801378:	c1 e8 0c             	shr    $0xc,%eax
  80137b:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801380:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801387:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80138a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80138f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801394:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  801399:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8013a0:	a1 20 41 80 00       	mov    0x804120,%eax
  8013a5:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8013a9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8013ac:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8013b3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b9:	01 d0                	add    %edx,%eax
  8013bb:	48                   	dec    %eax
  8013bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013c2:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c7:	f7 75 e4             	divl   -0x1c(%ebp)
  8013ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013cd:	29 d0                	sub    %edx,%eax
  8013cf:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8013d2:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8013d9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013dc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013e1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013e6:	83 ec 04             	sub    $0x4,%esp
  8013e9:	6a 07                	push   $0x7
  8013eb:	ff 75 e8             	pushl  -0x18(%ebp)
  8013ee:	50                   	push   %eax
  8013ef:	e8 3d 06 00 00       	call   801a31 <sys_allocate_chunk>
  8013f4:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013f7:	a1 20 41 80 00       	mov    0x804120,%eax
  8013fc:	83 ec 0c             	sub    $0xc,%esp
  8013ff:	50                   	push   %eax
  801400:	e8 b2 0c 00 00       	call   8020b7 <initialize_MemBlocksList>
  801405:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801408:	a1 4c 41 80 00       	mov    0x80414c,%eax
  80140d:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801410:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801414:	0f 84 f3 00 00 00    	je     80150d <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  80141a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80141e:	75 14                	jne    801434 <initialize_dyn_block_system+0x108>
  801420:	83 ec 04             	sub    $0x4,%esp
  801423:	68 35 3b 80 00       	push   $0x803b35
  801428:	6a 36                	push   $0x36
  80142a:	68 53 3b 80 00       	push   $0x803b53
  80142f:	e8 89 ee ff ff       	call   8002bd <_panic>
  801434:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801437:	8b 00                	mov    (%eax),%eax
  801439:	85 c0                	test   %eax,%eax
  80143b:	74 10                	je     80144d <initialize_dyn_block_system+0x121>
  80143d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801440:	8b 00                	mov    (%eax),%eax
  801442:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801445:	8b 52 04             	mov    0x4(%edx),%edx
  801448:	89 50 04             	mov    %edx,0x4(%eax)
  80144b:	eb 0b                	jmp    801458 <initialize_dyn_block_system+0x12c>
  80144d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801450:	8b 40 04             	mov    0x4(%eax),%eax
  801453:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801458:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80145b:	8b 40 04             	mov    0x4(%eax),%eax
  80145e:	85 c0                	test   %eax,%eax
  801460:	74 0f                	je     801471 <initialize_dyn_block_system+0x145>
  801462:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801465:	8b 40 04             	mov    0x4(%eax),%eax
  801468:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80146b:	8b 12                	mov    (%edx),%edx
  80146d:	89 10                	mov    %edx,(%eax)
  80146f:	eb 0a                	jmp    80147b <initialize_dyn_block_system+0x14f>
  801471:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801474:	8b 00                	mov    (%eax),%eax
  801476:	a3 48 41 80 00       	mov    %eax,0x804148
  80147b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80147e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801484:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801487:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80148e:	a1 54 41 80 00       	mov    0x804154,%eax
  801493:	48                   	dec    %eax
  801494:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801499:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80149c:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8014a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014a6:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8014ad:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014b1:	75 14                	jne    8014c7 <initialize_dyn_block_system+0x19b>
  8014b3:	83 ec 04             	sub    $0x4,%esp
  8014b6:	68 60 3b 80 00       	push   $0x803b60
  8014bb:	6a 3e                	push   $0x3e
  8014bd:	68 53 3b 80 00       	push   $0x803b53
  8014c2:	e8 f6 ed ff ff       	call   8002bd <_panic>
  8014c7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8014cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014d0:	89 10                	mov    %edx,(%eax)
  8014d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014d5:	8b 00                	mov    (%eax),%eax
  8014d7:	85 c0                	test   %eax,%eax
  8014d9:	74 0d                	je     8014e8 <initialize_dyn_block_system+0x1bc>
  8014db:	a1 38 41 80 00       	mov    0x804138,%eax
  8014e0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014e3:	89 50 04             	mov    %edx,0x4(%eax)
  8014e6:	eb 08                	jmp    8014f0 <initialize_dyn_block_system+0x1c4>
  8014e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014eb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014f3:	a3 38 41 80 00       	mov    %eax,0x804138
  8014f8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801502:	a1 44 41 80 00       	mov    0x804144,%eax
  801507:	40                   	inc    %eax
  801508:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  80150d:	90                   	nop
  80150e:	c9                   	leave  
  80150f:	c3                   	ret    

00801510 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801510:	55                   	push   %ebp
  801511:	89 e5                	mov    %esp,%ebp
  801513:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801516:	e8 e0 fd ff ff       	call   8012fb <InitializeUHeap>
		if (size == 0) return NULL ;
  80151b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80151f:	75 07                	jne    801528 <malloc+0x18>
  801521:	b8 00 00 00 00       	mov    $0x0,%eax
  801526:	eb 7f                	jmp    8015a7 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801528:	e8 d2 08 00 00       	call   801dff <sys_isUHeapPlacementStrategyFIRSTFIT>
  80152d:	85 c0                	test   %eax,%eax
  80152f:	74 71                	je     8015a2 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801531:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801538:	8b 55 08             	mov    0x8(%ebp),%edx
  80153b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80153e:	01 d0                	add    %edx,%eax
  801540:	48                   	dec    %eax
  801541:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801544:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801547:	ba 00 00 00 00       	mov    $0x0,%edx
  80154c:	f7 75 f4             	divl   -0xc(%ebp)
  80154f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801552:	29 d0                	sub    %edx,%eax
  801554:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801557:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  80155e:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801565:	76 07                	jbe    80156e <malloc+0x5e>
					return NULL ;
  801567:	b8 00 00 00 00       	mov    $0x0,%eax
  80156c:	eb 39                	jmp    8015a7 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  80156e:	83 ec 0c             	sub    $0xc,%esp
  801571:	ff 75 08             	pushl  0x8(%ebp)
  801574:	e8 e6 0d 00 00       	call   80235f <alloc_block_FF>
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  80157f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801583:	74 16                	je     80159b <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801585:	83 ec 0c             	sub    $0xc,%esp
  801588:	ff 75 ec             	pushl  -0x14(%ebp)
  80158b:	e8 37 0c 00 00       	call   8021c7 <insert_sorted_allocList>
  801590:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801593:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801596:	8b 40 08             	mov    0x8(%eax),%eax
  801599:	eb 0c                	jmp    8015a7 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  80159b:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a0:	eb 05                	jmp    8015a7 <malloc+0x97>
				}
		}
	return 0;
  8015a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a7:	c9                   	leave  
  8015a8:	c3                   	ret    

008015a9 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015a9:	55                   	push   %ebp
  8015aa:	89 e5                	mov    %esp,%ebp
  8015ac:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8015af:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8015b5:	83 ec 08             	sub    $0x8,%esp
  8015b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8015bb:	68 40 40 80 00       	push   $0x804040
  8015c0:	e8 cf 0b 00 00       	call   802194 <find_block>
  8015c5:	83 c4 10             	add    $0x10,%esp
  8015c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8015cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8015d1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8015d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d7:	8b 40 08             	mov    0x8(%eax),%eax
  8015da:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8015dd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015e1:	0f 84 a1 00 00 00    	je     801688 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8015e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015eb:	75 17                	jne    801604 <free+0x5b>
  8015ed:	83 ec 04             	sub    $0x4,%esp
  8015f0:	68 35 3b 80 00       	push   $0x803b35
  8015f5:	68 80 00 00 00       	push   $0x80
  8015fa:	68 53 3b 80 00       	push   $0x803b53
  8015ff:	e8 b9 ec ff ff       	call   8002bd <_panic>
  801604:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801607:	8b 00                	mov    (%eax),%eax
  801609:	85 c0                	test   %eax,%eax
  80160b:	74 10                	je     80161d <free+0x74>
  80160d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801610:	8b 00                	mov    (%eax),%eax
  801612:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801615:	8b 52 04             	mov    0x4(%edx),%edx
  801618:	89 50 04             	mov    %edx,0x4(%eax)
  80161b:	eb 0b                	jmp    801628 <free+0x7f>
  80161d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801620:	8b 40 04             	mov    0x4(%eax),%eax
  801623:	a3 44 40 80 00       	mov    %eax,0x804044
  801628:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162b:	8b 40 04             	mov    0x4(%eax),%eax
  80162e:	85 c0                	test   %eax,%eax
  801630:	74 0f                	je     801641 <free+0x98>
  801632:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801635:	8b 40 04             	mov    0x4(%eax),%eax
  801638:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80163b:	8b 12                	mov    (%edx),%edx
  80163d:	89 10                	mov    %edx,(%eax)
  80163f:	eb 0a                	jmp    80164b <free+0xa2>
  801641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801644:	8b 00                	mov    (%eax),%eax
  801646:	a3 40 40 80 00       	mov    %eax,0x804040
  80164b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801657:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80165e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801663:	48                   	dec    %eax
  801664:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  801669:	83 ec 0c             	sub    $0xc,%esp
  80166c:	ff 75 f0             	pushl  -0x10(%ebp)
  80166f:	e8 29 12 00 00       	call   80289d <insert_sorted_with_merge_freeList>
  801674:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801677:	83 ec 08             	sub    $0x8,%esp
  80167a:	ff 75 ec             	pushl  -0x14(%ebp)
  80167d:	ff 75 e8             	pushl  -0x18(%ebp)
  801680:	e8 74 03 00 00       	call   8019f9 <sys_free_user_mem>
  801685:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801688:	90                   	nop
  801689:	c9                   	leave  
  80168a:	c3                   	ret    

0080168b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  80168b:	55                   	push   %ebp
  80168c:	89 e5                	mov    %esp,%ebp
  80168e:	83 ec 38             	sub    $0x38,%esp
  801691:	8b 45 10             	mov    0x10(%ebp),%eax
  801694:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801697:	e8 5f fc ff ff       	call   8012fb <InitializeUHeap>
	if (size == 0) return NULL ;
  80169c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016a0:	75 0a                	jne    8016ac <smalloc+0x21>
  8016a2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a7:	e9 b2 00 00 00       	jmp    80175e <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8016ac:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8016b3:	76 0a                	jbe    8016bf <smalloc+0x34>
		return NULL;
  8016b5:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ba:	e9 9f 00 00 00       	jmp    80175e <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016bf:	e8 3b 07 00 00       	call   801dff <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016c4:	85 c0                	test   %eax,%eax
  8016c6:	0f 84 8d 00 00 00    	je     801759 <smalloc+0xce>
	struct MemBlock *b = NULL;
  8016cc:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8016d3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e0:	01 d0                	add    %edx,%eax
  8016e2:	48                   	dec    %eax
  8016e3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e9:	ba 00 00 00 00       	mov    $0x0,%edx
  8016ee:	f7 75 f0             	divl   -0x10(%ebp)
  8016f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016f4:	29 d0                	sub    %edx,%eax
  8016f6:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8016f9:	83 ec 0c             	sub    $0xc,%esp
  8016fc:	ff 75 e8             	pushl  -0x18(%ebp)
  8016ff:	e8 5b 0c 00 00       	call   80235f <alloc_block_FF>
  801704:	83 c4 10             	add    $0x10,%esp
  801707:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  80170a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80170e:	75 07                	jne    801717 <smalloc+0x8c>
			return NULL;
  801710:	b8 00 00 00 00       	mov    $0x0,%eax
  801715:	eb 47                	jmp    80175e <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801717:	83 ec 0c             	sub    $0xc,%esp
  80171a:	ff 75 f4             	pushl  -0xc(%ebp)
  80171d:	e8 a5 0a 00 00       	call   8021c7 <insert_sorted_allocList>
  801722:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801728:	8b 40 08             	mov    0x8(%eax),%eax
  80172b:	89 c2                	mov    %eax,%edx
  80172d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801731:	52                   	push   %edx
  801732:	50                   	push   %eax
  801733:	ff 75 0c             	pushl  0xc(%ebp)
  801736:	ff 75 08             	pushl  0x8(%ebp)
  801739:	e8 46 04 00 00       	call   801b84 <sys_createSharedObject>
  80173e:	83 c4 10             	add    $0x10,%esp
  801741:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801744:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801748:	78 08                	js     801752 <smalloc+0xc7>
		return (void *)b->sva;
  80174a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80174d:	8b 40 08             	mov    0x8(%eax),%eax
  801750:	eb 0c                	jmp    80175e <smalloc+0xd3>
		}else{
		return NULL;
  801752:	b8 00 00 00 00       	mov    $0x0,%eax
  801757:	eb 05                	jmp    80175e <smalloc+0xd3>
			}

	}return NULL;
  801759:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80175e:	c9                   	leave  
  80175f:	c3                   	ret    

00801760 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801760:	55                   	push   %ebp
  801761:	89 e5                	mov    %esp,%ebp
  801763:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801766:	e8 90 fb ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80176b:	e8 8f 06 00 00       	call   801dff <sys_isUHeapPlacementStrategyFIRSTFIT>
  801770:	85 c0                	test   %eax,%eax
  801772:	0f 84 ad 00 00 00    	je     801825 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801778:	83 ec 08             	sub    $0x8,%esp
  80177b:	ff 75 0c             	pushl  0xc(%ebp)
  80177e:	ff 75 08             	pushl  0x8(%ebp)
  801781:	e8 28 04 00 00       	call   801bae <sys_getSizeOfSharedObject>
  801786:	83 c4 10             	add    $0x10,%esp
  801789:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  80178c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801790:	79 0a                	jns    80179c <sget+0x3c>
    {
    	return NULL;
  801792:	b8 00 00 00 00       	mov    $0x0,%eax
  801797:	e9 8e 00 00 00       	jmp    80182a <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  80179c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  8017a3:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017aa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017b0:	01 d0                	add    %edx,%eax
  8017b2:	48                   	dec    %eax
  8017b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017be:	f7 75 ec             	divl   -0x14(%ebp)
  8017c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017c4:	29 d0                	sub    %edx,%eax
  8017c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8017c9:	83 ec 0c             	sub    $0xc,%esp
  8017cc:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017cf:	e8 8b 0b 00 00       	call   80235f <alloc_block_FF>
  8017d4:	83 c4 10             	add    $0x10,%esp
  8017d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8017da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017de:	75 07                	jne    8017e7 <sget+0x87>
				return NULL;
  8017e0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e5:	eb 43                	jmp    80182a <sget+0xca>
			}
			insert_sorted_allocList(b);
  8017e7:	83 ec 0c             	sub    $0xc,%esp
  8017ea:	ff 75 f0             	pushl  -0x10(%ebp)
  8017ed:	e8 d5 09 00 00       	call   8021c7 <insert_sorted_allocList>
  8017f2:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8017f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f8:	8b 40 08             	mov    0x8(%eax),%eax
  8017fb:	83 ec 04             	sub    $0x4,%esp
  8017fe:	50                   	push   %eax
  8017ff:	ff 75 0c             	pushl  0xc(%ebp)
  801802:	ff 75 08             	pushl  0x8(%ebp)
  801805:	e8 c1 03 00 00       	call   801bcb <sys_getSharedObject>
  80180a:	83 c4 10             	add    $0x10,%esp
  80180d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801810:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801814:	78 08                	js     80181e <sget+0xbe>
			return (void *)b->sva;
  801816:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801819:	8b 40 08             	mov    0x8(%eax),%eax
  80181c:	eb 0c                	jmp    80182a <sget+0xca>
			}else{
			return NULL;
  80181e:	b8 00 00 00 00       	mov    $0x0,%eax
  801823:	eb 05                	jmp    80182a <sget+0xca>
			}
    }}return NULL;
  801825:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80182a:	c9                   	leave  
  80182b:	c3                   	ret    

0080182c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80182c:	55                   	push   %ebp
  80182d:	89 e5                	mov    %esp,%ebp
  80182f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801832:	e8 c4 fa ff ff       	call   8012fb <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801837:	83 ec 04             	sub    $0x4,%esp
  80183a:	68 84 3b 80 00       	push   $0x803b84
  80183f:	68 03 01 00 00       	push   $0x103
  801844:	68 53 3b 80 00       	push   $0x803b53
  801849:	e8 6f ea ff ff       	call   8002bd <_panic>

0080184e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
  801851:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801854:	83 ec 04             	sub    $0x4,%esp
  801857:	68 ac 3b 80 00       	push   $0x803bac
  80185c:	68 17 01 00 00       	push   $0x117
  801861:	68 53 3b 80 00       	push   $0x803b53
  801866:	e8 52 ea ff ff       	call   8002bd <_panic>

0080186b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
  80186e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801871:	83 ec 04             	sub    $0x4,%esp
  801874:	68 d0 3b 80 00       	push   $0x803bd0
  801879:	68 22 01 00 00       	push   $0x122
  80187e:	68 53 3b 80 00       	push   $0x803b53
  801883:	e8 35 ea ff ff       	call   8002bd <_panic>

00801888 <shrink>:

}
void shrink(uint32 newSize)
{
  801888:	55                   	push   %ebp
  801889:	89 e5                	mov    %esp,%ebp
  80188b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80188e:	83 ec 04             	sub    $0x4,%esp
  801891:	68 d0 3b 80 00       	push   $0x803bd0
  801896:	68 27 01 00 00       	push   $0x127
  80189b:	68 53 3b 80 00       	push   $0x803b53
  8018a0:	e8 18 ea ff ff       	call   8002bd <_panic>

008018a5 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
  8018a8:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ab:	83 ec 04             	sub    $0x4,%esp
  8018ae:	68 d0 3b 80 00       	push   $0x803bd0
  8018b3:	68 2c 01 00 00       	push   $0x12c
  8018b8:	68 53 3b 80 00       	push   $0x803b53
  8018bd:	e8 fb e9 ff ff       	call   8002bd <_panic>

008018c2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018c2:	55                   	push   %ebp
  8018c3:	89 e5                	mov    %esp,%ebp
  8018c5:	57                   	push   %edi
  8018c6:	56                   	push   %esi
  8018c7:	53                   	push   %ebx
  8018c8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018d4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018d7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018da:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018dd:	cd 30                	int    $0x30
  8018df:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018e5:	83 c4 10             	add    $0x10,%esp
  8018e8:	5b                   	pop    %ebx
  8018e9:	5e                   	pop    %esi
  8018ea:	5f                   	pop    %edi
  8018eb:	5d                   	pop    %ebp
  8018ec:	c3                   	ret    

008018ed <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018ed:	55                   	push   %ebp
  8018ee:	89 e5                	mov    %esp,%ebp
  8018f0:	83 ec 04             	sub    $0x4,%esp
  8018f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8018f6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018f9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801900:	6a 00                	push   $0x0
  801902:	6a 00                	push   $0x0
  801904:	52                   	push   %edx
  801905:	ff 75 0c             	pushl  0xc(%ebp)
  801908:	50                   	push   %eax
  801909:	6a 00                	push   $0x0
  80190b:	e8 b2 ff ff ff       	call   8018c2 <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
}
  801913:	90                   	nop
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <sys_cgetc>:

int
sys_cgetc(void)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 01                	push   $0x1
  801925:	e8 98 ff ff ff       	call   8018c2 <syscall>
  80192a:	83 c4 18             	add    $0x18,%esp
}
  80192d:	c9                   	leave  
  80192e:	c3                   	ret    

0080192f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80192f:	55                   	push   %ebp
  801930:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801932:	8b 55 0c             	mov    0xc(%ebp),%edx
  801935:	8b 45 08             	mov    0x8(%ebp),%eax
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	52                   	push   %edx
  80193f:	50                   	push   %eax
  801940:	6a 05                	push   $0x5
  801942:	e8 7b ff ff ff       	call   8018c2 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
  80194f:	56                   	push   %esi
  801950:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801951:	8b 75 18             	mov    0x18(%ebp),%esi
  801954:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801957:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80195a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80195d:	8b 45 08             	mov    0x8(%ebp),%eax
  801960:	56                   	push   %esi
  801961:	53                   	push   %ebx
  801962:	51                   	push   %ecx
  801963:	52                   	push   %edx
  801964:	50                   	push   %eax
  801965:	6a 06                	push   $0x6
  801967:	e8 56 ff ff ff       	call   8018c2 <syscall>
  80196c:	83 c4 18             	add    $0x18,%esp
}
  80196f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801972:	5b                   	pop    %ebx
  801973:	5e                   	pop    %esi
  801974:	5d                   	pop    %ebp
  801975:	c3                   	ret    

00801976 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801976:	55                   	push   %ebp
  801977:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801979:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197c:	8b 45 08             	mov    0x8(%ebp),%eax
  80197f:	6a 00                	push   $0x0
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	52                   	push   %edx
  801986:	50                   	push   %eax
  801987:	6a 07                	push   $0x7
  801989:	e8 34 ff ff ff       	call   8018c2 <syscall>
  80198e:	83 c4 18             	add    $0x18,%esp
}
  801991:	c9                   	leave  
  801992:	c3                   	ret    

00801993 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801993:	55                   	push   %ebp
  801994:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	ff 75 0c             	pushl  0xc(%ebp)
  80199f:	ff 75 08             	pushl  0x8(%ebp)
  8019a2:	6a 08                	push   $0x8
  8019a4:	e8 19 ff ff ff       	call   8018c2 <syscall>
  8019a9:	83 c4 18             	add    $0x18,%esp
}
  8019ac:	c9                   	leave  
  8019ad:	c3                   	ret    

008019ae <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019ae:	55                   	push   %ebp
  8019af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019b1:	6a 00                	push   $0x0
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	6a 00                	push   $0x0
  8019bb:	6a 09                	push   $0x9
  8019bd:	e8 00 ff ff ff       	call   8018c2 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 0a                	push   $0xa
  8019d6:	e8 e7 fe ff ff       	call   8018c2 <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 0b                	push   $0xb
  8019ef:	e8 ce fe ff ff       	call   8018c2 <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	ff 75 0c             	pushl  0xc(%ebp)
  801a05:	ff 75 08             	pushl  0x8(%ebp)
  801a08:	6a 0f                	push   $0xf
  801a0a:	e8 b3 fe ff ff       	call   8018c2 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
	return;
  801a12:	90                   	nop
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	ff 75 0c             	pushl  0xc(%ebp)
  801a21:	ff 75 08             	pushl  0x8(%ebp)
  801a24:	6a 10                	push   $0x10
  801a26:	e8 97 fe ff ff       	call   8018c2 <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2e:	90                   	nop
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	ff 75 10             	pushl  0x10(%ebp)
  801a3b:	ff 75 0c             	pushl  0xc(%ebp)
  801a3e:	ff 75 08             	pushl  0x8(%ebp)
  801a41:	6a 11                	push   $0x11
  801a43:	e8 7a fe ff ff       	call   8018c2 <syscall>
  801a48:	83 c4 18             	add    $0x18,%esp
	return ;
  801a4b:	90                   	nop
}
  801a4c:	c9                   	leave  
  801a4d:	c3                   	ret    

00801a4e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a4e:	55                   	push   %ebp
  801a4f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 0c                	push   $0xc
  801a5d:	e8 60 fe ff ff       	call   8018c2 <syscall>
  801a62:	83 c4 18             	add    $0x18,%esp
}
  801a65:	c9                   	leave  
  801a66:	c3                   	ret    

00801a67 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a67:	55                   	push   %ebp
  801a68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	ff 75 08             	pushl  0x8(%ebp)
  801a75:	6a 0d                	push   $0xd
  801a77:	e8 46 fe ff ff       	call   8018c2 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 0e                	push   $0xe
  801a90:	e8 2d fe ff ff       	call   8018c2 <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	90                   	nop
  801a99:	c9                   	leave  
  801a9a:	c3                   	ret    

00801a9b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a9b:	55                   	push   %ebp
  801a9c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 00                	push   $0x0
  801aa8:	6a 13                	push   $0x13
  801aaa:	e8 13 fe ff ff       	call   8018c2 <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	90                   	nop
  801ab3:	c9                   	leave  
  801ab4:	c3                   	ret    

00801ab5 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ab5:	55                   	push   %ebp
  801ab6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 14                	push   $0x14
  801ac4:	e8 f9 fd ff ff       	call   8018c2 <syscall>
  801ac9:	83 c4 18             	add    $0x18,%esp
}
  801acc:	90                   	nop
  801acd:	c9                   	leave  
  801ace:	c3                   	ret    

00801acf <sys_cputc>:


void
sys_cputc(const char c)
{
  801acf:	55                   	push   %ebp
  801ad0:	89 e5                	mov    %esp,%ebp
  801ad2:	83 ec 04             	sub    $0x4,%esp
  801ad5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801adb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	50                   	push   %eax
  801ae8:	6a 15                	push   $0x15
  801aea:	e8 d3 fd ff ff       	call   8018c2 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	90                   	nop
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 16                	push   $0x16
  801b04:	e8 b9 fd ff ff       	call   8018c2 <syscall>
  801b09:	83 c4 18             	add    $0x18,%esp
}
  801b0c:	90                   	nop
  801b0d:	c9                   	leave  
  801b0e:	c3                   	ret    

00801b0f <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b0f:	55                   	push   %ebp
  801b10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b12:	8b 45 08             	mov    0x8(%ebp),%eax
  801b15:	6a 00                	push   $0x0
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	ff 75 0c             	pushl  0xc(%ebp)
  801b1e:	50                   	push   %eax
  801b1f:	6a 17                	push   $0x17
  801b21:	e8 9c fd ff ff       	call   8018c2 <syscall>
  801b26:	83 c4 18             	add    $0x18,%esp
}
  801b29:	c9                   	leave  
  801b2a:	c3                   	ret    

00801b2b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b2b:	55                   	push   %ebp
  801b2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b2e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b31:	8b 45 08             	mov    0x8(%ebp),%eax
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	52                   	push   %edx
  801b3b:	50                   	push   %eax
  801b3c:	6a 1a                	push   $0x1a
  801b3e:	e8 7f fd ff ff       	call   8018c2 <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
}
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b4b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 00                	push   $0x0
  801b57:	52                   	push   %edx
  801b58:	50                   	push   %eax
  801b59:	6a 18                	push   $0x18
  801b5b:	e8 62 fd ff ff       	call   8018c2 <syscall>
  801b60:	83 c4 18             	add    $0x18,%esp
}
  801b63:	90                   	nop
  801b64:	c9                   	leave  
  801b65:	c3                   	ret    

00801b66 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b66:	55                   	push   %ebp
  801b67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b69:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6f:	6a 00                	push   $0x0
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	52                   	push   %edx
  801b76:	50                   	push   %eax
  801b77:	6a 19                	push   $0x19
  801b79:	e8 44 fd ff ff       	call   8018c2 <syscall>
  801b7e:	83 c4 18             	add    $0x18,%esp
}
  801b81:	90                   	nop
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b84:	55                   	push   %ebp
  801b85:	89 e5                	mov    %esp,%ebp
  801b87:	83 ec 04             	sub    $0x4,%esp
  801b8a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b8d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b90:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b93:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	6a 00                	push   $0x0
  801b9c:	51                   	push   %ecx
  801b9d:	52                   	push   %edx
  801b9e:	ff 75 0c             	pushl  0xc(%ebp)
  801ba1:	50                   	push   %eax
  801ba2:	6a 1b                	push   $0x1b
  801ba4:	e8 19 fd ff ff       	call   8018c2 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	c9                   	leave  
  801bad:	c3                   	ret    

00801bae <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bae:	55                   	push   %ebp
  801baf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 00                	push   $0x0
  801bbb:	6a 00                	push   $0x0
  801bbd:	52                   	push   %edx
  801bbe:	50                   	push   %eax
  801bbf:	6a 1c                	push   $0x1c
  801bc1:	e8 fc fc ff ff       	call   8018c2 <syscall>
  801bc6:	83 c4 18             	add    $0x18,%esp
}
  801bc9:	c9                   	leave  
  801bca:	c3                   	ret    

00801bcb <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bcb:	55                   	push   %ebp
  801bcc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	51                   	push   %ecx
  801bdc:	52                   	push   %edx
  801bdd:	50                   	push   %eax
  801bde:	6a 1d                	push   $0x1d
  801be0:	e8 dd fc ff ff       	call   8018c2 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
}
  801be8:	c9                   	leave  
  801be9:	c3                   	ret    

00801bea <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bea:	55                   	push   %ebp
  801beb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bed:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bf0:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	52                   	push   %edx
  801bfa:	50                   	push   %eax
  801bfb:	6a 1e                	push   $0x1e
  801bfd:	e8 c0 fc ff ff       	call   8018c2 <syscall>
  801c02:	83 c4 18             	add    $0x18,%esp
}
  801c05:	c9                   	leave  
  801c06:	c3                   	ret    

00801c07 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c07:	55                   	push   %ebp
  801c08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c0a:	6a 00                	push   $0x0
  801c0c:	6a 00                	push   $0x0
  801c0e:	6a 00                	push   $0x0
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 1f                	push   $0x1f
  801c16:	e8 a7 fc ff ff       	call   8018c2 <syscall>
  801c1b:	83 c4 18             	add    $0x18,%esp
}
  801c1e:	c9                   	leave  
  801c1f:	c3                   	ret    

00801c20 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c20:	55                   	push   %ebp
  801c21:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c23:	8b 45 08             	mov    0x8(%ebp),%eax
  801c26:	6a 00                	push   $0x0
  801c28:	ff 75 14             	pushl  0x14(%ebp)
  801c2b:	ff 75 10             	pushl  0x10(%ebp)
  801c2e:	ff 75 0c             	pushl  0xc(%ebp)
  801c31:	50                   	push   %eax
  801c32:	6a 20                	push   $0x20
  801c34:	e8 89 fc ff ff       	call   8018c2 <syscall>
  801c39:	83 c4 18             	add    $0x18,%esp
}
  801c3c:	c9                   	leave  
  801c3d:	c3                   	ret    

00801c3e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c3e:	55                   	push   %ebp
  801c3f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c41:	8b 45 08             	mov    0x8(%ebp),%eax
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	50                   	push   %eax
  801c4d:	6a 21                	push   $0x21
  801c4f:	e8 6e fc ff ff       	call   8018c2 <syscall>
  801c54:	83 c4 18             	add    $0x18,%esp
}
  801c57:	90                   	nop
  801c58:	c9                   	leave  
  801c59:	c3                   	ret    

00801c5a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c5a:	55                   	push   %ebp
  801c5b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	50                   	push   %eax
  801c69:	6a 22                	push   $0x22
  801c6b:	e8 52 fc ff ff       	call   8018c2 <syscall>
  801c70:	83 c4 18             	add    $0x18,%esp
}
  801c73:	c9                   	leave  
  801c74:	c3                   	ret    

00801c75 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c75:	55                   	push   %ebp
  801c76:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 00                	push   $0x0
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 02                	push   $0x2
  801c84:	e8 39 fc ff ff       	call   8018c2 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c91:	6a 00                	push   $0x0
  801c93:	6a 00                	push   $0x0
  801c95:	6a 00                	push   $0x0
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 03                	push   $0x3
  801c9d:	e8 20 fc ff ff       	call   8018c2 <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 00                	push   $0x0
  801cb0:	6a 00                	push   $0x0
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 04                	push   $0x4
  801cb6:	e8 07 fc ff ff       	call   8018c2 <syscall>
  801cbb:	83 c4 18             	add    $0x18,%esp
}
  801cbe:	c9                   	leave  
  801cbf:	c3                   	ret    

00801cc0 <sys_exit_env>:


void sys_exit_env(void)
{
  801cc0:	55                   	push   %ebp
  801cc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 23                	push   $0x23
  801ccf:	e8 ee fb ff ff       	call   8018c2 <syscall>
  801cd4:	83 c4 18             	add    $0x18,%esp
}
  801cd7:	90                   	nop
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
  801cdd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ce0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ce3:	8d 50 04             	lea    0x4(%eax),%edx
  801ce6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 00                	push   $0x0
  801ced:	6a 00                	push   $0x0
  801cef:	52                   	push   %edx
  801cf0:	50                   	push   %eax
  801cf1:	6a 24                	push   $0x24
  801cf3:	e8 ca fb ff ff       	call   8018c2 <syscall>
  801cf8:	83 c4 18             	add    $0x18,%esp
	return result;
  801cfb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d04:	89 01                	mov    %eax,(%ecx)
  801d06:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d09:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0c:	c9                   	leave  
  801d0d:	c2 04 00             	ret    $0x4

00801d10 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	ff 75 10             	pushl  0x10(%ebp)
  801d1a:	ff 75 0c             	pushl  0xc(%ebp)
  801d1d:	ff 75 08             	pushl  0x8(%ebp)
  801d20:	6a 12                	push   $0x12
  801d22:	e8 9b fb ff ff       	call   8018c2 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
	return ;
  801d2a:	90                   	nop
}
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_rcr2>:
uint32 sys_rcr2()
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 00                	push   $0x0
  801d38:	6a 00                	push   $0x0
  801d3a:	6a 25                	push   $0x25
  801d3c:	e8 81 fb ff ff       	call   8018c2 <syscall>
  801d41:	83 c4 18             	add    $0x18,%esp
}
  801d44:	c9                   	leave  
  801d45:	c3                   	ret    

00801d46 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d46:	55                   	push   %ebp
  801d47:	89 e5                	mov    %esp,%ebp
  801d49:	83 ec 04             	sub    $0x4,%esp
  801d4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d4f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d52:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	50                   	push   %eax
  801d5f:	6a 26                	push   $0x26
  801d61:	e8 5c fb ff ff       	call   8018c2 <syscall>
  801d66:	83 c4 18             	add    $0x18,%esp
	return ;
  801d69:	90                   	nop
}
  801d6a:	c9                   	leave  
  801d6b:	c3                   	ret    

00801d6c <rsttst>:
void rsttst()
{
  801d6c:	55                   	push   %ebp
  801d6d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 28                	push   $0x28
  801d7b:	e8 42 fb ff ff       	call   8018c2 <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
	return ;
  801d83:	90                   	nop
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
  801d89:	83 ec 04             	sub    $0x4,%esp
  801d8c:	8b 45 14             	mov    0x14(%ebp),%eax
  801d8f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d92:	8b 55 18             	mov    0x18(%ebp),%edx
  801d95:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d99:	52                   	push   %edx
  801d9a:	50                   	push   %eax
  801d9b:	ff 75 10             	pushl  0x10(%ebp)
  801d9e:	ff 75 0c             	pushl  0xc(%ebp)
  801da1:	ff 75 08             	pushl  0x8(%ebp)
  801da4:	6a 27                	push   $0x27
  801da6:	e8 17 fb ff ff       	call   8018c2 <syscall>
  801dab:	83 c4 18             	add    $0x18,%esp
	return ;
  801dae:	90                   	nop
}
  801daf:	c9                   	leave  
  801db0:	c3                   	ret    

00801db1 <chktst>:
void chktst(uint32 n)
{
  801db1:	55                   	push   %ebp
  801db2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801db4:	6a 00                	push   $0x0
  801db6:	6a 00                	push   $0x0
  801db8:	6a 00                	push   $0x0
  801dba:	6a 00                	push   $0x0
  801dbc:	ff 75 08             	pushl  0x8(%ebp)
  801dbf:	6a 29                	push   $0x29
  801dc1:	e8 fc fa ff ff       	call   8018c2 <syscall>
  801dc6:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc9:	90                   	nop
}
  801dca:	c9                   	leave  
  801dcb:	c3                   	ret    

00801dcc <inctst>:

void inctst()
{
  801dcc:	55                   	push   %ebp
  801dcd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dcf:	6a 00                	push   $0x0
  801dd1:	6a 00                	push   $0x0
  801dd3:	6a 00                	push   $0x0
  801dd5:	6a 00                	push   $0x0
  801dd7:	6a 00                	push   $0x0
  801dd9:	6a 2a                	push   $0x2a
  801ddb:	e8 e2 fa ff ff       	call   8018c2 <syscall>
  801de0:	83 c4 18             	add    $0x18,%esp
	return ;
  801de3:	90                   	nop
}
  801de4:	c9                   	leave  
  801de5:	c3                   	ret    

00801de6 <gettst>:
uint32 gettst()
{
  801de6:	55                   	push   %ebp
  801de7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 00                	push   $0x0
  801df3:	6a 2b                	push   $0x2b
  801df5:	e8 c8 fa ff ff       	call   8018c2 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dff:	55                   	push   %ebp
  801e00:	89 e5                	mov    %esp,%ebp
  801e02:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 2c                	push   $0x2c
  801e11:	e8 ac fa ff ff       	call   8018c2 <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
  801e19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e1c:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e20:	75 07                	jne    801e29 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e22:	b8 01 00 00 00       	mov    $0x1,%eax
  801e27:	eb 05                	jmp    801e2e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e30:	55                   	push   %ebp
  801e31:	89 e5                	mov    %esp,%ebp
  801e33:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 2c                	push   $0x2c
  801e42:	e8 7b fa ff ff       	call   8018c2 <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
  801e4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e4d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e51:	75 07                	jne    801e5a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e53:	b8 01 00 00 00       	mov    $0x1,%eax
  801e58:	eb 05                	jmp    801e5f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
  801e64:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 2c                	push   $0x2c
  801e73:	e8 4a fa ff ff       	call   8018c2 <syscall>
  801e78:	83 c4 18             	add    $0x18,%esp
  801e7b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e7e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e82:	75 07                	jne    801e8b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e84:	b8 01 00 00 00       	mov    $0x1,%eax
  801e89:	eb 05                	jmp    801e90 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e8b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 00                	push   $0x0
  801ea2:	6a 2c                	push   $0x2c
  801ea4:	e8 19 fa ff ff       	call   8018c2 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
  801eac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801eaf:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801eb3:	75 07                	jne    801ebc <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eb5:	b8 01 00 00 00       	mov    $0x1,%eax
  801eba:	eb 05                	jmp    801ec1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ebc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec1:	c9                   	leave  
  801ec2:	c3                   	ret    

00801ec3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ec3:	55                   	push   %ebp
  801ec4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	ff 75 08             	pushl  0x8(%ebp)
  801ed1:	6a 2d                	push   $0x2d
  801ed3:	e8 ea f9 ff ff       	call   8018c2 <syscall>
  801ed8:	83 c4 18             	add    $0x18,%esp
	return ;
  801edb:	90                   	nop
}
  801edc:	c9                   	leave  
  801edd:	c3                   	ret    

00801ede <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ede:	55                   	push   %ebp
  801edf:	89 e5                	mov    %esp,%ebp
  801ee1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ee2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ee5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801eee:	6a 00                	push   $0x0
  801ef0:	53                   	push   %ebx
  801ef1:	51                   	push   %ecx
  801ef2:	52                   	push   %edx
  801ef3:	50                   	push   %eax
  801ef4:	6a 2e                	push   $0x2e
  801ef6:	e8 c7 f9 ff ff       	call   8018c2 <syscall>
  801efb:	83 c4 18             	add    $0x18,%esp
}
  801efe:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f06:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f09:	8b 45 08             	mov    0x8(%ebp),%eax
  801f0c:	6a 00                	push   $0x0
  801f0e:	6a 00                	push   $0x0
  801f10:	6a 00                	push   $0x0
  801f12:	52                   	push   %edx
  801f13:	50                   	push   %eax
  801f14:	6a 2f                	push   $0x2f
  801f16:	e8 a7 f9 ff ff       	call   8018c2 <syscall>
  801f1b:	83 c4 18             	add    $0x18,%esp
}
  801f1e:	c9                   	leave  
  801f1f:	c3                   	ret    

00801f20 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f20:	55                   	push   %ebp
  801f21:	89 e5                	mov    %esp,%ebp
  801f23:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f26:	83 ec 0c             	sub    $0xc,%esp
  801f29:	68 e0 3b 80 00       	push   $0x803be0
  801f2e:	e8 3e e6 ff ff       	call   800571 <cprintf>
  801f33:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f36:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f3d:	83 ec 0c             	sub    $0xc,%esp
  801f40:	68 0c 3c 80 00       	push   $0x803c0c
  801f45:	e8 27 e6 ff ff       	call   800571 <cprintf>
  801f4a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f4d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f51:	a1 38 41 80 00       	mov    0x804138,%eax
  801f56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f59:	eb 56                	jmp    801fb1 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f5f:	74 1c                	je     801f7d <print_mem_block_lists+0x5d>
  801f61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f64:	8b 50 08             	mov    0x8(%eax),%edx
  801f67:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f6a:	8b 48 08             	mov    0x8(%eax),%ecx
  801f6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f70:	8b 40 0c             	mov    0xc(%eax),%eax
  801f73:	01 c8                	add    %ecx,%eax
  801f75:	39 c2                	cmp    %eax,%edx
  801f77:	73 04                	jae    801f7d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f79:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f80:	8b 50 08             	mov    0x8(%eax),%edx
  801f83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f86:	8b 40 0c             	mov    0xc(%eax),%eax
  801f89:	01 c2                	add    %eax,%edx
  801f8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8e:	8b 40 08             	mov    0x8(%eax),%eax
  801f91:	83 ec 04             	sub    $0x4,%esp
  801f94:	52                   	push   %edx
  801f95:	50                   	push   %eax
  801f96:	68 21 3c 80 00       	push   $0x803c21
  801f9b:	e8 d1 e5 ff ff       	call   800571 <cprintf>
  801fa0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fa9:	a1 40 41 80 00       	mov    0x804140,%eax
  801fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fb1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fb5:	74 07                	je     801fbe <print_mem_block_lists+0x9e>
  801fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fba:	8b 00                	mov    (%eax),%eax
  801fbc:	eb 05                	jmp    801fc3 <print_mem_block_lists+0xa3>
  801fbe:	b8 00 00 00 00       	mov    $0x0,%eax
  801fc3:	a3 40 41 80 00       	mov    %eax,0x804140
  801fc8:	a1 40 41 80 00       	mov    0x804140,%eax
  801fcd:	85 c0                	test   %eax,%eax
  801fcf:	75 8a                	jne    801f5b <print_mem_block_lists+0x3b>
  801fd1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fd5:	75 84                	jne    801f5b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fd7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fdb:	75 10                	jne    801fed <print_mem_block_lists+0xcd>
  801fdd:	83 ec 0c             	sub    $0xc,%esp
  801fe0:	68 30 3c 80 00       	push   $0x803c30
  801fe5:	e8 87 e5 ff ff       	call   800571 <cprintf>
  801fea:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801ff4:	83 ec 0c             	sub    $0xc,%esp
  801ff7:	68 54 3c 80 00       	push   $0x803c54
  801ffc:	e8 70 e5 ff ff       	call   800571 <cprintf>
  802001:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802004:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802008:	a1 40 40 80 00       	mov    0x804040,%eax
  80200d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802010:	eb 56                	jmp    802068 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802012:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802016:	74 1c                	je     802034 <print_mem_block_lists+0x114>
  802018:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201b:	8b 50 08             	mov    0x8(%eax),%edx
  80201e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802021:	8b 48 08             	mov    0x8(%eax),%ecx
  802024:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802027:	8b 40 0c             	mov    0xc(%eax),%eax
  80202a:	01 c8                	add    %ecx,%eax
  80202c:	39 c2                	cmp    %eax,%edx
  80202e:	73 04                	jae    802034 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802030:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802037:	8b 50 08             	mov    0x8(%eax),%edx
  80203a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203d:	8b 40 0c             	mov    0xc(%eax),%eax
  802040:	01 c2                	add    %eax,%edx
  802042:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802045:	8b 40 08             	mov    0x8(%eax),%eax
  802048:	83 ec 04             	sub    $0x4,%esp
  80204b:	52                   	push   %edx
  80204c:	50                   	push   %eax
  80204d:	68 21 3c 80 00       	push   $0x803c21
  802052:	e8 1a e5 ff ff       	call   800571 <cprintf>
  802057:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80205a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80205d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802060:	a1 48 40 80 00       	mov    0x804048,%eax
  802065:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802068:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80206c:	74 07                	je     802075 <print_mem_block_lists+0x155>
  80206e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802071:	8b 00                	mov    (%eax),%eax
  802073:	eb 05                	jmp    80207a <print_mem_block_lists+0x15a>
  802075:	b8 00 00 00 00       	mov    $0x0,%eax
  80207a:	a3 48 40 80 00       	mov    %eax,0x804048
  80207f:	a1 48 40 80 00       	mov    0x804048,%eax
  802084:	85 c0                	test   %eax,%eax
  802086:	75 8a                	jne    802012 <print_mem_block_lists+0xf2>
  802088:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80208c:	75 84                	jne    802012 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80208e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802092:	75 10                	jne    8020a4 <print_mem_block_lists+0x184>
  802094:	83 ec 0c             	sub    $0xc,%esp
  802097:	68 6c 3c 80 00       	push   $0x803c6c
  80209c:	e8 d0 e4 ff ff       	call   800571 <cprintf>
  8020a1:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020a4:	83 ec 0c             	sub    $0xc,%esp
  8020a7:	68 e0 3b 80 00       	push   $0x803be0
  8020ac:	e8 c0 e4 ff ff       	call   800571 <cprintf>
  8020b1:	83 c4 10             	add    $0x10,%esp

}
  8020b4:	90                   	nop
  8020b5:	c9                   	leave  
  8020b6:	c3                   	ret    

008020b7 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020b7:	55                   	push   %ebp
  8020b8:	89 e5                	mov    %esp,%ebp
  8020ba:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8020bd:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020c4:	00 00 00 
  8020c7:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020ce:	00 00 00 
  8020d1:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020d8:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8020db:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020e2:	e9 9e 00 00 00       	jmp    802185 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8020e7:	a1 50 40 80 00       	mov    0x804050,%eax
  8020ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ef:	c1 e2 04             	shl    $0x4,%edx
  8020f2:	01 d0                	add    %edx,%eax
  8020f4:	85 c0                	test   %eax,%eax
  8020f6:	75 14                	jne    80210c <initialize_MemBlocksList+0x55>
  8020f8:	83 ec 04             	sub    $0x4,%esp
  8020fb:	68 94 3c 80 00       	push   $0x803c94
  802100:	6a 3d                	push   $0x3d
  802102:	68 b7 3c 80 00       	push   $0x803cb7
  802107:	e8 b1 e1 ff ff       	call   8002bd <_panic>
  80210c:	a1 50 40 80 00       	mov    0x804050,%eax
  802111:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802114:	c1 e2 04             	shl    $0x4,%edx
  802117:	01 d0                	add    %edx,%eax
  802119:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80211f:	89 10                	mov    %edx,(%eax)
  802121:	8b 00                	mov    (%eax),%eax
  802123:	85 c0                	test   %eax,%eax
  802125:	74 18                	je     80213f <initialize_MemBlocksList+0x88>
  802127:	a1 48 41 80 00       	mov    0x804148,%eax
  80212c:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802132:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802135:	c1 e1 04             	shl    $0x4,%ecx
  802138:	01 ca                	add    %ecx,%edx
  80213a:	89 50 04             	mov    %edx,0x4(%eax)
  80213d:	eb 12                	jmp    802151 <initialize_MemBlocksList+0x9a>
  80213f:	a1 50 40 80 00       	mov    0x804050,%eax
  802144:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802147:	c1 e2 04             	shl    $0x4,%edx
  80214a:	01 d0                	add    %edx,%eax
  80214c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802151:	a1 50 40 80 00       	mov    0x804050,%eax
  802156:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802159:	c1 e2 04             	shl    $0x4,%edx
  80215c:	01 d0                	add    %edx,%eax
  80215e:	a3 48 41 80 00       	mov    %eax,0x804148
  802163:	a1 50 40 80 00       	mov    0x804050,%eax
  802168:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80216b:	c1 e2 04             	shl    $0x4,%edx
  80216e:	01 d0                	add    %edx,%eax
  802170:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802177:	a1 54 41 80 00       	mov    0x804154,%eax
  80217c:	40                   	inc    %eax
  80217d:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802182:	ff 45 f4             	incl   -0xc(%ebp)
  802185:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802188:	3b 45 08             	cmp    0x8(%ebp),%eax
  80218b:	0f 82 56 ff ff ff    	jb     8020e7 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802191:	90                   	nop
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
  802197:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  80219a:	8b 45 08             	mov    0x8(%ebp),%eax
  80219d:	8b 00                	mov    (%eax),%eax
  80219f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8021a2:	eb 18                	jmp    8021bc <find_block+0x28>

		if(tmp->sva == va){
  8021a4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a7:	8b 40 08             	mov    0x8(%eax),%eax
  8021aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021ad:	75 05                	jne    8021b4 <find_block+0x20>
			return tmp ;
  8021af:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b2:	eb 11                	jmp    8021c5 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8021b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b7:	8b 00                	mov    (%eax),%eax
  8021b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8021bc:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021c0:	75 e2                	jne    8021a4 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8021c2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021c5:	c9                   	leave  
  8021c6:	c3                   	ret    

008021c7 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021c7:	55                   	push   %ebp
  8021c8:	89 e5                	mov    %esp,%ebp
  8021ca:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8021cd:	a1 40 40 80 00       	mov    0x804040,%eax
  8021d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8021d5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021da:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8021dd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021e1:	75 65                	jne    802248 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8021e3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e7:	75 14                	jne    8021fd <insert_sorted_allocList+0x36>
  8021e9:	83 ec 04             	sub    $0x4,%esp
  8021ec:	68 94 3c 80 00       	push   $0x803c94
  8021f1:	6a 62                	push   $0x62
  8021f3:	68 b7 3c 80 00       	push   $0x803cb7
  8021f8:	e8 c0 e0 ff ff       	call   8002bd <_panic>
  8021fd:	8b 15 40 40 80 00    	mov    0x804040,%edx
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	89 10                	mov    %edx,(%eax)
  802208:	8b 45 08             	mov    0x8(%ebp),%eax
  80220b:	8b 00                	mov    (%eax),%eax
  80220d:	85 c0                	test   %eax,%eax
  80220f:	74 0d                	je     80221e <insert_sorted_allocList+0x57>
  802211:	a1 40 40 80 00       	mov    0x804040,%eax
  802216:	8b 55 08             	mov    0x8(%ebp),%edx
  802219:	89 50 04             	mov    %edx,0x4(%eax)
  80221c:	eb 08                	jmp    802226 <insert_sorted_allocList+0x5f>
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	a3 44 40 80 00       	mov    %eax,0x804044
  802226:	8b 45 08             	mov    0x8(%ebp),%eax
  802229:	a3 40 40 80 00       	mov    %eax,0x804040
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802238:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80223d:	40                   	inc    %eax
  80223e:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802243:	e9 14 01 00 00       	jmp    80235c <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	8b 50 08             	mov    0x8(%eax),%edx
  80224e:	a1 44 40 80 00       	mov    0x804044,%eax
  802253:	8b 40 08             	mov    0x8(%eax),%eax
  802256:	39 c2                	cmp    %eax,%edx
  802258:	76 65                	jbe    8022bf <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80225a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80225e:	75 14                	jne    802274 <insert_sorted_allocList+0xad>
  802260:	83 ec 04             	sub    $0x4,%esp
  802263:	68 d0 3c 80 00       	push   $0x803cd0
  802268:	6a 64                	push   $0x64
  80226a:	68 b7 3c 80 00       	push   $0x803cb7
  80226f:	e8 49 e0 ff ff       	call   8002bd <_panic>
  802274:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	89 50 04             	mov    %edx,0x4(%eax)
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	8b 40 04             	mov    0x4(%eax),%eax
  802286:	85 c0                	test   %eax,%eax
  802288:	74 0c                	je     802296 <insert_sorted_allocList+0xcf>
  80228a:	a1 44 40 80 00       	mov    0x804044,%eax
  80228f:	8b 55 08             	mov    0x8(%ebp),%edx
  802292:	89 10                	mov    %edx,(%eax)
  802294:	eb 08                	jmp    80229e <insert_sorted_allocList+0xd7>
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	a3 40 40 80 00       	mov    %eax,0x804040
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	a3 44 40 80 00       	mov    %eax,0x804044
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022af:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022b4:	40                   	inc    %eax
  8022b5:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8022ba:	e9 9d 00 00 00       	jmp    80235c <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8022bf:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8022c6:	e9 85 00 00 00       	jmp    802350 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	8b 50 08             	mov    0x8(%eax),%edx
  8022d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d4:	8b 40 08             	mov    0x8(%eax),%eax
  8022d7:	39 c2                	cmp    %eax,%edx
  8022d9:	73 6a                	jae    802345 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8022db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022df:	74 06                	je     8022e7 <insert_sorted_allocList+0x120>
  8022e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022e5:	75 14                	jne    8022fb <insert_sorted_allocList+0x134>
  8022e7:	83 ec 04             	sub    $0x4,%esp
  8022ea:	68 f4 3c 80 00       	push   $0x803cf4
  8022ef:	6a 6b                	push   $0x6b
  8022f1:	68 b7 3c 80 00       	push   $0x803cb7
  8022f6:	e8 c2 df ff ff       	call   8002bd <_panic>
  8022fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fe:	8b 50 04             	mov    0x4(%eax),%edx
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	89 50 04             	mov    %edx,0x4(%eax)
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80230d:	89 10                	mov    %edx,(%eax)
  80230f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802312:	8b 40 04             	mov    0x4(%eax),%eax
  802315:	85 c0                	test   %eax,%eax
  802317:	74 0d                	je     802326 <insert_sorted_allocList+0x15f>
  802319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231c:	8b 40 04             	mov    0x4(%eax),%eax
  80231f:	8b 55 08             	mov    0x8(%ebp),%edx
  802322:	89 10                	mov    %edx,(%eax)
  802324:	eb 08                	jmp    80232e <insert_sorted_allocList+0x167>
  802326:	8b 45 08             	mov    0x8(%ebp),%eax
  802329:	a3 40 40 80 00       	mov    %eax,0x804040
  80232e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802331:	8b 55 08             	mov    0x8(%ebp),%edx
  802334:	89 50 04             	mov    %edx,0x4(%eax)
  802337:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80233c:	40                   	inc    %eax
  80233d:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  802342:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802343:	eb 17                	jmp    80235c <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 00                	mov    (%eax),%eax
  80234a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80234d:	ff 45 f0             	incl   -0x10(%ebp)
  802350:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802353:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802356:	0f 8c 6f ff ff ff    	jl     8022cb <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80235c:	90                   	nop
  80235d:	c9                   	leave  
  80235e:	c3                   	ret    

0080235f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80235f:	55                   	push   %ebp
  802360:	89 e5                	mov    %esp,%ebp
  802362:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802365:	a1 38 41 80 00       	mov    0x804138,%eax
  80236a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80236d:	e9 7c 01 00 00       	jmp    8024ee <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802372:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802375:	8b 40 0c             	mov    0xc(%eax),%eax
  802378:	3b 45 08             	cmp    0x8(%ebp),%eax
  80237b:	0f 86 cf 00 00 00    	jbe    802450 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802381:	a1 48 41 80 00       	mov    0x804148,%eax
  802386:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802389:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80238c:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  80238f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802392:	8b 55 08             	mov    0x8(%ebp),%edx
  802395:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802398:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239b:	8b 50 08             	mov    0x8(%eax),%edx
  80239e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a1:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023aa:	2b 45 08             	sub    0x8(%ebp),%eax
  8023ad:	89 c2                	mov    %eax,%edx
  8023af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b2:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	8b 50 08             	mov    0x8(%eax),%edx
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	01 c2                	add    %eax,%edx
  8023c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c3:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8023c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023ca:	75 17                	jne    8023e3 <alloc_block_FF+0x84>
  8023cc:	83 ec 04             	sub    $0x4,%esp
  8023cf:	68 29 3d 80 00       	push   $0x803d29
  8023d4:	68 83 00 00 00       	push   $0x83
  8023d9:	68 b7 3c 80 00       	push   $0x803cb7
  8023de:	e8 da de ff ff       	call   8002bd <_panic>
  8023e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e6:	8b 00                	mov    (%eax),%eax
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	74 10                	je     8023fc <alloc_block_FF+0x9d>
  8023ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ef:	8b 00                	mov    (%eax),%eax
  8023f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023f4:	8b 52 04             	mov    0x4(%edx),%edx
  8023f7:	89 50 04             	mov    %edx,0x4(%eax)
  8023fa:	eb 0b                	jmp    802407 <alloc_block_FF+0xa8>
  8023fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ff:	8b 40 04             	mov    0x4(%eax),%eax
  802402:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802407:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240a:	8b 40 04             	mov    0x4(%eax),%eax
  80240d:	85 c0                	test   %eax,%eax
  80240f:	74 0f                	je     802420 <alloc_block_FF+0xc1>
  802411:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802414:	8b 40 04             	mov    0x4(%eax),%eax
  802417:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80241a:	8b 12                	mov    (%edx),%edx
  80241c:	89 10                	mov    %edx,(%eax)
  80241e:	eb 0a                	jmp    80242a <alloc_block_FF+0xcb>
  802420:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802423:	8b 00                	mov    (%eax),%eax
  802425:	a3 48 41 80 00       	mov    %eax,0x804148
  80242a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802436:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80243d:	a1 54 41 80 00       	mov    0x804154,%eax
  802442:	48                   	dec    %eax
  802443:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  802448:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244b:	e9 ad 00 00 00       	jmp    8024fd <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802450:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802453:	8b 40 0c             	mov    0xc(%eax),%eax
  802456:	3b 45 08             	cmp    0x8(%ebp),%eax
  802459:	0f 85 87 00 00 00    	jne    8024e6 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  80245f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802463:	75 17                	jne    80247c <alloc_block_FF+0x11d>
  802465:	83 ec 04             	sub    $0x4,%esp
  802468:	68 29 3d 80 00       	push   $0x803d29
  80246d:	68 87 00 00 00       	push   $0x87
  802472:	68 b7 3c 80 00       	push   $0x803cb7
  802477:	e8 41 de ff ff       	call   8002bd <_panic>
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	8b 00                	mov    (%eax),%eax
  802481:	85 c0                	test   %eax,%eax
  802483:	74 10                	je     802495 <alloc_block_FF+0x136>
  802485:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802488:	8b 00                	mov    (%eax),%eax
  80248a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80248d:	8b 52 04             	mov    0x4(%edx),%edx
  802490:	89 50 04             	mov    %edx,0x4(%eax)
  802493:	eb 0b                	jmp    8024a0 <alloc_block_FF+0x141>
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 40 04             	mov    0x4(%eax),%eax
  80249b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 40 04             	mov    0x4(%eax),%eax
  8024a6:	85 c0                	test   %eax,%eax
  8024a8:	74 0f                	je     8024b9 <alloc_block_FF+0x15a>
  8024aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ad:	8b 40 04             	mov    0x4(%eax),%eax
  8024b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b3:	8b 12                	mov    (%edx),%edx
  8024b5:	89 10                	mov    %edx,(%eax)
  8024b7:	eb 0a                	jmp    8024c3 <alloc_block_FF+0x164>
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	a3 38 41 80 00       	mov    %eax,0x804138
  8024c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024d6:	a1 44 41 80 00       	mov    0x804144,%eax
  8024db:	48                   	dec    %eax
  8024dc:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8024e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e4:	eb 17                	jmp    8024fd <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8024e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e9:	8b 00                	mov    (%eax),%eax
  8024eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8024ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024f2:	0f 85 7a fe ff ff    	jne    802372 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8024f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024fd:	c9                   	leave  
  8024fe:	c3                   	ret    

008024ff <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024ff:	55                   	push   %ebp
  802500:	89 e5                	mov    %esp,%ebp
  802502:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802505:	a1 38 41 80 00       	mov    0x804138,%eax
  80250a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  80250d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802514:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80251b:	a1 38 41 80 00       	mov    0x804138,%eax
  802520:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802523:	e9 d0 00 00 00       	jmp    8025f8 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	8b 40 0c             	mov    0xc(%eax),%eax
  80252e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802531:	0f 82 b8 00 00 00    	jb     8025ef <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802537:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253a:	8b 40 0c             	mov    0xc(%eax),%eax
  80253d:	2b 45 08             	sub    0x8(%ebp),%eax
  802540:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802543:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802546:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802549:	0f 83 a1 00 00 00    	jae    8025f0 <alloc_block_BF+0xf1>
				differsize = differance ;
  80254f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802552:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80255b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80255f:	0f 85 8b 00 00 00    	jne    8025f0 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802565:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802569:	75 17                	jne    802582 <alloc_block_BF+0x83>
  80256b:	83 ec 04             	sub    $0x4,%esp
  80256e:	68 29 3d 80 00       	push   $0x803d29
  802573:	68 a0 00 00 00       	push   $0xa0
  802578:	68 b7 3c 80 00       	push   $0x803cb7
  80257d:	e8 3b dd ff ff       	call   8002bd <_panic>
  802582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802585:	8b 00                	mov    (%eax),%eax
  802587:	85 c0                	test   %eax,%eax
  802589:	74 10                	je     80259b <alloc_block_BF+0x9c>
  80258b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258e:	8b 00                	mov    (%eax),%eax
  802590:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802593:	8b 52 04             	mov    0x4(%edx),%edx
  802596:	89 50 04             	mov    %edx,0x4(%eax)
  802599:	eb 0b                	jmp    8025a6 <alloc_block_BF+0xa7>
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	8b 40 04             	mov    0x4(%eax),%eax
  8025a1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a9:	8b 40 04             	mov    0x4(%eax),%eax
  8025ac:	85 c0                	test   %eax,%eax
  8025ae:	74 0f                	je     8025bf <alloc_block_BF+0xc0>
  8025b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b3:	8b 40 04             	mov    0x4(%eax),%eax
  8025b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b9:	8b 12                	mov    (%edx),%edx
  8025bb:	89 10                	mov    %edx,(%eax)
  8025bd:	eb 0a                	jmp    8025c9 <alloc_block_BF+0xca>
  8025bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c2:	8b 00                	mov    (%eax),%eax
  8025c4:	a3 38 41 80 00       	mov    %eax,0x804138
  8025c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025cc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025dc:	a1 44 41 80 00       	mov    0x804144,%eax
  8025e1:	48                   	dec    %eax
  8025e2:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ea:	e9 0c 01 00 00       	jmp    8026fb <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8025ef:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8025f0:	a1 40 41 80 00       	mov    0x804140,%eax
  8025f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025fc:	74 07                	je     802605 <alloc_block_BF+0x106>
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	8b 00                	mov    (%eax),%eax
  802603:	eb 05                	jmp    80260a <alloc_block_BF+0x10b>
  802605:	b8 00 00 00 00       	mov    $0x0,%eax
  80260a:	a3 40 41 80 00       	mov    %eax,0x804140
  80260f:	a1 40 41 80 00       	mov    0x804140,%eax
  802614:	85 c0                	test   %eax,%eax
  802616:	0f 85 0c ff ff ff    	jne    802528 <alloc_block_BF+0x29>
  80261c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802620:	0f 85 02 ff ff ff    	jne    802528 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802626:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80262a:	0f 84 c6 00 00 00    	je     8026f6 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802630:	a1 48 41 80 00       	mov    0x804148,%eax
  802635:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802638:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80263b:	8b 55 08             	mov    0x8(%ebp),%edx
  80263e:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802644:	8b 50 08             	mov    0x8(%eax),%edx
  802647:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80264a:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  80264d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802650:	8b 40 0c             	mov    0xc(%eax),%eax
  802653:	2b 45 08             	sub    0x8(%ebp),%eax
  802656:	89 c2                	mov    %eax,%edx
  802658:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265b:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  80265e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802661:	8b 50 08             	mov    0x8(%eax),%edx
  802664:	8b 45 08             	mov    0x8(%ebp),%eax
  802667:	01 c2                	add    %eax,%edx
  802669:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80266c:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  80266f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802673:	75 17                	jne    80268c <alloc_block_BF+0x18d>
  802675:	83 ec 04             	sub    $0x4,%esp
  802678:	68 29 3d 80 00       	push   $0x803d29
  80267d:	68 af 00 00 00       	push   $0xaf
  802682:	68 b7 3c 80 00       	push   $0x803cb7
  802687:	e8 31 dc ff ff       	call   8002bd <_panic>
  80268c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80268f:	8b 00                	mov    (%eax),%eax
  802691:	85 c0                	test   %eax,%eax
  802693:	74 10                	je     8026a5 <alloc_block_BF+0x1a6>
  802695:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802698:	8b 00                	mov    (%eax),%eax
  80269a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80269d:	8b 52 04             	mov    0x4(%edx),%edx
  8026a0:	89 50 04             	mov    %edx,0x4(%eax)
  8026a3:	eb 0b                	jmp    8026b0 <alloc_block_BF+0x1b1>
  8026a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a8:	8b 40 04             	mov    0x4(%eax),%eax
  8026ab:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b3:	8b 40 04             	mov    0x4(%eax),%eax
  8026b6:	85 c0                	test   %eax,%eax
  8026b8:	74 0f                	je     8026c9 <alloc_block_BF+0x1ca>
  8026ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026bd:	8b 40 04             	mov    0x4(%eax),%eax
  8026c0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026c3:	8b 12                	mov    (%edx),%edx
  8026c5:	89 10                	mov    %edx,(%eax)
  8026c7:	eb 0a                	jmp    8026d3 <alloc_block_BF+0x1d4>
  8026c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026cc:	8b 00                	mov    (%eax),%eax
  8026ce:	a3 48 41 80 00       	mov    %eax,0x804148
  8026d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026e6:	a1 54 41 80 00       	mov    0x804154,%eax
  8026eb:	48                   	dec    %eax
  8026ec:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8026f1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f4:	eb 05                	jmp    8026fb <alloc_block_BF+0x1fc>
	}

	return NULL;
  8026f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026fb:	c9                   	leave  
  8026fc:	c3                   	ret    

008026fd <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8026fd:	55                   	push   %ebp
  8026fe:	89 e5                	mov    %esp,%ebp
  802700:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802703:	a1 38 41 80 00       	mov    0x804138,%eax
  802708:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  80270b:	e9 7c 01 00 00       	jmp    80288c <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802710:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802713:	8b 40 0c             	mov    0xc(%eax),%eax
  802716:	3b 45 08             	cmp    0x8(%ebp),%eax
  802719:	0f 86 cf 00 00 00    	jbe    8027ee <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80271f:	a1 48 41 80 00       	mov    0x804148,%eax
  802724:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  80272d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802730:	8b 55 08             	mov    0x8(%ebp),%edx
  802733:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802736:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802739:	8b 50 08             	mov    0x8(%eax),%edx
  80273c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273f:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802742:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802745:	8b 40 0c             	mov    0xc(%eax),%eax
  802748:	2b 45 08             	sub    0x8(%ebp),%eax
  80274b:	89 c2                	mov    %eax,%edx
  80274d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802750:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	8b 50 08             	mov    0x8(%eax),%edx
  802759:	8b 45 08             	mov    0x8(%ebp),%eax
  80275c:	01 c2                	add    %eax,%edx
  80275e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802761:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802764:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802768:	75 17                	jne    802781 <alloc_block_NF+0x84>
  80276a:	83 ec 04             	sub    $0x4,%esp
  80276d:	68 29 3d 80 00       	push   $0x803d29
  802772:	68 c4 00 00 00       	push   $0xc4
  802777:	68 b7 3c 80 00       	push   $0x803cb7
  80277c:	e8 3c db ff ff       	call   8002bd <_panic>
  802781:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802784:	8b 00                	mov    (%eax),%eax
  802786:	85 c0                	test   %eax,%eax
  802788:	74 10                	je     80279a <alloc_block_NF+0x9d>
  80278a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278d:	8b 00                	mov    (%eax),%eax
  80278f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802792:	8b 52 04             	mov    0x4(%edx),%edx
  802795:	89 50 04             	mov    %edx,0x4(%eax)
  802798:	eb 0b                	jmp    8027a5 <alloc_block_NF+0xa8>
  80279a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279d:	8b 40 04             	mov    0x4(%eax),%eax
  8027a0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a8:	8b 40 04             	mov    0x4(%eax),%eax
  8027ab:	85 c0                	test   %eax,%eax
  8027ad:	74 0f                	je     8027be <alloc_block_NF+0xc1>
  8027af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b2:	8b 40 04             	mov    0x4(%eax),%eax
  8027b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b8:	8b 12                	mov    (%edx),%edx
  8027ba:	89 10                	mov    %edx,(%eax)
  8027bc:	eb 0a                	jmp    8027c8 <alloc_block_NF+0xcb>
  8027be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c1:	8b 00                	mov    (%eax),%eax
  8027c3:	a3 48 41 80 00       	mov    %eax,0x804148
  8027c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027db:	a1 54 41 80 00       	mov    0x804154,%eax
  8027e0:	48                   	dec    %eax
  8027e1:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8027e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e9:	e9 ad 00 00 00       	jmp    80289b <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8027ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f7:	0f 85 87 00 00 00    	jne    802884 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8027fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802801:	75 17                	jne    80281a <alloc_block_NF+0x11d>
  802803:	83 ec 04             	sub    $0x4,%esp
  802806:	68 29 3d 80 00       	push   $0x803d29
  80280b:	68 c8 00 00 00       	push   $0xc8
  802810:	68 b7 3c 80 00       	push   $0x803cb7
  802815:	e8 a3 da ff ff       	call   8002bd <_panic>
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 00                	mov    (%eax),%eax
  80281f:	85 c0                	test   %eax,%eax
  802821:	74 10                	je     802833 <alloc_block_NF+0x136>
  802823:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80282b:	8b 52 04             	mov    0x4(%edx),%edx
  80282e:	89 50 04             	mov    %edx,0x4(%eax)
  802831:	eb 0b                	jmp    80283e <alloc_block_NF+0x141>
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 40 04             	mov    0x4(%eax),%eax
  802839:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	8b 40 04             	mov    0x4(%eax),%eax
  802844:	85 c0                	test   %eax,%eax
  802846:	74 0f                	je     802857 <alloc_block_NF+0x15a>
  802848:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284b:	8b 40 04             	mov    0x4(%eax),%eax
  80284e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802851:	8b 12                	mov    (%edx),%edx
  802853:	89 10                	mov    %edx,(%eax)
  802855:	eb 0a                	jmp    802861 <alloc_block_NF+0x164>
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 00                	mov    (%eax),%eax
  80285c:	a3 38 41 80 00       	mov    %eax,0x804138
  802861:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802864:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802874:	a1 44 41 80 00       	mov    0x804144,%eax
  802879:	48                   	dec    %eax
  80287a:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  80287f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802882:	eb 17                	jmp    80289b <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802884:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802887:	8b 00                	mov    (%eax),%eax
  802889:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  80288c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802890:	0f 85 7a fe ff ff    	jne    802710 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802896:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80289b:	c9                   	leave  
  80289c:	c3                   	ret    

0080289d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80289d:	55                   	push   %ebp
  80289e:	89 e5                	mov    %esp,%ebp
  8028a0:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  8028a3:	a1 38 41 80 00       	mov    0x804138,%eax
  8028a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8028ab:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028b0:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8028b3:	a1 44 41 80 00       	mov    0x804144,%eax
  8028b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8028bb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028bf:	75 68                	jne    802929 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8028c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028c5:	75 17                	jne    8028de <insert_sorted_with_merge_freeList+0x41>
  8028c7:	83 ec 04             	sub    $0x4,%esp
  8028ca:	68 94 3c 80 00       	push   $0x803c94
  8028cf:	68 da 00 00 00       	push   $0xda
  8028d4:	68 b7 3c 80 00       	push   $0x803cb7
  8028d9:	e8 df d9 ff ff       	call   8002bd <_panic>
  8028de:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e7:	89 10                	mov    %edx,(%eax)
  8028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ec:	8b 00                	mov    (%eax),%eax
  8028ee:	85 c0                	test   %eax,%eax
  8028f0:	74 0d                	je     8028ff <insert_sorted_with_merge_freeList+0x62>
  8028f2:	a1 38 41 80 00       	mov    0x804138,%eax
  8028f7:	8b 55 08             	mov    0x8(%ebp),%edx
  8028fa:	89 50 04             	mov    %edx,0x4(%eax)
  8028fd:	eb 08                	jmp    802907 <insert_sorted_with_merge_freeList+0x6a>
  8028ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802902:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	a3 38 41 80 00       	mov    %eax,0x804138
  80290f:	8b 45 08             	mov    0x8(%ebp),%eax
  802912:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802919:	a1 44 41 80 00       	mov    0x804144,%eax
  80291e:	40                   	inc    %eax
  80291f:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  802924:	e9 49 07 00 00       	jmp    803072 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802929:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292c:	8b 50 08             	mov    0x8(%eax),%edx
  80292f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802932:	8b 40 0c             	mov    0xc(%eax),%eax
  802935:	01 c2                	add    %eax,%edx
  802937:	8b 45 08             	mov    0x8(%ebp),%eax
  80293a:	8b 40 08             	mov    0x8(%eax),%eax
  80293d:	39 c2                	cmp    %eax,%edx
  80293f:	73 77                	jae    8029b8 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802941:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802944:	8b 00                	mov    (%eax),%eax
  802946:	85 c0                	test   %eax,%eax
  802948:	75 6e                	jne    8029b8 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  80294a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80294e:	74 68                	je     8029b8 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802950:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802954:	75 17                	jne    80296d <insert_sorted_with_merge_freeList+0xd0>
  802956:	83 ec 04             	sub    $0x4,%esp
  802959:	68 d0 3c 80 00       	push   $0x803cd0
  80295e:	68 e0 00 00 00       	push   $0xe0
  802963:	68 b7 3c 80 00       	push   $0x803cb7
  802968:	e8 50 d9 ff ff       	call   8002bd <_panic>
  80296d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802973:	8b 45 08             	mov    0x8(%ebp),%eax
  802976:	89 50 04             	mov    %edx,0x4(%eax)
  802979:	8b 45 08             	mov    0x8(%ebp),%eax
  80297c:	8b 40 04             	mov    0x4(%eax),%eax
  80297f:	85 c0                	test   %eax,%eax
  802981:	74 0c                	je     80298f <insert_sorted_with_merge_freeList+0xf2>
  802983:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802988:	8b 55 08             	mov    0x8(%ebp),%edx
  80298b:	89 10                	mov    %edx,(%eax)
  80298d:	eb 08                	jmp    802997 <insert_sorted_with_merge_freeList+0xfa>
  80298f:	8b 45 08             	mov    0x8(%ebp),%eax
  802992:	a3 38 41 80 00       	mov    %eax,0x804138
  802997:	8b 45 08             	mov    0x8(%ebp),%eax
  80299a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80299f:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a8:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ad:	40                   	inc    %eax
  8029ae:	a3 44 41 80 00       	mov    %eax,0x804144
  8029b3:	e9 ba 06 00 00       	jmp    803072 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8029b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bb:	8b 50 0c             	mov    0xc(%eax),%edx
  8029be:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c1:	8b 40 08             	mov    0x8(%eax),%eax
  8029c4:	01 c2                	add    %eax,%edx
  8029c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c9:	8b 40 08             	mov    0x8(%eax),%eax
  8029cc:	39 c2                	cmp    %eax,%edx
  8029ce:	73 78                	jae    802a48 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8029d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029d3:	8b 40 04             	mov    0x4(%eax),%eax
  8029d6:	85 c0                	test   %eax,%eax
  8029d8:	75 6e                	jne    802a48 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8029da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029de:	74 68                	je     802a48 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8029e0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029e4:	75 17                	jne    8029fd <insert_sorted_with_merge_freeList+0x160>
  8029e6:	83 ec 04             	sub    $0x4,%esp
  8029e9:	68 94 3c 80 00       	push   $0x803c94
  8029ee:	68 e6 00 00 00       	push   $0xe6
  8029f3:	68 b7 3c 80 00       	push   $0x803cb7
  8029f8:	e8 c0 d8 ff ff       	call   8002bd <_panic>
  8029fd:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a03:	8b 45 08             	mov    0x8(%ebp),%eax
  802a06:	89 10                	mov    %edx,(%eax)
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	8b 00                	mov    (%eax),%eax
  802a0d:	85 c0                	test   %eax,%eax
  802a0f:	74 0d                	je     802a1e <insert_sorted_with_merge_freeList+0x181>
  802a11:	a1 38 41 80 00       	mov    0x804138,%eax
  802a16:	8b 55 08             	mov    0x8(%ebp),%edx
  802a19:	89 50 04             	mov    %edx,0x4(%eax)
  802a1c:	eb 08                	jmp    802a26 <insert_sorted_with_merge_freeList+0x189>
  802a1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a21:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	a3 38 41 80 00       	mov    %eax,0x804138
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a38:	a1 44 41 80 00       	mov    0x804144,%eax
  802a3d:	40                   	inc    %eax
  802a3e:	a3 44 41 80 00       	mov    %eax,0x804144
  802a43:	e9 2a 06 00 00       	jmp    803072 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802a48:	a1 38 41 80 00       	mov    0x804138,%eax
  802a4d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a50:	e9 ed 05 00 00       	jmp    803042 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a58:	8b 00                	mov    (%eax),%eax
  802a5a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802a5d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a61:	0f 84 a7 00 00 00    	je     802b0e <insert_sorted_with_merge_freeList+0x271>
  802a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a6a:	8b 50 0c             	mov    0xc(%eax),%edx
  802a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a70:	8b 40 08             	mov    0x8(%eax),%eax
  802a73:	01 c2                	add    %eax,%edx
  802a75:	8b 45 08             	mov    0x8(%ebp),%eax
  802a78:	8b 40 08             	mov    0x8(%eax),%eax
  802a7b:	39 c2                	cmp    %eax,%edx
  802a7d:	0f 83 8b 00 00 00    	jae    802b0e <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	8b 50 0c             	mov    0xc(%eax),%edx
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	8b 40 08             	mov    0x8(%eax),%eax
  802a8f:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802a91:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a94:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802a97:	39 c2                	cmp    %eax,%edx
  802a99:	73 73                	jae    802b0e <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802a9b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a9f:	74 06                	je     802aa7 <insert_sorted_with_merge_freeList+0x20a>
  802aa1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802aa5:	75 17                	jne    802abe <insert_sorted_with_merge_freeList+0x221>
  802aa7:	83 ec 04             	sub    $0x4,%esp
  802aaa:	68 48 3d 80 00       	push   $0x803d48
  802aaf:	68 f0 00 00 00       	push   $0xf0
  802ab4:	68 b7 3c 80 00       	push   $0x803cb7
  802ab9:	e8 ff d7 ff ff       	call   8002bd <_panic>
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	8b 10                	mov    (%eax),%edx
  802ac3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac6:	89 10                	mov    %edx,(%eax)
  802ac8:	8b 45 08             	mov    0x8(%ebp),%eax
  802acb:	8b 00                	mov    (%eax),%eax
  802acd:	85 c0                	test   %eax,%eax
  802acf:	74 0b                	je     802adc <insert_sorted_with_merge_freeList+0x23f>
  802ad1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad4:	8b 00                	mov    (%eax),%eax
  802ad6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad9:	89 50 04             	mov    %edx,0x4(%eax)
  802adc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ae2:	89 10                	mov    %edx,(%eax)
  802ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aea:	89 50 04             	mov    %edx,0x4(%eax)
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	8b 00                	mov    (%eax),%eax
  802af2:	85 c0                	test   %eax,%eax
  802af4:	75 08                	jne    802afe <insert_sorted_with_merge_freeList+0x261>
  802af6:	8b 45 08             	mov    0x8(%ebp),%eax
  802af9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802afe:	a1 44 41 80 00       	mov    0x804144,%eax
  802b03:	40                   	inc    %eax
  802b04:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802b09:	e9 64 05 00 00       	jmp    803072 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802b0e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b13:	8b 50 0c             	mov    0xc(%eax),%edx
  802b16:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b1b:	8b 40 08             	mov    0x8(%eax),%eax
  802b1e:	01 c2                	add    %eax,%edx
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	8b 40 08             	mov    0x8(%eax),%eax
  802b26:	39 c2                	cmp    %eax,%edx
  802b28:	0f 85 b1 00 00 00    	jne    802bdf <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802b2e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b33:	85 c0                	test   %eax,%eax
  802b35:	0f 84 a4 00 00 00    	je     802bdf <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802b3b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	85 c0                	test   %eax,%eax
  802b44:	0f 85 95 00 00 00    	jne    802bdf <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802b4a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b4f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b55:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b58:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5b:	8b 52 0c             	mov    0xc(%edx),%edx
  802b5e:	01 ca                	add    %ecx,%edx
  802b60:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802b77:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b7b:	75 17                	jne    802b94 <insert_sorted_with_merge_freeList+0x2f7>
  802b7d:	83 ec 04             	sub    $0x4,%esp
  802b80:	68 94 3c 80 00       	push   $0x803c94
  802b85:	68 ff 00 00 00       	push   $0xff
  802b8a:	68 b7 3c 80 00       	push   $0x803cb7
  802b8f:	e8 29 d7 ff ff       	call   8002bd <_panic>
  802b94:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	89 10                	mov    %edx,(%eax)
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	8b 00                	mov    (%eax),%eax
  802ba4:	85 c0                	test   %eax,%eax
  802ba6:	74 0d                	je     802bb5 <insert_sorted_with_merge_freeList+0x318>
  802ba8:	a1 48 41 80 00       	mov    0x804148,%eax
  802bad:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb0:	89 50 04             	mov    %edx,0x4(%eax)
  802bb3:	eb 08                	jmp    802bbd <insert_sorted_with_merge_freeList+0x320>
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	a3 48 41 80 00       	mov    %eax,0x804148
  802bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bcf:	a1 54 41 80 00       	mov    0x804154,%eax
  802bd4:	40                   	inc    %eax
  802bd5:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802bda:	e9 93 04 00 00       	jmp    803072 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802bdf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be2:	8b 50 08             	mov    0x8(%eax),%edx
  802be5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be8:	8b 40 0c             	mov    0xc(%eax),%eax
  802beb:	01 c2                	add    %eax,%edx
  802bed:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf0:	8b 40 08             	mov    0x8(%eax),%eax
  802bf3:	39 c2                	cmp    %eax,%edx
  802bf5:	0f 85 ae 00 00 00    	jne    802ca9 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfe:	8b 50 0c             	mov    0xc(%eax),%edx
  802c01:	8b 45 08             	mov    0x8(%ebp),%eax
  802c04:	8b 40 08             	mov    0x8(%eax),%eax
  802c07:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802c09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0c:	8b 00                	mov    (%eax),%eax
  802c0e:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802c11:	39 c2                	cmp    %eax,%edx
  802c13:	0f 84 90 00 00 00    	je     802ca9 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 50 0c             	mov    0xc(%eax),%edx
  802c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c22:	8b 40 0c             	mov    0xc(%eax),%eax
  802c25:	01 c2                	add    %eax,%edx
  802c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c2a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c45:	75 17                	jne    802c5e <insert_sorted_with_merge_freeList+0x3c1>
  802c47:	83 ec 04             	sub    $0x4,%esp
  802c4a:	68 94 3c 80 00       	push   $0x803c94
  802c4f:	68 0b 01 00 00       	push   $0x10b
  802c54:	68 b7 3c 80 00       	push   $0x803cb7
  802c59:	e8 5f d6 ff ff       	call   8002bd <_panic>
  802c5e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c64:	8b 45 08             	mov    0x8(%ebp),%eax
  802c67:	89 10                	mov    %edx,(%eax)
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	8b 00                	mov    (%eax),%eax
  802c6e:	85 c0                	test   %eax,%eax
  802c70:	74 0d                	je     802c7f <insert_sorted_with_merge_freeList+0x3e2>
  802c72:	a1 48 41 80 00       	mov    0x804148,%eax
  802c77:	8b 55 08             	mov    0x8(%ebp),%edx
  802c7a:	89 50 04             	mov    %edx,0x4(%eax)
  802c7d:	eb 08                	jmp    802c87 <insert_sorted_with_merge_freeList+0x3ea>
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	a3 48 41 80 00       	mov    %eax,0x804148
  802c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c99:	a1 54 41 80 00       	mov    0x804154,%eax
  802c9e:	40                   	inc    %eax
  802c9f:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802ca4:	e9 c9 03 00 00       	jmp    803072 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802ca9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cac:	8b 50 0c             	mov    0xc(%eax),%edx
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	8b 40 08             	mov    0x8(%eax),%eax
  802cb5:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cba:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802cbd:	39 c2                	cmp    %eax,%edx
  802cbf:	0f 85 bb 00 00 00    	jne    802d80 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802cc5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc9:	0f 84 b1 00 00 00    	je     802d80 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802ccf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd2:	8b 40 04             	mov    0x4(%eax),%eax
  802cd5:	85 c0                	test   %eax,%eax
  802cd7:	0f 85 a3 00 00 00    	jne    802d80 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802cdd:	a1 38 41 80 00       	mov    0x804138,%eax
  802ce2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce5:	8b 52 08             	mov    0x8(%edx),%edx
  802ce8:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802ceb:	a1 38 41 80 00       	mov    0x804138,%eax
  802cf0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cf6:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802cf9:	8b 55 08             	mov    0x8(%ebp),%edx
  802cfc:	8b 52 0c             	mov    0xc(%edx),%edx
  802cff:	01 ca                	add    %ecx,%edx
  802d01:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d18:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d1c:	75 17                	jne    802d35 <insert_sorted_with_merge_freeList+0x498>
  802d1e:	83 ec 04             	sub    $0x4,%esp
  802d21:	68 94 3c 80 00       	push   $0x803c94
  802d26:	68 17 01 00 00       	push   $0x117
  802d2b:	68 b7 3c 80 00       	push   $0x803cb7
  802d30:	e8 88 d5 ff ff       	call   8002bd <_panic>
  802d35:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3e:	89 10                	mov    %edx,(%eax)
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	8b 00                	mov    (%eax),%eax
  802d45:	85 c0                	test   %eax,%eax
  802d47:	74 0d                	je     802d56 <insert_sorted_with_merge_freeList+0x4b9>
  802d49:	a1 48 41 80 00       	mov    0x804148,%eax
  802d4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d51:	89 50 04             	mov    %edx,0x4(%eax)
  802d54:	eb 08                	jmp    802d5e <insert_sorted_with_merge_freeList+0x4c1>
  802d56:	8b 45 08             	mov    0x8(%ebp),%eax
  802d59:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d61:	a3 48 41 80 00       	mov    %eax,0x804148
  802d66:	8b 45 08             	mov    0x8(%ebp),%eax
  802d69:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d70:	a1 54 41 80 00       	mov    0x804154,%eax
  802d75:	40                   	inc    %eax
  802d76:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d7b:	e9 f2 02 00 00       	jmp    803072 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802d80:	8b 45 08             	mov    0x8(%ebp),%eax
  802d83:	8b 50 08             	mov    0x8(%eax),%edx
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8c:	01 c2                	add    %eax,%edx
  802d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d91:	8b 40 08             	mov    0x8(%eax),%eax
  802d94:	39 c2                	cmp    %eax,%edx
  802d96:	0f 85 be 00 00 00    	jne    802e5a <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9f:	8b 40 04             	mov    0x4(%eax),%eax
  802da2:	8b 50 08             	mov    0x8(%eax),%edx
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 40 04             	mov    0x4(%eax),%eax
  802dab:	8b 40 0c             	mov    0xc(%eax),%eax
  802dae:	01 c2                	add    %eax,%edx
  802db0:	8b 45 08             	mov    0x8(%ebp),%eax
  802db3:	8b 40 08             	mov    0x8(%eax),%eax
  802db6:	39 c2                	cmp    %eax,%edx
  802db8:	0f 84 9c 00 00 00    	je     802e5a <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc1:	8b 50 08             	mov    0x8(%eax),%edx
  802dc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc7:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802dca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcd:	8b 50 0c             	mov    0xc(%eax),%edx
  802dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd3:	8b 40 0c             	mov    0xc(%eax),%eax
  802dd6:	01 c2                	add    %eax,%edx
  802dd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ddb:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802df2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802df6:	75 17                	jne    802e0f <insert_sorted_with_merge_freeList+0x572>
  802df8:	83 ec 04             	sub    $0x4,%esp
  802dfb:	68 94 3c 80 00       	push   $0x803c94
  802e00:	68 26 01 00 00       	push   $0x126
  802e05:	68 b7 3c 80 00       	push   $0x803cb7
  802e0a:	e8 ae d4 ff ff       	call   8002bd <_panic>
  802e0f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e15:	8b 45 08             	mov    0x8(%ebp),%eax
  802e18:	89 10                	mov    %edx,(%eax)
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	8b 00                	mov    (%eax),%eax
  802e1f:	85 c0                	test   %eax,%eax
  802e21:	74 0d                	je     802e30 <insert_sorted_with_merge_freeList+0x593>
  802e23:	a1 48 41 80 00       	mov    0x804148,%eax
  802e28:	8b 55 08             	mov    0x8(%ebp),%edx
  802e2b:	89 50 04             	mov    %edx,0x4(%eax)
  802e2e:	eb 08                	jmp    802e38 <insert_sorted_with_merge_freeList+0x59b>
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e38:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3b:	a3 48 41 80 00       	mov    %eax,0x804148
  802e40:	8b 45 08             	mov    0x8(%ebp),%eax
  802e43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4a:	a1 54 41 80 00       	mov    0x804154,%eax
  802e4f:	40                   	inc    %eax
  802e50:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802e55:	e9 18 02 00 00       	jmp    803072 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802e5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	8b 40 08             	mov    0x8(%eax),%eax
  802e66:	01 c2                	add    %eax,%edx
  802e68:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6b:	8b 40 08             	mov    0x8(%eax),%eax
  802e6e:	39 c2                	cmp    %eax,%edx
  802e70:	0f 85 c4 01 00 00    	jne    80303a <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	8b 50 0c             	mov    0xc(%eax),%edx
  802e7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7f:	8b 40 08             	mov    0x8(%eax),%eax
  802e82:	01 c2                	add    %eax,%edx
  802e84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e87:	8b 00                	mov    (%eax),%eax
  802e89:	8b 40 08             	mov    0x8(%eax),%eax
  802e8c:	39 c2                	cmp    %eax,%edx
  802e8e:	0f 85 a6 01 00 00    	jne    80303a <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802e94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e98:	0f 84 9c 01 00 00    	je     80303a <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802e9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea7:	8b 40 0c             	mov    0xc(%eax),%eax
  802eaa:	01 c2                	add    %eax,%edx
  802eac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eaf:	8b 00                	mov    (%eax),%eax
  802eb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb4:	01 c2                	add    %eax,%edx
  802eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb9:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802ed0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed4:	75 17                	jne    802eed <insert_sorted_with_merge_freeList+0x650>
  802ed6:	83 ec 04             	sub    $0x4,%esp
  802ed9:	68 94 3c 80 00       	push   $0x803c94
  802ede:	68 32 01 00 00       	push   $0x132
  802ee3:	68 b7 3c 80 00       	push   $0x803cb7
  802ee8:	e8 d0 d3 ff ff       	call   8002bd <_panic>
  802eed:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ef3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef6:	89 10                	mov    %edx,(%eax)
  802ef8:	8b 45 08             	mov    0x8(%ebp),%eax
  802efb:	8b 00                	mov    (%eax),%eax
  802efd:	85 c0                	test   %eax,%eax
  802eff:	74 0d                	je     802f0e <insert_sorted_with_merge_freeList+0x671>
  802f01:	a1 48 41 80 00       	mov    0x804148,%eax
  802f06:	8b 55 08             	mov    0x8(%ebp),%edx
  802f09:	89 50 04             	mov    %edx,0x4(%eax)
  802f0c:	eb 08                	jmp    802f16 <insert_sorted_with_merge_freeList+0x679>
  802f0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f11:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f16:	8b 45 08             	mov    0x8(%ebp),%eax
  802f19:	a3 48 41 80 00       	mov    %eax,0x804148
  802f1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f28:	a1 54 41 80 00       	mov    0x804154,%eax
  802f2d:	40                   	inc    %eax
  802f2e:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f42:	8b 00                	mov    (%eax),%eax
  802f44:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802f53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f57:	75 17                	jne    802f70 <insert_sorted_with_merge_freeList+0x6d3>
  802f59:	83 ec 04             	sub    $0x4,%esp
  802f5c:	68 29 3d 80 00       	push   $0x803d29
  802f61:	68 36 01 00 00       	push   $0x136
  802f66:	68 b7 3c 80 00       	push   $0x803cb7
  802f6b:	e8 4d d3 ff ff       	call   8002bd <_panic>
  802f70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f73:	8b 00                	mov    (%eax),%eax
  802f75:	85 c0                	test   %eax,%eax
  802f77:	74 10                	je     802f89 <insert_sorted_with_merge_freeList+0x6ec>
  802f79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7c:	8b 00                	mov    (%eax),%eax
  802f7e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f81:	8b 52 04             	mov    0x4(%edx),%edx
  802f84:	89 50 04             	mov    %edx,0x4(%eax)
  802f87:	eb 0b                	jmp    802f94 <insert_sorted_with_merge_freeList+0x6f7>
  802f89:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f8c:	8b 40 04             	mov    0x4(%eax),%eax
  802f8f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f97:	8b 40 04             	mov    0x4(%eax),%eax
  802f9a:	85 c0                	test   %eax,%eax
  802f9c:	74 0f                	je     802fad <insert_sorted_with_merge_freeList+0x710>
  802f9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa1:	8b 40 04             	mov    0x4(%eax),%eax
  802fa4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fa7:	8b 12                	mov    (%edx),%edx
  802fa9:	89 10                	mov    %edx,(%eax)
  802fab:	eb 0a                	jmp    802fb7 <insert_sorted_with_merge_freeList+0x71a>
  802fad:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb0:	8b 00                	mov    (%eax),%eax
  802fb2:	a3 38 41 80 00       	mov    %eax,0x804138
  802fb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fba:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fca:	a1 44 41 80 00       	mov    0x804144,%eax
  802fcf:	48                   	dec    %eax
  802fd0:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  802fd5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fd9:	75 17                	jne    802ff2 <insert_sorted_with_merge_freeList+0x755>
  802fdb:	83 ec 04             	sub    $0x4,%esp
  802fde:	68 94 3c 80 00       	push   $0x803c94
  802fe3:	68 37 01 00 00       	push   $0x137
  802fe8:	68 b7 3c 80 00       	push   $0x803cb7
  802fed:	e8 cb d2 ff ff       	call   8002bd <_panic>
  802ff2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ffb:	89 10                	mov    %edx,(%eax)
  802ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803000:	8b 00                	mov    (%eax),%eax
  803002:	85 c0                	test   %eax,%eax
  803004:	74 0d                	je     803013 <insert_sorted_with_merge_freeList+0x776>
  803006:	a1 48 41 80 00       	mov    0x804148,%eax
  80300b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80300e:	89 50 04             	mov    %edx,0x4(%eax)
  803011:	eb 08                	jmp    80301b <insert_sorted_with_merge_freeList+0x77e>
  803013:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803016:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80301b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301e:	a3 48 41 80 00       	mov    %eax,0x804148
  803023:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803026:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80302d:	a1 54 41 80 00       	mov    0x804154,%eax
  803032:	40                   	inc    %eax
  803033:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  803038:	eb 38                	jmp    803072 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80303a:	a1 40 41 80 00       	mov    0x804140,%eax
  80303f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803042:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803046:	74 07                	je     80304f <insert_sorted_with_merge_freeList+0x7b2>
  803048:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304b:	8b 00                	mov    (%eax),%eax
  80304d:	eb 05                	jmp    803054 <insert_sorted_with_merge_freeList+0x7b7>
  80304f:	b8 00 00 00 00       	mov    $0x0,%eax
  803054:	a3 40 41 80 00       	mov    %eax,0x804140
  803059:	a1 40 41 80 00       	mov    0x804140,%eax
  80305e:	85 c0                	test   %eax,%eax
  803060:	0f 85 ef f9 ff ff    	jne    802a55 <insert_sorted_with_merge_freeList+0x1b8>
  803066:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80306a:	0f 85 e5 f9 ff ff    	jne    802a55 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803070:	eb 00                	jmp    803072 <insert_sorted_with_merge_freeList+0x7d5>
  803072:	90                   	nop
  803073:	c9                   	leave  
  803074:	c3                   	ret    

00803075 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803075:	55                   	push   %ebp
  803076:	89 e5                	mov    %esp,%ebp
  803078:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80307b:	8b 55 08             	mov    0x8(%ebp),%edx
  80307e:	89 d0                	mov    %edx,%eax
  803080:	c1 e0 02             	shl    $0x2,%eax
  803083:	01 d0                	add    %edx,%eax
  803085:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80308c:	01 d0                	add    %edx,%eax
  80308e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803095:	01 d0                	add    %edx,%eax
  803097:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80309e:	01 d0                	add    %edx,%eax
  8030a0:	c1 e0 04             	shl    $0x4,%eax
  8030a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8030a6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030ad:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030b0:	83 ec 0c             	sub    $0xc,%esp
  8030b3:	50                   	push   %eax
  8030b4:	e8 21 ec ff ff       	call   801cda <sys_get_virtual_time>
  8030b9:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030bc:	eb 41                	jmp    8030ff <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030be:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030c1:	83 ec 0c             	sub    $0xc,%esp
  8030c4:	50                   	push   %eax
  8030c5:	e8 10 ec ff ff       	call   801cda <sys_get_virtual_time>
  8030ca:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030cd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030d0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030d3:	29 c2                	sub    %eax,%edx
  8030d5:	89 d0                	mov    %edx,%eax
  8030d7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030da:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030dd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030e0:	89 d1                	mov    %edx,%ecx
  8030e2:	29 c1                	sub    %eax,%ecx
  8030e4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030e7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030ea:	39 c2                	cmp    %eax,%edx
  8030ec:	0f 97 c0             	seta   %al
  8030ef:	0f b6 c0             	movzbl %al,%eax
  8030f2:	29 c1                	sub    %eax,%ecx
  8030f4:	89 c8                	mov    %ecx,%eax
  8030f6:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8030f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030fc:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8030ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803102:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803105:	72 b7                	jb     8030be <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803107:	90                   	nop
  803108:	c9                   	leave  
  803109:	c3                   	ret    

0080310a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80310a:	55                   	push   %ebp
  80310b:	89 e5                	mov    %esp,%ebp
  80310d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803110:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803117:	eb 03                	jmp    80311c <busy_wait+0x12>
  803119:	ff 45 fc             	incl   -0x4(%ebp)
  80311c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80311f:	3b 45 08             	cmp    0x8(%ebp),%eax
  803122:	72 f5                	jb     803119 <busy_wait+0xf>
	return i;
  803124:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803127:	c9                   	leave  
  803128:	c3                   	ret    
  803129:	66 90                	xchg   %ax,%ax
  80312b:	90                   	nop

0080312c <__udivdi3>:
  80312c:	55                   	push   %ebp
  80312d:	57                   	push   %edi
  80312e:	56                   	push   %esi
  80312f:	53                   	push   %ebx
  803130:	83 ec 1c             	sub    $0x1c,%esp
  803133:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803137:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80313b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80313f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803143:	89 ca                	mov    %ecx,%edx
  803145:	89 f8                	mov    %edi,%eax
  803147:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80314b:	85 f6                	test   %esi,%esi
  80314d:	75 2d                	jne    80317c <__udivdi3+0x50>
  80314f:	39 cf                	cmp    %ecx,%edi
  803151:	77 65                	ja     8031b8 <__udivdi3+0x8c>
  803153:	89 fd                	mov    %edi,%ebp
  803155:	85 ff                	test   %edi,%edi
  803157:	75 0b                	jne    803164 <__udivdi3+0x38>
  803159:	b8 01 00 00 00       	mov    $0x1,%eax
  80315e:	31 d2                	xor    %edx,%edx
  803160:	f7 f7                	div    %edi
  803162:	89 c5                	mov    %eax,%ebp
  803164:	31 d2                	xor    %edx,%edx
  803166:	89 c8                	mov    %ecx,%eax
  803168:	f7 f5                	div    %ebp
  80316a:	89 c1                	mov    %eax,%ecx
  80316c:	89 d8                	mov    %ebx,%eax
  80316e:	f7 f5                	div    %ebp
  803170:	89 cf                	mov    %ecx,%edi
  803172:	89 fa                	mov    %edi,%edx
  803174:	83 c4 1c             	add    $0x1c,%esp
  803177:	5b                   	pop    %ebx
  803178:	5e                   	pop    %esi
  803179:	5f                   	pop    %edi
  80317a:	5d                   	pop    %ebp
  80317b:	c3                   	ret    
  80317c:	39 ce                	cmp    %ecx,%esi
  80317e:	77 28                	ja     8031a8 <__udivdi3+0x7c>
  803180:	0f bd fe             	bsr    %esi,%edi
  803183:	83 f7 1f             	xor    $0x1f,%edi
  803186:	75 40                	jne    8031c8 <__udivdi3+0x9c>
  803188:	39 ce                	cmp    %ecx,%esi
  80318a:	72 0a                	jb     803196 <__udivdi3+0x6a>
  80318c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803190:	0f 87 9e 00 00 00    	ja     803234 <__udivdi3+0x108>
  803196:	b8 01 00 00 00       	mov    $0x1,%eax
  80319b:	89 fa                	mov    %edi,%edx
  80319d:	83 c4 1c             	add    $0x1c,%esp
  8031a0:	5b                   	pop    %ebx
  8031a1:	5e                   	pop    %esi
  8031a2:	5f                   	pop    %edi
  8031a3:	5d                   	pop    %ebp
  8031a4:	c3                   	ret    
  8031a5:	8d 76 00             	lea    0x0(%esi),%esi
  8031a8:	31 ff                	xor    %edi,%edi
  8031aa:	31 c0                	xor    %eax,%eax
  8031ac:	89 fa                	mov    %edi,%edx
  8031ae:	83 c4 1c             	add    $0x1c,%esp
  8031b1:	5b                   	pop    %ebx
  8031b2:	5e                   	pop    %esi
  8031b3:	5f                   	pop    %edi
  8031b4:	5d                   	pop    %ebp
  8031b5:	c3                   	ret    
  8031b6:	66 90                	xchg   %ax,%ax
  8031b8:	89 d8                	mov    %ebx,%eax
  8031ba:	f7 f7                	div    %edi
  8031bc:	31 ff                	xor    %edi,%edi
  8031be:	89 fa                	mov    %edi,%edx
  8031c0:	83 c4 1c             	add    $0x1c,%esp
  8031c3:	5b                   	pop    %ebx
  8031c4:	5e                   	pop    %esi
  8031c5:	5f                   	pop    %edi
  8031c6:	5d                   	pop    %ebp
  8031c7:	c3                   	ret    
  8031c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031cd:	89 eb                	mov    %ebp,%ebx
  8031cf:	29 fb                	sub    %edi,%ebx
  8031d1:	89 f9                	mov    %edi,%ecx
  8031d3:	d3 e6                	shl    %cl,%esi
  8031d5:	89 c5                	mov    %eax,%ebp
  8031d7:	88 d9                	mov    %bl,%cl
  8031d9:	d3 ed                	shr    %cl,%ebp
  8031db:	89 e9                	mov    %ebp,%ecx
  8031dd:	09 f1                	or     %esi,%ecx
  8031df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031e3:	89 f9                	mov    %edi,%ecx
  8031e5:	d3 e0                	shl    %cl,%eax
  8031e7:	89 c5                	mov    %eax,%ebp
  8031e9:	89 d6                	mov    %edx,%esi
  8031eb:	88 d9                	mov    %bl,%cl
  8031ed:	d3 ee                	shr    %cl,%esi
  8031ef:	89 f9                	mov    %edi,%ecx
  8031f1:	d3 e2                	shl    %cl,%edx
  8031f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031f7:	88 d9                	mov    %bl,%cl
  8031f9:	d3 e8                	shr    %cl,%eax
  8031fb:	09 c2                	or     %eax,%edx
  8031fd:	89 d0                	mov    %edx,%eax
  8031ff:	89 f2                	mov    %esi,%edx
  803201:	f7 74 24 0c          	divl   0xc(%esp)
  803205:	89 d6                	mov    %edx,%esi
  803207:	89 c3                	mov    %eax,%ebx
  803209:	f7 e5                	mul    %ebp
  80320b:	39 d6                	cmp    %edx,%esi
  80320d:	72 19                	jb     803228 <__udivdi3+0xfc>
  80320f:	74 0b                	je     80321c <__udivdi3+0xf0>
  803211:	89 d8                	mov    %ebx,%eax
  803213:	31 ff                	xor    %edi,%edi
  803215:	e9 58 ff ff ff       	jmp    803172 <__udivdi3+0x46>
  80321a:	66 90                	xchg   %ax,%ax
  80321c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803220:	89 f9                	mov    %edi,%ecx
  803222:	d3 e2                	shl    %cl,%edx
  803224:	39 c2                	cmp    %eax,%edx
  803226:	73 e9                	jae    803211 <__udivdi3+0xe5>
  803228:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80322b:	31 ff                	xor    %edi,%edi
  80322d:	e9 40 ff ff ff       	jmp    803172 <__udivdi3+0x46>
  803232:	66 90                	xchg   %ax,%ax
  803234:	31 c0                	xor    %eax,%eax
  803236:	e9 37 ff ff ff       	jmp    803172 <__udivdi3+0x46>
  80323b:	90                   	nop

0080323c <__umoddi3>:
  80323c:	55                   	push   %ebp
  80323d:	57                   	push   %edi
  80323e:	56                   	push   %esi
  80323f:	53                   	push   %ebx
  803240:	83 ec 1c             	sub    $0x1c,%esp
  803243:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803247:	8b 74 24 34          	mov    0x34(%esp),%esi
  80324b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80324f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803253:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803257:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80325b:	89 f3                	mov    %esi,%ebx
  80325d:	89 fa                	mov    %edi,%edx
  80325f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803263:	89 34 24             	mov    %esi,(%esp)
  803266:	85 c0                	test   %eax,%eax
  803268:	75 1a                	jne    803284 <__umoddi3+0x48>
  80326a:	39 f7                	cmp    %esi,%edi
  80326c:	0f 86 a2 00 00 00    	jbe    803314 <__umoddi3+0xd8>
  803272:	89 c8                	mov    %ecx,%eax
  803274:	89 f2                	mov    %esi,%edx
  803276:	f7 f7                	div    %edi
  803278:	89 d0                	mov    %edx,%eax
  80327a:	31 d2                	xor    %edx,%edx
  80327c:	83 c4 1c             	add    $0x1c,%esp
  80327f:	5b                   	pop    %ebx
  803280:	5e                   	pop    %esi
  803281:	5f                   	pop    %edi
  803282:	5d                   	pop    %ebp
  803283:	c3                   	ret    
  803284:	39 f0                	cmp    %esi,%eax
  803286:	0f 87 ac 00 00 00    	ja     803338 <__umoddi3+0xfc>
  80328c:	0f bd e8             	bsr    %eax,%ebp
  80328f:	83 f5 1f             	xor    $0x1f,%ebp
  803292:	0f 84 ac 00 00 00    	je     803344 <__umoddi3+0x108>
  803298:	bf 20 00 00 00       	mov    $0x20,%edi
  80329d:	29 ef                	sub    %ebp,%edi
  80329f:	89 fe                	mov    %edi,%esi
  8032a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032a5:	89 e9                	mov    %ebp,%ecx
  8032a7:	d3 e0                	shl    %cl,%eax
  8032a9:	89 d7                	mov    %edx,%edi
  8032ab:	89 f1                	mov    %esi,%ecx
  8032ad:	d3 ef                	shr    %cl,%edi
  8032af:	09 c7                	or     %eax,%edi
  8032b1:	89 e9                	mov    %ebp,%ecx
  8032b3:	d3 e2                	shl    %cl,%edx
  8032b5:	89 14 24             	mov    %edx,(%esp)
  8032b8:	89 d8                	mov    %ebx,%eax
  8032ba:	d3 e0                	shl    %cl,%eax
  8032bc:	89 c2                	mov    %eax,%edx
  8032be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032c2:	d3 e0                	shl    %cl,%eax
  8032c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032cc:	89 f1                	mov    %esi,%ecx
  8032ce:	d3 e8                	shr    %cl,%eax
  8032d0:	09 d0                	or     %edx,%eax
  8032d2:	d3 eb                	shr    %cl,%ebx
  8032d4:	89 da                	mov    %ebx,%edx
  8032d6:	f7 f7                	div    %edi
  8032d8:	89 d3                	mov    %edx,%ebx
  8032da:	f7 24 24             	mull   (%esp)
  8032dd:	89 c6                	mov    %eax,%esi
  8032df:	89 d1                	mov    %edx,%ecx
  8032e1:	39 d3                	cmp    %edx,%ebx
  8032e3:	0f 82 87 00 00 00    	jb     803370 <__umoddi3+0x134>
  8032e9:	0f 84 91 00 00 00    	je     803380 <__umoddi3+0x144>
  8032ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032f3:	29 f2                	sub    %esi,%edx
  8032f5:	19 cb                	sbb    %ecx,%ebx
  8032f7:	89 d8                	mov    %ebx,%eax
  8032f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032fd:	d3 e0                	shl    %cl,%eax
  8032ff:	89 e9                	mov    %ebp,%ecx
  803301:	d3 ea                	shr    %cl,%edx
  803303:	09 d0                	or     %edx,%eax
  803305:	89 e9                	mov    %ebp,%ecx
  803307:	d3 eb                	shr    %cl,%ebx
  803309:	89 da                	mov    %ebx,%edx
  80330b:	83 c4 1c             	add    $0x1c,%esp
  80330e:	5b                   	pop    %ebx
  80330f:	5e                   	pop    %esi
  803310:	5f                   	pop    %edi
  803311:	5d                   	pop    %ebp
  803312:	c3                   	ret    
  803313:	90                   	nop
  803314:	89 fd                	mov    %edi,%ebp
  803316:	85 ff                	test   %edi,%edi
  803318:	75 0b                	jne    803325 <__umoddi3+0xe9>
  80331a:	b8 01 00 00 00       	mov    $0x1,%eax
  80331f:	31 d2                	xor    %edx,%edx
  803321:	f7 f7                	div    %edi
  803323:	89 c5                	mov    %eax,%ebp
  803325:	89 f0                	mov    %esi,%eax
  803327:	31 d2                	xor    %edx,%edx
  803329:	f7 f5                	div    %ebp
  80332b:	89 c8                	mov    %ecx,%eax
  80332d:	f7 f5                	div    %ebp
  80332f:	89 d0                	mov    %edx,%eax
  803331:	e9 44 ff ff ff       	jmp    80327a <__umoddi3+0x3e>
  803336:	66 90                	xchg   %ax,%ax
  803338:	89 c8                	mov    %ecx,%eax
  80333a:	89 f2                	mov    %esi,%edx
  80333c:	83 c4 1c             	add    $0x1c,%esp
  80333f:	5b                   	pop    %ebx
  803340:	5e                   	pop    %esi
  803341:	5f                   	pop    %edi
  803342:	5d                   	pop    %ebp
  803343:	c3                   	ret    
  803344:	3b 04 24             	cmp    (%esp),%eax
  803347:	72 06                	jb     80334f <__umoddi3+0x113>
  803349:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80334d:	77 0f                	ja     80335e <__umoddi3+0x122>
  80334f:	89 f2                	mov    %esi,%edx
  803351:	29 f9                	sub    %edi,%ecx
  803353:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803357:	89 14 24             	mov    %edx,(%esp)
  80335a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80335e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803362:	8b 14 24             	mov    (%esp),%edx
  803365:	83 c4 1c             	add    $0x1c,%esp
  803368:	5b                   	pop    %ebx
  803369:	5e                   	pop    %esi
  80336a:	5f                   	pop    %edi
  80336b:	5d                   	pop    %ebp
  80336c:	c3                   	ret    
  80336d:	8d 76 00             	lea    0x0(%esi),%esi
  803370:	2b 04 24             	sub    (%esp),%eax
  803373:	19 fa                	sbb    %edi,%edx
  803375:	89 d1                	mov    %edx,%ecx
  803377:	89 c6                	mov    %eax,%esi
  803379:	e9 71 ff ff ff       	jmp    8032ef <__umoddi3+0xb3>
  80337e:	66 90                	xchg   %ax,%ax
  803380:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803384:	72 ea                	jb     803370 <__umoddi3+0x134>
  803386:	89 d9                	mov    %ebx,%ecx
  803388:	e9 62 ff ff ff       	jmp    8032ef <__umoddi3+0xb3>
