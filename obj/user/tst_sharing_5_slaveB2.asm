
obj/user/tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 44 01 00 00       	call   80017a <libmain>
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
  80008c:	68 a0 33 80 00       	push   $0x8033a0
  800091:	6a 12                	push   $0x12
  800093:	68 bc 33 80 00       	push   $0x8033bc
  800098:	e8 19 02 00 00       	call   8002b6 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 62 14 00 00       	call   801509 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  8000aa:	e8 f1 1b 00 00       	call   801ca0 <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 d9 33 80 00       	push   $0x8033d9
  8000b7:	50                   	push   %eax
  8000b8:	e8 9c 16 00 00       	call   801759 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000c3:	83 ec 0c             	sub    $0xc,%esp
  8000c6:	68 dc 33 80 00       	push   $0x8033dc
  8000cb:	e8 9a 04 00 00       	call   80056a <cprintf>
  8000d0:	83 c4 10             	add    $0x10,%esp
	//To indicate that it's successfully got z
	inctst();
  8000d3:	e8 ed 1c 00 00       	call   801dc5 <inctst>

	cprintf("Slave B2 please be patient ...\n");
  8000d8:	83 ec 0c             	sub    $0xc,%esp
  8000db:	68 04 34 80 00       	push   $0x803404
  8000e0:	e8 85 04 00 00       	call   80056a <cprintf>
  8000e5:	83 c4 10             	add    $0x10,%esp

	//sleep a while to allow the master to remove x & z
	env_sleep(9000);
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	68 28 23 00 00       	push   $0x2328
  8000f0:	e8 79 2f 00 00       	call   80306e <env_sleep>
  8000f5:	83 c4 10             	add    $0x10,%esp
	//to ensure that the other environments completed successfully
	while (gettst()!=2) ;// panic("test failed");
  8000f8:	90                   	nop
  8000f9:	e8 e1 1c 00 00       	call   801ddf <gettst>
  8000fe:	83 f8 02             	cmp    $0x2,%eax
  800101:	75 f6                	jne    8000f9 <_main+0xc1>

	int freeFrames = sys_calculate_free_frames() ;
  800103:	e8 9f 18 00 00       	call   8019a7 <sys_calculate_free_frames>
  800108:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 ec             	pushl  -0x14(%ebp)
  800111:	e8 31 17 00 00       	call   801847 <sfree>
  800116:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	68 24 34 80 00       	push   $0x803424
  800121:	e8 44 04 00 00       	call   80056a <cprintf>
  800126:	83 c4 10             	add    $0x10,%esp
	int expected = (1+1) + (1+1);
  800129:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
	if ((sys_calculate_free_frames() - freeFrames) !=  expected) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  800130:	e8 72 18 00 00       	call   8019a7 <sys_calculate_free_frames>
  800135:	89 c2                	mov    %eax,%edx
  800137:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80013a:	29 c2                	sub    %eax,%edx
  80013c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80013f:	39 c2                	cmp    %eax,%edx
  800141:	74 14                	je     800157 <_main+0x11f>
  800143:	83 ec 04             	sub    $0x4,%esp
  800146:	68 3c 34 80 00       	push   $0x80343c
  80014b:	6a 2a                	push   $0x2a
  80014d:	68 bc 33 80 00       	push   $0x8033bc
  800152:	e8 5f 01 00 00       	call   8002b6 <_panic>


	cprintf("Step B completed successfully!!\n\n\n");
  800157:	83 ec 0c             	sub    $0xc,%esp
  80015a:	68 dc 34 80 00       	push   $0x8034dc
  80015f:	e8 06 04 00 00       	call   80056a <cprintf>
  800164:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	68 00 35 80 00       	push   $0x803500
  80016f:	e8 f6 03 00 00       	call   80056a <cprintf>
  800174:	83 c4 10             	add    $0x10,%esp

	return;
  800177:	90                   	nop
}
  800178:	c9                   	leave  
  800179:	c3                   	ret    

0080017a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80017a:	55                   	push   %ebp
  80017b:	89 e5                	mov    %esp,%ebp
  80017d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800180:	e8 02 1b 00 00       	call   801c87 <sys_getenvindex>
  800185:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800188:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80018b:	89 d0                	mov    %edx,%eax
  80018d:	c1 e0 03             	shl    $0x3,%eax
  800190:	01 d0                	add    %edx,%eax
  800192:	01 c0                	add    %eax,%eax
  800194:	01 d0                	add    %edx,%eax
  800196:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80019d:	01 d0                	add    %edx,%eax
  80019f:	c1 e0 04             	shl    $0x4,%eax
  8001a2:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001a7:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001b7:	84 c0                	test   %al,%al
  8001b9:	74 0f                	je     8001ca <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c0:	05 5c 05 00 00       	add    $0x55c,%eax
  8001c5:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001ce:	7e 0a                	jle    8001da <libmain+0x60>
		binaryname = argv[0];
  8001d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001d3:	8b 00                	mov    (%eax),%eax
  8001d5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001da:	83 ec 08             	sub    $0x8,%esp
  8001dd:	ff 75 0c             	pushl  0xc(%ebp)
  8001e0:	ff 75 08             	pushl  0x8(%ebp)
  8001e3:	e8 50 fe ff ff       	call   800038 <_main>
  8001e8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001eb:	e8 a4 18 00 00       	call   801a94 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001f0:	83 ec 0c             	sub    $0xc,%esp
  8001f3:	68 64 35 80 00       	push   $0x803564
  8001f8:	e8 6d 03 00 00       	call   80056a <cprintf>
  8001fd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800200:	a1 20 40 80 00       	mov    0x804020,%eax
  800205:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80020b:	a1 20 40 80 00       	mov    0x804020,%eax
  800210:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800216:	83 ec 04             	sub    $0x4,%esp
  800219:	52                   	push   %edx
  80021a:	50                   	push   %eax
  80021b:	68 8c 35 80 00       	push   $0x80358c
  800220:	e8 45 03 00 00       	call   80056a <cprintf>
  800225:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800228:	a1 20 40 80 00       	mov    0x804020,%eax
  80022d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80023e:	a1 20 40 80 00       	mov    0x804020,%eax
  800243:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800249:	51                   	push   %ecx
  80024a:	52                   	push   %edx
  80024b:	50                   	push   %eax
  80024c:	68 b4 35 80 00       	push   $0x8035b4
  800251:	e8 14 03 00 00       	call   80056a <cprintf>
  800256:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800259:	a1 20 40 80 00       	mov    0x804020,%eax
  80025e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800264:	83 ec 08             	sub    $0x8,%esp
  800267:	50                   	push   %eax
  800268:	68 0c 36 80 00       	push   $0x80360c
  80026d:	e8 f8 02 00 00       	call   80056a <cprintf>
  800272:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800275:	83 ec 0c             	sub    $0xc,%esp
  800278:	68 64 35 80 00       	push   $0x803564
  80027d:	e8 e8 02 00 00       	call   80056a <cprintf>
  800282:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800285:	e8 24 18 00 00       	call   801aae <sys_enable_interrupt>

	// exit gracefully
	exit();
  80028a:	e8 19 00 00 00       	call   8002a8 <exit>
}
  80028f:	90                   	nop
  800290:	c9                   	leave  
  800291:	c3                   	ret    

00800292 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800292:	55                   	push   %ebp
  800293:	89 e5                	mov    %esp,%ebp
  800295:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	6a 00                	push   $0x0
  80029d:	e8 b1 19 00 00       	call   801c53 <sys_destroy_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <exit>:

void
exit(void)
{
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002ae:	e8 06 1a 00 00       	call   801cb9 <sys_exit_env>
}
  8002b3:	90                   	nop
  8002b4:	c9                   	leave  
  8002b5:	c3                   	ret    

008002b6 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002b6:	55                   	push   %ebp
  8002b7:	89 e5                	mov    %esp,%ebp
  8002b9:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002bc:	8d 45 10             	lea    0x10(%ebp),%eax
  8002bf:	83 c0 04             	add    $0x4,%eax
  8002c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002c5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002ca:	85 c0                	test   %eax,%eax
  8002cc:	74 16                	je     8002e4 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8002ce:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002d3:	83 ec 08             	sub    $0x8,%esp
  8002d6:	50                   	push   %eax
  8002d7:	68 20 36 80 00       	push   $0x803620
  8002dc:	e8 89 02 00 00       	call   80056a <cprintf>
  8002e1:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8002e4:	a1 00 40 80 00       	mov    0x804000,%eax
  8002e9:	ff 75 0c             	pushl  0xc(%ebp)
  8002ec:	ff 75 08             	pushl  0x8(%ebp)
  8002ef:	50                   	push   %eax
  8002f0:	68 25 36 80 00       	push   $0x803625
  8002f5:	e8 70 02 00 00       	call   80056a <cprintf>
  8002fa:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002fd:	8b 45 10             	mov    0x10(%ebp),%eax
  800300:	83 ec 08             	sub    $0x8,%esp
  800303:	ff 75 f4             	pushl  -0xc(%ebp)
  800306:	50                   	push   %eax
  800307:	e8 f3 01 00 00       	call   8004ff <vcprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80030f:	83 ec 08             	sub    $0x8,%esp
  800312:	6a 00                	push   $0x0
  800314:	68 41 36 80 00       	push   $0x803641
  800319:	e8 e1 01 00 00       	call   8004ff <vcprintf>
  80031e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800321:	e8 82 ff ff ff       	call   8002a8 <exit>

	// should not return here
	while (1) ;
  800326:	eb fe                	jmp    800326 <_panic+0x70>

00800328 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800328:	55                   	push   %ebp
  800329:	89 e5                	mov    %esp,%ebp
  80032b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80032e:	a1 20 40 80 00       	mov    0x804020,%eax
  800333:	8b 50 74             	mov    0x74(%eax),%edx
  800336:	8b 45 0c             	mov    0xc(%ebp),%eax
  800339:	39 c2                	cmp    %eax,%edx
  80033b:	74 14                	je     800351 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 44 36 80 00       	push   $0x803644
  800345:	6a 26                	push   $0x26
  800347:	68 90 36 80 00       	push   $0x803690
  80034c:	e8 65 ff ff ff       	call   8002b6 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800351:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800358:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80035f:	e9 c2 00 00 00       	jmp    800426 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800364:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800367:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80036e:	8b 45 08             	mov    0x8(%ebp),%eax
  800371:	01 d0                	add    %edx,%eax
  800373:	8b 00                	mov    (%eax),%eax
  800375:	85 c0                	test   %eax,%eax
  800377:	75 08                	jne    800381 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800379:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  80037c:	e9 a2 00 00 00       	jmp    800423 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800381:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800388:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80038f:	eb 69                	jmp    8003fa <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800391:	a1 20 40 80 00       	mov    0x804020,%eax
  800396:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80039c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	01 c0                	add    %eax,%eax
  8003a3:	01 d0                	add    %edx,%eax
  8003a5:	c1 e0 03             	shl    $0x3,%eax
  8003a8:	01 c8                	add    %ecx,%eax
  8003aa:	8a 40 04             	mov    0x4(%eax),%al
  8003ad:	84 c0                	test   %al,%al
  8003af:	75 46                	jne    8003f7 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003b1:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003bc:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003bf:	89 d0                	mov    %edx,%eax
  8003c1:	01 c0                	add    %eax,%eax
  8003c3:	01 d0                	add    %edx,%eax
  8003c5:	c1 e0 03             	shl    $0x3,%eax
  8003c8:	01 c8                	add    %ecx,%eax
  8003ca:	8b 00                	mov    (%eax),%eax
  8003cc:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8003cf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8003d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8003d7:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8003d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003dc:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c8                	add    %ecx,%eax
  8003e8:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003ea:	39 c2                	cmp    %eax,%edx
  8003ec:	75 09                	jne    8003f7 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003ee:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003f5:	eb 12                	jmp    800409 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f7:	ff 45 e8             	incl   -0x18(%ebp)
  8003fa:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ff:	8b 50 74             	mov    0x74(%eax),%edx
  800402:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800405:	39 c2                	cmp    %eax,%edx
  800407:	77 88                	ja     800391 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800409:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80040d:	75 14                	jne    800423 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80040f:	83 ec 04             	sub    $0x4,%esp
  800412:	68 9c 36 80 00       	push   $0x80369c
  800417:	6a 3a                	push   $0x3a
  800419:	68 90 36 80 00       	push   $0x803690
  80041e:	e8 93 fe ff ff       	call   8002b6 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800423:	ff 45 f0             	incl   -0x10(%ebp)
  800426:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800429:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80042c:	0f 8c 32 ff ff ff    	jl     800364 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800432:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800439:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800440:	eb 26                	jmp    800468 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800442:	a1 20 40 80 00       	mov    0x804020,%eax
  800447:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80044d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800450:	89 d0                	mov    %edx,%eax
  800452:	01 c0                	add    %eax,%eax
  800454:	01 d0                	add    %edx,%eax
  800456:	c1 e0 03             	shl    $0x3,%eax
  800459:	01 c8                	add    %ecx,%eax
  80045b:	8a 40 04             	mov    0x4(%eax),%al
  80045e:	3c 01                	cmp    $0x1,%al
  800460:	75 03                	jne    800465 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800462:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800465:	ff 45 e0             	incl   -0x20(%ebp)
  800468:	a1 20 40 80 00       	mov    0x804020,%eax
  80046d:	8b 50 74             	mov    0x74(%eax),%edx
  800470:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800473:	39 c2                	cmp    %eax,%edx
  800475:	77 cb                	ja     800442 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80047a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80047d:	74 14                	je     800493 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 f0 36 80 00       	push   $0x8036f0
  800487:	6a 44                	push   $0x44
  800489:	68 90 36 80 00       	push   $0x803690
  80048e:	e8 23 fe ff ff       	call   8002b6 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800493:	90                   	nop
  800494:	c9                   	leave  
  800495:	c3                   	ret    

00800496 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800496:	55                   	push   %ebp
  800497:	89 e5                	mov    %esp,%ebp
  800499:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049f:	8b 00                	mov    (%eax),%eax
  8004a1:	8d 48 01             	lea    0x1(%eax),%ecx
  8004a4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004a7:	89 0a                	mov    %ecx,(%edx)
  8004a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8004ac:	88 d1                	mov    %dl,%cl
  8004ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004b1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004bf:	75 2c                	jne    8004ed <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004c1:	a0 24 40 80 00       	mov    0x804024,%al
  8004c6:	0f b6 c0             	movzbl %al,%eax
  8004c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004cc:	8b 12                	mov    (%edx),%edx
  8004ce:	89 d1                	mov    %edx,%ecx
  8004d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004d3:	83 c2 08             	add    $0x8,%edx
  8004d6:	83 ec 04             	sub    $0x4,%esp
  8004d9:	50                   	push   %eax
  8004da:	51                   	push   %ecx
  8004db:	52                   	push   %edx
  8004dc:	e8 05 14 00 00       	call   8018e6 <sys_cputs>
  8004e1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8004e4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004ed:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f0:	8b 40 04             	mov    0x4(%eax),%eax
  8004f3:	8d 50 01             	lea    0x1(%eax),%edx
  8004f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004f9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004fc:	90                   	nop
  8004fd:	c9                   	leave  
  8004fe:	c3                   	ret    

008004ff <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ff:	55                   	push   %ebp
  800500:	89 e5                	mov    %esp,%ebp
  800502:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800508:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80050f:	00 00 00 
	b.cnt = 0;
  800512:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800519:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80051c:	ff 75 0c             	pushl  0xc(%ebp)
  80051f:	ff 75 08             	pushl  0x8(%ebp)
  800522:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800528:	50                   	push   %eax
  800529:	68 96 04 80 00       	push   $0x800496
  80052e:	e8 11 02 00 00       	call   800744 <vprintfmt>
  800533:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800536:	a0 24 40 80 00       	mov    0x804024,%al
  80053b:	0f b6 c0             	movzbl %al,%eax
  80053e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800544:	83 ec 04             	sub    $0x4,%esp
  800547:	50                   	push   %eax
  800548:	52                   	push   %edx
  800549:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80054f:	83 c0 08             	add    $0x8,%eax
  800552:	50                   	push   %eax
  800553:	e8 8e 13 00 00       	call   8018e6 <sys_cputs>
  800558:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80055b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800562:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800568:	c9                   	leave  
  800569:	c3                   	ret    

0080056a <cprintf>:

int cprintf(const char *fmt, ...) {
  80056a:	55                   	push   %ebp
  80056b:	89 e5                	mov    %esp,%ebp
  80056d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800570:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800577:	8d 45 0c             	lea    0xc(%ebp),%eax
  80057a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80057d:	8b 45 08             	mov    0x8(%ebp),%eax
  800580:	83 ec 08             	sub    $0x8,%esp
  800583:	ff 75 f4             	pushl  -0xc(%ebp)
  800586:	50                   	push   %eax
  800587:	e8 73 ff ff ff       	call   8004ff <vcprintf>
  80058c:	83 c4 10             	add    $0x10,%esp
  80058f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800592:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800595:	c9                   	leave  
  800596:	c3                   	ret    

00800597 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800597:	55                   	push   %ebp
  800598:	89 e5                	mov    %esp,%ebp
  80059a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80059d:	e8 f2 14 00 00       	call   801a94 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005a2:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ab:	83 ec 08             	sub    $0x8,%esp
  8005ae:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b1:	50                   	push   %eax
  8005b2:	e8 48 ff ff ff       	call   8004ff <vcprintf>
  8005b7:	83 c4 10             	add    $0x10,%esp
  8005ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005bd:	e8 ec 14 00 00       	call   801aae <sys_enable_interrupt>
	return cnt;
  8005c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c5:	c9                   	leave  
  8005c6:	c3                   	ret    

008005c7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	53                   	push   %ebx
  8005cb:	83 ec 14             	sub    $0x14,%esp
  8005ce:	8b 45 10             	mov    0x10(%ebp),%eax
  8005d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8005d4:	8b 45 14             	mov    0x14(%ebp),%eax
  8005d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8005da:	8b 45 18             	mov    0x18(%ebp),%eax
  8005dd:	ba 00 00 00 00       	mov    $0x0,%edx
  8005e2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005e5:	77 55                	ja     80063c <printnum+0x75>
  8005e7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005ea:	72 05                	jb     8005f1 <printnum+0x2a>
  8005ec:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005ef:	77 4b                	ja     80063c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005f1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005f4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005f7:	8b 45 18             	mov    0x18(%ebp),%eax
  8005fa:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ff:	52                   	push   %edx
  800600:	50                   	push   %eax
  800601:	ff 75 f4             	pushl  -0xc(%ebp)
  800604:	ff 75 f0             	pushl  -0x10(%ebp)
  800607:	e8 18 2b 00 00       	call   803124 <__udivdi3>
  80060c:	83 c4 10             	add    $0x10,%esp
  80060f:	83 ec 04             	sub    $0x4,%esp
  800612:	ff 75 20             	pushl  0x20(%ebp)
  800615:	53                   	push   %ebx
  800616:	ff 75 18             	pushl  0x18(%ebp)
  800619:	52                   	push   %edx
  80061a:	50                   	push   %eax
  80061b:	ff 75 0c             	pushl  0xc(%ebp)
  80061e:	ff 75 08             	pushl  0x8(%ebp)
  800621:	e8 a1 ff ff ff       	call   8005c7 <printnum>
  800626:	83 c4 20             	add    $0x20,%esp
  800629:	eb 1a                	jmp    800645 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80062b:	83 ec 08             	sub    $0x8,%esp
  80062e:	ff 75 0c             	pushl  0xc(%ebp)
  800631:	ff 75 20             	pushl  0x20(%ebp)
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	ff d0                	call   *%eax
  800639:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80063c:	ff 4d 1c             	decl   0x1c(%ebp)
  80063f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800643:	7f e6                	jg     80062b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800645:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800648:	bb 00 00 00 00       	mov    $0x0,%ebx
  80064d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800650:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800653:	53                   	push   %ebx
  800654:	51                   	push   %ecx
  800655:	52                   	push   %edx
  800656:	50                   	push   %eax
  800657:	e8 d8 2b 00 00       	call   803234 <__umoddi3>
  80065c:	83 c4 10             	add    $0x10,%esp
  80065f:	05 54 39 80 00       	add    $0x803954,%eax
  800664:	8a 00                	mov    (%eax),%al
  800666:	0f be c0             	movsbl %al,%eax
  800669:	83 ec 08             	sub    $0x8,%esp
  80066c:	ff 75 0c             	pushl  0xc(%ebp)
  80066f:	50                   	push   %eax
  800670:	8b 45 08             	mov    0x8(%ebp),%eax
  800673:	ff d0                	call   *%eax
  800675:	83 c4 10             	add    $0x10,%esp
}
  800678:	90                   	nop
  800679:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800681:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800685:	7e 1c                	jle    8006a3 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800687:	8b 45 08             	mov    0x8(%ebp),%eax
  80068a:	8b 00                	mov    (%eax),%eax
  80068c:	8d 50 08             	lea    0x8(%eax),%edx
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	89 10                	mov    %edx,(%eax)
  800694:	8b 45 08             	mov    0x8(%ebp),%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	83 e8 08             	sub    $0x8,%eax
  80069c:	8b 50 04             	mov    0x4(%eax),%edx
  80069f:	8b 00                	mov    (%eax),%eax
  8006a1:	eb 40                	jmp    8006e3 <getuint+0x65>
	else if (lflag)
  8006a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006a7:	74 1e                	je     8006c7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 04             	lea    0x4(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 04             	sub    $0x4,%eax
  8006be:	8b 00                	mov    (%eax),%eax
  8006c0:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c5:	eb 1c                	jmp    8006e3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	8d 50 04             	lea    0x4(%eax),%edx
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	89 10                	mov    %edx,(%eax)
  8006d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d7:	8b 00                	mov    (%eax),%eax
  8006d9:	83 e8 04             	sub    $0x4,%eax
  8006dc:	8b 00                	mov    (%eax),%eax
  8006de:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8006e3:	5d                   	pop    %ebp
  8006e4:	c3                   	ret    

008006e5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006e5:	55                   	push   %ebp
  8006e6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006e8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006ec:	7e 1c                	jle    80070a <getint+0x25>
		return va_arg(*ap, long long);
  8006ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	8d 50 08             	lea    0x8(%eax),%edx
  8006f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f9:	89 10                	mov    %edx,(%eax)
  8006fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fe:	8b 00                	mov    (%eax),%eax
  800700:	83 e8 08             	sub    $0x8,%eax
  800703:	8b 50 04             	mov    0x4(%eax),%edx
  800706:	8b 00                	mov    (%eax),%eax
  800708:	eb 38                	jmp    800742 <getint+0x5d>
	else if (lflag)
  80070a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80070e:	74 1a                	je     80072a <getint+0x45>
		return va_arg(*ap, long);
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	8b 00                	mov    (%eax),%eax
  800715:	8d 50 04             	lea    0x4(%eax),%edx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	89 10                	mov    %edx,(%eax)
  80071d:	8b 45 08             	mov    0x8(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	83 e8 04             	sub    $0x4,%eax
  800725:	8b 00                	mov    (%eax),%eax
  800727:	99                   	cltd   
  800728:	eb 18                	jmp    800742 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80072a:	8b 45 08             	mov    0x8(%ebp),%eax
  80072d:	8b 00                	mov    (%eax),%eax
  80072f:	8d 50 04             	lea    0x4(%eax),%edx
  800732:	8b 45 08             	mov    0x8(%ebp),%eax
  800735:	89 10                	mov    %edx,(%eax)
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	83 e8 04             	sub    $0x4,%eax
  80073f:	8b 00                	mov    (%eax),%eax
  800741:	99                   	cltd   
}
  800742:	5d                   	pop    %ebp
  800743:	c3                   	ret    

00800744 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800744:	55                   	push   %ebp
  800745:	89 e5                	mov    %esp,%ebp
  800747:	56                   	push   %esi
  800748:	53                   	push   %ebx
  800749:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80074c:	eb 17                	jmp    800765 <vprintfmt+0x21>
			if (ch == '\0')
  80074e:	85 db                	test   %ebx,%ebx
  800750:	0f 84 af 03 00 00    	je     800b05 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800756:	83 ec 08             	sub    $0x8,%esp
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	53                   	push   %ebx
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	ff d0                	call   *%eax
  800762:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	8d 50 01             	lea    0x1(%eax),%edx
  80076b:	89 55 10             	mov    %edx,0x10(%ebp)
  80076e:	8a 00                	mov    (%eax),%al
  800770:	0f b6 d8             	movzbl %al,%ebx
  800773:	83 fb 25             	cmp    $0x25,%ebx
  800776:	75 d6                	jne    80074e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800778:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80077c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800783:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80078a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800791:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007a9:	83 f8 55             	cmp    $0x55,%eax
  8007ac:	0f 87 2b 03 00 00    	ja     800add <vprintfmt+0x399>
  8007b2:	8b 04 85 78 39 80 00 	mov    0x803978(,%eax,4),%eax
  8007b9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007bb:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007bf:	eb d7                	jmp    800798 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007c1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007c5:	eb d1                	jmp    800798 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007c7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8007ce:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8007d1:	89 d0                	mov    %edx,%eax
  8007d3:	c1 e0 02             	shl    $0x2,%eax
  8007d6:	01 d0                	add    %edx,%eax
  8007d8:	01 c0                	add    %eax,%eax
  8007da:	01 d8                	add    %ebx,%eax
  8007dc:	83 e8 30             	sub    $0x30,%eax
  8007df:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8007e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e5:	8a 00                	mov    (%eax),%al
  8007e7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007ea:	83 fb 2f             	cmp    $0x2f,%ebx
  8007ed:	7e 3e                	jle    80082d <vprintfmt+0xe9>
  8007ef:	83 fb 39             	cmp    $0x39,%ebx
  8007f2:	7f 39                	jg     80082d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007f4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007f7:	eb d5                	jmp    8007ce <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007f9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fc:	83 c0 04             	add    $0x4,%eax
  8007ff:	89 45 14             	mov    %eax,0x14(%ebp)
  800802:	8b 45 14             	mov    0x14(%ebp),%eax
  800805:	83 e8 04             	sub    $0x4,%eax
  800808:	8b 00                	mov    (%eax),%eax
  80080a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80080d:	eb 1f                	jmp    80082e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80080f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800813:	79 83                	jns    800798 <vprintfmt+0x54>
				width = 0;
  800815:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80081c:	e9 77 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800821:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800828:	e9 6b ff ff ff       	jmp    800798 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80082d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80082e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800832:	0f 89 60 ff ff ff    	jns    800798 <vprintfmt+0x54>
				width = precision, precision = -1;
  800838:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80083b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80083e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800845:	e9 4e ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80084a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80084d:	e9 46 ff ff ff       	jmp    800798 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800852:	8b 45 14             	mov    0x14(%ebp),%eax
  800855:	83 c0 04             	add    $0x4,%eax
  800858:	89 45 14             	mov    %eax,0x14(%ebp)
  80085b:	8b 45 14             	mov    0x14(%ebp),%eax
  80085e:	83 e8 04             	sub    $0x4,%eax
  800861:	8b 00                	mov    (%eax),%eax
  800863:	83 ec 08             	sub    $0x8,%esp
  800866:	ff 75 0c             	pushl  0xc(%ebp)
  800869:	50                   	push   %eax
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	ff d0                	call   *%eax
  80086f:	83 c4 10             	add    $0x10,%esp
			break;
  800872:	e9 89 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800877:	8b 45 14             	mov    0x14(%ebp),%eax
  80087a:	83 c0 04             	add    $0x4,%eax
  80087d:	89 45 14             	mov    %eax,0x14(%ebp)
  800880:	8b 45 14             	mov    0x14(%ebp),%eax
  800883:	83 e8 04             	sub    $0x4,%eax
  800886:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800888:	85 db                	test   %ebx,%ebx
  80088a:	79 02                	jns    80088e <vprintfmt+0x14a>
				err = -err;
  80088c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80088e:	83 fb 64             	cmp    $0x64,%ebx
  800891:	7f 0b                	jg     80089e <vprintfmt+0x15a>
  800893:	8b 34 9d c0 37 80 00 	mov    0x8037c0(,%ebx,4),%esi
  80089a:	85 f6                	test   %esi,%esi
  80089c:	75 19                	jne    8008b7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80089e:	53                   	push   %ebx
  80089f:	68 65 39 80 00       	push   $0x803965
  8008a4:	ff 75 0c             	pushl  0xc(%ebp)
  8008a7:	ff 75 08             	pushl  0x8(%ebp)
  8008aa:	e8 5e 02 00 00       	call   800b0d <printfmt>
  8008af:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008b2:	e9 49 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008b7:	56                   	push   %esi
  8008b8:	68 6e 39 80 00       	push   $0x80396e
  8008bd:	ff 75 0c             	pushl  0xc(%ebp)
  8008c0:	ff 75 08             	pushl  0x8(%ebp)
  8008c3:	e8 45 02 00 00       	call   800b0d <printfmt>
  8008c8:	83 c4 10             	add    $0x10,%esp
			break;
  8008cb:	e9 30 02 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8008d0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d3:	83 c0 04             	add    $0x4,%eax
  8008d6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dc:	83 e8 04             	sub    $0x4,%eax
  8008df:	8b 30                	mov    (%eax),%esi
  8008e1:	85 f6                	test   %esi,%esi
  8008e3:	75 05                	jne    8008ea <vprintfmt+0x1a6>
				p = "(null)";
  8008e5:	be 71 39 80 00       	mov    $0x803971,%esi
			if (width > 0 && padc != '-')
  8008ea:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ee:	7e 6d                	jle    80095d <vprintfmt+0x219>
  8008f0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008f4:	74 67                	je     80095d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f9:	83 ec 08             	sub    $0x8,%esp
  8008fc:	50                   	push   %eax
  8008fd:	56                   	push   %esi
  8008fe:	e8 0c 03 00 00       	call   800c0f <strnlen>
  800903:	83 c4 10             	add    $0x10,%esp
  800906:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800909:	eb 16                	jmp    800921 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80090b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	50                   	push   %eax
  800916:	8b 45 08             	mov    0x8(%ebp),%eax
  800919:	ff d0                	call   *%eax
  80091b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80091e:	ff 4d e4             	decl   -0x1c(%ebp)
  800921:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800925:	7f e4                	jg     80090b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800927:	eb 34                	jmp    80095d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800929:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80092d:	74 1c                	je     80094b <vprintfmt+0x207>
  80092f:	83 fb 1f             	cmp    $0x1f,%ebx
  800932:	7e 05                	jle    800939 <vprintfmt+0x1f5>
  800934:	83 fb 7e             	cmp    $0x7e,%ebx
  800937:	7e 12                	jle    80094b <vprintfmt+0x207>
					putch('?', putdat);
  800939:	83 ec 08             	sub    $0x8,%esp
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	6a 3f                	push   $0x3f
  800941:	8b 45 08             	mov    0x8(%ebp),%eax
  800944:	ff d0                	call   *%eax
  800946:	83 c4 10             	add    $0x10,%esp
  800949:	eb 0f                	jmp    80095a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80094b:	83 ec 08             	sub    $0x8,%esp
  80094e:	ff 75 0c             	pushl  0xc(%ebp)
  800951:	53                   	push   %ebx
  800952:	8b 45 08             	mov    0x8(%ebp),%eax
  800955:	ff d0                	call   *%eax
  800957:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	ff 4d e4             	decl   -0x1c(%ebp)
  80095d:	89 f0                	mov    %esi,%eax
  80095f:	8d 70 01             	lea    0x1(%eax),%esi
  800962:	8a 00                	mov    (%eax),%al
  800964:	0f be d8             	movsbl %al,%ebx
  800967:	85 db                	test   %ebx,%ebx
  800969:	74 24                	je     80098f <vprintfmt+0x24b>
  80096b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80096f:	78 b8                	js     800929 <vprintfmt+0x1e5>
  800971:	ff 4d e0             	decl   -0x20(%ebp)
  800974:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800978:	79 af                	jns    800929 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80097a:	eb 13                	jmp    80098f <vprintfmt+0x24b>
				putch(' ', putdat);
  80097c:	83 ec 08             	sub    $0x8,%esp
  80097f:	ff 75 0c             	pushl  0xc(%ebp)
  800982:	6a 20                	push   $0x20
  800984:	8b 45 08             	mov    0x8(%ebp),%eax
  800987:	ff d0                	call   *%eax
  800989:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80098c:	ff 4d e4             	decl   -0x1c(%ebp)
  80098f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800993:	7f e7                	jg     80097c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800995:	e9 66 01 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80099a:	83 ec 08             	sub    $0x8,%esp
  80099d:	ff 75 e8             	pushl  -0x18(%ebp)
  8009a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8009a3:	50                   	push   %eax
  8009a4:	e8 3c fd ff ff       	call   8006e5 <getint>
  8009a9:	83 c4 10             	add    $0x10,%esp
  8009ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b8:	85 d2                	test   %edx,%edx
  8009ba:	79 23                	jns    8009df <vprintfmt+0x29b>
				putch('-', putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	6a 2d                	push   $0x2d
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	ff d0                	call   *%eax
  8009c9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009d2:	f7 d8                	neg    %eax
  8009d4:	83 d2 00             	adc    $0x0,%edx
  8009d7:	f7 da                	neg    %edx
  8009d9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009dc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8009df:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009e6:	e9 bc 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009eb:	83 ec 08             	sub    $0x8,%esp
  8009ee:	ff 75 e8             	pushl  -0x18(%ebp)
  8009f1:	8d 45 14             	lea    0x14(%ebp),%eax
  8009f4:	50                   	push   %eax
  8009f5:	e8 84 fc ff ff       	call   80067e <getuint>
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a00:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a03:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a0a:	e9 98 00 00 00       	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 58                	push   $0x58
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a1f:	83 ec 08             	sub    $0x8,%esp
  800a22:	ff 75 0c             	pushl  0xc(%ebp)
  800a25:	6a 58                	push   $0x58
  800a27:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2a:	ff d0                	call   *%eax
  800a2c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a2f:	83 ec 08             	sub    $0x8,%esp
  800a32:	ff 75 0c             	pushl  0xc(%ebp)
  800a35:	6a 58                	push   $0x58
  800a37:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3a:	ff d0                	call   *%eax
  800a3c:	83 c4 10             	add    $0x10,%esp
			break;
  800a3f:	e9 bc 00 00 00       	jmp    800b00 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a44:	83 ec 08             	sub    $0x8,%esp
  800a47:	ff 75 0c             	pushl  0xc(%ebp)
  800a4a:	6a 30                	push   $0x30
  800a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4f:	ff d0                	call   *%eax
  800a51:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a54:	83 ec 08             	sub    $0x8,%esp
  800a57:	ff 75 0c             	pushl  0xc(%ebp)
  800a5a:	6a 78                	push   $0x78
  800a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5f:	ff d0                	call   *%eax
  800a61:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a64:	8b 45 14             	mov    0x14(%ebp),%eax
  800a67:	83 c0 04             	add    $0x4,%eax
  800a6a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a70:	83 e8 04             	sub    $0x4,%eax
  800a73:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a75:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a78:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a7f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a86:	eb 1f                	jmp    800aa7 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a88:	83 ec 08             	sub    $0x8,%esp
  800a8b:	ff 75 e8             	pushl  -0x18(%ebp)
  800a8e:	8d 45 14             	lea    0x14(%ebp),%eax
  800a91:	50                   	push   %eax
  800a92:	e8 e7 fb ff ff       	call   80067e <getuint>
  800a97:	83 c4 10             	add    $0x10,%esp
  800a9a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a9d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800aa0:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800aa7:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800aab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aae:	83 ec 04             	sub    $0x4,%esp
  800ab1:	52                   	push   %edx
  800ab2:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ab5:	50                   	push   %eax
  800ab6:	ff 75 f4             	pushl  -0xc(%ebp)
  800ab9:	ff 75 f0             	pushl  -0x10(%ebp)
  800abc:	ff 75 0c             	pushl  0xc(%ebp)
  800abf:	ff 75 08             	pushl  0x8(%ebp)
  800ac2:	e8 00 fb ff ff       	call   8005c7 <printnum>
  800ac7:	83 c4 20             	add    $0x20,%esp
			break;
  800aca:	eb 34                	jmp    800b00 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800acc:	83 ec 08             	sub    $0x8,%esp
  800acf:	ff 75 0c             	pushl  0xc(%ebp)
  800ad2:	53                   	push   %ebx
  800ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad6:	ff d0                	call   *%eax
  800ad8:	83 c4 10             	add    $0x10,%esp
			break;
  800adb:	eb 23                	jmp    800b00 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800add:	83 ec 08             	sub    $0x8,%esp
  800ae0:	ff 75 0c             	pushl  0xc(%ebp)
  800ae3:	6a 25                	push   $0x25
  800ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae8:	ff d0                	call   *%eax
  800aea:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aed:	ff 4d 10             	decl   0x10(%ebp)
  800af0:	eb 03                	jmp    800af5 <vprintfmt+0x3b1>
  800af2:	ff 4d 10             	decl   0x10(%ebp)
  800af5:	8b 45 10             	mov    0x10(%ebp),%eax
  800af8:	48                   	dec    %eax
  800af9:	8a 00                	mov    (%eax),%al
  800afb:	3c 25                	cmp    $0x25,%al
  800afd:	75 f3                	jne    800af2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aff:	90                   	nop
		}
	}
  800b00:	e9 47 fc ff ff       	jmp    80074c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b05:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b06:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b09:	5b                   	pop    %ebx
  800b0a:	5e                   	pop    %esi
  800b0b:	5d                   	pop    %ebp
  800b0c:	c3                   	ret    

00800b0d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b0d:	55                   	push   %ebp
  800b0e:	89 e5                	mov    %esp,%ebp
  800b10:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b13:	8d 45 10             	lea    0x10(%ebp),%eax
  800b16:	83 c0 04             	add    $0x4,%eax
  800b19:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b1f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b22:	50                   	push   %eax
  800b23:	ff 75 0c             	pushl  0xc(%ebp)
  800b26:	ff 75 08             	pushl  0x8(%ebp)
  800b29:	e8 16 fc ff ff       	call   800744 <vprintfmt>
  800b2e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b31:	90                   	nop
  800b32:	c9                   	leave  
  800b33:	c3                   	ret    

00800b34 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b34:	55                   	push   %ebp
  800b35:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b3a:	8b 40 08             	mov    0x8(%eax),%eax
  800b3d:	8d 50 01             	lea    0x1(%eax),%edx
  800b40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b43:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b49:	8b 10                	mov    (%eax),%edx
  800b4b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b4e:	8b 40 04             	mov    0x4(%eax),%eax
  800b51:	39 c2                	cmp    %eax,%edx
  800b53:	73 12                	jae    800b67 <sprintputch+0x33>
		*b->buf++ = ch;
  800b55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b58:	8b 00                	mov    (%eax),%eax
  800b5a:	8d 48 01             	lea    0x1(%eax),%ecx
  800b5d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b60:	89 0a                	mov    %ecx,(%edx)
  800b62:	8b 55 08             	mov    0x8(%ebp),%edx
  800b65:	88 10                	mov    %dl,(%eax)
}
  800b67:	90                   	nop
  800b68:	5d                   	pop    %ebp
  800b69:	c3                   	ret    

00800b6a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b6a:	55                   	push   %ebp
  800b6b:	89 e5                	mov    %esp,%ebp
  800b6d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b70:	8b 45 08             	mov    0x8(%ebp),%eax
  800b73:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b79:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7f:	01 d0                	add    %edx,%eax
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b8b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b8f:	74 06                	je     800b97 <vsnprintf+0x2d>
  800b91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b95:	7f 07                	jg     800b9e <vsnprintf+0x34>
		return -E_INVAL;
  800b97:	b8 03 00 00 00       	mov    $0x3,%eax
  800b9c:	eb 20                	jmp    800bbe <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b9e:	ff 75 14             	pushl  0x14(%ebp)
  800ba1:	ff 75 10             	pushl  0x10(%ebp)
  800ba4:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ba7:	50                   	push   %eax
  800ba8:	68 34 0b 80 00       	push   $0x800b34
  800bad:	e8 92 fb ff ff       	call   800744 <vprintfmt>
  800bb2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800bb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800bb8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bbb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bc6:	8d 45 10             	lea    0x10(%ebp),%eax
  800bc9:	83 c0 04             	add    $0x4,%eax
  800bcc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd5:	50                   	push   %eax
  800bd6:	ff 75 0c             	pushl  0xc(%ebp)
  800bd9:	ff 75 08             	pushl  0x8(%ebp)
  800bdc:	e8 89 ff ff ff       	call   800b6a <vsnprintf>
  800be1:	83 c4 10             	add    $0x10,%esp
  800be4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800be7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bf2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bf9:	eb 06                	jmp    800c01 <strlen+0x15>
		n++;
  800bfb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bfe:	ff 45 08             	incl   0x8(%ebp)
  800c01:	8b 45 08             	mov    0x8(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	84 c0                	test   %al,%al
  800c08:	75 f1                	jne    800bfb <strlen+0xf>
		n++;
	return n;
  800c0a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0d:	c9                   	leave  
  800c0e:	c3                   	ret    

00800c0f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c0f:	55                   	push   %ebp
  800c10:	89 e5                	mov    %esp,%ebp
  800c12:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c15:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c1c:	eb 09                	jmp    800c27 <strnlen+0x18>
		n++;
  800c1e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c21:	ff 45 08             	incl   0x8(%ebp)
  800c24:	ff 4d 0c             	decl   0xc(%ebp)
  800c27:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c2b:	74 09                	je     800c36 <strnlen+0x27>
  800c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c30:	8a 00                	mov    (%eax),%al
  800c32:	84 c0                	test   %al,%al
  800c34:	75 e8                	jne    800c1e <strnlen+0xf>
		n++;
	return n;
  800c36:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c39:	c9                   	leave  
  800c3a:	c3                   	ret    

00800c3b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c3b:	55                   	push   %ebp
  800c3c:	89 e5                	mov    %esp,%ebp
  800c3e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c41:	8b 45 08             	mov    0x8(%ebp),%eax
  800c44:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c47:	90                   	nop
  800c48:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4b:	8d 50 01             	lea    0x1(%eax),%edx
  800c4e:	89 55 08             	mov    %edx,0x8(%ebp)
  800c51:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c54:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c57:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c5a:	8a 12                	mov    (%edx),%dl
  800c5c:	88 10                	mov    %dl,(%eax)
  800c5e:	8a 00                	mov    (%eax),%al
  800c60:	84 c0                	test   %al,%al
  800c62:	75 e4                	jne    800c48 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c64:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c67:	c9                   	leave  
  800c68:	c3                   	ret    

00800c69 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c69:	55                   	push   %ebp
  800c6a:	89 e5                	mov    %esp,%ebp
  800c6c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c72:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c75:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c7c:	eb 1f                	jmp    800c9d <strncpy+0x34>
		*dst++ = *src;
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	8d 50 01             	lea    0x1(%eax),%edx
  800c84:	89 55 08             	mov    %edx,0x8(%ebp)
  800c87:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c8a:	8a 12                	mov    (%edx),%dl
  800c8c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	74 03                	je     800c9a <strncpy+0x31>
			src++;
  800c97:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c9a:	ff 45 fc             	incl   -0x4(%ebp)
  800c9d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca0:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ca3:	72 d9                	jb     800c7e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ca5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ca8:	c9                   	leave  
  800ca9:	c3                   	ret    

00800caa <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800caa:	55                   	push   %ebp
  800cab:	89 e5                	mov    %esp,%ebp
  800cad:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800cb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800cb6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cba:	74 30                	je     800cec <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cbc:	eb 16                	jmp    800cd4 <strlcpy+0x2a>
			*dst++ = *src++;
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8d 50 01             	lea    0x1(%eax),%edx
  800cc4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cca:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ccd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd0:	8a 12                	mov    (%edx),%dl
  800cd2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800cd4:	ff 4d 10             	decl   0x10(%ebp)
  800cd7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cdb:	74 09                	je     800ce6 <strlcpy+0x3c>
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	84 c0                	test   %al,%al
  800ce4:	75 d8                	jne    800cbe <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ce6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800cec:	8b 55 08             	mov    0x8(%ebp),%edx
  800cef:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf2:	29 c2                	sub    %eax,%edx
  800cf4:	89 d0                	mov    %edx,%eax
}
  800cf6:	c9                   	leave  
  800cf7:	c3                   	ret    

00800cf8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cf8:	55                   	push   %ebp
  800cf9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cfb:	eb 06                	jmp    800d03 <strcmp+0xb>
		p++, q++;
  800cfd:	ff 45 08             	incl   0x8(%ebp)
  800d00:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d03:	8b 45 08             	mov    0x8(%ebp),%eax
  800d06:	8a 00                	mov    (%eax),%al
  800d08:	84 c0                	test   %al,%al
  800d0a:	74 0e                	je     800d1a <strcmp+0x22>
  800d0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0f:	8a 10                	mov    (%eax),%dl
  800d11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d14:	8a 00                	mov    (%eax),%al
  800d16:	38 c2                	cmp    %al,%dl
  800d18:	74 e3                	je     800cfd <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1d:	8a 00                	mov    (%eax),%al
  800d1f:	0f b6 d0             	movzbl %al,%edx
  800d22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d25:	8a 00                	mov    (%eax),%al
  800d27:	0f b6 c0             	movzbl %al,%eax
  800d2a:	29 c2                	sub    %eax,%edx
  800d2c:	89 d0                	mov    %edx,%eax
}
  800d2e:	5d                   	pop    %ebp
  800d2f:	c3                   	ret    

00800d30 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d30:	55                   	push   %ebp
  800d31:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d33:	eb 09                	jmp    800d3e <strncmp+0xe>
		n--, p++, q++;
  800d35:	ff 4d 10             	decl   0x10(%ebp)
  800d38:	ff 45 08             	incl   0x8(%ebp)
  800d3b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d3e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d42:	74 17                	je     800d5b <strncmp+0x2b>
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	84 c0                	test   %al,%al
  800d4b:	74 0e                	je     800d5b <strncmp+0x2b>
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 10                	mov    (%eax),%dl
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	38 c2                	cmp    %al,%dl
  800d59:	74 da                	je     800d35 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5f:	75 07                	jne    800d68 <strncmp+0x38>
		return 0;
  800d61:	b8 00 00 00 00       	mov    $0x0,%eax
  800d66:	eb 14                	jmp    800d7c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d68:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	0f b6 d0             	movzbl %al,%edx
  800d70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d73:	8a 00                	mov    (%eax),%al
  800d75:	0f b6 c0             	movzbl %al,%eax
  800d78:	29 c2                	sub    %eax,%edx
  800d7a:	89 d0                	mov    %edx,%eax
}
  800d7c:	5d                   	pop    %ebp
  800d7d:	c3                   	ret    

00800d7e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d7e:	55                   	push   %ebp
  800d7f:	89 e5                	mov    %esp,%ebp
  800d81:	83 ec 04             	sub    $0x4,%esp
  800d84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d87:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d8a:	eb 12                	jmp    800d9e <strchr+0x20>
		if (*s == c)
  800d8c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8f:	8a 00                	mov    (%eax),%al
  800d91:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d94:	75 05                	jne    800d9b <strchr+0x1d>
			return (char *) s;
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	eb 11                	jmp    800dac <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d9b:	ff 45 08             	incl   0x8(%ebp)
  800d9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800da1:	8a 00                	mov    (%eax),%al
  800da3:	84 c0                	test   %al,%al
  800da5:	75 e5                	jne    800d8c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800da7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800dac:	c9                   	leave  
  800dad:	c3                   	ret    

00800dae <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800dae:	55                   	push   %ebp
  800daf:	89 e5                	mov    %esp,%ebp
  800db1:	83 ec 04             	sub    $0x4,%esp
  800db4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dba:	eb 0d                	jmp    800dc9 <strfind+0x1b>
		if (*s == c)
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	8a 00                	mov    (%eax),%al
  800dc1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc4:	74 0e                	je     800dd4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800dc6:	ff 45 08             	incl   0x8(%ebp)
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	84 c0                	test   %al,%al
  800dd0:	75 ea                	jne    800dbc <strfind+0xe>
  800dd2:	eb 01                	jmp    800dd5 <strfind+0x27>
		if (*s == c)
			break;
  800dd4:	90                   	nop
	return (char *) s;
  800dd5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd8:	c9                   	leave  
  800dd9:	c3                   	ret    

00800dda <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800dda:	55                   	push   %ebp
  800ddb:	89 e5                	mov    %esp,%ebp
  800ddd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800de6:	8b 45 10             	mov    0x10(%ebp),%eax
  800de9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800dec:	eb 0e                	jmp    800dfc <memset+0x22>
		*p++ = c;
  800dee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800df1:	8d 50 01             	lea    0x1(%eax),%edx
  800df4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800df7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfa:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800dfc:	ff 4d f8             	decl   -0x8(%ebp)
  800dff:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e03:	79 e9                	jns    800dee <memset+0x14>
		*p++ = c;

	return v;
  800e05:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e08:	c9                   	leave  
  800e09:	c3                   	ret    

00800e0a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
  800e0d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e1c:	eb 16                	jmp    800e34 <memcpy+0x2a>
		*d++ = *s++;
  800e1e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e21:	8d 50 01             	lea    0x1(%eax),%edx
  800e24:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e27:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e2a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e2d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e30:	8a 12                	mov    (%edx),%dl
  800e32:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e34:	8b 45 10             	mov    0x10(%ebp),%eax
  800e37:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e3a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e3d:	85 c0                	test   %eax,%eax
  800e3f:	75 dd                	jne    800e1e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e44:	c9                   	leave  
  800e45:	c3                   	ret    

00800e46 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e46:	55                   	push   %ebp
  800e47:	89 e5                	mov    %esp,%ebp
  800e49:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e4c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e5b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e5e:	73 50                	jae    800eb0 <memmove+0x6a>
  800e60:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e63:	8b 45 10             	mov    0x10(%ebp),%eax
  800e66:	01 d0                	add    %edx,%eax
  800e68:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e6b:	76 43                	jbe    800eb0 <memmove+0x6a>
		s += n;
  800e6d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e70:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e73:	8b 45 10             	mov    0x10(%ebp),%eax
  800e76:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e79:	eb 10                	jmp    800e8b <memmove+0x45>
			*--d = *--s;
  800e7b:	ff 4d f8             	decl   -0x8(%ebp)
  800e7e:	ff 4d fc             	decl   -0x4(%ebp)
  800e81:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e84:	8a 10                	mov    (%eax),%dl
  800e86:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e89:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e8e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e91:	89 55 10             	mov    %edx,0x10(%ebp)
  800e94:	85 c0                	test   %eax,%eax
  800e96:	75 e3                	jne    800e7b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e98:	eb 23                	jmp    800ebd <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e9a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9d:	8d 50 01             	lea    0x1(%eax),%edx
  800ea0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea6:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ea9:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eac:	8a 12                	mov    (%edx),%dl
  800eae:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800eb0:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb6:	89 55 10             	mov    %edx,0x10(%ebp)
  800eb9:	85 c0                	test   %eax,%eax
  800ebb:	75 dd                	jne    800e9a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ebd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec0:	c9                   	leave  
  800ec1:	c3                   	ret    

00800ec2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ec2:	55                   	push   %ebp
  800ec3:	89 e5                	mov    %esp,%ebp
  800ec5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ece:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ed4:	eb 2a                	jmp    800f00 <memcmp+0x3e>
		if (*s1 != *s2)
  800ed6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed9:	8a 10                	mov    (%eax),%dl
  800edb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ede:	8a 00                	mov    (%eax),%al
  800ee0:	38 c2                	cmp    %al,%dl
  800ee2:	74 16                	je     800efa <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800ee4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ee7:	8a 00                	mov    (%eax),%al
  800ee9:	0f b6 d0             	movzbl %al,%edx
  800eec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eef:	8a 00                	mov    (%eax),%al
  800ef1:	0f b6 c0             	movzbl %al,%eax
  800ef4:	29 c2                	sub    %eax,%edx
  800ef6:	89 d0                	mov    %edx,%eax
  800ef8:	eb 18                	jmp    800f12 <memcmp+0x50>
		s1++, s2++;
  800efa:	ff 45 fc             	incl   -0x4(%ebp)
  800efd:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f00:	8b 45 10             	mov    0x10(%ebp),%eax
  800f03:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f06:	89 55 10             	mov    %edx,0x10(%ebp)
  800f09:	85 c0                	test   %eax,%eax
  800f0b:	75 c9                	jne    800ed6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f0d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f12:	c9                   	leave  
  800f13:	c3                   	ret    

00800f14 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f14:	55                   	push   %ebp
  800f15:	89 e5                	mov    %esp,%ebp
  800f17:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f1a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f1d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f20:	01 d0                	add    %edx,%eax
  800f22:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f25:	eb 15                	jmp    800f3c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f27:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2a:	8a 00                	mov    (%eax),%al
  800f2c:	0f b6 d0             	movzbl %al,%edx
  800f2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f32:	0f b6 c0             	movzbl %al,%eax
  800f35:	39 c2                	cmp    %eax,%edx
  800f37:	74 0d                	je     800f46 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f39:	ff 45 08             	incl   0x8(%ebp)
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f42:	72 e3                	jb     800f27 <memfind+0x13>
  800f44:	eb 01                	jmp    800f47 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f46:	90                   	nop
	return (void *) s;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f4a:	c9                   	leave  
  800f4b:	c3                   	ret    

00800f4c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f4c:	55                   	push   %ebp
  800f4d:	89 e5                	mov    %esp,%ebp
  800f4f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f59:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f60:	eb 03                	jmp    800f65 <strtol+0x19>
		s++;
  800f62:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	3c 20                	cmp    $0x20,%al
  800f6c:	74 f4                	je     800f62 <strtol+0x16>
  800f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f71:	8a 00                	mov    (%eax),%al
  800f73:	3c 09                	cmp    $0x9,%al
  800f75:	74 eb                	je     800f62 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f77:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7a:	8a 00                	mov    (%eax),%al
  800f7c:	3c 2b                	cmp    $0x2b,%al
  800f7e:	75 05                	jne    800f85 <strtol+0x39>
		s++;
  800f80:	ff 45 08             	incl   0x8(%ebp)
  800f83:	eb 13                	jmp    800f98 <strtol+0x4c>
	else if (*s == '-')
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 2d                	cmp    $0x2d,%al
  800f8c:	75 0a                	jne    800f98 <strtol+0x4c>
		s++, neg = 1;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f98:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9c:	74 06                	je     800fa4 <strtol+0x58>
  800f9e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fa2:	75 20                	jne    800fc4 <strtol+0x78>
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa7:	8a 00                	mov    (%eax),%al
  800fa9:	3c 30                	cmp    $0x30,%al
  800fab:	75 17                	jne    800fc4 <strtol+0x78>
  800fad:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb0:	40                   	inc    %eax
  800fb1:	8a 00                	mov    (%eax),%al
  800fb3:	3c 78                	cmp    $0x78,%al
  800fb5:	75 0d                	jne    800fc4 <strtol+0x78>
		s += 2, base = 16;
  800fb7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fbb:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800fc2:	eb 28                	jmp    800fec <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800fc4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc8:	75 15                	jne    800fdf <strtol+0x93>
  800fca:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcd:	8a 00                	mov    (%eax),%al
  800fcf:	3c 30                	cmp    $0x30,%al
  800fd1:	75 0c                	jne    800fdf <strtol+0x93>
		s++, base = 8;
  800fd3:	ff 45 08             	incl   0x8(%ebp)
  800fd6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800fdd:	eb 0d                	jmp    800fec <strtol+0xa0>
	else if (base == 0)
  800fdf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fe3:	75 07                	jne    800fec <strtol+0xa0>
		base = 10;
  800fe5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	8a 00                	mov    (%eax),%al
  800ff1:	3c 2f                	cmp    $0x2f,%al
  800ff3:	7e 19                	jle    80100e <strtol+0xc2>
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 39                	cmp    $0x39,%al
  800ffc:	7f 10                	jg     80100e <strtol+0xc2>
			dig = *s - '0';
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	8a 00                	mov    (%eax),%al
  801003:	0f be c0             	movsbl %al,%eax
  801006:	83 e8 30             	sub    $0x30,%eax
  801009:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80100c:	eb 42                	jmp    801050 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	3c 60                	cmp    $0x60,%al
  801015:	7e 19                	jle    801030 <strtol+0xe4>
  801017:	8b 45 08             	mov    0x8(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	3c 7a                	cmp    $0x7a,%al
  80101e:	7f 10                	jg     801030 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801020:	8b 45 08             	mov    0x8(%ebp),%eax
  801023:	8a 00                	mov    (%eax),%al
  801025:	0f be c0             	movsbl %al,%eax
  801028:	83 e8 57             	sub    $0x57,%eax
  80102b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80102e:	eb 20                	jmp    801050 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801030:	8b 45 08             	mov    0x8(%ebp),%eax
  801033:	8a 00                	mov    (%eax),%al
  801035:	3c 40                	cmp    $0x40,%al
  801037:	7e 39                	jle    801072 <strtol+0x126>
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 5a                	cmp    $0x5a,%al
  801040:	7f 30                	jg     801072 <strtol+0x126>
			dig = *s - 'A' + 10;
  801042:	8b 45 08             	mov    0x8(%ebp),%eax
  801045:	8a 00                	mov    (%eax),%al
  801047:	0f be c0             	movsbl %al,%eax
  80104a:	83 e8 37             	sub    $0x37,%eax
  80104d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801053:	3b 45 10             	cmp    0x10(%ebp),%eax
  801056:	7d 19                	jge    801071 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801058:	ff 45 08             	incl   0x8(%ebp)
  80105b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80105e:	0f af 45 10          	imul   0x10(%ebp),%eax
  801062:	89 c2                	mov    %eax,%edx
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	01 d0                	add    %edx,%eax
  801069:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80106c:	e9 7b ff ff ff       	jmp    800fec <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801071:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801072:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801076:	74 08                	je     801080 <strtol+0x134>
		*endptr = (char *) s;
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	8b 55 08             	mov    0x8(%ebp),%edx
  80107e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801080:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801084:	74 07                	je     80108d <strtol+0x141>
  801086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801089:	f7 d8                	neg    %eax
  80108b:	eb 03                	jmp    801090 <strtol+0x144>
  80108d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801090:	c9                   	leave  
  801091:	c3                   	ret    

00801092 <ltostr>:

void
ltostr(long value, char *str)
{
  801092:	55                   	push   %ebp
  801093:	89 e5                	mov    %esp,%ebp
  801095:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801098:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80109f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010a6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010aa:	79 13                	jns    8010bf <ltostr+0x2d>
	{
		neg = 1;
  8010ac:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010b9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010bc:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010c7:	99                   	cltd   
  8010c8:	f7 f9                	idiv   %ecx
  8010ca:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8010cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d0:	8d 50 01             	lea    0x1(%eax),%edx
  8010d3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d6:	89 c2                	mov    %eax,%edx
  8010d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010db:	01 d0                	add    %edx,%eax
  8010dd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010e0:	83 c2 30             	add    $0x30,%edx
  8010e3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ed:	f7 e9                	imul   %ecx
  8010ef:	c1 fa 02             	sar    $0x2,%edx
  8010f2:	89 c8                	mov    %ecx,%eax
  8010f4:	c1 f8 1f             	sar    $0x1f,%eax
  8010f7:	29 c2                	sub    %eax,%edx
  8010f9:	89 d0                	mov    %edx,%eax
  8010fb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010fe:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801101:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801106:	f7 e9                	imul   %ecx
  801108:	c1 fa 02             	sar    $0x2,%edx
  80110b:	89 c8                	mov    %ecx,%eax
  80110d:	c1 f8 1f             	sar    $0x1f,%eax
  801110:	29 c2                	sub    %eax,%edx
  801112:	89 d0                	mov    %edx,%eax
  801114:	c1 e0 02             	shl    $0x2,%eax
  801117:	01 d0                	add    %edx,%eax
  801119:	01 c0                	add    %eax,%eax
  80111b:	29 c1                	sub    %eax,%ecx
  80111d:	89 ca                	mov    %ecx,%edx
  80111f:	85 d2                	test   %edx,%edx
  801121:	75 9c                	jne    8010bf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801123:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80112a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80112d:	48                   	dec    %eax
  80112e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801131:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801135:	74 3d                	je     801174 <ltostr+0xe2>
		start = 1 ;
  801137:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80113e:	eb 34                	jmp    801174 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801140:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801143:	8b 45 0c             	mov    0xc(%ebp),%eax
  801146:	01 d0                	add    %edx,%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80114d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801150:	8b 45 0c             	mov    0xc(%ebp),%eax
  801153:	01 c2                	add    %eax,%edx
  801155:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801158:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115b:	01 c8                	add    %ecx,%eax
  80115d:	8a 00                	mov    (%eax),%al
  80115f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801161:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801164:	8b 45 0c             	mov    0xc(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8a 45 eb             	mov    -0x15(%ebp),%al
  80116c:	88 02                	mov    %al,(%edx)
		start++ ;
  80116e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801171:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801177:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80117a:	7c c4                	jl     801140 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80117c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80117f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801182:	01 d0                	add    %edx,%eax
  801184:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801187:	90                   	nop
  801188:	c9                   	leave  
  801189:	c3                   	ret    

0080118a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80118a:	55                   	push   %ebp
  80118b:	89 e5                	mov    %esp,%ebp
  80118d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801190:	ff 75 08             	pushl  0x8(%ebp)
  801193:	e8 54 fa ff ff       	call   800bec <strlen>
  801198:	83 c4 04             	add    $0x4,%esp
  80119b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80119e:	ff 75 0c             	pushl  0xc(%ebp)
  8011a1:	e8 46 fa ff ff       	call   800bec <strlen>
  8011a6:	83 c4 04             	add    $0x4,%esp
  8011a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011ac:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011b3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ba:	eb 17                	jmp    8011d3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011bc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011bf:	8b 45 10             	mov    0x10(%ebp),%eax
  8011c2:	01 c2                	add    %eax,%edx
  8011c4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	01 c8                	add    %ecx,%eax
  8011cc:	8a 00                	mov    (%eax),%al
  8011ce:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8011d0:	ff 45 fc             	incl   -0x4(%ebp)
  8011d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011d6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8011d9:	7c e1                	jl     8011bc <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8011db:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8011e2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011e9:	eb 1f                	jmp    80120a <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011eb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011ee:	8d 50 01             	lea    0x1(%eax),%edx
  8011f1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011f4:	89 c2                	mov    %eax,%edx
  8011f6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f9:	01 c2                	add    %eax,%edx
  8011fb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 c8                	add    %ecx,%eax
  801203:	8a 00                	mov    (%eax),%al
  801205:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801207:	ff 45 f8             	incl   -0x8(%ebp)
  80120a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80120d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801210:	7c d9                	jl     8011eb <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801212:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801215:	8b 45 10             	mov    0x10(%ebp),%eax
  801218:	01 d0                	add    %edx,%eax
  80121a:	c6 00 00             	movb   $0x0,(%eax)
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801223:	8b 45 14             	mov    0x14(%ebp),%eax
  801226:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80122c:	8b 45 14             	mov    0x14(%ebp),%eax
  80122f:	8b 00                	mov    (%eax),%eax
  801231:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801238:	8b 45 10             	mov    0x10(%ebp),%eax
  80123b:	01 d0                	add    %edx,%eax
  80123d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801243:	eb 0c                	jmp    801251 <strsplit+0x31>
			*string++ = 0;
  801245:	8b 45 08             	mov    0x8(%ebp),%eax
  801248:	8d 50 01             	lea    0x1(%eax),%edx
  80124b:	89 55 08             	mov    %edx,0x8(%ebp)
  80124e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801251:	8b 45 08             	mov    0x8(%ebp),%eax
  801254:	8a 00                	mov    (%eax),%al
  801256:	84 c0                	test   %al,%al
  801258:	74 18                	je     801272 <strsplit+0x52>
  80125a:	8b 45 08             	mov    0x8(%ebp),%eax
  80125d:	8a 00                	mov    (%eax),%al
  80125f:	0f be c0             	movsbl %al,%eax
  801262:	50                   	push   %eax
  801263:	ff 75 0c             	pushl  0xc(%ebp)
  801266:	e8 13 fb ff ff       	call   800d7e <strchr>
  80126b:	83 c4 08             	add    $0x8,%esp
  80126e:	85 c0                	test   %eax,%eax
  801270:	75 d3                	jne    801245 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801272:	8b 45 08             	mov    0x8(%ebp),%eax
  801275:	8a 00                	mov    (%eax),%al
  801277:	84 c0                	test   %al,%al
  801279:	74 5a                	je     8012d5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	83 f8 0f             	cmp    $0xf,%eax
  801283:	75 07                	jne    80128c <strsplit+0x6c>
		{
			return 0;
  801285:	b8 00 00 00 00       	mov    $0x0,%eax
  80128a:	eb 66                	jmp    8012f2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80128c:	8b 45 14             	mov    0x14(%ebp),%eax
  80128f:	8b 00                	mov    (%eax),%eax
  801291:	8d 48 01             	lea    0x1(%eax),%ecx
  801294:	8b 55 14             	mov    0x14(%ebp),%edx
  801297:	89 0a                	mov    %ecx,(%edx)
  801299:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a3:	01 c2                	add    %eax,%edx
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012aa:	eb 03                	jmp    8012af <strsplit+0x8f>
			string++;
  8012ac:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012af:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b2:	8a 00                	mov    (%eax),%al
  8012b4:	84 c0                	test   %al,%al
  8012b6:	74 8b                	je     801243 <strsplit+0x23>
  8012b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bb:	8a 00                	mov    (%eax),%al
  8012bd:	0f be c0             	movsbl %al,%eax
  8012c0:	50                   	push   %eax
  8012c1:	ff 75 0c             	pushl  0xc(%ebp)
  8012c4:	e8 b5 fa ff ff       	call   800d7e <strchr>
  8012c9:	83 c4 08             	add    $0x8,%esp
  8012cc:	85 c0                	test   %eax,%eax
  8012ce:	74 dc                	je     8012ac <strsplit+0x8c>
			string++;
	}
  8012d0:	e9 6e ff ff ff       	jmp    801243 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8012d5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8012d6:	8b 45 14             	mov    0x14(%ebp),%eax
  8012d9:	8b 00                	mov    (%eax),%eax
  8012db:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e5:	01 d0                	add    %edx,%eax
  8012e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012ed:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012f2:	c9                   	leave  
  8012f3:	c3                   	ret    

008012f4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012f4:	55                   	push   %ebp
  8012f5:	89 e5                	mov    %esp,%ebp
  8012f7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012fa:	a1 04 40 80 00       	mov    0x804004,%eax
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 1f                	je     801322 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801303:	e8 1d 00 00 00       	call   801325 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801308:	83 ec 0c             	sub    $0xc,%esp
  80130b:	68 d0 3a 80 00       	push   $0x803ad0
  801310:	e8 55 f2 ff ff       	call   80056a <cprintf>
  801315:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801318:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80131f:	00 00 00 
	}
}
  801322:	90                   	nop
  801323:	c9                   	leave  
  801324:	c3                   	ret    

00801325 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801325:	55                   	push   %ebp
  801326:	89 e5                	mov    %esp,%ebp
  801328:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  80132b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801332:	00 00 00 
  801335:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80133c:	00 00 00 
  80133f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801346:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801349:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801350:	00 00 00 
  801353:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80135a:	00 00 00 
  80135d:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801364:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801367:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  80136e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801371:	c1 e8 0c             	shr    $0xc,%eax
  801374:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801379:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801380:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801383:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801388:	2d 00 10 00 00       	sub    $0x1000,%eax
  80138d:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  801392:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801399:	a1 20 41 80 00       	mov    0x804120,%eax
  80139e:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8013a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8013a5:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8013ac:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013b2:	01 d0                	add    %edx,%eax
  8013b4:	48                   	dec    %eax
  8013b5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013bb:	ba 00 00 00 00       	mov    $0x0,%edx
  8013c0:	f7 75 e4             	divl   -0x1c(%ebp)
  8013c3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013c6:	29 d0                	sub    %edx,%eax
  8013c8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8013cb:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8013d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8013d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013da:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013df:	83 ec 04             	sub    $0x4,%esp
  8013e2:	6a 07                	push   $0x7
  8013e4:	ff 75 e8             	pushl  -0x18(%ebp)
  8013e7:	50                   	push   %eax
  8013e8:	e8 3d 06 00 00       	call   801a2a <sys_allocate_chunk>
  8013ed:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013f0:	a1 20 41 80 00       	mov    0x804120,%eax
  8013f5:	83 ec 0c             	sub    $0xc,%esp
  8013f8:	50                   	push   %eax
  8013f9:	e8 b2 0c 00 00       	call   8020b0 <initialize_MemBlocksList>
  8013fe:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801401:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801406:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801409:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80140d:	0f 84 f3 00 00 00    	je     801506 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801413:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801417:	75 14                	jne    80142d <initialize_dyn_block_system+0x108>
  801419:	83 ec 04             	sub    $0x4,%esp
  80141c:	68 f5 3a 80 00       	push   $0x803af5
  801421:	6a 36                	push   $0x36
  801423:	68 13 3b 80 00       	push   $0x803b13
  801428:	e8 89 ee ff ff       	call   8002b6 <_panic>
  80142d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801430:	8b 00                	mov    (%eax),%eax
  801432:	85 c0                	test   %eax,%eax
  801434:	74 10                	je     801446 <initialize_dyn_block_system+0x121>
  801436:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801439:	8b 00                	mov    (%eax),%eax
  80143b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80143e:	8b 52 04             	mov    0x4(%edx),%edx
  801441:	89 50 04             	mov    %edx,0x4(%eax)
  801444:	eb 0b                	jmp    801451 <initialize_dyn_block_system+0x12c>
  801446:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801449:	8b 40 04             	mov    0x4(%eax),%eax
  80144c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801451:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801454:	8b 40 04             	mov    0x4(%eax),%eax
  801457:	85 c0                	test   %eax,%eax
  801459:	74 0f                	je     80146a <initialize_dyn_block_system+0x145>
  80145b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80145e:	8b 40 04             	mov    0x4(%eax),%eax
  801461:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801464:	8b 12                	mov    (%edx),%edx
  801466:	89 10                	mov    %edx,(%eax)
  801468:	eb 0a                	jmp    801474 <initialize_dyn_block_system+0x14f>
  80146a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80146d:	8b 00                	mov    (%eax),%eax
  80146f:	a3 48 41 80 00       	mov    %eax,0x804148
  801474:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801477:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80147d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801480:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801487:	a1 54 41 80 00       	mov    0x804154,%eax
  80148c:	48                   	dec    %eax
  80148d:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801492:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801495:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  80149c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80149f:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8014a6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014aa:	75 14                	jne    8014c0 <initialize_dyn_block_system+0x19b>
  8014ac:	83 ec 04             	sub    $0x4,%esp
  8014af:	68 20 3b 80 00       	push   $0x803b20
  8014b4:	6a 3e                	push   $0x3e
  8014b6:	68 13 3b 80 00       	push   $0x803b13
  8014bb:	e8 f6 ed ff ff       	call   8002b6 <_panic>
  8014c0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8014c6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014c9:	89 10                	mov    %edx,(%eax)
  8014cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014ce:	8b 00                	mov    (%eax),%eax
  8014d0:	85 c0                	test   %eax,%eax
  8014d2:	74 0d                	je     8014e1 <initialize_dyn_block_system+0x1bc>
  8014d4:	a1 38 41 80 00       	mov    0x804138,%eax
  8014d9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014dc:	89 50 04             	mov    %edx,0x4(%eax)
  8014df:	eb 08                	jmp    8014e9 <initialize_dyn_block_system+0x1c4>
  8014e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014e4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014ec:	a3 38 41 80 00       	mov    %eax,0x804138
  8014f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014f4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014fb:	a1 44 41 80 00       	mov    0x804144,%eax
  801500:	40                   	inc    %eax
  801501:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  801506:	90                   	nop
  801507:	c9                   	leave  
  801508:	c3                   	ret    

00801509 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801509:	55                   	push   %ebp
  80150a:	89 e5                	mov    %esp,%ebp
  80150c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  80150f:	e8 e0 fd ff ff       	call   8012f4 <InitializeUHeap>
		if (size == 0) return NULL ;
  801514:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801518:	75 07                	jne    801521 <malloc+0x18>
  80151a:	b8 00 00 00 00       	mov    $0x0,%eax
  80151f:	eb 7f                	jmp    8015a0 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801521:	e8 d2 08 00 00       	call   801df8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801526:	85 c0                	test   %eax,%eax
  801528:	74 71                	je     80159b <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  80152a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801531:	8b 55 08             	mov    0x8(%ebp),%edx
  801534:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801537:	01 d0                	add    %edx,%eax
  801539:	48                   	dec    %eax
  80153a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80153d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801540:	ba 00 00 00 00       	mov    $0x0,%edx
  801545:	f7 75 f4             	divl   -0xc(%ebp)
  801548:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80154b:	29 d0                	sub    %edx,%eax
  80154d:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801550:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801557:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80155e:	76 07                	jbe    801567 <malloc+0x5e>
					return NULL ;
  801560:	b8 00 00 00 00       	mov    $0x0,%eax
  801565:	eb 39                	jmp    8015a0 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801567:	83 ec 0c             	sub    $0xc,%esp
  80156a:	ff 75 08             	pushl  0x8(%ebp)
  80156d:	e8 e6 0d 00 00       	call   802358 <alloc_block_FF>
  801572:	83 c4 10             	add    $0x10,%esp
  801575:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801578:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80157c:	74 16                	je     801594 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  80157e:	83 ec 0c             	sub    $0xc,%esp
  801581:	ff 75 ec             	pushl  -0x14(%ebp)
  801584:	e8 37 0c 00 00       	call   8021c0 <insert_sorted_allocList>
  801589:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  80158c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80158f:	8b 40 08             	mov    0x8(%eax),%eax
  801592:	eb 0c                	jmp    8015a0 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801594:	b8 00 00 00 00       	mov    $0x0,%eax
  801599:	eb 05                	jmp    8015a0 <malloc+0x97>
				}
		}
	return 0;
  80159b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015a0:	c9                   	leave  
  8015a1:	c3                   	ret    

008015a2 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015a2:	55                   	push   %ebp
  8015a3:	89 e5                	mov    %esp,%ebp
  8015a5:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8015a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8015ae:	83 ec 08             	sub    $0x8,%esp
  8015b1:	ff 75 f4             	pushl  -0xc(%ebp)
  8015b4:	68 40 40 80 00       	push   $0x804040
  8015b9:	e8 cf 0b 00 00       	call   80218d <find_block>
  8015be:	83 c4 10             	add    $0x10,%esp
  8015c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8015c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8015ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8015cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d0:	8b 40 08             	mov    0x8(%eax),%eax
  8015d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8015d6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015da:	0f 84 a1 00 00 00    	je     801681 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8015e0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015e4:	75 17                	jne    8015fd <free+0x5b>
  8015e6:	83 ec 04             	sub    $0x4,%esp
  8015e9:	68 f5 3a 80 00       	push   $0x803af5
  8015ee:	68 80 00 00 00       	push   $0x80
  8015f3:	68 13 3b 80 00       	push   $0x803b13
  8015f8:	e8 b9 ec ff ff       	call   8002b6 <_panic>
  8015fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801600:	8b 00                	mov    (%eax),%eax
  801602:	85 c0                	test   %eax,%eax
  801604:	74 10                	je     801616 <free+0x74>
  801606:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801609:	8b 00                	mov    (%eax),%eax
  80160b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80160e:	8b 52 04             	mov    0x4(%edx),%edx
  801611:	89 50 04             	mov    %edx,0x4(%eax)
  801614:	eb 0b                	jmp    801621 <free+0x7f>
  801616:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801619:	8b 40 04             	mov    0x4(%eax),%eax
  80161c:	a3 44 40 80 00       	mov    %eax,0x804044
  801621:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801624:	8b 40 04             	mov    0x4(%eax),%eax
  801627:	85 c0                	test   %eax,%eax
  801629:	74 0f                	je     80163a <free+0x98>
  80162b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80162e:	8b 40 04             	mov    0x4(%eax),%eax
  801631:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801634:	8b 12                	mov    (%edx),%edx
  801636:	89 10                	mov    %edx,(%eax)
  801638:	eb 0a                	jmp    801644 <free+0xa2>
  80163a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163d:	8b 00                	mov    (%eax),%eax
  80163f:	a3 40 40 80 00       	mov    %eax,0x804040
  801644:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801647:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80164d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801650:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801657:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80165c:	48                   	dec    %eax
  80165d:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  801662:	83 ec 0c             	sub    $0xc,%esp
  801665:	ff 75 f0             	pushl  -0x10(%ebp)
  801668:	e8 29 12 00 00       	call   802896 <insert_sorted_with_merge_freeList>
  80166d:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801670:	83 ec 08             	sub    $0x8,%esp
  801673:	ff 75 ec             	pushl  -0x14(%ebp)
  801676:	ff 75 e8             	pushl  -0x18(%ebp)
  801679:	e8 74 03 00 00       	call   8019f2 <sys_free_user_mem>
  80167e:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801681:	90                   	nop
  801682:	c9                   	leave  
  801683:	c3                   	ret    

00801684 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801684:	55                   	push   %ebp
  801685:	89 e5                	mov    %esp,%ebp
  801687:	83 ec 38             	sub    $0x38,%esp
  80168a:	8b 45 10             	mov    0x10(%ebp),%eax
  80168d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801690:	e8 5f fc ff ff       	call   8012f4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801695:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801699:	75 0a                	jne    8016a5 <smalloc+0x21>
  80169b:	b8 00 00 00 00       	mov    $0x0,%eax
  8016a0:	e9 b2 00 00 00       	jmp    801757 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8016a5:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8016ac:	76 0a                	jbe    8016b8 <smalloc+0x34>
		return NULL;
  8016ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b3:	e9 9f 00 00 00       	jmp    801757 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016b8:	e8 3b 07 00 00       	call   801df8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016bd:	85 c0                	test   %eax,%eax
  8016bf:	0f 84 8d 00 00 00    	je     801752 <smalloc+0xce>
	struct MemBlock *b = NULL;
  8016c5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8016cc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8016d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d9:	01 d0                	add    %edx,%eax
  8016db:	48                   	dec    %eax
  8016dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8016df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016e2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016e7:	f7 75 f0             	divl   -0x10(%ebp)
  8016ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016ed:	29 d0                	sub    %edx,%eax
  8016ef:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8016f2:	83 ec 0c             	sub    $0xc,%esp
  8016f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8016f8:	e8 5b 0c 00 00       	call   802358 <alloc_block_FF>
  8016fd:	83 c4 10             	add    $0x10,%esp
  801700:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801703:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801707:	75 07                	jne    801710 <smalloc+0x8c>
			return NULL;
  801709:	b8 00 00 00 00       	mov    $0x0,%eax
  80170e:	eb 47                	jmp    801757 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801710:	83 ec 0c             	sub    $0xc,%esp
  801713:	ff 75 f4             	pushl  -0xc(%ebp)
  801716:	e8 a5 0a 00 00       	call   8021c0 <insert_sorted_allocList>
  80171b:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  80171e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801721:	8b 40 08             	mov    0x8(%eax),%eax
  801724:	89 c2                	mov    %eax,%edx
  801726:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80172a:	52                   	push   %edx
  80172b:	50                   	push   %eax
  80172c:	ff 75 0c             	pushl  0xc(%ebp)
  80172f:	ff 75 08             	pushl  0x8(%ebp)
  801732:	e8 46 04 00 00       	call   801b7d <sys_createSharedObject>
  801737:	83 c4 10             	add    $0x10,%esp
  80173a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  80173d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801741:	78 08                	js     80174b <smalloc+0xc7>
		return (void *)b->sva;
  801743:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801746:	8b 40 08             	mov    0x8(%eax),%eax
  801749:	eb 0c                	jmp    801757 <smalloc+0xd3>
		}else{
		return NULL;
  80174b:	b8 00 00 00 00       	mov    $0x0,%eax
  801750:	eb 05                	jmp    801757 <smalloc+0xd3>
			}

	}return NULL;
  801752:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
  80175c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80175f:	e8 90 fb ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801764:	e8 8f 06 00 00       	call   801df8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801769:	85 c0                	test   %eax,%eax
  80176b:	0f 84 ad 00 00 00    	je     80181e <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801771:	83 ec 08             	sub    $0x8,%esp
  801774:	ff 75 0c             	pushl  0xc(%ebp)
  801777:	ff 75 08             	pushl  0x8(%ebp)
  80177a:	e8 28 04 00 00       	call   801ba7 <sys_getSizeOfSharedObject>
  80177f:	83 c4 10             	add    $0x10,%esp
  801782:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801785:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801789:	79 0a                	jns    801795 <sget+0x3c>
    {
    	return NULL;
  80178b:	b8 00 00 00 00       	mov    $0x0,%eax
  801790:	e9 8e 00 00 00       	jmp    801823 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801795:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  80179c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a9:	01 d0                	add    %edx,%eax
  8017ab:	48                   	dec    %eax
  8017ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b2:	ba 00 00 00 00       	mov    $0x0,%edx
  8017b7:	f7 75 ec             	divl   -0x14(%ebp)
  8017ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017bd:	29 d0                	sub    %edx,%eax
  8017bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8017c2:	83 ec 0c             	sub    $0xc,%esp
  8017c5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017c8:	e8 8b 0b 00 00       	call   802358 <alloc_block_FF>
  8017cd:	83 c4 10             	add    $0x10,%esp
  8017d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8017d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8017d7:	75 07                	jne    8017e0 <sget+0x87>
				return NULL;
  8017d9:	b8 00 00 00 00       	mov    $0x0,%eax
  8017de:	eb 43                	jmp    801823 <sget+0xca>
			}
			insert_sorted_allocList(b);
  8017e0:	83 ec 0c             	sub    $0xc,%esp
  8017e3:	ff 75 f0             	pushl  -0x10(%ebp)
  8017e6:	e8 d5 09 00 00       	call   8021c0 <insert_sorted_allocList>
  8017eb:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8017ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017f1:	8b 40 08             	mov    0x8(%eax),%eax
  8017f4:	83 ec 04             	sub    $0x4,%esp
  8017f7:	50                   	push   %eax
  8017f8:	ff 75 0c             	pushl  0xc(%ebp)
  8017fb:	ff 75 08             	pushl  0x8(%ebp)
  8017fe:	e8 c1 03 00 00       	call   801bc4 <sys_getSharedObject>
  801803:	83 c4 10             	add    $0x10,%esp
  801806:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801809:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80180d:	78 08                	js     801817 <sget+0xbe>
			return (void *)b->sva;
  80180f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801812:	8b 40 08             	mov    0x8(%eax),%eax
  801815:	eb 0c                	jmp    801823 <sget+0xca>
			}else{
			return NULL;
  801817:	b8 00 00 00 00       	mov    $0x0,%eax
  80181c:	eb 05                	jmp    801823 <sget+0xca>
			}
    }}return NULL;
  80181e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
  801828:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80182b:	e8 c4 fa ff ff       	call   8012f4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801830:	83 ec 04             	sub    $0x4,%esp
  801833:	68 44 3b 80 00       	push   $0x803b44
  801838:	68 03 01 00 00       	push   $0x103
  80183d:	68 13 3b 80 00       	push   $0x803b13
  801842:	e8 6f ea ff ff       	call   8002b6 <_panic>

00801847 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801847:	55                   	push   %ebp
  801848:	89 e5                	mov    %esp,%ebp
  80184a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80184d:	83 ec 04             	sub    $0x4,%esp
  801850:	68 6c 3b 80 00       	push   $0x803b6c
  801855:	68 17 01 00 00       	push   $0x117
  80185a:	68 13 3b 80 00       	push   $0x803b13
  80185f:	e8 52 ea ff ff       	call   8002b6 <_panic>

00801864 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801864:	55                   	push   %ebp
  801865:	89 e5                	mov    %esp,%ebp
  801867:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80186a:	83 ec 04             	sub    $0x4,%esp
  80186d:	68 90 3b 80 00       	push   $0x803b90
  801872:	68 22 01 00 00       	push   $0x122
  801877:	68 13 3b 80 00       	push   $0x803b13
  80187c:	e8 35 ea ff ff       	call   8002b6 <_panic>

00801881 <shrink>:

}
void shrink(uint32 newSize)
{
  801881:	55                   	push   %ebp
  801882:	89 e5                	mov    %esp,%ebp
  801884:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801887:	83 ec 04             	sub    $0x4,%esp
  80188a:	68 90 3b 80 00       	push   $0x803b90
  80188f:	68 27 01 00 00       	push   $0x127
  801894:	68 13 3b 80 00       	push   $0x803b13
  801899:	e8 18 ea ff ff       	call   8002b6 <_panic>

0080189e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80189e:	55                   	push   %ebp
  80189f:	89 e5                	mov    %esp,%ebp
  8018a1:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018a4:	83 ec 04             	sub    $0x4,%esp
  8018a7:	68 90 3b 80 00       	push   $0x803b90
  8018ac:	68 2c 01 00 00       	push   $0x12c
  8018b1:	68 13 3b 80 00       	push   $0x803b13
  8018b6:	e8 fb e9 ff ff       	call   8002b6 <_panic>

008018bb <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018bb:	55                   	push   %ebp
  8018bc:	89 e5                	mov    %esp,%ebp
  8018be:	57                   	push   %edi
  8018bf:	56                   	push   %esi
  8018c0:	53                   	push   %ebx
  8018c1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018ca:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018d0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8018d3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8018d6:	cd 30                	int    $0x30
  8018d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8018db:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8018de:	83 c4 10             	add    $0x10,%esp
  8018e1:	5b                   	pop    %ebx
  8018e2:	5e                   	pop    %esi
  8018e3:	5f                   	pop    %edi
  8018e4:	5d                   	pop    %ebp
  8018e5:	c3                   	ret    

008018e6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
  8018e9:	83 ec 04             	sub    $0x4,%esp
  8018ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8018ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018f2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	52                   	push   %edx
  8018fe:	ff 75 0c             	pushl  0xc(%ebp)
  801901:	50                   	push   %eax
  801902:	6a 00                	push   $0x0
  801904:	e8 b2 ff ff ff       	call   8018bb <syscall>
  801909:	83 c4 18             	add    $0x18,%esp
}
  80190c:	90                   	nop
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_cgetc>:

int
sys_cgetc(void)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 01                	push   $0x1
  80191e:	e8 98 ff ff ff       	call   8018bb <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80192b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	52                   	push   %edx
  801938:	50                   	push   %eax
  801939:	6a 05                	push   $0x5
  80193b:	e8 7b ff ff ff       	call   8018bb <syscall>
  801940:	83 c4 18             	add    $0x18,%esp
}
  801943:	c9                   	leave  
  801944:	c3                   	ret    

00801945 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801945:	55                   	push   %ebp
  801946:	89 e5                	mov    %esp,%ebp
  801948:	56                   	push   %esi
  801949:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80194a:	8b 75 18             	mov    0x18(%ebp),%esi
  80194d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801950:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801953:	8b 55 0c             	mov    0xc(%ebp),%edx
  801956:	8b 45 08             	mov    0x8(%ebp),%eax
  801959:	56                   	push   %esi
  80195a:	53                   	push   %ebx
  80195b:	51                   	push   %ecx
  80195c:	52                   	push   %edx
  80195d:	50                   	push   %eax
  80195e:	6a 06                	push   $0x6
  801960:	e8 56 ff ff ff       	call   8018bb <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
}
  801968:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80196b:	5b                   	pop    %ebx
  80196c:	5e                   	pop    %esi
  80196d:	5d                   	pop    %ebp
  80196e:	c3                   	ret    

0080196f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801972:	8b 55 0c             	mov    0xc(%ebp),%edx
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	52                   	push   %edx
  80197f:	50                   	push   %eax
  801980:	6a 07                	push   $0x7
  801982:	e8 34 ff ff ff       	call   8018bb <syscall>
  801987:	83 c4 18             	add    $0x18,%esp
}
  80198a:	c9                   	leave  
  80198b:	c3                   	ret    

0080198c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80198c:	55                   	push   %ebp
  80198d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80198f:	6a 00                	push   $0x0
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	ff 75 0c             	pushl  0xc(%ebp)
  801998:	ff 75 08             	pushl  0x8(%ebp)
  80199b:	6a 08                	push   $0x8
  80199d:	e8 19 ff ff ff       	call   8018bb <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019aa:	6a 00                	push   $0x0
  8019ac:	6a 00                	push   $0x0
  8019ae:	6a 00                	push   $0x0
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 09                	push   $0x9
  8019b6:	e8 00 ff ff ff       	call   8018bb <syscall>
  8019bb:	83 c4 18             	add    $0x18,%esp
}
  8019be:	c9                   	leave  
  8019bf:	c3                   	ret    

008019c0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	6a 00                	push   $0x0
  8019c9:	6a 00                	push   $0x0
  8019cb:	6a 00                	push   $0x0
  8019cd:	6a 0a                	push   $0xa
  8019cf:	e8 e7 fe ff ff       	call   8018bb <syscall>
  8019d4:	83 c4 18             	add    $0x18,%esp
}
  8019d7:	c9                   	leave  
  8019d8:	c3                   	ret    

008019d9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8019d9:	55                   	push   %ebp
  8019da:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8019dc:	6a 00                	push   $0x0
  8019de:	6a 00                	push   $0x0
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	6a 0b                	push   $0xb
  8019e8:	e8 ce fe ff ff       	call   8018bb <syscall>
  8019ed:	83 c4 18             	add    $0x18,%esp
}
  8019f0:	c9                   	leave  
  8019f1:	c3                   	ret    

008019f2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019f2:	55                   	push   %ebp
  8019f3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	ff 75 0c             	pushl  0xc(%ebp)
  8019fe:	ff 75 08             	pushl  0x8(%ebp)
  801a01:	6a 0f                	push   $0xf
  801a03:	e8 b3 fe ff ff       	call   8018bb <syscall>
  801a08:	83 c4 18             	add    $0x18,%esp
	return;
  801a0b:	90                   	nop
}
  801a0c:	c9                   	leave  
  801a0d:	c3                   	ret    

00801a0e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a0e:	55                   	push   %ebp
  801a0f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	ff 75 0c             	pushl  0xc(%ebp)
  801a1a:	ff 75 08             	pushl  0x8(%ebp)
  801a1d:	6a 10                	push   $0x10
  801a1f:	e8 97 fe ff ff       	call   8018bb <syscall>
  801a24:	83 c4 18             	add    $0x18,%esp
	return ;
  801a27:	90                   	nop
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	ff 75 10             	pushl  0x10(%ebp)
  801a34:	ff 75 0c             	pushl  0xc(%ebp)
  801a37:	ff 75 08             	pushl  0x8(%ebp)
  801a3a:	6a 11                	push   $0x11
  801a3c:	e8 7a fe ff ff       	call   8018bb <syscall>
  801a41:	83 c4 18             	add    $0x18,%esp
	return ;
  801a44:	90                   	nop
}
  801a45:	c9                   	leave  
  801a46:	c3                   	ret    

00801a47 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a47:	55                   	push   %ebp
  801a48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 0c                	push   $0xc
  801a56:	e8 60 fe ff ff       	call   8018bb <syscall>
  801a5b:	83 c4 18             	add    $0x18,%esp
}
  801a5e:	c9                   	leave  
  801a5f:	c3                   	ret    

00801a60 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a60:	55                   	push   %ebp
  801a61:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a63:	6a 00                	push   $0x0
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	ff 75 08             	pushl  0x8(%ebp)
  801a6e:	6a 0d                	push   $0xd
  801a70:	e8 46 fe ff ff       	call   8018bb <syscall>
  801a75:	83 c4 18             	add    $0x18,%esp
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 0e                	push   $0xe
  801a89:	e8 2d fe ff ff       	call   8018bb <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	90                   	nop
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 13                	push   $0x13
  801aa3:	e8 13 fe ff ff       	call   8018bb <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	90                   	nop
  801aac:	c9                   	leave  
  801aad:	c3                   	ret    

00801aae <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801aae:	55                   	push   %ebp
  801aaf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ab1:	6a 00                	push   $0x0
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 14                	push   $0x14
  801abd:	e8 f9 fd ff ff       	call   8018bb <syscall>
  801ac2:	83 c4 18             	add    $0x18,%esp
}
  801ac5:	90                   	nop
  801ac6:	c9                   	leave  
  801ac7:	c3                   	ret    

00801ac8 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ac8:	55                   	push   %ebp
  801ac9:	89 e5                	mov    %esp,%ebp
  801acb:	83 ec 04             	sub    $0x4,%esp
  801ace:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801ad4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 00                	push   $0x0
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	50                   	push   %eax
  801ae1:	6a 15                	push   $0x15
  801ae3:	e8 d3 fd ff ff       	call   8018bb <syscall>
  801ae8:	83 c4 18             	add    $0x18,%esp
}
  801aeb:	90                   	nop
  801aec:	c9                   	leave  
  801aed:	c3                   	ret    

00801aee <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aee:	55                   	push   %ebp
  801aef:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 16                	push   $0x16
  801afd:	e8 b9 fd ff ff       	call   8018bb <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
}
  801b05:	90                   	nop
  801b06:	c9                   	leave  
  801b07:	c3                   	ret    

00801b08 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b08:	55                   	push   %ebp
  801b09:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0e:	6a 00                	push   $0x0
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	ff 75 0c             	pushl  0xc(%ebp)
  801b17:	50                   	push   %eax
  801b18:	6a 17                	push   $0x17
  801b1a:	e8 9c fd ff ff       	call   8018bb <syscall>
  801b1f:	83 c4 18             	add    $0x18,%esp
}
  801b22:	c9                   	leave  
  801b23:	c3                   	ret    

00801b24 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b24:	55                   	push   %ebp
  801b25:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b27:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	52                   	push   %edx
  801b34:	50                   	push   %eax
  801b35:	6a 1a                	push   $0x1a
  801b37:	e8 7f fd ff ff       	call   8018bb <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
}
  801b3f:	c9                   	leave  
  801b40:	c3                   	ret    

00801b41 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b41:	55                   	push   %ebp
  801b42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b44:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b47:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	52                   	push   %edx
  801b51:	50                   	push   %eax
  801b52:	6a 18                	push   $0x18
  801b54:	e8 62 fd ff ff       	call   8018bb <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	90                   	nop
  801b5d:	c9                   	leave  
  801b5e:	c3                   	ret    

00801b5f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b5f:	55                   	push   %ebp
  801b60:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b62:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b65:	8b 45 08             	mov    0x8(%ebp),%eax
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	52                   	push   %edx
  801b6f:	50                   	push   %eax
  801b70:	6a 19                	push   $0x19
  801b72:	e8 44 fd ff ff       	call   8018bb <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
}
  801b7a:	90                   	nop
  801b7b:	c9                   	leave  
  801b7c:	c3                   	ret    

00801b7d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b7d:	55                   	push   %ebp
  801b7e:	89 e5                	mov    %esp,%ebp
  801b80:	83 ec 04             	sub    $0x4,%esp
  801b83:	8b 45 10             	mov    0x10(%ebp),%eax
  801b86:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b89:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b8c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	6a 00                	push   $0x0
  801b95:	51                   	push   %ecx
  801b96:	52                   	push   %edx
  801b97:	ff 75 0c             	pushl  0xc(%ebp)
  801b9a:	50                   	push   %eax
  801b9b:	6a 1b                	push   $0x1b
  801b9d:	e8 19 fd ff ff       	call   8018bb <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801baa:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bad:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	52                   	push   %edx
  801bb7:	50                   	push   %eax
  801bb8:	6a 1c                	push   $0x1c
  801bba:	e8 fc fc ff ff       	call   8018bb <syscall>
  801bbf:	83 c4 18             	add    $0x18,%esp
}
  801bc2:	c9                   	leave  
  801bc3:	c3                   	ret    

00801bc4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bc4:	55                   	push   %ebp
  801bc5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bc7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd0:	6a 00                	push   $0x0
  801bd2:	6a 00                	push   $0x0
  801bd4:	51                   	push   %ecx
  801bd5:	52                   	push   %edx
  801bd6:	50                   	push   %eax
  801bd7:	6a 1d                	push   $0x1d
  801bd9:	e8 dd fc ff ff       	call   8018bb <syscall>
  801bde:	83 c4 18             	add    $0x18,%esp
}
  801be1:	c9                   	leave  
  801be2:	c3                   	ret    

00801be3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801be3:	55                   	push   %ebp
  801be4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801be6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bec:	6a 00                	push   $0x0
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	52                   	push   %edx
  801bf3:	50                   	push   %eax
  801bf4:	6a 1e                	push   $0x1e
  801bf6:	e8 c0 fc ff ff       	call   8018bb <syscall>
  801bfb:	83 c4 18             	add    $0x18,%esp
}
  801bfe:	c9                   	leave  
  801bff:	c3                   	ret    

00801c00 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c00:	55                   	push   %ebp
  801c01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	6a 1f                	push   $0x1f
  801c0f:	e8 a7 fc ff ff       	call   8018bb <syscall>
  801c14:	83 c4 18             	add    $0x18,%esp
}
  801c17:	c9                   	leave  
  801c18:	c3                   	ret    

00801c19 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c19:	55                   	push   %ebp
  801c1a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	6a 00                	push   $0x0
  801c21:	ff 75 14             	pushl  0x14(%ebp)
  801c24:	ff 75 10             	pushl  0x10(%ebp)
  801c27:	ff 75 0c             	pushl  0xc(%ebp)
  801c2a:	50                   	push   %eax
  801c2b:	6a 20                	push   $0x20
  801c2d:	e8 89 fc ff ff       	call   8018bb <syscall>
  801c32:	83 c4 18             	add    $0x18,%esp
}
  801c35:	c9                   	leave  
  801c36:	c3                   	ret    

00801c37 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c37:	55                   	push   %ebp
  801c38:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c3d:	6a 00                	push   $0x0
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	50                   	push   %eax
  801c46:	6a 21                	push   $0x21
  801c48:	e8 6e fc ff ff       	call   8018bb <syscall>
  801c4d:	83 c4 18             	add    $0x18,%esp
}
  801c50:	90                   	nop
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c56:	8b 45 08             	mov    0x8(%ebp),%eax
  801c59:	6a 00                	push   $0x0
  801c5b:	6a 00                	push   $0x0
  801c5d:	6a 00                	push   $0x0
  801c5f:	6a 00                	push   $0x0
  801c61:	50                   	push   %eax
  801c62:	6a 22                	push   $0x22
  801c64:	e8 52 fc ff ff       	call   8018bb <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
}
  801c6c:	c9                   	leave  
  801c6d:	c3                   	ret    

00801c6e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c6e:	55                   	push   %ebp
  801c6f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 02                	push   $0x2
  801c7d:	e8 39 fc ff ff       	call   8018bb <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
}
  801c85:	c9                   	leave  
  801c86:	c3                   	ret    

00801c87 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c87:	55                   	push   %ebp
  801c88:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	6a 03                	push   $0x3
  801c96:	e8 20 fc ff ff       	call   8018bb <syscall>
  801c9b:	83 c4 18             	add    $0x18,%esp
}
  801c9e:	c9                   	leave  
  801c9f:	c3                   	ret    

00801ca0 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ca0:	55                   	push   %ebp
  801ca1:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 04                	push   $0x4
  801caf:	e8 07 fc ff ff       	call   8018bb <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
}
  801cb7:	c9                   	leave  
  801cb8:	c3                   	ret    

00801cb9 <sys_exit_env>:


void sys_exit_env(void)
{
  801cb9:	55                   	push   %ebp
  801cba:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	6a 00                	push   $0x0
  801cc6:	6a 23                	push   $0x23
  801cc8:	e8 ee fb ff ff       	call   8018bb <syscall>
  801ccd:	83 c4 18             	add    $0x18,%esp
}
  801cd0:	90                   	nop
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
  801cd6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801cd9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801cdc:	8d 50 04             	lea    0x4(%eax),%edx
  801cdf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ce2:	6a 00                	push   $0x0
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	52                   	push   %edx
  801ce9:	50                   	push   %eax
  801cea:	6a 24                	push   $0x24
  801cec:	e8 ca fb ff ff       	call   8018bb <syscall>
  801cf1:	83 c4 18             	add    $0x18,%esp
	return result;
  801cf4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cf7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cfa:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cfd:	89 01                	mov    %eax,(%ecx)
  801cff:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d02:	8b 45 08             	mov    0x8(%ebp),%eax
  801d05:	c9                   	leave  
  801d06:	c2 04 00             	ret    $0x4

00801d09 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	ff 75 10             	pushl  0x10(%ebp)
  801d13:	ff 75 0c             	pushl  0xc(%ebp)
  801d16:	ff 75 08             	pushl  0x8(%ebp)
  801d19:	6a 12                	push   $0x12
  801d1b:	e8 9b fb ff ff       	call   8018bb <syscall>
  801d20:	83 c4 18             	add    $0x18,%esp
	return ;
  801d23:	90                   	nop
}
  801d24:	c9                   	leave  
  801d25:	c3                   	ret    

00801d26 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d26:	55                   	push   %ebp
  801d27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 00                	push   $0x0
  801d31:	6a 00                	push   $0x0
  801d33:	6a 25                	push   $0x25
  801d35:	e8 81 fb ff ff       	call   8018bb <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
  801d42:	83 ec 04             	sub    $0x4,%esp
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d4b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 00                	push   $0x0
  801d57:	50                   	push   %eax
  801d58:	6a 26                	push   $0x26
  801d5a:	e8 5c fb ff ff       	call   8018bb <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d62:	90                   	nop
}
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <rsttst>:
void rsttst()
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	6a 00                	push   $0x0
  801d72:	6a 28                	push   $0x28
  801d74:	e8 42 fb ff ff       	call   8018bb <syscall>
  801d79:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7c:	90                   	nop
}
  801d7d:	c9                   	leave  
  801d7e:	c3                   	ret    

00801d7f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d7f:	55                   	push   %ebp
  801d80:	89 e5                	mov    %esp,%ebp
  801d82:	83 ec 04             	sub    $0x4,%esp
  801d85:	8b 45 14             	mov    0x14(%ebp),%eax
  801d88:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d8b:	8b 55 18             	mov    0x18(%ebp),%edx
  801d8e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d92:	52                   	push   %edx
  801d93:	50                   	push   %eax
  801d94:	ff 75 10             	pushl  0x10(%ebp)
  801d97:	ff 75 0c             	pushl  0xc(%ebp)
  801d9a:	ff 75 08             	pushl  0x8(%ebp)
  801d9d:	6a 27                	push   $0x27
  801d9f:	e8 17 fb ff ff       	call   8018bb <syscall>
  801da4:	83 c4 18             	add    $0x18,%esp
	return ;
  801da7:	90                   	nop
}
  801da8:	c9                   	leave  
  801da9:	c3                   	ret    

00801daa <chktst>:
void chktst(uint32 n)
{
  801daa:	55                   	push   %ebp
  801dab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801dad:	6a 00                	push   $0x0
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	ff 75 08             	pushl  0x8(%ebp)
  801db8:	6a 29                	push   $0x29
  801dba:	e8 fc fa ff ff       	call   8018bb <syscall>
  801dbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc2:	90                   	nop
}
  801dc3:	c9                   	leave  
  801dc4:	c3                   	ret    

00801dc5 <inctst>:

void inctst()
{
  801dc5:	55                   	push   %ebp
  801dc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dc8:	6a 00                	push   $0x0
  801dca:	6a 00                	push   $0x0
  801dcc:	6a 00                	push   $0x0
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 2a                	push   $0x2a
  801dd4:	e8 e2 fa ff ff       	call   8018bb <syscall>
  801dd9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ddc:	90                   	nop
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <gettst>:
uint32 gettst()
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	6a 00                	push   $0x0
  801dec:	6a 2b                	push   $0x2b
  801dee:	e8 c8 fa ff ff       	call   8018bb <syscall>
  801df3:	83 c4 18             	add    $0x18,%esp
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
  801dfb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dfe:	6a 00                	push   $0x0
  801e00:	6a 00                	push   $0x0
  801e02:	6a 00                	push   $0x0
  801e04:	6a 00                	push   $0x0
  801e06:	6a 00                	push   $0x0
  801e08:	6a 2c                	push   $0x2c
  801e0a:	e8 ac fa ff ff       	call   8018bb <syscall>
  801e0f:	83 c4 18             	add    $0x18,%esp
  801e12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e15:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e19:	75 07                	jne    801e22 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e1b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e20:	eb 05                	jmp    801e27 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e22:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
  801e2c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 2c                	push   $0x2c
  801e3b:	e8 7b fa ff ff       	call   8018bb <syscall>
  801e40:	83 c4 18             	add    $0x18,%esp
  801e43:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e46:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e4a:	75 07                	jne    801e53 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e4c:	b8 01 00 00 00       	mov    $0x1,%eax
  801e51:	eb 05                	jmp    801e58 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e53:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
  801e5d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e60:	6a 00                	push   $0x0
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 2c                	push   $0x2c
  801e6c:	e8 4a fa ff ff       	call   8018bb <syscall>
  801e71:	83 c4 18             	add    $0x18,%esp
  801e74:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e77:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e7b:	75 07                	jne    801e84 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801e82:	eb 05                	jmp    801e89 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e84:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e89:	c9                   	leave  
  801e8a:	c3                   	ret    

00801e8b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e8b:	55                   	push   %ebp
  801e8c:	89 e5                	mov    %esp,%ebp
  801e8e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e91:	6a 00                	push   $0x0
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 2c                	push   $0x2c
  801e9d:	e8 19 fa ff ff       	call   8018bb <syscall>
  801ea2:	83 c4 18             	add    $0x18,%esp
  801ea5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ea8:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801eac:	75 07                	jne    801eb5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801eae:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb3:	eb 05                	jmp    801eba <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801eb5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eba:	c9                   	leave  
  801ebb:	c3                   	ret    

00801ebc <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ebc:	55                   	push   %ebp
  801ebd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ebf:	6a 00                	push   $0x0
  801ec1:	6a 00                	push   $0x0
  801ec3:	6a 00                	push   $0x0
  801ec5:	6a 00                	push   $0x0
  801ec7:	ff 75 08             	pushl  0x8(%ebp)
  801eca:	6a 2d                	push   $0x2d
  801ecc:	e8 ea f9 ff ff       	call   8018bb <syscall>
  801ed1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ed4:	90                   	nop
}
  801ed5:	c9                   	leave  
  801ed6:	c3                   	ret    

00801ed7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ed7:	55                   	push   %ebp
  801ed8:	89 e5                	mov    %esp,%ebp
  801eda:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801edb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801ede:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ee1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ee7:	6a 00                	push   $0x0
  801ee9:	53                   	push   %ebx
  801eea:	51                   	push   %ecx
  801eeb:	52                   	push   %edx
  801eec:	50                   	push   %eax
  801eed:	6a 2e                	push   $0x2e
  801eef:	e8 c7 f9 ff ff       	call   8018bb <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
}
  801ef7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f02:	8b 45 08             	mov    0x8(%ebp),%eax
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	52                   	push   %edx
  801f0c:	50                   	push   %eax
  801f0d:	6a 2f                	push   $0x2f
  801f0f:	e8 a7 f9 ff ff       	call   8018bb <syscall>
  801f14:	83 c4 18             	add    $0x18,%esp
}
  801f17:	c9                   	leave  
  801f18:	c3                   	ret    

00801f19 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f19:	55                   	push   %ebp
  801f1a:	89 e5                	mov    %esp,%ebp
  801f1c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f1f:	83 ec 0c             	sub    $0xc,%esp
  801f22:	68 a0 3b 80 00       	push   $0x803ba0
  801f27:	e8 3e e6 ff ff       	call   80056a <cprintf>
  801f2c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f2f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f36:	83 ec 0c             	sub    $0xc,%esp
  801f39:	68 cc 3b 80 00       	push   $0x803bcc
  801f3e:	e8 27 e6 ff ff       	call   80056a <cprintf>
  801f43:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f46:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f4a:	a1 38 41 80 00       	mov    0x804138,%eax
  801f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f52:	eb 56                	jmp    801faa <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f54:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f58:	74 1c                	je     801f76 <print_mem_block_lists+0x5d>
  801f5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5d:	8b 50 08             	mov    0x8(%eax),%edx
  801f60:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f63:	8b 48 08             	mov    0x8(%eax),%ecx
  801f66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f69:	8b 40 0c             	mov    0xc(%eax),%eax
  801f6c:	01 c8                	add    %ecx,%eax
  801f6e:	39 c2                	cmp    %eax,%edx
  801f70:	73 04                	jae    801f76 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f72:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f79:	8b 50 08             	mov    0x8(%eax),%edx
  801f7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f7f:	8b 40 0c             	mov    0xc(%eax),%eax
  801f82:	01 c2                	add    %eax,%edx
  801f84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f87:	8b 40 08             	mov    0x8(%eax),%eax
  801f8a:	83 ec 04             	sub    $0x4,%esp
  801f8d:	52                   	push   %edx
  801f8e:	50                   	push   %eax
  801f8f:	68 e1 3b 80 00       	push   $0x803be1
  801f94:	e8 d1 e5 ff ff       	call   80056a <cprintf>
  801f99:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fa2:	a1 40 41 80 00       	mov    0x804140,%eax
  801fa7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801faa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fae:	74 07                	je     801fb7 <print_mem_block_lists+0x9e>
  801fb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb3:	8b 00                	mov    (%eax),%eax
  801fb5:	eb 05                	jmp    801fbc <print_mem_block_lists+0xa3>
  801fb7:	b8 00 00 00 00       	mov    $0x0,%eax
  801fbc:	a3 40 41 80 00       	mov    %eax,0x804140
  801fc1:	a1 40 41 80 00       	mov    0x804140,%eax
  801fc6:	85 c0                	test   %eax,%eax
  801fc8:	75 8a                	jne    801f54 <print_mem_block_lists+0x3b>
  801fca:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fce:	75 84                	jne    801f54 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801fd0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801fd4:	75 10                	jne    801fe6 <print_mem_block_lists+0xcd>
  801fd6:	83 ec 0c             	sub    $0xc,%esp
  801fd9:	68 f0 3b 80 00       	push   $0x803bf0
  801fde:	e8 87 e5 ff ff       	call   80056a <cprintf>
  801fe3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fe6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fed:	83 ec 0c             	sub    $0xc,%esp
  801ff0:	68 14 3c 80 00       	push   $0x803c14
  801ff5:	e8 70 e5 ff ff       	call   80056a <cprintf>
  801ffa:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801ffd:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802001:	a1 40 40 80 00       	mov    0x804040,%eax
  802006:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802009:	eb 56                	jmp    802061 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80200b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80200f:	74 1c                	je     80202d <print_mem_block_lists+0x114>
  802011:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802014:	8b 50 08             	mov    0x8(%eax),%edx
  802017:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201a:	8b 48 08             	mov    0x8(%eax),%ecx
  80201d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802020:	8b 40 0c             	mov    0xc(%eax),%eax
  802023:	01 c8                	add    %ecx,%eax
  802025:	39 c2                	cmp    %eax,%edx
  802027:	73 04                	jae    80202d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802029:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80202d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802030:	8b 50 08             	mov    0x8(%eax),%edx
  802033:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802036:	8b 40 0c             	mov    0xc(%eax),%eax
  802039:	01 c2                	add    %eax,%edx
  80203b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203e:	8b 40 08             	mov    0x8(%eax),%eax
  802041:	83 ec 04             	sub    $0x4,%esp
  802044:	52                   	push   %edx
  802045:	50                   	push   %eax
  802046:	68 e1 3b 80 00       	push   $0x803be1
  80204b:	e8 1a e5 ff ff       	call   80056a <cprintf>
  802050:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802053:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802056:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802059:	a1 48 40 80 00       	mov    0x804048,%eax
  80205e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802061:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802065:	74 07                	je     80206e <print_mem_block_lists+0x155>
  802067:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206a:	8b 00                	mov    (%eax),%eax
  80206c:	eb 05                	jmp    802073 <print_mem_block_lists+0x15a>
  80206e:	b8 00 00 00 00       	mov    $0x0,%eax
  802073:	a3 48 40 80 00       	mov    %eax,0x804048
  802078:	a1 48 40 80 00       	mov    0x804048,%eax
  80207d:	85 c0                	test   %eax,%eax
  80207f:	75 8a                	jne    80200b <print_mem_block_lists+0xf2>
  802081:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802085:	75 84                	jne    80200b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802087:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80208b:	75 10                	jne    80209d <print_mem_block_lists+0x184>
  80208d:	83 ec 0c             	sub    $0xc,%esp
  802090:	68 2c 3c 80 00       	push   $0x803c2c
  802095:	e8 d0 e4 ff ff       	call   80056a <cprintf>
  80209a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80209d:	83 ec 0c             	sub    $0xc,%esp
  8020a0:	68 a0 3b 80 00       	push   $0x803ba0
  8020a5:	e8 c0 e4 ff ff       	call   80056a <cprintf>
  8020aa:	83 c4 10             	add    $0x10,%esp

}
  8020ad:	90                   	nop
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8020b6:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020bd:	00 00 00 
  8020c0:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020c7:	00 00 00 
  8020ca:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8020d1:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8020d4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8020db:	e9 9e 00 00 00       	jmp    80217e <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8020e0:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e8:	c1 e2 04             	shl    $0x4,%edx
  8020eb:	01 d0                	add    %edx,%eax
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	75 14                	jne    802105 <initialize_MemBlocksList+0x55>
  8020f1:	83 ec 04             	sub    $0x4,%esp
  8020f4:	68 54 3c 80 00       	push   $0x803c54
  8020f9:	6a 3d                	push   $0x3d
  8020fb:	68 77 3c 80 00       	push   $0x803c77
  802100:	e8 b1 e1 ff ff       	call   8002b6 <_panic>
  802105:	a1 50 40 80 00       	mov    0x804050,%eax
  80210a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210d:	c1 e2 04             	shl    $0x4,%edx
  802110:	01 d0                	add    %edx,%eax
  802112:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802118:	89 10                	mov    %edx,(%eax)
  80211a:	8b 00                	mov    (%eax),%eax
  80211c:	85 c0                	test   %eax,%eax
  80211e:	74 18                	je     802138 <initialize_MemBlocksList+0x88>
  802120:	a1 48 41 80 00       	mov    0x804148,%eax
  802125:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80212b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80212e:	c1 e1 04             	shl    $0x4,%ecx
  802131:	01 ca                	add    %ecx,%edx
  802133:	89 50 04             	mov    %edx,0x4(%eax)
  802136:	eb 12                	jmp    80214a <initialize_MemBlocksList+0x9a>
  802138:	a1 50 40 80 00       	mov    0x804050,%eax
  80213d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802140:	c1 e2 04             	shl    $0x4,%edx
  802143:	01 d0                	add    %edx,%eax
  802145:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80214a:	a1 50 40 80 00       	mov    0x804050,%eax
  80214f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802152:	c1 e2 04             	shl    $0x4,%edx
  802155:	01 d0                	add    %edx,%eax
  802157:	a3 48 41 80 00       	mov    %eax,0x804148
  80215c:	a1 50 40 80 00       	mov    0x804050,%eax
  802161:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802164:	c1 e2 04             	shl    $0x4,%edx
  802167:	01 d0                	add    %edx,%eax
  802169:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802170:	a1 54 41 80 00       	mov    0x804154,%eax
  802175:	40                   	inc    %eax
  802176:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80217b:	ff 45 f4             	incl   -0xc(%ebp)
  80217e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802181:	3b 45 08             	cmp    0x8(%ebp),%eax
  802184:	0f 82 56 ff ff ff    	jb     8020e0 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  80218a:	90                   	nop
  80218b:	c9                   	leave  
  80218c:	c3                   	ret    

0080218d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80218d:	55                   	push   %ebp
  80218e:	89 e5                	mov    %esp,%ebp
  802190:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802193:	8b 45 08             	mov    0x8(%ebp),%eax
  802196:	8b 00                	mov    (%eax),%eax
  802198:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80219b:	eb 18                	jmp    8021b5 <find_block+0x28>

		if(tmp->sva == va){
  80219d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021a0:	8b 40 08             	mov    0x8(%eax),%eax
  8021a3:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021a6:	75 05                	jne    8021ad <find_block+0x20>
			return tmp ;
  8021a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021ab:	eb 11                	jmp    8021be <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8021ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021b0:	8b 00                	mov    (%eax),%eax
  8021b2:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8021b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021b9:	75 e2                	jne    80219d <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8021bb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8021c6:	a1 40 40 80 00       	mov    0x804040,%eax
  8021cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8021ce:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021d3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8021d6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021da:	75 65                	jne    802241 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8021dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021e0:	75 14                	jne    8021f6 <insert_sorted_allocList+0x36>
  8021e2:	83 ec 04             	sub    $0x4,%esp
  8021e5:	68 54 3c 80 00       	push   $0x803c54
  8021ea:	6a 62                	push   $0x62
  8021ec:	68 77 3c 80 00       	push   $0x803c77
  8021f1:	e8 c0 e0 ff ff       	call   8002b6 <_panic>
  8021f6:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	89 10                	mov    %edx,(%eax)
  802201:	8b 45 08             	mov    0x8(%ebp),%eax
  802204:	8b 00                	mov    (%eax),%eax
  802206:	85 c0                	test   %eax,%eax
  802208:	74 0d                	je     802217 <insert_sorted_allocList+0x57>
  80220a:	a1 40 40 80 00       	mov    0x804040,%eax
  80220f:	8b 55 08             	mov    0x8(%ebp),%edx
  802212:	89 50 04             	mov    %edx,0x4(%eax)
  802215:	eb 08                	jmp    80221f <insert_sorted_allocList+0x5f>
  802217:	8b 45 08             	mov    0x8(%ebp),%eax
  80221a:	a3 44 40 80 00       	mov    %eax,0x804044
  80221f:	8b 45 08             	mov    0x8(%ebp),%eax
  802222:	a3 40 40 80 00       	mov    %eax,0x804040
  802227:	8b 45 08             	mov    0x8(%ebp),%eax
  80222a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802231:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802236:	40                   	inc    %eax
  802237:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80223c:	e9 14 01 00 00       	jmp    802355 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802241:	8b 45 08             	mov    0x8(%ebp),%eax
  802244:	8b 50 08             	mov    0x8(%eax),%edx
  802247:	a1 44 40 80 00       	mov    0x804044,%eax
  80224c:	8b 40 08             	mov    0x8(%eax),%eax
  80224f:	39 c2                	cmp    %eax,%edx
  802251:	76 65                	jbe    8022b8 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802253:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802257:	75 14                	jne    80226d <insert_sorted_allocList+0xad>
  802259:	83 ec 04             	sub    $0x4,%esp
  80225c:	68 90 3c 80 00       	push   $0x803c90
  802261:	6a 64                	push   $0x64
  802263:	68 77 3c 80 00       	push   $0x803c77
  802268:	e8 49 e0 ff ff       	call   8002b6 <_panic>
  80226d:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802273:	8b 45 08             	mov    0x8(%ebp),%eax
  802276:	89 50 04             	mov    %edx,0x4(%eax)
  802279:	8b 45 08             	mov    0x8(%ebp),%eax
  80227c:	8b 40 04             	mov    0x4(%eax),%eax
  80227f:	85 c0                	test   %eax,%eax
  802281:	74 0c                	je     80228f <insert_sorted_allocList+0xcf>
  802283:	a1 44 40 80 00       	mov    0x804044,%eax
  802288:	8b 55 08             	mov    0x8(%ebp),%edx
  80228b:	89 10                	mov    %edx,(%eax)
  80228d:	eb 08                	jmp    802297 <insert_sorted_allocList+0xd7>
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	a3 40 40 80 00       	mov    %eax,0x804040
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	a3 44 40 80 00       	mov    %eax,0x804044
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022a8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022ad:	40                   	inc    %eax
  8022ae:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8022b3:	e9 9d 00 00 00       	jmp    802355 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8022b8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8022bf:	e9 85 00 00 00       	jmp    802349 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	8b 50 08             	mov    0x8(%eax),%edx
  8022ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cd:	8b 40 08             	mov    0x8(%eax),%eax
  8022d0:	39 c2                	cmp    %eax,%edx
  8022d2:	73 6a                	jae    80233e <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8022d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022d8:	74 06                	je     8022e0 <insert_sorted_allocList+0x120>
  8022da:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022de:	75 14                	jne    8022f4 <insert_sorted_allocList+0x134>
  8022e0:	83 ec 04             	sub    $0x4,%esp
  8022e3:	68 b4 3c 80 00       	push   $0x803cb4
  8022e8:	6a 6b                	push   $0x6b
  8022ea:	68 77 3c 80 00       	push   $0x803c77
  8022ef:	e8 c2 df ff ff       	call   8002b6 <_panic>
  8022f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f7:	8b 50 04             	mov    0x4(%eax),%edx
  8022fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fd:	89 50 04             	mov    %edx,0x4(%eax)
  802300:	8b 45 08             	mov    0x8(%ebp),%eax
  802303:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802306:	89 10                	mov    %edx,(%eax)
  802308:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80230b:	8b 40 04             	mov    0x4(%eax),%eax
  80230e:	85 c0                	test   %eax,%eax
  802310:	74 0d                	je     80231f <insert_sorted_allocList+0x15f>
  802312:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802315:	8b 40 04             	mov    0x4(%eax),%eax
  802318:	8b 55 08             	mov    0x8(%ebp),%edx
  80231b:	89 10                	mov    %edx,(%eax)
  80231d:	eb 08                	jmp    802327 <insert_sorted_allocList+0x167>
  80231f:	8b 45 08             	mov    0x8(%ebp),%eax
  802322:	a3 40 40 80 00       	mov    %eax,0x804040
  802327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232a:	8b 55 08             	mov    0x8(%ebp),%edx
  80232d:	89 50 04             	mov    %edx,0x4(%eax)
  802330:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802335:	40                   	inc    %eax
  802336:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  80233b:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80233c:	eb 17                	jmp    802355 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  80233e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802341:	8b 00                	mov    (%eax),%eax
  802343:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802346:	ff 45 f0             	incl   -0x10(%ebp)
  802349:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80234c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80234f:	0f 8c 6f ff ff ff    	jl     8022c4 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802355:	90                   	nop
  802356:	c9                   	leave  
  802357:	c3                   	ret    

00802358 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802358:	55                   	push   %ebp
  802359:	89 e5                	mov    %esp,%ebp
  80235b:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  80235e:	a1 38 41 80 00       	mov    0x804138,%eax
  802363:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802366:	e9 7c 01 00 00       	jmp    8024e7 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  80236b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236e:	8b 40 0c             	mov    0xc(%eax),%eax
  802371:	3b 45 08             	cmp    0x8(%ebp),%eax
  802374:	0f 86 cf 00 00 00    	jbe    802449 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80237a:	a1 48 41 80 00       	mov    0x804148,%eax
  80237f:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802382:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802385:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802388:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80238b:	8b 55 08             	mov    0x8(%ebp),%edx
  80238e:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	8b 50 08             	mov    0x8(%eax),%edx
  802397:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239a:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  80239d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a0:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a3:	2b 45 08             	sub    0x8(%ebp),%eax
  8023a6:	89 c2                	mov    %eax,%edx
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 50 08             	mov    0x8(%eax),%edx
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	01 c2                	add    %eax,%edx
  8023b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bc:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8023bf:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023c3:	75 17                	jne    8023dc <alloc_block_FF+0x84>
  8023c5:	83 ec 04             	sub    $0x4,%esp
  8023c8:	68 e9 3c 80 00       	push   $0x803ce9
  8023cd:	68 83 00 00 00       	push   $0x83
  8023d2:	68 77 3c 80 00       	push   $0x803c77
  8023d7:	e8 da de ff ff       	call   8002b6 <_panic>
  8023dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023df:	8b 00                	mov    (%eax),%eax
  8023e1:	85 c0                	test   %eax,%eax
  8023e3:	74 10                	je     8023f5 <alloc_block_FF+0x9d>
  8023e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e8:	8b 00                	mov    (%eax),%eax
  8023ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023ed:	8b 52 04             	mov    0x4(%edx),%edx
  8023f0:	89 50 04             	mov    %edx,0x4(%eax)
  8023f3:	eb 0b                	jmp    802400 <alloc_block_FF+0xa8>
  8023f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023f8:	8b 40 04             	mov    0x4(%eax),%eax
  8023fb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802400:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802403:	8b 40 04             	mov    0x4(%eax),%eax
  802406:	85 c0                	test   %eax,%eax
  802408:	74 0f                	je     802419 <alloc_block_FF+0xc1>
  80240a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240d:	8b 40 04             	mov    0x4(%eax),%eax
  802410:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802413:	8b 12                	mov    (%edx),%edx
  802415:	89 10                	mov    %edx,(%eax)
  802417:	eb 0a                	jmp    802423 <alloc_block_FF+0xcb>
  802419:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241c:	8b 00                	mov    (%eax),%eax
  80241e:	a3 48 41 80 00       	mov    %eax,0x804148
  802423:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802426:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80242c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802436:	a1 54 41 80 00       	mov    0x804154,%eax
  80243b:	48                   	dec    %eax
  80243c:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  802441:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802444:	e9 ad 00 00 00       	jmp    8024f6 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 40 0c             	mov    0xc(%eax),%eax
  80244f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802452:	0f 85 87 00 00 00    	jne    8024df <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802458:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80245c:	75 17                	jne    802475 <alloc_block_FF+0x11d>
  80245e:	83 ec 04             	sub    $0x4,%esp
  802461:	68 e9 3c 80 00       	push   $0x803ce9
  802466:	68 87 00 00 00       	push   $0x87
  80246b:	68 77 3c 80 00       	push   $0x803c77
  802470:	e8 41 de ff ff       	call   8002b6 <_panic>
  802475:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802478:	8b 00                	mov    (%eax),%eax
  80247a:	85 c0                	test   %eax,%eax
  80247c:	74 10                	je     80248e <alloc_block_FF+0x136>
  80247e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802481:	8b 00                	mov    (%eax),%eax
  802483:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802486:	8b 52 04             	mov    0x4(%edx),%edx
  802489:	89 50 04             	mov    %edx,0x4(%eax)
  80248c:	eb 0b                	jmp    802499 <alloc_block_FF+0x141>
  80248e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802491:	8b 40 04             	mov    0x4(%eax),%eax
  802494:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 40 04             	mov    0x4(%eax),%eax
  80249f:	85 c0                	test   %eax,%eax
  8024a1:	74 0f                	je     8024b2 <alloc_block_FF+0x15a>
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	8b 40 04             	mov    0x4(%eax),%eax
  8024a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024ac:	8b 12                	mov    (%edx),%edx
  8024ae:	89 10                	mov    %edx,(%eax)
  8024b0:	eb 0a                	jmp    8024bc <alloc_block_FF+0x164>
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	8b 00                	mov    (%eax),%eax
  8024b7:	a3 38 41 80 00       	mov    %eax,0x804138
  8024bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024cf:	a1 44 41 80 00       	mov    0x804144,%eax
  8024d4:	48                   	dec    %eax
  8024d5:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8024da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024dd:	eb 17                	jmp    8024f6 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8024df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e2:	8b 00                	mov    (%eax),%eax
  8024e4:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8024e7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024eb:	0f 85 7a fe ff ff    	jne    80236b <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8024f1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024f6:	c9                   	leave  
  8024f7:	c3                   	ret    

008024f8 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024f8:	55                   	push   %ebp
  8024f9:	89 e5                	mov    %esp,%ebp
  8024fb:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8024fe:	a1 38 41 80 00       	mov    0x804138,%eax
  802503:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802506:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  80250d:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802514:	a1 38 41 80 00       	mov    0x804138,%eax
  802519:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80251c:	e9 d0 00 00 00       	jmp    8025f1 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802521:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802524:	8b 40 0c             	mov    0xc(%eax),%eax
  802527:	3b 45 08             	cmp    0x8(%ebp),%eax
  80252a:	0f 82 b8 00 00 00    	jb     8025e8 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	8b 40 0c             	mov    0xc(%eax),%eax
  802536:	2b 45 08             	sub    0x8(%ebp),%eax
  802539:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  80253c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80253f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802542:	0f 83 a1 00 00 00    	jae    8025e9 <alloc_block_BF+0xf1>
				differsize = differance ;
  802548:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80254b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802554:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802558:	0f 85 8b 00 00 00    	jne    8025e9 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  80255e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802562:	75 17                	jne    80257b <alloc_block_BF+0x83>
  802564:	83 ec 04             	sub    $0x4,%esp
  802567:	68 e9 3c 80 00       	push   $0x803ce9
  80256c:	68 a0 00 00 00       	push   $0xa0
  802571:	68 77 3c 80 00       	push   $0x803c77
  802576:	e8 3b dd ff ff       	call   8002b6 <_panic>
  80257b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257e:	8b 00                	mov    (%eax),%eax
  802580:	85 c0                	test   %eax,%eax
  802582:	74 10                	je     802594 <alloc_block_BF+0x9c>
  802584:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802587:	8b 00                	mov    (%eax),%eax
  802589:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80258c:	8b 52 04             	mov    0x4(%edx),%edx
  80258f:	89 50 04             	mov    %edx,0x4(%eax)
  802592:	eb 0b                	jmp    80259f <alloc_block_BF+0xa7>
  802594:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802597:	8b 40 04             	mov    0x4(%eax),%eax
  80259a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	8b 40 04             	mov    0x4(%eax),%eax
  8025a5:	85 c0                	test   %eax,%eax
  8025a7:	74 0f                	je     8025b8 <alloc_block_BF+0xc0>
  8025a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ac:	8b 40 04             	mov    0x4(%eax),%eax
  8025af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025b2:	8b 12                	mov    (%edx),%edx
  8025b4:	89 10                	mov    %edx,(%eax)
  8025b6:	eb 0a                	jmp    8025c2 <alloc_block_BF+0xca>
  8025b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bb:	8b 00                	mov    (%eax),%eax
  8025bd:	a3 38 41 80 00       	mov    %eax,0x804138
  8025c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d5:	a1 44 41 80 00       	mov    0x804144,%eax
  8025da:	48                   	dec    %eax
  8025db:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8025e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e3:	e9 0c 01 00 00       	jmp    8026f4 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8025e8:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8025e9:	a1 40 41 80 00       	mov    0x804140,%eax
  8025ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025f5:	74 07                	je     8025fe <alloc_block_BF+0x106>
  8025f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fa:	8b 00                	mov    (%eax),%eax
  8025fc:	eb 05                	jmp    802603 <alloc_block_BF+0x10b>
  8025fe:	b8 00 00 00 00       	mov    $0x0,%eax
  802603:	a3 40 41 80 00       	mov    %eax,0x804140
  802608:	a1 40 41 80 00       	mov    0x804140,%eax
  80260d:	85 c0                	test   %eax,%eax
  80260f:	0f 85 0c ff ff ff    	jne    802521 <alloc_block_BF+0x29>
  802615:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802619:	0f 85 02 ff ff ff    	jne    802521 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  80261f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802623:	0f 84 c6 00 00 00    	je     8026ef <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802629:	a1 48 41 80 00       	mov    0x804148,%eax
  80262e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802631:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802634:	8b 55 08             	mov    0x8(%ebp),%edx
  802637:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  80263a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80263d:	8b 50 08             	mov    0x8(%eax),%edx
  802640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802643:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802646:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802649:	8b 40 0c             	mov    0xc(%eax),%eax
  80264c:	2b 45 08             	sub    0x8(%ebp),%eax
  80264f:	89 c2                	mov    %eax,%edx
  802651:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802654:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802657:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80265a:	8b 50 08             	mov    0x8(%eax),%edx
  80265d:	8b 45 08             	mov    0x8(%ebp),%eax
  802660:	01 c2                	add    %eax,%edx
  802662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802665:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802668:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80266c:	75 17                	jne    802685 <alloc_block_BF+0x18d>
  80266e:	83 ec 04             	sub    $0x4,%esp
  802671:	68 e9 3c 80 00       	push   $0x803ce9
  802676:	68 af 00 00 00       	push   $0xaf
  80267b:	68 77 3c 80 00       	push   $0x803c77
  802680:	e8 31 dc ff ff       	call   8002b6 <_panic>
  802685:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802688:	8b 00                	mov    (%eax),%eax
  80268a:	85 c0                	test   %eax,%eax
  80268c:	74 10                	je     80269e <alloc_block_BF+0x1a6>
  80268e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802691:	8b 00                	mov    (%eax),%eax
  802693:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802696:	8b 52 04             	mov    0x4(%edx),%edx
  802699:	89 50 04             	mov    %edx,0x4(%eax)
  80269c:	eb 0b                	jmp    8026a9 <alloc_block_BF+0x1b1>
  80269e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a1:	8b 40 04             	mov    0x4(%eax),%eax
  8026a4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ac:	8b 40 04             	mov    0x4(%eax),%eax
  8026af:	85 c0                	test   %eax,%eax
  8026b1:	74 0f                	je     8026c2 <alloc_block_BF+0x1ca>
  8026b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b6:	8b 40 04             	mov    0x4(%eax),%eax
  8026b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026bc:	8b 12                	mov    (%edx),%edx
  8026be:	89 10                	mov    %edx,(%eax)
  8026c0:	eb 0a                	jmp    8026cc <alloc_block_BF+0x1d4>
  8026c2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c5:	8b 00                	mov    (%eax),%eax
  8026c7:	a3 48 41 80 00       	mov    %eax,0x804148
  8026cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026cf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026d5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026df:	a1 54 41 80 00       	mov    0x804154,%eax
  8026e4:	48                   	dec    %eax
  8026e5:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8026ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026ed:	eb 05                	jmp    8026f4 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8026ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026f4:	c9                   	leave  
  8026f5:	c3                   	ret    

008026f6 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8026f6:	55                   	push   %ebp
  8026f7:	89 e5                	mov    %esp,%ebp
  8026f9:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8026fc:	a1 38 41 80 00       	mov    0x804138,%eax
  802701:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802704:	e9 7c 01 00 00       	jmp    802885 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802709:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270c:	8b 40 0c             	mov    0xc(%eax),%eax
  80270f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802712:	0f 86 cf 00 00 00    	jbe    8027e7 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802718:	a1 48 41 80 00       	mov    0x804148,%eax
  80271d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802723:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802726:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802729:	8b 55 08             	mov    0x8(%ebp),%edx
  80272c:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  80272f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802732:	8b 50 08             	mov    0x8(%eax),%edx
  802735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802738:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  80273b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273e:	8b 40 0c             	mov    0xc(%eax),%eax
  802741:	2b 45 08             	sub    0x8(%ebp),%eax
  802744:	89 c2                	mov    %eax,%edx
  802746:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802749:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  80274c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274f:	8b 50 08             	mov    0x8(%eax),%edx
  802752:	8b 45 08             	mov    0x8(%ebp),%eax
  802755:	01 c2                	add    %eax,%edx
  802757:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275a:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80275d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802761:	75 17                	jne    80277a <alloc_block_NF+0x84>
  802763:	83 ec 04             	sub    $0x4,%esp
  802766:	68 e9 3c 80 00       	push   $0x803ce9
  80276b:	68 c4 00 00 00       	push   $0xc4
  802770:	68 77 3c 80 00       	push   $0x803c77
  802775:	e8 3c db ff ff       	call   8002b6 <_panic>
  80277a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277d:	8b 00                	mov    (%eax),%eax
  80277f:	85 c0                	test   %eax,%eax
  802781:	74 10                	je     802793 <alloc_block_NF+0x9d>
  802783:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802786:	8b 00                	mov    (%eax),%eax
  802788:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80278b:	8b 52 04             	mov    0x4(%edx),%edx
  80278e:	89 50 04             	mov    %edx,0x4(%eax)
  802791:	eb 0b                	jmp    80279e <alloc_block_NF+0xa8>
  802793:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802796:	8b 40 04             	mov    0x4(%eax),%eax
  802799:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80279e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a1:	8b 40 04             	mov    0x4(%eax),%eax
  8027a4:	85 c0                	test   %eax,%eax
  8027a6:	74 0f                	je     8027b7 <alloc_block_NF+0xc1>
  8027a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ab:	8b 40 04             	mov    0x4(%eax),%eax
  8027ae:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027b1:	8b 12                	mov    (%edx),%edx
  8027b3:	89 10                	mov    %edx,(%eax)
  8027b5:	eb 0a                	jmp    8027c1 <alloc_block_NF+0xcb>
  8027b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ba:	8b 00                	mov    (%eax),%eax
  8027bc:	a3 48 41 80 00       	mov    %eax,0x804148
  8027c1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027cd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027d4:	a1 54 41 80 00       	mov    0x804154,%eax
  8027d9:	48                   	dec    %eax
  8027da:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8027df:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027e2:	e9 ad 00 00 00       	jmp    802894 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8027ed:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f0:	0f 85 87 00 00 00    	jne    80287d <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8027f6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027fa:	75 17                	jne    802813 <alloc_block_NF+0x11d>
  8027fc:	83 ec 04             	sub    $0x4,%esp
  8027ff:	68 e9 3c 80 00       	push   $0x803ce9
  802804:	68 c8 00 00 00       	push   $0xc8
  802809:	68 77 3c 80 00       	push   $0x803c77
  80280e:	e8 a3 da ff ff       	call   8002b6 <_panic>
  802813:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802816:	8b 00                	mov    (%eax),%eax
  802818:	85 c0                	test   %eax,%eax
  80281a:	74 10                	je     80282c <alloc_block_NF+0x136>
  80281c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281f:	8b 00                	mov    (%eax),%eax
  802821:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802824:	8b 52 04             	mov    0x4(%edx),%edx
  802827:	89 50 04             	mov    %edx,0x4(%eax)
  80282a:	eb 0b                	jmp    802837 <alloc_block_NF+0x141>
  80282c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282f:	8b 40 04             	mov    0x4(%eax),%eax
  802832:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802837:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283a:	8b 40 04             	mov    0x4(%eax),%eax
  80283d:	85 c0                	test   %eax,%eax
  80283f:	74 0f                	je     802850 <alloc_block_NF+0x15a>
  802841:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802844:	8b 40 04             	mov    0x4(%eax),%eax
  802847:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80284a:	8b 12                	mov    (%edx),%edx
  80284c:	89 10                	mov    %edx,(%eax)
  80284e:	eb 0a                	jmp    80285a <alloc_block_NF+0x164>
  802850:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802853:	8b 00                	mov    (%eax),%eax
  802855:	a3 38 41 80 00       	mov    %eax,0x804138
  80285a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802863:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802866:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80286d:	a1 44 41 80 00       	mov    0x804144,%eax
  802872:	48                   	dec    %eax
  802873:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	eb 17                	jmp    802894 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  80287d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802880:	8b 00                	mov    (%eax),%eax
  802882:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802885:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802889:	0f 85 7a fe ff ff    	jne    802709 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  80288f:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802894:	c9                   	leave  
  802895:	c3                   	ret    

00802896 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802896:	55                   	push   %ebp
  802897:	89 e5                	mov    %esp,%ebp
  802899:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  80289c:	a1 38 41 80 00       	mov    0x804138,%eax
  8028a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8028a4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8028ac:	a1 44 41 80 00       	mov    0x804144,%eax
  8028b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8028b4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028b8:	75 68                	jne    802922 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8028ba:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028be:	75 17                	jne    8028d7 <insert_sorted_with_merge_freeList+0x41>
  8028c0:	83 ec 04             	sub    $0x4,%esp
  8028c3:	68 54 3c 80 00       	push   $0x803c54
  8028c8:	68 da 00 00 00       	push   $0xda
  8028cd:	68 77 3c 80 00       	push   $0x803c77
  8028d2:	e8 df d9 ff ff       	call   8002b6 <_panic>
  8028d7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e0:	89 10                	mov    %edx,(%eax)
  8028e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028e5:	8b 00                	mov    (%eax),%eax
  8028e7:	85 c0                	test   %eax,%eax
  8028e9:	74 0d                	je     8028f8 <insert_sorted_with_merge_freeList+0x62>
  8028eb:	a1 38 41 80 00       	mov    0x804138,%eax
  8028f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028f3:	89 50 04             	mov    %edx,0x4(%eax)
  8028f6:	eb 08                	jmp    802900 <insert_sorted_with_merge_freeList+0x6a>
  8028f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802900:	8b 45 08             	mov    0x8(%ebp),%eax
  802903:	a3 38 41 80 00       	mov    %eax,0x804138
  802908:	8b 45 08             	mov    0x8(%ebp),%eax
  80290b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802912:	a1 44 41 80 00       	mov    0x804144,%eax
  802917:	40                   	inc    %eax
  802918:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  80291d:	e9 49 07 00 00       	jmp    80306b <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802922:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802925:	8b 50 08             	mov    0x8(%eax),%edx
  802928:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80292b:	8b 40 0c             	mov    0xc(%eax),%eax
  80292e:	01 c2                	add    %eax,%edx
  802930:	8b 45 08             	mov    0x8(%ebp),%eax
  802933:	8b 40 08             	mov    0x8(%eax),%eax
  802936:	39 c2                	cmp    %eax,%edx
  802938:	73 77                	jae    8029b1 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  80293a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80293d:	8b 00                	mov    (%eax),%eax
  80293f:	85 c0                	test   %eax,%eax
  802941:	75 6e                	jne    8029b1 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802943:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802947:	74 68                	je     8029b1 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802949:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80294d:	75 17                	jne    802966 <insert_sorted_with_merge_freeList+0xd0>
  80294f:	83 ec 04             	sub    $0x4,%esp
  802952:	68 90 3c 80 00       	push   $0x803c90
  802957:	68 e0 00 00 00       	push   $0xe0
  80295c:	68 77 3c 80 00       	push   $0x803c77
  802961:	e8 50 d9 ff ff       	call   8002b6 <_panic>
  802966:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80296c:	8b 45 08             	mov    0x8(%ebp),%eax
  80296f:	89 50 04             	mov    %edx,0x4(%eax)
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	8b 40 04             	mov    0x4(%eax),%eax
  802978:	85 c0                	test   %eax,%eax
  80297a:	74 0c                	je     802988 <insert_sorted_with_merge_freeList+0xf2>
  80297c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802981:	8b 55 08             	mov    0x8(%ebp),%edx
  802984:	89 10                	mov    %edx,(%eax)
  802986:	eb 08                	jmp    802990 <insert_sorted_with_merge_freeList+0xfa>
  802988:	8b 45 08             	mov    0x8(%ebp),%eax
  80298b:	a3 38 41 80 00       	mov    %eax,0x804138
  802990:	8b 45 08             	mov    0x8(%ebp),%eax
  802993:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802998:	8b 45 08             	mov    0x8(%ebp),%eax
  80299b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029a1:	a1 44 41 80 00       	mov    0x804144,%eax
  8029a6:	40                   	inc    %eax
  8029a7:	a3 44 41 80 00       	mov    %eax,0x804144
  8029ac:	e9 ba 06 00 00       	jmp    80306b <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	8b 50 0c             	mov    0xc(%eax),%edx
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	8b 40 08             	mov    0x8(%eax),%eax
  8029bd:	01 c2                	add    %eax,%edx
  8029bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c2:	8b 40 08             	mov    0x8(%eax),%eax
  8029c5:	39 c2                	cmp    %eax,%edx
  8029c7:	73 78                	jae    802a41 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8029c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029cc:	8b 40 04             	mov    0x4(%eax),%eax
  8029cf:	85 c0                	test   %eax,%eax
  8029d1:	75 6e                	jne    802a41 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8029d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029d7:	74 68                	je     802a41 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8029d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029dd:	75 17                	jne    8029f6 <insert_sorted_with_merge_freeList+0x160>
  8029df:	83 ec 04             	sub    $0x4,%esp
  8029e2:	68 54 3c 80 00       	push   $0x803c54
  8029e7:	68 e6 00 00 00       	push   $0xe6
  8029ec:	68 77 3c 80 00       	push   $0x803c77
  8029f1:	e8 c0 d8 ff ff       	call   8002b6 <_panic>
  8029f6:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ff:	89 10                	mov    %edx,(%eax)
  802a01:	8b 45 08             	mov    0x8(%ebp),%eax
  802a04:	8b 00                	mov    (%eax),%eax
  802a06:	85 c0                	test   %eax,%eax
  802a08:	74 0d                	je     802a17 <insert_sorted_with_merge_freeList+0x181>
  802a0a:	a1 38 41 80 00       	mov    0x804138,%eax
  802a0f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a12:	89 50 04             	mov    %edx,0x4(%eax)
  802a15:	eb 08                	jmp    802a1f <insert_sorted_with_merge_freeList+0x189>
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a22:	a3 38 41 80 00       	mov    %eax,0x804138
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a31:	a1 44 41 80 00       	mov    0x804144,%eax
  802a36:	40                   	inc    %eax
  802a37:	a3 44 41 80 00       	mov    %eax,0x804144
  802a3c:	e9 2a 06 00 00       	jmp    80306b <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802a41:	a1 38 41 80 00       	mov    0x804138,%eax
  802a46:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a49:	e9 ed 05 00 00       	jmp    80303b <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802a4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a51:	8b 00                	mov    (%eax),%eax
  802a53:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802a56:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a5a:	0f 84 a7 00 00 00    	je     802b07 <insert_sorted_with_merge_freeList+0x271>
  802a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a63:	8b 50 0c             	mov    0xc(%eax),%edx
  802a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a69:	8b 40 08             	mov    0x8(%eax),%eax
  802a6c:	01 c2                	add    %eax,%edx
  802a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a71:	8b 40 08             	mov    0x8(%eax),%eax
  802a74:	39 c2                	cmp    %eax,%edx
  802a76:	0f 83 8b 00 00 00    	jae    802b07 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7f:	8b 50 0c             	mov    0xc(%eax),%edx
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	8b 40 08             	mov    0x8(%eax),%eax
  802a88:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802a8a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a8d:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802a90:	39 c2                	cmp    %eax,%edx
  802a92:	73 73                	jae    802b07 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802a94:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a98:	74 06                	je     802aa0 <insert_sorted_with_merge_freeList+0x20a>
  802a9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a9e:	75 17                	jne    802ab7 <insert_sorted_with_merge_freeList+0x221>
  802aa0:	83 ec 04             	sub    $0x4,%esp
  802aa3:	68 08 3d 80 00       	push   $0x803d08
  802aa8:	68 f0 00 00 00       	push   $0xf0
  802aad:	68 77 3c 80 00       	push   $0x803c77
  802ab2:	e8 ff d7 ff ff       	call   8002b6 <_panic>
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	8b 10                	mov    (%eax),%edx
  802abc:	8b 45 08             	mov    0x8(%ebp),%eax
  802abf:	89 10                	mov    %edx,(%eax)
  802ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac4:	8b 00                	mov    (%eax),%eax
  802ac6:	85 c0                	test   %eax,%eax
  802ac8:	74 0b                	je     802ad5 <insert_sorted_with_merge_freeList+0x23f>
  802aca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acd:	8b 00                	mov    (%eax),%eax
  802acf:	8b 55 08             	mov    0x8(%ebp),%edx
  802ad2:	89 50 04             	mov    %edx,0x4(%eax)
  802ad5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad8:	8b 55 08             	mov    0x8(%ebp),%edx
  802adb:	89 10                	mov    %edx,(%eax)
  802add:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ae3:	89 50 04             	mov    %edx,0x4(%eax)
  802ae6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae9:	8b 00                	mov    (%eax),%eax
  802aeb:	85 c0                	test   %eax,%eax
  802aed:	75 08                	jne    802af7 <insert_sorted_with_merge_freeList+0x261>
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802af7:	a1 44 41 80 00       	mov    0x804144,%eax
  802afc:	40                   	inc    %eax
  802afd:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802b02:	e9 64 05 00 00       	jmp    80306b <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802b07:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b0c:	8b 50 0c             	mov    0xc(%eax),%edx
  802b0f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b14:	8b 40 08             	mov    0x8(%eax),%eax
  802b17:	01 c2                	add    %eax,%edx
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	8b 40 08             	mov    0x8(%eax),%eax
  802b1f:	39 c2                	cmp    %eax,%edx
  802b21:	0f 85 b1 00 00 00    	jne    802bd8 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802b27:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b2c:	85 c0                	test   %eax,%eax
  802b2e:	0f 84 a4 00 00 00    	je     802bd8 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802b34:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b39:	8b 00                	mov    (%eax),%eax
  802b3b:	85 c0                	test   %eax,%eax
  802b3d:	0f 85 95 00 00 00    	jne    802bd8 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802b43:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b48:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b4e:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b51:	8b 55 08             	mov    0x8(%ebp),%edx
  802b54:	8b 52 0c             	mov    0xc(%edx),%edx
  802b57:	01 ca                	add    %ecx,%edx
  802b59:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802b66:	8b 45 08             	mov    0x8(%ebp),%eax
  802b69:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802b70:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b74:	75 17                	jne    802b8d <insert_sorted_with_merge_freeList+0x2f7>
  802b76:	83 ec 04             	sub    $0x4,%esp
  802b79:	68 54 3c 80 00       	push   $0x803c54
  802b7e:	68 ff 00 00 00       	push   $0xff
  802b83:	68 77 3c 80 00       	push   $0x803c77
  802b88:	e8 29 d7 ff ff       	call   8002b6 <_panic>
  802b8d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b93:	8b 45 08             	mov    0x8(%ebp),%eax
  802b96:	89 10                	mov    %edx,(%eax)
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	8b 00                	mov    (%eax),%eax
  802b9d:	85 c0                	test   %eax,%eax
  802b9f:	74 0d                	je     802bae <insert_sorted_with_merge_freeList+0x318>
  802ba1:	a1 48 41 80 00       	mov    0x804148,%eax
  802ba6:	8b 55 08             	mov    0x8(%ebp),%edx
  802ba9:	89 50 04             	mov    %edx,0x4(%eax)
  802bac:	eb 08                	jmp    802bb6 <insert_sorted_with_merge_freeList+0x320>
  802bae:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	a3 48 41 80 00       	mov    %eax,0x804148
  802bbe:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bc8:	a1 54 41 80 00       	mov    0x804154,%eax
  802bcd:	40                   	inc    %eax
  802bce:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802bd3:	e9 93 04 00 00       	jmp    80306b <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bdb:	8b 50 08             	mov    0x8(%eax),%edx
  802bde:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be1:	8b 40 0c             	mov    0xc(%eax),%eax
  802be4:	01 c2                	add    %eax,%edx
  802be6:	8b 45 08             	mov    0x8(%ebp),%eax
  802be9:	8b 40 08             	mov    0x8(%eax),%eax
  802bec:	39 c2                	cmp    %eax,%edx
  802bee:	0f 85 ae 00 00 00    	jne    802ca2 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802bf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf7:	8b 50 0c             	mov    0xc(%eax),%edx
  802bfa:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfd:	8b 40 08             	mov    0x8(%eax),%eax
  802c00:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802c02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c05:	8b 00                	mov    (%eax),%eax
  802c07:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802c0a:	39 c2                	cmp    %eax,%edx
  802c0c:	0f 84 90 00 00 00    	je     802ca2 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c15:	8b 50 0c             	mov    0xc(%eax),%edx
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c1e:	01 c2                	add    %eax,%edx
  802c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c23:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802c30:	8b 45 08             	mov    0x8(%ebp),%eax
  802c33:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c3a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c3e:	75 17                	jne    802c57 <insert_sorted_with_merge_freeList+0x3c1>
  802c40:	83 ec 04             	sub    $0x4,%esp
  802c43:	68 54 3c 80 00       	push   $0x803c54
  802c48:	68 0b 01 00 00       	push   $0x10b
  802c4d:	68 77 3c 80 00       	push   $0x803c77
  802c52:	e8 5f d6 ff ff       	call   8002b6 <_panic>
  802c57:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	89 10                	mov    %edx,(%eax)
  802c62:	8b 45 08             	mov    0x8(%ebp),%eax
  802c65:	8b 00                	mov    (%eax),%eax
  802c67:	85 c0                	test   %eax,%eax
  802c69:	74 0d                	je     802c78 <insert_sorted_with_merge_freeList+0x3e2>
  802c6b:	a1 48 41 80 00       	mov    0x804148,%eax
  802c70:	8b 55 08             	mov    0x8(%ebp),%edx
  802c73:	89 50 04             	mov    %edx,0x4(%eax)
  802c76:	eb 08                	jmp    802c80 <insert_sorted_with_merge_freeList+0x3ea>
  802c78:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c80:	8b 45 08             	mov    0x8(%ebp),%eax
  802c83:	a3 48 41 80 00       	mov    %eax,0x804148
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c92:	a1 54 41 80 00       	mov    0x804154,%eax
  802c97:	40                   	inc    %eax
  802c98:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802c9d:	e9 c9 03 00 00       	jmp    80306b <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	8b 50 0c             	mov    0xc(%eax),%edx
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	8b 40 08             	mov    0x8(%eax),%eax
  802cae:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802cb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb3:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802cb6:	39 c2                	cmp    %eax,%edx
  802cb8:	0f 85 bb 00 00 00    	jne    802d79 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802cbe:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cc2:	0f 84 b1 00 00 00    	je     802d79 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802cc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccb:	8b 40 04             	mov    0x4(%eax),%eax
  802cce:	85 c0                	test   %eax,%eax
  802cd0:	0f 85 a3 00 00 00    	jne    802d79 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802cd6:	a1 38 41 80 00       	mov    0x804138,%eax
  802cdb:	8b 55 08             	mov    0x8(%ebp),%edx
  802cde:	8b 52 08             	mov    0x8(%edx),%edx
  802ce1:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802ce4:	a1 38 41 80 00       	mov    0x804138,%eax
  802ce9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802cef:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802cf2:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf5:	8b 52 0c             	mov    0xc(%edx),%edx
  802cf8:	01 ca                	add    %ecx,%edx
  802cfa:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d07:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d11:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d15:	75 17                	jne    802d2e <insert_sorted_with_merge_freeList+0x498>
  802d17:	83 ec 04             	sub    $0x4,%esp
  802d1a:	68 54 3c 80 00       	push   $0x803c54
  802d1f:	68 17 01 00 00       	push   $0x117
  802d24:	68 77 3c 80 00       	push   $0x803c77
  802d29:	e8 88 d5 ff ff       	call   8002b6 <_panic>
  802d2e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d34:	8b 45 08             	mov    0x8(%ebp),%eax
  802d37:	89 10                	mov    %edx,(%eax)
  802d39:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3c:	8b 00                	mov    (%eax),%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	74 0d                	je     802d4f <insert_sorted_with_merge_freeList+0x4b9>
  802d42:	a1 48 41 80 00       	mov    0x804148,%eax
  802d47:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4a:	89 50 04             	mov    %edx,0x4(%eax)
  802d4d:	eb 08                	jmp    802d57 <insert_sorted_with_merge_freeList+0x4c1>
  802d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d52:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d57:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5a:	a3 48 41 80 00       	mov    %eax,0x804148
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d69:	a1 54 41 80 00       	mov    0x804154,%eax
  802d6e:	40                   	inc    %eax
  802d6f:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d74:	e9 f2 02 00 00       	jmp    80306b <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802d79:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7c:	8b 50 08             	mov    0x8(%eax),%edx
  802d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d82:	8b 40 0c             	mov    0xc(%eax),%eax
  802d85:	01 c2                	add    %eax,%edx
  802d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8a:	8b 40 08             	mov    0x8(%eax),%eax
  802d8d:	39 c2                	cmp    %eax,%edx
  802d8f:	0f 85 be 00 00 00    	jne    802e53 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 40 04             	mov    0x4(%eax),%eax
  802d9b:	8b 50 08             	mov    0x8(%eax),%edx
  802d9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da1:	8b 40 04             	mov    0x4(%eax),%eax
  802da4:	8b 40 0c             	mov    0xc(%eax),%eax
  802da7:	01 c2                	add    %eax,%edx
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	8b 40 08             	mov    0x8(%eax),%eax
  802daf:	39 c2                	cmp    %eax,%edx
  802db1:	0f 84 9c 00 00 00    	je     802e53 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802db7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dba:	8b 50 08             	mov    0x8(%eax),%edx
  802dbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc0:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802dc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc6:	8b 50 0c             	mov    0xc(%eax),%edx
  802dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcc:	8b 40 0c             	mov    0xc(%eax),%eax
  802dcf:	01 c2                	add    %eax,%edx
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802deb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802def:	75 17                	jne    802e08 <insert_sorted_with_merge_freeList+0x572>
  802df1:	83 ec 04             	sub    $0x4,%esp
  802df4:	68 54 3c 80 00       	push   $0x803c54
  802df9:	68 26 01 00 00       	push   $0x126
  802dfe:	68 77 3c 80 00       	push   $0x803c77
  802e03:	e8 ae d4 ff ff       	call   8002b6 <_panic>
  802e08:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	89 10                	mov    %edx,(%eax)
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	8b 00                	mov    (%eax),%eax
  802e18:	85 c0                	test   %eax,%eax
  802e1a:	74 0d                	je     802e29 <insert_sorted_with_merge_freeList+0x593>
  802e1c:	a1 48 41 80 00       	mov    0x804148,%eax
  802e21:	8b 55 08             	mov    0x8(%ebp),%edx
  802e24:	89 50 04             	mov    %edx,0x4(%eax)
  802e27:	eb 08                	jmp    802e31 <insert_sorted_with_merge_freeList+0x59b>
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	a3 48 41 80 00       	mov    %eax,0x804148
  802e39:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e43:	a1 54 41 80 00       	mov    0x804154,%eax
  802e48:	40                   	inc    %eax
  802e49:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802e4e:	e9 18 02 00 00       	jmp    80306b <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e56:	8b 50 0c             	mov    0xc(%eax),%edx
  802e59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e5c:	8b 40 08             	mov    0x8(%eax),%eax
  802e5f:	01 c2                	add    %eax,%edx
  802e61:	8b 45 08             	mov    0x8(%ebp),%eax
  802e64:	8b 40 08             	mov    0x8(%eax),%eax
  802e67:	39 c2                	cmp    %eax,%edx
  802e69:	0f 85 c4 01 00 00    	jne    803033 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802e6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e72:	8b 50 0c             	mov    0xc(%eax),%edx
  802e75:	8b 45 08             	mov    0x8(%ebp),%eax
  802e78:	8b 40 08             	mov    0x8(%eax),%eax
  802e7b:	01 c2                	add    %eax,%edx
  802e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e80:	8b 00                	mov    (%eax),%eax
  802e82:	8b 40 08             	mov    0x8(%eax),%eax
  802e85:	39 c2                	cmp    %eax,%edx
  802e87:	0f 85 a6 01 00 00    	jne    803033 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802e8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e91:	0f 84 9c 01 00 00    	je     803033 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	8b 50 0c             	mov    0xc(%eax),%edx
  802e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea0:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea3:	01 c2                	add    %eax,%edx
  802ea5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea8:	8b 00                	mov    (%eax),%eax
  802eaa:	8b 40 0c             	mov    0xc(%eax),%eax
  802ead:	01 c2                	add    %eax,%edx
  802eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb2:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802eb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802ec9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ecd:	75 17                	jne    802ee6 <insert_sorted_with_merge_freeList+0x650>
  802ecf:	83 ec 04             	sub    $0x4,%esp
  802ed2:	68 54 3c 80 00       	push   $0x803c54
  802ed7:	68 32 01 00 00       	push   $0x132
  802edc:	68 77 3c 80 00       	push   $0x803c77
  802ee1:	e8 d0 d3 ff ff       	call   8002b6 <_panic>
  802ee6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802eec:	8b 45 08             	mov    0x8(%ebp),%eax
  802eef:	89 10                	mov    %edx,(%eax)
  802ef1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef4:	8b 00                	mov    (%eax),%eax
  802ef6:	85 c0                	test   %eax,%eax
  802ef8:	74 0d                	je     802f07 <insert_sorted_with_merge_freeList+0x671>
  802efa:	a1 48 41 80 00       	mov    0x804148,%eax
  802eff:	8b 55 08             	mov    0x8(%ebp),%edx
  802f02:	89 50 04             	mov    %edx,0x4(%eax)
  802f05:	eb 08                	jmp    802f0f <insert_sorted_with_merge_freeList+0x679>
  802f07:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f12:	a3 48 41 80 00       	mov    %eax,0x804148
  802f17:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f21:	a1 54 41 80 00       	mov    0x804154,%eax
  802f26:	40                   	inc    %eax
  802f27:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802f2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2f:	8b 00                	mov    (%eax),%eax
  802f31:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802f38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3b:	8b 00                	mov    (%eax),%eax
  802f3d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	8b 00                	mov    (%eax),%eax
  802f49:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802f4c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f50:	75 17                	jne    802f69 <insert_sorted_with_merge_freeList+0x6d3>
  802f52:	83 ec 04             	sub    $0x4,%esp
  802f55:	68 e9 3c 80 00       	push   $0x803ce9
  802f5a:	68 36 01 00 00       	push   $0x136
  802f5f:	68 77 3c 80 00       	push   $0x803c77
  802f64:	e8 4d d3 ff ff       	call   8002b6 <_panic>
  802f69:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f6c:	8b 00                	mov    (%eax),%eax
  802f6e:	85 c0                	test   %eax,%eax
  802f70:	74 10                	je     802f82 <insert_sorted_with_merge_freeList+0x6ec>
  802f72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f75:	8b 00                	mov    (%eax),%eax
  802f77:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f7a:	8b 52 04             	mov    0x4(%edx),%edx
  802f7d:	89 50 04             	mov    %edx,0x4(%eax)
  802f80:	eb 0b                	jmp    802f8d <insert_sorted_with_merge_freeList+0x6f7>
  802f82:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f85:	8b 40 04             	mov    0x4(%eax),%eax
  802f88:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f8d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f90:	8b 40 04             	mov    0x4(%eax),%eax
  802f93:	85 c0                	test   %eax,%eax
  802f95:	74 0f                	je     802fa6 <insert_sorted_with_merge_freeList+0x710>
  802f97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9a:	8b 40 04             	mov    0x4(%eax),%eax
  802f9d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fa0:	8b 12                	mov    (%edx),%edx
  802fa2:	89 10                	mov    %edx,(%eax)
  802fa4:	eb 0a                	jmp    802fb0 <insert_sorted_with_merge_freeList+0x71a>
  802fa6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa9:	8b 00                	mov    (%eax),%eax
  802fab:	a3 38 41 80 00       	mov    %eax,0x804138
  802fb0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fbc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc3:	a1 44 41 80 00       	mov    0x804144,%eax
  802fc8:	48                   	dec    %eax
  802fc9:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  802fce:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fd2:	75 17                	jne    802feb <insert_sorted_with_merge_freeList+0x755>
  802fd4:	83 ec 04             	sub    $0x4,%esp
  802fd7:	68 54 3c 80 00       	push   $0x803c54
  802fdc:	68 37 01 00 00       	push   $0x137
  802fe1:	68 77 3c 80 00       	push   $0x803c77
  802fe6:	e8 cb d2 ff ff       	call   8002b6 <_panic>
  802feb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ff1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff4:	89 10                	mov    %edx,(%eax)
  802ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff9:	8b 00                	mov    (%eax),%eax
  802ffb:	85 c0                	test   %eax,%eax
  802ffd:	74 0d                	je     80300c <insert_sorted_with_merge_freeList+0x776>
  802fff:	a1 48 41 80 00       	mov    0x804148,%eax
  803004:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803007:	89 50 04             	mov    %edx,0x4(%eax)
  80300a:	eb 08                	jmp    803014 <insert_sorted_with_merge_freeList+0x77e>
  80300c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80300f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803014:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803017:	a3 48 41 80 00       	mov    %eax,0x804148
  80301c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80301f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803026:	a1 54 41 80 00       	mov    0x804154,%eax
  80302b:	40                   	inc    %eax
  80302c:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  803031:	eb 38                	jmp    80306b <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803033:	a1 40 41 80 00       	mov    0x804140,%eax
  803038:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80303b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80303f:	74 07                	je     803048 <insert_sorted_with_merge_freeList+0x7b2>
  803041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803044:	8b 00                	mov    (%eax),%eax
  803046:	eb 05                	jmp    80304d <insert_sorted_with_merge_freeList+0x7b7>
  803048:	b8 00 00 00 00       	mov    $0x0,%eax
  80304d:	a3 40 41 80 00       	mov    %eax,0x804140
  803052:	a1 40 41 80 00       	mov    0x804140,%eax
  803057:	85 c0                	test   %eax,%eax
  803059:	0f 85 ef f9 ff ff    	jne    802a4e <insert_sorted_with_merge_freeList+0x1b8>
  80305f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803063:	0f 85 e5 f9 ff ff    	jne    802a4e <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803069:	eb 00                	jmp    80306b <insert_sorted_with_merge_freeList+0x7d5>
  80306b:	90                   	nop
  80306c:	c9                   	leave  
  80306d:	c3                   	ret    

0080306e <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  80306e:	55                   	push   %ebp
  80306f:	89 e5                	mov    %esp,%ebp
  803071:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  803074:	8b 55 08             	mov    0x8(%ebp),%edx
  803077:	89 d0                	mov    %edx,%eax
  803079:	c1 e0 02             	shl    $0x2,%eax
  80307c:	01 d0                	add    %edx,%eax
  80307e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803085:	01 d0                	add    %edx,%eax
  803087:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80308e:	01 d0                	add    %edx,%eax
  803090:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803097:	01 d0                	add    %edx,%eax
  803099:	c1 e0 04             	shl    $0x4,%eax
  80309c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80309f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030a6:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030a9:	83 ec 0c             	sub    $0xc,%esp
  8030ac:	50                   	push   %eax
  8030ad:	e8 21 ec ff ff       	call   801cd3 <sys_get_virtual_time>
  8030b2:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030b5:	eb 41                	jmp    8030f8 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030b7:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030ba:	83 ec 0c             	sub    $0xc,%esp
  8030bd:	50                   	push   %eax
  8030be:	e8 10 ec ff ff       	call   801cd3 <sys_get_virtual_time>
  8030c3:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030c6:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030c9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030cc:	29 c2                	sub    %eax,%edx
  8030ce:	89 d0                	mov    %edx,%eax
  8030d0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  8030d3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d9:	89 d1                	mov    %edx,%ecx
  8030db:	29 c1                	sub    %eax,%ecx
  8030dd:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8030e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030e3:	39 c2                	cmp    %eax,%edx
  8030e5:	0f 97 c0             	seta   %al
  8030e8:	0f b6 c0             	movzbl %al,%eax
  8030eb:	29 c1                	sub    %eax,%ecx
  8030ed:	89 c8                	mov    %ecx,%eax
  8030ef:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8030f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8030f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8030f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030fb:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8030fe:	72 b7                	jb     8030b7 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803100:	90                   	nop
  803101:	c9                   	leave  
  803102:	c3                   	ret    

00803103 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803103:	55                   	push   %ebp
  803104:	89 e5                	mov    %esp,%ebp
  803106:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803109:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803110:	eb 03                	jmp    803115 <busy_wait+0x12>
  803112:	ff 45 fc             	incl   -0x4(%ebp)
  803115:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803118:	3b 45 08             	cmp    0x8(%ebp),%eax
  80311b:	72 f5                	jb     803112 <busy_wait+0xf>
	return i;
  80311d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803120:	c9                   	leave  
  803121:	c3                   	ret    
  803122:	66 90                	xchg   %ax,%ax

00803124 <__udivdi3>:
  803124:	55                   	push   %ebp
  803125:	57                   	push   %edi
  803126:	56                   	push   %esi
  803127:	53                   	push   %ebx
  803128:	83 ec 1c             	sub    $0x1c,%esp
  80312b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80312f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803133:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803137:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80313b:	89 ca                	mov    %ecx,%edx
  80313d:	89 f8                	mov    %edi,%eax
  80313f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803143:	85 f6                	test   %esi,%esi
  803145:	75 2d                	jne    803174 <__udivdi3+0x50>
  803147:	39 cf                	cmp    %ecx,%edi
  803149:	77 65                	ja     8031b0 <__udivdi3+0x8c>
  80314b:	89 fd                	mov    %edi,%ebp
  80314d:	85 ff                	test   %edi,%edi
  80314f:	75 0b                	jne    80315c <__udivdi3+0x38>
  803151:	b8 01 00 00 00       	mov    $0x1,%eax
  803156:	31 d2                	xor    %edx,%edx
  803158:	f7 f7                	div    %edi
  80315a:	89 c5                	mov    %eax,%ebp
  80315c:	31 d2                	xor    %edx,%edx
  80315e:	89 c8                	mov    %ecx,%eax
  803160:	f7 f5                	div    %ebp
  803162:	89 c1                	mov    %eax,%ecx
  803164:	89 d8                	mov    %ebx,%eax
  803166:	f7 f5                	div    %ebp
  803168:	89 cf                	mov    %ecx,%edi
  80316a:	89 fa                	mov    %edi,%edx
  80316c:	83 c4 1c             	add    $0x1c,%esp
  80316f:	5b                   	pop    %ebx
  803170:	5e                   	pop    %esi
  803171:	5f                   	pop    %edi
  803172:	5d                   	pop    %ebp
  803173:	c3                   	ret    
  803174:	39 ce                	cmp    %ecx,%esi
  803176:	77 28                	ja     8031a0 <__udivdi3+0x7c>
  803178:	0f bd fe             	bsr    %esi,%edi
  80317b:	83 f7 1f             	xor    $0x1f,%edi
  80317e:	75 40                	jne    8031c0 <__udivdi3+0x9c>
  803180:	39 ce                	cmp    %ecx,%esi
  803182:	72 0a                	jb     80318e <__udivdi3+0x6a>
  803184:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803188:	0f 87 9e 00 00 00    	ja     80322c <__udivdi3+0x108>
  80318e:	b8 01 00 00 00       	mov    $0x1,%eax
  803193:	89 fa                	mov    %edi,%edx
  803195:	83 c4 1c             	add    $0x1c,%esp
  803198:	5b                   	pop    %ebx
  803199:	5e                   	pop    %esi
  80319a:	5f                   	pop    %edi
  80319b:	5d                   	pop    %ebp
  80319c:	c3                   	ret    
  80319d:	8d 76 00             	lea    0x0(%esi),%esi
  8031a0:	31 ff                	xor    %edi,%edi
  8031a2:	31 c0                	xor    %eax,%eax
  8031a4:	89 fa                	mov    %edi,%edx
  8031a6:	83 c4 1c             	add    $0x1c,%esp
  8031a9:	5b                   	pop    %ebx
  8031aa:	5e                   	pop    %esi
  8031ab:	5f                   	pop    %edi
  8031ac:	5d                   	pop    %ebp
  8031ad:	c3                   	ret    
  8031ae:	66 90                	xchg   %ax,%ax
  8031b0:	89 d8                	mov    %ebx,%eax
  8031b2:	f7 f7                	div    %edi
  8031b4:	31 ff                	xor    %edi,%edi
  8031b6:	89 fa                	mov    %edi,%edx
  8031b8:	83 c4 1c             	add    $0x1c,%esp
  8031bb:	5b                   	pop    %ebx
  8031bc:	5e                   	pop    %esi
  8031bd:	5f                   	pop    %edi
  8031be:	5d                   	pop    %ebp
  8031bf:	c3                   	ret    
  8031c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031c5:	89 eb                	mov    %ebp,%ebx
  8031c7:	29 fb                	sub    %edi,%ebx
  8031c9:	89 f9                	mov    %edi,%ecx
  8031cb:	d3 e6                	shl    %cl,%esi
  8031cd:	89 c5                	mov    %eax,%ebp
  8031cf:	88 d9                	mov    %bl,%cl
  8031d1:	d3 ed                	shr    %cl,%ebp
  8031d3:	89 e9                	mov    %ebp,%ecx
  8031d5:	09 f1                	or     %esi,%ecx
  8031d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031db:	89 f9                	mov    %edi,%ecx
  8031dd:	d3 e0                	shl    %cl,%eax
  8031df:	89 c5                	mov    %eax,%ebp
  8031e1:	89 d6                	mov    %edx,%esi
  8031e3:	88 d9                	mov    %bl,%cl
  8031e5:	d3 ee                	shr    %cl,%esi
  8031e7:	89 f9                	mov    %edi,%ecx
  8031e9:	d3 e2                	shl    %cl,%edx
  8031eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031ef:	88 d9                	mov    %bl,%cl
  8031f1:	d3 e8                	shr    %cl,%eax
  8031f3:	09 c2                	or     %eax,%edx
  8031f5:	89 d0                	mov    %edx,%eax
  8031f7:	89 f2                	mov    %esi,%edx
  8031f9:	f7 74 24 0c          	divl   0xc(%esp)
  8031fd:	89 d6                	mov    %edx,%esi
  8031ff:	89 c3                	mov    %eax,%ebx
  803201:	f7 e5                	mul    %ebp
  803203:	39 d6                	cmp    %edx,%esi
  803205:	72 19                	jb     803220 <__udivdi3+0xfc>
  803207:	74 0b                	je     803214 <__udivdi3+0xf0>
  803209:	89 d8                	mov    %ebx,%eax
  80320b:	31 ff                	xor    %edi,%edi
  80320d:	e9 58 ff ff ff       	jmp    80316a <__udivdi3+0x46>
  803212:	66 90                	xchg   %ax,%ax
  803214:	8b 54 24 08          	mov    0x8(%esp),%edx
  803218:	89 f9                	mov    %edi,%ecx
  80321a:	d3 e2                	shl    %cl,%edx
  80321c:	39 c2                	cmp    %eax,%edx
  80321e:	73 e9                	jae    803209 <__udivdi3+0xe5>
  803220:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803223:	31 ff                	xor    %edi,%edi
  803225:	e9 40 ff ff ff       	jmp    80316a <__udivdi3+0x46>
  80322a:	66 90                	xchg   %ax,%ax
  80322c:	31 c0                	xor    %eax,%eax
  80322e:	e9 37 ff ff ff       	jmp    80316a <__udivdi3+0x46>
  803233:	90                   	nop

00803234 <__umoddi3>:
  803234:	55                   	push   %ebp
  803235:	57                   	push   %edi
  803236:	56                   	push   %esi
  803237:	53                   	push   %ebx
  803238:	83 ec 1c             	sub    $0x1c,%esp
  80323b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80323f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803243:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803247:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80324b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80324f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803253:	89 f3                	mov    %esi,%ebx
  803255:	89 fa                	mov    %edi,%edx
  803257:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80325b:	89 34 24             	mov    %esi,(%esp)
  80325e:	85 c0                	test   %eax,%eax
  803260:	75 1a                	jne    80327c <__umoddi3+0x48>
  803262:	39 f7                	cmp    %esi,%edi
  803264:	0f 86 a2 00 00 00    	jbe    80330c <__umoddi3+0xd8>
  80326a:	89 c8                	mov    %ecx,%eax
  80326c:	89 f2                	mov    %esi,%edx
  80326e:	f7 f7                	div    %edi
  803270:	89 d0                	mov    %edx,%eax
  803272:	31 d2                	xor    %edx,%edx
  803274:	83 c4 1c             	add    $0x1c,%esp
  803277:	5b                   	pop    %ebx
  803278:	5e                   	pop    %esi
  803279:	5f                   	pop    %edi
  80327a:	5d                   	pop    %ebp
  80327b:	c3                   	ret    
  80327c:	39 f0                	cmp    %esi,%eax
  80327e:	0f 87 ac 00 00 00    	ja     803330 <__umoddi3+0xfc>
  803284:	0f bd e8             	bsr    %eax,%ebp
  803287:	83 f5 1f             	xor    $0x1f,%ebp
  80328a:	0f 84 ac 00 00 00    	je     80333c <__umoddi3+0x108>
  803290:	bf 20 00 00 00       	mov    $0x20,%edi
  803295:	29 ef                	sub    %ebp,%edi
  803297:	89 fe                	mov    %edi,%esi
  803299:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80329d:	89 e9                	mov    %ebp,%ecx
  80329f:	d3 e0                	shl    %cl,%eax
  8032a1:	89 d7                	mov    %edx,%edi
  8032a3:	89 f1                	mov    %esi,%ecx
  8032a5:	d3 ef                	shr    %cl,%edi
  8032a7:	09 c7                	or     %eax,%edi
  8032a9:	89 e9                	mov    %ebp,%ecx
  8032ab:	d3 e2                	shl    %cl,%edx
  8032ad:	89 14 24             	mov    %edx,(%esp)
  8032b0:	89 d8                	mov    %ebx,%eax
  8032b2:	d3 e0                	shl    %cl,%eax
  8032b4:	89 c2                	mov    %eax,%edx
  8032b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032ba:	d3 e0                	shl    %cl,%eax
  8032bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032c4:	89 f1                	mov    %esi,%ecx
  8032c6:	d3 e8                	shr    %cl,%eax
  8032c8:	09 d0                	or     %edx,%eax
  8032ca:	d3 eb                	shr    %cl,%ebx
  8032cc:	89 da                	mov    %ebx,%edx
  8032ce:	f7 f7                	div    %edi
  8032d0:	89 d3                	mov    %edx,%ebx
  8032d2:	f7 24 24             	mull   (%esp)
  8032d5:	89 c6                	mov    %eax,%esi
  8032d7:	89 d1                	mov    %edx,%ecx
  8032d9:	39 d3                	cmp    %edx,%ebx
  8032db:	0f 82 87 00 00 00    	jb     803368 <__umoddi3+0x134>
  8032e1:	0f 84 91 00 00 00    	je     803378 <__umoddi3+0x144>
  8032e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032eb:	29 f2                	sub    %esi,%edx
  8032ed:	19 cb                	sbb    %ecx,%ebx
  8032ef:	89 d8                	mov    %ebx,%eax
  8032f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032f5:	d3 e0                	shl    %cl,%eax
  8032f7:	89 e9                	mov    %ebp,%ecx
  8032f9:	d3 ea                	shr    %cl,%edx
  8032fb:	09 d0                	or     %edx,%eax
  8032fd:	89 e9                	mov    %ebp,%ecx
  8032ff:	d3 eb                	shr    %cl,%ebx
  803301:	89 da                	mov    %ebx,%edx
  803303:	83 c4 1c             	add    $0x1c,%esp
  803306:	5b                   	pop    %ebx
  803307:	5e                   	pop    %esi
  803308:	5f                   	pop    %edi
  803309:	5d                   	pop    %ebp
  80330a:	c3                   	ret    
  80330b:	90                   	nop
  80330c:	89 fd                	mov    %edi,%ebp
  80330e:	85 ff                	test   %edi,%edi
  803310:	75 0b                	jne    80331d <__umoddi3+0xe9>
  803312:	b8 01 00 00 00       	mov    $0x1,%eax
  803317:	31 d2                	xor    %edx,%edx
  803319:	f7 f7                	div    %edi
  80331b:	89 c5                	mov    %eax,%ebp
  80331d:	89 f0                	mov    %esi,%eax
  80331f:	31 d2                	xor    %edx,%edx
  803321:	f7 f5                	div    %ebp
  803323:	89 c8                	mov    %ecx,%eax
  803325:	f7 f5                	div    %ebp
  803327:	89 d0                	mov    %edx,%eax
  803329:	e9 44 ff ff ff       	jmp    803272 <__umoddi3+0x3e>
  80332e:	66 90                	xchg   %ax,%ax
  803330:	89 c8                	mov    %ecx,%eax
  803332:	89 f2                	mov    %esi,%edx
  803334:	83 c4 1c             	add    $0x1c,%esp
  803337:	5b                   	pop    %ebx
  803338:	5e                   	pop    %esi
  803339:	5f                   	pop    %edi
  80333a:	5d                   	pop    %ebp
  80333b:	c3                   	ret    
  80333c:	3b 04 24             	cmp    (%esp),%eax
  80333f:	72 06                	jb     803347 <__umoddi3+0x113>
  803341:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803345:	77 0f                	ja     803356 <__umoddi3+0x122>
  803347:	89 f2                	mov    %esi,%edx
  803349:	29 f9                	sub    %edi,%ecx
  80334b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80334f:	89 14 24             	mov    %edx,(%esp)
  803352:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803356:	8b 44 24 04          	mov    0x4(%esp),%eax
  80335a:	8b 14 24             	mov    (%esp),%edx
  80335d:	83 c4 1c             	add    $0x1c,%esp
  803360:	5b                   	pop    %ebx
  803361:	5e                   	pop    %esi
  803362:	5f                   	pop    %edi
  803363:	5d                   	pop    %ebp
  803364:	c3                   	ret    
  803365:	8d 76 00             	lea    0x0(%esi),%esi
  803368:	2b 04 24             	sub    (%esp),%eax
  80336b:	19 fa                	sbb    %edi,%edx
  80336d:	89 d1                	mov    %edx,%ecx
  80336f:	89 c6                	mov    %eax,%esi
  803371:	e9 71 ff ff ff       	jmp    8032e7 <__umoddi3+0xb3>
  803376:	66 90                	xchg   %ax,%ax
  803378:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80337c:	72 ea                	jb     803368 <__umoddi3+0x134>
  80337e:	89 d9                	mov    %ebx,%ecx
  803380:	e9 62 ff ff ff       	jmp    8032e7 <__umoddi3+0xb3>
