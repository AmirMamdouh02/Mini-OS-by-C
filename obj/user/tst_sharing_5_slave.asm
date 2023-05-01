
obj/user/tst_sharing_5_slave:     file format elf32-i386


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
  800031:	e8 ff 00 00 00       	call   800135 <libmain>
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
  80008c:	68 a0 32 80 00       	push   $0x8032a0
  800091:	6a 12                	push   $0x12
  800093:	68 bc 32 80 00       	push   $0x8032bc
  800098:	e8 d4 01 00 00       	call   800271 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009d:	83 ec 0c             	sub    $0xc,%esp
  8000a0:	6a 00                	push   $0x0
  8000a2:	e8 1d 14 00 00       	call   8014c4 <malloc>
  8000a7:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int expected;
	uint32 *x;
	x = sget(sys_getparentenvid(),"x");
  8000aa:	e8 ac 1b 00 00       	call   801c5b <sys_getparentenvid>
  8000af:	83 ec 08             	sub    $0x8,%esp
  8000b2:	68 d7 32 80 00       	push   $0x8032d7
  8000b7:	50                   	push   %eax
  8000b8:	e8 57 16 00 00       	call   801714 <sget>
  8000bd:	83 c4 10             	add    $0x10,%esp
  8000c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int freeFrames = sys_calculate_free_frames() ;
  8000c3:	e8 9a 18 00 00       	call   801962 <sys_calculate_free_frames>
  8000c8:	89 45 e8             	mov    %eax,-0x18(%ebp)

	cprintf("Slave env used x (getSharedObject)\n");
  8000cb:	83 ec 0c             	sub    $0xc,%esp
  8000ce:	68 dc 32 80 00       	push   $0x8032dc
  8000d3:	e8 4d 04 00 00       	call   800525 <cprintf>
  8000d8:	83 c4 10             	add    $0x10,%esp

	sfree(x);
  8000db:	83 ec 0c             	sub    $0xc,%esp
  8000de:	ff 75 ec             	pushl  -0x14(%ebp)
  8000e1:	e8 1c 17 00 00       	call   801802 <sfree>
  8000e6:	83 c4 10             	add    $0x10,%esp
	cprintf("Slave env removed x\n");
  8000e9:	83 ec 0c             	sub    $0xc,%esp
  8000ec:	68 00 33 80 00       	push   $0x803300
  8000f1:	e8 2f 04 00 00       	call   800525 <cprintf>
  8000f6:	83 c4 10             	add    $0x10,%esp

	int diff = (sys_calculate_free_frames() - freeFrames);
  8000f9:	e8 64 18 00 00       	call   801962 <sys_calculate_free_frames>
  8000fe:	89 c2                	mov    %eax,%edx
  800100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800103:	29 c2                	sub    %eax,%edx
  800105:	89 d0                	mov    %edx,%eax
  800107:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	expected = 1;
  80010a:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
	if (diff != expected) panic("wrong free: frames removed not equal 1 !, correct frames to be removed is 1:\nfrom the env: 1 table for x\nframes_storage: not cleared yet\n");
  800111:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800114:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800117:	74 14                	je     80012d <_main+0xf5>
  800119:	83 ec 04             	sub    $0x4,%esp
  80011c:	68 18 33 80 00       	push   $0x803318
  800121:	6a 24                	push   $0x24
  800123:	68 bc 32 80 00       	push   $0x8032bc
  800128:	e8 44 01 00 00       	call   800271 <_panic>

	//to ensure that this environment is completed successfully
	inctst();
  80012d:	e8 4e 1c 00 00       	call   801d80 <inctst>

	return;
  800132:	90                   	nop
}
  800133:	c9                   	leave  
  800134:	c3                   	ret    

00800135 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800135:	55                   	push   %ebp
  800136:	89 e5                	mov    %esp,%ebp
  800138:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80013b:	e8 02 1b 00 00       	call   801c42 <sys_getenvindex>
  800140:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800143:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800146:	89 d0                	mov    %edx,%eax
  800148:	c1 e0 03             	shl    $0x3,%eax
  80014b:	01 d0                	add    %edx,%eax
  80014d:	01 c0                	add    %eax,%eax
  80014f:	01 d0                	add    %edx,%eax
  800151:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800158:	01 d0                	add    %edx,%eax
  80015a:	c1 e0 04             	shl    $0x4,%eax
  80015d:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800162:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800167:	a1 20 40 80 00       	mov    0x804020,%eax
  80016c:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800172:	84 c0                	test   %al,%al
  800174:	74 0f                	je     800185 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800176:	a1 20 40 80 00       	mov    0x804020,%eax
  80017b:	05 5c 05 00 00       	add    $0x55c,%eax
  800180:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800185:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800189:	7e 0a                	jle    800195 <libmain+0x60>
		binaryname = argv[0];
  80018b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80018e:	8b 00                	mov    (%eax),%eax
  800190:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800195:	83 ec 08             	sub    $0x8,%esp
  800198:	ff 75 0c             	pushl  0xc(%ebp)
  80019b:	ff 75 08             	pushl  0x8(%ebp)
  80019e:	e8 95 fe ff ff       	call   800038 <_main>
  8001a3:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001a6:	e8 a4 18 00 00       	call   801a4f <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001ab:	83 ec 0c             	sub    $0xc,%esp
  8001ae:	68 bc 33 80 00       	push   $0x8033bc
  8001b3:	e8 6d 03 00 00       	call   800525 <cprintf>
  8001b8:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001bb:	a1 20 40 80 00       	mov    0x804020,%eax
  8001c0:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001c6:	a1 20 40 80 00       	mov    0x804020,%eax
  8001cb:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8001d1:	83 ec 04             	sub    $0x4,%esp
  8001d4:	52                   	push   %edx
  8001d5:	50                   	push   %eax
  8001d6:	68 e4 33 80 00       	push   $0x8033e4
  8001db:	e8 45 03 00 00       	call   800525 <cprintf>
  8001e0:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8001e3:	a1 20 40 80 00       	mov    0x804020,%eax
  8001e8:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8001ee:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f3:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8001f9:	a1 20 40 80 00       	mov    0x804020,%eax
  8001fe:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800204:	51                   	push   %ecx
  800205:	52                   	push   %edx
  800206:	50                   	push   %eax
  800207:	68 0c 34 80 00       	push   $0x80340c
  80020c:	e8 14 03 00 00       	call   800525 <cprintf>
  800211:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800214:	a1 20 40 80 00       	mov    0x804020,%eax
  800219:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80021f:	83 ec 08             	sub    $0x8,%esp
  800222:	50                   	push   %eax
  800223:	68 64 34 80 00       	push   $0x803464
  800228:	e8 f8 02 00 00       	call   800525 <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800230:	83 ec 0c             	sub    $0xc,%esp
  800233:	68 bc 33 80 00       	push   $0x8033bc
  800238:	e8 e8 02 00 00       	call   800525 <cprintf>
  80023d:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800240:	e8 24 18 00 00       	call   801a69 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800245:	e8 19 00 00 00       	call   800263 <exit>
}
  80024a:	90                   	nop
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800253:	83 ec 0c             	sub    $0xc,%esp
  800256:	6a 00                	push   $0x0
  800258:	e8 b1 19 00 00       	call   801c0e <sys_destroy_env>
  80025d:	83 c4 10             	add    $0x10,%esp
}
  800260:	90                   	nop
  800261:	c9                   	leave  
  800262:	c3                   	ret    

00800263 <exit>:

void
exit(void)
{
  800263:	55                   	push   %ebp
  800264:	89 e5                	mov    %esp,%ebp
  800266:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800269:	e8 06 1a 00 00       	call   801c74 <sys_exit_env>
}
  80026e:	90                   	nop
  80026f:	c9                   	leave  
  800270:	c3                   	ret    

00800271 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800271:	55                   	push   %ebp
  800272:	89 e5                	mov    %esp,%ebp
  800274:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800277:	8d 45 10             	lea    0x10(%ebp),%eax
  80027a:	83 c0 04             	add    $0x4,%eax
  80027d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800280:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800285:	85 c0                	test   %eax,%eax
  800287:	74 16                	je     80029f <_panic+0x2e>
		cprintf("%s: ", argv0);
  800289:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	50                   	push   %eax
  800292:	68 78 34 80 00       	push   $0x803478
  800297:	e8 89 02 00 00       	call   800525 <cprintf>
  80029c:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80029f:	a1 00 40 80 00       	mov    0x804000,%eax
  8002a4:	ff 75 0c             	pushl  0xc(%ebp)
  8002a7:	ff 75 08             	pushl  0x8(%ebp)
  8002aa:	50                   	push   %eax
  8002ab:	68 7d 34 80 00       	push   $0x80347d
  8002b0:	e8 70 02 00 00       	call   800525 <cprintf>
  8002b5:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8002b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bb:	83 ec 08             	sub    $0x8,%esp
  8002be:	ff 75 f4             	pushl  -0xc(%ebp)
  8002c1:	50                   	push   %eax
  8002c2:	e8 f3 01 00 00       	call   8004ba <vcprintf>
  8002c7:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8002ca:	83 ec 08             	sub    $0x8,%esp
  8002cd:	6a 00                	push   $0x0
  8002cf:	68 99 34 80 00       	push   $0x803499
  8002d4:	e8 e1 01 00 00       	call   8004ba <vcprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8002dc:	e8 82 ff ff ff       	call   800263 <exit>

	// should not return here
	while (1) ;
  8002e1:	eb fe                	jmp    8002e1 <_panic+0x70>

008002e3 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8002e3:	55                   	push   %ebp
  8002e4:	89 e5                	mov    %esp,%ebp
  8002e6:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8002e9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ee:	8b 50 74             	mov    0x74(%eax),%edx
  8002f1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f4:	39 c2                	cmp    %eax,%edx
  8002f6:	74 14                	je     80030c <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8002f8:	83 ec 04             	sub    $0x4,%esp
  8002fb:	68 9c 34 80 00       	push   $0x80349c
  800300:	6a 26                	push   $0x26
  800302:	68 e8 34 80 00       	push   $0x8034e8
  800307:	e8 65 ff ff ff       	call   800271 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80030c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800313:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80031a:	e9 c2 00 00 00       	jmp    8003e1 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80031f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800322:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800329:	8b 45 08             	mov    0x8(%ebp),%eax
  80032c:	01 d0                	add    %edx,%eax
  80032e:	8b 00                	mov    (%eax),%eax
  800330:	85 c0                	test   %eax,%eax
  800332:	75 08                	jne    80033c <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800334:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800337:	e9 a2 00 00 00       	jmp    8003de <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80033c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800343:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80034a:	eb 69                	jmp    8003b5 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80034c:	a1 20 40 80 00       	mov    0x804020,%eax
  800351:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800357:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80035a:	89 d0                	mov    %edx,%eax
  80035c:	01 c0                	add    %eax,%eax
  80035e:	01 d0                	add    %edx,%eax
  800360:	c1 e0 03             	shl    $0x3,%eax
  800363:	01 c8                	add    %ecx,%eax
  800365:	8a 40 04             	mov    0x4(%eax),%al
  800368:	84 c0                	test   %al,%al
  80036a:	75 46                	jne    8003b2 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80036c:	a1 20 40 80 00       	mov    0x804020,%eax
  800371:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800377:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80037a:	89 d0                	mov    %edx,%eax
  80037c:	01 c0                	add    %eax,%eax
  80037e:	01 d0                	add    %edx,%eax
  800380:	c1 e0 03             	shl    $0x3,%eax
  800383:	01 c8                	add    %ecx,%eax
  800385:	8b 00                	mov    (%eax),%eax
  800387:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80038a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80038d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800392:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800394:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800397:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039e:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a1:	01 c8                	add    %ecx,%eax
  8003a3:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8003a5:	39 c2                	cmp    %eax,%edx
  8003a7:	75 09                	jne    8003b2 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8003a9:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8003b0:	eb 12                	jmp    8003c4 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003b2:	ff 45 e8             	incl   -0x18(%ebp)
  8003b5:	a1 20 40 80 00       	mov    0x804020,%eax
  8003ba:	8b 50 74             	mov    0x74(%eax),%edx
  8003bd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003c0:	39 c2                	cmp    %eax,%edx
  8003c2:	77 88                	ja     80034c <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8003c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8003c8:	75 14                	jne    8003de <CheckWSWithoutLastIndex+0xfb>
			panic(
  8003ca:	83 ec 04             	sub    $0x4,%esp
  8003cd:	68 f4 34 80 00       	push   $0x8034f4
  8003d2:	6a 3a                	push   $0x3a
  8003d4:	68 e8 34 80 00       	push   $0x8034e8
  8003d9:	e8 93 fe ff ff       	call   800271 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8003de:	ff 45 f0             	incl   -0x10(%ebp)
  8003e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8003e7:	0f 8c 32 ff ff ff    	jl     80031f <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8003ed:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8003fb:	eb 26                	jmp    800423 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8003fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800402:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800408:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80040b:	89 d0                	mov    %edx,%eax
  80040d:	01 c0                	add    %eax,%eax
  80040f:	01 d0                	add    %edx,%eax
  800411:	c1 e0 03             	shl    $0x3,%eax
  800414:	01 c8                	add    %ecx,%eax
  800416:	8a 40 04             	mov    0x4(%eax),%al
  800419:	3c 01                	cmp    $0x1,%al
  80041b:	75 03                	jne    800420 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80041d:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800420:	ff 45 e0             	incl   -0x20(%ebp)
  800423:	a1 20 40 80 00       	mov    0x804020,%eax
  800428:	8b 50 74             	mov    0x74(%eax),%edx
  80042b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042e:	39 c2                	cmp    %eax,%edx
  800430:	77 cb                	ja     8003fd <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800432:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800435:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800438:	74 14                	je     80044e <CheckWSWithoutLastIndex+0x16b>
		panic(
  80043a:	83 ec 04             	sub    $0x4,%esp
  80043d:	68 48 35 80 00       	push   $0x803548
  800442:	6a 44                	push   $0x44
  800444:	68 e8 34 80 00       	push   $0x8034e8
  800449:	e8 23 fe ff ff       	call   800271 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80044e:	90                   	nop
  80044f:	c9                   	leave  
  800450:	c3                   	ret    

00800451 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800451:	55                   	push   %ebp
  800452:	89 e5                	mov    %esp,%ebp
  800454:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800457:	8b 45 0c             	mov    0xc(%ebp),%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	8d 48 01             	lea    0x1(%eax),%ecx
  80045f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800462:	89 0a                	mov    %ecx,(%edx)
  800464:	8b 55 08             	mov    0x8(%ebp),%edx
  800467:	88 d1                	mov    %dl,%cl
  800469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80046c:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800470:	8b 45 0c             	mov    0xc(%ebp),%eax
  800473:	8b 00                	mov    (%eax),%eax
  800475:	3d ff 00 00 00       	cmp    $0xff,%eax
  80047a:	75 2c                	jne    8004a8 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80047c:	a0 24 40 80 00       	mov    0x804024,%al
  800481:	0f b6 c0             	movzbl %al,%eax
  800484:	8b 55 0c             	mov    0xc(%ebp),%edx
  800487:	8b 12                	mov    (%edx),%edx
  800489:	89 d1                	mov    %edx,%ecx
  80048b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80048e:	83 c2 08             	add    $0x8,%edx
  800491:	83 ec 04             	sub    $0x4,%esp
  800494:	50                   	push   %eax
  800495:	51                   	push   %ecx
  800496:	52                   	push   %edx
  800497:	e8 05 14 00 00       	call   8018a1 <sys_cputs>
  80049c:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80049f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8004a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ab:	8b 40 04             	mov    0x4(%eax),%eax
  8004ae:	8d 50 01             	lea    0x1(%eax),%edx
  8004b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004b4:	89 50 04             	mov    %edx,0x4(%eax)
}
  8004b7:	90                   	nop
  8004b8:	c9                   	leave  
  8004b9:	c3                   	ret    

008004ba <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8004ba:	55                   	push   %ebp
  8004bb:	89 e5                	mov    %esp,%ebp
  8004bd:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8004c3:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8004ca:	00 00 00 
	b.cnt = 0;
  8004cd:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8004d4:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8004d7:	ff 75 0c             	pushl  0xc(%ebp)
  8004da:	ff 75 08             	pushl  0x8(%ebp)
  8004dd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8004e3:	50                   	push   %eax
  8004e4:	68 51 04 80 00       	push   $0x800451
  8004e9:	e8 11 02 00 00       	call   8006ff <vprintfmt>
  8004ee:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8004f1:	a0 24 40 80 00       	mov    0x804024,%al
  8004f6:	0f b6 c0             	movzbl %al,%eax
  8004f9:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	50                   	push   %eax
  800503:	52                   	push   %edx
  800504:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80050a:	83 c0 08             	add    $0x8,%eax
  80050d:	50                   	push   %eax
  80050e:	e8 8e 13 00 00       	call   8018a1 <sys_cputs>
  800513:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800516:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80051d:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800523:	c9                   	leave  
  800524:	c3                   	ret    

00800525 <cprintf>:

int cprintf(const char *fmt, ...) {
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80052b:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800532:	8d 45 0c             	lea    0xc(%ebp),%eax
  800535:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800538:	8b 45 08             	mov    0x8(%ebp),%eax
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	ff 75 f4             	pushl  -0xc(%ebp)
  800541:	50                   	push   %eax
  800542:	e8 73 ff ff ff       	call   8004ba <vcprintf>
  800547:	83 c4 10             	add    $0x10,%esp
  80054a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80054d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800550:	c9                   	leave  
  800551:	c3                   	ret    

00800552 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800552:	55                   	push   %ebp
  800553:	89 e5                	mov    %esp,%ebp
  800555:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800558:	e8 f2 14 00 00       	call   801a4f <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80055d:	8d 45 0c             	lea    0xc(%ebp),%eax
  800560:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800563:	8b 45 08             	mov    0x8(%ebp),%eax
  800566:	83 ec 08             	sub    $0x8,%esp
  800569:	ff 75 f4             	pushl  -0xc(%ebp)
  80056c:	50                   	push   %eax
  80056d:	e8 48 ff ff ff       	call   8004ba <vcprintf>
  800572:	83 c4 10             	add    $0x10,%esp
  800575:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800578:	e8 ec 14 00 00       	call   801a69 <sys_enable_interrupt>
	return cnt;
  80057d:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800580:	c9                   	leave  
  800581:	c3                   	ret    

00800582 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800582:	55                   	push   %ebp
  800583:	89 e5                	mov    %esp,%ebp
  800585:	53                   	push   %ebx
  800586:	83 ec 14             	sub    $0x14,%esp
  800589:	8b 45 10             	mov    0x10(%ebp),%eax
  80058c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80058f:	8b 45 14             	mov    0x14(%ebp),%eax
  800592:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800595:	8b 45 18             	mov    0x18(%ebp),%eax
  800598:	ba 00 00 00 00       	mov    $0x0,%edx
  80059d:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a0:	77 55                	ja     8005f7 <printnum+0x75>
  8005a2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8005a5:	72 05                	jb     8005ac <printnum+0x2a>
  8005a7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8005aa:	77 4b                	ja     8005f7 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8005ac:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8005af:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8005b2:	8b 45 18             	mov    0x18(%ebp),%eax
  8005b5:	ba 00 00 00 00       	mov    $0x0,%edx
  8005ba:	52                   	push   %edx
  8005bb:	50                   	push   %eax
  8005bc:	ff 75 f4             	pushl  -0xc(%ebp)
  8005bf:	ff 75 f0             	pushl  -0x10(%ebp)
  8005c2:	e8 65 2a 00 00       	call   80302c <__udivdi3>
  8005c7:	83 c4 10             	add    $0x10,%esp
  8005ca:	83 ec 04             	sub    $0x4,%esp
  8005cd:	ff 75 20             	pushl  0x20(%ebp)
  8005d0:	53                   	push   %ebx
  8005d1:	ff 75 18             	pushl  0x18(%ebp)
  8005d4:	52                   	push   %edx
  8005d5:	50                   	push   %eax
  8005d6:	ff 75 0c             	pushl  0xc(%ebp)
  8005d9:	ff 75 08             	pushl  0x8(%ebp)
  8005dc:	e8 a1 ff ff ff       	call   800582 <printnum>
  8005e1:	83 c4 20             	add    $0x20,%esp
  8005e4:	eb 1a                	jmp    800600 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8005e6:	83 ec 08             	sub    $0x8,%esp
  8005e9:	ff 75 0c             	pushl  0xc(%ebp)
  8005ec:	ff 75 20             	pushl  0x20(%ebp)
  8005ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f2:	ff d0                	call   *%eax
  8005f4:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8005f7:	ff 4d 1c             	decl   0x1c(%ebp)
  8005fa:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8005fe:	7f e6                	jg     8005e6 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800600:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800603:	bb 00 00 00 00       	mov    $0x0,%ebx
  800608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80060e:	53                   	push   %ebx
  80060f:	51                   	push   %ecx
  800610:	52                   	push   %edx
  800611:	50                   	push   %eax
  800612:	e8 25 2b 00 00       	call   80313c <__umoddi3>
  800617:	83 c4 10             	add    $0x10,%esp
  80061a:	05 b4 37 80 00       	add    $0x8037b4,%eax
  80061f:	8a 00                	mov    (%eax),%al
  800621:	0f be c0             	movsbl %al,%eax
  800624:	83 ec 08             	sub    $0x8,%esp
  800627:	ff 75 0c             	pushl  0xc(%ebp)
  80062a:	50                   	push   %eax
  80062b:	8b 45 08             	mov    0x8(%ebp),%eax
  80062e:	ff d0                	call   *%eax
  800630:	83 c4 10             	add    $0x10,%esp
}
  800633:	90                   	nop
  800634:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800637:	c9                   	leave  
  800638:	c3                   	ret    

00800639 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800639:	55                   	push   %ebp
  80063a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80063c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800640:	7e 1c                	jle    80065e <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800642:	8b 45 08             	mov    0x8(%ebp),%eax
  800645:	8b 00                	mov    (%eax),%eax
  800647:	8d 50 08             	lea    0x8(%eax),%edx
  80064a:	8b 45 08             	mov    0x8(%ebp),%eax
  80064d:	89 10                	mov    %edx,(%eax)
  80064f:	8b 45 08             	mov    0x8(%ebp),%eax
  800652:	8b 00                	mov    (%eax),%eax
  800654:	83 e8 08             	sub    $0x8,%eax
  800657:	8b 50 04             	mov    0x4(%eax),%edx
  80065a:	8b 00                	mov    (%eax),%eax
  80065c:	eb 40                	jmp    80069e <getuint+0x65>
	else if (lflag)
  80065e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800662:	74 1e                	je     800682 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	8b 00                	mov    (%eax),%eax
  800669:	8d 50 04             	lea    0x4(%eax),%edx
  80066c:	8b 45 08             	mov    0x8(%ebp),%eax
  80066f:	89 10                	mov    %edx,(%eax)
  800671:	8b 45 08             	mov    0x8(%ebp),%eax
  800674:	8b 00                	mov    (%eax),%eax
  800676:	83 e8 04             	sub    $0x4,%eax
  800679:	8b 00                	mov    (%eax),%eax
  80067b:	ba 00 00 00 00       	mov    $0x0,%edx
  800680:	eb 1c                	jmp    80069e <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	8b 00                	mov    (%eax),%eax
  800687:	8d 50 04             	lea    0x4(%eax),%edx
  80068a:	8b 45 08             	mov    0x8(%ebp),%eax
  80068d:	89 10                	mov    %edx,(%eax)
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	8b 00                	mov    (%eax),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 00                	mov    (%eax),%eax
  800699:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80069e:	5d                   	pop    %ebp
  80069f:	c3                   	ret    

008006a0 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8006a0:	55                   	push   %ebp
  8006a1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006a3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006a7:	7e 1c                	jle    8006c5 <getint+0x25>
		return va_arg(*ap, long long);
  8006a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ac:	8b 00                	mov    (%eax),%eax
  8006ae:	8d 50 08             	lea    0x8(%eax),%edx
  8006b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b4:	89 10                	mov    %edx,(%eax)
  8006b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b9:	8b 00                	mov    (%eax),%eax
  8006bb:	83 e8 08             	sub    $0x8,%eax
  8006be:	8b 50 04             	mov    0x4(%eax),%edx
  8006c1:	8b 00                	mov    (%eax),%eax
  8006c3:	eb 38                	jmp    8006fd <getint+0x5d>
	else if (lflag)
  8006c5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8006c9:	74 1a                	je     8006e5 <getint+0x45>
		return va_arg(*ap, long);
  8006cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ce:	8b 00                	mov    (%eax),%eax
  8006d0:	8d 50 04             	lea    0x4(%eax),%edx
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	89 10                	mov    %edx,(%eax)
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	8b 00                	mov    (%eax),%eax
  8006dd:	83 e8 04             	sub    $0x4,%eax
  8006e0:	8b 00                	mov    (%eax),%eax
  8006e2:	99                   	cltd   
  8006e3:	eb 18                	jmp    8006fd <getint+0x5d>
	else
		return va_arg(*ap, int);
  8006e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e8:	8b 00                	mov    (%eax),%eax
  8006ea:	8d 50 04             	lea    0x4(%eax),%edx
  8006ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f0:	89 10                	mov    %edx,(%eax)
  8006f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f5:	8b 00                	mov    (%eax),%eax
  8006f7:	83 e8 04             	sub    $0x4,%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	99                   	cltd   
}
  8006fd:	5d                   	pop    %ebp
  8006fe:	c3                   	ret    

008006ff <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8006ff:	55                   	push   %ebp
  800700:	89 e5                	mov    %esp,%ebp
  800702:	56                   	push   %esi
  800703:	53                   	push   %ebx
  800704:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800707:	eb 17                	jmp    800720 <vprintfmt+0x21>
			if (ch == '\0')
  800709:	85 db                	test   %ebx,%ebx
  80070b:	0f 84 af 03 00 00    	je     800ac0 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800711:	83 ec 08             	sub    $0x8,%esp
  800714:	ff 75 0c             	pushl  0xc(%ebp)
  800717:	53                   	push   %ebx
  800718:	8b 45 08             	mov    0x8(%ebp),%eax
  80071b:	ff d0                	call   *%eax
  80071d:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800720:	8b 45 10             	mov    0x10(%ebp),%eax
  800723:	8d 50 01             	lea    0x1(%eax),%edx
  800726:	89 55 10             	mov    %edx,0x10(%ebp)
  800729:	8a 00                	mov    (%eax),%al
  80072b:	0f b6 d8             	movzbl %al,%ebx
  80072e:	83 fb 25             	cmp    $0x25,%ebx
  800731:	75 d6                	jne    800709 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800733:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800737:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80073e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800745:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80074c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800753:	8b 45 10             	mov    0x10(%ebp),%eax
  800756:	8d 50 01             	lea    0x1(%eax),%edx
  800759:	89 55 10             	mov    %edx,0x10(%ebp)
  80075c:	8a 00                	mov    (%eax),%al
  80075e:	0f b6 d8             	movzbl %al,%ebx
  800761:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800764:	83 f8 55             	cmp    $0x55,%eax
  800767:	0f 87 2b 03 00 00    	ja     800a98 <vprintfmt+0x399>
  80076d:	8b 04 85 d8 37 80 00 	mov    0x8037d8(,%eax,4),%eax
  800774:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800776:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80077a:	eb d7                	jmp    800753 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80077c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800780:	eb d1                	jmp    800753 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800782:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800789:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80078c:	89 d0                	mov    %edx,%eax
  80078e:	c1 e0 02             	shl    $0x2,%eax
  800791:	01 d0                	add    %edx,%eax
  800793:	01 c0                	add    %eax,%eax
  800795:	01 d8                	add    %ebx,%eax
  800797:	83 e8 30             	sub    $0x30,%eax
  80079a:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  80079d:	8b 45 10             	mov    0x10(%ebp),%eax
  8007a0:	8a 00                	mov    (%eax),%al
  8007a2:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8007a5:	83 fb 2f             	cmp    $0x2f,%ebx
  8007a8:	7e 3e                	jle    8007e8 <vprintfmt+0xe9>
  8007aa:	83 fb 39             	cmp    $0x39,%ebx
  8007ad:	7f 39                	jg     8007e8 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8007af:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8007b2:	eb d5                	jmp    800789 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8007b4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007b7:	83 c0 04             	add    $0x4,%eax
  8007ba:	89 45 14             	mov    %eax,0x14(%ebp)
  8007bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8007c8:	eb 1f                	jmp    8007e9 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8007ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ce:	79 83                	jns    800753 <vprintfmt+0x54>
				width = 0;
  8007d0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8007d7:	e9 77 ff ff ff       	jmp    800753 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8007dc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8007e3:	e9 6b ff ff ff       	jmp    800753 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8007e8:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8007e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007ed:	0f 89 60 ff ff ff    	jns    800753 <vprintfmt+0x54>
				width = precision, precision = -1;
  8007f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007f6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8007f9:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800800:	e9 4e ff ff ff       	jmp    800753 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800805:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800808:	e9 46 ff ff ff       	jmp    800753 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80080d:	8b 45 14             	mov    0x14(%ebp),%eax
  800810:	83 c0 04             	add    $0x4,%eax
  800813:	89 45 14             	mov    %eax,0x14(%ebp)
  800816:	8b 45 14             	mov    0x14(%ebp),%eax
  800819:	83 e8 04             	sub    $0x4,%eax
  80081c:	8b 00                	mov    (%eax),%eax
  80081e:	83 ec 08             	sub    $0x8,%esp
  800821:	ff 75 0c             	pushl  0xc(%ebp)
  800824:	50                   	push   %eax
  800825:	8b 45 08             	mov    0x8(%ebp),%eax
  800828:	ff d0                	call   *%eax
  80082a:	83 c4 10             	add    $0x10,%esp
			break;
  80082d:	e9 89 02 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800832:	8b 45 14             	mov    0x14(%ebp),%eax
  800835:	83 c0 04             	add    $0x4,%eax
  800838:	89 45 14             	mov    %eax,0x14(%ebp)
  80083b:	8b 45 14             	mov    0x14(%ebp),%eax
  80083e:	83 e8 04             	sub    $0x4,%eax
  800841:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800843:	85 db                	test   %ebx,%ebx
  800845:	79 02                	jns    800849 <vprintfmt+0x14a>
				err = -err;
  800847:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800849:	83 fb 64             	cmp    $0x64,%ebx
  80084c:	7f 0b                	jg     800859 <vprintfmt+0x15a>
  80084e:	8b 34 9d 20 36 80 00 	mov    0x803620(,%ebx,4),%esi
  800855:	85 f6                	test   %esi,%esi
  800857:	75 19                	jne    800872 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800859:	53                   	push   %ebx
  80085a:	68 c5 37 80 00       	push   $0x8037c5
  80085f:	ff 75 0c             	pushl  0xc(%ebp)
  800862:	ff 75 08             	pushl  0x8(%ebp)
  800865:	e8 5e 02 00 00       	call   800ac8 <printfmt>
  80086a:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80086d:	e9 49 02 00 00       	jmp    800abb <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800872:	56                   	push   %esi
  800873:	68 ce 37 80 00       	push   $0x8037ce
  800878:	ff 75 0c             	pushl  0xc(%ebp)
  80087b:	ff 75 08             	pushl  0x8(%ebp)
  80087e:	e8 45 02 00 00       	call   800ac8 <printfmt>
  800883:	83 c4 10             	add    $0x10,%esp
			break;
  800886:	e9 30 02 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80088b:	8b 45 14             	mov    0x14(%ebp),%eax
  80088e:	83 c0 04             	add    $0x4,%eax
  800891:	89 45 14             	mov    %eax,0x14(%ebp)
  800894:	8b 45 14             	mov    0x14(%ebp),%eax
  800897:	83 e8 04             	sub    $0x4,%eax
  80089a:	8b 30                	mov    (%eax),%esi
  80089c:	85 f6                	test   %esi,%esi
  80089e:	75 05                	jne    8008a5 <vprintfmt+0x1a6>
				p = "(null)";
  8008a0:	be d1 37 80 00       	mov    $0x8037d1,%esi
			if (width > 0 && padc != '-')
  8008a5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a9:	7e 6d                	jle    800918 <vprintfmt+0x219>
  8008ab:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8008af:	74 67                	je     800918 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8008b1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008b4:	83 ec 08             	sub    $0x8,%esp
  8008b7:	50                   	push   %eax
  8008b8:	56                   	push   %esi
  8008b9:	e8 0c 03 00 00       	call   800bca <strnlen>
  8008be:	83 c4 10             	add    $0x10,%esp
  8008c1:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8008c4:	eb 16                	jmp    8008dc <vprintfmt+0x1dd>
					putch(padc, putdat);
  8008c6:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8008ca:	83 ec 08             	sub    $0x8,%esp
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	50                   	push   %eax
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	ff d0                	call   *%eax
  8008d6:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8008d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8008dc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e0:	7f e4                	jg     8008c6 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8008e2:	eb 34                	jmp    800918 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8008e4:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8008e8:	74 1c                	je     800906 <vprintfmt+0x207>
  8008ea:	83 fb 1f             	cmp    $0x1f,%ebx
  8008ed:	7e 05                	jle    8008f4 <vprintfmt+0x1f5>
  8008ef:	83 fb 7e             	cmp    $0x7e,%ebx
  8008f2:	7e 12                	jle    800906 <vprintfmt+0x207>
					putch('?', putdat);
  8008f4:	83 ec 08             	sub    $0x8,%esp
  8008f7:	ff 75 0c             	pushl  0xc(%ebp)
  8008fa:	6a 3f                	push   $0x3f
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	ff d0                	call   *%eax
  800901:	83 c4 10             	add    $0x10,%esp
  800904:	eb 0f                	jmp    800915 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800906:	83 ec 08             	sub    $0x8,%esp
  800909:	ff 75 0c             	pushl  0xc(%ebp)
  80090c:	53                   	push   %ebx
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	ff d0                	call   *%eax
  800912:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800915:	ff 4d e4             	decl   -0x1c(%ebp)
  800918:	89 f0                	mov    %esi,%eax
  80091a:	8d 70 01             	lea    0x1(%eax),%esi
  80091d:	8a 00                	mov    (%eax),%al
  80091f:	0f be d8             	movsbl %al,%ebx
  800922:	85 db                	test   %ebx,%ebx
  800924:	74 24                	je     80094a <vprintfmt+0x24b>
  800926:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80092a:	78 b8                	js     8008e4 <vprintfmt+0x1e5>
  80092c:	ff 4d e0             	decl   -0x20(%ebp)
  80092f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800933:	79 af                	jns    8008e4 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800935:	eb 13                	jmp    80094a <vprintfmt+0x24b>
				putch(' ', putdat);
  800937:	83 ec 08             	sub    $0x8,%esp
  80093a:	ff 75 0c             	pushl  0xc(%ebp)
  80093d:	6a 20                	push   $0x20
  80093f:	8b 45 08             	mov    0x8(%ebp),%eax
  800942:	ff d0                	call   *%eax
  800944:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800947:	ff 4d e4             	decl   -0x1c(%ebp)
  80094a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80094e:	7f e7                	jg     800937 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800950:	e9 66 01 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800955:	83 ec 08             	sub    $0x8,%esp
  800958:	ff 75 e8             	pushl  -0x18(%ebp)
  80095b:	8d 45 14             	lea    0x14(%ebp),%eax
  80095e:	50                   	push   %eax
  80095f:	e8 3c fd ff ff       	call   8006a0 <getint>
  800964:	83 c4 10             	add    $0x10,%esp
  800967:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80096d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800970:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800973:	85 d2                	test   %edx,%edx
  800975:	79 23                	jns    80099a <vprintfmt+0x29b>
				putch('-', putdat);
  800977:	83 ec 08             	sub    $0x8,%esp
  80097a:	ff 75 0c             	pushl  0xc(%ebp)
  80097d:	6a 2d                	push   $0x2d
  80097f:	8b 45 08             	mov    0x8(%ebp),%eax
  800982:	ff d0                	call   *%eax
  800984:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800987:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80098a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80098d:	f7 d8                	neg    %eax
  80098f:	83 d2 00             	adc    $0x0,%edx
  800992:	f7 da                	neg    %edx
  800994:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800997:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  80099a:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009a1:	e9 bc 00 00 00       	jmp    800a62 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8009a6:	83 ec 08             	sub    $0x8,%esp
  8009a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8009ac:	8d 45 14             	lea    0x14(%ebp),%eax
  8009af:	50                   	push   %eax
  8009b0:	e8 84 fc ff ff       	call   800639 <getuint>
  8009b5:	83 c4 10             	add    $0x10,%esp
  8009b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8009bb:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8009be:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8009c5:	e9 98 00 00 00       	jmp    800a62 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	6a 58                	push   $0x58
  8009d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d5:	ff d0                	call   *%eax
  8009d7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009da:	83 ec 08             	sub    $0x8,%esp
  8009dd:	ff 75 0c             	pushl  0xc(%ebp)
  8009e0:	6a 58                	push   $0x58
  8009e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e5:	ff d0                	call   *%eax
  8009e7:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  8009ea:	83 ec 08             	sub    $0x8,%esp
  8009ed:	ff 75 0c             	pushl  0xc(%ebp)
  8009f0:	6a 58                	push   $0x58
  8009f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f5:	ff d0                	call   *%eax
  8009f7:	83 c4 10             	add    $0x10,%esp
			break;
  8009fa:	e9 bc 00 00 00       	jmp    800abb <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	6a 30                	push   $0x30
  800a07:	8b 45 08             	mov    0x8(%ebp),%eax
  800a0a:	ff d0                	call   *%eax
  800a0c:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800a0f:	83 ec 08             	sub    $0x8,%esp
  800a12:	ff 75 0c             	pushl  0xc(%ebp)
  800a15:	6a 78                	push   $0x78
  800a17:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1a:	ff d0                	call   *%eax
  800a1c:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800a1f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a22:	83 c0 04             	add    $0x4,%eax
  800a25:	89 45 14             	mov    %eax,0x14(%ebp)
  800a28:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2b:	83 e8 04             	sub    $0x4,%eax
  800a2e:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800a30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800a3a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800a41:	eb 1f                	jmp    800a62 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800a43:	83 ec 08             	sub    $0x8,%esp
  800a46:	ff 75 e8             	pushl  -0x18(%ebp)
  800a49:	8d 45 14             	lea    0x14(%ebp),%eax
  800a4c:	50                   	push   %eax
  800a4d:	e8 e7 fb ff ff       	call   800639 <getuint>
  800a52:	83 c4 10             	add    $0x10,%esp
  800a55:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a58:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800a5b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800a62:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800a66:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a69:	83 ec 04             	sub    $0x4,%esp
  800a6c:	52                   	push   %edx
  800a6d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800a70:	50                   	push   %eax
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	ff 75 f0             	pushl  -0x10(%ebp)
  800a77:	ff 75 0c             	pushl  0xc(%ebp)
  800a7a:	ff 75 08             	pushl  0x8(%ebp)
  800a7d:	e8 00 fb ff ff       	call   800582 <printnum>
  800a82:	83 c4 20             	add    $0x20,%esp
			break;
  800a85:	eb 34                	jmp    800abb <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800a87:	83 ec 08             	sub    $0x8,%esp
  800a8a:	ff 75 0c             	pushl  0xc(%ebp)
  800a8d:	53                   	push   %ebx
  800a8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a91:	ff d0                	call   *%eax
  800a93:	83 c4 10             	add    $0x10,%esp
			break;
  800a96:	eb 23                	jmp    800abb <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800a98:	83 ec 08             	sub    $0x8,%esp
  800a9b:	ff 75 0c             	pushl  0xc(%ebp)
  800a9e:	6a 25                	push   $0x25
  800aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa3:	ff d0                	call   *%eax
  800aa5:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800aa8:	ff 4d 10             	decl   0x10(%ebp)
  800aab:	eb 03                	jmp    800ab0 <vprintfmt+0x3b1>
  800aad:	ff 4d 10             	decl   0x10(%ebp)
  800ab0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ab3:	48                   	dec    %eax
  800ab4:	8a 00                	mov    (%eax),%al
  800ab6:	3c 25                	cmp    $0x25,%al
  800ab8:	75 f3                	jne    800aad <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800aba:	90                   	nop
		}
	}
  800abb:	e9 47 fc ff ff       	jmp    800707 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800ac0:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800ac1:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800ac4:	5b                   	pop    %ebx
  800ac5:	5e                   	pop    %esi
  800ac6:	5d                   	pop    %ebp
  800ac7:	c3                   	ret    

00800ac8 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800ac8:	55                   	push   %ebp
  800ac9:	89 e5                	mov    %esp,%ebp
  800acb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800ace:	8d 45 10             	lea    0x10(%ebp),%eax
  800ad1:	83 c0 04             	add    $0x4,%eax
  800ad4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800ad7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ada:	ff 75 f4             	pushl  -0xc(%ebp)
  800add:	50                   	push   %eax
  800ade:	ff 75 0c             	pushl  0xc(%ebp)
  800ae1:	ff 75 08             	pushl  0x8(%ebp)
  800ae4:	e8 16 fc ff ff       	call   8006ff <vprintfmt>
  800ae9:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800aec:	90                   	nop
  800aed:	c9                   	leave  
  800aee:	c3                   	ret    

00800aef <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800aef:	55                   	push   %ebp
  800af0:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800af2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af5:	8b 40 08             	mov    0x8(%eax),%eax
  800af8:	8d 50 01             	lea    0x1(%eax),%edx
  800afb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800afe:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800b01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b04:	8b 10                	mov    (%eax),%edx
  800b06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b09:	8b 40 04             	mov    0x4(%eax),%eax
  800b0c:	39 c2                	cmp    %eax,%edx
  800b0e:	73 12                	jae    800b22 <sprintputch+0x33>
		*b->buf++ = ch;
  800b10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b13:	8b 00                	mov    (%eax),%eax
  800b15:	8d 48 01             	lea    0x1(%eax),%ecx
  800b18:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b1b:	89 0a                	mov    %ecx,(%edx)
  800b1d:	8b 55 08             	mov    0x8(%ebp),%edx
  800b20:	88 10                	mov    %dl,(%eax)
}
  800b22:	90                   	nop
  800b23:	5d                   	pop    %ebp
  800b24:	c3                   	ret    

00800b25 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800b25:	55                   	push   %ebp
  800b26:	89 e5                	mov    %esp,%ebp
  800b28:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b34:	8d 50 ff             	lea    -0x1(%eax),%edx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	01 d0                	add    %edx,%eax
  800b3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b3f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800b46:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800b4a:	74 06                	je     800b52 <vsnprintf+0x2d>
  800b4c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b50:	7f 07                	jg     800b59 <vsnprintf+0x34>
		return -E_INVAL;
  800b52:	b8 03 00 00 00       	mov    $0x3,%eax
  800b57:	eb 20                	jmp    800b79 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800b59:	ff 75 14             	pushl  0x14(%ebp)
  800b5c:	ff 75 10             	pushl  0x10(%ebp)
  800b5f:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800b62:	50                   	push   %eax
  800b63:	68 ef 0a 80 00       	push   $0x800aef
  800b68:	e8 92 fb ff ff       	call   8006ff <vprintfmt>
  800b6d:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800b70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b73:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800b76:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800b79:	c9                   	leave  
  800b7a:	c3                   	ret    

00800b7b <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800b7b:	55                   	push   %ebp
  800b7c:	89 e5                	mov    %esp,%ebp
  800b7e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800b81:	8d 45 10             	lea    0x10(%ebp),%eax
  800b84:	83 c0 04             	add    $0x4,%eax
  800b87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800b8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8d:	ff 75 f4             	pushl  -0xc(%ebp)
  800b90:	50                   	push   %eax
  800b91:	ff 75 0c             	pushl  0xc(%ebp)
  800b94:	ff 75 08             	pushl  0x8(%ebp)
  800b97:	e8 89 ff ff ff       	call   800b25 <vsnprintf>
  800b9c:	83 c4 10             	add    $0x10,%esp
  800b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ba2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ba5:	c9                   	leave  
  800ba6:	c3                   	ret    

00800ba7 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ba7:	55                   	push   %ebp
  800ba8:	89 e5                	mov    %esp,%ebp
  800baa:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800bad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bb4:	eb 06                	jmp    800bbc <strlen+0x15>
		n++;
  800bb6:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800bb9:	ff 45 08             	incl   0x8(%ebp)
  800bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbf:	8a 00                	mov    (%eax),%al
  800bc1:	84 c0                	test   %al,%al
  800bc3:	75 f1                	jne    800bb6 <strlen+0xf>
		n++;
	return n;
  800bc5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bc8:	c9                   	leave  
  800bc9:	c3                   	ret    

00800bca <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800bca:	55                   	push   %ebp
  800bcb:	89 e5                	mov    %esp,%ebp
  800bcd:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bd0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800bd7:	eb 09                	jmp    800be2 <strnlen+0x18>
		n++;
  800bd9:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800bdc:	ff 45 08             	incl   0x8(%ebp)
  800bdf:	ff 4d 0c             	decl   0xc(%ebp)
  800be2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800be6:	74 09                	je     800bf1 <strnlen+0x27>
  800be8:	8b 45 08             	mov    0x8(%ebp),%eax
  800beb:	8a 00                	mov    (%eax),%al
  800bed:	84 c0                	test   %al,%al
  800bef:	75 e8                	jne    800bd9 <strnlen+0xf>
		n++;
	return n;
  800bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bf4:	c9                   	leave  
  800bf5:	c3                   	ret    

00800bf6 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800bf6:	55                   	push   %ebp
  800bf7:	89 e5                	mov    %esp,%ebp
  800bf9:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800c02:	90                   	nop
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	8d 50 01             	lea    0x1(%eax),%edx
  800c09:	89 55 08             	mov    %edx,0x8(%ebp)
  800c0c:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0f:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c12:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c15:	8a 12                	mov    (%edx),%dl
  800c17:	88 10                	mov    %dl,(%eax)
  800c19:	8a 00                	mov    (%eax),%al
  800c1b:	84 c0                	test   %al,%al
  800c1d:	75 e4                	jne    800c03 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800c1f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c22:	c9                   	leave  
  800c23:	c3                   	ret    

00800c24 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800c24:	55                   	push   %ebp
  800c25:	89 e5                	mov    %esp,%ebp
  800c27:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800c30:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c37:	eb 1f                	jmp    800c58 <strncpy+0x34>
		*dst++ = *src;
  800c39:	8b 45 08             	mov    0x8(%ebp),%eax
  800c3c:	8d 50 01             	lea    0x1(%eax),%edx
  800c3f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c42:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c45:	8a 12                	mov    (%edx),%dl
  800c47:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800c49:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c4c:	8a 00                	mov    (%eax),%al
  800c4e:	84 c0                	test   %al,%al
  800c50:	74 03                	je     800c55 <strncpy+0x31>
			src++;
  800c52:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800c55:	ff 45 fc             	incl   -0x4(%ebp)
  800c58:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c5b:	3b 45 10             	cmp    0x10(%ebp),%eax
  800c5e:	72 d9                	jb     800c39 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800c60:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
  800c68:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800c6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800c71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c75:	74 30                	je     800ca7 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800c77:	eb 16                	jmp    800c8f <strlcpy+0x2a>
			*dst++ = *src++;
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	8d 50 01             	lea    0x1(%eax),%edx
  800c7f:	89 55 08             	mov    %edx,0x8(%ebp)
  800c82:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c85:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c88:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800c8b:	8a 12                	mov    (%edx),%dl
  800c8d:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800c8f:	ff 4d 10             	decl   0x10(%ebp)
  800c92:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c96:	74 09                	je     800ca1 <strlcpy+0x3c>
  800c98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9b:	8a 00                	mov    (%eax),%al
  800c9d:	84 c0                	test   %al,%al
  800c9f:	75 d8                	jne    800c79 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ca1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca4:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ca7:	8b 55 08             	mov    0x8(%ebp),%edx
  800caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cad:	29 c2                	sub    %eax,%edx
  800caf:	89 d0                	mov    %edx,%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800cb6:	eb 06                	jmp    800cbe <strcmp+0xb>
		p++, q++;
  800cb8:	ff 45 08             	incl   0x8(%ebp)
  800cbb:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8a 00                	mov    (%eax),%al
  800cc3:	84 c0                	test   %al,%al
  800cc5:	74 0e                	je     800cd5 <strcmp+0x22>
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8a 10                	mov    (%eax),%dl
  800ccc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ccf:	8a 00                	mov    (%eax),%al
  800cd1:	38 c2                	cmp    %al,%dl
  800cd3:	74 e3                	je     800cb8 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8a 00                	mov    (%eax),%al
  800cda:	0f b6 d0             	movzbl %al,%edx
  800cdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce0:	8a 00                	mov    (%eax),%al
  800ce2:	0f b6 c0             	movzbl %al,%eax
  800ce5:	29 c2                	sub    %eax,%edx
  800ce7:	89 d0                	mov    %edx,%eax
}
  800ce9:	5d                   	pop    %ebp
  800cea:	c3                   	ret    

00800ceb <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800ceb:	55                   	push   %ebp
  800cec:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800cee:	eb 09                	jmp    800cf9 <strncmp+0xe>
		n--, p++, q++;
  800cf0:	ff 4d 10             	decl   0x10(%ebp)
  800cf3:	ff 45 08             	incl   0x8(%ebp)
  800cf6:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800cf9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfd:	74 17                	je     800d16 <strncmp+0x2b>
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	8a 00                	mov    (%eax),%al
  800d04:	84 c0                	test   %al,%al
  800d06:	74 0e                	je     800d16 <strncmp+0x2b>
  800d08:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0b:	8a 10                	mov    (%eax),%dl
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	38 c2                	cmp    %al,%dl
  800d14:	74 da                	je     800cf0 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800d16:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1a:	75 07                	jne    800d23 <strncmp+0x38>
		return 0;
  800d1c:	b8 00 00 00 00       	mov    $0x0,%eax
  800d21:	eb 14                	jmp    800d37 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	8a 00                	mov    (%eax),%al
  800d28:	0f b6 d0             	movzbl %al,%edx
  800d2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2e:	8a 00                	mov    (%eax),%al
  800d30:	0f b6 c0             	movzbl %al,%eax
  800d33:	29 c2                	sub    %eax,%edx
  800d35:	89 d0                	mov    %edx,%eax
}
  800d37:	5d                   	pop    %ebp
  800d38:	c3                   	ret    

00800d39 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800d39:	55                   	push   %ebp
  800d3a:	89 e5                	mov    %esp,%ebp
  800d3c:	83 ec 04             	sub    $0x4,%esp
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d45:	eb 12                	jmp    800d59 <strchr+0x20>
		if (*s == c)
  800d47:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4a:	8a 00                	mov    (%eax),%al
  800d4c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d4f:	75 05                	jne    800d56 <strchr+0x1d>
			return (char *) s;
  800d51:	8b 45 08             	mov    0x8(%ebp),%eax
  800d54:	eb 11                	jmp    800d67 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800d56:	ff 45 08             	incl   0x8(%ebp)
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	8a 00                	mov    (%eax),%al
  800d5e:	84 c0                	test   %al,%al
  800d60:	75 e5                	jne    800d47 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800d62:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d67:	c9                   	leave  
  800d68:	c3                   	ret    

00800d69 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800d69:	55                   	push   %ebp
  800d6a:	89 e5                	mov    %esp,%ebp
  800d6c:	83 ec 04             	sub    $0x4,%esp
  800d6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d72:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800d75:	eb 0d                	jmp    800d84 <strfind+0x1b>
		if (*s == c)
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d7f:	74 0e                	je     800d8f <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800d81:	ff 45 08             	incl   0x8(%ebp)
  800d84:	8b 45 08             	mov    0x8(%ebp),%eax
  800d87:	8a 00                	mov    (%eax),%al
  800d89:	84 c0                	test   %al,%al
  800d8b:	75 ea                	jne    800d77 <strfind+0xe>
  800d8d:	eb 01                	jmp    800d90 <strfind+0x27>
		if (*s == c)
			break;
  800d8f:	90                   	nop
	return (char *) s;
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d93:	c9                   	leave  
  800d94:	c3                   	ret    

00800d95 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800d95:	55                   	push   %ebp
  800d96:	89 e5                	mov    %esp,%ebp
  800d98:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800d9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800da1:	8b 45 10             	mov    0x10(%ebp),%eax
  800da4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800da7:	eb 0e                	jmp    800db7 <memset+0x22>
		*p++ = c;
  800da9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dac:	8d 50 01             	lea    0x1(%eax),%edx
  800daf:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800db2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db5:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800db7:	ff 4d f8             	decl   -0x8(%ebp)
  800dba:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800dbe:	79 e9                	jns    800da9 <memset+0x14>
		*p++ = c;

	return v;
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dc3:	c9                   	leave  
  800dc4:	c3                   	ret    

00800dc5 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800dc5:	55                   	push   %ebp
  800dc6:	89 e5                	mov    %esp,%ebp
  800dc8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800dcb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dce:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800dd7:	eb 16                	jmp    800def <memcpy+0x2a>
		*d++ = *s++;
  800dd9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddc:	8d 50 01             	lea    0x1(%eax),%edx
  800ddf:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800de2:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800de5:	8d 4a 01             	lea    0x1(%edx),%ecx
  800de8:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800deb:	8a 12                	mov    (%edx),%dl
  800ded:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800def:	8b 45 10             	mov    0x10(%ebp),%eax
  800df2:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df5:	89 55 10             	mov    %edx,0x10(%ebp)
  800df8:	85 c0                	test   %eax,%eax
  800dfa:	75 dd                	jne    800dd9 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dff:	c9                   	leave  
  800e00:	c3                   	ret    

00800e01 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800e01:	55                   	push   %ebp
  800e02:	89 e5                	mov    %esp,%ebp
  800e04:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e07:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e10:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800e13:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e16:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e19:	73 50                	jae    800e6b <memmove+0x6a>
  800e1b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e1e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e21:	01 d0                	add    %edx,%eax
  800e23:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800e26:	76 43                	jbe    800e6b <memmove+0x6a>
		s += n;
  800e28:	8b 45 10             	mov    0x10(%ebp),%eax
  800e2b:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800e2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800e31:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800e34:	eb 10                	jmp    800e46 <memmove+0x45>
			*--d = *--s;
  800e36:	ff 4d f8             	decl   -0x8(%ebp)
  800e39:	ff 4d fc             	decl   -0x4(%ebp)
  800e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e3f:	8a 10                	mov    (%eax),%dl
  800e41:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e44:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800e46:	8b 45 10             	mov    0x10(%ebp),%eax
  800e49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800e4f:	85 c0                	test   %eax,%eax
  800e51:	75 e3                	jne    800e36 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800e53:	eb 23                	jmp    800e78 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800e55:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e58:	8d 50 01             	lea    0x1(%eax),%edx
  800e5b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e5e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e61:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e64:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800e67:	8a 12                	mov    (%edx),%dl
  800e69:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800e6b:	8b 45 10             	mov    0x10(%ebp),%eax
  800e6e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800e71:	89 55 10             	mov    %edx,0x10(%ebp)
  800e74:	85 c0                	test   %eax,%eax
  800e76:	75 dd                	jne    800e55 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e7b:	c9                   	leave  
  800e7c:	c3                   	ret    

00800e7d <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800e7d:	55                   	push   %ebp
  800e7e:	89 e5                	mov    %esp,%ebp
  800e80:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800e83:	8b 45 08             	mov    0x8(%ebp),%eax
  800e86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800e8f:	eb 2a                	jmp    800ebb <memcmp+0x3e>
		if (*s1 != *s2)
  800e91:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e94:	8a 10                	mov    (%eax),%dl
  800e96:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	38 c2                	cmp    %al,%dl
  800e9d:	74 16                	je     800eb5 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800e9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea2:	8a 00                	mov    (%eax),%al
  800ea4:	0f b6 d0             	movzbl %al,%edx
  800ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800eaa:	8a 00                	mov    (%eax),%al
  800eac:	0f b6 c0             	movzbl %al,%eax
  800eaf:	29 c2                	sub    %eax,%edx
  800eb1:	89 d0                	mov    %edx,%eax
  800eb3:	eb 18                	jmp    800ecd <memcmp+0x50>
		s1++, s2++;
  800eb5:	ff 45 fc             	incl   -0x4(%ebp)
  800eb8:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800ebb:	8b 45 10             	mov    0x10(%ebp),%eax
  800ebe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ec1:	89 55 10             	mov    %edx,0x10(%ebp)
  800ec4:	85 c0                	test   %eax,%eax
  800ec6:	75 c9                	jne    800e91 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ec8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ecd:	c9                   	leave  
  800ece:	c3                   	ret    

00800ecf <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ecf:	55                   	push   %ebp
  800ed0:	89 e5                	mov    %esp,%ebp
  800ed2:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ed8:	8b 45 10             	mov    0x10(%ebp),%eax
  800edb:	01 d0                	add    %edx,%eax
  800edd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800ee0:	eb 15                	jmp    800ef7 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	8a 00                	mov    (%eax),%al
  800ee7:	0f b6 d0             	movzbl %al,%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	0f b6 c0             	movzbl %al,%eax
  800ef0:	39 c2                	cmp    %eax,%edx
  800ef2:	74 0d                	je     800f01 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800ef4:	ff 45 08             	incl   0x8(%ebp)
  800ef7:	8b 45 08             	mov    0x8(%ebp),%eax
  800efa:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800efd:	72 e3                	jb     800ee2 <memfind+0x13>
  800eff:	eb 01                	jmp    800f02 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800f01:	90                   	nop
	return (void *) s;
  800f02:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f05:	c9                   	leave  
  800f06:	c3                   	ret    

00800f07 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800f07:	55                   	push   %ebp
  800f08:	89 e5                	mov    %esp,%ebp
  800f0a:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800f0d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800f14:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f1b:	eb 03                	jmp    800f20 <strtol+0x19>
		s++;
  800f1d:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 20                	cmp    $0x20,%al
  800f27:	74 f4                	je     800f1d <strtol+0x16>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 09                	cmp    $0x9,%al
  800f30:	74 eb                	je     800f1d <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	3c 2b                	cmp    $0x2b,%al
  800f39:	75 05                	jne    800f40 <strtol+0x39>
		s++;
  800f3b:	ff 45 08             	incl   0x8(%ebp)
  800f3e:	eb 13                	jmp    800f53 <strtol+0x4c>
	else if (*s == '-')
  800f40:	8b 45 08             	mov    0x8(%ebp),%eax
  800f43:	8a 00                	mov    (%eax),%al
  800f45:	3c 2d                	cmp    $0x2d,%al
  800f47:	75 0a                	jne    800f53 <strtol+0x4c>
		s++, neg = 1;
  800f49:	ff 45 08             	incl   0x8(%ebp)
  800f4c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800f53:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f57:	74 06                	je     800f5f <strtol+0x58>
  800f59:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800f5d:	75 20                	jne    800f7f <strtol+0x78>
  800f5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f62:	8a 00                	mov    (%eax),%al
  800f64:	3c 30                	cmp    $0x30,%al
  800f66:	75 17                	jne    800f7f <strtol+0x78>
  800f68:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6b:	40                   	inc    %eax
  800f6c:	8a 00                	mov    (%eax),%al
  800f6e:	3c 78                	cmp    $0x78,%al
  800f70:	75 0d                	jne    800f7f <strtol+0x78>
		s += 2, base = 16;
  800f72:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800f76:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800f7d:	eb 28                	jmp    800fa7 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800f7f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f83:	75 15                	jne    800f9a <strtol+0x93>
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	8a 00                	mov    (%eax),%al
  800f8a:	3c 30                	cmp    $0x30,%al
  800f8c:	75 0c                	jne    800f9a <strtol+0x93>
		s++, base = 8;
  800f8e:	ff 45 08             	incl   0x8(%ebp)
  800f91:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800f98:	eb 0d                	jmp    800fa7 <strtol+0xa0>
	else if (base == 0)
  800f9a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f9e:	75 07                	jne    800fa7 <strtol+0xa0>
		base = 10;
  800fa0:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800fa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800faa:	8a 00                	mov    (%eax),%al
  800fac:	3c 2f                	cmp    $0x2f,%al
  800fae:	7e 19                	jle    800fc9 <strtol+0xc2>
  800fb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb3:	8a 00                	mov    (%eax),%al
  800fb5:	3c 39                	cmp    $0x39,%al
  800fb7:	7f 10                	jg     800fc9 <strtol+0xc2>
			dig = *s - '0';
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	0f be c0             	movsbl %al,%eax
  800fc1:	83 e8 30             	sub    $0x30,%eax
  800fc4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fc7:	eb 42                	jmp    80100b <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	8a 00                	mov    (%eax),%al
  800fce:	3c 60                	cmp    $0x60,%al
  800fd0:	7e 19                	jle    800feb <strtol+0xe4>
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd5:	8a 00                	mov    (%eax),%al
  800fd7:	3c 7a                	cmp    $0x7a,%al
  800fd9:	7f 10                	jg     800feb <strtol+0xe4>
			dig = *s - 'a' + 10;
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f be c0             	movsbl %al,%eax
  800fe3:	83 e8 57             	sub    $0x57,%eax
  800fe6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800fe9:	eb 20                	jmp    80100b <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800feb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fee:	8a 00                	mov    (%eax),%al
  800ff0:	3c 40                	cmp    $0x40,%al
  800ff2:	7e 39                	jle    80102d <strtol+0x126>
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3c 5a                	cmp    $0x5a,%al
  800ffb:	7f 30                	jg     80102d <strtol+0x126>
			dig = *s - 'A' + 10;
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	8a 00                	mov    (%eax),%al
  801002:	0f be c0             	movsbl %al,%eax
  801005:	83 e8 37             	sub    $0x37,%eax
  801008:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80100b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80100e:	3b 45 10             	cmp    0x10(%ebp),%eax
  801011:	7d 19                	jge    80102c <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801019:	0f af 45 10          	imul   0x10(%ebp),%eax
  80101d:	89 c2                	mov    %eax,%edx
  80101f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801022:	01 d0                	add    %edx,%eax
  801024:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801027:	e9 7b ff ff ff       	jmp    800fa7 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80102c:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80102d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801031:	74 08                	je     80103b <strtol+0x134>
		*endptr = (char *) s;
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	8b 55 08             	mov    0x8(%ebp),%edx
  801039:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80103b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80103f:	74 07                	je     801048 <strtol+0x141>
  801041:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801044:	f7 d8                	neg    %eax
  801046:	eb 03                	jmp    80104b <strtol+0x144>
  801048:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80104b:	c9                   	leave  
  80104c:	c3                   	ret    

0080104d <ltostr>:

void
ltostr(long value, char *str)
{
  80104d:	55                   	push   %ebp
  80104e:	89 e5                	mov    %esp,%ebp
  801050:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801053:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80105a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801061:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801065:	79 13                	jns    80107a <ltostr+0x2d>
	{
		neg = 1;
  801067:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80106e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801071:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801074:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801077:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801082:	99                   	cltd   
  801083:	f7 f9                	idiv   %ecx
  801085:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801088:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80108b:	8d 50 01             	lea    0x1(%eax),%edx
  80108e:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801091:	89 c2                	mov    %eax,%edx
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	01 d0                	add    %edx,%eax
  801098:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80109b:	83 c2 30             	add    $0x30,%edx
  80109e:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8010a0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010a3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010a8:	f7 e9                	imul   %ecx
  8010aa:	c1 fa 02             	sar    $0x2,%edx
  8010ad:	89 c8                	mov    %ecx,%eax
  8010af:	c1 f8 1f             	sar    $0x1f,%eax
  8010b2:	29 c2                	sub    %eax,%edx
  8010b4:	89 d0                	mov    %edx,%eax
  8010b6:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8010b9:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8010bc:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8010c1:	f7 e9                	imul   %ecx
  8010c3:	c1 fa 02             	sar    $0x2,%edx
  8010c6:	89 c8                	mov    %ecx,%eax
  8010c8:	c1 f8 1f             	sar    $0x1f,%eax
  8010cb:	29 c2                	sub    %eax,%edx
  8010cd:	89 d0                	mov    %edx,%eax
  8010cf:	c1 e0 02             	shl    $0x2,%eax
  8010d2:	01 d0                	add    %edx,%eax
  8010d4:	01 c0                	add    %eax,%eax
  8010d6:	29 c1                	sub    %eax,%ecx
  8010d8:	89 ca                	mov    %ecx,%edx
  8010da:	85 d2                	test   %edx,%edx
  8010dc:	75 9c                	jne    80107a <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8010de:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8010e5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010e8:	48                   	dec    %eax
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8010ec:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f0:	74 3d                	je     80112f <ltostr+0xe2>
		start = 1 ;
  8010f2:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8010f9:	eb 34                	jmp    80112f <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8010fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801101:	01 d0                	add    %edx,%eax
  801103:	8a 00                	mov    (%eax),%al
  801105:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801108:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80110b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80110e:	01 c2                	add    %eax,%edx
  801110:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801113:	8b 45 0c             	mov    0xc(%ebp),%eax
  801116:	01 c8                	add    %ecx,%eax
  801118:	8a 00                	mov    (%eax),%al
  80111a:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80111c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80111f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801122:	01 c2                	add    %eax,%edx
  801124:	8a 45 eb             	mov    -0x15(%ebp),%al
  801127:	88 02                	mov    %al,(%edx)
		start++ ;
  801129:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80112c:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80112f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801132:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801135:	7c c4                	jl     8010fb <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801137:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80113a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113d:	01 d0                	add    %edx,%eax
  80113f:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801142:	90                   	nop
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
  801148:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80114b:	ff 75 08             	pushl  0x8(%ebp)
  80114e:	e8 54 fa ff ff       	call   800ba7 <strlen>
  801153:	83 c4 04             	add    $0x4,%esp
  801156:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801159:	ff 75 0c             	pushl  0xc(%ebp)
  80115c:	e8 46 fa ff ff       	call   800ba7 <strlen>
  801161:	83 c4 04             	add    $0x4,%esp
  801164:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801167:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80116e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801175:	eb 17                	jmp    80118e <strcconcat+0x49>
		final[s] = str1[s] ;
  801177:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80117a:	8b 45 10             	mov    0x10(%ebp),%eax
  80117d:	01 c2                	add    %eax,%edx
  80117f:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	01 c8                	add    %ecx,%eax
  801187:	8a 00                	mov    (%eax),%al
  801189:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80118b:	ff 45 fc             	incl   -0x4(%ebp)
  80118e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801191:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801194:	7c e1                	jl     801177 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801196:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80119d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8011a4:	eb 1f                	jmp    8011c5 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8011a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8011a9:	8d 50 01             	lea    0x1(%eax),%edx
  8011ac:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8011af:	89 c2                	mov    %eax,%edx
  8011b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b4:	01 c2                	add    %eax,%edx
  8011b6:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8011b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bc:	01 c8                	add    %ecx,%eax
  8011be:	8a 00                	mov    (%eax),%al
  8011c0:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8011c2:	ff 45 f8             	incl   -0x8(%ebp)
  8011c5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011c8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011cb:	7c d9                	jl     8011a6 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8011cd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8011d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d3:	01 d0                	add    %edx,%eax
  8011d5:	c6 00 00             	movb   $0x0,(%eax)
}
  8011d8:	90                   	nop
  8011d9:	c9                   	leave  
  8011da:	c3                   	ret    

008011db <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8011db:	55                   	push   %ebp
  8011dc:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8011de:	8b 45 14             	mov    0x14(%ebp),%eax
  8011e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8011e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8011ea:	8b 00                	mov    (%eax),%eax
  8011ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8011f6:	01 d0                	add    %edx,%eax
  8011f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8011fe:	eb 0c                	jmp    80120c <strsplit+0x31>
			*string++ = 0;
  801200:	8b 45 08             	mov    0x8(%ebp),%eax
  801203:	8d 50 01             	lea    0x1(%eax),%edx
  801206:	89 55 08             	mov    %edx,0x8(%ebp)
  801209:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	84 c0                	test   %al,%al
  801213:	74 18                	je     80122d <strsplit+0x52>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	8a 00                	mov    (%eax),%al
  80121a:	0f be c0             	movsbl %al,%eax
  80121d:	50                   	push   %eax
  80121e:	ff 75 0c             	pushl  0xc(%ebp)
  801221:	e8 13 fb ff ff       	call   800d39 <strchr>
  801226:	83 c4 08             	add    $0x8,%esp
  801229:	85 c0                	test   %eax,%eax
  80122b:	75 d3                	jne    801200 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	84 c0                	test   %al,%al
  801234:	74 5a                	je     801290 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801236:	8b 45 14             	mov    0x14(%ebp),%eax
  801239:	8b 00                	mov    (%eax),%eax
  80123b:	83 f8 0f             	cmp    $0xf,%eax
  80123e:	75 07                	jne    801247 <strsplit+0x6c>
		{
			return 0;
  801240:	b8 00 00 00 00       	mov    $0x0,%eax
  801245:	eb 66                	jmp    8012ad <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801247:	8b 45 14             	mov    0x14(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8d 48 01             	lea    0x1(%eax),%ecx
  80124f:	8b 55 14             	mov    0x14(%ebp),%edx
  801252:	89 0a                	mov    %ecx,(%edx)
  801254:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80125b:	8b 45 10             	mov    0x10(%ebp),%eax
  80125e:	01 c2                	add    %eax,%edx
  801260:	8b 45 08             	mov    0x8(%ebp),%eax
  801263:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801265:	eb 03                	jmp    80126a <strsplit+0x8f>
			string++;
  801267:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80126a:	8b 45 08             	mov    0x8(%ebp),%eax
  80126d:	8a 00                	mov    (%eax),%al
  80126f:	84 c0                	test   %al,%al
  801271:	74 8b                	je     8011fe <strsplit+0x23>
  801273:	8b 45 08             	mov    0x8(%ebp),%eax
  801276:	8a 00                	mov    (%eax),%al
  801278:	0f be c0             	movsbl %al,%eax
  80127b:	50                   	push   %eax
  80127c:	ff 75 0c             	pushl  0xc(%ebp)
  80127f:	e8 b5 fa ff ff       	call   800d39 <strchr>
  801284:	83 c4 08             	add    $0x8,%esp
  801287:	85 c0                	test   %eax,%eax
  801289:	74 dc                	je     801267 <strsplit+0x8c>
			string++;
	}
  80128b:	e9 6e ff ff ff       	jmp    8011fe <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801290:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801291:	8b 45 14             	mov    0x14(%ebp),%eax
  801294:	8b 00                	mov    (%eax),%eax
  801296:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80129d:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a0:	01 d0                	add    %edx,%eax
  8012a2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8012a8:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8012ad:	c9                   	leave  
  8012ae:	c3                   	ret    

008012af <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8012af:	55                   	push   %ebp
  8012b0:	89 e5                	mov    %esp,%ebp
  8012b2:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8012b5:	a1 04 40 80 00       	mov    0x804004,%eax
  8012ba:	85 c0                	test   %eax,%eax
  8012bc:	74 1f                	je     8012dd <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8012be:	e8 1d 00 00 00       	call   8012e0 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8012c3:	83 ec 0c             	sub    $0xc,%esp
  8012c6:	68 30 39 80 00       	push   $0x803930
  8012cb:	e8 55 f2 ff ff       	call   800525 <cprintf>
  8012d0:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8012d3:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8012da:	00 00 00 
	}
}
  8012dd:	90                   	nop
  8012de:	c9                   	leave  
  8012df:	c3                   	ret    

008012e0 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8012e0:	55                   	push   %ebp
  8012e1:	89 e5                	mov    %esp,%ebp
  8012e3:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  8012e6:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8012ed:	00 00 00 
  8012f0:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8012f7:	00 00 00 
  8012fa:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801301:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801304:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80130b:	00 00 00 
  80130e:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801315:	00 00 00 
  801318:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80131f:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801322:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801329:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80132c:	c1 e8 0c             	shr    $0xc,%eax
  80132f:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801334:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80133b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80133e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801343:	2d 00 10 00 00       	sub    $0x1000,%eax
  801348:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  80134d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801354:	a1 20 41 80 00       	mov    0x804120,%eax
  801359:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  80135d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801360:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801367:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80136a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80136d:	01 d0                	add    %edx,%eax
  80136f:	48                   	dec    %eax
  801370:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801373:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801376:	ba 00 00 00 00       	mov    $0x0,%edx
  80137b:	f7 75 e4             	divl   -0x1c(%ebp)
  80137e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801381:	29 d0                	sub    %edx,%eax
  801383:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801386:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  80138d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801390:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801395:	2d 00 10 00 00       	sub    $0x1000,%eax
  80139a:	83 ec 04             	sub    $0x4,%esp
  80139d:	6a 07                	push   $0x7
  80139f:	ff 75 e8             	pushl  -0x18(%ebp)
  8013a2:	50                   	push   %eax
  8013a3:	e8 3d 06 00 00       	call   8019e5 <sys_allocate_chunk>
  8013a8:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8013ab:	a1 20 41 80 00       	mov    0x804120,%eax
  8013b0:	83 ec 0c             	sub    $0xc,%esp
  8013b3:	50                   	push   %eax
  8013b4:	e8 b2 0c 00 00       	call   80206b <initialize_MemBlocksList>
  8013b9:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8013bc:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8013c1:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8013c4:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013c8:	0f 84 f3 00 00 00    	je     8014c1 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8013ce:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8013d2:	75 14                	jne    8013e8 <initialize_dyn_block_system+0x108>
  8013d4:	83 ec 04             	sub    $0x4,%esp
  8013d7:	68 55 39 80 00       	push   $0x803955
  8013dc:	6a 36                	push   $0x36
  8013de:	68 73 39 80 00       	push   $0x803973
  8013e3:	e8 89 ee ff ff       	call   800271 <_panic>
  8013e8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013eb:	8b 00                	mov    (%eax),%eax
  8013ed:	85 c0                	test   %eax,%eax
  8013ef:	74 10                	je     801401 <initialize_dyn_block_system+0x121>
  8013f1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013f4:	8b 00                	mov    (%eax),%eax
  8013f6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8013f9:	8b 52 04             	mov    0x4(%edx),%edx
  8013fc:	89 50 04             	mov    %edx,0x4(%eax)
  8013ff:	eb 0b                	jmp    80140c <initialize_dyn_block_system+0x12c>
  801401:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801404:	8b 40 04             	mov    0x4(%eax),%eax
  801407:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80140c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80140f:	8b 40 04             	mov    0x4(%eax),%eax
  801412:	85 c0                	test   %eax,%eax
  801414:	74 0f                	je     801425 <initialize_dyn_block_system+0x145>
  801416:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801419:	8b 40 04             	mov    0x4(%eax),%eax
  80141c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80141f:	8b 12                	mov    (%edx),%edx
  801421:	89 10                	mov    %edx,(%eax)
  801423:	eb 0a                	jmp    80142f <initialize_dyn_block_system+0x14f>
  801425:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801428:	8b 00                	mov    (%eax),%eax
  80142a:	a3 48 41 80 00       	mov    %eax,0x804148
  80142f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801432:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801438:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80143b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801442:	a1 54 41 80 00       	mov    0x804154,%eax
  801447:	48                   	dec    %eax
  801448:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  80144d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801450:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801457:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80145a:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801461:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801465:	75 14                	jne    80147b <initialize_dyn_block_system+0x19b>
  801467:	83 ec 04             	sub    $0x4,%esp
  80146a:	68 80 39 80 00       	push   $0x803980
  80146f:	6a 3e                	push   $0x3e
  801471:	68 73 39 80 00       	push   $0x803973
  801476:	e8 f6 ed ff ff       	call   800271 <_panic>
  80147b:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801481:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801484:	89 10                	mov    %edx,(%eax)
  801486:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801489:	8b 00                	mov    (%eax),%eax
  80148b:	85 c0                	test   %eax,%eax
  80148d:	74 0d                	je     80149c <initialize_dyn_block_system+0x1bc>
  80148f:	a1 38 41 80 00       	mov    0x804138,%eax
  801494:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801497:	89 50 04             	mov    %edx,0x4(%eax)
  80149a:	eb 08                	jmp    8014a4 <initialize_dyn_block_system+0x1c4>
  80149c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80149f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8014a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014a7:	a3 38 41 80 00       	mov    %eax,0x804138
  8014ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014b6:	a1 44 41 80 00       	mov    0x804144,%eax
  8014bb:	40                   	inc    %eax
  8014bc:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8014c1:	90                   	nop
  8014c2:	c9                   	leave  
  8014c3:	c3                   	ret    

008014c4 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8014c4:	55                   	push   %ebp
  8014c5:	89 e5                	mov    %esp,%ebp
  8014c7:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8014ca:	e8 e0 fd ff ff       	call   8012af <InitializeUHeap>
		if (size == 0) return NULL ;
  8014cf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014d3:	75 07                	jne    8014dc <malloc+0x18>
  8014d5:	b8 00 00 00 00       	mov    $0x0,%eax
  8014da:	eb 7f                	jmp    80155b <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8014dc:	e8 d2 08 00 00       	call   801db3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014e1:	85 c0                	test   %eax,%eax
  8014e3:	74 71                	je     801556 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  8014e5:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8014ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8014ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014f2:	01 d0                	add    %edx,%eax
  8014f4:	48                   	dec    %eax
  8014f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014fb:	ba 00 00 00 00       	mov    $0x0,%edx
  801500:	f7 75 f4             	divl   -0xc(%ebp)
  801503:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801506:	29 d0                	sub    %edx,%eax
  801508:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  80150b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801512:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801519:	76 07                	jbe    801522 <malloc+0x5e>
					return NULL ;
  80151b:	b8 00 00 00 00       	mov    $0x0,%eax
  801520:	eb 39                	jmp    80155b <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801522:	83 ec 0c             	sub    $0xc,%esp
  801525:	ff 75 08             	pushl  0x8(%ebp)
  801528:	e8 e6 0d 00 00       	call   802313 <alloc_block_FF>
  80152d:	83 c4 10             	add    $0x10,%esp
  801530:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801533:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801537:	74 16                	je     80154f <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801539:	83 ec 0c             	sub    $0xc,%esp
  80153c:	ff 75 ec             	pushl  -0x14(%ebp)
  80153f:	e8 37 0c 00 00       	call   80217b <insert_sorted_allocList>
  801544:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801547:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80154a:	8b 40 08             	mov    0x8(%eax),%eax
  80154d:	eb 0c                	jmp    80155b <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  80154f:	b8 00 00 00 00       	mov    $0x0,%eax
  801554:	eb 05                	jmp    80155b <malloc+0x97>
				}
		}
	return 0;
  801556:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80155b:	c9                   	leave  
  80155c:	c3                   	ret    

0080155d <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80155d:	55                   	push   %ebp
  80155e:	89 e5                	mov    %esp,%ebp
  801560:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801563:	8b 45 08             	mov    0x8(%ebp),%eax
  801566:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801569:	83 ec 08             	sub    $0x8,%esp
  80156c:	ff 75 f4             	pushl  -0xc(%ebp)
  80156f:	68 40 40 80 00       	push   $0x804040
  801574:	e8 cf 0b 00 00       	call   802148 <find_block>
  801579:	83 c4 10             	add    $0x10,%esp
  80157c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  80157f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801582:	8b 40 0c             	mov    0xc(%eax),%eax
  801585:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801588:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80158b:	8b 40 08             	mov    0x8(%eax),%eax
  80158e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801591:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801595:	0f 84 a1 00 00 00    	je     80163c <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  80159b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80159f:	75 17                	jne    8015b8 <free+0x5b>
  8015a1:	83 ec 04             	sub    $0x4,%esp
  8015a4:	68 55 39 80 00       	push   $0x803955
  8015a9:	68 80 00 00 00       	push   $0x80
  8015ae:	68 73 39 80 00       	push   $0x803973
  8015b3:	e8 b9 ec ff ff       	call   800271 <_panic>
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bb:	8b 00                	mov    (%eax),%eax
  8015bd:	85 c0                	test   %eax,%eax
  8015bf:	74 10                	je     8015d1 <free+0x74>
  8015c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c4:	8b 00                	mov    (%eax),%eax
  8015c6:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015c9:	8b 52 04             	mov    0x4(%edx),%edx
  8015cc:	89 50 04             	mov    %edx,0x4(%eax)
  8015cf:	eb 0b                	jmp    8015dc <free+0x7f>
  8015d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015d4:	8b 40 04             	mov    0x4(%eax),%eax
  8015d7:	a3 44 40 80 00       	mov    %eax,0x804044
  8015dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015df:	8b 40 04             	mov    0x4(%eax),%eax
  8015e2:	85 c0                	test   %eax,%eax
  8015e4:	74 0f                	je     8015f5 <free+0x98>
  8015e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015e9:	8b 40 04             	mov    0x4(%eax),%eax
  8015ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015ef:	8b 12                	mov    (%edx),%edx
  8015f1:	89 10                	mov    %edx,(%eax)
  8015f3:	eb 0a                	jmp    8015ff <free+0xa2>
  8015f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f8:	8b 00                	mov    (%eax),%eax
  8015fa:	a3 40 40 80 00       	mov    %eax,0x804040
  8015ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801602:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801608:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80160b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801612:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801617:	48                   	dec    %eax
  801618:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  80161d:	83 ec 0c             	sub    $0xc,%esp
  801620:	ff 75 f0             	pushl  -0x10(%ebp)
  801623:	e8 29 12 00 00       	call   802851 <insert_sorted_with_merge_freeList>
  801628:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  80162b:	83 ec 08             	sub    $0x8,%esp
  80162e:	ff 75 ec             	pushl  -0x14(%ebp)
  801631:	ff 75 e8             	pushl  -0x18(%ebp)
  801634:	e8 74 03 00 00       	call   8019ad <sys_free_user_mem>
  801639:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80163c:	90                   	nop
  80163d:	c9                   	leave  
  80163e:	c3                   	ret    

0080163f <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  80163f:	55                   	push   %ebp
  801640:	89 e5                	mov    %esp,%ebp
  801642:	83 ec 38             	sub    $0x38,%esp
  801645:	8b 45 10             	mov    0x10(%ebp),%eax
  801648:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80164b:	e8 5f fc ff ff       	call   8012af <InitializeUHeap>
	if (size == 0) return NULL ;
  801650:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801654:	75 0a                	jne    801660 <smalloc+0x21>
  801656:	b8 00 00 00 00       	mov    $0x0,%eax
  80165b:	e9 b2 00 00 00       	jmp    801712 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801660:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801667:	76 0a                	jbe    801673 <smalloc+0x34>
		return NULL;
  801669:	b8 00 00 00 00       	mov    $0x0,%eax
  80166e:	e9 9f 00 00 00       	jmp    801712 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801673:	e8 3b 07 00 00       	call   801db3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801678:	85 c0                	test   %eax,%eax
  80167a:	0f 84 8d 00 00 00    	je     80170d <smalloc+0xce>
	struct MemBlock *b = NULL;
  801680:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801687:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  80168e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801694:	01 d0                	add    %edx,%eax
  801696:	48                   	dec    %eax
  801697:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80169a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80169d:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a2:	f7 75 f0             	divl   -0x10(%ebp)
  8016a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8016a8:	29 d0                	sub    %edx,%eax
  8016aa:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8016ad:	83 ec 0c             	sub    $0xc,%esp
  8016b0:	ff 75 e8             	pushl  -0x18(%ebp)
  8016b3:	e8 5b 0c 00 00       	call   802313 <alloc_block_FF>
  8016b8:	83 c4 10             	add    $0x10,%esp
  8016bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8016be:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8016c2:	75 07                	jne    8016cb <smalloc+0x8c>
			return NULL;
  8016c4:	b8 00 00 00 00       	mov    $0x0,%eax
  8016c9:	eb 47                	jmp    801712 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8016cb:	83 ec 0c             	sub    $0xc,%esp
  8016ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8016d1:	e8 a5 0a 00 00       	call   80217b <insert_sorted_allocList>
  8016d6:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8016d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dc:	8b 40 08             	mov    0x8(%eax),%eax
  8016df:	89 c2                	mov    %eax,%edx
  8016e1:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8016e5:	52                   	push   %edx
  8016e6:	50                   	push   %eax
  8016e7:	ff 75 0c             	pushl  0xc(%ebp)
  8016ea:	ff 75 08             	pushl  0x8(%ebp)
  8016ed:	e8 46 04 00 00       	call   801b38 <sys_createSharedObject>
  8016f2:	83 c4 10             	add    $0x10,%esp
  8016f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  8016f8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8016fc:	78 08                	js     801706 <smalloc+0xc7>
		return (void *)b->sva;
  8016fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801701:	8b 40 08             	mov    0x8(%eax),%eax
  801704:	eb 0c                	jmp    801712 <smalloc+0xd3>
		}else{
		return NULL;
  801706:	b8 00 00 00 00       	mov    $0x0,%eax
  80170b:	eb 05                	jmp    801712 <smalloc+0xd3>
			}

	}return NULL;
  80170d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801712:	c9                   	leave  
  801713:	c3                   	ret    

00801714 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801714:	55                   	push   %ebp
  801715:	89 e5                	mov    %esp,%ebp
  801717:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80171a:	e8 90 fb ff ff       	call   8012af <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80171f:	e8 8f 06 00 00       	call   801db3 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801724:	85 c0                	test   %eax,%eax
  801726:	0f 84 ad 00 00 00    	je     8017d9 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80172c:	83 ec 08             	sub    $0x8,%esp
  80172f:	ff 75 0c             	pushl  0xc(%ebp)
  801732:	ff 75 08             	pushl  0x8(%ebp)
  801735:	e8 28 04 00 00       	call   801b62 <sys_getSizeOfSharedObject>
  80173a:	83 c4 10             	add    $0x10,%esp
  80173d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801740:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801744:	79 0a                	jns    801750 <sget+0x3c>
    {
    	return NULL;
  801746:	b8 00 00 00 00       	mov    $0x0,%eax
  80174b:	e9 8e 00 00 00       	jmp    8017de <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801750:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801757:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80175e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801761:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801764:	01 d0                	add    %edx,%eax
  801766:	48                   	dec    %eax
  801767:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80176a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80176d:	ba 00 00 00 00       	mov    $0x0,%edx
  801772:	f7 75 ec             	divl   -0x14(%ebp)
  801775:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801778:	29 d0                	sub    %edx,%eax
  80177a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  80177d:	83 ec 0c             	sub    $0xc,%esp
  801780:	ff 75 e4             	pushl  -0x1c(%ebp)
  801783:	e8 8b 0b 00 00       	call   802313 <alloc_block_FF>
  801788:	83 c4 10             	add    $0x10,%esp
  80178b:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  80178e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801792:	75 07                	jne    80179b <sget+0x87>
				return NULL;
  801794:	b8 00 00 00 00       	mov    $0x0,%eax
  801799:	eb 43                	jmp    8017de <sget+0xca>
			}
			insert_sorted_allocList(b);
  80179b:	83 ec 0c             	sub    $0xc,%esp
  80179e:	ff 75 f0             	pushl  -0x10(%ebp)
  8017a1:	e8 d5 09 00 00       	call   80217b <insert_sorted_allocList>
  8017a6:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8017a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017ac:	8b 40 08             	mov    0x8(%eax),%eax
  8017af:	83 ec 04             	sub    $0x4,%esp
  8017b2:	50                   	push   %eax
  8017b3:	ff 75 0c             	pushl  0xc(%ebp)
  8017b6:	ff 75 08             	pushl  0x8(%ebp)
  8017b9:	e8 c1 03 00 00       	call   801b7f <sys_getSharedObject>
  8017be:	83 c4 10             	add    $0x10,%esp
  8017c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8017c4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8017c8:	78 08                	js     8017d2 <sget+0xbe>
			return (void *)b->sva;
  8017ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017cd:	8b 40 08             	mov    0x8(%eax),%eax
  8017d0:	eb 0c                	jmp    8017de <sget+0xca>
			}else{
			return NULL;
  8017d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8017d7:	eb 05                	jmp    8017de <sget+0xca>
			}
    }}return NULL;
  8017d9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017de:	c9                   	leave  
  8017df:	c3                   	ret    

008017e0 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8017e0:	55                   	push   %ebp
  8017e1:	89 e5                	mov    %esp,%ebp
  8017e3:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017e6:	e8 c4 fa ff ff       	call   8012af <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	68 a4 39 80 00       	push   $0x8039a4
  8017f3:	68 03 01 00 00       	push   $0x103
  8017f8:	68 73 39 80 00       	push   $0x803973
  8017fd:	e8 6f ea ff ff       	call   800271 <_panic>

00801802 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801802:	55                   	push   %ebp
  801803:	89 e5                	mov    %esp,%ebp
  801805:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801808:	83 ec 04             	sub    $0x4,%esp
  80180b:	68 cc 39 80 00       	push   $0x8039cc
  801810:	68 17 01 00 00       	push   $0x117
  801815:	68 73 39 80 00       	push   $0x803973
  80181a:	e8 52 ea ff ff       	call   800271 <_panic>

0080181f <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
  801822:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801825:	83 ec 04             	sub    $0x4,%esp
  801828:	68 f0 39 80 00       	push   $0x8039f0
  80182d:	68 22 01 00 00       	push   $0x122
  801832:	68 73 39 80 00       	push   $0x803973
  801837:	e8 35 ea ff ff       	call   800271 <_panic>

0080183c <shrink>:

}
void shrink(uint32 newSize)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
  80183f:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801842:	83 ec 04             	sub    $0x4,%esp
  801845:	68 f0 39 80 00       	push   $0x8039f0
  80184a:	68 27 01 00 00       	push   $0x127
  80184f:	68 73 39 80 00       	push   $0x803973
  801854:	e8 18 ea ff ff       	call   800271 <_panic>

00801859 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
  80185c:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80185f:	83 ec 04             	sub    $0x4,%esp
  801862:	68 f0 39 80 00       	push   $0x8039f0
  801867:	68 2c 01 00 00       	push   $0x12c
  80186c:	68 73 39 80 00       	push   $0x803973
  801871:	e8 fb e9 ff ff       	call   800271 <_panic>

00801876 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801876:	55                   	push   %ebp
  801877:	89 e5                	mov    %esp,%ebp
  801879:	57                   	push   %edi
  80187a:	56                   	push   %esi
  80187b:	53                   	push   %ebx
  80187c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80187f:	8b 45 08             	mov    0x8(%ebp),%eax
  801882:	8b 55 0c             	mov    0xc(%ebp),%edx
  801885:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801888:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80188b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80188e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801891:	cd 30                	int    $0x30
  801893:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801896:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801899:	83 c4 10             	add    $0x10,%esp
  80189c:	5b                   	pop    %ebx
  80189d:	5e                   	pop    %esi
  80189e:	5f                   	pop    %edi
  80189f:	5d                   	pop    %ebp
  8018a0:	c3                   	ret    

008018a1 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
  8018a4:	83 ec 04             	sub    $0x4,%esp
  8018a7:	8b 45 10             	mov    0x10(%ebp),%eax
  8018aa:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8018ad:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	6a 00                	push   $0x0
  8018b6:	6a 00                	push   $0x0
  8018b8:	52                   	push   %edx
  8018b9:	ff 75 0c             	pushl  0xc(%ebp)
  8018bc:	50                   	push   %eax
  8018bd:	6a 00                	push   $0x0
  8018bf:	e8 b2 ff ff ff       	call   801876 <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	90                   	nop
  8018c8:	c9                   	leave  
  8018c9:	c3                   	ret    

008018ca <sys_cgetc>:

int
sys_cgetc(void)
{
  8018ca:	55                   	push   %ebp
  8018cb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8018cd:	6a 00                	push   $0x0
  8018cf:	6a 00                	push   $0x0
  8018d1:	6a 00                	push   $0x0
  8018d3:	6a 00                	push   $0x0
  8018d5:	6a 00                	push   $0x0
  8018d7:	6a 01                	push   $0x1
  8018d9:	e8 98 ff ff ff       	call   801876 <syscall>
  8018de:	83 c4 18             	add    $0x18,%esp
}
  8018e1:	c9                   	leave  
  8018e2:	c3                   	ret    

008018e3 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8018e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8018e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	52                   	push   %edx
  8018f3:	50                   	push   %eax
  8018f4:	6a 05                	push   $0x5
  8018f6:	e8 7b ff ff ff       	call   801876 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	56                   	push   %esi
  801904:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801905:	8b 75 18             	mov    0x18(%ebp),%esi
  801908:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80190b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80190e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801911:	8b 45 08             	mov    0x8(%ebp),%eax
  801914:	56                   	push   %esi
  801915:	53                   	push   %ebx
  801916:	51                   	push   %ecx
  801917:	52                   	push   %edx
  801918:	50                   	push   %eax
  801919:	6a 06                	push   $0x6
  80191b:	e8 56 ff ff ff       	call   801876 <syscall>
  801920:	83 c4 18             	add    $0x18,%esp
}
  801923:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801926:	5b                   	pop    %ebx
  801927:	5e                   	pop    %esi
  801928:	5d                   	pop    %ebp
  801929:	c3                   	ret    

0080192a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80192a:	55                   	push   %ebp
  80192b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80192d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801930:	8b 45 08             	mov    0x8(%ebp),%eax
  801933:	6a 00                	push   $0x0
  801935:	6a 00                	push   $0x0
  801937:	6a 00                	push   $0x0
  801939:	52                   	push   %edx
  80193a:	50                   	push   %eax
  80193b:	6a 07                	push   $0x7
  80193d:	e8 34 ff ff ff       	call   801876 <syscall>
  801942:	83 c4 18             	add    $0x18,%esp
}
  801945:	c9                   	leave  
  801946:	c3                   	ret    

00801947 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801947:	55                   	push   %ebp
  801948:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 00                	push   $0x0
  801950:	ff 75 0c             	pushl  0xc(%ebp)
  801953:	ff 75 08             	pushl  0x8(%ebp)
  801956:	6a 08                	push   $0x8
  801958:	e8 19 ff ff ff       	call   801876 <syscall>
  80195d:	83 c4 18             	add    $0x18,%esp
}
  801960:	c9                   	leave  
  801961:	c3                   	ret    

00801962 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801962:	55                   	push   %ebp
  801963:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	6a 00                	push   $0x0
  80196f:	6a 09                	push   $0x9
  801971:	e8 00 ff ff ff       	call   801876 <syscall>
  801976:	83 c4 18             	add    $0x18,%esp
}
  801979:	c9                   	leave  
  80197a:	c3                   	ret    

0080197b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80197b:	55                   	push   %ebp
  80197c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80197e:	6a 00                	push   $0x0
  801980:	6a 00                	push   $0x0
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 0a                	push   $0xa
  80198a:	e8 e7 fe ff ff       	call   801876 <syscall>
  80198f:	83 c4 18             	add    $0x18,%esp
}
  801992:	c9                   	leave  
  801993:	c3                   	ret    

00801994 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801994:	55                   	push   %ebp
  801995:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 0b                	push   $0xb
  8019a3:	e8 ce fe ff ff       	call   801876 <syscall>
  8019a8:	83 c4 18             	add    $0x18,%esp
}
  8019ab:	c9                   	leave  
  8019ac:	c3                   	ret    

008019ad <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8019ad:	55                   	push   %ebp
  8019ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	ff 75 0c             	pushl  0xc(%ebp)
  8019b9:	ff 75 08             	pushl  0x8(%ebp)
  8019bc:	6a 0f                	push   $0xf
  8019be:	e8 b3 fe ff ff       	call   801876 <syscall>
  8019c3:	83 c4 18             	add    $0x18,%esp
	return;
  8019c6:	90                   	nop
}
  8019c7:	c9                   	leave  
  8019c8:	c3                   	ret    

008019c9 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8019c9:	55                   	push   %ebp
  8019ca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	ff 75 0c             	pushl  0xc(%ebp)
  8019d5:	ff 75 08             	pushl  0x8(%ebp)
  8019d8:	6a 10                	push   $0x10
  8019da:	e8 97 fe ff ff       	call   801876 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e2:	90                   	nop
}
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	ff 75 10             	pushl  0x10(%ebp)
  8019ef:	ff 75 0c             	pushl  0xc(%ebp)
  8019f2:	ff 75 08             	pushl  0x8(%ebp)
  8019f5:	6a 11                	push   $0x11
  8019f7:	e8 7a fe ff ff       	call   801876 <syscall>
  8019fc:	83 c4 18             	add    $0x18,%esp
	return ;
  8019ff:	90                   	nop
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801a05:	6a 00                	push   $0x0
  801a07:	6a 00                	push   $0x0
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 0c                	push   $0xc
  801a11:	e8 60 fe ff ff       	call   801876 <syscall>
  801a16:	83 c4 18             	add    $0x18,%esp
}
  801a19:	c9                   	leave  
  801a1a:	c3                   	ret    

00801a1b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801a1b:	55                   	push   %ebp
  801a1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 00                	push   $0x0
  801a26:	ff 75 08             	pushl  0x8(%ebp)
  801a29:	6a 0d                	push   $0xd
  801a2b:	e8 46 fe ff ff       	call   801876 <syscall>
  801a30:	83 c4 18             	add    $0x18,%esp
}
  801a33:	c9                   	leave  
  801a34:	c3                   	ret    

00801a35 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801a35:	55                   	push   %ebp
  801a36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	6a 00                	push   $0x0
  801a42:	6a 0e                	push   $0xe
  801a44:	e8 2d fe ff ff       	call   801876 <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	90                   	nop
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 13                	push   $0x13
  801a5e:	e8 13 fe ff ff       	call   801876 <syscall>
  801a63:	83 c4 18             	add    $0x18,%esp
}
  801a66:	90                   	nop
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 14                	push   $0x14
  801a78:	e8 f9 fd ff ff       	call   801876 <syscall>
  801a7d:	83 c4 18             	add    $0x18,%esp
}
  801a80:	90                   	nop
  801a81:	c9                   	leave  
  801a82:	c3                   	ret    

00801a83 <sys_cputc>:


void
sys_cputc(const char c)
{
  801a83:	55                   	push   %ebp
  801a84:	89 e5                	mov    %esp,%ebp
  801a86:	83 ec 04             	sub    $0x4,%esp
  801a89:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801a8f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	50                   	push   %eax
  801a9c:	6a 15                	push   $0x15
  801a9e:	e8 d3 fd ff ff       	call   801876 <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
}
  801aa6:	90                   	nop
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 16                	push   $0x16
  801ab8:	e8 b9 fd ff ff       	call   801876 <syscall>
  801abd:	83 c4 18             	add    $0x18,%esp
}
  801ac0:	90                   	nop
  801ac1:	c9                   	leave  
  801ac2:	c3                   	ret    

00801ac3 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801ac3:	55                   	push   %ebp
  801ac4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801ac6:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	ff 75 0c             	pushl  0xc(%ebp)
  801ad2:	50                   	push   %eax
  801ad3:	6a 17                	push   $0x17
  801ad5:	e8 9c fd ff ff       	call   801876 <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae5:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae8:	6a 00                	push   $0x0
  801aea:	6a 00                	push   $0x0
  801aec:	6a 00                	push   $0x0
  801aee:	52                   	push   %edx
  801aef:	50                   	push   %eax
  801af0:	6a 1a                	push   $0x1a
  801af2:	e8 7f fd ff ff       	call   801876 <syscall>
  801af7:	83 c4 18             	add    $0x18,%esp
}
  801afa:	c9                   	leave  
  801afb:	c3                   	ret    

00801afc <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801afc:	55                   	push   %ebp
  801afd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801aff:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b02:	8b 45 08             	mov    0x8(%ebp),%eax
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	52                   	push   %edx
  801b0c:	50                   	push   %eax
  801b0d:	6a 18                	push   $0x18
  801b0f:	e8 62 fd ff ff       	call   801876 <syscall>
  801b14:	83 c4 18             	add    $0x18,%esp
}
  801b17:	90                   	nop
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b1d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b20:	8b 45 08             	mov    0x8(%ebp),%eax
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	52                   	push   %edx
  801b2a:	50                   	push   %eax
  801b2b:	6a 19                	push   $0x19
  801b2d:	e8 44 fd ff ff       	call   801876 <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	90                   	nop
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	83 ec 04             	sub    $0x4,%esp
  801b3e:	8b 45 10             	mov    0x10(%ebp),%eax
  801b41:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801b44:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801b47:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4e:	6a 00                	push   $0x0
  801b50:	51                   	push   %ecx
  801b51:	52                   	push   %edx
  801b52:	ff 75 0c             	pushl  0xc(%ebp)
  801b55:	50                   	push   %eax
  801b56:	6a 1b                	push   $0x1b
  801b58:	e8 19 fd ff ff       	call   801876 <syscall>
  801b5d:	83 c4 18             	add    $0x18,%esp
}
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801b65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b68:	8b 45 08             	mov    0x8(%ebp),%eax
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 00                	push   $0x0
  801b71:	52                   	push   %edx
  801b72:	50                   	push   %eax
  801b73:	6a 1c                	push   $0x1c
  801b75:	e8 fc fc ff ff       	call   801876 <syscall>
  801b7a:	83 c4 18             	add    $0x18,%esp
}
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801b82:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	51                   	push   %ecx
  801b90:	52                   	push   %edx
  801b91:	50                   	push   %eax
  801b92:	6a 1d                	push   $0x1d
  801b94:	e8 dd fc ff ff       	call   801876 <syscall>
  801b99:	83 c4 18             	add    $0x18,%esp
}
  801b9c:	c9                   	leave  
  801b9d:	c3                   	ret    

00801b9e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801b9e:	55                   	push   %ebp
  801b9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ba1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba4:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	52                   	push   %edx
  801bae:	50                   	push   %eax
  801baf:	6a 1e                	push   $0x1e
  801bb1:	e8 c0 fc ff ff       	call   801876 <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	6a 1f                	push   $0x1f
  801bca:	e8 a7 fc ff ff       	call   801876 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	c9                   	leave  
  801bd3:	c3                   	ret    

00801bd4 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801bd4:	55                   	push   %ebp
  801bd5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bda:	6a 00                	push   $0x0
  801bdc:	ff 75 14             	pushl  0x14(%ebp)
  801bdf:	ff 75 10             	pushl  0x10(%ebp)
  801be2:	ff 75 0c             	pushl  0xc(%ebp)
  801be5:	50                   	push   %eax
  801be6:	6a 20                	push   $0x20
  801be8:	e8 89 fc ff ff       	call   801876 <syscall>
  801bed:	83 c4 18             	add    $0x18,%esp
}
  801bf0:	c9                   	leave  
  801bf1:	c3                   	ret    

00801bf2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801bf2:	55                   	push   %ebp
  801bf3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801bf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	50                   	push   %eax
  801c01:	6a 21                	push   $0x21
  801c03:	e8 6e fc ff ff       	call   801876 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
}
  801c0b:	90                   	nop
  801c0c:	c9                   	leave  
  801c0d:	c3                   	ret    

00801c0e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801c0e:	55                   	push   %ebp
  801c0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 00                	push   $0x0
  801c1c:	50                   	push   %eax
  801c1d:	6a 22                	push   $0x22
  801c1f:	e8 52 fc ff ff       	call   801876 <syscall>
  801c24:	83 c4 18             	add    $0x18,%esp
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	6a 00                	push   $0x0
  801c34:	6a 00                	push   $0x0
  801c36:	6a 02                	push   $0x2
  801c38:	e8 39 fc ff ff       	call   801876 <syscall>
  801c3d:	83 c4 18             	add    $0x18,%esp
}
  801c40:	c9                   	leave  
  801c41:	c3                   	ret    

00801c42 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801c42:	55                   	push   %ebp
  801c43:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 00                	push   $0x0
  801c4d:	6a 00                	push   $0x0
  801c4f:	6a 03                	push   $0x3
  801c51:	e8 20 fc ff ff       	call   801876 <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 00                	push   $0x0
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 04                	push   $0x4
  801c6a:	e8 07 fc ff ff       	call   801876 <syscall>
  801c6f:	83 c4 18             	add    $0x18,%esp
}
  801c72:	c9                   	leave  
  801c73:	c3                   	ret    

00801c74 <sys_exit_env>:


void sys_exit_env(void)
{
  801c74:	55                   	push   %ebp
  801c75:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 00                	push   $0x0
  801c7f:	6a 00                	push   $0x0
  801c81:	6a 23                	push   $0x23
  801c83:	e8 ee fb ff ff       	call   801876 <syscall>
  801c88:	83 c4 18             	add    $0x18,%esp
}
  801c8b:	90                   	nop
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
  801c91:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801c94:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c97:	8d 50 04             	lea    0x4(%eax),%edx
  801c9a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	52                   	push   %edx
  801ca4:	50                   	push   %eax
  801ca5:	6a 24                	push   $0x24
  801ca7:	e8 ca fb ff ff       	call   801876 <syscall>
  801cac:	83 c4 18             	add    $0x18,%esp
	return result;
  801caf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801cb2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801cb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801cb8:	89 01                	mov    %eax,(%ecx)
  801cba:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801cbd:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc0:	c9                   	leave  
  801cc1:	c2 04 00             	ret    $0x4

00801cc4 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801cc4:	55                   	push   %ebp
  801cc5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801cc7:	6a 00                	push   $0x0
  801cc9:	6a 00                	push   $0x0
  801ccb:	ff 75 10             	pushl  0x10(%ebp)
  801cce:	ff 75 0c             	pushl  0xc(%ebp)
  801cd1:	ff 75 08             	pushl  0x8(%ebp)
  801cd4:	6a 12                	push   $0x12
  801cd6:	e8 9b fb ff ff       	call   801876 <syscall>
  801cdb:	83 c4 18             	add    $0x18,%esp
	return ;
  801cde:	90                   	nop
}
  801cdf:	c9                   	leave  
  801ce0:	c3                   	ret    

00801ce1 <sys_rcr2>:
uint32 sys_rcr2()
{
  801ce1:	55                   	push   %ebp
  801ce2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ce4:	6a 00                	push   $0x0
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 25                	push   $0x25
  801cf0:	e8 81 fb ff ff       	call   801876 <syscall>
  801cf5:	83 c4 18             	add    $0x18,%esp
}
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	83 ec 04             	sub    $0x4,%esp
  801d00:	8b 45 08             	mov    0x8(%ebp),%eax
  801d03:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801d06:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801d0a:	6a 00                	push   $0x0
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	50                   	push   %eax
  801d13:	6a 26                	push   $0x26
  801d15:	e8 5c fb ff ff       	call   801876 <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d1d:	90                   	nop
}
  801d1e:	c9                   	leave  
  801d1f:	c3                   	ret    

00801d20 <rsttst>:
void rsttst()
{
  801d20:	55                   	push   %ebp
  801d21:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 28                	push   $0x28
  801d2f:	e8 42 fb ff ff       	call   801876 <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
	return ;
  801d37:	90                   	nop
}
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
  801d3d:	83 ec 04             	sub    $0x4,%esp
  801d40:	8b 45 14             	mov    0x14(%ebp),%eax
  801d43:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801d46:	8b 55 18             	mov    0x18(%ebp),%edx
  801d49:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801d4d:	52                   	push   %edx
  801d4e:	50                   	push   %eax
  801d4f:	ff 75 10             	pushl  0x10(%ebp)
  801d52:	ff 75 0c             	pushl  0xc(%ebp)
  801d55:	ff 75 08             	pushl  0x8(%ebp)
  801d58:	6a 27                	push   $0x27
  801d5a:	e8 17 fb ff ff       	call   801876 <syscall>
  801d5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801d62:	90                   	nop
}
  801d63:	c9                   	leave  
  801d64:	c3                   	ret    

00801d65 <chktst>:
void chktst(uint32 n)
{
  801d65:	55                   	push   %ebp
  801d66:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 00                	push   $0x0
  801d70:	ff 75 08             	pushl  0x8(%ebp)
  801d73:	6a 29                	push   $0x29
  801d75:	e8 fc fa ff ff       	call   801876 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801d7d:	90                   	nop
}
  801d7e:	c9                   	leave  
  801d7f:	c3                   	ret    

00801d80 <inctst>:

void inctst()
{
  801d80:	55                   	push   %ebp
  801d81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 2a                	push   $0x2a
  801d8f:	e8 e2 fa ff ff       	call   801876 <syscall>
  801d94:	83 c4 18             	add    $0x18,%esp
	return ;
  801d97:	90                   	nop
}
  801d98:	c9                   	leave  
  801d99:	c3                   	ret    

00801d9a <gettst>:
uint32 gettst()
{
  801d9a:	55                   	push   %ebp
  801d9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 2b                	push   $0x2b
  801da9:	e8 c8 fa ff ff       	call   801876 <syscall>
  801dae:	83 c4 18             	add    $0x18,%esp
}
  801db1:	c9                   	leave  
  801db2:	c3                   	ret    

00801db3 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801db3:	55                   	push   %ebp
  801db4:	89 e5                	mov    %esp,%ebp
  801db6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801db9:	6a 00                	push   $0x0
  801dbb:	6a 00                	push   $0x0
  801dbd:	6a 00                	push   $0x0
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 2c                	push   $0x2c
  801dc5:	e8 ac fa ff ff       	call   801876 <syscall>
  801dca:	83 c4 18             	add    $0x18,%esp
  801dcd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801dd0:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801dd4:	75 07                	jne    801ddd <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801dd6:	b8 01 00 00 00       	mov    $0x1,%eax
  801ddb:	eb 05                	jmp    801de2 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ddd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
  801de7:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801dea:	6a 00                	push   $0x0
  801dec:	6a 00                	push   $0x0
  801dee:	6a 00                	push   $0x0
  801df0:	6a 00                	push   $0x0
  801df2:	6a 00                	push   $0x0
  801df4:	6a 2c                	push   $0x2c
  801df6:	e8 7b fa ff ff       	call   801876 <syscall>
  801dfb:	83 c4 18             	add    $0x18,%esp
  801dfe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801e01:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801e05:	75 07                	jne    801e0e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801e07:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0c:	eb 05                	jmp    801e13 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801e0e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e13:	c9                   	leave  
  801e14:	c3                   	ret    

00801e15 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801e15:	55                   	push   %ebp
  801e16:	89 e5                	mov    %esp,%ebp
  801e18:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e1b:	6a 00                	push   $0x0
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	6a 2c                	push   $0x2c
  801e27:	e8 4a fa ff ff       	call   801876 <syscall>
  801e2c:	83 c4 18             	add    $0x18,%esp
  801e2f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801e32:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801e36:	75 07                	jne    801e3f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801e38:	b8 01 00 00 00       	mov    $0x1,%eax
  801e3d:	eb 05                	jmp    801e44 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801e3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e44:	c9                   	leave  
  801e45:	c3                   	ret    

00801e46 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801e46:	55                   	push   %ebp
  801e47:	89 e5                	mov    %esp,%ebp
  801e49:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 00                	push   $0x0
  801e50:	6a 00                	push   $0x0
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 2c                	push   $0x2c
  801e58:	e8 19 fa ff ff       	call   801876 <syscall>
  801e5d:	83 c4 18             	add    $0x18,%esp
  801e60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801e63:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801e67:	75 07                	jne    801e70 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801e69:	b8 01 00 00 00       	mov    $0x1,%eax
  801e6e:	eb 05                	jmp    801e75 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801e70:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801e7a:	6a 00                	push   $0x0
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	ff 75 08             	pushl  0x8(%ebp)
  801e85:	6a 2d                	push   $0x2d
  801e87:	e8 ea f9 ff ff       	call   801876 <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8f:	90                   	nop
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
  801e95:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801e96:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801e99:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801e9c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  801ea2:	6a 00                	push   $0x0
  801ea4:	53                   	push   %ebx
  801ea5:	51                   	push   %ecx
  801ea6:	52                   	push   %edx
  801ea7:	50                   	push   %eax
  801ea8:	6a 2e                	push   $0x2e
  801eaa:	e8 c7 f9 ff ff       	call   801876 <syscall>
  801eaf:	83 c4 18             	add    $0x18,%esp
}
  801eb2:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801eb5:	c9                   	leave  
  801eb6:	c3                   	ret    

00801eb7 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801eb7:	55                   	push   %ebp
  801eb8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801eba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ebd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	52                   	push   %edx
  801ec7:	50                   	push   %eax
  801ec8:	6a 2f                	push   $0x2f
  801eca:	e8 a7 f9 ff ff       	call   801876 <syscall>
  801ecf:	83 c4 18             	add    $0x18,%esp
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
  801ed7:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801eda:	83 ec 0c             	sub    $0xc,%esp
  801edd:	68 00 3a 80 00       	push   $0x803a00
  801ee2:	e8 3e e6 ff ff       	call   800525 <cprintf>
  801ee7:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801eea:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801ef1:	83 ec 0c             	sub    $0xc,%esp
  801ef4:	68 2c 3a 80 00       	push   $0x803a2c
  801ef9:	e8 27 e6 ff ff       	call   800525 <cprintf>
  801efe:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801f01:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f05:	a1 38 41 80 00       	mov    0x804138,%eax
  801f0a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f0d:	eb 56                	jmp    801f65 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801f0f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801f13:	74 1c                	je     801f31 <print_mem_block_lists+0x5d>
  801f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f18:	8b 50 08             	mov    0x8(%eax),%edx
  801f1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f1e:	8b 48 08             	mov    0x8(%eax),%ecx
  801f21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f24:	8b 40 0c             	mov    0xc(%eax),%eax
  801f27:	01 c8                	add    %ecx,%eax
  801f29:	39 c2                	cmp    %eax,%edx
  801f2b:	73 04                	jae    801f31 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801f2d:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f34:	8b 50 08             	mov    0x8(%eax),%edx
  801f37:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f3a:	8b 40 0c             	mov    0xc(%eax),%eax
  801f3d:	01 c2                	add    %eax,%edx
  801f3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f42:	8b 40 08             	mov    0x8(%eax),%eax
  801f45:	83 ec 04             	sub    $0x4,%esp
  801f48:	52                   	push   %edx
  801f49:	50                   	push   %eax
  801f4a:	68 41 3a 80 00       	push   $0x803a41
  801f4f:	e8 d1 e5 ff ff       	call   800525 <cprintf>
  801f54:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801f5d:	a1 40 41 80 00       	mov    0x804140,%eax
  801f62:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f65:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f69:	74 07                	je     801f72 <print_mem_block_lists+0x9e>
  801f6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f6e:	8b 00                	mov    (%eax),%eax
  801f70:	eb 05                	jmp    801f77 <print_mem_block_lists+0xa3>
  801f72:	b8 00 00 00 00       	mov    $0x0,%eax
  801f77:	a3 40 41 80 00       	mov    %eax,0x804140
  801f7c:	a1 40 41 80 00       	mov    0x804140,%eax
  801f81:	85 c0                	test   %eax,%eax
  801f83:	75 8a                	jne    801f0f <print_mem_block_lists+0x3b>
  801f85:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f89:	75 84                	jne    801f0f <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801f8b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f8f:	75 10                	jne    801fa1 <print_mem_block_lists+0xcd>
  801f91:	83 ec 0c             	sub    $0xc,%esp
  801f94:	68 50 3a 80 00       	push   $0x803a50
  801f99:	e8 87 e5 ff ff       	call   800525 <cprintf>
  801f9e:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801fa1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801fa8:	83 ec 0c             	sub    $0xc,%esp
  801fab:	68 74 3a 80 00       	push   $0x803a74
  801fb0:	e8 70 e5 ff ff       	call   800525 <cprintf>
  801fb5:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801fb8:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801fbc:	a1 40 40 80 00       	mov    0x804040,%eax
  801fc1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc4:	eb 56                	jmp    80201c <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fc6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fca:	74 1c                	je     801fe8 <print_mem_block_lists+0x114>
  801fcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcf:	8b 50 08             	mov    0x8(%eax),%edx
  801fd2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd5:	8b 48 08             	mov    0x8(%eax),%ecx
  801fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fdb:	8b 40 0c             	mov    0xc(%eax),%eax
  801fde:	01 c8                	add    %ecx,%eax
  801fe0:	39 c2                	cmp    %eax,%edx
  801fe2:	73 04                	jae    801fe8 <print_mem_block_lists+0x114>
			sorted = 0 ;
  801fe4:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fe8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801feb:	8b 50 08             	mov    0x8(%eax),%edx
  801fee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff1:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff4:	01 c2                	add    %eax,%edx
  801ff6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff9:	8b 40 08             	mov    0x8(%eax),%eax
  801ffc:	83 ec 04             	sub    $0x4,%esp
  801fff:	52                   	push   %edx
  802000:	50                   	push   %eax
  802001:	68 41 3a 80 00       	push   $0x803a41
  802006:	e8 1a e5 ff ff       	call   800525 <cprintf>
  80200b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80200e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802011:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802014:	a1 48 40 80 00       	mov    0x804048,%eax
  802019:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80201c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802020:	74 07                	je     802029 <print_mem_block_lists+0x155>
  802022:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802025:	8b 00                	mov    (%eax),%eax
  802027:	eb 05                	jmp    80202e <print_mem_block_lists+0x15a>
  802029:	b8 00 00 00 00       	mov    $0x0,%eax
  80202e:	a3 48 40 80 00       	mov    %eax,0x804048
  802033:	a1 48 40 80 00       	mov    0x804048,%eax
  802038:	85 c0                	test   %eax,%eax
  80203a:	75 8a                	jne    801fc6 <print_mem_block_lists+0xf2>
  80203c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802040:	75 84                	jne    801fc6 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802042:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802046:	75 10                	jne    802058 <print_mem_block_lists+0x184>
  802048:	83 ec 0c             	sub    $0xc,%esp
  80204b:	68 8c 3a 80 00       	push   $0x803a8c
  802050:	e8 d0 e4 ff ff       	call   800525 <cprintf>
  802055:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802058:	83 ec 0c             	sub    $0xc,%esp
  80205b:	68 00 3a 80 00       	push   $0x803a00
  802060:	e8 c0 e4 ff ff       	call   800525 <cprintf>
  802065:	83 c4 10             	add    $0x10,%esp

}
  802068:	90                   	nop
  802069:	c9                   	leave  
  80206a:	c3                   	ret    

0080206b <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80206b:	55                   	push   %ebp
  80206c:	89 e5                	mov    %esp,%ebp
  80206e:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802071:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802078:	00 00 00 
  80207b:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802082:	00 00 00 
  802085:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  80208c:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80208f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802096:	e9 9e 00 00 00       	jmp    802139 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  80209b:	a1 50 40 80 00       	mov    0x804050,%eax
  8020a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020a3:	c1 e2 04             	shl    $0x4,%edx
  8020a6:	01 d0                	add    %edx,%eax
  8020a8:	85 c0                	test   %eax,%eax
  8020aa:	75 14                	jne    8020c0 <initialize_MemBlocksList+0x55>
  8020ac:	83 ec 04             	sub    $0x4,%esp
  8020af:	68 b4 3a 80 00       	push   $0x803ab4
  8020b4:	6a 3d                	push   $0x3d
  8020b6:	68 d7 3a 80 00       	push   $0x803ad7
  8020bb:	e8 b1 e1 ff ff       	call   800271 <_panic>
  8020c0:	a1 50 40 80 00       	mov    0x804050,%eax
  8020c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020c8:	c1 e2 04             	shl    $0x4,%edx
  8020cb:	01 d0                	add    %edx,%eax
  8020cd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8020d3:	89 10                	mov    %edx,(%eax)
  8020d5:	8b 00                	mov    (%eax),%eax
  8020d7:	85 c0                	test   %eax,%eax
  8020d9:	74 18                	je     8020f3 <initialize_MemBlocksList+0x88>
  8020db:	a1 48 41 80 00       	mov    0x804148,%eax
  8020e0:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8020e6:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8020e9:	c1 e1 04             	shl    $0x4,%ecx
  8020ec:	01 ca                	add    %ecx,%edx
  8020ee:	89 50 04             	mov    %edx,0x4(%eax)
  8020f1:	eb 12                	jmp    802105 <initialize_MemBlocksList+0x9a>
  8020f3:	a1 50 40 80 00       	mov    0x804050,%eax
  8020f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8020fb:	c1 e2 04             	shl    $0x4,%edx
  8020fe:	01 d0                	add    %edx,%eax
  802100:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802105:	a1 50 40 80 00       	mov    0x804050,%eax
  80210a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80210d:	c1 e2 04             	shl    $0x4,%edx
  802110:	01 d0                	add    %edx,%eax
  802112:	a3 48 41 80 00       	mov    %eax,0x804148
  802117:	a1 50 40 80 00       	mov    0x804050,%eax
  80211c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80211f:	c1 e2 04             	shl    $0x4,%edx
  802122:	01 d0                	add    %edx,%eax
  802124:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80212b:	a1 54 41 80 00       	mov    0x804154,%eax
  802130:	40                   	inc    %eax
  802131:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802136:	ff 45 f4             	incl   -0xc(%ebp)
  802139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80213f:	0f 82 56 ff ff ff    	jb     80209b <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802145:	90                   	nop
  802146:	c9                   	leave  
  802147:	c3                   	ret    

00802148 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802148:	55                   	push   %ebp
  802149:	89 e5                	mov    %esp,%ebp
  80214b:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  80214e:	8b 45 08             	mov    0x8(%ebp),%eax
  802151:	8b 00                	mov    (%eax),%eax
  802153:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802156:	eb 18                	jmp    802170 <find_block+0x28>

		if(tmp->sva == va){
  802158:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80215b:	8b 40 08             	mov    0x8(%eax),%eax
  80215e:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802161:	75 05                	jne    802168 <find_block+0x20>
			return tmp ;
  802163:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802166:	eb 11                	jmp    802179 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802168:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80216b:	8b 00                	mov    (%eax),%eax
  80216d:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802170:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802174:	75 e2                	jne    802158 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802176:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802179:	c9                   	leave  
  80217a:	c3                   	ret    

0080217b <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80217b:	55                   	push   %ebp
  80217c:	89 e5                	mov    %esp,%ebp
  80217e:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802181:	a1 40 40 80 00       	mov    0x804040,%eax
  802186:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802189:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80218e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802191:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802195:	75 65                	jne    8021fc <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802197:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80219b:	75 14                	jne    8021b1 <insert_sorted_allocList+0x36>
  80219d:	83 ec 04             	sub    $0x4,%esp
  8021a0:	68 b4 3a 80 00       	push   $0x803ab4
  8021a5:	6a 62                	push   $0x62
  8021a7:	68 d7 3a 80 00       	push   $0x803ad7
  8021ac:	e8 c0 e0 ff ff       	call   800271 <_panic>
  8021b1:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8021b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ba:	89 10                	mov    %edx,(%eax)
  8021bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021bf:	8b 00                	mov    (%eax),%eax
  8021c1:	85 c0                	test   %eax,%eax
  8021c3:	74 0d                	je     8021d2 <insert_sorted_allocList+0x57>
  8021c5:	a1 40 40 80 00       	mov    0x804040,%eax
  8021ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8021cd:	89 50 04             	mov    %edx,0x4(%eax)
  8021d0:	eb 08                	jmp    8021da <insert_sorted_allocList+0x5f>
  8021d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021d5:	a3 44 40 80 00       	mov    %eax,0x804044
  8021da:	8b 45 08             	mov    0x8(%ebp),%eax
  8021dd:	a3 40 40 80 00       	mov    %eax,0x804040
  8021e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8021e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ec:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8021f1:	40                   	inc    %eax
  8021f2:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8021f7:	e9 14 01 00 00       	jmp    802310 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  8021fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ff:	8b 50 08             	mov    0x8(%eax),%edx
  802202:	a1 44 40 80 00       	mov    0x804044,%eax
  802207:	8b 40 08             	mov    0x8(%eax),%eax
  80220a:	39 c2                	cmp    %eax,%edx
  80220c:	76 65                	jbe    802273 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80220e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802212:	75 14                	jne    802228 <insert_sorted_allocList+0xad>
  802214:	83 ec 04             	sub    $0x4,%esp
  802217:	68 f0 3a 80 00       	push   $0x803af0
  80221c:	6a 64                	push   $0x64
  80221e:	68 d7 3a 80 00       	push   $0x803ad7
  802223:	e8 49 e0 ff ff       	call   800271 <_panic>
  802228:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80222e:	8b 45 08             	mov    0x8(%ebp),%eax
  802231:	89 50 04             	mov    %edx,0x4(%eax)
  802234:	8b 45 08             	mov    0x8(%ebp),%eax
  802237:	8b 40 04             	mov    0x4(%eax),%eax
  80223a:	85 c0                	test   %eax,%eax
  80223c:	74 0c                	je     80224a <insert_sorted_allocList+0xcf>
  80223e:	a1 44 40 80 00       	mov    0x804044,%eax
  802243:	8b 55 08             	mov    0x8(%ebp),%edx
  802246:	89 10                	mov    %edx,(%eax)
  802248:	eb 08                	jmp    802252 <insert_sorted_allocList+0xd7>
  80224a:	8b 45 08             	mov    0x8(%ebp),%eax
  80224d:	a3 40 40 80 00       	mov    %eax,0x804040
  802252:	8b 45 08             	mov    0x8(%ebp),%eax
  802255:	a3 44 40 80 00       	mov    %eax,0x804044
  80225a:	8b 45 08             	mov    0x8(%ebp),%eax
  80225d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802263:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802268:	40                   	inc    %eax
  802269:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80226e:	e9 9d 00 00 00       	jmp    802310 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802273:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80227a:	e9 85 00 00 00       	jmp    802304 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  80227f:	8b 45 08             	mov    0x8(%ebp),%eax
  802282:	8b 50 08             	mov    0x8(%eax),%edx
  802285:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802288:	8b 40 08             	mov    0x8(%eax),%eax
  80228b:	39 c2                	cmp    %eax,%edx
  80228d:	73 6a                	jae    8022f9 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  80228f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802293:	74 06                	je     80229b <insert_sorted_allocList+0x120>
  802295:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802299:	75 14                	jne    8022af <insert_sorted_allocList+0x134>
  80229b:	83 ec 04             	sub    $0x4,%esp
  80229e:	68 14 3b 80 00       	push   $0x803b14
  8022a3:	6a 6b                	push   $0x6b
  8022a5:	68 d7 3a 80 00       	push   $0x803ad7
  8022aa:	e8 c2 df ff ff       	call   800271 <_panic>
  8022af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b2:	8b 50 04             	mov    0x4(%eax),%edx
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	89 50 04             	mov    %edx,0x4(%eax)
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022c1:	89 10                	mov    %edx,(%eax)
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 40 04             	mov    0x4(%eax),%eax
  8022c9:	85 c0                	test   %eax,%eax
  8022cb:	74 0d                	je     8022da <insert_sorted_allocList+0x15f>
  8022cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d0:	8b 40 04             	mov    0x4(%eax),%eax
  8022d3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022d6:	89 10                	mov    %edx,(%eax)
  8022d8:	eb 08                	jmp    8022e2 <insert_sorted_allocList+0x167>
  8022da:	8b 45 08             	mov    0x8(%ebp),%eax
  8022dd:	a3 40 40 80 00       	mov    %eax,0x804040
  8022e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8022e8:	89 50 04             	mov    %edx,0x4(%eax)
  8022eb:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022f0:	40                   	inc    %eax
  8022f1:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  8022f6:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8022f7:	eb 17                	jmp    802310 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  8022f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022fc:	8b 00                	mov    (%eax),%eax
  8022fe:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802301:	ff 45 f0             	incl   -0x10(%ebp)
  802304:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802307:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80230a:	0f 8c 6f ff ff ff    	jl     80227f <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802310:	90                   	nop
  802311:	c9                   	leave  
  802312:	c3                   	ret    

00802313 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802313:	55                   	push   %ebp
  802314:	89 e5                	mov    %esp,%ebp
  802316:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802319:	a1 38 41 80 00       	mov    0x804138,%eax
  80231e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802321:	e9 7c 01 00 00       	jmp    8024a2 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802329:	8b 40 0c             	mov    0xc(%eax),%eax
  80232c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80232f:	0f 86 cf 00 00 00    	jbe    802404 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802335:	a1 48 41 80 00       	mov    0x804148,%eax
  80233a:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  80233d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802340:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802343:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802346:	8b 55 08             	mov    0x8(%ebp),%edx
  802349:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  80234c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234f:	8b 50 08             	mov    0x8(%eax),%edx
  802352:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802355:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80235b:	8b 40 0c             	mov    0xc(%eax),%eax
  80235e:	2b 45 08             	sub    0x8(%ebp),%eax
  802361:	89 c2                	mov    %eax,%edx
  802363:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802366:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802369:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80236c:	8b 50 08             	mov    0x8(%eax),%edx
  80236f:	8b 45 08             	mov    0x8(%ebp),%eax
  802372:	01 c2                	add    %eax,%edx
  802374:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802377:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80237a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80237e:	75 17                	jne    802397 <alloc_block_FF+0x84>
  802380:	83 ec 04             	sub    $0x4,%esp
  802383:	68 49 3b 80 00       	push   $0x803b49
  802388:	68 83 00 00 00       	push   $0x83
  80238d:	68 d7 3a 80 00       	push   $0x803ad7
  802392:	e8 da de ff ff       	call   800271 <_panic>
  802397:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80239a:	8b 00                	mov    (%eax),%eax
  80239c:	85 c0                	test   %eax,%eax
  80239e:	74 10                	je     8023b0 <alloc_block_FF+0x9d>
  8023a0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023a3:	8b 00                	mov    (%eax),%eax
  8023a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023a8:	8b 52 04             	mov    0x4(%edx),%edx
  8023ab:	89 50 04             	mov    %edx,0x4(%eax)
  8023ae:	eb 0b                	jmp    8023bb <alloc_block_FF+0xa8>
  8023b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023b3:	8b 40 04             	mov    0x4(%eax),%eax
  8023b6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8023bb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023be:	8b 40 04             	mov    0x4(%eax),%eax
  8023c1:	85 c0                	test   %eax,%eax
  8023c3:	74 0f                	je     8023d4 <alloc_block_FF+0xc1>
  8023c5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023c8:	8b 40 04             	mov    0x4(%eax),%eax
  8023cb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8023ce:	8b 12                	mov    (%edx),%edx
  8023d0:	89 10                	mov    %edx,(%eax)
  8023d2:	eb 0a                	jmp    8023de <alloc_block_FF+0xcb>
  8023d4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023d7:	8b 00                	mov    (%eax),%eax
  8023d9:	a3 48 41 80 00       	mov    %eax,0x804148
  8023de:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023f1:	a1 54 41 80 00       	mov    0x804154,%eax
  8023f6:	48                   	dec    %eax
  8023f7:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  8023fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023ff:	e9 ad 00 00 00       	jmp    8024b1 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	8b 40 0c             	mov    0xc(%eax),%eax
  80240a:	3b 45 08             	cmp    0x8(%ebp),%eax
  80240d:	0f 85 87 00 00 00    	jne    80249a <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802413:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802417:	75 17                	jne    802430 <alloc_block_FF+0x11d>
  802419:	83 ec 04             	sub    $0x4,%esp
  80241c:	68 49 3b 80 00       	push   $0x803b49
  802421:	68 87 00 00 00       	push   $0x87
  802426:	68 d7 3a 80 00       	push   $0x803ad7
  80242b:	e8 41 de ff ff       	call   800271 <_panic>
  802430:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802433:	8b 00                	mov    (%eax),%eax
  802435:	85 c0                	test   %eax,%eax
  802437:	74 10                	je     802449 <alloc_block_FF+0x136>
  802439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243c:	8b 00                	mov    (%eax),%eax
  80243e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802441:	8b 52 04             	mov    0x4(%edx),%edx
  802444:	89 50 04             	mov    %edx,0x4(%eax)
  802447:	eb 0b                	jmp    802454 <alloc_block_FF+0x141>
  802449:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80244c:	8b 40 04             	mov    0x4(%eax),%eax
  80244f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802454:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802457:	8b 40 04             	mov    0x4(%eax),%eax
  80245a:	85 c0                	test   %eax,%eax
  80245c:	74 0f                	je     80246d <alloc_block_FF+0x15a>
  80245e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802461:	8b 40 04             	mov    0x4(%eax),%eax
  802464:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802467:	8b 12                	mov    (%edx),%edx
  802469:	89 10                	mov    %edx,(%eax)
  80246b:	eb 0a                	jmp    802477 <alloc_block_FF+0x164>
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	8b 00                	mov    (%eax),%eax
  802472:	a3 38 41 80 00       	mov    %eax,0x804138
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802480:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802483:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80248a:	a1 44 41 80 00       	mov    0x804144,%eax
  80248f:	48                   	dec    %eax
  802490:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	eb 17                	jmp    8024b1 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  80249a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249d:	8b 00                	mov    (%eax),%eax
  80249f:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8024a2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024a6:	0f 85 7a fe ff ff    	jne    802326 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8024ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024b1:	c9                   	leave  
  8024b2:	c3                   	ret    

008024b3 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8024b3:	55                   	push   %ebp
  8024b4:	89 e5                	mov    %esp,%ebp
  8024b6:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8024b9:	a1 38 41 80 00       	mov    0x804138,%eax
  8024be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8024c1:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8024c8:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8024cf:	a1 38 41 80 00       	mov    0x804138,%eax
  8024d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024d7:	e9 d0 00 00 00       	jmp    8025ac <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8024dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024df:	8b 40 0c             	mov    0xc(%eax),%eax
  8024e2:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024e5:	0f 82 b8 00 00 00    	jb     8025a3 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  8024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ee:	8b 40 0c             	mov    0xc(%eax),%eax
  8024f1:	2b 45 08             	sub    0x8(%ebp),%eax
  8024f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  8024f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8024fa:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8024fd:	0f 83 a1 00 00 00    	jae    8025a4 <alloc_block_BF+0xf1>
				differsize = differance ;
  802503:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802506:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80250f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802513:	0f 85 8b 00 00 00    	jne    8025a4 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802519:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80251d:	75 17                	jne    802536 <alloc_block_BF+0x83>
  80251f:	83 ec 04             	sub    $0x4,%esp
  802522:	68 49 3b 80 00       	push   $0x803b49
  802527:	68 a0 00 00 00       	push   $0xa0
  80252c:	68 d7 3a 80 00       	push   $0x803ad7
  802531:	e8 3b dd ff ff       	call   800271 <_panic>
  802536:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802539:	8b 00                	mov    (%eax),%eax
  80253b:	85 c0                	test   %eax,%eax
  80253d:	74 10                	je     80254f <alloc_block_BF+0x9c>
  80253f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802542:	8b 00                	mov    (%eax),%eax
  802544:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802547:	8b 52 04             	mov    0x4(%edx),%edx
  80254a:	89 50 04             	mov    %edx,0x4(%eax)
  80254d:	eb 0b                	jmp    80255a <alloc_block_BF+0xa7>
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 40 04             	mov    0x4(%eax),%eax
  802555:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80255a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255d:	8b 40 04             	mov    0x4(%eax),%eax
  802560:	85 c0                	test   %eax,%eax
  802562:	74 0f                	je     802573 <alloc_block_BF+0xc0>
  802564:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802567:	8b 40 04             	mov    0x4(%eax),%eax
  80256a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256d:	8b 12                	mov    (%edx),%edx
  80256f:	89 10                	mov    %edx,(%eax)
  802571:	eb 0a                	jmp    80257d <alloc_block_BF+0xca>
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 00                	mov    (%eax),%eax
  802578:	a3 38 41 80 00       	mov    %eax,0x804138
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802586:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802589:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802590:	a1 44 41 80 00       	mov    0x804144,%eax
  802595:	48                   	dec    %eax
  802596:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  80259b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259e:	e9 0c 01 00 00       	jmp    8026af <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8025a3:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8025a4:	a1 40 41 80 00       	mov    0x804140,%eax
  8025a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025ac:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025b0:	74 07                	je     8025b9 <alloc_block_BF+0x106>
  8025b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b5:	8b 00                	mov    (%eax),%eax
  8025b7:	eb 05                	jmp    8025be <alloc_block_BF+0x10b>
  8025b9:	b8 00 00 00 00       	mov    $0x0,%eax
  8025be:	a3 40 41 80 00       	mov    %eax,0x804140
  8025c3:	a1 40 41 80 00       	mov    0x804140,%eax
  8025c8:	85 c0                	test   %eax,%eax
  8025ca:	0f 85 0c ff ff ff    	jne    8024dc <alloc_block_BF+0x29>
  8025d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d4:	0f 85 02 ff ff ff    	jne    8024dc <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  8025da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025de:	0f 84 c6 00 00 00    	je     8026aa <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  8025e4:	a1 48 41 80 00       	mov    0x804148,%eax
  8025e9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  8025ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025ef:	8b 55 08             	mov    0x8(%ebp),%edx
  8025f2:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  8025f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025f8:	8b 50 08             	mov    0x8(%eax),%edx
  8025fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025fe:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802601:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802604:	8b 40 0c             	mov    0xc(%eax),%eax
  802607:	2b 45 08             	sub    0x8(%ebp),%eax
  80260a:	89 c2                	mov    %eax,%edx
  80260c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80260f:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802612:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802615:	8b 50 08             	mov    0x8(%eax),%edx
  802618:	8b 45 08             	mov    0x8(%ebp),%eax
  80261b:	01 c2                	add    %eax,%edx
  80261d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802620:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802623:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802627:	75 17                	jne    802640 <alloc_block_BF+0x18d>
  802629:	83 ec 04             	sub    $0x4,%esp
  80262c:	68 49 3b 80 00       	push   $0x803b49
  802631:	68 af 00 00 00       	push   $0xaf
  802636:	68 d7 3a 80 00       	push   $0x803ad7
  80263b:	e8 31 dc ff ff       	call   800271 <_panic>
  802640:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802643:	8b 00                	mov    (%eax),%eax
  802645:	85 c0                	test   %eax,%eax
  802647:	74 10                	je     802659 <alloc_block_BF+0x1a6>
  802649:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80264c:	8b 00                	mov    (%eax),%eax
  80264e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802651:	8b 52 04             	mov    0x4(%edx),%edx
  802654:	89 50 04             	mov    %edx,0x4(%eax)
  802657:	eb 0b                	jmp    802664 <alloc_block_BF+0x1b1>
  802659:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80265c:	8b 40 04             	mov    0x4(%eax),%eax
  80265f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802664:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802667:	8b 40 04             	mov    0x4(%eax),%eax
  80266a:	85 c0                	test   %eax,%eax
  80266c:	74 0f                	je     80267d <alloc_block_BF+0x1ca>
  80266e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802671:	8b 40 04             	mov    0x4(%eax),%eax
  802674:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802677:	8b 12                	mov    (%edx),%edx
  802679:	89 10                	mov    %edx,(%eax)
  80267b:	eb 0a                	jmp    802687 <alloc_block_BF+0x1d4>
  80267d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802680:	8b 00                	mov    (%eax),%eax
  802682:	a3 48 41 80 00       	mov    %eax,0x804148
  802687:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80268a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802690:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802693:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80269a:	a1 54 41 80 00       	mov    0x804154,%eax
  80269f:	48                   	dec    %eax
  8026a0:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8026a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a8:	eb 05                	jmp    8026af <alloc_block_BF+0x1fc>
	}

	return NULL;
  8026aa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026af:	c9                   	leave  
  8026b0:	c3                   	ret    

008026b1 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8026b1:	55                   	push   %ebp
  8026b2:	89 e5                	mov    %esp,%ebp
  8026b4:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8026b7:	a1 38 41 80 00       	mov    0x804138,%eax
  8026bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8026bf:	e9 7c 01 00 00       	jmp    802840 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8026c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026c7:	8b 40 0c             	mov    0xc(%eax),%eax
  8026ca:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026cd:	0f 86 cf 00 00 00    	jbe    8027a2 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8026d3:	a1 48 41 80 00       	mov    0x804148,%eax
  8026d8:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8026db:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026de:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  8026e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8026e7:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  8026ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ed:	8b 50 08             	mov    0x8(%eax),%edx
  8026f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026f3:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  8026f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026f9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026fc:	2b 45 08             	sub    0x8(%ebp),%eax
  8026ff:	89 c2                	mov    %eax,%edx
  802701:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802704:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802707:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270a:	8b 50 08             	mov    0x8(%eax),%edx
  80270d:	8b 45 08             	mov    0x8(%ebp),%eax
  802710:	01 c2                	add    %eax,%edx
  802712:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802715:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802718:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80271c:	75 17                	jne    802735 <alloc_block_NF+0x84>
  80271e:	83 ec 04             	sub    $0x4,%esp
  802721:	68 49 3b 80 00       	push   $0x803b49
  802726:	68 c4 00 00 00       	push   $0xc4
  80272b:	68 d7 3a 80 00       	push   $0x803ad7
  802730:	e8 3c db ff ff       	call   800271 <_panic>
  802735:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802738:	8b 00                	mov    (%eax),%eax
  80273a:	85 c0                	test   %eax,%eax
  80273c:	74 10                	je     80274e <alloc_block_NF+0x9d>
  80273e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802741:	8b 00                	mov    (%eax),%eax
  802743:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802746:	8b 52 04             	mov    0x4(%edx),%edx
  802749:	89 50 04             	mov    %edx,0x4(%eax)
  80274c:	eb 0b                	jmp    802759 <alloc_block_NF+0xa8>
  80274e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802751:	8b 40 04             	mov    0x4(%eax),%eax
  802754:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802759:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80275c:	8b 40 04             	mov    0x4(%eax),%eax
  80275f:	85 c0                	test   %eax,%eax
  802761:	74 0f                	je     802772 <alloc_block_NF+0xc1>
  802763:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802766:	8b 40 04             	mov    0x4(%eax),%eax
  802769:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80276c:	8b 12                	mov    (%edx),%edx
  80276e:	89 10                	mov    %edx,(%eax)
  802770:	eb 0a                	jmp    80277c <alloc_block_NF+0xcb>
  802772:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802775:	8b 00                	mov    (%eax),%eax
  802777:	a3 48 41 80 00       	mov    %eax,0x804148
  80277c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80277f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802785:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802788:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80278f:	a1 54 41 80 00       	mov    0x804154,%eax
  802794:	48                   	dec    %eax
  802795:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  80279a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80279d:	e9 ad 00 00 00       	jmp    80284f <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8027a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a5:	8b 40 0c             	mov    0xc(%eax),%eax
  8027a8:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ab:	0f 85 87 00 00 00    	jne    802838 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8027b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027b5:	75 17                	jne    8027ce <alloc_block_NF+0x11d>
  8027b7:	83 ec 04             	sub    $0x4,%esp
  8027ba:	68 49 3b 80 00       	push   $0x803b49
  8027bf:	68 c8 00 00 00       	push   $0xc8
  8027c4:	68 d7 3a 80 00       	push   $0x803ad7
  8027c9:	e8 a3 da ff ff       	call   800271 <_panic>
  8027ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d1:	8b 00                	mov    (%eax),%eax
  8027d3:	85 c0                	test   %eax,%eax
  8027d5:	74 10                	je     8027e7 <alloc_block_NF+0x136>
  8027d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027da:	8b 00                	mov    (%eax),%eax
  8027dc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027df:	8b 52 04             	mov    0x4(%edx),%edx
  8027e2:	89 50 04             	mov    %edx,0x4(%eax)
  8027e5:	eb 0b                	jmp    8027f2 <alloc_block_NF+0x141>
  8027e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ea:	8b 40 04             	mov    0x4(%eax),%eax
  8027ed:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f5:	8b 40 04             	mov    0x4(%eax),%eax
  8027f8:	85 c0                	test   %eax,%eax
  8027fa:	74 0f                	je     80280b <alloc_block_NF+0x15a>
  8027fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ff:	8b 40 04             	mov    0x4(%eax),%eax
  802802:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802805:	8b 12                	mov    (%edx),%edx
  802807:	89 10                	mov    %edx,(%eax)
  802809:	eb 0a                	jmp    802815 <alloc_block_NF+0x164>
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	8b 00                	mov    (%eax),%eax
  802810:	a3 38 41 80 00       	mov    %eax,0x804138
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80281e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802821:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802828:	a1 44 41 80 00       	mov    0x804144,%eax
  80282d:	48                   	dec    %eax
  80282e:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	eb 17                	jmp    80284f <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802838:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80283b:	8b 00                	mov    (%eax),%eax
  80283d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802840:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802844:	0f 85 7a fe ff ff    	jne    8026c4 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  80284a:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80284f:	c9                   	leave  
  802850:	c3                   	ret    

00802851 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802851:	55                   	push   %ebp
  802852:	89 e5                	mov    %esp,%ebp
  802854:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802857:	a1 38 41 80 00       	mov    0x804138,%eax
  80285c:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  80285f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802864:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802867:	a1 44 41 80 00       	mov    0x804144,%eax
  80286c:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  80286f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802873:	75 68                	jne    8028dd <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802875:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802879:	75 17                	jne    802892 <insert_sorted_with_merge_freeList+0x41>
  80287b:	83 ec 04             	sub    $0x4,%esp
  80287e:	68 b4 3a 80 00       	push   $0x803ab4
  802883:	68 da 00 00 00       	push   $0xda
  802888:	68 d7 3a 80 00       	push   $0x803ad7
  80288d:	e8 df d9 ff ff       	call   800271 <_panic>
  802892:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802898:	8b 45 08             	mov    0x8(%ebp),%eax
  80289b:	89 10                	mov    %edx,(%eax)
  80289d:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a0:	8b 00                	mov    (%eax),%eax
  8028a2:	85 c0                	test   %eax,%eax
  8028a4:	74 0d                	je     8028b3 <insert_sorted_with_merge_freeList+0x62>
  8028a6:	a1 38 41 80 00       	mov    0x804138,%eax
  8028ab:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ae:	89 50 04             	mov    %edx,0x4(%eax)
  8028b1:	eb 08                	jmp    8028bb <insert_sorted_with_merge_freeList+0x6a>
  8028b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028b6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028be:	a3 38 41 80 00       	mov    %eax,0x804138
  8028c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028c6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028cd:	a1 44 41 80 00       	mov    0x804144,%eax
  8028d2:	40                   	inc    %eax
  8028d3:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  8028d8:	e9 49 07 00 00       	jmp    803026 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  8028dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e0:	8b 50 08             	mov    0x8(%eax),%edx
  8028e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8028e9:	01 c2                	add    %eax,%edx
  8028eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ee:	8b 40 08             	mov    0x8(%eax),%eax
  8028f1:	39 c2                	cmp    %eax,%edx
  8028f3:	73 77                	jae    80296c <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  8028f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8028f8:	8b 00                	mov    (%eax),%eax
  8028fa:	85 c0                	test   %eax,%eax
  8028fc:	75 6e                	jne    80296c <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  8028fe:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802902:	74 68                	je     80296c <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802904:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802908:	75 17                	jne    802921 <insert_sorted_with_merge_freeList+0xd0>
  80290a:	83 ec 04             	sub    $0x4,%esp
  80290d:	68 f0 3a 80 00       	push   $0x803af0
  802912:	68 e0 00 00 00       	push   $0xe0
  802917:	68 d7 3a 80 00       	push   $0x803ad7
  80291c:	e8 50 d9 ff ff       	call   800271 <_panic>
  802921:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802927:	8b 45 08             	mov    0x8(%ebp),%eax
  80292a:	89 50 04             	mov    %edx,0x4(%eax)
  80292d:	8b 45 08             	mov    0x8(%ebp),%eax
  802930:	8b 40 04             	mov    0x4(%eax),%eax
  802933:	85 c0                	test   %eax,%eax
  802935:	74 0c                	je     802943 <insert_sorted_with_merge_freeList+0xf2>
  802937:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80293c:	8b 55 08             	mov    0x8(%ebp),%edx
  80293f:	89 10                	mov    %edx,(%eax)
  802941:	eb 08                	jmp    80294b <insert_sorted_with_merge_freeList+0xfa>
  802943:	8b 45 08             	mov    0x8(%ebp),%eax
  802946:	a3 38 41 80 00       	mov    %eax,0x804138
  80294b:	8b 45 08             	mov    0x8(%ebp),%eax
  80294e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802953:	8b 45 08             	mov    0x8(%ebp),%eax
  802956:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80295c:	a1 44 41 80 00       	mov    0x804144,%eax
  802961:	40                   	inc    %eax
  802962:	a3 44 41 80 00       	mov    %eax,0x804144
  802967:	e9 ba 06 00 00       	jmp    803026 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  80296c:	8b 45 08             	mov    0x8(%ebp),%eax
  80296f:	8b 50 0c             	mov    0xc(%eax),%edx
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	8b 40 08             	mov    0x8(%eax),%eax
  802978:	01 c2                	add    %eax,%edx
  80297a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80297d:	8b 40 08             	mov    0x8(%eax),%eax
  802980:	39 c2                	cmp    %eax,%edx
  802982:	73 78                	jae    8029fc <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802984:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802987:	8b 40 04             	mov    0x4(%eax),%eax
  80298a:	85 c0                	test   %eax,%eax
  80298c:	75 6e                	jne    8029fc <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  80298e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802992:	74 68                	je     8029fc <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802994:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802998:	75 17                	jne    8029b1 <insert_sorted_with_merge_freeList+0x160>
  80299a:	83 ec 04             	sub    $0x4,%esp
  80299d:	68 b4 3a 80 00       	push   $0x803ab4
  8029a2:	68 e6 00 00 00       	push   $0xe6
  8029a7:	68 d7 3a 80 00       	push   $0x803ad7
  8029ac:	e8 c0 d8 ff ff       	call   800271 <_panic>
  8029b1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	89 10                	mov    %edx,(%eax)
  8029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bf:	8b 00                	mov    (%eax),%eax
  8029c1:	85 c0                	test   %eax,%eax
  8029c3:	74 0d                	je     8029d2 <insert_sorted_with_merge_freeList+0x181>
  8029c5:	a1 38 41 80 00       	mov    0x804138,%eax
  8029ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cd:	89 50 04             	mov    %edx,0x4(%eax)
  8029d0:	eb 08                	jmp    8029da <insert_sorted_with_merge_freeList+0x189>
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	a3 38 41 80 00       	mov    %eax,0x804138
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ec:	a1 44 41 80 00       	mov    0x804144,%eax
  8029f1:	40                   	inc    %eax
  8029f2:	a3 44 41 80 00       	mov    %eax,0x804144
  8029f7:	e9 2a 06 00 00       	jmp    803026 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8029fc:	a1 38 41 80 00       	mov    0x804138,%eax
  802a01:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a04:	e9 ed 05 00 00       	jmp    802ff6 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802a09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802a11:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802a15:	0f 84 a7 00 00 00    	je     802ac2 <insert_sorted_with_merge_freeList+0x271>
  802a1b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a1e:	8b 50 0c             	mov    0xc(%eax),%edx
  802a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a24:	8b 40 08             	mov    0x8(%eax),%eax
  802a27:	01 c2                	add    %eax,%edx
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	8b 40 08             	mov    0x8(%eax),%eax
  802a2f:	39 c2                	cmp    %eax,%edx
  802a31:	0f 83 8b 00 00 00    	jae    802ac2 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	8b 50 0c             	mov    0xc(%eax),%edx
  802a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802a40:	8b 40 08             	mov    0x8(%eax),%eax
  802a43:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802a45:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a48:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802a4b:	39 c2                	cmp    %eax,%edx
  802a4d:	73 73                	jae    802ac2 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802a4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a53:	74 06                	je     802a5b <insert_sorted_with_merge_freeList+0x20a>
  802a55:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a59:	75 17                	jne    802a72 <insert_sorted_with_merge_freeList+0x221>
  802a5b:	83 ec 04             	sub    $0x4,%esp
  802a5e:	68 68 3b 80 00       	push   $0x803b68
  802a63:	68 f0 00 00 00       	push   $0xf0
  802a68:	68 d7 3a 80 00       	push   $0x803ad7
  802a6d:	e8 ff d7 ff ff       	call   800271 <_panic>
  802a72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a75:	8b 10                	mov    (%eax),%edx
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	89 10                	mov    %edx,(%eax)
  802a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7f:	8b 00                	mov    (%eax),%eax
  802a81:	85 c0                	test   %eax,%eax
  802a83:	74 0b                	je     802a90 <insert_sorted_with_merge_freeList+0x23f>
  802a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a88:	8b 00                	mov    (%eax),%eax
  802a8a:	8b 55 08             	mov    0x8(%ebp),%edx
  802a8d:	89 50 04             	mov    %edx,0x4(%eax)
  802a90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a93:	8b 55 08             	mov    0x8(%ebp),%edx
  802a96:	89 10                	mov    %edx,(%eax)
  802a98:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a9e:	89 50 04             	mov    %edx,0x4(%eax)
  802aa1:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa4:	8b 00                	mov    (%eax),%eax
  802aa6:	85 c0                	test   %eax,%eax
  802aa8:	75 08                	jne    802ab2 <insert_sorted_with_merge_freeList+0x261>
  802aaa:	8b 45 08             	mov    0x8(%ebp),%eax
  802aad:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ab2:	a1 44 41 80 00       	mov    0x804144,%eax
  802ab7:	40                   	inc    %eax
  802ab8:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802abd:	e9 64 05 00 00       	jmp    803026 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802ac2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ac7:	8b 50 0c             	mov    0xc(%eax),%edx
  802aca:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802acf:	8b 40 08             	mov    0x8(%eax),%eax
  802ad2:	01 c2                	add    %eax,%edx
  802ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad7:	8b 40 08             	mov    0x8(%eax),%eax
  802ada:	39 c2                	cmp    %eax,%edx
  802adc:	0f 85 b1 00 00 00    	jne    802b93 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802ae2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ae7:	85 c0                	test   %eax,%eax
  802ae9:	0f 84 a4 00 00 00    	je     802b93 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802aef:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802af4:	8b 00                	mov    (%eax),%eax
  802af6:	85 c0                	test   %eax,%eax
  802af8:	0f 85 95 00 00 00    	jne    802b93 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802afe:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b03:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802b09:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b0c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b0f:	8b 52 0c             	mov    0xc(%edx),%edx
  802b12:	01 ca                	add    %ecx,%edx
  802b14:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802b17:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802b21:	8b 45 08             	mov    0x8(%ebp),%eax
  802b24:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802b2b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b2f:	75 17                	jne    802b48 <insert_sorted_with_merge_freeList+0x2f7>
  802b31:	83 ec 04             	sub    $0x4,%esp
  802b34:	68 b4 3a 80 00       	push   $0x803ab4
  802b39:	68 ff 00 00 00       	push   $0xff
  802b3e:	68 d7 3a 80 00       	push   $0x803ad7
  802b43:	e8 29 d7 ff ff       	call   800271 <_panic>
  802b48:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b51:	89 10                	mov    %edx,(%eax)
  802b53:	8b 45 08             	mov    0x8(%ebp),%eax
  802b56:	8b 00                	mov    (%eax),%eax
  802b58:	85 c0                	test   %eax,%eax
  802b5a:	74 0d                	je     802b69 <insert_sorted_with_merge_freeList+0x318>
  802b5c:	a1 48 41 80 00       	mov    0x804148,%eax
  802b61:	8b 55 08             	mov    0x8(%ebp),%edx
  802b64:	89 50 04             	mov    %edx,0x4(%eax)
  802b67:	eb 08                	jmp    802b71 <insert_sorted_with_merge_freeList+0x320>
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b71:	8b 45 08             	mov    0x8(%ebp),%eax
  802b74:	a3 48 41 80 00       	mov    %eax,0x804148
  802b79:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b83:	a1 54 41 80 00       	mov    0x804154,%eax
  802b88:	40                   	inc    %eax
  802b89:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802b8e:	e9 93 04 00 00       	jmp    803026 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802b93:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b96:	8b 50 08             	mov    0x8(%eax),%edx
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9f:	01 c2                	add    %eax,%edx
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	8b 40 08             	mov    0x8(%eax),%eax
  802ba7:	39 c2                	cmp    %eax,%edx
  802ba9:	0f 85 ae 00 00 00    	jne    802c5d <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802baf:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb2:	8b 50 0c             	mov    0xc(%eax),%edx
  802bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb8:	8b 40 08             	mov    0x8(%eax),%eax
  802bbb:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc0:	8b 00                	mov    (%eax),%eax
  802bc2:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802bc5:	39 c2                	cmp    %eax,%edx
  802bc7:	0f 84 90 00 00 00    	je     802c5d <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802bcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd0:	8b 50 0c             	mov    0xc(%eax),%edx
  802bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bd9:	01 c2                	add    %eax,%edx
  802bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bde:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802be1:	8b 45 08             	mov    0x8(%ebp),%eax
  802be4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802beb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bee:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802bf5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf9:	75 17                	jne    802c12 <insert_sorted_with_merge_freeList+0x3c1>
  802bfb:	83 ec 04             	sub    $0x4,%esp
  802bfe:	68 b4 3a 80 00       	push   $0x803ab4
  802c03:	68 0b 01 00 00       	push   $0x10b
  802c08:	68 d7 3a 80 00       	push   $0x803ad7
  802c0d:	e8 5f d6 ff ff       	call   800271 <_panic>
  802c12:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c18:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1b:	89 10                	mov    %edx,(%eax)
  802c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	85 c0                	test   %eax,%eax
  802c24:	74 0d                	je     802c33 <insert_sorted_with_merge_freeList+0x3e2>
  802c26:	a1 48 41 80 00       	mov    0x804148,%eax
  802c2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2e:	89 50 04             	mov    %edx,0x4(%eax)
  802c31:	eb 08                	jmp    802c3b <insert_sorted_with_merge_freeList+0x3ea>
  802c33:	8b 45 08             	mov    0x8(%ebp),%eax
  802c36:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	a3 48 41 80 00       	mov    %eax,0x804148
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4d:	a1 54 41 80 00       	mov    0x804154,%eax
  802c52:	40                   	inc    %eax
  802c53:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802c58:	e9 c9 03 00 00       	jmp    803026 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802c5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c60:	8b 50 0c             	mov    0xc(%eax),%edx
  802c63:	8b 45 08             	mov    0x8(%ebp),%eax
  802c66:	8b 40 08             	mov    0x8(%eax),%eax
  802c69:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802c71:	39 c2                	cmp    %eax,%edx
  802c73:	0f 85 bb 00 00 00    	jne    802d34 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802c79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c7d:	0f 84 b1 00 00 00    	je     802d34 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 40 04             	mov    0x4(%eax),%eax
  802c89:	85 c0                	test   %eax,%eax
  802c8b:	0f 85 a3 00 00 00    	jne    802d34 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802c91:	a1 38 41 80 00       	mov    0x804138,%eax
  802c96:	8b 55 08             	mov    0x8(%ebp),%edx
  802c99:	8b 52 08             	mov    0x8(%edx),%edx
  802c9c:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802c9f:	a1 38 41 80 00       	mov    0x804138,%eax
  802ca4:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802caa:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802cad:	8b 55 08             	mov    0x8(%ebp),%edx
  802cb0:	8b 52 0c             	mov    0xc(%edx),%edx
  802cb3:	01 ca                	add    %ecx,%edx
  802cb5:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802cc2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802ccc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cd0:	75 17                	jne    802ce9 <insert_sorted_with_merge_freeList+0x498>
  802cd2:	83 ec 04             	sub    $0x4,%esp
  802cd5:	68 b4 3a 80 00       	push   $0x803ab4
  802cda:	68 17 01 00 00       	push   $0x117
  802cdf:	68 d7 3a 80 00       	push   $0x803ad7
  802ce4:	e8 88 d5 ff ff       	call   800271 <_panic>
  802ce9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cef:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf2:	89 10                	mov    %edx,(%eax)
  802cf4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf7:	8b 00                	mov    (%eax),%eax
  802cf9:	85 c0                	test   %eax,%eax
  802cfb:	74 0d                	je     802d0a <insert_sorted_with_merge_freeList+0x4b9>
  802cfd:	a1 48 41 80 00       	mov    0x804148,%eax
  802d02:	8b 55 08             	mov    0x8(%ebp),%edx
  802d05:	89 50 04             	mov    %edx,0x4(%eax)
  802d08:	eb 08                	jmp    802d12 <insert_sorted_with_merge_freeList+0x4c1>
  802d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	a3 48 41 80 00       	mov    %eax,0x804148
  802d1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d24:	a1 54 41 80 00       	mov    0x804154,%eax
  802d29:	40                   	inc    %eax
  802d2a:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d2f:	e9 f2 02 00 00       	jmp    803026 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802d34:	8b 45 08             	mov    0x8(%ebp),%eax
  802d37:	8b 50 08             	mov    0x8(%eax),%edx
  802d3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3d:	8b 40 0c             	mov    0xc(%eax),%eax
  802d40:	01 c2                	add    %eax,%edx
  802d42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d45:	8b 40 08             	mov    0x8(%eax),%eax
  802d48:	39 c2                	cmp    %eax,%edx
  802d4a:	0f 85 be 00 00 00    	jne    802e0e <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802d50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d53:	8b 40 04             	mov    0x4(%eax),%eax
  802d56:	8b 50 08             	mov    0x8(%eax),%edx
  802d59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d5c:	8b 40 04             	mov    0x4(%eax),%eax
  802d5f:	8b 40 0c             	mov    0xc(%eax),%eax
  802d62:	01 c2                	add    %eax,%edx
  802d64:	8b 45 08             	mov    0x8(%ebp),%eax
  802d67:	8b 40 08             	mov    0x8(%eax),%eax
  802d6a:	39 c2                	cmp    %eax,%edx
  802d6c:	0f 84 9c 00 00 00    	je     802e0e <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802d72:	8b 45 08             	mov    0x8(%ebp),%eax
  802d75:	8b 50 08             	mov    0x8(%eax),%edx
  802d78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7b:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d81:	8b 50 0c             	mov    0xc(%eax),%edx
  802d84:	8b 45 08             	mov    0x8(%ebp),%eax
  802d87:	8b 40 0c             	mov    0xc(%eax),%eax
  802d8a:	01 c2                	add    %eax,%edx
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802d92:	8b 45 08             	mov    0x8(%ebp),%eax
  802d95:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802da6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802daa:	75 17                	jne    802dc3 <insert_sorted_with_merge_freeList+0x572>
  802dac:	83 ec 04             	sub    $0x4,%esp
  802daf:	68 b4 3a 80 00       	push   $0x803ab4
  802db4:	68 26 01 00 00       	push   $0x126
  802db9:	68 d7 3a 80 00       	push   $0x803ad7
  802dbe:	e8 ae d4 ff ff       	call   800271 <_panic>
  802dc3:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802dc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcc:	89 10                	mov    %edx,(%eax)
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	8b 00                	mov    (%eax),%eax
  802dd3:	85 c0                	test   %eax,%eax
  802dd5:	74 0d                	je     802de4 <insert_sorted_with_merge_freeList+0x593>
  802dd7:	a1 48 41 80 00       	mov    0x804148,%eax
  802ddc:	8b 55 08             	mov    0x8(%ebp),%edx
  802ddf:	89 50 04             	mov    %edx,0x4(%eax)
  802de2:	eb 08                	jmp    802dec <insert_sorted_with_merge_freeList+0x59b>
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dec:	8b 45 08             	mov    0x8(%ebp),%eax
  802def:	a3 48 41 80 00       	mov    %eax,0x804148
  802df4:	8b 45 08             	mov    0x8(%ebp),%eax
  802df7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dfe:	a1 54 41 80 00       	mov    0x804154,%eax
  802e03:	40                   	inc    %eax
  802e04:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802e09:	e9 18 02 00 00       	jmp    803026 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	8b 50 0c             	mov    0xc(%eax),%edx
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	8b 40 08             	mov    0x8(%eax),%eax
  802e1a:	01 c2                	add    %eax,%edx
  802e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1f:	8b 40 08             	mov    0x8(%eax),%eax
  802e22:	39 c2                	cmp    %eax,%edx
  802e24:	0f 85 c4 01 00 00    	jne    802fee <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2d:	8b 50 0c             	mov    0xc(%eax),%edx
  802e30:	8b 45 08             	mov    0x8(%ebp),%eax
  802e33:	8b 40 08             	mov    0x8(%eax),%eax
  802e36:	01 c2                	add    %eax,%edx
  802e38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3b:	8b 00                	mov    (%eax),%eax
  802e3d:	8b 40 08             	mov    0x8(%eax),%eax
  802e40:	39 c2                	cmp    %eax,%edx
  802e42:	0f 85 a6 01 00 00    	jne    802fee <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802e48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e4c:	0f 84 9c 01 00 00    	je     802fee <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	8b 50 0c             	mov    0xc(%eax),%edx
  802e58:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5e:	01 c2                	add    %eax,%edx
  802e60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e63:	8b 00                	mov    (%eax),%eax
  802e65:	8b 40 0c             	mov    0xc(%eax),%eax
  802e68:	01 c2                	add    %eax,%edx
  802e6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e6d:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802e70:	8b 45 08             	mov    0x8(%ebp),%eax
  802e73:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e7d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802e84:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e88:	75 17                	jne    802ea1 <insert_sorted_with_merge_freeList+0x650>
  802e8a:	83 ec 04             	sub    $0x4,%esp
  802e8d:	68 b4 3a 80 00       	push   $0x803ab4
  802e92:	68 32 01 00 00       	push   $0x132
  802e97:	68 d7 3a 80 00       	push   $0x803ad7
  802e9c:	e8 d0 d3 ff ff       	call   800271 <_panic>
  802ea1:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaa:	89 10                	mov    %edx,(%eax)
  802eac:	8b 45 08             	mov    0x8(%ebp),%eax
  802eaf:	8b 00                	mov    (%eax),%eax
  802eb1:	85 c0                	test   %eax,%eax
  802eb3:	74 0d                	je     802ec2 <insert_sorted_with_merge_freeList+0x671>
  802eb5:	a1 48 41 80 00       	mov    0x804148,%eax
  802eba:	8b 55 08             	mov    0x8(%ebp),%edx
  802ebd:	89 50 04             	mov    %edx,0x4(%eax)
  802ec0:	eb 08                	jmp    802eca <insert_sorted_with_merge_freeList+0x679>
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802eca:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecd:	a3 48 41 80 00       	mov    %eax,0x804148
  802ed2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802edc:	a1 54 41 80 00       	mov    0x804154,%eax
  802ee1:	40                   	inc    %eax
  802ee2:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802ee7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eea:	8b 00                	mov    (%eax),%eax
  802eec:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8b 00                	mov    (%eax),%eax
  802ef8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802eff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f02:	8b 00                	mov    (%eax),%eax
  802f04:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802f07:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f0b:	75 17                	jne    802f24 <insert_sorted_with_merge_freeList+0x6d3>
  802f0d:	83 ec 04             	sub    $0x4,%esp
  802f10:	68 49 3b 80 00       	push   $0x803b49
  802f15:	68 36 01 00 00       	push   $0x136
  802f1a:	68 d7 3a 80 00       	push   $0x803ad7
  802f1f:	e8 4d d3 ff ff       	call   800271 <_panic>
  802f24:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	85 c0                	test   %eax,%eax
  802f2b:	74 10                	je     802f3d <insert_sorted_with_merge_freeList+0x6ec>
  802f2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f30:	8b 00                	mov    (%eax),%eax
  802f32:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f35:	8b 52 04             	mov    0x4(%edx),%edx
  802f38:	89 50 04             	mov    %edx,0x4(%eax)
  802f3b:	eb 0b                	jmp    802f48 <insert_sorted_with_merge_freeList+0x6f7>
  802f3d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f40:	8b 40 04             	mov    0x4(%eax),%eax
  802f43:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802f48:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f4b:	8b 40 04             	mov    0x4(%eax),%eax
  802f4e:	85 c0                	test   %eax,%eax
  802f50:	74 0f                	je     802f61 <insert_sorted_with_merge_freeList+0x710>
  802f52:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f55:	8b 40 04             	mov    0x4(%eax),%eax
  802f58:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802f5b:	8b 12                	mov    (%edx),%edx
  802f5d:	89 10                	mov    %edx,(%eax)
  802f5f:	eb 0a                	jmp    802f6b <insert_sorted_with_merge_freeList+0x71a>
  802f61:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	a3 38 41 80 00       	mov    %eax,0x804138
  802f6b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f6e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802f74:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f77:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f7e:	a1 44 41 80 00       	mov    0x804144,%eax
  802f83:	48                   	dec    %eax
  802f84:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  802f89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802f8d:	75 17                	jne    802fa6 <insert_sorted_with_merge_freeList+0x755>
  802f8f:	83 ec 04             	sub    $0x4,%esp
  802f92:	68 b4 3a 80 00       	push   $0x803ab4
  802f97:	68 37 01 00 00       	push   $0x137
  802f9c:	68 d7 3a 80 00       	push   $0x803ad7
  802fa1:	e8 cb d2 ff ff       	call   800271 <_panic>
  802fa6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802faf:	89 10                	mov    %edx,(%eax)
  802fb1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fb4:	8b 00                	mov    (%eax),%eax
  802fb6:	85 c0                	test   %eax,%eax
  802fb8:	74 0d                	je     802fc7 <insert_sorted_with_merge_freeList+0x776>
  802fba:	a1 48 41 80 00       	mov    0x804148,%eax
  802fbf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fc2:	89 50 04             	mov    %edx,0x4(%eax)
  802fc5:	eb 08                	jmp    802fcf <insert_sorted_with_merge_freeList+0x77e>
  802fc7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fca:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fcf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fd2:	a3 48 41 80 00       	mov    %eax,0x804148
  802fd7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fda:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fe1:	a1 54 41 80 00       	mov    0x804154,%eax
  802fe6:	40                   	inc    %eax
  802fe7:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  802fec:	eb 38                	jmp    803026 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802fee:	a1 40 41 80 00       	mov    0x804140,%eax
  802ff3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ff6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ffa:	74 07                	je     803003 <insert_sorted_with_merge_freeList+0x7b2>
  802ffc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fff:	8b 00                	mov    (%eax),%eax
  803001:	eb 05                	jmp    803008 <insert_sorted_with_merge_freeList+0x7b7>
  803003:	b8 00 00 00 00       	mov    $0x0,%eax
  803008:	a3 40 41 80 00       	mov    %eax,0x804140
  80300d:	a1 40 41 80 00       	mov    0x804140,%eax
  803012:	85 c0                	test   %eax,%eax
  803014:	0f 85 ef f9 ff ff    	jne    802a09 <insert_sorted_with_merge_freeList+0x1b8>
  80301a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80301e:	0f 85 e5 f9 ff ff    	jne    802a09 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803024:	eb 00                	jmp    803026 <insert_sorted_with_merge_freeList+0x7d5>
  803026:	90                   	nop
  803027:	c9                   	leave  
  803028:	c3                   	ret    
  803029:	66 90                	xchg   %ax,%ax
  80302b:	90                   	nop

0080302c <__udivdi3>:
  80302c:	55                   	push   %ebp
  80302d:	57                   	push   %edi
  80302e:	56                   	push   %esi
  80302f:	53                   	push   %ebx
  803030:	83 ec 1c             	sub    $0x1c,%esp
  803033:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803037:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80303b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80303f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803043:	89 ca                	mov    %ecx,%edx
  803045:	89 f8                	mov    %edi,%eax
  803047:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80304b:	85 f6                	test   %esi,%esi
  80304d:	75 2d                	jne    80307c <__udivdi3+0x50>
  80304f:	39 cf                	cmp    %ecx,%edi
  803051:	77 65                	ja     8030b8 <__udivdi3+0x8c>
  803053:	89 fd                	mov    %edi,%ebp
  803055:	85 ff                	test   %edi,%edi
  803057:	75 0b                	jne    803064 <__udivdi3+0x38>
  803059:	b8 01 00 00 00       	mov    $0x1,%eax
  80305e:	31 d2                	xor    %edx,%edx
  803060:	f7 f7                	div    %edi
  803062:	89 c5                	mov    %eax,%ebp
  803064:	31 d2                	xor    %edx,%edx
  803066:	89 c8                	mov    %ecx,%eax
  803068:	f7 f5                	div    %ebp
  80306a:	89 c1                	mov    %eax,%ecx
  80306c:	89 d8                	mov    %ebx,%eax
  80306e:	f7 f5                	div    %ebp
  803070:	89 cf                	mov    %ecx,%edi
  803072:	89 fa                	mov    %edi,%edx
  803074:	83 c4 1c             	add    $0x1c,%esp
  803077:	5b                   	pop    %ebx
  803078:	5e                   	pop    %esi
  803079:	5f                   	pop    %edi
  80307a:	5d                   	pop    %ebp
  80307b:	c3                   	ret    
  80307c:	39 ce                	cmp    %ecx,%esi
  80307e:	77 28                	ja     8030a8 <__udivdi3+0x7c>
  803080:	0f bd fe             	bsr    %esi,%edi
  803083:	83 f7 1f             	xor    $0x1f,%edi
  803086:	75 40                	jne    8030c8 <__udivdi3+0x9c>
  803088:	39 ce                	cmp    %ecx,%esi
  80308a:	72 0a                	jb     803096 <__udivdi3+0x6a>
  80308c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803090:	0f 87 9e 00 00 00    	ja     803134 <__udivdi3+0x108>
  803096:	b8 01 00 00 00       	mov    $0x1,%eax
  80309b:	89 fa                	mov    %edi,%edx
  80309d:	83 c4 1c             	add    $0x1c,%esp
  8030a0:	5b                   	pop    %ebx
  8030a1:	5e                   	pop    %esi
  8030a2:	5f                   	pop    %edi
  8030a3:	5d                   	pop    %ebp
  8030a4:	c3                   	ret    
  8030a5:	8d 76 00             	lea    0x0(%esi),%esi
  8030a8:	31 ff                	xor    %edi,%edi
  8030aa:	31 c0                	xor    %eax,%eax
  8030ac:	89 fa                	mov    %edi,%edx
  8030ae:	83 c4 1c             	add    $0x1c,%esp
  8030b1:	5b                   	pop    %ebx
  8030b2:	5e                   	pop    %esi
  8030b3:	5f                   	pop    %edi
  8030b4:	5d                   	pop    %ebp
  8030b5:	c3                   	ret    
  8030b6:	66 90                	xchg   %ax,%ax
  8030b8:	89 d8                	mov    %ebx,%eax
  8030ba:	f7 f7                	div    %edi
  8030bc:	31 ff                	xor    %edi,%edi
  8030be:	89 fa                	mov    %edi,%edx
  8030c0:	83 c4 1c             	add    $0x1c,%esp
  8030c3:	5b                   	pop    %ebx
  8030c4:	5e                   	pop    %esi
  8030c5:	5f                   	pop    %edi
  8030c6:	5d                   	pop    %ebp
  8030c7:	c3                   	ret    
  8030c8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8030cd:	89 eb                	mov    %ebp,%ebx
  8030cf:	29 fb                	sub    %edi,%ebx
  8030d1:	89 f9                	mov    %edi,%ecx
  8030d3:	d3 e6                	shl    %cl,%esi
  8030d5:	89 c5                	mov    %eax,%ebp
  8030d7:	88 d9                	mov    %bl,%cl
  8030d9:	d3 ed                	shr    %cl,%ebp
  8030db:	89 e9                	mov    %ebp,%ecx
  8030dd:	09 f1                	or     %esi,%ecx
  8030df:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8030e3:	89 f9                	mov    %edi,%ecx
  8030e5:	d3 e0                	shl    %cl,%eax
  8030e7:	89 c5                	mov    %eax,%ebp
  8030e9:	89 d6                	mov    %edx,%esi
  8030eb:	88 d9                	mov    %bl,%cl
  8030ed:	d3 ee                	shr    %cl,%esi
  8030ef:	89 f9                	mov    %edi,%ecx
  8030f1:	d3 e2                	shl    %cl,%edx
  8030f3:	8b 44 24 08          	mov    0x8(%esp),%eax
  8030f7:	88 d9                	mov    %bl,%cl
  8030f9:	d3 e8                	shr    %cl,%eax
  8030fb:	09 c2                	or     %eax,%edx
  8030fd:	89 d0                	mov    %edx,%eax
  8030ff:	89 f2                	mov    %esi,%edx
  803101:	f7 74 24 0c          	divl   0xc(%esp)
  803105:	89 d6                	mov    %edx,%esi
  803107:	89 c3                	mov    %eax,%ebx
  803109:	f7 e5                	mul    %ebp
  80310b:	39 d6                	cmp    %edx,%esi
  80310d:	72 19                	jb     803128 <__udivdi3+0xfc>
  80310f:	74 0b                	je     80311c <__udivdi3+0xf0>
  803111:	89 d8                	mov    %ebx,%eax
  803113:	31 ff                	xor    %edi,%edi
  803115:	e9 58 ff ff ff       	jmp    803072 <__udivdi3+0x46>
  80311a:	66 90                	xchg   %ax,%ax
  80311c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803120:	89 f9                	mov    %edi,%ecx
  803122:	d3 e2                	shl    %cl,%edx
  803124:	39 c2                	cmp    %eax,%edx
  803126:	73 e9                	jae    803111 <__udivdi3+0xe5>
  803128:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80312b:	31 ff                	xor    %edi,%edi
  80312d:	e9 40 ff ff ff       	jmp    803072 <__udivdi3+0x46>
  803132:	66 90                	xchg   %ax,%ax
  803134:	31 c0                	xor    %eax,%eax
  803136:	e9 37 ff ff ff       	jmp    803072 <__udivdi3+0x46>
  80313b:	90                   	nop

0080313c <__umoddi3>:
  80313c:	55                   	push   %ebp
  80313d:	57                   	push   %edi
  80313e:	56                   	push   %esi
  80313f:	53                   	push   %ebx
  803140:	83 ec 1c             	sub    $0x1c,%esp
  803143:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803147:	8b 74 24 34          	mov    0x34(%esp),%esi
  80314b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80314f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803153:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803157:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80315b:	89 f3                	mov    %esi,%ebx
  80315d:	89 fa                	mov    %edi,%edx
  80315f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803163:	89 34 24             	mov    %esi,(%esp)
  803166:	85 c0                	test   %eax,%eax
  803168:	75 1a                	jne    803184 <__umoddi3+0x48>
  80316a:	39 f7                	cmp    %esi,%edi
  80316c:	0f 86 a2 00 00 00    	jbe    803214 <__umoddi3+0xd8>
  803172:	89 c8                	mov    %ecx,%eax
  803174:	89 f2                	mov    %esi,%edx
  803176:	f7 f7                	div    %edi
  803178:	89 d0                	mov    %edx,%eax
  80317a:	31 d2                	xor    %edx,%edx
  80317c:	83 c4 1c             	add    $0x1c,%esp
  80317f:	5b                   	pop    %ebx
  803180:	5e                   	pop    %esi
  803181:	5f                   	pop    %edi
  803182:	5d                   	pop    %ebp
  803183:	c3                   	ret    
  803184:	39 f0                	cmp    %esi,%eax
  803186:	0f 87 ac 00 00 00    	ja     803238 <__umoddi3+0xfc>
  80318c:	0f bd e8             	bsr    %eax,%ebp
  80318f:	83 f5 1f             	xor    $0x1f,%ebp
  803192:	0f 84 ac 00 00 00    	je     803244 <__umoddi3+0x108>
  803198:	bf 20 00 00 00       	mov    $0x20,%edi
  80319d:	29 ef                	sub    %ebp,%edi
  80319f:	89 fe                	mov    %edi,%esi
  8031a1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8031a5:	89 e9                	mov    %ebp,%ecx
  8031a7:	d3 e0                	shl    %cl,%eax
  8031a9:	89 d7                	mov    %edx,%edi
  8031ab:	89 f1                	mov    %esi,%ecx
  8031ad:	d3 ef                	shr    %cl,%edi
  8031af:	09 c7                	or     %eax,%edi
  8031b1:	89 e9                	mov    %ebp,%ecx
  8031b3:	d3 e2                	shl    %cl,%edx
  8031b5:	89 14 24             	mov    %edx,(%esp)
  8031b8:	89 d8                	mov    %ebx,%eax
  8031ba:	d3 e0                	shl    %cl,%eax
  8031bc:	89 c2                	mov    %eax,%edx
  8031be:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031c2:	d3 e0                	shl    %cl,%eax
  8031c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8031c8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031cc:	89 f1                	mov    %esi,%ecx
  8031ce:	d3 e8                	shr    %cl,%eax
  8031d0:	09 d0                	or     %edx,%eax
  8031d2:	d3 eb                	shr    %cl,%ebx
  8031d4:	89 da                	mov    %ebx,%edx
  8031d6:	f7 f7                	div    %edi
  8031d8:	89 d3                	mov    %edx,%ebx
  8031da:	f7 24 24             	mull   (%esp)
  8031dd:	89 c6                	mov    %eax,%esi
  8031df:	89 d1                	mov    %edx,%ecx
  8031e1:	39 d3                	cmp    %edx,%ebx
  8031e3:	0f 82 87 00 00 00    	jb     803270 <__umoddi3+0x134>
  8031e9:	0f 84 91 00 00 00    	je     803280 <__umoddi3+0x144>
  8031ef:	8b 54 24 04          	mov    0x4(%esp),%edx
  8031f3:	29 f2                	sub    %esi,%edx
  8031f5:	19 cb                	sbb    %ecx,%ebx
  8031f7:	89 d8                	mov    %ebx,%eax
  8031f9:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8031fd:	d3 e0                	shl    %cl,%eax
  8031ff:	89 e9                	mov    %ebp,%ecx
  803201:	d3 ea                	shr    %cl,%edx
  803203:	09 d0                	or     %edx,%eax
  803205:	89 e9                	mov    %ebp,%ecx
  803207:	d3 eb                	shr    %cl,%ebx
  803209:	89 da                	mov    %ebx,%edx
  80320b:	83 c4 1c             	add    $0x1c,%esp
  80320e:	5b                   	pop    %ebx
  80320f:	5e                   	pop    %esi
  803210:	5f                   	pop    %edi
  803211:	5d                   	pop    %ebp
  803212:	c3                   	ret    
  803213:	90                   	nop
  803214:	89 fd                	mov    %edi,%ebp
  803216:	85 ff                	test   %edi,%edi
  803218:	75 0b                	jne    803225 <__umoddi3+0xe9>
  80321a:	b8 01 00 00 00       	mov    $0x1,%eax
  80321f:	31 d2                	xor    %edx,%edx
  803221:	f7 f7                	div    %edi
  803223:	89 c5                	mov    %eax,%ebp
  803225:	89 f0                	mov    %esi,%eax
  803227:	31 d2                	xor    %edx,%edx
  803229:	f7 f5                	div    %ebp
  80322b:	89 c8                	mov    %ecx,%eax
  80322d:	f7 f5                	div    %ebp
  80322f:	89 d0                	mov    %edx,%eax
  803231:	e9 44 ff ff ff       	jmp    80317a <__umoddi3+0x3e>
  803236:	66 90                	xchg   %ax,%ax
  803238:	89 c8                	mov    %ecx,%eax
  80323a:	89 f2                	mov    %esi,%edx
  80323c:	83 c4 1c             	add    $0x1c,%esp
  80323f:	5b                   	pop    %ebx
  803240:	5e                   	pop    %esi
  803241:	5f                   	pop    %edi
  803242:	5d                   	pop    %ebp
  803243:	c3                   	ret    
  803244:	3b 04 24             	cmp    (%esp),%eax
  803247:	72 06                	jb     80324f <__umoddi3+0x113>
  803249:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  80324d:	77 0f                	ja     80325e <__umoddi3+0x122>
  80324f:	89 f2                	mov    %esi,%edx
  803251:	29 f9                	sub    %edi,%ecx
  803253:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803257:	89 14 24             	mov    %edx,(%esp)
  80325a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80325e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803262:	8b 14 24             	mov    (%esp),%edx
  803265:	83 c4 1c             	add    $0x1c,%esp
  803268:	5b                   	pop    %ebx
  803269:	5e                   	pop    %esi
  80326a:	5f                   	pop    %edi
  80326b:	5d                   	pop    %ebp
  80326c:	c3                   	ret    
  80326d:	8d 76 00             	lea    0x0(%esi),%esi
  803270:	2b 04 24             	sub    (%esp),%eax
  803273:	19 fa                	sbb    %edi,%edx
  803275:	89 d1                	mov    %edx,%ecx
  803277:	89 c6                	mov    %eax,%esi
  803279:	e9 71 ff ff ff       	jmp    8031ef <__umoddi3+0xb3>
  80327e:	66 90                	xchg   %ax,%ax
  803280:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803284:	72 ea                	jb     803270 <__umoddi3+0x134>
  803286:	89 d9                	mov    %ebx,%ecx
  803288:	e9 62 ff ff ff       	jmp    8031ef <__umoddi3+0xb3>
