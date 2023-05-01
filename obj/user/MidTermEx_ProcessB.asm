
obj/user/MidTermEx_ProcessB:     file format elf32-i386


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
  800031:	e8 35 01 00 00       	call   80016b <libmain>
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
  80003e:	e8 6e 1a 00 00       	call   801ab1 <sys_getparentenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int delay;

	/*[1] GET SHARED VARIABLE, SEMAPHORE SEL, check-finishing counter*/
	int *X = sget(parentenvID, "X") ;
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	68 80 33 80 00       	push   $0x803380
  80004e:	ff 75 f4             	pushl  -0xc(%ebp)
  800051:	e8 14 15 00 00       	call   80156a <sget>
  800056:	83 c4 10             	add    $0x10,%esp
  800059:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int *useSem = sget(parentenvID, "useSem") ;
  80005c:	83 ec 08             	sub    $0x8,%esp
  80005f:	68 82 33 80 00       	push   $0x803382
  800064:	ff 75 f4             	pushl  -0xc(%ebp)
  800067:	e8 fe 14 00 00       	call   80156a <sget>
  80006c:	83 c4 10             	add    $0x10,%esp
  80006f:	89 45 ec             	mov    %eax,-0x14(%ebp)
	int *finishedCount = sget(parentenvID, "finishedCount") ;
  800072:	83 ec 08             	sub    $0x8,%esp
  800075:	68 89 33 80 00       	push   $0x803389
  80007a:	ff 75 f4             	pushl  -0xc(%ebp)
  80007d:	e8 e8 14 00 00       	call   80156a <sget>
  800082:	83 c4 10             	add    $0x10,%esp
  800085:	89 45 e8             	mov    %eax,-0x18(%ebp)

	/*[2] DO THE JOB*/
	int Z ;
	if (*useSem == 1)
  800088:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80008b:	8b 00                	mov    (%eax),%eax
  80008d:	83 f8 01             	cmp    $0x1,%eax
  800090:	75 13                	jne    8000a5 <_main+0x6d>
	{
		sys_waitSemaphore(parentenvID, "T") ;
  800092:	83 ec 08             	sub    $0x8,%esp
  800095:	68 97 33 80 00       	push   $0x803397
  80009a:	ff 75 f4             	pushl  -0xc(%ebp)
  80009d:	e8 b0 18 00 00       	call   801952 <sys_waitSemaphore>
  8000a2:	83 c4 10             	add    $0x10,%esp
	}

	//random delay
	delay = RAND(2000, 10000);
  8000a5:	8d 45 c8             	lea    -0x38(%ebp),%eax
  8000a8:	83 ec 0c             	sub    $0xc,%esp
  8000ab:	50                   	push   %eax
  8000ac:	e8 33 1a 00 00       	call   801ae4 <sys_get_virtual_time>
  8000b1:	83 c4 0c             	add    $0xc,%esp
  8000b4:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8000b7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000bc:	ba 00 00 00 00       	mov    $0x0,%edx
  8000c1:	f7 f1                	div    %ecx
  8000c3:	89 d0                	mov    %edx,%eax
  8000c5:	05 d0 07 00 00       	add    $0x7d0,%eax
  8000ca:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  8000cd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8000d0:	83 ec 0c             	sub    $0xc,%esp
  8000d3:	50                   	push   %eax
  8000d4:	e8 a6 2d 00 00       	call   802e7f <env_sleep>
  8000d9:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	Z = (*X) + 1 ;
  8000dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000df:	8b 00                	mov    (%eax),%eax
  8000e1:	40                   	inc    %eax
  8000e2:	89 45 e0             	mov    %eax,-0x20(%ebp)

	//random delay
	delay = RAND(2000, 10000);
  8000e5:	8d 45 d0             	lea    -0x30(%ebp),%eax
  8000e8:	83 ec 0c             	sub    $0xc,%esp
  8000eb:	50                   	push   %eax
  8000ec:	e8 f3 19 00 00       	call   801ae4 <sys_get_virtual_time>
  8000f1:	83 c4 0c             	add    $0xc,%esp
  8000f4:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f7:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  8000fc:	ba 00 00 00 00       	mov    $0x0,%edx
  800101:	f7 f1                	div    %ecx
  800103:	89 d0                	mov    %edx,%eax
  800105:	05 d0 07 00 00       	add    $0x7d0,%eax
  80010a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80010d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800110:	83 ec 0c             	sub    $0xc,%esp
  800113:	50                   	push   %eax
  800114:	e8 66 2d 00 00       	call   802e7f <env_sleep>
  800119:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	(*X) = Z ;
  80011c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80011f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800122:	89 10                	mov    %edx,(%eax)

	//random delay
	delay = RAND(2000, 10000);
  800124:	8d 45 d8             	lea    -0x28(%ebp),%eax
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	50                   	push   %eax
  80012b:	e8 b4 19 00 00       	call   801ae4 <sys_get_virtual_time>
  800130:	83 c4 0c             	add    $0xc,%esp
  800133:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800136:	b9 40 1f 00 00       	mov    $0x1f40,%ecx
  80013b:	ba 00 00 00 00       	mov    $0x0,%edx
  800140:	f7 f1                	div    %ecx
  800142:	89 d0                	mov    %edx,%eax
  800144:	05 d0 07 00 00       	add    $0x7d0,%eax
  800149:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	env_sleep(delay);
  80014c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80014f:	83 ec 0c             	sub    $0xc,%esp
  800152:	50                   	push   %eax
  800153:	e8 27 2d 00 00       	call   802e7f <env_sleep>
  800158:	83 c4 10             	add    $0x10,%esp
//	cprintf("delay = %d\n", delay);

	/*[3] DECLARE FINISHING*/
	(*finishedCount)++ ;
  80015b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80015e:	8b 00                	mov    (%eax),%eax
  800160:	8d 50 01             	lea    0x1(%eax),%edx
  800163:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800166:	89 10                	mov    %edx,(%eax)

}
  800168:	90                   	nop
  800169:	c9                   	leave  
  80016a:	c3                   	ret    

0080016b <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80016b:	55                   	push   %ebp
  80016c:	89 e5                	mov    %esp,%ebp
  80016e:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800171:	e8 22 19 00 00       	call   801a98 <sys_getenvindex>
  800176:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800179:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80017c:	89 d0                	mov    %edx,%eax
  80017e:	c1 e0 03             	shl    $0x3,%eax
  800181:	01 d0                	add    %edx,%eax
  800183:	01 c0                	add    %eax,%eax
  800185:	01 d0                	add    %edx,%eax
  800187:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80018e:	01 d0                	add    %edx,%eax
  800190:	c1 e0 04             	shl    $0x4,%eax
  800193:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800198:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80019d:	a1 20 40 80 00       	mov    0x804020,%eax
  8001a2:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8001a8:	84 c0                	test   %al,%al
  8001aa:	74 0f                	je     8001bb <libmain+0x50>
		binaryname = myEnv->prog_name;
  8001ac:	a1 20 40 80 00       	mov    0x804020,%eax
  8001b1:	05 5c 05 00 00       	add    $0x55c,%eax
  8001b6:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8001bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8001bf:	7e 0a                	jle    8001cb <libmain+0x60>
		binaryname = argv[0];
  8001c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001c4:	8b 00                	mov    (%eax),%eax
  8001c6:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  8001cb:	83 ec 08             	sub    $0x8,%esp
  8001ce:	ff 75 0c             	pushl  0xc(%ebp)
  8001d1:	ff 75 08             	pushl  0x8(%ebp)
  8001d4:	e8 5f fe ff ff       	call   800038 <_main>
  8001d9:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8001dc:	e8 c4 16 00 00       	call   8018a5 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8001e1:	83 ec 0c             	sub    $0xc,%esp
  8001e4:	68 b4 33 80 00       	push   $0x8033b4
  8001e9:	e8 8d 01 00 00       	call   80037b <cprintf>
  8001ee:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8001f1:	a1 20 40 80 00       	mov    0x804020,%eax
  8001f6:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8001fc:	a1 20 40 80 00       	mov    0x804020,%eax
  800201:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	52                   	push   %edx
  80020b:	50                   	push   %eax
  80020c:	68 dc 33 80 00       	push   $0x8033dc
  800211:	e8 65 01 00 00       	call   80037b <cprintf>
  800216:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800219:	a1 20 40 80 00       	mov    0x804020,%eax
  80021e:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800224:	a1 20 40 80 00       	mov    0x804020,%eax
  800229:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80022f:	a1 20 40 80 00       	mov    0x804020,%eax
  800234:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80023a:	51                   	push   %ecx
  80023b:	52                   	push   %edx
  80023c:	50                   	push   %eax
  80023d:	68 04 34 80 00       	push   $0x803404
  800242:	e8 34 01 00 00       	call   80037b <cprintf>
  800247:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80024a:	a1 20 40 80 00       	mov    0x804020,%eax
  80024f:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800255:	83 ec 08             	sub    $0x8,%esp
  800258:	50                   	push   %eax
  800259:	68 5c 34 80 00       	push   $0x80345c
  80025e:	e8 18 01 00 00       	call   80037b <cprintf>
  800263:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800266:	83 ec 0c             	sub    $0xc,%esp
  800269:	68 b4 33 80 00       	push   $0x8033b4
  80026e:	e8 08 01 00 00       	call   80037b <cprintf>
  800273:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800276:	e8 44 16 00 00       	call   8018bf <sys_enable_interrupt>

	// exit gracefully
	exit();
  80027b:	e8 19 00 00 00       	call   800299 <exit>
}
  800280:	90                   	nop
  800281:	c9                   	leave  
  800282:	c3                   	ret    

00800283 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800283:	55                   	push   %ebp
  800284:	89 e5                	mov    %esp,%ebp
  800286:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800289:	83 ec 0c             	sub    $0xc,%esp
  80028c:	6a 00                	push   $0x0
  80028e:	e8 d1 17 00 00       	call   801a64 <sys_destroy_env>
  800293:	83 c4 10             	add    $0x10,%esp
}
  800296:	90                   	nop
  800297:	c9                   	leave  
  800298:	c3                   	ret    

00800299 <exit>:

void
exit(void)
{
  800299:	55                   	push   %ebp
  80029a:	89 e5                	mov    %esp,%ebp
  80029c:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80029f:	e8 26 18 00 00       	call   801aca <sys_exit_env>
}
  8002a4:	90                   	nop
  8002a5:	c9                   	leave  
  8002a6:	c3                   	ret    

008002a7 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8002a7:	55                   	push   %ebp
  8002a8:	89 e5                	mov    %esp,%ebp
  8002aa:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8002ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002b0:	8b 00                	mov    (%eax),%eax
  8002b2:	8d 48 01             	lea    0x1(%eax),%ecx
  8002b5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002b8:	89 0a                	mov    %ecx,(%edx)
  8002ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8002bd:	88 d1                	mov    %dl,%cl
  8002bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002c2:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8002c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002c9:	8b 00                	mov    (%eax),%eax
  8002cb:	3d ff 00 00 00       	cmp    $0xff,%eax
  8002d0:	75 2c                	jne    8002fe <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8002d2:	a0 24 40 80 00       	mov    0x804024,%al
  8002d7:	0f b6 c0             	movzbl %al,%eax
  8002da:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002dd:	8b 12                	mov    (%edx),%edx
  8002df:	89 d1                	mov    %edx,%ecx
  8002e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8002e4:	83 c2 08             	add    $0x8,%edx
  8002e7:	83 ec 04             	sub    $0x4,%esp
  8002ea:	50                   	push   %eax
  8002eb:	51                   	push   %ecx
  8002ec:	52                   	push   %edx
  8002ed:	e8 05 14 00 00       	call   8016f7 <sys_cputs>
  8002f2:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8002f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8002fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800301:	8b 40 04             	mov    0x4(%eax),%eax
  800304:	8d 50 01             	lea    0x1(%eax),%edx
  800307:	8b 45 0c             	mov    0xc(%ebp),%eax
  80030a:	89 50 04             	mov    %edx,0x4(%eax)
}
  80030d:	90                   	nop
  80030e:	c9                   	leave  
  80030f:	c3                   	ret    

00800310 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800310:	55                   	push   %ebp
  800311:	89 e5                	mov    %esp,%ebp
  800313:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800319:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800320:	00 00 00 
	b.cnt = 0;
  800323:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80032a:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80032d:	ff 75 0c             	pushl  0xc(%ebp)
  800330:	ff 75 08             	pushl  0x8(%ebp)
  800333:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800339:	50                   	push   %eax
  80033a:	68 a7 02 80 00       	push   $0x8002a7
  80033f:	e8 11 02 00 00       	call   800555 <vprintfmt>
  800344:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800347:	a0 24 40 80 00       	mov    0x804024,%al
  80034c:	0f b6 c0             	movzbl %al,%eax
  80034f:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800355:	83 ec 04             	sub    $0x4,%esp
  800358:	50                   	push   %eax
  800359:	52                   	push   %edx
  80035a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800360:	83 c0 08             	add    $0x8,%eax
  800363:	50                   	push   %eax
  800364:	e8 8e 13 00 00       	call   8016f7 <sys_cputs>
  800369:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80036c:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800373:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <cprintf>:

int cprintf(const char *fmt, ...) {
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800381:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  800388:	8d 45 0c             	lea    0xc(%ebp),%eax
  80038b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	83 ec 08             	sub    $0x8,%esp
  800394:	ff 75 f4             	pushl  -0xc(%ebp)
  800397:	50                   	push   %eax
  800398:	e8 73 ff ff ff       	call   800310 <vcprintf>
  80039d:	83 c4 10             	add    $0x10,%esp
  8003a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8003a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8003ae:	e8 f2 14 00 00       	call   8018a5 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8003b3:	8d 45 0c             	lea    0xc(%ebp),%eax
  8003b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8003b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003bc:	83 ec 08             	sub    $0x8,%esp
  8003bf:	ff 75 f4             	pushl  -0xc(%ebp)
  8003c2:	50                   	push   %eax
  8003c3:	e8 48 ff ff ff       	call   800310 <vcprintf>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8003ce:	e8 ec 14 00 00       	call   8018bf <sys_enable_interrupt>
	return cnt;
  8003d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8003d6:	c9                   	leave  
  8003d7:	c3                   	ret    

008003d8 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8003d8:	55                   	push   %ebp
  8003d9:	89 e5                	mov    %esp,%ebp
  8003db:	53                   	push   %ebx
  8003dc:	83 ec 14             	sub    $0x14,%esp
  8003df:	8b 45 10             	mov    0x10(%ebp),%eax
  8003e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8003e5:	8b 45 14             	mov    0x14(%ebp),%eax
  8003e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8003eb:	8b 45 18             	mov    0x18(%ebp),%eax
  8003ee:	ba 00 00 00 00       	mov    $0x0,%edx
  8003f3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003f6:	77 55                	ja     80044d <printnum+0x75>
  8003f8:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8003fb:	72 05                	jb     800402 <printnum+0x2a>
  8003fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800400:	77 4b                	ja     80044d <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800402:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800405:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800408:	8b 45 18             	mov    0x18(%ebp),%eax
  80040b:	ba 00 00 00 00       	mov    $0x0,%edx
  800410:	52                   	push   %edx
  800411:	50                   	push   %eax
  800412:	ff 75 f4             	pushl  -0xc(%ebp)
  800415:	ff 75 f0             	pushl  -0x10(%ebp)
  800418:	e8 f7 2c 00 00       	call   803114 <__udivdi3>
  80041d:	83 c4 10             	add    $0x10,%esp
  800420:	83 ec 04             	sub    $0x4,%esp
  800423:	ff 75 20             	pushl  0x20(%ebp)
  800426:	53                   	push   %ebx
  800427:	ff 75 18             	pushl  0x18(%ebp)
  80042a:	52                   	push   %edx
  80042b:	50                   	push   %eax
  80042c:	ff 75 0c             	pushl  0xc(%ebp)
  80042f:	ff 75 08             	pushl  0x8(%ebp)
  800432:	e8 a1 ff ff ff       	call   8003d8 <printnum>
  800437:	83 c4 20             	add    $0x20,%esp
  80043a:	eb 1a                	jmp    800456 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80043c:	83 ec 08             	sub    $0x8,%esp
  80043f:	ff 75 0c             	pushl  0xc(%ebp)
  800442:	ff 75 20             	pushl  0x20(%ebp)
  800445:	8b 45 08             	mov    0x8(%ebp),%eax
  800448:	ff d0                	call   *%eax
  80044a:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80044d:	ff 4d 1c             	decl   0x1c(%ebp)
  800450:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800454:	7f e6                	jg     80043c <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800456:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800459:	bb 00 00 00 00       	mov    $0x0,%ebx
  80045e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800461:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800464:	53                   	push   %ebx
  800465:	51                   	push   %ecx
  800466:	52                   	push   %edx
  800467:	50                   	push   %eax
  800468:	e8 b7 2d 00 00       	call   803224 <__umoddi3>
  80046d:	83 c4 10             	add    $0x10,%esp
  800470:	05 94 36 80 00       	add    $0x803694,%eax
  800475:	8a 00                	mov    (%eax),%al
  800477:	0f be c0             	movsbl %al,%eax
  80047a:	83 ec 08             	sub    $0x8,%esp
  80047d:	ff 75 0c             	pushl  0xc(%ebp)
  800480:	50                   	push   %eax
  800481:	8b 45 08             	mov    0x8(%ebp),%eax
  800484:	ff d0                	call   *%eax
  800486:	83 c4 10             	add    $0x10,%esp
}
  800489:	90                   	nop
  80048a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800492:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800496:	7e 1c                	jle    8004b4 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800498:	8b 45 08             	mov    0x8(%ebp),%eax
  80049b:	8b 00                	mov    (%eax),%eax
  80049d:	8d 50 08             	lea    0x8(%eax),%edx
  8004a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a3:	89 10                	mov    %edx,(%eax)
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8b 00                	mov    (%eax),%eax
  8004aa:	83 e8 08             	sub    $0x8,%eax
  8004ad:	8b 50 04             	mov    0x4(%eax),%edx
  8004b0:	8b 00                	mov    (%eax),%eax
  8004b2:	eb 40                	jmp    8004f4 <getuint+0x65>
	else if (lflag)
  8004b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004b8:	74 1e                	je     8004d8 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8004ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8004bd:	8b 00                	mov    (%eax),%eax
  8004bf:	8d 50 04             	lea    0x4(%eax),%edx
  8004c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c5:	89 10                	mov    %edx,(%eax)
  8004c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ca:	8b 00                	mov    (%eax),%eax
  8004cc:	83 e8 04             	sub    $0x4,%eax
  8004cf:	8b 00                	mov    (%eax),%eax
  8004d1:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d6:	eb 1c                	jmp    8004f4 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8004d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8004db:	8b 00                	mov    (%eax),%eax
  8004dd:	8d 50 04             	lea    0x4(%eax),%edx
  8004e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e3:	89 10                	mov    %edx,(%eax)
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	83 e8 04             	sub    $0x4,%eax
  8004ed:	8b 00                	mov    (%eax),%eax
  8004ef:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8004f4:	5d                   	pop    %ebp
  8004f5:	c3                   	ret    

008004f6 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8004f6:	55                   	push   %ebp
  8004f7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8004f9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004fd:	7e 1c                	jle    80051b <getint+0x25>
		return va_arg(*ap, long long);
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	8d 50 08             	lea    0x8(%eax),%edx
  800507:	8b 45 08             	mov    0x8(%ebp),%eax
  80050a:	89 10                	mov    %edx,(%eax)
  80050c:	8b 45 08             	mov    0x8(%ebp),%eax
  80050f:	8b 00                	mov    (%eax),%eax
  800511:	83 e8 08             	sub    $0x8,%eax
  800514:	8b 50 04             	mov    0x4(%eax),%edx
  800517:	8b 00                	mov    (%eax),%eax
  800519:	eb 38                	jmp    800553 <getint+0x5d>
	else if (lflag)
  80051b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80051f:	74 1a                	je     80053b <getint+0x45>
		return va_arg(*ap, long);
  800521:	8b 45 08             	mov    0x8(%ebp),%eax
  800524:	8b 00                	mov    (%eax),%eax
  800526:	8d 50 04             	lea    0x4(%eax),%edx
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	89 10                	mov    %edx,(%eax)
  80052e:	8b 45 08             	mov    0x8(%ebp),%eax
  800531:	8b 00                	mov    (%eax),%eax
  800533:	83 e8 04             	sub    $0x4,%eax
  800536:	8b 00                	mov    (%eax),%eax
  800538:	99                   	cltd   
  800539:	eb 18                	jmp    800553 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	8b 00                	mov    (%eax),%eax
  800540:	8d 50 04             	lea    0x4(%eax),%edx
  800543:	8b 45 08             	mov    0x8(%ebp),%eax
  800546:	89 10                	mov    %edx,(%eax)
  800548:	8b 45 08             	mov    0x8(%ebp),%eax
  80054b:	8b 00                	mov    (%eax),%eax
  80054d:	83 e8 04             	sub    $0x4,%eax
  800550:	8b 00                	mov    (%eax),%eax
  800552:	99                   	cltd   
}
  800553:	5d                   	pop    %ebp
  800554:	c3                   	ret    

00800555 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800555:	55                   	push   %ebp
  800556:	89 e5                	mov    %esp,%ebp
  800558:	56                   	push   %esi
  800559:	53                   	push   %ebx
  80055a:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80055d:	eb 17                	jmp    800576 <vprintfmt+0x21>
			if (ch == '\0')
  80055f:	85 db                	test   %ebx,%ebx
  800561:	0f 84 af 03 00 00    	je     800916 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800567:	83 ec 08             	sub    $0x8,%esp
  80056a:	ff 75 0c             	pushl  0xc(%ebp)
  80056d:	53                   	push   %ebx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	ff d0                	call   *%eax
  800573:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800576:	8b 45 10             	mov    0x10(%ebp),%eax
  800579:	8d 50 01             	lea    0x1(%eax),%edx
  80057c:	89 55 10             	mov    %edx,0x10(%ebp)
  80057f:	8a 00                	mov    (%eax),%al
  800581:	0f b6 d8             	movzbl %al,%ebx
  800584:	83 fb 25             	cmp    $0x25,%ebx
  800587:	75 d6                	jne    80055f <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800589:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  80058d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800594:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80059b:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8005a2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8005a9:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ac:	8d 50 01             	lea    0x1(%eax),%edx
  8005af:	89 55 10             	mov    %edx,0x10(%ebp)
  8005b2:	8a 00                	mov    (%eax),%al
  8005b4:	0f b6 d8             	movzbl %al,%ebx
  8005b7:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8005ba:	83 f8 55             	cmp    $0x55,%eax
  8005bd:	0f 87 2b 03 00 00    	ja     8008ee <vprintfmt+0x399>
  8005c3:	8b 04 85 b8 36 80 00 	mov    0x8036b8(,%eax,4),%eax
  8005ca:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8005cc:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8005d0:	eb d7                	jmp    8005a9 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8005d2:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8005d6:	eb d1                	jmp    8005a9 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8005d8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8005df:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8005e2:	89 d0                	mov    %edx,%eax
  8005e4:	c1 e0 02             	shl    $0x2,%eax
  8005e7:	01 d0                	add    %edx,%eax
  8005e9:	01 c0                	add    %eax,%eax
  8005eb:	01 d8                	add    %ebx,%eax
  8005ed:	83 e8 30             	sub    $0x30,%eax
  8005f0:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8005f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8005f6:	8a 00                	mov    (%eax),%al
  8005f8:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8005fb:	83 fb 2f             	cmp    $0x2f,%ebx
  8005fe:	7e 3e                	jle    80063e <vprintfmt+0xe9>
  800600:	83 fb 39             	cmp    $0x39,%ebx
  800603:	7f 39                	jg     80063e <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800605:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800608:	eb d5                	jmp    8005df <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80060a:	8b 45 14             	mov    0x14(%ebp),%eax
  80060d:	83 c0 04             	add    $0x4,%eax
  800610:	89 45 14             	mov    %eax,0x14(%ebp)
  800613:	8b 45 14             	mov    0x14(%ebp),%eax
  800616:	83 e8 04             	sub    $0x4,%eax
  800619:	8b 00                	mov    (%eax),%eax
  80061b:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  80061e:	eb 1f                	jmp    80063f <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800620:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800624:	79 83                	jns    8005a9 <vprintfmt+0x54>
				width = 0;
  800626:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80062d:	e9 77 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800632:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800639:	e9 6b ff ff ff       	jmp    8005a9 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80063e:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  80063f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800643:	0f 89 60 ff ff ff    	jns    8005a9 <vprintfmt+0x54>
				width = precision, precision = -1;
  800649:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80064c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80064f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800656:	e9 4e ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80065b:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80065e:	e9 46 ff ff ff       	jmp    8005a9 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800663:	8b 45 14             	mov    0x14(%ebp),%eax
  800666:	83 c0 04             	add    $0x4,%eax
  800669:	89 45 14             	mov    %eax,0x14(%ebp)
  80066c:	8b 45 14             	mov    0x14(%ebp),%eax
  80066f:	83 e8 04             	sub    $0x4,%eax
  800672:	8b 00                	mov    (%eax),%eax
  800674:	83 ec 08             	sub    $0x8,%esp
  800677:	ff 75 0c             	pushl  0xc(%ebp)
  80067a:	50                   	push   %eax
  80067b:	8b 45 08             	mov    0x8(%ebp),%eax
  80067e:	ff d0                	call   *%eax
  800680:	83 c4 10             	add    $0x10,%esp
			break;
  800683:	e9 89 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	83 c0 04             	add    $0x4,%eax
  80068e:	89 45 14             	mov    %eax,0x14(%ebp)
  800691:	8b 45 14             	mov    0x14(%ebp),%eax
  800694:	83 e8 04             	sub    $0x4,%eax
  800697:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800699:	85 db                	test   %ebx,%ebx
  80069b:	79 02                	jns    80069f <vprintfmt+0x14a>
				err = -err;
  80069d:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  80069f:	83 fb 64             	cmp    $0x64,%ebx
  8006a2:	7f 0b                	jg     8006af <vprintfmt+0x15a>
  8006a4:	8b 34 9d 00 35 80 00 	mov    0x803500(,%ebx,4),%esi
  8006ab:	85 f6                	test   %esi,%esi
  8006ad:	75 19                	jne    8006c8 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8006af:	53                   	push   %ebx
  8006b0:	68 a5 36 80 00       	push   $0x8036a5
  8006b5:	ff 75 0c             	pushl  0xc(%ebp)
  8006b8:	ff 75 08             	pushl  0x8(%ebp)
  8006bb:	e8 5e 02 00 00       	call   80091e <printfmt>
  8006c0:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8006c3:	e9 49 02 00 00       	jmp    800911 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8006c8:	56                   	push   %esi
  8006c9:	68 ae 36 80 00       	push   $0x8036ae
  8006ce:	ff 75 0c             	pushl  0xc(%ebp)
  8006d1:	ff 75 08             	pushl  0x8(%ebp)
  8006d4:	e8 45 02 00 00       	call   80091e <printfmt>
  8006d9:	83 c4 10             	add    $0x10,%esp
			break;
  8006dc:	e9 30 02 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8006e1:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e4:	83 c0 04             	add    $0x4,%eax
  8006e7:	89 45 14             	mov    %eax,0x14(%ebp)
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	83 e8 04             	sub    $0x4,%eax
  8006f0:	8b 30                	mov    (%eax),%esi
  8006f2:	85 f6                	test   %esi,%esi
  8006f4:	75 05                	jne    8006fb <vprintfmt+0x1a6>
				p = "(null)";
  8006f6:	be b1 36 80 00       	mov    $0x8036b1,%esi
			if (width > 0 && padc != '-')
  8006fb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8006ff:	7e 6d                	jle    80076e <vprintfmt+0x219>
  800701:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800705:	74 67                	je     80076e <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800707:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80070a:	83 ec 08             	sub    $0x8,%esp
  80070d:	50                   	push   %eax
  80070e:	56                   	push   %esi
  80070f:	e8 0c 03 00 00       	call   800a20 <strnlen>
  800714:	83 c4 10             	add    $0x10,%esp
  800717:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  80071a:	eb 16                	jmp    800732 <vprintfmt+0x1dd>
					putch(padc, putdat);
  80071c:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	ff 75 0c             	pushl  0xc(%ebp)
  800726:	50                   	push   %eax
  800727:	8b 45 08             	mov    0x8(%ebp),%eax
  80072a:	ff d0                	call   *%eax
  80072c:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80072f:	ff 4d e4             	decl   -0x1c(%ebp)
  800732:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800736:	7f e4                	jg     80071c <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800738:	eb 34                	jmp    80076e <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80073a:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80073e:	74 1c                	je     80075c <vprintfmt+0x207>
  800740:	83 fb 1f             	cmp    $0x1f,%ebx
  800743:	7e 05                	jle    80074a <vprintfmt+0x1f5>
  800745:	83 fb 7e             	cmp    $0x7e,%ebx
  800748:	7e 12                	jle    80075c <vprintfmt+0x207>
					putch('?', putdat);
  80074a:	83 ec 08             	sub    $0x8,%esp
  80074d:	ff 75 0c             	pushl  0xc(%ebp)
  800750:	6a 3f                	push   $0x3f
  800752:	8b 45 08             	mov    0x8(%ebp),%eax
  800755:	ff d0                	call   *%eax
  800757:	83 c4 10             	add    $0x10,%esp
  80075a:	eb 0f                	jmp    80076b <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	ff 75 0c             	pushl  0xc(%ebp)
  800762:	53                   	push   %ebx
  800763:	8b 45 08             	mov    0x8(%ebp),%eax
  800766:	ff d0                	call   *%eax
  800768:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80076b:	ff 4d e4             	decl   -0x1c(%ebp)
  80076e:	89 f0                	mov    %esi,%eax
  800770:	8d 70 01             	lea    0x1(%eax),%esi
  800773:	8a 00                	mov    (%eax),%al
  800775:	0f be d8             	movsbl %al,%ebx
  800778:	85 db                	test   %ebx,%ebx
  80077a:	74 24                	je     8007a0 <vprintfmt+0x24b>
  80077c:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800780:	78 b8                	js     80073a <vprintfmt+0x1e5>
  800782:	ff 4d e0             	decl   -0x20(%ebp)
  800785:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800789:	79 af                	jns    80073a <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80078b:	eb 13                	jmp    8007a0 <vprintfmt+0x24b>
				putch(' ', putdat);
  80078d:	83 ec 08             	sub    $0x8,%esp
  800790:	ff 75 0c             	pushl  0xc(%ebp)
  800793:	6a 20                	push   $0x20
  800795:	8b 45 08             	mov    0x8(%ebp),%eax
  800798:	ff d0                	call   *%eax
  80079a:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80079d:	ff 4d e4             	decl   -0x1c(%ebp)
  8007a0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007a4:	7f e7                	jg     80078d <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  8007a6:	e9 66 01 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  8007ab:	83 ec 08             	sub    $0x8,%esp
  8007ae:	ff 75 e8             	pushl  -0x18(%ebp)
  8007b1:	8d 45 14             	lea    0x14(%ebp),%eax
  8007b4:	50                   	push   %eax
  8007b5:	e8 3c fd ff ff       	call   8004f6 <getint>
  8007ba:	83 c4 10             	add    $0x10,%esp
  8007bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007c0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  8007c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007c6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007c9:	85 d2                	test   %edx,%edx
  8007cb:	79 23                	jns    8007f0 <vprintfmt+0x29b>
				putch('-', putdat);
  8007cd:	83 ec 08             	sub    $0x8,%esp
  8007d0:	ff 75 0c             	pushl  0xc(%ebp)
  8007d3:	6a 2d                	push   $0x2d
  8007d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d8:	ff d0                	call   *%eax
  8007da:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8007dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8007e3:	f7 d8                	neg    %eax
  8007e5:	83 d2 00             	adc    $0x0,%edx
  8007e8:	f7 da                	neg    %edx
  8007ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007ed:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8007f0:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8007f7:	e9 bc 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8007fc:	83 ec 08             	sub    $0x8,%esp
  8007ff:	ff 75 e8             	pushl  -0x18(%ebp)
  800802:	8d 45 14             	lea    0x14(%ebp),%eax
  800805:	50                   	push   %eax
  800806:	e8 84 fc ff ff       	call   80048f <getuint>
  80080b:	83 c4 10             	add    $0x10,%esp
  80080e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800811:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800814:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  80081b:	e9 98 00 00 00       	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800820:	83 ec 08             	sub    $0x8,%esp
  800823:	ff 75 0c             	pushl  0xc(%ebp)
  800826:	6a 58                	push   $0x58
  800828:	8b 45 08             	mov    0x8(%ebp),%eax
  80082b:	ff d0                	call   *%eax
  80082d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800830:	83 ec 08             	sub    $0x8,%esp
  800833:	ff 75 0c             	pushl  0xc(%ebp)
  800836:	6a 58                	push   $0x58
  800838:	8b 45 08             	mov    0x8(%ebp),%eax
  80083b:	ff d0                	call   *%eax
  80083d:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800840:	83 ec 08             	sub    $0x8,%esp
  800843:	ff 75 0c             	pushl  0xc(%ebp)
  800846:	6a 58                	push   $0x58
  800848:	8b 45 08             	mov    0x8(%ebp),%eax
  80084b:	ff d0                	call   *%eax
  80084d:	83 c4 10             	add    $0x10,%esp
			break;
  800850:	e9 bc 00 00 00       	jmp    800911 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800855:	83 ec 08             	sub    $0x8,%esp
  800858:	ff 75 0c             	pushl  0xc(%ebp)
  80085b:	6a 30                	push   $0x30
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
  800862:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800865:	83 ec 08             	sub    $0x8,%esp
  800868:	ff 75 0c             	pushl  0xc(%ebp)
  80086b:	6a 78                	push   $0x78
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	ff d0                	call   *%eax
  800872:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800875:	8b 45 14             	mov    0x14(%ebp),%eax
  800878:	83 c0 04             	add    $0x4,%eax
  80087b:	89 45 14             	mov    %eax,0x14(%ebp)
  80087e:	8b 45 14             	mov    0x14(%ebp),%eax
  800881:	83 e8 04             	sub    $0x4,%eax
  800884:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800886:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800889:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800890:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800897:	eb 1f                	jmp    8008b8 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800899:	83 ec 08             	sub    $0x8,%esp
  80089c:	ff 75 e8             	pushl  -0x18(%ebp)
  80089f:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a2:	50                   	push   %eax
  8008a3:	e8 e7 fb ff ff       	call   80048f <getuint>
  8008a8:	83 c4 10             	add    $0x10,%esp
  8008ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  8008b1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  8008b8:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8008bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8008bf:	83 ec 04             	sub    $0x4,%esp
  8008c2:	52                   	push   %edx
  8008c3:	ff 75 e4             	pushl  -0x1c(%ebp)
  8008c6:	50                   	push   %eax
  8008c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ca:	ff 75 f0             	pushl  -0x10(%ebp)
  8008cd:	ff 75 0c             	pushl  0xc(%ebp)
  8008d0:	ff 75 08             	pushl  0x8(%ebp)
  8008d3:	e8 00 fb ff ff       	call   8003d8 <printnum>
  8008d8:	83 c4 20             	add    $0x20,%esp
			break;
  8008db:	eb 34                	jmp    800911 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8008dd:	83 ec 08             	sub    $0x8,%esp
  8008e0:	ff 75 0c             	pushl  0xc(%ebp)
  8008e3:	53                   	push   %ebx
  8008e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e7:	ff d0                	call   *%eax
  8008e9:	83 c4 10             	add    $0x10,%esp
			break;
  8008ec:	eb 23                	jmp    800911 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8008ee:	83 ec 08             	sub    $0x8,%esp
  8008f1:	ff 75 0c             	pushl  0xc(%ebp)
  8008f4:	6a 25                	push   $0x25
  8008f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f9:	ff d0                	call   *%eax
  8008fb:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8008fe:	ff 4d 10             	decl   0x10(%ebp)
  800901:	eb 03                	jmp    800906 <vprintfmt+0x3b1>
  800903:	ff 4d 10             	decl   0x10(%ebp)
  800906:	8b 45 10             	mov    0x10(%ebp),%eax
  800909:	48                   	dec    %eax
  80090a:	8a 00                	mov    (%eax),%al
  80090c:	3c 25                	cmp    $0x25,%al
  80090e:	75 f3                	jne    800903 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800910:	90                   	nop
		}
	}
  800911:	e9 47 fc ff ff       	jmp    80055d <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800916:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800917:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80091a:	5b                   	pop    %ebx
  80091b:	5e                   	pop    %esi
  80091c:	5d                   	pop    %ebp
  80091d:	c3                   	ret    

0080091e <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  80091e:	55                   	push   %ebp
  80091f:	89 e5                	mov    %esp,%ebp
  800921:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800924:	8d 45 10             	lea    0x10(%ebp),%eax
  800927:	83 c0 04             	add    $0x4,%eax
  80092a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  80092d:	8b 45 10             	mov    0x10(%ebp),%eax
  800930:	ff 75 f4             	pushl  -0xc(%ebp)
  800933:	50                   	push   %eax
  800934:	ff 75 0c             	pushl  0xc(%ebp)
  800937:	ff 75 08             	pushl  0x8(%ebp)
  80093a:	e8 16 fc ff ff       	call   800555 <vprintfmt>
  80093f:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800942:	90                   	nop
  800943:	c9                   	leave  
  800944:	c3                   	ret    

00800945 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800945:	55                   	push   %ebp
  800946:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800948:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094b:	8b 40 08             	mov    0x8(%eax),%eax
  80094e:	8d 50 01             	lea    0x1(%eax),%edx
  800951:	8b 45 0c             	mov    0xc(%ebp),%eax
  800954:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800957:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095a:	8b 10                	mov    (%eax),%edx
  80095c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80095f:	8b 40 04             	mov    0x4(%eax),%eax
  800962:	39 c2                	cmp    %eax,%edx
  800964:	73 12                	jae    800978 <sprintputch+0x33>
		*b->buf++ = ch;
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	8d 48 01             	lea    0x1(%eax),%ecx
  80096e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800971:	89 0a                	mov    %ecx,(%edx)
  800973:	8b 55 08             	mov    0x8(%ebp),%edx
  800976:	88 10                	mov    %dl,(%eax)
}
  800978:	90                   	nop
  800979:	5d                   	pop    %ebp
  80097a:	c3                   	ret    

0080097b <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80097b:	55                   	push   %ebp
  80097c:	89 e5                	mov    %esp,%ebp
  80097e:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800981:	8b 45 08             	mov    0x8(%ebp),%eax
  800984:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800987:	8b 45 0c             	mov    0xc(%ebp),%eax
  80098a:	8d 50 ff             	lea    -0x1(%eax),%edx
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	01 d0                	add    %edx,%eax
  800992:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800995:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80099c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009a0:	74 06                	je     8009a8 <vsnprintf+0x2d>
  8009a2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8009a6:	7f 07                	jg     8009af <vsnprintf+0x34>
		return -E_INVAL;
  8009a8:	b8 03 00 00 00       	mov    $0x3,%eax
  8009ad:	eb 20                	jmp    8009cf <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  8009af:	ff 75 14             	pushl  0x14(%ebp)
  8009b2:	ff 75 10             	pushl  0x10(%ebp)
  8009b5:	8d 45 ec             	lea    -0x14(%ebp),%eax
  8009b8:	50                   	push   %eax
  8009b9:	68 45 09 80 00       	push   $0x800945
  8009be:	e8 92 fb ff ff       	call   800555 <vprintfmt>
  8009c3:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8009c6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009c9:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8009cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8009cf:	c9                   	leave  
  8009d0:	c3                   	ret    

008009d1 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8009d1:	55                   	push   %ebp
  8009d2:	89 e5                	mov    %esp,%ebp
  8009d4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8009d7:	8d 45 10             	lea    0x10(%ebp),%eax
  8009da:	83 c0 04             	add    $0x4,%eax
  8009dd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8009e0:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009e6:	50                   	push   %eax
  8009e7:	ff 75 0c             	pushl  0xc(%ebp)
  8009ea:	ff 75 08             	pushl  0x8(%ebp)
  8009ed:	e8 89 ff ff ff       	call   80097b <vsnprintf>
  8009f2:	83 c4 10             	add    $0x10,%esp
  8009f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8009f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fb:	c9                   	leave  
  8009fc:	c3                   	ret    

008009fd <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8009fd:	55                   	push   %ebp
  8009fe:	89 e5                	mov    %esp,%ebp
  800a00:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800a03:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a0a:	eb 06                	jmp    800a12 <strlen+0x15>
		n++;
  800a0c:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800a0f:	ff 45 08             	incl   0x8(%ebp)
  800a12:	8b 45 08             	mov    0x8(%ebp),%eax
  800a15:	8a 00                	mov    (%eax),%al
  800a17:	84 c0                	test   %al,%al
  800a19:	75 f1                	jne    800a0c <strlen+0xf>
		n++;
	return n;
  800a1b:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a1e:	c9                   	leave  
  800a1f:	c3                   	ret    

00800a20 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800a20:	55                   	push   %ebp
  800a21:	89 e5                	mov    %esp,%ebp
  800a23:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a26:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a2d:	eb 09                	jmp    800a38 <strnlen+0x18>
		n++;
  800a2f:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800a32:	ff 45 08             	incl   0x8(%ebp)
  800a35:	ff 4d 0c             	decl   0xc(%ebp)
  800a38:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800a3c:	74 09                	je     800a47 <strnlen+0x27>
  800a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800a41:	8a 00                	mov    (%eax),%al
  800a43:	84 c0                	test   %al,%al
  800a45:	75 e8                	jne    800a2f <strnlen+0xf>
		n++;
	return n;
  800a47:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a4a:	c9                   	leave  
  800a4b:	c3                   	ret    

00800a4c <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800a4c:	55                   	push   %ebp
  800a4d:	89 e5                	mov    %esp,%ebp
  800a4f:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800a52:	8b 45 08             	mov    0x8(%ebp),%eax
  800a55:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800a58:	90                   	nop
  800a59:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5c:	8d 50 01             	lea    0x1(%eax),%edx
  800a5f:	89 55 08             	mov    %edx,0x8(%ebp)
  800a62:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a65:	8d 4a 01             	lea    0x1(%edx),%ecx
  800a68:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800a6b:	8a 12                	mov    (%edx),%dl
  800a6d:	88 10                	mov    %dl,(%eax)
  800a6f:	8a 00                	mov    (%eax),%al
  800a71:	84 c0                	test   %al,%al
  800a73:	75 e4                	jne    800a59 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800a75:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800a78:	c9                   	leave  
  800a79:	c3                   	ret    

00800a7a <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800a7a:	55                   	push   %ebp
  800a7b:	89 e5                	mov    %esp,%ebp
  800a7d:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800a80:	8b 45 08             	mov    0x8(%ebp),%eax
  800a83:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800a86:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800a8d:	eb 1f                	jmp    800aae <strncpy+0x34>
		*dst++ = *src;
  800a8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800a92:	8d 50 01             	lea    0x1(%eax),%edx
  800a95:	89 55 08             	mov    %edx,0x8(%ebp)
  800a98:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a9b:	8a 12                	mov    (%edx),%dl
  800a9d:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aa2:	8a 00                	mov    (%eax),%al
  800aa4:	84 c0                	test   %al,%al
  800aa6:	74 03                	je     800aab <strncpy+0x31>
			src++;
  800aa8:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800aab:	ff 45 fc             	incl   -0x4(%ebp)
  800aae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ab1:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ab4:	72 d9                	jb     800a8f <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ab6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ab9:	c9                   	leave  
  800aba:	c3                   	ret    

00800abb <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800abb:	55                   	push   %ebp
  800abc:	89 e5                	mov    %esp,%ebp
  800abe:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ac1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ac7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800acb:	74 30                	je     800afd <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800acd:	eb 16                	jmp    800ae5 <strlcpy+0x2a>
			*dst++ = *src++;
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	8d 50 01             	lea    0x1(%eax),%edx
  800ad5:	89 55 08             	mov    %edx,0x8(%ebp)
  800ad8:	8b 55 0c             	mov    0xc(%ebp),%edx
  800adb:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ade:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ae1:	8a 12                	mov    (%edx),%dl
  800ae3:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ae5:	ff 4d 10             	decl   0x10(%ebp)
  800ae8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800aec:	74 09                	je     800af7 <strlcpy+0x3c>
  800aee:	8b 45 0c             	mov    0xc(%ebp),%eax
  800af1:	8a 00                	mov    (%eax),%al
  800af3:	84 c0                	test   %al,%al
  800af5:	75 d8                	jne    800acf <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800afd:	8b 55 08             	mov    0x8(%ebp),%edx
  800b00:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800b03:	29 c2                	sub    %eax,%edx
  800b05:	89 d0                	mov    %edx,%eax
}
  800b07:	c9                   	leave  
  800b08:	c3                   	ret    

00800b09 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800b09:	55                   	push   %ebp
  800b0a:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800b0c:	eb 06                	jmp    800b14 <strcmp+0xb>
		p++, q++;
  800b0e:	ff 45 08             	incl   0x8(%ebp)
  800b11:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8a 00                	mov    (%eax),%al
  800b19:	84 c0                	test   %al,%al
  800b1b:	74 0e                	je     800b2b <strcmp+0x22>
  800b1d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b20:	8a 10                	mov    (%eax),%dl
  800b22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b25:	8a 00                	mov    (%eax),%al
  800b27:	38 c2                	cmp    %al,%dl
  800b29:	74 e3                	je     800b0e <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800b2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b2e:	8a 00                	mov    (%eax),%al
  800b30:	0f b6 d0             	movzbl %al,%edx
  800b33:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b36:	8a 00                	mov    (%eax),%al
  800b38:	0f b6 c0             	movzbl %al,%eax
  800b3b:	29 c2                	sub    %eax,%edx
  800b3d:	89 d0                	mov    %edx,%eax
}
  800b3f:	5d                   	pop    %ebp
  800b40:	c3                   	ret    

00800b41 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800b41:	55                   	push   %ebp
  800b42:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800b44:	eb 09                	jmp    800b4f <strncmp+0xe>
		n--, p++, q++;
  800b46:	ff 4d 10             	decl   0x10(%ebp)
  800b49:	ff 45 08             	incl   0x8(%ebp)
  800b4c:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800b4f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b53:	74 17                	je     800b6c <strncmp+0x2b>
  800b55:	8b 45 08             	mov    0x8(%ebp),%eax
  800b58:	8a 00                	mov    (%eax),%al
  800b5a:	84 c0                	test   %al,%al
  800b5c:	74 0e                	je     800b6c <strncmp+0x2b>
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8a 10                	mov    (%eax),%dl
  800b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b66:	8a 00                	mov    (%eax),%al
  800b68:	38 c2                	cmp    %al,%dl
  800b6a:	74 da                	je     800b46 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800b6c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800b70:	75 07                	jne    800b79 <strncmp+0x38>
		return 0;
  800b72:	b8 00 00 00 00       	mov    $0x0,%eax
  800b77:	eb 14                	jmp    800b8d <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800b79:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7c:	8a 00                	mov    (%eax),%al
  800b7e:	0f b6 d0             	movzbl %al,%edx
  800b81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b84:	8a 00                	mov    (%eax),%al
  800b86:	0f b6 c0             	movzbl %al,%eax
  800b89:	29 c2                	sub    %eax,%edx
  800b8b:	89 d0                	mov    %edx,%eax
}
  800b8d:	5d                   	pop    %ebp
  800b8e:	c3                   	ret    

00800b8f <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800b8f:	55                   	push   %ebp
  800b90:	89 e5                	mov    %esp,%ebp
  800b92:	83 ec 04             	sub    $0x4,%esp
  800b95:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b98:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800b9b:	eb 12                	jmp    800baf <strchr+0x20>
		if (*s == c)
  800b9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba0:	8a 00                	mov    (%eax),%al
  800ba2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ba5:	75 05                	jne    800bac <strchr+0x1d>
			return (char *) s;
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	eb 11                	jmp    800bbd <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800bac:	ff 45 08             	incl   0x8(%ebp)
  800baf:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb2:	8a 00                	mov    (%eax),%al
  800bb4:	84 c0                	test   %al,%al
  800bb6:	75 e5                	jne    800b9d <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800bb8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800bbd:	c9                   	leave  
  800bbe:	c3                   	ret    

00800bbf <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800bbf:	55                   	push   %ebp
  800bc0:	89 e5                	mov    %esp,%ebp
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bc8:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800bcb:	eb 0d                	jmp    800bda <strfind+0x1b>
		if (*s == c)
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	8a 00                	mov    (%eax),%al
  800bd2:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800bd5:	74 0e                	je     800be5 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800bd7:	ff 45 08             	incl   0x8(%ebp)
  800bda:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdd:	8a 00                	mov    (%eax),%al
  800bdf:	84 c0                	test   %al,%al
  800be1:	75 ea                	jne    800bcd <strfind+0xe>
  800be3:	eb 01                	jmp    800be6 <strfind+0x27>
		if (*s == c)
			break;
  800be5:	90                   	nop
	return (char *) s;
  800be6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800bf1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800bf7:	8b 45 10             	mov    0x10(%ebp),%eax
  800bfa:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800bfd:	eb 0e                	jmp    800c0d <memset+0x22>
		*p++ = c;
  800bff:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c02:	8d 50 01             	lea    0x1(%eax),%edx
  800c05:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800c08:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c0b:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800c0d:	ff 4d f8             	decl   -0x8(%ebp)
  800c10:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800c14:	79 e9                	jns    800bff <memset+0x14>
		*p++ = c;

	return v;
  800c16:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c21:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c24:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800c2d:	eb 16                	jmp    800c45 <memcpy+0x2a>
		*d++ = *s++;
  800c2f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c32:	8d 50 01             	lea    0x1(%eax),%edx
  800c35:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800c38:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c3b:	8d 4a 01             	lea    0x1(%edx),%ecx
  800c3e:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800c41:	8a 12                	mov    (%edx),%dl
  800c43:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800c45:	8b 45 10             	mov    0x10(%ebp),%eax
  800c48:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c4b:	89 55 10             	mov    %edx,0x10(%ebp)
  800c4e:	85 c0                	test   %eax,%eax
  800c50:	75 dd                	jne    800c2f <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800c52:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c55:	c9                   	leave  
  800c56:	c3                   	ret    

00800c57 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800c57:	55                   	push   %ebp
  800c58:	89 e5                	mov    %esp,%ebp
  800c5a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800c63:	8b 45 08             	mov    0x8(%ebp),%eax
  800c66:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800c69:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c6c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c6f:	73 50                	jae    800cc1 <memmove+0x6a>
  800c71:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800c74:	8b 45 10             	mov    0x10(%ebp),%eax
  800c77:	01 d0                	add    %edx,%eax
  800c79:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800c7c:	76 43                	jbe    800cc1 <memmove+0x6a>
		s += n;
  800c7e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c81:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800c84:	8b 45 10             	mov    0x10(%ebp),%eax
  800c87:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800c8a:	eb 10                	jmp    800c9c <memmove+0x45>
			*--d = *--s;
  800c8c:	ff 4d f8             	decl   -0x8(%ebp)
  800c8f:	ff 4d fc             	decl   -0x4(%ebp)
  800c92:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c95:	8a 10                	mov    (%eax),%dl
  800c97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800c9a:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800c9c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c9f:	8d 50 ff             	lea    -0x1(%eax),%edx
  800ca2:	89 55 10             	mov    %edx,0x10(%ebp)
  800ca5:	85 c0                	test   %eax,%eax
  800ca7:	75 e3                	jne    800c8c <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800ca9:	eb 23                	jmp    800cce <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800cab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cae:	8d 50 01             	lea    0x1(%eax),%edx
  800cb1:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800cb4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800cb7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800cba:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800cbd:	8a 12                	mov    (%edx),%dl
  800cbf:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800cc1:	8b 45 10             	mov    0x10(%ebp),%eax
  800cc4:	8d 50 ff             	lea    -0x1(%eax),%edx
  800cc7:	89 55 10             	mov    %edx,0x10(%ebp)
  800cca:	85 c0                	test   %eax,%eax
  800ccc:	75 dd                	jne    800cab <memmove+0x54>
			*d++ = *s++;

	return dst;
  800cce:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cd1:	c9                   	leave  
  800cd2:	c3                   	ret    

00800cd3 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800cd3:	55                   	push   %ebp
  800cd4:	89 e5                	mov    %esp,%ebp
  800cd6:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800cd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800cdf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ce2:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800ce5:	eb 2a                	jmp    800d11 <memcmp+0x3e>
		if (*s1 != *s2)
  800ce7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cea:	8a 10                	mov    (%eax),%dl
  800cec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800cef:	8a 00                	mov    (%eax),%al
  800cf1:	38 c2                	cmp    %al,%dl
  800cf3:	74 16                	je     800d0b <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800cf5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cf8:	8a 00                	mov    (%eax),%al
  800cfa:	0f b6 d0             	movzbl %al,%edx
  800cfd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800d00:	8a 00                	mov    (%eax),%al
  800d02:	0f b6 c0             	movzbl %al,%eax
  800d05:	29 c2                	sub    %eax,%edx
  800d07:	89 d0                	mov    %edx,%eax
  800d09:	eb 18                	jmp    800d23 <memcmp+0x50>
		s1++, s2++;
  800d0b:	ff 45 fc             	incl   -0x4(%ebp)
  800d0e:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800d11:	8b 45 10             	mov    0x10(%ebp),%eax
  800d14:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d17:	89 55 10             	mov    %edx,0x10(%ebp)
  800d1a:	85 c0                	test   %eax,%eax
  800d1c:	75 c9                	jne    800ce7 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800d1e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d23:	c9                   	leave  
  800d24:	c3                   	ret    

00800d25 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800d25:	55                   	push   %ebp
  800d26:	89 e5                	mov    %esp,%ebp
  800d28:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800d2b:	8b 55 08             	mov    0x8(%ebp),%edx
  800d2e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d31:	01 d0                	add    %edx,%eax
  800d33:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800d36:	eb 15                	jmp    800d4d <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800d38:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3b:	8a 00                	mov    (%eax),%al
  800d3d:	0f b6 d0             	movzbl %al,%edx
  800d40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d43:	0f b6 c0             	movzbl %al,%eax
  800d46:	39 c2                	cmp    %eax,%edx
  800d48:	74 0d                	je     800d57 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800d4a:	ff 45 08             	incl   0x8(%ebp)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800d53:	72 e3                	jb     800d38 <memfind+0x13>
  800d55:	eb 01                	jmp    800d58 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800d57:	90                   	nop
	return (void *) s;
  800d58:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d5b:	c9                   	leave  
  800d5c:	c3                   	ret    

00800d5d <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  800d5d:	55                   	push   %ebp
  800d5e:	89 e5                	mov    %esp,%ebp
  800d60:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  800d63:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  800d6a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d71:	eb 03                	jmp    800d76 <strtol+0x19>
		s++;
  800d73:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	8a 00                	mov    (%eax),%al
  800d7b:	3c 20                	cmp    $0x20,%al
  800d7d:	74 f4                	je     800d73 <strtol+0x16>
  800d7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d82:	8a 00                	mov    (%eax),%al
  800d84:	3c 09                	cmp    $0x9,%al
  800d86:	74 eb                	je     800d73 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  800d88:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8b:	8a 00                	mov    (%eax),%al
  800d8d:	3c 2b                	cmp    $0x2b,%al
  800d8f:	75 05                	jne    800d96 <strtol+0x39>
		s++;
  800d91:	ff 45 08             	incl   0x8(%ebp)
  800d94:	eb 13                	jmp    800da9 <strtol+0x4c>
	else if (*s == '-')
  800d96:	8b 45 08             	mov    0x8(%ebp),%eax
  800d99:	8a 00                	mov    (%eax),%al
  800d9b:	3c 2d                	cmp    $0x2d,%al
  800d9d:	75 0a                	jne    800da9 <strtol+0x4c>
		s++, neg = 1;
  800d9f:	ff 45 08             	incl   0x8(%ebp)
  800da2:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  800da9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dad:	74 06                	je     800db5 <strtol+0x58>
  800daf:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800db3:	75 20                	jne    800dd5 <strtol+0x78>
  800db5:	8b 45 08             	mov    0x8(%ebp),%eax
  800db8:	8a 00                	mov    (%eax),%al
  800dba:	3c 30                	cmp    $0x30,%al
  800dbc:	75 17                	jne    800dd5 <strtol+0x78>
  800dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc1:	40                   	inc    %eax
  800dc2:	8a 00                	mov    (%eax),%al
  800dc4:	3c 78                	cmp    $0x78,%al
  800dc6:	75 0d                	jne    800dd5 <strtol+0x78>
		s += 2, base = 16;
  800dc8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd3:	eb 28                	jmp    800dfd <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  800dd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd9:	75 15                	jne    800df0 <strtol+0x93>
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	8a 00                	mov    (%eax),%al
  800de0:	3c 30                	cmp    $0x30,%al
  800de2:	75 0c                	jne    800df0 <strtol+0x93>
		s++, base = 8;
  800de4:	ff 45 08             	incl   0x8(%ebp)
  800de7:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800dee:	eb 0d                	jmp    800dfd <strtol+0xa0>
	else if (base == 0)
  800df0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df4:	75 07                	jne    800dfd <strtol+0xa0>
		base = 10;
  800df6:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  800dfd:	8b 45 08             	mov    0x8(%ebp),%eax
  800e00:	8a 00                	mov    (%eax),%al
  800e02:	3c 2f                	cmp    $0x2f,%al
  800e04:	7e 19                	jle    800e1f <strtol+0xc2>
  800e06:	8b 45 08             	mov    0x8(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	3c 39                	cmp    $0x39,%al
  800e0d:	7f 10                	jg     800e1f <strtol+0xc2>
			dig = *s - '0';
  800e0f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e12:	8a 00                	mov    (%eax),%al
  800e14:	0f be c0             	movsbl %al,%eax
  800e17:	83 e8 30             	sub    $0x30,%eax
  800e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e1d:	eb 42                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  800e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e22:	8a 00                	mov    (%eax),%al
  800e24:	3c 60                	cmp    $0x60,%al
  800e26:	7e 19                	jle    800e41 <strtol+0xe4>
  800e28:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2b:	8a 00                	mov    (%eax),%al
  800e2d:	3c 7a                	cmp    $0x7a,%al
  800e2f:	7f 10                	jg     800e41 <strtol+0xe4>
			dig = *s - 'a' + 10;
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	8a 00                	mov    (%eax),%al
  800e36:	0f be c0             	movsbl %al,%eax
  800e39:	83 e8 57             	sub    $0x57,%eax
  800e3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e3f:	eb 20                	jmp    800e61 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  800e41:	8b 45 08             	mov    0x8(%ebp),%eax
  800e44:	8a 00                	mov    (%eax),%al
  800e46:	3c 40                	cmp    $0x40,%al
  800e48:	7e 39                	jle    800e83 <strtol+0x126>
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	8a 00                	mov    (%eax),%al
  800e4f:	3c 5a                	cmp    $0x5a,%al
  800e51:	7f 30                	jg     800e83 <strtol+0x126>
			dig = *s - 'A' + 10;
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	8a 00                	mov    (%eax),%al
  800e58:	0f be c0             	movsbl %al,%eax
  800e5b:	83 e8 37             	sub    $0x37,%eax
  800e5e:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  800e61:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e64:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e67:	7d 19                	jge    800e82 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  800e69:	ff 45 08             	incl   0x8(%ebp)
  800e6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e6f:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e73:	89 c2                	mov    %eax,%edx
  800e75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e78:	01 d0                	add    %edx,%eax
  800e7a:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  800e7d:	e9 7b ff ff ff       	jmp    800dfd <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  800e82:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  800e83:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e87:	74 08                	je     800e91 <strtol+0x134>
		*endptr = (char *) s;
  800e89:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8c:	8b 55 08             	mov    0x8(%ebp),%edx
  800e8f:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  800e91:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e95:	74 07                	je     800e9e <strtol+0x141>
  800e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e9a:	f7 d8                	neg    %eax
  800e9c:	eb 03                	jmp    800ea1 <strtol+0x144>
  800e9e:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <ltostr>:

void
ltostr(long value, char *str)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  800ea9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  800eb0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  800eb7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ebb:	79 13                	jns    800ed0 <ltostr+0x2d>
	{
		neg = 1;
  800ebd:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  800eca:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  800ecd:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	b9 0a 00 00 00       	mov    $0xa,%ecx
  800ed8:	99                   	cltd   
  800ed9:	f7 f9                	idiv   %ecx
  800edb:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  800ede:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ee1:	8d 50 01             	lea    0x1(%eax),%edx
  800ee4:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800ee7:	89 c2                	mov    %eax,%edx
  800ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eec:	01 d0                	add    %edx,%eax
  800eee:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ef1:	83 c2 30             	add    $0x30,%edx
  800ef4:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  800ef6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800ef9:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800efe:	f7 e9                	imul   %ecx
  800f00:	c1 fa 02             	sar    $0x2,%edx
  800f03:	89 c8                	mov    %ecx,%eax
  800f05:	c1 f8 1f             	sar    $0x1f,%eax
  800f08:	29 c2                	sub    %eax,%edx
  800f0a:	89 d0                	mov    %edx,%eax
  800f0c:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  800f0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  800f12:	b8 67 66 66 66       	mov    $0x66666667,%eax
  800f17:	f7 e9                	imul   %ecx
  800f19:	c1 fa 02             	sar    $0x2,%edx
  800f1c:	89 c8                	mov    %ecx,%eax
  800f1e:	c1 f8 1f             	sar    $0x1f,%eax
  800f21:	29 c2                	sub    %eax,%edx
  800f23:	89 d0                	mov    %edx,%eax
  800f25:	c1 e0 02             	shl    $0x2,%eax
  800f28:	01 d0                	add    %edx,%eax
  800f2a:	01 c0                	add    %eax,%eax
  800f2c:	29 c1                	sub    %eax,%ecx
  800f2e:	89 ca                	mov    %ecx,%edx
  800f30:	85 d2                	test   %edx,%edx
  800f32:	75 9c                	jne    800ed0 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  800f34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  800f3b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3e:	48                   	dec    %eax
  800f3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  800f42:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f46:	74 3d                	je     800f85 <ltostr+0xe2>
		start = 1 ;
  800f48:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  800f4f:	eb 34                	jmp    800f85 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  800f51:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	01 d0                	add    %edx,%eax
  800f59:	8a 00                	mov    (%eax),%al
  800f5b:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  800f5e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f61:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f64:	01 c2                	add    %eax,%edx
  800f66:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  800f69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f6c:	01 c8                	add    %ecx,%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  800f72:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f75:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f78:	01 c2                	add    %eax,%edx
  800f7a:	8a 45 eb             	mov    -0x15(%ebp),%al
  800f7d:	88 02                	mov    %al,(%edx)
		start++ ;
  800f7f:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  800f82:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  800f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800f88:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800f8b:	7c c4                	jl     800f51 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  800f8d:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800f90:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f93:	01 d0                	add    %edx,%eax
  800f95:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  800f98:	90                   	nop
  800f99:	c9                   	leave  
  800f9a:	c3                   	ret    

00800f9b <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  800f9b:	55                   	push   %ebp
  800f9c:	89 e5                	mov    %esp,%ebp
  800f9e:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  800fa1:	ff 75 08             	pushl  0x8(%ebp)
  800fa4:	e8 54 fa ff ff       	call   8009fd <strlen>
  800fa9:	83 c4 04             	add    $0x4,%esp
  800fac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  800faf:	ff 75 0c             	pushl  0xc(%ebp)
  800fb2:	e8 46 fa ff ff       	call   8009fd <strlen>
  800fb7:	83 c4 04             	add    $0x4,%esp
  800fba:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  800fbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  800fc4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800fcb:	eb 17                	jmp    800fe4 <strcconcat+0x49>
		final[s] = str1[s] ;
  800fcd:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd3:	01 c2                	add    %eax,%edx
  800fd5:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	01 c8                	add    %ecx,%eax
  800fdd:	8a 00                	mov    (%eax),%al
  800fdf:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  800fe1:	ff 45 fc             	incl   -0x4(%ebp)
  800fe4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fe7:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800fea:	7c e1                	jl     800fcd <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  800fec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  800ff3:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800ffa:	eb 1f                	jmp    80101b <strcconcat+0x80>
		final[s++] = str2[i] ;
  800ffc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fff:	8d 50 01             	lea    0x1(%eax),%edx
  801002:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801005:	89 c2                	mov    %eax,%edx
  801007:	8b 45 10             	mov    0x10(%ebp),%eax
  80100a:	01 c2                	add    %eax,%edx
  80100c:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80100f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801012:	01 c8                	add    %ecx,%eax
  801014:	8a 00                	mov    (%eax),%al
  801016:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801018:	ff 45 f8             	incl   -0x8(%ebp)
  80101b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801021:	7c d9                	jl     800ffc <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801023:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801026:	8b 45 10             	mov    0x10(%ebp),%eax
  801029:	01 d0                	add    %edx,%eax
  80102b:	c6 00 00             	movb   $0x0,(%eax)
}
  80102e:	90                   	nop
  80102f:	c9                   	leave  
  801030:	c3                   	ret    

00801031 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801031:	55                   	push   %ebp
  801032:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801034:	8b 45 14             	mov    0x14(%ebp),%eax
  801037:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80103d:	8b 45 14             	mov    0x14(%ebp),%eax
  801040:	8b 00                	mov    (%eax),%eax
  801042:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801049:	8b 45 10             	mov    0x10(%ebp),%eax
  80104c:	01 d0                	add    %edx,%eax
  80104e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801054:	eb 0c                	jmp    801062 <strsplit+0x31>
			*string++ = 0;
  801056:	8b 45 08             	mov    0x8(%ebp),%eax
  801059:	8d 50 01             	lea    0x1(%eax),%edx
  80105c:	89 55 08             	mov    %edx,0x8(%ebp)
  80105f:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801062:	8b 45 08             	mov    0x8(%ebp),%eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	84 c0                	test   %al,%al
  801069:	74 18                	je     801083 <strsplit+0x52>
  80106b:	8b 45 08             	mov    0x8(%ebp),%eax
  80106e:	8a 00                	mov    (%eax),%al
  801070:	0f be c0             	movsbl %al,%eax
  801073:	50                   	push   %eax
  801074:	ff 75 0c             	pushl  0xc(%ebp)
  801077:	e8 13 fb ff ff       	call   800b8f <strchr>
  80107c:	83 c4 08             	add    $0x8,%esp
  80107f:	85 c0                	test   %eax,%eax
  801081:	75 d3                	jne    801056 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801083:	8b 45 08             	mov    0x8(%ebp),%eax
  801086:	8a 00                	mov    (%eax),%al
  801088:	84 c0                	test   %al,%al
  80108a:	74 5a                	je     8010e6 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80108c:	8b 45 14             	mov    0x14(%ebp),%eax
  80108f:	8b 00                	mov    (%eax),%eax
  801091:	83 f8 0f             	cmp    $0xf,%eax
  801094:	75 07                	jne    80109d <strsplit+0x6c>
		{
			return 0;
  801096:	b8 00 00 00 00       	mov    $0x0,%eax
  80109b:	eb 66                	jmp    801103 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  80109d:	8b 45 14             	mov    0x14(%ebp),%eax
  8010a0:	8b 00                	mov    (%eax),%eax
  8010a2:	8d 48 01             	lea    0x1(%eax),%ecx
  8010a5:	8b 55 14             	mov    0x14(%ebp),%edx
  8010a8:	89 0a                	mov    %ecx,(%edx)
  8010aa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b4:	01 c2                	add    %eax,%edx
  8010b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b9:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010bb:	eb 03                	jmp    8010c0 <strsplit+0x8f>
			string++;
  8010bd:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8010c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c3:	8a 00                	mov    (%eax),%al
  8010c5:	84 c0                	test   %al,%al
  8010c7:	74 8b                	je     801054 <strsplit+0x23>
  8010c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cc:	8a 00                	mov    (%eax),%al
  8010ce:	0f be c0             	movsbl %al,%eax
  8010d1:	50                   	push   %eax
  8010d2:	ff 75 0c             	pushl  0xc(%ebp)
  8010d5:	e8 b5 fa ff ff       	call   800b8f <strchr>
  8010da:	83 c4 08             	add    $0x8,%esp
  8010dd:	85 c0                	test   %eax,%eax
  8010df:	74 dc                	je     8010bd <strsplit+0x8c>
			string++;
	}
  8010e1:	e9 6e ff ff ff       	jmp    801054 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8010e6:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8010e7:	8b 45 14             	mov    0x14(%ebp),%eax
  8010ea:	8b 00                	mov    (%eax),%eax
  8010ec:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	01 d0                	add    %edx,%eax
  8010f8:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8010fe:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801103:	c9                   	leave  
  801104:	c3                   	ret    

00801105 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801105:	55                   	push   %ebp
  801106:	89 e5                	mov    %esp,%ebp
  801108:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  80110b:	a1 04 40 80 00       	mov    0x804004,%eax
  801110:	85 c0                	test   %eax,%eax
  801112:	74 1f                	je     801133 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801114:	e8 1d 00 00 00       	call   801136 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801119:	83 ec 0c             	sub    $0xc,%esp
  80111c:	68 10 38 80 00       	push   $0x803810
  801121:	e8 55 f2 ff ff       	call   80037b <cprintf>
  801126:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801129:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  801130:	00 00 00 
	}
}
  801133:	90                   	nop
  801134:	c9                   	leave  
  801135:	c3                   	ret    

00801136 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801136:	55                   	push   %ebp
  801137:	89 e5                	mov    %esp,%ebp
  801139:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  80113c:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  801143:	00 00 00 
  801146:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  80114d:	00 00 00 
  801150:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  801157:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  80115a:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801161:	00 00 00 
  801164:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80116b:	00 00 00 
  80116e:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801175:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801178:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  80117f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801182:	c1 e8 0c             	shr    $0xc,%eax
  801185:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  80118a:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801191:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801194:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801199:	2d 00 10 00 00       	sub    $0x1000,%eax
  80119e:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  8011a3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  8011aa:	a1 20 41 80 00       	mov    0x804120,%eax
  8011af:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  8011b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  8011b6:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  8011bd:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8011c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8011c3:	01 d0                	add    %edx,%eax
  8011c5:	48                   	dec    %eax
  8011c6:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8011c9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011cc:	ba 00 00 00 00       	mov    $0x0,%edx
  8011d1:	f7 75 e4             	divl   -0x1c(%ebp)
  8011d4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8011d7:	29 d0                	sub    %edx,%eax
  8011d9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  8011dc:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  8011e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8011e6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8011eb:	2d 00 10 00 00       	sub    $0x1000,%eax
  8011f0:	83 ec 04             	sub    $0x4,%esp
  8011f3:	6a 07                	push   $0x7
  8011f5:	ff 75 e8             	pushl  -0x18(%ebp)
  8011f8:	50                   	push   %eax
  8011f9:	e8 3d 06 00 00       	call   80183b <sys_allocate_chunk>
  8011fe:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801201:	a1 20 41 80 00       	mov    0x804120,%eax
  801206:	83 ec 0c             	sub    $0xc,%esp
  801209:	50                   	push   %eax
  80120a:	e8 b2 0c 00 00       	call   801ec1 <initialize_MemBlocksList>
  80120f:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801212:	a1 4c 41 80 00       	mov    0x80414c,%eax
  801217:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  80121a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80121e:	0f 84 f3 00 00 00    	je     801317 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801224:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801228:	75 14                	jne    80123e <initialize_dyn_block_system+0x108>
  80122a:	83 ec 04             	sub    $0x4,%esp
  80122d:	68 35 38 80 00       	push   $0x803835
  801232:	6a 36                	push   $0x36
  801234:	68 53 38 80 00       	push   $0x803853
  801239:	e8 f5 1c 00 00       	call   802f33 <_panic>
  80123e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801241:	8b 00                	mov    (%eax),%eax
  801243:	85 c0                	test   %eax,%eax
  801245:	74 10                	je     801257 <initialize_dyn_block_system+0x121>
  801247:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80124a:	8b 00                	mov    (%eax),%eax
  80124c:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80124f:	8b 52 04             	mov    0x4(%edx),%edx
  801252:	89 50 04             	mov    %edx,0x4(%eax)
  801255:	eb 0b                	jmp    801262 <initialize_dyn_block_system+0x12c>
  801257:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80125a:	8b 40 04             	mov    0x4(%eax),%eax
  80125d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801262:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801265:	8b 40 04             	mov    0x4(%eax),%eax
  801268:	85 c0                	test   %eax,%eax
  80126a:	74 0f                	je     80127b <initialize_dyn_block_system+0x145>
  80126c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80126f:	8b 40 04             	mov    0x4(%eax),%eax
  801272:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801275:	8b 12                	mov    (%edx),%edx
  801277:	89 10                	mov    %edx,(%eax)
  801279:	eb 0a                	jmp    801285 <initialize_dyn_block_system+0x14f>
  80127b:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80127e:	8b 00                	mov    (%eax),%eax
  801280:	a3 48 41 80 00       	mov    %eax,0x804148
  801285:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801288:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80128e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801291:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801298:	a1 54 41 80 00       	mov    0x804154,%eax
  80129d:	48                   	dec    %eax
  80129e:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  8012a3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012a6:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  8012ad:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012b0:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  8012b7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8012bb:	75 14                	jne    8012d1 <initialize_dyn_block_system+0x19b>
  8012bd:	83 ec 04             	sub    $0x4,%esp
  8012c0:	68 60 38 80 00       	push   $0x803860
  8012c5:	6a 3e                	push   $0x3e
  8012c7:	68 53 38 80 00       	push   $0x803853
  8012cc:	e8 62 1c 00 00       	call   802f33 <_panic>
  8012d1:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8012d7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012da:	89 10                	mov    %edx,(%eax)
  8012dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012df:	8b 00                	mov    (%eax),%eax
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	74 0d                	je     8012f2 <initialize_dyn_block_system+0x1bc>
  8012e5:	a1 38 41 80 00       	mov    0x804138,%eax
  8012ea:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8012ed:	89 50 04             	mov    %edx,0x4(%eax)
  8012f0:	eb 08                	jmp    8012fa <initialize_dyn_block_system+0x1c4>
  8012f2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012f5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8012fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8012fd:	a3 38 41 80 00       	mov    %eax,0x804138
  801302:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801305:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80130c:	a1 44 41 80 00       	mov    0x804144,%eax
  801311:	40                   	inc    %eax
  801312:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  801317:	90                   	nop
  801318:	c9                   	leave  
  801319:	c3                   	ret    

0080131a <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  80131a:	55                   	push   %ebp
  80131b:	89 e5                	mov    %esp,%ebp
  80131d:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801320:	e8 e0 fd ff ff       	call   801105 <InitializeUHeap>
		if (size == 0) return NULL ;
  801325:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801329:	75 07                	jne    801332 <malloc+0x18>
  80132b:	b8 00 00 00 00       	mov    $0x0,%eax
  801330:	eb 7f                	jmp    8013b1 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801332:	e8 d2 08 00 00       	call   801c09 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801337:	85 c0                	test   %eax,%eax
  801339:	74 71                	je     8013ac <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  80133b:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801342:	8b 55 08             	mov    0x8(%ebp),%edx
  801345:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801348:	01 d0                	add    %edx,%eax
  80134a:	48                   	dec    %eax
  80134b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80134e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801351:	ba 00 00 00 00       	mov    $0x0,%edx
  801356:	f7 75 f4             	divl   -0xc(%ebp)
  801359:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80135c:	29 d0                	sub    %edx,%eax
  80135e:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801361:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801368:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  80136f:	76 07                	jbe    801378 <malloc+0x5e>
					return NULL ;
  801371:	b8 00 00 00 00       	mov    $0x0,%eax
  801376:	eb 39                	jmp    8013b1 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801378:	83 ec 0c             	sub    $0xc,%esp
  80137b:	ff 75 08             	pushl  0x8(%ebp)
  80137e:	e8 e6 0d 00 00       	call   802169 <alloc_block_FF>
  801383:	83 c4 10             	add    $0x10,%esp
  801386:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801389:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80138d:	74 16                	je     8013a5 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  80138f:	83 ec 0c             	sub    $0xc,%esp
  801392:	ff 75 ec             	pushl  -0x14(%ebp)
  801395:	e8 37 0c 00 00       	call   801fd1 <insert_sorted_allocList>
  80139a:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  80139d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8013a0:	8b 40 08             	mov    0x8(%eax),%eax
  8013a3:	eb 0c                	jmp    8013b1 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8013a5:	b8 00 00 00 00       	mov    $0x0,%eax
  8013aa:	eb 05                	jmp    8013b1 <malloc+0x97>
				}
		}
	return 0;
  8013ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8013b1:	c9                   	leave  
  8013b2:	c3                   	ret    

008013b3 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  8013b3:	55                   	push   %ebp
  8013b4:	89 e5                	mov    %esp,%ebp
  8013b6:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  8013b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  8013bf:	83 ec 08             	sub    $0x8,%esp
  8013c2:	ff 75 f4             	pushl  -0xc(%ebp)
  8013c5:	68 40 40 80 00       	push   $0x804040
  8013ca:	e8 cf 0b 00 00       	call   801f9e <find_block>
  8013cf:	83 c4 10             	add    $0x10,%esp
  8013d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  8013d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8013db:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  8013de:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8013e1:	8b 40 08             	mov    0x8(%eax),%eax
  8013e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  8013e7:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013eb:	0f 84 a1 00 00 00    	je     801492 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  8013f1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013f5:	75 17                	jne    80140e <free+0x5b>
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	68 35 38 80 00       	push   $0x803835
  8013ff:	68 80 00 00 00       	push   $0x80
  801404:	68 53 38 80 00       	push   $0x803853
  801409:	e8 25 1b 00 00       	call   802f33 <_panic>
  80140e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801411:	8b 00                	mov    (%eax),%eax
  801413:	85 c0                	test   %eax,%eax
  801415:	74 10                	je     801427 <free+0x74>
  801417:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80141a:	8b 00                	mov    (%eax),%eax
  80141c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  80141f:	8b 52 04             	mov    0x4(%edx),%edx
  801422:	89 50 04             	mov    %edx,0x4(%eax)
  801425:	eb 0b                	jmp    801432 <free+0x7f>
  801427:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80142a:	8b 40 04             	mov    0x4(%eax),%eax
  80142d:	a3 44 40 80 00       	mov    %eax,0x804044
  801432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801435:	8b 40 04             	mov    0x4(%eax),%eax
  801438:	85 c0                	test   %eax,%eax
  80143a:	74 0f                	je     80144b <free+0x98>
  80143c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80143f:	8b 40 04             	mov    0x4(%eax),%eax
  801442:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801445:	8b 12                	mov    (%edx),%edx
  801447:	89 10                	mov    %edx,(%eax)
  801449:	eb 0a                	jmp    801455 <free+0xa2>
  80144b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80144e:	8b 00                	mov    (%eax),%eax
  801450:	a3 40 40 80 00       	mov    %eax,0x804040
  801455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80145e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801461:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801468:	a1 4c 40 80 00       	mov    0x80404c,%eax
  80146d:	48                   	dec    %eax
  80146e:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  801473:	83 ec 0c             	sub    $0xc,%esp
  801476:	ff 75 f0             	pushl  -0x10(%ebp)
  801479:	e8 29 12 00 00       	call   8026a7 <insert_sorted_with_merge_freeList>
  80147e:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801481:	83 ec 08             	sub    $0x8,%esp
  801484:	ff 75 ec             	pushl  -0x14(%ebp)
  801487:	ff 75 e8             	pushl  -0x18(%ebp)
  80148a:	e8 74 03 00 00       	call   801803 <sys_free_user_mem>
  80148f:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801492:	90                   	nop
  801493:	c9                   	leave  
  801494:	c3                   	ret    

00801495 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801495:	55                   	push   %ebp
  801496:	89 e5                	mov    %esp,%ebp
  801498:	83 ec 38             	sub    $0x38,%esp
  80149b:	8b 45 10             	mov    0x10(%ebp),%eax
  80149e:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8014a1:	e8 5f fc ff ff       	call   801105 <InitializeUHeap>
	if (size == 0) return NULL ;
  8014a6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014aa:	75 0a                	jne    8014b6 <smalloc+0x21>
  8014ac:	b8 00 00 00 00       	mov    $0x0,%eax
  8014b1:	e9 b2 00 00 00       	jmp    801568 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  8014b6:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  8014bd:	76 0a                	jbe    8014c9 <smalloc+0x34>
		return NULL;
  8014bf:	b8 00 00 00 00       	mov    $0x0,%eax
  8014c4:	e9 9f 00 00 00       	jmp    801568 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8014c9:	e8 3b 07 00 00       	call   801c09 <sys_isUHeapPlacementStrategyFIRSTFIT>
  8014ce:	85 c0                	test   %eax,%eax
  8014d0:	0f 84 8d 00 00 00    	je     801563 <smalloc+0xce>
	struct MemBlock *b = NULL;
  8014d6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  8014dd:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  8014e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8014ea:	01 d0                	add    %edx,%eax
  8014ec:	48                   	dec    %eax
  8014ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
  8014f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8014f8:	f7 75 f0             	divl   -0x10(%ebp)
  8014fb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014fe:	29 d0                	sub    %edx,%eax
  801500:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801503:	83 ec 0c             	sub    $0xc,%esp
  801506:	ff 75 e8             	pushl  -0x18(%ebp)
  801509:	e8 5b 0c 00 00       	call   802169 <alloc_block_FF>
  80150e:	83 c4 10             	add    $0x10,%esp
  801511:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801514:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801518:	75 07                	jne    801521 <smalloc+0x8c>
			return NULL;
  80151a:	b8 00 00 00 00       	mov    $0x0,%eax
  80151f:	eb 47                	jmp    801568 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801521:	83 ec 0c             	sub    $0xc,%esp
  801524:	ff 75 f4             	pushl  -0xc(%ebp)
  801527:	e8 a5 0a 00 00       	call   801fd1 <insert_sorted_allocList>
  80152c:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  80152f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801532:	8b 40 08             	mov    0x8(%eax),%eax
  801535:	89 c2                	mov    %eax,%edx
  801537:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80153b:	52                   	push   %edx
  80153c:	50                   	push   %eax
  80153d:	ff 75 0c             	pushl  0xc(%ebp)
  801540:	ff 75 08             	pushl  0x8(%ebp)
  801543:	e8 46 04 00 00       	call   80198e <sys_createSharedObject>
  801548:	83 c4 10             	add    $0x10,%esp
  80154b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  80154e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801552:	78 08                	js     80155c <smalloc+0xc7>
		return (void *)b->sva;
  801554:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801557:	8b 40 08             	mov    0x8(%eax),%eax
  80155a:	eb 0c                	jmp    801568 <smalloc+0xd3>
		}else{
		return NULL;
  80155c:	b8 00 00 00 00       	mov    $0x0,%eax
  801561:	eb 05                	jmp    801568 <smalloc+0xd3>
			}

	}return NULL;
  801563:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801568:	c9                   	leave  
  801569:	c3                   	ret    

0080156a <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80156a:	55                   	push   %ebp
  80156b:	89 e5                	mov    %esp,%ebp
  80156d:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801570:	e8 90 fb ff ff       	call   801105 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801575:	e8 8f 06 00 00       	call   801c09 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80157a:	85 c0                	test   %eax,%eax
  80157c:	0f 84 ad 00 00 00    	je     80162f <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801582:	83 ec 08             	sub    $0x8,%esp
  801585:	ff 75 0c             	pushl  0xc(%ebp)
  801588:	ff 75 08             	pushl  0x8(%ebp)
  80158b:	e8 28 04 00 00       	call   8019b8 <sys_getSizeOfSharedObject>
  801590:	83 c4 10             	add    $0x10,%esp
  801593:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801596:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80159a:	79 0a                	jns    8015a6 <sget+0x3c>
    {
    	return NULL;
  80159c:	b8 00 00 00 00       	mov    $0x0,%eax
  8015a1:	e9 8e 00 00 00       	jmp    801634 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  8015a6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  8015ad:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  8015b4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8015ba:	01 d0                	add    %edx,%eax
  8015bc:	48                   	dec    %eax
  8015bd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8015c0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015c3:	ba 00 00 00 00       	mov    $0x0,%edx
  8015c8:	f7 75 ec             	divl   -0x14(%ebp)
  8015cb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8015ce:	29 d0                	sub    %edx,%eax
  8015d0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8015d3:	83 ec 0c             	sub    $0xc,%esp
  8015d6:	ff 75 e4             	pushl  -0x1c(%ebp)
  8015d9:	e8 8b 0b 00 00       	call   802169 <alloc_block_FF>
  8015de:	83 c4 10             	add    $0x10,%esp
  8015e1:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8015e4:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8015e8:	75 07                	jne    8015f1 <sget+0x87>
				return NULL;
  8015ea:	b8 00 00 00 00       	mov    $0x0,%eax
  8015ef:	eb 43                	jmp    801634 <sget+0xca>
			}
			insert_sorted_allocList(b);
  8015f1:	83 ec 0c             	sub    $0xc,%esp
  8015f4:	ff 75 f0             	pushl  -0x10(%ebp)
  8015f7:	e8 d5 09 00 00       	call   801fd1 <insert_sorted_allocList>
  8015fc:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8015ff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801602:	8b 40 08             	mov    0x8(%eax),%eax
  801605:	83 ec 04             	sub    $0x4,%esp
  801608:	50                   	push   %eax
  801609:	ff 75 0c             	pushl  0xc(%ebp)
  80160c:	ff 75 08             	pushl  0x8(%ebp)
  80160f:	e8 c1 03 00 00       	call   8019d5 <sys_getSharedObject>
  801614:	83 c4 10             	add    $0x10,%esp
  801617:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  80161a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80161e:	78 08                	js     801628 <sget+0xbe>
			return (void *)b->sva;
  801620:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801623:	8b 40 08             	mov    0x8(%eax),%eax
  801626:	eb 0c                	jmp    801634 <sget+0xca>
			}else{
			return NULL;
  801628:	b8 00 00 00 00       	mov    $0x0,%eax
  80162d:	eb 05                	jmp    801634 <sget+0xca>
			}
    }}return NULL;
  80162f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801634:	c9                   	leave  
  801635:	c3                   	ret    

00801636 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801636:	55                   	push   %ebp
  801637:	89 e5                	mov    %esp,%ebp
  801639:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80163c:	e8 c4 fa ff ff       	call   801105 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801641:	83 ec 04             	sub    $0x4,%esp
  801644:	68 84 38 80 00       	push   $0x803884
  801649:	68 03 01 00 00       	push   $0x103
  80164e:	68 53 38 80 00       	push   $0x803853
  801653:	e8 db 18 00 00       	call   802f33 <_panic>

00801658 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801658:	55                   	push   %ebp
  801659:	89 e5                	mov    %esp,%ebp
  80165b:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80165e:	83 ec 04             	sub    $0x4,%esp
  801661:	68 ac 38 80 00       	push   $0x8038ac
  801666:	68 17 01 00 00       	push   $0x117
  80166b:	68 53 38 80 00       	push   $0x803853
  801670:	e8 be 18 00 00       	call   802f33 <_panic>

00801675 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801675:	55                   	push   %ebp
  801676:	89 e5                	mov    %esp,%ebp
  801678:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80167b:	83 ec 04             	sub    $0x4,%esp
  80167e:	68 d0 38 80 00       	push   $0x8038d0
  801683:	68 22 01 00 00       	push   $0x122
  801688:	68 53 38 80 00       	push   $0x803853
  80168d:	e8 a1 18 00 00       	call   802f33 <_panic>

00801692 <shrink>:

}
void shrink(uint32 newSize)
{
  801692:	55                   	push   %ebp
  801693:	89 e5                	mov    %esp,%ebp
  801695:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801698:	83 ec 04             	sub    $0x4,%esp
  80169b:	68 d0 38 80 00       	push   $0x8038d0
  8016a0:	68 27 01 00 00       	push   $0x127
  8016a5:	68 53 38 80 00       	push   $0x803853
  8016aa:	e8 84 18 00 00       	call   802f33 <_panic>

008016af <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  8016b5:	83 ec 04             	sub    $0x4,%esp
  8016b8:	68 d0 38 80 00       	push   $0x8038d0
  8016bd:	68 2c 01 00 00       	push   $0x12c
  8016c2:	68 53 38 80 00       	push   $0x803853
  8016c7:	e8 67 18 00 00       	call   802f33 <_panic>

008016cc <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	57                   	push   %edi
  8016d0:	56                   	push   %esi
  8016d1:	53                   	push   %ebx
  8016d2:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8016d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8016de:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8016e1:	8b 7d 18             	mov    0x18(%ebp),%edi
  8016e4:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8016e7:	cd 30                	int    $0x30
  8016e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8016ec:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8016ef:	83 c4 10             	add    $0x10,%esp
  8016f2:	5b                   	pop    %ebx
  8016f3:	5e                   	pop    %esi
  8016f4:	5f                   	pop    %edi
  8016f5:	5d                   	pop    %ebp
  8016f6:	c3                   	ret    

008016f7 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8016f7:	55                   	push   %ebp
  8016f8:	89 e5                	mov    %esp,%ebp
  8016fa:	83 ec 04             	sub    $0x4,%esp
  8016fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801700:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801703:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801707:	8b 45 08             	mov    0x8(%ebp),%eax
  80170a:	6a 00                	push   $0x0
  80170c:	6a 00                	push   $0x0
  80170e:	52                   	push   %edx
  80170f:	ff 75 0c             	pushl  0xc(%ebp)
  801712:	50                   	push   %eax
  801713:	6a 00                	push   $0x0
  801715:	e8 b2 ff ff ff       	call   8016cc <syscall>
  80171a:	83 c4 18             	add    $0x18,%esp
}
  80171d:	90                   	nop
  80171e:	c9                   	leave  
  80171f:	c3                   	ret    

00801720 <sys_cgetc>:

int
sys_cgetc(void)
{
  801720:	55                   	push   %ebp
  801721:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801723:	6a 00                	push   $0x0
  801725:	6a 00                	push   $0x0
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 01                	push   $0x1
  80172f:	e8 98 ff ff ff       	call   8016cc <syscall>
  801734:	83 c4 18             	add    $0x18,%esp
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80173c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80173f:	8b 45 08             	mov    0x8(%ebp),%eax
  801742:	6a 00                	push   $0x0
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	52                   	push   %edx
  801749:	50                   	push   %eax
  80174a:	6a 05                	push   $0x5
  80174c:	e8 7b ff ff ff       	call   8016cc <syscall>
  801751:	83 c4 18             	add    $0x18,%esp
}
  801754:	c9                   	leave  
  801755:	c3                   	ret    

00801756 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801756:	55                   	push   %ebp
  801757:	89 e5                	mov    %esp,%ebp
  801759:	56                   	push   %esi
  80175a:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80175b:	8b 75 18             	mov    0x18(%ebp),%esi
  80175e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801761:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801764:	8b 55 0c             	mov    0xc(%ebp),%edx
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	56                   	push   %esi
  80176b:	53                   	push   %ebx
  80176c:	51                   	push   %ecx
  80176d:	52                   	push   %edx
  80176e:	50                   	push   %eax
  80176f:	6a 06                	push   $0x6
  801771:	e8 56 ff ff ff       	call   8016cc <syscall>
  801776:	83 c4 18             	add    $0x18,%esp
}
  801779:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80177c:	5b                   	pop    %ebx
  80177d:	5e                   	pop    %esi
  80177e:	5d                   	pop    %ebp
  80177f:	c3                   	ret    

00801780 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801780:	55                   	push   %ebp
  801781:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801783:	8b 55 0c             	mov    0xc(%ebp),%edx
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	6a 00                	push   $0x0
  80178b:	6a 00                	push   $0x0
  80178d:	6a 00                	push   $0x0
  80178f:	52                   	push   %edx
  801790:	50                   	push   %eax
  801791:	6a 07                	push   $0x7
  801793:	e8 34 ff ff ff       	call   8016cc <syscall>
  801798:	83 c4 18             	add    $0x18,%esp
}
  80179b:	c9                   	leave  
  80179c:	c3                   	ret    

0080179d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80179d:	55                   	push   %ebp
  80179e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	6a 00                	push   $0x0
  8017a6:	ff 75 0c             	pushl  0xc(%ebp)
  8017a9:	ff 75 08             	pushl  0x8(%ebp)
  8017ac:	6a 08                	push   $0x8
  8017ae:	e8 19 ff ff ff       	call   8016cc <syscall>
  8017b3:	83 c4 18             	add    $0x18,%esp
}
  8017b6:	c9                   	leave  
  8017b7:	c3                   	ret    

008017b8 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8017b8:	55                   	push   %ebp
  8017b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8017bb:	6a 00                	push   $0x0
  8017bd:	6a 00                	push   $0x0
  8017bf:	6a 00                	push   $0x0
  8017c1:	6a 00                	push   $0x0
  8017c3:	6a 00                	push   $0x0
  8017c5:	6a 09                	push   $0x9
  8017c7:	e8 00 ff ff ff       	call   8016cc <syscall>
  8017cc:	83 c4 18             	add    $0x18,%esp
}
  8017cf:	c9                   	leave  
  8017d0:	c3                   	ret    

008017d1 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8017d1:	55                   	push   %ebp
  8017d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8017d4:	6a 00                	push   $0x0
  8017d6:	6a 00                	push   $0x0
  8017d8:	6a 00                	push   $0x0
  8017da:	6a 00                	push   $0x0
  8017dc:	6a 00                	push   $0x0
  8017de:	6a 0a                	push   $0xa
  8017e0:	e8 e7 fe ff ff       	call   8016cc <syscall>
  8017e5:	83 c4 18             	add    $0x18,%esp
}
  8017e8:	c9                   	leave  
  8017e9:	c3                   	ret    

008017ea <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8017ea:	55                   	push   %ebp
  8017eb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	6a 00                	push   $0x0
  8017f3:	6a 00                	push   $0x0
  8017f5:	6a 00                	push   $0x0
  8017f7:	6a 0b                	push   $0xb
  8017f9:	e8 ce fe ff ff       	call   8016cc <syscall>
  8017fe:	83 c4 18             	add    $0x18,%esp
}
  801801:	c9                   	leave  
  801802:	c3                   	ret    

00801803 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801803:	55                   	push   %ebp
  801804:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	6a 00                	push   $0x0
  80180c:	ff 75 0c             	pushl  0xc(%ebp)
  80180f:	ff 75 08             	pushl  0x8(%ebp)
  801812:	6a 0f                	push   $0xf
  801814:	e8 b3 fe ff ff       	call   8016cc <syscall>
  801819:	83 c4 18             	add    $0x18,%esp
	return;
  80181c:	90                   	nop
}
  80181d:	c9                   	leave  
  80181e:	c3                   	ret    

0080181f <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80181f:	55                   	push   %ebp
  801820:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	ff 75 0c             	pushl  0xc(%ebp)
  80182b:	ff 75 08             	pushl  0x8(%ebp)
  80182e:	6a 10                	push   $0x10
  801830:	e8 97 fe ff ff       	call   8016cc <syscall>
  801835:	83 c4 18             	add    $0x18,%esp
	return ;
  801838:	90                   	nop
}
  801839:	c9                   	leave  
  80183a:	c3                   	ret    

0080183b <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80183b:	55                   	push   %ebp
  80183c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80183e:	6a 00                	push   $0x0
  801840:	6a 00                	push   $0x0
  801842:	ff 75 10             	pushl  0x10(%ebp)
  801845:	ff 75 0c             	pushl  0xc(%ebp)
  801848:	ff 75 08             	pushl  0x8(%ebp)
  80184b:	6a 11                	push   $0x11
  80184d:	e8 7a fe ff ff       	call   8016cc <syscall>
  801852:	83 c4 18             	add    $0x18,%esp
	return ;
  801855:	90                   	nop
}
  801856:	c9                   	leave  
  801857:	c3                   	ret    

00801858 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801858:	55                   	push   %ebp
  801859:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80185b:	6a 00                	push   $0x0
  80185d:	6a 00                	push   $0x0
  80185f:	6a 00                	push   $0x0
  801861:	6a 00                	push   $0x0
  801863:	6a 00                	push   $0x0
  801865:	6a 0c                	push   $0xc
  801867:	e8 60 fe ff ff       	call   8016cc <syscall>
  80186c:	83 c4 18             	add    $0x18,%esp
}
  80186f:	c9                   	leave  
  801870:	c3                   	ret    

00801871 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801871:	55                   	push   %ebp
  801872:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	ff 75 08             	pushl  0x8(%ebp)
  80187f:	6a 0d                	push   $0xd
  801881:	e8 46 fe ff ff       	call   8016cc <syscall>
  801886:	83 c4 18             	add    $0x18,%esp
}
  801889:	c9                   	leave  
  80188a:	c3                   	ret    

0080188b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80188b:	55                   	push   %ebp
  80188c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80188e:	6a 00                	push   $0x0
  801890:	6a 00                	push   $0x0
  801892:	6a 00                	push   $0x0
  801894:	6a 00                	push   $0x0
  801896:	6a 00                	push   $0x0
  801898:	6a 0e                	push   $0xe
  80189a:	e8 2d fe ff ff       	call   8016cc <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	90                   	nop
  8018a3:	c9                   	leave  
  8018a4:	c3                   	ret    

008018a5 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8018a5:	55                   	push   %ebp
  8018a6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	6a 00                	push   $0x0
  8018b2:	6a 13                	push   $0x13
  8018b4:	e8 13 fe ff ff       	call   8016cc <syscall>
  8018b9:	83 c4 18             	add    $0x18,%esp
}
  8018bc:	90                   	nop
  8018bd:	c9                   	leave  
  8018be:	c3                   	ret    

008018bf <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8018bf:	55                   	push   %ebp
  8018c0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	6a 14                	push   $0x14
  8018ce:	e8 f9 fd ff ff       	call   8016cc <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	90                   	nop
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_cputc>:


void
sys_cputc(const char c)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 04             	sub    $0x4,%esp
  8018df:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e2:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8018e5:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	50                   	push   %eax
  8018f2:	6a 15                	push   $0x15
  8018f4:	e8 d3 fd ff ff       	call   8016cc <syscall>
  8018f9:	83 c4 18             	add    $0x18,%esp
}
  8018fc:	90                   	nop
  8018fd:	c9                   	leave  
  8018fe:	c3                   	ret    

008018ff <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8018ff:	55                   	push   %ebp
  801900:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801902:	6a 00                	push   $0x0
  801904:	6a 00                	push   $0x0
  801906:	6a 00                	push   $0x0
  801908:	6a 00                	push   $0x0
  80190a:	6a 00                	push   $0x0
  80190c:	6a 16                	push   $0x16
  80190e:	e8 b9 fd ff ff       	call   8016cc <syscall>
  801913:	83 c4 18             	add    $0x18,%esp
}
  801916:	90                   	nop
  801917:	c9                   	leave  
  801918:	c3                   	ret    

00801919 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801919:	55                   	push   %ebp
  80191a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  80191c:	8b 45 08             	mov    0x8(%ebp),%eax
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	ff 75 0c             	pushl  0xc(%ebp)
  801928:	50                   	push   %eax
  801929:	6a 17                	push   $0x17
  80192b:	e8 9c fd ff ff       	call   8016cc <syscall>
  801930:	83 c4 18             	add    $0x18,%esp
}
  801933:	c9                   	leave  
  801934:	c3                   	ret    

00801935 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80193b:	8b 45 08             	mov    0x8(%ebp),%eax
  80193e:	6a 00                	push   $0x0
  801940:	6a 00                	push   $0x0
  801942:	6a 00                	push   $0x0
  801944:	52                   	push   %edx
  801945:	50                   	push   %eax
  801946:	6a 1a                	push   $0x1a
  801948:	e8 7f fd ff ff       	call   8016cc <syscall>
  80194d:	83 c4 18             	add    $0x18,%esp
}
  801950:	c9                   	leave  
  801951:	c3                   	ret    

00801952 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801955:	8b 55 0c             	mov    0xc(%ebp),%edx
  801958:	8b 45 08             	mov    0x8(%ebp),%eax
  80195b:	6a 00                	push   $0x0
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	52                   	push   %edx
  801962:	50                   	push   %eax
  801963:	6a 18                	push   $0x18
  801965:	e8 62 fd ff ff       	call   8016cc <syscall>
  80196a:	83 c4 18             	add    $0x18,%esp
}
  80196d:	90                   	nop
  80196e:	c9                   	leave  
  80196f:	c3                   	ret    

00801970 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801970:	55                   	push   %ebp
  801971:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801973:	8b 55 0c             	mov    0xc(%ebp),%edx
  801976:	8b 45 08             	mov    0x8(%ebp),%eax
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	52                   	push   %edx
  801980:	50                   	push   %eax
  801981:	6a 19                	push   $0x19
  801983:	e8 44 fd ff ff       	call   8016cc <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	90                   	nop
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
  801991:	83 ec 04             	sub    $0x4,%esp
  801994:	8b 45 10             	mov    0x10(%ebp),%eax
  801997:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80199a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80199d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a4:	6a 00                	push   $0x0
  8019a6:	51                   	push   %ecx
  8019a7:	52                   	push   %edx
  8019a8:	ff 75 0c             	pushl  0xc(%ebp)
  8019ab:	50                   	push   %eax
  8019ac:	6a 1b                	push   $0x1b
  8019ae:	e8 19 fd ff ff       	call   8016cc <syscall>
  8019b3:	83 c4 18             	add    $0x18,%esp
}
  8019b6:	c9                   	leave  
  8019b7:	c3                   	ret    

008019b8 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8019b8:	55                   	push   %ebp
  8019b9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8019bb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019be:	8b 45 08             	mov    0x8(%ebp),%eax
  8019c1:	6a 00                	push   $0x0
  8019c3:	6a 00                	push   $0x0
  8019c5:	6a 00                	push   $0x0
  8019c7:	52                   	push   %edx
  8019c8:	50                   	push   %eax
  8019c9:	6a 1c                	push   $0x1c
  8019cb:	e8 fc fc ff ff       	call   8016cc <syscall>
  8019d0:	83 c4 18             	add    $0x18,%esp
}
  8019d3:	c9                   	leave  
  8019d4:	c3                   	ret    

008019d5 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8019d5:	55                   	push   %ebp
  8019d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8019d8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8019db:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019de:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e1:	6a 00                	push   $0x0
  8019e3:	6a 00                	push   $0x0
  8019e5:	51                   	push   %ecx
  8019e6:	52                   	push   %edx
  8019e7:	50                   	push   %eax
  8019e8:	6a 1d                	push   $0x1d
  8019ea:	e8 dd fc ff ff       	call   8016cc <syscall>
  8019ef:	83 c4 18             	add    $0x18,%esp
}
  8019f2:	c9                   	leave  
  8019f3:	c3                   	ret    

008019f4 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8019f4:	55                   	push   %ebp
  8019f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8019f7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	52                   	push   %edx
  801a04:	50                   	push   %eax
  801a05:	6a 1e                	push   $0x1e
  801a07:	e8 c0 fc ff ff       	call   8016cc <syscall>
  801a0c:	83 c4 18             	add    $0x18,%esp
}
  801a0f:	c9                   	leave  
  801a10:	c3                   	ret    

00801a11 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a11:	55                   	push   %ebp
  801a12:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a14:	6a 00                	push   $0x0
  801a16:	6a 00                	push   $0x0
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 1f                	push   $0x1f
  801a20:	e8 a7 fc ff ff       	call   8016cc <syscall>
  801a25:	83 c4 18             	add    $0x18,%esp
}
  801a28:	c9                   	leave  
  801a29:	c3                   	ret    

00801a2a <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a2a:	55                   	push   %ebp
  801a2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801a2d:	8b 45 08             	mov    0x8(%ebp),%eax
  801a30:	6a 00                	push   $0x0
  801a32:	ff 75 14             	pushl  0x14(%ebp)
  801a35:	ff 75 10             	pushl  0x10(%ebp)
  801a38:	ff 75 0c             	pushl  0xc(%ebp)
  801a3b:	50                   	push   %eax
  801a3c:	6a 20                	push   $0x20
  801a3e:	e8 89 fc ff ff       	call   8016cc <syscall>
  801a43:	83 c4 18             	add    $0x18,%esp
}
  801a46:	c9                   	leave  
  801a47:	c3                   	ret    

00801a48 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801a48:	55                   	push   %ebp
  801a49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801a4b:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	50                   	push   %eax
  801a57:	6a 21                	push   $0x21
  801a59:	e8 6e fc ff ff       	call   8016cc <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	90                   	nop
  801a62:	c9                   	leave  
  801a63:	c3                   	ret    

00801a64 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801a64:	55                   	push   %ebp
  801a65:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801a67:	8b 45 08             	mov    0x8(%ebp),%eax
  801a6a:	6a 00                	push   $0x0
  801a6c:	6a 00                	push   $0x0
  801a6e:	6a 00                	push   $0x0
  801a70:	6a 00                	push   $0x0
  801a72:	50                   	push   %eax
  801a73:	6a 22                	push   $0x22
  801a75:	e8 52 fc ff ff       	call   8016cc <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
}
  801a7d:	c9                   	leave  
  801a7e:	c3                   	ret    

00801a7f <sys_getenvid>:

int32 sys_getenvid(void)
{
  801a7f:	55                   	push   %ebp
  801a80:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801a82:	6a 00                	push   $0x0
  801a84:	6a 00                	push   $0x0
  801a86:	6a 00                	push   $0x0
  801a88:	6a 00                	push   $0x0
  801a8a:	6a 00                	push   $0x0
  801a8c:	6a 02                	push   $0x2
  801a8e:	e8 39 fc ff ff       	call   8016cc <syscall>
  801a93:	83 c4 18             	add    $0x18,%esp
}
  801a96:	c9                   	leave  
  801a97:	c3                   	ret    

00801a98 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801a98:	55                   	push   %ebp
  801a99:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801a9b:	6a 00                	push   $0x0
  801a9d:	6a 00                	push   $0x0
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 03                	push   $0x3
  801aa7:	e8 20 fc ff ff       	call   8016cc <syscall>
  801aac:	83 c4 18             	add    $0x18,%esp
}
  801aaf:	c9                   	leave  
  801ab0:	c3                   	ret    

00801ab1 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ab1:	55                   	push   %ebp
  801ab2:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ab4:	6a 00                	push   $0x0
  801ab6:	6a 00                	push   $0x0
  801ab8:	6a 00                	push   $0x0
  801aba:	6a 00                	push   $0x0
  801abc:	6a 00                	push   $0x0
  801abe:	6a 04                	push   $0x4
  801ac0:	e8 07 fc ff ff       	call   8016cc <syscall>
  801ac5:	83 c4 18             	add    $0x18,%esp
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_exit_env>:


void sys_exit_env(void)
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 00                	push   $0x0
  801ad7:	6a 23                	push   $0x23
  801ad9:	e8 ee fb ff ff       	call   8016cc <syscall>
  801ade:	83 c4 18             	add    $0x18,%esp
}
  801ae1:	90                   	nop
  801ae2:	c9                   	leave  
  801ae3:	c3                   	ret    

00801ae4 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801ae4:	55                   	push   %ebp
  801ae5:	89 e5                	mov    %esp,%ebp
  801ae7:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801aea:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801aed:	8d 50 04             	lea    0x4(%eax),%edx
  801af0:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801af3:	6a 00                	push   $0x0
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	52                   	push   %edx
  801afa:	50                   	push   %eax
  801afb:	6a 24                	push   $0x24
  801afd:	e8 ca fb ff ff       	call   8016cc <syscall>
  801b02:	83 c4 18             	add    $0x18,%esp
	return result;
  801b05:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b08:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b0b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b0e:	89 01                	mov    %eax,(%ecx)
  801b10:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b13:	8b 45 08             	mov    0x8(%ebp),%eax
  801b16:	c9                   	leave  
  801b17:	c2 04 00             	ret    $0x4

00801b1a <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b1d:	6a 00                	push   $0x0
  801b1f:	6a 00                	push   $0x0
  801b21:	ff 75 10             	pushl  0x10(%ebp)
  801b24:	ff 75 0c             	pushl  0xc(%ebp)
  801b27:	ff 75 08             	pushl  0x8(%ebp)
  801b2a:	6a 12                	push   $0x12
  801b2c:	e8 9b fb ff ff       	call   8016cc <syscall>
  801b31:	83 c4 18             	add    $0x18,%esp
	return ;
  801b34:	90                   	nop
}
  801b35:	c9                   	leave  
  801b36:	c3                   	ret    

00801b37 <sys_rcr2>:
uint32 sys_rcr2()
{
  801b37:	55                   	push   %ebp
  801b38:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 00                	push   $0x0
  801b3e:	6a 00                	push   $0x0
  801b40:	6a 00                	push   $0x0
  801b42:	6a 00                	push   $0x0
  801b44:	6a 25                	push   $0x25
  801b46:	e8 81 fb ff ff       	call   8016cc <syscall>
  801b4b:	83 c4 18             	add    $0x18,%esp
}
  801b4e:	c9                   	leave  
  801b4f:	c3                   	ret    

00801b50 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801b50:	55                   	push   %ebp
  801b51:	89 e5                	mov    %esp,%ebp
  801b53:	83 ec 04             	sub    $0x4,%esp
  801b56:	8b 45 08             	mov    0x8(%ebp),%eax
  801b59:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801b5c:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	50                   	push   %eax
  801b69:	6a 26                	push   $0x26
  801b6b:	e8 5c fb ff ff       	call   8016cc <syscall>
  801b70:	83 c4 18             	add    $0x18,%esp
	return ;
  801b73:	90                   	nop
}
  801b74:	c9                   	leave  
  801b75:	c3                   	ret    

00801b76 <rsttst>:
void rsttst()
{
  801b76:	55                   	push   %ebp
  801b77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801b79:	6a 00                	push   $0x0
  801b7b:	6a 00                	push   $0x0
  801b7d:	6a 00                	push   $0x0
  801b7f:	6a 00                	push   $0x0
  801b81:	6a 00                	push   $0x0
  801b83:	6a 28                	push   $0x28
  801b85:	e8 42 fb ff ff       	call   8016cc <syscall>
  801b8a:	83 c4 18             	add    $0x18,%esp
	return ;
  801b8d:	90                   	nop
}
  801b8e:	c9                   	leave  
  801b8f:	c3                   	ret    

00801b90 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801b90:	55                   	push   %ebp
  801b91:	89 e5                	mov    %esp,%ebp
  801b93:	83 ec 04             	sub    $0x4,%esp
  801b96:	8b 45 14             	mov    0x14(%ebp),%eax
  801b99:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801b9c:	8b 55 18             	mov    0x18(%ebp),%edx
  801b9f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801ba3:	52                   	push   %edx
  801ba4:	50                   	push   %eax
  801ba5:	ff 75 10             	pushl  0x10(%ebp)
  801ba8:	ff 75 0c             	pushl  0xc(%ebp)
  801bab:	ff 75 08             	pushl  0x8(%ebp)
  801bae:	6a 27                	push   $0x27
  801bb0:	e8 17 fb ff ff       	call   8016cc <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
	return ;
  801bb8:	90                   	nop
}
  801bb9:	c9                   	leave  
  801bba:	c3                   	ret    

00801bbb <chktst>:
void chktst(uint32 n)
{
  801bbb:	55                   	push   %ebp
  801bbc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801bbe:	6a 00                	push   $0x0
  801bc0:	6a 00                	push   $0x0
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	ff 75 08             	pushl  0x8(%ebp)
  801bc9:	6a 29                	push   $0x29
  801bcb:	e8 fc fa ff ff       	call   8016cc <syscall>
  801bd0:	83 c4 18             	add    $0x18,%esp
	return ;
  801bd3:	90                   	nop
}
  801bd4:	c9                   	leave  
  801bd5:	c3                   	ret    

00801bd6 <inctst>:

void inctst()
{
  801bd6:	55                   	push   %ebp
  801bd7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	6a 00                	push   $0x0
  801bdf:	6a 00                	push   $0x0
  801be1:	6a 00                	push   $0x0
  801be3:	6a 2a                	push   $0x2a
  801be5:	e8 e2 fa ff ff       	call   8016cc <syscall>
  801bea:	83 c4 18             	add    $0x18,%esp
	return ;
  801bed:	90                   	nop
}
  801bee:	c9                   	leave  
  801bef:	c3                   	ret    

00801bf0 <gettst>:
uint32 gettst()
{
  801bf0:	55                   	push   %ebp
  801bf1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801bf3:	6a 00                	push   $0x0
  801bf5:	6a 00                	push   $0x0
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 2b                	push   $0x2b
  801bff:	e8 c8 fa ff ff       	call   8016cc <syscall>
  801c04:	83 c4 18             	add    $0x18,%esp
}
  801c07:	c9                   	leave  
  801c08:	c3                   	ret    

00801c09 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c09:	55                   	push   %ebp
  801c0a:	89 e5                	mov    %esp,%ebp
  801c0c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c0f:	6a 00                	push   $0x0
  801c11:	6a 00                	push   $0x0
  801c13:	6a 00                	push   $0x0
  801c15:	6a 00                	push   $0x0
  801c17:	6a 00                	push   $0x0
  801c19:	6a 2c                	push   $0x2c
  801c1b:	e8 ac fa ff ff       	call   8016cc <syscall>
  801c20:	83 c4 18             	add    $0x18,%esp
  801c23:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c26:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c2a:	75 07                	jne    801c33 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801c2c:	b8 01 00 00 00       	mov    $0x1,%eax
  801c31:	eb 05                	jmp    801c38 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801c33:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c38:	c9                   	leave  
  801c39:	c3                   	ret    

00801c3a <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801c3a:	55                   	push   %ebp
  801c3b:	89 e5                	mov    %esp,%ebp
  801c3d:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c40:	6a 00                	push   $0x0
  801c42:	6a 00                	push   $0x0
  801c44:	6a 00                	push   $0x0
  801c46:	6a 00                	push   $0x0
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 2c                	push   $0x2c
  801c4c:	e8 7b fa ff ff       	call   8016cc <syscall>
  801c51:	83 c4 18             	add    $0x18,%esp
  801c54:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801c57:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801c5b:	75 07                	jne    801c64 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801c5d:	b8 01 00 00 00       	mov    $0x1,%eax
  801c62:	eb 05                	jmp    801c69 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801c64:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c69:	c9                   	leave  
  801c6a:	c3                   	ret    

00801c6b <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801c6b:	55                   	push   %ebp
  801c6c:	89 e5                	mov    %esp,%ebp
  801c6e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c71:	6a 00                	push   $0x0
  801c73:	6a 00                	push   $0x0
  801c75:	6a 00                	push   $0x0
  801c77:	6a 00                	push   $0x0
  801c79:	6a 00                	push   $0x0
  801c7b:	6a 2c                	push   $0x2c
  801c7d:	e8 4a fa ff ff       	call   8016cc <syscall>
  801c82:	83 c4 18             	add    $0x18,%esp
  801c85:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801c88:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801c8c:	75 07                	jne    801c95 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801c8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801c93:	eb 05                	jmp    801c9a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c9a:	c9                   	leave  
  801c9b:	c3                   	ret    

00801c9c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801c9c:	55                   	push   %ebp
  801c9d:	89 e5                	mov    %esp,%ebp
  801c9f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	6a 00                	push   $0x0
  801ca8:	6a 00                	push   $0x0
  801caa:	6a 00                	push   $0x0
  801cac:	6a 2c                	push   $0x2c
  801cae:	e8 19 fa ff ff       	call   8016cc <syscall>
  801cb3:	83 c4 18             	add    $0x18,%esp
  801cb6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801cb9:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801cbd:	75 07                	jne    801cc6 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801cbf:	b8 01 00 00 00       	mov    $0x1,%eax
  801cc4:	eb 05                	jmp    801ccb <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801cc6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 00                	push   $0x0
  801cd8:	ff 75 08             	pushl  0x8(%ebp)
  801cdb:	6a 2d                	push   $0x2d
  801cdd:	e8 ea f9 ff ff       	call   8016cc <syscall>
  801ce2:	83 c4 18             	add    $0x18,%esp
	return ;
  801ce5:	90                   	nop
}
  801ce6:	c9                   	leave  
  801ce7:	c3                   	ret    

00801ce8 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801ce8:	55                   	push   %ebp
  801ce9:	89 e5                	mov    %esp,%ebp
  801ceb:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801cec:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801cef:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801cf2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf8:	6a 00                	push   $0x0
  801cfa:	53                   	push   %ebx
  801cfb:	51                   	push   %ecx
  801cfc:	52                   	push   %edx
  801cfd:	50                   	push   %eax
  801cfe:	6a 2e                	push   $0x2e
  801d00:	e8 c7 f9 ff ff       	call   8016cc <syscall>
  801d05:	83 c4 18             	add    $0x18,%esp
}
  801d08:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d0b:	c9                   	leave  
  801d0c:	c3                   	ret    

00801d0d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d0d:	55                   	push   %ebp
  801d0e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d10:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d13:	8b 45 08             	mov    0x8(%ebp),%eax
  801d16:	6a 00                	push   $0x0
  801d18:	6a 00                	push   $0x0
  801d1a:	6a 00                	push   $0x0
  801d1c:	52                   	push   %edx
  801d1d:	50                   	push   %eax
  801d1e:	6a 2f                	push   $0x2f
  801d20:	e8 a7 f9 ff ff       	call   8016cc <syscall>
  801d25:	83 c4 18             	add    $0x18,%esp
}
  801d28:	c9                   	leave  
  801d29:	c3                   	ret    

00801d2a <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801d2a:	55                   	push   %ebp
  801d2b:	89 e5                	mov    %esp,%ebp
  801d2d:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801d30:	83 ec 0c             	sub    $0xc,%esp
  801d33:	68 e0 38 80 00       	push   $0x8038e0
  801d38:	e8 3e e6 ff ff       	call   80037b <cprintf>
  801d3d:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801d40:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801d47:	83 ec 0c             	sub    $0xc,%esp
  801d4a:	68 0c 39 80 00       	push   $0x80390c
  801d4f:	e8 27 e6 ff ff       	call   80037b <cprintf>
  801d54:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801d57:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801d5b:	a1 38 41 80 00       	mov    0x804138,%eax
  801d60:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801d63:	eb 56                	jmp    801dbb <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801d65:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801d69:	74 1c                	je     801d87 <print_mem_block_lists+0x5d>
  801d6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d6e:	8b 50 08             	mov    0x8(%eax),%edx
  801d71:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d74:	8b 48 08             	mov    0x8(%eax),%ecx
  801d77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d7a:	8b 40 0c             	mov    0xc(%eax),%eax
  801d7d:	01 c8                	add    %ecx,%eax
  801d7f:	39 c2                	cmp    %eax,%edx
  801d81:	73 04                	jae    801d87 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  801d83:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d8a:	8b 50 08             	mov    0x8(%eax),%edx
  801d8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d90:	8b 40 0c             	mov    0xc(%eax),%eax
  801d93:	01 c2                	add    %eax,%edx
  801d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d98:	8b 40 08             	mov    0x8(%eax),%eax
  801d9b:	83 ec 04             	sub    $0x4,%esp
  801d9e:	52                   	push   %edx
  801d9f:	50                   	push   %eax
  801da0:	68 21 39 80 00       	push   $0x803921
  801da5:	e8 d1 e5 ff ff       	call   80037b <cprintf>
  801daa:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801dad:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801db0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801db3:	a1 40 41 80 00       	mov    0x804140,%eax
  801db8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801dbb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dbf:	74 07                	je     801dc8 <print_mem_block_lists+0x9e>
  801dc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dc4:	8b 00                	mov    (%eax),%eax
  801dc6:	eb 05                	jmp    801dcd <print_mem_block_lists+0xa3>
  801dc8:	b8 00 00 00 00       	mov    $0x0,%eax
  801dcd:	a3 40 41 80 00       	mov    %eax,0x804140
  801dd2:	a1 40 41 80 00       	mov    0x804140,%eax
  801dd7:	85 c0                	test   %eax,%eax
  801dd9:	75 8a                	jne    801d65 <print_mem_block_lists+0x3b>
  801ddb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ddf:	75 84                	jne    801d65 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  801de1:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801de5:	75 10                	jne    801df7 <print_mem_block_lists+0xcd>
  801de7:	83 ec 0c             	sub    $0xc,%esp
  801dea:	68 30 39 80 00       	push   $0x803930
  801def:	e8 87 e5 ff ff       	call   80037b <cprintf>
  801df4:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  801df7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  801dfe:	83 ec 0c             	sub    $0xc,%esp
  801e01:	68 54 39 80 00       	push   $0x803954
  801e06:	e8 70 e5 ff ff       	call   80037b <cprintf>
  801e0b:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  801e0e:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e12:	a1 40 40 80 00       	mov    0x804040,%eax
  801e17:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e1a:	eb 56                	jmp    801e72 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  801e1c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e20:	74 1c                	je     801e3e <print_mem_block_lists+0x114>
  801e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e25:	8b 50 08             	mov    0x8(%eax),%edx
  801e28:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2b:	8b 48 08             	mov    0x8(%eax),%ecx
  801e2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e31:	8b 40 0c             	mov    0xc(%eax),%eax
  801e34:	01 c8                	add    %ecx,%eax
  801e36:	39 c2                	cmp    %eax,%edx
  801e38:	73 04                	jae    801e3e <print_mem_block_lists+0x114>
			sorted = 0 ;
  801e3a:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  801e3e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e41:	8b 50 08             	mov    0x8(%eax),%edx
  801e44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e47:	8b 40 0c             	mov    0xc(%eax),%eax
  801e4a:	01 c2                	add    %eax,%edx
  801e4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e4f:	8b 40 08             	mov    0x8(%eax),%eax
  801e52:	83 ec 04             	sub    $0x4,%esp
  801e55:	52                   	push   %edx
  801e56:	50                   	push   %eax
  801e57:	68 21 39 80 00       	push   $0x803921
  801e5c:	e8 1a e5 ff ff       	call   80037b <cprintf>
  801e61:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  801e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e67:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  801e6a:	a1 48 40 80 00       	mov    0x804048,%eax
  801e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801e72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e76:	74 07                	je     801e7f <print_mem_block_lists+0x155>
  801e78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e7b:	8b 00                	mov    (%eax),%eax
  801e7d:	eb 05                	jmp    801e84 <print_mem_block_lists+0x15a>
  801e7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e84:	a3 48 40 80 00       	mov    %eax,0x804048
  801e89:	a1 48 40 80 00       	mov    0x804048,%eax
  801e8e:	85 c0                	test   %eax,%eax
  801e90:	75 8a                	jne    801e1c <print_mem_block_lists+0xf2>
  801e92:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801e96:	75 84                	jne    801e1c <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  801e98:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  801e9c:	75 10                	jne    801eae <print_mem_block_lists+0x184>
  801e9e:	83 ec 0c             	sub    $0xc,%esp
  801ea1:	68 6c 39 80 00       	push   $0x80396c
  801ea6:	e8 d0 e4 ff ff       	call   80037b <cprintf>
  801eab:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  801eae:	83 ec 0c             	sub    $0xc,%esp
  801eb1:	68 e0 38 80 00       	push   $0x8038e0
  801eb6:	e8 c0 e4 ff ff       	call   80037b <cprintf>
  801ebb:	83 c4 10             	add    $0x10,%esp

}
  801ebe:	90                   	nop
  801ebf:	c9                   	leave  
  801ec0:	c3                   	ret    

00801ec1 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  801ec1:	55                   	push   %ebp
  801ec2:	89 e5                	mov    %esp,%ebp
  801ec4:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  801ec7:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  801ece:	00 00 00 
  801ed1:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  801ed8:	00 00 00 
  801edb:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  801ee2:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  801ee5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  801eec:	e9 9e 00 00 00       	jmp    801f8f <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  801ef1:	a1 50 40 80 00       	mov    0x804050,%eax
  801ef6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801ef9:	c1 e2 04             	shl    $0x4,%edx
  801efc:	01 d0                	add    %edx,%eax
  801efe:	85 c0                	test   %eax,%eax
  801f00:	75 14                	jne    801f16 <initialize_MemBlocksList+0x55>
  801f02:	83 ec 04             	sub    $0x4,%esp
  801f05:	68 94 39 80 00       	push   $0x803994
  801f0a:	6a 3d                	push   $0x3d
  801f0c:	68 b7 39 80 00       	push   $0x8039b7
  801f11:	e8 1d 10 00 00       	call   802f33 <_panic>
  801f16:	a1 50 40 80 00       	mov    0x804050,%eax
  801f1b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f1e:	c1 e2 04             	shl    $0x4,%edx
  801f21:	01 d0                	add    %edx,%eax
  801f23:	8b 15 48 41 80 00    	mov    0x804148,%edx
  801f29:	89 10                	mov    %edx,(%eax)
  801f2b:	8b 00                	mov    (%eax),%eax
  801f2d:	85 c0                	test   %eax,%eax
  801f2f:	74 18                	je     801f49 <initialize_MemBlocksList+0x88>
  801f31:	a1 48 41 80 00       	mov    0x804148,%eax
  801f36:	8b 15 50 40 80 00    	mov    0x804050,%edx
  801f3c:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  801f3f:	c1 e1 04             	shl    $0x4,%ecx
  801f42:	01 ca                	add    %ecx,%edx
  801f44:	89 50 04             	mov    %edx,0x4(%eax)
  801f47:	eb 12                	jmp    801f5b <initialize_MemBlocksList+0x9a>
  801f49:	a1 50 40 80 00       	mov    0x804050,%eax
  801f4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f51:	c1 e2 04             	shl    $0x4,%edx
  801f54:	01 d0                	add    %edx,%eax
  801f56:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801f5b:	a1 50 40 80 00       	mov    0x804050,%eax
  801f60:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f63:	c1 e2 04             	shl    $0x4,%edx
  801f66:	01 d0                	add    %edx,%eax
  801f68:	a3 48 41 80 00       	mov    %eax,0x804148
  801f6d:	a1 50 40 80 00       	mov    0x804050,%eax
  801f72:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f75:	c1 e2 04             	shl    $0x4,%edx
  801f78:	01 d0                	add    %edx,%eax
  801f7a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f81:	a1 54 41 80 00       	mov    0x804154,%eax
  801f86:	40                   	inc    %eax
  801f87:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  801f8c:	ff 45 f4             	incl   -0xc(%ebp)
  801f8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f92:	3b 45 08             	cmp    0x8(%ebp),%eax
  801f95:	0f 82 56 ff ff ff    	jb     801ef1 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  801f9b:	90                   	nop
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
  801fa1:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	8b 00                	mov    (%eax),%eax
  801fa9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  801fac:	eb 18                	jmp    801fc6 <find_block+0x28>

		if(tmp->sva == va){
  801fae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fb1:	8b 40 08             	mov    0x8(%eax),%eax
  801fb4:	3b 45 0c             	cmp    0xc(%ebp),%eax
  801fb7:	75 05                	jne    801fbe <find_block+0x20>
			return tmp ;
  801fb9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fbc:	eb 11                	jmp    801fcf <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  801fbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801fc1:	8b 00                	mov    (%eax),%eax
  801fc3:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  801fc6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801fca:	75 e2                	jne    801fae <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  801fcc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801fcf:	c9                   	leave  
  801fd0:	c3                   	ret    

00801fd1 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  801fd1:	55                   	push   %ebp
  801fd2:	89 e5                	mov    %esp,%ebp
  801fd4:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  801fd7:	a1 40 40 80 00       	mov    0x804040,%eax
  801fdc:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  801fdf:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801fe4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  801fe7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801feb:	75 65                	jne    802052 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  801fed:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801ff1:	75 14                	jne    802007 <insert_sorted_allocList+0x36>
  801ff3:	83 ec 04             	sub    $0x4,%esp
  801ff6:	68 94 39 80 00       	push   $0x803994
  801ffb:	6a 62                	push   $0x62
  801ffd:	68 b7 39 80 00       	push   $0x8039b7
  802002:	e8 2c 0f 00 00       	call   802f33 <_panic>
  802007:	8b 15 40 40 80 00    	mov    0x804040,%edx
  80200d:	8b 45 08             	mov    0x8(%ebp),%eax
  802010:	89 10                	mov    %edx,(%eax)
  802012:	8b 45 08             	mov    0x8(%ebp),%eax
  802015:	8b 00                	mov    (%eax),%eax
  802017:	85 c0                	test   %eax,%eax
  802019:	74 0d                	je     802028 <insert_sorted_allocList+0x57>
  80201b:	a1 40 40 80 00       	mov    0x804040,%eax
  802020:	8b 55 08             	mov    0x8(%ebp),%edx
  802023:	89 50 04             	mov    %edx,0x4(%eax)
  802026:	eb 08                	jmp    802030 <insert_sorted_allocList+0x5f>
  802028:	8b 45 08             	mov    0x8(%ebp),%eax
  80202b:	a3 44 40 80 00       	mov    %eax,0x804044
  802030:	8b 45 08             	mov    0x8(%ebp),%eax
  802033:	a3 40 40 80 00       	mov    %eax,0x804040
  802038:	8b 45 08             	mov    0x8(%ebp),%eax
  80203b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802042:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802047:	40                   	inc    %eax
  802048:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80204d:	e9 14 01 00 00       	jmp    802166 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802052:	8b 45 08             	mov    0x8(%ebp),%eax
  802055:	8b 50 08             	mov    0x8(%eax),%edx
  802058:	a1 44 40 80 00       	mov    0x804044,%eax
  80205d:	8b 40 08             	mov    0x8(%eax),%eax
  802060:	39 c2                	cmp    %eax,%edx
  802062:	76 65                	jbe    8020c9 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802064:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802068:	75 14                	jne    80207e <insert_sorted_allocList+0xad>
  80206a:	83 ec 04             	sub    $0x4,%esp
  80206d:	68 d0 39 80 00       	push   $0x8039d0
  802072:	6a 64                	push   $0x64
  802074:	68 b7 39 80 00       	push   $0x8039b7
  802079:	e8 b5 0e 00 00       	call   802f33 <_panic>
  80207e:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	89 50 04             	mov    %edx,0x4(%eax)
  80208a:	8b 45 08             	mov    0x8(%ebp),%eax
  80208d:	8b 40 04             	mov    0x4(%eax),%eax
  802090:	85 c0                	test   %eax,%eax
  802092:	74 0c                	je     8020a0 <insert_sorted_allocList+0xcf>
  802094:	a1 44 40 80 00       	mov    0x804044,%eax
  802099:	8b 55 08             	mov    0x8(%ebp),%edx
  80209c:	89 10                	mov    %edx,(%eax)
  80209e:	eb 08                	jmp    8020a8 <insert_sorted_allocList+0xd7>
  8020a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a3:	a3 40 40 80 00       	mov    %eax,0x804040
  8020a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8020ab:	a3 44 40 80 00       	mov    %eax,0x804044
  8020b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8020b9:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8020be:	40                   	inc    %eax
  8020bf:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8020c4:	e9 9d 00 00 00       	jmp    802166 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8020c9:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8020d0:	e9 85 00 00 00       	jmp    80215a <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  8020d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8020d8:	8b 50 08             	mov    0x8(%eax),%edx
  8020db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020de:	8b 40 08             	mov    0x8(%eax),%eax
  8020e1:	39 c2                	cmp    %eax,%edx
  8020e3:	73 6a                	jae    80214f <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  8020e5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8020e9:	74 06                	je     8020f1 <insert_sorted_allocList+0x120>
  8020eb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8020ef:	75 14                	jne    802105 <insert_sorted_allocList+0x134>
  8020f1:	83 ec 04             	sub    $0x4,%esp
  8020f4:	68 f4 39 80 00       	push   $0x8039f4
  8020f9:	6a 6b                	push   $0x6b
  8020fb:	68 b7 39 80 00       	push   $0x8039b7
  802100:	e8 2e 0e 00 00       	call   802f33 <_panic>
  802105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802108:	8b 50 04             	mov    0x4(%eax),%edx
  80210b:	8b 45 08             	mov    0x8(%ebp),%eax
  80210e:	89 50 04             	mov    %edx,0x4(%eax)
  802111:	8b 45 08             	mov    0x8(%ebp),%eax
  802114:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802117:	89 10                	mov    %edx,(%eax)
  802119:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211c:	8b 40 04             	mov    0x4(%eax),%eax
  80211f:	85 c0                	test   %eax,%eax
  802121:	74 0d                	je     802130 <insert_sorted_allocList+0x15f>
  802123:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802126:	8b 40 04             	mov    0x4(%eax),%eax
  802129:	8b 55 08             	mov    0x8(%ebp),%edx
  80212c:	89 10                	mov    %edx,(%eax)
  80212e:	eb 08                	jmp    802138 <insert_sorted_allocList+0x167>
  802130:	8b 45 08             	mov    0x8(%ebp),%eax
  802133:	a3 40 40 80 00       	mov    %eax,0x804040
  802138:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80213b:	8b 55 08             	mov    0x8(%ebp),%edx
  80213e:	89 50 04             	mov    %edx,0x4(%eax)
  802141:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802146:	40                   	inc    %eax
  802147:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  80214c:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80214d:	eb 17                	jmp    802166 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  80214f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802152:	8b 00                	mov    (%eax),%eax
  802154:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802157:	ff 45 f0             	incl   -0x10(%ebp)
  80215a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80215d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802160:	0f 8c 6f ff ff ff    	jl     8020d5 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802166:	90                   	nop
  802167:	c9                   	leave  
  802168:	c3                   	ret    

00802169 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802169:	55                   	push   %ebp
  80216a:	89 e5                	mov    %esp,%ebp
  80216c:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  80216f:	a1 38 41 80 00       	mov    0x804138,%eax
  802174:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802177:	e9 7c 01 00 00       	jmp    8022f8 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  80217c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80217f:	8b 40 0c             	mov    0xc(%eax),%eax
  802182:	3b 45 08             	cmp    0x8(%ebp),%eax
  802185:	0f 86 cf 00 00 00    	jbe    80225a <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80218b:	a1 48 41 80 00       	mov    0x804148,%eax
  802190:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802193:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802196:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802199:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219c:	8b 55 08             	mov    0x8(%ebp),%edx
  80219f:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8021a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021a5:	8b 50 08             	mov    0x8(%eax),%edx
  8021a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021ab:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  8021ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021b1:	8b 40 0c             	mov    0xc(%eax),%eax
  8021b4:	2b 45 08             	sub    0x8(%ebp),%eax
  8021b7:	89 c2                	mov    %eax,%edx
  8021b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021bc:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  8021bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c2:	8b 50 08             	mov    0x8(%eax),%edx
  8021c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c8:	01 c2                	add    %eax,%edx
  8021ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021cd:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  8021d0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8021d4:	75 17                	jne    8021ed <alloc_block_FF+0x84>
  8021d6:	83 ec 04             	sub    $0x4,%esp
  8021d9:	68 29 3a 80 00       	push   $0x803a29
  8021de:	68 83 00 00 00       	push   $0x83
  8021e3:	68 b7 39 80 00       	push   $0x8039b7
  8021e8:	e8 46 0d 00 00       	call   802f33 <_panic>
  8021ed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f0:	8b 00                	mov    (%eax),%eax
  8021f2:	85 c0                	test   %eax,%eax
  8021f4:	74 10                	je     802206 <alloc_block_FF+0x9d>
  8021f6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8021f9:	8b 00                	mov    (%eax),%eax
  8021fb:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8021fe:	8b 52 04             	mov    0x4(%edx),%edx
  802201:	89 50 04             	mov    %edx,0x4(%eax)
  802204:	eb 0b                	jmp    802211 <alloc_block_FF+0xa8>
  802206:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802209:	8b 40 04             	mov    0x4(%eax),%eax
  80220c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802211:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802214:	8b 40 04             	mov    0x4(%eax),%eax
  802217:	85 c0                	test   %eax,%eax
  802219:	74 0f                	je     80222a <alloc_block_FF+0xc1>
  80221b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80221e:	8b 40 04             	mov    0x4(%eax),%eax
  802221:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802224:	8b 12                	mov    (%edx),%edx
  802226:	89 10                	mov    %edx,(%eax)
  802228:	eb 0a                	jmp    802234 <alloc_block_FF+0xcb>
  80222a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80222d:	8b 00                	mov    (%eax),%eax
  80222f:	a3 48 41 80 00       	mov    %eax,0x804148
  802234:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802237:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80223d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802240:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802247:	a1 54 41 80 00       	mov    0x804154,%eax
  80224c:	48                   	dec    %eax
  80224d:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  802252:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802255:	e9 ad 00 00 00       	jmp    802307 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  80225a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80225d:	8b 40 0c             	mov    0xc(%eax),%eax
  802260:	3b 45 08             	cmp    0x8(%ebp),%eax
  802263:	0f 85 87 00 00 00    	jne    8022f0 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802269:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80226d:	75 17                	jne    802286 <alloc_block_FF+0x11d>
  80226f:	83 ec 04             	sub    $0x4,%esp
  802272:	68 29 3a 80 00       	push   $0x803a29
  802277:	68 87 00 00 00       	push   $0x87
  80227c:	68 b7 39 80 00       	push   $0x8039b7
  802281:	e8 ad 0c 00 00       	call   802f33 <_panic>
  802286:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802289:	8b 00                	mov    (%eax),%eax
  80228b:	85 c0                	test   %eax,%eax
  80228d:	74 10                	je     80229f <alloc_block_FF+0x136>
  80228f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802292:	8b 00                	mov    (%eax),%eax
  802294:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802297:	8b 52 04             	mov    0x4(%edx),%edx
  80229a:	89 50 04             	mov    %edx,0x4(%eax)
  80229d:	eb 0b                	jmp    8022aa <alloc_block_FF+0x141>
  80229f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022a2:	8b 40 04             	mov    0x4(%eax),%eax
  8022a5:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8022aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ad:	8b 40 04             	mov    0x4(%eax),%eax
  8022b0:	85 c0                	test   %eax,%eax
  8022b2:	74 0f                	je     8022c3 <alloc_block_FF+0x15a>
  8022b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022b7:	8b 40 04             	mov    0x4(%eax),%eax
  8022ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8022bd:	8b 12                	mov    (%edx),%edx
  8022bf:	89 10                	mov    %edx,(%eax)
  8022c1:	eb 0a                	jmp    8022cd <alloc_block_FF+0x164>
  8022c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022c6:	8b 00                	mov    (%eax),%eax
  8022c8:	a3 38 41 80 00       	mov    %eax,0x804138
  8022cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8022d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022d9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e0:	a1 44 41 80 00       	mov    0x804144,%eax
  8022e5:	48                   	dec    %eax
  8022e6:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  8022eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022ee:	eb 17                	jmp    802307 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  8022f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8022f3:	8b 00                	mov    (%eax),%eax
  8022f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  8022f8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8022fc:	0f 85 7a fe ff ff    	jne    80217c <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802302:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802307:	c9                   	leave  
  802308:	c3                   	ret    

00802309 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802309:	55                   	push   %ebp
  80230a:	89 e5                	mov    %esp,%ebp
  80230c:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  80230f:	a1 38 41 80 00       	mov    0x804138,%eax
  802314:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802317:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  80231e:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802325:	a1 38 41 80 00       	mov    0x804138,%eax
  80232a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80232d:	e9 d0 00 00 00       	jmp    802402 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802332:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802335:	8b 40 0c             	mov    0xc(%eax),%eax
  802338:	3b 45 08             	cmp    0x8(%ebp),%eax
  80233b:	0f 82 b8 00 00 00    	jb     8023f9 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802341:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802344:	8b 40 0c             	mov    0xc(%eax),%eax
  802347:	2b 45 08             	sub    0x8(%ebp),%eax
  80234a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  80234d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802350:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802353:	0f 83 a1 00 00 00    	jae    8023fa <alloc_block_BF+0xf1>
				differsize = differance ;
  802359:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80235c:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  80235f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802362:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802365:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802369:	0f 85 8b 00 00 00    	jne    8023fa <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  80236f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802373:	75 17                	jne    80238c <alloc_block_BF+0x83>
  802375:	83 ec 04             	sub    $0x4,%esp
  802378:	68 29 3a 80 00       	push   $0x803a29
  80237d:	68 a0 00 00 00       	push   $0xa0
  802382:	68 b7 39 80 00       	push   $0x8039b7
  802387:	e8 a7 0b 00 00       	call   802f33 <_panic>
  80238c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80238f:	8b 00                	mov    (%eax),%eax
  802391:	85 c0                	test   %eax,%eax
  802393:	74 10                	je     8023a5 <alloc_block_BF+0x9c>
  802395:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802398:	8b 00                	mov    (%eax),%eax
  80239a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80239d:	8b 52 04             	mov    0x4(%edx),%edx
  8023a0:	89 50 04             	mov    %edx,0x4(%eax)
  8023a3:	eb 0b                	jmp    8023b0 <alloc_block_BF+0xa7>
  8023a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023a8:	8b 40 04             	mov    0x4(%eax),%eax
  8023ab:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8023b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023b3:	8b 40 04             	mov    0x4(%eax),%eax
  8023b6:	85 c0                	test   %eax,%eax
  8023b8:	74 0f                	je     8023c9 <alloc_block_BF+0xc0>
  8023ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bd:	8b 40 04             	mov    0x4(%eax),%eax
  8023c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023c3:	8b 12                	mov    (%edx),%edx
  8023c5:	89 10                	mov    %edx,(%eax)
  8023c7:	eb 0a                	jmp    8023d3 <alloc_block_BF+0xca>
  8023c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023cc:	8b 00                	mov    (%eax),%eax
  8023ce:	a3 38 41 80 00       	mov    %eax,0x804138
  8023d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023d6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8023dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8023e6:	a1 44 41 80 00       	mov    0x804144,%eax
  8023eb:	48                   	dec    %eax
  8023ec:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  8023f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f4:	e9 0c 01 00 00       	jmp    802505 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  8023f9:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8023fa:	a1 40 41 80 00       	mov    0x804140,%eax
  8023ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802402:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802406:	74 07                	je     80240f <alloc_block_BF+0x106>
  802408:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80240b:	8b 00                	mov    (%eax),%eax
  80240d:	eb 05                	jmp    802414 <alloc_block_BF+0x10b>
  80240f:	b8 00 00 00 00       	mov    $0x0,%eax
  802414:	a3 40 41 80 00       	mov    %eax,0x804140
  802419:	a1 40 41 80 00       	mov    0x804140,%eax
  80241e:	85 c0                	test   %eax,%eax
  802420:	0f 85 0c ff ff ff    	jne    802332 <alloc_block_BF+0x29>
  802426:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80242a:	0f 85 02 ff ff ff    	jne    802332 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802430:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802434:	0f 84 c6 00 00 00    	je     802500 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  80243a:	a1 48 41 80 00       	mov    0x804148,%eax
  80243f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802442:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802445:	8b 55 08             	mov    0x8(%ebp),%edx
  802448:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  80244b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80244e:	8b 50 08             	mov    0x8(%eax),%edx
  802451:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802454:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802457:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80245a:	8b 40 0c             	mov    0xc(%eax),%eax
  80245d:	2b 45 08             	sub    0x8(%ebp),%eax
  802460:	89 c2                	mov    %eax,%edx
  802462:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802465:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802468:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80246b:	8b 50 08             	mov    0x8(%eax),%edx
  80246e:	8b 45 08             	mov    0x8(%ebp),%eax
  802471:	01 c2                	add    %eax,%edx
  802473:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802476:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802479:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80247d:	75 17                	jne    802496 <alloc_block_BF+0x18d>
  80247f:	83 ec 04             	sub    $0x4,%esp
  802482:	68 29 3a 80 00       	push   $0x803a29
  802487:	68 af 00 00 00       	push   $0xaf
  80248c:	68 b7 39 80 00       	push   $0x8039b7
  802491:	e8 9d 0a 00 00       	call   802f33 <_panic>
  802496:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802499:	8b 00                	mov    (%eax),%eax
  80249b:	85 c0                	test   %eax,%eax
  80249d:	74 10                	je     8024af <alloc_block_BF+0x1a6>
  80249f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024a2:	8b 00                	mov    (%eax),%eax
  8024a4:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024a7:	8b 52 04             	mov    0x4(%edx),%edx
  8024aa:	89 50 04             	mov    %edx,0x4(%eax)
  8024ad:	eb 0b                	jmp    8024ba <alloc_block_BF+0x1b1>
  8024af:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024b2:	8b 40 04             	mov    0x4(%eax),%eax
  8024b5:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024bd:	8b 40 04             	mov    0x4(%eax),%eax
  8024c0:	85 c0                	test   %eax,%eax
  8024c2:	74 0f                	je     8024d3 <alloc_block_BF+0x1ca>
  8024c4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024c7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ca:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8024cd:	8b 12                	mov    (%edx),%edx
  8024cf:	89 10                	mov    %edx,(%eax)
  8024d1:	eb 0a                	jmp    8024dd <alloc_block_BF+0x1d4>
  8024d3:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024d6:	8b 00                	mov    (%eax),%eax
  8024d8:	a3 48 41 80 00       	mov    %eax,0x804148
  8024dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024e0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024e9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024f0:	a1 54 41 80 00       	mov    0x804154,%eax
  8024f5:	48                   	dec    %eax
  8024f6:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  8024fb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8024fe:	eb 05                	jmp    802505 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802500:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802505:	c9                   	leave  
  802506:	c3                   	ret    

00802507 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802507:	55                   	push   %ebp
  802508:	89 e5                	mov    %esp,%ebp
  80250a:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  80250d:	a1 38 41 80 00       	mov    0x804138,%eax
  802512:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802515:	e9 7c 01 00 00       	jmp    802696 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  80251a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80251d:	8b 40 0c             	mov    0xc(%eax),%eax
  802520:	3b 45 08             	cmp    0x8(%ebp),%eax
  802523:	0f 86 cf 00 00 00    	jbe    8025f8 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802529:	a1 48 41 80 00       	mov    0x804148,%eax
  80252e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802531:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802534:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802537:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80253a:	8b 55 08             	mov    0x8(%ebp),%edx
  80253d:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802540:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802543:	8b 50 08             	mov    0x8(%eax),%edx
  802546:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802549:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  80254c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80254f:	8b 40 0c             	mov    0xc(%eax),%eax
  802552:	2b 45 08             	sub    0x8(%ebp),%eax
  802555:	89 c2                	mov    %eax,%edx
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  80255d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802560:	8b 50 08             	mov    0x8(%eax),%edx
  802563:	8b 45 08             	mov    0x8(%ebp),%eax
  802566:	01 c2                	add    %eax,%edx
  802568:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80256b:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80256e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802572:	75 17                	jne    80258b <alloc_block_NF+0x84>
  802574:	83 ec 04             	sub    $0x4,%esp
  802577:	68 29 3a 80 00       	push   $0x803a29
  80257c:	68 c4 00 00 00       	push   $0xc4
  802581:	68 b7 39 80 00       	push   $0x8039b7
  802586:	e8 a8 09 00 00       	call   802f33 <_panic>
  80258b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80258e:	8b 00                	mov    (%eax),%eax
  802590:	85 c0                	test   %eax,%eax
  802592:	74 10                	je     8025a4 <alloc_block_NF+0x9d>
  802594:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802597:	8b 00                	mov    (%eax),%eax
  802599:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80259c:	8b 52 04             	mov    0x4(%edx),%edx
  80259f:	89 50 04             	mov    %edx,0x4(%eax)
  8025a2:	eb 0b                	jmp    8025af <alloc_block_NF+0xa8>
  8025a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025a7:	8b 40 04             	mov    0x4(%eax),%eax
  8025aa:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8025af:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025b2:	8b 40 04             	mov    0x4(%eax),%eax
  8025b5:	85 c0                	test   %eax,%eax
  8025b7:	74 0f                	je     8025c8 <alloc_block_NF+0xc1>
  8025b9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025bc:	8b 40 04             	mov    0x4(%eax),%eax
  8025bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8025c2:	8b 12                	mov    (%edx),%edx
  8025c4:	89 10                	mov    %edx,(%eax)
  8025c6:	eb 0a                	jmp    8025d2 <alloc_block_NF+0xcb>
  8025c8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025cb:	8b 00                	mov    (%eax),%eax
  8025cd:	a3 48 41 80 00       	mov    %eax,0x804148
  8025d2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025d5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8025db:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025e5:	a1 54 41 80 00       	mov    0x804154,%eax
  8025ea:	48                   	dec    %eax
  8025eb:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  8025f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8025f3:	e9 ad 00 00 00       	jmp    8026a5 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8025f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fb:	8b 40 0c             	mov    0xc(%eax),%eax
  8025fe:	3b 45 08             	cmp    0x8(%ebp),%eax
  802601:	0f 85 87 00 00 00    	jne    80268e <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802607:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80260b:	75 17                	jne    802624 <alloc_block_NF+0x11d>
  80260d:	83 ec 04             	sub    $0x4,%esp
  802610:	68 29 3a 80 00       	push   $0x803a29
  802615:	68 c8 00 00 00       	push   $0xc8
  80261a:	68 b7 39 80 00       	push   $0x8039b7
  80261f:	e8 0f 09 00 00       	call   802f33 <_panic>
  802624:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802627:	8b 00                	mov    (%eax),%eax
  802629:	85 c0                	test   %eax,%eax
  80262b:	74 10                	je     80263d <alloc_block_NF+0x136>
  80262d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802630:	8b 00                	mov    (%eax),%eax
  802632:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802635:	8b 52 04             	mov    0x4(%edx),%edx
  802638:	89 50 04             	mov    %edx,0x4(%eax)
  80263b:	eb 0b                	jmp    802648 <alloc_block_NF+0x141>
  80263d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802640:	8b 40 04             	mov    0x4(%eax),%eax
  802643:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 40 04             	mov    0x4(%eax),%eax
  80264e:	85 c0                	test   %eax,%eax
  802650:	74 0f                	je     802661 <alloc_block_NF+0x15a>
  802652:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802655:	8b 40 04             	mov    0x4(%eax),%eax
  802658:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80265b:	8b 12                	mov    (%edx),%edx
  80265d:	89 10                	mov    %edx,(%eax)
  80265f:	eb 0a                	jmp    80266b <alloc_block_NF+0x164>
  802661:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802664:	8b 00                	mov    (%eax),%eax
  802666:	a3 38 41 80 00       	mov    %eax,0x804138
  80266b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802677:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80267e:	a1 44 41 80 00       	mov    0x804144,%eax
  802683:	48                   	dec    %eax
  802684:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  802689:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268c:	eb 17                	jmp    8026a5 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  80268e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802691:	8b 00                	mov    (%eax),%eax
  802693:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802696:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80269a:	0f 85 7a fe ff ff    	jne    80251a <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  8026a0:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  8026a5:	c9                   	leave  
  8026a6:	c3                   	ret    

008026a7 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  8026a7:	55                   	push   %ebp
  8026a8:	89 e5                	mov    %esp,%ebp
  8026aa:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  8026ad:	a1 38 41 80 00       	mov    0x804138,%eax
  8026b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  8026b5:	a1 3c 41 80 00       	mov    0x80413c,%eax
  8026ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  8026bd:	a1 44 41 80 00       	mov    0x804144,%eax
  8026c2:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8026c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8026c9:	75 68                	jne    802733 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8026cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026cf:	75 17                	jne    8026e8 <insert_sorted_with_merge_freeList+0x41>
  8026d1:	83 ec 04             	sub    $0x4,%esp
  8026d4:	68 94 39 80 00       	push   $0x803994
  8026d9:	68 da 00 00 00       	push   $0xda
  8026de:	68 b7 39 80 00       	push   $0x8039b7
  8026e3:	e8 4b 08 00 00       	call   802f33 <_panic>
  8026e8:	8b 15 38 41 80 00    	mov    0x804138,%edx
  8026ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f1:	89 10                	mov    %edx,(%eax)
  8026f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f6:	8b 00                	mov    (%eax),%eax
  8026f8:	85 c0                	test   %eax,%eax
  8026fa:	74 0d                	je     802709 <insert_sorted_with_merge_freeList+0x62>
  8026fc:	a1 38 41 80 00       	mov    0x804138,%eax
  802701:	8b 55 08             	mov    0x8(%ebp),%edx
  802704:	89 50 04             	mov    %edx,0x4(%eax)
  802707:	eb 08                	jmp    802711 <insert_sorted_with_merge_freeList+0x6a>
  802709:	8b 45 08             	mov    0x8(%ebp),%eax
  80270c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802711:	8b 45 08             	mov    0x8(%ebp),%eax
  802714:	a3 38 41 80 00       	mov    %eax,0x804138
  802719:	8b 45 08             	mov    0x8(%ebp),%eax
  80271c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802723:	a1 44 41 80 00       	mov    0x804144,%eax
  802728:	40                   	inc    %eax
  802729:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  80272e:	e9 49 07 00 00       	jmp    802e7c <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802733:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802736:	8b 50 08             	mov    0x8(%eax),%edx
  802739:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80273c:	8b 40 0c             	mov    0xc(%eax),%eax
  80273f:	01 c2                	add    %eax,%edx
  802741:	8b 45 08             	mov    0x8(%ebp),%eax
  802744:	8b 40 08             	mov    0x8(%eax),%eax
  802747:	39 c2                	cmp    %eax,%edx
  802749:	73 77                	jae    8027c2 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  80274b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80274e:	8b 00                	mov    (%eax),%eax
  802750:	85 c0                	test   %eax,%eax
  802752:	75 6e                	jne    8027c2 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802754:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802758:	74 68                	je     8027c2 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  80275a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80275e:	75 17                	jne    802777 <insert_sorted_with_merge_freeList+0xd0>
  802760:	83 ec 04             	sub    $0x4,%esp
  802763:	68 d0 39 80 00       	push   $0x8039d0
  802768:	68 e0 00 00 00       	push   $0xe0
  80276d:	68 b7 39 80 00       	push   $0x8039b7
  802772:	e8 bc 07 00 00       	call   802f33 <_panic>
  802777:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80277d:	8b 45 08             	mov    0x8(%ebp),%eax
  802780:	89 50 04             	mov    %edx,0x4(%eax)
  802783:	8b 45 08             	mov    0x8(%ebp),%eax
  802786:	8b 40 04             	mov    0x4(%eax),%eax
  802789:	85 c0                	test   %eax,%eax
  80278b:	74 0c                	je     802799 <insert_sorted_with_merge_freeList+0xf2>
  80278d:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802792:	8b 55 08             	mov    0x8(%ebp),%edx
  802795:	89 10                	mov    %edx,(%eax)
  802797:	eb 08                	jmp    8027a1 <insert_sorted_with_merge_freeList+0xfa>
  802799:	8b 45 08             	mov    0x8(%ebp),%eax
  80279c:	a3 38 41 80 00       	mov    %eax,0x804138
  8027a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8027a4:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8027a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8027ac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8027b2:	a1 44 41 80 00       	mov    0x804144,%eax
  8027b7:	40                   	inc    %eax
  8027b8:	a3 44 41 80 00       	mov    %eax,0x804144
  8027bd:	e9 ba 06 00 00       	jmp    802e7c <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8027c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8027c5:	8b 50 0c             	mov    0xc(%eax),%edx
  8027c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8027cb:	8b 40 08             	mov    0x8(%eax),%eax
  8027ce:	01 c2                	add    %eax,%edx
  8027d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d3:	8b 40 08             	mov    0x8(%eax),%eax
  8027d6:	39 c2                	cmp    %eax,%edx
  8027d8:	73 78                	jae    802852 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8027da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027dd:	8b 40 04             	mov    0x4(%eax),%eax
  8027e0:	85 c0                	test   %eax,%eax
  8027e2:	75 6e                	jne    802852 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8027e4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8027e8:	74 68                	je     802852 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8027ea:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8027ee:	75 17                	jne    802807 <insert_sorted_with_merge_freeList+0x160>
  8027f0:	83 ec 04             	sub    $0x4,%esp
  8027f3:	68 94 39 80 00       	push   $0x803994
  8027f8:	68 e6 00 00 00       	push   $0xe6
  8027fd:	68 b7 39 80 00       	push   $0x8039b7
  802802:	e8 2c 07 00 00       	call   802f33 <_panic>
  802807:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80280d:	8b 45 08             	mov    0x8(%ebp),%eax
  802810:	89 10                	mov    %edx,(%eax)
  802812:	8b 45 08             	mov    0x8(%ebp),%eax
  802815:	8b 00                	mov    (%eax),%eax
  802817:	85 c0                	test   %eax,%eax
  802819:	74 0d                	je     802828 <insert_sorted_with_merge_freeList+0x181>
  80281b:	a1 38 41 80 00       	mov    0x804138,%eax
  802820:	8b 55 08             	mov    0x8(%ebp),%edx
  802823:	89 50 04             	mov    %edx,0x4(%eax)
  802826:	eb 08                	jmp    802830 <insert_sorted_with_merge_freeList+0x189>
  802828:	8b 45 08             	mov    0x8(%ebp),%eax
  80282b:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802830:	8b 45 08             	mov    0x8(%ebp),%eax
  802833:	a3 38 41 80 00       	mov    %eax,0x804138
  802838:	8b 45 08             	mov    0x8(%ebp),%eax
  80283b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802842:	a1 44 41 80 00       	mov    0x804144,%eax
  802847:	40                   	inc    %eax
  802848:	a3 44 41 80 00       	mov    %eax,0x804144
  80284d:	e9 2a 06 00 00       	jmp    802e7c <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802852:	a1 38 41 80 00       	mov    0x804138,%eax
  802857:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80285a:	e9 ed 05 00 00       	jmp    802e4c <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  80285f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802862:	8b 00                	mov    (%eax),%eax
  802864:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802867:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80286b:	0f 84 a7 00 00 00    	je     802918 <insert_sorted_with_merge_freeList+0x271>
  802871:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802874:	8b 50 0c             	mov    0xc(%eax),%edx
  802877:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80287a:	8b 40 08             	mov    0x8(%eax),%eax
  80287d:	01 c2                	add    %eax,%edx
  80287f:	8b 45 08             	mov    0x8(%ebp),%eax
  802882:	8b 40 08             	mov    0x8(%eax),%eax
  802885:	39 c2                	cmp    %eax,%edx
  802887:	0f 83 8b 00 00 00    	jae    802918 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  80288d:	8b 45 08             	mov    0x8(%ebp),%eax
  802890:	8b 50 0c             	mov    0xc(%eax),%edx
  802893:	8b 45 08             	mov    0x8(%ebp),%eax
  802896:	8b 40 08             	mov    0x8(%eax),%eax
  802899:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  80289b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80289e:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  8028a1:	39 c2                	cmp    %eax,%edx
  8028a3:	73 73                	jae    802918 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  8028a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a9:	74 06                	je     8028b1 <insert_sorted_with_merge_freeList+0x20a>
  8028ab:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028af:	75 17                	jne    8028c8 <insert_sorted_with_merge_freeList+0x221>
  8028b1:	83 ec 04             	sub    $0x4,%esp
  8028b4:	68 48 3a 80 00       	push   $0x803a48
  8028b9:	68 f0 00 00 00       	push   $0xf0
  8028be:	68 b7 39 80 00       	push   $0x8039b7
  8028c3:	e8 6b 06 00 00       	call   802f33 <_panic>
  8028c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028cb:	8b 10                	mov    (%eax),%edx
  8028cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d0:	89 10                	mov    %edx,(%eax)
  8028d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8028d5:	8b 00                	mov    (%eax),%eax
  8028d7:	85 c0                	test   %eax,%eax
  8028d9:	74 0b                	je     8028e6 <insert_sorted_with_merge_freeList+0x23f>
  8028db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028de:	8b 00                	mov    (%eax),%eax
  8028e0:	8b 55 08             	mov    0x8(%ebp),%edx
  8028e3:	89 50 04             	mov    %edx,0x4(%eax)
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	8b 55 08             	mov    0x8(%ebp),%edx
  8028ec:	89 10                	mov    %edx,(%eax)
  8028ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028f4:	89 50 04             	mov    %edx,0x4(%eax)
  8028f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028fa:	8b 00                	mov    (%eax),%eax
  8028fc:	85 c0                	test   %eax,%eax
  8028fe:	75 08                	jne    802908 <insert_sorted_with_merge_freeList+0x261>
  802900:	8b 45 08             	mov    0x8(%ebp),%eax
  802903:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802908:	a1 44 41 80 00       	mov    0x804144,%eax
  80290d:	40                   	inc    %eax
  80290e:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802913:	e9 64 05 00 00       	jmp    802e7c <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802918:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80291d:	8b 50 0c             	mov    0xc(%eax),%edx
  802920:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802925:	8b 40 08             	mov    0x8(%eax),%eax
  802928:	01 c2                	add    %eax,%edx
  80292a:	8b 45 08             	mov    0x8(%ebp),%eax
  80292d:	8b 40 08             	mov    0x8(%eax),%eax
  802930:	39 c2                	cmp    %eax,%edx
  802932:	0f 85 b1 00 00 00    	jne    8029e9 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802938:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80293d:	85 c0                	test   %eax,%eax
  80293f:	0f 84 a4 00 00 00    	je     8029e9 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802945:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80294a:	8b 00                	mov    (%eax),%eax
  80294c:	85 c0                	test   %eax,%eax
  80294e:	0f 85 95 00 00 00    	jne    8029e9 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802954:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802959:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  80295f:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802962:	8b 55 08             	mov    0x8(%ebp),%edx
  802965:	8b 52 0c             	mov    0xc(%edx),%edx
  802968:	01 ca                	add    %ecx,%edx
  80296a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  80296d:	8b 45 08             	mov    0x8(%ebp),%eax
  802970:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802977:	8b 45 08             	mov    0x8(%ebp),%eax
  80297a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802981:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802985:	75 17                	jne    80299e <insert_sorted_with_merge_freeList+0x2f7>
  802987:	83 ec 04             	sub    $0x4,%esp
  80298a:	68 94 39 80 00       	push   $0x803994
  80298f:	68 ff 00 00 00       	push   $0xff
  802994:	68 b7 39 80 00       	push   $0x8039b7
  802999:	e8 95 05 00 00       	call   802f33 <_panic>
  80299e:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8029a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029a7:	89 10                	mov    %edx,(%eax)
  8029a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ac:	8b 00                	mov    (%eax),%eax
  8029ae:	85 c0                	test   %eax,%eax
  8029b0:	74 0d                	je     8029bf <insert_sorted_with_merge_freeList+0x318>
  8029b2:	a1 48 41 80 00       	mov    0x804148,%eax
  8029b7:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ba:	89 50 04             	mov    %edx,0x4(%eax)
  8029bd:	eb 08                	jmp    8029c7 <insert_sorted_with_merge_freeList+0x320>
  8029bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029c2:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8029c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ca:	a3 48 41 80 00       	mov    %eax,0x804148
  8029cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8029d2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029d9:	a1 54 41 80 00       	mov    0x804154,%eax
  8029de:	40                   	inc    %eax
  8029df:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  8029e4:	e9 93 04 00 00       	jmp    802e7c <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  8029e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ec:	8b 50 08             	mov    0x8(%eax),%edx
  8029ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8029f5:	01 c2                	add    %eax,%edx
  8029f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8029fa:	8b 40 08             	mov    0x8(%eax),%eax
  8029fd:	39 c2                	cmp    %eax,%edx
  8029ff:	0f 85 ae 00 00 00    	jne    802ab3 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802a05:	8b 45 08             	mov    0x8(%ebp),%eax
  802a08:	8b 50 0c             	mov    0xc(%eax),%edx
  802a0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0e:	8b 40 08             	mov    0x8(%eax),%eax
  802a11:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	8b 00                	mov    (%eax),%eax
  802a18:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802a1b:	39 c2                	cmp    %eax,%edx
  802a1d:	0f 84 90 00 00 00    	je     802ab3 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802a23:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a26:	8b 50 0c             	mov    0xc(%eax),%edx
  802a29:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2c:	8b 40 0c             	mov    0xc(%eax),%eax
  802a2f:	01 c2                	add    %eax,%edx
  802a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a34:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802a37:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802a41:	8b 45 08             	mov    0x8(%ebp),%eax
  802a44:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802a4b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a4f:	75 17                	jne    802a68 <insert_sorted_with_merge_freeList+0x3c1>
  802a51:	83 ec 04             	sub    $0x4,%esp
  802a54:	68 94 39 80 00       	push   $0x803994
  802a59:	68 0b 01 00 00       	push   $0x10b
  802a5e:	68 b7 39 80 00       	push   $0x8039b7
  802a63:	e8 cb 04 00 00       	call   802f33 <_panic>
  802a68:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a71:	89 10                	mov    %edx,(%eax)
  802a73:	8b 45 08             	mov    0x8(%ebp),%eax
  802a76:	8b 00                	mov    (%eax),%eax
  802a78:	85 c0                	test   %eax,%eax
  802a7a:	74 0d                	je     802a89 <insert_sorted_with_merge_freeList+0x3e2>
  802a7c:	a1 48 41 80 00       	mov    0x804148,%eax
  802a81:	8b 55 08             	mov    0x8(%ebp),%edx
  802a84:	89 50 04             	mov    %edx,0x4(%eax)
  802a87:	eb 08                	jmp    802a91 <insert_sorted_with_merge_freeList+0x3ea>
  802a89:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8c:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802a91:	8b 45 08             	mov    0x8(%ebp),%eax
  802a94:	a3 48 41 80 00       	mov    %eax,0x804148
  802a99:	8b 45 08             	mov    0x8(%ebp),%eax
  802a9c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aa3:	a1 54 41 80 00       	mov    0x804154,%eax
  802aa8:	40                   	inc    %eax
  802aa9:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802aae:	e9 c9 03 00 00       	jmp    802e7c <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802ab3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab6:	8b 50 0c             	mov    0xc(%eax),%edx
  802ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  802abc:	8b 40 08             	mov    0x8(%eax),%eax
  802abf:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802ac1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac4:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802ac7:	39 c2                	cmp    %eax,%edx
  802ac9:	0f 85 bb 00 00 00    	jne    802b8a <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802acf:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad3:	0f 84 b1 00 00 00    	je     802b8a <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802ad9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802adc:	8b 40 04             	mov    0x4(%eax),%eax
  802adf:	85 c0                	test   %eax,%eax
  802ae1:	0f 85 a3 00 00 00    	jne    802b8a <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802ae7:	a1 38 41 80 00       	mov    0x804138,%eax
  802aec:	8b 55 08             	mov    0x8(%ebp),%edx
  802aef:	8b 52 08             	mov    0x8(%edx),%edx
  802af2:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802af5:	a1 38 41 80 00       	mov    0x804138,%eax
  802afa:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802b00:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802b03:	8b 55 08             	mov    0x8(%ebp),%edx
  802b06:	8b 52 0c             	mov    0xc(%edx),%edx
  802b09:	01 ca                	add    %ecx,%edx
  802b0b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802b0e:	8b 45 08             	mov    0x8(%ebp),%eax
  802b11:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802b18:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802b22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b26:	75 17                	jne    802b3f <insert_sorted_with_merge_freeList+0x498>
  802b28:	83 ec 04             	sub    $0x4,%esp
  802b2b:	68 94 39 80 00       	push   $0x803994
  802b30:	68 17 01 00 00       	push   $0x117
  802b35:	68 b7 39 80 00       	push   $0x8039b7
  802b3a:	e8 f4 03 00 00       	call   802f33 <_panic>
  802b3f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802b45:	8b 45 08             	mov    0x8(%ebp),%eax
  802b48:	89 10                	mov    %edx,(%eax)
  802b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b4d:	8b 00                	mov    (%eax),%eax
  802b4f:	85 c0                	test   %eax,%eax
  802b51:	74 0d                	je     802b60 <insert_sorted_with_merge_freeList+0x4b9>
  802b53:	a1 48 41 80 00       	mov    0x804148,%eax
  802b58:	8b 55 08             	mov    0x8(%ebp),%edx
  802b5b:	89 50 04             	mov    %edx,0x4(%eax)
  802b5e:	eb 08                	jmp    802b68 <insert_sorted_with_merge_freeList+0x4c1>
  802b60:	8b 45 08             	mov    0x8(%ebp),%eax
  802b63:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802b68:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6b:	a3 48 41 80 00       	mov    %eax,0x804148
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b7a:	a1 54 41 80 00       	mov    0x804154,%eax
  802b7f:	40                   	inc    %eax
  802b80:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802b85:	e9 f2 02 00 00       	jmp    802e7c <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802b8a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8d:	8b 50 08             	mov    0x8(%eax),%edx
  802b90:	8b 45 08             	mov    0x8(%ebp),%eax
  802b93:	8b 40 0c             	mov    0xc(%eax),%eax
  802b96:	01 c2                	add    %eax,%edx
  802b98:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9b:	8b 40 08             	mov    0x8(%eax),%eax
  802b9e:	39 c2                	cmp    %eax,%edx
  802ba0:	0f 85 be 00 00 00    	jne    802c64 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 40 04             	mov    0x4(%eax),%eax
  802bac:	8b 50 08             	mov    0x8(%eax),%edx
  802baf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb2:	8b 40 04             	mov    0x4(%eax),%eax
  802bb5:	8b 40 0c             	mov    0xc(%eax),%eax
  802bb8:	01 c2                	add    %eax,%edx
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	8b 40 08             	mov    0x8(%eax),%eax
  802bc0:	39 c2                	cmp    %eax,%edx
  802bc2:	0f 84 9c 00 00 00    	je     802c64 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802bc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802bcb:	8b 50 08             	mov    0x8(%eax),%edx
  802bce:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd1:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802bd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bd7:	8b 50 0c             	mov    0xc(%eax),%edx
  802bda:	8b 45 08             	mov    0x8(%ebp),%eax
  802bdd:	8b 40 0c             	mov    0xc(%eax),%eax
  802be0:	01 c2                	add    %eax,%edx
  802be2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be5:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802be8:	8b 45 08             	mov    0x8(%ebp),%eax
  802beb:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802bfc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c00:	75 17                	jne    802c19 <insert_sorted_with_merge_freeList+0x572>
  802c02:	83 ec 04             	sub    $0x4,%esp
  802c05:	68 94 39 80 00       	push   $0x803994
  802c0a:	68 26 01 00 00       	push   $0x126
  802c0f:	68 b7 39 80 00       	push   $0x8039b7
  802c14:	e8 1a 03 00 00       	call   802f33 <_panic>
  802c19:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802c22:	89 10                	mov    %edx,(%eax)
  802c24:	8b 45 08             	mov    0x8(%ebp),%eax
  802c27:	8b 00                	mov    (%eax),%eax
  802c29:	85 c0                	test   %eax,%eax
  802c2b:	74 0d                	je     802c3a <insert_sorted_with_merge_freeList+0x593>
  802c2d:	a1 48 41 80 00       	mov    0x804148,%eax
  802c32:	8b 55 08             	mov    0x8(%ebp),%edx
  802c35:	89 50 04             	mov    %edx,0x4(%eax)
  802c38:	eb 08                	jmp    802c42 <insert_sorted_with_merge_freeList+0x59b>
  802c3a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c3d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c42:	8b 45 08             	mov    0x8(%ebp),%eax
  802c45:	a3 48 41 80 00       	mov    %eax,0x804148
  802c4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c54:	a1 54 41 80 00       	mov    0x804154,%eax
  802c59:	40                   	inc    %eax
  802c5a:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802c5f:	e9 18 02 00 00       	jmp    802e7c <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802c64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c67:	8b 50 0c             	mov    0xc(%eax),%edx
  802c6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6d:	8b 40 08             	mov    0x8(%eax),%eax
  802c70:	01 c2                	add    %eax,%edx
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	8b 40 08             	mov    0x8(%eax),%eax
  802c78:	39 c2                	cmp    %eax,%edx
  802c7a:	0f 85 c4 01 00 00    	jne    802e44 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802c80:	8b 45 08             	mov    0x8(%ebp),%eax
  802c83:	8b 50 0c             	mov    0xc(%eax),%edx
  802c86:	8b 45 08             	mov    0x8(%ebp),%eax
  802c89:	8b 40 08             	mov    0x8(%eax),%eax
  802c8c:	01 c2                	add    %eax,%edx
  802c8e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c91:	8b 00                	mov    (%eax),%eax
  802c93:	8b 40 08             	mov    0x8(%eax),%eax
  802c96:	39 c2                	cmp    %eax,%edx
  802c98:	0f 85 a6 01 00 00    	jne    802e44 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802c9e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ca2:	0f 84 9c 01 00 00    	je     802e44 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802ca8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cab:	8b 50 0c             	mov    0xc(%eax),%edx
  802cae:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb1:	8b 40 0c             	mov    0xc(%eax),%eax
  802cb4:	01 c2                	add    %eax,%edx
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	8b 40 0c             	mov    0xc(%eax),%eax
  802cbe:	01 c2                	add    %eax,%edx
  802cc0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc3:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802cc6:	8b 45 08             	mov    0x8(%ebp),%eax
  802cc9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802cda:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cde:	75 17                	jne    802cf7 <insert_sorted_with_merge_freeList+0x650>
  802ce0:	83 ec 04             	sub    $0x4,%esp
  802ce3:	68 94 39 80 00       	push   $0x803994
  802ce8:	68 32 01 00 00       	push   $0x132
  802ced:	68 b7 39 80 00       	push   $0x8039b7
  802cf2:	e8 3c 02 00 00       	call   802f33 <_panic>
  802cf7:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802cfd:	8b 45 08             	mov    0x8(%ebp),%eax
  802d00:	89 10                	mov    %edx,(%eax)
  802d02:	8b 45 08             	mov    0x8(%ebp),%eax
  802d05:	8b 00                	mov    (%eax),%eax
  802d07:	85 c0                	test   %eax,%eax
  802d09:	74 0d                	je     802d18 <insert_sorted_with_merge_freeList+0x671>
  802d0b:	a1 48 41 80 00       	mov    0x804148,%eax
  802d10:	8b 55 08             	mov    0x8(%ebp),%edx
  802d13:	89 50 04             	mov    %edx,0x4(%eax)
  802d16:	eb 08                	jmp    802d20 <insert_sorted_with_merge_freeList+0x679>
  802d18:	8b 45 08             	mov    0x8(%ebp),%eax
  802d1b:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d20:	8b 45 08             	mov    0x8(%ebp),%eax
  802d23:	a3 48 41 80 00       	mov    %eax,0x804148
  802d28:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d32:	a1 54 41 80 00       	mov    0x804154,%eax
  802d37:	40                   	inc    %eax
  802d38:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802d3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d40:	8b 00                	mov    (%eax),%eax
  802d42:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802d49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d4c:	8b 00                	mov    (%eax),%eax
  802d4e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802d55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d58:	8b 00                	mov    (%eax),%eax
  802d5a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  802d5d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802d61:	75 17                	jne    802d7a <insert_sorted_with_merge_freeList+0x6d3>
  802d63:	83 ec 04             	sub    $0x4,%esp
  802d66:	68 29 3a 80 00       	push   $0x803a29
  802d6b:	68 36 01 00 00       	push   $0x136
  802d70:	68 b7 39 80 00       	push   $0x8039b7
  802d75:	e8 b9 01 00 00       	call   802f33 <_panic>
  802d7a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d7d:	8b 00                	mov    (%eax),%eax
  802d7f:	85 c0                	test   %eax,%eax
  802d81:	74 10                	je     802d93 <insert_sorted_with_merge_freeList+0x6ec>
  802d83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d86:	8b 00                	mov    (%eax),%eax
  802d88:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802d8b:	8b 52 04             	mov    0x4(%edx),%edx
  802d8e:	89 50 04             	mov    %edx,0x4(%eax)
  802d91:	eb 0b                	jmp    802d9e <insert_sorted_with_merge_freeList+0x6f7>
  802d93:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d96:	8b 40 04             	mov    0x4(%eax),%eax
  802d99:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802d9e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802da1:	8b 40 04             	mov    0x4(%eax),%eax
  802da4:	85 c0                	test   %eax,%eax
  802da6:	74 0f                	je     802db7 <insert_sorted_with_merge_freeList+0x710>
  802da8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dab:	8b 40 04             	mov    0x4(%eax),%eax
  802dae:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802db1:	8b 12                	mov    (%edx),%edx
  802db3:	89 10                	mov    %edx,(%eax)
  802db5:	eb 0a                	jmp    802dc1 <insert_sorted_with_merge_freeList+0x71a>
  802db7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dba:	8b 00                	mov    (%eax),%eax
  802dbc:	a3 38 41 80 00       	mov    %eax,0x804138
  802dc1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dc4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802dca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802dcd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dd4:	a1 44 41 80 00       	mov    0x804144,%eax
  802dd9:	48                   	dec    %eax
  802dda:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  802ddf:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802de3:	75 17                	jne    802dfc <insert_sorted_with_merge_freeList+0x755>
  802de5:	83 ec 04             	sub    $0x4,%esp
  802de8:	68 94 39 80 00       	push   $0x803994
  802ded:	68 37 01 00 00       	push   $0x137
  802df2:	68 b7 39 80 00       	push   $0x8039b7
  802df7:	e8 37 01 00 00       	call   802f33 <_panic>
  802dfc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802e02:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e05:	89 10                	mov    %edx,(%eax)
  802e07:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e0a:	8b 00                	mov    (%eax),%eax
  802e0c:	85 c0                	test   %eax,%eax
  802e0e:	74 0d                	je     802e1d <insert_sorted_with_merge_freeList+0x776>
  802e10:	a1 48 41 80 00       	mov    0x804148,%eax
  802e15:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802e18:	89 50 04             	mov    %edx,0x4(%eax)
  802e1b:	eb 08                	jmp    802e25 <insert_sorted_with_merge_freeList+0x77e>
  802e1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e20:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e28:	a3 48 41 80 00       	mov    %eax,0x804148
  802e2d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e30:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e37:	a1 54 41 80 00       	mov    0x804154,%eax
  802e3c:	40                   	inc    %eax
  802e3d:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  802e42:	eb 38                	jmp    802e7c <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802e44:	a1 40 41 80 00       	mov    0x804140,%eax
  802e49:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e4c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e50:	74 07                	je     802e59 <insert_sorted_with_merge_freeList+0x7b2>
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	8b 00                	mov    (%eax),%eax
  802e57:	eb 05                	jmp    802e5e <insert_sorted_with_merge_freeList+0x7b7>
  802e59:	b8 00 00 00 00       	mov    $0x0,%eax
  802e5e:	a3 40 41 80 00       	mov    %eax,0x804140
  802e63:	a1 40 41 80 00       	mov    0x804140,%eax
  802e68:	85 c0                	test   %eax,%eax
  802e6a:	0f 85 ef f9 ff ff    	jne    80285f <insert_sorted_with_merge_freeList+0x1b8>
  802e70:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e74:	0f 85 e5 f9 ff ff    	jne    80285f <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  802e7a:	eb 00                	jmp    802e7c <insert_sorted_with_merge_freeList+0x7d5>
  802e7c:	90                   	nop
  802e7d:	c9                   	leave  
  802e7e:	c3                   	ret    

00802e7f <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802e7f:	55                   	push   %ebp
  802e80:	89 e5                	mov    %esp,%ebp
  802e82:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  802e85:	8b 55 08             	mov    0x8(%ebp),%edx
  802e88:	89 d0                	mov    %edx,%eax
  802e8a:	c1 e0 02             	shl    $0x2,%eax
  802e8d:	01 d0                	add    %edx,%eax
  802e8f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e96:	01 d0                	add    %edx,%eax
  802e98:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802e9f:	01 d0                	add    %edx,%eax
  802ea1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802ea8:	01 d0                	add    %edx,%eax
  802eaa:	c1 e0 04             	shl    $0x4,%eax
  802ead:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802eb0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  802eb7:	8d 45 e8             	lea    -0x18(%ebp),%eax
  802eba:	83 ec 0c             	sub    $0xc,%esp
  802ebd:	50                   	push   %eax
  802ebe:	e8 21 ec ff ff       	call   801ae4 <sys_get_virtual_time>
  802ec3:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  802ec6:	eb 41                	jmp    802f09 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  802ec8:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802ecb:	83 ec 0c             	sub    $0xc,%esp
  802ece:	50                   	push   %eax
  802ecf:	e8 10 ec ff ff       	call   801ae4 <sys_get_virtual_time>
  802ed4:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  802ed7:	8b 55 e0             	mov    -0x20(%ebp),%edx
  802eda:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802edd:	29 c2                	sub    %eax,%edx
  802edf:	89 d0                	mov    %edx,%eax
  802ee1:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802ee4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  802ee7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802eea:	89 d1                	mov    %edx,%ecx
  802eec:	29 c1                	sub    %eax,%ecx
  802eee:	8b 55 d8             	mov    -0x28(%ebp),%edx
  802ef1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  802ef4:	39 c2                	cmp    %eax,%edx
  802ef6:	0f 97 c0             	seta   %al
  802ef9:	0f b6 c0             	movzbl %al,%eax
  802efc:	29 c1                	sub    %eax,%ecx
  802efe:	89 c8                	mov    %ecx,%eax
  802f00:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  802f03:	8b 45 d8             	mov    -0x28(%ebp),%eax
  802f06:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  802f09:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  802f0f:	72 b7                	jb     802ec8 <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  802f11:	90                   	nop
  802f12:	c9                   	leave  
  802f13:	c3                   	ret    

00802f14 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  802f14:	55                   	push   %ebp
  802f15:	89 e5                	mov    %esp,%ebp
  802f17:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  802f1a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  802f21:	eb 03                	jmp    802f26 <busy_wait+0x12>
  802f23:	ff 45 fc             	incl   -0x4(%ebp)
  802f26:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802f29:	3b 45 08             	cmp    0x8(%ebp),%eax
  802f2c:	72 f5                	jb     802f23 <busy_wait+0xf>
	return i;
  802f2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802f31:	c9                   	leave  
  802f32:	c3                   	ret    

00802f33 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  802f33:	55                   	push   %ebp
  802f34:	89 e5                	mov    %esp,%ebp
  802f36:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  802f39:	8d 45 10             	lea    0x10(%ebp),%eax
  802f3c:	83 c0 04             	add    $0x4,%eax
  802f3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  802f42:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802f47:	85 c0                	test   %eax,%eax
  802f49:	74 16                	je     802f61 <_panic+0x2e>
		cprintf("%s: ", argv0);
  802f4b:	a1 5c 41 80 00       	mov    0x80415c,%eax
  802f50:	83 ec 08             	sub    $0x8,%esp
  802f53:	50                   	push   %eax
  802f54:	68 7c 3a 80 00       	push   $0x803a7c
  802f59:	e8 1d d4 ff ff       	call   80037b <cprintf>
  802f5e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  802f61:	a1 00 40 80 00       	mov    0x804000,%eax
  802f66:	ff 75 0c             	pushl  0xc(%ebp)
  802f69:	ff 75 08             	pushl  0x8(%ebp)
  802f6c:	50                   	push   %eax
  802f6d:	68 81 3a 80 00       	push   $0x803a81
  802f72:	e8 04 d4 ff ff       	call   80037b <cprintf>
  802f77:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  802f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  802f7d:	83 ec 08             	sub    $0x8,%esp
  802f80:	ff 75 f4             	pushl  -0xc(%ebp)
  802f83:	50                   	push   %eax
  802f84:	e8 87 d3 ff ff       	call   800310 <vcprintf>
  802f89:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  802f8c:	83 ec 08             	sub    $0x8,%esp
  802f8f:	6a 00                	push   $0x0
  802f91:	68 9d 3a 80 00       	push   $0x803a9d
  802f96:	e8 75 d3 ff ff       	call   800310 <vcprintf>
  802f9b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  802f9e:	e8 f6 d2 ff ff       	call   800299 <exit>

	// should not return here
	while (1) ;
  802fa3:	eb fe                	jmp    802fa3 <_panic+0x70>

00802fa5 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  802fa5:	55                   	push   %ebp
  802fa6:	89 e5                	mov    %esp,%ebp
  802fa8:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  802fab:	a1 20 40 80 00       	mov    0x804020,%eax
  802fb0:	8b 50 74             	mov    0x74(%eax),%edx
  802fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  802fb6:	39 c2                	cmp    %eax,%edx
  802fb8:	74 14                	je     802fce <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  802fba:	83 ec 04             	sub    $0x4,%esp
  802fbd:	68 a0 3a 80 00       	push   $0x803aa0
  802fc2:	6a 26                	push   $0x26
  802fc4:	68 ec 3a 80 00       	push   $0x803aec
  802fc9:	e8 65 ff ff ff       	call   802f33 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  802fce:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  802fd5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802fdc:	e9 c2 00 00 00       	jmp    8030a3 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  802fe1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fe4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802feb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fee:	01 d0                	add    %edx,%eax
  802ff0:	8b 00                	mov    (%eax),%eax
  802ff2:	85 c0                	test   %eax,%eax
  802ff4:	75 08                	jne    802ffe <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  802ff6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  802ff9:	e9 a2 00 00 00       	jmp    8030a0 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  802ffe:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803005:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80300c:	eb 69                	jmp    803077 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80300e:	a1 20 40 80 00       	mov    0x804020,%eax
  803013:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803019:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80301c:	89 d0                	mov    %edx,%eax
  80301e:	01 c0                	add    %eax,%eax
  803020:	01 d0                	add    %edx,%eax
  803022:	c1 e0 03             	shl    $0x3,%eax
  803025:	01 c8                	add    %ecx,%eax
  803027:	8a 40 04             	mov    0x4(%eax),%al
  80302a:	84 c0                	test   %al,%al
  80302c:	75 46                	jne    803074 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80302e:	a1 20 40 80 00       	mov    0x804020,%eax
  803033:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  803039:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80303c:	89 d0                	mov    %edx,%eax
  80303e:	01 c0                	add    %eax,%eax
  803040:	01 d0                	add    %edx,%eax
  803042:	c1 e0 03             	shl    $0x3,%eax
  803045:	01 c8                	add    %ecx,%eax
  803047:	8b 00                	mov    (%eax),%eax
  803049:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80304c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80304f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  803054:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  803056:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803059:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  803060:	8b 45 08             	mov    0x8(%ebp),%eax
  803063:	01 c8                	add    %ecx,%eax
  803065:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  803067:	39 c2                	cmp    %eax,%edx
  803069:	75 09                	jne    803074 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80306b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  803072:	eb 12                	jmp    803086 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  803074:	ff 45 e8             	incl   -0x18(%ebp)
  803077:	a1 20 40 80 00       	mov    0x804020,%eax
  80307c:	8b 50 74             	mov    0x74(%eax),%edx
  80307f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803082:	39 c2                	cmp    %eax,%edx
  803084:	77 88                	ja     80300e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  803086:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80308a:	75 14                	jne    8030a0 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80308c:	83 ec 04             	sub    $0x4,%esp
  80308f:	68 f8 3a 80 00       	push   $0x803af8
  803094:	6a 3a                	push   $0x3a
  803096:	68 ec 3a 80 00       	push   $0x803aec
  80309b:	e8 93 fe ff ff       	call   802f33 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8030a0:	ff 45 f0             	incl   -0x10(%ebp)
  8030a3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8030a6:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8030a9:	0f 8c 32 ff ff ff    	jl     802fe1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8030af:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030b6:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8030bd:	eb 26                	jmp    8030e5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8030bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8030c4:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8030ca:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8030cd:	89 d0                	mov    %edx,%eax
  8030cf:	01 c0                	add    %eax,%eax
  8030d1:	01 d0                	add    %edx,%eax
  8030d3:	c1 e0 03             	shl    $0x3,%eax
  8030d6:	01 c8                	add    %ecx,%eax
  8030d8:	8a 40 04             	mov    0x4(%eax),%al
  8030db:	3c 01                	cmp    $0x1,%al
  8030dd:	75 03                	jne    8030e2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8030df:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8030e2:	ff 45 e0             	incl   -0x20(%ebp)
  8030e5:	a1 20 40 80 00       	mov    0x804020,%eax
  8030ea:	8b 50 74             	mov    0x74(%eax),%edx
  8030ed:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8030f0:	39 c2                	cmp    %eax,%edx
  8030f2:	77 cb                	ja     8030bf <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8030f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8030fa:	74 14                	je     803110 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8030fc:	83 ec 04             	sub    $0x4,%esp
  8030ff:	68 4c 3b 80 00       	push   $0x803b4c
  803104:	6a 44                	push   $0x44
  803106:	68 ec 3a 80 00       	push   $0x803aec
  80310b:	e8 23 fe ff ff       	call   802f33 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  803110:	90                   	nop
  803111:	c9                   	leave  
  803112:	c3                   	ret    
  803113:	90                   	nop

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
