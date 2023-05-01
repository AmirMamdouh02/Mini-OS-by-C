
obj/user/ef_tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 05 01 00 00       	call   80013b <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Test the free of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 18             	sub    $0x18,%esp
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
_main(void)
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
  80008c:	68 60 33 80 00       	push   $0x803360
  800091:	6a 12                	push   $0x12
  800093:	68 7c 33 80 00       	push   $0x80337c
  800098:	e8 da 01 00 00       	call   800277 <_panic>
	}
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 bf 1b 00 00       	call   801c61 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 9c 33 80 00       	push   $0x80339c
  8000aa:	50                   	push   %eax
  8000ab:	e8 6a 16 00 00       	call   80171a <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 a0 33 80 00       	push   $0x8033a0
  8000be:	e8 68 04 00 00       	call   80052b <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B1 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 c8 33 80 00       	push   $0x8033c8
  8000ce:	e8 58 04 00 00       	call   80052b <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(6000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 70 17 00 00       	push   $0x1770
  8000de:	e8 4c 2f 00 00       	call   80302f <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 7d 18 00 00       	call   801968 <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 0f 17 00 00       	call   801808 <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 e8 33 80 00       	push   $0x8033e8
  800104:	e8 22 04 00 00       	call   80052b <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  80010c:	e8 57 18 00 00       	call   801968 <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 00 34 80 00       	push   $0x803400
  800127:	6a 20                	push   $0x20
  800129:	68 7c 33 80 00       	push   $0x80337c
  80012e:	e8 44 01 00 00       	call   800277 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800133:	e8 4e 1c 00 00       	call   801d86 <inctst>
	return;
  800138:	90                   	nop
}
  800139:	c9                   	leave  
  80013a:	c3                   	ret    

0080013b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80013b:	55                   	push   %ebp
  80013c:	89 e5                	mov    %esp,%ebp
  80013e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800141:	e8 02 1b 00 00       	call   801c48 <sys_getenvindex>
  800146:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800149:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80014c:	89 d0                	mov    %edx,%eax
  80014e:	c1 e0 03             	shl    $0x3,%eax
  800151:	01 d0                	add    %edx,%eax
  800153:	01 c0                	add    %eax,%eax
  800155:	01 d0                	add    %edx,%eax
  800157:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80015e:	01 d0                	add    %edx,%eax
  800160:	c1 e0 04             	shl    $0x4,%eax
  800163:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800168:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80016d:	a1 20 40 80 00       	mov    0x804020,%eax
  800172:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800178:	84 c0                	test   %al,%al
  80017a:	74 0f                	je     80018b <libmain+0x50>
		binaryname = myEnv->prog_name;
  80017c:	a1 20 40 80 00       	mov    0x804020,%eax
  800181:	05 5c 05 00 00       	add    $0x55c,%eax
  800186:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80018b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80018f:	7e 0a                	jle    80019b <libmain+0x60>
		binaryname = argv[0];
  800191:	8b 45 0c             	mov    0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80019b:	83 ec 08             	sub    $0x8,%esp
  80019e:	ff 75 0c             	pushl  0xc(%ebp)
  8001a1:	ff 75 08             	pushl  0x8(%ebp)
  8001a4:	e8 8f fe ff ff       	call   800038 <_main>
  8001a9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001ac:	e8 a4 18 00 00       	call   801a55 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001b1:	83 ec 0c             	sub    $0xc,%esp
  8001b4:	68 c0 34 80 00       	push   $0x8034c0
  8001b9:	e8 6d 03 00 00       	call   80052b <cprintf>
  8001be:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001cc:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d1:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d7:	83 ec 04             	sub    $0x4,%esp
  8001da:	52                   	push   %edx
  8001db:	50                   	push   %eax
  8001dc:	68 e8 34 80 00       	push   $0x8034e8
  8001e1:	e8 45 03 00 00       	call   80052b <cprintf>
  8001e6:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ee:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001f4:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f9:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001ff:	a1 20 40 80 00       	mov    0x804020,%eax
  800204:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80020a:	51                   	push   %ecx
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 10 35 80 00       	push   $0x803510
  800212:	e8 14 03 00 00       	call   80052b <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800225:	83 ec 08             	sub    $0x8,%esp
  800228:	50                   	push   %eax
  800229:	68 68 35 80 00       	push   $0x803568
  80022e:	e8 f8 02 00 00       	call   80052b <cprintf>
  800233:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800236:	83 ec 0c             	sub    $0xc,%esp
  800239:	68 c0 34 80 00       	push   $0x8034c0
  80023e:	e8 e8 02 00 00       	call   80052b <cprintf>
  800243:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800246:	e8 24 18 00 00       	call   801a6f <sys_enable_interrupt>

	// exit gracefully
	exit();
  80024b:	e8 19 00 00 00       	call   800269 <exit>
}
  800250:	90                   	nop
  800251:	c9                   	leave  
  800252:	c3                   	ret    

00800253 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800253:	55                   	push   %ebp
  800254:	89 e5                	mov    %esp,%ebp
  800256:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	6a 00                	push   $0x0
  80025e:	e8 b1 19 00 00       	call   801c14 <sys_destroy_env>
  800263:	83 c4 10             	add    $0x10,%esp
}
  800266:	90                   	nop
  800267:	c9                   	leave  
  800268:	c3                   	ret    

00800269 <exit>:

void
exit(void)
{
  800269:	55                   	push   %ebp
  80026a:	89 e5                	mov    %esp,%ebp
  80026c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80026f:	e8 06 1a 00 00       	call   801c7a <sys_exit_env>
}
  800274:	90                   	nop
  800275:	c9                   	leave  
  800276:	c3                   	ret    

00800277 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800277:	55                   	push   %ebp
  800278:	89 e5                	mov    %esp,%ebp
  80027a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80027d:	8d 45 10             	lea    0x10(%ebp),%eax
  800280:	83 c0 04             	add    $0x4,%eax
  800283:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800286:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80028b:	85 c0                	test   %eax,%eax
  80028d:	74 16                	je     8002a5 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80028f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800294:	83 ec 08             	sub    $0x8,%esp
  800297:	50                   	push   %eax
  800298:	68 7c 35 80 00       	push   $0x80357c
  80029d:	e8 89 02 00 00       	call   80052b <cprintf>
  8002a2:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002a5:	a1 00 40 80 00       	mov    0x804000,%eax
  8002aa:	ff 75 0c             	pushl  0xc(%ebp)
  8002ad:	ff 75 08             	pushl  0x8(%ebp)
  8002b0:	50                   	push   %eax
  8002b1:	68 81 35 80 00       	push   $0x803581
  8002b6:	e8 70 02 00 00       	call   80052b <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002be:	8b 45 10             	mov    0x10(%ebp),%eax
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c7:	50                   	push   %eax
  8002c8:	e8 f3 01 00 00       	call   8004c0 <vcprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002d0:	83 ec 08             	sub    $0x8,%esp
  8002d3:	6a 00                	push   $0x0
  8002d5:	68 9d 35 80 00       	push   $0x80359d
  8002da:	e8 e1 01 00 00       	call   8004c0 <vcprintf>
  8002df:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002e2:	e8 82 ff ff ff       	call   800269 <exit>

	// should not return here
	while (1) ;
  8002e7:	eb fe                	jmp    8002e7 <_panic+0x70>

008002e9 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002ef:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f4:	8b 50 74             	mov    0x74(%eax),%edx
  8002f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fa:	39 c2                	cmp    %eax,%edx
  8002fc:	74 14                	je     800312 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002fe:	83 ec 04             	sub    $0x4,%esp
  800301:	68 a0 35 80 00       	push   $0x8035a0
  800306:	6a 26                	push   $0x26
  800308:	68 ec 35 80 00       	push   $0x8035ec
  80030d:	e8 65 ff ff ff       	call   800277 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800312:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800319:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800320:	e9 c2 00 00 00       	jmp    8003e7 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800328:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80032f:	8b 45 08             	mov    0x8(%ebp),%eax
  800332:	01 d0                	add    %edx,%eax
  800334:	8b 00                	mov    (%eax),%eax
  800336:	85 c0                	test   %eax,%eax
  800338:	75 08                	jne    800342 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80033a:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80033d:	e9 a2 00 00 00       	jmp    8003e4 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800342:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800349:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800350:	eb 69                	jmp    8003bb <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800352:	a1 20 40 80 00       	mov    0x804020,%eax
  800357:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80035d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800360:	89 d0                	mov    %edx,%eax
  800362:	01 c0                	add    %eax,%eax
  800364:	01 d0                	add    %edx,%eax
  800366:	c1 e0 03             	shl    $0x3,%eax
  800369:	01 c8                	add    %ecx,%eax
  80036b:	8a 40 04             	mov    0x4(%eax),%al
  80036e:	84 c0                	test   %al,%al
  800370:	75 46                	jne    8003b8 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800372:	a1 20 40 80 00       	mov    0x804020,%eax
  800377:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80037d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800380:	89 d0                	mov    %edx,%eax
  800382:	01 c0                	add    %eax,%eax
  800384:	01 d0                	add    %edx,%eax
  800386:	c1 e0 03             	shl    $0x3,%eax
  800389:	01 c8                	add    %ecx,%eax
  80038b:	8b 00                	mov    (%eax),%eax
  80038d:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800390:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800393:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800398:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80039a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039d:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a7:	01 c8                	add    %ecx,%eax
  8003a9:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ab:	39 c2                	cmp    %eax,%edx
  8003ad:	75 09                	jne    8003b8 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003af:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b6:	eb 12                	jmp    8003ca <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b8:	ff 45 e8             	incl   -0x18(%ebp)
  8003bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c0:	8b 50 74             	mov    0x74(%eax),%edx
  8003c3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c6:	39 c2                	cmp    %eax,%edx
  8003c8:	77 88                	ja     800352 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003ce:	75 14                	jne    8003e4 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003d0:	83 ec 04             	sub    $0x4,%esp
  8003d3:	68 f8 35 80 00       	push   $0x8035f8
  8003d8:	6a 3a                	push   $0x3a
  8003da:	68 ec 35 80 00       	push   $0x8035ec
  8003df:	e8 93 fe ff ff       	call   800277 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003e4:	ff 45 f0             	incl   -0x10(%ebp)
  8003e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ea:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003ed:	0f 8c 32 ff ff ff    	jl     800325 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003f3:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800401:	eb 26                	jmp    800429 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800403:	a1 20 40 80 00       	mov    0x804020,%eax
  800408:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80040e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800411:	89 d0                	mov    %edx,%eax
  800413:	01 c0                	add    %eax,%eax
  800415:	01 d0                	add    %edx,%eax
  800417:	c1 e0 03             	shl    $0x3,%eax
  80041a:	01 c8                	add    %ecx,%eax
  80041c:	8a 40 04             	mov    0x4(%eax),%al
  80041f:	3c 01                	cmp    $0x1,%al
  800421:	75 03                	jne    800426 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800423:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800426:	ff 45 e0             	incl   -0x20(%ebp)
  800429:	a1 20 40 80 00       	mov    0x804020,%eax
  80042e:	8b 50 74             	mov    0x74(%eax),%edx
  800431:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800434:	39 c2                	cmp    %eax,%edx
  800436:	77 cb                	ja     800403 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80043b:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80043e:	74 14                	je     800454 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 4c 36 80 00       	push   $0x80364c
  800448:	6a 44                	push   $0x44
  80044a:	68 ec 35 80 00       	push   $0x8035ec
  80044f:	e8 23 fe ff ff       	call   800277 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800454:	90                   	nop
  800455:	c9                   	leave  
  800456:	c3                   	ret    

00800457 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800457:	55                   	push   %ebp
  800458:	89 e5                	mov    %esp,%ebp
  80045a:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80045d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800460:	8b 00                	mov    (%eax),%eax
  800462:	8d 48 01             	lea    0x1(%eax),%ecx
  800465:	8b 55 0c             	mov    0xc(%ebp),%edx
  800468:	89 0a                	mov    %ecx,(%edx)
  80046a:	8b 55 08             	mov    0x8(%ebp),%edx
  80046d:	88 d1                	mov    %dl,%cl
  80046f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800472:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	3d ff 00 00 00       	cmp    $0xff,%eax
  800480:	75 2c                	jne    8004ae <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800482:	a0 24 40 80 00       	mov    0x804024,%al
  800487:	0f b6 c0             	movzbl %al,%eax
  80048a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048d:	8b 12                	mov    (%edx),%edx
  80048f:	89 d1                	mov    %edx,%ecx
  800491:	8b 55 0c             	mov    0xc(%ebp),%edx
  800494:	83 c2 08             	add    $0x8,%edx
  800497:	83 ec 04             	sub    $0x4,%esp
  80049a:	50                   	push   %eax
  80049b:	51                   	push   %ecx
  80049c:	52                   	push   %edx
  80049d:	e8 05 14 00 00       	call   8018a7 <sys_cputs>
  8004a2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b1:	8b 40 04             	mov    0x4(%eax),%eax
  8004b4:	8d 50 01             	lea    0x1(%eax),%edx
  8004b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ba:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004bd:	90                   	nop
  8004be:	c9                   	leave  
  8004bf:	c3                   	ret    

008004c0 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004c0:	55                   	push   %ebp
  8004c1:	89 e5                	mov    %esp,%ebp
  8004c3:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c9:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004d0:	00 00 00 
	b.cnt = 0;
  8004d3:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004da:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004dd:	ff 75 0c             	pushl  0xc(%ebp)
  8004e0:	ff 75 08             	pushl  0x8(%ebp)
  8004e3:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e9:	50                   	push   %eax
  8004ea:	68 57 04 80 00       	push   $0x800457
  8004ef:	e8 11 02 00 00       	call   800705 <vprintfmt>
  8004f4:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f7:	a0 24 40 80 00       	mov    0x804024,%al
  8004fc:	0f b6 c0             	movzbl %al,%eax
  8004ff:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800505:	83 ec 04             	sub    $0x4,%esp
  800508:	50                   	push   %eax
  800509:	52                   	push   %edx
  80050a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800510:	83 c0 08             	add    $0x8,%eax
  800513:	50                   	push   %eax
  800514:	e8 8e 13 00 00       	call   8018a7 <sys_cputs>
  800519:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80051c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800523:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800529:	c9                   	leave  
  80052a:	c3                   	ret    

0080052b <cprintf>:

int cprintf(const char *fmt, ...) {
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
  80052e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800531:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800538:	8d 45 0c             	lea    0xc(%ebp),%eax
  80053b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80053e:	8b 45 08             	mov    0x8(%ebp),%eax
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	ff 75 f4             	pushl  -0xc(%ebp)
  800547:	50                   	push   %eax
  800548:	e8 73 ff ff ff       	call   8004c0 <vcprintf>
  80054d:	83 c4 10             	add    $0x10,%esp
  800550:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800553:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800556:	c9                   	leave  
  800557:	c3                   	ret    

00800558 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800558:	55                   	push   %ebp
  800559:	89 e5                	mov    %esp,%ebp
  80055b:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80055e:	e8 f2 14 00 00       	call   801a55 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800563:	8d 45 0c             	lea    0xc(%ebp),%eax
  800566:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800569:	8b 45 08             	mov    0x8(%ebp),%eax
  80056c:	83 ec 08             	sub    $0x8,%esp
  80056f:	ff 75 f4             	pushl  -0xc(%ebp)
  800572:	50                   	push   %eax
  800573:	e8 48 ff ff ff       	call   8004c0 <vcprintf>
  800578:	83 c4 10             	add    $0x10,%esp
  80057b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80057e:	e8 ec 14 00 00       	call   801a6f <sys_enable_interrupt>
	return cnt;
  800583:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800586:	c9                   	leave  
  800587:	c3                   	ret    

00800588 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800588:	55                   	push   %ebp
  800589:	89 e5                	mov    %esp,%ebp
  80058b:	53                   	push   %ebx
  80058c:	83 ec 14             	sub    $0x14,%esp
  80058f:	8b 45 10             	mov    0x10(%ebp),%eax
  800592:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800595:	8b 45 14             	mov    0x14(%ebp),%eax
  800598:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80059b:	8b 45 18             	mov    0x18(%ebp),%eax
  80059e:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a6:	77 55                	ja     8005fd <printnum+0x75>
  8005a8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ab:	72 05                	jb     8005b2 <printnum+0x2a>
  8005ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005b0:	77 4b                	ja     8005fd <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005b2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005b5:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b8:	8b 45 18             	mov    0x18(%ebp),%eax
  8005bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8005c0:	52                   	push   %edx
  8005c1:	50                   	push   %eax
  8005c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8005c5:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c8:	e8 17 2b 00 00       	call   8030e4 <__udivdi3>
  8005cd:	83 c4 10             	add    $0x10,%esp
  8005d0:	83 ec 04             	sub    $0x4,%esp
  8005d3:	ff 75 20             	pushl  0x20(%ebp)
  8005d6:	53                   	push   %ebx
  8005d7:	ff 75 18             	pushl  0x18(%ebp)
  8005da:	52                   	push   %edx
  8005db:	50                   	push   %eax
  8005dc:	ff 75 0c             	pushl  0xc(%ebp)
  8005df:	ff 75 08             	pushl  0x8(%ebp)
  8005e2:	e8 a1 ff ff ff       	call   800588 <printnum>
  8005e7:	83 c4 20             	add    $0x20,%esp
  8005ea:	eb 1a                	jmp    800606 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005ec:	83 ec 08             	sub    $0x8,%esp
  8005ef:	ff 75 0c             	pushl  0xc(%ebp)
  8005f2:	ff 75 20             	pushl  0x20(%ebp)
  8005f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f8:	ff d0                	call   *%eax
  8005fa:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005fd:	ff 4d 1c             	decl   0x1c(%ebp)
  800600:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800604:	7f e6                	jg     8005ec <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800606:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800609:	bb 00 00 00 00       	mov    $0x0,%ebx
  80060e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800611:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800614:	53                   	push   %ebx
  800615:	51                   	push   %ecx
  800616:	52                   	push   %edx
  800617:	50                   	push   %eax
  800618:	e8 d7 2b 00 00       	call   8031f4 <__umoddi3>
  80061d:	83 c4 10             	add    $0x10,%esp
  800620:	05 b4 38 80 00       	add    $0x8038b4,%eax
  800625:	8a 00                	mov    (%eax),%al
  800627:	0f be c0             	movsbl %al,%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 0c             	pushl  0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	ff d0                	call   *%eax
  800636:	83 c4 10             	add    $0x10,%esp
}
  800639:	90                   	nop
  80063a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80063d:	c9                   	leave  
  80063e:	c3                   	ret    

0080063f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80063f:	55                   	push   %ebp
  800640:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800642:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800646:	7e 1c                	jle    800664 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800648:	8b 45 08             	mov    0x8(%ebp),%eax
  80064b:	8b 00                	mov    (%eax),%eax
  80064d:	8d 50 08             	lea    0x8(%eax),%edx
  800650:	8b 45 08             	mov    0x8(%ebp),%eax
  800653:	89 10                	mov    %edx,(%eax)
  800655:	8b 45 08             	mov    0x8(%ebp),%eax
  800658:	8b 00                	mov    (%eax),%eax
  80065a:	83 e8 08             	sub    $0x8,%eax
  80065d:	8b 50 04             	mov    0x4(%eax),%edx
  800660:	8b 00                	mov    (%eax),%eax
  800662:	eb 40                	jmp    8006a4 <getuint+0x65>
	else if (lflag)
  800664:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800668:	74 1e                	je     800688 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80066a:	8b 45 08             	mov    0x8(%ebp),%eax
  80066d:	8b 00                	mov    (%eax),%eax
  80066f:	8d 50 04             	lea    0x4(%eax),%edx
  800672:	8b 45 08             	mov    0x8(%ebp),%eax
  800675:	89 10                	mov    %edx,(%eax)
  800677:	8b 45 08             	mov    0x8(%ebp),%eax
  80067a:	8b 00                	mov    (%eax),%eax
  80067c:	83 e8 04             	sub    $0x4,%eax
  80067f:	8b 00                	mov    (%eax),%eax
  800681:	ba 00 00 00 00       	mov    $0x0,%edx
  800686:	eb 1c                	jmp    8006a4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800688:	8b 45 08             	mov    0x8(%ebp),%eax
  80068b:	8b 00                	mov    (%eax),%eax
  80068d:	8d 50 04             	lea    0x4(%eax),%edx
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	89 10                	mov    %edx,(%eax)
  800695:	8b 45 08             	mov    0x8(%ebp),%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	83 e8 04             	sub    $0x4,%eax
  80069d:	8b 00                	mov    (%eax),%eax
  80069f:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006a4:	5d                   	pop    %ebp
  8006a5:	c3                   	ret    

008006a6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a6:	55                   	push   %ebp
  8006a7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ad:	7e 1c                	jle    8006cb <getint+0x25>
		return va_arg(*ap, long long);
  8006af:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b2:	8b 00                	mov    (%eax),%eax
  8006b4:	8d 50 08             	lea    0x8(%eax),%edx
  8006b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ba:	89 10                	mov    %edx,(%eax)
  8006bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006bf:	8b 00                	mov    (%eax),%eax
  8006c1:	83 e8 08             	sub    $0x8,%eax
  8006c4:	8b 50 04             	mov    0x4(%eax),%edx
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	eb 38                	jmp    800703 <getint+0x5d>
	else if (lflag)
  8006cb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006cf:	74 1a                	je     8006eb <getint+0x45>
		return va_arg(*ap, long);
  8006d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d4:	8b 00                	mov    (%eax),%eax
  8006d6:	8d 50 04             	lea    0x4(%eax),%edx
  8006d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006dc:	89 10                	mov    %edx,(%eax)
  8006de:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e1:	8b 00                	mov    (%eax),%eax
  8006e3:	83 e8 04             	sub    $0x4,%eax
  8006e6:	8b 00                	mov    (%eax),%eax
  8006e8:	99                   	cltd   
  8006e9:	eb 18                	jmp    800703 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	8b 00                	mov    (%eax),%eax
  8006f0:	8d 50 04             	lea    0x4(%eax),%edx
  8006f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f6:	89 10                	mov    %edx,(%eax)
  8006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fb:	8b 00                	mov    (%eax),%eax
  8006fd:	83 e8 04             	sub    $0x4,%eax
  800700:	8b 00                	mov    (%eax),%eax
  800702:	99                   	cltd   
}
  800703:	5d                   	pop    %ebp
  800704:	c3                   	ret    

00800705 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800705:	55                   	push   %ebp
  800706:	89 e5                	mov    %esp,%ebp
  800708:	56                   	push   %esi
  800709:	53                   	push   %ebx
  80070a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070d:	eb 17                	jmp    800726 <vprintfmt+0x21>
			if (ch == '\0')
  80070f:	85 db                	test   %ebx,%ebx
  800711:	0f 84 af 03 00 00    	je     800ac6 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800717:	83 ec 08             	sub    $0x8,%esp
  80071a:	ff 75 0c             	pushl  0xc(%ebp)
  80071d:	53                   	push   %ebx
  80071e:	8b 45 08             	mov    0x8(%ebp),%eax
  800721:	ff d0                	call   *%eax
  800723:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	8b 45 10             	mov    0x10(%ebp),%eax
  800729:	8d 50 01             	lea    0x1(%eax),%edx
  80072c:	89 55 10             	mov    %edx,0x10(%ebp)
  80072f:	8a 00                	mov    (%eax),%al
  800731:	0f b6 d8             	movzbl %al,%ebx
  800734:	83 fb 25             	cmp    $0x25,%ebx
  800737:	75 d6                	jne    80070f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800739:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80073d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800744:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80074b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800752:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800759:	8b 45 10             	mov    0x10(%ebp),%eax
  80075c:	8d 50 01             	lea    0x1(%eax),%edx
  80075f:	89 55 10             	mov    %edx,0x10(%ebp)
  800762:	8a 00                	mov    (%eax),%al
  800764:	0f b6 d8             	movzbl %al,%ebx
  800767:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80076a:	83 f8 55             	cmp    $0x55,%eax
  80076d:	0f 87 2b 03 00 00    	ja     800a9e <vprintfmt+0x399>
  800773:	8b 04 85 d8 38 80 00 	mov    0x8038d8(,%eax,4),%eax
  80077a:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80077c:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800780:	eb d7                	jmp    800759 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800782:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800786:	eb d1                	jmp    800759 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800788:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80078f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800792:	89 d0                	mov    %edx,%eax
  800794:	c1 e0 02             	shl    $0x2,%eax
  800797:	01 d0                	add    %edx,%eax
  800799:	01 c0                	add    %eax,%eax
  80079b:	01 d8                	add    %ebx,%eax
  80079d:	83 e8 30             	sub    $0x30,%eax
  8007a0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a6:	8a 00                	mov    (%eax),%al
  8007a8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ab:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ae:	7e 3e                	jle    8007ee <vprintfmt+0xe9>
  8007b0:	83 fb 39             	cmp    $0x39,%ebx
  8007b3:	7f 39                	jg     8007ee <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007b5:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b8:	eb d5                	jmp    80078f <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8007bd:	83 c0 04             	add    $0x4,%eax
  8007c0:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c6:	83 e8 04             	sub    $0x4,%eax
  8007c9:	8b 00                	mov    (%eax),%eax
  8007cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007ce:	eb 1f                	jmp    8007ef <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007d0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d4:	79 83                	jns    800759 <vprintfmt+0x54>
				width = 0;
  8007d6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007dd:	e9 77 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007e2:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e9:	e9 6b ff ff ff       	jmp    800759 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007ee:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007ef:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f3:	0f 89 60 ff ff ff    	jns    800759 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007fc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007ff:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800806:	e9 4e ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80080b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80080e:	e9 46 ff ff ff       	jmp    800759 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800813:	8b 45 14             	mov    0x14(%ebp),%eax
  800816:	83 c0 04             	add    $0x4,%eax
  800819:	89 45 14             	mov    %eax,0x14(%ebp)
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 e8 04             	sub    $0x4,%eax
  800822:	8b 00                	mov    (%eax),%eax
  800824:	83 ec 08             	sub    $0x8,%esp
  800827:	ff 75 0c             	pushl  0xc(%ebp)
  80082a:	50                   	push   %eax
  80082b:	8b 45 08             	mov    0x8(%ebp),%eax
  80082e:	ff d0                	call   *%eax
  800830:	83 c4 10             	add    $0x10,%esp
			break;
  800833:	e9 89 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800838:	8b 45 14             	mov    0x14(%ebp),%eax
  80083b:	83 c0 04             	add    $0x4,%eax
  80083e:	89 45 14             	mov    %eax,0x14(%ebp)
  800841:	8b 45 14             	mov    0x14(%ebp),%eax
  800844:	83 e8 04             	sub    $0x4,%eax
  800847:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800849:	85 db                	test   %ebx,%ebx
  80084b:	79 02                	jns    80084f <vprintfmt+0x14a>
				err = -err;
  80084d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80084f:	83 fb 64             	cmp    $0x64,%ebx
  800852:	7f 0b                	jg     80085f <vprintfmt+0x15a>
  800854:	8b 34 9d 20 37 80 00 	mov    0x803720(,%ebx,4),%esi
  80085b:	85 f6                	test   %esi,%esi
  80085d:	75 19                	jne    800878 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80085f:	53                   	push   %ebx
  800860:	68 c5 38 80 00       	push   $0x8038c5
  800865:	ff 75 0c             	pushl  0xc(%ebp)
  800868:	ff 75 08             	pushl  0x8(%ebp)
  80086b:	e8 5e 02 00 00       	call   800ace <printfmt>
  800870:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800873:	e9 49 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800878:	56                   	push   %esi
  800879:	68 ce 38 80 00       	push   $0x8038ce
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 45 02 00 00       	call   800ace <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			break;
  80088c:	e9 30 02 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800891:	8b 45 14             	mov    0x14(%ebp),%eax
  800894:	83 c0 04             	add    $0x4,%eax
  800897:	89 45 14             	mov    %eax,0x14(%ebp)
  80089a:	8b 45 14             	mov    0x14(%ebp),%eax
  80089d:	83 e8 04             	sub    $0x4,%eax
  8008a0:	8b 30                	mov    (%eax),%esi
  8008a2:	85 f6                	test   %esi,%esi
  8008a4:	75 05                	jne    8008ab <vprintfmt+0x1a6>
				p = "(null)";
  8008a6:	be d1 38 80 00       	mov    $0x8038d1,%esi
			if (width > 0 && padc != '-')
  8008ab:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008af:	7e 6d                	jle    80091e <vprintfmt+0x219>
  8008b1:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008b5:	74 67                	je     80091e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	56                   	push   %esi
  8008bf:	e8 0c 03 00 00       	call   800bd0 <strnlen>
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ca:	eb 16                	jmp    8008e2 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008cc:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008d0:	83 ec 08             	sub    $0x8,%esp
  8008d3:	ff 75 0c             	pushl  0xc(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008da:	ff d0                	call   *%eax
  8008dc:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008df:	ff 4d e4             	decl   -0x1c(%ebp)
  8008e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e6:	7f e4                	jg     8008cc <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e8:	eb 34                	jmp    80091e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ea:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008ee:	74 1c                	je     80090c <vprintfmt+0x207>
  8008f0:	83 fb 1f             	cmp    $0x1f,%ebx
  8008f3:	7e 05                	jle    8008fa <vprintfmt+0x1f5>
  8008f5:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f8:	7e 12                	jle    80090c <vprintfmt+0x207>
					putch('?', putdat);
  8008fa:	83 ec 08             	sub    $0x8,%esp
  8008fd:	ff 75 0c             	pushl  0xc(%ebp)
  800900:	6a 3f                	push   $0x3f
  800902:	8b 45 08             	mov    0x8(%ebp),%eax
  800905:	ff d0                	call   *%eax
  800907:	83 c4 10             	add    $0x10,%esp
  80090a:	eb 0f                	jmp    80091b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80090c:	83 ec 08             	sub    $0x8,%esp
  80090f:	ff 75 0c             	pushl  0xc(%ebp)
  800912:	53                   	push   %ebx
  800913:	8b 45 08             	mov    0x8(%ebp),%eax
  800916:	ff d0                	call   *%eax
  800918:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80091b:	ff 4d e4             	decl   -0x1c(%ebp)
  80091e:	89 f0                	mov    %esi,%eax
  800920:	8d 70 01             	lea    0x1(%eax),%esi
  800923:	8a 00                	mov    (%eax),%al
  800925:	0f be d8             	movsbl %al,%ebx
  800928:	85 db                	test   %ebx,%ebx
  80092a:	74 24                	je     800950 <vprintfmt+0x24b>
  80092c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800930:	78 b8                	js     8008ea <vprintfmt+0x1e5>
  800932:	ff 4d e0             	decl   -0x20(%ebp)
  800935:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800939:	79 af                	jns    8008ea <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80093b:	eb 13                	jmp    800950 <vprintfmt+0x24b>
				putch(' ', putdat);
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	6a 20                	push   $0x20
  800945:	8b 45 08             	mov    0x8(%ebp),%eax
  800948:	ff d0                	call   *%eax
  80094a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80094d:	ff 4d e4             	decl   -0x1c(%ebp)
  800950:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800954:	7f e7                	jg     80093d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800956:	e9 66 01 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80095b:	83 ec 08             	sub    $0x8,%esp
  80095e:	ff 75 e8             	pushl  -0x18(%ebp)
  800961:	8d 45 14             	lea    0x14(%ebp),%eax
  800964:	50                   	push   %eax
  800965:	e8 3c fd ff ff       	call   8006a6 <getint>
  80096a:	83 c4 10             	add    $0x10,%esp
  80096d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800970:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800973:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800976:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800979:	85 d2                	test   %edx,%edx
  80097b:	79 23                	jns    8009a0 <vprintfmt+0x29b>
				putch('-', putdat);
  80097d:	83 ec 08             	sub    $0x8,%esp
  800980:	ff 75 0c             	pushl  0xc(%ebp)
  800983:	6a 2d                	push   $0x2d
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  80098d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800990:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800993:	f7 d8                	neg    %eax
  800995:	83 d2 00             	adc    $0x0,%edx
  800998:	f7 da                	neg    %edx
  80099a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80099d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009a0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a7:	e9 bc 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009ac:	83 ec 08             	sub    $0x8,%esp
  8009af:	ff 75 e8             	pushl  -0x18(%ebp)
  8009b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8009b5:	50                   	push   %eax
  8009b6:	e8 84 fc ff ff       	call   80063f <getuint>
  8009bb:	83 c4 10             	add    $0x10,%esp
  8009be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009c4:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009cb:	e9 98 00 00 00       	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009d0:	83 ec 08             	sub    $0x8,%esp
  8009d3:	ff 75 0c             	pushl  0xc(%ebp)
  8009d6:	6a 58                	push   $0x58
  8009d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009db:	ff d0                	call   *%eax
  8009dd:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	ff 75 0c             	pushl  0xc(%ebp)
  8009e6:	6a 58                	push   $0x58
  8009e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009eb:	ff d0                	call   *%eax
  8009ed:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 0c             	pushl  0xc(%ebp)
  8009f6:	6a 58                	push   $0x58
  8009f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fb:	ff d0                	call   *%eax
  8009fd:	83 c4 10             	add    $0x10,%esp
			break;
  800a00:	e9 bc 00 00 00       	jmp    800ac1 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a05:	83 ec 08             	sub    $0x8,%esp
  800a08:	ff 75 0c             	pushl  0xc(%ebp)
  800a0b:	6a 30                	push   $0x30
  800a0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a10:	ff d0                	call   *%eax
  800a12:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a15:	83 ec 08             	sub    $0x8,%esp
  800a18:	ff 75 0c             	pushl  0xc(%ebp)
  800a1b:	6a 78                	push   $0x78
  800a1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800a20:	ff d0                	call   *%eax
  800a22:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a25:	8b 45 14             	mov    0x14(%ebp),%eax
  800a28:	83 c0 04             	add    $0x4,%eax
  800a2b:	89 45 14             	mov    %eax,0x14(%ebp)
  800a2e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a31:	83 e8 04             	sub    $0x4,%eax
  800a34:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a36:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a39:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a40:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a47:	eb 1f                	jmp    800a68 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a49:	83 ec 08             	sub    $0x8,%esp
  800a4c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a4f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a52:	50                   	push   %eax
  800a53:	e8 e7 fb ff ff       	call   80063f <getuint>
  800a58:	83 c4 10             	add    $0x10,%esp
  800a5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a61:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a68:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a6f:	83 ec 04             	sub    $0x4,%esp
  800a72:	52                   	push   %edx
  800a73:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a76:	50                   	push   %eax
  800a77:	ff 75 f4             	pushl  -0xc(%ebp)
  800a7a:	ff 75 f0             	pushl  -0x10(%ebp)
  800a7d:	ff 75 0c             	pushl  0xc(%ebp)
  800a80:	ff 75 08             	pushl  0x8(%ebp)
  800a83:	e8 00 fb ff ff       	call   800588 <printnum>
  800a88:	83 c4 20             	add    $0x20,%esp
			break;
  800a8b:	eb 34                	jmp    800ac1 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a8d:	83 ec 08             	sub    $0x8,%esp
  800a90:	ff 75 0c             	pushl  0xc(%ebp)
  800a93:	53                   	push   %ebx
  800a94:	8b 45 08             	mov    0x8(%ebp),%eax
  800a97:	ff d0                	call   *%eax
  800a99:	83 c4 10             	add    $0x10,%esp
			break;
  800a9c:	eb 23                	jmp    800ac1 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 25                	push   $0x25
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aae:	ff 4d 10             	decl   0x10(%ebp)
  800ab1:	eb 03                	jmp    800ab6 <vprintfmt+0x3b1>
  800ab3:	ff 4d 10             	decl   0x10(%ebp)
  800ab6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab9:	48                   	dec    %eax
  800aba:	8a 00                	mov    (%eax),%al
  800abc:	3c 25                	cmp    $0x25,%al
  800abe:	75 f3                	jne    800ab3 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ac0:	90                   	nop
		}
	}
  800ac1:	e9 47 fc ff ff       	jmp    80070d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac6:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aca:	5b                   	pop    %ebx
  800acb:	5e                   	pop    %esi
  800acc:	5d                   	pop    %ebp
  800acd:	c3                   	ret    

00800ace <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ace:	55                   	push   %ebp
  800acf:	89 e5                	mov    %esp,%ebp
  800ad1:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ad4:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad7:	83 c0 04             	add    $0x4,%eax
  800ada:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800add:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae0:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae3:	50                   	push   %eax
  800ae4:	ff 75 0c             	pushl  0xc(%ebp)
  800ae7:	ff 75 08             	pushl  0x8(%ebp)
  800aea:	e8 16 fc ff ff       	call   800705 <vprintfmt>
  800aef:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800af2:	90                   	nop
  800af3:	c9                   	leave  
  800af4:	c3                   	ret    

00800af5 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800af5:	55                   	push   %ebp
  800af6:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afb:	8b 40 08             	mov    0x8(%eax),%eax
  800afe:	8d 50 01             	lea    0x1(%eax),%edx
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0a:	8b 10                	mov    (%eax),%edx
  800b0c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b0f:	8b 40 04             	mov    0x4(%eax),%eax
  800b12:	39 c2                	cmp    %eax,%edx
  800b14:	73 12                	jae    800b28 <sprintputch+0x33>
		*b->buf++ = ch;
  800b16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b19:	8b 00                	mov    (%eax),%eax
  800b1b:	8d 48 01             	lea    0x1(%eax),%ecx
  800b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b21:	89 0a                	mov    %ecx,(%edx)
  800b23:	8b 55 08             	mov    0x8(%ebp),%edx
  800b26:	88 10                	mov    %dl,(%eax)
}
  800b28:	90                   	nop
  800b29:	5d                   	pop    %ebp
  800b2a:	c3                   	ret    

00800b2b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b50:	74 06                	je     800b58 <vsnprintf+0x2d>
  800b52:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b56:	7f 07                	jg     800b5f <vsnprintf+0x34>
		return -E_INVAL;
  800b58:	b8 03 00 00 00       	mov    $0x3,%eax
  800b5d:	eb 20                	jmp    800b7f <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b5f:	ff 75 14             	pushl  0x14(%ebp)
  800b62:	ff 75 10             	pushl  0x10(%ebp)
  800b65:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b68:	50                   	push   %eax
  800b69:	68 f5 0a 80 00       	push   $0x800af5
  800b6e:	e8 92 fb ff ff       	call   800705 <vprintfmt>
  800b73:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b79:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b7f:	c9                   	leave  
  800b80:	c3                   	ret    

00800b81 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b81:	55                   	push   %ebp
  800b82:	89 e5                	mov    %esp,%ebp
  800b84:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b87:	8d 45 10             	lea    0x10(%ebp),%eax
  800b8a:	83 c0 04             	add    $0x4,%eax
  800b8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b90:	8b 45 10             	mov    0x10(%ebp),%eax
  800b93:	ff 75 f4             	pushl  -0xc(%ebp)
  800b96:	50                   	push   %eax
  800b97:	ff 75 0c             	pushl  0xc(%ebp)
  800b9a:	ff 75 08             	pushl  0x8(%ebp)
  800b9d:	e8 89 ff ff ff       	call   800b2b <vsnprintf>
  800ba2:	83 c4 10             	add    $0x10,%esp
  800ba5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bab:	c9                   	leave  
  800bac:	c3                   	ret    

00800bad <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bad:	55                   	push   %ebp
  800bae:	89 e5                	mov    %esp,%ebp
  800bb0:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bba:	eb 06                	jmp    800bc2 <strlen+0x15>
		n++;
  800bbc:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bbf:	ff 45 08             	incl   0x8(%ebp)
  800bc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc5:	8a 00                	mov    (%eax),%al
  800bc7:	84 c0                	test   %al,%al
  800bc9:	75 f1                	jne    800bbc <strlen+0xf>
		n++;
	return n;
  800bcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bce:	c9                   	leave  
  800bcf:	c3                   	ret    

00800bd0 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bd0:	55                   	push   %ebp
  800bd1:	89 e5                	mov    %esp,%ebp
  800bd3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bdd:	eb 09                	jmp    800be8 <strnlen+0x18>
		n++;
  800bdf:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800be2:	ff 45 08             	incl   0x8(%ebp)
  800be5:	ff 4d 0c             	decl   0xc(%ebp)
  800be8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bec:	74 09                	je     800bf7 <strnlen+0x27>
  800bee:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf1:	8a 00                	mov    (%eax),%al
  800bf3:	84 c0                	test   %al,%al
  800bf5:	75 e8                	jne    800bdf <strnlen+0xf>
		n++;
	return n;
  800bf7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bfa:	c9                   	leave  
  800bfb:	c3                   	ret    

00800bfc <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bfc:	55                   	push   %ebp
  800bfd:	89 e5                	mov    %esp,%ebp
  800bff:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c02:	8b 45 08             	mov    0x8(%ebp),%eax
  800c05:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c08:	90                   	nop
  800c09:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0c:	8d 50 01             	lea    0x1(%eax),%edx
  800c0f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c12:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c15:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c18:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c1b:	8a 12                	mov    (%edx),%dl
  800c1d:	88 10                	mov    %dl,(%eax)
  800c1f:	8a 00                	mov    (%eax),%al
  800c21:	84 c0                	test   %al,%al
  800c23:	75 e4                	jne    800c09 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c28:	c9                   	leave  
  800c29:	c3                   	ret    

00800c2a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c2a:	55                   	push   %ebp
  800c2b:	89 e5                	mov    %esp,%ebp
  800c2d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c36:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c3d:	eb 1f                	jmp    800c5e <strncpy+0x34>
		*dst++ = *src;
  800c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c42:	8d 50 01             	lea    0x1(%eax),%edx
  800c45:	89 55 08             	mov    %edx,0x8(%ebp)
  800c48:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c4b:	8a 12                	mov    (%edx),%dl
  800c4d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c52:	8a 00                	mov    (%eax),%al
  800c54:	84 c0                	test   %al,%al
  800c56:	74 03                	je     800c5b <strncpy+0x31>
			src++;
  800c58:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c5b:	ff 45 fc             	incl   -0x4(%ebp)
  800c5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c61:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c64:	72 d9                	jb     800c3f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c66:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c77:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c7b:	74 30                	je     800cad <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c7d:	eb 16                	jmp    800c95 <strlcpy+0x2a>
			*dst++ = *src++;
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	8d 50 01             	lea    0x1(%eax),%edx
  800c85:	89 55 08             	mov    %edx,0x8(%ebp)
  800c88:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c91:	8a 12                	mov    (%edx),%dl
  800c93:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c95:	ff 4d 10             	decl   0x10(%ebp)
  800c98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c9c:	74 09                	je     800ca7 <strlcpy+0x3c>
  800c9e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca1:	8a 00                	mov    (%eax),%al
  800ca3:	84 c0                	test   %al,%al
  800ca5:	75 d8                	jne    800c7f <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  800caa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cad:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cb3:	29 c2                	sub    %eax,%edx
  800cb5:	89 d0                	mov    %edx,%eax
}
  800cb7:	c9                   	leave  
  800cb8:	c3                   	ret    

00800cb9 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb9:	55                   	push   %ebp
  800cba:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cbc:	eb 06                	jmp    800cc4 <strcmp+0xb>
		p++, q++;
  800cbe:	ff 45 08             	incl   0x8(%ebp)
  800cc1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	8a 00                	mov    (%eax),%al
  800cc9:	84 c0                	test   %al,%al
  800ccb:	74 0e                	je     800cdb <strcmp+0x22>
  800ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd0:	8a 10                	mov    (%eax),%dl
  800cd2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd5:	8a 00                	mov    (%eax),%al
  800cd7:	38 c2                	cmp    %al,%dl
  800cd9:	74 e3                	je     800cbe <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	0f b6 d0             	movzbl %al,%edx
  800ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce6:	8a 00                	mov    (%eax),%al
  800ce8:	0f b6 c0             	movzbl %al,%eax
  800ceb:	29 c2                	sub    %eax,%edx
  800ced:	89 d0                	mov    %edx,%eax
}
  800cef:	5d                   	pop    %ebp
  800cf0:	c3                   	ret    

00800cf1 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cf1:	55                   	push   %ebp
  800cf2:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cf4:	eb 09                	jmp    800cff <strncmp+0xe>
		n--, p++, q++;
  800cf6:	ff 4d 10             	decl   0x10(%ebp)
  800cf9:	ff 45 08             	incl   0x8(%ebp)
  800cfc:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cff:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d03:	74 17                	je     800d1c <strncmp+0x2b>
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	8a 00                	mov    (%eax),%al
  800d0a:	84 c0                	test   %al,%al
  800d0c:	74 0e                	je     800d1c <strncmp+0x2b>
  800d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d11:	8a 10                	mov    (%eax),%dl
  800d13:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d16:	8a 00                	mov    (%eax),%al
  800d18:	38 c2                	cmp    %al,%dl
  800d1a:	74 da                	je     800cf6 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d20:	75 07                	jne    800d29 <strncmp+0x38>
		return 0;
  800d22:	b8 00 00 00 00       	mov    $0x0,%eax
  800d27:	eb 14                	jmp    800d3d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d29:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2c:	8a 00                	mov    (%eax),%al
  800d2e:	0f b6 d0             	movzbl %al,%edx
  800d31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	0f b6 c0             	movzbl %al,%eax
  800d39:	29 c2                	sub    %eax,%edx
  800d3b:	89 d0                	mov    %edx,%eax
}
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 04             	sub    $0x4,%esp
  800d45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d48:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d4b:	eb 12                	jmp    800d5f <strchr+0x20>
		if (*s == c)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d55:	75 05                	jne    800d5c <strchr+0x1d>
			return (char *) s;
  800d57:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5a:	eb 11                	jmp    800d6d <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d5c:	ff 45 08             	incl   0x8(%ebp)
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	8a 00                	mov    (%eax),%al
  800d64:	84 c0                	test   %al,%al
  800d66:	75 e5                	jne    800d4d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d68:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6d:	c9                   	leave  
  800d6e:	c3                   	ret    

00800d6f <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d6f:	55                   	push   %ebp
  800d70:	89 e5                	mov    %esp,%ebp
  800d72:	83 ec 04             	sub    $0x4,%esp
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d7b:	eb 0d                	jmp    800d8a <strfind+0x1b>
		if (*s == c)
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	8a 00                	mov    (%eax),%al
  800d82:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d85:	74 0e                	je     800d95 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d87:	ff 45 08             	incl   0x8(%ebp)
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	84 c0                	test   %al,%al
  800d91:	75 ea                	jne    800d7d <strfind+0xe>
  800d93:	eb 01                	jmp    800d96 <strfind+0x27>
		if (*s == c)
			break;
  800d95:	90                   	nop
	return (char *) s;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d99:	c9                   	leave  
  800d9a:	c3                   	ret    

00800d9b <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d9b:	55                   	push   %ebp
  800d9c:	89 e5                	mov    %esp,%ebp
  800d9e:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800da1:	8b 45 08             	mov    0x8(%ebp),%eax
  800da4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da7:	8b 45 10             	mov    0x10(%ebp),%eax
  800daa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dad:	eb 0e                	jmp    800dbd <memset+0x22>
		*p++ = c;
  800daf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800db2:	8d 50 01             	lea    0x1(%eax),%edx
  800db5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbb:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dbd:	ff 4d f8             	decl   -0x8(%ebp)
  800dc0:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dc4:	79 e9                	jns    800daf <memset+0x14>
		*p++ = c;

	return v;
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc9:	c9                   	leave  
  800dca:	c3                   	ret    

00800dcb <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dcb:	55                   	push   %ebp
  800dcc:	89 e5                	mov    %esp,%ebp
  800dce:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ddd:	eb 16                	jmp    800df5 <memcpy+0x2a>
		*d++ = *s++;
  800ddf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800de2:	8d 50 01             	lea    0x1(%eax),%edx
  800de5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800deb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dee:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800df1:	8a 12                	mov    (%edx),%dl
  800df3:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800df5:	8b 45 10             	mov    0x10(%ebp),%eax
  800df8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dfb:	89 55 10             	mov    %edx,0x10(%ebp)
  800dfe:	85 c0                	test   %eax,%eax
  800e00:	75 dd                	jne    800ddf <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e05:	c9                   	leave  
  800e06:	c3                   	ret    

00800e07 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e07:	55                   	push   %ebp
  800e08:	89 e5                	mov    %esp,%ebp
  800e0a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e19:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e1f:	73 50                	jae    800e71 <memmove+0x6a>
  800e21:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e24:	8b 45 10             	mov    0x10(%ebp),%eax
  800e27:	01 d0                	add    %edx,%eax
  800e29:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e2c:	76 43                	jbe    800e71 <memmove+0x6a>
		s += n;
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
  800e37:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e3a:	eb 10                	jmp    800e4c <memmove+0x45>
			*--d = *--s;
  800e3c:	ff 4d f8             	decl   -0x8(%ebp)
  800e3f:	ff 4d fc             	decl   -0x4(%ebp)
  800e42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e45:	8a 10                	mov    (%eax),%dl
  800e47:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e4a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e52:	89 55 10             	mov    %edx,0x10(%ebp)
  800e55:	85 c0                	test   %eax,%eax
  800e57:	75 e3                	jne    800e3c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e59:	eb 23                	jmp    800e7e <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e5b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e5e:	8d 50 01             	lea    0x1(%eax),%edx
  800e61:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e64:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e67:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e6a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e6d:	8a 12                	mov    (%edx),%dl
  800e6f:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e71:	8b 45 10             	mov    0x10(%ebp),%eax
  800e74:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e77:	89 55 10             	mov    %edx,0x10(%ebp)
  800e7a:	85 c0                	test   %eax,%eax
  800e7c:	75 dd                	jne    800e5b <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e81:	c9                   	leave  
  800e82:	c3                   	ret    

00800e83 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e83:	55                   	push   %ebp
  800e84:	89 e5                	mov    %esp,%ebp
  800e86:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e95:	eb 2a                	jmp    800ec1 <memcmp+0x3e>
		if (*s1 != *s2)
  800e97:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9a:	8a 10                	mov    (%eax),%dl
  800e9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9f:	8a 00                	mov    (%eax),%al
  800ea1:	38 c2                	cmp    %al,%dl
  800ea3:	74 16                	je     800ebb <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ea5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea8:	8a 00                	mov    (%eax),%al
  800eaa:	0f b6 d0             	movzbl %al,%edx
  800ead:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb0:	8a 00                	mov    (%eax),%al
  800eb2:	0f b6 c0             	movzbl %al,%eax
  800eb5:	29 c2                	sub    %eax,%edx
  800eb7:	89 d0                	mov    %edx,%eax
  800eb9:	eb 18                	jmp    800ed3 <memcmp+0x50>
		s1++, s2++;
  800ebb:	ff 45 fc             	incl   -0x4(%ebp)
  800ebe:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ec1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec7:	89 55 10             	mov    %edx,0x10(%ebp)
  800eca:	85 c0                	test   %eax,%eax
  800ecc:	75 c9                	jne    800e97 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ece:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ed3:	c9                   	leave  
  800ed4:	c3                   	ret    

00800ed5 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ed5:	55                   	push   %ebp
  800ed6:	89 e5                	mov    %esp,%ebp
  800ed8:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800edb:	8b 55 08             	mov    0x8(%ebp),%edx
  800ede:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee1:	01 d0                	add    %edx,%eax
  800ee3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee6:	eb 15                	jmp    800efd <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  800eeb:	8a 00                	mov    (%eax),%al
  800eed:	0f b6 d0             	movzbl %al,%edx
  800ef0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef3:	0f b6 c0             	movzbl %al,%eax
  800ef6:	39 c2                	cmp    %eax,%edx
  800ef8:	74 0d                	je     800f07 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800efa:	ff 45 08             	incl   0x8(%ebp)
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f03:	72 e3                	jb     800ee8 <memfind+0x13>
  800f05:	eb 01                	jmp    800f08 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f07:	90                   	nop
	return (void *) s;
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f13:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f1a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f21:	eb 03                	jmp    800f26 <strtol+0x19>
		s++;
  800f23:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8a 00                	mov    (%eax),%al
  800f2b:	3c 20                	cmp    $0x20,%al
  800f2d:	74 f4                	je     800f23 <strtol+0x16>
  800f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f32:	8a 00                	mov    (%eax),%al
  800f34:	3c 09                	cmp    $0x9,%al
  800f36:	74 eb                	je     800f23 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	8a 00                	mov    (%eax),%al
  800f3d:	3c 2b                	cmp    $0x2b,%al
  800f3f:	75 05                	jne    800f46 <strtol+0x39>
		s++;
  800f41:	ff 45 08             	incl   0x8(%ebp)
  800f44:	eb 13                	jmp    800f59 <strtol+0x4c>
	else if (*s == '-')
  800f46:	8b 45 08             	mov    0x8(%ebp),%eax
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	3c 2d                	cmp    $0x2d,%al
  800f4d:	75 0a                	jne    800f59 <strtol+0x4c>
		s++, neg = 1;
  800f4f:	ff 45 08             	incl   0x8(%ebp)
  800f52:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f59:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5d:	74 06                	je     800f65 <strtol+0x58>
  800f5f:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f63:	75 20                	jne    800f85 <strtol+0x78>
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 30                	cmp    $0x30,%al
  800f6c:	75 17                	jne    800f85 <strtol+0x78>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	40                   	inc    %eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 78                	cmp    $0x78,%al
  800f76:	75 0d                	jne    800f85 <strtol+0x78>
		s += 2, base = 16;
  800f78:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f7c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f83:	eb 28                	jmp    800fad <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f89:	75 15                	jne    800fa0 <strtol+0x93>
  800f8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8e:	8a 00                	mov    (%eax),%al
  800f90:	3c 30                	cmp    $0x30,%al
  800f92:	75 0c                	jne    800fa0 <strtol+0x93>
		s++, base = 8;
  800f94:	ff 45 08             	incl   0x8(%ebp)
  800f97:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f9e:	eb 0d                	jmp    800fad <strtol+0xa0>
	else if (base == 0)
  800fa0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa4:	75 07                	jne    800fad <strtol+0xa0>
		base = 10;
  800fa6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	8a 00                	mov    (%eax),%al
  800fb2:	3c 2f                	cmp    $0x2f,%al
  800fb4:	7e 19                	jle    800fcf <strtol+0xc2>
  800fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb9:	8a 00                	mov    (%eax),%al
  800fbb:	3c 39                	cmp    $0x39,%al
  800fbd:	7f 10                	jg     800fcf <strtol+0xc2>
			dig = *s - '0';
  800fbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc2:	8a 00                	mov    (%eax),%al
  800fc4:	0f be c0             	movsbl %al,%eax
  800fc7:	83 e8 30             	sub    $0x30,%eax
  800fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fcd:	eb 42                	jmp    801011 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 60                	cmp    $0x60,%al
  800fd6:	7e 19                	jle    800ff1 <strtol+0xe4>
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	3c 7a                	cmp    $0x7a,%al
  800fdf:	7f 10                	jg     800ff1 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	0f be c0             	movsbl %al,%eax
  800fe9:	83 e8 57             	sub    $0x57,%eax
  800fec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fef:	eb 20                	jmp    801011 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 40                	cmp    $0x40,%al
  800ff8:	7e 39                	jle    801033 <strtol+0x126>
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	3c 5a                	cmp    $0x5a,%al
  801001:	7f 30                	jg     801033 <strtol+0x126>
			dig = *s - 'A' + 10;
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	8a 00                	mov    (%eax),%al
  801008:	0f be c0             	movsbl %al,%eax
  80100b:	83 e8 37             	sub    $0x37,%eax
  80100e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801014:	3b 45 10             	cmp    0x10(%ebp),%eax
  801017:	7d 19                	jge    801032 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801019:	ff 45 08             	incl   0x8(%ebp)
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	0f af 45 10          	imul   0x10(%ebp),%eax
  801023:	89 c2                	mov    %eax,%edx
  801025:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801028:	01 d0                	add    %edx,%eax
  80102a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80102d:	e9 7b ff ff ff       	jmp    800fad <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801032:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801033:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801037:	74 08                	je     801041 <strtol+0x134>
		*endptr = (char *) s;
  801039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103c:	8b 55 08             	mov    0x8(%ebp),%edx
  80103f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801041:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801045:	74 07                	je     80104e <strtol+0x141>
  801047:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80104a:	f7 d8                	neg    %eax
  80104c:	eb 03                	jmp    801051 <strtol+0x144>
  80104e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801051:	c9                   	leave  
  801052:	c3                   	ret    

00801053 <ltostr>:

void
ltostr(long value, char *str)
{
  801053:	55                   	push   %ebp
  801054:	89 e5                	mov    %esp,%ebp
  801056:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801059:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801060:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801067:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80106b:	79 13                	jns    801080 <ltostr+0x2d>
	{
		neg = 1;
  80106d:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801074:	8b 45 0c             	mov    0xc(%ebp),%eax
  801077:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80107a:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80107d:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801080:	8b 45 08             	mov    0x8(%ebp),%eax
  801083:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801088:	99                   	cltd   
  801089:	f7 f9                	idiv   %ecx
  80108b:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	8d 50 01             	lea    0x1(%eax),%edx
  801094:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801097:	89 c2                	mov    %eax,%edx
  801099:	8b 45 0c             	mov    0xc(%ebp),%eax
  80109c:	01 d0                	add    %edx,%eax
  80109e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010a1:	83 c2 30             	add    $0x30,%edx
  8010a4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ae:	f7 e9                	imul   %ecx
  8010b0:	c1 fa 02             	sar    $0x2,%edx
  8010b3:	89 c8                	mov    %ecx,%eax
  8010b5:	c1 f8 1f             	sar    $0x1f,%eax
  8010b8:	29 c2                	sub    %eax,%edx
  8010ba:	89 d0                	mov    %edx,%eax
  8010bc:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c7:	f7 e9                	imul   %ecx
  8010c9:	c1 fa 02             	sar    $0x2,%edx
  8010cc:	89 c8                	mov    %ecx,%eax
  8010ce:	c1 f8 1f             	sar    $0x1f,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	c1 e0 02             	shl    $0x2,%eax
  8010d8:	01 d0                	add    %edx,%eax
  8010da:	01 c0                	add    %eax,%eax
  8010dc:	29 c1                	sub    %eax,%ecx
  8010de:	89 ca                	mov    %ecx,%edx
  8010e0:	85 d2                	test   %edx,%edx
  8010e2:	75 9c                	jne    801080 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010e4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010eb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ee:	48                   	dec    %eax
  8010ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010f2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f6:	74 3d                	je     801135 <ltostr+0xe2>
		start = 1 ;
  8010f8:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010ff:	eb 34                	jmp    801135 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801101:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801104:	8b 45 0c             	mov    0xc(%ebp),%eax
  801107:	01 d0                	add    %edx,%eax
  801109:	8a 00                	mov    (%eax),%al
  80110b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80110e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801111:	8b 45 0c             	mov    0xc(%ebp),%eax
  801114:	01 c2                	add    %eax,%edx
  801116:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801119:	8b 45 0c             	mov    0xc(%ebp),%eax
  80111c:	01 c8                	add    %ecx,%eax
  80111e:	8a 00                	mov    (%eax),%al
  801120:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801122:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801125:	8b 45 0c             	mov    0xc(%ebp),%eax
  801128:	01 c2                	add    %eax,%edx
  80112a:	8a 45 eb             	mov    -0x15(%ebp),%al
  80112d:	88 02                	mov    %al,(%edx)
		start++ ;
  80112f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801132:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801135:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801138:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80113b:	7c c4                	jl     801101 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80113d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801140:	8b 45 0c             	mov    0xc(%ebp),%eax
  801143:	01 d0                	add    %edx,%eax
  801145:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801148:	90                   	nop
  801149:	c9                   	leave  
  80114a:	c3                   	ret    

0080114b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80114b:	55                   	push   %ebp
  80114c:	89 e5                	mov    %esp,%ebp
  80114e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801151:	ff 75 08             	pushl  0x8(%ebp)
  801154:	e8 54 fa ff ff       	call   800bad <strlen>
  801159:	83 c4 04             	add    $0x4,%esp
  80115c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80115f:	ff 75 0c             	pushl  0xc(%ebp)
  801162:	e8 46 fa ff ff       	call   800bad <strlen>
  801167:	83 c4 04             	add    $0x4,%esp
  80116a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80116d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801174:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80117b:	eb 17                	jmp    801194 <strcconcat+0x49>
		final[s] = str1[s] ;
  80117d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801180:	8b 45 10             	mov    0x10(%ebp),%eax
  801183:	01 c2                	add    %eax,%edx
  801185:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801188:	8b 45 08             	mov    0x8(%ebp),%eax
  80118b:	01 c8                	add    %ecx,%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801191:	ff 45 fc             	incl   -0x4(%ebp)
  801194:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801197:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80119a:	7c e1                	jl     80117d <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80119c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011a3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011aa:	eb 1f                	jmp    8011cb <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011af:	8d 50 01             	lea    0x1(%eax),%edx
  8011b2:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011b5:	89 c2                	mov    %eax,%edx
  8011b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8011ba:	01 c2                	add    %eax,%edx
  8011bc:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 c8                	add    %ecx,%eax
  8011c4:	8a 00                	mov    (%eax),%al
  8011c6:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c8:	ff 45 f8             	incl   -0x8(%ebp)
  8011cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011d1:	7c d9                	jl     8011ac <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011d3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d9:	01 d0                	add    %edx,%eax
  8011db:	c6 00 00             	movb   $0x0,(%eax)
}
  8011de:	90                   	nop
  8011df:	c9                   	leave  
  8011e0:	c3                   	ret    

008011e1 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011e1:	55                   	push   %ebp
  8011e2:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011e4:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8011f0:	8b 00                	mov    (%eax),%eax
  8011f2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8011fc:	01 d0                	add    %edx,%eax
  8011fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801204:	eb 0c                	jmp    801212 <strsplit+0x31>
			*string++ = 0;
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8d 50 01             	lea    0x1(%eax),%edx
  80120c:	89 55 08             	mov    %edx,0x8(%ebp)
  80120f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801212:	8b 45 08             	mov    0x8(%ebp),%eax
  801215:	8a 00                	mov    (%eax),%al
  801217:	84 c0                	test   %al,%al
  801219:	74 18                	je     801233 <strsplit+0x52>
  80121b:	8b 45 08             	mov    0x8(%ebp),%eax
  80121e:	8a 00                	mov    (%eax),%al
  801220:	0f be c0             	movsbl %al,%eax
  801223:	50                   	push   %eax
  801224:	ff 75 0c             	pushl  0xc(%ebp)
  801227:	e8 13 fb ff ff       	call   800d3f <strchr>
  80122c:	83 c4 08             	add    $0x8,%esp
  80122f:	85 c0                	test   %eax,%eax
  801231:	75 d3                	jne    801206 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801233:	8b 45 08             	mov    0x8(%ebp),%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	84 c0                	test   %al,%al
  80123a:	74 5a                	je     801296 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80123c:	8b 45 14             	mov    0x14(%ebp),%eax
  80123f:	8b 00                	mov    (%eax),%eax
  801241:	83 f8 0f             	cmp    $0xf,%eax
  801244:	75 07                	jne    80124d <strsplit+0x6c>
		{
			return 0;
  801246:	b8 00 00 00 00       	mov    $0x0,%eax
  80124b:	eb 66                	jmp    8012b3 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80124d:	8b 45 14             	mov    0x14(%ebp),%eax
  801250:	8b 00                	mov    (%eax),%eax
  801252:	8d 48 01             	lea    0x1(%eax),%ecx
  801255:	8b 55 14             	mov    0x14(%ebp),%edx
  801258:	89 0a                	mov    %ecx,(%edx)
  80125a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801261:	8b 45 10             	mov    0x10(%ebp),%eax
  801264:	01 c2                	add    %eax,%edx
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126b:	eb 03                	jmp    801270 <strsplit+0x8f>
			string++;
  80126d:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801270:	8b 45 08             	mov    0x8(%ebp),%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	84 c0                	test   %al,%al
  801277:	74 8b                	je     801204 <strsplit+0x23>
  801279:	8b 45 08             	mov    0x8(%ebp),%eax
  80127c:	8a 00                	mov    (%eax),%al
  80127e:	0f be c0             	movsbl %al,%eax
  801281:	50                   	push   %eax
  801282:	ff 75 0c             	pushl  0xc(%ebp)
  801285:	e8 b5 fa ff ff       	call   800d3f <strchr>
  80128a:	83 c4 08             	add    $0x8,%esp
  80128d:	85 c0                	test   %eax,%eax
  80128f:	74 dc                	je     80126d <strsplit+0x8c>
			string++;
	}
  801291:	e9 6e ff ff ff       	jmp    801204 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801296:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801297:	8b 45 14             	mov    0x14(%ebp),%eax
  80129a:	8b 00                	mov    (%eax),%eax
  80129c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a6:	01 d0                	add    %edx,%eax
  8012a8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ae:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012b3:	c9                   	leave  
  8012b4:	c3                   	ret    

008012b5 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012b5:	55                   	push   %ebp
  8012b6:	89 e5                	mov    %esp,%ebp
  8012b8:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012bb:	a1 04 40 80 00       	mov    0x804004,%eax
  8012c0:	85 c0                	test   %eax,%eax
  8012c2:	74 1f                	je     8012e3 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012c4:	e8 1d 00 00 00       	call   8012e6 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012c9:	83 ec 0c             	sub    $0xc,%esp
  8012cc:	68 30 3a 80 00       	push   $0x803a30
  8012d1:	e8 55 f2 ff ff       	call   80052b <cprintf>
  8012d6:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012d9:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012e0:	00 00 00 
	}
}
  8012e3:	90                   	nop
  8012e4:	c9                   	leave  
  8012e5:	c3                   	ret    

008012e6 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012e6:	55                   	push   %ebp
  8012e7:	89 e5                	mov    %esp,%ebp
  8012e9:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  8012ec:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012f3:	00 00 00 
  8012f6:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8012fd:	00 00 00 
  801300:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801307:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80130a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801311:	00 00 00 
  801314:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80131b:	00 00 00 
  80131e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801325:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801328:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  80132f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801332:	c1 e8 0c             	shr    $0xc,%eax
  801335:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  80133a:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801341:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801344:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801349:	2d 00 10 00 00       	sub    $0x1000,%eax
  80134e:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  801353:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  80135a:	a1 20 41 80 00       	mov    0x804120,%eax
  80135f:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801363:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801366:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80136d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801370:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801373:	01 d0                	add    %edx,%eax
  801375:	48                   	dec    %eax
  801376:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801379:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80137c:	ba 00 00 00 00       	mov    $0x0,%edx
  801381:	f7 75 e4             	divl   -0x1c(%ebp)
  801384:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801387:	29 d0                	sub    %edx,%eax
  801389:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  80138c:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801393:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801396:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80139b:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013a0:	83 ec 04             	sub    $0x4,%esp
  8013a3:	6a 07                	push   $0x7
  8013a5:	ff 75 e8             	pushl  -0x18(%ebp)
  8013a8:	50                   	push   %eax
  8013a9:	e8 3d 06 00 00       	call   8019eb <sys_allocate_chunk>
  8013ae:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013b1:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b6:	83 ec 0c             	sub    $0xc,%esp
  8013b9:	50                   	push   %eax
  8013ba:	e8 b2 0c 00 00       	call   802071 <initialize_MemBlocksList>
  8013bf:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8013c2:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013c7:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8013ca:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013ce:	0f 84 f3 00 00 00    	je     8014c7 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8013d4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013d8:	75 14                	jne    8013ee <initialize_dyn_block_system+0x108>
  8013da:	83 ec 04             	sub    $0x4,%esp
  8013dd:	68 55 3a 80 00       	push   $0x803a55
  8013e2:	6a 36                	push   $0x36
  8013e4:	68 73 3a 80 00       	push   $0x803a73
  8013e9:	e8 89 ee ff ff       	call   800277 <_panic>
  8013ee:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013f1:	8b 00                	mov    (%eax),%eax
  8013f3:	85 c0                	test   %eax,%eax
  8013f5:	74 10                	je     801407 <initialize_dyn_block_system+0x121>
  8013f7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013fa:	8b 00                	mov    (%eax),%eax
  8013fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8013ff:	8b 52 04             	mov    0x4(%edx),%edx
  801402:	89 50 04             	mov    %edx,0x4(%eax)
  801405:	eb 0b                	jmp    801412 <initialize_dyn_block_system+0x12c>
  801407:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80140a:	8b 40 04             	mov    0x4(%eax),%eax
  80140d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801412:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801415:	8b 40 04             	mov    0x4(%eax),%eax
  801418:	85 c0                	test   %eax,%eax
  80141a:	74 0f                	je     80142b <initialize_dyn_block_system+0x145>
  80141c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80141f:	8b 40 04             	mov    0x4(%eax),%eax
  801422:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801425:	8b 12                	mov    (%edx),%edx
  801427:	89 10                	mov    %edx,(%eax)
  801429:	eb 0a                	jmp    801435 <initialize_dyn_block_system+0x14f>
  80142b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80142e:	8b 00                	mov    (%eax),%eax
  801430:	a3 48 41 80 00       	mov    %eax,0x804148
  801435:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801438:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80143e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801441:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801448:	a1 54 41 80 00       	mov    0x804154,%eax
  80144d:	48                   	dec    %eax
  80144e:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801453:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801456:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  80145d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801460:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801467:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80146b:	75 14                	jne    801481 <initialize_dyn_block_system+0x19b>
  80146d:	83 ec 04             	sub    $0x4,%esp
  801470:	68 80 3a 80 00       	push   $0x803a80
  801475:	6a 3e                	push   $0x3e
  801477:	68 73 3a 80 00       	push   $0x803a73
  80147c:	e8 f6 ed ff ff       	call   800277 <_panic>
  801481:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801487:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80148a:	89 10                	mov    %edx,(%eax)
  80148c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80148f:	8b 00                	mov    (%eax),%eax
  801491:	85 c0                	test   %eax,%eax
  801493:	74 0d                	je     8014a2 <initialize_dyn_block_system+0x1bc>
  801495:	a1 38 41 80 00       	mov    0x804138,%eax
  80149a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80149d:	89 50 04             	mov    %edx,0x4(%eax)
  8014a0:	eb 08                	jmp    8014aa <initialize_dyn_block_system+0x1c4>
  8014a2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014a5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014aa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014ad:	a3 38 41 80 00       	mov    %eax,0x804138
  8014b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014bc:	a1 44 41 80 00       	mov    0x804144,%eax
  8014c1:	40                   	inc    %eax
  8014c2:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8014c7:	90                   	nop
  8014c8:	c9                   	leave  
  8014c9:	c3                   	ret    

008014ca <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014ca:	55                   	push   %ebp
  8014cb:	89 e5                	mov    %esp,%ebp
  8014cd:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8014d0:	e8 e0 fd ff ff       	call   8012b5 <InitializeUHeap>
		if (size == 0) return NULL ;
  8014d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d9:	75 07                	jne    8014e2 <malloc+0x18>
  8014db:	b8 00 00 00 00       	mov    $0x0,%eax
  8014e0:	eb 7f                	jmp    801561 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8014e2:	e8 d2 08 00 00       	call   801db9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014e7:	85 c0                	test   %eax,%eax
  8014e9:	74 71                	je     80155c <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  8014eb:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8014f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f8:	01 d0                	add    %edx,%eax
  8014fa:	48                   	dec    %eax
  8014fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801501:	ba 00 00 00 00       	mov    $0x0,%edx
  801506:	f7 75 f4             	divl   -0xc(%ebp)
  801509:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80150c:	29 d0                	sub    %edx,%eax
  80150e:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801511:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801518:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80151f:	76 07                	jbe    801528 <malloc+0x5e>
					return NULL ;
  801521:	b8 00 00 00 00       	mov    $0x0,%eax
  801526:	eb 39                	jmp    801561 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801528:	83 ec 0c             	sub    $0xc,%esp
  80152b:	ff 75 08             	pushl  0x8(%ebp)
  80152e:	e8 e6 0d 00 00       	call   802319 <alloc_block_FF>
  801533:	83 c4 10             	add    $0x10,%esp
  801536:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801539:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80153d:	74 16                	je     801555 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  80153f:	83 ec 0c             	sub    $0xc,%esp
  801542:	ff 75 ec             	pushl  -0x14(%ebp)
  801545:	e8 37 0c 00 00       	call   802181 <insert_sorted_allocList>
  80154a:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  80154d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801550:	8b 40 08             	mov    0x8(%eax),%eax
  801553:	eb 0c                	jmp    801561 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801555:	b8 00 00 00 00       	mov    $0x0,%eax
  80155a:	eb 05                	jmp    801561 <malloc+0x97>
				}
		}
	return 0;
  80155c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801561:	c9                   	leave  
  801562:	c3                   	ret    

00801563 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801563:	55                   	push   %ebp
  801564:	89 e5                	mov    %esp,%ebp
  801566:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801569:	8b 45 08             	mov    0x8(%ebp),%eax
  80156c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  80156f:	83 ec 08             	sub    $0x8,%esp
  801572:	ff 75 f4             	pushl  -0xc(%ebp)
  801575:	68 40 40 80 00       	push   $0x804040
  80157a:	e8 cf 0b 00 00       	call   80214e <find_block>
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801585:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801588:	8b 40 0c             	mov    0xc(%eax),%eax
  80158b:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  80158e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801591:	8b 40 08             	mov    0x8(%eax),%eax
  801594:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801597:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80159b:	0f 84 a1 00 00 00    	je     801642 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8015a1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015a5:	75 17                	jne    8015be <free+0x5b>
  8015a7:	83 ec 04             	sub    $0x4,%esp
  8015aa:	68 55 3a 80 00       	push   $0x803a55
  8015af:	68 80 00 00 00       	push   $0x80
  8015b4:	68 73 3a 80 00       	push   $0x803a73
  8015b9:	e8 b9 ec ff ff       	call   800277 <_panic>
  8015be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c1:	8b 00                	mov    (%eax),%eax
  8015c3:	85 c0                	test   %eax,%eax
  8015c5:	74 10                	je     8015d7 <free+0x74>
  8015c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ca:	8b 00                	mov    (%eax),%eax
  8015cc:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cf:	8b 52 04             	mov    0x4(%edx),%edx
  8015d2:	89 50 04             	mov    %edx,0x4(%eax)
  8015d5:	eb 0b                	jmp    8015e2 <free+0x7f>
  8015d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015da:	8b 40 04             	mov    0x4(%eax),%eax
  8015dd:	a3 44 40 80 00       	mov    %eax,0x804044
  8015e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e5:	8b 40 04             	mov    0x4(%eax),%eax
  8015e8:	85 c0                	test   %eax,%eax
  8015ea:	74 0f                	je     8015fb <free+0x98>
  8015ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ef:	8b 40 04             	mov    0x4(%eax),%eax
  8015f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015f5:	8b 12                	mov    (%edx),%edx
  8015f7:	89 10                	mov    %edx,(%eax)
  8015f9:	eb 0a                	jmp    801605 <free+0xa2>
  8015fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fe:	8b 00                	mov    (%eax),%eax
  801600:	a3 40 40 80 00       	mov    %eax,0x804040
  801605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801608:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80160e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801611:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801618:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80161d:	48                   	dec    %eax
  80161e:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  801623:	83 ec 0c             	sub    $0xc,%esp
  801626:	ff 75 f0             	pushl  -0x10(%ebp)
  801629:	e8 29 12 00 00       	call   802857 <insert_sorted_with_merge_freeList>
  80162e:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801631:	83 ec 08             	sub    $0x8,%esp
  801634:	ff 75 ec             	pushl  -0x14(%ebp)
  801637:	ff 75 e8             	pushl  -0x18(%ebp)
  80163a:	e8 74 03 00 00       	call   8019b3 <sys_free_user_mem>
  80163f:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801642:	90                   	nop
  801643:	c9                   	leave  
  801644:	c3                   	ret    

00801645 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801645:	55                   	push   %ebp
  801646:	89 e5                	mov    %esp,%ebp
  801648:	83 ec 38             	sub    $0x38,%esp
  80164b:	8b 45 10             	mov    0x10(%ebp),%eax
  80164e:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801651:	e8 5f fc ff ff       	call   8012b5 <InitializeUHeap>
	if (size == 0) return NULL ;
  801656:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80165a:	75 0a                	jne    801666 <smalloc+0x21>
  80165c:	b8 00 00 00 00       	mov    $0x0,%eax
  801661:	e9 b2 00 00 00       	jmp    801718 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801666:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80166d:	76 0a                	jbe    801679 <smalloc+0x34>
		return NULL;
  80166f:	b8 00 00 00 00       	mov    $0x0,%eax
  801674:	e9 9f 00 00 00       	jmp    801718 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801679:	e8 3b 07 00 00       	call   801db9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80167e:	85 c0                	test   %eax,%eax
  801680:	0f 84 8d 00 00 00    	je     801713 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801686:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  80168d:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801694:	8b 55 0c             	mov    0xc(%ebp),%edx
  801697:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169a:	01 d0                	add    %edx,%eax
  80169c:	48                   	dec    %eax
  80169d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a3:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a8:	f7 75 f0             	divl   -0x10(%ebp)
  8016ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ae:	29 d0                	sub    %edx,%eax
  8016b0:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8016b3:	83 ec 0c             	sub    $0xc,%esp
  8016b6:	ff 75 e8             	pushl  -0x18(%ebp)
  8016b9:	e8 5b 0c 00 00       	call   802319 <alloc_block_FF>
  8016be:	83 c4 10             	add    $0x10,%esp
  8016c1:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8016c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016c8:	75 07                	jne    8016d1 <smalloc+0x8c>
			return NULL;
  8016ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8016cf:	eb 47                	jmp    801718 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8016d1:	83 ec 0c             	sub    $0xc,%esp
  8016d4:	ff 75 f4             	pushl  -0xc(%ebp)
  8016d7:	e8 a5 0a 00 00       	call   802181 <insert_sorted_allocList>
  8016dc:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8016df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016e2:	8b 40 08             	mov    0x8(%eax),%eax
  8016e5:	89 c2                	mov    %eax,%edx
  8016e7:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016eb:	52                   	push   %edx
  8016ec:	50                   	push   %eax
  8016ed:	ff 75 0c             	pushl  0xc(%ebp)
  8016f0:	ff 75 08             	pushl  0x8(%ebp)
  8016f3:	e8 46 04 00 00       	call   801b3e <sys_createSharedObject>
  8016f8:	83 c4 10             	add    $0x10,%esp
  8016fb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  8016fe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801702:	78 08                	js     80170c <smalloc+0xc7>
		return (void *)b->sva;
  801704:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801707:	8b 40 08             	mov    0x8(%eax),%eax
  80170a:	eb 0c                	jmp    801718 <smalloc+0xd3>
		}else{
		return NULL;
  80170c:	b8 00 00 00 00       	mov    $0x0,%eax
  801711:	eb 05                	jmp    801718 <smalloc+0xd3>
			}

	}return NULL;
  801713:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801718:	c9                   	leave  
  801719:	c3                   	ret    

0080171a <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80171a:	55                   	push   %ebp
  80171b:	89 e5                	mov    %esp,%ebp
  80171d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801720:	e8 90 fb ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801725:	e8 8f 06 00 00       	call   801db9 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80172a:	85 c0                	test   %eax,%eax
  80172c:	0f 84 ad 00 00 00    	je     8017df <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801732:	83 ec 08             	sub    $0x8,%esp
  801735:	ff 75 0c             	pushl  0xc(%ebp)
  801738:	ff 75 08             	pushl  0x8(%ebp)
  80173b:	e8 28 04 00 00       	call   801b68 <sys_getSizeOfSharedObject>
  801740:	83 c4 10             	add    $0x10,%esp
  801743:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801746:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80174a:	79 0a                	jns    801756 <sget+0x3c>
    {
    	return NULL;
  80174c:	b8 00 00 00 00       	mov    $0x0,%eax
  801751:	e9 8e 00 00 00       	jmp    8017e4 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801756:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  80175d:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801764:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801767:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176a:	01 d0                	add    %edx,%eax
  80176c:	48                   	dec    %eax
  80176d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801770:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801773:	ba 00 00 00 00       	mov    $0x0,%edx
  801778:	f7 75 ec             	divl   -0x14(%ebp)
  80177b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80177e:	29 d0                	sub    %edx,%eax
  801780:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801783:	83 ec 0c             	sub    $0xc,%esp
  801786:	ff 75 e4             	pushl  -0x1c(%ebp)
  801789:	e8 8b 0b 00 00       	call   802319 <alloc_block_FF>
  80178e:	83 c4 10             	add    $0x10,%esp
  801791:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801794:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801798:	75 07                	jne    8017a1 <sget+0x87>
				return NULL;
  80179a:	b8 00 00 00 00       	mov    $0x0,%eax
  80179f:	eb 43                	jmp    8017e4 <sget+0xca>
			}
			insert_sorted_allocList(b);
  8017a1:	83 ec 0c             	sub    $0xc,%esp
  8017a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8017a7:	e8 d5 09 00 00       	call   802181 <insert_sorted_allocList>
  8017ac:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8017af:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b2:	8b 40 08             	mov    0x8(%eax),%eax
  8017b5:	83 ec 04             	sub    $0x4,%esp
  8017b8:	50                   	push   %eax
  8017b9:	ff 75 0c             	pushl  0xc(%ebp)
  8017bc:	ff 75 08             	pushl  0x8(%ebp)
  8017bf:	e8 c1 03 00 00       	call   801b85 <sys_getSharedObject>
  8017c4:	83 c4 10             	add    $0x10,%esp
  8017c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8017ca:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017ce:	78 08                	js     8017d8 <sget+0xbe>
			return (void *)b->sva;
  8017d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017d3:	8b 40 08             	mov    0x8(%eax),%eax
  8017d6:	eb 0c                	jmp    8017e4 <sget+0xca>
			}else{
			return NULL;
  8017d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8017dd:	eb 05                	jmp    8017e4 <sget+0xca>
			}
    }}return NULL;
  8017df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017e4:	c9                   	leave  
  8017e5:	c3                   	ret    

008017e6 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017e6:	55                   	push   %ebp
  8017e7:	89 e5                	mov    %esp,%ebp
  8017e9:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017ec:	e8 c4 fa ff ff       	call   8012b5 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017f1:	83 ec 04             	sub    $0x4,%esp
  8017f4:	68 a4 3a 80 00       	push   $0x803aa4
  8017f9:	68 03 01 00 00       	push   $0x103
  8017fe:	68 73 3a 80 00       	push   $0x803a73
  801803:	e8 6f ea ff ff       	call   800277 <_panic>

00801808 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801808:	55                   	push   %ebp
  801809:	89 e5                	mov    %esp,%ebp
  80180b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80180e:	83 ec 04             	sub    $0x4,%esp
  801811:	68 cc 3a 80 00       	push   $0x803acc
  801816:	68 17 01 00 00       	push   $0x117
  80181b:	68 73 3a 80 00       	push   $0x803a73
  801820:	e8 52 ea ff ff       	call   800277 <_panic>

00801825 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80182b:	83 ec 04             	sub    $0x4,%esp
  80182e:	68 f0 3a 80 00       	push   $0x803af0
  801833:	68 22 01 00 00       	push   $0x122
  801838:	68 73 3a 80 00       	push   $0x803a73
  80183d:	e8 35 ea ff ff       	call   800277 <_panic>

00801842 <shrink>:

}
void shrink(uint32 newSize)
{
  801842:	55                   	push   %ebp
  801843:	89 e5                	mov    %esp,%ebp
  801845:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801848:	83 ec 04             	sub    $0x4,%esp
  80184b:	68 f0 3a 80 00       	push   $0x803af0
  801850:	68 27 01 00 00       	push   $0x127
  801855:	68 73 3a 80 00       	push   $0x803a73
  80185a:	e8 18 ea ff ff       	call   800277 <_panic>

0080185f <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
  801862:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801865:	83 ec 04             	sub    $0x4,%esp
  801868:	68 f0 3a 80 00       	push   $0x803af0
  80186d:	68 2c 01 00 00       	push   $0x12c
  801872:	68 73 3a 80 00       	push   $0x803a73
  801877:	e8 fb e9 ff ff       	call   800277 <_panic>

0080187c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
  80187f:	57                   	push   %edi
  801880:	56                   	push   %esi
  801881:	53                   	push   %ebx
  801882:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801885:	8b 45 08             	mov    0x8(%ebp),%eax
  801888:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80188e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801891:	8b 7d 18             	mov    0x18(%ebp),%edi
  801894:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801897:	cd 30                	int    $0x30
  801899:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80189c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80189f:	83 c4 10             	add    $0x10,%esp
  8018a2:	5b                   	pop    %ebx
  8018a3:	5e                   	pop    %esi
  8018a4:	5f                   	pop    %edi
  8018a5:	5d                   	pop    %ebp
  8018a6:	c3                   	ret    

008018a7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018a7:	55                   	push   %ebp
  8018a8:	89 e5                	mov    %esp,%ebp
  8018aa:	83 ec 04             	sub    $0x4,%esp
  8018ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018b3:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ba:	6a 00                	push   $0x0
  8018bc:	6a 00                	push   $0x0
  8018be:	52                   	push   %edx
  8018bf:	ff 75 0c             	pushl  0xc(%ebp)
  8018c2:	50                   	push   %eax
  8018c3:	6a 00                	push   $0x0
  8018c5:	e8 b2 ff ff ff       	call   80187c <syscall>
  8018ca:	83 c4 18             	add    $0x18,%esp
}
  8018cd:	90                   	nop
  8018ce:	c9                   	leave  
  8018cf:	c3                   	ret    

008018d0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018d0:	55                   	push   %ebp
  8018d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 00                	push   $0x0
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 01                	push   $0x1
  8018df:	e8 98 ff ff ff       	call   80187c <syscall>
  8018e4:	83 c4 18             	add    $0x18,%esp
}
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	52                   	push   %edx
  8018f9:	50                   	push   %eax
  8018fa:	6a 05                	push   $0x5
  8018fc:	e8 7b ff ff ff       	call   80187c <syscall>
  801901:	83 c4 18             	add    $0x18,%esp
}
  801904:	c9                   	leave  
  801905:	c3                   	ret    

00801906 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801906:	55                   	push   %ebp
  801907:	89 e5                	mov    %esp,%ebp
  801909:	56                   	push   %esi
  80190a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80190b:	8b 75 18             	mov    0x18(%ebp),%esi
  80190e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801911:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801914:	8b 55 0c             	mov    0xc(%ebp),%edx
  801917:	8b 45 08             	mov    0x8(%ebp),%eax
  80191a:	56                   	push   %esi
  80191b:	53                   	push   %ebx
  80191c:	51                   	push   %ecx
  80191d:	52                   	push   %edx
  80191e:	50                   	push   %eax
  80191f:	6a 06                	push   $0x6
  801921:	e8 56 ff ff ff       	call   80187c <syscall>
  801926:	83 c4 18             	add    $0x18,%esp
}
  801929:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80192c:	5b                   	pop    %ebx
  80192d:	5e                   	pop    %esi
  80192e:	5d                   	pop    %ebp
  80192f:	c3                   	ret    

00801930 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801930:	55                   	push   %ebp
  801931:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801933:	8b 55 0c             	mov    0xc(%ebp),%edx
  801936:	8b 45 08             	mov    0x8(%ebp),%eax
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	52                   	push   %edx
  801940:	50                   	push   %eax
  801941:	6a 07                	push   $0x7
  801943:	e8 34 ff ff ff       	call   80187c <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	c9                   	leave  
  80194c:	c3                   	ret    

0080194d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80194d:	55                   	push   %ebp
  80194e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	ff 75 0c             	pushl  0xc(%ebp)
  801959:	ff 75 08             	pushl  0x8(%ebp)
  80195c:	6a 08                	push   $0x8
  80195e:	e8 19 ff ff ff       	call   80187c <syscall>
  801963:	83 c4 18             	add    $0x18,%esp
}
  801966:	c9                   	leave  
  801967:	c3                   	ret    

00801968 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 09                	push   $0x9
  801977:	e8 00 ff ff ff       	call   80187c <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 0a                	push   $0xa
  801990:	e8 e7 fe ff ff       	call   80187c <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 0b                	push   $0xb
  8019a9:	e8 ce fe ff ff       	call   80187c <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	ff 75 0c             	pushl  0xc(%ebp)
  8019bf:	ff 75 08             	pushl  0x8(%ebp)
  8019c2:	6a 0f                	push   $0xf
  8019c4:	e8 b3 fe ff ff       	call   80187c <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
	return;
  8019cc:	90                   	nop
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 00                	push   $0x0
  8019d8:	ff 75 0c             	pushl  0xc(%ebp)
  8019db:	ff 75 08             	pushl  0x8(%ebp)
  8019de:	6a 10                	push   $0x10
  8019e0:	e8 97 fe ff ff       	call   80187c <syscall>
  8019e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e8:	90                   	nop
}
  8019e9:	c9                   	leave  
  8019ea:	c3                   	ret    

008019eb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019eb:	55                   	push   %ebp
  8019ec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	ff 75 10             	pushl  0x10(%ebp)
  8019f5:	ff 75 0c             	pushl  0xc(%ebp)
  8019f8:	ff 75 08             	pushl  0x8(%ebp)
  8019fb:	6a 11                	push   $0x11
  8019fd:	e8 7a fe ff ff       	call   80187c <syscall>
  801a02:	83 c4 18             	add    $0x18,%esp
	return ;
  801a05:	90                   	nop
}
  801a06:	c9                   	leave  
  801a07:	c3                   	ret    

00801a08 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a08:	55                   	push   %ebp
  801a09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 0c                	push   $0xc
  801a17:	e8 60 fe ff ff       	call   80187c <syscall>
  801a1c:	83 c4 18             	add    $0x18,%esp
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	ff 75 08             	pushl  0x8(%ebp)
  801a2f:	6a 0d                	push   $0xd
  801a31:	e8 46 fe ff ff       	call   80187c <syscall>
  801a36:	83 c4 18             	add    $0x18,%esp
}
  801a39:	c9                   	leave  
  801a3a:	c3                   	ret    

00801a3b <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a3b:	55                   	push   %ebp
  801a3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 0e                	push   $0xe
  801a4a:	e8 2d fe ff ff       	call   80187c <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	90                   	nop
  801a53:	c9                   	leave  
  801a54:	c3                   	ret    

00801a55 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a55:	55                   	push   %ebp
  801a56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 13                	push   $0x13
  801a64:	e8 13 fe ff ff       	call   80187c <syscall>
  801a69:	83 c4 18             	add    $0x18,%esp
}
  801a6c:	90                   	nop
  801a6d:	c9                   	leave  
  801a6e:	c3                   	ret    

00801a6f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a6f:	55                   	push   %ebp
  801a70:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	6a 14                	push   $0x14
  801a7e:	e8 f9 fd ff ff       	call   80187c <syscall>
  801a83:	83 c4 18             	add    $0x18,%esp
}
  801a86:	90                   	nop
  801a87:	c9                   	leave  
  801a88:	c3                   	ret    

00801a89 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a89:	55                   	push   %ebp
  801a8a:	89 e5                	mov    %esp,%ebp
  801a8c:	83 ec 04             	sub    $0x4,%esp
  801a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a92:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a95:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	50                   	push   %eax
  801aa2:	6a 15                	push   $0x15
  801aa4:	e8 d3 fd ff ff       	call   80187c <syscall>
  801aa9:	83 c4 18             	add    $0x18,%esp
}
  801aac:	90                   	nop
  801aad:	c9                   	leave  
  801aae:	c3                   	ret    

00801aaf <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aaf:	55                   	push   %ebp
  801ab0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 16                	push   $0x16
  801abe:	e8 b9 fd ff ff       	call   80187c <syscall>
  801ac3:	83 c4 18             	add    $0x18,%esp
}
  801ac6:	90                   	nop
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801acc:	8b 45 08             	mov    0x8(%ebp),%eax
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	ff 75 0c             	pushl  0xc(%ebp)
  801ad8:	50                   	push   %eax
  801ad9:	6a 17                	push   $0x17
  801adb:	e8 9c fd ff ff       	call   80187c <syscall>
  801ae0:	83 c4 18             	add    $0x18,%esp
}
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ae8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  801aee:	6a 00                	push   $0x0
  801af0:	6a 00                	push   $0x0
  801af2:	6a 00                	push   $0x0
  801af4:	52                   	push   %edx
  801af5:	50                   	push   %eax
  801af6:	6a 1a                	push   $0x1a
  801af8:	e8 7f fd ff ff       	call   80187c <syscall>
  801afd:	83 c4 18             	add    $0x18,%esp
}
  801b00:	c9                   	leave  
  801b01:	c3                   	ret    

00801b02 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b02:	55                   	push   %ebp
  801b03:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b08:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	52                   	push   %edx
  801b12:	50                   	push   %eax
  801b13:	6a 18                	push   $0x18
  801b15:	e8 62 fd ff ff       	call   80187c <syscall>
  801b1a:	83 c4 18             	add    $0x18,%esp
}
  801b1d:	90                   	nop
  801b1e:	c9                   	leave  
  801b1f:	c3                   	ret    

00801b20 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b20:	55                   	push   %ebp
  801b21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b23:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b26:	8b 45 08             	mov    0x8(%ebp),%eax
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	52                   	push   %edx
  801b30:	50                   	push   %eax
  801b31:	6a 19                	push   $0x19
  801b33:	e8 44 fd ff ff       	call   80187c <syscall>
  801b38:	83 c4 18             	add    $0x18,%esp
}
  801b3b:	90                   	nop
  801b3c:	c9                   	leave  
  801b3d:	c3                   	ret    

00801b3e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b3e:	55                   	push   %ebp
  801b3f:	89 e5                	mov    %esp,%ebp
  801b41:	83 ec 04             	sub    $0x4,%esp
  801b44:	8b 45 10             	mov    0x10(%ebp),%eax
  801b47:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b4a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b4d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b51:	8b 45 08             	mov    0x8(%ebp),%eax
  801b54:	6a 00                	push   $0x0
  801b56:	51                   	push   %ecx
  801b57:	52                   	push   %edx
  801b58:	ff 75 0c             	pushl  0xc(%ebp)
  801b5b:	50                   	push   %eax
  801b5c:	6a 1b                	push   $0x1b
  801b5e:	e8 19 fd ff ff       	call   80187c <syscall>
  801b63:	83 c4 18             	add    $0x18,%esp
}
  801b66:	c9                   	leave  
  801b67:	c3                   	ret    

00801b68 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b68:	55                   	push   %ebp
  801b69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	52                   	push   %edx
  801b78:	50                   	push   %eax
  801b79:	6a 1c                	push   $0x1c
  801b7b:	e8 fc fc ff ff       	call   80187c <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
}
  801b83:	c9                   	leave  
  801b84:	c3                   	ret    

00801b85 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b85:	55                   	push   %ebp
  801b86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b88:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	51                   	push   %ecx
  801b96:	52                   	push   %edx
  801b97:	50                   	push   %eax
  801b98:	6a 1d                	push   $0x1d
  801b9a:	e8 dd fc ff ff       	call   80187c <syscall>
  801b9f:	83 c4 18             	add    $0x18,%esp
}
  801ba2:	c9                   	leave  
  801ba3:	c3                   	ret    

00801ba4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ba4:	55                   	push   %ebp
  801ba5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ba7:	8b 55 0c             	mov    0xc(%ebp),%edx
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	6a 00                	push   $0x0
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	52                   	push   %edx
  801bb4:	50                   	push   %eax
  801bb5:	6a 1e                	push   $0x1e
  801bb7:	e8 c0 fc ff ff       	call   80187c <syscall>
  801bbc:	83 c4 18             	add    $0x18,%esp
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	6a 00                	push   $0x0
  801bce:	6a 1f                	push   $0x1f
  801bd0:	e8 a7 fc ff ff       	call   80187c <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bdd:	8b 45 08             	mov    0x8(%ebp),%eax
  801be0:	6a 00                	push   $0x0
  801be2:	ff 75 14             	pushl  0x14(%ebp)
  801be5:	ff 75 10             	pushl  0x10(%ebp)
  801be8:	ff 75 0c             	pushl  0xc(%ebp)
  801beb:	50                   	push   %eax
  801bec:	6a 20                	push   $0x20
  801bee:	e8 89 fc ff ff       	call   80187c <syscall>
  801bf3:	83 c4 18             	add    $0x18,%esp
}
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	50                   	push   %eax
  801c07:	6a 21                	push   $0x21
  801c09:	e8 6e fc ff ff       	call   80187c <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	90                   	nop
  801c12:	c9                   	leave  
  801c13:	c3                   	ret    

00801c14 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c14:	55                   	push   %ebp
  801c15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c17:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	50                   	push   %eax
  801c23:	6a 22                	push   $0x22
  801c25:	e8 52 fc ff ff       	call   80187c <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 02                	push   $0x2
  801c3e:	e8 39 fc ff ff       	call   80187c <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 03                	push   $0x3
  801c57:	e8 20 fc ff ff       	call   80187c <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 04                	push   $0x4
  801c70:	e8 07 fc ff ff       	call   80187c <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_exit_env>:


void sys_exit_env(void)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 23                	push   $0x23
  801c89:	e8 ee fb ff ff       	call   80187c <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	90                   	nop
  801c92:	c9                   	leave  
  801c93:	c3                   	ret    

00801c94 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c94:	55                   	push   %ebp
  801c95:	89 e5                	mov    %esp,%ebp
  801c97:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c9a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c9d:	8d 50 04             	lea    0x4(%eax),%edx
  801ca0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	52                   	push   %edx
  801caa:	50                   	push   %eax
  801cab:	6a 24                	push   $0x24
  801cad:	e8 ca fb ff ff       	call   80187c <syscall>
  801cb2:	83 c4 18             	add    $0x18,%esp
	return result;
  801cb5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cbb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cbe:	89 01                	mov    %eax,(%ecx)
  801cc0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	c9                   	leave  
  801cc7:	c2 04 00             	ret    $0x4

00801cca <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	ff 75 10             	pushl  0x10(%ebp)
  801cd4:	ff 75 0c             	pushl  0xc(%ebp)
  801cd7:	ff 75 08             	pushl  0x8(%ebp)
  801cda:	6a 12                	push   $0x12
  801cdc:	e8 9b fb ff ff       	call   80187c <syscall>
  801ce1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce4:	90                   	nop
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 25                	push   $0x25
  801cf6:	e8 81 fb ff ff       	call   80187c <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
  801d03:	83 ec 04             	sub    $0x4,%esp
  801d06:	8b 45 08             	mov    0x8(%ebp),%eax
  801d09:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d0c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 00                	push   $0x0
  801d18:	50                   	push   %eax
  801d19:	6a 26                	push   $0x26
  801d1b:	e8 5c fb ff ff       	call   80187c <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
	return ;
  801d23:	90                   	nop
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <rsttst>:
void rsttst()
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 28                	push   $0x28
  801d35:	e8 42 fb ff ff       	call   80187c <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3d:	90                   	nop
}
  801d3e:	c9                   	leave  
  801d3f:	c3                   	ret    

00801d40 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d40:	55                   	push   %ebp
  801d41:	89 e5                	mov    %esp,%ebp
  801d43:	83 ec 04             	sub    $0x4,%esp
  801d46:	8b 45 14             	mov    0x14(%ebp),%eax
  801d49:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d4c:	8b 55 18             	mov    0x18(%ebp),%edx
  801d4f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d53:	52                   	push   %edx
  801d54:	50                   	push   %eax
  801d55:	ff 75 10             	pushl  0x10(%ebp)
  801d58:	ff 75 0c             	pushl  0xc(%ebp)
  801d5b:	ff 75 08             	pushl  0x8(%ebp)
  801d5e:	6a 27                	push   $0x27
  801d60:	e8 17 fb ff ff       	call   80187c <syscall>
  801d65:	83 c4 18             	add    $0x18,%esp
	return ;
  801d68:	90                   	nop
}
  801d69:	c9                   	leave  
  801d6a:	c3                   	ret    

00801d6b <chktst>:
void chktst(uint32 n)
{
  801d6b:	55                   	push   %ebp
  801d6c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	ff 75 08             	pushl  0x8(%ebp)
  801d79:	6a 29                	push   $0x29
  801d7b:	e8 fc fa ff ff       	call   80187c <syscall>
  801d80:	83 c4 18             	add    $0x18,%esp
	return ;
  801d83:	90                   	nop
}
  801d84:	c9                   	leave  
  801d85:	c3                   	ret    

00801d86 <inctst>:

void inctst()
{
  801d86:	55                   	push   %ebp
  801d87:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 00                	push   $0x0
  801d93:	6a 2a                	push   $0x2a
  801d95:	e8 e2 fa ff ff       	call   80187c <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9d:	90                   	nop
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <gettst>:
uint32 gettst()
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 2b                	push   $0x2b
  801daf:	e8 c8 fa ff ff       	call   80187c <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
  801dbc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	6a 00                	push   $0x0
  801dc9:	6a 2c                	push   $0x2c
  801dcb:	e8 ac fa ff ff       	call   80187c <syscall>
  801dd0:	83 c4 18             	add    $0x18,%esp
  801dd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dd6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dda:	75 07                	jne    801de3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ddc:	b8 01 00 00 00       	mov    $0x1,%eax
  801de1:	eb 05                	jmp    801de8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801de3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de8:	c9                   	leave  
  801de9:	c3                   	ret    

00801dea <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dea:	55                   	push   %ebp
  801deb:	89 e5                	mov    %esp,%ebp
  801ded:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 00                	push   $0x0
  801df6:	6a 00                	push   $0x0
  801df8:	6a 00                	push   $0x0
  801dfa:	6a 2c                	push   $0x2c
  801dfc:	e8 7b fa ff ff       	call   80187c <syscall>
  801e01:	83 c4 18             	add    $0x18,%esp
  801e04:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e07:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e0b:	75 07                	jne    801e14 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e0d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e12:	eb 05                	jmp    801e19 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e14:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
  801e1e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 00                	push   $0x0
  801e27:	6a 00                	push   $0x0
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 2c                	push   $0x2c
  801e2d:	e8 4a fa ff ff       	call   80187c <syscall>
  801e32:	83 c4 18             	add    $0x18,%esp
  801e35:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e38:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e3c:	75 07                	jne    801e45 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e43:	eb 05                	jmp    801e4a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e45:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
  801e4f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 2c                	push   $0x2c
  801e5e:	e8 19 fa ff ff       	call   80187c <syscall>
  801e63:	83 c4 18             	add    $0x18,%esp
  801e66:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e69:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e6d:	75 07                	jne    801e76 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e6f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e74:	eb 05                	jmp    801e7b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e76:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e7b:	c9                   	leave  
  801e7c:	c3                   	ret    

00801e7d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e7d:	55                   	push   %ebp
  801e7e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 00                	push   $0x0
  801e88:	ff 75 08             	pushl  0x8(%ebp)
  801e8b:	6a 2d                	push   $0x2d
  801e8d:	e8 ea f9 ff ff       	call   80187c <syscall>
  801e92:	83 c4 18             	add    $0x18,%esp
	return ;
  801e95:	90                   	nop
}
  801e96:	c9                   	leave  
  801e97:	c3                   	ret    

00801e98 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e98:	55                   	push   %ebp
  801e99:	89 e5                	mov    %esp,%ebp
  801e9b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e9c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e9f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ea2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea8:	6a 00                	push   $0x0
  801eaa:	53                   	push   %ebx
  801eab:	51                   	push   %ecx
  801eac:	52                   	push   %edx
  801ead:	50                   	push   %eax
  801eae:	6a 2e                	push   $0x2e
  801eb0:	e8 c7 f9 ff ff       	call   80187c <syscall>
  801eb5:	83 c4 18             	add    $0x18,%esp
}
  801eb8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ebb:	c9                   	leave  
  801ebc:	c3                   	ret    

00801ebd <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ec0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	52                   	push   %edx
  801ecd:	50                   	push   %eax
  801ece:	6a 2f                	push   $0x2f
  801ed0:	e8 a7 f9 ff ff       	call   80187c <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
}
  801ed8:	c9                   	leave  
  801ed9:	c3                   	ret    

00801eda <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ee0:	83 ec 0c             	sub    $0xc,%esp
  801ee3:	68 00 3b 80 00       	push   $0x803b00
  801ee8:	e8 3e e6 ff ff       	call   80052b <cprintf>
  801eed:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ef0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ef7:	83 ec 0c             	sub    $0xc,%esp
  801efa:	68 2c 3b 80 00       	push   $0x803b2c
  801eff:	e8 27 e6 ff ff       	call   80052b <cprintf>
  801f04:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f07:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f0b:	a1 38 41 80 00       	mov    0x804138,%eax
  801f10:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f13:	eb 56                	jmp    801f6b <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f15:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f19:	74 1c                	je     801f37 <print_mem_block_lists+0x5d>
  801f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1e:	8b 50 08             	mov    0x8(%eax),%edx
  801f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f24:	8b 48 08             	mov    0x8(%eax),%ecx
  801f27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f2d:	01 c8                	add    %ecx,%eax
  801f2f:	39 c2                	cmp    %eax,%edx
  801f31:	73 04                	jae    801f37 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f33:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3a:	8b 50 08             	mov    0x8(%eax),%edx
  801f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f40:	8b 40 0c             	mov    0xc(%eax),%eax
  801f43:	01 c2                	add    %eax,%edx
  801f45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f48:	8b 40 08             	mov    0x8(%eax),%eax
  801f4b:	83 ec 04             	sub    $0x4,%esp
  801f4e:	52                   	push   %edx
  801f4f:	50                   	push   %eax
  801f50:	68 41 3b 80 00       	push   $0x803b41
  801f55:	e8 d1 e5 ff ff       	call   80052b <cprintf>
  801f5a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f60:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f63:	a1 40 41 80 00       	mov    0x804140,%eax
  801f68:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f6f:	74 07                	je     801f78 <print_mem_block_lists+0x9e>
  801f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f74:	8b 00                	mov    (%eax),%eax
  801f76:	eb 05                	jmp    801f7d <print_mem_block_lists+0xa3>
  801f78:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7d:	a3 40 41 80 00       	mov    %eax,0x804140
  801f82:	a1 40 41 80 00       	mov    0x804140,%eax
  801f87:	85 c0                	test   %eax,%eax
  801f89:	75 8a                	jne    801f15 <print_mem_block_lists+0x3b>
  801f8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f8f:	75 84                	jne    801f15 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f91:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f95:	75 10                	jne    801fa7 <print_mem_block_lists+0xcd>
  801f97:	83 ec 0c             	sub    $0xc,%esp
  801f9a:	68 50 3b 80 00       	push   $0x803b50
  801f9f:	e8 87 e5 ff ff       	call   80052b <cprintf>
  801fa4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fa7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fae:	83 ec 0c             	sub    $0xc,%esp
  801fb1:	68 74 3b 80 00       	push   $0x803b74
  801fb6:	e8 70 e5 ff ff       	call   80052b <cprintf>
  801fbb:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fbe:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fc2:	a1 40 40 80 00       	mov    0x804040,%eax
  801fc7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fca:	eb 56                	jmp    802022 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fcc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fd0:	74 1c                	je     801fee <print_mem_block_lists+0x114>
  801fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd5:	8b 50 08             	mov    0x8(%eax),%edx
  801fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fdb:	8b 48 08             	mov    0x8(%eax),%ecx
  801fde:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe1:	8b 40 0c             	mov    0xc(%eax),%eax
  801fe4:	01 c8                	add    %ecx,%eax
  801fe6:	39 c2                	cmp    %eax,%edx
  801fe8:	73 04                	jae    801fee <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fea:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff1:	8b 50 08             	mov    0x8(%eax),%edx
  801ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff7:	8b 40 0c             	mov    0xc(%eax),%eax
  801ffa:	01 c2                	add    %eax,%edx
  801ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fff:	8b 40 08             	mov    0x8(%eax),%eax
  802002:	83 ec 04             	sub    $0x4,%esp
  802005:	52                   	push   %edx
  802006:	50                   	push   %eax
  802007:	68 41 3b 80 00       	push   $0x803b41
  80200c:	e8 1a e5 ff ff       	call   80052b <cprintf>
  802011:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802014:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802017:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80201a:	a1 48 40 80 00       	mov    0x804048,%eax
  80201f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802022:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802026:	74 07                	je     80202f <print_mem_block_lists+0x155>
  802028:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202b:	8b 00                	mov    (%eax),%eax
  80202d:	eb 05                	jmp    802034 <print_mem_block_lists+0x15a>
  80202f:	b8 00 00 00 00       	mov    $0x0,%eax
  802034:	a3 48 40 80 00       	mov    %eax,0x804048
  802039:	a1 48 40 80 00       	mov    0x804048,%eax
  80203e:	85 c0                	test   %eax,%eax
  802040:	75 8a                	jne    801fcc <print_mem_block_lists+0xf2>
  802042:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802046:	75 84                	jne    801fcc <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802048:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80204c:	75 10                	jne    80205e <print_mem_block_lists+0x184>
  80204e:	83 ec 0c             	sub    $0xc,%esp
  802051:	68 8c 3b 80 00       	push   $0x803b8c
  802056:	e8 d0 e4 ff ff       	call   80052b <cprintf>
  80205b:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80205e:	83 ec 0c             	sub    $0xc,%esp
  802061:	68 00 3b 80 00       	push   $0x803b00
  802066:	e8 c0 e4 ff ff       	call   80052b <cprintf>
  80206b:	83 c4 10             	add    $0x10,%esp

}
  80206e:	90                   	nop
  80206f:	c9                   	leave  
  802070:	c3                   	ret    

00802071 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802071:	55                   	push   %ebp
  802072:	89 e5                	mov    %esp,%ebp
  802074:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802077:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80207e:	00 00 00 
  802081:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802088:	00 00 00 
  80208b:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802092:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802095:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80209c:	e9 9e 00 00 00       	jmp    80213f <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8020a1:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a9:	c1 e2 04             	shl    $0x4,%edx
  8020ac:	01 d0                	add    %edx,%eax
  8020ae:	85 c0                	test   %eax,%eax
  8020b0:	75 14                	jne    8020c6 <initialize_MemBlocksList+0x55>
  8020b2:	83 ec 04             	sub    $0x4,%esp
  8020b5:	68 b4 3b 80 00       	push   $0x803bb4
  8020ba:	6a 3d                	push   $0x3d
  8020bc:	68 d7 3b 80 00       	push   $0x803bd7
  8020c1:	e8 b1 e1 ff ff       	call   800277 <_panic>
  8020c6:	a1 50 40 80 00       	mov    0x804050,%eax
  8020cb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020ce:	c1 e2 04             	shl    $0x4,%edx
  8020d1:	01 d0                	add    %edx,%eax
  8020d3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020d9:	89 10                	mov    %edx,(%eax)
  8020db:	8b 00                	mov    (%eax),%eax
  8020dd:	85 c0                	test   %eax,%eax
  8020df:	74 18                	je     8020f9 <initialize_MemBlocksList+0x88>
  8020e1:	a1 48 41 80 00       	mov    0x804148,%eax
  8020e6:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020ec:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020ef:	c1 e1 04             	shl    $0x4,%ecx
  8020f2:	01 ca                	add    %ecx,%edx
  8020f4:	89 50 04             	mov    %edx,0x4(%eax)
  8020f7:	eb 12                	jmp    80210b <initialize_MemBlocksList+0x9a>
  8020f9:	a1 50 40 80 00       	mov    0x804050,%eax
  8020fe:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802101:	c1 e2 04             	shl    $0x4,%edx
  802104:	01 d0                	add    %edx,%eax
  802106:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80210b:	a1 50 40 80 00       	mov    0x804050,%eax
  802110:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802113:	c1 e2 04             	shl    $0x4,%edx
  802116:	01 d0                	add    %edx,%eax
  802118:	a3 48 41 80 00       	mov    %eax,0x804148
  80211d:	a1 50 40 80 00       	mov    0x804050,%eax
  802122:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802125:	c1 e2 04             	shl    $0x4,%edx
  802128:	01 d0                	add    %edx,%eax
  80212a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802131:	a1 54 41 80 00       	mov    0x804154,%eax
  802136:	40                   	inc    %eax
  802137:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80213c:	ff 45 f4             	incl   -0xc(%ebp)
  80213f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802142:	3b 45 08             	cmp    0x8(%ebp),%eax
  802145:	0f 82 56 ff ff ff    	jb     8020a1 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  80214b:	90                   	nop
  80214c:	c9                   	leave  
  80214d:	c3                   	ret    

0080214e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80214e:	55                   	push   %ebp
  80214f:	89 e5                	mov    %esp,%ebp
  802151:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802154:	8b 45 08             	mov    0x8(%ebp),%eax
  802157:	8b 00                	mov    (%eax),%eax
  802159:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80215c:	eb 18                	jmp    802176 <find_block+0x28>

		if(tmp->sva == va){
  80215e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802161:	8b 40 08             	mov    0x8(%eax),%eax
  802164:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802167:	75 05                	jne    80216e <find_block+0x20>
			return tmp ;
  802169:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80216c:	eb 11                	jmp    80217f <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  80216e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802171:	8b 00                	mov    (%eax),%eax
  802173:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802176:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80217a:	75 e2                	jne    80215e <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  80217c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80217f:	c9                   	leave  
  802180:	c3                   	ret    

00802181 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802181:	55                   	push   %ebp
  802182:	89 e5                	mov    %esp,%ebp
  802184:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802187:	a1 40 40 80 00       	mov    0x804040,%eax
  80218c:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  80218f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802194:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802197:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80219b:	75 65                	jne    802202 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  80219d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021a1:	75 14                	jne    8021b7 <insert_sorted_allocList+0x36>
  8021a3:	83 ec 04             	sub    $0x4,%esp
  8021a6:	68 b4 3b 80 00       	push   $0x803bb4
  8021ab:	6a 62                	push   $0x62
  8021ad:	68 d7 3b 80 00       	push   $0x803bd7
  8021b2:	e8 c0 e0 ff ff       	call   800277 <_panic>
  8021b7:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	89 10                	mov    %edx,(%eax)
  8021c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c5:	8b 00                	mov    (%eax),%eax
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	74 0d                	je     8021d8 <insert_sorted_allocList+0x57>
  8021cb:	a1 40 40 80 00       	mov    0x804040,%eax
  8021d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8021d3:	89 50 04             	mov    %edx,0x4(%eax)
  8021d6:	eb 08                	jmp    8021e0 <insert_sorted_allocList+0x5f>
  8021d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021db:	a3 44 40 80 00       	mov    %eax,0x804044
  8021e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e3:	a3 40 40 80 00       	mov    %eax,0x804040
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021f2:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021f7:	40                   	inc    %eax
  8021f8:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8021fd:	e9 14 01 00 00       	jmp    802316 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802202:	8b 45 08             	mov    0x8(%ebp),%eax
  802205:	8b 50 08             	mov    0x8(%eax),%edx
  802208:	a1 44 40 80 00       	mov    0x804044,%eax
  80220d:	8b 40 08             	mov    0x8(%eax),%eax
  802210:	39 c2                	cmp    %eax,%edx
  802212:	76 65                	jbe    802279 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802214:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802218:	75 14                	jne    80222e <insert_sorted_allocList+0xad>
  80221a:	83 ec 04             	sub    $0x4,%esp
  80221d:	68 f0 3b 80 00       	push   $0x803bf0
  802222:	6a 64                	push   $0x64
  802224:	68 d7 3b 80 00       	push   $0x803bd7
  802229:	e8 49 e0 ff ff       	call   800277 <_panic>
  80222e:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	89 50 04             	mov    %edx,0x4(%eax)
  80223a:	8b 45 08             	mov    0x8(%ebp),%eax
  80223d:	8b 40 04             	mov    0x4(%eax),%eax
  802240:	85 c0                	test   %eax,%eax
  802242:	74 0c                	je     802250 <insert_sorted_allocList+0xcf>
  802244:	a1 44 40 80 00       	mov    0x804044,%eax
  802249:	8b 55 08             	mov    0x8(%ebp),%edx
  80224c:	89 10                	mov    %edx,(%eax)
  80224e:	eb 08                	jmp    802258 <insert_sorted_allocList+0xd7>
  802250:	8b 45 08             	mov    0x8(%ebp),%eax
  802253:	a3 40 40 80 00       	mov    %eax,0x804040
  802258:	8b 45 08             	mov    0x8(%ebp),%eax
  80225b:	a3 44 40 80 00       	mov    %eax,0x804044
  802260:	8b 45 08             	mov    0x8(%ebp),%eax
  802263:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802269:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80226e:	40                   	inc    %eax
  80226f:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802274:	e9 9d 00 00 00       	jmp    802316 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802279:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802280:	e9 85 00 00 00       	jmp    80230a <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802285:	8b 45 08             	mov    0x8(%ebp),%eax
  802288:	8b 50 08             	mov    0x8(%eax),%edx
  80228b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228e:	8b 40 08             	mov    0x8(%eax),%eax
  802291:	39 c2                	cmp    %eax,%edx
  802293:	73 6a                	jae    8022ff <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802295:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802299:	74 06                	je     8022a1 <insert_sorted_allocList+0x120>
  80229b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80229f:	75 14                	jne    8022b5 <insert_sorted_allocList+0x134>
  8022a1:	83 ec 04             	sub    $0x4,%esp
  8022a4:	68 14 3c 80 00       	push   $0x803c14
  8022a9:	6a 6b                	push   $0x6b
  8022ab:	68 d7 3b 80 00       	push   $0x803bd7
  8022b0:	e8 c2 df ff ff       	call   800277 <_panic>
  8022b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b8:	8b 50 04             	mov    0x4(%eax),%edx
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	89 50 04             	mov    %edx,0x4(%eax)
  8022c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c7:	89 10                	mov    %edx,(%eax)
  8022c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cc:	8b 40 04             	mov    0x4(%eax),%eax
  8022cf:	85 c0                	test   %eax,%eax
  8022d1:	74 0d                	je     8022e0 <insert_sorted_allocList+0x15f>
  8022d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d6:	8b 40 04             	mov    0x4(%eax),%eax
  8022d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022dc:	89 10                	mov    %edx,(%eax)
  8022de:	eb 08                	jmp    8022e8 <insert_sorted_allocList+0x167>
  8022e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e3:	a3 40 40 80 00       	mov    %eax,0x804040
  8022e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ee:	89 50 04             	mov    %edx,0x4(%eax)
  8022f1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022f6:	40                   	inc    %eax
  8022f7:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  8022fc:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8022fd:	eb 17                	jmp    802316 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  8022ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802302:	8b 00                	mov    (%eax),%eax
  802304:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802307:	ff 45 f0             	incl   -0x10(%ebp)
  80230a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80230d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802310:	0f 8c 6f ff ff ff    	jl     802285 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802316:	90                   	nop
  802317:	c9                   	leave  
  802318:	c3                   	ret    

00802319 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802319:	55                   	push   %ebp
  80231a:	89 e5                	mov    %esp,%ebp
  80231c:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  80231f:	a1 38 41 80 00       	mov    0x804138,%eax
  802324:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802327:	e9 7c 01 00 00       	jmp    8024a8 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  80232c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232f:	8b 40 0c             	mov    0xc(%eax),%eax
  802332:	3b 45 08             	cmp    0x8(%ebp),%eax
  802335:	0f 86 cf 00 00 00    	jbe    80240a <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80233b:	a1 48 41 80 00       	mov    0x804148,%eax
  802340:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802343:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802346:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802349:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80234c:	8b 55 08             	mov    0x8(%ebp),%edx
  80234f:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802355:	8b 50 08             	mov    0x8(%eax),%edx
  802358:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80235b:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	8b 40 0c             	mov    0xc(%eax),%eax
  802364:	2b 45 08             	sub    0x8(%ebp),%eax
  802367:	89 c2                	mov    %eax,%edx
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  80236f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802372:	8b 50 08             	mov    0x8(%eax),%edx
  802375:	8b 45 08             	mov    0x8(%ebp),%eax
  802378:	01 c2                	add    %eax,%edx
  80237a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237d:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802380:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802384:	75 17                	jne    80239d <alloc_block_FF+0x84>
  802386:	83 ec 04             	sub    $0x4,%esp
  802389:	68 49 3c 80 00       	push   $0x803c49
  80238e:	68 83 00 00 00       	push   $0x83
  802393:	68 d7 3b 80 00       	push   $0x803bd7
  802398:	e8 da de ff ff       	call   800277 <_panic>
  80239d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a0:	8b 00                	mov    (%eax),%eax
  8023a2:	85 c0                	test   %eax,%eax
  8023a4:	74 10                	je     8023b6 <alloc_block_FF+0x9d>
  8023a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a9:	8b 00                	mov    (%eax),%eax
  8023ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023ae:	8b 52 04             	mov    0x4(%edx),%edx
  8023b1:	89 50 04             	mov    %edx,0x4(%eax)
  8023b4:	eb 0b                	jmp    8023c1 <alloc_block_FF+0xa8>
  8023b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b9:	8b 40 04             	mov    0x4(%eax),%eax
  8023bc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c4:	8b 40 04             	mov    0x4(%eax),%eax
  8023c7:	85 c0                	test   %eax,%eax
  8023c9:	74 0f                	je     8023da <alloc_block_FF+0xc1>
  8023cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ce:	8b 40 04             	mov    0x4(%eax),%eax
  8023d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023d4:	8b 12                	mov    (%edx),%edx
  8023d6:	89 10                	mov    %edx,(%eax)
  8023d8:	eb 0a                	jmp    8023e4 <alloc_block_FF+0xcb>
  8023da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023dd:	8b 00                	mov    (%eax),%eax
  8023df:	a3 48 41 80 00       	mov    %eax,0x804148
  8023e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f7:	a1 54 41 80 00       	mov    0x804154,%eax
  8023fc:	48                   	dec    %eax
  8023fd:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  802402:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802405:	e9 ad 00 00 00       	jmp    8024b7 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  80240a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240d:	8b 40 0c             	mov    0xc(%eax),%eax
  802410:	3b 45 08             	cmp    0x8(%ebp),%eax
  802413:	0f 85 87 00 00 00    	jne    8024a0 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802419:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80241d:	75 17                	jne    802436 <alloc_block_FF+0x11d>
  80241f:	83 ec 04             	sub    $0x4,%esp
  802422:	68 49 3c 80 00       	push   $0x803c49
  802427:	68 87 00 00 00       	push   $0x87
  80242c:	68 d7 3b 80 00       	push   $0x803bd7
  802431:	e8 41 de ff ff       	call   800277 <_panic>
  802436:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802439:	8b 00                	mov    (%eax),%eax
  80243b:	85 c0                	test   %eax,%eax
  80243d:	74 10                	je     80244f <alloc_block_FF+0x136>
  80243f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802442:	8b 00                	mov    (%eax),%eax
  802444:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802447:	8b 52 04             	mov    0x4(%edx),%edx
  80244a:	89 50 04             	mov    %edx,0x4(%eax)
  80244d:	eb 0b                	jmp    80245a <alloc_block_FF+0x141>
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	8b 40 04             	mov    0x4(%eax),%eax
  802455:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80245a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245d:	8b 40 04             	mov    0x4(%eax),%eax
  802460:	85 c0                	test   %eax,%eax
  802462:	74 0f                	je     802473 <alloc_block_FF+0x15a>
  802464:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802467:	8b 40 04             	mov    0x4(%eax),%eax
  80246a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80246d:	8b 12                	mov    (%edx),%edx
  80246f:	89 10                	mov    %edx,(%eax)
  802471:	eb 0a                	jmp    80247d <alloc_block_FF+0x164>
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 00                	mov    (%eax),%eax
  802478:	a3 38 41 80 00       	mov    %eax,0x804138
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802486:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802489:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802490:	a1 44 41 80 00       	mov    0x804144,%eax
  802495:	48                   	dec    %eax
  802496:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249e:	eb 17                	jmp    8024b7 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	8b 00                	mov    (%eax),%eax
  8024a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8024a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ac:	0f 85 7a fe ff ff    	jne    80232c <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8024b2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b7:	c9                   	leave  
  8024b8:	c3                   	ret    

008024b9 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024b9:	55                   	push   %ebp
  8024ba:	89 e5                	mov    %esp,%ebp
  8024bc:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8024bf:	a1 38 41 80 00       	mov    0x804138,%eax
  8024c4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8024c7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8024ce:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8024d5:	a1 38 41 80 00       	mov    0x804138,%eax
  8024da:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024dd:	e9 d0 00 00 00       	jmp    8025b2 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8024e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e5:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024eb:	0f 82 b8 00 00 00    	jb     8025a9 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  8024f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f4:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f7:	2b 45 08             	sub    0x8(%ebp),%eax
  8024fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  8024fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802500:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802503:	0f 83 a1 00 00 00    	jae    8025aa <alloc_block_BF+0xf1>
				differsize = differance ;
  802509:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80250c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  80250f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802512:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802515:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802519:	0f 85 8b 00 00 00    	jne    8025aa <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  80251f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802523:	75 17                	jne    80253c <alloc_block_BF+0x83>
  802525:	83 ec 04             	sub    $0x4,%esp
  802528:	68 49 3c 80 00       	push   $0x803c49
  80252d:	68 a0 00 00 00       	push   $0xa0
  802532:	68 d7 3b 80 00       	push   $0x803bd7
  802537:	e8 3b dd ff ff       	call   800277 <_panic>
  80253c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253f:	8b 00                	mov    (%eax),%eax
  802541:	85 c0                	test   %eax,%eax
  802543:	74 10                	je     802555 <alloc_block_BF+0x9c>
  802545:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802548:	8b 00                	mov    (%eax),%eax
  80254a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80254d:	8b 52 04             	mov    0x4(%edx),%edx
  802550:	89 50 04             	mov    %edx,0x4(%eax)
  802553:	eb 0b                	jmp    802560 <alloc_block_BF+0xa7>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 40 04             	mov    0x4(%eax),%eax
  80255b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802563:	8b 40 04             	mov    0x4(%eax),%eax
  802566:	85 c0                	test   %eax,%eax
  802568:	74 0f                	je     802579 <alloc_block_BF+0xc0>
  80256a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256d:	8b 40 04             	mov    0x4(%eax),%eax
  802570:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802573:	8b 12                	mov    (%edx),%edx
  802575:	89 10                	mov    %edx,(%eax)
  802577:	eb 0a                	jmp    802583 <alloc_block_BF+0xca>
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 00                	mov    (%eax),%eax
  80257e:	a3 38 41 80 00       	mov    %eax,0x804138
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802596:	a1 44 41 80 00       	mov    0x804144,%eax
  80259b:	48                   	dec    %eax
  80259c:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8025a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a4:	e9 0c 01 00 00       	jmp    8026b5 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8025a9:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8025aa:	a1 40 41 80 00       	mov    0x804140,%eax
  8025af:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025b2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b6:	74 07                	je     8025bf <alloc_block_BF+0x106>
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 00                	mov    (%eax),%eax
  8025bd:	eb 05                	jmp    8025c4 <alloc_block_BF+0x10b>
  8025bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8025c4:	a3 40 41 80 00       	mov    %eax,0x804140
  8025c9:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ce:	85 c0                	test   %eax,%eax
  8025d0:	0f 85 0c ff ff ff    	jne    8024e2 <alloc_block_BF+0x29>
  8025d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025da:	0f 85 02 ff ff ff    	jne    8024e2 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  8025e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025e4:	0f 84 c6 00 00 00    	je     8026b0 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  8025ea:	a1 48 41 80 00       	mov    0x804148,%eax
  8025ef:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  8025f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025f5:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f8:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  8025fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025fe:	8b 50 08             	mov    0x8(%eax),%edx
  802601:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802604:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260a:	8b 40 0c             	mov    0xc(%eax),%eax
  80260d:	2b 45 08             	sub    0x8(%ebp),%eax
  802610:	89 c2                	mov    %eax,%edx
  802612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802615:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802618:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80261b:	8b 50 08             	mov    0x8(%eax),%edx
  80261e:	8b 45 08             	mov    0x8(%ebp),%eax
  802621:	01 c2                	add    %eax,%edx
  802623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802626:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802629:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80262d:	75 17                	jne    802646 <alloc_block_BF+0x18d>
  80262f:	83 ec 04             	sub    $0x4,%esp
  802632:	68 49 3c 80 00       	push   $0x803c49
  802637:	68 af 00 00 00       	push   $0xaf
  80263c:	68 d7 3b 80 00       	push   $0x803bd7
  802641:	e8 31 dc ff ff       	call   800277 <_panic>
  802646:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802649:	8b 00                	mov    (%eax),%eax
  80264b:	85 c0                	test   %eax,%eax
  80264d:	74 10                	je     80265f <alloc_block_BF+0x1a6>
  80264f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802652:	8b 00                	mov    (%eax),%eax
  802654:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802657:	8b 52 04             	mov    0x4(%edx),%edx
  80265a:	89 50 04             	mov    %edx,0x4(%eax)
  80265d:	eb 0b                	jmp    80266a <alloc_block_BF+0x1b1>
  80265f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802662:	8b 40 04             	mov    0x4(%eax),%eax
  802665:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80266a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266d:	8b 40 04             	mov    0x4(%eax),%eax
  802670:	85 c0                	test   %eax,%eax
  802672:	74 0f                	je     802683 <alloc_block_BF+0x1ca>
  802674:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802677:	8b 40 04             	mov    0x4(%eax),%eax
  80267a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80267d:	8b 12                	mov    (%edx),%edx
  80267f:	89 10                	mov    %edx,(%eax)
  802681:	eb 0a                	jmp    80268d <alloc_block_BF+0x1d4>
  802683:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802686:	8b 00                	mov    (%eax),%eax
  802688:	a3 48 41 80 00       	mov    %eax,0x804148
  80268d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802690:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802696:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802699:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026a0:	a1 54 41 80 00       	mov    0x804154,%eax
  8026a5:	48                   	dec    %eax
  8026a6:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8026ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ae:	eb 05                	jmp    8026b5 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8026b0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026b5:	c9                   	leave  
  8026b6:	c3                   	ret    

008026b7 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8026b7:	55                   	push   %ebp
  8026b8:	89 e5                	mov    %esp,%ebp
  8026ba:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8026bd:	a1 38 41 80 00       	mov    0x804138,%eax
  8026c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8026c5:	e9 7c 01 00 00       	jmp    802846 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8026ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cd:	8b 40 0c             	mov    0xc(%eax),%eax
  8026d0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026d3:	0f 86 cf 00 00 00    	jbe    8027a8 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8026d9:	a1 48 41 80 00       	mov    0x804148,%eax
  8026de:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8026e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  8026e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8026ed:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  8026f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f3:	8b 50 08             	mov    0x8(%eax),%edx
  8026f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f9:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	8b 40 0c             	mov    0xc(%eax),%eax
  802702:	2b 45 08             	sub    0x8(%ebp),%eax
  802705:	89 c2                	mov    %eax,%edx
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  80270d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802710:	8b 50 08             	mov    0x8(%eax),%edx
  802713:	8b 45 08             	mov    0x8(%ebp),%eax
  802716:	01 c2                	add    %eax,%edx
  802718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271b:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80271e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802722:	75 17                	jne    80273b <alloc_block_NF+0x84>
  802724:	83 ec 04             	sub    $0x4,%esp
  802727:	68 49 3c 80 00       	push   $0x803c49
  80272c:	68 c4 00 00 00       	push   $0xc4
  802731:	68 d7 3b 80 00       	push   $0x803bd7
  802736:	e8 3c db ff ff       	call   800277 <_panic>
  80273b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273e:	8b 00                	mov    (%eax),%eax
  802740:	85 c0                	test   %eax,%eax
  802742:	74 10                	je     802754 <alloc_block_NF+0x9d>
  802744:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802747:	8b 00                	mov    (%eax),%eax
  802749:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80274c:	8b 52 04             	mov    0x4(%edx),%edx
  80274f:	89 50 04             	mov    %edx,0x4(%eax)
  802752:	eb 0b                	jmp    80275f <alloc_block_NF+0xa8>
  802754:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802757:	8b 40 04             	mov    0x4(%eax),%eax
  80275a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80275f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802762:	8b 40 04             	mov    0x4(%eax),%eax
  802765:	85 c0                	test   %eax,%eax
  802767:	74 0f                	je     802778 <alloc_block_NF+0xc1>
  802769:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276c:	8b 40 04             	mov    0x4(%eax),%eax
  80276f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802772:	8b 12                	mov    (%edx),%edx
  802774:	89 10                	mov    %edx,(%eax)
  802776:	eb 0a                	jmp    802782 <alloc_block_NF+0xcb>
  802778:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277b:	8b 00                	mov    (%eax),%eax
  80277d:	a3 48 41 80 00       	mov    %eax,0x804148
  802782:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802785:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80278b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80278e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802795:	a1 54 41 80 00       	mov    0x804154,%eax
  80279a:	48                   	dec    %eax
  80279b:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8027a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a3:	e9 ad 00 00 00       	jmp    802855 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8027a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ab:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ae:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027b1:	0f 85 87 00 00 00    	jne    80283e <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8027b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bb:	75 17                	jne    8027d4 <alloc_block_NF+0x11d>
  8027bd:	83 ec 04             	sub    $0x4,%esp
  8027c0:	68 49 3c 80 00       	push   $0x803c49
  8027c5:	68 c8 00 00 00       	push   $0xc8
  8027ca:	68 d7 3b 80 00       	push   $0x803bd7
  8027cf:	e8 a3 da ff ff       	call   800277 <_panic>
  8027d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d7:	8b 00                	mov    (%eax),%eax
  8027d9:	85 c0                	test   %eax,%eax
  8027db:	74 10                	je     8027ed <alloc_block_NF+0x136>
  8027dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e0:	8b 00                	mov    (%eax),%eax
  8027e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027e5:	8b 52 04             	mov    0x4(%edx),%edx
  8027e8:	89 50 04             	mov    %edx,0x4(%eax)
  8027eb:	eb 0b                	jmp    8027f8 <alloc_block_NF+0x141>
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 40 04             	mov    0x4(%eax),%eax
  8027f3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fb:	8b 40 04             	mov    0x4(%eax),%eax
  8027fe:	85 c0                	test   %eax,%eax
  802800:	74 0f                	je     802811 <alloc_block_NF+0x15a>
  802802:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802805:	8b 40 04             	mov    0x4(%eax),%eax
  802808:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80280b:	8b 12                	mov    (%edx),%edx
  80280d:	89 10                	mov    %edx,(%eax)
  80280f:	eb 0a                	jmp    80281b <alloc_block_NF+0x164>
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	8b 00                	mov    (%eax),%eax
  802816:	a3 38 41 80 00       	mov    %eax,0x804138
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802824:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802827:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80282e:	a1 44 41 80 00       	mov    0x804144,%eax
  802833:	48                   	dec    %eax
  802834:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802839:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283c:	eb 17                	jmp    802855 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	8b 00                	mov    (%eax),%eax
  802843:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802846:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80284a:	0f 85 7a fe ff ff    	jne    8026ca <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802850:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802855:	c9                   	leave  
  802856:	c3                   	ret    

00802857 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802857:	55                   	push   %ebp
  802858:	89 e5                	mov    %esp,%ebp
  80285a:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  80285d:	a1 38 41 80 00       	mov    0x804138,%eax
  802862:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802865:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80286a:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  80286d:	a1 44 41 80 00       	mov    0x804144,%eax
  802872:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802875:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802879:	75 68                	jne    8028e3 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80287b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80287f:	75 17                	jne    802898 <insert_sorted_with_merge_freeList+0x41>
  802881:	83 ec 04             	sub    $0x4,%esp
  802884:	68 b4 3b 80 00       	push   $0x803bb4
  802889:	68 da 00 00 00       	push   $0xda
  80288e:	68 d7 3b 80 00       	push   $0x803bd7
  802893:	e8 df d9 ff ff       	call   800277 <_panic>
  802898:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80289e:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a1:	89 10                	mov    %edx,(%eax)
  8028a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a6:	8b 00                	mov    (%eax),%eax
  8028a8:	85 c0                	test   %eax,%eax
  8028aa:	74 0d                	je     8028b9 <insert_sorted_with_merge_freeList+0x62>
  8028ac:	a1 38 41 80 00       	mov    0x804138,%eax
  8028b1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028b4:	89 50 04             	mov    %edx,0x4(%eax)
  8028b7:	eb 08                	jmp    8028c1 <insert_sorted_with_merge_freeList+0x6a>
  8028b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c4:	a3 38 41 80 00       	mov    %eax,0x804138
  8028c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028cc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028d3:	a1 44 41 80 00       	mov    0x804144,%eax
  8028d8:	40                   	inc    %eax
  8028d9:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  8028de:	e9 49 07 00 00       	jmp    80302c <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  8028e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e6:	8b 50 08             	mov    0x8(%eax),%edx
  8028e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ec:	8b 40 0c             	mov    0xc(%eax),%eax
  8028ef:	01 c2                	add    %eax,%edx
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	8b 40 08             	mov    0x8(%eax),%eax
  8028f7:	39 c2                	cmp    %eax,%edx
  8028f9:	73 77                	jae    802972 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  8028fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028fe:	8b 00                	mov    (%eax),%eax
  802900:	85 c0                	test   %eax,%eax
  802902:	75 6e                	jne    802972 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802904:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802908:	74 68                	je     802972 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  80290a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80290e:	75 17                	jne    802927 <insert_sorted_with_merge_freeList+0xd0>
  802910:	83 ec 04             	sub    $0x4,%esp
  802913:	68 f0 3b 80 00       	push   $0x803bf0
  802918:	68 e0 00 00 00       	push   $0xe0
  80291d:	68 d7 3b 80 00       	push   $0x803bd7
  802922:	e8 50 d9 ff ff       	call   800277 <_panic>
  802927:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80292d:	8b 45 08             	mov    0x8(%ebp),%eax
  802930:	89 50 04             	mov    %edx,0x4(%eax)
  802933:	8b 45 08             	mov    0x8(%ebp),%eax
  802936:	8b 40 04             	mov    0x4(%eax),%eax
  802939:	85 c0                	test   %eax,%eax
  80293b:	74 0c                	je     802949 <insert_sorted_with_merge_freeList+0xf2>
  80293d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802942:	8b 55 08             	mov    0x8(%ebp),%edx
  802945:	89 10                	mov    %edx,(%eax)
  802947:	eb 08                	jmp    802951 <insert_sorted_with_merge_freeList+0xfa>
  802949:	8b 45 08             	mov    0x8(%ebp),%eax
  80294c:	a3 38 41 80 00       	mov    %eax,0x804138
  802951:	8b 45 08             	mov    0x8(%ebp),%eax
  802954:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802959:	8b 45 08             	mov    0x8(%ebp),%eax
  80295c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802962:	a1 44 41 80 00       	mov    0x804144,%eax
  802967:	40                   	inc    %eax
  802968:	a3 44 41 80 00       	mov    %eax,0x804144
  80296d:	e9 ba 06 00 00       	jmp    80302c <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	8b 50 0c             	mov    0xc(%eax),%edx
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	8b 40 08             	mov    0x8(%eax),%eax
  80297e:	01 c2                	add    %eax,%edx
  802980:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802983:	8b 40 08             	mov    0x8(%eax),%eax
  802986:	39 c2                	cmp    %eax,%edx
  802988:	73 78                	jae    802a02 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  80298a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298d:	8b 40 04             	mov    0x4(%eax),%eax
  802990:	85 c0                	test   %eax,%eax
  802992:	75 6e                	jne    802a02 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802994:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802998:	74 68                	je     802a02 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80299a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80299e:	75 17                	jne    8029b7 <insert_sorted_with_merge_freeList+0x160>
  8029a0:	83 ec 04             	sub    $0x4,%esp
  8029a3:	68 b4 3b 80 00       	push   $0x803bb4
  8029a8:	68 e6 00 00 00       	push   $0xe6
  8029ad:	68 d7 3b 80 00       	push   $0x803bd7
  8029b2:	e8 c0 d8 ff ff       	call   800277 <_panic>
  8029b7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c0:	89 10                	mov    %edx,(%eax)
  8029c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c5:	8b 00                	mov    (%eax),%eax
  8029c7:	85 c0                	test   %eax,%eax
  8029c9:	74 0d                	je     8029d8 <insert_sorted_with_merge_freeList+0x181>
  8029cb:	a1 38 41 80 00       	mov    0x804138,%eax
  8029d0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029d3:	89 50 04             	mov    %edx,0x4(%eax)
  8029d6:	eb 08                	jmp    8029e0 <insert_sorted_with_merge_freeList+0x189>
  8029d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029db:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e3:	a3 38 41 80 00       	mov    %eax,0x804138
  8029e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029eb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f2:	a1 44 41 80 00       	mov    0x804144,%eax
  8029f7:	40                   	inc    %eax
  8029f8:	a3 44 41 80 00       	mov    %eax,0x804144
  8029fd:	e9 2a 06 00 00       	jmp    80302c <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802a02:	a1 38 41 80 00       	mov    0x804138,%eax
  802a07:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a0a:	e9 ed 05 00 00       	jmp    802ffc <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802a0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a12:	8b 00                	mov    (%eax),%eax
  802a14:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802a17:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a1b:	0f 84 a7 00 00 00    	je     802ac8 <insert_sorted_with_merge_freeList+0x271>
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 50 0c             	mov    0xc(%eax),%edx
  802a27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2a:	8b 40 08             	mov    0x8(%eax),%eax
  802a2d:	01 c2                	add    %eax,%edx
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	8b 40 08             	mov    0x8(%eax),%eax
  802a35:	39 c2                	cmp    %eax,%edx
  802a37:	0f 83 8b 00 00 00    	jae    802ac8 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	8b 50 0c             	mov    0xc(%eax),%edx
  802a43:	8b 45 08             	mov    0x8(%ebp),%eax
  802a46:	8b 40 08             	mov    0x8(%eax),%eax
  802a49:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802a4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a4e:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802a51:	39 c2                	cmp    %eax,%edx
  802a53:	73 73                	jae    802ac8 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802a55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a59:	74 06                	je     802a61 <insert_sorted_with_merge_freeList+0x20a>
  802a5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a5f:	75 17                	jne    802a78 <insert_sorted_with_merge_freeList+0x221>
  802a61:	83 ec 04             	sub    $0x4,%esp
  802a64:	68 68 3c 80 00       	push   $0x803c68
  802a69:	68 f0 00 00 00       	push   $0xf0
  802a6e:	68 d7 3b 80 00       	push   $0x803bd7
  802a73:	e8 ff d7 ff ff       	call   800277 <_panic>
  802a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7b:	8b 10                	mov    (%eax),%edx
  802a7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a80:	89 10                	mov    %edx,(%eax)
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	8b 00                	mov    (%eax),%eax
  802a87:	85 c0                	test   %eax,%eax
  802a89:	74 0b                	je     802a96 <insert_sorted_with_merge_freeList+0x23f>
  802a8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a8e:	8b 00                	mov    (%eax),%eax
  802a90:	8b 55 08             	mov    0x8(%ebp),%edx
  802a93:	89 50 04             	mov    %edx,0x4(%eax)
  802a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a99:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9c:	89 10                	mov    %edx,(%eax)
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802aa4:	89 50 04             	mov    %edx,0x4(%eax)
  802aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aaa:	8b 00                	mov    (%eax),%eax
  802aac:	85 c0                	test   %eax,%eax
  802aae:	75 08                	jne    802ab8 <insert_sorted_with_merge_freeList+0x261>
  802ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab3:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ab8:	a1 44 41 80 00       	mov    0x804144,%eax
  802abd:	40                   	inc    %eax
  802abe:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802ac3:	e9 64 05 00 00       	jmp    80302c <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802ac8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802acd:	8b 50 0c             	mov    0xc(%eax),%edx
  802ad0:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ad5:	8b 40 08             	mov    0x8(%eax),%eax
  802ad8:	01 c2                	add    %eax,%edx
  802ada:	8b 45 08             	mov    0x8(%ebp),%eax
  802add:	8b 40 08             	mov    0x8(%eax),%eax
  802ae0:	39 c2                	cmp    %eax,%edx
  802ae2:	0f 85 b1 00 00 00    	jne    802b99 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802ae8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	0f 84 a4 00 00 00    	je     802b99 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802af5:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802afa:	8b 00                	mov    (%eax),%eax
  802afc:	85 c0                	test   %eax,%eax
  802afe:	0f 85 95 00 00 00    	jne    802b99 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802b04:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b09:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b0f:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b12:	8b 55 08             	mov    0x8(%ebp),%edx
  802b15:	8b 52 0c             	mov    0xc(%edx),%edx
  802b18:	01 ca                	add    %ecx,%edx
  802b1a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b20:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802b27:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802b31:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b35:	75 17                	jne    802b4e <insert_sorted_with_merge_freeList+0x2f7>
  802b37:	83 ec 04             	sub    $0x4,%esp
  802b3a:	68 b4 3b 80 00       	push   $0x803bb4
  802b3f:	68 ff 00 00 00       	push   $0xff
  802b44:	68 d7 3b 80 00       	push   $0x803bd7
  802b49:	e8 29 d7 ff ff       	call   800277 <_panic>
  802b4e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b54:	8b 45 08             	mov    0x8(%ebp),%eax
  802b57:	89 10                	mov    %edx,(%eax)
  802b59:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5c:	8b 00                	mov    (%eax),%eax
  802b5e:	85 c0                	test   %eax,%eax
  802b60:	74 0d                	je     802b6f <insert_sorted_with_merge_freeList+0x318>
  802b62:	a1 48 41 80 00       	mov    0x804148,%eax
  802b67:	8b 55 08             	mov    0x8(%ebp),%edx
  802b6a:	89 50 04             	mov    %edx,0x4(%eax)
  802b6d:	eb 08                	jmp    802b77 <insert_sorted_with_merge_freeList+0x320>
  802b6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b72:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b77:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7a:	a3 48 41 80 00       	mov    %eax,0x804148
  802b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b82:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b89:	a1 54 41 80 00       	mov    0x804154,%eax
  802b8e:	40                   	inc    %eax
  802b8f:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802b94:	e9 93 04 00 00       	jmp    80302c <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 50 08             	mov    0x8(%eax),%edx
  802b9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba5:	01 c2                	add    %eax,%edx
  802ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  802baa:	8b 40 08             	mov    0x8(%eax),%eax
  802bad:	39 c2                	cmp    %eax,%edx
  802baf:	0f 85 ae 00 00 00    	jne    802c63 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	8b 50 0c             	mov    0xc(%eax),%edx
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	8b 40 08             	mov    0x8(%eax),%eax
  802bc1:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802bc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc6:	8b 00                	mov    (%eax),%eax
  802bc8:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802bcb:	39 c2                	cmp    %eax,%edx
  802bcd:	0f 84 90 00 00 00    	je     802c63 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802bd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd6:	8b 50 0c             	mov    0xc(%eax),%edx
  802bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdc:	8b 40 0c             	mov    0xc(%eax),%eax
  802bdf:	01 c2                	add    %eax,%edx
  802be1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be4:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802be7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bea:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802bfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bff:	75 17                	jne    802c18 <insert_sorted_with_merge_freeList+0x3c1>
  802c01:	83 ec 04             	sub    $0x4,%esp
  802c04:	68 b4 3b 80 00       	push   $0x803bb4
  802c09:	68 0b 01 00 00       	push   $0x10b
  802c0e:	68 d7 3b 80 00       	push   $0x803bd7
  802c13:	e8 5f d6 ff ff       	call   800277 <_panic>
  802c18:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	89 10                	mov    %edx,(%eax)
  802c23:	8b 45 08             	mov    0x8(%ebp),%eax
  802c26:	8b 00                	mov    (%eax),%eax
  802c28:	85 c0                	test   %eax,%eax
  802c2a:	74 0d                	je     802c39 <insert_sorted_with_merge_freeList+0x3e2>
  802c2c:	a1 48 41 80 00       	mov    0x804148,%eax
  802c31:	8b 55 08             	mov    0x8(%ebp),%edx
  802c34:	89 50 04             	mov    %edx,0x4(%eax)
  802c37:	eb 08                	jmp    802c41 <insert_sorted_with_merge_freeList+0x3ea>
  802c39:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c41:	8b 45 08             	mov    0x8(%ebp),%eax
  802c44:	a3 48 41 80 00       	mov    %eax,0x804148
  802c49:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c53:	a1 54 41 80 00       	mov    0x804154,%eax
  802c58:	40                   	inc    %eax
  802c59:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802c5e:	e9 c9 03 00 00       	jmp    80302c <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802c63:	8b 45 08             	mov    0x8(%ebp),%eax
  802c66:	8b 50 0c             	mov    0xc(%eax),%edx
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	8b 40 08             	mov    0x8(%eax),%eax
  802c6f:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802c71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c74:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802c77:	39 c2                	cmp    %eax,%edx
  802c79:	0f 85 bb 00 00 00    	jne    802d3a <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802c7f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c83:	0f 84 b1 00 00 00    	je     802d3a <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802c89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8c:	8b 40 04             	mov    0x4(%eax),%eax
  802c8f:	85 c0                	test   %eax,%eax
  802c91:	0f 85 a3 00 00 00    	jne    802d3a <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802c97:	a1 38 41 80 00       	mov    0x804138,%eax
  802c9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9f:	8b 52 08             	mov    0x8(%edx),%edx
  802ca2:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802ca5:	a1 38 41 80 00       	mov    0x804138,%eax
  802caa:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cb0:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802cb3:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb6:	8b 52 0c             	mov    0xc(%edx),%edx
  802cb9:	01 ca                	add    %ecx,%edx
  802cbb:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802cc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802cd2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd6:	75 17                	jne    802cef <insert_sorted_with_merge_freeList+0x498>
  802cd8:	83 ec 04             	sub    $0x4,%esp
  802cdb:	68 b4 3b 80 00       	push   $0x803bb4
  802ce0:	68 17 01 00 00       	push   $0x117
  802ce5:	68 d7 3b 80 00       	push   $0x803bd7
  802cea:	e8 88 d5 ff ff       	call   800277 <_panic>
  802cef:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf8:	89 10                	mov    %edx,(%eax)
  802cfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfd:	8b 00                	mov    (%eax),%eax
  802cff:	85 c0                	test   %eax,%eax
  802d01:	74 0d                	je     802d10 <insert_sorted_with_merge_freeList+0x4b9>
  802d03:	a1 48 41 80 00       	mov    0x804148,%eax
  802d08:	8b 55 08             	mov    0x8(%ebp),%edx
  802d0b:	89 50 04             	mov    %edx,0x4(%eax)
  802d0e:	eb 08                	jmp    802d18 <insert_sorted_with_merge_freeList+0x4c1>
  802d10:	8b 45 08             	mov    0x8(%ebp),%eax
  802d13:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	a3 48 41 80 00       	mov    %eax,0x804148
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d2a:	a1 54 41 80 00       	mov    0x804154,%eax
  802d2f:	40                   	inc    %eax
  802d30:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d35:	e9 f2 02 00 00       	jmp    80302c <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	8b 50 08             	mov    0x8(%eax),%edx
  802d40:	8b 45 08             	mov    0x8(%ebp),%eax
  802d43:	8b 40 0c             	mov    0xc(%eax),%eax
  802d46:	01 c2                	add    %eax,%edx
  802d48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4b:	8b 40 08             	mov    0x8(%eax),%eax
  802d4e:	39 c2                	cmp    %eax,%edx
  802d50:	0f 85 be 00 00 00    	jne    802e14 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d59:	8b 40 04             	mov    0x4(%eax),%eax
  802d5c:	8b 50 08             	mov    0x8(%eax),%edx
  802d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d62:	8b 40 04             	mov    0x4(%eax),%eax
  802d65:	8b 40 0c             	mov    0xc(%eax),%eax
  802d68:	01 c2                	add    %eax,%edx
  802d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6d:	8b 40 08             	mov    0x8(%eax),%eax
  802d70:	39 c2                	cmp    %eax,%edx
  802d72:	0f 84 9c 00 00 00    	je     802e14 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802d78:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7b:	8b 50 08             	mov    0x8(%eax),%edx
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802d84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d87:	8b 50 0c             	mov    0xc(%eax),%edx
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d90:	01 c2                	add    %eax,%edx
  802d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d95:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802da2:	8b 45 08             	mov    0x8(%ebp),%eax
  802da5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802dac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db0:	75 17                	jne    802dc9 <insert_sorted_with_merge_freeList+0x572>
  802db2:	83 ec 04             	sub    $0x4,%esp
  802db5:	68 b4 3b 80 00       	push   $0x803bb4
  802dba:	68 26 01 00 00       	push   $0x126
  802dbf:	68 d7 3b 80 00       	push   $0x803bd7
  802dc4:	e8 ae d4 ff ff       	call   800277 <_panic>
  802dc9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	89 10                	mov    %edx,(%eax)
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	8b 00                	mov    (%eax),%eax
  802dd9:	85 c0                	test   %eax,%eax
  802ddb:	74 0d                	je     802dea <insert_sorted_with_merge_freeList+0x593>
  802ddd:	a1 48 41 80 00       	mov    0x804148,%eax
  802de2:	8b 55 08             	mov    0x8(%ebp),%edx
  802de5:	89 50 04             	mov    %edx,0x4(%eax)
  802de8:	eb 08                	jmp    802df2 <insert_sorted_with_merge_freeList+0x59b>
  802dea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ded:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802df2:	8b 45 08             	mov    0x8(%ebp),%eax
  802df5:	a3 48 41 80 00       	mov    %eax,0x804148
  802dfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e04:	a1 54 41 80 00       	mov    0x804154,%eax
  802e09:	40                   	inc    %eax
  802e0a:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802e0f:	e9 18 02 00 00       	jmp    80302c <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	8b 50 0c             	mov    0xc(%eax),%edx
  802e1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1d:	8b 40 08             	mov    0x8(%eax),%eax
  802e20:	01 c2                	add    %eax,%edx
  802e22:	8b 45 08             	mov    0x8(%ebp),%eax
  802e25:	8b 40 08             	mov    0x8(%eax),%eax
  802e28:	39 c2                	cmp    %eax,%edx
  802e2a:	0f 85 c4 01 00 00    	jne    802ff4 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	8b 50 0c             	mov    0xc(%eax),%edx
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	8b 40 08             	mov    0x8(%eax),%eax
  802e3c:	01 c2                	add    %eax,%edx
  802e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e41:	8b 00                	mov    (%eax),%eax
  802e43:	8b 40 08             	mov    0x8(%eax),%eax
  802e46:	39 c2                	cmp    %eax,%edx
  802e48:	0f 85 a6 01 00 00    	jne    802ff4 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802e4e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e52:	0f 84 9c 01 00 00    	je     802ff4 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802e58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5b:	8b 50 0c             	mov    0xc(%eax),%edx
  802e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e61:	8b 40 0c             	mov    0xc(%eax),%eax
  802e64:	01 c2                	add    %eax,%edx
  802e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e69:	8b 00                	mov    (%eax),%eax
  802e6b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6e:	01 c2                	add    %eax,%edx
  802e70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e73:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802e76:	8b 45 08             	mov    0x8(%ebp),%eax
  802e79:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802e80:	8b 45 08             	mov    0x8(%ebp),%eax
  802e83:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802e8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e8e:	75 17                	jne    802ea7 <insert_sorted_with_merge_freeList+0x650>
  802e90:	83 ec 04             	sub    $0x4,%esp
  802e93:	68 b4 3b 80 00       	push   $0x803bb4
  802e98:	68 32 01 00 00       	push   $0x132
  802e9d:	68 d7 3b 80 00       	push   $0x803bd7
  802ea2:	e8 d0 d3 ff ff       	call   800277 <_panic>
  802ea7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ead:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb0:	89 10                	mov    %edx,(%eax)
  802eb2:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb5:	8b 00                	mov    (%eax),%eax
  802eb7:	85 c0                	test   %eax,%eax
  802eb9:	74 0d                	je     802ec8 <insert_sorted_with_merge_freeList+0x671>
  802ebb:	a1 48 41 80 00       	mov    0x804148,%eax
  802ec0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ec3:	89 50 04             	mov    %edx,0x4(%eax)
  802ec6:	eb 08                	jmp    802ed0 <insert_sorted_with_merge_freeList+0x679>
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	a3 48 41 80 00       	mov    %eax,0x804148
  802ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  802edb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee2:	a1 54 41 80 00       	mov    0x804154,%eax
  802ee7:	40                   	inc    %eax
  802ee8:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802ef9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802efc:	8b 00                	mov    (%eax),%eax
  802efe:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802f05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f08:	8b 00                	mov    (%eax),%eax
  802f0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802f0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f11:	75 17                	jne    802f2a <insert_sorted_with_merge_freeList+0x6d3>
  802f13:	83 ec 04             	sub    $0x4,%esp
  802f16:	68 49 3c 80 00       	push   $0x803c49
  802f1b:	68 36 01 00 00       	push   $0x136
  802f20:	68 d7 3b 80 00       	push   $0x803bd7
  802f25:	e8 4d d3 ff ff       	call   800277 <_panic>
  802f2a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f2d:	8b 00                	mov    (%eax),%eax
  802f2f:	85 c0                	test   %eax,%eax
  802f31:	74 10                	je     802f43 <insert_sorted_with_merge_freeList+0x6ec>
  802f33:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f36:	8b 00                	mov    (%eax),%eax
  802f38:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f3b:	8b 52 04             	mov    0x4(%edx),%edx
  802f3e:	89 50 04             	mov    %edx,0x4(%eax)
  802f41:	eb 0b                	jmp    802f4e <insert_sorted_with_merge_freeList+0x6f7>
  802f43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f46:	8b 40 04             	mov    0x4(%eax),%eax
  802f49:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f4e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f51:	8b 40 04             	mov    0x4(%eax),%eax
  802f54:	85 c0                	test   %eax,%eax
  802f56:	74 0f                	je     802f67 <insert_sorted_with_merge_freeList+0x710>
  802f58:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f5b:	8b 40 04             	mov    0x4(%eax),%eax
  802f5e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f61:	8b 12                	mov    (%edx),%edx
  802f63:	89 10                	mov    %edx,(%eax)
  802f65:	eb 0a                	jmp    802f71 <insert_sorted_with_merge_freeList+0x71a>
  802f67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f6a:	8b 00                	mov    (%eax),%eax
  802f6c:	a3 38 41 80 00       	mov    %eax,0x804138
  802f71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f74:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f7d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f84:	a1 44 41 80 00       	mov    0x804144,%eax
  802f89:	48                   	dec    %eax
  802f8a:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  802f8f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f93:	75 17                	jne    802fac <insert_sorted_with_merge_freeList+0x755>
  802f95:	83 ec 04             	sub    $0x4,%esp
  802f98:	68 b4 3b 80 00       	push   $0x803bb4
  802f9d:	68 37 01 00 00       	push   $0x137
  802fa2:	68 d7 3b 80 00       	push   $0x803bd7
  802fa7:	e8 cb d2 ff ff       	call   800277 <_panic>
  802fac:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb5:	89 10                	mov    %edx,(%eax)
  802fb7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fba:	8b 00                	mov    (%eax),%eax
  802fbc:	85 c0                	test   %eax,%eax
  802fbe:	74 0d                	je     802fcd <insert_sorted_with_merge_freeList+0x776>
  802fc0:	a1 48 41 80 00       	mov    0x804148,%eax
  802fc5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fc8:	89 50 04             	mov    %edx,0x4(%eax)
  802fcb:	eb 08                	jmp    802fd5 <insert_sorted_with_merge_freeList+0x77e>
  802fcd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fd5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd8:	a3 48 41 80 00       	mov    %eax,0x804148
  802fdd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe7:	a1 54 41 80 00       	mov    0x804154,%eax
  802fec:	40                   	inc    %eax
  802fed:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  802ff2:	eb 38                	jmp    80302c <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802ff4:	a1 40 41 80 00       	mov    0x804140,%eax
  802ff9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ffc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803000:	74 07                	je     803009 <insert_sorted_with_merge_freeList+0x7b2>
  803002:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803005:	8b 00                	mov    (%eax),%eax
  803007:	eb 05                	jmp    80300e <insert_sorted_with_merge_freeList+0x7b7>
  803009:	b8 00 00 00 00       	mov    $0x0,%eax
  80300e:	a3 40 41 80 00       	mov    %eax,0x804140
  803013:	a1 40 41 80 00       	mov    0x804140,%eax
  803018:	85 c0                	test   %eax,%eax
  80301a:	0f 85 ef f9 ff ff    	jne    802a0f <insert_sorted_with_merge_freeList+0x1b8>
  803020:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803024:	0f 85 e5 f9 ff ff    	jne    802a0f <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  80302a:	eb 00                	jmp    80302c <insert_sorted_with_merge_freeList+0x7d5>
  80302c:	90                   	nop
  80302d:	c9                   	leave  
  80302e:	c3                   	ret    

0080302f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80302f:	55                   	push   %ebp
  803030:	89 e5                	mov    %esp,%ebp
  803032:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803035:	8b 55 08             	mov    0x8(%ebp),%edx
  803038:	89 d0                	mov    %edx,%eax
  80303a:	c1 e0 02             	shl    $0x2,%eax
  80303d:	01 d0                	add    %edx,%eax
  80303f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803046:	01 d0                	add    %edx,%eax
  803048:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80304f:	01 d0                	add    %edx,%eax
  803051:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803058:	01 d0                	add    %edx,%eax
  80305a:	c1 e0 04             	shl    $0x4,%eax
  80305d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803060:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803067:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80306a:	83 ec 0c             	sub    $0xc,%esp
  80306d:	50                   	push   %eax
  80306e:	e8 21 ec ff ff       	call   801c94 <sys_get_virtual_time>
  803073:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803076:	eb 41                	jmp    8030b9 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803078:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80307b:	83 ec 0c             	sub    $0xc,%esp
  80307e:	50                   	push   %eax
  80307f:	e8 10 ec ff ff       	call   801c94 <sys_get_virtual_time>
  803084:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803087:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80308a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80308d:	29 c2                	sub    %eax,%edx
  80308f:	89 d0                	mov    %edx,%eax
  803091:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803094:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309a:	89 d1                	mov    %edx,%ecx
  80309c:	29 c1                	sub    %eax,%ecx
  80309e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030a4:	39 c2                	cmp    %eax,%edx
  8030a6:	0f 97 c0             	seta   %al
  8030a9:	0f b6 c0             	movzbl %al,%eax
  8030ac:	29 c1                	sub    %eax,%ecx
  8030ae:	89 c8                	mov    %ecx,%eax
  8030b0:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8030b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8030b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030bc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030bf:	72 b7                	jb     803078 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8030c1:	90                   	nop
  8030c2:	c9                   	leave  
  8030c3:	c3                   	ret    

008030c4 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8030c4:	55                   	push   %ebp
  8030c5:	89 e5                	mov    %esp,%ebp
  8030c7:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8030ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8030d1:	eb 03                	jmp    8030d6 <busy_wait+0x12>
  8030d3:	ff 45 fc             	incl   -0x4(%ebp)
  8030d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030dc:	72 f5                	jb     8030d3 <busy_wait+0xf>
	return i;
  8030de:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8030e1:	c9                   	leave  
  8030e2:	c3                   	ret    
  8030e3:	90                   	nop

008030e4 <__udivdi3>:
  8030e4:	55                   	push   %ebp
  8030e5:	57                   	push   %edi
  8030e6:	56                   	push   %esi
  8030e7:	53                   	push   %ebx
  8030e8:	83 ec 1c             	sub    $0x1c,%esp
  8030eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8030f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8030fb:	89 ca                	mov    %ecx,%edx
  8030fd:	89 f8                	mov    %edi,%eax
  8030ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803103:	85 f6                	test   %esi,%esi
  803105:	75 2d                	jne    803134 <__udivdi3+0x50>
  803107:	39 cf                	cmp    %ecx,%edi
  803109:	77 65                	ja     803170 <__udivdi3+0x8c>
  80310b:	89 fd                	mov    %edi,%ebp
  80310d:	85 ff                	test   %edi,%edi
  80310f:	75 0b                	jne    80311c <__udivdi3+0x38>
  803111:	b8 01 00 00 00       	mov    $0x1,%eax
  803116:	31 d2                	xor    %edx,%edx
  803118:	f7 f7                	div    %edi
  80311a:	89 c5                	mov    %eax,%ebp
  80311c:	31 d2                	xor    %edx,%edx
  80311e:	89 c8                	mov    %ecx,%eax
  803120:	f7 f5                	div    %ebp
  803122:	89 c1                	mov    %eax,%ecx
  803124:	89 d8                	mov    %ebx,%eax
  803126:	f7 f5                	div    %ebp
  803128:	89 cf                	mov    %ecx,%edi
  80312a:	89 fa                	mov    %edi,%edx
  80312c:	83 c4 1c             	add    $0x1c,%esp
  80312f:	5b                   	pop    %ebx
  803130:	5e                   	pop    %esi
  803131:	5f                   	pop    %edi
  803132:	5d                   	pop    %ebp
  803133:	c3                   	ret    
  803134:	39 ce                	cmp    %ecx,%esi
  803136:	77 28                	ja     803160 <__udivdi3+0x7c>
  803138:	0f bd fe             	bsr    %esi,%edi
  80313b:	83 f7 1f             	xor    $0x1f,%edi
  80313e:	75 40                	jne    803180 <__udivdi3+0x9c>
  803140:	39 ce                	cmp    %ecx,%esi
  803142:	72 0a                	jb     80314e <__udivdi3+0x6a>
  803144:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803148:	0f 87 9e 00 00 00    	ja     8031ec <__udivdi3+0x108>
  80314e:	b8 01 00 00 00       	mov    $0x1,%eax
  803153:	89 fa                	mov    %edi,%edx
  803155:	83 c4 1c             	add    $0x1c,%esp
  803158:	5b                   	pop    %ebx
  803159:	5e                   	pop    %esi
  80315a:	5f                   	pop    %edi
  80315b:	5d                   	pop    %ebp
  80315c:	c3                   	ret    
  80315d:	8d 76 00             	lea    0x0(%esi),%esi
  803160:	31 ff                	xor    %edi,%edi
  803162:	31 c0                	xor    %eax,%eax
  803164:	89 fa                	mov    %edi,%edx
  803166:	83 c4 1c             	add    $0x1c,%esp
  803169:	5b                   	pop    %ebx
  80316a:	5e                   	pop    %esi
  80316b:	5f                   	pop    %edi
  80316c:	5d                   	pop    %ebp
  80316d:	c3                   	ret    
  80316e:	66 90                	xchg   %ax,%ax
  803170:	89 d8                	mov    %ebx,%eax
  803172:	f7 f7                	div    %edi
  803174:	31 ff                	xor    %edi,%edi
  803176:	89 fa                	mov    %edi,%edx
  803178:	83 c4 1c             	add    $0x1c,%esp
  80317b:	5b                   	pop    %ebx
  80317c:	5e                   	pop    %esi
  80317d:	5f                   	pop    %edi
  80317e:	5d                   	pop    %ebp
  80317f:	c3                   	ret    
  803180:	bd 20 00 00 00       	mov    $0x20,%ebp
  803185:	89 eb                	mov    %ebp,%ebx
  803187:	29 fb                	sub    %edi,%ebx
  803189:	89 f9                	mov    %edi,%ecx
  80318b:	d3 e6                	shl    %cl,%esi
  80318d:	89 c5                	mov    %eax,%ebp
  80318f:	88 d9                	mov    %bl,%cl
  803191:	d3 ed                	shr    %cl,%ebp
  803193:	89 e9                	mov    %ebp,%ecx
  803195:	09 f1                	or     %esi,%ecx
  803197:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80319b:	89 f9                	mov    %edi,%ecx
  80319d:	d3 e0                	shl    %cl,%eax
  80319f:	89 c5                	mov    %eax,%ebp
  8031a1:	89 d6                	mov    %edx,%esi
  8031a3:	88 d9                	mov    %bl,%cl
  8031a5:	d3 ee                	shr    %cl,%esi
  8031a7:	89 f9                	mov    %edi,%ecx
  8031a9:	d3 e2                	shl    %cl,%edx
  8031ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031af:	88 d9                	mov    %bl,%cl
  8031b1:	d3 e8                	shr    %cl,%eax
  8031b3:	09 c2                	or     %eax,%edx
  8031b5:	89 d0                	mov    %edx,%eax
  8031b7:	89 f2                	mov    %esi,%edx
  8031b9:	f7 74 24 0c          	divl   0xc(%esp)
  8031bd:	89 d6                	mov    %edx,%esi
  8031bf:	89 c3                	mov    %eax,%ebx
  8031c1:	f7 e5                	mul    %ebp
  8031c3:	39 d6                	cmp    %edx,%esi
  8031c5:	72 19                	jb     8031e0 <__udivdi3+0xfc>
  8031c7:	74 0b                	je     8031d4 <__udivdi3+0xf0>
  8031c9:	89 d8                	mov    %ebx,%eax
  8031cb:	31 ff                	xor    %edi,%edi
  8031cd:	e9 58 ff ff ff       	jmp    80312a <__udivdi3+0x46>
  8031d2:	66 90                	xchg   %ax,%ax
  8031d4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031d8:	89 f9                	mov    %edi,%ecx
  8031da:	d3 e2                	shl    %cl,%edx
  8031dc:	39 c2                	cmp    %eax,%edx
  8031de:	73 e9                	jae    8031c9 <__udivdi3+0xe5>
  8031e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031e3:	31 ff                	xor    %edi,%edi
  8031e5:	e9 40 ff ff ff       	jmp    80312a <__udivdi3+0x46>
  8031ea:	66 90                	xchg   %ax,%ax
  8031ec:	31 c0                	xor    %eax,%eax
  8031ee:	e9 37 ff ff ff       	jmp    80312a <__udivdi3+0x46>
  8031f3:	90                   	nop

008031f4 <__umoddi3>:
  8031f4:	55                   	push   %ebp
  8031f5:	57                   	push   %edi
  8031f6:	56                   	push   %esi
  8031f7:	53                   	push   %ebx
  8031f8:	83 ec 1c             	sub    $0x1c,%esp
  8031fb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8031ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803203:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803207:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80320b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80320f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803213:	89 f3                	mov    %esi,%ebx
  803215:	89 fa                	mov    %edi,%edx
  803217:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80321b:	89 34 24             	mov    %esi,(%esp)
  80321e:	85 c0                	test   %eax,%eax
  803220:	75 1a                	jne    80323c <__umoddi3+0x48>
  803222:	39 f7                	cmp    %esi,%edi
  803224:	0f 86 a2 00 00 00    	jbe    8032cc <__umoddi3+0xd8>
  80322a:	89 c8                	mov    %ecx,%eax
  80322c:	89 f2                	mov    %esi,%edx
  80322e:	f7 f7                	div    %edi
  803230:	89 d0                	mov    %edx,%eax
  803232:	31 d2                	xor    %edx,%edx
  803234:	83 c4 1c             	add    $0x1c,%esp
  803237:	5b                   	pop    %ebx
  803238:	5e                   	pop    %esi
  803239:	5f                   	pop    %edi
  80323a:	5d                   	pop    %ebp
  80323b:	c3                   	ret    
  80323c:	39 f0                	cmp    %esi,%eax
  80323e:	0f 87 ac 00 00 00    	ja     8032f0 <__umoddi3+0xfc>
  803244:	0f bd e8             	bsr    %eax,%ebp
  803247:	83 f5 1f             	xor    $0x1f,%ebp
  80324a:	0f 84 ac 00 00 00    	je     8032fc <__umoddi3+0x108>
  803250:	bf 20 00 00 00       	mov    $0x20,%edi
  803255:	29 ef                	sub    %ebp,%edi
  803257:	89 fe                	mov    %edi,%esi
  803259:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80325d:	89 e9                	mov    %ebp,%ecx
  80325f:	d3 e0                	shl    %cl,%eax
  803261:	89 d7                	mov    %edx,%edi
  803263:	89 f1                	mov    %esi,%ecx
  803265:	d3 ef                	shr    %cl,%edi
  803267:	09 c7                	or     %eax,%edi
  803269:	89 e9                	mov    %ebp,%ecx
  80326b:	d3 e2                	shl    %cl,%edx
  80326d:	89 14 24             	mov    %edx,(%esp)
  803270:	89 d8                	mov    %ebx,%eax
  803272:	d3 e0                	shl    %cl,%eax
  803274:	89 c2                	mov    %eax,%edx
  803276:	8b 44 24 08          	mov    0x8(%esp),%eax
  80327a:	d3 e0                	shl    %cl,%eax
  80327c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803280:	8b 44 24 08          	mov    0x8(%esp),%eax
  803284:	89 f1                	mov    %esi,%ecx
  803286:	d3 e8                	shr    %cl,%eax
  803288:	09 d0                	or     %edx,%eax
  80328a:	d3 eb                	shr    %cl,%ebx
  80328c:	89 da                	mov    %ebx,%edx
  80328e:	f7 f7                	div    %edi
  803290:	89 d3                	mov    %edx,%ebx
  803292:	f7 24 24             	mull   (%esp)
  803295:	89 c6                	mov    %eax,%esi
  803297:	89 d1                	mov    %edx,%ecx
  803299:	39 d3                	cmp    %edx,%ebx
  80329b:	0f 82 87 00 00 00    	jb     803328 <__umoddi3+0x134>
  8032a1:	0f 84 91 00 00 00    	je     803338 <__umoddi3+0x144>
  8032a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032ab:	29 f2                	sub    %esi,%edx
  8032ad:	19 cb                	sbb    %ecx,%ebx
  8032af:	89 d8                	mov    %ebx,%eax
  8032b1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032b5:	d3 e0                	shl    %cl,%eax
  8032b7:	89 e9                	mov    %ebp,%ecx
  8032b9:	d3 ea                	shr    %cl,%edx
  8032bb:	09 d0                	or     %edx,%eax
  8032bd:	89 e9                	mov    %ebp,%ecx
  8032bf:	d3 eb                	shr    %cl,%ebx
  8032c1:	89 da                	mov    %ebx,%edx
  8032c3:	83 c4 1c             	add    $0x1c,%esp
  8032c6:	5b                   	pop    %ebx
  8032c7:	5e                   	pop    %esi
  8032c8:	5f                   	pop    %edi
  8032c9:	5d                   	pop    %ebp
  8032ca:	c3                   	ret    
  8032cb:	90                   	nop
  8032cc:	89 fd                	mov    %edi,%ebp
  8032ce:	85 ff                	test   %edi,%edi
  8032d0:	75 0b                	jne    8032dd <__umoddi3+0xe9>
  8032d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8032d7:	31 d2                	xor    %edx,%edx
  8032d9:	f7 f7                	div    %edi
  8032db:	89 c5                	mov    %eax,%ebp
  8032dd:	89 f0                	mov    %esi,%eax
  8032df:	31 d2                	xor    %edx,%edx
  8032e1:	f7 f5                	div    %ebp
  8032e3:	89 c8                	mov    %ecx,%eax
  8032e5:	f7 f5                	div    %ebp
  8032e7:	89 d0                	mov    %edx,%eax
  8032e9:	e9 44 ff ff ff       	jmp    803232 <__umoddi3+0x3e>
  8032ee:	66 90                	xchg   %ax,%ax
  8032f0:	89 c8                	mov    %ecx,%eax
  8032f2:	89 f2                	mov    %esi,%edx
  8032f4:	83 c4 1c             	add    $0x1c,%esp
  8032f7:	5b                   	pop    %ebx
  8032f8:	5e                   	pop    %esi
  8032f9:	5f                   	pop    %edi
  8032fa:	5d                   	pop    %ebp
  8032fb:	c3                   	ret    
  8032fc:	3b 04 24             	cmp    (%esp),%eax
  8032ff:	72 06                	jb     803307 <__umoddi3+0x113>
  803301:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803305:	77 0f                	ja     803316 <__umoddi3+0x122>
  803307:	89 f2                	mov    %esi,%edx
  803309:	29 f9                	sub    %edi,%ecx
  80330b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80330f:	89 14 24             	mov    %edx,(%esp)
  803312:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803316:	8b 44 24 04          	mov    0x4(%esp),%eax
  80331a:	8b 14 24             	mov    (%esp),%edx
  80331d:	83 c4 1c             	add    $0x1c,%esp
  803320:	5b                   	pop    %ebx
  803321:	5e                   	pop    %esi
  803322:	5f                   	pop    %edi
  803323:	5d                   	pop    %ebp
  803324:	c3                   	ret    
  803325:	8d 76 00             	lea    0x0(%esi),%esi
  803328:	2b 04 24             	sub    (%esp),%eax
  80332b:	19 fa                	sbb    %edi,%edx
  80332d:	89 d1                	mov    %edx,%ecx
  80332f:	89 c6                	mov    %eax,%esi
  803331:	e9 71 ff ff ff       	jmp    8032a7 <__umoddi3+0xb3>
  803336:	66 90                	xchg   %ax,%ax
  803338:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80333c:	72 ea                	jb     803328 <__umoddi3+0x134>
  80333e:	89 d9                	mov    %ebx,%ecx
  803340:	e9 62 ff ff ff       	jmp    8032a7 <__umoddi3+0xb3>
