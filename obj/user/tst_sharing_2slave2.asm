
obj/user/tst_sharing_2slave2:     file format elf32-i386


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
  800031:	e8 c3 01 00 00       	call   8001f9 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Slave program2: Get 2 shared variables, edit the writable one, and attempt to edit the readOnly one
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
  80008d:	68 60 33 80 00       	push   $0x803360
  800092:	6a 13                	push   $0x13
  800094:	68 7c 33 80 00       	push   $0x80337c
  800099:	e8 97 02 00 00       	call   800335 <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 e0 14 00 00       	call   801588 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	int32 parentenvID = sys_getparentenvid();
  8000ab:	e8 6f 1c 00 00       	call   801d1f <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	uint32 *x, *z;

	//GET: z then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 5b 1a 00 00       	call   801b13 <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 69 19 00 00       	call   801a26 <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 97 33 80 00       	push   $0x803397
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 08 17 00 00       	call   8017d8 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 9c 33 80 00       	push   $0x80339c
  8000e7:	6a 21                	push   $0x21
  8000e9:	68 7c 33 80 00       	push   $0x80337c
  8000ee:	e8 42 02 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 2b 19 00 00       	call   801a26 <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 fc 33 80 00       	push   $0x8033fc
  80010c:	6a 22                	push   $0x22
  80010e:	68 7c 33 80 00       	push   $0x80337c
  800113:	e8 1d 02 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  800118:	e8 10 1a 00 00       	call   801b2d <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 f1 19 00 00       	call   801b13 <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 ff 18 00 00       	call   801a26 <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 8d 34 80 00       	push   $0x80348d
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 9e 16 00 00       	call   8017d8 <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 9c 33 80 00       	push   $0x80339c
  800151:	6a 28                	push   $0x28
  800153:	68 7c 33 80 00       	push   $0x80337c
  800158:	e8 d8 01 00 00       	call   800335 <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 c4 18 00 00       	call   801a26 <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 fc 33 80 00       	push   $0x8033fc
  800173:	6a 29                	push   $0x29
  800175:	68 7c 33 80 00       	push   $0x80337c
  80017a:	e8 b6 01 00 00       	call   800335 <_panic>
	sys_enable_interrupt();
  80017f:	e8 a9 19 00 00       	call   801b2d <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 0a             	cmp    $0xa,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 90 34 80 00       	push   $0x803490
  800196:	6a 2c                	push   $0x2c
  800198:	68 7c 33 80 00       	push   $0x80337c
  80019d:	e8 93 01 00 00       	call   800335 <_panic>

	//Edit the writable object
	*z = 30;
  8001a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001a5:	c7 00 1e 00 00 00    	movl   $0x1e,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  8001ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8001ae:	8b 00                	mov    (%eax),%eax
  8001b0:	83 f8 1e             	cmp    $0x1e,%eax
  8001b3:	74 14                	je     8001c9 <_main+0x191>
  8001b5:	83 ec 04             	sub    $0x4,%esp
  8001b8:	68 90 34 80 00       	push   $0x803490
  8001bd:	6a 30                	push   $0x30
  8001bf:	68 7c 33 80 00       	push   $0x80337c
  8001c4:	e8 6c 01 00 00       	call   800335 <_panic>

	//Attempt to edit the ReadOnly object, it should panic
	cprintf("Attempt to edit the ReadOnly object @ va = %x\n", x);
  8001c9:	83 ec 08             	sub    $0x8,%esp
  8001cc:	ff 75 e0             	pushl  -0x20(%ebp)
  8001cf:	68 c8 34 80 00       	push   $0x8034c8
  8001d4:	e8 10 04 00 00       	call   8005e9 <cprintf>
  8001d9:	83 c4 10             	add    $0x10,%esp
	*x = 100;
  8001dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001df:	c7 00 64 00 00 00    	movl   $0x64,(%eax)

	panic("Test FAILED! it should panic early and not reach this line of code") ;
  8001e5:	83 ec 04             	sub    $0x4,%esp
  8001e8:	68 f8 34 80 00       	push   $0x8034f8
  8001ed:	6a 36                	push   $0x36
  8001ef:	68 7c 33 80 00       	push   $0x80337c
  8001f4:	e8 3c 01 00 00       	call   800335 <_panic>

008001f9 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001f9:	55                   	push   %ebp
  8001fa:	89 e5                	mov    %esp,%ebp
  8001fc:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001ff:	e8 02 1b 00 00       	call   801d06 <sys_getenvindex>
  800204:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800207:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80020a:	89 d0                	mov    %edx,%eax
  80020c:	c1 e0 03             	shl    $0x3,%eax
  80020f:	01 d0                	add    %edx,%eax
  800211:	01 c0                	add    %eax,%eax
  800213:	01 d0                	add    %edx,%eax
  800215:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80021c:	01 d0                	add    %edx,%eax
  80021e:	c1 e0 04             	shl    $0x4,%eax
  800221:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800226:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800236:	84 c0                	test   %al,%al
  800238:	74 0f                	je     800249 <libmain+0x50>
		binaryname = myEnv->prog_name;
  80023a:	a1 20 40 80 00       	mov    0x804020,%eax
  80023f:	05 5c 05 00 00       	add    $0x55c,%eax
  800244:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800249:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80024d:	7e 0a                	jle    800259 <libmain+0x60>
		binaryname = argv[0];
  80024f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800252:	8b 00                	mov    (%eax),%eax
  800254:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  800259:	83 ec 08             	sub    $0x8,%esp
  80025c:	ff 75 0c             	pushl  0xc(%ebp)
  80025f:	ff 75 08             	pushl  0x8(%ebp)
  800262:	e8 d1 fd ff ff       	call   800038 <_main>
  800267:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80026a:	e8 a4 18 00 00       	call   801b13 <sys_disable_interrupt>
	cprintf("**************************************\n");
  80026f:	83 ec 0c             	sub    $0xc,%esp
  800272:	68 54 35 80 00       	push   $0x803554
  800277:	e8 6d 03 00 00       	call   8005e9 <cprintf>
  80027c:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80027f:	a1 20 40 80 00       	mov    0x804020,%eax
  800284:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80028a:	a1 20 40 80 00       	mov    0x804020,%eax
  80028f:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800295:	83 ec 04             	sub    $0x4,%esp
  800298:	52                   	push   %edx
  800299:	50                   	push   %eax
  80029a:	68 7c 35 80 00       	push   $0x80357c
  80029f:	e8 45 03 00 00       	call   8005e9 <cprintf>
  8002a4:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002a7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ac:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b7:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002bd:	a1 20 40 80 00       	mov    0x804020,%eax
  8002c2:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002c8:	51                   	push   %ecx
  8002c9:	52                   	push   %edx
  8002ca:	50                   	push   %eax
  8002cb:	68 a4 35 80 00       	push   $0x8035a4
  8002d0:	e8 14 03 00 00       	call   8005e9 <cprintf>
  8002d5:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002dd:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002e3:	83 ec 08             	sub    $0x8,%esp
  8002e6:	50                   	push   %eax
  8002e7:	68 fc 35 80 00       	push   $0x8035fc
  8002ec:	e8 f8 02 00 00       	call   8005e9 <cprintf>
  8002f1:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002f4:	83 ec 0c             	sub    $0xc,%esp
  8002f7:	68 54 35 80 00       	push   $0x803554
  8002fc:	e8 e8 02 00 00       	call   8005e9 <cprintf>
  800301:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800304:	e8 24 18 00 00       	call   801b2d <sys_enable_interrupt>

	// exit gracefully
	exit();
  800309:	e8 19 00 00 00       	call   800327 <exit>
}
  80030e:	90                   	nop
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800317:	83 ec 0c             	sub    $0xc,%esp
  80031a:	6a 00                	push   $0x0
  80031c:	e8 b1 19 00 00       	call   801cd2 <sys_destroy_env>
  800321:	83 c4 10             	add    $0x10,%esp
}
  800324:	90                   	nop
  800325:	c9                   	leave  
  800326:	c3                   	ret    

00800327 <exit>:

void
exit(void)
{
  800327:	55                   	push   %ebp
  800328:	89 e5                	mov    %esp,%ebp
  80032a:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80032d:	e8 06 1a 00 00       	call   801d38 <sys_exit_env>
}
  800332:	90                   	nop
  800333:	c9                   	leave  
  800334:	c3                   	ret    

00800335 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800335:	55                   	push   %ebp
  800336:	89 e5                	mov    %esp,%ebp
  800338:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80033b:	8d 45 10             	lea    0x10(%ebp),%eax
  80033e:	83 c0 04             	add    $0x4,%eax
  800341:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800344:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800349:	85 c0                	test   %eax,%eax
  80034b:	74 16                	je     800363 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80034d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800352:	83 ec 08             	sub    $0x8,%esp
  800355:	50                   	push   %eax
  800356:	68 10 36 80 00       	push   $0x803610
  80035b:	e8 89 02 00 00       	call   8005e9 <cprintf>
  800360:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800363:	a1 00 40 80 00       	mov    0x804000,%eax
  800368:	ff 75 0c             	pushl  0xc(%ebp)
  80036b:	ff 75 08             	pushl  0x8(%ebp)
  80036e:	50                   	push   %eax
  80036f:	68 15 36 80 00       	push   $0x803615
  800374:	e8 70 02 00 00       	call   8005e9 <cprintf>
  800379:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80037c:	8b 45 10             	mov    0x10(%ebp),%eax
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	ff 75 f4             	pushl  -0xc(%ebp)
  800385:	50                   	push   %eax
  800386:	e8 f3 01 00 00       	call   80057e <vcprintf>
  80038b:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80038e:	83 ec 08             	sub    $0x8,%esp
  800391:	6a 00                	push   $0x0
  800393:	68 31 36 80 00       	push   $0x803631
  800398:	e8 e1 01 00 00       	call   80057e <vcprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003a0:	e8 82 ff ff ff       	call   800327 <exit>

	// should not return here
	while (1) ;
  8003a5:	eb fe                	jmp    8003a5 <_panic+0x70>

008003a7 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003a7:	55                   	push   %ebp
  8003a8:	89 e5                	mov    %esp,%ebp
  8003aa:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8003b2:	8b 50 74             	mov    0x74(%eax),%edx
  8003b5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b8:	39 c2                	cmp    %eax,%edx
  8003ba:	74 14                	je     8003d0 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003bc:	83 ec 04             	sub    $0x4,%esp
  8003bf:	68 34 36 80 00       	push   $0x803634
  8003c4:	6a 26                	push   $0x26
  8003c6:	68 80 36 80 00       	push   $0x803680
  8003cb:	e8 65 ff ff ff       	call   800335 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003d0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003d7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003de:	e9 c2 00 00 00       	jmp    8004a5 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f0:	01 d0                	add    %edx,%eax
  8003f2:	8b 00                	mov    (%eax),%eax
  8003f4:	85 c0                	test   %eax,%eax
  8003f6:	75 08                	jne    800400 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003f8:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003fb:	e9 a2 00 00 00       	jmp    8004a2 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800400:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800407:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80040e:	eb 69                	jmp    800479 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800410:	a1 20 40 80 00       	mov    0x804020,%eax
  800415:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80041b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80041e:	89 d0                	mov    %edx,%eax
  800420:	01 c0                	add    %eax,%eax
  800422:	01 d0                	add    %edx,%eax
  800424:	c1 e0 03             	shl    $0x3,%eax
  800427:	01 c8                	add    %ecx,%eax
  800429:	8a 40 04             	mov    0x4(%eax),%al
  80042c:	84 c0                	test   %al,%al
  80042e:	75 46                	jne    800476 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800430:	a1 20 40 80 00       	mov    0x804020,%eax
  800435:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80043b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80043e:	89 d0                	mov    %edx,%eax
  800440:	01 c0                	add    %eax,%eax
  800442:	01 d0                	add    %edx,%eax
  800444:	c1 e0 03             	shl    $0x3,%eax
  800447:	01 c8                	add    %ecx,%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80044e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800451:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800456:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80045b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800462:	8b 45 08             	mov    0x8(%ebp),%eax
  800465:	01 c8                	add    %ecx,%eax
  800467:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800469:	39 c2                	cmp    %eax,%edx
  80046b:	75 09                	jne    800476 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80046d:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800474:	eb 12                	jmp    800488 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800476:	ff 45 e8             	incl   -0x18(%ebp)
  800479:	a1 20 40 80 00       	mov    0x804020,%eax
  80047e:	8b 50 74             	mov    0x74(%eax),%edx
  800481:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800484:	39 c2                	cmp    %eax,%edx
  800486:	77 88                	ja     800410 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800488:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80048c:	75 14                	jne    8004a2 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80048e:	83 ec 04             	sub    $0x4,%esp
  800491:	68 8c 36 80 00       	push   $0x80368c
  800496:	6a 3a                	push   $0x3a
  800498:	68 80 36 80 00       	push   $0x803680
  80049d:	e8 93 fe ff ff       	call   800335 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004a2:	ff 45 f0             	incl   -0x10(%ebp)
  8004a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004a8:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004ab:	0f 8c 32 ff ff ff    	jl     8003e3 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004b1:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004b8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004bf:	eb 26                	jmp    8004e7 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004c1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004c6:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004cc:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004cf:	89 d0                	mov    %edx,%eax
  8004d1:	01 c0                	add    %eax,%eax
  8004d3:	01 d0                	add    %edx,%eax
  8004d5:	c1 e0 03             	shl    $0x3,%eax
  8004d8:	01 c8                	add    %ecx,%eax
  8004da:	8a 40 04             	mov    0x4(%eax),%al
  8004dd:	3c 01                	cmp    $0x1,%al
  8004df:	75 03                	jne    8004e4 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004e1:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004e4:	ff 45 e0             	incl   -0x20(%ebp)
  8004e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8004ec:	8b 50 74             	mov    0x74(%eax),%edx
  8004ef:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004f2:	39 c2                	cmp    %eax,%edx
  8004f4:	77 cb                	ja     8004c1 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004f9:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fc:	74 14                	je     800512 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004fe:	83 ec 04             	sub    $0x4,%esp
  800501:	68 e0 36 80 00       	push   $0x8036e0
  800506:	6a 44                	push   $0x44
  800508:	68 80 36 80 00       	push   $0x803680
  80050d:	e8 23 fe ff ff       	call   800335 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800512:	90                   	nop
  800513:	c9                   	leave  
  800514:	c3                   	ret    

00800515 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800515:	55                   	push   %ebp
  800516:	89 e5                	mov    %esp,%ebp
  800518:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80051b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051e:	8b 00                	mov    (%eax),%eax
  800520:	8d 48 01             	lea    0x1(%eax),%ecx
  800523:	8b 55 0c             	mov    0xc(%ebp),%edx
  800526:	89 0a                	mov    %ecx,(%edx)
  800528:	8b 55 08             	mov    0x8(%ebp),%edx
  80052b:	88 d1                	mov    %dl,%cl
  80052d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800530:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800534:	8b 45 0c             	mov    0xc(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	3d ff 00 00 00       	cmp    $0xff,%eax
  80053e:	75 2c                	jne    80056c <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800540:	a0 24 40 80 00       	mov    0x804024,%al
  800545:	0f b6 c0             	movzbl %al,%eax
  800548:	8b 55 0c             	mov    0xc(%ebp),%edx
  80054b:	8b 12                	mov    (%edx),%edx
  80054d:	89 d1                	mov    %edx,%ecx
  80054f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800552:	83 c2 08             	add    $0x8,%edx
  800555:	83 ec 04             	sub    $0x4,%esp
  800558:	50                   	push   %eax
  800559:	51                   	push   %ecx
  80055a:	52                   	push   %edx
  80055b:	e8 05 14 00 00       	call   801965 <sys_cputs>
  800560:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800563:	8b 45 0c             	mov    0xc(%ebp),%eax
  800566:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80056c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056f:	8b 40 04             	mov    0x4(%eax),%eax
  800572:	8d 50 01             	lea    0x1(%eax),%edx
  800575:	8b 45 0c             	mov    0xc(%ebp),%eax
  800578:	89 50 04             	mov    %edx,0x4(%eax)
}
  80057b:	90                   	nop
  80057c:	c9                   	leave  
  80057d:	c3                   	ret    

0080057e <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80057e:	55                   	push   %ebp
  80057f:	89 e5                	mov    %esp,%ebp
  800581:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800587:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80058e:	00 00 00 
	b.cnt = 0;
  800591:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800598:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80059b:	ff 75 0c             	pushl  0xc(%ebp)
  80059e:	ff 75 08             	pushl  0x8(%ebp)
  8005a1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005a7:	50                   	push   %eax
  8005a8:	68 15 05 80 00       	push   $0x800515
  8005ad:	e8 11 02 00 00       	call   8007c3 <vprintfmt>
  8005b2:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005b5:	a0 24 40 80 00       	mov    0x804024,%al
  8005ba:	0f b6 c0             	movzbl %al,%eax
  8005bd:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005c3:	83 ec 04             	sub    $0x4,%esp
  8005c6:	50                   	push   %eax
  8005c7:	52                   	push   %edx
  8005c8:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005ce:	83 c0 08             	add    $0x8,%eax
  8005d1:	50                   	push   %eax
  8005d2:	e8 8e 13 00 00       	call   801965 <sys_cputs>
  8005d7:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005da:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005e1:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005e7:	c9                   	leave  
  8005e8:	c3                   	ret    

008005e9 <cprintf>:

int cprintf(const char *fmt, ...) {
  8005e9:	55                   	push   %ebp
  8005ea:	89 e5                	mov    %esp,%ebp
  8005ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005ef:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005f6:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005f9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ff:	83 ec 08             	sub    $0x8,%esp
  800602:	ff 75 f4             	pushl  -0xc(%ebp)
  800605:	50                   	push   %eax
  800606:	e8 73 ff ff ff       	call   80057e <vcprintf>
  80060b:	83 c4 10             	add    $0x10,%esp
  80060e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800611:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800614:	c9                   	leave  
  800615:	c3                   	ret    

00800616 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800616:	55                   	push   %ebp
  800617:	89 e5                	mov    %esp,%ebp
  800619:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80061c:	e8 f2 14 00 00       	call   801b13 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800621:	8d 45 0c             	lea    0xc(%ebp),%eax
  800624:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	83 ec 08             	sub    $0x8,%esp
  80062d:	ff 75 f4             	pushl  -0xc(%ebp)
  800630:	50                   	push   %eax
  800631:	e8 48 ff ff ff       	call   80057e <vcprintf>
  800636:	83 c4 10             	add    $0x10,%esp
  800639:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80063c:	e8 ec 14 00 00       	call   801b2d <sys_enable_interrupt>
	return cnt;
  800641:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800644:	c9                   	leave  
  800645:	c3                   	ret    

00800646 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800646:	55                   	push   %ebp
  800647:	89 e5                	mov    %esp,%ebp
  800649:	53                   	push   %ebx
  80064a:	83 ec 14             	sub    $0x14,%esp
  80064d:	8b 45 10             	mov    0x10(%ebp),%eax
  800650:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800653:	8b 45 14             	mov    0x14(%ebp),%eax
  800656:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800659:	8b 45 18             	mov    0x18(%ebp),%eax
  80065c:	ba 00 00 00 00       	mov    $0x0,%edx
  800661:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800664:	77 55                	ja     8006bb <printnum+0x75>
  800666:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800669:	72 05                	jb     800670 <printnum+0x2a>
  80066b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80066e:	77 4b                	ja     8006bb <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800670:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800673:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800676:	8b 45 18             	mov    0x18(%ebp),%eax
  800679:	ba 00 00 00 00       	mov    $0x0,%edx
  80067e:	52                   	push   %edx
  80067f:	50                   	push   %eax
  800680:	ff 75 f4             	pushl  -0xc(%ebp)
  800683:	ff 75 f0             	pushl  -0x10(%ebp)
  800686:	e8 65 2a 00 00       	call   8030f0 <__udivdi3>
  80068b:	83 c4 10             	add    $0x10,%esp
  80068e:	83 ec 04             	sub    $0x4,%esp
  800691:	ff 75 20             	pushl  0x20(%ebp)
  800694:	53                   	push   %ebx
  800695:	ff 75 18             	pushl  0x18(%ebp)
  800698:	52                   	push   %edx
  800699:	50                   	push   %eax
  80069a:	ff 75 0c             	pushl  0xc(%ebp)
  80069d:	ff 75 08             	pushl  0x8(%ebp)
  8006a0:	e8 a1 ff ff ff       	call   800646 <printnum>
  8006a5:	83 c4 20             	add    $0x20,%esp
  8006a8:	eb 1a                	jmp    8006c4 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006aa:	83 ec 08             	sub    $0x8,%esp
  8006ad:	ff 75 0c             	pushl  0xc(%ebp)
  8006b0:	ff 75 20             	pushl  0x20(%ebp)
  8006b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b6:	ff d0                	call   *%eax
  8006b8:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006bb:	ff 4d 1c             	decl   0x1c(%ebp)
  8006be:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006c2:	7f e6                	jg     8006aa <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006c4:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006c7:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006cf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006d2:	53                   	push   %ebx
  8006d3:	51                   	push   %ecx
  8006d4:	52                   	push   %edx
  8006d5:	50                   	push   %eax
  8006d6:	e8 25 2b 00 00       	call   803200 <__umoddi3>
  8006db:	83 c4 10             	add    $0x10,%esp
  8006de:	05 54 39 80 00       	add    $0x803954,%eax
  8006e3:	8a 00                	mov    (%eax),%al
  8006e5:	0f be c0             	movsbl %al,%eax
  8006e8:	83 ec 08             	sub    $0x8,%esp
  8006eb:	ff 75 0c             	pushl  0xc(%ebp)
  8006ee:	50                   	push   %eax
  8006ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8006f2:	ff d0                	call   *%eax
  8006f4:	83 c4 10             	add    $0x10,%esp
}
  8006f7:	90                   	nop
  8006f8:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006fb:	c9                   	leave  
  8006fc:	c3                   	ret    

008006fd <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006fd:	55                   	push   %ebp
  8006fe:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800700:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800704:	7e 1c                	jle    800722 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
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
  800720:	eb 40                	jmp    800762 <getuint+0x65>
	else if (lflag)
  800722:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800726:	74 1e                	je     800746 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	8b 00                	mov    (%eax),%eax
  80072d:	8d 50 04             	lea    0x4(%eax),%edx
  800730:	8b 45 08             	mov    0x8(%ebp),%eax
  800733:	89 10                	mov    %edx,(%eax)
  800735:	8b 45 08             	mov    0x8(%ebp),%eax
  800738:	8b 00                	mov    (%eax),%eax
  80073a:	83 e8 04             	sub    $0x4,%eax
  80073d:	8b 00                	mov    (%eax),%eax
  80073f:	ba 00 00 00 00       	mov    $0x0,%edx
  800744:	eb 1c                	jmp    800762 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800746:	8b 45 08             	mov    0x8(%ebp),%eax
  800749:	8b 00                	mov    (%eax),%eax
  80074b:	8d 50 04             	lea    0x4(%eax),%edx
  80074e:	8b 45 08             	mov    0x8(%ebp),%eax
  800751:	89 10                	mov    %edx,(%eax)
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	8b 00                	mov    (%eax),%eax
  800758:	83 e8 04             	sub    $0x4,%eax
  80075b:	8b 00                	mov    (%eax),%eax
  80075d:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800762:	5d                   	pop    %ebp
  800763:	c3                   	ret    

00800764 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800764:	55                   	push   %ebp
  800765:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800767:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80076b:	7e 1c                	jle    800789 <getint+0x25>
		return va_arg(*ap, long long);
  80076d:	8b 45 08             	mov    0x8(%ebp),%eax
  800770:	8b 00                	mov    (%eax),%eax
  800772:	8d 50 08             	lea    0x8(%eax),%edx
  800775:	8b 45 08             	mov    0x8(%ebp),%eax
  800778:	89 10                	mov    %edx,(%eax)
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	8b 00                	mov    (%eax),%eax
  80077f:	83 e8 08             	sub    $0x8,%eax
  800782:	8b 50 04             	mov    0x4(%eax),%edx
  800785:	8b 00                	mov    (%eax),%eax
  800787:	eb 38                	jmp    8007c1 <getint+0x5d>
	else if (lflag)
  800789:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078d:	74 1a                	je     8007a9 <getint+0x45>
		return va_arg(*ap, long);
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	8b 00                	mov    (%eax),%eax
  800794:	8d 50 04             	lea    0x4(%eax),%edx
  800797:	8b 45 08             	mov    0x8(%ebp),%eax
  80079a:	89 10                	mov    %edx,(%eax)
  80079c:	8b 45 08             	mov    0x8(%ebp),%eax
  80079f:	8b 00                	mov    (%eax),%eax
  8007a1:	83 e8 04             	sub    $0x4,%eax
  8007a4:	8b 00                	mov    (%eax),%eax
  8007a6:	99                   	cltd   
  8007a7:	eb 18                	jmp    8007c1 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ac:	8b 00                	mov    (%eax),%eax
  8007ae:	8d 50 04             	lea    0x4(%eax),%edx
  8007b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b4:	89 10                	mov    %edx,(%eax)
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	8b 00                	mov    (%eax),%eax
  8007bb:	83 e8 04             	sub    $0x4,%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	99                   	cltd   
}
  8007c1:	5d                   	pop    %ebp
  8007c2:	c3                   	ret    

008007c3 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007c3:	55                   	push   %ebp
  8007c4:	89 e5                	mov    %esp,%ebp
  8007c6:	56                   	push   %esi
  8007c7:	53                   	push   %ebx
  8007c8:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007cb:	eb 17                	jmp    8007e4 <vprintfmt+0x21>
			if (ch == '\0')
  8007cd:	85 db                	test   %ebx,%ebx
  8007cf:	0f 84 af 03 00 00    	je     800b84 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007d5:	83 ec 08             	sub    $0x8,%esp
  8007d8:	ff 75 0c             	pushl  0xc(%ebp)
  8007db:	53                   	push   %ebx
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	ff d0                	call   *%eax
  8007e1:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8007e7:	8d 50 01             	lea    0x1(%eax),%edx
  8007ea:	89 55 10             	mov    %edx,0x10(%ebp)
  8007ed:	8a 00                	mov    (%eax),%al
  8007ef:	0f b6 d8             	movzbl %al,%ebx
  8007f2:	83 fb 25             	cmp    $0x25,%ebx
  8007f5:	75 d6                	jne    8007cd <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007f7:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007fb:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800802:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800809:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800810:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800817:	8b 45 10             	mov    0x10(%ebp),%eax
  80081a:	8d 50 01             	lea    0x1(%eax),%edx
  80081d:	89 55 10             	mov    %edx,0x10(%ebp)
  800820:	8a 00                	mov    (%eax),%al
  800822:	0f b6 d8             	movzbl %al,%ebx
  800825:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800828:	83 f8 55             	cmp    $0x55,%eax
  80082b:	0f 87 2b 03 00 00    	ja     800b5c <vprintfmt+0x399>
  800831:	8b 04 85 78 39 80 00 	mov    0x803978(,%eax,4),%eax
  800838:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80083a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80083e:	eb d7                	jmp    800817 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800840:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800844:	eb d1                	jmp    800817 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800846:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80084d:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800850:	89 d0                	mov    %edx,%eax
  800852:	c1 e0 02             	shl    $0x2,%eax
  800855:	01 d0                	add    %edx,%eax
  800857:	01 c0                	add    %eax,%eax
  800859:	01 d8                	add    %ebx,%eax
  80085b:	83 e8 30             	sub    $0x30,%eax
  80085e:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800861:	8b 45 10             	mov    0x10(%ebp),%eax
  800864:	8a 00                	mov    (%eax),%al
  800866:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800869:	83 fb 2f             	cmp    $0x2f,%ebx
  80086c:	7e 3e                	jle    8008ac <vprintfmt+0xe9>
  80086e:	83 fb 39             	cmp    $0x39,%ebx
  800871:	7f 39                	jg     8008ac <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800873:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800876:	eb d5                	jmp    80084d <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800878:	8b 45 14             	mov    0x14(%ebp),%eax
  80087b:	83 c0 04             	add    $0x4,%eax
  80087e:	89 45 14             	mov    %eax,0x14(%ebp)
  800881:	8b 45 14             	mov    0x14(%ebp),%eax
  800884:	83 e8 04             	sub    $0x4,%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80088c:	eb 1f                	jmp    8008ad <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80088e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800892:	79 83                	jns    800817 <vprintfmt+0x54>
				width = 0;
  800894:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80089b:	e9 77 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008a0:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008a7:	e9 6b ff ff ff       	jmp    800817 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008ac:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008b1:	0f 89 60 ff ff ff    	jns    800817 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008b7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008bd:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008c4:	e9 4e ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008c9:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008cc:	e9 46 ff ff ff       	jmp    800817 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8008d4:	83 c0 04             	add    $0x4,%eax
  8008d7:	89 45 14             	mov    %eax,0x14(%ebp)
  8008da:	8b 45 14             	mov    0x14(%ebp),%eax
  8008dd:	83 e8 04             	sub    $0x4,%eax
  8008e0:	8b 00                	mov    (%eax),%eax
  8008e2:	83 ec 08             	sub    $0x8,%esp
  8008e5:	ff 75 0c             	pushl  0xc(%ebp)
  8008e8:	50                   	push   %eax
  8008e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ec:	ff d0                	call   *%eax
  8008ee:	83 c4 10             	add    $0x10,%esp
			break;
  8008f1:	e9 89 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f9:	83 c0 04             	add    $0x4,%eax
  8008fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8008ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800902:	83 e8 04             	sub    $0x4,%eax
  800905:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800907:	85 db                	test   %ebx,%ebx
  800909:	79 02                	jns    80090d <vprintfmt+0x14a>
				err = -err;
  80090b:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80090d:	83 fb 64             	cmp    $0x64,%ebx
  800910:	7f 0b                	jg     80091d <vprintfmt+0x15a>
  800912:	8b 34 9d c0 37 80 00 	mov    0x8037c0(,%ebx,4),%esi
  800919:	85 f6                	test   %esi,%esi
  80091b:	75 19                	jne    800936 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80091d:	53                   	push   %ebx
  80091e:	68 65 39 80 00       	push   $0x803965
  800923:	ff 75 0c             	pushl  0xc(%ebp)
  800926:	ff 75 08             	pushl  0x8(%ebp)
  800929:	e8 5e 02 00 00       	call   800b8c <printfmt>
  80092e:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800931:	e9 49 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800936:	56                   	push   %esi
  800937:	68 6e 39 80 00       	push   $0x80396e
  80093c:	ff 75 0c             	pushl  0xc(%ebp)
  80093f:	ff 75 08             	pushl  0x8(%ebp)
  800942:	e8 45 02 00 00       	call   800b8c <printfmt>
  800947:	83 c4 10             	add    $0x10,%esp
			break;
  80094a:	e9 30 02 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  80094f:	8b 45 14             	mov    0x14(%ebp),%eax
  800952:	83 c0 04             	add    $0x4,%eax
  800955:	89 45 14             	mov    %eax,0x14(%ebp)
  800958:	8b 45 14             	mov    0x14(%ebp),%eax
  80095b:	83 e8 04             	sub    $0x4,%eax
  80095e:	8b 30                	mov    (%eax),%esi
  800960:	85 f6                	test   %esi,%esi
  800962:	75 05                	jne    800969 <vprintfmt+0x1a6>
				p = "(null)";
  800964:	be 71 39 80 00       	mov    $0x803971,%esi
			if (width > 0 && padc != '-')
  800969:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80096d:	7e 6d                	jle    8009dc <vprintfmt+0x219>
  80096f:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800973:	74 67                	je     8009dc <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800975:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	50                   	push   %eax
  80097c:	56                   	push   %esi
  80097d:	e8 0c 03 00 00       	call   800c8e <strnlen>
  800982:	83 c4 10             	add    $0x10,%esp
  800985:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800988:	eb 16                	jmp    8009a0 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80098a:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80098e:	83 ec 08             	sub    $0x8,%esp
  800991:	ff 75 0c             	pushl  0xc(%ebp)
  800994:	50                   	push   %eax
  800995:	8b 45 08             	mov    0x8(%ebp),%eax
  800998:	ff d0                	call   *%eax
  80099a:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80099d:	ff 4d e4             	decl   -0x1c(%ebp)
  8009a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a4:	7f e4                	jg     80098a <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009a6:	eb 34                	jmp    8009dc <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009a8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009ac:	74 1c                	je     8009ca <vprintfmt+0x207>
  8009ae:	83 fb 1f             	cmp    $0x1f,%ebx
  8009b1:	7e 05                	jle    8009b8 <vprintfmt+0x1f5>
  8009b3:	83 fb 7e             	cmp    $0x7e,%ebx
  8009b6:	7e 12                	jle    8009ca <vprintfmt+0x207>
					putch('?', putdat);
  8009b8:	83 ec 08             	sub    $0x8,%esp
  8009bb:	ff 75 0c             	pushl  0xc(%ebp)
  8009be:	6a 3f                	push   $0x3f
  8009c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c3:	ff d0                	call   *%eax
  8009c5:	83 c4 10             	add    $0x10,%esp
  8009c8:	eb 0f                	jmp    8009d9 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ca:	83 ec 08             	sub    $0x8,%esp
  8009cd:	ff 75 0c             	pushl  0xc(%ebp)
  8009d0:	53                   	push   %ebx
  8009d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d4:	ff d0                	call   *%eax
  8009d6:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009d9:	ff 4d e4             	decl   -0x1c(%ebp)
  8009dc:	89 f0                	mov    %esi,%eax
  8009de:	8d 70 01             	lea    0x1(%eax),%esi
  8009e1:	8a 00                	mov    (%eax),%al
  8009e3:	0f be d8             	movsbl %al,%ebx
  8009e6:	85 db                	test   %ebx,%ebx
  8009e8:	74 24                	je     800a0e <vprintfmt+0x24b>
  8009ea:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009ee:	78 b8                	js     8009a8 <vprintfmt+0x1e5>
  8009f0:	ff 4d e0             	decl   -0x20(%ebp)
  8009f3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009f7:	79 af                	jns    8009a8 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009f9:	eb 13                	jmp    800a0e <vprintfmt+0x24b>
				putch(' ', putdat);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	ff 75 0c             	pushl  0xc(%ebp)
  800a01:	6a 20                	push   $0x20
  800a03:	8b 45 08             	mov    0x8(%ebp),%eax
  800a06:	ff d0                	call   *%eax
  800a08:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a0b:	ff 4d e4             	decl   -0x1c(%ebp)
  800a0e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a12:	7f e7                	jg     8009fb <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a14:	e9 66 01 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a19:	83 ec 08             	sub    $0x8,%esp
  800a1c:	ff 75 e8             	pushl  -0x18(%ebp)
  800a1f:	8d 45 14             	lea    0x14(%ebp),%eax
  800a22:	50                   	push   %eax
  800a23:	e8 3c fd ff ff       	call   800764 <getint>
  800a28:	83 c4 10             	add    $0x10,%esp
  800a2b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a2e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a34:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a37:	85 d2                	test   %edx,%edx
  800a39:	79 23                	jns    800a5e <vprintfmt+0x29b>
				putch('-', putdat);
  800a3b:	83 ec 08             	sub    $0x8,%esp
  800a3e:	ff 75 0c             	pushl  0xc(%ebp)
  800a41:	6a 2d                	push   $0x2d
  800a43:	8b 45 08             	mov    0x8(%ebp),%eax
  800a46:	ff d0                	call   *%eax
  800a48:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a51:	f7 d8                	neg    %eax
  800a53:	83 d2 00             	adc    $0x0,%edx
  800a56:	f7 da                	neg    %edx
  800a58:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a5b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a5e:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a65:	e9 bc 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a6a:	83 ec 08             	sub    $0x8,%esp
  800a6d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a70:	8d 45 14             	lea    0x14(%ebp),%eax
  800a73:	50                   	push   %eax
  800a74:	e8 84 fc ff ff       	call   8006fd <getuint>
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a7f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a82:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a89:	e9 98 00 00 00       	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a8e:	83 ec 08             	sub    $0x8,%esp
  800a91:	ff 75 0c             	pushl  0xc(%ebp)
  800a94:	6a 58                	push   $0x58
  800a96:	8b 45 08             	mov    0x8(%ebp),%eax
  800a99:	ff d0                	call   *%eax
  800a9b:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9e:	83 ec 08             	sub    $0x8,%esp
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	6a 58                	push   $0x58
  800aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa9:	ff d0                	call   *%eax
  800aab:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800aae:	83 ec 08             	sub    $0x8,%esp
  800ab1:	ff 75 0c             	pushl  0xc(%ebp)
  800ab4:	6a 58                	push   $0x58
  800ab6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ab9:	ff d0                	call   *%eax
  800abb:	83 c4 10             	add    $0x10,%esp
			break;
  800abe:	e9 bc 00 00 00       	jmp    800b7f <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 30                	push   $0x30
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 78                	push   $0x78
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ae3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae6:	83 c0 04             	add    $0x4,%eax
  800ae9:	89 45 14             	mov    %eax,0x14(%ebp)
  800aec:	8b 45 14             	mov    0x14(%ebp),%eax
  800aef:	83 e8 04             	sub    $0x4,%eax
  800af2:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800af4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800af7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800afe:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b05:	eb 1f                	jmp    800b26 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b07:	83 ec 08             	sub    $0x8,%esp
  800b0a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b0d:	8d 45 14             	lea    0x14(%ebp),%eax
  800b10:	50                   	push   %eax
  800b11:	e8 e7 fb ff ff       	call   8006fd <getuint>
  800b16:	83 c4 10             	add    $0x10,%esp
  800b19:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b1c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b1f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b26:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b2a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b2d:	83 ec 04             	sub    $0x4,%esp
  800b30:	52                   	push   %edx
  800b31:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b34:	50                   	push   %eax
  800b35:	ff 75 f4             	pushl  -0xc(%ebp)
  800b38:	ff 75 f0             	pushl  -0x10(%ebp)
  800b3b:	ff 75 0c             	pushl  0xc(%ebp)
  800b3e:	ff 75 08             	pushl  0x8(%ebp)
  800b41:	e8 00 fb ff ff       	call   800646 <printnum>
  800b46:	83 c4 20             	add    $0x20,%esp
			break;
  800b49:	eb 34                	jmp    800b7f <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b4b:	83 ec 08             	sub    $0x8,%esp
  800b4e:	ff 75 0c             	pushl  0xc(%ebp)
  800b51:	53                   	push   %ebx
  800b52:	8b 45 08             	mov    0x8(%ebp),%eax
  800b55:	ff d0                	call   *%eax
  800b57:	83 c4 10             	add    $0x10,%esp
			break;
  800b5a:	eb 23                	jmp    800b7f <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b5c:	83 ec 08             	sub    $0x8,%esp
  800b5f:	ff 75 0c             	pushl  0xc(%ebp)
  800b62:	6a 25                	push   $0x25
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	ff d0                	call   *%eax
  800b69:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b6c:	ff 4d 10             	decl   0x10(%ebp)
  800b6f:	eb 03                	jmp    800b74 <vprintfmt+0x3b1>
  800b71:	ff 4d 10             	decl   0x10(%ebp)
  800b74:	8b 45 10             	mov    0x10(%ebp),%eax
  800b77:	48                   	dec    %eax
  800b78:	8a 00                	mov    (%eax),%al
  800b7a:	3c 25                	cmp    $0x25,%al
  800b7c:	75 f3                	jne    800b71 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b7e:	90                   	nop
		}
	}
  800b7f:	e9 47 fc ff ff       	jmp    8007cb <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b84:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b85:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b88:	5b                   	pop    %ebx
  800b89:	5e                   	pop    %esi
  800b8a:	5d                   	pop    %ebp
  800b8b:	c3                   	ret    

00800b8c <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b8c:	55                   	push   %ebp
  800b8d:	89 e5                	mov    %esp,%ebp
  800b8f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b92:	8d 45 10             	lea    0x10(%ebp),%eax
  800b95:	83 c0 04             	add    $0x4,%eax
  800b98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b9b:	8b 45 10             	mov    0x10(%ebp),%eax
  800b9e:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba1:	50                   	push   %eax
  800ba2:	ff 75 0c             	pushl  0xc(%ebp)
  800ba5:	ff 75 08             	pushl  0x8(%ebp)
  800ba8:	e8 16 fc ff ff       	call   8007c3 <vprintfmt>
  800bad:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800bb0:	90                   	nop
  800bb1:	c9                   	leave  
  800bb2:	c3                   	ret    

00800bb3 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800bb3:	55                   	push   %ebp
  800bb4:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 40 08             	mov    0x8(%eax),%eax
  800bbc:	8d 50 01             	lea    0x1(%eax),%edx
  800bbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc2:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8b 10                	mov    (%eax),%edx
  800bca:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bcd:	8b 40 04             	mov    0x4(%eax),%eax
  800bd0:	39 c2                	cmp    %eax,%edx
  800bd2:	73 12                	jae    800be6 <sprintputch+0x33>
		*b->buf++ = ch;
  800bd4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd7:	8b 00                	mov    (%eax),%eax
  800bd9:	8d 48 01             	lea    0x1(%eax),%ecx
  800bdc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bdf:	89 0a                	mov    %ecx,(%edx)
  800be1:	8b 55 08             	mov    0x8(%ebp),%edx
  800be4:	88 10                	mov    %dl,(%eax)
}
  800be6:	90                   	nop
  800be7:	5d                   	pop    %ebp
  800be8:	c3                   	ret    

00800be9 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800be9:	55                   	push   %ebp
  800bea:	89 e5                	mov    %esp,%ebp
  800bec:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800bef:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf2:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800bf5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf8:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bfe:	01 d0                	add    %edx,%eax
  800c00:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c03:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c0e:	74 06                	je     800c16 <vsnprintf+0x2d>
  800c10:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c14:	7f 07                	jg     800c1d <vsnprintf+0x34>
		return -E_INVAL;
  800c16:	b8 03 00 00 00       	mov    $0x3,%eax
  800c1b:	eb 20                	jmp    800c3d <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c1d:	ff 75 14             	pushl  0x14(%ebp)
  800c20:	ff 75 10             	pushl  0x10(%ebp)
  800c23:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c26:	50                   	push   %eax
  800c27:	68 b3 0b 80 00       	push   $0x800bb3
  800c2c:	e8 92 fb ff ff       	call   8007c3 <vprintfmt>
  800c31:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c34:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c37:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c3d:	c9                   	leave  
  800c3e:	c3                   	ret    

00800c3f <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c3f:	55                   	push   %ebp
  800c40:	89 e5                	mov    %esp,%ebp
  800c42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c45:	8d 45 10             	lea    0x10(%ebp),%eax
  800c48:	83 c0 04             	add    $0x4,%eax
  800c4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c51:	ff 75 f4             	pushl  -0xc(%ebp)
  800c54:	50                   	push   %eax
  800c55:	ff 75 0c             	pushl  0xc(%ebp)
  800c58:	ff 75 08             	pushl  0x8(%ebp)
  800c5b:	e8 89 ff ff ff       	call   800be9 <vsnprintf>
  800c60:	83 c4 10             	add    $0x10,%esp
  800c63:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c69:	c9                   	leave  
  800c6a:	c3                   	ret    

00800c6b <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c6b:	55                   	push   %ebp
  800c6c:	89 e5                	mov    %esp,%ebp
  800c6e:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c71:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c78:	eb 06                	jmp    800c80 <strlen+0x15>
		n++;
  800c7a:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c7d:	ff 45 08             	incl   0x8(%ebp)
  800c80:	8b 45 08             	mov    0x8(%ebp),%eax
  800c83:	8a 00                	mov    (%eax),%al
  800c85:	84 c0                	test   %al,%al
  800c87:	75 f1                	jne    800c7a <strlen+0xf>
		n++;
	return n;
  800c89:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c8c:	c9                   	leave  
  800c8d:	c3                   	ret    

00800c8e <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c8e:	55                   	push   %ebp
  800c8f:	89 e5                	mov    %esp,%ebp
  800c91:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c94:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c9b:	eb 09                	jmp    800ca6 <strnlen+0x18>
		n++;
  800c9d:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800ca0:	ff 45 08             	incl   0x8(%ebp)
  800ca3:	ff 4d 0c             	decl   0xc(%ebp)
  800ca6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800caa:	74 09                	je     800cb5 <strnlen+0x27>
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	84 c0                	test   %al,%al
  800cb3:	75 e8                	jne    800c9d <strnlen+0xf>
		n++;
	return n;
  800cb5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cb8:	c9                   	leave  
  800cb9:	c3                   	ret    

00800cba <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cba:	55                   	push   %ebp
  800cbb:	89 e5                	mov    %esp,%ebp
  800cbd:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cc6:	90                   	nop
  800cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cca:	8d 50 01             	lea    0x1(%eax),%edx
  800ccd:	89 55 08             	mov    %edx,0x8(%ebp)
  800cd0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cd3:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cd6:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cd9:	8a 12                	mov    (%edx),%dl
  800cdb:	88 10                	mov    %dl,(%eax)
  800cdd:	8a 00                	mov    (%eax),%al
  800cdf:	84 c0                	test   %al,%al
  800ce1:	75 e4                	jne    800cc7 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ce3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ce6:	c9                   	leave  
  800ce7:	c3                   	ret    

00800ce8 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
  800ceb:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800cf4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cfb:	eb 1f                	jmp    800d1c <strncpy+0x34>
		*dst++ = *src;
  800cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800d00:	8d 50 01             	lea    0x1(%eax),%edx
  800d03:	89 55 08             	mov    %edx,0x8(%ebp)
  800d06:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d09:	8a 12                	mov    (%edx),%dl
  800d0b:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d0d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d10:	8a 00                	mov    (%eax),%al
  800d12:	84 c0                	test   %al,%al
  800d14:	74 03                	je     800d19 <strncpy+0x31>
			src++;
  800d16:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d19:	ff 45 fc             	incl   -0x4(%ebp)
  800d1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d1f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d22:	72 d9                	jb     800cfd <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d24:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d27:	c9                   	leave  
  800d28:	c3                   	ret    

00800d29 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d29:	55                   	push   %ebp
  800d2a:	89 e5                	mov    %esp,%ebp
  800d2c:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d35:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d39:	74 30                	je     800d6b <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d3b:	eb 16                	jmp    800d53 <strlcpy+0x2a>
			*dst++ = *src++;
  800d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d40:	8d 50 01             	lea    0x1(%eax),%edx
  800d43:	89 55 08             	mov    %edx,0x8(%ebp)
  800d46:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d49:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d4c:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d4f:	8a 12                	mov    (%edx),%dl
  800d51:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d53:	ff 4d 10             	decl   0x10(%ebp)
  800d56:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d5a:	74 09                	je     800d65 <strlcpy+0x3c>
  800d5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5f:	8a 00                	mov    (%eax),%al
  800d61:	84 c0                	test   %al,%al
  800d63:	75 d8                	jne    800d3d <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d6e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d71:	29 c2                	sub    %eax,%edx
  800d73:	89 d0                	mov    %edx,%eax
}
  800d75:	c9                   	leave  
  800d76:	c3                   	ret    

00800d77 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d77:	55                   	push   %ebp
  800d78:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d7a:	eb 06                	jmp    800d82 <strcmp+0xb>
		p++, q++;
  800d7c:	ff 45 08             	incl   0x8(%ebp)
  800d7f:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d82:	8b 45 08             	mov    0x8(%ebp),%eax
  800d85:	8a 00                	mov    (%eax),%al
  800d87:	84 c0                	test   %al,%al
  800d89:	74 0e                	je     800d99 <strcmp+0x22>
  800d8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8e:	8a 10                	mov    (%eax),%dl
  800d90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d93:	8a 00                	mov    (%eax),%al
  800d95:	38 c2                	cmp    %al,%dl
  800d97:	74 e3                	je     800d7c <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d99:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9c:	8a 00                	mov    (%eax),%al
  800d9e:	0f b6 d0             	movzbl %al,%edx
  800da1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da4:	8a 00                	mov    (%eax),%al
  800da6:	0f b6 c0             	movzbl %al,%eax
  800da9:	29 c2                	sub    %eax,%edx
  800dab:	89 d0                	mov    %edx,%eax
}
  800dad:	5d                   	pop    %ebp
  800dae:	c3                   	ret    

00800daf <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800daf:	55                   	push   %ebp
  800db0:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800db2:	eb 09                	jmp    800dbd <strncmp+0xe>
		n--, p++, q++;
  800db4:	ff 4d 10             	decl   0x10(%ebp)
  800db7:	ff 45 08             	incl   0x8(%ebp)
  800dba:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dbd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc1:	74 17                	je     800dda <strncmp+0x2b>
  800dc3:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc6:	8a 00                	mov    (%eax),%al
  800dc8:	84 c0                	test   %al,%al
  800dca:	74 0e                	je     800dda <strncmp+0x2b>
  800dcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dcf:	8a 10                	mov    (%eax),%dl
  800dd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd4:	8a 00                	mov    (%eax),%al
  800dd6:	38 c2                	cmp    %al,%dl
  800dd8:	74 da                	je     800db4 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dda:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dde:	75 07                	jne    800de7 <strncmp+0x38>
		return 0;
  800de0:	b8 00 00 00 00       	mov    $0x0,%eax
  800de5:	eb 14                	jmp    800dfb <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8a 00                	mov    (%eax),%al
  800dec:	0f b6 d0             	movzbl %al,%edx
  800def:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df2:	8a 00                	mov    (%eax),%al
  800df4:	0f b6 c0             	movzbl %al,%eax
  800df7:	29 c2                	sub    %eax,%edx
  800df9:	89 d0                	mov    %edx,%eax
}
  800dfb:	5d                   	pop    %ebp
  800dfc:	c3                   	ret    

00800dfd <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dfd:	55                   	push   %ebp
  800dfe:	89 e5                	mov    %esp,%ebp
  800e00:	83 ec 04             	sub    $0x4,%esp
  800e03:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e06:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e09:	eb 12                	jmp    800e1d <strchr+0x20>
		if (*s == c)
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	8a 00                	mov    (%eax),%al
  800e10:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e13:	75 05                	jne    800e1a <strchr+0x1d>
			return (char *) s;
  800e15:	8b 45 08             	mov    0x8(%ebp),%eax
  800e18:	eb 11                	jmp    800e2b <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e1a:	ff 45 08             	incl   0x8(%ebp)
  800e1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e20:	8a 00                	mov    (%eax),%al
  800e22:	84 c0                	test   %al,%al
  800e24:	75 e5                	jne    800e0b <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e26:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e2b:	c9                   	leave  
  800e2c:	c3                   	ret    

00800e2d <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e2d:	55                   	push   %ebp
  800e2e:	89 e5                	mov    %esp,%ebp
  800e30:	83 ec 04             	sub    $0x4,%esp
  800e33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e36:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e39:	eb 0d                	jmp    800e48 <strfind+0x1b>
		if (*s == c)
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	8a 00                	mov    (%eax),%al
  800e40:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e43:	74 0e                	je     800e53 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e45:	ff 45 08             	incl   0x8(%ebp)
  800e48:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4b:	8a 00                	mov    (%eax),%al
  800e4d:	84 c0                	test   %al,%al
  800e4f:	75 ea                	jne    800e3b <strfind+0xe>
  800e51:	eb 01                	jmp    800e54 <strfind+0x27>
		if (*s == c)
			break;
  800e53:	90                   	nop
	return (char *) s;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e57:	c9                   	leave  
  800e58:	c3                   	ret    

00800e59 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e59:	55                   	push   %ebp
  800e5a:	89 e5                	mov    %esp,%ebp
  800e5c:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e65:	8b 45 10             	mov    0x10(%ebp),%eax
  800e68:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e6b:	eb 0e                	jmp    800e7b <memset+0x22>
		*p++ = c;
  800e6d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e70:	8d 50 01             	lea    0x1(%eax),%edx
  800e73:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e76:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e79:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e7b:	ff 4d f8             	decl   -0x8(%ebp)
  800e7e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e82:	79 e9                	jns    800e6d <memset+0x14>
		*p++ = c;

	return v;
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e87:	c9                   	leave  
  800e88:	c3                   	ret    

00800e89 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e89:	55                   	push   %ebp
  800e8a:	89 e5                	mov    %esp,%ebp
  800e8c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e8f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e9b:	eb 16                	jmp    800eb3 <memcpy+0x2a>
		*d++ = *s++;
  800e9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea0:	8d 50 01             	lea    0x1(%eax),%edx
  800ea3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ea6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ea9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eac:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800eaf:	8a 12                	mov    (%edx),%dl
  800eb1:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800eb3:	8b 45 10             	mov    0x10(%ebp),%eax
  800eb6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eb9:	89 55 10             	mov    %edx,0x10(%ebp)
  800ebc:	85 c0                	test   %eax,%eax
  800ebe:	75 dd                	jne    800e9d <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ec0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ec3:	c9                   	leave  
  800ec4:	c3                   	ret    

00800ec5 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800ec5:	55                   	push   %ebp
  800ec6:	89 e5                	mov    %esp,%ebp
  800ec8:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ece:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ed7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eda:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edd:	73 50                	jae    800f2f <memmove+0x6a>
  800edf:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ee2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee5:	01 d0                	add    %edx,%eax
  800ee7:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800eea:	76 43                	jbe    800f2f <memmove+0x6a>
		s += n;
  800eec:	8b 45 10             	mov    0x10(%ebp),%eax
  800eef:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ef8:	eb 10                	jmp    800f0a <memmove+0x45>
			*--d = *--s;
  800efa:	ff 4d f8             	decl   -0x8(%ebp)
  800efd:	ff 4d fc             	decl   -0x4(%ebp)
  800f00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f03:	8a 10                	mov    (%eax),%dl
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f0a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f10:	89 55 10             	mov    %edx,0x10(%ebp)
  800f13:	85 c0                	test   %eax,%eax
  800f15:	75 e3                	jne    800efa <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f17:	eb 23                	jmp    800f3c <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f19:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f1c:	8d 50 01             	lea    0x1(%eax),%edx
  800f1f:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f22:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f25:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f28:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f2b:	8a 12                	mov    (%edx),%dl
  800f2d:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f32:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f35:	89 55 10             	mov    %edx,0x10(%ebp)
  800f38:	85 c0                	test   %eax,%eax
  800f3a:	75 dd                	jne    800f19 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f3c:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3f:	c9                   	leave  
  800f40:	c3                   	ret    

00800f41 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f41:	55                   	push   %ebp
  800f42:	89 e5                	mov    %esp,%ebp
  800f44:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f47:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f50:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f53:	eb 2a                	jmp    800f7f <memcmp+0x3e>
		if (*s1 != *s2)
  800f55:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f58:	8a 10                	mov    (%eax),%dl
  800f5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5d:	8a 00                	mov    (%eax),%al
  800f5f:	38 c2                	cmp    %al,%dl
  800f61:	74 16                	je     800f79 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f63:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f66:	8a 00                	mov    (%eax),%al
  800f68:	0f b6 d0             	movzbl %al,%edx
  800f6b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	0f b6 c0             	movzbl %al,%eax
  800f73:	29 c2                	sub    %eax,%edx
  800f75:	89 d0                	mov    %edx,%eax
  800f77:	eb 18                	jmp    800f91 <memcmp+0x50>
		s1++, s2++;
  800f79:	ff 45 fc             	incl   -0x4(%ebp)
  800f7c:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f82:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f85:	89 55 10             	mov    %edx,0x10(%ebp)
  800f88:	85 c0                	test   %eax,%eax
  800f8a:	75 c9                	jne    800f55 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f8c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f91:	c9                   	leave  
  800f92:	c3                   	ret    

00800f93 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f93:	55                   	push   %ebp
  800f94:	89 e5                	mov    %esp,%ebp
  800f96:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f99:	8b 55 08             	mov    0x8(%ebp),%edx
  800f9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9f:	01 d0                	add    %edx,%eax
  800fa1:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fa4:	eb 15                	jmp    800fbb <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa9:	8a 00                	mov    (%eax),%al
  800fab:	0f b6 d0             	movzbl %al,%edx
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	0f b6 c0             	movzbl %al,%eax
  800fb4:	39 c2                	cmp    %eax,%edx
  800fb6:	74 0d                	je     800fc5 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fb8:	ff 45 08             	incl   0x8(%ebp)
  800fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbe:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fc1:	72 e3                	jb     800fa6 <memfind+0x13>
  800fc3:	eb 01                	jmp    800fc6 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fc5:	90                   	nop
	return (void *) s;
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fc9:	c9                   	leave  
  800fca:	c3                   	ret    

00800fcb <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fcb:	55                   	push   %ebp
  800fcc:	89 e5                	mov    %esp,%ebp
  800fce:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fd1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fd8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fdf:	eb 03                	jmp    800fe4 <strtol+0x19>
		s++;
  800fe1:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	8a 00                	mov    (%eax),%al
  800fe9:	3c 20                	cmp    $0x20,%al
  800feb:	74 f4                	je     800fe1 <strtol+0x16>
  800fed:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff0:	8a 00                	mov    (%eax),%al
  800ff2:	3c 09                	cmp    $0x9,%al
  800ff4:	74 eb                	je     800fe1 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff9:	8a 00                	mov    (%eax),%al
  800ffb:	3c 2b                	cmp    $0x2b,%al
  800ffd:	75 05                	jne    801004 <strtol+0x39>
		s++;
  800fff:	ff 45 08             	incl   0x8(%ebp)
  801002:	eb 13                	jmp    801017 <strtol+0x4c>
	else if (*s == '-')
  801004:	8b 45 08             	mov    0x8(%ebp),%eax
  801007:	8a 00                	mov    (%eax),%al
  801009:	3c 2d                	cmp    $0x2d,%al
  80100b:	75 0a                	jne    801017 <strtol+0x4c>
		s++, neg = 1;
  80100d:	ff 45 08             	incl   0x8(%ebp)
  801010:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801017:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80101b:	74 06                	je     801023 <strtol+0x58>
  80101d:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801021:	75 20                	jne    801043 <strtol+0x78>
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	8a 00                	mov    (%eax),%al
  801028:	3c 30                	cmp    $0x30,%al
  80102a:	75 17                	jne    801043 <strtol+0x78>
  80102c:	8b 45 08             	mov    0x8(%ebp),%eax
  80102f:	40                   	inc    %eax
  801030:	8a 00                	mov    (%eax),%al
  801032:	3c 78                	cmp    $0x78,%al
  801034:	75 0d                	jne    801043 <strtol+0x78>
		s += 2, base = 16;
  801036:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80103a:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801041:	eb 28                	jmp    80106b <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801043:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801047:	75 15                	jne    80105e <strtol+0x93>
  801049:	8b 45 08             	mov    0x8(%ebp),%eax
  80104c:	8a 00                	mov    (%eax),%al
  80104e:	3c 30                	cmp    $0x30,%al
  801050:	75 0c                	jne    80105e <strtol+0x93>
		s++, base = 8;
  801052:	ff 45 08             	incl   0x8(%ebp)
  801055:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80105c:	eb 0d                	jmp    80106b <strtol+0xa0>
	else if (base == 0)
  80105e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801062:	75 07                	jne    80106b <strtol+0xa0>
		base = 10;
  801064:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	3c 2f                	cmp    $0x2f,%al
  801072:	7e 19                	jle    80108d <strtol+0xc2>
  801074:	8b 45 08             	mov    0x8(%ebp),%eax
  801077:	8a 00                	mov    (%eax),%al
  801079:	3c 39                	cmp    $0x39,%al
  80107b:	7f 10                	jg     80108d <strtol+0xc2>
			dig = *s - '0';
  80107d:	8b 45 08             	mov    0x8(%ebp),%eax
  801080:	8a 00                	mov    (%eax),%al
  801082:	0f be c0             	movsbl %al,%eax
  801085:	83 e8 30             	sub    $0x30,%eax
  801088:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80108b:	eb 42                	jmp    8010cf <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	8a 00                	mov    (%eax),%al
  801092:	3c 60                	cmp    $0x60,%al
  801094:	7e 19                	jle    8010af <strtol+0xe4>
  801096:	8b 45 08             	mov    0x8(%ebp),%eax
  801099:	8a 00                	mov    (%eax),%al
  80109b:	3c 7a                	cmp    $0x7a,%al
  80109d:	7f 10                	jg     8010af <strtol+0xe4>
			dig = *s - 'a' + 10;
  80109f:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a2:	8a 00                	mov    (%eax),%al
  8010a4:	0f be c0             	movsbl %al,%eax
  8010a7:	83 e8 57             	sub    $0x57,%eax
  8010aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010ad:	eb 20                	jmp    8010cf <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010af:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b2:	8a 00                	mov    (%eax),%al
  8010b4:	3c 40                	cmp    $0x40,%al
  8010b6:	7e 39                	jle    8010f1 <strtol+0x126>
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	3c 5a                	cmp    $0x5a,%al
  8010bf:	7f 30                	jg     8010f1 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	0f be c0             	movsbl %al,%eax
  8010c9:	83 e8 37             	sub    $0x37,%eax
  8010cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010d5:	7d 19                	jge    8010f0 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010d7:	ff 45 08             	incl   0x8(%ebp)
  8010da:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010dd:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010e1:	89 c2                	mov    %eax,%edx
  8010e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e6:	01 d0                	add    %edx,%eax
  8010e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010eb:	e9 7b ff ff ff       	jmp    80106b <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010f0:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010f5:	74 08                	je     8010ff <strtol+0x134>
		*endptr = (char *) s;
  8010f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010fa:	8b 55 08             	mov    0x8(%ebp),%edx
  8010fd:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010ff:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801103:	74 07                	je     80110c <strtol+0x141>
  801105:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801108:	f7 d8                	neg    %eax
  80110a:	eb 03                	jmp    80110f <strtol+0x144>
  80110c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <ltostr>:

void
ltostr(long value, char *str)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801117:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80111e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801125:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801129:	79 13                	jns    80113e <ltostr+0x2d>
	{
		neg = 1;
  80112b:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801138:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80113b:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80113e:	8b 45 08             	mov    0x8(%ebp),%eax
  801141:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801146:	99                   	cltd   
  801147:	f7 f9                	idiv   %ecx
  801149:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80114c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80114f:	8d 50 01             	lea    0x1(%eax),%edx
  801152:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801155:	89 c2                	mov    %eax,%edx
  801157:	8b 45 0c             	mov    0xc(%ebp),%eax
  80115a:	01 d0                	add    %edx,%eax
  80115c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80115f:	83 c2 30             	add    $0x30,%edx
  801162:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801164:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801167:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80116c:	f7 e9                	imul   %ecx
  80116e:	c1 fa 02             	sar    $0x2,%edx
  801171:	89 c8                	mov    %ecx,%eax
  801173:	c1 f8 1f             	sar    $0x1f,%eax
  801176:	29 c2                	sub    %eax,%edx
  801178:	89 d0                	mov    %edx,%eax
  80117a:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80117d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801180:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801185:	f7 e9                	imul   %ecx
  801187:	c1 fa 02             	sar    $0x2,%edx
  80118a:	89 c8                	mov    %ecx,%eax
  80118c:	c1 f8 1f             	sar    $0x1f,%eax
  80118f:	29 c2                	sub    %eax,%edx
  801191:	89 d0                	mov    %edx,%eax
  801193:	c1 e0 02             	shl    $0x2,%eax
  801196:	01 d0                	add    %edx,%eax
  801198:	01 c0                	add    %eax,%eax
  80119a:	29 c1                	sub    %eax,%ecx
  80119c:	89 ca                	mov    %ecx,%edx
  80119e:	85 d2                	test   %edx,%edx
  8011a0:	75 9c                	jne    80113e <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011a2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011a9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011ac:	48                   	dec    %eax
  8011ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011b0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b4:	74 3d                	je     8011f3 <ltostr+0xe2>
		start = 1 ;
  8011b6:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011bd:	eb 34                	jmp    8011f3 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c5:	01 d0                	add    %edx,%eax
  8011c7:	8a 00                	mov    (%eax),%al
  8011c9:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d2:	01 c2                	add    %eax,%edx
  8011d4:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011d7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011da:	01 c8                	add    %ecx,%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e6:	01 c2                	add    %eax,%edx
  8011e8:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011eb:	88 02                	mov    %al,(%edx)
		start++ ;
  8011ed:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011f0:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011f6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011f9:	7c c4                	jl     8011bf <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011fb:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801201:	01 d0                	add    %edx,%eax
  801203:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801206:	90                   	nop
  801207:	c9                   	leave  
  801208:	c3                   	ret    

00801209 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801209:	55                   	push   %ebp
  80120a:	89 e5                	mov    %esp,%ebp
  80120c:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80120f:	ff 75 08             	pushl  0x8(%ebp)
  801212:	e8 54 fa ff ff       	call   800c6b <strlen>
  801217:	83 c4 04             	add    $0x4,%esp
  80121a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80121d:	ff 75 0c             	pushl  0xc(%ebp)
  801220:	e8 46 fa ff ff       	call   800c6b <strlen>
  801225:	83 c4 04             	add    $0x4,%esp
  801228:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80122b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801232:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801239:	eb 17                	jmp    801252 <strcconcat+0x49>
		final[s] = str1[s] ;
  80123b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80123e:	8b 45 10             	mov    0x10(%ebp),%eax
  801241:	01 c2                	add    %eax,%edx
  801243:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801246:	8b 45 08             	mov    0x8(%ebp),%eax
  801249:	01 c8                	add    %ecx,%eax
  80124b:	8a 00                	mov    (%eax),%al
  80124d:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80124f:	ff 45 fc             	incl   -0x4(%ebp)
  801252:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801255:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801258:	7c e1                	jl     80123b <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80125a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801261:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801268:	eb 1f                	jmp    801289 <strcconcat+0x80>
		final[s++] = str2[i] ;
  80126a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80126d:	8d 50 01             	lea    0x1(%eax),%edx
  801270:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801273:	89 c2                	mov    %eax,%edx
  801275:	8b 45 10             	mov    0x10(%ebp),%eax
  801278:	01 c2                	add    %eax,%edx
  80127a:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80127d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801280:	01 c8                	add    %ecx,%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801286:	ff 45 f8             	incl   -0x8(%ebp)
  801289:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80128c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80128f:	7c d9                	jl     80126a <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801291:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801294:	8b 45 10             	mov    0x10(%ebp),%eax
  801297:	01 d0                	add    %edx,%eax
  801299:	c6 00 00             	movb   $0x0,(%eax)
}
  80129c:	90                   	nop
  80129d:	c9                   	leave  
  80129e:	c3                   	ret    

0080129f <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80129f:	55                   	push   %ebp
  8012a0:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8012a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012ab:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ae:	8b 00                	mov    (%eax),%eax
  8012b0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012b7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ba:	01 d0                	add    %edx,%eax
  8012bc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c2:	eb 0c                	jmp    8012d0 <strsplit+0x31>
			*string++ = 0;
  8012c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c7:	8d 50 01             	lea    0x1(%eax),%edx
  8012ca:	89 55 08             	mov    %edx,0x8(%ebp)
  8012cd:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8012d3:	8a 00                	mov    (%eax),%al
  8012d5:	84 c0                	test   %al,%al
  8012d7:	74 18                	je     8012f1 <strsplit+0x52>
  8012d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012dc:	8a 00                	mov    (%eax),%al
  8012de:	0f be c0             	movsbl %al,%eax
  8012e1:	50                   	push   %eax
  8012e2:	ff 75 0c             	pushl  0xc(%ebp)
  8012e5:	e8 13 fb ff ff       	call   800dfd <strchr>
  8012ea:	83 c4 08             	add    $0x8,%esp
  8012ed:	85 c0                	test   %eax,%eax
  8012ef:	75 d3                	jne    8012c4 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	8a 00                	mov    (%eax),%al
  8012f6:	84 c0                	test   %al,%al
  8012f8:	74 5a                	je     801354 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012fa:	8b 45 14             	mov    0x14(%ebp),%eax
  8012fd:	8b 00                	mov    (%eax),%eax
  8012ff:	83 f8 0f             	cmp    $0xf,%eax
  801302:	75 07                	jne    80130b <strsplit+0x6c>
		{
			return 0;
  801304:	b8 00 00 00 00       	mov    $0x0,%eax
  801309:	eb 66                	jmp    801371 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80130b:	8b 45 14             	mov    0x14(%ebp),%eax
  80130e:	8b 00                	mov    (%eax),%eax
  801310:	8d 48 01             	lea    0x1(%eax),%ecx
  801313:	8b 55 14             	mov    0x14(%ebp),%edx
  801316:	89 0a                	mov    %ecx,(%edx)
  801318:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	01 c2                	add    %eax,%edx
  801324:	8b 45 08             	mov    0x8(%ebp),%eax
  801327:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801329:	eb 03                	jmp    80132e <strsplit+0x8f>
			string++;
  80132b:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80132e:	8b 45 08             	mov    0x8(%ebp),%eax
  801331:	8a 00                	mov    (%eax),%al
  801333:	84 c0                	test   %al,%al
  801335:	74 8b                	je     8012c2 <strsplit+0x23>
  801337:	8b 45 08             	mov    0x8(%ebp),%eax
  80133a:	8a 00                	mov    (%eax),%al
  80133c:	0f be c0             	movsbl %al,%eax
  80133f:	50                   	push   %eax
  801340:	ff 75 0c             	pushl  0xc(%ebp)
  801343:	e8 b5 fa ff ff       	call   800dfd <strchr>
  801348:	83 c4 08             	add    $0x8,%esp
  80134b:	85 c0                	test   %eax,%eax
  80134d:	74 dc                	je     80132b <strsplit+0x8c>
			string++;
	}
  80134f:	e9 6e ff ff ff       	jmp    8012c2 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801354:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801355:	8b 45 14             	mov    0x14(%ebp),%eax
  801358:	8b 00                	mov    (%eax),%eax
  80135a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801361:	8b 45 10             	mov    0x10(%ebp),%eax
  801364:	01 d0                	add    %edx,%eax
  801366:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80136c:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801371:	c9                   	leave  
  801372:	c3                   	ret    

00801373 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801373:	55                   	push   %ebp
  801374:	89 e5                	mov    %esp,%ebp
  801376:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801379:	a1 04 40 80 00       	mov    0x804004,%eax
  80137e:	85 c0                	test   %eax,%eax
  801380:	74 1f                	je     8013a1 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801382:	e8 1d 00 00 00       	call   8013a4 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801387:	83 ec 0c             	sub    $0xc,%esp
  80138a:	68 d0 3a 80 00       	push   $0x803ad0
  80138f:	e8 55 f2 ff ff       	call   8005e9 <cprintf>
  801394:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801397:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80139e:	00 00 00 
	}
}
  8013a1:	90                   	nop
  8013a2:	c9                   	leave  
  8013a3:	c3                   	ret    

008013a4 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013a4:	55                   	push   %ebp
  8013a5:	89 e5                	mov    %esp,%ebp
  8013a7:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  8013aa:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013b1:	00 00 00 
  8013b4:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013bb:	00 00 00 
  8013be:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013c5:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8013c8:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013cf:	00 00 00 
  8013d2:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013d9:	00 00 00 
  8013dc:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013e3:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  8013e6:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  8013ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013f0:	c1 e8 0c             	shr    $0xc,%eax
  8013f3:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  8013f8:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8013ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801402:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801407:	2d 00 10 00 00       	sub    $0x1000,%eax
  80140c:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  801411:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801418:	a1 20 41 80 00       	mov    0x804120,%eax
  80141d:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801421:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801424:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80142b:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80142e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801431:	01 d0                	add    %edx,%eax
  801433:	48                   	dec    %eax
  801434:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801437:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80143a:	ba 00 00 00 00       	mov    $0x0,%edx
  80143f:	f7 75 e4             	divl   -0x1c(%ebp)
  801442:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801445:	29 d0                	sub    %edx,%eax
  801447:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  80144a:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801451:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801454:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801459:	2d 00 10 00 00       	sub    $0x1000,%eax
  80145e:	83 ec 04             	sub    $0x4,%esp
  801461:	6a 07                	push   $0x7
  801463:	ff 75 e8             	pushl  -0x18(%ebp)
  801466:	50                   	push   %eax
  801467:	e8 3d 06 00 00       	call   801aa9 <sys_allocate_chunk>
  80146c:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  80146f:	a1 20 41 80 00       	mov    0x804120,%eax
  801474:	83 ec 0c             	sub    $0xc,%esp
  801477:	50                   	push   %eax
  801478:	e8 b2 0c 00 00       	call   80212f <initialize_MemBlocksList>
  80147d:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801480:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801485:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801488:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80148c:	0f 84 f3 00 00 00    	je     801585 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801492:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801496:	75 14                	jne    8014ac <initialize_dyn_block_system+0x108>
  801498:	83 ec 04             	sub    $0x4,%esp
  80149b:	68 f5 3a 80 00       	push   $0x803af5
  8014a0:	6a 36                	push   $0x36
  8014a2:	68 13 3b 80 00       	push   $0x803b13
  8014a7:	e8 89 ee ff ff       	call   800335 <_panic>
  8014ac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014af:	8b 00                	mov    (%eax),%eax
  8014b1:	85 c0                	test   %eax,%eax
  8014b3:	74 10                	je     8014c5 <initialize_dyn_block_system+0x121>
  8014b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014b8:	8b 00                	mov    (%eax),%eax
  8014ba:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014bd:	8b 52 04             	mov    0x4(%edx),%edx
  8014c0:	89 50 04             	mov    %edx,0x4(%eax)
  8014c3:	eb 0b                	jmp    8014d0 <initialize_dyn_block_system+0x12c>
  8014c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014c8:	8b 40 04             	mov    0x4(%eax),%eax
  8014cb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014d3:	8b 40 04             	mov    0x4(%eax),%eax
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	74 0f                	je     8014e9 <initialize_dyn_block_system+0x145>
  8014da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014dd:	8b 40 04             	mov    0x4(%eax),%eax
  8014e0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014e3:	8b 12                	mov    (%edx),%edx
  8014e5:	89 10                	mov    %edx,(%eax)
  8014e7:	eb 0a                	jmp    8014f3 <initialize_dyn_block_system+0x14f>
  8014e9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014ec:	8b 00                	mov    (%eax),%eax
  8014ee:	a3 48 41 80 00       	mov    %eax,0x804148
  8014f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014f6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014fc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014ff:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801506:	a1 54 41 80 00       	mov    0x804154,%eax
  80150b:	48                   	dec    %eax
  80150c:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801511:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801514:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  80151b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80151e:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801525:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801529:	75 14                	jne    80153f <initialize_dyn_block_system+0x19b>
  80152b:	83 ec 04             	sub    $0x4,%esp
  80152e:	68 20 3b 80 00       	push   $0x803b20
  801533:	6a 3e                	push   $0x3e
  801535:	68 13 3b 80 00       	push   $0x803b13
  80153a:	e8 f6 ed ff ff       	call   800335 <_panic>
  80153f:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801545:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801548:	89 10                	mov    %edx,(%eax)
  80154a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80154d:	8b 00                	mov    (%eax),%eax
  80154f:	85 c0                	test   %eax,%eax
  801551:	74 0d                	je     801560 <initialize_dyn_block_system+0x1bc>
  801553:	a1 38 41 80 00       	mov    0x804138,%eax
  801558:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80155b:	89 50 04             	mov    %edx,0x4(%eax)
  80155e:	eb 08                	jmp    801568 <initialize_dyn_block_system+0x1c4>
  801560:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801563:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801568:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80156b:	a3 38 41 80 00       	mov    %eax,0x804138
  801570:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801573:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80157a:	a1 44 41 80 00       	mov    0x804144,%eax
  80157f:	40                   	inc    %eax
  801580:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  801585:	90                   	nop
  801586:	c9                   	leave  
  801587:	c3                   	ret    

00801588 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801588:	55                   	push   %ebp
  801589:	89 e5                	mov    %esp,%ebp
  80158b:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  80158e:	e8 e0 fd ff ff       	call   801373 <InitializeUHeap>
		if (size == 0) return NULL ;
  801593:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801597:	75 07                	jne    8015a0 <malloc+0x18>
  801599:	b8 00 00 00 00       	mov    $0x0,%eax
  80159e:	eb 7f                	jmp    80161f <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8015a0:	e8 d2 08 00 00       	call   801e77 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015a5:	85 c0                	test   %eax,%eax
  8015a7:	74 71                	je     80161a <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  8015a9:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015b0:	8b 55 08             	mov    0x8(%ebp),%edx
  8015b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015b6:	01 d0                	add    %edx,%eax
  8015b8:	48                   	dec    %eax
  8015b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bf:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c4:	f7 75 f4             	divl   -0xc(%ebp)
  8015c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ca:	29 d0                	sub    %edx,%eax
  8015cc:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  8015cf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  8015d6:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8015dd:	76 07                	jbe    8015e6 <malloc+0x5e>
					return NULL ;
  8015df:	b8 00 00 00 00       	mov    $0x0,%eax
  8015e4:	eb 39                	jmp    80161f <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  8015e6:	83 ec 0c             	sub    $0xc,%esp
  8015e9:	ff 75 08             	pushl  0x8(%ebp)
  8015ec:	e8 e6 0d 00 00       	call   8023d7 <alloc_block_FF>
  8015f1:	83 c4 10             	add    $0x10,%esp
  8015f4:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  8015f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015fb:	74 16                	je     801613 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  8015fd:	83 ec 0c             	sub    $0xc,%esp
  801600:	ff 75 ec             	pushl  -0x14(%ebp)
  801603:	e8 37 0c 00 00       	call   80223f <insert_sorted_allocList>
  801608:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  80160b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80160e:	8b 40 08             	mov    0x8(%eax),%eax
  801611:	eb 0c                	jmp    80161f <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801613:	b8 00 00 00 00       	mov    $0x0,%eax
  801618:	eb 05                	jmp    80161f <malloc+0x97>
				}
		}
	return 0;
  80161a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80161f:	c9                   	leave  
  801620:	c3                   	ret    

00801621 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801621:	55                   	push   %ebp
  801622:	89 e5                	mov    %esp,%ebp
  801624:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801627:	8b 45 08             	mov    0x8(%ebp),%eax
  80162a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  80162d:	83 ec 08             	sub    $0x8,%esp
  801630:	ff 75 f4             	pushl  -0xc(%ebp)
  801633:	68 40 40 80 00       	push   $0x804040
  801638:	e8 cf 0b 00 00       	call   80220c <find_block>
  80163d:	83 c4 10             	add    $0x10,%esp
  801640:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801643:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801646:	8b 40 0c             	mov    0xc(%eax),%eax
  801649:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  80164c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80164f:	8b 40 08             	mov    0x8(%eax),%eax
  801652:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801655:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801659:	0f 84 a1 00 00 00    	je     801700 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  80165f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801663:	75 17                	jne    80167c <free+0x5b>
  801665:	83 ec 04             	sub    $0x4,%esp
  801668:	68 f5 3a 80 00       	push   $0x803af5
  80166d:	68 80 00 00 00       	push   $0x80
  801672:	68 13 3b 80 00       	push   $0x803b13
  801677:	e8 b9 ec ff ff       	call   800335 <_panic>
  80167c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167f:	8b 00                	mov    (%eax),%eax
  801681:	85 c0                	test   %eax,%eax
  801683:	74 10                	je     801695 <free+0x74>
  801685:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801688:	8b 00                	mov    (%eax),%eax
  80168a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80168d:	8b 52 04             	mov    0x4(%edx),%edx
  801690:	89 50 04             	mov    %edx,0x4(%eax)
  801693:	eb 0b                	jmp    8016a0 <free+0x7f>
  801695:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801698:	8b 40 04             	mov    0x4(%eax),%eax
  80169b:	a3 44 40 80 00       	mov    %eax,0x804044
  8016a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016a3:	8b 40 04             	mov    0x4(%eax),%eax
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	74 0f                	je     8016b9 <free+0x98>
  8016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ad:	8b 40 04             	mov    0x4(%eax),%eax
  8016b0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016b3:	8b 12                	mov    (%edx),%edx
  8016b5:	89 10                	mov    %edx,(%eax)
  8016b7:	eb 0a                	jmp    8016c3 <free+0xa2>
  8016b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bc:	8b 00                	mov    (%eax),%eax
  8016be:	a3 40 40 80 00       	mov    %eax,0x804040
  8016c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016d6:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016db:	48                   	dec    %eax
  8016dc:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  8016e1:	83 ec 0c             	sub    $0xc,%esp
  8016e4:	ff 75 f0             	pushl  -0x10(%ebp)
  8016e7:	e8 29 12 00 00       	call   802915 <insert_sorted_with_merge_freeList>
  8016ec:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  8016ef:	83 ec 08             	sub    $0x8,%esp
  8016f2:	ff 75 ec             	pushl  -0x14(%ebp)
  8016f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8016f8:	e8 74 03 00 00       	call   801a71 <sys_free_user_mem>
  8016fd:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801700:	90                   	nop
  801701:	c9                   	leave  
  801702:	c3                   	ret    

00801703 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801703:	55                   	push   %ebp
  801704:	89 e5                	mov    %esp,%ebp
  801706:	83 ec 38             	sub    $0x38,%esp
  801709:	8b 45 10             	mov    0x10(%ebp),%eax
  80170c:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80170f:	e8 5f fc ff ff       	call   801373 <InitializeUHeap>
	if (size == 0) return NULL ;
  801714:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801718:	75 0a                	jne    801724 <smalloc+0x21>
  80171a:	b8 00 00 00 00       	mov    $0x0,%eax
  80171f:	e9 b2 00 00 00       	jmp    8017d6 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801724:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80172b:	76 0a                	jbe    801737 <smalloc+0x34>
		return NULL;
  80172d:	b8 00 00 00 00       	mov    $0x0,%eax
  801732:	e9 9f 00 00 00       	jmp    8017d6 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801737:	e8 3b 07 00 00       	call   801e77 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80173c:	85 c0                	test   %eax,%eax
  80173e:	0f 84 8d 00 00 00    	je     8017d1 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801744:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  80174b:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801752:	8b 55 0c             	mov    0xc(%ebp),%edx
  801755:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801758:	01 d0                	add    %edx,%eax
  80175a:	48                   	dec    %eax
  80175b:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80175e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801761:	ba 00 00 00 00       	mov    $0x0,%edx
  801766:	f7 75 f0             	divl   -0x10(%ebp)
  801769:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176c:	29 d0                	sub    %edx,%eax
  80176e:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801771:	83 ec 0c             	sub    $0xc,%esp
  801774:	ff 75 e8             	pushl  -0x18(%ebp)
  801777:	e8 5b 0c 00 00       	call   8023d7 <alloc_block_FF>
  80177c:	83 c4 10             	add    $0x10,%esp
  80177f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801782:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801786:	75 07                	jne    80178f <smalloc+0x8c>
			return NULL;
  801788:	b8 00 00 00 00       	mov    $0x0,%eax
  80178d:	eb 47                	jmp    8017d6 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  80178f:	83 ec 0c             	sub    $0xc,%esp
  801792:	ff 75 f4             	pushl  -0xc(%ebp)
  801795:	e8 a5 0a 00 00       	call   80223f <insert_sorted_allocList>
  80179a:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  80179d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017a0:	8b 40 08             	mov    0x8(%eax),%eax
  8017a3:	89 c2                	mov    %eax,%edx
  8017a5:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017a9:	52                   	push   %edx
  8017aa:	50                   	push   %eax
  8017ab:	ff 75 0c             	pushl  0xc(%ebp)
  8017ae:	ff 75 08             	pushl  0x8(%ebp)
  8017b1:	e8 46 04 00 00       	call   801bfc <sys_createSharedObject>
  8017b6:	83 c4 10             	add    $0x10,%esp
  8017b9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  8017bc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017c0:	78 08                	js     8017ca <smalloc+0xc7>
		return (void *)b->sva;
  8017c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017c5:	8b 40 08             	mov    0x8(%eax),%eax
  8017c8:	eb 0c                	jmp    8017d6 <smalloc+0xd3>
		}else{
		return NULL;
  8017ca:	b8 00 00 00 00       	mov    $0x0,%eax
  8017cf:	eb 05                	jmp    8017d6 <smalloc+0xd3>
			}

	}return NULL;
  8017d1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017d6:	c9                   	leave  
  8017d7:	c3                   	ret    

008017d8 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017d8:	55                   	push   %ebp
  8017d9:	89 e5                	mov    %esp,%ebp
  8017db:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017de:	e8 90 fb ff ff       	call   801373 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8017e3:	e8 8f 06 00 00       	call   801e77 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017e8:	85 c0                	test   %eax,%eax
  8017ea:	0f 84 ad 00 00 00    	je     80189d <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017f0:	83 ec 08             	sub    $0x8,%esp
  8017f3:	ff 75 0c             	pushl  0xc(%ebp)
  8017f6:	ff 75 08             	pushl  0x8(%ebp)
  8017f9:	e8 28 04 00 00       	call   801c26 <sys_getSizeOfSharedObject>
  8017fe:	83 c4 10             	add    $0x10,%esp
  801801:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801804:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801808:	79 0a                	jns    801814 <sget+0x3c>
    {
    	return NULL;
  80180a:	b8 00 00 00 00       	mov    $0x0,%eax
  80180f:	e9 8e 00 00 00       	jmp    8018a2 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801814:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  80181b:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801822:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801825:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801828:	01 d0                	add    %edx,%eax
  80182a:	48                   	dec    %eax
  80182b:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80182e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801831:	ba 00 00 00 00       	mov    $0x0,%edx
  801836:	f7 75 ec             	divl   -0x14(%ebp)
  801839:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80183c:	29 d0                	sub    %edx,%eax
  80183e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801841:	83 ec 0c             	sub    $0xc,%esp
  801844:	ff 75 e4             	pushl  -0x1c(%ebp)
  801847:	e8 8b 0b 00 00       	call   8023d7 <alloc_block_FF>
  80184c:	83 c4 10             	add    $0x10,%esp
  80184f:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801852:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801856:	75 07                	jne    80185f <sget+0x87>
				return NULL;
  801858:	b8 00 00 00 00       	mov    $0x0,%eax
  80185d:	eb 43                	jmp    8018a2 <sget+0xca>
			}
			insert_sorted_allocList(b);
  80185f:	83 ec 0c             	sub    $0xc,%esp
  801862:	ff 75 f0             	pushl  -0x10(%ebp)
  801865:	e8 d5 09 00 00       	call   80223f <insert_sorted_allocList>
  80186a:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  80186d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801870:	8b 40 08             	mov    0x8(%eax),%eax
  801873:	83 ec 04             	sub    $0x4,%esp
  801876:	50                   	push   %eax
  801877:	ff 75 0c             	pushl  0xc(%ebp)
  80187a:	ff 75 08             	pushl  0x8(%ebp)
  80187d:	e8 c1 03 00 00       	call   801c43 <sys_getSharedObject>
  801882:	83 c4 10             	add    $0x10,%esp
  801885:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801888:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80188c:	78 08                	js     801896 <sget+0xbe>
			return (void *)b->sva;
  80188e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801891:	8b 40 08             	mov    0x8(%eax),%eax
  801894:	eb 0c                	jmp    8018a2 <sget+0xca>
			}else{
			return NULL;
  801896:	b8 00 00 00 00       	mov    $0x0,%eax
  80189b:	eb 05                	jmp    8018a2 <sget+0xca>
			}
    }}return NULL;
  80189d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
  8018a7:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018aa:	e8 c4 fa ff ff       	call   801373 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018af:	83 ec 04             	sub    $0x4,%esp
  8018b2:	68 44 3b 80 00       	push   $0x803b44
  8018b7:	68 03 01 00 00       	push   $0x103
  8018bc:	68 13 3b 80 00       	push   $0x803b13
  8018c1:	e8 6f ea ff ff       	call   800335 <_panic>

008018c6 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018c6:	55                   	push   %ebp
  8018c7:	89 e5                	mov    %esp,%ebp
  8018c9:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018cc:	83 ec 04             	sub    $0x4,%esp
  8018cf:	68 6c 3b 80 00       	push   $0x803b6c
  8018d4:	68 17 01 00 00       	push   $0x117
  8018d9:	68 13 3b 80 00       	push   $0x803b13
  8018de:	e8 52 ea ff ff       	call   800335 <_panic>

008018e3 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018e3:	55                   	push   %ebp
  8018e4:	89 e5                	mov    %esp,%ebp
  8018e6:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018e9:	83 ec 04             	sub    $0x4,%esp
  8018ec:	68 90 3b 80 00       	push   $0x803b90
  8018f1:	68 22 01 00 00       	push   $0x122
  8018f6:	68 13 3b 80 00       	push   $0x803b13
  8018fb:	e8 35 ea ff ff       	call   800335 <_panic>

00801900 <shrink>:

}
void shrink(uint32 newSize)
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
  801903:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801906:	83 ec 04             	sub    $0x4,%esp
  801909:	68 90 3b 80 00       	push   $0x803b90
  80190e:	68 27 01 00 00       	push   $0x127
  801913:	68 13 3b 80 00       	push   $0x803b13
  801918:	e8 18 ea ff ff       	call   800335 <_panic>

0080191d <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80191d:	55                   	push   %ebp
  80191e:	89 e5                	mov    %esp,%ebp
  801920:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801923:	83 ec 04             	sub    $0x4,%esp
  801926:	68 90 3b 80 00       	push   $0x803b90
  80192b:	68 2c 01 00 00       	push   $0x12c
  801930:	68 13 3b 80 00       	push   $0x803b13
  801935:	e8 fb e9 ff ff       	call   800335 <_panic>

0080193a <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80193a:	55                   	push   %ebp
  80193b:	89 e5                	mov    %esp,%ebp
  80193d:	57                   	push   %edi
  80193e:	56                   	push   %esi
  80193f:	53                   	push   %ebx
  801940:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801943:	8b 45 08             	mov    0x8(%ebp),%eax
  801946:	8b 55 0c             	mov    0xc(%ebp),%edx
  801949:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80194c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80194f:	8b 7d 18             	mov    0x18(%ebp),%edi
  801952:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801955:	cd 30                	int    $0x30
  801957:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80195a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80195d:	83 c4 10             	add    $0x10,%esp
  801960:	5b                   	pop    %ebx
  801961:	5e                   	pop    %esi
  801962:	5f                   	pop    %edi
  801963:	5d                   	pop    %ebp
  801964:	c3                   	ret    

00801965 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801965:	55                   	push   %ebp
  801966:	89 e5                	mov    %esp,%ebp
  801968:	83 ec 04             	sub    $0x4,%esp
  80196b:	8b 45 10             	mov    0x10(%ebp),%eax
  80196e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801971:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801975:	8b 45 08             	mov    0x8(%ebp),%eax
  801978:	6a 00                	push   $0x0
  80197a:	6a 00                	push   $0x0
  80197c:	52                   	push   %edx
  80197d:	ff 75 0c             	pushl  0xc(%ebp)
  801980:	50                   	push   %eax
  801981:	6a 00                	push   $0x0
  801983:	e8 b2 ff ff ff       	call   80193a <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	90                   	nop
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_cgetc>:

int
sys_cgetc(void)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801991:	6a 00                	push   $0x0
  801993:	6a 00                	push   $0x0
  801995:	6a 00                	push   $0x0
  801997:	6a 00                	push   $0x0
  801999:	6a 00                	push   $0x0
  80199b:	6a 01                	push   $0x1
  80199d:	e8 98 ff ff ff       	call   80193a <syscall>
  8019a2:	83 c4 18             	add    $0x18,%esp
}
  8019a5:	c9                   	leave  
  8019a6:	c3                   	ret    

008019a7 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019a7:	55                   	push   %ebp
  8019a8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019aa:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b0:	6a 00                	push   $0x0
  8019b2:	6a 00                	push   $0x0
  8019b4:	6a 00                	push   $0x0
  8019b6:	52                   	push   %edx
  8019b7:	50                   	push   %eax
  8019b8:	6a 05                	push   $0x5
  8019ba:	e8 7b ff ff ff       	call   80193a <syscall>
  8019bf:	83 c4 18             	add    $0x18,%esp
}
  8019c2:	c9                   	leave  
  8019c3:	c3                   	ret    

008019c4 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019c4:	55                   	push   %ebp
  8019c5:	89 e5                	mov    %esp,%ebp
  8019c7:	56                   	push   %esi
  8019c8:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019c9:	8b 75 18             	mov    0x18(%ebp),%esi
  8019cc:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019cf:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019d2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d8:	56                   	push   %esi
  8019d9:	53                   	push   %ebx
  8019da:	51                   	push   %ecx
  8019db:	52                   	push   %edx
  8019dc:	50                   	push   %eax
  8019dd:	6a 06                	push   $0x6
  8019df:	e8 56 ff ff ff       	call   80193a <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
}
  8019e7:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019ea:	5b                   	pop    %ebx
  8019eb:	5e                   	pop    %esi
  8019ec:	5d                   	pop    %ebp
  8019ed:	c3                   	ret    

008019ee <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019ee:	55                   	push   %ebp
  8019ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019f7:	6a 00                	push   $0x0
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	52                   	push   %edx
  8019fe:	50                   	push   %eax
  8019ff:	6a 07                	push   $0x7
  801a01:	e8 34 ff ff ff       	call   80193a <syscall>
  801a06:	83 c4 18             	add    $0x18,%esp
}
  801a09:	c9                   	leave  
  801a0a:	c3                   	ret    

00801a0b <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a0b:	55                   	push   %ebp
  801a0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a0e:	6a 00                	push   $0x0
  801a10:	6a 00                	push   $0x0
  801a12:	6a 00                	push   $0x0
  801a14:	ff 75 0c             	pushl  0xc(%ebp)
  801a17:	ff 75 08             	pushl  0x8(%ebp)
  801a1a:	6a 08                	push   $0x8
  801a1c:	e8 19 ff ff ff       	call   80193a <syscall>
  801a21:	83 c4 18             	add    $0x18,%esp
}
  801a24:	c9                   	leave  
  801a25:	c3                   	ret    

00801a26 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a26:	55                   	push   %ebp
  801a27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a29:	6a 00                	push   $0x0
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	6a 09                	push   $0x9
  801a35:	e8 00 ff ff ff       	call   80193a <syscall>
  801a3a:	83 c4 18             	add    $0x18,%esp
}
  801a3d:	c9                   	leave  
  801a3e:	c3                   	ret    

00801a3f <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a3f:	55                   	push   %ebp
  801a40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a42:	6a 00                	push   $0x0
  801a44:	6a 00                	push   $0x0
  801a46:	6a 00                	push   $0x0
  801a48:	6a 00                	push   $0x0
  801a4a:	6a 00                	push   $0x0
  801a4c:	6a 0a                	push   $0xa
  801a4e:	e8 e7 fe ff ff       	call   80193a <syscall>
  801a53:	83 c4 18             	add    $0x18,%esp
}
  801a56:	c9                   	leave  
  801a57:	c3                   	ret    

00801a58 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a58:	55                   	push   %ebp
  801a59:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a5b:	6a 00                	push   $0x0
  801a5d:	6a 00                	push   $0x0
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	6a 0b                	push   $0xb
  801a67:	e8 ce fe ff ff       	call   80193a <syscall>
  801a6c:	83 c4 18             	add    $0x18,%esp
}
  801a6f:	c9                   	leave  
  801a70:	c3                   	ret    

00801a71 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a71:	55                   	push   %ebp
  801a72:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	ff 75 0c             	pushl  0xc(%ebp)
  801a7d:	ff 75 08             	pushl  0x8(%ebp)
  801a80:	6a 0f                	push   $0xf
  801a82:	e8 b3 fe ff ff       	call   80193a <syscall>
  801a87:	83 c4 18             	add    $0x18,%esp
	return;
  801a8a:	90                   	nop
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	ff 75 0c             	pushl  0xc(%ebp)
  801a99:	ff 75 08             	pushl  0x8(%ebp)
  801a9c:	6a 10                	push   $0x10
  801a9e:	e8 97 fe ff ff       	call   80193a <syscall>
  801aa3:	83 c4 18             	add    $0x18,%esp
	return ;
  801aa6:	90                   	nop
}
  801aa7:	c9                   	leave  
  801aa8:	c3                   	ret    

00801aa9 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801aa9:	55                   	push   %ebp
  801aaa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	ff 75 10             	pushl  0x10(%ebp)
  801ab3:	ff 75 0c             	pushl  0xc(%ebp)
  801ab6:	ff 75 08             	pushl  0x8(%ebp)
  801ab9:	6a 11                	push   $0x11
  801abb:	e8 7a fe ff ff       	call   80193a <syscall>
  801ac0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ac3:	90                   	nop
}
  801ac4:	c9                   	leave  
  801ac5:	c3                   	ret    

00801ac6 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ac6:	55                   	push   %ebp
  801ac7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 0c                	push   $0xc
  801ad5:	e8 60 fe ff ff       	call   80193a <syscall>
  801ada:	83 c4 18             	add    $0x18,%esp
}
  801add:	c9                   	leave  
  801ade:	c3                   	ret    

00801adf <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801adf:	55                   	push   %ebp
  801ae0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ae2:	6a 00                	push   $0x0
  801ae4:	6a 00                	push   $0x0
  801ae6:	6a 00                	push   $0x0
  801ae8:	6a 00                	push   $0x0
  801aea:	ff 75 08             	pushl  0x8(%ebp)
  801aed:	6a 0d                	push   $0xd
  801aef:	e8 46 fe ff ff       	call   80193a <syscall>
  801af4:	83 c4 18             	add    $0x18,%esp
}
  801af7:	c9                   	leave  
  801af8:	c3                   	ret    

00801af9 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801af9:	55                   	push   %ebp
  801afa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 0e                	push   $0xe
  801b08:	e8 2d fe ff ff       	call   80193a <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
}
  801b10:	90                   	nop
  801b11:	c9                   	leave  
  801b12:	c3                   	ret    

00801b13 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b13:	55                   	push   %ebp
  801b14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 00                	push   $0x0
  801b1c:	6a 00                	push   $0x0
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 13                	push   $0x13
  801b22:	e8 13 fe ff ff       	call   80193a <syscall>
  801b27:	83 c4 18             	add    $0x18,%esp
}
  801b2a:	90                   	nop
  801b2b:	c9                   	leave  
  801b2c:	c3                   	ret    

00801b2d <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b2d:	55                   	push   %ebp
  801b2e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b30:	6a 00                	push   $0x0
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 14                	push   $0x14
  801b3c:	e8 f9 fd ff ff       	call   80193a <syscall>
  801b41:	83 c4 18             	add    $0x18,%esp
}
  801b44:	90                   	nop
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
  801b4a:	83 ec 04             	sub    $0x4,%esp
  801b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b50:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b53:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b57:	6a 00                	push   $0x0
  801b59:	6a 00                	push   $0x0
  801b5b:	6a 00                	push   $0x0
  801b5d:	6a 00                	push   $0x0
  801b5f:	50                   	push   %eax
  801b60:	6a 15                	push   $0x15
  801b62:	e8 d3 fd ff ff       	call   80193a <syscall>
  801b67:	83 c4 18             	add    $0x18,%esp
}
  801b6a:	90                   	nop
  801b6b:	c9                   	leave  
  801b6c:	c3                   	ret    

00801b6d <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b6d:	55                   	push   %ebp
  801b6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	6a 00                	push   $0x0
  801b78:	6a 00                	push   $0x0
  801b7a:	6a 16                	push   $0x16
  801b7c:	e8 b9 fd ff ff       	call   80193a <syscall>
  801b81:	83 c4 18             	add    $0x18,%esp
}
  801b84:	90                   	nop
  801b85:	c9                   	leave  
  801b86:	c3                   	ret    

00801b87 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b87:	55                   	push   %ebp
  801b88:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8d:	6a 00                	push   $0x0
  801b8f:	6a 00                	push   $0x0
  801b91:	6a 00                	push   $0x0
  801b93:	ff 75 0c             	pushl  0xc(%ebp)
  801b96:	50                   	push   %eax
  801b97:	6a 17                	push   $0x17
  801b99:	e8 9c fd ff ff       	call   80193a <syscall>
  801b9e:	83 c4 18             	add    $0x18,%esp
}
  801ba1:	c9                   	leave  
  801ba2:	c3                   	ret    

00801ba3 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801ba3:	55                   	push   %ebp
  801ba4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801ba6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	52                   	push   %edx
  801bb3:	50                   	push   %eax
  801bb4:	6a 1a                	push   $0x1a
  801bb6:	e8 7f fd ff ff       	call   80193a <syscall>
  801bbb:	83 c4 18             	add    $0x18,%esp
}
  801bbe:	c9                   	leave  
  801bbf:	c3                   	ret    

00801bc0 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bc0:	55                   	push   %ebp
  801bc1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bc3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	52                   	push   %edx
  801bd0:	50                   	push   %eax
  801bd1:	6a 18                	push   $0x18
  801bd3:	e8 62 fd ff ff       	call   80193a <syscall>
  801bd8:	83 c4 18             	add    $0x18,%esp
}
  801bdb:	90                   	nop
  801bdc:	c9                   	leave  
  801bdd:	c3                   	ret    

00801bde <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bde:	55                   	push   %ebp
  801bdf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801be1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801be4:	8b 45 08             	mov    0x8(%ebp),%eax
  801be7:	6a 00                	push   $0x0
  801be9:	6a 00                	push   $0x0
  801beb:	6a 00                	push   $0x0
  801bed:	52                   	push   %edx
  801bee:	50                   	push   %eax
  801bef:	6a 19                	push   $0x19
  801bf1:	e8 44 fd ff ff       	call   80193a <syscall>
  801bf6:	83 c4 18             	add    $0x18,%esp
}
  801bf9:	90                   	nop
  801bfa:	c9                   	leave  
  801bfb:	c3                   	ret    

00801bfc <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bfc:	55                   	push   %ebp
  801bfd:	89 e5                	mov    %esp,%ebp
  801bff:	83 ec 04             	sub    $0x4,%esp
  801c02:	8b 45 10             	mov    0x10(%ebp),%eax
  801c05:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c08:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c0b:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c0f:	8b 45 08             	mov    0x8(%ebp),%eax
  801c12:	6a 00                	push   $0x0
  801c14:	51                   	push   %ecx
  801c15:	52                   	push   %edx
  801c16:	ff 75 0c             	pushl  0xc(%ebp)
  801c19:	50                   	push   %eax
  801c1a:	6a 1b                	push   $0x1b
  801c1c:	e8 19 fd ff ff       	call   80193a <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
}
  801c24:	c9                   	leave  
  801c25:	c3                   	ret    

00801c26 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c26:	55                   	push   %ebp
  801c27:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c29:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c2f:	6a 00                	push   $0x0
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	52                   	push   %edx
  801c36:	50                   	push   %eax
  801c37:	6a 1c                	push   $0x1c
  801c39:	e8 fc fc ff ff       	call   80193a <syscall>
  801c3e:	83 c4 18             	add    $0x18,%esp
}
  801c41:	c9                   	leave  
  801c42:	c3                   	ret    

00801c43 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c43:	55                   	push   %ebp
  801c44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c46:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	51                   	push   %ecx
  801c54:	52                   	push   %edx
  801c55:	50                   	push   %eax
  801c56:	6a 1d                	push   $0x1d
  801c58:	e8 dd fc ff ff       	call   80193a <syscall>
  801c5d:	83 c4 18             	add    $0x18,%esp
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c65:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c68:	8b 45 08             	mov    0x8(%ebp),%eax
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 00                	push   $0x0
  801c71:	52                   	push   %edx
  801c72:	50                   	push   %eax
  801c73:	6a 1e                	push   $0x1e
  801c75:	e8 c0 fc ff ff       	call   80193a <syscall>
  801c7a:	83 c4 18             	add    $0x18,%esp
}
  801c7d:	c9                   	leave  
  801c7e:	c3                   	ret    

00801c7f <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c7f:	55                   	push   %ebp
  801c80:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 1f                	push   $0x1f
  801c8e:	e8 a7 fc ff ff       	call   80193a <syscall>
  801c93:	83 c4 18             	add    $0x18,%esp
}
  801c96:	c9                   	leave  
  801c97:	c3                   	ret    

00801c98 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c98:	55                   	push   %ebp
  801c99:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c9b:	8b 45 08             	mov    0x8(%ebp),%eax
  801c9e:	6a 00                	push   $0x0
  801ca0:	ff 75 14             	pushl  0x14(%ebp)
  801ca3:	ff 75 10             	pushl  0x10(%ebp)
  801ca6:	ff 75 0c             	pushl  0xc(%ebp)
  801ca9:	50                   	push   %eax
  801caa:	6a 20                	push   $0x20
  801cac:	e8 89 fc ff ff       	call   80193a <syscall>
  801cb1:	83 c4 18             	add    $0x18,%esp
}
  801cb4:	c9                   	leave  
  801cb5:	c3                   	ret    

00801cb6 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801cb6:	55                   	push   %ebp
  801cb7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 00                	push   $0x0
  801cc4:	50                   	push   %eax
  801cc5:	6a 21                	push   $0x21
  801cc7:	e8 6e fc ff ff       	call   80193a <syscall>
  801ccc:	83 c4 18             	add    $0x18,%esp
}
  801ccf:	90                   	nop
  801cd0:	c9                   	leave  
  801cd1:	c3                   	ret    

00801cd2 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cd2:	55                   	push   %ebp
  801cd3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 00                	push   $0x0
  801cde:	6a 00                	push   $0x0
  801ce0:	50                   	push   %eax
  801ce1:	6a 22                	push   $0x22
  801ce3:	e8 52 fc ff ff       	call   80193a <syscall>
  801ce8:	83 c4 18             	add    $0x18,%esp
}
  801ceb:	c9                   	leave  
  801cec:	c3                   	ret    

00801ced <sys_getenvid>:

int32 sys_getenvid(void)
{
  801ced:	55                   	push   %ebp
  801cee:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 00                	push   $0x0
  801cfa:	6a 02                	push   $0x2
  801cfc:	e8 39 fc ff ff       	call   80193a <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
}
  801d04:	c9                   	leave  
  801d05:	c3                   	ret    

00801d06 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d09:	6a 00                	push   $0x0
  801d0b:	6a 00                	push   $0x0
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 03                	push   $0x3
  801d15:	e8 20 fc ff ff       	call   80193a <syscall>
  801d1a:	83 c4 18             	add    $0x18,%esp
}
  801d1d:	c9                   	leave  
  801d1e:	c3                   	ret    

00801d1f <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d1f:	55                   	push   %ebp
  801d20:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d22:	6a 00                	push   $0x0
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	6a 04                	push   $0x4
  801d2e:	e8 07 fc ff ff       	call   80193a <syscall>
  801d33:	83 c4 18             	add    $0x18,%esp
}
  801d36:	c9                   	leave  
  801d37:	c3                   	ret    

00801d38 <sys_exit_env>:


void sys_exit_env(void)
{
  801d38:	55                   	push   %ebp
  801d39:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d3b:	6a 00                	push   $0x0
  801d3d:	6a 00                	push   $0x0
  801d3f:	6a 00                	push   $0x0
  801d41:	6a 00                	push   $0x0
  801d43:	6a 00                	push   $0x0
  801d45:	6a 23                	push   $0x23
  801d47:	e8 ee fb ff ff       	call   80193a <syscall>
  801d4c:	83 c4 18             	add    $0x18,%esp
}
  801d4f:	90                   	nop
  801d50:	c9                   	leave  
  801d51:	c3                   	ret    

00801d52 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d52:	55                   	push   %ebp
  801d53:	89 e5                	mov    %esp,%ebp
  801d55:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d58:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d5b:	8d 50 04             	lea    0x4(%eax),%edx
  801d5e:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	6a 00                	push   $0x0
  801d67:	52                   	push   %edx
  801d68:	50                   	push   %eax
  801d69:	6a 24                	push   $0x24
  801d6b:	e8 ca fb ff ff       	call   80193a <syscall>
  801d70:	83 c4 18             	add    $0x18,%esp
	return result;
  801d73:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d79:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d7c:	89 01                	mov    %eax,(%ecx)
  801d7e:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d81:	8b 45 08             	mov    0x8(%ebp),%eax
  801d84:	c9                   	leave  
  801d85:	c2 04 00             	ret    $0x4

00801d88 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d88:	55                   	push   %ebp
  801d89:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	ff 75 10             	pushl  0x10(%ebp)
  801d92:	ff 75 0c             	pushl  0xc(%ebp)
  801d95:	ff 75 08             	pushl  0x8(%ebp)
  801d98:	6a 12                	push   $0x12
  801d9a:	e8 9b fb ff ff       	call   80193a <syscall>
  801d9f:	83 c4 18             	add    $0x18,%esp
	return ;
  801da2:	90                   	nop
}
  801da3:	c9                   	leave  
  801da4:	c3                   	ret    

00801da5 <sys_rcr2>:
uint32 sys_rcr2()
{
  801da5:	55                   	push   %ebp
  801da6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801da8:	6a 00                	push   $0x0
  801daa:	6a 00                	push   $0x0
  801dac:	6a 00                	push   $0x0
  801dae:	6a 00                	push   $0x0
  801db0:	6a 00                	push   $0x0
  801db2:	6a 25                	push   $0x25
  801db4:	e8 81 fb ff ff       	call   80193a <syscall>
  801db9:	83 c4 18             	add    $0x18,%esp
}
  801dbc:	c9                   	leave  
  801dbd:	c3                   	ret    

00801dbe <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801dbe:	55                   	push   %ebp
  801dbf:	89 e5                	mov    %esp,%ebp
  801dc1:	83 ec 04             	sub    $0x4,%esp
  801dc4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc7:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dca:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dce:	6a 00                	push   $0x0
  801dd0:	6a 00                	push   $0x0
  801dd2:	6a 00                	push   $0x0
  801dd4:	6a 00                	push   $0x0
  801dd6:	50                   	push   %eax
  801dd7:	6a 26                	push   $0x26
  801dd9:	e8 5c fb ff ff       	call   80193a <syscall>
  801dde:	83 c4 18             	add    $0x18,%esp
	return ;
  801de1:	90                   	nop
}
  801de2:	c9                   	leave  
  801de3:	c3                   	ret    

00801de4 <rsttst>:
void rsttst()
{
  801de4:	55                   	push   %ebp
  801de5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801de7:	6a 00                	push   $0x0
  801de9:	6a 00                	push   $0x0
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	6a 00                	push   $0x0
  801df1:	6a 28                	push   $0x28
  801df3:	e8 42 fb ff ff       	call   80193a <syscall>
  801df8:	83 c4 18             	add    $0x18,%esp
	return ;
  801dfb:	90                   	nop
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
  801e01:	83 ec 04             	sub    $0x4,%esp
  801e04:	8b 45 14             	mov    0x14(%ebp),%eax
  801e07:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e0a:	8b 55 18             	mov    0x18(%ebp),%edx
  801e0d:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e11:	52                   	push   %edx
  801e12:	50                   	push   %eax
  801e13:	ff 75 10             	pushl  0x10(%ebp)
  801e16:	ff 75 0c             	pushl  0xc(%ebp)
  801e19:	ff 75 08             	pushl  0x8(%ebp)
  801e1c:	6a 27                	push   $0x27
  801e1e:	e8 17 fb ff ff       	call   80193a <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
	return ;
  801e26:	90                   	nop
}
  801e27:	c9                   	leave  
  801e28:	c3                   	ret    

00801e29 <chktst>:
void chktst(uint32 n)
{
  801e29:	55                   	push   %ebp
  801e2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e2c:	6a 00                	push   $0x0
  801e2e:	6a 00                	push   $0x0
  801e30:	6a 00                	push   $0x0
  801e32:	6a 00                	push   $0x0
  801e34:	ff 75 08             	pushl  0x8(%ebp)
  801e37:	6a 29                	push   $0x29
  801e39:	e8 fc fa ff ff       	call   80193a <syscall>
  801e3e:	83 c4 18             	add    $0x18,%esp
	return ;
  801e41:	90                   	nop
}
  801e42:	c9                   	leave  
  801e43:	c3                   	ret    

00801e44 <inctst>:

void inctst()
{
  801e44:	55                   	push   %ebp
  801e45:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e47:	6a 00                	push   $0x0
  801e49:	6a 00                	push   $0x0
  801e4b:	6a 00                	push   $0x0
  801e4d:	6a 00                	push   $0x0
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 2a                	push   $0x2a
  801e53:	e8 e2 fa ff ff       	call   80193a <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5b:	90                   	nop
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <gettst>:
uint32 gettst()
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	6a 00                	push   $0x0
  801e6b:	6a 2b                	push   $0x2b
  801e6d:	e8 c8 fa ff ff       	call   80193a <syscall>
  801e72:	83 c4 18             	add    $0x18,%esp
}
  801e75:	c9                   	leave  
  801e76:	c3                   	ret    

00801e77 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e77:	55                   	push   %ebp
  801e78:	89 e5                	mov    %esp,%ebp
  801e7a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e7d:	6a 00                	push   $0x0
  801e7f:	6a 00                	push   $0x0
  801e81:	6a 00                	push   $0x0
  801e83:	6a 00                	push   $0x0
  801e85:	6a 00                	push   $0x0
  801e87:	6a 2c                	push   $0x2c
  801e89:	e8 ac fa ff ff       	call   80193a <syscall>
  801e8e:	83 c4 18             	add    $0x18,%esp
  801e91:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e94:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e98:	75 07                	jne    801ea1 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e9a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e9f:	eb 05                	jmp    801ea6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ea1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ea6:	c9                   	leave  
  801ea7:	c3                   	ret    

00801ea8 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801ea8:	55                   	push   %ebp
  801ea9:	89 e5                	mov    %esp,%ebp
  801eab:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eae:	6a 00                	push   $0x0
  801eb0:	6a 00                	push   $0x0
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 2c                	push   $0x2c
  801eba:	e8 7b fa ff ff       	call   80193a <syscall>
  801ebf:	83 c4 18             	add    $0x18,%esp
  801ec2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ec5:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ec9:	75 07                	jne    801ed2 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ecb:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed0:	eb 05                	jmp    801ed7 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ed2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ed7:	c9                   	leave  
  801ed8:	c3                   	ret    

00801ed9 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ed9:	55                   	push   %ebp
  801eda:	89 e5                	mov    %esp,%ebp
  801edc:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 00                	push   $0x0
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 2c                	push   $0x2c
  801eeb:	e8 4a fa ff ff       	call   80193a <syscall>
  801ef0:	83 c4 18             	add    $0x18,%esp
  801ef3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ef6:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801efa:	75 07                	jne    801f03 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801efc:	b8 01 00 00 00       	mov    $0x1,%eax
  801f01:	eb 05                	jmp    801f08 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f08:	c9                   	leave  
  801f09:	c3                   	ret    

00801f0a <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f0a:	55                   	push   %ebp
  801f0b:	89 e5                	mov    %esp,%ebp
  801f0d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f10:	6a 00                	push   $0x0
  801f12:	6a 00                	push   $0x0
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 2c                	push   $0x2c
  801f1c:	e8 19 fa ff ff       	call   80193a <syscall>
  801f21:	83 c4 18             	add    $0x18,%esp
  801f24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f27:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f2b:	75 07                	jne    801f34 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801f32:	eb 05                	jmp    801f39 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f39:	c9                   	leave  
  801f3a:	c3                   	ret    

00801f3b <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f3b:	55                   	push   %ebp
  801f3c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f3e:	6a 00                	push   $0x0
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	ff 75 08             	pushl  0x8(%ebp)
  801f49:	6a 2d                	push   $0x2d
  801f4b:	e8 ea f9 ff ff       	call   80193a <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
	return ;
  801f53:	90                   	nop
}
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
  801f59:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f5a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f5d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f60:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f63:	8b 45 08             	mov    0x8(%ebp),%eax
  801f66:	6a 00                	push   $0x0
  801f68:	53                   	push   %ebx
  801f69:	51                   	push   %ecx
  801f6a:	52                   	push   %edx
  801f6b:	50                   	push   %eax
  801f6c:	6a 2e                	push   $0x2e
  801f6e:	e8 c7 f9 ff ff       	call   80193a <syscall>
  801f73:	83 c4 18             	add    $0x18,%esp
}
  801f76:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f79:	c9                   	leave  
  801f7a:	c3                   	ret    

00801f7b <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f7b:	55                   	push   %ebp
  801f7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f81:	8b 45 08             	mov    0x8(%ebp),%eax
  801f84:	6a 00                	push   $0x0
  801f86:	6a 00                	push   $0x0
  801f88:	6a 00                	push   $0x0
  801f8a:	52                   	push   %edx
  801f8b:	50                   	push   %eax
  801f8c:	6a 2f                	push   $0x2f
  801f8e:	e8 a7 f9 ff ff       	call   80193a <syscall>
  801f93:	83 c4 18             	add    $0x18,%esp
}
  801f96:	c9                   	leave  
  801f97:	c3                   	ret    

00801f98 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f98:	55                   	push   %ebp
  801f99:	89 e5                	mov    %esp,%ebp
  801f9b:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f9e:	83 ec 0c             	sub    $0xc,%esp
  801fa1:	68 a0 3b 80 00       	push   $0x803ba0
  801fa6:	e8 3e e6 ff ff       	call   8005e9 <cprintf>
  801fab:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fae:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fb5:	83 ec 0c             	sub    $0xc,%esp
  801fb8:	68 cc 3b 80 00       	push   $0x803bcc
  801fbd:	e8 27 e6 ff ff       	call   8005e9 <cprintf>
  801fc2:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fc5:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fc9:	a1 38 41 80 00       	mov    0x804138,%eax
  801fce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fd1:	eb 56                	jmp    802029 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fd3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fd7:	74 1c                	je     801ff5 <print_mem_block_lists+0x5d>
  801fd9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fdc:	8b 50 08             	mov    0x8(%eax),%edx
  801fdf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe2:	8b 48 08             	mov    0x8(%eax),%ecx
  801fe5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fe8:	8b 40 0c             	mov    0xc(%eax),%eax
  801feb:	01 c8                	add    %ecx,%eax
  801fed:	39 c2                	cmp    %eax,%edx
  801fef:	73 04                	jae    801ff5 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801ff1:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801ff5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff8:	8b 50 08             	mov    0x8(%eax),%edx
  801ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ffe:	8b 40 0c             	mov    0xc(%eax),%eax
  802001:	01 c2                	add    %eax,%edx
  802003:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802006:	8b 40 08             	mov    0x8(%eax),%eax
  802009:	83 ec 04             	sub    $0x4,%esp
  80200c:	52                   	push   %edx
  80200d:	50                   	push   %eax
  80200e:	68 e1 3b 80 00       	push   $0x803be1
  802013:	e8 d1 e5 ff ff       	call   8005e9 <cprintf>
  802018:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80201b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80201e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802021:	a1 40 41 80 00       	mov    0x804140,%eax
  802026:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802029:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80202d:	74 07                	je     802036 <print_mem_block_lists+0x9e>
  80202f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802032:	8b 00                	mov    (%eax),%eax
  802034:	eb 05                	jmp    80203b <print_mem_block_lists+0xa3>
  802036:	b8 00 00 00 00       	mov    $0x0,%eax
  80203b:	a3 40 41 80 00       	mov    %eax,0x804140
  802040:	a1 40 41 80 00       	mov    0x804140,%eax
  802045:	85 c0                	test   %eax,%eax
  802047:	75 8a                	jne    801fd3 <print_mem_block_lists+0x3b>
  802049:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80204d:	75 84                	jne    801fd3 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  80204f:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802053:	75 10                	jne    802065 <print_mem_block_lists+0xcd>
  802055:	83 ec 0c             	sub    $0xc,%esp
  802058:	68 f0 3b 80 00       	push   $0x803bf0
  80205d:	e8 87 e5 ff ff       	call   8005e9 <cprintf>
  802062:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802065:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80206c:	83 ec 0c             	sub    $0xc,%esp
  80206f:	68 14 3c 80 00       	push   $0x803c14
  802074:	e8 70 e5 ff ff       	call   8005e9 <cprintf>
  802079:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80207c:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802080:	a1 40 40 80 00       	mov    0x804040,%eax
  802085:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802088:	eb 56                	jmp    8020e0 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80208a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80208e:	74 1c                	je     8020ac <print_mem_block_lists+0x114>
  802090:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802093:	8b 50 08             	mov    0x8(%eax),%edx
  802096:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802099:	8b 48 08             	mov    0x8(%eax),%ecx
  80209c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80209f:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a2:	01 c8                	add    %ecx,%eax
  8020a4:	39 c2                	cmp    %eax,%edx
  8020a6:	73 04                	jae    8020ac <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020a8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020af:	8b 50 08             	mov    0x8(%eax),%edx
  8020b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020b5:	8b 40 0c             	mov    0xc(%eax),%eax
  8020b8:	01 c2                	add    %eax,%edx
  8020ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020bd:	8b 40 08             	mov    0x8(%eax),%eax
  8020c0:	83 ec 04             	sub    $0x4,%esp
  8020c3:	52                   	push   %edx
  8020c4:	50                   	push   %eax
  8020c5:	68 e1 3b 80 00       	push   $0x803be1
  8020ca:	e8 1a e5 ff ff       	call   8005e9 <cprintf>
  8020cf:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020d8:	a1 48 40 80 00       	mov    0x804048,%eax
  8020dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020e0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e4:	74 07                	je     8020ed <print_mem_block_lists+0x155>
  8020e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e9:	8b 00                	mov    (%eax),%eax
  8020eb:	eb 05                	jmp    8020f2 <print_mem_block_lists+0x15a>
  8020ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8020f2:	a3 48 40 80 00       	mov    %eax,0x804048
  8020f7:	a1 48 40 80 00       	mov    0x804048,%eax
  8020fc:	85 c0                	test   %eax,%eax
  8020fe:	75 8a                	jne    80208a <print_mem_block_lists+0xf2>
  802100:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802104:	75 84                	jne    80208a <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802106:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80210a:	75 10                	jne    80211c <print_mem_block_lists+0x184>
  80210c:	83 ec 0c             	sub    $0xc,%esp
  80210f:	68 2c 3c 80 00       	push   $0x803c2c
  802114:	e8 d0 e4 ff ff       	call   8005e9 <cprintf>
  802119:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80211c:	83 ec 0c             	sub    $0xc,%esp
  80211f:	68 a0 3b 80 00       	push   $0x803ba0
  802124:	e8 c0 e4 ff ff       	call   8005e9 <cprintf>
  802129:	83 c4 10             	add    $0x10,%esp

}
  80212c:	90                   	nop
  80212d:	c9                   	leave  
  80212e:	c3                   	ret    

0080212f <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80212f:	55                   	push   %ebp
  802130:	89 e5                	mov    %esp,%ebp
  802132:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802135:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80213c:	00 00 00 
  80213f:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802146:	00 00 00 
  802149:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802150:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802153:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80215a:	e9 9e 00 00 00       	jmp    8021fd <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  80215f:	a1 50 40 80 00       	mov    0x804050,%eax
  802164:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802167:	c1 e2 04             	shl    $0x4,%edx
  80216a:	01 d0                	add    %edx,%eax
  80216c:	85 c0                	test   %eax,%eax
  80216e:	75 14                	jne    802184 <initialize_MemBlocksList+0x55>
  802170:	83 ec 04             	sub    $0x4,%esp
  802173:	68 54 3c 80 00       	push   $0x803c54
  802178:	6a 3d                	push   $0x3d
  80217a:	68 77 3c 80 00       	push   $0x803c77
  80217f:	e8 b1 e1 ff ff       	call   800335 <_panic>
  802184:	a1 50 40 80 00       	mov    0x804050,%eax
  802189:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80218c:	c1 e2 04             	shl    $0x4,%edx
  80218f:	01 d0                	add    %edx,%eax
  802191:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802197:	89 10                	mov    %edx,(%eax)
  802199:	8b 00                	mov    (%eax),%eax
  80219b:	85 c0                	test   %eax,%eax
  80219d:	74 18                	je     8021b7 <initialize_MemBlocksList+0x88>
  80219f:	a1 48 41 80 00       	mov    0x804148,%eax
  8021a4:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8021aa:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021ad:	c1 e1 04             	shl    $0x4,%ecx
  8021b0:	01 ca                	add    %ecx,%edx
  8021b2:	89 50 04             	mov    %edx,0x4(%eax)
  8021b5:	eb 12                	jmp    8021c9 <initialize_MemBlocksList+0x9a>
  8021b7:	a1 50 40 80 00       	mov    0x804050,%eax
  8021bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021bf:	c1 e2 04             	shl    $0x4,%edx
  8021c2:	01 d0                	add    %edx,%eax
  8021c4:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021c9:	a1 50 40 80 00       	mov    0x804050,%eax
  8021ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d1:	c1 e2 04             	shl    $0x4,%edx
  8021d4:	01 d0                	add    %edx,%eax
  8021d6:	a3 48 41 80 00       	mov    %eax,0x804148
  8021db:	a1 50 40 80 00       	mov    0x804050,%eax
  8021e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021e3:	c1 e2 04             	shl    $0x4,%edx
  8021e6:	01 d0                	add    %edx,%eax
  8021e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021ef:	a1 54 41 80 00       	mov    0x804154,%eax
  8021f4:	40                   	inc    %eax
  8021f5:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8021fa:	ff 45 f4             	incl   -0xc(%ebp)
  8021fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802200:	3b 45 08             	cmp    0x8(%ebp),%eax
  802203:	0f 82 56 ff ff ff    	jb     80215f <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802209:	90                   	nop
  80220a:	c9                   	leave  
  80220b:	c3                   	ret    

0080220c <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80220c:	55                   	push   %ebp
  80220d:	89 e5                	mov    %esp,%ebp
  80220f:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802212:	8b 45 08             	mov    0x8(%ebp),%eax
  802215:	8b 00                	mov    (%eax),%eax
  802217:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80221a:	eb 18                	jmp    802234 <find_block+0x28>

		if(tmp->sva == va){
  80221c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80221f:	8b 40 08             	mov    0x8(%eax),%eax
  802222:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802225:	75 05                	jne    80222c <find_block+0x20>
			return tmp ;
  802227:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80222a:	eb 11                	jmp    80223d <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  80222c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80222f:	8b 00                	mov    (%eax),%eax
  802231:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802234:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802238:	75 e2                	jne    80221c <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  80223a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80223d:	c9                   	leave  
  80223e:	c3                   	ret    

0080223f <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  80223f:	55                   	push   %ebp
  802240:	89 e5                	mov    %esp,%ebp
  802242:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802245:	a1 40 40 80 00       	mov    0x804040,%eax
  80224a:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  80224d:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802252:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802255:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802259:	75 65                	jne    8022c0 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  80225b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80225f:	75 14                	jne    802275 <insert_sorted_allocList+0x36>
  802261:	83 ec 04             	sub    $0x4,%esp
  802264:	68 54 3c 80 00       	push   $0x803c54
  802269:	6a 62                	push   $0x62
  80226b:	68 77 3c 80 00       	push   $0x803c77
  802270:	e8 c0 e0 ff ff       	call   800335 <_panic>
  802275:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80227b:	8b 45 08             	mov    0x8(%ebp),%eax
  80227e:	89 10                	mov    %edx,(%eax)
  802280:	8b 45 08             	mov    0x8(%ebp),%eax
  802283:	8b 00                	mov    (%eax),%eax
  802285:	85 c0                	test   %eax,%eax
  802287:	74 0d                	je     802296 <insert_sorted_allocList+0x57>
  802289:	a1 40 40 80 00       	mov    0x804040,%eax
  80228e:	8b 55 08             	mov    0x8(%ebp),%edx
  802291:	89 50 04             	mov    %edx,0x4(%eax)
  802294:	eb 08                	jmp    80229e <insert_sorted_allocList+0x5f>
  802296:	8b 45 08             	mov    0x8(%ebp),%eax
  802299:	a3 44 40 80 00       	mov    %eax,0x804044
  80229e:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a1:	a3 40 40 80 00       	mov    %eax,0x804040
  8022a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022b0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022b5:	40                   	inc    %eax
  8022b6:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8022bb:	e9 14 01 00 00       	jmp    8023d4 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  8022c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022c3:	8b 50 08             	mov    0x8(%eax),%edx
  8022c6:	a1 44 40 80 00       	mov    0x804044,%eax
  8022cb:	8b 40 08             	mov    0x8(%eax),%eax
  8022ce:	39 c2                	cmp    %eax,%edx
  8022d0:	76 65                	jbe    802337 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  8022d2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022d6:	75 14                	jne    8022ec <insert_sorted_allocList+0xad>
  8022d8:	83 ec 04             	sub    $0x4,%esp
  8022db:	68 90 3c 80 00       	push   $0x803c90
  8022e0:	6a 64                	push   $0x64
  8022e2:	68 77 3c 80 00       	push   $0x803c77
  8022e7:	e8 49 e0 ff ff       	call   800335 <_panic>
  8022ec:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f5:	89 50 04             	mov    %edx,0x4(%eax)
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	8b 40 04             	mov    0x4(%eax),%eax
  8022fe:	85 c0                	test   %eax,%eax
  802300:	74 0c                	je     80230e <insert_sorted_allocList+0xcf>
  802302:	a1 44 40 80 00       	mov    0x804044,%eax
  802307:	8b 55 08             	mov    0x8(%ebp),%edx
  80230a:	89 10                	mov    %edx,(%eax)
  80230c:	eb 08                	jmp    802316 <insert_sorted_allocList+0xd7>
  80230e:	8b 45 08             	mov    0x8(%ebp),%eax
  802311:	a3 40 40 80 00       	mov    %eax,0x804040
  802316:	8b 45 08             	mov    0x8(%ebp),%eax
  802319:	a3 44 40 80 00       	mov    %eax,0x804044
  80231e:	8b 45 08             	mov    0x8(%ebp),%eax
  802321:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802327:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80232c:	40                   	inc    %eax
  80232d:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802332:	e9 9d 00 00 00       	jmp    8023d4 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802337:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80233e:	e9 85 00 00 00       	jmp    8023c8 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	8b 50 08             	mov    0x8(%eax),%edx
  802349:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80234c:	8b 40 08             	mov    0x8(%eax),%eax
  80234f:	39 c2                	cmp    %eax,%edx
  802351:	73 6a                	jae    8023bd <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802353:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802357:	74 06                	je     80235f <insert_sorted_allocList+0x120>
  802359:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80235d:	75 14                	jne    802373 <insert_sorted_allocList+0x134>
  80235f:	83 ec 04             	sub    $0x4,%esp
  802362:	68 b4 3c 80 00       	push   $0x803cb4
  802367:	6a 6b                	push   $0x6b
  802369:	68 77 3c 80 00       	push   $0x803c77
  80236e:	e8 c2 df ff ff       	call   800335 <_panic>
  802373:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802376:	8b 50 04             	mov    0x4(%eax),%edx
  802379:	8b 45 08             	mov    0x8(%ebp),%eax
  80237c:	89 50 04             	mov    %edx,0x4(%eax)
  80237f:	8b 45 08             	mov    0x8(%ebp),%eax
  802382:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802385:	89 10                	mov    %edx,(%eax)
  802387:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238a:	8b 40 04             	mov    0x4(%eax),%eax
  80238d:	85 c0                	test   %eax,%eax
  80238f:	74 0d                	je     80239e <insert_sorted_allocList+0x15f>
  802391:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802394:	8b 40 04             	mov    0x4(%eax),%eax
  802397:	8b 55 08             	mov    0x8(%ebp),%edx
  80239a:	89 10                	mov    %edx,(%eax)
  80239c:	eb 08                	jmp    8023a6 <insert_sorted_allocList+0x167>
  80239e:	8b 45 08             	mov    0x8(%ebp),%eax
  8023a1:	a3 40 40 80 00       	mov    %eax,0x804040
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	8b 55 08             	mov    0x8(%ebp),%edx
  8023ac:	89 50 04             	mov    %edx,0x4(%eax)
  8023af:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023b4:	40                   	inc    %eax
  8023b5:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  8023ba:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8023bb:	eb 17                	jmp    8023d4 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  8023bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c0:	8b 00                	mov    (%eax),%eax
  8023c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8023c5:	ff 45 f0             	incl   -0x10(%ebp)
  8023c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8023ce:	0f 8c 6f ff ff ff    	jl     802343 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8023d4:	90                   	nop
  8023d5:	c9                   	leave  
  8023d6:	c3                   	ret    

008023d7 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023d7:	55                   	push   %ebp
  8023d8:	89 e5                	mov    %esp,%ebp
  8023da:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  8023dd:	a1 38 41 80 00       	mov    0x804138,%eax
  8023e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  8023e5:	e9 7c 01 00 00       	jmp    802566 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  8023ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ed:	8b 40 0c             	mov    0xc(%eax),%eax
  8023f0:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023f3:	0f 86 cf 00 00 00    	jbe    8024c8 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8023f9:	a1 48 41 80 00       	mov    0x804148,%eax
  8023fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802401:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802404:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802407:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240a:	8b 55 08             	mov    0x8(%ebp),%edx
  80240d:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802410:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802413:	8b 50 08             	mov    0x8(%eax),%edx
  802416:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802419:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  80241c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241f:	8b 40 0c             	mov    0xc(%eax),%eax
  802422:	2b 45 08             	sub    0x8(%ebp),%eax
  802425:	89 c2                	mov    %eax,%edx
  802427:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242a:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  80242d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802430:	8b 50 08             	mov    0x8(%eax),%edx
  802433:	8b 45 08             	mov    0x8(%ebp),%eax
  802436:	01 c2                	add    %eax,%edx
  802438:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80243b:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80243e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802442:	75 17                	jne    80245b <alloc_block_FF+0x84>
  802444:	83 ec 04             	sub    $0x4,%esp
  802447:	68 e9 3c 80 00       	push   $0x803ce9
  80244c:	68 83 00 00 00       	push   $0x83
  802451:	68 77 3c 80 00       	push   $0x803c77
  802456:	e8 da de ff ff       	call   800335 <_panic>
  80245b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80245e:	8b 00                	mov    (%eax),%eax
  802460:	85 c0                	test   %eax,%eax
  802462:	74 10                	je     802474 <alloc_block_FF+0x9d>
  802464:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802467:	8b 00                	mov    (%eax),%eax
  802469:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80246c:	8b 52 04             	mov    0x4(%edx),%edx
  80246f:	89 50 04             	mov    %edx,0x4(%eax)
  802472:	eb 0b                	jmp    80247f <alloc_block_FF+0xa8>
  802474:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802477:	8b 40 04             	mov    0x4(%eax),%eax
  80247a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80247f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802482:	8b 40 04             	mov    0x4(%eax),%eax
  802485:	85 c0                	test   %eax,%eax
  802487:	74 0f                	je     802498 <alloc_block_FF+0xc1>
  802489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248c:	8b 40 04             	mov    0x4(%eax),%eax
  80248f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802492:	8b 12                	mov    (%edx),%edx
  802494:	89 10                	mov    %edx,(%eax)
  802496:	eb 0a                	jmp    8024a2 <alloc_block_FF+0xcb>
  802498:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249b:	8b 00                	mov    (%eax),%eax
  80249d:	a3 48 41 80 00       	mov    %eax,0x804148
  8024a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024b5:	a1 54 41 80 00       	mov    0x804154,%eax
  8024ba:	48                   	dec    %eax
  8024bb:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  8024c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c3:	e9 ad 00 00 00       	jmp    802575 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  8024c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024cb:	8b 40 0c             	mov    0xc(%eax),%eax
  8024ce:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024d1:	0f 85 87 00 00 00    	jne    80255e <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  8024d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024db:	75 17                	jne    8024f4 <alloc_block_FF+0x11d>
  8024dd:	83 ec 04             	sub    $0x4,%esp
  8024e0:	68 e9 3c 80 00       	push   $0x803ce9
  8024e5:	68 87 00 00 00       	push   $0x87
  8024ea:	68 77 3c 80 00       	push   $0x803c77
  8024ef:	e8 41 de ff ff       	call   800335 <_panic>
  8024f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f7:	8b 00                	mov    (%eax),%eax
  8024f9:	85 c0                	test   %eax,%eax
  8024fb:	74 10                	je     80250d <alloc_block_FF+0x136>
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 00                	mov    (%eax),%eax
  802502:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802505:	8b 52 04             	mov    0x4(%edx),%edx
  802508:	89 50 04             	mov    %edx,0x4(%eax)
  80250b:	eb 0b                	jmp    802518 <alloc_block_FF+0x141>
  80250d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802510:	8b 40 04             	mov    0x4(%eax),%eax
  802513:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251b:	8b 40 04             	mov    0x4(%eax),%eax
  80251e:	85 c0                	test   %eax,%eax
  802520:	74 0f                	je     802531 <alloc_block_FF+0x15a>
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	8b 40 04             	mov    0x4(%eax),%eax
  802528:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80252b:	8b 12                	mov    (%edx),%edx
  80252d:	89 10                	mov    %edx,(%eax)
  80252f:	eb 0a                	jmp    80253b <alloc_block_FF+0x164>
  802531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802534:	8b 00                	mov    (%eax),%eax
  802536:	a3 38 41 80 00       	mov    %eax,0x804138
  80253b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80253e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802544:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802547:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80254e:	a1 44 41 80 00       	mov    0x804144,%eax
  802553:	48                   	dec    %eax
  802554:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  802559:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255c:	eb 17                	jmp    802575 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 00                	mov    (%eax),%eax
  802563:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802566:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80256a:	0f 85 7a fe ff ff    	jne    8023ea <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802570:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802575:	c9                   	leave  
  802576:	c3                   	ret    

00802577 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802577:	55                   	push   %ebp
  802578:	89 e5                	mov    %esp,%ebp
  80257a:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  80257d:	a1 38 41 80 00       	mov    0x804138,%eax
  802582:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802585:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  80258c:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802593:	a1 38 41 80 00       	mov    0x804138,%eax
  802598:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80259b:	e9 d0 00 00 00       	jmp    802670 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025a9:	0f 82 b8 00 00 00    	jb     802667 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  8025af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8025b5:	2b 45 08             	sub    0x8(%ebp),%eax
  8025b8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  8025bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025be:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025c1:	0f 83 a1 00 00 00    	jae    802668 <alloc_block_BF+0xf1>
				differsize = differance ;
  8025c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  8025cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  8025d3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025d7:	0f 85 8b 00 00 00    	jne    802668 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  8025dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025e1:	75 17                	jne    8025fa <alloc_block_BF+0x83>
  8025e3:	83 ec 04             	sub    $0x4,%esp
  8025e6:	68 e9 3c 80 00       	push   $0x803ce9
  8025eb:	68 a0 00 00 00       	push   $0xa0
  8025f0:	68 77 3c 80 00       	push   $0x803c77
  8025f5:	e8 3b dd ff ff       	call   800335 <_panic>
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 00                	mov    (%eax),%eax
  8025ff:	85 c0                	test   %eax,%eax
  802601:	74 10                	je     802613 <alloc_block_BF+0x9c>
  802603:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802606:	8b 00                	mov    (%eax),%eax
  802608:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80260b:	8b 52 04             	mov    0x4(%edx),%edx
  80260e:	89 50 04             	mov    %edx,0x4(%eax)
  802611:	eb 0b                	jmp    80261e <alloc_block_BF+0xa7>
  802613:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802616:	8b 40 04             	mov    0x4(%eax),%eax
  802619:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80261e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802621:	8b 40 04             	mov    0x4(%eax),%eax
  802624:	85 c0                	test   %eax,%eax
  802626:	74 0f                	je     802637 <alloc_block_BF+0xc0>
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 40 04             	mov    0x4(%eax),%eax
  80262e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802631:	8b 12                	mov    (%edx),%edx
  802633:	89 10                	mov    %edx,(%eax)
  802635:	eb 0a                	jmp    802641 <alloc_block_BF+0xca>
  802637:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263a:	8b 00                	mov    (%eax),%eax
  80263c:	a3 38 41 80 00       	mov    %eax,0x804138
  802641:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802644:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80264a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802654:	a1 44 41 80 00       	mov    0x804144,%eax
  802659:	48                   	dec    %eax
  80265a:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  80265f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802662:	e9 0c 01 00 00       	jmp    802773 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802667:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802668:	a1 40 41 80 00       	mov    0x804140,%eax
  80266d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802670:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802674:	74 07                	je     80267d <alloc_block_BF+0x106>
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	8b 00                	mov    (%eax),%eax
  80267b:	eb 05                	jmp    802682 <alloc_block_BF+0x10b>
  80267d:	b8 00 00 00 00       	mov    $0x0,%eax
  802682:	a3 40 41 80 00       	mov    %eax,0x804140
  802687:	a1 40 41 80 00       	mov    0x804140,%eax
  80268c:	85 c0                	test   %eax,%eax
  80268e:	0f 85 0c ff ff ff    	jne    8025a0 <alloc_block_BF+0x29>
  802694:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802698:	0f 85 02 ff ff ff    	jne    8025a0 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  80269e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026a2:	0f 84 c6 00 00 00    	je     80276e <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  8026a8:	a1 48 41 80 00       	mov    0x804148,%eax
  8026ad:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  8026b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b3:	8b 55 08             	mov    0x8(%ebp),%edx
  8026b6:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  8026b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026bc:	8b 50 08             	mov    0x8(%eax),%edx
  8026bf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026c2:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  8026c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c8:	8b 40 0c             	mov    0xc(%eax),%eax
  8026cb:	2b 45 08             	sub    0x8(%ebp),%eax
  8026ce:	89 c2                	mov    %eax,%edx
  8026d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d3:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  8026d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d9:	8b 50 08             	mov    0x8(%eax),%edx
  8026dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8026df:	01 c2                	add    %eax,%edx
  8026e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026e4:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  8026e7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026eb:	75 17                	jne    802704 <alloc_block_BF+0x18d>
  8026ed:	83 ec 04             	sub    $0x4,%esp
  8026f0:	68 e9 3c 80 00       	push   $0x803ce9
  8026f5:	68 af 00 00 00       	push   $0xaf
  8026fa:	68 77 3c 80 00       	push   $0x803c77
  8026ff:	e8 31 dc ff ff       	call   800335 <_panic>
  802704:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802707:	8b 00                	mov    (%eax),%eax
  802709:	85 c0                	test   %eax,%eax
  80270b:	74 10                	je     80271d <alloc_block_BF+0x1a6>
  80270d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802710:	8b 00                	mov    (%eax),%eax
  802712:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802715:	8b 52 04             	mov    0x4(%edx),%edx
  802718:	89 50 04             	mov    %edx,0x4(%eax)
  80271b:	eb 0b                	jmp    802728 <alloc_block_BF+0x1b1>
  80271d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802720:	8b 40 04             	mov    0x4(%eax),%eax
  802723:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802728:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80272b:	8b 40 04             	mov    0x4(%eax),%eax
  80272e:	85 c0                	test   %eax,%eax
  802730:	74 0f                	je     802741 <alloc_block_BF+0x1ca>
  802732:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802735:	8b 40 04             	mov    0x4(%eax),%eax
  802738:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80273b:	8b 12                	mov    (%edx),%edx
  80273d:	89 10                	mov    %edx,(%eax)
  80273f:	eb 0a                	jmp    80274b <alloc_block_BF+0x1d4>
  802741:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802744:	8b 00                	mov    (%eax),%eax
  802746:	a3 48 41 80 00       	mov    %eax,0x804148
  80274b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80274e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802754:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802757:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275e:	a1 54 41 80 00       	mov    0x804154,%eax
  802763:	48                   	dec    %eax
  802764:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  802769:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276c:	eb 05                	jmp    802773 <alloc_block_BF+0x1fc>
	}

	return NULL;
  80276e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802773:	c9                   	leave  
  802774:	c3                   	ret    

00802775 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802775:	55                   	push   %ebp
  802776:	89 e5                	mov    %esp,%ebp
  802778:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  80277b:	a1 38 41 80 00       	mov    0x804138,%eax
  802780:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802783:	e9 7c 01 00 00       	jmp    802904 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802788:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278b:	8b 40 0c             	mov    0xc(%eax),%eax
  80278e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802791:	0f 86 cf 00 00 00    	jbe    802866 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802797:	a1 48 41 80 00       	mov    0x804148,%eax
  80279c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  80279f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  8027a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a8:	8b 55 08             	mov    0x8(%ebp),%edx
  8027ab:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  8027ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b1:	8b 50 08             	mov    0x8(%eax),%edx
  8027b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027b7:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  8027ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bd:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c0:	2b 45 08             	sub    0x8(%ebp),%eax
  8027c3:	89 c2                	mov    %eax,%edx
  8027c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c8:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  8027cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ce:	8b 50 08             	mov    0x8(%eax),%edx
  8027d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d4:	01 c2                	add    %eax,%edx
  8027d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d9:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8027dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027e0:	75 17                	jne    8027f9 <alloc_block_NF+0x84>
  8027e2:	83 ec 04             	sub    $0x4,%esp
  8027e5:	68 e9 3c 80 00       	push   $0x803ce9
  8027ea:	68 c4 00 00 00       	push   $0xc4
  8027ef:	68 77 3c 80 00       	push   $0x803c77
  8027f4:	e8 3c db ff ff       	call   800335 <_panic>
  8027f9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027fc:	8b 00                	mov    (%eax),%eax
  8027fe:	85 c0                	test   %eax,%eax
  802800:	74 10                	je     802812 <alloc_block_NF+0x9d>
  802802:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802805:	8b 00                	mov    (%eax),%eax
  802807:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80280a:	8b 52 04             	mov    0x4(%edx),%edx
  80280d:	89 50 04             	mov    %edx,0x4(%eax)
  802810:	eb 0b                	jmp    80281d <alloc_block_NF+0xa8>
  802812:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802815:	8b 40 04             	mov    0x4(%eax),%eax
  802818:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80281d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802820:	8b 40 04             	mov    0x4(%eax),%eax
  802823:	85 c0                	test   %eax,%eax
  802825:	74 0f                	je     802836 <alloc_block_NF+0xc1>
  802827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282a:	8b 40 04             	mov    0x4(%eax),%eax
  80282d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802830:	8b 12                	mov    (%edx),%edx
  802832:	89 10                	mov    %edx,(%eax)
  802834:	eb 0a                	jmp    802840 <alloc_block_NF+0xcb>
  802836:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802839:	8b 00                	mov    (%eax),%eax
  80283b:	a3 48 41 80 00       	mov    %eax,0x804148
  802840:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802843:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802849:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802853:	a1 54 41 80 00       	mov    0x804154,%eax
  802858:	48                   	dec    %eax
  802859:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  80285e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802861:	e9 ad 00 00 00       	jmp    802913 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802866:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802869:	8b 40 0c             	mov    0xc(%eax),%eax
  80286c:	3b 45 08             	cmp    0x8(%ebp),%eax
  80286f:	0f 85 87 00 00 00    	jne    8028fc <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802875:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802879:	75 17                	jne    802892 <alloc_block_NF+0x11d>
  80287b:	83 ec 04             	sub    $0x4,%esp
  80287e:	68 e9 3c 80 00       	push   $0x803ce9
  802883:	68 c8 00 00 00       	push   $0xc8
  802888:	68 77 3c 80 00       	push   $0x803c77
  80288d:	e8 a3 da ff ff       	call   800335 <_panic>
  802892:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802895:	8b 00                	mov    (%eax),%eax
  802897:	85 c0                	test   %eax,%eax
  802899:	74 10                	je     8028ab <alloc_block_NF+0x136>
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 00                	mov    (%eax),%eax
  8028a0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028a3:	8b 52 04             	mov    0x4(%edx),%edx
  8028a6:	89 50 04             	mov    %edx,0x4(%eax)
  8028a9:	eb 0b                	jmp    8028b6 <alloc_block_NF+0x141>
  8028ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ae:	8b 40 04             	mov    0x4(%eax),%eax
  8028b1:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b9:	8b 40 04             	mov    0x4(%eax),%eax
  8028bc:	85 c0                	test   %eax,%eax
  8028be:	74 0f                	je     8028cf <alloc_block_NF+0x15a>
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 40 04             	mov    0x4(%eax),%eax
  8028c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028c9:	8b 12                	mov    (%edx),%edx
  8028cb:	89 10                	mov    %edx,(%eax)
  8028cd:	eb 0a                	jmp    8028d9 <alloc_block_NF+0x164>
  8028cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d2:	8b 00                	mov    (%eax),%eax
  8028d4:	a3 38 41 80 00       	mov    %eax,0x804138
  8028d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028dc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028e2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028ec:	a1 44 41 80 00       	mov    0x804144,%eax
  8028f1:	48                   	dec    %eax
  8028f2:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  8028f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fa:	eb 17                	jmp    802913 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  8028fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ff:	8b 00                	mov    (%eax),%eax
  802901:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802904:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802908:	0f 85 7a fe ff ff    	jne    802788 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  80290e:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802913:	c9                   	leave  
  802914:	c3                   	ret    

00802915 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802915:	55                   	push   %ebp
  802916:	89 e5                	mov    %esp,%ebp
  802918:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  80291b:	a1 38 41 80 00       	mov    0x804138,%eax
  802920:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802923:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802928:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  80292b:	a1 44 41 80 00       	mov    0x804144,%eax
  802930:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802933:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802937:	75 68                	jne    8029a1 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802939:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80293d:	75 17                	jne    802956 <insert_sorted_with_merge_freeList+0x41>
  80293f:	83 ec 04             	sub    $0x4,%esp
  802942:	68 54 3c 80 00       	push   $0x803c54
  802947:	68 da 00 00 00       	push   $0xda
  80294c:	68 77 3c 80 00       	push   $0x803c77
  802951:	e8 df d9 ff ff       	call   800335 <_panic>
  802956:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80295c:	8b 45 08             	mov    0x8(%ebp),%eax
  80295f:	89 10                	mov    %edx,(%eax)
  802961:	8b 45 08             	mov    0x8(%ebp),%eax
  802964:	8b 00                	mov    (%eax),%eax
  802966:	85 c0                	test   %eax,%eax
  802968:	74 0d                	je     802977 <insert_sorted_with_merge_freeList+0x62>
  80296a:	a1 38 41 80 00       	mov    0x804138,%eax
  80296f:	8b 55 08             	mov    0x8(%ebp),%edx
  802972:	89 50 04             	mov    %edx,0x4(%eax)
  802975:	eb 08                	jmp    80297f <insert_sorted_with_merge_freeList+0x6a>
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80297f:	8b 45 08             	mov    0x8(%ebp),%eax
  802982:	a3 38 41 80 00       	mov    %eax,0x804138
  802987:	8b 45 08             	mov    0x8(%ebp),%eax
  80298a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802991:	a1 44 41 80 00       	mov    0x804144,%eax
  802996:	40                   	inc    %eax
  802997:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  80299c:	e9 49 07 00 00       	jmp    8030ea <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  8029a1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029a4:	8b 50 08             	mov    0x8(%eax),%edx
  8029a7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029aa:	8b 40 0c             	mov    0xc(%eax),%eax
  8029ad:	01 c2                	add    %eax,%edx
  8029af:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b2:	8b 40 08             	mov    0x8(%eax),%eax
  8029b5:	39 c2                	cmp    %eax,%edx
  8029b7:	73 77                	jae    802a30 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  8029b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029bc:	8b 00                	mov    (%eax),%eax
  8029be:	85 c0                	test   %eax,%eax
  8029c0:	75 6e                	jne    802a30 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  8029c2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029c6:	74 68                	je     802a30 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  8029c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029cc:	75 17                	jne    8029e5 <insert_sorted_with_merge_freeList+0xd0>
  8029ce:	83 ec 04             	sub    $0x4,%esp
  8029d1:	68 90 3c 80 00       	push   $0x803c90
  8029d6:	68 e0 00 00 00       	push   $0xe0
  8029db:	68 77 3c 80 00       	push   $0x803c77
  8029e0:	e8 50 d9 ff ff       	call   800335 <_panic>
  8029e5:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ee:	89 50 04             	mov    %edx,0x4(%eax)
  8029f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f4:	8b 40 04             	mov    0x4(%eax),%eax
  8029f7:	85 c0                	test   %eax,%eax
  8029f9:	74 0c                	je     802a07 <insert_sorted_with_merge_freeList+0xf2>
  8029fb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a00:	8b 55 08             	mov    0x8(%ebp),%edx
  802a03:	89 10                	mov    %edx,(%eax)
  802a05:	eb 08                	jmp    802a0f <insert_sorted_with_merge_freeList+0xfa>
  802a07:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0a:	a3 38 41 80 00       	mov    %eax,0x804138
  802a0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a12:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a20:	a1 44 41 80 00       	mov    0x804144,%eax
  802a25:	40                   	inc    %eax
  802a26:	a3 44 41 80 00       	mov    %eax,0x804144
  802a2b:	e9 ba 06 00 00       	jmp    8030ea <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802a30:	8b 45 08             	mov    0x8(%ebp),%eax
  802a33:	8b 50 0c             	mov    0xc(%eax),%edx
  802a36:	8b 45 08             	mov    0x8(%ebp),%eax
  802a39:	8b 40 08             	mov    0x8(%eax),%eax
  802a3c:	01 c2                	add    %eax,%edx
  802a3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a41:	8b 40 08             	mov    0x8(%eax),%eax
  802a44:	39 c2                	cmp    %eax,%edx
  802a46:	73 78                	jae    802ac0 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	8b 40 04             	mov    0x4(%eax),%eax
  802a4e:	85 c0                	test   %eax,%eax
  802a50:	75 6e                	jne    802ac0 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802a52:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a56:	74 68                	je     802ac0 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802a58:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a5c:	75 17                	jne    802a75 <insert_sorted_with_merge_freeList+0x160>
  802a5e:	83 ec 04             	sub    $0x4,%esp
  802a61:	68 54 3c 80 00       	push   $0x803c54
  802a66:	68 e6 00 00 00       	push   $0xe6
  802a6b:	68 77 3c 80 00       	push   $0x803c77
  802a70:	e8 c0 d8 ff ff       	call   800335 <_panic>
  802a75:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a7b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7e:	89 10                	mov    %edx,(%eax)
  802a80:	8b 45 08             	mov    0x8(%ebp),%eax
  802a83:	8b 00                	mov    (%eax),%eax
  802a85:	85 c0                	test   %eax,%eax
  802a87:	74 0d                	je     802a96 <insert_sorted_with_merge_freeList+0x181>
  802a89:	a1 38 41 80 00       	mov    0x804138,%eax
  802a8e:	8b 55 08             	mov    0x8(%ebp),%edx
  802a91:	89 50 04             	mov    %edx,0x4(%eax)
  802a94:	eb 08                	jmp    802a9e <insert_sorted_with_merge_freeList+0x189>
  802a96:	8b 45 08             	mov    0x8(%ebp),%eax
  802a99:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	a3 38 41 80 00       	mov    %eax,0x804138
  802aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab0:	a1 44 41 80 00       	mov    0x804144,%eax
  802ab5:	40                   	inc    %eax
  802ab6:	a3 44 41 80 00       	mov    %eax,0x804144
  802abb:	e9 2a 06 00 00       	jmp    8030ea <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802ac0:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ac8:	e9 ed 05 00 00       	jmp    8030ba <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802acd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad0:	8b 00                	mov    (%eax),%eax
  802ad2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802ad5:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ad9:	0f 84 a7 00 00 00    	je     802b86 <insert_sorted_with_merge_freeList+0x271>
  802adf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ae5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae8:	8b 40 08             	mov    0x8(%eax),%eax
  802aeb:	01 c2                	add    %eax,%edx
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	8b 40 08             	mov    0x8(%eax),%eax
  802af3:	39 c2                	cmp    %eax,%edx
  802af5:	0f 83 8b 00 00 00    	jae    802b86 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802afb:	8b 45 08             	mov    0x8(%ebp),%eax
  802afe:	8b 50 0c             	mov    0xc(%eax),%edx
  802b01:	8b 45 08             	mov    0x8(%ebp),%eax
  802b04:	8b 40 08             	mov    0x8(%eax),%eax
  802b07:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802b09:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b0c:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802b0f:	39 c2                	cmp    %eax,%edx
  802b11:	73 73                	jae    802b86 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802b13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b17:	74 06                	je     802b1f <insert_sorted_with_merge_freeList+0x20a>
  802b19:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b1d:	75 17                	jne    802b36 <insert_sorted_with_merge_freeList+0x221>
  802b1f:	83 ec 04             	sub    $0x4,%esp
  802b22:	68 08 3d 80 00       	push   $0x803d08
  802b27:	68 f0 00 00 00       	push   $0xf0
  802b2c:	68 77 3c 80 00       	push   $0x803c77
  802b31:	e8 ff d7 ff ff       	call   800335 <_panic>
  802b36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b39:	8b 10                	mov    (%eax),%edx
  802b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b3e:	89 10                	mov    %edx,(%eax)
  802b40:	8b 45 08             	mov    0x8(%ebp),%eax
  802b43:	8b 00                	mov    (%eax),%eax
  802b45:	85 c0                	test   %eax,%eax
  802b47:	74 0b                	je     802b54 <insert_sorted_with_merge_freeList+0x23f>
  802b49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4c:	8b 00                	mov    (%eax),%eax
  802b4e:	8b 55 08             	mov    0x8(%ebp),%edx
  802b51:	89 50 04             	mov    %edx,0x4(%eax)
  802b54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b57:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5a:	89 10                	mov    %edx,(%eax)
  802b5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b62:	89 50 04             	mov    %edx,0x4(%eax)
  802b65:	8b 45 08             	mov    0x8(%ebp),%eax
  802b68:	8b 00                	mov    (%eax),%eax
  802b6a:	85 c0                	test   %eax,%eax
  802b6c:	75 08                	jne    802b76 <insert_sorted_with_merge_freeList+0x261>
  802b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b71:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b76:	a1 44 41 80 00       	mov    0x804144,%eax
  802b7b:	40                   	inc    %eax
  802b7c:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802b81:	e9 64 05 00 00       	jmp    8030ea <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802b86:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b8b:	8b 50 0c             	mov    0xc(%eax),%edx
  802b8e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b93:	8b 40 08             	mov    0x8(%eax),%eax
  802b96:	01 c2                	add    %eax,%edx
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	8b 40 08             	mov    0x8(%eax),%eax
  802b9e:	39 c2                	cmp    %eax,%edx
  802ba0:	0f 85 b1 00 00 00    	jne    802c57 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802ba6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bab:	85 c0                	test   %eax,%eax
  802bad:	0f 84 a4 00 00 00    	je     802c57 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802bb3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bb8:	8b 00                	mov    (%eax),%eax
  802bba:	85 c0                	test   %eax,%eax
  802bbc:	0f 85 95 00 00 00    	jne    802c57 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802bc2:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bc7:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802bcd:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802bd0:	8b 55 08             	mov    0x8(%ebp),%edx
  802bd3:	8b 52 0c             	mov    0xc(%edx),%edx
  802bd6:	01 ca                	add    %ecx,%edx
  802bd8:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802be5:	8b 45 08             	mov    0x8(%ebp),%eax
  802be8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802bef:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bf3:	75 17                	jne    802c0c <insert_sorted_with_merge_freeList+0x2f7>
  802bf5:	83 ec 04             	sub    $0x4,%esp
  802bf8:	68 54 3c 80 00       	push   $0x803c54
  802bfd:	68 ff 00 00 00       	push   $0xff
  802c02:	68 77 3c 80 00       	push   $0x803c77
  802c07:	e8 29 d7 ff ff       	call   800335 <_panic>
  802c0c:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c12:	8b 45 08             	mov    0x8(%ebp),%eax
  802c15:	89 10                	mov    %edx,(%eax)
  802c17:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1a:	8b 00                	mov    (%eax),%eax
  802c1c:	85 c0                	test   %eax,%eax
  802c1e:	74 0d                	je     802c2d <insert_sorted_with_merge_freeList+0x318>
  802c20:	a1 48 41 80 00       	mov    0x804148,%eax
  802c25:	8b 55 08             	mov    0x8(%ebp),%edx
  802c28:	89 50 04             	mov    %edx,0x4(%eax)
  802c2b:	eb 08                	jmp    802c35 <insert_sorted_with_merge_freeList+0x320>
  802c2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c30:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c35:	8b 45 08             	mov    0x8(%ebp),%eax
  802c38:	a3 48 41 80 00       	mov    %eax,0x804148
  802c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c47:	a1 54 41 80 00       	mov    0x804154,%eax
  802c4c:	40                   	inc    %eax
  802c4d:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802c52:	e9 93 04 00 00       	jmp    8030ea <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802c57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c5a:	8b 50 08             	mov    0x8(%eax),%edx
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 40 0c             	mov    0xc(%eax),%eax
  802c63:	01 c2                	add    %eax,%edx
  802c65:	8b 45 08             	mov    0x8(%ebp),%eax
  802c68:	8b 40 08             	mov    0x8(%eax),%eax
  802c6b:	39 c2                	cmp    %eax,%edx
  802c6d:	0f 85 ae 00 00 00    	jne    802d21 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802c73:	8b 45 08             	mov    0x8(%ebp),%eax
  802c76:	8b 50 0c             	mov    0xc(%eax),%edx
  802c79:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7c:	8b 40 08             	mov    0x8(%eax),%eax
  802c7f:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802c81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c84:	8b 00                	mov    (%eax),%eax
  802c86:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802c89:	39 c2                	cmp    %eax,%edx
  802c8b:	0f 84 90 00 00 00    	je     802d21 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802c91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c94:	8b 50 0c             	mov    0xc(%eax),%edx
  802c97:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802c9d:	01 c2                	add    %eax,%edx
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802cb9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cbd:	75 17                	jne    802cd6 <insert_sorted_with_merge_freeList+0x3c1>
  802cbf:	83 ec 04             	sub    $0x4,%esp
  802cc2:	68 54 3c 80 00       	push   $0x803c54
  802cc7:	68 0b 01 00 00       	push   $0x10b
  802ccc:	68 77 3c 80 00       	push   $0x803c77
  802cd1:	e8 5f d6 ff ff       	call   800335 <_panic>
  802cd6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cdc:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdf:	89 10                	mov    %edx,(%eax)
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	8b 00                	mov    (%eax),%eax
  802ce6:	85 c0                	test   %eax,%eax
  802ce8:	74 0d                	je     802cf7 <insert_sorted_with_merge_freeList+0x3e2>
  802cea:	a1 48 41 80 00       	mov    0x804148,%eax
  802cef:	8b 55 08             	mov    0x8(%ebp),%edx
  802cf2:	89 50 04             	mov    %edx,0x4(%eax)
  802cf5:	eb 08                	jmp    802cff <insert_sorted_with_merge_freeList+0x3ea>
  802cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	a3 48 41 80 00       	mov    %eax,0x804148
  802d07:	8b 45 08             	mov    0x8(%ebp),%eax
  802d0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d11:	a1 54 41 80 00       	mov    0x804154,%eax
  802d16:	40                   	inc    %eax
  802d17:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d1c:	e9 c9 03 00 00       	jmp    8030ea <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	8b 50 0c             	mov    0xc(%eax),%edx
  802d27:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2a:	8b 40 08             	mov    0x8(%eax),%eax
  802d2d:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802d2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d32:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d35:	39 c2                	cmp    %eax,%edx
  802d37:	0f 85 bb 00 00 00    	jne    802df8 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802d3d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d41:	0f 84 b1 00 00 00    	je     802df8 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4a:	8b 40 04             	mov    0x4(%eax),%eax
  802d4d:	85 c0                	test   %eax,%eax
  802d4f:	0f 85 a3 00 00 00    	jne    802df8 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802d55:	a1 38 41 80 00       	mov    0x804138,%eax
  802d5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5d:	8b 52 08             	mov    0x8(%edx),%edx
  802d60:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802d63:	a1 38 41 80 00       	mov    0x804138,%eax
  802d68:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d6e:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802d71:	8b 55 08             	mov    0x8(%ebp),%edx
  802d74:	8b 52 0c             	mov    0xc(%edx),%edx
  802d77:	01 ca                	add    %ecx,%edx
  802d79:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d86:	8b 45 08             	mov    0x8(%ebp),%eax
  802d89:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d90:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d94:	75 17                	jne    802dad <insert_sorted_with_merge_freeList+0x498>
  802d96:	83 ec 04             	sub    $0x4,%esp
  802d99:	68 54 3c 80 00       	push   $0x803c54
  802d9e:	68 17 01 00 00       	push   $0x117
  802da3:	68 77 3c 80 00       	push   $0x803c77
  802da8:	e8 88 d5 ff ff       	call   800335 <_panic>
  802dad:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802db3:	8b 45 08             	mov    0x8(%ebp),%eax
  802db6:	89 10                	mov    %edx,(%eax)
  802db8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbb:	8b 00                	mov    (%eax),%eax
  802dbd:	85 c0                	test   %eax,%eax
  802dbf:	74 0d                	je     802dce <insert_sorted_with_merge_freeList+0x4b9>
  802dc1:	a1 48 41 80 00       	mov    0x804148,%eax
  802dc6:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc9:	89 50 04             	mov    %edx,0x4(%eax)
  802dcc:	eb 08                	jmp    802dd6 <insert_sorted_with_merge_freeList+0x4c1>
  802dce:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd9:	a3 48 41 80 00       	mov    %eax,0x804148
  802dde:	8b 45 08             	mov    0x8(%ebp),%eax
  802de1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802de8:	a1 54 41 80 00       	mov    0x804154,%eax
  802ded:	40                   	inc    %eax
  802dee:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802df3:	e9 f2 02 00 00       	jmp    8030ea <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	8b 50 08             	mov    0x8(%eax),%edx
  802dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802e01:	8b 40 0c             	mov    0xc(%eax),%eax
  802e04:	01 c2                	add    %eax,%edx
  802e06:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e09:	8b 40 08             	mov    0x8(%eax),%eax
  802e0c:	39 c2                	cmp    %eax,%edx
  802e0e:	0f 85 be 00 00 00    	jne    802ed2 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802e14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e17:	8b 40 04             	mov    0x4(%eax),%eax
  802e1a:	8b 50 08             	mov    0x8(%eax),%edx
  802e1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e20:	8b 40 04             	mov    0x4(%eax),%eax
  802e23:	8b 40 0c             	mov    0xc(%eax),%eax
  802e26:	01 c2                	add    %eax,%edx
  802e28:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2b:	8b 40 08             	mov    0x8(%eax),%eax
  802e2e:	39 c2                	cmp    %eax,%edx
  802e30:	0f 84 9c 00 00 00    	je     802ed2 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	8b 50 08             	mov    0x8(%eax),%edx
  802e3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3f:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802e42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e45:	8b 50 0c             	mov    0xc(%eax),%edx
  802e48:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e4e:	01 c2                	add    %eax,%edx
  802e50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e53:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e56:	8b 45 08             	mov    0x8(%ebp),%eax
  802e59:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e6a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e6e:	75 17                	jne    802e87 <insert_sorted_with_merge_freeList+0x572>
  802e70:	83 ec 04             	sub    $0x4,%esp
  802e73:	68 54 3c 80 00       	push   $0x803c54
  802e78:	68 26 01 00 00       	push   $0x126
  802e7d:	68 77 3c 80 00       	push   $0x803c77
  802e82:	e8 ae d4 ff ff       	call   800335 <_panic>
  802e87:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e90:	89 10                	mov    %edx,(%eax)
  802e92:	8b 45 08             	mov    0x8(%ebp),%eax
  802e95:	8b 00                	mov    (%eax),%eax
  802e97:	85 c0                	test   %eax,%eax
  802e99:	74 0d                	je     802ea8 <insert_sorted_with_merge_freeList+0x593>
  802e9b:	a1 48 41 80 00       	mov    0x804148,%eax
  802ea0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ea3:	89 50 04             	mov    %edx,0x4(%eax)
  802ea6:	eb 08                	jmp    802eb0 <insert_sorted_with_merge_freeList+0x59b>
  802ea8:	8b 45 08             	mov    0x8(%ebp),%eax
  802eab:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	a3 48 41 80 00       	mov    %eax,0x804148
  802eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ebb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec2:	a1 54 41 80 00       	mov    0x804154,%eax
  802ec7:	40                   	inc    %eax
  802ec8:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802ecd:	e9 18 02 00 00       	jmp    8030ea <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed5:	8b 50 0c             	mov    0xc(%eax),%edx
  802ed8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edb:	8b 40 08             	mov    0x8(%eax),%eax
  802ede:	01 c2                	add    %eax,%edx
  802ee0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee3:	8b 40 08             	mov    0x8(%eax),%eax
  802ee6:	39 c2                	cmp    %eax,%edx
  802ee8:	0f 85 c4 01 00 00    	jne    8030b2 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802eee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef1:	8b 50 0c             	mov    0xc(%eax),%edx
  802ef4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef7:	8b 40 08             	mov    0x8(%eax),%eax
  802efa:	01 c2                	add    %eax,%edx
  802efc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eff:	8b 00                	mov    (%eax),%eax
  802f01:	8b 40 08             	mov    0x8(%eax),%eax
  802f04:	39 c2                	cmp    %eax,%edx
  802f06:	0f 85 a6 01 00 00    	jne    8030b2 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802f0c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f10:	0f 84 9c 01 00 00    	je     8030b2 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802f16:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f19:	8b 50 0c             	mov    0xc(%eax),%edx
  802f1c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1f:	8b 40 0c             	mov    0xc(%eax),%eax
  802f22:	01 c2                	add    %eax,%edx
  802f24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f27:	8b 00                	mov    (%eax),%eax
  802f29:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2c:	01 c2                	add    %eax,%edx
  802f2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f31:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802f34:	8b 45 08             	mov    0x8(%ebp),%eax
  802f37:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f41:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802f48:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f4c:	75 17                	jne    802f65 <insert_sorted_with_merge_freeList+0x650>
  802f4e:	83 ec 04             	sub    $0x4,%esp
  802f51:	68 54 3c 80 00       	push   $0x803c54
  802f56:	68 32 01 00 00       	push   $0x132
  802f5b:	68 77 3c 80 00       	push   $0x803c77
  802f60:	e8 d0 d3 ff ff       	call   800335 <_panic>
  802f65:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6e:	89 10                	mov    %edx,(%eax)
  802f70:	8b 45 08             	mov    0x8(%ebp),%eax
  802f73:	8b 00                	mov    (%eax),%eax
  802f75:	85 c0                	test   %eax,%eax
  802f77:	74 0d                	je     802f86 <insert_sorted_with_merge_freeList+0x671>
  802f79:	a1 48 41 80 00       	mov    0x804148,%eax
  802f7e:	8b 55 08             	mov    0x8(%ebp),%edx
  802f81:	89 50 04             	mov    %edx,0x4(%eax)
  802f84:	eb 08                	jmp    802f8e <insert_sorted_with_merge_freeList+0x679>
  802f86:	8b 45 08             	mov    0x8(%ebp),%eax
  802f89:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f8e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f91:	a3 48 41 80 00       	mov    %eax,0x804148
  802f96:	8b 45 08             	mov    0x8(%ebp),%eax
  802f99:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fa0:	a1 54 41 80 00       	mov    0x804154,%eax
  802fa5:	40                   	inc    %eax
  802fa6:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802fab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fae:	8b 00                	mov    (%eax),%eax
  802fb0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802fb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fba:	8b 00                	mov    (%eax),%eax
  802fbc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802fc3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fc6:	8b 00                	mov    (%eax),%eax
  802fc8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802fcb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fcf:	75 17                	jne    802fe8 <insert_sorted_with_merge_freeList+0x6d3>
  802fd1:	83 ec 04             	sub    $0x4,%esp
  802fd4:	68 e9 3c 80 00       	push   $0x803ce9
  802fd9:	68 36 01 00 00       	push   $0x136
  802fde:	68 77 3c 80 00       	push   $0x803c77
  802fe3:	e8 4d d3 ff ff       	call   800335 <_panic>
  802fe8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802feb:	8b 00                	mov    (%eax),%eax
  802fed:	85 c0                	test   %eax,%eax
  802fef:	74 10                	je     803001 <insert_sorted_with_merge_freeList+0x6ec>
  802ff1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff4:	8b 00                	mov    (%eax),%eax
  802ff6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ff9:	8b 52 04             	mov    0x4(%edx),%edx
  802ffc:	89 50 04             	mov    %edx,0x4(%eax)
  802fff:	eb 0b                	jmp    80300c <insert_sorted_with_merge_freeList+0x6f7>
  803001:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803004:	8b 40 04             	mov    0x4(%eax),%eax
  803007:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80300c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80300f:	8b 40 04             	mov    0x4(%eax),%eax
  803012:	85 c0                	test   %eax,%eax
  803014:	74 0f                	je     803025 <insert_sorted_with_merge_freeList+0x710>
  803016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803019:	8b 40 04             	mov    0x4(%eax),%eax
  80301c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80301f:	8b 12                	mov    (%edx),%edx
  803021:	89 10                	mov    %edx,(%eax)
  803023:	eb 0a                	jmp    80302f <insert_sorted_with_merge_freeList+0x71a>
  803025:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803028:	8b 00                	mov    (%eax),%eax
  80302a:	a3 38 41 80 00       	mov    %eax,0x804138
  80302f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803032:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803038:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80303b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803042:	a1 44 41 80 00       	mov    0x804144,%eax
  803047:	48                   	dec    %eax
  803048:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  80304d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803051:	75 17                	jne    80306a <insert_sorted_with_merge_freeList+0x755>
  803053:	83 ec 04             	sub    $0x4,%esp
  803056:	68 54 3c 80 00       	push   $0x803c54
  80305b:	68 37 01 00 00       	push   $0x137
  803060:	68 77 3c 80 00       	push   $0x803c77
  803065:	e8 cb d2 ff ff       	call   800335 <_panic>
  80306a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803070:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803073:	89 10                	mov    %edx,(%eax)
  803075:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803078:	8b 00                	mov    (%eax),%eax
  80307a:	85 c0                	test   %eax,%eax
  80307c:	74 0d                	je     80308b <insert_sorted_with_merge_freeList+0x776>
  80307e:	a1 48 41 80 00       	mov    0x804148,%eax
  803083:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803086:	89 50 04             	mov    %edx,0x4(%eax)
  803089:	eb 08                	jmp    803093 <insert_sorted_with_merge_freeList+0x77e>
  80308b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80308e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803093:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803096:	a3 48 41 80 00       	mov    %eax,0x804148
  80309b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80309e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a5:	a1 54 41 80 00       	mov    0x804154,%eax
  8030aa:	40                   	inc    %eax
  8030ab:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  8030b0:	eb 38                	jmp    8030ea <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8030b2:	a1 40 41 80 00       	mov    0x804140,%eax
  8030b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030be:	74 07                	je     8030c7 <insert_sorted_with_merge_freeList+0x7b2>
  8030c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c3:	8b 00                	mov    (%eax),%eax
  8030c5:	eb 05                	jmp    8030cc <insert_sorted_with_merge_freeList+0x7b7>
  8030c7:	b8 00 00 00 00       	mov    $0x0,%eax
  8030cc:	a3 40 41 80 00       	mov    %eax,0x804140
  8030d1:	a1 40 41 80 00       	mov    0x804140,%eax
  8030d6:	85 c0                	test   %eax,%eax
  8030d8:	0f 85 ef f9 ff ff    	jne    802acd <insert_sorted_with_merge_freeList+0x1b8>
  8030de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030e2:	0f 85 e5 f9 ff ff    	jne    802acd <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  8030e8:	eb 00                	jmp    8030ea <insert_sorted_with_merge_freeList+0x7d5>
  8030ea:	90                   	nop
  8030eb:	c9                   	leave  
  8030ec:	c3                   	ret    
  8030ed:	66 90                	xchg   %ax,%ax
  8030ef:	90                   	nop

008030f0 <__udivdi3>:
  8030f0:	55                   	push   %ebp
  8030f1:	57                   	push   %edi
  8030f2:	56                   	push   %esi
  8030f3:	53                   	push   %ebx
  8030f4:	83 ec 1c             	sub    $0x1c,%esp
  8030f7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8030fb:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8030ff:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803103:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803107:	89 ca                	mov    %ecx,%edx
  803109:	89 f8                	mov    %edi,%eax
  80310b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80310f:	85 f6                	test   %esi,%esi
  803111:	75 2d                	jne    803140 <__udivdi3+0x50>
  803113:	39 cf                	cmp    %ecx,%edi
  803115:	77 65                	ja     80317c <__udivdi3+0x8c>
  803117:	89 fd                	mov    %edi,%ebp
  803119:	85 ff                	test   %edi,%edi
  80311b:	75 0b                	jne    803128 <__udivdi3+0x38>
  80311d:	b8 01 00 00 00       	mov    $0x1,%eax
  803122:	31 d2                	xor    %edx,%edx
  803124:	f7 f7                	div    %edi
  803126:	89 c5                	mov    %eax,%ebp
  803128:	31 d2                	xor    %edx,%edx
  80312a:	89 c8                	mov    %ecx,%eax
  80312c:	f7 f5                	div    %ebp
  80312e:	89 c1                	mov    %eax,%ecx
  803130:	89 d8                	mov    %ebx,%eax
  803132:	f7 f5                	div    %ebp
  803134:	89 cf                	mov    %ecx,%edi
  803136:	89 fa                	mov    %edi,%edx
  803138:	83 c4 1c             	add    $0x1c,%esp
  80313b:	5b                   	pop    %ebx
  80313c:	5e                   	pop    %esi
  80313d:	5f                   	pop    %edi
  80313e:	5d                   	pop    %ebp
  80313f:	c3                   	ret    
  803140:	39 ce                	cmp    %ecx,%esi
  803142:	77 28                	ja     80316c <__udivdi3+0x7c>
  803144:	0f bd fe             	bsr    %esi,%edi
  803147:	83 f7 1f             	xor    $0x1f,%edi
  80314a:	75 40                	jne    80318c <__udivdi3+0x9c>
  80314c:	39 ce                	cmp    %ecx,%esi
  80314e:	72 0a                	jb     80315a <__udivdi3+0x6a>
  803150:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803154:	0f 87 9e 00 00 00    	ja     8031f8 <__udivdi3+0x108>
  80315a:	b8 01 00 00 00       	mov    $0x1,%eax
  80315f:	89 fa                	mov    %edi,%edx
  803161:	83 c4 1c             	add    $0x1c,%esp
  803164:	5b                   	pop    %ebx
  803165:	5e                   	pop    %esi
  803166:	5f                   	pop    %edi
  803167:	5d                   	pop    %ebp
  803168:	c3                   	ret    
  803169:	8d 76 00             	lea    0x0(%esi),%esi
  80316c:	31 ff                	xor    %edi,%edi
  80316e:	31 c0                	xor    %eax,%eax
  803170:	89 fa                	mov    %edi,%edx
  803172:	83 c4 1c             	add    $0x1c,%esp
  803175:	5b                   	pop    %ebx
  803176:	5e                   	pop    %esi
  803177:	5f                   	pop    %edi
  803178:	5d                   	pop    %ebp
  803179:	c3                   	ret    
  80317a:	66 90                	xchg   %ax,%ax
  80317c:	89 d8                	mov    %ebx,%eax
  80317e:	f7 f7                	div    %edi
  803180:	31 ff                	xor    %edi,%edi
  803182:	89 fa                	mov    %edi,%edx
  803184:	83 c4 1c             	add    $0x1c,%esp
  803187:	5b                   	pop    %ebx
  803188:	5e                   	pop    %esi
  803189:	5f                   	pop    %edi
  80318a:	5d                   	pop    %ebp
  80318b:	c3                   	ret    
  80318c:	bd 20 00 00 00       	mov    $0x20,%ebp
  803191:	89 eb                	mov    %ebp,%ebx
  803193:	29 fb                	sub    %edi,%ebx
  803195:	89 f9                	mov    %edi,%ecx
  803197:	d3 e6                	shl    %cl,%esi
  803199:	89 c5                	mov    %eax,%ebp
  80319b:	88 d9                	mov    %bl,%cl
  80319d:	d3 ed                	shr    %cl,%ebp
  80319f:	89 e9                	mov    %ebp,%ecx
  8031a1:	09 f1                	or     %esi,%ecx
  8031a3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031a7:	89 f9                	mov    %edi,%ecx
  8031a9:	d3 e0                	shl    %cl,%eax
  8031ab:	89 c5                	mov    %eax,%ebp
  8031ad:	89 d6                	mov    %edx,%esi
  8031af:	88 d9                	mov    %bl,%cl
  8031b1:	d3 ee                	shr    %cl,%esi
  8031b3:	89 f9                	mov    %edi,%ecx
  8031b5:	d3 e2                	shl    %cl,%edx
  8031b7:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031bb:	88 d9                	mov    %bl,%cl
  8031bd:	d3 e8                	shr    %cl,%eax
  8031bf:	09 c2                	or     %eax,%edx
  8031c1:	89 d0                	mov    %edx,%eax
  8031c3:	89 f2                	mov    %esi,%edx
  8031c5:	f7 74 24 0c          	divl   0xc(%esp)
  8031c9:	89 d6                	mov    %edx,%esi
  8031cb:	89 c3                	mov    %eax,%ebx
  8031cd:	f7 e5                	mul    %ebp
  8031cf:	39 d6                	cmp    %edx,%esi
  8031d1:	72 19                	jb     8031ec <__udivdi3+0xfc>
  8031d3:	74 0b                	je     8031e0 <__udivdi3+0xf0>
  8031d5:	89 d8                	mov    %ebx,%eax
  8031d7:	31 ff                	xor    %edi,%edi
  8031d9:	e9 58 ff ff ff       	jmp    803136 <__udivdi3+0x46>
  8031de:	66 90                	xchg   %ax,%ax
  8031e0:	8b 54 24 08          	mov    0x8(%esp),%edx
  8031e4:	89 f9                	mov    %edi,%ecx
  8031e6:	d3 e2                	shl    %cl,%edx
  8031e8:	39 c2                	cmp    %eax,%edx
  8031ea:	73 e9                	jae    8031d5 <__udivdi3+0xe5>
  8031ec:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8031ef:	31 ff                	xor    %edi,%edi
  8031f1:	e9 40 ff ff ff       	jmp    803136 <__udivdi3+0x46>
  8031f6:	66 90                	xchg   %ax,%ax
  8031f8:	31 c0                	xor    %eax,%eax
  8031fa:	e9 37 ff ff ff       	jmp    803136 <__udivdi3+0x46>
  8031ff:	90                   	nop

00803200 <__umoddi3>:
  803200:	55                   	push   %ebp
  803201:	57                   	push   %edi
  803202:	56                   	push   %esi
  803203:	53                   	push   %ebx
  803204:	83 ec 1c             	sub    $0x1c,%esp
  803207:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80320b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80320f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803213:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803217:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80321b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80321f:	89 f3                	mov    %esi,%ebx
  803221:	89 fa                	mov    %edi,%edx
  803223:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803227:	89 34 24             	mov    %esi,(%esp)
  80322a:	85 c0                	test   %eax,%eax
  80322c:	75 1a                	jne    803248 <__umoddi3+0x48>
  80322e:	39 f7                	cmp    %esi,%edi
  803230:	0f 86 a2 00 00 00    	jbe    8032d8 <__umoddi3+0xd8>
  803236:	89 c8                	mov    %ecx,%eax
  803238:	89 f2                	mov    %esi,%edx
  80323a:	f7 f7                	div    %edi
  80323c:	89 d0                	mov    %edx,%eax
  80323e:	31 d2                	xor    %edx,%edx
  803240:	83 c4 1c             	add    $0x1c,%esp
  803243:	5b                   	pop    %ebx
  803244:	5e                   	pop    %esi
  803245:	5f                   	pop    %edi
  803246:	5d                   	pop    %ebp
  803247:	c3                   	ret    
  803248:	39 f0                	cmp    %esi,%eax
  80324a:	0f 87 ac 00 00 00    	ja     8032fc <__umoddi3+0xfc>
  803250:	0f bd e8             	bsr    %eax,%ebp
  803253:	83 f5 1f             	xor    $0x1f,%ebp
  803256:	0f 84 ac 00 00 00    	je     803308 <__umoddi3+0x108>
  80325c:	bf 20 00 00 00       	mov    $0x20,%edi
  803261:	29 ef                	sub    %ebp,%edi
  803263:	89 fe                	mov    %edi,%esi
  803265:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803269:	89 e9                	mov    %ebp,%ecx
  80326b:	d3 e0                	shl    %cl,%eax
  80326d:	89 d7                	mov    %edx,%edi
  80326f:	89 f1                	mov    %esi,%ecx
  803271:	d3 ef                	shr    %cl,%edi
  803273:	09 c7                	or     %eax,%edi
  803275:	89 e9                	mov    %ebp,%ecx
  803277:	d3 e2                	shl    %cl,%edx
  803279:	89 14 24             	mov    %edx,(%esp)
  80327c:	89 d8                	mov    %ebx,%eax
  80327e:	d3 e0                	shl    %cl,%eax
  803280:	89 c2                	mov    %eax,%edx
  803282:	8b 44 24 08          	mov    0x8(%esp),%eax
  803286:	d3 e0                	shl    %cl,%eax
  803288:	89 44 24 04          	mov    %eax,0x4(%esp)
  80328c:	8b 44 24 08          	mov    0x8(%esp),%eax
  803290:	89 f1                	mov    %esi,%ecx
  803292:	d3 e8                	shr    %cl,%eax
  803294:	09 d0                	or     %edx,%eax
  803296:	d3 eb                	shr    %cl,%ebx
  803298:	89 da                	mov    %ebx,%edx
  80329a:	f7 f7                	div    %edi
  80329c:	89 d3                	mov    %edx,%ebx
  80329e:	f7 24 24             	mull   (%esp)
  8032a1:	89 c6                	mov    %eax,%esi
  8032a3:	89 d1                	mov    %edx,%ecx
  8032a5:	39 d3                	cmp    %edx,%ebx
  8032a7:	0f 82 87 00 00 00    	jb     803334 <__umoddi3+0x134>
  8032ad:	0f 84 91 00 00 00    	je     803344 <__umoddi3+0x144>
  8032b3:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032b7:	29 f2                	sub    %esi,%edx
  8032b9:	19 cb                	sbb    %ecx,%ebx
  8032bb:	89 d8                	mov    %ebx,%eax
  8032bd:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032c1:	d3 e0                	shl    %cl,%eax
  8032c3:	89 e9                	mov    %ebp,%ecx
  8032c5:	d3 ea                	shr    %cl,%edx
  8032c7:	09 d0                	or     %edx,%eax
  8032c9:	89 e9                	mov    %ebp,%ecx
  8032cb:	d3 eb                	shr    %cl,%ebx
  8032cd:	89 da                	mov    %ebx,%edx
  8032cf:	83 c4 1c             	add    $0x1c,%esp
  8032d2:	5b                   	pop    %ebx
  8032d3:	5e                   	pop    %esi
  8032d4:	5f                   	pop    %edi
  8032d5:	5d                   	pop    %ebp
  8032d6:	c3                   	ret    
  8032d7:	90                   	nop
  8032d8:	89 fd                	mov    %edi,%ebp
  8032da:	85 ff                	test   %edi,%edi
  8032dc:	75 0b                	jne    8032e9 <__umoddi3+0xe9>
  8032de:	b8 01 00 00 00       	mov    $0x1,%eax
  8032e3:	31 d2                	xor    %edx,%edx
  8032e5:	f7 f7                	div    %edi
  8032e7:	89 c5                	mov    %eax,%ebp
  8032e9:	89 f0                	mov    %esi,%eax
  8032eb:	31 d2                	xor    %edx,%edx
  8032ed:	f7 f5                	div    %ebp
  8032ef:	89 c8                	mov    %ecx,%eax
  8032f1:	f7 f5                	div    %ebp
  8032f3:	89 d0                	mov    %edx,%eax
  8032f5:	e9 44 ff ff ff       	jmp    80323e <__umoddi3+0x3e>
  8032fa:	66 90                	xchg   %ax,%ax
  8032fc:	89 c8                	mov    %ecx,%eax
  8032fe:	89 f2                	mov    %esi,%edx
  803300:	83 c4 1c             	add    $0x1c,%esp
  803303:	5b                   	pop    %ebx
  803304:	5e                   	pop    %esi
  803305:	5f                   	pop    %edi
  803306:	5d                   	pop    %ebp
  803307:	c3                   	ret    
  803308:	3b 04 24             	cmp    (%esp),%eax
  80330b:	72 06                	jb     803313 <__umoddi3+0x113>
  80330d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803311:	77 0f                	ja     803322 <__umoddi3+0x122>
  803313:	89 f2                	mov    %esi,%edx
  803315:	29 f9                	sub    %edi,%ecx
  803317:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80331b:	89 14 24             	mov    %edx,(%esp)
  80331e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803322:	8b 44 24 04          	mov    0x4(%esp),%eax
  803326:	8b 14 24             	mov    (%esp),%edx
  803329:	83 c4 1c             	add    $0x1c,%esp
  80332c:	5b                   	pop    %ebx
  80332d:	5e                   	pop    %esi
  80332e:	5f                   	pop    %edi
  80332f:	5d                   	pop    %ebp
  803330:	c3                   	ret    
  803331:	8d 76 00             	lea    0x0(%esi),%esi
  803334:	2b 04 24             	sub    (%esp),%eax
  803337:	19 fa                	sbb    %edi,%edx
  803339:	89 d1                	mov    %edx,%ecx
  80333b:	89 c6                	mov    %eax,%esi
  80333d:	e9 71 ff ff ff       	jmp    8032b3 <__umoddi3+0xb3>
  803342:	66 90                	xchg   %ax,%ax
  803344:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803348:	72 ea                	jb     803334 <__umoddi3+0x134>
  80334a:	89 d9                	mov    %ebx,%ecx
  80334c:	e9 62 ff ff ff       	jmp    8032b3 <__umoddi3+0xb3>
