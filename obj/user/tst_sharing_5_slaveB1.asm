
obj/user/tst_sharing_5_slaveB1:     file format elf32-i386


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
  800031:	e8 1e 01 00 00       	call   800154 <libmain>
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
  800098:	e8 f3 01 00 00       	call   800290 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 3c 14 00 00       	call   8014e3 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  8000aa:	e8 cb 1b 00 00       	call   801c7a <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 99 33 80 00       	push   $0x803399
  8000b7:	50                   	push   %eax
  8000b8:	e8 76 16 00 00       	call   801733 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B1 env used x (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 9c 33 80 00       	push   $0x80339c
  8000cb:	e8 74 04 00 00       	call   800544 <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got x
	inctst();
  8000d3:	e8 c7 1c 00 00       	call   801d9f <inctst>
	cprintf("Slave B1 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 c4 33 80 00       	push   $0x8033c4
  8000e0:	e8 5f 04 00 00       	call   800544 <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(6000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 70 17 00 00       	push   $0x1770
  8000f0:	e8 53 2f 00 00       	call   803048 <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp

	int freeFrames = sys_calculate_free_frames() ;
  8000f8:	e8 84 18 00 00       	call   801981 <sys_calculate_free_frames>
  8000fd:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(x);
  800100:	83 ec 0c             	sub    $0xc,%esp
  800103:	ff 75 ec             	pushl  -0x14(%ebp)
  800106:	e8 16 17 00 00       	call   801821 <sfree>
  80010b:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B1 env removed x\n");
  80010e:	83 ec 0c             	sub    $0xc,%esp
  800111:	68 e4 33 80 00       	push   $0x8033e4
  800116:	e8 29 04 00 00       	call   800544 <cprintf>
  80011b:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  80011e:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("B1 wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table and 1 for frame of x\nframes_storage of x: should be cleared now\n");
  800125:	e8 57 18 00 00       	call   801981 <sys_calculate_free_frames>
  80012a:	89 c2                	mov    %eax,%edx
  80012c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80012f:	29 c2                	sub    %eax,%edx
  800131:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800134:	39 c2                	cmp    %eax,%edx
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 fc 33 80 00       	push   $0x8033fc
  800140:	6a 27                	push   $0x27
  800142:	68 7c 33 80 00       	push   $0x80337c
  800147:	e8 44 01 00 00       	call   800290 <_panic>

	//To indicate that it's completed successfully
	inctst();
  80014c:	e8 4e 1c 00 00       	call   801d9f <inctst>
	return;
  800151:	90                   	nop
}
  800152:	c9                   	leave  
  800153:	c3                   	ret    

00800154 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800154:	55                   	push   %ebp
  800155:	89 e5                	mov    %esp,%ebp
  800157:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80015a:	e8 02 1b 00 00       	call   801c61 <sys_getenvindex>
  80015f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800162:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800165:	89 d0                	mov    %edx,%eax
  800167:	c1 e0 03             	shl    $0x3,%eax
  80016a:	01 d0                	add    %edx,%eax
  80016c:	01 c0                	add    %eax,%eax
  80016e:	01 d0                	add    %edx,%eax
  800170:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800177:	01 d0                	add    %edx,%eax
  800179:	c1 e0 04             	shl    $0x4,%eax
  80017c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800181:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800186:	a1 20 40 80 00       	mov    0x804020,%eax
  80018b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800191:	84 c0                	test   %al,%al
  800193:	74 0f                	je     8001a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800195:	a1 20 40 80 00       	mov    0x804020,%eax
  80019a:	05 5c 05 00 00       	add    $0x55c,%eax
  80019f:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001a8:	7e 0a                	jle    8001b4 <libmain+0x60>
		binaryname = argv[0];
  8001aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001ad:	8b 00                	mov    (%eax),%eax
  8001af:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001b4:	83 ec 08             	sub    $0x8,%esp
  8001b7:	ff 75 0c             	pushl  0xc(%ebp)
  8001ba:	ff 75 08             	pushl  0x8(%ebp)
  8001bd:	e8 76 fe ff ff       	call   800038 <_main>
  8001c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001c5:	e8 a4 18 00 00       	call   801a6e <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ca:	83 ec 0c             	sub    $0xc,%esp
  8001cd:	68 bc 34 80 00       	push   $0x8034bc
  8001d2:	e8 6d 03 00 00       	call   800544 <cprintf>
  8001d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001da:	a1 20 40 80 00       	mov    0x804020,%eax
  8001df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	52                   	push   %edx
  8001f4:	50                   	push   %eax
  8001f5:	68 e4 34 80 00       	push   $0x8034e4
  8001fa:	e8 45 03 00 00       	call   800544 <cprintf>
  8001ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800202:	a1 20 40 80 00       	mov    0x804020,%eax
  800207:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80020d:	a1 20 40 80 00       	mov    0x804020,%eax
  800212:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800218:	a1 20 40 80 00       	mov    0x804020,%eax
  80021d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800223:	51                   	push   %ecx
  800224:	52                   	push   %edx
  800225:	50                   	push   %eax
  800226:	68 0c 35 80 00       	push   $0x80350c
  80022b:	e8 14 03 00 00       	call   800544 <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80023e:	83 ec 08             	sub    $0x8,%esp
  800241:	50                   	push   %eax
  800242:	68 64 35 80 00       	push   $0x803564
  800247:	e8 f8 02 00 00       	call   800544 <cprintf>
  80024c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80024f:	83 ec 0c             	sub    $0xc,%esp
  800252:	68 bc 34 80 00       	push   $0x8034bc
  800257:	e8 e8 02 00 00       	call   800544 <cprintf>
  80025c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80025f:	e8 24 18 00 00       	call   801a88 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800264:	e8 19 00 00 00       	call   800282 <exit>
}
  800269:	90                   	nop
  80026a:	c9                   	leave  
  80026b:	c3                   	ret    

0080026c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80026c:	55                   	push   %ebp
  80026d:	89 e5                	mov    %esp,%ebp
  80026f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800272:	83 ec 0c             	sub    $0xc,%esp
  800275:	6a 00                	push   $0x0
  800277:	e8 b1 19 00 00       	call   801c2d <sys_destroy_env>
  80027c:	83 c4 10             	add    $0x10,%esp
}
  80027f:	90                   	nop
  800280:	c9                   	leave  
  800281:	c3                   	ret    

00800282 <exit>:

void
exit(void)
{
  800282:	55                   	push   %ebp
  800283:	89 e5                	mov    %esp,%ebp
  800285:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800288:	e8 06 1a 00 00       	call   801c93 <sys_exit_env>
}
  80028d:	90                   	nop
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800296:	8d 45 10             	lea    0x10(%ebp),%eax
  800299:	83 c0 04             	add    $0x4,%eax
  80029c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80029f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002a4:	85 c0                	test   %eax,%eax
  8002a6:	74 16                	je     8002be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ad:	83 ec 08             	sub    $0x8,%esp
  8002b0:	50                   	push   %eax
  8002b1:	68 78 35 80 00       	push   $0x803578
  8002b6:	e8 89 02 00 00       	call   800544 <cprintf>
  8002bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002be:	a1 00 40 80 00       	mov    0x804000,%eax
  8002c3:	ff 75 0c             	pushl  0xc(%ebp)
  8002c6:	ff 75 08             	pushl  0x8(%ebp)
  8002c9:	50                   	push   %eax
  8002ca:	68 7d 35 80 00       	push   $0x80357d
  8002cf:	e8 70 02 00 00       	call   800544 <cprintf>
  8002d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	83 ec 08             	sub    $0x8,%esp
  8002dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8002e0:	50                   	push   %eax
  8002e1:	e8 f3 01 00 00       	call   8004d9 <vcprintf>
  8002e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002e9:	83 ec 08             	sub    $0x8,%esp
  8002ec:	6a 00                	push   $0x0
  8002ee:	68 99 35 80 00       	push   $0x803599
  8002f3:	e8 e1 01 00 00       	call   8004d9 <vcprintf>
  8002f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002fb:	e8 82 ff ff ff       	call   800282 <exit>

	// should not return here
	while (1) ;
  800300:	eb fe                	jmp    800300 <_panic+0x70>

00800302 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800308:	a1 20 40 80 00       	mov    0x804020,%eax
  80030d:	8b 50 74             	mov    0x74(%eax),%edx
  800310:	8b 45 0c             	mov    0xc(%ebp),%eax
  800313:	39 c2                	cmp    %eax,%edx
  800315:	74 14                	je     80032b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800317:	83 ec 04             	sub    $0x4,%esp
  80031a:	68 9c 35 80 00       	push   $0x80359c
  80031f:	6a 26                	push   $0x26
  800321:	68 e8 35 80 00       	push   $0x8035e8
  800326:	e8 65 ff ff ff       	call   800290 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80032b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800332:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800339:	e9 c2 00 00 00       	jmp    800400 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80033e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800341:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800348:	8b 45 08             	mov    0x8(%ebp),%eax
  80034b:	01 d0                	add    %edx,%eax
  80034d:	8b 00                	mov    (%eax),%eax
  80034f:	85 c0                	test   %eax,%eax
  800351:	75 08                	jne    80035b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800353:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800356:	e9 a2 00 00 00       	jmp    8003fd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80035b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800362:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800369:	eb 69                	jmp    8003d4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80036b:	a1 20 40 80 00       	mov    0x804020,%eax
  800370:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800376:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800379:	89 d0                	mov    %edx,%eax
  80037b:	01 c0                	add    %eax,%eax
  80037d:	01 d0                	add    %edx,%eax
  80037f:	c1 e0 03             	shl    $0x3,%eax
  800382:	01 c8                	add    %ecx,%eax
  800384:	8a 40 04             	mov    0x4(%eax),%al
  800387:	84 c0                	test   %al,%al
  800389:	75 46                	jne    8003d1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038b:	a1 20 40 80 00       	mov    0x804020,%eax
  800390:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800396:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800399:	89 d0                	mov    %edx,%eax
  80039b:	01 c0                	add    %eax,%eax
  80039d:	01 d0                	add    %edx,%eax
  80039f:	c1 e0 03             	shl    $0x3,%eax
  8003a2:	01 c8                	add    %ecx,%eax
  8003a4:	8b 00                	mov    (%eax),%eax
  8003a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8003c0:	01 c8                	add    %ecx,%eax
  8003c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003c4:	39 c2                	cmp    %eax,%edx
  8003c6:	75 09                	jne    8003d1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003cf:	eb 12                	jmp    8003e3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003d1:	ff 45 e8             	incl   -0x18(%ebp)
  8003d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003d9:	8b 50 74             	mov    0x74(%eax),%edx
  8003dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003df:	39 c2                	cmp    %eax,%edx
  8003e1:	77 88                	ja     80036b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003e7:	75 14                	jne    8003fd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003e9:	83 ec 04             	sub    $0x4,%esp
  8003ec:	68 f4 35 80 00       	push   $0x8035f4
  8003f1:	6a 3a                	push   $0x3a
  8003f3:	68 e8 35 80 00       	push   $0x8035e8
  8003f8:	e8 93 fe ff ff       	call   800290 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003fd:	ff 45 f0             	incl   -0x10(%ebp)
  800400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800403:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800406:	0f 8c 32 ff ff ff    	jl     80033e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80040c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800413:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80041a:	eb 26                	jmp    800442 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80041c:	a1 20 40 80 00       	mov    0x804020,%eax
  800421:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800427:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80042a:	89 d0                	mov    %edx,%eax
  80042c:	01 c0                	add    %eax,%eax
  80042e:	01 d0                	add    %edx,%eax
  800430:	c1 e0 03             	shl    $0x3,%eax
  800433:	01 c8                	add    %ecx,%eax
  800435:	8a 40 04             	mov    0x4(%eax),%al
  800438:	3c 01                	cmp    $0x1,%al
  80043a:	75 03                	jne    80043f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80043c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043f:	ff 45 e0             	incl   -0x20(%ebp)
  800442:	a1 20 40 80 00       	mov    0x804020,%eax
  800447:	8b 50 74             	mov    0x74(%eax),%edx
  80044a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80044d:	39 c2                	cmp    %eax,%edx
  80044f:	77 cb                	ja     80041c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800454:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800457:	74 14                	je     80046d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800459:	83 ec 04             	sub    $0x4,%esp
  80045c:	68 48 36 80 00       	push   $0x803648
  800461:	6a 44                	push   $0x44
  800463:	68 e8 35 80 00       	push   $0x8035e8
  800468:	e8 23 fe ff ff       	call   800290 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80046d:	90                   	nop
  80046e:	c9                   	leave  
  80046f:	c3                   	ret    

00800470 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800470:	55                   	push   %ebp
  800471:	89 e5                	mov    %esp,%ebp
  800473:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800476:	8b 45 0c             	mov    0xc(%ebp),%eax
  800479:	8b 00                	mov    (%eax),%eax
  80047b:	8d 48 01             	lea    0x1(%eax),%ecx
  80047e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800481:	89 0a                	mov    %ecx,(%edx)
  800483:	8b 55 08             	mov    0x8(%ebp),%edx
  800486:	88 d1                	mov    %dl,%cl
  800488:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80048f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800492:	8b 00                	mov    (%eax),%eax
  800494:	3d ff 00 00 00       	cmp    $0xff,%eax
  800499:	75 2c                	jne    8004c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80049b:	a0 24 40 80 00       	mov    0x804024,%al
  8004a0:	0f b6 c0             	movzbl %al,%eax
  8004a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a6:	8b 12                	mov    (%edx),%edx
  8004a8:	89 d1                	mov    %edx,%ecx
  8004aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ad:	83 c2 08             	add    $0x8,%edx
  8004b0:	83 ec 04             	sub    $0x4,%esp
  8004b3:	50                   	push   %eax
  8004b4:	51                   	push   %ecx
  8004b5:	52                   	push   %edx
  8004b6:	e8 05 14 00 00       	call   8018c0 <sys_cputs>
  8004bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ca:	8b 40 04             	mov    0x4(%eax),%eax
  8004cd:	8d 50 01             	lea    0x1(%eax),%edx
  8004d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004d6:	90                   	nop
  8004d7:	c9                   	leave  
  8004d8:	c3                   	ret    

008004d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004d9:	55                   	push   %ebp
  8004da:	89 e5                	mov    %esp,%ebp
  8004dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004e9:	00 00 00 
	b.cnt = 0;
  8004ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004f6:	ff 75 0c             	pushl  0xc(%ebp)
  8004f9:	ff 75 08             	pushl  0x8(%ebp)
  8004fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800502:	50                   	push   %eax
  800503:	68 70 04 80 00       	push   $0x800470
  800508:	e8 11 02 00 00       	call   80071e <vprintfmt>
  80050d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800510:	a0 24 40 80 00       	mov    0x804024,%al
  800515:	0f b6 c0             	movzbl %al,%eax
  800518:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80051e:	83 ec 04             	sub    $0x4,%esp
  800521:	50                   	push   %eax
  800522:	52                   	push   %edx
  800523:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800529:	83 c0 08             	add    $0x8,%eax
  80052c:	50                   	push   %eax
  80052d:	e8 8e 13 00 00       	call   8018c0 <sys_cputs>
  800532:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800535:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80053c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800542:	c9                   	leave  
  800543:	c3                   	ret    

00800544 <cprintf>:

int cprintf(const char *fmt, ...) {
  800544:	55                   	push   %ebp
  800545:	89 e5                	mov    %esp,%ebp
  800547:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80054a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800551:	8d 45 0c             	lea    0xc(%ebp),%eax
  800554:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800557:	8b 45 08             	mov    0x8(%ebp),%eax
  80055a:	83 ec 08             	sub    $0x8,%esp
  80055d:	ff 75 f4             	pushl  -0xc(%ebp)
  800560:	50                   	push   %eax
  800561:	e8 73 ff ff ff       	call   8004d9 <vcprintf>
  800566:	83 c4 10             	add    $0x10,%esp
  800569:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80056c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056f:	c9                   	leave  
  800570:	c3                   	ret    

00800571 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800571:	55                   	push   %ebp
  800572:	89 e5                	mov    %esp,%ebp
  800574:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800577:	e8 f2 14 00 00       	call   801a6e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80057c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800582:	8b 45 08             	mov    0x8(%ebp),%eax
  800585:	83 ec 08             	sub    $0x8,%esp
  800588:	ff 75 f4             	pushl  -0xc(%ebp)
  80058b:	50                   	push   %eax
  80058c:	e8 48 ff ff ff       	call   8004d9 <vcprintf>
  800591:	83 c4 10             	add    $0x10,%esp
  800594:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800597:	e8 ec 14 00 00       	call   801a88 <sys_enable_interrupt>
	return cnt;
  80059c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80059f:	c9                   	leave  
  8005a0:	c3                   	ret    

008005a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005a1:	55                   	push   %ebp
  8005a2:	89 e5                	mov    %esp,%ebp
  8005a4:	53                   	push   %ebx
  8005a5:	83 ec 14             	sub    $0x14,%esp
  8005a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8005b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8005bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005bf:	77 55                	ja     800616 <printnum+0x75>
  8005c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005c4:	72 05                	jb     8005cb <printnum+0x2a>
  8005c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005c9:	77 4b                	ja     800616 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8005d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8005d9:	52                   	push   %edx
  8005da:	50                   	push   %eax
  8005db:	ff 75 f4             	pushl  -0xc(%ebp)
  8005de:	ff 75 f0             	pushl  -0x10(%ebp)
  8005e1:	e8 16 2b 00 00       	call   8030fc <__udivdi3>
  8005e6:	83 c4 10             	add    $0x10,%esp
  8005e9:	83 ec 04             	sub    $0x4,%esp
  8005ec:	ff 75 20             	pushl  0x20(%ebp)
  8005ef:	53                   	push   %ebx
  8005f0:	ff 75 18             	pushl  0x18(%ebp)
  8005f3:	52                   	push   %edx
  8005f4:	50                   	push   %eax
  8005f5:	ff 75 0c             	pushl  0xc(%ebp)
  8005f8:	ff 75 08             	pushl  0x8(%ebp)
  8005fb:	e8 a1 ff ff ff       	call   8005a1 <printnum>
  800600:	83 c4 20             	add    $0x20,%esp
  800603:	eb 1a                	jmp    80061f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800605:	83 ec 08             	sub    $0x8,%esp
  800608:	ff 75 0c             	pushl  0xc(%ebp)
  80060b:	ff 75 20             	pushl  0x20(%ebp)
  80060e:	8b 45 08             	mov    0x8(%ebp),%eax
  800611:	ff d0                	call   *%eax
  800613:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800616:	ff 4d 1c             	decl   0x1c(%ebp)
  800619:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80061d:	7f e6                	jg     800605 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80061f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800622:	bb 00 00 00 00       	mov    $0x0,%ebx
  800627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80062a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80062d:	53                   	push   %ebx
  80062e:	51                   	push   %ecx
  80062f:	52                   	push   %edx
  800630:	50                   	push   %eax
  800631:	e8 d6 2b 00 00       	call   80320c <__umoddi3>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	05 b4 38 80 00       	add    $0x8038b4,%eax
  80063e:	8a 00                	mov    (%eax),%al
  800640:	0f be c0             	movsbl %al,%eax
  800643:	83 ec 08             	sub    $0x8,%esp
  800646:	ff 75 0c             	pushl  0xc(%ebp)
  800649:	50                   	push   %eax
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	ff d0                	call   *%eax
  80064f:	83 c4 10             	add    $0x10,%esp
}
  800652:	90                   	nop
  800653:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800656:	c9                   	leave  
  800657:	c3                   	ret    

00800658 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800658:	55                   	push   %ebp
  800659:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80065b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80065f:	7e 1c                	jle    80067d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800661:	8b 45 08             	mov    0x8(%ebp),%eax
  800664:	8b 00                	mov    (%eax),%eax
  800666:	8d 50 08             	lea    0x8(%eax),%edx
  800669:	8b 45 08             	mov    0x8(%ebp),%eax
  80066c:	89 10                	mov    %edx,(%eax)
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	8b 00                	mov    (%eax),%eax
  800673:	83 e8 08             	sub    $0x8,%eax
  800676:	8b 50 04             	mov    0x4(%eax),%edx
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	eb 40                	jmp    8006bd <getuint+0x65>
	else if (lflag)
  80067d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800681:	74 1e                	je     8006a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800683:	8b 45 08             	mov    0x8(%ebp),%eax
  800686:	8b 00                	mov    (%eax),%eax
  800688:	8d 50 04             	lea    0x4(%eax),%edx
  80068b:	8b 45 08             	mov    0x8(%ebp),%eax
  80068e:	89 10                	mov    %edx,(%eax)
  800690:	8b 45 08             	mov    0x8(%ebp),%eax
  800693:	8b 00                	mov    (%eax),%eax
  800695:	83 e8 04             	sub    $0x4,%eax
  800698:	8b 00                	mov    (%eax),%eax
  80069a:	ba 00 00 00 00       	mov    $0x0,%edx
  80069f:	eb 1c                	jmp    8006bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a4:	8b 00                	mov    (%eax),%eax
  8006a6:	8d 50 04             	lea    0x4(%eax),%edx
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	89 10                	mov    %edx,(%eax)
  8006ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b1:	8b 00                	mov    (%eax),%eax
  8006b3:	83 e8 04             	sub    $0x4,%eax
  8006b6:	8b 00                	mov    (%eax),%eax
  8006b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006bd:	5d                   	pop    %ebp
  8006be:	c3                   	ret    

008006bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006c6:	7e 1c                	jle    8006e4 <getint+0x25>
		return va_arg(*ap, long long);
  8006c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006cb:	8b 00                	mov    (%eax),%eax
  8006cd:	8d 50 08             	lea    0x8(%eax),%edx
  8006d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d3:	89 10                	mov    %edx,(%eax)
  8006d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d8:	8b 00                	mov    (%eax),%eax
  8006da:	83 e8 08             	sub    $0x8,%eax
  8006dd:	8b 50 04             	mov    0x4(%eax),%edx
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	eb 38                	jmp    80071c <getint+0x5d>
	else if (lflag)
  8006e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006e8:	74 1a                	je     800704 <getint+0x45>
		return va_arg(*ap, long);
  8006ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ed:	8b 00                	mov    (%eax),%eax
  8006ef:	8d 50 04             	lea    0x4(%eax),%edx
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	89 10                	mov    %edx,(%eax)
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	83 e8 04             	sub    $0x4,%eax
  8006ff:	8b 00                	mov    (%eax),%eax
  800701:	99                   	cltd   
  800702:	eb 18                	jmp    80071c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8d 50 04             	lea    0x4(%eax),%edx
  80070c:	8b 45 08             	mov    0x8(%ebp),%eax
  80070f:	89 10                	mov    %edx,(%eax)
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	8b 00                	mov    (%eax),%eax
  800716:	83 e8 04             	sub    $0x4,%eax
  800719:	8b 00                	mov    (%eax),%eax
  80071b:	99                   	cltd   
}
  80071c:	5d                   	pop    %ebp
  80071d:	c3                   	ret    

0080071e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	56                   	push   %esi
  800722:	53                   	push   %ebx
  800723:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800726:	eb 17                	jmp    80073f <vprintfmt+0x21>
			if (ch == '\0')
  800728:	85 db                	test   %ebx,%ebx
  80072a:	0f 84 af 03 00 00    	je     800adf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800730:	83 ec 08             	sub    $0x8,%esp
  800733:	ff 75 0c             	pushl  0xc(%ebp)
  800736:	53                   	push   %ebx
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	ff d0                	call   *%eax
  80073c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80073f:	8b 45 10             	mov    0x10(%ebp),%eax
  800742:	8d 50 01             	lea    0x1(%eax),%edx
  800745:	89 55 10             	mov    %edx,0x10(%ebp)
  800748:	8a 00                	mov    (%eax),%al
  80074a:	0f b6 d8             	movzbl %al,%ebx
  80074d:	83 fb 25             	cmp    $0x25,%ebx
  800750:	75 d6                	jne    800728 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800752:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800756:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80075d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800764:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80076b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800772:	8b 45 10             	mov    0x10(%ebp),%eax
  800775:	8d 50 01             	lea    0x1(%eax),%edx
  800778:	89 55 10             	mov    %edx,0x10(%ebp)
  80077b:	8a 00                	mov    (%eax),%al
  80077d:	0f b6 d8             	movzbl %al,%ebx
  800780:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800783:	83 f8 55             	cmp    $0x55,%eax
  800786:	0f 87 2b 03 00 00    	ja     800ab7 <vprintfmt+0x399>
  80078c:	8b 04 85 d8 38 80 00 	mov    0x8038d8(,%eax,4),%eax
  800793:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800795:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800799:	eb d7                	jmp    800772 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80079b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80079f:	eb d1                	jmp    800772 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007ab:	89 d0                	mov    %edx,%eax
  8007ad:	c1 e0 02             	shl    $0x2,%eax
  8007b0:	01 d0                	add    %edx,%eax
  8007b2:	01 c0                	add    %eax,%eax
  8007b4:	01 d8                	add    %ebx,%eax
  8007b6:	83 e8 30             	sub    $0x30,%eax
  8007b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8007bf:	8a 00                	mov    (%eax),%al
  8007c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8007c7:	7e 3e                	jle    800807 <vprintfmt+0xe9>
  8007c9:	83 fb 39             	cmp    $0x39,%ebx
  8007cc:	7f 39                	jg     800807 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007d1:	eb d5                	jmp    8007a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d6:	83 c0 04             	add    $0x4,%eax
  8007d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8007dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8007df:	83 e8 04             	sub    $0x4,%eax
  8007e2:	8b 00                	mov    (%eax),%eax
  8007e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007e7:	eb 1f                	jmp    800808 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	79 83                	jns    800772 <vprintfmt+0x54>
				width = 0;
  8007ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007f6:	e9 77 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800802:	e9 6b ff ff ff       	jmp    800772 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800807:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800808:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80080c:	0f 89 60 ff ff ff    	jns    800772 <vprintfmt+0x54>
				width = precision, precision = -1;
  800812:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800815:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800818:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80081f:	e9 4e ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800824:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800827:	e9 46 ff ff ff       	jmp    800772 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	50                   	push   %eax
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
			break;
  80084c:	e9 89 02 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800851:	8b 45 14             	mov    0x14(%ebp),%eax
  800854:	83 c0 04             	add    $0x4,%eax
  800857:	89 45 14             	mov    %eax,0x14(%ebp)
  80085a:	8b 45 14             	mov    0x14(%ebp),%eax
  80085d:	83 e8 04             	sub    $0x4,%eax
  800860:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800862:	85 db                	test   %ebx,%ebx
  800864:	79 02                	jns    800868 <vprintfmt+0x14a>
				err = -err;
  800866:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800868:	83 fb 64             	cmp    $0x64,%ebx
  80086b:	7f 0b                	jg     800878 <vprintfmt+0x15a>
  80086d:	8b 34 9d 20 37 80 00 	mov    0x803720(,%ebx,4),%esi
  800874:	85 f6                	test   %esi,%esi
  800876:	75 19                	jne    800891 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800878:	53                   	push   %ebx
  800879:	68 c5 38 80 00       	push   $0x8038c5
  80087e:	ff 75 0c             	pushl  0xc(%ebp)
  800881:	ff 75 08             	pushl  0x8(%ebp)
  800884:	e8 5e 02 00 00       	call   800ae7 <printfmt>
  800889:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80088c:	e9 49 02 00 00       	jmp    800ada <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800891:	56                   	push   %esi
  800892:	68 ce 38 80 00       	push   $0x8038ce
  800897:	ff 75 0c             	pushl  0xc(%ebp)
  80089a:	ff 75 08             	pushl  0x8(%ebp)
  80089d:	e8 45 02 00 00       	call   800ae7 <printfmt>
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 30 02 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 30                	mov    (%eax),%esi
  8008bb:	85 f6                	test   %esi,%esi
  8008bd:	75 05                	jne    8008c4 <vprintfmt+0x1a6>
				p = "(null)";
  8008bf:	be d1 38 80 00       	mov    $0x8038d1,%esi
			if (width > 0 && padc != '-')
  8008c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c8:	7e 6d                	jle    800937 <vprintfmt+0x219>
  8008ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008ce:	74 67                	je     800937 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	50                   	push   %eax
  8008d7:	56                   	push   %esi
  8008d8:	e8 0c 03 00 00       	call   800be9 <strnlen>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008e3:	eb 16                	jmp    8008fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008e9:	83 ec 08             	sub    $0x8,%esp
  8008ec:	ff 75 0c             	pushl  0xc(%ebp)
  8008ef:	50                   	push   %eax
  8008f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f3:	ff d0                	call   *%eax
  8008f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8008fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ff:	7f e4                	jg     8008e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800901:	eb 34                	jmp    800937 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800903:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800907:	74 1c                	je     800925 <vprintfmt+0x207>
  800909:	83 fb 1f             	cmp    $0x1f,%ebx
  80090c:	7e 05                	jle    800913 <vprintfmt+0x1f5>
  80090e:	83 fb 7e             	cmp    $0x7e,%ebx
  800911:	7e 12                	jle    800925 <vprintfmt+0x207>
					putch('?', putdat);
  800913:	83 ec 08             	sub    $0x8,%esp
  800916:	ff 75 0c             	pushl  0xc(%ebp)
  800919:	6a 3f                	push   $0x3f
  80091b:	8b 45 08             	mov    0x8(%ebp),%eax
  80091e:	ff d0                	call   *%eax
  800920:	83 c4 10             	add    $0x10,%esp
  800923:	eb 0f                	jmp    800934 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800925:	83 ec 08             	sub    $0x8,%esp
  800928:	ff 75 0c             	pushl  0xc(%ebp)
  80092b:	53                   	push   %ebx
  80092c:	8b 45 08             	mov    0x8(%ebp),%eax
  80092f:	ff d0                	call   *%eax
  800931:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800934:	ff 4d e4             	decl   -0x1c(%ebp)
  800937:	89 f0                	mov    %esi,%eax
  800939:	8d 70 01             	lea    0x1(%eax),%esi
  80093c:	8a 00                	mov    (%eax),%al
  80093e:	0f be d8             	movsbl %al,%ebx
  800941:	85 db                	test   %ebx,%ebx
  800943:	74 24                	je     800969 <vprintfmt+0x24b>
  800945:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800949:	78 b8                	js     800903 <vprintfmt+0x1e5>
  80094b:	ff 4d e0             	decl   -0x20(%ebp)
  80094e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800952:	79 af                	jns    800903 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800954:	eb 13                	jmp    800969 <vprintfmt+0x24b>
				putch(' ', putdat);
  800956:	83 ec 08             	sub    $0x8,%esp
  800959:	ff 75 0c             	pushl  0xc(%ebp)
  80095c:	6a 20                	push   $0x20
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	ff d0                	call   *%eax
  800963:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800966:	ff 4d e4             	decl   -0x1c(%ebp)
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7f e7                	jg     800956 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80096f:	e9 66 01 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800974:	83 ec 08             	sub    $0x8,%esp
  800977:	ff 75 e8             	pushl  -0x18(%ebp)
  80097a:	8d 45 14             	lea    0x14(%ebp),%eax
  80097d:	50                   	push   %eax
  80097e:	e8 3c fd ff ff       	call   8006bf <getint>
  800983:	83 c4 10             	add    $0x10,%esp
  800986:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800989:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80098c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800992:	85 d2                	test   %edx,%edx
  800994:	79 23                	jns    8009b9 <vprintfmt+0x29b>
				putch('-', putdat);
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	6a 2d                	push   $0x2d
  80099e:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a1:	ff d0                	call   *%eax
  8009a3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009ac:	f7 d8                	neg    %eax
  8009ae:	83 d2 00             	adc    $0x0,%edx
  8009b1:	f7 da                	neg    %edx
  8009b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c0:	e9 bc 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009c5:	83 ec 08             	sub    $0x8,%esp
  8009c8:	ff 75 e8             	pushl  -0x18(%ebp)
  8009cb:	8d 45 14             	lea    0x14(%ebp),%eax
  8009ce:	50                   	push   %eax
  8009cf:	e8 84 fc ff ff       	call   800658 <getuint>
  8009d4:	83 c4 10             	add    $0x10,%esp
  8009d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009da:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e4:	e9 98 00 00 00       	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 58                	push   $0x58
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 58                	push   $0x58
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a09:	83 ec 08             	sub    $0x8,%esp
  800a0c:	ff 75 0c             	pushl  0xc(%ebp)
  800a0f:	6a 58                	push   $0x58
  800a11:	8b 45 08             	mov    0x8(%ebp),%eax
  800a14:	ff d0                	call   *%eax
  800a16:	83 c4 10             	add    $0x10,%esp
			break;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 0c             	pushl  0xc(%ebp)
  800a24:	6a 30                	push   $0x30
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	ff d0                	call   *%eax
  800a2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a2e:	83 ec 08             	sub    $0x8,%esp
  800a31:	ff 75 0c             	pushl  0xc(%ebp)
  800a34:	6a 78                	push   $0x78
  800a36:	8b 45 08             	mov    0x8(%ebp),%eax
  800a39:	ff d0                	call   *%eax
  800a3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800a41:	83 c0 04             	add    $0x4,%eax
  800a44:	89 45 14             	mov    %eax,0x14(%ebp)
  800a47:	8b 45 14             	mov    0x14(%ebp),%eax
  800a4a:	83 e8 04             	sub    $0x4,%eax
  800a4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a60:	eb 1f                	jmp    800a81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 e8             	pushl  -0x18(%ebp)
  800a68:	8d 45 14             	lea    0x14(%ebp),%eax
  800a6b:	50                   	push   %eax
  800a6c:	e8 e7 fb ff ff       	call   800658 <getuint>
  800a71:	83 c4 10             	add    $0x10,%esp
  800a74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a88:	83 ec 04             	sub    $0x4,%esp
  800a8b:	52                   	push   %edx
  800a8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a8f:	50                   	push   %eax
  800a90:	ff 75 f4             	pushl  -0xc(%ebp)
  800a93:	ff 75 f0             	pushl  -0x10(%ebp)
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 08             	pushl  0x8(%ebp)
  800a9c:	e8 00 fb ff ff       	call   8005a1 <printnum>
  800aa1:	83 c4 20             	add    $0x20,%esp
			break;
  800aa4:	eb 34                	jmp    800ada <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aa6:	83 ec 08             	sub    $0x8,%esp
  800aa9:	ff 75 0c             	pushl  0xc(%ebp)
  800aac:	53                   	push   %ebx
  800aad:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab0:	ff d0                	call   *%eax
  800ab2:	83 c4 10             	add    $0x10,%esp
			break;
  800ab5:	eb 23                	jmp    800ada <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800ab7:	83 ec 08             	sub    $0x8,%esp
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	6a 25                	push   $0x25
  800abf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac2:	ff d0                	call   *%eax
  800ac4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ac7:	ff 4d 10             	decl   0x10(%ebp)
  800aca:	eb 03                	jmp    800acf <vprintfmt+0x3b1>
  800acc:	ff 4d 10             	decl   0x10(%ebp)
  800acf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ad2:	48                   	dec    %eax
  800ad3:	8a 00                	mov    (%eax),%al
  800ad5:	3c 25                	cmp    $0x25,%al
  800ad7:	75 f3                	jne    800acc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800ad9:	90                   	nop
		}
	}
  800ada:	e9 47 fc ff ff       	jmp    800726 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800adf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ae0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ae3:	5b                   	pop    %ebx
  800ae4:	5e                   	pop    %esi
  800ae5:	5d                   	pop    %ebp
  800ae6:	c3                   	ret    

00800ae7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ae7:	55                   	push   %ebp
  800ae8:	89 e5                	mov    %esp,%ebp
  800aea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800aed:	8d 45 10             	lea    0x10(%ebp),%eax
  800af0:	83 c0 04             	add    $0x4,%eax
  800af3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800af6:	8b 45 10             	mov    0x10(%ebp),%eax
  800af9:	ff 75 f4             	pushl  -0xc(%ebp)
  800afc:	50                   	push   %eax
  800afd:	ff 75 0c             	pushl  0xc(%ebp)
  800b00:	ff 75 08             	pushl  0x8(%ebp)
  800b03:	e8 16 fc ff ff       	call   80071e <vprintfmt>
  800b08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b0b:	90                   	nop
  800b0c:	c9                   	leave  
  800b0d:	c3                   	ret    

00800b0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b0e:	55                   	push   %ebp
  800b0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b14:	8b 40 08             	mov    0x8(%eax),%eax
  800b17:	8d 50 01             	lea    0x1(%eax),%edx
  800b1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b23:	8b 10                	mov    (%eax),%edx
  800b25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b28:	8b 40 04             	mov    0x4(%eax),%eax
  800b2b:	39 c2                	cmp    %eax,%edx
  800b2d:	73 12                	jae    800b41 <sprintputch+0x33>
		*b->buf++ = ch;
  800b2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 48 01             	lea    0x1(%eax),%ecx
  800b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b3a:	89 0a                	mov    %ecx,(%edx)
  800b3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800b3f:	88 10                	mov    %dl,(%eax)
}
  800b41:	90                   	nop
  800b42:	5d                   	pop    %ebp
  800b43:	c3                   	ret    

00800b44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b44:	55                   	push   %ebp
  800b45:	89 e5                	mov    %esp,%ebp
  800b47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	01 d0                	add    %edx,%eax
  800b5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b69:	74 06                	je     800b71 <vsnprintf+0x2d>
  800b6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b6f:	7f 07                	jg     800b78 <vsnprintf+0x34>
		return -E_INVAL;
  800b71:	b8 03 00 00 00       	mov    $0x3,%eax
  800b76:	eb 20                	jmp    800b98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b78:	ff 75 14             	pushl  0x14(%ebp)
  800b7b:	ff 75 10             	pushl  0x10(%ebp)
  800b7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b81:	50                   	push   %eax
  800b82:	68 0e 0b 80 00       	push   $0x800b0e
  800b87:	e8 92 fb ff ff       	call   80071e <vprintfmt>
  800b8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ba0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ba3:	83 c0 04             	add    $0x4,%eax
  800ba6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bac:	ff 75 f4             	pushl  -0xc(%ebp)
  800baf:	50                   	push   %eax
  800bb0:	ff 75 0c             	pushl  0xc(%ebp)
  800bb3:	ff 75 08             	pushl  0x8(%ebp)
  800bb6:	e8 89 ff ff ff       	call   800b44 <vsnprintf>
  800bbb:	83 c4 10             	add    $0x10,%esp
  800bbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800bc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bc4:	c9                   	leave  
  800bc5:	c3                   	ret    

00800bc6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bc6:	55                   	push   %ebp
  800bc7:	89 e5                	mov    %esp,%ebp
  800bc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bcc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd3:	eb 06                	jmp    800bdb <strlen+0x15>
		n++;
  800bd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 f1                	jne    800bd5 <strlen+0xf>
		n++;
	return n;
  800be4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be7:	c9                   	leave  
  800be8:	c3                   	ret    

00800be9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf6:	eb 09                	jmp    800c01 <strnlen+0x18>
		n++;
  800bf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bfb:	ff 45 08             	incl   0x8(%ebp)
  800bfe:	ff 4d 0c             	decl   0xc(%ebp)
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	74 09                	je     800c10 <strnlen+0x27>
  800c07:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0a:	8a 00                	mov    (%eax),%al
  800c0c:	84 c0                	test   %al,%al
  800c0e:	75 e8                	jne    800bf8 <strnlen+0xf>
		n++;
	return n;
  800c10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c13:	c9                   	leave  
  800c14:	c3                   	ret    

00800c15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c15:	55                   	push   %ebp
  800c16:	89 e5                	mov    %esp,%ebp
  800c18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c21:	90                   	nop
  800c22:	8b 45 08             	mov    0x8(%ebp),%eax
  800c25:	8d 50 01             	lea    0x1(%eax),%edx
  800c28:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c34:	8a 12                	mov    (%edx),%dl
  800c36:	88 10                	mov    %dl,(%eax)
  800c38:	8a 00                	mov    (%eax),%al
  800c3a:	84 c0                	test   %al,%al
  800c3c:	75 e4                	jne    800c22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c41:	c9                   	leave  
  800c42:	c3                   	ret    

00800c43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c43:	55                   	push   %ebp
  800c44:	89 e5                	mov    %esp,%ebp
  800c46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c56:	eb 1f                	jmp    800c77 <strncpy+0x34>
		*dst++ = *src;
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8d 50 01             	lea    0x1(%eax),%edx
  800c5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c64:	8a 12                	mov    (%edx),%dl
  800c66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6b:	8a 00                	mov    (%eax),%al
  800c6d:	84 c0                	test   %al,%al
  800c6f:	74 03                	je     800c74 <strncpy+0x31>
			src++;
  800c71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c74:	ff 45 fc             	incl   -0x4(%ebp)
  800c77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c7d:	72 d9                	jb     800c58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c82:	c9                   	leave  
  800c83:	c3                   	ret    

00800c84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c84:	55                   	push   %ebp
  800c85:	89 e5                	mov    %esp,%ebp
  800c87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c94:	74 30                	je     800cc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c96:	eb 16                	jmp    800cae <strlcpy+0x2a>
			*dst++ = *src++;
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	8d 50 01             	lea    0x1(%eax),%edx
  800c9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800ca1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ca4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ca7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800caa:	8a 12                	mov    (%edx),%dl
  800cac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cae:	ff 4d 10             	decl   0x10(%ebp)
  800cb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cb5:	74 09                	je     800cc0 <strlcpy+0x3c>
  800cb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cba:	8a 00                	mov    (%eax),%al
  800cbc:	84 c0                	test   %al,%al
  800cbe:	75 d8                	jne    800c98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ccc:	29 c2                	sub    %eax,%edx
  800cce:	89 d0                	mov    %edx,%eax
}
  800cd0:	c9                   	leave  
  800cd1:	c3                   	ret    

00800cd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cd2:	55                   	push   %ebp
  800cd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cd5:	eb 06                	jmp    800cdd <strcmp+0xb>
		p++, q++;
  800cd7:	ff 45 08             	incl   0x8(%ebp)
  800cda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	74 0e                	je     800cf4 <strcmp+0x22>
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	8a 10                	mov    (%eax),%dl
  800ceb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cee:	8a 00                	mov    (%eax),%al
  800cf0:	38 c2                	cmp    %al,%dl
  800cf2:	74 e3                	je     800cd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf7:	8a 00                	mov    (%eax),%al
  800cf9:	0f b6 d0             	movzbl %al,%edx
  800cfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cff:	8a 00                	mov    (%eax),%al
  800d01:	0f b6 c0             	movzbl %al,%eax
  800d04:	29 c2                	sub    %eax,%edx
  800d06:	89 d0                	mov    %edx,%eax
}
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d0d:	eb 09                	jmp    800d18 <strncmp+0xe>
		n--, p++, q++;
  800d0f:	ff 4d 10             	decl   0x10(%ebp)
  800d12:	ff 45 08             	incl   0x8(%ebp)
  800d15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1c:	74 17                	je     800d35 <strncmp+0x2b>
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8a 00                	mov    (%eax),%al
  800d23:	84 c0                	test   %al,%al
  800d25:	74 0e                	je     800d35 <strncmp+0x2b>
  800d27:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2a:	8a 10                	mov    (%eax),%dl
  800d2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2f:	8a 00                	mov    (%eax),%al
  800d31:	38 c2                	cmp    %al,%dl
  800d33:	74 da                	je     800d0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	75 07                	jne    800d42 <strncmp+0x38>
		return 0;
  800d3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800d40:	eb 14                	jmp    800d56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	0f b6 d0             	movzbl %al,%edx
  800d4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4d:	8a 00                	mov    (%eax),%al
  800d4f:	0f b6 c0             	movzbl %al,%eax
  800d52:	29 c2                	sub    %eax,%edx
  800d54:	89 d0                	mov    %edx,%eax
}
  800d56:	5d                   	pop    %ebp
  800d57:	c3                   	ret    

00800d58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d58:	55                   	push   %ebp
  800d59:	89 e5                	mov    %esp,%ebp
  800d5b:	83 ec 04             	sub    $0x4,%esp
  800d5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d64:	eb 12                	jmp    800d78 <strchr+0x20>
		if (*s == c)
  800d66:	8b 45 08             	mov    0x8(%ebp),%eax
  800d69:	8a 00                	mov    (%eax),%al
  800d6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d6e:	75 05                	jne    800d75 <strchr+0x1d>
			return (char *) s;
  800d70:	8b 45 08             	mov    0x8(%ebp),%eax
  800d73:	eb 11                	jmp    800d86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d75:	ff 45 08             	incl   0x8(%ebp)
  800d78:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7b:	8a 00                	mov    (%eax),%al
  800d7d:	84 c0                	test   %al,%al
  800d7f:	75 e5                	jne    800d66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d86:	c9                   	leave  
  800d87:	c3                   	ret    

00800d88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d88:	55                   	push   %ebp
  800d89:	89 e5                	mov    %esp,%ebp
  800d8b:	83 ec 04             	sub    $0x4,%esp
  800d8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d94:	eb 0d                	jmp    800da3 <strfind+0x1b>
		if (*s == c)
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d9e:	74 0e                	je     800dae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	8b 45 08             	mov    0x8(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	84 c0                	test   %al,%al
  800daa:	75 ea                	jne    800d96 <strfind+0xe>
  800dac:	eb 01                	jmp    800daf <strfind+0x27>
		if (*s == c)
			break;
  800dae:	90                   	nop
	return (char *) s;
  800daf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db2:	c9                   	leave  
  800db3:	c3                   	ret    

00800db4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800db4:	55                   	push   %ebp
  800db5:	89 e5                	mov    %esp,%ebp
  800db7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800dc0:	8b 45 10             	mov    0x10(%ebp),%eax
  800dc3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dc6:	eb 0e                	jmp    800dd6 <memset+0x22>
		*p++ = c;
  800dc8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcb:	8d 50 01             	lea    0x1(%eax),%edx
  800dce:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800dd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dd4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dd6:	ff 4d f8             	decl   -0x8(%ebp)
  800dd9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800ddd:	79 e9                	jns    800dc8 <memset+0x14>
		*p++ = c;

	return v;
  800ddf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de2:	c9                   	leave  
  800de3:	c3                   	ret    

00800de4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
  800de7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ded:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df0:	8b 45 08             	mov    0x8(%ebp),%eax
  800df3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800df6:	eb 16                	jmp    800e0e <memcpy+0x2a>
		*d++ = *s++;
  800df8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dfb:	8d 50 01             	lea    0x1(%eax),%edx
  800dfe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e0a:	8a 12                	mov    (%edx),%dl
  800e0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e14:	89 55 10             	mov    %edx,0x10(%ebp)
  800e17:	85 c0                	test   %eax,%eax
  800e19:	75 dd                	jne    800df8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e1e:	c9                   	leave  
  800e1f:	c3                   	ret    

00800e20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e20:	55                   	push   %ebp
  800e21:	89 e5                	mov    %esp,%ebp
  800e23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e38:	73 50                	jae    800e8a <memmove+0x6a>
  800e3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e40:	01 d0                	add    %edx,%eax
  800e42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e45:	76 43                	jbe    800e8a <memmove+0x6a>
		s += n;
  800e47:	8b 45 10             	mov    0x10(%ebp),%eax
  800e4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e53:	eb 10                	jmp    800e65 <memmove+0x45>
			*--d = *--s;
  800e55:	ff 4d f8             	decl   -0x8(%ebp)
  800e58:	ff 4d fc             	decl   -0x4(%ebp)
  800e5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5e:	8a 10                	mov    (%eax),%dl
  800e60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e6e:	85 c0                	test   %eax,%eax
  800e70:	75 e3                	jne    800e55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e72:	eb 23                	jmp    800e97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e77:	8d 50 01             	lea    0x1(%eax),%edx
  800e7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e86:	8a 12                	mov    (%edx),%dl
  800e88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e90:	89 55 10             	mov    %edx,0x10(%ebp)
  800e93:	85 c0                	test   %eax,%eax
  800e95:	75 dd                	jne    800e74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e9a:	c9                   	leave  
  800e9b:	c3                   	ret    

00800e9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e9c:	55                   	push   %ebp
  800e9d:	89 e5                	mov    %esp,%ebp
  800e9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ea8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800eae:	eb 2a                	jmp    800eda <memcmp+0x3e>
		if (*s1 != *s2)
  800eb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb3:	8a 10                	mov    (%eax),%dl
  800eb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eb8:	8a 00                	mov    (%eax),%al
  800eba:	38 c2                	cmp    %al,%dl
  800ebc:	74 16                	je     800ed4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ebe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ec1:	8a 00                	mov    (%eax),%al
  800ec3:	0f b6 d0             	movzbl %al,%edx
  800ec6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ec9:	8a 00                	mov    (%eax),%al
  800ecb:	0f b6 c0             	movzbl %al,%eax
  800ece:	29 c2                	sub    %eax,%edx
  800ed0:	89 d0                	mov    %edx,%eax
  800ed2:	eb 18                	jmp    800eec <memcmp+0x50>
		s1++, s2++;
  800ed4:	ff 45 fc             	incl   -0x4(%ebp)
  800ed7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800eda:	8b 45 10             	mov    0x10(%ebp),%eax
  800edd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee0:	89 55 10             	mov    %edx,0x10(%ebp)
  800ee3:	85 c0                	test   %eax,%eax
  800ee5:	75 c9                	jne    800eb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ee7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eec:	c9                   	leave  
  800eed:	c3                   	ret    

00800eee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eee:	55                   	push   %ebp
  800eef:	89 e5                	mov    %esp,%ebp
  800ef1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ef4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ef7:	8b 45 10             	mov    0x10(%ebp),%eax
  800efa:	01 d0                	add    %edx,%eax
  800efc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eff:	eb 15                	jmp    800f16 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f01:	8b 45 08             	mov    0x8(%ebp),%eax
  800f04:	8a 00                	mov    (%eax),%al
  800f06:	0f b6 d0             	movzbl %al,%edx
  800f09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f0c:	0f b6 c0             	movzbl %al,%eax
  800f0f:	39 c2                	cmp    %eax,%edx
  800f11:	74 0d                	je     800f20 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f13:	ff 45 08             	incl   0x8(%ebp)
  800f16:	8b 45 08             	mov    0x8(%ebp),%eax
  800f19:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f1c:	72 e3                	jb     800f01 <memfind+0x13>
  800f1e:	eb 01                	jmp    800f21 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f20:	90                   	nop
	return (void *) s;
  800f21:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f24:	c9                   	leave  
  800f25:	c3                   	ret    

00800f26 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f2c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f33:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3a:	eb 03                	jmp    800f3f <strtol+0x19>
		s++;
  800f3c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	8a 00                	mov    (%eax),%al
  800f44:	3c 20                	cmp    $0x20,%al
  800f46:	74 f4                	je     800f3c <strtol+0x16>
  800f48:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4b:	8a 00                	mov    (%eax),%al
  800f4d:	3c 09                	cmp    $0x9,%al
  800f4f:	74 eb                	je     800f3c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f51:	8b 45 08             	mov    0x8(%ebp),%eax
  800f54:	8a 00                	mov    (%eax),%al
  800f56:	3c 2b                	cmp    $0x2b,%al
  800f58:	75 05                	jne    800f5f <strtol+0x39>
		s++;
  800f5a:	ff 45 08             	incl   0x8(%ebp)
  800f5d:	eb 13                	jmp    800f72 <strtol+0x4c>
	else if (*s == '-')
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 2d                	cmp    $0x2d,%al
  800f66:	75 0a                	jne    800f72 <strtol+0x4c>
		s++, neg = 1;
  800f68:	ff 45 08             	incl   0x8(%ebp)
  800f6b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f76:	74 06                	je     800f7e <strtol+0x58>
  800f78:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f7c:	75 20                	jne    800f9e <strtol+0x78>
  800f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f81:	8a 00                	mov    (%eax),%al
  800f83:	3c 30                	cmp    $0x30,%al
  800f85:	75 17                	jne    800f9e <strtol+0x78>
  800f87:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8a:	40                   	inc    %eax
  800f8b:	8a 00                	mov    (%eax),%al
  800f8d:	3c 78                	cmp    $0x78,%al
  800f8f:	75 0d                	jne    800f9e <strtol+0x78>
		s += 2, base = 16;
  800f91:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f95:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f9c:	eb 28                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f9e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fa2:	75 15                	jne    800fb9 <strtol+0x93>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 0c                	jne    800fb9 <strtol+0x93>
		s++, base = 8;
  800fad:	ff 45 08             	incl   0x8(%ebp)
  800fb0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fb7:	eb 0d                	jmp    800fc6 <strtol+0xa0>
	else if (base == 0)
  800fb9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fbd:	75 07                	jne    800fc6 <strtol+0xa0>
		base = 10;
  800fbf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	3c 2f                	cmp    $0x2f,%al
  800fcd:	7e 19                	jle    800fe8 <strtol+0xc2>
  800fcf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd2:	8a 00                	mov    (%eax),%al
  800fd4:	3c 39                	cmp    $0x39,%al
  800fd6:	7f 10                	jg     800fe8 <strtol+0xc2>
			dig = *s - '0';
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f be c0             	movsbl %al,%eax
  800fe0:	83 e8 30             	sub    $0x30,%eax
  800fe3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe6:	eb 42                	jmp    80102a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  800feb:	8a 00                	mov    (%eax),%al
  800fed:	3c 60                	cmp    $0x60,%al
  800fef:	7e 19                	jle    80100a <strtol+0xe4>
  800ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff4:	8a 00                	mov    (%eax),%al
  800ff6:	3c 7a                	cmp    $0x7a,%al
  800ff8:	7f 10                	jg     80100a <strtol+0xe4>
			dig = *s - 'a' + 10;
  800ffa:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffd:	8a 00                	mov    (%eax),%al
  800fff:	0f be c0             	movsbl %al,%eax
  801002:	83 e8 57             	sub    $0x57,%eax
  801005:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801008:	eb 20                	jmp    80102a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80100a:	8b 45 08             	mov    0x8(%ebp),%eax
  80100d:	8a 00                	mov    (%eax),%al
  80100f:	3c 40                	cmp    $0x40,%al
  801011:	7e 39                	jle    80104c <strtol+0x126>
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	8a 00                	mov    (%eax),%al
  801018:	3c 5a                	cmp    $0x5a,%al
  80101a:	7f 30                	jg     80104c <strtol+0x126>
			dig = *s - 'A' + 10;
  80101c:	8b 45 08             	mov    0x8(%ebp),%eax
  80101f:	8a 00                	mov    (%eax),%al
  801021:	0f be c0             	movsbl %al,%eax
  801024:	83 e8 37             	sub    $0x37,%eax
  801027:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80102a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80102d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801030:	7d 19                	jge    80104b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801032:	ff 45 08             	incl   0x8(%ebp)
  801035:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801038:	0f af 45 10          	imul   0x10(%ebp),%eax
  80103c:	89 c2                	mov    %eax,%edx
  80103e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801041:	01 d0                	add    %edx,%eax
  801043:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801046:	e9 7b ff ff ff       	jmp    800fc6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80104b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80104c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801050:	74 08                	je     80105a <strtol+0x134>
		*endptr = (char *) s;
  801052:	8b 45 0c             	mov    0xc(%ebp),%eax
  801055:	8b 55 08             	mov    0x8(%ebp),%edx
  801058:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80105a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80105e:	74 07                	je     801067 <strtol+0x141>
  801060:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801063:	f7 d8                	neg    %eax
  801065:	eb 03                	jmp    80106a <strtol+0x144>
  801067:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80106a:	c9                   	leave  
  80106b:	c3                   	ret    

0080106c <ltostr>:

void
ltostr(long value, char *str)
{
  80106c:	55                   	push   %ebp
  80106d:	89 e5                	mov    %esp,%ebp
  80106f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801072:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801079:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801080:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801084:	79 13                	jns    801099 <ltostr+0x2d>
	{
		neg = 1;
  801086:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80108d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801090:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801093:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801096:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801099:	8b 45 08             	mov    0x8(%ebp),%eax
  80109c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010a1:	99                   	cltd   
  8010a2:	f7 f9                	idiv   %ecx
  8010a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010aa:	8d 50 01             	lea    0x1(%eax),%edx
  8010ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010b0:	89 c2                	mov    %eax,%edx
  8010b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b5:	01 d0                	add    %edx,%eax
  8010b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010ba:	83 c2 30             	add    $0x30,%edx
  8010bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c7:	f7 e9                	imul   %ecx
  8010c9:	c1 fa 02             	sar    $0x2,%edx
  8010cc:	89 c8                	mov    %ecx,%eax
  8010ce:	c1 f8 1f             	sar    $0x1f,%eax
  8010d1:	29 c2                	sub    %eax,%edx
  8010d3:	89 d0                	mov    %edx,%eax
  8010d5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010e0:	f7 e9                	imul   %ecx
  8010e2:	c1 fa 02             	sar    $0x2,%edx
  8010e5:	89 c8                	mov    %ecx,%eax
  8010e7:	c1 f8 1f             	sar    $0x1f,%eax
  8010ea:	29 c2                	sub    %eax,%edx
  8010ec:	89 d0                	mov    %edx,%eax
  8010ee:	c1 e0 02             	shl    $0x2,%eax
  8010f1:	01 d0                	add    %edx,%eax
  8010f3:	01 c0                	add    %eax,%eax
  8010f5:	29 c1                	sub    %eax,%ecx
  8010f7:	89 ca                	mov    %ecx,%edx
  8010f9:	85 d2                	test   %edx,%edx
  8010fb:	75 9c                	jne    801099 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801104:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801107:	48                   	dec    %eax
  801108:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80110b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80110f:	74 3d                	je     80114e <ltostr+0xe2>
		start = 1 ;
  801111:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801118:	eb 34                	jmp    80114e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80111a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80111d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801120:	01 d0                	add    %edx,%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801127:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	01 c2                	add    %eax,%edx
  80112f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	01 c8                	add    %ecx,%eax
  801137:	8a 00                	mov    (%eax),%al
  801139:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80113b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80113e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801141:	01 c2                	add    %eax,%edx
  801143:	8a 45 eb             	mov    -0x15(%ebp),%al
  801146:	88 02                	mov    %al,(%edx)
		start++ ;
  801148:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80114b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80114e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801151:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801154:	7c c4                	jl     80111a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801156:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801159:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115c:	01 d0                	add    %edx,%eax
  80115e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801161:	90                   	nop
  801162:	c9                   	leave  
  801163:	c3                   	ret    

00801164 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801164:	55                   	push   %ebp
  801165:	89 e5                	mov    %esp,%ebp
  801167:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80116a:	ff 75 08             	pushl  0x8(%ebp)
  80116d:	e8 54 fa ff ff       	call   800bc6 <strlen>
  801172:	83 c4 04             	add    $0x4,%esp
  801175:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801178:	ff 75 0c             	pushl  0xc(%ebp)
  80117b:	e8 46 fa ff ff       	call   800bc6 <strlen>
  801180:	83 c4 04             	add    $0x4,%esp
  801183:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801186:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80118d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801194:	eb 17                	jmp    8011ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801196:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801199:	8b 45 10             	mov    0x10(%ebp),%eax
  80119c:	01 c2                	add    %eax,%edx
  80119e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	01 c8                	add    %ecx,%eax
  8011a6:	8a 00                	mov    (%eax),%al
  8011a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011aa:	ff 45 fc             	incl   -0x4(%ebp)
  8011ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011b3:	7c e1                	jl     801196 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011c3:	eb 1f                	jmp    8011e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011c8:	8d 50 01             	lea    0x1(%eax),%edx
  8011cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011ce:	89 c2                	mov    %eax,%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 c2                	add    %eax,%edx
  8011d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	01 c8                	add    %ecx,%eax
  8011dd:	8a 00                	mov    (%eax),%al
  8011df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011e1:	ff 45 f8             	incl   -0x8(%ebp)
  8011e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ea:	7c d9                	jl     8011c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8011f7:	90                   	nop
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801200:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801206:	8b 45 14             	mov    0x14(%ebp),%eax
  801209:	8b 00                	mov    (%eax),%eax
  80120b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801212:	8b 45 10             	mov    0x10(%ebp),%eax
  801215:	01 d0                	add    %edx,%eax
  801217:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80121d:	eb 0c                	jmp    80122b <strsplit+0x31>
			*string++ = 0;
  80121f:	8b 45 08             	mov    0x8(%ebp),%eax
  801222:	8d 50 01             	lea    0x1(%eax),%edx
  801225:	89 55 08             	mov    %edx,0x8(%ebp)
  801228:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80122b:	8b 45 08             	mov    0x8(%ebp),%eax
  80122e:	8a 00                	mov    (%eax),%al
  801230:	84 c0                	test   %al,%al
  801232:	74 18                	je     80124c <strsplit+0x52>
  801234:	8b 45 08             	mov    0x8(%ebp),%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	0f be c0             	movsbl %al,%eax
  80123c:	50                   	push   %eax
  80123d:	ff 75 0c             	pushl  0xc(%ebp)
  801240:	e8 13 fb ff ff       	call   800d58 <strchr>
  801245:	83 c4 08             	add    $0x8,%esp
  801248:	85 c0                	test   %eax,%eax
  80124a:	75 d3                	jne    80121f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80124c:	8b 45 08             	mov    0x8(%ebp),%eax
  80124f:	8a 00                	mov    (%eax),%al
  801251:	84 c0                	test   %al,%al
  801253:	74 5a                	je     8012af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801255:	8b 45 14             	mov    0x14(%ebp),%eax
  801258:	8b 00                	mov    (%eax),%eax
  80125a:	83 f8 0f             	cmp    $0xf,%eax
  80125d:	75 07                	jne    801266 <strsplit+0x6c>
		{
			return 0;
  80125f:	b8 00 00 00 00       	mov    $0x0,%eax
  801264:	eb 66                	jmp    8012cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801266:	8b 45 14             	mov    0x14(%ebp),%eax
  801269:	8b 00                	mov    (%eax),%eax
  80126b:	8d 48 01             	lea    0x1(%eax),%ecx
  80126e:	8b 55 14             	mov    0x14(%ebp),%edx
  801271:	89 0a                	mov    %ecx,(%edx)
  801273:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80127a:	8b 45 10             	mov    0x10(%ebp),%eax
  80127d:	01 c2                	add    %eax,%edx
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801284:	eb 03                	jmp    801289 <strsplit+0x8f>
			string++;
  801286:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801289:	8b 45 08             	mov    0x8(%ebp),%eax
  80128c:	8a 00                	mov    (%eax),%al
  80128e:	84 c0                	test   %al,%al
  801290:	74 8b                	je     80121d <strsplit+0x23>
  801292:	8b 45 08             	mov    0x8(%ebp),%eax
  801295:	8a 00                	mov    (%eax),%al
  801297:	0f be c0             	movsbl %al,%eax
  80129a:	50                   	push   %eax
  80129b:	ff 75 0c             	pushl  0xc(%ebp)
  80129e:	e8 b5 fa ff ff       	call   800d58 <strchr>
  8012a3:	83 c4 08             	add    $0x8,%esp
  8012a6:	85 c0                	test   %eax,%eax
  8012a8:	74 dc                	je     801286 <strsplit+0x8c>
			string++;
	}
  8012aa:	e9 6e ff ff ff       	jmp    80121d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b3:	8b 00                	mov    (%eax),%eax
  8012b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bf:	01 d0                	add    %edx,%eax
  8012c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012cc:	c9                   	leave  
  8012cd:	c3                   	ret    

008012ce <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012ce:	55                   	push   %ebp
  8012cf:	89 e5                	mov    %esp,%ebp
  8012d1:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8012d9:	85 c0                	test   %eax,%eax
  8012db:	74 1f                	je     8012fc <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012dd:	e8 1d 00 00 00       	call   8012ff <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012e2:	83 ec 0c             	sub    $0xc,%esp
  8012e5:	68 30 3a 80 00       	push   $0x803a30
  8012ea:	e8 55 f2 ff ff       	call   800544 <cprintf>
  8012ef:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012f2:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012f9:	00 00 00 
	}
}
  8012fc:	90                   	nop
  8012fd:	c9                   	leave  
  8012fe:	c3                   	ret    

008012ff <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ff:	55                   	push   %ebp
  801300:	89 e5                	mov    %esp,%ebp
  801302:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801305:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80130c:	00 00 00 
  80130f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801316:	00 00 00 
  801319:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801320:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801323:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80132a:	00 00 00 
  80132d:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801334:	00 00 00 
  801337:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80133e:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801341:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801348:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80134b:	c1 e8 0c             	shr    $0xc,%eax
  80134e:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801353:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801362:	2d 00 10 00 00       	sub    $0x1000,%eax
  801367:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  80136c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801373:	a1 20 41 80 00       	mov    0x804120,%eax
  801378:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  80137c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  80137f:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801386:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801389:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80138c:	01 d0                	add    %edx,%eax
  80138e:	48                   	dec    %eax
  80138f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801392:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801395:	ba 00 00 00 00       	mov    $0x0,%edx
  80139a:	f7 75 e4             	divl   -0x1c(%ebp)
  80139d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013a0:	29 d0                	sub    %edx,%eax
  8013a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8013a5:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8013ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013b4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013b9:	83 ec 04             	sub    $0x4,%esp
  8013bc:	6a 07                	push   $0x7
  8013be:	ff 75 e8             	pushl  -0x18(%ebp)
  8013c1:	50                   	push   %eax
  8013c2:	e8 3d 06 00 00       	call   801a04 <sys_allocate_chunk>
  8013c7:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ca:	a1 20 41 80 00       	mov    0x804120,%eax
  8013cf:	83 ec 0c             	sub    $0xc,%esp
  8013d2:	50                   	push   %eax
  8013d3:	e8 b2 0c 00 00       	call   80208a <initialize_MemBlocksList>
  8013d8:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8013db:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8013e3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013e7:	0f 84 f3 00 00 00    	je     8014e0 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8013ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013f1:	75 14                	jne    801407 <initialize_dyn_block_system+0x108>
  8013f3:	83 ec 04             	sub    $0x4,%esp
  8013f6:	68 55 3a 80 00       	push   $0x803a55
  8013fb:	6a 36                	push   $0x36
  8013fd:	68 73 3a 80 00       	push   $0x803a73
  801402:	e8 89 ee ff ff       	call   800290 <_panic>
  801407:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80140a:	8b 00                	mov    (%eax),%eax
  80140c:	85 c0                	test   %eax,%eax
  80140e:	74 10                	je     801420 <initialize_dyn_block_system+0x121>
  801410:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801413:	8b 00                	mov    (%eax),%eax
  801415:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801418:	8b 52 04             	mov    0x4(%edx),%edx
  80141b:	89 50 04             	mov    %edx,0x4(%eax)
  80141e:	eb 0b                	jmp    80142b <initialize_dyn_block_system+0x12c>
  801420:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801423:	8b 40 04             	mov    0x4(%eax),%eax
  801426:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80142b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80142e:	8b 40 04             	mov    0x4(%eax),%eax
  801431:	85 c0                	test   %eax,%eax
  801433:	74 0f                	je     801444 <initialize_dyn_block_system+0x145>
  801435:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801438:	8b 40 04             	mov    0x4(%eax),%eax
  80143b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80143e:	8b 12                	mov    (%edx),%edx
  801440:	89 10                	mov    %edx,(%eax)
  801442:	eb 0a                	jmp    80144e <initialize_dyn_block_system+0x14f>
  801444:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801447:	8b 00                	mov    (%eax),%eax
  801449:	a3 48 41 80 00       	mov    %eax,0x804148
  80144e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801451:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801457:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80145a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801461:	a1 54 41 80 00       	mov    0x804154,%eax
  801466:	48                   	dec    %eax
  801467:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  80146c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80146f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801476:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801479:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801480:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801484:	75 14                	jne    80149a <initialize_dyn_block_system+0x19b>
  801486:	83 ec 04             	sub    $0x4,%esp
  801489:	68 80 3a 80 00       	push   $0x803a80
  80148e:	6a 3e                	push   $0x3e
  801490:	68 73 3a 80 00       	push   $0x803a73
  801495:	e8 f6 ed ff ff       	call   800290 <_panic>
  80149a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8014a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014a3:	89 10                	mov    %edx,(%eax)
  8014a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014a8:	8b 00                	mov    (%eax),%eax
  8014aa:	85 c0                	test   %eax,%eax
  8014ac:	74 0d                	je     8014bb <initialize_dyn_block_system+0x1bc>
  8014ae:	a1 38 41 80 00       	mov    0x804138,%eax
  8014b3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014b6:	89 50 04             	mov    %edx,0x4(%eax)
  8014b9:	eb 08                	jmp    8014c3 <initialize_dyn_block_system+0x1c4>
  8014bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014be:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8014cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014d5:	a1 44 41 80 00       	mov    0x804144,%eax
  8014da:	40                   	inc    %eax
  8014db:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8014e0:	90                   	nop
  8014e1:	c9                   	leave  
  8014e2:	c3                   	ret    

008014e3 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014e3:	55                   	push   %ebp
  8014e4:	89 e5                	mov    %esp,%ebp
  8014e6:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8014e9:	e8 e0 fd ff ff       	call   8012ce <InitializeUHeap>
		if (size == 0) return NULL ;
  8014ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f2:	75 07                	jne    8014fb <malloc+0x18>
  8014f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f9:	eb 7f                	jmp    80157a <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8014fb:	e8 d2 08 00 00       	call   801dd2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801500:	85 c0                	test   %eax,%eax
  801502:	74 71                	je     801575 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801504:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80150b:	8b 55 08             	mov    0x8(%ebp),%edx
  80150e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801511:	01 d0                	add    %edx,%eax
  801513:	48                   	dec    %eax
  801514:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801517:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151a:	ba 00 00 00 00       	mov    $0x0,%edx
  80151f:	f7 75 f4             	divl   -0xc(%ebp)
  801522:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801525:	29 d0                	sub    %edx,%eax
  801527:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  80152a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801531:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801538:	76 07                	jbe    801541 <malloc+0x5e>
					return NULL ;
  80153a:	b8 00 00 00 00       	mov    $0x0,%eax
  80153f:	eb 39                	jmp    80157a <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801541:	83 ec 0c             	sub    $0xc,%esp
  801544:	ff 75 08             	pushl  0x8(%ebp)
  801547:	e8 e6 0d 00 00       	call   802332 <alloc_block_FF>
  80154c:	83 c4 10             	add    $0x10,%esp
  80154f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801552:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801556:	74 16                	je     80156e <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801558:	83 ec 0c             	sub    $0xc,%esp
  80155b:	ff 75 ec             	pushl  -0x14(%ebp)
  80155e:	e8 37 0c 00 00       	call   80219a <insert_sorted_allocList>
  801563:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801566:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801569:	8b 40 08             	mov    0x8(%eax),%eax
  80156c:	eb 0c                	jmp    80157a <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  80156e:	b8 00 00 00 00       	mov    $0x0,%eax
  801573:	eb 05                	jmp    80157a <malloc+0x97>
				}
		}
	return 0;
  801575:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80157a:	c9                   	leave  
  80157b:	c3                   	ret    

0080157c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80157c:	55                   	push   %ebp
  80157d:	89 e5                	mov    %esp,%ebp
  80157f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801582:	8b 45 08             	mov    0x8(%ebp),%eax
  801585:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801588:	83 ec 08             	sub    $0x8,%esp
  80158b:	ff 75 f4             	pushl  -0xc(%ebp)
  80158e:	68 40 40 80 00       	push   $0x804040
  801593:	e8 cf 0b 00 00       	call   802167 <find_block>
  801598:	83 c4 10             	add    $0x10,%esp
  80159b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  80159e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8015a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8015a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015aa:	8b 40 08             	mov    0x8(%eax),%eax
  8015ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8015b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015b4:	0f 84 a1 00 00 00    	je     80165b <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8015ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015be:	75 17                	jne    8015d7 <free+0x5b>
  8015c0:	83 ec 04             	sub    $0x4,%esp
  8015c3:	68 55 3a 80 00       	push   $0x803a55
  8015c8:	68 80 00 00 00       	push   $0x80
  8015cd:	68 73 3a 80 00       	push   $0x803a73
  8015d2:	e8 b9 ec ff ff       	call   800290 <_panic>
  8015d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015da:	8b 00                	mov    (%eax),%eax
  8015dc:	85 c0                	test   %eax,%eax
  8015de:	74 10                	je     8015f0 <free+0x74>
  8015e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e3:	8b 00                	mov    (%eax),%eax
  8015e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015e8:	8b 52 04             	mov    0x4(%edx),%edx
  8015eb:	89 50 04             	mov    %edx,0x4(%eax)
  8015ee:	eb 0b                	jmp    8015fb <free+0x7f>
  8015f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f3:	8b 40 04             	mov    0x4(%eax),%eax
  8015f6:	a3 44 40 80 00       	mov    %eax,0x804044
  8015fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fe:	8b 40 04             	mov    0x4(%eax),%eax
  801601:	85 c0                	test   %eax,%eax
  801603:	74 0f                	je     801614 <free+0x98>
  801605:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801608:	8b 40 04             	mov    0x4(%eax),%eax
  80160b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80160e:	8b 12                	mov    (%edx),%edx
  801610:	89 10                	mov    %edx,(%eax)
  801612:	eb 0a                	jmp    80161e <free+0xa2>
  801614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801617:	8b 00                	mov    (%eax),%eax
  801619:	a3 40 40 80 00       	mov    %eax,0x804040
  80161e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801621:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801627:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801631:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801636:	48                   	dec    %eax
  801637:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  80163c:	83 ec 0c             	sub    $0xc,%esp
  80163f:	ff 75 f0             	pushl  -0x10(%ebp)
  801642:	e8 29 12 00 00       	call   802870 <insert_sorted_with_merge_freeList>
  801647:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  80164a:	83 ec 08             	sub    $0x8,%esp
  80164d:	ff 75 ec             	pushl  -0x14(%ebp)
  801650:	ff 75 e8             	pushl  -0x18(%ebp)
  801653:	e8 74 03 00 00       	call   8019cc <sys_free_user_mem>
  801658:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80165b:	90                   	nop
  80165c:	c9                   	leave  
  80165d:	c3                   	ret    

0080165e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  80165e:	55                   	push   %ebp
  80165f:	89 e5                	mov    %esp,%ebp
  801661:	83 ec 38             	sub    $0x38,%esp
  801664:	8b 45 10             	mov    0x10(%ebp),%eax
  801667:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80166a:	e8 5f fc ff ff       	call   8012ce <InitializeUHeap>
	if (size == 0) return NULL ;
  80166f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801673:	75 0a                	jne    80167f <smalloc+0x21>
  801675:	b8 00 00 00 00       	mov    $0x0,%eax
  80167a:	e9 b2 00 00 00       	jmp    801731 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  80167f:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801686:	76 0a                	jbe    801692 <smalloc+0x34>
		return NULL;
  801688:	b8 00 00 00 00       	mov    $0x0,%eax
  80168d:	e9 9f 00 00 00       	jmp    801731 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801692:	e8 3b 07 00 00       	call   801dd2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801697:	85 c0                	test   %eax,%eax
  801699:	0f 84 8d 00 00 00    	je     80172c <smalloc+0xce>
	struct MemBlock *b = NULL;
  80169f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8016a6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b3:	01 d0                	add    %edx,%eax
  8016b5:	48                   	dec    %eax
  8016b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8016c1:	f7 75 f0             	divl   -0x10(%ebp)
  8016c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016c7:	29 d0                	sub    %edx,%eax
  8016c9:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8016cc:	83 ec 0c             	sub    $0xc,%esp
  8016cf:	ff 75 e8             	pushl  -0x18(%ebp)
  8016d2:	e8 5b 0c 00 00       	call   802332 <alloc_block_FF>
  8016d7:	83 c4 10             	add    $0x10,%esp
  8016da:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8016dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016e1:	75 07                	jne    8016ea <smalloc+0x8c>
			return NULL;
  8016e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e8:	eb 47                	jmp    801731 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8016ea:	83 ec 0c             	sub    $0xc,%esp
  8016ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8016f0:	e8 a5 0a 00 00       	call   80219a <insert_sorted_allocList>
  8016f5:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8016f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016fb:	8b 40 08             	mov    0x8(%eax),%eax
  8016fe:	89 c2                	mov    %eax,%edx
  801700:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801704:	52                   	push   %edx
  801705:	50                   	push   %eax
  801706:	ff 75 0c             	pushl  0xc(%ebp)
  801709:	ff 75 08             	pushl  0x8(%ebp)
  80170c:	e8 46 04 00 00       	call   801b57 <sys_createSharedObject>
  801711:	83 c4 10             	add    $0x10,%esp
  801714:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801717:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80171b:	78 08                	js     801725 <smalloc+0xc7>
		return (void *)b->sva;
  80171d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801720:	8b 40 08             	mov    0x8(%eax),%eax
  801723:	eb 0c                	jmp    801731 <smalloc+0xd3>
		}else{
		return NULL;
  801725:	b8 00 00 00 00       	mov    $0x0,%eax
  80172a:	eb 05                	jmp    801731 <smalloc+0xd3>
			}

	}return NULL;
  80172c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801739:	e8 90 fb ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80173e:	e8 8f 06 00 00       	call   801dd2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801743:	85 c0                	test   %eax,%eax
  801745:	0f 84 ad 00 00 00    	je     8017f8 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80174b:	83 ec 08             	sub    $0x8,%esp
  80174e:	ff 75 0c             	pushl  0xc(%ebp)
  801751:	ff 75 08             	pushl  0x8(%ebp)
  801754:	e8 28 04 00 00       	call   801b81 <sys_getSizeOfSharedObject>
  801759:	83 c4 10             	add    $0x10,%esp
  80175c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  80175f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801763:	79 0a                	jns    80176f <sget+0x3c>
    {
    	return NULL;
  801765:	b8 00 00 00 00       	mov    $0x0,%eax
  80176a:	e9 8e 00 00 00       	jmp    8017fd <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  80176f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801776:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80177d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801780:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801783:	01 d0                	add    %edx,%eax
  801785:	48                   	dec    %eax
  801786:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801789:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80178c:	ba 00 00 00 00       	mov    $0x0,%edx
  801791:	f7 75 ec             	divl   -0x14(%ebp)
  801794:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801797:	29 d0                	sub    %edx,%eax
  801799:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  80179c:	83 ec 0c             	sub    $0xc,%esp
  80179f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017a2:	e8 8b 0b 00 00       	call   802332 <alloc_block_FF>
  8017a7:	83 c4 10             	add    $0x10,%esp
  8017aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8017ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017b1:	75 07                	jne    8017ba <sget+0x87>
				return NULL;
  8017b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017b8:	eb 43                	jmp    8017fd <sget+0xca>
			}
			insert_sorted_allocList(b);
  8017ba:	83 ec 0c             	sub    $0xc,%esp
  8017bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8017c0:	e8 d5 09 00 00       	call   80219a <insert_sorted_allocList>
  8017c5:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8017c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cb:	8b 40 08             	mov    0x8(%eax),%eax
  8017ce:	83 ec 04             	sub    $0x4,%esp
  8017d1:	50                   	push   %eax
  8017d2:	ff 75 0c             	pushl  0xc(%ebp)
  8017d5:	ff 75 08             	pushl  0x8(%ebp)
  8017d8:	e8 c1 03 00 00       	call   801b9e <sys_getSharedObject>
  8017dd:	83 c4 10             	add    $0x10,%esp
  8017e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8017e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017e7:	78 08                	js     8017f1 <sget+0xbe>
			return (void *)b->sva;
  8017e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ec:	8b 40 08             	mov    0x8(%eax),%eax
  8017ef:	eb 0c                	jmp    8017fd <sget+0xca>
			}else{
			return NULL;
  8017f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f6:	eb 05                	jmp    8017fd <sget+0xca>
			}
    }}return NULL;
  8017f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
  801802:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801805:	e8 c4 fa ff ff       	call   8012ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80180a:	83 ec 04             	sub    $0x4,%esp
  80180d:	68 a4 3a 80 00       	push   $0x803aa4
  801812:	68 03 01 00 00       	push   $0x103
  801817:	68 73 3a 80 00       	push   $0x803a73
  80181c:	e8 6f ea ff ff       	call   800290 <_panic>

00801821 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801821:	55                   	push   %ebp
  801822:	89 e5                	mov    %esp,%ebp
  801824:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801827:	83 ec 04             	sub    $0x4,%esp
  80182a:	68 cc 3a 80 00       	push   $0x803acc
  80182f:	68 17 01 00 00       	push   $0x117
  801834:	68 73 3a 80 00       	push   $0x803a73
  801839:	e8 52 ea ff ff       	call   800290 <_panic>

0080183e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801844:	83 ec 04             	sub    $0x4,%esp
  801847:	68 f0 3a 80 00       	push   $0x803af0
  80184c:	68 22 01 00 00       	push   $0x122
  801851:	68 73 3a 80 00       	push   $0x803a73
  801856:	e8 35 ea ff ff       	call   800290 <_panic>

0080185b <shrink>:

}
void shrink(uint32 newSize)
{
  80185b:	55                   	push   %ebp
  80185c:	89 e5                	mov    %esp,%ebp
  80185e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801861:	83 ec 04             	sub    $0x4,%esp
  801864:	68 f0 3a 80 00       	push   $0x803af0
  801869:	68 27 01 00 00       	push   $0x127
  80186e:	68 73 3a 80 00       	push   $0x803a73
  801873:	e8 18 ea ff ff       	call   800290 <_panic>

00801878 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
  80187b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80187e:	83 ec 04             	sub    $0x4,%esp
  801881:	68 f0 3a 80 00       	push   $0x803af0
  801886:	68 2c 01 00 00       	push   $0x12c
  80188b:	68 73 3a 80 00       	push   $0x803a73
  801890:	e8 fb e9 ff ff       	call   800290 <_panic>

00801895 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	57                   	push   %edi
  801899:	56                   	push   %esi
  80189a:	53                   	push   %ebx
  80189b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80189e:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018aa:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018ad:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018b0:	cd 30                	int    $0x30
  8018b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018b8:	83 c4 10             	add    $0x10,%esp
  8018bb:	5b                   	pop    %ebx
  8018bc:	5e                   	pop    %esi
  8018bd:	5f                   	pop    %edi
  8018be:	5d                   	pop    %ebp
  8018bf:	c3                   	ret    

008018c0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
  8018c3:	83 ec 04             	sub    $0x4,%esp
  8018c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8018c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018cc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	52                   	push   %edx
  8018d8:	ff 75 0c             	pushl  0xc(%ebp)
  8018db:	50                   	push   %eax
  8018dc:	6a 00                	push   $0x0
  8018de:	e8 b2 ff ff ff       	call   801895 <syscall>
  8018e3:	83 c4 18             	add    $0x18,%esp
}
  8018e6:	90                   	nop
  8018e7:	c9                   	leave  
  8018e8:	c3                   	ret    

008018e9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018e9:	55                   	push   %ebp
  8018ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 01                	push   $0x1
  8018f8:	e8 98 ff ff ff       	call   801895 <syscall>
  8018fd:	83 c4 18             	add    $0x18,%esp
}
  801900:	c9                   	leave  
  801901:	c3                   	ret    

00801902 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801902:	55                   	push   %ebp
  801903:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801905:	8b 55 0c             	mov    0xc(%ebp),%edx
  801908:	8b 45 08             	mov    0x8(%ebp),%eax
  80190b:	6a 00                	push   $0x0
  80190d:	6a 00                	push   $0x0
  80190f:	6a 00                	push   $0x0
  801911:	52                   	push   %edx
  801912:	50                   	push   %eax
  801913:	6a 05                	push   $0x5
  801915:	e8 7b ff ff ff       	call   801895 <syscall>
  80191a:	83 c4 18             	add    $0x18,%esp
}
  80191d:	c9                   	leave  
  80191e:	c3                   	ret    

0080191f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80191f:	55                   	push   %ebp
  801920:	89 e5                	mov    %esp,%ebp
  801922:	56                   	push   %esi
  801923:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801924:	8b 75 18             	mov    0x18(%ebp),%esi
  801927:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80192a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80192d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	56                   	push   %esi
  801934:	53                   	push   %ebx
  801935:	51                   	push   %ecx
  801936:	52                   	push   %edx
  801937:	50                   	push   %eax
  801938:	6a 06                	push   $0x6
  80193a:	e8 56 ff ff ff       	call   801895 <syscall>
  80193f:	83 c4 18             	add    $0x18,%esp
}
  801942:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801945:	5b                   	pop    %ebx
  801946:	5e                   	pop    %esi
  801947:	5d                   	pop    %ebp
  801948:	c3                   	ret    

00801949 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801949:	55                   	push   %ebp
  80194a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80194c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80194f:	8b 45 08             	mov    0x8(%ebp),%eax
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	52                   	push   %edx
  801959:	50                   	push   %eax
  80195a:	6a 07                	push   $0x7
  80195c:	e8 34 ff ff ff       	call   801895 <syscall>
  801961:	83 c4 18             	add    $0x18,%esp
}
  801964:	c9                   	leave  
  801965:	c3                   	ret    

00801966 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801966:	55                   	push   %ebp
  801967:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	ff 75 0c             	pushl  0xc(%ebp)
  801972:	ff 75 08             	pushl  0x8(%ebp)
  801975:	6a 08                	push   $0x8
  801977:	e8 19 ff ff ff       	call   801895 <syscall>
  80197c:	83 c4 18             	add    $0x18,%esp
}
  80197f:	c9                   	leave  
  801980:	c3                   	ret    

00801981 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801981:	55                   	push   %ebp
  801982:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 00                	push   $0x0
  80198e:	6a 09                	push   $0x9
  801990:	e8 00 ff ff ff       	call   801895 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
}
  801998:	c9                   	leave  
  801999:	c3                   	ret    

0080199a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 0a                	push   $0xa
  8019a9:	e8 e7 fe ff ff       	call   801895 <syscall>
  8019ae:	83 c4 18             	add    $0x18,%esp
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 0b                	push   $0xb
  8019c2:	e8 ce fe ff ff       	call   801895 <syscall>
  8019c7:	83 c4 18             	add    $0x18,%esp
}
  8019ca:	c9                   	leave  
  8019cb:	c3                   	ret    

008019cc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019cc:	55                   	push   %ebp
  8019cd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019cf:	6a 00                	push   $0x0
  8019d1:	6a 00                	push   $0x0
  8019d3:	6a 00                	push   $0x0
  8019d5:	ff 75 0c             	pushl  0xc(%ebp)
  8019d8:	ff 75 08             	pushl  0x8(%ebp)
  8019db:	6a 0f                	push   $0xf
  8019dd:	e8 b3 fe ff ff       	call   801895 <syscall>
  8019e2:	83 c4 18             	add    $0x18,%esp
	return;
  8019e5:	90                   	nop
}
  8019e6:	c9                   	leave  
  8019e7:	c3                   	ret    

008019e8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019e8:	55                   	push   %ebp
  8019e9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019eb:	6a 00                	push   $0x0
  8019ed:	6a 00                	push   $0x0
  8019ef:	6a 00                	push   $0x0
  8019f1:	ff 75 0c             	pushl  0xc(%ebp)
  8019f4:	ff 75 08             	pushl  0x8(%ebp)
  8019f7:	6a 10                	push   $0x10
  8019f9:	e8 97 fe ff ff       	call   801895 <syscall>
  8019fe:	83 c4 18             	add    $0x18,%esp
	return ;
  801a01:	90                   	nop
}
  801a02:	c9                   	leave  
  801a03:	c3                   	ret    

00801a04 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a04:	55                   	push   %ebp
  801a05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	ff 75 10             	pushl  0x10(%ebp)
  801a0e:	ff 75 0c             	pushl  0xc(%ebp)
  801a11:	ff 75 08             	pushl  0x8(%ebp)
  801a14:	6a 11                	push   $0x11
  801a16:	e8 7a fe ff ff       	call   801895 <syscall>
  801a1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1e:	90                   	nop
}
  801a1f:	c9                   	leave  
  801a20:	c3                   	ret    

00801a21 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a21:	55                   	push   %ebp
  801a22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 0c                	push   $0xc
  801a30:	e8 60 fe ff ff       	call   801895 <syscall>
  801a35:	83 c4 18             	add    $0x18,%esp
}
  801a38:	c9                   	leave  
  801a39:	c3                   	ret    

00801a3a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a3a:	55                   	push   %ebp
  801a3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a3d:	6a 00                	push   $0x0
  801a3f:	6a 00                	push   $0x0
  801a41:	6a 00                	push   $0x0
  801a43:	6a 00                	push   $0x0
  801a45:	ff 75 08             	pushl  0x8(%ebp)
  801a48:	6a 0d                	push   $0xd
  801a4a:	e8 46 fe ff ff       	call   801895 <syscall>
  801a4f:	83 c4 18             	add    $0x18,%esp
}
  801a52:	c9                   	leave  
  801a53:	c3                   	ret    

00801a54 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a54:	55                   	push   %ebp
  801a55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a57:	6a 00                	push   $0x0
  801a59:	6a 00                	push   $0x0
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 0e                	push   $0xe
  801a63:	e8 2d fe ff ff       	call   801895 <syscall>
  801a68:	83 c4 18             	add    $0x18,%esp
}
  801a6b:	90                   	nop
  801a6c:	c9                   	leave  
  801a6d:	c3                   	ret    

00801a6e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a6e:	55                   	push   %ebp
  801a6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 13                	push   $0x13
  801a7d:	e8 13 fe ff ff       	call   801895 <syscall>
  801a82:	83 c4 18             	add    $0x18,%esp
}
  801a85:	90                   	nop
  801a86:	c9                   	leave  
  801a87:	c3                   	ret    

00801a88 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a88:	55                   	push   %ebp
  801a89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 14                	push   $0x14
  801a97:	e8 f9 fd ff ff       	call   801895 <syscall>
  801a9c:	83 c4 18             	add    $0x18,%esp
}
  801a9f:	90                   	nop
  801aa0:	c9                   	leave  
  801aa1:	c3                   	ret    

00801aa2 <sys_cputc>:


void
sys_cputc(const char c)
{
  801aa2:	55                   	push   %ebp
  801aa3:	89 e5                	mov    %esp,%ebp
  801aa5:	83 ec 04             	sub    $0x4,%esp
  801aa8:	8b 45 08             	mov    0x8(%ebp),%eax
  801aab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801aae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	50                   	push   %eax
  801abb:	6a 15                	push   $0x15
  801abd:	e8 d3 fd ff ff       	call   801895 <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	90                   	nop
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 16                	push   $0x16
  801ad7:	e8 b9 fd ff ff       	call   801895 <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
}
  801adf:	90                   	nop
  801ae0:	c9                   	leave  
  801ae1:	c3                   	ret    

00801ae2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ae2:	55                   	push   %ebp
  801ae3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	ff 75 0c             	pushl  0xc(%ebp)
  801af1:	50                   	push   %eax
  801af2:	6a 17                	push   $0x17
  801af4:	e8 9c fd ff ff       	call   801895 <syscall>
  801af9:	83 c4 18             	add    $0x18,%esp
}
  801afc:	c9                   	leave  
  801afd:	c3                   	ret    

00801afe <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801afe:	55                   	push   %ebp
  801aff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b04:	8b 45 08             	mov    0x8(%ebp),%eax
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	52                   	push   %edx
  801b0e:	50                   	push   %eax
  801b0f:	6a 1a                	push   $0x1a
  801b11:	e8 7f fd ff ff       	call   801895 <syscall>
  801b16:	83 c4 18             	add    $0x18,%esp
}
  801b19:	c9                   	leave  
  801b1a:	c3                   	ret    

00801b1b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b21:	8b 45 08             	mov    0x8(%ebp),%eax
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	52                   	push   %edx
  801b2b:	50                   	push   %eax
  801b2c:	6a 18                	push   $0x18
  801b2e:	e8 62 fd ff ff       	call   801895 <syscall>
  801b33:	83 c4 18             	add    $0x18,%esp
}
  801b36:	90                   	nop
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    

00801b39 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b39:	55                   	push   %ebp
  801b3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	52                   	push   %edx
  801b49:	50                   	push   %eax
  801b4a:	6a 19                	push   $0x19
  801b4c:	e8 44 fd ff ff       	call   801895 <syscall>
  801b51:	83 c4 18             	add    $0x18,%esp
}
  801b54:	90                   	nop
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
  801b5a:	83 ec 04             	sub    $0x4,%esp
  801b5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801b60:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b63:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b66:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6d:	6a 00                	push   $0x0
  801b6f:	51                   	push   %ecx
  801b70:	52                   	push   %edx
  801b71:	ff 75 0c             	pushl  0xc(%ebp)
  801b74:	50                   	push   %eax
  801b75:	6a 1b                	push   $0x1b
  801b77:	e8 19 fd ff ff       	call   801895 <syscall>
  801b7c:	83 c4 18             	add    $0x18,%esp
}
  801b7f:	c9                   	leave  
  801b80:	c3                   	ret    

00801b81 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b81:	55                   	push   %ebp
  801b82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b87:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8a:	6a 00                	push   $0x0
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	52                   	push   %edx
  801b91:	50                   	push   %eax
  801b92:	6a 1c                	push   $0x1c
  801b94:	e8 fc fc ff ff       	call   801895 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ba1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ba4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	51                   	push   %ecx
  801baf:	52                   	push   %edx
  801bb0:	50                   	push   %eax
  801bb1:	6a 1d                	push   $0x1d
  801bb3:	e8 dd fc ff ff       	call   801895 <syscall>
  801bb8:	83 c4 18             	add    $0x18,%esp
}
  801bbb:	c9                   	leave  
  801bbc:	c3                   	ret    

00801bbd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801bbd:	55                   	push   %ebp
  801bbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801bc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 00                	push   $0x0
  801bca:	6a 00                	push   $0x0
  801bcc:	52                   	push   %edx
  801bcd:	50                   	push   %eax
  801bce:	6a 1e                	push   $0x1e
  801bd0:	e8 c0 fc ff ff       	call   801895 <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 1f                	push   $0x1f
  801be9:	e8 a7 fc ff ff       	call   801895 <syscall>
  801bee:	83 c4 18             	add    $0x18,%esp
}
  801bf1:	c9                   	leave  
  801bf2:	c3                   	ret    

00801bf3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bf3:	55                   	push   %ebp
  801bf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf9:	6a 00                	push   $0x0
  801bfb:	ff 75 14             	pushl  0x14(%ebp)
  801bfe:	ff 75 10             	pushl  0x10(%ebp)
  801c01:	ff 75 0c             	pushl  0xc(%ebp)
  801c04:	50                   	push   %eax
  801c05:	6a 20                	push   $0x20
  801c07:	e8 89 fc ff ff       	call   801895 <syscall>
  801c0c:	83 c4 18             	add    $0x18,%esp
}
  801c0f:	c9                   	leave  
  801c10:	c3                   	ret    

00801c11 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c11:	55                   	push   %ebp
  801c12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c14:	8b 45 08             	mov    0x8(%ebp),%eax
  801c17:	6a 00                	push   $0x0
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	50                   	push   %eax
  801c20:	6a 21                	push   $0x21
  801c22:	e8 6e fc ff ff       	call   801895 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
}
  801c2a:	90                   	nop
  801c2b:	c9                   	leave  
  801c2c:	c3                   	ret    

00801c2d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c2d:	55                   	push   %ebp
  801c2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c30:	8b 45 08             	mov    0x8(%ebp),%eax
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	50                   	push   %eax
  801c3c:	6a 22                	push   $0x22
  801c3e:	e8 52 fc ff ff       	call   801895 <syscall>
  801c43:	83 c4 18             	add    $0x18,%esp
}
  801c46:	c9                   	leave  
  801c47:	c3                   	ret    

00801c48 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c48:	55                   	push   %ebp
  801c49:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	6a 02                	push   $0x2
  801c57:	e8 39 fc ff ff       	call   801895 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
}
  801c5f:	c9                   	leave  
  801c60:	c3                   	ret    

00801c61 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c61:	55                   	push   %ebp
  801c62:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 03                	push   $0x3
  801c70:	e8 20 fc ff ff       	call   801895 <syscall>
  801c75:	83 c4 18             	add    $0x18,%esp
}
  801c78:	c9                   	leave  
  801c79:	c3                   	ret    

00801c7a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c7a:	55                   	push   %ebp
  801c7b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 00                	push   $0x0
  801c83:	6a 00                	push   $0x0
  801c85:	6a 00                	push   $0x0
  801c87:	6a 04                	push   $0x4
  801c89:	e8 07 fc ff ff       	call   801895 <syscall>
  801c8e:	83 c4 18             	add    $0x18,%esp
}
  801c91:	c9                   	leave  
  801c92:	c3                   	ret    

00801c93 <sys_exit_env>:


void sys_exit_env(void)
{
  801c93:	55                   	push   %ebp
  801c94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c96:	6a 00                	push   $0x0
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 23                	push   $0x23
  801ca2:	e8 ee fb ff ff       	call   801895 <syscall>
  801ca7:	83 c4 18             	add    $0x18,%esp
}
  801caa:	90                   	nop
  801cab:	c9                   	leave  
  801cac:	c3                   	ret    

00801cad <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cad:	55                   	push   %ebp
  801cae:	89 e5                	mov    %esp,%ebp
  801cb0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cb3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cb6:	8d 50 04             	lea    0x4(%eax),%edx
  801cb9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	52                   	push   %edx
  801cc3:	50                   	push   %eax
  801cc4:	6a 24                	push   $0x24
  801cc6:	e8 ca fb ff ff       	call   801895 <syscall>
  801ccb:	83 c4 18             	add    $0x18,%esp
	return result;
  801cce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cd4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cd7:	89 01                	mov    %eax,(%ecx)
  801cd9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801cdf:	c9                   	leave  
  801ce0:	c2 04 00             	ret    $0x4

00801ce3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	ff 75 10             	pushl  0x10(%ebp)
  801ced:	ff 75 0c             	pushl  0xc(%ebp)
  801cf0:	ff 75 08             	pushl  0x8(%ebp)
  801cf3:	6a 12                	push   $0x12
  801cf5:	e8 9b fb ff ff       	call   801895 <syscall>
  801cfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801cfd:	90                   	nop
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d03:	6a 00                	push   $0x0
  801d05:	6a 00                	push   $0x0
  801d07:	6a 00                	push   $0x0
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 25                	push   $0x25
  801d0f:	e8 81 fb ff ff       	call   801895 <syscall>
  801d14:	83 c4 18             	add    $0x18,%esp
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 04             	sub    $0x4,%esp
  801d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801d22:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d25:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	50                   	push   %eax
  801d32:	6a 26                	push   $0x26
  801d34:	e8 5c fb ff ff       	call   801895 <syscall>
  801d39:	83 c4 18             	add    $0x18,%esp
	return ;
  801d3c:	90                   	nop
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <rsttst>:
void rsttst()
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 28                	push   $0x28
  801d4e:	e8 42 fb ff ff       	call   801895 <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
	return ;
  801d56:	90                   	nop
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
  801d5c:	83 ec 04             	sub    $0x4,%esp
  801d5f:	8b 45 14             	mov    0x14(%ebp),%eax
  801d62:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d65:	8b 55 18             	mov    0x18(%ebp),%edx
  801d68:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d6c:	52                   	push   %edx
  801d6d:	50                   	push   %eax
  801d6e:	ff 75 10             	pushl  0x10(%ebp)
  801d71:	ff 75 0c             	pushl  0xc(%ebp)
  801d74:	ff 75 08             	pushl  0x8(%ebp)
  801d77:	6a 27                	push   $0x27
  801d79:	e8 17 fb ff ff       	call   801895 <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d81:	90                   	nop
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <chktst>:
void chktst(uint32 n)
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	ff 75 08             	pushl  0x8(%ebp)
  801d92:	6a 29                	push   $0x29
  801d94:	e8 fc fa ff ff       	call   801895 <syscall>
  801d99:	83 c4 18             	add    $0x18,%esp
	return ;
  801d9c:	90                   	nop
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    

00801d9f <inctst>:

void inctst()
{
  801d9f:	55                   	push   %ebp
  801da0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801da2:	6a 00                	push   $0x0
  801da4:	6a 00                	push   $0x0
  801da6:	6a 00                	push   $0x0
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 2a                	push   $0x2a
  801dae:	e8 e2 fa ff ff       	call   801895 <syscall>
  801db3:	83 c4 18             	add    $0x18,%esp
	return ;
  801db6:	90                   	nop
}
  801db7:	c9                   	leave  
  801db8:	c3                   	ret    

00801db9 <gettst>:
uint32 gettst()
{
  801db9:	55                   	push   %ebp
  801dba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	6a 00                	push   $0x0
  801dc6:	6a 2b                	push   $0x2b
  801dc8:	e8 c8 fa ff ff       	call   801895 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	c9                   	leave  
  801dd1:	c3                   	ret    

00801dd2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801dd2:	55                   	push   %ebp
  801dd3:	89 e5                	mov    %esp,%ebp
  801dd5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 2c                	push   $0x2c
  801de4:	e8 ac fa ff ff       	call   801895 <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
  801dec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801def:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801df3:	75 07                	jne    801dfc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801df5:	b8 01 00 00 00       	mov    $0x1,%eax
  801dfa:	eb 05                	jmp    801e01 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dfc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e01:	c9                   	leave  
  801e02:	c3                   	ret    

00801e03 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e03:	55                   	push   %ebp
  801e04:	89 e5                	mov    %esp,%ebp
  801e06:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 00                	push   $0x0
  801e0f:	6a 00                	push   $0x0
  801e11:	6a 00                	push   $0x0
  801e13:	6a 2c                	push   $0x2c
  801e15:	e8 7b fa ff ff       	call   801895 <syscall>
  801e1a:	83 c4 18             	add    $0x18,%esp
  801e1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e20:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e24:	75 07                	jne    801e2d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e26:	b8 01 00 00 00       	mov    $0x1,%eax
  801e2b:	eb 05                	jmp    801e32 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
  801e37:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 00                	push   $0x0
  801e44:	6a 2c                	push   $0x2c
  801e46:	e8 4a fa ff ff       	call   801895 <syscall>
  801e4b:	83 c4 18             	add    $0x18,%esp
  801e4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e51:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e55:	75 07                	jne    801e5e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e57:	b8 01 00 00 00       	mov    $0x1,%eax
  801e5c:	eb 05                	jmp    801e63 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e63:	c9                   	leave  
  801e64:	c3                   	ret    

00801e65 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e65:	55                   	push   %ebp
  801e66:	89 e5                	mov    %esp,%ebp
  801e68:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6b:	6a 00                	push   $0x0
  801e6d:	6a 00                	push   $0x0
  801e6f:	6a 00                	push   $0x0
  801e71:	6a 00                	push   $0x0
  801e73:	6a 00                	push   $0x0
  801e75:	6a 2c                	push   $0x2c
  801e77:	e8 19 fa ff ff       	call   801895 <syscall>
  801e7c:	83 c4 18             	add    $0x18,%esp
  801e7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e82:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e86:	75 07                	jne    801e8f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e88:	b8 01 00 00 00       	mov    $0x1,%eax
  801e8d:	eb 05                	jmp    801e94 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e94:	c9                   	leave  
  801e95:	c3                   	ret    

00801e96 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e96:	55                   	push   %ebp
  801e97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 00                	push   $0x0
  801e9f:	6a 00                	push   $0x0
  801ea1:	ff 75 08             	pushl  0x8(%ebp)
  801ea4:	6a 2d                	push   $0x2d
  801ea6:	e8 ea f9 ff ff       	call   801895 <syscall>
  801eab:	83 c4 18             	add    $0x18,%esp
	return ;
  801eae:	90                   	nop
}
  801eaf:	c9                   	leave  
  801eb0:	c3                   	ret    

00801eb1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801eb1:	55                   	push   %ebp
  801eb2:	89 e5                	mov    %esp,%ebp
  801eb4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801eb5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801eb8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ebb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec1:	6a 00                	push   $0x0
  801ec3:	53                   	push   %ebx
  801ec4:	51                   	push   %ecx
  801ec5:	52                   	push   %edx
  801ec6:	50                   	push   %eax
  801ec7:	6a 2e                	push   $0x2e
  801ec9:	e8 c7 f9 ff ff       	call   801895 <syscall>
  801ece:	83 c4 18             	add    $0x18,%esp
}
  801ed1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801ed4:	c9                   	leave  
  801ed5:	c3                   	ret    

00801ed6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ed6:	55                   	push   %ebp
  801ed7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ed9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801edc:	8b 45 08             	mov    0x8(%ebp),%eax
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	52                   	push   %edx
  801ee6:	50                   	push   %eax
  801ee7:	6a 2f                	push   $0x2f
  801ee9:	e8 a7 f9 ff ff       	call   801895 <syscall>
  801eee:	83 c4 18             	add    $0x18,%esp
}
  801ef1:	c9                   	leave  
  801ef2:	c3                   	ret    

00801ef3 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ef3:	55                   	push   %ebp
  801ef4:	89 e5                	mov    %esp,%ebp
  801ef6:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ef9:	83 ec 0c             	sub    $0xc,%esp
  801efc:	68 00 3b 80 00       	push   $0x803b00
  801f01:	e8 3e e6 ff ff       	call   800544 <cprintf>
  801f06:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f09:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f10:	83 ec 0c             	sub    $0xc,%esp
  801f13:	68 2c 3b 80 00       	push   $0x803b2c
  801f18:	e8 27 e6 ff ff       	call   800544 <cprintf>
  801f1d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f20:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f24:	a1 38 41 80 00       	mov    0x804138,%eax
  801f29:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f2c:	eb 56                	jmp    801f84 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f2e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f32:	74 1c                	je     801f50 <print_mem_block_lists+0x5d>
  801f34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f37:	8b 50 08             	mov    0x8(%eax),%edx
  801f3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f3d:	8b 48 08             	mov    0x8(%eax),%ecx
  801f40:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f43:	8b 40 0c             	mov    0xc(%eax),%eax
  801f46:	01 c8                	add    %ecx,%eax
  801f48:	39 c2                	cmp    %eax,%edx
  801f4a:	73 04                	jae    801f50 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f4c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f53:	8b 50 08             	mov    0x8(%eax),%edx
  801f56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f59:	8b 40 0c             	mov    0xc(%eax),%eax
  801f5c:	01 c2                	add    %eax,%edx
  801f5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f61:	8b 40 08             	mov    0x8(%eax),%eax
  801f64:	83 ec 04             	sub    $0x4,%esp
  801f67:	52                   	push   %edx
  801f68:	50                   	push   %eax
  801f69:	68 41 3b 80 00       	push   $0x803b41
  801f6e:	e8 d1 e5 ff ff       	call   800544 <cprintf>
  801f73:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f79:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f7c:	a1 40 41 80 00       	mov    0x804140,%eax
  801f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f88:	74 07                	je     801f91 <print_mem_block_lists+0x9e>
  801f8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f8d:	8b 00                	mov    (%eax),%eax
  801f8f:	eb 05                	jmp    801f96 <print_mem_block_lists+0xa3>
  801f91:	b8 00 00 00 00       	mov    $0x0,%eax
  801f96:	a3 40 41 80 00       	mov    %eax,0x804140
  801f9b:	a1 40 41 80 00       	mov    0x804140,%eax
  801fa0:	85 c0                	test   %eax,%eax
  801fa2:	75 8a                	jne    801f2e <print_mem_block_lists+0x3b>
  801fa4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fa8:	75 84                	jne    801f2e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801faa:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fae:	75 10                	jne    801fc0 <print_mem_block_lists+0xcd>
  801fb0:	83 ec 0c             	sub    $0xc,%esp
  801fb3:	68 50 3b 80 00       	push   $0x803b50
  801fb8:	e8 87 e5 ff ff       	call   800544 <cprintf>
  801fbd:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fc0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fc7:	83 ec 0c             	sub    $0xc,%esp
  801fca:	68 74 3b 80 00       	push   $0x803b74
  801fcf:	e8 70 e5 ff ff       	call   800544 <cprintf>
  801fd4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fd7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fdb:	a1 40 40 80 00       	mov    0x804040,%eax
  801fe0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fe3:	eb 56                	jmp    80203b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fe5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fe9:	74 1c                	je     802007 <print_mem_block_lists+0x114>
  801feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fee:	8b 50 08             	mov    0x8(%eax),%edx
  801ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ff4:	8b 48 08             	mov    0x8(%eax),%ecx
  801ff7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ffa:	8b 40 0c             	mov    0xc(%eax),%eax
  801ffd:	01 c8                	add    %ecx,%eax
  801fff:	39 c2                	cmp    %eax,%edx
  802001:	73 04                	jae    802007 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802003:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802007:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200a:	8b 50 08             	mov    0x8(%eax),%edx
  80200d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802010:	8b 40 0c             	mov    0xc(%eax),%eax
  802013:	01 c2                	add    %eax,%edx
  802015:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802018:	8b 40 08             	mov    0x8(%eax),%eax
  80201b:	83 ec 04             	sub    $0x4,%esp
  80201e:	52                   	push   %edx
  80201f:	50                   	push   %eax
  802020:	68 41 3b 80 00       	push   $0x803b41
  802025:	e8 1a e5 ff ff       	call   800544 <cprintf>
  80202a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80202d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802030:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802033:	a1 48 40 80 00       	mov    0x804048,%eax
  802038:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203f:	74 07                	je     802048 <print_mem_block_lists+0x155>
  802041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802044:	8b 00                	mov    (%eax),%eax
  802046:	eb 05                	jmp    80204d <print_mem_block_lists+0x15a>
  802048:	b8 00 00 00 00       	mov    $0x0,%eax
  80204d:	a3 48 40 80 00       	mov    %eax,0x804048
  802052:	a1 48 40 80 00       	mov    0x804048,%eax
  802057:	85 c0                	test   %eax,%eax
  802059:	75 8a                	jne    801fe5 <print_mem_block_lists+0xf2>
  80205b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80205f:	75 84                	jne    801fe5 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802061:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802065:	75 10                	jne    802077 <print_mem_block_lists+0x184>
  802067:	83 ec 0c             	sub    $0xc,%esp
  80206a:	68 8c 3b 80 00       	push   $0x803b8c
  80206f:	e8 d0 e4 ff ff       	call   800544 <cprintf>
  802074:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802077:	83 ec 0c             	sub    $0xc,%esp
  80207a:	68 00 3b 80 00       	push   $0x803b00
  80207f:	e8 c0 e4 ff ff       	call   800544 <cprintf>
  802084:	83 c4 10             	add    $0x10,%esp

}
  802087:	90                   	nop
  802088:	c9                   	leave  
  802089:	c3                   	ret    

0080208a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80208a:	55                   	push   %ebp
  80208b:	89 e5                	mov    %esp,%ebp
  80208d:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802090:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802097:	00 00 00 
  80209a:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020a1:	00 00 00 
  8020a4:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020ab:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8020ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020b5:	e9 9e 00 00 00       	jmp    802158 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8020ba:	a1 50 40 80 00       	mov    0x804050,%eax
  8020bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c2:	c1 e2 04             	shl    $0x4,%edx
  8020c5:	01 d0                	add    %edx,%eax
  8020c7:	85 c0                	test   %eax,%eax
  8020c9:	75 14                	jne    8020df <initialize_MemBlocksList+0x55>
  8020cb:	83 ec 04             	sub    $0x4,%esp
  8020ce:	68 b4 3b 80 00       	push   $0x803bb4
  8020d3:	6a 3d                	push   $0x3d
  8020d5:	68 d7 3b 80 00       	push   $0x803bd7
  8020da:	e8 b1 e1 ff ff       	call   800290 <_panic>
  8020df:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e7:	c1 e2 04             	shl    $0x4,%edx
  8020ea:	01 d0                	add    %edx,%eax
  8020ec:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020f2:	89 10                	mov    %edx,(%eax)
  8020f4:	8b 00                	mov    (%eax),%eax
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	74 18                	je     802112 <initialize_MemBlocksList+0x88>
  8020fa:	a1 48 41 80 00       	mov    0x804148,%eax
  8020ff:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802105:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802108:	c1 e1 04             	shl    $0x4,%ecx
  80210b:	01 ca                	add    %ecx,%edx
  80210d:	89 50 04             	mov    %edx,0x4(%eax)
  802110:	eb 12                	jmp    802124 <initialize_MemBlocksList+0x9a>
  802112:	a1 50 40 80 00       	mov    0x804050,%eax
  802117:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211a:	c1 e2 04             	shl    $0x4,%edx
  80211d:	01 d0                	add    %edx,%eax
  80211f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802124:	a1 50 40 80 00       	mov    0x804050,%eax
  802129:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80212c:	c1 e2 04             	shl    $0x4,%edx
  80212f:	01 d0                	add    %edx,%eax
  802131:	a3 48 41 80 00       	mov    %eax,0x804148
  802136:	a1 50 40 80 00       	mov    0x804050,%eax
  80213b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80213e:	c1 e2 04             	shl    $0x4,%edx
  802141:	01 d0                	add    %edx,%eax
  802143:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80214a:	a1 54 41 80 00       	mov    0x804154,%eax
  80214f:	40                   	inc    %eax
  802150:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802155:	ff 45 f4             	incl   -0xc(%ebp)
  802158:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80215b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80215e:	0f 82 56 ff ff ff    	jb     8020ba <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802164:	90                   	nop
  802165:	c9                   	leave  
  802166:	c3                   	ret    

00802167 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802167:	55                   	push   %ebp
  802168:	89 e5                	mov    %esp,%ebp
  80216a:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  80216d:	8b 45 08             	mov    0x8(%ebp),%eax
  802170:	8b 00                	mov    (%eax),%eax
  802172:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802175:	eb 18                	jmp    80218f <find_block+0x28>

		if(tmp->sva == va){
  802177:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80217a:	8b 40 08             	mov    0x8(%eax),%eax
  80217d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802180:	75 05                	jne    802187 <find_block+0x20>
			return tmp ;
  802182:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802185:	eb 11                	jmp    802198 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802187:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80218a:	8b 00                	mov    (%eax),%eax
  80218c:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  80218f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802193:	75 e2                	jne    802177 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802195:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
  80219d:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8021a0:	a1 40 40 80 00       	mov    0x804040,%eax
  8021a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8021a8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8021b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021b4:	75 65                	jne    80221b <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8021b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ba:	75 14                	jne    8021d0 <insert_sorted_allocList+0x36>
  8021bc:	83 ec 04             	sub    $0x4,%esp
  8021bf:	68 b4 3b 80 00       	push   $0x803bb4
  8021c4:	6a 62                	push   $0x62
  8021c6:	68 d7 3b 80 00       	push   $0x803bd7
  8021cb:	e8 c0 e0 ff ff       	call   800290 <_panic>
  8021d0:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d9:	89 10                	mov    %edx,(%eax)
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	8b 00                	mov    (%eax),%eax
  8021e0:	85 c0                	test   %eax,%eax
  8021e2:	74 0d                	je     8021f1 <insert_sorted_allocList+0x57>
  8021e4:	a1 40 40 80 00       	mov    0x804040,%eax
  8021e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8021ec:	89 50 04             	mov    %edx,0x4(%eax)
  8021ef:	eb 08                	jmp    8021f9 <insert_sorted_allocList+0x5f>
  8021f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f4:	a3 44 40 80 00       	mov    %eax,0x804044
  8021f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8021fc:	a3 40 40 80 00       	mov    %eax,0x804040
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80220b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802210:	40                   	inc    %eax
  802211:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802216:	e9 14 01 00 00       	jmp    80232f <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80221b:	8b 45 08             	mov    0x8(%ebp),%eax
  80221e:	8b 50 08             	mov    0x8(%eax),%edx
  802221:	a1 44 40 80 00       	mov    0x804044,%eax
  802226:	8b 40 08             	mov    0x8(%eax),%eax
  802229:	39 c2                	cmp    %eax,%edx
  80222b:	76 65                	jbe    802292 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80222d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802231:	75 14                	jne    802247 <insert_sorted_allocList+0xad>
  802233:	83 ec 04             	sub    $0x4,%esp
  802236:	68 f0 3b 80 00       	push   $0x803bf0
  80223b:	6a 64                	push   $0x64
  80223d:	68 d7 3b 80 00       	push   $0x803bd7
  802242:	e8 49 e0 ff ff       	call   800290 <_panic>
  802247:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80224d:	8b 45 08             	mov    0x8(%ebp),%eax
  802250:	89 50 04             	mov    %edx,0x4(%eax)
  802253:	8b 45 08             	mov    0x8(%ebp),%eax
  802256:	8b 40 04             	mov    0x4(%eax),%eax
  802259:	85 c0                	test   %eax,%eax
  80225b:	74 0c                	je     802269 <insert_sorted_allocList+0xcf>
  80225d:	a1 44 40 80 00       	mov    0x804044,%eax
  802262:	8b 55 08             	mov    0x8(%ebp),%edx
  802265:	89 10                	mov    %edx,(%eax)
  802267:	eb 08                	jmp    802271 <insert_sorted_allocList+0xd7>
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	a3 40 40 80 00       	mov    %eax,0x804040
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	a3 44 40 80 00       	mov    %eax,0x804044
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802282:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802287:	40                   	inc    %eax
  802288:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80228d:	e9 9d 00 00 00       	jmp    80232f <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802292:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802299:	e9 85 00 00 00       	jmp    802323 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	8b 50 08             	mov    0x8(%eax),%edx
  8022a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a7:	8b 40 08             	mov    0x8(%eax),%eax
  8022aa:	39 c2                	cmp    %eax,%edx
  8022ac:	73 6a                	jae    802318 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8022ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022b2:	74 06                	je     8022ba <insert_sorted_allocList+0x120>
  8022b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022b8:	75 14                	jne    8022ce <insert_sorted_allocList+0x134>
  8022ba:	83 ec 04             	sub    $0x4,%esp
  8022bd:	68 14 3c 80 00       	push   $0x803c14
  8022c2:	6a 6b                	push   $0x6b
  8022c4:	68 d7 3b 80 00       	push   $0x803bd7
  8022c9:	e8 c2 df ff ff       	call   800290 <_panic>
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	8b 50 04             	mov    0x4(%eax),%edx
  8022d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d7:	89 50 04             	mov    %edx,0x4(%eax)
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022e0:	89 10                	mov    %edx,(%eax)
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	8b 40 04             	mov    0x4(%eax),%eax
  8022e8:	85 c0                	test   %eax,%eax
  8022ea:	74 0d                	je     8022f9 <insert_sorted_allocList+0x15f>
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	8b 40 04             	mov    0x4(%eax),%eax
  8022f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f5:	89 10                	mov    %edx,(%eax)
  8022f7:	eb 08                	jmp    802301 <insert_sorted_allocList+0x167>
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	a3 40 40 80 00       	mov    %eax,0x804040
  802301:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802304:	8b 55 08             	mov    0x8(%ebp),%edx
  802307:	89 50 04             	mov    %edx,0x4(%eax)
  80230a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80230f:	40                   	inc    %eax
  802310:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  802315:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802316:	eb 17                	jmp    80232f <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802318:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80231b:	8b 00                	mov    (%eax),%eax
  80231d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802320:	ff 45 f0             	incl   -0x10(%ebp)
  802323:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802326:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802329:	0f 8c 6f ff ff ff    	jl     80229e <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80232f:	90                   	nop
  802330:	c9                   	leave  
  802331:	c3                   	ret    

00802332 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802332:	55                   	push   %ebp
  802333:	89 e5                	mov    %esp,%ebp
  802335:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802338:	a1 38 41 80 00       	mov    0x804138,%eax
  80233d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802340:	e9 7c 01 00 00       	jmp    8024c1 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 40 0c             	mov    0xc(%eax),%eax
  80234b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80234e:	0f 86 cf 00 00 00    	jbe    802423 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802354:	a1 48 41 80 00       	mov    0x804148,%eax
  802359:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  80235c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80235f:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802362:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802365:	8b 55 08             	mov    0x8(%ebp),%edx
  802368:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	8b 50 08             	mov    0x8(%eax),%edx
  802371:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802374:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802377:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237a:	8b 40 0c             	mov    0xc(%eax),%eax
  80237d:	2b 45 08             	sub    0x8(%ebp),%eax
  802380:	89 c2                	mov    %eax,%edx
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802388:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238b:	8b 50 08             	mov    0x8(%eax),%edx
  80238e:	8b 45 08             	mov    0x8(%ebp),%eax
  802391:	01 c2                	add    %eax,%edx
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802399:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80239d:	75 17                	jne    8023b6 <alloc_block_FF+0x84>
  80239f:	83 ec 04             	sub    $0x4,%esp
  8023a2:	68 49 3c 80 00       	push   $0x803c49
  8023a7:	68 83 00 00 00       	push   $0x83
  8023ac:	68 d7 3b 80 00       	push   $0x803bd7
  8023b1:	e8 da de ff ff       	call   800290 <_panic>
  8023b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b9:	8b 00                	mov    (%eax),%eax
  8023bb:	85 c0                	test   %eax,%eax
  8023bd:	74 10                	je     8023cf <alloc_block_FF+0x9d>
  8023bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c2:	8b 00                	mov    (%eax),%eax
  8023c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023c7:	8b 52 04             	mov    0x4(%edx),%edx
  8023ca:	89 50 04             	mov    %edx,0x4(%eax)
  8023cd:	eb 0b                	jmp    8023da <alloc_block_FF+0xa8>
  8023cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d2:	8b 40 04             	mov    0x4(%eax),%eax
  8023d5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023dd:	8b 40 04             	mov    0x4(%eax),%eax
  8023e0:	85 c0                	test   %eax,%eax
  8023e2:	74 0f                	je     8023f3 <alloc_block_FF+0xc1>
  8023e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e7:	8b 40 04             	mov    0x4(%eax),%eax
  8023ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023ed:	8b 12                	mov    (%edx),%edx
  8023ef:	89 10                	mov    %edx,(%eax)
  8023f1:	eb 0a                	jmp    8023fd <alloc_block_FF+0xcb>
  8023f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f6:	8b 00                	mov    (%eax),%eax
  8023f8:	a3 48 41 80 00       	mov    %eax,0x804148
  8023fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802400:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802406:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802409:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802410:	a1 54 41 80 00       	mov    0x804154,%eax
  802415:	48                   	dec    %eax
  802416:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  80241b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241e:	e9 ad 00 00 00       	jmp    8024d0 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 40 0c             	mov    0xc(%eax),%eax
  802429:	3b 45 08             	cmp    0x8(%ebp),%eax
  80242c:	0f 85 87 00 00 00    	jne    8024b9 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802432:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802436:	75 17                	jne    80244f <alloc_block_FF+0x11d>
  802438:	83 ec 04             	sub    $0x4,%esp
  80243b:	68 49 3c 80 00       	push   $0x803c49
  802440:	68 87 00 00 00       	push   $0x87
  802445:	68 d7 3b 80 00       	push   $0x803bd7
  80244a:	e8 41 de ff ff       	call   800290 <_panic>
  80244f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802452:	8b 00                	mov    (%eax),%eax
  802454:	85 c0                	test   %eax,%eax
  802456:	74 10                	je     802468 <alloc_block_FF+0x136>
  802458:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245b:	8b 00                	mov    (%eax),%eax
  80245d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802460:	8b 52 04             	mov    0x4(%edx),%edx
  802463:	89 50 04             	mov    %edx,0x4(%eax)
  802466:	eb 0b                	jmp    802473 <alloc_block_FF+0x141>
  802468:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246b:	8b 40 04             	mov    0x4(%eax),%eax
  80246e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802473:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802476:	8b 40 04             	mov    0x4(%eax),%eax
  802479:	85 c0                	test   %eax,%eax
  80247b:	74 0f                	je     80248c <alloc_block_FF+0x15a>
  80247d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802480:	8b 40 04             	mov    0x4(%eax),%eax
  802483:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802486:	8b 12                	mov    (%edx),%edx
  802488:	89 10                	mov    %edx,(%eax)
  80248a:	eb 0a                	jmp    802496 <alloc_block_FF+0x164>
  80248c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248f:	8b 00                	mov    (%eax),%eax
  802491:	a3 38 41 80 00       	mov    %eax,0x804138
  802496:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802499:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a9:	a1 44 41 80 00       	mov    0x804144,%eax
  8024ae:	48                   	dec    %eax
  8024af:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8024b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b7:	eb 17                	jmp    8024d0 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 00                	mov    (%eax),%eax
  8024be:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8024c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024c5:	0f 85 7a fe ff ff    	jne    802345 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8024cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024d0:	c9                   	leave  
  8024d1:	c3                   	ret    

008024d2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024d2:	55                   	push   %ebp
  8024d3:	89 e5                	mov    %esp,%ebp
  8024d5:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8024d8:	a1 38 41 80 00       	mov    0x804138,%eax
  8024dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8024e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8024e7:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8024ee:	a1 38 41 80 00       	mov    0x804138,%eax
  8024f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024f6:	e9 d0 00 00 00       	jmp    8025cb <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8024fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802501:	3b 45 08             	cmp    0x8(%ebp),%eax
  802504:	0f 82 b8 00 00 00    	jb     8025c2 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  80250a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250d:	8b 40 0c             	mov    0xc(%eax),%eax
  802510:	2b 45 08             	sub    0x8(%ebp),%eax
  802513:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802516:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802519:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80251c:	0f 83 a1 00 00 00    	jae    8025c3 <alloc_block_BF+0xf1>
				differsize = differance ;
  802522:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802525:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802528:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80252e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802532:	0f 85 8b 00 00 00    	jne    8025c3 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802538:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80253c:	75 17                	jne    802555 <alloc_block_BF+0x83>
  80253e:	83 ec 04             	sub    $0x4,%esp
  802541:	68 49 3c 80 00       	push   $0x803c49
  802546:	68 a0 00 00 00       	push   $0xa0
  80254b:	68 d7 3b 80 00       	push   $0x803bd7
  802550:	e8 3b dd ff ff       	call   800290 <_panic>
  802555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802558:	8b 00                	mov    (%eax),%eax
  80255a:	85 c0                	test   %eax,%eax
  80255c:	74 10                	je     80256e <alloc_block_BF+0x9c>
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 00                	mov    (%eax),%eax
  802563:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802566:	8b 52 04             	mov    0x4(%edx),%edx
  802569:	89 50 04             	mov    %edx,0x4(%eax)
  80256c:	eb 0b                	jmp    802579 <alloc_block_BF+0xa7>
  80256e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802571:	8b 40 04             	mov    0x4(%eax),%eax
  802574:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	8b 40 04             	mov    0x4(%eax),%eax
  80257f:	85 c0                	test   %eax,%eax
  802581:	74 0f                	je     802592 <alloc_block_BF+0xc0>
  802583:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802586:	8b 40 04             	mov    0x4(%eax),%eax
  802589:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258c:	8b 12                	mov    (%edx),%edx
  80258e:	89 10                	mov    %edx,(%eax)
  802590:	eb 0a                	jmp    80259c <alloc_block_BF+0xca>
  802592:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802595:	8b 00                	mov    (%eax),%eax
  802597:	a3 38 41 80 00       	mov    %eax,0x804138
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025af:	a1 44 41 80 00       	mov    0x804144,%eax
  8025b4:	48                   	dec    %eax
  8025b5:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8025ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bd:	e9 0c 01 00 00       	jmp    8026ce <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8025c2:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8025c3:	a1 40 41 80 00       	mov    0x804140,%eax
  8025c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025cf:	74 07                	je     8025d8 <alloc_block_BF+0x106>
  8025d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d4:	8b 00                	mov    (%eax),%eax
  8025d6:	eb 05                	jmp    8025dd <alloc_block_BF+0x10b>
  8025d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8025dd:	a3 40 41 80 00       	mov    %eax,0x804140
  8025e2:	a1 40 41 80 00       	mov    0x804140,%eax
  8025e7:	85 c0                	test   %eax,%eax
  8025e9:	0f 85 0c ff ff ff    	jne    8024fb <alloc_block_BF+0x29>
  8025ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f3:	0f 85 02 ff ff ff    	jne    8024fb <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  8025f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025fd:	0f 84 c6 00 00 00    	je     8026c9 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802603:	a1 48 41 80 00       	mov    0x804148,%eax
  802608:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  80260b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80260e:	8b 55 08             	mov    0x8(%ebp),%edx
  802611:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802614:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802617:	8b 50 08             	mov    0x8(%eax),%edx
  80261a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80261d:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802623:	8b 40 0c             	mov    0xc(%eax),%eax
  802626:	2b 45 08             	sub    0x8(%ebp),%eax
  802629:	89 c2                	mov    %eax,%edx
  80262b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80262e:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802631:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802634:	8b 50 08             	mov    0x8(%eax),%edx
  802637:	8b 45 08             	mov    0x8(%ebp),%eax
  80263a:	01 c2                	add    %eax,%edx
  80263c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263f:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802642:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802646:	75 17                	jne    80265f <alloc_block_BF+0x18d>
  802648:	83 ec 04             	sub    $0x4,%esp
  80264b:	68 49 3c 80 00       	push   $0x803c49
  802650:	68 af 00 00 00       	push   $0xaf
  802655:	68 d7 3b 80 00       	push   $0x803bd7
  80265a:	e8 31 dc ff ff       	call   800290 <_panic>
  80265f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802662:	8b 00                	mov    (%eax),%eax
  802664:	85 c0                	test   %eax,%eax
  802666:	74 10                	je     802678 <alloc_block_BF+0x1a6>
  802668:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266b:	8b 00                	mov    (%eax),%eax
  80266d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802670:	8b 52 04             	mov    0x4(%edx),%edx
  802673:	89 50 04             	mov    %edx,0x4(%eax)
  802676:	eb 0b                	jmp    802683 <alloc_block_BF+0x1b1>
  802678:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80267b:	8b 40 04             	mov    0x4(%eax),%eax
  80267e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802683:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802686:	8b 40 04             	mov    0x4(%eax),%eax
  802689:	85 c0                	test   %eax,%eax
  80268b:	74 0f                	je     80269c <alloc_block_BF+0x1ca>
  80268d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802690:	8b 40 04             	mov    0x4(%eax),%eax
  802693:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802696:	8b 12                	mov    (%edx),%edx
  802698:	89 10                	mov    %edx,(%eax)
  80269a:	eb 0a                	jmp    8026a6 <alloc_block_BF+0x1d4>
  80269c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80269f:	8b 00                	mov    (%eax),%eax
  8026a1:	a3 48 41 80 00       	mov    %eax,0x804148
  8026a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026b9:	a1 54 41 80 00       	mov    0x804154,%eax
  8026be:	48                   	dec    %eax
  8026bf:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8026c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c7:	eb 05                	jmp    8026ce <alloc_block_BF+0x1fc>
	}

	return NULL;
  8026c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026ce:	c9                   	leave  
  8026cf:	c3                   	ret    

008026d0 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8026d0:	55                   	push   %ebp
  8026d1:	89 e5                	mov    %esp,%ebp
  8026d3:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8026d6:	a1 38 41 80 00       	mov    0x804138,%eax
  8026db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8026de:	e9 7c 01 00 00       	jmp    80285f <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8026e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026ec:	0f 86 cf 00 00 00    	jbe    8027c1 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8026f2:	a1 48 41 80 00       	mov    0x804148,%eax
  8026f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8026fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802700:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802703:	8b 55 08             	mov    0x8(%ebp),%edx
  802706:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 50 08             	mov    0x8(%eax),%edx
  80270f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802712:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802718:	8b 40 0c             	mov    0xc(%eax),%eax
  80271b:	2b 45 08             	sub    0x8(%ebp),%eax
  80271e:	89 c2                	mov    %eax,%edx
  802720:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802723:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802726:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802729:	8b 50 08             	mov    0x8(%eax),%edx
  80272c:	8b 45 08             	mov    0x8(%ebp),%eax
  80272f:	01 c2                	add    %eax,%edx
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802737:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80273b:	75 17                	jne    802754 <alloc_block_NF+0x84>
  80273d:	83 ec 04             	sub    $0x4,%esp
  802740:	68 49 3c 80 00       	push   $0x803c49
  802745:	68 c4 00 00 00       	push   $0xc4
  80274a:	68 d7 3b 80 00       	push   $0x803bd7
  80274f:	e8 3c db ff ff       	call   800290 <_panic>
  802754:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802757:	8b 00                	mov    (%eax),%eax
  802759:	85 c0                	test   %eax,%eax
  80275b:	74 10                	je     80276d <alloc_block_NF+0x9d>
  80275d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802760:	8b 00                	mov    (%eax),%eax
  802762:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802765:	8b 52 04             	mov    0x4(%edx),%edx
  802768:	89 50 04             	mov    %edx,0x4(%eax)
  80276b:	eb 0b                	jmp    802778 <alloc_block_NF+0xa8>
  80276d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802770:	8b 40 04             	mov    0x4(%eax),%eax
  802773:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802778:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277b:	8b 40 04             	mov    0x4(%eax),%eax
  80277e:	85 c0                	test   %eax,%eax
  802780:	74 0f                	je     802791 <alloc_block_NF+0xc1>
  802782:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802785:	8b 40 04             	mov    0x4(%eax),%eax
  802788:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80278b:	8b 12                	mov    (%edx),%edx
  80278d:	89 10                	mov    %edx,(%eax)
  80278f:	eb 0a                	jmp    80279b <alloc_block_NF+0xcb>
  802791:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802794:	8b 00                	mov    (%eax),%eax
  802796:	a3 48 41 80 00       	mov    %eax,0x804148
  80279b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027ae:	a1 54 41 80 00       	mov    0x804154,%eax
  8027b3:	48                   	dec    %eax
  8027b4:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8027b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027bc:	e9 ad 00 00 00       	jmp    80286e <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ca:	0f 85 87 00 00 00    	jne    802857 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8027d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027d4:	75 17                	jne    8027ed <alloc_block_NF+0x11d>
  8027d6:	83 ec 04             	sub    $0x4,%esp
  8027d9:	68 49 3c 80 00       	push   $0x803c49
  8027de:	68 c8 00 00 00       	push   $0xc8
  8027e3:	68 d7 3b 80 00       	push   $0x803bd7
  8027e8:	e8 a3 da ff ff       	call   800290 <_panic>
  8027ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f0:	8b 00                	mov    (%eax),%eax
  8027f2:	85 c0                	test   %eax,%eax
  8027f4:	74 10                	je     802806 <alloc_block_NF+0x136>
  8027f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f9:	8b 00                	mov    (%eax),%eax
  8027fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027fe:	8b 52 04             	mov    0x4(%edx),%edx
  802801:	89 50 04             	mov    %edx,0x4(%eax)
  802804:	eb 0b                	jmp    802811 <alloc_block_NF+0x141>
  802806:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802809:	8b 40 04             	mov    0x4(%eax),%eax
  80280c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802811:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802814:	8b 40 04             	mov    0x4(%eax),%eax
  802817:	85 c0                	test   %eax,%eax
  802819:	74 0f                	je     80282a <alloc_block_NF+0x15a>
  80281b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281e:	8b 40 04             	mov    0x4(%eax),%eax
  802821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802824:	8b 12                	mov    (%edx),%edx
  802826:	89 10                	mov    %edx,(%eax)
  802828:	eb 0a                	jmp    802834 <alloc_block_NF+0x164>
  80282a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282d:	8b 00                	mov    (%eax),%eax
  80282f:	a3 38 41 80 00       	mov    %eax,0x804138
  802834:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802837:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80283d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802840:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802847:	a1 44 41 80 00       	mov    0x804144,%eax
  80284c:	48                   	dec    %eax
  80284d:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802852:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802855:	eb 17                	jmp    80286e <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 00                	mov    (%eax),%eax
  80285c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  80285f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802863:	0f 85 7a fe ff ff    	jne    8026e3 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802869:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80286e:	c9                   	leave  
  80286f:	c3                   	ret    

00802870 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802870:	55                   	push   %ebp
  802871:	89 e5                	mov    %esp,%ebp
  802873:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802876:	a1 38 41 80 00       	mov    0x804138,%eax
  80287b:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  80287e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802883:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802886:	a1 44 41 80 00       	mov    0x804144,%eax
  80288b:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  80288e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802892:	75 68                	jne    8028fc <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802894:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802898:	75 17                	jne    8028b1 <insert_sorted_with_merge_freeList+0x41>
  80289a:	83 ec 04             	sub    $0x4,%esp
  80289d:	68 b4 3b 80 00       	push   $0x803bb4
  8028a2:	68 da 00 00 00       	push   $0xda
  8028a7:	68 d7 3b 80 00       	push   $0x803bd7
  8028ac:	e8 df d9 ff ff       	call   800290 <_panic>
  8028b1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	89 10                	mov    %edx,(%eax)
  8028bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8028bf:	8b 00                	mov    (%eax),%eax
  8028c1:	85 c0                	test   %eax,%eax
  8028c3:	74 0d                	je     8028d2 <insert_sorted_with_merge_freeList+0x62>
  8028c5:	a1 38 41 80 00       	mov    0x804138,%eax
  8028ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8028cd:	89 50 04             	mov    %edx,0x4(%eax)
  8028d0:	eb 08                	jmp    8028da <insert_sorted_with_merge_freeList+0x6a>
  8028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028da:	8b 45 08             	mov    0x8(%ebp),%eax
  8028dd:	a3 38 41 80 00       	mov    %eax,0x804138
  8028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ec:	a1 44 41 80 00       	mov    0x804144,%eax
  8028f1:	40                   	inc    %eax
  8028f2:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  8028f7:	e9 49 07 00 00       	jmp    803045 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  8028fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ff:	8b 50 08             	mov    0x8(%eax),%edx
  802902:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802905:	8b 40 0c             	mov    0xc(%eax),%eax
  802908:	01 c2                	add    %eax,%edx
  80290a:	8b 45 08             	mov    0x8(%ebp),%eax
  80290d:	8b 40 08             	mov    0x8(%eax),%eax
  802910:	39 c2                	cmp    %eax,%edx
  802912:	73 77                	jae    80298b <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802914:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802917:	8b 00                	mov    (%eax),%eax
  802919:	85 c0                	test   %eax,%eax
  80291b:	75 6e                	jne    80298b <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  80291d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802921:	74 68                	je     80298b <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802923:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802927:	75 17                	jne    802940 <insert_sorted_with_merge_freeList+0xd0>
  802929:	83 ec 04             	sub    $0x4,%esp
  80292c:	68 f0 3b 80 00       	push   $0x803bf0
  802931:	68 e0 00 00 00       	push   $0xe0
  802936:	68 d7 3b 80 00       	push   $0x803bd7
  80293b:	e8 50 d9 ff ff       	call   800290 <_panic>
  802940:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802946:	8b 45 08             	mov    0x8(%ebp),%eax
  802949:	89 50 04             	mov    %edx,0x4(%eax)
  80294c:	8b 45 08             	mov    0x8(%ebp),%eax
  80294f:	8b 40 04             	mov    0x4(%eax),%eax
  802952:	85 c0                	test   %eax,%eax
  802954:	74 0c                	je     802962 <insert_sorted_with_merge_freeList+0xf2>
  802956:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80295b:	8b 55 08             	mov    0x8(%ebp),%edx
  80295e:	89 10                	mov    %edx,(%eax)
  802960:	eb 08                	jmp    80296a <insert_sorted_with_merge_freeList+0xfa>
  802962:	8b 45 08             	mov    0x8(%ebp),%eax
  802965:	a3 38 41 80 00       	mov    %eax,0x804138
  80296a:	8b 45 08             	mov    0x8(%ebp),%eax
  80296d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80297b:	a1 44 41 80 00       	mov    0x804144,%eax
  802980:	40                   	inc    %eax
  802981:	a3 44 41 80 00       	mov    %eax,0x804144
  802986:	e9 ba 06 00 00       	jmp    803045 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  80298b:	8b 45 08             	mov    0x8(%ebp),%eax
  80298e:	8b 50 0c             	mov    0xc(%eax),%edx
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
  802994:	8b 40 08             	mov    0x8(%eax),%eax
  802997:	01 c2                	add    %eax,%edx
  802999:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299c:	8b 40 08             	mov    0x8(%eax),%eax
  80299f:	39 c2                	cmp    %eax,%edx
  8029a1:	73 78                	jae    802a1b <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8029a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a6:	8b 40 04             	mov    0x4(%eax),%eax
  8029a9:	85 c0                	test   %eax,%eax
  8029ab:	75 6e                	jne    802a1b <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8029ad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029b1:	74 68                	je     802a1b <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8029b3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029b7:	75 17                	jne    8029d0 <insert_sorted_with_merge_freeList+0x160>
  8029b9:	83 ec 04             	sub    $0x4,%esp
  8029bc:	68 b4 3b 80 00       	push   $0x803bb4
  8029c1:	68 e6 00 00 00       	push   $0xe6
  8029c6:	68 d7 3b 80 00       	push   $0x803bd7
  8029cb:	e8 c0 d8 ff ff       	call   800290 <_panic>
  8029d0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	89 10                	mov    %edx,(%eax)
  8029db:	8b 45 08             	mov    0x8(%ebp),%eax
  8029de:	8b 00                	mov    (%eax),%eax
  8029e0:	85 c0                	test   %eax,%eax
  8029e2:	74 0d                	je     8029f1 <insert_sorted_with_merge_freeList+0x181>
  8029e4:	a1 38 41 80 00       	mov    0x804138,%eax
  8029e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ec:	89 50 04             	mov    %edx,0x4(%eax)
  8029ef:	eb 08                	jmp    8029f9 <insert_sorted_with_merge_freeList+0x189>
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fc:	a3 38 41 80 00       	mov    %eax,0x804138
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a0b:	a1 44 41 80 00       	mov    0x804144,%eax
  802a10:	40                   	inc    %eax
  802a11:	a3 44 41 80 00       	mov    %eax,0x804144
  802a16:	e9 2a 06 00 00       	jmp    803045 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802a1b:	a1 38 41 80 00       	mov    0x804138,%eax
  802a20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a23:	e9 ed 05 00 00       	jmp    803015 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802a28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2b:	8b 00                	mov    (%eax),%eax
  802a2d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802a30:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a34:	0f 84 a7 00 00 00    	je     802ae1 <insert_sorted_with_merge_freeList+0x271>
  802a3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3d:	8b 50 0c             	mov    0xc(%eax),%edx
  802a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a43:	8b 40 08             	mov    0x8(%eax),%eax
  802a46:	01 c2                	add    %eax,%edx
  802a48:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4b:	8b 40 08             	mov    0x8(%eax),%eax
  802a4e:	39 c2                	cmp    %eax,%edx
  802a50:	0f 83 8b 00 00 00    	jae    802ae1 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
  802a59:	8b 50 0c             	mov    0xc(%eax),%edx
  802a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5f:	8b 40 08             	mov    0x8(%eax),%eax
  802a62:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802a64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a67:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802a6a:	39 c2                	cmp    %eax,%edx
  802a6c:	73 73                	jae    802ae1 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802a6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a72:	74 06                	je     802a7a <insert_sorted_with_merge_freeList+0x20a>
  802a74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a78:	75 17                	jne    802a91 <insert_sorted_with_merge_freeList+0x221>
  802a7a:	83 ec 04             	sub    $0x4,%esp
  802a7d:	68 68 3c 80 00       	push   $0x803c68
  802a82:	68 f0 00 00 00       	push   $0xf0
  802a87:	68 d7 3b 80 00       	push   $0x803bd7
  802a8c:	e8 ff d7 ff ff       	call   800290 <_panic>
  802a91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a94:	8b 10                	mov    (%eax),%edx
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	89 10                	mov    %edx,(%eax)
  802a9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9e:	8b 00                	mov    (%eax),%eax
  802aa0:	85 c0                	test   %eax,%eax
  802aa2:	74 0b                	je     802aaf <insert_sorted_with_merge_freeList+0x23f>
  802aa4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa7:	8b 00                	mov    (%eax),%eax
  802aa9:	8b 55 08             	mov    0x8(%ebp),%edx
  802aac:	89 50 04             	mov    %edx,0x4(%eax)
  802aaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab2:	8b 55 08             	mov    0x8(%ebp),%edx
  802ab5:	89 10                	mov    %edx,(%eax)
  802ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802abd:	89 50 04             	mov    %edx,0x4(%eax)
  802ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac3:	8b 00                	mov    (%eax),%eax
  802ac5:	85 c0                	test   %eax,%eax
  802ac7:	75 08                	jne    802ad1 <insert_sorted_with_merge_freeList+0x261>
  802ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  802acc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ad1:	a1 44 41 80 00       	mov    0x804144,%eax
  802ad6:	40                   	inc    %eax
  802ad7:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802adc:	e9 64 05 00 00       	jmp    803045 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802ae1:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ae6:	8b 50 0c             	mov    0xc(%eax),%edx
  802ae9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802aee:	8b 40 08             	mov    0x8(%eax),%eax
  802af1:	01 c2                	add    %eax,%edx
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	8b 40 08             	mov    0x8(%eax),%eax
  802af9:	39 c2                	cmp    %eax,%edx
  802afb:	0f 85 b1 00 00 00    	jne    802bb2 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802b01:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b06:	85 c0                	test   %eax,%eax
  802b08:	0f 84 a4 00 00 00    	je     802bb2 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802b0e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b13:	8b 00                	mov    (%eax),%eax
  802b15:	85 c0                	test   %eax,%eax
  802b17:	0f 85 95 00 00 00    	jne    802bb2 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802b1d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b22:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b28:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b2e:	8b 52 0c             	mov    0xc(%edx),%edx
  802b31:	01 ca                	add    %ecx,%edx
  802b33:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802b36:	8b 45 08             	mov    0x8(%ebp),%eax
  802b39:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802b4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b4e:	75 17                	jne    802b67 <insert_sorted_with_merge_freeList+0x2f7>
  802b50:	83 ec 04             	sub    $0x4,%esp
  802b53:	68 b4 3b 80 00       	push   $0x803bb4
  802b58:	68 ff 00 00 00       	push   $0xff
  802b5d:	68 d7 3b 80 00       	push   $0x803bd7
  802b62:	e8 29 d7 ff ff       	call   800290 <_panic>
  802b67:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b70:	89 10                	mov    %edx,(%eax)
  802b72:	8b 45 08             	mov    0x8(%ebp),%eax
  802b75:	8b 00                	mov    (%eax),%eax
  802b77:	85 c0                	test   %eax,%eax
  802b79:	74 0d                	je     802b88 <insert_sorted_with_merge_freeList+0x318>
  802b7b:	a1 48 41 80 00       	mov    0x804148,%eax
  802b80:	8b 55 08             	mov    0x8(%ebp),%edx
  802b83:	89 50 04             	mov    %edx,0x4(%eax)
  802b86:	eb 08                	jmp    802b90 <insert_sorted_with_merge_freeList+0x320>
  802b88:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	a3 48 41 80 00       	mov    %eax,0x804148
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ba2:	a1 54 41 80 00       	mov    0x804154,%eax
  802ba7:	40                   	inc    %eax
  802ba8:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802bad:	e9 93 04 00 00       	jmp    803045 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802bb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb5:	8b 50 08             	mov    0x8(%eax),%edx
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802bbe:	01 c2                	add    %eax,%edx
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	8b 40 08             	mov    0x8(%eax),%eax
  802bc6:	39 c2                	cmp    %eax,%edx
  802bc8:	0f 85 ae 00 00 00    	jne    802c7c <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802bce:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd1:	8b 50 0c             	mov    0xc(%eax),%edx
  802bd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd7:	8b 40 08             	mov    0x8(%eax),%eax
  802bda:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802bdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdf:	8b 00                	mov    (%eax),%eax
  802be1:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802be4:	39 c2                	cmp    %eax,%edx
  802be6:	0f 84 90 00 00 00    	je     802c7c <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802bec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bef:	8b 50 0c             	mov    0xc(%eax),%edx
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bf8:	01 c2                	add    %eax,%edx
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c18:	75 17                	jne    802c31 <insert_sorted_with_merge_freeList+0x3c1>
  802c1a:	83 ec 04             	sub    $0x4,%esp
  802c1d:	68 b4 3b 80 00       	push   $0x803bb4
  802c22:	68 0b 01 00 00       	push   $0x10b
  802c27:	68 d7 3b 80 00       	push   $0x803bd7
  802c2c:	e8 5f d6 ff ff       	call   800290 <_panic>
  802c31:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c37:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3a:	89 10                	mov    %edx,(%eax)
  802c3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3f:	8b 00                	mov    (%eax),%eax
  802c41:	85 c0                	test   %eax,%eax
  802c43:	74 0d                	je     802c52 <insert_sorted_with_merge_freeList+0x3e2>
  802c45:	a1 48 41 80 00       	mov    0x804148,%eax
  802c4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c4d:	89 50 04             	mov    %edx,0x4(%eax)
  802c50:	eb 08                	jmp    802c5a <insert_sorted_with_merge_freeList+0x3ea>
  802c52:	8b 45 08             	mov    0x8(%ebp),%eax
  802c55:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5d:	a3 48 41 80 00       	mov    %eax,0x804148
  802c62:	8b 45 08             	mov    0x8(%ebp),%eax
  802c65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c6c:	a1 54 41 80 00       	mov    0x804154,%eax
  802c71:	40                   	inc    %eax
  802c72:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802c77:	e9 c9 03 00 00       	jmp    803045 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7f:	8b 50 0c             	mov    0xc(%eax),%edx
  802c82:	8b 45 08             	mov    0x8(%ebp),%eax
  802c85:	8b 40 08             	mov    0x8(%eax),%eax
  802c88:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802c8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8d:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802c90:	39 c2                	cmp    %eax,%edx
  802c92:	0f 85 bb 00 00 00    	jne    802d53 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802c98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c9c:	0f 84 b1 00 00 00    	je     802d53 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca5:	8b 40 04             	mov    0x4(%eax),%eax
  802ca8:	85 c0                	test   %eax,%eax
  802caa:	0f 85 a3 00 00 00    	jne    802d53 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802cb0:	a1 38 41 80 00       	mov    0x804138,%eax
  802cb5:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb8:	8b 52 08             	mov    0x8(%edx),%edx
  802cbb:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802cbe:	a1 38 41 80 00       	mov    0x804138,%eax
  802cc3:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cc9:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802ccc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ccf:	8b 52 0c             	mov    0xc(%edx),%edx
  802cd2:	01 ca                	add    %ecx,%edx
  802cd4:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802cd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cda:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802ceb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cef:	75 17                	jne    802d08 <insert_sorted_with_merge_freeList+0x498>
  802cf1:	83 ec 04             	sub    $0x4,%esp
  802cf4:	68 b4 3b 80 00       	push   $0x803bb4
  802cf9:	68 17 01 00 00       	push   $0x117
  802cfe:	68 d7 3b 80 00       	push   $0x803bd7
  802d03:	e8 88 d5 ff ff       	call   800290 <_panic>
  802d08:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d11:	89 10                	mov    %edx,(%eax)
  802d13:	8b 45 08             	mov    0x8(%ebp),%eax
  802d16:	8b 00                	mov    (%eax),%eax
  802d18:	85 c0                	test   %eax,%eax
  802d1a:	74 0d                	je     802d29 <insert_sorted_with_merge_freeList+0x4b9>
  802d1c:	a1 48 41 80 00       	mov    0x804148,%eax
  802d21:	8b 55 08             	mov    0x8(%ebp),%edx
  802d24:	89 50 04             	mov    %edx,0x4(%eax)
  802d27:	eb 08                	jmp    802d31 <insert_sorted_with_merge_freeList+0x4c1>
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d31:	8b 45 08             	mov    0x8(%ebp),%eax
  802d34:	a3 48 41 80 00       	mov    %eax,0x804148
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d43:	a1 54 41 80 00       	mov    0x804154,%eax
  802d48:	40                   	inc    %eax
  802d49:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d4e:	e9 f2 02 00 00       	jmp    803045 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802d53:	8b 45 08             	mov    0x8(%ebp),%eax
  802d56:	8b 50 08             	mov    0x8(%eax),%edx
  802d59:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802d5f:	01 c2                	add    %eax,%edx
  802d61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d64:	8b 40 08             	mov    0x8(%eax),%eax
  802d67:	39 c2                	cmp    %eax,%edx
  802d69:	0f 85 be 00 00 00    	jne    802e2d <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802d6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d72:	8b 40 04             	mov    0x4(%eax),%eax
  802d75:	8b 50 08             	mov    0x8(%eax),%edx
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	8b 40 04             	mov    0x4(%eax),%eax
  802d7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d81:	01 c2                	add    %eax,%edx
  802d83:	8b 45 08             	mov    0x8(%ebp),%eax
  802d86:	8b 40 08             	mov    0x8(%eax),%eax
  802d89:	39 c2                	cmp    %eax,%edx
  802d8b:	0f 84 9c 00 00 00    	je     802e2d <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802d91:	8b 45 08             	mov    0x8(%ebp),%eax
  802d94:	8b 50 08             	mov    0x8(%eax),%edx
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802d9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da0:	8b 50 0c             	mov    0xc(%eax),%edx
  802da3:	8b 45 08             	mov    0x8(%ebp),%eax
  802da6:	8b 40 0c             	mov    0xc(%eax),%eax
  802da9:	01 c2                	add    %eax,%edx
  802dab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dae:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802dc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc9:	75 17                	jne    802de2 <insert_sorted_with_merge_freeList+0x572>
  802dcb:	83 ec 04             	sub    $0x4,%esp
  802dce:	68 b4 3b 80 00       	push   $0x803bb4
  802dd3:	68 26 01 00 00       	push   $0x126
  802dd8:	68 d7 3b 80 00       	push   $0x803bd7
  802ddd:	e8 ae d4 ff ff       	call   800290 <_panic>
  802de2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	89 10                	mov    %edx,(%eax)
  802ded:	8b 45 08             	mov    0x8(%ebp),%eax
  802df0:	8b 00                	mov    (%eax),%eax
  802df2:	85 c0                	test   %eax,%eax
  802df4:	74 0d                	je     802e03 <insert_sorted_with_merge_freeList+0x593>
  802df6:	a1 48 41 80 00       	mov    0x804148,%eax
  802dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfe:	89 50 04             	mov    %edx,0x4(%eax)
  802e01:	eb 08                	jmp    802e0b <insert_sorted_with_merge_freeList+0x59b>
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0e:	a3 48 41 80 00       	mov    %eax,0x804148
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1d:	a1 54 41 80 00       	mov    0x804154,%eax
  802e22:	40                   	inc    %eax
  802e23:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802e28:	e9 18 02 00 00       	jmp    803045 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e30:	8b 50 0c             	mov    0xc(%eax),%edx
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 40 08             	mov    0x8(%eax),%eax
  802e39:	01 c2                	add    %eax,%edx
  802e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3e:	8b 40 08             	mov    0x8(%eax),%eax
  802e41:	39 c2                	cmp    %eax,%edx
  802e43:	0f 85 c4 01 00 00    	jne    80300d <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802e49:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4c:	8b 50 0c             	mov    0xc(%eax),%edx
  802e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e52:	8b 40 08             	mov    0x8(%eax),%eax
  802e55:	01 c2                	add    %eax,%edx
  802e57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5a:	8b 00                	mov    (%eax),%eax
  802e5c:	8b 40 08             	mov    0x8(%eax),%eax
  802e5f:	39 c2                	cmp    %eax,%edx
  802e61:	0f 85 a6 01 00 00    	jne    80300d <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802e67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e6b:	0f 84 9c 01 00 00    	je     80300d <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	8b 50 0c             	mov    0xc(%eax),%edx
  802e77:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802e7d:	01 c2                	add    %eax,%edx
  802e7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e82:	8b 00                	mov    (%eax),%eax
  802e84:	8b 40 0c             	mov    0xc(%eax),%eax
  802e87:	01 c2                	add    %eax,%edx
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802ea3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea7:	75 17                	jne    802ec0 <insert_sorted_with_merge_freeList+0x650>
  802ea9:	83 ec 04             	sub    $0x4,%esp
  802eac:	68 b4 3b 80 00       	push   $0x803bb4
  802eb1:	68 32 01 00 00       	push   $0x132
  802eb6:	68 d7 3b 80 00       	push   $0x803bd7
  802ebb:	e8 d0 d3 ff ff       	call   800290 <_panic>
  802ec0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ec6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec9:	89 10                	mov    %edx,(%eax)
  802ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ece:	8b 00                	mov    (%eax),%eax
  802ed0:	85 c0                	test   %eax,%eax
  802ed2:	74 0d                	je     802ee1 <insert_sorted_with_merge_freeList+0x671>
  802ed4:	a1 48 41 80 00       	mov    0x804148,%eax
  802ed9:	8b 55 08             	mov    0x8(%ebp),%edx
  802edc:	89 50 04             	mov    %edx,0x4(%eax)
  802edf:	eb 08                	jmp    802ee9 <insert_sorted_with_merge_freeList+0x679>
  802ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ee9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eec:	a3 48 41 80 00       	mov    %eax,0x804148
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802efb:	a1 54 41 80 00       	mov    0x804154,%eax
  802f00:	40                   	inc    %eax
  802f01:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802f06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f09:	8b 00                	mov    (%eax),%eax
  802f0b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802f12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f15:	8b 00                	mov    (%eax),%eax
  802f17:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802f1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f21:	8b 00                	mov    (%eax),%eax
  802f23:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802f26:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f2a:	75 17                	jne    802f43 <insert_sorted_with_merge_freeList+0x6d3>
  802f2c:	83 ec 04             	sub    $0x4,%esp
  802f2f:	68 49 3c 80 00       	push   $0x803c49
  802f34:	68 36 01 00 00       	push   $0x136
  802f39:	68 d7 3b 80 00       	push   $0x803bd7
  802f3e:	e8 4d d3 ff ff       	call   800290 <_panic>
  802f43:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f46:	8b 00                	mov    (%eax),%eax
  802f48:	85 c0                	test   %eax,%eax
  802f4a:	74 10                	je     802f5c <insert_sorted_with_merge_freeList+0x6ec>
  802f4c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4f:	8b 00                	mov    (%eax),%eax
  802f51:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f54:	8b 52 04             	mov    0x4(%edx),%edx
  802f57:	89 50 04             	mov    %edx,0x4(%eax)
  802f5a:	eb 0b                	jmp    802f67 <insert_sorted_with_merge_freeList+0x6f7>
  802f5c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f5f:	8b 40 04             	mov    0x4(%eax),%eax
  802f62:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f67:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f6a:	8b 40 04             	mov    0x4(%eax),%eax
  802f6d:	85 c0                	test   %eax,%eax
  802f6f:	74 0f                	je     802f80 <insert_sorted_with_merge_freeList+0x710>
  802f71:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f74:	8b 40 04             	mov    0x4(%eax),%eax
  802f77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f7a:	8b 12                	mov    (%edx),%edx
  802f7c:	89 10                	mov    %edx,(%eax)
  802f7e:	eb 0a                	jmp    802f8a <insert_sorted_with_merge_freeList+0x71a>
  802f80:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f83:	8b 00                	mov    (%eax),%eax
  802f85:	a3 38 41 80 00       	mov    %eax,0x804138
  802f8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f8d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f96:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f9d:	a1 44 41 80 00       	mov    0x804144,%eax
  802fa2:	48                   	dec    %eax
  802fa3:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  802fa8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fac:	75 17                	jne    802fc5 <insert_sorted_with_merge_freeList+0x755>
  802fae:	83 ec 04             	sub    $0x4,%esp
  802fb1:	68 b4 3b 80 00       	push   $0x803bb4
  802fb6:	68 37 01 00 00       	push   $0x137
  802fbb:	68 d7 3b 80 00       	push   $0x803bd7
  802fc0:	e8 cb d2 ff ff       	call   800290 <_panic>
  802fc5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fce:	89 10                	mov    %edx,(%eax)
  802fd0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd3:	8b 00                	mov    (%eax),%eax
  802fd5:	85 c0                	test   %eax,%eax
  802fd7:	74 0d                	je     802fe6 <insert_sorted_with_merge_freeList+0x776>
  802fd9:	a1 48 41 80 00       	mov    0x804148,%eax
  802fde:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fe1:	89 50 04             	mov    %edx,0x4(%eax)
  802fe4:	eb 08                	jmp    802fee <insert_sorted_with_merge_freeList+0x77e>
  802fe6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff1:	a3 48 41 80 00       	mov    %eax,0x804148
  802ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803000:	a1 54 41 80 00       	mov    0x804154,%eax
  803005:	40                   	inc    %eax
  803006:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  80300b:	eb 38                	jmp    803045 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80300d:	a1 40 41 80 00       	mov    0x804140,%eax
  803012:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803015:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803019:	74 07                	je     803022 <insert_sorted_with_merge_freeList+0x7b2>
  80301b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301e:	8b 00                	mov    (%eax),%eax
  803020:	eb 05                	jmp    803027 <insert_sorted_with_merge_freeList+0x7b7>
  803022:	b8 00 00 00 00       	mov    $0x0,%eax
  803027:	a3 40 41 80 00       	mov    %eax,0x804140
  80302c:	a1 40 41 80 00       	mov    0x804140,%eax
  803031:	85 c0                	test   %eax,%eax
  803033:	0f 85 ef f9 ff ff    	jne    802a28 <insert_sorted_with_merge_freeList+0x1b8>
  803039:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303d:	0f 85 e5 f9 ff ff    	jne    802a28 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803043:	eb 00                	jmp    803045 <insert_sorted_with_merge_freeList+0x7d5>
  803045:	90                   	nop
  803046:	c9                   	leave  
  803047:	c3                   	ret    

00803048 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  803048:	55                   	push   %ebp
  803049:	89 e5                	mov    %esp,%ebp
  80304b:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80304e:	8b 55 08             	mov    0x8(%ebp),%edx
  803051:	89 d0                	mov    %edx,%eax
  803053:	c1 e0 02             	shl    $0x2,%eax
  803056:	01 d0                	add    %edx,%eax
  803058:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80305f:	01 d0                	add    %edx,%eax
  803061:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803068:	01 d0                	add    %edx,%eax
  80306a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803071:	01 d0                	add    %edx,%eax
  803073:	c1 e0 04             	shl    $0x4,%eax
  803076:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803079:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803080:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803083:	83 ec 0c             	sub    $0xc,%esp
  803086:	50                   	push   %eax
  803087:	e8 21 ec ff ff       	call   801cad <sys_get_virtual_time>
  80308c:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80308f:	eb 41                	jmp    8030d2 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803091:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803094:	83 ec 0c             	sub    $0xc,%esp
  803097:	50                   	push   %eax
  803098:	e8 10 ec ff ff       	call   801cad <sys_get_virtual_time>
  80309d:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030a0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030a6:	29 c2                	sub    %eax,%edx
  8030a8:	89 d0                	mov    %edx,%eax
  8030aa:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030ad:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b3:	89 d1                	mov    %edx,%ecx
  8030b5:	29 c1                	sub    %eax,%ecx
  8030b7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030ba:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030bd:	39 c2                	cmp    %eax,%edx
  8030bf:	0f 97 c0             	seta   %al
  8030c2:	0f b6 c0             	movzbl %al,%eax
  8030c5:	29 c1                	sub    %eax,%ecx
  8030c7:	89 c8                	mov    %ecx,%eax
  8030c9:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8030cc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8030d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d5:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030d8:	72 b7                	jb     803091 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8030da:	90                   	nop
  8030db:	c9                   	leave  
  8030dc:	c3                   	ret    

008030dd <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8030dd:	55                   	push   %ebp
  8030de:	89 e5                	mov    %esp,%ebp
  8030e0:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8030e3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8030ea:	eb 03                	jmp    8030ef <busy_wait+0x12>
  8030ec:	ff 45 fc             	incl   -0x4(%ebp)
  8030ef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8030f2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030f5:	72 f5                	jb     8030ec <busy_wait+0xf>
	return i;
  8030f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8030fa:	c9                   	leave  
  8030fb:	c3                   	ret    

008030fc <__udivdi3>:
  8030fc:	55                   	push   %ebp
  8030fd:	57                   	push   %edi
  8030fe:	56                   	push   %esi
  8030ff:	53                   	push   %ebx
  803100:	83 ec 1c             	sub    $0x1c,%esp
  803103:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803107:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80310b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80310f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803113:	89 ca                	mov    %ecx,%edx
  803115:	89 f8                	mov    %edi,%eax
  803117:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80311b:	85 f6                	test   %esi,%esi
  80311d:	75 2d                	jne    80314c <__udivdi3+0x50>
  80311f:	39 cf                	cmp    %ecx,%edi
  803121:	77 65                	ja     803188 <__udivdi3+0x8c>
  803123:	89 fd                	mov    %edi,%ebp
  803125:	85 ff                	test   %edi,%edi
  803127:	75 0b                	jne    803134 <__udivdi3+0x38>
  803129:	b8 01 00 00 00       	mov    $0x1,%eax
  80312e:	31 d2                	xor    %edx,%edx
  803130:	f7 f7                	div    %edi
  803132:	89 c5                	mov    %eax,%ebp
  803134:	31 d2                	xor    %edx,%edx
  803136:	89 c8                	mov    %ecx,%eax
  803138:	f7 f5                	div    %ebp
  80313a:	89 c1                	mov    %eax,%ecx
  80313c:	89 d8                	mov    %ebx,%eax
  80313e:	f7 f5                	div    %ebp
  803140:	89 cf                	mov    %ecx,%edi
  803142:	89 fa                	mov    %edi,%edx
  803144:	83 c4 1c             	add    $0x1c,%esp
  803147:	5b                   	pop    %ebx
  803148:	5e                   	pop    %esi
  803149:	5f                   	pop    %edi
  80314a:	5d                   	pop    %ebp
  80314b:	c3                   	ret    
  80314c:	39 ce                	cmp    %ecx,%esi
  80314e:	77 28                	ja     803178 <__udivdi3+0x7c>
  803150:	0f bd fe             	bsr    %esi,%edi
  803153:	83 f7 1f             	xor    $0x1f,%edi
  803156:	75 40                	jne    803198 <__udivdi3+0x9c>
  803158:	39 ce                	cmp    %ecx,%esi
  80315a:	72 0a                	jb     803166 <__udivdi3+0x6a>
  80315c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803160:	0f 87 9e 00 00 00    	ja     803204 <__udivdi3+0x108>
  803166:	b8 01 00 00 00       	mov    $0x1,%eax
  80316b:	89 fa                	mov    %edi,%edx
  80316d:	83 c4 1c             	add    $0x1c,%esp
  803170:	5b                   	pop    %ebx
  803171:	5e                   	pop    %esi
  803172:	5f                   	pop    %edi
  803173:	5d                   	pop    %ebp
  803174:	c3                   	ret    
  803175:	8d 76 00             	lea    0x0(%esi),%esi
  803178:	31 ff                	xor    %edi,%edi
  80317a:	31 c0                	xor    %eax,%eax
  80317c:	89 fa                	mov    %edi,%edx
  80317e:	83 c4 1c             	add    $0x1c,%esp
  803181:	5b                   	pop    %ebx
  803182:	5e                   	pop    %esi
  803183:	5f                   	pop    %edi
  803184:	5d                   	pop    %ebp
  803185:	c3                   	ret    
  803186:	66 90                	xchg   %ax,%ax
  803188:	89 d8                	mov    %ebx,%eax
  80318a:	f7 f7                	div    %edi
  80318c:	31 ff                	xor    %edi,%edi
  80318e:	89 fa                	mov    %edi,%edx
  803190:	83 c4 1c             	add    $0x1c,%esp
  803193:	5b                   	pop    %ebx
  803194:	5e                   	pop    %esi
  803195:	5f                   	pop    %edi
  803196:	5d                   	pop    %ebp
  803197:	c3                   	ret    
  803198:	bd 20 00 00 00       	mov    $0x20,%ebp
  80319d:	89 eb                	mov    %ebp,%ebx
  80319f:	29 fb                	sub    %edi,%ebx
  8031a1:	89 f9                	mov    %edi,%ecx
  8031a3:	d3 e6                	shl    %cl,%esi
  8031a5:	89 c5                	mov    %eax,%ebp
  8031a7:	88 d9                	mov    %bl,%cl
  8031a9:	d3 ed                	shr    %cl,%ebp
  8031ab:	89 e9                	mov    %ebp,%ecx
  8031ad:	09 f1                	or     %esi,%ecx
  8031af:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031b3:	89 f9                	mov    %edi,%ecx
  8031b5:	d3 e0                	shl    %cl,%eax
  8031b7:	89 c5                	mov    %eax,%ebp
  8031b9:	89 d6                	mov    %edx,%esi
  8031bb:	88 d9                	mov    %bl,%cl
  8031bd:	d3 ee                	shr    %cl,%esi
  8031bf:	89 f9                	mov    %edi,%ecx
  8031c1:	d3 e2                	shl    %cl,%edx
  8031c3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031c7:	88 d9                	mov    %bl,%cl
  8031c9:	d3 e8                	shr    %cl,%eax
  8031cb:	09 c2                	or     %eax,%edx
  8031cd:	89 d0                	mov    %edx,%eax
  8031cf:	89 f2                	mov    %esi,%edx
  8031d1:	f7 74 24 0c          	divl   0xc(%esp)
  8031d5:	89 d6                	mov    %edx,%esi
  8031d7:	89 c3                	mov    %eax,%ebx
  8031d9:	f7 e5                	mul    %ebp
  8031db:	39 d6                	cmp    %edx,%esi
  8031dd:	72 19                	jb     8031f8 <__udivdi3+0xfc>
  8031df:	74 0b                	je     8031ec <__udivdi3+0xf0>
  8031e1:	89 d8                	mov    %ebx,%eax
  8031e3:	31 ff                	xor    %edi,%edi
  8031e5:	e9 58 ff ff ff       	jmp    803142 <__udivdi3+0x46>
  8031ea:	66 90                	xchg   %ax,%ax
  8031ec:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031f0:	89 f9                	mov    %edi,%ecx
  8031f2:	d3 e2                	shl    %cl,%edx
  8031f4:	39 c2                	cmp    %eax,%edx
  8031f6:	73 e9                	jae    8031e1 <__udivdi3+0xe5>
  8031f8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031fb:	31 ff                	xor    %edi,%edi
  8031fd:	e9 40 ff ff ff       	jmp    803142 <__udivdi3+0x46>
  803202:	66 90                	xchg   %ax,%ax
  803204:	31 c0                	xor    %eax,%eax
  803206:	e9 37 ff ff ff       	jmp    803142 <__udivdi3+0x46>
  80320b:	90                   	nop

0080320c <__umoddi3>:
  80320c:	55                   	push   %ebp
  80320d:	57                   	push   %edi
  80320e:	56                   	push   %esi
  80320f:	53                   	push   %ebx
  803210:	83 ec 1c             	sub    $0x1c,%esp
  803213:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803217:	8b 74 24 34          	mov    0x34(%esp),%esi
  80321b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80321f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803223:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803227:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80322b:	89 f3                	mov    %esi,%ebx
  80322d:	89 fa                	mov    %edi,%edx
  80322f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803233:	89 34 24             	mov    %esi,(%esp)
  803236:	85 c0                	test   %eax,%eax
  803238:	75 1a                	jne    803254 <__umoddi3+0x48>
  80323a:	39 f7                	cmp    %esi,%edi
  80323c:	0f 86 a2 00 00 00    	jbe    8032e4 <__umoddi3+0xd8>
  803242:	89 c8                	mov    %ecx,%eax
  803244:	89 f2                	mov    %esi,%edx
  803246:	f7 f7                	div    %edi
  803248:	89 d0                	mov    %edx,%eax
  80324a:	31 d2                	xor    %edx,%edx
  80324c:	83 c4 1c             	add    $0x1c,%esp
  80324f:	5b                   	pop    %ebx
  803250:	5e                   	pop    %esi
  803251:	5f                   	pop    %edi
  803252:	5d                   	pop    %ebp
  803253:	c3                   	ret    
  803254:	39 f0                	cmp    %esi,%eax
  803256:	0f 87 ac 00 00 00    	ja     803308 <__umoddi3+0xfc>
  80325c:	0f bd e8             	bsr    %eax,%ebp
  80325f:	83 f5 1f             	xor    $0x1f,%ebp
  803262:	0f 84 ac 00 00 00    	je     803314 <__umoddi3+0x108>
  803268:	bf 20 00 00 00       	mov    $0x20,%edi
  80326d:	29 ef                	sub    %ebp,%edi
  80326f:	89 fe                	mov    %edi,%esi
  803271:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803275:	89 e9                	mov    %ebp,%ecx
  803277:	d3 e0                	shl    %cl,%eax
  803279:	89 d7                	mov    %edx,%edi
  80327b:	89 f1                	mov    %esi,%ecx
  80327d:	d3 ef                	shr    %cl,%edi
  80327f:	09 c7                	or     %eax,%edi
  803281:	89 e9                	mov    %ebp,%ecx
  803283:	d3 e2                	shl    %cl,%edx
  803285:	89 14 24             	mov    %edx,(%esp)
  803288:	89 d8                	mov    %ebx,%eax
  80328a:	d3 e0                	shl    %cl,%eax
  80328c:	89 c2                	mov    %eax,%edx
  80328e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803292:	d3 e0                	shl    %cl,%eax
  803294:	89 44 24 04          	mov    %eax,0x4(%esp)
  803298:	8b 44 24 08          	mov    0x8(%esp),%eax
  80329c:	89 f1                	mov    %esi,%ecx
  80329e:	d3 e8                	shr    %cl,%eax
  8032a0:	09 d0                	or     %edx,%eax
  8032a2:	d3 eb                	shr    %cl,%ebx
  8032a4:	89 da                	mov    %ebx,%edx
  8032a6:	f7 f7                	div    %edi
  8032a8:	89 d3                	mov    %edx,%ebx
  8032aa:	f7 24 24             	mull   (%esp)
  8032ad:	89 c6                	mov    %eax,%esi
  8032af:	89 d1                	mov    %edx,%ecx
  8032b1:	39 d3                	cmp    %edx,%ebx
  8032b3:	0f 82 87 00 00 00    	jb     803340 <__umoddi3+0x134>
  8032b9:	0f 84 91 00 00 00    	je     803350 <__umoddi3+0x144>
  8032bf:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032c3:	29 f2                	sub    %esi,%edx
  8032c5:	19 cb                	sbb    %ecx,%ebx
  8032c7:	89 d8                	mov    %ebx,%eax
  8032c9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032cd:	d3 e0                	shl    %cl,%eax
  8032cf:	89 e9                	mov    %ebp,%ecx
  8032d1:	d3 ea                	shr    %cl,%edx
  8032d3:	09 d0                	or     %edx,%eax
  8032d5:	89 e9                	mov    %ebp,%ecx
  8032d7:	d3 eb                	shr    %cl,%ebx
  8032d9:	89 da                	mov    %ebx,%edx
  8032db:	83 c4 1c             	add    $0x1c,%esp
  8032de:	5b                   	pop    %ebx
  8032df:	5e                   	pop    %esi
  8032e0:	5f                   	pop    %edi
  8032e1:	5d                   	pop    %ebp
  8032e2:	c3                   	ret    
  8032e3:	90                   	nop
  8032e4:	89 fd                	mov    %edi,%ebp
  8032e6:	85 ff                	test   %edi,%edi
  8032e8:	75 0b                	jne    8032f5 <__umoddi3+0xe9>
  8032ea:	b8 01 00 00 00       	mov    $0x1,%eax
  8032ef:	31 d2                	xor    %edx,%edx
  8032f1:	f7 f7                	div    %edi
  8032f3:	89 c5                	mov    %eax,%ebp
  8032f5:	89 f0                	mov    %esi,%eax
  8032f7:	31 d2                	xor    %edx,%edx
  8032f9:	f7 f5                	div    %ebp
  8032fb:	89 c8                	mov    %ecx,%eax
  8032fd:	f7 f5                	div    %ebp
  8032ff:	89 d0                	mov    %edx,%eax
  803301:	e9 44 ff ff ff       	jmp    80324a <__umoddi3+0x3e>
  803306:	66 90                	xchg   %ax,%ax
  803308:	89 c8                	mov    %ecx,%eax
  80330a:	89 f2                	mov    %esi,%edx
  80330c:	83 c4 1c             	add    $0x1c,%esp
  80330f:	5b                   	pop    %ebx
  803310:	5e                   	pop    %esi
  803311:	5f                   	pop    %edi
  803312:	5d                   	pop    %ebp
  803313:	c3                   	ret    
  803314:	3b 04 24             	cmp    (%esp),%eax
  803317:	72 06                	jb     80331f <__umoddi3+0x113>
  803319:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80331d:	77 0f                	ja     80332e <__umoddi3+0x122>
  80331f:	89 f2                	mov    %esi,%edx
  803321:	29 f9                	sub    %edi,%ecx
  803323:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803327:	89 14 24             	mov    %edx,(%esp)
  80332a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80332e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803332:	8b 14 24             	mov    (%esp),%edx
  803335:	83 c4 1c             	add    $0x1c,%esp
  803338:	5b                   	pop    %ebx
  803339:	5e                   	pop    %esi
  80333a:	5f                   	pop    %edi
  80333b:	5d                   	pop    %ebp
  80333c:	c3                   	ret    
  80333d:	8d 76 00             	lea    0x0(%esi),%esi
  803340:	2b 04 24             	sub    (%esp),%eax
  803343:	19 fa                	sbb    %edi,%edx
  803345:	89 d1                	mov    %edx,%ecx
  803347:	89 c6                	mov    %eax,%esi
  803349:	e9 71 ff ff ff       	jmp    8032bf <__umoddi3+0xb3>
  80334e:	66 90                	xchg   %ax,%ax
  803350:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803354:	72 ea                	jb     803340 <__umoddi3+0x134>
  803356:	89 d9                	mov    %ebx,%ecx
  803358:	e9 62 ff ff ff       	jmp    8032bf <__umoddi3+0xb3>
