
obj/user/tst_sharing_2slave1:     file format elf32-i386


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
  800031:	e8 2b 02 00 00       	call   800261 <libmain>
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
  800099:	e8 ff 02 00 00       	call   80039d <_panic>
	}
	/*Dummy malloc to enforce the UHEAP initializations*/
	malloc(0);
  80009e:	83 ec 0c             	sub    $0xc,%esp
  8000a1:	6a 00                	push   $0x0
  8000a3:	e8 48 15 00 00       	call   8015f0 <malloc>
  8000a8:	83 c4 10             	add    $0x10,%esp
	/*=================================================*/

	uint32 *x,*y,*z;
	int32 parentenvID = sys_getparentenvid();
  8000ab:	e8 d7 1c 00 00       	call   801d87 <sys_getparentenvid>
  8000b0:	89 45 ec             	mov    %eax,-0x14(%ebp)
	//GET: z then y then x, opposite to creation order (x then y then z)
	//So, addresses here will be different from the OWNER addresses
	sys_disable_interrupt();
  8000b3:	e8 c3 1a 00 00       	call   801b7b <sys_disable_interrupt>
	int freeFrames = sys_calculate_free_frames() ;
  8000b8:	e8 d1 19 00 00       	call   801a8e <sys_calculate_free_frames>
  8000bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
	z = sget(parentenvID,"z");
  8000c0:	83 ec 08             	sub    $0x8,%esp
  8000c3:	68 f7 33 80 00       	push   $0x8033f7
  8000c8:	ff 75 ec             	pushl  -0x14(%ebp)
  8000cb:	e8 70 17 00 00       	call   801840 <sget>
  8000d0:	83 c4 10             	add    $0x10,%esp
  8000d3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	if (z != (uint32*)(USER_HEAP_START + 0 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8000d6:	81 7d e4 00 00 00 80 	cmpl   $0x80000000,-0x1c(%ebp)
  8000dd:	74 14                	je     8000f3 <_main+0xbb>
  8000df:	83 ec 04             	sub    $0x4,%esp
  8000e2:	68 fc 33 80 00       	push   $0x8033fc
  8000e7:	6a 20                	push   $0x20
  8000e9:	68 dc 33 80 00       	push   $0x8033dc
  8000ee:	e8 aa 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  1) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8000f3:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8000f6:	e8 93 19 00 00       	call   801a8e <sys_calculate_free_frames>
  8000fb:	29 c3                	sub    %eax,%ebx
  8000fd:	89 d8                	mov    %ebx,%eax
  8000ff:	83 f8 01             	cmp    $0x1,%eax
  800102:	74 14                	je     800118 <_main+0xe0>
  800104:	83 ec 04             	sub    $0x4,%esp
  800107:	68 5c 34 80 00       	push   $0x80345c
  80010c:	6a 21                	push   $0x21
  80010e:	68 dc 33 80 00       	push   $0x8033dc
  800113:	e8 85 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800118:	e8 78 1a 00 00       	call   801b95 <sys_enable_interrupt>

	sys_disable_interrupt();
  80011d:	e8 59 1a 00 00       	call   801b7b <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  800122:	e8 67 19 00 00       	call   801a8e <sys_calculate_free_frames>
  800127:	89 45 e8             	mov    %eax,-0x18(%ebp)
	y = sget(parentenvID,"y");
  80012a:	83 ec 08             	sub    $0x8,%esp
  80012d:	68 ed 34 80 00       	push   $0x8034ed
  800132:	ff 75 ec             	pushl  -0x14(%ebp)
  800135:	e8 06 17 00 00       	call   801840 <sget>
  80013a:	83 c4 10             	add    $0x10,%esp
  80013d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (y != (uint32*)(USER_HEAP_START + 1 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  800140:	81 7d e0 00 10 00 80 	cmpl   $0x80001000,-0x20(%ebp)
  800147:	74 14                	je     80015d <_main+0x125>
  800149:	83 ec 04             	sub    $0x4,%esp
  80014c:	68 fc 33 80 00       	push   $0x8033fc
  800151:	6a 27                	push   $0x27
  800153:	68 dc 33 80 00       	push   $0x8033dc
  800158:	e8 40 02 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  80015d:	e8 2c 19 00 00       	call   801a8e <sys_calculate_free_frames>
  800162:	89 c2                	mov    %eax,%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	39 c2                	cmp    %eax,%edx
  800169:	74 14                	je     80017f <_main+0x147>
  80016b:	83 ec 04             	sub    $0x4,%esp
  80016e:	68 5c 34 80 00       	push   $0x80345c
  800173:	6a 28                	push   $0x28
  800175:	68 dc 33 80 00       	push   $0x8033dc
  80017a:	e8 1e 02 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  80017f:	e8 11 1a 00 00       	call   801b95 <sys_enable_interrupt>

	if (*y != 20) panic("Get(): Shared Variable is not created or got correctly") ;
  800184:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800187:	8b 00                	mov    (%eax),%eax
  800189:	83 f8 14             	cmp    $0x14,%eax
  80018c:	74 14                	je     8001a2 <_main+0x16a>
  80018e:	83 ec 04             	sub    $0x4,%esp
  800191:	68 f0 34 80 00       	push   $0x8034f0
  800196:	6a 2b                	push   $0x2b
  800198:	68 dc 33 80 00       	push   $0x8033dc
  80019d:	e8 fb 01 00 00       	call   80039d <_panic>

	sys_disable_interrupt();
  8001a2:	e8 d4 19 00 00       	call   801b7b <sys_disable_interrupt>
	freeFrames = sys_calculate_free_frames() ;
  8001a7:	e8 e2 18 00 00       	call   801a8e <sys_calculate_free_frames>
  8001ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
	x = sget(parentenvID,"x");
  8001af:	83 ec 08             	sub    $0x8,%esp
  8001b2:	68 27 35 80 00       	push   $0x803527
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 81 16 00 00       	call   801840 <sget>
  8001bf:	83 c4 10             	add    $0x10,%esp
  8001c2:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if (x != (uint32*)(USER_HEAP_START + 2 * PAGE_SIZE)) panic("Get(): Returned address is not correct. make sure that you align the allocation on 4KB boundary");
  8001c5:	81 7d dc 00 20 00 80 	cmpl   $0x80002000,-0x24(%ebp)
  8001cc:	74 14                	je     8001e2 <_main+0x1aa>
  8001ce:	83 ec 04             	sub    $0x4,%esp
  8001d1:	68 fc 33 80 00       	push   $0x8033fc
  8001d6:	6a 30                	push   $0x30
  8001d8:	68 dc 33 80 00       	push   $0x8033dc
  8001dd:	e8 bb 01 00 00       	call   80039d <_panic>
	if ((freeFrames - sys_calculate_free_frames()) !=  0) panic("Get(): Wrong sharing- make sure that you share the required space in the current user environment using the correct frames (from frames_storage)");
  8001e2:	e8 a7 18 00 00       	call   801a8e <sys_calculate_free_frames>
  8001e7:	89 c2                	mov    %eax,%edx
  8001e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001ec:	39 c2                	cmp    %eax,%edx
  8001ee:	74 14                	je     800204 <_main+0x1cc>
  8001f0:	83 ec 04             	sub    $0x4,%esp
  8001f3:	68 5c 34 80 00       	push   $0x80345c
  8001f8:	6a 31                	push   $0x31
  8001fa:	68 dc 33 80 00       	push   $0x8033dc
  8001ff:	e8 99 01 00 00       	call   80039d <_panic>
	sys_enable_interrupt();
  800204:	e8 8c 19 00 00       	call   801b95 <sys_enable_interrupt>

	if (*x != 10) panic("Get(): Shared Variable is not created or got correctly") ;
  800209:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80020c:	8b 00                	mov    (%eax),%eax
  80020e:	83 f8 0a             	cmp    $0xa,%eax
  800211:	74 14                	je     800227 <_main+0x1ef>
  800213:	83 ec 04             	sub    $0x4,%esp
  800216:	68 f0 34 80 00       	push   $0x8034f0
  80021b:	6a 34                	push   $0x34
  80021d:	68 dc 33 80 00       	push   $0x8033dc
  800222:	e8 76 01 00 00       	call   80039d <_panic>

	*z = *x + *y ;
  800227:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80022a:	8b 10                	mov    (%eax),%edx
  80022c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80022f:	8b 00                	mov    (%eax),%eax
  800231:	01 c2                	add    %eax,%edx
  800233:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800236:	89 10                	mov    %edx,(%eax)
	if (*z != 30) panic("Get(): Shared Variable is not created or got correctly") ;
  800238:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80023b:	8b 00                	mov    (%eax),%eax
  80023d:	83 f8 1e             	cmp    $0x1e,%eax
  800240:	74 14                	je     800256 <_main+0x21e>
  800242:	83 ec 04             	sub    $0x4,%esp
  800245:	68 f0 34 80 00       	push   $0x8034f0
  80024a:	6a 37                	push   $0x37
  80024c:	68 dc 33 80 00       	push   $0x8033dc
  800251:	e8 47 01 00 00       	call   80039d <_panic>

	//To indicate that it's completed successfully
	inctst();
  800256:	e8 51 1c 00 00       	call   801eac <inctst>

	return;
  80025b:	90                   	nop
}
  80025c:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800267:	e8 02 1b 00 00       	call   801d6e <sys_getenvindex>
  80026c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80026f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800272:	89 d0                	mov    %edx,%eax
  800274:	c1 e0 03             	shl    $0x3,%eax
  800277:	01 d0                	add    %edx,%eax
  800279:	01 c0                	add    %eax,%eax
  80027b:	01 d0                	add    %edx,%eax
  80027d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800284:	01 d0                	add    %edx,%eax
  800286:	c1 e0 04             	shl    $0x4,%eax
  800289:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80028e:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800293:	a1 20 40 80 00       	mov    0x804020,%eax
  800298:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80029e:	84 c0                	test   %al,%al
  8002a0:	74 0f                	je     8002b1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a7:	05 5c 05 00 00       	add    $0x55c,%eax
  8002ac:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8002b5:	7e 0a                	jle    8002c1 <libmain+0x60>
		binaryname = argv[0];
  8002b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ba:	8b 00                	mov    (%eax),%eax
  8002bc:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002c1:	83 ec 08             	sub    $0x8,%esp
  8002c4:	ff 75 0c             	pushl  0xc(%ebp)
  8002c7:	ff 75 08             	pushl  0x8(%ebp)
  8002ca:	e8 69 fd ff ff       	call   800038 <_main>
  8002cf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002d2:	e8 a4 18 00 00       	call   801b7b <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002d7:	83 ec 0c             	sub    $0xc,%esp
  8002da:	68 44 35 80 00       	push   $0x803544
  8002df:	e8 6d 03 00 00       	call   800651 <cprintf>
  8002e4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ec:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f7:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002fd:	83 ec 04             	sub    $0x4,%esp
  800300:	52                   	push   %edx
  800301:	50                   	push   %eax
  800302:	68 6c 35 80 00       	push   $0x80356c
  800307:	e8 45 03 00 00       	call   800651 <cprintf>
  80030c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80030f:	a1 20 40 80 00       	mov    0x804020,%eax
  800314:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80031a:	a1 20 40 80 00       	mov    0x804020,%eax
  80031f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800325:	a1 20 40 80 00       	mov    0x804020,%eax
  80032a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800330:	51                   	push   %ecx
  800331:	52                   	push   %edx
  800332:	50                   	push   %eax
  800333:	68 94 35 80 00       	push   $0x803594
  800338:	e8 14 03 00 00       	call   800651 <cprintf>
  80033d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800340:	a1 20 40 80 00       	mov    0x804020,%eax
  800345:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80034b:	83 ec 08             	sub    $0x8,%esp
  80034e:	50                   	push   %eax
  80034f:	68 ec 35 80 00       	push   $0x8035ec
  800354:	e8 f8 02 00 00       	call   800651 <cprintf>
  800359:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80035c:	83 ec 0c             	sub    $0xc,%esp
  80035f:	68 44 35 80 00       	push   $0x803544
  800364:	e8 e8 02 00 00       	call   800651 <cprintf>
  800369:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80036c:	e8 24 18 00 00       	call   801b95 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800371:	e8 19 00 00 00       	call   80038f <exit>
}
  800376:	90                   	nop
  800377:	c9                   	leave  
  800378:	c3                   	ret    

00800379 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800379:	55                   	push   %ebp
  80037a:	89 e5                	mov    %esp,%ebp
  80037c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80037f:	83 ec 0c             	sub    $0xc,%esp
  800382:	6a 00                	push   $0x0
  800384:	e8 b1 19 00 00       	call   801d3a <sys_destroy_env>
  800389:	83 c4 10             	add    $0x10,%esp
}
  80038c:	90                   	nop
  80038d:	c9                   	leave  
  80038e:	c3                   	ret    

0080038f <exit>:

void
exit(void)
{
  80038f:	55                   	push   %ebp
  800390:	89 e5                	mov    %esp,%ebp
  800392:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800395:	e8 06 1a 00 00       	call   801da0 <sys_exit_env>
}
  80039a:	90                   	nop
  80039b:	c9                   	leave  
  80039c:	c3                   	ret    

0080039d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80039d:	55                   	push   %ebp
  80039e:	89 e5                	mov    %esp,%ebp
  8003a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8003a6:	83 c0 04             	add    $0x4,%eax
  8003a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003ac:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003b1:	85 c0                	test   %eax,%eax
  8003b3:	74 16                	je     8003cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8003b5:	a1 5c 41 80 00       	mov    0x80415c,%eax
  8003ba:	83 ec 08             	sub    $0x8,%esp
  8003bd:	50                   	push   %eax
  8003be:	68 00 36 80 00       	push   $0x803600
  8003c3:	e8 89 02 00 00       	call   800651 <cprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8003cb:	a1 00 40 80 00       	mov    0x804000,%eax
  8003d0:	ff 75 0c             	pushl  0xc(%ebp)
  8003d3:	ff 75 08             	pushl  0x8(%ebp)
  8003d6:	50                   	push   %eax
  8003d7:	68 05 36 80 00       	push   $0x803605
  8003dc:	e8 70 02 00 00       	call   800651 <cprintf>
  8003e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e7:	83 ec 08             	sub    $0x8,%esp
  8003ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ed:	50                   	push   %eax
  8003ee:	e8 f3 01 00 00       	call   8005e6 <vcprintf>
  8003f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003f6:	83 ec 08             	sub    $0x8,%esp
  8003f9:	6a 00                	push   $0x0
  8003fb:	68 21 36 80 00       	push   $0x803621
  800400:	e8 e1 01 00 00       	call   8005e6 <vcprintf>
  800405:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800408:	e8 82 ff ff ff       	call   80038f <exit>

	// should not return here
	while (1) ;
  80040d:	eb fe                	jmp    80040d <_panic+0x70>

0080040f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80040f:	55                   	push   %ebp
  800410:	89 e5                	mov    %esp,%ebp
  800412:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800415:	a1 20 40 80 00       	mov    0x804020,%eax
  80041a:	8b 50 74             	mov    0x74(%eax),%edx
  80041d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800420:	39 c2                	cmp    %eax,%edx
  800422:	74 14                	je     800438 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800424:	83 ec 04             	sub    $0x4,%esp
  800427:	68 24 36 80 00       	push   $0x803624
  80042c:	6a 26                	push   $0x26
  80042e:	68 70 36 80 00       	push   $0x803670
  800433:	e8 65 ff ff ff       	call   80039d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800438:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80043f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800446:	e9 c2 00 00 00       	jmp    80050d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80044b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800455:	8b 45 08             	mov    0x8(%ebp),%eax
  800458:	01 d0                	add    %edx,%eax
  80045a:	8b 00                	mov    (%eax),%eax
  80045c:	85 c0                	test   %eax,%eax
  80045e:	75 08                	jne    800468 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800460:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800463:	e9 a2 00 00 00       	jmp    80050a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800468:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80046f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800476:	eb 69                	jmp    8004e1 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800478:	a1 20 40 80 00       	mov    0x804020,%eax
  80047d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800483:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800486:	89 d0                	mov    %edx,%eax
  800488:	01 c0                	add    %eax,%eax
  80048a:	01 d0                	add    %edx,%eax
  80048c:	c1 e0 03             	shl    $0x3,%eax
  80048f:	01 c8                	add    %ecx,%eax
  800491:	8a 40 04             	mov    0x4(%eax),%al
  800494:	84 c0                	test   %al,%al
  800496:	75 46                	jne    8004de <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800498:	a1 20 40 80 00       	mov    0x804020,%eax
  80049d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004a6:	89 d0                	mov    %edx,%eax
  8004a8:	01 c0                	add    %eax,%eax
  8004aa:	01 d0                	add    %edx,%eax
  8004ac:	c1 e0 03             	shl    $0x3,%eax
  8004af:	01 c8                	add    %ecx,%eax
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8004b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8004be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8004ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cd:	01 c8                	add    %ecx,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004d1:	39 c2                	cmp    %eax,%edx
  8004d3:	75 09                	jne    8004de <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004dc:	eb 12                	jmp    8004f0 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004de:	ff 45 e8             	incl   -0x18(%ebp)
  8004e1:	a1 20 40 80 00       	mov    0x804020,%eax
  8004e6:	8b 50 74             	mov    0x74(%eax),%edx
  8004e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004ec:	39 c2                	cmp    %eax,%edx
  8004ee:	77 88                	ja     800478 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004f4:	75 14                	jne    80050a <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004f6:	83 ec 04             	sub    $0x4,%esp
  8004f9:	68 7c 36 80 00       	push   $0x80367c
  8004fe:	6a 3a                	push   $0x3a
  800500:	68 70 36 80 00       	push   $0x803670
  800505:	e8 93 fe ff ff       	call   80039d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80050a:	ff 45 f0             	incl   -0x10(%ebp)
  80050d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800510:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800513:	0f 8c 32 ff ff ff    	jl     80044b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800519:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800520:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800527:	eb 26                	jmp    80054f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800529:	a1 20 40 80 00       	mov    0x804020,%eax
  80052e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800534:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800537:	89 d0                	mov    %edx,%eax
  800539:	01 c0                	add    %eax,%eax
  80053b:	01 d0                	add    %edx,%eax
  80053d:	c1 e0 03             	shl    $0x3,%eax
  800540:	01 c8                	add    %ecx,%eax
  800542:	8a 40 04             	mov    0x4(%eax),%al
  800545:	3c 01                	cmp    $0x1,%al
  800547:	75 03                	jne    80054c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800549:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80054c:	ff 45 e0             	incl   -0x20(%ebp)
  80054f:	a1 20 40 80 00       	mov    0x804020,%eax
  800554:	8b 50 74             	mov    0x74(%eax),%edx
  800557:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80055a:	39 c2                	cmp    %eax,%edx
  80055c:	77 cb                	ja     800529 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80055e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800561:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800564:	74 14                	je     80057a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800566:	83 ec 04             	sub    $0x4,%esp
  800569:	68 d0 36 80 00       	push   $0x8036d0
  80056e:	6a 44                	push   $0x44
  800570:	68 70 36 80 00       	push   $0x803670
  800575:	e8 23 fe ff ff       	call   80039d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80057a:	90                   	nop
  80057b:	c9                   	leave  
  80057c:	c3                   	ret    

0080057d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80057d:	55                   	push   %ebp
  80057e:	89 e5                	mov    %esp,%ebp
  800580:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800583:	8b 45 0c             	mov    0xc(%ebp),%eax
  800586:	8b 00                	mov    (%eax),%eax
  800588:	8d 48 01             	lea    0x1(%eax),%ecx
  80058b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80058e:	89 0a                	mov    %ecx,(%edx)
  800590:	8b 55 08             	mov    0x8(%ebp),%edx
  800593:	88 d1                	mov    %dl,%cl
  800595:	8b 55 0c             	mov    0xc(%ebp),%edx
  800598:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80059c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059f:	8b 00                	mov    (%eax),%eax
  8005a1:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005a6:	75 2c                	jne    8005d4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005a8:	a0 24 40 80 00       	mov    0x804024,%al
  8005ad:	0f b6 c0             	movzbl %al,%eax
  8005b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005b3:	8b 12                	mov    (%edx),%edx
  8005b5:	89 d1                	mov    %edx,%ecx
  8005b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ba:	83 c2 08             	add    $0x8,%edx
  8005bd:	83 ec 04             	sub    $0x4,%esp
  8005c0:	50                   	push   %eax
  8005c1:	51                   	push   %ecx
  8005c2:	52                   	push   %edx
  8005c3:	e8 05 14 00 00       	call   8019cd <sys_cputs>
  8005c8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8005cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d7:	8b 40 04             	mov    0x4(%eax),%eax
  8005da:	8d 50 01             	lea    0x1(%eax),%edx
  8005dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e0:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005e3:	90                   	nop
  8005e4:	c9                   	leave  
  8005e5:	c3                   	ret    

008005e6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005e6:	55                   	push   %ebp
  8005e7:	89 e5                	mov    %esp,%ebp
  8005e9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005ef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005f6:	00 00 00 
	b.cnt = 0;
  8005f9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800600:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800603:	ff 75 0c             	pushl  0xc(%ebp)
  800606:	ff 75 08             	pushl  0x8(%ebp)
  800609:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80060f:	50                   	push   %eax
  800610:	68 7d 05 80 00       	push   $0x80057d
  800615:	e8 11 02 00 00       	call   80082b <vprintfmt>
  80061a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80061d:	a0 24 40 80 00       	mov    0x804024,%al
  800622:	0f b6 c0             	movzbl %al,%eax
  800625:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  80062b:	83 ec 04             	sub    $0x4,%esp
  80062e:	50                   	push   %eax
  80062f:	52                   	push   %edx
  800630:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800636:	83 c0 08             	add    $0x8,%eax
  800639:	50                   	push   %eax
  80063a:	e8 8e 13 00 00       	call   8019cd <sys_cputs>
  80063f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800642:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800649:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80064f:	c9                   	leave  
  800650:	c3                   	ret    

00800651 <cprintf>:

int cprintf(const char *fmt, ...) {
  800651:	55                   	push   %ebp
  800652:	89 e5                	mov    %esp,%ebp
  800654:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800657:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80065e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800661:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800664:	8b 45 08             	mov    0x8(%ebp),%eax
  800667:	83 ec 08             	sub    $0x8,%esp
  80066a:	ff 75 f4             	pushl  -0xc(%ebp)
  80066d:	50                   	push   %eax
  80066e:	e8 73 ff ff ff       	call   8005e6 <vcprintf>
  800673:	83 c4 10             	add    $0x10,%esp
  800676:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800679:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80067c:	c9                   	leave  
  80067d:	c3                   	ret    

0080067e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80067e:	55                   	push   %ebp
  80067f:	89 e5                	mov    %esp,%ebp
  800681:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800684:	e8 f2 14 00 00       	call   801b7b <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800689:	8d 45 0c             	lea    0xc(%ebp),%eax
  80068c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80068f:	8b 45 08             	mov    0x8(%ebp),%eax
  800692:	83 ec 08             	sub    $0x8,%esp
  800695:	ff 75 f4             	pushl  -0xc(%ebp)
  800698:	50                   	push   %eax
  800699:	e8 48 ff ff ff       	call   8005e6 <vcprintf>
  80069e:	83 c4 10             	add    $0x10,%esp
  8006a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006a4:	e8 ec 14 00 00       	call   801b95 <sys_enable_interrupt>
	return cnt;
  8006a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006ac:	c9                   	leave  
  8006ad:	c3                   	ret    

008006ae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006ae:	55                   	push   %ebp
  8006af:	89 e5                	mov    %esp,%ebp
  8006b1:	53                   	push   %ebx
  8006b2:	83 ec 14             	sub    $0x14,%esp
  8006b5:	8b 45 10             	mov    0x10(%ebp),%eax
  8006b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8006bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006be:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8006c1:	8b 45 18             	mov    0x18(%ebp),%eax
  8006c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8006c9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006cc:	77 55                	ja     800723 <printnum+0x75>
  8006ce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8006d1:	72 05                	jb     8006d8 <printnum+0x2a>
  8006d3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006d6:	77 4b                	ja     800723 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006d8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006db:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006de:	8b 45 18             	mov    0x18(%ebp),%eax
  8006e1:	ba 00 00 00 00       	mov    $0x0,%edx
  8006e6:	52                   	push   %edx
  8006e7:	50                   	push   %eax
  8006e8:	ff 75 f4             	pushl  -0xc(%ebp)
  8006eb:	ff 75 f0             	pushl  -0x10(%ebp)
  8006ee:	e8 65 2a 00 00       	call   803158 <__udivdi3>
  8006f3:	83 c4 10             	add    $0x10,%esp
  8006f6:	83 ec 04             	sub    $0x4,%esp
  8006f9:	ff 75 20             	pushl  0x20(%ebp)
  8006fc:	53                   	push   %ebx
  8006fd:	ff 75 18             	pushl  0x18(%ebp)
  800700:	52                   	push   %edx
  800701:	50                   	push   %eax
  800702:	ff 75 0c             	pushl  0xc(%ebp)
  800705:	ff 75 08             	pushl  0x8(%ebp)
  800708:	e8 a1 ff ff ff       	call   8006ae <printnum>
  80070d:	83 c4 20             	add    $0x20,%esp
  800710:	eb 1a                	jmp    80072c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800712:	83 ec 08             	sub    $0x8,%esp
  800715:	ff 75 0c             	pushl  0xc(%ebp)
  800718:	ff 75 20             	pushl  0x20(%ebp)
  80071b:	8b 45 08             	mov    0x8(%ebp),%eax
  80071e:	ff d0                	call   *%eax
  800720:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800723:	ff 4d 1c             	decl   0x1c(%ebp)
  800726:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  80072a:	7f e6                	jg     800712 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  80072c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80072f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80073a:	53                   	push   %ebx
  80073b:	51                   	push   %ecx
  80073c:	52                   	push   %edx
  80073d:	50                   	push   %eax
  80073e:	e8 25 2b 00 00       	call   803268 <__umoddi3>
  800743:	83 c4 10             	add    $0x10,%esp
  800746:	05 34 39 80 00       	add    $0x803934,%eax
  80074b:	8a 00                	mov    (%eax),%al
  80074d:	0f be c0             	movsbl %al,%eax
  800750:	83 ec 08             	sub    $0x8,%esp
  800753:	ff 75 0c             	pushl  0xc(%ebp)
  800756:	50                   	push   %eax
  800757:	8b 45 08             	mov    0x8(%ebp),%eax
  80075a:	ff d0                	call   *%eax
  80075c:	83 c4 10             	add    $0x10,%esp
}
  80075f:	90                   	nop
  800760:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800763:	c9                   	leave  
  800764:	c3                   	ret    

00800765 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800765:	55                   	push   %ebp
  800766:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800768:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80076c:	7e 1c                	jle    80078a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80076e:	8b 45 08             	mov    0x8(%ebp),%eax
  800771:	8b 00                	mov    (%eax),%eax
  800773:	8d 50 08             	lea    0x8(%eax),%edx
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	89 10                	mov    %edx,(%eax)
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	83 e8 08             	sub    $0x8,%eax
  800783:	8b 50 04             	mov    0x4(%eax),%edx
  800786:	8b 00                	mov    (%eax),%eax
  800788:	eb 40                	jmp    8007ca <getuint+0x65>
	else if (lflag)
  80078a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80078e:	74 1e                	je     8007ae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800790:	8b 45 08             	mov    0x8(%ebp),%eax
  800793:	8b 00                	mov    (%eax),%eax
  800795:	8d 50 04             	lea    0x4(%eax),%edx
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	89 10                	mov    %edx,(%eax)
  80079d:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a0:	8b 00                	mov    (%eax),%eax
  8007a2:	83 e8 04             	sub    $0x4,%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007ac:	eb 1c                	jmp    8007ca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b1:	8b 00                	mov    (%eax),%eax
  8007b3:	8d 50 04             	lea    0x4(%eax),%edx
  8007b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b9:	89 10                	mov    %edx,(%eax)
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	8b 00                	mov    (%eax),%eax
  8007c0:	83 e8 04             	sub    $0x4,%eax
  8007c3:	8b 00                	mov    (%eax),%eax
  8007c5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8007ca:	5d                   	pop    %ebp
  8007cb:	c3                   	ret    

008007cc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8007cc:	55                   	push   %ebp
  8007cd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007cf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007d3:	7e 1c                	jle    8007f1 <getint+0x25>
		return va_arg(*ap, long long);
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	8b 00                	mov    (%eax),%eax
  8007da:	8d 50 08             	lea    0x8(%eax),%edx
  8007dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e0:	89 10                	mov    %edx,(%eax)
  8007e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e5:	8b 00                	mov    (%eax),%eax
  8007e7:	83 e8 08             	sub    $0x8,%eax
  8007ea:	8b 50 04             	mov    0x4(%eax),%edx
  8007ed:	8b 00                	mov    (%eax),%eax
  8007ef:	eb 38                	jmp    800829 <getint+0x5d>
	else if (lflag)
  8007f1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007f5:	74 1a                	je     800811 <getint+0x45>
		return va_arg(*ap, long);
  8007f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fa:	8b 00                	mov    (%eax),%eax
  8007fc:	8d 50 04             	lea    0x4(%eax),%edx
  8007ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800802:	89 10                	mov    %edx,(%eax)
  800804:	8b 45 08             	mov    0x8(%ebp),%eax
  800807:	8b 00                	mov    (%eax),%eax
  800809:	83 e8 04             	sub    $0x4,%eax
  80080c:	8b 00                	mov    (%eax),%eax
  80080e:	99                   	cltd   
  80080f:	eb 18                	jmp    800829 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	8b 00                	mov    (%eax),%eax
  800816:	8d 50 04             	lea    0x4(%eax),%edx
  800819:	8b 45 08             	mov    0x8(%ebp),%eax
  80081c:	89 10                	mov    %edx,(%eax)
  80081e:	8b 45 08             	mov    0x8(%ebp),%eax
  800821:	8b 00                	mov    (%eax),%eax
  800823:	83 e8 04             	sub    $0x4,%eax
  800826:	8b 00                	mov    (%eax),%eax
  800828:	99                   	cltd   
}
  800829:	5d                   	pop    %ebp
  80082a:	c3                   	ret    

0080082b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  80082b:	55                   	push   %ebp
  80082c:	89 e5                	mov    %esp,%ebp
  80082e:	56                   	push   %esi
  80082f:	53                   	push   %ebx
  800830:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800833:	eb 17                	jmp    80084c <vprintfmt+0x21>
			if (ch == '\0')
  800835:	85 db                	test   %ebx,%ebx
  800837:	0f 84 af 03 00 00    	je     800bec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80083d:	83 ec 08             	sub    $0x8,%esp
  800840:	ff 75 0c             	pushl  0xc(%ebp)
  800843:	53                   	push   %ebx
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	ff d0                	call   *%eax
  800849:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80084c:	8b 45 10             	mov    0x10(%ebp),%eax
  80084f:	8d 50 01             	lea    0x1(%eax),%edx
  800852:	89 55 10             	mov    %edx,0x10(%ebp)
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f b6 d8             	movzbl %al,%ebx
  80085a:	83 fb 25             	cmp    $0x25,%ebx
  80085d:	75 d6                	jne    800835 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80085f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800863:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  80086a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800871:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800878:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80087f:	8b 45 10             	mov    0x10(%ebp),%eax
  800882:	8d 50 01             	lea    0x1(%eax),%edx
  800885:	89 55 10             	mov    %edx,0x10(%ebp)
  800888:	8a 00                	mov    (%eax),%al
  80088a:	0f b6 d8             	movzbl %al,%ebx
  80088d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800890:	83 f8 55             	cmp    $0x55,%eax
  800893:	0f 87 2b 03 00 00    	ja     800bc4 <vprintfmt+0x399>
  800899:	8b 04 85 58 39 80 00 	mov    0x803958(,%eax,4),%eax
  8008a0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008a2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008a6:	eb d7                	jmp    80087f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008a8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008ac:	eb d1                	jmp    80087f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008ae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8008b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b8:	89 d0                	mov    %edx,%eax
  8008ba:	c1 e0 02             	shl    $0x2,%eax
  8008bd:	01 d0                	add    %edx,%eax
  8008bf:	01 c0                	add    %eax,%eax
  8008c1:	01 d8                	add    %ebx,%eax
  8008c3:	83 e8 30             	sub    $0x30,%eax
  8008c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8008c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8008cc:	8a 00                	mov    (%eax),%al
  8008ce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8008d1:	83 fb 2f             	cmp    $0x2f,%ebx
  8008d4:	7e 3e                	jle    800914 <vprintfmt+0xe9>
  8008d6:	83 fb 39             	cmp    $0x39,%ebx
  8008d9:	7f 39                	jg     800914 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008db:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008de:	eb d5                	jmp    8008b5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	83 c0 04             	add    $0x4,%eax
  8008e6:	89 45 14             	mov    %eax,0x14(%ebp)
  8008e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ec:	83 e8 04             	sub    $0x4,%eax
  8008ef:	8b 00                	mov    (%eax),%eax
  8008f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008f4:	eb 1f                	jmp    800915 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008f6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008fa:	79 83                	jns    80087f <vprintfmt+0x54>
				width = 0;
  8008fc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800903:	e9 77 ff ff ff       	jmp    80087f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800908:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80090f:	e9 6b ff ff ff       	jmp    80087f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800914:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800915:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800919:	0f 89 60 ff ff ff    	jns    80087f <vprintfmt+0x54>
				width = precision, precision = -1;
  80091f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800922:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800925:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  80092c:	e9 4e ff ff ff       	jmp    80087f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800931:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800934:	e9 46 ff ff ff       	jmp    80087f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800939:	8b 45 14             	mov    0x14(%ebp),%eax
  80093c:	83 c0 04             	add    $0x4,%eax
  80093f:	89 45 14             	mov    %eax,0x14(%ebp)
  800942:	8b 45 14             	mov    0x14(%ebp),%eax
  800945:	83 e8 04             	sub    $0x4,%eax
  800948:	8b 00                	mov    (%eax),%eax
  80094a:	83 ec 08             	sub    $0x8,%esp
  80094d:	ff 75 0c             	pushl  0xc(%ebp)
  800950:	50                   	push   %eax
  800951:	8b 45 08             	mov    0x8(%ebp),%eax
  800954:	ff d0                	call   *%eax
  800956:	83 c4 10             	add    $0x10,%esp
			break;
  800959:	e9 89 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80095e:	8b 45 14             	mov    0x14(%ebp),%eax
  800961:	83 c0 04             	add    $0x4,%eax
  800964:	89 45 14             	mov    %eax,0x14(%ebp)
  800967:	8b 45 14             	mov    0x14(%ebp),%eax
  80096a:	83 e8 04             	sub    $0x4,%eax
  80096d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80096f:	85 db                	test   %ebx,%ebx
  800971:	79 02                	jns    800975 <vprintfmt+0x14a>
				err = -err;
  800973:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800975:	83 fb 64             	cmp    $0x64,%ebx
  800978:	7f 0b                	jg     800985 <vprintfmt+0x15a>
  80097a:	8b 34 9d a0 37 80 00 	mov    0x8037a0(,%ebx,4),%esi
  800981:	85 f6                	test   %esi,%esi
  800983:	75 19                	jne    80099e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800985:	53                   	push   %ebx
  800986:	68 45 39 80 00       	push   $0x803945
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	ff 75 08             	pushl  0x8(%ebp)
  800991:	e8 5e 02 00 00       	call   800bf4 <printfmt>
  800996:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800999:	e9 49 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80099e:	56                   	push   %esi
  80099f:	68 4e 39 80 00       	push   $0x80394e
  8009a4:	ff 75 0c             	pushl  0xc(%ebp)
  8009a7:	ff 75 08             	pushl  0x8(%ebp)
  8009aa:	e8 45 02 00 00       	call   800bf4 <printfmt>
  8009af:	83 c4 10             	add    $0x10,%esp
			break;
  8009b2:	e9 30 02 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8009b7:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ba:	83 c0 04             	add    $0x4,%eax
  8009bd:	89 45 14             	mov    %eax,0x14(%ebp)
  8009c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8009c3:	83 e8 04             	sub    $0x4,%eax
  8009c6:	8b 30                	mov    (%eax),%esi
  8009c8:	85 f6                	test   %esi,%esi
  8009ca:	75 05                	jne    8009d1 <vprintfmt+0x1a6>
				p = "(null)";
  8009cc:	be 51 39 80 00       	mov    $0x803951,%esi
			if (width > 0 && padc != '-')
  8009d1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d5:	7e 6d                	jle    800a44 <vprintfmt+0x219>
  8009d7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009db:	74 67                	je     800a44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009dd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009e0:	83 ec 08             	sub    $0x8,%esp
  8009e3:	50                   	push   %eax
  8009e4:	56                   	push   %esi
  8009e5:	e8 0c 03 00 00       	call   800cf6 <strnlen>
  8009ea:	83 c4 10             	add    $0x10,%esp
  8009ed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009f0:	eb 16                	jmp    800a08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009f2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009f6:	83 ec 08             	sub    $0x8,%esp
  8009f9:	ff 75 0c             	pushl  0xc(%ebp)
  8009fc:	50                   	push   %eax
  8009fd:	8b 45 08             	mov    0x8(%ebp),%eax
  800a00:	ff d0                	call   *%eax
  800a02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a05:	ff 4d e4             	decl   -0x1c(%ebp)
  800a08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a0c:	7f e4                	jg     8009f2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0e:	eb 34                	jmp    800a44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a14:	74 1c                	je     800a32 <vprintfmt+0x207>
  800a16:	83 fb 1f             	cmp    $0x1f,%ebx
  800a19:	7e 05                	jle    800a20 <vprintfmt+0x1f5>
  800a1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800a1e:	7e 12                	jle    800a32 <vprintfmt+0x207>
					putch('?', putdat);
  800a20:	83 ec 08             	sub    $0x8,%esp
  800a23:	ff 75 0c             	pushl  0xc(%ebp)
  800a26:	6a 3f                	push   $0x3f
  800a28:	8b 45 08             	mov    0x8(%ebp),%eax
  800a2b:	ff d0                	call   *%eax
  800a2d:	83 c4 10             	add    $0x10,%esp
  800a30:	eb 0f                	jmp    800a41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a32:	83 ec 08             	sub    $0x8,%esp
  800a35:	ff 75 0c             	pushl  0xc(%ebp)
  800a38:	53                   	push   %ebx
  800a39:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3c:	ff d0                	call   *%eax
  800a3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a41:	ff 4d e4             	decl   -0x1c(%ebp)
  800a44:	89 f0                	mov    %esi,%eax
  800a46:	8d 70 01             	lea    0x1(%eax),%esi
  800a49:	8a 00                	mov    (%eax),%al
  800a4b:	0f be d8             	movsbl %al,%ebx
  800a4e:	85 db                	test   %ebx,%ebx
  800a50:	74 24                	je     800a76 <vprintfmt+0x24b>
  800a52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a56:	78 b8                	js     800a10 <vprintfmt+0x1e5>
  800a58:	ff 4d e0             	decl   -0x20(%ebp)
  800a5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a5f:	79 af                	jns    800a10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a61:	eb 13                	jmp    800a76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a63:	83 ec 08             	sub    $0x8,%esp
  800a66:	ff 75 0c             	pushl  0xc(%ebp)
  800a69:	6a 20                	push   $0x20
  800a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6e:	ff d0                	call   *%eax
  800a70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a73:	ff 4d e4             	decl   -0x1c(%ebp)
  800a76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7a:	7f e7                	jg     800a63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a7c:	e9 66 01 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a81:	83 ec 08             	sub    $0x8,%esp
  800a84:	ff 75 e8             	pushl  -0x18(%ebp)
  800a87:	8d 45 14             	lea    0x14(%ebp),%eax
  800a8a:	50                   	push   %eax
  800a8b:	e8 3c fd ff ff       	call   8007cc <getint>
  800a90:	83 c4 10             	add    $0x10,%esp
  800a93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a9f:	85 d2                	test   %edx,%edx
  800aa1:	79 23                	jns    800ac6 <vprintfmt+0x29b>
				putch('-', putdat);
  800aa3:	83 ec 08             	sub    $0x8,%esp
  800aa6:	ff 75 0c             	pushl  0xc(%ebp)
  800aa9:	6a 2d                	push   $0x2d
  800aab:	8b 45 08             	mov    0x8(%ebp),%eax
  800aae:	ff d0                	call   *%eax
  800ab0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800ab3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ab9:	f7 d8                	neg    %eax
  800abb:	83 d2 00             	adc    $0x0,%edx
  800abe:	f7 da                	neg    %edx
  800ac0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ac3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800ac6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800acd:	e9 bc 00 00 00       	jmp    800b8e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800ad2:	83 ec 08             	sub    $0x8,%esp
  800ad5:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad8:	8d 45 14             	lea    0x14(%ebp),%eax
  800adb:	50                   	push   %eax
  800adc:	e8 84 fc ff ff       	call   800765 <getuint>
  800ae1:	83 c4 10             	add    $0x10,%esp
  800ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800aea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800af1:	e9 98 00 00 00       	jmp    800b8e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800af6:	83 ec 08             	sub    $0x8,%esp
  800af9:	ff 75 0c             	pushl  0xc(%ebp)
  800afc:	6a 58                	push   $0x58
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	ff d0                	call   *%eax
  800b03:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b06:	83 ec 08             	sub    $0x8,%esp
  800b09:	ff 75 0c             	pushl  0xc(%ebp)
  800b0c:	6a 58                	push   $0x58
  800b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b11:	ff d0                	call   *%eax
  800b13:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b16:	83 ec 08             	sub    $0x8,%esp
  800b19:	ff 75 0c             	pushl  0xc(%ebp)
  800b1c:	6a 58                	push   $0x58
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	ff d0                	call   *%eax
  800b23:	83 c4 10             	add    $0x10,%esp
			break;
  800b26:	e9 bc 00 00 00       	jmp    800be7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	ff 75 0c             	pushl  0xc(%ebp)
  800b31:	6a 30                	push   $0x30
  800b33:	8b 45 08             	mov    0x8(%ebp),%eax
  800b36:	ff d0                	call   *%eax
  800b38:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b3b:	83 ec 08             	sub    $0x8,%esp
  800b3e:	ff 75 0c             	pushl  0xc(%ebp)
  800b41:	6a 78                	push   $0x78
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b4b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b4e:	83 c0 04             	add    $0x4,%eax
  800b51:	89 45 14             	mov    %eax,0x14(%ebp)
  800b54:	8b 45 14             	mov    0x14(%ebp),%eax
  800b57:	83 e8 04             	sub    $0x4,%eax
  800b5a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b5f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b66:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b6d:	eb 1f                	jmp    800b8e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b6f:	83 ec 08             	sub    $0x8,%esp
  800b72:	ff 75 e8             	pushl  -0x18(%ebp)
  800b75:	8d 45 14             	lea    0x14(%ebp),%eax
  800b78:	50                   	push   %eax
  800b79:	e8 e7 fb ff ff       	call   800765 <getuint>
  800b7e:	83 c4 10             	add    $0x10,%esp
  800b81:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b84:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b87:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b8e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b95:	83 ec 04             	sub    $0x4,%esp
  800b98:	52                   	push   %edx
  800b99:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b9c:	50                   	push   %eax
  800b9d:	ff 75 f4             	pushl  -0xc(%ebp)
  800ba0:	ff 75 f0             	pushl  -0x10(%ebp)
  800ba3:	ff 75 0c             	pushl  0xc(%ebp)
  800ba6:	ff 75 08             	pushl  0x8(%ebp)
  800ba9:	e8 00 fb ff ff       	call   8006ae <printnum>
  800bae:	83 c4 20             	add    $0x20,%esp
			break;
  800bb1:	eb 34                	jmp    800be7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bb3:	83 ec 08             	sub    $0x8,%esp
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	53                   	push   %ebx
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	ff d0                	call   *%eax
  800bbf:	83 c4 10             	add    $0x10,%esp
			break;
  800bc2:	eb 23                	jmp    800be7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800bc4:	83 ec 08             	sub    $0x8,%esp
  800bc7:	ff 75 0c             	pushl  0xc(%ebp)
  800bca:	6a 25                	push   $0x25
  800bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bcf:	ff d0                	call   *%eax
  800bd1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800bd4:	ff 4d 10             	decl   0x10(%ebp)
  800bd7:	eb 03                	jmp    800bdc <vprintfmt+0x3b1>
  800bd9:	ff 4d 10             	decl   0x10(%ebp)
  800bdc:	8b 45 10             	mov    0x10(%ebp),%eax
  800bdf:	48                   	dec    %eax
  800be0:	8a 00                	mov    (%eax),%al
  800be2:	3c 25                	cmp    $0x25,%al
  800be4:	75 f3                	jne    800bd9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800be6:	90                   	nop
		}
	}
  800be7:	e9 47 fc ff ff       	jmp    800833 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bf0:	5b                   	pop    %ebx
  800bf1:	5e                   	pop    %esi
  800bf2:	5d                   	pop    %ebp
  800bf3:	c3                   	ret    

00800bf4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bf4:	55                   	push   %ebp
  800bf5:	89 e5                	mov    %esp,%ebp
  800bf7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bfa:	8d 45 10             	lea    0x10(%ebp),%eax
  800bfd:	83 c0 04             	add    $0x4,%eax
  800c00:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c03:	8b 45 10             	mov    0x10(%ebp),%eax
  800c06:	ff 75 f4             	pushl  -0xc(%ebp)
  800c09:	50                   	push   %eax
  800c0a:	ff 75 0c             	pushl  0xc(%ebp)
  800c0d:	ff 75 08             	pushl  0x8(%ebp)
  800c10:	e8 16 fc ff ff       	call   80082b <vprintfmt>
  800c15:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c18:	90                   	nop
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c1e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c21:	8b 40 08             	mov    0x8(%eax),%eax
  800c24:	8d 50 01             	lea    0x1(%eax),%edx
  800c27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	8b 10                	mov    (%eax),%edx
  800c32:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c35:	8b 40 04             	mov    0x4(%eax),%eax
  800c38:	39 c2                	cmp    %eax,%edx
  800c3a:	73 12                	jae    800c4e <sprintputch+0x33>
		*b->buf++ = ch;
  800c3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3f:	8b 00                	mov    (%eax),%eax
  800c41:	8d 48 01             	lea    0x1(%eax),%ecx
  800c44:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c47:	89 0a                	mov    %ecx,(%edx)
  800c49:	8b 55 08             	mov    0x8(%ebp),%edx
  800c4c:	88 10                	mov    %dl,(%eax)
}
  800c4e:	90                   	nop
  800c4f:	5d                   	pop    %ebp
  800c50:	c3                   	ret    

00800c51 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c51:	55                   	push   %ebp
  800c52:	89 e5                	mov    %esp,%ebp
  800c54:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	01 d0                	add    %edx,%eax
  800c68:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c6b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c72:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c76:	74 06                	je     800c7e <vsnprintf+0x2d>
  800c78:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c7c:	7f 07                	jg     800c85 <vsnprintf+0x34>
		return -E_INVAL;
  800c7e:	b8 03 00 00 00       	mov    $0x3,%eax
  800c83:	eb 20                	jmp    800ca5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c85:	ff 75 14             	pushl  0x14(%ebp)
  800c88:	ff 75 10             	pushl  0x10(%ebp)
  800c8b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c8e:	50                   	push   %eax
  800c8f:	68 1b 0c 80 00       	push   $0x800c1b
  800c94:	e8 92 fb ff ff       	call   80082b <vprintfmt>
  800c99:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c9f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ca2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800ca5:	c9                   	leave  
  800ca6:	c3                   	ret    

00800ca7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ca7:	55                   	push   %ebp
  800ca8:	89 e5                	mov    %esp,%ebp
  800caa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cad:	8d 45 10             	lea    0x10(%ebp),%eax
  800cb0:	83 c0 04             	add    $0x4,%eax
  800cb3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800cb6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cb9:	ff 75 f4             	pushl  -0xc(%ebp)
  800cbc:	50                   	push   %eax
  800cbd:	ff 75 0c             	pushl  0xc(%ebp)
  800cc0:	ff 75 08             	pushl  0x8(%ebp)
  800cc3:	e8 89 ff ff ff       	call   800c51 <vsnprintf>
  800cc8:	83 c4 10             	add    $0x10,%esp
  800ccb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800cce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800cd9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ce0:	eb 06                	jmp    800ce8 <strlen+0x15>
		n++;
  800ce2:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800ce5:	ff 45 08             	incl   0x8(%ebp)
  800ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ceb:	8a 00                	mov    (%eax),%al
  800ced:	84 c0                	test   %al,%al
  800cef:	75 f1                	jne    800ce2 <strlen+0xf>
		n++;
	return n;
  800cf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cf4:	c9                   	leave  
  800cf5:	c3                   	ret    

00800cf6 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cf6:	55                   	push   %ebp
  800cf7:	89 e5                	mov    %esp,%ebp
  800cf9:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cfc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d03:	eb 09                	jmp    800d0e <strnlen+0x18>
		n++;
  800d05:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d08:	ff 45 08             	incl   0x8(%ebp)
  800d0b:	ff 4d 0c             	decl   0xc(%ebp)
  800d0e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d12:	74 09                	je     800d1d <strnlen+0x27>
  800d14:	8b 45 08             	mov    0x8(%ebp),%eax
  800d17:	8a 00                	mov    (%eax),%al
  800d19:	84 c0                	test   %al,%al
  800d1b:	75 e8                	jne    800d05 <strnlen+0xf>
		n++;
	return n;
  800d1d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d20:	c9                   	leave  
  800d21:	c3                   	ret    

00800d22 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d22:	55                   	push   %ebp
  800d23:	89 e5                	mov    %esp,%ebp
  800d25:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d28:	8b 45 08             	mov    0x8(%ebp),%eax
  800d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d2e:	90                   	nop
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	8d 50 01             	lea    0x1(%eax),%edx
  800d35:	89 55 08             	mov    %edx,0x8(%ebp)
  800d38:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3e:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d41:	8a 12                	mov    (%edx),%dl
  800d43:	88 10                	mov    %dl,(%eax)
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	75 e4                	jne    800d2f <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d4b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d4e:	c9                   	leave  
  800d4f:	c3                   	ret    

00800d50 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d50:	55                   	push   %ebp
  800d51:	89 e5                	mov    %esp,%ebp
  800d53:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d5c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d63:	eb 1f                	jmp    800d84 <strncpy+0x34>
		*dst++ = *src;
  800d65:	8b 45 08             	mov    0x8(%ebp),%eax
  800d68:	8d 50 01             	lea    0x1(%eax),%edx
  800d6b:	89 55 08             	mov    %edx,0x8(%ebp)
  800d6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d71:	8a 12                	mov    (%edx),%dl
  800d73:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d78:	8a 00                	mov    (%eax),%al
  800d7a:	84 c0                	test   %al,%al
  800d7c:	74 03                	je     800d81 <strncpy+0x31>
			src++;
  800d7e:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d81:	ff 45 fc             	incl   -0x4(%ebp)
  800d84:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d87:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d8a:	72 d9                	jb     800d65 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d8c:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d8f:	c9                   	leave  
  800d90:	c3                   	ret    

00800d91 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d91:	55                   	push   %ebp
  800d92:	89 e5                	mov    %esp,%ebp
  800d94:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d9d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da1:	74 30                	je     800dd3 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800da3:	eb 16                	jmp    800dbb <strlcpy+0x2a>
			*dst++ = *src++;
  800da5:	8b 45 08             	mov    0x8(%ebp),%eax
  800da8:	8d 50 01             	lea    0x1(%eax),%edx
  800dab:	89 55 08             	mov    %edx,0x8(%ebp)
  800dae:	8b 55 0c             	mov    0xc(%ebp),%edx
  800db1:	8d 4a 01             	lea    0x1(%edx),%ecx
  800db4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800db7:	8a 12                	mov    (%edx),%dl
  800db9:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800dbb:	ff 4d 10             	decl   0x10(%ebp)
  800dbe:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dc2:	74 09                	je     800dcd <strlcpy+0x3c>
  800dc4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc7:	8a 00                	mov    (%eax),%al
  800dc9:	84 c0                	test   %al,%al
  800dcb:	75 d8                	jne    800da5 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd0:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800dd3:	8b 55 08             	mov    0x8(%ebp),%edx
  800dd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd9:	29 c2                	sub    %eax,%edx
  800ddb:	89 d0                	mov    %edx,%eax
}
  800ddd:	c9                   	leave  
  800dde:	c3                   	ret    

00800ddf <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ddf:	55                   	push   %ebp
  800de0:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800de2:	eb 06                	jmp    800dea <strcmp+0xb>
		p++, q++;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800dea:	8b 45 08             	mov    0x8(%ebp),%eax
  800ded:	8a 00                	mov    (%eax),%al
  800def:	84 c0                	test   %al,%al
  800df1:	74 0e                	je     800e01 <strcmp+0x22>
  800df3:	8b 45 08             	mov    0x8(%ebp),%eax
  800df6:	8a 10                	mov    (%eax),%dl
  800df8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	38 c2                	cmp    %al,%dl
  800dff:	74 e3                	je     800de4 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 00                	mov    (%eax),%al
  800e06:	0f b6 d0             	movzbl %al,%edx
  800e09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e0c:	8a 00                	mov    (%eax),%al
  800e0e:	0f b6 c0             	movzbl %al,%eax
  800e11:	29 c2                	sub    %eax,%edx
  800e13:	89 d0                	mov    %edx,%eax
}
  800e15:	5d                   	pop    %ebp
  800e16:	c3                   	ret    

00800e17 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e17:	55                   	push   %ebp
  800e18:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e1a:	eb 09                	jmp    800e25 <strncmp+0xe>
		n--, p++, q++;
  800e1c:	ff 4d 10             	decl   0x10(%ebp)
  800e1f:	ff 45 08             	incl   0x8(%ebp)
  800e22:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e29:	74 17                	je     800e42 <strncmp+0x2b>
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	8a 00                	mov    (%eax),%al
  800e30:	84 c0                	test   %al,%al
  800e32:	74 0e                	je     800e42 <strncmp+0x2b>
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	8a 10                	mov    (%eax),%dl
  800e39:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	38 c2                	cmp    %al,%dl
  800e40:	74 da                	je     800e1c <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e46:	75 07                	jne    800e4f <strncmp+0x38>
		return 0;
  800e48:	b8 00 00 00 00       	mov    $0x0,%eax
  800e4d:	eb 14                	jmp    800e63 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	8a 00                	mov    (%eax),%al
  800e54:	0f b6 d0             	movzbl %al,%edx
  800e57:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f b6 c0             	movzbl %al,%eax
  800e5f:	29 c2                	sub    %eax,%edx
  800e61:	89 d0                	mov    %edx,%eax
}
  800e63:	5d                   	pop    %ebp
  800e64:	c3                   	ret    

00800e65 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e65:	55                   	push   %ebp
  800e66:	89 e5                	mov    %esp,%ebp
  800e68:	83 ec 04             	sub    $0x4,%esp
  800e6b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e71:	eb 12                	jmp    800e85 <strchr+0x20>
		if (*s == c)
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	8a 00                	mov    (%eax),%al
  800e78:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e7b:	75 05                	jne    800e82 <strchr+0x1d>
			return (char *) s;
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	eb 11                	jmp    800e93 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e82:	ff 45 08             	incl   0x8(%ebp)
  800e85:	8b 45 08             	mov    0x8(%ebp),%eax
  800e88:	8a 00                	mov    (%eax),%al
  800e8a:	84 c0                	test   %al,%al
  800e8c:	75 e5                	jne    800e73 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e8e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e93:	c9                   	leave  
  800e94:	c3                   	ret    

00800e95 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e95:	55                   	push   %ebp
  800e96:	89 e5                	mov    %esp,%ebp
  800e98:	83 ec 04             	sub    $0x4,%esp
  800e9b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e9e:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ea1:	eb 0d                	jmp    800eb0 <strfind+0x1b>
		if (*s == c)
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800eab:	74 0e                	je     800ebb <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ead:	ff 45 08             	incl   0x8(%ebp)
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8a 00                	mov    (%eax),%al
  800eb5:	84 c0                	test   %al,%al
  800eb7:	75 ea                	jne    800ea3 <strfind+0xe>
  800eb9:	eb 01                	jmp    800ebc <strfind+0x27>
		if (*s == c)
			break;
  800ebb:	90                   	nop
	return (char *) s;
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebf:	c9                   	leave  
  800ec0:	c3                   	ret    

00800ec1 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800ec1:	55                   	push   %ebp
  800ec2:	89 e5                	mov    %esp,%ebp
  800ec4:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eca:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800ecd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed0:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ed3:	eb 0e                	jmp    800ee3 <memset+0x22>
		*p++ = c;
  800ed5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed8:	8d 50 01             	lea    0x1(%eax),%edx
  800edb:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ede:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ee1:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ee3:	ff 4d f8             	decl   -0x8(%ebp)
  800ee6:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eea:	79 e9                	jns    800ed5 <memset+0x14>
		*p++ = c;

	return v;
  800eec:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eef:	c9                   	leave  
  800ef0:	c3                   	ret    

00800ef1 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ef1:	55                   	push   %ebp
  800ef2:	89 e5                	mov    %esp,%ebp
  800ef4:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ef7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f03:	eb 16                	jmp    800f1b <memcpy+0x2a>
		*d++ = *s++;
  800f05:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f08:	8d 50 01             	lea    0x1(%eax),%edx
  800f0b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f0e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f11:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f14:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f17:	8a 12                	mov    (%edx),%dl
  800f19:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f21:	89 55 10             	mov    %edx,0x10(%ebp)
  800f24:	85 c0                	test   %eax,%eax
  800f26:	75 dd                	jne    800f05 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f2b:	c9                   	leave  
  800f2c:	c3                   	ret    

00800f2d <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
  800f30:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f36:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f3f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f42:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f45:	73 50                	jae    800f97 <memmove+0x6a>
  800f47:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4d:	01 d0                	add    %edx,%eax
  800f4f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f52:	76 43                	jbe    800f97 <memmove+0x6a>
		s += n;
  800f54:	8b 45 10             	mov    0x10(%ebp),%eax
  800f57:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f5a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5d:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f60:	eb 10                	jmp    800f72 <memmove+0x45>
			*--d = *--s;
  800f62:	ff 4d f8             	decl   -0x8(%ebp)
  800f65:	ff 4d fc             	decl   -0x4(%ebp)
  800f68:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f6b:	8a 10                	mov    (%eax),%dl
  800f6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f70:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f72:	8b 45 10             	mov    0x10(%ebp),%eax
  800f75:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f78:	89 55 10             	mov    %edx,0x10(%ebp)
  800f7b:	85 c0                	test   %eax,%eax
  800f7d:	75 e3                	jne    800f62 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f7f:	eb 23                	jmp    800fa4 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f81:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f84:	8d 50 01             	lea    0x1(%eax),%edx
  800f87:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f8a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f8d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f90:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f93:	8a 12                	mov    (%edx),%dl
  800f95:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f97:	8b 45 10             	mov    0x10(%ebp),%eax
  800f9a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f9d:	89 55 10             	mov    %edx,0x10(%ebp)
  800fa0:	85 c0                	test   %eax,%eax
  800fa2:	75 dd                	jne    800f81 <memmove+0x54>
			*d++ = *s++;

	return dst;
  800fa4:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fa7:	c9                   	leave  
  800fa8:	c3                   	ret    

00800fa9 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800fa9:	55                   	push   %ebp
  800faa:	89 e5                	mov    %esp,%ebp
  800fac:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800fb5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb8:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800fbb:	eb 2a                	jmp    800fe7 <memcmp+0x3e>
		if (*s1 != *s2)
  800fbd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fc0:	8a 10                	mov    (%eax),%dl
  800fc2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc5:	8a 00                	mov    (%eax),%al
  800fc7:	38 c2                	cmp    %al,%dl
  800fc9:	74 16                	je     800fe1 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800fcb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fce:	8a 00                	mov    (%eax),%al
  800fd0:	0f b6 d0             	movzbl %al,%edx
  800fd3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd6:	8a 00                	mov    (%eax),%al
  800fd8:	0f b6 c0             	movzbl %al,%eax
  800fdb:	29 c2                	sub    %eax,%edx
  800fdd:	89 d0                	mov    %edx,%eax
  800fdf:	eb 18                	jmp    800ff9 <memcmp+0x50>
		s1++, s2++;
  800fe1:	ff 45 fc             	incl   -0x4(%ebp)
  800fe4:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fe7:	8b 45 10             	mov    0x10(%ebp),%eax
  800fea:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fed:	89 55 10             	mov    %edx,0x10(%ebp)
  800ff0:	85 c0                	test   %eax,%eax
  800ff2:	75 c9                	jne    800fbd <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800ff4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800ff9:	c9                   	leave  
  800ffa:	c3                   	ret    

00800ffb <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800ffb:	55                   	push   %ebp
  800ffc:	89 e5                	mov    %esp,%ebp
  800ffe:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801001:	8b 55 08             	mov    0x8(%ebp),%edx
  801004:	8b 45 10             	mov    0x10(%ebp),%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80100c:	eb 15                	jmp    801023 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	0f b6 d0             	movzbl %al,%edx
  801016:	8b 45 0c             	mov    0xc(%ebp),%eax
  801019:	0f b6 c0             	movzbl %al,%eax
  80101c:	39 c2                	cmp    %eax,%edx
  80101e:	74 0d                	je     80102d <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801020:	ff 45 08             	incl   0x8(%ebp)
  801023:	8b 45 08             	mov    0x8(%ebp),%eax
  801026:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801029:	72 e3                	jb     80100e <memfind+0x13>
  80102b:	eb 01                	jmp    80102e <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  80102d:	90                   	nop
	return (void *) s;
  80102e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801031:	c9                   	leave  
  801032:	c3                   	ret    

00801033 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801033:	55                   	push   %ebp
  801034:	89 e5                	mov    %esp,%ebp
  801036:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801039:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801040:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801047:	eb 03                	jmp    80104c <strtol+0x19>
		s++;
  801049:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	8a 00                	mov    (%eax),%al
  801051:	3c 20                	cmp    $0x20,%al
  801053:	74 f4                	je     801049 <strtol+0x16>
  801055:	8b 45 08             	mov    0x8(%ebp),%eax
  801058:	8a 00                	mov    (%eax),%al
  80105a:	3c 09                	cmp    $0x9,%al
  80105c:	74 eb                	je     801049 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80105e:	8b 45 08             	mov    0x8(%ebp),%eax
  801061:	8a 00                	mov    (%eax),%al
  801063:	3c 2b                	cmp    $0x2b,%al
  801065:	75 05                	jne    80106c <strtol+0x39>
		s++;
  801067:	ff 45 08             	incl   0x8(%ebp)
  80106a:	eb 13                	jmp    80107f <strtol+0x4c>
	else if (*s == '-')
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	3c 2d                	cmp    $0x2d,%al
  801073:	75 0a                	jne    80107f <strtol+0x4c>
		s++, neg = 1;
  801075:	ff 45 08             	incl   0x8(%ebp)
  801078:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80107f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801083:	74 06                	je     80108b <strtol+0x58>
  801085:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801089:	75 20                	jne    8010ab <strtol+0x78>
  80108b:	8b 45 08             	mov    0x8(%ebp),%eax
  80108e:	8a 00                	mov    (%eax),%al
  801090:	3c 30                	cmp    $0x30,%al
  801092:	75 17                	jne    8010ab <strtol+0x78>
  801094:	8b 45 08             	mov    0x8(%ebp),%eax
  801097:	40                   	inc    %eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	3c 78                	cmp    $0x78,%al
  80109c:	75 0d                	jne    8010ab <strtol+0x78>
		s += 2, base = 16;
  80109e:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010a2:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010a9:	eb 28                	jmp    8010d3 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010ab:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010af:	75 15                	jne    8010c6 <strtol+0x93>
  8010b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b4:	8a 00                	mov    (%eax),%al
  8010b6:	3c 30                	cmp    $0x30,%al
  8010b8:	75 0c                	jne    8010c6 <strtol+0x93>
		s++, base = 8;
  8010ba:	ff 45 08             	incl   0x8(%ebp)
  8010bd:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8010c4:	eb 0d                	jmp    8010d3 <strtol+0xa0>
	else if (base == 0)
  8010c6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010ca:	75 07                	jne    8010d3 <strtol+0xa0>
		base = 10;
  8010cc:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d6:	8a 00                	mov    (%eax),%al
  8010d8:	3c 2f                	cmp    $0x2f,%al
  8010da:	7e 19                	jle    8010f5 <strtol+0xc2>
  8010dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010df:	8a 00                	mov    (%eax),%al
  8010e1:	3c 39                	cmp    $0x39,%al
  8010e3:	7f 10                	jg     8010f5 <strtol+0xc2>
			dig = *s - '0';
  8010e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e8:	8a 00                	mov    (%eax),%al
  8010ea:	0f be c0             	movsbl %al,%eax
  8010ed:	83 e8 30             	sub    $0x30,%eax
  8010f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010f3:	eb 42                	jmp    801137 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f8:	8a 00                	mov    (%eax),%al
  8010fa:	3c 60                	cmp    $0x60,%al
  8010fc:	7e 19                	jle    801117 <strtol+0xe4>
  8010fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801101:	8a 00                	mov    (%eax),%al
  801103:	3c 7a                	cmp    $0x7a,%al
  801105:	7f 10                	jg     801117 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801107:	8b 45 08             	mov    0x8(%ebp),%eax
  80110a:	8a 00                	mov    (%eax),%al
  80110c:	0f be c0             	movsbl %al,%eax
  80110f:	83 e8 57             	sub    $0x57,%eax
  801112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801115:	eb 20                	jmp    801137 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801117:	8b 45 08             	mov    0x8(%ebp),%eax
  80111a:	8a 00                	mov    (%eax),%al
  80111c:	3c 40                	cmp    $0x40,%al
  80111e:	7e 39                	jle    801159 <strtol+0x126>
  801120:	8b 45 08             	mov    0x8(%ebp),%eax
  801123:	8a 00                	mov    (%eax),%al
  801125:	3c 5a                	cmp    $0x5a,%al
  801127:	7f 30                	jg     801159 <strtol+0x126>
			dig = *s - 'A' + 10;
  801129:	8b 45 08             	mov    0x8(%ebp),%eax
  80112c:	8a 00                	mov    (%eax),%al
  80112e:	0f be c0             	movsbl %al,%eax
  801131:	83 e8 37             	sub    $0x37,%eax
  801134:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801137:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80113a:	3b 45 10             	cmp    0x10(%ebp),%eax
  80113d:	7d 19                	jge    801158 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80113f:	ff 45 08             	incl   0x8(%ebp)
  801142:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801145:	0f af 45 10          	imul   0x10(%ebp),%eax
  801149:	89 c2                	mov    %eax,%edx
  80114b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80114e:	01 d0                	add    %edx,%eax
  801150:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801153:	e9 7b ff ff ff       	jmp    8010d3 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801158:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801159:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80115d:	74 08                	je     801167 <strtol+0x134>
		*endptr = (char *) s;
  80115f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801162:	8b 55 08             	mov    0x8(%ebp),%edx
  801165:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801167:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80116b:	74 07                	je     801174 <strtol+0x141>
  80116d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801170:	f7 d8                	neg    %eax
  801172:	eb 03                	jmp    801177 <strtol+0x144>
  801174:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801177:	c9                   	leave  
  801178:	c3                   	ret    

00801179 <ltostr>:

void
ltostr(long value, char *str)
{
  801179:	55                   	push   %ebp
  80117a:	89 e5                	mov    %esp,%ebp
  80117c:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80117f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801186:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80118d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801191:	79 13                	jns    8011a6 <ltostr+0x2d>
	{
		neg = 1;
  801193:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80119a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119d:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011a0:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011a3:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011ae:	99                   	cltd   
  8011af:	f7 f9                	idiv   %ecx
  8011b1:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8011b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011b7:	8d 50 01             	lea    0x1(%eax),%edx
  8011ba:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8011bd:	89 c2                	mov    %eax,%edx
  8011bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c2:	01 d0                	add    %edx,%eax
  8011c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011c7:	83 c2 30             	add    $0x30,%edx
  8011ca:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8011cc:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011cf:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011d4:	f7 e9                	imul   %ecx
  8011d6:	c1 fa 02             	sar    $0x2,%edx
  8011d9:	89 c8                	mov    %ecx,%eax
  8011db:	c1 f8 1f             	sar    $0x1f,%eax
  8011de:	29 c2                	sub    %eax,%edx
  8011e0:	89 d0                	mov    %edx,%eax
  8011e2:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011e5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011e8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ed:	f7 e9                	imul   %ecx
  8011ef:	c1 fa 02             	sar    $0x2,%edx
  8011f2:	89 c8                	mov    %ecx,%eax
  8011f4:	c1 f8 1f             	sar    $0x1f,%eax
  8011f7:	29 c2                	sub    %eax,%edx
  8011f9:	89 d0                	mov    %edx,%eax
  8011fb:	c1 e0 02             	shl    $0x2,%eax
  8011fe:	01 d0                	add    %edx,%eax
  801200:	01 c0                	add    %eax,%eax
  801202:	29 c1                	sub    %eax,%ecx
  801204:	89 ca                	mov    %ecx,%edx
  801206:	85 d2                	test   %edx,%edx
  801208:	75 9c                	jne    8011a6 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80120a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801211:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801214:	48                   	dec    %eax
  801215:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801218:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80121c:	74 3d                	je     80125b <ltostr+0xe2>
		start = 1 ;
  80121e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801225:	eb 34                	jmp    80125b <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801227:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80122a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122d:	01 d0                	add    %edx,%eax
  80122f:	8a 00                	mov    (%eax),%al
  801231:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801234:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	01 c2                	add    %eax,%edx
  80123c:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80123f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801242:	01 c8                	add    %ecx,%eax
  801244:	8a 00                	mov    (%eax),%al
  801246:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801248:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80124b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124e:	01 c2                	add    %eax,%edx
  801250:	8a 45 eb             	mov    -0x15(%ebp),%al
  801253:	88 02                	mov    %al,(%edx)
		start++ ;
  801255:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801258:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  80125b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801261:	7c c4                	jl     801227 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801263:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801266:	8b 45 0c             	mov    0xc(%ebp),%eax
  801269:	01 d0                	add    %edx,%eax
  80126b:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80126e:	90                   	nop
  80126f:	c9                   	leave  
  801270:	c3                   	ret    

00801271 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801271:	55                   	push   %ebp
  801272:	89 e5                	mov    %esp,%ebp
  801274:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801277:	ff 75 08             	pushl  0x8(%ebp)
  80127a:	e8 54 fa ff ff       	call   800cd3 <strlen>
  80127f:	83 c4 04             	add    $0x4,%esp
  801282:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801285:	ff 75 0c             	pushl  0xc(%ebp)
  801288:	e8 46 fa ff ff       	call   800cd3 <strlen>
  80128d:	83 c4 04             	add    $0x4,%esp
  801290:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801293:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80129a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012a1:	eb 17                	jmp    8012ba <strcconcat+0x49>
		final[s] = str1[s] ;
  8012a3:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8012a9:	01 c2                	add    %eax,%edx
  8012ab:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b1:	01 c8                	add    %ecx,%eax
  8012b3:	8a 00                	mov    (%eax),%al
  8012b5:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8012b7:	ff 45 fc             	incl   -0x4(%ebp)
  8012ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012bd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8012c0:	7c e1                	jl     8012a3 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8012c2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8012c9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8012d0:	eb 1f                	jmp    8012f1 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8012d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d5:	8d 50 01             	lea    0x1(%eax),%edx
  8012d8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012db:	89 c2                	mov    %eax,%edx
  8012dd:	8b 45 10             	mov    0x10(%ebp),%eax
  8012e0:	01 c2                	add    %eax,%edx
  8012e2:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e8:	01 c8                	add    %ecx,%eax
  8012ea:	8a 00                	mov    (%eax),%al
  8012ec:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012ee:	ff 45 f8             	incl   -0x8(%ebp)
  8012f1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012f7:	7c d9                	jl     8012d2 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012f9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ff:	01 d0                	add    %edx,%eax
  801301:	c6 00 00             	movb   $0x0,(%eax)
}
  801304:	90                   	nop
  801305:	c9                   	leave  
  801306:	c3                   	ret    

00801307 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801307:	55                   	push   %ebp
  801308:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80130a:	8b 45 14             	mov    0x14(%ebp),%eax
  80130d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801313:	8b 45 14             	mov    0x14(%ebp),%eax
  801316:	8b 00                	mov    (%eax),%eax
  801318:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80131f:	8b 45 10             	mov    0x10(%ebp),%eax
  801322:	01 d0                	add    %edx,%eax
  801324:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80132a:	eb 0c                	jmp    801338 <strsplit+0x31>
			*string++ = 0;
  80132c:	8b 45 08             	mov    0x8(%ebp),%eax
  80132f:	8d 50 01             	lea    0x1(%eax),%edx
  801332:	89 55 08             	mov    %edx,0x8(%ebp)
  801335:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801338:	8b 45 08             	mov    0x8(%ebp),%eax
  80133b:	8a 00                	mov    (%eax),%al
  80133d:	84 c0                	test   %al,%al
  80133f:	74 18                	je     801359 <strsplit+0x52>
  801341:	8b 45 08             	mov    0x8(%ebp),%eax
  801344:	8a 00                	mov    (%eax),%al
  801346:	0f be c0             	movsbl %al,%eax
  801349:	50                   	push   %eax
  80134a:	ff 75 0c             	pushl  0xc(%ebp)
  80134d:	e8 13 fb ff ff       	call   800e65 <strchr>
  801352:	83 c4 08             	add    $0x8,%esp
  801355:	85 c0                	test   %eax,%eax
  801357:	75 d3                	jne    80132c <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	8a 00                	mov    (%eax),%al
  80135e:	84 c0                	test   %al,%al
  801360:	74 5a                	je     8013bc <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801362:	8b 45 14             	mov    0x14(%ebp),%eax
  801365:	8b 00                	mov    (%eax),%eax
  801367:	83 f8 0f             	cmp    $0xf,%eax
  80136a:	75 07                	jne    801373 <strsplit+0x6c>
		{
			return 0;
  80136c:	b8 00 00 00 00       	mov    $0x0,%eax
  801371:	eb 66                	jmp    8013d9 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801373:	8b 45 14             	mov    0x14(%ebp),%eax
  801376:	8b 00                	mov    (%eax),%eax
  801378:	8d 48 01             	lea    0x1(%eax),%ecx
  80137b:	8b 55 14             	mov    0x14(%ebp),%edx
  80137e:	89 0a                	mov    %ecx,(%edx)
  801380:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801387:	8b 45 10             	mov    0x10(%ebp),%eax
  80138a:	01 c2                	add    %eax,%edx
  80138c:	8b 45 08             	mov    0x8(%ebp),%eax
  80138f:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801391:	eb 03                	jmp    801396 <strsplit+0x8f>
			string++;
  801393:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801396:	8b 45 08             	mov    0x8(%ebp),%eax
  801399:	8a 00                	mov    (%eax),%al
  80139b:	84 c0                	test   %al,%al
  80139d:	74 8b                	je     80132a <strsplit+0x23>
  80139f:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a2:	8a 00                	mov    (%eax),%al
  8013a4:	0f be c0             	movsbl %al,%eax
  8013a7:	50                   	push   %eax
  8013a8:	ff 75 0c             	pushl  0xc(%ebp)
  8013ab:	e8 b5 fa ff ff       	call   800e65 <strchr>
  8013b0:	83 c4 08             	add    $0x8,%esp
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 dc                	je     801393 <strsplit+0x8c>
			string++;
	}
  8013b7:	e9 6e ff ff ff       	jmp    80132a <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8013bc:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8013bd:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c0:	8b 00                	mov    (%eax),%eax
  8013c2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8013cc:	01 d0                	add    %edx,%eax
  8013ce:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013d4:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013d9:	c9                   	leave  
  8013da:	c3                   	ret    

008013db <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013db:	55                   	push   %ebp
  8013dc:	89 e5                	mov    %esp,%ebp
  8013de:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013e1:	a1 04 40 80 00       	mov    0x804004,%eax
  8013e6:	85 c0                	test   %eax,%eax
  8013e8:	74 1f                	je     801409 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013ea:	e8 1d 00 00 00       	call   80140c <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013ef:	83 ec 0c             	sub    $0xc,%esp
  8013f2:	68 b0 3a 80 00       	push   $0x803ab0
  8013f7:	e8 55 f2 ff ff       	call   800651 <cprintf>
  8013fc:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013ff:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801406:	00 00 00 
	}
}
  801409:	90                   	nop
  80140a:	c9                   	leave  
  80140b:	c3                   	ret    

0080140c <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80140c:	55                   	push   %ebp
  80140d:	89 e5                	mov    %esp,%ebp
  80140f:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801412:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801419:	00 00 00 
  80141c:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  801423:	00 00 00 
  801426:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  80142d:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801430:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801437:	00 00 00 
  80143a:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  801441:	00 00 00 
  801444:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  80144b:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  80144e:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801455:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801458:	c1 e8 0c             	shr    $0xc,%eax
  80145b:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801460:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801467:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80146a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80146f:	2d 00 10 00 00       	sub    $0x1000,%eax
  801474:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  801479:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801480:	a1 20 41 80 00       	mov    0x804120,%eax
  801485:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801489:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  80148c:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801493:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801496:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801499:	01 d0                	add    %edx,%eax
  80149b:	48                   	dec    %eax
  80149c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80149f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8014a7:	f7 75 e4             	divl   -0x1c(%ebp)
  8014aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8014ad:	29 d0                	sub    %edx,%eax
  8014af:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8014b2:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8014b9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8014bc:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8014c1:	2d 00 10 00 00       	sub    $0x1000,%eax
  8014c6:	83 ec 04             	sub    $0x4,%esp
  8014c9:	6a 07                	push   $0x7
  8014cb:	ff 75 e8             	pushl  -0x18(%ebp)
  8014ce:	50                   	push   %eax
  8014cf:	e8 3d 06 00 00       	call   801b11 <sys_allocate_chunk>
  8014d4:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014d7:	a1 20 41 80 00       	mov    0x804120,%eax
  8014dc:	83 ec 0c             	sub    $0xc,%esp
  8014df:	50                   	push   %eax
  8014e0:	e8 b2 0c 00 00       	call   802197 <initialize_MemBlocksList>
  8014e5:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8014e8:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8014ed:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8014f0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014f4:	0f 84 f3 00 00 00    	je     8015ed <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8014fa:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014fe:	75 14                	jne    801514 <initialize_dyn_block_system+0x108>
  801500:	83 ec 04             	sub    $0x4,%esp
  801503:	68 d5 3a 80 00       	push   $0x803ad5
  801508:	6a 36                	push   $0x36
  80150a:	68 f3 3a 80 00       	push   $0x803af3
  80150f:	e8 89 ee ff ff       	call   80039d <_panic>
  801514:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801517:	8b 00                	mov    (%eax),%eax
  801519:	85 c0                	test   %eax,%eax
  80151b:	74 10                	je     80152d <initialize_dyn_block_system+0x121>
  80151d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801520:	8b 00                	mov    (%eax),%eax
  801522:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801525:	8b 52 04             	mov    0x4(%edx),%edx
  801528:	89 50 04             	mov    %edx,0x4(%eax)
  80152b:	eb 0b                	jmp    801538 <initialize_dyn_block_system+0x12c>
  80152d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801530:	8b 40 04             	mov    0x4(%eax),%eax
  801533:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801538:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80153b:	8b 40 04             	mov    0x4(%eax),%eax
  80153e:	85 c0                	test   %eax,%eax
  801540:	74 0f                	je     801551 <initialize_dyn_block_system+0x145>
  801542:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801545:	8b 40 04             	mov    0x4(%eax),%eax
  801548:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80154b:	8b 12                	mov    (%edx),%edx
  80154d:	89 10                	mov    %edx,(%eax)
  80154f:	eb 0a                	jmp    80155b <initialize_dyn_block_system+0x14f>
  801551:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801554:	8b 00                	mov    (%eax),%eax
  801556:	a3 48 41 80 00       	mov    %eax,0x804148
  80155b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80155e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801564:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801567:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80156e:	a1 54 41 80 00       	mov    0x804154,%eax
  801573:	48                   	dec    %eax
  801574:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801579:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80157c:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801583:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801586:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  80158d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801591:	75 14                	jne    8015a7 <initialize_dyn_block_system+0x19b>
  801593:	83 ec 04             	sub    $0x4,%esp
  801596:	68 00 3b 80 00       	push   $0x803b00
  80159b:	6a 3e                	push   $0x3e
  80159d:	68 f3 3a 80 00       	push   $0x803af3
  8015a2:	e8 f6 ed ff ff       	call   80039d <_panic>
  8015a7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8015ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015b0:	89 10                	mov    %edx,(%eax)
  8015b2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015b5:	8b 00                	mov    (%eax),%eax
  8015b7:	85 c0                	test   %eax,%eax
  8015b9:	74 0d                	je     8015c8 <initialize_dyn_block_system+0x1bc>
  8015bb:	a1 38 41 80 00       	mov    0x804138,%eax
  8015c0:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8015c3:	89 50 04             	mov    %edx,0x4(%eax)
  8015c6:	eb 08                	jmp    8015d0 <initialize_dyn_block_system+0x1c4>
  8015c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015cb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8015d0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015d3:	a3 38 41 80 00       	mov    %eax,0x804138
  8015d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015db:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015e2:	a1 44 41 80 00       	mov    0x804144,%eax
  8015e7:	40                   	inc    %eax
  8015e8:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8015ed:	90                   	nop
  8015ee:	c9                   	leave  
  8015ef:	c3                   	ret    

008015f0 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015f0:	55                   	push   %ebp
  8015f1:	89 e5                	mov    %esp,%ebp
  8015f3:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8015f6:	e8 e0 fd ff ff       	call   8013db <InitializeUHeap>
		if (size == 0) return NULL ;
  8015fb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015ff:	75 07                	jne    801608 <malloc+0x18>
  801601:	b8 00 00 00 00       	mov    $0x0,%eax
  801606:	eb 7f                	jmp    801687 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801608:	e8 d2 08 00 00       	call   801edf <sys_isUHeapPlacementStrategyFIRSTFIT>
  80160d:	85 c0                	test   %eax,%eax
  80160f:	74 71                	je     801682 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801611:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801618:	8b 55 08             	mov    0x8(%ebp),%edx
  80161b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80161e:	01 d0                	add    %edx,%eax
  801620:	48                   	dec    %eax
  801621:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801624:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801627:	ba 00 00 00 00       	mov    $0x0,%edx
  80162c:	f7 75 f4             	divl   -0xc(%ebp)
  80162f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801632:	29 d0                	sub    %edx,%eax
  801634:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801637:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  80163e:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801645:	76 07                	jbe    80164e <malloc+0x5e>
					return NULL ;
  801647:	b8 00 00 00 00       	mov    $0x0,%eax
  80164c:	eb 39                	jmp    801687 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  80164e:	83 ec 0c             	sub    $0xc,%esp
  801651:	ff 75 08             	pushl  0x8(%ebp)
  801654:	e8 e6 0d 00 00       	call   80243f <alloc_block_FF>
  801659:	83 c4 10             	add    $0x10,%esp
  80165c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  80165f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801663:	74 16                	je     80167b <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801665:	83 ec 0c             	sub    $0xc,%esp
  801668:	ff 75 ec             	pushl  -0x14(%ebp)
  80166b:	e8 37 0c 00 00       	call   8022a7 <insert_sorted_allocList>
  801670:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801673:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801676:	8b 40 08             	mov    0x8(%eax),%eax
  801679:	eb 0c                	jmp    801687 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  80167b:	b8 00 00 00 00       	mov    $0x0,%eax
  801680:	eb 05                	jmp    801687 <malloc+0x97>
				}
		}
	return 0;
  801682:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801687:	c9                   	leave  
  801688:	c3                   	ret    

00801689 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801689:	55                   	push   %ebp
  80168a:	89 e5                	mov    %esp,%ebp
  80168c:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  80168f:	8b 45 08             	mov    0x8(%ebp),%eax
  801692:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801695:	83 ec 08             	sub    $0x8,%esp
  801698:	ff 75 f4             	pushl  -0xc(%ebp)
  80169b:	68 40 40 80 00       	push   $0x804040
  8016a0:	e8 cf 0b 00 00       	call   802274 <find_block>
  8016a5:	83 c4 10             	add    $0x10,%esp
  8016a8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8016ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8016b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8016b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b7:	8b 40 08             	mov    0x8(%eax),%eax
  8016ba:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8016bd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016c1:	0f 84 a1 00 00 00    	je     801768 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8016c7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016cb:	75 17                	jne    8016e4 <free+0x5b>
  8016cd:	83 ec 04             	sub    $0x4,%esp
  8016d0:	68 d5 3a 80 00       	push   $0x803ad5
  8016d5:	68 80 00 00 00       	push   $0x80
  8016da:	68 f3 3a 80 00       	push   $0x803af3
  8016df:	e8 b9 ec ff ff       	call   80039d <_panic>
  8016e4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e7:	8b 00                	mov    (%eax),%eax
  8016e9:	85 c0                	test   %eax,%eax
  8016eb:	74 10                	je     8016fd <free+0x74>
  8016ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f0:	8b 00                	mov    (%eax),%eax
  8016f2:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016f5:	8b 52 04             	mov    0x4(%edx),%edx
  8016f8:	89 50 04             	mov    %edx,0x4(%eax)
  8016fb:	eb 0b                	jmp    801708 <free+0x7f>
  8016fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801700:	8b 40 04             	mov    0x4(%eax),%eax
  801703:	a3 44 40 80 00       	mov    %eax,0x804044
  801708:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80170b:	8b 40 04             	mov    0x4(%eax),%eax
  80170e:	85 c0                	test   %eax,%eax
  801710:	74 0f                	je     801721 <free+0x98>
  801712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801715:	8b 40 04             	mov    0x4(%eax),%eax
  801718:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80171b:	8b 12                	mov    (%edx),%edx
  80171d:	89 10                	mov    %edx,(%eax)
  80171f:	eb 0a                	jmp    80172b <free+0xa2>
  801721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801724:	8b 00                	mov    (%eax),%eax
  801726:	a3 40 40 80 00       	mov    %eax,0x804040
  80172b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80172e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801737:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80173e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801743:	48                   	dec    %eax
  801744:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  801749:	83 ec 0c             	sub    $0xc,%esp
  80174c:	ff 75 f0             	pushl  -0x10(%ebp)
  80174f:	e8 29 12 00 00       	call   80297d <insert_sorted_with_merge_freeList>
  801754:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801757:	83 ec 08             	sub    $0x8,%esp
  80175a:	ff 75 ec             	pushl  -0x14(%ebp)
  80175d:	ff 75 e8             	pushl  -0x18(%ebp)
  801760:	e8 74 03 00 00       	call   801ad9 <sys_free_user_mem>
  801765:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801768:	90                   	nop
  801769:	c9                   	leave  
  80176a:	c3                   	ret    

0080176b <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  80176b:	55                   	push   %ebp
  80176c:	89 e5                	mov    %esp,%ebp
  80176e:	83 ec 38             	sub    $0x38,%esp
  801771:	8b 45 10             	mov    0x10(%ebp),%eax
  801774:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801777:	e8 5f fc ff ff       	call   8013db <InitializeUHeap>
	if (size == 0) return NULL ;
  80177c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801780:	75 0a                	jne    80178c <smalloc+0x21>
  801782:	b8 00 00 00 00       	mov    $0x0,%eax
  801787:	e9 b2 00 00 00       	jmp    80183e <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  80178c:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801793:	76 0a                	jbe    80179f <smalloc+0x34>
		return NULL;
  801795:	b8 00 00 00 00       	mov    $0x0,%eax
  80179a:	e9 9f 00 00 00       	jmp    80183e <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80179f:	e8 3b 07 00 00       	call   801edf <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017a4:	85 c0                	test   %eax,%eax
  8017a6:	0f 84 8d 00 00 00    	je     801839 <smalloc+0xce>
	struct MemBlock *b = NULL;
  8017ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8017b3:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8017ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017c0:	01 d0                	add    %edx,%eax
  8017c2:	48                   	dec    %eax
  8017c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8017c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017c9:	ba 00 00 00 00       	mov    $0x0,%edx
  8017ce:	f7 75 f0             	divl   -0x10(%ebp)
  8017d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017d4:	29 d0                	sub    %edx,%eax
  8017d6:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8017d9:	83 ec 0c             	sub    $0xc,%esp
  8017dc:	ff 75 e8             	pushl  -0x18(%ebp)
  8017df:	e8 5b 0c 00 00       	call   80243f <alloc_block_FF>
  8017e4:	83 c4 10             	add    $0x10,%esp
  8017e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8017ea:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017ee:	75 07                	jne    8017f7 <smalloc+0x8c>
			return NULL;
  8017f0:	b8 00 00 00 00       	mov    $0x0,%eax
  8017f5:	eb 47                	jmp    80183e <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8017f7:	83 ec 0c             	sub    $0xc,%esp
  8017fa:	ff 75 f4             	pushl  -0xc(%ebp)
  8017fd:	e8 a5 0a 00 00       	call   8022a7 <insert_sorted_allocList>
  801802:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801808:	8b 40 08             	mov    0x8(%eax),%eax
  80180b:	89 c2                	mov    %eax,%edx
  80180d:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801811:	52                   	push   %edx
  801812:	50                   	push   %eax
  801813:	ff 75 0c             	pushl  0xc(%ebp)
  801816:	ff 75 08             	pushl  0x8(%ebp)
  801819:	e8 46 04 00 00       	call   801c64 <sys_createSharedObject>
  80181e:	83 c4 10             	add    $0x10,%esp
  801821:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801824:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801828:	78 08                	js     801832 <smalloc+0xc7>
		return (void *)b->sva;
  80182a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80182d:	8b 40 08             	mov    0x8(%eax),%eax
  801830:	eb 0c                	jmp    80183e <smalloc+0xd3>
		}else{
		return NULL;
  801832:	b8 00 00 00 00       	mov    $0x0,%eax
  801837:	eb 05                	jmp    80183e <smalloc+0xd3>
			}

	}return NULL;
  801839:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80183e:	c9                   	leave  
  80183f:	c3                   	ret    

00801840 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801840:	55                   	push   %ebp
  801841:	89 e5                	mov    %esp,%ebp
  801843:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801846:	e8 90 fb ff ff       	call   8013db <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  80184b:	e8 8f 06 00 00       	call   801edf <sys_isUHeapPlacementStrategyFIRSTFIT>
  801850:	85 c0                	test   %eax,%eax
  801852:	0f 84 ad 00 00 00    	je     801905 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801858:	83 ec 08             	sub    $0x8,%esp
  80185b:	ff 75 0c             	pushl  0xc(%ebp)
  80185e:	ff 75 08             	pushl  0x8(%ebp)
  801861:	e8 28 04 00 00       	call   801c8e <sys_getSizeOfSharedObject>
  801866:	83 c4 10             	add    $0x10,%esp
  801869:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  80186c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801870:	79 0a                	jns    80187c <sget+0x3c>
    {
    	return NULL;
  801872:	b8 00 00 00 00       	mov    $0x0,%eax
  801877:	e9 8e 00 00 00       	jmp    80190a <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  80187c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801883:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  80188a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80188d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801890:	01 d0                	add    %edx,%eax
  801892:	48                   	dec    %eax
  801893:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801896:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801899:	ba 00 00 00 00       	mov    $0x0,%edx
  80189e:	f7 75 ec             	divl   -0x14(%ebp)
  8018a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8018a4:	29 d0                	sub    %edx,%eax
  8018a6:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8018a9:	83 ec 0c             	sub    $0xc,%esp
  8018ac:	ff 75 e4             	pushl  -0x1c(%ebp)
  8018af:	e8 8b 0b 00 00       	call   80243f <alloc_block_FF>
  8018b4:	83 c4 10             	add    $0x10,%esp
  8018b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8018ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8018be:	75 07                	jne    8018c7 <sget+0x87>
				return NULL;
  8018c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8018c5:	eb 43                	jmp    80190a <sget+0xca>
			}
			insert_sorted_allocList(b);
  8018c7:	83 ec 0c             	sub    $0xc,%esp
  8018ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8018cd:	e8 d5 09 00 00       	call   8022a7 <insert_sorted_allocList>
  8018d2:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8018d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018d8:	8b 40 08             	mov    0x8(%eax),%eax
  8018db:	83 ec 04             	sub    $0x4,%esp
  8018de:	50                   	push   %eax
  8018df:	ff 75 0c             	pushl  0xc(%ebp)
  8018e2:	ff 75 08             	pushl  0x8(%ebp)
  8018e5:	e8 c1 03 00 00       	call   801cab <sys_getSharedObject>
  8018ea:	83 c4 10             	add    $0x10,%esp
  8018ed:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8018f0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018f4:	78 08                	js     8018fe <sget+0xbe>
			return (void *)b->sva;
  8018f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018f9:	8b 40 08             	mov    0x8(%eax),%eax
  8018fc:	eb 0c                	jmp    80190a <sget+0xca>
			}else{
			return NULL;
  8018fe:	b8 00 00 00 00       	mov    $0x0,%eax
  801903:	eb 05                	jmp    80190a <sget+0xca>
			}
    }}return NULL;
  801905:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80190a:	c9                   	leave  
  80190b:	c3                   	ret    

0080190c <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  80190c:	55                   	push   %ebp
  80190d:	89 e5                	mov    %esp,%ebp
  80190f:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801912:	e8 c4 fa ff ff       	call   8013db <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801917:	83 ec 04             	sub    $0x4,%esp
  80191a:	68 24 3b 80 00       	push   $0x803b24
  80191f:	68 03 01 00 00       	push   $0x103
  801924:	68 f3 3a 80 00       	push   $0x803af3
  801929:	e8 6f ea ff ff       	call   80039d <_panic>

0080192e <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  80192e:	55                   	push   %ebp
  80192f:	89 e5                	mov    %esp,%ebp
  801931:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801934:	83 ec 04             	sub    $0x4,%esp
  801937:	68 4c 3b 80 00       	push   $0x803b4c
  80193c:	68 17 01 00 00       	push   $0x117
  801941:	68 f3 3a 80 00       	push   $0x803af3
  801946:	e8 52 ea ff ff       	call   80039d <_panic>

0080194b <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
  80194e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801951:	83 ec 04             	sub    $0x4,%esp
  801954:	68 70 3b 80 00       	push   $0x803b70
  801959:	68 22 01 00 00       	push   $0x122
  80195e:	68 f3 3a 80 00       	push   $0x803af3
  801963:	e8 35 ea ff ff       	call   80039d <_panic>

00801968 <shrink>:

}
void shrink(uint32 newSize)
{
  801968:	55                   	push   %ebp
  801969:	89 e5                	mov    %esp,%ebp
  80196b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80196e:	83 ec 04             	sub    $0x4,%esp
  801971:	68 70 3b 80 00       	push   $0x803b70
  801976:	68 27 01 00 00       	push   $0x127
  80197b:	68 f3 3a 80 00       	push   $0x803af3
  801980:	e8 18 ea ff ff       	call   80039d <_panic>

00801985 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801985:	55                   	push   %ebp
  801986:	89 e5                	mov    %esp,%ebp
  801988:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80198b:	83 ec 04             	sub    $0x4,%esp
  80198e:	68 70 3b 80 00       	push   $0x803b70
  801993:	68 2c 01 00 00       	push   $0x12c
  801998:	68 f3 3a 80 00       	push   $0x803af3
  80199d:	e8 fb e9 ff ff       	call   80039d <_panic>

008019a2 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8019a2:	55                   	push   %ebp
  8019a3:	89 e5                	mov    %esp,%ebp
  8019a5:	57                   	push   %edi
  8019a6:	56                   	push   %esi
  8019a7:	53                   	push   %ebx
  8019a8:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8019ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ae:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019b4:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019b7:	8b 7d 18             	mov    0x18(%ebp),%edi
  8019ba:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8019bd:	cd 30                	int    $0x30
  8019bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8019c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8019c5:	83 c4 10             	add    $0x10,%esp
  8019c8:	5b                   	pop    %ebx
  8019c9:	5e                   	pop    %esi
  8019ca:	5f                   	pop    %edi
  8019cb:	5d                   	pop    %ebp
  8019cc:	c3                   	ret    

008019cd <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8019cd:	55                   	push   %ebp
  8019ce:	89 e5                	mov    %esp,%ebp
  8019d0:	83 ec 04             	sub    $0x4,%esp
  8019d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019d6:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019d9:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e0:	6a 00                	push   $0x0
  8019e2:	6a 00                	push   $0x0
  8019e4:	52                   	push   %edx
  8019e5:	ff 75 0c             	pushl  0xc(%ebp)
  8019e8:	50                   	push   %eax
  8019e9:	6a 00                	push   $0x0
  8019eb:	e8 b2 ff ff ff       	call   8019a2 <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	90                   	nop
  8019f4:	c9                   	leave  
  8019f5:	c3                   	ret    

008019f6 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019f6:	55                   	push   %ebp
  8019f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019f9:	6a 00                	push   $0x0
  8019fb:	6a 00                	push   $0x0
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 01                	push   $0x1
  801a05:	e8 98 ff ff ff       	call   8019a2 <syscall>
  801a0a:	83 c4 18             	add    $0x18,%esp
}
  801a0d:	c9                   	leave  
  801a0e:	c3                   	ret    

00801a0f <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801a0f:	55                   	push   %ebp
  801a10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801a12:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a15:	8b 45 08             	mov    0x8(%ebp),%eax
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	52                   	push   %edx
  801a1f:	50                   	push   %eax
  801a20:	6a 05                	push   $0x5
  801a22:	e8 7b ff ff ff       	call   8019a2 <syscall>
  801a27:	83 c4 18             	add    $0x18,%esp
}
  801a2a:	c9                   	leave  
  801a2b:	c3                   	ret    

00801a2c <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801a2c:	55                   	push   %ebp
  801a2d:	89 e5                	mov    %esp,%ebp
  801a2f:	56                   	push   %esi
  801a30:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801a31:	8b 75 18             	mov    0x18(%ebp),%esi
  801a34:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a37:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a40:	56                   	push   %esi
  801a41:	53                   	push   %ebx
  801a42:	51                   	push   %ecx
  801a43:	52                   	push   %edx
  801a44:	50                   	push   %eax
  801a45:	6a 06                	push   $0x6
  801a47:	e8 56 ff ff ff       	call   8019a2 <syscall>
  801a4c:	83 c4 18             	add    $0x18,%esp
}
  801a4f:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a52:	5b                   	pop    %ebx
  801a53:	5e                   	pop    %esi
  801a54:	5d                   	pop    %ebp
  801a55:	c3                   	ret    

00801a56 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a56:	55                   	push   %ebp
  801a57:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a59:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a5c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a5f:	6a 00                	push   $0x0
  801a61:	6a 00                	push   $0x0
  801a63:	6a 00                	push   $0x0
  801a65:	52                   	push   %edx
  801a66:	50                   	push   %eax
  801a67:	6a 07                	push   $0x7
  801a69:	e8 34 ff ff ff       	call   8019a2 <syscall>
  801a6e:	83 c4 18             	add    $0x18,%esp
}
  801a71:	c9                   	leave  
  801a72:	c3                   	ret    

00801a73 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a73:	55                   	push   %ebp
  801a74:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a76:	6a 00                	push   $0x0
  801a78:	6a 00                	push   $0x0
  801a7a:	6a 00                	push   $0x0
  801a7c:	ff 75 0c             	pushl  0xc(%ebp)
  801a7f:	ff 75 08             	pushl  0x8(%ebp)
  801a82:	6a 08                	push   $0x8
  801a84:	e8 19 ff ff ff       	call   8019a2 <syscall>
  801a89:	83 c4 18             	add    $0x18,%esp
}
  801a8c:	c9                   	leave  
  801a8d:	c3                   	ret    

00801a8e <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a8e:	55                   	push   %ebp
  801a8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a91:	6a 00                	push   $0x0
  801a93:	6a 00                	push   $0x0
  801a95:	6a 00                	push   $0x0
  801a97:	6a 00                	push   $0x0
  801a99:	6a 00                	push   $0x0
  801a9b:	6a 09                	push   $0x9
  801a9d:	e8 00 ff ff ff       	call   8019a2 <syscall>
  801aa2:	83 c4 18             	add    $0x18,%esp
}
  801aa5:	c9                   	leave  
  801aa6:	c3                   	ret    

00801aa7 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801aa7:	55                   	push   %ebp
  801aa8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801aaa:	6a 00                	push   $0x0
  801aac:	6a 00                	push   $0x0
  801aae:	6a 00                	push   $0x0
  801ab0:	6a 00                	push   $0x0
  801ab2:	6a 00                	push   $0x0
  801ab4:	6a 0a                	push   $0xa
  801ab6:	e8 e7 fe ff ff       	call   8019a2 <syscall>
  801abb:	83 c4 18             	add    $0x18,%esp
}
  801abe:	c9                   	leave  
  801abf:	c3                   	ret    

00801ac0 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801ac0:	55                   	push   %ebp
  801ac1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 0b                	push   $0xb
  801acf:	e8 ce fe ff ff       	call   8019a2 <syscall>
  801ad4:	83 c4 18             	add    $0x18,%esp
}
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	ff 75 0c             	pushl  0xc(%ebp)
  801ae5:	ff 75 08             	pushl  0x8(%ebp)
  801ae8:	6a 0f                	push   $0xf
  801aea:	e8 b3 fe ff ff       	call   8019a2 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
	return;
  801af2:	90                   	nop
}
  801af3:	c9                   	leave  
  801af4:	c3                   	ret    

00801af5 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801af5:	55                   	push   %ebp
  801af6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801af8:	6a 00                	push   $0x0
  801afa:	6a 00                	push   $0x0
  801afc:	6a 00                	push   $0x0
  801afe:	ff 75 0c             	pushl  0xc(%ebp)
  801b01:	ff 75 08             	pushl  0x8(%ebp)
  801b04:	6a 10                	push   $0x10
  801b06:	e8 97 fe ff ff       	call   8019a2 <syscall>
  801b0b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0e:	90                   	nop
}
  801b0f:	c9                   	leave  
  801b10:	c3                   	ret    

00801b11 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801b11:	55                   	push   %ebp
  801b12:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	ff 75 10             	pushl  0x10(%ebp)
  801b1b:	ff 75 0c             	pushl  0xc(%ebp)
  801b1e:	ff 75 08             	pushl  0x8(%ebp)
  801b21:	6a 11                	push   $0x11
  801b23:	e8 7a fe ff ff       	call   8019a2 <syscall>
  801b28:	83 c4 18             	add    $0x18,%esp
	return ;
  801b2b:	90                   	nop
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 0c                	push   $0xc
  801b3d:	e8 60 fe ff ff       	call   8019a2 <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	c9                   	leave  
  801b46:	c3                   	ret    

00801b47 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b47:	55                   	push   %ebp
  801b48:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	ff 75 08             	pushl  0x8(%ebp)
  801b55:	6a 0d                	push   $0xd
  801b57:	e8 46 fe ff ff       	call   8019a2 <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	c9                   	leave  
  801b60:	c3                   	ret    

00801b61 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b61:	55                   	push   %ebp
  801b62:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	6a 0e                	push   $0xe
  801b70:	e8 2d fe ff ff       	call   8019a2 <syscall>
  801b75:	83 c4 18             	add    $0x18,%esp
}
  801b78:	90                   	nop
  801b79:	c9                   	leave  
  801b7a:	c3                   	ret    

00801b7b <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b7b:	55                   	push   %ebp
  801b7c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 00                	push   $0x0
  801b86:	6a 00                	push   $0x0
  801b88:	6a 13                	push   $0x13
  801b8a:	e8 13 fe ff ff       	call   8019a2 <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	90                   	nop
  801b93:	c9                   	leave  
  801b94:	c3                   	ret    

00801b95 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b95:	55                   	push   %ebp
  801b96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b98:	6a 00                	push   $0x0
  801b9a:	6a 00                	push   $0x0
  801b9c:	6a 00                	push   $0x0
  801b9e:	6a 00                	push   $0x0
  801ba0:	6a 00                	push   $0x0
  801ba2:	6a 14                	push   $0x14
  801ba4:	e8 f9 fd ff ff       	call   8019a2 <syscall>
  801ba9:	83 c4 18             	add    $0x18,%esp
}
  801bac:	90                   	nop
  801bad:	c9                   	leave  
  801bae:	c3                   	ret    

00801baf <sys_cputc>:


void
sys_cputc(const char c)
{
  801baf:	55                   	push   %ebp
  801bb0:	89 e5                	mov    %esp,%ebp
  801bb2:	83 ec 04             	sub    $0x4,%esp
  801bb5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bb8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801bbb:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	50                   	push   %eax
  801bc8:	6a 15                	push   $0x15
  801bca:	e8 d3 fd ff ff       	call   8019a2 <syscall>
  801bcf:	83 c4 18             	add    $0x18,%esp
}
  801bd2:	90                   	nop
  801bd3:	c9                   	leave  
  801bd4:	c3                   	ret    

00801bd5 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801bd5:	55                   	push   %ebp
  801bd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 16                	push   $0x16
  801be4:	e8 b9 fd ff ff       	call   8019a2 <syscall>
  801be9:	83 c4 18             	add    $0x18,%esp
}
  801bec:	90                   	nop
  801bed:	c9                   	leave  
  801bee:	c3                   	ret    

00801bef <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bef:	55                   	push   %ebp
  801bf0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	ff 75 0c             	pushl  0xc(%ebp)
  801bfe:	50                   	push   %eax
  801bff:	6a 17                	push   $0x17
  801c01:	e8 9c fd ff ff       	call   8019a2 <syscall>
  801c06:	83 c4 18             	add    $0x18,%esp
}
  801c09:	c9                   	leave  
  801c0a:	c3                   	ret    

00801c0b <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801c0b:	55                   	push   %ebp
  801c0c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c0e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c11:	8b 45 08             	mov    0x8(%ebp),%eax
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	52                   	push   %edx
  801c1b:	50                   	push   %eax
  801c1c:	6a 1a                	push   $0x1a
  801c1e:	e8 7f fd ff ff       	call   8019a2 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
}
  801c26:	c9                   	leave  
  801c27:	c3                   	ret    

00801c28 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c28:	55                   	push   %ebp
  801c29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c2b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c31:	6a 00                	push   $0x0
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	52                   	push   %edx
  801c38:	50                   	push   %eax
  801c39:	6a 18                	push   $0x18
  801c3b:	e8 62 fd ff ff       	call   8019a2 <syscall>
  801c40:	83 c4 18             	add    $0x18,%esp
}
  801c43:	90                   	nop
  801c44:	c9                   	leave  
  801c45:	c3                   	ret    

00801c46 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c46:	55                   	push   %ebp
  801c47:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c4f:	6a 00                	push   $0x0
  801c51:	6a 00                	push   $0x0
  801c53:	6a 00                	push   $0x0
  801c55:	52                   	push   %edx
  801c56:	50                   	push   %eax
  801c57:	6a 19                	push   $0x19
  801c59:	e8 44 fd ff ff       	call   8019a2 <syscall>
  801c5e:	83 c4 18             	add    $0x18,%esp
}
  801c61:	90                   	nop
  801c62:	c9                   	leave  
  801c63:	c3                   	ret    

00801c64 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c64:	55                   	push   %ebp
  801c65:	89 e5                	mov    %esp,%ebp
  801c67:	83 ec 04             	sub    $0x4,%esp
  801c6a:	8b 45 10             	mov    0x10(%ebp),%eax
  801c6d:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c70:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c73:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c77:	8b 45 08             	mov    0x8(%ebp),%eax
  801c7a:	6a 00                	push   $0x0
  801c7c:	51                   	push   %ecx
  801c7d:	52                   	push   %edx
  801c7e:	ff 75 0c             	pushl  0xc(%ebp)
  801c81:	50                   	push   %eax
  801c82:	6a 1b                	push   $0x1b
  801c84:	e8 19 fd ff ff       	call   8019a2 <syscall>
  801c89:	83 c4 18             	add    $0x18,%esp
}
  801c8c:	c9                   	leave  
  801c8d:	c3                   	ret    

00801c8e <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c8e:	55                   	push   %ebp
  801c8f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c91:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c94:	8b 45 08             	mov    0x8(%ebp),%eax
  801c97:	6a 00                	push   $0x0
  801c99:	6a 00                	push   $0x0
  801c9b:	6a 00                	push   $0x0
  801c9d:	52                   	push   %edx
  801c9e:	50                   	push   %eax
  801c9f:	6a 1c                	push   $0x1c
  801ca1:	e8 fc fc ff ff       	call   8019a2 <syscall>
  801ca6:	83 c4 18             	add    $0x18,%esp
}
  801ca9:	c9                   	leave  
  801caa:	c3                   	ret    

00801cab <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801cab:	55                   	push   %ebp
  801cac:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801cae:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cb1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	51                   	push   %ecx
  801cbc:	52                   	push   %edx
  801cbd:	50                   	push   %eax
  801cbe:	6a 1d                	push   $0x1d
  801cc0:	e8 dd fc ff ff       	call   8019a2 <syscall>
  801cc5:	83 c4 18             	add    $0x18,%esp
}
  801cc8:	c9                   	leave  
  801cc9:	c3                   	ret    

00801cca <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801cca:	55                   	push   %ebp
  801ccb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ccd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	52                   	push   %edx
  801cda:	50                   	push   %eax
  801cdb:	6a 1e                	push   $0x1e
  801cdd:	e8 c0 fc ff ff       	call   8019a2 <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
}
  801ce5:	c9                   	leave  
  801ce6:	c3                   	ret    

00801ce7 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801ce7:	55                   	push   %ebp
  801ce8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 1f                	push   $0x1f
  801cf6:	e8 a7 fc ff ff       	call   8019a2 <syscall>
  801cfb:	83 c4 18             	add    $0x18,%esp
}
  801cfe:	c9                   	leave  
  801cff:	c3                   	ret    

00801d00 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801d00:	55                   	push   %ebp
  801d01:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801d03:	8b 45 08             	mov    0x8(%ebp),%eax
  801d06:	6a 00                	push   $0x0
  801d08:	ff 75 14             	pushl  0x14(%ebp)
  801d0b:	ff 75 10             	pushl  0x10(%ebp)
  801d0e:	ff 75 0c             	pushl  0xc(%ebp)
  801d11:	50                   	push   %eax
  801d12:	6a 20                	push   $0x20
  801d14:	e8 89 fc ff ff       	call   8019a2 <syscall>
  801d19:	83 c4 18             	add    $0x18,%esp
}
  801d1c:	c9                   	leave  
  801d1d:	c3                   	ret    

00801d1e <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801d1e:	55                   	push   %ebp
  801d1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801d21:	8b 45 08             	mov    0x8(%ebp),%eax
  801d24:	6a 00                	push   $0x0
  801d26:	6a 00                	push   $0x0
  801d28:	6a 00                	push   $0x0
  801d2a:	6a 00                	push   $0x0
  801d2c:	50                   	push   %eax
  801d2d:	6a 21                	push   $0x21
  801d2f:	e8 6e fc ff ff       	call   8019a2 <syscall>
  801d34:	83 c4 18             	add    $0x18,%esp
}
  801d37:	90                   	nop
  801d38:	c9                   	leave  
  801d39:	c3                   	ret    

00801d3a <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d3a:	55                   	push   %ebp
  801d3b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	50                   	push   %eax
  801d49:	6a 22                	push   $0x22
  801d4b:	e8 52 fc ff ff       	call   8019a2 <syscall>
  801d50:	83 c4 18             	add    $0x18,%esp
}
  801d53:	c9                   	leave  
  801d54:	c3                   	ret    

00801d55 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d55:	55                   	push   %ebp
  801d56:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 00                	push   $0x0
  801d5c:	6a 00                	push   $0x0
  801d5e:	6a 00                	push   $0x0
  801d60:	6a 00                	push   $0x0
  801d62:	6a 02                	push   $0x2
  801d64:	e8 39 fc ff ff       	call   8019a2 <syscall>
  801d69:	83 c4 18             	add    $0x18,%esp
}
  801d6c:	c9                   	leave  
  801d6d:	c3                   	ret    

00801d6e <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d6e:	55                   	push   %ebp
  801d6f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d71:	6a 00                	push   $0x0
  801d73:	6a 00                	push   $0x0
  801d75:	6a 00                	push   $0x0
  801d77:	6a 00                	push   $0x0
  801d79:	6a 00                	push   $0x0
  801d7b:	6a 03                	push   $0x3
  801d7d:	e8 20 fc ff ff       	call   8019a2 <syscall>
  801d82:	83 c4 18             	add    $0x18,%esp
}
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d8a:	6a 00                	push   $0x0
  801d8c:	6a 00                	push   $0x0
  801d8e:	6a 00                	push   $0x0
  801d90:	6a 00                	push   $0x0
  801d92:	6a 00                	push   $0x0
  801d94:	6a 04                	push   $0x4
  801d96:	e8 07 fc ff ff       	call   8019a2 <syscall>
  801d9b:	83 c4 18             	add    $0x18,%esp
}
  801d9e:	c9                   	leave  
  801d9f:	c3                   	ret    

00801da0 <sys_exit_env>:


void sys_exit_env(void)
{
  801da0:	55                   	push   %ebp
  801da1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801da3:	6a 00                	push   $0x0
  801da5:	6a 00                	push   $0x0
  801da7:	6a 00                	push   $0x0
  801da9:	6a 00                	push   $0x0
  801dab:	6a 00                	push   $0x0
  801dad:	6a 23                	push   $0x23
  801daf:	e8 ee fb ff ff       	call   8019a2 <syscall>
  801db4:	83 c4 18             	add    $0x18,%esp
}
  801db7:	90                   	nop
  801db8:	c9                   	leave  
  801db9:	c3                   	ret    

00801dba <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801dba:	55                   	push   %ebp
  801dbb:	89 e5                	mov    %esp,%ebp
  801dbd:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801dc0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dc3:	8d 50 04             	lea    0x4(%eax),%edx
  801dc6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801dc9:	6a 00                	push   $0x0
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	52                   	push   %edx
  801dd0:	50                   	push   %eax
  801dd1:	6a 24                	push   $0x24
  801dd3:	e8 ca fb ff ff       	call   8019a2 <syscall>
  801dd8:	83 c4 18             	add    $0x18,%esp
	return result;
  801ddb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dde:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801de1:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801de4:	89 01                	mov    %eax,(%ecx)
  801de6:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801de9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dec:	c9                   	leave  
  801ded:	c2 04 00             	ret    $0x4

00801df0 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801df0:	55                   	push   %ebp
  801df1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801df3:	6a 00                	push   $0x0
  801df5:	6a 00                	push   $0x0
  801df7:	ff 75 10             	pushl  0x10(%ebp)
  801dfa:	ff 75 0c             	pushl  0xc(%ebp)
  801dfd:	ff 75 08             	pushl  0x8(%ebp)
  801e00:	6a 12                	push   $0x12
  801e02:	e8 9b fb ff ff       	call   8019a2 <syscall>
  801e07:	83 c4 18             	add    $0x18,%esp
	return ;
  801e0a:	90                   	nop
}
  801e0b:	c9                   	leave  
  801e0c:	c3                   	ret    

00801e0d <sys_rcr2>:
uint32 sys_rcr2()
{
  801e0d:	55                   	push   %ebp
  801e0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801e10:	6a 00                	push   $0x0
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 25                	push   $0x25
  801e1c:	e8 81 fb ff ff       	call   8019a2 <syscall>
  801e21:	83 c4 18             	add    $0x18,%esp
}
  801e24:	c9                   	leave  
  801e25:	c3                   	ret    

00801e26 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801e26:	55                   	push   %ebp
  801e27:	89 e5                	mov    %esp,%ebp
  801e29:	83 ec 04             	sub    $0x4,%esp
  801e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801e2f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801e32:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e36:	6a 00                	push   $0x0
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	50                   	push   %eax
  801e3f:	6a 26                	push   $0x26
  801e41:	e8 5c fb ff ff       	call   8019a2 <syscall>
  801e46:	83 c4 18             	add    $0x18,%esp
	return ;
  801e49:	90                   	nop
}
  801e4a:	c9                   	leave  
  801e4b:	c3                   	ret    

00801e4c <rsttst>:
void rsttst()
{
  801e4c:	55                   	push   %ebp
  801e4d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e4f:	6a 00                	push   $0x0
  801e51:	6a 00                	push   $0x0
  801e53:	6a 00                	push   $0x0
  801e55:	6a 00                	push   $0x0
  801e57:	6a 00                	push   $0x0
  801e59:	6a 28                	push   $0x28
  801e5b:	e8 42 fb ff ff       	call   8019a2 <syscall>
  801e60:	83 c4 18             	add    $0x18,%esp
	return ;
  801e63:	90                   	nop
}
  801e64:	c9                   	leave  
  801e65:	c3                   	ret    

00801e66 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e66:	55                   	push   %ebp
  801e67:	89 e5                	mov    %esp,%ebp
  801e69:	83 ec 04             	sub    $0x4,%esp
  801e6c:	8b 45 14             	mov    0x14(%ebp),%eax
  801e6f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e72:	8b 55 18             	mov    0x18(%ebp),%edx
  801e75:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e79:	52                   	push   %edx
  801e7a:	50                   	push   %eax
  801e7b:	ff 75 10             	pushl  0x10(%ebp)
  801e7e:	ff 75 0c             	pushl  0xc(%ebp)
  801e81:	ff 75 08             	pushl  0x8(%ebp)
  801e84:	6a 27                	push   $0x27
  801e86:	e8 17 fb ff ff       	call   8019a2 <syscall>
  801e8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8e:	90                   	nop
}
  801e8f:	c9                   	leave  
  801e90:	c3                   	ret    

00801e91 <chktst>:
void chktst(uint32 n)
{
  801e91:	55                   	push   %ebp
  801e92:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e94:	6a 00                	push   $0x0
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	ff 75 08             	pushl  0x8(%ebp)
  801e9f:	6a 29                	push   $0x29
  801ea1:	e8 fc fa ff ff       	call   8019a2 <syscall>
  801ea6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ea9:	90                   	nop
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <inctst>:

void inctst()
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801eaf:	6a 00                	push   $0x0
  801eb1:	6a 00                	push   $0x0
  801eb3:	6a 00                	push   $0x0
  801eb5:	6a 00                	push   $0x0
  801eb7:	6a 00                	push   $0x0
  801eb9:	6a 2a                	push   $0x2a
  801ebb:	e8 e2 fa ff ff       	call   8019a2 <syscall>
  801ec0:	83 c4 18             	add    $0x18,%esp
	return ;
  801ec3:	90                   	nop
}
  801ec4:	c9                   	leave  
  801ec5:	c3                   	ret    

00801ec6 <gettst>:
uint32 gettst()
{
  801ec6:	55                   	push   %ebp
  801ec7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ec9:	6a 00                	push   $0x0
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	6a 2b                	push   $0x2b
  801ed5:	e8 c8 fa ff ff       	call   8019a2 <syscall>
  801eda:	83 c4 18             	add    $0x18,%esp
}
  801edd:	c9                   	leave  
  801ede:	c3                   	ret    

00801edf <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801edf:	55                   	push   %ebp
  801ee0:	89 e5                	mov    %esp,%ebp
  801ee2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 2c                	push   $0x2c
  801ef1:	e8 ac fa ff ff       	call   8019a2 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
  801ef9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801efc:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801f00:	75 07                	jne    801f09 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801f02:	b8 01 00 00 00       	mov    $0x1,%eax
  801f07:	eb 05                	jmp    801f0e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801f09:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0e:	c9                   	leave  
  801f0f:	c3                   	ret    

00801f10 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801f10:	55                   	push   %ebp
  801f11:	89 e5                	mov    %esp,%ebp
  801f13:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 00                	push   $0x0
  801f20:	6a 2c                	push   $0x2c
  801f22:	e8 7b fa ff ff       	call   8019a2 <syscall>
  801f27:	83 c4 18             	add    $0x18,%esp
  801f2a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801f2d:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801f31:	75 07                	jne    801f3a <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f33:	b8 01 00 00 00       	mov    $0x1,%eax
  801f38:	eb 05                	jmp    801f3f <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f3a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
  801f44:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 00                	push   $0x0
  801f51:	6a 2c                	push   $0x2c
  801f53:	e8 4a fa ff ff       	call   8019a2 <syscall>
  801f58:	83 c4 18             	add    $0x18,%esp
  801f5b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f5e:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f62:	75 07                	jne    801f6b <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f64:	b8 01 00 00 00       	mov    $0x1,%eax
  801f69:	eb 05                	jmp    801f70 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f6b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f70:	c9                   	leave  
  801f71:	c3                   	ret    

00801f72 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f72:	55                   	push   %ebp
  801f73:	89 e5                	mov    %esp,%ebp
  801f75:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	6a 00                	push   $0x0
  801f7e:	6a 00                	push   $0x0
  801f80:	6a 00                	push   $0x0
  801f82:	6a 2c                	push   $0x2c
  801f84:	e8 19 fa ff ff       	call   8019a2 <syscall>
  801f89:	83 c4 18             	add    $0x18,%esp
  801f8c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f8f:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f93:	75 07                	jne    801f9c <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f95:	b8 01 00 00 00       	mov    $0x1,%eax
  801f9a:	eb 05                	jmp    801fa1 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801fa1:	c9                   	leave  
  801fa2:	c3                   	ret    

00801fa3 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801fa3:	55                   	push   %ebp
  801fa4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801fa6:	6a 00                	push   $0x0
  801fa8:	6a 00                	push   $0x0
  801faa:	6a 00                	push   $0x0
  801fac:	6a 00                	push   $0x0
  801fae:	ff 75 08             	pushl  0x8(%ebp)
  801fb1:	6a 2d                	push   $0x2d
  801fb3:	e8 ea f9 ff ff       	call   8019a2 <syscall>
  801fb8:	83 c4 18             	add    $0x18,%esp
	return ;
  801fbb:	90                   	nop
}
  801fbc:	c9                   	leave  
  801fbd:	c3                   	ret    

00801fbe <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801fbe:	55                   	push   %ebp
  801fbf:	89 e5                	mov    %esp,%ebp
  801fc1:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801fc2:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fc5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fc8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fce:	6a 00                	push   $0x0
  801fd0:	53                   	push   %ebx
  801fd1:	51                   	push   %ecx
  801fd2:	52                   	push   %edx
  801fd3:	50                   	push   %eax
  801fd4:	6a 2e                	push   $0x2e
  801fd6:	e8 c7 f9 ff ff       	call   8019a2 <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
}
  801fde:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fe1:	c9                   	leave  
  801fe2:	c3                   	ret    

00801fe3 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fe3:	55                   	push   %ebp
  801fe4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fe6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fe9:	8b 45 08             	mov    0x8(%ebp),%eax
  801fec:	6a 00                	push   $0x0
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	52                   	push   %edx
  801ff3:	50                   	push   %eax
  801ff4:	6a 2f                	push   $0x2f
  801ff6:	e8 a7 f9 ff ff       	call   8019a2 <syscall>
  801ffb:	83 c4 18             	add    $0x18,%esp
}
  801ffe:	c9                   	leave  
  801fff:	c3                   	ret    

00802000 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802000:	55                   	push   %ebp
  802001:	89 e5                	mov    %esp,%ebp
  802003:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802006:	83 ec 0c             	sub    $0xc,%esp
  802009:	68 80 3b 80 00       	push   $0x803b80
  80200e:	e8 3e e6 ff ff       	call   800651 <cprintf>
  802013:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802016:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80201d:	83 ec 0c             	sub    $0xc,%esp
  802020:	68 ac 3b 80 00       	push   $0x803bac
  802025:	e8 27 e6 ff ff       	call   800651 <cprintf>
  80202a:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  80202d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802031:	a1 38 41 80 00       	mov    0x804138,%eax
  802036:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802039:	eb 56                	jmp    802091 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80203b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80203f:	74 1c                	je     80205d <print_mem_block_lists+0x5d>
  802041:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802044:	8b 50 08             	mov    0x8(%eax),%edx
  802047:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80204a:	8b 48 08             	mov    0x8(%eax),%ecx
  80204d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802050:	8b 40 0c             	mov    0xc(%eax),%eax
  802053:	01 c8                	add    %ecx,%eax
  802055:	39 c2                	cmp    %eax,%edx
  802057:	73 04                	jae    80205d <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802059:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80205d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802060:	8b 50 08             	mov    0x8(%eax),%edx
  802063:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802066:	8b 40 0c             	mov    0xc(%eax),%eax
  802069:	01 c2                	add    %eax,%edx
  80206b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80206e:	8b 40 08             	mov    0x8(%eax),%eax
  802071:	83 ec 04             	sub    $0x4,%esp
  802074:	52                   	push   %edx
  802075:	50                   	push   %eax
  802076:	68 c1 3b 80 00       	push   $0x803bc1
  80207b:	e8 d1 e5 ff ff       	call   800651 <cprintf>
  802080:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802083:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802086:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802089:	a1 40 41 80 00       	mov    0x804140,%eax
  80208e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802091:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802095:	74 07                	je     80209e <print_mem_block_lists+0x9e>
  802097:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80209a:	8b 00                	mov    (%eax),%eax
  80209c:	eb 05                	jmp    8020a3 <print_mem_block_lists+0xa3>
  80209e:	b8 00 00 00 00       	mov    $0x0,%eax
  8020a3:	a3 40 41 80 00       	mov    %eax,0x804140
  8020a8:	a1 40 41 80 00       	mov    0x804140,%eax
  8020ad:	85 c0                	test   %eax,%eax
  8020af:	75 8a                	jne    80203b <print_mem_block_lists+0x3b>
  8020b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020b5:	75 84                	jne    80203b <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8020b7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020bb:	75 10                	jne    8020cd <print_mem_block_lists+0xcd>
  8020bd:	83 ec 0c             	sub    $0xc,%esp
  8020c0:	68 d0 3b 80 00       	push   $0x803bd0
  8020c5:	e8 87 e5 ff ff       	call   800651 <cprintf>
  8020ca:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8020cd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020d4:	83 ec 0c             	sub    $0xc,%esp
  8020d7:	68 f4 3b 80 00       	push   $0x803bf4
  8020dc:	e8 70 e5 ff ff       	call   800651 <cprintf>
  8020e1:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020e4:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020e8:	a1 40 40 80 00       	mov    0x804040,%eax
  8020ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020f0:	eb 56                	jmp    802148 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020f6:	74 1c                	je     802114 <print_mem_block_lists+0x114>
  8020f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020fb:	8b 50 08             	mov    0x8(%eax),%edx
  8020fe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802101:	8b 48 08             	mov    0x8(%eax),%ecx
  802104:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802107:	8b 40 0c             	mov    0xc(%eax),%eax
  80210a:	01 c8                	add    %ecx,%eax
  80210c:	39 c2                	cmp    %eax,%edx
  80210e:	73 04                	jae    802114 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802110:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802114:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802117:	8b 50 08             	mov    0x8(%eax),%edx
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	8b 40 0c             	mov    0xc(%eax),%eax
  802120:	01 c2                	add    %eax,%edx
  802122:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802125:	8b 40 08             	mov    0x8(%eax),%eax
  802128:	83 ec 04             	sub    $0x4,%esp
  80212b:	52                   	push   %edx
  80212c:	50                   	push   %eax
  80212d:	68 c1 3b 80 00       	push   $0x803bc1
  802132:	e8 1a e5 ff ff       	call   800651 <cprintf>
  802137:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80213a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802140:	a1 48 40 80 00       	mov    0x804048,%eax
  802145:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802148:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80214c:	74 07                	je     802155 <print_mem_block_lists+0x155>
  80214e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802151:	8b 00                	mov    (%eax),%eax
  802153:	eb 05                	jmp    80215a <print_mem_block_lists+0x15a>
  802155:	b8 00 00 00 00       	mov    $0x0,%eax
  80215a:	a3 48 40 80 00       	mov    %eax,0x804048
  80215f:	a1 48 40 80 00       	mov    0x804048,%eax
  802164:	85 c0                	test   %eax,%eax
  802166:	75 8a                	jne    8020f2 <print_mem_block_lists+0xf2>
  802168:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80216c:	75 84                	jne    8020f2 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80216e:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802172:	75 10                	jne    802184 <print_mem_block_lists+0x184>
  802174:	83 ec 0c             	sub    $0xc,%esp
  802177:	68 0c 3c 80 00       	push   $0x803c0c
  80217c:	e8 d0 e4 ff ff       	call   800651 <cprintf>
  802181:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802184:	83 ec 0c             	sub    $0xc,%esp
  802187:	68 80 3b 80 00       	push   $0x803b80
  80218c:	e8 c0 e4 ff ff       	call   800651 <cprintf>
  802191:	83 c4 10             	add    $0x10,%esp

}
  802194:	90                   	nop
  802195:	c9                   	leave  
  802196:	c3                   	ret    

00802197 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802197:	55                   	push   %ebp
  802198:	89 e5                	mov    %esp,%ebp
  80219a:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80219d:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  8021a4:	00 00 00 
  8021a7:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  8021ae:	00 00 00 
  8021b1:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  8021b8:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8021bb:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8021c2:	e9 9e 00 00 00       	jmp    802265 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8021c7:	a1 50 40 80 00       	mov    0x804050,%eax
  8021cc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021cf:	c1 e2 04             	shl    $0x4,%edx
  8021d2:	01 d0                	add    %edx,%eax
  8021d4:	85 c0                	test   %eax,%eax
  8021d6:	75 14                	jne    8021ec <initialize_MemBlocksList+0x55>
  8021d8:	83 ec 04             	sub    $0x4,%esp
  8021db:	68 34 3c 80 00       	push   $0x803c34
  8021e0:	6a 3d                	push   $0x3d
  8021e2:	68 57 3c 80 00       	push   $0x803c57
  8021e7:	e8 b1 e1 ff ff       	call   80039d <_panic>
  8021ec:	a1 50 40 80 00       	mov    0x804050,%eax
  8021f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f4:	c1 e2 04             	shl    $0x4,%edx
  8021f7:	01 d0                	add    %edx,%eax
  8021f9:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8021ff:	89 10                	mov    %edx,(%eax)
  802201:	8b 00                	mov    (%eax),%eax
  802203:	85 c0                	test   %eax,%eax
  802205:	74 18                	je     80221f <initialize_MemBlocksList+0x88>
  802207:	a1 48 41 80 00       	mov    0x804148,%eax
  80220c:	8b 15 50 40 80 00    	mov    0x804050,%edx
  802212:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802215:	c1 e1 04             	shl    $0x4,%ecx
  802218:	01 ca                	add    %ecx,%edx
  80221a:	89 50 04             	mov    %edx,0x4(%eax)
  80221d:	eb 12                	jmp    802231 <initialize_MemBlocksList+0x9a>
  80221f:	a1 50 40 80 00       	mov    0x804050,%eax
  802224:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802227:	c1 e2 04             	shl    $0x4,%edx
  80222a:	01 d0                	add    %edx,%eax
  80222c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802231:	a1 50 40 80 00       	mov    0x804050,%eax
  802236:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802239:	c1 e2 04             	shl    $0x4,%edx
  80223c:	01 d0                	add    %edx,%eax
  80223e:	a3 48 41 80 00       	mov    %eax,0x804148
  802243:	a1 50 40 80 00       	mov    0x804050,%eax
  802248:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80224b:	c1 e2 04             	shl    $0x4,%edx
  80224e:	01 d0                	add    %edx,%eax
  802250:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802257:	a1 54 41 80 00       	mov    0x804154,%eax
  80225c:	40                   	inc    %eax
  80225d:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802262:	ff 45 f4             	incl   -0xc(%ebp)
  802265:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802268:	3b 45 08             	cmp    0x8(%ebp),%eax
  80226b:	0f 82 56 ff ff ff    	jb     8021c7 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802271:	90                   	nop
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  80227a:	8b 45 08             	mov    0x8(%ebp),%eax
  80227d:	8b 00                	mov    (%eax),%eax
  80227f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802282:	eb 18                	jmp    80229c <find_block+0x28>

		if(tmp->sva == va){
  802284:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802287:	8b 40 08             	mov    0x8(%eax),%eax
  80228a:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80228d:	75 05                	jne    802294 <find_block+0x20>
			return tmp ;
  80228f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802292:	eb 11                	jmp    8022a5 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802294:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802297:	8b 00                	mov    (%eax),%eax
  802299:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  80229c:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8022a0:	75 e2                	jne    802284 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8022a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8022a5:	c9                   	leave  
  8022a6:	c3                   	ret    

008022a7 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8022a7:	55                   	push   %ebp
  8022a8:	89 e5                	mov    %esp,%ebp
  8022aa:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8022ad:	a1 40 40 80 00       	mov    0x804040,%eax
  8022b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8022b5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8022bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022c1:	75 65                	jne    802328 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8022c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c7:	75 14                	jne    8022dd <insert_sorted_allocList+0x36>
  8022c9:	83 ec 04             	sub    $0x4,%esp
  8022cc:	68 34 3c 80 00       	push   $0x803c34
  8022d1:	6a 62                	push   $0x62
  8022d3:	68 57 3c 80 00       	push   $0x803c57
  8022d8:	e8 c0 e0 ff ff       	call   80039d <_panic>
  8022dd:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	89 10                	mov    %edx,(%eax)
  8022e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022eb:	8b 00                	mov    (%eax),%eax
  8022ed:	85 c0                	test   %eax,%eax
  8022ef:	74 0d                	je     8022fe <insert_sorted_allocList+0x57>
  8022f1:	a1 40 40 80 00       	mov    0x804040,%eax
  8022f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8022f9:	89 50 04             	mov    %edx,0x4(%eax)
  8022fc:	eb 08                	jmp    802306 <insert_sorted_allocList+0x5f>
  8022fe:	8b 45 08             	mov    0x8(%ebp),%eax
  802301:	a3 44 40 80 00       	mov    %eax,0x804044
  802306:	8b 45 08             	mov    0x8(%ebp),%eax
  802309:	a3 40 40 80 00       	mov    %eax,0x804040
  80230e:	8b 45 08             	mov    0x8(%ebp),%eax
  802311:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802318:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80231d:	40                   	inc    %eax
  80231e:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802323:	e9 14 01 00 00       	jmp    80243c <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802328:	8b 45 08             	mov    0x8(%ebp),%eax
  80232b:	8b 50 08             	mov    0x8(%eax),%edx
  80232e:	a1 44 40 80 00       	mov    0x804044,%eax
  802333:	8b 40 08             	mov    0x8(%eax),%eax
  802336:	39 c2                	cmp    %eax,%edx
  802338:	76 65                	jbe    80239f <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  80233a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80233e:	75 14                	jne    802354 <insert_sorted_allocList+0xad>
  802340:	83 ec 04             	sub    $0x4,%esp
  802343:	68 70 3c 80 00       	push   $0x803c70
  802348:	6a 64                	push   $0x64
  80234a:	68 57 3c 80 00       	push   $0x803c57
  80234f:	e8 49 e0 ff ff       	call   80039d <_panic>
  802354:	8b 15 44 40 80 00    	mov    0x804044,%edx
  80235a:	8b 45 08             	mov    0x8(%ebp),%eax
  80235d:	89 50 04             	mov    %edx,0x4(%eax)
  802360:	8b 45 08             	mov    0x8(%ebp),%eax
  802363:	8b 40 04             	mov    0x4(%eax),%eax
  802366:	85 c0                	test   %eax,%eax
  802368:	74 0c                	je     802376 <insert_sorted_allocList+0xcf>
  80236a:	a1 44 40 80 00       	mov    0x804044,%eax
  80236f:	8b 55 08             	mov    0x8(%ebp),%edx
  802372:	89 10                	mov    %edx,(%eax)
  802374:	eb 08                	jmp    80237e <insert_sorted_allocList+0xd7>
  802376:	8b 45 08             	mov    0x8(%ebp),%eax
  802379:	a3 40 40 80 00       	mov    %eax,0x804040
  80237e:	8b 45 08             	mov    0x8(%ebp),%eax
  802381:	a3 44 40 80 00       	mov    %eax,0x804044
  802386:	8b 45 08             	mov    0x8(%ebp),%eax
  802389:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80238f:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802394:	40                   	inc    %eax
  802395:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80239a:	e9 9d 00 00 00       	jmp    80243c <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80239f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8023a6:	e9 85 00 00 00       	jmp    802430 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8023ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ae:	8b 50 08             	mov    0x8(%eax),%edx
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 40 08             	mov    0x8(%eax),%eax
  8023b7:	39 c2                	cmp    %eax,%edx
  8023b9:	73 6a                	jae    802425 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8023bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023bf:	74 06                	je     8023c7 <insert_sorted_allocList+0x120>
  8023c1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8023c5:	75 14                	jne    8023db <insert_sorted_allocList+0x134>
  8023c7:	83 ec 04             	sub    $0x4,%esp
  8023ca:	68 94 3c 80 00       	push   $0x803c94
  8023cf:	6a 6b                	push   $0x6b
  8023d1:	68 57 3c 80 00       	push   $0x803c57
  8023d6:	e8 c2 df ff ff       	call   80039d <_panic>
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 50 04             	mov    0x4(%eax),%edx
  8023e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8023e4:	89 50 04             	mov    %edx,0x4(%eax)
  8023e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8023ea:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ed:	89 10                	mov    %edx,(%eax)
  8023ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f2:	8b 40 04             	mov    0x4(%eax),%eax
  8023f5:	85 c0                	test   %eax,%eax
  8023f7:	74 0d                	je     802406 <insert_sorted_allocList+0x15f>
  8023f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023fc:	8b 40 04             	mov    0x4(%eax),%eax
  8023ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802402:	89 10                	mov    %edx,(%eax)
  802404:	eb 08                	jmp    80240e <insert_sorted_allocList+0x167>
  802406:	8b 45 08             	mov    0x8(%ebp),%eax
  802409:	a3 40 40 80 00       	mov    %eax,0x804040
  80240e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802411:	8b 55 08             	mov    0x8(%ebp),%edx
  802414:	89 50 04             	mov    %edx,0x4(%eax)
  802417:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80241c:	40                   	inc    %eax
  80241d:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  802422:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802423:	eb 17                	jmp    80243c <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802425:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802428:	8b 00                	mov    (%eax),%eax
  80242a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80242d:	ff 45 f0             	incl   -0x10(%ebp)
  802430:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802433:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802436:	0f 8c 6f ff ff ff    	jl     8023ab <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80243c:	90                   	nop
  80243d:	c9                   	leave  
  80243e:	c3                   	ret    

0080243f <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80243f:	55                   	push   %ebp
  802440:	89 e5                	mov    %esp,%ebp
  802442:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802445:	a1 38 41 80 00       	mov    0x804138,%eax
  80244a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80244d:	e9 7c 01 00 00       	jmp    8025ce <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802452:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802455:	8b 40 0c             	mov    0xc(%eax),%eax
  802458:	3b 45 08             	cmp    0x8(%ebp),%eax
  80245b:	0f 86 cf 00 00 00    	jbe    802530 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802461:	a1 48 41 80 00       	mov    0x804148,%eax
  802466:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246c:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  80246f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802472:	8b 55 08             	mov    0x8(%ebp),%edx
  802475:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802478:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247b:	8b 50 08             	mov    0x8(%eax),%edx
  80247e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802481:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 40 0c             	mov    0xc(%eax),%eax
  80248a:	2b 45 08             	sub    0x8(%ebp),%eax
  80248d:	89 c2                	mov    %eax,%edx
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 50 08             	mov    0x8(%eax),%edx
  80249b:	8b 45 08             	mov    0x8(%ebp),%eax
  80249e:	01 c2                	add    %eax,%edx
  8024a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a3:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8024a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8024aa:	75 17                	jne    8024c3 <alloc_block_FF+0x84>
  8024ac:	83 ec 04             	sub    $0x4,%esp
  8024af:	68 c9 3c 80 00       	push   $0x803cc9
  8024b4:	68 83 00 00 00       	push   $0x83
  8024b9:	68 57 3c 80 00       	push   $0x803c57
  8024be:	e8 da de ff ff       	call   80039d <_panic>
  8024c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c6:	8b 00                	mov    (%eax),%eax
  8024c8:	85 c0                	test   %eax,%eax
  8024ca:	74 10                	je     8024dc <alloc_block_FF+0x9d>
  8024cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024cf:	8b 00                	mov    (%eax),%eax
  8024d1:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024d4:	8b 52 04             	mov    0x4(%edx),%edx
  8024d7:	89 50 04             	mov    %edx,0x4(%eax)
  8024da:	eb 0b                	jmp    8024e7 <alloc_block_FF+0xa8>
  8024dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024df:	8b 40 04             	mov    0x4(%eax),%eax
  8024e2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024e7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ea:	8b 40 04             	mov    0x4(%eax),%eax
  8024ed:	85 c0                	test   %eax,%eax
  8024ef:	74 0f                	je     802500 <alloc_block_FF+0xc1>
  8024f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f4:	8b 40 04             	mov    0x4(%eax),%eax
  8024f7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024fa:	8b 12                	mov    (%edx),%edx
  8024fc:	89 10                	mov    %edx,(%eax)
  8024fe:	eb 0a                	jmp    80250a <alloc_block_FF+0xcb>
  802500:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802503:	8b 00                	mov    (%eax),%eax
  802505:	a3 48 41 80 00       	mov    %eax,0x804148
  80250a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80250d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802513:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802516:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80251d:	a1 54 41 80 00       	mov    0x804154,%eax
  802522:	48                   	dec    %eax
  802523:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  802528:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80252b:	e9 ad 00 00 00       	jmp    8025dd <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802533:	8b 40 0c             	mov    0xc(%eax),%eax
  802536:	3b 45 08             	cmp    0x8(%ebp),%eax
  802539:	0f 85 87 00 00 00    	jne    8025c6 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  80253f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802543:	75 17                	jne    80255c <alloc_block_FF+0x11d>
  802545:	83 ec 04             	sub    $0x4,%esp
  802548:	68 c9 3c 80 00       	push   $0x803cc9
  80254d:	68 87 00 00 00       	push   $0x87
  802552:	68 57 3c 80 00       	push   $0x803c57
  802557:	e8 41 de ff ff       	call   80039d <_panic>
  80255c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255f:	8b 00                	mov    (%eax),%eax
  802561:	85 c0                	test   %eax,%eax
  802563:	74 10                	je     802575 <alloc_block_FF+0x136>
  802565:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802568:	8b 00                	mov    (%eax),%eax
  80256a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80256d:	8b 52 04             	mov    0x4(%edx),%edx
  802570:	89 50 04             	mov    %edx,0x4(%eax)
  802573:	eb 0b                	jmp    802580 <alloc_block_FF+0x141>
  802575:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802578:	8b 40 04             	mov    0x4(%eax),%eax
  80257b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802580:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802583:	8b 40 04             	mov    0x4(%eax),%eax
  802586:	85 c0                	test   %eax,%eax
  802588:	74 0f                	je     802599 <alloc_block_FF+0x15a>
  80258a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80258d:	8b 40 04             	mov    0x4(%eax),%eax
  802590:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802593:	8b 12                	mov    (%edx),%edx
  802595:	89 10                	mov    %edx,(%eax)
  802597:	eb 0a                	jmp    8025a3 <alloc_block_FF+0x164>
  802599:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80259c:	8b 00                	mov    (%eax),%eax
  80259e:	a3 38 41 80 00       	mov    %eax,0x804138
  8025a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025af:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025b6:	a1 44 41 80 00       	mov    0x804144,%eax
  8025bb:	48                   	dec    %eax
  8025bc:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8025c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c4:	eb 17                	jmp    8025dd <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8025c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c9:	8b 00                	mov    (%eax),%eax
  8025cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8025ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d2:	0f 85 7a fe ff ff    	jne    802452 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8025d8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025dd:	c9                   	leave  
  8025de:	c3                   	ret    

008025df <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025df:	55                   	push   %ebp
  8025e0:	89 e5                	mov    %esp,%ebp
  8025e2:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8025e5:	a1 38 41 80 00       	mov    0x804138,%eax
  8025ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8025ed:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8025f4:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8025fb:	a1 38 41 80 00       	mov    0x804138,%eax
  802600:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802603:	e9 d0 00 00 00       	jmp    8026d8 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80260b:	8b 40 0c             	mov    0xc(%eax),%eax
  80260e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802611:	0f 82 b8 00 00 00    	jb     8026cf <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802617:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261a:	8b 40 0c             	mov    0xc(%eax),%eax
  80261d:	2b 45 08             	sub    0x8(%ebp),%eax
  802620:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802623:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802626:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802629:	0f 83 a1 00 00 00    	jae    8026d0 <alloc_block_BF+0xf1>
				differsize = differance ;
  80262f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802632:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802635:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802638:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  80263b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80263f:	0f 85 8b 00 00 00    	jne    8026d0 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802645:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802649:	75 17                	jne    802662 <alloc_block_BF+0x83>
  80264b:	83 ec 04             	sub    $0x4,%esp
  80264e:	68 c9 3c 80 00       	push   $0x803cc9
  802653:	68 a0 00 00 00       	push   $0xa0
  802658:	68 57 3c 80 00       	push   $0x803c57
  80265d:	e8 3b dd ff ff       	call   80039d <_panic>
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	8b 00                	mov    (%eax),%eax
  802667:	85 c0                	test   %eax,%eax
  802669:	74 10                	je     80267b <alloc_block_BF+0x9c>
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	8b 00                	mov    (%eax),%eax
  802670:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802673:	8b 52 04             	mov    0x4(%edx),%edx
  802676:	89 50 04             	mov    %edx,0x4(%eax)
  802679:	eb 0b                	jmp    802686 <alloc_block_BF+0xa7>
  80267b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80267e:	8b 40 04             	mov    0x4(%eax),%eax
  802681:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802686:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802689:	8b 40 04             	mov    0x4(%eax),%eax
  80268c:	85 c0                	test   %eax,%eax
  80268e:	74 0f                	je     80269f <alloc_block_BF+0xc0>
  802690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802693:	8b 40 04             	mov    0x4(%eax),%eax
  802696:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802699:	8b 12                	mov    (%edx),%edx
  80269b:	89 10                	mov    %edx,(%eax)
  80269d:	eb 0a                	jmp    8026a9 <alloc_block_BF+0xca>
  80269f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a2:	8b 00                	mov    (%eax),%eax
  8026a4:	a3 38 41 80 00       	mov    %eax,0x804138
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026bc:	a1 44 41 80 00       	mov    0x804144,%eax
  8026c1:	48                   	dec    %eax
  8026c2:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8026c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ca:	e9 0c 01 00 00       	jmp    8027db <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8026cf:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8026d0:	a1 40 41 80 00       	mov    0x804140,%eax
  8026d5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026dc:	74 07                	je     8026e5 <alloc_block_BF+0x106>
  8026de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e1:	8b 00                	mov    (%eax),%eax
  8026e3:	eb 05                	jmp    8026ea <alloc_block_BF+0x10b>
  8026e5:	b8 00 00 00 00       	mov    $0x0,%eax
  8026ea:	a3 40 41 80 00       	mov    %eax,0x804140
  8026ef:	a1 40 41 80 00       	mov    0x804140,%eax
  8026f4:	85 c0                	test   %eax,%eax
  8026f6:	0f 85 0c ff ff ff    	jne    802608 <alloc_block_BF+0x29>
  8026fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802700:	0f 85 02 ff ff ff    	jne    802608 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802706:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80270a:	0f 84 c6 00 00 00    	je     8027d6 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802710:	a1 48 41 80 00       	mov    0x804148,%eax
  802715:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802718:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271b:	8b 55 08             	mov    0x8(%ebp),%edx
  80271e:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802721:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802724:	8b 50 08             	mov    0x8(%eax),%edx
  802727:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80272a:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  80272d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802730:	8b 40 0c             	mov    0xc(%eax),%eax
  802733:	2b 45 08             	sub    0x8(%ebp),%eax
  802736:	89 c2                	mov    %eax,%edx
  802738:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273b:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  80273e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802741:	8b 50 08             	mov    0x8(%eax),%edx
  802744:	8b 45 08             	mov    0x8(%ebp),%eax
  802747:	01 c2                	add    %eax,%edx
  802749:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274c:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  80274f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802753:	75 17                	jne    80276c <alloc_block_BF+0x18d>
  802755:	83 ec 04             	sub    $0x4,%esp
  802758:	68 c9 3c 80 00       	push   $0x803cc9
  80275d:	68 af 00 00 00       	push   $0xaf
  802762:	68 57 3c 80 00       	push   $0x803c57
  802767:	e8 31 dc ff ff       	call   80039d <_panic>
  80276c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276f:	8b 00                	mov    (%eax),%eax
  802771:	85 c0                	test   %eax,%eax
  802773:	74 10                	je     802785 <alloc_block_BF+0x1a6>
  802775:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802778:	8b 00                	mov    (%eax),%eax
  80277a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80277d:	8b 52 04             	mov    0x4(%edx),%edx
  802780:	89 50 04             	mov    %edx,0x4(%eax)
  802783:	eb 0b                	jmp    802790 <alloc_block_BF+0x1b1>
  802785:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802788:	8b 40 04             	mov    0x4(%eax),%eax
  80278b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802790:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802793:	8b 40 04             	mov    0x4(%eax),%eax
  802796:	85 c0                	test   %eax,%eax
  802798:	74 0f                	je     8027a9 <alloc_block_BF+0x1ca>
  80279a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80279d:	8b 40 04             	mov    0x4(%eax),%eax
  8027a0:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8027a3:	8b 12                	mov    (%edx),%edx
  8027a5:	89 10                	mov    %edx,(%eax)
  8027a7:	eb 0a                	jmp    8027b3 <alloc_block_BF+0x1d4>
  8027a9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027ac:	8b 00                	mov    (%eax),%eax
  8027ae:	a3 48 41 80 00       	mov    %eax,0x804148
  8027b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027c6:	a1 54 41 80 00       	mov    0x804154,%eax
  8027cb:	48                   	dec    %eax
  8027cc:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8027d1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027d4:	eb 05                	jmp    8027db <alloc_block_BF+0x1fc>
	}

	return NULL;
  8027d6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027db:	c9                   	leave  
  8027dc:	c3                   	ret    

008027dd <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8027dd:	55                   	push   %ebp
  8027de:	89 e5                	mov    %esp,%ebp
  8027e0:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8027e3:	a1 38 41 80 00       	mov    0x804138,%eax
  8027e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8027eb:	e9 7c 01 00 00       	jmp    80296c <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8027f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f6:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027f9:	0f 86 cf 00 00 00    	jbe    8028ce <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8027ff:	a1 48 41 80 00       	mov    0x804148,%eax
  802804:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802807:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280a:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  80280d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802810:	8b 55 08             	mov    0x8(%ebp),%edx
  802813:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 50 08             	mov    0x8(%eax),%edx
  80281c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281f:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802822:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802825:	8b 40 0c             	mov    0xc(%eax),%eax
  802828:	2b 45 08             	sub    0x8(%ebp),%eax
  80282b:	89 c2                	mov    %eax,%edx
  80282d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802830:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802833:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802836:	8b 50 08             	mov    0x8(%eax),%edx
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	01 c2                	add    %eax,%edx
  80283e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802841:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802844:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802848:	75 17                	jne    802861 <alloc_block_NF+0x84>
  80284a:	83 ec 04             	sub    $0x4,%esp
  80284d:	68 c9 3c 80 00       	push   $0x803cc9
  802852:	68 c4 00 00 00       	push   $0xc4
  802857:	68 57 3c 80 00       	push   $0x803c57
  80285c:	e8 3c db ff ff       	call   80039d <_panic>
  802861:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802864:	8b 00                	mov    (%eax),%eax
  802866:	85 c0                	test   %eax,%eax
  802868:	74 10                	je     80287a <alloc_block_NF+0x9d>
  80286a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286d:	8b 00                	mov    (%eax),%eax
  80286f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802872:	8b 52 04             	mov    0x4(%edx),%edx
  802875:	89 50 04             	mov    %edx,0x4(%eax)
  802878:	eb 0b                	jmp    802885 <alloc_block_NF+0xa8>
  80287a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80287d:	8b 40 04             	mov    0x4(%eax),%eax
  802880:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802885:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802888:	8b 40 04             	mov    0x4(%eax),%eax
  80288b:	85 c0                	test   %eax,%eax
  80288d:	74 0f                	je     80289e <alloc_block_NF+0xc1>
  80288f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802892:	8b 40 04             	mov    0x4(%eax),%eax
  802895:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802898:	8b 12                	mov    (%edx),%edx
  80289a:	89 10                	mov    %edx,(%eax)
  80289c:	eb 0a                	jmp    8028a8 <alloc_block_NF+0xcb>
  80289e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028a1:	8b 00                	mov    (%eax),%eax
  8028a3:	a3 48 41 80 00       	mov    %eax,0x804148
  8028a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ab:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028b4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028bb:	a1 54 41 80 00       	mov    0x804154,%eax
  8028c0:	48                   	dec    %eax
  8028c1:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8028c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028c9:	e9 ad 00 00 00       	jmp    80297b <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8028ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8028d4:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028d7:	0f 85 87 00 00 00    	jne    802964 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8028dd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028e1:	75 17                	jne    8028fa <alloc_block_NF+0x11d>
  8028e3:	83 ec 04             	sub    $0x4,%esp
  8028e6:	68 c9 3c 80 00       	push   $0x803cc9
  8028eb:	68 c8 00 00 00       	push   $0xc8
  8028f0:	68 57 3c 80 00       	push   $0x803c57
  8028f5:	e8 a3 da ff ff       	call   80039d <_panic>
  8028fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028fd:	8b 00                	mov    (%eax),%eax
  8028ff:	85 c0                	test   %eax,%eax
  802901:	74 10                	je     802913 <alloc_block_NF+0x136>
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 00                	mov    (%eax),%eax
  802908:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80290b:	8b 52 04             	mov    0x4(%edx),%edx
  80290e:	89 50 04             	mov    %edx,0x4(%eax)
  802911:	eb 0b                	jmp    80291e <alloc_block_NF+0x141>
  802913:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802916:	8b 40 04             	mov    0x4(%eax),%eax
  802919:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80291e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802921:	8b 40 04             	mov    0x4(%eax),%eax
  802924:	85 c0                	test   %eax,%eax
  802926:	74 0f                	je     802937 <alloc_block_NF+0x15a>
  802928:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292b:	8b 40 04             	mov    0x4(%eax),%eax
  80292e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802931:	8b 12                	mov    (%edx),%edx
  802933:	89 10                	mov    %edx,(%eax)
  802935:	eb 0a                	jmp    802941 <alloc_block_NF+0x164>
  802937:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80293a:	8b 00                	mov    (%eax),%eax
  80293c:	a3 38 41 80 00       	mov    %eax,0x804138
  802941:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802944:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80294a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802954:	a1 44 41 80 00       	mov    0x804144,%eax
  802959:	48                   	dec    %eax
  80295a:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  80295f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802962:	eb 17                	jmp    80297b <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802967:	8b 00                	mov    (%eax),%eax
  802969:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  80296c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802970:	0f 85 7a fe ff ff    	jne    8027f0 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802976:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  80297b:	c9                   	leave  
  80297c:	c3                   	ret    

0080297d <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80297d:	55                   	push   %ebp
  80297e:	89 e5                	mov    %esp,%ebp
  802980:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802983:	a1 38 41 80 00       	mov    0x804138,%eax
  802988:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  80298b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802990:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802993:	a1 44 41 80 00       	mov    0x804144,%eax
  802998:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  80299b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80299f:	75 68                	jne    802a09 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8029a1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029a5:	75 17                	jne    8029be <insert_sorted_with_merge_freeList+0x41>
  8029a7:	83 ec 04             	sub    $0x4,%esp
  8029aa:	68 34 3c 80 00       	push   $0x803c34
  8029af:	68 da 00 00 00       	push   $0xda
  8029b4:	68 57 3c 80 00       	push   $0x803c57
  8029b9:	e8 df d9 ff ff       	call   80039d <_panic>
  8029be:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8029c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c7:	89 10                	mov    %edx,(%eax)
  8029c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cc:	8b 00                	mov    (%eax),%eax
  8029ce:	85 c0                	test   %eax,%eax
  8029d0:	74 0d                	je     8029df <insert_sorted_with_merge_freeList+0x62>
  8029d2:	a1 38 41 80 00       	mov    0x804138,%eax
  8029d7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029da:	89 50 04             	mov    %edx,0x4(%eax)
  8029dd:	eb 08                	jmp    8029e7 <insert_sorted_with_merge_freeList+0x6a>
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ea:	a3 38 41 80 00       	mov    %eax,0x804138
  8029ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029f9:	a1 44 41 80 00       	mov    0x804144,%eax
  8029fe:	40                   	inc    %eax
  8029ff:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  802a04:	e9 49 07 00 00       	jmp    803152 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a0c:	8b 50 08             	mov    0x8(%eax),%edx
  802a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a12:	8b 40 0c             	mov    0xc(%eax),%eax
  802a15:	01 c2                	add    %eax,%edx
  802a17:	8b 45 08             	mov    0x8(%ebp),%eax
  802a1a:	8b 40 08             	mov    0x8(%eax),%eax
  802a1d:	39 c2                	cmp    %eax,%edx
  802a1f:	73 77                	jae    802a98 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802a21:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802a24:	8b 00                	mov    (%eax),%eax
  802a26:	85 c0                	test   %eax,%eax
  802a28:	75 6e                	jne    802a98 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802a2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a2e:	74 68                	je     802a98 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802a30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a34:	75 17                	jne    802a4d <insert_sorted_with_merge_freeList+0xd0>
  802a36:	83 ec 04             	sub    $0x4,%esp
  802a39:	68 70 3c 80 00       	push   $0x803c70
  802a3e:	68 e0 00 00 00       	push   $0xe0
  802a43:	68 57 3c 80 00       	push   $0x803c57
  802a48:	e8 50 d9 ff ff       	call   80039d <_panic>
  802a4d:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a53:	8b 45 08             	mov    0x8(%ebp),%eax
  802a56:	89 50 04             	mov    %edx,0x4(%eax)
  802a59:	8b 45 08             	mov    0x8(%ebp),%eax
  802a5c:	8b 40 04             	mov    0x4(%eax),%eax
  802a5f:	85 c0                	test   %eax,%eax
  802a61:	74 0c                	je     802a6f <insert_sorted_with_merge_freeList+0xf2>
  802a63:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a68:	8b 55 08             	mov    0x8(%ebp),%edx
  802a6b:	89 10                	mov    %edx,(%eax)
  802a6d:	eb 08                	jmp    802a77 <insert_sorted_with_merge_freeList+0xfa>
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	a3 38 41 80 00       	mov    %eax,0x804138
  802a77:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a82:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a88:	a1 44 41 80 00       	mov    0x804144,%eax
  802a8d:	40                   	inc    %eax
  802a8e:	a3 44 41 80 00       	mov    %eax,0x804144
  802a93:	e9 ba 06 00 00       	jmp    803152 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802a98:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9b:	8b 50 0c             	mov    0xc(%eax),%edx
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	8b 40 08             	mov    0x8(%eax),%eax
  802aa4:	01 c2                	add    %eax,%edx
  802aa6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aa9:	8b 40 08             	mov    0x8(%eax),%eax
  802aac:	39 c2                	cmp    %eax,%edx
  802aae:	73 78                	jae    802b28 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802ab0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ab3:	8b 40 04             	mov    0x4(%eax),%eax
  802ab6:	85 c0                	test   %eax,%eax
  802ab8:	75 6e                	jne    802b28 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802aba:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802abe:	74 68                	je     802b28 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802ac0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ac4:	75 17                	jne    802add <insert_sorted_with_merge_freeList+0x160>
  802ac6:	83 ec 04             	sub    $0x4,%esp
  802ac9:	68 34 3c 80 00       	push   $0x803c34
  802ace:	68 e6 00 00 00       	push   $0xe6
  802ad3:	68 57 3c 80 00       	push   $0x803c57
  802ad8:	e8 c0 d8 ff ff       	call   80039d <_panic>
  802add:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae6:	89 10                	mov    %edx,(%eax)
  802ae8:	8b 45 08             	mov    0x8(%ebp),%eax
  802aeb:	8b 00                	mov    (%eax),%eax
  802aed:	85 c0                	test   %eax,%eax
  802aef:	74 0d                	je     802afe <insert_sorted_with_merge_freeList+0x181>
  802af1:	a1 38 41 80 00       	mov    0x804138,%eax
  802af6:	8b 55 08             	mov    0x8(%ebp),%edx
  802af9:	89 50 04             	mov    %edx,0x4(%eax)
  802afc:	eb 08                	jmp    802b06 <insert_sorted_with_merge_freeList+0x189>
  802afe:	8b 45 08             	mov    0x8(%ebp),%eax
  802b01:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b06:	8b 45 08             	mov    0x8(%ebp),%eax
  802b09:	a3 38 41 80 00       	mov    %eax,0x804138
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b18:	a1 44 41 80 00       	mov    0x804144,%eax
  802b1d:	40                   	inc    %eax
  802b1e:	a3 44 41 80 00       	mov    %eax,0x804144
  802b23:	e9 2a 06 00 00       	jmp    803152 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802b28:	a1 38 41 80 00       	mov    0x804138,%eax
  802b2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b30:	e9 ed 05 00 00       	jmp    803122 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802b35:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b38:	8b 00                	mov    (%eax),%eax
  802b3a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802b3d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b41:	0f 84 a7 00 00 00    	je     802bee <insert_sorted_with_merge_freeList+0x271>
  802b47:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b4a:	8b 50 0c             	mov    0xc(%eax),%edx
  802b4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b50:	8b 40 08             	mov    0x8(%eax),%eax
  802b53:	01 c2                	add    %eax,%edx
  802b55:	8b 45 08             	mov    0x8(%ebp),%eax
  802b58:	8b 40 08             	mov    0x8(%eax),%eax
  802b5b:	39 c2                	cmp    %eax,%edx
  802b5d:	0f 83 8b 00 00 00    	jae    802bee <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802b63:	8b 45 08             	mov    0x8(%ebp),%eax
  802b66:	8b 50 0c             	mov    0xc(%eax),%edx
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	8b 40 08             	mov    0x8(%eax),%eax
  802b6f:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802b71:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b74:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802b77:	39 c2                	cmp    %eax,%edx
  802b79:	73 73                	jae    802bee <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802b7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b7f:	74 06                	je     802b87 <insert_sorted_with_merge_freeList+0x20a>
  802b81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b85:	75 17                	jne    802b9e <insert_sorted_with_merge_freeList+0x221>
  802b87:	83 ec 04             	sub    $0x4,%esp
  802b8a:	68 e8 3c 80 00       	push   $0x803ce8
  802b8f:	68 f0 00 00 00       	push   $0xf0
  802b94:	68 57 3c 80 00       	push   $0x803c57
  802b99:	e8 ff d7 ff ff       	call   80039d <_panic>
  802b9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba1:	8b 10                	mov    (%eax),%edx
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	89 10                	mov    %edx,(%eax)
  802ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bab:	8b 00                	mov    (%eax),%eax
  802bad:	85 c0                	test   %eax,%eax
  802baf:	74 0b                	je     802bbc <insert_sorted_with_merge_freeList+0x23f>
  802bb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb4:	8b 00                	mov    (%eax),%eax
  802bb6:	8b 55 08             	mov    0x8(%ebp),%edx
  802bb9:	89 50 04             	mov    %edx,0x4(%eax)
  802bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbf:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc2:	89 10                	mov    %edx,(%eax)
  802bc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802bc7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bca:	89 50 04             	mov    %edx,0x4(%eax)
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	8b 00                	mov    (%eax),%eax
  802bd2:	85 c0                	test   %eax,%eax
  802bd4:	75 08                	jne    802bde <insert_sorted_with_merge_freeList+0x261>
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bde:	a1 44 41 80 00       	mov    0x804144,%eax
  802be3:	40                   	inc    %eax
  802be4:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802be9:	e9 64 05 00 00       	jmp    803152 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802bee:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bf3:	8b 50 0c             	mov    0xc(%eax),%edx
  802bf6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bfb:	8b 40 08             	mov    0x8(%eax),%eax
  802bfe:	01 c2                	add    %eax,%edx
  802c00:	8b 45 08             	mov    0x8(%ebp),%eax
  802c03:	8b 40 08             	mov    0x8(%eax),%eax
  802c06:	39 c2                	cmp    %eax,%edx
  802c08:	0f 85 b1 00 00 00    	jne    802cbf <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802c0e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c13:	85 c0                	test   %eax,%eax
  802c15:	0f 84 a4 00 00 00    	je     802cbf <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802c1b:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c20:	8b 00                	mov    (%eax),%eax
  802c22:	85 c0                	test   %eax,%eax
  802c24:	0f 85 95 00 00 00    	jne    802cbf <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802c2a:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802c2f:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c35:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802c38:	8b 55 08             	mov    0x8(%ebp),%edx
  802c3b:	8b 52 0c             	mov    0xc(%edx),%edx
  802c3e:	01 ca                	add    %ecx,%edx
  802c40:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802c4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802c50:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c5b:	75 17                	jne    802c74 <insert_sorted_with_merge_freeList+0x2f7>
  802c5d:	83 ec 04             	sub    $0x4,%esp
  802c60:	68 34 3c 80 00       	push   $0x803c34
  802c65:	68 ff 00 00 00       	push   $0xff
  802c6a:	68 57 3c 80 00       	push   $0x803c57
  802c6f:	e8 29 d7 ff ff       	call   80039d <_panic>
  802c74:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c7a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c7d:	89 10                	mov    %edx,(%eax)
  802c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c82:	8b 00                	mov    (%eax),%eax
  802c84:	85 c0                	test   %eax,%eax
  802c86:	74 0d                	je     802c95 <insert_sorted_with_merge_freeList+0x318>
  802c88:	a1 48 41 80 00       	mov    0x804148,%eax
  802c8d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c90:	89 50 04             	mov    %edx,0x4(%eax)
  802c93:	eb 08                	jmp    802c9d <insert_sorted_with_merge_freeList+0x320>
  802c95:	8b 45 08             	mov    0x8(%ebp),%eax
  802c98:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca0:	a3 48 41 80 00       	mov    %eax,0x804148
  802ca5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802caf:	a1 54 41 80 00       	mov    0x804154,%eax
  802cb4:	40                   	inc    %eax
  802cb5:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802cba:	e9 93 04 00 00       	jmp    803152 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802cbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc2:	8b 50 08             	mov    0x8(%eax),%edx
  802cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc8:	8b 40 0c             	mov    0xc(%eax),%eax
  802ccb:	01 c2                	add    %eax,%edx
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	8b 40 08             	mov    0x8(%eax),%eax
  802cd3:	39 c2                	cmp    %eax,%edx
  802cd5:	0f 85 ae 00 00 00    	jne    802d89 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802cdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802cde:	8b 50 0c             	mov    0xc(%eax),%edx
  802ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce4:	8b 40 08             	mov    0x8(%eax),%eax
  802ce7:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802ce9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cec:	8b 00                	mov    (%eax),%eax
  802cee:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802cf1:	39 c2                	cmp    %eax,%edx
  802cf3:	0f 84 90 00 00 00    	je     802d89 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802cf9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cfc:	8b 50 0c             	mov    0xc(%eax),%edx
  802cff:	8b 45 08             	mov    0x8(%ebp),%eax
  802d02:	8b 40 0c             	mov    0xc(%eax),%eax
  802d05:	01 c2                	add    %eax,%edx
  802d07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d0a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d10:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d17:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d21:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d25:	75 17                	jne    802d3e <insert_sorted_with_merge_freeList+0x3c1>
  802d27:	83 ec 04             	sub    $0x4,%esp
  802d2a:	68 34 3c 80 00       	push   $0x803c34
  802d2f:	68 0b 01 00 00       	push   $0x10b
  802d34:	68 57 3c 80 00       	push   $0x803c57
  802d39:	e8 5f d6 ff ff       	call   80039d <_panic>
  802d3e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d44:	8b 45 08             	mov    0x8(%ebp),%eax
  802d47:	89 10                	mov    %edx,(%eax)
  802d49:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4c:	8b 00                	mov    (%eax),%eax
  802d4e:	85 c0                	test   %eax,%eax
  802d50:	74 0d                	je     802d5f <insert_sorted_with_merge_freeList+0x3e2>
  802d52:	a1 48 41 80 00       	mov    0x804148,%eax
  802d57:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5a:	89 50 04             	mov    %edx,0x4(%eax)
  802d5d:	eb 08                	jmp    802d67 <insert_sorted_with_merge_freeList+0x3ea>
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d67:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6a:	a3 48 41 80 00       	mov    %eax,0x804148
  802d6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d79:	a1 54 41 80 00       	mov    0x804154,%eax
  802d7e:	40                   	inc    %eax
  802d7f:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d84:	e9 c9 03 00 00       	jmp    803152 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d89:	8b 45 08             	mov    0x8(%ebp),%eax
  802d8c:	8b 50 0c             	mov    0xc(%eax),%edx
  802d8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d92:	8b 40 08             	mov    0x8(%eax),%eax
  802d95:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802d97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d9a:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d9d:	39 c2                	cmp    %eax,%edx
  802d9f:	0f 85 bb 00 00 00    	jne    802e60 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802da5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802da9:	0f 84 b1 00 00 00    	je     802e60 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	8b 40 04             	mov    0x4(%eax),%eax
  802db5:	85 c0                	test   %eax,%eax
  802db7:	0f 85 a3 00 00 00    	jne    802e60 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802dbd:	a1 38 41 80 00       	mov    0x804138,%eax
  802dc2:	8b 55 08             	mov    0x8(%ebp),%edx
  802dc5:	8b 52 08             	mov    0x8(%edx),%edx
  802dc8:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802dcb:	a1 38 41 80 00       	mov    0x804138,%eax
  802dd0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802dd6:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802dd9:	8b 55 08             	mov    0x8(%ebp),%edx
  802ddc:	8b 52 0c             	mov    0xc(%edx),%edx
  802ddf:	01 ca                	add    %ecx,%edx
  802de1:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802de4:	8b 45 08             	mov    0x8(%ebp),%eax
  802de7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802dee:	8b 45 08             	mov    0x8(%ebp),%eax
  802df1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802df8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dfc:	75 17                	jne    802e15 <insert_sorted_with_merge_freeList+0x498>
  802dfe:	83 ec 04             	sub    $0x4,%esp
  802e01:	68 34 3c 80 00       	push   $0x803c34
  802e06:	68 17 01 00 00       	push   $0x117
  802e0b:	68 57 3c 80 00       	push   $0x803c57
  802e10:	e8 88 d5 ff ff       	call   80039d <_panic>
  802e15:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e1b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1e:	89 10                	mov    %edx,(%eax)
  802e20:	8b 45 08             	mov    0x8(%ebp),%eax
  802e23:	8b 00                	mov    (%eax),%eax
  802e25:	85 c0                	test   %eax,%eax
  802e27:	74 0d                	je     802e36 <insert_sorted_with_merge_freeList+0x4b9>
  802e29:	a1 48 41 80 00       	mov    0x804148,%eax
  802e2e:	8b 55 08             	mov    0x8(%ebp),%edx
  802e31:	89 50 04             	mov    %edx,0x4(%eax)
  802e34:	eb 08                	jmp    802e3e <insert_sorted_with_merge_freeList+0x4c1>
  802e36:	8b 45 08             	mov    0x8(%ebp),%eax
  802e39:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e41:	a3 48 41 80 00       	mov    %eax,0x804148
  802e46:	8b 45 08             	mov    0x8(%ebp),%eax
  802e49:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e50:	a1 54 41 80 00       	mov    0x804154,%eax
  802e55:	40                   	inc    %eax
  802e56:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802e5b:	e9 f2 02 00 00       	jmp    803152 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802e60:	8b 45 08             	mov    0x8(%ebp),%eax
  802e63:	8b 50 08             	mov    0x8(%eax),%edx
  802e66:	8b 45 08             	mov    0x8(%ebp),%eax
  802e69:	8b 40 0c             	mov    0xc(%eax),%eax
  802e6c:	01 c2                	add    %eax,%edx
  802e6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e71:	8b 40 08             	mov    0x8(%eax),%eax
  802e74:	39 c2                	cmp    %eax,%edx
  802e76:	0f 85 be 00 00 00    	jne    802f3a <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802e7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7f:	8b 40 04             	mov    0x4(%eax),%eax
  802e82:	8b 50 08             	mov    0x8(%eax),%edx
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	8b 40 04             	mov    0x4(%eax),%eax
  802e8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802e8e:	01 c2                	add    %eax,%edx
  802e90:	8b 45 08             	mov    0x8(%ebp),%eax
  802e93:	8b 40 08             	mov    0x8(%eax),%eax
  802e96:	39 c2                	cmp    %eax,%edx
  802e98:	0f 84 9c 00 00 00    	je     802f3a <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802e9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea1:	8b 50 08             	mov    0x8(%eax),%edx
  802ea4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea7:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ead:	8b 50 0c             	mov    0xc(%eax),%edx
  802eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  802eb3:	8b 40 0c             	mov    0xc(%eax),%eax
  802eb6:	01 c2                	add    %eax,%edx
  802eb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ebb:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802ebe:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802ec8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ecb:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802ed2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ed6:	75 17                	jne    802eef <insert_sorted_with_merge_freeList+0x572>
  802ed8:	83 ec 04             	sub    $0x4,%esp
  802edb:	68 34 3c 80 00       	push   $0x803c34
  802ee0:	68 26 01 00 00       	push   $0x126
  802ee5:	68 57 3c 80 00       	push   $0x803c57
  802eea:	e8 ae d4 ff ff       	call   80039d <_panic>
  802eef:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ef5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef8:	89 10                	mov    %edx,(%eax)
  802efa:	8b 45 08             	mov    0x8(%ebp),%eax
  802efd:	8b 00                	mov    (%eax),%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	74 0d                	je     802f10 <insert_sorted_with_merge_freeList+0x593>
  802f03:	a1 48 41 80 00       	mov    0x804148,%eax
  802f08:	8b 55 08             	mov    0x8(%ebp),%edx
  802f0b:	89 50 04             	mov    %edx,0x4(%eax)
  802f0e:	eb 08                	jmp    802f18 <insert_sorted_with_merge_freeList+0x59b>
  802f10:	8b 45 08             	mov    0x8(%ebp),%eax
  802f13:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f18:	8b 45 08             	mov    0x8(%ebp),%eax
  802f1b:	a3 48 41 80 00       	mov    %eax,0x804148
  802f20:	8b 45 08             	mov    0x8(%ebp),%eax
  802f23:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f2a:	a1 54 41 80 00       	mov    0x804154,%eax
  802f2f:	40                   	inc    %eax
  802f30:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802f35:	e9 18 02 00 00       	jmp    803152 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802f3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3d:	8b 50 0c             	mov    0xc(%eax),%edx
  802f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f43:	8b 40 08             	mov    0x8(%eax),%eax
  802f46:	01 c2                	add    %eax,%edx
  802f48:	8b 45 08             	mov    0x8(%ebp),%eax
  802f4b:	8b 40 08             	mov    0x8(%eax),%eax
  802f4e:	39 c2                	cmp    %eax,%edx
  802f50:	0f 85 c4 01 00 00    	jne    80311a <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802f56:	8b 45 08             	mov    0x8(%ebp),%eax
  802f59:	8b 50 0c             	mov    0xc(%eax),%edx
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	8b 40 08             	mov    0x8(%eax),%eax
  802f62:	01 c2                	add    %eax,%edx
  802f64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f67:	8b 00                	mov    (%eax),%eax
  802f69:	8b 40 08             	mov    0x8(%eax),%eax
  802f6c:	39 c2                	cmp    %eax,%edx
  802f6e:	0f 85 a6 01 00 00    	jne    80311a <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802f74:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f78:	0f 84 9c 01 00 00    	je     80311a <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802f7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f81:	8b 50 0c             	mov    0xc(%eax),%edx
  802f84:	8b 45 08             	mov    0x8(%ebp),%eax
  802f87:	8b 40 0c             	mov    0xc(%eax),%eax
  802f8a:	01 c2                	add    %eax,%edx
  802f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f8f:	8b 00                	mov    (%eax),%eax
  802f91:	8b 40 0c             	mov    0xc(%eax),%eax
  802f94:	01 c2                	add    %eax,%edx
  802f96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f99:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f9f:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802fb0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fb4:	75 17                	jne    802fcd <insert_sorted_with_merge_freeList+0x650>
  802fb6:	83 ec 04             	sub    $0x4,%esp
  802fb9:	68 34 3c 80 00       	push   $0x803c34
  802fbe:	68 32 01 00 00       	push   $0x132
  802fc3:	68 57 3c 80 00       	push   $0x803c57
  802fc8:	e8 d0 d3 ff ff       	call   80039d <_panic>
  802fcd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd6:	89 10                	mov    %edx,(%eax)
  802fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  802fdb:	8b 00                	mov    (%eax),%eax
  802fdd:	85 c0                	test   %eax,%eax
  802fdf:	74 0d                	je     802fee <insert_sorted_with_merge_freeList+0x671>
  802fe1:	a1 48 41 80 00       	mov    0x804148,%eax
  802fe6:	8b 55 08             	mov    0x8(%ebp),%edx
  802fe9:	89 50 04             	mov    %edx,0x4(%eax)
  802fec:	eb 08                	jmp    802ff6 <insert_sorted_with_merge_freeList+0x679>
  802fee:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ff6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ff9:	a3 48 41 80 00       	mov    %eax,0x804148
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803008:	a1 54 41 80 00       	mov    0x804154,%eax
  80300d:	40                   	inc    %eax
  80300e:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  803013:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803016:	8b 00                	mov    (%eax),%eax
  803018:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  80301f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803022:	8b 00                	mov    (%eax),%eax
  803024:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  80302b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80302e:	8b 00                	mov    (%eax),%eax
  803030:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803033:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803037:	75 17                	jne    803050 <insert_sorted_with_merge_freeList+0x6d3>
  803039:	83 ec 04             	sub    $0x4,%esp
  80303c:	68 c9 3c 80 00       	push   $0x803cc9
  803041:	68 36 01 00 00       	push   $0x136
  803046:	68 57 3c 80 00       	push   $0x803c57
  80304b:	e8 4d d3 ff ff       	call   80039d <_panic>
  803050:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803053:	8b 00                	mov    (%eax),%eax
  803055:	85 c0                	test   %eax,%eax
  803057:	74 10                	je     803069 <insert_sorted_with_merge_freeList+0x6ec>
  803059:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305c:	8b 00                	mov    (%eax),%eax
  80305e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803061:	8b 52 04             	mov    0x4(%edx),%edx
  803064:	89 50 04             	mov    %edx,0x4(%eax)
  803067:	eb 0b                	jmp    803074 <insert_sorted_with_merge_freeList+0x6f7>
  803069:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80306c:	8b 40 04             	mov    0x4(%eax),%eax
  80306f:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803074:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803077:	8b 40 04             	mov    0x4(%eax),%eax
  80307a:	85 c0                	test   %eax,%eax
  80307c:	74 0f                	je     80308d <insert_sorted_with_merge_freeList+0x710>
  80307e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803081:	8b 40 04             	mov    0x4(%eax),%eax
  803084:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803087:	8b 12                	mov    (%edx),%edx
  803089:	89 10                	mov    %edx,(%eax)
  80308b:	eb 0a                	jmp    803097 <insert_sorted_with_merge_freeList+0x71a>
  80308d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803090:	8b 00                	mov    (%eax),%eax
  803092:	a3 38 41 80 00       	mov    %eax,0x804138
  803097:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80309a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030aa:	a1 44 41 80 00       	mov    0x804144,%eax
  8030af:	48                   	dec    %eax
  8030b0:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8030b5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8030b9:	75 17                	jne    8030d2 <insert_sorted_with_merge_freeList+0x755>
  8030bb:	83 ec 04             	sub    $0x4,%esp
  8030be:	68 34 3c 80 00       	push   $0x803c34
  8030c3:	68 37 01 00 00       	push   $0x137
  8030c8:	68 57 3c 80 00       	push   $0x803c57
  8030cd:	e8 cb d2 ff ff       	call   80039d <_panic>
  8030d2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030d8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030db:	89 10                	mov    %edx,(%eax)
  8030dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030e0:	8b 00                	mov    (%eax),%eax
  8030e2:	85 c0                	test   %eax,%eax
  8030e4:	74 0d                	je     8030f3 <insert_sorted_with_merge_freeList+0x776>
  8030e6:	a1 48 41 80 00       	mov    0x804148,%eax
  8030eb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030ee:	89 50 04             	mov    %edx,0x4(%eax)
  8030f1:	eb 08                	jmp    8030fb <insert_sorted_with_merge_freeList+0x77e>
  8030f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030f6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030fe:	a3 48 41 80 00       	mov    %eax,0x804148
  803103:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803106:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80310d:	a1 54 41 80 00       	mov    0x804154,%eax
  803112:	40                   	inc    %eax
  803113:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  803118:	eb 38                	jmp    803152 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80311a:	a1 40 41 80 00       	mov    0x804140,%eax
  80311f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803122:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803126:	74 07                	je     80312f <insert_sorted_with_merge_freeList+0x7b2>
  803128:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312b:	8b 00                	mov    (%eax),%eax
  80312d:	eb 05                	jmp    803134 <insert_sorted_with_merge_freeList+0x7b7>
  80312f:	b8 00 00 00 00       	mov    $0x0,%eax
  803134:	a3 40 41 80 00       	mov    %eax,0x804140
  803139:	a1 40 41 80 00       	mov    0x804140,%eax
  80313e:	85 c0                	test   %eax,%eax
  803140:	0f 85 ef f9 ff ff    	jne    802b35 <insert_sorted_with_merge_freeList+0x1b8>
  803146:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80314a:	0f 85 e5 f9 ff ff    	jne    802b35 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803150:	eb 00                	jmp    803152 <insert_sorted_with_merge_freeList+0x7d5>
  803152:	90                   	nop
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
