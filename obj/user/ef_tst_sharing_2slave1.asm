
obj/user/ef_tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 1e 02 00 00       	call   800254 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program1: Read the 2 shared variables, edit the 3rd one, and exit
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	83 ec 24             	sub    $0x24,%esp
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
  80003f:	c6 45 f7 01          	movb   $0x1,-0x9(%ebp)
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800043:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80004a:	eb 29                	jmp    800075 <_main+0x3d>
		{
			if (myEnv->__uptr_pws[i].empty)
  80004c:	a1 20 40 80 00       	mov    0x804020,%eax
  800051:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800057:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80005a:	89 d0                	mov    %edx,%eax
  80005c:	01 c0                	add    %eax,%eax
  80005e:	01 d0                	add    %edx,%eax
  800060:	c1 e0 03             	shl    $0x3,%eax
  800063:	01 c8                	add    %ecx,%eax
  800065:	8a 40 04             	mov    0x4(%eax),%al
  800068:	84 c0                	test   %al,%al
  80006a:	74 06                	je     800072 <_main+0x3a>
			{
				fullWS = 0;
  80006c:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
				break;
  800070:	eb 12                	jmp    800084 <_main+0x4c>
_main(void)
{
	//Initial test to ensure it works on "PLACEMENT" not "REPLACEMENT"
	{
		uint8 fullWS = 1;
		for (int i = 0; i < myEnv->page_WS_max_size; ++i)
  800072:	ff 45 f0             	incl   -0x10(%ebp)
  800075:	a1 20 40 80 00       	mov    0x804020,%eax
  80007a:	8b 50 74             	mov    0x74(%eax),%edx
  80007d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800080:	39 c2                	cmp    %eax,%edx
  800082:	77 c8                	ja     80004c <_main+0x14>
			{
				fullWS = 0;
				break;
			}
		}
		if (fullWS) panic("Please increase the WS size");
  800084:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800088:	74 14                	je     80009e <_main+0x66>
  80008a:	83 ec 04             	sub    $0x4,%esp
  80008d:	68 c0 33 80 00       	push   $0x8033c0
  800092:	6a 13                	push   $0x13
  800094:	68 dc 33 80 00       	push   $0x8033dc
  800099:	e8 f2 02 00 00       	call   800390 <_panic>
	}
	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  80009e:	e8 d7 1c 00 00       	call   801d7a <sys_getparentenvid>
  8000a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000a6:	e8 c3 1a 00 00       	call   801b6e <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000ab:	e8 d1 19 00 00       	call   801a81 <sys_calculate_free_frames>
  8000b0:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000b3:	83 ec 08             	sub    $0x8,%esp
  8000b6:	68 fa 33 80 00       	push   $0x8033fa
  8000bb:	ff 75 ec             	pushl  -0x14(%ebp)
  8000be:	e8 70 17 00 00       	call   801833 <sget>
  8000c3:	83 c4 10             	add    $0x10,%esp
  8000c6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000c9:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000d0:	74 14                	je     8000e6 <_main+0xae>
  8000d2:	83 ec 04             	sub    $0x4,%esp
  8000d5:	68 fc 33 80 00       	push   $0x8033fc
  8000da:	6a 1c                	push   $0x1c
  8000dc:	68 dc 33 80 00       	push   $0x8033dc
  8000e1:	e8 aa 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000e6:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000e9:	e8 93 19 00 00       	call   801a81 <sys_calculate_free_frames>
  8000ee:	29 c3                	sub    %eax,%ebx
  8000f0:	89 d8                	mov    %ebx,%eax
  8000f2:	83 f8 01             	cmp    $0x1,%eax
  8000f5:	74 14                	je     80010b <_main+0xd3>
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 5c 34 80 00       	push   $0x80345c
  8000ff:	6a 1d                	push   $0x1d
  800101:	68 dc 33 80 00       	push   $0x8033dc
  800106:	e8 85 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  80010b:	e8 78 1a 00 00       	call   801b88 <sys_enable_interrupt>

	sys_disable_interrupt();
  800110:	e8 59 1a 00 00       	call   801b6e <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800115:	e8 67 19 00 00       	call   801a81 <sys_calculate_free_frames>
  80011a:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80011d:	83 ec 08             	sub    $0x8,%esp
  800120:	68 ed 34 80 00       	push   $0x8034ed
  800125:	ff 75 ec             	pushl  -0x14(%ebp)
  800128:	e8 06 17 00 00       	call   801833 <sget>
  80012d:	83 c4 10             	add    $0x10,%esp
  800130:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800133:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  80013a:	74 14                	je     800150 <_main+0x118>
  80013c:	83 ec 04             	sub    $0x4,%esp
  80013f:	68 fc 33 80 00       	push   $0x8033fc
  800144:	6a 23                	push   $0x23
  800146:	68 dc 33 80 00       	push   $0x8033dc
  80014b:	e8 40 02 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  800150:	e8 2c 19 00 00       	call   801a81 <sys_calculate_free_frames>
  800155:	89 c2                	mov    %eax,%edx
  800157:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015a:	39 c2                	cmp    %eax,%edx
  80015c:	74 14                	je     800172 <_main+0x13a>
  80015e:	83 ec 04             	sub    $0x4,%esp
  800161:	68 5c 34 80 00       	push   $0x80345c
  800166:	6a 24                	push   $0x24
  800168:	68 dc 33 80 00       	push   $0x8033dc
  80016d:	e8 1e 02 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  800172:	e8 11 1a 00 00       	call   801b88 <sys_enable_interrupt>
	
	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80017a:	8b 00                	mov    (%eax),%eax
  80017c:	83 f8 14             	cmp    $0x14,%eax
  80017f:	74 14                	je     800195 <_main+0x15d>
  800181:	83 ec 04             	sub    $0x4,%esp
  800184:	68 f0 34 80 00       	push   $0x8034f0
  800189:	6a 27                	push   $0x27
  80018b:	68 dc 33 80 00       	push   $0x8033dc
  800190:	e8 fb 01 00 00       	call   800390 <_panic>

	sys_disable_interrupt();
  800195:	e8 d4 19 00 00       	call   801b6e <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  80019a:	e8 e2 18 00 00       	call   801a81 <sys_calculate_free_frames>
  80019f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001a2:	83 ec 08             	sub    $0x8,%esp
  8001a5:	68 27 35 80 00       	push   $0x803527
  8001aa:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ad:	e8 81 16 00 00       	call   801833 <sget>
  8001b2:	83 c4 10             	add    $0x10,%esp
  8001b5:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001b8:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001bf:	74 14                	je     8001d5 <_main+0x19d>
  8001c1:	83 ec 04             	sub    $0x4,%esp
  8001c4:	68 fc 33 80 00       	push   $0x8033fc
  8001c9:	6a 2c                	push   $0x2c
  8001cb:	68 dc 33 80 00       	push   $0x8033dc
  8001d0:	e8 bb 01 00 00       	call   800390 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001d5:	e8 a7 18 00 00       	call   801a81 <sys_calculate_free_frames>
  8001da:	89 c2                	mov    %eax,%edx
  8001dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001df:	39 c2                	cmp    %eax,%edx
  8001e1:	74 14                	je     8001f7 <_main+0x1bf>
  8001e3:	83 ec 04             	sub    $0x4,%esp
  8001e6:	68 5c 34 80 00       	push   $0x80345c
  8001eb:	6a 2d                	push   $0x2d
  8001ed:	68 dc 33 80 00       	push   $0x8033dc
  8001f2:	e8 99 01 00 00       	call   800390 <_panic>
	sys_enable_interrupt();
  8001f7:	e8 8c 19 00 00       	call   801b88 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  8001fc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001ff:	8b 00                	mov    (%eax),%eax
  800201:	83 f8 0a             	cmp    $0xa,%eax
  800204:	74 14                	je     80021a <_main+0x1e2>
  800206:	83 ec 04             	sub    $0x4,%esp
  800209:	68 f0 34 80 00       	push   $0x8034f0
  80020e:	6a 30                	push   $0x30
  800210:	68 dc 33 80 00       	push   $0x8033dc
  800215:	e8 76 01 00 00       	call   800390 <_panic>

	*z = *x + *y ;
  80021a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80021d:	8b 10                	mov    (%eax),%edx
  80021f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800222:	8b 00                	mov    (%eax),%eax
  800224:	01 c2                	add    %eax,%edx
  800226:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800229:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  80022b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80022e:	8b 00                	mov    (%eax),%eax
  800230:	83 f8 1e             	cmp    $0x1e,%eax
  800233:	74 14                	je     800249 <_main+0x211>
  800235:	83 ec 04             	sub    $0x4,%esp
  800238:	68 f0 34 80 00       	push   $0x8034f0
  80023d:	6a 33                	push   $0x33
  80023f:	68 dc 33 80 00       	push   $0x8033dc
  800244:	e8 47 01 00 00       	call   800390 <_panic>

	//To indicate that it's completed successfully
	inctst();
  800249:	e8 51 1c 00 00       	call   801e9f <inctst>

	return;
  80024e:	90                   	nop
}
  80024f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800252:	c9                   	leave  
  800253:	c3                   	ret    

00800254 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800254:	55                   	push   %ebp
  800255:	89 e5                	mov    %esp,%ebp
  800257:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80025a:	e8 02 1b 00 00       	call   801d61 <sys_getenvindex>
  80025f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800265:	89 d0                	mov    %edx,%eax
  800267:	c1 e0 03             	shl    $0x3,%eax
  80026a:	01 d0                	add    %edx,%eax
  80026c:	01 c0                	add    %eax,%eax
  80026e:	01 d0                	add    %edx,%eax
  800270:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800277:	01 d0                	add    %edx,%eax
  800279:	c1 e0 04             	shl    $0x4,%eax
  80027c:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800281:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800286:	a1 20 40 80 00       	mov    0x804020,%eax
  80028b:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800291:	84 c0                	test   %al,%al
  800293:	74 0f                	je     8002a4 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800295:	a1 20 40 80 00       	mov    0x804020,%eax
  80029a:	05 5c 05 00 00       	add    $0x55c,%eax
  80029f:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002a4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002a8:	7e 0a                	jle    8002b4 <libmain+0x60>
		binaryname = argv[0];
  8002aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ad:	8b 00                	mov    (%eax),%eax
  8002af:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002b4:	83 ec 08             	sub    $0x8,%esp
  8002b7:	ff 75 0c             	pushl  0xc(%ebp)
  8002ba:	ff 75 08             	pushl  0x8(%ebp)
  8002bd:	e8 76 fd ff ff       	call   800038 <_main>
  8002c2:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002c5:	e8 a4 18 00 00       	call   801b6e <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002ca:	83 ec 0c             	sub    $0xc,%esp
  8002cd:	68 44 35 80 00       	push   $0x803544
  8002d2:	e8 6d 03 00 00       	call   800644 <cprintf>
  8002d7:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002da:	a1 20 40 80 00       	mov    0x804020,%eax
  8002df:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ea:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002f0:	83 ec 04             	sub    $0x4,%esp
  8002f3:	52                   	push   %edx
  8002f4:	50                   	push   %eax
  8002f5:	68 6c 35 80 00       	push   $0x80356c
  8002fa:	e8 45 03 00 00       	call   800644 <cprintf>
  8002ff:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800302:	a1 20 40 80 00       	mov    0x804020,%eax
  800307:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80030d:	a1 20 40 80 00       	mov    0x804020,%eax
  800312:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800318:	a1 20 40 80 00       	mov    0x804020,%eax
  80031d:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800323:	51                   	push   %ecx
  800324:	52                   	push   %edx
  800325:	50                   	push   %eax
  800326:	68 94 35 80 00       	push   $0x803594
  80032b:	e8 14 03 00 00       	call   800644 <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800333:	a1 20 40 80 00       	mov    0x804020,%eax
  800338:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80033e:	83 ec 08             	sub    $0x8,%esp
  800341:	50                   	push   %eax
  800342:	68 ec 35 80 00       	push   $0x8035ec
  800347:	e8 f8 02 00 00       	call   800644 <cprintf>
  80034c:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 44 35 80 00       	push   $0x803544
  800357:	e8 e8 02 00 00       	call   800644 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80035f:	e8 24 18 00 00       	call   801b88 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800364:	e8 19 00 00 00       	call   800382 <exit>
}
  800369:	90                   	nop
  80036a:	c9                   	leave  
  80036b:	c3                   	ret    

0080036c <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80036c:	55                   	push   %ebp
  80036d:	89 e5                	mov    %esp,%ebp
  80036f:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800372:	83 ec 0c             	sub    $0xc,%esp
  800375:	6a 00                	push   $0x0
  800377:	e8 b1 19 00 00       	call   801d2d <sys_destroy_env>
  80037c:	83 c4 10             	add    $0x10,%esp
}
  80037f:	90                   	nop
  800380:	c9                   	leave  
  800381:	c3                   	ret    

00800382 <exit>:

void
exit(void)
{
  800382:	55                   	push   %ebp
  800383:	89 e5                	mov    %esp,%ebp
  800385:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800388:	e8 06 1a 00 00       	call   801d93 <sys_exit_env>
}
  80038d:	90                   	nop
  80038e:	c9                   	leave  
  80038f:	c3                   	ret    

00800390 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800390:	55                   	push   %ebp
  800391:	89 e5                	mov    %esp,%ebp
  800393:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800396:	8d 45 10             	lea    0x10(%ebp),%eax
  800399:	83 c0 04             	add    $0x4,%eax
  80039c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80039f:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003a4:	85 c0                	test   %eax,%eax
  8003a6:	74 16                	je     8003be <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003a8:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003ad:	83 ec 08             	sub    $0x8,%esp
  8003b0:	50                   	push   %eax
  8003b1:	68 00 36 80 00       	push   $0x803600
  8003b6:	e8 89 02 00 00       	call   800644 <cprintf>
  8003bb:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003be:	a1 00 40 80 00       	mov    0x804000,%eax
  8003c3:	ff 75 0c             	pushl  0xc(%ebp)
  8003c6:	ff 75 08             	pushl  0x8(%ebp)
  8003c9:	50                   	push   %eax
  8003ca:	68 05 36 80 00       	push   $0x803605
  8003cf:	e8 70 02 00 00       	call   800644 <cprintf>
  8003d4:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8003da:	83 ec 08             	sub    $0x8,%esp
  8003dd:	ff 75 f4             	pushl  -0xc(%ebp)
  8003e0:	50                   	push   %eax
  8003e1:	e8 f3 01 00 00       	call   8005d9 <vcprintf>
  8003e6:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003e9:	83 ec 08             	sub    $0x8,%esp
  8003ec:	6a 00                	push   $0x0
  8003ee:	68 21 36 80 00       	push   $0x803621
  8003f3:	e8 e1 01 00 00       	call   8005d9 <vcprintf>
  8003f8:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003fb:	e8 82 ff ff ff       	call   800382 <exit>

	// should not return here
	while (1) ;
  800400:	eb fe                	jmp    800400 <_panic+0x70>

00800402 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800402:	55                   	push   %ebp
  800403:	89 e5                	mov    %esp,%ebp
  800405:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800408:	a1 20 40 80 00       	mov    0x804020,%eax
  80040d:	8b 50 74             	mov    0x74(%eax),%edx
  800410:	8b 45 0c             	mov    0xc(%ebp),%eax
  800413:	39 c2                	cmp    %eax,%edx
  800415:	74 14                	je     80042b <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800417:	83 ec 04             	sub    $0x4,%esp
  80041a:	68 24 36 80 00       	push   $0x803624
  80041f:	6a 26                	push   $0x26
  800421:	68 70 36 80 00       	push   $0x803670
  800426:	e8 65 ff ff ff       	call   800390 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80042b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800432:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800439:	e9 c2 00 00 00       	jmp    800500 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80043e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800441:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800448:	8b 45 08             	mov    0x8(%ebp),%eax
  80044b:	01 d0                	add    %edx,%eax
  80044d:	8b 00                	mov    (%eax),%eax
  80044f:	85 c0                	test   %eax,%eax
  800451:	75 08                	jne    80045b <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800453:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800456:	e9 a2 00 00 00       	jmp    8004fd <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80045b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800462:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800469:	eb 69                	jmp    8004d4 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80046b:	a1 20 40 80 00       	mov    0x804020,%eax
  800470:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800476:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800479:	89 d0                	mov    %edx,%eax
  80047b:	01 c0                	add    %eax,%eax
  80047d:	01 d0                	add    %edx,%eax
  80047f:	c1 e0 03             	shl    $0x3,%eax
  800482:	01 c8                	add    %ecx,%eax
  800484:	8a 40 04             	mov    0x4(%eax),%al
  800487:	84 c0                	test   %al,%al
  800489:	75 46                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80048b:	a1 20 40 80 00       	mov    0x804020,%eax
  800490:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800496:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800499:	89 d0                	mov    %edx,%eax
  80049b:	01 c0                	add    %eax,%eax
  80049d:	01 d0                	add    %edx,%eax
  80049f:	c1 e0 03             	shl    $0x3,%eax
  8004a2:	01 c8                	add    %ecx,%eax
  8004a4:	8b 00                	mov    (%eax),%eax
  8004a6:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004a9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004ac:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004b1:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004b6:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	01 c8                	add    %ecx,%eax
  8004c2:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004c4:	39 c2                	cmp    %eax,%edx
  8004c6:	75 09                	jne    8004d1 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004c8:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004cf:	eb 12                	jmp    8004e3 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d1:	ff 45 e8             	incl   -0x18(%ebp)
  8004d4:	a1 20 40 80 00       	mov    0x804020,%eax
  8004d9:	8b 50 74             	mov    0x74(%eax),%edx
  8004dc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004df:	39 c2                	cmp    %eax,%edx
  8004e1:	77 88                	ja     80046b <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004e3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004e7:	75 14                	jne    8004fd <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004e9:	83 ec 04             	sub    $0x4,%esp
  8004ec:	68 7c 36 80 00       	push   $0x80367c
  8004f1:	6a 3a                	push   $0x3a
  8004f3:	68 70 36 80 00       	push   $0x803670
  8004f8:	e8 93 fe ff ff       	call   800390 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004fd:	ff 45 f0             	incl   -0x10(%ebp)
  800500:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800503:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800506:	0f 8c 32 ff ff ff    	jl     80043e <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80050c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800513:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80051a:	eb 26                	jmp    800542 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80051c:	a1 20 40 80 00       	mov    0x804020,%eax
  800521:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800527:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80052a:	89 d0                	mov    %edx,%eax
  80052c:	01 c0                	add    %eax,%eax
  80052e:	01 d0                	add    %edx,%eax
  800530:	c1 e0 03             	shl    $0x3,%eax
  800533:	01 c8                	add    %ecx,%eax
  800535:	8a 40 04             	mov    0x4(%eax),%al
  800538:	3c 01                	cmp    $0x1,%al
  80053a:	75 03                	jne    80053f <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80053c:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80053f:	ff 45 e0             	incl   -0x20(%ebp)
  800542:	a1 20 40 80 00       	mov    0x804020,%eax
  800547:	8b 50 74             	mov    0x74(%eax),%edx
  80054a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80054d:	39 c2                	cmp    %eax,%edx
  80054f:	77 cb                	ja     80051c <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800551:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800554:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800557:	74 14                	je     80056d <CheckWSWithoutLastIndex+0x16b>
		panic(
  800559:	83 ec 04             	sub    $0x4,%esp
  80055c:	68 d0 36 80 00       	push   $0x8036d0
  800561:	6a 44                	push   $0x44
  800563:	68 70 36 80 00       	push   $0x803670
  800568:	e8 23 fe ff ff       	call   800390 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80056d:	90                   	nop
  80056e:	c9                   	leave  
  80056f:	c3                   	ret    

00800570 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800570:	55                   	push   %ebp
  800571:	89 e5                	mov    %esp,%ebp
  800573:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800576:	8b 45 0c             	mov    0xc(%ebp),%eax
  800579:	8b 00                	mov    (%eax),%eax
  80057b:	8d 48 01             	lea    0x1(%eax),%ecx
  80057e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800581:	89 0a                	mov    %ecx,(%edx)
  800583:	8b 55 08             	mov    0x8(%ebp),%edx
  800586:	88 d1                	mov    %dl,%cl
  800588:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058b:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80058f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800592:	8b 00                	mov    (%eax),%eax
  800594:	3d ff 00 00 00       	cmp    $0xff,%eax
  800599:	75 2c                	jne    8005c7 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80059b:	a0 24 40 80 00       	mov    0x804024,%al
  8005a0:	0f b6 c0             	movzbl %al,%eax
  8005a3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005a6:	8b 12                	mov    (%edx),%edx
  8005a8:	89 d1                	mov    %edx,%ecx
  8005aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ad:	83 c2 08             	add    $0x8,%edx
  8005b0:	83 ec 04             	sub    $0x4,%esp
  8005b3:	50                   	push   %eax
  8005b4:	51                   	push   %ecx
  8005b5:	52                   	push   %edx
  8005b6:	e8 05 14 00 00       	call   8019c0 <sys_cputs>
  8005bb:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005be:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ca:	8b 40 04             	mov    0x4(%eax),%eax
  8005cd:	8d 50 01             	lea    0x1(%eax),%edx
  8005d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d3:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005d6:	90                   	nop
  8005d7:	c9                   	leave  
  8005d8:	c3                   	ret    

008005d9 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005d9:	55                   	push   %ebp
  8005da:	89 e5                	mov    %esp,%ebp
  8005dc:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005e2:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005e9:	00 00 00 
	b.cnt = 0;
  8005ec:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005f3:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005f6:	ff 75 0c             	pushl  0xc(%ebp)
  8005f9:	ff 75 08             	pushl  0x8(%ebp)
  8005fc:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800602:	50                   	push   %eax
  800603:	68 70 05 80 00       	push   $0x800570
  800608:	e8 11 02 00 00       	call   80081e <vprintfmt>
  80060d:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800610:	a0 24 40 80 00       	mov    0x804024,%al
  800615:	0f b6 c0             	movzbl %al,%eax
  800618:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80061e:	83 ec 04             	sub    $0x4,%esp
  800621:	50                   	push   %eax
  800622:	52                   	push   %edx
  800623:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800629:	83 c0 08             	add    $0x8,%eax
  80062c:	50                   	push   %eax
  80062d:	e8 8e 13 00 00       	call   8019c0 <sys_cputs>
  800632:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800635:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  80063c:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800642:	c9                   	leave  
  800643:	c3                   	ret    

00800644 <cprintf>:

int cprintf(const char *fmt, ...) {
  800644:	55                   	push   %ebp
  800645:	89 e5                	mov    %esp,%ebp
  800647:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80064a:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800651:	8d 45 0c             	lea    0xc(%ebp),%eax
  800654:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800657:	8b 45 08             	mov    0x8(%ebp),%eax
  80065a:	83 ec 08             	sub    $0x8,%esp
  80065d:	ff 75 f4             	pushl  -0xc(%ebp)
  800660:	50                   	push   %eax
  800661:	e8 73 ff ff ff       	call   8005d9 <vcprintf>
  800666:	83 c4 10             	add    $0x10,%esp
  800669:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80066c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80066f:	c9                   	leave  
  800670:	c3                   	ret    

00800671 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800671:	55                   	push   %ebp
  800672:	89 e5                	mov    %esp,%ebp
  800674:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800677:	e8 f2 14 00 00       	call   801b6e <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80067c:	8d 45 0c             	lea    0xc(%ebp),%eax
  80067f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800682:	8b 45 08             	mov    0x8(%ebp),%eax
  800685:	83 ec 08             	sub    $0x8,%esp
  800688:	ff 75 f4             	pushl  -0xc(%ebp)
  80068b:	50                   	push   %eax
  80068c:	e8 48 ff ff ff       	call   8005d9 <vcprintf>
  800691:	83 c4 10             	add    $0x10,%esp
  800694:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800697:	e8 ec 14 00 00       	call   801b88 <sys_enable_interrupt>
	return cnt;
  80069c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80069f:	c9                   	leave  
  8006a0:	c3                   	ret    

008006a1 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006a1:	55                   	push   %ebp
  8006a2:	89 e5                	mov    %esp,%ebp
  8006a4:	53                   	push   %ebx
  8006a5:	83 ec 14             	sub    $0x14,%esp
  8006a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8006ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006b4:	8b 45 18             	mov    0x18(%ebp),%eax
  8006b7:	ba 00 00 00 00       	mov    $0x0,%edx
  8006bc:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006bf:	77 55                	ja     800716 <printnum+0x75>
  8006c1:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006c4:	72 05                	jb     8006cb <printnum+0x2a>
  8006c6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006c9:	77 4b                	ja     800716 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006cb:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006ce:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006d1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006d4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006d9:	52                   	push   %edx
  8006da:	50                   	push   %eax
  8006db:	ff 75 f4             	pushl  -0xc(%ebp)
  8006de:	ff 75 f0             	pushl  -0x10(%ebp)
  8006e1:	e8 62 2a 00 00       	call   803148 <__udivdi3>
  8006e6:	83 c4 10             	add    $0x10,%esp
  8006e9:	83 ec 04             	sub    $0x4,%esp
  8006ec:	ff 75 20             	pushl  0x20(%ebp)
  8006ef:	53                   	push   %ebx
  8006f0:	ff 75 18             	pushl  0x18(%ebp)
  8006f3:	52                   	push   %edx
  8006f4:	50                   	push   %eax
  8006f5:	ff 75 0c             	pushl  0xc(%ebp)
  8006f8:	ff 75 08             	pushl  0x8(%ebp)
  8006fb:	e8 a1 ff ff ff       	call   8006a1 <printnum>
  800700:	83 c4 20             	add    $0x20,%esp
  800703:	eb 1a                	jmp    80071f <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800705:	83 ec 08             	sub    $0x8,%esp
  800708:	ff 75 0c             	pushl  0xc(%ebp)
  80070b:	ff 75 20             	pushl  0x20(%ebp)
  80070e:	8b 45 08             	mov    0x8(%ebp),%eax
  800711:	ff d0                	call   *%eax
  800713:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800716:	ff 4d 1c             	decl   0x1c(%ebp)
  800719:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80071d:	7f e6                	jg     800705 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80071f:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800722:	bb 00 00 00 00       	mov    $0x0,%ebx
  800727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80072a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80072d:	53                   	push   %ebx
  80072e:	51                   	push   %ecx
  80072f:	52                   	push   %edx
  800730:	50                   	push   %eax
  800731:	e8 22 2b 00 00       	call   803258 <__umoddi3>
  800736:	83 c4 10             	add    $0x10,%esp
  800739:	05 34 39 80 00       	add    $0x803934,%eax
  80073e:	8a 00                	mov    (%eax),%al
  800740:	0f be c0             	movsbl %al,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	ff 75 0c             	pushl  0xc(%ebp)
  800749:	50                   	push   %eax
  80074a:	8b 45 08             	mov    0x8(%ebp),%eax
  80074d:	ff d0                	call   *%eax
  80074f:	83 c4 10             	add    $0x10,%esp
}
  800752:	90                   	nop
  800753:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800756:	c9                   	leave  
  800757:	c3                   	ret    

00800758 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800758:	55                   	push   %ebp
  800759:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80075b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075f:	7e 1c                	jle    80077d <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	8b 00                	mov    (%eax),%eax
  800766:	8d 50 08             	lea    0x8(%eax),%edx
  800769:	8b 45 08             	mov    0x8(%ebp),%eax
  80076c:	89 10                	mov    %edx,(%eax)
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	83 e8 08             	sub    $0x8,%eax
  800776:	8b 50 04             	mov    0x4(%eax),%edx
  800779:	8b 00                	mov    (%eax),%eax
  80077b:	eb 40                	jmp    8007bd <getuint+0x65>
	else if (lflag)
  80077d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800781:	74 1e                	je     8007a1 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	8b 00                	mov    (%eax),%eax
  800788:	8d 50 04             	lea    0x4(%eax),%edx
  80078b:	8b 45 08             	mov    0x8(%ebp),%eax
  80078e:	89 10                	mov    %edx,(%eax)
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	83 e8 04             	sub    $0x4,%eax
  800798:	8b 00                	mov    (%eax),%eax
  80079a:	ba 00 00 00 00       	mov    $0x0,%edx
  80079f:	eb 1c                	jmp    8007bd <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	8d 50 04             	lea    0x4(%eax),%edx
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	89 10                	mov    %edx,(%eax)
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	83 e8 04             	sub    $0x4,%eax
  8007b6:	8b 00                	mov    (%eax),%eax
  8007b8:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007bd:	5d                   	pop    %ebp
  8007be:	c3                   	ret    

008007bf <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007bf:	55                   	push   %ebp
  8007c0:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007c2:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007c6:	7e 1c                	jle    8007e4 <getint+0x25>
		return va_arg(*ap, long long);
  8007c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cb:	8b 00                	mov    (%eax),%eax
  8007cd:	8d 50 08             	lea    0x8(%eax),%edx
  8007d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d3:	89 10                	mov    %edx,(%eax)
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	83 e8 08             	sub    $0x8,%eax
  8007dd:	8b 50 04             	mov    0x4(%eax),%edx
  8007e0:	8b 00                	mov    (%eax),%eax
  8007e2:	eb 38                	jmp    80081c <getint+0x5d>
	else if (lflag)
  8007e4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007e8:	74 1a                	je     800804 <getint+0x45>
		return va_arg(*ap, long);
  8007ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	8d 50 04             	lea    0x4(%eax),%edx
  8007f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f5:	89 10                	mov    %edx,(%eax)
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	83 e8 04             	sub    $0x4,%eax
  8007ff:	8b 00                	mov    (%eax),%eax
  800801:	99                   	cltd   
  800802:	eb 18                	jmp    80081c <getint+0x5d>
	else
		return va_arg(*ap, int);
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	8d 50 04             	lea    0x4(%eax),%edx
  80080c:	8b 45 08             	mov    0x8(%ebp),%eax
  80080f:	89 10                	mov    %edx,(%eax)
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	83 e8 04             	sub    $0x4,%eax
  800819:	8b 00                	mov    (%eax),%eax
  80081b:	99                   	cltd   
}
  80081c:	5d                   	pop    %ebp
  80081d:	c3                   	ret    

0080081e <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80081e:	55                   	push   %ebp
  80081f:	89 e5                	mov    %esp,%ebp
  800821:	56                   	push   %esi
  800822:	53                   	push   %ebx
  800823:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800826:	eb 17                	jmp    80083f <vprintfmt+0x21>
			if (ch == '\0')
  800828:	85 db                	test   %ebx,%ebx
  80082a:	0f 84 af 03 00 00    	je     800bdf <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	53                   	push   %ebx
  800837:	8b 45 08             	mov    0x8(%ebp),%eax
  80083a:	ff d0                	call   *%eax
  80083c:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80083f:	8b 45 10             	mov    0x10(%ebp),%eax
  800842:	8d 50 01             	lea    0x1(%eax),%edx
  800845:	89 55 10             	mov    %edx,0x10(%ebp)
  800848:	8a 00                	mov    (%eax),%al
  80084a:	0f b6 d8             	movzbl %al,%ebx
  80084d:	83 fb 25             	cmp    $0x25,%ebx
  800850:	75 d6                	jne    800828 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800852:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800856:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80085d:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800864:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80086b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800872:	8b 45 10             	mov    0x10(%ebp),%eax
  800875:	8d 50 01             	lea    0x1(%eax),%edx
  800878:	89 55 10             	mov    %edx,0x10(%ebp)
  80087b:	8a 00                	mov    (%eax),%al
  80087d:	0f b6 d8             	movzbl %al,%ebx
  800880:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800883:	83 f8 55             	cmp    $0x55,%eax
  800886:	0f 87 2b 03 00 00    	ja     800bb7 <vprintfmt+0x399>
  80088c:	8b 04 85 58 39 80 00 	mov    0x803958(,%eax,4),%eax
  800893:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800895:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800899:	eb d7                	jmp    800872 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  80089b:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  80089f:	eb d1                	jmp    800872 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008a8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008ab:	89 d0                	mov    %edx,%eax
  8008ad:	c1 e0 02             	shl    $0x2,%eax
  8008b0:	01 d0                	add    %edx,%eax
  8008b2:	01 c0                	add    %eax,%eax
  8008b4:	01 d8                	add    %ebx,%eax
  8008b6:	83 e8 30             	sub    $0x30,%eax
  8008b9:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8008bf:	8a 00                	mov    (%eax),%al
  8008c1:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008c4:	83 fb 2f             	cmp    $0x2f,%ebx
  8008c7:	7e 3e                	jle    800907 <vprintfmt+0xe9>
  8008c9:	83 fb 39             	cmp    $0x39,%ebx
  8008cc:	7f 39                	jg     800907 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ce:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008d1:	eb d5                	jmp    8008a8 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d6:	83 c0 04             	add    $0x4,%eax
  8008d9:	89 45 14             	mov    %eax,0x14(%ebp)
  8008dc:	8b 45 14             	mov    0x14(%ebp),%eax
  8008df:	83 e8 04             	sub    $0x4,%eax
  8008e2:	8b 00                	mov    (%eax),%eax
  8008e4:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008e7:	eb 1f                	jmp    800908 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008e9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008ed:	79 83                	jns    800872 <vprintfmt+0x54>
				width = 0;
  8008ef:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008f6:	e9 77 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008fb:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800902:	e9 6b ff ff ff       	jmp    800872 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800907:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800908:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80090c:	0f 89 60 ff ff ff    	jns    800872 <vprintfmt+0x54>
				width = precision, precision = -1;
  800912:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800915:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800918:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80091f:	e9 4e ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800924:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800927:	e9 46 ff ff ff       	jmp    800872 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	83 c0 04             	add    $0x4,%eax
  800932:	89 45 14             	mov    %eax,0x14(%ebp)
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	83 e8 04             	sub    $0x4,%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	83 ec 08             	sub    $0x8,%esp
  800940:	ff 75 0c             	pushl  0xc(%ebp)
  800943:	50                   	push   %eax
  800944:	8b 45 08             	mov    0x8(%ebp),%eax
  800947:	ff d0                	call   *%eax
  800949:	83 c4 10             	add    $0x10,%esp
			break;
  80094c:	e9 89 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800951:	8b 45 14             	mov    0x14(%ebp),%eax
  800954:	83 c0 04             	add    $0x4,%eax
  800957:	89 45 14             	mov    %eax,0x14(%ebp)
  80095a:	8b 45 14             	mov    0x14(%ebp),%eax
  80095d:	83 e8 04             	sub    $0x4,%eax
  800960:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800962:	85 db                	test   %ebx,%ebx
  800964:	79 02                	jns    800968 <vprintfmt+0x14a>
				err = -err;
  800966:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800968:	83 fb 64             	cmp    $0x64,%ebx
  80096b:	7f 0b                	jg     800978 <vprintfmt+0x15a>
  80096d:	8b 34 9d a0 37 80 00 	mov    0x8037a0(,%ebx,4),%esi
  800974:	85 f6                	test   %esi,%esi
  800976:	75 19                	jne    800991 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800978:	53                   	push   %ebx
  800979:	68 45 39 80 00       	push   $0x803945
  80097e:	ff 75 0c             	pushl  0xc(%ebp)
  800981:	ff 75 08             	pushl  0x8(%ebp)
  800984:	e8 5e 02 00 00       	call   800be7 <printfmt>
  800989:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  80098c:	e9 49 02 00 00       	jmp    800bda <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800991:	56                   	push   %esi
  800992:	68 4e 39 80 00       	push   $0x80394e
  800997:	ff 75 0c             	pushl  0xc(%ebp)
  80099a:	ff 75 08             	pushl  0x8(%ebp)
  80099d:	e8 45 02 00 00       	call   800be7 <printfmt>
  8009a2:	83 c4 10             	add    $0x10,%esp
			break;
  8009a5:	e9 30 02 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	83 c0 04             	add    $0x4,%eax
  8009b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 30                	mov    (%eax),%esi
  8009bb:	85 f6                	test   %esi,%esi
  8009bd:	75 05                	jne    8009c4 <vprintfmt+0x1a6>
				p = "(null)";
  8009bf:	be 51 39 80 00       	mov    $0x803951,%esi
			if (width > 0 && padc != '-')
  8009c4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009c8:	7e 6d                	jle    800a37 <vprintfmt+0x219>
  8009ca:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009ce:	74 67                	je     800a37 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009d3:	83 ec 08             	sub    $0x8,%esp
  8009d6:	50                   	push   %eax
  8009d7:	56                   	push   %esi
  8009d8:	e8 0c 03 00 00       	call   800ce9 <strnlen>
  8009dd:	83 c4 10             	add    $0x10,%esp
  8009e0:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009e3:	eb 16                	jmp    8009fb <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009e5:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009e9:	83 ec 08             	sub    $0x8,%esp
  8009ec:	ff 75 0c             	pushl  0xc(%ebp)
  8009ef:	50                   	push   %eax
  8009f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f3:	ff d0                	call   *%eax
  8009f5:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009f8:	ff 4d e4             	decl   -0x1c(%ebp)
  8009fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009ff:	7f e4                	jg     8009e5 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a01:	eb 34                	jmp    800a37 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a03:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a07:	74 1c                	je     800a25 <vprintfmt+0x207>
  800a09:	83 fb 1f             	cmp    $0x1f,%ebx
  800a0c:	7e 05                	jle    800a13 <vprintfmt+0x1f5>
  800a0e:	83 fb 7e             	cmp    $0x7e,%ebx
  800a11:	7e 12                	jle    800a25 <vprintfmt+0x207>
					putch('?', putdat);
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 0c             	pushl  0xc(%ebp)
  800a19:	6a 3f                	push   $0x3f
  800a1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1e:	ff d0                	call   *%eax
  800a20:	83 c4 10             	add    $0x10,%esp
  800a23:	eb 0f                	jmp    800a34 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a25:	83 ec 08             	sub    $0x8,%esp
  800a28:	ff 75 0c             	pushl  0xc(%ebp)
  800a2b:	53                   	push   %ebx
  800a2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2f:	ff d0                	call   *%eax
  800a31:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a34:	ff 4d e4             	decl   -0x1c(%ebp)
  800a37:	89 f0                	mov    %esi,%eax
  800a39:	8d 70 01             	lea    0x1(%eax),%esi
  800a3c:	8a 00                	mov    (%eax),%al
  800a3e:	0f be d8             	movsbl %al,%ebx
  800a41:	85 db                	test   %ebx,%ebx
  800a43:	74 24                	je     800a69 <vprintfmt+0x24b>
  800a45:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a49:	78 b8                	js     800a03 <vprintfmt+0x1e5>
  800a4b:	ff 4d e0             	decl   -0x20(%ebp)
  800a4e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a52:	79 af                	jns    800a03 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a54:	eb 13                	jmp    800a69 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a56:	83 ec 08             	sub    $0x8,%esp
  800a59:	ff 75 0c             	pushl  0xc(%ebp)
  800a5c:	6a 20                	push   $0x20
  800a5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a61:	ff d0                	call   *%eax
  800a63:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a66:	ff 4d e4             	decl   -0x1c(%ebp)
  800a69:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a6d:	7f e7                	jg     800a56 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a6f:	e9 66 01 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a74:	83 ec 08             	sub    $0x8,%esp
  800a77:	ff 75 e8             	pushl  -0x18(%ebp)
  800a7a:	8d 45 14             	lea    0x14(%ebp),%eax
  800a7d:	50                   	push   %eax
  800a7e:	e8 3c fd ff ff       	call   8007bf <getint>
  800a83:	83 c4 10             	add    $0x10,%esp
  800a86:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a89:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a8f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a92:	85 d2                	test   %edx,%edx
  800a94:	79 23                	jns    800ab9 <vprintfmt+0x29b>
				putch('-', putdat);
  800a96:	83 ec 08             	sub    $0x8,%esp
  800a99:	ff 75 0c             	pushl  0xc(%ebp)
  800a9c:	6a 2d                	push   $0x2d
  800a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa1:	ff d0                	call   *%eax
  800aa3:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aa6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800aa9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aac:	f7 d8                	neg    %eax
  800aae:	83 d2 00             	adc    $0x0,%edx
  800ab1:	f7 da                	neg    %edx
  800ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab6:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ab9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ac0:	e9 bc 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ac5:	83 ec 08             	sub    $0x8,%esp
  800ac8:	ff 75 e8             	pushl  -0x18(%ebp)
  800acb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ace:	50                   	push   %eax
  800acf:	e8 84 fc ff ff       	call   800758 <getuint>
  800ad4:	83 c4 10             	add    $0x10,%esp
  800ad7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ada:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800add:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ae4:	e9 98 00 00 00       	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ae9:	83 ec 08             	sub    $0x8,%esp
  800aec:	ff 75 0c             	pushl  0xc(%ebp)
  800aef:	6a 58                	push   $0x58
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	ff d0                	call   *%eax
  800af6:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800af9:	83 ec 08             	sub    $0x8,%esp
  800afc:	ff 75 0c             	pushl  0xc(%ebp)
  800aff:	6a 58                	push   $0x58
  800b01:	8b 45 08             	mov    0x8(%ebp),%eax
  800b04:	ff d0                	call   *%eax
  800b06:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b09:	83 ec 08             	sub    $0x8,%esp
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	6a 58                	push   $0x58
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	ff d0                	call   *%eax
  800b16:	83 c4 10             	add    $0x10,%esp
			break;
  800b19:	e9 bc 00 00 00       	jmp    800bda <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 0c             	pushl  0xc(%ebp)
  800b24:	6a 30                	push   $0x30
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	ff d0                	call   *%eax
  800b2b:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b2e:	83 ec 08             	sub    $0x8,%esp
  800b31:	ff 75 0c             	pushl  0xc(%ebp)
  800b34:	6a 78                	push   $0x78
  800b36:	8b 45 08             	mov    0x8(%ebp),%eax
  800b39:	ff d0                	call   *%eax
  800b3b:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800b41:	83 c0 04             	add    $0x4,%eax
  800b44:	89 45 14             	mov    %eax,0x14(%ebp)
  800b47:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4a:	83 e8 04             	sub    $0x4,%eax
  800b4d:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b52:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b59:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b60:	eb 1f                	jmp    800b81 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 e8             	pushl  -0x18(%ebp)
  800b68:	8d 45 14             	lea    0x14(%ebp),%eax
  800b6b:	50                   	push   %eax
  800b6c:	e8 e7 fb ff ff       	call   800758 <getuint>
  800b71:	83 c4 10             	add    $0x10,%esp
  800b74:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b77:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b7a:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b81:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b85:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b88:	83 ec 04             	sub    $0x4,%esp
  800b8b:	52                   	push   %edx
  800b8c:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b8f:	50                   	push   %eax
  800b90:	ff 75 f4             	pushl  -0xc(%ebp)
  800b93:	ff 75 f0             	pushl  -0x10(%ebp)
  800b96:	ff 75 0c             	pushl  0xc(%ebp)
  800b99:	ff 75 08             	pushl  0x8(%ebp)
  800b9c:	e8 00 fb ff ff       	call   8006a1 <printnum>
  800ba1:	83 c4 20             	add    $0x20,%esp
			break;
  800ba4:	eb 34                	jmp    800bda <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800ba6:	83 ec 08             	sub    $0x8,%esp
  800ba9:	ff 75 0c             	pushl  0xc(%ebp)
  800bac:	53                   	push   %ebx
  800bad:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb0:	ff d0                	call   *%eax
  800bb2:	83 c4 10             	add    $0x10,%esp
			break;
  800bb5:	eb 23                	jmp    800bda <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bb7:	83 ec 08             	sub    $0x8,%esp
  800bba:	ff 75 0c             	pushl  0xc(%ebp)
  800bbd:	6a 25                	push   $0x25
  800bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc2:	ff d0                	call   *%eax
  800bc4:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bc7:	ff 4d 10             	decl   0x10(%ebp)
  800bca:	eb 03                	jmp    800bcf <vprintfmt+0x3b1>
  800bcc:	ff 4d 10             	decl   0x10(%ebp)
  800bcf:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd2:	48                   	dec    %eax
  800bd3:	8a 00                	mov    (%eax),%al
  800bd5:	3c 25                	cmp    $0x25,%al
  800bd7:	75 f3                	jne    800bcc <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bd9:	90                   	nop
		}
	}
  800bda:	e9 47 fc ff ff       	jmp    800826 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bdf:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800be0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800be3:	5b                   	pop    %ebx
  800be4:	5e                   	pop    %esi
  800be5:	5d                   	pop    %ebp
  800be6:	c3                   	ret    

00800be7 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800be7:	55                   	push   %ebp
  800be8:	89 e5                	mov    %esp,%ebp
  800bea:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bed:	8d 45 10             	lea    0x10(%ebp),%eax
  800bf0:	83 c0 04             	add    $0x4,%eax
  800bf3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bf6:	8b 45 10             	mov    0x10(%ebp),%eax
  800bf9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bfc:	50                   	push   %eax
  800bfd:	ff 75 0c             	pushl  0xc(%ebp)
  800c00:	ff 75 08             	pushl  0x8(%ebp)
  800c03:	e8 16 fc ff ff       	call   80081e <vprintfmt>
  800c08:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c0b:	90                   	nop
  800c0c:	c9                   	leave  
  800c0d:	c3                   	ret    

00800c0e <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c0e:	55                   	push   %ebp
  800c0f:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c14:	8b 40 08             	mov    0x8(%eax),%eax
  800c17:	8d 50 01             	lea    0x1(%eax),%edx
  800c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c1d:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c20:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c23:	8b 10                	mov    (%eax),%edx
  800c25:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c28:	8b 40 04             	mov    0x4(%eax),%eax
  800c2b:	39 c2                	cmp    %eax,%edx
  800c2d:	73 12                	jae    800c41 <sprintputch+0x33>
		*b->buf++ = ch;
  800c2f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c32:	8b 00                	mov    (%eax),%eax
  800c34:	8d 48 01             	lea    0x1(%eax),%ecx
  800c37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c3a:	89 0a                	mov    %ecx,(%edx)
  800c3c:	8b 55 08             	mov    0x8(%ebp),%edx
  800c3f:	88 10                	mov    %dl,(%eax)
}
  800c41:	90                   	nop
  800c42:	5d                   	pop    %ebp
  800c43:	c3                   	ret    

00800c44 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c44:	55                   	push   %ebp
  800c45:	89 e5                	mov    %esp,%ebp
  800c47:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c50:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c53:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c56:	8b 45 08             	mov    0x8(%ebp),%eax
  800c59:	01 d0                	add    %edx,%eax
  800c5b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c65:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c69:	74 06                	je     800c71 <vsnprintf+0x2d>
  800c6b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c6f:	7f 07                	jg     800c78 <vsnprintf+0x34>
		return -E_INVAL;
  800c71:	b8 03 00 00 00       	mov    $0x3,%eax
  800c76:	eb 20                	jmp    800c98 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c78:	ff 75 14             	pushl  0x14(%ebp)
  800c7b:	ff 75 10             	pushl  0x10(%ebp)
  800c7e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c81:	50                   	push   %eax
  800c82:	68 0e 0c 80 00       	push   $0x800c0e
  800c87:	e8 92 fb ff ff       	call   80081e <vprintfmt>
  800c8c:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c92:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c95:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c98:	c9                   	leave  
  800c99:	c3                   	ret    

00800c9a <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c9a:	55                   	push   %ebp
  800c9b:	89 e5                	mov    %esp,%ebp
  800c9d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ca0:	8d 45 10             	lea    0x10(%ebp),%eax
  800ca3:	83 c0 04             	add    $0x4,%eax
  800ca6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800ca9:	8b 45 10             	mov    0x10(%ebp),%eax
  800cac:	ff 75 f4             	pushl  -0xc(%ebp)
  800caf:	50                   	push   %eax
  800cb0:	ff 75 0c             	pushl  0xc(%ebp)
  800cb3:	ff 75 08             	pushl  0x8(%ebp)
  800cb6:	e8 89 ff ff ff       	call   800c44 <vsnprintf>
  800cbb:	83 c4 10             	add    $0x10,%esp
  800cbe:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cc1:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cc4:	c9                   	leave  
  800cc5:	c3                   	ret    

00800cc6 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cc6:	55                   	push   %ebp
  800cc7:	89 e5                	mov    %esp,%ebp
  800cc9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ccc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd3:	eb 06                	jmp    800cdb <strlen+0x15>
		n++;
  800cd5:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd8:	ff 45 08             	incl   0x8(%ebp)
  800cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cde:	8a 00                	mov    (%eax),%al
  800ce0:	84 c0                	test   %al,%al
  800ce2:	75 f1                	jne    800cd5 <strlen+0xf>
		n++;
	return n;
  800ce4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce7:	c9                   	leave  
  800ce8:	c3                   	ret    

00800ce9 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800ce9:	55                   	push   %ebp
  800cea:	89 e5                	mov    %esp,%ebp
  800cec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cef:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cf6:	eb 09                	jmp    800d01 <strnlen+0x18>
		n++;
  800cf8:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfb:	ff 45 08             	incl   0x8(%ebp)
  800cfe:	ff 4d 0c             	decl   0xc(%ebp)
  800d01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d05:	74 09                	je     800d10 <strnlen+0x27>
  800d07:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0a:	8a 00                	mov    (%eax),%al
  800d0c:	84 c0                	test   %al,%al
  800d0e:	75 e8                	jne    800cf8 <strnlen+0xf>
		n++;
	return n;
  800d10:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d13:	c9                   	leave  
  800d14:	c3                   	ret    

00800d15 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d15:	55                   	push   %ebp
  800d16:	89 e5                	mov    %esp,%ebp
  800d18:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d21:	90                   	nop
  800d22:	8b 45 08             	mov    0x8(%ebp),%eax
  800d25:	8d 50 01             	lea    0x1(%eax),%edx
  800d28:	89 55 08             	mov    %edx,0x8(%ebp)
  800d2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d2e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d31:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d34:	8a 12                	mov    (%edx),%dl
  800d36:	88 10                	mov    %dl,(%eax)
  800d38:	8a 00                	mov    (%eax),%al
  800d3a:	84 c0                	test   %al,%al
  800d3c:	75 e4                	jne    800d22 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d3e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d41:	c9                   	leave  
  800d42:	c3                   	ret    

00800d43 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d43:	55                   	push   %ebp
  800d44:	89 e5                	mov    %esp,%ebp
  800d46:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d49:	8b 45 08             	mov    0x8(%ebp),%eax
  800d4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d4f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d56:	eb 1f                	jmp    800d77 <strncpy+0x34>
		*dst++ = *src;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5b:	8d 50 01             	lea    0x1(%eax),%edx
  800d5e:	89 55 08             	mov    %edx,0x8(%ebp)
  800d61:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d64:	8a 12                	mov    (%edx),%dl
  800d66:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6b:	8a 00                	mov    (%eax),%al
  800d6d:	84 c0                	test   %al,%al
  800d6f:	74 03                	je     800d74 <strncpy+0x31>
			src++;
  800d71:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d74:	ff 45 fc             	incl   -0x4(%ebp)
  800d77:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d7a:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d7d:	72 d9                	jb     800d58 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d7f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d82:	c9                   	leave  
  800d83:	c3                   	ret    

00800d84 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d84:	55                   	push   %ebp
  800d85:	89 e5                	mov    %esp,%ebp
  800d87:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d94:	74 30                	je     800dc6 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d96:	eb 16                	jmp    800dae <strlcpy+0x2a>
			*dst++ = *src++;
  800d98:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9b:	8d 50 01             	lea    0x1(%eax),%edx
  800d9e:	89 55 08             	mov    %edx,0x8(%ebp)
  800da1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800da4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800da7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800daa:	8a 12                	mov    (%edx),%dl
  800dac:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dae:	ff 4d 10             	decl   0x10(%ebp)
  800db1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db5:	74 09                	je     800dc0 <strlcpy+0x3c>
  800db7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	75 d8                	jne    800d98 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800dc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dcc:	29 c2                	sub    %eax,%edx
  800dce:	89 d0                	mov    %edx,%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800dd5:	eb 06                	jmp    800ddd <strcmp+0xb>
		p++, q++;
  800dd7:	ff 45 08             	incl   0x8(%ebp)
  800dda:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  800de0:	8a 00                	mov    (%eax),%al
  800de2:	84 c0                	test   %al,%al
  800de4:	74 0e                	je     800df4 <strcmp+0x22>
  800de6:	8b 45 08             	mov    0x8(%ebp),%eax
  800de9:	8a 10                	mov    (%eax),%dl
  800deb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dee:	8a 00                	mov    (%eax),%al
  800df0:	38 c2                	cmp    %al,%dl
  800df2:	74 e3                	je     800dd7 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	8a 00                	mov    (%eax),%al
  800df9:	0f b6 d0             	movzbl %al,%edx
  800dfc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	0f b6 c0             	movzbl %al,%eax
  800e04:	29 c2                	sub    %eax,%edx
  800e06:	89 d0                	mov    %edx,%eax
}
  800e08:	5d                   	pop    %ebp
  800e09:	c3                   	ret    

00800e0a <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e0a:	55                   	push   %ebp
  800e0b:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e0d:	eb 09                	jmp    800e18 <strncmp+0xe>
		n--, p++, q++;
  800e0f:	ff 4d 10             	decl   0x10(%ebp)
  800e12:	ff 45 08             	incl   0x8(%ebp)
  800e15:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e18:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e1c:	74 17                	je     800e35 <strncmp+0x2b>
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	8a 00                	mov    (%eax),%al
  800e23:	84 c0                	test   %al,%al
  800e25:	74 0e                	je     800e35 <strncmp+0x2b>
  800e27:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2a:	8a 10                	mov    (%eax),%dl
  800e2c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	38 c2                	cmp    %al,%dl
  800e33:	74 da                	je     800e0f <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e39:	75 07                	jne    800e42 <strncmp+0x38>
		return 0;
  800e3b:	b8 00 00 00 00       	mov    $0x0,%eax
  800e40:	eb 14                	jmp    800e56 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	0f b6 d0             	movzbl %al,%edx
  800e4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	0f b6 c0             	movzbl %al,%eax
  800e52:	29 c2                	sub    %eax,%edx
  800e54:	89 d0                	mov    %edx,%eax
}
  800e56:	5d                   	pop    %ebp
  800e57:	c3                   	ret    

00800e58 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e58:	55                   	push   %ebp
  800e59:	89 e5                	mov    %esp,%ebp
  800e5b:	83 ec 04             	sub    $0x4,%esp
  800e5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e61:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e64:	eb 12                	jmp    800e78 <strchr+0x20>
		if (*s == c)
  800e66:	8b 45 08             	mov    0x8(%ebp),%eax
  800e69:	8a 00                	mov    (%eax),%al
  800e6b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e6e:	75 05                	jne    800e75 <strchr+0x1d>
			return (char *) s;
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	eb 11                	jmp    800e86 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e75:	ff 45 08             	incl   0x8(%ebp)
  800e78:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7b:	8a 00                	mov    (%eax),%al
  800e7d:	84 c0                	test   %al,%al
  800e7f:	75 e5                	jne    800e66 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e81:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e86:	c9                   	leave  
  800e87:	c3                   	ret    

00800e88 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e88:	55                   	push   %ebp
  800e89:	89 e5                	mov    %esp,%ebp
  800e8b:	83 ec 04             	sub    $0x4,%esp
  800e8e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e91:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e94:	eb 0d                	jmp    800ea3 <strfind+0x1b>
		if (*s == c)
  800e96:	8b 45 08             	mov    0x8(%ebp),%eax
  800e99:	8a 00                	mov    (%eax),%al
  800e9b:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e9e:	74 0e                	je     800eae <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ea0:	ff 45 08             	incl   0x8(%ebp)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	84 c0                	test   %al,%al
  800eaa:	75 ea                	jne    800e96 <strfind+0xe>
  800eac:	eb 01                	jmp    800eaf <strfind+0x27>
		if (*s == c)
			break;
  800eae:	90                   	nop
	return (char *) s;
  800eaf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb2:	c9                   	leave  
  800eb3:	c3                   	ret    

00800eb4 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800eb4:	55                   	push   %ebp
  800eb5:	89 e5                	mov    %esp,%ebp
  800eb7:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ec0:	8b 45 10             	mov    0x10(%ebp),%eax
  800ec3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ec6:	eb 0e                	jmp    800ed6 <memset+0x22>
		*p++ = c;
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	8d 50 01             	lea    0x1(%eax),%edx
  800ece:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ed1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ed4:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ed6:	ff 4d f8             	decl   -0x8(%ebp)
  800ed9:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800edd:	79 e9                	jns    800ec8 <memset+0x14>
		*p++ = c;

	return v;
  800edf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ee2:	c9                   	leave  
  800ee3:	c3                   	ret    

00800ee4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ee4:	55                   	push   %ebp
  800ee5:	89 e5                	mov    %esp,%ebp
  800ee7:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ef6:	eb 16                	jmp    800f0e <memcpy+0x2a>
		*d++ = *s++;
  800ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efb:	8d 50 01             	lea    0x1(%eax),%edx
  800efe:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f01:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f04:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f07:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f0a:	8a 12                	mov    (%edx),%dl
  800f0c:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f0e:	8b 45 10             	mov    0x10(%ebp),%eax
  800f11:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f14:	89 55 10             	mov    %edx,0x10(%ebp)
  800f17:	85 c0                	test   %eax,%eax
  800f19:	75 dd                	jne    800ef8 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f1b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f1e:	c9                   	leave  
  800f1f:	c3                   	ret    

00800f20 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f20:	55                   	push   %ebp
  800f21:	89 e5                	mov    %esp,%ebp
  800f23:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f26:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f29:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f32:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f35:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f38:	73 50                	jae    800f8a <memmove+0x6a>
  800f3a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f3d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f40:	01 d0                	add    %edx,%eax
  800f42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f45:	76 43                	jbe    800f8a <memmove+0x6a>
		s += n;
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f4d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f50:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f53:	eb 10                	jmp    800f65 <memmove+0x45>
			*--d = *--s;
  800f55:	ff 4d f8             	decl   -0x8(%ebp)
  800f58:	ff 4d fc             	decl   -0x4(%ebp)
  800f5b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5e:	8a 10                	mov    (%eax),%dl
  800f60:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f63:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6b:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6e:	85 c0                	test   %eax,%eax
  800f70:	75 e3                	jne    800f55 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f72:	eb 23                	jmp    800f97 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f74:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f77:	8d 50 01             	lea    0x1(%eax),%edx
  800f7a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f7d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f80:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f83:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f86:	8a 12                	mov    (%edx),%dl
  800f88:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f8a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f90:	89 55 10             	mov    %edx,0x10(%ebp)
  800f93:	85 c0                	test   %eax,%eax
  800f95:	75 dd                	jne    800f74 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800fa2:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fae:	eb 2a                	jmp    800fda <memcmp+0x3e>
		if (*s1 != *s2)
  800fb0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb3:	8a 10                	mov    (%eax),%dl
  800fb5:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fb8:	8a 00                	mov    (%eax),%al
  800fba:	38 c2                	cmp    %al,%dl
  800fbc:	74 16                	je     800fd4 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	0f b6 d0             	movzbl %al,%edx
  800fc6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	0f b6 c0             	movzbl %al,%eax
  800fce:	29 c2                	sub    %eax,%edx
  800fd0:	89 d0                	mov    %edx,%eax
  800fd2:	eb 18                	jmp    800fec <memcmp+0x50>
		s1++, s2++;
  800fd4:	ff 45 fc             	incl   -0x4(%ebp)
  800fd7:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fda:	8b 45 10             	mov    0x10(%ebp),%eax
  800fdd:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe0:	89 55 10             	mov    %edx,0x10(%ebp)
  800fe3:	85 c0                	test   %eax,%eax
  800fe5:	75 c9                	jne    800fb0 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fe7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fec:	c9                   	leave  
  800fed:	c3                   	ret    

00800fee <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fee:	55                   	push   %ebp
  800fef:	89 e5                	mov    %esp,%ebp
  800ff1:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800ff4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ff7:	8b 45 10             	mov    0x10(%ebp),%eax
  800ffa:	01 d0                	add    %edx,%eax
  800ffc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fff:	eb 15                	jmp    801016 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801001:	8b 45 08             	mov    0x8(%ebp),%eax
  801004:	8a 00                	mov    (%eax),%al
  801006:	0f b6 d0             	movzbl %al,%edx
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	0f b6 c0             	movzbl %al,%eax
  80100f:	39 c2                	cmp    %eax,%edx
  801011:	74 0d                	je     801020 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801013:	ff 45 08             	incl   0x8(%ebp)
  801016:	8b 45 08             	mov    0x8(%ebp),%eax
  801019:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80101c:	72 e3                	jb     801001 <memfind+0x13>
  80101e:	eb 01                	jmp    801021 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801020:	90                   	nop
	return (void *) s;
  801021:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801024:	c9                   	leave  
  801025:	c3                   	ret    

00801026 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801026:	55                   	push   %ebp
  801027:	89 e5                	mov    %esp,%ebp
  801029:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80102c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801033:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103a:	eb 03                	jmp    80103f <strtol+0x19>
		s++;
  80103c:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80103f:	8b 45 08             	mov    0x8(%ebp),%eax
  801042:	8a 00                	mov    (%eax),%al
  801044:	3c 20                	cmp    $0x20,%al
  801046:	74 f4                	je     80103c <strtol+0x16>
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	8a 00                	mov    (%eax),%al
  80104d:	3c 09                	cmp    $0x9,%al
  80104f:	74 eb                	je     80103c <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801051:	8b 45 08             	mov    0x8(%ebp),%eax
  801054:	8a 00                	mov    (%eax),%al
  801056:	3c 2b                	cmp    $0x2b,%al
  801058:	75 05                	jne    80105f <strtol+0x39>
		s++;
  80105a:	ff 45 08             	incl   0x8(%ebp)
  80105d:	eb 13                	jmp    801072 <strtol+0x4c>
	else if (*s == '-')
  80105f:	8b 45 08             	mov    0x8(%ebp),%eax
  801062:	8a 00                	mov    (%eax),%al
  801064:	3c 2d                	cmp    $0x2d,%al
  801066:	75 0a                	jne    801072 <strtol+0x4c>
		s++, neg = 1;
  801068:	ff 45 08             	incl   0x8(%ebp)
  80106b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801072:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801076:	74 06                	je     80107e <strtol+0x58>
  801078:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80107c:	75 20                	jne    80109e <strtol+0x78>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 30                	cmp    $0x30,%al
  801085:	75 17                	jne    80109e <strtol+0x78>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	40                   	inc    %eax
  80108b:	8a 00                	mov    (%eax),%al
  80108d:	3c 78                	cmp    $0x78,%al
  80108f:	75 0d                	jne    80109e <strtol+0x78>
		s += 2, base = 16;
  801091:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801095:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80109c:	eb 28                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80109e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a2:	75 15                	jne    8010b9 <strtol+0x93>
  8010a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a7:	8a 00                	mov    (%eax),%al
  8010a9:	3c 30                	cmp    $0x30,%al
  8010ab:	75 0c                	jne    8010b9 <strtol+0x93>
		s++, base = 8;
  8010ad:	ff 45 08             	incl   0x8(%ebp)
  8010b0:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010b7:	eb 0d                	jmp    8010c6 <strtol+0xa0>
	else if (base == 0)
  8010b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010bd:	75 07                	jne    8010c6 <strtol+0xa0>
		base = 10;
  8010bf:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	8a 00                	mov    (%eax),%al
  8010cb:	3c 2f                	cmp    $0x2f,%al
  8010cd:	7e 19                	jle    8010e8 <strtol+0xc2>
  8010cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d2:	8a 00                	mov    (%eax),%al
  8010d4:	3c 39                	cmp    $0x39,%al
  8010d6:	7f 10                	jg     8010e8 <strtol+0xc2>
			dig = *s - '0';
  8010d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	0f be c0             	movsbl %al,%eax
  8010e0:	83 e8 30             	sub    $0x30,%eax
  8010e3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e6:	eb 42                	jmp    80112a <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010eb:	8a 00                	mov    (%eax),%al
  8010ed:	3c 60                	cmp    $0x60,%al
  8010ef:	7e 19                	jle    80110a <strtol+0xe4>
  8010f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f4:	8a 00                	mov    (%eax),%al
  8010f6:	3c 7a                	cmp    $0x7a,%al
  8010f8:	7f 10                	jg     80110a <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	8a 00                	mov    (%eax),%al
  8010ff:	0f be c0             	movsbl %al,%eax
  801102:	83 e8 57             	sub    $0x57,%eax
  801105:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801108:	eb 20                	jmp    80112a <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80110a:	8b 45 08             	mov    0x8(%ebp),%eax
  80110d:	8a 00                	mov    (%eax),%al
  80110f:	3c 40                	cmp    $0x40,%al
  801111:	7e 39                	jle    80114c <strtol+0x126>
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	8a 00                	mov    (%eax),%al
  801118:	3c 5a                	cmp    $0x5a,%al
  80111a:	7f 30                	jg     80114c <strtol+0x126>
			dig = *s - 'A' + 10;
  80111c:	8b 45 08             	mov    0x8(%ebp),%eax
  80111f:	8a 00                	mov    (%eax),%al
  801121:	0f be c0             	movsbl %al,%eax
  801124:	83 e8 37             	sub    $0x37,%eax
  801127:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80112a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80112d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801130:	7d 19                	jge    80114b <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801132:	ff 45 08             	incl   0x8(%ebp)
  801135:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801138:	0f af 45 10          	imul   0x10(%ebp),%eax
  80113c:	89 c2                	mov    %eax,%edx
  80113e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801141:	01 d0                	add    %edx,%eax
  801143:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801146:	e9 7b ff ff ff       	jmp    8010c6 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80114b:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80114c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801150:	74 08                	je     80115a <strtol+0x134>
		*endptr = (char *) s;
  801152:	8b 45 0c             	mov    0xc(%ebp),%eax
  801155:	8b 55 08             	mov    0x8(%ebp),%edx
  801158:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80115a:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80115e:	74 07                	je     801167 <strtol+0x141>
  801160:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801163:	f7 d8                	neg    %eax
  801165:	eb 03                	jmp    80116a <strtol+0x144>
  801167:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80116a:	c9                   	leave  
  80116b:	c3                   	ret    

0080116c <ltostr>:

void
ltostr(long value, char *str)
{
  80116c:	55                   	push   %ebp
  80116d:	89 e5                	mov    %esp,%ebp
  80116f:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801172:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801179:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801180:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801184:	79 13                	jns    801199 <ltostr+0x2d>
	{
		neg = 1;
  801186:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80118d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801190:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801193:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801196:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801199:	8b 45 08             	mov    0x8(%ebp),%eax
  80119c:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011a1:	99                   	cltd   
  8011a2:	f7 f9                	idiv   %ecx
  8011a4:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011a7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011aa:	8d 50 01             	lea    0x1(%eax),%edx
  8011ad:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011b0:	89 c2                	mov    %eax,%edx
  8011b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b5:	01 d0                	add    %edx,%eax
  8011b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011ba:	83 c2 30             	add    $0x30,%edx
  8011bd:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011bf:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011c2:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011c7:	f7 e9                	imul   %ecx
  8011c9:	c1 fa 02             	sar    $0x2,%edx
  8011cc:	89 c8                	mov    %ecx,%eax
  8011ce:	c1 f8 1f             	sar    $0x1f,%eax
  8011d1:	29 c2                	sub    %eax,%edx
  8011d3:	89 d0                	mov    %edx,%eax
  8011d5:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011d8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011db:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011e0:	f7 e9                	imul   %ecx
  8011e2:	c1 fa 02             	sar    $0x2,%edx
  8011e5:	89 c8                	mov    %ecx,%eax
  8011e7:	c1 f8 1f             	sar    $0x1f,%eax
  8011ea:	29 c2                	sub    %eax,%edx
  8011ec:	89 d0                	mov    %edx,%eax
  8011ee:	c1 e0 02             	shl    $0x2,%eax
  8011f1:	01 d0                	add    %edx,%eax
  8011f3:	01 c0                	add    %eax,%eax
  8011f5:	29 c1                	sub    %eax,%ecx
  8011f7:	89 ca                	mov    %ecx,%edx
  8011f9:	85 d2                	test   %edx,%edx
  8011fb:	75 9c                	jne    801199 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011fd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801204:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801207:	48                   	dec    %eax
  801208:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80120b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80120f:	74 3d                	je     80124e <ltostr+0xe2>
		start = 1 ;
  801211:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801218:	eb 34                	jmp    80124e <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80121a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80121d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801220:	01 d0                	add    %edx,%eax
  801222:	8a 00                	mov    (%eax),%al
  801224:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 c2                	add    %eax,%edx
  80122f:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	01 c8                	add    %ecx,%eax
  801237:	8a 00                	mov    (%eax),%al
  801239:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80123b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80123e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8a 45 eb             	mov    -0x15(%ebp),%al
  801246:	88 02                	mov    %al,(%edx)
		start++ ;
  801248:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80124b:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80124e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801251:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801254:	7c c4                	jl     80121a <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801256:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801259:	8b 45 0c             	mov    0xc(%ebp),%eax
  80125c:	01 d0                	add    %edx,%eax
  80125e:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801261:	90                   	nop
  801262:	c9                   	leave  
  801263:	c3                   	ret    

00801264 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801264:	55                   	push   %ebp
  801265:	89 e5                	mov    %esp,%ebp
  801267:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80126a:	ff 75 08             	pushl  0x8(%ebp)
  80126d:	e8 54 fa ff ff       	call   800cc6 <strlen>
  801272:	83 c4 04             	add    $0x4,%esp
  801275:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801278:	ff 75 0c             	pushl  0xc(%ebp)
  80127b:	e8 46 fa ff ff       	call   800cc6 <strlen>
  801280:	83 c4 04             	add    $0x4,%esp
  801283:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801286:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80128d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801294:	eb 17                	jmp    8012ad <strcconcat+0x49>
		final[s] = str1[s] ;
  801296:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801299:	8b 45 10             	mov    0x10(%ebp),%eax
  80129c:	01 c2                	add    %eax,%edx
  80129e:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	01 c8                	add    %ecx,%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012aa:	ff 45 fc             	incl   -0x4(%ebp)
  8012ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012b0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012b3:	7c e1                	jl     801296 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012b5:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012c3:	eb 1f                	jmp    8012e4 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012c5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c8:	8d 50 01             	lea    0x1(%eax),%edx
  8012cb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012ce:	89 c2                	mov    %eax,%edx
  8012d0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d3:	01 c2                	add    %eax,%edx
  8012d5:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012db:	01 c8                	add    %ecx,%eax
  8012dd:	8a 00                	mov    (%eax),%al
  8012df:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012e1:	ff 45 f8             	incl   -0x8(%ebp)
  8012e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ea:	7c d9                	jl     8012c5 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f2:	01 d0                	add    %edx,%eax
  8012f4:	c6 00 00             	movb   $0x0,(%eax)
}
  8012f7:	90                   	nop
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012fd:	8b 45 14             	mov    0x14(%ebp),%eax
  801300:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801306:	8b 45 14             	mov    0x14(%ebp),%eax
  801309:	8b 00                	mov    (%eax),%eax
  80130b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801312:	8b 45 10             	mov    0x10(%ebp),%eax
  801315:	01 d0                	add    %edx,%eax
  801317:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80131d:	eb 0c                	jmp    80132b <strsplit+0x31>
			*string++ = 0;
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8d 50 01             	lea    0x1(%eax),%edx
  801325:	89 55 08             	mov    %edx,0x8(%ebp)
  801328:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132b:	8b 45 08             	mov    0x8(%ebp),%eax
  80132e:	8a 00                	mov    (%eax),%al
  801330:	84 c0                	test   %al,%al
  801332:	74 18                	je     80134c <strsplit+0x52>
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8a 00                	mov    (%eax),%al
  801339:	0f be c0             	movsbl %al,%eax
  80133c:	50                   	push   %eax
  80133d:	ff 75 0c             	pushl  0xc(%ebp)
  801340:	e8 13 fb ff ff       	call   800e58 <strchr>
  801345:	83 c4 08             	add    $0x8,%esp
  801348:	85 c0                	test   %eax,%eax
  80134a:	75 d3                	jne    80131f <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80134c:	8b 45 08             	mov    0x8(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	84 c0                	test   %al,%al
  801353:	74 5a                	je     8013af <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	83 f8 0f             	cmp    $0xf,%eax
  80135d:	75 07                	jne    801366 <strsplit+0x6c>
		{
			return 0;
  80135f:	b8 00 00 00 00       	mov    $0x0,%eax
  801364:	eb 66                	jmp    8013cc <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801366:	8b 45 14             	mov    0x14(%ebp),%eax
  801369:	8b 00                	mov    (%eax),%eax
  80136b:	8d 48 01             	lea    0x1(%eax),%ecx
  80136e:	8b 55 14             	mov    0x14(%ebp),%edx
  801371:	89 0a                	mov    %ecx,(%edx)
  801373:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80137a:	8b 45 10             	mov    0x10(%ebp),%eax
  80137d:	01 c2                	add    %eax,%edx
  80137f:	8b 45 08             	mov    0x8(%ebp),%eax
  801382:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801384:	eb 03                	jmp    801389 <strsplit+0x8f>
			string++;
  801386:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	8a 00                	mov    (%eax),%al
  80138e:	84 c0                	test   %al,%al
  801390:	74 8b                	je     80131d <strsplit+0x23>
  801392:	8b 45 08             	mov    0x8(%ebp),%eax
  801395:	8a 00                	mov    (%eax),%al
  801397:	0f be c0             	movsbl %al,%eax
  80139a:	50                   	push   %eax
  80139b:	ff 75 0c             	pushl  0xc(%ebp)
  80139e:	e8 b5 fa ff ff       	call   800e58 <strchr>
  8013a3:	83 c4 08             	add    $0x8,%esp
  8013a6:	85 c0                	test   %eax,%eax
  8013a8:	74 dc                	je     801386 <strsplit+0x8c>
			string++;
	}
  8013aa:	e9 6e ff ff ff       	jmp    80131d <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013af:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013b0:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b3:	8b 00                	mov    (%eax),%eax
  8013b5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bf:	01 d0                	add    %edx,%eax
  8013c1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013c7:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013d4:	a1 04 40 80 00       	mov    0x804004,%eax
  8013d9:	85 c0                	test   %eax,%eax
  8013db:	74 1f                	je     8013fc <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013dd:	e8 1d 00 00 00       	call   8013ff <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013e2:	83 ec 0c             	sub    $0xc,%esp
  8013e5:	68 b0 3a 80 00       	push   $0x803ab0
  8013ea:	e8 55 f2 ff ff       	call   800644 <cprintf>
  8013ef:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013f2:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013f9:	00 00 00 
	}
}
  8013fc:	90                   	nop
  8013fd:	c9                   	leave  
  8013fe:	c3                   	ret    

008013ff <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013ff:	55                   	push   %ebp
  801400:	89 e5                	mov    %esp,%ebp
  801402:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801405:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  80140c:	00 00 00 
  80140f:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801416:	00 00 00 
  801419:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801420:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801423:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  80142a:	00 00 00 
  80142d:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801434:	00 00 00 
  801437:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80143e:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801441:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801448:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80144b:	c1 e8 0c             	shr    $0xc,%eax
  80144e:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801453:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  80145a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80145d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801462:	2d 00 10 00 00       	sub    $0x1000,%eax
  801467:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  80146c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801473:	a1 20 41 80 00       	mov    0x804120,%eax
  801478:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  80147c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  80147f:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801486:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801489:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80148c:	01 d0                	add    %edx,%eax
  80148e:	48                   	dec    %eax
  80148f:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801492:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801495:	ba 00 00 00 00       	mov    $0x0,%edx
  80149a:	f7 75 e4             	divl   -0x1c(%ebp)
  80149d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a0:	29 d0                	sub    %edx,%eax
  8014a2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8014a5:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8014ac:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014af:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014b4:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014b9:	83 ec 04             	sub    $0x4,%esp
  8014bc:	6a 07                	push   $0x7
  8014be:	ff 75 e8             	pushl  -0x18(%ebp)
  8014c1:	50                   	push   %eax
  8014c2:	e8 3d 06 00 00       	call   801b04 <sys_allocate_chunk>
  8014c7:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014ca:	a1 20 41 80 00       	mov    0x804120,%eax
  8014cf:	83 ec 0c             	sub    $0xc,%esp
  8014d2:	50                   	push   %eax
  8014d3:	e8 b2 0c 00 00       	call   80218a <initialize_MemBlocksList>
  8014d8:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8014db:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8014e0:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8014e3:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014e7:	0f 84 f3 00 00 00    	je     8015e0 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8014ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014f1:	75 14                	jne    801507 <initialize_dyn_block_system+0x108>
  8014f3:	83 ec 04             	sub    $0x4,%esp
  8014f6:	68 d5 3a 80 00       	push   $0x803ad5
  8014fb:	6a 36                	push   $0x36
  8014fd:	68 f3 3a 80 00       	push   $0x803af3
  801502:	e8 89 ee ff ff       	call   800390 <_panic>
  801507:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80150a:	8b 00                	mov    (%eax),%eax
  80150c:	85 c0                	test   %eax,%eax
  80150e:	74 10                	je     801520 <initialize_dyn_block_system+0x121>
  801510:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801513:	8b 00                	mov    (%eax),%eax
  801515:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801518:	8b 52 04             	mov    0x4(%edx),%edx
  80151b:	89 50 04             	mov    %edx,0x4(%eax)
  80151e:	eb 0b                	jmp    80152b <initialize_dyn_block_system+0x12c>
  801520:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801523:	8b 40 04             	mov    0x4(%eax),%eax
  801526:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80152b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80152e:	8b 40 04             	mov    0x4(%eax),%eax
  801531:	85 c0                	test   %eax,%eax
  801533:	74 0f                	je     801544 <initialize_dyn_block_system+0x145>
  801535:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801538:	8b 40 04             	mov    0x4(%eax),%eax
  80153b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80153e:	8b 12                	mov    (%edx),%edx
  801540:	89 10                	mov    %edx,(%eax)
  801542:	eb 0a                	jmp    80154e <initialize_dyn_block_system+0x14f>
  801544:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801547:	8b 00                	mov    (%eax),%eax
  801549:	a3 48 41 80 00       	mov    %eax,0x804148
  80154e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801551:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801557:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80155a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801561:	a1 54 41 80 00       	mov    0x804154,%eax
  801566:	48                   	dec    %eax
  801567:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  80156c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80156f:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801576:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801579:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801580:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801584:	75 14                	jne    80159a <initialize_dyn_block_system+0x19b>
  801586:	83 ec 04             	sub    $0x4,%esp
  801589:	68 00 3b 80 00       	push   $0x803b00
  80158e:	6a 3e                	push   $0x3e
  801590:	68 f3 3a 80 00       	push   $0x803af3
  801595:	e8 f6 ed ff ff       	call   800390 <_panic>
  80159a:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8015a0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015a3:	89 10                	mov    %edx,(%eax)
  8015a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015a8:	8b 00                	mov    (%eax),%eax
  8015aa:	85 c0                	test   %eax,%eax
  8015ac:	74 0d                	je     8015bb <initialize_dyn_block_system+0x1bc>
  8015ae:	a1 38 41 80 00       	mov    0x804138,%eax
  8015b3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015b6:	89 50 04             	mov    %edx,0x4(%eax)
  8015b9:	eb 08                	jmp    8015c3 <initialize_dyn_block_system+0x1c4>
  8015bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015be:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8015c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015c6:	a3 38 41 80 00       	mov    %eax,0x804138
  8015cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015ce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015d5:	a1 44 41 80 00       	mov    0x804144,%eax
  8015da:	40                   	inc    %eax
  8015db:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8015e0:	90                   	nop
  8015e1:	c9                   	leave  
  8015e2:	c3                   	ret    

008015e3 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015e3:	55                   	push   %ebp
  8015e4:	89 e5                	mov    %esp,%ebp
  8015e6:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8015e9:	e8 e0 fd ff ff       	call   8013ce <InitializeUHeap>
		if (size == 0) return NULL ;
  8015ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015f2:	75 07                	jne    8015fb <malloc+0x18>
  8015f4:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f9:	eb 7f                	jmp    80167a <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8015fb:	e8 d2 08 00 00       	call   801ed2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801600:	85 c0                	test   %eax,%eax
  801602:	74 71                	je     801675 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801604:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  80160b:	8b 55 08             	mov    0x8(%ebp),%edx
  80160e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801611:	01 d0                	add    %edx,%eax
  801613:	48                   	dec    %eax
  801614:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801617:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80161a:	ba 00 00 00 00       	mov    $0x0,%edx
  80161f:	f7 75 f4             	divl   -0xc(%ebp)
  801622:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801625:	29 d0                	sub    %edx,%eax
  801627:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  80162a:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801631:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801638:	76 07                	jbe    801641 <malloc+0x5e>
					return NULL ;
  80163a:	b8 00 00 00 00       	mov    $0x0,%eax
  80163f:	eb 39                	jmp    80167a <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801641:	83 ec 0c             	sub    $0xc,%esp
  801644:	ff 75 08             	pushl  0x8(%ebp)
  801647:	e8 e6 0d 00 00       	call   802432 <alloc_block_FF>
  80164c:	83 c4 10             	add    $0x10,%esp
  80164f:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801652:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801656:	74 16                	je     80166e <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801658:	83 ec 0c             	sub    $0xc,%esp
  80165b:	ff 75 ec             	pushl  -0x14(%ebp)
  80165e:	e8 37 0c 00 00       	call   80229a <insert_sorted_allocList>
  801663:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801666:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801669:	8b 40 08             	mov    0x8(%eax),%eax
  80166c:	eb 0c                	jmp    80167a <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  80166e:	b8 00 00 00 00       	mov    $0x0,%eax
  801673:	eb 05                	jmp    80167a <malloc+0x97>
				}
		}
	return 0;
  801675:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80167a:	c9                   	leave  
  80167b:	c3                   	ret    

0080167c <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  80167c:	55                   	push   %ebp
  80167d:	89 e5                	mov    %esp,%ebp
  80167f:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801682:	8b 45 08             	mov    0x8(%ebp),%eax
  801685:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801688:	83 ec 08             	sub    $0x8,%esp
  80168b:	ff 75 f4             	pushl  -0xc(%ebp)
  80168e:	68 40 40 80 00       	push   $0x804040
  801693:	e8 cf 0b 00 00       	call   802267 <find_block>
  801698:	83 c4 10             	add    $0x10,%esp
  80169b:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  80169e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a1:	8b 40 0c             	mov    0xc(%eax),%eax
  8016a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8016a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016aa:	8b 40 08             	mov    0x8(%eax),%eax
  8016ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8016b0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016b4:	0f 84 a1 00 00 00    	je     80175b <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8016ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016be:	75 17                	jne    8016d7 <free+0x5b>
  8016c0:	83 ec 04             	sub    $0x4,%esp
  8016c3:	68 d5 3a 80 00       	push   $0x803ad5
  8016c8:	68 80 00 00 00       	push   $0x80
  8016cd:	68 f3 3a 80 00       	push   $0x803af3
  8016d2:	e8 b9 ec ff ff       	call   800390 <_panic>
  8016d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016da:	8b 00                	mov    (%eax),%eax
  8016dc:	85 c0                	test   %eax,%eax
  8016de:	74 10                	je     8016f0 <free+0x74>
  8016e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e3:	8b 00                	mov    (%eax),%eax
  8016e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016e8:	8b 52 04             	mov    0x4(%edx),%edx
  8016eb:	89 50 04             	mov    %edx,0x4(%eax)
  8016ee:	eb 0b                	jmp    8016fb <free+0x7f>
  8016f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f3:	8b 40 04             	mov    0x4(%eax),%eax
  8016f6:	a3 44 40 80 00       	mov    %eax,0x804044
  8016fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fe:	8b 40 04             	mov    0x4(%eax),%eax
  801701:	85 c0                	test   %eax,%eax
  801703:	74 0f                	je     801714 <free+0x98>
  801705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801708:	8b 40 04             	mov    0x4(%eax),%eax
  80170b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80170e:	8b 12                	mov    (%edx),%edx
  801710:	89 10                	mov    %edx,(%eax)
  801712:	eb 0a                	jmp    80171e <free+0xa2>
  801714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801717:	8b 00                	mov    (%eax),%eax
  801719:	a3 40 40 80 00       	mov    %eax,0x804040
  80171e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801721:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801727:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801731:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801736:	48                   	dec    %eax
  801737:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  80173c:	83 ec 0c             	sub    $0xc,%esp
  80173f:	ff 75 f0             	pushl  -0x10(%ebp)
  801742:	e8 29 12 00 00       	call   802970 <insert_sorted_with_merge_freeList>
  801747:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  80174a:	83 ec 08             	sub    $0x8,%esp
  80174d:	ff 75 ec             	pushl  -0x14(%ebp)
  801750:	ff 75 e8             	pushl  -0x18(%ebp)
  801753:	e8 74 03 00 00       	call   801acc <sys_free_user_mem>
  801758:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  80175b:	90                   	nop
  80175c:	c9                   	leave  
  80175d:	c3                   	ret    

0080175e <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  80175e:	55                   	push   %ebp
  80175f:	89 e5                	mov    %esp,%ebp
  801761:	83 ec 38             	sub    $0x38,%esp
  801764:	8b 45 10             	mov    0x10(%ebp),%eax
  801767:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80176a:	e8 5f fc ff ff       	call   8013ce <InitializeUHeap>
	if (size == 0) return NULL ;
  80176f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801773:	75 0a                	jne    80177f <smalloc+0x21>
  801775:	b8 00 00 00 00       	mov    $0x0,%eax
  80177a:	e9 b2 00 00 00       	jmp    801831 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  80177f:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801786:	76 0a                	jbe    801792 <smalloc+0x34>
		return NULL;
  801788:	b8 00 00 00 00       	mov    $0x0,%eax
  80178d:	e9 9f 00 00 00       	jmp    801831 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801792:	e8 3b 07 00 00       	call   801ed2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801797:	85 c0                	test   %eax,%eax
  801799:	0f 84 8d 00 00 00    	je     80182c <smalloc+0xce>
	struct MemBlock *b = NULL;
  80179f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8017a6:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017b3:	01 d0                	add    %edx,%eax
  8017b5:	48                   	dec    %eax
  8017b6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8017c1:	f7 75 f0             	divl   -0x10(%ebp)
  8017c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c7:	29 d0                	sub    %edx,%eax
  8017c9:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8017cc:	83 ec 0c             	sub    $0xc,%esp
  8017cf:	ff 75 e8             	pushl  -0x18(%ebp)
  8017d2:	e8 5b 0c 00 00       	call   802432 <alloc_block_FF>
  8017d7:	83 c4 10             	add    $0x10,%esp
  8017da:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8017dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017e1:	75 07                	jne    8017ea <smalloc+0x8c>
			return NULL;
  8017e3:	b8 00 00 00 00       	mov    $0x0,%eax
  8017e8:	eb 47                	jmp    801831 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8017ea:	83 ec 0c             	sub    $0xc,%esp
  8017ed:	ff 75 f4             	pushl  -0xc(%ebp)
  8017f0:	e8 a5 0a 00 00       	call   80229a <insert_sorted_allocList>
  8017f5:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8017f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fb:	8b 40 08             	mov    0x8(%eax),%eax
  8017fe:	89 c2                	mov    %eax,%edx
  801800:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801804:	52                   	push   %edx
  801805:	50                   	push   %eax
  801806:	ff 75 0c             	pushl  0xc(%ebp)
  801809:	ff 75 08             	pushl  0x8(%ebp)
  80180c:	e8 46 04 00 00       	call   801c57 <sys_createSharedObject>
  801811:	83 c4 10             	add    $0x10,%esp
  801814:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801817:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80181b:	78 08                	js     801825 <smalloc+0xc7>
		return (void *)b->sva;
  80181d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801820:	8b 40 08             	mov    0x8(%eax),%eax
  801823:	eb 0c                	jmp    801831 <smalloc+0xd3>
		}else{
		return NULL;
  801825:	b8 00 00 00 00       	mov    $0x0,%eax
  80182a:	eb 05                	jmp    801831 <smalloc+0xd3>
			}

	}return NULL;
  80182c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801831:	c9                   	leave  
  801832:	c3                   	ret    

00801833 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801833:	55                   	push   %ebp
  801834:	89 e5                	mov    %esp,%ebp
  801836:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801839:	e8 90 fb ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80183e:	e8 8f 06 00 00       	call   801ed2 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801843:	85 c0                	test   %eax,%eax
  801845:	0f 84 ad 00 00 00    	je     8018f8 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  80184b:	83 ec 08             	sub    $0x8,%esp
  80184e:	ff 75 0c             	pushl  0xc(%ebp)
  801851:	ff 75 08             	pushl  0x8(%ebp)
  801854:	e8 28 04 00 00       	call   801c81 <sys_getSizeOfSharedObject>
  801859:	83 c4 10             	add    $0x10,%esp
  80185c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  80185f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801863:	79 0a                	jns    80186f <sget+0x3c>
    {
    	return NULL;
  801865:	b8 00 00 00 00       	mov    $0x0,%eax
  80186a:	e9 8e 00 00 00       	jmp    8018fd <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  80186f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801876:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80187d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801880:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801883:	01 d0                	add    %edx,%eax
  801885:	48                   	dec    %eax
  801886:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801889:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80188c:	ba 00 00 00 00       	mov    $0x0,%edx
  801891:	f7 75 ec             	divl   -0x14(%ebp)
  801894:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801897:	29 d0                	sub    %edx,%eax
  801899:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  80189c:	83 ec 0c             	sub    $0xc,%esp
  80189f:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018a2:	e8 8b 0b 00 00       	call   802432 <alloc_block_FF>
  8018a7:	83 c4 10             	add    $0x10,%esp
  8018aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8018ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018b1:	75 07                	jne    8018ba <sget+0x87>
				return NULL;
  8018b3:	b8 00 00 00 00       	mov    $0x0,%eax
  8018b8:	eb 43                	jmp    8018fd <sget+0xca>
			}
			insert_sorted_allocList(b);
  8018ba:	83 ec 0c             	sub    $0xc,%esp
  8018bd:	ff 75 f0             	pushl  -0x10(%ebp)
  8018c0:	e8 d5 09 00 00       	call   80229a <insert_sorted_allocList>
  8018c5:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8018c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018cb:	8b 40 08             	mov    0x8(%eax),%eax
  8018ce:	83 ec 04             	sub    $0x4,%esp
  8018d1:	50                   	push   %eax
  8018d2:	ff 75 0c             	pushl  0xc(%ebp)
  8018d5:	ff 75 08             	pushl  0x8(%ebp)
  8018d8:	e8 c1 03 00 00       	call   801c9e <sys_getSharedObject>
  8018dd:	83 c4 10             	add    $0x10,%esp
  8018e0:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8018e3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018e7:	78 08                	js     8018f1 <sget+0xbe>
			return (void *)b->sva;
  8018e9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018ec:	8b 40 08             	mov    0x8(%eax),%eax
  8018ef:	eb 0c                	jmp    8018fd <sget+0xca>
			}else{
			return NULL;
  8018f1:	b8 00 00 00 00       	mov    $0x0,%eax
  8018f6:	eb 05                	jmp    8018fd <sget+0xca>
			}
    }}return NULL;
  8018f8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
  801902:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801905:	e8 c4 fa ff ff       	call   8013ce <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80190a:	83 ec 04             	sub    $0x4,%esp
  80190d:	68 24 3b 80 00       	push   $0x803b24
  801912:	68 03 01 00 00       	push   $0x103
  801917:	68 f3 3a 80 00       	push   $0x803af3
  80191c:	e8 6f ea ff ff       	call   800390 <_panic>

00801921 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801921:	55                   	push   %ebp
  801922:	89 e5                	mov    %esp,%ebp
  801924:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801927:	83 ec 04             	sub    $0x4,%esp
  80192a:	68 4c 3b 80 00       	push   $0x803b4c
  80192f:	68 17 01 00 00       	push   $0x117
  801934:	68 f3 3a 80 00       	push   $0x803af3
  801939:	e8 52 ea ff ff       	call   800390 <_panic>

0080193e <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801944:	83 ec 04             	sub    $0x4,%esp
  801947:	68 70 3b 80 00       	push   $0x803b70
  80194c:	68 22 01 00 00       	push   $0x122
  801951:	68 f3 3a 80 00       	push   $0x803af3
  801956:	e8 35 ea ff ff       	call   800390 <_panic>

0080195b <shrink>:

}
void shrink(uint32 newSize)
{
  80195b:	55                   	push   %ebp
  80195c:	89 e5                	mov    %esp,%ebp
  80195e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801961:	83 ec 04             	sub    $0x4,%esp
  801964:	68 70 3b 80 00       	push   $0x803b70
  801969:	68 27 01 00 00       	push   $0x127
  80196e:	68 f3 3a 80 00       	push   $0x803af3
  801973:	e8 18 ea ff ff       	call   800390 <_panic>

00801978 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801978:	55                   	push   %ebp
  801979:	89 e5                	mov    %esp,%ebp
  80197b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80197e:	83 ec 04             	sub    $0x4,%esp
  801981:	68 70 3b 80 00       	push   $0x803b70
  801986:	68 2c 01 00 00       	push   $0x12c
  80198b:	68 f3 3a 80 00       	push   $0x803af3
  801990:	e8 fb e9 ff ff       	call   800390 <_panic>

00801995 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	57                   	push   %edi
  801999:	56                   	push   %esi
  80199a:	53                   	push   %ebx
  80199b:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019a4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019a7:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019aa:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019ad:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019b0:	cd 30                	int    $0x30
  8019b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019b8:	83 c4 10             	add    $0x10,%esp
  8019bb:	5b                   	pop    %ebx
  8019bc:	5e                   	pop    %esi
  8019bd:	5f                   	pop    %edi
  8019be:	5d                   	pop    %ebp
  8019bf:	c3                   	ret    

008019c0 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019c0:	55                   	push   %ebp
  8019c1:	89 e5                	mov    %esp,%ebp
  8019c3:	83 ec 04             	sub    $0x4,%esp
  8019c6:	8b 45 10             	mov    0x10(%ebp),%eax
  8019c9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019cc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	52                   	push   %edx
  8019d8:	ff 75 0c             	pushl  0xc(%ebp)
  8019db:	50                   	push   %eax
  8019dc:	6a 00                	push   $0x0
  8019de:	e8 b2 ff ff ff       	call   801995 <syscall>
  8019e3:	83 c4 18             	add    $0x18,%esp
}
  8019e6:	90                   	nop
  8019e7:	c9                   	leave  
  8019e8:	c3                   	ret    

008019e9 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019e9:	55                   	push   %ebp
  8019ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019ec:	6a 00                	push   $0x0
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 01                	push   $0x1
  8019f8:	e8 98 ff ff ff       	call   801995 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a05:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a08:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	52                   	push   %edx
  801a12:	50                   	push   %eax
  801a13:	6a 05                	push   $0x5
  801a15:	e8 7b ff ff ff       	call   801995 <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
}
  801a1d:	c9                   	leave  
  801a1e:	c3                   	ret    

00801a1f <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a1f:	55                   	push   %ebp
  801a20:	89 e5                	mov    %esp,%ebp
  801a22:	56                   	push   %esi
  801a23:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a24:	8b 75 18             	mov    0x18(%ebp),%esi
  801a27:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a2a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a2d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a30:	8b 45 08             	mov    0x8(%ebp),%eax
  801a33:	56                   	push   %esi
  801a34:	53                   	push   %ebx
  801a35:	51                   	push   %ecx
  801a36:	52                   	push   %edx
  801a37:	50                   	push   %eax
  801a38:	6a 06                	push   $0x6
  801a3a:	e8 56 ff ff ff       	call   801995 <syscall>
  801a3f:	83 c4 18             	add    $0x18,%esp
}
  801a42:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a45:	5b                   	pop    %ebx
  801a46:	5e                   	pop    %esi
  801a47:	5d                   	pop    %ebp
  801a48:	c3                   	ret    

00801a49 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 00                	push   $0x0
  801a58:	52                   	push   %edx
  801a59:	50                   	push   %eax
  801a5a:	6a 07                	push   $0x7
  801a5c:	e8 34 ff ff ff       	call   801995 <syscall>
  801a61:	83 c4 18             	add    $0x18,%esp
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	ff 75 0c             	pushl  0xc(%ebp)
  801a72:	ff 75 08             	pushl  0x8(%ebp)
  801a75:	6a 08                	push   $0x8
  801a77:	e8 19 ff ff ff       	call   801995 <syscall>
  801a7c:	83 c4 18             	add    $0x18,%esp
}
  801a7f:	c9                   	leave  
  801a80:	c3                   	ret    

00801a81 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a81:	55                   	push   %ebp
  801a82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 00                	push   $0x0
  801a8e:	6a 09                	push   $0x9
  801a90:	e8 00 ff ff ff       	call   801995 <syscall>
  801a95:	83 c4 18             	add    $0x18,%esp
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 0a                	push   $0xa
  801aa9:	e8 e7 fe ff ff       	call   801995 <syscall>
  801aae:	83 c4 18             	add    $0x18,%esp
}
  801ab1:	c9                   	leave  
  801ab2:	c3                   	ret    

00801ab3 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ab3:	55                   	push   %ebp
  801ab4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 0b                	push   $0xb
  801ac2:	e8 ce fe ff ff       	call   801995 <syscall>
  801ac7:	83 c4 18             	add    $0x18,%esp
}
  801aca:	c9                   	leave  
  801acb:	c3                   	ret    

00801acc <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801acc:	55                   	push   %ebp
  801acd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	ff 75 0c             	pushl  0xc(%ebp)
  801ad8:	ff 75 08             	pushl  0x8(%ebp)
  801adb:	6a 0f                	push   $0xf
  801add:	e8 b3 fe ff ff       	call   801995 <syscall>
  801ae2:	83 c4 18             	add    $0x18,%esp
	return;
  801ae5:	90                   	nop
}
  801ae6:	c9                   	leave  
  801ae7:	c3                   	ret    

00801ae8 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ae8:	55                   	push   %ebp
  801ae9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801aeb:	6a 00                	push   $0x0
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	ff 75 0c             	pushl  0xc(%ebp)
  801af4:	ff 75 08             	pushl  0x8(%ebp)
  801af7:	6a 10                	push   $0x10
  801af9:	e8 97 fe ff ff       	call   801995 <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
	return ;
  801b01:	90                   	nop
}
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	ff 75 10             	pushl  0x10(%ebp)
  801b0e:	ff 75 0c             	pushl  0xc(%ebp)
  801b11:	ff 75 08             	pushl  0x8(%ebp)
  801b14:	6a 11                	push   $0x11
  801b16:	e8 7a fe ff ff       	call   801995 <syscall>
  801b1b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b1e:	90                   	nop
}
  801b1f:	c9                   	leave  
  801b20:	c3                   	ret    

00801b21 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b21:	55                   	push   %ebp
  801b22:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b24:	6a 00                	push   $0x0
  801b26:	6a 00                	push   $0x0
  801b28:	6a 00                	push   $0x0
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 0c                	push   $0xc
  801b30:	e8 60 fe ff ff       	call   801995 <syscall>
  801b35:	83 c4 18             	add    $0x18,%esp
}
  801b38:	c9                   	leave  
  801b39:	c3                   	ret    

00801b3a <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b3a:	55                   	push   %ebp
  801b3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	ff 75 08             	pushl  0x8(%ebp)
  801b48:	6a 0d                	push   $0xd
  801b4a:	e8 46 fe ff ff       	call   801995 <syscall>
  801b4f:	83 c4 18             	add    $0x18,%esp
}
  801b52:	c9                   	leave  
  801b53:	c3                   	ret    

00801b54 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b54:	55                   	push   %ebp
  801b55:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	6a 00                	push   $0x0
  801b61:	6a 0e                	push   $0xe
  801b63:	e8 2d fe ff ff       	call   801995 <syscall>
  801b68:	83 c4 18             	add    $0x18,%esp
}
  801b6b:	90                   	nop
  801b6c:	c9                   	leave  
  801b6d:	c3                   	ret    

00801b6e <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b6e:	55                   	push   %ebp
  801b6f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b71:	6a 00                	push   $0x0
  801b73:	6a 00                	push   $0x0
  801b75:	6a 00                	push   $0x0
  801b77:	6a 00                	push   $0x0
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 13                	push   $0x13
  801b7d:	e8 13 fe ff ff       	call   801995 <syscall>
  801b82:	83 c4 18             	add    $0x18,%esp
}
  801b85:	90                   	nop
  801b86:	c9                   	leave  
  801b87:	c3                   	ret    

00801b88 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b88:	55                   	push   %ebp
  801b89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b8b:	6a 00                	push   $0x0
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	6a 00                	push   $0x0
  801b95:	6a 14                	push   $0x14
  801b97:	e8 f9 fd ff ff       	call   801995 <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	90                   	nop
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
  801ba5:	83 ec 04             	sub    $0x4,%esp
  801ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  801bab:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bae:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 00                	push   $0x0
  801bb8:	6a 00                	push   $0x0
  801bba:	50                   	push   %eax
  801bbb:	6a 15                	push   $0x15
  801bbd:	e8 d3 fd ff ff       	call   801995 <syscall>
  801bc2:	83 c4 18             	add    $0x18,%esp
}
  801bc5:	90                   	nop
  801bc6:	c9                   	leave  
  801bc7:	c3                   	ret    

00801bc8 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bc8:	55                   	push   %ebp
  801bc9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 00                	push   $0x0
  801bd1:	6a 00                	push   $0x0
  801bd3:	6a 00                	push   $0x0
  801bd5:	6a 16                	push   $0x16
  801bd7:	e8 b9 fd ff ff       	call   801995 <syscall>
  801bdc:	83 c4 18             	add    $0x18,%esp
}
  801bdf:	90                   	nop
  801be0:	c9                   	leave  
  801be1:	c3                   	ret    

00801be2 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801be2:	55                   	push   %ebp
  801be3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801be5:	8b 45 08             	mov    0x8(%ebp),%eax
  801be8:	6a 00                	push   $0x0
  801bea:	6a 00                	push   $0x0
  801bec:	6a 00                	push   $0x0
  801bee:	ff 75 0c             	pushl  0xc(%ebp)
  801bf1:	50                   	push   %eax
  801bf2:	6a 17                	push   $0x17
  801bf4:	e8 9c fd ff ff       	call   801995 <syscall>
  801bf9:	83 c4 18             	add    $0x18,%esp
}
  801bfc:	c9                   	leave  
  801bfd:	c3                   	ret    

00801bfe <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bfe:	55                   	push   %ebp
  801bff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c04:	8b 45 08             	mov    0x8(%ebp),%eax
  801c07:	6a 00                	push   $0x0
  801c09:	6a 00                	push   $0x0
  801c0b:	6a 00                	push   $0x0
  801c0d:	52                   	push   %edx
  801c0e:	50                   	push   %eax
  801c0f:	6a 1a                	push   $0x1a
  801c11:	e8 7f fd ff ff       	call   801995 <syscall>
  801c16:	83 c4 18             	add    $0x18,%esp
}
  801c19:	c9                   	leave  
  801c1a:	c3                   	ret    

00801c1b <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c1b:	55                   	push   %ebp
  801c1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c1e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c21:	8b 45 08             	mov    0x8(%ebp),%eax
  801c24:	6a 00                	push   $0x0
  801c26:	6a 00                	push   $0x0
  801c28:	6a 00                	push   $0x0
  801c2a:	52                   	push   %edx
  801c2b:	50                   	push   %eax
  801c2c:	6a 18                	push   $0x18
  801c2e:	e8 62 fd ff ff       	call   801995 <syscall>
  801c33:	83 c4 18             	add    $0x18,%esp
}
  801c36:	90                   	nop
  801c37:	c9                   	leave  
  801c38:	c3                   	ret    

00801c39 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c39:	55                   	push   %ebp
  801c3a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c3c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	52                   	push   %edx
  801c49:	50                   	push   %eax
  801c4a:	6a 19                	push   $0x19
  801c4c:	e8 44 fd ff ff       	call   801995 <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
}
  801c54:	90                   	nop
  801c55:	c9                   	leave  
  801c56:	c3                   	ret    

00801c57 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c57:	55                   	push   %ebp
  801c58:	89 e5                	mov    %esp,%ebp
  801c5a:	83 ec 04             	sub    $0x4,%esp
  801c5d:	8b 45 10             	mov    0x10(%ebp),%eax
  801c60:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c63:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c66:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6d:	6a 00                	push   $0x0
  801c6f:	51                   	push   %ecx
  801c70:	52                   	push   %edx
  801c71:	ff 75 0c             	pushl  0xc(%ebp)
  801c74:	50                   	push   %eax
  801c75:	6a 1b                	push   $0x1b
  801c77:	e8 19 fd ff ff       	call   801995 <syscall>
  801c7c:	83 c4 18             	add    $0x18,%esp
}
  801c7f:	c9                   	leave  
  801c80:	c3                   	ret    

00801c81 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c81:	55                   	push   %ebp
  801c82:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c84:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c87:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 00                	push   $0x0
  801c90:	52                   	push   %edx
  801c91:	50                   	push   %eax
  801c92:	6a 1c                	push   $0x1c
  801c94:	e8 fc fc ff ff       	call   801995 <syscall>
  801c99:	83 c4 18             	add    $0x18,%esp
}
  801c9c:	c9                   	leave  
  801c9d:	c3                   	ret    

00801c9e <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c9e:	55                   	push   %ebp
  801c9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ca1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ca4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  801caa:	6a 00                	push   $0x0
  801cac:	6a 00                	push   $0x0
  801cae:	51                   	push   %ecx
  801caf:	52                   	push   %edx
  801cb0:	50                   	push   %eax
  801cb1:	6a 1d                	push   $0x1d
  801cb3:	e8 dd fc ff ff       	call   801995 <syscall>
  801cb8:	83 c4 18             	add    $0x18,%esp
}
  801cbb:	c9                   	leave  
  801cbc:	c3                   	ret    

00801cbd <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cbd:	55                   	push   %ebp
  801cbe:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801cc0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cc3:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc6:	6a 00                	push   $0x0
  801cc8:	6a 00                	push   $0x0
  801cca:	6a 00                	push   $0x0
  801ccc:	52                   	push   %edx
  801ccd:	50                   	push   %eax
  801cce:	6a 1e                	push   $0x1e
  801cd0:	e8 c0 fc ff ff       	call   801995 <syscall>
  801cd5:	83 c4 18             	add    $0x18,%esp
}
  801cd8:	c9                   	leave  
  801cd9:	c3                   	ret    

00801cda <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cda:	55                   	push   %ebp
  801cdb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cdd:	6a 00                	push   $0x0
  801cdf:	6a 00                	push   $0x0
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 1f                	push   $0x1f
  801ce9:	e8 a7 fc ff ff       	call   801995 <syscall>
  801cee:	83 c4 18             	add    $0x18,%esp
}
  801cf1:	c9                   	leave  
  801cf2:	c3                   	ret    

00801cf3 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801cf3:	55                   	push   %ebp
  801cf4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	6a 00                	push   $0x0
  801cfb:	ff 75 14             	pushl  0x14(%ebp)
  801cfe:	ff 75 10             	pushl  0x10(%ebp)
  801d01:	ff 75 0c             	pushl  0xc(%ebp)
  801d04:	50                   	push   %eax
  801d05:	6a 20                	push   $0x20
  801d07:	e8 89 fc ff ff       	call   801995 <syscall>
  801d0c:	83 c4 18             	add    $0x18,%esp
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	50                   	push   %eax
  801d20:	6a 21                	push   $0x21
  801d22:	e8 6e fc ff ff       	call   801995 <syscall>
  801d27:	83 c4 18             	add    $0x18,%esp
}
  801d2a:	90                   	nop
  801d2b:	c9                   	leave  
  801d2c:	c3                   	ret    

00801d2d <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d2d:	55                   	push   %ebp
  801d2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d30:	8b 45 08             	mov    0x8(%ebp),%eax
  801d33:	6a 00                	push   $0x0
  801d35:	6a 00                	push   $0x0
  801d37:	6a 00                	push   $0x0
  801d39:	6a 00                	push   $0x0
  801d3b:	50                   	push   %eax
  801d3c:	6a 22                	push   $0x22
  801d3e:	e8 52 fc ff ff       	call   801995 <syscall>
  801d43:	83 c4 18             	add    $0x18,%esp
}
  801d46:	c9                   	leave  
  801d47:	c3                   	ret    

00801d48 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d48:	55                   	push   %ebp
  801d49:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d4b:	6a 00                	push   $0x0
  801d4d:	6a 00                	push   $0x0
  801d4f:	6a 00                	push   $0x0
  801d51:	6a 00                	push   $0x0
  801d53:	6a 00                	push   $0x0
  801d55:	6a 02                	push   $0x2
  801d57:	e8 39 fc ff ff       	call   801995 <syscall>
  801d5c:	83 c4 18             	add    $0x18,%esp
}
  801d5f:	c9                   	leave  
  801d60:	c3                   	ret    

00801d61 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d61:	55                   	push   %ebp
  801d62:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d64:	6a 00                	push   $0x0
  801d66:	6a 00                	push   $0x0
  801d68:	6a 00                	push   $0x0
  801d6a:	6a 00                	push   $0x0
  801d6c:	6a 00                	push   $0x0
  801d6e:	6a 03                	push   $0x3
  801d70:	e8 20 fc ff ff       	call   801995 <syscall>
  801d75:	83 c4 18             	add    $0x18,%esp
}
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d7d:	6a 00                	push   $0x0
  801d7f:	6a 00                	push   $0x0
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 04                	push   $0x4
  801d89:	e8 07 fc ff ff       	call   801995 <syscall>
  801d8e:	83 c4 18             	add    $0x18,%esp
}
  801d91:	c9                   	leave  
  801d92:	c3                   	ret    

00801d93 <sys_exit_env>:


void sys_exit_env(void)
{
  801d93:	55                   	push   %ebp
  801d94:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	6a 00                	push   $0x0
  801d9e:	6a 00                	push   $0x0
  801da0:	6a 23                	push   $0x23
  801da2:	e8 ee fb ff ff       	call   801995 <syscall>
  801da7:	83 c4 18             	add    $0x18,%esp
}
  801daa:	90                   	nop
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801db3:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801db6:	8d 50 04             	lea    0x4(%eax),%edx
  801db9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dbc:	6a 00                	push   $0x0
  801dbe:	6a 00                	push   $0x0
  801dc0:	6a 00                	push   $0x0
  801dc2:	52                   	push   %edx
  801dc3:	50                   	push   %eax
  801dc4:	6a 24                	push   $0x24
  801dc6:	e8 ca fb ff ff       	call   801995 <syscall>
  801dcb:	83 c4 18             	add    $0x18,%esp
	return result;
  801dce:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dd1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dd4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801dd7:	89 01                	mov    %eax,(%ecx)
  801dd9:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  801ddf:	c9                   	leave  
  801de0:	c2 04 00             	ret    $0x4

00801de3 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801de3:	55                   	push   %ebp
  801de4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801de6:	6a 00                	push   $0x0
  801de8:	6a 00                	push   $0x0
  801dea:	ff 75 10             	pushl  0x10(%ebp)
  801ded:	ff 75 0c             	pushl  0xc(%ebp)
  801df0:	ff 75 08             	pushl  0x8(%ebp)
  801df3:	6a 12                	push   $0x12
  801df5:	e8 9b fb ff ff       	call   801995 <syscall>
  801dfa:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfd:	90                   	nop
}
  801dfe:	c9                   	leave  
  801dff:	c3                   	ret    

00801e00 <sys_rcr2>:
uint32 sys_rcr2()
{
  801e00:	55                   	push   %ebp
  801e01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	6a 25                	push   $0x25
  801e0f:	e8 81 fb ff ff       	call   801995 <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
}
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
  801e1c:	83 ec 04             	sub    $0x4,%esp
  801e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  801e22:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e25:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e29:	6a 00                	push   $0x0
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	50                   	push   %eax
  801e32:	6a 26                	push   $0x26
  801e34:	e8 5c fb ff ff       	call   801995 <syscall>
  801e39:	83 c4 18             	add    $0x18,%esp
	return ;
  801e3c:	90                   	nop
}
  801e3d:	c9                   	leave  
  801e3e:	c3                   	ret    

00801e3f <rsttst>:
void rsttst()
{
  801e3f:	55                   	push   %ebp
  801e40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e42:	6a 00                	push   $0x0
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 28                	push   $0x28
  801e4e:	e8 42 fb ff ff       	call   801995 <syscall>
  801e53:	83 c4 18             	add    $0x18,%esp
	return ;
  801e56:	90                   	nop
}
  801e57:	c9                   	leave  
  801e58:	c3                   	ret    

00801e59 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e59:	55                   	push   %ebp
  801e5a:	89 e5                	mov    %esp,%ebp
  801e5c:	83 ec 04             	sub    $0x4,%esp
  801e5f:	8b 45 14             	mov    0x14(%ebp),%eax
  801e62:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e65:	8b 55 18             	mov    0x18(%ebp),%edx
  801e68:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e6c:	52                   	push   %edx
  801e6d:	50                   	push   %eax
  801e6e:	ff 75 10             	pushl  0x10(%ebp)
  801e71:	ff 75 0c             	pushl  0xc(%ebp)
  801e74:	ff 75 08             	pushl  0x8(%ebp)
  801e77:	6a 27                	push   $0x27
  801e79:	e8 17 fb ff ff       	call   801995 <syscall>
  801e7e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e81:	90                   	nop
}
  801e82:	c9                   	leave  
  801e83:	c3                   	ret    

00801e84 <chktst>:
void chktst(uint32 n)
{
  801e84:	55                   	push   %ebp
  801e85:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e87:	6a 00                	push   $0x0
  801e89:	6a 00                	push   $0x0
  801e8b:	6a 00                	push   $0x0
  801e8d:	6a 00                	push   $0x0
  801e8f:	ff 75 08             	pushl  0x8(%ebp)
  801e92:	6a 29                	push   $0x29
  801e94:	e8 fc fa ff ff       	call   801995 <syscall>
  801e99:	83 c4 18             	add    $0x18,%esp
	return ;
  801e9c:	90                   	nop
}
  801e9d:	c9                   	leave  
  801e9e:	c3                   	ret    

00801e9f <inctst>:

void inctst()
{
  801e9f:	55                   	push   %ebp
  801ea0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801ea2:	6a 00                	push   $0x0
  801ea4:	6a 00                	push   $0x0
  801ea6:	6a 00                	push   $0x0
  801ea8:	6a 00                	push   $0x0
  801eaa:	6a 00                	push   $0x0
  801eac:	6a 2a                	push   $0x2a
  801eae:	e8 e2 fa ff ff       	call   801995 <syscall>
  801eb3:	83 c4 18             	add    $0x18,%esp
	return ;
  801eb6:	90                   	nop
}
  801eb7:	c9                   	leave  
  801eb8:	c3                   	ret    

00801eb9 <gettst>:
uint32 gettst()
{
  801eb9:	55                   	push   %ebp
  801eba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ebc:	6a 00                	push   $0x0
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 2b                	push   $0x2b
  801ec8:	e8 c8 fa ff ff       	call   801995 <syscall>
  801ecd:	83 c4 18             	add    $0x18,%esp
}
  801ed0:	c9                   	leave  
  801ed1:	c3                   	ret    

00801ed2 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ed2:	55                   	push   %ebp
  801ed3:	89 e5                	mov    %esp,%ebp
  801ed5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 00                	push   $0x0
  801edc:	6a 00                	push   $0x0
  801ede:	6a 00                	push   $0x0
  801ee0:	6a 00                	push   $0x0
  801ee2:	6a 2c                	push   $0x2c
  801ee4:	e8 ac fa ff ff       	call   801995 <syscall>
  801ee9:	83 c4 18             	add    $0x18,%esp
  801eec:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801eef:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ef3:	75 07                	jne    801efc <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ef5:	b8 01 00 00 00       	mov    $0x1,%eax
  801efa:	eb 05                	jmp    801f01 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801efc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f01:	c9                   	leave  
  801f02:	c3                   	ret    

00801f03 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f03:	55                   	push   %ebp
  801f04:	89 e5                	mov    %esp,%ebp
  801f06:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 00                	push   $0x0
  801f0d:	6a 00                	push   $0x0
  801f0f:	6a 00                	push   $0x0
  801f11:	6a 00                	push   $0x0
  801f13:	6a 2c                	push   $0x2c
  801f15:	e8 7b fa ff ff       	call   801995 <syscall>
  801f1a:	83 c4 18             	add    $0x18,%esp
  801f1d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f20:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f24:	75 07                	jne    801f2d <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f26:	b8 01 00 00 00       	mov    $0x1,%eax
  801f2b:	eb 05                	jmp    801f32 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f2d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f32:	c9                   	leave  
  801f33:	c3                   	ret    

00801f34 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f34:	55                   	push   %ebp
  801f35:	89 e5                	mov    %esp,%ebp
  801f37:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f3a:	6a 00                	push   $0x0
  801f3c:	6a 00                	push   $0x0
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 2c                	push   $0x2c
  801f46:	e8 4a fa ff ff       	call   801995 <syscall>
  801f4b:	83 c4 18             	add    $0x18,%esp
  801f4e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f51:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f55:	75 07                	jne    801f5e <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f57:	b8 01 00 00 00       	mov    $0x1,%eax
  801f5c:	eb 05                	jmp    801f63 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f5e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f63:	c9                   	leave  
  801f64:	c3                   	ret    

00801f65 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f65:	55                   	push   %ebp
  801f66:	89 e5                	mov    %esp,%ebp
  801f68:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f6b:	6a 00                	push   $0x0
  801f6d:	6a 00                	push   $0x0
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	6a 00                	push   $0x0
  801f75:	6a 2c                	push   $0x2c
  801f77:	e8 19 fa ff ff       	call   801995 <syscall>
  801f7c:	83 c4 18             	add    $0x18,%esp
  801f7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f82:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f86:	75 07                	jne    801f8f <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f88:	b8 01 00 00 00       	mov    $0x1,%eax
  801f8d:	eb 05                	jmp    801f94 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f94:	c9                   	leave  
  801f95:	c3                   	ret    

00801f96 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f96:	55                   	push   %ebp
  801f97:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f99:	6a 00                	push   $0x0
  801f9b:	6a 00                	push   $0x0
  801f9d:	6a 00                	push   $0x0
  801f9f:	6a 00                	push   $0x0
  801fa1:	ff 75 08             	pushl  0x8(%ebp)
  801fa4:	6a 2d                	push   $0x2d
  801fa6:	e8 ea f9 ff ff       	call   801995 <syscall>
  801fab:	83 c4 18             	add    $0x18,%esp
	return ;
  801fae:	90                   	nop
}
  801faf:	c9                   	leave  
  801fb0:	c3                   	ret    

00801fb1 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fb1:	55                   	push   %ebp
  801fb2:	89 e5                	mov    %esp,%ebp
  801fb4:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fb5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fb8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801fc1:	6a 00                	push   $0x0
  801fc3:	53                   	push   %ebx
  801fc4:	51                   	push   %ecx
  801fc5:	52                   	push   %edx
  801fc6:	50                   	push   %eax
  801fc7:	6a 2e                	push   $0x2e
  801fc9:	e8 c7 f9 ff ff       	call   801995 <syscall>
  801fce:	83 c4 18             	add    $0x18,%esp
}
  801fd1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fd4:	c9                   	leave  
  801fd5:	c3                   	ret    

00801fd6 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fd6:	55                   	push   %ebp
  801fd7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fd9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fdc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fdf:	6a 00                	push   $0x0
  801fe1:	6a 00                	push   $0x0
  801fe3:	6a 00                	push   $0x0
  801fe5:	52                   	push   %edx
  801fe6:	50                   	push   %eax
  801fe7:	6a 2f                	push   $0x2f
  801fe9:	e8 a7 f9 ff ff       	call   801995 <syscall>
  801fee:	83 c4 18             	add    $0x18,%esp
}
  801ff1:	c9                   	leave  
  801ff2:	c3                   	ret    

00801ff3 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801ff3:	55                   	push   %ebp
  801ff4:	89 e5                	mov    %esp,%ebp
  801ff6:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801ff9:	83 ec 0c             	sub    $0xc,%esp
  801ffc:	68 80 3b 80 00       	push   $0x803b80
  802001:	e8 3e e6 ff ff       	call   800644 <cprintf>
  802006:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802009:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802010:	83 ec 0c             	sub    $0xc,%esp
  802013:	68 ac 3b 80 00       	push   $0x803bac
  802018:	e8 27 e6 ff ff       	call   800644 <cprintf>
  80201d:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802020:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802024:	a1 38 41 80 00       	mov    0x804138,%eax
  802029:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80202c:	eb 56                	jmp    802084 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80202e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802032:	74 1c                	je     802050 <print_mem_block_lists+0x5d>
  802034:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802037:	8b 50 08             	mov    0x8(%eax),%edx
  80203a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80203d:	8b 48 08             	mov    0x8(%eax),%ecx
  802040:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802043:	8b 40 0c             	mov    0xc(%eax),%eax
  802046:	01 c8                	add    %ecx,%eax
  802048:	39 c2                	cmp    %eax,%edx
  80204a:	73 04                	jae    802050 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80204c:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	8b 50 08             	mov    0x8(%eax),%edx
  802056:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802059:	8b 40 0c             	mov    0xc(%eax),%eax
  80205c:	01 c2                	add    %eax,%edx
  80205e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802061:	8b 40 08             	mov    0x8(%eax),%eax
  802064:	83 ec 04             	sub    $0x4,%esp
  802067:	52                   	push   %edx
  802068:	50                   	push   %eax
  802069:	68 c1 3b 80 00       	push   $0x803bc1
  80206e:	e8 d1 e5 ff ff       	call   800644 <cprintf>
  802073:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802076:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802079:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80207c:	a1 40 41 80 00       	mov    0x804140,%eax
  802081:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802084:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802088:	74 07                	je     802091 <print_mem_block_lists+0x9e>
  80208a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80208d:	8b 00                	mov    (%eax),%eax
  80208f:	eb 05                	jmp    802096 <print_mem_block_lists+0xa3>
  802091:	b8 00 00 00 00       	mov    $0x0,%eax
  802096:	a3 40 41 80 00       	mov    %eax,0x804140
  80209b:	a1 40 41 80 00       	mov    0x804140,%eax
  8020a0:	85 c0                	test   %eax,%eax
  8020a2:	75 8a                	jne    80202e <print_mem_block_lists+0x3b>
  8020a4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020a8:	75 84                	jne    80202e <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8020aa:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020ae:	75 10                	jne    8020c0 <print_mem_block_lists+0xcd>
  8020b0:	83 ec 0c             	sub    $0xc,%esp
  8020b3:	68 d0 3b 80 00       	push   $0x803bd0
  8020b8:	e8 87 e5 ff ff       	call   800644 <cprintf>
  8020bd:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8020c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020c7:	83 ec 0c             	sub    $0xc,%esp
  8020ca:	68 f4 3b 80 00       	push   $0x803bf4
  8020cf:	e8 70 e5 ff ff       	call   800644 <cprintf>
  8020d4:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020d7:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020db:	a1 40 40 80 00       	mov    0x804040,%eax
  8020e0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e3:	eb 56                	jmp    80213b <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020e9:	74 1c                	je     802107 <print_mem_block_lists+0x114>
  8020eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ee:	8b 50 08             	mov    0x8(%eax),%edx
  8020f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020f4:	8b 48 08             	mov    0x8(%eax),%ecx
  8020f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020fa:	8b 40 0c             	mov    0xc(%eax),%eax
  8020fd:	01 c8                	add    %ecx,%eax
  8020ff:	39 c2                	cmp    %eax,%edx
  802101:	73 04                	jae    802107 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802103:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210a:	8b 50 08             	mov    0x8(%eax),%edx
  80210d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802110:	8b 40 0c             	mov    0xc(%eax),%eax
  802113:	01 c2                	add    %eax,%edx
  802115:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802118:	8b 40 08             	mov    0x8(%eax),%eax
  80211b:	83 ec 04             	sub    $0x4,%esp
  80211e:	52                   	push   %edx
  80211f:	50                   	push   %eax
  802120:	68 c1 3b 80 00       	push   $0x803bc1
  802125:	e8 1a e5 ff ff       	call   800644 <cprintf>
  80212a:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80212d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802130:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802133:	a1 48 40 80 00       	mov    0x804048,%eax
  802138:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80213b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80213f:	74 07                	je     802148 <print_mem_block_lists+0x155>
  802141:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802144:	8b 00                	mov    (%eax),%eax
  802146:	eb 05                	jmp    80214d <print_mem_block_lists+0x15a>
  802148:	b8 00 00 00 00       	mov    $0x0,%eax
  80214d:	a3 48 40 80 00       	mov    %eax,0x804048
  802152:	a1 48 40 80 00       	mov    0x804048,%eax
  802157:	85 c0                	test   %eax,%eax
  802159:	75 8a                	jne    8020e5 <print_mem_block_lists+0xf2>
  80215b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80215f:	75 84                	jne    8020e5 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802161:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802165:	75 10                	jne    802177 <print_mem_block_lists+0x184>
  802167:	83 ec 0c             	sub    $0xc,%esp
  80216a:	68 0c 3c 80 00       	push   $0x803c0c
  80216f:	e8 d0 e4 ff ff       	call   800644 <cprintf>
  802174:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802177:	83 ec 0c             	sub    $0xc,%esp
  80217a:	68 80 3b 80 00       	push   $0x803b80
  80217f:	e8 c0 e4 ff ff       	call   800644 <cprintf>
  802184:	83 c4 10             	add    $0x10,%esp

}
  802187:	90                   	nop
  802188:	c9                   	leave  
  802189:	c3                   	ret    

0080218a <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80218a:	55                   	push   %ebp
  80218b:	89 e5                	mov    %esp,%ebp
  80218d:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802190:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802197:	00 00 00 
  80219a:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8021a1:	00 00 00 
  8021a4:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8021ab:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8021ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021b5:	e9 9e 00 00 00       	jmp    802258 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8021ba:	a1 50 40 80 00       	mov    0x804050,%eax
  8021bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c2:	c1 e2 04             	shl    $0x4,%edx
  8021c5:	01 d0                	add    %edx,%eax
  8021c7:	85 c0                	test   %eax,%eax
  8021c9:	75 14                	jne    8021df <initialize_MemBlocksList+0x55>
  8021cb:	83 ec 04             	sub    $0x4,%esp
  8021ce:	68 34 3c 80 00       	push   $0x803c34
  8021d3:	6a 3d                	push   $0x3d
  8021d5:	68 57 3c 80 00       	push   $0x803c57
  8021da:	e8 b1 e1 ff ff       	call   800390 <_panic>
  8021df:	a1 50 40 80 00       	mov    0x804050,%eax
  8021e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e7:	c1 e2 04             	shl    $0x4,%edx
  8021ea:	01 d0                	add    %edx,%eax
  8021ec:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8021f2:	89 10                	mov    %edx,(%eax)
  8021f4:	8b 00                	mov    (%eax),%eax
  8021f6:	85 c0                	test   %eax,%eax
  8021f8:	74 18                	je     802212 <initialize_MemBlocksList+0x88>
  8021fa:	a1 48 41 80 00       	mov    0x804148,%eax
  8021ff:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802205:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802208:	c1 e1 04             	shl    $0x4,%ecx
  80220b:	01 ca                	add    %ecx,%edx
  80220d:	89 50 04             	mov    %edx,0x4(%eax)
  802210:	eb 12                	jmp    802224 <initialize_MemBlocksList+0x9a>
  802212:	a1 50 40 80 00       	mov    0x804050,%eax
  802217:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80221a:	c1 e2 04             	shl    $0x4,%edx
  80221d:	01 d0                	add    %edx,%eax
  80221f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802224:	a1 50 40 80 00       	mov    0x804050,%eax
  802229:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80222c:	c1 e2 04             	shl    $0x4,%edx
  80222f:	01 d0                	add    %edx,%eax
  802231:	a3 48 41 80 00       	mov    %eax,0x804148
  802236:	a1 50 40 80 00       	mov    0x804050,%eax
  80223b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80223e:	c1 e2 04             	shl    $0x4,%edx
  802241:	01 d0                	add    %edx,%eax
  802243:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80224a:	a1 54 41 80 00       	mov    0x804154,%eax
  80224f:	40                   	inc    %eax
  802250:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802255:	ff 45 f4             	incl   -0xc(%ebp)
  802258:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80225e:	0f 82 56 ff ff ff    	jb     8021ba <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802264:	90                   	nop
  802265:	c9                   	leave  
  802266:	c3                   	ret    

00802267 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
  80226a:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  80226d:	8b 45 08             	mov    0x8(%ebp),%eax
  802270:	8b 00                	mov    (%eax),%eax
  802272:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802275:	eb 18                	jmp    80228f <find_block+0x28>

		if(tmp->sva == va){
  802277:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80227a:	8b 40 08             	mov    0x8(%eax),%eax
  80227d:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802280:	75 05                	jne    802287 <find_block+0x20>
			return tmp ;
  802282:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802285:	eb 11                	jmp    802298 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802287:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80228a:	8b 00                	mov    (%eax),%eax
  80228c:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  80228f:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802293:	75 e2                	jne    802277 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802295:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802298:	c9                   	leave  
  802299:	c3                   	ret    

0080229a <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80229a:	55                   	push   %ebp
  80229b:	89 e5                	mov    %esp,%ebp
  80229d:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8022a0:	a1 40 40 80 00       	mov    0x804040,%eax
  8022a5:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8022a8:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8022b0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022b4:	75 65                	jne    80231b <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8022b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022ba:	75 14                	jne    8022d0 <insert_sorted_allocList+0x36>
  8022bc:	83 ec 04             	sub    $0x4,%esp
  8022bf:	68 34 3c 80 00       	push   $0x803c34
  8022c4:	6a 62                	push   $0x62
  8022c6:	68 57 3c 80 00       	push   $0x803c57
  8022cb:	e8 c0 e0 ff ff       	call   800390 <_panic>
  8022d0:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d9:	89 10                	mov    %edx,(%eax)
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	8b 00                	mov    (%eax),%eax
  8022e0:	85 c0                	test   %eax,%eax
  8022e2:	74 0d                	je     8022f1 <insert_sorted_allocList+0x57>
  8022e4:	a1 40 40 80 00       	mov    0x804040,%eax
  8022e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8022ec:	89 50 04             	mov    %edx,0x4(%eax)
  8022ef:	eb 08                	jmp    8022f9 <insert_sorted_allocList+0x5f>
  8022f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f4:	a3 44 40 80 00       	mov    %eax,0x804044
  8022f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fc:	a3 40 40 80 00       	mov    %eax,0x804040
  802301:	8b 45 08             	mov    0x8(%ebp),%eax
  802304:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80230b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802310:	40                   	inc    %eax
  802311:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802316:	e9 14 01 00 00       	jmp    80242f <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  80231b:	8b 45 08             	mov    0x8(%ebp),%eax
  80231e:	8b 50 08             	mov    0x8(%eax),%edx
  802321:	a1 44 40 80 00       	mov    0x804044,%eax
  802326:	8b 40 08             	mov    0x8(%eax),%eax
  802329:	39 c2                	cmp    %eax,%edx
  80232b:	76 65                	jbe    802392 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80232d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802331:	75 14                	jne    802347 <insert_sorted_allocList+0xad>
  802333:	83 ec 04             	sub    $0x4,%esp
  802336:	68 70 3c 80 00       	push   $0x803c70
  80233b:	6a 64                	push   $0x64
  80233d:	68 57 3c 80 00       	push   $0x803c57
  802342:	e8 49 e0 ff ff       	call   800390 <_panic>
  802347:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80234d:	8b 45 08             	mov    0x8(%ebp),%eax
  802350:	89 50 04             	mov    %edx,0x4(%eax)
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	8b 40 04             	mov    0x4(%eax),%eax
  802359:	85 c0                	test   %eax,%eax
  80235b:	74 0c                	je     802369 <insert_sorted_allocList+0xcf>
  80235d:	a1 44 40 80 00       	mov    0x804044,%eax
  802362:	8b 55 08             	mov    0x8(%ebp),%edx
  802365:	89 10                	mov    %edx,(%eax)
  802367:	eb 08                	jmp    802371 <insert_sorted_allocList+0xd7>
  802369:	8b 45 08             	mov    0x8(%ebp),%eax
  80236c:	a3 40 40 80 00       	mov    %eax,0x804040
  802371:	8b 45 08             	mov    0x8(%ebp),%eax
  802374:	a3 44 40 80 00       	mov    %eax,0x804044
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802382:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802387:	40                   	inc    %eax
  802388:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80238d:	e9 9d 00 00 00       	jmp    80242f <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802392:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802399:	e9 85 00 00 00       	jmp    802423 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	8b 50 08             	mov    0x8(%eax),%edx
  8023a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a7:	8b 40 08             	mov    0x8(%eax),%eax
  8023aa:	39 c2                	cmp    %eax,%edx
  8023ac:	73 6a                	jae    802418 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8023ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023b2:	74 06                	je     8023ba <insert_sorted_allocList+0x120>
  8023b4:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023b8:	75 14                	jne    8023ce <insert_sorted_allocList+0x134>
  8023ba:	83 ec 04             	sub    $0x4,%esp
  8023bd:	68 94 3c 80 00       	push   $0x803c94
  8023c2:	6a 6b                	push   $0x6b
  8023c4:	68 57 3c 80 00       	push   $0x803c57
  8023c9:	e8 c2 df ff ff       	call   800390 <_panic>
  8023ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d1:	8b 50 04             	mov    0x4(%eax),%edx
  8023d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d7:	89 50 04             	mov    %edx,0x4(%eax)
  8023da:	8b 45 08             	mov    0x8(%ebp),%eax
  8023dd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023e0:	89 10                	mov    %edx,(%eax)
  8023e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e5:	8b 40 04             	mov    0x4(%eax),%eax
  8023e8:	85 c0                	test   %eax,%eax
  8023ea:	74 0d                	je     8023f9 <insert_sorted_allocList+0x15f>
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	8b 40 04             	mov    0x4(%eax),%eax
  8023f2:	8b 55 08             	mov    0x8(%ebp),%edx
  8023f5:	89 10                	mov    %edx,(%eax)
  8023f7:	eb 08                	jmp    802401 <insert_sorted_allocList+0x167>
  8023f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8023fc:	a3 40 40 80 00       	mov    %eax,0x804040
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	8b 55 08             	mov    0x8(%ebp),%edx
  802407:	89 50 04             	mov    %edx,0x4(%eax)
  80240a:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80240f:	40                   	inc    %eax
  802410:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  802415:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802416:	eb 17                	jmp    80242f <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	8b 00                	mov    (%eax),%eax
  80241d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802420:	ff 45 f0             	incl   -0x10(%ebp)
  802423:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802426:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802429:	0f 8c 6f ff ff ff    	jl     80239e <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80242f:	90                   	nop
  802430:	c9                   	leave  
  802431:	c3                   	ret    

00802432 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802432:	55                   	push   %ebp
  802433:	89 e5                	mov    %esp,%ebp
  802435:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802438:	a1 38 41 80 00       	mov    0x804138,%eax
  80243d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802440:	e9 7c 01 00 00       	jmp    8025c1 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	8b 40 0c             	mov    0xc(%eax),%eax
  80244b:	3b 45 08             	cmp    0x8(%ebp),%eax
  80244e:	0f 86 cf 00 00 00    	jbe    802523 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802454:	a1 48 41 80 00       	mov    0x804148,%eax
  802459:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  80245c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245f:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802462:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802465:	8b 55 08             	mov    0x8(%ebp),%edx
  802468:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 50 08             	mov    0x8(%eax),%edx
  802471:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802474:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802477:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247a:	8b 40 0c             	mov    0xc(%eax),%eax
  80247d:	2b 45 08             	sub    0x8(%ebp),%eax
  802480:	89 c2                	mov    %eax,%edx
  802482:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802485:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802488:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80248b:	8b 50 08             	mov    0x8(%eax),%edx
  80248e:	8b 45 08             	mov    0x8(%ebp),%eax
  802491:	01 c2                	add    %eax,%edx
  802493:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802496:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802499:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80249d:	75 17                	jne    8024b6 <alloc_block_FF+0x84>
  80249f:	83 ec 04             	sub    $0x4,%esp
  8024a2:	68 c9 3c 80 00       	push   $0x803cc9
  8024a7:	68 83 00 00 00       	push   $0x83
  8024ac:	68 57 3c 80 00       	push   $0x803c57
  8024b1:	e8 da de ff ff       	call   800390 <_panic>
  8024b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b9:	8b 00                	mov    (%eax),%eax
  8024bb:	85 c0                	test   %eax,%eax
  8024bd:	74 10                	je     8024cf <alloc_block_FF+0x9d>
  8024bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c2:	8b 00                	mov    (%eax),%eax
  8024c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024c7:	8b 52 04             	mov    0x4(%edx),%edx
  8024ca:	89 50 04             	mov    %edx,0x4(%eax)
  8024cd:	eb 0b                	jmp    8024da <alloc_block_FF+0xa8>
  8024cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d2:	8b 40 04             	mov    0x4(%eax),%eax
  8024d5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024dd:	8b 40 04             	mov    0x4(%eax),%eax
  8024e0:	85 c0                	test   %eax,%eax
  8024e2:	74 0f                	je     8024f3 <alloc_block_FF+0xc1>
  8024e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ea:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024ed:	8b 12                	mov    (%edx),%edx
  8024ef:	89 10                	mov    %edx,(%eax)
  8024f1:	eb 0a                	jmp    8024fd <alloc_block_FF+0xcb>
  8024f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f6:	8b 00                	mov    (%eax),%eax
  8024f8:	a3 48 41 80 00       	mov    %eax,0x804148
  8024fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802500:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802506:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802509:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802510:	a1 54 41 80 00       	mov    0x804154,%eax
  802515:	48                   	dec    %eax
  802516:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  80251b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80251e:	e9 ad 00 00 00       	jmp    8025d0 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802523:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802526:	8b 40 0c             	mov    0xc(%eax),%eax
  802529:	3b 45 08             	cmp    0x8(%ebp),%eax
  80252c:	0f 85 87 00 00 00    	jne    8025b9 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802532:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802536:	75 17                	jne    80254f <alloc_block_FF+0x11d>
  802538:	83 ec 04             	sub    $0x4,%esp
  80253b:	68 c9 3c 80 00       	push   $0x803cc9
  802540:	68 87 00 00 00       	push   $0x87
  802545:	68 57 3c 80 00       	push   $0x803c57
  80254a:	e8 41 de ff ff       	call   800390 <_panic>
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 00                	mov    (%eax),%eax
  802554:	85 c0                	test   %eax,%eax
  802556:	74 10                	je     802568 <alloc_block_FF+0x136>
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	8b 00                	mov    (%eax),%eax
  80255d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802560:	8b 52 04             	mov    0x4(%edx),%edx
  802563:	89 50 04             	mov    %edx,0x4(%eax)
  802566:	eb 0b                	jmp    802573 <alloc_block_FF+0x141>
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	8b 40 04             	mov    0x4(%eax),%eax
  80256e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802573:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802576:	8b 40 04             	mov    0x4(%eax),%eax
  802579:	85 c0                	test   %eax,%eax
  80257b:	74 0f                	je     80258c <alloc_block_FF+0x15a>
  80257d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802580:	8b 40 04             	mov    0x4(%eax),%eax
  802583:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802586:	8b 12                	mov    (%edx),%edx
  802588:	89 10                	mov    %edx,(%eax)
  80258a:	eb 0a                	jmp    802596 <alloc_block_FF+0x164>
  80258c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258f:	8b 00                	mov    (%eax),%eax
  802591:	a3 38 41 80 00       	mov    %eax,0x804138
  802596:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802599:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80259f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025a9:	a1 44 41 80 00       	mov    0x804144,%eax
  8025ae:	48                   	dec    %eax
  8025af:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8025b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b7:	eb 17                	jmp    8025d0 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8025b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025bc:	8b 00                	mov    (%eax),%eax
  8025be:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8025c1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025c5:	0f 85 7a fe ff ff    	jne    802445 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8025cb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025d0:	c9                   	leave  
  8025d1:	c3                   	ret    

008025d2 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025d2:	55                   	push   %ebp
  8025d3:	89 e5                	mov    %esp,%ebp
  8025d5:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8025d8:	a1 38 41 80 00       	mov    0x804138,%eax
  8025dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8025e0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8025e7:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8025ee:	a1 38 41 80 00       	mov    0x804138,%eax
  8025f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025f6:	e9 d0 00 00 00       	jmp    8026cb <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8025fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fe:	8b 40 0c             	mov    0xc(%eax),%eax
  802601:	3b 45 08             	cmp    0x8(%ebp),%eax
  802604:	0f 82 b8 00 00 00    	jb     8026c2 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  80260a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260d:	8b 40 0c             	mov    0xc(%eax),%eax
  802610:	2b 45 08             	sub    0x8(%ebp),%eax
  802613:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802619:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80261c:	0f 83 a1 00 00 00    	jae    8026c3 <alloc_block_BF+0xf1>
				differsize = differance ;
  802622:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802625:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80262e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802632:	0f 85 8b 00 00 00    	jne    8026c3 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802638:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80263c:	75 17                	jne    802655 <alloc_block_BF+0x83>
  80263e:	83 ec 04             	sub    $0x4,%esp
  802641:	68 c9 3c 80 00       	push   $0x803cc9
  802646:	68 a0 00 00 00       	push   $0xa0
  80264b:	68 57 3c 80 00       	push   $0x803c57
  802650:	e8 3b dd ff ff       	call   800390 <_panic>
  802655:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802658:	8b 00                	mov    (%eax),%eax
  80265a:	85 c0                	test   %eax,%eax
  80265c:	74 10                	je     80266e <alloc_block_BF+0x9c>
  80265e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802661:	8b 00                	mov    (%eax),%eax
  802663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802666:	8b 52 04             	mov    0x4(%edx),%edx
  802669:	89 50 04             	mov    %edx,0x4(%eax)
  80266c:	eb 0b                	jmp    802679 <alloc_block_BF+0xa7>
  80266e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802671:	8b 40 04             	mov    0x4(%eax),%eax
  802674:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267c:	8b 40 04             	mov    0x4(%eax),%eax
  80267f:	85 c0                	test   %eax,%eax
  802681:	74 0f                	je     802692 <alloc_block_BF+0xc0>
  802683:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802686:	8b 40 04             	mov    0x4(%eax),%eax
  802689:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80268c:	8b 12                	mov    (%edx),%edx
  80268e:	89 10                	mov    %edx,(%eax)
  802690:	eb 0a                	jmp    80269c <alloc_block_BF+0xca>
  802692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802695:	8b 00                	mov    (%eax),%eax
  802697:	a3 38 41 80 00       	mov    %eax,0x804138
  80269c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80269f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026af:	a1 44 41 80 00       	mov    0x804144,%eax
  8026b4:	48                   	dec    %eax
  8026b5:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8026ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026bd:	e9 0c 01 00 00       	jmp    8027ce <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8026c2:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8026c3:	a1 40 41 80 00       	mov    0x804140,%eax
  8026c8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026cb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cf:	74 07                	je     8026d8 <alloc_block_BF+0x106>
  8026d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026d4:	8b 00                	mov    (%eax),%eax
  8026d6:	eb 05                	jmp    8026dd <alloc_block_BF+0x10b>
  8026d8:	b8 00 00 00 00       	mov    $0x0,%eax
  8026dd:	a3 40 41 80 00       	mov    %eax,0x804140
  8026e2:	a1 40 41 80 00       	mov    0x804140,%eax
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	0f 85 0c ff ff ff    	jne    8025fb <alloc_block_BF+0x29>
  8026ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026f3:	0f 85 02 ff ff ff    	jne    8025fb <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  8026f9:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026fd:	0f 84 c6 00 00 00    	je     8027c9 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802703:	a1 48 41 80 00       	mov    0x804148,%eax
  802708:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  80270b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80270e:	8b 55 08             	mov    0x8(%ebp),%edx
  802711:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802714:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802717:	8b 50 08             	mov    0x8(%eax),%edx
  80271a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271d:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802723:	8b 40 0c             	mov    0xc(%eax),%eax
  802726:	2b 45 08             	sub    0x8(%ebp),%eax
  802729:	89 c2                	mov    %eax,%edx
  80272b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80272e:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802731:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802734:	8b 50 08             	mov    0x8(%eax),%edx
  802737:	8b 45 08             	mov    0x8(%ebp),%eax
  80273a:	01 c2                	add    %eax,%edx
  80273c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273f:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802742:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802746:	75 17                	jne    80275f <alloc_block_BF+0x18d>
  802748:	83 ec 04             	sub    $0x4,%esp
  80274b:	68 c9 3c 80 00       	push   $0x803cc9
  802750:	68 af 00 00 00       	push   $0xaf
  802755:	68 57 3c 80 00       	push   $0x803c57
  80275a:	e8 31 dc ff ff       	call   800390 <_panic>
  80275f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802762:	8b 00                	mov    (%eax),%eax
  802764:	85 c0                	test   %eax,%eax
  802766:	74 10                	je     802778 <alloc_block_BF+0x1a6>
  802768:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276b:	8b 00                	mov    (%eax),%eax
  80276d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802770:	8b 52 04             	mov    0x4(%edx),%edx
  802773:	89 50 04             	mov    %edx,0x4(%eax)
  802776:	eb 0b                	jmp    802783 <alloc_block_BF+0x1b1>
  802778:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80277b:	8b 40 04             	mov    0x4(%eax),%eax
  80277e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802783:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802786:	8b 40 04             	mov    0x4(%eax),%eax
  802789:	85 c0                	test   %eax,%eax
  80278b:	74 0f                	je     80279c <alloc_block_BF+0x1ca>
  80278d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802790:	8b 40 04             	mov    0x4(%eax),%eax
  802793:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802796:	8b 12                	mov    (%edx),%edx
  802798:	89 10                	mov    %edx,(%eax)
  80279a:	eb 0a                	jmp    8027a6 <alloc_block_BF+0x1d4>
  80279c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80279f:	8b 00                	mov    (%eax),%eax
  8027a1:	a3 48 41 80 00       	mov    %eax,0x804148
  8027a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027b9:	a1 54 41 80 00       	mov    0x804154,%eax
  8027be:	48                   	dec    %eax
  8027bf:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8027c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027c7:	eb 05                	jmp    8027ce <alloc_block_BF+0x1fc>
	}

	return NULL;
  8027c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ce:	c9                   	leave  
  8027cf:	c3                   	ret    

008027d0 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8027d0:	55                   	push   %ebp
  8027d1:	89 e5                	mov    %esp,%ebp
  8027d3:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8027d6:	a1 38 41 80 00       	mov    0x804138,%eax
  8027db:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8027de:	e9 7c 01 00 00       	jmp    80295f <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027ec:	0f 86 cf 00 00 00    	jbe    8028c1 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8027f2:	a1 48 41 80 00       	mov    0x804148,%eax
  8027f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8027fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802800:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802803:	8b 55 08             	mov    0x8(%ebp),%edx
  802806:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802809:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280c:	8b 50 08             	mov    0x8(%eax),%edx
  80280f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802812:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802815:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802818:	8b 40 0c             	mov    0xc(%eax),%eax
  80281b:	2b 45 08             	sub    0x8(%ebp),%eax
  80281e:	89 c2                	mov    %eax,%edx
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802826:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802829:	8b 50 08             	mov    0x8(%eax),%edx
  80282c:	8b 45 08             	mov    0x8(%ebp),%eax
  80282f:	01 c2                	add    %eax,%edx
  802831:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802834:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802837:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80283b:	75 17                	jne    802854 <alloc_block_NF+0x84>
  80283d:	83 ec 04             	sub    $0x4,%esp
  802840:	68 c9 3c 80 00       	push   $0x803cc9
  802845:	68 c4 00 00 00       	push   $0xc4
  80284a:	68 57 3c 80 00       	push   $0x803c57
  80284f:	e8 3c db ff ff       	call   800390 <_panic>
  802854:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802857:	8b 00                	mov    (%eax),%eax
  802859:	85 c0                	test   %eax,%eax
  80285b:	74 10                	je     80286d <alloc_block_NF+0x9d>
  80285d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802860:	8b 00                	mov    (%eax),%eax
  802862:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802865:	8b 52 04             	mov    0x4(%edx),%edx
  802868:	89 50 04             	mov    %edx,0x4(%eax)
  80286b:	eb 0b                	jmp    802878 <alloc_block_NF+0xa8>
  80286d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802870:	8b 40 04             	mov    0x4(%eax),%eax
  802873:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802878:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287b:	8b 40 04             	mov    0x4(%eax),%eax
  80287e:	85 c0                	test   %eax,%eax
  802880:	74 0f                	je     802891 <alloc_block_NF+0xc1>
  802882:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802885:	8b 40 04             	mov    0x4(%eax),%eax
  802888:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80288b:	8b 12                	mov    (%edx),%edx
  80288d:	89 10                	mov    %edx,(%eax)
  80288f:	eb 0a                	jmp    80289b <alloc_block_NF+0xcb>
  802891:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802894:	8b 00                	mov    (%eax),%eax
  802896:	a3 48 41 80 00       	mov    %eax,0x804148
  80289b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80289e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ae:	a1 54 41 80 00       	mov    0x804154,%eax
  8028b3:	48                   	dec    %eax
  8028b4:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8028b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028bc:	e9 ad 00 00 00       	jmp    80296e <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8028c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028c7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ca:	0f 85 87 00 00 00    	jne    802957 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8028d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028d4:	75 17                	jne    8028ed <alloc_block_NF+0x11d>
  8028d6:	83 ec 04             	sub    $0x4,%esp
  8028d9:	68 c9 3c 80 00       	push   $0x803cc9
  8028de:	68 c8 00 00 00       	push   $0xc8
  8028e3:	68 57 3c 80 00       	push   $0x803c57
  8028e8:	e8 a3 da ff ff       	call   800390 <_panic>
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 00                	mov    (%eax),%eax
  8028f2:	85 c0                	test   %eax,%eax
  8028f4:	74 10                	je     802906 <alloc_block_NF+0x136>
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	8b 00                	mov    (%eax),%eax
  8028fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fe:	8b 52 04             	mov    0x4(%edx),%edx
  802901:	89 50 04             	mov    %edx,0x4(%eax)
  802904:	eb 0b                	jmp    802911 <alloc_block_NF+0x141>
  802906:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802909:	8b 40 04             	mov    0x4(%eax),%eax
  80290c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802911:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802914:	8b 40 04             	mov    0x4(%eax),%eax
  802917:	85 c0                	test   %eax,%eax
  802919:	74 0f                	je     80292a <alloc_block_NF+0x15a>
  80291b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291e:	8b 40 04             	mov    0x4(%eax),%eax
  802921:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802924:	8b 12                	mov    (%edx),%edx
  802926:	89 10                	mov    %edx,(%eax)
  802928:	eb 0a                	jmp    802934 <alloc_block_NF+0x164>
  80292a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292d:	8b 00                	mov    (%eax),%eax
  80292f:	a3 38 41 80 00       	mov    %eax,0x804138
  802934:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802937:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80293d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802940:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802947:	a1 44 41 80 00       	mov    0x804144,%eax
  80294c:	48                   	dec    %eax
  80294d:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802952:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802955:	eb 17                	jmp    80296e <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802957:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295a:	8b 00                	mov    (%eax),%eax
  80295c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  80295f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802963:	0f 85 7a fe ff ff    	jne    8027e3 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802969:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80296e:	c9                   	leave  
  80296f:	c3                   	ret    

00802970 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802970:	55                   	push   %ebp
  802971:	89 e5                	mov    %esp,%ebp
  802973:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802976:	a1 38 41 80 00       	mov    0x804138,%eax
  80297b:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  80297e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802983:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802986:	a1 44 41 80 00       	mov    0x804144,%eax
  80298b:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  80298e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802992:	75 68                	jne    8029fc <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802994:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802998:	75 17                	jne    8029b1 <insert_sorted_with_merge_freeList+0x41>
  80299a:	83 ec 04             	sub    $0x4,%esp
  80299d:	68 34 3c 80 00       	push   $0x803c34
  8029a2:	68 da 00 00 00       	push   $0xda
  8029a7:	68 57 3c 80 00       	push   $0x803c57
  8029ac:	e8 df d9 ff ff       	call   800390 <_panic>
  8029b1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ba:	89 10                	mov    %edx,(%eax)
  8029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bf:	8b 00                	mov    (%eax),%eax
  8029c1:	85 c0                	test   %eax,%eax
  8029c3:	74 0d                	je     8029d2 <insert_sorted_with_merge_freeList+0x62>
  8029c5:	a1 38 41 80 00       	mov    0x804138,%eax
  8029ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cd:	89 50 04             	mov    %edx,0x4(%eax)
  8029d0:	eb 08                	jmp    8029da <insert_sorted_with_merge_freeList+0x6a>
  8029d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029da:	8b 45 08             	mov    0x8(%ebp),%eax
  8029dd:	a3 38 41 80 00       	mov    %eax,0x804138
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029ec:	a1 44 41 80 00       	mov    0x804144,%eax
  8029f1:	40                   	inc    %eax
  8029f2:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  8029f7:	e9 49 07 00 00       	jmp    803145 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  8029fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ff:	8b 50 08             	mov    0x8(%eax),%edx
  802a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a05:	8b 40 0c             	mov    0xc(%eax),%eax
  802a08:	01 c2                	add    %eax,%edx
  802a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0d:	8b 40 08             	mov    0x8(%eax),%eax
  802a10:	39 c2                	cmp    %eax,%edx
  802a12:	73 77                	jae    802a8b <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802a14:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a17:	8b 00                	mov    (%eax),%eax
  802a19:	85 c0                	test   %eax,%eax
  802a1b:	75 6e                	jne    802a8b <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802a1d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a21:	74 68                	je     802a8b <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802a23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a27:	75 17                	jne    802a40 <insert_sorted_with_merge_freeList+0xd0>
  802a29:	83 ec 04             	sub    $0x4,%esp
  802a2c:	68 70 3c 80 00       	push   $0x803c70
  802a31:	68 e0 00 00 00       	push   $0xe0
  802a36:	68 57 3c 80 00       	push   $0x803c57
  802a3b:	e8 50 d9 ff ff       	call   800390 <_panic>
  802a40:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a46:	8b 45 08             	mov    0x8(%ebp),%eax
  802a49:	89 50 04             	mov    %edx,0x4(%eax)
  802a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4f:	8b 40 04             	mov    0x4(%eax),%eax
  802a52:	85 c0                	test   %eax,%eax
  802a54:	74 0c                	je     802a62 <insert_sorted_with_merge_freeList+0xf2>
  802a56:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a5b:	8b 55 08             	mov    0x8(%ebp),%edx
  802a5e:	89 10                	mov    %edx,(%eax)
  802a60:	eb 08                	jmp    802a6a <insert_sorted_with_merge_freeList+0xfa>
  802a62:	8b 45 08             	mov    0x8(%ebp),%eax
  802a65:	a3 38 41 80 00       	mov    %eax,0x804138
  802a6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a72:	8b 45 08             	mov    0x8(%ebp),%eax
  802a75:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a7b:	a1 44 41 80 00       	mov    0x804144,%eax
  802a80:	40                   	inc    %eax
  802a81:	a3 44 41 80 00       	mov    %eax,0x804144
  802a86:	e9 ba 06 00 00       	jmp    803145 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802a8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8e:	8b 50 0c             	mov    0xc(%eax),%edx
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	8b 40 08             	mov    0x8(%eax),%eax
  802a97:	01 c2                	add    %eax,%edx
  802a99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a9c:	8b 40 08             	mov    0x8(%eax),%eax
  802a9f:	39 c2                	cmp    %eax,%edx
  802aa1:	73 78                	jae    802b1b <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802aa3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa6:	8b 40 04             	mov    0x4(%eax),%eax
  802aa9:	85 c0                	test   %eax,%eax
  802aab:	75 6e                	jne    802b1b <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802aad:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802ab1:	74 68                	je     802b1b <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802ab3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ab7:	75 17                	jne    802ad0 <insert_sorted_with_merge_freeList+0x160>
  802ab9:	83 ec 04             	sub    $0x4,%esp
  802abc:	68 34 3c 80 00       	push   $0x803c34
  802ac1:	68 e6 00 00 00       	push   $0xe6
  802ac6:	68 57 3c 80 00       	push   $0x803c57
  802acb:	e8 c0 d8 ff ff       	call   800390 <_panic>
  802ad0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad9:	89 10                	mov    %edx,(%eax)
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	8b 00                	mov    (%eax),%eax
  802ae0:	85 c0                	test   %eax,%eax
  802ae2:	74 0d                	je     802af1 <insert_sorted_with_merge_freeList+0x181>
  802ae4:	a1 38 41 80 00       	mov    0x804138,%eax
  802ae9:	8b 55 08             	mov    0x8(%ebp),%edx
  802aec:	89 50 04             	mov    %edx,0x4(%eax)
  802aef:	eb 08                	jmp    802af9 <insert_sorted_with_merge_freeList+0x189>
  802af1:	8b 45 08             	mov    0x8(%ebp),%eax
  802af4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802af9:	8b 45 08             	mov    0x8(%ebp),%eax
  802afc:	a3 38 41 80 00       	mov    %eax,0x804138
  802b01:	8b 45 08             	mov    0x8(%ebp),%eax
  802b04:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b0b:	a1 44 41 80 00       	mov    0x804144,%eax
  802b10:	40                   	inc    %eax
  802b11:	a3 44 41 80 00       	mov    %eax,0x804144
  802b16:	e9 2a 06 00 00       	jmp    803145 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802b1b:	a1 38 41 80 00       	mov    0x804138,%eax
  802b20:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b23:	e9 ed 05 00 00       	jmp    803115 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802b30:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b34:	0f 84 a7 00 00 00    	je     802be1 <insert_sorted_with_merge_freeList+0x271>
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 50 0c             	mov    0xc(%eax),%edx
  802b40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b43:	8b 40 08             	mov    0x8(%eax),%eax
  802b46:	01 c2                	add    %eax,%edx
  802b48:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4b:	8b 40 08             	mov    0x8(%eax),%eax
  802b4e:	39 c2                	cmp    %eax,%edx
  802b50:	0f 83 8b 00 00 00    	jae    802be1 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	8b 50 0c             	mov    0xc(%eax),%edx
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	8b 40 08             	mov    0x8(%eax),%eax
  802b62:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802b64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b67:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802b6a:	39 c2                	cmp    %eax,%edx
  802b6c:	73 73                	jae    802be1 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802b6e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b72:	74 06                	je     802b7a <insert_sorted_with_merge_freeList+0x20a>
  802b74:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b78:	75 17                	jne    802b91 <insert_sorted_with_merge_freeList+0x221>
  802b7a:	83 ec 04             	sub    $0x4,%esp
  802b7d:	68 e8 3c 80 00       	push   $0x803ce8
  802b82:	68 f0 00 00 00       	push   $0xf0
  802b87:	68 57 3c 80 00       	push   $0x803c57
  802b8c:	e8 ff d7 ff ff       	call   800390 <_panic>
  802b91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b94:	8b 10                	mov    (%eax),%edx
  802b96:	8b 45 08             	mov    0x8(%ebp),%eax
  802b99:	89 10                	mov    %edx,(%eax)
  802b9b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9e:	8b 00                	mov    (%eax),%eax
  802ba0:	85 c0                	test   %eax,%eax
  802ba2:	74 0b                	je     802baf <insert_sorted_with_merge_freeList+0x23f>
  802ba4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba7:	8b 00                	mov    (%eax),%eax
  802ba9:	8b 55 08             	mov    0x8(%ebp),%edx
  802bac:	89 50 04             	mov    %edx,0x4(%eax)
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb5:	89 10                	mov    %edx,(%eax)
  802bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bbd:	89 50 04             	mov    %edx,0x4(%eax)
  802bc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc3:	8b 00                	mov    (%eax),%eax
  802bc5:	85 c0                	test   %eax,%eax
  802bc7:	75 08                	jne    802bd1 <insert_sorted_with_merge_freeList+0x261>
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bd1:	a1 44 41 80 00       	mov    0x804144,%eax
  802bd6:	40                   	inc    %eax
  802bd7:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802bdc:	e9 64 05 00 00       	jmp    803145 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802be1:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802be6:	8b 50 0c             	mov    0xc(%eax),%edx
  802be9:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bee:	8b 40 08             	mov    0x8(%eax),%eax
  802bf1:	01 c2                	add    %eax,%edx
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	8b 40 08             	mov    0x8(%eax),%eax
  802bf9:	39 c2                	cmp    %eax,%edx
  802bfb:	0f 85 b1 00 00 00    	jne    802cb2 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802c01:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c06:	85 c0                	test   %eax,%eax
  802c08:	0f 84 a4 00 00 00    	je     802cb2 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802c0e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c13:	8b 00                	mov    (%eax),%eax
  802c15:	85 c0                	test   %eax,%eax
  802c17:	0f 85 95 00 00 00    	jne    802cb2 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802c1d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c22:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c28:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802c2b:	8b 55 08             	mov    0x8(%ebp),%edx
  802c2e:	8b 52 0c             	mov    0xc(%edx),%edx
  802c31:	01 ca                	add    %ecx,%edx
  802c33:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802c36:	8b 45 08             	mov    0x8(%ebp),%eax
  802c39:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802c40:	8b 45 08             	mov    0x8(%ebp),%eax
  802c43:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c4a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c4e:	75 17                	jne    802c67 <insert_sorted_with_merge_freeList+0x2f7>
  802c50:	83 ec 04             	sub    $0x4,%esp
  802c53:	68 34 3c 80 00       	push   $0x803c34
  802c58:	68 ff 00 00 00       	push   $0xff
  802c5d:	68 57 3c 80 00       	push   $0x803c57
  802c62:	e8 29 d7 ff ff       	call   800390 <_panic>
  802c67:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c70:	89 10                	mov    %edx,(%eax)
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	85 c0                	test   %eax,%eax
  802c79:	74 0d                	je     802c88 <insert_sorted_with_merge_freeList+0x318>
  802c7b:	a1 48 41 80 00       	mov    0x804148,%eax
  802c80:	8b 55 08             	mov    0x8(%ebp),%edx
  802c83:	89 50 04             	mov    %edx,0x4(%eax)
  802c86:	eb 08                	jmp    802c90 <insert_sorted_with_merge_freeList+0x320>
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c90:	8b 45 08             	mov    0x8(%ebp),%eax
  802c93:	a3 48 41 80 00       	mov    %eax,0x804148
  802c98:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ca2:	a1 54 41 80 00       	mov    0x804154,%eax
  802ca7:	40                   	inc    %eax
  802ca8:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802cad:	e9 93 04 00 00       	jmp    803145 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	8b 50 08             	mov    0x8(%eax),%edx
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbe:	01 c2                	add    %eax,%edx
  802cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc3:	8b 40 08             	mov    0x8(%eax),%eax
  802cc6:	39 c2                	cmp    %eax,%edx
  802cc8:	0f 85 ae 00 00 00    	jne    802d7c <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802cce:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd1:	8b 50 0c             	mov    0xc(%eax),%edx
  802cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd7:	8b 40 08             	mov    0x8(%eax),%eax
  802cda:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802cdc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cdf:	8b 00                	mov    (%eax),%eax
  802ce1:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802ce4:	39 c2                	cmp    %eax,%edx
  802ce6:	0f 84 90 00 00 00    	je     802d7c <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802cec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cef:	8b 50 0c             	mov    0xc(%eax),%edx
  802cf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf5:	8b 40 0c             	mov    0xc(%eax),%eax
  802cf8:	01 c2                	add    %eax,%edx
  802cfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfd:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802d00:	8b 45 08             	mov    0x8(%ebp),%eax
  802d03:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d14:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d18:	75 17                	jne    802d31 <insert_sorted_with_merge_freeList+0x3c1>
  802d1a:	83 ec 04             	sub    $0x4,%esp
  802d1d:	68 34 3c 80 00       	push   $0x803c34
  802d22:	68 0b 01 00 00       	push   $0x10b
  802d27:	68 57 3c 80 00       	push   $0x803c57
  802d2c:	e8 5f d6 ff ff       	call   800390 <_panic>
  802d31:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d37:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3a:	89 10                	mov    %edx,(%eax)
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	8b 00                	mov    (%eax),%eax
  802d41:	85 c0                	test   %eax,%eax
  802d43:	74 0d                	je     802d52 <insert_sorted_with_merge_freeList+0x3e2>
  802d45:	a1 48 41 80 00       	mov    0x804148,%eax
  802d4a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4d:	89 50 04             	mov    %edx,0x4(%eax)
  802d50:	eb 08                	jmp    802d5a <insert_sorted_with_merge_freeList+0x3ea>
  802d52:	8b 45 08             	mov    0x8(%ebp),%eax
  802d55:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d5a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5d:	a3 48 41 80 00       	mov    %eax,0x804148
  802d62:	8b 45 08             	mov    0x8(%ebp),%eax
  802d65:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d6c:	a1 54 41 80 00       	mov    0x804154,%eax
  802d71:	40                   	inc    %eax
  802d72:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d77:	e9 c9 03 00 00       	jmp    803145 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	8b 50 0c             	mov    0xc(%eax),%edx
  802d82:	8b 45 08             	mov    0x8(%ebp),%eax
  802d85:	8b 40 08             	mov    0x8(%eax),%eax
  802d88:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8d:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d90:	39 c2                	cmp    %eax,%edx
  802d92:	0f 85 bb 00 00 00    	jne    802e53 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802d98:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d9c:	0f 84 b1 00 00 00    	je     802e53 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802da2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da5:	8b 40 04             	mov    0x4(%eax),%eax
  802da8:	85 c0                	test   %eax,%eax
  802daa:	0f 85 a3 00 00 00    	jne    802e53 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802db0:	a1 38 41 80 00       	mov    0x804138,%eax
  802db5:	8b 55 08             	mov    0x8(%ebp),%edx
  802db8:	8b 52 08             	mov    0x8(%edx),%edx
  802dbb:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802dbe:	a1 38 41 80 00       	mov    0x804138,%eax
  802dc3:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802dc9:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802dcc:	8b 55 08             	mov    0x8(%ebp),%edx
  802dcf:	8b 52 0c             	mov    0xc(%edx),%edx
  802dd2:	01 ca                	add    %ecx,%edx
  802dd4:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802dd7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dda:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802deb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802def:	75 17                	jne    802e08 <insert_sorted_with_merge_freeList+0x498>
  802df1:	83 ec 04             	sub    $0x4,%esp
  802df4:	68 34 3c 80 00       	push   $0x803c34
  802df9:	68 17 01 00 00       	push   $0x117
  802dfe:	68 57 3c 80 00       	push   $0x803c57
  802e03:	e8 88 d5 ff ff       	call   800390 <_panic>
  802e08:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e11:	89 10                	mov    %edx,(%eax)
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	8b 00                	mov    (%eax),%eax
  802e18:	85 c0                	test   %eax,%eax
  802e1a:	74 0d                	je     802e29 <insert_sorted_with_merge_freeList+0x4b9>
  802e1c:	a1 48 41 80 00       	mov    0x804148,%eax
  802e21:	8b 55 08             	mov    0x8(%ebp),%edx
  802e24:	89 50 04             	mov    %edx,0x4(%eax)
  802e27:	eb 08                	jmp    802e31 <insert_sorted_with_merge_freeList+0x4c1>
  802e29:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e31:	8b 45 08             	mov    0x8(%ebp),%eax
  802e34:	a3 48 41 80 00       	mov    %eax,0x804148
  802e39:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e43:	a1 54 41 80 00       	mov    0x804154,%eax
  802e48:	40                   	inc    %eax
  802e49:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802e4e:	e9 f2 02 00 00       	jmp    803145 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802e53:	8b 45 08             	mov    0x8(%ebp),%eax
  802e56:	8b 50 08             	mov    0x8(%eax),%edx
  802e59:	8b 45 08             	mov    0x8(%ebp),%eax
  802e5c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5f:	01 c2                	add    %eax,%edx
  802e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e64:	8b 40 08             	mov    0x8(%eax),%eax
  802e67:	39 c2                	cmp    %eax,%edx
  802e69:	0f 85 be 00 00 00    	jne    802f2d <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802e6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e72:	8b 40 04             	mov    0x4(%eax),%eax
  802e75:	8b 50 08             	mov    0x8(%eax),%edx
  802e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7b:	8b 40 04             	mov    0x4(%eax),%eax
  802e7e:	8b 40 0c             	mov    0xc(%eax),%eax
  802e81:	01 c2                	add    %eax,%edx
  802e83:	8b 45 08             	mov    0x8(%ebp),%eax
  802e86:	8b 40 08             	mov    0x8(%eax),%eax
  802e89:	39 c2                	cmp    %eax,%edx
  802e8b:	0f 84 9c 00 00 00    	je     802f2d <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802e91:	8b 45 08             	mov    0x8(%ebp),%eax
  802e94:	8b 50 08             	mov    0x8(%eax),%edx
  802e97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9a:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802e9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea0:	8b 50 0c             	mov    0xc(%eax),%edx
  802ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ea9:	01 c2                	add    %eax,%edx
  802eab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eae:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802ec5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ec9:	75 17                	jne    802ee2 <insert_sorted_with_merge_freeList+0x572>
  802ecb:	83 ec 04             	sub    $0x4,%esp
  802ece:	68 34 3c 80 00       	push   $0x803c34
  802ed3:	68 26 01 00 00       	push   $0x126
  802ed8:	68 57 3c 80 00       	push   $0x803c57
  802edd:	e8 ae d4 ff ff       	call   800390 <_panic>
  802ee2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ee8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eeb:	89 10                	mov    %edx,(%eax)
  802eed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	85 c0                	test   %eax,%eax
  802ef4:	74 0d                	je     802f03 <insert_sorted_with_merge_freeList+0x593>
  802ef6:	a1 48 41 80 00       	mov    0x804148,%eax
  802efb:	8b 55 08             	mov    0x8(%ebp),%edx
  802efe:	89 50 04             	mov    %edx,0x4(%eax)
  802f01:	eb 08                	jmp    802f0b <insert_sorted_with_merge_freeList+0x59b>
  802f03:	8b 45 08             	mov    0x8(%ebp),%eax
  802f06:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f0e:	a3 48 41 80 00       	mov    %eax,0x804148
  802f13:	8b 45 08             	mov    0x8(%ebp),%eax
  802f16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f1d:	a1 54 41 80 00       	mov    0x804154,%eax
  802f22:	40                   	inc    %eax
  802f23:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802f28:	e9 18 02 00 00       	jmp    803145 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802f2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f30:	8b 50 0c             	mov    0xc(%eax),%edx
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	8b 40 08             	mov    0x8(%eax),%eax
  802f39:	01 c2                	add    %eax,%edx
  802f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f3e:	8b 40 08             	mov    0x8(%eax),%eax
  802f41:	39 c2                	cmp    %eax,%edx
  802f43:	0f 85 c4 01 00 00    	jne    80310d <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802f49:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4c:	8b 50 0c             	mov    0xc(%eax),%edx
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	8b 40 08             	mov    0x8(%eax),%eax
  802f55:	01 c2                	add    %eax,%edx
  802f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5a:	8b 00                	mov    (%eax),%eax
  802f5c:	8b 40 08             	mov    0x8(%eax),%eax
  802f5f:	39 c2                	cmp    %eax,%edx
  802f61:	0f 85 a6 01 00 00    	jne    80310d <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802f67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f6b:	0f 84 9c 01 00 00    	je     80310d <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802f71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f74:	8b 50 0c             	mov    0xc(%eax),%edx
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f7d:	01 c2                	add    %eax,%edx
  802f7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f82:	8b 00                	mov    (%eax),%eax
  802f84:	8b 40 0c             	mov    0xc(%eax),%eax
  802f87:	01 c2                	add    %eax,%edx
  802f89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8c:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802f8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f92:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802f99:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802fa3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fa7:	75 17                	jne    802fc0 <insert_sorted_with_merge_freeList+0x650>
  802fa9:	83 ec 04             	sub    $0x4,%esp
  802fac:	68 34 3c 80 00       	push   $0x803c34
  802fb1:	68 32 01 00 00       	push   $0x132
  802fb6:	68 57 3c 80 00       	push   $0x803c57
  802fbb:	e8 d0 d3 ff ff       	call   800390 <_panic>
  802fc0:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc9:	89 10                	mov    %edx,(%eax)
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	8b 00                	mov    (%eax),%eax
  802fd0:	85 c0                	test   %eax,%eax
  802fd2:	74 0d                	je     802fe1 <insert_sorted_with_merge_freeList+0x671>
  802fd4:	a1 48 41 80 00       	mov    0x804148,%eax
  802fd9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fdc:	89 50 04             	mov    %edx,0x4(%eax)
  802fdf:	eb 08                	jmp    802fe9 <insert_sorted_with_merge_freeList+0x679>
  802fe1:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  802fec:	a3 48 41 80 00       	mov    %eax,0x804148
  802ff1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ffb:	a1 54 41 80 00       	mov    0x804154,%eax
  803000:	40                   	inc    %eax
  803001:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  803006:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803009:	8b 00                	mov    (%eax),%eax
  80300b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803012:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803015:	8b 00                	mov    (%eax),%eax
  803017:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  80301e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803021:	8b 00                	mov    (%eax),%eax
  803023:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803026:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80302a:	75 17                	jne    803043 <insert_sorted_with_merge_freeList+0x6d3>
  80302c:	83 ec 04             	sub    $0x4,%esp
  80302f:	68 c9 3c 80 00       	push   $0x803cc9
  803034:	68 36 01 00 00       	push   $0x136
  803039:	68 57 3c 80 00       	push   $0x803c57
  80303e:	e8 4d d3 ff ff       	call   800390 <_panic>
  803043:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803046:	8b 00                	mov    (%eax),%eax
  803048:	85 c0                	test   %eax,%eax
  80304a:	74 10                	je     80305c <insert_sorted_with_merge_freeList+0x6ec>
  80304c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80304f:	8b 00                	mov    (%eax),%eax
  803051:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803054:	8b 52 04             	mov    0x4(%edx),%edx
  803057:	89 50 04             	mov    %edx,0x4(%eax)
  80305a:	eb 0b                	jmp    803067 <insert_sorted_with_merge_freeList+0x6f7>
  80305c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305f:	8b 40 04             	mov    0x4(%eax),%eax
  803062:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803067:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306a:	8b 40 04             	mov    0x4(%eax),%eax
  80306d:	85 c0                	test   %eax,%eax
  80306f:	74 0f                	je     803080 <insert_sorted_with_merge_freeList+0x710>
  803071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803074:	8b 40 04             	mov    0x4(%eax),%eax
  803077:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80307a:	8b 12                	mov    (%edx),%edx
  80307c:	89 10                	mov    %edx,(%eax)
  80307e:	eb 0a                	jmp    80308a <insert_sorted_with_merge_freeList+0x71a>
  803080:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803083:	8b 00                	mov    (%eax),%eax
  803085:	a3 38 41 80 00       	mov    %eax,0x804138
  80308a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80308d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803096:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80309d:	a1 44 41 80 00       	mov    0x804144,%eax
  8030a2:	48                   	dec    %eax
  8030a3:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8030a8:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030ac:	75 17                	jne    8030c5 <insert_sorted_with_merge_freeList+0x755>
  8030ae:	83 ec 04             	sub    $0x4,%esp
  8030b1:	68 34 3c 80 00       	push   $0x803c34
  8030b6:	68 37 01 00 00       	push   $0x137
  8030bb:	68 57 3c 80 00       	push   $0x803c57
  8030c0:	e8 cb d2 ff ff       	call   800390 <_panic>
  8030c5:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ce:	89 10                	mov    %edx,(%eax)
  8030d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d3:	8b 00                	mov    (%eax),%eax
  8030d5:	85 c0                	test   %eax,%eax
  8030d7:	74 0d                	je     8030e6 <insert_sorted_with_merge_freeList+0x776>
  8030d9:	a1 48 41 80 00       	mov    0x804148,%eax
  8030de:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030e1:	89 50 04             	mov    %edx,0x4(%eax)
  8030e4:	eb 08                	jmp    8030ee <insert_sorted_with_merge_freeList+0x77e>
  8030e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f1:	a3 48 41 80 00       	mov    %eax,0x804148
  8030f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803100:	a1 54 41 80 00       	mov    0x804154,%eax
  803105:	40                   	inc    %eax
  803106:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  80310b:	eb 38                	jmp    803145 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80310d:	a1 40 41 80 00       	mov    0x804140,%eax
  803112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803115:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803119:	74 07                	je     803122 <insert_sorted_with_merge_freeList+0x7b2>
  80311b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311e:	8b 00                	mov    (%eax),%eax
  803120:	eb 05                	jmp    803127 <insert_sorted_with_merge_freeList+0x7b7>
  803122:	b8 00 00 00 00       	mov    $0x0,%eax
  803127:	a3 40 41 80 00       	mov    %eax,0x804140
  80312c:	a1 40 41 80 00       	mov    0x804140,%eax
  803131:	85 c0                	test   %eax,%eax
  803133:	0f 85 ef f9 ff ff    	jne    802b28 <insert_sorted_with_merge_freeList+0x1b8>
  803139:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80313d:	0f 85 e5 f9 ff ff    	jne    802b28 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803143:	eb 00                	jmp    803145 <insert_sorted_with_merge_freeList+0x7d5>
  803145:	90                   	nop
  803146:	c9                   	leave  
  803147:	c3                   	ret    

00803148 <__udivdi3>:
  803148:	55                   	push   %ebp
  803149:	57                   	push   %edi
  80314a:	56                   	push   %esi
  80314b:	53                   	push   %ebx
  80314c:	83 ec 1c             	sub    $0x1c,%esp
  80314f:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803153:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803157:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80315b:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80315f:	89 ca                	mov    %ecx,%edx
  803161:	89 f8                	mov    %edi,%eax
  803163:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803167:	85 f6                	test   %esi,%esi
  803169:	75 2d                	jne    803198 <__udivdi3+0x50>
  80316b:	39 cf                	cmp    %ecx,%edi
  80316d:	77 65                	ja     8031d4 <__udivdi3+0x8c>
  80316f:	89 fd                	mov    %edi,%ebp
  803171:	85 ff                	test   %edi,%edi
  803173:	75 0b                	jne    803180 <__udivdi3+0x38>
  803175:	b8 01 00 00 00       	mov    $0x1,%eax
  80317a:	31 d2                	xor    %edx,%edx
  80317c:	f7 f7                	div    %edi
  80317e:	89 c5                	mov    %eax,%ebp
  803180:	31 d2                	xor    %edx,%edx
  803182:	89 c8                	mov    %ecx,%eax
  803184:	f7 f5                	div    %ebp
  803186:	89 c1                	mov    %eax,%ecx
  803188:	89 d8                	mov    %ebx,%eax
  80318a:	f7 f5                	div    %ebp
  80318c:	89 cf                	mov    %ecx,%edi
  80318e:	89 fa                	mov    %edi,%edx
  803190:	83 c4 1c             	add    $0x1c,%esp
  803193:	5b                   	pop    %ebx
  803194:	5e                   	pop    %esi
  803195:	5f                   	pop    %edi
  803196:	5d                   	pop    %ebp
  803197:	c3                   	ret    
  803198:	39 ce                	cmp    %ecx,%esi
  80319a:	77 28                	ja     8031c4 <__udivdi3+0x7c>
  80319c:	0f bd fe             	bsr    %esi,%edi
  80319f:	83 f7 1f             	xor    $0x1f,%edi
  8031a2:	75 40                	jne    8031e4 <__udivdi3+0x9c>
  8031a4:	39 ce                	cmp    %ecx,%esi
  8031a6:	72 0a                	jb     8031b2 <__udivdi3+0x6a>
  8031a8:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031ac:	0f 87 9e 00 00 00    	ja     803250 <__udivdi3+0x108>
  8031b2:	b8 01 00 00 00       	mov    $0x1,%eax
  8031b7:	89 fa                	mov    %edi,%edx
  8031b9:	83 c4 1c             	add    $0x1c,%esp
  8031bc:	5b                   	pop    %ebx
  8031bd:	5e                   	pop    %esi
  8031be:	5f                   	pop    %edi
  8031bf:	5d                   	pop    %ebp
  8031c0:	c3                   	ret    
  8031c1:	8d 76 00             	lea    0x0(%esi),%esi
  8031c4:	31 ff                	xor    %edi,%edi
  8031c6:	31 c0                	xor    %eax,%eax
  8031c8:	89 fa                	mov    %edi,%edx
  8031ca:	83 c4 1c             	add    $0x1c,%esp
  8031cd:	5b                   	pop    %ebx
  8031ce:	5e                   	pop    %esi
  8031cf:	5f                   	pop    %edi
  8031d0:	5d                   	pop    %ebp
  8031d1:	c3                   	ret    
  8031d2:	66 90                	xchg   %ax,%ax
  8031d4:	89 d8                	mov    %ebx,%eax
  8031d6:	f7 f7                	div    %edi
  8031d8:	31 ff                	xor    %edi,%edi
  8031da:	89 fa                	mov    %edi,%edx
  8031dc:	83 c4 1c             	add    $0x1c,%esp
  8031df:	5b                   	pop    %ebx
  8031e0:	5e                   	pop    %esi
  8031e1:	5f                   	pop    %edi
  8031e2:	5d                   	pop    %ebp
  8031e3:	c3                   	ret    
  8031e4:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031e9:	89 eb                	mov    %ebp,%ebx
  8031eb:	29 fb                	sub    %edi,%ebx
  8031ed:	89 f9                	mov    %edi,%ecx
  8031ef:	d3 e6                	shl    %cl,%esi
  8031f1:	89 c5                	mov    %eax,%ebp
  8031f3:	88 d9                	mov    %bl,%cl
  8031f5:	d3 ed                	shr    %cl,%ebp
  8031f7:	89 e9                	mov    %ebp,%ecx
  8031f9:	09 f1                	or     %esi,%ecx
  8031fb:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031ff:	89 f9                	mov    %edi,%ecx
  803201:	d3 e0                	shl    %cl,%eax
  803203:	89 c5                	mov    %eax,%ebp
  803205:	89 d6                	mov    %edx,%esi
  803207:	88 d9                	mov    %bl,%cl
  803209:	d3 ee                	shr    %cl,%esi
  80320b:	89 f9                	mov    %edi,%ecx
  80320d:	d3 e2                	shl    %cl,%edx
  80320f:	8b 44 24 08          	mov    0x8(%esp),%eax
  803213:	88 d9                	mov    %bl,%cl
  803215:	d3 e8                	shr    %cl,%eax
  803217:	09 c2                	or     %eax,%edx
  803219:	89 d0                	mov    %edx,%eax
  80321b:	89 f2                	mov    %esi,%edx
  80321d:	f7 74 24 0c          	divl   0xc(%esp)
  803221:	89 d6                	mov    %edx,%esi
  803223:	89 c3                	mov    %eax,%ebx
  803225:	f7 e5                	mul    %ebp
  803227:	39 d6                	cmp    %edx,%esi
  803229:	72 19                	jb     803244 <__udivdi3+0xfc>
  80322b:	74 0b                	je     803238 <__udivdi3+0xf0>
  80322d:	89 d8                	mov    %ebx,%eax
  80322f:	31 ff                	xor    %edi,%edi
  803231:	e9 58 ff ff ff       	jmp    80318e <__udivdi3+0x46>
  803236:	66 90                	xchg   %ax,%ax
  803238:	8b 54 24 08          	mov    0x8(%esp),%edx
  80323c:	89 f9                	mov    %edi,%ecx
  80323e:	d3 e2                	shl    %cl,%edx
  803240:	39 c2                	cmp    %eax,%edx
  803242:	73 e9                	jae    80322d <__udivdi3+0xe5>
  803244:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803247:	31 ff                	xor    %edi,%edi
  803249:	e9 40 ff ff ff       	jmp    80318e <__udivdi3+0x46>
  80324e:	66 90                	xchg   %ax,%ax
  803250:	31 c0                	xor    %eax,%eax
  803252:	e9 37 ff ff ff       	jmp    80318e <__udivdi3+0x46>
  803257:	90                   	nop

00803258 <__umoddi3>:
  803258:	55                   	push   %ebp
  803259:	57                   	push   %edi
  80325a:	56                   	push   %esi
  80325b:	53                   	push   %ebx
  80325c:	83 ec 1c             	sub    $0x1c,%esp
  80325f:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803263:	8b 74 24 34          	mov    0x34(%esp),%esi
  803267:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80326b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80326f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803273:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803277:	89 f3                	mov    %esi,%ebx
  803279:	89 fa                	mov    %edi,%edx
  80327b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80327f:	89 34 24             	mov    %esi,(%esp)
  803282:	85 c0                	test   %eax,%eax
  803284:	75 1a                	jne    8032a0 <__umoddi3+0x48>
  803286:	39 f7                	cmp    %esi,%edi
  803288:	0f 86 a2 00 00 00    	jbe    803330 <__umoddi3+0xd8>
  80328e:	89 c8                	mov    %ecx,%eax
  803290:	89 f2                	mov    %esi,%edx
  803292:	f7 f7                	div    %edi
  803294:	89 d0                	mov    %edx,%eax
  803296:	31 d2                	xor    %edx,%edx
  803298:	83 c4 1c             	add    $0x1c,%esp
  80329b:	5b                   	pop    %ebx
  80329c:	5e                   	pop    %esi
  80329d:	5f                   	pop    %edi
  80329e:	5d                   	pop    %ebp
  80329f:	c3                   	ret    
  8032a0:	39 f0                	cmp    %esi,%eax
  8032a2:	0f 87 ac 00 00 00    	ja     803354 <__umoddi3+0xfc>
  8032a8:	0f bd e8             	bsr    %eax,%ebp
  8032ab:	83 f5 1f             	xor    $0x1f,%ebp
  8032ae:	0f 84 ac 00 00 00    	je     803360 <__umoddi3+0x108>
  8032b4:	bf 20 00 00 00       	mov    $0x20,%edi
  8032b9:	29 ef                	sub    %ebp,%edi
  8032bb:	89 fe                	mov    %edi,%esi
  8032bd:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032c1:	89 e9                	mov    %ebp,%ecx
  8032c3:	d3 e0                	shl    %cl,%eax
  8032c5:	89 d7                	mov    %edx,%edi
  8032c7:	89 f1                	mov    %esi,%ecx
  8032c9:	d3 ef                	shr    %cl,%edi
  8032cb:	09 c7                	or     %eax,%edi
  8032cd:	89 e9                	mov    %ebp,%ecx
  8032cf:	d3 e2                	shl    %cl,%edx
  8032d1:	89 14 24             	mov    %edx,(%esp)
  8032d4:	89 d8                	mov    %ebx,%eax
  8032d6:	d3 e0                	shl    %cl,%eax
  8032d8:	89 c2                	mov    %eax,%edx
  8032da:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032de:	d3 e0                	shl    %cl,%eax
  8032e0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032e4:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032e8:	89 f1                	mov    %esi,%ecx
  8032ea:	d3 e8                	shr    %cl,%eax
  8032ec:	09 d0                	or     %edx,%eax
  8032ee:	d3 eb                	shr    %cl,%ebx
  8032f0:	89 da                	mov    %ebx,%edx
  8032f2:	f7 f7                	div    %edi
  8032f4:	89 d3                	mov    %edx,%ebx
  8032f6:	f7 24 24             	mull   (%esp)
  8032f9:	89 c6                	mov    %eax,%esi
  8032fb:	89 d1                	mov    %edx,%ecx
  8032fd:	39 d3                	cmp    %edx,%ebx
  8032ff:	0f 82 87 00 00 00    	jb     80338c <__umoddi3+0x134>
  803305:	0f 84 91 00 00 00    	je     80339c <__umoddi3+0x144>
  80330b:	8b 54 24 04          	mov    0x4(%esp),%edx
  80330f:	29 f2                	sub    %esi,%edx
  803311:	19 cb                	sbb    %ecx,%ebx
  803313:	89 d8                	mov    %ebx,%eax
  803315:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803319:	d3 e0                	shl    %cl,%eax
  80331b:	89 e9                	mov    %ebp,%ecx
  80331d:	d3 ea                	shr    %cl,%edx
  80331f:	09 d0                	or     %edx,%eax
  803321:	89 e9                	mov    %ebp,%ecx
  803323:	d3 eb                	shr    %cl,%ebx
  803325:	89 da                	mov    %ebx,%edx
  803327:	83 c4 1c             	add    $0x1c,%esp
  80332a:	5b                   	pop    %ebx
  80332b:	5e                   	pop    %esi
  80332c:	5f                   	pop    %edi
  80332d:	5d                   	pop    %ebp
  80332e:	c3                   	ret    
  80332f:	90                   	nop
  803330:	89 fd                	mov    %edi,%ebp
  803332:	85 ff                	test   %edi,%edi
  803334:	75 0b                	jne    803341 <__umoddi3+0xe9>
  803336:	b8 01 00 00 00       	mov    $0x1,%eax
  80333b:	31 d2                	xor    %edx,%edx
  80333d:	f7 f7                	div    %edi
  80333f:	89 c5                	mov    %eax,%ebp
  803341:	89 f0                	mov    %esi,%eax
  803343:	31 d2                	xor    %edx,%edx
  803345:	f7 f5                	div    %ebp
  803347:	89 c8                	mov    %ecx,%eax
  803349:	f7 f5                	div    %ebp
  80334b:	89 d0                	mov    %edx,%eax
  80334d:	e9 44 ff ff ff       	jmp    803296 <__umoddi3+0x3e>
  803352:	66 90                	xchg   %ax,%ax
  803354:	89 c8                	mov    %ecx,%eax
  803356:	89 f2                	mov    %esi,%edx
  803358:	83 c4 1c             	add    $0x1c,%esp
  80335b:	5b                   	pop    %ebx
  80335c:	5e                   	pop    %esi
  80335d:	5f                   	pop    %edi
  80335e:	5d                   	pop    %ebp
  80335f:	c3                   	ret    
  803360:	3b 04 24             	cmp    (%esp),%eax
  803363:	72 06                	jb     80336b <__umoddi3+0x113>
  803365:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803369:	77 0f                	ja     80337a <__umoddi3+0x122>
  80336b:	89 f2                	mov    %esi,%edx
  80336d:	29 f9                	sub    %edi,%ecx
  80336f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803373:	89 14 24             	mov    %edx,(%esp)
  803376:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80337a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80337e:	8b 14 24             	mov    (%esp),%edx
  803381:	83 c4 1c             	add    $0x1c,%esp
  803384:	5b                   	pop    %ebx
  803385:	5e                   	pop    %esi
  803386:	5f                   	pop    %edi
  803387:	5d                   	pop    %ebp
  803388:	c3                   	ret    
  803389:	8d 76 00             	lea    0x0(%esi),%esi
  80338c:	2b 04 24             	sub    (%esp),%eax
  80338f:	19 fa                	sbb    %edi,%edx
  803391:	89 d1                	mov    %edx,%ecx
  803393:	89 c6                	mov    %eax,%esi
  803395:	e9 71 ff ff ff       	jmp    80330b <__umoddi3+0xb3>
  80339a:	66 90                	xchg   %ax,%ax
  80339c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033a0:	72 ea                	jb     80338c <__umoddi3+0x134>
  8033a2:	89 d9                	mov    %ebx,%ecx
  8033a4:	e9 62 ff ff ff       	jmp    80330b <__umoddi3+0xb3>
