
obj/user/ef_MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 b4 01 00 00       	call   8001ea <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Scenario that tests the usage of shared variables
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	/*[1] CREATE SHARED VARIABLE & INITIALIZE IT*/
	int *X = smalloc("X", sizeof(int) , 1) ;
  80003e:	83 ec 04             	sub    $0x4,%esp
  800041:	6a 01                	push   $0x1
  800043:	6a 04                	push   $0x4
  800045:	68 00 34 80 00       	push   $0x803400
  80004a:	e8 a5 16 00 00       	call   8016f4 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	//cprintf("Do you want to use semaphore (y/n)? ") ;
	//char select = getchar() ;
	char select = 'y';
  80005e:	c6 45 f3 79          	movb   $0x79,-0xd(%ebp)
	//cputchar(select);
	//cputchar('\n');

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800062:	83 ec 04             	sub    $0x4,%esp
  800065:	6a 00                	push   $0x0
  800067:	6a 04                	push   $0x4
  800069:	68 02 34 80 00       	push   $0x803402
  80006e:	e8 81 16 00 00       	call   8016f4 <smalloc>
  800073:	83 c4 10             	add    $0x10,%esp
  800076:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  800079:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80007c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  800082:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  800086:	74 06                	je     80008e <_main+0x56>
  800088:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  80008c:	75 09                	jne    800097 <_main+0x5f>
		*useSem = 1 ;
  80008e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800091:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  800097:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80009a:	8b 00                	mov    (%eax),%eax
  80009c:	83 f8 01             	cmp    $0x1,%eax
  80009f:	75 12                	jne    8000b3 <_main+0x7b>
	{
		sys_createSemaphore("T", 0);
  8000a1:	83 ec 08             	sub    $0x8,%esp
  8000a4:	6a 00                	push   $0x0
  8000a6:	68 09 34 80 00       	push   $0x803409
  8000ab:	e8 c8 1a 00 00       	call   801b78 <sys_createSemaphore>
  8000b0:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000b3:	83 ec 04             	sub    $0x4,%esp
  8000b6:	6a 01                	push   $0x1
  8000b8:	6a 04                	push   $0x4
  8000ba:	68 0b 34 80 00       	push   $0x80340b
  8000bf:	e8 30 16 00 00       	call   8016f4 <smalloc>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000d3:	a1 20 40 80 00       	mov    0x804020,%eax
  8000d8:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000de:	89 c2                	mov    %eax,%edx
  8000e0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000e5:	8b 40 74             	mov    0x74(%eax),%eax
  8000e8:	6a 32                	push   $0x32
  8000ea:	52                   	push   %edx
  8000eb:	50                   	push   %eax
  8000ec:	68 19 34 80 00       	push   $0x803419
  8000f1:	e8 93 1b 00 00       	call   801c89 <sys_create_env>
  8000f6:	83 c4 10             	add    $0x10,%esp
  8000f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800101:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800107:	89 c2                	mov    %eax,%edx
  800109:	a1 20 40 80 00       	mov    0x804020,%eax
  80010e:	8b 40 74             	mov    0x74(%eax),%eax
  800111:	6a 32                	push   $0x32
  800113:	52                   	push   %edx
  800114:	50                   	push   %eax
  800115:	68 23 34 80 00       	push   $0x803423
  80011a:	e8 6a 1b 00 00       	call   801c89 <sys_create_env>
  80011f:	83 c4 10             	add    $0x10,%esp
  800122:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (envIdProcessA == E_ENV_CREATION_ERROR || envIdProcessB == E_ENV_CREATION_ERROR)
  800125:	83 7d e4 ef          	cmpl   $0xffffffef,-0x1c(%ebp)
  800129:	74 06                	je     800131 <_main+0xf9>
  80012b:	83 7d e0 ef          	cmpl   $0xffffffef,-0x20(%ebp)
  80012f:	75 14                	jne    800145 <_main+0x10d>
		panic("NO AVAILABLE ENVs...");
  800131:	83 ec 04             	sub    $0x4,%esp
  800134:	68 2d 34 80 00       	push   $0x80342d
  800139:	6a 27                	push   $0x27
  80013b:	68 42 34 80 00       	push   $0x803442
  800140:	e8 e1 01 00 00       	call   800326 <_panic>

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  800145:	83 ec 0c             	sub    $0xc,%esp
  800148:	ff 75 e4             	pushl  -0x1c(%ebp)
  80014b:	e8 57 1b 00 00       	call   801ca7 <sys_run_env>
  800150:	83 c4 10             	add    $0x10,%esp
	env_sleep(10000);
  800153:	83 ec 0c             	sub    $0xc,%esp
  800156:	68 10 27 00 00       	push   $0x2710
  80015b:	e8 7e 2f 00 00       	call   8030de <env_sleep>
  800160:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800163:	83 ec 0c             	sub    $0xc,%esp
  800166:	ff 75 e0             	pushl  -0x20(%ebp)
  800169:	e8 39 1b 00 00       	call   801ca7 <sys_run_env>
  80016e:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800171:	90                   	nop
  800172:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800175:	8b 00                	mov    (%eax),%eax
  800177:	83 f8 02             	cmp    $0x2,%eax
  80017a:	75 f6                	jne    800172 <_main+0x13a>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  80017c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80017f:	8b 00                	mov    (%eax),%eax
  800181:	83 ec 08             	sub    $0x8,%esp
  800184:	50                   	push   %eax
  800185:	68 5d 34 80 00       	push   $0x80345d
  80018a:	e8 4b 04 00 00       	call   8005da <cprintf>
  80018f:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  800192:	e8 79 1b 00 00       	call   801d10 <sys_getparentenvid>
  800197:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  80019a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80019e:	7e 47                	jle    8001e7 <_main+0x1af>
	{
		//Get the check-finishing counter
		int *AllFinish = NULL;
  8001a0:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		AllFinish = sget(parentenvID, "finishedCount") ;
  8001a7:	83 ec 08             	sub    $0x8,%esp
  8001aa:	68 0b 34 80 00       	push   $0x80340b
  8001af:	ff 75 dc             	pushl  -0x24(%ebp)
  8001b2:	e8 12 16 00 00       	call   8017c9 <sget>
  8001b7:	83 c4 10             	add    $0x10,%esp
  8001ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(envIdProcessA);
  8001bd:	83 ec 0c             	sub    $0xc,%esp
  8001c0:	ff 75 e4             	pushl  -0x1c(%ebp)
  8001c3:	e8 fb 1a 00 00       	call   801cc3 <sys_destroy_env>
  8001c8:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(envIdProcessB);
  8001cb:	83 ec 0c             	sub    $0xc,%esp
  8001ce:	ff 75 e0             	pushl  -0x20(%ebp)
  8001d1:	e8 ed 1a 00 00       	call   801cc3 <sys_destroy_env>
  8001d6:	83 c4 10             	add    $0x10,%esp
		(*AllFinish)++ ;
  8001d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001dc:	8b 00                	mov    (%eax),%eax
  8001de:	8d 50 01             	lea    0x1(%eax),%edx
  8001e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8001e4:	89 10                	mov    %edx,(%eax)
	}

	return;
  8001e6:	90                   	nop
  8001e7:	90                   	nop
}
  8001e8:	c9                   	leave  
  8001e9:	c3                   	ret    

008001ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8001ea:	55                   	push   %ebp
  8001eb:	89 e5                	mov    %esp,%ebp
  8001ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8001f0:	e8 02 1b 00 00       	call   801cf7 <sys_getenvindex>
  8001f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8001f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8001fb:	89 d0                	mov    %edx,%eax
  8001fd:	c1 e0 03             	shl    $0x3,%eax
  800200:	01 d0                	add    %edx,%eax
  800202:	01 c0                	add    %eax,%eax
  800204:	01 d0                	add    %edx,%eax
  800206:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80020d:	01 d0                	add    %edx,%eax
  80020f:	c1 e0 04             	shl    $0x4,%eax
  800212:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800217:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80021c:	a1 20 40 80 00       	mov    0x804020,%eax
  800221:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800227:	84 c0                	test   %al,%al
  800229:	74 0f                	je     80023a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80022b:	a1 20 40 80 00       	mov    0x804020,%eax
  800230:	05 5c 05 00 00       	add    $0x55c,%eax
  800235:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80023a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80023e:	7e 0a                	jle    80024a <libmain+0x60>
		binaryname = argv[0];
  800240:	8b 45 0c             	mov    0xc(%ebp),%eax
  800243:	8b 00                	mov    (%eax),%eax
  800245:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80024a:	83 ec 08             	sub    $0x8,%esp
  80024d:	ff 75 0c             	pushl  0xc(%ebp)
  800250:	ff 75 08             	pushl  0x8(%ebp)
  800253:	e8 e0 fd ff ff       	call   800038 <_main>
  800258:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80025b:	e8 a4 18 00 00       	call   801b04 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800260:	83 ec 0c             	sub    $0xc,%esp
  800263:	68 8c 34 80 00       	push   $0x80348c
  800268:	e8 6d 03 00 00       	call   8005da <cprintf>
  80026d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800270:	a1 20 40 80 00       	mov    0x804020,%eax
  800275:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80027b:	a1 20 40 80 00       	mov    0x804020,%eax
  800280:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	52                   	push   %edx
  80028a:	50                   	push   %eax
  80028b:	68 b4 34 80 00       	push   $0x8034b4
  800290:	e8 45 03 00 00       	call   8005da <cprintf>
  800295:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800298:	a1 20 40 80 00       	mov    0x804020,%eax
  80029d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002a3:	a1 20 40 80 00       	mov    0x804020,%eax
  8002a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002b9:	51                   	push   %ecx
  8002ba:	52                   	push   %edx
  8002bb:	50                   	push   %eax
  8002bc:	68 dc 34 80 00       	push   $0x8034dc
  8002c1:	e8 14 03 00 00       	call   8005da <cprintf>
  8002c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8002c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8002d4:	83 ec 08             	sub    $0x8,%esp
  8002d7:	50                   	push   %eax
  8002d8:	68 34 35 80 00       	push   $0x803534
  8002dd:	e8 f8 02 00 00       	call   8005da <cprintf>
  8002e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8002e5:	83 ec 0c             	sub    $0xc,%esp
  8002e8:	68 8c 34 80 00       	push   $0x80348c
  8002ed:	e8 e8 02 00 00       	call   8005da <cprintf>
  8002f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8002f5:	e8 24 18 00 00       	call   801b1e <sys_enable_interrupt>

	// exit gracefully
	exit();
  8002fa:	e8 19 00 00 00       	call   800318 <exit>
}
  8002ff:	90                   	nop
  800300:	c9                   	leave  
  800301:	c3                   	ret    

00800302 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800302:	55                   	push   %ebp
  800303:	89 e5                	mov    %esp,%ebp
  800305:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	6a 00                	push   $0x0
  80030d:	e8 b1 19 00 00       	call   801cc3 <sys_destroy_env>
  800312:	83 c4 10             	add    $0x10,%esp
}
  800315:	90                   	nop
  800316:	c9                   	leave  
  800317:	c3                   	ret    

00800318 <exit>:

void
exit(void)
{
  800318:	55                   	push   %ebp
  800319:	89 e5                	mov    %esp,%ebp
  80031b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80031e:	e8 06 1a 00 00       	call   801d29 <sys_exit_env>
}
  800323:	90                   	nop
  800324:	c9                   	leave  
  800325:	c3                   	ret    

00800326 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800326:	55                   	push   %ebp
  800327:	89 e5                	mov    %esp,%ebp
  800329:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80032c:	8d 45 10             	lea    0x10(%ebp),%eax
  80032f:	83 c0 04             	add    $0x4,%eax
  800332:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800335:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80033a:	85 c0                	test   %eax,%eax
  80033c:	74 16                	je     800354 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80033e:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800343:	83 ec 08             	sub    $0x8,%esp
  800346:	50                   	push   %eax
  800347:	68 48 35 80 00       	push   $0x803548
  80034c:	e8 89 02 00 00       	call   8005da <cprintf>
  800351:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800354:	a1 00 40 80 00       	mov    0x804000,%eax
  800359:	ff 75 0c             	pushl  0xc(%ebp)
  80035c:	ff 75 08             	pushl  0x8(%ebp)
  80035f:	50                   	push   %eax
  800360:	68 4d 35 80 00       	push   $0x80354d
  800365:	e8 70 02 00 00       	call   8005da <cprintf>
  80036a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80036d:	8b 45 10             	mov    0x10(%ebp),%eax
  800370:	83 ec 08             	sub    $0x8,%esp
  800373:	ff 75 f4             	pushl  -0xc(%ebp)
  800376:	50                   	push   %eax
  800377:	e8 f3 01 00 00       	call   80056f <vcprintf>
  80037c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80037f:	83 ec 08             	sub    $0x8,%esp
  800382:	6a 00                	push   $0x0
  800384:	68 69 35 80 00       	push   $0x803569
  800389:	e8 e1 01 00 00       	call   80056f <vcprintf>
  80038e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800391:	e8 82 ff ff ff       	call   800318 <exit>

	// should not return here
	while (1) ;
  800396:	eb fe                	jmp    800396 <_panic+0x70>

00800398 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800398:	55                   	push   %ebp
  800399:	89 e5                	mov    %esp,%ebp
  80039b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80039e:	a1 20 40 80 00       	mov    0x804020,%eax
  8003a3:	8b 50 74             	mov    0x74(%eax),%edx
  8003a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a9:	39 c2                	cmp    %eax,%edx
  8003ab:	74 14                	je     8003c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003ad:	83 ec 04             	sub    $0x4,%esp
  8003b0:	68 6c 35 80 00       	push   $0x80356c
  8003b5:	6a 26                	push   $0x26
  8003b7:	68 b8 35 80 00       	push   $0x8035b8
  8003bc:	e8 65 ff ff ff       	call   800326 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8003c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8003c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8003cf:	e9 c2 00 00 00       	jmp    800496 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003de:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e1:	01 d0                	add    %edx,%eax
  8003e3:	8b 00                	mov    (%eax),%eax
  8003e5:	85 c0                	test   %eax,%eax
  8003e7:	75 08                	jne    8003f1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8003e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8003ec:	e9 a2 00 00 00       	jmp    800493 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8003f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8003f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8003ff:	eb 69                	jmp    80046a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800401:	a1 20 40 80 00       	mov    0x804020,%eax
  800406:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80040c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80040f:	89 d0                	mov    %edx,%eax
  800411:	01 c0                	add    %eax,%eax
  800413:	01 d0                	add    %edx,%eax
  800415:	c1 e0 03             	shl    $0x3,%eax
  800418:	01 c8                	add    %ecx,%eax
  80041a:	8a 40 04             	mov    0x4(%eax),%al
  80041d:	84 c0                	test   %al,%al
  80041f:	75 46                	jne    800467 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800421:	a1 20 40 80 00       	mov    0x804020,%eax
  800426:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80042c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80042f:	89 d0                	mov    %edx,%eax
  800431:	01 c0                	add    %eax,%eax
  800433:	01 d0                	add    %edx,%eax
  800435:	c1 e0 03             	shl    $0x3,%eax
  800438:	01 c8                	add    %ecx,%eax
  80043a:	8b 00                	mov    (%eax),%eax
  80043c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80043f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800442:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800447:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800449:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80044c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800453:	8b 45 08             	mov    0x8(%ebp),%eax
  800456:	01 c8                	add    %ecx,%eax
  800458:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80045a:	39 c2                	cmp    %eax,%edx
  80045c:	75 09                	jne    800467 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80045e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800465:	eb 12                	jmp    800479 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800467:	ff 45 e8             	incl   -0x18(%ebp)
  80046a:	a1 20 40 80 00       	mov    0x804020,%eax
  80046f:	8b 50 74             	mov    0x74(%eax),%edx
  800472:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800475:	39 c2                	cmp    %eax,%edx
  800477:	77 88                	ja     800401 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800479:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80047d:	75 14                	jne    800493 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80047f:	83 ec 04             	sub    $0x4,%esp
  800482:	68 c4 35 80 00       	push   $0x8035c4
  800487:	6a 3a                	push   $0x3a
  800489:	68 b8 35 80 00       	push   $0x8035b8
  80048e:	e8 93 fe ff ff       	call   800326 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800493:	ff 45 f0             	incl   -0x10(%ebp)
  800496:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800499:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80049c:	0f 8c 32 ff ff ff    	jl     8003d4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004b0:	eb 26                	jmp    8004d8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004b2:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8004c0:	89 d0                	mov    %edx,%eax
  8004c2:	01 c0                	add    %eax,%eax
  8004c4:	01 d0                	add    %edx,%eax
  8004c6:	c1 e0 03             	shl    $0x3,%eax
  8004c9:	01 c8                	add    %ecx,%eax
  8004cb:	8a 40 04             	mov    0x4(%eax),%al
  8004ce:	3c 01                	cmp    $0x1,%al
  8004d0:	75 03                	jne    8004d5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8004d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004d5:	ff 45 e0             	incl   -0x20(%ebp)
  8004d8:	a1 20 40 80 00       	mov    0x804020,%eax
  8004dd:	8b 50 74             	mov    0x74(%eax),%edx
  8004e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004e3:	39 c2                	cmp    %eax,%edx
  8004e5:	77 cb                	ja     8004b2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8004e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004ed:	74 14                	je     800503 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8004ef:	83 ec 04             	sub    $0x4,%esp
  8004f2:	68 18 36 80 00       	push   $0x803618
  8004f7:	6a 44                	push   $0x44
  8004f9:	68 b8 35 80 00       	push   $0x8035b8
  8004fe:	e8 23 fe ff ff       	call   800326 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800503:	90                   	nop
  800504:	c9                   	leave  
  800505:	c3                   	ret    

00800506 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800506:	55                   	push   %ebp
  800507:	89 e5                	mov    %esp,%ebp
  800509:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80050c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	8d 48 01             	lea    0x1(%eax),%ecx
  800514:	8b 55 0c             	mov    0xc(%ebp),%edx
  800517:	89 0a                	mov    %ecx,(%edx)
  800519:	8b 55 08             	mov    0x8(%ebp),%edx
  80051c:	88 d1                	mov    %dl,%cl
  80051e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800521:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800525:	8b 45 0c             	mov    0xc(%ebp),%eax
  800528:	8b 00                	mov    (%eax),%eax
  80052a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80052f:	75 2c                	jne    80055d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800531:	a0 24 40 80 00       	mov    0x804024,%al
  800536:	0f b6 c0             	movzbl %al,%eax
  800539:	8b 55 0c             	mov    0xc(%ebp),%edx
  80053c:	8b 12                	mov    (%edx),%edx
  80053e:	89 d1                	mov    %edx,%ecx
  800540:	8b 55 0c             	mov    0xc(%ebp),%edx
  800543:	83 c2 08             	add    $0x8,%edx
  800546:	83 ec 04             	sub    $0x4,%esp
  800549:	50                   	push   %eax
  80054a:	51                   	push   %ecx
  80054b:	52                   	push   %edx
  80054c:	e8 05 14 00 00       	call   801956 <sys_cputs>
  800551:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800554:	8b 45 0c             	mov    0xc(%ebp),%eax
  800557:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80055d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800560:	8b 40 04             	mov    0x4(%eax),%eax
  800563:	8d 50 01             	lea    0x1(%eax),%edx
  800566:	8b 45 0c             	mov    0xc(%ebp),%eax
  800569:	89 50 04             	mov    %edx,0x4(%eax)
}
  80056c:	90                   	nop
  80056d:	c9                   	leave  
  80056e:	c3                   	ret    

0080056f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80056f:	55                   	push   %ebp
  800570:	89 e5                	mov    %esp,%ebp
  800572:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800578:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80057f:	00 00 00 
	b.cnt = 0;
  800582:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800589:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80058c:	ff 75 0c             	pushl  0xc(%ebp)
  80058f:	ff 75 08             	pushl  0x8(%ebp)
  800592:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800598:	50                   	push   %eax
  800599:	68 06 05 80 00       	push   $0x800506
  80059e:	e8 11 02 00 00       	call   8007b4 <vprintfmt>
  8005a3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005a6:	a0 24 40 80 00       	mov    0x804024,%al
  8005ab:	0f b6 c0             	movzbl %al,%eax
  8005ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005b4:	83 ec 04             	sub    $0x4,%esp
  8005b7:	50                   	push   %eax
  8005b8:	52                   	push   %edx
  8005b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005bf:	83 c0 08             	add    $0x8,%eax
  8005c2:	50                   	push   %eax
  8005c3:	e8 8e 13 00 00       	call   801956 <sys_cputs>
  8005c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8005cb:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  8005d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8005d8:	c9                   	leave  
  8005d9:	c3                   	ret    

008005da <cprintf>:

int cprintf(const char *fmt, ...) {
  8005da:	55                   	push   %ebp
  8005db:	89 e5                	mov    %esp,%ebp
  8005dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8005e0:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  8005e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8005ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	83 ec 08             	sub    $0x8,%esp
  8005f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8005f6:	50                   	push   %eax
  8005f7:	e8 73 ff ff ff       	call   80056f <vcprintf>
  8005fc:	83 c4 10             	add    $0x10,%esp
  8005ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800602:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800605:	c9                   	leave  
  800606:	c3                   	ret    

00800607 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800607:	55                   	push   %ebp
  800608:	89 e5                	mov    %esp,%ebp
  80060a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80060d:	e8 f2 14 00 00       	call   801b04 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800612:	8d 45 0c             	lea    0xc(%ebp),%eax
  800615:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800618:	8b 45 08             	mov    0x8(%ebp),%eax
  80061b:	83 ec 08             	sub    $0x8,%esp
  80061e:	ff 75 f4             	pushl  -0xc(%ebp)
  800621:	50                   	push   %eax
  800622:	e8 48 ff ff ff       	call   80056f <vcprintf>
  800627:	83 c4 10             	add    $0x10,%esp
  80062a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  80062d:	e8 ec 14 00 00       	call   801b1e <sys_enable_interrupt>
	return cnt;
  800632:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800635:	c9                   	leave  
  800636:	c3                   	ret    

00800637 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800637:	55                   	push   %ebp
  800638:	89 e5                	mov    %esp,%ebp
  80063a:	53                   	push   %ebx
  80063b:	83 ec 14             	sub    $0x14,%esp
  80063e:	8b 45 10             	mov    0x10(%ebp),%eax
  800641:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800644:	8b 45 14             	mov    0x14(%ebp),%eax
  800647:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80064a:	8b 45 18             	mov    0x18(%ebp),%eax
  80064d:	ba 00 00 00 00       	mov    $0x0,%edx
  800652:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800655:	77 55                	ja     8006ac <printnum+0x75>
  800657:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80065a:	72 05                	jb     800661 <printnum+0x2a>
  80065c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80065f:	77 4b                	ja     8006ac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800661:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800664:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800667:	8b 45 18             	mov    0x18(%ebp),%eax
  80066a:	ba 00 00 00 00       	mov    $0x0,%edx
  80066f:	52                   	push   %edx
  800670:	50                   	push   %eax
  800671:	ff 75 f4             	pushl  -0xc(%ebp)
  800674:	ff 75 f0             	pushl  -0x10(%ebp)
  800677:	e8 18 2b 00 00       	call   803194 <__udivdi3>
  80067c:	83 c4 10             	add    $0x10,%esp
  80067f:	83 ec 04             	sub    $0x4,%esp
  800682:	ff 75 20             	pushl  0x20(%ebp)
  800685:	53                   	push   %ebx
  800686:	ff 75 18             	pushl  0x18(%ebp)
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	ff 75 0c             	pushl  0xc(%ebp)
  80068e:	ff 75 08             	pushl  0x8(%ebp)
  800691:	e8 a1 ff ff ff       	call   800637 <printnum>
  800696:	83 c4 20             	add    $0x20,%esp
  800699:	eb 1a                	jmp    8006b5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80069b:	83 ec 08             	sub    $0x8,%esp
  80069e:	ff 75 0c             	pushl  0xc(%ebp)
  8006a1:	ff 75 20             	pushl  0x20(%ebp)
  8006a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a7:	ff d0                	call   *%eax
  8006a9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006ac:	ff 4d 1c             	decl   0x1c(%ebp)
  8006af:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006b3:	7f e6                	jg     80069b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006b5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006b8:	bb 00 00 00 00       	mov    $0x0,%ebx
  8006bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8006c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8006c3:	53                   	push   %ebx
  8006c4:	51                   	push   %ecx
  8006c5:	52                   	push   %edx
  8006c6:	50                   	push   %eax
  8006c7:	e8 d8 2b 00 00       	call   8032a4 <__umoddi3>
  8006cc:	83 c4 10             	add    $0x10,%esp
  8006cf:	05 94 38 80 00       	add    $0x803894,%eax
  8006d4:	8a 00                	mov    (%eax),%al
  8006d6:	0f be c0             	movsbl %al,%eax
  8006d9:	83 ec 08             	sub    $0x8,%esp
  8006dc:	ff 75 0c             	pushl  0xc(%ebp)
  8006df:	50                   	push   %eax
  8006e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006e3:	ff d0                	call   *%eax
  8006e5:	83 c4 10             	add    $0x10,%esp
}
  8006e8:	90                   	nop
  8006e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8006ec:	c9                   	leave  
  8006ed:	c3                   	ret    

008006ee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8006ee:	55                   	push   %ebp
  8006ef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8006f1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8006f5:	7e 1c                	jle    800713 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8006f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006fa:	8b 00                	mov    (%eax),%eax
  8006fc:	8d 50 08             	lea    0x8(%eax),%edx
  8006ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800702:	89 10                	mov    %edx,(%eax)
  800704:	8b 45 08             	mov    0x8(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	83 e8 08             	sub    $0x8,%eax
  80070c:	8b 50 04             	mov    0x4(%eax),%edx
  80070f:	8b 00                	mov    (%eax),%eax
  800711:	eb 40                	jmp    800753 <getuint+0x65>
	else if (lflag)
  800713:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800717:	74 1e                	je     800737 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800719:	8b 45 08             	mov    0x8(%ebp),%eax
  80071c:	8b 00                	mov    (%eax),%eax
  80071e:	8d 50 04             	lea    0x4(%eax),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	89 10                	mov    %edx,(%eax)
  800726:	8b 45 08             	mov    0x8(%ebp),%eax
  800729:	8b 00                	mov    (%eax),%eax
  80072b:	83 e8 04             	sub    $0x4,%eax
  80072e:	8b 00                	mov    (%eax),%eax
  800730:	ba 00 00 00 00       	mov    $0x0,%edx
  800735:	eb 1c                	jmp    800753 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800737:	8b 45 08             	mov    0x8(%ebp),%eax
  80073a:	8b 00                	mov    (%eax),%eax
  80073c:	8d 50 04             	lea    0x4(%eax),%edx
  80073f:	8b 45 08             	mov    0x8(%ebp),%eax
  800742:	89 10                	mov    %edx,(%eax)
  800744:	8b 45 08             	mov    0x8(%ebp),%eax
  800747:	8b 00                	mov    (%eax),%eax
  800749:	83 e8 04             	sub    $0x4,%eax
  80074c:	8b 00                	mov    (%eax),%eax
  80074e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800753:	5d                   	pop    %ebp
  800754:	c3                   	ret    

00800755 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800755:	55                   	push   %ebp
  800756:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800758:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80075c:	7e 1c                	jle    80077a <getint+0x25>
		return va_arg(*ap, long long);
  80075e:	8b 45 08             	mov    0x8(%ebp),%eax
  800761:	8b 00                	mov    (%eax),%eax
  800763:	8d 50 08             	lea    0x8(%eax),%edx
  800766:	8b 45 08             	mov    0x8(%ebp),%eax
  800769:	89 10                	mov    %edx,(%eax)
  80076b:	8b 45 08             	mov    0x8(%ebp),%eax
  80076e:	8b 00                	mov    (%eax),%eax
  800770:	83 e8 08             	sub    $0x8,%eax
  800773:	8b 50 04             	mov    0x4(%eax),%edx
  800776:	8b 00                	mov    (%eax),%eax
  800778:	eb 38                	jmp    8007b2 <getint+0x5d>
	else if (lflag)
  80077a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80077e:	74 1a                	je     80079a <getint+0x45>
		return va_arg(*ap, long);
  800780:	8b 45 08             	mov    0x8(%ebp),%eax
  800783:	8b 00                	mov    (%eax),%eax
  800785:	8d 50 04             	lea    0x4(%eax),%edx
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	89 10                	mov    %edx,(%eax)
  80078d:	8b 45 08             	mov    0x8(%ebp),%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	83 e8 04             	sub    $0x4,%eax
  800795:	8b 00                	mov    (%eax),%eax
  800797:	99                   	cltd   
  800798:	eb 18                	jmp    8007b2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80079a:	8b 45 08             	mov    0x8(%ebp),%eax
  80079d:	8b 00                	mov    (%eax),%eax
  80079f:	8d 50 04             	lea    0x4(%eax),%edx
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	89 10                	mov    %edx,(%eax)
  8007a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007aa:	8b 00                	mov    (%eax),%eax
  8007ac:	83 e8 04             	sub    $0x4,%eax
  8007af:	8b 00                	mov    (%eax),%eax
  8007b1:	99                   	cltd   
}
  8007b2:	5d                   	pop    %ebp
  8007b3:	c3                   	ret    

008007b4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007b4:	55                   	push   %ebp
  8007b5:	89 e5                	mov    %esp,%ebp
  8007b7:	56                   	push   %esi
  8007b8:	53                   	push   %ebx
  8007b9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007bc:	eb 17                	jmp    8007d5 <vprintfmt+0x21>
			if (ch == '\0')
  8007be:	85 db                	test   %ebx,%ebx
  8007c0:	0f 84 af 03 00 00    	je     800b75 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8007c6:	83 ec 08             	sub    $0x8,%esp
  8007c9:	ff 75 0c             	pushl  0xc(%ebp)
  8007cc:	53                   	push   %ebx
  8007cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d0:	ff d0                	call   *%eax
  8007d2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8007d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8007d8:	8d 50 01             	lea    0x1(%eax),%edx
  8007db:	89 55 10             	mov    %edx,0x10(%ebp)
  8007de:	8a 00                	mov    (%eax),%al
  8007e0:	0f b6 d8             	movzbl %al,%ebx
  8007e3:	83 fb 25             	cmp    $0x25,%ebx
  8007e6:	75 d6                	jne    8007be <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8007e8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8007ec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8007f3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8007fa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800801:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800808:	8b 45 10             	mov    0x10(%ebp),%eax
  80080b:	8d 50 01             	lea    0x1(%eax),%edx
  80080e:	89 55 10             	mov    %edx,0x10(%ebp)
  800811:	8a 00                	mov    (%eax),%al
  800813:	0f b6 d8             	movzbl %al,%ebx
  800816:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800819:	83 f8 55             	cmp    $0x55,%eax
  80081c:	0f 87 2b 03 00 00    	ja     800b4d <vprintfmt+0x399>
  800822:	8b 04 85 b8 38 80 00 	mov    0x8038b8(,%eax,4),%eax
  800829:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80082b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  80082f:	eb d7                	jmp    800808 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800831:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800835:	eb d1                	jmp    800808 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800837:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  80083e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800841:	89 d0                	mov    %edx,%eax
  800843:	c1 e0 02             	shl    $0x2,%eax
  800846:	01 d0                	add    %edx,%eax
  800848:	01 c0                	add    %eax,%eax
  80084a:	01 d8                	add    %ebx,%eax
  80084c:	83 e8 30             	sub    $0x30,%eax
  80084f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800852:	8b 45 10             	mov    0x10(%ebp),%eax
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80085a:	83 fb 2f             	cmp    $0x2f,%ebx
  80085d:	7e 3e                	jle    80089d <vprintfmt+0xe9>
  80085f:	83 fb 39             	cmp    $0x39,%ebx
  800862:	7f 39                	jg     80089d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800864:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800867:	eb d5                	jmp    80083e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800869:	8b 45 14             	mov    0x14(%ebp),%eax
  80086c:	83 c0 04             	add    $0x4,%eax
  80086f:	89 45 14             	mov    %eax,0x14(%ebp)
  800872:	8b 45 14             	mov    0x14(%ebp),%eax
  800875:	83 e8 04             	sub    $0x4,%eax
  800878:	8b 00                	mov    (%eax),%eax
  80087a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80087d:	eb 1f                	jmp    80089e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	79 83                	jns    800808 <vprintfmt+0x54>
				width = 0;
  800885:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80088c:	e9 77 ff ff ff       	jmp    800808 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800891:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800898:	e9 6b ff ff ff       	jmp    800808 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80089d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80089e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008a2:	0f 89 60 ff ff ff    	jns    800808 <vprintfmt+0x54>
				width = precision, precision = -1;
  8008a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008ae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008b5:	e9 4e ff ff ff       	jmp    800808 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008ba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  8008bd:	e9 46 ff ff ff       	jmp    800808 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  8008c2:	8b 45 14             	mov    0x14(%ebp),%eax
  8008c5:	83 c0 04             	add    $0x4,%eax
  8008c8:	89 45 14             	mov    %eax,0x14(%ebp)
  8008cb:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ce:	83 e8 04             	sub    $0x4,%eax
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	83 ec 08             	sub    $0x8,%esp
  8008d6:	ff 75 0c             	pushl  0xc(%ebp)
  8008d9:	50                   	push   %eax
  8008da:	8b 45 08             	mov    0x8(%ebp),%eax
  8008dd:	ff d0                	call   *%eax
  8008df:	83 c4 10             	add    $0x10,%esp
			break;
  8008e2:	e9 89 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8008e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8008ea:	83 c0 04             	add    $0x4,%eax
  8008ed:	89 45 14             	mov    %eax,0x14(%ebp)
  8008f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008f3:	83 e8 04             	sub    $0x4,%eax
  8008f6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8008f8:	85 db                	test   %ebx,%ebx
  8008fa:	79 02                	jns    8008fe <vprintfmt+0x14a>
				err = -err;
  8008fc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8008fe:	83 fb 64             	cmp    $0x64,%ebx
  800901:	7f 0b                	jg     80090e <vprintfmt+0x15a>
  800903:	8b 34 9d 00 37 80 00 	mov    0x803700(,%ebx,4),%esi
  80090a:	85 f6                	test   %esi,%esi
  80090c:	75 19                	jne    800927 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80090e:	53                   	push   %ebx
  80090f:	68 a5 38 80 00       	push   $0x8038a5
  800914:	ff 75 0c             	pushl  0xc(%ebp)
  800917:	ff 75 08             	pushl  0x8(%ebp)
  80091a:	e8 5e 02 00 00       	call   800b7d <printfmt>
  80091f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800922:	e9 49 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800927:	56                   	push   %esi
  800928:	68 ae 38 80 00       	push   $0x8038ae
  80092d:	ff 75 0c             	pushl  0xc(%ebp)
  800930:	ff 75 08             	pushl  0x8(%ebp)
  800933:	e8 45 02 00 00       	call   800b7d <printfmt>
  800938:	83 c4 10             	add    $0x10,%esp
			break;
  80093b:	e9 30 02 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800940:	8b 45 14             	mov    0x14(%ebp),%eax
  800943:	83 c0 04             	add    $0x4,%eax
  800946:	89 45 14             	mov    %eax,0x14(%ebp)
  800949:	8b 45 14             	mov    0x14(%ebp),%eax
  80094c:	83 e8 04             	sub    $0x4,%eax
  80094f:	8b 30                	mov    (%eax),%esi
  800951:	85 f6                	test   %esi,%esi
  800953:	75 05                	jne    80095a <vprintfmt+0x1a6>
				p = "(null)";
  800955:	be b1 38 80 00       	mov    $0x8038b1,%esi
			if (width > 0 && padc != '-')
  80095a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80095e:	7e 6d                	jle    8009cd <vprintfmt+0x219>
  800960:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800964:	74 67                	je     8009cd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800966:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800969:	83 ec 08             	sub    $0x8,%esp
  80096c:	50                   	push   %eax
  80096d:	56                   	push   %esi
  80096e:	e8 0c 03 00 00       	call   800c7f <strnlen>
  800973:	83 c4 10             	add    $0x10,%esp
  800976:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800979:	eb 16                	jmp    800991 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80097b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  80097f:	83 ec 08             	sub    $0x8,%esp
  800982:	ff 75 0c             	pushl  0xc(%ebp)
  800985:	50                   	push   %eax
  800986:	8b 45 08             	mov    0x8(%ebp),%eax
  800989:	ff d0                	call   *%eax
  80098b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80098e:	ff 4d e4             	decl   -0x1c(%ebp)
  800991:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800995:	7f e4                	jg     80097b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800997:	eb 34                	jmp    8009cd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800999:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80099d:	74 1c                	je     8009bb <vprintfmt+0x207>
  80099f:	83 fb 1f             	cmp    $0x1f,%ebx
  8009a2:	7e 05                	jle    8009a9 <vprintfmt+0x1f5>
  8009a4:	83 fb 7e             	cmp    $0x7e,%ebx
  8009a7:	7e 12                	jle    8009bb <vprintfmt+0x207>
					putch('?', putdat);
  8009a9:	83 ec 08             	sub    $0x8,%esp
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	6a 3f                	push   $0x3f
  8009b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b4:	ff d0                	call   *%eax
  8009b6:	83 c4 10             	add    $0x10,%esp
  8009b9:	eb 0f                	jmp    8009ca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009bb:	83 ec 08             	sub    $0x8,%esp
  8009be:	ff 75 0c             	pushl  0xc(%ebp)
  8009c1:	53                   	push   %ebx
  8009c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c5:	ff d0                	call   *%eax
  8009c7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009ca:	ff 4d e4             	decl   -0x1c(%ebp)
  8009cd:	89 f0                	mov    %esi,%eax
  8009cf:	8d 70 01             	lea    0x1(%eax),%esi
  8009d2:	8a 00                	mov    (%eax),%al
  8009d4:	0f be d8             	movsbl %al,%ebx
  8009d7:	85 db                	test   %ebx,%ebx
  8009d9:	74 24                	je     8009ff <vprintfmt+0x24b>
  8009db:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009df:	78 b8                	js     800999 <vprintfmt+0x1e5>
  8009e1:	ff 4d e0             	decl   -0x20(%ebp)
  8009e4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8009e8:	79 af                	jns    800999 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009ea:	eb 13                	jmp    8009ff <vprintfmt+0x24b>
				putch(' ', putdat);
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 0c             	pushl  0xc(%ebp)
  8009f2:	6a 20                	push   $0x20
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	ff d0                	call   *%eax
  8009f9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  8009fc:	ff 4d e4             	decl   -0x1c(%ebp)
  8009ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a03:	7f e7                	jg     8009ec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a05:	e9 66 01 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a0a:	83 ec 08             	sub    $0x8,%esp
  800a0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800a10:	8d 45 14             	lea    0x14(%ebp),%eax
  800a13:	50                   	push   %eax
  800a14:	e8 3c fd ff ff       	call   800755 <getint>
  800a19:	83 c4 10             	add    $0x10,%esp
  800a1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a28:	85 d2                	test   %edx,%edx
  800a2a:	79 23                	jns    800a4f <vprintfmt+0x29b>
				putch('-', putdat);
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	ff 75 0c             	pushl  0xc(%ebp)
  800a32:	6a 2d                	push   $0x2d
  800a34:	8b 45 08             	mov    0x8(%ebp),%eax
  800a37:	ff d0                	call   *%eax
  800a39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a42:	f7 d8                	neg    %eax
  800a44:	83 d2 00             	adc    $0x0,%edx
  800a47:	f7 da                	neg    %edx
  800a49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a56:	e9 bc 00 00 00       	jmp    800b17 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a5b:	83 ec 08             	sub    $0x8,%esp
  800a5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800a61:	8d 45 14             	lea    0x14(%ebp),%eax
  800a64:	50                   	push   %eax
  800a65:	e8 84 fc ff ff       	call   8006ee <getuint>
  800a6a:	83 c4 10             	add    $0x10,%esp
  800a6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800a73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a7a:	e9 98 00 00 00       	jmp    800b17 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800a7f:	83 ec 08             	sub    $0x8,%esp
  800a82:	ff 75 0c             	pushl  0xc(%ebp)
  800a85:	6a 58                	push   $0x58
  800a87:	8b 45 08             	mov    0x8(%ebp),%eax
  800a8a:	ff d0                	call   *%eax
  800a8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a8f:	83 ec 08             	sub    $0x8,%esp
  800a92:	ff 75 0c             	pushl  0xc(%ebp)
  800a95:	6a 58                	push   $0x58
  800a97:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9a:	ff d0                	call   *%eax
  800a9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 0c             	pushl  0xc(%ebp)
  800aa5:	6a 58                	push   $0x58
  800aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aaa:	ff d0                	call   *%eax
  800aac:	83 c4 10             	add    $0x10,%esp
			break;
  800aaf:	e9 bc 00 00 00       	jmp    800b70 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800ab4:	83 ec 08             	sub    $0x8,%esp
  800ab7:	ff 75 0c             	pushl  0xc(%ebp)
  800aba:	6a 30                	push   $0x30
  800abc:	8b 45 08             	mov    0x8(%ebp),%eax
  800abf:	ff d0                	call   *%eax
  800ac1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ac4:	83 ec 08             	sub    $0x8,%esp
  800ac7:	ff 75 0c             	pushl  0xc(%ebp)
  800aca:	6a 78                	push   $0x78
  800acc:	8b 45 08             	mov    0x8(%ebp),%eax
  800acf:	ff d0                	call   *%eax
  800ad1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ad4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad7:	83 c0 04             	add    $0x4,%eax
  800ada:	89 45 14             	mov    %eax,0x14(%ebp)
  800add:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae0:	83 e8 04             	sub    $0x4,%eax
  800ae3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ae5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800aef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800af6:	eb 1f                	jmp    800b17 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 e8             	pushl  -0x18(%ebp)
  800afe:	8d 45 14             	lea    0x14(%ebp),%eax
  800b01:	50                   	push   %eax
  800b02:	e8 e7 fb ff ff       	call   8006ee <getuint>
  800b07:	83 c4 10             	add    $0x10,%esp
  800b0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b17:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1e:	83 ec 04             	sub    $0x4,%esp
  800b21:	52                   	push   %edx
  800b22:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b25:	50                   	push   %eax
  800b26:	ff 75 f4             	pushl  -0xc(%ebp)
  800b29:	ff 75 f0             	pushl  -0x10(%ebp)
  800b2c:	ff 75 0c             	pushl  0xc(%ebp)
  800b2f:	ff 75 08             	pushl  0x8(%ebp)
  800b32:	e8 00 fb ff ff       	call   800637 <printnum>
  800b37:	83 c4 20             	add    $0x20,%esp
			break;
  800b3a:	eb 34                	jmp    800b70 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 0c             	pushl  0xc(%ebp)
  800b42:	53                   	push   %ebx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	ff d0                	call   *%eax
  800b48:	83 c4 10             	add    $0x10,%esp
			break;
  800b4b:	eb 23                	jmp    800b70 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b4d:	83 ec 08             	sub    $0x8,%esp
  800b50:	ff 75 0c             	pushl  0xc(%ebp)
  800b53:	6a 25                	push   $0x25
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	ff d0                	call   *%eax
  800b5a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800b5d:	ff 4d 10             	decl   0x10(%ebp)
  800b60:	eb 03                	jmp    800b65 <vprintfmt+0x3b1>
  800b62:	ff 4d 10             	decl   0x10(%ebp)
  800b65:	8b 45 10             	mov    0x10(%ebp),%eax
  800b68:	48                   	dec    %eax
  800b69:	8a 00                	mov    (%eax),%al
  800b6b:	3c 25                	cmp    $0x25,%al
  800b6d:	75 f3                	jne    800b62 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800b6f:	90                   	nop
		}
	}
  800b70:	e9 47 fc ff ff       	jmp    8007bc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800b75:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800b76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800b79:	5b                   	pop    %ebx
  800b7a:	5e                   	pop    %esi
  800b7b:	5d                   	pop    %ebp
  800b7c:	c3                   	ret    

00800b7d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800b7d:	55                   	push   %ebp
  800b7e:	89 e5                	mov    %esp,%ebp
  800b80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800b83:	8d 45 10             	lea    0x10(%ebp),%eax
  800b86:	83 c0 04             	add    $0x4,%eax
  800b89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800b8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800b8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800b92:	50                   	push   %eax
  800b93:	ff 75 0c             	pushl  0xc(%ebp)
  800b96:	ff 75 08             	pushl  0x8(%ebp)
  800b99:	e8 16 fc ff ff       	call   8007b4 <vprintfmt>
  800b9e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800ba1:	90                   	nop
  800ba2:	c9                   	leave  
  800ba3:	c3                   	ret    

00800ba4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800ba4:	55                   	push   %ebp
  800ba5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800baa:	8b 40 08             	mov    0x8(%eax),%eax
  800bad:	8d 50 01             	lea    0x1(%eax),%edx
  800bb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bb9:	8b 10                	mov    (%eax),%edx
  800bbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bbe:	8b 40 04             	mov    0x4(%eax),%eax
  800bc1:	39 c2                	cmp    %eax,%edx
  800bc3:	73 12                	jae    800bd7 <sprintputch+0x33>
		*b->buf++ = ch;
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	8b 00                	mov    (%eax),%eax
  800bca:	8d 48 01             	lea    0x1(%eax),%ecx
  800bcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bd0:	89 0a                	mov    %ecx,(%edx)
  800bd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800bd5:	88 10                	mov    %dl,(%eax)
}
  800bd7:	90                   	nop
  800bd8:	5d                   	pop    %ebp
  800bd9:	c3                   	ret    

00800bda <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800bda:	55                   	push   %ebp
  800bdb:	89 e5                	mov    %esp,%ebp
  800bdd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800be0:	8b 45 08             	mov    0x8(%ebp),%eax
  800be3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800be6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	01 d0                	add    %edx,%eax
  800bf1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bf4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800bfb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800bff:	74 06                	je     800c07 <vsnprintf+0x2d>
  800c01:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c05:	7f 07                	jg     800c0e <vsnprintf+0x34>
		return -E_INVAL;
  800c07:	b8 03 00 00 00       	mov    $0x3,%eax
  800c0c:	eb 20                	jmp    800c2e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c0e:	ff 75 14             	pushl  0x14(%ebp)
  800c11:	ff 75 10             	pushl  0x10(%ebp)
  800c14:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c17:	50                   	push   %eax
  800c18:	68 a4 0b 80 00       	push   $0x800ba4
  800c1d:	e8 92 fb ff ff       	call   8007b4 <vprintfmt>
  800c22:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c25:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c28:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c2e:	c9                   	leave  
  800c2f:	c3                   	ret    

00800c30 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c30:	55                   	push   %ebp
  800c31:	89 e5                	mov    %esp,%ebp
  800c33:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c36:	8d 45 10             	lea    0x10(%ebp),%eax
  800c39:	83 c0 04             	add    $0x4,%eax
  800c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c42:	ff 75 f4             	pushl  -0xc(%ebp)
  800c45:	50                   	push   %eax
  800c46:	ff 75 0c             	pushl  0xc(%ebp)
  800c49:	ff 75 08             	pushl  0x8(%ebp)
  800c4c:	e8 89 ff ff ff       	call   800bda <vsnprintf>
  800c51:	83 c4 10             	add    $0x10,%esp
  800c54:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c57:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c5a:	c9                   	leave  
  800c5b:	c3                   	ret    

00800c5c <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800c5c:	55                   	push   %ebp
  800c5d:	89 e5                	mov    %esp,%ebp
  800c5f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800c62:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c69:	eb 06                	jmp    800c71 <strlen+0x15>
		n++;
  800c6b:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800c6e:	ff 45 08             	incl   0x8(%ebp)
  800c71:	8b 45 08             	mov    0x8(%ebp),%eax
  800c74:	8a 00                	mov    (%eax),%al
  800c76:	84 c0                	test   %al,%al
  800c78:	75 f1                	jne    800c6b <strlen+0xf>
		n++;
	return n;
  800c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c7d:	c9                   	leave  
  800c7e:	c3                   	ret    

00800c7f <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800c7f:	55                   	push   %ebp
  800c80:	89 e5                	mov    %esp,%ebp
  800c82:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c85:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800c8c:	eb 09                	jmp    800c97 <strnlen+0x18>
		n++;
  800c8e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800c91:	ff 45 08             	incl   0x8(%ebp)
  800c94:	ff 4d 0c             	decl   0xc(%ebp)
  800c97:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c9b:	74 09                	je     800ca6 <strnlen+0x27>
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8a 00                	mov    (%eax),%al
  800ca2:	84 c0                	test   %al,%al
  800ca4:	75 e8                	jne    800c8e <strnlen+0xf>
		n++;
	return n;
  800ca6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ca9:	c9                   	leave  
  800caa:	c3                   	ret    

00800cab <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cab:	55                   	push   %ebp
  800cac:	89 e5                	mov    %esp,%ebp
  800cae:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cb7:	90                   	nop
  800cb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbb:	8d 50 01             	lea    0x1(%eax),%edx
  800cbe:	89 55 08             	mov    %edx,0x8(%ebp)
  800cc1:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cc4:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cc7:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800cca:	8a 12                	mov    (%edx),%dl
  800ccc:	88 10                	mov    %dl,(%eax)
  800cce:	8a 00                	mov    (%eax),%al
  800cd0:	84 c0                	test   %al,%al
  800cd2:	75 e4                	jne    800cb8 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800cd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cd7:	c9                   	leave  
  800cd8:	c3                   	ret    

00800cd9 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800cd9:	55                   	push   %ebp
  800cda:	89 e5                	mov    %esp,%ebp
  800cdc:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800cdf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ce5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cec:	eb 1f                	jmp    800d0d <strncpy+0x34>
		*dst++ = *src;
  800cee:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf1:	8d 50 01             	lea    0x1(%eax),%edx
  800cf4:	89 55 08             	mov    %edx,0x8(%ebp)
  800cf7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cfa:	8a 12                	mov    (%edx),%dl
  800cfc:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	84 c0                	test   %al,%al
  800d05:	74 03                	je     800d0a <strncpy+0x31>
			src++;
  800d07:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d0a:	ff 45 fc             	incl   -0x4(%ebp)
  800d0d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d10:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d13:	72 d9                	jb     800cee <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d15:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d18:	c9                   	leave  
  800d19:	c3                   	ret    

00800d1a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d1a:	55                   	push   %ebp
  800d1b:	89 e5                	mov    %esp,%ebp
  800d1d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d26:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2a:	74 30                	je     800d5c <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d2c:	eb 16                	jmp    800d44 <strlcpy+0x2a>
			*dst++ = *src++;
  800d2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d31:	8d 50 01             	lea    0x1(%eax),%edx
  800d34:	89 55 08             	mov    %edx,0x8(%ebp)
  800d37:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d3d:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d40:	8a 12                	mov    (%edx),%dl
  800d42:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d44:	ff 4d 10             	decl   0x10(%ebp)
  800d47:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4b:	74 09                	je     800d56 <strlcpy+0x3c>
  800d4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	84 c0                	test   %al,%al
  800d54:	75 d8                	jne    800d2e <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d56:	8b 45 08             	mov    0x8(%ebp),%eax
  800d59:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800d5c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d5f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d62:	29 c2                	sub    %eax,%edx
  800d64:	89 d0                	mov    %edx,%eax
}
  800d66:	c9                   	leave  
  800d67:	c3                   	ret    

00800d68 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800d68:	55                   	push   %ebp
  800d69:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800d6b:	eb 06                	jmp    800d73 <strcmp+0xb>
		p++, q++;
  800d6d:	ff 45 08             	incl   0x8(%ebp)
  800d70:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8a 00                	mov    (%eax),%al
  800d78:	84 c0                	test   %al,%al
  800d7a:	74 0e                	je     800d8a <strcmp+0x22>
  800d7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7f:	8a 10                	mov    (%eax),%dl
  800d81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d84:	8a 00                	mov    (%eax),%al
  800d86:	38 c2                	cmp    %al,%dl
  800d88:	74 e3                	je     800d6d <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	8a 00                	mov    (%eax),%al
  800d8f:	0f b6 d0             	movzbl %al,%edx
  800d92:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d95:	8a 00                	mov    (%eax),%al
  800d97:	0f b6 c0             	movzbl %al,%eax
  800d9a:	29 c2                	sub    %eax,%edx
  800d9c:	89 d0                	mov    %edx,%eax
}
  800d9e:	5d                   	pop    %ebp
  800d9f:	c3                   	ret    

00800da0 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800da0:	55                   	push   %ebp
  800da1:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800da3:	eb 09                	jmp    800dae <strncmp+0xe>
		n--, p++, q++;
  800da5:	ff 4d 10             	decl   0x10(%ebp)
  800da8:	ff 45 08             	incl   0x8(%ebp)
  800dab:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800dae:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800db2:	74 17                	je     800dcb <strncmp+0x2b>
  800db4:	8b 45 08             	mov    0x8(%ebp),%eax
  800db7:	8a 00                	mov    (%eax),%al
  800db9:	84 c0                	test   %al,%al
  800dbb:	74 0e                	je     800dcb <strncmp+0x2b>
  800dbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc0:	8a 10                	mov    (%eax),%dl
  800dc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc5:	8a 00                	mov    (%eax),%al
  800dc7:	38 c2                	cmp    %al,%dl
  800dc9:	74 da                	je     800da5 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800dcb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dcf:	75 07                	jne    800dd8 <strncmp+0x38>
		return 0;
  800dd1:	b8 00 00 00 00       	mov    $0x0,%eax
  800dd6:	eb 14                	jmp    800dec <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	8a 00                	mov    (%eax),%al
  800ddd:	0f b6 d0             	movzbl %al,%edx
  800de0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de3:	8a 00                	mov    (%eax),%al
  800de5:	0f b6 c0             	movzbl %al,%eax
  800de8:	29 c2                	sub    %eax,%edx
  800dea:	89 d0                	mov    %edx,%eax
}
  800dec:	5d                   	pop    %ebp
  800ded:	c3                   	ret    

00800dee <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800dee:	55                   	push   %ebp
  800def:	89 e5                	mov    %esp,%ebp
  800df1:	83 ec 04             	sub    $0x4,%esp
  800df4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800df7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800dfa:	eb 12                	jmp    800e0e <strchr+0x20>
		if (*s == c)
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8a 00                	mov    (%eax),%al
  800e01:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e04:	75 05                	jne    800e0b <strchr+0x1d>
			return (char *) s;
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	eb 11                	jmp    800e1c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e0b:	ff 45 08             	incl   0x8(%ebp)
  800e0e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e11:	8a 00                	mov    (%eax),%al
  800e13:	84 c0                	test   %al,%al
  800e15:	75 e5                	jne    800dfc <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e17:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 04             	sub    $0x4,%esp
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e2a:	eb 0d                	jmp    800e39 <strfind+0x1b>
		if (*s == c)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	8a 00                	mov    (%eax),%al
  800e31:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e34:	74 0e                	je     800e44 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e36:	ff 45 08             	incl   0x8(%ebp)
  800e39:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3c:	8a 00                	mov    (%eax),%al
  800e3e:	84 c0                	test   %al,%al
  800e40:	75 ea                	jne    800e2c <strfind+0xe>
  800e42:	eb 01                	jmp    800e45 <strfind+0x27>
		if (*s == c)
			break;
  800e44:	90                   	nop
	return (char *) s;
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e48:	c9                   	leave  
  800e49:	c3                   	ret    

00800e4a <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e4a:	55                   	push   %ebp
  800e4b:	89 e5                	mov    %esp,%ebp
  800e4d:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e50:	8b 45 08             	mov    0x8(%ebp),%eax
  800e53:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e56:	8b 45 10             	mov    0x10(%ebp),%eax
  800e59:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800e5c:	eb 0e                	jmp    800e6c <memset+0x22>
		*p++ = c;
  800e5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e61:	8d 50 01             	lea    0x1(%eax),%edx
  800e64:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800e67:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e6a:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800e6c:	ff 4d f8             	decl   -0x8(%ebp)
  800e6f:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800e73:	79 e9                	jns    800e5e <memset+0x14>
		*p++ = c;

	return v;
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e78:	c9                   	leave  
  800e79:	c3                   	ret    

00800e7a <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800e7a:	55                   	push   %ebp
  800e7b:	89 e5                	mov    %esp,%ebp
  800e7d:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800e80:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e83:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800e86:	8b 45 08             	mov    0x8(%ebp),%eax
  800e89:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800e8c:	eb 16                	jmp    800ea4 <memcpy+0x2a>
		*d++ = *s++;
  800e8e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e91:	8d 50 01             	lea    0x1(%eax),%edx
  800e94:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800e97:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800e9a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e9d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ea0:	8a 12                	mov    (%edx),%dl
  800ea2:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ea4:	8b 45 10             	mov    0x10(%ebp),%eax
  800ea7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eaa:	89 55 10             	mov    %edx,0x10(%ebp)
  800ead:	85 c0                	test   %eax,%eax
  800eaf:	75 dd                	jne    800e8e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800eb4:	c9                   	leave  
  800eb5:	c3                   	ret    

00800eb6 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800eb6:	55                   	push   %ebp
  800eb7:	89 e5                	mov    %esp,%ebp
  800eb9:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ebf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800ec8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ecb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800ece:	73 50                	jae    800f20 <memmove+0x6a>
  800ed0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ed3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed6:	01 d0                	add    %edx,%eax
  800ed8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800edb:	76 43                	jbe    800f20 <memmove+0x6a>
		s += n;
  800edd:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee0:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800ee3:	8b 45 10             	mov    0x10(%ebp),%eax
  800ee6:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800ee9:	eb 10                	jmp    800efb <memmove+0x45>
			*--d = *--s;
  800eeb:	ff 4d f8             	decl   -0x8(%ebp)
  800eee:	ff 4d fc             	decl   -0x4(%ebp)
  800ef1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ef4:	8a 10                	mov    (%eax),%dl
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef9:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800efb:	8b 45 10             	mov    0x10(%ebp),%eax
  800efe:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f01:	89 55 10             	mov    %edx,0x10(%ebp)
  800f04:	85 c0                	test   %eax,%eax
  800f06:	75 e3                	jne    800eeb <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f08:	eb 23                	jmp    800f2d <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f0a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f0d:	8d 50 01             	lea    0x1(%eax),%edx
  800f10:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f13:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f16:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f19:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f1c:	8a 12                	mov    (%edx),%dl
  800f1e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f20:	8b 45 10             	mov    0x10(%ebp),%eax
  800f23:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f26:	89 55 10             	mov    %edx,0x10(%ebp)
  800f29:	85 c0                	test   %eax,%eax
  800f2b:	75 dd                	jne    800f0a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f2d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f30:	c9                   	leave  
  800f31:	c3                   	ret    

00800f32 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f32:	55                   	push   %ebp
  800f33:	89 e5                	mov    %esp,%ebp
  800f35:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f3e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f41:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f44:	eb 2a                	jmp    800f70 <memcmp+0x3e>
		if (*s1 != *s2)
  800f46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f49:	8a 10                	mov    (%eax),%dl
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	8a 00                	mov    (%eax),%al
  800f50:	38 c2                	cmp    %al,%dl
  800f52:	74 16                	je     800f6a <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f54:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	0f b6 d0             	movzbl %al,%edx
  800f5c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f5f:	8a 00                	mov    (%eax),%al
  800f61:	0f b6 c0             	movzbl %al,%eax
  800f64:	29 c2                	sub    %eax,%edx
  800f66:	89 d0                	mov    %edx,%eax
  800f68:	eb 18                	jmp    800f82 <memcmp+0x50>
		s1++, s2++;
  800f6a:	ff 45 fc             	incl   -0x4(%ebp)
  800f6d:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800f70:	8b 45 10             	mov    0x10(%ebp),%eax
  800f73:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f76:	89 55 10             	mov    %edx,0x10(%ebp)
  800f79:	85 c0                	test   %eax,%eax
  800f7b:	75 c9                	jne    800f46 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800f7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800f82:	c9                   	leave  
  800f83:	c3                   	ret    

00800f84 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800f84:	55                   	push   %ebp
  800f85:	89 e5                	mov    %esp,%ebp
  800f87:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800f8a:	8b 55 08             	mov    0x8(%ebp),%edx
  800f8d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f90:	01 d0                	add    %edx,%eax
  800f92:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800f95:	eb 15                	jmp    800fac <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800f97:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9a:	8a 00                	mov    (%eax),%al
  800f9c:	0f b6 d0             	movzbl %al,%edx
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	0f b6 c0             	movzbl %al,%eax
  800fa5:	39 c2                	cmp    %eax,%edx
  800fa7:	74 0d                	je     800fb6 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fa9:	ff 45 08             	incl   0x8(%ebp)
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800fb2:	72 e3                	jb     800f97 <memfind+0x13>
  800fb4:	eb 01                	jmp    800fb7 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800fb6:	90                   	nop
	return (void *) s;
  800fb7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fba:	c9                   	leave  
  800fbb:	c3                   	ret    

00800fbc <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800fbc:	55                   	push   %ebp
  800fbd:	89 e5                	mov    %esp,%ebp
  800fbf:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800fc2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800fc9:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd0:	eb 03                	jmp    800fd5 <strtol+0x19>
		s++;
  800fd2:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800fd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd8:	8a 00                	mov    (%eax),%al
  800fda:	3c 20                	cmp    $0x20,%al
  800fdc:	74 f4                	je     800fd2 <strtol+0x16>
  800fde:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe1:	8a 00                	mov    (%eax),%al
  800fe3:	3c 09                	cmp    $0x9,%al
  800fe5:	74 eb                	je     800fd2 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800fe7:	8b 45 08             	mov    0x8(%ebp),%eax
  800fea:	8a 00                	mov    (%eax),%al
  800fec:	3c 2b                	cmp    $0x2b,%al
  800fee:	75 05                	jne    800ff5 <strtol+0x39>
		s++;
  800ff0:	ff 45 08             	incl   0x8(%ebp)
  800ff3:	eb 13                	jmp    801008 <strtol+0x4c>
	else if (*s == '-')
  800ff5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff8:	8a 00                	mov    (%eax),%al
  800ffa:	3c 2d                	cmp    $0x2d,%al
  800ffc:	75 0a                	jne    801008 <strtol+0x4c>
		s++, neg = 1;
  800ffe:	ff 45 08             	incl   0x8(%ebp)
  801001:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801008:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80100c:	74 06                	je     801014 <strtol+0x58>
  80100e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801012:	75 20                	jne    801034 <strtol+0x78>
  801014:	8b 45 08             	mov    0x8(%ebp),%eax
  801017:	8a 00                	mov    (%eax),%al
  801019:	3c 30                	cmp    $0x30,%al
  80101b:	75 17                	jne    801034 <strtol+0x78>
  80101d:	8b 45 08             	mov    0x8(%ebp),%eax
  801020:	40                   	inc    %eax
  801021:	8a 00                	mov    (%eax),%al
  801023:	3c 78                	cmp    $0x78,%al
  801025:	75 0d                	jne    801034 <strtol+0x78>
		s += 2, base = 16;
  801027:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80102b:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801032:	eb 28                	jmp    80105c <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801034:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801038:	75 15                	jne    80104f <strtol+0x93>
  80103a:	8b 45 08             	mov    0x8(%ebp),%eax
  80103d:	8a 00                	mov    (%eax),%al
  80103f:	3c 30                	cmp    $0x30,%al
  801041:	75 0c                	jne    80104f <strtol+0x93>
		s++, base = 8;
  801043:	ff 45 08             	incl   0x8(%ebp)
  801046:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80104d:	eb 0d                	jmp    80105c <strtol+0xa0>
	else if (base == 0)
  80104f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801053:	75 07                	jne    80105c <strtol+0xa0>
		base = 10;
  801055:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80105c:	8b 45 08             	mov    0x8(%ebp),%eax
  80105f:	8a 00                	mov    (%eax),%al
  801061:	3c 2f                	cmp    $0x2f,%al
  801063:	7e 19                	jle    80107e <strtol+0xc2>
  801065:	8b 45 08             	mov    0x8(%ebp),%eax
  801068:	8a 00                	mov    (%eax),%al
  80106a:	3c 39                	cmp    $0x39,%al
  80106c:	7f 10                	jg     80107e <strtol+0xc2>
			dig = *s - '0';
  80106e:	8b 45 08             	mov    0x8(%ebp),%eax
  801071:	8a 00                	mov    (%eax),%al
  801073:	0f be c0             	movsbl %al,%eax
  801076:	83 e8 30             	sub    $0x30,%eax
  801079:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80107c:	eb 42                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 60                	cmp    $0x60,%al
  801085:	7e 19                	jle    8010a0 <strtol+0xe4>
  801087:	8b 45 08             	mov    0x8(%ebp),%eax
  80108a:	8a 00                	mov    (%eax),%al
  80108c:	3c 7a                	cmp    $0x7a,%al
  80108e:	7f 10                	jg     8010a0 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801090:	8b 45 08             	mov    0x8(%ebp),%eax
  801093:	8a 00                	mov    (%eax),%al
  801095:	0f be c0             	movsbl %al,%eax
  801098:	83 e8 57             	sub    $0x57,%eax
  80109b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80109e:	eb 20                	jmp    8010c0 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 40                	cmp    $0x40,%al
  8010a7:	7e 39                	jle    8010e2 <strtol+0x126>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 5a                	cmp    $0x5a,%al
  8010b0:	7f 30                	jg     8010e2 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f be c0             	movsbl %al,%eax
  8010ba:	83 e8 37             	sub    $0x37,%eax
  8010bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8010c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010c3:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010c6:	7d 19                	jge    8010e1 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8010c8:	ff 45 08             	incl   0x8(%ebp)
  8010cb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ce:	0f af 45 10          	imul   0x10(%ebp),%eax
  8010d2:	89 c2                	mov    %eax,%edx
  8010d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010d7:	01 d0                	add    %edx,%eax
  8010d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8010dc:	e9 7b ff ff ff       	jmp    80105c <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8010e1:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8010e2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8010e6:	74 08                	je     8010f0 <strtol+0x134>
		*endptr = (char *) s;
  8010e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010eb:	8b 55 08             	mov    0x8(%ebp),%edx
  8010ee:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8010f0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8010f4:	74 07                	je     8010fd <strtol+0x141>
  8010f6:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f9:	f7 d8                	neg    %eax
  8010fb:	eb 03                	jmp    801100 <strtol+0x144>
  8010fd:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801100:	c9                   	leave  
  801101:	c3                   	ret    

00801102 <ltostr>:

void
ltostr(long value, char *str)
{
  801102:	55                   	push   %ebp
  801103:	89 e5                	mov    %esp,%ebp
  801105:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801108:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80110f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801116:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80111a:	79 13                	jns    80112f <ltostr+0x2d>
	{
		neg = 1;
  80111c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801123:	8b 45 0c             	mov    0xc(%ebp),%eax
  801126:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801129:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80112c:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80112f:	8b 45 08             	mov    0x8(%ebp),%eax
  801132:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801137:	99                   	cltd   
  801138:	f7 f9                	idiv   %ecx
  80113a:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80113d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801140:	8d 50 01             	lea    0x1(%eax),%edx
  801143:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801146:	89 c2                	mov    %eax,%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801150:	83 c2 30             	add    $0x30,%edx
  801153:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801155:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801158:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80115d:	f7 e9                	imul   %ecx
  80115f:	c1 fa 02             	sar    $0x2,%edx
  801162:	89 c8                	mov    %ecx,%eax
  801164:	c1 f8 1f             	sar    $0x1f,%eax
  801167:	29 c2                	sub    %eax,%edx
  801169:	89 d0                	mov    %edx,%eax
  80116b:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80116e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801171:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801176:	f7 e9                	imul   %ecx
  801178:	c1 fa 02             	sar    $0x2,%edx
  80117b:	89 c8                	mov    %ecx,%eax
  80117d:	c1 f8 1f             	sar    $0x1f,%eax
  801180:	29 c2                	sub    %eax,%edx
  801182:	89 d0                	mov    %edx,%eax
  801184:	c1 e0 02             	shl    $0x2,%eax
  801187:	01 d0                	add    %edx,%eax
  801189:	01 c0                	add    %eax,%eax
  80118b:	29 c1                	sub    %eax,%ecx
  80118d:	89 ca                	mov    %ecx,%edx
  80118f:	85 d2                	test   %edx,%edx
  801191:	75 9c                	jne    80112f <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801193:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80119a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80119d:	48                   	dec    %eax
  80119e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011a1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011a5:	74 3d                	je     8011e4 <ltostr+0xe2>
		start = 1 ;
  8011a7:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011ae:	eb 34                	jmp    8011e4 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011b0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011b6:	01 d0                	add    %edx,%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8011bd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c3:	01 c2                	add    %eax,%edx
  8011c5:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8011c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011cb:	01 c8                	add    %ecx,%eax
  8011cd:	8a 00                	mov    (%eax),%al
  8011cf:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8011d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8011d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d7:	01 c2                	add    %eax,%edx
  8011d9:	8a 45 eb             	mov    -0x15(%ebp),%al
  8011dc:	88 02                	mov    %al,(%edx)
		start++ ;
  8011de:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8011e1:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8011e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011e7:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8011ea:	7c c4                	jl     8011b0 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8011ec:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8011ef:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f2:	01 d0                	add    %edx,%eax
  8011f4:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8011f7:	90                   	nop
  8011f8:	c9                   	leave  
  8011f9:	c3                   	ret    

008011fa <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8011fa:	55                   	push   %ebp
  8011fb:	89 e5                	mov    %esp,%ebp
  8011fd:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801200:	ff 75 08             	pushl  0x8(%ebp)
  801203:	e8 54 fa ff ff       	call   800c5c <strlen>
  801208:	83 c4 04             	add    $0x4,%esp
  80120b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80120e:	ff 75 0c             	pushl  0xc(%ebp)
  801211:	e8 46 fa ff ff       	call   800c5c <strlen>
  801216:	83 c4 04             	add    $0x4,%esp
  801219:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80121c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801223:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80122a:	eb 17                	jmp    801243 <strcconcat+0x49>
		final[s] = str1[s] ;
  80122c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80122f:	8b 45 10             	mov    0x10(%ebp),%eax
  801232:	01 c2                	add    %eax,%edx
  801234:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801237:	8b 45 08             	mov    0x8(%ebp),%eax
  80123a:	01 c8                	add    %ecx,%eax
  80123c:	8a 00                	mov    (%eax),%al
  80123e:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801240:	ff 45 fc             	incl   -0x4(%ebp)
  801243:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801246:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801249:	7c e1                	jl     80122c <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80124b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801252:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801259:	eb 1f                	jmp    80127a <strcconcat+0x80>
		final[s++] = str2[i] ;
  80125b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80125e:	8d 50 01             	lea    0x1(%eax),%edx
  801261:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801264:	89 c2                	mov    %eax,%edx
  801266:	8b 45 10             	mov    0x10(%ebp),%eax
  801269:	01 c2                	add    %eax,%edx
  80126b:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80126e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801271:	01 c8                	add    %ecx,%eax
  801273:	8a 00                	mov    (%eax),%al
  801275:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801277:	ff 45 f8             	incl   -0x8(%ebp)
  80127a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80127d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801280:	7c d9                	jl     80125b <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801282:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801285:	8b 45 10             	mov    0x10(%ebp),%eax
  801288:	01 d0                	add    %edx,%eax
  80128a:	c6 00 00             	movb   $0x0,(%eax)
}
  80128d:	90                   	nop
  80128e:	c9                   	leave  
  80128f:	c3                   	ret    

00801290 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801293:	8b 45 14             	mov    0x14(%ebp),%eax
  801296:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80129c:	8b 45 14             	mov    0x14(%ebp),%eax
  80129f:	8b 00                	mov    (%eax),%eax
  8012a1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012a8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ab:	01 d0                	add    %edx,%eax
  8012ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012b3:	eb 0c                	jmp    8012c1 <strsplit+0x31>
			*string++ = 0;
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	8d 50 01             	lea    0x1(%eax),%edx
  8012bb:	89 55 08             	mov    %edx,0x8(%ebp)
  8012be:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c4:	8a 00                	mov    (%eax),%al
  8012c6:	84 c0                	test   %al,%al
  8012c8:	74 18                	je     8012e2 <strsplit+0x52>
  8012ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8012cd:	8a 00                	mov    (%eax),%al
  8012cf:	0f be c0             	movsbl %al,%eax
  8012d2:	50                   	push   %eax
  8012d3:	ff 75 0c             	pushl  0xc(%ebp)
  8012d6:	e8 13 fb ff ff       	call   800dee <strchr>
  8012db:	83 c4 08             	add    $0x8,%esp
  8012de:	85 c0                	test   %eax,%eax
  8012e0:	75 d3                	jne    8012b5 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8012e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e5:	8a 00                	mov    (%eax),%al
  8012e7:	84 c0                	test   %al,%al
  8012e9:	74 5a                	je     801345 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8012eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ee:	8b 00                	mov    (%eax),%eax
  8012f0:	83 f8 0f             	cmp    $0xf,%eax
  8012f3:	75 07                	jne    8012fc <strsplit+0x6c>
		{
			return 0;
  8012f5:	b8 00 00 00 00       	mov    $0x0,%eax
  8012fa:	eb 66                	jmp    801362 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8012fc:	8b 45 14             	mov    0x14(%ebp),%eax
  8012ff:	8b 00                	mov    (%eax),%eax
  801301:	8d 48 01             	lea    0x1(%eax),%ecx
  801304:	8b 55 14             	mov    0x14(%ebp),%edx
  801307:	89 0a                	mov    %ecx,(%edx)
  801309:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801310:	8b 45 10             	mov    0x10(%ebp),%eax
  801313:	01 c2                	add    %eax,%edx
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131a:	eb 03                	jmp    80131f <strsplit+0x8f>
			string++;
  80131c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80131f:	8b 45 08             	mov    0x8(%ebp),%eax
  801322:	8a 00                	mov    (%eax),%al
  801324:	84 c0                	test   %al,%al
  801326:	74 8b                	je     8012b3 <strsplit+0x23>
  801328:	8b 45 08             	mov    0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	0f be c0             	movsbl %al,%eax
  801330:	50                   	push   %eax
  801331:	ff 75 0c             	pushl  0xc(%ebp)
  801334:	e8 b5 fa ff ff       	call   800dee <strchr>
  801339:	83 c4 08             	add    $0x8,%esp
  80133c:	85 c0                	test   %eax,%eax
  80133e:	74 dc                	je     80131c <strsplit+0x8c>
			string++;
	}
  801340:	e9 6e ff ff ff       	jmp    8012b3 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801345:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801346:	8b 45 14             	mov    0x14(%ebp),%eax
  801349:	8b 00                	mov    (%eax),%eax
  80134b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801352:	8b 45 10             	mov    0x10(%ebp),%eax
  801355:	01 d0                	add    %edx,%eax
  801357:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80135d:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801362:	c9                   	leave  
  801363:	c3                   	ret    

00801364 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801364:	55                   	push   %ebp
  801365:	89 e5                	mov    %esp,%ebp
  801367:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80136a:	a1 04 40 80 00       	mov    0x804004,%eax
  80136f:	85 c0                	test   %eax,%eax
  801371:	74 1f                	je     801392 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801373:	e8 1d 00 00 00       	call   801395 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801378:	83 ec 0c             	sub    $0xc,%esp
  80137b:	68 10 3a 80 00       	push   $0x803a10
  801380:	e8 55 f2 ff ff       	call   8005da <cprintf>
  801385:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801388:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80138f:	00 00 00 
	}
}
  801392:	90                   	nop
  801393:	c9                   	leave  
  801394:	c3                   	ret    

00801395 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801395:	55                   	push   %ebp
  801396:	89 e5                	mov    %esp,%ebp
  801398:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  80139b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013a2:	00 00 00 
  8013a5:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013ac:	00 00 00 
  8013af:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013b6:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8013b9:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  8013c0:	00 00 00 
  8013c3:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  8013ca:	00 00 00 
  8013cd:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  8013d4:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  8013d7:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  8013de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013e1:	c1 e8 0c             	shr    $0xc,%eax
  8013e4:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  8013e9:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8013f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013f3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8013f8:	2d 00 10 00 00       	sub    $0x1000,%eax
  8013fd:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  801402:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801409:	a1 20 41 80 00       	mov    0x804120,%eax
  80140e:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801412:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801415:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80141c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80141f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801422:	01 d0                	add    %edx,%eax
  801424:	48                   	dec    %eax
  801425:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801428:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80142b:	ba 00 00 00 00       	mov    $0x0,%edx
  801430:	f7 75 e4             	divl   -0x1c(%ebp)
  801433:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801436:	29 d0                	sub    %edx,%eax
  801438:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  80143b:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801442:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801445:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80144a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80144f:	83 ec 04             	sub    $0x4,%esp
  801452:	6a 07                	push   $0x7
  801454:	ff 75 e8             	pushl  -0x18(%ebp)
  801457:	50                   	push   %eax
  801458:	e8 3d 06 00 00       	call   801a9a <sys_allocate_chunk>
  80145d:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801460:	a1 20 41 80 00       	mov    0x804120,%eax
  801465:	83 ec 0c             	sub    $0xc,%esp
  801468:	50                   	push   %eax
  801469:	e8 b2 0c 00 00       	call   802120 <initialize_MemBlocksList>
  80146e:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801471:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801476:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801479:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80147d:	0f 84 f3 00 00 00    	je     801576 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801483:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801487:	75 14                	jne    80149d <initialize_dyn_block_system+0x108>
  801489:	83 ec 04             	sub    $0x4,%esp
  80148c:	68 35 3a 80 00       	push   $0x803a35
  801491:	6a 36                	push   $0x36
  801493:	68 53 3a 80 00       	push   $0x803a53
  801498:	e8 89 ee ff ff       	call   800326 <_panic>
  80149d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014a0:	8b 00                	mov    (%eax),%eax
  8014a2:	85 c0                	test   %eax,%eax
  8014a4:	74 10                	je     8014b6 <initialize_dyn_block_system+0x121>
  8014a6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014a9:	8b 00                	mov    (%eax),%eax
  8014ab:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014ae:	8b 52 04             	mov    0x4(%edx),%edx
  8014b1:	89 50 04             	mov    %edx,0x4(%eax)
  8014b4:	eb 0b                	jmp    8014c1 <initialize_dyn_block_system+0x12c>
  8014b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014b9:	8b 40 04             	mov    0x4(%eax),%eax
  8014bc:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8014c1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014c4:	8b 40 04             	mov    0x4(%eax),%eax
  8014c7:	85 c0                	test   %eax,%eax
  8014c9:	74 0f                	je     8014da <initialize_dyn_block_system+0x145>
  8014cb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014ce:	8b 40 04             	mov    0x4(%eax),%eax
  8014d1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014d4:	8b 12                	mov    (%edx),%edx
  8014d6:	89 10                	mov    %edx,(%eax)
  8014d8:	eb 0a                	jmp    8014e4 <initialize_dyn_block_system+0x14f>
  8014da:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014dd:	8b 00                	mov    (%eax),%eax
  8014df:	a3 48 41 80 00       	mov    %eax,0x804148
  8014e4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014e7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8014ed:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014f0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8014f7:	a1 54 41 80 00       	mov    0x804154,%eax
  8014fc:	48                   	dec    %eax
  8014fd:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801502:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801505:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  80150c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80150f:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801516:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80151a:	75 14                	jne    801530 <initialize_dyn_block_system+0x19b>
  80151c:	83 ec 04             	sub    $0x4,%esp
  80151f:	68 60 3a 80 00       	push   $0x803a60
  801524:	6a 3e                	push   $0x3e
  801526:	68 53 3a 80 00       	push   $0x803a53
  80152b:	e8 f6 ed ff ff       	call   800326 <_panic>
  801530:	8b 15 38 41 80 00    	mov    0x804138,%edx
  801536:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801539:	89 10                	mov    %edx,(%eax)
  80153b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80153e:	8b 00                	mov    (%eax),%eax
  801540:	85 c0                	test   %eax,%eax
  801542:	74 0d                	je     801551 <initialize_dyn_block_system+0x1bc>
  801544:	a1 38 41 80 00       	mov    0x804138,%eax
  801549:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80154c:	89 50 04             	mov    %edx,0x4(%eax)
  80154f:	eb 08                	jmp    801559 <initialize_dyn_block_system+0x1c4>
  801551:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801554:	a3 3c 41 80 00       	mov    %eax,0x80413c
  801559:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80155c:	a3 38 41 80 00       	mov    %eax,0x804138
  801561:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801564:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80156b:	a1 44 41 80 00       	mov    0x804144,%eax
  801570:	40                   	inc    %eax
  801571:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  801576:	90                   	nop
  801577:	c9                   	leave  
  801578:	c3                   	ret    

00801579 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801579:	55                   	push   %ebp
  80157a:	89 e5                	mov    %esp,%ebp
  80157c:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  80157f:	e8 e0 fd ff ff       	call   801364 <InitializeUHeap>
		if (size == 0) return NULL ;
  801584:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801588:	75 07                	jne    801591 <malloc+0x18>
  80158a:	b8 00 00 00 00       	mov    $0x0,%eax
  80158f:	eb 7f                	jmp    801610 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801591:	e8 d2 08 00 00       	call   801e68 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801596:	85 c0                	test   %eax,%eax
  801598:	74 71                	je     80160b <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  80159a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015a1:	8b 55 08             	mov    0x8(%ebp),%edx
  8015a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015a7:	01 d0                	add    %edx,%eax
  8015a9:	48                   	dec    %eax
  8015aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8015b5:	f7 75 f4             	divl   -0xc(%ebp)
  8015b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015bb:	29 d0                	sub    %edx,%eax
  8015bd:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  8015c0:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  8015c7:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8015ce:	76 07                	jbe    8015d7 <malloc+0x5e>
					return NULL ;
  8015d0:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d5:	eb 39                	jmp    801610 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  8015d7:	83 ec 0c             	sub    $0xc,%esp
  8015da:	ff 75 08             	pushl  0x8(%ebp)
  8015dd:	e8 e6 0d 00 00       	call   8023c8 <alloc_block_FF>
  8015e2:	83 c4 10             	add    $0x10,%esp
  8015e5:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  8015e8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8015ec:	74 16                	je     801604 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  8015ee:	83 ec 0c             	sub    $0xc,%esp
  8015f1:	ff 75 ec             	pushl  -0x14(%ebp)
  8015f4:	e8 37 0c 00 00       	call   802230 <insert_sorted_allocList>
  8015f9:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  8015fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ff:	8b 40 08             	mov    0x8(%eax),%eax
  801602:	eb 0c                	jmp    801610 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801604:	b8 00 00 00 00       	mov    $0x0,%eax
  801609:	eb 05                	jmp    801610 <malloc+0x97>
				}
		}
	return 0;
  80160b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
  801615:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801618:	8b 45 08             	mov    0x8(%ebp),%eax
  80161b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  80161e:	83 ec 08             	sub    $0x8,%esp
  801621:	ff 75 f4             	pushl  -0xc(%ebp)
  801624:	68 40 40 80 00       	push   $0x804040
  801629:	e8 cf 0b 00 00       	call   8021fd <find_block>
  80162e:	83 c4 10             	add    $0x10,%esp
  801631:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801634:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801637:	8b 40 0c             	mov    0xc(%eax),%eax
  80163a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  80163d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801640:	8b 40 08             	mov    0x8(%eax),%eax
  801643:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801646:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80164a:	0f 84 a1 00 00 00    	je     8016f1 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801650:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801654:	75 17                	jne    80166d <free+0x5b>
  801656:	83 ec 04             	sub    $0x4,%esp
  801659:	68 35 3a 80 00       	push   $0x803a35
  80165e:	68 80 00 00 00       	push   $0x80
  801663:	68 53 3a 80 00       	push   $0x803a53
  801668:	e8 b9 ec ff ff       	call   800326 <_panic>
  80166d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801670:	8b 00                	mov    (%eax),%eax
  801672:	85 c0                	test   %eax,%eax
  801674:	74 10                	je     801686 <free+0x74>
  801676:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801679:	8b 00                	mov    (%eax),%eax
  80167b:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80167e:	8b 52 04             	mov    0x4(%edx),%edx
  801681:	89 50 04             	mov    %edx,0x4(%eax)
  801684:	eb 0b                	jmp    801691 <free+0x7f>
  801686:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801689:	8b 40 04             	mov    0x4(%eax),%eax
  80168c:	a3 44 40 80 00       	mov    %eax,0x804044
  801691:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801694:	8b 40 04             	mov    0x4(%eax),%eax
  801697:	85 c0                	test   %eax,%eax
  801699:	74 0f                	je     8016aa <free+0x98>
  80169b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80169e:	8b 40 04             	mov    0x4(%eax),%eax
  8016a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016a4:	8b 12                	mov    (%edx),%edx
  8016a6:	89 10                	mov    %edx,(%eax)
  8016a8:	eb 0a                	jmp    8016b4 <free+0xa2>
  8016aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016ad:	8b 00                	mov    (%eax),%eax
  8016af:	a3 40 40 80 00       	mov    %eax,0x804040
  8016b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8016bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016c0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8016c7:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8016cc:	48                   	dec    %eax
  8016cd:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  8016d2:	83 ec 0c             	sub    $0xc,%esp
  8016d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8016d8:	e8 29 12 00 00       	call   802906 <insert_sorted_with_merge_freeList>
  8016dd:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  8016e0:	83 ec 08             	sub    $0x8,%esp
  8016e3:	ff 75 ec             	pushl  -0x14(%ebp)
  8016e6:	ff 75 e8             	pushl  -0x18(%ebp)
  8016e9:	e8 74 03 00 00       	call   801a62 <sys_free_user_mem>
  8016ee:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  8016f1:	90                   	nop
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	83 ec 38             	sub    $0x38,%esp
  8016fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8016fd:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801700:	e8 5f fc ff ff       	call   801364 <InitializeUHeap>
	if (size == 0) return NULL ;
  801705:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801709:	75 0a                	jne    801715 <smalloc+0x21>
  80170b:	b8 00 00 00 00       	mov    $0x0,%eax
  801710:	e9 b2 00 00 00       	jmp    8017c7 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801715:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80171c:	76 0a                	jbe    801728 <smalloc+0x34>
		return NULL;
  80171e:	b8 00 00 00 00       	mov    $0x0,%eax
  801723:	e9 9f 00 00 00       	jmp    8017c7 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801728:	e8 3b 07 00 00       	call   801e68 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80172d:	85 c0                	test   %eax,%eax
  80172f:	0f 84 8d 00 00 00    	je     8017c2 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801735:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  80173c:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801743:	8b 55 0c             	mov    0xc(%ebp),%edx
  801746:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801749:	01 d0                	add    %edx,%eax
  80174b:	48                   	dec    %eax
  80174c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80174f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801752:	ba 00 00 00 00       	mov    $0x0,%edx
  801757:	f7 75 f0             	divl   -0x10(%ebp)
  80175a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80175d:	29 d0                	sub    %edx,%eax
  80175f:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801762:	83 ec 0c             	sub    $0xc,%esp
  801765:	ff 75 e8             	pushl  -0x18(%ebp)
  801768:	e8 5b 0c 00 00       	call   8023c8 <alloc_block_FF>
  80176d:	83 c4 10             	add    $0x10,%esp
  801770:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801773:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801777:	75 07                	jne    801780 <smalloc+0x8c>
			return NULL;
  801779:	b8 00 00 00 00       	mov    $0x0,%eax
  80177e:	eb 47                	jmp    8017c7 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801780:	83 ec 0c             	sub    $0xc,%esp
  801783:	ff 75 f4             	pushl  -0xc(%ebp)
  801786:	e8 a5 0a 00 00       	call   802230 <insert_sorted_allocList>
  80178b:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  80178e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801791:	8b 40 08             	mov    0x8(%eax),%eax
  801794:	89 c2                	mov    %eax,%edx
  801796:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80179a:	52                   	push   %edx
  80179b:	50                   	push   %eax
  80179c:	ff 75 0c             	pushl  0xc(%ebp)
  80179f:	ff 75 08             	pushl  0x8(%ebp)
  8017a2:	e8 46 04 00 00       	call   801bed <sys_createSharedObject>
  8017a7:	83 c4 10             	add    $0x10,%esp
  8017aa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  8017ad:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017b1:	78 08                	js     8017bb <smalloc+0xc7>
		return (void *)b->sva;
  8017b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017b6:	8b 40 08             	mov    0x8(%eax),%eax
  8017b9:	eb 0c                	jmp    8017c7 <smalloc+0xd3>
		}else{
		return NULL;
  8017bb:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c0:	eb 05                	jmp    8017c7 <smalloc+0xd3>
			}

	}return NULL;
  8017c2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8017c7:	c9                   	leave  
  8017c8:	c3                   	ret    

008017c9 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  8017c9:	55                   	push   %ebp
  8017ca:	89 e5                	mov    %esp,%ebp
  8017cc:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8017cf:	e8 90 fb ff ff       	call   801364 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  8017d4:	e8 8f 06 00 00       	call   801e68 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8017d9:	85 c0                	test   %eax,%eax
  8017db:	0f 84 ad 00 00 00    	je     80188e <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  8017e1:	83 ec 08             	sub    $0x8,%esp
  8017e4:	ff 75 0c             	pushl  0xc(%ebp)
  8017e7:	ff 75 08             	pushl  0x8(%ebp)
  8017ea:	e8 28 04 00 00       	call   801c17 <sys_getSizeOfSharedObject>
  8017ef:	83 c4 10             	add    $0x10,%esp
  8017f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  8017f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017f9:	79 0a                	jns    801805 <sget+0x3c>
    {
    	return NULL;
  8017fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801800:	e9 8e 00 00 00       	jmp    801893 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801805:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  80180c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801813:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801816:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801819:	01 d0                	add    %edx,%eax
  80181b:	48                   	dec    %eax
  80181c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80181f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801822:	ba 00 00 00 00       	mov    $0x0,%edx
  801827:	f7 75 ec             	divl   -0x14(%ebp)
  80182a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80182d:	29 d0                	sub    %edx,%eax
  80182f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801832:	83 ec 0c             	sub    $0xc,%esp
  801835:	ff 75 e4             	pushl  -0x1c(%ebp)
  801838:	e8 8b 0b 00 00       	call   8023c8 <alloc_block_FF>
  80183d:	83 c4 10             	add    $0x10,%esp
  801840:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801843:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801847:	75 07                	jne    801850 <sget+0x87>
				return NULL;
  801849:	b8 00 00 00 00       	mov    $0x0,%eax
  80184e:	eb 43                	jmp    801893 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801850:	83 ec 0c             	sub    $0xc,%esp
  801853:	ff 75 f0             	pushl  -0x10(%ebp)
  801856:	e8 d5 09 00 00       	call   802230 <insert_sorted_allocList>
  80185b:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  80185e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801861:	8b 40 08             	mov    0x8(%eax),%eax
  801864:	83 ec 04             	sub    $0x4,%esp
  801867:	50                   	push   %eax
  801868:	ff 75 0c             	pushl  0xc(%ebp)
  80186b:	ff 75 08             	pushl  0x8(%ebp)
  80186e:	e8 c1 03 00 00       	call   801c34 <sys_getSharedObject>
  801873:	83 c4 10             	add    $0x10,%esp
  801876:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801879:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80187d:	78 08                	js     801887 <sget+0xbe>
			return (void *)b->sva;
  80187f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801882:	8b 40 08             	mov    0x8(%eax),%eax
  801885:	eb 0c                	jmp    801893 <sget+0xca>
			}else{
			return NULL;
  801887:	b8 00 00 00 00       	mov    $0x0,%eax
  80188c:	eb 05                	jmp    801893 <sget+0xca>
			}
    }}return NULL;
  80188e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801893:	c9                   	leave  
  801894:	c3                   	ret    

00801895 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801895:	55                   	push   %ebp
  801896:	89 e5                	mov    %esp,%ebp
  801898:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80189b:	e8 c4 fa ff ff       	call   801364 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018a0:	83 ec 04             	sub    $0x4,%esp
  8018a3:	68 84 3a 80 00       	push   $0x803a84
  8018a8:	68 03 01 00 00       	push   $0x103
  8018ad:	68 53 3a 80 00       	push   $0x803a53
  8018b2:	e8 6f ea ff ff       	call   800326 <_panic>

008018b7 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018b7:	55                   	push   %ebp
  8018b8:	89 e5                	mov    %esp,%ebp
  8018ba:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  8018bd:	83 ec 04             	sub    $0x4,%esp
  8018c0:	68 ac 3a 80 00       	push   $0x803aac
  8018c5:	68 17 01 00 00       	push   $0x117
  8018ca:	68 53 3a 80 00       	push   $0x803a53
  8018cf:	e8 52 ea ff ff       	call   800326 <_panic>

008018d4 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  8018d4:	55                   	push   %ebp
  8018d5:	89 e5                	mov    %esp,%ebp
  8018d7:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018da:	83 ec 04             	sub    $0x4,%esp
  8018dd:	68 d0 3a 80 00       	push   $0x803ad0
  8018e2:	68 22 01 00 00       	push   $0x122
  8018e7:	68 53 3a 80 00       	push   $0x803a53
  8018ec:	e8 35 ea ff ff       	call   800326 <_panic>

008018f1 <shrink>:

}
void shrink(uint32 newSize)
{
  8018f1:	55                   	push   %ebp
  8018f2:	89 e5                	mov    %esp,%ebp
  8018f4:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8018f7:	83 ec 04             	sub    $0x4,%esp
  8018fa:	68 d0 3a 80 00       	push   $0x803ad0
  8018ff:	68 27 01 00 00       	push   $0x127
  801904:	68 53 3a 80 00       	push   $0x803a53
  801909:	e8 18 ea ff ff       	call   800326 <_panic>

0080190e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80190e:	55                   	push   %ebp
  80190f:	89 e5                	mov    %esp,%ebp
  801911:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801914:	83 ec 04             	sub    $0x4,%esp
  801917:	68 d0 3a 80 00       	push   $0x803ad0
  80191c:	68 2c 01 00 00       	push   $0x12c
  801921:	68 53 3a 80 00       	push   $0x803a53
  801926:	e8 fb e9 ff ff       	call   800326 <_panic>

0080192b <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80192b:	55                   	push   %ebp
  80192c:	89 e5                	mov    %esp,%ebp
  80192e:	57                   	push   %edi
  80192f:	56                   	push   %esi
  801930:	53                   	push   %ebx
  801931:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80193d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801940:	8b 7d 18             	mov    0x18(%ebp),%edi
  801943:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801946:	cd 30                	int    $0x30
  801948:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80194b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80194e:	83 c4 10             	add    $0x10,%esp
  801951:	5b                   	pop    %ebx
  801952:	5e                   	pop    %esi
  801953:	5f                   	pop    %edi
  801954:	5d                   	pop    %ebp
  801955:	c3                   	ret    

00801956 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801956:	55                   	push   %ebp
  801957:	89 e5                	mov    %esp,%ebp
  801959:	83 ec 04             	sub    $0x4,%esp
  80195c:	8b 45 10             	mov    0x10(%ebp),%eax
  80195f:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801962:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801966:	8b 45 08             	mov    0x8(%ebp),%eax
  801969:	6a 00                	push   $0x0
  80196b:	6a 00                	push   $0x0
  80196d:	52                   	push   %edx
  80196e:	ff 75 0c             	pushl  0xc(%ebp)
  801971:	50                   	push   %eax
  801972:	6a 00                	push   $0x0
  801974:	e8 b2 ff ff ff       	call   80192b <syscall>
  801979:	83 c4 18             	add    $0x18,%esp
}
  80197c:	90                   	nop
  80197d:	c9                   	leave  
  80197e:	c3                   	ret    

0080197f <sys_cgetc>:

int
sys_cgetc(void)
{
  80197f:	55                   	push   %ebp
  801980:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801982:	6a 00                	push   $0x0
  801984:	6a 00                	push   $0x0
  801986:	6a 00                	push   $0x0
  801988:	6a 00                	push   $0x0
  80198a:	6a 00                	push   $0x0
  80198c:	6a 01                	push   $0x1
  80198e:	e8 98 ff ff ff       	call   80192b <syscall>
  801993:	83 c4 18             	add    $0x18,%esp
}
  801996:	c9                   	leave  
  801997:	c3                   	ret    

00801998 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801998:	55                   	push   %ebp
  801999:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80199b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80199e:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	52                   	push   %edx
  8019a8:	50                   	push   %eax
  8019a9:	6a 05                	push   $0x5
  8019ab:	e8 7b ff ff ff       	call   80192b <syscall>
  8019b0:	83 c4 18             	add    $0x18,%esp
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	56                   	push   %esi
  8019b9:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019ba:	8b 75 18             	mov    0x18(%ebp),%esi
  8019bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8019c0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c9:	56                   	push   %esi
  8019ca:	53                   	push   %ebx
  8019cb:	51                   	push   %ecx
  8019cc:	52                   	push   %edx
  8019cd:	50                   	push   %eax
  8019ce:	6a 06                	push   $0x6
  8019d0:	e8 56 ff ff ff       	call   80192b <syscall>
  8019d5:	83 c4 18             	add    $0x18,%esp
}
  8019d8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8019db:	5b                   	pop    %ebx
  8019dc:	5e                   	pop    %esi
  8019dd:	5d                   	pop    %ebp
  8019de:	c3                   	ret    

008019df <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8019df:	55                   	push   %ebp
  8019e0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8019e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e8:	6a 00                	push   $0x0
  8019ea:	6a 00                	push   $0x0
  8019ec:	6a 00                	push   $0x0
  8019ee:	52                   	push   %edx
  8019ef:	50                   	push   %eax
  8019f0:	6a 07                	push   $0x7
  8019f2:	e8 34 ff ff ff       	call   80192b <syscall>
  8019f7:	83 c4 18             	add    $0x18,%esp
}
  8019fa:	c9                   	leave  
  8019fb:	c3                   	ret    

008019fc <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8019fc:	55                   	push   %ebp
  8019fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	ff 75 0c             	pushl  0xc(%ebp)
  801a08:	ff 75 08             	pushl  0x8(%ebp)
  801a0b:	6a 08                	push   $0x8
  801a0d:	e8 19 ff ff ff       	call   80192b <syscall>
  801a12:	83 c4 18             	add    $0x18,%esp
}
  801a15:	c9                   	leave  
  801a16:	c3                   	ret    

00801a17 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a17:	55                   	push   %ebp
  801a18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 00                	push   $0x0
  801a24:	6a 09                	push   $0x9
  801a26:	e8 00 ff ff ff       	call   80192b <syscall>
  801a2b:	83 c4 18             	add    $0x18,%esp
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 0a                	push   $0xa
  801a3f:	e8 e7 fe ff ff       	call   80192b <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a4c:	6a 00                	push   $0x0
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	6a 0b                	push   $0xb
  801a58:	e8 ce fe ff ff       	call   80192b <syscall>
  801a5d:	83 c4 18             	add    $0x18,%esp
}
  801a60:	c9                   	leave  
  801a61:	c3                   	ret    

00801a62 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801a62:	55                   	push   %ebp
  801a63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	ff 75 0c             	pushl  0xc(%ebp)
  801a6e:	ff 75 08             	pushl  0x8(%ebp)
  801a71:	6a 0f                	push   $0xf
  801a73:	e8 b3 fe ff ff       	call   80192b <syscall>
  801a78:	83 c4 18             	add    $0x18,%esp
	return;
  801a7b:	90                   	nop
}
  801a7c:	c9                   	leave  
  801a7d:	c3                   	ret    

00801a7e <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801a7e:	55                   	push   %ebp
  801a7f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801a81:	6a 00                	push   $0x0
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	ff 75 0c             	pushl  0xc(%ebp)
  801a8a:	ff 75 08             	pushl  0x8(%ebp)
  801a8d:	6a 10                	push   $0x10
  801a8f:	e8 97 fe ff ff       	call   80192b <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
	return ;
  801a97:	90                   	nop
}
  801a98:	c9                   	leave  
  801a99:	c3                   	ret    

00801a9a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801a9a:	55                   	push   %ebp
  801a9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	ff 75 10             	pushl  0x10(%ebp)
  801aa4:	ff 75 0c             	pushl  0xc(%ebp)
  801aa7:	ff 75 08             	pushl  0x8(%ebp)
  801aaa:	6a 11                	push   $0x11
  801aac:	e8 7a fe ff ff       	call   80192b <syscall>
  801ab1:	83 c4 18             	add    $0x18,%esp
	return ;
  801ab4:	90                   	nop
}
  801ab5:	c9                   	leave  
  801ab6:	c3                   	ret    

00801ab7 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801ab7:	55                   	push   %ebp
  801ab8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 00                	push   $0x0
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	6a 0c                	push   $0xc
  801ac6:	e8 60 fe ff ff       	call   80192b <syscall>
  801acb:	83 c4 18             	add    $0x18,%esp
}
  801ace:	c9                   	leave  
  801acf:	c3                   	ret    

00801ad0 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ad0:	55                   	push   %ebp
  801ad1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 00                	push   $0x0
  801ad9:	6a 00                	push   $0x0
  801adb:	ff 75 08             	pushl  0x8(%ebp)
  801ade:	6a 0d                	push   $0xd
  801ae0:	e8 46 fe ff ff       	call   80192b <syscall>
  801ae5:	83 c4 18             	add    $0x18,%esp
}
  801ae8:	c9                   	leave  
  801ae9:	c3                   	ret    

00801aea <sys_scarce_memory>:

void sys_scarce_memory()
{
  801aea:	55                   	push   %ebp
  801aeb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801aed:	6a 00                	push   $0x0
  801aef:	6a 00                	push   $0x0
  801af1:	6a 00                	push   $0x0
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 0e                	push   $0xe
  801af9:	e8 2d fe ff ff       	call   80192b <syscall>
  801afe:	83 c4 18             	add    $0x18,%esp
}
  801b01:	90                   	nop
  801b02:	c9                   	leave  
  801b03:	c3                   	ret    

00801b04 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b04:	55                   	push   %ebp
  801b05:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 00                	push   $0x0
  801b0d:	6a 00                	push   $0x0
  801b0f:	6a 00                	push   $0x0
  801b11:	6a 13                	push   $0x13
  801b13:	e8 13 fe ff ff       	call   80192b <syscall>
  801b18:	83 c4 18             	add    $0x18,%esp
}
  801b1b:	90                   	nop
  801b1c:	c9                   	leave  
  801b1d:	c3                   	ret    

00801b1e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b1e:	55                   	push   %ebp
  801b1f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b21:	6a 00                	push   $0x0
  801b23:	6a 00                	push   $0x0
  801b25:	6a 00                	push   $0x0
  801b27:	6a 00                	push   $0x0
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 14                	push   $0x14
  801b2d:	e8 f9 fd ff ff       	call   80192b <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
}
  801b35:	90                   	nop
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_cputc>:


void
sys_cputc(const char c)
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
  801b3b:	83 ec 04             	sub    $0x4,%esp
  801b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801b41:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b44:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	50                   	push   %eax
  801b51:	6a 15                	push   $0x15
  801b53:	e8 d3 fd ff ff       	call   80192b <syscall>
  801b58:	83 c4 18             	add    $0x18,%esp
}
  801b5b:	90                   	nop
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 16                	push   $0x16
  801b6d:	e8 b9 fd ff ff       	call   80192b <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	90                   	nop
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801b7b:	8b 45 08             	mov    0x8(%ebp),%eax
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	ff 75 0c             	pushl  0xc(%ebp)
  801b87:	50                   	push   %eax
  801b88:	6a 17                	push   $0x17
  801b8a:	e8 9c fd ff ff       	call   80192b <syscall>
  801b8f:	83 c4 18             	add    $0x18,%esp
}
  801b92:	c9                   	leave  
  801b93:	c3                   	ret    

00801b94 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801b94:	55                   	push   %ebp
  801b95:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801b97:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9d:	6a 00                	push   $0x0
  801b9f:	6a 00                	push   $0x0
  801ba1:	6a 00                	push   $0x0
  801ba3:	52                   	push   %edx
  801ba4:	50                   	push   %eax
  801ba5:	6a 1a                	push   $0x1a
  801ba7:	e8 7f fd ff ff       	call   80192b <syscall>
  801bac:	83 c4 18             	add    $0x18,%esp
}
  801baf:	c9                   	leave  
  801bb0:	c3                   	ret    

00801bb1 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bb1:	55                   	push   %ebp
  801bb2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bb4:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bb7:	8b 45 08             	mov    0x8(%ebp),%eax
  801bba:	6a 00                	push   $0x0
  801bbc:	6a 00                	push   $0x0
  801bbe:	6a 00                	push   $0x0
  801bc0:	52                   	push   %edx
  801bc1:	50                   	push   %eax
  801bc2:	6a 18                	push   $0x18
  801bc4:	e8 62 fd ff ff       	call   80192b <syscall>
  801bc9:	83 c4 18             	add    $0x18,%esp
}
  801bcc:	90                   	nop
  801bcd:	c9                   	leave  
  801bce:	c3                   	ret    

00801bcf <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bcf:	55                   	push   %ebp
  801bd0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bd2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bd5:	8b 45 08             	mov    0x8(%ebp),%eax
  801bd8:	6a 00                	push   $0x0
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	52                   	push   %edx
  801bdf:	50                   	push   %eax
  801be0:	6a 19                	push   $0x19
  801be2:	e8 44 fd ff ff       	call   80192b <syscall>
  801be7:	83 c4 18             	add    $0x18,%esp
}
  801bea:	90                   	nop
  801beb:	c9                   	leave  
  801bec:	c3                   	ret    

00801bed <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801bed:	55                   	push   %ebp
  801bee:	89 e5                	mov    %esp,%ebp
  801bf0:	83 ec 04             	sub    $0x4,%esp
  801bf3:	8b 45 10             	mov    0x10(%ebp),%eax
  801bf6:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801bf9:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801bfc:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c00:	8b 45 08             	mov    0x8(%ebp),%eax
  801c03:	6a 00                	push   $0x0
  801c05:	51                   	push   %ecx
  801c06:	52                   	push   %edx
  801c07:	ff 75 0c             	pushl  0xc(%ebp)
  801c0a:	50                   	push   %eax
  801c0b:	6a 1b                	push   $0x1b
  801c0d:	e8 19 fd ff ff       	call   80192b <syscall>
  801c12:	83 c4 18             	add    $0x18,%esp
}
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c1a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c20:	6a 00                	push   $0x0
  801c22:	6a 00                	push   $0x0
  801c24:	6a 00                	push   $0x0
  801c26:	52                   	push   %edx
  801c27:	50                   	push   %eax
  801c28:	6a 1c                	push   $0x1c
  801c2a:	e8 fc fc ff ff       	call   80192b <syscall>
  801c2f:	83 c4 18             	add    $0x18,%esp
}
  801c32:	c9                   	leave  
  801c33:	c3                   	ret    

00801c34 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c34:	55                   	push   %ebp
  801c35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c37:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c3a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	51                   	push   %ecx
  801c45:	52                   	push   %edx
  801c46:	50                   	push   %eax
  801c47:	6a 1d                	push   $0x1d
  801c49:	e8 dd fc ff ff       	call   80192b <syscall>
  801c4e:	83 c4 18             	add    $0x18,%esp
}
  801c51:	c9                   	leave  
  801c52:	c3                   	ret    

00801c53 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c53:	55                   	push   %ebp
  801c54:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c56:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c59:	8b 45 08             	mov    0x8(%ebp),%eax
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	52                   	push   %edx
  801c63:	50                   	push   %eax
  801c64:	6a 1e                	push   $0x1e
  801c66:	e8 c0 fc ff ff       	call   80192b <syscall>
  801c6b:	83 c4 18             	add    $0x18,%esp
}
  801c6e:	c9                   	leave  
  801c6f:	c3                   	ret    

00801c70 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801c70:	55                   	push   %ebp
  801c71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 00                	push   $0x0
  801c7d:	6a 1f                	push   $0x1f
  801c7f:	e8 a7 fc ff ff       	call   80192b <syscall>
  801c84:	83 c4 18             	add    $0x18,%esp
}
  801c87:	c9                   	leave  
  801c88:	c3                   	ret    

00801c89 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801c89:	55                   	push   %ebp
  801c8a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801c8c:	8b 45 08             	mov    0x8(%ebp),%eax
  801c8f:	6a 00                	push   $0x0
  801c91:	ff 75 14             	pushl  0x14(%ebp)
  801c94:	ff 75 10             	pushl  0x10(%ebp)
  801c97:	ff 75 0c             	pushl  0xc(%ebp)
  801c9a:	50                   	push   %eax
  801c9b:	6a 20                	push   $0x20
  801c9d:	e8 89 fc ff ff       	call   80192b <syscall>
  801ca2:	83 c4 18             	add    $0x18,%esp
}
  801ca5:	c9                   	leave  
  801ca6:	c3                   	ret    

00801ca7 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ca7:	55                   	push   %ebp
  801ca8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801caa:	8b 45 08             	mov    0x8(%ebp),%eax
  801cad:	6a 00                	push   $0x0
  801caf:	6a 00                	push   $0x0
  801cb1:	6a 00                	push   $0x0
  801cb3:	6a 00                	push   $0x0
  801cb5:	50                   	push   %eax
  801cb6:	6a 21                	push   $0x21
  801cb8:	e8 6e fc ff ff       	call   80192b <syscall>
  801cbd:	83 c4 18             	add    $0x18,%esp
}
  801cc0:	90                   	nop
  801cc1:	c9                   	leave  
  801cc2:	c3                   	ret    

00801cc3 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801cc3:	55                   	push   %ebp
  801cc4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cc9:	6a 00                	push   $0x0
  801ccb:	6a 00                	push   $0x0
  801ccd:	6a 00                	push   $0x0
  801ccf:	6a 00                	push   $0x0
  801cd1:	50                   	push   %eax
  801cd2:	6a 22                	push   $0x22
  801cd4:	e8 52 fc ff ff       	call   80192b <syscall>
  801cd9:	83 c4 18             	add    $0x18,%esp
}
  801cdc:	c9                   	leave  
  801cdd:	c3                   	ret    

00801cde <sys_getenvid>:

int32 sys_getenvid(void)
{
  801cde:	55                   	push   %ebp
  801cdf:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801ce1:	6a 00                	push   $0x0
  801ce3:	6a 00                	push   $0x0
  801ce5:	6a 00                	push   $0x0
  801ce7:	6a 00                	push   $0x0
  801ce9:	6a 00                	push   $0x0
  801ceb:	6a 02                	push   $0x2
  801ced:	e8 39 fc ff ff       	call   80192b <syscall>
  801cf2:	83 c4 18             	add    $0x18,%esp
}
  801cf5:	c9                   	leave  
  801cf6:	c3                   	ret    

00801cf7 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801cf7:	55                   	push   %ebp
  801cf8:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801cfa:	6a 00                	push   $0x0
  801cfc:	6a 00                	push   $0x0
  801cfe:	6a 00                	push   $0x0
  801d00:	6a 00                	push   $0x0
  801d02:	6a 00                	push   $0x0
  801d04:	6a 03                	push   $0x3
  801d06:	e8 20 fc ff ff       	call   80192b <syscall>
  801d0b:	83 c4 18             	add    $0x18,%esp
}
  801d0e:	c9                   	leave  
  801d0f:	c3                   	ret    

00801d10 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d10:	55                   	push   %ebp
  801d11:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d13:	6a 00                	push   $0x0
  801d15:	6a 00                	push   $0x0
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 04                	push   $0x4
  801d1f:	e8 07 fc ff ff       	call   80192b <syscall>
  801d24:	83 c4 18             	add    $0x18,%esp
}
  801d27:	c9                   	leave  
  801d28:	c3                   	ret    

00801d29 <sys_exit_env>:


void sys_exit_env(void)
{
  801d29:	55                   	push   %ebp
  801d2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d2c:	6a 00                	push   $0x0
  801d2e:	6a 00                	push   $0x0
  801d30:	6a 00                	push   $0x0
  801d32:	6a 00                	push   $0x0
  801d34:	6a 00                	push   $0x0
  801d36:	6a 23                	push   $0x23
  801d38:	e8 ee fb ff ff       	call   80192b <syscall>
  801d3d:	83 c4 18             	add    $0x18,%esp
}
  801d40:	90                   	nop
  801d41:	c9                   	leave  
  801d42:	c3                   	ret    

00801d43 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d43:	55                   	push   %ebp
  801d44:	89 e5                	mov    %esp,%ebp
  801d46:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d49:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d4c:	8d 50 04             	lea    0x4(%eax),%edx
  801d4f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	52                   	push   %edx
  801d59:	50                   	push   %eax
  801d5a:	6a 24                	push   $0x24
  801d5c:	e8 ca fb ff ff       	call   80192b <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
	return result;
  801d64:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801d67:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801d6a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801d6d:	89 01                	mov    %eax,(%ecx)
  801d6f:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801d72:	8b 45 08             	mov    0x8(%ebp),%eax
  801d75:	c9                   	leave  
  801d76:	c2 04 00             	ret    $0x4

00801d79 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801d79:	55                   	push   %ebp
  801d7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	ff 75 10             	pushl  0x10(%ebp)
  801d83:	ff 75 0c             	pushl  0xc(%ebp)
  801d86:	ff 75 08             	pushl  0x8(%ebp)
  801d89:	6a 12                	push   $0x12
  801d8b:	e8 9b fb ff ff       	call   80192b <syscall>
  801d90:	83 c4 18             	add    $0x18,%esp
	return ;
  801d93:	90                   	nop
}
  801d94:	c9                   	leave  
  801d95:	c3                   	ret    

00801d96 <sys_rcr2>:
uint32 sys_rcr2()
{
  801d96:	55                   	push   %ebp
  801d97:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	6a 00                	push   $0x0
  801da1:	6a 00                	push   $0x0
  801da3:	6a 25                	push   $0x25
  801da5:	e8 81 fb ff ff       	call   80192b <syscall>
  801daa:	83 c4 18             	add    $0x18,%esp
}
  801dad:	c9                   	leave  
  801dae:	c3                   	ret    

00801daf <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801daf:	55                   	push   %ebp
  801db0:	89 e5                	mov    %esp,%ebp
  801db2:	83 ec 04             	sub    $0x4,%esp
  801db5:	8b 45 08             	mov    0x8(%ebp),%eax
  801db8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dbb:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801dbf:	6a 00                	push   $0x0
  801dc1:	6a 00                	push   $0x0
  801dc3:	6a 00                	push   $0x0
  801dc5:	6a 00                	push   $0x0
  801dc7:	50                   	push   %eax
  801dc8:	6a 26                	push   $0x26
  801dca:	e8 5c fb ff ff       	call   80192b <syscall>
  801dcf:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd2:	90                   	nop
}
  801dd3:	c9                   	leave  
  801dd4:	c3                   	ret    

00801dd5 <rsttst>:
void rsttst()
{
  801dd5:	55                   	push   %ebp
  801dd6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801dd8:	6a 00                	push   $0x0
  801dda:	6a 00                	push   $0x0
  801ddc:	6a 00                	push   $0x0
  801dde:	6a 00                	push   $0x0
  801de0:	6a 00                	push   $0x0
  801de2:	6a 28                	push   $0x28
  801de4:	e8 42 fb ff ff       	call   80192b <syscall>
  801de9:	83 c4 18             	add    $0x18,%esp
	return ;
  801dec:	90                   	nop
}
  801ded:	c9                   	leave  
  801dee:	c3                   	ret    

00801def <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801def:	55                   	push   %ebp
  801df0:	89 e5                	mov    %esp,%ebp
  801df2:	83 ec 04             	sub    $0x4,%esp
  801df5:	8b 45 14             	mov    0x14(%ebp),%eax
  801df8:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801dfb:	8b 55 18             	mov    0x18(%ebp),%edx
  801dfe:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e02:	52                   	push   %edx
  801e03:	50                   	push   %eax
  801e04:	ff 75 10             	pushl  0x10(%ebp)
  801e07:	ff 75 0c             	pushl  0xc(%ebp)
  801e0a:	ff 75 08             	pushl  0x8(%ebp)
  801e0d:	6a 27                	push   $0x27
  801e0f:	e8 17 fb ff ff       	call   80192b <syscall>
  801e14:	83 c4 18             	add    $0x18,%esp
	return ;
  801e17:	90                   	nop
}
  801e18:	c9                   	leave  
  801e19:	c3                   	ret    

00801e1a <chktst>:
void chktst(uint32 n)
{
  801e1a:	55                   	push   %ebp
  801e1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e1d:	6a 00                	push   $0x0
  801e1f:	6a 00                	push   $0x0
  801e21:	6a 00                	push   $0x0
  801e23:	6a 00                	push   $0x0
  801e25:	ff 75 08             	pushl  0x8(%ebp)
  801e28:	6a 29                	push   $0x29
  801e2a:	e8 fc fa ff ff       	call   80192b <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
	return ;
  801e32:	90                   	nop
}
  801e33:	c9                   	leave  
  801e34:	c3                   	ret    

00801e35 <inctst>:

void inctst()
{
  801e35:	55                   	push   %ebp
  801e36:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e38:	6a 00                	push   $0x0
  801e3a:	6a 00                	push   $0x0
  801e3c:	6a 00                	push   $0x0
  801e3e:	6a 00                	push   $0x0
  801e40:	6a 00                	push   $0x0
  801e42:	6a 2a                	push   $0x2a
  801e44:	e8 e2 fa ff ff       	call   80192b <syscall>
  801e49:	83 c4 18             	add    $0x18,%esp
	return ;
  801e4c:	90                   	nop
}
  801e4d:	c9                   	leave  
  801e4e:	c3                   	ret    

00801e4f <gettst>:
uint32 gettst()
{
  801e4f:	55                   	push   %ebp
  801e50:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e52:	6a 00                	push   $0x0
  801e54:	6a 00                	push   $0x0
  801e56:	6a 00                	push   $0x0
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 2b                	push   $0x2b
  801e5e:	e8 c8 fa ff ff       	call   80192b <syscall>
  801e63:	83 c4 18             	add    $0x18,%esp
}
  801e66:	c9                   	leave  
  801e67:	c3                   	ret    

00801e68 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801e68:	55                   	push   %ebp
  801e69:	89 e5                	mov    %esp,%ebp
  801e6b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e6e:	6a 00                	push   $0x0
  801e70:	6a 00                	push   $0x0
  801e72:	6a 00                	push   $0x0
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 2c                	push   $0x2c
  801e7a:	e8 ac fa ff ff       	call   80192b <syscall>
  801e7f:	83 c4 18             	add    $0x18,%esp
  801e82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801e85:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801e89:	75 07                	jne    801e92 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801e8b:	b8 01 00 00 00       	mov    $0x1,%eax
  801e90:	eb 05                	jmp    801e97 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801e92:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e97:	c9                   	leave  
  801e98:	c3                   	ret    

00801e99 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801e99:	55                   	push   %ebp
  801e9a:	89 e5                	mov    %esp,%ebp
  801e9c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801e9f:	6a 00                	push   $0x0
  801ea1:	6a 00                	push   $0x0
  801ea3:	6a 00                	push   $0x0
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 2c                	push   $0x2c
  801eab:	e8 7b fa ff ff       	call   80192b <syscall>
  801eb0:	83 c4 18             	add    $0x18,%esp
  801eb3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801eb6:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801eba:	75 07                	jne    801ec3 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ebc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ec1:	eb 05                	jmp    801ec8 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801ec3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ec8:	c9                   	leave  
  801ec9:	c3                   	ret    

00801eca <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801eca:	55                   	push   %ebp
  801ecb:	89 e5                	mov    %esp,%ebp
  801ecd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ed0:	6a 00                	push   $0x0
  801ed2:	6a 00                	push   $0x0
  801ed4:	6a 00                	push   $0x0
  801ed6:	6a 00                	push   $0x0
  801ed8:	6a 00                	push   $0x0
  801eda:	6a 2c                	push   $0x2c
  801edc:	e8 4a fa ff ff       	call   80192b <syscall>
  801ee1:	83 c4 18             	add    $0x18,%esp
  801ee4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ee7:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801eeb:	75 07                	jne    801ef4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801eed:	b8 01 00 00 00       	mov    $0x1,%eax
  801ef2:	eb 05                	jmp    801ef9 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801ef4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ef9:	c9                   	leave  
  801efa:	c3                   	ret    

00801efb <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801efb:	55                   	push   %ebp
  801efc:	89 e5                	mov    %esp,%ebp
  801efe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 00                	push   $0x0
  801f0b:	6a 2c                	push   $0x2c
  801f0d:	e8 19 fa ff ff       	call   80192b <syscall>
  801f12:	83 c4 18             	add    $0x18,%esp
  801f15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f18:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f1c:	75 07                	jne    801f25 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f23:	eb 05                	jmp    801f2a <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f2a:	c9                   	leave  
  801f2b:	c3                   	ret    

00801f2c <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f2c:	55                   	push   %ebp
  801f2d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f2f:	6a 00                	push   $0x0
  801f31:	6a 00                	push   $0x0
  801f33:	6a 00                	push   $0x0
  801f35:	6a 00                	push   $0x0
  801f37:	ff 75 08             	pushl  0x8(%ebp)
  801f3a:	6a 2d                	push   $0x2d
  801f3c:	e8 ea f9 ff ff       	call   80192b <syscall>
  801f41:	83 c4 18             	add    $0x18,%esp
	return ;
  801f44:	90                   	nop
}
  801f45:	c9                   	leave  
  801f46:	c3                   	ret    

00801f47 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f47:	55                   	push   %ebp
  801f48:	89 e5                	mov    %esp,%ebp
  801f4a:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f4b:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f4e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f51:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f54:	8b 45 08             	mov    0x8(%ebp),%eax
  801f57:	6a 00                	push   $0x0
  801f59:	53                   	push   %ebx
  801f5a:	51                   	push   %ecx
  801f5b:	52                   	push   %edx
  801f5c:	50                   	push   %eax
  801f5d:	6a 2e                	push   $0x2e
  801f5f:	e8 c7 f9 ff ff       	call   80192b <syscall>
  801f64:	83 c4 18             	add    $0x18,%esp
}
  801f67:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801f6a:	c9                   	leave  
  801f6b:	c3                   	ret    

00801f6c <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801f6c:	55                   	push   %ebp
  801f6d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801f6f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f72:	8b 45 08             	mov    0x8(%ebp),%eax
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	52                   	push   %edx
  801f7c:	50                   	push   %eax
  801f7d:	6a 2f                	push   $0x2f
  801f7f:	e8 a7 f9 ff ff       	call   80192b <syscall>
  801f84:	83 c4 18             	add    $0x18,%esp
}
  801f87:	c9                   	leave  
  801f88:	c3                   	ret    

00801f89 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801f89:	55                   	push   %ebp
  801f8a:	89 e5                	mov    %esp,%ebp
  801f8c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801f8f:	83 ec 0c             	sub    $0xc,%esp
  801f92:	68 e0 3a 80 00       	push   $0x803ae0
  801f97:	e8 3e e6 ff ff       	call   8005da <cprintf>
  801f9c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801f9f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fa6:	83 ec 0c             	sub    $0xc,%esp
  801fa9:	68 0c 3b 80 00       	push   $0x803b0c
  801fae:	e8 27 e6 ff ff       	call   8005da <cprintf>
  801fb3:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801fb6:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801fba:	a1 38 41 80 00       	mov    0x804138,%eax
  801fbf:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801fc2:	eb 56                	jmp    80201a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801fc4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fc8:	74 1c                	je     801fe6 <print_mem_block_lists+0x5d>
  801fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fcd:	8b 50 08             	mov    0x8(%eax),%edx
  801fd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd3:	8b 48 08             	mov    0x8(%eax),%ecx
  801fd6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fd9:	8b 40 0c             	mov    0xc(%eax),%eax
  801fdc:	01 c8                	add    %ecx,%eax
  801fde:	39 c2                	cmp    %eax,%edx
  801fe0:	73 04                	jae    801fe6 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801fe2:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801fe6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fe9:	8b 50 08             	mov    0x8(%eax),%edx
  801fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801fef:	8b 40 0c             	mov    0xc(%eax),%eax
  801ff2:	01 c2                	add    %eax,%edx
  801ff4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ff7:	8b 40 08             	mov    0x8(%eax),%eax
  801ffa:	83 ec 04             	sub    $0x4,%esp
  801ffd:	52                   	push   %edx
  801ffe:	50                   	push   %eax
  801fff:	68 21 3b 80 00       	push   $0x803b21
  802004:	e8 d1 e5 ff ff       	call   8005da <cprintf>
  802009:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80200c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80200f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802012:	a1 40 41 80 00       	mov    0x804140,%eax
  802017:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80201a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80201e:	74 07                	je     802027 <print_mem_block_lists+0x9e>
  802020:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802023:	8b 00                	mov    (%eax),%eax
  802025:	eb 05                	jmp    80202c <print_mem_block_lists+0xa3>
  802027:	b8 00 00 00 00       	mov    $0x0,%eax
  80202c:	a3 40 41 80 00       	mov    %eax,0x804140
  802031:	a1 40 41 80 00       	mov    0x804140,%eax
  802036:	85 c0                	test   %eax,%eax
  802038:	75 8a                	jne    801fc4 <print_mem_block_lists+0x3b>
  80203a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80203e:	75 84                	jne    801fc4 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802040:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802044:	75 10                	jne    802056 <print_mem_block_lists+0xcd>
  802046:	83 ec 0c             	sub    $0xc,%esp
  802049:	68 30 3b 80 00       	push   $0x803b30
  80204e:	e8 87 e5 ff ff       	call   8005da <cprintf>
  802053:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  802056:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  80205d:	83 ec 0c             	sub    $0xc,%esp
  802060:	68 54 3b 80 00       	push   $0x803b54
  802065:	e8 70 e5 ff ff       	call   8005da <cprintf>
  80206a:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  80206d:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802071:	a1 40 40 80 00       	mov    0x804040,%eax
  802076:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802079:	eb 56                	jmp    8020d1 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  80207b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80207f:	74 1c                	je     80209d <print_mem_block_lists+0x114>
  802081:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802084:	8b 50 08             	mov    0x8(%eax),%edx
  802087:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80208a:	8b 48 08             	mov    0x8(%eax),%ecx
  80208d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802090:	8b 40 0c             	mov    0xc(%eax),%eax
  802093:	01 c8                	add    %ecx,%eax
  802095:	39 c2                	cmp    %eax,%edx
  802097:	73 04                	jae    80209d <print_mem_block_lists+0x114>
			sorted = 0 ;
  802099:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80209d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a0:	8b 50 08             	mov    0x8(%eax),%edx
  8020a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020a6:	8b 40 0c             	mov    0xc(%eax),%eax
  8020a9:	01 c2                	add    %eax,%edx
  8020ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ae:	8b 40 08             	mov    0x8(%eax),%eax
  8020b1:	83 ec 04             	sub    $0x4,%esp
  8020b4:	52                   	push   %edx
  8020b5:	50                   	push   %eax
  8020b6:	68 21 3b 80 00       	push   $0x803b21
  8020bb:	e8 1a e5 ff ff       	call   8005da <cprintf>
  8020c0:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8020c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020c9:	a1 48 40 80 00       	mov    0x804048,%eax
  8020ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020d1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020d5:	74 07                	je     8020de <print_mem_block_lists+0x155>
  8020d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020da:	8b 00                	mov    (%eax),%eax
  8020dc:	eb 05                	jmp    8020e3 <print_mem_block_lists+0x15a>
  8020de:	b8 00 00 00 00       	mov    $0x0,%eax
  8020e3:	a3 48 40 80 00       	mov    %eax,0x804048
  8020e8:	a1 48 40 80 00       	mov    0x804048,%eax
  8020ed:	85 c0                	test   %eax,%eax
  8020ef:	75 8a                	jne    80207b <print_mem_block_lists+0xf2>
  8020f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020f5:	75 84                	jne    80207b <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8020f7:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8020fb:	75 10                	jne    80210d <print_mem_block_lists+0x184>
  8020fd:	83 ec 0c             	sub    $0xc,%esp
  802100:	68 6c 3b 80 00       	push   $0x803b6c
  802105:	e8 d0 e4 ff ff       	call   8005da <cprintf>
  80210a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80210d:	83 ec 0c             	sub    $0xc,%esp
  802110:	68 e0 3a 80 00       	push   $0x803ae0
  802115:	e8 c0 e4 ff ff       	call   8005da <cprintf>
  80211a:	83 c4 10             	add    $0x10,%esp

}
  80211d:	90                   	nop
  80211e:	c9                   	leave  
  80211f:	c3                   	ret    

00802120 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802120:	55                   	push   %ebp
  802121:	89 e5                	mov    %esp,%ebp
  802123:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  802126:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  80212d:	00 00 00 
  802130:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  802137:	00 00 00 
  80213a:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802141:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802144:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80214b:	e9 9e 00 00 00       	jmp    8021ee <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802150:	a1 50 40 80 00       	mov    0x804050,%eax
  802155:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802158:	c1 e2 04             	shl    $0x4,%edx
  80215b:	01 d0                	add    %edx,%eax
  80215d:	85 c0                	test   %eax,%eax
  80215f:	75 14                	jne    802175 <initialize_MemBlocksList+0x55>
  802161:	83 ec 04             	sub    $0x4,%esp
  802164:	68 94 3b 80 00       	push   $0x803b94
  802169:	6a 3d                	push   $0x3d
  80216b:	68 b7 3b 80 00       	push   $0x803bb7
  802170:	e8 b1 e1 ff ff       	call   800326 <_panic>
  802175:	a1 50 40 80 00       	mov    0x804050,%eax
  80217a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80217d:	c1 e2 04             	shl    $0x4,%edx
  802180:	01 d0                	add    %edx,%eax
  802182:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802188:	89 10                	mov    %edx,(%eax)
  80218a:	8b 00                	mov    (%eax),%eax
  80218c:	85 c0                	test   %eax,%eax
  80218e:	74 18                	je     8021a8 <initialize_MemBlocksList+0x88>
  802190:	a1 48 41 80 00       	mov    0x804148,%eax
  802195:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80219b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80219e:	c1 e1 04             	shl    $0x4,%ecx
  8021a1:	01 ca                	add    %ecx,%edx
  8021a3:	89 50 04             	mov    %edx,0x4(%eax)
  8021a6:	eb 12                	jmp    8021ba <initialize_MemBlocksList+0x9a>
  8021a8:	a1 50 40 80 00       	mov    0x804050,%eax
  8021ad:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021b0:	c1 e2 04             	shl    $0x4,%edx
  8021b3:	01 d0                	add    %edx,%eax
  8021b5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021ba:	a1 50 40 80 00       	mov    0x804050,%eax
  8021bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c2:	c1 e2 04             	shl    $0x4,%edx
  8021c5:	01 d0                	add    %edx,%eax
  8021c7:	a3 48 41 80 00       	mov    %eax,0x804148
  8021cc:	a1 50 40 80 00       	mov    0x804050,%eax
  8021d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021d4:	c1 e2 04             	shl    $0x4,%edx
  8021d7:	01 d0                	add    %edx,%eax
  8021d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8021e0:	a1 54 41 80 00       	mov    0x804154,%eax
  8021e5:	40                   	inc    %eax
  8021e6:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8021eb:	ff 45 f4             	incl   -0xc(%ebp)
  8021ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021f1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021f4:	0f 82 56 ff ff ff    	jb     802150 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8021fa:	90                   	nop
  8021fb:	c9                   	leave  
  8021fc:	c3                   	ret    

008021fd <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8021fd:	55                   	push   %ebp
  8021fe:	89 e5                	mov    %esp,%ebp
  802200:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802203:	8b 45 08             	mov    0x8(%ebp),%eax
  802206:	8b 00                	mov    (%eax),%eax
  802208:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80220b:	eb 18                	jmp    802225 <find_block+0x28>

		if(tmp->sva == va){
  80220d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802210:	8b 40 08             	mov    0x8(%eax),%eax
  802213:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802216:	75 05                	jne    80221d <find_block+0x20>
			return tmp ;
  802218:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80221b:	eb 11                	jmp    80222e <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  80221d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802220:	8b 00                	mov    (%eax),%eax
  802222:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802225:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802229:	75 e2                	jne    80220d <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  80222b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80222e:	c9                   	leave  
  80222f:	c3                   	ret    

00802230 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802230:	55                   	push   %ebp
  802231:	89 e5                	mov    %esp,%ebp
  802233:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802236:	a1 40 40 80 00       	mov    0x804040,%eax
  80223b:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  80223e:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802243:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802246:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80224a:	75 65                	jne    8022b1 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  80224c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802250:	75 14                	jne    802266 <insert_sorted_allocList+0x36>
  802252:	83 ec 04             	sub    $0x4,%esp
  802255:	68 94 3b 80 00       	push   $0x803b94
  80225a:	6a 62                	push   $0x62
  80225c:	68 b7 3b 80 00       	push   $0x803bb7
  802261:	e8 c0 e0 ff ff       	call   800326 <_panic>
  802266:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80226c:	8b 45 08             	mov    0x8(%ebp),%eax
  80226f:	89 10                	mov    %edx,(%eax)
  802271:	8b 45 08             	mov    0x8(%ebp),%eax
  802274:	8b 00                	mov    (%eax),%eax
  802276:	85 c0                	test   %eax,%eax
  802278:	74 0d                	je     802287 <insert_sorted_allocList+0x57>
  80227a:	a1 40 40 80 00       	mov    0x804040,%eax
  80227f:	8b 55 08             	mov    0x8(%ebp),%edx
  802282:	89 50 04             	mov    %edx,0x4(%eax)
  802285:	eb 08                	jmp    80228f <insert_sorted_allocList+0x5f>
  802287:	8b 45 08             	mov    0x8(%ebp),%eax
  80228a:	a3 44 40 80 00       	mov    %eax,0x804044
  80228f:	8b 45 08             	mov    0x8(%ebp),%eax
  802292:	a3 40 40 80 00       	mov    %eax,0x804040
  802297:	8b 45 08             	mov    0x8(%ebp),%eax
  80229a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022a1:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022a6:	40                   	inc    %eax
  8022a7:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8022ac:	e9 14 01 00 00       	jmp    8023c5 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  8022b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b4:	8b 50 08             	mov    0x8(%eax),%edx
  8022b7:	a1 44 40 80 00       	mov    0x804044,%eax
  8022bc:	8b 40 08             	mov    0x8(%eax),%eax
  8022bf:	39 c2                	cmp    %eax,%edx
  8022c1:	76 65                	jbe    802328 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  8022c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8022c7:	75 14                	jne    8022dd <insert_sorted_allocList+0xad>
  8022c9:	83 ec 04             	sub    $0x4,%esp
  8022cc:	68 d0 3b 80 00       	push   $0x803bd0
  8022d1:	6a 64                	push   $0x64
  8022d3:	68 b7 3b 80 00       	push   $0x803bb7
  8022d8:	e8 49 e0 ff ff       	call   800326 <_panic>
  8022dd:	8b 15 44 40 80 00    	mov    0x804044,%edx
  8022e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022e6:	89 50 04             	mov    %edx,0x4(%eax)
  8022e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ec:	8b 40 04             	mov    0x4(%eax),%eax
  8022ef:	85 c0                	test   %eax,%eax
  8022f1:	74 0c                	je     8022ff <insert_sorted_allocList+0xcf>
  8022f3:	a1 44 40 80 00       	mov    0x804044,%eax
  8022f8:	8b 55 08             	mov    0x8(%ebp),%edx
  8022fb:	89 10                	mov    %edx,(%eax)
  8022fd:	eb 08                	jmp    802307 <insert_sorted_allocList+0xd7>
  8022ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802302:	a3 40 40 80 00       	mov    %eax,0x804040
  802307:	8b 45 08             	mov    0x8(%ebp),%eax
  80230a:	a3 44 40 80 00       	mov    %eax,0x804044
  80230f:	8b 45 08             	mov    0x8(%ebp),%eax
  802312:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802318:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80231d:	40                   	inc    %eax
  80231e:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802323:	e9 9d 00 00 00       	jmp    8023c5 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802328:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80232f:	e9 85 00 00 00       	jmp    8023b9 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	8b 50 08             	mov    0x8(%eax),%edx
  80233a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233d:	8b 40 08             	mov    0x8(%eax),%eax
  802340:	39 c2                	cmp    %eax,%edx
  802342:	73 6a                	jae    8023ae <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802344:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802348:	74 06                	je     802350 <insert_sorted_allocList+0x120>
  80234a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80234e:	75 14                	jne    802364 <insert_sorted_allocList+0x134>
  802350:	83 ec 04             	sub    $0x4,%esp
  802353:	68 f4 3b 80 00       	push   $0x803bf4
  802358:	6a 6b                	push   $0x6b
  80235a:	68 b7 3b 80 00       	push   $0x803bb7
  80235f:	e8 c2 df ff ff       	call   800326 <_panic>
  802364:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802367:	8b 50 04             	mov    0x4(%eax),%edx
  80236a:	8b 45 08             	mov    0x8(%ebp),%eax
  80236d:	89 50 04             	mov    %edx,0x4(%eax)
  802370:	8b 45 08             	mov    0x8(%ebp),%eax
  802373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802376:	89 10                	mov    %edx,(%eax)
  802378:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80237b:	8b 40 04             	mov    0x4(%eax),%eax
  80237e:	85 c0                	test   %eax,%eax
  802380:	74 0d                	je     80238f <insert_sorted_allocList+0x15f>
  802382:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802385:	8b 40 04             	mov    0x4(%eax),%eax
  802388:	8b 55 08             	mov    0x8(%ebp),%edx
  80238b:	89 10                	mov    %edx,(%eax)
  80238d:	eb 08                	jmp    802397 <insert_sorted_allocList+0x167>
  80238f:	8b 45 08             	mov    0x8(%ebp),%eax
  802392:	a3 40 40 80 00       	mov    %eax,0x804040
  802397:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80239a:	8b 55 08             	mov    0x8(%ebp),%edx
  80239d:	89 50 04             	mov    %edx,0x4(%eax)
  8023a0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023a5:	40                   	inc    %eax
  8023a6:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  8023ab:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8023ac:	eb 17                	jmp    8023c5 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  8023ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b1:	8b 00                	mov    (%eax),%eax
  8023b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8023b6:	ff 45 f0             	incl   -0x10(%ebp)
  8023b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023bc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8023bf:	0f 8c 6f ff ff ff    	jl     802334 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8023c5:	90                   	nop
  8023c6:	c9                   	leave  
  8023c7:	c3                   	ret    

008023c8 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8023c8:	55                   	push   %ebp
  8023c9:	89 e5                	mov    %esp,%ebp
  8023cb:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  8023ce:	a1 38 41 80 00       	mov    0x804138,%eax
  8023d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  8023d6:	e9 7c 01 00 00       	jmp    802557 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 40 0c             	mov    0xc(%eax),%eax
  8023e1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8023e4:	0f 86 cf 00 00 00    	jbe    8024b9 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8023ea:	a1 48 41 80 00       	mov    0x804148,%eax
  8023ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  8023f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023f5:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8023f8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8023fb:	8b 55 08             	mov    0x8(%ebp),%edx
  8023fe:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802401:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802404:	8b 50 08             	mov    0x8(%eax),%edx
  802407:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80240a:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  80240d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802410:	8b 40 0c             	mov    0xc(%eax),%eax
  802413:	2b 45 08             	sub    0x8(%ebp),%eax
  802416:	89 c2                	mov    %eax,%edx
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  80241e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802421:	8b 50 08             	mov    0x8(%eax),%edx
  802424:	8b 45 08             	mov    0x8(%ebp),%eax
  802427:	01 c2                	add    %eax,%edx
  802429:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80242c:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80242f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802433:	75 17                	jne    80244c <alloc_block_FF+0x84>
  802435:	83 ec 04             	sub    $0x4,%esp
  802438:	68 29 3c 80 00       	push   $0x803c29
  80243d:	68 83 00 00 00       	push   $0x83
  802442:	68 b7 3b 80 00       	push   $0x803bb7
  802447:	e8 da de ff ff       	call   800326 <_panic>
  80244c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244f:	8b 00                	mov    (%eax),%eax
  802451:	85 c0                	test   %eax,%eax
  802453:	74 10                	je     802465 <alloc_block_FF+0x9d>
  802455:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802458:	8b 00                	mov    (%eax),%eax
  80245a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80245d:	8b 52 04             	mov    0x4(%edx),%edx
  802460:	89 50 04             	mov    %edx,0x4(%eax)
  802463:	eb 0b                	jmp    802470 <alloc_block_FF+0xa8>
  802465:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802468:	8b 40 04             	mov    0x4(%eax),%eax
  80246b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802470:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802473:	8b 40 04             	mov    0x4(%eax),%eax
  802476:	85 c0                	test   %eax,%eax
  802478:	74 0f                	je     802489 <alloc_block_FF+0xc1>
  80247a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80247d:	8b 40 04             	mov    0x4(%eax),%eax
  802480:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802483:	8b 12                	mov    (%edx),%edx
  802485:	89 10                	mov    %edx,(%eax)
  802487:	eb 0a                	jmp    802493 <alloc_block_FF+0xcb>
  802489:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80248c:	8b 00                	mov    (%eax),%eax
  80248e:	a3 48 41 80 00       	mov    %eax,0x804148
  802493:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802496:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80249c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024a6:	a1 54 41 80 00       	mov    0x804154,%eax
  8024ab:	48                   	dec    %eax
  8024ac:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  8024b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b4:	e9 ad 00 00 00       	jmp    802566 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  8024b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024bc:	8b 40 0c             	mov    0xc(%eax),%eax
  8024bf:	3b 45 08             	cmp    0x8(%ebp),%eax
  8024c2:	0f 85 87 00 00 00    	jne    80254f <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  8024c8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cc:	75 17                	jne    8024e5 <alloc_block_FF+0x11d>
  8024ce:	83 ec 04             	sub    $0x4,%esp
  8024d1:	68 29 3c 80 00       	push   $0x803c29
  8024d6:	68 87 00 00 00       	push   $0x87
  8024db:	68 b7 3b 80 00       	push   $0x803bb7
  8024e0:	e8 41 de ff ff       	call   800326 <_panic>
  8024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024e8:	8b 00                	mov    (%eax),%eax
  8024ea:	85 c0                	test   %eax,%eax
  8024ec:	74 10                	je     8024fe <alloc_block_FF+0x136>
  8024ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024f1:	8b 00                	mov    (%eax),%eax
  8024f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024f6:	8b 52 04             	mov    0x4(%edx),%edx
  8024f9:	89 50 04             	mov    %edx,0x4(%eax)
  8024fc:	eb 0b                	jmp    802509 <alloc_block_FF+0x141>
  8024fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802501:	8b 40 04             	mov    0x4(%eax),%eax
  802504:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802509:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80250c:	8b 40 04             	mov    0x4(%eax),%eax
  80250f:	85 c0                	test   %eax,%eax
  802511:	74 0f                	je     802522 <alloc_block_FF+0x15a>
  802513:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802516:	8b 40 04             	mov    0x4(%eax),%eax
  802519:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80251c:	8b 12                	mov    (%edx),%edx
  80251e:	89 10                	mov    %edx,(%eax)
  802520:	eb 0a                	jmp    80252c <alloc_block_FF+0x164>
  802522:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802525:	8b 00                	mov    (%eax),%eax
  802527:	a3 38 41 80 00       	mov    %eax,0x804138
  80252c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802535:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802538:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80253f:	a1 44 41 80 00       	mov    0x804144,%eax
  802544:	48                   	dec    %eax
  802545:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  80254a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254d:	eb 17                	jmp    802566 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  80254f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802552:	8b 00                	mov    (%eax),%eax
  802554:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802557:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80255b:	0f 85 7a fe ff ff    	jne    8023db <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802561:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802566:	c9                   	leave  
  802567:	c3                   	ret    

00802568 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802568:	55                   	push   %ebp
  802569:	89 e5                	mov    %esp,%ebp
  80256b:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  80256e:	a1 38 41 80 00       	mov    0x804138,%eax
  802573:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802576:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  80257d:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802584:	a1 38 41 80 00       	mov    0x804138,%eax
  802589:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80258c:	e9 d0 00 00 00       	jmp    802661 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802591:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802594:	8b 40 0c             	mov    0xc(%eax),%eax
  802597:	3b 45 08             	cmp    0x8(%ebp),%eax
  80259a:	0f 82 b8 00 00 00    	jb     802658 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  8025a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025a3:	8b 40 0c             	mov    0xc(%eax),%eax
  8025a6:	2b 45 08             	sub    0x8(%ebp),%eax
  8025a9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  8025ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025af:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025b2:	0f 83 a1 00 00 00    	jae    802659 <alloc_block_BF+0xf1>
				differsize = differance ;
  8025b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025bb:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  8025be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  8025c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8025c8:	0f 85 8b 00 00 00    	jne    802659 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  8025ce:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8025d2:	75 17                	jne    8025eb <alloc_block_BF+0x83>
  8025d4:	83 ec 04             	sub    $0x4,%esp
  8025d7:	68 29 3c 80 00       	push   $0x803c29
  8025dc:	68 a0 00 00 00       	push   $0xa0
  8025e1:	68 b7 3b 80 00       	push   $0x803bb7
  8025e6:	e8 3b dd ff ff       	call   800326 <_panic>
  8025eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ee:	8b 00                	mov    (%eax),%eax
  8025f0:	85 c0                	test   %eax,%eax
  8025f2:	74 10                	je     802604 <alloc_block_BF+0x9c>
  8025f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f7:	8b 00                	mov    (%eax),%eax
  8025f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025fc:	8b 52 04             	mov    0x4(%edx),%edx
  8025ff:	89 50 04             	mov    %edx,0x4(%eax)
  802602:	eb 0b                	jmp    80260f <alloc_block_BF+0xa7>
  802604:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802607:	8b 40 04             	mov    0x4(%eax),%eax
  80260a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80260f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802612:	8b 40 04             	mov    0x4(%eax),%eax
  802615:	85 c0                	test   %eax,%eax
  802617:	74 0f                	je     802628 <alloc_block_BF+0xc0>
  802619:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80261c:	8b 40 04             	mov    0x4(%eax),%eax
  80261f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802622:	8b 12                	mov    (%edx),%edx
  802624:	89 10                	mov    %edx,(%eax)
  802626:	eb 0a                	jmp    802632 <alloc_block_BF+0xca>
  802628:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262b:	8b 00                	mov    (%eax),%eax
  80262d:	a3 38 41 80 00       	mov    %eax,0x804138
  802632:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802635:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80263b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802645:	a1 44 41 80 00       	mov    0x804144,%eax
  80264a:	48                   	dec    %eax
  80264b:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  802650:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802653:	e9 0c 01 00 00       	jmp    802764 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802658:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802659:	a1 40 41 80 00       	mov    0x804140,%eax
  80265e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802661:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802665:	74 07                	je     80266e <alloc_block_BF+0x106>
  802667:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266a:	8b 00                	mov    (%eax),%eax
  80266c:	eb 05                	jmp    802673 <alloc_block_BF+0x10b>
  80266e:	b8 00 00 00 00       	mov    $0x0,%eax
  802673:	a3 40 41 80 00       	mov    %eax,0x804140
  802678:	a1 40 41 80 00       	mov    0x804140,%eax
  80267d:	85 c0                	test   %eax,%eax
  80267f:	0f 85 0c ff ff ff    	jne    802591 <alloc_block_BF+0x29>
  802685:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802689:	0f 85 02 ff ff ff    	jne    802591 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  80268f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802693:	0f 84 c6 00 00 00    	je     80275f <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802699:	a1 48 41 80 00       	mov    0x804148,%eax
  80269e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  8026a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8026a7:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  8026aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ad:	8b 50 08             	mov    0x8(%eax),%edx
  8026b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026b3:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  8026b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8026bc:	2b 45 08             	sub    0x8(%ebp),%eax
  8026bf:	89 c2                	mov    %eax,%edx
  8026c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026c4:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  8026c7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026ca:	8b 50 08             	mov    0x8(%eax),%edx
  8026cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d0:	01 c2                	add    %eax,%edx
  8026d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026d5:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  8026d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8026dc:	75 17                	jne    8026f5 <alloc_block_BF+0x18d>
  8026de:	83 ec 04             	sub    $0x4,%esp
  8026e1:	68 29 3c 80 00       	push   $0x803c29
  8026e6:	68 af 00 00 00       	push   $0xaf
  8026eb:	68 b7 3b 80 00       	push   $0x803bb7
  8026f0:	e8 31 dc ff ff       	call   800326 <_panic>
  8026f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f8:	8b 00                	mov    (%eax),%eax
  8026fa:	85 c0                	test   %eax,%eax
  8026fc:	74 10                	je     80270e <alloc_block_BF+0x1a6>
  8026fe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802701:	8b 00                	mov    (%eax),%eax
  802703:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802706:	8b 52 04             	mov    0x4(%edx),%edx
  802709:	89 50 04             	mov    %edx,0x4(%eax)
  80270c:	eb 0b                	jmp    802719 <alloc_block_BF+0x1b1>
  80270e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802711:	8b 40 04             	mov    0x4(%eax),%eax
  802714:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802719:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80271c:	8b 40 04             	mov    0x4(%eax),%eax
  80271f:	85 c0                	test   %eax,%eax
  802721:	74 0f                	je     802732 <alloc_block_BF+0x1ca>
  802723:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802726:	8b 40 04             	mov    0x4(%eax),%eax
  802729:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80272c:	8b 12                	mov    (%edx),%edx
  80272e:	89 10                	mov    %edx,(%eax)
  802730:	eb 0a                	jmp    80273c <alloc_block_BF+0x1d4>
  802732:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802735:	8b 00                	mov    (%eax),%eax
  802737:	a3 48 41 80 00       	mov    %eax,0x804148
  80273c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80273f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802745:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802748:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80274f:	a1 54 41 80 00       	mov    0x804154,%eax
  802754:	48                   	dec    %eax
  802755:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  80275a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80275d:	eb 05                	jmp    802764 <alloc_block_BF+0x1fc>
	}

	return NULL;
  80275f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802764:	c9                   	leave  
  802765:	c3                   	ret    

00802766 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802766:	55                   	push   %ebp
  802767:	89 e5                	mov    %esp,%ebp
  802769:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  80276c:	a1 38 41 80 00       	mov    0x804138,%eax
  802771:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802774:	e9 7c 01 00 00       	jmp    8028f5 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802779:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277c:	8b 40 0c             	mov    0xc(%eax),%eax
  80277f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802782:	0f 86 cf 00 00 00    	jbe    802857 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802788:	a1 48 41 80 00       	mov    0x804148,%eax
  80278d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802790:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802793:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802796:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802799:	8b 55 08             	mov    0x8(%ebp),%edx
  80279c:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  80279f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a2:	8b 50 08             	mov    0x8(%eax),%edx
  8027a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027a8:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  8027ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ae:	8b 40 0c             	mov    0xc(%eax),%eax
  8027b1:	2b 45 08             	sub    0x8(%ebp),%eax
  8027b4:	89 c2                	mov    %eax,%edx
  8027b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027b9:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  8027bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027bf:	8b 50 08             	mov    0x8(%eax),%edx
  8027c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c5:	01 c2                	add    %eax,%edx
  8027c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027ca:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8027cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027d1:	75 17                	jne    8027ea <alloc_block_NF+0x84>
  8027d3:	83 ec 04             	sub    $0x4,%esp
  8027d6:	68 29 3c 80 00       	push   $0x803c29
  8027db:	68 c4 00 00 00       	push   $0xc4
  8027e0:	68 b7 3b 80 00       	push   $0x803bb7
  8027e5:	e8 3c db ff ff       	call   800326 <_panic>
  8027ea:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ed:	8b 00                	mov    (%eax),%eax
  8027ef:	85 c0                	test   %eax,%eax
  8027f1:	74 10                	je     802803 <alloc_block_NF+0x9d>
  8027f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f6:	8b 00                	mov    (%eax),%eax
  8027f8:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8027fb:	8b 52 04             	mov    0x4(%edx),%edx
  8027fe:	89 50 04             	mov    %edx,0x4(%eax)
  802801:	eb 0b                	jmp    80280e <alloc_block_NF+0xa8>
  802803:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802806:	8b 40 04             	mov    0x4(%eax),%eax
  802809:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80280e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802811:	8b 40 04             	mov    0x4(%eax),%eax
  802814:	85 c0                	test   %eax,%eax
  802816:	74 0f                	je     802827 <alloc_block_NF+0xc1>
  802818:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80281b:	8b 40 04             	mov    0x4(%eax),%eax
  80281e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802821:	8b 12                	mov    (%edx),%edx
  802823:	89 10                	mov    %edx,(%eax)
  802825:	eb 0a                	jmp    802831 <alloc_block_NF+0xcb>
  802827:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80282a:	8b 00                	mov    (%eax),%eax
  80282c:	a3 48 41 80 00       	mov    %eax,0x804148
  802831:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802834:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80283a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802844:	a1 54 41 80 00       	mov    0x804154,%eax
  802849:	48                   	dec    %eax
  80284a:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  80284f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802852:	e9 ad 00 00 00       	jmp    802904 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802857:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80285a:	8b 40 0c             	mov    0xc(%eax),%eax
  80285d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802860:	0f 85 87 00 00 00    	jne    8028ed <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802866:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80286a:	75 17                	jne    802883 <alloc_block_NF+0x11d>
  80286c:	83 ec 04             	sub    $0x4,%esp
  80286f:	68 29 3c 80 00       	push   $0x803c29
  802874:	68 c8 00 00 00       	push   $0xc8
  802879:	68 b7 3b 80 00       	push   $0x803bb7
  80287e:	e8 a3 da ff ff       	call   800326 <_panic>
  802883:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802886:	8b 00                	mov    (%eax),%eax
  802888:	85 c0                	test   %eax,%eax
  80288a:	74 10                	je     80289c <alloc_block_NF+0x136>
  80288c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80288f:	8b 00                	mov    (%eax),%eax
  802891:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802894:	8b 52 04             	mov    0x4(%edx),%edx
  802897:	89 50 04             	mov    %edx,0x4(%eax)
  80289a:	eb 0b                	jmp    8028a7 <alloc_block_NF+0x141>
  80289c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289f:	8b 40 04             	mov    0x4(%eax),%eax
  8028a2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028aa:	8b 40 04             	mov    0x4(%eax),%eax
  8028ad:	85 c0                	test   %eax,%eax
  8028af:	74 0f                	je     8028c0 <alloc_block_NF+0x15a>
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	8b 40 04             	mov    0x4(%eax),%eax
  8028b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ba:	8b 12                	mov    (%edx),%edx
  8028bc:	89 10                	mov    %edx,(%eax)
  8028be:	eb 0a                	jmp    8028ca <alloc_block_NF+0x164>
  8028c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028c3:	8b 00                	mov    (%eax),%eax
  8028c5:	a3 38 41 80 00       	mov    %eax,0x804138
  8028ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8028d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028dd:	a1 44 41 80 00       	mov    0x804144,%eax
  8028e2:	48                   	dec    %eax
  8028e3:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  8028e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028eb:	eb 17                	jmp    802904 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  8028ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f0:	8b 00                	mov    (%eax),%eax
  8028f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  8028f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028f9:	0f 85 7a fe ff ff    	jne    802779 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  8028ff:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802904:	c9                   	leave  
  802905:	c3                   	ret    

00802906 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802906:	55                   	push   %ebp
  802907:	89 e5                	mov    %esp,%ebp
  802909:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  80290c:	a1 38 41 80 00       	mov    0x804138,%eax
  802911:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802914:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802919:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  80291c:	a1 44 41 80 00       	mov    0x804144,%eax
  802921:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802924:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802928:	75 68                	jne    802992 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80292a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80292e:	75 17                	jne    802947 <insert_sorted_with_merge_freeList+0x41>
  802930:	83 ec 04             	sub    $0x4,%esp
  802933:	68 94 3b 80 00       	push   $0x803b94
  802938:	68 da 00 00 00       	push   $0xda
  80293d:	68 b7 3b 80 00       	push   $0x803bb7
  802942:	e8 df d9 ff ff       	call   800326 <_panic>
  802947:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80294d:	8b 45 08             	mov    0x8(%ebp),%eax
  802950:	89 10                	mov    %edx,(%eax)
  802952:	8b 45 08             	mov    0x8(%ebp),%eax
  802955:	8b 00                	mov    (%eax),%eax
  802957:	85 c0                	test   %eax,%eax
  802959:	74 0d                	je     802968 <insert_sorted_with_merge_freeList+0x62>
  80295b:	a1 38 41 80 00       	mov    0x804138,%eax
  802960:	8b 55 08             	mov    0x8(%ebp),%edx
  802963:	89 50 04             	mov    %edx,0x4(%eax)
  802966:	eb 08                	jmp    802970 <insert_sorted_with_merge_freeList+0x6a>
  802968:	8b 45 08             	mov    0x8(%ebp),%eax
  80296b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	a3 38 41 80 00       	mov    %eax,0x804138
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802982:	a1 44 41 80 00       	mov    0x804144,%eax
  802987:	40                   	inc    %eax
  802988:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  80298d:	e9 49 07 00 00       	jmp    8030db <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802992:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802995:	8b 50 08             	mov    0x8(%eax),%edx
  802998:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80299b:	8b 40 0c             	mov    0xc(%eax),%eax
  80299e:	01 c2                	add    %eax,%edx
  8029a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a3:	8b 40 08             	mov    0x8(%eax),%eax
  8029a6:	39 c2                	cmp    %eax,%edx
  8029a8:	73 77                	jae    802a21 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  8029aa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029ad:	8b 00                	mov    (%eax),%eax
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	75 6e                	jne    802a21 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  8029b3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029b7:	74 68                	je     802a21 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  8029b9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029bd:	75 17                	jne    8029d6 <insert_sorted_with_merge_freeList+0xd0>
  8029bf:	83 ec 04             	sub    $0x4,%esp
  8029c2:	68 d0 3b 80 00       	push   $0x803bd0
  8029c7:	68 e0 00 00 00       	push   $0xe0
  8029cc:	68 b7 3b 80 00       	push   $0x803bb7
  8029d1:	e8 50 d9 ff ff       	call   800326 <_panic>
  8029d6:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  8029dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029df:	89 50 04             	mov    %edx,0x4(%eax)
  8029e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e5:	8b 40 04             	mov    0x4(%eax),%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	74 0c                	je     8029f8 <insert_sorted_with_merge_freeList+0xf2>
  8029ec:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8029f4:	89 10                	mov    %edx,(%eax)
  8029f6:	eb 08                	jmp    802a00 <insert_sorted_with_merge_freeList+0xfa>
  8029f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fb:	a3 38 41 80 00       	mov    %eax,0x804138
  802a00:	8b 45 08             	mov    0x8(%ebp),%eax
  802a03:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a08:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a11:	a1 44 41 80 00       	mov    0x804144,%eax
  802a16:	40                   	inc    %eax
  802a17:	a3 44 41 80 00       	mov    %eax,0x804144
  802a1c:	e9 ba 06 00 00       	jmp    8030db <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802a21:	8b 45 08             	mov    0x8(%ebp),%eax
  802a24:	8b 50 0c             	mov    0xc(%eax),%edx
  802a27:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2a:	8b 40 08             	mov    0x8(%eax),%eax
  802a2d:	01 c2                	add    %eax,%edx
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	8b 40 08             	mov    0x8(%eax),%eax
  802a35:	39 c2                	cmp    %eax,%edx
  802a37:	73 78                	jae    802ab1 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802a39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a3c:	8b 40 04             	mov    0x4(%eax),%eax
  802a3f:	85 c0                	test   %eax,%eax
  802a41:	75 6e                	jne    802ab1 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802a43:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a47:	74 68                	je     802ab1 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802a49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a4d:	75 17                	jne    802a66 <insert_sorted_with_merge_freeList+0x160>
  802a4f:	83 ec 04             	sub    $0x4,%esp
  802a52:	68 94 3b 80 00       	push   $0x803b94
  802a57:	68 e6 00 00 00       	push   $0xe6
  802a5c:	68 b7 3b 80 00       	push   $0x803bb7
  802a61:	e8 c0 d8 ff ff       	call   800326 <_panic>
  802a66:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6f:	89 10                	mov    %edx,(%eax)
  802a71:	8b 45 08             	mov    0x8(%ebp),%eax
  802a74:	8b 00                	mov    (%eax),%eax
  802a76:	85 c0                	test   %eax,%eax
  802a78:	74 0d                	je     802a87 <insert_sorted_with_merge_freeList+0x181>
  802a7a:	a1 38 41 80 00       	mov    0x804138,%eax
  802a7f:	8b 55 08             	mov    0x8(%ebp),%edx
  802a82:	89 50 04             	mov    %edx,0x4(%eax)
  802a85:	eb 08                	jmp    802a8f <insert_sorted_with_merge_freeList+0x189>
  802a87:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a92:	a3 38 41 80 00       	mov    %eax,0x804138
  802a97:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa1:	a1 44 41 80 00       	mov    0x804144,%eax
  802aa6:	40                   	inc    %eax
  802aa7:	a3 44 41 80 00       	mov    %eax,0x804144
  802aac:	e9 2a 06 00 00       	jmp    8030db <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802ab1:	a1 38 41 80 00       	mov    0x804138,%eax
  802ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ab9:	e9 ed 05 00 00       	jmp    8030ab <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802abe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac1:	8b 00                	mov    (%eax),%eax
  802ac3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802ac6:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802aca:	0f 84 a7 00 00 00    	je     802b77 <insert_sorted_with_merge_freeList+0x271>
  802ad0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad3:	8b 50 0c             	mov    0xc(%eax),%edx
  802ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad9:	8b 40 08             	mov    0x8(%eax),%eax
  802adc:	01 c2                	add    %eax,%edx
  802ade:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae1:	8b 40 08             	mov    0x8(%eax),%eax
  802ae4:	39 c2                	cmp    %eax,%edx
  802ae6:	0f 83 8b 00 00 00    	jae    802b77 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802aec:	8b 45 08             	mov    0x8(%ebp),%eax
  802aef:	8b 50 0c             	mov    0xc(%eax),%edx
  802af2:	8b 45 08             	mov    0x8(%ebp),%eax
  802af5:	8b 40 08             	mov    0x8(%eax),%eax
  802af8:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802afa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802afd:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802b00:	39 c2                	cmp    %eax,%edx
  802b02:	73 73                	jae    802b77 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802b04:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b08:	74 06                	je     802b10 <insert_sorted_with_merge_freeList+0x20a>
  802b0a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b0e:	75 17                	jne    802b27 <insert_sorted_with_merge_freeList+0x221>
  802b10:	83 ec 04             	sub    $0x4,%esp
  802b13:	68 48 3c 80 00       	push   $0x803c48
  802b18:	68 f0 00 00 00       	push   $0xf0
  802b1d:	68 b7 3b 80 00       	push   $0x803bb7
  802b22:	e8 ff d7 ff ff       	call   800326 <_panic>
  802b27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2a:	8b 10                	mov    (%eax),%edx
  802b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b2f:	89 10                	mov    %edx,(%eax)
  802b31:	8b 45 08             	mov    0x8(%ebp),%eax
  802b34:	8b 00                	mov    (%eax),%eax
  802b36:	85 c0                	test   %eax,%eax
  802b38:	74 0b                	je     802b45 <insert_sorted_with_merge_freeList+0x23f>
  802b3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3d:	8b 00                	mov    (%eax),%eax
  802b3f:	8b 55 08             	mov    0x8(%ebp),%edx
  802b42:	89 50 04             	mov    %edx,0x4(%eax)
  802b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b48:	8b 55 08             	mov    0x8(%ebp),%edx
  802b4b:	89 10                	mov    %edx,(%eax)
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b53:	89 50 04             	mov    %edx,0x4(%eax)
  802b56:	8b 45 08             	mov    0x8(%ebp),%eax
  802b59:	8b 00                	mov    (%eax),%eax
  802b5b:	85 c0                	test   %eax,%eax
  802b5d:	75 08                	jne    802b67 <insert_sorted_with_merge_freeList+0x261>
  802b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b62:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802b67:	a1 44 41 80 00       	mov    0x804144,%eax
  802b6c:	40                   	inc    %eax
  802b6d:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802b72:	e9 64 05 00 00       	jmp    8030db <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802b77:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b7c:	8b 50 0c             	mov    0xc(%eax),%edx
  802b7f:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b84:	8b 40 08             	mov    0x8(%eax),%eax
  802b87:	01 c2                	add    %eax,%edx
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	8b 40 08             	mov    0x8(%eax),%eax
  802b8f:	39 c2                	cmp    %eax,%edx
  802b91:	0f 85 b1 00 00 00    	jne    802c48 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802b97:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802b9c:	85 c0                	test   %eax,%eax
  802b9e:	0f 84 a4 00 00 00    	je     802c48 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802ba4:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802ba9:	8b 00                	mov    (%eax),%eax
  802bab:	85 c0                	test   %eax,%eax
  802bad:	0f 85 95 00 00 00    	jne    802c48 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802bb3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bb8:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802bbe:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802bc1:	8b 55 08             	mov    0x8(%ebp),%edx
  802bc4:	8b 52 0c             	mov    0xc(%edx),%edx
  802bc7:	01 ca                	add    %ecx,%edx
  802bc9:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802bcc:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcf:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802be0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802be4:	75 17                	jne    802bfd <insert_sorted_with_merge_freeList+0x2f7>
  802be6:	83 ec 04             	sub    $0x4,%esp
  802be9:	68 94 3b 80 00       	push   $0x803b94
  802bee:	68 ff 00 00 00       	push   $0xff
  802bf3:	68 b7 3b 80 00       	push   $0x803bb7
  802bf8:	e8 29 d7 ff ff       	call   800326 <_panic>
  802bfd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c03:	8b 45 08             	mov    0x8(%ebp),%eax
  802c06:	89 10                	mov    %edx,(%eax)
  802c08:	8b 45 08             	mov    0x8(%ebp),%eax
  802c0b:	8b 00                	mov    (%eax),%eax
  802c0d:	85 c0                	test   %eax,%eax
  802c0f:	74 0d                	je     802c1e <insert_sorted_with_merge_freeList+0x318>
  802c11:	a1 48 41 80 00       	mov    0x804148,%eax
  802c16:	8b 55 08             	mov    0x8(%ebp),%edx
  802c19:	89 50 04             	mov    %edx,0x4(%eax)
  802c1c:	eb 08                	jmp    802c26 <insert_sorted_with_merge_freeList+0x320>
  802c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c21:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c26:	8b 45 08             	mov    0x8(%ebp),%eax
  802c29:	a3 48 41 80 00       	mov    %eax,0x804148
  802c2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802c31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c38:	a1 54 41 80 00       	mov    0x804154,%eax
  802c3d:	40                   	inc    %eax
  802c3e:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802c43:	e9 93 04 00 00       	jmp    8030db <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802c48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c4b:	8b 50 08             	mov    0x8(%eax),%edx
  802c4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c51:	8b 40 0c             	mov    0xc(%eax),%eax
  802c54:	01 c2                	add    %eax,%edx
  802c56:	8b 45 08             	mov    0x8(%ebp),%eax
  802c59:	8b 40 08             	mov    0x8(%eax),%eax
  802c5c:	39 c2                	cmp    %eax,%edx
  802c5e:	0f 85 ae 00 00 00    	jne    802d12 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802c64:	8b 45 08             	mov    0x8(%ebp),%eax
  802c67:	8b 50 0c             	mov    0xc(%eax),%edx
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	8b 40 08             	mov    0x8(%eax),%eax
  802c70:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802c72:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c75:	8b 00                	mov    (%eax),%eax
  802c77:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802c7a:	39 c2                	cmp    %eax,%edx
  802c7c:	0f 84 90 00 00 00    	je     802d12 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802c82:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c85:	8b 50 0c             	mov    0xc(%eax),%edx
  802c88:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8b:	8b 40 0c             	mov    0xc(%eax),%eax
  802c8e:	01 c2                	add    %eax,%edx
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802c96:	8b 45 08             	mov    0x8(%ebp),%eax
  802c99:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802ca0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802caa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cae:	75 17                	jne    802cc7 <insert_sorted_with_merge_freeList+0x3c1>
  802cb0:	83 ec 04             	sub    $0x4,%esp
  802cb3:	68 94 3b 80 00       	push   $0x803b94
  802cb8:	68 0b 01 00 00       	push   $0x10b
  802cbd:	68 b7 3b 80 00       	push   $0x803bb7
  802cc2:	e8 5f d6 ff ff       	call   800326 <_panic>
  802cc7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ccd:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd0:	89 10                	mov    %edx,(%eax)
  802cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd5:	8b 00                	mov    (%eax),%eax
  802cd7:	85 c0                	test   %eax,%eax
  802cd9:	74 0d                	je     802ce8 <insert_sorted_with_merge_freeList+0x3e2>
  802cdb:	a1 48 41 80 00       	mov    0x804148,%eax
  802ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  802ce3:	89 50 04             	mov    %edx,0x4(%eax)
  802ce6:	eb 08                	jmp    802cf0 <insert_sorted_with_merge_freeList+0x3ea>
  802ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  802ceb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802cf0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cf3:	a3 48 41 80 00       	mov    %eax,0x804148
  802cf8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cfb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d02:	a1 54 41 80 00       	mov    0x804154,%eax
  802d07:	40                   	inc    %eax
  802d08:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d0d:	e9 c9 03 00 00       	jmp    8030db <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d12:	8b 45 08             	mov    0x8(%ebp),%eax
  802d15:	8b 50 0c             	mov    0xc(%eax),%edx
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	8b 40 08             	mov    0x8(%eax),%eax
  802d1e:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802d20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d23:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d26:	39 c2                	cmp    %eax,%edx
  802d28:	0f 85 bb 00 00 00    	jne    802de9 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802d2e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d32:	0f 84 b1 00 00 00    	je     802de9 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802d38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3b:	8b 40 04             	mov    0x4(%eax),%eax
  802d3e:	85 c0                	test   %eax,%eax
  802d40:	0f 85 a3 00 00 00    	jne    802de9 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802d46:	a1 38 41 80 00       	mov    0x804138,%eax
  802d4b:	8b 55 08             	mov    0x8(%ebp),%edx
  802d4e:	8b 52 08             	mov    0x8(%edx),%edx
  802d51:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802d54:	a1 38 41 80 00       	mov    0x804138,%eax
  802d59:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802d5f:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802d62:	8b 55 08             	mov    0x8(%ebp),%edx
  802d65:	8b 52 0c             	mov    0xc(%edx),%edx
  802d68:	01 ca                	add    %ecx,%edx
  802d6a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d70:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802d77:	8b 45 08             	mov    0x8(%ebp),%eax
  802d7a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802d81:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d85:	75 17                	jne    802d9e <insert_sorted_with_merge_freeList+0x498>
  802d87:	83 ec 04             	sub    $0x4,%esp
  802d8a:	68 94 3b 80 00       	push   $0x803b94
  802d8f:	68 17 01 00 00       	push   $0x117
  802d94:	68 b7 3b 80 00       	push   $0x803bb7
  802d99:	e8 88 d5 ff ff       	call   800326 <_panic>
  802d9e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802da4:	8b 45 08             	mov    0x8(%ebp),%eax
  802da7:	89 10                	mov    %edx,(%eax)
  802da9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dac:	8b 00                	mov    (%eax),%eax
  802dae:	85 c0                	test   %eax,%eax
  802db0:	74 0d                	je     802dbf <insert_sorted_with_merge_freeList+0x4b9>
  802db2:	a1 48 41 80 00       	mov    0x804148,%eax
  802db7:	8b 55 08             	mov    0x8(%ebp),%edx
  802dba:	89 50 04             	mov    %edx,0x4(%eax)
  802dbd:	eb 08                	jmp    802dc7 <insert_sorted_with_merge_freeList+0x4c1>
  802dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dc2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dca:	a3 48 41 80 00       	mov    %eax,0x804148
  802dcf:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd9:	a1 54 41 80 00       	mov    0x804154,%eax
  802dde:	40                   	inc    %eax
  802ddf:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802de4:	e9 f2 02 00 00       	jmp    8030db <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802de9:	8b 45 08             	mov    0x8(%ebp),%eax
  802dec:	8b 50 08             	mov    0x8(%eax),%edx
  802def:	8b 45 08             	mov    0x8(%ebp),%eax
  802df2:	8b 40 0c             	mov    0xc(%eax),%eax
  802df5:	01 c2                	add    %eax,%edx
  802df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dfa:	8b 40 08             	mov    0x8(%eax),%eax
  802dfd:	39 c2                	cmp    %eax,%edx
  802dff:	0f 85 be 00 00 00    	jne    802ec3 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802e05:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e08:	8b 40 04             	mov    0x4(%eax),%eax
  802e0b:	8b 50 08             	mov    0x8(%eax),%edx
  802e0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e11:	8b 40 04             	mov    0x4(%eax),%eax
  802e14:	8b 40 0c             	mov    0xc(%eax),%eax
  802e17:	01 c2                	add    %eax,%edx
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	8b 40 08             	mov    0x8(%eax),%eax
  802e1f:	39 c2                	cmp    %eax,%edx
  802e21:	0f 84 9c 00 00 00    	je     802ec3 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802e27:	8b 45 08             	mov    0x8(%ebp),%eax
  802e2a:	8b 50 08             	mov    0x8(%eax),%edx
  802e2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e30:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802e33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e36:	8b 50 0c             	mov    0xc(%eax),%edx
  802e39:	8b 45 08             	mov    0x8(%ebp),%eax
  802e3c:	8b 40 0c             	mov    0xc(%eax),%eax
  802e3f:	01 c2                	add    %eax,%edx
  802e41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e44:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e47:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e51:	8b 45 08             	mov    0x8(%ebp),%eax
  802e54:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e5b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e5f:	75 17                	jne    802e78 <insert_sorted_with_merge_freeList+0x572>
  802e61:	83 ec 04             	sub    $0x4,%esp
  802e64:	68 94 3b 80 00       	push   $0x803b94
  802e69:	68 26 01 00 00       	push   $0x126
  802e6e:	68 b7 3b 80 00       	push   $0x803bb7
  802e73:	e8 ae d4 ff ff       	call   800326 <_panic>
  802e78:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802e81:	89 10                	mov    %edx,(%eax)
  802e83:	8b 45 08             	mov    0x8(%ebp),%eax
  802e86:	8b 00                	mov    (%eax),%eax
  802e88:	85 c0                	test   %eax,%eax
  802e8a:	74 0d                	je     802e99 <insert_sorted_with_merge_freeList+0x593>
  802e8c:	a1 48 41 80 00       	mov    0x804148,%eax
  802e91:	8b 55 08             	mov    0x8(%ebp),%edx
  802e94:	89 50 04             	mov    %edx,0x4(%eax)
  802e97:	eb 08                	jmp    802ea1 <insert_sorted_with_merge_freeList+0x59b>
  802e99:	8b 45 08             	mov    0x8(%ebp),%eax
  802e9c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ea4:	a3 48 41 80 00       	mov    %eax,0x804148
  802ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  802eac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb3:	a1 54 41 80 00       	mov    0x804154,%eax
  802eb8:	40                   	inc    %eax
  802eb9:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802ebe:	e9 18 02 00 00       	jmp    8030db <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802ec3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec6:	8b 50 0c             	mov    0xc(%eax),%edx
  802ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecc:	8b 40 08             	mov    0x8(%eax),%eax
  802ecf:	01 c2                	add    %eax,%edx
  802ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed4:	8b 40 08             	mov    0x8(%eax),%eax
  802ed7:	39 c2                	cmp    %eax,%edx
  802ed9:	0f 85 c4 01 00 00    	jne    8030a3 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802edf:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee2:	8b 50 0c             	mov    0xc(%eax),%edx
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	8b 40 08             	mov    0x8(%eax),%eax
  802eeb:	01 c2                	add    %eax,%edx
  802eed:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef0:	8b 00                	mov    (%eax),%eax
  802ef2:	8b 40 08             	mov    0x8(%eax),%eax
  802ef5:	39 c2                	cmp    %eax,%edx
  802ef7:	0f 85 a6 01 00 00    	jne    8030a3 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802efd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f01:	0f 84 9c 01 00 00    	je     8030a3 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f0d:	8b 45 08             	mov    0x8(%ebp),%eax
  802f10:	8b 40 0c             	mov    0xc(%eax),%eax
  802f13:	01 c2                	add    %eax,%edx
  802f15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f18:	8b 00                	mov    (%eax),%eax
  802f1a:	8b 40 0c             	mov    0xc(%eax),%eax
  802f1d:	01 c2                	add    %eax,%edx
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802f25:	8b 45 08             	mov    0x8(%ebp),%eax
  802f28:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802f2f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f32:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802f39:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f3d:	75 17                	jne    802f56 <insert_sorted_with_merge_freeList+0x650>
  802f3f:	83 ec 04             	sub    $0x4,%esp
  802f42:	68 94 3b 80 00       	push   $0x803b94
  802f47:	68 32 01 00 00       	push   $0x132
  802f4c:	68 b7 3b 80 00       	push   $0x803bb7
  802f51:	e8 d0 d3 ff ff       	call   800326 <_panic>
  802f56:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5f:	89 10                	mov    %edx,(%eax)
  802f61:	8b 45 08             	mov    0x8(%ebp),%eax
  802f64:	8b 00                	mov    (%eax),%eax
  802f66:	85 c0                	test   %eax,%eax
  802f68:	74 0d                	je     802f77 <insert_sorted_with_merge_freeList+0x671>
  802f6a:	a1 48 41 80 00       	mov    0x804148,%eax
  802f6f:	8b 55 08             	mov    0x8(%ebp),%edx
  802f72:	89 50 04             	mov    %edx,0x4(%eax)
  802f75:	eb 08                	jmp    802f7f <insert_sorted_with_merge_freeList+0x679>
  802f77:	8b 45 08             	mov    0x8(%ebp),%eax
  802f7a:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f82:	a3 48 41 80 00       	mov    %eax,0x804148
  802f87:	8b 45 08             	mov    0x8(%ebp),%eax
  802f8a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f91:	a1 54 41 80 00       	mov    0x804154,%eax
  802f96:	40                   	inc    %eax
  802f97:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802f9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f9f:	8b 00                	mov    (%eax),%eax
  802fa1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802fa8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fab:	8b 00                	mov    (%eax),%eax
  802fad:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802fb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fb7:	8b 00                	mov    (%eax),%eax
  802fb9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802fbc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802fc0:	75 17                	jne    802fd9 <insert_sorted_with_merge_freeList+0x6d3>
  802fc2:	83 ec 04             	sub    $0x4,%esp
  802fc5:	68 29 3c 80 00       	push   $0x803c29
  802fca:	68 36 01 00 00       	push   $0x136
  802fcf:	68 b7 3b 80 00       	push   $0x803bb7
  802fd4:	e8 4d d3 ff ff       	call   800326 <_panic>
  802fd9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fdc:	8b 00                	mov    (%eax),%eax
  802fde:	85 c0                	test   %eax,%eax
  802fe0:	74 10                	je     802ff2 <insert_sorted_with_merge_freeList+0x6ec>
  802fe2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802fe5:	8b 00                	mov    (%eax),%eax
  802fe7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802fea:	8b 52 04             	mov    0x4(%edx),%edx
  802fed:	89 50 04             	mov    %edx,0x4(%eax)
  802ff0:	eb 0b                	jmp    802ffd <insert_sorted_with_merge_freeList+0x6f7>
  802ff2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ff5:	8b 40 04             	mov    0x4(%eax),%eax
  802ff8:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ffd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803000:	8b 40 04             	mov    0x4(%eax),%eax
  803003:	85 c0                	test   %eax,%eax
  803005:	74 0f                	je     803016 <insert_sorted_with_merge_freeList+0x710>
  803007:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80300a:	8b 40 04             	mov    0x4(%eax),%eax
  80300d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803010:	8b 12                	mov    (%edx),%edx
  803012:	89 10                	mov    %edx,(%eax)
  803014:	eb 0a                	jmp    803020 <insert_sorted_with_merge_freeList+0x71a>
  803016:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803019:	8b 00                	mov    (%eax),%eax
  80301b:	a3 38 41 80 00       	mov    %eax,0x804138
  803020:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803023:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803029:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80302c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803033:	a1 44 41 80 00       	mov    0x804144,%eax
  803038:	48                   	dec    %eax
  803039:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  80303e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803042:	75 17                	jne    80305b <insert_sorted_with_merge_freeList+0x755>
  803044:	83 ec 04             	sub    $0x4,%esp
  803047:	68 94 3b 80 00       	push   $0x803b94
  80304c:	68 37 01 00 00       	push   $0x137
  803051:	68 b7 3b 80 00       	push   $0x803bb7
  803056:	e8 cb d2 ff ff       	call   800326 <_panic>
  80305b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  803061:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803064:	89 10                	mov    %edx,(%eax)
  803066:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803069:	8b 00                	mov    (%eax),%eax
  80306b:	85 c0                	test   %eax,%eax
  80306d:	74 0d                	je     80307c <insert_sorted_with_merge_freeList+0x776>
  80306f:	a1 48 41 80 00       	mov    0x804148,%eax
  803074:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803077:	89 50 04             	mov    %edx,0x4(%eax)
  80307a:	eb 08                	jmp    803084 <insert_sorted_with_merge_freeList+0x77e>
  80307c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80307f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  803084:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803087:	a3 48 41 80 00       	mov    %eax,0x804148
  80308c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80308f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803096:	a1 54 41 80 00       	mov    0x804154,%eax
  80309b:	40                   	inc    %eax
  80309c:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  8030a1:	eb 38                	jmp    8030db <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8030a3:	a1 40 41 80 00       	mov    0x804140,%eax
  8030a8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030af:	74 07                	je     8030b8 <insert_sorted_with_merge_freeList+0x7b2>
  8030b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030b4:	8b 00                	mov    (%eax),%eax
  8030b6:	eb 05                	jmp    8030bd <insert_sorted_with_merge_freeList+0x7b7>
  8030b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8030bd:	a3 40 41 80 00       	mov    %eax,0x804140
  8030c2:	a1 40 41 80 00       	mov    0x804140,%eax
  8030c7:	85 c0                	test   %eax,%eax
  8030c9:	0f 85 ef f9 ff ff    	jne    802abe <insert_sorted_with_merge_freeList+0x1b8>
  8030cf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030d3:	0f 85 e5 f9 ff ff    	jne    802abe <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  8030d9:	eb 00                	jmp    8030db <insert_sorted_with_merge_freeList+0x7d5>
  8030db:	90                   	nop
  8030dc:	c9                   	leave  
  8030dd:	c3                   	ret    

008030de <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8030de:	55                   	push   %ebp
  8030df:	89 e5                	mov    %esp,%ebp
  8030e1:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8030e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e7:	89 d0                	mov    %edx,%eax
  8030e9:	c1 e0 02             	shl    $0x2,%eax
  8030ec:	01 d0                	add    %edx,%eax
  8030ee:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030f5:	01 d0                	add    %edx,%eax
  8030f7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8030fe:	01 d0                	add    %edx,%eax
  803100:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803107:	01 d0                	add    %edx,%eax
  803109:	c1 e0 04             	shl    $0x4,%eax
  80310c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  80310f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  803116:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803119:	83 ec 0c             	sub    $0xc,%esp
  80311c:	50                   	push   %eax
  80311d:	e8 21 ec ff ff       	call   801d43 <sys_get_virtual_time>
  803122:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  803125:	eb 41                	jmp    803168 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  803127:	8d 45 e0             	lea    -0x20(%ebp),%eax
  80312a:	83 ec 0c             	sub    $0xc,%esp
  80312d:	50                   	push   %eax
  80312e:	e8 10 ec ff ff       	call   801d43 <sys_get_virtual_time>
  803133:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  803136:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803139:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80313c:	29 c2                	sub    %eax,%edx
  80313e:	89 d0                	mov    %edx,%eax
  803140:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  803143:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803146:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803149:	89 d1                	mov    %edx,%ecx
  80314b:	29 c1                	sub    %eax,%ecx
  80314d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803150:	8b 45 e0             	mov    -0x20(%ebp),%eax
  803153:	39 c2                	cmp    %eax,%edx
  803155:	0f 97 c0             	seta   %al
  803158:	0f b6 c0             	movzbl %al,%eax
  80315b:	29 c1                	sub    %eax,%ecx
  80315d:	89 c8                	mov    %ecx,%eax
  80315f:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  803162:	8b 45 d8             	mov    -0x28(%ebp),%eax
  803165:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803168:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80316e:	72 b7                	jb     803127 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803170:	90                   	nop
  803171:	c9                   	leave  
  803172:	c3                   	ret    

00803173 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  803173:	55                   	push   %ebp
  803174:	89 e5                	mov    %esp,%ebp
  803176:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803179:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803180:	eb 03                	jmp    803185 <busy_wait+0x12>
  803182:	ff 45 fc             	incl   -0x4(%ebp)
  803185:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803188:	3b 45 08             	cmp    0x8(%ebp),%eax
  80318b:	72 f5                	jb     803182 <busy_wait+0xf>
	return i;
  80318d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803190:	c9                   	leave  
  803191:	c3                   	ret    
  803192:	66 90                	xchg   %ax,%ax

00803194 <__udivdi3>:
  803194:	55                   	push   %ebp
  803195:	57                   	push   %edi
  803196:	56                   	push   %esi
  803197:	53                   	push   %ebx
  803198:	83 ec 1c             	sub    $0x1c,%esp
  80319b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80319f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8031a3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8031a7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8031ab:	89 ca                	mov    %ecx,%edx
  8031ad:	89 f8                	mov    %edi,%eax
  8031af:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8031b3:	85 f6                	test   %esi,%esi
  8031b5:	75 2d                	jne    8031e4 <__udivdi3+0x50>
  8031b7:	39 cf                	cmp    %ecx,%edi
  8031b9:	77 65                	ja     803220 <__udivdi3+0x8c>
  8031bb:	89 fd                	mov    %edi,%ebp
  8031bd:	85 ff                	test   %edi,%edi
  8031bf:	75 0b                	jne    8031cc <__udivdi3+0x38>
  8031c1:	b8 01 00 00 00       	mov    $0x1,%eax
  8031c6:	31 d2                	xor    %edx,%edx
  8031c8:	f7 f7                	div    %edi
  8031ca:	89 c5                	mov    %eax,%ebp
  8031cc:	31 d2                	xor    %edx,%edx
  8031ce:	89 c8                	mov    %ecx,%eax
  8031d0:	f7 f5                	div    %ebp
  8031d2:	89 c1                	mov    %eax,%ecx
  8031d4:	89 d8                	mov    %ebx,%eax
  8031d6:	f7 f5                	div    %ebp
  8031d8:	89 cf                	mov    %ecx,%edi
  8031da:	89 fa                	mov    %edi,%edx
  8031dc:	83 c4 1c             	add    $0x1c,%esp
  8031df:	5b                   	pop    %ebx
  8031e0:	5e                   	pop    %esi
  8031e1:	5f                   	pop    %edi
  8031e2:	5d                   	pop    %ebp
  8031e3:	c3                   	ret    
  8031e4:	39 ce                	cmp    %ecx,%esi
  8031e6:	77 28                	ja     803210 <__udivdi3+0x7c>
  8031e8:	0f bd fe             	bsr    %esi,%edi
  8031eb:	83 f7 1f             	xor    $0x1f,%edi
  8031ee:	75 40                	jne    803230 <__udivdi3+0x9c>
  8031f0:	39 ce                	cmp    %ecx,%esi
  8031f2:	72 0a                	jb     8031fe <__udivdi3+0x6a>
  8031f4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031f8:	0f 87 9e 00 00 00    	ja     80329c <__udivdi3+0x108>
  8031fe:	b8 01 00 00 00       	mov    $0x1,%eax
  803203:	89 fa                	mov    %edi,%edx
  803205:	83 c4 1c             	add    $0x1c,%esp
  803208:	5b                   	pop    %ebx
  803209:	5e                   	pop    %esi
  80320a:	5f                   	pop    %edi
  80320b:	5d                   	pop    %ebp
  80320c:	c3                   	ret    
  80320d:	8d 76 00             	lea    0x0(%esi),%esi
  803210:	31 ff                	xor    %edi,%edi
  803212:	31 c0                	xor    %eax,%eax
  803214:	89 fa                	mov    %edi,%edx
  803216:	83 c4 1c             	add    $0x1c,%esp
  803219:	5b                   	pop    %ebx
  80321a:	5e                   	pop    %esi
  80321b:	5f                   	pop    %edi
  80321c:	5d                   	pop    %ebp
  80321d:	c3                   	ret    
  80321e:	66 90                	xchg   %ax,%ax
  803220:	89 d8                	mov    %ebx,%eax
  803222:	f7 f7                	div    %edi
  803224:	31 ff                	xor    %edi,%edi
  803226:	89 fa                	mov    %edi,%edx
  803228:	83 c4 1c             	add    $0x1c,%esp
  80322b:	5b                   	pop    %ebx
  80322c:	5e                   	pop    %esi
  80322d:	5f                   	pop    %edi
  80322e:	5d                   	pop    %ebp
  80322f:	c3                   	ret    
  803230:	bd 20 00 00 00       	mov    $0x20,%ebp
  803235:	89 eb                	mov    %ebp,%ebx
  803237:	29 fb                	sub    %edi,%ebx
  803239:	89 f9                	mov    %edi,%ecx
  80323b:	d3 e6                	shl    %cl,%esi
  80323d:	89 c5                	mov    %eax,%ebp
  80323f:	88 d9                	mov    %bl,%cl
  803241:	d3 ed                	shr    %cl,%ebp
  803243:	89 e9                	mov    %ebp,%ecx
  803245:	09 f1                	or     %esi,%ecx
  803247:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80324b:	89 f9                	mov    %edi,%ecx
  80324d:	d3 e0                	shl    %cl,%eax
  80324f:	89 c5                	mov    %eax,%ebp
  803251:	89 d6                	mov    %edx,%esi
  803253:	88 d9                	mov    %bl,%cl
  803255:	d3 ee                	shr    %cl,%esi
  803257:	89 f9                	mov    %edi,%ecx
  803259:	d3 e2                	shl    %cl,%edx
  80325b:	8b 44 24 08          	mov    0x8(%esp),%eax
  80325f:	88 d9                	mov    %bl,%cl
  803261:	d3 e8                	shr    %cl,%eax
  803263:	09 c2                	or     %eax,%edx
  803265:	89 d0                	mov    %edx,%eax
  803267:	89 f2                	mov    %esi,%edx
  803269:	f7 74 24 0c          	divl   0xc(%esp)
  80326d:	89 d6                	mov    %edx,%esi
  80326f:	89 c3                	mov    %eax,%ebx
  803271:	f7 e5                	mul    %ebp
  803273:	39 d6                	cmp    %edx,%esi
  803275:	72 19                	jb     803290 <__udivdi3+0xfc>
  803277:	74 0b                	je     803284 <__udivdi3+0xf0>
  803279:	89 d8                	mov    %ebx,%eax
  80327b:	31 ff                	xor    %edi,%edi
  80327d:	e9 58 ff ff ff       	jmp    8031da <__udivdi3+0x46>
  803282:	66 90                	xchg   %ax,%ax
  803284:	8b 54 24 08          	mov    0x8(%esp),%edx
  803288:	89 f9                	mov    %edi,%ecx
  80328a:	d3 e2                	shl    %cl,%edx
  80328c:	39 c2                	cmp    %eax,%edx
  80328e:	73 e9                	jae    803279 <__udivdi3+0xe5>
  803290:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803293:	31 ff                	xor    %edi,%edi
  803295:	e9 40 ff ff ff       	jmp    8031da <__udivdi3+0x46>
  80329a:	66 90                	xchg   %ax,%ax
  80329c:	31 c0                	xor    %eax,%eax
  80329e:	e9 37 ff ff ff       	jmp    8031da <__udivdi3+0x46>
  8032a3:	90                   	nop

008032a4 <__umoddi3>:
  8032a4:	55                   	push   %ebp
  8032a5:	57                   	push   %edi
  8032a6:	56                   	push   %esi
  8032a7:	53                   	push   %ebx
  8032a8:	83 ec 1c             	sub    $0x1c,%esp
  8032ab:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8032af:	8b 74 24 34          	mov    0x34(%esp),%esi
  8032b3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8032b7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8032bb:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8032bf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8032c3:	89 f3                	mov    %esi,%ebx
  8032c5:	89 fa                	mov    %edi,%edx
  8032c7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8032cb:	89 34 24             	mov    %esi,(%esp)
  8032ce:	85 c0                	test   %eax,%eax
  8032d0:	75 1a                	jne    8032ec <__umoddi3+0x48>
  8032d2:	39 f7                	cmp    %esi,%edi
  8032d4:	0f 86 a2 00 00 00    	jbe    80337c <__umoddi3+0xd8>
  8032da:	89 c8                	mov    %ecx,%eax
  8032dc:	89 f2                	mov    %esi,%edx
  8032de:	f7 f7                	div    %edi
  8032e0:	89 d0                	mov    %edx,%eax
  8032e2:	31 d2                	xor    %edx,%edx
  8032e4:	83 c4 1c             	add    $0x1c,%esp
  8032e7:	5b                   	pop    %ebx
  8032e8:	5e                   	pop    %esi
  8032e9:	5f                   	pop    %edi
  8032ea:	5d                   	pop    %ebp
  8032eb:	c3                   	ret    
  8032ec:	39 f0                	cmp    %esi,%eax
  8032ee:	0f 87 ac 00 00 00    	ja     8033a0 <__umoddi3+0xfc>
  8032f4:	0f bd e8             	bsr    %eax,%ebp
  8032f7:	83 f5 1f             	xor    $0x1f,%ebp
  8032fa:	0f 84 ac 00 00 00    	je     8033ac <__umoddi3+0x108>
  803300:	bf 20 00 00 00       	mov    $0x20,%edi
  803305:	29 ef                	sub    %ebp,%edi
  803307:	89 fe                	mov    %edi,%esi
  803309:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80330d:	89 e9                	mov    %ebp,%ecx
  80330f:	d3 e0                	shl    %cl,%eax
  803311:	89 d7                	mov    %edx,%edi
  803313:	89 f1                	mov    %esi,%ecx
  803315:	d3 ef                	shr    %cl,%edi
  803317:	09 c7                	or     %eax,%edi
  803319:	89 e9                	mov    %ebp,%ecx
  80331b:	d3 e2                	shl    %cl,%edx
  80331d:	89 14 24             	mov    %edx,(%esp)
  803320:	89 d8                	mov    %ebx,%eax
  803322:	d3 e0                	shl    %cl,%eax
  803324:	89 c2                	mov    %eax,%edx
  803326:	8b 44 24 08          	mov    0x8(%esp),%eax
  80332a:	d3 e0                	shl    %cl,%eax
  80332c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803330:	8b 44 24 08          	mov    0x8(%esp),%eax
  803334:	89 f1                	mov    %esi,%ecx
  803336:	d3 e8                	shr    %cl,%eax
  803338:	09 d0                	or     %edx,%eax
  80333a:	d3 eb                	shr    %cl,%ebx
  80333c:	89 da                	mov    %ebx,%edx
  80333e:	f7 f7                	div    %edi
  803340:	89 d3                	mov    %edx,%ebx
  803342:	f7 24 24             	mull   (%esp)
  803345:	89 c6                	mov    %eax,%esi
  803347:	89 d1                	mov    %edx,%ecx
  803349:	39 d3                	cmp    %edx,%ebx
  80334b:	0f 82 87 00 00 00    	jb     8033d8 <__umoddi3+0x134>
  803351:	0f 84 91 00 00 00    	je     8033e8 <__umoddi3+0x144>
  803357:	8b 54 24 04          	mov    0x4(%esp),%edx
  80335b:	29 f2                	sub    %esi,%edx
  80335d:	19 cb                	sbb    %ecx,%ebx
  80335f:	89 d8                	mov    %ebx,%eax
  803361:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803365:	d3 e0                	shl    %cl,%eax
  803367:	89 e9                	mov    %ebp,%ecx
  803369:	d3 ea                	shr    %cl,%edx
  80336b:	09 d0                	or     %edx,%eax
  80336d:	89 e9                	mov    %ebp,%ecx
  80336f:	d3 eb                	shr    %cl,%ebx
  803371:	89 da                	mov    %ebx,%edx
  803373:	83 c4 1c             	add    $0x1c,%esp
  803376:	5b                   	pop    %ebx
  803377:	5e                   	pop    %esi
  803378:	5f                   	pop    %edi
  803379:	5d                   	pop    %ebp
  80337a:	c3                   	ret    
  80337b:	90                   	nop
  80337c:	89 fd                	mov    %edi,%ebp
  80337e:	85 ff                	test   %edi,%edi
  803380:	75 0b                	jne    80338d <__umoddi3+0xe9>
  803382:	b8 01 00 00 00       	mov    $0x1,%eax
  803387:	31 d2                	xor    %edx,%edx
  803389:	f7 f7                	div    %edi
  80338b:	89 c5                	mov    %eax,%ebp
  80338d:	89 f0                	mov    %esi,%eax
  80338f:	31 d2                	xor    %edx,%edx
  803391:	f7 f5                	div    %ebp
  803393:	89 c8                	mov    %ecx,%eax
  803395:	f7 f5                	div    %ebp
  803397:	89 d0                	mov    %edx,%eax
  803399:	e9 44 ff ff ff       	jmp    8032e2 <__umoddi3+0x3e>
  80339e:	66 90                	xchg   %ax,%ax
  8033a0:	89 c8                	mov    %ecx,%eax
  8033a2:	89 f2                	mov    %esi,%edx
  8033a4:	83 c4 1c             	add    $0x1c,%esp
  8033a7:	5b                   	pop    %ebx
  8033a8:	5e                   	pop    %esi
  8033a9:	5f                   	pop    %edi
  8033aa:	5d                   	pop    %ebp
  8033ab:	c3                   	ret    
  8033ac:	3b 04 24             	cmp    (%esp),%eax
  8033af:	72 06                	jb     8033b7 <__umoddi3+0x113>
  8033b1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8033b5:	77 0f                	ja     8033c6 <__umoddi3+0x122>
  8033b7:	89 f2                	mov    %esi,%edx
  8033b9:	29 f9                	sub    %edi,%ecx
  8033bb:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8033bf:	89 14 24             	mov    %edx,(%esp)
  8033c2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8033c6:	8b 44 24 04          	mov    0x4(%esp),%eax
  8033ca:	8b 14 24             	mov    (%esp),%edx
  8033cd:	83 c4 1c             	add    $0x1c,%esp
  8033d0:	5b                   	pop    %ebx
  8033d1:	5e                   	pop    %esi
  8033d2:	5f                   	pop    %edi
  8033d3:	5d                   	pop    %ebp
  8033d4:	c3                   	ret    
  8033d5:	8d 76 00             	lea    0x0(%esi),%esi
  8033d8:	2b 04 24             	sub    (%esp),%eax
  8033db:	19 fa                	sbb    %edi,%edx
  8033dd:	89 d1                	mov    %edx,%ecx
  8033df:	89 c6                	mov    %eax,%esi
  8033e1:	e9 71 ff ff ff       	jmp    803357 <__umoddi3+0xb3>
  8033e6:	66 90                	xchg   %ax,%ax
  8033e8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8033ec:	72 ea                	jb     8033d8 <__umoddi3+0x134>
  8033ee:	89 d9                	mov    %ebx,%ecx
  8033f0:	e9 62 ff ff ff       	jmp    803357 <__umoddi3+0xb3>
