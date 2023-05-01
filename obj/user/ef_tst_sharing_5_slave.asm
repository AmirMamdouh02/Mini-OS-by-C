
obj/user/ef_tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 e9 00 00 00       	call   80011f <libmain>
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
  80008c:	68 80 32 80 00       	push   $0x803280
  800091:	6a 12                	push   $0x12
  800093:	68 9c 32 80 00       	push   $0x80329c
  800098:	e8 be 01 00 00       	call   80025b <_panic>
	}

	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  80009d:	e8 a3 1b 00 00       	call   801c45 <sys_getparentenvid>
  8000a2:	83 ec 08             	sub    $0x8,%esp
  8000a5:	68 ba 32 80 00       	push   $0x8032ba
  8000aa:	50                   	push   %eax
  8000ab:	e8 4e 16 00 00       	call   8016fe <sget>
  8000b0:	83 c4 10             	add    $0x10,%esp
  8000b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000b6:	e8 91 18 00 00       	call   80194c <sys_calculate_free_frames>
  8000bb:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000be:	83 ec 0c             	sub    $0xc,%esp
  8000c1:	68 bc 32 80 00       	push   $0x8032bc
  8000c6:	e8 44 04 00 00       	call   80050f <cprintf>
  8000cb:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000ce:	83 ec 0c             	sub    $0xc,%esp
  8000d1:	ff 75 ec             	pushl  -0x14(%ebp)
  8000d4:	e8 13 17 00 00       	call   8017ec <sfree>
  8000d9:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000dc:	83 ec 0c             	sub    $0xc,%esp
  8000df:	68 e0 32 80 00       	push   $0x8032e0
  8000e4:	e8 26 04 00 00       	call   80050f <cprintf>
  8000e9:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000ec:	e8 5b 18 00 00       	call   80194c <sys_calculate_free_frames>
  8000f1:	89 c2                	mov    %eax,%edx
  8000f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000f6:	29 c2                	sub    %eax,%edx
  8000f8:	89 d0                	mov    %edx,%eax
  8000fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (diff != 1) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  8000fd:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  800101:	74 14                	je     800117 <_main+0xdf>
  800103:	83 ec 04             	sub    $0x4,%esp
  800106:	68 f8 32 80 00       	push   $0x8032f8
  80010b:	6a 1f                	push   $0x1f
  80010d:	68 9c 32 80 00       	push   $0x80329c
  800112:	e8 44 01 00 00       	call   80025b <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  800117:	e8 4e 1c 00 00       	call   801d6a <inctst>

	return;
  80011c:	90                   	nop
}
  80011d:	c9                   	leave  
  80011e:	c3                   	ret    

0080011f <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800125:	e8 02 1b 00 00       	call   801c2c <sys_getenvindex>
  80012a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80012d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800130:	89 d0                	mov    %edx,%eax
  800132:	c1 e0 03             	shl    $0x3,%eax
  800135:	01 d0                	add    %edx,%eax
  800137:	01 c0                	add    %eax,%eax
  800139:	01 d0                	add    %edx,%eax
  80013b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800142:	01 d0                	add    %edx,%eax
  800144:	c1 e0 04             	shl    $0x4,%eax
  800147:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80014c:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800151:	a1 20 40 80 00       	mov    0x804020,%eax
  800156:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80015c:	84 c0                	test   %al,%al
  80015e:	74 0f                	je     80016f <libmain+0x50>
		binaryname = myEnv->prog_name;
  800160:	a1 20 40 80 00       	mov    0x804020,%eax
  800165:	05 5c 05 00 00       	add    $0x55c,%eax
  80016a:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80016f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800173:	7e 0a                	jle    80017f <libmain+0x60>
		binaryname = argv[0];
  800175:	8b 45 0c             	mov    0xc(%ebp),%eax
  800178:	8b 00                	mov    (%eax),%eax
  80017a:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80017f:	83 ec 08             	sub    $0x8,%esp
  800182:	ff 75 0c             	pushl  0xc(%ebp)
  800185:	ff 75 08             	pushl  0x8(%ebp)
  800188:	e8 ab fe ff ff       	call   800038 <_main>
  80018d:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800190:	e8 a4 18 00 00       	call   801a39 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800195:	83 ec 0c             	sub    $0xc,%esp
  800198:	68 9c 33 80 00       	push   $0x80339c
  80019d:	e8 6d 03 00 00       	call   80050f <cprintf>
  8001a2:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001a5:	a1 20 40 80 00       	mov    0x804020,%eax
  8001aa:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001b0:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b5:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001bb:	83 ec 04             	sub    $0x4,%esp
  8001be:	52                   	push   %edx
  8001bf:	50                   	push   %eax
  8001c0:	68 c4 33 80 00       	push   $0x8033c4
  8001c5:	e8 45 03 00 00       	call   80050f <cprintf>
  8001ca:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001cd:	a1 20 40 80 00       	mov    0x804020,%eax
  8001d2:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8001dd:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e8:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8001ee:	51                   	push   %ecx
  8001ef:	52                   	push   %edx
  8001f0:	50                   	push   %eax
  8001f1:	68 ec 33 80 00       	push   $0x8033ec
  8001f6:	e8 14 03 00 00       	call   80050f <cprintf>
  8001fb:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8001fe:	a1 20 40 80 00       	mov    0x804020,%eax
  800203:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800209:	83 ec 08             	sub    $0x8,%esp
  80020c:	50                   	push   %eax
  80020d:	68 44 34 80 00       	push   $0x803444
  800212:	e8 f8 02 00 00       	call   80050f <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80021a:	83 ec 0c             	sub    $0xc,%esp
  80021d:	68 9c 33 80 00       	push   $0x80339c
  800222:	e8 e8 02 00 00       	call   80050f <cprintf>
  800227:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80022a:	e8 24 18 00 00       	call   801a53 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80022f:	e8 19 00 00 00       	call   80024d <exit>
}
  800234:	90                   	nop
  800235:	c9                   	leave  
  800236:	c3                   	ret    

00800237 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800237:	55                   	push   %ebp
  800238:	89 e5                	mov    %esp,%ebp
  80023a:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80023d:	83 ec 0c             	sub    $0xc,%esp
  800240:	6a 00                	push   $0x0
  800242:	e8 b1 19 00 00       	call   801bf8 <sys_destroy_env>
  800247:	83 c4 10             	add    $0x10,%esp
}
  80024a:	90                   	nop
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <exit>:

void
exit(void)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800253:	e8 06 1a 00 00       	call   801c5e <sys_exit_env>
}
  800258:	90                   	nop
  800259:	c9                   	leave  
  80025a:	c3                   	ret    

0080025b <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80025b:	55                   	push   %ebp
  80025c:	89 e5                	mov    %esp,%ebp
  80025e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800261:	8d 45 10             	lea    0x10(%ebp),%eax
  800264:	83 c0 04             	add    $0x4,%eax
  800267:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80026a:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80026f:	85 c0                	test   %eax,%eax
  800271:	74 16                	je     800289 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800273:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800278:	83 ec 08             	sub    $0x8,%esp
  80027b:	50                   	push   %eax
  80027c:	68 58 34 80 00       	push   $0x803458
  800281:	e8 89 02 00 00       	call   80050f <cprintf>
  800286:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800289:	a1 00 40 80 00       	mov    0x804000,%eax
  80028e:	ff 75 0c             	pushl  0xc(%ebp)
  800291:	ff 75 08             	pushl  0x8(%ebp)
  800294:	50                   	push   %eax
  800295:	68 5d 34 80 00       	push   $0x80345d
  80029a:	e8 70 02 00 00       	call   80050f <cprintf>
  80029f:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a5:	83 ec 08             	sub    $0x8,%esp
  8002a8:	ff 75 f4             	pushl  -0xc(%ebp)
  8002ab:	50                   	push   %eax
  8002ac:	e8 f3 01 00 00       	call   8004a4 <vcprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	6a 00                	push   $0x0
  8002b9:	68 79 34 80 00       	push   $0x803479
  8002be:	e8 e1 01 00 00       	call   8004a4 <vcprintf>
  8002c3:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002c6:	e8 82 ff ff ff       	call   80024d <exit>

	// should not return here
	while (1) ;
  8002cb:	eb fe                	jmp    8002cb <_panic+0x70>

008002cd <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002cd:	55                   	push   %ebp
  8002ce:	89 e5                	mov    %esp,%ebp
  8002d0:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d8:	8b 50 74             	mov    0x74(%eax),%edx
  8002db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002de:	39 c2                	cmp    %eax,%edx
  8002e0:	74 14                	je     8002f6 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002e2:	83 ec 04             	sub    $0x4,%esp
  8002e5:	68 7c 34 80 00       	push   $0x80347c
  8002ea:	6a 26                	push   $0x26
  8002ec:	68 c8 34 80 00       	push   $0x8034c8
  8002f1:	e8 65 ff ff ff       	call   80025b <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8002f6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8002fd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800304:	e9 c2 00 00 00       	jmp    8003cb <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800309:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80030c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800313:	8b 45 08             	mov    0x8(%ebp),%eax
  800316:	01 d0                	add    %edx,%eax
  800318:	8b 00                	mov    (%eax),%eax
  80031a:	85 c0                	test   %eax,%eax
  80031c:	75 08                	jne    800326 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80031e:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800321:	e9 a2 00 00 00       	jmp    8003c8 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800326:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80032d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800334:	eb 69                	jmp    80039f <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800336:	a1 20 40 80 00       	mov    0x804020,%eax
  80033b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800341:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800344:	89 d0                	mov    %edx,%eax
  800346:	01 c0                	add    %eax,%eax
  800348:	01 d0                	add    %edx,%eax
  80034a:	c1 e0 03             	shl    $0x3,%eax
  80034d:	01 c8                	add    %ecx,%eax
  80034f:	8a 40 04             	mov    0x4(%eax),%al
  800352:	84 c0                	test   %al,%al
  800354:	75 46                	jne    80039c <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800356:	a1 20 40 80 00       	mov    0x804020,%eax
  80035b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800361:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800364:	89 d0                	mov    %edx,%eax
  800366:	01 c0                	add    %eax,%eax
  800368:	01 d0                	add    %edx,%eax
  80036a:	c1 e0 03             	shl    $0x3,%eax
  80036d:	01 c8                	add    %ecx,%eax
  80036f:	8b 00                	mov    (%eax),%eax
  800371:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800374:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800377:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80037c:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80037e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800381:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 c8                	add    %ecx,%eax
  80038d:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80038f:	39 c2                	cmp    %eax,%edx
  800391:	75 09                	jne    80039c <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800393:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80039a:	eb 12                	jmp    8003ae <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80039c:	ff 45 e8             	incl   -0x18(%ebp)
  80039f:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a4:	8b 50 74             	mov    0x74(%eax),%edx
  8003a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003aa:	39 c2                	cmp    %eax,%edx
  8003ac:	77 88                	ja     800336 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003ae:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003b2:	75 14                	jne    8003c8 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003b4:	83 ec 04             	sub    $0x4,%esp
  8003b7:	68 d4 34 80 00       	push   $0x8034d4
  8003bc:	6a 3a                	push   $0x3a
  8003be:	68 c8 34 80 00       	push   $0x8034c8
  8003c3:	e8 93 fe ff ff       	call   80025b <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003c8:	ff 45 f0             	incl   -0x10(%ebp)
  8003cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003ce:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003d1:	0f 8c 32 ff ff ff    	jl     800309 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003d7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003de:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003e5:	eb 26                	jmp    80040d <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ec:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8003f2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8003f5:	89 d0                	mov    %edx,%eax
  8003f7:	01 c0                	add    %eax,%eax
  8003f9:	01 d0                	add    %edx,%eax
  8003fb:	c1 e0 03             	shl    $0x3,%eax
  8003fe:	01 c8                	add    %ecx,%eax
  800400:	8a 40 04             	mov    0x4(%eax),%al
  800403:	3c 01                	cmp    $0x1,%al
  800405:	75 03                	jne    80040a <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800407:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80040a:	ff 45 e0             	incl   -0x20(%ebp)
  80040d:	a1 20 40 80 00       	mov    0x804020,%eax
  800412:	8b 50 74             	mov    0x74(%eax),%edx
  800415:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800418:	39 c2                	cmp    %eax,%edx
  80041a:	77 cb                	ja     8003e7 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80041c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80041f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800422:	74 14                	je     800438 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 28 35 80 00       	push   $0x803528
  80042c:	6a 44                	push   $0x44
  80042e:	68 c8 34 80 00       	push   $0x8034c8
  800433:	e8 23 fe ff ff       	call   80025b <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800438:	90                   	nop
  800439:	c9                   	leave  
  80043a:	c3                   	ret    

0080043b <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80043b:	55                   	push   %ebp
  80043c:	89 e5                	mov    %esp,%ebp
  80043e:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800441:	8b 45 0c             	mov    0xc(%ebp),%eax
  800444:	8b 00                	mov    (%eax),%eax
  800446:	8d 48 01             	lea    0x1(%eax),%ecx
  800449:	8b 55 0c             	mov    0xc(%ebp),%edx
  80044c:	89 0a                	mov    %ecx,(%edx)
  80044e:	8b 55 08             	mov    0x8(%ebp),%edx
  800451:	88 d1                	mov    %dl,%cl
  800453:	8b 55 0c             	mov    0xc(%ebp),%edx
  800456:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80045a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045d:	8b 00                	mov    (%eax),%eax
  80045f:	3d ff 00 00 00       	cmp    $0xff,%eax
  800464:	75 2c                	jne    800492 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800466:	a0 24 40 80 00       	mov    0x804024,%al
  80046b:	0f b6 c0             	movzbl %al,%eax
  80046e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800471:	8b 12                	mov    (%edx),%edx
  800473:	89 d1                	mov    %edx,%ecx
  800475:	8b 55 0c             	mov    0xc(%ebp),%edx
  800478:	83 c2 08             	add    $0x8,%edx
  80047b:	83 ec 04             	sub    $0x4,%esp
  80047e:	50                   	push   %eax
  80047f:	51                   	push   %ecx
  800480:	52                   	push   %edx
  800481:	e8 05 14 00 00       	call   80188b <sys_cputs>
  800486:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800489:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800492:	8b 45 0c             	mov    0xc(%ebp),%eax
  800495:	8b 40 04             	mov    0x4(%eax),%eax
  800498:	8d 50 01             	lea    0x1(%eax),%edx
  80049b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049e:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004a1:	90                   	nop
  8004a2:	c9                   	leave  
  8004a3:	c3                   	ret    

008004a4 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004a4:	55                   	push   %ebp
  8004a5:	89 e5                	mov    %esp,%ebp
  8004a7:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004ad:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004b4:	00 00 00 
	b.cnt = 0;
  8004b7:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004be:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004c1:	ff 75 0c             	pushl  0xc(%ebp)
  8004c4:	ff 75 08             	pushl  0x8(%ebp)
  8004c7:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004cd:	50                   	push   %eax
  8004ce:	68 3b 04 80 00       	push   $0x80043b
  8004d3:	e8 11 02 00 00       	call   8006e9 <vprintfmt>
  8004d8:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004db:	a0 24 40 80 00       	mov    0x804024,%al
  8004e0:	0f b6 c0             	movzbl %al,%eax
  8004e3:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	50                   	push   %eax
  8004ed:	52                   	push   %edx
  8004ee:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004f4:	83 c0 08             	add    $0x8,%eax
  8004f7:	50                   	push   %eax
  8004f8:	e8 8e 13 00 00       	call   80188b <sys_cputs>
  8004fd:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800500:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800507:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80050d:	c9                   	leave  
  80050e:	c3                   	ret    

0080050f <cprintf>:

int cprintf(const char *fmt, ...) {
  80050f:	55                   	push   %ebp
  800510:	89 e5                	mov    %esp,%ebp
  800512:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800515:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80051c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80051f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	83 ec 08             	sub    $0x8,%esp
  800528:	ff 75 f4             	pushl  -0xc(%ebp)
  80052b:	50                   	push   %eax
  80052c:	e8 73 ff ff ff       	call   8004a4 <vcprintf>
  800531:	83 c4 10             	add    $0x10,%esp
  800534:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800537:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80053a:	c9                   	leave  
  80053b:	c3                   	ret    

0080053c <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80053c:	55                   	push   %ebp
  80053d:	89 e5                	mov    %esp,%ebp
  80053f:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800542:	e8 f2 14 00 00       	call   801a39 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800547:	8d 45 0c             	lea    0xc(%ebp),%eax
  80054a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80054d:	8b 45 08             	mov    0x8(%ebp),%eax
  800550:	83 ec 08             	sub    $0x8,%esp
  800553:	ff 75 f4             	pushl  -0xc(%ebp)
  800556:	50                   	push   %eax
  800557:	e8 48 ff ff ff       	call   8004a4 <vcprintf>
  80055c:	83 c4 10             	add    $0x10,%esp
  80055f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800562:	e8 ec 14 00 00       	call   801a53 <sys_enable_interrupt>
	return cnt;
  800567:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80056a:	c9                   	leave  
  80056b:	c3                   	ret    

0080056c <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80056c:	55                   	push   %ebp
  80056d:	89 e5                	mov    %esp,%ebp
  80056f:	53                   	push   %ebx
  800570:	83 ec 14             	sub    $0x14,%esp
  800573:	8b 45 10             	mov    0x10(%ebp),%eax
  800576:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800579:	8b 45 14             	mov    0x14(%ebp),%eax
  80057c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80057f:	8b 45 18             	mov    0x18(%ebp),%eax
  800582:	ba 00 00 00 00       	mov    $0x0,%edx
  800587:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058a:	77 55                	ja     8005e1 <printnum+0x75>
  80058c:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80058f:	72 05                	jb     800596 <printnum+0x2a>
  800591:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800594:	77 4b                	ja     8005e1 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800596:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800599:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80059c:	8b 45 18             	mov    0x18(%ebp),%eax
  80059f:	ba 00 00 00 00       	mov    $0x0,%edx
  8005a4:	52                   	push   %edx
  8005a5:	50                   	push   %eax
  8005a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8005a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8005ac:	e8 63 2a 00 00       	call   803014 <__udivdi3>
  8005b1:	83 c4 10             	add    $0x10,%esp
  8005b4:	83 ec 04             	sub    $0x4,%esp
  8005b7:	ff 75 20             	pushl  0x20(%ebp)
  8005ba:	53                   	push   %ebx
  8005bb:	ff 75 18             	pushl  0x18(%ebp)
  8005be:	52                   	push   %edx
  8005bf:	50                   	push   %eax
  8005c0:	ff 75 0c             	pushl  0xc(%ebp)
  8005c3:	ff 75 08             	pushl  0x8(%ebp)
  8005c6:	e8 a1 ff ff ff       	call   80056c <printnum>
  8005cb:	83 c4 20             	add    $0x20,%esp
  8005ce:	eb 1a                	jmp    8005ea <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005d0:	83 ec 08             	sub    $0x8,%esp
  8005d3:	ff 75 0c             	pushl  0xc(%ebp)
  8005d6:	ff 75 20             	pushl  0x20(%ebp)
  8005d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dc:	ff d0                	call   *%eax
  8005de:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005e1:	ff 4d 1c             	decl   0x1c(%ebp)
  8005e4:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005e8:	7f e6                	jg     8005d0 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8005ea:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8005ed:	bb 00 00 00 00       	mov    $0x0,%ebx
  8005f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005f5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f8:	53                   	push   %ebx
  8005f9:	51                   	push   %ecx
  8005fa:	52                   	push   %edx
  8005fb:	50                   	push   %eax
  8005fc:	e8 23 2b 00 00       	call   803124 <__umoddi3>
  800601:	83 c4 10             	add    $0x10,%esp
  800604:	05 94 37 80 00       	add    $0x803794,%eax
  800609:	8a 00                	mov    (%eax),%al
  80060b:	0f be c0             	movsbl %al,%eax
  80060e:	83 ec 08             	sub    $0x8,%esp
  800611:	ff 75 0c             	pushl  0xc(%ebp)
  800614:	50                   	push   %eax
  800615:	8b 45 08             	mov    0x8(%ebp),%eax
  800618:	ff d0                	call   *%eax
  80061a:	83 c4 10             	add    $0x10,%esp
}
  80061d:	90                   	nop
  80061e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800621:	c9                   	leave  
  800622:	c3                   	ret    

00800623 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800626:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80062a:	7e 1c                	jle    800648 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80062c:	8b 45 08             	mov    0x8(%ebp),%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	8d 50 08             	lea    0x8(%eax),%edx
  800634:	8b 45 08             	mov    0x8(%ebp),%eax
  800637:	89 10                	mov    %edx,(%eax)
  800639:	8b 45 08             	mov    0x8(%ebp),%eax
  80063c:	8b 00                	mov    (%eax),%eax
  80063e:	83 e8 08             	sub    $0x8,%eax
  800641:	8b 50 04             	mov    0x4(%eax),%edx
  800644:	8b 00                	mov    (%eax),%eax
  800646:	eb 40                	jmp    800688 <getuint+0x65>
	else if (lflag)
  800648:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80064c:	74 1e                	je     80066c <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80064e:	8b 45 08             	mov    0x8(%ebp),%eax
  800651:	8b 00                	mov    (%eax),%eax
  800653:	8d 50 04             	lea    0x4(%eax),%edx
  800656:	8b 45 08             	mov    0x8(%ebp),%eax
  800659:	89 10                	mov    %edx,(%eax)
  80065b:	8b 45 08             	mov    0x8(%ebp),%eax
  80065e:	8b 00                	mov    (%eax),%eax
  800660:	83 e8 04             	sub    $0x4,%eax
  800663:	8b 00                	mov    (%eax),%eax
  800665:	ba 00 00 00 00       	mov    $0x0,%edx
  80066a:	eb 1c                	jmp    800688 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	8b 00                	mov    (%eax),%eax
  800671:	8d 50 04             	lea    0x4(%eax),%edx
  800674:	8b 45 08             	mov    0x8(%ebp),%eax
  800677:	89 10                	mov    %edx,(%eax)
  800679:	8b 45 08             	mov    0x8(%ebp),%eax
  80067c:	8b 00                	mov    (%eax),%eax
  80067e:	83 e8 04             	sub    $0x4,%eax
  800681:	8b 00                	mov    (%eax),%eax
  800683:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800688:	5d                   	pop    %ebp
  800689:	c3                   	ret    

0080068a <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80068a:	55                   	push   %ebp
  80068b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80068d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800691:	7e 1c                	jle    8006af <getint+0x25>
		return va_arg(*ap, long long);
  800693:	8b 45 08             	mov    0x8(%ebp),%eax
  800696:	8b 00                	mov    (%eax),%eax
  800698:	8d 50 08             	lea    0x8(%eax),%edx
  80069b:	8b 45 08             	mov    0x8(%ebp),%eax
  80069e:	89 10                	mov    %edx,(%eax)
  8006a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a3:	8b 00                	mov    (%eax),%eax
  8006a5:	83 e8 08             	sub    $0x8,%eax
  8006a8:	8b 50 04             	mov    0x4(%eax),%edx
  8006ab:	8b 00                	mov    (%eax),%eax
  8006ad:	eb 38                	jmp    8006e7 <getint+0x5d>
	else if (lflag)
  8006af:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006b3:	74 1a                	je     8006cf <getint+0x45>
		return va_arg(*ap, long);
  8006b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b8:	8b 00                	mov    (%eax),%eax
  8006ba:	8d 50 04             	lea    0x4(%eax),%edx
  8006bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c0:	89 10                	mov    %edx,(%eax)
  8006c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c5:	8b 00                	mov    (%eax),%eax
  8006c7:	83 e8 04             	sub    $0x4,%eax
  8006ca:	8b 00                	mov    (%eax),%eax
  8006cc:	99                   	cltd   
  8006cd:	eb 18                	jmp    8006e7 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d2:	8b 00                	mov    (%eax),%eax
  8006d4:	8d 50 04             	lea    0x4(%eax),%edx
  8006d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006da:	89 10                	mov    %edx,(%eax)
  8006dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8006df:	8b 00                	mov    (%eax),%eax
  8006e1:	83 e8 04             	sub    $0x4,%eax
  8006e4:	8b 00                	mov    (%eax),%eax
  8006e6:	99                   	cltd   
}
  8006e7:	5d                   	pop    %ebp
  8006e8:	c3                   	ret    

008006e9 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006e9:	55                   	push   %ebp
  8006ea:	89 e5                	mov    %esp,%ebp
  8006ec:	56                   	push   %esi
  8006ed:	53                   	push   %ebx
  8006ee:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8006f1:	eb 17                	jmp    80070a <vprintfmt+0x21>
			if (ch == '\0')
  8006f3:	85 db                	test   %ebx,%ebx
  8006f5:	0f 84 af 03 00 00    	je     800aaa <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8006fb:	83 ec 08             	sub    $0x8,%esp
  8006fe:	ff 75 0c             	pushl  0xc(%ebp)
  800701:	53                   	push   %ebx
  800702:	8b 45 08             	mov    0x8(%ebp),%eax
  800705:	ff d0                	call   *%eax
  800707:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80070a:	8b 45 10             	mov    0x10(%ebp),%eax
  80070d:	8d 50 01             	lea    0x1(%eax),%edx
  800710:	89 55 10             	mov    %edx,0x10(%ebp)
  800713:	8a 00                	mov    (%eax),%al
  800715:	0f b6 d8             	movzbl %al,%ebx
  800718:	83 fb 25             	cmp    $0x25,%ebx
  80071b:	75 d6                	jne    8006f3 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80071d:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800721:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800728:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80072f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800736:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80073d:	8b 45 10             	mov    0x10(%ebp),%eax
  800740:	8d 50 01             	lea    0x1(%eax),%edx
  800743:	89 55 10             	mov    %edx,0x10(%ebp)
  800746:	8a 00                	mov    (%eax),%al
  800748:	0f b6 d8             	movzbl %al,%ebx
  80074b:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80074e:	83 f8 55             	cmp    $0x55,%eax
  800751:	0f 87 2b 03 00 00    	ja     800a82 <vprintfmt+0x399>
  800757:	8b 04 85 b8 37 80 00 	mov    0x8037b8(,%eax,4),%eax
  80075e:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800760:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800764:	eb d7                	jmp    80073d <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800766:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80076a:	eb d1                	jmp    80073d <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80076c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800773:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800776:	89 d0                	mov    %edx,%eax
  800778:	c1 e0 02             	shl    $0x2,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	01 c0                	add    %eax,%eax
  80077f:	01 d8                	add    %ebx,%eax
  800781:	83 e8 30             	sub    $0x30,%eax
  800784:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800787:	8b 45 10             	mov    0x10(%ebp),%eax
  80078a:	8a 00                	mov    (%eax),%al
  80078c:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80078f:	83 fb 2f             	cmp    $0x2f,%ebx
  800792:	7e 3e                	jle    8007d2 <vprintfmt+0xe9>
  800794:	83 fb 39             	cmp    $0x39,%ebx
  800797:	7f 39                	jg     8007d2 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800799:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80079c:	eb d5                	jmp    800773 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80079e:	8b 45 14             	mov    0x14(%ebp),%eax
  8007a1:	83 c0 04             	add    $0x4,%eax
  8007a4:	89 45 14             	mov    %eax,0x14(%ebp)
  8007a7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007aa:	83 e8 04             	sub    $0x4,%eax
  8007ad:	8b 00                	mov    (%eax),%eax
  8007af:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007b2:	eb 1f                	jmp    8007d3 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007b8:	79 83                	jns    80073d <vprintfmt+0x54>
				width = 0;
  8007ba:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007c1:	e9 77 ff ff ff       	jmp    80073d <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007c6:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007cd:	e9 6b ff ff ff       	jmp    80073d <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007d2:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007d7:	0f 89 60 ff ff ff    	jns    80073d <vprintfmt+0x54>
				width = precision, precision = -1;
  8007dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007e3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8007ea:	e9 4e ff ff ff       	jmp    80073d <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8007ef:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8007f2:	e9 46 ff ff ff       	jmp    80073d <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8007f7:	8b 45 14             	mov    0x14(%ebp),%eax
  8007fa:	83 c0 04             	add    $0x4,%eax
  8007fd:	89 45 14             	mov    %eax,0x14(%ebp)
  800800:	8b 45 14             	mov    0x14(%ebp),%eax
  800803:	83 e8 04             	sub    $0x4,%eax
  800806:	8b 00                	mov    (%eax),%eax
  800808:	83 ec 08             	sub    $0x8,%esp
  80080b:	ff 75 0c             	pushl  0xc(%ebp)
  80080e:	50                   	push   %eax
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	ff d0                	call   *%eax
  800814:	83 c4 10             	add    $0x10,%esp
			break;
  800817:	e9 89 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80081c:	8b 45 14             	mov    0x14(%ebp),%eax
  80081f:	83 c0 04             	add    $0x4,%eax
  800822:	89 45 14             	mov    %eax,0x14(%ebp)
  800825:	8b 45 14             	mov    0x14(%ebp),%eax
  800828:	83 e8 04             	sub    $0x4,%eax
  80082b:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80082d:	85 db                	test   %ebx,%ebx
  80082f:	79 02                	jns    800833 <vprintfmt+0x14a>
				err = -err;
  800831:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800833:	83 fb 64             	cmp    $0x64,%ebx
  800836:	7f 0b                	jg     800843 <vprintfmt+0x15a>
  800838:	8b 34 9d 00 36 80 00 	mov    0x803600(,%ebx,4),%esi
  80083f:	85 f6                	test   %esi,%esi
  800841:	75 19                	jne    80085c <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800843:	53                   	push   %ebx
  800844:	68 a5 37 80 00       	push   $0x8037a5
  800849:	ff 75 0c             	pushl  0xc(%ebp)
  80084c:	ff 75 08             	pushl  0x8(%ebp)
  80084f:	e8 5e 02 00 00       	call   800ab2 <printfmt>
  800854:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800857:	e9 49 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80085c:	56                   	push   %esi
  80085d:	68 ae 37 80 00       	push   $0x8037ae
  800862:	ff 75 0c             	pushl  0xc(%ebp)
  800865:	ff 75 08             	pushl  0x8(%ebp)
  800868:	e8 45 02 00 00       	call   800ab2 <printfmt>
  80086d:	83 c4 10             	add    $0x10,%esp
			break;
  800870:	e9 30 02 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 30                	mov    (%eax),%esi
  800886:	85 f6                	test   %esi,%esi
  800888:	75 05                	jne    80088f <vprintfmt+0x1a6>
				p = "(null)";
  80088a:	be b1 37 80 00       	mov    $0x8037b1,%esi
			if (width > 0 && padc != '-')
  80088f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800893:	7e 6d                	jle    800902 <vprintfmt+0x219>
  800895:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800899:	74 67                	je     800902 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  80089b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089e:	83 ec 08             	sub    $0x8,%esp
  8008a1:	50                   	push   %eax
  8008a2:	56                   	push   %esi
  8008a3:	e8 0c 03 00 00       	call   800bb4 <strnlen>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008ae:	eb 16                	jmp    8008c6 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008b0:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	ff 75 0c             	pushl  0xc(%ebp)
  8008ba:	50                   	push   %eax
  8008bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008be:	ff d0                	call   *%eax
  8008c0:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008c3:	ff 4d e4             	decl   -0x1c(%ebp)
  8008c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ca:	7f e4                	jg     8008b0 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008cc:	eb 34                	jmp    800902 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008ce:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008d2:	74 1c                	je     8008f0 <vprintfmt+0x207>
  8008d4:	83 fb 1f             	cmp    $0x1f,%ebx
  8008d7:	7e 05                	jle    8008de <vprintfmt+0x1f5>
  8008d9:	83 fb 7e             	cmp    $0x7e,%ebx
  8008dc:	7e 12                	jle    8008f0 <vprintfmt+0x207>
					putch('?', putdat);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	6a 3f                	push   $0x3f
  8008e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e9:	ff d0                	call   *%eax
  8008eb:	83 c4 10             	add    $0x10,%esp
  8008ee:	eb 0f                	jmp    8008ff <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8008f0:	83 ec 08             	sub    $0x8,%esp
  8008f3:	ff 75 0c             	pushl  0xc(%ebp)
  8008f6:	53                   	push   %ebx
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008ff:	ff 4d e4             	decl   -0x1c(%ebp)
  800902:	89 f0                	mov    %esi,%eax
  800904:	8d 70 01             	lea    0x1(%eax),%esi
  800907:	8a 00                	mov    (%eax),%al
  800909:	0f be d8             	movsbl %al,%ebx
  80090c:	85 db                	test   %ebx,%ebx
  80090e:	74 24                	je     800934 <vprintfmt+0x24b>
  800910:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800914:	78 b8                	js     8008ce <vprintfmt+0x1e5>
  800916:	ff 4d e0             	decl   -0x20(%ebp)
  800919:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80091d:	79 af                	jns    8008ce <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80091f:	eb 13                	jmp    800934 <vprintfmt+0x24b>
				putch(' ', putdat);
  800921:	83 ec 08             	sub    $0x8,%esp
  800924:	ff 75 0c             	pushl  0xc(%ebp)
  800927:	6a 20                	push   $0x20
  800929:	8b 45 08             	mov    0x8(%ebp),%eax
  80092c:	ff d0                	call   *%eax
  80092e:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800931:	ff 4d e4             	decl   -0x1c(%ebp)
  800934:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800938:	7f e7                	jg     800921 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  80093a:	e9 66 01 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80093f:	83 ec 08             	sub    $0x8,%esp
  800942:	ff 75 e8             	pushl  -0x18(%ebp)
  800945:	8d 45 14             	lea    0x14(%ebp),%eax
  800948:	50                   	push   %eax
  800949:	e8 3c fd ff ff       	call   80068a <getint>
  80094e:	83 c4 10             	add    $0x10,%esp
  800951:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800954:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800957:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80095a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80095d:	85 d2                	test   %edx,%edx
  80095f:	79 23                	jns    800984 <vprintfmt+0x29b>
				putch('-', putdat);
  800961:	83 ec 08             	sub    $0x8,%esp
  800964:	ff 75 0c             	pushl  0xc(%ebp)
  800967:	6a 2d                	push   $0x2d
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	ff d0                	call   *%eax
  80096e:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800971:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800974:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800977:	f7 d8                	neg    %eax
  800979:	83 d2 00             	adc    $0x0,%edx
  80097c:	f7 da                	neg    %edx
  80097e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800981:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800984:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80098b:	e9 bc 00 00 00       	jmp    800a4c <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800990:	83 ec 08             	sub    $0x8,%esp
  800993:	ff 75 e8             	pushl  -0x18(%ebp)
  800996:	8d 45 14             	lea    0x14(%ebp),%eax
  800999:	50                   	push   %eax
  80099a:	e8 84 fc ff ff       	call   800623 <getuint>
  80099f:	83 c4 10             	add    $0x10,%esp
  8009a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009a8:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009af:	e9 98 00 00 00       	jmp    800a4c <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009b4:	83 ec 08             	sub    $0x8,%esp
  8009b7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ba:	6a 58                	push   $0x58
  8009bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009bf:	ff d0                	call   *%eax
  8009c1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009c4:	83 ec 08             	sub    $0x8,%esp
  8009c7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ca:	6a 58                	push   $0x58
  8009cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cf:	ff d0                	call   *%eax
  8009d1:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009d4:	83 ec 08             	sub    $0x8,%esp
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	6a 58                	push   $0x58
  8009dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8009df:	ff d0                	call   *%eax
  8009e1:	83 c4 10             	add    $0x10,%esp
			break;
  8009e4:	e9 bc 00 00 00       	jmp    800aa5 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	6a 30                	push   $0x30
  8009f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f4:	ff d0                	call   *%eax
  8009f6:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  8009f9:	83 ec 08             	sub    $0x8,%esp
  8009fc:	ff 75 0c             	pushl  0xc(%ebp)
  8009ff:	6a 78                	push   $0x78
  800a01:	8b 45 08             	mov    0x8(%ebp),%eax
  800a04:	ff d0                	call   *%eax
  800a06:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a09:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0c:	83 c0 04             	add    $0x4,%eax
  800a0f:	89 45 14             	mov    %eax,0x14(%ebp)
  800a12:	8b 45 14             	mov    0x14(%ebp),%eax
  800a15:	83 e8 04             	sub    $0x4,%eax
  800a18:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a24:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a2b:	eb 1f                	jmp    800a4c <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a2d:	83 ec 08             	sub    $0x8,%esp
  800a30:	ff 75 e8             	pushl  -0x18(%ebp)
  800a33:	8d 45 14             	lea    0x14(%ebp),%eax
  800a36:	50                   	push   %eax
  800a37:	e8 e7 fb ff ff       	call   800623 <getuint>
  800a3c:	83 c4 10             	add    $0x10,%esp
  800a3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a42:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a45:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a4c:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a50:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a53:	83 ec 04             	sub    $0x4,%esp
  800a56:	52                   	push   %edx
  800a57:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a5a:	50                   	push   %eax
  800a5b:	ff 75 f4             	pushl  -0xc(%ebp)
  800a5e:	ff 75 f0             	pushl  -0x10(%ebp)
  800a61:	ff 75 0c             	pushl  0xc(%ebp)
  800a64:	ff 75 08             	pushl  0x8(%ebp)
  800a67:	e8 00 fb ff ff       	call   80056c <printnum>
  800a6c:	83 c4 20             	add    $0x20,%esp
			break;
  800a6f:	eb 34                	jmp    800aa5 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a71:	83 ec 08             	sub    $0x8,%esp
  800a74:	ff 75 0c             	pushl  0xc(%ebp)
  800a77:	53                   	push   %ebx
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	ff d0                	call   *%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
			break;
  800a80:	eb 23                	jmp    800aa5 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a82:	83 ec 08             	sub    $0x8,%esp
  800a85:	ff 75 0c             	pushl  0xc(%ebp)
  800a88:	6a 25                	push   $0x25
  800a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8d:	ff d0                	call   *%eax
  800a8f:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800a92:	ff 4d 10             	decl   0x10(%ebp)
  800a95:	eb 03                	jmp    800a9a <vprintfmt+0x3b1>
  800a97:	ff 4d 10             	decl   0x10(%ebp)
  800a9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9d:	48                   	dec    %eax
  800a9e:	8a 00                	mov    (%eax),%al
  800aa0:	3c 25                	cmp    $0x25,%al
  800aa2:	75 f3                	jne    800a97 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aa4:	90                   	nop
		}
	}
  800aa5:	e9 47 fc ff ff       	jmp    8006f1 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800aaa:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800aab:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800aae:	5b                   	pop    %ebx
  800aaf:	5e                   	pop    %esi
  800ab0:	5d                   	pop    %ebp
  800ab1:	c3                   	ret    

00800ab2 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ab2:	55                   	push   %ebp
  800ab3:	89 e5                	mov    %esp,%ebp
  800ab5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ab8:	8d 45 10             	lea    0x10(%ebp),%eax
  800abb:	83 c0 04             	add    $0x4,%eax
  800abe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ac1:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac4:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac7:	50                   	push   %eax
  800ac8:	ff 75 0c             	pushl  0xc(%ebp)
  800acb:	ff 75 08             	pushl  0x8(%ebp)
  800ace:	e8 16 fc ff ff       	call   8006e9 <vprintfmt>
  800ad3:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ad6:	90                   	nop
  800ad7:	c9                   	leave  
  800ad8:	c3                   	ret    

00800ad9 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ad9:	55                   	push   %ebp
  800ada:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800adc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800adf:	8b 40 08             	mov    0x8(%eax),%eax
  800ae2:	8d 50 01             	lea    0x1(%eax),%edx
  800ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae8:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800aeb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aee:	8b 10                	mov    (%eax),%edx
  800af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af3:	8b 40 04             	mov    0x4(%eax),%eax
  800af6:	39 c2                	cmp    %eax,%edx
  800af8:	73 12                	jae    800b0c <sprintputch+0x33>
		*b->buf++ = ch;
  800afa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afd:	8b 00                	mov    (%eax),%eax
  800aff:	8d 48 01             	lea    0x1(%eax),%ecx
  800b02:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b05:	89 0a                	mov    %ecx,(%edx)
  800b07:	8b 55 08             	mov    0x8(%ebp),%edx
  800b0a:	88 10                	mov    %dl,(%eax)
}
  800b0c:	90                   	nop
  800b0d:	5d                   	pop    %ebp
  800b0e:	c3                   	ret    

00800b0f <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b0f:	55                   	push   %ebp
  800b10:	89 e5                	mov    %esp,%ebp
  800b12:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b1b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	01 d0                	add    %edx,%eax
  800b26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b29:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b34:	74 06                	je     800b3c <vsnprintf+0x2d>
  800b36:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b3a:	7f 07                	jg     800b43 <vsnprintf+0x34>
		return -E_INVAL;
  800b3c:	b8 03 00 00 00       	mov    $0x3,%eax
  800b41:	eb 20                	jmp    800b63 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b43:	ff 75 14             	pushl  0x14(%ebp)
  800b46:	ff 75 10             	pushl  0x10(%ebp)
  800b49:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b4c:	50                   	push   %eax
  800b4d:	68 d9 0a 80 00       	push   $0x800ad9
  800b52:	e8 92 fb ff ff       	call   8006e9 <vprintfmt>
  800b57:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b5d:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b60:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b63:	c9                   	leave  
  800b64:	c3                   	ret    

00800b65 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b65:	55                   	push   %ebp
  800b66:	89 e5                	mov    %esp,%ebp
  800b68:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b6b:	8d 45 10             	lea    0x10(%ebp),%eax
  800b6e:	83 c0 04             	add    $0x4,%eax
  800b71:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	ff 75 f4             	pushl  -0xc(%ebp)
  800b7a:	50                   	push   %eax
  800b7b:	ff 75 0c             	pushl  0xc(%ebp)
  800b7e:	ff 75 08             	pushl  0x8(%ebp)
  800b81:	e8 89 ff ff ff       	call   800b0f <vsnprintf>
  800b86:	83 c4 10             	add    $0x10,%esp
  800b89:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800b8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b8f:	c9                   	leave  
  800b90:	c3                   	ret    

00800b91 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800b97:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b9e:	eb 06                	jmp    800ba6 <strlen+0x15>
		n++;
  800ba0:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ba3:	ff 45 08             	incl   0x8(%ebp)
  800ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba9:	8a 00                	mov    (%eax),%al
  800bab:	84 c0                	test   %al,%al
  800bad:	75 f1                	jne    800ba0 <strlen+0xf>
		n++;
	return n;
  800baf:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bb2:	c9                   	leave  
  800bb3:	c3                   	ret    

00800bb4 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bc1:	eb 09                	jmp    800bcc <strnlen+0x18>
		n++;
  800bc3:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bc6:	ff 45 08             	incl   0x8(%ebp)
  800bc9:	ff 4d 0c             	decl   0xc(%ebp)
  800bcc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800bd0:	74 09                	je     800bdb <strnlen+0x27>
  800bd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd5:	8a 00                	mov    (%eax),%al
  800bd7:	84 c0                	test   %al,%al
  800bd9:	75 e8                	jne    800bc3 <strnlen+0xf>
		n++;
	return n;
  800bdb:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bde:	c9                   	leave  
  800bdf:	c3                   	ret    

00800be0 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800be0:	55                   	push   %ebp
  800be1:	89 e5                	mov    %esp,%ebp
  800be3:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
  800be9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800bec:	90                   	nop
  800bed:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf0:	8d 50 01             	lea    0x1(%eax),%edx
  800bf3:	89 55 08             	mov    %edx,0x8(%ebp)
  800bf6:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bf9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bfc:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bff:	8a 12                	mov    (%edx),%dl
  800c01:	88 10                	mov    %dl,(%eax)
  800c03:	8a 00                	mov    (%eax),%al
  800c05:	84 c0                	test   %al,%al
  800c07:	75 e4                	jne    800bed <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c09:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
  800c11:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c21:	eb 1f                	jmp    800c42 <strncpy+0x34>
		*dst++ = *src;
  800c23:	8b 45 08             	mov    0x8(%ebp),%eax
  800c26:	8d 50 01             	lea    0x1(%eax),%edx
  800c29:	89 55 08             	mov    %edx,0x8(%ebp)
  800c2c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c2f:	8a 12                	mov    (%edx),%dl
  800c31:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c36:	8a 00                	mov    (%eax),%al
  800c38:	84 c0                	test   %al,%al
  800c3a:	74 03                	je     800c3f <strncpy+0x31>
			src++;
  800c3c:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c3f:	ff 45 fc             	incl   -0x4(%ebp)
  800c42:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c45:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c48:	72 d9                	jb     800c23 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c4a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c4d:	c9                   	leave  
  800c4e:	c3                   	ret    

00800c4f <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c4f:	55                   	push   %ebp
  800c50:	89 e5                	mov    %esp,%ebp
  800c52:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c55:	8b 45 08             	mov    0x8(%ebp),%eax
  800c58:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c5b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c5f:	74 30                	je     800c91 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c61:	eb 16                	jmp    800c79 <strlcpy+0x2a>
			*dst++ = *src++;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	8d 50 01             	lea    0x1(%eax),%edx
  800c69:	89 55 08             	mov    %edx,0x8(%ebp)
  800c6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c72:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c75:	8a 12                	mov    (%edx),%dl
  800c77:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c79:	ff 4d 10             	decl   0x10(%ebp)
  800c7c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c80:	74 09                	je     800c8b <strlcpy+0x3c>
  800c82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c85:	8a 00                	mov    (%eax),%al
  800c87:	84 c0                	test   %al,%al
  800c89:	75 d8                	jne    800c63 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800c8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c8e:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800c91:	8b 55 08             	mov    0x8(%ebp),%edx
  800c94:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c97:	29 c2                	sub    %eax,%edx
  800c99:	89 d0                	mov    %edx,%eax
}
  800c9b:	c9                   	leave  
  800c9c:	c3                   	ret    

00800c9d <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ca0:	eb 06                	jmp    800ca8 <strcmp+0xb>
		p++, q++;
  800ca2:	ff 45 08             	incl   0x8(%ebp)
  800ca5:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8a 00                	mov    (%eax),%al
  800cad:	84 c0                	test   %al,%al
  800caf:	74 0e                	je     800cbf <strcmp+0x22>
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	8a 10                	mov    (%eax),%dl
  800cb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cb9:	8a 00                	mov    (%eax),%al
  800cbb:	38 c2                	cmp    %al,%dl
  800cbd:	74 e3                	je     800ca2 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc2:	8a 00                	mov    (%eax),%al
  800cc4:	0f b6 d0             	movzbl %al,%edx
  800cc7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cca:	8a 00                	mov    (%eax),%al
  800ccc:	0f b6 c0             	movzbl %al,%eax
  800ccf:	29 c2                	sub    %eax,%edx
  800cd1:	89 d0                	mov    %edx,%eax
}
  800cd3:	5d                   	pop    %ebp
  800cd4:	c3                   	ret    

00800cd5 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800cd5:	55                   	push   %ebp
  800cd6:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cd8:	eb 09                	jmp    800ce3 <strncmp+0xe>
		n--, p++, q++;
  800cda:	ff 4d 10             	decl   0x10(%ebp)
  800cdd:	ff 45 08             	incl   0x8(%ebp)
  800ce0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800ce3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ce7:	74 17                	je     800d00 <strncmp+0x2b>
  800ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cec:	8a 00                	mov    (%eax),%al
  800cee:	84 c0                	test   %al,%al
  800cf0:	74 0e                	je     800d00 <strncmp+0x2b>
  800cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf5:	8a 10                	mov    (%eax),%dl
  800cf7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cfa:	8a 00                	mov    (%eax),%al
  800cfc:	38 c2                	cmp    %al,%dl
  800cfe:	74 da                	je     800cda <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d00:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d04:	75 07                	jne    800d0d <strncmp+0x38>
		return 0;
  800d06:	b8 00 00 00 00       	mov    $0x0,%eax
  800d0b:	eb 14                	jmp    800d21 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	0f b6 d0             	movzbl %al,%edx
  800d15:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d18:	8a 00                	mov    (%eax),%al
  800d1a:	0f b6 c0             	movzbl %al,%eax
  800d1d:	29 c2                	sub    %eax,%edx
  800d1f:	89 d0                	mov    %edx,%eax
}
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 04             	sub    $0x4,%esp
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d2f:	eb 12                	jmp    800d43 <strchr+0x20>
		if (*s == c)
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	8a 00                	mov    (%eax),%al
  800d36:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d39:	75 05                	jne    800d40 <strchr+0x1d>
			return (char *) s;
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	eb 11                	jmp    800d51 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d40:	ff 45 08             	incl   0x8(%ebp)
  800d43:	8b 45 08             	mov    0x8(%ebp),%eax
  800d46:	8a 00                	mov    (%eax),%al
  800d48:	84 c0                	test   %al,%al
  800d4a:	75 e5                	jne    800d31 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d4c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d51:	c9                   	leave  
  800d52:	c3                   	ret    

00800d53 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d53:	55                   	push   %ebp
  800d54:	89 e5                	mov    %esp,%ebp
  800d56:	83 ec 04             	sub    $0x4,%esp
  800d59:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5c:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d5f:	eb 0d                	jmp    800d6e <strfind+0x1b>
		if (*s == c)
  800d61:	8b 45 08             	mov    0x8(%ebp),%eax
  800d64:	8a 00                	mov    (%eax),%al
  800d66:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d69:	74 0e                	je     800d79 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d6b:	ff 45 08             	incl   0x8(%ebp)
  800d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d71:	8a 00                	mov    (%eax),%al
  800d73:	84 c0                	test   %al,%al
  800d75:	75 ea                	jne    800d61 <strfind+0xe>
  800d77:	eb 01                	jmp    800d7a <strfind+0x27>
		if (*s == c)
			break;
  800d79:	90                   	nop
	return (char *) s;
  800d7a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d7d:	c9                   	leave  
  800d7e:	c3                   	ret    

00800d7f <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d7f:	55                   	push   %ebp
  800d80:	89 e5                	mov    %esp,%ebp
  800d82:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d85:	8b 45 08             	mov    0x8(%ebp),%eax
  800d88:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800d8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d8e:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800d91:	eb 0e                	jmp    800da1 <memset+0x22>
		*p++ = c;
  800d93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d96:	8d 50 01             	lea    0x1(%eax),%edx
  800d99:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800d9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d9f:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800da1:	ff 4d f8             	decl   -0x8(%ebp)
  800da4:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800da8:	79 e9                	jns    800d93 <memset+0x14>
		*p++ = c;

	return v;
  800daa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dad:	c9                   	leave  
  800dae:	c3                   	ret    

00800daf <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
  800db2:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800db5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dc1:	eb 16                	jmp    800dd9 <memcpy+0x2a>
		*d++ = *s++;
  800dc3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dc6:	8d 50 01             	lea    0x1(%eax),%edx
  800dc9:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800dcc:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800dcf:	8d 4a 01             	lea    0x1(%edx),%ecx
  800dd2:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800dd5:	8a 12                	mov    (%edx),%dl
  800dd7:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800dd9:	8b 45 10             	mov    0x10(%ebp),%eax
  800ddc:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ddf:	89 55 10             	mov    %edx,0x10(%ebp)
  800de2:	85 c0                	test   %eax,%eax
  800de4:	75 dd                	jne    800dc3 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800de9:	c9                   	leave  
  800dea:	c3                   	ret    

00800deb <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800deb:	55                   	push   %ebp
  800dec:	89 e5                	mov    %esp,%ebp
  800dee:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800df1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800df7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800dfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e00:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e03:	73 50                	jae    800e55 <memmove+0x6a>
  800e05:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e08:	8b 45 10             	mov    0x10(%ebp),%eax
  800e0b:	01 d0                	add    %edx,%eax
  800e0d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e10:	76 43                	jbe    800e55 <memmove+0x6a>
		s += n;
  800e12:	8b 45 10             	mov    0x10(%ebp),%eax
  800e15:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e18:	8b 45 10             	mov    0x10(%ebp),%eax
  800e1b:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e1e:	eb 10                	jmp    800e30 <memmove+0x45>
			*--d = *--s;
  800e20:	ff 4d f8             	decl   -0x8(%ebp)
  800e23:	ff 4d fc             	decl   -0x4(%ebp)
  800e26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e29:	8a 10                	mov    (%eax),%dl
  800e2b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e2e:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e30:	8b 45 10             	mov    0x10(%ebp),%eax
  800e33:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e36:	89 55 10             	mov    %edx,0x10(%ebp)
  800e39:	85 c0                	test   %eax,%eax
  800e3b:	75 e3                	jne    800e20 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e3d:	eb 23                	jmp    800e62 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e3f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e42:	8d 50 01             	lea    0x1(%eax),%edx
  800e45:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e48:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e4b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e4e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e51:	8a 12                	mov    (%edx),%dl
  800e53:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e55:	8b 45 10             	mov    0x10(%ebp),%eax
  800e58:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e5b:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5e:	85 c0                	test   %eax,%eax
  800e60:	75 dd                	jne    800e3f <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e65:	c9                   	leave  
  800e66:	c3                   	ret    

00800e67 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e67:	55                   	push   %ebp
  800e68:	89 e5                	mov    %esp,%ebp
  800e6a:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e70:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e76:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e79:	eb 2a                	jmp    800ea5 <memcmp+0x3e>
		if (*s1 != *s2)
  800e7b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e7e:	8a 10                	mov    (%eax),%dl
  800e80:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e83:	8a 00                	mov    (%eax),%al
  800e85:	38 c2                	cmp    %al,%dl
  800e87:	74 16                	je     800e9f <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e89:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e8c:	8a 00                	mov    (%eax),%al
  800e8e:	0f b6 d0             	movzbl %al,%edx
  800e91:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e94:	8a 00                	mov    (%eax),%al
  800e96:	0f b6 c0             	movzbl %al,%eax
  800e99:	29 c2                	sub    %eax,%edx
  800e9b:	89 d0                	mov    %edx,%eax
  800e9d:	eb 18                	jmp    800eb7 <memcmp+0x50>
		s1++, s2++;
  800e9f:	ff 45 fc             	incl   -0x4(%ebp)
  800ea2:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ea5:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eab:	89 55 10             	mov    %edx,0x10(%ebp)
  800eae:	85 c0                	test   %eax,%eax
  800eb0:	75 c9                	jne    800e7b <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800eb7:	c9                   	leave  
  800eb8:	c3                   	ret    

00800eb9 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800eb9:	55                   	push   %ebp
  800eba:	89 e5                	mov    %esp,%ebp
  800ebc:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ebf:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec5:	01 d0                	add    %edx,%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800eca:	eb 15                	jmp    800ee1 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	8a 00                	mov    (%eax),%al
  800ed1:	0f b6 d0             	movzbl %al,%edx
  800ed4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed7:	0f b6 c0             	movzbl %al,%eax
  800eda:	39 c2                	cmp    %eax,%edx
  800edc:	74 0d                	je     800eeb <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ede:	ff 45 08             	incl   0x8(%ebp)
  800ee1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee4:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ee7:	72 e3                	jb     800ecc <memfind+0x13>
  800ee9:	eb 01                	jmp    800eec <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800eeb:	90                   	nop
	return (void *) s;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800ef7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800efe:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f05:	eb 03                	jmp    800f0a <strtol+0x19>
		s++;
  800f07:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0d:	8a 00                	mov    (%eax),%al
  800f0f:	3c 20                	cmp    $0x20,%al
  800f11:	74 f4                	je     800f07 <strtol+0x16>
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	8a 00                	mov    (%eax),%al
  800f18:	3c 09                	cmp    $0x9,%al
  800f1a:	74 eb                	je     800f07 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1f:	8a 00                	mov    (%eax),%al
  800f21:	3c 2b                	cmp    $0x2b,%al
  800f23:	75 05                	jne    800f2a <strtol+0x39>
		s++;
  800f25:	ff 45 08             	incl   0x8(%ebp)
  800f28:	eb 13                	jmp    800f3d <strtol+0x4c>
	else if (*s == '-')
  800f2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2d:	8a 00                	mov    (%eax),%al
  800f2f:	3c 2d                	cmp    $0x2d,%al
  800f31:	75 0a                	jne    800f3d <strtol+0x4c>
		s++, neg = 1;
  800f33:	ff 45 08             	incl   0x8(%ebp)
  800f36:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f41:	74 06                	je     800f49 <strtol+0x58>
  800f43:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f47:	75 20                	jne    800f69 <strtol+0x78>
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	8a 00                	mov    (%eax),%al
  800f4e:	3c 30                	cmp    $0x30,%al
  800f50:	75 17                	jne    800f69 <strtol+0x78>
  800f52:	8b 45 08             	mov    0x8(%ebp),%eax
  800f55:	40                   	inc    %eax
  800f56:	8a 00                	mov    (%eax),%al
  800f58:	3c 78                	cmp    $0x78,%al
  800f5a:	75 0d                	jne    800f69 <strtol+0x78>
		s += 2, base = 16;
  800f5c:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f60:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f67:	eb 28                	jmp    800f91 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f69:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f6d:	75 15                	jne    800f84 <strtol+0x93>
  800f6f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f72:	8a 00                	mov    (%eax),%al
  800f74:	3c 30                	cmp    $0x30,%al
  800f76:	75 0c                	jne    800f84 <strtol+0x93>
		s++, base = 8;
  800f78:	ff 45 08             	incl   0x8(%ebp)
  800f7b:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f82:	eb 0d                	jmp    800f91 <strtol+0xa0>
	else if (base == 0)
  800f84:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f88:	75 07                	jne    800f91 <strtol+0xa0>
		base = 10;
  800f8a:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800f91:	8b 45 08             	mov    0x8(%ebp),%eax
  800f94:	8a 00                	mov    (%eax),%al
  800f96:	3c 2f                	cmp    $0x2f,%al
  800f98:	7e 19                	jle    800fb3 <strtol+0xc2>
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	3c 39                	cmp    $0x39,%al
  800fa1:	7f 10                	jg     800fb3 <strtol+0xc2>
			dig = *s - '0';
  800fa3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa6:	8a 00                	mov    (%eax),%al
  800fa8:	0f be c0             	movsbl %al,%eax
  800fab:	83 e8 30             	sub    $0x30,%eax
  800fae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fb1:	eb 42                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	8a 00                	mov    (%eax),%al
  800fb8:	3c 60                	cmp    $0x60,%al
  800fba:	7e 19                	jle    800fd5 <strtol+0xe4>
  800fbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbf:	8a 00                	mov    (%eax),%al
  800fc1:	3c 7a                	cmp    $0x7a,%al
  800fc3:	7f 10                	jg     800fd5 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc8:	8a 00                	mov    (%eax),%al
  800fca:	0f be c0             	movsbl %al,%eax
  800fcd:	83 e8 57             	sub    $0x57,%eax
  800fd0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fd3:	eb 20                	jmp    800ff5 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 40                	cmp    $0x40,%al
  800fdc:	7e 39                	jle    801017 <strtol+0x126>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 5a                	cmp    $0x5a,%al
  800fe5:	7f 30                	jg     801017 <strtol+0x126>
			dig = *s - 'A' + 10;
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	0f be c0             	movsbl %al,%eax
  800fef:	83 e8 37             	sub    $0x37,%eax
  800ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ff8:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ffb:	7d 19                	jge    801016 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800ffd:	ff 45 08             	incl   0x8(%ebp)
  801000:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801003:	0f af 45 10          	imul   0x10(%ebp),%eax
  801007:	89 c2                	mov    %eax,%edx
  801009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100c:	01 d0                	add    %edx,%eax
  80100e:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801011:	e9 7b ff ff ff       	jmp    800f91 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801016:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801017:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80101b:	74 08                	je     801025 <strtol+0x134>
		*endptr = (char *) s;
  80101d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801020:	8b 55 08             	mov    0x8(%ebp),%edx
  801023:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801025:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801029:	74 07                	je     801032 <strtol+0x141>
  80102b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80102e:	f7 d8                	neg    %eax
  801030:	eb 03                	jmp    801035 <strtol+0x144>
  801032:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801035:	c9                   	leave  
  801036:	c3                   	ret    

00801037 <ltostr>:

void
ltostr(long value, char *str)
{
  801037:	55                   	push   %ebp
  801038:	89 e5                	mov    %esp,%ebp
  80103a:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80103d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801044:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80104b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80104f:	79 13                	jns    801064 <ltostr+0x2d>
	{
		neg = 1;
  801051:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801058:	8b 45 0c             	mov    0xc(%ebp),%eax
  80105b:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80105e:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801061:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801064:	8b 45 08             	mov    0x8(%ebp),%eax
  801067:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80106c:	99                   	cltd   
  80106d:	f7 f9                	idiv   %ecx
  80106f:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801072:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801075:	8d 50 01             	lea    0x1(%eax),%edx
  801078:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80107b:	89 c2                	mov    %eax,%edx
  80107d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801080:	01 d0                	add    %edx,%eax
  801082:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801085:	83 c2 30             	add    $0x30,%edx
  801088:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80108a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80108d:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801092:	f7 e9                	imul   %ecx
  801094:	c1 fa 02             	sar    $0x2,%edx
  801097:	89 c8                	mov    %ecx,%eax
  801099:	c1 f8 1f             	sar    $0x1f,%eax
  80109c:	29 c2                	sub    %eax,%edx
  80109e:	89 d0                	mov    %edx,%eax
  8010a0:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010a3:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a6:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010ab:	f7 e9                	imul   %ecx
  8010ad:	c1 fa 02             	sar    $0x2,%edx
  8010b0:	89 c8                	mov    %ecx,%eax
  8010b2:	c1 f8 1f             	sar    $0x1f,%eax
  8010b5:	29 c2                	sub    %eax,%edx
  8010b7:	89 d0                	mov    %edx,%eax
  8010b9:	c1 e0 02             	shl    $0x2,%eax
  8010bc:	01 d0                	add    %edx,%eax
  8010be:	01 c0                	add    %eax,%eax
  8010c0:	29 c1                	sub    %eax,%ecx
  8010c2:	89 ca                	mov    %ecx,%edx
  8010c4:	85 d2                	test   %edx,%edx
  8010c6:	75 9c                	jne    801064 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010c8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010cf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010d2:	48                   	dec    %eax
  8010d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010d6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010da:	74 3d                	je     801119 <ltostr+0xe2>
		start = 1 ;
  8010dc:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010e3:	eb 34                	jmp    801119 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010e5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	01 d0                	add    %edx,%eax
  8010ed:	8a 00                	mov    (%eax),%al
  8010ef:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8010f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f8:	01 c2                	add    %eax,%edx
  8010fa:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8010fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801100:	01 c8                	add    %ecx,%eax
  801102:	8a 00                	mov    (%eax),%al
  801104:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801106:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801109:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110c:	01 c2                	add    %eax,%edx
  80110e:	8a 45 eb             	mov    -0x15(%ebp),%al
  801111:	88 02                	mov    %al,(%edx)
		start++ ;
  801113:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801116:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80111f:	7c c4                	jl     8010e5 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801121:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801124:	8b 45 0c             	mov    0xc(%ebp),%eax
  801127:	01 d0                	add    %edx,%eax
  801129:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80112c:	90                   	nop
  80112d:	c9                   	leave  
  80112e:	c3                   	ret    

0080112f <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80112f:	55                   	push   %ebp
  801130:	89 e5                	mov    %esp,%ebp
  801132:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801135:	ff 75 08             	pushl  0x8(%ebp)
  801138:	e8 54 fa ff ff       	call   800b91 <strlen>
  80113d:	83 c4 04             	add    $0x4,%esp
  801140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	e8 46 fa ff ff       	call   800b91 <strlen>
  80114b:	83 c4 04             	add    $0x4,%esp
  80114e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801151:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801158:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80115f:	eb 17                	jmp    801178 <strcconcat+0x49>
		final[s] = str1[s] ;
  801161:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801164:	8b 45 10             	mov    0x10(%ebp),%eax
  801167:	01 c2                	add    %eax,%edx
  801169:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	01 c8                	add    %ecx,%eax
  801171:	8a 00                	mov    (%eax),%al
  801173:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801175:	ff 45 fc             	incl   -0x4(%ebp)
  801178:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80117b:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80117e:	7c e1                	jl     801161 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801180:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801187:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80118e:	eb 1f                	jmp    8011af <strcconcat+0x80>
		final[s++] = str2[i] ;
  801190:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801193:	8d 50 01             	lea    0x1(%eax),%edx
  801196:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801199:	89 c2                	mov    %eax,%edx
  80119b:	8b 45 10             	mov    0x10(%ebp),%eax
  80119e:	01 c2                	add    %eax,%edx
  8011a0:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a6:	01 c8                	add    %ecx,%eax
  8011a8:	8a 00                	mov    (%eax),%al
  8011aa:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011ac:	ff 45 f8             	incl   -0x8(%ebp)
  8011af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b2:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011b5:	7c d9                	jl     801190 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011b7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8011bd:	01 d0                	add    %edx,%eax
  8011bf:	c6 00 00             	movb   $0x0,(%eax)
}
  8011c2:	90                   	nop
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8011cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8011d4:	8b 00                	mov    (%eax),%eax
  8011d6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e0:	01 d0                	add    %edx,%eax
  8011e2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011e8:	eb 0c                	jmp    8011f6 <strsplit+0x31>
			*string++ = 0;
  8011ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ed:	8d 50 01             	lea    0x1(%eax),%edx
  8011f0:	89 55 08             	mov    %edx,0x8(%ebp)
  8011f3:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f9:	8a 00                	mov    (%eax),%al
  8011fb:	84 c0                	test   %al,%al
  8011fd:	74 18                	je     801217 <strsplit+0x52>
  8011ff:	8b 45 08             	mov    0x8(%ebp),%eax
  801202:	8a 00                	mov    (%eax),%al
  801204:	0f be c0             	movsbl %al,%eax
  801207:	50                   	push   %eax
  801208:	ff 75 0c             	pushl  0xc(%ebp)
  80120b:	e8 13 fb ff ff       	call   800d23 <strchr>
  801210:	83 c4 08             	add    $0x8,%esp
  801213:	85 c0                	test   %eax,%eax
  801215:	75 d3                	jne    8011ea <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801217:	8b 45 08             	mov    0x8(%ebp),%eax
  80121a:	8a 00                	mov    (%eax),%al
  80121c:	84 c0                	test   %al,%al
  80121e:	74 5a                	je     80127a <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801220:	8b 45 14             	mov    0x14(%ebp),%eax
  801223:	8b 00                	mov    (%eax),%eax
  801225:	83 f8 0f             	cmp    $0xf,%eax
  801228:	75 07                	jne    801231 <strsplit+0x6c>
		{
			return 0;
  80122a:	b8 00 00 00 00       	mov    $0x0,%eax
  80122f:	eb 66                	jmp    801297 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801231:	8b 45 14             	mov    0x14(%ebp),%eax
  801234:	8b 00                	mov    (%eax),%eax
  801236:	8d 48 01             	lea    0x1(%eax),%ecx
  801239:	8b 55 14             	mov    0x14(%ebp),%edx
  80123c:	89 0a                	mov    %ecx,(%edx)
  80123e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801245:	8b 45 10             	mov    0x10(%ebp),%eax
  801248:	01 c2                	add    %eax,%edx
  80124a:	8b 45 08             	mov    0x8(%ebp),%eax
  80124d:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80124f:	eb 03                	jmp    801254 <strsplit+0x8f>
			string++;
  801251:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	84 c0                	test   %al,%al
  80125b:	74 8b                	je     8011e8 <strsplit+0x23>
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	0f be c0             	movsbl %al,%eax
  801265:	50                   	push   %eax
  801266:	ff 75 0c             	pushl  0xc(%ebp)
  801269:	e8 b5 fa ff ff       	call   800d23 <strchr>
  80126e:	83 c4 08             	add    $0x8,%esp
  801271:	85 c0                	test   %eax,%eax
  801273:	74 dc                	je     801251 <strsplit+0x8c>
			string++;
	}
  801275:	e9 6e ff ff ff       	jmp    8011e8 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80127a:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80127b:	8b 45 14             	mov    0x14(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801287:	8b 45 10             	mov    0x10(%ebp),%eax
  80128a:	01 d0                	add    %edx,%eax
  80128c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801292:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801297:	c9                   	leave  
  801298:	c3                   	ret    

00801299 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801299:	55                   	push   %ebp
  80129a:	89 e5                	mov    %esp,%ebp
  80129c:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80129f:	a1 04 40 80 00       	mov    0x804004,%eax
  8012a4:	85 c0                	test   %eax,%eax
  8012a6:	74 1f                	je     8012c7 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012a8:	e8 1d 00 00 00       	call   8012ca <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012ad:	83 ec 0c             	sub    $0xc,%esp
  8012b0:	68 10 39 80 00       	push   $0x803910
  8012b5:	e8 55 f2 ff ff       	call   80050f <cprintf>
  8012ba:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012bd:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012c4:	00 00 00 
	}
}
  8012c7:	90                   	nop
  8012c8:	c9                   	leave  
  8012c9:	c3                   	ret    

008012ca <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012ca:	55                   	push   %ebp
  8012cb:	89 e5                	mov    %esp,%ebp
  8012cd:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  8012d0:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012d7:	00 00 00 
  8012da:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8012e1:	00 00 00 
  8012e4:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8012eb:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8012ee:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8012f5:	00 00 00 
  8012f8:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8012ff:	00 00 00 
  801302:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801309:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  80130c:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801313:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801316:	c1 e8 0c             	shr    $0xc,%eax
  801319:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  80131e:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801325:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801328:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80132d:	2d 00 10 00 00       	sub    $0x1000,%eax
  801332:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  801337:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  80133e:	a1 20 41 80 00       	mov    0x804120,%eax
  801343:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801347:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  80134a:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801351:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801354:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801357:	01 d0                	add    %edx,%eax
  801359:	48                   	dec    %eax
  80135a:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80135d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801360:	ba 00 00 00 00       	mov    $0x0,%edx
  801365:	f7 75 e4             	divl   -0x1c(%ebp)
  801368:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80136b:	29 d0                	sub    %edx,%eax
  80136d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801370:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801377:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80137a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80137f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801384:	83 ec 04             	sub    $0x4,%esp
  801387:	6a 07                	push   $0x7
  801389:	ff 75 e8             	pushl  -0x18(%ebp)
  80138c:	50                   	push   %eax
  80138d:	e8 3d 06 00 00       	call   8019cf <sys_allocate_chunk>
  801392:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801395:	a1 20 41 80 00       	mov    0x804120,%eax
  80139a:	83 ec 0c             	sub    $0xc,%esp
  80139d:	50                   	push   %eax
  80139e:	e8 b2 0c 00 00       	call   802055 <initialize_MemBlocksList>
  8013a3:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8013a6:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013ab:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8013ae:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013b2:	0f 84 f3 00 00 00    	je     8014ab <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8013b8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013bc:	75 14                	jne    8013d2 <initialize_dyn_block_system+0x108>
  8013be:	83 ec 04             	sub    $0x4,%esp
  8013c1:	68 35 39 80 00       	push   $0x803935
  8013c6:	6a 36                	push   $0x36
  8013c8:	68 53 39 80 00       	push   $0x803953
  8013cd:	e8 89 ee ff ff       	call   80025b <_panic>
  8013d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013d5:	8b 00                	mov    (%eax),%eax
  8013d7:	85 c0                	test   %eax,%eax
  8013d9:	74 10                	je     8013eb <initialize_dyn_block_system+0x121>
  8013db:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013de:	8b 00                	mov    (%eax),%eax
  8013e0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8013e3:	8b 52 04             	mov    0x4(%edx),%edx
  8013e6:	89 50 04             	mov    %edx,0x4(%eax)
  8013e9:	eb 0b                	jmp    8013f6 <initialize_dyn_block_system+0x12c>
  8013eb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013ee:	8b 40 04             	mov    0x4(%eax),%eax
  8013f1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8013f6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013f9:	8b 40 04             	mov    0x4(%eax),%eax
  8013fc:	85 c0                	test   %eax,%eax
  8013fe:	74 0f                	je     80140f <initialize_dyn_block_system+0x145>
  801400:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801403:	8b 40 04             	mov    0x4(%eax),%eax
  801406:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801409:	8b 12                	mov    (%edx),%edx
  80140b:	89 10                	mov    %edx,(%eax)
  80140d:	eb 0a                	jmp    801419 <initialize_dyn_block_system+0x14f>
  80140f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801412:	8b 00                	mov    (%eax),%eax
  801414:	a3 48 41 80 00       	mov    %eax,0x804148
  801419:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80141c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801422:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801425:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80142c:	a1 54 41 80 00       	mov    0x804154,%eax
  801431:	48                   	dec    %eax
  801432:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801437:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80143a:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801441:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801444:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  80144b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80144f:	75 14                	jne    801465 <initialize_dyn_block_system+0x19b>
  801451:	83 ec 04             	sub    $0x4,%esp
  801454:	68 60 39 80 00       	push   $0x803960
  801459:	6a 3e                	push   $0x3e
  80145b:	68 53 39 80 00       	push   $0x803953
  801460:	e8 f6 ed ff ff       	call   80025b <_panic>
  801465:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80146b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80146e:	89 10                	mov    %edx,(%eax)
  801470:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801473:	8b 00                	mov    (%eax),%eax
  801475:	85 c0                	test   %eax,%eax
  801477:	74 0d                	je     801486 <initialize_dyn_block_system+0x1bc>
  801479:	a1 38 41 80 00       	mov    0x804138,%eax
  80147e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801481:	89 50 04             	mov    %edx,0x4(%eax)
  801484:	eb 08                	jmp    80148e <initialize_dyn_block_system+0x1c4>
  801486:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801489:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80148e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801491:	a3 38 41 80 00       	mov    %eax,0x804138
  801496:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801499:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014a0:	a1 44 41 80 00       	mov    0x804144,%eax
  8014a5:	40                   	inc    %eax
  8014a6:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8014ab:	90                   	nop
  8014ac:	c9                   	leave  
  8014ad:	c3                   	ret    

008014ae <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014ae:	55                   	push   %ebp
  8014af:	89 e5                	mov    %esp,%ebp
  8014b1:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8014b4:	e8 e0 fd ff ff       	call   801299 <InitializeUHeap>
		if (size == 0) return NULL ;
  8014b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014bd:	75 07                	jne    8014c6 <malloc+0x18>
  8014bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c4:	eb 7f                	jmp    801545 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8014c6:	e8 d2 08 00 00       	call   801d9d <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014cb:	85 c0                	test   %eax,%eax
  8014cd:	74 71                	je     801540 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  8014cf:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	48                   	dec    %eax
  8014df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014e5:	ba 00 00 00 00       	mov    $0x0,%edx
  8014ea:	f7 75 f4             	divl   -0xc(%ebp)
  8014ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f0:	29 d0                	sub    %edx,%eax
  8014f2:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  8014f5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  8014fc:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801503:	76 07                	jbe    80150c <malloc+0x5e>
					return NULL ;
  801505:	b8 00 00 00 00       	mov    $0x0,%eax
  80150a:	eb 39                	jmp    801545 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  80150c:	83 ec 0c             	sub    $0xc,%esp
  80150f:	ff 75 08             	pushl  0x8(%ebp)
  801512:	e8 e6 0d 00 00       	call   8022fd <alloc_block_FF>
  801517:	83 c4 10             	add    $0x10,%esp
  80151a:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  80151d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801521:	74 16                	je     801539 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801523:	83 ec 0c             	sub    $0xc,%esp
  801526:	ff 75 ec             	pushl  -0x14(%ebp)
  801529:	e8 37 0c 00 00       	call   802165 <insert_sorted_allocList>
  80152e:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801531:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801534:	8b 40 08             	mov    0x8(%eax),%eax
  801537:	eb 0c                	jmp    801545 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801539:	b8 00 00 00 00       	mov    $0x0,%eax
  80153e:	eb 05                	jmp    801545 <malloc+0x97>
				}
		}
	return 0;
  801540:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801545:	c9                   	leave  
  801546:	c3                   	ret    

00801547 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801547:	55                   	push   %ebp
  801548:	89 e5                	mov    %esp,%ebp
  80154a:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  80154d:	8b 45 08             	mov    0x8(%ebp),%eax
  801550:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801553:	83 ec 08             	sub    $0x8,%esp
  801556:	ff 75 f4             	pushl  -0xc(%ebp)
  801559:	68 40 40 80 00       	push   $0x804040
  80155e:	e8 cf 0b 00 00       	call   802132 <find_block>
  801563:	83 c4 10             	add    $0x10,%esp
  801566:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801569:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80156c:	8b 40 0c             	mov    0xc(%eax),%eax
  80156f:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801572:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801575:	8b 40 08             	mov    0x8(%eax),%eax
  801578:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  80157b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80157f:	0f 84 a1 00 00 00    	je     801626 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801585:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801589:	75 17                	jne    8015a2 <free+0x5b>
  80158b:	83 ec 04             	sub    $0x4,%esp
  80158e:	68 35 39 80 00       	push   $0x803935
  801593:	68 80 00 00 00       	push   $0x80
  801598:	68 53 39 80 00       	push   $0x803953
  80159d:	e8 b9 ec ff ff       	call   80025b <_panic>
  8015a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015a5:	8b 00                	mov    (%eax),%eax
  8015a7:	85 c0                	test   %eax,%eax
  8015a9:	74 10                	je     8015bb <free+0x74>
  8015ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ae:	8b 00                	mov    (%eax),%eax
  8015b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b3:	8b 52 04             	mov    0x4(%edx),%edx
  8015b6:	89 50 04             	mov    %edx,0x4(%eax)
  8015b9:	eb 0b                	jmp    8015c6 <free+0x7f>
  8015bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015be:	8b 40 04             	mov    0x4(%eax),%eax
  8015c1:	a3 44 40 80 00       	mov    %eax,0x804044
  8015c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c9:	8b 40 04             	mov    0x4(%eax),%eax
  8015cc:	85 c0                	test   %eax,%eax
  8015ce:	74 0f                	je     8015df <free+0x98>
  8015d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d3:	8b 40 04             	mov    0x4(%eax),%eax
  8015d6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015d9:	8b 12                	mov    (%edx),%edx
  8015db:	89 10                	mov    %edx,(%eax)
  8015dd:	eb 0a                	jmp    8015e9 <free+0xa2>
  8015df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e2:	8b 00                	mov    (%eax),%eax
  8015e4:	a3 40 40 80 00       	mov    %eax,0x804040
  8015e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ec:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8015f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015fc:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801601:	48                   	dec    %eax
  801602:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  801607:	83 ec 0c             	sub    $0xc,%esp
  80160a:	ff 75 f0             	pushl  -0x10(%ebp)
  80160d:	e8 29 12 00 00       	call   80283b <insert_sorted_with_merge_freeList>
  801612:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801615:	83 ec 08             	sub    $0x8,%esp
  801618:	ff 75 ec             	pushl  -0x14(%ebp)
  80161b:	ff 75 e8             	pushl  -0x18(%ebp)
  80161e:	e8 74 03 00 00       	call   801997 <sys_free_user_mem>
  801623:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801626:	90                   	nop
  801627:	c9                   	leave  
  801628:	c3                   	ret    

00801629 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801629:	55                   	push   %ebp
  80162a:	89 e5                	mov    %esp,%ebp
  80162c:	83 ec 38             	sub    $0x38,%esp
  80162f:	8b 45 10             	mov    0x10(%ebp),%eax
  801632:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801635:	e8 5f fc ff ff       	call   801299 <InitializeUHeap>
	if (size == 0) return NULL ;
  80163a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80163e:	75 0a                	jne    80164a <smalloc+0x21>
  801640:	b8 00 00 00 00       	mov    $0x0,%eax
  801645:	e9 b2 00 00 00       	jmp    8016fc <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  80164a:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801651:	76 0a                	jbe    80165d <smalloc+0x34>
		return NULL;
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
  801658:	e9 9f 00 00 00       	jmp    8016fc <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80165d:	e8 3b 07 00 00       	call   801d9d <sys_isUHeapPlacementStrategyFIRSTFIT>
  801662:	85 c0                	test   %eax,%eax
  801664:	0f 84 8d 00 00 00    	je     8016f7 <smalloc+0xce>
	struct MemBlock *b = NULL;
  80166a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801671:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801678:	8b 55 0c             	mov    0xc(%ebp),%edx
  80167b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167e:	01 d0                	add    %edx,%eax
  801680:	48                   	dec    %eax
  801681:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801684:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801687:	ba 00 00 00 00       	mov    $0x0,%edx
  80168c:	f7 75 f0             	divl   -0x10(%ebp)
  80168f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801692:	29 d0                	sub    %edx,%eax
  801694:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801697:	83 ec 0c             	sub    $0xc,%esp
  80169a:	ff 75 e8             	pushl  -0x18(%ebp)
  80169d:	e8 5b 0c 00 00       	call   8022fd <alloc_block_FF>
  8016a2:	83 c4 10             	add    $0x10,%esp
  8016a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8016a8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016ac:	75 07                	jne    8016b5 <smalloc+0x8c>
			return NULL;
  8016ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8016b3:	eb 47                	jmp    8016fc <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8016b5:	83 ec 0c             	sub    $0xc,%esp
  8016b8:	ff 75 f4             	pushl  -0xc(%ebp)
  8016bb:	e8 a5 0a 00 00       	call   802165 <insert_sorted_allocList>
  8016c0:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8016c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c6:	8b 40 08             	mov    0x8(%eax),%eax
  8016c9:	89 c2                	mov    %eax,%edx
  8016cb:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016cf:	52                   	push   %edx
  8016d0:	50                   	push   %eax
  8016d1:	ff 75 0c             	pushl  0xc(%ebp)
  8016d4:	ff 75 08             	pushl  0x8(%ebp)
  8016d7:	e8 46 04 00 00       	call   801b22 <sys_createSharedObject>
  8016dc:	83 c4 10             	add    $0x10,%esp
  8016df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  8016e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016e6:	78 08                	js     8016f0 <smalloc+0xc7>
		return (void *)b->sva;
  8016e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016eb:	8b 40 08             	mov    0x8(%eax),%eax
  8016ee:	eb 0c                	jmp    8016fc <smalloc+0xd3>
		}else{
		return NULL;
  8016f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f5:	eb 05                	jmp    8016fc <smalloc+0xd3>
			}

	}return NULL;
  8016f7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801704:	e8 90 fb ff ff       	call   801299 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801709:	e8 8f 06 00 00       	call   801d9d <sys_isUHeapPlacementStrategyFIRSTFIT>
  80170e:	85 c0                	test   %eax,%eax
  801710:	0f 84 ad 00 00 00    	je     8017c3 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801716:	83 ec 08             	sub    $0x8,%esp
  801719:	ff 75 0c             	pushl  0xc(%ebp)
  80171c:	ff 75 08             	pushl  0x8(%ebp)
  80171f:	e8 28 04 00 00       	call   801b4c <sys_getSizeOfSharedObject>
  801724:	83 c4 10             	add    $0x10,%esp
  801727:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  80172a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80172e:	79 0a                	jns    80173a <sget+0x3c>
    {
    	return NULL;
  801730:	b8 00 00 00 00       	mov    $0x0,%eax
  801735:	e9 8e 00 00 00       	jmp    8017c8 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  80173a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801741:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801748:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80174b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80174e:	01 d0                	add    %edx,%eax
  801750:	48                   	dec    %eax
  801751:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801754:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801757:	ba 00 00 00 00       	mov    $0x0,%edx
  80175c:	f7 75 ec             	divl   -0x14(%ebp)
  80175f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801762:	29 d0                	sub    %edx,%eax
  801764:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801767:	83 ec 0c             	sub    $0xc,%esp
  80176a:	ff 75 e4             	pushl  -0x1c(%ebp)
  80176d:	e8 8b 0b 00 00       	call   8022fd <alloc_block_FF>
  801772:	83 c4 10             	add    $0x10,%esp
  801775:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801778:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80177c:	75 07                	jne    801785 <sget+0x87>
				return NULL;
  80177e:	b8 00 00 00 00       	mov    $0x0,%eax
  801783:	eb 43                	jmp    8017c8 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801785:	83 ec 0c             	sub    $0xc,%esp
  801788:	ff 75 f0             	pushl  -0x10(%ebp)
  80178b:	e8 d5 09 00 00       	call   802165 <insert_sorted_allocList>
  801790:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801793:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801796:	8b 40 08             	mov    0x8(%eax),%eax
  801799:	83 ec 04             	sub    $0x4,%esp
  80179c:	50                   	push   %eax
  80179d:	ff 75 0c             	pushl  0xc(%ebp)
  8017a0:	ff 75 08             	pushl  0x8(%ebp)
  8017a3:	e8 c1 03 00 00       	call   801b69 <sys_getSharedObject>
  8017a8:	83 c4 10             	add    $0x10,%esp
  8017ab:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8017ae:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017b2:	78 08                	js     8017bc <sget+0xbe>
			return (void *)b->sva;
  8017b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b7:	8b 40 08             	mov    0x8(%eax),%eax
  8017ba:	eb 0c                	jmp    8017c8 <sget+0xca>
			}else{
			return NULL;
  8017bc:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c1:	eb 05                	jmp    8017c8 <sget+0xca>
			}
    }}return NULL;
  8017c3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
  8017cd:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017d0:	e8 c4 fa ff ff       	call   801299 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017d5:	83 ec 04             	sub    $0x4,%esp
  8017d8:	68 84 39 80 00       	push   $0x803984
  8017dd:	68 03 01 00 00       	push   $0x103
  8017e2:	68 53 39 80 00       	push   $0x803953
  8017e7:	e8 6f ea ff ff       	call   80025b <_panic>

008017ec <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8017ec:	55                   	push   %ebp
  8017ed:	89 e5                	mov    %esp,%ebp
  8017ef:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8017f2:	83 ec 04             	sub    $0x4,%esp
  8017f5:	68 ac 39 80 00       	push   $0x8039ac
  8017fa:	68 17 01 00 00       	push   $0x117
  8017ff:	68 53 39 80 00       	push   $0x803953
  801804:	e8 52 ea ff ff       	call   80025b <_panic>

00801809 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801809:	55                   	push   %ebp
  80180a:	89 e5                	mov    %esp,%ebp
  80180c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80180f:	83 ec 04             	sub    $0x4,%esp
  801812:	68 d0 39 80 00       	push   $0x8039d0
  801817:	68 22 01 00 00       	push   $0x122
  80181c:	68 53 39 80 00       	push   $0x803953
  801821:	e8 35 ea ff ff       	call   80025b <_panic>

00801826 <shrink>:

}
void shrink(uint32 newSize)
{
  801826:	55                   	push   %ebp
  801827:	89 e5                	mov    %esp,%ebp
  801829:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80182c:	83 ec 04             	sub    $0x4,%esp
  80182f:	68 d0 39 80 00       	push   $0x8039d0
  801834:	68 27 01 00 00       	push   $0x127
  801839:	68 53 39 80 00       	push   $0x803953
  80183e:	e8 18 ea ff ff       	call   80025b <_panic>

00801843 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801843:	55                   	push   %ebp
  801844:	89 e5                	mov    %esp,%ebp
  801846:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801849:	83 ec 04             	sub    $0x4,%esp
  80184c:	68 d0 39 80 00       	push   $0x8039d0
  801851:	68 2c 01 00 00       	push   $0x12c
  801856:	68 53 39 80 00       	push   $0x803953
  80185b:	e8 fb e9 ff ff       	call   80025b <_panic>

00801860 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801860:	55                   	push   %ebp
  801861:	89 e5                	mov    %esp,%ebp
  801863:	57                   	push   %edi
  801864:	56                   	push   %esi
  801865:	53                   	push   %ebx
  801866:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801872:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801875:	8b 7d 18             	mov    0x18(%ebp),%edi
  801878:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80187b:	cd 30                	int    $0x30
  80187d:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801880:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801883:	83 c4 10             	add    $0x10,%esp
  801886:	5b                   	pop    %ebx
  801887:	5e                   	pop    %esi
  801888:	5f                   	pop    %edi
  801889:	5d                   	pop    %ebp
  80188a:	c3                   	ret    

0080188b <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
  80188e:	83 ec 04             	sub    $0x4,%esp
  801891:	8b 45 10             	mov    0x10(%ebp),%eax
  801894:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801897:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80189b:	8b 45 08             	mov    0x8(%ebp),%eax
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	52                   	push   %edx
  8018a3:	ff 75 0c             	pushl  0xc(%ebp)
  8018a6:	50                   	push   %eax
  8018a7:	6a 00                	push   $0x0
  8018a9:	e8 b2 ff ff ff       	call   801860 <syscall>
  8018ae:	83 c4 18             	add    $0x18,%esp
}
  8018b1:	90                   	nop
  8018b2:	c9                   	leave  
  8018b3:	c3                   	ret    

008018b4 <sys_cgetc>:

int
sys_cgetc(void)
{
  8018b4:	55                   	push   %ebp
  8018b5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 01                	push   $0x1
  8018c3:	e8 98 ff ff ff       	call   801860 <syscall>
  8018c8:	83 c4 18             	add    $0x18,%esp
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018d0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	52                   	push   %edx
  8018dd:	50                   	push   %eax
  8018de:	6a 05                	push   $0x5
  8018e0:	e8 7b ff ff ff       	call   801860 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
}
  8018e8:	c9                   	leave  
  8018e9:	c3                   	ret    

008018ea <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8018ea:	55                   	push   %ebp
  8018eb:	89 e5                	mov    %esp,%ebp
  8018ed:	56                   	push   %esi
  8018ee:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8018ef:	8b 75 18             	mov    0x18(%ebp),%esi
  8018f2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8018f5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8018f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fe:	56                   	push   %esi
  8018ff:	53                   	push   %ebx
  801900:	51                   	push   %ecx
  801901:	52                   	push   %edx
  801902:	50                   	push   %eax
  801903:	6a 06                	push   $0x6
  801905:	e8 56 ff ff ff       	call   801860 <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801910:	5b                   	pop    %ebx
  801911:	5e                   	pop    %esi
  801912:	5d                   	pop    %ebp
  801913:	c3                   	ret    

00801914 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801914:	55                   	push   %ebp
  801915:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801917:	8b 55 0c             	mov    0xc(%ebp),%edx
  80191a:	8b 45 08             	mov    0x8(%ebp),%eax
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	52                   	push   %edx
  801924:	50                   	push   %eax
  801925:	6a 07                	push   $0x7
  801927:	e8 34 ff ff ff       	call   801860 <syscall>
  80192c:	83 c4 18             	add    $0x18,%esp
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	ff 75 0c             	pushl  0xc(%ebp)
  80193d:	ff 75 08             	pushl  0x8(%ebp)
  801940:	6a 08                	push   $0x8
  801942:	e8 19 ff ff ff       	call   801860 <syscall>
  801947:	83 c4 18             	add    $0x18,%esp
}
  80194a:	c9                   	leave  
  80194b:	c3                   	ret    

0080194c <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80194c:	55                   	push   %ebp
  80194d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 09                	push   $0x9
  80195b:	e8 00 ff ff ff       	call   801860 <syscall>
  801960:	83 c4 18             	add    $0x18,%esp
}
  801963:	c9                   	leave  
  801964:	c3                   	ret    

00801965 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801968:	6a 00                	push   $0x0
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 0a                	push   $0xa
  801974:	e8 e7 fe ff ff       	call   801860 <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	c9                   	leave  
  80197d:	c3                   	ret    

0080197e <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80197e:	55                   	push   %ebp
  80197f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801981:	6a 00                	push   $0x0
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 0b                	push   $0xb
  80198d:	e8 ce fe ff ff       	call   801860 <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
}
  801995:	c9                   	leave  
  801996:	c3                   	ret    

00801997 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801997:	55                   	push   %ebp
  801998:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 00                	push   $0x0
  8019a0:	ff 75 0c             	pushl  0xc(%ebp)
  8019a3:	ff 75 08             	pushl  0x8(%ebp)
  8019a6:	6a 0f                	push   $0xf
  8019a8:	e8 b3 fe ff ff       	call   801860 <syscall>
  8019ad:	83 c4 18             	add    $0x18,%esp
	return;
  8019b0:	90                   	nop
}
  8019b1:	c9                   	leave  
  8019b2:	c3                   	ret    

008019b3 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019b3:	55                   	push   %ebp
  8019b4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019b6:	6a 00                	push   $0x0
  8019b8:	6a 00                	push   $0x0
  8019ba:	6a 00                	push   $0x0
  8019bc:	ff 75 0c             	pushl  0xc(%ebp)
  8019bf:	ff 75 08             	pushl  0x8(%ebp)
  8019c2:	6a 10                	push   $0x10
  8019c4:	e8 97 fe ff ff       	call   801860 <syscall>
  8019c9:	83 c4 18             	add    $0x18,%esp
	return ;
  8019cc:	90                   	nop
}
  8019cd:	c9                   	leave  
  8019ce:	c3                   	ret    

008019cf <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019cf:	55                   	push   %ebp
  8019d0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	ff 75 10             	pushl  0x10(%ebp)
  8019d9:	ff 75 0c             	pushl  0xc(%ebp)
  8019dc:	ff 75 08             	pushl  0x8(%ebp)
  8019df:	6a 11                	push   $0x11
  8019e1:	e8 7a fe ff ff       	call   801860 <syscall>
  8019e6:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e9:	90                   	nop
}
  8019ea:	c9                   	leave  
  8019eb:	c3                   	ret    

008019ec <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8019ec:	55                   	push   %ebp
  8019ed:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8019ef:	6a 00                	push   $0x0
  8019f1:	6a 00                	push   $0x0
  8019f3:	6a 00                	push   $0x0
  8019f5:	6a 00                	push   $0x0
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 0c                	push   $0xc
  8019fb:	e8 60 fe ff ff       	call   801860 <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
}
  801a03:	c9                   	leave  
  801a04:	c3                   	ret    

00801a05 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a05:	55                   	push   %ebp
  801a06:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a08:	6a 00                	push   $0x0
  801a0a:	6a 00                	push   $0x0
  801a0c:	6a 00                	push   $0x0
  801a0e:	6a 00                	push   $0x0
  801a10:	ff 75 08             	pushl  0x8(%ebp)
  801a13:	6a 0d                	push   $0xd
  801a15:	e8 46 fe ff ff       	call   801860 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	6a 00                	push   $0x0
  801a28:	6a 00                	push   $0x0
  801a2a:	6a 00                	push   $0x0
  801a2c:	6a 0e                	push   $0xe
  801a2e:	e8 2d fe ff ff       	call   801860 <syscall>
  801a33:	83 c4 18             	add    $0x18,%esp
}
  801a36:	90                   	nop
  801a37:	c9                   	leave  
  801a38:	c3                   	ret    

00801a39 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a39:	55                   	push   %ebp
  801a3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 13                	push   $0x13
  801a48:	e8 13 fe ff ff       	call   801860 <syscall>
  801a4d:	83 c4 18             	add    $0x18,%esp
}
  801a50:	90                   	nop
  801a51:	c9                   	leave  
  801a52:	c3                   	ret    

00801a53 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a53:	55                   	push   %ebp
  801a54:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 14                	push   $0x14
  801a62:	e8 f9 fd ff ff       	call   801860 <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	90                   	nop
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_cputc>:


void
sys_cputc(const char c)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	83 ec 04             	sub    $0x4,%esp
  801a73:	8b 45 08             	mov    0x8(%ebp),%eax
  801a76:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a79:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	50                   	push   %eax
  801a86:	6a 15                	push   $0x15
  801a88:	e8 d3 fd ff ff       	call   801860 <syscall>
  801a8d:	83 c4 18             	add    $0x18,%esp
}
  801a90:	90                   	nop
  801a91:	c9                   	leave  
  801a92:	c3                   	ret    

00801a93 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801a93:	55                   	push   %ebp
  801a94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 16                	push   $0x16
  801aa2:	e8 b9 fd ff ff       	call   801860 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
}
  801aaa:	90                   	nop
  801aab:	c9                   	leave  
  801aac:	c3                   	ret    

00801aad <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801aad:	55                   	push   %ebp
  801aae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ab3:	6a 00                	push   $0x0
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	ff 75 0c             	pushl  0xc(%ebp)
  801abc:	50                   	push   %eax
  801abd:	6a 17                	push   $0x17
  801abf:	e8 9c fd ff ff       	call   801860 <syscall>
  801ac4:	83 c4 18             	add    $0x18,%esp
}
  801ac7:	c9                   	leave  
  801ac8:	c3                   	ret    

00801ac9 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ac9:	55                   	push   %ebp
  801aca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801acc:	8b 55 0c             	mov    0xc(%ebp),%edx
  801acf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	52                   	push   %edx
  801ad9:	50                   	push   %eax
  801ada:	6a 1a                	push   $0x1a
  801adc:	e8 7f fd ff ff       	call   801860 <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
}
  801ae4:	c9                   	leave  
  801ae5:	c3                   	ret    

00801ae6 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801ae6:	55                   	push   %ebp
  801ae7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ae9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801aec:	8b 45 08             	mov    0x8(%ebp),%eax
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	52                   	push   %edx
  801af6:	50                   	push   %eax
  801af7:	6a 18                	push   $0x18
  801af9:	e8 62 fd ff ff       	call   801860 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	90                   	nop
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 00                	push   $0x0
  801b13:	52                   	push   %edx
  801b14:	50                   	push   %eax
  801b15:	6a 19                	push   $0x19
  801b17:	e8 44 fd ff ff       	call   801860 <syscall>
  801b1c:	83 c4 18             	add    $0x18,%esp
}
  801b1f:	90                   	nop
  801b20:	c9                   	leave  
  801b21:	c3                   	ret    

00801b22 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b22:	55                   	push   %ebp
  801b23:	89 e5                	mov    %esp,%ebp
  801b25:	83 ec 04             	sub    $0x4,%esp
  801b28:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2b:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b2e:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b31:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b35:	8b 45 08             	mov    0x8(%ebp),%eax
  801b38:	6a 00                	push   $0x0
  801b3a:	51                   	push   %ecx
  801b3b:	52                   	push   %edx
  801b3c:	ff 75 0c             	pushl  0xc(%ebp)
  801b3f:	50                   	push   %eax
  801b40:	6a 1b                	push   $0x1b
  801b42:	e8 19 fd ff ff       	call   801860 <syscall>
  801b47:	83 c4 18             	add    $0x18,%esp
}
  801b4a:	c9                   	leave  
  801b4b:	c3                   	ret    

00801b4c <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b4c:	55                   	push   %ebp
  801b4d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b4f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b52:	8b 45 08             	mov    0x8(%ebp),%eax
  801b55:	6a 00                	push   $0x0
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	52                   	push   %edx
  801b5c:	50                   	push   %eax
  801b5d:	6a 1c                	push   $0x1c
  801b5f:	e8 fc fc ff ff       	call   801860 <syscall>
  801b64:	83 c4 18             	add    $0x18,%esp
}
  801b67:	c9                   	leave  
  801b68:	c3                   	ret    

00801b69 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b69:	55                   	push   %ebp
  801b6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b6c:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b72:	8b 45 08             	mov    0x8(%ebp),%eax
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	51                   	push   %ecx
  801b7a:	52                   	push   %edx
  801b7b:	50                   	push   %eax
  801b7c:	6a 1d                	push   $0x1d
  801b7e:	e8 dd fc ff ff       	call   801860 <syscall>
  801b83:	83 c4 18             	add    $0x18,%esp
}
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801b8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b8e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	52                   	push   %edx
  801b98:	50                   	push   %eax
  801b99:	6a 1e                	push   $0x1e
  801b9b:	e8 c0 fc ff ff       	call   801860 <syscall>
  801ba0:	83 c4 18             	add    $0x18,%esp
}
  801ba3:	c9                   	leave  
  801ba4:	c3                   	ret    

00801ba5 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ba5:	55                   	push   %ebp
  801ba6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 1f                	push   $0x1f
  801bb4:	e8 a7 fc ff ff       	call   801860 <syscall>
  801bb9:	83 c4 18             	add    $0x18,%esp
}
  801bbc:	c9                   	leave  
  801bbd:	c3                   	ret    

00801bbe <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bbe:	55                   	push   %ebp
  801bbf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc4:	6a 00                	push   $0x0
  801bc6:	ff 75 14             	pushl  0x14(%ebp)
  801bc9:	ff 75 10             	pushl  0x10(%ebp)
  801bcc:	ff 75 0c             	pushl  0xc(%ebp)
  801bcf:	50                   	push   %eax
  801bd0:	6a 20                	push   $0x20
  801bd2:	e8 89 fc ff ff       	call   801860 <syscall>
  801bd7:	83 c4 18             	add    $0x18,%esp
}
  801bda:	c9                   	leave  
  801bdb:	c3                   	ret    

00801bdc <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bdc:	55                   	push   %ebp
  801bdd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bdf:	8b 45 08             	mov    0x8(%ebp),%eax
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 00                	push   $0x0
  801bea:	50                   	push   %eax
  801beb:	6a 21                	push   $0x21
  801bed:	e8 6e fc ff ff       	call   801860 <syscall>
  801bf2:	83 c4 18             	add    $0x18,%esp
}
  801bf5:	90                   	nop
  801bf6:	c9                   	leave  
  801bf7:	c3                   	ret    

00801bf8 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801bf8:	55                   	push   %ebp
  801bf9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	6a 00                	push   $0x0
  801c06:	50                   	push   %eax
  801c07:	6a 22                	push   $0x22
  801c09:	e8 52 fc ff ff       	call   801860 <syscall>
  801c0e:	83 c4 18             	add    $0x18,%esp
}
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 02                	push   $0x2
  801c22:	e8 39 fc ff ff       	call   801860 <syscall>
  801c27:	83 c4 18             	add    $0x18,%esp
}
  801c2a:	c9                   	leave  
  801c2b:	c3                   	ret    

00801c2c <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c2c:	55                   	push   %ebp
  801c2d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 03                	push   $0x3
  801c3b:	e8 20 fc ff ff       	call   801860 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	6a 00                	push   $0x0
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 04                	push   $0x4
  801c54:	e8 07 fc ff ff       	call   801860 <syscall>
  801c59:	83 c4 18             	add    $0x18,%esp
}
  801c5c:	c9                   	leave  
  801c5d:	c3                   	ret    

00801c5e <sys_exit_env>:


void sys_exit_env(void)
{
  801c5e:	55                   	push   %ebp
  801c5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c61:	6a 00                	push   $0x0
  801c63:	6a 00                	push   $0x0
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 23                	push   $0x23
  801c6d:	e8 ee fb ff ff       	call   801860 <syscall>
  801c72:	83 c4 18             	add    $0x18,%esp
}
  801c75:	90                   	nop
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
  801c7b:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c7e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c81:	8d 50 04             	lea    0x4(%eax),%edx
  801c84:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c87:	6a 00                	push   $0x0
  801c89:	6a 00                	push   $0x0
  801c8b:	6a 00                	push   $0x0
  801c8d:	52                   	push   %edx
  801c8e:	50                   	push   %eax
  801c8f:	6a 24                	push   $0x24
  801c91:	e8 ca fb ff ff       	call   801860 <syscall>
  801c96:	83 c4 18             	add    $0x18,%esp
	return result;
  801c99:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801c9c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801c9f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ca2:	89 01                	mov    %eax,(%ecx)
  801ca4:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	c9                   	leave  
  801cab:	c2 04 00             	ret    $0x4

00801cae <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cae:	55                   	push   %ebp
  801caf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	ff 75 10             	pushl  0x10(%ebp)
  801cb8:	ff 75 0c             	pushl  0xc(%ebp)
  801cbb:	ff 75 08             	pushl  0x8(%ebp)
  801cbe:	6a 12                	push   $0x12
  801cc0:	e8 9b fb ff ff       	call   801860 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
	return ;
  801cc8:	90                   	nop
}
  801cc9:	c9                   	leave  
  801cca:	c3                   	ret    

00801ccb <sys_rcr2>:
uint32 sys_rcr2()
{
  801ccb:	55                   	push   %ebp
  801ccc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 25                	push   $0x25
  801cda:	e8 81 fb ff ff       	call   801860 <syscall>
  801cdf:	83 c4 18             	add    $0x18,%esp
}
  801ce2:	c9                   	leave  
  801ce3:	c3                   	ret    

00801ce4 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801ce4:	55                   	push   %ebp
  801ce5:	89 e5                	mov    %esp,%ebp
  801ce7:	83 ec 04             	sub    $0x4,%esp
  801cea:	8b 45 08             	mov    0x8(%ebp),%eax
  801ced:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801cf0:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 00                	push   $0x0
  801cfc:	50                   	push   %eax
  801cfd:	6a 26                	push   $0x26
  801cff:	e8 5c fb ff ff       	call   801860 <syscall>
  801d04:	83 c4 18             	add    $0x18,%esp
	return ;
  801d07:	90                   	nop
}
  801d08:	c9                   	leave  
  801d09:	c3                   	ret    

00801d0a <rsttst>:
void rsttst()
{
  801d0a:	55                   	push   %ebp
  801d0b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 28                	push   $0x28
  801d19:	e8 42 fb ff ff       	call   801860 <syscall>
  801d1e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d21:	90                   	nop
}
  801d22:	c9                   	leave  
  801d23:	c3                   	ret    

00801d24 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d24:	55                   	push   %ebp
  801d25:	89 e5                	mov    %esp,%ebp
  801d27:	83 ec 04             	sub    $0x4,%esp
  801d2a:	8b 45 14             	mov    0x14(%ebp),%eax
  801d2d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d30:	8b 55 18             	mov    0x18(%ebp),%edx
  801d33:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d37:	52                   	push   %edx
  801d38:	50                   	push   %eax
  801d39:	ff 75 10             	pushl  0x10(%ebp)
  801d3c:	ff 75 0c             	pushl  0xc(%ebp)
  801d3f:	ff 75 08             	pushl  0x8(%ebp)
  801d42:	6a 27                	push   $0x27
  801d44:	e8 17 fb ff ff       	call   801860 <syscall>
  801d49:	83 c4 18             	add    $0x18,%esp
	return ;
  801d4c:	90                   	nop
}
  801d4d:	c9                   	leave  
  801d4e:	c3                   	ret    

00801d4f <chktst>:
void chktst(uint32 n)
{
  801d4f:	55                   	push   %ebp
  801d50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	ff 75 08             	pushl  0x8(%ebp)
  801d5d:	6a 29                	push   $0x29
  801d5f:	e8 fc fa ff ff       	call   801860 <syscall>
  801d64:	83 c4 18             	add    $0x18,%esp
	return ;
  801d67:	90                   	nop
}
  801d68:	c9                   	leave  
  801d69:	c3                   	ret    

00801d6a <inctst>:

void inctst()
{
  801d6a:	55                   	push   %ebp
  801d6b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d6d:	6a 00                	push   $0x0
  801d6f:	6a 00                	push   $0x0
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 2a                	push   $0x2a
  801d79:	e8 e2 fa ff ff       	call   801860 <syscall>
  801d7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801d81:	90                   	nop
}
  801d82:	c9                   	leave  
  801d83:	c3                   	ret    

00801d84 <gettst>:
uint32 gettst()
{
  801d84:	55                   	push   %ebp
  801d85:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	6a 2b                	push   $0x2b
  801d93:	e8 c8 fa ff ff       	call   801860 <syscall>
  801d98:	83 c4 18             	add    $0x18,%esp
}
  801d9b:	c9                   	leave  
  801d9c:	c3                   	ret    

00801d9d <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801d9d:	55                   	push   %ebp
  801d9e:	89 e5                	mov    %esp,%ebp
  801da0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 2c                	push   $0x2c
  801daf:	e8 ac fa ff ff       	call   801860 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
  801db7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dba:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dbe:	75 07                	jne    801dc7 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dc0:	b8 01 00 00 00       	mov    $0x1,%eax
  801dc5:	eb 05                	jmp    801dcc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801dc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcc:	c9                   	leave  
  801dcd:	c3                   	ret    

00801dce <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801dce:	55                   	push   %ebp
  801dcf:	89 e5                	mov    %esp,%ebp
  801dd1:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dd4:	6a 00                	push   $0x0
  801dd6:	6a 00                	push   $0x0
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 2c                	push   $0x2c
  801de0:	e8 7b fa ff ff       	call   801860 <syscall>
  801de5:	83 c4 18             	add    $0x18,%esp
  801de8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801deb:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801def:	75 07                	jne    801df8 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801df1:	b8 01 00 00 00       	mov    $0x1,%eax
  801df6:	eb 05                	jmp    801dfd <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801df8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dfd:	c9                   	leave  
  801dfe:	c3                   	ret    

00801dff <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
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
  801e11:	e8 4a fa ff ff       	call   801860 <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
  801e19:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e1c:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e20:	75 07                	jne    801e29 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e22:	b8 01 00 00 00       	mov    $0x1,%eax
  801e27:	eb 05                	jmp    801e2e <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e29:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e2e:	c9                   	leave  
  801e2f:	c3                   	ret    

00801e30 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
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
  801e42:	e8 19 fa ff ff       	call   801860 <syscall>
  801e47:	83 c4 18             	add    $0x18,%esp
  801e4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e4d:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e51:	75 07                	jne    801e5a <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e53:	b8 01 00 00 00       	mov    $0x1,%eax
  801e58:	eb 05                	jmp    801e5f <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e5a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e5f:	c9                   	leave  
  801e60:	c3                   	ret    

00801e61 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e61:	55                   	push   %ebp
  801e62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e64:	6a 00                	push   $0x0
  801e66:	6a 00                	push   $0x0
  801e68:	6a 00                	push   $0x0
  801e6a:	6a 00                	push   $0x0
  801e6c:	ff 75 08             	pushl  0x8(%ebp)
  801e6f:	6a 2d                	push   $0x2d
  801e71:	e8 ea f9 ff ff       	call   801860 <syscall>
  801e76:	83 c4 18             	add    $0x18,%esp
	return ;
  801e79:	90                   	nop
}
  801e7a:	c9                   	leave  
  801e7b:	c3                   	ret    

00801e7c <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e7c:	55                   	push   %ebp
  801e7d:	89 e5                	mov    %esp,%ebp
  801e7f:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e80:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e83:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e86:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e89:	8b 45 08             	mov    0x8(%ebp),%eax
  801e8c:	6a 00                	push   $0x0
  801e8e:	53                   	push   %ebx
  801e8f:	51                   	push   %ecx
  801e90:	52                   	push   %edx
  801e91:	50                   	push   %eax
  801e92:	6a 2e                	push   $0x2e
  801e94:	e8 c7 f9 ff ff       	call   801860 <syscall>
  801e99:	83 c4 18             	add    $0x18,%esp
}
  801e9c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801e9f:	c9                   	leave  
  801ea0:	c3                   	ret    

00801ea1 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801ea1:	55                   	push   %ebp
  801ea2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ea4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 00                	push   $0x0
  801eae:	6a 00                	push   $0x0
  801eb0:	52                   	push   %edx
  801eb1:	50                   	push   %eax
  801eb2:	6a 2f                	push   $0x2f
  801eb4:	e8 a7 f9 ff ff       	call   801860 <syscall>
  801eb9:	83 c4 18             	add    $0x18,%esp
}
  801ebc:	c9                   	leave  
  801ebd:	c3                   	ret    

00801ebe <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ebe:	55                   	push   %ebp
  801ebf:	89 e5                	mov    %esp,%ebp
  801ec1:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ec4:	83 ec 0c             	sub    $0xc,%esp
  801ec7:	68 e0 39 80 00       	push   $0x8039e0
  801ecc:	e8 3e e6 ff ff       	call   80050f <cprintf>
  801ed1:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801ed4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801edb:	83 ec 0c             	sub    $0xc,%esp
  801ede:	68 0c 3a 80 00       	push   $0x803a0c
  801ee3:	e8 27 e6 ff ff       	call   80050f <cprintf>
  801ee8:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801eeb:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801eef:	a1 38 41 80 00       	mov    0x804138,%eax
  801ef4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef7:	eb 56                	jmp    801f4f <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801ef9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801efd:	74 1c                	je     801f1b <print_mem_block_lists+0x5d>
  801eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f02:	8b 50 08             	mov    0x8(%eax),%edx
  801f05:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f08:	8b 48 08             	mov    0x8(%eax),%ecx
  801f0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0e:	8b 40 0c             	mov    0xc(%eax),%eax
  801f11:	01 c8                	add    %ecx,%eax
  801f13:	39 c2                	cmp    %eax,%edx
  801f15:	73 04                	jae    801f1b <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f17:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f1e:	8b 50 08             	mov    0x8(%eax),%edx
  801f21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f24:	8b 40 0c             	mov    0xc(%eax),%eax
  801f27:	01 c2                	add    %eax,%edx
  801f29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2c:	8b 40 08             	mov    0x8(%eax),%eax
  801f2f:	83 ec 04             	sub    $0x4,%esp
  801f32:	52                   	push   %edx
  801f33:	50                   	push   %eax
  801f34:	68 21 3a 80 00       	push   $0x803a21
  801f39:	e8 d1 e5 ff ff       	call   80050f <cprintf>
  801f3e:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f44:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f47:	a1 40 41 80 00       	mov    0x804140,%eax
  801f4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f53:	74 07                	je     801f5c <print_mem_block_lists+0x9e>
  801f55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f58:	8b 00                	mov    (%eax),%eax
  801f5a:	eb 05                	jmp    801f61 <print_mem_block_lists+0xa3>
  801f5c:	b8 00 00 00 00       	mov    $0x0,%eax
  801f61:	a3 40 41 80 00       	mov    %eax,0x804140
  801f66:	a1 40 41 80 00       	mov    0x804140,%eax
  801f6b:	85 c0                	test   %eax,%eax
  801f6d:	75 8a                	jne    801ef9 <print_mem_block_lists+0x3b>
  801f6f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f73:	75 84                	jne    801ef9 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f75:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f79:	75 10                	jne    801f8b <print_mem_block_lists+0xcd>
  801f7b:	83 ec 0c             	sub    $0xc,%esp
  801f7e:	68 30 3a 80 00       	push   $0x803a30
  801f83:	e8 87 e5 ff ff       	call   80050f <cprintf>
  801f88:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801f8b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801f92:	83 ec 0c             	sub    $0xc,%esp
  801f95:	68 54 3a 80 00       	push   $0x803a54
  801f9a:	e8 70 e5 ff ff       	call   80050f <cprintf>
  801f9f:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fa2:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fa6:	a1 40 40 80 00       	mov    0x804040,%eax
  801fab:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fae:	eb 56                	jmp    802006 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fb0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fb4:	74 1c                	je     801fd2 <print_mem_block_lists+0x114>
  801fb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fb9:	8b 50 08             	mov    0x8(%eax),%edx
  801fbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fbf:	8b 48 08             	mov    0x8(%eax),%ecx
  801fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fc5:	8b 40 0c             	mov    0xc(%eax),%eax
  801fc8:	01 c8                	add    %ecx,%eax
  801fca:	39 c2                	cmp    %eax,%edx
  801fcc:	73 04                	jae    801fd2 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fce:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fd5:	8b 50 08             	mov    0x8(%eax),%edx
  801fd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdb:	8b 40 0c             	mov    0xc(%eax),%eax
  801fde:	01 c2                	add    %eax,%edx
  801fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe3:	8b 40 08             	mov    0x8(%eax),%eax
  801fe6:	83 ec 04             	sub    $0x4,%esp
  801fe9:	52                   	push   %edx
  801fea:	50                   	push   %eax
  801feb:	68 21 3a 80 00       	push   $0x803a21
  801ff0:	e8 1a e5 ff ff       	call   80050f <cprintf>
  801ff5:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ffe:	a1 48 40 80 00       	mov    0x804048,%eax
  802003:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802006:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80200a:	74 07                	je     802013 <print_mem_block_lists+0x155>
  80200c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200f:	8b 00                	mov    (%eax),%eax
  802011:	eb 05                	jmp    802018 <print_mem_block_lists+0x15a>
  802013:	b8 00 00 00 00       	mov    $0x0,%eax
  802018:	a3 48 40 80 00       	mov    %eax,0x804048
  80201d:	a1 48 40 80 00       	mov    0x804048,%eax
  802022:	85 c0                	test   %eax,%eax
  802024:	75 8a                	jne    801fb0 <print_mem_block_lists+0xf2>
  802026:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202a:	75 84                	jne    801fb0 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80202c:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802030:	75 10                	jne    802042 <print_mem_block_lists+0x184>
  802032:	83 ec 0c             	sub    $0xc,%esp
  802035:	68 6c 3a 80 00       	push   $0x803a6c
  80203a:	e8 d0 e4 ff ff       	call   80050f <cprintf>
  80203f:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802042:	83 ec 0c             	sub    $0xc,%esp
  802045:	68 e0 39 80 00       	push   $0x8039e0
  80204a:	e8 c0 e4 ff ff       	call   80050f <cprintf>
  80204f:	83 c4 10             	add    $0x10,%esp

}
  802052:	90                   	nop
  802053:	c9                   	leave  
  802054:	c3                   	ret    

00802055 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802055:	55                   	push   %ebp
  802056:	89 e5                	mov    %esp,%ebp
  802058:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80205b:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802062:	00 00 00 
  802065:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80206c:	00 00 00 
  80206f:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802076:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802079:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802080:	e9 9e 00 00 00       	jmp    802123 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802085:	a1 50 40 80 00       	mov    0x804050,%eax
  80208a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80208d:	c1 e2 04             	shl    $0x4,%edx
  802090:	01 d0                	add    %edx,%eax
  802092:	85 c0                	test   %eax,%eax
  802094:	75 14                	jne    8020aa <initialize_MemBlocksList+0x55>
  802096:	83 ec 04             	sub    $0x4,%esp
  802099:	68 94 3a 80 00       	push   $0x803a94
  80209e:	6a 3d                	push   $0x3d
  8020a0:	68 b7 3a 80 00       	push   $0x803ab7
  8020a5:	e8 b1 e1 ff ff       	call   80025b <_panic>
  8020aa:	a1 50 40 80 00       	mov    0x804050,%eax
  8020af:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020b2:	c1 e2 04             	shl    $0x4,%edx
  8020b5:	01 d0                	add    %edx,%eax
  8020b7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020bd:	89 10                	mov    %edx,(%eax)
  8020bf:	8b 00                	mov    (%eax),%eax
  8020c1:	85 c0                	test   %eax,%eax
  8020c3:	74 18                	je     8020dd <initialize_MemBlocksList+0x88>
  8020c5:	a1 48 41 80 00       	mov    0x804148,%eax
  8020ca:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020d0:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020d3:	c1 e1 04             	shl    $0x4,%ecx
  8020d6:	01 ca                	add    %ecx,%edx
  8020d8:	89 50 04             	mov    %edx,0x4(%eax)
  8020db:	eb 12                	jmp    8020ef <initialize_MemBlocksList+0x9a>
  8020dd:	a1 50 40 80 00       	mov    0x804050,%eax
  8020e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020e5:	c1 e2 04             	shl    $0x4,%edx
  8020e8:	01 d0                	add    %edx,%eax
  8020ea:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8020ef:	a1 50 40 80 00       	mov    0x804050,%eax
  8020f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020f7:	c1 e2 04             	shl    $0x4,%edx
  8020fa:	01 d0                	add    %edx,%eax
  8020fc:	a3 48 41 80 00       	mov    %eax,0x804148
  802101:	a1 50 40 80 00       	mov    0x804050,%eax
  802106:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802109:	c1 e2 04             	shl    $0x4,%edx
  80210c:	01 d0                	add    %edx,%eax
  80210e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802115:	a1 54 41 80 00       	mov    0x804154,%eax
  80211a:	40                   	inc    %eax
  80211b:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802120:	ff 45 f4             	incl   -0xc(%ebp)
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	3b 45 08             	cmp    0x8(%ebp),%eax
  802129:	0f 82 56 ff ff ff    	jb     802085 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  80212f:	90                   	nop
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802138:	8b 45 08             	mov    0x8(%ebp),%eax
  80213b:	8b 00                	mov    (%eax),%eax
  80213d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802140:	eb 18                	jmp    80215a <find_block+0x28>

		if(tmp->sva == va){
  802142:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802145:	8b 40 08             	mov    0x8(%eax),%eax
  802148:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80214b:	75 05                	jne    802152 <find_block+0x20>
			return tmp ;
  80214d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802150:	eb 11                	jmp    802163 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802152:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802155:	8b 00                	mov    (%eax),%eax
  802157:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  80215a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80215e:	75 e2                	jne    802142 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802160:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802163:	c9                   	leave  
  802164:	c3                   	ret    

00802165 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802165:	55                   	push   %ebp
  802166:	89 e5                	mov    %esp,%ebp
  802168:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  80216b:	a1 40 40 80 00       	mov    0x804040,%eax
  802170:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802173:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802178:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  80217b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80217f:	75 65                	jne    8021e6 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802181:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802185:	75 14                	jne    80219b <insert_sorted_allocList+0x36>
  802187:	83 ec 04             	sub    $0x4,%esp
  80218a:	68 94 3a 80 00       	push   $0x803a94
  80218f:	6a 62                	push   $0x62
  802191:	68 b7 3a 80 00       	push   $0x803ab7
  802196:	e8 c0 e0 ff ff       	call   80025b <_panic>
  80219b:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a4:	89 10                	mov    %edx,(%eax)
  8021a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a9:	8b 00                	mov    (%eax),%eax
  8021ab:	85 c0                	test   %eax,%eax
  8021ad:	74 0d                	je     8021bc <insert_sorted_allocList+0x57>
  8021af:	a1 40 40 80 00       	mov    0x804040,%eax
  8021b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8021b7:	89 50 04             	mov    %edx,0x4(%eax)
  8021ba:	eb 08                	jmp    8021c4 <insert_sorted_allocList+0x5f>
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	a3 44 40 80 00       	mov    %eax,0x804044
  8021c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c7:	a3 40 40 80 00       	mov    %eax,0x804040
  8021cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021d6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021db:	40                   	inc    %eax
  8021dc:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8021e1:	e9 14 01 00 00       	jmp    8022fa <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  8021e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e9:	8b 50 08             	mov    0x8(%eax),%edx
  8021ec:	a1 44 40 80 00       	mov    0x804044,%eax
  8021f1:	8b 40 08             	mov    0x8(%eax),%eax
  8021f4:	39 c2                	cmp    %eax,%edx
  8021f6:	76 65                	jbe    80225d <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  8021f8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021fc:	75 14                	jne    802212 <insert_sorted_allocList+0xad>
  8021fe:	83 ec 04             	sub    $0x4,%esp
  802201:	68 d0 3a 80 00       	push   $0x803ad0
  802206:	6a 64                	push   $0x64
  802208:	68 b7 3a 80 00       	push   $0x803ab7
  80220d:	e8 49 e0 ff ff       	call   80025b <_panic>
  802212:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802218:	8b 45 08             	mov    0x8(%ebp),%eax
  80221b:	89 50 04             	mov    %edx,0x4(%eax)
  80221e:	8b 45 08             	mov    0x8(%ebp),%eax
  802221:	8b 40 04             	mov    0x4(%eax),%eax
  802224:	85 c0                	test   %eax,%eax
  802226:	74 0c                	je     802234 <insert_sorted_allocList+0xcf>
  802228:	a1 44 40 80 00       	mov    0x804044,%eax
  80222d:	8b 55 08             	mov    0x8(%ebp),%edx
  802230:	89 10                	mov    %edx,(%eax)
  802232:	eb 08                	jmp    80223c <insert_sorted_allocList+0xd7>
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	a3 40 40 80 00       	mov    %eax,0x804040
  80223c:	8b 45 08             	mov    0x8(%ebp),%eax
  80223f:	a3 44 40 80 00       	mov    %eax,0x804044
  802244:	8b 45 08             	mov    0x8(%ebp),%eax
  802247:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80224d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802252:	40                   	inc    %eax
  802253:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802258:	e9 9d 00 00 00       	jmp    8022fa <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80225d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802264:	e9 85 00 00 00       	jmp    8022ee <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802269:	8b 45 08             	mov    0x8(%ebp),%eax
  80226c:	8b 50 08             	mov    0x8(%eax),%edx
  80226f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802272:	8b 40 08             	mov    0x8(%eax),%eax
  802275:	39 c2                	cmp    %eax,%edx
  802277:	73 6a                	jae    8022e3 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80227d:	74 06                	je     802285 <insert_sorted_allocList+0x120>
  80227f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802283:	75 14                	jne    802299 <insert_sorted_allocList+0x134>
  802285:	83 ec 04             	sub    $0x4,%esp
  802288:	68 f4 3a 80 00       	push   $0x803af4
  80228d:	6a 6b                	push   $0x6b
  80228f:	68 b7 3a 80 00       	push   $0x803ab7
  802294:	e8 c2 df ff ff       	call   80025b <_panic>
  802299:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229c:	8b 50 04             	mov    0x4(%eax),%edx
  80229f:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a2:	89 50 04             	mov    %edx,0x4(%eax)
  8022a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022ab:	89 10                	mov    %edx,(%eax)
  8022ad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b0:	8b 40 04             	mov    0x4(%eax),%eax
  8022b3:	85 c0                	test   %eax,%eax
  8022b5:	74 0d                	je     8022c4 <insert_sorted_allocList+0x15f>
  8022b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ba:	8b 40 04             	mov    0x4(%eax),%eax
  8022bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c0:	89 10                	mov    %edx,(%eax)
  8022c2:	eb 08                	jmp    8022cc <insert_sorted_allocList+0x167>
  8022c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c7:	a3 40 40 80 00       	mov    %eax,0x804040
  8022cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022cf:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d2:	89 50 04             	mov    %edx,0x4(%eax)
  8022d5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022da:	40                   	inc    %eax
  8022db:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  8022e0:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8022e1:	eb 17                	jmp    8022fa <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  8022e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e6:	8b 00                	mov    (%eax),%eax
  8022e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8022eb:	ff 45 f0             	incl   -0x10(%ebp)
  8022ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8022f1:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8022f4:	0f 8c 6f ff ff ff    	jl     802269 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8022fa:	90                   	nop
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
  802300:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802303:	a1 38 41 80 00       	mov    0x804138,%eax
  802308:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80230b:	e9 7c 01 00 00       	jmp    80248c <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802310:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802313:	8b 40 0c             	mov    0xc(%eax),%eax
  802316:	3b 45 08             	cmp    0x8(%ebp),%eax
  802319:	0f 86 cf 00 00 00    	jbe    8023ee <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80231f:	a1 48 41 80 00       	mov    0x804148,%eax
  802324:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802327:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80232a:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  80232d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802330:	8b 55 08             	mov    0x8(%ebp),%edx
  802333:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802336:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802339:	8b 50 08             	mov    0x8(%eax),%edx
  80233c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80233f:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	8b 40 0c             	mov    0xc(%eax),%eax
  802348:	2b 45 08             	sub    0x8(%ebp),%eax
  80234b:	89 c2                	mov    %eax,%edx
  80234d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802350:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802353:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802356:	8b 50 08             	mov    0x8(%eax),%edx
  802359:	8b 45 08             	mov    0x8(%ebp),%eax
  80235c:	01 c2                	add    %eax,%edx
  80235e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802361:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802364:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802368:	75 17                	jne    802381 <alloc_block_FF+0x84>
  80236a:	83 ec 04             	sub    $0x4,%esp
  80236d:	68 29 3b 80 00       	push   $0x803b29
  802372:	68 83 00 00 00       	push   $0x83
  802377:	68 b7 3a 80 00       	push   $0x803ab7
  80237c:	e8 da de ff ff       	call   80025b <_panic>
  802381:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802384:	8b 00                	mov    (%eax),%eax
  802386:	85 c0                	test   %eax,%eax
  802388:	74 10                	je     80239a <alloc_block_FF+0x9d>
  80238a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80238d:	8b 00                	mov    (%eax),%eax
  80238f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802392:	8b 52 04             	mov    0x4(%edx),%edx
  802395:	89 50 04             	mov    %edx,0x4(%eax)
  802398:	eb 0b                	jmp    8023a5 <alloc_block_FF+0xa8>
  80239a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239d:	8b 40 04             	mov    0x4(%eax),%eax
  8023a0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a8:	8b 40 04             	mov    0x4(%eax),%eax
  8023ab:	85 c0                	test   %eax,%eax
  8023ad:	74 0f                	je     8023be <alloc_block_FF+0xc1>
  8023af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b2:	8b 40 04             	mov    0x4(%eax),%eax
  8023b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023b8:	8b 12                	mov    (%edx),%edx
  8023ba:	89 10                	mov    %edx,(%eax)
  8023bc:	eb 0a                	jmp    8023c8 <alloc_block_FF+0xcb>
  8023be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c1:	8b 00                	mov    (%eax),%eax
  8023c3:	a3 48 41 80 00       	mov    %eax,0x804148
  8023c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023cb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023db:	a1 54 41 80 00       	mov    0x804154,%eax
  8023e0:	48                   	dec    %eax
  8023e1:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  8023e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e9:	e9 ad 00 00 00       	jmp    80249b <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  8023ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f7:	0f 85 87 00 00 00    	jne    802484 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  8023fd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802401:	75 17                	jne    80241a <alloc_block_FF+0x11d>
  802403:	83 ec 04             	sub    $0x4,%esp
  802406:	68 29 3b 80 00       	push   $0x803b29
  80240b:	68 87 00 00 00       	push   $0x87
  802410:	68 b7 3a 80 00       	push   $0x803ab7
  802415:	e8 41 de ff ff       	call   80025b <_panic>
  80241a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241d:	8b 00                	mov    (%eax),%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	74 10                	je     802433 <alloc_block_FF+0x136>
  802423:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802426:	8b 00                	mov    (%eax),%eax
  802428:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80242b:	8b 52 04             	mov    0x4(%edx),%edx
  80242e:	89 50 04             	mov    %edx,0x4(%eax)
  802431:	eb 0b                	jmp    80243e <alloc_block_FF+0x141>
  802433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802436:	8b 40 04             	mov    0x4(%eax),%eax
  802439:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	8b 40 04             	mov    0x4(%eax),%eax
  802444:	85 c0                	test   %eax,%eax
  802446:	74 0f                	je     802457 <alloc_block_FF+0x15a>
  802448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244b:	8b 40 04             	mov    0x4(%eax),%eax
  80244e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802451:	8b 12                	mov    (%edx),%edx
  802453:	89 10                	mov    %edx,(%eax)
  802455:	eb 0a                	jmp    802461 <alloc_block_FF+0x164>
  802457:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245a:	8b 00                	mov    (%eax),%eax
  80245c:	a3 38 41 80 00       	mov    %eax,0x804138
  802461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802464:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80246a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802474:	a1 44 41 80 00       	mov    0x804144,%eax
  802479:	48                   	dec    %eax
  80247a:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  80247f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802482:	eb 17                	jmp    80249b <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 00                	mov    (%eax),%eax
  802489:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  80248c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802490:	0f 85 7a fe ff ff    	jne    802310 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802496:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80249b:	c9                   	leave  
  80249c:	c3                   	ret    

0080249d <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80249d:	55                   	push   %ebp
  80249e:	89 e5                	mov    %esp,%ebp
  8024a0:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8024a3:	a1 38 41 80 00       	mov    0x804138,%eax
  8024a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8024ab:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8024b2:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8024b9:	a1 38 41 80 00       	mov    0x804138,%eax
  8024be:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c1:	e9 d0 00 00 00       	jmp    802596 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8024c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024c9:	8b 40 0c             	mov    0xc(%eax),%eax
  8024cc:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024cf:	0f 82 b8 00 00 00    	jb     80258d <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  8024d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8024db:	2b 45 08             	sub    0x8(%ebp),%eax
  8024de:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  8024e1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024e4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024e7:	0f 83 a1 00 00 00    	jae    80258e <alloc_block_BF+0xf1>
				differsize = differance ;
  8024ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  8024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  8024f9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024fd:	0f 85 8b 00 00 00    	jne    80258e <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802503:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802507:	75 17                	jne    802520 <alloc_block_BF+0x83>
  802509:	83 ec 04             	sub    $0x4,%esp
  80250c:	68 29 3b 80 00       	push   $0x803b29
  802511:	68 a0 00 00 00       	push   $0xa0
  802516:	68 b7 3a 80 00       	push   $0x803ab7
  80251b:	e8 3b dd ff ff       	call   80025b <_panic>
  802520:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802523:	8b 00                	mov    (%eax),%eax
  802525:	85 c0                	test   %eax,%eax
  802527:	74 10                	je     802539 <alloc_block_BF+0x9c>
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802531:	8b 52 04             	mov    0x4(%edx),%edx
  802534:	89 50 04             	mov    %edx,0x4(%eax)
  802537:	eb 0b                	jmp    802544 <alloc_block_BF+0xa7>
  802539:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253c:	8b 40 04             	mov    0x4(%eax),%eax
  80253f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	8b 40 04             	mov    0x4(%eax),%eax
  80254a:	85 c0                	test   %eax,%eax
  80254c:	74 0f                	je     80255d <alloc_block_BF+0xc0>
  80254e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802551:	8b 40 04             	mov    0x4(%eax),%eax
  802554:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802557:	8b 12                	mov    (%edx),%edx
  802559:	89 10                	mov    %edx,(%eax)
  80255b:	eb 0a                	jmp    802567 <alloc_block_BF+0xca>
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 00                	mov    (%eax),%eax
  802562:	a3 38 41 80 00       	mov    %eax,0x804138
  802567:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80257a:	a1 44 41 80 00       	mov    0x804144,%eax
  80257f:	48                   	dec    %eax
  802580:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  802585:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802588:	e9 0c 01 00 00       	jmp    802699 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  80258d:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80258e:	a1 40 41 80 00       	mov    0x804140,%eax
  802593:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802596:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259a:	74 07                	je     8025a3 <alloc_block_BF+0x106>
  80259c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259f:	8b 00                	mov    (%eax),%eax
  8025a1:	eb 05                	jmp    8025a8 <alloc_block_BF+0x10b>
  8025a3:	b8 00 00 00 00       	mov    $0x0,%eax
  8025a8:	a3 40 41 80 00       	mov    %eax,0x804140
  8025ad:	a1 40 41 80 00       	mov    0x804140,%eax
  8025b2:	85 c0                	test   %eax,%eax
  8025b4:	0f 85 0c ff ff ff    	jne    8024c6 <alloc_block_BF+0x29>
  8025ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025be:	0f 85 02 ff ff ff    	jne    8024c6 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  8025c4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025c8:	0f 84 c6 00 00 00    	je     802694 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  8025ce:	a1 48 41 80 00       	mov    0x804148,%eax
  8025d3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  8025d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8025dc:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  8025df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025e2:	8b 50 08             	mov    0x8(%eax),%edx
  8025e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025e8:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  8025eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f1:	2b 45 08             	sub    0x8(%ebp),%eax
  8025f4:	89 c2                	mov    %eax,%edx
  8025f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f9:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  8025fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025ff:	8b 50 08             	mov    0x8(%eax),%edx
  802602:	8b 45 08             	mov    0x8(%ebp),%eax
  802605:	01 c2                	add    %eax,%edx
  802607:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260a:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  80260d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802611:	75 17                	jne    80262a <alloc_block_BF+0x18d>
  802613:	83 ec 04             	sub    $0x4,%esp
  802616:	68 29 3b 80 00       	push   $0x803b29
  80261b:	68 af 00 00 00       	push   $0xaf
  802620:	68 b7 3a 80 00       	push   $0x803ab7
  802625:	e8 31 dc ff ff       	call   80025b <_panic>
  80262a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80262d:	8b 00                	mov    (%eax),%eax
  80262f:	85 c0                	test   %eax,%eax
  802631:	74 10                	je     802643 <alloc_block_BF+0x1a6>
  802633:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802636:	8b 00                	mov    (%eax),%eax
  802638:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80263b:	8b 52 04             	mov    0x4(%edx),%edx
  80263e:	89 50 04             	mov    %edx,0x4(%eax)
  802641:	eb 0b                	jmp    80264e <alloc_block_BF+0x1b1>
  802643:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802646:	8b 40 04             	mov    0x4(%eax),%eax
  802649:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80264e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802651:	8b 40 04             	mov    0x4(%eax),%eax
  802654:	85 c0                	test   %eax,%eax
  802656:	74 0f                	je     802667 <alloc_block_BF+0x1ca>
  802658:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265b:	8b 40 04             	mov    0x4(%eax),%eax
  80265e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802661:	8b 12                	mov    (%edx),%edx
  802663:	89 10                	mov    %edx,(%eax)
  802665:	eb 0a                	jmp    802671 <alloc_block_BF+0x1d4>
  802667:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80266a:	8b 00                	mov    (%eax),%eax
  80266c:	a3 48 41 80 00       	mov    %eax,0x804148
  802671:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802674:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80267d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802684:	a1 54 41 80 00       	mov    0x804154,%eax
  802689:	48                   	dec    %eax
  80268a:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  80268f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802692:	eb 05                	jmp    802699 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802694:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802699:	c9                   	leave  
  80269a:	c3                   	ret    

0080269b <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  80269b:	55                   	push   %ebp
  80269c:	89 e5                	mov    %esp,%ebp
  80269e:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8026a1:	a1 38 41 80 00       	mov    0x804138,%eax
  8026a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8026a9:	e9 7c 01 00 00       	jmp    80282a <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8026ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8026b4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026b7:	0f 86 cf 00 00 00    	jbe    80278c <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8026bd:	a1 48 41 80 00       	mov    0x804148,%eax
  8026c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8026c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  8026cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8026d1:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  8026d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d7:	8b 50 08             	mov    0x8(%eax),%edx
  8026da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026dd:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  8026e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e3:	8b 40 0c             	mov    0xc(%eax),%eax
  8026e6:	2b 45 08             	sub    0x8(%ebp),%eax
  8026e9:	89 c2                	mov    %eax,%edx
  8026eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ee:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  8026f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f4:	8b 50 08             	mov    0x8(%eax),%edx
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	01 c2                	add    %eax,%edx
  8026fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ff:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802702:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802706:	75 17                	jne    80271f <alloc_block_NF+0x84>
  802708:	83 ec 04             	sub    $0x4,%esp
  80270b:	68 29 3b 80 00       	push   $0x803b29
  802710:	68 c4 00 00 00       	push   $0xc4
  802715:	68 b7 3a 80 00       	push   $0x803ab7
  80271a:	e8 3c db ff ff       	call   80025b <_panic>
  80271f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802722:	8b 00                	mov    (%eax),%eax
  802724:	85 c0                	test   %eax,%eax
  802726:	74 10                	je     802738 <alloc_block_NF+0x9d>
  802728:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80272b:	8b 00                	mov    (%eax),%eax
  80272d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802730:	8b 52 04             	mov    0x4(%edx),%edx
  802733:	89 50 04             	mov    %edx,0x4(%eax)
  802736:	eb 0b                	jmp    802743 <alloc_block_NF+0xa8>
  802738:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80273b:	8b 40 04             	mov    0x4(%eax),%eax
  80273e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802743:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802746:	8b 40 04             	mov    0x4(%eax),%eax
  802749:	85 c0                	test   %eax,%eax
  80274b:	74 0f                	je     80275c <alloc_block_NF+0xc1>
  80274d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802750:	8b 40 04             	mov    0x4(%eax),%eax
  802753:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802756:	8b 12                	mov    (%edx),%edx
  802758:	89 10                	mov    %edx,(%eax)
  80275a:	eb 0a                	jmp    802766 <alloc_block_NF+0xcb>
  80275c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275f:	8b 00                	mov    (%eax),%eax
  802761:	a3 48 41 80 00       	mov    %eax,0x804148
  802766:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802769:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80276f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802772:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802779:	a1 54 41 80 00       	mov    0x804154,%eax
  80277e:	48                   	dec    %eax
  80277f:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  802784:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802787:	e9 ad 00 00 00       	jmp    802839 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  80278c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278f:	8b 40 0c             	mov    0xc(%eax),%eax
  802792:	3b 45 08             	cmp    0x8(%ebp),%eax
  802795:	0f 85 87 00 00 00    	jne    802822 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  80279b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279f:	75 17                	jne    8027b8 <alloc_block_NF+0x11d>
  8027a1:	83 ec 04             	sub    $0x4,%esp
  8027a4:	68 29 3b 80 00       	push   $0x803b29
  8027a9:	68 c8 00 00 00       	push   $0xc8
  8027ae:	68 b7 3a 80 00       	push   $0x803ab7
  8027b3:	e8 a3 da ff ff       	call   80025b <_panic>
  8027b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bb:	8b 00                	mov    (%eax),%eax
  8027bd:	85 c0                	test   %eax,%eax
  8027bf:	74 10                	je     8027d1 <alloc_block_NF+0x136>
  8027c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c4:	8b 00                	mov    (%eax),%eax
  8027c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c9:	8b 52 04             	mov    0x4(%edx),%edx
  8027cc:	89 50 04             	mov    %edx,0x4(%eax)
  8027cf:	eb 0b                	jmp    8027dc <alloc_block_NF+0x141>
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 04             	mov    0x4(%eax),%eax
  8027d7:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027df:	8b 40 04             	mov    0x4(%eax),%eax
  8027e2:	85 c0                	test   %eax,%eax
  8027e4:	74 0f                	je     8027f5 <alloc_block_NF+0x15a>
  8027e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e9:	8b 40 04             	mov    0x4(%eax),%eax
  8027ec:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027ef:	8b 12                	mov    (%edx),%edx
  8027f1:	89 10                	mov    %edx,(%eax)
  8027f3:	eb 0a                	jmp    8027ff <alloc_block_NF+0x164>
  8027f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f8:	8b 00                	mov    (%eax),%eax
  8027fa:	a3 38 41 80 00       	mov    %eax,0x804138
  8027ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802802:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802808:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802812:	a1 44 41 80 00       	mov    0x804144,%eax
  802817:	48                   	dec    %eax
  802818:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  80281d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802820:	eb 17                	jmp    802839 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	8b 00                	mov    (%eax),%eax
  802827:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  80282a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80282e:	0f 85 7a fe ff ff    	jne    8026ae <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802834:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802839:	c9                   	leave  
  80283a:	c3                   	ret    

0080283b <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80283b:	55                   	push   %ebp
  80283c:	89 e5                	mov    %esp,%ebp
  80283e:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802841:	a1 38 41 80 00       	mov    0x804138,%eax
  802846:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802849:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80284e:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802851:	a1 44 41 80 00       	mov    0x804144,%eax
  802856:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802859:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80285d:	75 68                	jne    8028c7 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80285f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802863:	75 17                	jne    80287c <insert_sorted_with_merge_freeList+0x41>
  802865:	83 ec 04             	sub    $0x4,%esp
  802868:	68 94 3a 80 00       	push   $0x803a94
  80286d:	68 da 00 00 00       	push   $0xda
  802872:	68 b7 3a 80 00       	push   $0x803ab7
  802877:	e8 df d9 ff ff       	call   80025b <_panic>
  80287c:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802882:	8b 45 08             	mov    0x8(%ebp),%eax
  802885:	89 10                	mov    %edx,(%eax)
  802887:	8b 45 08             	mov    0x8(%ebp),%eax
  80288a:	8b 00                	mov    (%eax),%eax
  80288c:	85 c0                	test   %eax,%eax
  80288e:	74 0d                	je     80289d <insert_sorted_with_merge_freeList+0x62>
  802890:	a1 38 41 80 00       	mov    0x804138,%eax
  802895:	8b 55 08             	mov    0x8(%ebp),%edx
  802898:	89 50 04             	mov    %edx,0x4(%eax)
  80289b:	eb 08                	jmp    8028a5 <insert_sorted_with_merge_freeList+0x6a>
  80289d:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a0:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a8:	a3 38 41 80 00       	mov    %eax,0x804138
  8028ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028b7:	a1 44 41 80 00       	mov    0x804144,%eax
  8028bc:	40                   	inc    %eax
  8028bd:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  8028c2:	e9 49 07 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  8028c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028ca:	8b 50 08             	mov    0x8(%eax),%edx
  8028cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028d0:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d3:	01 c2                	add    %eax,%edx
  8028d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d8:	8b 40 08             	mov    0x8(%eax),%eax
  8028db:	39 c2                	cmp    %eax,%edx
  8028dd:	73 77                	jae    802956 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  8028df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e2:	8b 00                	mov    (%eax),%eax
  8028e4:	85 c0                	test   %eax,%eax
  8028e6:	75 6e                	jne    802956 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  8028e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028ec:	74 68                	je     802956 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  8028ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028f2:	75 17                	jne    80290b <insert_sorted_with_merge_freeList+0xd0>
  8028f4:	83 ec 04             	sub    $0x4,%esp
  8028f7:	68 d0 3a 80 00       	push   $0x803ad0
  8028fc:	68 e0 00 00 00       	push   $0xe0
  802901:	68 b7 3a 80 00       	push   $0x803ab7
  802906:	e8 50 d9 ff ff       	call   80025b <_panic>
  80290b:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802911:	8b 45 08             	mov    0x8(%ebp),%eax
  802914:	89 50 04             	mov    %edx,0x4(%eax)
  802917:	8b 45 08             	mov    0x8(%ebp),%eax
  80291a:	8b 40 04             	mov    0x4(%eax),%eax
  80291d:	85 c0                	test   %eax,%eax
  80291f:	74 0c                	je     80292d <insert_sorted_with_merge_freeList+0xf2>
  802921:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802926:	8b 55 08             	mov    0x8(%ebp),%edx
  802929:	89 10                	mov    %edx,(%eax)
  80292b:	eb 08                	jmp    802935 <insert_sorted_with_merge_freeList+0xfa>
  80292d:	8b 45 08             	mov    0x8(%ebp),%eax
  802930:	a3 38 41 80 00       	mov    %eax,0x804138
  802935:	8b 45 08             	mov    0x8(%ebp),%eax
  802938:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80293d:	8b 45 08             	mov    0x8(%ebp),%eax
  802940:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802946:	a1 44 41 80 00       	mov    0x804144,%eax
  80294b:	40                   	inc    %eax
  80294c:	a3 44 41 80 00       	mov    %eax,0x804144
  802951:	e9 ba 06 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802956:	8b 45 08             	mov    0x8(%ebp),%eax
  802959:	8b 50 0c             	mov    0xc(%eax),%edx
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	8b 40 08             	mov    0x8(%eax),%eax
  802962:	01 c2                	add    %eax,%edx
  802964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802967:	8b 40 08             	mov    0x8(%eax),%eax
  80296a:	39 c2                	cmp    %eax,%edx
  80296c:	73 78                	jae    8029e6 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  80296e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802971:	8b 40 04             	mov    0x4(%eax),%eax
  802974:	85 c0                	test   %eax,%eax
  802976:	75 6e                	jne    8029e6 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802978:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80297c:	74 68                	je     8029e6 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80297e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802982:	75 17                	jne    80299b <insert_sorted_with_merge_freeList+0x160>
  802984:	83 ec 04             	sub    $0x4,%esp
  802987:	68 94 3a 80 00       	push   $0x803a94
  80298c:	68 e6 00 00 00       	push   $0xe6
  802991:	68 b7 3a 80 00       	push   $0x803ab7
  802996:	e8 c0 d8 ff ff       	call   80025b <_panic>
  80299b:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a4:	89 10                	mov    %edx,(%eax)
  8029a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a9:	8b 00                	mov    (%eax),%eax
  8029ab:	85 c0                	test   %eax,%eax
  8029ad:	74 0d                	je     8029bc <insert_sorted_with_merge_freeList+0x181>
  8029af:	a1 38 41 80 00       	mov    0x804138,%eax
  8029b4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029b7:	89 50 04             	mov    %edx,0x4(%eax)
  8029ba:	eb 08                	jmp    8029c4 <insert_sorted_with_merge_freeList+0x189>
  8029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bf:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	a3 38 41 80 00       	mov    %eax,0x804138
  8029cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d6:	a1 44 41 80 00       	mov    0x804144,%eax
  8029db:	40                   	inc    %eax
  8029dc:	a3 44 41 80 00       	mov    %eax,0x804144
  8029e1:	e9 2a 06 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8029e6:	a1 38 41 80 00       	mov    0x804138,%eax
  8029eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8029ee:	e9 ed 05 00 00       	jmp    802fe0 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  8029f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f6:	8b 00                	mov    (%eax),%eax
  8029f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  8029fb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8029ff:	0f 84 a7 00 00 00    	je     802aac <insert_sorted_with_merge_freeList+0x271>
  802a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a08:	8b 50 0c             	mov    0xc(%eax),%edx
  802a0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0e:	8b 40 08             	mov    0x8(%eax),%eax
  802a11:	01 c2                	add    %eax,%edx
  802a13:	8b 45 08             	mov    0x8(%ebp),%eax
  802a16:	8b 40 08             	mov    0x8(%eax),%eax
  802a19:	39 c2                	cmp    %eax,%edx
  802a1b:	0f 83 8b 00 00 00    	jae    802aac <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	8b 50 0c             	mov    0xc(%eax),%edx
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	8b 40 08             	mov    0x8(%eax),%eax
  802a2d:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802a2f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a32:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802a35:	39 c2                	cmp    %eax,%edx
  802a37:	73 73                	jae    802aac <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802a39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a3d:	74 06                	je     802a45 <insert_sorted_with_merge_freeList+0x20a>
  802a3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a43:	75 17                	jne    802a5c <insert_sorted_with_merge_freeList+0x221>
  802a45:	83 ec 04             	sub    $0x4,%esp
  802a48:	68 48 3b 80 00       	push   $0x803b48
  802a4d:	68 f0 00 00 00       	push   $0xf0
  802a52:	68 b7 3a 80 00       	push   $0x803ab7
  802a57:	e8 ff d7 ff ff       	call   80025b <_panic>
  802a5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a5f:	8b 10                	mov    (%eax),%edx
  802a61:	8b 45 08             	mov    0x8(%ebp),%eax
  802a64:	89 10                	mov    %edx,(%eax)
  802a66:	8b 45 08             	mov    0x8(%ebp),%eax
  802a69:	8b 00                	mov    (%eax),%eax
  802a6b:	85 c0                	test   %eax,%eax
  802a6d:	74 0b                	je     802a7a <insert_sorted_with_merge_freeList+0x23f>
  802a6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a72:	8b 00                	mov    (%eax),%eax
  802a74:	8b 55 08             	mov    0x8(%ebp),%edx
  802a77:	89 50 04             	mov    %edx,0x4(%eax)
  802a7a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a7d:	8b 55 08             	mov    0x8(%ebp),%edx
  802a80:	89 10                	mov    %edx,(%eax)
  802a82:	8b 45 08             	mov    0x8(%ebp),%eax
  802a85:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a88:	89 50 04             	mov    %edx,0x4(%eax)
  802a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8e:	8b 00                	mov    (%eax),%eax
  802a90:	85 c0                	test   %eax,%eax
  802a92:	75 08                	jne    802a9c <insert_sorted_with_merge_freeList+0x261>
  802a94:	8b 45 08             	mov    0x8(%ebp),%eax
  802a97:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a9c:	a1 44 41 80 00       	mov    0x804144,%eax
  802aa1:	40                   	inc    %eax
  802aa2:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802aa7:	e9 64 05 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802aac:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ab1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ab4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ab9:	8b 40 08             	mov    0x8(%eax),%eax
  802abc:	01 c2                	add    %eax,%edx
  802abe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac1:	8b 40 08             	mov    0x8(%eax),%eax
  802ac4:	39 c2                	cmp    %eax,%edx
  802ac6:	0f 85 b1 00 00 00    	jne    802b7d <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802acc:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ad1:	85 c0                	test   %eax,%eax
  802ad3:	0f 84 a4 00 00 00    	je     802b7d <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802ad9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ade:	8b 00                	mov    (%eax),%eax
  802ae0:	85 c0                	test   %eax,%eax
  802ae2:	0f 85 95 00 00 00    	jne    802b7d <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802ae8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802aed:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802af3:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802af6:	8b 55 08             	mov    0x8(%ebp),%edx
  802af9:	8b 52 0c             	mov    0xc(%edx),%edx
  802afc:	01 ca                	add    %ecx,%edx
  802afe:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802b01:	8b 45 08             	mov    0x8(%ebp),%eax
  802b04:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802b0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802b15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b19:	75 17                	jne    802b32 <insert_sorted_with_merge_freeList+0x2f7>
  802b1b:	83 ec 04             	sub    $0x4,%esp
  802b1e:	68 94 3a 80 00       	push   $0x803a94
  802b23:	68 ff 00 00 00       	push   $0xff
  802b28:	68 b7 3a 80 00       	push   $0x803ab7
  802b2d:	e8 29 d7 ff ff       	call   80025b <_panic>
  802b32:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b38:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3b:	89 10                	mov    %edx,(%eax)
  802b3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b40:	8b 00                	mov    (%eax),%eax
  802b42:	85 c0                	test   %eax,%eax
  802b44:	74 0d                	je     802b53 <insert_sorted_with_merge_freeList+0x318>
  802b46:	a1 48 41 80 00       	mov    0x804148,%eax
  802b4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4e:	89 50 04             	mov    %edx,0x4(%eax)
  802b51:	eb 08                	jmp    802b5b <insert_sorted_with_merge_freeList+0x320>
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b5b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5e:	a3 48 41 80 00       	mov    %eax,0x804148
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b6d:	a1 54 41 80 00       	mov    0x804154,%eax
  802b72:	40                   	inc    %eax
  802b73:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802b78:	e9 93 04 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802b7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b80:	8b 50 08             	mov    0x8(%eax),%edx
  802b83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b86:	8b 40 0c             	mov    0xc(%eax),%eax
  802b89:	01 c2                	add    %eax,%edx
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	8b 40 08             	mov    0x8(%eax),%eax
  802b91:	39 c2                	cmp    %eax,%edx
  802b93:	0f 85 ae 00 00 00    	jne    802c47 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802b99:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9c:	8b 50 0c             	mov    0xc(%eax),%edx
  802b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba2:	8b 40 08             	mov    0x8(%eax),%eax
  802ba5:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 00                	mov    (%eax),%eax
  802bac:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802baf:	39 c2                	cmp    %eax,%edx
  802bb1:	0f 84 90 00 00 00    	je     802c47 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802bb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bba:	8b 50 0c             	mov    0xc(%eax),%edx
  802bbd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc0:	8b 40 0c             	mov    0xc(%eax),%eax
  802bc3:	01 c2                	add    %eax,%edx
  802bc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc8:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bce:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802bdf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be3:	75 17                	jne    802bfc <insert_sorted_with_merge_freeList+0x3c1>
  802be5:	83 ec 04             	sub    $0x4,%esp
  802be8:	68 94 3a 80 00       	push   $0x803a94
  802bed:	68 0b 01 00 00       	push   $0x10b
  802bf2:	68 b7 3a 80 00       	push   $0x803ab7
  802bf7:	e8 5f d6 ff ff       	call   80025b <_panic>
  802bfc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c02:	8b 45 08             	mov    0x8(%ebp),%eax
  802c05:	89 10                	mov    %edx,(%eax)
  802c07:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0a:	8b 00                	mov    (%eax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	74 0d                	je     802c1d <insert_sorted_with_merge_freeList+0x3e2>
  802c10:	a1 48 41 80 00       	mov    0x804148,%eax
  802c15:	8b 55 08             	mov    0x8(%ebp),%edx
  802c18:	89 50 04             	mov    %edx,0x4(%eax)
  802c1b:	eb 08                	jmp    802c25 <insert_sorted_with_merge_freeList+0x3ea>
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	a3 48 41 80 00       	mov    %eax,0x804148
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c37:	a1 54 41 80 00       	mov    0x804154,%eax
  802c3c:	40                   	inc    %eax
  802c3d:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802c42:	e9 c9 03 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	8b 50 0c             	mov    0xc(%eax),%edx
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	8b 40 08             	mov    0x8(%eax),%eax
  802c53:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802c55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c58:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802c5b:	39 c2                	cmp    %eax,%edx
  802c5d:	0f 85 bb 00 00 00    	jne    802d1e <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802c63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c67:	0f 84 b1 00 00 00    	je     802d1e <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 40 04             	mov    0x4(%eax),%eax
  802c73:	85 c0                	test   %eax,%eax
  802c75:	0f 85 a3 00 00 00    	jne    802d1e <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802c7b:	a1 38 41 80 00       	mov    0x804138,%eax
  802c80:	8b 55 08             	mov    0x8(%ebp),%edx
  802c83:	8b 52 08             	mov    0x8(%edx),%edx
  802c86:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802c89:	a1 38 41 80 00       	mov    0x804138,%eax
  802c8e:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802c94:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802c97:	8b 55 08             	mov    0x8(%ebp),%edx
  802c9a:	8b 52 0c             	mov    0xc(%edx),%edx
  802c9d:	01 ca                	add    %ecx,%edx
  802c9f:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802ca2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802cac:	8b 45 08             	mov    0x8(%ebp),%eax
  802caf:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802cb6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cba:	75 17                	jne    802cd3 <insert_sorted_with_merge_freeList+0x498>
  802cbc:	83 ec 04             	sub    $0x4,%esp
  802cbf:	68 94 3a 80 00       	push   $0x803a94
  802cc4:	68 17 01 00 00       	push   $0x117
  802cc9:	68 b7 3a 80 00       	push   $0x803ab7
  802cce:	e8 88 d5 ff ff       	call   80025b <_panic>
  802cd3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdc:	89 10                	mov    %edx,(%eax)
  802cde:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce1:	8b 00                	mov    (%eax),%eax
  802ce3:	85 c0                	test   %eax,%eax
  802ce5:	74 0d                	je     802cf4 <insert_sorted_with_merge_freeList+0x4b9>
  802ce7:	a1 48 41 80 00       	mov    0x804148,%eax
  802cec:	8b 55 08             	mov    0x8(%ebp),%edx
  802cef:	89 50 04             	mov    %edx,0x4(%eax)
  802cf2:	eb 08                	jmp    802cfc <insert_sorted_with_merge_freeList+0x4c1>
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cff:	a3 48 41 80 00       	mov    %eax,0x804148
  802d04:	8b 45 08             	mov    0x8(%ebp),%eax
  802d07:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d0e:	a1 54 41 80 00       	mov    0x804154,%eax
  802d13:	40                   	inc    %eax
  802d14:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d19:	e9 f2 02 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d21:	8b 50 08             	mov    0x8(%eax),%edx
  802d24:	8b 45 08             	mov    0x8(%ebp),%eax
  802d27:	8b 40 0c             	mov    0xc(%eax),%eax
  802d2a:	01 c2                	add    %eax,%edx
  802d2c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d2f:	8b 40 08             	mov    0x8(%eax),%eax
  802d32:	39 c2                	cmp    %eax,%edx
  802d34:	0f 85 be 00 00 00    	jne    802df8 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3d:	8b 40 04             	mov    0x4(%eax),%eax
  802d40:	8b 50 08             	mov    0x8(%eax),%edx
  802d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d46:	8b 40 04             	mov    0x4(%eax),%eax
  802d49:	8b 40 0c             	mov    0xc(%eax),%eax
  802d4c:	01 c2                	add    %eax,%edx
  802d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d51:	8b 40 08             	mov    0x8(%eax),%eax
  802d54:	39 c2                	cmp    %eax,%edx
  802d56:	0f 84 9c 00 00 00    	je     802df8 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	8b 50 08             	mov    0x8(%eax),%edx
  802d62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d65:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 50 0c             	mov    0xc(%eax),%edx
  802d6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802d71:	8b 40 0c             	mov    0xc(%eax),%eax
  802d74:	01 c2                	add    %eax,%edx
  802d76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d79:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d94:	75 17                	jne    802dad <insert_sorted_with_merge_freeList+0x572>
  802d96:	83 ec 04             	sub    $0x4,%esp
  802d99:	68 94 3a 80 00       	push   $0x803a94
  802d9e:	68 26 01 00 00       	push   $0x126
  802da3:	68 b7 3a 80 00       	push   $0x803ab7
  802da8:	e8 ae d4 ff ff       	call   80025b <_panic>
  802dad:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	89 10                	mov    %edx,(%eax)
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	8b 00                	mov    (%eax),%eax
  802dbd:	85 c0                	test   %eax,%eax
  802dbf:	74 0d                	je     802dce <insert_sorted_with_merge_freeList+0x593>
  802dc1:	a1 48 41 80 00       	mov    0x804148,%eax
  802dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc9:	89 50 04             	mov    %edx,0x4(%eax)
  802dcc:	eb 08                	jmp    802dd6 <insert_sorted_with_merge_freeList+0x59b>
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	a3 48 41 80 00       	mov    %eax,0x804148
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de8:	a1 54 41 80 00       	mov    0x804154,%eax
  802ded:	40                   	inc    %eax
  802dee:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802df3:	e9 18 02 00 00       	jmp    803010 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802df8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfb:	8b 50 0c             	mov    0xc(%eax),%edx
  802dfe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e01:	8b 40 08             	mov    0x8(%eax),%eax
  802e04:	01 c2                	add    %eax,%edx
  802e06:	8b 45 08             	mov    0x8(%ebp),%eax
  802e09:	8b 40 08             	mov    0x8(%eax),%eax
  802e0c:	39 c2                	cmp    %eax,%edx
  802e0e:	0f 85 c4 01 00 00    	jne    802fd8 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802e14:	8b 45 08             	mov    0x8(%ebp),%eax
  802e17:	8b 50 0c             	mov    0xc(%eax),%edx
  802e1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1d:	8b 40 08             	mov    0x8(%eax),%eax
  802e20:	01 c2                	add    %eax,%edx
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 00                	mov    (%eax),%eax
  802e27:	8b 40 08             	mov    0x8(%eax),%eax
  802e2a:	39 c2                	cmp    %eax,%edx
  802e2c:	0f 85 a6 01 00 00    	jne    802fd8 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802e32:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e36:	0f 84 9c 01 00 00    	je     802fd8 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	8b 50 0c             	mov    0xc(%eax),%edx
  802e42:	8b 45 08             	mov    0x8(%ebp),%eax
  802e45:	8b 40 0c             	mov    0xc(%eax),%eax
  802e48:	01 c2                	add    %eax,%edx
  802e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4d:	8b 00                	mov    (%eax),%eax
  802e4f:	8b 40 0c             	mov    0xc(%eax),%eax
  802e52:	01 c2                	add    %eax,%edx
  802e54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e57:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802e5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802e6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e72:	75 17                	jne    802e8b <insert_sorted_with_merge_freeList+0x650>
  802e74:	83 ec 04             	sub    $0x4,%esp
  802e77:	68 94 3a 80 00       	push   $0x803a94
  802e7c:	68 32 01 00 00       	push   $0x132
  802e81:	68 b7 3a 80 00       	push   $0x803ab7
  802e86:	e8 d0 d3 ff ff       	call   80025b <_panic>
  802e8b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	89 10                	mov    %edx,(%eax)
  802e96:	8b 45 08             	mov    0x8(%ebp),%eax
  802e99:	8b 00                	mov    (%eax),%eax
  802e9b:	85 c0                	test   %eax,%eax
  802e9d:	74 0d                	je     802eac <insert_sorted_with_merge_freeList+0x671>
  802e9f:	a1 48 41 80 00       	mov    0x804148,%eax
  802ea4:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea7:	89 50 04             	mov    %edx,0x4(%eax)
  802eaa:	eb 08                	jmp    802eb4 <insert_sorted_with_merge_freeList+0x679>
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb7:	a3 48 41 80 00       	mov    %eax,0x804148
  802ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec6:	a1 54 41 80 00       	mov    0x804154,%eax
  802ecb:	40                   	inc    %eax
  802ecc:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802ed1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed4:	8b 00                	mov    (%eax),%eax
  802ed6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802edd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ee0:	8b 00                	mov    (%eax),%eax
  802ee2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802ef1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ef5:	75 17                	jne    802f0e <insert_sorted_with_merge_freeList+0x6d3>
  802ef7:	83 ec 04             	sub    $0x4,%esp
  802efa:	68 29 3b 80 00       	push   $0x803b29
  802eff:	68 36 01 00 00       	push   $0x136
  802f04:	68 b7 3a 80 00       	push   $0x803ab7
  802f09:	e8 4d d3 ff ff       	call   80025b <_panic>
  802f0e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f11:	8b 00                	mov    (%eax),%eax
  802f13:	85 c0                	test   %eax,%eax
  802f15:	74 10                	je     802f27 <insert_sorted_with_merge_freeList+0x6ec>
  802f17:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f1a:	8b 00                	mov    (%eax),%eax
  802f1c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f1f:	8b 52 04             	mov    0x4(%edx),%edx
  802f22:	89 50 04             	mov    %edx,0x4(%eax)
  802f25:	eb 0b                	jmp    802f32 <insert_sorted_with_merge_freeList+0x6f7>
  802f27:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f2a:	8b 40 04             	mov    0x4(%eax),%eax
  802f2d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f32:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f35:	8b 40 04             	mov    0x4(%eax),%eax
  802f38:	85 c0                	test   %eax,%eax
  802f3a:	74 0f                	je     802f4b <insert_sorted_with_merge_freeList+0x710>
  802f3c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f3f:	8b 40 04             	mov    0x4(%eax),%eax
  802f42:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f45:	8b 12                	mov    (%edx),%edx
  802f47:	89 10                	mov    %edx,(%eax)
  802f49:	eb 0a                	jmp    802f55 <insert_sorted_with_merge_freeList+0x71a>
  802f4b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4e:	8b 00                	mov    (%eax),%eax
  802f50:	a3 38 41 80 00       	mov    %eax,0x804138
  802f55:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f58:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f5e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f61:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f68:	a1 44 41 80 00       	mov    0x804144,%eax
  802f6d:	48                   	dec    %eax
  802f6e:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  802f73:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f77:	75 17                	jne    802f90 <insert_sorted_with_merge_freeList+0x755>
  802f79:	83 ec 04             	sub    $0x4,%esp
  802f7c:	68 94 3a 80 00       	push   $0x803a94
  802f81:	68 37 01 00 00       	push   $0x137
  802f86:	68 b7 3a 80 00       	push   $0x803ab7
  802f8b:	e8 cb d2 ff ff       	call   80025b <_panic>
  802f90:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f99:	89 10                	mov    %edx,(%eax)
  802f9b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f9e:	8b 00                	mov    (%eax),%eax
  802fa0:	85 c0                	test   %eax,%eax
  802fa2:	74 0d                	je     802fb1 <insert_sorted_with_merge_freeList+0x776>
  802fa4:	a1 48 41 80 00       	mov    0x804148,%eax
  802fa9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fac:	89 50 04             	mov    %edx,0x4(%eax)
  802faf:	eb 08                	jmp    802fb9 <insert_sorted_with_merge_freeList+0x77e>
  802fb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fb9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fbc:	a3 48 41 80 00       	mov    %eax,0x804148
  802fc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fc4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fcb:	a1 54 41 80 00       	mov    0x804154,%eax
  802fd0:	40                   	inc    %eax
  802fd1:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  802fd6:	eb 38                	jmp    803010 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802fd8:	a1 40 41 80 00       	mov    0x804140,%eax
  802fdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802fe0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe4:	74 07                	je     802fed <insert_sorted_with_merge_freeList+0x7b2>
  802fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe9:	8b 00                	mov    (%eax),%eax
  802feb:	eb 05                	jmp    802ff2 <insert_sorted_with_merge_freeList+0x7b7>
  802fed:	b8 00 00 00 00       	mov    $0x0,%eax
  802ff2:	a3 40 41 80 00       	mov    %eax,0x804140
  802ff7:	a1 40 41 80 00       	mov    0x804140,%eax
  802ffc:	85 c0                	test   %eax,%eax
  802ffe:	0f 85 ef f9 ff ff    	jne    8029f3 <insert_sorted_with_merge_freeList+0x1b8>
  803004:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803008:	0f 85 e5 f9 ff ff    	jne    8029f3 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  80300e:	eb 00                	jmp    803010 <insert_sorted_with_merge_freeList+0x7d5>
  803010:	90                   	nop
  803011:	c9                   	leave  
  803012:	c3                   	ret    
  803013:	90                   	nop

00803014 <__udivdi3>:
  803014:	55                   	push   %ebp
  803015:	57                   	push   %edi
  803016:	56                   	push   %esi
  803017:	53                   	push   %ebx
  803018:	83 ec 1c             	sub    $0x1c,%esp
  80301b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80301f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803023:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803027:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80302b:	89 ca                	mov    %ecx,%edx
  80302d:	89 f8                	mov    %edi,%eax
  80302f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803033:	85 f6                	test   %esi,%esi
  803035:	75 2d                	jne    803064 <__udivdi3+0x50>
  803037:	39 cf                	cmp    %ecx,%edi
  803039:	77 65                	ja     8030a0 <__udivdi3+0x8c>
  80303b:	89 fd                	mov    %edi,%ebp
  80303d:	85 ff                	test   %edi,%edi
  80303f:	75 0b                	jne    80304c <__udivdi3+0x38>
  803041:	b8 01 00 00 00       	mov    $0x1,%eax
  803046:	31 d2                	xor    %edx,%edx
  803048:	f7 f7                	div    %edi
  80304a:	89 c5                	mov    %eax,%ebp
  80304c:	31 d2                	xor    %edx,%edx
  80304e:	89 c8                	mov    %ecx,%eax
  803050:	f7 f5                	div    %ebp
  803052:	89 c1                	mov    %eax,%ecx
  803054:	89 d8                	mov    %ebx,%eax
  803056:	f7 f5                	div    %ebp
  803058:	89 cf                	mov    %ecx,%edi
  80305a:	89 fa                	mov    %edi,%edx
  80305c:	83 c4 1c             	add    $0x1c,%esp
  80305f:	5b                   	pop    %ebx
  803060:	5e                   	pop    %esi
  803061:	5f                   	pop    %edi
  803062:	5d                   	pop    %ebp
  803063:	c3                   	ret    
  803064:	39 ce                	cmp    %ecx,%esi
  803066:	77 28                	ja     803090 <__udivdi3+0x7c>
  803068:	0f bd fe             	bsr    %esi,%edi
  80306b:	83 f7 1f             	xor    $0x1f,%edi
  80306e:	75 40                	jne    8030b0 <__udivdi3+0x9c>
  803070:	39 ce                	cmp    %ecx,%esi
  803072:	72 0a                	jb     80307e <__udivdi3+0x6a>
  803074:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803078:	0f 87 9e 00 00 00    	ja     80311c <__udivdi3+0x108>
  80307e:	b8 01 00 00 00       	mov    $0x1,%eax
  803083:	89 fa                	mov    %edi,%edx
  803085:	83 c4 1c             	add    $0x1c,%esp
  803088:	5b                   	pop    %ebx
  803089:	5e                   	pop    %esi
  80308a:	5f                   	pop    %edi
  80308b:	5d                   	pop    %ebp
  80308c:	c3                   	ret    
  80308d:	8d 76 00             	lea    0x0(%esi),%esi
  803090:	31 ff                	xor    %edi,%edi
  803092:	31 c0                	xor    %eax,%eax
  803094:	89 fa                	mov    %edi,%edx
  803096:	83 c4 1c             	add    $0x1c,%esp
  803099:	5b                   	pop    %ebx
  80309a:	5e                   	pop    %esi
  80309b:	5f                   	pop    %edi
  80309c:	5d                   	pop    %ebp
  80309d:	c3                   	ret    
  80309e:	66 90                	xchg   %ax,%ax
  8030a0:	89 d8                	mov    %ebx,%eax
  8030a2:	f7 f7                	div    %edi
  8030a4:	31 ff                	xor    %edi,%edi
  8030a6:	89 fa                	mov    %edi,%edx
  8030a8:	83 c4 1c             	add    $0x1c,%esp
  8030ab:	5b                   	pop    %ebx
  8030ac:	5e                   	pop    %esi
  8030ad:	5f                   	pop    %edi
  8030ae:	5d                   	pop    %ebp
  8030af:	c3                   	ret    
  8030b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030b5:	89 eb                	mov    %ebp,%ebx
  8030b7:	29 fb                	sub    %edi,%ebx
  8030b9:	89 f9                	mov    %edi,%ecx
  8030bb:	d3 e6                	shl    %cl,%esi
  8030bd:	89 c5                	mov    %eax,%ebp
  8030bf:	88 d9                	mov    %bl,%cl
  8030c1:	d3 ed                	shr    %cl,%ebp
  8030c3:	89 e9                	mov    %ebp,%ecx
  8030c5:	09 f1                	or     %esi,%ecx
  8030c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030cb:	89 f9                	mov    %edi,%ecx
  8030cd:	d3 e0                	shl    %cl,%eax
  8030cf:	89 c5                	mov    %eax,%ebp
  8030d1:	89 d6                	mov    %edx,%esi
  8030d3:	88 d9                	mov    %bl,%cl
  8030d5:	d3 ee                	shr    %cl,%esi
  8030d7:	89 f9                	mov    %edi,%ecx
  8030d9:	d3 e2                	shl    %cl,%edx
  8030db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030df:	88 d9                	mov    %bl,%cl
  8030e1:	d3 e8                	shr    %cl,%eax
  8030e3:	09 c2                	or     %eax,%edx
  8030e5:	89 d0                	mov    %edx,%eax
  8030e7:	89 f2                	mov    %esi,%edx
  8030e9:	f7 74 24 0c          	divl   0xc(%esp)
  8030ed:	89 d6                	mov    %edx,%esi
  8030ef:	89 c3                	mov    %eax,%ebx
  8030f1:	f7 e5                	mul    %ebp
  8030f3:	39 d6                	cmp    %edx,%esi
  8030f5:	72 19                	jb     803110 <__udivdi3+0xfc>
  8030f7:	74 0b                	je     803104 <__udivdi3+0xf0>
  8030f9:	89 d8                	mov    %ebx,%eax
  8030fb:	31 ff                	xor    %edi,%edi
  8030fd:	e9 58 ff ff ff       	jmp    80305a <__udivdi3+0x46>
  803102:	66 90                	xchg   %ax,%ax
  803104:	8b 54 24 08          	mov    0x8(%esp),%edx
  803108:	89 f9                	mov    %edi,%ecx
  80310a:	d3 e2                	shl    %cl,%edx
  80310c:	39 c2                	cmp    %eax,%edx
  80310e:	73 e9                	jae    8030f9 <__udivdi3+0xe5>
  803110:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803113:	31 ff                	xor    %edi,%edi
  803115:	e9 40 ff ff ff       	jmp    80305a <__udivdi3+0x46>
  80311a:	66 90                	xchg   %ax,%ax
  80311c:	31 c0                	xor    %eax,%eax
  80311e:	e9 37 ff ff ff       	jmp    80305a <__udivdi3+0x46>
  803123:	90                   	nop

00803124 <__umoddi3>:
  803124:	55                   	push   %ebp
  803125:	57                   	push   %edi
  803126:	56                   	push   %esi
  803127:	53                   	push   %ebx
  803128:	83 ec 1c             	sub    $0x1c,%esp
  80312b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80312f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803133:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803137:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80313b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80313f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803143:	89 f3                	mov    %esi,%ebx
  803145:	89 fa                	mov    %edi,%edx
  803147:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80314b:	89 34 24             	mov    %esi,(%esp)
  80314e:	85 c0                	test   %eax,%eax
  803150:	75 1a                	jne    80316c <__umoddi3+0x48>
  803152:	39 f7                	cmp    %esi,%edi
  803154:	0f 86 a2 00 00 00    	jbe    8031fc <__umoddi3+0xd8>
  80315a:	89 c8                	mov    %ecx,%eax
  80315c:	89 f2                	mov    %esi,%edx
  80315e:	f7 f7                	div    %edi
  803160:	89 d0                	mov    %edx,%eax
  803162:	31 d2                	xor    %edx,%edx
  803164:	83 c4 1c             	add    $0x1c,%esp
  803167:	5b                   	pop    %ebx
  803168:	5e                   	pop    %esi
  803169:	5f                   	pop    %edi
  80316a:	5d                   	pop    %ebp
  80316b:	c3                   	ret    
  80316c:	39 f0                	cmp    %esi,%eax
  80316e:	0f 87 ac 00 00 00    	ja     803220 <__umoddi3+0xfc>
  803174:	0f bd e8             	bsr    %eax,%ebp
  803177:	83 f5 1f             	xor    $0x1f,%ebp
  80317a:	0f 84 ac 00 00 00    	je     80322c <__umoddi3+0x108>
  803180:	bf 20 00 00 00       	mov    $0x20,%edi
  803185:	29 ef                	sub    %ebp,%edi
  803187:	89 fe                	mov    %edi,%esi
  803189:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80318d:	89 e9                	mov    %ebp,%ecx
  80318f:	d3 e0                	shl    %cl,%eax
  803191:	89 d7                	mov    %edx,%edi
  803193:	89 f1                	mov    %esi,%ecx
  803195:	d3 ef                	shr    %cl,%edi
  803197:	09 c7                	or     %eax,%edi
  803199:	89 e9                	mov    %ebp,%ecx
  80319b:	d3 e2                	shl    %cl,%edx
  80319d:	89 14 24             	mov    %edx,(%esp)
  8031a0:	89 d8                	mov    %ebx,%eax
  8031a2:	d3 e0                	shl    %cl,%eax
  8031a4:	89 c2                	mov    %eax,%edx
  8031a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031aa:	d3 e0                	shl    %cl,%eax
  8031ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031b4:	89 f1                	mov    %esi,%ecx
  8031b6:	d3 e8                	shr    %cl,%eax
  8031b8:	09 d0                	or     %edx,%eax
  8031ba:	d3 eb                	shr    %cl,%ebx
  8031bc:	89 da                	mov    %ebx,%edx
  8031be:	f7 f7                	div    %edi
  8031c0:	89 d3                	mov    %edx,%ebx
  8031c2:	f7 24 24             	mull   (%esp)
  8031c5:	89 c6                	mov    %eax,%esi
  8031c7:	89 d1                	mov    %edx,%ecx
  8031c9:	39 d3                	cmp    %edx,%ebx
  8031cb:	0f 82 87 00 00 00    	jb     803258 <__umoddi3+0x134>
  8031d1:	0f 84 91 00 00 00    	je     803268 <__umoddi3+0x144>
  8031d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031db:	29 f2                	sub    %esi,%edx
  8031dd:	19 cb                	sbb    %ecx,%ebx
  8031df:	89 d8                	mov    %ebx,%eax
  8031e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8031e5:	d3 e0                	shl    %cl,%eax
  8031e7:	89 e9                	mov    %ebp,%ecx
  8031e9:	d3 ea                	shr    %cl,%edx
  8031eb:	09 d0                	or     %edx,%eax
  8031ed:	89 e9                	mov    %ebp,%ecx
  8031ef:	d3 eb                	shr    %cl,%ebx
  8031f1:	89 da                	mov    %ebx,%edx
  8031f3:	83 c4 1c             	add    $0x1c,%esp
  8031f6:	5b                   	pop    %ebx
  8031f7:	5e                   	pop    %esi
  8031f8:	5f                   	pop    %edi
  8031f9:	5d                   	pop    %ebp
  8031fa:	c3                   	ret    
  8031fb:	90                   	nop
  8031fc:	89 fd                	mov    %edi,%ebp
  8031fe:	85 ff                	test   %edi,%edi
  803200:	75 0b                	jne    80320d <__umoddi3+0xe9>
  803202:	b8 01 00 00 00       	mov    $0x1,%eax
  803207:	31 d2                	xor    %edx,%edx
  803209:	f7 f7                	div    %edi
  80320b:	89 c5                	mov    %eax,%ebp
  80320d:	89 f0                	mov    %esi,%eax
  80320f:	31 d2                	xor    %edx,%edx
  803211:	f7 f5                	div    %ebp
  803213:	89 c8                	mov    %ecx,%eax
  803215:	f7 f5                	div    %ebp
  803217:	89 d0                	mov    %edx,%eax
  803219:	e9 44 ff ff ff       	jmp    803162 <__umoddi3+0x3e>
  80321e:	66 90                	xchg   %ax,%ax
  803220:	89 c8                	mov    %ecx,%eax
  803222:	89 f2                	mov    %esi,%edx
  803224:	83 c4 1c             	add    $0x1c,%esp
  803227:	5b                   	pop    %ebx
  803228:	5e                   	pop    %esi
  803229:	5f                   	pop    %edi
  80322a:	5d                   	pop    %ebp
  80322b:	c3                   	ret    
  80322c:	3b 04 24             	cmp    (%esp),%eax
  80322f:	72 06                	jb     803237 <__umoddi3+0x113>
  803231:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803235:	77 0f                	ja     803246 <__umoddi3+0x122>
  803237:	89 f2                	mov    %esi,%edx
  803239:	29 f9                	sub    %edi,%ecx
  80323b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80323f:	89 14 24             	mov    %edx,(%esp)
  803242:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803246:	8b 44 24 04          	mov    0x4(%esp),%eax
  80324a:	8b 14 24             	mov    (%esp),%edx
  80324d:	83 c4 1c             	add    $0x1c,%esp
  803250:	5b                   	pop    %ebx
  803251:	5e                   	pop    %esi
  803252:	5f                   	pop    %edi
  803253:	5d                   	pop    %ebp
  803254:	c3                   	ret    
  803255:	8d 76 00             	lea    0x0(%esi),%esi
  803258:	2b 04 24             	sub    (%esp),%eax
  80325b:	19 fa                	sbb    %edi,%edx
  80325d:	89 d1                	mov    %edx,%ecx
  80325f:	89 c6                	mov    %eax,%esi
  803261:	e9 71 ff ff ff       	jmp    8031d7 <__umoddi3+0xb3>
  803266:	66 90                	xchg   %ax,%ax
  803268:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80326c:	72 ea                	jb     803258 <__umoddi3+0x134>
  80326e:	89 d9                	mov    %ebx,%ecx
  803270:	e9 62 ff ff ff       	jmp    8031d7 <__umoddi3+0xb3>
