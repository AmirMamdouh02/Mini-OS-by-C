
obj/user/MidTermEx_Master:     file format elf32-i386


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
  800031:	e8 14 02 00 00       	call   80024a <libmain>
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
  800045:	68 c0 33 80 00       	push   $0x8033c0
  80004a:	e8 25 15 00 00       	call   801574 <smalloc>
  80004f:	83 c4 10             	add    $0x10,%esp
  800052:	89 45 f4             	mov    %eax,-0xc(%ebp)
	*X = 5 ;
  800055:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800058:	c7 00 05 00 00 00    	movl   $0x5,(%eax)

	/*[2] SPECIFY WHETHER TO USE SEMAPHORE OR NOT*/
	cprintf("Do you want to use semaphore (y/n)? ") ;
  80005e:	83 ec 0c             	sub    $0xc,%esp
  800061:	68 c4 33 80 00       	push   $0x8033c4
  800066:	e8 ef 03 00 00       	call   80045a <cprintf>
  80006b:	83 c4 10             	add    $0x10,%esp
	char select = getchar() ;
  80006e:	e8 7f 01 00 00       	call   8001f2 <getchar>
  800073:	88 45 f3             	mov    %al,-0xd(%ebp)
	cputchar(select);
  800076:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
  80007a:	83 ec 0c             	sub    $0xc,%esp
  80007d:	50                   	push   %eax
  80007e:	e8 27 01 00 00       	call   8001aa <cputchar>
  800083:	83 c4 10             	add    $0x10,%esp
	cputchar('\n');
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	6a 0a                	push   $0xa
  80008b:	e8 1a 01 00 00       	call   8001aa <cputchar>
  800090:	83 c4 10             	add    $0x10,%esp

	/*[3] SHARE THIS SELECTION WITH OTHER PROCESSES*/
	int *useSem = smalloc("useSem", sizeof(int) , 0) ;
  800093:	83 ec 04             	sub    $0x4,%esp
  800096:	6a 00                	push   $0x0
  800098:	6a 04                	push   $0x4
  80009a:	68 e9 33 80 00       	push   $0x8033e9
  80009f:	e8 d0 14 00 00       	call   801574 <smalloc>
  8000a4:	83 c4 10             	add    $0x10,%esp
  8000a7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	*useSem = 0 ;
  8000aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	if (select == 'Y' || select == 'y')
  8000b3:	80 7d f3 59          	cmpb   $0x59,-0xd(%ebp)
  8000b7:	74 06                	je     8000bf <_main+0x87>
  8000b9:	80 7d f3 79          	cmpb   $0x79,-0xd(%ebp)
  8000bd:	75 09                	jne    8000c8 <_main+0x90>
		*useSem = 1 ;
  8000bf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000c2:	c7 00 01 00 00 00    	movl   $0x1,(%eax)

	if (*useSem == 1)
  8000c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cb:	8b 00                	mov    (%eax),%eax
  8000cd:	83 f8 01             	cmp    $0x1,%eax
  8000d0:	75 12                	jne    8000e4 <_main+0xac>
	{
		sys_createSemaphore("T", 0);
  8000d2:	83 ec 08             	sub    $0x8,%esp
  8000d5:	6a 00                	push   $0x0
  8000d7:	68 f0 33 80 00       	push   $0x8033f0
  8000dc:	e8 17 19 00 00       	call   8019f8 <sys_createSemaphore>
  8000e1:	83 c4 10             	add    $0x10,%esp
	}

	/*[4] CREATE AND RUN ProcessA & ProcessB*/

	//Create the check-finishing counter
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8000e4:	83 ec 04             	sub    $0x4,%esp
  8000e7:	6a 01                	push   $0x1
  8000e9:	6a 04                	push   $0x4
  8000eb:	68 f2 33 80 00       	push   $0x8033f2
  8000f0:	e8 7f 14 00 00       	call   801574 <smalloc>
  8000f5:	83 c4 10             	add    $0x10,%esp
  8000f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
	*numOfFinished = 0 ;
  8000fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000fe:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	//Create the 2 processes
	int32 envIdProcessA = sys_create_env("midterm_a", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800104:	a1 20 40 80 00       	mov    0x804020,%eax
  800109:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80010f:	a1 20 40 80 00       	mov    0x804020,%eax
  800114:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80011a:	89 c1                	mov    %eax,%ecx
  80011c:	a1 20 40 80 00       	mov    0x804020,%eax
  800121:	8b 40 74             	mov    0x74(%eax),%eax
  800124:	52                   	push   %edx
  800125:	51                   	push   %ecx
  800126:	50                   	push   %eax
  800127:	68 00 34 80 00       	push   $0x803400
  80012c:	e8 d8 19 00 00       	call   801b09 <sys_create_env>
  800131:	83 c4 10             	add    $0x10,%esp
  800134:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int32 envIdProcessB = sys_create_env("midterm_b", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800137:	a1 20 40 80 00       	mov    0x804020,%eax
  80013c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800142:	a1 20 40 80 00       	mov    0x804020,%eax
  800147:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80014d:	89 c1                	mov    %eax,%ecx
  80014f:	a1 20 40 80 00       	mov    0x804020,%eax
  800154:	8b 40 74             	mov    0x74(%eax),%eax
  800157:	52                   	push   %edx
  800158:	51                   	push   %ecx
  800159:	50                   	push   %eax
  80015a:	68 0a 34 80 00       	push   $0x80340a
  80015f:	e8 a5 19 00 00       	call   801b09 <sys_create_env>
  800164:	83 c4 10             	add    $0x10,%esp
  800167:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//Run the 2 processes
	sys_run_env(envIdProcessA);
  80016a:	83 ec 0c             	sub    $0xc,%esp
  80016d:	ff 75 e4             	pushl  -0x1c(%ebp)
  800170:	e8 b2 19 00 00       	call   801b27 <sys_run_env>
  800175:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdProcessB);
  800178:	83 ec 0c             	sub    $0xc,%esp
  80017b:	ff 75 e0             	pushl  -0x20(%ebp)
  80017e:	e8 a4 19 00 00       	call   801b27 <sys_run_env>
  800183:	83 c4 10             	add    $0x10,%esp

	/*[5] BUSY-WAIT TILL FINISHING BOTH PROCESSES*/
	while (*numOfFinished != 2) ;
  800186:	90                   	nop
  800187:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80018a:	8b 00                	mov    (%eax),%eax
  80018c:	83 f8 02             	cmp    $0x2,%eax
  80018f:	75 f6                	jne    800187 <_main+0x14f>

	/*[6] PRINT X*/
	cprintf("Final value of X = %d\n", *X);
  800191:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800194:	8b 00                	mov    (%eax),%eax
  800196:	83 ec 08             	sub    $0x8,%esp
  800199:	50                   	push   %eax
  80019a:	68 14 34 80 00       	push   $0x803414
  80019f:	e8 b6 02 00 00       	call   80045a <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp

	return;
  8001a7:	90                   	nop
}
  8001a8:	c9                   	leave  
  8001a9:	c3                   	ret    

008001aa <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8001aa:	55                   	push   %ebp
  8001ab:	89 e5                	mov    %esp,%ebp
  8001ad:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8001b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8001b3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001b6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001ba:	83 ec 0c             	sub    $0xc,%esp
  8001bd:	50                   	push   %eax
  8001be:	e8 f5 17 00 00       	call   8019b8 <sys_cputc>
  8001c3:	83 c4 10             	add    $0x10,%esp
}
  8001c6:	90                   	nop
  8001c7:	c9                   	leave  
  8001c8:	c3                   	ret    

008001c9 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8001c9:	55                   	push   %ebp
  8001ca:	89 e5                	mov    %esp,%ebp
  8001cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8001cf:	e8 b0 17 00 00       	call   801984 <sys_disable_interrupt>
	char c = ch;
  8001d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d7:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8001da:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8001de:	83 ec 0c             	sub    $0xc,%esp
  8001e1:	50                   	push   %eax
  8001e2:	e8 d1 17 00 00       	call   8019b8 <sys_cputc>
  8001e7:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8001ea:	e8 af 17 00 00       	call   80199e <sys_enable_interrupt>
}
  8001ef:	90                   	nop
  8001f0:	c9                   	leave  
  8001f1:	c3                   	ret    

008001f2 <getchar>:

int
getchar(void)
{
  8001f2:	55                   	push   %ebp
  8001f3:	89 e5                	mov    %esp,%ebp
  8001f5:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  8001f8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8001ff:	eb 08                	jmp    800209 <getchar+0x17>
	{
		c = sys_cgetc();
  800201:	e8 f9 15 00 00       	call   8017ff <sys_cgetc>
  800206:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800209:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80020d:	74 f2                	je     800201 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80020f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800212:	c9                   	leave  
  800213:	c3                   	ret    

00800214 <atomic_getchar>:

int
atomic_getchar(void)
{
  800214:	55                   	push   %ebp
  800215:	89 e5                	mov    %esp,%ebp
  800217:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80021a:	e8 65 17 00 00       	call   801984 <sys_disable_interrupt>
	int c=0;
  80021f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800226:	eb 08                	jmp    800230 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800228:	e8 d2 15 00 00       	call   8017ff <sys_cgetc>
  80022d:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800230:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800234:	74 f2                	je     800228 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800236:	e8 63 17 00 00       	call   80199e <sys_enable_interrupt>
	return c;
  80023b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80023e:	c9                   	leave  
  80023f:	c3                   	ret    

00800240 <iscons>:

int iscons(int fdnum)
{
  800240:	55                   	push   %ebp
  800241:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  800243:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800248:	5d                   	pop    %ebp
  800249:	c3                   	ret    

0080024a <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80024a:	55                   	push   %ebp
  80024b:	89 e5                	mov    %esp,%ebp
  80024d:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800250:	e8 22 19 00 00       	call   801b77 <sys_getenvindex>
  800255:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800258:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80025b:	89 d0                	mov    %edx,%eax
  80025d:	c1 e0 03             	shl    $0x3,%eax
  800260:	01 d0                	add    %edx,%eax
  800262:	01 c0                	add    %eax,%eax
  800264:	01 d0                	add    %edx,%eax
  800266:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80026d:	01 d0                	add    %edx,%eax
  80026f:	c1 e0 04             	shl    $0x4,%eax
  800272:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800277:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80027c:	a1 20 40 80 00       	mov    0x804020,%eax
  800281:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800287:	84 c0                	test   %al,%al
  800289:	74 0f                	je     80029a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80028b:	a1 20 40 80 00       	mov    0x804020,%eax
  800290:	05 5c 05 00 00       	add    $0x55c,%eax
  800295:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80029a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80029e:	7e 0a                	jle    8002aa <libmain+0x60>
		binaryname = argv[0];
  8002a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002a3:	8b 00                	mov    (%eax),%eax
  8002a5:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8002aa:	83 ec 08             	sub    $0x8,%esp
  8002ad:	ff 75 0c             	pushl  0xc(%ebp)
  8002b0:	ff 75 08             	pushl  0x8(%ebp)
  8002b3:	e8 80 fd ff ff       	call   800038 <_main>
  8002b8:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8002bb:	e8 c4 16 00 00       	call   801984 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002c0:	83 ec 0c             	sub    $0xc,%esp
  8002c3:	68 44 34 80 00       	push   $0x803444
  8002c8:	e8 8d 01 00 00       	call   80045a <cprintf>
  8002cd:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002d0:	a1 20 40 80 00       	mov    0x804020,%eax
  8002d5:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002db:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e0:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002e6:	83 ec 04             	sub    $0x4,%esp
  8002e9:	52                   	push   %edx
  8002ea:	50                   	push   %eax
  8002eb:	68 6c 34 80 00       	push   $0x80346c
  8002f0:	e8 65 01 00 00       	call   80045a <cprintf>
  8002f5:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002f8:	a1 20 40 80 00       	mov    0x804020,%eax
  8002fd:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800303:	a1 20 40 80 00       	mov    0x804020,%eax
  800308:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80030e:	a1 20 40 80 00       	mov    0x804020,%eax
  800313:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800319:	51                   	push   %ecx
  80031a:	52                   	push   %edx
  80031b:	50                   	push   %eax
  80031c:	68 94 34 80 00       	push   $0x803494
  800321:	e8 34 01 00 00       	call   80045a <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800329:	a1 20 40 80 00       	mov    0x804020,%eax
  80032e:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	50                   	push   %eax
  800338:	68 ec 34 80 00       	push   $0x8034ec
  80033d:	e8 18 01 00 00       	call   80045a <cprintf>
  800342:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800345:	83 ec 0c             	sub    $0xc,%esp
  800348:	68 44 34 80 00       	push   $0x803444
  80034d:	e8 08 01 00 00       	call   80045a <cprintf>
  800352:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800355:	e8 44 16 00 00       	call   80199e <sys_enable_interrupt>

	// exit gracefully
	exit();
  80035a:	e8 19 00 00 00       	call   800378 <exit>
}
  80035f:	90                   	nop
  800360:	c9                   	leave  
  800361:	c3                   	ret    

00800362 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800362:	55                   	push   %ebp
  800363:	89 e5                	mov    %esp,%ebp
  800365:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800368:	83 ec 0c             	sub    $0xc,%esp
  80036b:	6a 00                	push   $0x0
  80036d:	e8 d1 17 00 00       	call   801b43 <sys_destroy_env>
  800372:	83 c4 10             	add    $0x10,%esp
}
  800375:	90                   	nop
  800376:	c9                   	leave  
  800377:	c3                   	ret    

00800378 <exit>:

void
exit(void)
{
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80037e:	e8 26 18 00 00       	call   801ba9 <sys_exit_env>
}
  800383:	90                   	nop
  800384:	c9                   	leave  
  800385:	c3                   	ret    

00800386 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800386:	55                   	push   %ebp
  800387:	89 e5                	mov    %esp,%ebp
  800389:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80038c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80038f:	8b 00                	mov    (%eax),%eax
  800391:	8d 48 01             	lea    0x1(%eax),%ecx
  800394:	8b 55 0c             	mov    0xc(%ebp),%edx
  800397:	89 0a                	mov    %ecx,(%edx)
  800399:	8b 55 08             	mov    0x8(%ebp),%edx
  80039c:	88 d1                	mov    %dl,%cl
  80039e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003a1:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8003a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a8:	8b 00                	mov    (%eax),%eax
  8003aa:	3d ff 00 00 00       	cmp    $0xff,%eax
  8003af:	75 2c                	jne    8003dd <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8003b1:	a0 24 40 80 00       	mov    0x804024,%al
  8003b6:	0f b6 c0             	movzbl %al,%eax
  8003b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bc:	8b 12                	mov    (%edx),%edx
  8003be:	89 d1                	mov    %edx,%ecx
  8003c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003c3:	83 c2 08             	add    $0x8,%edx
  8003c6:	83 ec 04             	sub    $0x4,%esp
  8003c9:	50                   	push   %eax
  8003ca:	51                   	push   %ecx
  8003cb:	52                   	push   %edx
  8003cc:	e8 05 14 00 00       	call   8017d6 <sys_cputs>
  8003d1:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8003d4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8003dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e0:	8b 40 04             	mov    0x4(%eax),%eax
  8003e3:	8d 50 01             	lea    0x1(%eax),%edx
  8003e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003e9:	89 50 04             	mov    %edx,0x4(%eax)
}
  8003ec:	90                   	nop
  8003ed:	c9                   	leave  
  8003ee:	c3                   	ret    

008003ef <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8003ef:	55                   	push   %ebp
  8003f0:	89 e5                	mov    %esp,%ebp
  8003f2:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8003f8:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8003ff:	00 00 00 
	b.cnt = 0;
  800402:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800409:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80040c:	ff 75 0c             	pushl  0xc(%ebp)
  80040f:	ff 75 08             	pushl  0x8(%ebp)
  800412:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800418:	50                   	push   %eax
  800419:	68 86 03 80 00       	push   $0x800386
  80041e:	e8 11 02 00 00       	call   800634 <vprintfmt>
  800423:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800426:	a0 24 40 80 00       	mov    0x804024,%al
  80042b:	0f b6 c0             	movzbl %al,%eax
  80042e:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800434:	83 ec 04             	sub    $0x4,%esp
  800437:	50                   	push   %eax
  800438:	52                   	push   %edx
  800439:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80043f:	83 c0 08             	add    $0x8,%eax
  800442:	50                   	push   %eax
  800443:	e8 8e 13 00 00       	call   8017d6 <sys_cputs>
  800448:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80044b:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800452:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800458:	c9                   	leave  
  800459:	c3                   	ret    

0080045a <cprintf>:

int cprintf(const char *fmt, ...) {
  80045a:	55                   	push   %ebp
  80045b:	89 e5                	mov    %esp,%ebp
  80045d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800460:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800467:	8d 45 0c             	lea    0xc(%ebp),%eax
  80046a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80046d:	8b 45 08             	mov    0x8(%ebp),%eax
  800470:	83 ec 08             	sub    $0x8,%esp
  800473:	ff 75 f4             	pushl  -0xc(%ebp)
  800476:	50                   	push   %eax
  800477:	e8 73 ff ff ff       	call   8003ef <vcprintf>
  80047c:	83 c4 10             	add    $0x10,%esp
  80047f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800482:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800485:	c9                   	leave  
  800486:	c3                   	ret    

00800487 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800487:	55                   	push   %ebp
  800488:	89 e5                	mov    %esp,%ebp
  80048a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80048d:	e8 f2 14 00 00       	call   801984 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800492:	8d 45 0c             	lea    0xc(%ebp),%eax
  800495:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	83 ec 08             	sub    $0x8,%esp
  80049e:	ff 75 f4             	pushl  -0xc(%ebp)
  8004a1:	50                   	push   %eax
  8004a2:	e8 48 ff ff ff       	call   8003ef <vcprintf>
  8004a7:	83 c4 10             	add    $0x10,%esp
  8004aa:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8004ad:	e8 ec 14 00 00       	call   80199e <sys_enable_interrupt>
	return cnt;
  8004b2:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8004b5:	c9                   	leave  
  8004b6:	c3                   	ret    

008004b7 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8004b7:	55                   	push   %ebp
  8004b8:	89 e5                	mov    %esp,%ebp
  8004ba:	53                   	push   %ebx
  8004bb:	83 ec 14             	sub    $0x14,%esp
  8004be:	8b 45 10             	mov    0x10(%ebp),%eax
  8004c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8004c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8004c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8004ca:	8b 45 18             	mov    0x18(%ebp),%eax
  8004cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d2:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004d5:	77 55                	ja     80052c <printnum+0x75>
  8004d7:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8004da:	72 05                	jb     8004e1 <printnum+0x2a>
  8004dc:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8004df:	77 4b                	ja     80052c <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8004e1:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e4:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8004e7:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ea:	ba 00 00 00 00       	mov    $0x0,%edx
  8004ef:	52                   	push   %edx
  8004f0:	50                   	push   %eax
  8004f1:	ff 75 f4             	pushl  -0xc(%ebp)
  8004f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8004f7:	e8 44 2c 00 00       	call   803140 <__udivdi3>
  8004fc:	83 c4 10             	add    $0x10,%esp
  8004ff:	83 ec 04             	sub    $0x4,%esp
  800502:	ff 75 20             	pushl  0x20(%ebp)
  800505:	53                   	push   %ebx
  800506:	ff 75 18             	pushl  0x18(%ebp)
  800509:	52                   	push   %edx
  80050a:	50                   	push   %eax
  80050b:	ff 75 0c             	pushl  0xc(%ebp)
  80050e:	ff 75 08             	pushl  0x8(%ebp)
  800511:	e8 a1 ff ff ff       	call   8004b7 <printnum>
  800516:	83 c4 20             	add    $0x20,%esp
  800519:	eb 1a                	jmp    800535 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80051b:	83 ec 08             	sub    $0x8,%esp
  80051e:	ff 75 0c             	pushl  0xc(%ebp)
  800521:	ff 75 20             	pushl  0x20(%ebp)
  800524:	8b 45 08             	mov    0x8(%ebp),%eax
  800527:	ff d0                	call   *%eax
  800529:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80052c:	ff 4d 1c             	decl   0x1c(%ebp)
  80052f:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800533:	7f e6                	jg     80051b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800535:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800538:	bb 00 00 00 00       	mov    $0x0,%ebx
  80053d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800540:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800543:	53                   	push   %ebx
  800544:	51                   	push   %ecx
  800545:	52                   	push   %edx
  800546:	50                   	push   %eax
  800547:	e8 04 2d 00 00       	call   803250 <__umoddi3>
  80054c:	83 c4 10             	add    $0x10,%esp
  80054f:	05 14 37 80 00       	add    $0x803714,%eax
  800554:	8a 00                	mov    (%eax),%al
  800556:	0f be c0             	movsbl %al,%eax
  800559:	83 ec 08             	sub    $0x8,%esp
  80055c:	ff 75 0c             	pushl  0xc(%ebp)
  80055f:	50                   	push   %eax
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	ff d0                	call   *%eax
  800565:	83 c4 10             	add    $0x10,%esp
}
  800568:	90                   	nop
  800569:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80056c:	c9                   	leave  
  80056d:	c3                   	ret    

0080056e <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80056e:	55                   	push   %ebp
  80056f:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800571:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800575:	7e 1c                	jle    800593 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800577:	8b 45 08             	mov    0x8(%ebp),%eax
  80057a:	8b 00                	mov    (%eax),%eax
  80057c:	8d 50 08             	lea    0x8(%eax),%edx
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	89 10                	mov    %edx,(%eax)
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	83 e8 08             	sub    $0x8,%eax
  80058c:	8b 50 04             	mov    0x4(%eax),%edx
  80058f:	8b 00                	mov    (%eax),%eax
  800591:	eb 40                	jmp    8005d3 <getuint+0x65>
	else if (lflag)
  800593:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800597:	74 1e                	je     8005b7 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800599:	8b 45 08             	mov    0x8(%ebp),%eax
  80059c:	8b 00                	mov    (%eax),%eax
  80059e:	8d 50 04             	lea    0x4(%eax),%edx
  8005a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a4:	89 10                	mov    %edx,(%eax)
  8005a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a9:	8b 00                	mov    (%eax),%eax
  8005ab:	83 e8 04             	sub    $0x4,%eax
  8005ae:	8b 00                	mov    (%eax),%eax
  8005b0:	ba 00 00 00 00       	mov    $0x0,%edx
  8005b5:	eb 1c                	jmp    8005d3 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8005b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ba:	8b 00                	mov    (%eax),%eax
  8005bc:	8d 50 04             	lea    0x4(%eax),%edx
  8005bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c2:	89 10                	mov    %edx,(%eax)
  8005c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	83 e8 04             	sub    $0x4,%eax
  8005cc:	8b 00                	mov    (%eax),%eax
  8005ce:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8005d3:	5d                   	pop    %ebp
  8005d4:	c3                   	ret    

008005d5 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8005d5:	55                   	push   %ebp
  8005d6:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8005d8:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005dc:	7e 1c                	jle    8005fa <getint+0x25>
		return va_arg(*ap, long long);
  8005de:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e1:	8b 00                	mov    (%eax),%eax
  8005e3:	8d 50 08             	lea    0x8(%eax),%edx
  8005e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e9:	89 10                	mov    %edx,(%eax)
  8005eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ee:	8b 00                	mov    (%eax),%eax
  8005f0:	83 e8 08             	sub    $0x8,%eax
  8005f3:	8b 50 04             	mov    0x4(%eax),%edx
  8005f6:	8b 00                	mov    (%eax),%eax
  8005f8:	eb 38                	jmp    800632 <getint+0x5d>
	else if (lflag)
  8005fa:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005fe:	74 1a                	je     80061a <getint+0x45>
		return va_arg(*ap, long);
  800600:	8b 45 08             	mov    0x8(%ebp),%eax
  800603:	8b 00                	mov    (%eax),%eax
  800605:	8d 50 04             	lea    0x4(%eax),%edx
  800608:	8b 45 08             	mov    0x8(%ebp),%eax
  80060b:	89 10                	mov    %edx,(%eax)
  80060d:	8b 45 08             	mov    0x8(%ebp),%eax
  800610:	8b 00                	mov    (%eax),%eax
  800612:	83 e8 04             	sub    $0x4,%eax
  800615:	8b 00                	mov    (%eax),%eax
  800617:	99                   	cltd   
  800618:	eb 18                	jmp    800632 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80061a:	8b 45 08             	mov    0x8(%ebp),%eax
  80061d:	8b 00                	mov    (%eax),%eax
  80061f:	8d 50 04             	lea    0x4(%eax),%edx
  800622:	8b 45 08             	mov    0x8(%ebp),%eax
  800625:	89 10                	mov    %edx,(%eax)
  800627:	8b 45 08             	mov    0x8(%ebp),%eax
  80062a:	8b 00                	mov    (%eax),%eax
  80062c:	83 e8 04             	sub    $0x4,%eax
  80062f:	8b 00                	mov    (%eax),%eax
  800631:	99                   	cltd   
}
  800632:	5d                   	pop    %ebp
  800633:	c3                   	ret    

00800634 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800634:	55                   	push   %ebp
  800635:	89 e5                	mov    %esp,%ebp
  800637:	56                   	push   %esi
  800638:	53                   	push   %ebx
  800639:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80063c:	eb 17                	jmp    800655 <vprintfmt+0x21>
			if (ch == '\0')
  80063e:	85 db                	test   %ebx,%ebx
  800640:	0f 84 af 03 00 00    	je     8009f5 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800646:	83 ec 08             	sub    $0x8,%esp
  800649:	ff 75 0c             	pushl  0xc(%ebp)
  80064c:	53                   	push   %ebx
  80064d:	8b 45 08             	mov    0x8(%ebp),%eax
  800650:	ff d0                	call   *%eax
  800652:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800655:	8b 45 10             	mov    0x10(%ebp),%eax
  800658:	8d 50 01             	lea    0x1(%eax),%edx
  80065b:	89 55 10             	mov    %edx,0x10(%ebp)
  80065e:	8a 00                	mov    (%eax),%al
  800660:	0f b6 d8             	movzbl %al,%ebx
  800663:	83 fb 25             	cmp    $0x25,%ebx
  800666:	75 d6                	jne    80063e <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800668:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80066c:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800673:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80067a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800681:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800688:	8b 45 10             	mov    0x10(%ebp),%eax
  80068b:	8d 50 01             	lea    0x1(%eax),%edx
  80068e:	89 55 10             	mov    %edx,0x10(%ebp)
  800691:	8a 00                	mov    (%eax),%al
  800693:	0f b6 d8             	movzbl %al,%ebx
  800696:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800699:	83 f8 55             	cmp    $0x55,%eax
  80069c:	0f 87 2b 03 00 00    	ja     8009cd <vprintfmt+0x399>
  8006a2:	8b 04 85 38 37 80 00 	mov    0x803738(,%eax,4),%eax
  8006a9:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8006ab:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8006af:	eb d7                	jmp    800688 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8006b1:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8006b5:	eb d1                	jmp    800688 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8006be:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006c1:	89 d0                	mov    %edx,%eax
  8006c3:	c1 e0 02             	shl    $0x2,%eax
  8006c6:	01 d0                	add    %edx,%eax
  8006c8:	01 c0                	add    %eax,%eax
  8006ca:	01 d8                	add    %ebx,%eax
  8006cc:	83 e8 30             	sub    $0x30,%eax
  8006cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8006d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d5:	8a 00                	mov    (%eax),%al
  8006d7:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8006da:	83 fb 2f             	cmp    $0x2f,%ebx
  8006dd:	7e 3e                	jle    80071d <vprintfmt+0xe9>
  8006df:	83 fb 39             	cmp    $0x39,%ebx
  8006e2:	7f 39                	jg     80071d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8006e4:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8006e7:	eb d5                	jmp    8006be <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8006e9:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ec:	83 c0 04             	add    $0x4,%eax
  8006ef:	89 45 14             	mov    %eax,0x14(%ebp)
  8006f2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006f5:	83 e8 04             	sub    $0x4,%eax
  8006f8:	8b 00                	mov    (%eax),%eax
  8006fa:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8006fd:	eb 1f                	jmp    80071e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8006ff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800703:	79 83                	jns    800688 <vprintfmt+0x54>
				width = 0;
  800705:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80070c:	e9 77 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800711:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800718:	e9 6b ff ff ff       	jmp    800688 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80071d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80071e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800722:	0f 89 60 ff ff ff    	jns    800688 <vprintfmt+0x54>
				width = precision, precision = -1;
  800728:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80072b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80072e:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800735:	e9 4e ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80073a:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80073d:	e9 46 ff ff ff       	jmp    800688 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800742:	8b 45 14             	mov    0x14(%ebp),%eax
  800745:	83 c0 04             	add    $0x4,%eax
  800748:	89 45 14             	mov    %eax,0x14(%ebp)
  80074b:	8b 45 14             	mov    0x14(%ebp),%eax
  80074e:	83 e8 04             	sub    $0x4,%eax
  800751:	8b 00                	mov    (%eax),%eax
  800753:	83 ec 08             	sub    $0x8,%esp
  800756:	ff 75 0c             	pushl  0xc(%ebp)
  800759:	50                   	push   %eax
  80075a:	8b 45 08             	mov    0x8(%ebp),%eax
  80075d:	ff d0                	call   *%eax
  80075f:	83 c4 10             	add    $0x10,%esp
			break;
  800762:	e9 89 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800767:	8b 45 14             	mov    0x14(%ebp),%eax
  80076a:	83 c0 04             	add    $0x4,%eax
  80076d:	89 45 14             	mov    %eax,0x14(%ebp)
  800770:	8b 45 14             	mov    0x14(%ebp),%eax
  800773:	83 e8 04             	sub    $0x4,%eax
  800776:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800778:	85 db                	test   %ebx,%ebx
  80077a:	79 02                	jns    80077e <vprintfmt+0x14a>
				err = -err;
  80077c:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80077e:	83 fb 64             	cmp    $0x64,%ebx
  800781:	7f 0b                	jg     80078e <vprintfmt+0x15a>
  800783:	8b 34 9d 80 35 80 00 	mov    0x803580(,%ebx,4),%esi
  80078a:	85 f6                	test   %esi,%esi
  80078c:	75 19                	jne    8007a7 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  80078e:	53                   	push   %ebx
  80078f:	68 25 37 80 00       	push   $0x803725
  800794:	ff 75 0c             	pushl  0xc(%ebp)
  800797:	ff 75 08             	pushl  0x8(%ebp)
  80079a:	e8 5e 02 00 00       	call   8009fd <printfmt>
  80079f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8007a2:	e9 49 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8007a7:	56                   	push   %esi
  8007a8:	68 2e 37 80 00       	push   $0x80372e
  8007ad:	ff 75 0c             	pushl  0xc(%ebp)
  8007b0:	ff 75 08             	pushl  0x8(%ebp)
  8007b3:	e8 45 02 00 00       	call   8009fd <printfmt>
  8007b8:	83 c4 10             	add    $0x10,%esp
			break;
  8007bb:	e9 30 02 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8007c0:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c3:	83 c0 04             	add    $0x4,%eax
  8007c6:	89 45 14             	mov    %eax,0x14(%ebp)
  8007c9:	8b 45 14             	mov    0x14(%ebp),%eax
  8007cc:	83 e8 04             	sub    $0x4,%eax
  8007cf:	8b 30                	mov    (%eax),%esi
  8007d1:	85 f6                	test   %esi,%esi
  8007d3:	75 05                	jne    8007da <vprintfmt+0x1a6>
				p = "(null)";
  8007d5:	be 31 37 80 00       	mov    $0x803731,%esi
			if (width > 0 && padc != '-')
  8007da:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007de:	7e 6d                	jle    80084d <vprintfmt+0x219>
  8007e0:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e4:	74 67                	je     80084d <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8007e6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8007e9:	83 ec 08             	sub    $0x8,%esp
  8007ec:	50                   	push   %eax
  8007ed:	56                   	push   %esi
  8007ee:	e8 0c 03 00 00       	call   800aff <strnlen>
  8007f3:	83 c4 10             	add    $0x10,%esp
  8007f6:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8007f9:	eb 16                	jmp    800811 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8007fb:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007ff:	83 ec 08             	sub    $0x8,%esp
  800802:	ff 75 0c             	pushl  0xc(%ebp)
  800805:	50                   	push   %eax
  800806:	8b 45 08             	mov    0x8(%ebp),%eax
  800809:	ff d0                	call   *%eax
  80080b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80080e:	ff 4d e4             	decl   -0x1c(%ebp)
  800811:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800815:	7f e4                	jg     8007fb <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800817:	eb 34                	jmp    80084d <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800819:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80081d:	74 1c                	je     80083b <vprintfmt+0x207>
  80081f:	83 fb 1f             	cmp    $0x1f,%ebx
  800822:	7e 05                	jle    800829 <vprintfmt+0x1f5>
  800824:	83 fb 7e             	cmp    $0x7e,%ebx
  800827:	7e 12                	jle    80083b <vprintfmt+0x207>
					putch('?', putdat);
  800829:	83 ec 08             	sub    $0x8,%esp
  80082c:	ff 75 0c             	pushl  0xc(%ebp)
  80082f:	6a 3f                	push   $0x3f
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
  800839:	eb 0f                	jmp    80084a <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80083b:	83 ec 08             	sub    $0x8,%esp
  80083e:	ff 75 0c             	pushl  0xc(%ebp)
  800841:	53                   	push   %ebx
  800842:	8b 45 08             	mov    0x8(%ebp),%eax
  800845:	ff d0                	call   *%eax
  800847:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80084a:	ff 4d e4             	decl   -0x1c(%ebp)
  80084d:	89 f0                	mov    %esi,%eax
  80084f:	8d 70 01             	lea    0x1(%eax),%esi
  800852:	8a 00                	mov    (%eax),%al
  800854:	0f be d8             	movsbl %al,%ebx
  800857:	85 db                	test   %ebx,%ebx
  800859:	74 24                	je     80087f <vprintfmt+0x24b>
  80085b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80085f:	78 b8                	js     800819 <vprintfmt+0x1e5>
  800861:	ff 4d e0             	decl   -0x20(%ebp)
  800864:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800868:	79 af                	jns    800819 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80086a:	eb 13                	jmp    80087f <vprintfmt+0x24b>
				putch(' ', putdat);
  80086c:	83 ec 08             	sub    $0x8,%esp
  80086f:	ff 75 0c             	pushl  0xc(%ebp)
  800872:	6a 20                	push   $0x20
  800874:	8b 45 08             	mov    0x8(%ebp),%eax
  800877:	ff d0                	call   *%eax
  800879:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80087c:	ff 4d e4             	decl   -0x1c(%ebp)
  80087f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800883:	7f e7                	jg     80086c <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800885:	e9 66 01 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80088a:	83 ec 08             	sub    $0x8,%esp
  80088d:	ff 75 e8             	pushl  -0x18(%ebp)
  800890:	8d 45 14             	lea    0x14(%ebp),%eax
  800893:	50                   	push   %eax
  800894:	e8 3c fd ff ff       	call   8005d5 <getint>
  800899:	83 c4 10             	add    $0x10,%esp
  80089c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80089f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8008a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008a8:	85 d2                	test   %edx,%edx
  8008aa:	79 23                	jns    8008cf <vprintfmt+0x29b>
				putch('-', putdat);
  8008ac:	83 ec 08             	sub    $0x8,%esp
  8008af:	ff 75 0c             	pushl  0xc(%ebp)
  8008b2:	6a 2d                	push   $0x2d
  8008b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b7:	ff d0                	call   *%eax
  8008b9:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8008bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008c2:	f7 d8                	neg    %eax
  8008c4:	83 d2 00             	adc    $0x0,%edx
  8008c7:	f7 da                	neg    %edx
  8008c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008cc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8008cf:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008d6:	e9 bc 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8008db:	83 ec 08             	sub    $0x8,%esp
  8008de:	ff 75 e8             	pushl  -0x18(%ebp)
  8008e1:	8d 45 14             	lea    0x14(%ebp),%eax
  8008e4:	50                   	push   %eax
  8008e5:	e8 84 fc ff ff       	call   80056e <getuint>
  8008ea:	83 c4 10             	add    $0x10,%esp
  8008ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008f0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8008f3:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8008fa:	e9 98 00 00 00       	jmp    800997 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8008ff:	83 ec 08             	sub    $0x8,%esp
  800902:	ff 75 0c             	pushl  0xc(%ebp)
  800905:	6a 58                	push   $0x58
  800907:	8b 45 08             	mov    0x8(%ebp),%eax
  80090a:	ff d0                	call   *%eax
  80090c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80090f:	83 ec 08             	sub    $0x8,%esp
  800912:	ff 75 0c             	pushl  0xc(%ebp)
  800915:	6a 58                	push   $0x58
  800917:	8b 45 08             	mov    0x8(%ebp),%eax
  80091a:	ff d0                	call   *%eax
  80091c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80091f:	83 ec 08             	sub    $0x8,%esp
  800922:	ff 75 0c             	pushl  0xc(%ebp)
  800925:	6a 58                	push   $0x58
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	ff d0                	call   *%eax
  80092c:	83 c4 10             	add    $0x10,%esp
			break;
  80092f:	e9 bc 00 00 00       	jmp    8009f0 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800934:	83 ec 08             	sub    $0x8,%esp
  800937:	ff 75 0c             	pushl  0xc(%ebp)
  80093a:	6a 30                	push   $0x30
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	ff d0                	call   *%eax
  800941:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800944:	83 ec 08             	sub    $0x8,%esp
  800947:	ff 75 0c             	pushl  0xc(%ebp)
  80094a:	6a 78                	push   $0x78
  80094c:	8b 45 08             	mov    0x8(%ebp),%eax
  80094f:	ff d0                	call   *%eax
  800951:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800954:	8b 45 14             	mov    0x14(%ebp),%eax
  800957:	83 c0 04             	add    $0x4,%eax
  80095a:	89 45 14             	mov    %eax,0x14(%ebp)
  80095d:	8b 45 14             	mov    0x14(%ebp),%eax
  800960:	83 e8 04             	sub    $0x4,%eax
  800963:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800965:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800968:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80096f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800976:	eb 1f                	jmp    800997 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800978:	83 ec 08             	sub    $0x8,%esp
  80097b:	ff 75 e8             	pushl  -0x18(%ebp)
  80097e:	8d 45 14             	lea    0x14(%ebp),%eax
  800981:	50                   	push   %eax
  800982:	e8 e7 fb ff ff       	call   80056e <getuint>
  800987:	83 c4 10             	add    $0x10,%esp
  80098a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80098d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800990:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800997:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80099b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80099e:	83 ec 04             	sub    $0x4,%esp
  8009a1:	52                   	push   %edx
  8009a2:	ff 75 e4             	pushl  -0x1c(%ebp)
  8009a5:	50                   	push   %eax
  8009a6:	ff 75 f4             	pushl  -0xc(%ebp)
  8009a9:	ff 75 f0             	pushl  -0x10(%ebp)
  8009ac:	ff 75 0c             	pushl  0xc(%ebp)
  8009af:	ff 75 08             	pushl  0x8(%ebp)
  8009b2:	e8 00 fb ff ff       	call   8004b7 <printnum>
  8009b7:	83 c4 20             	add    $0x20,%esp
			break;
  8009ba:	eb 34                	jmp    8009f0 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	53                   	push   %ebx
  8009c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c6:	ff d0                	call   *%eax
  8009c8:	83 c4 10             	add    $0x10,%esp
			break;
  8009cb:	eb 23                	jmp    8009f0 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 0c             	pushl  0xc(%ebp)
  8009d3:	6a 25                	push   $0x25
  8009d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009d8:	ff d0                	call   *%eax
  8009da:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8009dd:	ff 4d 10             	decl   0x10(%ebp)
  8009e0:	eb 03                	jmp    8009e5 <vprintfmt+0x3b1>
  8009e2:	ff 4d 10             	decl   0x10(%ebp)
  8009e5:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e8:	48                   	dec    %eax
  8009e9:	8a 00                	mov    (%eax),%al
  8009eb:	3c 25                	cmp    $0x25,%al
  8009ed:	75 f3                	jne    8009e2 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8009ef:	90                   	nop
		}
	}
  8009f0:	e9 47 fc ff ff       	jmp    80063c <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8009f5:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8009f6:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8009f9:	5b                   	pop    %ebx
  8009fa:	5e                   	pop    %esi
  8009fb:	5d                   	pop    %ebp
  8009fc:	c3                   	ret    

008009fd <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800a03:	8d 45 10             	lea    0x10(%ebp),%eax
  800a06:	83 c0 04             	add    $0x4,%eax
  800a09:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800a0c:	8b 45 10             	mov    0x10(%ebp),%eax
  800a0f:	ff 75 f4             	pushl  -0xc(%ebp)
  800a12:	50                   	push   %eax
  800a13:	ff 75 0c             	pushl  0xc(%ebp)
  800a16:	ff 75 08             	pushl  0x8(%ebp)
  800a19:	e8 16 fc ff ff       	call   800634 <vprintfmt>
  800a1e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800a21:	90                   	nop
  800a22:	c9                   	leave  
  800a23:	c3                   	ret    

00800a24 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800a27:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2a:	8b 40 08             	mov    0x8(%eax),%eax
  800a2d:	8d 50 01             	lea    0x1(%eax),%edx
  800a30:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a33:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a39:	8b 10                	mov    (%eax),%edx
  800a3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a3e:	8b 40 04             	mov    0x4(%eax),%eax
  800a41:	39 c2                	cmp    %eax,%edx
  800a43:	73 12                	jae    800a57 <sprintputch+0x33>
		*b->buf++ = ch;
  800a45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a48:	8b 00                	mov    (%eax),%eax
  800a4a:	8d 48 01             	lea    0x1(%eax),%ecx
  800a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a50:	89 0a                	mov    %ecx,(%edx)
  800a52:	8b 55 08             	mov    0x8(%ebp),%edx
  800a55:	88 10                	mov    %dl,(%eax)
}
  800a57:	90                   	nop
  800a58:	5d                   	pop    %ebp
  800a59:	c3                   	ret    

00800a5a <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	8d 50 ff             	lea    -0x1(%eax),%edx
  800a6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6f:	01 d0                	add    %edx,%eax
  800a71:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a74:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800a7b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7f:	74 06                	je     800a87 <vsnprintf+0x2d>
  800a81:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a85:	7f 07                	jg     800a8e <vsnprintf+0x34>
		return -E_INVAL;
  800a87:	b8 03 00 00 00       	mov    $0x3,%eax
  800a8c:	eb 20                	jmp    800aae <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a8e:	ff 75 14             	pushl  0x14(%ebp)
  800a91:	ff 75 10             	pushl  0x10(%ebp)
  800a94:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a97:	50                   	push   %eax
  800a98:	68 24 0a 80 00       	push   $0x800a24
  800a9d:	e8 92 fb ff ff       	call   800634 <vprintfmt>
  800aa2:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800aa5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800aa8:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800aab:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aae:	c9                   	leave  
  800aaf:	c3                   	ret    

00800ab0 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800ab0:	55                   	push   %ebp
  800ab1:	89 e5                	mov    %esp,%ebp
  800ab3:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800ab6:	8d 45 10             	lea    0x10(%ebp),%eax
  800ab9:	83 c0 04             	add    $0x4,%eax
  800abc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800abf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ac2:	ff 75 f4             	pushl  -0xc(%ebp)
  800ac5:	50                   	push   %eax
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	ff 75 08             	pushl  0x8(%ebp)
  800acc:	e8 89 ff ff ff       	call   800a5a <vsnprintf>
  800ad1:	83 c4 10             	add    $0x10,%esp
  800ad4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800ada:	c9                   	leave  
  800adb:	c3                   	ret    

00800adc <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800adc:	55                   	push   %ebp
  800add:	89 e5                	mov    %esp,%ebp
  800adf:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ae2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ae9:	eb 06                	jmp    800af1 <strlen+0x15>
		n++;
  800aeb:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800aee:	ff 45 08             	incl   0x8(%ebp)
  800af1:	8b 45 08             	mov    0x8(%ebp),%eax
  800af4:	8a 00                	mov    (%eax),%al
  800af6:	84 c0                	test   %al,%al
  800af8:	75 f1                	jne    800aeb <strlen+0xf>
		n++;
	return n;
  800afa:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800afd:	c9                   	leave  
  800afe:	c3                   	ret    

00800aff <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800aff:	55                   	push   %ebp
  800b00:	89 e5                	mov    %esp,%ebp
  800b02:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b05:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b0c:	eb 09                	jmp    800b17 <strnlen+0x18>
		n++;
  800b0e:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800b11:	ff 45 08             	incl   0x8(%ebp)
  800b14:	ff 4d 0c             	decl   0xc(%ebp)
  800b17:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b1b:	74 09                	je     800b26 <strnlen+0x27>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 00                	mov    (%eax),%al
  800b22:	84 c0                	test   %al,%al
  800b24:	75 e8                	jne    800b0e <strnlen+0xf>
		n++;
	return n;
  800b26:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b29:	c9                   	leave  
  800b2a:	c3                   	ret    

00800b2b <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800b2b:	55                   	push   %ebp
  800b2c:	89 e5                	mov    %esp,%ebp
  800b2e:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800b31:	8b 45 08             	mov    0x8(%ebp),%eax
  800b34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800b37:	90                   	nop
  800b38:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3b:	8d 50 01             	lea    0x1(%eax),%edx
  800b3e:	89 55 08             	mov    %edx,0x8(%ebp)
  800b41:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b44:	8d 4a 01             	lea    0x1(%edx),%ecx
  800b47:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800b4a:	8a 12                	mov    (%edx),%dl
  800b4c:	88 10                	mov    %dl,(%eax)
  800b4e:	8a 00                	mov    (%eax),%al
  800b50:	84 c0                	test   %al,%al
  800b52:	75 e4                	jne    800b38 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800b54:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b57:	c9                   	leave  
  800b58:	c3                   	ret    

00800b59 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800b59:	55                   	push   %ebp
  800b5a:	89 e5                	mov    %esp,%ebp
  800b5c:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800b65:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800b6c:	eb 1f                	jmp    800b8d <strncpy+0x34>
		*dst++ = *src;
  800b6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b71:	8d 50 01             	lea    0x1(%eax),%edx
  800b74:	89 55 08             	mov    %edx,0x8(%ebp)
  800b77:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b7a:	8a 12                	mov    (%edx),%dl
  800b7c:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800b7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b81:	8a 00                	mov    (%eax),%al
  800b83:	84 c0                	test   %al,%al
  800b85:	74 03                	je     800b8a <strncpy+0x31>
			src++;
  800b87:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800b8a:	ff 45 fc             	incl   -0x4(%ebp)
  800b8d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b90:	3b 45 10             	cmp    0x10(%ebp),%eax
  800b93:	72 d9                	jb     800b6e <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800b95:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800b98:	c9                   	leave  
  800b99:	c3                   	ret    

00800b9a <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800b9a:	55                   	push   %ebp
  800b9b:	89 e5                	mov    %esp,%ebp
  800b9d:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ba0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ba6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800baa:	74 30                	je     800bdc <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800bac:	eb 16                	jmp    800bc4 <strlcpy+0x2a>
			*dst++ = *src++;
  800bae:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb1:	8d 50 01             	lea    0x1(%eax),%edx
  800bb4:	89 55 08             	mov    %edx,0x8(%ebp)
  800bb7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bba:	8d 4a 01             	lea    0x1(%edx),%ecx
  800bbd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800bc0:	8a 12                	mov    (%edx),%dl
  800bc2:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800bc4:	ff 4d 10             	decl   0x10(%ebp)
  800bc7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800bcb:	74 09                	je     800bd6 <strlcpy+0x3c>
  800bcd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	84 c0                	test   %al,%al
  800bd4:	75 d8                	jne    800bae <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd9:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800bdc:	8b 55 08             	mov    0x8(%ebp),%edx
  800bdf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800be2:	29 c2                	sub    %eax,%edx
  800be4:	89 d0                	mov    %edx,%eax
}
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800beb:	eb 06                	jmp    800bf3 <strcmp+0xb>
		p++, q++;
  800bed:	ff 45 08             	incl   0x8(%ebp)
  800bf0:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf6:	8a 00                	mov    (%eax),%al
  800bf8:	84 c0                	test   %al,%al
  800bfa:	74 0e                	je     800c0a <strcmp+0x22>
  800bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800bff:	8a 10                	mov    (%eax),%dl
  800c01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c04:	8a 00                	mov    (%eax),%al
  800c06:	38 c2                	cmp    %al,%dl
  800c08:	74 e3                	je     800bed <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800c0a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c0d:	8a 00                	mov    (%eax),%al
  800c0f:	0f b6 d0             	movzbl %al,%edx
  800c12:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c15:	8a 00                	mov    (%eax),%al
  800c17:	0f b6 c0             	movzbl %al,%eax
  800c1a:	29 c2                	sub    %eax,%edx
  800c1c:	89 d0                	mov    %edx,%eax
}
  800c1e:	5d                   	pop    %ebp
  800c1f:	c3                   	ret    

00800c20 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800c20:	55                   	push   %ebp
  800c21:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800c23:	eb 09                	jmp    800c2e <strncmp+0xe>
		n--, p++, q++;
  800c25:	ff 4d 10             	decl   0x10(%ebp)
  800c28:	ff 45 08             	incl   0x8(%ebp)
  800c2b:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800c2e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c32:	74 17                	je     800c4b <strncmp+0x2b>
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	8a 00                	mov    (%eax),%al
  800c39:	84 c0                	test   %al,%al
  800c3b:	74 0e                	je     800c4b <strncmp+0x2b>
  800c3d:	8b 45 08             	mov    0x8(%ebp),%eax
  800c40:	8a 10                	mov    (%eax),%dl
  800c42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c45:	8a 00                	mov    (%eax),%al
  800c47:	38 c2                	cmp    %al,%dl
  800c49:	74 da                	je     800c25 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800c4b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c4f:	75 07                	jne    800c58 <strncmp+0x38>
		return 0;
  800c51:	b8 00 00 00 00       	mov    $0x0,%eax
  800c56:	eb 14                	jmp    800c6c <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800c58:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5b:	8a 00                	mov    (%eax),%al
  800c5d:	0f b6 d0             	movzbl %al,%edx
  800c60:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c63:	8a 00                	mov    (%eax),%al
  800c65:	0f b6 c0             	movzbl %al,%eax
  800c68:	29 c2                	sub    %eax,%edx
  800c6a:	89 d0                	mov    %edx,%eax
}
  800c6c:	5d                   	pop    %ebp
  800c6d:	c3                   	ret    

00800c6e <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800c6e:	55                   	push   %ebp
  800c6f:	89 e5                	mov    %esp,%ebp
  800c71:	83 ec 04             	sub    $0x4,%esp
  800c74:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c77:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800c7a:	eb 12                	jmp    800c8e <strchr+0x20>
		if (*s == c)
  800c7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7f:	8a 00                	mov    (%eax),%al
  800c81:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800c84:	75 05                	jne    800c8b <strchr+0x1d>
			return (char *) s;
  800c86:	8b 45 08             	mov    0x8(%ebp),%eax
  800c89:	eb 11                	jmp    800c9c <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800c8b:	ff 45 08             	incl   0x8(%ebp)
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8a 00                	mov    (%eax),%al
  800c93:	84 c0                	test   %al,%al
  800c95:	75 e5                	jne    800c7c <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800c97:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800c9c:	c9                   	leave  
  800c9d:	c3                   	ret    

00800c9e <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800c9e:	55                   	push   %ebp
  800c9f:	89 e5                	mov    %esp,%ebp
  800ca1:	83 ec 04             	sub    $0x4,%esp
  800ca4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca7:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800caa:	eb 0d                	jmp    800cb9 <strfind+0x1b>
		if (*s == c)
  800cac:	8b 45 08             	mov    0x8(%ebp),%eax
  800caf:	8a 00                	mov    (%eax),%al
  800cb1:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800cb4:	74 0e                	je     800cc4 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800cb6:	ff 45 08             	incl   0x8(%ebp)
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	8a 00                	mov    (%eax),%al
  800cbe:	84 c0                	test   %al,%al
  800cc0:	75 ea                	jne    800cac <strfind+0xe>
  800cc2:	eb 01                	jmp    800cc5 <strfind+0x27>
		if (*s == c)
			break;
  800cc4:	90                   	nop
	return (char *) s;
  800cc5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc8:	c9                   	leave  
  800cc9:	c3                   	ret    

00800cca <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800cca:	55                   	push   %ebp
  800ccb:	89 e5                	mov    %esp,%ebp
  800ccd:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800cd6:	8b 45 10             	mov    0x10(%ebp),%eax
  800cd9:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800cdc:	eb 0e                	jmp    800cec <memset+0x22>
		*p++ = c;
  800cde:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ce1:	8d 50 01             	lea    0x1(%eax),%edx
  800ce4:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ce7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cea:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800cec:	ff 4d f8             	decl   -0x8(%ebp)
  800cef:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800cf3:	79 e9                	jns    800cde <memset+0x14>
		*p++ = c;

	return v;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cf8:	c9                   	leave  
  800cf9:	c3                   	ret    

00800cfa <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800cfa:	55                   	push   %ebp
  800cfb:	89 e5                	mov    %esp,%ebp
  800cfd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d06:	8b 45 08             	mov    0x8(%ebp),%eax
  800d09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800d0c:	eb 16                	jmp    800d24 <memcpy+0x2a>
		*d++ = *s++;
  800d0e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d11:	8d 50 01             	lea    0x1(%eax),%edx
  800d14:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d17:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d1a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d1d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d20:	8a 12                	mov    (%edx),%dl
  800d22:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800d24:	8b 45 10             	mov    0x10(%ebp),%eax
  800d27:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d2a:	89 55 10             	mov    %edx,0x10(%ebp)
  800d2d:	85 c0                	test   %eax,%eax
  800d2f:	75 dd                	jne    800d0e <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d34:	c9                   	leave  
  800d35:	c3                   	ret    

00800d36 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800d36:	55                   	push   %ebp
  800d37:	89 e5                	mov    %esp,%ebp
  800d39:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800d3c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d3f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800d42:	8b 45 08             	mov    0x8(%ebp),%eax
  800d45:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800d48:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d4b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d4e:	73 50                	jae    800da0 <memmove+0x6a>
  800d50:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d53:	8b 45 10             	mov    0x10(%ebp),%eax
  800d56:	01 d0                	add    %edx,%eax
  800d58:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800d5b:	76 43                	jbe    800da0 <memmove+0x6a>
		s += n;
  800d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d60:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800d63:	8b 45 10             	mov    0x10(%ebp),%eax
  800d66:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800d69:	eb 10                	jmp    800d7b <memmove+0x45>
			*--d = *--s;
  800d6b:	ff 4d f8             	decl   -0x8(%ebp)
  800d6e:	ff 4d fc             	decl   -0x4(%ebp)
  800d71:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d74:	8a 10                	mov    (%eax),%dl
  800d76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d79:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800d7b:	8b 45 10             	mov    0x10(%ebp),%eax
  800d7e:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d81:	89 55 10             	mov    %edx,0x10(%ebp)
  800d84:	85 c0                	test   %eax,%eax
  800d86:	75 e3                	jne    800d6b <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800d88:	eb 23                	jmp    800dad <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800d8a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d8d:	8d 50 01             	lea    0x1(%eax),%edx
  800d90:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800d93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800d96:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d99:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800d9c:	8a 12                	mov    (%edx),%dl
  800d9e:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800da0:	8b 45 10             	mov    0x10(%ebp),%eax
  800da3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800da6:	89 55 10             	mov    %edx,0x10(%ebp)
  800da9:	85 c0                	test   %eax,%eax
  800dab:	75 dd                	jne    800d8a <memmove+0x54>
			*d++ = *s++;

	return dst;
  800dad:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800db0:	c9                   	leave  
  800db1:	c3                   	ret    

00800db2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800db2:	55                   	push   %ebp
  800db3:	89 e5                	mov    %esp,%ebp
  800db5:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800db8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800dbe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc1:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800dc4:	eb 2a                	jmp    800df0 <memcmp+0x3e>
		if (*s1 != *s2)
  800dc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dc9:	8a 10                	mov    (%eax),%dl
  800dcb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800dce:	8a 00                	mov    (%eax),%al
  800dd0:	38 c2                	cmp    %al,%dl
  800dd2:	74 16                	je     800dea <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800dd4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd7:	8a 00                	mov    (%eax),%al
  800dd9:	0f b6 d0             	movzbl %al,%edx
  800ddc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	0f b6 c0             	movzbl %al,%eax
  800de4:	29 c2                	sub    %eax,%edx
  800de6:	89 d0                	mov    %edx,%eax
  800de8:	eb 18                	jmp    800e02 <memcmp+0x50>
		s1++, s2++;
  800dea:	ff 45 fc             	incl   -0x4(%ebp)
  800ded:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800df0:	8b 45 10             	mov    0x10(%ebp),%eax
  800df3:	8d 50 ff             	lea    -0x1(%eax),%edx
  800df6:	89 55 10             	mov    %edx,0x10(%ebp)
  800df9:	85 c0                	test   %eax,%eax
  800dfb:	75 c9                	jne    800dc6 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800dfd:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e02:	c9                   	leave  
  800e03:	c3                   	ret    

00800e04 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800e04:	55                   	push   %ebp
  800e05:	89 e5                	mov    %esp,%ebp
  800e07:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800e0a:	8b 55 08             	mov    0x8(%ebp),%edx
  800e0d:	8b 45 10             	mov    0x10(%ebp),%eax
  800e10:	01 d0                	add    %edx,%eax
  800e12:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800e15:	eb 15                	jmp    800e2c <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800e17:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1a:	8a 00                	mov    (%eax),%al
  800e1c:	0f b6 d0             	movzbl %al,%edx
  800e1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e22:	0f b6 c0             	movzbl %al,%eax
  800e25:	39 c2                	cmp    %eax,%edx
  800e27:	74 0d                	je     800e36 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800e29:	ff 45 08             	incl   0x8(%ebp)
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800e32:	72 e3                	jb     800e17 <memfind+0x13>
  800e34:	eb 01                	jmp    800e37 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800e36:	90                   	nop
	return (void *) s;
  800e37:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e3a:	c9                   	leave  
  800e3b:	c3                   	ret    

00800e3c <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800e3c:	55                   	push   %ebp
  800e3d:	89 e5                	mov    %esp,%ebp
  800e3f:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800e42:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800e49:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e50:	eb 03                	jmp    800e55 <strtol+0x19>
		s++;
  800e52:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800e55:	8b 45 08             	mov    0x8(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	3c 20                	cmp    $0x20,%al
  800e5c:	74 f4                	je     800e52 <strtol+0x16>
  800e5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e61:	8a 00                	mov    (%eax),%al
  800e63:	3c 09                	cmp    $0x9,%al
  800e65:	74 eb                	je     800e52 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800e67:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6a:	8a 00                	mov    (%eax),%al
  800e6c:	3c 2b                	cmp    $0x2b,%al
  800e6e:	75 05                	jne    800e75 <strtol+0x39>
		s++;
  800e70:	ff 45 08             	incl   0x8(%ebp)
  800e73:	eb 13                	jmp    800e88 <strtol+0x4c>
	else if (*s == '-')
  800e75:	8b 45 08             	mov    0x8(%ebp),%eax
  800e78:	8a 00                	mov    (%eax),%al
  800e7a:	3c 2d                	cmp    $0x2d,%al
  800e7c:	75 0a                	jne    800e88 <strtol+0x4c>
		s++, neg = 1;
  800e7e:	ff 45 08             	incl   0x8(%ebp)
  800e81:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800e88:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e8c:	74 06                	je     800e94 <strtol+0x58>
  800e8e:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e92:	75 20                	jne    800eb4 <strtol+0x78>
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	8a 00                	mov    (%eax),%al
  800e99:	3c 30                	cmp    $0x30,%al
  800e9b:	75 17                	jne    800eb4 <strtol+0x78>
  800e9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea0:	40                   	inc    %eax
  800ea1:	8a 00                	mov    (%eax),%al
  800ea3:	3c 78                	cmp    $0x78,%al
  800ea5:	75 0d                	jne    800eb4 <strtol+0x78>
		s += 2, base = 16;
  800ea7:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800eab:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800eb2:	eb 28                	jmp    800edc <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800eb4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb8:	75 15                	jne    800ecf <strtol+0x93>
  800eba:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebd:	8a 00                	mov    (%eax),%al
  800ebf:	3c 30                	cmp    $0x30,%al
  800ec1:	75 0c                	jne    800ecf <strtol+0x93>
		s++, base = 8;
  800ec3:	ff 45 08             	incl   0x8(%ebp)
  800ec6:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800ecd:	eb 0d                	jmp    800edc <strtol+0xa0>
	else if (base == 0)
  800ecf:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed3:	75 07                	jne    800edc <strtol+0xa0>
		base = 10;
  800ed5:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800edc:	8b 45 08             	mov    0x8(%ebp),%eax
  800edf:	8a 00                	mov    (%eax),%al
  800ee1:	3c 2f                	cmp    $0x2f,%al
  800ee3:	7e 19                	jle    800efe <strtol+0xc2>
  800ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee8:	8a 00                	mov    (%eax),%al
  800eea:	3c 39                	cmp    $0x39,%al
  800eec:	7f 10                	jg     800efe <strtol+0xc2>
			dig = *s - '0';
  800eee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef1:	8a 00                	mov    (%eax),%al
  800ef3:	0f be c0             	movsbl %al,%eax
  800ef6:	83 e8 30             	sub    $0x30,%eax
  800ef9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800efc:	eb 42                	jmp    800f40 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800efe:	8b 45 08             	mov    0x8(%ebp),%eax
  800f01:	8a 00                	mov    (%eax),%al
  800f03:	3c 60                	cmp    $0x60,%al
  800f05:	7e 19                	jle    800f20 <strtol+0xe4>
  800f07:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0a:	8a 00                	mov    (%eax),%al
  800f0c:	3c 7a                	cmp    $0x7a,%al
  800f0e:	7f 10                	jg     800f20 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800f10:	8b 45 08             	mov    0x8(%ebp),%eax
  800f13:	8a 00                	mov    (%eax),%al
  800f15:	0f be c0             	movsbl %al,%eax
  800f18:	83 e8 57             	sub    $0x57,%eax
  800f1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800f1e:	eb 20                	jmp    800f40 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	8a 00                	mov    (%eax),%al
  800f25:	3c 40                	cmp    $0x40,%al
  800f27:	7e 39                	jle    800f62 <strtol+0x126>
  800f29:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2c:	8a 00                	mov    (%eax),%al
  800f2e:	3c 5a                	cmp    $0x5a,%al
  800f30:	7f 30                	jg     800f62 <strtol+0x126>
			dig = *s - 'A' + 10;
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	8a 00                	mov    (%eax),%al
  800f37:	0f be c0             	movsbl %al,%eax
  800f3a:	83 e8 37             	sub    $0x37,%eax
  800f3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800f40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f43:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f46:	7d 19                	jge    800f61 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800f48:	ff 45 08             	incl   0x8(%ebp)
  800f4b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f4e:	0f af 45 10          	imul   0x10(%ebp),%eax
  800f52:	89 c2                	mov    %eax,%edx
  800f54:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800f5c:	e9 7b ff ff ff       	jmp    800edc <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800f61:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800f62:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f66:	74 08                	je     800f70 <strtol+0x134>
		*endptr = (char *) s;
  800f68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6b:	8b 55 08             	mov    0x8(%ebp),%edx
  800f6e:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800f70:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f74:	74 07                	je     800f7d <strtol+0x141>
  800f76:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f79:	f7 d8                	neg    %eax
  800f7b:	eb 03                	jmp    800f80 <strtol+0x144>
  800f7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f80:	c9                   	leave  
  800f81:	c3                   	ret    

00800f82 <ltostr>:

void
ltostr(long value, char *str)
{
  800f82:	55                   	push   %ebp
  800f83:	89 e5                	mov    %esp,%ebp
  800f85:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800f88:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800f8f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800f96:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800f9a:	79 13                	jns    800faf <ltostr+0x2d>
	{
		neg = 1;
  800f9c:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800fa3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa6:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800fa9:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800fac:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800faf:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb2:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800fb7:	99                   	cltd   
  800fb8:	f7 f9                	idiv   %ecx
  800fba:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800fbd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fc0:	8d 50 01             	lea    0x1(%eax),%edx
  800fc3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fc6:	89 c2                	mov    %eax,%edx
  800fc8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fcb:	01 d0                	add    %edx,%eax
  800fcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800fd0:	83 c2 30             	add    $0x30,%edx
  800fd3:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800fd5:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800fd8:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800fdd:	f7 e9                	imul   %ecx
  800fdf:	c1 fa 02             	sar    $0x2,%edx
  800fe2:	89 c8                	mov    %ecx,%eax
  800fe4:	c1 f8 1f             	sar    $0x1f,%eax
  800fe7:	29 c2                	sub    %eax,%edx
  800fe9:	89 d0                	mov    %edx,%eax
  800feb:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800fee:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ff1:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800ff6:	f7 e9                	imul   %ecx
  800ff8:	c1 fa 02             	sar    $0x2,%edx
  800ffb:	89 c8                	mov    %ecx,%eax
  800ffd:	c1 f8 1f             	sar    $0x1f,%eax
  801000:	29 c2                	sub    %eax,%edx
  801002:	89 d0                	mov    %edx,%eax
  801004:	c1 e0 02             	shl    $0x2,%eax
  801007:	01 d0                	add    %edx,%eax
  801009:	01 c0                	add    %eax,%eax
  80100b:	29 c1                	sub    %eax,%ecx
  80100d:	89 ca                	mov    %ecx,%edx
  80100f:	85 d2                	test   %edx,%edx
  801011:	75 9c                	jne    800faf <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801013:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80101a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101d:	48                   	dec    %eax
  80101e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801021:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801025:	74 3d                	je     801064 <ltostr+0xe2>
		start = 1 ;
  801027:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80102e:	eb 34                	jmp    801064 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801030:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	01 d0                	add    %edx,%eax
  801038:	8a 00                	mov    (%eax),%al
  80103a:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80103d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801040:	8b 45 0c             	mov    0xc(%ebp),%eax
  801043:	01 c2                	add    %eax,%edx
  801045:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801048:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104b:	01 c8                	add    %ecx,%eax
  80104d:	8a 00                	mov    (%eax),%al
  80104f:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801051:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801054:	8b 45 0c             	mov    0xc(%ebp),%eax
  801057:	01 c2                	add    %eax,%edx
  801059:	8a 45 eb             	mov    -0x15(%ebp),%al
  80105c:	88 02                	mov    %al,(%edx)
		start++ ;
  80105e:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801061:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801067:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80106a:	7c c4                	jl     801030 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80106c:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80106f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801072:	01 d0                	add    %edx,%eax
  801074:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801077:	90                   	nop
  801078:	c9                   	leave  
  801079:	c3                   	ret    

0080107a <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80107a:	55                   	push   %ebp
  80107b:	89 e5                	mov    %esp,%ebp
  80107d:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801080:	ff 75 08             	pushl  0x8(%ebp)
  801083:	e8 54 fa ff ff       	call   800adc <strlen>
  801088:	83 c4 04             	add    $0x4,%esp
  80108b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80108e:	ff 75 0c             	pushl  0xc(%ebp)
  801091:	e8 46 fa ff ff       	call   800adc <strlen>
  801096:	83 c4 04             	add    $0x4,%esp
  801099:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80109c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8010a3:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010aa:	eb 17                	jmp    8010c3 <strcconcat+0x49>
		final[s] = str1[s] ;
  8010ac:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010af:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b2:	01 c2                	add    %eax,%edx
  8010b4:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	01 c8                	add    %ecx,%eax
  8010bc:	8a 00                	mov    (%eax),%al
  8010be:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8010c0:	ff 45 fc             	incl   -0x4(%ebp)
  8010c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c6:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8010c9:	7c e1                	jl     8010ac <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8010cb:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8010d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8010d9:	eb 1f                	jmp    8010fa <strcconcat+0x80>
		final[s++] = str2[i] ;
  8010db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010de:	8d 50 01             	lea    0x1(%eax),%edx
  8010e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8010e4:	89 c2                	mov    %eax,%edx
  8010e6:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e9:	01 c2                	add    %eax,%edx
  8010eb:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8010ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f1:	01 c8                	add    %ecx,%eax
  8010f3:	8a 00                	mov    (%eax),%al
  8010f5:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8010f7:	ff 45 f8             	incl   -0x8(%ebp)
  8010fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801100:	7c d9                	jl     8010db <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801102:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801105:	8b 45 10             	mov    0x10(%ebp),%eax
  801108:	01 d0                	add    %edx,%eax
  80110a:	c6 00 00             	movb   $0x0,(%eax)
}
  80110d:	90                   	nop
  80110e:	c9                   	leave  
  80110f:	c3                   	ret    

00801110 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801110:	55                   	push   %ebp
  801111:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801113:	8b 45 14             	mov    0x14(%ebp),%eax
  801116:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80111c:	8b 45 14             	mov    0x14(%ebp),%eax
  80111f:	8b 00                	mov    (%eax),%eax
  801121:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801128:	8b 45 10             	mov    0x10(%ebp),%eax
  80112b:	01 d0                	add    %edx,%eax
  80112d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801133:	eb 0c                	jmp    801141 <strsplit+0x31>
			*string++ = 0;
  801135:	8b 45 08             	mov    0x8(%ebp),%eax
  801138:	8d 50 01             	lea    0x1(%eax),%edx
  80113b:	89 55 08             	mov    %edx,0x8(%ebp)
  80113e:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	84 c0                	test   %al,%al
  801148:	74 18                	je     801162 <strsplit+0x52>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	0f be c0             	movsbl %al,%eax
  801152:	50                   	push   %eax
  801153:	ff 75 0c             	pushl  0xc(%ebp)
  801156:	e8 13 fb ff ff       	call   800c6e <strchr>
  80115b:	83 c4 08             	add    $0x8,%esp
  80115e:	85 c0                	test   %eax,%eax
  801160:	75 d3                	jne    801135 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	84 c0                	test   %al,%al
  801169:	74 5a                	je     8011c5 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80116b:	8b 45 14             	mov    0x14(%ebp),%eax
  80116e:	8b 00                	mov    (%eax),%eax
  801170:	83 f8 0f             	cmp    $0xf,%eax
  801173:	75 07                	jne    80117c <strsplit+0x6c>
		{
			return 0;
  801175:	b8 00 00 00 00       	mov    $0x0,%eax
  80117a:	eb 66                	jmp    8011e2 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80117c:	8b 45 14             	mov    0x14(%ebp),%eax
  80117f:	8b 00                	mov    (%eax),%eax
  801181:	8d 48 01             	lea    0x1(%eax),%ecx
  801184:	8b 55 14             	mov    0x14(%ebp),%edx
  801187:	89 0a                	mov    %ecx,(%edx)
  801189:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801190:	8b 45 10             	mov    0x10(%ebp),%eax
  801193:	01 c2                	add    %eax,%edx
  801195:	8b 45 08             	mov    0x8(%ebp),%eax
  801198:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119a:	eb 03                	jmp    80119f <strsplit+0x8f>
			string++;
  80119c:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  80119f:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	84 c0                	test   %al,%al
  8011a6:	74 8b                	je     801133 <strsplit+0x23>
  8011a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ab:	8a 00                	mov    (%eax),%al
  8011ad:	0f be c0             	movsbl %al,%eax
  8011b0:	50                   	push   %eax
  8011b1:	ff 75 0c             	pushl  0xc(%ebp)
  8011b4:	e8 b5 fa ff ff       	call   800c6e <strchr>
  8011b9:	83 c4 08             	add    $0x8,%esp
  8011bc:	85 c0                	test   %eax,%eax
  8011be:	74 dc                	je     80119c <strsplit+0x8c>
			string++;
	}
  8011c0:	e9 6e ff ff ff       	jmp    801133 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8011c5:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8011c6:	8b 45 14             	mov    0x14(%ebp),%eax
  8011c9:	8b 00                	mov    (%eax),%eax
  8011cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8011d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8011d5:	01 d0                	add    %edx,%eax
  8011d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8011dd:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8011e2:	c9                   	leave  
  8011e3:	c3                   	ret    

008011e4 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8011e4:	55                   	push   %ebp
  8011e5:	89 e5                	mov    %esp,%ebp
  8011e7:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8011ea:	a1 04 40 80 00       	mov    0x804004,%eax
  8011ef:	85 c0                	test   %eax,%eax
  8011f1:	74 1f                	je     801212 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8011f3:	e8 1d 00 00 00       	call   801215 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8011f8:	83 ec 0c             	sub    $0xc,%esp
  8011fb:	68 90 38 80 00       	push   $0x803890
  801200:	e8 55 f2 ff ff       	call   80045a <cprintf>
  801205:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801208:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  80120f:	00 00 00 
	}
}
  801212:	90                   	nop
  801213:	c9                   	leave  
  801214:	c3                   	ret    

00801215 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801215:	55                   	push   %ebp
  801216:	89 e5                	mov    %esp,%ebp
  801218:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  80121b:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801222:	00 00 00 
  801225:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80122c:	00 00 00 
  80122f:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801236:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801239:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801240:	00 00 00 
  801243:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80124a:	00 00 00 
  80124d:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801254:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801257:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  80125e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801261:	c1 e8 0c             	shr    $0xc,%eax
  801264:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801269:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801270:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801273:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801278:	2d 00 10 00 00       	sub    $0x1000,%eax
  80127d:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  801282:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801289:	a1 20 41 80 00       	mov    0x804120,%eax
  80128e:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801292:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801295:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  80129c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80129f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8012a2:	01 d0                	add    %edx,%eax
  8012a4:	48                   	dec    %eax
  8012a5:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8012a8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012ab:	ba 00 00 00 00       	mov    $0x0,%edx
  8012b0:	f7 75 e4             	divl   -0x1c(%ebp)
  8012b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012b6:	29 d0                	sub    %edx,%eax
  8012b8:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8012bb:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8012c2:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8012c5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8012ca:	2d 00 10 00 00       	sub    $0x1000,%eax
  8012cf:	83 ec 04             	sub    $0x4,%esp
  8012d2:	6a 07                	push   $0x7
  8012d4:	ff 75 e8             	pushl  -0x18(%ebp)
  8012d7:	50                   	push   %eax
  8012d8:	e8 3d 06 00 00       	call   80191a <sys_allocate_chunk>
  8012dd:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8012e0:	a1 20 41 80 00       	mov    0x804120,%eax
  8012e5:	83 ec 0c             	sub    $0xc,%esp
  8012e8:	50                   	push   %eax
  8012e9:	e8 b2 0c 00 00       	call   801fa0 <initialize_MemBlocksList>
  8012ee:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8012f1:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8012f6:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8012f9:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8012fd:	0f 84 f3 00 00 00    	je     8013f6 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801303:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801307:	75 14                	jne    80131d <initialize_dyn_block_system+0x108>
  801309:	83 ec 04             	sub    $0x4,%esp
  80130c:	68 b5 38 80 00       	push   $0x8038b5
  801311:	6a 36                	push   $0x36
  801313:	68 d3 38 80 00       	push   $0x8038d3
  801318:	e8 41 1c 00 00       	call   802f5e <_panic>
  80131d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801320:	8b 00                	mov    (%eax),%eax
  801322:	85 c0                	test   %eax,%eax
  801324:	74 10                	je     801336 <initialize_dyn_block_system+0x121>
  801326:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801329:	8b 00                	mov    (%eax),%eax
  80132b:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80132e:	8b 52 04             	mov    0x4(%edx),%edx
  801331:	89 50 04             	mov    %edx,0x4(%eax)
  801334:	eb 0b                	jmp    801341 <initialize_dyn_block_system+0x12c>
  801336:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801339:	8b 40 04             	mov    0x4(%eax),%eax
  80133c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801341:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801344:	8b 40 04             	mov    0x4(%eax),%eax
  801347:	85 c0                	test   %eax,%eax
  801349:	74 0f                	je     80135a <initialize_dyn_block_system+0x145>
  80134b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80134e:	8b 40 04             	mov    0x4(%eax),%eax
  801351:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801354:	8b 12                	mov    (%edx),%edx
  801356:	89 10                	mov    %edx,(%eax)
  801358:	eb 0a                	jmp    801364 <initialize_dyn_block_system+0x14f>
  80135a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80135d:	8b 00                	mov    (%eax),%eax
  80135f:	a3 48 41 80 00       	mov    %eax,0x804148
  801364:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801367:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80136d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801370:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801377:	a1 54 41 80 00       	mov    0x804154,%eax
  80137c:	48                   	dec    %eax
  80137d:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801382:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801385:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  80138c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80138f:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801396:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80139a:	75 14                	jne    8013b0 <initialize_dyn_block_system+0x19b>
  80139c:	83 ec 04             	sub    $0x4,%esp
  80139f:	68 e0 38 80 00       	push   $0x8038e0
  8013a4:	6a 3e                	push   $0x3e
  8013a6:	68 d3 38 80 00       	push   $0x8038d3
  8013ab:	e8 ae 1b 00 00       	call   802f5e <_panic>
  8013b0:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8013b6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013b9:	89 10                	mov    %edx,(%eax)
  8013bb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013be:	8b 00                	mov    (%eax),%eax
  8013c0:	85 c0                	test   %eax,%eax
  8013c2:	74 0d                	je     8013d1 <initialize_dyn_block_system+0x1bc>
  8013c4:	a1 38 41 80 00       	mov    0x804138,%eax
  8013c9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8013cc:	89 50 04             	mov    %edx,0x4(%eax)
  8013cf:	eb 08                	jmp    8013d9 <initialize_dyn_block_system+0x1c4>
  8013d1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013d4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8013d9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013dc:	a3 38 41 80 00       	mov    %eax,0x804138
  8013e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8013e4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8013eb:	a1 44 41 80 00       	mov    0x804144,%eax
  8013f0:	40                   	inc    %eax
  8013f1:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8013f6:	90                   	nop
  8013f7:	c9                   	leave  
  8013f8:	c3                   	ret    

008013f9 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8013f9:	55                   	push   %ebp
  8013fa:	89 e5                	mov    %esp,%ebp
  8013fc:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8013ff:	e8 e0 fd ff ff       	call   8011e4 <InitializeUHeap>
		if (size == 0) return NULL ;
  801404:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801408:	75 07                	jne    801411 <malloc+0x18>
  80140a:	b8 00 00 00 00       	mov    $0x0,%eax
  80140f:	eb 7f                	jmp    801490 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801411:	e8 d2 08 00 00       	call   801ce8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801416:	85 c0                	test   %eax,%eax
  801418:	74 71                	je     80148b <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  80141a:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801421:	8b 55 08             	mov    0x8(%ebp),%edx
  801424:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801427:	01 d0                	add    %edx,%eax
  801429:	48                   	dec    %eax
  80142a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80142d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801430:	ba 00 00 00 00       	mov    $0x0,%edx
  801435:	f7 75 f4             	divl   -0xc(%ebp)
  801438:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143b:	29 d0                	sub    %edx,%eax
  80143d:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801440:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801447:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80144e:	76 07                	jbe    801457 <malloc+0x5e>
					return NULL ;
  801450:	b8 00 00 00 00       	mov    $0x0,%eax
  801455:	eb 39                	jmp    801490 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801457:	83 ec 0c             	sub    $0xc,%esp
  80145a:	ff 75 08             	pushl  0x8(%ebp)
  80145d:	e8 e6 0d 00 00       	call   802248 <alloc_block_FF>
  801462:	83 c4 10             	add    $0x10,%esp
  801465:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801468:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80146c:	74 16                	je     801484 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  80146e:	83 ec 0c             	sub    $0xc,%esp
  801471:	ff 75 ec             	pushl  -0x14(%ebp)
  801474:	e8 37 0c 00 00       	call   8020b0 <insert_sorted_allocList>
  801479:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  80147c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80147f:	8b 40 08             	mov    0x8(%eax),%eax
  801482:	eb 0c                	jmp    801490 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801484:	b8 00 00 00 00       	mov    $0x0,%eax
  801489:	eb 05                	jmp    801490 <malloc+0x97>
				}
		}
	return 0;
  80148b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801490:	c9                   	leave  
  801491:	c3                   	ret    

00801492 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801492:	55                   	push   %ebp
  801493:	89 e5                	mov    %esp,%ebp
  801495:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  80149e:	83 ec 08             	sub    $0x8,%esp
  8014a1:	ff 75 f4             	pushl  -0xc(%ebp)
  8014a4:	68 40 40 80 00       	push   $0x804040
  8014a9:	e8 cf 0b 00 00       	call   80207d <find_block>
  8014ae:	83 c4 10             	add    $0x10,%esp
  8014b1:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8014b4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014b7:	8b 40 0c             	mov    0xc(%eax),%eax
  8014ba:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8014bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014c0:	8b 40 08             	mov    0x8(%eax),%eax
  8014c3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8014c6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014ca:	0f 84 a1 00 00 00    	je     801571 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8014d0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014d4:	75 17                	jne    8014ed <free+0x5b>
  8014d6:	83 ec 04             	sub    $0x4,%esp
  8014d9:	68 b5 38 80 00       	push   $0x8038b5
  8014de:	68 80 00 00 00       	push   $0x80
  8014e3:	68 d3 38 80 00       	push   $0x8038d3
  8014e8:	e8 71 1a 00 00       	call   802f5e <_panic>
  8014ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f0:	8b 00                	mov    (%eax),%eax
  8014f2:	85 c0                	test   %eax,%eax
  8014f4:	74 10                	je     801506 <free+0x74>
  8014f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014f9:	8b 00                	mov    (%eax),%eax
  8014fb:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014fe:	8b 52 04             	mov    0x4(%edx),%edx
  801501:	89 50 04             	mov    %edx,0x4(%eax)
  801504:	eb 0b                	jmp    801511 <free+0x7f>
  801506:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801509:	8b 40 04             	mov    0x4(%eax),%eax
  80150c:	a3 44 40 80 00       	mov    %eax,0x804044
  801511:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801514:	8b 40 04             	mov    0x4(%eax),%eax
  801517:	85 c0                	test   %eax,%eax
  801519:	74 0f                	je     80152a <free+0x98>
  80151b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80151e:	8b 40 04             	mov    0x4(%eax),%eax
  801521:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801524:	8b 12                	mov    (%edx),%edx
  801526:	89 10                	mov    %edx,(%eax)
  801528:	eb 0a                	jmp    801534 <free+0xa2>
  80152a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80152d:	8b 00                	mov    (%eax),%eax
  80152f:	a3 40 40 80 00       	mov    %eax,0x804040
  801534:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801537:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80153d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801540:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801547:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80154c:	48                   	dec    %eax
  80154d:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  801552:	83 ec 0c             	sub    $0xc,%esp
  801555:	ff 75 f0             	pushl  -0x10(%ebp)
  801558:	e8 29 12 00 00       	call   802786 <insert_sorted_with_merge_freeList>
  80155d:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801560:	83 ec 08             	sub    $0x8,%esp
  801563:	ff 75 ec             	pushl  -0x14(%ebp)
  801566:	ff 75 e8             	pushl  -0x18(%ebp)
  801569:	e8 74 03 00 00       	call   8018e2 <sys_free_user_mem>
  80156e:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801571:	90                   	nop
  801572:	c9                   	leave  
  801573:	c3                   	ret    

00801574 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801574:	55                   	push   %ebp
  801575:	89 e5                	mov    %esp,%ebp
  801577:	83 ec 38             	sub    $0x38,%esp
  80157a:	8b 45 10             	mov    0x10(%ebp),%eax
  80157d:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801580:	e8 5f fc ff ff       	call   8011e4 <InitializeUHeap>
	if (size == 0) return NULL ;
  801585:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801589:	75 0a                	jne    801595 <smalloc+0x21>
  80158b:	b8 00 00 00 00       	mov    $0x0,%eax
  801590:	e9 b2 00 00 00       	jmp    801647 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801595:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  80159c:	76 0a                	jbe    8015a8 <smalloc+0x34>
		return NULL;
  80159e:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a3:	e9 9f 00 00 00       	jmp    801647 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8015a8:	e8 3b 07 00 00       	call   801ce8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015ad:	85 c0                	test   %eax,%eax
  8015af:	0f 84 8d 00 00 00    	je     801642 <smalloc+0xce>
	struct MemBlock *b = NULL;
  8015b5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8015bc:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8015c3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015c9:	01 d0                	add    %edx,%eax
  8015cb:	48                   	dec    %eax
  8015cc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8015cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8015d7:	f7 75 f0             	divl   -0x10(%ebp)
  8015da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015dd:	29 d0                	sub    %edx,%eax
  8015df:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8015e2:	83 ec 0c             	sub    $0xc,%esp
  8015e5:	ff 75 e8             	pushl  -0x18(%ebp)
  8015e8:	e8 5b 0c 00 00       	call   802248 <alloc_block_FF>
  8015ed:	83 c4 10             	add    $0x10,%esp
  8015f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8015f3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8015f7:	75 07                	jne    801600 <smalloc+0x8c>
			return NULL;
  8015f9:	b8 00 00 00 00       	mov    $0x0,%eax
  8015fe:	eb 47                	jmp    801647 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801600:	83 ec 0c             	sub    $0xc,%esp
  801603:	ff 75 f4             	pushl  -0xc(%ebp)
  801606:	e8 a5 0a 00 00       	call   8020b0 <insert_sorted_allocList>
  80160b:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  80160e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801611:	8b 40 08             	mov    0x8(%eax),%eax
  801614:	89 c2                	mov    %eax,%edx
  801616:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80161a:	52                   	push   %edx
  80161b:	50                   	push   %eax
  80161c:	ff 75 0c             	pushl  0xc(%ebp)
  80161f:	ff 75 08             	pushl  0x8(%ebp)
  801622:	e8 46 04 00 00       	call   801a6d <sys_createSharedObject>
  801627:	83 c4 10             	add    $0x10,%esp
  80162a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  80162d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801631:	78 08                	js     80163b <smalloc+0xc7>
		return (void *)b->sva;
  801633:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801636:	8b 40 08             	mov    0x8(%eax),%eax
  801639:	eb 0c                	jmp    801647 <smalloc+0xd3>
		}else{
		return NULL;
  80163b:	b8 00 00 00 00       	mov    $0x0,%eax
  801640:	eb 05                	jmp    801647 <smalloc+0xd3>
			}

	}return NULL;
  801642:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801647:	c9                   	leave  
  801648:	c3                   	ret    

00801649 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801649:	55                   	push   %ebp
  80164a:	89 e5                	mov    %esp,%ebp
  80164c:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80164f:	e8 90 fb ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801654:	e8 8f 06 00 00       	call   801ce8 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801659:	85 c0                	test   %eax,%eax
  80165b:	0f 84 ad 00 00 00    	je     80170e <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801661:	83 ec 08             	sub    $0x8,%esp
  801664:	ff 75 0c             	pushl  0xc(%ebp)
  801667:	ff 75 08             	pushl  0x8(%ebp)
  80166a:	e8 28 04 00 00       	call   801a97 <sys_getSizeOfSharedObject>
  80166f:	83 c4 10             	add    $0x10,%esp
  801672:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801675:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801679:	79 0a                	jns    801685 <sget+0x3c>
    {
    	return NULL;
  80167b:	b8 00 00 00 00       	mov    $0x0,%eax
  801680:	e9 8e 00 00 00       	jmp    801713 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801685:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  80168c:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801693:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801696:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801699:	01 d0                	add    %edx,%eax
  80169b:	48                   	dec    %eax
  80169c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80169f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016a2:	ba 00 00 00 00       	mov    $0x0,%edx
  8016a7:	f7 75 ec             	divl   -0x14(%ebp)
  8016aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8016ad:	29 d0                	sub    %edx,%eax
  8016af:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8016b2:	83 ec 0c             	sub    $0xc,%esp
  8016b5:	ff 75 e4             	pushl  -0x1c(%ebp)
  8016b8:	e8 8b 0b 00 00       	call   802248 <alloc_block_FF>
  8016bd:	83 c4 10             	add    $0x10,%esp
  8016c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8016c3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8016c7:	75 07                	jne    8016d0 <sget+0x87>
				return NULL;
  8016c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8016ce:	eb 43                	jmp    801713 <sget+0xca>
			}
			insert_sorted_allocList(b);
  8016d0:	83 ec 0c             	sub    $0xc,%esp
  8016d3:	ff 75 f0             	pushl  -0x10(%ebp)
  8016d6:	e8 d5 09 00 00       	call   8020b0 <insert_sorted_allocList>
  8016db:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8016de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e1:	8b 40 08             	mov    0x8(%eax),%eax
  8016e4:	83 ec 04             	sub    $0x4,%esp
  8016e7:	50                   	push   %eax
  8016e8:	ff 75 0c             	pushl  0xc(%ebp)
  8016eb:	ff 75 08             	pushl  0x8(%ebp)
  8016ee:	e8 c1 03 00 00       	call   801ab4 <sys_getSharedObject>
  8016f3:	83 c4 10             	add    $0x10,%esp
  8016f6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8016f9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8016fd:	78 08                	js     801707 <sget+0xbe>
			return (void *)b->sva;
  8016ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801702:	8b 40 08             	mov    0x8(%eax),%eax
  801705:	eb 0c                	jmp    801713 <sget+0xca>
			}else{
			return NULL;
  801707:	b8 00 00 00 00       	mov    $0x0,%eax
  80170c:	eb 05                	jmp    801713 <sget+0xca>
			}
    }}return NULL;
  80170e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801713:	c9                   	leave  
  801714:	c3                   	ret    

00801715 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801715:	55                   	push   %ebp
  801716:	89 e5                	mov    %esp,%ebp
  801718:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80171b:	e8 c4 fa ff ff       	call   8011e4 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801720:	83 ec 04             	sub    $0x4,%esp
  801723:	68 04 39 80 00       	push   $0x803904
  801728:	68 03 01 00 00       	push   $0x103
  80172d:	68 d3 38 80 00       	push   $0x8038d3
  801732:	e8 27 18 00 00       	call   802f5e <_panic>

00801737 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801737:	55                   	push   %ebp
  801738:	89 e5                	mov    %esp,%ebp
  80173a:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80173d:	83 ec 04             	sub    $0x4,%esp
  801740:	68 2c 39 80 00       	push   $0x80392c
  801745:	68 17 01 00 00       	push   $0x117
  80174a:	68 d3 38 80 00       	push   $0x8038d3
  80174f:	e8 0a 18 00 00       	call   802f5e <_panic>

00801754 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801754:	55                   	push   %ebp
  801755:	89 e5                	mov    %esp,%ebp
  801757:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80175a:	83 ec 04             	sub    $0x4,%esp
  80175d:	68 50 39 80 00       	push   $0x803950
  801762:	68 22 01 00 00       	push   $0x122
  801767:	68 d3 38 80 00       	push   $0x8038d3
  80176c:	e8 ed 17 00 00       	call   802f5e <_panic>

00801771 <shrink>:

}
void shrink(uint32 newSize)
{
  801771:	55                   	push   %ebp
  801772:	89 e5                	mov    %esp,%ebp
  801774:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801777:	83 ec 04             	sub    $0x4,%esp
  80177a:	68 50 39 80 00       	push   $0x803950
  80177f:	68 27 01 00 00       	push   $0x127
  801784:	68 d3 38 80 00       	push   $0x8038d3
  801789:	e8 d0 17 00 00       	call   802f5e <_panic>

0080178e <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80178e:	55                   	push   %ebp
  80178f:	89 e5                	mov    %esp,%ebp
  801791:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801794:	83 ec 04             	sub    $0x4,%esp
  801797:	68 50 39 80 00       	push   $0x803950
  80179c:	68 2c 01 00 00       	push   $0x12c
  8017a1:	68 d3 38 80 00       	push   $0x8038d3
  8017a6:	e8 b3 17 00 00       	call   802f5e <_panic>

008017ab <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8017ab:	55                   	push   %ebp
  8017ac:	89 e5                	mov    %esp,%ebp
  8017ae:	57                   	push   %edi
  8017af:	56                   	push   %esi
  8017b0:	53                   	push   %ebx
  8017b1:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017ba:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017bd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017c0:	8b 7d 18             	mov    0x18(%ebp),%edi
  8017c3:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8017c6:	cd 30                	int    $0x30
  8017c8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8017cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8017ce:	83 c4 10             	add    $0x10,%esp
  8017d1:	5b                   	pop    %ebx
  8017d2:	5e                   	pop    %esi
  8017d3:	5f                   	pop    %edi
  8017d4:	5d                   	pop    %ebp
  8017d5:	c3                   	ret    

008017d6 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8017d6:	55                   	push   %ebp
  8017d7:	89 e5                	mov    %esp,%ebp
  8017d9:	83 ec 04             	sub    $0x4,%esp
  8017dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8017df:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8017e2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e9:	6a 00                	push   $0x0
  8017eb:	6a 00                	push   $0x0
  8017ed:	52                   	push   %edx
  8017ee:	ff 75 0c             	pushl  0xc(%ebp)
  8017f1:	50                   	push   %eax
  8017f2:	6a 00                	push   $0x0
  8017f4:	e8 b2 ff ff ff       	call   8017ab <syscall>
  8017f9:	83 c4 18             	add    $0x18,%esp
}
  8017fc:	90                   	nop
  8017fd:	c9                   	leave  
  8017fe:	c3                   	ret    

008017ff <sys_cgetc>:

int
sys_cgetc(void)
{
  8017ff:	55                   	push   %ebp
  801800:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801802:	6a 00                	push   $0x0
  801804:	6a 00                	push   $0x0
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	6a 01                	push   $0x1
  80180e:	e8 98 ff ff ff       	call   8017ab <syscall>
  801813:	83 c4 18             	add    $0x18,%esp
}
  801816:	c9                   	leave  
  801817:	c3                   	ret    

00801818 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801818:	55                   	push   %ebp
  801819:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80181b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181e:	8b 45 08             	mov    0x8(%ebp),%eax
  801821:	6a 00                	push   $0x0
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	52                   	push   %edx
  801828:	50                   	push   %eax
  801829:	6a 05                	push   $0x5
  80182b:	e8 7b ff ff ff       	call   8017ab <syscall>
  801830:	83 c4 18             	add    $0x18,%esp
}
  801833:	c9                   	leave  
  801834:	c3                   	ret    

00801835 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801835:	55                   	push   %ebp
  801836:	89 e5                	mov    %esp,%ebp
  801838:	56                   	push   %esi
  801839:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80183a:	8b 75 18             	mov    0x18(%ebp),%esi
  80183d:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801840:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801843:	8b 55 0c             	mov    0xc(%ebp),%edx
  801846:	8b 45 08             	mov    0x8(%ebp),%eax
  801849:	56                   	push   %esi
  80184a:	53                   	push   %ebx
  80184b:	51                   	push   %ecx
  80184c:	52                   	push   %edx
  80184d:	50                   	push   %eax
  80184e:	6a 06                	push   $0x6
  801850:	e8 56 ff ff ff       	call   8017ab <syscall>
  801855:	83 c4 18             	add    $0x18,%esp
}
  801858:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80185b:	5b                   	pop    %ebx
  80185c:	5e                   	pop    %esi
  80185d:	5d                   	pop    %ebp
  80185e:	c3                   	ret    

0080185f <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801862:	8b 55 0c             	mov    0xc(%ebp),%edx
  801865:	8b 45 08             	mov    0x8(%ebp),%eax
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 00                	push   $0x0
  80186e:	52                   	push   %edx
  80186f:	50                   	push   %eax
  801870:	6a 07                	push   $0x7
  801872:	e8 34 ff ff ff       	call   8017ab <syscall>
  801877:	83 c4 18             	add    $0x18,%esp
}
  80187a:	c9                   	leave  
  80187b:	c3                   	ret    

0080187c <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80187c:	55                   	push   %ebp
  80187d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80187f:	6a 00                	push   $0x0
  801881:	6a 00                	push   $0x0
  801883:	6a 00                	push   $0x0
  801885:	ff 75 0c             	pushl  0xc(%ebp)
  801888:	ff 75 08             	pushl  0x8(%ebp)
  80188b:	6a 08                	push   $0x8
  80188d:	e8 19 ff ff ff       	call   8017ab <syscall>
  801892:	83 c4 18             	add    $0x18,%esp
}
  801895:	c9                   	leave  
  801896:	c3                   	ret    

00801897 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801897:	55                   	push   %ebp
  801898:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80189a:	6a 00                	push   $0x0
  80189c:	6a 00                	push   $0x0
  80189e:	6a 00                	push   $0x0
  8018a0:	6a 00                	push   $0x0
  8018a2:	6a 00                	push   $0x0
  8018a4:	6a 09                	push   $0x9
  8018a6:	e8 00 ff ff ff       	call   8017ab <syscall>
  8018ab:	83 c4 18             	add    $0x18,%esp
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	6a 00                	push   $0x0
  8018b9:	6a 00                	push   $0x0
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 0a                	push   $0xa
  8018bf:	e8 e7 fe ff ff       	call   8017ab <syscall>
  8018c4:	83 c4 18             	add    $0x18,%esp
}
  8018c7:	c9                   	leave  
  8018c8:	c3                   	ret    

008018c9 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8018c9:	55                   	push   %ebp
  8018ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8018cc:	6a 00                	push   $0x0
  8018ce:	6a 00                	push   $0x0
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 0b                	push   $0xb
  8018d8:	e8 ce fe ff ff       	call   8017ab <syscall>
  8018dd:	83 c4 18             	add    $0x18,%esp
}
  8018e0:	c9                   	leave  
  8018e1:	c3                   	ret    

008018e2 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8018e2:	55                   	push   %ebp
  8018e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8018e5:	6a 00                	push   $0x0
  8018e7:	6a 00                	push   $0x0
  8018e9:	6a 00                	push   $0x0
  8018eb:	ff 75 0c             	pushl  0xc(%ebp)
  8018ee:	ff 75 08             	pushl  0x8(%ebp)
  8018f1:	6a 0f                	push   $0xf
  8018f3:	e8 b3 fe ff ff       	call   8017ab <syscall>
  8018f8:	83 c4 18             	add    $0x18,%esp
	return;
  8018fb:	90                   	nop
}
  8018fc:	c9                   	leave  
  8018fd:	c3                   	ret    

008018fe <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8018fe:	55                   	push   %ebp
  8018ff:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801901:	6a 00                	push   $0x0
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	ff 75 0c             	pushl  0xc(%ebp)
  80190a:	ff 75 08             	pushl  0x8(%ebp)
  80190d:	6a 10                	push   $0x10
  80190f:	e8 97 fe ff ff       	call   8017ab <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
	return ;
  801917:	90                   	nop
}
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	ff 75 10             	pushl  0x10(%ebp)
  801924:	ff 75 0c             	pushl  0xc(%ebp)
  801927:	ff 75 08             	pushl  0x8(%ebp)
  80192a:	6a 11                	push   $0x11
  80192c:	e8 7a fe ff ff       	call   8017ab <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
	return ;
  801934:	90                   	nop
}
  801935:	c9                   	leave  
  801936:	c3                   	ret    

00801937 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801937:	55                   	push   %ebp
  801938:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	6a 0c                	push   $0xc
  801946:	e8 60 fe ff ff       	call   8017ab <syscall>
  80194b:	83 c4 18             	add    $0x18,%esp
}
  80194e:	c9                   	leave  
  80194f:	c3                   	ret    

00801950 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801950:	55                   	push   %ebp
  801951:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801953:	6a 00                	push   $0x0
  801955:	6a 00                	push   $0x0
  801957:	6a 00                	push   $0x0
  801959:	6a 00                	push   $0x0
  80195b:	ff 75 08             	pushl  0x8(%ebp)
  80195e:	6a 0d                	push   $0xd
  801960:	e8 46 fe ff ff       	call   8017ab <syscall>
  801965:	83 c4 18             	add    $0x18,%esp
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <sys_scarce_memory>:

void sys_scarce_memory()
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80196d:	6a 00                	push   $0x0
  80196f:	6a 00                	push   $0x0
  801971:	6a 00                	push   $0x0
  801973:	6a 00                	push   $0x0
  801975:	6a 00                	push   $0x0
  801977:	6a 0e                	push   $0xe
  801979:	e8 2d fe ff ff       	call   8017ab <syscall>
  80197e:	83 c4 18             	add    $0x18,%esp
}
  801981:	90                   	nop
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	6a 00                	push   $0x0
  80198f:	6a 00                	push   $0x0
  801991:	6a 13                	push   $0x13
  801993:	e8 13 fe ff ff       	call   8017ab <syscall>
  801998:	83 c4 18             	add    $0x18,%esp
}
  80199b:	90                   	nop
  80199c:	c9                   	leave  
  80199d:	c3                   	ret    

0080199e <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80199e:	55                   	push   %ebp
  80199f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 00                	push   $0x0
  8019a7:	6a 00                	push   $0x0
  8019a9:	6a 00                	push   $0x0
  8019ab:	6a 14                	push   $0x14
  8019ad:	e8 f9 fd ff ff       	call   8017ab <syscall>
  8019b2:	83 c4 18             	add    $0x18,%esp
}
  8019b5:	90                   	nop
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_cputc>:


void
sys_cputc(const char c)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
  8019bb:	83 ec 04             	sub    $0x4,%esp
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8019c4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	50                   	push   %eax
  8019d1:	6a 15                	push   $0x15
  8019d3:	e8 d3 fd ff ff       	call   8017ab <syscall>
  8019d8:	83 c4 18             	add    $0x18,%esp
}
  8019db:	90                   	nop
  8019dc:	c9                   	leave  
  8019dd:	c3                   	ret    

008019de <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8019de:	55                   	push   %ebp
  8019df:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	6a 16                	push   $0x16
  8019ed:	e8 b9 fd ff ff       	call   8017ab <syscall>
  8019f2:	83 c4 18             	add    $0x18,%esp
}
  8019f5:	90                   	nop
  8019f6:	c9                   	leave  
  8019f7:	c3                   	ret    

008019f8 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8019f8:	55                   	push   %ebp
  8019f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	ff 75 0c             	pushl  0xc(%ebp)
  801a07:	50                   	push   %eax
  801a08:	6a 17                	push   $0x17
  801a0a:	e8 9c fd ff ff       	call   8017ab <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
}
  801a12:	c9                   	leave  
  801a13:	c3                   	ret    

00801a14 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801a14:	55                   	push   %ebp
  801a15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 00                	push   $0x0
  801a21:	6a 00                	push   $0x0
  801a23:	52                   	push   %edx
  801a24:	50                   	push   %eax
  801a25:	6a 1a                	push   $0x1a
  801a27:	e8 7f fd ff ff       	call   8017ab <syscall>
  801a2c:	83 c4 18             	add    $0x18,%esp
}
  801a2f:	c9                   	leave  
  801a30:	c3                   	ret    

00801a31 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a31:	55                   	push   %ebp
  801a32:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a34:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a37:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 00                	push   $0x0
  801a40:	52                   	push   %edx
  801a41:	50                   	push   %eax
  801a42:	6a 18                	push   $0x18
  801a44:	e8 62 fd ff ff       	call   8017ab <syscall>
  801a49:	83 c4 18             	add    $0x18,%esp
}
  801a4c:	90                   	nop
  801a4d:	c9                   	leave  
  801a4e:	c3                   	ret    

00801a4f <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801a4f:	55                   	push   %ebp
  801a50:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801a52:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a55:	8b 45 08             	mov    0x8(%ebp),%eax
  801a58:	6a 00                	push   $0x0
  801a5a:	6a 00                	push   $0x0
  801a5c:	6a 00                	push   $0x0
  801a5e:	52                   	push   %edx
  801a5f:	50                   	push   %eax
  801a60:	6a 19                	push   $0x19
  801a62:	e8 44 fd ff ff       	call   8017ab <syscall>
  801a67:	83 c4 18             	add    $0x18,%esp
}
  801a6a:	90                   	nop
  801a6b:	c9                   	leave  
  801a6c:	c3                   	ret    

00801a6d <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a6d:	55                   	push   %ebp
  801a6e:	89 e5                	mov    %esp,%ebp
  801a70:	83 ec 04             	sub    $0x4,%esp
  801a73:	8b 45 10             	mov    0x10(%ebp),%eax
  801a76:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a79:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a7c:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a80:	8b 45 08             	mov    0x8(%ebp),%eax
  801a83:	6a 00                	push   $0x0
  801a85:	51                   	push   %ecx
  801a86:	52                   	push   %edx
  801a87:	ff 75 0c             	pushl  0xc(%ebp)
  801a8a:	50                   	push   %eax
  801a8b:	6a 1b                	push   $0x1b
  801a8d:	e8 19 fd ff ff       	call   8017ab <syscall>
  801a92:	83 c4 18             	add    $0x18,%esp
}
  801a95:	c9                   	leave  
  801a96:	c3                   	ret    

00801a97 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a97:	55                   	push   %ebp
  801a98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	52                   	push   %edx
  801aa7:	50                   	push   %eax
  801aa8:	6a 1c                	push   $0x1c
  801aaa:	e8 fc fc ff ff       	call   8017ab <syscall>
  801aaf:	83 c4 18             	add    $0x18,%esp
}
  801ab2:	c9                   	leave  
  801ab3:	c3                   	ret    

00801ab4 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ab4:	55                   	push   %ebp
  801ab5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801ab7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801aba:	8b 55 0c             	mov    0xc(%ebp),%edx
  801abd:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac0:	6a 00                	push   $0x0
  801ac2:	6a 00                	push   $0x0
  801ac4:	51                   	push   %ecx
  801ac5:	52                   	push   %edx
  801ac6:	50                   	push   %eax
  801ac7:	6a 1d                	push   $0x1d
  801ac9:	e8 dd fc ff ff       	call   8017ab <syscall>
  801ace:	83 c4 18             	add    $0x18,%esp
}
  801ad1:	c9                   	leave  
  801ad2:	c3                   	ret    

00801ad3 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801ad3:	55                   	push   %ebp
  801ad4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801ad6:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ad9:	8b 45 08             	mov    0x8(%ebp),%eax
  801adc:	6a 00                	push   $0x0
  801ade:	6a 00                	push   $0x0
  801ae0:	6a 00                	push   $0x0
  801ae2:	52                   	push   %edx
  801ae3:	50                   	push   %eax
  801ae4:	6a 1e                	push   $0x1e
  801ae6:	e8 c0 fc ff ff       	call   8017ab <syscall>
  801aeb:	83 c4 18             	add    $0x18,%esp
}
  801aee:	c9                   	leave  
  801aef:	c3                   	ret    

00801af0 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801af0:	55                   	push   %ebp
  801af1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 1f                	push   $0x1f
  801aff:	e8 a7 fc ff ff       	call   8017ab <syscall>
  801b04:	83 c4 18             	add    $0x18,%esp
}
  801b07:	c9                   	leave  
  801b08:	c3                   	ret    

00801b09 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801b09:	55                   	push   %ebp
  801b0a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b0f:	6a 00                	push   $0x0
  801b11:	ff 75 14             	pushl  0x14(%ebp)
  801b14:	ff 75 10             	pushl  0x10(%ebp)
  801b17:	ff 75 0c             	pushl  0xc(%ebp)
  801b1a:	50                   	push   %eax
  801b1b:	6a 20                	push   $0x20
  801b1d:	e8 89 fc ff ff       	call   8017ab <syscall>
  801b22:	83 c4 18             	add    $0x18,%esp
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801b2a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	50                   	push   %eax
  801b36:	6a 21                	push   $0x21
  801b38:	e8 6e fc ff ff       	call   8017ab <syscall>
  801b3d:	83 c4 18             	add    $0x18,%esp
}
  801b40:	90                   	nop
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801b46:	8b 45 08             	mov    0x8(%ebp),%eax
  801b49:	6a 00                	push   $0x0
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	50                   	push   %eax
  801b52:	6a 22                	push   $0x22
  801b54:	e8 52 fc ff ff       	call   8017ab <syscall>
  801b59:	83 c4 18             	add    $0x18,%esp
}
  801b5c:	c9                   	leave  
  801b5d:	c3                   	ret    

00801b5e <sys_getenvid>:

int32 sys_getenvid(void)
{
  801b5e:	55                   	push   %ebp
  801b5f:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 02                	push   $0x2
  801b6d:	e8 39 fc ff ff       	call   8017ab <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 03                	push   $0x3
  801b86:	e8 20 fc ff ff       	call   8017ab <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	6a 00                	push   $0x0
  801b9b:	6a 00                	push   $0x0
  801b9d:	6a 04                	push   $0x4
  801b9f:	e8 07 fc ff ff       	call   8017ab <syscall>
  801ba4:	83 c4 18             	add    $0x18,%esp
}
  801ba7:	c9                   	leave  
  801ba8:	c3                   	ret    

00801ba9 <sys_exit_env>:


void sys_exit_env(void)
{
  801ba9:	55                   	push   %ebp
  801baa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	6a 00                	push   $0x0
  801bb2:	6a 00                	push   $0x0
  801bb4:	6a 00                	push   $0x0
  801bb6:	6a 23                	push   $0x23
  801bb8:	e8 ee fb ff ff       	call   8017ab <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	90                   	nop
  801bc1:	c9                   	leave  
  801bc2:	c3                   	ret    

00801bc3 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801bc3:	55                   	push   %ebp
  801bc4:	89 e5                	mov    %esp,%ebp
  801bc6:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801bc9:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bcc:	8d 50 04             	lea    0x4(%eax),%edx
  801bcf:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801bd2:	6a 00                	push   $0x0
  801bd4:	6a 00                	push   $0x0
  801bd6:	6a 00                	push   $0x0
  801bd8:	52                   	push   %edx
  801bd9:	50                   	push   %eax
  801bda:	6a 24                	push   $0x24
  801bdc:	e8 ca fb ff ff       	call   8017ab <syscall>
  801be1:	83 c4 18             	add    $0x18,%esp
	return result;
  801be4:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801be7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801bea:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801bed:	89 01                	mov    %eax,(%ecx)
  801bef:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  801bf5:	c9                   	leave  
  801bf6:	c2 04 00             	ret    $0x4

00801bf9 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801bf9:	55                   	push   %ebp
  801bfa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 00                	push   $0x0
  801c00:	ff 75 10             	pushl  0x10(%ebp)
  801c03:	ff 75 0c             	pushl  0xc(%ebp)
  801c06:	ff 75 08             	pushl  0x8(%ebp)
  801c09:	6a 12                	push   $0x12
  801c0b:	e8 9b fb ff ff       	call   8017ab <syscall>
  801c10:	83 c4 18             	add    $0x18,%esp
	return ;
  801c13:	90                   	nop
}
  801c14:	c9                   	leave  
  801c15:	c3                   	ret    

00801c16 <sys_rcr2>:
uint32 sys_rcr2()
{
  801c16:	55                   	push   %ebp
  801c17:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801c19:	6a 00                	push   $0x0
  801c1b:	6a 00                	push   $0x0
  801c1d:	6a 00                	push   $0x0
  801c1f:	6a 00                	push   $0x0
  801c21:	6a 00                	push   $0x0
  801c23:	6a 25                	push   $0x25
  801c25:	e8 81 fb ff ff       	call   8017ab <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
}
  801c2d:	c9                   	leave  
  801c2e:	c3                   	ret    

00801c2f <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801c2f:	55                   	push   %ebp
  801c30:	89 e5                	mov    %esp,%ebp
  801c32:	83 ec 04             	sub    $0x4,%esp
  801c35:	8b 45 08             	mov    0x8(%ebp),%eax
  801c38:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801c3b:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801c3f:	6a 00                	push   $0x0
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	50                   	push   %eax
  801c48:	6a 26                	push   $0x26
  801c4a:	e8 5c fb ff ff       	call   8017ab <syscall>
  801c4f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c52:	90                   	nop
}
  801c53:	c9                   	leave  
  801c54:	c3                   	ret    

00801c55 <rsttst>:
void rsttst()
{
  801c55:	55                   	push   %ebp
  801c56:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801c58:	6a 00                	push   $0x0
  801c5a:	6a 00                	push   $0x0
  801c5c:	6a 00                	push   $0x0
  801c5e:	6a 00                	push   $0x0
  801c60:	6a 00                	push   $0x0
  801c62:	6a 28                	push   $0x28
  801c64:	e8 42 fb ff ff       	call   8017ab <syscall>
  801c69:	83 c4 18             	add    $0x18,%esp
	return ;
  801c6c:	90                   	nop
}
  801c6d:	c9                   	leave  
  801c6e:	c3                   	ret    

00801c6f <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c6f:	55                   	push   %ebp
  801c70:	89 e5                	mov    %esp,%ebp
  801c72:	83 ec 04             	sub    $0x4,%esp
  801c75:	8b 45 14             	mov    0x14(%ebp),%eax
  801c78:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c7b:	8b 55 18             	mov    0x18(%ebp),%edx
  801c7e:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c82:	52                   	push   %edx
  801c83:	50                   	push   %eax
  801c84:	ff 75 10             	pushl  0x10(%ebp)
  801c87:	ff 75 0c             	pushl  0xc(%ebp)
  801c8a:	ff 75 08             	pushl  0x8(%ebp)
  801c8d:	6a 27                	push   $0x27
  801c8f:	e8 17 fb ff ff       	call   8017ab <syscall>
  801c94:	83 c4 18             	add    $0x18,%esp
	return ;
  801c97:	90                   	nop
}
  801c98:	c9                   	leave  
  801c99:	c3                   	ret    

00801c9a <chktst>:
void chktst(uint32 n)
{
  801c9a:	55                   	push   %ebp
  801c9b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c9d:	6a 00                	push   $0x0
  801c9f:	6a 00                	push   $0x0
  801ca1:	6a 00                	push   $0x0
  801ca3:	6a 00                	push   $0x0
  801ca5:	ff 75 08             	pushl  0x8(%ebp)
  801ca8:	6a 29                	push   $0x29
  801caa:	e8 fc fa ff ff       	call   8017ab <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
	return ;
  801cb2:	90                   	nop
}
  801cb3:	c9                   	leave  
  801cb4:	c3                   	ret    

00801cb5 <inctst>:

void inctst()
{
  801cb5:	55                   	push   %ebp
  801cb6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 00                	push   $0x0
  801cbe:	6a 00                	push   $0x0
  801cc0:	6a 00                	push   $0x0
  801cc2:	6a 2a                	push   $0x2a
  801cc4:	e8 e2 fa ff ff       	call   8017ab <syscall>
  801cc9:	83 c4 18             	add    $0x18,%esp
	return ;
  801ccc:	90                   	nop
}
  801ccd:	c9                   	leave  
  801cce:	c3                   	ret    

00801ccf <gettst>:
uint32 gettst()
{
  801ccf:	55                   	push   %ebp
  801cd0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	6a 00                	push   $0x0
  801cda:	6a 00                	push   $0x0
  801cdc:	6a 2b                	push   $0x2b
  801cde:	e8 c8 fa ff ff       	call   8017ab <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 00                	push   $0x0
  801cf2:	6a 00                	push   $0x0
  801cf4:	6a 00                	push   $0x0
  801cf6:	6a 00                	push   $0x0
  801cf8:	6a 2c                	push   $0x2c
  801cfa:	e8 ac fa ff ff       	call   8017ab <syscall>
  801cff:	83 c4 18             	add    $0x18,%esp
  801d02:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801d05:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801d09:	75 07                	jne    801d12 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801d0b:	b8 01 00 00 00       	mov    $0x1,%eax
  801d10:	eb 05                	jmp    801d17 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801d12:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d17:	c9                   	leave  
  801d18:	c3                   	ret    

00801d19 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801d19:	55                   	push   %ebp
  801d1a:	89 e5                	mov    %esp,%ebp
  801d1c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 00                	push   $0x0
  801d23:	6a 00                	push   $0x0
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 2c                	push   $0x2c
  801d2b:	e8 7b fa ff ff       	call   8017ab <syscall>
  801d30:	83 c4 18             	add    $0x18,%esp
  801d33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801d36:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801d3a:	75 07                	jne    801d43 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801d3c:	b8 01 00 00 00       	mov    $0x1,%eax
  801d41:	eb 05                	jmp    801d48 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801d43:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d48:	c9                   	leave  
  801d49:	c3                   	ret    

00801d4a <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801d4a:	55                   	push   %ebp
  801d4b:	89 e5                	mov    %esp,%ebp
  801d4d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d50:	6a 00                	push   $0x0
  801d52:	6a 00                	push   $0x0
  801d54:	6a 00                	push   $0x0
  801d56:	6a 00                	push   $0x0
  801d58:	6a 00                	push   $0x0
  801d5a:	6a 2c                	push   $0x2c
  801d5c:	e8 4a fa ff ff       	call   8017ab <syscall>
  801d61:	83 c4 18             	add    $0x18,%esp
  801d64:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801d67:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d6b:	75 07                	jne    801d74 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d6d:	b8 01 00 00 00       	mov    $0x1,%eax
  801d72:	eb 05                	jmp    801d79 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d74:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d79:	c9                   	leave  
  801d7a:	c3                   	ret    

00801d7b <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d7b:	55                   	push   %ebp
  801d7c:	89 e5                	mov    %esp,%ebp
  801d7e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d81:	6a 00                	push   $0x0
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	6a 00                	push   $0x0
  801d8b:	6a 2c                	push   $0x2c
  801d8d:	e8 19 fa ff ff       	call   8017ab <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
  801d95:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d98:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d9c:	75 07                	jne    801da5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d9e:	b8 01 00 00 00       	mov    $0x1,%eax
  801da3:	eb 05                	jmp    801daa <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801da5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801daa:	c9                   	leave  
  801dab:	c3                   	ret    

00801dac <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801dac:	55                   	push   %ebp
  801dad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801daf:	6a 00                	push   $0x0
  801db1:	6a 00                	push   $0x0
  801db3:	6a 00                	push   $0x0
  801db5:	6a 00                	push   $0x0
  801db7:	ff 75 08             	pushl  0x8(%ebp)
  801dba:	6a 2d                	push   $0x2d
  801dbc:	e8 ea f9 ff ff       	call   8017ab <syscall>
  801dc1:	83 c4 18             	add    $0x18,%esp
	return ;
  801dc4:	90                   	nop
}
  801dc5:	c9                   	leave  
  801dc6:	c3                   	ret    

00801dc7 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801dc7:	55                   	push   %ebp
  801dc8:	89 e5                	mov    %esp,%ebp
  801dca:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801dcb:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801dce:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dd1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  801dd7:	6a 00                	push   $0x0
  801dd9:	53                   	push   %ebx
  801dda:	51                   	push   %ecx
  801ddb:	52                   	push   %edx
  801ddc:	50                   	push   %eax
  801ddd:	6a 2e                	push   $0x2e
  801ddf:	e8 c7 f9 ff ff       	call   8017ab <syscall>
  801de4:	83 c4 18             	add    $0x18,%esp
}
  801de7:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801dea:	c9                   	leave  
  801deb:	c3                   	ret    

00801dec <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801dec:	55                   	push   %ebp
  801ded:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801def:	8b 55 0c             	mov    0xc(%ebp),%edx
  801df2:	8b 45 08             	mov    0x8(%ebp),%eax
  801df5:	6a 00                	push   $0x0
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	52                   	push   %edx
  801dfc:	50                   	push   %eax
  801dfd:	6a 2f                	push   $0x2f
  801dff:	e8 a7 f9 ff ff       	call   8017ab <syscall>
  801e04:	83 c4 18             	add    $0x18,%esp
}
  801e07:	c9                   	leave  
  801e08:	c3                   	ret    

00801e09 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801e09:	55                   	push   %ebp
  801e0a:	89 e5                	mov    %esp,%ebp
  801e0c:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801e0f:	83 ec 0c             	sub    $0xc,%esp
  801e12:	68 60 39 80 00       	push   $0x803960
  801e17:	e8 3e e6 ff ff       	call   80045a <cprintf>
  801e1c:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801e1f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801e26:	83 ec 0c             	sub    $0xc,%esp
  801e29:	68 8c 39 80 00       	push   $0x80398c
  801e2e:	e8 27 e6 ff ff       	call   80045a <cprintf>
  801e33:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801e36:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e3a:	a1 38 41 80 00       	mov    0x804138,%eax
  801e3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e42:	eb 56                	jmp    801e9a <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e44:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e48:	74 1c                	je     801e66 <print_mem_block_lists+0x5d>
  801e4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4d:	8b 50 08             	mov    0x8(%eax),%edx
  801e50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e53:	8b 48 08             	mov    0x8(%eax),%ecx
  801e56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e59:	8b 40 0c             	mov    0xc(%eax),%eax
  801e5c:	01 c8                	add    %ecx,%eax
  801e5e:	39 c2                	cmp    %eax,%edx
  801e60:	73 04                	jae    801e66 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801e62:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e69:	8b 50 08             	mov    0x8(%eax),%edx
  801e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e6f:	8b 40 0c             	mov    0xc(%eax),%eax
  801e72:	01 c2                	add    %eax,%edx
  801e74:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e77:	8b 40 08             	mov    0x8(%eax),%eax
  801e7a:	83 ec 04             	sub    $0x4,%esp
  801e7d:	52                   	push   %edx
  801e7e:	50                   	push   %eax
  801e7f:	68 a1 39 80 00       	push   $0x8039a1
  801e84:	e8 d1 e5 ff ff       	call   80045a <cprintf>
  801e89:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801e92:	a1 40 41 80 00       	mov    0x804140,%eax
  801e97:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e9e:	74 07                	je     801ea7 <print_mem_block_lists+0x9e>
  801ea0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801ea3:	8b 00                	mov    (%eax),%eax
  801ea5:	eb 05                	jmp    801eac <print_mem_block_lists+0xa3>
  801ea7:	b8 00 00 00 00       	mov    $0x0,%eax
  801eac:	a3 40 41 80 00       	mov    %eax,0x804140
  801eb1:	a1 40 41 80 00       	mov    0x804140,%eax
  801eb6:	85 c0                	test   %eax,%eax
  801eb8:	75 8a                	jne    801e44 <print_mem_block_lists+0x3b>
  801eba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ebe:	75 84                	jne    801e44 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801ec0:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801ec4:	75 10                	jne    801ed6 <print_mem_block_lists+0xcd>
  801ec6:	83 ec 0c             	sub    $0xc,%esp
  801ec9:	68 b0 39 80 00       	push   $0x8039b0
  801ece:	e8 87 e5 ff ff       	call   80045a <cprintf>
  801ed3:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801ed6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801edd:	83 ec 0c             	sub    $0xc,%esp
  801ee0:	68 d4 39 80 00       	push   $0x8039d4
  801ee5:	e8 70 e5 ff ff       	call   80045a <cprintf>
  801eea:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801eed:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801ef1:	a1 40 40 80 00       	mov    0x804040,%eax
  801ef6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801ef9:	eb 56                	jmp    801f51 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801efb:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801eff:	74 1c                	je     801f1d <print_mem_block_lists+0x114>
  801f01:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f04:	8b 50 08             	mov    0x8(%eax),%edx
  801f07:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0a:	8b 48 08             	mov    0x8(%eax),%ecx
  801f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f10:	8b 40 0c             	mov    0xc(%eax),%eax
  801f13:	01 c8                	add    %ecx,%eax
  801f15:	39 c2                	cmp    %eax,%edx
  801f17:	73 04                	jae    801f1d <print_mem_block_lists+0x114>
			sorted = 0 ;
  801f19:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801f1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f20:	8b 50 08             	mov    0x8(%eax),%edx
  801f23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f26:	8b 40 0c             	mov    0xc(%eax),%eax
  801f29:	01 c2                	add    %eax,%edx
  801f2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f2e:	8b 40 08             	mov    0x8(%eax),%eax
  801f31:	83 ec 04             	sub    $0x4,%esp
  801f34:	52                   	push   %edx
  801f35:	50                   	push   %eax
  801f36:	68 a1 39 80 00       	push   $0x8039a1
  801f3b:	e8 1a e5 ff ff       	call   80045a <cprintf>
  801f40:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801f43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f46:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801f49:	a1 48 40 80 00       	mov    0x804048,%eax
  801f4e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801f51:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f55:	74 07                	je     801f5e <print_mem_block_lists+0x155>
  801f57:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f5a:	8b 00                	mov    (%eax),%eax
  801f5c:	eb 05                	jmp    801f63 <print_mem_block_lists+0x15a>
  801f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  801f63:	a3 48 40 80 00       	mov    %eax,0x804048
  801f68:	a1 48 40 80 00       	mov    0x804048,%eax
  801f6d:	85 c0                	test   %eax,%eax
  801f6f:	75 8a                	jne    801efb <print_mem_block_lists+0xf2>
  801f71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f75:	75 84                	jne    801efb <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801f77:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801f7b:	75 10                	jne    801f8d <print_mem_block_lists+0x184>
  801f7d:	83 ec 0c             	sub    $0xc,%esp
  801f80:	68 ec 39 80 00       	push   $0x8039ec
  801f85:	e8 d0 e4 ff ff       	call   80045a <cprintf>
  801f8a:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801f8d:	83 ec 0c             	sub    $0xc,%esp
  801f90:	68 60 39 80 00       	push   $0x803960
  801f95:	e8 c0 e4 ff ff       	call   80045a <cprintf>
  801f9a:	83 c4 10             	add    $0x10,%esp

}
  801f9d:	90                   	nop
  801f9e:	c9                   	leave  
  801f9f:	c3                   	ret    

00801fa0 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801fa0:	55                   	push   %ebp
  801fa1:	89 e5                	mov    %esp,%ebp
  801fa3:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801fa6:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801fad:	00 00 00 
  801fb0:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801fb7:	00 00 00 
  801fba:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801fc1:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  801fc4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801fcb:	e9 9e 00 00 00       	jmp    80206e <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  801fd0:	a1 50 40 80 00       	mov    0x804050,%eax
  801fd5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801fd8:	c1 e2 04             	shl    $0x4,%edx
  801fdb:	01 d0                	add    %edx,%eax
  801fdd:	85 c0                	test   %eax,%eax
  801fdf:	75 14                	jne    801ff5 <initialize_MemBlocksList+0x55>
  801fe1:	83 ec 04             	sub    $0x4,%esp
  801fe4:	68 14 3a 80 00       	push   $0x803a14
  801fe9:	6a 3d                	push   $0x3d
  801feb:	68 37 3a 80 00       	push   $0x803a37
  801ff0:	e8 69 0f 00 00       	call   802f5e <_panic>
  801ff5:	a1 50 40 80 00       	mov    0x804050,%eax
  801ffa:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ffd:	c1 e2 04             	shl    $0x4,%edx
  802000:	01 d0                	add    %edx,%eax
  802002:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802008:	89 10                	mov    %edx,(%eax)
  80200a:	8b 00                	mov    (%eax),%eax
  80200c:	85 c0                	test   %eax,%eax
  80200e:	74 18                	je     802028 <initialize_MemBlocksList+0x88>
  802010:	a1 48 41 80 00       	mov    0x804148,%eax
  802015:	8b 15 50 40 80 00    	mov    0x804050,%edx
  80201b:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80201e:	c1 e1 04             	shl    $0x4,%ecx
  802021:	01 ca                	add    %ecx,%edx
  802023:	89 50 04             	mov    %edx,0x4(%eax)
  802026:	eb 12                	jmp    80203a <initialize_MemBlocksList+0x9a>
  802028:	a1 50 40 80 00       	mov    0x804050,%eax
  80202d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802030:	c1 e2 04             	shl    $0x4,%edx
  802033:	01 d0                	add    %edx,%eax
  802035:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80203a:	a1 50 40 80 00       	mov    0x804050,%eax
  80203f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802042:	c1 e2 04             	shl    $0x4,%edx
  802045:	01 d0                	add    %edx,%eax
  802047:	a3 48 41 80 00       	mov    %eax,0x804148
  80204c:	a1 50 40 80 00       	mov    0x804050,%eax
  802051:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802054:	c1 e2 04             	shl    $0x4,%edx
  802057:	01 d0                	add    %edx,%eax
  802059:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802060:	a1 54 41 80 00       	mov    0x804154,%eax
  802065:	40                   	inc    %eax
  802066:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80206b:	ff 45 f4             	incl   -0xc(%ebp)
  80206e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802071:	3b 45 08             	cmp    0x8(%ebp),%eax
  802074:	0f 82 56 ff ff ff    	jb     801fd0 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  80207a:	90                   	nop
  80207b:	c9                   	leave  
  80207c:	c3                   	ret    

0080207d <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80207d:	55                   	push   %ebp
  80207e:	89 e5                	mov    %esp,%ebp
  802080:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802083:	8b 45 08             	mov    0x8(%ebp),%eax
  802086:	8b 00                	mov    (%eax),%eax
  802088:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80208b:	eb 18                	jmp    8020a5 <find_block+0x28>

		if(tmp->sva == va){
  80208d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802090:	8b 40 08             	mov    0x8(%eax),%eax
  802093:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802096:	75 05                	jne    80209d <find_block+0x20>
			return tmp ;
  802098:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80209b:	eb 11                	jmp    8020ae <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  80209d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8020a0:	8b 00                	mov    (%eax),%eax
  8020a2:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8020a5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8020a9:	75 e2                	jne    80208d <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8020ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8020ae:	c9                   	leave  
  8020af:	c3                   	ret    

008020b0 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8020b0:	55                   	push   %ebp
  8020b1:	89 e5                	mov    %esp,%ebp
  8020b3:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8020b6:	a1 40 40 80 00       	mov    0x804040,%eax
  8020bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8020be:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8020c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8020ca:	75 65                	jne    802131 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8020cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020d0:	75 14                	jne    8020e6 <insert_sorted_allocList+0x36>
  8020d2:	83 ec 04             	sub    $0x4,%esp
  8020d5:	68 14 3a 80 00       	push   $0x803a14
  8020da:	6a 62                	push   $0x62
  8020dc:	68 37 3a 80 00       	push   $0x803a37
  8020e1:	e8 78 0e 00 00       	call   802f5e <_panic>
  8020e6:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8020ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ef:	89 10                	mov    %edx,(%eax)
  8020f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020f4:	8b 00                	mov    (%eax),%eax
  8020f6:	85 c0                	test   %eax,%eax
  8020f8:	74 0d                	je     802107 <insert_sorted_allocList+0x57>
  8020fa:	a1 40 40 80 00       	mov    0x804040,%eax
  8020ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802102:	89 50 04             	mov    %edx,0x4(%eax)
  802105:	eb 08                	jmp    80210f <insert_sorted_allocList+0x5f>
  802107:	8b 45 08             	mov    0x8(%ebp),%eax
  80210a:	a3 44 40 80 00       	mov    %eax,0x804044
  80210f:	8b 45 08             	mov    0x8(%ebp),%eax
  802112:	a3 40 40 80 00       	mov    %eax,0x804040
  802117:	8b 45 08             	mov    0x8(%ebp),%eax
  80211a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802121:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802126:	40                   	inc    %eax
  802127:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80212c:	e9 14 01 00 00       	jmp    802245 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	8b 50 08             	mov    0x8(%eax),%edx
  802137:	a1 44 40 80 00       	mov    0x804044,%eax
  80213c:	8b 40 08             	mov    0x8(%eax),%eax
  80213f:	39 c2                	cmp    %eax,%edx
  802141:	76 65                	jbe    8021a8 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802143:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802147:	75 14                	jne    80215d <insert_sorted_allocList+0xad>
  802149:	83 ec 04             	sub    $0x4,%esp
  80214c:	68 50 3a 80 00       	push   $0x803a50
  802151:	6a 64                	push   $0x64
  802153:	68 37 3a 80 00       	push   $0x803a37
  802158:	e8 01 0e 00 00       	call   802f5e <_panic>
  80215d:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802163:	8b 45 08             	mov    0x8(%ebp),%eax
  802166:	89 50 04             	mov    %edx,0x4(%eax)
  802169:	8b 45 08             	mov    0x8(%ebp),%eax
  80216c:	8b 40 04             	mov    0x4(%eax),%eax
  80216f:	85 c0                	test   %eax,%eax
  802171:	74 0c                	je     80217f <insert_sorted_allocList+0xcf>
  802173:	a1 44 40 80 00       	mov    0x804044,%eax
  802178:	8b 55 08             	mov    0x8(%ebp),%edx
  80217b:	89 10                	mov    %edx,(%eax)
  80217d:	eb 08                	jmp    802187 <insert_sorted_allocList+0xd7>
  80217f:	8b 45 08             	mov    0x8(%ebp),%eax
  802182:	a3 40 40 80 00       	mov    %eax,0x804040
  802187:	8b 45 08             	mov    0x8(%ebp),%eax
  80218a:	a3 44 40 80 00       	mov    %eax,0x804044
  80218f:	8b 45 08             	mov    0x8(%ebp),%eax
  802192:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802198:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80219d:	40                   	inc    %eax
  80219e:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8021a3:	e9 9d 00 00 00       	jmp    802245 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8021a8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8021af:	e9 85 00 00 00       	jmp    802239 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8021b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b7:	8b 50 08             	mov    0x8(%eax),%edx
  8021ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bd:	8b 40 08             	mov    0x8(%eax),%eax
  8021c0:	39 c2                	cmp    %eax,%edx
  8021c2:	73 6a                	jae    80222e <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8021c4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8021c8:	74 06                	je     8021d0 <insert_sorted_allocList+0x120>
  8021ca:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8021ce:	75 14                	jne    8021e4 <insert_sorted_allocList+0x134>
  8021d0:	83 ec 04             	sub    $0x4,%esp
  8021d3:	68 74 3a 80 00       	push   $0x803a74
  8021d8:	6a 6b                	push   $0x6b
  8021da:	68 37 3a 80 00       	push   $0x803a37
  8021df:	e8 7a 0d 00 00       	call   802f5e <_panic>
  8021e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021e7:	8b 50 04             	mov    0x4(%eax),%edx
  8021ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8021ed:	89 50 04             	mov    %edx,0x4(%eax)
  8021f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021f3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f6:	89 10                	mov    %edx,(%eax)
  8021f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021fb:	8b 40 04             	mov    0x4(%eax),%eax
  8021fe:	85 c0                	test   %eax,%eax
  802200:	74 0d                	je     80220f <insert_sorted_allocList+0x15f>
  802202:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802205:	8b 40 04             	mov    0x4(%eax),%eax
  802208:	8b 55 08             	mov    0x8(%ebp),%edx
  80220b:	89 10                	mov    %edx,(%eax)
  80220d:	eb 08                	jmp    802217 <insert_sorted_allocList+0x167>
  80220f:	8b 45 08             	mov    0x8(%ebp),%eax
  802212:	a3 40 40 80 00       	mov    %eax,0x804040
  802217:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80221a:	8b 55 08             	mov    0x8(%ebp),%edx
  80221d:	89 50 04             	mov    %edx,0x4(%eax)
  802220:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802225:	40                   	inc    %eax
  802226:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  80222b:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80222c:	eb 17                	jmp    802245 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  80222e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802231:	8b 00                	mov    (%eax),%eax
  802233:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802236:	ff 45 f0             	incl   -0x10(%ebp)
  802239:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80223c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  80223f:	0f 8c 6f ff ff ff    	jl     8021b4 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802245:	90                   	nop
  802246:	c9                   	leave  
  802247:	c3                   	ret    

00802248 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802248:	55                   	push   %ebp
  802249:	89 e5                	mov    %esp,%ebp
  80224b:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  80224e:	a1 38 41 80 00       	mov    0x804138,%eax
  802253:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802256:	e9 7c 01 00 00       	jmp    8023d7 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  80225b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225e:	8b 40 0c             	mov    0xc(%eax),%eax
  802261:	3b 45 08             	cmp    0x8(%ebp),%eax
  802264:	0f 86 cf 00 00 00    	jbe    802339 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80226a:	a1 48 41 80 00       	mov    0x804148,%eax
  80226f:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802272:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802275:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802278:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80227b:	8b 55 08             	mov    0x8(%ebp),%edx
  80227e:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802281:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802284:	8b 50 08             	mov    0x8(%eax),%edx
  802287:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80228a:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  80228d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802290:	8b 40 0c             	mov    0xc(%eax),%eax
  802293:	2b 45 08             	sub    0x8(%ebp),%eax
  802296:	89 c2                	mov    %eax,%edx
  802298:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80229b:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  80229e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a1:	8b 50 08             	mov    0x8(%eax),%edx
  8022a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8022a7:	01 c2                	add    %eax,%edx
  8022a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ac:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8022af:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8022b3:	75 17                	jne    8022cc <alloc_block_FF+0x84>
  8022b5:	83 ec 04             	sub    $0x4,%esp
  8022b8:	68 a9 3a 80 00       	push   $0x803aa9
  8022bd:	68 83 00 00 00       	push   $0x83
  8022c2:	68 37 3a 80 00       	push   $0x803a37
  8022c7:	e8 92 0c 00 00       	call   802f5e <_panic>
  8022cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022cf:	8b 00                	mov    (%eax),%eax
  8022d1:	85 c0                	test   %eax,%eax
  8022d3:	74 10                	je     8022e5 <alloc_block_FF+0x9d>
  8022d5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022d8:	8b 00                	mov    (%eax),%eax
  8022da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8022dd:	8b 52 04             	mov    0x4(%edx),%edx
  8022e0:	89 50 04             	mov    %edx,0x4(%eax)
  8022e3:	eb 0b                	jmp    8022f0 <alloc_block_FF+0xa8>
  8022e5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022e8:	8b 40 04             	mov    0x4(%eax),%eax
  8022eb:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8022f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022f3:	8b 40 04             	mov    0x4(%eax),%eax
  8022f6:	85 c0                	test   %eax,%eax
  8022f8:	74 0f                	je     802309 <alloc_block_FF+0xc1>
  8022fa:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8022fd:	8b 40 04             	mov    0x4(%eax),%eax
  802300:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802303:	8b 12                	mov    (%edx),%edx
  802305:	89 10                	mov    %edx,(%eax)
  802307:	eb 0a                	jmp    802313 <alloc_block_FF+0xcb>
  802309:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80230c:	8b 00                	mov    (%eax),%eax
  80230e:	a3 48 41 80 00       	mov    %eax,0x804148
  802313:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802316:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80231c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80231f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802326:	a1 54 41 80 00       	mov    0x804154,%eax
  80232b:	48                   	dec    %eax
  80232c:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  802331:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802334:	e9 ad 00 00 00       	jmp    8023e6 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802339:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80233c:	8b 40 0c             	mov    0xc(%eax),%eax
  80233f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802342:	0f 85 87 00 00 00    	jne    8023cf <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802348:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80234c:	75 17                	jne    802365 <alloc_block_FF+0x11d>
  80234e:	83 ec 04             	sub    $0x4,%esp
  802351:	68 a9 3a 80 00       	push   $0x803aa9
  802356:	68 87 00 00 00       	push   $0x87
  80235b:	68 37 3a 80 00       	push   $0x803a37
  802360:	e8 f9 0b 00 00       	call   802f5e <_panic>
  802365:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802368:	8b 00                	mov    (%eax),%eax
  80236a:	85 c0                	test   %eax,%eax
  80236c:	74 10                	je     80237e <alloc_block_FF+0x136>
  80236e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802371:	8b 00                	mov    (%eax),%eax
  802373:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802376:	8b 52 04             	mov    0x4(%edx),%edx
  802379:	89 50 04             	mov    %edx,0x4(%eax)
  80237c:	eb 0b                	jmp    802389 <alloc_block_FF+0x141>
  80237e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802381:	8b 40 04             	mov    0x4(%eax),%eax
  802384:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802389:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238c:	8b 40 04             	mov    0x4(%eax),%eax
  80238f:	85 c0                	test   %eax,%eax
  802391:	74 0f                	je     8023a2 <alloc_block_FF+0x15a>
  802393:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802396:	8b 40 04             	mov    0x4(%eax),%eax
  802399:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239c:	8b 12                	mov    (%edx),%edx
  80239e:	89 10                	mov    %edx,(%eax)
  8023a0:	eb 0a                	jmp    8023ac <alloc_block_FF+0x164>
  8023a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a5:	8b 00                	mov    (%eax),%eax
  8023a7:	a3 38 41 80 00       	mov    %eax,0x804138
  8023ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023af:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023bf:	a1 44 41 80 00       	mov    0x804144,%eax
  8023c4:	48                   	dec    %eax
  8023c5:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	eb 17                	jmp    8023e6 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8023cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d2:	8b 00                	mov    (%eax),%eax
  8023d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8023d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8023db:	0f 85 7a fe ff ff    	jne    80225b <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8023e1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8023e6:	c9                   	leave  
  8023e7:	c3                   	ret    

008023e8 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8023e8:	55                   	push   %ebp
  8023e9:	89 e5                	mov    %esp,%ebp
  8023eb:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8023ee:	a1 38 41 80 00       	mov    0x804138,%eax
  8023f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8023f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8023fd:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802404:	a1 38 41 80 00       	mov    0x804138,%eax
  802409:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80240c:	e9 d0 00 00 00       	jmp    8024e1 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802414:	8b 40 0c             	mov    0xc(%eax),%eax
  802417:	3b 45 08             	cmp    0x8(%ebp),%eax
  80241a:	0f 82 b8 00 00 00    	jb     8024d8 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802420:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802423:	8b 40 0c             	mov    0xc(%eax),%eax
  802426:	2b 45 08             	sub    0x8(%ebp),%eax
  802429:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  80242c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80242f:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802432:	0f 83 a1 00 00 00    	jae    8024d9 <alloc_block_BF+0xf1>
				differsize = differance ;
  802438:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80243b:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  80243e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802441:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802444:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802448:	0f 85 8b 00 00 00    	jne    8024d9 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  80244e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802452:	75 17                	jne    80246b <alloc_block_BF+0x83>
  802454:	83 ec 04             	sub    $0x4,%esp
  802457:	68 a9 3a 80 00       	push   $0x803aa9
  80245c:	68 a0 00 00 00       	push   $0xa0
  802461:	68 37 3a 80 00       	push   $0x803a37
  802466:	e8 f3 0a 00 00       	call   802f5e <_panic>
  80246b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80246e:	8b 00                	mov    (%eax),%eax
  802470:	85 c0                	test   %eax,%eax
  802472:	74 10                	je     802484 <alloc_block_BF+0x9c>
  802474:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802477:	8b 00                	mov    (%eax),%eax
  802479:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80247c:	8b 52 04             	mov    0x4(%edx),%edx
  80247f:	89 50 04             	mov    %edx,0x4(%eax)
  802482:	eb 0b                	jmp    80248f <alloc_block_BF+0xa7>
  802484:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802487:	8b 40 04             	mov    0x4(%eax),%eax
  80248a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80248f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802492:	8b 40 04             	mov    0x4(%eax),%eax
  802495:	85 c0                	test   %eax,%eax
  802497:	74 0f                	je     8024a8 <alloc_block_BF+0xc0>
  802499:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249c:	8b 40 04             	mov    0x4(%eax),%eax
  80249f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8024a2:	8b 12                	mov    (%edx),%edx
  8024a4:	89 10                	mov    %edx,(%eax)
  8024a6:	eb 0a                	jmp    8024b2 <alloc_block_BF+0xca>
  8024a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ab:	8b 00                	mov    (%eax),%eax
  8024ad:	a3 38 41 80 00       	mov    %eax,0x804138
  8024b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024c5:	a1 44 41 80 00       	mov    0x804144,%eax
  8024ca:	48                   	dec    %eax
  8024cb:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8024d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d3:	e9 0c 01 00 00       	jmp    8025e4 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8024d8:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8024d9:	a1 40 41 80 00       	mov    0x804140,%eax
  8024de:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024e1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024e5:	74 07                	je     8024ee <alloc_block_BF+0x106>
  8024e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024ea:	8b 00                	mov    (%eax),%eax
  8024ec:	eb 05                	jmp    8024f3 <alloc_block_BF+0x10b>
  8024ee:	b8 00 00 00 00       	mov    $0x0,%eax
  8024f3:	a3 40 41 80 00       	mov    %eax,0x804140
  8024f8:	a1 40 41 80 00       	mov    0x804140,%eax
  8024fd:	85 c0                	test   %eax,%eax
  8024ff:	0f 85 0c ff ff ff    	jne    802411 <alloc_block_BF+0x29>
  802505:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802509:	0f 85 02 ff ff ff    	jne    802411 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  80250f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802513:	0f 84 c6 00 00 00    	je     8025df <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802519:	a1 48 41 80 00       	mov    0x804148,%eax
  80251e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802521:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802524:	8b 55 08             	mov    0x8(%ebp),%edx
  802527:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  80252a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80252d:	8b 50 08             	mov    0x8(%eax),%edx
  802530:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802533:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802536:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802539:	8b 40 0c             	mov    0xc(%eax),%eax
  80253c:	2b 45 08             	sub    0x8(%ebp),%eax
  80253f:	89 c2                	mov    %eax,%edx
  802541:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802544:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802547:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80254a:	8b 50 08             	mov    0x8(%eax),%edx
  80254d:	8b 45 08             	mov    0x8(%ebp),%eax
  802550:	01 c2                	add    %eax,%edx
  802552:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802555:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802558:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80255c:	75 17                	jne    802575 <alloc_block_BF+0x18d>
  80255e:	83 ec 04             	sub    $0x4,%esp
  802561:	68 a9 3a 80 00       	push   $0x803aa9
  802566:	68 af 00 00 00       	push   $0xaf
  80256b:	68 37 3a 80 00       	push   $0x803a37
  802570:	e8 e9 09 00 00       	call   802f5e <_panic>
  802575:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802578:	8b 00                	mov    (%eax),%eax
  80257a:	85 c0                	test   %eax,%eax
  80257c:	74 10                	je     80258e <alloc_block_BF+0x1a6>
  80257e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802581:	8b 00                	mov    (%eax),%eax
  802583:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802586:	8b 52 04             	mov    0x4(%edx),%edx
  802589:	89 50 04             	mov    %edx,0x4(%eax)
  80258c:	eb 0b                	jmp    802599 <alloc_block_BF+0x1b1>
  80258e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802591:	8b 40 04             	mov    0x4(%eax),%eax
  802594:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802599:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80259c:	8b 40 04             	mov    0x4(%eax),%eax
  80259f:	85 c0                	test   %eax,%eax
  8025a1:	74 0f                	je     8025b2 <alloc_block_BF+0x1ca>
  8025a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025a6:	8b 40 04             	mov    0x4(%eax),%eax
  8025a9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8025ac:	8b 12                	mov    (%edx),%edx
  8025ae:	89 10                	mov    %edx,(%eax)
  8025b0:	eb 0a                	jmp    8025bc <alloc_block_BF+0x1d4>
  8025b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025b5:	8b 00                	mov    (%eax),%eax
  8025b7:	a3 48 41 80 00       	mov    %eax,0x804148
  8025bc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025bf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025c8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025cf:	a1 54 41 80 00       	mov    0x804154,%eax
  8025d4:	48                   	dec    %eax
  8025d5:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8025da:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8025dd:	eb 05                	jmp    8025e4 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8025df:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025e4:	c9                   	leave  
  8025e5:	c3                   	ret    

008025e6 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8025e6:	55                   	push   %ebp
  8025e7:	89 e5                	mov    %esp,%ebp
  8025e9:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8025ec:	a1 38 41 80 00       	mov    0x804138,%eax
  8025f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8025f4:	e9 7c 01 00 00       	jmp    802775 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802602:	0f 86 cf 00 00 00    	jbe    8026d7 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802608:	a1 48 41 80 00       	mov    0x804148,%eax
  80260d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802610:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802613:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802616:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802619:	8b 55 08             	mov    0x8(%ebp),%edx
  80261c:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  80261f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802622:	8b 50 08             	mov    0x8(%eax),%edx
  802625:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802628:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  80262b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80262e:	8b 40 0c             	mov    0xc(%eax),%eax
  802631:	2b 45 08             	sub    0x8(%ebp),%eax
  802634:	89 c2                	mov    %eax,%edx
  802636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802639:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  80263c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263f:	8b 50 08             	mov    0x8(%eax),%edx
  802642:	8b 45 08             	mov    0x8(%ebp),%eax
  802645:	01 c2                	add    %eax,%edx
  802647:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264a:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80264d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802651:	75 17                	jne    80266a <alloc_block_NF+0x84>
  802653:	83 ec 04             	sub    $0x4,%esp
  802656:	68 a9 3a 80 00       	push   $0x803aa9
  80265b:	68 c4 00 00 00       	push   $0xc4
  802660:	68 37 3a 80 00       	push   $0x803a37
  802665:	e8 f4 08 00 00       	call   802f5e <_panic>
  80266a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80266d:	8b 00                	mov    (%eax),%eax
  80266f:	85 c0                	test   %eax,%eax
  802671:	74 10                	je     802683 <alloc_block_NF+0x9d>
  802673:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802676:	8b 00                	mov    (%eax),%eax
  802678:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80267b:	8b 52 04             	mov    0x4(%edx),%edx
  80267e:	89 50 04             	mov    %edx,0x4(%eax)
  802681:	eb 0b                	jmp    80268e <alloc_block_NF+0xa8>
  802683:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802686:	8b 40 04             	mov    0x4(%eax),%eax
  802689:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80268e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802691:	8b 40 04             	mov    0x4(%eax),%eax
  802694:	85 c0                	test   %eax,%eax
  802696:	74 0f                	je     8026a7 <alloc_block_NF+0xc1>
  802698:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80269b:	8b 40 04             	mov    0x4(%eax),%eax
  80269e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8026a1:	8b 12                	mov    (%edx),%edx
  8026a3:	89 10                	mov    %edx,(%eax)
  8026a5:	eb 0a                	jmp    8026b1 <alloc_block_NF+0xcb>
  8026a7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026aa:	8b 00                	mov    (%eax),%eax
  8026ac:	a3 48 41 80 00       	mov    %eax,0x804148
  8026b1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8026ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026bd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8026c4:	a1 54 41 80 00       	mov    0x804154,%eax
  8026c9:	48                   	dec    %eax
  8026ca:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8026cf:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8026d2:	e9 ad 00 00 00       	jmp    802784 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8026d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026da:	8b 40 0c             	mov    0xc(%eax),%eax
  8026dd:	3b 45 08             	cmp    0x8(%ebp),%eax
  8026e0:	0f 85 87 00 00 00    	jne    80276d <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8026e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026ea:	75 17                	jne    802703 <alloc_block_NF+0x11d>
  8026ec:	83 ec 04             	sub    $0x4,%esp
  8026ef:	68 a9 3a 80 00       	push   $0x803aa9
  8026f4:	68 c8 00 00 00       	push   $0xc8
  8026f9:	68 37 3a 80 00       	push   $0x803a37
  8026fe:	e8 5b 08 00 00       	call   802f5e <_panic>
  802703:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802706:	8b 00                	mov    (%eax),%eax
  802708:	85 c0                	test   %eax,%eax
  80270a:	74 10                	je     80271c <alloc_block_NF+0x136>
  80270c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80270f:	8b 00                	mov    (%eax),%eax
  802711:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802714:	8b 52 04             	mov    0x4(%edx),%edx
  802717:	89 50 04             	mov    %edx,0x4(%eax)
  80271a:	eb 0b                	jmp    802727 <alloc_block_NF+0x141>
  80271c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80271f:	8b 40 04             	mov    0x4(%eax),%eax
  802722:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802727:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80272a:	8b 40 04             	mov    0x4(%eax),%eax
  80272d:	85 c0                	test   %eax,%eax
  80272f:	74 0f                	je     802740 <alloc_block_NF+0x15a>
  802731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802734:	8b 40 04             	mov    0x4(%eax),%eax
  802737:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80273a:	8b 12                	mov    (%edx),%edx
  80273c:	89 10                	mov    %edx,(%eax)
  80273e:	eb 0a                	jmp    80274a <alloc_block_NF+0x164>
  802740:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802743:	8b 00                	mov    (%eax),%eax
  802745:	a3 38 41 80 00       	mov    %eax,0x804138
  80274a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802753:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802756:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80275d:	a1 44 41 80 00       	mov    0x804144,%eax
  802762:	48                   	dec    %eax
  802763:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802768:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276b:	eb 17                	jmp    802784 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  80276d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802770:	8b 00                	mov    (%eax),%eax
  802772:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802775:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802779:	0f 85 7a fe ff ff    	jne    8025f9 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  80277f:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802784:	c9                   	leave  
  802785:	c3                   	ret    

00802786 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802786:	55                   	push   %ebp
  802787:	89 e5                	mov    %esp,%ebp
  802789:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  80278c:	a1 38 41 80 00       	mov    0x804138,%eax
  802791:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802794:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802799:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  80279c:	a1 44 41 80 00       	mov    0x804144,%eax
  8027a1:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8027a4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027a8:	75 68                	jne    802812 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8027aa:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027ae:	75 17                	jne    8027c7 <insert_sorted_with_merge_freeList+0x41>
  8027b0:	83 ec 04             	sub    $0x4,%esp
  8027b3:	68 14 3a 80 00       	push   $0x803a14
  8027b8:	68 da 00 00 00       	push   $0xda
  8027bd:	68 37 3a 80 00       	push   $0x803a37
  8027c2:	e8 97 07 00 00       	call   802f5e <_panic>
  8027c7:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8027cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d0:	89 10                	mov    %edx,(%eax)
  8027d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d5:	8b 00                	mov    (%eax),%eax
  8027d7:	85 c0                	test   %eax,%eax
  8027d9:	74 0d                	je     8027e8 <insert_sorted_with_merge_freeList+0x62>
  8027db:	a1 38 41 80 00       	mov    0x804138,%eax
  8027e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e3:	89 50 04             	mov    %edx,0x4(%eax)
  8027e6:	eb 08                	jmp    8027f0 <insert_sorted_with_merge_freeList+0x6a>
  8027e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027eb:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f3:	a3 38 41 80 00       	mov    %eax,0x804138
  8027f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027fb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802802:	a1 44 41 80 00       	mov    0x804144,%eax
  802807:	40                   	inc    %eax
  802808:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  80280d:	e9 49 07 00 00       	jmp    802f5b <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802812:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802815:	8b 50 08             	mov    0x8(%eax),%edx
  802818:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80281b:	8b 40 0c             	mov    0xc(%eax),%eax
  80281e:	01 c2                	add    %eax,%edx
  802820:	8b 45 08             	mov    0x8(%ebp),%eax
  802823:	8b 40 08             	mov    0x8(%eax),%eax
  802826:	39 c2                	cmp    %eax,%edx
  802828:	73 77                	jae    8028a1 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  80282a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80282d:	8b 00                	mov    (%eax),%eax
  80282f:	85 c0                	test   %eax,%eax
  802831:	75 6e                	jne    8028a1 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802833:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802837:	74 68                	je     8028a1 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802839:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80283d:	75 17                	jne    802856 <insert_sorted_with_merge_freeList+0xd0>
  80283f:	83 ec 04             	sub    $0x4,%esp
  802842:	68 50 3a 80 00       	push   $0x803a50
  802847:	68 e0 00 00 00       	push   $0xe0
  80284c:	68 37 3a 80 00       	push   $0x803a37
  802851:	e8 08 07 00 00       	call   802f5e <_panic>
  802856:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80285c:	8b 45 08             	mov    0x8(%ebp),%eax
  80285f:	89 50 04             	mov    %edx,0x4(%eax)
  802862:	8b 45 08             	mov    0x8(%ebp),%eax
  802865:	8b 40 04             	mov    0x4(%eax),%eax
  802868:	85 c0                	test   %eax,%eax
  80286a:	74 0c                	je     802878 <insert_sorted_with_merge_freeList+0xf2>
  80286c:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802871:	8b 55 08             	mov    0x8(%ebp),%edx
  802874:	89 10                	mov    %edx,(%eax)
  802876:	eb 08                	jmp    802880 <insert_sorted_with_merge_freeList+0xfa>
  802878:	8b 45 08             	mov    0x8(%ebp),%eax
  80287b:	a3 38 41 80 00       	mov    %eax,0x804138
  802880:	8b 45 08             	mov    0x8(%ebp),%eax
  802883:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802888:	8b 45 08             	mov    0x8(%ebp),%eax
  80288b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802891:	a1 44 41 80 00       	mov    0x804144,%eax
  802896:	40                   	inc    %eax
  802897:	a3 44 41 80 00       	mov    %eax,0x804144
  80289c:	e9 ba 06 00 00       	jmp    802f5b <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8028a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a4:	8b 50 0c             	mov    0xc(%eax),%edx
  8028a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028aa:	8b 40 08             	mov    0x8(%eax),%eax
  8028ad:	01 c2                	add    %eax,%edx
  8028af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b2:	8b 40 08             	mov    0x8(%eax),%eax
  8028b5:	39 c2                	cmp    %eax,%edx
  8028b7:	73 78                	jae    802931 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8028b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028bc:	8b 40 04             	mov    0x4(%eax),%eax
  8028bf:	85 c0                	test   %eax,%eax
  8028c1:	75 6e                	jne    802931 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8028c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8028c7:	74 68                	je     802931 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8028c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028cd:	75 17                	jne    8028e6 <insert_sorted_with_merge_freeList+0x160>
  8028cf:	83 ec 04             	sub    $0x4,%esp
  8028d2:	68 14 3a 80 00       	push   $0x803a14
  8028d7:	68 e6 00 00 00       	push   $0xe6
  8028dc:	68 37 3a 80 00       	push   $0x803a37
  8028e1:	e8 78 06 00 00       	call   802f5e <_panic>
  8028e6:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8028ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ef:	89 10                	mov    %edx,(%eax)
  8028f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f4:	8b 00                	mov    (%eax),%eax
  8028f6:	85 c0                	test   %eax,%eax
  8028f8:	74 0d                	je     802907 <insert_sorted_with_merge_freeList+0x181>
  8028fa:	a1 38 41 80 00       	mov    0x804138,%eax
  8028ff:	8b 55 08             	mov    0x8(%ebp),%edx
  802902:	89 50 04             	mov    %edx,0x4(%eax)
  802905:	eb 08                	jmp    80290f <insert_sorted_with_merge_freeList+0x189>
  802907:	8b 45 08             	mov    0x8(%ebp),%eax
  80290a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80290f:	8b 45 08             	mov    0x8(%ebp),%eax
  802912:	a3 38 41 80 00       	mov    %eax,0x804138
  802917:	8b 45 08             	mov    0x8(%ebp),%eax
  80291a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802921:	a1 44 41 80 00       	mov    0x804144,%eax
  802926:	40                   	inc    %eax
  802927:	a3 44 41 80 00       	mov    %eax,0x804144
  80292c:	e9 2a 06 00 00       	jmp    802f5b <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802931:	a1 38 41 80 00       	mov    0x804138,%eax
  802936:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802939:	e9 ed 05 00 00       	jmp    802f2b <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  80293e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802941:	8b 00                	mov    (%eax),%eax
  802943:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802946:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80294a:	0f 84 a7 00 00 00    	je     8029f7 <insert_sorted_with_merge_freeList+0x271>
  802950:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802953:	8b 50 0c             	mov    0xc(%eax),%edx
  802956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802959:	8b 40 08             	mov    0x8(%eax),%eax
  80295c:	01 c2                	add    %eax,%edx
  80295e:	8b 45 08             	mov    0x8(%ebp),%eax
  802961:	8b 40 08             	mov    0x8(%eax),%eax
  802964:	39 c2                	cmp    %eax,%edx
  802966:	0f 83 8b 00 00 00    	jae    8029f7 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  80296c:	8b 45 08             	mov    0x8(%ebp),%eax
  80296f:	8b 50 0c             	mov    0xc(%eax),%edx
  802972:	8b 45 08             	mov    0x8(%ebp),%eax
  802975:	8b 40 08             	mov    0x8(%eax),%eax
  802978:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  80297a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80297d:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802980:	39 c2                	cmp    %eax,%edx
  802982:	73 73                	jae    8029f7 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802984:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802988:	74 06                	je     802990 <insert_sorted_with_merge_freeList+0x20a>
  80298a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80298e:	75 17                	jne    8029a7 <insert_sorted_with_merge_freeList+0x221>
  802990:	83 ec 04             	sub    $0x4,%esp
  802993:	68 c8 3a 80 00       	push   $0x803ac8
  802998:	68 f0 00 00 00       	push   $0xf0
  80299d:	68 37 3a 80 00       	push   $0x803a37
  8029a2:	e8 b7 05 00 00       	call   802f5e <_panic>
  8029a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029aa:	8b 10                	mov    (%eax),%edx
  8029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8029af:	89 10                	mov    %edx,(%eax)
  8029b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b4:	8b 00                	mov    (%eax),%eax
  8029b6:	85 c0                	test   %eax,%eax
  8029b8:	74 0b                	je     8029c5 <insert_sorted_with_merge_freeList+0x23f>
  8029ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029bd:	8b 00                	mov    (%eax),%eax
  8029bf:	8b 55 08             	mov    0x8(%ebp),%edx
  8029c2:	89 50 04             	mov    %edx,0x4(%eax)
  8029c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029cb:	89 10                	mov    %edx,(%eax)
  8029cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029d3:	89 50 04             	mov    %edx,0x4(%eax)
  8029d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d9:	8b 00                	mov    (%eax),%eax
  8029db:	85 c0                	test   %eax,%eax
  8029dd:	75 08                	jne    8029e7 <insert_sorted_with_merge_freeList+0x261>
  8029df:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e2:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029e7:	a1 44 41 80 00       	mov    0x804144,%eax
  8029ec:	40                   	inc    %eax
  8029ed:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  8029f2:	e9 64 05 00 00       	jmp    802f5b <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  8029f7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8029fc:	8b 50 0c             	mov    0xc(%eax),%edx
  8029ff:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a04:	8b 40 08             	mov    0x8(%eax),%eax
  802a07:	01 c2                	add    %eax,%edx
  802a09:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0c:	8b 40 08             	mov    0x8(%eax),%eax
  802a0f:	39 c2                	cmp    %eax,%edx
  802a11:	0f 85 b1 00 00 00    	jne    802ac8 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802a17:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a1c:	85 c0                	test   %eax,%eax
  802a1e:	0f 84 a4 00 00 00    	je     802ac8 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802a24:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a29:	8b 00                	mov    (%eax),%eax
  802a2b:	85 c0                	test   %eax,%eax
  802a2d:	0f 85 95 00 00 00    	jne    802ac8 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802a33:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a38:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a3e:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802a41:	8b 55 08             	mov    0x8(%ebp),%edx
  802a44:	8b 52 0c             	mov    0xc(%edx),%edx
  802a47:	01 ca                	add    %ecx,%edx
  802a49:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802a56:	8b 45 08             	mov    0x8(%ebp),%eax
  802a59:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802a60:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a64:	75 17                	jne    802a7d <insert_sorted_with_merge_freeList+0x2f7>
  802a66:	83 ec 04             	sub    $0x4,%esp
  802a69:	68 14 3a 80 00       	push   $0x803a14
  802a6e:	68 ff 00 00 00       	push   $0xff
  802a73:	68 37 3a 80 00       	push   $0x803a37
  802a78:	e8 e1 04 00 00       	call   802f5e <_panic>
  802a7d:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a83:	8b 45 08             	mov    0x8(%ebp),%eax
  802a86:	89 10                	mov    %edx,(%eax)
  802a88:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8b:	8b 00                	mov    (%eax),%eax
  802a8d:	85 c0                	test   %eax,%eax
  802a8f:	74 0d                	je     802a9e <insert_sorted_with_merge_freeList+0x318>
  802a91:	a1 48 41 80 00       	mov    0x804148,%eax
  802a96:	8b 55 08             	mov    0x8(%ebp),%edx
  802a99:	89 50 04             	mov    %edx,0x4(%eax)
  802a9c:	eb 08                	jmp    802aa6 <insert_sorted_with_merge_freeList+0x320>
  802a9e:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa1:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802aa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802aa9:	a3 48 41 80 00       	mov    %eax,0x804148
  802aae:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ab8:	a1 54 41 80 00       	mov    0x804154,%eax
  802abd:	40                   	inc    %eax
  802abe:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802ac3:	e9 93 04 00 00       	jmp    802f5b <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802ac8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802acb:	8b 50 08             	mov    0x8(%eax),%edx
  802ace:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ad1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ad4:	01 c2                	add    %eax,%edx
  802ad6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad9:	8b 40 08             	mov    0x8(%eax),%eax
  802adc:	39 c2                	cmp    %eax,%edx
  802ade:	0f 85 ae 00 00 00    	jne    802b92 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802ae4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ae7:	8b 50 0c             	mov    0xc(%eax),%edx
  802aea:	8b 45 08             	mov    0x8(%ebp),%eax
  802aed:	8b 40 08             	mov    0x8(%eax),%eax
  802af0:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802af2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af5:	8b 00                	mov    (%eax),%eax
  802af7:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802afa:	39 c2                	cmp    %eax,%edx
  802afc:	0f 84 90 00 00 00    	je     802b92 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 50 0c             	mov    0xc(%eax),%edx
  802b08:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b0e:	01 c2                	add    %eax,%edx
  802b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b13:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802b16:	8b 45 08             	mov    0x8(%ebp),%eax
  802b19:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802b20:	8b 45 08             	mov    0x8(%ebp),%eax
  802b23:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802b2a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b2e:	75 17                	jne    802b47 <insert_sorted_with_merge_freeList+0x3c1>
  802b30:	83 ec 04             	sub    $0x4,%esp
  802b33:	68 14 3a 80 00       	push   $0x803a14
  802b38:	68 0b 01 00 00       	push   $0x10b
  802b3d:	68 37 3a 80 00       	push   $0x803a37
  802b42:	e8 17 04 00 00       	call   802f5e <_panic>
  802b47:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b4d:	8b 45 08             	mov    0x8(%ebp),%eax
  802b50:	89 10                	mov    %edx,(%eax)
  802b52:	8b 45 08             	mov    0x8(%ebp),%eax
  802b55:	8b 00                	mov    (%eax),%eax
  802b57:	85 c0                	test   %eax,%eax
  802b59:	74 0d                	je     802b68 <insert_sorted_with_merge_freeList+0x3e2>
  802b5b:	a1 48 41 80 00       	mov    0x804148,%eax
  802b60:	8b 55 08             	mov    0x8(%ebp),%edx
  802b63:	89 50 04             	mov    %edx,0x4(%eax)
  802b66:	eb 08                	jmp    802b70 <insert_sorted_with_merge_freeList+0x3ea>
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	a3 48 41 80 00       	mov    %eax,0x804148
  802b78:	8b 45 08             	mov    0x8(%ebp),%eax
  802b7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b82:	a1 54 41 80 00       	mov    0x804154,%eax
  802b87:	40                   	inc    %eax
  802b88:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802b8d:	e9 c9 03 00 00       	jmp    802f5b <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802b92:	8b 45 08             	mov    0x8(%ebp),%eax
  802b95:	8b 50 0c             	mov    0xc(%eax),%edx
  802b98:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9b:	8b 40 08             	mov    0x8(%eax),%eax
  802b9e:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802ba0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba3:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802ba6:	39 c2                	cmp    %eax,%edx
  802ba8:	0f 85 bb 00 00 00    	jne    802c69 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802bae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bb2:	0f 84 b1 00 00 00    	je     802c69 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802bb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbb:	8b 40 04             	mov    0x4(%eax),%eax
  802bbe:	85 c0                	test   %eax,%eax
  802bc0:	0f 85 a3 00 00 00    	jne    802c69 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802bc6:	a1 38 41 80 00       	mov    0x804138,%eax
  802bcb:	8b 55 08             	mov    0x8(%ebp),%edx
  802bce:	8b 52 08             	mov    0x8(%edx),%edx
  802bd1:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802bd4:	a1 38 41 80 00       	mov    0x804138,%eax
  802bd9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802bdf:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802be2:	8b 55 08             	mov    0x8(%ebp),%edx
  802be5:	8b 52 0c             	mov    0xc(%edx),%edx
  802be8:	01 ca                	add    %ecx,%edx
  802bea:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802bed:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf0:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802bf7:	8b 45 08             	mov    0x8(%ebp),%eax
  802bfa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c05:	75 17                	jne    802c1e <insert_sorted_with_merge_freeList+0x498>
  802c07:	83 ec 04             	sub    $0x4,%esp
  802c0a:	68 14 3a 80 00       	push   $0x803a14
  802c0f:	68 17 01 00 00       	push   $0x117
  802c14:	68 37 3a 80 00       	push   $0x803a37
  802c19:	e8 40 03 00 00       	call   802f5e <_panic>
  802c1e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	89 10                	mov    %edx,(%eax)
  802c29:	8b 45 08             	mov    0x8(%ebp),%eax
  802c2c:	8b 00                	mov    (%eax),%eax
  802c2e:	85 c0                	test   %eax,%eax
  802c30:	74 0d                	je     802c3f <insert_sorted_with_merge_freeList+0x4b9>
  802c32:	a1 48 41 80 00       	mov    0x804148,%eax
  802c37:	8b 55 08             	mov    0x8(%ebp),%edx
  802c3a:	89 50 04             	mov    %edx,0x4(%eax)
  802c3d:	eb 08                	jmp    802c47 <insert_sorted_with_merge_freeList+0x4c1>
  802c3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c42:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	a3 48 41 80 00       	mov    %eax,0x804148
  802c4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c52:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c59:	a1 54 41 80 00       	mov    0x804154,%eax
  802c5e:	40                   	inc    %eax
  802c5f:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802c64:	e9 f2 02 00 00       	jmp    802f5b <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802c69:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6c:	8b 50 08             	mov    0x8(%eax),%edx
  802c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c72:	8b 40 0c             	mov    0xc(%eax),%eax
  802c75:	01 c2                	add    %eax,%edx
  802c77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7a:	8b 40 08             	mov    0x8(%eax),%eax
  802c7d:	39 c2                	cmp    %eax,%edx
  802c7f:	0f 85 be 00 00 00    	jne    802d43 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c88:	8b 40 04             	mov    0x4(%eax),%eax
  802c8b:	8b 50 08             	mov    0x8(%eax),%edx
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	8b 40 04             	mov    0x4(%eax),%eax
  802c94:	8b 40 0c             	mov    0xc(%eax),%eax
  802c97:	01 c2                	add    %eax,%edx
  802c99:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9c:	8b 40 08             	mov    0x8(%eax),%eax
  802c9f:	39 c2                	cmp    %eax,%edx
  802ca1:	0f 84 9c 00 00 00    	je     802d43 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  802caa:	8b 50 08             	mov    0x8(%eax),%edx
  802cad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb0:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802cb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb6:	8b 50 0c             	mov    0xc(%eax),%edx
  802cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  802cbc:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbf:	01 c2                	add    %eax,%edx
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cca:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802cdb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cdf:	75 17                	jne    802cf8 <insert_sorted_with_merge_freeList+0x572>
  802ce1:	83 ec 04             	sub    $0x4,%esp
  802ce4:	68 14 3a 80 00       	push   $0x803a14
  802ce9:	68 26 01 00 00       	push   $0x126
  802cee:	68 37 3a 80 00       	push   $0x803a37
  802cf3:	e8 66 02 00 00       	call   802f5e <_panic>
  802cf8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	89 10                	mov    %edx,(%eax)
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	8b 00                	mov    (%eax),%eax
  802d08:	85 c0                	test   %eax,%eax
  802d0a:	74 0d                	je     802d19 <insert_sorted_with_merge_freeList+0x593>
  802d0c:	a1 48 41 80 00       	mov    0x804148,%eax
  802d11:	8b 55 08             	mov    0x8(%ebp),%edx
  802d14:	89 50 04             	mov    %edx,0x4(%eax)
  802d17:	eb 08                	jmp    802d21 <insert_sorted_with_merge_freeList+0x59b>
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	a3 48 41 80 00       	mov    %eax,0x804148
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d33:	a1 54 41 80 00       	mov    0x804154,%eax
  802d38:	40                   	inc    %eax
  802d39:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802d3e:	e9 18 02 00 00       	jmp    802f5b <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802d43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d46:	8b 50 0c             	mov    0xc(%eax),%edx
  802d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4c:	8b 40 08             	mov    0x8(%eax),%eax
  802d4f:	01 c2                	add    %eax,%edx
  802d51:	8b 45 08             	mov    0x8(%ebp),%eax
  802d54:	8b 40 08             	mov    0x8(%eax),%eax
  802d57:	39 c2                	cmp    %eax,%edx
  802d59:	0f 85 c4 01 00 00    	jne    802f23 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  802d62:	8b 50 0c             	mov    0xc(%eax),%edx
  802d65:	8b 45 08             	mov    0x8(%ebp),%eax
  802d68:	8b 40 08             	mov    0x8(%eax),%eax
  802d6b:	01 c2                	add    %eax,%edx
  802d6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d70:	8b 00                	mov    (%eax),%eax
  802d72:	8b 40 08             	mov    0x8(%eax),%eax
  802d75:	39 c2                	cmp    %eax,%edx
  802d77:	0f 85 a6 01 00 00    	jne    802f23 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802d7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d81:	0f 84 9c 01 00 00    	je     802f23 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8a:	8b 50 0c             	mov    0xc(%eax),%edx
  802d8d:	8b 45 08             	mov    0x8(%ebp),%eax
  802d90:	8b 40 0c             	mov    0xc(%eax),%eax
  802d93:	01 c2                	add    %eax,%edx
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 00                	mov    (%eax),%eax
  802d9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802d9d:	01 c2                	add    %eax,%edx
  802d9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da2:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802da5:	8b 45 08             	mov    0x8(%ebp),%eax
  802da8:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802daf:	8b 45 08             	mov    0x8(%ebp),%eax
  802db2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802db9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dbd:	75 17                	jne    802dd6 <insert_sorted_with_merge_freeList+0x650>
  802dbf:	83 ec 04             	sub    $0x4,%esp
  802dc2:	68 14 3a 80 00       	push   $0x803a14
  802dc7:	68 32 01 00 00       	push   $0x132
  802dcc:	68 37 3a 80 00       	push   $0x803a37
  802dd1:	e8 88 01 00 00       	call   802f5e <_panic>
  802dd6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddf:	89 10                	mov    %edx,(%eax)
  802de1:	8b 45 08             	mov    0x8(%ebp),%eax
  802de4:	8b 00                	mov    (%eax),%eax
  802de6:	85 c0                	test   %eax,%eax
  802de8:	74 0d                	je     802df7 <insert_sorted_with_merge_freeList+0x671>
  802dea:	a1 48 41 80 00       	mov    0x804148,%eax
  802def:	8b 55 08             	mov    0x8(%ebp),%edx
  802df2:	89 50 04             	mov    %edx,0x4(%eax)
  802df5:	eb 08                	jmp    802dff <insert_sorted_with_merge_freeList+0x679>
  802df7:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802dff:	8b 45 08             	mov    0x8(%ebp),%eax
  802e02:	a3 48 41 80 00       	mov    %eax,0x804148
  802e07:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e11:	a1 54 41 80 00       	mov    0x804154,%eax
  802e16:	40                   	inc    %eax
  802e17:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802e1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e1f:	8b 00                	mov    (%eax),%eax
  802e21:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802e28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2b:	8b 00                	mov    (%eax),%eax
  802e2d:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802e34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e37:	8b 00                	mov    (%eax),%eax
  802e39:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802e3c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802e40:	75 17                	jne    802e59 <insert_sorted_with_merge_freeList+0x6d3>
  802e42:	83 ec 04             	sub    $0x4,%esp
  802e45:	68 a9 3a 80 00       	push   $0x803aa9
  802e4a:	68 36 01 00 00       	push   $0x136
  802e4f:	68 37 3a 80 00       	push   $0x803a37
  802e54:	e8 05 01 00 00       	call   802f5e <_panic>
  802e59:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e5c:	8b 00                	mov    (%eax),%eax
  802e5e:	85 c0                	test   %eax,%eax
  802e60:	74 10                	je     802e72 <insert_sorted_with_merge_freeList+0x6ec>
  802e62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e65:	8b 00                	mov    (%eax),%eax
  802e67:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e6a:	8b 52 04             	mov    0x4(%edx),%edx
  802e6d:	89 50 04             	mov    %edx,0x4(%eax)
  802e70:	eb 0b                	jmp    802e7d <insert_sorted_with_merge_freeList+0x6f7>
  802e72:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e75:	8b 40 04             	mov    0x4(%eax),%eax
  802e78:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802e7d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e80:	8b 40 04             	mov    0x4(%eax),%eax
  802e83:	85 c0                	test   %eax,%eax
  802e85:	74 0f                	je     802e96 <insert_sorted_with_merge_freeList+0x710>
  802e87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e8a:	8b 40 04             	mov    0x4(%eax),%eax
  802e8d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e90:	8b 12                	mov    (%edx),%edx
  802e92:	89 10                	mov    %edx,(%eax)
  802e94:	eb 0a                	jmp    802ea0 <insert_sorted_with_merge_freeList+0x71a>
  802e96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e99:	8b 00                	mov    (%eax),%eax
  802e9b:	a3 38 41 80 00       	mov    %eax,0x804138
  802ea0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ea3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ea9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eac:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802eb3:	a1 44 41 80 00       	mov    0x804144,%eax
  802eb8:	48                   	dec    %eax
  802eb9:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  802ebe:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802ec2:	75 17                	jne    802edb <insert_sorted_with_merge_freeList+0x755>
  802ec4:	83 ec 04             	sub    $0x4,%esp
  802ec7:	68 14 3a 80 00       	push   $0x803a14
  802ecc:	68 37 01 00 00       	push   $0x137
  802ed1:	68 37 3a 80 00       	push   $0x803a37
  802ed6:	e8 83 00 00 00       	call   802f5e <_panic>
  802edb:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ee1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee4:	89 10                	mov    %edx,(%eax)
  802ee6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802ee9:	8b 00                	mov    (%eax),%eax
  802eeb:	85 c0                	test   %eax,%eax
  802eed:	74 0d                	je     802efc <insert_sorted_with_merge_freeList+0x776>
  802eef:	a1 48 41 80 00       	mov    0x804148,%eax
  802ef4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ef7:	89 50 04             	mov    %edx,0x4(%eax)
  802efa:	eb 08                	jmp    802f04 <insert_sorted_with_merge_freeList+0x77e>
  802efc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802eff:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802f04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f07:	a3 48 41 80 00       	mov    %eax,0x804148
  802f0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802f0f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f16:	a1 54 41 80 00       	mov    0x804154,%eax
  802f1b:	40                   	inc    %eax
  802f1c:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  802f21:	eb 38                	jmp    802f5b <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802f23:	a1 40 41 80 00       	mov    0x804140,%eax
  802f28:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802f2b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f2f:	74 07                	je     802f38 <insert_sorted_with_merge_freeList+0x7b2>
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 00                	mov    (%eax),%eax
  802f36:	eb 05                	jmp    802f3d <insert_sorted_with_merge_freeList+0x7b7>
  802f38:	b8 00 00 00 00       	mov    $0x0,%eax
  802f3d:	a3 40 41 80 00       	mov    %eax,0x804140
  802f42:	a1 40 41 80 00       	mov    0x804140,%eax
  802f47:	85 c0                	test   %eax,%eax
  802f49:	0f 85 ef f9 ff ff    	jne    80293e <insert_sorted_with_merge_freeList+0x1b8>
  802f4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f53:	0f 85 e5 f9 ff ff    	jne    80293e <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  802f59:	eb 00                	jmp    802f5b <insert_sorted_with_merge_freeList+0x7d5>
  802f5b:	90                   	nop
  802f5c:	c9                   	leave  
  802f5d:	c3                   	ret    

00802f5e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802f5e:	55                   	push   %ebp
  802f5f:	89 e5                	mov    %esp,%ebp
  802f61:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802f64:	8d 45 10             	lea    0x10(%ebp),%eax
  802f67:	83 c0 04             	add    $0x4,%eax
  802f6a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802f6d:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802f72:	85 c0                	test   %eax,%eax
  802f74:	74 16                	je     802f8c <_panic+0x2e>
		cprintf("%s: ", argv0);
  802f76:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802f7b:	83 ec 08             	sub    $0x8,%esp
  802f7e:	50                   	push   %eax
  802f7f:	68 fc 3a 80 00       	push   $0x803afc
  802f84:	e8 d1 d4 ff ff       	call   80045a <cprintf>
  802f89:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802f8c:	a1 00 40 80 00       	mov    0x804000,%eax
  802f91:	ff 75 0c             	pushl  0xc(%ebp)
  802f94:	ff 75 08             	pushl  0x8(%ebp)
  802f97:	50                   	push   %eax
  802f98:	68 01 3b 80 00       	push   $0x803b01
  802f9d:	e8 b8 d4 ff ff       	call   80045a <cprintf>
  802fa2:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802fa5:	8b 45 10             	mov    0x10(%ebp),%eax
  802fa8:	83 ec 08             	sub    $0x8,%esp
  802fab:	ff 75 f4             	pushl  -0xc(%ebp)
  802fae:	50                   	push   %eax
  802faf:	e8 3b d4 ff ff       	call   8003ef <vcprintf>
  802fb4:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802fb7:	83 ec 08             	sub    $0x8,%esp
  802fba:	6a 00                	push   $0x0
  802fbc:	68 1d 3b 80 00       	push   $0x803b1d
  802fc1:	e8 29 d4 ff ff       	call   8003ef <vcprintf>
  802fc6:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802fc9:	e8 aa d3 ff ff       	call   800378 <exit>

	// should not return here
	while (1) ;
  802fce:	eb fe                	jmp    802fce <_panic+0x70>

00802fd0 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802fd0:	55                   	push   %ebp
  802fd1:	89 e5                	mov    %esp,%ebp
  802fd3:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802fd6:	a1 20 40 80 00       	mov    0x804020,%eax
  802fdb:	8b 50 74             	mov    0x74(%eax),%edx
  802fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fe1:	39 c2                	cmp    %eax,%edx
  802fe3:	74 14                	je     802ff9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802fe5:	83 ec 04             	sub    $0x4,%esp
  802fe8:	68 20 3b 80 00       	push   $0x803b20
  802fed:	6a 26                	push   $0x26
  802fef:	68 6c 3b 80 00       	push   $0x803b6c
  802ff4:	e8 65 ff ff ff       	call   802f5e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802ff9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  803000:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  803007:	e9 c2 00 00 00       	jmp    8030ce <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80300c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80300f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	01 d0                	add    %edx,%eax
  80301b:	8b 00                	mov    (%eax),%eax
  80301d:	85 c0                	test   %eax,%eax
  80301f:	75 08                	jne    803029 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  803021:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  803024:	e9 a2 00 00 00       	jmp    8030cb <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  803029:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803030:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  803037:	eb 69                	jmp    8030a2 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  803039:	a1 20 40 80 00       	mov    0x804020,%eax
  80303e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803044:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803047:	89 d0                	mov    %edx,%eax
  803049:	01 c0                	add    %eax,%eax
  80304b:	01 d0                	add    %edx,%eax
  80304d:	c1 e0 03             	shl    $0x3,%eax
  803050:	01 c8                	add    %ecx,%eax
  803052:	8a 40 04             	mov    0x4(%eax),%al
  803055:	84 c0                	test   %al,%al
  803057:	75 46                	jne    80309f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803059:	a1 20 40 80 00       	mov    0x804020,%eax
  80305e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803064:	8b 55 e8             	mov    -0x18(%ebp),%edx
  803067:	89 d0                	mov    %edx,%eax
  803069:	01 c0                	add    %eax,%eax
  80306b:	01 d0                	add    %edx,%eax
  80306d:	c1 e0 03             	shl    $0x3,%eax
  803070:	01 c8                	add    %ecx,%eax
  803072:	8b 00                	mov    (%eax),%eax
  803074:	89 45 dc             	mov    %eax,-0x24(%ebp)
  803077:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80307a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80307f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803081:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803084:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80308b:	8b 45 08             	mov    0x8(%ebp),%eax
  80308e:	01 c8                	add    %ecx,%eax
  803090:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803092:	39 c2                	cmp    %eax,%edx
  803094:	75 09                	jne    80309f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  803096:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80309d:	eb 12                	jmp    8030b1 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80309f:	ff 45 e8             	incl   -0x18(%ebp)
  8030a2:	a1 20 40 80 00       	mov    0x804020,%eax
  8030a7:	8b 50 74             	mov    0x74(%eax),%edx
  8030aa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8030ad:	39 c2                	cmp    %eax,%edx
  8030af:	77 88                	ja     803039 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8030b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030b5:	75 14                	jne    8030cb <CheckWSWithoutLastIndex+0xfb>
			panic(
  8030b7:	83 ec 04             	sub    $0x4,%esp
  8030ba:	68 78 3b 80 00       	push   $0x803b78
  8030bf:	6a 3a                	push   $0x3a
  8030c1:	68 6c 3b 80 00       	push   $0x803b6c
  8030c6:	e8 93 fe ff ff       	call   802f5e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8030cb:	ff 45 f0             	incl   -0x10(%ebp)
  8030ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030d1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030d4:	0f 8c 32 ff ff ff    	jl     80300c <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8030da:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030e1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8030e8:	eb 26                	jmp    803110 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8030ea:	a1 20 40 80 00       	mov    0x804020,%eax
  8030ef:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8030f5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030f8:	89 d0                	mov    %edx,%eax
  8030fa:	01 c0                	add    %eax,%eax
  8030fc:	01 d0                	add    %edx,%eax
  8030fe:	c1 e0 03             	shl    $0x3,%eax
  803101:	01 c8                	add    %ecx,%eax
  803103:	8a 40 04             	mov    0x4(%eax),%al
  803106:	3c 01                	cmp    $0x1,%al
  803108:	75 03                	jne    80310d <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80310a:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80310d:	ff 45 e0             	incl   -0x20(%ebp)
  803110:	a1 20 40 80 00       	mov    0x804020,%eax
  803115:	8b 50 74             	mov    0x74(%eax),%edx
  803118:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80311b:	39 c2                	cmp    %eax,%edx
  80311d:	77 cb                	ja     8030ea <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80311f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803122:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  803125:	74 14                	je     80313b <CheckWSWithoutLastIndex+0x16b>
		panic(
  803127:	83 ec 04             	sub    $0x4,%esp
  80312a:	68 cc 3b 80 00       	push   $0x803bcc
  80312f:	6a 44                	push   $0x44
  803131:	68 6c 3b 80 00       	push   $0x803b6c
  803136:	e8 23 fe ff ff       	call   802f5e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  80313b:	90                   	nop
  80313c:	c9                   	leave  
  80313d:	c3                   	ret    
  80313e:	66 90                	xchg   %ax,%ax

00803140 <__udivdi3>:
  803140:	55                   	push   %ebp
  803141:	57                   	push   %edi
  803142:	56                   	push   %esi
  803143:	53                   	push   %ebx
  803144:	83 ec 1c             	sub    $0x1c,%esp
  803147:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80314b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80314f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803153:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803157:	89 ca                	mov    %ecx,%edx
  803159:	89 f8                	mov    %edi,%eax
  80315b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80315f:	85 f6                	test   %esi,%esi
  803161:	75 2d                	jne    803190 <__udivdi3+0x50>
  803163:	39 cf                	cmp    %ecx,%edi
  803165:	77 65                	ja     8031cc <__udivdi3+0x8c>
  803167:	89 fd                	mov    %edi,%ebp
  803169:	85 ff                	test   %edi,%edi
  80316b:	75 0b                	jne    803178 <__udivdi3+0x38>
  80316d:	b8 01 00 00 00       	mov    $0x1,%eax
  803172:	31 d2                	xor    %edx,%edx
  803174:	f7 f7                	div    %edi
  803176:	89 c5                	mov    %eax,%ebp
  803178:	31 d2                	xor    %edx,%edx
  80317a:	89 c8                	mov    %ecx,%eax
  80317c:	f7 f5                	div    %ebp
  80317e:	89 c1                	mov    %eax,%ecx
  803180:	89 d8                	mov    %ebx,%eax
  803182:	f7 f5                	div    %ebp
  803184:	89 cf                	mov    %ecx,%edi
  803186:	89 fa                	mov    %edi,%edx
  803188:	83 c4 1c             	add    $0x1c,%esp
  80318b:	5b                   	pop    %ebx
  80318c:	5e                   	pop    %esi
  80318d:	5f                   	pop    %edi
  80318e:	5d                   	pop    %ebp
  80318f:	c3                   	ret    
  803190:	39 ce                	cmp    %ecx,%esi
  803192:	77 28                	ja     8031bc <__udivdi3+0x7c>
  803194:	0f bd fe             	bsr    %esi,%edi
  803197:	83 f7 1f             	xor    $0x1f,%edi
  80319a:	75 40                	jne    8031dc <__udivdi3+0x9c>
  80319c:	39 ce                	cmp    %ecx,%esi
  80319e:	72 0a                	jb     8031aa <__udivdi3+0x6a>
  8031a0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8031a4:	0f 87 9e 00 00 00    	ja     803248 <__udivdi3+0x108>
  8031aa:	b8 01 00 00 00       	mov    $0x1,%eax
  8031af:	89 fa                	mov    %edi,%edx
  8031b1:	83 c4 1c             	add    $0x1c,%esp
  8031b4:	5b                   	pop    %ebx
  8031b5:	5e                   	pop    %esi
  8031b6:	5f                   	pop    %edi
  8031b7:	5d                   	pop    %ebp
  8031b8:	c3                   	ret    
  8031b9:	8d 76 00             	lea    0x0(%esi),%esi
  8031bc:	31 ff                	xor    %edi,%edi
  8031be:	31 c0                	xor    %eax,%eax
  8031c0:	89 fa                	mov    %edi,%edx
  8031c2:	83 c4 1c             	add    $0x1c,%esp
  8031c5:	5b                   	pop    %ebx
  8031c6:	5e                   	pop    %esi
  8031c7:	5f                   	pop    %edi
  8031c8:	5d                   	pop    %ebp
  8031c9:	c3                   	ret    
  8031ca:	66 90                	xchg   %ax,%ax
  8031cc:	89 d8                	mov    %ebx,%eax
  8031ce:	f7 f7                	div    %edi
  8031d0:	31 ff                	xor    %edi,%edi
  8031d2:	89 fa                	mov    %edi,%edx
  8031d4:	83 c4 1c             	add    $0x1c,%esp
  8031d7:	5b                   	pop    %ebx
  8031d8:	5e                   	pop    %esi
  8031d9:	5f                   	pop    %edi
  8031da:	5d                   	pop    %ebp
  8031db:	c3                   	ret    
  8031dc:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031e1:	89 eb                	mov    %ebp,%ebx
  8031e3:	29 fb                	sub    %edi,%ebx
  8031e5:	89 f9                	mov    %edi,%ecx
  8031e7:	d3 e6                	shl    %cl,%esi
  8031e9:	89 c5                	mov    %eax,%ebp
  8031eb:	88 d9                	mov    %bl,%cl
  8031ed:	d3 ed                	shr    %cl,%ebp
  8031ef:	89 e9                	mov    %ebp,%ecx
  8031f1:	09 f1                	or     %esi,%ecx
  8031f3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031f7:	89 f9                	mov    %edi,%ecx
  8031f9:	d3 e0                	shl    %cl,%eax
  8031fb:	89 c5                	mov    %eax,%ebp
  8031fd:	89 d6                	mov    %edx,%esi
  8031ff:	88 d9                	mov    %bl,%cl
  803201:	d3 ee                	shr    %cl,%esi
  803203:	89 f9                	mov    %edi,%ecx
  803205:	d3 e2                	shl    %cl,%edx
  803207:	8b 44 24 08          	mov    0x8(%esp),%eax
  80320b:	88 d9                	mov    %bl,%cl
  80320d:	d3 e8                	shr    %cl,%eax
  80320f:	09 c2                	or     %eax,%edx
  803211:	89 d0                	mov    %edx,%eax
  803213:	89 f2                	mov    %esi,%edx
  803215:	f7 74 24 0c          	divl   0xc(%esp)
  803219:	89 d6                	mov    %edx,%esi
  80321b:	89 c3                	mov    %eax,%ebx
  80321d:	f7 e5                	mul    %ebp
  80321f:	39 d6                	cmp    %edx,%esi
  803221:	72 19                	jb     80323c <__udivdi3+0xfc>
  803223:	74 0b                	je     803230 <__udivdi3+0xf0>
  803225:	89 d8                	mov    %ebx,%eax
  803227:	31 ff                	xor    %edi,%edi
  803229:	e9 58 ff ff ff       	jmp    803186 <__udivdi3+0x46>
  80322e:	66 90                	xchg   %ax,%ax
  803230:	8b 54 24 08          	mov    0x8(%esp),%edx
  803234:	89 f9                	mov    %edi,%ecx
  803236:	d3 e2                	shl    %cl,%edx
  803238:	39 c2                	cmp    %eax,%edx
  80323a:	73 e9                	jae    803225 <__udivdi3+0xe5>
  80323c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80323f:	31 ff                	xor    %edi,%edi
  803241:	e9 40 ff ff ff       	jmp    803186 <__udivdi3+0x46>
  803246:	66 90                	xchg   %ax,%ax
  803248:	31 c0                	xor    %eax,%eax
  80324a:	e9 37 ff ff ff       	jmp    803186 <__udivdi3+0x46>
  80324f:	90                   	nop

00803250 <__umoddi3>:
  803250:	55                   	push   %ebp
  803251:	57                   	push   %edi
  803252:	56                   	push   %esi
  803253:	53                   	push   %ebx
  803254:	83 ec 1c             	sub    $0x1c,%esp
  803257:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80325b:	8b 74 24 34          	mov    0x34(%esp),%esi
  80325f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803263:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803267:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80326b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80326f:	89 f3                	mov    %esi,%ebx
  803271:	89 fa                	mov    %edi,%edx
  803273:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803277:	89 34 24             	mov    %esi,(%esp)
  80327a:	85 c0                	test   %eax,%eax
  80327c:	75 1a                	jne    803298 <__umoddi3+0x48>
  80327e:	39 f7                	cmp    %esi,%edi
  803280:	0f 86 a2 00 00 00    	jbe    803328 <__umoddi3+0xd8>
  803286:	89 c8                	mov    %ecx,%eax
  803288:	89 f2                	mov    %esi,%edx
  80328a:	f7 f7                	div    %edi
  80328c:	89 d0                	mov    %edx,%eax
  80328e:	31 d2                	xor    %edx,%edx
  803290:	83 c4 1c             	add    $0x1c,%esp
  803293:	5b                   	pop    %ebx
  803294:	5e                   	pop    %esi
  803295:	5f                   	pop    %edi
  803296:	5d                   	pop    %ebp
  803297:	c3                   	ret    
  803298:	39 f0                	cmp    %esi,%eax
  80329a:	0f 87 ac 00 00 00    	ja     80334c <__umoddi3+0xfc>
  8032a0:	0f bd e8             	bsr    %eax,%ebp
  8032a3:	83 f5 1f             	xor    $0x1f,%ebp
  8032a6:	0f 84 ac 00 00 00    	je     803358 <__umoddi3+0x108>
  8032ac:	bf 20 00 00 00       	mov    $0x20,%edi
  8032b1:	29 ef                	sub    %ebp,%edi
  8032b3:	89 fe                	mov    %edi,%esi
  8032b5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8032b9:	89 e9                	mov    %ebp,%ecx
  8032bb:	d3 e0                	shl    %cl,%eax
  8032bd:	89 d7                	mov    %edx,%edi
  8032bf:	89 f1                	mov    %esi,%ecx
  8032c1:	d3 ef                	shr    %cl,%edi
  8032c3:	09 c7                	or     %eax,%edi
  8032c5:	89 e9                	mov    %ebp,%ecx
  8032c7:	d3 e2                	shl    %cl,%edx
  8032c9:	89 14 24             	mov    %edx,(%esp)
  8032cc:	89 d8                	mov    %ebx,%eax
  8032ce:	d3 e0                	shl    %cl,%eax
  8032d0:	89 c2                	mov    %eax,%edx
  8032d2:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032d6:	d3 e0                	shl    %cl,%eax
  8032d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032dc:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032e0:	89 f1                	mov    %esi,%ecx
  8032e2:	d3 e8                	shr    %cl,%eax
  8032e4:	09 d0                	or     %edx,%eax
  8032e6:	d3 eb                	shr    %cl,%ebx
  8032e8:	89 da                	mov    %ebx,%edx
  8032ea:	f7 f7                	div    %edi
  8032ec:	89 d3                	mov    %edx,%ebx
  8032ee:	f7 24 24             	mull   (%esp)
  8032f1:	89 c6                	mov    %eax,%esi
  8032f3:	89 d1                	mov    %edx,%ecx
  8032f5:	39 d3                	cmp    %edx,%ebx
  8032f7:	0f 82 87 00 00 00    	jb     803384 <__umoddi3+0x134>
  8032fd:	0f 84 91 00 00 00    	je     803394 <__umoddi3+0x144>
  803303:	8b 54 24 04          	mov    0x4(%esp),%edx
  803307:	29 f2                	sub    %esi,%edx
  803309:	19 cb                	sbb    %ecx,%ebx
  80330b:	89 d8                	mov    %ebx,%eax
  80330d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803311:	d3 e0                	shl    %cl,%eax
  803313:	89 e9                	mov    %ebp,%ecx
  803315:	d3 ea                	shr    %cl,%edx
  803317:	09 d0                	or     %edx,%eax
  803319:	89 e9                	mov    %ebp,%ecx
  80331b:	d3 eb                	shr    %cl,%ebx
  80331d:	89 da                	mov    %ebx,%edx
  80331f:	83 c4 1c             	add    $0x1c,%esp
  803322:	5b                   	pop    %ebx
  803323:	5e                   	pop    %esi
  803324:	5f                   	pop    %edi
  803325:	5d                   	pop    %ebp
  803326:	c3                   	ret    
  803327:	90                   	nop
  803328:	89 fd                	mov    %edi,%ebp
  80332a:	85 ff                	test   %edi,%edi
  80332c:	75 0b                	jne    803339 <__umoddi3+0xe9>
  80332e:	b8 01 00 00 00       	mov    $0x1,%eax
  803333:	31 d2                	xor    %edx,%edx
  803335:	f7 f7                	div    %edi
  803337:	89 c5                	mov    %eax,%ebp
  803339:	89 f0                	mov    %esi,%eax
  80333b:	31 d2                	xor    %edx,%edx
  80333d:	f7 f5                	div    %ebp
  80333f:	89 c8                	mov    %ecx,%eax
  803341:	f7 f5                	div    %ebp
  803343:	89 d0                	mov    %edx,%eax
  803345:	e9 44 ff ff ff       	jmp    80328e <__umoddi3+0x3e>
  80334a:	66 90                	xchg   %ax,%ax
  80334c:	89 c8                	mov    %ecx,%eax
  80334e:	89 f2                	mov    %esi,%edx
  803350:	83 c4 1c             	add    $0x1c,%esp
  803353:	5b                   	pop    %ebx
  803354:	5e                   	pop    %esi
  803355:	5f                   	pop    %edi
  803356:	5d                   	pop    %ebp
  803357:	c3                   	ret    
  803358:	3b 04 24             	cmp    (%esp),%eax
  80335b:	72 06                	jb     803363 <__umoddi3+0x113>
  80335d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803361:	77 0f                	ja     803372 <__umoddi3+0x122>
  803363:	89 f2                	mov    %esi,%edx
  803365:	29 f9                	sub    %edi,%ecx
  803367:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80336b:	89 14 24             	mov    %edx,(%esp)
  80336e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803372:	8b 44 24 04          	mov    0x4(%esp),%eax
  803376:	8b 14 24             	mov    (%esp),%edx
  803379:	83 c4 1c             	add    $0x1c,%esp
  80337c:	5b                   	pop    %ebx
  80337d:	5e                   	pop    %esi
  80337e:	5f                   	pop    %edi
  80337f:	5d                   	pop    %ebp
  803380:	c3                   	ret    
  803381:	8d 76 00             	lea    0x0(%esi),%esi
  803384:	2b 04 24             	sub    (%esp),%eax
  803387:	19 fa                	sbb    %edi,%edx
  803389:	89 d1                	mov    %edx,%ecx
  80338b:	89 c6                	mov    %eax,%esi
  80338d:	e9 71 ff ff ff       	jmp    803303 <__umoddi3+0xb3>
  803392:	66 90                	xchg   %ax,%ax
  803394:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803398:	72 ea                	jb     803384 <__umoddi3+0x134>
  80339a:	89 d9                	mov    %ebx,%ecx
  80339c:	e9 62 ff ff ff       	jmp    803303 <__umoddi3+0xb3>
