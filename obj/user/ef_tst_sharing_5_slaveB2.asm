
obj/user/ef_tst_sharing_5_slaveB2:     file format elf32-i386


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
  800031:	e8 77 01 00 00       	call   8001ad <libmain>
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
  80008c:	68 c0 33 80 00       	push   $0x8033c0
  800091:	6a 12                	push   $0x12
  800093:	68 dc 33 80 00       	push   $0x8033dc
  800098:	e8 4c 02 00 00       	call   8002e9 <_panic>
	}
	uint32 *z;
	z = sget(sys_getparentenvid(),"z");
  80009d:	e8 31 1c 00 00       	call   801cd3 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 fc 33 80 00       	push   $0x8033fc
  8000aa:	50                   	push   %eax
  8000ab:	e8 dc 16 00 00       	call   80178c <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	cprintf("Slave B2 env used z (getSharedObject)\n");
  8000b6:	83 ec 0c             	sub    $0xc,%esp
  8000b9:	68 00 34 80 00       	push   $0x803400
  8000be:	e8 da 04 00 00       	call   80059d <cprintf>
  8000c3:	83 c4 10             	add    $0x10,%esp

	cprintf("Slave B2 please be patient ...\n");
  8000c6:	83 ec 0c             	sub    $0xc,%esp
  8000c9:	68 28 34 80 00       	push   $0x803428
  8000ce:	e8 ca 04 00 00       	call   80059d <cprintf>
  8000d3:	83 c4 10             	add    $0x10,%esp

	env_sleep(9000);
  8000d6:	83 ec 0c             	sub    $0xc,%esp
  8000d9:	68 28 23 00 00       	push   $0x2328
  8000de:	e8 be 2f 00 00       	call   8030a1 <env_sleep>
  8000e3:	83 c4 10             	add    $0x10,%esp
	int freeFrames = sys_calculate_free_frames() ;
  8000e6:	e8 ef 18 00 00       	call   8019da <sys_calculate_free_frames>
  8000eb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	sfree(z);
  8000ee:	83 ec 0c             	sub    $0xc,%esp
  8000f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000f4:	e8 81 17 00 00       	call   80187a <sfree>
  8000f9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave B2 env removed z\n");
  8000fc:	83 ec 0c             	sub    $0xc,%esp
  8000ff:	68 48 34 80 00       	push   $0x803448
  800104:	e8 94 04 00 00       	call   80059d <cprintf>
  800109:	83 c4 10             	add    $0x10,%esp

	if ((sys_calculate_free_frames() - freeFrames) !=  4) panic("wrong free: frames removed not equal 4 !, correct frames to be removed are 4:\nfrom the env: 1 table + 1 frame for z\nframes_storage of z: should be cleared now\n");
  80010c:	e8 c9 18 00 00       	call   8019da <sys_calculate_free_frames>
  800111:	89 c2                	mov    %eax,%edx
  800113:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800116:	29 c2                	sub    %eax,%edx
  800118:	89 d0                	mov    %edx,%eax
  80011a:	83 f8 04             	cmp    $0x4,%eax
  80011d:	74 14                	je     800133 <_main+0xfb>
  80011f:	83 ec 04             	sub    $0x4,%esp
  800122:	68 60 34 80 00       	push   $0x803460
  800127:	6a 20                	push   $0x20
  800129:	68 dc 33 80 00       	push   $0x8033dc
  80012e:	e8 b6 01 00 00       	call   8002e9 <_panic>

	//to ensure that the other environments completed successfully
	if (gettst()!=2) panic("test failed");
  800133:	e8 da 1c 00 00       	call   801e12 <gettst>
  800138:	83 f8 02             	cmp    $0x2,%eax
  80013b:	74 14                	je     800151 <_main+0x119>
  80013d:	83 ec 04             	sub    $0x4,%esp
  800140:	68 00 35 80 00       	push   $0x803500
  800145:	6a 23                	push   $0x23
  800147:	68 dc 33 80 00       	push   $0x8033dc
  80014c:	e8 98 01 00 00       	call   8002e9 <_panic>

	cprintf("Step B completed successfully!!\n\n\n");
  800151:	83 ec 0c             	sub    $0xc,%esp
  800154:	68 0c 35 80 00       	push   $0x80350c
  800159:	e8 3f 04 00 00       	call   80059d <cprintf>
  80015e:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of freeSharedObjects [5] completed successfully!!\n\n\n");
  800161:	83 ec 0c             	sub    $0xc,%esp
  800164:	68 30 35 80 00       	push   $0x803530
  800169:	e8 2f 04 00 00       	call   80059d <cprintf>
  80016e:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800171:	e8 5d 1b 00 00       	call   801cd3 <sys_getparentenvid>
  800176:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if(parentenvID > 0)
  800179:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80017d:	7e 2b                	jle    8001aa <_main+0x172>
	{
		//Get the check-finishing counter
		int *finish = NULL;
  80017f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		finish = sget(parentenvID, "finish_children") ;
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	68 7c 35 80 00       	push   $0x80357c
  80018e:	ff 75 e4             	pushl  -0x1c(%ebp)
  800191:	e8 f6 15 00 00       	call   80178c <sget>
  800196:	83 c4 10             	add    $0x10,%esp
  800199:	89 45 e0             	mov    %eax,-0x20(%ebp)
		(*finish)++ ;
  80019c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80019f:	8b 00                	mov    (%eax),%eax
  8001a1:	8d 50 01             	lea    0x1(%eax),%edx
  8001a4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001a7:	89 10                	mov    %edx,(%eax)
	}
	return;
  8001a9:	90                   	nop
  8001aa:	90                   	nop
}
  8001ab:	c9                   	leave  
  8001ac:	c3                   	ret    

008001ad <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ad:	55                   	push   %ebp
  8001ae:	89 e5                	mov    %esp,%ebp
  8001b0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001b3:	e8 02 1b 00 00       	call   801cba <sys_getenvindex>
  8001b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001be:	89 d0                	mov    %edx,%eax
  8001c0:	c1 e0 03             	shl    $0x3,%eax
  8001c3:	01 d0                	add    %edx,%eax
  8001c5:	01 c0                	add    %eax,%eax
  8001c7:	01 d0                	add    %edx,%eax
  8001c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8001d0:	01 d0                	add    %edx,%eax
  8001d2:	c1 e0 04             	shl    $0x4,%eax
  8001d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8001da:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8001df:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e4:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001ea:	84 c0                	test   %al,%al
  8001ec:	74 0f                	je     8001fd <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f3:	05 5c 05 00 00       	add    $0x55c,%eax
  8001f8:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800201:	7e 0a                	jle    80020d <libmain+0x60>
		binaryname = argv[0];
  800203:	8b 45 0c             	mov    0xc(%ebp),%eax
  800206:	8b 00                	mov    (%eax),%eax
  800208:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80020d:	83 ec 08             	sub    $0x8,%esp
  800210:	ff 75 0c             	pushl  0xc(%ebp)
  800213:	ff 75 08             	pushl  0x8(%ebp)
  800216:	e8 1d fe ff ff       	call   800038 <_main>
  80021b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80021e:	e8 a4 18 00 00       	call   801ac7 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800223:	83 ec 0c             	sub    $0xc,%esp
  800226:	68 a4 35 80 00       	push   $0x8035a4
  80022b:	e8 6d 03 00 00       	call   80059d <cprintf>
  800230:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800233:	a1 20 40 80 00       	mov    0x804020,%eax
  800238:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80023e:	a1 20 40 80 00       	mov    0x804020,%eax
  800243:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800249:	83 ec 04             	sub    $0x4,%esp
  80024c:	52                   	push   %edx
  80024d:	50                   	push   %eax
  80024e:	68 cc 35 80 00       	push   $0x8035cc
  800253:	e8 45 03 00 00       	call   80059d <cprintf>
  800258:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80025b:	a1 20 40 80 00       	mov    0x804020,%eax
  800260:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800266:	a1 20 40 80 00       	mov    0x804020,%eax
  80026b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800271:	a1 20 40 80 00       	mov    0x804020,%eax
  800276:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80027c:	51                   	push   %ecx
  80027d:	52                   	push   %edx
  80027e:	50                   	push   %eax
  80027f:	68 f4 35 80 00       	push   $0x8035f4
  800284:	e8 14 03 00 00       	call   80059d <cprintf>
  800289:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80028c:	a1 20 40 80 00       	mov    0x804020,%eax
  800291:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800297:	83 ec 08             	sub    $0x8,%esp
  80029a:	50                   	push   %eax
  80029b:	68 4c 36 80 00       	push   $0x80364c
  8002a0:	e8 f8 02 00 00       	call   80059d <cprintf>
  8002a5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002a8:	83 ec 0c             	sub    $0xc,%esp
  8002ab:	68 a4 35 80 00       	push   $0x8035a4
  8002b0:	e8 e8 02 00 00       	call   80059d <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002b8:	e8 24 18 00 00       	call   801ae1 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002bd:	e8 19 00 00 00       	call   8002db <exit>
}
  8002c2:	90                   	nop
  8002c3:	c9                   	leave  
  8002c4:	c3                   	ret    

008002c5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8002c5:	55                   	push   %ebp
  8002c6:	89 e5                	mov    %esp,%ebp
  8002c8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8002cb:	83 ec 0c             	sub    $0xc,%esp
  8002ce:	6a 00                	push   $0x0
  8002d0:	e8 b1 19 00 00       	call   801c86 <sys_destroy_env>
  8002d5:	83 c4 10             	add    $0x10,%esp
}
  8002d8:	90                   	nop
  8002d9:	c9                   	leave  
  8002da:	c3                   	ret    

008002db <exit>:

void
exit(void)
{
  8002db:	55                   	push   %ebp
  8002dc:	89 e5                	mov    %esp,%ebp
  8002de:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002e1:	e8 06 1a 00 00       	call   801cec <sys_exit_env>
}
  8002e6:	90                   	nop
  8002e7:	c9                   	leave  
  8002e8:	c3                   	ret    

008002e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8002e9:	55                   	push   %ebp
  8002ea:	89 e5                	mov    %esp,%ebp
  8002ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8002ef:	8d 45 10             	lea    0x10(%ebp),%eax
  8002f2:	83 c0 04             	add    $0x4,%eax
  8002f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8002f8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8002fd:	85 c0                	test   %eax,%eax
  8002ff:	74 16                	je     800317 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800301:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800306:	83 ec 08             	sub    $0x8,%esp
  800309:	50                   	push   %eax
  80030a:	68 60 36 80 00       	push   $0x803660
  80030f:	e8 89 02 00 00       	call   80059d <cprintf>
  800314:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800317:	a1 00 40 80 00       	mov    0x804000,%eax
  80031c:	ff 75 0c             	pushl  0xc(%ebp)
  80031f:	ff 75 08             	pushl  0x8(%ebp)
  800322:	50                   	push   %eax
  800323:	68 65 36 80 00       	push   $0x803665
  800328:	e8 70 02 00 00       	call   80059d <cprintf>
  80032d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800330:	8b 45 10             	mov    0x10(%ebp),%eax
  800333:	83 ec 08             	sub    $0x8,%esp
  800336:	ff 75 f4             	pushl  -0xc(%ebp)
  800339:	50                   	push   %eax
  80033a:	e8 f3 01 00 00       	call   800532 <vcprintf>
  80033f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800342:	83 ec 08             	sub    $0x8,%esp
  800345:	6a 00                	push   $0x0
  800347:	68 81 36 80 00       	push   $0x803681
  80034c:	e8 e1 01 00 00       	call   800532 <vcprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800354:	e8 82 ff ff ff       	call   8002db <exit>

	// should not return here
	while (1) ;
  800359:	eb fe                	jmp    800359 <_panic+0x70>

0080035b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80035b:	55                   	push   %ebp
  80035c:	89 e5                	mov    %esp,%ebp
  80035e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800361:	a1 20 40 80 00       	mov    0x804020,%eax
  800366:	8b 50 74             	mov    0x74(%eax),%edx
  800369:	8b 45 0c             	mov    0xc(%ebp),%eax
  80036c:	39 c2                	cmp    %eax,%edx
  80036e:	74 14                	je     800384 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	68 84 36 80 00       	push   $0x803684
  800378:	6a 26                	push   $0x26
  80037a:	68 d0 36 80 00       	push   $0x8036d0
  80037f:	e8 65 ff ff ff       	call   8002e9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800384:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80038b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800392:	e9 c2 00 00 00       	jmp    800459 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800397:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80039a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	8b 00                	mov    (%eax),%eax
  8003a8:	85 c0                	test   %eax,%eax
  8003aa:	75 08                	jne    8003b4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003ac:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003af:	e9 a2 00 00 00       	jmp    800456 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003c2:	eb 69                	jmp    80042d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8003c4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003c9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003d2:	89 d0                	mov    %edx,%eax
  8003d4:	01 c0                	add    %eax,%eax
  8003d6:	01 d0                	add    %edx,%eax
  8003d8:	c1 e0 03             	shl    $0x3,%eax
  8003db:	01 c8                	add    %ecx,%eax
  8003dd:	8a 40 04             	mov    0x4(%eax),%al
  8003e0:	84 c0                	test   %al,%al
  8003e2:	75 46                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003e4:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8003f2:	89 d0                	mov    %edx,%eax
  8003f4:	01 c0                	add    %eax,%eax
  8003f6:	01 d0                	add    %edx,%eax
  8003f8:	c1 e0 03             	shl    $0x3,%eax
  8003fb:	01 c8                	add    %ecx,%eax
  8003fd:	8b 00                	mov    (%eax),%eax
  8003ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800402:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800405:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80040a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80040c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80040f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800416:	8b 45 08             	mov    0x8(%ebp),%eax
  800419:	01 c8                	add    %ecx,%eax
  80041b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80041d:	39 c2                	cmp    %eax,%edx
  80041f:	75 09                	jne    80042a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800421:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800428:	eb 12                	jmp    80043c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80042a:	ff 45 e8             	incl   -0x18(%ebp)
  80042d:	a1 20 40 80 00       	mov    0x804020,%eax
  800432:	8b 50 74             	mov    0x74(%eax),%edx
  800435:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800438:	39 c2                	cmp    %eax,%edx
  80043a:	77 88                	ja     8003c4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80043c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800440:	75 14                	jne    800456 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800442:	83 ec 04             	sub    $0x4,%esp
  800445:	68 dc 36 80 00       	push   $0x8036dc
  80044a:	6a 3a                	push   $0x3a
  80044c:	68 d0 36 80 00       	push   $0x8036d0
  800451:	e8 93 fe ff ff       	call   8002e9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800456:	ff 45 f0             	incl   -0x10(%ebp)
  800459:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80045f:	0f 8c 32 ff ff ff    	jl     800397 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800465:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800473:	eb 26                	jmp    80049b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800475:	a1 20 40 80 00       	mov    0x804020,%eax
  80047a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800480:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800483:	89 d0                	mov    %edx,%eax
  800485:	01 c0                	add    %eax,%eax
  800487:	01 d0                	add    %edx,%eax
  800489:	c1 e0 03             	shl    $0x3,%eax
  80048c:	01 c8                	add    %ecx,%eax
  80048e:	8a 40 04             	mov    0x4(%eax),%al
  800491:	3c 01                	cmp    $0x1,%al
  800493:	75 03                	jne    800498 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800495:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800498:	ff 45 e0             	incl   -0x20(%ebp)
  80049b:	a1 20 40 80 00       	mov    0x804020,%eax
  8004a0:	8b 50 74             	mov    0x74(%eax),%edx
  8004a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004a6:	39 c2                	cmp    %eax,%edx
  8004a8:	77 cb                	ja     800475 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004b0:	74 14                	je     8004c6 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004b2:	83 ec 04             	sub    $0x4,%esp
  8004b5:	68 30 37 80 00       	push   $0x803730
  8004ba:	6a 44                	push   $0x44
  8004bc:	68 d0 36 80 00       	push   $0x8036d0
  8004c1:	e8 23 fe ff ff       	call   8002e9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8004c6:	90                   	nop
  8004c7:	c9                   	leave  
  8004c8:	c3                   	ret    

008004c9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8004c9:	55                   	push   %ebp
  8004ca:	89 e5                	mov    %esp,%ebp
  8004cc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8004cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004d2:	8b 00                	mov    (%eax),%eax
  8004d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8004d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004da:	89 0a                	mov    %ecx,(%edx)
  8004dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8004df:	88 d1                	mov    %dl,%cl
  8004e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004e4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8004e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004eb:	8b 00                	mov    (%eax),%eax
  8004ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8004f2:	75 2c                	jne    800520 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8004f4:	a0 24 40 80 00       	mov    0x804024,%al
  8004f9:	0f b6 c0             	movzbl %al,%eax
  8004fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004ff:	8b 12                	mov    (%edx),%edx
  800501:	89 d1                	mov    %edx,%ecx
  800503:	8b 55 0c             	mov    0xc(%ebp),%edx
  800506:	83 c2 08             	add    $0x8,%edx
  800509:	83 ec 04             	sub    $0x4,%esp
  80050c:	50                   	push   %eax
  80050d:	51                   	push   %ecx
  80050e:	52                   	push   %edx
  80050f:	e8 05 14 00 00       	call   801919 <sys_cputs>
  800514:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800517:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800520:	8b 45 0c             	mov    0xc(%ebp),%eax
  800523:	8b 40 04             	mov    0x4(%eax),%eax
  800526:	8d 50 01             	lea    0x1(%eax),%edx
  800529:	8b 45 0c             	mov    0xc(%ebp),%eax
  80052c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80052f:	90                   	nop
  800530:	c9                   	leave  
  800531:	c3                   	ret    

00800532 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800532:	55                   	push   %ebp
  800533:	89 e5                	mov    %esp,%ebp
  800535:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80053b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800542:	00 00 00 
	b.cnt = 0;
  800545:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80054c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80054f:	ff 75 0c             	pushl  0xc(%ebp)
  800552:	ff 75 08             	pushl  0x8(%ebp)
  800555:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80055b:	50                   	push   %eax
  80055c:	68 c9 04 80 00       	push   $0x8004c9
  800561:	e8 11 02 00 00       	call   800777 <vprintfmt>
  800566:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800569:	a0 24 40 80 00       	mov    0x804024,%al
  80056e:	0f b6 c0             	movzbl %al,%eax
  800571:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800577:	83 ec 04             	sub    $0x4,%esp
  80057a:	50                   	push   %eax
  80057b:	52                   	push   %edx
  80057c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800582:	83 c0 08             	add    $0x8,%eax
  800585:	50                   	push   %eax
  800586:	e8 8e 13 00 00       	call   801919 <sys_cputs>
  80058b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80058e:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800595:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80059b:	c9                   	leave  
  80059c:	c3                   	ret    

0080059d <cprintf>:

int cprintf(const char *fmt, ...) {
  80059d:	55                   	push   %ebp
  80059e:	89 e5                	mov    %esp,%ebp
  8005a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005a3:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b3:	83 ec 08             	sub    $0x8,%esp
  8005b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005b9:	50                   	push   %eax
  8005ba:	e8 73 ff ff ff       	call   800532 <vcprintf>
  8005bf:	83 c4 10             	add    $0x10,%esp
  8005c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8005c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005c8:	c9                   	leave  
  8005c9:	c3                   	ret    

008005ca <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8005ca:	55                   	push   %ebp
  8005cb:	89 e5                	mov    %esp,%ebp
  8005cd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005d0:	e8 f2 14 00 00       	call   801ac7 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8005d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005db:	8b 45 08             	mov    0x8(%ebp),%eax
  8005de:	83 ec 08             	sub    $0x8,%esp
  8005e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8005e4:	50                   	push   %eax
  8005e5:	e8 48 ff ff ff       	call   800532 <vcprintf>
  8005ea:	83 c4 10             	add    $0x10,%esp
  8005ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8005f0:	e8 ec 14 00 00       	call   801ae1 <sys_enable_interrupt>
	return cnt;
  8005f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	53                   	push   %ebx
  8005fe:	83 ec 14             	sub    $0x14,%esp
  800601:	8b 45 10             	mov    0x10(%ebp),%eax
  800604:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800607:	8b 45 14             	mov    0x14(%ebp),%eax
  80060a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80060d:	8b 45 18             	mov    0x18(%ebp),%eax
  800610:	ba 00 00 00 00       	mov    $0x0,%edx
  800615:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800618:	77 55                	ja     80066f <printnum+0x75>
  80061a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80061d:	72 05                	jb     800624 <printnum+0x2a>
  80061f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800622:	77 4b                	ja     80066f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800624:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800627:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80062a:	8b 45 18             	mov    0x18(%ebp),%eax
  80062d:	ba 00 00 00 00       	mov    $0x0,%edx
  800632:	52                   	push   %edx
  800633:	50                   	push   %eax
  800634:	ff 75 f4             	pushl  -0xc(%ebp)
  800637:	ff 75 f0             	pushl  -0x10(%ebp)
  80063a:	e8 19 2b 00 00       	call   803158 <__udivdi3>
  80063f:	83 c4 10             	add    $0x10,%esp
  800642:	83 ec 04             	sub    $0x4,%esp
  800645:	ff 75 20             	pushl  0x20(%ebp)
  800648:	53                   	push   %ebx
  800649:	ff 75 18             	pushl  0x18(%ebp)
  80064c:	52                   	push   %edx
  80064d:	50                   	push   %eax
  80064e:	ff 75 0c             	pushl  0xc(%ebp)
  800651:	ff 75 08             	pushl  0x8(%ebp)
  800654:	e8 a1 ff ff ff       	call   8005fa <printnum>
  800659:	83 c4 20             	add    $0x20,%esp
  80065c:	eb 1a                	jmp    800678 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80065e:	83 ec 08             	sub    $0x8,%esp
  800661:	ff 75 0c             	pushl  0xc(%ebp)
  800664:	ff 75 20             	pushl  0x20(%ebp)
  800667:	8b 45 08             	mov    0x8(%ebp),%eax
  80066a:	ff d0                	call   *%eax
  80066c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80066f:	ff 4d 1c             	decl   0x1c(%ebp)
  800672:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800676:	7f e6                	jg     80065e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800678:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80067b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800683:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800686:	53                   	push   %ebx
  800687:	51                   	push   %ecx
  800688:	52                   	push   %edx
  800689:	50                   	push   %eax
  80068a:	e8 d9 2b 00 00       	call   803268 <__umoddi3>
  80068f:	83 c4 10             	add    $0x10,%esp
  800692:	05 94 39 80 00       	add    $0x803994,%eax
  800697:	8a 00                	mov    (%eax),%al
  800699:	0f be c0             	movsbl %al,%eax
  80069c:	83 ec 08             	sub    $0x8,%esp
  80069f:	ff 75 0c             	pushl  0xc(%ebp)
  8006a2:	50                   	push   %eax
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	ff d0                	call   *%eax
  8006a8:	83 c4 10             	add    $0x10,%esp
}
  8006ab:	90                   	nop
  8006ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006af:	c9                   	leave  
  8006b0:	c3                   	ret    

008006b1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006b1:	55                   	push   %ebp
  8006b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006b8:	7e 1c                	jle    8006d6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  8006d4:	eb 40                	jmp    800716 <getuint+0x65>
	else if (lflag)
  8006d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006da:	74 1e                	je     8006fa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	8d 50 04             	lea    0x4(%eax),%edx
  8006e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e7:	89 10                	mov    %edx,(%eax)
  8006e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ec:	8b 00                	mov    (%eax),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 00                	mov    (%eax),%eax
  8006f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8006f8:	eb 1c                	jmp    800716 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8006fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fd:	8b 00                	mov    (%eax),%eax
  8006ff:	8d 50 04             	lea    0x4(%eax),%edx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	89 10                	mov    %edx,(%eax)
  800707:	8b 45 08             	mov    0x8(%ebp),%eax
  80070a:	8b 00                	mov    (%eax),%eax
  80070c:	83 e8 04             	sub    $0x4,%eax
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800716:	5d                   	pop    %ebp
  800717:	c3                   	ret    

00800718 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80071b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80071f:	7e 1c                	jle    80073d <getint+0x25>
		return va_arg(*ap, long long);
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8b 00                	mov    (%eax),%eax
  800726:	8d 50 08             	lea    0x8(%eax),%edx
  800729:	8b 45 08             	mov    0x8(%ebp),%eax
  80072c:	89 10                	mov    %edx,(%eax)
  80072e:	8b 45 08             	mov    0x8(%ebp),%eax
  800731:	8b 00                	mov    (%eax),%eax
  800733:	83 e8 08             	sub    $0x8,%eax
  800736:	8b 50 04             	mov    0x4(%eax),%edx
  800739:	8b 00                	mov    (%eax),%eax
  80073b:	eb 38                	jmp    800775 <getint+0x5d>
	else if (lflag)
  80073d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800741:	74 1a                	je     80075d <getint+0x45>
		return va_arg(*ap, long);
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	8b 00                	mov    (%eax),%eax
  800748:	8d 50 04             	lea    0x4(%eax),%edx
  80074b:	8b 45 08             	mov    0x8(%ebp),%eax
  80074e:	89 10                	mov    %edx,(%eax)
  800750:	8b 45 08             	mov    0x8(%ebp),%eax
  800753:	8b 00                	mov    (%eax),%eax
  800755:	83 e8 04             	sub    $0x4,%eax
  800758:	8b 00                	mov    (%eax),%eax
  80075a:	99                   	cltd   
  80075b:	eb 18                	jmp    800775 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	99                   	cltd   
}
  800775:	5d                   	pop    %ebp
  800776:	c3                   	ret    

00800777 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800777:	55                   	push   %ebp
  800778:	89 e5                	mov    %esp,%ebp
  80077a:	56                   	push   %esi
  80077b:	53                   	push   %ebx
  80077c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80077f:	eb 17                	jmp    800798 <vprintfmt+0x21>
			if (ch == '\0')
  800781:	85 db                	test   %ebx,%ebx
  800783:	0f 84 af 03 00 00    	je     800b38 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800789:	83 ec 08             	sub    $0x8,%esp
  80078c:	ff 75 0c             	pushl  0xc(%ebp)
  80078f:	53                   	push   %ebx
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	ff d0                	call   *%eax
  800795:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800798:	8b 45 10             	mov    0x10(%ebp),%eax
  80079b:	8d 50 01             	lea    0x1(%eax),%edx
  80079e:	89 55 10             	mov    %edx,0x10(%ebp)
  8007a1:	8a 00                	mov    (%eax),%al
  8007a3:	0f b6 d8             	movzbl %al,%ebx
  8007a6:	83 fb 25             	cmp    $0x25,%ebx
  8007a9:	75 d6                	jne    800781 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007ab:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007af:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8007c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8007cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ce:	8d 50 01             	lea    0x1(%eax),%edx
  8007d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8007d4:	8a 00                	mov    (%eax),%al
  8007d6:	0f b6 d8             	movzbl %al,%ebx
  8007d9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8007dc:	83 f8 55             	cmp    $0x55,%eax
  8007df:	0f 87 2b 03 00 00    	ja     800b10 <vprintfmt+0x399>
  8007e5:	8b 04 85 b8 39 80 00 	mov    0x8039b8(,%eax,4),%eax
  8007ec:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8007ee:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8007f2:	eb d7                	jmp    8007cb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8007f4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8007f8:	eb d1                	jmp    8007cb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800801:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800804:	89 d0                	mov    %edx,%eax
  800806:	c1 e0 02             	shl    $0x2,%eax
  800809:	01 d0                	add    %edx,%eax
  80080b:	01 c0                	add    %eax,%eax
  80080d:	01 d8                	add    %ebx,%eax
  80080f:	83 e8 30             	sub    $0x30,%eax
  800812:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800815:	8b 45 10             	mov    0x10(%ebp),%eax
  800818:	8a 00                	mov    (%eax),%al
  80081a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80081d:	83 fb 2f             	cmp    $0x2f,%ebx
  800820:	7e 3e                	jle    800860 <vprintfmt+0xe9>
  800822:	83 fb 39             	cmp    $0x39,%ebx
  800825:	7f 39                	jg     800860 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800827:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80082a:	eb d5                	jmp    800801 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80082c:	8b 45 14             	mov    0x14(%ebp),%eax
  80082f:	83 c0 04             	add    $0x4,%eax
  800832:	89 45 14             	mov    %eax,0x14(%ebp)
  800835:	8b 45 14             	mov    0x14(%ebp),%eax
  800838:	83 e8 04             	sub    $0x4,%eax
  80083b:	8b 00                	mov    (%eax),%eax
  80083d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800840:	eb 1f                	jmp    800861 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800842:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800846:	79 83                	jns    8007cb <vprintfmt+0x54>
				width = 0;
  800848:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80084f:	e9 77 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800854:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80085b:	e9 6b ff ff ff       	jmp    8007cb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800860:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800861:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800865:	0f 89 60 ff ff ff    	jns    8007cb <vprintfmt+0x54>
				width = precision, precision = -1;
  80086b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80086e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800871:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800878:	e9 4e ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80087d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800880:	e9 46 ff ff ff       	jmp    8007cb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800885:	8b 45 14             	mov    0x14(%ebp),%eax
  800888:	83 c0 04             	add    $0x4,%eax
  80088b:	89 45 14             	mov    %eax,0x14(%ebp)
  80088e:	8b 45 14             	mov    0x14(%ebp),%eax
  800891:	83 e8 04             	sub    $0x4,%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	83 ec 08             	sub    $0x8,%esp
  800899:	ff 75 0c             	pushl  0xc(%ebp)
  80089c:	50                   	push   %eax
  80089d:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a0:	ff d0                	call   *%eax
  8008a2:	83 c4 10             	add    $0x10,%esp
			break;
  8008a5:	e9 89 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ad:	83 c0 04             	add    $0x4,%eax
  8008b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b6:	83 e8 04             	sub    $0x4,%eax
  8008b9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008bb:	85 db                	test   %ebx,%ebx
  8008bd:	79 02                	jns    8008c1 <vprintfmt+0x14a>
				err = -err;
  8008bf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008c1:	83 fb 64             	cmp    $0x64,%ebx
  8008c4:	7f 0b                	jg     8008d1 <vprintfmt+0x15a>
  8008c6:	8b 34 9d 00 38 80 00 	mov    0x803800(,%ebx,4),%esi
  8008cd:	85 f6                	test   %esi,%esi
  8008cf:	75 19                	jne    8008ea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8008d1:	53                   	push   %ebx
  8008d2:	68 a5 39 80 00       	push   $0x8039a5
  8008d7:	ff 75 0c             	pushl  0xc(%ebp)
  8008da:	ff 75 08             	pushl  0x8(%ebp)
  8008dd:	e8 5e 02 00 00       	call   800b40 <printfmt>
  8008e2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8008e5:	e9 49 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8008ea:	56                   	push   %esi
  8008eb:	68 ae 39 80 00       	push   $0x8039ae
  8008f0:	ff 75 0c             	pushl  0xc(%ebp)
  8008f3:	ff 75 08             	pushl  0x8(%ebp)
  8008f6:	e8 45 02 00 00       	call   800b40 <printfmt>
  8008fb:	83 c4 10             	add    $0x10,%esp
			break;
  8008fe:	e9 30 02 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800903:	8b 45 14             	mov    0x14(%ebp),%eax
  800906:	83 c0 04             	add    $0x4,%eax
  800909:	89 45 14             	mov    %eax,0x14(%ebp)
  80090c:	8b 45 14             	mov    0x14(%ebp),%eax
  80090f:	83 e8 04             	sub    $0x4,%eax
  800912:	8b 30                	mov    (%eax),%esi
  800914:	85 f6                	test   %esi,%esi
  800916:	75 05                	jne    80091d <vprintfmt+0x1a6>
				p = "(null)";
  800918:	be b1 39 80 00       	mov    $0x8039b1,%esi
			if (width > 0 && padc != '-')
  80091d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800921:	7e 6d                	jle    800990 <vprintfmt+0x219>
  800923:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800927:	74 67                	je     800990 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800929:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80092c:	83 ec 08             	sub    $0x8,%esp
  80092f:	50                   	push   %eax
  800930:	56                   	push   %esi
  800931:	e8 0c 03 00 00       	call   800c42 <strnlen>
  800936:	83 c4 10             	add    $0x10,%esp
  800939:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80093c:	eb 16                	jmp    800954 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80093e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800942:	83 ec 08             	sub    $0x8,%esp
  800945:	ff 75 0c             	pushl  0xc(%ebp)
  800948:	50                   	push   %eax
  800949:	8b 45 08             	mov    0x8(%ebp),%eax
  80094c:	ff d0                	call   *%eax
  80094e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800951:	ff 4d e4             	decl   -0x1c(%ebp)
  800954:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800958:	7f e4                	jg     80093e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80095a:	eb 34                	jmp    800990 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80095c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800960:	74 1c                	je     80097e <vprintfmt+0x207>
  800962:	83 fb 1f             	cmp    $0x1f,%ebx
  800965:	7e 05                	jle    80096c <vprintfmt+0x1f5>
  800967:	83 fb 7e             	cmp    $0x7e,%ebx
  80096a:	7e 12                	jle    80097e <vprintfmt+0x207>
					putch('?', putdat);
  80096c:	83 ec 08             	sub    $0x8,%esp
  80096f:	ff 75 0c             	pushl  0xc(%ebp)
  800972:	6a 3f                	push   $0x3f
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	ff d0                	call   *%eax
  800979:	83 c4 10             	add    $0x10,%esp
  80097c:	eb 0f                	jmp    80098d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80097e:	83 ec 08             	sub    $0x8,%esp
  800981:	ff 75 0c             	pushl  0xc(%ebp)
  800984:	53                   	push   %ebx
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	ff d0                	call   *%eax
  80098a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80098d:	ff 4d e4             	decl   -0x1c(%ebp)
  800990:	89 f0                	mov    %esi,%eax
  800992:	8d 70 01             	lea    0x1(%eax),%esi
  800995:	8a 00                	mov    (%eax),%al
  800997:	0f be d8             	movsbl %al,%ebx
  80099a:	85 db                	test   %ebx,%ebx
  80099c:	74 24                	je     8009c2 <vprintfmt+0x24b>
  80099e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009a2:	78 b8                	js     80095c <vprintfmt+0x1e5>
  8009a4:	ff 4d e0             	decl   -0x20(%ebp)
  8009a7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ab:	79 af                	jns    80095c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ad:	eb 13                	jmp    8009c2 <vprintfmt+0x24b>
				putch(' ', putdat);
  8009af:	83 ec 08             	sub    $0x8,%esp
  8009b2:	ff 75 0c             	pushl  0xc(%ebp)
  8009b5:	6a 20                	push   $0x20
  8009b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ba:	ff d0                	call   *%eax
  8009bc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009bf:	ff 4d e4             	decl   -0x1c(%ebp)
  8009c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c6:	7f e7                	jg     8009af <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8009c8:	e9 66 01 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8009d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8009d6:	50                   	push   %eax
  8009d7:	e8 3c fd ff ff       	call   800718 <getint>
  8009dc:	83 c4 10             	add    $0x10,%esp
  8009df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8009e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009eb:	85 d2                	test   %edx,%edx
  8009ed:	79 23                	jns    800a12 <vprintfmt+0x29b>
				putch('-', putdat);
  8009ef:	83 ec 08             	sub    $0x8,%esp
  8009f2:	ff 75 0c             	pushl  0xc(%ebp)
  8009f5:	6a 2d                	push   $0x2d
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	ff d0                	call   *%eax
  8009fc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8009ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a05:	f7 d8                	neg    %eax
  800a07:	83 d2 00             	adc    $0x0,%edx
  800a0a:	f7 da                	neg    %edx
  800a0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a19:	e9 bc 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a1e:	83 ec 08             	sub    $0x8,%esp
  800a21:	ff 75 e8             	pushl  -0x18(%ebp)
  800a24:	8d 45 14             	lea    0x14(%ebp),%eax
  800a27:	50                   	push   %eax
  800a28:	e8 84 fc ff ff       	call   8006b1 <getuint>
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a3d:	e9 98 00 00 00       	jmp    800ada <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	6a 58                	push   $0x58
  800a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4d:	ff d0                	call   *%eax
  800a4f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a52:	83 ec 08             	sub    $0x8,%esp
  800a55:	ff 75 0c             	pushl  0xc(%ebp)
  800a58:	6a 58                	push   $0x58
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	ff d0                	call   *%eax
  800a5f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a62:	83 ec 08             	sub    $0x8,%esp
  800a65:	ff 75 0c             	pushl  0xc(%ebp)
  800a68:	6a 58                	push   $0x58
  800a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6d:	ff d0                	call   *%eax
  800a6f:	83 c4 10             	add    $0x10,%esp
			break;
  800a72:	e9 bc 00 00 00       	jmp    800b33 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800a77:	83 ec 08             	sub    $0x8,%esp
  800a7a:	ff 75 0c             	pushl  0xc(%ebp)
  800a7d:	6a 30                	push   $0x30
  800a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a82:	ff d0                	call   *%eax
  800a84:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	6a 78                	push   $0x78
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	ff d0                	call   *%eax
  800a94:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a97:	8b 45 14             	mov    0x14(%ebp),%eax
  800a9a:	83 c0 04             	add    $0x4,%eax
  800a9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800aa0:	8b 45 14             	mov    0x14(%ebp),%eax
  800aa3:	83 e8 04             	sub    $0x4,%eax
  800aa6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800aa8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ab2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ab9:	eb 1f                	jmp    800ada <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800abb:	83 ec 08             	sub    $0x8,%esp
  800abe:	ff 75 e8             	pushl  -0x18(%ebp)
  800ac1:	8d 45 14             	lea    0x14(%ebp),%eax
  800ac4:	50                   	push   %eax
  800ac5:	e8 e7 fb ff ff       	call   8006b1 <getuint>
  800aca:	83 c4 10             	add    $0x10,%esp
  800acd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ad0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800ad3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ada:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ade:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae1:	83 ec 04             	sub    $0x4,%esp
  800ae4:	52                   	push   %edx
  800ae5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	ff 75 f4             	pushl  -0xc(%ebp)
  800aec:	ff 75 f0             	pushl  -0x10(%ebp)
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 00 fb ff ff       	call   8005fa <printnum>
  800afa:	83 c4 20             	add    $0x20,%esp
			break;
  800afd:	eb 34                	jmp    800b33 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800aff:	83 ec 08             	sub    $0x8,%esp
  800b02:	ff 75 0c             	pushl  0xc(%ebp)
  800b05:	53                   	push   %ebx
  800b06:	8b 45 08             	mov    0x8(%ebp),%eax
  800b09:	ff d0                	call   *%eax
  800b0b:	83 c4 10             	add    $0x10,%esp
			break;
  800b0e:	eb 23                	jmp    800b33 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b10:	83 ec 08             	sub    $0x8,%esp
  800b13:	ff 75 0c             	pushl  0xc(%ebp)
  800b16:	6a 25                	push   $0x25
  800b18:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1b:	ff d0                	call   *%eax
  800b1d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b20:	ff 4d 10             	decl   0x10(%ebp)
  800b23:	eb 03                	jmp    800b28 <vprintfmt+0x3b1>
  800b25:	ff 4d 10             	decl   0x10(%ebp)
  800b28:	8b 45 10             	mov    0x10(%ebp),%eax
  800b2b:	48                   	dec    %eax
  800b2c:	8a 00                	mov    (%eax),%al
  800b2e:	3c 25                	cmp    $0x25,%al
  800b30:	75 f3                	jne    800b25 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b32:	90                   	nop
		}
	}
  800b33:	e9 47 fc ff ff       	jmp    80077f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b38:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b3c:	5b                   	pop    %ebx
  800b3d:	5e                   	pop    %esi
  800b3e:	5d                   	pop    %ebp
  800b3f:	c3                   	ret    

00800b40 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b40:	55                   	push   %ebp
  800b41:	89 e5                	mov    %esp,%ebp
  800b43:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b46:	8d 45 10             	lea    0x10(%ebp),%eax
  800b49:	83 c0 04             	add    $0x4,%eax
  800b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800b52:	ff 75 f4             	pushl  -0xc(%ebp)
  800b55:	50                   	push   %eax
  800b56:	ff 75 0c             	pushl  0xc(%ebp)
  800b59:	ff 75 08             	pushl  0x8(%ebp)
  800b5c:	e8 16 fc ff ff       	call   800777 <vprintfmt>
  800b61:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800b64:	90                   	nop
  800b65:	c9                   	leave  
  800b66:	c3                   	ret    

00800b67 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800b67:	55                   	push   %ebp
  800b68:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800b6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b6d:	8b 40 08             	mov    0x8(%eax),%eax
  800b70:	8d 50 01             	lea    0x1(%eax),%edx
  800b73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b76:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b7c:	8b 10                	mov    (%eax),%edx
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8b 40 04             	mov    0x4(%eax),%eax
  800b84:	39 c2                	cmp    %eax,%edx
  800b86:	73 12                	jae    800b9a <sprintputch+0x33>
		*b->buf++ = ch;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 0a                	mov    %ecx,(%edx)
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	88 10                	mov    %dl,(%eax)
}
  800b9a:	90                   	nop
  800b9b:	5d                   	pop    %ebp
  800b9c:	c3                   	ret    

00800b9d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b9d:	55                   	push   %ebp
  800b9e:	89 e5                	mov    %esp,%ebp
  800ba0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ba9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	01 d0                	add    %edx,%eax
  800bb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bc2:	74 06                	je     800bca <vsnprintf+0x2d>
  800bc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bc8:	7f 07                	jg     800bd1 <vsnprintf+0x34>
		return -E_INVAL;
  800bca:	b8 03 00 00 00       	mov    $0x3,%eax
  800bcf:	eb 20                	jmp    800bf1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800bd1:	ff 75 14             	pushl  0x14(%ebp)
  800bd4:	ff 75 10             	pushl  0x10(%ebp)
  800bd7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800bda:	50                   	push   %eax
  800bdb:	68 67 0b 80 00       	push   $0x800b67
  800be0:	e8 92 fb ff ff       	call   800777 <vprintfmt>
  800be5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800be8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800beb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800bee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800bf1:	c9                   	leave  
  800bf2:	c3                   	ret    

00800bf3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800bf3:	55                   	push   %ebp
  800bf4:	89 e5                	mov    %esp,%ebp
  800bf6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800bf9:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfc:	83 c0 04             	add    $0x4,%eax
  800bff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c02:	8b 45 10             	mov    0x10(%ebp),%eax
  800c05:	ff 75 f4             	pushl  -0xc(%ebp)
  800c08:	50                   	push   %eax
  800c09:	ff 75 0c             	pushl  0xc(%ebp)
  800c0c:	ff 75 08             	pushl  0x8(%ebp)
  800c0f:	e8 89 ff ff ff       	call   800b9d <vsnprintf>
  800c14:	83 c4 10             	add    $0x10,%esp
  800c17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c1d:	c9                   	leave  
  800c1e:	c3                   	ret    

00800c1f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c1f:	55                   	push   %ebp
  800c20:	89 e5                	mov    %esp,%ebp
  800c22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c2c:	eb 06                	jmp    800c34 <strlen+0x15>
		n++;
  800c2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c31:	ff 45 08             	incl   0x8(%ebp)
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	75 f1                	jne    800c2e <strlen+0xf>
		n++;
	return n;
  800c3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c40:	c9                   	leave  
  800c41:	c3                   	ret    

00800c42 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c42:	55                   	push   %ebp
  800c43:	89 e5                	mov    %esp,%ebp
  800c45:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c4f:	eb 09                	jmp    800c5a <strnlen+0x18>
		n++;
  800c51:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c54:	ff 45 08             	incl   0x8(%ebp)
  800c57:	ff 4d 0c             	decl   0xc(%ebp)
  800c5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c5e:	74 09                	je     800c69 <strnlen+0x27>
  800c60:	8b 45 08             	mov    0x8(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	84 c0                	test   %al,%al
  800c67:	75 e8                	jne    800c51 <strnlen+0xf>
		n++;
	return n;
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c6c:	c9                   	leave  
  800c6d:	c3                   	ret    

00800c6e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800c74:	8b 45 08             	mov    0x8(%ebp),%eax
  800c77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c7a:	90                   	nop
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8d 50 01             	lea    0x1(%eax),%edx
  800c81:	89 55 08             	mov    %edx,0x8(%ebp)
  800c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c8a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8d:	8a 12                	mov    (%edx),%dl
  800c8f:	88 10                	mov    %dl,(%eax)
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e4                	jne    800c7b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c9a:	c9                   	leave  
  800c9b:	c3                   	ret    

00800c9c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c9c:	55                   	push   %ebp
  800c9d:	89 e5                	mov    %esp,%ebp
  800c9f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ca8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800caf:	eb 1f                	jmp    800cd0 <strncpy+0x34>
		*dst++ = *src;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8d 50 01             	lea    0x1(%eax),%edx
  800cb7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc4:	8a 00                	mov    (%eax),%al
  800cc6:	84 c0                	test   %al,%al
  800cc8:	74 03                	je     800ccd <strncpy+0x31>
			src++;
  800cca:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ccd:	ff 45 fc             	incl   -0x4(%ebp)
  800cd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cd3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800cd6:	72 d9                	jb     800cb1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800cd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800cdb:	c9                   	leave  
  800cdc:	c3                   	ret    

00800cdd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800cdd:	55                   	push   %ebp
  800cde:	89 e5                	mov    %esp,%ebp
  800ce0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ce3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ce9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ced:	74 30                	je     800d1f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800cef:	eb 16                	jmp    800d07 <strlcpy+0x2a>
			*dst++ = *src++;
  800cf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf4:	8d 50 01             	lea    0x1(%eax),%edx
  800cf7:	89 55 08             	mov    %edx,0x8(%ebp)
  800cfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d00:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d03:	8a 12                	mov    (%edx),%dl
  800d05:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d07:	ff 4d 10             	decl   0x10(%ebp)
  800d0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d0e:	74 09                	je     800d19 <strlcpy+0x3c>
  800d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d13:	8a 00                	mov    (%eax),%al
  800d15:	84 c0                	test   %al,%al
  800d17:	75 d8                	jne    800cf1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d25:	29 c2                	sub    %eax,%edx
  800d27:	89 d0                	mov    %edx,%eax
}
  800d29:	c9                   	leave  
  800d2a:	c3                   	ret    

00800d2b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d2e:	eb 06                	jmp    800d36 <strcmp+0xb>
		p++, q++;
  800d30:	ff 45 08             	incl   0x8(%ebp)
  800d33:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d36:	8b 45 08             	mov    0x8(%ebp),%eax
  800d39:	8a 00                	mov    (%eax),%al
  800d3b:	84 c0                	test   %al,%al
  800d3d:	74 0e                	je     800d4d <strcmp+0x22>
  800d3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d42:	8a 10                	mov    (%eax),%dl
  800d44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d47:	8a 00                	mov    (%eax),%al
  800d49:	38 c2                	cmp    %al,%dl
  800d4b:	74 e3                	je     800d30 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f b6 d0             	movzbl %al,%edx
  800d55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d58:	8a 00                	mov    (%eax),%al
  800d5a:	0f b6 c0             	movzbl %al,%eax
  800d5d:	29 c2                	sub    %eax,%edx
  800d5f:	89 d0                	mov    %edx,%eax
}
  800d61:	5d                   	pop    %ebp
  800d62:	c3                   	ret    

00800d63 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800d63:	55                   	push   %ebp
  800d64:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800d66:	eb 09                	jmp    800d71 <strncmp+0xe>
		n--, p++, q++;
  800d68:	ff 4d 10             	decl   0x10(%ebp)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800d71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d75:	74 17                	je     800d8e <strncmp+0x2b>
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	84 c0                	test   %al,%al
  800d7e:	74 0e                	je     800d8e <strncmp+0x2b>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 10                	mov    (%eax),%dl
  800d85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	38 c2                	cmp    %al,%dl
  800d8c:	74 da                	je     800d68 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d92:	75 07                	jne    800d9b <strncmp+0x38>
		return 0;
  800d94:	b8 00 00 00 00       	mov    $0x0,%eax
  800d99:	eb 14                	jmp    800daf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	8a 00                	mov    (%eax),%al
  800da0:	0f b6 d0             	movzbl %al,%edx
  800da3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da6:	8a 00                	mov    (%eax),%al
  800da8:	0f b6 c0             	movzbl %al,%eax
  800dab:	29 c2                	sub    %eax,%edx
  800dad:	89 d0                	mov    %edx,%eax
}
  800daf:	5d                   	pop    %ebp
  800db0:	c3                   	ret    

00800db1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800db1:	55                   	push   %ebp
  800db2:	89 e5                	mov    %esp,%ebp
  800db4:	83 ec 04             	sub    $0x4,%esp
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dbd:	eb 12                	jmp    800dd1 <strchr+0x20>
		if (*s == c)
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dc7:	75 05                	jne    800dce <strchr+0x1d>
			return (char *) s;
  800dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcc:	eb 11                	jmp    800ddf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800dce:	ff 45 08             	incl   0x8(%ebp)
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	84 c0                	test   %al,%al
  800dd8:	75 e5                	jne    800dbf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800dda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ddf:	c9                   	leave  
  800de0:	c3                   	ret    

00800de1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800de1:	55                   	push   %ebp
  800de2:	89 e5                	mov    %esp,%ebp
  800de4:	83 ec 04             	sub    $0x4,%esp
  800de7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ded:	eb 0d                	jmp    800dfc <strfind+0x1b>
		if (*s == c)
  800def:	8b 45 08             	mov    0x8(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800df7:	74 0e                	je     800e07 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800df9:	ff 45 08             	incl   0x8(%ebp)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	84 c0                	test   %al,%al
  800e03:	75 ea                	jne    800def <strfind+0xe>
  800e05:	eb 01                	jmp    800e08 <strfind+0x27>
		if (*s == c)
			break;
  800e07:	90                   	nop
	return (char *) s;
  800e08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e0b:	c9                   	leave  
  800e0c:	c3                   	ret    

00800e0d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e0d:	55                   	push   %ebp
  800e0e:	89 e5                	mov    %esp,%ebp
  800e10:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e19:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e1f:	eb 0e                	jmp    800e2f <memset+0x22>
		*p++ = c;
  800e21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e24:	8d 50 01             	lea    0x1(%eax),%edx
  800e27:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e2d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e2f:	ff 4d f8             	decl   -0x8(%ebp)
  800e32:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e36:	79 e9                	jns    800e21 <memset+0x14>
		*p++ = c;

	return v;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3b:	c9                   	leave  
  800e3c:	c3                   	ret    

00800e3d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e3d:	55                   	push   %ebp
  800e3e:	89 e5                	mov    %esp,%ebp
  800e40:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e4f:	eb 16                	jmp    800e67 <memcpy+0x2a>
		*d++ = *s++;
  800e51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e5d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e60:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e63:	8a 12                	mov    (%edx),%dl
  800e65:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800e67:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800e70:	85 c0                	test   %eax,%eax
  800e72:	75 dd                	jne    800e51 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e77:	c9                   	leave  
  800e78:	c3                   	ret    

00800e79 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e79:	55                   	push   %ebp
  800e7a:	89 e5                	mov    %esp,%ebp
  800e7c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e91:	73 50                	jae    800ee3 <memmove+0x6a>
  800e93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e96:	8b 45 10             	mov    0x10(%ebp),%eax
  800e99:	01 d0                	add    %edx,%eax
  800e9b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e9e:	76 43                	jbe    800ee3 <memmove+0x6a>
		s += n;
  800ea0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ea6:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800eac:	eb 10                	jmp    800ebe <memmove+0x45>
			*--d = *--s;
  800eae:	ff 4d f8             	decl   -0x8(%ebp)
  800eb1:	ff 4d fc             	decl   -0x4(%ebp)
  800eb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eb7:	8a 10                	mov    (%eax),%dl
  800eb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ebc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800ebe:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec4:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec7:	85 c0                	test   %eax,%eax
  800ec9:	75 e3                	jne    800eae <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ecb:	eb 23                	jmp    800ef0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800ecd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed0:	8d 50 01             	lea    0x1(%eax),%edx
  800ed3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ed6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800edc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800edf:	8a 12                	mov    (%edx),%dl
  800ee1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ee9:	89 55 10             	mov    %edx,0x10(%ebp)
  800eec:	85 c0                	test   %eax,%eax
  800eee:	75 dd                	jne    800ecd <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
  800ef8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800efb:	8b 45 08             	mov    0x8(%ebp),%eax
  800efe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f04:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f07:	eb 2a                	jmp    800f33 <memcmp+0x3e>
		if (*s1 != *s2)
  800f09:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0c:	8a 10                	mov    (%eax),%dl
  800f0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	38 c2                	cmp    %al,%dl
  800f15:	74 16                	je     800f2d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f17:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	0f b6 d0             	movzbl %al,%edx
  800f1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 c0             	movzbl %al,%eax
  800f27:	29 c2                	sub    %eax,%edx
  800f29:	89 d0                	mov    %edx,%eax
  800f2b:	eb 18                	jmp    800f45 <memcmp+0x50>
		s1++, s2++;
  800f2d:	ff 45 fc             	incl   -0x4(%ebp)
  800f30:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f33:	8b 45 10             	mov    0x10(%ebp),%eax
  800f36:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f39:	89 55 10             	mov    %edx,0x10(%ebp)
  800f3c:	85 c0                	test   %eax,%eax
  800f3e:	75 c9                	jne    800f09 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f40:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f45:	c9                   	leave  
  800f46:	c3                   	ret    

00800f47 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f47:	55                   	push   %ebp
  800f48:	89 e5                	mov    %esp,%ebp
  800f4a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f4d:	8b 55 08             	mov    0x8(%ebp),%edx
  800f50:	8b 45 10             	mov    0x10(%ebp),%eax
  800f53:	01 d0                	add    %edx,%eax
  800f55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f58:	eb 15                	jmp    800f6f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	0f b6 d0             	movzbl %al,%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	0f b6 c0             	movzbl %al,%eax
  800f68:	39 c2                	cmp    %eax,%edx
  800f6a:	74 0d                	je     800f79 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800f6c:	ff 45 08             	incl   0x8(%ebp)
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800f75:	72 e3                	jb     800f5a <memfind+0x13>
  800f77:	eb 01                	jmp    800f7a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f79:	90                   	nop
	return (void *) s;
  800f7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f7d:	c9                   	leave  
  800f7e:	c3                   	ret    

00800f7f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f7f:	55                   	push   %ebp
  800f80:	89 e5                	mov    %esp,%ebp
  800f82:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f8c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f93:	eb 03                	jmp    800f98 <strtol+0x19>
		s++;
  800f95:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f98:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	3c 20                	cmp    $0x20,%al
  800f9f:	74 f4                	je     800f95 <strtol+0x16>
  800fa1:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa4:	8a 00                	mov    (%eax),%al
  800fa6:	3c 09                	cmp    $0x9,%al
  800fa8:	74 eb                	je     800f95 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800faa:	8b 45 08             	mov    0x8(%ebp),%eax
  800fad:	8a 00                	mov    (%eax),%al
  800faf:	3c 2b                	cmp    $0x2b,%al
  800fb1:	75 05                	jne    800fb8 <strtol+0x39>
		s++;
  800fb3:	ff 45 08             	incl   0x8(%ebp)
  800fb6:	eb 13                	jmp    800fcb <strtol+0x4c>
	else if (*s == '-')
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	8a 00                	mov    (%eax),%al
  800fbd:	3c 2d                	cmp    $0x2d,%al
  800fbf:	75 0a                	jne    800fcb <strtol+0x4c>
		s++, neg = 1;
  800fc1:	ff 45 08             	incl   0x8(%ebp)
  800fc4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800fcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fcf:	74 06                	je     800fd7 <strtol+0x58>
  800fd1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800fd5:	75 20                	jne    800ff7 <strtol+0x78>
  800fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fda:	8a 00                	mov    (%eax),%al
  800fdc:	3c 30                	cmp    $0x30,%al
  800fde:	75 17                	jne    800ff7 <strtol+0x78>
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	40                   	inc    %eax
  800fe4:	8a 00                	mov    (%eax),%al
  800fe6:	3c 78                	cmp    $0x78,%al
  800fe8:	75 0d                	jne    800ff7 <strtol+0x78>
		s += 2, base = 16;
  800fea:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800fee:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800ff5:	eb 28                	jmp    80101f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800ff7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ffb:	75 15                	jne    801012 <strtol+0x93>
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	3c 30                	cmp    $0x30,%al
  801004:	75 0c                	jne    801012 <strtol+0x93>
		s++, base = 8;
  801006:	ff 45 08             	incl   0x8(%ebp)
  801009:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801010:	eb 0d                	jmp    80101f <strtol+0xa0>
	else if (base == 0)
  801012:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801016:	75 07                	jne    80101f <strtol+0xa0>
		base = 10;
  801018:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80101f:	8b 45 08             	mov    0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	3c 2f                	cmp    $0x2f,%al
  801026:	7e 19                	jle    801041 <strtol+0xc2>
  801028:	8b 45 08             	mov    0x8(%ebp),%eax
  80102b:	8a 00                	mov    (%eax),%al
  80102d:	3c 39                	cmp    $0x39,%al
  80102f:	7f 10                	jg     801041 <strtol+0xc2>
			dig = *s - '0';
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	0f be c0             	movsbl %al,%eax
  801039:	83 e8 30             	sub    $0x30,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80103f:	eb 42                	jmp    801083 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801041:	8b 45 08             	mov    0x8(%ebp),%eax
  801044:	8a 00                	mov    (%eax),%al
  801046:	3c 60                	cmp    $0x60,%al
  801048:	7e 19                	jle    801063 <strtol+0xe4>
  80104a:	8b 45 08             	mov    0x8(%ebp),%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	3c 7a                	cmp    $0x7a,%al
  801051:	7f 10                	jg     801063 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801053:	8b 45 08             	mov    0x8(%ebp),%eax
  801056:	8a 00                	mov    (%eax),%al
  801058:	0f be c0             	movsbl %al,%eax
  80105b:	83 e8 57             	sub    $0x57,%eax
  80105e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801061:	eb 20                	jmp    801083 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	3c 40                	cmp    $0x40,%al
  80106a:	7e 39                	jle    8010a5 <strtol+0x126>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 5a                	cmp    $0x5a,%al
  801073:	7f 30                	jg     8010a5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801075:	8b 45 08             	mov    0x8(%ebp),%eax
  801078:	8a 00                	mov    (%eax),%al
  80107a:	0f be c0             	movsbl %al,%eax
  80107d:	83 e8 37             	sub    $0x37,%eax
  801080:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801086:	3b 45 10             	cmp    0x10(%ebp),%eax
  801089:	7d 19                	jge    8010a4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80108b:	ff 45 08             	incl   0x8(%ebp)
  80108e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801091:	0f af 45 10          	imul   0x10(%ebp),%eax
  801095:	89 c2                	mov    %eax,%edx
  801097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80109a:	01 d0                	add    %edx,%eax
  80109c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80109f:	e9 7b ff ff ff       	jmp    80101f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010a4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010a9:	74 08                	je     8010b3 <strtol+0x134>
		*endptr = (char *) s;
  8010ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8010b1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010b7:	74 07                	je     8010c0 <strtol+0x141>
  8010b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bc:	f7 d8                	neg    %eax
  8010be:	eb 03                	jmp    8010c3 <strtol+0x144>
  8010c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010c3:	c9                   	leave  
  8010c4:	c3                   	ret    

008010c5 <ltostr>:

void
ltostr(long value, char *str)
{
  8010c5:	55                   	push   %ebp
  8010c6:	89 e5                	mov    %esp,%ebp
  8010c8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8010cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8010d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8010dd:	79 13                	jns    8010f2 <ltostr+0x2d>
	{
		neg = 1;
  8010df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8010e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010e9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8010ec:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8010ef:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8010f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8010fa:	99                   	cltd   
  8010fb:	f7 f9                	idiv   %ecx
  8010fd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801100:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801103:	8d 50 01             	lea    0x1(%eax),%edx
  801106:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801109:	89 c2                	mov    %eax,%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 d0                	add    %edx,%eax
  801110:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801113:	83 c2 30             	add    $0x30,%edx
  801116:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801118:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80111b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801120:	f7 e9                	imul   %ecx
  801122:	c1 fa 02             	sar    $0x2,%edx
  801125:	89 c8                	mov    %ecx,%eax
  801127:	c1 f8 1f             	sar    $0x1f,%eax
  80112a:	29 c2                	sub    %eax,%edx
  80112c:	89 d0                	mov    %edx,%eax
  80112e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801131:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801134:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801139:	f7 e9                	imul   %ecx
  80113b:	c1 fa 02             	sar    $0x2,%edx
  80113e:	89 c8                	mov    %ecx,%eax
  801140:	c1 f8 1f             	sar    $0x1f,%eax
  801143:	29 c2                	sub    %eax,%edx
  801145:	89 d0                	mov    %edx,%eax
  801147:	c1 e0 02             	shl    $0x2,%eax
  80114a:	01 d0                	add    %edx,%eax
  80114c:	01 c0                	add    %eax,%eax
  80114e:	29 c1                	sub    %eax,%ecx
  801150:	89 ca                	mov    %ecx,%edx
  801152:	85 d2                	test   %edx,%edx
  801154:	75 9c                	jne    8010f2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801156:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80115d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801160:	48                   	dec    %eax
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801164:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801168:	74 3d                	je     8011a7 <ltostr+0xe2>
		start = 1 ;
  80116a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801171:	eb 34                	jmp    8011a7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801173:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801176:	8b 45 0c             	mov    0xc(%ebp),%eax
  801179:	01 d0                	add    %edx,%eax
  80117b:	8a 00                	mov    (%eax),%al
  80117d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801180:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801183:	8b 45 0c             	mov    0xc(%ebp),%eax
  801186:	01 c2                	add    %eax,%edx
  801188:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80118b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118e:	01 c8                	add    %ecx,%eax
  801190:	8a 00                	mov    (%eax),%al
  801192:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801194:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	01 c2                	add    %eax,%edx
  80119c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80119f:	88 02                	mov    %al,(%edx)
		start++ ;
  8011a1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011a4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ad:	7c c4                	jl     801173 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011af:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011ba:	90                   	nop
  8011bb:	c9                   	leave  
  8011bc:	c3                   	ret    

008011bd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011bd:	55                   	push   %ebp
  8011be:	89 e5                	mov    %esp,%ebp
  8011c0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8011c3:	ff 75 08             	pushl  0x8(%ebp)
  8011c6:	e8 54 fa ff ff       	call   800c1f <strlen>
  8011cb:	83 c4 04             	add    $0x4,%esp
  8011ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8011d1:	ff 75 0c             	pushl  0xc(%ebp)
  8011d4:	e8 46 fa ff ff       	call   800c1f <strlen>
  8011d9:	83 c4 04             	add    $0x4,%esp
  8011dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8011df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8011e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8011ed:	eb 17                	jmp    801206 <strcconcat+0x49>
		final[s] = str1[s] ;
  8011ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f5:	01 c2                	add    %eax,%edx
  8011f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8011fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fd:	01 c8                	add    %ecx,%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801203:	ff 45 fc             	incl   -0x4(%ebp)
  801206:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801209:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80120c:	7c e1                	jl     8011ef <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80120e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801215:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80121c:	eb 1f                	jmp    80123d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80121e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801221:	8d 50 01             	lea    0x1(%eax),%edx
  801224:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801227:	89 c2                	mov    %eax,%edx
  801229:	8b 45 10             	mov    0x10(%ebp),%eax
  80122c:	01 c2                	add    %eax,%edx
  80122e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801231:	8b 45 0c             	mov    0xc(%ebp),%eax
  801234:	01 c8                	add    %ecx,%eax
  801236:	8a 00                	mov    (%eax),%al
  801238:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80123a:	ff 45 f8             	incl   -0x8(%ebp)
  80123d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801240:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801243:	7c d9                	jl     80121e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801245:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801248:	8b 45 10             	mov    0x10(%ebp),%eax
  80124b:	01 d0                	add    %edx,%eax
  80124d:	c6 00 00             	movb   $0x0,(%eax)
}
  801250:	90                   	nop
  801251:	c9                   	leave  
  801252:	c3                   	ret    

00801253 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801253:	55                   	push   %ebp
  801254:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801256:	8b 45 14             	mov    0x14(%ebp),%eax
  801259:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80125f:	8b 45 14             	mov    0x14(%ebp),%eax
  801262:	8b 00                	mov    (%eax),%eax
  801264:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80126b:	8b 45 10             	mov    0x10(%ebp),%eax
  80126e:	01 d0                	add    %edx,%eax
  801270:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801276:	eb 0c                	jmp    801284 <strsplit+0x31>
			*string++ = 0;
  801278:	8b 45 08             	mov    0x8(%ebp),%eax
  80127b:	8d 50 01             	lea    0x1(%eax),%edx
  80127e:	89 55 08             	mov    %edx,0x8(%ebp)
  801281:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801284:	8b 45 08             	mov    0x8(%ebp),%eax
  801287:	8a 00                	mov    (%eax),%al
  801289:	84 c0                	test   %al,%al
  80128b:	74 18                	je     8012a5 <strsplit+0x52>
  80128d:	8b 45 08             	mov    0x8(%ebp),%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	0f be c0             	movsbl %al,%eax
  801295:	50                   	push   %eax
  801296:	ff 75 0c             	pushl  0xc(%ebp)
  801299:	e8 13 fb ff ff       	call   800db1 <strchr>
  80129e:	83 c4 08             	add    $0x8,%esp
  8012a1:	85 c0                	test   %eax,%eax
  8012a3:	75 d3                	jne    801278 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a8:	8a 00                	mov    (%eax),%al
  8012aa:	84 c0                	test   %al,%al
  8012ac:	74 5a                	je     801308 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8012b1:	8b 00                	mov    (%eax),%eax
  8012b3:	83 f8 0f             	cmp    $0xf,%eax
  8012b6:	75 07                	jne    8012bf <strsplit+0x6c>
		{
			return 0;
  8012b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8012bd:	eb 66                	jmp    801325 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8012c2:	8b 00                	mov    (%eax),%eax
  8012c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8012c7:	8b 55 14             	mov    0x14(%ebp),%edx
  8012ca:	89 0a                	mov    %ecx,(%edx)
  8012cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d6:	01 c2                	add    %eax,%edx
  8012d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8012db:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012dd:	eb 03                	jmp    8012e2 <strsplit+0x8f>
			string++;
  8012df:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 8b                	je     801276 <strsplit+0x23>
  8012eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ee:	8a 00                	mov    (%eax),%al
  8012f0:	0f be c0             	movsbl %al,%eax
  8012f3:	50                   	push   %eax
  8012f4:	ff 75 0c             	pushl  0xc(%ebp)
  8012f7:	e8 b5 fa ff ff       	call   800db1 <strchr>
  8012fc:	83 c4 08             	add    $0x8,%esp
  8012ff:	85 c0                	test   %eax,%eax
  801301:	74 dc                	je     8012df <strsplit+0x8c>
			string++;
	}
  801303:	e9 6e ff ff ff       	jmp    801276 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801308:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801309:	8b 45 14             	mov    0x14(%ebp),%eax
  80130c:	8b 00                	mov    (%eax),%eax
  80130e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801315:	8b 45 10             	mov    0x10(%ebp),%eax
  801318:	01 d0                	add    %edx,%eax
  80131a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801320:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801325:	c9                   	leave  
  801326:	c3                   	ret    

00801327 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801327:	55                   	push   %ebp
  801328:	89 e5                	mov    %esp,%ebp
  80132a:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80132d:	a1 04 40 80 00       	mov    0x804004,%eax
  801332:	85 c0                	test   %eax,%eax
  801334:	74 1f                	je     801355 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801336:	e8 1d 00 00 00       	call   801358 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80133b:	83 ec 0c             	sub    $0xc,%esp
  80133e:	68 10 3b 80 00       	push   $0x803b10
  801343:	e8 55 f2 ff ff       	call   80059d <cprintf>
  801348:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80134b:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801352:	00 00 00 
	}
}
  801355:	90                   	nop
  801356:	c9                   	leave  
  801357:	c3                   	ret    

00801358 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801358:	55                   	push   %ebp
  801359:	89 e5                	mov    %esp,%ebp
  80135b:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  80135e:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801365:	00 00 00 
  801368:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80136f:	00 00 00 
  801372:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801379:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80137c:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801383:	00 00 00 
  801386:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80138d:	00 00 00 
  801390:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801397:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  80139a:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  8013a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a4:	c1 e8 0c             	shr    $0xc,%eax
  8013a7:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  8013ac:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8013b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013b6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013bb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013c0:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  8013c5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8013cc:	a1 20 41 80 00       	mov    0x804120,%eax
  8013d1:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8013d5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8013d8:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8013df:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8013e2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8013e5:	01 d0                	add    %edx,%eax
  8013e7:	48                   	dec    %eax
  8013e8:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8013eb:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8013f3:	f7 75 e4             	divl   -0x1c(%ebp)
  8013f6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8013f9:	29 d0                	sub    %edx,%eax
  8013fb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8013fe:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801405:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801408:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80140d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801412:	83 ec 04             	sub    $0x4,%esp
  801415:	6a 07                	push   $0x7
  801417:	ff 75 e8             	pushl  -0x18(%ebp)
  80141a:	50                   	push   %eax
  80141b:	e8 3d 06 00 00       	call   801a5d <sys_allocate_chunk>
  801420:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801423:	a1 20 41 80 00       	mov    0x804120,%eax
  801428:	83 ec 0c             	sub    $0xc,%esp
  80142b:	50                   	push   %eax
  80142c:	e8 b2 0c 00 00       	call   8020e3 <initialize_MemBlocksList>
  801431:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801434:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801439:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  80143c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801440:	0f 84 f3 00 00 00    	je     801539 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801446:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80144a:	75 14                	jne    801460 <initialize_dyn_block_system+0x108>
  80144c:	83 ec 04             	sub    $0x4,%esp
  80144f:	68 35 3b 80 00       	push   $0x803b35
  801454:	6a 36                	push   $0x36
  801456:	68 53 3b 80 00       	push   $0x803b53
  80145b:	e8 89 ee ff ff       	call   8002e9 <_panic>
  801460:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801463:	8b 00                	mov    (%eax),%eax
  801465:	85 c0                	test   %eax,%eax
  801467:	74 10                	je     801479 <initialize_dyn_block_system+0x121>
  801469:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80146c:	8b 00                	mov    (%eax),%eax
  80146e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801471:	8b 52 04             	mov    0x4(%edx),%edx
  801474:	89 50 04             	mov    %edx,0x4(%eax)
  801477:	eb 0b                	jmp    801484 <initialize_dyn_block_system+0x12c>
  801479:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80147c:	8b 40 04             	mov    0x4(%eax),%eax
  80147f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801484:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801487:	8b 40 04             	mov    0x4(%eax),%eax
  80148a:	85 c0                	test   %eax,%eax
  80148c:	74 0f                	je     80149d <initialize_dyn_block_system+0x145>
  80148e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801491:	8b 40 04             	mov    0x4(%eax),%eax
  801494:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801497:	8b 12                	mov    (%edx),%edx
  801499:	89 10                	mov    %edx,(%eax)
  80149b:	eb 0a                	jmp    8014a7 <initialize_dyn_block_system+0x14f>
  80149d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014a0:	8b 00                	mov    (%eax),%eax
  8014a2:	a3 48 41 80 00       	mov    %eax,0x804148
  8014a7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014aa:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014b0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014ba:	a1 54 41 80 00       	mov    0x804154,%eax
  8014bf:	48                   	dec    %eax
  8014c0:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  8014c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014c8:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8014cf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014d2:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8014d9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014dd:	75 14                	jne    8014f3 <initialize_dyn_block_system+0x19b>
  8014df:	83 ec 04             	sub    $0x4,%esp
  8014e2:	68 60 3b 80 00       	push   $0x803b60
  8014e7:	6a 3e                	push   $0x3e
  8014e9:	68 53 3b 80 00       	push   $0x803b53
  8014ee:	e8 f6 ed ff ff       	call   8002e9 <_panic>
  8014f3:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8014f9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014fc:	89 10                	mov    %edx,(%eax)
  8014fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801501:	8b 00                	mov    (%eax),%eax
  801503:	85 c0                	test   %eax,%eax
  801505:	74 0d                	je     801514 <initialize_dyn_block_system+0x1bc>
  801507:	a1 38 41 80 00       	mov    0x804138,%eax
  80150c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80150f:	89 50 04             	mov    %edx,0x4(%eax)
  801512:	eb 08                	jmp    80151c <initialize_dyn_block_system+0x1c4>
  801514:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801517:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80151c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80151f:	a3 38 41 80 00       	mov    %eax,0x804138
  801524:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801527:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80152e:	a1 44 41 80 00       	mov    0x804144,%eax
  801533:	40                   	inc    %eax
  801534:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  801539:	90                   	nop
  80153a:	c9                   	leave  
  80153b:	c3                   	ret    

0080153c <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80153c:	55                   	push   %ebp
  80153d:	89 e5                	mov    %esp,%ebp
  80153f:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801542:	e8 e0 fd ff ff       	call   801327 <InitializeUHeap>
		if (size == 0) return NULL ;
  801547:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80154b:	75 07                	jne    801554 <malloc+0x18>
  80154d:	b8 00 00 00 00       	mov    $0x0,%eax
  801552:	eb 7f                	jmp    8015d3 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801554:	e8 d2 08 00 00       	call   801e2b <sys_isUHeapPlacementStrategyFIRSTFIT>
  801559:	85 c0                	test   %eax,%eax
  80155b:	74 71                	je     8015ce <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  80155d:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801564:	8b 55 08             	mov    0x8(%ebp),%edx
  801567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80156a:	01 d0                	add    %edx,%eax
  80156c:	48                   	dec    %eax
  80156d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801570:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801573:	ba 00 00 00 00       	mov    $0x0,%edx
  801578:	f7 75 f4             	divl   -0xc(%ebp)
  80157b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80157e:	29 d0                	sub    %edx,%eax
  801580:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801583:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  80158a:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801591:	76 07                	jbe    80159a <malloc+0x5e>
					return NULL ;
  801593:	b8 00 00 00 00       	mov    $0x0,%eax
  801598:	eb 39                	jmp    8015d3 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  80159a:	83 ec 0c             	sub    $0xc,%esp
  80159d:	ff 75 08             	pushl  0x8(%ebp)
  8015a0:	e8 e6 0d 00 00       	call   80238b <alloc_block_FF>
  8015a5:	83 c4 10             	add    $0x10,%esp
  8015a8:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  8015ab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015af:	74 16                	je     8015c7 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  8015b1:	83 ec 0c             	sub    $0xc,%esp
  8015b4:	ff 75 ec             	pushl  -0x14(%ebp)
  8015b7:	e8 37 0c 00 00       	call   8021f3 <insert_sorted_allocList>
  8015bc:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  8015bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015c2:	8b 40 08             	mov    0x8(%eax),%eax
  8015c5:	eb 0c                	jmp    8015d3 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8015c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8015cc:	eb 05                	jmp    8015d3 <malloc+0x97>
				}
		}
	return 0;
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8015d3:	c9                   	leave  
  8015d4:	c3                   	ret    

008015d5 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8015d5:	55                   	push   %ebp
  8015d6:	89 e5                	mov    %esp,%ebp
  8015d8:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8015e1:	83 ec 08             	sub    $0x8,%esp
  8015e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8015e7:	68 40 40 80 00       	push   $0x804040
  8015ec:	e8 cf 0b 00 00       	call   8021c0 <find_block>
  8015f1:	83 c4 10             	add    $0x10,%esp
  8015f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8015f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8015fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801603:	8b 40 08             	mov    0x8(%eax),%eax
  801606:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801609:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80160d:	0f 84 a1 00 00 00    	je     8016b4 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801613:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801617:	75 17                	jne    801630 <free+0x5b>
  801619:	83 ec 04             	sub    $0x4,%esp
  80161c:	68 35 3b 80 00       	push   $0x803b35
  801621:	68 80 00 00 00       	push   $0x80
  801626:	68 53 3b 80 00       	push   $0x803b53
  80162b:	e8 b9 ec ff ff       	call   8002e9 <_panic>
  801630:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801633:	8b 00                	mov    (%eax),%eax
  801635:	85 c0                	test   %eax,%eax
  801637:	74 10                	je     801649 <free+0x74>
  801639:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80163c:	8b 00                	mov    (%eax),%eax
  80163e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801641:	8b 52 04             	mov    0x4(%edx),%edx
  801644:	89 50 04             	mov    %edx,0x4(%eax)
  801647:	eb 0b                	jmp    801654 <free+0x7f>
  801649:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164c:	8b 40 04             	mov    0x4(%eax),%eax
  80164f:	a3 44 40 80 00       	mov    %eax,0x804044
  801654:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801657:	8b 40 04             	mov    0x4(%eax),%eax
  80165a:	85 c0                	test   %eax,%eax
  80165c:	74 0f                	je     80166d <free+0x98>
  80165e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801661:	8b 40 04             	mov    0x4(%eax),%eax
  801664:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801667:	8b 12                	mov    (%edx),%edx
  801669:	89 10                	mov    %edx,(%eax)
  80166b:	eb 0a                	jmp    801677 <free+0xa2>
  80166d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801670:	8b 00                	mov    (%eax),%eax
  801672:	a3 40 40 80 00       	mov    %eax,0x804040
  801677:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801680:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801683:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80168a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80168f:	48                   	dec    %eax
  801690:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  801695:	83 ec 0c             	sub    $0xc,%esp
  801698:	ff 75 f0             	pushl  -0x10(%ebp)
  80169b:	e8 29 12 00 00       	call   8028c9 <insert_sorted_with_merge_freeList>
  8016a0:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  8016a3:	83 ec 08             	sub    $0x8,%esp
  8016a6:	ff 75 ec             	pushl  -0x14(%ebp)
  8016a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8016ac:	e8 74 03 00 00       	call   801a25 <sys_free_user_mem>
  8016b1:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8016b4:	90                   	nop
  8016b5:	c9                   	leave  
  8016b6:	c3                   	ret    

008016b7 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  8016b7:	55                   	push   %ebp
  8016b8:	89 e5                	mov    %esp,%ebp
  8016ba:	83 ec 38             	sub    $0x38,%esp
  8016bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8016c0:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8016c3:	e8 5f fc ff ff       	call   801327 <InitializeUHeap>
	if (size == 0) return NULL ;
  8016c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016cc:	75 0a                	jne    8016d8 <smalloc+0x21>
  8016ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d3:	e9 b2 00 00 00       	jmp    80178a <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8016d8:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8016df:	76 0a                	jbe    8016eb <smalloc+0x34>
		return NULL;
  8016e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8016e6:	e9 9f 00 00 00       	jmp    80178a <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8016eb:	e8 3b 07 00 00       	call   801e2b <sys_isUHeapPlacementStrategyFIRSTFIT>
  8016f0:	85 c0                	test   %eax,%eax
  8016f2:	0f 84 8d 00 00 00    	je     801785 <smalloc+0xce>
	struct MemBlock *b = NULL;
  8016f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8016ff:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801706:	8b 55 0c             	mov    0xc(%ebp),%edx
  801709:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170c:	01 d0                	add    %edx,%eax
  80170e:	48                   	dec    %eax
  80170f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801712:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801715:	ba 00 00 00 00       	mov    $0x0,%edx
  80171a:	f7 75 f0             	divl   -0x10(%ebp)
  80171d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801720:	29 d0                	sub    %edx,%eax
  801722:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801725:	83 ec 0c             	sub    $0xc,%esp
  801728:	ff 75 e8             	pushl  -0x18(%ebp)
  80172b:	e8 5b 0c 00 00       	call   80238b <alloc_block_FF>
  801730:	83 c4 10             	add    $0x10,%esp
  801733:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801736:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80173a:	75 07                	jne    801743 <smalloc+0x8c>
			return NULL;
  80173c:	b8 00 00 00 00       	mov    $0x0,%eax
  801741:	eb 47                	jmp    80178a <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801743:	83 ec 0c             	sub    $0xc,%esp
  801746:	ff 75 f4             	pushl  -0xc(%ebp)
  801749:	e8 a5 0a 00 00       	call   8021f3 <insert_sorted_allocList>
  80174e:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801751:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801754:	8b 40 08             	mov    0x8(%eax),%eax
  801757:	89 c2                	mov    %eax,%edx
  801759:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80175d:	52                   	push   %edx
  80175e:	50                   	push   %eax
  80175f:	ff 75 0c             	pushl  0xc(%ebp)
  801762:	ff 75 08             	pushl  0x8(%ebp)
  801765:	e8 46 04 00 00       	call   801bb0 <sys_createSharedObject>
  80176a:	83 c4 10             	add    $0x10,%esp
  80176d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801770:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801774:	78 08                	js     80177e <smalloc+0xc7>
		return (void *)b->sva;
  801776:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801779:	8b 40 08             	mov    0x8(%eax),%eax
  80177c:	eb 0c                	jmp    80178a <smalloc+0xd3>
		}else{
		return NULL;
  80177e:	b8 00 00 00 00       	mov    $0x0,%eax
  801783:	eb 05                	jmp    80178a <smalloc+0xd3>
			}

	}return NULL;
  801785:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80178a:	c9                   	leave  
  80178b:	c3                   	ret    

0080178c <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80178c:	55                   	push   %ebp
  80178d:	89 e5                	mov    %esp,%ebp
  80178f:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801792:	e8 90 fb ff ff       	call   801327 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801797:	e8 8f 06 00 00       	call   801e2b <sys_isUHeapPlacementStrategyFIRSTFIT>
  80179c:	85 c0                	test   %eax,%eax
  80179e:	0f 84 ad 00 00 00    	je     801851 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017a4:	83 ec 08             	sub    $0x8,%esp
  8017a7:	ff 75 0c             	pushl  0xc(%ebp)
  8017aa:	ff 75 08             	pushl  0x8(%ebp)
  8017ad:	e8 28 04 00 00       	call   801bda <sys_getSizeOfSharedObject>
  8017b2:	83 c4 10             	add    $0x10,%esp
  8017b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  8017b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017bc:	79 0a                	jns    8017c8 <sget+0x3c>
    {
    	return NULL;
  8017be:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c3:	e9 8e 00 00 00       	jmp    801856 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  8017c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  8017cf:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8017d6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017d9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017dc:	01 d0                	add    %edx,%eax
  8017de:	48                   	dec    %eax
  8017df:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8017e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ea:	f7 75 ec             	divl   -0x14(%ebp)
  8017ed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017f0:	29 d0                	sub    %edx,%eax
  8017f2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8017f5:	83 ec 0c             	sub    $0xc,%esp
  8017f8:	ff 75 e4             	pushl  -0x1c(%ebp)
  8017fb:	e8 8b 0b 00 00       	call   80238b <alloc_block_FF>
  801800:	83 c4 10             	add    $0x10,%esp
  801803:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801806:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80180a:	75 07                	jne    801813 <sget+0x87>
				return NULL;
  80180c:	b8 00 00 00 00       	mov    $0x0,%eax
  801811:	eb 43                	jmp    801856 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801813:	83 ec 0c             	sub    $0xc,%esp
  801816:	ff 75 f0             	pushl  -0x10(%ebp)
  801819:	e8 d5 09 00 00       	call   8021f3 <insert_sorted_allocList>
  80181e:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801821:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801824:	8b 40 08             	mov    0x8(%eax),%eax
  801827:	83 ec 04             	sub    $0x4,%esp
  80182a:	50                   	push   %eax
  80182b:	ff 75 0c             	pushl  0xc(%ebp)
  80182e:	ff 75 08             	pushl  0x8(%ebp)
  801831:	e8 c1 03 00 00       	call   801bf7 <sys_getSharedObject>
  801836:	83 c4 10             	add    $0x10,%esp
  801839:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  80183c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801840:	78 08                	js     80184a <sget+0xbe>
			return (void *)b->sva;
  801842:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801845:	8b 40 08             	mov    0x8(%eax),%eax
  801848:	eb 0c                	jmp    801856 <sget+0xca>
			}else{
			return NULL;
  80184a:	b8 00 00 00 00       	mov    $0x0,%eax
  80184f:	eb 05                	jmp    801856 <sget+0xca>
			}
    }}return NULL;
  801851:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
  80185b:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80185e:	e8 c4 fa ff ff       	call   801327 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801863:	83 ec 04             	sub    $0x4,%esp
  801866:	68 84 3b 80 00       	push   $0x803b84
  80186b:	68 03 01 00 00       	push   $0x103
  801870:	68 53 3b 80 00       	push   $0x803b53
  801875:	e8 6f ea ff ff       	call   8002e9 <_panic>

0080187a <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80187a:	55                   	push   %ebp
  80187b:	89 e5                	mov    %esp,%ebp
  80187d:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801880:	83 ec 04             	sub    $0x4,%esp
  801883:	68 ac 3b 80 00       	push   $0x803bac
  801888:	68 17 01 00 00       	push   $0x117
  80188d:	68 53 3b 80 00       	push   $0x803b53
  801892:	e8 52 ea ff ff       	call   8002e9 <_panic>

00801897 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
  80189a:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80189d:	83 ec 04             	sub    $0x4,%esp
  8018a0:	68 d0 3b 80 00       	push   $0x803bd0
  8018a5:	68 22 01 00 00       	push   $0x122
  8018aa:	68 53 3b 80 00       	push   $0x803b53
  8018af:	e8 35 ea ff ff       	call   8002e9 <_panic>

008018b4 <shrink>:

}
void shrink(uint32 newSize)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
  8018b7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018ba:	83 ec 04             	sub    $0x4,%esp
  8018bd:	68 d0 3b 80 00       	push   $0x803bd0
  8018c2:	68 27 01 00 00       	push   $0x127
  8018c7:	68 53 3b 80 00       	push   $0x803b53
  8018cc:	e8 18 ea ff ff       	call   8002e9 <_panic>

008018d1 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
  8018d4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018d7:	83 ec 04             	sub    $0x4,%esp
  8018da:	68 d0 3b 80 00       	push   $0x803bd0
  8018df:	68 2c 01 00 00       	push   $0x12c
  8018e4:	68 53 3b 80 00       	push   $0x803b53
  8018e9:	e8 fb e9 ff ff       	call   8002e9 <_panic>

008018ee <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8018ee:	55                   	push   %ebp
  8018ef:	89 e5                	mov    %esp,%ebp
  8018f1:	57                   	push   %edi
  8018f2:	56                   	push   %esi
  8018f3:	53                   	push   %ebx
  8018f4:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801900:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801903:	8b 7d 18             	mov    0x18(%ebp),%edi
  801906:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801909:	cd 30                	int    $0x30
  80190b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80190e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801911:	83 c4 10             	add    $0x10,%esp
  801914:	5b                   	pop    %ebx
  801915:	5e                   	pop    %esi
  801916:	5f                   	pop    %edi
  801917:	5d                   	pop    %ebp
  801918:	c3                   	ret    

00801919 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
  80191c:	83 ec 04             	sub    $0x4,%esp
  80191f:	8b 45 10             	mov    0x10(%ebp),%eax
  801922:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801925:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801929:	8b 45 08             	mov    0x8(%ebp),%eax
  80192c:	6a 00                	push   $0x0
  80192e:	6a 00                	push   $0x0
  801930:	52                   	push   %edx
  801931:	ff 75 0c             	pushl  0xc(%ebp)
  801934:	50                   	push   %eax
  801935:	6a 00                	push   $0x0
  801937:	e8 b2 ff ff ff       	call   8018ee <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	90                   	nop
  801940:	c9                   	leave  
  801941:	c3                   	ret    

00801942 <sys_cgetc>:

int
sys_cgetc(void)
{
  801942:	55                   	push   %ebp
  801943:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801945:	6a 00                	push   $0x0
  801947:	6a 00                	push   $0x0
  801949:	6a 00                	push   $0x0
  80194b:	6a 00                	push   $0x0
  80194d:	6a 00                	push   $0x0
  80194f:	6a 01                	push   $0x1
  801951:	e8 98 ff ff ff       	call   8018ee <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
}
  801959:	c9                   	leave  
  80195a:	c3                   	ret    

0080195b <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80195e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801961:	8b 45 08             	mov    0x8(%ebp),%eax
  801964:	6a 00                	push   $0x0
  801966:	6a 00                	push   $0x0
  801968:	6a 00                	push   $0x0
  80196a:	52                   	push   %edx
  80196b:	50                   	push   %eax
  80196c:	6a 05                	push   $0x5
  80196e:	e8 7b ff ff ff       	call   8018ee <syscall>
  801973:	83 c4 18             	add    $0x18,%esp
}
  801976:	c9                   	leave  
  801977:	c3                   	ret    

00801978 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	56                   	push   %esi
  80197c:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80197d:	8b 75 18             	mov    0x18(%ebp),%esi
  801980:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801983:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801986:	8b 55 0c             	mov    0xc(%ebp),%edx
  801989:	8b 45 08             	mov    0x8(%ebp),%eax
  80198c:	56                   	push   %esi
  80198d:	53                   	push   %ebx
  80198e:	51                   	push   %ecx
  80198f:	52                   	push   %edx
  801990:	50                   	push   %eax
  801991:	6a 06                	push   $0x6
  801993:	e8 56 ff ff ff       	call   8018ee <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80199e:	5b                   	pop    %ebx
  80199f:	5e                   	pop    %esi
  8019a0:	5d                   	pop    %ebp
  8019a1:	c3                   	ret    

008019a2 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019a5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ab:	6a 00                	push   $0x0
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	52                   	push   %edx
  8019b2:	50                   	push   %eax
  8019b3:	6a 07                	push   $0x7
  8019b5:	e8 34 ff ff ff       	call   8018ee <syscall>
  8019ba:	83 c4 18             	add    $0x18,%esp
}
  8019bd:	c9                   	leave  
  8019be:	c3                   	ret    

008019bf <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019bf:	55                   	push   %ebp
  8019c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	ff 75 0c             	pushl  0xc(%ebp)
  8019cb:	ff 75 08             	pushl  0x8(%ebp)
  8019ce:	6a 08                	push   $0x8
  8019d0:	e8 19 ff ff ff       	call   8018ee <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	c9                   	leave  
  8019d9:	c3                   	ret    

008019da <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8019da:	55                   	push   %ebp
  8019db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8019dd:	6a 00                	push   $0x0
  8019df:	6a 00                	push   $0x0
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 09                	push   $0x9
  8019e9:	e8 00 ff ff ff       	call   8018ee <syscall>
  8019ee:	83 c4 18             	add    $0x18,%esp
}
  8019f1:	c9                   	leave  
  8019f2:	c3                   	ret    

008019f3 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8019f3:	55                   	push   %ebp
  8019f4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8019f6:	6a 00                	push   $0x0
  8019f8:	6a 00                	push   $0x0
  8019fa:	6a 00                	push   $0x0
  8019fc:	6a 00                	push   $0x0
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 0a                	push   $0xa
  801a02:	e8 e7 fe ff ff       	call   8018ee <syscall>
  801a07:	83 c4 18             	add    $0x18,%esp
}
  801a0a:	c9                   	leave  
  801a0b:	c3                   	ret    

00801a0c <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a0c:	55                   	push   %ebp
  801a0d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 00                	push   $0x0
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 0b                	push   $0xb
  801a1b:	e8 ce fe ff ff       	call   8018ee <syscall>
  801a20:	83 c4 18             	add    $0x18,%esp
}
  801a23:	c9                   	leave  
  801a24:	c3                   	ret    

00801a25 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a25:	55                   	push   %ebp
  801a26:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 00                	push   $0x0
  801a2e:	ff 75 0c             	pushl  0xc(%ebp)
  801a31:	ff 75 08             	pushl  0x8(%ebp)
  801a34:	6a 0f                	push   $0xf
  801a36:	e8 b3 fe ff ff       	call   8018ee <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
	return;
  801a3e:	90                   	nop
}
  801a3f:	c9                   	leave  
  801a40:	c3                   	ret    

00801a41 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a41:	55                   	push   %ebp
  801a42:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	ff 75 0c             	pushl  0xc(%ebp)
  801a4d:	ff 75 08             	pushl  0x8(%ebp)
  801a50:	6a 10                	push   $0x10
  801a52:	e8 97 fe ff ff       	call   8018ee <syscall>
  801a57:	83 c4 18             	add    $0x18,%esp
	return ;
  801a5a:	90                   	nop
}
  801a5b:	c9                   	leave  
  801a5c:	c3                   	ret    

00801a5d <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a5d:	55                   	push   %ebp
  801a5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	ff 75 10             	pushl  0x10(%ebp)
  801a67:	ff 75 0c             	pushl  0xc(%ebp)
  801a6a:	ff 75 08             	pushl  0x8(%ebp)
  801a6d:	6a 11                	push   $0x11
  801a6f:	e8 7a fe ff ff       	call   8018ee <syscall>
  801a74:	83 c4 18             	add    $0x18,%esp
	return ;
  801a77:	90                   	nop
}
  801a78:	c9                   	leave  
  801a79:	c3                   	ret    

00801a7a <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a7a:	55                   	push   %ebp
  801a7b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 0c                	push   $0xc
  801a89:	e8 60 fe ff ff       	call   8018ee <syscall>
  801a8e:	83 c4 18             	add    $0x18,%esp
}
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	ff 75 08             	pushl  0x8(%ebp)
  801aa1:	6a 0d                	push   $0xd
  801aa3:	e8 46 fe ff ff       	call   8018ee <syscall>
  801aa8:	83 c4 18             	add    $0x18,%esp
}
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 0e                	push   $0xe
  801abc:	e8 2d fe ff ff       	call   8018ee <syscall>
  801ac1:	83 c4 18             	add    $0x18,%esp
}
  801ac4:	90                   	nop
  801ac5:	c9                   	leave  
  801ac6:	c3                   	ret    

00801ac7 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801ac7:	55                   	push   %ebp
  801ac8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801aca:	6a 00                	push   $0x0
  801acc:	6a 00                	push   $0x0
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 13                	push   $0x13
  801ad6:	e8 13 fe ff ff       	call   8018ee <syscall>
  801adb:	83 c4 18             	add    $0x18,%esp
}
  801ade:	90                   	nop
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	6a 14                	push   $0x14
  801af0:	e8 f9 fd ff ff       	call   8018ee <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
}
  801af8:	90                   	nop
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_cputc>:


void
sys_cputc(const char c)
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	83 ec 04             	sub    $0x4,%esp
  801b01:	8b 45 08             	mov    0x8(%ebp),%eax
  801b04:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b07:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	50                   	push   %eax
  801b14:	6a 15                	push   $0x15
  801b16:	e8 d3 fd ff ff       	call   8018ee <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
}
  801b1e:	90                   	nop
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 16                	push   $0x16
  801b30:	e8 b9 fd ff ff       	call   8018ee <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	90                   	nop
  801b39:	c9                   	leave  
  801b3a:	c3                   	ret    

00801b3b <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b3b:	55                   	push   %ebp
  801b3c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 00                	push   $0x0
  801b47:	ff 75 0c             	pushl  0xc(%ebp)
  801b4a:	50                   	push   %eax
  801b4b:	6a 17                	push   $0x17
  801b4d:	e8 9c fd ff ff       	call   8018ee <syscall>
  801b52:	83 c4 18             	add    $0x18,%esp
}
  801b55:	c9                   	leave  
  801b56:	c3                   	ret    

00801b57 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b57:	55                   	push   %ebp
  801b58:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	52                   	push   %edx
  801b67:	50                   	push   %eax
  801b68:	6a 1a                	push   $0x1a
  801b6a:	e8 7f fd ff ff       	call   8018ee <syscall>
  801b6f:	83 c4 18             	add    $0x18,%esp
}
  801b72:	c9                   	leave  
  801b73:	c3                   	ret    

00801b74 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b74:	55                   	push   %ebp
  801b75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	52                   	push   %edx
  801b84:	50                   	push   %eax
  801b85:	6a 18                	push   $0x18
  801b87:	e8 62 fd ff ff       	call   8018ee <syscall>
  801b8c:	83 c4 18             	add    $0x18,%esp
}
  801b8f:	90                   	nop
  801b90:	c9                   	leave  
  801b91:	c3                   	ret    

00801b92 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b92:	55                   	push   %ebp
  801b93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b98:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	52                   	push   %edx
  801ba2:	50                   	push   %eax
  801ba3:	6a 19                	push   $0x19
  801ba5:	e8 44 fd ff ff       	call   8018ee <syscall>
  801baa:	83 c4 18             	add    $0x18,%esp
}
  801bad:	90                   	nop
  801bae:	c9                   	leave  
  801baf:	c3                   	ret    

00801bb0 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bb0:	55                   	push   %ebp
  801bb1:	89 e5                	mov    %esp,%ebp
  801bb3:	83 ec 04             	sub    $0x4,%esp
  801bb6:	8b 45 10             	mov    0x10(%ebp),%eax
  801bb9:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bbc:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bbf:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801bc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc6:	6a 00                	push   $0x0
  801bc8:	51                   	push   %ecx
  801bc9:	52                   	push   %edx
  801bca:	ff 75 0c             	pushl  0xc(%ebp)
  801bcd:	50                   	push   %eax
  801bce:	6a 1b                	push   $0x1b
  801bd0:	e8 19 fd ff ff       	call   8018ee <syscall>
  801bd5:	83 c4 18             	add    $0x18,%esp
}
  801bd8:	c9                   	leave  
  801bd9:	c3                   	ret    

00801bda <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801bda:	55                   	push   %ebp
  801bdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801bdd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be0:	8b 45 08             	mov    0x8(%ebp),%eax
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	6a 00                	push   $0x0
  801be9:	52                   	push   %edx
  801bea:	50                   	push   %eax
  801beb:	6a 1c                	push   $0x1c
  801bed:	e8 fc fc ff ff       	call   8018ee <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	c9                   	leave  
  801bf6:	c3                   	ret    

00801bf7 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801bf7:	55                   	push   %ebp
  801bf8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801bfa:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801bfd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	6a 00                	push   $0x0
  801c05:	6a 00                	push   $0x0
  801c07:	51                   	push   %ecx
  801c08:	52                   	push   %edx
  801c09:	50                   	push   %eax
  801c0a:	6a 1d                	push   $0x1d
  801c0c:	e8 dd fc ff ff       	call   8018ee <syscall>
  801c11:	83 c4 18             	add    $0x18,%esp
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c19:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 00                	push   $0x0
  801c25:	52                   	push   %edx
  801c26:	50                   	push   %eax
  801c27:	6a 1e                	push   $0x1e
  801c29:	e8 c0 fc ff ff       	call   8018ee <syscall>
  801c2e:	83 c4 18             	add    $0x18,%esp
}
  801c31:	c9                   	leave  
  801c32:	c3                   	ret    

00801c33 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c33:	55                   	push   %ebp
  801c34:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c36:	6a 00                	push   $0x0
  801c38:	6a 00                	push   $0x0
  801c3a:	6a 00                	push   $0x0
  801c3c:	6a 00                	push   $0x0
  801c3e:	6a 00                	push   $0x0
  801c40:	6a 1f                	push   $0x1f
  801c42:	e8 a7 fc ff ff       	call   8018ee <syscall>
  801c47:	83 c4 18             	add    $0x18,%esp
}
  801c4a:	c9                   	leave  
  801c4b:	c3                   	ret    

00801c4c <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c4c:	55                   	push   %ebp
  801c4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c52:	6a 00                	push   $0x0
  801c54:	ff 75 14             	pushl  0x14(%ebp)
  801c57:	ff 75 10             	pushl  0x10(%ebp)
  801c5a:	ff 75 0c             	pushl  0xc(%ebp)
  801c5d:	50                   	push   %eax
  801c5e:	6a 20                	push   $0x20
  801c60:	e8 89 fc ff ff       	call   8018ee <syscall>
  801c65:	83 c4 18             	add    $0x18,%esp
}
  801c68:	c9                   	leave  
  801c69:	c3                   	ret    

00801c6a <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801c6a:	55                   	push   %ebp
  801c6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c70:	6a 00                	push   $0x0
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	50                   	push   %eax
  801c79:	6a 21                	push   $0x21
  801c7b:	e8 6e fc ff ff       	call   8018ee <syscall>
  801c80:	83 c4 18             	add    $0x18,%esp
}
  801c83:	90                   	nop
  801c84:	c9                   	leave  
  801c85:	c3                   	ret    

00801c86 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c86:	55                   	push   %ebp
  801c87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c89:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	6a 00                	push   $0x0
  801c92:	6a 00                	push   $0x0
  801c94:	50                   	push   %eax
  801c95:	6a 22                	push   $0x22
  801c97:	e8 52 fc ff ff       	call   8018ee <syscall>
  801c9c:	83 c4 18             	add    $0x18,%esp
}
  801c9f:	c9                   	leave  
  801ca0:	c3                   	ret    

00801ca1 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ca1:	55                   	push   %ebp
  801ca2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	6a 02                	push   $0x2
  801cb0:	e8 39 fc ff ff       	call   8018ee <syscall>
  801cb5:	83 c4 18             	add    $0x18,%esp
}
  801cb8:	c9                   	leave  
  801cb9:	c3                   	ret    

00801cba <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cba:	55                   	push   %ebp
  801cbb:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 00                	push   $0x0
  801cc3:	6a 00                	push   $0x0
  801cc5:	6a 00                	push   $0x0
  801cc7:	6a 03                	push   $0x3
  801cc9:	e8 20 fc ff ff       	call   8018ee <syscall>
  801cce:	83 c4 18             	add    $0x18,%esp
}
  801cd1:	c9                   	leave  
  801cd2:	c3                   	ret    

00801cd3 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801cd3:	55                   	push   %ebp
  801cd4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	6a 04                	push   $0x4
  801ce2:	e8 07 fc ff ff       	call   8018ee <syscall>
  801ce7:	83 c4 18             	add    $0x18,%esp
}
  801cea:	c9                   	leave  
  801ceb:	c3                   	ret    

00801cec <sys_exit_env>:


void sys_exit_env(void)
{
  801cec:	55                   	push   %ebp
  801ced:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801cef:	6a 00                	push   $0x0
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 23                	push   $0x23
  801cfb:	e8 ee fb ff ff       	call   8018ee <syscall>
  801d00:	83 c4 18             	add    $0x18,%esp
}
  801d03:	90                   	nop
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d0c:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d0f:	8d 50 04             	lea    0x4(%eax),%edx
  801d12:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	52                   	push   %edx
  801d1c:	50                   	push   %eax
  801d1d:	6a 24                	push   $0x24
  801d1f:	e8 ca fb ff ff       	call   8018ee <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
	return result;
  801d27:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d2a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d2d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d30:	89 01                	mov    %eax,(%ecx)
  801d32:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d35:	8b 45 08             	mov    0x8(%ebp),%eax
  801d38:	c9                   	leave  
  801d39:	c2 04 00             	ret    $0x4

00801d3c <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d3c:	55                   	push   %ebp
  801d3d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	ff 75 10             	pushl  0x10(%ebp)
  801d46:	ff 75 0c             	pushl  0xc(%ebp)
  801d49:	ff 75 08             	pushl  0x8(%ebp)
  801d4c:	6a 12                	push   $0x12
  801d4e:	e8 9b fb ff ff       	call   8018ee <syscall>
  801d53:	83 c4 18             	add    $0x18,%esp
	return ;
  801d56:	90                   	nop
}
  801d57:	c9                   	leave  
  801d58:	c3                   	ret    

00801d59 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d59:	55                   	push   %ebp
  801d5a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 00                	push   $0x0
  801d64:	6a 00                	push   $0x0
  801d66:	6a 25                	push   $0x25
  801d68:	e8 81 fb ff ff       	call   8018ee <syscall>
  801d6d:	83 c4 18             	add    $0x18,%esp
}
  801d70:	c9                   	leave  
  801d71:	c3                   	ret    

00801d72 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801d72:	55                   	push   %ebp
  801d73:	89 e5                	mov    %esp,%ebp
  801d75:	83 ec 04             	sub    $0x4,%esp
  801d78:	8b 45 08             	mov    0x8(%ebp),%eax
  801d7b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d7e:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d82:	6a 00                	push   $0x0
  801d84:	6a 00                	push   $0x0
  801d86:	6a 00                	push   $0x0
  801d88:	6a 00                	push   $0x0
  801d8a:	50                   	push   %eax
  801d8b:	6a 26                	push   $0x26
  801d8d:	e8 5c fb ff ff       	call   8018ee <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
	return ;
  801d95:	90                   	nop
}
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <rsttst>:
void rsttst()
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 28                	push   $0x28
  801da7:	e8 42 fb ff ff       	call   8018ee <syscall>
  801dac:	83 c4 18             	add    $0x18,%esp
	return ;
  801daf:	90                   	nop
}
  801db0:	c9                   	leave  
  801db1:	c3                   	ret    

00801db2 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801db2:	55                   	push   %ebp
  801db3:	89 e5                	mov    %esp,%ebp
  801db5:	83 ec 04             	sub    $0x4,%esp
  801db8:	8b 45 14             	mov    0x14(%ebp),%eax
  801dbb:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dbe:	8b 55 18             	mov    0x18(%ebp),%edx
  801dc1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801dc5:	52                   	push   %edx
  801dc6:	50                   	push   %eax
  801dc7:	ff 75 10             	pushl  0x10(%ebp)
  801dca:	ff 75 0c             	pushl  0xc(%ebp)
  801dcd:	ff 75 08             	pushl  0x8(%ebp)
  801dd0:	6a 27                	push   $0x27
  801dd2:	e8 17 fb ff ff       	call   8018ee <syscall>
  801dd7:	83 c4 18             	add    $0x18,%esp
	return ;
  801dda:	90                   	nop
}
  801ddb:	c9                   	leave  
  801ddc:	c3                   	ret    

00801ddd <chktst>:
void chktst(uint32 n)
{
  801ddd:	55                   	push   %ebp
  801dde:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	6a 00                	push   $0x0
  801de8:	ff 75 08             	pushl  0x8(%ebp)
  801deb:	6a 29                	push   $0x29
  801ded:	e8 fc fa ff ff       	call   8018ee <syscall>
  801df2:	83 c4 18             	add    $0x18,%esp
	return ;
  801df5:	90                   	nop
}
  801df6:	c9                   	leave  
  801df7:	c3                   	ret    

00801df8 <inctst>:

void inctst()
{
  801df8:	55                   	push   %ebp
  801df9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801dfb:	6a 00                	push   $0x0
  801dfd:	6a 00                	push   $0x0
  801dff:	6a 00                	push   $0x0
  801e01:	6a 00                	push   $0x0
  801e03:	6a 00                	push   $0x0
  801e05:	6a 2a                	push   $0x2a
  801e07:	e8 e2 fa ff ff       	call   8018ee <syscall>
  801e0c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0f:	90                   	nop
}
  801e10:	c9                   	leave  
  801e11:	c3                   	ret    

00801e12 <gettst>:
uint32 gettst()
{
  801e12:	55                   	push   %ebp
  801e13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e15:	6a 00                	push   $0x0
  801e17:	6a 00                	push   $0x0
  801e19:	6a 00                	push   $0x0
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 2b                	push   $0x2b
  801e21:	e8 c8 fa ff ff       	call   8018ee <syscall>
  801e26:	83 c4 18             	add    $0x18,%esp
}
  801e29:	c9                   	leave  
  801e2a:	c3                   	ret    

00801e2b <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e2b:	55                   	push   %ebp
  801e2c:	89 e5                	mov    %esp,%ebp
  801e2e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 00                	push   $0x0
  801e37:	6a 00                	push   $0x0
  801e39:	6a 00                	push   $0x0
  801e3b:	6a 2c                	push   $0x2c
  801e3d:	e8 ac fa ff ff       	call   8018ee <syscall>
  801e42:	83 c4 18             	add    $0x18,%esp
  801e45:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e48:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e4c:	75 07                	jne    801e55 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e4e:	b8 01 00 00 00       	mov    $0x1,%eax
  801e53:	eb 05                	jmp    801e5a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e55:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5a:	c9                   	leave  
  801e5b:	c3                   	ret    

00801e5c <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e5c:	55                   	push   %ebp
  801e5d:	89 e5                	mov    %esp,%ebp
  801e5f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e62:	6a 00                	push   $0x0
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	6a 2c                	push   $0x2c
  801e6e:	e8 7b fa ff ff       	call   8018ee <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
  801e76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e79:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e7d:	75 07                	jne    801e86 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e7f:	b8 01 00 00 00       	mov    $0x1,%eax
  801e84:	eb 05                	jmp    801e8b <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e8b:	c9                   	leave  
  801e8c:	c3                   	ret    

00801e8d <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e8d:	55                   	push   %ebp
  801e8e:	89 e5                	mov    %esp,%ebp
  801e90:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e93:	6a 00                	push   $0x0
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	6a 00                	push   $0x0
  801e9b:	6a 00                	push   $0x0
  801e9d:	6a 2c                	push   $0x2c
  801e9f:	e8 4a fa ff ff       	call   8018ee <syscall>
  801ea4:	83 c4 18             	add    $0x18,%esp
  801ea7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801eaa:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eae:	75 07                	jne    801eb7 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801eb0:	b8 01 00 00 00       	mov    $0x1,%eax
  801eb5:	eb 05                	jmp    801ebc <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801eb7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 00                	push   $0x0
  801eca:	6a 00                	push   $0x0
  801ecc:	6a 00                	push   $0x0
  801ece:	6a 2c                	push   $0x2c
  801ed0:	e8 19 fa ff ff       	call   8018ee <syscall>
  801ed5:	83 c4 18             	add    $0x18,%esp
  801ed8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801edb:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801edf:	75 07                	jne    801ee8 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ee1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ee6:	eb 05                	jmp    801eed <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801ee8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801eed:	c9                   	leave  
  801eee:	c3                   	ret    

00801eef <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801eef:	55                   	push   %ebp
  801ef0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801ef2:	6a 00                	push   $0x0
  801ef4:	6a 00                	push   $0x0
  801ef6:	6a 00                	push   $0x0
  801ef8:	6a 00                	push   $0x0
  801efa:	ff 75 08             	pushl  0x8(%ebp)
  801efd:	6a 2d                	push   $0x2d
  801eff:	e8 ea f9 ff ff       	call   8018ee <syscall>
  801f04:	83 c4 18             	add    $0x18,%esp
	return ;
  801f07:	90                   	nop
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f0e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f11:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f14:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f17:	8b 45 08             	mov    0x8(%ebp),%eax
  801f1a:	6a 00                	push   $0x0
  801f1c:	53                   	push   %ebx
  801f1d:	51                   	push   %ecx
  801f1e:	52                   	push   %edx
  801f1f:	50                   	push   %eax
  801f20:	6a 2e                	push   $0x2e
  801f22:	e8 c7 f9 ff ff       	call   8018ee <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
}
  801f2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f2d:	c9                   	leave  
  801f2e:	c3                   	ret    

00801f2f <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f2f:	55                   	push   %ebp
  801f30:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f32:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f35:	8b 45 08             	mov    0x8(%ebp),%eax
  801f38:	6a 00                	push   $0x0
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	52                   	push   %edx
  801f3f:	50                   	push   %eax
  801f40:	6a 2f                	push   $0x2f
  801f42:	e8 a7 f9 ff ff       	call   8018ee <syscall>
  801f47:	83 c4 18             	add    $0x18,%esp
}
  801f4a:	c9                   	leave  
  801f4b:	c3                   	ret    

00801f4c <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f4c:	55                   	push   %ebp
  801f4d:	89 e5                	mov    %esp,%ebp
  801f4f:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f52:	83 ec 0c             	sub    $0xc,%esp
  801f55:	68 e0 3b 80 00       	push   $0x803be0
  801f5a:	e8 3e e6 ff ff       	call   80059d <cprintf>
  801f5f:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f62:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801f69:	83 ec 0c             	sub    $0xc,%esp
  801f6c:	68 0c 3c 80 00       	push   $0x803c0c
  801f71:	e8 27 e6 ff ff       	call   80059d <cprintf>
  801f76:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f79:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f7d:	a1 38 41 80 00       	mov    0x804138,%eax
  801f82:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f85:	eb 56                	jmp    801fdd <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f8b:	74 1c                	je     801fa9 <print_mem_block_lists+0x5d>
  801f8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f90:	8b 50 08             	mov    0x8(%eax),%edx
  801f93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f96:	8b 48 08             	mov    0x8(%eax),%ecx
  801f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f9c:	8b 40 0c             	mov    0xc(%eax),%eax
  801f9f:	01 c8                	add    %ecx,%eax
  801fa1:	39 c2                	cmp    %eax,%edx
  801fa3:	73 04                	jae    801fa9 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fa5:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fa9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fac:	8b 50 08             	mov    0x8(%eax),%edx
  801faf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb2:	8b 40 0c             	mov    0xc(%eax),%eax
  801fb5:	01 c2                	add    %eax,%edx
  801fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fba:	8b 40 08             	mov    0x8(%eax),%eax
  801fbd:	83 ec 04             	sub    $0x4,%esp
  801fc0:	52                   	push   %edx
  801fc1:	50                   	push   %eax
  801fc2:	68 21 3c 80 00       	push   $0x803c21
  801fc7:	e8 d1 e5 ff ff       	call   80059d <cprintf>
  801fcc:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801fcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fd5:	a1 40 41 80 00       	mov    0x804140,%eax
  801fda:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fdd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801fe1:	74 07                	je     801fea <print_mem_block_lists+0x9e>
  801fe3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe6:	8b 00                	mov    (%eax),%eax
  801fe8:	eb 05                	jmp    801fef <print_mem_block_lists+0xa3>
  801fea:	b8 00 00 00 00       	mov    $0x0,%eax
  801fef:	a3 40 41 80 00       	mov    %eax,0x804140
  801ff4:	a1 40 41 80 00       	mov    0x804140,%eax
  801ff9:	85 c0                	test   %eax,%eax
  801ffb:	75 8a                	jne    801f87 <print_mem_block_lists+0x3b>
  801ffd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802001:	75 84                	jne    801f87 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802003:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802007:	75 10                	jne    802019 <print_mem_block_lists+0xcd>
  802009:	83 ec 0c             	sub    $0xc,%esp
  80200c:	68 30 3c 80 00       	push   $0x803c30
  802011:	e8 87 e5 ff ff       	call   80059d <cprintf>
  802016:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802019:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802020:	83 ec 0c             	sub    $0xc,%esp
  802023:	68 54 3c 80 00       	push   $0x803c54
  802028:	e8 70 e5 ff ff       	call   80059d <cprintf>
  80202d:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802030:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802034:	a1 40 40 80 00       	mov    0x804040,%eax
  802039:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80203c:	eb 56                	jmp    802094 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80203e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802042:	74 1c                	je     802060 <print_mem_block_lists+0x114>
  802044:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802047:	8b 50 08             	mov    0x8(%eax),%edx
  80204a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204d:	8b 48 08             	mov    0x8(%eax),%ecx
  802050:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802053:	8b 40 0c             	mov    0xc(%eax),%eax
  802056:	01 c8                	add    %ecx,%eax
  802058:	39 c2                	cmp    %eax,%edx
  80205a:	73 04                	jae    802060 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80205c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802060:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802063:	8b 50 08             	mov    0x8(%eax),%edx
  802066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802069:	8b 40 0c             	mov    0xc(%eax),%eax
  80206c:	01 c2                	add    %eax,%edx
  80206e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802071:	8b 40 08             	mov    0x8(%eax),%eax
  802074:	83 ec 04             	sub    $0x4,%esp
  802077:	52                   	push   %edx
  802078:	50                   	push   %eax
  802079:	68 21 3c 80 00       	push   $0x803c21
  80207e:	e8 1a e5 ff ff       	call   80059d <cprintf>
  802083:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802086:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802089:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80208c:	a1 48 40 80 00       	mov    0x804048,%eax
  802091:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802094:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802098:	74 07                	je     8020a1 <print_mem_block_lists+0x155>
  80209a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209d:	8b 00                	mov    (%eax),%eax
  80209f:	eb 05                	jmp    8020a6 <print_mem_block_lists+0x15a>
  8020a1:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a6:	a3 48 40 80 00       	mov    %eax,0x804048
  8020ab:	a1 48 40 80 00       	mov    0x804048,%eax
  8020b0:	85 c0                	test   %eax,%eax
  8020b2:	75 8a                	jne    80203e <print_mem_block_lists+0xf2>
  8020b4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b8:	75 84                	jne    80203e <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020ba:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020be:	75 10                	jne    8020d0 <print_mem_block_lists+0x184>
  8020c0:	83 ec 0c             	sub    $0xc,%esp
  8020c3:	68 6c 3c 80 00       	push   $0x803c6c
  8020c8:	e8 d0 e4 ff ff       	call   80059d <cprintf>
  8020cd:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  8020d0:	83 ec 0c             	sub    $0xc,%esp
  8020d3:	68 e0 3b 80 00       	push   $0x803be0
  8020d8:	e8 c0 e4 ff ff       	call   80059d <cprintf>
  8020dd:	83 c4 10             	add    $0x10,%esp

}
  8020e0:	90                   	nop
  8020e1:	c9                   	leave  
  8020e2:	c3                   	ret    

008020e3 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8020e3:	55                   	push   %ebp
  8020e4:	89 e5                	mov    %esp,%ebp
  8020e6:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8020e9:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8020f0:	00 00 00 
  8020f3:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8020fa:	00 00 00 
  8020fd:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802104:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802107:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80210e:	e9 9e 00 00 00       	jmp    8021b1 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802113:	a1 50 40 80 00       	mov    0x804050,%eax
  802118:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211b:	c1 e2 04             	shl    $0x4,%edx
  80211e:	01 d0                	add    %edx,%eax
  802120:	85 c0                	test   %eax,%eax
  802122:	75 14                	jne    802138 <initialize_MemBlocksList+0x55>
  802124:	83 ec 04             	sub    $0x4,%esp
  802127:	68 94 3c 80 00       	push   $0x803c94
  80212c:	6a 3d                	push   $0x3d
  80212e:	68 b7 3c 80 00       	push   $0x803cb7
  802133:	e8 b1 e1 ff ff       	call   8002e9 <_panic>
  802138:	a1 50 40 80 00       	mov    0x804050,%eax
  80213d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802140:	c1 e2 04             	shl    $0x4,%edx
  802143:	01 d0                	add    %edx,%eax
  802145:	8b 15 48 41 80 00    	mov    0x804148,%edx
  80214b:	89 10                	mov    %edx,(%eax)
  80214d:	8b 00                	mov    (%eax),%eax
  80214f:	85 c0                	test   %eax,%eax
  802151:	74 18                	je     80216b <initialize_MemBlocksList+0x88>
  802153:	a1 48 41 80 00       	mov    0x804148,%eax
  802158:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80215e:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802161:	c1 e1 04             	shl    $0x4,%ecx
  802164:	01 ca                	add    %ecx,%edx
  802166:	89 50 04             	mov    %edx,0x4(%eax)
  802169:	eb 12                	jmp    80217d <initialize_MemBlocksList+0x9a>
  80216b:	a1 50 40 80 00       	mov    0x804050,%eax
  802170:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802173:	c1 e2 04             	shl    $0x4,%edx
  802176:	01 d0                	add    %edx,%eax
  802178:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80217d:	a1 50 40 80 00       	mov    0x804050,%eax
  802182:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802185:	c1 e2 04             	shl    $0x4,%edx
  802188:	01 d0                	add    %edx,%eax
  80218a:	a3 48 41 80 00       	mov    %eax,0x804148
  80218f:	a1 50 40 80 00       	mov    0x804050,%eax
  802194:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802197:	c1 e2 04             	shl    $0x4,%edx
  80219a:	01 d0                	add    %edx,%eax
  80219c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021a3:	a1 54 41 80 00       	mov    0x804154,%eax
  8021a8:	40                   	inc    %eax
  8021a9:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8021ae:	ff 45 f4             	incl   -0xc(%ebp)
  8021b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021b7:	0f 82 56 ff ff ff    	jb     802113 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8021bd:	90                   	nop
  8021be:	c9                   	leave  
  8021bf:	c3                   	ret    

008021c0 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021c0:	55                   	push   %ebp
  8021c1:	89 e5                	mov    %esp,%ebp
  8021c3:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	8b 00                	mov    (%eax),%eax
  8021cb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  8021ce:	eb 18                	jmp    8021e8 <find_block+0x28>

		if(tmp->sva == va){
  8021d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021d3:	8b 40 08             	mov    0x8(%eax),%eax
  8021d6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8021d9:	75 05                	jne    8021e0 <find_block+0x20>
			return tmp ;
  8021db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021de:	eb 11                	jmp    8021f1 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  8021e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021e3:	8b 00                	mov    (%eax),%eax
  8021e5:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8021e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8021ec:	75 e2                	jne    8021d0 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8021ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8021f9:	a1 40 40 80 00       	mov    0x804040,%eax
  8021fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802201:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802206:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802209:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80220d:	75 65                	jne    802274 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  80220f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802213:	75 14                	jne    802229 <insert_sorted_allocList+0x36>
  802215:	83 ec 04             	sub    $0x4,%esp
  802218:	68 94 3c 80 00       	push   $0x803c94
  80221d:	6a 62                	push   $0x62
  80221f:	68 b7 3c 80 00       	push   $0x803cb7
  802224:	e8 c0 e0 ff ff       	call   8002e9 <_panic>
  802229:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80222f:	8b 45 08             	mov    0x8(%ebp),%eax
  802232:	89 10                	mov    %edx,(%eax)
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	8b 00                	mov    (%eax),%eax
  802239:	85 c0                	test   %eax,%eax
  80223b:	74 0d                	je     80224a <insert_sorted_allocList+0x57>
  80223d:	a1 40 40 80 00       	mov    0x804040,%eax
  802242:	8b 55 08             	mov    0x8(%ebp),%edx
  802245:	89 50 04             	mov    %edx,0x4(%eax)
  802248:	eb 08                	jmp    802252 <insert_sorted_allocList+0x5f>
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	a3 44 40 80 00       	mov    %eax,0x804044
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	a3 40 40 80 00       	mov    %eax,0x804040
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802264:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802269:	40                   	inc    %eax
  80226a:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80226f:	e9 14 01 00 00       	jmp    802388 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802274:	8b 45 08             	mov    0x8(%ebp),%eax
  802277:	8b 50 08             	mov    0x8(%eax),%edx
  80227a:	a1 44 40 80 00       	mov    0x804044,%eax
  80227f:	8b 40 08             	mov    0x8(%eax),%eax
  802282:	39 c2                	cmp    %eax,%edx
  802284:	76 65                	jbe    8022eb <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802286:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80228a:	75 14                	jne    8022a0 <insert_sorted_allocList+0xad>
  80228c:	83 ec 04             	sub    $0x4,%esp
  80228f:	68 d0 3c 80 00       	push   $0x803cd0
  802294:	6a 64                	push   $0x64
  802296:	68 b7 3c 80 00       	push   $0x803cb7
  80229b:	e8 49 e0 ff ff       	call   8002e9 <_panic>
  8022a0:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	89 50 04             	mov    %edx,0x4(%eax)
  8022ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8022af:	8b 40 04             	mov    0x4(%eax),%eax
  8022b2:	85 c0                	test   %eax,%eax
  8022b4:	74 0c                	je     8022c2 <insert_sorted_allocList+0xcf>
  8022b6:	a1 44 40 80 00       	mov    0x804044,%eax
  8022bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8022be:	89 10                	mov    %edx,(%eax)
  8022c0:	eb 08                	jmp    8022ca <insert_sorted_allocList+0xd7>
  8022c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c5:	a3 40 40 80 00       	mov    %eax,0x804040
  8022ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cd:	a3 44 40 80 00       	mov    %eax,0x804044
  8022d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022db:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022e0:	40                   	inc    %eax
  8022e1:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8022e6:	e9 9d 00 00 00       	jmp    802388 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8022eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8022f2:	e9 85 00 00 00       	jmp    80237c <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8022f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fa:	8b 50 08             	mov    0x8(%eax),%edx
  8022fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802300:	8b 40 08             	mov    0x8(%eax),%eax
  802303:	39 c2                	cmp    %eax,%edx
  802305:	73 6a                	jae    802371 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802307:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80230b:	74 06                	je     802313 <insert_sorted_allocList+0x120>
  80230d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802311:	75 14                	jne    802327 <insert_sorted_allocList+0x134>
  802313:	83 ec 04             	sub    $0x4,%esp
  802316:	68 f4 3c 80 00       	push   $0x803cf4
  80231b:	6a 6b                	push   $0x6b
  80231d:	68 b7 3c 80 00       	push   $0x803cb7
  802322:	e8 c2 df ff ff       	call   8002e9 <_panic>
  802327:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80232a:	8b 50 04             	mov    0x4(%eax),%edx
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	89 50 04             	mov    %edx,0x4(%eax)
  802333:	8b 45 08             	mov    0x8(%ebp),%eax
  802336:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802339:	89 10                	mov    %edx,(%eax)
  80233b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233e:	8b 40 04             	mov    0x4(%eax),%eax
  802341:	85 c0                	test   %eax,%eax
  802343:	74 0d                	je     802352 <insert_sorted_allocList+0x15f>
  802345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802348:	8b 40 04             	mov    0x4(%eax),%eax
  80234b:	8b 55 08             	mov    0x8(%ebp),%edx
  80234e:	89 10                	mov    %edx,(%eax)
  802350:	eb 08                	jmp    80235a <insert_sorted_allocList+0x167>
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	a3 40 40 80 00       	mov    %eax,0x804040
  80235a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235d:	8b 55 08             	mov    0x8(%ebp),%edx
  802360:	89 50 04             	mov    %edx,0x4(%eax)
  802363:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802368:	40                   	inc    %eax
  802369:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  80236e:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80236f:	eb 17                	jmp    802388 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802374:	8b 00                	mov    (%eax),%eax
  802376:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802379:	ff 45 f0             	incl   -0x10(%ebp)
  80237c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80237f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802382:	0f 8c 6f ff ff ff    	jl     8022f7 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802388:	90                   	nop
  802389:	c9                   	leave  
  80238a:	c3                   	ret    

0080238b <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80238b:	55                   	push   %ebp
  80238c:	89 e5                	mov    %esp,%ebp
  80238e:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802391:	a1 38 41 80 00       	mov    0x804138,%eax
  802396:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802399:	e9 7c 01 00 00       	jmp    80251a <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  80239e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023a4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023a7:	0f 86 cf 00 00 00    	jbe    80247c <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8023ad:	a1 48 41 80 00       	mov    0x804148,%eax
  8023b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  8023b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8023bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023be:	8b 55 08             	mov    0x8(%ebp),%edx
  8023c1:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8023c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c7:	8b 50 08             	mov    0x8(%eax),%edx
  8023ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023cd:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8023d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d6:	2b 45 08             	sub    0x8(%ebp),%eax
  8023d9:	89 c2                	mov    %eax,%edx
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8023e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e4:	8b 50 08             	mov    0x8(%eax),%edx
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	01 c2                	add    %eax,%edx
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8023f2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8023f6:	75 17                	jne    80240f <alloc_block_FF+0x84>
  8023f8:	83 ec 04             	sub    $0x4,%esp
  8023fb:	68 29 3d 80 00       	push   $0x803d29
  802400:	68 83 00 00 00       	push   $0x83
  802405:	68 b7 3c 80 00       	push   $0x803cb7
  80240a:	e8 da de ff ff       	call   8002e9 <_panic>
  80240f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802412:	8b 00                	mov    (%eax),%eax
  802414:	85 c0                	test   %eax,%eax
  802416:	74 10                	je     802428 <alloc_block_FF+0x9d>
  802418:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80241b:	8b 00                	mov    (%eax),%eax
  80241d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802420:	8b 52 04             	mov    0x4(%edx),%edx
  802423:	89 50 04             	mov    %edx,0x4(%eax)
  802426:	eb 0b                	jmp    802433 <alloc_block_FF+0xa8>
  802428:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80242b:	8b 40 04             	mov    0x4(%eax),%eax
  80242e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802433:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802436:	8b 40 04             	mov    0x4(%eax),%eax
  802439:	85 c0                	test   %eax,%eax
  80243b:	74 0f                	je     80244c <alloc_block_FF+0xc1>
  80243d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802440:	8b 40 04             	mov    0x4(%eax),%eax
  802443:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802446:	8b 12                	mov    (%edx),%edx
  802448:	89 10                	mov    %edx,(%eax)
  80244a:	eb 0a                	jmp    802456 <alloc_block_FF+0xcb>
  80244c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244f:	8b 00                	mov    (%eax),%eax
  802451:	a3 48 41 80 00       	mov    %eax,0x804148
  802456:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802459:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80245f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802462:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802469:	a1 54 41 80 00       	mov    0x804154,%eax
  80246e:	48                   	dec    %eax
  80246f:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  802474:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802477:	e9 ad 00 00 00       	jmp    802529 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  80247c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247f:	8b 40 0c             	mov    0xc(%eax),%eax
  802482:	3b 45 08             	cmp    0x8(%ebp),%eax
  802485:	0f 85 87 00 00 00    	jne    802512 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  80248b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80248f:	75 17                	jne    8024a8 <alloc_block_FF+0x11d>
  802491:	83 ec 04             	sub    $0x4,%esp
  802494:	68 29 3d 80 00       	push   $0x803d29
  802499:	68 87 00 00 00       	push   $0x87
  80249e:	68 b7 3c 80 00       	push   $0x803cb7
  8024a3:	e8 41 de ff ff       	call   8002e9 <_panic>
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 00                	mov    (%eax),%eax
  8024ad:	85 c0                	test   %eax,%eax
  8024af:	74 10                	je     8024c1 <alloc_block_FF+0x136>
  8024b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b4:	8b 00                	mov    (%eax),%eax
  8024b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024b9:	8b 52 04             	mov    0x4(%edx),%edx
  8024bc:	89 50 04             	mov    %edx,0x4(%eax)
  8024bf:	eb 0b                	jmp    8024cc <alloc_block_FF+0x141>
  8024c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c4:	8b 40 04             	mov    0x4(%eax),%eax
  8024c7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8024cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cf:	8b 40 04             	mov    0x4(%eax),%eax
  8024d2:	85 c0                	test   %eax,%eax
  8024d4:	74 0f                	je     8024e5 <alloc_block_FF+0x15a>
  8024d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d9:	8b 40 04             	mov    0x4(%eax),%eax
  8024dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024df:	8b 12                	mov    (%edx),%edx
  8024e1:	89 10                	mov    %edx,(%eax)
  8024e3:	eb 0a                	jmp    8024ef <alloc_block_FF+0x164>
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 00                	mov    (%eax),%eax
  8024ea:	a3 38 41 80 00       	mov    %eax,0x804138
  8024ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802502:	a1 44 41 80 00       	mov    0x804144,%eax
  802507:	48                   	dec    %eax
  802508:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	eb 17                	jmp    802529 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802515:	8b 00                	mov    (%eax),%eax
  802517:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  80251a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251e:	0f 85 7a fe ff ff    	jne    80239e <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802524:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802529:	c9                   	leave  
  80252a:	c3                   	ret    

0080252b <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80252b:	55                   	push   %ebp
  80252c:	89 e5                	mov    %esp,%ebp
  80252e:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802531:	a1 38 41 80 00       	mov    0x804138,%eax
  802536:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802539:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802540:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802547:	a1 38 41 80 00       	mov    0x804138,%eax
  80254c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80254f:	e9 d0 00 00 00       	jmp    802624 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802557:	8b 40 0c             	mov    0xc(%eax),%eax
  80255a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80255d:	0f 82 b8 00 00 00    	jb     80261b <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802563:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802566:	8b 40 0c             	mov    0xc(%eax),%eax
  802569:	2b 45 08             	sub    0x8(%ebp),%eax
  80256c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  80256f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802572:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802575:	0f 83 a1 00 00 00    	jae    80261c <alloc_block_BF+0xf1>
				differsize = differance ;
  80257b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80257e:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802581:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802584:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802587:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80258b:	0f 85 8b 00 00 00    	jne    80261c <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802591:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802595:	75 17                	jne    8025ae <alloc_block_BF+0x83>
  802597:	83 ec 04             	sub    $0x4,%esp
  80259a:	68 29 3d 80 00       	push   $0x803d29
  80259f:	68 a0 00 00 00       	push   $0xa0
  8025a4:	68 b7 3c 80 00       	push   $0x803cb7
  8025a9:	e8 3b dd ff ff       	call   8002e9 <_panic>
  8025ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b1:	8b 00                	mov    (%eax),%eax
  8025b3:	85 c0                	test   %eax,%eax
  8025b5:	74 10                	je     8025c7 <alloc_block_BF+0x9c>
  8025b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ba:	8b 00                	mov    (%eax),%eax
  8025bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025bf:	8b 52 04             	mov    0x4(%edx),%edx
  8025c2:	89 50 04             	mov    %edx,0x4(%eax)
  8025c5:	eb 0b                	jmp    8025d2 <alloc_block_BF+0xa7>
  8025c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ca:	8b 40 04             	mov    0x4(%eax),%eax
  8025cd:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8025d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d5:	8b 40 04             	mov    0x4(%eax),%eax
  8025d8:	85 c0                	test   %eax,%eax
  8025da:	74 0f                	je     8025eb <alloc_block_BF+0xc0>
  8025dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025df:	8b 40 04             	mov    0x4(%eax),%eax
  8025e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025e5:	8b 12                	mov    (%edx),%edx
  8025e7:	89 10                	mov    %edx,(%eax)
  8025e9:	eb 0a                	jmp    8025f5 <alloc_block_BF+0xca>
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	a3 38 41 80 00       	mov    %eax,0x804138
  8025f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802601:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802608:	a1 44 41 80 00       	mov    0x804144,%eax
  80260d:	48                   	dec    %eax
  80260e:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	e9 0c 01 00 00       	jmp    802727 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  80261b:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80261c:	a1 40 41 80 00       	mov    0x804140,%eax
  802621:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802624:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802628:	74 07                	je     802631 <alloc_block_BF+0x106>
  80262a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262d:	8b 00                	mov    (%eax),%eax
  80262f:	eb 05                	jmp    802636 <alloc_block_BF+0x10b>
  802631:	b8 00 00 00 00       	mov    $0x0,%eax
  802636:	a3 40 41 80 00       	mov    %eax,0x804140
  80263b:	a1 40 41 80 00       	mov    0x804140,%eax
  802640:	85 c0                	test   %eax,%eax
  802642:	0f 85 0c ff ff ff    	jne    802554 <alloc_block_BF+0x29>
  802648:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80264c:	0f 85 02 ff ff ff    	jne    802554 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802652:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802656:	0f 84 c6 00 00 00    	je     802722 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  80265c:	a1 48 41 80 00       	mov    0x804148,%eax
  802661:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802664:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802667:	8b 55 08             	mov    0x8(%ebp),%edx
  80266a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  80266d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802670:	8b 50 08             	mov    0x8(%eax),%edx
  802673:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802676:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802679:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80267c:	8b 40 0c             	mov    0xc(%eax),%eax
  80267f:	2b 45 08             	sub    0x8(%ebp),%eax
  802682:	89 c2                	mov    %eax,%edx
  802684:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802687:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  80268a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80268d:	8b 50 08             	mov    0x8(%eax),%edx
  802690:	8b 45 08             	mov    0x8(%ebp),%eax
  802693:	01 c2                	add    %eax,%edx
  802695:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802698:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  80269b:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80269f:	75 17                	jne    8026b8 <alloc_block_BF+0x18d>
  8026a1:	83 ec 04             	sub    $0x4,%esp
  8026a4:	68 29 3d 80 00       	push   $0x803d29
  8026a9:	68 af 00 00 00       	push   $0xaf
  8026ae:	68 b7 3c 80 00       	push   $0x803cb7
  8026b3:	e8 31 dc ff ff       	call   8002e9 <_panic>
  8026b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026bb:	8b 00                	mov    (%eax),%eax
  8026bd:	85 c0                	test   %eax,%eax
  8026bf:	74 10                	je     8026d1 <alloc_block_BF+0x1a6>
  8026c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c4:	8b 00                	mov    (%eax),%eax
  8026c6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026c9:	8b 52 04             	mov    0x4(%edx),%edx
  8026cc:	89 50 04             	mov    %edx,0x4(%eax)
  8026cf:	eb 0b                	jmp    8026dc <alloc_block_BF+0x1b1>
  8026d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026d4:	8b 40 04             	mov    0x4(%eax),%eax
  8026d7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8026dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026df:	8b 40 04             	mov    0x4(%eax),%eax
  8026e2:	85 c0                	test   %eax,%eax
  8026e4:	74 0f                	je     8026f5 <alloc_block_BF+0x1ca>
  8026e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e9:	8b 40 04             	mov    0x4(%eax),%eax
  8026ec:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8026ef:	8b 12                	mov    (%edx),%edx
  8026f1:	89 10                	mov    %edx,(%eax)
  8026f3:	eb 0a                	jmp    8026ff <alloc_block_BF+0x1d4>
  8026f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	a3 48 41 80 00       	mov    %eax,0x804148
  8026ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802702:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802708:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802712:	a1 54 41 80 00       	mov    0x804154,%eax
  802717:	48                   	dec    %eax
  802718:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  80271d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802720:	eb 05                	jmp    802727 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802722:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802727:	c9                   	leave  
  802728:	c3                   	ret    

00802729 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802729:	55                   	push   %ebp
  80272a:	89 e5                	mov    %esp,%ebp
  80272c:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  80272f:	a1 38 41 80 00       	mov    0x804138,%eax
  802734:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802737:	e9 7c 01 00 00       	jmp    8028b8 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  80273c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80273f:	8b 40 0c             	mov    0xc(%eax),%eax
  802742:	3b 45 08             	cmp    0x8(%ebp),%eax
  802745:	0f 86 cf 00 00 00    	jbe    80281a <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80274b:	a1 48 41 80 00       	mov    0x804148,%eax
  802750:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802756:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275c:	8b 55 08             	mov    0x8(%ebp),%edx
  80275f:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802762:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802765:	8b 50 08             	mov    0x8(%eax),%edx
  802768:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80276b:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  80276e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802771:	8b 40 0c             	mov    0xc(%eax),%eax
  802774:	2b 45 08             	sub    0x8(%ebp),%eax
  802777:	89 c2                	mov    %eax,%edx
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  80277f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802782:	8b 50 08             	mov    0x8(%eax),%edx
  802785:	8b 45 08             	mov    0x8(%ebp),%eax
  802788:	01 c2                	add    %eax,%edx
  80278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278d:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802790:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802794:	75 17                	jne    8027ad <alloc_block_NF+0x84>
  802796:	83 ec 04             	sub    $0x4,%esp
  802799:	68 29 3d 80 00       	push   $0x803d29
  80279e:	68 c4 00 00 00       	push   $0xc4
  8027a3:	68 b7 3c 80 00       	push   $0x803cb7
  8027a8:	e8 3c db ff ff       	call   8002e9 <_panic>
  8027ad:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b0:	8b 00                	mov    (%eax),%eax
  8027b2:	85 c0                	test   %eax,%eax
  8027b4:	74 10                	je     8027c6 <alloc_block_NF+0x9d>
  8027b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b9:	8b 00                	mov    (%eax),%eax
  8027bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027be:	8b 52 04             	mov    0x4(%edx),%edx
  8027c1:	89 50 04             	mov    %edx,0x4(%eax)
  8027c4:	eb 0b                	jmp    8027d1 <alloc_block_NF+0xa8>
  8027c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027c9:	8b 40 04             	mov    0x4(%eax),%eax
  8027cc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8027d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027d4:	8b 40 04             	mov    0x4(%eax),%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	74 0f                	je     8027ea <alloc_block_NF+0xc1>
  8027db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027de:	8b 40 04             	mov    0x4(%eax),%eax
  8027e1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027e4:	8b 12                	mov    (%edx),%edx
  8027e6:	89 10                	mov    %edx,(%eax)
  8027e8:	eb 0a                	jmp    8027f4 <alloc_block_NF+0xcb>
  8027ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ed:	8b 00                	mov    (%eax),%eax
  8027ef:	a3 48 41 80 00       	mov    %eax,0x804148
  8027f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802800:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802807:	a1 54 41 80 00       	mov    0x804154,%eax
  80280c:	48                   	dec    %eax
  80280d:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  802812:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802815:	e9 ad 00 00 00       	jmp    8028c7 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 40 0c             	mov    0xc(%eax),%eax
  802820:	3b 45 08             	cmp    0x8(%ebp),%eax
  802823:	0f 85 87 00 00 00    	jne    8028b0 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802829:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282d:	75 17                	jne    802846 <alloc_block_NF+0x11d>
  80282f:	83 ec 04             	sub    $0x4,%esp
  802832:	68 29 3d 80 00       	push   $0x803d29
  802837:	68 c8 00 00 00       	push   $0xc8
  80283c:	68 b7 3c 80 00       	push   $0x803cb7
  802841:	e8 a3 da ff ff       	call   8002e9 <_panic>
  802846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802849:	8b 00                	mov    (%eax),%eax
  80284b:	85 c0                	test   %eax,%eax
  80284d:	74 10                	je     80285f <alloc_block_NF+0x136>
  80284f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802852:	8b 00                	mov    (%eax),%eax
  802854:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802857:	8b 52 04             	mov    0x4(%edx),%edx
  80285a:	89 50 04             	mov    %edx,0x4(%eax)
  80285d:	eb 0b                	jmp    80286a <alloc_block_NF+0x141>
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	8b 40 04             	mov    0x4(%eax),%eax
  802865:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80286a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286d:	8b 40 04             	mov    0x4(%eax),%eax
  802870:	85 c0                	test   %eax,%eax
  802872:	74 0f                	je     802883 <alloc_block_NF+0x15a>
  802874:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802877:	8b 40 04             	mov    0x4(%eax),%eax
  80287a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80287d:	8b 12                	mov    (%edx),%edx
  80287f:	89 10                	mov    %edx,(%eax)
  802881:	eb 0a                	jmp    80288d <alloc_block_NF+0x164>
  802883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802886:	8b 00                	mov    (%eax),%eax
  802888:	a3 38 41 80 00       	mov    %eax,0x804138
  80288d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802890:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802896:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802899:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a0:	a1 44 41 80 00       	mov    0x804144,%eax
  8028a5:	48                   	dec    %eax
  8028a6:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	eb 17                	jmp    8028c7 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  8028b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b3:	8b 00                	mov    (%eax),%eax
  8028b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  8028b8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028bc:	0f 85 7a fe ff ff    	jne    80273c <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  8028c2:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8028c7:	c9                   	leave  
  8028c8:	c3                   	ret    

008028c9 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8028c9:	55                   	push   %ebp
  8028ca:	89 e5                	mov    %esp,%ebp
  8028cc:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  8028cf:	a1 38 41 80 00       	mov    0x804138,%eax
  8028d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8028d7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8028dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8028df:	a1 44 41 80 00       	mov    0x804144,%eax
  8028e4:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8028e7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028eb:	75 68                	jne    802955 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8028ed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028f1:	75 17                	jne    80290a <insert_sorted_with_merge_freeList+0x41>
  8028f3:	83 ec 04             	sub    $0x4,%esp
  8028f6:	68 94 3c 80 00       	push   $0x803c94
  8028fb:	68 da 00 00 00       	push   $0xda
  802900:	68 b7 3c 80 00       	push   $0x803cb7
  802905:	e8 df d9 ff ff       	call   8002e9 <_panic>
  80290a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802910:	8b 45 08             	mov    0x8(%ebp),%eax
  802913:	89 10                	mov    %edx,(%eax)
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	8b 00                	mov    (%eax),%eax
  80291a:	85 c0                	test   %eax,%eax
  80291c:	74 0d                	je     80292b <insert_sorted_with_merge_freeList+0x62>
  80291e:	a1 38 41 80 00       	mov    0x804138,%eax
  802923:	8b 55 08             	mov    0x8(%ebp),%edx
  802926:	89 50 04             	mov    %edx,0x4(%eax)
  802929:	eb 08                	jmp    802933 <insert_sorted_with_merge_freeList+0x6a>
  80292b:	8b 45 08             	mov    0x8(%ebp),%eax
  80292e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802933:	8b 45 08             	mov    0x8(%ebp),%eax
  802936:	a3 38 41 80 00       	mov    %eax,0x804138
  80293b:	8b 45 08             	mov    0x8(%ebp),%eax
  80293e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802945:	a1 44 41 80 00       	mov    0x804144,%eax
  80294a:	40                   	inc    %eax
  80294b:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  802950:	e9 49 07 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802955:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802958:	8b 50 08             	mov    0x8(%eax),%edx
  80295b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80295e:	8b 40 0c             	mov    0xc(%eax),%eax
  802961:	01 c2                	add    %eax,%edx
  802963:	8b 45 08             	mov    0x8(%ebp),%eax
  802966:	8b 40 08             	mov    0x8(%eax),%eax
  802969:	39 c2                	cmp    %eax,%edx
  80296b:	73 77                	jae    8029e4 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  80296d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802970:	8b 00                	mov    (%eax),%eax
  802972:	85 c0                	test   %eax,%eax
  802974:	75 6e                	jne    8029e4 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802976:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80297a:	74 68                	je     8029e4 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  80297c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802980:	75 17                	jne    802999 <insert_sorted_with_merge_freeList+0xd0>
  802982:	83 ec 04             	sub    $0x4,%esp
  802985:	68 d0 3c 80 00       	push   $0x803cd0
  80298a:	68 e0 00 00 00       	push   $0xe0
  80298f:	68 b7 3c 80 00       	push   $0x803cb7
  802994:	e8 50 d9 ff ff       	call   8002e9 <_panic>
  802999:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80299f:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a2:	89 50 04             	mov    %edx,0x4(%eax)
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	8b 40 04             	mov    0x4(%eax),%eax
  8029ab:	85 c0                	test   %eax,%eax
  8029ad:	74 0c                	je     8029bb <insert_sorted_with_merge_freeList+0xf2>
  8029af:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b7:	89 10                	mov    %edx,(%eax)
  8029b9:	eb 08                	jmp    8029c3 <insert_sorted_with_merge_freeList+0xfa>
  8029bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029be:	a3 38 41 80 00       	mov    %eax,0x804138
  8029c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8029d4:	a1 44 41 80 00       	mov    0x804144,%eax
  8029d9:	40                   	inc    %eax
  8029da:	a3 44 41 80 00       	mov    %eax,0x804144
  8029df:	e9 ba 06 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	8b 50 0c             	mov    0xc(%eax),%edx
  8029ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ed:	8b 40 08             	mov    0x8(%eax),%eax
  8029f0:	01 c2                	add    %eax,%edx
  8029f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f5:	8b 40 08             	mov    0x8(%eax),%eax
  8029f8:	39 c2                	cmp    %eax,%edx
  8029fa:	73 78                	jae    802a74 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 40 04             	mov    0x4(%eax),%eax
  802a02:	85 c0                	test   %eax,%eax
  802a04:	75 6e                	jne    802a74 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802a06:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a0a:	74 68                	je     802a74 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802a0c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a10:	75 17                	jne    802a29 <insert_sorted_with_merge_freeList+0x160>
  802a12:	83 ec 04             	sub    $0x4,%esp
  802a15:	68 94 3c 80 00       	push   $0x803c94
  802a1a:	68 e6 00 00 00       	push   $0xe6
  802a1f:	68 b7 3c 80 00       	push   $0x803cb7
  802a24:	e8 c0 d8 ff ff       	call   8002e9 <_panic>
  802a29:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a32:	89 10                	mov    %edx,(%eax)
  802a34:	8b 45 08             	mov    0x8(%ebp),%eax
  802a37:	8b 00                	mov    (%eax),%eax
  802a39:	85 c0                	test   %eax,%eax
  802a3b:	74 0d                	je     802a4a <insert_sorted_with_merge_freeList+0x181>
  802a3d:	a1 38 41 80 00       	mov    0x804138,%eax
  802a42:	8b 55 08             	mov    0x8(%ebp),%edx
  802a45:	89 50 04             	mov    %edx,0x4(%eax)
  802a48:	eb 08                	jmp    802a52 <insert_sorted_with_merge_freeList+0x189>
  802a4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a52:	8b 45 08             	mov    0x8(%ebp),%eax
  802a55:	a3 38 41 80 00       	mov    %eax,0x804138
  802a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a64:	a1 44 41 80 00       	mov    0x804144,%eax
  802a69:	40                   	inc    %eax
  802a6a:	a3 44 41 80 00       	mov    %eax,0x804144
  802a6f:	e9 2a 06 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802a74:	a1 38 41 80 00       	mov    0x804138,%eax
  802a79:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a7c:	e9 ed 05 00 00       	jmp    80306e <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a84:	8b 00                	mov    (%eax),%eax
  802a86:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802a89:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a8d:	0f 84 a7 00 00 00    	je     802b3a <insert_sorted_with_merge_freeList+0x271>
  802a93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a96:	8b 50 0c             	mov    0xc(%eax),%edx
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	8b 40 08             	mov    0x8(%eax),%eax
  802a9f:	01 c2                	add    %eax,%edx
  802aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa4:	8b 40 08             	mov    0x8(%eax),%eax
  802aa7:	39 c2                	cmp    %eax,%edx
  802aa9:	0f 83 8b 00 00 00    	jae    802b3a <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab8:	8b 40 08             	mov    0x8(%eax),%eax
  802abb:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802abd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ac0:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802ac3:	39 c2                	cmp    %eax,%edx
  802ac5:	73 73                	jae    802b3a <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802ac7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802acb:	74 06                	je     802ad3 <insert_sorted_with_merge_freeList+0x20a>
  802acd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad1:	75 17                	jne    802aea <insert_sorted_with_merge_freeList+0x221>
  802ad3:	83 ec 04             	sub    $0x4,%esp
  802ad6:	68 48 3d 80 00       	push   $0x803d48
  802adb:	68 f0 00 00 00       	push   $0xf0
  802ae0:	68 b7 3c 80 00       	push   $0x803cb7
  802ae5:	e8 ff d7 ff ff       	call   8002e9 <_panic>
  802aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aed:	8b 10                	mov    (%eax),%edx
  802aef:	8b 45 08             	mov    0x8(%ebp),%eax
  802af2:	89 10                	mov    %edx,(%eax)
  802af4:	8b 45 08             	mov    0x8(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	85 c0                	test   %eax,%eax
  802afb:	74 0b                	je     802b08 <insert_sorted_with_merge_freeList+0x23f>
  802afd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b00:	8b 00                	mov    (%eax),%eax
  802b02:	8b 55 08             	mov    0x8(%ebp),%edx
  802b05:	89 50 04             	mov    %edx,0x4(%eax)
  802b08:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b0b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b0e:	89 10                	mov    %edx,(%eax)
  802b10:	8b 45 08             	mov    0x8(%ebp),%eax
  802b13:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b16:	89 50 04             	mov    %edx,0x4(%eax)
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	8b 00                	mov    (%eax),%eax
  802b1e:	85 c0                	test   %eax,%eax
  802b20:	75 08                	jne    802b2a <insert_sorted_with_merge_freeList+0x261>
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b2a:	a1 44 41 80 00       	mov    0x804144,%eax
  802b2f:	40                   	inc    %eax
  802b30:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802b35:	e9 64 05 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802b3a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b3f:	8b 50 0c             	mov    0xc(%eax),%edx
  802b42:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b47:	8b 40 08             	mov    0x8(%eax),%eax
  802b4a:	01 c2                	add    %eax,%edx
  802b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4f:	8b 40 08             	mov    0x8(%eax),%eax
  802b52:	39 c2                	cmp    %eax,%edx
  802b54:	0f 85 b1 00 00 00    	jne    802c0b <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802b5a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b5f:	85 c0                	test   %eax,%eax
  802b61:	0f 84 a4 00 00 00    	je     802c0b <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802b67:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b6c:	8b 00                	mov    (%eax),%eax
  802b6e:	85 c0                	test   %eax,%eax
  802b70:	0f 85 95 00 00 00    	jne    802c0b <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802b76:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b7b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b81:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b84:	8b 55 08             	mov    0x8(%ebp),%edx
  802b87:	8b 52 0c             	mov    0xc(%edx),%edx
  802b8a:	01 ca                	add    %ecx,%edx
  802b8c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b92:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802b99:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802ba3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ba7:	75 17                	jne    802bc0 <insert_sorted_with_merge_freeList+0x2f7>
  802ba9:	83 ec 04             	sub    $0x4,%esp
  802bac:	68 94 3c 80 00       	push   $0x803c94
  802bb1:	68 ff 00 00 00       	push   $0xff
  802bb6:	68 b7 3c 80 00       	push   $0x803cb7
  802bbb:	e8 29 d7 ff ff       	call   8002e9 <_panic>
  802bc0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc9:	89 10                	mov    %edx,(%eax)
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	8b 00                	mov    (%eax),%eax
  802bd0:	85 c0                	test   %eax,%eax
  802bd2:	74 0d                	je     802be1 <insert_sorted_with_merge_freeList+0x318>
  802bd4:	a1 48 41 80 00       	mov    0x804148,%eax
  802bd9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bdc:	89 50 04             	mov    %edx,0x4(%eax)
  802bdf:	eb 08                	jmp    802be9 <insert_sorted_with_merge_freeList+0x320>
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	a3 48 41 80 00       	mov    %eax,0x804148
  802bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802bfb:	a1 54 41 80 00       	mov    0x804154,%eax
  802c00:	40                   	inc    %eax
  802c01:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802c06:	e9 93 04 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0e:	8b 50 08             	mov    0x8(%eax),%edx
  802c11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c14:	8b 40 0c             	mov    0xc(%eax),%eax
  802c17:	01 c2                	add    %eax,%edx
  802c19:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1c:	8b 40 08             	mov    0x8(%eax),%eax
  802c1f:	39 c2                	cmp    %eax,%edx
  802c21:	0f 85 ae 00 00 00    	jne    802cd5 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802c27:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2a:	8b 50 0c             	mov    0xc(%eax),%edx
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	8b 40 08             	mov    0x8(%eax),%eax
  802c33:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802c35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c38:	8b 00                	mov    (%eax),%eax
  802c3a:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802c3d:	39 c2                	cmp    %eax,%edx
  802c3f:	0f 84 90 00 00 00    	je     802cd5 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802c45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c48:	8b 50 0c             	mov    0xc(%eax),%edx
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	8b 40 0c             	mov    0xc(%eax),%eax
  802c51:	01 c2                	add    %eax,%edx
  802c53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c56:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802c59:	8b 45 08             	mov    0x8(%ebp),%eax
  802c5c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802c63:	8b 45 08             	mov    0x8(%ebp),%eax
  802c66:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c6d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c71:	75 17                	jne    802c8a <insert_sorted_with_merge_freeList+0x3c1>
  802c73:	83 ec 04             	sub    $0x4,%esp
  802c76:	68 94 3c 80 00       	push   $0x803c94
  802c7b:	68 0b 01 00 00       	push   $0x10b
  802c80:	68 b7 3c 80 00       	push   $0x803cb7
  802c85:	e8 5f d6 ff ff       	call   8002e9 <_panic>
  802c8a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	89 10                	mov    %edx,(%eax)
  802c95:	8b 45 08             	mov    0x8(%ebp),%eax
  802c98:	8b 00                	mov    (%eax),%eax
  802c9a:	85 c0                	test   %eax,%eax
  802c9c:	74 0d                	je     802cab <insert_sorted_with_merge_freeList+0x3e2>
  802c9e:	a1 48 41 80 00       	mov    0x804148,%eax
  802ca3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ca6:	89 50 04             	mov    %edx,0x4(%eax)
  802ca9:	eb 08                	jmp    802cb3 <insert_sorted_with_merge_freeList+0x3ea>
  802cab:	8b 45 08             	mov    0x8(%ebp),%eax
  802cae:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cb3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb6:	a3 48 41 80 00       	mov    %eax,0x804148
  802cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbe:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cc5:	a1 54 41 80 00       	mov    0x804154,%eax
  802cca:	40                   	inc    %eax
  802ccb:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802cd0:	e9 c9 03 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd8:	8b 50 0c             	mov    0xc(%eax),%edx
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	8b 40 08             	mov    0x8(%eax),%eax
  802ce1:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce6:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802ce9:	39 c2                	cmp    %eax,%edx
  802ceb:	0f 85 bb 00 00 00    	jne    802dac <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802cf1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf5:	0f 84 b1 00 00 00    	je     802dac <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfe:	8b 40 04             	mov    0x4(%eax),%eax
  802d01:	85 c0                	test   %eax,%eax
  802d03:	0f 85 a3 00 00 00    	jne    802dac <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802d09:	a1 38 41 80 00       	mov    0x804138,%eax
  802d0e:	8b 55 08             	mov    0x8(%ebp),%edx
  802d11:	8b 52 08             	mov    0x8(%edx),%edx
  802d14:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802d17:	a1 38 41 80 00       	mov    0x804138,%eax
  802d1c:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d22:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802d25:	8b 55 08             	mov    0x8(%ebp),%edx
  802d28:	8b 52 0c             	mov    0xc(%edx),%edx
  802d2b:	01 ca                	add    %ecx,%edx
  802d2d:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802d30:	8b 45 08             	mov    0x8(%ebp),%eax
  802d33:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d44:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d48:	75 17                	jne    802d61 <insert_sorted_with_merge_freeList+0x498>
  802d4a:	83 ec 04             	sub    $0x4,%esp
  802d4d:	68 94 3c 80 00       	push   $0x803c94
  802d52:	68 17 01 00 00       	push   $0x117
  802d57:	68 b7 3c 80 00       	push   $0x803cb7
  802d5c:	e8 88 d5 ff ff       	call   8002e9 <_panic>
  802d61:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	89 10                	mov    %edx,(%eax)
  802d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6f:	8b 00                	mov    (%eax),%eax
  802d71:	85 c0                	test   %eax,%eax
  802d73:	74 0d                	je     802d82 <insert_sorted_with_merge_freeList+0x4b9>
  802d75:	a1 48 41 80 00       	mov    0x804148,%eax
  802d7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d7d:	89 50 04             	mov    %edx,0x4(%eax)
  802d80:	eb 08                	jmp    802d8a <insert_sorted_with_merge_freeList+0x4c1>
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8d:	a3 48 41 80 00       	mov    %eax,0x804148
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d9c:	a1 54 41 80 00       	mov    0x804154,%eax
  802da1:	40                   	inc    %eax
  802da2:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802da7:	e9 f2 02 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802dac:	8b 45 08             	mov    0x8(%ebp),%eax
  802daf:	8b 50 08             	mov    0x8(%eax),%edx
  802db2:	8b 45 08             	mov    0x8(%ebp),%eax
  802db5:	8b 40 0c             	mov    0xc(%eax),%eax
  802db8:	01 c2                	add    %eax,%edx
  802dba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbd:	8b 40 08             	mov    0x8(%eax),%eax
  802dc0:	39 c2                	cmp    %eax,%edx
  802dc2:	0f 85 be 00 00 00    	jne    802e86 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802dc8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcb:	8b 40 04             	mov    0x4(%eax),%eax
  802dce:	8b 50 08             	mov    0x8(%eax),%edx
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	8b 40 04             	mov    0x4(%eax),%eax
  802dd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802dda:	01 c2                	add    %eax,%edx
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	8b 40 08             	mov    0x8(%eax),%eax
  802de2:	39 c2                	cmp    %eax,%edx
  802de4:	0f 84 9c 00 00 00    	je     802e86 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802dea:	8b 45 08             	mov    0x8(%ebp),%eax
  802ded:	8b 50 08             	mov    0x8(%eax),%edx
  802df0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df3:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802df6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802df9:	8b 50 0c             	mov    0xc(%eax),%edx
  802dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802dff:	8b 40 0c             	mov    0xc(%eax),%eax
  802e02:	01 c2                	add    %eax,%edx
  802e04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e07:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e1e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e22:	75 17                	jne    802e3b <insert_sorted_with_merge_freeList+0x572>
  802e24:	83 ec 04             	sub    $0x4,%esp
  802e27:	68 94 3c 80 00       	push   $0x803c94
  802e2c:	68 26 01 00 00       	push   $0x126
  802e31:	68 b7 3c 80 00       	push   $0x803cb7
  802e36:	e8 ae d4 ff ff       	call   8002e9 <_panic>
  802e3b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e41:	8b 45 08             	mov    0x8(%ebp),%eax
  802e44:	89 10                	mov    %edx,(%eax)
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	8b 00                	mov    (%eax),%eax
  802e4b:	85 c0                	test   %eax,%eax
  802e4d:	74 0d                	je     802e5c <insert_sorted_with_merge_freeList+0x593>
  802e4f:	a1 48 41 80 00       	mov    0x804148,%eax
  802e54:	8b 55 08             	mov    0x8(%ebp),%edx
  802e57:	89 50 04             	mov    %edx,0x4(%eax)
  802e5a:	eb 08                	jmp    802e64 <insert_sorted_with_merge_freeList+0x59b>
  802e5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	a3 48 41 80 00       	mov    %eax,0x804148
  802e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e76:	a1 54 41 80 00       	mov    0x804154,%eax
  802e7b:	40                   	inc    %eax
  802e7c:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802e81:	e9 18 02 00 00       	jmp    80309e <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 50 0c             	mov    0xc(%eax),%edx
  802e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8f:	8b 40 08             	mov    0x8(%eax),%eax
  802e92:	01 c2                	add    %eax,%edx
  802e94:	8b 45 08             	mov    0x8(%ebp),%eax
  802e97:	8b 40 08             	mov    0x8(%eax),%eax
  802e9a:	39 c2                	cmp    %eax,%edx
  802e9c:	0f 85 c4 01 00 00    	jne    803066 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802ea2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea5:	8b 50 0c             	mov    0xc(%eax),%edx
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	8b 40 08             	mov    0x8(%eax),%eax
  802eae:	01 c2                	add    %eax,%edx
  802eb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb3:	8b 00                	mov    (%eax),%eax
  802eb5:	8b 40 08             	mov    0x8(%eax),%eax
  802eb8:	39 c2                	cmp    %eax,%edx
  802eba:	0f 85 a6 01 00 00    	jne    803066 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802ec0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ec4:	0f 84 9c 01 00 00    	je     803066 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802eca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecd:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed3:	8b 40 0c             	mov    0xc(%eax),%eax
  802ed6:	01 c2                	add    %eax,%edx
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	8b 00                	mov    (%eax),%eax
  802edd:	8b 40 0c             	mov    0xc(%eax),%eax
  802ee0:	01 c2                	add    %eax,%edx
  802ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee5:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802efc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f00:	75 17                	jne    802f19 <insert_sorted_with_merge_freeList+0x650>
  802f02:	83 ec 04             	sub    $0x4,%esp
  802f05:	68 94 3c 80 00       	push   $0x803c94
  802f0a:	68 32 01 00 00       	push   $0x132
  802f0f:	68 b7 3c 80 00       	push   $0x803cb7
  802f14:	e8 d0 d3 ff ff       	call   8002e9 <_panic>
  802f19:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f22:	89 10                	mov    %edx,(%eax)
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	74 0d                	je     802f3a <insert_sorted_with_merge_freeList+0x671>
  802f2d:	a1 48 41 80 00       	mov    0x804148,%eax
  802f32:	8b 55 08             	mov    0x8(%ebp),%edx
  802f35:	89 50 04             	mov    %edx,0x4(%eax)
  802f38:	eb 08                	jmp    802f42 <insert_sorted_with_merge_freeList+0x679>
  802f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f42:	8b 45 08             	mov    0x8(%ebp),%eax
  802f45:	a3 48 41 80 00       	mov    %eax,0x804148
  802f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f54:	a1 54 41 80 00       	mov    0x804154,%eax
  802f59:	40                   	inc    %eax
  802f5a:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802f5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f62:	8b 00                	mov    (%eax),%eax
  802f64:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f6e:	8b 00                	mov    (%eax),%eax
  802f70:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802f77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f7a:	8b 00                	mov    (%eax),%eax
  802f7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802f7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f83:	75 17                	jne    802f9c <insert_sorted_with_merge_freeList+0x6d3>
  802f85:	83 ec 04             	sub    $0x4,%esp
  802f88:	68 29 3d 80 00       	push   $0x803d29
  802f8d:	68 36 01 00 00       	push   $0x136
  802f92:	68 b7 3c 80 00       	push   $0x803cb7
  802f97:	e8 4d d3 ff ff       	call   8002e9 <_panic>
  802f9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9f:	8b 00                	mov    (%eax),%eax
  802fa1:	85 c0                	test   %eax,%eax
  802fa3:	74 10                	je     802fb5 <insert_sorted_with_merge_freeList+0x6ec>
  802fa5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fa8:	8b 00                	mov    (%eax),%eax
  802faa:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fad:	8b 52 04             	mov    0x4(%edx),%edx
  802fb0:	89 50 04             	mov    %edx,0x4(%eax)
  802fb3:	eb 0b                	jmp    802fc0 <insert_sorted_with_merge_freeList+0x6f7>
  802fb5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb8:	8b 40 04             	mov    0x4(%eax),%eax
  802fbb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802fc0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc3:	8b 40 04             	mov    0x4(%eax),%eax
  802fc6:	85 c0                	test   %eax,%eax
  802fc8:	74 0f                	je     802fd9 <insert_sorted_with_merge_freeList+0x710>
  802fca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fcd:	8b 40 04             	mov    0x4(%eax),%eax
  802fd0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fd3:	8b 12                	mov    (%edx),%edx
  802fd5:	89 10                	mov    %edx,(%eax)
  802fd7:	eb 0a                	jmp    802fe3 <insert_sorted_with_merge_freeList+0x71a>
  802fd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fdc:	8b 00                	mov    (%eax),%eax
  802fde:	a3 38 41 80 00       	mov    %eax,0x804138
  802fe3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fec:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fef:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ff6:	a1 44 41 80 00       	mov    0x804144,%eax
  802ffb:	48                   	dec    %eax
  802ffc:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  803001:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803005:	75 17                	jne    80301e <insert_sorted_with_merge_freeList+0x755>
  803007:	83 ec 04             	sub    $0x4,%esp
  80300a:	68 94 3c 80 00       	push   $0x803c94
  80300f:	68 37 01 00 00       	push   $0x137
  803014:	68 b7 3c 80 00       	push   $0x803cb7
  803019:	e8 cb d2 ff ff       	call   8002e9 <_panic>
  80301e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803024:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803027:	89 10                	mov    %edx,(%eax)
  803029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302c:	8b 00                	mov    (%eax),%eax
  80302e:	85 c0                	test   %eax,%eax
  803030:	74 0d                	je     80303f <insert_sorted_with_merge_freeList+0x776>
  803032:	a1 48 41 80 00       	mov    0x804148,%eax
  803037:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80303a:	89 50 04             	mov    %edx,0x4(%eax)
  80303d:	eb 08                	jmp    803047 <insert_sorted_with_merge_freeList+0x77e>
  80303f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803042:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803047:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80304a:	a3 48 41 80 00       	mov    %eax,0x804148
  80304f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803052:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803059:	a1 54 41 80 00       	mov    0x804154,%eax
  80305e:	40                   	inc    %eax
  80305f:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  803064:	eb 38                	jmp    80309e <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803066:	a1 40 41 80 00       	mov    0x804140,%eax
  80306b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80306e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803072:	74 07                	je     80307b <insert_sorted_with_merge_freeList+0x7b2>
  803074:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803077:	8b 00                	mov    (%eax),%eax
  803079:	eb 05                	jmp    803080 <insert_sorted_with_merge_freeList+0x7b7>
  80307b:	b8 00 00 00 00       	mov    $0x0,%eax
  803080:	a3 40 41 80 00       	mov    %eax,0x804140
  803085:	a1 40 41 80 00       	mov    0x804140,%eax
  80308a:	85 c0                	test   %eax,%eax
  80308c:	0f 85 ef f9 ff ff    	jne    802a81 <insert_sorted_with_merge_freeList+0x1b8>
  803092:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803096:	0f 85 e5 f9 ff ff    	jne    802a81 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  80309c:	eb 00                	jmp    80309e <insert_sorted_with_merge_freeList+0x7d5>
  80309e:	90                   	nop
  80309f:	c9                   	leave  
  8030a0:	c3                   	ret    

008030a1 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8030a1:	55                   	push   %ebp
  8030a2:	89 e5                	mov    %esp,%ebp
  8030a4:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8030a7:	8b 55 08             	mov    0x8(%ebp),%edx
  8030aa:	89 d0                	mov    %edx,%eax
  8030ac:	c1 e0 02             	shl    $0x2,%eax
  8030af:	01 d0                	add    %edx,%eax
  8030b1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030b8:	01 d0                	add    %edx,%eax
  8030ba:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030c1:	01 d0                	add    %edx,%eax
  8030c3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030ca:	01 d0                	add    %edx,%eax
  8030cc:	c1 e0 04             	shl    $0x4,%eax
  8030cf:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  8030d2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  8030d9:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8030dc:	83 ec 0c             	sub    $0xc,%esp
  8030df:	50                   	push   %eax
  8030e0:	e8 21 ec ff ff       	call   801d06 <sys_get_virtual_time>
  8030e5:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  8030e8:	eb 41                	jmp    80312b <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  8030ea:	8d 45 e0             	lea    -0x20(%ebp),%eax
  8030ed:	83 ec 0c             	sub    $0xc,%esp
  8030f0:	50                   	push   %eax
  8030f1:	e8 10 ec ff ff       	call   801d06 <sys_get_virtual_time>
  8030f6:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  8030f9:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ff:	29 c2                	sub    %eax,%edx
  803101:	89 d0                	mov    %edx,%eax
  803103:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803106:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803109:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80310c:	89 d1                	mov    %edx,%ecx
  80310e:	29 c1                	sub    %eax,%ecx
  803110:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803113:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803116:	39 c2                	cmp    %eax,%edx
  803118:	0f 97 c0             	seta   %al
  80311b:	0f b6 c0             	movzbl %al,%eax
  80311e:	29 c1                	sub    %eax,%ecx
  803120:	89 c8                	mov    %ecx,%eax
  803122:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803125:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803128:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  80312b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803131:	72 b7                	jb     8030ea <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803133:	90                   	nop
  803134:	c9                   	leave  
  803135:	c3                   	ret    

00803136 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803136:	55                   	push   %ebp
  803137:	89 e5                	mov    %esp,%ebp
  803139:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  80313c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803143:	eb 03                	jmp    803148 <busy_wait+0x12>
  803145:	ff 45 fc             	incl   -0x4(%ebp)
  803148:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80314b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80314e:	72 f5                	jb     803145 <busy_wait+0xf>
	return i;
  803150:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803153:	c9                   	leave  
  803154:	c3                   	ret    
  803155:	66 90                	xchg   %ax,%ax
  803157:	90                   	nop

00803158 <__udivdi3>:
  803158:	55                   	push   %ebp
  803159:	57                   	push   %edi
  80315a:	56                   	push   %esi
  80315b:	53                   	push   %ebx
  80315c:	83 ec 1c             	sub    $0x1c,%esp
  80315f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803163:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803167:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80316b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80316f:	89 ca                	mov    %ecx,%edx
  803171:	89 f8                	mov    %edi,%eax
  803173:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803177:	85 f6                	test   %esi,%esi
  803179:	75 2d                	jne    8031a8 <__udivdi3+0x50>
  80317b:	39 cf                	cmp    %ecx,%edi
  80317d:	77 65                	ja     8031e4 <__udivdi3+0x8c>
  80317f:	89 fd                	mov    %edi,%ebp
  803181:	85 ff                	test   %edi,%edi
  803183:	75 0b                	jne    803190 <__udivdi3+0x38>
  803185:	b8 01 00 00 00       	mov    $0x1,%eax
  80318a:	31 d2                	xor    %edx,%edx
  80318c:	f7 f7                	div    %edi
  80318e:	89 c5                	mov    %eax,%ebp
  803190:	31 d2                	xor    %edx,%edx
  803192:	89 c8                	mov    %ecx,%eax
  803194:	f7 f5                	div    %ebp
  803196:	89 c1                	mov    %eax,%ecx
  803198:	89 d8                	mov    %ebx,%eax
  80319a:	f7 f5                	div    %ebp
  80319c:	89 cf                	mov    %ecx,%edi
  80319e:	89 fa                	mov    %edi,%edx
  8031a0:	83 c4 1c             	add    $0x1c,%esp
  8031a3:	5b                   	pop    %ebx
  8031a4:	5e                   	pop    %esi
  8031a5:	5f                   	pop    %edi
  8031a6:	5d                   	pop    %ebp
  8031a7:	c3                   	ret    
  8031a8:	39 ce                	cmp    %ecx,%esi
  8031aa:	77 28                	ja     8031d4 <__udivdi3+0x7c>
  8031ac:	0f bd fe             	bsr    %esi,%edi
  8031af:	83 f7 1f             	xor    $0x1f,%edi
  8031b2:	75 40                	jne    8031f4 <__udivdi3+0x9c>
  8031b4:	39 ce                	cmp    %ecx,%esi
  8031b6:	72 0a                	jb     8031c2 <__udivdi3+0x6a>
  8031b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031bc:	0f 87 9e 00 00 00    	ja     803260 <__udivdi3+0x108>
  8031c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8031c7:	89 fa                	mov    %edi,%edx
  8031c9:	83 c4 1c             	add    $0x1c,%esp
  8031cc:	5b                   	pop    %ebx
  8031cd:	5e                   	pop    %esi
  8031ce:	5f                   	pop    %edi
  8031cf:	5d                   	pop    %ebp
  8031d0:	c3                   	ret    
  8031d1:	8d 76 00             	lea    0x0(%esi),%esi
  8031d4:	31 ff                	xor    %edi,%edi
  8031d6:	31 c0                	xor    %eax,%eax
  8031d8:	89 fa                	mov    %edi,%edx
  8031da:	83 c4 1c             	add    $0x1c,%esp
  8031dd:	5b                   	pop    %ebx
  8031de:	5e                   	pop    %esi
  8031df:	5f                   	pop    %edi
  8031e0:	5d                   	pop    %ebp
  8031e1:	c3                   	ret    
  8031e2:	66 90                	xchg   %ax,%ax
  8031e4:	89 d8                	mov    %ebx,%eax
  8031e6:	f7 f7                	div    %edi
  8031e8:	31 ff                	xor    %edi,%edi
  8031ea:	89 fa                	mov    %edi,%edx
  8031ec:	83 c4 1c             	add    $0x1c,%esp
  8031ef:	5b                   	pop    %ebx
  8031f0:	5e                   	pop    %esi
  8031f1:	5f                   	pop    %edi
  8031f2:	5d                   	pop    %ebp
  8031f3:	c3                   	ret    
  8031f4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031f9:	89 eb                	mov    %ebp,%ebx
  8031fb:	29 fb                	sub    %edi,%ebx
  8031fd:	89 f9                	mov    %edi,%ecx
  8031ff:	d3 e6                	shl    %cl,%esi
  803201:	89 c5                	mov    %eax,%ebp
  803203:	88 d9                	mov    %bl,%cl
  803205:	d3 ed                	shr    %cl,%ebp
  803207:	89 e9                	mov    %ebp,%ecx
  803209:	09 f1                	or     %esi,%ecx
  80320b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80320f:	89 f9                	mov    %edi,%ecx
  803211:	d3 e0                	shl    %cl,%eax
  803213:	89 c5                	mov    %eax,%ebp
  803215:	89 d6                	mov    %edx,%esi
  803217:	88 d9                	mov    %bl,%cl
  803219:	d3 ee                	shr    %cl,%esi
  80321b:	89 f9                	mov    %edi,%ecx
  80321d:	d3 e2                	shl    %cl,%edx
  80321f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803223:	88 d9                	mov    %bl,%cl
  803225:	d3 e8                	shr    %cl,%eax
  803227:	09 c2                	or     %eax,%edx
  803229:	89 d0                	mov    %edx,%eax
  80322b:	89 f2                	mov    %esi,%edx
  80322d:	f7 74 24 0c          	divl   0xc(%esp)
  803231:	89 d6                	mov    %edx,%esi
  803233:	89 c3                	mov    %eax,%ebx
  803235:	f7 e5                	mul    %ebp
  803237:	39 d6                	cmp    %edx,%esi
  803239:	72 19                	jb     803254 <__udivdi3+0xfc>
  80323b:	74 0b                	je     803248 <__udivdi3+0xf0>
  80323d:	89 d8                	mov    %ebx,%eax
  80323f:	31 ff                	xor    %edi,%edi
  803241:	e9 58 ff ff ff       	jmp    80319e <__udivdi3+0x46>
  803246:	66 90                	xchg   %ax,%ax
  803248:	8b 54 24 08          	mov    0x8(%esp),%edx
  80324c:	89 f9                	mov    %edi,%ecx
  80324e:	d3 e2                	shl    %cl,%edx
  803250:	39 c2                	cmp    %eax,%edx
  803252:	73 e9                	jae    80323d <__udivdi3+0xe5>
  803254:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803257:	31 ff                	xor    %edi,%edi
  803259:	e9 40 ff ff ff       	jmp    80319e <__udivdi3+0x46>
  80325e:	66 90                	xchg   %ax,%ax
  803260:	31 c0                	xor    %eax,%eax
  803262:	e9 37 ff ff ff       	jmp    80319e <__udivdi3+0x46>
  803267:	90                   	nop

00803268 <__umoddi3>:
  803268:	55                   	push   %ebp
  803269:	57                   	push   %edi
  80326a:	56                   	push   %esi
  80326b:	53                   	push   %ebx
  80326c:	83 ec 1c             	sub    $0x1c,%esp
  80326f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803273:	8b 74 24 34          	mov    0x34(%esp),%esi
  803277:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80327b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80327f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803283:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803287:	89 f3                	mov    %esi,%ebx
  803289:	89 fa                	mov    %edi,%edx
  80328b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80328f:	89 34 24             	mov    %esi,(%esp)
  803292:	85 c0                	test   %eax,%eax
  803294:	75 1a                	jne    8032b0 <__umoddi3+0x48>
  803296:	39 f7                	cmp    %esi,%edi
  803298:	0f 86 a2 00 00 00    	jbe    803340 <__umoddi3+0xd8>
  80329e:	89 c8                	mov    %ecx,%eax
  8032a0:	89 f2                	mov    %esi,%edx
  8032a2:	f7 f7                	div    %edi
  8032a4:	89 d0                	mov    %edx,%eax
  8032a6:	31 d2                	xor    %edx,%edx
  8032a8:	83 c4 1c             	add    $0x1c,%esp
  8032ab:	5b                   	pop    %ebx
  8032ac:	5e                   	pop    %esi
  8032ad:	5f                   	pop    %edi
  8032ae:	5d                   	pop    %ebp
  8032af:	c3                   	ret    
  8032b0:	39 f0                	cmp    %esi,%eax
  8032b2:	0f 87 ac 00 00 00    	ja     803364 <__umoddi3+0xfc>
  8032b8:	0f bd e8             	bsr    %eax,%ebp
  8032bb:	83 f5 1f             	xor    $0x1f,%ebp
  8032be:	0f 84 ac 00 00 00    	je     803370 <__umoddi3+0x108>
  8032c4:	bf 20 00 00 00       	mov    $0x20,%edi
  8032c9:	29 ef                	sub    %ebp,%edi
  8032cb:	89 fe                	mov    %edi,%esi
  8032cd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032d1:	89 e9                	mov    %ebp,%ecx
  8032d3:	d3 e0                	shl    %cl,%eax
  8032d5:	89 d7                	mov    %edx,%edi
  8032d7:	89 f1                	mov    %esi,%ecx
  8032d9:	d3 ef                	shr    %cl,%edi
  8032db:	09 c7                	or     %eax,%edi
  8032dd:	89 e9                	mov    %ebp,%ecx
  8032df:	d3 e2                	shl    %cl,%edx
  8032e1:	89 14 24             	mov    %edx,(%esp)
  8032e4:	89 d8                	mov    %ebx,%eax
  8032e6:	d3 e0                	shl    %cl,%eax
  8032e8:	89 c2                	mov    %eax,%edx
  8032ea:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032ee:	d3 e0                	shl    %cl,%eax
  8032f0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032f4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032f8:	89 f1                	mov    %esi,%ecx
  8032fa:	d3 e8                	shr    %cl,%eax
  8032fc:	09 d0                	or     %edx,%eax
  8032fe:	d3 eb                	shr    %cl,%ebx
  803300:	89 da                	mov    %ebx,%edx
  803302:	f7 f7                	div    %edi
  803304:	89 d3                	mov    %edx,%ebx
  803306:	f7 24 24             	mull   (%esp)
  803309:	89 c6                	mov    %eax,%esi
  80330b:	89 d1                	mov    %edx,%ecx
  80330d:	39 d3                	cmp    %edx,%ebx
  80330f:	0f 82 87 00 00 00    	jb     80339c <__umoddi3+0x134>
  803315:	0f 84 91 00 00 00    	je     8033ac <__umoddi3+0x144>
  80331b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80331f:	29 f2                	sub    %esi,%edx
  803321:	19 cb                	sbb    %ecx,%ebx
  803323:	89 d8                	mov    %ebx,%eax
  803325:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803329:	d3 e0                	shl    %cl,%eax
  80332b:	89 e9                	mov    %ebp,%ecx
  80332d:	d3 ea                	shr    %cl,%edx
  80332f:	09 d0                	or     %edx,%eax
  803331:	89 e9                	mov    %ebp,%ecx
  803333:	d3 eb                	shr    %cl,%ebx
  803335:	89 da                	mov    %ebx,%edx
  803337:	83 c4 1c             	add    $0x1c,%esp
  80333a:	5b                   	pop    %ebx
  80333b:	5e                   	pop    %esi
  80333c:	5f                   	pop    %edi
  80333d:	5d                   	pop    %ebp
  80333e:	c3                   	ret    
  80333f:	90                   	nop
  803340:	89 fd                	mov    %edi,%ebp
  803342:	85 ff                	test   %edi,%edi
  803344:	75 0b                	jne    803351 <__umoddi3+0xe9>
  803346:	b8 01 00 00 00       	mov    $0x1,%eax
  80334b:	31 d2                	xor    %edx,%edx
  80334d:	f7 f7                	div    %edi
  80334f:	89 c5                	mov    %eax,%ebp
  803351:	89 f0                	mov    %esi,%eax
  803353:	31 d2                	xor    %edx,%edx
  803355:	f7 f5                	div    %ebp
  803357:	89 c8                	mov    %ecx,%eax
  803359:	f7 f5                	div    %ebp
  80335b:	89 d0                	mov    %edx,%eax
  80335d:	e9 44 ff ff ff       	jmp    8032a6 <__umoddi3+0x3e>
  803362:	66 90                	xchg   %ax,%ax
  803364:	89 c8                	mov    %ecx,%eax
  803366:	89 f2                	mov    %esi,%edx
  803368:	83 c4 1c             	add    $0x1c,%esp
  80336b:	5b                   	pop    %ebx
  80336c:	5e                   	pop    %esi
  80336d:	5f                   	pop    %edi
  80336e:	5d                   	pop    %ebp
  80336f:	c3                   	ret    
  803370:	3b 04 24             	cmp    (%esp),%eax
  803373:	72 06                	jb     80337b <__umoddi3+0x113>
  803375:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803379:	77 0f                	ja     80338a <__umoddi3+0x122>
  80337b:	89 f2                	mov    %esi,%edx
  80337d:	29 f9                	sub    %edi,%ecx
  80337f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803383:	89 14 24             	mov    %edx,(%esp)
  803386:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80338a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80338e:	8b 14 24             	mov    (%esp),%edx
  803391:	83 c4 1c             	add    $0x1c,%esp
  803394:	5b                   	pop    %ebx
  803395:	5e                   	pop    %esi
  803396:	5f                   	pop    %edi
  803397:	5d                   	pop    %ebp
  803398:	c3                   	ret    
  803399:	8d 76 00             	lea    0x0(%esi),%esi
  80339c:	2b 04 24             	sub    (%esp),%eax
  80339f:	19 fa                	sbb    %edi,%edx
  8033a1:	89 d1                	mov    %edx,%ecx
  8033a3:	89 c6                	mov    %eax,%esi
  8033a5:	e9 71 ff ff ff       	jmp    80331b <__umoddi3+0xb3>
  8033aa:	66 90                	xchg   %ax,%ax
  8033ac:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033b0:	72 ea                	jb     80339c <__umoddi3+0x134>
  8033b2:	89 d9                	mov    %ebx,%ecx
  8033b4:	e9 62 ff ff ff       	jmp    80331b <__umoddi3+0xb3>
