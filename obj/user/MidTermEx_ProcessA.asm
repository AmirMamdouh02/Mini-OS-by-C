
obj/user/MidTermEx_ProcessA:     file format elf32-i386


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
  800031:	e8 36 01 00 00       	call   80016c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int32 parentenvID = sys_getparentenvid();
  80003e:	e8 6f 1a 00 00       	call   801ab2 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 80 33 80 00       	push   $0x803380
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 15 15 00 00       	call   80156b <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 82 33 80 00       	push   $0x803382
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 ff 14 00 00       	call   80156b <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 89 33 80 00       	push   $0x803389
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 e9 14 00 00       	call   80156b <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Y ;
	//random delay
	delay = RAND(2000, 10000);
  800088:	8d 45 c8             	lea    -0x38(%ebp),%eax
  80008b:	83 ec 0c             	sub    $0xc,%esp
  80008e:	50                   	push   %eax
  80008f:	e8 51 1a 00 00       	call   801ae5 <sys_get_virtual_time>
  800094:	83 c4 0c             	add    $0xc,%esp
  800097:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80009a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80009f:	ba 00 00 00 00       	mov    $0x0,%edx
  8000a4:	f7 f1                	div    %ecx
  8000a6:	89 d0                	mov    %edx,%eax
  8000a8:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000b3:	83 ec 0c             	sub    $0xc,%esp
  8000b6:	50                   	push   %eax
  8000b7:	e8 c4 2d 00 00       	call   802e80 <env_sleep>
  8000bc:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Y = (*X) * 2 ;
  8000bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000c2:	8b 00                	mov    (%eax),%eax
  8000c4:	01 c0                	add    %eax,%eax
  8000c6:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000c9:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000cc:	83 ec 0c             	sub    $0xc,%esp
  8000cf:	50                   	push   %eax
  8000d0:	e8 10 1a 00 00       	call   801ae5 <sys_get_virtual_time>
  8000d5:	83 c4 0c             	add    $0xc,%esp
  8000d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000db:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000e0:	ba 00 00 00 00       	mov    $0x0,%edx
  8000e5:	f7 f1                	div    %ecx
  8000e7:	89 d0                	mov    %edx,%eax
  8000e9:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000f4:	83 ec 0c             	sub    $0xc,%esp
  8000f7:	50                   	push   %eax
  8000f8:	e8 83 2d 00 00       	call   802e80 <env_sleep>
  8000fd:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Y ;
  800100:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800103:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800106:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800108:	8d 45 d8             	lea    -0x28(%ebp),%eax
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	50                   	push   %eax
  80010f:	e8 d1 19 00 00       	call   801ae5 <sys_get_virtual_time>
  800114:	83 c4 0c             	add    $0xc,%esp
  800117:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80011a:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80011f:	ba 00 00 00 00       	mov    $0x0,%edx
  800124:	f7 f1                	div    %ecx
  800126:	89 d0                	mov    %edx,%eax
  800128:	05 d0 07 00 00       	add    $0x7d0,%eax
  80012d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  800130:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800133:	83 ec 0c             	sub    $0xc,%esp
  800136:	50                   	push   %eax
  800137:	e8 44 2d 00 00       	call   802e80 <env_sleep>
  80013c:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	if (*useSem == 1)
  80013f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800142:	8b 00                	mov    (%eax),%eax
  800144:	83 f8 01             	cmp    $0x1,%eax
  800147:	75 13                	jne    80015c <_main+0x124>
	{
		sys_signalSemaphore(parentenvID, "T") ;
  800149:	83 ec 08             	sub    $0x8,%esp
  80014c:	68 97 33 80 00       	push   $0x803397
  800151:	ff 75 f4             	pushl  -0xc(%ebp)
  800154:	e8 18 18 00 00       	call   801971 <sys_signalSemaphore>
  800159:	83 c4 10             	add    $0x10,%esp
	}

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015f:	8b 00                	mov    (%eax),%eax
  800161:	8d 50 01             	lea    0x1(%eax),%edx
  800164:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800167:	89 10                	mov    %edx,(%eax)

}
  800169:	90                   	nop
  80016a:	c9                   	leave  
  80016b:	c3                   	ret    

0080016c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016c:	55                   	push   %ebp
  80016d:	89 e5                	mov    %esp,%ebp
  80016f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800172:	e8 22 19 00 00       	call   801a99 <sys_getenvindex>
  800177:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80017a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017d:	89 d0                	mov    %edx,%eax
  80017f:	c1 e0 03             	shl    $0x3,%eax
  800182:	01 d0                	add    %edx,%eax
  800184:	01 c0                	add    %eax,%eax
  800186:	01 d0                	add    %edx,%eax
  800188:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018f:	01 d0                	add    %edx,%eax
  800191:	c1 e0 04             	shl    $0x4,%eax
  800194:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800199:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019e:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a3:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001a9:	84 c0                	test   %al,%al
  8001ab:	74 0f                	je     8001bc <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ad:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b2:	05 5c 05 00 00       	add    $0x55c,%eax
  8001b7:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001c0:	7e 0a                	jle    8001cc <libmain+0x60>
		binaryname = argv[0];
  8001c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c5:	8b 00                	mov    (%eax),%eax
  8001c7:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001cc:	83 ec 08             	sub    $0x8,%esp
  8001cf:	ff 75 0c             	pushl  0xc(%ebp)
  8001d2:	ff 75 08             	pushl  0x8(%ebp)
  8001d5:	e8 5e fe ff ff       	call   800038 <_main>
  8001da:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001dd:	e8 c4 16 00 00       	call   8018a6 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e2:	83 ec 0c             	sub    $0xc,%esp
  8001e5:	68 b4 33 80 00       	push   $0x8033b4
  8001ea:	e8 8d 01 00 00       	call   80037c <cprintf>
  8001ef:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f7:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001fd:	a1 20 40 80 00       	mov    0x804020,%eax
  800202:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800208:	83 ec 04             	sub    $0x4,%esp
  80020b:	52                   	push   %edx
  80020c:	50                   	push   %eax
  80020d:	68 dc 33 80 00       	push   $0x8033dc
  800212:	e8 65 01 00 00       	call   80037c <cprintf>
  800217:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80021a:	a1 20 40 80 00       	mov    0x804020,%eax
  80021f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800225:	a1 20 40 80 00       	mov    0x804020,%eax
  80022a:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800230:	a1 20 40 80 00       	mov    0x804020,%eax
  800235:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80023b:	51                   	push   %ecx
  80023c:	52                   	push   %edx
  80023d:	50                   	push   %eax
  80023e:	68 04 34 80 00       	push   $0x803404
  800243:	e8 34 01 00 00       	call   80037c <cprintf>
  800248:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024b:	a1 20 40 80 00       	mov    0x804020,%eax
  800250:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800256:	83 ec 08             	sub    $0x8,%esp
  800259:	50                   	push   %eax
  80025a:	68 5c 34 80 00       	push   $0x80345c
  80025f:	e8 18 01 00 00       	call   80037c <cprintf>
  800264:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800267:	83 ec 0c             	sub    $0xc,%esp
  80026a:	68 b4 33 80 00       	push   $0x8033b4
  80026f:	e8 08 01 00 00       	call   80037c <cprintf>
  800274:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800277:	e8 44 16 00 00       	call   8018c0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027c:	e8 19 00 00 00       	call   80029a <exit>
}
  800281:	90                   	nop
  800282:	c9                   	leave  
  800283:	c3                   	ret    

00800284 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800284:	55                   	push   %ebp
  800285:	89 e5                	mov    %esp,%ebp
  800287:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80028a:	83 ec 0c             	sub    $0xc,%esp
  80028d:	6a 00                	push   $0x0
  80028f:	e8 d1 17 00 00       	call   801a65 <sys_destroy_env>
  800294:	83 c4 10             	add    $0x10,%esp
}
  800297:	90                   	nop
  800298:	c9                   	leave  
  800299:	c3                   	ret    

0080029a <exit>:

void
exit(void)
{
  80029a:	55                   	push   %ebp
  80029b:	89 e5                	mov    %esp,%ebp
  80029d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8002a0:	e8 26 18 00 00       	call   801acb <sys_exit_env>
}
  8002a5:	90                   	nop
  8002a6:	c9                   	leave  
  8002a7:	c3                   	ret    

008002a8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a8:	55                   	push   %ebp
  8002a9:	89 e5                	mov    %esp,%ebp
  8002ab:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ae:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b1:	8b 00                	mov    (%eax),%eax
  8002b3:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b9:	89 0a                	mov    %ecx,(%edx)
  8002bb:	8b 55 08             	mov    0x8(%ebp),%edx
  8002be:	88 d1                	mov    %dl,%cl
  8002c0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002ca:	8b 00                	mov    (%eax),%eax
  8002cc:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d1:	75 2c                	jne    8002ff <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d3:	a0 24 40 80 00       	mov    0x804024,%al
  8002d8:	0f b6 c0             	movzbl %al,%eax
  8002db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002de:	8b 12                	mov    (%edx),%edx
  8002e0:	89 d1                	mov    %edx,%ecx
  8002e2:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e5:	83 c2 08             	add    $0x8,%edx
  8002e8:	83 ec 04             	sub    $0x4,%esp
  8002eb:	50                   	push   %eax
  8002ec:	51                   	push   %ecx
  8002ed:	52                   	push   %edx
  8002ee:	e8 05 14 00 00       	call   8016f8 <sys_cputs>
  8002f3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800302:	8b 40 04             	mov    0x4(%eax),%eax
  800305:	8d 50 01             	lea    0x1(%eax),%edx
  800308:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030e:	90                   	nop
  80030f:	c9                   	leave  
  800310:	c3                   	ret    

00800311 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800311:	55                   	push   %ebp
  800312:	89 e5                	mov    %esp,%ebp
  800314:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80031a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800321:	00 00 00 
	b.cnt = 0;
  800324:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032e:	ff 75 0c             	pushl  0xc(%ebp)
  800331:	ff 75 08             	pushl  0x8(%ebp)
  800334:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80033a:	50                   	push   %eax
  80033b:	68 a8 02 80 00       	push   $0x8002a8
  800340:	e8 11 02 00 00       	call   800556 <vprintfmt>
  800345:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800348:	a0 24 40 80 00       	mov    0x804024,%al
  80034d:	0f b6 c0             	movzbl %al,%eax
  800350:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800356:	83 ec 04             	sub    $0x4,%esp
  800359:	50                   	push   %eax
  80035a:	52                   	push   %edx
  80035b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800361:	83 c0 08             	add    $0x8,%eax
  800364:	50                   	push   %eax
  800365:	e8 8e 13 00 00       	call   8016f8 <sys_cputs>
  80036a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036d:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800374:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80037a:	c9                   	leave  
  80037b:	c3                   	ret    

0080037c <cprintf>:

int cprintf(const char *fmt, ...) {
  80037c:	55                   	push   %ebp
  80037d:	89 e5                	mov    %esp,%ebp
  80037f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800382:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800389:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038f:	8b 45 08             	mov    0x8(%ebp),%eax
  800392:	83 ec 08             	sub    $0x8,%esp
  800395:	ff 75 f4             	pushl  -0xc(%ebp)
  800398:	50                   	push   %eax
  800399:	e8 73 ff ff ff       	call   800311 <vcprintf>
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a7:	c9                   	leave  
  8003a8:	c3                   	ret    

008003a9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a9:	55                   	push   %ebp
  8003aa:	89 e5                	mov    %esp,%ebp
  8003ac:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003af:	e8 f2 14 00 00       	call   8018a6 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bd:	83 ec 08             	sub    $0x8,%esp
  8003c0:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c3:	50                   	push   %eax
  8003c4:	e8 48 ff ff ff       	call   800311 <vcprintf>
  8003c9:	83 c4 10             	add    $0x10,%esp
  8003cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003cf:	e8 ec 14 00 00       	call   8018c0 <sys_enable_interrupt>
	return cnt;
  8003d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d7:	c9                   	leave  
  8003d8:	c3                   	ret    

008003d9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d9:	55                   	push   %ebp
  8003da:	89 e5                	mov    %esp,%ebp
  8003dc:	53                   	push   %ebx
  8003dd:	83 ec 14             	sub    $0x14,%esp
  8003e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e6:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003ec:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ef:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f7:	77 55                	ja     80044e <printnum+0x75>
  8003f9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fc:	72 05                	jb     800403 <printnum+0x2a>
  8003fe:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800401:	77 4b                	ja     80044e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800403:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800406:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800409:	8b 45 18             	mov    0x18(%ebp),%eax
  80040c:	ba 00 00 00 00       	mov    $0x0,%edx
  800411:	52                   	push   %edx
  800412:	50                   	push   %eax
  800413:	ff 75 f4             	pushl  -0xc(%ebp)
  800416:	ff 75 f0             	pushl  -0x10(%ebp)
  800419:	e8 f6 2c 00 00       	call   803114 <__udivdi3>
  80041e:	83 c4 10             	add    $0x10,%esp
  800421:	83 ec 04             	sub    $0x4,%esp
  800424:	ff 75 20             	pushl  0x20(%ebp)
  800427:	53                   	push   %ebx
  800428:	ff 75 18             	pushl  0x18(%ebp)
  80042b:	52                   	push   %edx
  80042c:	50                   	push   %eax
  80042d:	ff 75 0c             	pushl  0xc(%ebp)
  800430:	ff 75 08             	pushl  0x8(%ebp)
  800433:	e8 a1 ff ff ff       	call   8003d9 <printnum>
  800438:	83 c4 20             	add    $0x20,%esp
  80043b:	eb 1a                	jmp    800457 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043d:	83 ec 08             	sub    $0x8,%esp
  800440:	ff 75 0c             	pushl  0xc(%ebp)
  800443:	ff 75 20             	pushl  0x20(%ebp)
  800446:	8b 45 08             	mov    0x8(%ebp),%eax
  800449:	ff d0                	call   *%eax
  80044b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044e:	ff 4d 1c             	decl   0x1c(%ebp)
  800451:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800455:	7f e6                	jg     80043d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800457:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80045a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800462:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800465:	53                   	push   %ebx
  800466:	51                   	push   %ecx
  800467:	52                   	push   %edx
  800468:	50                   	push   %eax
  800469:	e8 b6 2d 00 00       	call   803224 <__umoddi3>
  80046e:	83 c4 10             	add    $0x10,%esp
  800471:	05 94 36 80 00       	add    $0x803694,%eax
  800476:	8a 00                	mov    (%eax),%al
  800478:	0f be c0             	movsbl %al,%eax
  80047b:	83 ec 08             	sub    $0x8,%esp
  80047e:	ff 75 0c             	pushl  0xc(%ebp)
  800481:	50                   	push   %eax
  800482:	8b 45 08             	mov    0x8(%ebp),%eax
  800485:	ff d0                	call   *%eax
  800487:	83 c4 10             	add    $0x10,%esp
}
  80048a:	90                   	nop
  80048b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048e:	c9                   	leave  
  80048f:	c3                   	ret    

00800490 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800490:	55                   	push   %ebp
  800491:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800493:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800497:	7e 1c                	jle    8004b5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800499:	8b 45 08             	mov    0x8(%ebp),%eax
  80049c:	8b 00                	mov    (%eax),%eax
  80049e:	8d 50 08             	lea    0x8(%eax),%edx
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	89 10                	mov    %edx,(%eax)
  8004a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a9:	8b 00                	mov    (%eax),%eax
  8004ab:	83 e8 08             	sub    $0x8,%eax
  8004ae:	8b 50 04             	mov    0x4(%eax),%edx
  8004b1:	8b 00                	mov    (%eax),%eax
  8004b3:	eb 40                	jmp    8004f5 <getuint+0x65>
	else if (lflag)
  8004b5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b9:	74 1e                	je     8004d9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8004be:	8b 00                	mov    (%eax),%eax
  8004c0:	8d 50 04             	lea    0x4(%eax),%edx
  8004c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c6:	89 10                	mov    %edx,(%eax)
  8004c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004cb:	8b 00                	mov    (%eax),%eax
  8004cd:	83 e8 04             	sub    $0x4,%eax
  8004d0:	8b 00                	mov    (%eax),%eax
  8004d2:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d7:	eb 1c                	jmp    8004f5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004dc:	8b 00                	mov    (%eax),%eax
  8004de:	8d 50 04             	lea    0x4(%eax),%edx
  8004e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e4:	89 10                	mov    %edx,(%eax)
  8004e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e9:	8b 00                	mov    (%eax),%eax
  8004eb:	83 e8 04             	sub    $0x4,%eax
  8004ee:	8b 00                	mov    (%eax),%eax
  8004f0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f5:	5d                   	pop    %ebp
  8004f6:	c3                   	ret    

008004f7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f7:	55                   	push   %ebp
  8004f8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004fa:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fe:	7e 1c                	jle    80051c <getint+0x25>
		return va_arg(*ap, long long);
  800500:	8b 45 08             	mov    0x8(%ebp),%eax
  800503:	8b 00                	mov    (%eax),%eax
  800505:	8d 50 08             	lea    0x8(%eax),%edx
  800508:	8b 45 08             	mov    0x8(%ebp),%eax
  80050b:	89 10                	mov    %edx,(%eax)
  80050d:	8b 45 08             	mov    0x8(%ebp),%eax
  800510:	8b 00                	mov    (%eax),%eax
  800512:	83 e8 08             	sub    $0x8,%eax
  800515:	8b 50 04             	mov    0x4(%eax),%edx
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	eb 38                	jmp    800554 <getint+0x5d>
	else if (lflag)
  80051c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800520:	74 1a                	je     80053c <getint+0x45>
		return va_arg(*ap, long);
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	8b 00                	mov    (%eax),%eax
  800527:	8d 50 04             	lea    0x4(%eax),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	89 10                	mov    %edx,(%eax)
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	8b 00                	mov    (%eax),%eax
  800534:	83 e8 04             	sub    $0x4,%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	99                   	cltd   
  80053a:	eb 18                	jmp    800554 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053c:	8b 45 08             	mov    0x8(%ebp),%eax
  80053f:	8b 00                	mov    (%eax),%eax
  800541:	8d 50 04             	lea    0x4(%eax),%edx
  800544:	8b 45 08             	mov    0x8(%ebp),%eax
  800547:	89 10                	mov    %edx,(%eax)
  800549:	8b 45 08             	mov    0x8(%ebp),%eax
  80054c:	8b 00                	mov    (%eax),%eax
  80054e:	83 e8 04             	sub    $0x4,%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	99                   	cltd   
}
  800554:	5d                   	pop    %ebp
  800555:	c3                   	ret    

00800556 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800556:	55                   	push   %ebp
  800557:	89 e5                	mov    %esp,%ebp
  800559:	56                   	push   %esi
  80055a:	53                   	push   %ebx
  80055b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055e:	eb 17                	jmp    800577 <vprintfmt+0x21>
			if (ch == '\0')
  800560:	85 db                	test   %ebx,%ebx
  800562:	0f 84 af 03 00 00    	je     800917 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	ff 75 0c             	pushl  0xc(%ebp)
  80056e:	53                   	push   %ebx
  80056f:	8b 45 08             	mov    0x8(%ebp),%eax
  800572:	ff d0                	call   *%eax
  800574:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800577:	8b 45 10             	mov    0x10(%ebp),%eax
  80057a:	8d 50 01             	lea    0x1(%eax),%edx
  80057d:	89 55 10             	mov    %edx,0x10(%ebp)
  800580:	8a 00                	mov    (%eax),%al
  800582:	0f b6 d8             	movzbl %al,%ebx
  800585:	83 fb 25             	cmp    $0x25,%ebx
  800588:	75 d6                	jne    800560 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80058a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800595:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ad:	8d 50 01             	lea    0x1(%eax),%edx
  8005b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b3:	8a 00                	mov    (%eax),%al
  8005b5:	0f b6 d8             	movzbl %al,%ebx
  8005b8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005bb:	83 f8 55             	cmp    $0x55,%eax
  8005be:	0f 87 2b 03 00 00    	ja     8008ef <vprintfmt+0x399>
  8005c4:	8b 04 85 b8 36 80 00 	mov    0x8036b8(,%eax,4),%eax
  8005cb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005cd:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d1:	eb d7                	jmp    8005aa <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d7:	eb d1                	jmp    8005aa <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005e0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e3:	89 d0                	mov    %edx,%eax
  8005e5:	c1 e0 02             	shl    $0x2,%eax
  8005e8:	01 d0                	add    %edx,%eax
  8005ea:	01 c0                	add    %eax,%eax
  8005ec:	01 d8                	add    %ebx,%eax
  8005ee:	83 e8 30             	sub    $0x30,%eax
  8005f1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f7:	8a 00                	mov    (%eax),%al
  8005f9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005fc:	83 fb 2f             	cmp    $0x2f,%ebx
  8005ff:	7e 3e                	jle    80063f <vprintfmt+0xe9>
  800601:	83 fb 39             	cmp    $0x39,%ebx
  800604:	7f 39                	jg     80063f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800606:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800609:	eb d5                	jmp    8005e0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060b:	8b 45 14             	mov    0x14(%ebp),%eax
  80060e:	83 c0 04             	add    $0x4,%eax
  800611:	89 45 14             	mov    %eax,0x14(%ebp)
  800614:	8b 45 14             	mov    0x14(%ebp),%eax
  800617:	83 e8 04             	sub    $0x4,%eax
  80061a:	8b 00                	mov    (%eax),%eax
  80061c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061f:	eb 1f                	jmp    800640 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800621:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800625:	79 83                	jns    8005aa <vprintfmt+0x54>
				width = 0;
  800627:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062e:	e9 77 ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800633:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80063a:	e9 6b ff ff ff       	jmp    8005aa <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800640:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800644:	0f 89 60 ff ff ff    	jns    8005aa <vprintfmt+0x54>
				width = precision, precision = -1;
  80064a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800650:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800657:	e9 4e ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065f:	e9 46 ff ff ff       	jmp    8005aa <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800664:	8b 45 14             	mov    0x14(%ebp),%eax
  800667:	83 c0 04             	add    $0x4,%eax
  80066a:	89 45 14             	mov    %eax,0x14(%ebp)
  80066d:	8b 45 14             	mov    0x14(%ebp),%eax
  800670:	83 e8 04             	sub    $0x4,%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	83 ec 08             	sub    $0x8,%esp
  800678:	ff 75 0c             	pushl  0xc(%ebp)
  80067b:	50                   	push   %eax
  80067c:	8b 45 08             	mov    0x8(%ebp),%eax
  80067f:	ff d0                	call   *%eax
  800681:	83 c4 10             	add    $0x10,%esp
			break;
  800684:	e9 89 02 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800689:	8b 45 14             	mov    0x14(%ebp),%eax
  80068c:	83 c0 04             	add    $0x4,%eax
  80068f:	89 45 14             	mov    %eax,0x14(%ebp)
  800692:	8b 45 14             	mov    0x14(%ebp),%eax
  800695:	83 e8 04             	sub    $0x4,%eax
  800698:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80069a:	85 db                	test   %ebx,%ebx
  80069c:	79 02                	jns    8006a0 <vprintfmt+0x14a>
				err = -err;
  80069e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8006a0:	83 fb 64             	cmp    $0x64,%ebx
  8006a3:	7f 0b                	jg     8006b0 <vprintfmt+0x15a>
  8006a5:	8b 34 9d 00 35 80 00 	mov    0x803500(,%ebx,4),%esi
  8006ac:	85 f6                	test   %esi,%esi
  8006ae:	75 19                	jne    8006c9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006b0:	53                   	push   %ebx
  8006b1:	68 a5 36 80 00       	push   $0x8036a5
  8006b6:	ff 75 0c             	pushl  0xc(%ebp)
  8006b9:	ff 75 08             	pushl  0x8(%ebp)
  8006bc:	e8 5e 02 00 00       	call   80091f <printfmt>
  8006c1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c4:	e9 49 02 00 00       	jmp    800912 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c9:	56                   	push   %esi
  8006ca:	68 ae 36 80 00       	push   $0x8036ae
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	e8 45 02 00 00       	call   80091f <printfmt>
  8006da:	83 c4 10             	add    $0x10,%esp
			break;
  8006dd:	e9 30 02 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e2:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e5:	83 c0 04             	add    $0x4,%eax
  8006e8:	89 45 14             	mov    %eax,0x14(%ebp)
  8006eb:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ee:	83 e8 04             	sub    $0x4,%eax
  8006f1:	8b 30                	mov    (%eax),%esi
  8006f3:	85 f6                	test   %esi,%esi
  8006f5:	75 05                	jne    8006fc <vprintfmt+0x1a6>
				p = "(null)";
  8006f7:	be b1 36 80 00       	mov    $0x8036b1,%esi
			if (width > 0 && padc != '-')
  8006fc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800700:	7e 6d                	jle    80076f <vprintfmt+0x219>
  800702:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800706:	74 67                	je     80076f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800708:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070b:	83 ec 08             	sub    $0x8,%esp
  80070e:	50                   	push   %eax
  80070f:	56                   	push   %esi
  800710:	e8 0c 03 00 00       	call   800a21 <strnlen>
  800715:	83 c4 10             	add    $0x10,%esp
  800718:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071b:	eb 16                	jmp    800733 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800721:	83 ec 08             	sub    $0x8,%esp
  800724:	ff 75 0c             	pushl  0xc(%ebp)
  800727:	50                   	push   %eax
  800728:	8b 45 08             	mov    0x8(%ebp),%eax
  80072b:	ff d0                	call   *%eax
  80072d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800730:	ff 4d e4             	decl   -0x1c(%ebp)
  800733:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800737:	7f e4                	jg     80071d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800739:	eb 34                	jmp    80076f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073f:	74 1c                	je     80075d <vprintfmt+0x207>
  800741:	83 fb 1f             	cmp    $0x1f,%ebx
  800744:	7e 05                	jle    80074b <vprintfmt+0x1f5>
  800746:	83 fb 7e             	cmp    $0x7e,%ebx
  800749:	7e 12                	jle    80075d <vprintfmt+0x207>
					putch('?', putdat);
  80074b:	83 ec 08             	sub    $0x8,%esp
  80074e:	ff 75 0c             	pushl  0xc(%ebp)
  800751:	6a 3f                	push   $0x3f
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	ff d0                	call   *%eax
  800758:	83 c4 10             	add    $0x10,%esp
  80075b:	eb 0f                	jmp    80076c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075d:	83 ec 08             	sub    $0x8,%esp
  800760:	ff 75 0c             	pushl  0xc(%ebp)
  800763:	53                   	push   %ebx
  800764:	8b 45 08             	mov    0x8(%ebp),%eax
  800767:	ff d0                	call   *%eax
  800769:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076c:	ff 4d e4             	decl   -0x1c(%ebp)
  80076f:	89 f0                	mov    %esi,%eax
  800771:	8d 70 01             	lea    0x1(%eax),%esi
  800774:	8a 00                	mov    (%eax),%al
  800776:	0f be d8             	movsbl %al,%ebx
  800779:	85 db                	test   %ebx,%ebx
  80077b:	74 24                	je     8007a1 <vprintfmt+0x24b>
  80077d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800781:	78 b8                	js     80073b <vprintfmt+0x1e5>
  800783:	ff 4d e0             	decl   -0x20(%ebp)
  800786:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80078a:	79 af                	jns    80073b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078c:	eb 13                	jmp    8007a1 <vprintfmt+0x24b>
				putch(' ', putdat);
  80078e:	83 ec 08             	sub    $0x8,%esp
  800791:	ff 75 0c             	pushl  0xc(%ebp)
  800794:	6a 20                	push   $0x20
  800796:	8b 45 08             	mov    0x8(%ebp),%eax
  800799:	ff d0                	call   *%eax
  80079b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079e:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a5:	7f e7                	jg     80078e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a7:	e9 66 01 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ac:	83 ec 08             	sub    $0x8,%esp
  8007af:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b2:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b5:	50                   	push   %eax
  8007b6:	e8 3c fd ff ff       	call   8004f7 <getint>
  8007bb:	83 c4 10             	add    $0x10,%esp
  8007be:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007ca:	85 d2                	test   %edx,%edx
  8007cc:	79 23                	jns    8007f1 <vprintfmt+0x29b>
				putch('-', putdat);
  8007ce:	83 ec 08             	sub    $0x8,%esp
  8007d1:	ff 75 0c             	pushl  0xc(%ebp)
  8007d4:	6a 2d                	push   $0x2d
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	ff d0                	call   *%eax
  8007db:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e4:	f7 d8                	neg    %eax
  8007e6:	83 d2 00             	adc    $0x0,%edx
  8007e9:	f7 da                	neg    %edx
  8007eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ee:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f8:	e9 bc 00 00 00       	jmp    8008b9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fd:	83 ec 08             	sub    $0x8,%esp
  800800:	ff 75 e8             	pushl  -0x18(%ebp)
  800803:	8d 45 14             	lea    0x14(%ebp),%eax
  800806:	50                   	push   %eax
  800807:	e8 84 fc ff ff       	call   800490 <getuint>
  80080c:	83 c4 10             	add    $0x10,%esp
  80080f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800812:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800815:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081c:	e9 98 00 00 00       	jmp    8008b9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800821:	83 ec 08             	sub    $0x8,%esp
  800824:	ff 75 0c             	pushl  0xc(%ebp)
  800827:	6a 58                	push   $0x58
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	ff d0                	call   *%eax
  80082e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800831:	83 ec 08             	sub    $0x8,%esp
  800834:	ff 75 0c             	pushl  0xc(%ebp)
  800837:	6a 58                	push   $0x58
  800839:	8b 45 08             	mov    0x8(%ebp),%eax
  80083c:	ff d0                	call   *%eax
  80083e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800841:	83 ec 08             	sub    $0x8,%esp
  800844:	ff 75 0c             	pushl  0xc(%ebp)
  800847:	6a 58                	push   $0x58
  800849:	8b 45 08             	mov    0x8(%ebp),%eax
  80084c:	ff d0                	call   *%eax
  80084e:	83 c4 10             	add    $0x10,%esp
			break;
  800851:	e9 bc 00 00 00       	jmp    800912 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800856:	83 ec 08             	sub    $0x8,%esp
  800859:	ff 75 0c             	pushl  0xc(%ebp)
  80085c:	6a 30                	push   $0x30
  80085e:	8b 45 08             	mov    0x8(%ebp),%eax
  800861:	ff d0                	call   *%eax
  800863:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	6a 78                	push   $0x78
  80086e:	8b 45 08             	mov    0x8(%ebp),%eax
  800871:	ff d0                	call   *%eax
  800873:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800876:	8b 45 14             	mov    0x14(%ebp),%eax
  800879:	83 c0 04             	add    $0x4,%eax
  80087c:	89 45 14             	mov    %eax,0x14(%ebp)
  80087f:	8b 45 14             	mov    0x14(%ebp),%eax
  800882:	83 e8 04             	sub    $0x4,%eax
  800885:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800887:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800891:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800898:	eb 1f                	jmp    8008b9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80089a:	83 ec 08             	sub    $0x8,%esp
  80089d:	ff 75 e8             	pushl  -0x18(%ebp)
  8008a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a3:	50                   	push   %eax
  8008a4:	e8 e7 fb ff ff       	call   800490 <getuint>
  8008a9:	83 c4 10             	add    $0x10,%esp
  8008ac:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008af:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008bd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008c0:	83 ec 04             	sub    $0x4,%esp
  8008c3:	52                   	push   %edx
  8008c4:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c7:	50                   	push   %eax
  8008c8:	ff 75 f4             	pushl  -0xc(%ebp)
  8008cb:	ff 75 f0             	pushl  -0x10(%ebp)
  8008ce:	ff 75 0c             	pushl  0xc(%ebp)
  8008d1:	ff 75 08             	pushl  0x8(%ebp)
  8008d4:	e8 00 fb ff ff       	call   8003d9 <printnum>
  8008d9:	83 c4 20             	add    $0x20,%esp
			break;
  8008dc:	eb 34                	jmp    800912 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008de:	83 ec 08             	sub    $0x8,%esp
  8008e1:	ff 75 0c             	pushl  0xc(%ebp)
  8008e4:	53                   	push   %ebx
  8008e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e8:	ff d0                	call   *%eax
  8008ea:	83 c4 10             	add    $0x10,%esp
			break;
  8008ed:	eb 23                	jmp    800912 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ef:	83 ec 08             	sub    $0x8,%esp
  8008f2:	ff 75 0c             	pushl  0xc(%ebp)
  8008f5:	6a 25                	push   $0x25
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	ff d0                	call   *%eax
  8008fc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008ff:	ff 4d 10             	decl   0x10(%ebp)
  800902:	eb 03                	jmp    800907 <vprintfmt+0x3b1>
  800904:	ff 4d 10             	decl   0x10(%ebp)
  800907:	8b 45 10             	mov    0x10(%ebp),%eax
  80090a:	48                   	dec    %eax
  80090b:	8a 00                	mov    (%eax),%al
  80090d:	3c 25                	cmp    $0x25,%al
  80090f:	75 f3                	jne    800904 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800911:	90                   	nop
		}
	}
  800912:	e9 47 fc ff ff       	jmp    80055e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800917:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800918:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091b:	5b                   	pop    %ebx
  80091c:	5e                   	pop    %esi
  80091d:	5d                   	pop    %ebp
  80091e:	c3                   	ret    

0080091f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091f:	55                   	push   %ebp
  800920:	89 e5                	mov    %esp,%ebp
  800922:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800925:	8d 45 10             	lea    0x10(%ebp),%eax
  800928:	83 c0 04             	add    $0x4,%eax
  80092b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092e:	8b 45 10             	mov    0x10(%ebp),%eax
  800931:	ff 75 f4             	pushl  -0xc(%ebp)
  800934:	50                   	push   %eax
  800935:	ff 75 0c             	pushl  0xc(%ebp)
  800938:	ff 75 08             	pushl  0x8(%ebp)
  80093b:	e8 16 fc ff ff       	call   800556 <vprintfmt>
  800940:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800943:	90                   	nop
  800944:	c9                   	leave  
  800945:	c3                   	ret    

00800946 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800946:	55                   	push   %ebp
  800947:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800949:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094c:	8b 40 08             	mov    0x8(%eax),%eax
  80094f:	8d 50 01             	lea    0x1(%eax),%edx
  800952:	8b 45 0c             	mov    0xc(%ebp),%eax
  800955:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800958:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095b:	8b 10                	mov    (%eax),%edx
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8b 40 04             	mov    0x4(%eax),%eax
  800963:	39 c2                	cmp    %eax,%edx
  800965:	73 12                	jae    800979 <sprintputch+0x33>
		*b->buf++ = ch;
  800967:	8b 45 0c             	mov    0xc(%ebp),%eax
  80096a:	8b 00                	mov    (%eax),%eax
  80096c:	8d 48 01             	lea    0x1(%eax),%ecx
  80096f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800972:	89 0a                	mov    %ecx,(%edx)
  800974:	8b 55 08             	mov    0x8(%ebp),%edx
  800977:	88 10                	mov    %dl,(%eax)
}
  800979:	90                   	nop
  80097a:	5d                   	pop    %ebp
  80097b:	c3                   	ret    

0080097c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097c:	55                   	push   %ebp
  80097d:	89 e5                	mov    %esp,%ebp
  80097f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800982:	8b 45 08             	mov    0x8(%ebp),%eax
  800985:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800988:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098e:	8b 45 08             	mov    0x8(%ebp),%eax
  800991:	01 d0                	add    %edx,%eax
  800993:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800996:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a1:	74 06                	je     8009a9 <vsnprintf+0x2d>
  8009a3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a7:	7f 07                	jg     8009b0 <vsnprintf+0x34>
		return -E_INVAL;
  8009a9:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ae:	eb 20                	jmp    8009d0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009b0:	ff 75 14             	pushl  0x14(%ebp)
  8009b3:	ff 75 10             	pushl  0x10(%ebp)
  8009b6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b9:	50                   	push   %eax
  8009ba:	68 46 09 80 00       	push   $0x800946
  8009bf:	e8 92 fb ff ff       	call   800556 <vprintfmt>
  8009c4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009ca:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009db:	83 c0 04             	add    $0x4,%eax
  8009de:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e4:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e7:	50                   	push   %eax
  8009e8:	ff 75 0c             	pushl  0xc(%ebp)
  8009eb:	ff 75 08             	pushl  0x8(%ebp)
  8009ee:	e8 89 ff ff ff       	call   80097c <vsnprintf>
  8009f3:	83 c4 10             	add    $0x10,%esp
  8009f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fc:	c9                   	leave  
  8009fd:	c3                   	ret    

008009fe <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fe:	55                   	push   %ebp
  8009ff:	89 e5                	mov    %esp,%ebp
  800a01:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a04:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0b:	eb 06                	jmp    800a13 <strlen+0x15>
		n++;
  800a0d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a10:	ff 45 08             	incl   0x8(%ebp)
  800a13:	8b 45 08             	mov    0x8(%ebp),%eax
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	84 c0                	test   %al,%al
  800a1a:	75 f1                	jne    800a0d <strlen+0xf>
		n++;
	return n;
  800a1c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1f:	c9                   	leave  
  800a20:	c3                   	ret    

00800a21 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a21:	55                   	push   %ebp
  800a22:	89 e5                	mov    %esp,%ebp
  800a24:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a27:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2e:	eb 09                	jmp    800a39 <strnlen+0x18>
		n++;
  800a30:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a33:	ff 45 08             	incl   0x8(%ebp)
  800a36:	ff 4d 0c             	decl   0xc(%ebp)
  800a39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3d:	74 09                	je     800a48 <strnlen+0x27>
  800a3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a42:	8a 00                	mov    (%eax),%al
  800a44:	84 c0                	test   %al,%al
  800a46:	75 e8                	jne    800a30 <strnlen+0xf>
		n++;
	return n;
  800a48:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4b:	c9                   	leave  
  800a4c:	c3                   	ret    

00800a4d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4d:	55                   	push   %ebp
  800a4e:	89 e5                	mov    %esp,%ebp
  800a50:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a53:	8b 45 08             	mov    0x8(%ebp),%eax
  800a56:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a59:	90                   	nop
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	8d 50 01             	lea    0x1(%eax),%edx
  800a60:	89 55 08             	mov    %edx,0x8(%ebp)
  800a63:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a66:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a69:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6c:	8a 12                	mov    (%edx),%dl
  800a6e:	88 10                	mov    %dl,(%eax)
  800a70:	8a 00                	mov    (%eax),%al
  800a72:	84 c0                	test   %al,%al
  800a74:	75 e4                	jne    800a5a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a76:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a79:	c9                   	leave  
  800a7a:	c3                   	ret    

00800a7b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a7b:	55                   	push   %ebp
  800a7c:	89 e5                	mov    %esp,%ebp
  800a7e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a87:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8e:	eb 1f                	jmp    800aaf <strncpy+0x34>
		*dst++ = *src;
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	8d 50 01             	lea    0x1(%eax),%edx
  800a96:	89 55 08             	mov    %edx,0x8(%ebp)
  800a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9c:	8a 12                	mov    (%edx),%dl
  800a9e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800aa0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa3:	8a 00                	mov    (%eax),%al
  800aa5:	84 c0                	test   %al,%al
  800aa7:	74 03                	je     800aac <strncpy+0x31>
			src++;
  800aa9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aac:	ff 45 fc             	incl   -0x4(%ebp)
  800aaf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab5:	72 d9                	jb     800a90 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800aba:	c9                   	leave  
  800abb:	c3                   	ret    

00800abc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ac2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acc:	74 30                	je     800afe <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800ace:	eb 16                	jmp    800ae6 <strlcpy+0x2a>
			*dst++ = *src++;
  800ad0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad3:	8d 50 01             	lea    0x1(%eax),%edx
  800ad6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800adf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae2:	8a 12                	mov    (%edx),%dl
  800ae4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae6:	ff 4d 10             	decl   0x10(%ebp)
  800ae9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aed:	74 09                	je     800af8 <strlcpy+0x3c>
  800aef:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af2:	8a 00                	mov    (%eax),%al
  800af4:	84 c0                	test   %al,%al
  800af6:	75 d8                	jne    800ad0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af8:	8b 45 08             	mov    0x8(%ebp),%eax
  800afb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afe:	8b 55 08             	mov    0x8(%ebp),%edx
  800b01:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b04:	29 c2                	sub    %eax,%edx
  800b06:	89 d0                	mov    %edx,%eax
}
  800b08:	c9                   	leave  
  800b09:	c3                   	ret    

00800b0a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0d:	eb 06                	jmp    800b15 <strcmp+0xb>
		p++, q++;
  800b0f:	ff 45 08             	incl   0x8(%ebp)
  800b12:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b15:	8b 45 08             	mov    0x8(%ebp),%eax
  800b18:	8a 00                	mov    (%eax),%al
  800b1a:	84 c0                	test   %al,%al
  800b1c:	74 0e                	je     800b2c <strcmp+0x22>
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8a 10                	mov    (%eax),%dl
  800b23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b26:	8a 00                	mov    (%eax),%al
  800b28:	38 c2                	cmp    %al,%dl
  800b2a:	74 e3                	je     800b0f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2f:	8a 00                	mov    (%eax),%al
  800b31:	0f b6 d0             	movzbl %al,%edx
  800b34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b37:	8a 00                	mov    (%eax),%al
  800b39:	0f b6 c0             	movzbl %al,%eax
  800b3c:	29 c2                	sub    %eax,%edx
  800b3e:	89 d0                	mov    %edx,%eax
}
  800b40:	5d                   	pop    %ebp
  800b41:	c3                   	ret    

00800b42 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b42:	55                   	push   %ebp
  800b43:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b45:	eb 09                	jmp    800b50 <strncmp+0xe>
		n--, p++, q++;
  800b47:	ff 4d 10             	decl   0x10(%ebp)
  800b4a:	ff 45 08             	incl   0x8(%ebp)
  800b4d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b50:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b54:	74 17                	je     800b6d <strncmp+0x2b>
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8a 00                	mov    (%eax),%al
  800b5b:	84 c0                	test   %al,%al
  800b5d:	74 0e                	je     800b6d <strncmp+0x2b>
  800b5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b62:	8a 10                	mov    (%eax),%dl
  800b64:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b67:	8a 00                	mov    (%eax),%al
  800b69:	38 c2                	cmp    %al,%dl
  800b6b:	74 da                	je     800b47 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b71:	75 07                	jne    800b7a <strncmp+0x38>
		return 0;
  800b73:	b8 00 00 00 00       	mov    $0x0,%eax
  800b78:	eb 14                	jmp    800b8e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7d:	8a 00                	mov    (%eax),%al
  800b7f:	0f b6 d0             	movzbl %al,%edx
  800b82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b85:	8a 00                	mov    (%eax),%al
  800b87:	0f b6 c0             	movzbl %al,%eax
  800b8a:	29 c2                	sub    %eax,%edx
  800b8c:	89 d0                	mov    %edx,%eax
}
  800b8e:	5d                   	pop    %ebp
  800b8f:	c3                   	ret    

00800b90 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b90:	55                   	push   %ebp
  800b91:	89 e5                	mov    %esp,%ebp
  800b93:	83 ec 04             	sub    $0x4,%esp
  800b96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b99:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9c:	eb 12                	jmp    800bb0 <strchr+0x20>
		if (*s == c)
  800b9e:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba1:	8a 00                	mov    (%eax),%al
  800ba3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba6:	75 05                	jne    800bad <strchr+0x1d>
			return (char *) s;
  800ba8:	8b 45 08             	mov    0x8(%ebp),%eax
  800bab:	eb 11                	jmp    800bbe <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bad:	ff 45 08             	incl   0x8(%ebp)
  800bb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb3:	8a 00                	mov    (%eax),%al
  800bb5:	84 c0                	test   %al,%al
  800bb7:	75 e5                	jne    800b9e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbe:	c9                   	leave  
  800bbf:	c3                   	ret    

00800bc0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 04             	sub    $0x4,%esp
  800bc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bcc:	eb 0d                	jmp    800bdb <strfind+0x1b>
		if (*s == c)
  800bce:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd1:	8a 00                	mov    (%eax),%al
  800bd3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd6:	74 0e                	je     800be6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd8:	ff 45 08             	incl   0x8(%ebp)
  800bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	84 c0                	test   %al,%al
  800be2:	75 ea                	jne    800bce <strfind+0xe>
  800be4:	eb 01                	jmp    800be7 <strfind+0x27>
		if (*s == c)
			break;
  800be6:	90                   	nop
	return (char *) s;
  800be7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800bea:	c9                   	leave  
  800beb:	c3                   	ret    

00800bec <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800bec:	55                   	push   %ebp
  800bed:	89 e5                	mov    %esp,%ebp
  800bef:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf8:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfe:	eb 0e                	jmp    800c0e <memset+0x22>
		*p++ = c;
  800c00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c09:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0e:	ff 4d f8             	decl   -0x8(%ebp)
  800c11:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c15:	79 e9                	jns    800c00 <memset+0x14>
		*p++ = c;

	return v;
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c1a:	c9                   	leave  
  800c1b:	c3                   	ret    

00800c1c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c1c:	55                   	push   %ebp
  800c1d:	89 e5                	mov    %esp,%ebp
  800c1f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c25:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c28:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2e:	eb 16                	jmp    800c46 <memcpy+0x2a>
		*d++ = *s++;
  800c30:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c33:	8d 50 01             	lea    0x1(%eax),%edx
  800c36:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c39:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3c:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c42:	8a 12                	mov    (%edx),%dl
  800c44:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c46:	8b 45 10             	mov    0x10(%ebp),%eax
  800c49:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4c:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4f:	85 c0                	test   %eax,%eax
  800c51:	75 dd                	jne    800c30 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c53:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c56:	c9                   	leave  
  800c57:	c3                   	ret    

00800c58 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c58:	55                   	push   %ebp
  800c59:	89 e5                	mov    %esp,%ebp
  800c5b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c61:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c64:	8b 45 08             	mov    0x8(%ebp),%eax
  800c67:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c6a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c70:	73 50                	jae    800cc2 <memmove+0x6a>
  800c72:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c75:	8b 45 10             	mov    0x10(%ebp),%eax
  800c78:	01 d0                	add    %edx,%eax
  800c7a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7d:	76 43                	jbe    800cc2 <memmove+0x6a>
		s += n;
  800c7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c82:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c85:	8b 45 10             	mov    0x10(%ebp),%eax
  800c88:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c8b:	eb 10                	jmp    800c9d <memmove+0x45>
			*--d = *--s;
  800c8d:	ff 4d f8             	decl   -0x8(%ebp)
  800c90:	ff 4d fc             	decl   -0x4(%ebp)
  800c93:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c96:	8a 10                	mov    (%eax),%dl
  800c98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9d:	8b 45 10             	mov    0x10(%ebp),%eax
  800ca0:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca3:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca6:	85 c0                	test   %eax,%eax
  800ca8:	75 e3                	jne    800c8d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800caa:	eb 23                	jmp    800ccf <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cac:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800caf:	8d 50 01             	lea    0x1(%eax),%edx
  800cb2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb8:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cbb:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbe:	8a 12                	mov    (%edx),%dl
  800cc0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cc2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc5:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc8:	89 55 10             	mov    %edx,0x10(%ebp)
  800ccb:	85 c0                	test   %eax,%eax
  800ccd:	75 dd                	jne    800cac <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd2:	c9                   	leave  
  800cd3:	c3                   	ret    

00800cd4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
  800cd7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce6:	eb 2a                	jmp    800d12 <memcmp+0x3e>
		if (*s1 != *s2)
  800ce8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ceb:	8a 10                	mov    (%eax),%dl
  800ced:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cf0:	8a 00                	mov    (%eax),%al
  800cf2:	38 c2                	cmp    %al,%dl
  800cf4:	74 16                	je     800d0c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf9:	8a 00                	mov    (%eax),%al
  800cfb:	0f b6 d0             	movzbl %al,%edx
  800cfe:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d01:	8a 00                	mov    (%eax),%al
  800d03:	0f b6 c0             	movzbl %al,%eax
  800d06:	29 c2                	sub    %eax,%edx
  800d08:	89 d0                	mov    %edx,%eax
  800d0a:	eb 18                	jmp    800d24 <memcmp+0x50>
		s1++, s2++;
  800d0c:	ff 45 fc             	incl   -0x4(%ebp)
  800d0f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d12:	8b 45 10             	mov    0x10(%ebp),%eax
  800d15:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d18:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1b:	85 c0                	test   %eax,%eax
  800d1d:	75 c9                	jne    800ce8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d24:	c9                   	leave  
  800d25:	c3                   	ret    

00800d26 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d26:	55                   	push   %ebp
  800d27:	89 e5                	mov    %esp,%ebp
  800d29:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d2c:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d32:	01 d0                	add    %edx,%eax
  800d34:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d37:	eb 15                	jmp    800d4e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	8a 00                	mov    (%eax),%al
  800d3e:	0f b6 d0             	movzbl %al,%edx
  800d41:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d44:	0f b6 c0             	movzbl %al,%eax
  800d47:	39 c2                	cmp    %eax,%edx
  800d49:	74 0d                	je     800d58 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d4b:	ff 45 08             	incl   0x8(%ebp)
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d54:	72 e3                	jb     800d39 <memfind+0x13>
  800d56:	eb 01                	jmp    800d59 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d58:	90                   	nop
	return (void *) s;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d64:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d6b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d72:	eb 03                	jmp    800d77 <strtol+0x19>
		s++;
  800d74:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d77:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7a:	8a 00                	mov    (%eax),%al
  800d7c:	3c 20                	cmp    $0x20,%al
  800d7e:	74 f4                	je     800d74 <strtol+0x16>
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8a 00                	mov    (%eax),%al
  800d85:	3c 09                	cmp    $0x9,%al
  800d87:	74 eb                	je     800d74 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	8a 00                	mov    (%eax),%al
  800d8e:	3c 2b                	cmp    $0x2b,%al
  800d90:	75 05                	jne    800d97 <strtol+0x39>
		s++;
  800d92:	ff 45 08             	incl   0x8(%ebp)
  800d95:	eb 13                	jmp    800daa <strtol+0x4c>
	else if (*s == '-')
  800d97:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9a:	8a 00                	mov    (%eax),%al
  800d9c:	3c 2d                	cmp    $0x2d,%al
  800d9e:	75 0a                	jne    800daa <strtol+0x4c>
		s++, neg = 1;
  800da0:	ff 45 08             	incl   0x8(%ebp)
  800da3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800daa:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dae:	74 06                	je     800db6 <strtol+0x58>
  800db0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db4:	75 20                	jne    800dd6 <strtol+0x78>
  800db6:	8b 45 08             	mov    0x8(%ebp),%eax
  800db9:	8a 00                	mov    (%eax),%al
  800dbb:	3c 30                	cmp    $0x30,%al
  800dbd:	75 17                	jne    800dd6 <strtol+0x78>
  800dbf:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc2:	40                   	inc    %eax
  800dc3:	8a 00                	mov    (%eax),%al
  800dc5:	3c 78                	cmp    $0x78,%al
  800dc7:	75 0d                	jne    800dd6 <strtol+0x78>
		s += 2, base = 16;
  800dc9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcd:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd4:	eb 28                	jmp    800dfe <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dda:	75 15                	jne    800df1 <strtol+0x93>
  800ddc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddf:	8a 00                	mov    (%eax),%al
  800de1:	3c 30                	cmp    $0x30,%al
  800de3:	75 0c                	jne    800df1 <strtol+0x93>
		s++, base = 8;
  800de5:	ff 45 08             	incl   0x8(%ebp)
  800de8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800def:	eb 0d                	jmp    800dfe <strtol+0xa0>
	else if (base == 0)
  800df1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df5:	75 07                	jne    800dfe <strtol+0xa0>
		base = 10;
  800df7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	3c 2f                	cmp    $0x2f,%al
  800e05:	7e 19                	jle    800e20 <strtol+0xc2>
  800e07:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0a:	8a 00                	mov    (%eax),%al
  800e0c:	3c 39                	cmp    $0x39,%al
  800e0e:	7f 10                	jg     800e20 <strtol+0xc2>
			dig = *s - '0';
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	0f be c0             	movsbl %al,%eax
  800e18:	83 e8 30             	sub    $0x30,%eax
  800e1b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1e:	eb 42                	jmp    800e62 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e20:	8b 45 08             	mov    0x8(%ebp),%eax
  800e23:	8a 00                	mov    (%eax),%al
  800e25:	3c 60                	cmp    $0x60,%al
  800e27:	7e 19                	jle    800e42 <strtol+0xe4>
  800e29:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2c:	8a 00                	mov    (%eax),%al
  800e2e:	3c 7a                	cmp    $0x7a,%al
  800e30:	7f 10                	jg     800e42 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e32:	8b 45 08             	mov    0x8(%ebp),%eax
  800e35:	8a 00                	mov    (%eax),%al
  800e37:	0f be c0             	movsbl %al,%eax
  800e3a:	83 e8 57             	sub    $0x57,%eax
  800e3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e40:	eb 20                	jmp    800e62 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e42:	8b 45 08             	mov    0x8(%ebp),%eax
  800e45:	8a 00                	mov    (%eax),%al
  800e47:	3c 40                	cmp    $0x40,%al
  800e49:	7e 39                	jle    800e84 <strtol+0x126>
  800e4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4e:	8a 00                	mov    (%eax),%al
  800e50:	3c 5a                	cmp    $0x5a,%al
  800e52:	7f 30                	jg     800e84 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e54:	8b 45 08             	mov    0x8(%ebp),%eax
  800e57:	8a 00                	mov    (%eax),%al
  800e59:	0f be c0             	movsbl %al,%eax
  800e5c:	83 e8 37             	sub    $0x37,%eax
  800e5f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e65:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e68:	7d 19                	jge    800e83 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e6a:	ff 45 08             	incl   0x8(%ebp)
  800e6d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e70:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e74:	89 c2                	mov    %eax,%edx
  800e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e79:	01 d0                	add    %edx,%eax
  800e7b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7e:	e9 7b ff ff ff       	jmp    800dfe <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e83:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e84:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e88:	74 08                	je     800e92 <strtol+0x134>
		*endptr = (char *) s;
  800e8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8d:	8b 55 08             	mov    0x8(%ebp),%edx
  800e90:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e92:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e96:	74 07                	je     800e9f <strtol+0x141>
  800e98:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9b:	f7 d8                	neg    %eax
  800e9d:	eb 03                	jmp    800ea2 <strtol+0x144>
  800e9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea2:	c9                   	leave  
  800ea3:	c3                   	ret    

00800ea4 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea4:	55                   	push   %ebp
  800ea5:	89 e5                	mov    %esp,%ebp
  800ea7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800eaa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ebc:	79 13                	jns    800ed1 <ltostr+0x2d>
	{
		neg = 1;
  800ebe:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800ecb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ece:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed9:	99                   	cltd   
  800eda:	f7 f9                	idiv   %ecx
  800edc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800edf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee2:	8d 50 01             	lea    0x1(%eax),%edx
  800ee5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee8:	89 c2                	mov    %eax,%edx
  800eea:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eed:	01 d0                	add    %edx,%eax
  800eef:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef2:	83 c2 30             	add    $0x30,%edx
  800ef5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800efa:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800eff:	f7 e9                	imul   %ecx
  800f01:	c1 fa 02             	sar    $0x2,%edx
  800f04:	89 c8                	mov    %ecx,%eax
  800f06:	c1 f8 1f             	sar    $0x1f,%eax
  800f09:	29 c2                	sub    %eax,%edx
  800f0b:	89 d0                	mov    %edx,%eax
  800f0d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f10:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f13:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f18:	f7 e9                	imul   %ecx
  800f1a:	c1 fa 02             	sar    $0x2,%edx
  800f1d:	89 c8                	mov    %ecx,%eax
  800f1f:	c1 f8 1f             	sar    $0x1f,%eax
  800f22:	29 c2                	sub    %eax,%edx
  800f24:	89 d0                	mov    %edx,%eax
  800f26:	c1 e0 02             	shl    $0x2,%eax
  800f29:	01 d0                	add    %edx,%eax
  800f2b:	01 c0                	add    %eax,%eax
  800f2d:	29 c1                	sub    %eax,%ecx
  800f2f:	89 ca                	mov    %ecx,%edx
  800f31:	85 d2                	test   %edx,%edx
  800f33:	75 9c                	jne    800ed1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f35:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3f:	48                   	dec    %eax
  800f40:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f43:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f47:	74 3d                	je     800f86 <ltostr+0xe2>
		start = 1 ;
  800f49:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f50:	eb 34                	jmp    800f86 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f52:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	01 d0                	add    %edx,%eax
  800f5a:	8a 00                	mov    (%eax),%al
  800f5c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f62:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f65:	01 c2                	add    %eax,%edx
  800f67:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6d:	01 c8                	add    %ecx,%eax
  800f6f:	8a 00                	mov    (%eax),%al
  800f71:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f79:	01 c2                	add    %eax,%edx
  800f7b:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7e:	88 02                	mov    %al,(%edx)
		start++ ;
  800f80:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f83:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f89:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8c:	7c c4                	jl     800f52 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f94:	01 d0                	add    %edx,%eax
  800f96:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
  800f9f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa2:	ff 75 08             	pushl  0x8(%ebp)
  800fa5:	e8 54 fa ff ff       	call   8009fe <strlen>
  800faa:	83 c4 04             	add    $0x4,%esp
  800fad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800fb0:	ff 75 0c             	pushl  0xc(%ebp)
  800fb3:	e8 46 fa ff ff       	call   8009fe <strlen>
  800fb8:	83 c4 04             	add    $0x4,%esp
  800fbb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbe:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcc:	eb 17                	jmp    800fe5 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fce:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 c2                	add    %eax,%edx
  800fd6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdc:	01 c8                	add    %ecx,%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe2:	ff 45 fc             	incl   -0x4(%ebp)
  800fe5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800feb:	7c e1                	jl     800fce <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fed:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffb:	eb 1f                	jmp    80101c <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801000:	8d 50 01             	lea    0x1(%eax),%edx
  801003:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801006:	89 c2                	mov    %eax,%edx
  801008:	8b 45 10             	mov    0x10(%ebp),%eax
  80100b:	01 c2                	add    %eax,%edx
  80100d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801010:	8b 45 0c             	mov    0xc(%ebp),%eax
  801013:	01 c8                	add    %ecx,%eax
  801015:	8a 00                	mov    (%eax),%al
  801017:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801019:	ff 45 f8             	incl   -0x8(%ebp)
  80101c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801022:	7c d9                	jl     800ffd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801024:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801027:	8b 45 10             	mov    0x10(%ebp),%eax
  80102a:	01 d0                	add    %edx,%eax
  80102c:	c6 00 00             	movb   $0x0,(%eax)
}
  80102f:	90                   	nop
  801030:	c9                   	leave  
  801031:	c3                   	ret    

00801032 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801032:	55                   	push   %ebp
  801033:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801035:	8b 45 14             	mov    0x14(%ebp),%eax
  801038:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103e:	8b 45 14             	mov    0x14(%ebp),%eax
  801041:	8b 00                	mov    (%eax),%eax
  801043:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80104a:	8b 45 10             	mov    0x10(%ebp),%eax
  80104d:	01 d0                	add    %edx,%eax
  80104f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801055:	eb 0c                	jmp    801063 <strsplit+0x31>
			*string++ = 0;
  801057:	8b 45 08             	mov    0x8(%ebp),%eax
  80105a:	8d 50 01             	lea    0x1(%eax),%edx
  80105d:	89 55 08             	mov    %edx,0x8(%ebp)
  801060:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801063:	8b 45 08             	mov    0x8(%ebp),%eax
  801066:	8a 00                	mov    (%eax),%al
  801068:	84 c0                	test   %al,%al
  80106a:	74 18                	je     801084 <strsplit+0x52>
  80106c:	8b 45 08             	mov    0x8(%ebp),%eax
  80106f:	8a 00                	mov    (%eax),%al
  801071:	0f be c0             	movsbl %al,%eax
  801074:	50                   	push   %eax
  801075:	ff 75 0c             	pushl  0xc(%ebp)
  801078:	e8 13 fb ff ff       	call   800b90 <strchr>
  80107d:	83 c4 08             	add    $0x8,%esp
  801080:	85 c0                	test   %eax,%eax
  801082:	75 d3                	jne    801057 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	8a 00                	mov    (%eax),%al
  801089:	84 c0                	test   %al,%al
  80108b:	74 5a                	je     8010e7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108d:	8b 45 14             	mov    0x14(%ebp),%eax
  801090:	8b 00                	mov    (%eax),%eax
  801092:	83 f8 0f             	cmp    $0xf,%eax
  801095:	75 07                	jne    80109e <strsplit+0x6c>
		{
			return 0;
  801097:	b8 00 00 00 00       	mov    $0x0,%eax
  80109c:	eb 66                	jmp    801104 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109e:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a1:	8b 00                	mov    (%eax),%eax
  8010a3:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a6:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a9:	89 0a                	mov    %ecx,(%edx)
  8010ab:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b5:	01 c2                	add    %eax,%edx
  8010b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ba:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bc:	eb 03                	jmp    8010c1 <strsplit+0x8f>
			string++;
  8010be:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c4:	8a 00                	mov    (%eax),%al
  8010c6:	84 c0                	test   %al,%al
  8010c8:	74 8b                	je     801055 <strsplit+0x23>
  8010ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cd:	8a 00                	mov    (%eax),%al
  8010cf:	0f be c0             	movsbl %al,%eax
  8010d2:	50                   	push   %eax
  8010d3:	ff 75 0c             	pushl  0xc(%ebp)
  8010d6:	e8 b5 fa ff ff       	call   800b90 <strchr>
  8010db:	83 c4 08             	add    $0x8,%esp
  8010de:	85 c0                	test   %eax,%eax
  8010e0:	74 dc                	je     8010be <strsplit+0x8c>
			string++;
	}
  8010e2:	e9 6e ff ff ff       	jmp    801055 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e8:	8b 45 14             	mov    0x14(%ebp),%eax
  8010eb:	8b 00                	mov    (%eax),%eax
  8010ed:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f4:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f7:	01 d0                	add    %edx,%eax
  8010f9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010ff:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801104:	c9                   	leave  
  801105:	c3                   	ret    

00801106 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801106:	55                   	push   %ebp
  801107:	89 e5                	mov    %esp,%ebp
  801109:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80110c:	a1 04 40 80 00       	mov    0x804004,%eax
  801111:	85 c0                	test   %eax,%eax
  801113:	74 1f                	je     801134 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801115:	e8 1d 00 00 00       	call   801137 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80111a:	83 ec 0c             	sub    $0xc,%esp
  80111d:	68 10 38 80 00       	push   $0x803810
  801122:	e8 55 f2 ff ff       	call   80037c <cprintf>
  801127:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80112a:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801131:	00 00 00 
	}
}
  801134:	90                   	nop
  801135:	c9                   	leave  
  801136:	c3                   	ret    

00801137 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801137:	55                   	push   %ebp
  801138:	89 e5                	mov    %esp,%ebp
  80113a:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  80113d:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801144:	00 00 00 
  801147:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80114e:	00 00 00 
  801151:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801158:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80115b:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801162:	00 00 00 
  801165:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80116c:	00 00 00 
  80116f:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801176:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801179:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801180:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801183:	c1 e8 0c             	shr    $0xc,%eax
  801186:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  80118b:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801192:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801195:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80119a:	2d 00 10 00 00       	sub    $0x1000,%eax
  80119f:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  8011a4:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8011ab:	a1 20 41 80 00       	mov    0x804120,%eax
  8011b0:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8011b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8011b7:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8011be:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8011c1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011c4:	01 d0                	add    %edx,%eax
  8011c6:	48                   	dec    %eax
  8011c7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011ca:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011cd:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d2:	f7 75 e4             	divl   -0x1c(%ebp)
  8011d5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011d8:	29 d0                	sub    %edx,%eax
  8011da:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8011dd:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8011e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011e7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011ec:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011f1:	83 ec 04             	sub    $0x4,%esp
  8011f4:	6a 07                	push   $0x7
  8011f6:	ff 75 e8             	pushl  -0x18(%ebp)
  8011f9:	50                   	push   %eax
  8011fa:	e8 3d 06 00 00       	call   80183c <sys_allocate_chunk>
  8011ff:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801202:	a1 20 41 80 00       	mov    0x804120,%eax
  801207:	83 ec 0c             	sub    $0xc,%esp
  80120a:	50                   	push   %eax
  80120b:	e8 b2 0c 00 00       	call   801ec2 <initialize_MemBlocksList>
  801210:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801213:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801218:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  80121b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80121f:	0f 84 f3 00 00 00    	je     801318 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801225:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801229:	75 14                	jne    80123f <initialize_dyn_block_system+0x108>
  80122b:	83 ec 04             	sub    $0x4,%esp
  80122e:	68 35 38 80 00       	push   $0x803835
  801233:	6a 36                	push   $0x36
  801235:	68 53 38 80 00       	push   $0x803853
  80123a:	e8 f5 1c 00 00       	call   802f34 <_panic>
  80123f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801242:	8b 00                	mov    (%eax),%eax
  801244:	85 c0                	test   %eax,%eax
  801246:	74 10                	je     801258 <initialize_dyn_block_system+0x121>
  801248:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80124b:	8b 00                	mov    (%eax),%eax
  80124d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801250:	8b 52 04             	mov    0x4(%edx),%edx
  801253:	89 50 04             	mov    %edx,0x4(%eax)
  801256:	eb 0b                	jmp    801263 <initialize_dyn_block_system+0x12c>
  801258:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80125b:	8b 40 04             	mov    0x4(%eax),%eax
  80125e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801263:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801266:	8b 40 04             	mov    0x4(%eax),%eax
  801269:	85 c0                	test   %eax,%eax
  80126b:	74 0f                	je     80127c <initialize_dyn_block_system+0x145>
  80126d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801270:	8b 40 04             	mov    0x4(%eax),%eax
  801273:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801276:	8b 12                	mov    (%edx),%edx
  801278:	89 10                	mov    %edx,(%eax)
  80127a:	eb 0a                	jmp    801286 <initialize_dyn_block_system+0x14f>
  80127c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80127f:	8b 00                	mov    (%eax),%eax
  801281:	a3 48 41 80 00       	mov    %eax,0x804148
  801286:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801289:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80128f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801292:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801299:	a1 54 41 80 00       	mov    0x804154,%eax
  80129e:	48                   	dec    %eax
  80129f:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  8012a4:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012a7:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8012ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012b1:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8012b8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8012bc:	75 14                	jne    8012d2 <initialize_dyn_block_system+0x19b>
  8012be:	83 ec 04             	sub    $0x4,%esp
  8012c1:	68 60 38 80 00       	push   $0x803860
  8012c6:	6a 3e                	push   $0x3e
  8012c8:	68 53 38 80 00       	push   $0x803853
  8012cd:	e8 62 1c 00 00       	call   802f34 <_panic>
  8012d2:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8012d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012db:	89 10                	mov    %edx,(%eax)
  8012dd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012e0:	8b 00                	mov    (%eax),%eax
  8012e2:	85 c0                	test   %eax,%eax
  8012e4:	74 0d                	je     8012f3 <initialize_dyn_block_system+0x1bc>
  8012e6:	a1 38 41 80 00       	mov    0x804138,%eax
  8012eb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8012ee:	89 50 04             	mov    %edx,0x4(%eax)
  8012f1:	eb 08                	jmp    8012fb <initialize_dyn_block_system+0x1c4>
  8012f3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012f6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8012fb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012fe:	a3 38 41 80 00       	mov    %eax,0x804138
  801303:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801306:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80130d:	a1 44 41 80 00       	mov    0x804144,%eax
  801312:	40                   	inc    %eax
  801313:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  801318:	90                   	nop
  801319:	c9                   	leave  
  80131a:	c3                   	ret    

0080131b <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80131b:	55                   	push   %ebp
  80131c:	89 e5                	mov    %esp,%ebp
  80131e:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801321:	e8 e0 fd ff ff       	call   801106 <InitializeUHeap>
		if (size == 0) return NULL ;
  801326:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80132a:	75 07                	jne    801333 <malloc+0x18>
  80132c:	b8 00 00 00 00       	mov    $0x0,%eax
  801331:	eb 7f                	jmp    8013b2 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801333:	e8 d2 08 00 00       	call   801c0a <sys_isUHeapPlacementStrategyFIRSTFIT>
  801338:	85 c0                	test   %eax,%eax
  80133a:	74 71                	je     8013ad <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  80133c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801343:	8b 55 08             	mov    0x8(%ebp),%edx
  801346:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801349:	01 d0                	add    %edx,%eax
  80134b:	48                   	dec    %eax
  80134c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80134f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801352:	ba 00 00 00 00       	mov    $0x0,%edx
  801357:	f7 75 f4             	divl   -0xc(%ebp)
  80135a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135d:	29 d0                	sub    %edx,%eax
  80135f:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801362:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801369:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801370:	76 07                	jbe    801379 <malloc+0x5e>
					return NULL ;
  801372:	b8 00 00 00 00       	mov    $0x0,%eax
  801377:	eb 39                	jmp    8013b2 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801379:	83 ec 0c             	sub    $0xc,%esp
  80137c:	ff 75 08             	pushl  0x8(%ebp)
  80137f:	e8 e6 0d 00 00       	call   80216a <alloc_block_FF>
  801384:	83 c4 10             	add    $0x10,%esp
  801387:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  80138a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80138e:	74 16                	je     8013a6 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801390:	83 ec 0c             	sub    $0xc,%esp
  801393:	ff 75 ec             	pushl  -0x14(%ebp)
  801396:	e8 37 0c 00 00       	call   801fd2 <insert_sorted_allocList>
  80139b:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  80139e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a1:	8b 40 08             	mov    0x8(%eax),%eax
  8013a4:	eb 0c                	jmp    8013b2 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8013a6:	b8 00 00 00 00       	mov    $0x0,%eax
  8013ab:	eb 05                	jmp    8013b2 <malloc+0x97>
				}
		}
	return 0;
  8013ad:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8013c0:	83 ec 08             	sub    $0x8,%esp
  8013c3:	ff 75 f4             	pushl  -0xc(%ebp)
  8013c6:	68 40 40 80 00       	push   $0x804040
  8013cb:	e8 cf 0b 00 00       	call   801f9f <find_block>
  8013d0:	83 c4 10             	add    $0x10,%esp
  8013d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8013d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d9:	8b 40 0c             	mov    0xc(%eax),%eax
  8013dc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8013df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e2:	8b 40 08             	mov    0x8(%eax),%eax
  8013e5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8013e8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013ec:	0f 84 a1 00 00 00    	je     801493 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8013f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013f6:	75 17                	jne    80140f <free+0x5b>
  8013f8:	83 ec 04             	sub    $0x4,%esp
  8013fb:	68 35 38 80 00       	push   $0x803835
  801400:	68 80 00 00 00       	push   $0x80
  801405:	68 53 38 80 00       	push   $0x803853
  80140a:	e8 25 1b 00 00       	call   802f34 <_panic>
  80140f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801412:	8b 00                	mov    (%eax),%eax
  801414:	85 c0                	test   %eax,%eax
  801416:	74 10                	je     801428 <free+0x74>
  801418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141b:	8b 00                	mov    (%eax),%eax
  80141d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801420:	8b 52 04             	mov    0x4(%edx),%edx
  801423:	89 50 04             	mov    %edx,0x4(%eax)
  801426:	eb 0b                	jmp    801433 <free+0x7f>
  801428:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142b:	8b 40 04             	mov    0x4(%eax),%eax
  80142e:	a3 44 40 80 00       	mov    %eax,0x804044
  801433:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801436:	8b 40 04             	mov    0x4(%eax),%eax
  801439:	85 c0                	test   %eax,%eax
  80143b:	74 0f                	je     80144c <free+0x98>
  80143d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801440:	8b 40 04             	mov    0x4(%eax),%eax
  801443:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801446:	8b 12                	mov    (%edx),%edx
  801448:	89 10                	mov    %edx,(%eax)
  80144a:	eb 0a                	jmp    801456 <free+0xa2>
  80144c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144f:	8b 00                	mov    (%eax),%eax
  801451:	a3 40 40 80 00       	mov    %eax,0x804040
  801456:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801459:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80145f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801462:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801469:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80146e:	48                   	dec    %eax
  80146f:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  801474:	83 ec 0c             	sub    $0xc,%esp
  801477:	ff 75 f0             	pushl  -0x10(%ebp)
  80147a:	e8 29 12 00 00       	call   8026a8 <insert_sorted_with_merge_freeList>
  80147f:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801482:	83 ec 08             	sub    $0x8,%esp
  801485:	ff 75 ec             	pushl  -0x14(%ebp)
  801488:	ff 75 e8             	pushl  -0x18(%ebp)
  80148b:	e8 74 03 00 00       	call   801804 <sys_free_user_mem>
  801490:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801493:	90                   	nop
  801494:	c9                   	leave  
  801495:	c3                   	ret    

00801496 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801496:	55                   	push   %ebp
  801497:	89 e5                	mov    %esp,%ebp
  801499:	83 ec 38             	sub    $0x38,%esp
  80149c:	8b 45 10             	mov    0x10(%ebp),%eax
  80149f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014a2:	e8 5f fc ff ff       	call   801106 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014ab:	75 0a                	jne    8014b7 <smalloc+0x21>
  8014ad:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b2:	e9 b2 00 00 00       	jmp    801569 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8014b7:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8014be:	76 0a                	jbe    8014ca <smalloc+0x34>
		return NULL;
  8014c0:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c5:	e9 9f 00 00 00       	jmp    801569 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8014ca:	e8 3b 07 00 00       	call   801c0a <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014cf:	85 c0                	test   %eax,%eax
  8014d1:	0f 84 8d 00 00 00    	je     801564 <smalloc+0xce>
	struct MemBlock *b = NULL;
  8014d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8014de:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014eb:	01 d0                	add    %edx,%eax
  8014ed:	48                   	dec    %eax
  8014ee:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f9:	f7 75 f0             	divl   -0x10(%ebp)
  8014fc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014ff:	29 d0                	sub    %edx,%eax
  801501:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801504:	83 ec 0c             	sub    $0xc,%esp
  801507:	ff 75 e8             	pushl  -0x18(%ebp)
  80150a:	e8 5b 0c 00 00       	call   80216a <alloc_block_FF>
  80150f:	83 c4 10             	add    $0x10,%esp
  801512:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801515:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801519:	75 07                	jne    801522 <smalloc+0x8c>
			return NULL;
  80151b:	b8 00 00 00 00       	mov    $0x0,%eax
  801520:	eb 47                	jmp    801569 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801522:	83 ec 0c             	sub    $0xc,%esp
  801525:	ff 75 f4             	pushl  -0xc(%ebp)
  801528:	e8 a5 0a 00 00       	call   801fd2 <insert_sorted_allocList>
  80152d:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801530:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801533:	8b 40 08             	mov    0x8(%eax),%eax
  801536:	89 c2                	mov    %eax,%edx
  801538:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80153c:	52                   	push   %edx
  80153d:	50                   	push   %eax
  80153e:	ff 75 0c             	pushl  0xc(%ebp)
  801541:	ff 75 08             	pushl  0x8(%ebp)
  801544:	e8 46 04 00 00       	call   80198f <sys_createSharedObject>
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  80154f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801553:	78 08                	js     80155d <smalloc+0xc7>
		return (void *)b->sva;
  801555:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801558:	8b 40 08             	mov    0x8(%eax),%eax
  80155b:	eb 0c                	jmp    801569 <smalloc+0xd3>
		}else{
		return NULL;
  80155d:	b8 00 00 00 00       	mov    $0x0,%eax
  801562:	eb 05                	jmp    801569 <smalloc+0xd3>
			}

	}return NULL;
  801564:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801569:	c9                   	leave  
  80156a:	c3                   	ret    

0080156b <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801571:	e8 90 fb ff ff       	call   801106 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801576:	e8 8f 06 00 00       	call   801c0a <sys_isUHeapPlacementStrategyFIRSTFIT>
  80157b:	85 c0                	test   %eax,%eax
  80157d:	0f 84 ad 00 00 00    	je     801630 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801583:	83 ec 08             	sub    $0x8,%esp
  801586:	ff 75 0c             	pushl  0xc(%ebp)
  801589:	ff 75 08             	pushl  0x8(%ebp)
  80158c:	e8 28 04 00 00       	call   8019b9 <sys_getSizeOfSharedObject>
  801591:	83 c4 10             	add    $0x10,%esp
  801594:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801597:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80159b:	79 0a                	jns    8015a7 <sget+0x3c>
    {
    	return NULL;
  80159d:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a2:	e9 8e 00 00 00       	jmp    801635 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  8015a7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  8015ae:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8015b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015bb:	01 d0                	add    %edx,%eax
  8015bd:	48                   	dec    %eax
  8015be:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8015c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c9:	f7 75 ec             	divl   -0x14(%ebp)
  8015cc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015cf:	29 d0                	sub    %edx,%eax
  8015d1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8015d4:	83 ec 0c             	sub    $0xc,%esp
  8015d7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015da:	e8 8b 0b 00 00       	call   80216a <alloc_block_FF>
  8015df:	83 c4 10             	add    $0x10,%esp
  8015e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8015e5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015e9:	75 07                	jne    8015f2 <sget+0x87>
				return NULL;
  8015eb:	b8 00 00 00 00       	mov    $0x0,%eax
  8015f0:	eb 43                	jmp    801635 <sget+0xca>
			}
			insert_sorted_allocList(b);
  8015f2:	83 ec 0c             	sub    $0xc,%esp
  8015f5:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f8:	e8 d5 09 00 00       	call   801fd2 <insert_sorted_allocList>
  8015fd:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801600:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801603:	8b 40 08             	mov    0x8(%eax),%eax
  801606:	83 ec 04             	sub    $0x4,%esp
  801609:	50                   	push   %eax
  80160a:	ff 75 0c             	pushl  0xc(%ebp)
  80160d:	ff 75 08             	pushl  0x8(%ebp)
  801610:	e8 c1 03 00 00       	call   8019d6 <sys_getSharedObject>
  801615:	83 c4 10             	add    $0x10,%esp
  801618:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  80161b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80161f:	78 08                	js     801629 <sget+0xbe>
			return (void *)b->sva;
  801621:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801624:	8b 40 08             	mov    0x8(%eax),%eax
  801627:	eb 0c                	jmp    801635 <sget+0xca>
			}else{
			return NULL;
  801629:	b8 00 00 00 00       	mov    $0x0,%eax
  80162e:	eb 05                	jmp    801635 <sget+0xca>
			}
    }}return NULL;
  801630:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801635:	c9                   	leave  
  801636:	c3                   	ret    

00801637 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801637:	55                   	push   %ebp
  801638:	89 e5                	mov    %esp,%ebp
  80163a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80163d:	e8 c4 fa ff ff       	call   801106 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801642:	83 ec 04             	sub    $0x4,%esp
  801645:	68 84 38 80 00       	push   $0x803884
  80164a:	68 03 01 00 00       	push   $0x103
  80164f:	68 53 38 80 00       	push   $0x803853
  801654:	e8 db 18 00 00       	call   802f34 <_panic>

00801659 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801659:	55                   	push   %ebp
  80165a:	89 e5                	mov    %esp,%ebp
  80165c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80165f:	83 ec 04             	sub    $0x4,%esp
  801662:	68 ac 38 80 00       	push   $0x8038ac
  801667:	68 17 01 00 00       	push   $0x117
  80166c:	68 53 38 80 00       	push   $0x803853
  801671:	e8 be 18 00 00       	call   802f34 <_panic>

00801676 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801676:	55                   	push   %ebp
  801677:	89 e5                	mov    %esp,%ebp
  801679:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80167c:	83 ec 04             	sub    $0x4,%esp
  80167f:	68 d0 38 80 00       	push   $0x8038d0
  801684:	68 22 01 00 00       	push   $0x122
  801689:	68 53 38 80 00       	push   $0x803853
  80168e:	e8 a1 18 00 00       	call   802f34 <_panic>

00801693 <shrink>:

}
void shrink(uint32 newSize)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
  801696:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801699:	83 ec 04             	sub    $0x4,%esp
  80169c:	68 d0 38 80 00       	push   $0x8038d0
  8016a1:	68 27 01 00 00       	push   $0x127
  8016a6:	68 53 38 80 00       	push   $0x803853
  8016ab:	e8 84 18 00 00       	call   802f34 <_panic>

008016b0 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
  8016b3:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016b6:	83 ec 04             	sub    $0x4,%esp
  8016b9:	68 d0 38 80 00       	push   $0x8038d0
  8016be:	68 2c 01 00 00       	push   $0x12c
  8016c3:	68 53 38 80 00       	push   $0x803853
  8016c8:	e8 67 18 00 00       	call   802f34 <_panic>

008016cd <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016cd:	55                   	push   %ebp
  8016ce:	89 e5                	mov    %esp,%ebp
  8016d0:	57                   	push   %edi
  8016d1:	56                   	push   %esi
  8016d2:	53                   	push   %ebx
  8016d3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016dc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016df:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016e2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016e5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016e8:	cd 30                	int    $0x30
  8016ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016f0:	83 c4 10             	add    $0x10,%esp
  8016f3:	5b                   	pop    %ebx
  8016f4:	5e                   	pop    %esi
  8016f5:	5f                   	pop    %edi
  8016f6:	5d                   	pop    %ebp
  8016f7:	c3                   	ret    

008016f8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016f8:	55                   	push   %ebp
  8016f9:	89 e5                	mov    %esp,%ebp
  8016fb:	83 ec 04             	sub    $0x4,%esp
  8016fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801701:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801704:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	6a 00                	push   $0x0
  80170d:	6a 00                	push   $0x0
  80170f:	52                   	push   %edx
  801710:	ff 75 0c             	pushl  0xc(%ebp)
  801713:	50                   	push   %eax
  801714:	6a 00                	push   $0x0
  801716:	e8 b2 ff ff ff       	call   8016cd <syscall>
  80171b:	83 c4 18             	add    $0x18,%esp
}
  80171e:	90                   	nop
  80171f:	c9                   	leave  
  801720:	c3                   	ret    

00801721 <sys_cgetc>:

int
sys_cgetc(void)
{
  801721:	55                   	push   %ebp
  801722:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 00                	push   $0x0
  80172a:	6a 00                	push   $0x0
  80172c:	6a 00                	push   $0x0
  80172e:	6a 01                	push   $0x1
  801730:	e8 98 ff ff ff       	call   8016cd <syscall>
  801735:	83 c4 18             	add    $0x18,%esp
}
  801738:	c9                   	leave  
  801739:	c3                   	ret    

0080173a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80173a:	55                   	push   %ebp
  80173b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80173d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801740:	8b 45 08             	mov    0x8(%ebp),%eax
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	52                   	push   %edx
  80174a:	50                   	push   %eax
  80174b:	6a 05                	push   $0x5
  80174d:	e8 7b ff ff ff       	call   8016cd <syscall>
  801752:	83 c4 18             	add    $0x18,%esp
}
  801755:	c9                   	leave  
  801756:	c3                   	ret    

00801757 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801757:	55                   	push   %ebp
  801758:	89 e5                	mov    %esp,%ebp
  80175a:	56                   	push   %esi
  80175b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80175c:	8b 75 18             	mov    0x18(%ebp),%esi
  80175f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801762:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801765:	8b 55 0c             	mov    0xc(%ebp),%edx
  801768:	8b 45 08             	mov    0x8(%ebp),%eax
  80176b:	56                   	push   %esi
  80176c:	53                   	push   %ebx
  80176d:	51                   	push   %ecx
  80176e:	52                   	push   %edx
  80176f:	50                   	push   %eax
  801770:	6a 06                	push   $0x6
  801772:	e8 56 ff ff ff       	call   8016cd <syscall>
  801777:	83 c4 18             	add    $0x18,%esp
}
  80177a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177d:	5b                   	pop    %ebx
  80177e:	5e                   	pop    %esi
  80177f:	5d                   	pop    %ebp
  801780:	c3                   	ret    

00801781 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801781:	55                   	push   %ebp
  801782:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801784:	8b 55 0c             	mov    0xc(%ebp),%edx
  801787:	8b 45 08             	mov    0x8(%ebp),%eax
  80178a:	6a 00                	push   $0x0
  80178c:	6a 00                	push   $0x0
  80178e:	6a 00                	push   $0x0
  801790:	52                   	push   %edx
  801791:	50                   	push   %eax
  801792:	6a 07                	push   $0x7
  801794:	e8 34 ff ff ff       	call   8016cd <syscall>
  801799:	83 c4 18             	add    $0x18,%esp
}
  80179c:	c9                   	leave  
  80179d:	c3                   	ret    

0080179e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80179e:	55                   	push   %ebp
  80179f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017a1:	6a 00                	push   $0x0
  8017a3:	6a 00                	push   $0x0
  8017a5:	6a 00                	push   $0x0
  8017a7:	ff 75 0c             	pushl  0xc(%ebp)
  8017aa:	ff 75 08             	pushl  0x8(%ebp)
  8017ad:	6a 08                	push   $0x8
  8017af:	e8 19 ff ff ff       	call   8016cd <syscall>
  8017b4:	83 c4 18             	add    $0x18,%esp
}
  8017b7:	c9                   	leave  
  8017b8:	c3                   	ret    

008017b9 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017b9:	55                   	push   %ebp
  8017ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017bc:	6a 00                	push   $0x0
  8017be:	6a 00                	push   $0x0
  8017c0:	6a 00                	push   $0x0
  8017c2:	6a 00                	push   $0x0
  8017c4:	6a 00                	push   $0x0
  8017c6:	6a 09                	push   $0x9
  8017c8:	e8 00 ff ff ff       	call   8016cd <syscall>
  8017cd:	83 c4 18             	add    $0x18,%esp
}
  8017d0:	c9                   	leave  
  8017d1:	c3                   	ret    

008017d2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017d2:	55                   	push   %ebp
  8017d3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	6a 00                	push   $0x0
  8017db:	6a 00                	push   $0x0
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 0a                	push   $0xa
  8017e1:	e8 e7 fe ff ff       	call   8016cd <syscall>
  8017e6:	83 c4 18             	add    $0x18,%esp
}
  8017e9:	c9                   	leave  
  8017ea:	c3                   	ret    

008017eb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017eb:	55                   	push   %ebp
  8017ec:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017ee:	6a 00                	push   $0x0
  8017f0:	6a 00                	push   $0x0
  8017f2:	6a 00                	push   $0x0
  8017f4:	6a 00                	push   $0x0
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 0b                	push   $0xb
  8017fa:	e8 ce fe ff ff       	call   8016cd <syscall>
  8017ff:	83 c4 18             	add    $0x18,%esp
}
  801802:	c9                   	leave  
  801803:	c3                   	ret    

00801804 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801804:	55                   	push   %ebp
  801805:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801807:	6a 00                	push   $0x0
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	ff 75 0c             	pushl  0xc(%ebp)
  801810:	ff 75 08             	pushl  0x8(%ebp)
  801813:	6a 0f                	push   $0xf
  801815:	e8 b3 fe ff ff       	call   8016cd <syscall>
  80181a:	83 c4 18             	add    $0x18,%esp
	return;
  80181d:	90                   	nop
}
  80181e:	c9                   	leave  
  80181f:	c3                   	ret    

00801820 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801820:	55                   	push   %ebp
  801821:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801823:	6a 00                	push   $0x0
  801825:	6a 00                	push   $0x0
  801827:	6a 00                	push   $0x0
  801829:	ff 75 0c             	pushl  0xc(%ebp)
  80182c:	ff 75 08             	pushl  0x8(%ebp)
  80182f:	6a 10                	push   $0x10
  801831:	e8 97 fe ff ff       	call   8016cd <syscall>
  801836:	83 c4 18             	add    $0x18,%esp
	return ;
  801839:	90                   	nop
}
  80183a:	c9                   	leave  
  80183b:	c3                   	ret    

0080183c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80183c:	55                   	push   %ebp
  80183d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	ff 75 10             	pushl  0x10(%ebp)
  801846:	ff 75 0c             	pushl  0xc(%ebp)
  801849:	ff 75 08             	pushl  0x8(%ebp)
  80184c:	6a 11                	push   $0x11
  80184e:	e8 7a fe ff ff       	call   8016cd <syscall>
  801853:	83 c4 18             	add    $0x18,%esp
	return ;
  801856:	90                   	nop
}
  801857:	c9                   	leave  
  801858:	c3                   	ret    

00801859 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801859:	55                   	push   %ebp
  80185a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80185c:	6a 00                	push   $0x0
  80185e:	6a 00                	push   $0x0
  801860:	6a 00                	push   $0x0
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 0c                	push   $0xc
  801868:	e8 60 fe ff ff       	call   8016cd <syscall>
  80186d:	83 c4 18             	add    $0x18,%esp
}
  801870:	c9                   	leave  
  801871:	c3                   	ret    

00801872 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801872:	55                   	push   %ebp
  801873:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	6a 00                	push   $0x0
  80187d:	ff 75 08             	pushl  0x8(%ebp)
  801880:	6a 0d                	push   $0xd
  801882:	e8 46 fe ff ff       	call   8016cd <syscall>
  801887:	83 c4 18             	add    $0x18,%esp
}
  80188a:	c9                   	leave  
  80188b:	c3                   	ret    

0080188c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80188c:	55                   	push   %ebp
  80188d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 0e                	push   $0xe
  80189b:	e8 2d fe ff ff       	call   8016cd <syscall>
  8018a0:	83 c4 18             	add    $0x18,%esp
}
  8018a3:	90                   	nop
  8018a4:	c9                   	leave  
  8018a5:	c3                   	ret    

008018a6 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018a6:	55                   	push   %ebp
  8018a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 00                	push   $0x0
  8018b3:	6a 13                	push   $0x13
  8018b5:	e8 13 fe ff ff       	call   8016cd <syscall>
  8018ba:	83 c4 18             	add    $0x18,%esp
}
  8018bd:	90                   	nop
  8018be:	c9                   	leave  
  8018bf:	c3                   	ret    

008018c0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018c0:	55                   	push   %ebp
  8018c1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018c3:	6a 00                	push   $0x0
  8018c5:	6a 00                	push   $0x0
  8018c7:	6a 00                	push   $0x0
  8018c9:	6a 00                	push   $0x0
  8018cb:	6a 00                	push   $0x0
  8018cd:	6a 14                	push   $0x14
  8018cf:	e8 f9 fd ff ff       	call   8016cd <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	90                   	nop
  8018d8:	c9                   	leave  
  8018d9:	c3                   	ret    

008018da <sys_cputc>:


void
sys_cputc(const char c)
{
  8018da:	55                   	push   %ebp
  8018db:	89 e5                	mov    %esp,%ebp
  8018dd:	83 ec 04             	sub    $0x4,%esp
  8018e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018e6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018ea:	6a 00                	push   $0x0
  8018ec:	6a 00                	push   $0x0
  8018ee:	6a 00                	push   $0x0
  8018f0:	6a 00                	push   $0x0
  8018f2:	50                   	push   %eax
  8018f3:	6a 15                	push   $0x15
  8018f5:	e8 d3 fd ff ff       	call   8016cd <syscall>
  8018fa:	83 c4 18             	add    $0x18,%esp
}
  8018fd:	90                   	nop
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 16                	push   $0x16
  80190f:	e8 b9 fd ff ff       	call   8016cd <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	90                   	nop
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80191d:	8b 45 08             	mov    0x8(%ebp),%eax
  801920:	6a 00                	push   $0x0
  801922:	6a 00                	push   $0x0
  801924:	6a 00                	push   $0x0
  801926:	ff 75 0c             	pushl  0xc(%ebp)
  801929:	50                   	push   %eax
  80192a:	6a 17                	push   $0x17
  80192c:	e8 9c fd ff ff       	call   8016cd <syscall>
  801931:	83 c4 18             	add    $0x18,%esp
}
  801934:	c9                   	leave  
  801935:	c3                   	ret    

00801936 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801936:	55                   	push   %ebp
  801937:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193c:	8b 45 08             	mov    0x8(%ebp),%eax
  80193f:	6a 00                	push   $0x0
  801941:	6a 00                	push   $0x0
  801943:	6a 00                	push   $0x0
  801945:	52                   	push   %edx
  801946:	50                   	push   %eax
  801947:	6a 1a                	push   $0x1a
  801949:	e8 7f fd ff ff       	call   8016cd <syscall>
  80194e:	83 c4 18             	add    $0x18,%esp
}
  801951:	c9                   	leave  
  801952:	c3                   	ret    

00801953 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801953:	55                   	push   %ebp
  801954:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801956:	8b 55 0c             	mov    0xc(%ebp),%edx
  801959:	8b 45 08             	mov    0x8(%ebp),%eax
  80195c:	6a 00                	push   $0x0
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	52                   	push   %edx
  801963:	50                   	push   %eax
  801964:	6a 18                	push   $0x18
  801966:	e8 62 fd ff ff       	call   8016cd <syscall>
  80196b:	83 c4 18             	add    $0x18,%esp
}
  80196e:	90                   	nop
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801974:	8b 55 0c             	mov    0xc(%ebp),%edx
  801977:	8b 45 08             	mov    0x8(%ebp),%eax
  80197a:	6a 00                	push   $0x0
  80197c:	6a 00                	push   $0x0
  80197e:	6a 00                	push   $0x0
  801980:	52                   	push   %edx
  801981:	50                   	push   %eax
  801982:	6a 19                	push   $0x19
  801984:	e8 44 fd ff ff       	call   8016cd <syscall>
  801989:	83 c4 18             	add    $0x18,%esp
}
  80198c:	90                   	nop
  80198d:	c9                   	leave  
  80198e:	c3                   	ret    

0080198f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80198f:	55                   	push   %ebp
  801990:	89 e5                	mov    %esp,%ebp
  801992:	83 ec 04             	sub    $0x4,%esp
  801995:	8b 45 10             	mov    0x10(%ebp),%eax
  801998:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80199b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80199e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a5:	6a 00                	push   $0x0
  8019a7:	51                   	push   %ecx
  8019a8:	52                   	push   %edx
  8019a9:	ff 75 0c             	pushl  0xc(%ebp)
  8019ac:	50                   	push   %eax
  8019ad:	6a 1b                	push   $0x1b
  8019af:	e8 19 fd ff ff       	call   8016cd <syscall>
  8019b4:	83 c4 18             	add    $0x18,%esp
}
  8019b7:	c9                   	leave  
  8019b8:	c3                   	ret    

008019b9 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019b9:	55                   	push   %ebp
  8019ba:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c2:	6a 00                	push   $0x0
  8019c4:	6a 00                	push   $0x0
  8019c6:	6a 00                	push   $0x0
  8019c8:	52                   	push   %edx
  8019c9:	50                   	push   %eax
  8019ca:	6a 1c                	push   $0x1c
  8019cc:	e8 fc fc ff ff       	call   8016cd <syscall>
  8019d1:	83 c4 18             	add    $0x18,%esp
}
  8019d4:	c9                   	leave  
  8019d5:	c3                   	ret    

008019d6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019d6:	55                   	push   %ebp
  8019d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019d9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019dc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019df:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e2:	6a 00                	push   $0x0
  8019e4:	6a 00                	push   $0x0
  8019e6:	51                   	push   %ecx
  8019e7:	52                   	push   %edx
  8019e8:	50                   	push   %eax
  8019e9:	6a 1d                	push   $0x1d
  8019eb:	e8 dd fc ff ff       	call   8016cd <syscall>
  8019f0:	83 c4 18             	add    $0x18,%esp
}
  8019f3:	c9                   	leave  
  8019f4:	c3                   	ret    

008019f5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019f5:	55                   	push   %ebp
  8019f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	52                   	push   %edx
  801a05:	50                   	push   %eax
  801a06:	6a 1e                	push   $0x1e
  801a08:	e8 c0 fc ff ff       	call   8016cd <syscall>
  801a0d:	83 c4 18             	add    $0x18,%esp
}
  801a10:	c9                   	leave  
  801a11:	c3                   	ret    

00801a12 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a12:	55                   	push   %ebp
  801a13:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a15:	6a 00                	push   $0x0
  801a17:	6a 00                	push   $0x0
  801a19:	6a 00                	push   $0x0
  801a1b:	6a 00                	push   $0x0
  801a1d:	6a 00                	push   $0x0
  801a1f:	6a 1f                	push   $0x1f
  801a21:	e8 a7 fc ff ff       	call   8016cd <syscall>
  801a26:	83 c4 18             	add    $0x18,%esp
}
  801a29:	c9                   	leave  
  801a2a:	c3                   	ret    

00801a2b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a2b:	55                   	push   %ebp
  801a2c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a31:	6a 00                	push   $0x0
  801a33:	ff 75 14             	pushl  0x14(%ebp)
  801a36:	ff 75 10             	pushl  0x10(%ebp)
  801a39:	ff 75 0c             	pushl  0xc(%ebp)
  801a3c:	50                   	push   %eax
  801a3d:	6a 20                	push   $0x20
  801a3f:	e8 89 fc ff ff       	call   8016cd <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
}
  801a47:	c9                   	leave  
  801a48:	c3                   	ret    

00801a49 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a49:	55                   	push   %ebp
  801a4a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	50                   	push   %eax
  801a58:	6a 21                	push   $0x21
  801a5a:	e8 6e fc ff ff       	call   8016cd <syscall>
  801a5f:	83 c4 18             	add    $0x18,%esp
}
  801a62:	90                   	nop
  801a63:	c9                   	leave  
  801a64:	c3                   	ret    

00801a65 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a65:	55                   	push   %ebp
  801a66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a68:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	50                   	push   %eax
  801a74:	6a 22                	push   $0x22
  801a76:	e8 52 fc ff ff       	call   8016cd <syscall>
  801a7b:	83 c4 18             	add    $0x18,%esp
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 02                	push   $0x2
  801a8f:	e8 39 fc ff ff       	call   8016cd <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 00                	push   $0x0
  801aa6:	6a 03                	push   $0x3
  801aa8:	e8 20 fc ff ff       	call   8016cd <syscall>
  801aad:	83 c4 18             	add    $0x18,%esp
}
  801ab0:	c9                   	leave  
  801ab1:	c3                   	ret    

00801ab2 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ab2:	55                   	push   %ebp
  801ab3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ab5:	6a 00                	push   $0x0
  801ab7:	6a 00                	push   $0x0
  801ab9:	6a 00                	push   $0x0
  801abb:	6a 00                	push   $0x0
  801abd:	6a 00                	push   $0x0
  801abf:	6a 04                	push   $0x4
  801ac1:	e8 07 fc ff ff       	call   8016cd <syscall>
  801ac6:	83 c4 18             	add    $0x18,%esp
}
  801ac9:	c9                   	leave  
  801aca:	c3                   	ret    

00801acb <sys_exit_env>:


void sys_exit_env(void)
{
  801acb:	55                   	push   %ebp
  801acc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ace:	6a 00                	push   $0x0
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 23                	push   $0x23
  801ada:	e8 ee fb ff ff       	call   8016cd <syscall>
  801adf:	83 c4 18             	add    $0x18,%esp
}
  801ae2:	90                   	nop
  801ae3:	c9                   	leave  
  801ae4:	c3                   	ret    

00801ae5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ae5:	55                   	push   %ebp
  801ae6:	89 e5                	mov    %esp,%ebp
  801ae8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801aeb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aee:	8d 50 04             	lea    0x4(%eax),%edx
  801af1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801af4:	6a 00                	push   $0x0
  801af6:	6a 00                	push   $0x0
  801af8:	6a 00                	push   $0x0
  801afa:	52                   	push   %edx
  801afb:	50                   	push   %eax
  801afc:	6a 24                	push   $0x24
  801afe:	e8 ca fb ff ff       	call   8016cd <syscall>
  801b03:	83 c4 18             	add    $0x18,%esp
	return result;
  801b06:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b09:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b0c:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b0f:	89 01                	mov    %eax,(%ecx)
  801b11:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b14:	8b 45 08             	mov    0x8(%ebp),%eax
  801b17:	c9                   	leave  
  801b18:	c2 04 00             	ret    $0x4

00801b1b <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b1b:	55                   	push   %ebp
  801b1c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b1e:	6a 00                	push   $0x0
  801b20:	6a 00                	push   $0x0
  801b22:	ff 75 10             	pushl  0x10(%ebp)
  801b25:	ff 75 0c             	pushl  0xc(%ebp)
  801b28:	ff 75 08             	pushl  0x8(%ebp)
  801b2b:	6a 12                	push   $0x12
  801b2d:	e8 9b fb ff ff       	call   8016cd <syscall>
  801b32:	83 c4 18             	add    $0x18,%esp
	return ;
  801b35:	90                   	nop
}
  801b36:	c9                   	leave  
  801b37:	c3                   	ret    

00801b38 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b38:	55                   	push   %ebp
  801b39:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	6a 00                	push   $0x0
  801b43:	6a 00                	push   $0x0
  801b45:	6a 25                	push   $0x25
  801b47:	e8 81 fb ff ff       	call   8016cd <syscall>
  801b4c:	83 c4 18             	add    $0x18,%esp
}
  801b4f:	c9                   	leave  
  801b50:	c3                   	ret    

00801b51 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b51:	55                   	push   %ebp
  801b52:	89 e5                	mov    %esp,%ebp
  801b54:	83 ec 04             	sub    $0x4,%esp
  801b57:	8b 45 08             	mov    0x8(%ebp),%eax
  801b5a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b5d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b61:	6a 00                	push   $0x0
  801b63:	6a 00                	push   $0x0
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	50                   	push   %eax
  801b6a:	6a 26                	push   $0x26
  801b6c:	e8 5c fb ff ff       	call   8016cd <syscall>
  801b71:	83 c4 18             	add    $0x18,%esp
	return ;
  801b74:	90                   	nop
}
  801b75:	c9                   	leave  
  801b76:	c3                   	ret    

00801b77 <rsttst>:
void rsttst()
{
  801b77:	55                   	push   %ebp
  801b78:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b7a:	6a 00                	push   $0x0
  801b7c:	6a 00                	push   $0x0
  801b7e:	6a 00                	push   $0x0
  801b80:	6a 00                	push   $0x0
  801b82:	6a 00                	push   $0x0
  801b84:	6a 28                	push   $0x28
  801b86:	e8 42 fb ff ff       	call   8016cd <syscall>
  801b8b:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8e:	90                   	nop
}
  801b8f:	c9                   	leave  
  801b90:	c3                   	ret    

00801b91 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b91:	55                   	push   %ebp
  801b92:	89 e5                	mov    %esp,%ebp
  801b94:	83 ec 04             	sub    $0x4,%esp
  801b97:	8b 45 14             	mov    0x14(%ebp),%eax
  801b9a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b9d:	8b 55 18             	mov    0x18(%ebp),%edx
  801ba0:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ba4:	52                   	push   %edx
  801ba5:	50                   	push   %eax
  801ba6:	ff 75 10             	pushl  0x10(%ebp)
  801ba9:	ff 75 0c             	pushl  0xc(%ebp)
  801bac:	ff 75 08             	pushl  0x8(%ebp)
  801baf:	6a 27                	push   $0x27
  801bb1:	e8 17 fb ff ff       	call   8016cd <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb9:	90                   	nop
}
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <chktst>:
void chktst(uint32 n)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bbf:	6a 00                	push   $0x0
  801bc1:	6a 00                	push   $0x0
  801bc3:	6a 00                	push   $0x0
  801bc5:	6a 00                	push   $0x0
  801bc7:	ff 75 08             	pushl  0x8(%ebp)
  801bca:	6a 29                	push   $0x29
  801bcc:	e8 fc fa ff ff       	call   8016cd <syscall>
  801bd1:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd4:	90                   	nop
}
  801bd5:	c9                   	leave  
  801bd6:	c3                   	ret    

00801bd7 <inctst>:

void inctst()
{
  801bd7:	55                   	push   %ebp
  801bd8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bda:	6a 00                	push   $0x0
  801bdc:	6a 00                	push   $0x0
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 2a                	push   $0x2a
  801be6:	e8 e2 fa ff ff       	call   8016cd <syscall>
  801beb:	83 c4 18             	add    $0x18,%esp
	return ;
  801bee:	90                   	nop
}
  801bef:	c9                   	leave  
  801bf0:	c3                   	ret    

00801bf1 <gettst>:
uint32 gettst()
{
  801bf1:	55                   	push   %ebp
  801bf2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 00                	push   $0x0
  801bfa:	6a 00                	push   $0x0
  801bfc:	6a 00                	push   $0x0
  801bfe:	6a 2b                	push   $0x2b
  801c00:	e8 c8 fa ff ff       	call   8016cd <syscall>
  801c05:	83 c4 18             	add    $0x18,%esp
}
  801c08:	c9                   	leave  
  801c09:	c3                   	ret    

00801c0a <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c0a:	55                   	push   %ebp
  801c0b:	89 e5                	mov    %esp,%ebp
  801c0d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	6a 00                	push   $0x0
  801c18:	6a 00                	push   $0x0
  801c1a:	6a 2c                	push   $0x2c
  801c1c:	e8 ac fa ff ff       	call   8016cd <syscall>
  801c21:	83 c4 18             	add    $0x18,%esp
  801c24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c27:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c2b:	75 07                	jne    801c34 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c2d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c32:	eb 05                	jmp    801c39 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c34:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c39:	c9                   	leave  
  801c3a:	c3                   	ret    

00801c3b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c3b:	55                   	push   %ebp
  801c3c:	89 e5                	mov    %esp,%ebp
  801c3e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c41:	6a 00                	push   $0x0
  801c43:	6a 00                	push   $0x0
  801c45:	6a 00                	push   $0x0
  801c47:	6a 00                	push   $0x0
  801c49:	6a 00                	push   $0x0
  801c4b:	6a 2c                	push   $0x2c
  801c4d:	e8 7b fa ff ff       	call   8016cd <syscall>
  801c52:	83 c4 18             	add    $0x18,%esp
  801c55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c58:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c5c:	75 07                	jne    801c65 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c5e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c63:	eb 05                	jmp    801c6a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c6a:	c9                   	leave  
  801c6b:	c3                   	ret    

00801c6c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c6c:	55                   	push   %ebp
  801c6d:	89 e5                	mov    %esp,%ebp
  801c6f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c72:	6a 00                	push   $0x0
  801c74:	6a 00                	push   $0x0
  801c76:	6a 00                	push   $0x0
  801c78:	6a 00                	push   $0x0
  801c7a:	6a 00                	push   $0x0
  801c7c:	6a 2c                	push   $0x2c
  801c7e:	e8 4a fa ff ff       	call   8016cd <syscall>
  801c83:	83 c4 18             	add    $0x18,%esp
  801c86:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c89:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c8d:	75 07                	jne    801c96 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c8f:	b8 01 00 00 00       	mov    $0x1,%eax
  801c94:	eb 05                	jmp    801c9b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c96:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9b:	c9                   	leave  
  801c9c:	c3                   	ret    

00801c9d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c9d:	55                   	push   %ebp
  801c9e:	89 e5                	mov    %esp,%ebp
  801ca0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca3:	6a 00                	push   $0x0
  801ca5:	6a 00                	push   $0x0
  801ca7:	6a 00                	push   $0x0
  801ca9:	6a 00                	push   $0x0
  801cab:	6a 00                	push   $0x0
  801cad:	6a 2c                	push   $0x2c
  801caf:	e8 19 fa ff ff       	call   8016cd <syscall>
  801cb4:	83 c4 18             	add    $0x18,%esp
  801cb7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cba:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cbe:	75 07                	jne    801cc7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cc0:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc5:	eb 05                	jmp    801ccc <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cc7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccc:	c9                   	leave  
  801ccd:	c3                   	ret    

00801cce <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801cce:	55                   	push   %ebp
  801ccf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cd1:	6a 00                	push   $0x0
  801cd3:	6a 00                	push   $0x0
  801cd5:	6a 00                	push   $0x0
  801cd7:	6a 00                	push   $0x0
  801cd9:	ff 75 08             	pushl  0x8(%ebp)
  801cdc:	6a 2d                	push   $0x2d
  801cde:	e8 ea f9 ff ff       	call   8016cd <syscall>
  801ce3:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce6:	90                   	nop
}
  801ce7:	c9                   	leave  
  801ce8:	c3                   	ret    

00801ce9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801ced:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cf0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf6:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf9:	6a 00                	push   $0x0
  801cfb:	53                   	push   %ebx
  801cfc:	51                   	push   %ecx
  801cfd:	52                   	push   %edx
  801cfe:	50                   	push   %eax
  801cff:	6a 2e                	push   $0x2e
  801d01:	e8 c7 f9 ff ff       	call   8016cd <syscall>
  801d06:	83 c4 18             	add    $0x18,%esp
}
  801d09:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0c:	c9                   	leave  
  801d0d:	c3                   	ret    

00801d0e <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d0e:	55                   	push   %ebp
  801d0f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d11:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d14:	8b 45 08             	mov    0x8(%ebp),%eax
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	52                   	push   %edx
  801d1e:	50                   	push   %eax
  801d1f:	6a 2f                	push   $0x2f
  801d21:	e8 a7 f9 ff ff       	call   8016cd <syscall>
  801d26:	83 c4 18             	add    $0x18,%esp
}
  801d29:	c9                   	leave  
  801d2a:	c3                   	ret    

00801d2b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d2b:	55                   	push   %ebp
  801d2c:	89 e5                	mov    %esp,%ebp
  801d2e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d31:	83 ec 0c             	sub    $0xc,%esp
  801d34:	68 e0 38 80 00       	push   $0x8038e0
  801d39:	e8 3e e6 ff ff       	call   80037c <cprintf>
  801d3e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d41:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d48:	83 ec 0c             	sub    $0xc,%esp
  801d4b:	68 0c 39 80 00       	push   $0x80390c
  801d50:	e8 27 e6 ff ff       	call   80037c <cprintf>
  801d55:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d58:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d5c:	a1 38 41 80 00       	mov    0x804138,%eax
  801d61:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d64:	eb 56                	jmp    801dbc <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d66:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d6a:	74 1c                	je     801d88 <print_mem_block_lists+0x5d>
  801d6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6f:	8b 50 08             	mov    0x8(%eax),%edx
  801d72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d75:	8b 48 08             	mov    0x8(%eax),%ecx
  801d78:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7b:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7e:	01 c8                	add    %ecx,%eax
  801d80:	39 c2                	cmp    %eax,%edx
  801d82:	73 04                	jae    801d88 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d84:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d88:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8b:	8b 50 08             	mov    0x8(%eax),%edx
  801d8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d91:	8b 40 0c             	mov    0xc(%eax),%eax
  801d94:	01 c2                	add    %eax,%edx
  801d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d99:	8b 40 08             	mov    0x8(%eax),%eax
  801d9c:	83 ec 04             	sub    $0x4,%esp
  801d9f:	52                   	push   %edx
  801da0:	50                   	push   %eax
  801da1:	68 21 39 80 00       	push   $0x803921
  801da6:	e8 d1 e5 ff ff       	call   80037c <cprintf>
  801dab:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801db4:	a1 40 41 80 00       	mov    0x804140,%eax
  801db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dbc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dc0:	74 07                	je     801dc9 <print_mem_block_lists+0x9e>
  801dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc5:	8b 00                	mov    (%eax),%eax
  801dc7:	eb 05                	jmp    801dce <print_mem_block_lists+0xa3>
  801dc9:	b8 00 00 00 00       	mov    $0x0,%eax
  801dce:	a3 40 41 80 00       	mov    %eax,0x804140
  801dd3:	a1 40 41 80 00       	mov    0x804140,%eax
  801dd8:	85 c0                	test   %eax,%eax
  801dda:	75 8a                	jne    801d66 <print_mem_block_lists+0x3b>
  801ddc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801de0:	75 84                	jne    801d66 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801de2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801de6:	75 10                	jne    801df8 <print_mem_block_lists+0xcd>
  801de8:	83 ec 0c             	sub    $0xc,%esp
  801deb:	68 30 39 80 00       	push   $0x803930
  801df0:	e8 87 e5 ff ff       	call   80037c <cprintf>
  801df5:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801df8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dff:	83 ec 0c             	sub    $0xc,%esp
  801e02:	68 54 39 80 00       	push   $0x803954
  801e07:	e8 70 e5 ff ff       	call   80037c <cprintf>
  801e0c:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e0f:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e13:	a1 40 40 80 00       	mov    0x804040,%eax
  801e18:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e1b:	eb 56                	jmp    801e73 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e21:	74 1c                	je     801e3f <print_mem_block_lists+0x114>
  801e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e26:	8b 50 08             	mov    0x8(%eax),%edx
  801e29:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2c:	8b 48 08             	mov    0x8(%eax),%ecx
  801e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e32:	8b 40 0c             	mov    0xc(%eax),%eax
  801e35:	01 c8                	add    %ecx,%eax
  801e37:	39 c2                	cmp    %eax,%edx
  801e39:	73 04                	jae    801e3f <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e3b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e42:	8b 50 08             	mov    0x8(%eax),%edx
  801e45:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e48:	8b 40 0c             	mov    0xc(%eax),%eax
  801e4b:	01 c2                	add    %eax,%edx
  801e4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e50:	8b 40 08             	mov    0x8(%eax),%eax
  801e53:	83 ec 04             	sub    $0x4,%esp
  801e56:	52                   	push   %edx
  801e57:	50                   	push   %eax
  801e58:	68 21 39 80 00       	push   $0x803921
  801e5d:	e8 1a e5 ff ff       	call   80037c <cprintf>
  801e62:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e68:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e6b:	a1 48 40 80 00       	mov    0x804048,%eax
  801e70:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e73:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e77:	74 07                	je     801e80 <print_mem_block_lists+0x155>
  801e79:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7c:	8b 00                	mov    (%eax),%eax
  801e7e:	eb 05                	jmp    801e85 <print_mem_block_lists+0x15a>
  801e80:	b8 00 00 00 00       	mov    $0x0,%eax
  801e85:	a3 48 40 80 00       	mov    %eax,0x804048
  801e8a:	a1 48 40 80 00       	mov    0x804048,%eax
  801e8f:	85 c0                	test   %eax,%eax
  801e91:	75 8a                	jne    801e1d <print_mem_block_lists+0xf2>
  801e93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e97:	75 84                	jne    801e1d <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e99:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e9d:	75 10                	jne    801eaf <print_mem_block_lists+0x184>
  801e9f:	83 ec 0c             	sub    $0xc,%esp
  801ea2:	68 6c 39 80 00       	push   $0x80396c
  801ea7:	e8 d0 e4 ff ff       	call   80037c <cprintf>
  801eac:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801eaf:	83 ec 0c             	sub    $0xc,%esp
  801eb2:	68 e0 38 80 00       	push   $0x8038e0
  801eb7:	e8 c0 e4 ff ff       	call   80037c <cprintf>
  801ebc:	83 c4 10             	add    $0x10,%esp

}
  801ebf:	90                   	nop
  801ec0:	c9                   	leave  
  801ec1:	c3                   	ret    

00801ec2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ec2:	55                   	push   %ebp
  801ec3:	89 e5                	mov    %esp,%ebp
  801ec5:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801ec8:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801ecf:	00 00 00 
  801ed2:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801ed9:	00 00 00 
  801edc:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801ee3:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  801ee6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801eed:	e9 9e 00 00 00       	jmp    801f90 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  801ef2:	a1 50 40 80 00       	mov    0x804050,%eax
  801ef7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801efa:	c1 e2 04             	shl    $0x4,%edx
  801efd:	01 d0                	add    %edx,%eax
  801eff:	85 c0                	test   %eax,%eax
  801f01:	75 14                	jne    801f17 <initialize_MemBlocksList+0x55>
  801f03:	83 ec 04             	sub    $0x4,%esp
  801f06:	68 94 39 80 00       	push   $0x803994
  801f0b:	6a 3d                	push   $0x3d
  801f0d:	68 b7 39 80 00       	push   $0x8039b7
  801f12:	e8 1d 10 00 00       	call   802f34 <_panic>
  801f17:	a1 50 40 80 00       	mov    0x804050,%eax
  801f1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1f:	c1 e2 04             	shl    $0x4,%edx
  801f22:	01 d0                	add    %edx,%eax
  801f24:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801f2a:	89 10                	mov    %edx,(%eax)
  801f2c:	8b 00                	mov    (%eax),%eax
  801f2e:	85 c0                	test   %eax,%eax
  801f30:	74 18                	je     801f4a <initialize_MemBlocksList+0x88>
  801f32:	a1 48 41 80 00       	mov    0x804148,%eax
  801f37:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f3d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f40:	c1 e1 04             	shl    $0x4,%ecx
  801f43:	01 ca                	add    %ecx,%edx
  801f45:	89 50 04             	mov    %edx,0x4(%eax)
  801f48:	eb 12                	jmp    801f5c <initialize_MemBlocksList+0x9a>
  801f4a:	a1 50 40 80 00       	mov    0x804050,%eax
  801f4f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f52:	c1 e2 04             	shl    $0x4,%edx
  801f55:	01 d0                	add    %edx,%eax
  801f57:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801f5c:	a1 50 40 80 00       	mov    0x804050,%eax
  801f61:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f64:	c1 e2 04             	shl    $0x4,%edx
  801f67:	01 d0                	add    %edx,%eax
  801f69:	a3 48 41 80 00       	mov    %eax,0x804148
  801f6e:	a1 50 40 80 00       	mov    0x804050,%eax
  801f73:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f76:	c1 e2 04             	shl    $0x4,%edx
  801f79:	01 d0                	add    %edx,%eax
  801f7b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f82:	a1 54 41 80 00       	mov    0x804154,%eax
  801f87:	40                   	inc    %eax
  801f88:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  801f8d:	ff 45 f4             	incl   -0xc(%ebp)
  801f90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f93:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f96:	0f 82 56 ff ff ff    	jb     801ef2 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  801f9c:	90                   	nop
  801f9d:	c9                   	leave  
  801f9e:	c3                   	ret    

00801f9f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f9f:	55                   	push   %ebp
  801fa0:	89 e5                	mov    %esp,%ebp
  801fa2:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  801fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa8:	8b 00                	mov    (%eax),%eax
  801faa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  801fad:	eb 18                	jmp    801fc7 <find_block+0x28>

		if(tmp->sva == va){
  801faf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb2:	8b 40 08             	mov    0x8(%eax),%eax
  801fb5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fb8:	75 05                	jne    801fbf <find_block+0x20>
			return tmp ;
  801fba:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fbd:	eb 11                	jmp    801fd0 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  801fbf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc2:	8b 00                	mov    (%eax),%eax
  801fc4:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  801fc7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fcb:	75 e2                	jne    801faf <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  801fcd:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fd0:	c9                   	leave  
  801fd1:	c3                   	ret    

00801fd2 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fd2:	55                   	push   %ebp
  801fd3:	89 e5                	mov    %esp,%ebp
  801fd5:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  801fd8:	a1 40 40 80 00       	mov    0x804040,%eax
  801fdd:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  801fe0:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fe5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  801fe8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801fec:	75 65                	jne    802053 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  801fee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ff2:	75 14                	jne    802008 <insert_sorted_allocList+0x36>
  801ff4:	83 ec 04             	sub    $0x4,%esp
  801ff7:	68 94 39 80 00       	push   $0x803994
  801ffc:	6a 62                	push   $0x62
  801ffe:	68 b7 39 80 00       	push   $0x8039b7
  802003:	e8 2c 0f 00 00       	call   802f34 <_panic>
  802008:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80200e:	8b 45 08             	mov    0x8(%ebp),%eax
  802011:	89 10                	mov    %edx,(%eax)
  802013:	8b 45 08             	mov    0x8(%ebp),%eax
  802016:	8b 00                	mov    (%eax),%eax
  802018:	85 c0                	test   %eax,%eax
  80201a:	74 0d                	je     802029 <insert_sorted_allocList+0x57>
  80201c:	a1 40 40 80 00       	mov    0x804040,%eax
  802021:	8b 55 08             	mov    0x8(%ebp),%edx
  802024:	89 50 04             	mov    %edx,0x4(%eax)
  802027:	eb 08                	jmp    802031 <insert_sorted_allocList+0x5f>
  802029:	8b 45 08             	mov    0x8(%ebp),%eax
  80202c:	a3 44 40 80 00       	mov    %eax,0x804044
  802031:	8b 45 08             	mov    0x8(%ebp),%eax
  802034:	a3 40 40 80 00       	mov    %eax,0x804040
  802039:	8b 45 08             	mov    0x8(%ebp),%eax
  80203c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802043:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802048:	40                   	inc    %eax
  802049:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80204e:	e9 14 01 00 00       	jmp    802167 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802053:	8b 45 08             	mov    0x8(%ebp),%eax
  802056:	8b 50 08             	mov    0x8(%eax),%edx
  802059:	a1 44 40 80 00       	mov    0x804044,%eax
  80205e:	8b 40 08             	mov    0x8(%eax),%eax
  802061:	39 c2                	cmp    %eax,%edx
  802063:	76 65                	jbe    8020ca <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802065:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802069:	75 14                	jne    80207f <insert_sorted_allocList+0xad>
  80206b:	83 ec 04             	sub    $0x4,%esp
  80206e:	68 d0 39 80 00       	push   $0x8039d0
  802073:	6a 64                	push   $0x64
  802075:	68 b7 39 80 00       	push   $0x8039b7
  80207a:	e8 b5 0e 00 00       	call   802f34 <_panic>
  80207f:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802085:	8b 45 08             	mov    0x8(%ebp),%eax
  802088:	89 50 04             	mov    %edx,0x4(%eax)
  80208b:	8b 45 08             	mov    0x8(%ebp),%eax
  80208e:	8b 40 04             	mov    0x4(%eax),%eax
  802091:	85 c0                	test   %eax,%eax
  802093:	74 0c                	je     8020a1 <insert_sorted_allocList+0xcf>
  802095:	a1 44 40 80 00       	mov    0x804044,%eax
  80209a:	8b 55 08             	mov    0x8(%ebp),%edx
  80209d:	89 10                	mov    %edx,(%eax)
  80209f:	eb 08                	jmp    8020a9 <insert_sorted_allocList+0xd7>
  8020a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a4:	a3 40 40 80 00       	mov    %eax,0x804040
  8020a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ac:	a3 44 40 80 00       	mov    %eax,0x804044
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020ba:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020bf:	40                   	inc    %eax
  8020c0:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8020c5:	e9 9d 00 00 00       	jmp    802167 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8020ca:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8020d1:	e9 85 00 00 00       	jmp    80215b <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8020d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d9:	8b 50 08             	mov    0x8(%eax),%edx
  8020dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020df:	8b 40 08             	mov    0x8(%eax),%eax
  8020e2:	39 c2                	cmp    %eax,%edx
  8020e4:	73 6a                	jae    802150 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8020e6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020ea:	74 06                	je     8020f2 <insert_sorted_allocList+0x120>
  8020ec:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020f0:	75 14                	jne    802106 <insert_sorted_allocList+0x134>
  8020f2:	83 ec 04             	sub    $0x4,%esp
  8020f5:	68 f4 39 80 00       	push   $0x8039f4
  8020fa:	6a 6b                	push   $0x6b
  8020fc:	68 b7 39 80 00       	push   $0x8039b7
  802101:	e8 2e 0e 00 00       	call   802f34 <_panic>
  802106:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802109:	8b 50 04             	mov    0x4(%eax),%edx
  80210c:	8b 45 08             	mov    0x8(%ebp),%eax
  80210f:	89 50 04             	mov    %edx,0x4(%eax)
  802112:	8b 45 08             	mov    0x8(%ebp),%eax
  802115:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802118:	89 10                	mov    %edx,(%eax)
  80211a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211d:	8b 40 04             	mov    0x4(%eax),%eax
  802120:	85 c0                	test   %eax,%eax
  802122:	74 0d                	je     802131 <insert_sorted_allocList+0x15f>
  802124:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802127:	8b 40 04             	mov    0x4(%eax),%eax
  80212a:	8b 55 08             	mov    0x8(%ebp),%edx
  80212d:	89 10                	mov    %edx,(%eax)
  80212f:	eb 08                	jmp    802139 <insert_sorted_allocList+0x167>
  802131:	8b 45 08             	mov    0x8(%ebp),%eax
  802134:	a3 40 40 80 00       	mov    %eax,0x804040
  802139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213c:	8b 55 08             	mov    0x8(%ebp),%edx
  80213f:	89 50 04             	mov    %edx,0x4(%eax)
  802142:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802147:	40                   	inc    %eax
  802148:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  80214d:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80214e:	eb 17                	jmp    802167 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802150:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802153:	8b 00                	mov    (%eax),%eax
  802155:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802158:	ff 45 f0             	incl   -0x10(%ebp)
  80215b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802161:	0f 8c 6f ff ff ff    	jl     8020d6 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802167:	90                   	nop
  802168:	c9                   	leave  
  802169:	c3                   	ret    

0080216a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80216a:	55                   	push   %ebp
  80216b:	89 e5                	mov    %esp,%ebp
  80216d:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802170:	a1 38 41 80 00       	mov    0x804138,%eax
  802175:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802178:	e9 7c 01 00 00       	jmp    8022f9 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  80217d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802180:	8b 40 0c             	mov    0xc(%eax),%eax
  802183:	3b 45 08             	cmp    0x8(%ebp),%eax
  802186:	0f 86 cf 00 00 00    	jbe    80225b <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80218c:	a1 48 41 80 00       	mov    0x804148,%eax
  802191:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802197:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  80219a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219d:	8b 55 08             	mov    0x8(%ebp),%edx
  8021a0:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8021a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a6:	8b 50 08             	mov    0x8(%eax),%edx
  8021a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ac:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8021af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b2:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b5:	2b 45 08             	sub    0x8(%ebp),%eax
  8021b8:	89 c2                	mov    %eax,%edx
  8021ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bd:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8021c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c3:	8b 50 08             	mov    0x8(%eax),%edx
  8021c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c9:	01 c2                	add    %eax,%edx
  8021cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021ce:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8021d1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021d5:	75 17                	jne    8021ee <alloc_block_FF+0x84>
  8021d7:	83 ec 04             	sub    $0x4,%esp
  8021da:	68 29 3a 80 00       	push   $0x803a29
  8021df:	68 83 00 00 00       	push   $0x83
  8021e4:	68 b7 39 80 00       	push   $0x8039b7
  8021e9:	e8 46 0d 00 00       	call   802f34 <_panic>
  8021ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f1:	8b 00                	mov    (%eax),%eax
  8021f3:	85 c0                	test   %eax,%eax
  8021f5:	74 10                	je     802207 <alloc_block_FF+0x9d>
  8021f7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021fa:	8b 00                	mov    (%eax),%eax
  8021fc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021ff:	8b 52 04             	mov    0x4(%edx),%edx
  802202:	89 50 04             	mov    %edx,0x4(%eax)
  802205:	eb 0b                	jmp    802212 <alloc_block_FF+0xa8>
  802207:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80220a:	8b 40 04             	mov    0x4(%eax),%eax
  80220d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802212:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802215:	8b 40 04             	mov    0x4(%eax),%eax
  802218:	85 c0                	test   %eax,%eax
  80221a:	74 0f                	je     80222b <alloc_block_FF+0xc1>
  80221c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221f:	8b 40 04             	mov    0x4(%eax),%eax
  802222:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802225:	8b 12                	mov    (%edx),%edx
  802227:	89 10                	mov    %edx,(%eax)
  802229:	eb 0a                	jmp    802235 <alloc_block_FF+0xcb>
  80222b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222e:	8b 00                	mov    (%eax),%eax
  802230:	a3 48 41 80 00       	mov    %eax,0x804148
  802235:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802238:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80223e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802241:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802248:	a1 54 41 80 00       	mov    0x804154,%eax
  80224d:	48                   	dec    %eax
  80224e:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  802253:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802256:	e9 ad 00 00 00       	jmp    802308 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  80225b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225e:	8b 40 0c             	mov    0xc(%eax),%eax
  802261:	3b 45 08             	cmp    0x8(%ebp),%eax
  802264:	0f 85 87 00 00 00    	jne    8022f1 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  80226a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226e:	75 17                	jne    802287 <alloc_block_FF+0x11d>
  802270:	83 ec 04             	sub    $0x4,%esp
  802273:	68 29 3a 80 00       	push   $0x803a29
  802278:	68 87 00 00 00       	push   $0x87
  80227d:	68 b7 39 80 00       	push   $0x8039b7
  802282:	e8 ad 0c 00 00       	call   802f34 <_panic>
  802287:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80228a:	8b 00                	mov    (%eax),%eax
  80228c:	85 c0                	test   %eax,%eax
  80228e:	74 10                	je     8022a0 <alloc_block_FF+0x136>
  802290:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802293:	8b 00                	mov    (%eax),%eax
  802295:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802298:	8b 52 04             	mov    0x4(%edx),%edx
  80229b:	89 50 04             	mov    %edx,0x4(%eax)
  80229e:	eb 0b                	jmp    8022ab <alloc_block_FF+0x141>
  8022a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a3:	8b 40 04             	mov    0x4(%eax),%eax
  8022a6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ae:	8b 40 04             	mov    0x4(%eax),%eax
  8022b1:	85 c0                	test   %eax,%eax
  8022b3:	74 0f                	je     8022c4 <alloc_block_FF+0x15a>
  8022b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b8:	8b 40 04             	mov    0x4(%eax),%eax
  8022bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022be:	8b 12                	mov    (%edx),%edx
  8022c0:	89 10                	mov    %edx,(%eax)
  8022c2:	eb 0a                	jmp    8022ce <alloc_block_FF+0x164>
  8022c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c7:	8b 00                	mov    (%eax),%eax
  8022c9:	a3 38 41 80 00       	mov    %eax,0x804138
  8022ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022da:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e1:	a1 44 41 80 00       	mov    0x804144,%eax
  8022e6:	48                   	dec    %eax
  8022e7:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8022ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ef:	eb 17                	jmp    802308 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8022f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f4:	8b 00                	mov    (%eax),%eax
  8022f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8022f9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fd:	0f 85 7a fe ff ff    	jne    80217d <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802303:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802308:	c9                   	leave  
  802309:	c3                   	ret    

0080230a <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  80230a:	55                   	push   %ebp
  80230b:	89 e5                	mov    %esp,%ebp
  80230d:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802310:	a1 38 41 80 00       	mov    0x804138,%eax
  802315:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802318:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  80231f:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802326:	a1 38 41 80 00       	mov    0x804138,%eax
  80232b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232e:	e9 d0 00 00 00       	jmp    802403 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802333:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802336:	8b 40 0c             	mov    0xc(%eax),%eax
  802339:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233c:	0f 82 b8 00 00 00    	jb     8023fa <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802342:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802345:	8b 40 0c             	mov    0xc(%eax),%eax
  802348:	2b 45 08             	sub    0x8(%ebp),%eax
  80234b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  80234e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802351:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802354:	0f 83 a1 00 00 00    	jae    8023fb <alloc_block_BF+0xf1>
				differsize = differance ;
  80235a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80235d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802363:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802366:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80236a:	0f 85 8b 00 00 00    	jne    8023fb <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802370:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802374:	75 17                	jne    80238d <alloc_block_BF+0x83>
  802376:	83 ec 04             	sub    $0x4,%esp
  802379:	68 29 3a 80 00       	push   $0x803a29
  80237e:	68 a0 00 00 00       	push   $0xa0
  802383:	68 b7 39 80 00       	push   $0x8039b7
  802388:	e8 a7 0b 00 00       	call   802f34 <_panic>
  80238d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802390:	8b 00                	mov    (%eax),%eax
  802392:	85 c0                	test   %eax,%eax
  802394:	74 10                	je     8023a6 <alloc_block_BF+0x9c>
  802396:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802399:	8b 00                	mov    (%eax),%eax
  80239b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239e:	8b 52 04             	mov    0x4(%edx),%edx
  8023a1:	89 50 04             	mov    %edx,0x4(%eax)
  8023a4:	eb 0b                	jmp    8023b1 <alloc_block_BF+0xa7>
  8023a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a9:	8b 40 04             	mov    0x4(%eax),%eax
  8023ac:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b4:	8b 40 04             	mov    0x4(%eax),%eax
  8023b7:	85 c0                	test   %eax,%eax
  8023b9:	74 0f                	je     8023ca <alloc_block_BF+0xc0>
  8023bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023be:	8b 40 04             	mov    0x4(%eax),%eax
  8023c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c4:	8b 12                	mov    (%edx),%edx
  8023c6:	89 10                	mov    %edx,(%eax)
  8023c8:	eb 0a                	jmp    8023d4 <alloc_block_BF+0xca>
  8023ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cd:	8b 00                	mov    (%eax),%eax
  8023cf:	a3 38 41 80 00       	mov    %eax,0x804138
  8023d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e7:	a1 44 41 80 00       	mov    0x804144,%eax
  8023ec:	48                   	dec    %eax
  8023ed:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	e9 0c 01 00 00       	jmp    802506 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8023fa:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8023fb:	a1 40 41 80 00       	mov    0x804140,%eax
  802400:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802403:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802407:	74 07                	je     802410 <alloc_block_BF+0x106>
  802409:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240c:	8b 00                	mov    (%eax),%eax
  80240e:	eb 05                	jmp    802415 <alloc_block_BF+0x10b>
  802410:	b8 00 00 00 00       	mov    $0x0,%eax
  802415:	a3 40 41 80 00       	mov    %eax,0x804140
  80241a:	a1 40 41 80 00       	mov    0x804140,%eax
  80241f:	85 c0                	test   %eax,%eax
  802421:	0f 85 0c ff ff ff    	jne    802333 <alloc_block_BF+0x29>
  802427:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242b:	0f 85 02 ff ff ff    	jne    802333 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802431:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802435:	0f 84 c6 00 00 00    	je     802501 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  80243b:	a1 48 41 80 00       	mov    0x804148,%eax
  802440:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802443:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802446:	8b 55 08             	mov    0x8(%ebp),%edx
  802449:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  80244c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244f:	8b 50 08             	mov    0x8(%eax),%edx
  802452:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802455:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802458:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245b:	8b 40 0c             	mov    0xc(%eax),%eax
  80245e:	2b 45 08             	sub    0x8(%ebp),%eax
  802461:	89 c2                	mov    %eax,%edx
  802463:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802466:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802469:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246c:	8b 50 08             	mov    0x8(%eax),%edx
  80246f:	8b 45 08             	mov    0x8(%ebp),%eax
  802472:	01 c2                	add    %eax,%edx
  802474:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802477:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  80247a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80247e:	75 17                	jne    802497 <alloc_block_BF+0x18d>
  802480:	83 ec 04             	sub    $0x4,%esp
  802483:	68 29 3a 80 00       	push   $0x803a29
  802488:	68 af 00 00 00       	push   $0xaf
  80248d:	68 b7 39 80 00       	push   $0x8039b7
  802492:	e8 9d 0a 00 00       	call   802f34 <_panic>
  802497:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80249a:	8b 00                	mov    (%eax),%eax
  80249c:	85 c0                	test   %eax,%eax
  80249e:	74 10                	je     8024b0 <alloc_block_BF+0x1a6>
  8024a0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024a3:	8b 00                	mov    (%eax),%eax
  8024a5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024a8:	8b 52 04             	mov    0x4(%edx),%edx
  8024ab:	89 50 04             	mov    %edx,0x4(%eax)
  8024ae:	eb 0b                	jmp    8024bb <alloc_block_BF+0x1b1>
  8024b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b3:	8b 40 04             	mov    0x4(%eax),%eax
  8024b6:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024be:	8b 40 04             	mov    0x4(%eax),%eax
  8024c1:	85 c0                	test   %eax,%eax
  8024c3:	74 0f                	je     8024d4 <alloc_block_BF+0x1ca>
  8024c5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024c8:	8b 40 04             	mov    0x4(%eax),%eax
  8024cb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024ce:	8b 12                	mov    (%edx),%edx
  8024d0:	89 10                	mov    %edx,(%eax)
  8024d2:	eb 0a                	jmp    8024de <alloc_block_BF+0x1d4>
  8024d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024d7:	8b 00                	mov    (%eax),%eax
  8024d9:	a3 48 41 80 00       	mov    %eax,0x804148
  8024de:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024e1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024ea:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f1:	a1 54 41 80 00       	mov    0x804154,%eax
  8024f6:	48                   	dec    %eax
  8024f7:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8024fc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024ff:	eb 05                	jmp    802506 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802501:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802506:	c9                   	leave  
  802507:	c3                   	ret    

00802508 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802508:	55                   	push   %ebp
  802509:	89 e5                	mov    %esp,%ebp
  80250b:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  80250e:	a1 38 41 80 00       	mov    0x804138,%eax
  802513:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802516:	e9 7c 01 00 00       	jmp    802697 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  80251b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251e:	8b 40 0c             	mov    0xc(%eax),%eax
  802521:	3b 45 08             	cmp    0x8(%ebp),%eax
  802524:	0f 86 cf 00 00 00    	jbe    8025f9 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80252a:	a1 48 41 80 00       	mov    0x804148,%eax
  80252f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802532:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802535:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802538:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253b:	8b 55 08             	mov    0x8(%ebp),%edx
  80253e:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802541:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802544:	8b 50 08             	mov    0x8(%eax),%edx
  802547:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80254a:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 40 0c             	mov    0xc(%eax),%eax
  802553:	2b 45 08             	sub    0x8(%ebp),%eax
  802556:	89 c2                	mov    %eax,%edx
  802558:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255b:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  80255e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802561:	8b 50 08             	mov    0x8(%eax),%edx
  802564:	8b 45 08             	mov    0x8(%ebp),%eax
  802567:	01 c2                	add    %eax,%edx
  802569:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256c:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80256f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802573:	75 17                	jne    80258c <alloc_block_NF+0x84>
  802575:	83 ec 04             	sub    $0x4,%esp
  802578:	68 29 3a 80 00       	push   $0x803a29
  80257d:	68 c4 00 00 00       	push   $0xc4
  802582:	68 b7 39 80 00       	push   $0x8039b7
  802587:	e8 a8 09 00 00       	call   802f34 <_panic>
  80258c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258f:	8b 00                	mov    (%eax),%eax
  802591:	85 c0                	test   %eax,%eax
  802593:	74 10                	je     8025a5 <alloc_block_NF+0x9d>
  802595:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802598:	8b 00                	mov    (%eax),%eax
  80259a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80259d:	8b 52 04             	mov    0x4(%edx),%edx
  8025a0:	89 50 04             	mov    %edx,0x4(%eax)
  8025a3:	eb 0b                	jmp    8025b0 <alloc_block_NF+0xa8>
  8025a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a8:	8b 40 04             	mov    0x4(%eax),%eax
  8025ab:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025b0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b3:	8b 40 04             	mov    0x4(%eax),%eax
  8025b6:	85 c0                	test   %eax,%eax
  8025b8:	74 0f                	je     8025c9 <alloc_block_NF+0xc1>
  8025ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bd:	8b 40 04             	mov    0x4(%eax),%eax
  8025c0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025c3:	8b 12                	mov    (%edx),%edx
  8025c5:	89 10                	mov    %edx,(%eax)
  8025c7:	eb 0a                	jmp    8025d3 <alloc_block_NF+0xcb>
  8025c9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025cc:	8b 00                	mov    (%eax),%eax
  8025ce:	a3 48 41 80 00       	mov    %eax,0x804148
  8025d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025dc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e6:	a1 54 41 80 00       	mov    0x804154,%eax
  8025eb:	48                   	dec    %eax
  8025ec:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8025f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f4:	e9 ad 00 00 00       	jmp    8026a6 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8025f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fc:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ff:	3b 45 08             	cmp    0x8(%ebp),%eax
  802602:	0f 85 87 00 00 00    	jne    80268f <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802608:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260c:	75 17                	jne    802625 <alloc_block_NF+0x11d>
  80260e:	83 ec 04             	sub    $0x4,%esp
  802611:	68 29 3a 80 00       	push   $0x803a29
  802616:	68 c8 00 00 00       	push   $0xc8
  80261b:	68 b7 39 80 00       	push   $0x8039b7
  802620:	e8 0f 09 00 00       	call   802f34 <_panic>
  802625:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802628:	8b 00                	mov    (%eax),%eax
  80262a:	85 c0                	test   %eax,%eax
  80262c:	74 10                	je     80263e <alloc_block_NF+0x136>
  80262e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802631:	8b 00                	mov    (%eax),%eax
  802633:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802636:	8b 52 04             	mov    0x4(%edx),%edx
  802639:	89 50 04             	mov    %edx,0x4(%eax)
  80263c:	eb 0b                	jmp    802649 <alloc_block_NF+0x141>
  80263e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802641:	8b 40 04             	mov    0x4(%eax),%eax
  802644:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802649:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264c:	8b 40 04             	mov    0x4(%eax),%eax
  80264f:	85 c0                	test   %eax,%eax
  802651:	74 0f                	je     802662 <alloc_block_NF+0x15a>
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	8b 40 04             	mov    0x4(%eax),%eax
  802659:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265c:	8b 12                	mov    (%edx),%edx
  80265e:	89 10                	mov    %edx,(%eax)
  802660:	eb 0a                	jmp    80266c <alloc_block_NF+0x164>
  802662:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802665:	8b 00                	mov    (%eax),%eax
  802667:	a3 38 41 80 00       	mov    %eax,0x804138
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802675:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802678:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267f:	a1 44 41 80 00       	mov    0x804144,%eax
  802684:	48                   	dec    %eax
  802685:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  80268a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268d:	eb 17                	jmp    8026a6 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  80268f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802692:	8b 00                	mov    (%eax),%eax
  802694:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802697:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269b:	0f 85 7a fe ff ff    	jne    80251b <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  8026a1:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8026a6:	c9                   	leave  
  8026a7:	c3                   	ret    

008026a8 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8026a8:	55                   	push   %ebp
  8026a9:	89 e5                	mov    %esp,%ebp
  8026ab:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  8026ae:	a1 38 41 80 00       	mov    0x804138,%eax
  8026b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8026b6:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8026bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8026be:	a1 44 41 80 00       	mov    0x804144,%eax
  8026c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8026c6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026ca:	75 68                	jne    802734 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8026cc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026d0:	75 17                	jne    8026e9 <insert_sorted_with_merge_freeList+0x41>
  8026d2:	83 ec 04             	sub    $0x4,%esp
  8026d5:	68 94 39 80 00       	push   $0x803994
  8026da:	68 da 00 00 00       	push   $0xda
  8026df:	68 b7 39 80 00       	push   $0x8039b7
  8026e4:	e8 4b 08 00 00       	call   802f34 <_panic>
  8026e9:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	89 10                	mov    %edx,(%eax)
  8026f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f7:	8b 00                	mov    (%eax),%eax
  8026f9:	85 c0                	test   %eax,%eax
  8026fb:	74 0d                	je     80270a <insert_sorted_with_merge_freeList+0x62>
  8026fd:	a1 38 41 80 00       	mov    0x804138,%eax
  802702:	8b 55 08             	mov    0x8(%ebp),%edx
  802705:	89 50 04             	mov    %edx,0x4(%eax)
  802708:	eb 08                	jmp    802712 <insert_sorted_with_merge_freeList+0x6a>
  80270a:	8b 45 08             	mov    0x8(%ebp),%eax
  80270d:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802712:	8b 45 08             	mov    0x8(%ebp),%eax
  802715:	a3 38 41 80 00       	mov    %eax,0x804138
  80271a:	8b 45 08             	mov    0x8(%ebp),%eax
  80271d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802724:	a1 44 41 80 00       	mov    0x804144,%eax
  802729:	40                   	inc    %eax
  80272a:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  80272f:	e9 49 07 00 00       	jmp    802e7d <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802734:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802737:	8b 50 08             	mov    0x8(%eax),%edx
  80273a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273d:	8b 40 0c             	mov    0xc(%eax),%eax
  802740:	01 c2                	add    %eax,%edx
  802742:	8b 45 08             	mov    0x8(%ebp),%eax
  802745:	8b 40 08             	mov    0x8(%eax),%eax
  802748:	39 c2                	cmp    %eax,%edx
  80274a:	73 77                	jae    8027c3 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  80274c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274f:	8b 00                	mov    (%eax),%eax
  802751:	85 c0                	test   %eax,%eax
  802753:	75 6e                	jne    8027c3 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802755:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802759:	74 68                	je     8027c3 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  80275b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80275f:	75 17                	jne    802778 <insert_sorted_with_merge_freeList+0xd0>
  802761:	83 ec 04             	sub    $0x4,%esp
  802764:	68 d0 39 80 00       	push   $0x8039d0
  802769:	68 e0 00 00 00       	push   $0xe0
  80276e:	68 b7 39 80 00       	push   $0x8039b7
  802773:	e8 bc 07 00 00       	call   802f34 <_panic>
  802778:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80277e:	8b 45 08             	mov    0x8(%ebp),%eax
  802781:	89 50 04             	mov    %edx,0x4(%eax)
  802784:	8b 45 08             	mov    0x8(%ebp),%eax
  802787:	8b 40 04             	mov    0x4(%eax),%eax
  80278a:	85 c0                	test   %eax,%eax
  80278c:	74 0c                	je     80279a <insert_sorted_with_merge_freeList+0xf2>
  80278e:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802793:	8b 55 08             	mov    0x8(%ebp),%edx
  802796:	89 10                	mov    %edx,(%eax)
  802798:	eb 08                	jmp    8027a2 <insert_sorted_with_merge_freeList+0xfa>
  80279a:	8b 45 08             	mov    0x8(%ebp),%eax
  80279d:	a3 38 41 80 00       	mov    %eax,0x804138
  8027a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ad:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b3:	a1 44 41 80 00       	mov    0x804144,%eax
  8027b8:	40                   	inc    %eax
  8027b9:	a3 44 41 80 00       	mov    %eax,0x804144
  8027be:	e9 ba 06 00 00       	jmp    802e7d <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8027c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c6:	8b 50 0c             	mov    0xc(%eax),%edx
  8027c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cc:	8b 40 08             	mov    0x8(%eax),%eax
  8027cf:	01 c2                	add    %eax,%edx
  8027d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d4:	8b 40 08             	mov    0x8(%eax),%eax
  8027d7:	39 c2                	cmp    %eax,%edx
  8027d9:	73 78                	jae    802853 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8027db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027de:	8b 40 04             	mov    0x4(%eax),%eax
  8027e1:	85 c0                	test   %eax,%eax
  8027e3:	75 6e                	jne    802853 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8027e5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027e9:	74 68                	je     802853 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8027eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027ef:	75 17                	jne    802808 <insert_sorted_with_merge_freeList+0x160>
  8027f1:	83 ec 04             	sub    $0x4,%esp
  8027f4:	68 94 39 80 00       	push   $0x803994
  8027f9:	68 e6 00 00 00       	push   $0xe6
  8027fe:	68 b7 39 80 00       	push   $0x8039b7
  802803:	e8 2c 07 00 00       	call   802f34 <_panic>
  802808:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80280e:	8b 45 08             	mov    0x8(%ebp),%eax
  802811:	89 10                	mov    %edx,(%eax)
  802813:	8b 45 08             	mov    0x8(%ebp),%eax
  802816:	8b 00                	mov    (%eax),%eax
  802818:	85 c0                	test   %eax,%eax
  80281a:	74 0d                	je     802829 <insert_sorted_with_merge_freeList+0x181>
  80281c:	a1 38 41 80 00       	mov    0x804138,%eax
  802821:	8b 55 08             	mov    0x8(%ebp),%edx
  802824:	89 50 04             	mov    %edx,0x4(%eax)
  802827:	eb 08                	jmp    802831 <insert_sorted_with_merge_freeList+0x189>
  802829:	8b 45 08             	mov    0x8(%ebp),%eax
  80282c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802831:	8b 45 08             	mov    0x8(%ebp),%eax
  802834:	a3 38 41 80 00       	mov    %eax,0x804138
  802839:	8b 45 08             	mov    0x8(%ebp),%eax
  80283c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802843:	a1 44 41 80 00       	mov    0x804144,%eax
  802848:	40                   	inc    %eax
  802849:	a3 44 41 80 00       	mov    %eax,0x804144
  80284e:	e9 2a 06 00 00       	jmp    802e7d <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802853:	a1 38 41 80 00       	mov    0x804138,%eax
  802858:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285b:	e9 ed 05 00 00       	jmp    802e4d <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802860:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802863:	8b 00                	mov    (%eax),%eax
  802865:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802868:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80286c:	0f 84 a7 00 00 00    	je     802919 <insert_sorted_with_merge_freeList+0x271>
  802872:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802875:	8b 50 0c             	mov    0xc(%eax),%edx
  802878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287b:	8b 40 08             	mov    0x8(%eax),%eax
  80287e:	01 c2                	add    %eax,%edx
  802880:	8b 45 08             	mov    0x8(%ebp),%eax
  802883:	8b 40 08             	mov    0x8(%eax),%eax
  802886:	39 c2                	cmp    %eax,%edx
  802888:	0f 83 8b 00 00 00    	jae    802919 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  80288e:	8b 45 08             	mov    0x8(%ebp),%eax
  802891:	8b 50 0c             	mov    0xc(%eax),%edx
  802894:	8b 45 08             	mov    0x8(%ebp),%eax
  802897:	8b 40 08             	mov    0x8(%eax),%eax
  80289a:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  80289c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80289f:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  8028a2:	39 c2                	cmp    %eax,%edx
  8028a4:	73 73                	jae    802919 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  8028a6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028aa:	74 06                	je     8028b2 <insert_sorted_with_merge_freeList+0x20a>
  8028ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028b0:	75 17                	jne    8028c9 <insert_sorted_with_merge_freeList+0x221>
  8028b2:	83 ec 04             	sub    $0x4,%esp
  8028b5:	68 48 3a 80 00       	push   $0x803a48
  8028ba:	68 f0 00 00 00       	push   $0xf0
  8028bf:	68 b7 39 80 00       	push   $0x8039b7
  8028c4:	e8 6b 06 00 00       	call   802f34 <_panic>
  8028c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cc:	8b 10                	mov    (%eax),%edx
  8028ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d1:	89 10                	mov    %edx,(%eax)
  8028d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d6:	8b 00                	mov    (%eax),%eax
  8028d8:	85 c0                	test   %eax,%eax
  8028da:	74 0b                	je     8028e7 <insert_sorted_with_merge_freeList+0x23f>
  8028dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028df:	8b 00                	mov    (%eax),%eax
  8028e1:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e4:	89 50 04             	mov    %edx,0x4(%eax)
  8028e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ea:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ed:	89 10                	mov    %edx,(%eax)
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f5:	89 50 04             	mov    %edx,0x4(%eax)
  8028f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fb:	8b 00                	mov    (%eax),%eax
  8028fd:	85 c0                	test   %eax,%eax
  8028ff:	75 08                	jne    802909 <insert_sorted_with_merge_freeList+0x261>
  802901:	8b 45 08             	mov    0x8(%ebp),%eax
  802904:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802909:	a1 44 41 80 00       	mov    0x804144,%eax
  80290e:	40                   	inc    %eax
  80290f:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802914:	e9 64 05 00 00       	jmp    802e7d <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802919:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80291e:	8b 50 0c             	mov    0xc(%eax),%edx
  802921:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802926:	8b 40 08             	mov    0x8(%eax),%eax
  802929:	01 c2                	add    %eax,%edx
  80292b:	8b 45 08             	mov    0x8(%ebp),%eax
  80292e:	8b 40 08             	mov    0x8(%eax),%eax
  802931:	39 c2                	cmp    %eax,%edx
  802933:	0f 85 b1 00 00 00    	jne    8029ea <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802939:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80293e:	85 c0                	test   %eax,%eax
  802940:	0f 84 a4 00 00 00    	je     8029ea <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802946:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80294b:	8b 00                	mov    (%eax),%eax
  80294d:	85 c0                	test   %eax,%eax
  80294f:	0f 85 95 00 00 00    	jne    8029ea <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802955:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80295a:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802960:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802963:	8b 55 08             	mov    0x8(%ebp),%edx
  802966:	8b 52 0c             	mov    0xc(%edx),%edx
  802969:	01 ca                	add    %ecx,%edx
  80296b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  80296e:	8b 45 08             	mov    0x8(%ebp),%eax
  802971:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802978:	8b 45 08             	mov    0x8(%ebp),%eax
  80297b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802982:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802986:	75 17                	jne    80299f <insert_sorted_with_merge_freeList+0x2f7>
  802988:	83 ec 04             	sub    $0x4,%esp
  80298b:	68 94 39 80 00       	push   $0x803994
  802990:	68 ff 00 00 00       	push   $0xff
  802995:	68 b7 39 80 00       	push   $0x8039b7
  80299a:	e8 95 05 00 00       	call   802f34 <_panic>
  80299f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a8:	89 10                	mov    %edx,(%eax)
  8029aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ad:	8b 00                	mov    (%eax),%eax
  8029af:	85 c0                	test   %eax,%eax
  8029b1:	74 0d                	je     8029c0 <insert_sorted_with_merge_freeList+0x318>
  8029b3:	a1 48 41 80 00       	mov    0x804148,%eax
  8029b8:	8b 55 08             	mov    0x8(%ebp),%edx
  8029bb:	89 50 04             	mov    %edx,0x4(%eax)
  8029be:	eb 08                	jmp    8029c8 <insert_sorted_with_merge_freeList+0x320>
  8029c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029cb:	a3 48 41 80 00       	mov    %eax,0x804148
  8029d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029da:	a1 54 41 80 00       	mov    0x804154,%eax
  8029df:	40                   	inc    %eax
  8029e0:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  8029e5:	e9 93 04 00 00       	jmp    802e7d <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  8029ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ed:	8b 50 08             	mov    0x8(%eax),%edx
  8029f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f3:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f6:	01 c2                	add    %eax,%edx
  8029f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fb:	8b 40 08             	mov    0x8(%eax),%eax
  8029fe:	39 c2                	cmp    %eax,%edx
  802a00:	0f 85 ae 00 00 00    	jne    802ab4 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802a06:	8b 45 08             	mov    0x8(%ebp),%eax
  802a09:	8b 50 0c             	mov    0xc(%eax),%edx
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	8b 40 08             	mov    0x8(%eax),%eax
  802a12:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802a14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a17:	8b 00                	mov    (%eax),%eax
  802a19:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802a1c:	39 c2                	cmp    %eax,%edx
  802a1e:	0f 84 90 00 00 00    	je     802ab4 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 50 0c             	mov    0xc(%eax),%edx
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	8b 40 0c             	mov    0xc(%eax),%eax
  802a30:	01 c2                	add    %eax,%edx
  802a32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a35:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802a38:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802a42:	8b 45 08             	mov    0x8(%ebp),%eax
  802a45:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802a4c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a50:	75 17                	jne    802a69 <insert_sorted_with_merge_freeList+0x3c1>
  802a52:	83 ec 04             	sub    $0x4,%esp
  802a55:	68 94 39 80 00       	push   $0x803994
  802a5a:	68 0b 01 00 00       	push   $0x10b
  802a5f:	68 b7 39 80 00       	push   $0x8039b7
  802a64:	e8 cb 04 00 00       	call   802f34 <_panic>
  802a69:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  802a72:	89 10                	mov    %edx,(%eax)
  802a74:	8b 45 08             	mov    0x8(%ebp),%eax
  802a77:	8b 00                	mov    (%eax),%eax
  802a79:	85 c0                	test   %eax,%eax
  802a7b:	74 0d                	je     802a8a <insert_sorted_with_merge_freeList+0x3e2>
  802a7d:	a1 48 41 80 00       	mov    0x804148,%eax
  802a82:	8b 55 08             	mov    0x8(%ebp),%edx
  802a85:	89 50 04             	mov    %edx,0x4(%eax)
  802a88:	eb 08                	jmp    802a92 <insert_sorted_with_merge_freeList+0x3ea>
  802a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a92:	8b 45 08             	mov    0x8(%ebp),%eax
  802a95:	a3 48 41 80 00       	mov    %eax,0x804148
  802a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa4:	a1 54 41 80 00       	mov    0x804154,%eax
  802aa9:	40                   	inc    %eax
  802aaa:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802aaf:	e9 c9 03 00 00       	jmp    802e7d <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802ab4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab7:	8b 50 0c             	mov    0xc(%eax),%edx
  802aba:	8b 45 08             	mov    0x8(%ebp),%eax
  802abd:	8b 40 08             	mov    0x8(%eax),%eax
  802ac0:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802ac2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac5:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802ac8:	39 c2                	cmp    %eax,%edx
  802aca:	0f 85 bb 00 00 00    	jne    802b8b <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802ad0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad4:	0f 84 b1 00 00 00    	je     802b8b <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802ada:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802add:	8b 40 04             	mov    0x4(%eax),%eax
  802ae0:	85 c0                	test   %eax,%eax
  802ae2:	0f 85 a3 00 00 00    	jne    802b8b <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ae8:	a1 38 41 80 00       	mov    0x804138,%eax
  802aed:	8b 55 08             	mov    0x8(%ebp),%edx
  802af0:	8b 52 08             	mov    0x8(%edx),%edx
  802af3:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802af6:	a1 38 41 80 00       	mov    0x804138,%eax
  802afb:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b01:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b04:	8b 55 08             	mov    0x8(%ebp),%edx
  802b07:	8b 52 0c             	mov    0xc(%edx),%edx
  802b0a:	01 ca                	add    %ecx,%edx
  802b0c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802b0f:	8b 45 08             	mov    0x8(%ebp),%eax
  802b12:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802b23:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b27:	75 17                	jne    802b40 <insert_sorted_with_merge_freeList+0x498>
  802b29:	83 ec 04             	sub    $0x4,%esp
  802b2c:	68 94 39 80 00       	push   $0x803994
  802b31:	68 17 01 00 00       	push   $0x117
  802b36:	68 b7 39 80 00       	push   $0x8039b7
  802b3b:	e8 f4 03 00 00       	call   802f34 <_panic>
  802b40:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b46:	8b 45 08             	mov    0x8(%ebp),%eax
  802b49:	89 10                	mov    %edx,(%eax)
  802b4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4e:	8b 00                	mov    (%eax),%eax
  802b50:	85 c0                	test   %eax,%eax
  802b52:	74 0d                	je     802b61 <insert_sorted_with_merge_freeList+0x4b9>
  802b54:	a1 48 41 80 00       	mov    0x804148,%eax
  802b59:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5c:	89 50 04             	mov    %edx,0x4(%eax)
  802b5f:	eb 08                	jmp    802b69 <insert_sorted_with_merge_freeList+0x4c1>
  802b61:	8b 45 08             	mov    0x8(%ebp),%eax
  802b64:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b69:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6c:	a3 48 41 80 00       	mov    %eax,0x804148
  802b71:	8b 45 08             	mov    0x8(%ebp),%eax
  802b74:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7b:	a1 54 41 80 00       	mov    0x804154,%eax
  802b80:	40                   	inc    %eax
  802b81:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802b86:	e9 f2 02 00 00       	jmp    802e7d <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802b8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8e:	8b 50 08             	mov    0x8(%eax),%edx
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	8b 40 0c             	mov    0xc(%eax),%eax
  802b97:	01 c2                	add    %eax,%edx
  802b99:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9c:	8b 40 08             	mov    0x8(%eax),%eax
  802b9f:	39 c2                	cmp    %eax,%edx
  802ba1:	0f 85 be 00 00 00    	jne    802c65 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802ba7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802baa:	8b 40 04             	mov    0x4(%eax),%eax
  802bad:	8b 50 08             	mov    0x8(%eax),%edx
  802bb0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb3:	8b 40 04             	mov    0x4(%eax),%eax
  802bb6:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb9:	01 c2                	add    %eax,%edx
  802bbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbe:	8b 40 08             	mov    0x8(%eax),%eax
  802bc1:	39 c2                	cmp    %eax,%edx
  802bc3:	0f 84 9c 00 00 00    	je     802c65 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802bc9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcc:	8b 50 08             	mov    0x8(%eax),%edx
  802bcf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd2:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802bd5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd8:	8b 50 0c             	mov    0xc(%eax),%edx
  802bdb:	8b 45 08             	mov    0x8(%ebp),%eax
  802bde:	8b 40 0c             	mov    0xc(%eax),%eax
  802be1:	01 c2                	add    %eax,%edx
  802be3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be6:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802be9:	8b 45 08             	mov    0x8(%ebp),%eax
  802bec:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802bf3:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802bfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c01:	75 17                	jne    802c1a <insert_sorted_with_merge_freeList+0x572>
  802c03:	83 ec 04             	sub    $0x4,%esp
  802c06:	68 94 39 80 00       	push   $0x803994
  802c0b:	68 26 01 00 00       	push   $0x126
  802c10:	68 b7 39 80 00       	push   $0x8039b7
  802c15:	e8 1a 03 00 00       	call   802f34 <_panic>
  802c1a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c20:	8b 45 08             	mov    0x8(%ebp),%eax
  802c23:	89 10                	mov    %edx,(%eax)
  802c25:	8b 45 08             	mov    0x8(%ebp),%eax
  802c28:	8b 00                	mov    (%eax),%eax
  802c2a:	85 c0                	test   %eax,%eax
  802c2c:	74 0d                	je     802c3b <insert_sorted_with_merge_freeList+0x593>
  802c2e:	a1 48 41 80 00       	mov    0x804148,%eax
  802c33:	8b 55 08             	mov    0x8(%ebp),%edx
  802c36:	89 50 04             	mov    %edx,0x4(%eax)
  802c39:	eb 08                	jmp    802c43 <insert_sorted_with_merge_freeList+0x59b>
  802c3b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3e:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c43:	8b 45 08             	mov    0x8(%ebp),%eax
  802c46:	a3 48 41 80 00       	mov    %eax,0x804148
  802c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c55:	a1 54 41 80 00       	mov    0x804154,%eax
  802c5a:	40                   	inc    %eax
  802c5b:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802c60:	e9 18 02 00 00       	jmp    802e7d <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802c65:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c68:	8b 50 0c             	mov    0xc(%eax),%edx
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 40 08             	mov    0x8(%eax),%eax
  802c71:	01 c2                	add    %eax,%edx
  802c73:	8b 45 08             	mov    0x8(%ebp),%eax
  802c76:	8b 40 08             	mov    0x8(%eax),%eax
  802c79:	39 c2                	cmp    %eax,%edx
  802c7b:	0f 85 c4 01 00 00    	jne    802e45 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802c81:	8b 45 08             	mov    0x8(%ebp),%eax
  802c84:	8b 50 0c             	mov    0xc(%eax),%edx
  802c87:	8b 45 08             	mov    0x8(%ebp),%eax
  802c8a:	8b 40 08             	mov    0x8(%eax),%eax
  802c8d:	01 c2                	add    %eax,%edx
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	8b 00                	mov    (%eax),%eax
  802c94:	8b 40 08             	mov    0x8(%eax),%eax
  802c97:	39 c2                	cmp    %eax,%edx
  802c99:	0f 85 a6 01 00 00    	jne    802e45 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802c9f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca3:	0f 84 9c 01 00 00    	je     802e45 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 50 0c             	mov    0xc(%eax),%edx
  802caf:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb2:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb5:	01 c2                	add    %eax,%edx
  802cb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cba:	8b 00                	mov    (%eax),%eax
  802cbc:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbf:	01 c2                	add    %eax,%edx
  802cc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc4:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802cc7:	8b 45 08             	mov    0x8(%ebp),%eax
  802cca:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802cd1:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802cdb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cdf:	75 17                	jne    802cf8 <insert_sorted_with_merge_freeList+0x650>
  802ce1:	83 ec 04             	sub    $0x4,%esp
  802ce4:	68 94 39 80 00       	push   $0x803994
  802ce9:	68 32 01 00 00       	push   $0x132
  802cee:	68 b7 39 80 00       	push   $0x8039b7
  802cf3:	e8 3c 02 00 00       	call   802f34 <_panic>
  802cf8:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  802d01:	89 10                	mov    %edx,(%eax)
  802d03:	8b 45 08             	mov    0x8(%ebp),%eax
  802d06:	8b 00                	mov    (%eax),%eax
  802d08:	85 c0                	test   %eax,%eax
  802d0a:	74 0d                	je     802d19 <insert_sorted_with_merge_freeList+0x671>
  802d0c:	a1 48 41 80 00       	mov    0x804148,%eax
  802d11:	8b 55 08             	mov    0x8(%ebp),%edx
  802d14:	89 50 04             	mov    %edx,0x4(%eax)
  802d17:	eb 08                	jmp    802d21 <insert_sorted_with_merge_freeList+0x679>
  802d19:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d21:	8b 45 08             	mov    0x8(%ebp),%eax
  802d24:	a3 48 41 80 00       	mov    %eax,0x804148
  802d29:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d33:	a1 54 41 80 00       	mov    0x804154,%eax
  802d38:	40                   	inc    %eax
  802d39:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802d3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d41:	8b 00                	mov    (%eax),%eax
  802d43:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802d4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802d56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d59:	8b 00                	mov    (%eax),%eax
  802d5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802d5e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d62:	75 17                	jne    802d7b <insert_sorted_with_merge_freeList+0x6d3>
  802d64:	83 ec 04             	sub    $0x4,%esp
  802d67:	68 29 3a 80 00       	push   $0x803a29
  802d6c:	68 36 01 00 00       	push   $0x136
  802d71:	68 b7 39 80 00       	push   $0x8039b7
  802d76:	e8 b9 01 00 00       	call   802f34 <_panic>
  802d7b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7e:	8b 00                	mov    (%eax),%eax
  802d80:	85 c0                	test   %eax,%eax
  802d82:	74 10                	je     802d94 <insert_sorted_with_merge_freeList+0x6ec>
  802d84:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d87:	8b 00                	mov    (%eax),%eax
  802d89:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d8c:	8b 52 04             	mov    0x4(%edx),%edx
  802d8f:	89 50 04             	mov    %edx,0x4(%eax)
  802d92:	eb 0b                	jmp    802d9f <insert_sorted_with_merge_freeList+0x6f7>
  802d94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d97:	8b 40 04             	mov    0x4(%eax),%eax
  802d9a:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d9f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da2:	8b 40 04             	mov    0x4(%eax),%eax
  802da5:	85 c0                	test   %eax,%eax
  802da7:	74 0f                	je     802db8 <insert_sorted_with_merge_freeList+0x710>
  802da9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dac:	8b 40 04             	mov    0x4(%eax),%eax
  802daf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802db2:	8b 12                	mov    (%edx),%edx
  802db4:	89 10                	mov    %edx,(%eax)
  802db6:	eb 0a                	jmp    802dc2 <insert_sorted_with_merge_freeList+0x71a>
  802db8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dbb:	8b 00                	mov    (%eax),%eax
  802dbd:	a3 38 41 80 00       	mov    %eax,0x804138
  802dc2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dcb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd5:	a1 44 41 80 00       	mov    0x804144,%eax
  802dda:	48                   	dec    %eax
  802ddb:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  802de0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802de4:	75 17                	jne    802dfd <insert_sorted_with_merge_freeList+0x755>
  802de6:	83 ec 04             	sub    $0x4,%esp
  802de9:	68 94 39 80 00       	push   $0x803994
  802dee:	68 37 01 00 00       	push   $0x137
  802df3:	68 b7 39 80 00       	push   $0x8039b7
  802df8:	e8 37 01 00 00       	call   802f34 <_panic>
  802dfd:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e06:	89 10                	mov    %edx,(%eax)
  802e08:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e0b:	8b 00                	mov    (%eax),%eax
  802e0d:	85 c0                	test   %eax,%eax
  802e0f:	74 0d                	je     802e1e <insert_sorted_with_merge_freeList+0x776>
  802e11:	a1 48 41 80 00       	mov    0x804148,%eax
  802e16:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e19:	89 50 04             	mov    %edx,0x4(%eax)
  802e1c:	eb 08                	jmp    802e26 <insert_sorted_with_merge_freeList+0x77e>
  802e1e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e21:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e29:	a3 48 41 80 00       	mov    %eax,0x804148
  802e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e31:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e38:	a1 54 41 80 00       	mov    0x804154,%eax
  802e3d:	40                   	inc    %eax
  802e3e:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  802e43:	eb 38                	jmp    802e7d <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802e45:	a1 40 41 80 00       	mov    0x804140,%eax
  802e4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e51:	74 07                	je     802e5a <insert_sorted_with_merge_freeList+0x7b2>
  802e53:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e56:	8b 00                	mov    (%eax),%eax
  802e58:	eb 05                	jmp    802e5f <insert_sorted_with_merge_freeList+0x7b7>
  802e5a:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5f:	a3 40 41 80 00       	mov    %eax,0x804140
  802e64:	a1 40 41 80 00       	mov    0x804140,%eax
  802e69:	85 c0                	test   %eax,%eax
  802e6b:	0f 85 ef f9 ff ff    	jne    802860 <insert_sorted_with_merge_freeList+0x1b8>
  802e71:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e75:	0f 85 e5 f9 ff ff    	jne    802860 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  802e7b:	eb 00                	jmp    802e7d <insert_sorted_with_merge_freeList+0x7d5>
  802e7d:	90                   	nop
  802e7e:	c9                   	leave  
  802e7f:	c3                   	ret    

00802e80 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802e80:	55                   	push   %ebp
  802e81:	89 e5                	mov    %esp,%ebp
  802e83:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802e86:	8b 55 08             	mov    0x8(%ebp),%edx
  802e89:	89 d0                	mov    %edx,%eax
  802e8b:	c1 e0 02             	shl    $0x2,%eax
  802e8e:	01 d0                	add    %edx,%eax
  802e90:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e97:	01 d0                	add    %edx,%eax
  802e99:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ea0:	01 d0                	add    %edx,%eax
  802ea2:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ea9:	01 d0                	add    %edx,%eax
  802eab:	c1 e0 04             	shl    $0x4,%eax
  802eae:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802eb1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802eb8:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802ebb:	83 ec 0c             	sub    $0xc,%esp
  802ebe:	50                   	push   %eax
  802ebf:	e8 21 ec ff ff       	call   801ae5 <sys_get_virtual_time>
  802ec4:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802ec7:	eb 41                	jmp    802f0a <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802ec9:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802ecc:	83 ec 0c             	sub    $0xc,%esp
  802ecf:	50                   	push   %eax
  802ed0:	e8 10 ec ff ff       	call   801ae5 <sys_get_virtual_time>
  802ed5:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802ed8:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802edb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ede:	29 c2                	sub    %eax,%edx
  802ee0:	89 d0                	mov    %edx,%eax
  802ee2:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802ee5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ee8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eeb:	89 d1                	mov    %edx,%ecx
  802eed:	29 c1                	sub    %eax,%ecx
  802eef:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ef2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef5:	39 c2                	cmp    %eax,%edx
  802ef7:	0f 97 c0             	seta   %al
  802efa:	0f b6 c0             	movzbl %al,%eax
  802efd:	29 c1                	sub    %eax,%ecx
  802eff:	89 c8                	mov    %ecx,%eax
  802f01:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802f04:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f07:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802f0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f10:	72 b7                	jb     802ec9 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802f12:	90                   	nop
  802f13:	c9                   	leave  
  802f14:	c3                   	ret    

00802f15 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802f15:	55                   	push   %ebp
  802f16:	89 e5                	mov    %esp,%ebp
  802f18:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802f1b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802f22:	eb 03                	jmp    802f27 <busy_wait+0x12>
  802f24:	ff 45 fc             	incl   -0x4(%ebp)
  802f27:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f2a:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f2d:	72 f5                	jb     802f24 <busy_wait+0xf>
	return i;
  802f2f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802f32:	c9                   	leave  
  802f33:	c3                   	ret    

00802f34 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802f34:	55                   	push   %ebp
  802f35:	89 e5                	mov    %esp,%ebp
  802f37:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802f3a:	8d 45 10             	lea    0x10(%ebp),%eax
  802f3d:	83 c0 04             	add    $0x4,%eax
  802f40:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802f43:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802f48:	85 c0                	test   %eax,%eax
  802f4a:	74 16                	je     802f62 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802f4c:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802f51:	83 ec 08             	sub    $0x8,%esp
  802f54:	50                   	push   %eax
  802f55:	68 7c 3a 80 00       	push   $0x803a7c
  802f5a:	e8 1d d4 ff ff       	call   80037c <cprintf>
  802f5f:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802f62:	a1 00 40 80 00       	mov    0x804000,%eax
  802f67:	ff 75 0c             	pushl  0xc(%ebp)
  802f6a:	ff 75 08             	pushl  0x8(%ebp)
  802f6d:	50                   	push   %eax
  802f6e:	68 81 3a 80 00       	push   $0x803a81
  802f73:	e8 04 d4 ff ff       	call   80037c <cprintf>
  802f78:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802f7b:	8b 45 10             	mov    0x10(%ebp),%eax
  802f7e:	83 ec 08             	sub    $0x8,%esp
  802f81:	ff 75 f4             	pushl  -0xc(%ebp)
  802f84:	50                   	push   %eax
  802f85:	e8 87 d3 ff ff       	call   800311 <vcprintf>
  802f8a:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802f8d:	83 ec 08             	sub    $0x8,%esp
  802f90:	6a 00                	push   $0x0
  802f92:	68 9d 3a 80 00       	push   $0x803a9d
  802f97:	e8 75 d3 ff ff       	call   800311 <vcprintf>
  802f9c:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802f9f:	e8 f6 d2 ff ff       	call   80029a <exit>

	// should not return here
	while (1) ;
  802fa4:	eb fe                	jmp    802fa4 <_panic+0x70>

00802fa6 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802fa6:	55                   	push   %ebp
  802fa7:	89 e5                	mov    %esp,%ebp
  802fa9:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802fac:	a1 20 40 80 00       	mov    0x804020,%eax
  802fb1:	8b 50 74             	mov    0x74(%eax),%edx
  802fb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb7:	39 c2                	cmp    %eax,%edx
  802fb9:	74 14                	je     802fcf <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802fbb:	83 ec 04             	sub    $0x4,%esp
  802fbe:	68 a0 3a 80 00       	push   $0x803aa0
  802fc3:	6a 26                	push   $0x26
  802fc5:	68 ec 3a 80 00       	push   $0x803aec
  802fca:	e8 65 ff ff ff       	call   802f34 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802fcf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802fd6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802fdd:	e9 c2 00 00 00       	jmp    8030a4 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802fe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802fec:	8b 45 08             	mov    0x8(%ebp),%eax
  802fef:	01 d0                	add    %edx,%eax
  802ff1:	8b 00                	mov    (%eax),%eax
  802ff3:	85 c0                	test   %eax,%eax
  802ff5:	75 08                	jne    802fff <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802ff7:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802ffa:	e9 a2 00 00 00       	jmp    8030a1 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802fff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803006:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80300d:	eb 69                	jmp    803078 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80300f:	a1 20 40 80 00       	mov    0x804020,%eax
  803014:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80301a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80301d:	89 d0                	mov    %edx,%eax
  80301f:	01 c0                	add    %eax,%eax
  803021:	01 d0                	add    %edx,%eax
  803023:	c1 e0 03             	shl    $0x3,%eax
  803026:	01 c8                	add    %ecx,%eax
  803028:	8a 40 04             	mov    0x4(%eax),%al
  80302b:	84 c0                	test   %al,%al
  80302d:	75 46                	jne    803075 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80302f:	a1 20 40 80 00       	mov    0x804020,%eax
  803034:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80303a:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80303d:	89 d0                	mov    %edx,%eax
  80303f:	01 c0                	add    %eax,%eax
  803041:	01 d0                	add    %edx,%eax
  803043:	c1 e0 03             	shl    $0x3,%eax
  803046:	01 c8                	add    %ecx,%eax
  803048:	8b 00                	mov    (%eax),%eax
  80304a:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80304d:	8b 45 dc             	mov    -0x24(%ebp),%eax
  803050:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803055:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803057:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80305a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803061:	8b 45 08             	mov    0x8(%ebp),%eax
  803064:	01 c8                	add    %ecx,%eax
  803066:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803068:	39 c2                	cmp    %eax,%edx
  80306a:	75 09                	jne    803075 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80306c:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803073:	eb 12                	jmp    803087 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803075:	ff 45 e8             	incl   -0x18(%ebp)
  803078:	a1 20 40 80 00       	mov    0x804020,%eax
  80307d:	8b 50 74             	mov    0x74(%eax),%edx
  803080:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803083:	39 c2                	cmp    %eax,%edx
  803085:	77 88                	ja     80300f <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803087:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80308b:	75 14                	jne    8030a1 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80308d:	83 ec 04             	sub    $0x4,%esp
  803090:	68 f8 3a 80 00       	push   $0x803af8
  803095:	6a 3a                	push   $0x3a
  803097:	68 ec 3a 80 00       	push   $0x803aec
  80309c:	e8 93 fe ff ff       	call   802f34 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8030a1:	ff 45 f0             	incl   -0x10(%ebp)
  8030a4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030aa:	0f 8c 32 ff ff ff    	jl     802fe2 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8030b0:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030b7:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8030be:	eb 26                	jmp    8030e6 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8030c0:	a1 20 40 80 00       	mov    0x804020,%eax
  8030c5:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8030cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030ce:	89 d0                	mov    %edx,%eax
  8030d0:	01 c0                	add    %eax,%eax
  8030d2:	01 d0                	add    %edx,%eax
  8030d4:	c1 e0 03             	shl    $0x3,%eax
  8030d7:	01 c8                	add    %ecx,%eax
  8030d9:	8a 40 04             	mov    0x4(%eax),%al
  8030dc:	3c 01                	cmp    $0x1,%al
  8030de:	75 03                	jne    8030e3 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8030e0:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030e3:	ff 45 e0             	incl   -0x20(%ebp)
  8030e6:	a1 20 40 80 00       	mov    0x804020,%eax
  8030eb:	8b 50 74             	mov    0x74(%eax),%edx
  8030ee:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f1:	39 c2                	cmp    %eax,%edx
  8030f3:	77 cb                	ja     8030c0 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8030f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f8:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030fb:	74 14                	je     803111 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8030fd:	83 ec 04             	sub    $0x4,%esp
  803100:	68 4c 3b 80 00       	push   $0x803b4c
  803105:	6a 44                	push   $0x44
  803107:	68 ec 3a 80 00       	push   $0x803aec
  80310c:	e8 23 fe ff ff       	call   802f34 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803111:	90                   	nop
  803112:	c9                   	leave  
  803113:	c3                   	ret    

00803114 <__udivdi3>:
  803114:	55                   	push   %ebp
  803115:	57                   	push   %edi
  803116:	56                   	push   %esi
  803117:	53                   	push   %ebx
  803118:	83 ec 1c             	sub    $0x1c,%esp
  80311b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80311f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803123:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803127:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80312b:	89 ca                	mov    %ecx,%edx
  80312d:	89 f8                	mov    %edi,%eax
  80312f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803133:	85 f6                	test   %esi,%esi
  803135:	75 2d                	jne    803164 <__udivdi3+0x50>
  803137:	39 cf                	cmp    %ecx,%edi
  803139:	77 65                	ja     8031a0 <__udivdi3+0x8c>
  80313b:	89 fd                	mov    %edi,%ebp
  80313d:	85 ff                	test   %edi,%edi
  80313f:	75 0b                	jne    80314c <__udivdi3+0x38>
  803141:	b8 01 00 00 00       	mov    $0x1,%eax
  803146:	31 d2                	xor    %edx,%edx
  803148:	f7 f7                	div    %edi
  80314a:	89 c5                	mov    %eax,%ebp
  80314c:	31 d2                	xor    %edx,%edx
  80314e:	89 c8                	mov    %ecx,%eax
  803150:	f7 f5                	div    %ebp
  803152:	89 c1                	mov    %eax,%ecx
  803154:	89 d8                	mov    %ebx,%eax
  803156:	f7 f5                	div    %ebp
  803158:	89 cf                	mov    %ecx,%edi
  80315a:	89 fa                	mov    %edi,%edx
  80315c:	83 c4 1c             	add    $0x1c,%esp
  80315f:	5b                   	pop    %ebx
  803160:	5e                   	pop    %esi
  803161:	5f                   	pop    %edi
  803162:	5d                   	pop    %ebp
  803163:	c3                   	ret    
  803164:	39 ce                	cmp    %ecx,%esi
  803166:	77 28                	ja     803190 <__udivdi3+0x7c>
  803168:	0f bd fe             	bsr    %esi,%edi
  80316b:	83 f7 1f             	xor    $0x1f,%edi
  80316e:	75 40                	jne    8031b0 <__udivdi3+0x9c>
  803170:	39 ce                	cmp    %ecx,%esi
  803172:	72 0a                	jb     80317e <__udivdi3+0x6a>
  803174:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803178:	0f 87 9e 00 00 00    	ja     80321c <__udivdi3+0x108>
  80317e:	b8 01 00 00 00       	mov    $0x1,%eax
  803183:	89 fa                	mov    %edi,%edx
  803185:	83 c4 1c             	add    $0x1c,%esp
  803188:	5b                   	pop    %ebx
  803189:	5e                   	pop    %esi
  80318a:	5f                   	pop    %edi
  80318b:	5d                   	pop    %ebp
  80318c:	c3                   	ret    
  80318d:	8d 76 00             	lea    0x0(%esi),%esi
  803190:	31 ff                	xor    %edi,%edi
  803192:	31 c0                	xor    %eax,%eax
  803194:	89 fa                	mov    %edi,%edx
  803196:	83 c4 1c             	add    $0x1c,%esp
  803199:	5b                   	pop    %ebx
  80319a:	5e                   	pop    %esi
  80319b:	5f                   	pop    %edi
  80319c:	5d                   	pop    %ebp
  80319d:	c3                   	ret    
  80319e:	66 90                	xchg   %ax,%ax
  8031a0:	89 d8                	mov    %ebx,%eax
  8031a2:	f7 f7                	div    %edi
  8031a4:	31 ff                	xor    %edi,%edi
  8031a6:	89 fa                	mov    %edi,%edx
  8031a8:	83 c4 1c             	add    $0x1c,%esp
  8031ab:	5b                   	pop    %ebx
  8031ac:	5e                   	pop    %esi
  8031ad:	5f                   	pop    %edi
  8031ae:	5d                   	pop    %ebp
  8031af:	c3                   	ret    
  8031b0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031b5:	89 eb                	mov    %ebp,%ebx
  8031b7:	29 fb                	sub    %edi,%ebx
  8031b9:	89 f9                	mov    %edi,%ecx
  8031bb:	d3 e6                	shl    %cl,%esi
  8031bd:	89 c5                	mov    %eax,%ebp
  8031bf:	88 d9                	mov    %bl,%cl
  8031c1:	d3 ed                	shr    %cl,%ebp
  8031c3:	89 e9                	mov    %ebp,%ecx
  8031c5:	09 f1                	or     %esi,%ecx
  8031c7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031cb:	89 f9                	mov    %edi,%ecx
  8031cd:	d3 e0                	shl    %cl,%eax
  8031cf:	89 c5                	mov    %eax,%ebp
  8031d1:	89 d6                	mov    %edx,%esi
  8031d3:	88 d9                	mov    %bl,%cl
  8031d5:	d3 ee                	shr    %cl,%esi
  8031d7:	89 f9                	mov    %edi,%ecx
  8031d9:	d3 e2                	shl    %cl,%edx
  8031db:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031df:	88 d9                	mov    %bl,%cl
  8031e1:	d3 e8                	shr    %cl,%eax
  8031e3:	09 c2                	or     %eax,%edx
  8031e5:	89 d0                	mov    %edx,%eax
  8031e7:	89 f2                	mov    %esi,%edx
  8031e9:	f7 74 24 0c          	divl   0xc(%esp)
  8031ed:	89 d6                	mov    %edx,%esi
  8031ef:	89 c3                	mov    %eax,%ebx
  8031f1:	f7 e5                	mul    %ebp
  8031f3:	39 d6                	cmp    %edx,%esi
  8031f5:	72 19                	jb     803210 <__udivdi3+0xfc>
  8031f7:	74 0b                	je     803204 <__udivdi3+0xf0>
  8031f9:	89 d8                	mov    %ebx,%eax
  8031fb:	31 ff                	xor    %edi,%edi
  8031fd:	e9 58 ff ff ff       	jmp    80315a <__udivdi3+0x46>
  803202:	66 90                	xchg   %ax,%ax
  803204:	8b 54 24 08          	mov    0x8(%esp),%edx
  803208:	89 f9                	mov    %edi,%ecx
  80320a:	d3 e2                	shl    %cl,%edx
  80320c:	39 c2                	cmp    %eax,%edx
  80320e:	73 e9                	jae    8031f9 <__udivdi3+0xe5>
  803210:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803213:	31 ff                	xor    %edi,%edi
  803215:	e9 40 ff ff ff       	jmp    80315a <__udivdi3+0x46>
  80321a:	66 90                	xchg   %ax,%ax
  80321c:	31 c0                	xor    %eax,%eax
  80321e:	e9 37 ff ff ff       	jmp    80315a <__udivdi3+0x46>
  803223:	90                   	nop

00803224 <__umoddi3>:
  803224:	55                   	push   %ebp
  803225:	57                   	push   %edi
  803226:	56                   	push   %esi
  803227:	53                   	push   %ebx
  803228:	83 ec 1c             	sub    $0x1c,%esp
  80322b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80322f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803233:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803237:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80323b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80323f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803243:	89 f3                	mov    %esi,%ebx
  803245:	89 fa                	mov    %edi,%edx
  803247:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80324b:	89 34 24             	mov    %esi,(%esp)
  80324e:	85 c0                	test   %eax,%eax
  803250:	75 1a                	jne    80326c <__umoddi3+0x48>
  803252:	39 f7                	cmp    %esi,%edi
  803254:	0f 86 a2 00 00 00    	jbe    8032fc <__umoddi3+0xd8>
  80325a:	89 c8                	mov    %ecx,%eax
  80325c:	89 f2                	mov    %esi,%edx
  80325e:	f7 f7                	div    %edi
  803260:	89 d0                	mov    %edx,%eax
  803262:	31 d2                	xor    %edx,%edx
  803264:	83 c4 1c             	add    $0x1c,%esp
  803267:	5b                   	pop    %ebx
  803268:	5e                   	pop    %esi
  803269:	5f                   	pop    %edi
  80326a:	5d                   	pop    %ebp
  80326b:	c3                   	ret    
  80326c:	39 f0                	cmp    %esi,%eax
  80326e:	0f 87 ac 00 00 00    	ja     803320 <__umoddi3+0xfc>
  803274:	0f bd e8             	bsr    %eax,%ebp
  803277:	83 f5 1f             	xor    $0x1f,%ebp
  80327a:	0f 84 ac 00 00 00    	je     80332c <__umoddi3+0x108>
  803280:	bf 20 00 00 00       	mov    $0x20,%edi
  803285:	29 ef                	sub    %ebp,%edi
  803287:	89 fe                	mov    %edi,%esi
  803289:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80328d:	89 e9                	mov    %ebp,%ecx
  80328f:	d3 e0                	shl    %cl,%eax
  803291:	89 d7                	mov    %edx,%edi
  803293:	89 f1                	mov    %esi,%ecx
  803295:	d3 ef                	shr    %cl,%edi
  803297:	09 c7                	or     %eax,%edi
  803299:	89 e9                	mov    %ebp,%ecx
  80329b:	d3 e2                	shl    %cl,%edx
  80329d:	89 14 24             	mov    %edx,(%esp)
  8032a0:	89 d8                	mov    %ebx,%eax
  8032a2:	d3 e0                	shl    %cl,%eax
  8032a4:	89 c2                	mov    %eax,%edx
  8032a6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032aa:	d3 e0                	shl    %cl,%eax
  8032ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032b0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032b4:	89 f1                	mov    %esi,%ecx
  8032b6:	d3 e8                	shr    %cl,%eax
  8032b8:	09 d0                	or     %edx,%eax
  8032ba:	d3 eb                	shr    %cl,%ebx
  8032bc:	89 da                	mov    %ebx,%edx
  8032be:	f7 f7                	div    %edi
  8032c0:	89 d3                	mov    %edx,%ebx
  8032c2:	f7 24 24             	mull   (%esp)
  8032c5:	89 c6                	mov    %eax,%esi
  8032c7:	89 d1                	mov    %edx,%ecx
  8032c9:	39 d3                	cmp    %edx,%ebx
  8032cb:	0f 82 87 00 00 00    	jb     803358 <__umoddi3+0x134>
  8032d1:	0f 84 91 00 00 00    	je     803368 <__umoddi3+0x144>
  8032d7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032db:	29 f2                	sub    %esi,%edx
  8032dd:	19 cb                	sbb    %ecx,%ebx
  8032df:	89 d8                	mov    %ebx,%eax
  8032e1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032e5:	d3 e0                	shl    %cl,%eax
  8032e7:	89 e9                	mov    %ebp,%ecx
  8032e9:	d3 ea                	shr    %cl,%edx
  8032eb:	09 d0                	or     %edx,%eax
  8032ed:	89 e9                	mov    %ebp,%ecx
  8032ef:	d3 eb                	shr    %cl,%ebx
  8032f1:	89 da                	mov    %ebx,%edx
  8032f3:	83 c4 1c             	add    $0x1c,%esp
  8032f6:	5b                   	pop    %ebx
  8032f7:	5e                   	pop    %esi
  8032f8:	5f                   	pop    %edi
  8032f9:	5d                   	pop    %ebp
  8032fa:	c3                   	ret    
  8032fb:	90                   	nop
  8032fc:	89 fd                	mov    %edi,%ebp
  8032fe:	85 ff                	test   %edi,%edi
  803300:	75 0b                	jne    80330d <__umoddi3+0xe9>
  803302:	b8 01 00 00 00       	mov    $0x1,%eax
  803307:	31 d2                	xor    %edx,%edx
  803309:	f7 f7                	div    %edi
  80330b:	89 c5                	mov    %eax,%ebp
  80330d:	89 f0                	mov    %esi,%eax
  80330f:	31 d2                	xor    %edx,%edx
  803311:	f7 f5                	div    %ebp
  803313:	89 c8                	mov    %ecx,%eax
  803315:	f7 f5                	div    %ebp
  803317:	89 d0                	mov    %edx,%eax
  803319:	e9 44 ff ff ff       	jmp    803262 <__umoddi3+0x3e>
  80331e:	66 90                	xchg   %ax,%ax
  803320:	89 c8                	mov    %ecx,%eax
  803322:	89 f2                	mov    %esi,%edx
  803324:	83 c4 1c             	add    $0x1c,%esp
  803327:	5b                   	pop    %ebx
  803328:	5e                   	pop    %esi
  803329:	5f                   	pop    %edi
  80332a:	5d                   	pop    %ebp
  80332b:	c3                   	ret    
  80332c:	3b 04 24             	cmp    (%esp),%eax
  80332f:	72 06                	jb     803337 <__umoddi3+0x113>
  803331:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803335:	77 0f                	ja     803346 <__umoddi3+0x122>
  803337:	89 f2                	mov    %esi,%edx
  803339:	29 f9                	sub    %edi,%ecx
  80333b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80333f:	89 14 24             	mov    %edx,(%esp)
  803342:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803346:	8b 44 24 04          	mov    0x4(%esp),%eax
  80334a:	8b 14 24             	mov    (%esp),%edx
  80334d:	83 c4 1c             	add    $0x1c,%esp
  803350:	5b                   	pop    %ebx
  803351:	5e                   	pop    %esi
  803352:	5f                   	pop    %edi
  803353:	5d                   	pop    %ebp
  803354:	c3                   	ret    
  803355:	8d 76 00             	lea    0x0(%esi),%esi
  803358:	2b 04 24             	sub    (%esp),%eax
  80335b:	19 fa                	sbb    %edi,%edx
  80335d:	89 d1                	mov    %edx,%ecx
  80335f:	89 c6                	mov    %eax,%esi
  803361:	e9 71 ff ff ff       	jmp    8032d7 <__umoddi3+0xb3>
  803366:	66 90                	xchg   %ax,%ax
  803368:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80336c:	72 ea                	jb     803358 <__umoddi3+0x134>
  80336e:	89 d9                	mov    %ebx,%ecx
  803370:	e9 62 ff ff ff       	jmp    8032d7 <__umoddi3+0xb3>
