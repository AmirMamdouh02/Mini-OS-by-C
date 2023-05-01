
obj/user/ef_tst_semaphore_1master:     file format elf32-i386


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
  800031:	e8 f8 01 00 00       	call   80022e <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
// Master program: create the semaphores, run slaves and wait them to finish
#include <inc/lib.h>

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 28             	sub    $0x28,%esp
	int envID = sys_getenvid();
  80003e:	e8 df 1c 00 00       	call   801d22 <sys_getenvid>
  800043:	89 45 f4             	mov    %eax,-0xc(%ebp)

	sys_createSemaphore("cs1", 1);
  800046:	83 ec 08             	sub    $0x8,%esp
  800049:	6a 01                	push   $0x1
  80004b:	68 a0 33 80 00       	push   $0x8033a0
  800050:	e8 67 1b 00 00       	call   801bbc <sys_createSemaphore>
  800055:	83 c4 10             	add    $0x10,%esp

	sys_createSemaphore("depend1", 0);
  800058:	83 ec 08             	sub    $0x8,%esp
  80005b:	6a 00                	push   $0x0
  80005d:	68 a4 33 80 00       	push   $0x8033a4
  800062:	e8 55 1b 00 00       	call   801bbc <sys_createSemaphore>
  800067:	83 c4 10             	add    $0x10,%esp

	int id1, id2, id3;
	id1 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  80006a:	a1 20 40 80 00       	mov    0x804020,%eax
  80006f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800075:	89 c2                	mov    %eax,%edx
  800077:	a1 20 40 80 00       	mov    0x804020,%eax
  80007c:	8b 40 74             	mov    0x74(%eax),%eax
  80007f:	6a 32                	push   $0x32
  800081:	52                   	push   %edx
  800082:	50                   	push   %eax
  800083:	68 ac 33 80 00       	push   $0x8033ac
  800088:	e8 40 1c 00 00       	call   801ccd <sys_create_env>
  80008d:	83 c4 10             	add    $0x10,%esp
  800090:	89 45 f0             	mov    %eax,-0x10(%ebp)
	id2 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  800093:	a1 20 40 80 00       	mov    0x804020,%eax
  800098:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80009e:	89 c2                	mov    %eax,%edx
  8000a0:	a1 20 40 80 00       	mov    0x804020,%eax
  8000a5:	8b 40 74             	mov    0x74(%eax),%eax
  8000a8:	6a 32                	push   $0x32
  8000aa:	52                   	push   %edx
  8000ab:	50                   	push   %eax
  8000ac:	68 ac 33 80 00       	push   $0x8033ac
  8000b1:	e8 17 1c 00 00       	call   801ccd <sys_create_env>
  8000b6:	83 c4 10             	add    $0x10,%esp
  8000b9:	89 45 ec             	mov    %eax,-0x14(%ebp)
	id3 = sys_create_env("ef_sem1Slave", (myEnv->page_WS_max_size),(myEnv->SecondListSize), 50);
  8000bc:	a1 20 40 80 00       	mov    0x804020,%eax
  8000c1:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000c7:	89 c2                	mov    %eax,%edx
  8000c9:	a1 20 40 80 00       	mov    0x804020,%eax
  8000ce:	8b 40 74             	mov    0x74(%eax),%eax
  8000d1:	6a 32                	push   $0x32
  8000d3:	52                   	push   %edx
  8000d4:	50                   	push   %eax
  8000d5:	68 ac 33 80 00       	push   $0x8033ac
  8000da:	e8 ee 1b 00 00       	call   801ccd <sys_create_env>
  8000df:	83 c4 10             	add    $0x10,%esp
  8000e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
	if (id1 == E_ENV_CREATION_ERROR || id2 == E_ENV_CREATION_ERROR || id3 == E_ENV_CREATION_ERROR)
  8000e5:	83 7d f0 ef          	cmpl   $0xffffffef,-0x10(%ebp)
  8000e9:	74 0c                	je     8000f7 <_main+0xbf>
  8000eb:	83 7d ec ef          	cmpl   $0xffffffef,-0x14(%ebp)
  8000ef:	74 06                	je     8000f7 <_main+0xbf>
  8000f1:	83 7d e8 ef          	cmpl   $0xffffffef,-0x18(%ebp)
  8000f5:	75 14                	jne    80010b <_main+0xd3>
		panic("NO AVAILABLE ENVs...");
  8000f7:	83 ec 04             	sub    $0x4,%esp
  8000fa:	68 b9 33 80 00       	push   $0x8033b9
  8000ff:	6a 13                	push   $0x13
  800101:	68 d0 33 80 00       	push   $0x8033d0
  800106:	e8 5f 02 00 00       	call   80036a <_panic>

	sys_run_env(id1);
  80010b:	83 ec 0c             	sub    $0xc,%esp
  80010e:	ff 75 f0             	pushl  -0x10(%ebp)
  800111:	e8 d5 1b 00 00       	call   801ceb <sys_run_env>
  800116:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id2);
  800119:	83 ec 0c             	sub    $0xc,%esp
  80011c:	ff 75 ec             	pushl  -0x14(%ebp)
  80011f:	e8 c7 1b 00 00       	call   801ceb <sys_run_env>
  800124:	83 c4 10             	add    $0x10,%esp
	sys_run_env(id3);
  800127:	83 ec 0c             	sub    $0xc,%esp
  80012a:	ff 75 e8             	pushl  -0x18(%ebp)
  80012d:	e8 b9 1b 00 00       	call   801ceb <sys_run_env>
  800132:	83 c4 10             	add    $0x10,%esp

	sys_waitSemaphore(envID, "depend1") ;
  800135:	83 ec 08             	sub    $0x8,%esp
  800138:	68 a4 33 80 00       	push   $0x8033a4
  80013d:	ff 75 f4             	pushl  -0xc(%ebp)
  800140:	e8 b0 1a 00 00       	call   801bf5 <sys_waitSemaphore>
  800145:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  800148:	83 ec 08             	sub    $0x8,%esp
  80014b:	68 a4 33 80 00       	push   $0x8033a4
  800150:	ff 75 f4             	pushl  -0xc(%ebp)
  800153:	e8 9d 1a 00 00       	call   801bf5 <sys_waitSemaphore>
  800158:	83 c4 10             	add    $0x10,%esp
	sys_waitSemaphore(envID, "depend1") ;
  80015b:	83 ec 08             	sub    $0x8,%esp
  80015e:	68 a4 33 80 00       	push   $0x8033a4
  800163:	ff 75 f4             	pushl  -0xc(%ebp)
  800166:	e8 8a 1a 00 00       	call   801bf5 <sys_waitSemaphore>
  80016b:	83 c4 10             	add    $0x10,%esp

	int sem1val = sys_getSemaphoreValue(envID, "cs1");
  80016e:	83 ec 08             	sub    $0x8,%esp
  800171:	68 a0 33 80 00       	push   $0x8033a0
  800176:	ff 75 f4             	pushl  -0xc(%ebp)
  800179:	e8 5a 1a 00 00       	call   801bd8 <sys_getSemaphoreValue>
  80017e:	83 c4 10             	add    $0x10,%esp
  800181:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int sem2val = sys_getSemaphoreValue(envID, "depend1");
  800184:	83 ec 08             	sub    $0x8,%esp
  800187:	68 a4 33 80 00       	push   $0x8033a4
  80018c:	ff 75 f4             	pushl  -0xc(%ebp)
  80018f:	e8 44 1a 00 00       	call   801bd8 <sys_getSemaphoreValue>
  800194:	83 c4 10             	add    $0x10,%esp
  800197:	89 45 e0             	mov    %eax,-0x20(%ebp)
	if (sem2val == 0 && sem1val == 1)
  80019a:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80019e:	75 18                	jne    8001b8 <_main+0x180>
  8001a0:	83 7d e4 01          	cmpl   $0x1,-0x1c(%ebp)
  8001a4:	75 12                	jne    8001b8 <_main+0x180>
		cprintf("Congratulations!! Test of Semaphores [1] completed successfully!!\n\n\n");
  8001a6:	83 ec 0c             	sub    $0xc,%esp
  8001a9:	68 f0 33 80 00       	push   $0x8033f0
  8001ae:	e8 6b 04 00 00       	call   80061e <cprintf>
  8001b3:	83 c4 10             	add    $0x10,%esp
  8001b6:	eb 10                	jmp    8001c8 <_main+0x190>
	else
		cprintf("Error: wrong semaphore value... please review your semaphore code again...");
  8001b8:	83 ec 0c             	sub    $0xc,%esp
  8001bb:	68 38 34 80 00       	push   $0x803438
  8001c0:	e8 59 04 00 00       	call   80061e <cprintf>
  8001c5:	83 c4 10             	add    $0x10,%esp

	int32 parentenvID = sys_getparentenvid();
  8001c8:	e8 87 1b 00 00       	call   801d54 <sys_getparentenvid>
  8001cd:	89 45 dc             	mov    %eax,-0x24(%ebp)
	if(parentenvID > 0)
  8001d0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8001d4:	7e 55                	jle    80022b <_main+0x1f3>
	{
		//Get the check-finishing counter
		int *finishedCount = NULL;
  8001d6:	c7 45 d8 00 00 00 00 	movl   $0x0,-0x28(%ebp)
		finishedCount = sget(parentenvID, "finishedCount") ;
  8001dd:	83 ec 08             	sub    $0x8,%esp
  8001e0:	68 83 34 80 00       	push   $0x803483
  8001e5:	ff 75 dc             	pushl  -0x24(%ebp)
  8001e8:	e8 20 16 00 00       	call   80180d <sget>
  8001ed:	83 c4 10             	add    $0x10,%esp
  8001f0:	89 45 d8             	mov    %eax,-0x28(%ebp)
		sys_destroy_env(id1);
  8001f3:	83 ec 0c             	sub    $0xc,%esp
  8001f6:	ff 75 f0             	pushl  -0x10(%ebp)
  8001f9:	e8 09 1b 00 00       	call   801d07 <sys_destroy_env>
  8001fe:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id2);
  800201:	83 ec 0c             	sub    $0xc,%esp
  800204:	ff 75 ec             	pushl  -0x14(%ebp)
  800207:	e8 fb 1a 00 00       	call   801d07 <sys_destroy_env>
  80020c:	83 c4 10             	add    $0x10,%esp
		sys_destroy_env(id3);
  80020f:	83 ec 0c             	sub    $0xc,%esp
  800212:	ff 75 e8             	pushl  -0x18(%ebp)
  800215:	e8 ed 1a 00 00       	call   801d07 <sys_destroy_env>
  80021a:	83 c4 10             	add    $0x10,%esp
		(*finishedCount)++ ;
  80021d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800220:	8b 00                	mov    (%eax),%eax
  800222:	8d 50 01             	lea    0x1(%eax),%edx
  800225:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800228:	89 10                	mov    %edx,(%eax)
	}

	return;
  80022a:	90                   	nop
  80022b:	90                   	nop
}
  80022c:	c9                   	leave  
  80022d:	c3                   	ret    

0080022e <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80022e:	55                   	push   %ebp
  80022f:	89 e5                	mov    %esp,%ebp
  800231:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800234:	e8 02 1b 00 00       	call   801d3b <sys_getenvindex>
  800239:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80023c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80023f:	89 d0                	mov    %edx,%eax
  800241:	c1 e0 03             	shl    $0x3,%eax
  800244:	01 d0                	add    %edx,%eax
  800246:	01 c0                	add    %eax,%eax
  800248:	01 d0                	add    %edx,%eax
  80024a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800251:	01 d0                	add    %edx,%eax
  800253:	c1 e0 04             	shl    $0x4,%eax
  800256:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80025b:	a3 20 40 80 00       	mov    %eax,0x804020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800260:	a1 20 40 80 00       	mov    0x804020,%eax
  800265:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80026b:	84 c0                	test   %al,%al
  80026d:	74 0f                	je     80027e <libmain+0x50>
		binaryname = myEnv->prog_name;
  80026f:	a1 20 40 80 00       	mov    0x804020,%eax
  800274:	05 5c 05 00 00       	add    $0x55c,%eax
  800279:	a3 00 40 80 00       	mov    %eax,0x804000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80027e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800282:	7e 0a                	jle    80028e <libmain+0x60>
		binaryname = argv[0];
  800284:	8b 45 0c             	mov    0xc(%ebp),%eax
  800287:	8b 00                	mov    (%eax),%eax
  800289:	a3 00 40 80 00       	mov    %eax,0x804000

	// call user main routine
	_main(argc, argv);
  80028e:	83 ec 08             	sub    $0x8,%esp
  800291:	ff 75 0c             	pushl  0xc(%ebp)
  800294:	ff 75 08             	pushl  0x8(%ebp)
  800297:	e8 9c fd ff ff       	call   800038 <_main>
  80029c:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80029f:	e8 a4 18 00 00       	call   801b48 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8002a4:	83 ec 0c             	sub    $0xc,%esp
  8002a7:	68 ac 34 80 00       	push   $0x8034ac
  8002ac:	e8 6d 03 00 00       	call   80061e <cprintf>
  8002b1:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8002b4:	a1 20 40 80 00       	mov    0x804020,%eax
  8002b9:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8002bf:	a1 20 40 80 00       	mov    0x804020,%eax
  8002c4:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8002ca:	83 ec 04             	sub    $0x4,%esp
  8002cd:	52                   	push   %edx
  8002ce:	50                   	push   %eax
  8002cf:	68 d4 34 80 00       	push   $0x8034d4
  8002d4:	e8 45 03 00 00       	call   80061e <cprintf>
  8002d9:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  8002dc:	a1 20 40 80 00       	mov    0x804020,%eax
  8002e1:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8002e7:	a1 20 40 80 00       	mov    0x804020,%eax
  8002ec:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8002f2:	a1 20 40 80 00       	mov    0x804020,%eax
  8002f7:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8002fd:	51                   	push   %ecx
  8002fe:	52                   	push   %edx
  8002ff:	50                   	push   %eax
  800300:	68 fc 34 80 00       	push   $0x8034fc
  800305:	e8 14 03 00 00       	call   80061e <cprintf>
  80030a:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80030d:	a1 20 40 80 00       	mov    0x804020,%eax
  800312:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800318:	83 ec 08             	sub    $0x8,%esp
  80031b:	50                   	push   %eax
  80031c:	68 54 35 80 00       	push   $0x803554
  800321:	e8 f8 02 00 00       	call   80061e <cprintf>
  800326:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800329:	83 ec 0c             	sub    $0xc,%esp
  80032c:	68 ac 34 80 00       	push   $0x8034ac
  800331:	e8 e8 02 00 00       	call   80061e <cprintf>
  800336:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800339:	e8 24 18 00 00       	call   801b62 <sys_enable_interrupt>

	// exit gracefully
	exit();
  80033e:	e8 19 00 00 00       	call   80035c <exit>
}
  800343:	90                   	nop
  800344:	c9                   	leave  
  800345:	c3                   	ret    

00800346 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800346:	55                   	push   %ebp
  800347:	89 e5                	mov    %esp,%ebp
  800349:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80034c:	83 ec 0c             	sub    $0xc,%esp
  80034f:	6a 00                	push   $0x0
  800351:	e8 b1 19 00 00       	call   801d07 <sys_destroy_env>
  800356:	83 c4 10             	add    $0x10,%esp
}
  800359:	90                   	nop
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <exit>:

void
exit(void)
{
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800362:	e8 06 1a 00 00       	call   801d6d <sys_exit_env>
}
  800367:	90                   	nop
  800368:	c9                   	leave  
  800369:	c3                   	ret    

0080036a <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80036a:	55                   	push   %ebp
  80036b:	89 e5                	mov    %esp,%ebp
  80036d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800370:	8d 45 10             	lea    0x10(%ebp),%eax
  800373:	83 c0 04             	add    $0x4,%eax
  800376:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800379:	a1 5c 41 80 00       	mov    0x80415c,%eax
  80037e:	85 c0                	test   %eax,%eax
  800380:	74 16                	je     800398 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800382:	a1 5c 41 80 00       	mov    0x80415c,%eax
  800387:	83 ec 08             	sub    $0x8,%esp
  80038a:	50                   	push   %eax
  80038b:	68 68 35 80 00       	push   $0x803568
  800390:	e8 89 02 00 00       	call   80061e <cprintf>
  800395:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800398:	a1 00 40 80 00       	mov    0x804000,%eax
  80039d:	ff 75 0c             	pushl  0xc(%ebp)
  8003a0:	ff 75 08             	pushl  0x8(%ebp)
  8003a3:	50                   	push   %eax
  8003a4:	68 6d 35 80 00       	push   $0x80356d
  8003a9:	e8 70 02 00 00       	call   80061e <cprintf>
  8003ae:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8003b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8003b4:	83 ec 08             	sub    $0x8,%esp
  8003b7:	ff 75 f4             	pushl  -0xc(%ebp)
  8003ba:	50                   	push   %eax
  8003bb:	e8 f3 01 00 00       	call   8005b3 <vcprintf>
  8003c0:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8003c3:	83 ec 08             	sub    $0x8,%esp
  8003c6:	6a 00                	push   $0x0
  8003c8:	68 89 35 80 00       	push   $0x803589
  8003cd:	e8 e1 01 00 00       	call   8005b3 <vcprintf>
  8003d2:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  8003d5:	e8 82 ff ff ff       	call   80035c <exit>

	// should not return here
	while (1) ;
  8003da:	eb fe                	jmp    8003da <_panic+0x70>

008003dc <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  8003e2:	a1 20 40 80 00       	mov    0x804020,%eax
  8003e7:	8b 50 74             	mov    0x74(%eax),%edx
  8003ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003ed:	39 c2                	cmp    %eax,%edx
  8003ef:	74 14                	je     800405 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8003f1:	83 ec 04             	sub    $0x4,%esp
  8003f4:	68 8c 35 80 00       	push   $0x80358c
  8003f9:	6a 26                	push   $0x26
  8003fb:	68 d8 35 80 00       	push   $0x8035d8
  800400:	e8 65 ff ff ff       	call   80036a <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800405:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80040c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800413:	e9 c2 00 00 00       	jmp    8004da <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800418:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80041b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800422:	8b 45 08             	mov    0x8(%ebp),%eax
  800425:	01 d0                	add    %edx,%eax
  800427:	8b 00                	mov    (%eax),%eax
  800429:	85 c0                	test   %eax,%eax
  80042b:	75 08                	jne    800435 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  80042d:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800430:	e9 a2 00 00 00       	jmp    8004d7 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800435:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80043c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800443:	eb 69                	jmp    8004ae <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800445:	a1 20 40 80 00       	mov    0x804020,%eax
  80044a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800450:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800453:	89 d0                	mov    %edx,%eax
  800455:	01 c0                	add    %eax,%eax
  800457:	01 d0                	add    %edx,%eax
  800459:	c1 e0 03             	shl    $0x3,%eax
  80045c:	01 c8                	add    %ecx,%eax
  80045e:	8a 40 04             	mov    0x4(%eax),%al
  800461:	84 c0                	test   %al,%al
  800463:	75 46                	jne    8004ab <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800465:	a1 20 40 80 00       	mov    0x804020,%eax
  80046a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800470:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800473:	89 d0                	mov    %edx,%eax
  800475:	01 c0                	add    %eax,%eax
  800477:	01 d0                	add    %edx,%eax
  800479:	c1 e0 03             	shl    $0x3,%eax
  80047c:	01 c8                	add    %ecx,%eax
  80047e:	8b 00                	mov    (%eax),%eax
  800480:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800483:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800486:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80048b:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80048d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800490:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800497:	8b 45 08             	mov    0x8(%ebp),%eax
  80049a:	01 c8                	add    %ecx,%eax
  80049c:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80049e:	39 c2                	cmp    %eax,%edx
  8004a0:	75 09                	jne    8004ab <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8004a2:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8004a9:	eb 12                	jmp    8004bd <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ab:	ff 45 e8             	incl   -0x18(%ebp)
  8004ae:	a1 20 40 80 00       	mov    0x804020,%eax
  8004b3:	8b 50 74             	mov    0x74(%eax),%edx
  8004b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004b9:	39 c2                	cmp    %eax,%edx
  8004bb:	77 88                	ja     800445 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8004bd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8004c1:	75 14                	jne    8004d7 <CheckWSWithoutLastIndex+0xfb>
			panic(
  8004c3:	83 ec 04             	sub    $0x4,%esp
  8004c6:	68 e4 35 80 00       	push   $0x8035e4
  8004cb:	6a 3a                	push   $0x3a
  8004cd:	68 d8 35 80 00       	push   $0x8035d8
  8004d2:	e8 93 fe ff ff       	call   80036a <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  8004d7:	ff 45 f0             	incl   -0x10(%ebp)
  8004da:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004dd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004e0:	0f 8c 32 ff ff ff    	jl     800418 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8004e6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004ed:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8004f4:	eb 26                	jmp    80051c <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8004f6:	a1 20 40 80 00       	mov    0x804020,%eax
  8004fb:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800501:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800504:	89 d0                	mov    %edx,%eax
  800506:	01 c0                	add    %eax,%eax
  800508:	01 d0                	add    %edx,%eax
  80050a:	c1 e0 03             	shl    $0x3,%eax
  80050d:	01 c8                	add    %ecx,%eax
  80050f:	8a 40 04             	mov    0x4(%eax),%al
  800512:	3c 01                	cmp    $0x1,%al
  800514:	75 03                	jne    800519 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800516:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800519:	ff 45 e0             	incl   -0x20(%ebp)
  80051c:	a1 20 40 80 00       	mov    0x804020,%eax
  800521:	8b 50 74             	mov    0x74(%eax),%edx
  800524:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800527:	39 c2                	cmp    %eax,%edx
  800529:	77 cb                	ja     8004f6 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  80052b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80052e:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800531:	74 14                	je     800547 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800533:	83 ec 04             	sub    $0x4,%esp
  800536:	68 38 36 80 00       	push   $0x803638
  80053b:	6a 44                	push   $0x44
  80053d:	68 d8 35 80 00       	push   $0x8035d8
  800542:	e8 23 fe ff ff       	call   80036a <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800550:	8b 45 0c             	mov    0xc(%ebp),%eax
  800553:	8b 00                	mov    (%eax),%eax
  800555:	8d 48 01             	lea    0x1(%eax),%ecx
  800558:	8b 55 0c             	mov    0xc(%ebp),%edx
  80055b:	89 0a                	mov    %ecx,(%edx)
  80055d:	8b 55 08             	mov    0x8(%ebp),%edx
  800560:	88 d1                	mov    %dl,%cl
  800562:	8b 55 0c             	mov    0xc(%ebp),%edx
  800565:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800569:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056c:	8b 00                	mov    (%eax),%eax
  80056e:	3d ff 00 00 00       	cmp    $0xff,%eax
  800573:	75 2c                	jne    8005a1 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800575:	a0 24 40 80 00       	mov    0x804024,%al
  80057a:	0f b6 c0             	movzbl %al,%eax
  80057d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800580:	8b 12                	mov    (%edx),%edx
  800582:	89 d1                	mov    %edx,%ecx
  800584:	8b 55 0c             	mov    0xc(%ebp),%edx
  800587:	83 c2 08             	add    $0x8,%edx
  80058a:	83 ec 04             	sub    $0x4,%esp
  80058d:	50                   	push   %eax
  80058e:	51                   	push   %ecx
  80058f:	52                   	push   %edx
  800590:	e8 05 14 00 00       	call   80199a <sys_cputs>
  800595:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800598:	8b 45 0c             	mov    0xc(%ebp),%eax
  80059b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8005a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a4:	8b 40 04             	mov    0x4(%eax),%eax
  8005a7:	8d 50 01             	lea    0x1(%eax),%edx
  8005aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005ad:	89 50 04             	mov    %edx,0x4(%eax)
}
  8005b0:	90                   	nop
  8005b1:	c9                   	leave  
  8005b2:	c3                   	ret    

008005b3 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8005b3:	55                   	push   %ebp
  8005b4:	89 e5                	mov    %esp,%ebp
  8005b6:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  8005bc:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  8005c3:	00 00 00 
	b.cnt = 0;
  8005c6:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  8005cd:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  8005d0:	ff 75 0c             	pushl  0xc(%ebp)
  8005d3:	ff 75 08             	pushl  0x8(%ebp)
  8005d6:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8005dc:	50                   	push   %eax
  8005dd:	68 4a 05 80 00       	push   $0x80054a
  8005e2:	e8 11 02 00 00       	call   8007f8 <vprintfmt>
  8005e7:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8005ea:	a0 24 40 80 00       	mov    0x804024,%al
  8005ef:	0f b6 c0             	movzbl %al,%eax
  8005f2:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8005f8:	83 ec 04             	sub    $0x4,%esp
  8005fb:	50                   	push   %eax
  8005fc:	52                   	push   %edx
  8005fd:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800603:	83 c0 08             	add    $0x8,%eax
  800606:	50                   	push   %eax
  800607:	e8 8e 13 00 00       	call   80199a <sys_cputs>
  80060c:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80060f:	c6 05 24 40 80 00 00 	movb   $0x0,0x804024
	return b.cnt;
  800616:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80061c:	c9                   	leave  
  80061d:	c3                   	ret    

0080061e <cprintf>:

int cprintf(const char *fmt, ...) {
  80061e:	55                   	push   %ebp
  80061f:	89 e5                	mov    %esp,%ebp
  800621:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800624:	c6 05 24 40 80 00 01 	movb   $0x1,0x804024
	va_start(ap, fmt);
  80062b:	8d 45 0c             	lea    0xc(%ebp),%eax
  80062e:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800631:	8b 45 08             	mov    0x8(%ebp),%eax
  800634:	83 ec 08             	sub    $0x8,%esp
  800637:	ff 75 f4             	pushl  -0xc(%ebp)
  80063a:	50                   	push   %eax
  80063b:	e8 73 ff ff ff       	call   8005b3 <vcprintf>
  800640:	83 c4 10             	add    $0x10,%esp
  800643:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800646:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800649:	c9                   	leave  
  80064a:	c3                   	ret    

0080064b <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  80064b:	55                   	push   %ebp
  80064c:	89 e5                	mov    %esp,%ebp
  80064e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800651:	e8 f2 14 00 00       	call   801b48 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800656:	8d 45 0c             	lea    0xc(%ebp),%eax
  800659:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80065c:	8b 45 08             	mov    0x8(%ebp),%eax
  80065f:	83 ec 08             	sub    $0x8,%esp
  800662:	ff 75 f4             	pushl  -0xc(%ebp)
  800665:	50                   	push   %eax
  800666:	e8 48 ff ff ff       	call   8005b3 <vcprintf>
  80066b:	83 c4 10             	add    $0x10,%esp
  80066e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800671:	e8 ec 14 00 00       	call   801b62 <sys_enable_interrupt>
	return cnt;
  800676:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800679:	c9                   	leave  
  80067a:	c3                   	ret    

0080067b <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80067b:	55                   	push   %ebp
  80067c:	89 e5                	mov    %esp,%ebp
  80067e:	53                   	push   %ebx
  80067f:	83 ec 14             	sub    $0x14,%esp
  800682:	8b 45 10             	mov    0x10(%ebp),%eax
  800685:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800688:	8b 45 14             	mov    0x14(%ebp),%eax
  80068b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80068e:	8b 45 18             	mov    0x18(%ebp),%eax
  800691:	ba 00 00 00 00       	mov    $0x0,%edx
  800696:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800699:	77 55                	ja     8006f0 <printnum+0x75>
  80069b:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80069e:	72 05                	jb     8006a5 <printnum+0x2a>
  8006a0:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8006a3:	77 4b                	ja     8006f0 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8006a5:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8006a8:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8006ab:	8b 45 18             	mov    0x18(%ebp),%eax
  8006ae:	ba 00 00 00 00       	mov    $0x0,%edx
  8006b3:	52                   	push   %edx
  8006b4:	50                   	push   %eax
  8006b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b8:	ff 75 f0             	pushl  -0x10(%ebp)
  8006bb:	e8 64 2a 00 00       	call   803124 <__udivdi3>
  8006c0:	83 c4 10             	add    $0x10,%esp
  8006c3:	83 ec 04             	sub    $0x4,%esp
  8006c6:	ff 75 20             	pushl  0x20(%ebp)
  8006c9:	53                   	push   %ebx
  8006ca:	ff 75 18             	pushl  0x18(%ebp)
  8006cd:	52                   	push   %edx
  8006ce:	50                   	push   %eax
  8006cf:	ff 75 0c             	pushl  0xc(%ebp)
  8006d2:	ff 75 08             	pushl  0x8(%ebp)
  8006d5:	e8 a1 ff ff ff       	call   80067b <printnum>
  8006da:	83 c4 20             	add    $0x20,%esp
  8006dd:	eb 1a                	jmp    8006f9 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  8006df:	83 ec 08             	sub    $0x8,%esp
  8006e2:	ff 75 0c             	pushl  0xc(%ebp)
  8006e5:	ff 75 20             	pushl  0x20(%ebp)
  8006e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006eb:	ff d0                	call   *%eax
  8006ed:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8006f0:	ff 4d 1c             	decl   0x1c(%ebp)
  8006f3:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8006f7:	7f e6                	jg     8006df <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8006f9:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8006fc:	bb 00 00 00 00       	mov    $0x0,%ebx
  800701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800704:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800707:	53                   	push   %ebx
  800708:	51                   	push   %ecx
  800709:	52                   	push   %edx
  80070a:	50                   	push   %eax
  80070b:	e8 24 2b 00 00       	call   803234 <__umoddi3>
  800710:	83 c4 10             	add    $0x10,%esp
  800713:	05 b4 38 80 00       	add    $0x8038b4,%eax
  800718:	8a 00                	mov    (%eax),%al
  80071a:	0f be c0             	movsbl %al,%eax
  80071d:	83 ec 08             	sub    $0x8,%esp
  800720:	ff 75 0c             	pushl  0xc(%ebp)
  800723:	50                   	push   %eax
  800724:	8b 45 08             	mov    0x8(%ebp),%eax
  800727:	ff d0                	call   *%eax
  800729:	83 c4 10             	add    $0x10,%esp
}
  80072c:	90                   	nop
  80072d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800730:	c9                   	leave  
  800731:	c3                   	ret    

00800732 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800732:	55                   	push   %ebp
  800733:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800735:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800739:	7e 1c                	jle    800757 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  80073b:	8b 45 08             	mov    0x8(%ebp),%eax
  80073e:	8b 00                	mov    (%eax),%eax
  800740:	8d 50 08             	lea    0x8(%eax),%edx
  800743:	8b 45 08             	mov    0x8(%ebp),%eax
  800746:	89 10                	mov    %edx,(%eax)
  800748:	8b 45 08             	mov    0x8(%ebp),%eax
  80074b:	8b 00                	mov    (%eax),%eax
  80074d:	83 e8 08             	sub    $0x8,%eax
  800750:	8b 50 04             	mov    0x4(%eax),%edx
  800753:	8b 00                	mov    (%eax),%eax
  800755:	eb 40                	jmp    800797 <getuint+0x65>
	else if (lflag)
  800757:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80075b:	74 1e                	je     80077b <getuint+0x49>
		return va_arg(*ap, unsigned long);
  80075d:	8b 45 08             	mov    0x8(%ebp),%eax
  800760:	8b 00                	mov    (%eax),%eax
  800762:	8d 50 04             	lea    0x4(%eax),%edx
  800765:	8b 45 08             	mov    0x8(%ebp),%eax
  800768:	89 10                	mov    %edx,(%eax)
  80076a:	8b 45 08             	mov    0x8(%ebp),%eax
  80076d:	8b 00                	mov    (%eax),%eax
  80076f:	83 e8 04             	sub    $0x4,%eax
  800772:	8b 00                	mov    (%eax),%eax
  800774:	ba 00 00 00 00       	mov    $0x0,%edx
  800779:	eb 1c                	jmp    800797 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80077b:	8b 45 08             	mov    0x8(%ebp),%eax
  80077e:	8b 00                	mov    (%eax),%eax
  800780:	8d 50 04             	lea    0x4(%eax),%edx
  800783:	8b 45 08             	mov    0x8(%ebp),%eax
  800786:	89 10                	mov    %edx,(%eax)
  800788:	8b 45 08             	mov    0x8(%ebp),%eax
  80078b:	8b 00                	mov    (%eax),%eax
  80078d:	83 e8 04             	sub    $0x4,%eax
  800790:	8b 00                	mov    (%eax),%eax
  800792:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800797:	5d                   	pop    %ebp
  800798:	c3                   	ret    

00800799 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800799:	55                   	push   %ebp
  80079a:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80079c:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007a0:	7e 1c                	jle    8007be <getint+0x25>
		return va_arg(*ap, long long);
  8007a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a5:	8b 00                	mov    (%eax),%eax
  8007a7:	8d 50 08             	lea    0x8(%eax),%edx
  8007aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ad:	89 10                	mov    %edx,(%eax)
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	8b 00                	mov    (%eax),%eax
  8007b4:	83 e8 08             	sub    $0x8,%eax
  8007b7:	8b 50 04             	mov    0x4(%eax),%edx
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	eb 38                	jmp    8007f6 <getint+0x5d>
	else if (lflag)
  8007be:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007c2:	74 1a                	je     8007de <getint+0x45>
		return va_arg(*ap, long);
  8007c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c7:	8b 00                	mov    (%eax),%eax
  8007c9:	8d 50 04             	lea    0x4(%eax),%edx
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	89 10                	mov    %edx,(%eax)
  8007d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d4:	8b 00                	mov    (%eax),%eax
  8007d6:	83 e8 04             	sub    $0x4,%eax
  8007d9:	8b 00                	mov    (%eax),%eax
  8007db:	99                   	cltd   
  8007dc:	eb 18                	jmp    8007f6 <getint+0x5d>
	else
		return va_arg(*ap, int);
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	8b 00                	mov    (%eax),%eax
  8007e3:	8d 50 04             	lea    0x4(%eax),%edx
  8007e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e9:	89 10                	mov    %edx,(%eax)
  8007eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ee:	8b 00                	mov    (%eax),%eax
  8007f0:	83 e8 04             	sub    $0x4,%eax
  8007f3:	8b 00                	mov    (%eax),%eax
  8007f5:	99                   	cltd   
}
  8007f6:	5d                   	pop    %ebp
  8007f7:	c3                   	ret    

008007f8 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8007f8:	55                   	push   %ebp
  8007f9:	89 e5                	mov    %esp,%ebp
  8007fb:	56                   	push   %esi
  8007fc:	53                   	push   %ebx
  8007fd:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800800:	eb 17                	jmp    800819 <vprintfmt+0x21>
			if (ch == '\0')
  800802:	85 db                	test   %ebx,%ebx
  800804:	0f 84 af 03 00 00    	je     800bb9 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  80080a:	83 ec 08             	sub    $0x8,%esp
  80080d:	ff 75 0c             	pushl  0xc(%ebp)
  800810:	53                   	push   %ebx
  800811:	8b 45 08             	mov    0x8(%ebp),%eax
  800814:	ff d0                	call   *%eax
  800816:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800819:	8b 45 10             	mov    0x10(%ebp),%eax
  80081c:	8d 50 01             	lea    0x1(%eax),%edx
  80081f:	89 55 10             	mov    %edx,0x10(%ebp)
  800822:	8a 00                	mov    (%eax),%al
  800824:	0f b6 d8             	movzbl %al,%ebx
  800827:	83 fb 25             	cmp    $0x25,%ebx
  80082a:	75 d6                	jne    800802 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  80082c:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800830:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800837:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  80083e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800845:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  80084c:	8b 45 10             	mov    0x10(%ebp),%eax
  80084f:	8d 50 01             	lea    0x1(%eax),%edx
  800852:	89 55 10             	mov    %edx,0x10(%ebp)
  800855:	8a 00                	mov    (%eax),%al
  800857:	0f b6 d8             	movzbl %al,%ebx
  80085a:	8d 43 dd             	lea    -0x23(%ebx),%eax
  80085d:	83 f8 55             	cmp    $0x55,%eax
  800860:	0f 87 2b 03 00 00    	ja     800b91 <vprintfmt+0x399>
  800866:	8b 04 85 d8 38 80 00 	mov    0x8038d8(,%eax,4),%eax
  80086d:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  80086f:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800873:	eb d7                	jmp    80084c <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800875:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800879:	eb d1                	jmp    80084c <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  80087b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800882:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800885:	89 d0                	mov    %edx,%eax
  800887:	c1 e0 02             	shl    $0x2,%eax
  80088a:	01 d0                	add    %edx,%eax
  80088c:	01 c0                	add    %eax,%eax
  80088e:	01 d8                	add    %ebx,%eax
  800890:	83 e8 30             	sub    $0x30,%eax
  800893:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800896:	8b 45 10             	mov    0x10(%ebp),%eax
  800899:	8a 00                	mov    (%eax),%al
  80089b:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80089e:	83 fb 2f             	cmp    $0x2f,%ebx
  8008a1:	7e 3e                	jle    8008e1 <vprintfmt+0xe9>
  8008a3:	83 fb 39             	cmp    $0x39,%ebx
  8008a6:	7f 39                	jg     8008e1 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008a8:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8008ab:	eb d5                	jmp    800882 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8008ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b0:	83 c0 04             	add    $0x4,%eax
  8008b3:	89 45 14             	mov    %eax,0x14(%ebp)
  8008b6:	8b 45 14             	mov    0x14(%ebp),%eax
  8008b9:	83 e8 04             	sub    $0x4,%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  8008c1:	eb 1f                	jmp    8008e2 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  8008c3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008c7:	79 83                	jns    80084c <vprintfmt+0x54>
				width = 0;
  8008c9:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  8008d0:	e9 77 ff ff ff       	jmp    80084c <vprintfmt+0x54>

		case '#':
			altflag = 1;
  8008d5:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  8008dc:	e9 6b ff ff ff       	jmp    80084c <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  8008e1:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  8008e2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8008e6:	0f 89 60 ff ff ff    	jns    80084c <vprintfmt+0x54>
				width = precision, precision = -1;
  8008ec:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8008f2:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  8008f9:	e9 4e ff ff ff       	jmp    80084c <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  8008fe:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800901:	e9 46 ff ff ff       	jmp    80084c <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800906:	8b 45 14             	mov    0x14(%ebp),%eax
  800909:	83 c0 04             	add    $0x4,%eax
  80090c:	89 45 14             	mov    %eax,0x14(%ebp)
  80090f:	8b 45 14             	mov    0x14(%ebp),%eax
  800912:	83 e8 04             	sub    $0x4,%eax
  800915:	8b 00                	mov    (%eax),%eax
  800917:	83 ec 08             	sub    $0x8,%esp
  80091a:	ff 75 0c             	pushl  0xc(%ebp)
  80091d:	50                   	push   %eax
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	ff d0                	call   *%eax
  800923:	83 c4 10             	add    $0x10,%esp
			break;
  800926:	e9 89 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  80092b:	8b 45 14             	mov    0x14(%ebp),%eax
  80092e:	83 c0 04             	add    $0x4,%eax
  800931:	89 45 14             	mov    %eax,0x14(%ebp)
  800934:	8b 45 14             	mov    0x14(%ebp),%eax
  800937:	83 e8 04             	sub    $0x4,%eax
  80093a:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80093c:	85 db                	test   %ebx,%ebx
  80093e:	79 02                	jns    800942 <vprintfmt+0x14a>
				err = -err;
  800940:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800942:	83 fb 64             	cmp    $0x64,%ebx
  800945:	7f 0b                	jg     800952 <vprintfmt+0x15a>
  800947:	8b 34 9d 20 37 80 00 	mov    0x803720(,%ebx,4),%esi
  80094e:	85 f6                	test   %esi,%esi
  800950:	75 19                	jne    80096b <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800952:	53                   	push   %ebx
  800953:	68 c5 38 80 00       	push   $0x8038c5
  800958:	ff 75 0c             	pushl  0xc(%ebp)
  80095b:	ff 75 08             	pushl  0x8(%ebp)
  80095e:	e8 5e 02 00 00       	call   800bc1 <printfmt>
  800963:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800966:	e9 49 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  80096b:	56                   	push   %esi
  80096c:	68 ce 38 80 00       	push   $0x8038ce
  800971:	ff 75 0c             	pushl  0xc(%ebp)
  800974:	ff 75 08             	pushl  0x8(%ebp)
  800977:	e8 45 02 00 00       	call   800bc1 <printfmt>
  80097c:	83 c4 10             	add    $0x10,%esp
			break;
  80097f:	e9 30 02 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800984:	8b 45 14             	mov    0x14(%ebp),%eax
  800987:	83 c0 04             	add    $0x4,%eax
  80098a:	89 45 14             	mov    %eax,0x14(%ebp)
  80098d:	8b 45 14             	mov    0x14(%ebp),%eax
  800990:	83 e8 04             	sub    $0x4,%eax
  800993:	8b 30                	mov    (%eax),%esi
  800995:	85 f6                	test   %esi,%esi
  800997:	75 05                	jne    80099e <vprintfmt+0x1a6>
				p = "(null)";
  800999:	be d1 38 80 00       	mov    $0x8038d1,%esi
			if (width > 0 && padc != '-')
  80099e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009a2:	7e 6d                	jle    800a11 <vprintfmt+0x219>
  8009a4:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8009a8:	74 67                	je     800a11 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8009aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8009ad:	83 ec 08             	sub    $0x8,%esp
  8009b0:	50                   	push   %eax
  8009b1:	56                   	push   %esi
  8009b2:	e8 0c 03 00 00       	call   800cc3 <strnlen>
  8009b7:	83 c4 10             	add    $0x10,%esp
  8009ba:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8009bd:	eb 16                	jmp    8009d5 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8009bf:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8009c3:	83 ec 08             	sub    $0x8,%esp
  8009c6:	ff 75 0c             	pushl  0xc(%ebp)
  8009c9:	50                   	push   %eax
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	ff d0                	call   *%eax
  8009cf:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  8009d2:	ff 4d e4             	decl   -0x1c(%ebp)
  8009d5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8009d9:	7f e4                	jg     8009bf <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  8009db:	eb 34                	jmp    800a11 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  8009dd:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8009e1:	74 1c                	je     8009ff <vprintfmt+0x207>
  8009e3:	83 fb 1f             	cmp    $0x1f,%ebx
  8009e6:	7e 05                	jle    8009ed <vprintfmt+0x1f5>
  8009e8:	83 fb 7e             	cmp    $0x7e,%ebx
  8009eb:	7e 12                	jle    8009ff <vprintfmt+0x207>
					putch('?', putdat);
  8009ed:	83 ec 08             	sub    $0x8,%esp
  8009f0:	ff 75 0c             	pushl  0xc(%ebp)
  8009f3:	6a 3f                	push   $0x3f
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	ff d0                	call   *%eax
  8009fa:	83 c4 10             	add    $0x10,%esp
  8009fd:	eb 0f                	jmp    800a0e <vprintfmt+0x216>
				else
					putch(ch, putdat);
  8009ff:	83 ec 08             	sub    $0x8,%esp
  800a02:	ff 75 0c             	pushl  0xc(%ebp)
  800a05:	53                   	push   %ebx
  800a06:	8b 45 08             	mov    0x8(%ebp),%eax
  800a09:	ff d0                	call   *%eax
  800a0b:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a0e:	ff 4d e4             	decl   -0x1c(%ebp)
  800a11:	89 f0                	mov    %esi,%eax
  800a13:	8d 70 01             	lea    0x1(%eax),%esi
  800a16:	8a 00                	mov    (%eax),%al
  800a18:	0f be d8             	movsbl %al,%ebx
  800a1b:	85 db                	test   %ebx,%ebx
  800a1d:	74 24                	je     800a43 <vprintfmt+0x24b>
  800a1f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a23:	78 b8                	js     8009dd <vprintfmt+0x1e5>
  800a25:	ff 4d e0             	decl   -0x20(%ebp)
  800a28:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800a2c:	79 af                	jns    8009dd <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a2e:	eb 13                	jmp    800a43 <vprintfmt+0x24b>
				putch(' ', putdat);
  800a30:	83 ec 08             	sub    $0x8,%esp
  800a33:	ff 75 0c             	pushl  0xc(%ebp)
  800a36:	6a 20                	push   $0x20
  800a38:	8b 45 08             	mov    0x8(%ebp),%eax
  800a3b:	ff d0                	call   *%eax
  800a3d:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800a40:	ff 4d e4             	decl   -0x1c(%ebp)
  800a43:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a47:	7f e7                	jg     800a30 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800a49:	e9 66 01 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800a4e:	83 ec 08             	sub    $0x8,%esp
  800a51:	ff 75 e8             	pushl  -0x18(%ebp)
  800a54:	8d 45 14             	lea    0x14(%ebp),%eax
  800a57:	50                   	push   %eax
  800a58:	e8 3c fd ff ff       	call   800799 <getint>
  800a5d:	83 c4 10             	add    $0x10,%esp
  800a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a63:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800a66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a69:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a6c:	85 d2                	test   %edx,%edx
  800a6e:	79 23                	jns    800a93 <vprintfmt+0x29b>
				putch('-', putdat);
  800a70:	83 ec 08             	sub    $0x8,%esp
  800a73:	ff 75 0c             	pushl  0xc(%ebp)
  800a76:	6a 2d                	push   $0x2d
  800a78:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7b:	ff d0                	call   *%eax
  800a7d:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800a80:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a83:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800a86:	f7 d8                	neg    %eax
  800a88:	83 d2 00             	adc    $0x0,%edx
  800a8b:	f7 da                	neg    %edx
  800a8d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a90:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800a93:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800a9a:	e9 bc 00 00 00       	jmp    800b5b <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800a9f:	83 ec 08             	sub    $0x8,%esp
  800aa2:	ff 75 e8             	pushl  -0x18(%ebp)
  800aa5:	8d 45 14             	lea    0x14(%ebp),%eax
  800aa8:	50                   	push   %eax
  800aa9:	e8 84 fc ff ff       	call   800732 <getuint>
  800aae:	83 c4 10             	add    $0x10,%esp
  800ab1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ab4:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800ab7:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800abe:	e9 98 00 00 00       	jmp    800b5b <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ac3:	83 ec 08             	sub    $0x8,%esp
  800ac6:	ff 75 0c             	pushl  0xc(%ebp)
  800ac9:	6a 58                	push   $0x58
  800acb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ace:	ff d0                	call   *%eax
  800ad0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ad3:	83 ec 08             	sub    $0x8,%esp
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	6a 58                	push   $0x58
  800adb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ade:	ff d0                	call   *%eax
  800ae0:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800ae3:	83 ec 08             	sub    $0x8,%esp
  800ae6:	ff 75 0c             	pushl  0xc(%ebp)
  800ae9:	6a 58                	push   $0x58
  800aeb:	8b 45 08             	mov    0x8(%ebp),%eax
  800aee:	ff d0                	call   *%eax
  800af0:	83 c4 10             	add    $0x10,%esp
			break;
  800af3:	e9 bc 00 00 00       	jmp    800bb4 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800af8:	83 ec 08             	sub    $0x8,%esp
  800afb:	ff 75 0c             	pushl  0xc(%ebp)
  800afe:	6a 30                	push   $0x30
  800b00:	8b 45 08             	mov    0x8(%ebp),%eax
  800b03:	ff d0                	call   *%eax
  800b05:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b08:	83 ec 08             	sub    $0x8,%esp
  800b0b:	ff 75 0c             	pushl  0xc(%ebp)
  800b0e:	6a 78                	push   $0x78
  800b10:	8b 45 08             	mov    0x8(%ebp),%eax
  800b13:	ff d0                	call   *%eax
  800b15:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b18:	8b 45 14             	mov    0x14(%ebp),%eax
  800b1b:	83 c0 04             	add    $0x4,%eax
  800b1e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b21:	8b 45 14             	mov    0x14(%ebp),%eax
  800b24:	83 e8 04             	sub    $0x4,%eax
  800b27:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800b29:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800b33:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800b3a:	eb 1f                	jmp    800b5b <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800b3c:	83 ec 08             	sub    $0x8,%esp
  800b3f:	ff 75 e8             	pushl  -0x18(%ebp)
  800b42:	8d 45 14             	lea    0x14(%ebp),%eax
  800b45:	50                   	push   %eax
  800b46:	e8 e7 fb ff ff       	call   800732 <getuint>
  800b4b:	83 c4 10             	add    $0x10,%esp
  800b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b51:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800b54:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800b5b:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b62:	83 ec 04             	sub    $0x4,%esp
  800b65:	52                   	push   %edx
  800b66:	ff 75 e4             	pushl  -0x1c(%ebp)
  800b69:	50                   	push   %eax
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	ff 75 f0             	pushl  -0x10(%ebp)
  800b70:	ff 75 0c             	pushl  0xc(%ebp)
  800b73:	ff 75 08             	pushl  0x8(%ebp)
  800b76:	e8 00 fb ff ff       	call   80067b <printnum>
  800b7b:	83 c4 20             	add    $0x20,%esp
			break;
  800b7e:	eb 34                	jmp    800bb4 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800b80:	83 ec 08             	sub    $0x8,%esp
  800b83:	ff 75 0c             	pushl  0xc(%ebp)
  800b86:	53                   	push   %ebx
  800b87:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8a:	ff d0                	call   *%eax
  800b8c:	83 c4 10             	add    $0x10,%esp
			break;
  800b8f:	eb 23                	jmp    800bb4 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800b91:	83 ec 08             	sub    $0x8,%esp
  800b94:	ff 75 0c             	pushl  0xc(%ebp)
  800b97:	6a 25                	push   $0x25
  800b99:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9c:	ff d0                	call   *%eax
  800b9e:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800ba1:	ff 4d 10             	decl   0x10(%ebp)
  800ba4:	eb 03                	jmp    800ba9 <vprintfmt+0x3b1>
  800ba6:	ff 4d 10             	decl   0x10(%ebp)
  800ba9:	8b 45 10             	mov    0x10(%ebp),%eax
  800bac:	48                   	dec    %eax
  800bad:	8a 00                	mov    (%eax),%al
  800baf:	3c 25                	cmp    $0x25,%al
  800bb1:	75 f3                	jne    800ba6 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800bb3:	90                   	nop
		}
	}
  800bb4:	e9 47 fc ff ff       	jmp    800800 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800bb9:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800bba:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800bbd:	5b                   	pop    %ebx
  800bbe:	5e                   	pop    %esi
  800bbf:	5d                   	pop    %ebp
  800bc0:	c3                   	ret    

00800bc1 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800bc1:	55                   	push   %ebp
  800bc2:	89 e5                	mov    %esp,%ebp
  800bc4:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800bc7:	8d 45 10             	lea    0x10(%ebp),%eax
  800bca:	83 c0 04             	add    $0x4,%eax
  800bcd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800bd0:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd3:	ff 75 f4             	pushl  -0xc(%ebp)
  800bd6:	50                   	push   %eax
  800bd7:	ff 75 0c             	pushl  0xc(%ebp)
  800bda:	ff 75 08             	pushl  0x8(%ebp)
  800bdd:	e8 16 fc ff ff       	call   8007f8 <vprintfmt>
  800be2:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800be5:	90                   	nop
  800be6:	c9                   	leave  
  800be7:	c3                   	ret    

00800be8 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800be8:	55                   	push   %ebp
  800be9:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800beb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bee:	8b 40 08             	mov    0x8(%eax),%eax
  800bf1:	8d 50 01             	lea    0x1(%eax),%edx
  800bf4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bf7:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800bfa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bfd:	8b 10                	mov    (%eax),%edx
  800bff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c02:	8b 40 04             	mov    0x4(%eax),%eax
  800c05:	39 c2                	cmp    %eax,%edx
  800c07:	73 12                	jae    800c1b <sprintputch+0x33>
		*b->buf++ = ch;
  800c09:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c0c:	8b 00                	mov    (%eax),%eax
  800c0e:	8d 48 01             	lea    0x1(%eax),%ecx
  800c11:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c14:	89 0a                	mov    %ecx,(%edx)
  800c16:	8b 55 08             	mov    0x8(%ebp),%edx
  800c19:	88 10                	mov    %dl,(%eax)
}
  800c1b:	90                   	nop
  800c1c:	5d                   	pop    %ebp
  800c1d:	c3                   	ret    

00800c1e <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800c2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c2d:	8d 50 ff             	lea    -0x1(%eax),%edx
  800c30:	8b 45 08             	mov    0x8(%ebp),%eax
  800c33:	01 d0                	add    %edx,%eax
  800c35:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c38:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800c3f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800c43:	74 06                	je     800c4b <vsnprintf+0x2d>
  800c45:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c49:	7f 07                	jg     800c52 <vsnprintf+0x34>
		return -E_INVAL;
  800c4b:	b8 03 00 00 00       	mov    $0x3,%eax
  800c50:	eb 20                	jmp    800c72 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800c52:	ff 75 14             	pushl  0x14(%ebp)
  800c55:	ff 75 10             	pushl  0x10(%ebp)
  800c58:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800c5b:	50                   	push   %eax
  800c5c:	68 e8 0b 80 00       	push   $0x800be8
  800c61:	e8 92 fb ff ff       	call   8007f8 <vprintfmt>
  800c66:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800c69:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c6c:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800c72:	c9                   	leave  
  800c73:	c3                   	ret    

00800c74 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800c74:	55                   	push   %ebp
  800c75:	89 e5                	mov    %esp,%ebp
  800c77:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800c7a:	8d 45 10             	lea    0x10(%ebp),%eax
  800c7d:	83 c0 04             	add    $0x4,%eax
  800c80:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800c83:	8b 45 10             	mov    0x10(%ebp),%eax
  800c86:	ff 75 f4             	pushl  -0xc(%ebp)
  800c89:	50                   	push   %eax
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	ff 75 08             	pushl  0x8(%ebp)
  800c90:	e8 89 ff ff ff       	call   800c1e <vsnprintf>
  800c95:	83 c4 10             	add    $0x10,%esp
  800c98:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800c9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c9e:	c9                   	leave  
  800c9f:	c3                   	ret    

00800ca0 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800ca0:	55                   	push   %ebp
  800ca1:	89 e5                	mov    %esp,%ebp
  800ca3:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800ca6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cad:	eb 06                	jmp    800cb5 <strlen+0x15>
		n++;
  800caf:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800cb2:	ff 45 08             	incl   0x8(%ebp)
  800cb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb8:	8a 00                	mov    (%eax),%al
  800cba:	84 c0                	test   %al,%al
  800cbc:	75 f1                	jne    800caf <strlen+0xf>
		n++;
	return n;
  800cbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800cc1:	c9                   	leave  
  800cc2:	c3                   	ret    

00800cc3 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800cc3:	55                   	push   %ebp
  800cc4:	89 e5                	mov    %esp,%ebp
  800cc6:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800cd0:	eb 09                	jmp    800cdb <strnlen+0x18>
		n++;
  800cd2:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800cd5:	ff 45 08             	incl   0x8(%ebp)
  800cd8:	ff 4d 0c             	decl   0xc(%ebp)
  800cdb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cdf:	74 09                	je     800cea <strnlen+0x27>
  800ce1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce4:	8a 00                	mov    (%eax),%al
  800ce6:	84 c0                	test   %al,%al
  800ce8:	75 e8                	jne    800cd2 <strnlen+0xf>
		n++;
	return n;
  800cea:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ced:	c9                   	leave  
  800cee:	c3                   	ret    

00800cef <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800cef:	55                   	push   %ebp
  800cf0:	89 e5                	mov    %esp,%ebp
  800cf2:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800cf5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cf8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800cfb:	90                   	nop
  800cfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800cff:	8d 50 01             	lea    0x1(%eax),%edx
  800d02:	89 55 08             	mov    %edx,0x8(%ebp)
  800d05:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d08:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d0b:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d0e:	8a 12                	mov    (%edx),%dl
  800d10:	88 10                	mov    %dl,(%eax)
  800d12:	8a 00                	mov    (%eax),%al
  800d14:	84 c0                	test   %al,%al
  800d16:	75 e4                	jne    800cfc <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d18:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d1b:	c9                   	leave  
  800d1c:	c3                   	ret    

00800d1d <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d1d:	55                   	push   %ebp
  800d1e:	89 e5                	mov    %esp,%ebp
  800d20:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800d23:	8b 45 08             	mov    0x8(%ebp),%eax
  800d26:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800d29:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d30:	eb 1f                	jmp    800d51 <strncpy+0x34>
		*dst++ = *src;
  800d32:	8b 45 08             	mov    0x8(%ebp),%eax
  800d35:	8d 50 01             	lea    0x1(%eax),%edx
  800d38:	89 55 08             	mov    %edx,0x8(%ebp)
  800d3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d3e:	8a 12                	mov    (%edx),%dl
  800d40:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800d42:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d45:	8a 00                	mov    (%eax),%al
  800d47:	84 c0                	test   %al,%al
  800d49:	74 03                	je     800d4e <strncpy+0x31>
			src++;
  800d4b:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800d4e:	ff 45 fc             	incl   -0x4(%ebp)
  800d51:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800d54:	3b 45 10             	cmp    0x10(%ebp),%eax
  800d57:	72 d9                	jb     800d32 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800d59:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800d5c:	c9                   	leave  
  800d5d:	c3                   	ret    

00800d5e <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800d5e:	55                   	push   %ebp
  800d5f:	89 e5                	mov    %esp,%ebp
  800d61:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800d64:	8b 45 08             	mov    0x8(%ebp),%eax
  800d67:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800d6a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d6e:	74 30                	je     800da0 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800d70:	eb 16                	jmp    800d88 <strlcpy+0x2a>
			*dst++ = *src++;
  800d72:	8b 45 08             	mov    0x8(%ebp),%eax
  800d75:	8d 50 01             	lea    0x1(%eax),%edx
  800d78:	89 55 08             	mov    %edx,0x8(%ebp)
  800d7b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d7e:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d81:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d84:	8a 12                	mov    (%edx),%dl
  800d86:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800d88:	ff 4d 10             	decl   0x10(%ebp)
  800d8b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d8f:	74 09                	je     800d9a <strlcpy+0x3c>
  800d91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d94:	8a 00                	mov    (%eax),%al
  800d96:	84 c0                	test   %al,%al
  800d98:	75 d8                	jne    800d72 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800d9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d9d:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800da0:	8b 55 08             	mov    0x8(%ebp),%edx
  800da3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800da6:	29 c2                	sub    %eax,%edx
  800da8:	89 d0                	mov    %edx,%eax
}
  800daa:	c9                   	leave  
  800dab:	c3                   	ret    

00800dac <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800dac:	55                   	push   %ebp
  800dad:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800daf:	eb 06                	jmp    800db7 <strcmp+0xb>
		p++, q++;
  800db1:	ff 45 08             	incl   0x8(%ebp)
  800db4:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800db7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dba:	8a 00                	mov    (%eax),%al
  800dbc:	84 c0                	test   %al,%al
  800dbe:	74 0e                	je     800dce <strcmp+0x22>
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8a 10                	mov    (%eax),%dl
  800dc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc8:	8a 00                	mov    (%eax),%al
  800dca:	38 c2                	cmp    %al,%dl
  800dcc:	74 e3                	je     800db1 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800dce:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd1:	8a 00                	mov    (%eax),%al
  800dd3:	0f b6 d0             	movzbl %al,%edx
  800dd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dd9:	8a 00                	mov    (%eax),%al
  800ddb:	0f b6 c0             	movzbl %al,%eax
  800dde:	29 c2                	sub    %eax,%edx
  800de0:	89 d0                	mov    %edx,%eax
}
  800de2:	5d                   	pop    %ebp
  800de3:	c3                   	ret    

00800de4 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800de4:	55                   	push   %ebp
  800de5:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800de7:	eb 09                	jmp    800df2 <strncmp+0xe>
		n--, p++, q++;
  800de9:	ff 4d 10             	decl   0x10(%ebp)
  800dec:	ff 45 08             	incl   0x8(%ebp)
  800def:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800df2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df6:	74 17                	je     800e0f <strncmp+0x2b>
  800df8:	8b 45 08             	mov    0x8(%ebp),%eax
  800dfb:	8a 00                	mov    (%eax),%al
  800dfd:	84 c0                	test   %al,%al
  800dff:	74 0e                	je     800e0f <strncmp+0x2b>
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	8a 10                	mov    (%eax),%dl
  800e06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e09:	8a 00                	mov    (%eax),%al
  800e0b:	38 c2                	cmp    %al,%dl
  800e0d:	74 da                	je     800de9 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e0f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e13:	75 07                	jne    800e1c <strncmp+0x38>
		return 0;
  800e15:	b8 00 00 00 00       	mov    $0x0,%eax
  800e1a:	eb 14                	jmp    800e30 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1f:	8a 00                	mov    (%eax),%al
  800e21:	0f b6 d0             	movzbl %al,%edx
  800e24:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e27:	8a 00                	mov    (%eax),%al
  800e29:	0f b6 c0             	movzbl %al,%eax
  800e2c:	29 c2                	sub    %eax,%edx
  800e2e:	89 d0                	mov    %edx,%eax
}
  800e30:	5d                   	pop    %ebp
  800e31:	c3                   	ret    

00800e32 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800e32:	55                   	push   %ebp
  800e33:	89 e5                	mov    %esp,%ebp
  800e35:	83 ec 04             	sub    $0x4,%esp
  800e38:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e3b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e3e:	eb 12                	jmp    800e52 <strchr+0x20>
		if (*s == c)
  800e40:	8b 45 08             	mov    0x8(%ebp),%eax
  800e43:	8a 00                	mov    (%eax),%al
  800e45:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e48:	75 05                	jne    800e4f <strchr+0x1d>
			return (char *) s;
  800e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4d:	eb 11                	jmp    800e60 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800e4f:	ff 45 08             	incl   0x8(%ebp)
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	8a 00                	mov    (%eax),%al
  800e57:	84 c0                	test   %al,%al
  800e59:	75 e5                	jne    800e40 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800e5b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800e60:	c9                   	leave  
  800e61:	c3                   	ret    

00800e62 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800e62:	55                   	push   %ebp
  800e63:	89 e5                	mov    %esp,%ebp
  800e65:	83 ec 04             	sub    $0x4,%esp
  800e68:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e6b:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800e6e:	eb 0d                	jmp    800e7d <strfind+0x1b>
		if (*s == c)
  800e70:	8b 45 08             	mov    0x8(%ebp),%eax
  800e73:	8a 00                	mov    (%eax),%al
  800e75:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800e78:	74 0e                	je     800e88 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800e7a:	ff 45 08             	incl   0x8(%ebp)
  800e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e80:	8a 00                	mov    (%eax),%al
  800e82:	84 c0                	test   %al,%al
  800e84:	75 ea                	jne    800e70 <strfind+0xe>
  800e86:	eb 01                	jmp    800e89 <strfind+0x27>
		if (*s == c)
			break;
  800e88:	90                   	nop
	return (char *) s;
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800e8c:	c9                   	leave  
  800e8d:	c3                   	ret    

00800e8e <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800e8e:	55                   	push   %ebp
  800e8f:	89 e5                	mov    %esp,%ebp
  800e91:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800e94:	8b 45 08             	mov    0x8(%ebp),%eax
  800e97:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800e9a:	8b 45 10             	mov    0x10(%ebp),%eax
  800e9d:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800ea0:	eb 0e                	jmp    800eb0 <memset+0x22>
		*p++ = c;
  800ea2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ea5:	8d 50 01             	lea    0x1(%eax),%edx
  800ea8:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800eab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800eae:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800eb0:	ff 4d f8             	decl   -0x8(%ebp)
  800eb3:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800eb7:	79 e9                	jns    800ea2 <memset+0x14>
		*p++ = c;

	return v;
  800eb9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ebc:	c9                   	leave  
  800ebd:	c3                   	ret    

00800ebe <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800ebe:	55                   	push   %ebp
  800ebf:	89 e5                	mov    %esp,%ebp
  800ec1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800ec4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800eca:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800ed0:	eb 16                	jmp    800ee8 <memcpy+0x2a>
		*d++ = *s++;
  800ed2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ed5:	8d 50 01             	lea    0x1(%eax),%edx
  800ed8:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800edb:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800ede:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ee1:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800ee4:	8a 12                	mov    (%edx),%dl
  800ee6:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800ee8:	8b 45 10             	mov    0x10(%ebp),%eax
  800eeb:	8d 50 ff             	lea    -0x1(%eax),%edx
  800eee:	89 55 10             	mov    %edx,0x10(%ebp)
  800ef1:	85 c0                	test   %eax,%eax
  800ef3:	75 dd                	jne    800ed2 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800ef5:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ef8:	c9                   	leave  
  800ef9:	c3                   	ret    

00800efa <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800efa:	55                   	push   %ebp
  800efb:	89 e5                	mov    %esp,%ebp
  800efd:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f00:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f03:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f06:	8b 45 08             	mov    0x8(%ebp),%eax
  800f09:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f0c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f0f:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f12:	73 50                	jae    800f64 <memmove+0x6a>
  800f14:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	01 d0                	add    %edx,%eax
  800f1c:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f1f:	76 43                	jbe    800f64 <memmove+0x6a>
		s += n;
  800f21:	8b 45 10             	mov    0x10(%ebp),%eax
  800f24:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800f27:	8b 45 10             	mov    0x10(%ebp),%eax
  800f2a:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800f2d:	eb 10                	jmp    800f3f <memmove+0x45>
			*--d = *--s;
  800f2f:	ff 4d f8             	decl   -0x8(%ebp)
  800f32:	ff 4d fc             	decl   -0x4(%ebp)
  800f35:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f38:	8a 10                	mov    (%eax),%dl
  800f3a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f3d:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800f3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800f42:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f45:	89 55 10             	mov    %edx,0x10(%ebp)
  800f48:	85 c0                	test   %eax,%eax
  800f4a:	75 e3                	jne    800f2f <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800f4c:	eb 23                	jmp    800f71 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800f4e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f51:	8d 50 01             	lea    0x1(%eax),%edx
  800f54:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f57:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5a:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f5d:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f60:	8a 12                	mov    (%edx),%dl
  800f62:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800f64:	8b 45 10             	mov    0x10(%ebp),%eax
  800f67:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6a:	89 55 10             	mov    %edx,0x10(%ebp)
  800f6d:	85 c0                	test   %eax,%eax
  800f6f:	75 dd                	jne    800f4e <memmove+0x54>
			*d++ = *s++;

	return dst;
  800f71:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f74:	c9                   	leave  
  800f75:	c3                   	ret    

00800f76 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800f7c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f7f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  800f82:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f85:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  800f88:	eb 2a                	jmp    800fb4 <memcmp+0x3e>
		if (*s1 != *s2)
  800f8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8d:	8a 10                	mov    (%eax),%dl
  800f8f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f92:	8a 00                	mov    (%eax),%al
  800f94:	38 c2                	cmp    %al,%dl
  800f96:	74 16                	je     800fae <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  800f98:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f9b:	8a 00                	mov    (%eax),%al
  800f9d:	0f b6 d0             	movzbl %al,%edx
  800fa0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fa3:	8a 00                	mov    (%eax),%al
  800fa5:	0f b6 c0             	movzbl %al,%eax
  800fa8:	29 c2                	sub    %eax,%edx
  800faa:	89 d0                	mov    %edx,%eax
  800fac:	eb 18                	jmp    800fc6 <memcmp+0x50>
		s1++, s2++;
  800fae:	ff 45 fc             	incl   -0x4(%ebp)
  800fb1:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  800fb4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb7:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fba:	89 55 10             	mov    %edx,0x10(%ebp)
  800fbd:	85 c0                	test   %eax,%eax
  800fbf:	75 c9                	jne    800f8a <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  800fc1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fc6:	c9                   	leave  
  800fc7:	c3                   	ret    

00800fc8 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  800fc8:	55                   	push   %ebp
  800fc9:	89 e5                	mov    %esp,%ebp
  800fcb:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  800fce:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd1:	8b 45 10             	mov    0x10(%ebp),%eax
  800fd4:	01 d0                	add    %edx,%eax
  800fd6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  800fd9:	eb 15                	jmp    800ff0 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  800fdb:	8b 45 08             	mov    0x8(%ebp),%eax
  800fde:	8a 00                	mov    (%eax),%al
  800fe0:	0f b6 d0             	movzbl %al,%edx
  800fe3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe6:	0f b6 c0             	movzbl %al,%eax
  800fe9:	39 c2                	cmp    %eax,%edx
  800feb:	74 0d                	je     800ffa <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  800fed:	ff 45 08             	incl   0x8(%ebp)
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff3:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  800ff6:	72 e3                	jb     800fdb <memfind+0x13>
  800ff8:	eb 01                	jmp    800ffb <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  800ffa:	90                   	nop
	return (void *) s;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ffe:	c9                   	leave  
  800fff:	c3                   	ret    

00801000 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801000:	55                   	push   %ebp
  801001:	89 e5                	mov    %esp,%ebp
  801003:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801006:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80100d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801014:	eb 03                	jmp    801019 <strtol+0x19>
		s++;
  801016:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801019:	8b 45 08             	mov    0x8(%ebp),%eax
  80101c:	8a 00                	mov    (%eax),%al
  80101e:	3c 20                	cmp    $0x20,%al
  801020:	74 f4                	je     801016 <strtol+0x16>
  801022:	8b 45 08             	mov    0x8(%ebp),%eax
  801025:	8a 00                	mov    (%eax),%al
  801027:	3c 09                	cmp    $0x9,%al
  801029:	74 eb                	je     801016 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  80102b:	8b 45 08             	mov    0x8(%ebp),%eax
  80102e:	8a 00                	mov    (%eax),%al
  801030:	3c 2b                	cmp    $0x2b,%al
  801032:	75 05                	jne    801039 <strtol+0x39>
		s++;
  801034:	ff 45 08             	incl   0x8(%ebp)
  801037:	eb 13                	jmp    80104c <strtol+0x4c>
	else if (*s == '-')
  801039:	8b 45 08             	mov    0x8(%ebp),%eax
  80103c:	8a 00                	mov    (%eax),%al
  80103e:	3c 2d                	cmp    $0x2d,%al
  801040:	75 0a                	jne    80104c <strtol+0x4c>
		s++, neg = 1;
  801042:	ff 45 08             	incl   0x8(%ebp)
  801045:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80104c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801050:	74 06                	je     801058 <strtol+0x58>
  801052:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801056:	75 20                	jne    801078 <strtol+0x78>
  801058:	8b 45 08             	mov    0x8(%ebp),%eax
  80105b:	8a 00                	mov    (%eax),%al
  80105d:	3c 30                	cmp    $0x30,%al
  80105f:	75 17                	jne    801078 <strtol+0x78>
  801061:	8b 45 08             	mov    0x8(%ebp),%eax
  801064:	40                   	inc    %eax
  801065:	8a 00                	mov    (%eax),%al
  801067:	3c 78                	cmp    $0x78,%al
  801069:	75 0d                	jne    801078 <strtol+0x78>
		s += 2, base = 16;
  80106b:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80106f:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801076:	eb 28                	jmp    8010a0 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801078:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80107c:	75 15                	jne    801093 <strtol+0x93>
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	8a 00                	mov    (%eax),%al
  801083:	3c 30                	cmp    $0x30,%al
  801085:	75 0c                	jne    801093 <strtol+0x93>
		s++, base = 8;
  801087:	ff 45 08             	incl   0x8(%ebp)
  80108a:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801091:	eb 0d                	jmp    8010a0 <strtol+0xa0>
	else if (base == 0)
  801093:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801097:	75 07                	jne    8010a0 <strtol+0xa0>
		base = 10;
  801099:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8010a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a3:	8a 00                	mov    (%eax),%al
  8010a5:	3c 2f                	cmp    $0x2f,%al
  8010a7:	7e 19                	jle    8010c2 <strtol+0xc2>
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	8a 00                	mov    (%eax),%al
  8010ae:	3c 39                	cmp    $0x39,%al
  8010b0:	7f 10                	jg     8010c2 <strtol+0xc2>
			dig = *s - '0';
  8010b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b5:	8a 00                	mov    (%eax),%al
  8010b7:	0f be c0             	movsbl %al,%eax
  8010ba:	83 e8 30             	sub    $0x30,%eax
  8010bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010c0:	eb 42                	jmp    801104 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8010c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c5:	8a 00                	mov    (%eax),%al
  8010c7:	3c 60                	cmp    $0x60,%al
  8010c9:	7e 19                	jle    8010e4 <strtol+0xe4>
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8a 00                	mov    (%eax),%al
  8010d0:	3c 7a                	cmp    $0x7a,%al
  8010d2:	7f 10                	jg     8010e4 <strtol+0xe4>
			dig = *s - 'a' + 10;
  8010d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010d7:	8a 00                	mov    (%eax),%al
  8010d9:	0f be c0             	movsbl %al,%eax
  8010dc:	83 e8 57             	sub    $0x57,%eax
  8010df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8010e2:	eb 20                	jmp    801104 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8010e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e7:	8a 00                	mov    (%eax),%al
  8010e9:	3c 40                	cmp    $0x40,%al
  8010eb:	7e 39                	jle    801126 <strtol+0x126>
  8010ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f0:	8a 00                	mov    (%eax),%al
  8010f2:	3c 5a                	cmp    $0x5a,%al
  8010f4:	7f 30                	jg     801126 <strtol+0x126>
			dig = *s - 'A' + 10;
  8010f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	0f be c0             	movsbl %al,%eax
  8010fe:	83 e8 37             	sub    $0x37,%eax
  801101:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801104:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801107:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110a:	7d 19                	jge    801125 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80110c:	ff 45 08             	incl   0x8(%ebp)
  80110f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801112:	0f af 45 10          	imul   0x10(%ebp),%eax
  801116:	89 c2                	mov    %eax,%edx
  801118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80111b:	01 d0                	add    %edx,%eax
  80111d:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801120:	e9 7b ff ff ff       	jmp    8010a0 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801125:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801126:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80112a:	74 08                	je     801134 <strtol+0x134>
		*endptr = (char *) s;
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	8b 55 08             	mov    0x8(%ebp),%edx
  801132:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801134:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801138:	74 07                	je     801141 <strtol+0x141>
  80113a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80113d:	f7 d8                	neg    %eax
  80113f:	eb 03                	jmp    801144 <strtol+0x144>
  801141:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <ltostr>:

void
ltostr(long value, char *str)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80114c:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801153:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80115a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80115e:	79 13                	jns    801173 <ltostr+0x2d>
	{
		neg = 1;
  801160:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801167:	8b 45 0c             	mov    0xc(%ebp),%eax
  80116a:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80116d:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801170:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801173:	8b 45 08             	mov    0x8(%ebp),%eax
  801176:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80117b:	99                   	cltd   
  80117c:	f7 f9                	idiv   %ecx
  80117e:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801181:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801184:	8d 50 01             	lea    0x1(%eax),%edx
  801187:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80118a:	89 c2                	mov    %eax,%edx
  80118c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118f:	01 d0                	add    %edx,%eax
  801191:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801194:	83 c2 30             	add    $0x30,%edx
  801197:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801199:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80119c:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011a1:	f7 e9                	imul   %ecx
  8011a3:	c1 fa 02             	sar    $0x2,%edx
  8011a6:	89 c8                	mov    %ecx,%eax
  8011a8:	c1 f8 1f             	sar    $0x1f,%eax
  8011ab:	29 c2                	sub    %eax,%edx
  8011ad:	89 d0                	mov    %edx,%eax
  8011af:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8011b2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8011b5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8011ba:	f7 e9                	imul   %ecx
  8011bc:	c1 fa 02             	sar    $0x2,%edx
  8011bf:	89 c8                	mov    %ecx,%eax
  8011c1:	c1 f8 1f             	sar    $0x1f,%eax
  8011c4:	29 c2                	sub    %eax,%edx
  8011c6:	89 d0                	mov    %edx,%eax
  8011c8:	c1 e0 02             	shl    $0x2,%eax
  8011cb:	01 d0                	add    %edx,%eax
  8011cd:	01 c0                	add    %eax,%eax
  8011cf:	29 c1                	sub    %eax,%ecx
  8011d1:	89 ca                	mov    %ecx,%edx
  8011d3:	85 d2                	test   %edx,%edx
  8011d5:	75 9c                	jne    801173 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  8011d7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8011de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011e1:	48                   	dec    %eax
  8011e2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8011e5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011e9:	74 3d                	je     801228 <ltostr+0xe2>
		start = 1 ;
  8011eb:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8011f2:	eb 34                	jmp    801228 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8011f4:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011f7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011fa:	01 d0                	add    %edx,%eax
  8011fc:	8a 00                	mov    (%eax),%al
  8011fe:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801201:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801204:	8b 45 0c             	mov    0xc(%ebp),%eax
  801207:	01 c2                	add    %eax,%edx
  801209:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80120c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120f:	01 c8                	add    %ecx,%eax
  801211:	8a 00                	mov    (%eax),%al
  801213:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801215:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801218:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121b:	01 c2                	add    %eax,%edx
  80121d:	8a 45 eb             	mov    -0x15(%ebp),%al
  801220:	88 02                	mov    %al,(%edx)
		start++ ;
  801222:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801225:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801228:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80122b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80122e:	7c c4                	jl     8011f4 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801230:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801233:	8b 45 0c             	mov    0xc(%ebp),%eax
  801236:	01 d0                	add    %edx,%eax
  801238:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  80123b:	90                   	nop
  80123c:	c9                   	leave  
  80123d:	c3                   	ret    

0080123e <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80123e:	55                   	push   %ebp
  80123f:	89 e5                	mov    %esp,%ebp
  801241:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801244:	ff 75 08             	pushl  0x8(%ebp)
  801247:	e8 54 fa ff ff       	call   800ca0 <strlen>
  80124c:	83 c4 04             	add    $0x4,%esp
  80124f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801252:	ff 75 0c             	pushl  0xc(%ebp)
  801255:	e8 46 fa ff ff       	call   800ca0 <strlen>
  80125a:	83 c4 04             	add    $0x4,%esp
  80125d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801260:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801267:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126e:	eb 17                	jmp    801287 <strcconcat+0x49>
		final[s] = str1[s] ;
  801270:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801273:	8b 45 10             	mov    0x10(%ebp),%eax
  801276:	01 c2                	add    %eax,%edx
  801278:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80127b:	8b 45 08             	mov    0x8(%ebp),%eax
  80127e:	01 c8                	add    %ecx,%eax
  801280:	8a 00                	mov    (%eax),%al
  801282:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801284:	ff 45 fc             	incl   -0x4(%ebp)
  801287:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80128a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80128d:	7c e1                	jl     801270 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80128f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801296:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80129d:	eb 1f                	jmp    8012be <strcconcat+0x80>
		final[s++] = str2[i] ;
  80129f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a2:	8d 50 01             	lea    0x1(%eax),%edx
  8012a5:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8012a8:	89 c2                	mov    %eax,%edx
  8012aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ad:	01 c2                	add    %eax,%edx
  8012af:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8012b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b5:	01 c8                	add    %ecx,%eax
  8012b7:	8a 00                	mov    (%eax),%al
  8012b9:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8012bb:	ff 45 f8             	incl   -0x8(%ebp)
  8012be:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012c4:	7c d9                	jl     80129f <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8012c6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012c9:	8b 45 10             	mov    0x10(%ebp),%eax
  8012cc:	01 d0                	add    %edx,%eax
  8012ce:	c6 00 00             	movb   $0x0,(%eax)
}
  8012d1:	90                   	nop
  8012d2:	c9                   	leave  
  8012d3:	c3                   	ret    

008012d4 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  8012d4:	55                   	push   %ebp
  8012d5:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  8012d7:	8b 45 14             	mov    0x14(%ebp),%eax
  8012da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8012e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8012e3:	8b 00                	mov    (%eax),%eax
  8012e5:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8012ec:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ef:	01 d0                	add    %edx,%eax
  8012f1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8012f7:	eb 0c                	jmp    801305 <strsplit+0x31>
			*string++ = 0;
  8012f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fc:	8d 50 01             	lea    0x1(%eax),%edx
  8012ff:	89 55 08             	mov    %edx,0x8(%ebp)
  801302:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801305:	8b 45 08             	mov    0x8(%ebp),%eax
  801308:	8a 00                	mov    (%eax),%al
  80130a:	84 c0                	test   %al,%al
  80130c:	74 18                	je     801326 <strsplit+0x52>
  80130e:	8b 45 08             	mov    0x8(%ebp),%eax
  801311:	8a 00                	mov    (%eax),%al
  801313:	0f be c0             	movsbl %al,%eax
  801316:	50                   	push   %eax
  801317:	ff 75 0c             	pushl  0xc(%ebp)
  80131a:	e8 13 fb ff ff       	call   800e32 <strchr>
  80131f:	83 c4 08             	add    $0x8,%esp
  801322:	85 c0                	test   %eax,%eax
  801324:	75 d3                	jne    8012f9 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	8a 00                	mov    (%eax),%al
  80132b:	84 c0                	test   %al,%al
  80132d:	74 5a                	je     801389 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  80132f:	8b 45 14             	mov    0x14(%ebp),%eax
  801332:	8b 00                	mov    (%eax),%eax
  801334:	83 f8 0f             	cmp    $0xf,%eax
  801337:	75 07                	jne    801340 <strsplit+0x6c>
		{
			return 0;
  801339:	b8 00 00 00 00       	mov    $0x0,%eax
  80133e:	eb 66                	jmp    8013a6 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801340:	8b 45 14             	mov    0x14(%ebp),%eax
  801343:	8b 00                	mov    (%eax),%eax
  801345:	8d 48 01             	lea    0x1(%eax),%ecx
  801348:	8b 55 14             	mov    0x14(%ebp),%edx
  80134b:	89 0a                	mov    %ecx,(%edx)
  80134d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801354:	8b 45 10             	mov    0x10(%ebp),%eax
  801357:	01 c2                	add    %eax,%edx
  801359:	8b 45 08             	mov    0x8(%ebp),%eax
  80135c:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  80135e:	eb 03                	jmp    801363 <strsplit+0x8f>
			string++;
  801360:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801363:	8b 45 08             	mov    0x8(%ebp),%eax
  801366:	8a 00                	mov    (%eax),%al
  801368:	84 c0                	test   %al,%al
  80136a:	74 8b                	je     8012f7 <strsplit+0x23>
  80136c:	8b 45 08             	mov    0x8(%ebp),%eax
  80136f:	8a 00                	mov    (%eax),%al
  801371:	0f be c0             	movsbl %al,%eax
  801374:	50                   	push   %eax
  801375:	ff 75 0c             	pushl  0xc(%ebp)
  801378:	e8 b5 fa ff ff       	call   800e32 <strchr>
  80137d:	83 c4 08             	add    $0x8,%esp
  801380:	85 c0                	test   %eax,%eax
  801382:	74 dc                	je     801360 <strsplit+0x8c>
			string++;
	}
  801384:	e9 6e ff ff ff       	jmp    8012f7 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801389:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80138a:	8b 45 14             	mov    0x14(%ebp),%eax
  80138d:	8b 00                	mov    (%eax),%eax
  80138f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801396:	8b 45 10             	mov    0x10(%ebp),%eax
  801399:	01 d0                	add    %edx,%eax
  80139b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8013a1:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8013a6:	c9                   	leave  
  8013a7:	c3                   	ret    

008013a8 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  8013a8:	55                   	push   %ebp
  8013a9:	89 e5                	mov    %esp,%ebp
  8013ab:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  8013ae:	a1 04 40 80 00       	mov    0x804004,%eax
  8013b3:	85 c0                	test   %eax,%eax
  8013b5:	74 1f                	je     8013d6 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  8013b7:	e8 1d 00 00 00       	call   8013d9 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  8013bc:	83 ec 0c             	sub    $0xc,%esp
  8013bf:	68 30 3a 80 00       	push   $0x803a30
  8013c4:	e8 55 f2 ff ff       	call   80061e <cprintf>
  8013c9:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  8013cc:	c7 05 04 40 80 00 00 	movl   $0x0,0x804004
  8013d3:	00 00 00 
	}
}
  8013d6:	90                   	nop
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  8013df:	c7 05 40 40 80 00 00 	movl   $0x0,0x804040
  8013e6:	00 00 00 
  8013e9:	c7 05 44 40 80 00 00 	movl   $0x0,0x804044
  8013f0:	00 00 00 
  8013f3:	c7 05 4c 40 80 00 00 	movl   $0x0,0x80404c
  8013fa:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8013fd:	c7 05 38 41 80 00 00 	movl   $0x0,0x804138
  801404:	00 00 00 
  801407:	c7 05 3c 41 80 00 00 	movl   $0x0,0x80413c
  80140e:	00 00 00 
  801411:	c7 05 44 41 80 00 00 	movl   $0x0,0x804144
  801418:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  80141b:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801422:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801425:	c1 e8 0c             	shr    $0xc,%eax
  801428:	a3 20 41 80 00       	mov    %eax,0x804120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  80142d:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801434:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801437:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80143c:	2d 00 10 00 00       	sub    $0x1000,%eax
  801441:	a3 50 40 80 00       	mov    %eax,0x804050
		uint32 MEMsize=sizeof(struct MemBlock);
  801446:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  80144d:	a1 20 41 80 00       	mov    0x804120,%eax
  801452:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801456:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801459:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801460:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801463:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801466:	01 d0                	add    %edx,%eax
  801468:	48                   	dec    %eax
  801469:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80146c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80146f:	ba 00 00 00 00       	mov    $0x0,%edx
  801474:	f7 75 e4             	divl   -0x1c(%ebp)
  801477:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80147a:	29 d0                	sub    %edx,%eax
  80147c:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  80147f:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801486:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801489:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80148e:	2d 00 10 00 00       	sub    $0x1000,%eax
  801493:	83 ec 04             	sub    $0x4,%esp
  801496:	6a 07                	push   $0x7
  801498:	ff 75 e8             	pushl  -0x18(%ebp)
  80149b:	50                   	push   %eax
  80149c:	e8 3d 06 00 00       	call   801ade <sys_allocate_chunk>
  8014a1:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  8014a4:	a1 20 41 80 00       	mov    0x804120,%eax
  8014a9:	83 ec 0c             	sub    $0xc,%esp
  8014ac:	50                   	push   %eax
  8014ad:	e8 b2 0c 00 00       	call   802164 <initialize_MemBlocksList>
  8014b2:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  8014b5:	a1 4c 41 80 00       	mov    0x80414c,%eax
  8014ba:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  8014bd:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014c1:	0f 84 f3 00 00 00    	je     8015ba <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  8014c7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8014cb:	75 14                	jne    8014e1 <initialize_dyn_block_system+0x108>
  8014cd:	83 ec 04             	sub    $0x4,%esp
  8014d0:	68 55 3a 80 00       	push   $0x803a55
  8014d5:	6a 36                	push   $0x36
  8014d7:	68 73 3a 80 00       	push   $0x803a73
  8014dc:	e8 89 ee ff ff       	call   80036a <_panic>
  8014e1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014e4:	8b 00                	mov    (%eax),%eax
  8014e6:	85 c0                	test   %eax,%eax
  8014e8:	74 10                	je     8014fa <initialize_dyn_block_system+0x121>
  8014ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014ed:	8b 00                	mov    (%eax),%eax
  8014ef:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8014f2:	8b 52 04             	mov    0x4(%edx),%edx
  8014f5:	89 50 04             	mov    %edx,0x4(%eax)
  8014f8:	eb 0b                	jmp    801505 <initialize_dyn_block_system+0x12c>
  8014fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8014fd:	8b 40 04             	mov    0x4(%eax),%eax
  801500:	a3 4c 41 80 00       	mov    %eax,0x80414c
  801505:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801508:	8b 40 04             	mov    0x4(%eax),%eax
  80150b:	85 c0                	test   %eax,%eax
  80150d:	74 0f                	je     80151e <initialize_dyn_block_system+0x145>
  80150f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801512:	8b 40 04             	mov    0x4(%eax),%eax
  801515:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801518:	8b 12                	mov    (%edx),%edx
  80151a:	89 10                	mov    %edx,(%eax)
  80151c:	eb 0a                	jmp    801528 <initialize_dyn_block_system+0x14f>
  80151e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801521:	8b 00                	mov    (%eax),%eax
  801523:	a3 48 41 80 00       	mov    %eax,0x804148
  801528:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80152b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801531:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801534:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80153b:	a1 54 41 80 00       	mov    0x804154,%eax
  801540:	48                   	dec    %eax
  801541:	a3 54 41 80 00       	mov    %eax,0x804154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801546:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801549:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801550:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801553:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  80155a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80155e:	75 14                	jne    801574 <initialize_dyn_block_system+0x19b>
  801560:	83 ec 04             	sub    $0x4,%esp
  801563:	68 80 3a 80 00       	push   $0x803a80
  801568:	6a 3e                	push   $0x3e
  80156a:	68 73 3a 80 00       	push   $0x803a73
  80156f:	e8 f6 ed ff ff       	call   80036a <_panic>
  801574:	8b 15 38 41 80 00    	mov    0x804138,%edx
  80157a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80157d:	89 10                	mov    %edx,(%eax)
  80157f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801582:	8b 00                	mov    (%eax),%eax
  801584:	85 c0                	test   %eax,%eax
  801586:	74 0d                	je     801595 <initialize_dyn_block_system+0x1bc>
  801588:	a1 38 41 80 00       	mov    0x804138,%eax
  80158d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801590:	89 50 04             	mov    %edx,0x4(%eax)
  801593:	eb 08                	jmp    80159d <initialize_dyn_block_system+0x1c4>
  801595:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801598:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80159d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015a0:	a3 38 41 80 00       	mov    %eax,0x804138
  8015a5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8015a8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8015af:	a1 44 41 80 00       	mov    0x804144,%eax
  8015b4:	40                   	inc    %eax
  8015b5:	a3 44 41 80 00       	mov    %eax,0x804144

				}


}
  8015ba:	90                   	nop
  8015bb:	c9                   	leave  
  8015bc:	c3                   	ret    

008015bd <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  8015bd:	55                   	push   %ebp
  8015be:	89 e5                	mov    %esp,%ebp
  8015c0:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  8015c3:	e8 e0 fd ff ff       	call   8013a8 <InitializeUHeap>
		if (size == 0) return NULL ;
  8015c8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8015cc:	75 07                	jne    8015d5 <malloc+0x18>
  8015ce:	b8 00 00 00 00       	mov    $0x0,%eax
  8015d3:	eb 7f                	jmp    801654 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  8015d5:	e8 d2 08 00 00       	call   801eac <sys_isUHeapPlacementStrategyFIRSTFIT>
  8015da:	85 c0                	test   %eax,%eax
  8015dc:	74 71                	je     80164f <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  8015de:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  8015e5:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015eb:	01 d0                	add    %edx,%eax
  8015ed:	48                   	dec    %eax
  8015ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8015f1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015f4:	ba 00 00 00 00       	mov    $0x0,%edx
  8015f9:	f7 75 f4             	divl   -0xc(%ebp)
  8015fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8015ff:	29 d0                	sub    %edx,%eax
  801601:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801604:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  80160b:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801612:	76 07                	jbe    80161b <malloc+0x5e>
					return NULL ;
  801614:	b8 00 00 00 00       	mov    $0x0,%eax
  801619:	eb 39                	jmp    801654 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  80161b:	83 ec 0c             	sub    $0xc,%esp
  80161e:	ff 75 08             	pushl  0x8(%ebp)
  801621:	e8 e6 0d 00 00       	call   80240c <alloc_block_FF>
  801626:	83 c4 10             	add    $0x10,%esp
  801629:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  80162c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801630:	74 16                	je     801648 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801632:	83 ec 0c             	sub    $0xc,%esp
  801635:	ff 75 ec             	pushl  -0x14(%ebp)
  801638:	e8 37 0c 00 00       	call   802274 <insert_sorted_allocList>
  80163d:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801640:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801643:	8b 40 08             	mov    0x8(%eax),%eax
  801646:	eb 0c                	jmp    801654 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801648:	b8 00 00 00 00       	mov    $0x0,%eax
  80164d:	eb 05                	jmp    801654 <malloc+0x97>
				}
		}
	return 0;
  80164f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801654:	c9                   	leave  
  801655:	c3                   	ret    

00801656 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801656:	55                   	push   %ebp
  801657:	89 e5                	mov    %esp,%ebp
  801659:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801662:	83 ec 08             	sub    $0x8,%esp
  801665:	ff 75 f4             	pushl  -0xc(%ebp)
  801668:	68 40 40 80 00       	push   $0x804040
  80166d:	e8 cf 0b 00 00       	call   802241 <find_block>
  801672:	83 c4 10             	add    $0x10,%esp
  801675:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801678:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80167b:	8b 40 0c             	mov    0xc(%eax),%eax
  80167e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801681:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801684:	8b 40 08             	mov    0x8(%eax),%eax
  801687:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  80168a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80168e:	0f 84 a1 00 00 00    	je     801735 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801694:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801698:	75 17                	jne    8016b1 <free+0x5b>
  80169a:	83 ec 04             	sub    $0x4,%esp
  80169d:	68 55 3a 80 00       	push   $0x803a55
  8016a2:	68 80 00 00 00       	push   $0x80
  8016a7:	68 73 3a 80 00       	push   $0x803a73
  8016ac:	e8 b9 ec ff ff       	call   80036a <_panic>
  8016b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016b4:	8b 00                	mov    (%eax),%eax
  8016b6:	85 c0                	test   %eax,%eax
  8016b8:	74 10                	je     8016ca <free+0x74>
  8016ba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016bd:	8b 00                	mov    (%eax),%eax
  8016bf:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016c2:	8b 52 04             	mov    0x4(%edx),%edx
  8016c5:	89 50 04             	mov    %edx,0x4(%eax)
  8016c8:	eb 0b                	jmp    8016d5 <free+0x7f>
  8016ca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016cd:	8b 40 04             	mov    0x4(%eax),%eax
  8016d0:	a3 44 40 80 00       	mov    %eax,0x804044
  8016d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016d8:	8b 40 04             	mov    0x4(%eax),%eax
  8016db:	85 c0                	test   %eax,%eax
  8016dd:	74 0f                	je     8016ee <free+0x98>
  8016df:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016e2:	8b 40 04             	mov    0x4(%eax),%eax
  8016e5:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8016e8:	8b 12                	mov    (%edx),%edx
  8016ea:	89 10                	mov    %edx,(%eax)
  8016ec:	eb 0a                	jmp    8016f8 <free+0xa2>
  8016ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016f1:	8b 00                	mov    (%eax),%eax
  8016f3:	a3 40 40 80 00       	mov    %eax,0x804040
  8016f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8016fb:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801701:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801704:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80170b:	a1 4c 40 80 00       	mov    0x80404c,%eax
  801710:	48                   	dec    %eax
  801711:	a3 4c 40 80 00       	mov    %eax,0x80404c
			insert_sorted_with_merge_freeList(block);
  801716:	83 ec 0c             	sub    $0xc,%esp
  801719:	ff 75 f0             	pushl  -0x10(%ebp)
  80171c:	e8 29 12 00 00       	call   80294a <insert_sorted_with_merge_freeList>
  801721:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801724:	83 ec 08             	sub    $0x8,%esp
  801727:	ff 75 ec             	pushl  -0x14(%ebp)
  80172a:	ff 75 e8             	pushl  -0x18(%ebp)
  80172d:	e8 74 03 00 00       	call   801aa6 <sys_free_user_mem>
  801732:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801735:	90                   	nop
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 38             	sub    $0x38,%esp
  80173e:	8b 45 10             	mov    0x10(%ebp),%eax
  801741:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801744:	e8 5f fc ff ff       	call   8013a8 <InitializeUHeap>
	if (size == 0) return NULL ;
  801749:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80174d:	75 0a                	jne    801759 <smalloc+0x21>
  80174f:	b8 00 00 00 00       	mov    $0x0,%eax
  801754:	e9 b2 00 00 00       	jmp    80180b <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801759:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801760:	76 0a                	jbe    80176c <smalloc+0x34>
		return NULL;
  801762:	b8 00 00 00 00       	mov    $0x0,%eax
  801767:	e9 9f 00 00 00       	jmp    80180b <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  80176c:	e8 3b 07 00 00       	call   801eac <sys_isUHeapPlacementStrategyFIRSTFIT>
  801771:	85 c0                	test   %eax,%eax
  801773:	0f 84 8d 00 00 00    	je     801806 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801779:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801780:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801787:	8b 55 0c             	mov    0xc(%ebp),%edx
  80178a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80178d:	01 d0                	add    %edx,%eax
  80178f:	48                   	dec    %eax
  801790:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801793:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801796:	ba 00 00 00 00       	mov    $0x0,%edx
  80179b:	f7 75 f0             	divl   -0x10(%ebp)
  80179e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8017a1:	29 d0                	sub    %edx,%eax
  8017a3:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  8017a6:	83 ec 0c             	sub    $0xc,%esp
  8017a9:	ff 75 e8             	pushl  -0x18(%ebp)
  8017ac:	e8 5b 0c 00 00       	call   80240c <alloc_block_FF>
  8017b1:	83 c4 10             	add    $0x10,%esp
  8017b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  8017b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8017bb:	75 07                	jne    8017c4 <smalloc+0x8c>
			return NULL;
  8017bd:	b8 00 00 00 00       	mov    $0x0,%eax
  8017c2:	eb 47                	jmp    80180b <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  8017c4:	83 ec 0c             	sub    $0xc,%esp
  8017c7:	ff 75 f4             	pushl  -0xc(%ebp)
  8017ca:	e8 a5 0a 00 00       	call   802274 <insert_sorted_allocList>
  8017cf:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  8017d2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d5:	8b 40 08             	mov    0x8(%eax),%eax
  8017d8:	89 c2                	mov    %eax,%edx
  8017da:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  8017de:	52                   	push   %edx
  8017df:	50                   	push   %eax
  8017e0:	ff 75 0c             	pushl  0xc(%ebp)
  8017e3:	ff 75 08             	pushl  0x8(%ebp)
  8017e6:	e8 46 04 00 00       	call   801c31 <sys_createSharedObject>
  8017eb:	83 c4 10             	add    $0x10,%esp
  8017ee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  8017f1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8017f5:	78 08                	js     8017ff <smalloc+0xc7>
		return (void *)b->sva;
  8017f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017fa:	8b 40 08             	mov    0x8(%eax),%eax
  8017fd:	eb 0c                	jmp    80180b <smalloc+0xd3>
		}else{
		return NULL;
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
  801804:	eb 05                	jmp    80180b <smalloc+0xd3>
			}

	}return NULL;
  801806:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80180b:	c9                   	leave  
  80180c:	c3                   	ret    

0080180d <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80180d:	55                   	push   %ebp
  80180e:	89 e5                	mov    %esp,%ebp
  801810:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801813:	e8 90 fb ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801818:	e8 8f 06 00 00       	call   801eac <sys_isUHeapPlacementStrategyFIRSTFIT>
  80181d:	85 c0                	test   %eax,%eax
  80181f:	0f 84 ad 00 00 00    	je     8018d2 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801825:	83 ec 08             	sub    $0x8,%esp
  801828:	ff 75 0c             	pushl  0xc(%ebp)
  80182b:	ff 75 08             	pushl  0x8(%ebp)
  80182e:	e8 28 04 00 00       	call   801c5b <sys_getSizeOfSharedObject>
  801833:	83 c4 10             	add    $0x10,%esp
  801836:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801839:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80183d:	79 0a                	jns    801849 <sget+0x3c>
    {
    	return NULL;
  80183f:	b8 00 00 00 00       	mov    $0x0,%eax
  801844:	e9 8e 00 00 00       	jmp    8018d7 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801849:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801850:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801857:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80185a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80185d:	01 d0                	add    %edx,%eax
  80185f:	48                   	dec    %eax
  801860:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801863:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801866:	ba 00 00 00 00       	mov    $0x0,%edx
  80186b:	f7 75 ec             	divl   -0x14(%ebp)
  80186e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801871:	29 d0                	sub    %edx,%eax
  801873:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801876:	83 ec 0c             	sub    $0xc,%esp
  801879:	ff 75 e4             	pushl  -0x1c(%ebp)
  80187c:	e8 8b 0b 00 00       	call   80240c <alloc_block_FF>
  801881:	83 c4 10             	add    $0x10,%esp
  801884:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801887:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80188b:	75 07                	jne    801894 <sget+0x87>
				return NULL;
  80188d:	b8 00 00 00 00       	mov    $0x0,%eax
  801892:	eb 43                	jmp    8018d7 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801894:	83 ec 0c             	sub    $0xc,%esp
  801897:	ff 75 f0             	pushl  -0x10(%ebp)
  80189a:	e8 d5 09 00 00       	call   802274 <insert_sorted_allocList>
  80189f:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8018a2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018a5:	8b 40 08             	mov    0x8(%eax),%eax
  8018a8:	83 ec 04             	sub    $0x4,%esp
  8018ab:	50                   	push   %eax
  8018ac:	ff 75 0c             	pushl  0xc(%ebp)
  8018af:	ff 75 08             	pushl  0x8(%ebp)
  8018b2:	e8 c1 03 00 00       	call   801c78 <sys_getSharedObject>
  8018b7:	83 c4 10             	add    $0x10,%esp
  8018ba:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8018bd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8018c1:	78 08                	js     8018cb <sget+0xbe>
			return (void *)b->sva;
  8018c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8018c6:	8b 40 08             	mov    0x8(%eax),%eax
  8018c9:	eb 0c                	jmp    8018d7 <sget+0xca>
			}else{
			return NULL;
  8018cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8018d0:	eb 05                	jmp    8018d7 <sget+0xca>
			}
    }}return NULL;
  8018d2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
  8018dc:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  8018df:	e8 c4 fa ff ff       	call   8013a8 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  8018e4:	83 ec 04             	sub    $0x4,%esp
  8018e7:	68 a4 3a 80 00       	push   $0x803aa4
  8018ec:	68 03 01 00 00       	push   $0x103
  8018f1:	68 73 3a 80 00       	push   $0x803a73
  8018f6:	e8 6f ea ff ff       	call   80036a <_panic>

008018fb <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  8018fb:	55                   	push   %ebp
  8018fc:	89 e5                	mov    %esp,%ebp
  8018fe:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801901:	83 ec 04             	sub    $0x4,%esp
  801904:	68 cc 3a 80 00       	push   $0x803acc
  801909:	68 17 01 00 00       	push   $0x117
  80190e:	68 73 3a 80 00       	push   $0x803a73
  801913:	e8 52 ea ff ff       	call   80036a <_panic>

00801918 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801918:	55                   	push   %ebp
  801919:	89 e5                	mov    %esp,%ebp
  80191b:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80191e:	83 ec 04             	sub    $0x4,%esp
  801921:	68 f0 3a 80 00       	push   $0x803af0
  801926:	68 22 01 00 00       	push   $0x122
  80192b:	68 73 3a 80 00       	push   $0x803a73
  801930:	e8 35 ea ff ff       	call   80036a <_panic>

00801935 <shrink>:

}
void shrink(uint32 newSize)
{
  801935:	55                   	push   %ebp
  801936:	89 e5                	mov    %esp,%ebp
  801938:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80193b:	83 ec 04             	sub    $0x4,%esp
  80193e:	68 f0 3a 80 00       	push   $0x803af0
  801943:	68 27 01 00 00       	push   $0x127
  801948:	68 73 3a 80 00       	push   $0x803a73
  80194d:	e8 18 ea ff ff       	call   80036a <_panic>

00801952 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801952:	55                   	push   %ebp
  801953:	89 e5                	mov    %esp,%ebp
  801955:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801958:	83 ec 04             	sub    $0x4,%esp
  80195b:	68 f0 3a 80 00       	push   $0x803af0
  801960:	68 2c 01 00 00       	push   $0x12c
  801965:	68 73 3a 80 00       	push   $0x803a73
  80196a:	e8 fb e9 ff ff       	call   80036a <_panic>

0080196f <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80196f:	55                   	push   %ebp
  801970:	89 e5                	mov    %esp,%ebp
  801972:	57                   	push   %edi
  801973:	56                   	push   %esi
  801974:	53                   	push   %ebx
  801975:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801978:	8b 45 08             	mov    0x8(%ebp),%eax
  80197b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80197e:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801981:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801984:	8b 7d 18             	mov    0x18(%ebp),%edi
  801987:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80198a:	cd 30                	int    $0x30
  80198c:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80198f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801992:	83 c4 10             	add    $0x10,%esp
  801995:	5b                   	pop    %ebx
  801996:	5e                   	pop    %esi
  801997:	5f                   	pop    %edi
  801998:	5d                   	pop    %ebp
  801999:	c3                   	ret    

0080199a <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80199a:	55                   	push   %ebp
  80199b:	89 e5                	mov    %esp,%ebp
  80199d:	83 ec 04             	sub    $0x4,%esp
  8019a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8019a6:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8019aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	52                   	push   %edx
  8019b2:	ff 75 0c             	pushl  0xc(%ebp)
  8019b5:	50                   	push   %eax
  8019b6:	6a 00                	push   $0x0
  8019b8:	e8 b2 ff ff ff       	call   80196f <syscall>
  8019bd:	83 c4 18             	add    $0x18,%esp
}
  8019c0:	90                   	nop
  8019c1:	c9                   	leave  
  8019c2:	c3                   	ret    

008019c3 <sys_cgetc>:

int
sys_cgetc(void)
{
  8019c3:	55                   	push   %ebp
  8019c4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8019c6:	6a 00                	push   $0x0
  8019c8:	6a 00                	push   $0x0
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 01                	push   $0x1
  8019d2:	e8 98 ff ff ff       	call   80196f <syscall>
  8019d7:	83 c4 18             	add    $0x18,%esp
}
  8019da:	c9                   	leave  
  8019db:	c3                   	ret    

008019dc <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8019dc:	55                   	push   %ebp
  8019dd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8019df:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	52                   	push   %edx
  8019ec:	50                   	push   %eax
  8019ed:	6a 05                	push   $0x5
  8019ef:	e8 7b ff ff ff       	call   80196f <syscall>
  8019f4:	83 c4 18             	add    $0x18,%esp
}
  8019f7:	c9                   	leave  
  8019f8:	c3                   	ret    

008019f9 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8019f9:	55                   	push   %ebp
  8019fa:	89 e5                	mov    %esp,%ebp
  8019fc:	56                   	push   %esi
  8019fd:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8019fe:	8b 75 18             	mov    0x18(%ebp),%esi
  801a01:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a04:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a07:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a0d:	56                   	push   %esi
  801a0e:	53                   	push   %ebx
  801a0f:	51                   	push   %ecx
  801a10:	52                   	push   %edx
  801a11:	50                   	push   %eax
  801a12:	6a 06                	push   $0x6
  801a14:	e8 56 ff ff ff       	call   80196f <syscall>
  801a19:	83 c4 18             	add    $0x18,%esp
}
  801a1c:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801a1f:	5b                   	pop    %ebx
  801a20:	5e                   	pop    %esi
  801a21:	5d                   	pop    %ebp
  801a22:	c3                   	ret    

00801a23 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801a23:	55                   	push   %ebp
  801a24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801a26:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a29:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2c:	6a 00                	push   $0x0
  801a2e:	6a 00                	push   $0x0
  801a30:	6a 00                	push   $0x0
  801a32:	52                   	push   %edx
  801a33:	50                   	push   %eax
  801a34:	6a 07                	push   $0x7
  801a36:	e8 34 ff ff ff       	call   80196f <syscall>
  801a3b:	83 c4 18             	add    $0x18,%esp
}
  801a3e:	c9                   	leave  
  801a3f:	c3                   	ret    

00801a40 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801a40:	55                   	push   %ebp
  801a41:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801a43:	6a 00                	push   $0x0
  801a45:	6a 00                	push   $0x0
  801a47:	6a 00                	push   $0x0
  801a49:	ff 75 0c             	pushl  0xc(%ebp)
  801a4c:	ff 75 08             	pushl  0x8(%ebp)
  801a4f:	6a 08                	push   $0x8
  801a51:	e8 19 ff ff ff       	call   80196f <syscall>
  801a56:	83 c4 18             	add    $0x18,%esp
}
  801a59:	c9                   	leave  
  801a5a:	c3                   	ret    

00801a5b <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801a5b:	55                   	push   %ebp
  801a5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801a5e:	6a 00                	push   $0x0
  801a60:	6a 00                	push   $0x0
  801a62:	6a 00                	push   $0x0
  801a64:	6a 00                	push   $0x0
  801a66:	6a 00                	push   $0x0
  801a68:	6a 09                	push   $0x9
  801a6a:	e8 00 ff ff ff       	call   80196f <syscall>
  801a6f:	83 c4 18             	add    $0x18,%esp
}
  801a72:	c9                   	leave  
  801a73:	c3                   	ret    

00801a74 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801a74:	55                   	push   %ebp
  801a75:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801a77:	6a 00                	push   $0x0
  801a79:	6a 00                	push   $0x0
  801a7b:	6a 00                	push   $0x0
  801a7d:	6a 00                	push   $0x0
  801a7f:	6a 00                	push   $0x0
  801a81:	6a 0a                	push   $0xa
  801a83:	e8 e7 fe ff ff       	call   80196f <syscall>
  801a88:	83 c4 18             	add    $0x18,%esp
}
  801a8b:	c9                   	leave  
  801a8c:	c3                   	ret    

00801a8d <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801a8d:	55                   	push   %ebp
  801a8e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801a90:	6a 00                	push   $0x0
  801a92:	6a 00                	push   $0x0
  801a94:	6a 00                	push   $0x0
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 0b                	push   $0xb
  801a9c:	e8 ce fe ff ff       	call   80196f <syscall>
  801aa1:	83 c4 18             	add    $0x18,%esp
}
  801aa4:	c9                   	leave  
  801aa5:	c3                   	ret    

00801aa6 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801aa6:	55                   	push   %ebp
  801aa7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801aa9:	6a 00                	push   $0x0
  801aab:	6a 00                	push   $0x0
  801aad:	6a 00                	push   $0x0
  801aaf:	ff 75 0c             	pushl  0xc(%ebp)
  801ab2:	ff 75 08             	pushl  0x8(%ebp)
  801ab5:	6a 0f                	push   $0xf
  801ab7:	e8 b3 fe ff ff       	call   80196f <syscall>
  801abc:	83 c4 18             	add    $0x18,%esp
	return;
  801abf:	90                   	nop
}
  801ac0:	c9                   	leave  
  801ac1:	c3                   	ret    

00801ac2 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801ac2:	55                   	push   %ebp
  801ac3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	ff 75 0c             	pushl  0xc(%ebp)
  801ace:	ff 75 08             	pushl  0x8(%ebp)
  801ad1:	6a 10                	push   $0x10
  801ad3:	e8 97 fe ff ff       	call   80196f <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
	return ;
  801adb:	90                   	nop
}
  801adc:	c9                   	leave  
  801add:	c3                   	ret    

00801ade <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801ade:	55                   	push   %ebp
  801adf:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	ff 75 10             	pushl  0x10(%ebp)
  801ae8:	ff 75 0c             	pushl  0xc(%ebp)
  801aeb:	ff 75 08             	pushl  0x8(%ebp)
  801aee:	6a 11                	push   $0x11
  801af0:	e8 7a fe ff ff       	call   80196f <syscall>
  801af5:	83 c4 18             	add    $0x18,%esp
	return ;
  801af8:	90                   	nop
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 00                	push   $0x0
  801b08:	6a 0c                	push   $0xc
  801b0a:	e8 60 fe ff ff       	call   80196f <syscall>
  801b0f:	83 c4 18             	add    $0x18,%esp
}
  801b12:	c9                   	leave  
  801b13:	c3                   	ret    

00801b14 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801b14:	55                   	push   %ebp
  801b15:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801b17:	6a 00                	push   $0x0
  801b19:	6a 00                	push   $0x0
  801b1b:	6a 00                	push   $0x0
  801b1d:	6a 00                	push   $0x0
  801b1f:	ff 75 08             	pushl  0x8(%ebp)
  801b22:	6a 0d                	push   $0xd
  801b24:	e8 46 fe ff ff       	call   80196f <syscall>
  801b29:	83 c4 18             	add    $0x18,%esp
}
  801b2c:	c9                   	leave  
  801b2d:	c3                   	ret    

00801b2e <sys_scarce_memory>:

void sys_scarce_memory()
{
  801b2e:	55                   	push   %ebp
  801b2f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 00                	push   $0x0
  801b39:	6a 00                	push   $0x0
  801b3b:	6a 0e                	push   $0xe
  801b3d:	e8 2d fe ff ff       	call   80196f <syscall>
  801b42:	83 c4 18             	add    $0x18,%esp
}
  801b45:	90                   	nop
  801b46:	c9                   	leave  
  801b47:	c3                   	ret    

00801b48 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801b48:	55                   	push   %ebp
  801b49:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801b4b:	6a 00                	push   $0x0
  801b4d:	6a 00                	push   $0x0
  801b4f:	6a 00                	push   $0x0
  801b51:	6a 00                	push   $0x0
  801b53:	6a 00                	push   $0x0
  801b55:	6a 13                	push   $0x13
  801b57:	e8 13 fe ff ff       	call   80196f <syscall>
  801b5c:	83 c4 18             	add    $0x18,%esp
}
  801b5f:	90                   	nop
  801b60:	c9                   	leave  
  801b61:	c3                   	ret    

00801b62 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801b62:	55                   	push   %ebp
  801b63:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801b65:	6a 00                	push   $0x0
  801b67:	6a 00                	push   $0x0
  801b69:	6a 00                	push   $0x0
  801b6b:	6a 00                	push   $0x0
  801b6d:	6a 00                	push   $0x0
  801b6f:	6a 14                	push   $0x14
  801b71:	e8 f9 fd ff ff       	call   80196f <syscall>
  801b76:	83 c4 18             	add    $0x18,%esp
}
  801b79:	90                   	nop
  801b7a:	c9                   	leave  
  801b7b:	c3                   	ret    

00801b7c <sys_cputc>:


void
sys_cputc(const char c)
{
  801b7c:	55                   	push   %ebp
  801b7d:	89 e5                	mov    %esp,%ebp
  801b7f:	83 ec 04             	sub    $0x4,%esp
  801b82:	8b 45 08             	mov    0x8(%ebp),%eax
  801b85:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801b88:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801b8c:	6a 00                	push   $0x0
  801b8e:	6a 00                	push   $0x0
  801b90:	6a 00                	push   $0x0
  801b92:	6a 00                	push   $0x0
  801b94:	50                   	push   %eax
  801b95:	6a 15                	push   $0x15
  801b97:	e8 d3 fd ff ff       	call   80196f <syscall>
  801b9c:	83 c4 18             	add    $0x18,%esp
}
  801b9f:	90                   	nop
  801ba0:	c9                   	leave  
  801ba1:	c3                   	ret    

00801ba2 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801ba2:	55                   	push   %ebp
  801ba3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801ba5:	6a 00                	push   $0x0
  801ba7:	6a 00                	push   $0x0
  801ba9:	6a 00                	push   $0x0
  801bab:	6a 00                	push   $0x0
  801bad:	6a 00                	push   $0x0
  801baf:	6a 16                	push   $0x16
  801bb1:	e8 b9 fd ff ff       	call   80196f <syscall>
  801bb6:	83 c4 18             	add    $0x18,%esp
}
  801bb9:	90                   	nop
  801bba:	c9                   	leave  
  801bbb:	c3                   	ret    

00801bbc <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801bbc:	55                   	push   %ebp
  801bbd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801bbf:	8b 45 08             	mov    0x8(%ebp),%eax
  801bc2:	6a 00                	push   $0x0
  801bc4:	6a 00                	push   $0x0
  801bc6:	6a 00                	push   $0x0
  801bc8:	ff 75 0c             	pushl  0xc(%ebp)
  801bcb:	50                   	push   %eax
  801bcc:	6a 17                	push   $0x17
  801bce:	e8 9c fd ff ff       	call   80196f <syscall>
  801bd3:	83 c4 18             	add    $0x18,%esp
}
  801bd6:	c9                   	leave  
  801bd7:	c3                   	ret    

00801bd8 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801bd8:	55                   	push   %ebp
  801bd9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bdb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bde:	8b 45 08             	mov    0x8(%ebp),%eax
  801be1:	6a 00                	push   $0x0
  801be3:	6a 00                	push   $0x0
  801be5:	6a 00                	push   $0x0
  801be7:	52                   	push   %edx
  801be8:	50                   	push   %eax
  801be9:	6a 1a                	push   $0x1a
  801beb:	e8 7f fd ff ff       	call   80196f <syscall>
  801bf0:	83 c4 18             	add    $0x18,%esp
}
  801bf3:	c9                   	leave  
  801bf4:	c3                   	ret    

00801bf5 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801bf5:	55                   	push   %ebp
  801bf6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801bf8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bfe:	6a 00                	push   $0x0
  801c00:	6a 00                	push   $0x0
  801c02:	6a 00                	push   $0x0
  801c04:	52                   	push   %edx
  801c05:	50                   	push   %eax
  801c06:	6a 18                	push   $0x18
  801c08:	e8 62 fd ff ff       	call   80196f <syscall>
  801c0d:	83 c4 18             	add    $0x18,%esp
}
  801c10:	90                   	nop
  801c11:	c9                   	leave  
  801c12:	c3                   	ret    

00801c13 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801c13:	55                   	push   %ebp
  801c14:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801c16:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c19:	8b 45 08             	mov    0x8(%ebp),%eax
  801c1c:	6a 00                	push   $0x0
  801c1e:	6a 00                	push   $0x0
  801c20:	6a 00                	push   $0x0
  801c22:	52                   	push   %edx
  801c23:	50                   	push   %eax
  801c24:	6a 19                	push   $0x19
  801c26:	e8 44 fd ff ff       	call   80196f <syscall>
  801c2b:	83 c4 18             	add    $0x18,%esp
}
  801c2e:	90                   	nop
  801c2f:	c9                   	leave  
  801c30:	c3                   	ret    

00801c31 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801c31:	55                   	push   %ebp
  801c32:	89 e5                	mov    %esp,%ebp
  801c34:	83 ec 04             	sub    $0x4,%esp
  801c37:	8b 45 10             	mov    0x10(%ebp),%eax
  801c3a:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801c3d:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801c40:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801c44:	8b 45 08             	mov    0x8(%ebp),%eax
  801c47:	6a 00                	push   $0x0
  801c49:	51                   	push   %ecx
  801c4a:	52                   	push   %edx
  801c4b:	ff 75 0c             	pushl  0xc(%ebp)
  801c4e:	50                   	push   %eax
  801c4f:	6a 1b                	push   $0x1b
  801c51:	e8 19 fd ff ff       	call   80196f <syscall>
  801c56:	83 c4 18             	add    $0x18,%esp
}
  801c59:	c9                   	leave  
  801c5a:	c3                   	ret    

00801c5b <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801c5b:	55                   	push   %ebp
  801c5c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801c5e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c61:	8b 45 08             	mov    0x8(%ebp),%eax
  801c64:	6a 00                	push   $0x0
  801c66:	6a 00                	push   $0x0
  801c68:	6a 00                	push   $0x0
  801c6a:	52                   	push   %edx
  801c6b:	50                   	push   %eax
  801c6c:	6a 1c                	push   $0x1c
  801c6e:	e8 fc fc ff ff       	call   80196f <syscall>
  801c73:	83 c4 18             	add    $0x18,%esp
}
  801c76:	c9                   	leave  
  801c77:	c3                   	ret    

00801c78 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801c78:	55                   	push   %ebp
  801c79:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801c7b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801c7e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c81:	8b 45 08             	mov    0x8(%ebp),%eax
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	51                   	push   %ecx
  801c89:	52                   	push   %edx
  801c8a:	50                   	push   %eax
  801c8b:	6a 1d                	push   $0x1d
  801c8d:	e8 dd fc ff ff       	call   80196f <syscall>
  801c92:	83 c4 18             	add    $0x18,%esp
}
  801c95:	c9                   	leave  
  801c96:	c3                   	ret    

00801c97 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801c97:	55                   	push   %ebp
  801c98:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801c9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 00                	push   $0x0
  801ca4:	6a 00                	push   $0x0
  801ca6:	52                   	push   %edx
  801ca7:	50                   	push   %eax
  801ca8:	6a 1e                	push   $0x1e
  801caa:	e8 c0 fc ff ff       	call   80196f <syscall>
  801caf:	83 c4 18             	add    $0x18,%esp
}
  801cb2:	c9                   	leave  
  801cb3:	c3                   	ret    

00801cb4 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801cb4:	55                   	push   %ebp
  801cb5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 00                	push   $0x0
  801cc1:	6a 1f                	push   $0x1f
  801cc3:	e8 a7 fc ff ff       	call   80196f <syscall>
  801cc8:	83 c4 18             	add    $0x18,%esp
}
  801ccb:	c9                   	leave  
  801ccc:	c3                   	ret    

00801ccd <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801ccd:	55                   	push   %ebp
  801cce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  801cd3:	6a 00                	push   $0x0
  801cd5:	ff 75 14             	pushl  0x14(%ebp)
  801cd8:	ff 75 10             	pushl  0x10(%ebp)
  801cdb:	ff 75 0c             	pushl  0xc(%ebp)
  801cde:	50                   	push   %eax
  801cdf:	6a 20                	push   $0x20
  801ce1:	e8 89 fc ff ff       	call   80196f <syscall>
  801ce6:	83 c4 18             	add    $0x18,%esp
}
  801ce9:	c9                   	leave  
  801cea:	c3                   	ret    

00801ceb <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801ceb:	55                   	push   %ebp
  801cec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801cee:	8b 45 08             	mov    0x8(%ebp),%eax
  801cf1:	6a 00                	push   $0x0
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	50                   	push   %eax
  801cfa:	6a 21                	push   $0x21
  801cfc:	e8 6e fc ff ff       	call   80196f <syscall>
  801d01:	83 c4 18             	add    $0x18,%esp
}
  801d04:	90                   	nop
  801d05:	c9                   	leave  
  801d06:	c3                   	ret    

00801d07 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801d07:	55                   	push   %ebp
  801d08:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801d0a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d0d:	6a 00                	push   $0x0
  801d0f:	6a 00                	push   $0x0
  801d11:	6a 00                	push   $0x0
  801d13:	6a 00                	push   $0x0
  801d15:	50                   	push   %eax
  801d16:	6a 22                	push   $0x22
  801d18:	e8 52 fc ff ff       	call   80196f <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
}
  801d20:	c9                   	leave  
  801d21:	c3                   	ret    

00801d22 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801d22:	55                   	push   %ebp
  801d23:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801d25:	6a 00                	push   $0x0
  801d27:	6a 00                	push   $0x0
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	6a 02                	push   $0x2
  801d31:	e8 39 fc ff ff       	call   80196f <syscall>
  801d36:	83 c4 18             	add    $0x18,%esp
}
  801d39:	c9                   	leave  
  801d3a:	c3                   	ret    

00801d3b <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801d3b:	55                   	push   %ebp
  801d3c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801d3e:	6a 00                	push   $0x0
  801d40:	6a 00                	push   $0x0
  801d42:	6a 00                	push   $0x0
  801d44:	6a 00                	push   $0x0
  801d46:	6a 00                	push   $0x0
  801d48:	6a 03                	push   $0x3
  801d4a:	e8 20 fc ff ff       	call   80196f <syscall>
  801d4f:	83 c4 18             	add    $0x18,%esp
}
  801d52:	c9                   	leave  
  801d53:	c3                   	ret    

00801d54 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801d54:	55                   	push   %ebp
  801d55:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801d57:	6a 00                	push   $0x0
  801d59:	6a 00                	push   $0x0
  801d5b:	6a 00                	push   $0x0
  801d5d:	6a 00                	push   $0x0
  801d5f:	6a 00                	push   $0x0
  801d61:	6a 04                	push   $0x4
  801d63:	e8 07 fc ff ff       	call   80196f <syscall>
  801d68:	83 c4 18             	add    $0x18,%esp
}
  801d6b:	c9                   	leave  
  801d6c:	c3                   	ret    

00801d6d <sys_exit_env>:


void sys_exit_env(void)
{
  801d6d:	55                   	push   %ebp
  801d6e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801d70:	6a 00                	push   $0x0
  801d72:	6a 00                	push   $0x0
  801d74:	6a 00                	push   $0x0
  801d76:	6a 00                	push   $0x0
  801d78:	6a 00                	push   $0x0
  801d7a:	6a 23                	push   $0x23
  801d7c:	e8 ee fb ff ff       	call   80196f <syscall>
  801d81:	83 c4 18             	add    $0x18,%esp
}
  801d84:	90                   	nop
  801d85:	c9                   	leave  
  801d86:	c3                   	ret    

00801d87 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801d87:	55                   	push   %ebp
  801d88:	89 e5                	mov    %esp,%ebp
  801d8a:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801d8d:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d90:	8d 50 04             	lea    0x4(%eax),%edx
  801d93:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801d96:	6a 00                	push   $0x0
  801d98:	6a 00                	push   $0x0
  801d9a:	6a 00                	push   $0x0
  801d9c:	52                   	push   %edx
  801d9d:	50                   	push   %eax
  801d9e:	6a 24                	push   $0x24
  801da0:	e8 ca fb ff ff       	call   80196f <syscall>
  801da5:	83 c4 18             	add    $0x18,%esp
	return result;
  801da8:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801dab:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801dae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801db1:	89 01                	mov    %eax,(%ecx)
  801db3:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801db6:	8b 45 08             	mov    0x8(%ebp),%eax
  801db9:	c9                   	leave  
  801dba:	c2 04 00             	ret    $0x4

00801dbd <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801dbd:	55                   	push   %ebp
  801dbe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801dc0:	6a 00                	push   $0x0
  801dc2:	6a 00                	push   $0x0
  801dc4:	ff 75 10             	pushl  0x10(%ebp)
  801dc7:	ff 75 0c             	pushl  0xc(%ebp)
  801dca:	ff 75 08             	pushl  0x8(%ebp)
  801dcd:	6a 12                	push   $0x12
  801dcf:	e8 9b fb ff ff       	call   80196f <syscall>
  801dd4:	83 c4 18             	add    $0x18,%esp
	return ;
  801dd7:	90                   	nop
}
  801dd8:	c9                   	leave  
  801dd9:	c3                   	ret    

00801dda <sys_rcr2>:
uint32 sys_rcr2()
{
  801dda:	55                   	push   %ebp
  801ddb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801ddd:	6a 00                	push   $0x0
  801ddf:	6a 00                	push   $0x0
  801de1:	6a 00                	push   $0x0
  801de3:	6a 00                	push   $0x0
  801de5:	6a 00                	push   $0x0
  801de7:	6a 25                	push   $0x25
  801de9:	e8 81 fb ff ff       	call   80196f <syscall>
  801dee:	83 c4 18             	add    $0x18,%esp
}
  801df1:	c9                   	leave  
  801df2:	c3                   	ret    

00801df3 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801df3:	55                   	push   %ebp
  801df4:	89 e5                	mov    %esp,%ebp
  801df6:	83 ec 04             	sub    $0x4,%esp
  801df9:	8b 45 08             	mov    0x8(%ebp),%eax
  801dfc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801dff:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801e03:	6a 00                	push   $0x0
  801e05:	6a 00                	push   $0x0
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	50                   	push   %eax
  801e0c:	6a 26                	push   $0x26
  801e0e:	e8 5c fb ff ff       	call   80196f <syscall>
  801e13:	83 c4 18             	add    $0x18,%esp
	return ;
  801e16:	90                   	nop
}
  801e17:	c9                   	leave  
  801e18:	c3                   	ret    

00801e19 <rsttst>:
void rsttst()
{
  801e19:	55                   	push   %ebp
  801e1a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801e1c:	6a 00                	push   $0x0
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 28                	push   $0x28
  801e28:	e8 42 fb ff ff       	call   80196f <syscall>
  801e2d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e30:	90                   	nop
}
  801e31:	c9                   	leave  
  801e32:	c3                   	ret    

00801e33 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801e33:	55                   	push   %ebp
  801e34:	89 e5                	mov    %esp,%ebp
  801e36:	83 ec 04             	sub    $0x4,%esp
  801e39:	8b 45 14             	mov    0x14(%ebp),%eax
  801e3c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801e3f:	8b 55 18             	mov    0x18(%ebp),%edx
  801e42:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801e46:	52                   	push   %edx
  801e47:	50                   	push   %eax
  801e48:	ff 75 10             	pushl  0x10(%ebp)
  801e4b:	ff 75 0c             	pushl  0xc(%ebp)
  801e4e:	ff 75 08             	pushl  0x8(%ebp)
  801e51:	6a 27                	push   $0x27
  801e53:	e8 17 fb ff ff       	call   80196f <syscall>
  801e58:	83 c4 18             	add    $0x18,%esp
	return ;
  801e5b:	90                   	nop
}
  801e5c:	c9                   	leave  
  801e5d:	c3                   	ret    

00801e5e <chktst>:
void chktst(uint32 n)
{
  801e5e:	55                   	push   %ebp
  801e5f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801e61:	6a 00                	push   $0x0
  801e63:	6a 00                	push   $0x0
  801e65:	6a 00                	push   $0x0
  801e67:	6a 00                	push   $0x0
  801e69:	ff 75 08             	pushl  0x8(%ebp)
  801e6c:	6a 29                	push   $0x29
  801e6e:	e8 fc fa ff ff       	call   80196f <syscall>
  801e73:	83 c4 18             	add    $0x18,%esp
	return ;
  801e76:	90                   	nop
}
  801e77:	c9                   	leave  
  801e78:	c3                   	ret    

00801e79 <inctst>:

void inctst()
{
  801e79:	55                   	push   %ebp
  801e7a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801e7c:	6a 00                	push   $0x0
  801e7e:	6a 00                	push   $0x0
  801e80:	6a 00                	push   $0x0
  801e82:	6a 00                	push   $0x0
  801e84:	6a 00                	push   $0x0
  801e86:	6a 2a                	push   $0x2a
  801e88:	e8 e2 fa ff ff       	call   80196f <syscall>
  801e8d:	83 c4 18             	add    $0x18,%esp
	return ;
  801e90:	90                   	nop
}
  801e91:	c9                   	leave  
  801e92:	c3                   	ret    

00801e93 <gettst>:
uint32 gettst()
{
  801e93:	55                   	push   %ebp
  801e94:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801e96:	6a 00                	push   $0x0
  801e98:	6a 00                	push   $0x0
  801e9a:	6a 00                	push   $0x0
  801e9c:	6a 00                	push   $0x0
  801e9e:	6a 00                	push   $0x0
  801ea0:	6a 2b                	push   $0x2b
  801ea2:	e8 c8 fa ff ff       	call   80196f <syscall>
  801ea7:	83 c4 18             	add    $0x18,%esp
}
  801eaa:	c9                   	leave  
  801eab:	c3                   	ret    

00801eac <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801eac:	55                   	push   %ebp
  801ead:	89 e5                	mov    %esp,%ebp
  801eaf:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 2c                	push   $0x2c
  801ebe:	e8 ac fa ff ff       	call   80196f <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
  801ec6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ec9:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801ecd:	75 07                	jne    801ed6 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ecf:	b8 01 00 00 00       	mov    $0x1,%eax
  801ed4:	eb 05                	jmp    801edb <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ed6:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801edb:	c9                   	leave  
  801edc:	c3                   	ret    

00801edd <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801edd:	55                   	push   %ebp
  801ede:	89 e5                	mov    %esp,%ebp
  801ee0:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ee3:	6a 00                	push   $0x0
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 2c                	push   $0x2c
  801eef:	e8 7b fa ff ff       	call   80196f <syscall>
  801ef4:	83 c4 18             	add    $0x18,%esp
  801ef7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801efa:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801efe:	75 07                	jne    801f07 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801f00:	b8 01 00 00 00       	mov    $0x1,%eax
  801f05:	eb 05                	jmp    801f0c <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801f07:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f0c:	c9                   	leave  
  801f0d:	c3                   	ret    

00801f0e <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801f0e:	55                   	push   %ebp
  801f0f:	89 e5                	mov    %esp,%ebp
  801f11:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f14:	6a 00                	push   $0x0
  801f16:	6a 00                	push   $0x0
  801f18:	6a 00                	push   $0x0
  801f1a:	6a 00                	push   $0x0
  801f1c:	6a 00                	push   $0x0
  801f1e:	6a 2c                	push   $0x2c
  801f20:	e8 4a fa ff ff       	call   80196f <syscall>
  801f25:	83 c4 18             	add    $0x18,%esp
  801f28:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801f2b:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801f2f:	75 07                	jne    801f38 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801f31:	b8 01 00 00 00       	mov    $0x1,%eax
  801f36:	eb 05                	jmp    801f3d <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801f38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f3d:	c9                   	leave  
  801f3e:	c3                   	ret    

00801f3f <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801f3f:	55                   	push   %ebp
  801f40:	89 e5                	mov    %esp,%ebp
  801f42:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801f45:	6a 00                	push   $0x0
  801f47:	6a 00                	push   $0x0
  801f49:	6a 00                	push   $0x0
  801f4b:	6a 00                	push   $0x0
  801f4d:	6a 00                	push   $0x0
  801f4f:	6a 2c                	push   $0x2c
  801f51:	e8 19 fa ff ff       	call   80196f <syscall>
  801f56:	83 c4 18             	add    $0x18,%esp
  801f59:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801f5c:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801f60:	75 07                	jne    801f69 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801f62:	b8 01 00 00 00       	mov    $0x1,%eax
  801f67:	eb 05                	jmp    801f6e <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801f69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801f73:	6a 00                	push   $0x0
  801f75:	6a 00                	push   $0x0
  801f77:	6a 00                	push   $0x0
  801f79:	6a 00                	push   $0x0
  801f7b:	ff 75 08             	pushl  0x8(%ebp)
  801f7e:	6a 2d                	push   $0x2d
  801f80:	e8 ea f9 ff ff       	call   80196f <syscall>
  801f85:	83 c4 18             	add    $0x18,%esp
	return ;
  801f88:	90                   	nop
}
  801f89:	c9                   	leave  
  801f8a:	c3                   	ret    

00801f8b <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801f8b:	55                   	push   %ebp
  801f8c:	89 e5                	mov    %esp,%ebp
  801f8e:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801f8f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f92:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f95:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f98:	8b 45 08             	mov    0x8(%ebp),%eax
  801f9b:	6a 00                	push   $0x0
  801f9d:	53                   	push   %ebx
  801f9e:	51                   	push   %ecx
  801f9f:	52                   	push   %edx
  801fa0:	50                   	push   %eax
  801fa1:	6a 2e                	push   $0x2e
  801fa3:	e8 c7 f9 ff ff       	call   80196f <syscall>
  801fa8:	83 c4 18             	add    $0x18,%esp
}
  801fab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801fae:	c9                   	leave  
  801faf:	c3                   	ret    

00801fb0 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801fb0:	55                   	push   %ebp
  801fb1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801fb3:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fb6:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb9:	6a 00                	push   $0x0
  801fbb:	6a 00                	push   $0x0
  801fbd:	6a 00                	push   $0x0
  801fbf:	52                   	push   %edx
  801fc0:	50                   	push   %eax
  801fc1:	6a 2f                	push   $0x2f
  801fc3:	e8 a7 f9 ff ff       	call   80196f <syscall>
  801fc8:	83 c4 18             	add    $0x18,%esp
}
  801fcb:	c9                   	leave  
  801fcc:	c3                   	ret    

00801fcd <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  801fcd:	55                   	push   %ebp
  801fce:	89 e5                	mov    %esp,%ebp
  801fd0:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  801fd3:	83 ec 0c             	sub    $0xc,%esp
  801fd6:	68 00 3b 80 00       	push   $0x803b00
  801fdb:	e8 3e e6 ff ff       	call   80061e <cprintf>
  801fe0:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  801fe3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  801fea:	83 ec 0c             	sub    $0xc,%esp
  801fed:	68 2c 3b 80 00       	push   $0x803b2c
  801ff2:	e8 27 e6 ff ff       	call   80061e <cprintf>
  801ff7:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  801ffa:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  801ffe:	a1 38 41 80 00       	mov    0x804138,%eax
  802003:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802006:	eb 56                	jmp    80205e <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802008:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80200c:	74 1c                	je     80202a <print_mem_block_lists+0x5d>
  80200e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802011:	8b 50 08             	mov    0x8(%eax),%edx
  802014:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802017:	8b 48 08             	mov    0x8(%eax),%ecx
  80201a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80201d:	8b 40 0c             	mov    0xc(%eax),%eax
  802020:	01 c8                	add    %ecx,%eax
  802022:	39 c2                	cmp    %eax,%edx
  802024:	73 04                	jae    80202a <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802026:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80202a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80202d:	8b 50 08             	mov    0x8(%eax),%edx
  802030:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802033:	8b 40 0c             	mov    0xc(%eax),%eax
  802036:	01 c2                	add    %eax,%edx
  802038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80203b:	8b 40 08             	mov    0x8(%eax),%eax
  80203e:	83 ec 04             	sub    $0x4,%esp
  802041:	52                   	push   %edx
  802042:	50                   	push   %eax
  802043:	68 41 3b 80 00       	push   $0x803b41
  802048:	e8 d1 e5 ff ff       	call   80061e <cprintf>
  80204d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802053:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802056:	a1 40 41 80 00       	mov    0x804140,%eax
  80205b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80205e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802062:	74 07                	je     80206b <print_mem_block_lists+0x9e>
  802064:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802067:	8b 00                	mov    (%eax),%eax
  802069:	eb 05                	jmp    802070 <print_mem_block_lists+0xa3>
  80206b:	b8 00 00 00 00       	mov    $0x0,%eax
  802070:	a3 40 41 80 00       	mov    %eax,0x804140
  802075:	a1 40 41 80 00       	mov    0x804140,%eax
  80207a:	85 c0                	test   %eax,%eax
  80207c:	75 8a                	jne    802008 <print_mem_block_lists+0x3b>
  80207e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802082:	75 84                	jne    802008 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802084:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802088:	75 10                	jne    80209a <print_mem_block_lists+0xcd>
  80208a:	83 ec 0c             	sub    $0xc,%esp
  80208d:	68 50 3b 80 00       	push   $0x803b50
  802092:	e8 87 e5 ff ff       	call   80061e <cprintf>
  802097:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80209a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8020a1:	83 ec 0c             	sub    $0xc,%esp
  8020a4:	68 74 3b 80 00       	push   $0x803b74
  8020a9:	e8 70 e5 ff ff       	call   80061e <cprintf>
  8020ae:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8020b1:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8020b5:	a1 40 40 80 00       	mov    0x804040,%eax
  8020ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8020bd:	eb 56                	jmp    802115 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8020bf:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c3:	74 1c                	je     8020e1 <print_mem_block_lists+0x114>
  8020c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020c8:	8b 50 08             	mov    0x8(%eax),%edx
  8020cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020ce:	8b 48 08             	mov    0x8(%eax),%ecx
  8020d1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020d4:	8b 40 0c             	mov    0xc(%eax),%eax
  8020d7:	01 c8                	add    %ecx,%eax
  8020d9:	39 c2                	cmp    %eax,%edx
  8020db:	73 04                	jae    8020e1 <print_mem_block_lists+0x114>
			sorted = 0 ;
  8020dd:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8020e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020e4:	8b 50 08             	mov    0x8(%eax),%edx
  8020e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8020ed:	01 c2                	add    %eax,%edx
  8020ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8020f2:	8b 40 08             	mov    0x8(%eax),%eax
  8020f5:	83 ec 04             	sub    $0x4,%esp
  8020f8:	52                   	push   %edx
  8020f9:	50                   	push   %eax
  8020fa:	68 41 3b 80 00       	push   $0x803b41
  8020ff:	e8 1a e5 ff ff       	call   80061e <cprintf>
  802104:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802107:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80210a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80210d:	a1 48 40 80 00       	mov    0x804048,%eax
  802112:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802115:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802119:	74 07                	je     802122 <print_mem_block_lists+0x155>
  80211b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80211e:	8b 00                	mov    (%eax),%eax
  802120:	eb 05                	jmp    802127 <print_mem_block_lists+0x15a>
  802122:	b8 00 00 00 00       	mov    $0x0,%eax
  802127:	a3 48 40 80 00       	mov    %eax,0x804048
  80212c:	a1 48 40 80 00       	mov    0x804048,%eax
  802131:	85 c0                	test   %eax,%eax
  802133:	75 8a                	jne    8020bf <print_mem_block_lists+0xf2>
  802135:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802139:	75 84                	jne    8020bf <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  80213b:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80213f:	75 10                	jne    802151 <print_mem_block_lists+0x184>
  802141:	83 ec 0c             	sub    $0xc,%esp
  802144:	68 8c 3b 80 00       	push   $0x803b8c
  802149:	e8 d0 e4 ff ff       	call   80061e <cprintf>
  80214e:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802151:	83 ec 0c             	sub    $0xc,%esp
  802154:	68 00 3b 80 00       	push   $0x803b00
  802159:	e8 c0 e4 ff ff       	call   80061e <cprintf>
  80215e:	83 c4 10             	add    $0x10,%esp

}
  802161:	90                   	nop
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
  802167:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80216a:	c7 05 48 41 80 00 00 	movl   $0x0,0x804148
  802171:	00 00 00 
  802174:	c7 05 4c 41 80 00 00 	movl   $0x0,0x80414c
  80217b:	00 00 00 
  80217e:	c7 05 54 41 80 00 00 	movl   $0x0,0x804154
  802185:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802188:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  80218f:	e9 9e 00 00 00       	jmp    802232 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802194:	a1 50 40 80 00       	mov    0x804050,%eax
  802199:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80219c:	c1 e2 04             	shl    $0x4,%edx
  80219f:	01 d0                	add    %edx,%eax
  8021a1:	85 c0                	test   %eax,%eax
  8021a3:	75 14                	jne    8021b9 <initialize_MemBlocksList+0x55>
  8021a5:	83 ec 04             	sub    $0x4,%esp
  8021a8:	68 b4 3b 80 00       	push   $0x803bb4
  8021ad:	6a 3d                	push   $0x3d
  8021af:	68 d7 3b 80 00       	push   $0x803bd7
  8021b4:	e8 b1 e1 ff ff       	call   80036a <_panic>
  8021b9:	a1 50 40 80 00       	mov    0x804050,%eax
  8021be:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021c1:	c1 e2 04             	shl    $0x4,%edx
  8021c4:	01 d0                	add    %edx,%eax
  8021c6:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8021cc:	89 10                	mov    %edx,(%eax)
  8021ce:	8b 00                	mov    (%eax),%eax
  8021d0:	85 c0                	test   %eax,%eax
  8021d2:	74 18                	je     8021ec <initialize_MemBlocksList+0x88>
  8021d4:	a1 48 41 80 00       	mov    0x804148,%eax
  8021d9:	8b 15 50 40 80 00    	mov    0x804050,%edx
  8021df:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8021e2:	c1 e1 04             	shl    $0x4,%ecx
  8021e5:	01 ca                	add    %ecx,%edx
  8021e7:	89 50 04             	mov    %edx,0x4(%eax)
  8021ea:	eb 12                	jmp    8021fe <initialize_MemBlocksList+0x9a>
  8021ec:	a1 50 40 80 00       	mov    0x804050,%eax
  8021f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8021f4:	c1 e2 04             	shl    $0x4,%edx
  8021f7:	01 d0                	add    %edx,%eax
  8021f9:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8021fe:	a1 50 40 80 00       	mov    0x804050,%eax
  802203:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802206:	c1 e2 04             	shl    $0x4,%edx
  802209:	01 d0                	add    %edx,%eax
  80220b:	a3 48 41 80 00       	mov    %eax,0x804148
  802210:	a1 50 40 80 00       	mov    0x804050,%eax
  802215:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802218:	c1 e2 04             	shl    $0x4,%edx
  80221b:	01 d0                	add    %edx,%eax
  80221d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802224:	a1 54 41 80 00       	mov    0x804154,%eax
  802229:	40                   	inc    %eax
  80222a:	a3 54 41 80 00       	mov    %eax,0x804154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80222f:	ff 45 f4             	incl   -0xc(%ebp)
  802232:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802235:	3b 45 08             	cmp    0x8(%ebp),%eax
  802238:	0f 82 56 ff ff ff    	jb     802194 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  80223e:	90                   	nop
  80223f:	c9                   	leave  
  802240:	c3                   	ret    

00802241 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802241:	55                   	push   %ebp
  802242:	89 e5                	mov    %esp,%ebp
  802244:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802247:	8b 45 08             	mov    0x8(%ebp),%eax
  80224a:	8b 00                	mov    (%eax),%eax
  80224c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  80224f:	eb 18                	jmp    802269 <find_block+0x28>

		if(tmp->sva == va){
  802251:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802254:	8b 40 08             	mov    0x8(%eax),%eax
  802257:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80225a:	75 05                	jne    802261 <find_block+0x20>
			return tmp ;
  80225c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80225f:	eb 11                	jmp    802272 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802261:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802264:	8b 00                	mov    (%eax),%eax
  802266:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802269:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80226d:	75 e2                	jne    802251 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  80226f:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802272:	c9                   	leave  
  802273:	c3                   	ret    

00802274 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802274:	55                   	push   %ebp
  802275:	89 e5                	mov    %esp,%ebp
  802277:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  80227a:	a1 40 40 80 00       	mov    0x804040,%eax
  80227f:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802282:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802287:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  80228a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80228e:	75 65                	jne    8022f5 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802290:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802294:	75 14                	jne    8022aa <insert_sorted_allocList+0x36>
  802296:	83 ec 04             	sub    $0x4,%esp
  802299:	68 b4 3b 80 00       	push   $0x803bb4
  80229e:	6a 62                	push   $0x62
  8022a0:	68 d7 3b 80 00       	push   $0x803bd7
  8022a5:	e8 c0 e0 ff ff       	call   80036a <_panic>
  8022aa:	8b 15 40 40 80 00    	mov    0x804040,%edx
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	89 10                	mov    %edx,(%eax)
  8022b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b8:	8b 00                	mov    (%eax),%eax
  8022ba:	85 c0                	test   %eax,%eax
  8022bc:	74 0d                	je     8022cb <insert_sorted_allocList+0x57>
  8022be:	a1 40 40 80 00       	mov    0x804040,%eax
  8022c3:	8b 55 08             	mov    0x8(%ebp),%edx
  8022c6:	89 50 04             	mov    %edx,0x4(%eax)
  8022c9:	eb 08                	jmp    8022d3 <insert_sorted_allocList+0x5f>
  8022cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022ce:	a3 44 40 80 00       	mov    %eax,0x804044
  8022d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8022d6:	a3 40 40 80 00       	mov    %eax,0x804040
  8022db:	8b 45 08             	mov    0x8(%ebp),%eax
  8022de:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8022e5:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8022ea:	40                   	inc    %eax
  8022eb:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8022f0:	e9 14 01 00 00       	jmp    802409 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  8022f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8022f8:	8b 50 08             	mov    0x8(%eax),%edx
  8022fb:	a1 44 40 80 00       	mov    0x804044,%eax
  802300:	8b 40 08             	mov    0x8(%eax),%eax
  802303:	39 c2                	cmp    %eax,%edx
  802305:	76 65                	jbe    80236c <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802307:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80230b:	75 14                	jne    802321 <insert_sorted_allocList+0xad>
  80230d:	83 ec 04             	sub    $0x4,%esp
  802310:	68 f0 3b 80 00       	push   $0x803bf0
  802315:	6a 64                	push   $0x64
  802317:	68 d7 3b 80 00       	push   $0x803bd7
  80231c:	e8 49 e0 ff ff       	call   80036a <_panic>
  802321:	8b 15 44 40 80 00    	mov    0x804044,%edx
  802327:	8b 45 08             	mov    0x8(%ebp),%eax
  80232a:	89 50 04             	mov    %edx,0x4(%eax)
  80232d:	8b 45 08             	mov    0x8(%ebp),%eax
  802330:	8b 40 04             	mov    0x4(%eax),%eax
  802333:	85 c0                	test   %eax,%eax
  802335:	74 0c                	je     802343 <insert_sorted_allocList+0xcf>
  802337:	a1 44 40 80 00       	mov    0x804044,%eax
  80233c:	8b 55 08             	mov    0x8(%ebp),%edx
  80233f:	89 10                	mov    %edx,(%eax)
  802341:	eb 08                	jmp    80234b <insert_sorted_allocList+0xd7>
  802343:	8b 45 08             	mov    0x8(%ebp),%eax
  802346:	a3 40 40 80 00       	mov    %eax,0x804040
  80234b:	8b 45 08             	mov    0x8(%ebp),%eax
  80234e:	a3 44 40 80 00       	mov    %eax,0x804044
  802353:	8b 45 08             	mov    0x8(%ebp),%eax
  802356:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80235c:	a1 4c 40 80 00       	mov    0x80404c,%eax
  802361:	40                   	inc    %eax
  802362:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802367:	e9 9d 00 00 00       	jmp    802409 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80236c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802373:	e9 85 00 00 00       	jmp    8023fd <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	8b 50 08             	mov    0x8(%eax),%edx
  80237e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802381:	8b 40 08             	mov    0x8(%eax),%eax
  802384:	39 c2                	cmp    %eax,%edx
  802386:	73 6a                	jae    8023f2 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802388:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80238c:	74 06                	je     802394 <insert_sorted_allocList+0x120>
  80238e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802392:	75 14                	jne    8023a8 <insert_sorted_allocList+0x134>
  802394:	83 ec 04             	sub    $0x4,%esp
  802397:	68 14 3c 80 00       	push   $0x803c14
  80239c:	6a 6b                	push   $0x6b
  80239e:	68 d7 3b 80 00       	push   $0x803bd7
  8023a3:	e8 c2 df ff ff       	call   80036a <_panic>
  8023a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ab:	8b 50 04             	mov    0x4(%eax),%edx
  8023ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b1:	89 50 04             	mov    %edx,0x4(%eax)
  8023b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8023b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8023ba:	89 10                	mov    %edx,(%eax)
  8023bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023bf:	8b 40 04             	mov    0x4(%eax),%eax
  8023c2:	85 c0                	test   %eax,%eax
  8023c4:	74 0d                	je     8023d3 <insert_sorted_allocList+0x15f>
  8023c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c9:	8b 40 04             	mov    0x4(%eax),%eax
  8023cc:	8b 55 08             	mov    0x8(%ebp),%edx
  8023cf:	89 10                	mov    %edx,(%eax)
  8023d1:	eb 08                	jmp    8023db <insert_sorted_allocList+0x167>
  8023d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d6:	a3 40 40 80 00       	mov    %eax,0x804040
  8023db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023de:	8b 55 08             	mov    0x8(%ebp),%edx
  8023e1:	89 50 04             	mov    %edx,0x4(%eax)
  8023e4:	a1 4c 40 80 00       	mov    0x80404c,%eax
  8023e9:	40                   	inc    %eax
  8023ea:	a3 4c 40 80 00       	mov    %eax,0x80404c
    	    			break;
  8023ef:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8023f0:	eb 17                	jmp    802409 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  8023f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023f5:	8b 00                	mov    (%eax),%eax
  8023f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8023fa:	ff 45 f0             	incl   -0x10(%ebp)
  8023fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802400:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802403:	0f 8c 6f ff ff ff    	jl     802378 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802409:	90                   	nop
  80240a:	c9                   	leave  
  80240b:	c3                   	ret    

0080240c <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  80240c:	55                   	push   %ebp
  80240d:	89 e5                	mov    %esp,%ebp
  80240f:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802412:	a1 38 41 80 00       	mov    0x804138,%eax
  802417:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  80241a:	e9 7c 01 00 00       	jmp    80259b <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  80241f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802422:	8b 40 0c             	mov    0xc(%eax),%eax
  802425:	3b 45 08             	cmp    0x8(%ebp),%eax
  802428:	0f 86 cf 00 00 00    	jbe    8024fd <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80242e:	a1 48 41 80 00       	mov    0x804148,%eax
  802433:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802439:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  80243c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80243f:	8b 55 08             	mov    0x8(%ebp),%edx
  802442:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802445:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802448:	8b 50 08             	mov    0x8(%eax),%edx
  80244b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80244e:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802451:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802454:	8b 40 0c             	mov    0xc(%eax),%eax
  802457:	2b 45 08             	sub    0x8(%ebp),%eax
  80245a:	89 c2                	mov    %eax,%edx
  80245c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80245f:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802462:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802465:	8b 50 08             	mov    0x8(%eax),%edx
  802468:	8b 45 08             	mov    0x8(%ebp),%eax
  80246b:	01 c2                	add    %eax,%edx
  80246d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802470:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802473:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802477:	75 17                	jne    802490 <alloc_block_FF+0x84>
  802479:	83 ec 04             	sub    $0x4,%esp
  80247c:	68 49 3c 80 00       	push   $0x803c49
  802481:	68 83 00 00 00       	push   $0x83
  802486:	68 d7 3b 80 00       	push   $0x803bd7
  80248b:	e8 da de ff ff       	call   80036a <_panic>
  802490:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802493:	8b 00                	mov    (%eax),%eax
  802495:	85 c0                	test   %eax,%eax
  802497:	74 10                	je     8024a9 <alloc_block_FF+0x9d>
  802499:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80249c:	8b 00                	mov    (%eax),%eax
  80249e:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024a1:	8b 52 04             	mov    0x4(%edx),%edx
  8024a4:	89 50 04             	mov    %edx,0x4(%eax)
  8024a7:	eb 0b                	jmp    8024b4 <alloc_block_FF+0xa8>
  8024a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024ac:	8b 40 04             	mov    0x4(%eax),%eax
  8024af:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8024b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024b7:	8b 40 04             	mov    0x4(%eax),%eax
  8024ba:	85 c0                	test   %eax,%eax
  8024bc:	74 0f                	je     8024cd <alloc_block_FF+0xc1>
  8024be:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024c1:	8b 40 04             	mov    0x4(%eax),%eax
  8024c4:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8024c7:	8b 12                	mov    (%edx),%edx
  8024c9:	89 10                	mov    %edx,(%eax)
  8024cb:	eb 0a                	jmp    8024d7 <alloc_block_FF+0xcb>
  8024cd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024d0:	8b 00                	mov    (%eax),%eax
  8024d2:	a3 48 41 80 00       	mov    %eax,0x804148
  8024d7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024da:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8024e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024e3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8024ea:	a1 54 41 80 00       	mov    0x804154,%eax
  8024ef:	48                   	dec    %eax
  8024f0:	a3 54 41 80 00       	mov    %eax,0x804154
                    return newBlock ;
  8024f5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8024f8:	e9 ad 00 00 00       	jmp    8025aa <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  8024fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802500:	8b 40 0c             	mov    0xc(%eax),%eax
  802503:	3b 45 08             	cmp    0x8(%ebp),%eax
  802506:	0f 85 87 00 00 00    	jne    802593 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  80250c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802510:	75 17                	jne    802529 <alloc_block_FF+0x11d>
  802512:	83 ec 04             	sub    $0x4,%esp
  802515:	68 49 3c 80 00       	push   $0x803c49
  80251a:	68 87 00 00 00       	push   $0x87
  80251f:	68 d7 3b 80 00       	push   $0x803bd7
  802524:	e8 41 de ff ff       	call   80036a <_panic>
  802529:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80252c:	8b 00                	mov    (%eax),%eax
  80252e:	85 c0                	test   %eax,%eax
  802530:	74 10                	je     802542 <alloc_block_FF+0x136>
  802532:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802535:	8b 00                	mov    (%eax),%eax
  802537:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80253a:	8b 52 04             	mov    0x4(%edx),%edx
  80253d:	89 50 04             	mov    %edx,0x4(%eax)
  802540:	eb 0b                	jmp    80254d <alloc_block_FF+0x141>
  802542:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802545:	8b 40 04             	mov    0x4(%eax),%eax
  802548:	a3 3c 41 80 00       	mov    %eax,0x80413c
  80254d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802550:	8b 40 04             	mov    0x4(%eax),%eax
  802553:	85 c0                	test   %eax,%eax
  802555:	74 0f                	je     802566 <alloc_block_FF+0x15a>
  802557:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80255a:	8b 40 04             	mov    0x4(%eax),%eax
  80255d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802560:	8b 12                	mov    (%edx),%edx
  802562:	89 10                	mov    %edx,(%eax)
  802564:	eb 0a                	jmp    802570 <alloc_block_FF+0x164>
  802566:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802569:	8b 00                	mov    (%eax),%eax
  80256b:	a3 38 41 80 00       	mov    %eax,0x804138
  802570:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802573:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80257c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802583:	a1 44 41 80 00       	mov    0x804144,%eax
  802588:	48                   	dec    %eax
  802589:	a3 44 41 80 00       	mov    %eax,0x804144
                        return  pointertempp;
  80258e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802591:	eb 17                	jmp    8025aa <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802593:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802596:	8b 00                	mov    (%eax),%eax
  802598:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  80259b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80259f:	0f 85 7a fe ff ff    	jne    80241f <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  8025a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8025aa:	c9                   	leave  
  8025ab:	c3                   	ret    

008025ac <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  8025ac:	55                   	push   %ebp
  8025ad:	89 e5                	mov    %esp,%ebp
  8025af:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  8025b2:	a1 38 41 80 00       	mov    0x804138,%eax
  8025b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  8025ba:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  8025c1:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  8025c8:	a1 38 41 80 00       	mov    0x804138,%eax
  8025cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025d0:	e9 d0 00 00 00       	jmp    8026a5 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  8025d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d8:	8b 40 0c             	mov    0xc(%eax),%eax
  8025db:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025de:	0f 82 b8 00 00 00    	jb     80269c <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  8025e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8025ea:	2b 45 08             	sub    0x8(%ebp),%eax
  8025ed:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  8025f0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025f3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8025f6:	0f 83 a1 00 00 00    	jae    80269d <alloc_block_BF+0xf1>
				differsize = differance ;
  8025fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8025ff:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802602:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802605:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802608:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80260c:	0f 85 8b 00 00 00    	jne    80269d <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802612:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802616:	75 17                	jne    80262f <alloc_block_BF+0x83>
  802618:	83 ec 04             	sub    $0x4,%esp
  80261b:	68 49 3c 80 00       	push   $0x803c49
  802620:	68 a0 00 00 00       	push   $0xa0
  802625:	68 d7 3b 80 00       	push   $0x803bd7
  80262a:	e8 3b dd ff ff       	call   80036a <_panic>
  80262f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802632:	8b 00                	mov    (%eax),%eax
  802634:	85 c0                	test   %eax,%eax
  802636:	74 10                	je     802648 <alloc_block_BF+0x9c>
  802638:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80263b:	8b 00                	mov    (%eax),%eax
  80263d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802640:	8b 52 04             	mov    0x4(%edx),%edx
  802643:	89 50 04             	mov    %edx,0x4(%eax)
  802646:	eb 0b                	jmp    802653 <alloc_block_BF+0xa7>
  802648:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80264b:	8b 40 04             	mov    0x4(%eax),%eax
  80264e:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802653:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802656:	8b 40 04             	mov    0x4(%eax),%eax
  802659:	85 c0                	test   %eax,%eax
  80265b:	74 0f                	je     80266c <alloc_block_BF+0xc0>
  80265d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802660:	8b 40 04             	mov    0x4(%eax),%eax
  802663:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802666:	8b 12                	mov    (%edx),%edx
  802668:	89 10                	mov    %edx,(%eax)
  80266a:	eb 0a                	jmp    802676 <alloc_block_BF+0xca>
  80266c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80266f:	8b 00                	mov    (%eax),%eax
  802671:	a3 38 41 80 00       	mov    %eax,0x804138
  802676:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802679:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80267f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802682:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802689:	a1 44 41 80 00       	mov    0x804144,%eax
  80268e:	48                   	dec    %eax
  80268f:	a3 44 41 80 00       	mov    %eax,0x804144
					return elementiterator;
  802694:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802697:	e9 0c 01 00 00       	jmp    8027a8 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  80269c:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80269d:	a1 40 41 80 00       	mov    0x804140,%eax
  8026a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026a5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026a9:	74 07                	je     8026b2 <alloc_block_BF+0x106>
  8026ab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ae:	8b 00                	mov    (%eax),%eax
  8026b0:	eb 05                	jmp    8026b7 <alloc_block_BF+0x10b>
  8026b2:	b8 00 00 00 00       	mov    $0x0,%eax
  8026b7:	a3 40 41 80 00       	mov    %eax,0x804140
  8026bc:	a1 40 41 80 00       	mov    0x804140,%eax
  8026c1:	85 c0                	test   %eax,%eax
  8026c3:	0f 85 0c ff ff ff    	jne    8025d5 <alloc_block_BF+0x29>
  8026c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026cd:	0f 85 02 ff ff ff    	jne    8025d5 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  8026d3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8026d7:	0f 84 c6 00 00 00    	je     8027a3 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  8026dd:	a1 48 41 80 00       	mov    0x804148,%eax
  8026e2:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  8026e5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026e8:	8b 55 08             	mov    0x8(%ebp),%edx
  8026eb:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  8026ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026f1:	8b 50 08             	mov    0x8(%eax),%edx
  8026f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8026f7:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  8026fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8026fd:	8b 40 0c             	mov    0xc(%eax),%eax
  802700:	2b 45 08             	sub    0x8(%ebp),%eax
  802703:	89 c2                	mov    %eax,%edx
  802705:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802708:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  80270b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80270e:	8b 50 08             	mov    0x8(%eax),%edx
  802711:	8b 45 08             	mov    0x8(%ebp),%eax
  802714:	01 c2                	add    %eax,%edx
  802716:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802719:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  80271c:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802720:	75 17                	jne    802739 <alloc_block_BF+0x18d>
  802722:	83 ec 04             	sub    $0x4,%esp
  802725:	68 49 3c 80 00       	push   $0x803c49
  80272a:	68 af 00 00 00       	push   $0xaf
  80272f:	68 d7 3b 80 00       	push   $0x803bd7
  802734:	e8 31 dc ff ff       	call   80036a <_panic>
  802739:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80273c:	8b 00                	mov    (%eax),%eax
  80273e:	85 c0                	test   %eax,%eax
  802740:	74 10                	je     802752 <alloc_block_BF+0x1a6>
  802742:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802745:	8b 00                	mov    (%eax),%eax
  802747:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80274a:	8b 52 04             	mov    0x4(%edx),%edx
  80274d:	89 50 04             	mov    %edx,0x4(%eax)
  802750:	eb 0b                	jmp    80275d <alloc_block_BF+0x1b1>
  802752:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802755:	8b 40 04             	mov    0x4(%eax),%eax
  802758:	a3 4c 41 80 00       	mov    %eax,0x80414c
  80275d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802760:	8b 40 04             	mov    0x4(%eax),%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	74 0f                	je     802776 <alloc_block_BF+0x1ca>
  802767:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80276a:	8b 40 04             	mov    0x4(%eax),%eax
  80276d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802770:	8b 12                	mov    (%edx),%edx
  802772:	89 10                	mov    %edx,(%eax)
  802774:	eb 0a                	jmp    802780 <alloc_block_BF+0x1d4>
  802776:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802779:	8b 00                	mov    (%eax),%eax
  80277b:	a3 48 41 80 00       	mov    %eax,0x804148
  802780:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802783:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802789:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80278c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802793:	a1 54 41 80 00       	mov    0x804154,%eax
  802798:	48                   	dec    %eax
  802799:	a3 54 41 80 00       	mov    %eax,0x804154
		return blockToUpdate;
  80279e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8027a1:	eb 05                	jmp    8027a8 <alloc_block_BF+0x1fc>
	}

	return NULL;
  8027a3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027a8:	c9                   	leave  
  8027a9:	c3                   	ret    

008027aa <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  8027aa:	55                   	push   %ebp
  8027ab:	89 e5                	mov    %esp,%ebp
  8027ad:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  8027b0:	a1 38 41 80 00       	mov    0x804138,%eax
  8027b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  8027b8:	e9 7c 01 00 00       	jmp    802939 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  8027bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027c0:	8b 40 0c             	mov    0xc(%eax),%eax
  8027c3:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027c6:	0f 86 cf 00 00 00    	jbe    80289b <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8027cc:	a1 48 41 80 00       	mov    0x804148,%eax
  8027d1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  8027d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  8027da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8027e0:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  8027e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027e6:	8b 50 08             	mov    0x8(%eax),%edx
  8027e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027ec:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  8027ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f2:	8b 40 0c             	mov    0xc(%eax),%eax
  8027f5:	2b 45 08             	sub    0x8(%ebp),%eax
  8027f8:	89 c2                	mov    %eax,%edx
  8027fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fd:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802800:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802803:	8b 50 08             	mov    0x8(%eax),%edx
  802806:	8b 45 08             	mov    0x8(%ebp),%eax
  802809:	01 c2                	add    %eax,%edx
  80280b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80280e:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802811:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802815:	75 17                	jne    80282e <alloc_block_NF+0x84>
  802817:	83 ec 04             	sub    $0x4,%esp
  80281a:	68 49 3c 80 00       	push   $0x803c49
  80281f:	68 c4 00 00 00       	push   $0xc4
  802824:	68 d7 3b 80 00       	push   $0x803bd7
  802829:	e8 3c db ff ff       	call   80036a <_panic>
  80282e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802831:	8b 00                	mov    (%eax),%eax
  802833:	85 c0                	test   %eax,%eax
  802835:	74 10                	je     802847 <alloc_block_NF+0x9d>
  802837:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80283a:	8b 00                	mov    (%eax),%eax
  80283c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80283f:	8b 52 04             	mov    0x4(%edx),%edx
  802842:	89 50 04             	mov    %edx,0x4(%eax)
  802845:	eb 0b                	jmp    802852 <alloc_block_NF+0xa8>
  802847:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80284a:	8b 40 04             	mov    0x4(%eax),%eax
  80284d:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802852:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802855:	8b 40 04             	mov    0x4(%eax),%eax
  802858:	85 c0                	test   %eax,%eax
  80285a:	74 0f                	je     80286b <alloc_block_NF+0xc1>
  80285c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80285f:	8b 40 04             	mov    0x4(%eax),%eax
  802862:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802865:	8b 12                	mov    (%edx),%edx
  802867:	89 10                	mov    %edx,(%eax)
  802869:	eb 0a                	jmp    802875 <alloc_block_NF+0xcb>
  80286b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286e:	8b 00                	mov    (%eax),%eax
  802870:	a3 48 41 80 00       	mov    %eax,0x804148
  802875:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802878:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80287e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802881:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802888:	a1 54 41 80 00       	mov    0x804154,%eax
  80288d:	48                   	dec    %eax
  80288e:	a3 54 41 80 00       	mov    %eax,0x804154
	                    return newBlock ;
  802893:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802896:	e9 ad 00 00 00       	jmp    802948 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  80289b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80289e:	8b 40 0c             	mov    0xc(%eax),%eax
  8028a1:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028a4:	0f 85 87 00 00 00    	jne    802931 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8028aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028ae:	75 17                	jne    8028c7 <alloc_block_NF+0x11d>
  8028b0:	83 ec 04             	sub    $0x4,%esp
  8028b3:	68 49 3c 80 00       	push   $0x803c49
  8028b8:	68 c8 00 00 00       	push   $0xc8
  8028bd:	68 d7 3b 80 00       	push   $0x803bd7
  8028c2:	e8 a3 da ff ff       	call   80036a <_panic>
  8028c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ca:	8b 00                	mov    (%eax),%eax
  8028cc:	85 c0                	test   %eax,%eax
  8028ce:	74 10                	je     8028e0 <alloc_block_NF+0x136>
  8028d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028d3:	8b 00                	mov    (%eax),%eax
  8028d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d8:	8b 52 04             	mov    0x4(%edx),%edx
  8028db:	89 50 04             	mov    %edx,0x4(%eax)
  8028de:	eb 0b                	jmp    8028eb <alloc_block_NF+0x141>
  8028e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e3:	8b 40 04             	mov    0x4(%eax),%eax
  8028e6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8028eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028ee:	8b 40 04             	mov    0x4(%eax),%eax
  8028f1:	85 c0                	test   %eax,%eax
  8028f3:	74 0f                	je     802904 <alloc_block_NF+0x15a>
  8028f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f8:	8b 40 04             	mov    0x4(%eax),%eax
  8028fb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fe:	8b 12                	mov    (%edx),%edx
  802900:	89 10                	mov    %edx,(%eax)
  802902:	eb 0a                	jmp    80290e <alloc_block_NF+0x164>
  802904:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802907:	8b 00                	mov    (%eax),%eax
  802909:	a3 38 41 80 00       	mov    %eax,0x804138
  80290e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802911:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802917:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802921:	a1 44 41 80 00       	mov    0x804144,%eax
  802926:	48                   	dec    %eax
  802927:	a3 44 41 80 00       	mov    %eax,0x804144
	                        return  updated;
  80292c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80292f:	eb 17                	jmp    802948 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802931:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802934:	8b 00                	mov    (%eax),%eax
  802936:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802939:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80293d:	0f 85 7a fe ff ff    	jne    8027bd <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802943:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802948:	c9                   	leave  
  802949:	c3                   	ret    

0080294a <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  80294a:	55                   	push   %ebp
  80294b:	89 e5                	mov    %esp,%ebp
  80294d:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802950:	a1 38 41 80 00       	mov    0x804138,%eax
  802955:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802958:	a1 3c 41 80 00       	mov    0x80413c,%eax
  80295d:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802960:	a1 44 41 80 00       	mov    0x804144,%eax
  802965:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802968:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80296c:	75 68                	jne    8029d6 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80296e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802972:	75 17                	jne    80298b <insert_sorted_with_merge_freeList+0x41>
  802974:	83 ec 04             	sub    $0x4,%esp
  802977:	68 b4 3b 80 00       	push   $0x803bb4
  80297c:	68 da 00 00 00       	push   $0xda
  802981:	68 d7 3b 80 00       	push   $0x803bd7
  802986:	e8 df d9 ff ff       	call   80036a <_panic>
  80298b:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802991:	8b 45 08             	mov    0x8(%ebp),%eax
  802994:	89 10                	mov    %edx,(%eax)
  802996:	8b 45 08             	mov    0x8(%ebp),%eax
  802999:	8b 00                	mov    (%eax),%eax
  80299b:	85 c0                	test   %eax,%eax
  80299d:	74 0d                	je     8029ac <insert_sorted_with_merge_freeList+0x62>
  80299f:	a1 38 41 80 00       	mov    0x804138,%eax
  8029a4:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a7:	89 50 04             	mov    %edx,0x4(%eax)
  8029aa:	eb 08                	jmp    8029b4 <insert_sorted_with_merge_freeList+0x6a>
  8029ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8029af:	a3 3c 41 80 00       	mov    %eax,0x80413c
  8029b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029b7:	a3 38 41 80 00       	mov    %eax,0x804138
  8029bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8029bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8029c6:	a1 44 41 80 00       	mov    0x804144,%eax
  8029cb:	40                   	inc    %eax
  8029cc:	a3 44 41 80 00       	mov    %eax,0x804144



	}
	}
	}
  8029d1:	e9 49 07 00 00       	jmp    80311f <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  8029d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029d9:	8b 50 08             	mov    0x8(%eax),%edx
  8029dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029df:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e2:	01 c2                	add    %eax,%edx
  8029e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8029e7:	8b 40 08             	mov    0x8(%eax),%eax
  8029ea:	39 c2                	cmp    %eax,%edx
  8029ec:	73 77                	jae    802a65 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  8029ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029f1:	8b 00                	mov    (%eax),%eax
  8029f3:	85 c0                	test   %eax,%eax
  8029f5:	75 6e                	jne    802a65 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  8029f7:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029fb:	74 68                	je     802a65 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  8029fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a01:	75 17                	jne    802a1a <insert_sorted_with_merge_freeList+0xd0>
  802a03:	83 ec 04             	sub    $0x4,%esp
  802a06:	68 f0 3b 80 00       	push   $0x803bf0
  802a0b:	68 e0 00 00 00       	push   $0xe0
  802a10:	68 d7 3b 80 00       	push   $0x803bd7
  802a15:	e8 50 d9 ff ff       	call   80036a <_panic>
  802a1a:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802a20:	8b 45 08             	mov    0x8(%ebp),%eax
  802a23:	89 50 04             	mov    %edx,0x4(%eax)
  802a26:	8b 45 08             	mov    0x8(%ebp),%eax
  802a29:	8b 40 04             	mov    0x4(%eax),%eax
  802a2c:	85 c0                	test   %eax,%eax
  802a2e:	74 0c                	je     802a3c <insert_sorted_with_merge_freeList+0xf2>
  802a30:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802a35:	8b 55 08             	mov    0x8(%ebp),%edx
  802a38:	89 10                	mov    %edx,(%eax)
  802a3a:	eb 08                	jmp    802a44 <insert_sorted_with_merge_freeList+0xfa>
  802a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a3f:	a3 38 41 80 00       	mov    %eax,0x804138
  802a44:	8b 45 08             	mov    0x8(%ebp),%eax
  802a47:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802a4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a4f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a55:	a1 44 41 80 00       	mov    0x804144,%eax
  802a5a:	40                   	inc    %eax
  802a5b:	a3 44 41 80 00       	mov    %eax,0x804144
  802a60:	e9 ba 06 00 00       	jmp    80311f <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802a65:	8b 45 08             	mov    0x8(%ebp),%eax
  802a68:	8b 50 0c             	mov    0xc(%eax),%edx
  802a6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802a6e:	8b 40 08             	mov    0x8(%eax),%eax
  802a71:	01 c2                	add    %eax,%edx
  802a73:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a76:	8b 40 08             	mov    0x8(%eax),%eax
  802a79:	39 c2                	cmp    %eax,%edx
  802a7b:	73 78                	jae    802af5 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a80:	8b 40 04             	mov    0x4(%eax),%eax
  802a83:	85 c0                	test   %eax,%eax
  802a85:	75 6e                	jne    802af5 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802a87:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a8b:	74 68                	je     802af5 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802a8d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a91:	75 17                	jne    802aaa <insert_sorted_with_merge_freeList+0x160>
  802a93:	83 ec 04             	sub    $0x4,%esp
  802a96:	68 b4 3b 80 00       	push   $0x803bb4
  802a9b:	68 e6 00 00 00       	push   $0xe6
  802aa0:	68 d7 3b 80 00       	push   $0x803bd7
  802aa5:	e8 c0 d8 ff ff       	call   80036a <_panic>
  802aaa:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802ab0:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab3:	89 10                	mov    %edx,(%eax)
  802ab5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab8:	8b 00                	mov    (%eax),%eax
  802aba:	85 c0                	test   %eax,%eax
  802abc:	74 0d                	je     802acb <insert_sorted_with_merge_freeList+0x181>
  802abe:	a1 38 41 80 00       	mov    0x804138,%eax
  802ac3:	8b 55 08             	mov    0x8(%ebp),%edx
  802ac6:	89 50 04             	mov    %edx,0x4(%eax)
  802ac9:	eb 08                	jmp    802ad3 <insert_sorted_with_merge_freeList+0x189>
  802acb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ace:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802ad3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ad6:	a3 38 41 80 00       	mov    %eax,0x804138
  802adb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ade:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ae5:	a1 44 41 80 00       	mov    0x804144,%eax
  802aea:	40                   	inc    %eax
  802aeb:	a3 44 41 80 00       	mov    %eax,0x804144
  802af0:	e9 2a 06 00 00       	jmp    80311f <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802af5:	a1 38 41 80 00       	mov    0x804138,%eax
  802afa:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802afd:	e9 ed 05 00 00       	jmp    8030ef <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802b02:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b05:	8b 00                	mov    (%eax),%eax
  802b07:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802b0a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802b0e:	0f 84 a7 00 00 00    	je     802bbb <insert_sorted_with_merge_freeList+0x271>
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 50 0c             	mov    0xc(%eax),%edx
  802b1a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1d:	8b 40 08             	mov    0x8(%eax),%eax
  802b20:	01 c2                	add    %eax,%edx
  802b22:	8b 45 08             	mov    0x8(%ebp),%eax
  802b25:	8b 40 08             	mov    0x8(%eax),%eax
  802b28:	39 c2                	cmp    %eax,%edx
  802b2a:	0f 83 8b 00 00 00    	jae    802bbb <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802b30:	8b 45 08             	mov    0x8(%ebp),%eax
  802b33:	8b 50 0c             	mov    0xc(%eax),%edx
  802b36:	8b 45 08             	mov    0x8(%ebp),%eax
  802b39:	8b 40 08             	mov    0x8(%eax),%eax
  802b3c:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802b3e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b41:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802b44:	39 c2                	cmp    %eax,%edx
  802b46:	73 73                	jae    802bbb <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802b48:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b4c:	74 06                	je     802b54 <insert_sorted_with_merge_freeList+0x20a>
  802b4e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b52:	75 17                	jne    802b6b <insert_sorted_with_merge_freeList+0x221>
  802b54:	83 ec 04             	sub    $0x4,%esp
  802b57:	68 68 3c 80 00       	push   $0x803c68
  802b5c:	68 f0 00 00 00       	push   $0xf0
  802b61:	68 d7 3b 80 00       	push   $0x803bd7
  802b66:	e8 ff d7 ff ff       	call   80036a <_panic>
  802b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b6e:	8b 10                	mov    (%eax),%edx
  802b70:	8b 45 08             	mov    0x8(%ebp),%eax
  802b73:	89 10                	mov    %edx,(%eax)
  802b75:	8b 45 08             	mov    0x8(%ebp),%eax
  802b78:	8b 00                	mov    (%eax),%eax
  802b7a:	85 c0                	test   %eax,%eax
  802b7c:	74 0b                	je     802b89 <insert_sorted_with_merge_freeList+0x23f>
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 00                	mov    (%eax),%eax
  802b83:	8b 55 08             	mov    0x8(%ebp),%edx
  802b86:	89 50 04             	mov    %edx,0x4(%eax)
  802b89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8c:	8b 55 08             	mov    0x8(%ebp),%edx
  802b8f:	89 10                	mov    %edx,(%eax)
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b97:	89 50 04             	mov    %edx,0x4(%eax)
  802b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802b9d:	8b 00                	mov    (%eax),%eax
  802b9f:	85 c0                	test   %eax,%eax
  802ba1:	75 08                	jne    802bab <insert_sorted_with_merge_freeList+0x261>
  802ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba6:	a3 3c 41 80 00       	mov    %eax,0x80413c
  802bab:	a1 44 41 80 00       	mov    0x804144,%eax
  802bb0:	40                   	inc    %eax
  802bb1:	a3 44 41 80 00       	mov    %eax,0x804144

		         break;
  802bb6:	e9 64 05 00 00       	jmp    80311f <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802bbb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bc0:	8b 50 0c             	mov    0xc(%eax),%edx
  802bc3:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bc8:	8b 40 08             	mov    0x8(%eax),%eax
  802bcb:	01 c2                	add    %eax,%edx
  802bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  802bd0:	8b 40 08             	mov    0x8(%eax),%eax
  802bd3:	39 c2                	cmp    %eax,%edx
  802bd5:	0f 85 b1 00 00 00    	jne    802c8c <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802bdb:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802be0:	85 c0                	test   %eax,%eax
  802be2:	0f 84 a4 00 00 00    	je     802c8c <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802be8:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bed:	8b 00                	mov    (%eax),%eax
  802bef:	85 c0                	test   %eax,%eax
  802bf1:	0f 85 95 00 00 00    	jne    802c8c <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802bf7:	a1 3c 41 80 00       	mov    0x80413c,%eax
  802bfc:	8b 15 3c 41 80 00    	mov    0x80413c,%edx
  802c02:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802c05:	8b 55 08             	mov    0x8(%ebp),%edx
  802c08:	8b 52 0c             	mov    0xc(%edx),%edx
  802c0b:	01 ca                	add    %ecx,%edx
  802c0d:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802c10:	8b 45 08             	mov    0x8(%ebp),%eax
  802c13:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802c1a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c1d:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802c24:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802c28:	75 17                	jne    802c41 <insert_sorted_with_merge_freeList+0x2f7>
  802c2a:	83 ec 04             	sub    $0x4,%esp
  802c2d:	68 b4 3b 80 00       	push   $0x803bb4
  802c32:	68 ff 00 00 00       	push   $0xff
  802c37:	68 d7 3b 80 00       	push   $0x803bd7
  802c3c:	e8 29 d7 ff ff       	call   80036a <_panic>
  802c41:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802c47:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4a:	89 10                	mov    %edx,(%eax)
  802c4c:	8b 45 08             	mov    0x8(%ebp),%eax
  802c4f:	8b 00                	mov    (%eax),%eax
  802c51:	85 c0                	test   %eax,%eax
  802c53:	74 0d                	je     802c62 <insert_sorted_with_merge_freeList+0x318>
  802c55:	a1 48 41 80 00       	mov    0x804148,%eax
  802c5a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c5d:	89 50 04             	mov    %edx,0x4(%eax)
  802c60:	eb 08                	jmp    802c6a <insert_sorted_with_merge_freeList+0x320>
  802c62:	8b 45 08             	mov    0x8(%ebp),%eax
  802c65:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802c6a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c6d:	a3 48 41 80 00       	mov    %eax,0x804148
  802c72:	8b 45 08             	mov    0x8(%ebp),%eax
  802c75:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c7c:	a1 54 41 80 00       	mov    0x804154,%eax
  802c81:	40                   	inc    %eax
  802c82:	a3 54 41 80 00       	mov    %eax,0x804154

	break;
  802c87:	e9 93 04 00 00       	jmp    80311f <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  802c8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c8f:	8b 50 08             	mov    0x8(%eax),%edx
  802c92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c95:	8b 40 0c             	mov    0xc(%eax),%eax
  802c98:	01 c2                	add    %eax,%edx
  802c9a:	8b 45 08             	mov    0x8(%ebp),%eax
  802c9d:	8b 40 08             	mov    0x8(%eax),%eax
  802ca0:	39 c2                	cmp    %eax,%edx
  802ca2:	0f 85 ae 00 00 00    	jne    802d56 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  802ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  802cab:	8b 50 0c             	mov    0xc(%eax),%edx
  802cae:	8b 45 08             	mov    0x8(%ebp),%eax
  802cb1:	8b 40 08             	mov    0x8(%eax),%eax
  802cb4:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  802cb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb9:	8b 00                	mov    (%eax),%eax
  802cbb:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  802cbe:	39 c2                	cmp    %eax,%edx
  802cc0:	0f 84 90 00 00 00    	je     802d56 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  802cc6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc9:	8b 50 0c             	mov    0xc(%eax),%edx
  802ccc:	8b 45 08             	mov    0x8(%ebp),%eax
  802ccf:	8b 40 0c             	mov    0xc(%eax),%eax
  802cd2:	01 c2                	add    %eax,%edx
  802cd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cd7:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802cda:	8b 45 08             	mov    0x8(%ebp),%eax
  802cdd:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802ce4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ce7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802cee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802cf2:	75 17                	jne    802d0b <insert_sorted_with_merge_freeList+0x3c1>
  802cf4:	83 ec 04             	sub    $0x4,%esp
  802cf7:	68 b4 3b 80 00       	push   $0x803bb4
  802cfc:	68 0b 01 00 00       	push   $0x10b
  802d01:	68 d7 3b 80 00       	push   $0x803bd7
  802d06:	e8 5f d6 ff ff       	call   80036a <_panic>
  802d0b:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802d11:	8b 45 08             	mov    0x8(%ebp),%eax
  802d14:	89 10                	mov    %edx,(%eax)
  802d16:	8b 45 08             	mov    0x8(%ebp),%eax
  802d19:	8b 00                	mov    (%eax),%eax
  802d1b:	85 c0                	test   %eax,%eax
  802d1d:	74 0d                	je     802d2c <insert_sorted_with_merge_freeList+0x3e2>
  802d1f:	a1 48 41 80 00       	mov    0x804148,%eax
  802d24:	8b 55 08             	mov    0x8(%ebp),%edx
  802d27:	89 50 04             	mov    %edx,0x4(%eax)
  802d2a:	eb 08                	jmp    802d34 <insert_sorted_with_merge_freeList+0x3ea>
  802d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d2f:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802d34:	8b 45 08             	mov    0x8(%ebp),%eax
  802d37:	a3 48 41 80 00       	mov    %eax,0x804148
  802d3c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d3f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d46:	a1 54 41 80 00       	mov    0x804154,%eax
  802d4b:	40                   	inc    %eax
  802d4c:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802d51:	e9 c9 03 00 00       	jmp    80311f <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d56:	8b 45 08             	mov    0x8(%ebp),%eax
  802d59:	8b 50 0c             	mov    0xc(%eax),%edx
  802d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  802d5f:	8b 40 08             	mov    0x8(%eax),%eax
  802d62:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  802d64:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d67:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  802d6a:	39 c2                	cmp    %eax,%edx
  802d6c:	0f 85 bb 00 00 00    	jne    802e2d <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  802d72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d76:	0f 84 b1 00 00 00    	je     802e2d <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  802d7c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d7f:	8b 40 04             	mov    0x4(%eax),%eax
  802d82:	85 c0                	test   %eax,%eax
  802d84:	0f 85 a3 00 00 00    	jne    802e2d <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  802d8a:	a1 38 41 80 00       	mov    0x804138,%eax
  802d8f:	8b 55 08             	mov    0x8(%ebp),%edx
  802d92:	8b 52 08             	mov    0x8(%edx),%edx
  802d95:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  802d98:	a1 38 41 80 00       	mov    0x804138,%eax
  802d9d:	8b 15 38 41 80 00    	mov    0x804138,%edx
  802da3:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802da6:	8b 55 08             	mov    0x8(%ebp),%edx
  802da9:	8b 52 0c             	mov    0xc(%edx),%edx
  802dac:	01 ca                	add    %ecx,%edx
  802dae:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802db1:	8b 45 08             	mov    0x8(%ebp),%eax
  802db4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802dbe:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802dc5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802dc9:	75 17                	jne    802de2 <insert_sorted_with_merge_freeList+0x498>
  802dcb:	83 ec 04             	sub    $0x4,%esp
  802dce:	68 b4 3b 80 00       	push   $0x803bb4
  802dd3:	68 17 01 00 00       	push   $0x117
  802dd8:	68 d7 3b 80 00       	push   $0x803bd7
  802ddd:	e8 88 d5 ff ff       	call   80036a <_panic>
  802de2:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802de8:	8b 45 08             	mov    0x8(%ebp),%eax
  802deb:	89 10                	mov    %edx,(%eax)
  802ded:	8b 45 08             	mov    0x8(%ebp),%eax
  802df0:	8b 00                	mov    (%eax),%eax
  802df2:	85 c0                	test   %eax,%eax
  802df4:	74 0d                	je     802e03 <insert_sorted_with_merge_freeList+0x4b9>
  802df6:	a1 48 41 80 00       	mov    0x804148,%eax
  802dfb:	8b 55 08             	mov    0x8(%ebp),%edx
  802dfe:	89 50 04             	mov    %edx,0x4(%eax)
  802e01:	eb 08                	jmp    802e0b <insert_sorted_with_merge_freeList+0x4c1>
  802e03:	8b 45 08             	mov    0x8(%ebp),%eax
  802e06:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e0e:	a3 48 41 80 00       	mov    %eax,0x804148
  802e13:	8b 45 08             	mov    0x8(%ebp),%eax
  802e16:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e1d:	a1 54 41 80 00       	mov    0x804154,%eax
  802e22:	40                   	inc    %eax
  802e23:	a3 54 41 80 00       	mov    %eax,0x804154

		break;
  802e28:	e9 f2 02 00 00       	jmp    80311f <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  802e2d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e30:	8b 50 08             	mov    0x8(%eax),%edx
  802e33:	8b 45 08             	mov    0x8(%ebp),%eax
  802e36:	8b 40 0c             	mov    0xc(%eax),%eax
  802e39:	01 c2                	add    %eax,%edx
  802e3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e3e:	8b 40 08             	mov    0x8(%eax),%eax
  802e41:	39 c2                	cmp    %eax,%edx
  802e43:	0f 85 be 00 00 00    	jne    802f07 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  802e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e4c:	8b 40 04             	mov    0x4(%eax),%eax
  802e4f:	8b 50 08             	mov    0x8(%eax),%edx
  802e52:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e55:	8b 40 04             	mov    0x4(%eax),%eax
  802e58:	8b 40 0c             	mov    0xc(%eax),%eax
  802e5b:	01 c2                	add    %eax,%edx
  802e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e60:	8b 40 08             	mov    0x8(%eax),%eax
  802e63:	39 c2                	cmp    %eax,%edx
  802e65:	0f 84 9c 00 00 00    	je     802f07 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  802e6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6e:	8b 50 08             	mov    0x8(%eax),%edx
  802e71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e74:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  802e77:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e7a:	8b 50 0c             	mov    0xc(%eax),%edx
  802e7d:	8b 45 08             	mov    0x8(%ebp),%eax
  802e80:	8b 40 0c             	mov    0xc(%eax),%eax
  802e83:	01 c2                	add    %eax,%edx
  802e85:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e88:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  802e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8e:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  802e95:	8b 45 08             	mov    0x8(%ebp),%eax
  802e98:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802e9f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ea3:	75 17                	jne    802ebc <insert_sorted_with_merge_freeList+0x572>
  802ea5:	83 ec 04             	sub    $0x4,%esp
  802ea8:	68 b4 3b 80 00       	push   $0x803bb4
  802ead:	68 26 01 00 00       	push   $0x126
  802eb2:	68 d7 3b 80 00       	push   $0x803bd7
  802eb7:	e8 ae d4 ff ff       	call   80036a <_panic>
  802ebc:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802ec2:	8b 45 08             	mov    0x8(%ebp),%eax
  802ec5:	89 10                	mov    %edx,(%eax)
  802ec7:	8b 45 08             	mov    0x8(%ebp),%eax
  802eca:	8b 00                	mov    (%eax),%eax
  802ecc:	85 c0                	test   %eax,%eax
  802ece:	74 0d                	je     802edd <insert_sorted_with_merge_freeList+0x593>
  802ed0:	a1 48 41 80 00       	mov    0x804148,%eax
  802ed5:	8b 55 08             	mov    0x8(%ebp),%edx
  802ed8:	89 50 04             	mov    %edx,0x4(%eax)
  802edb:	eb 08                	jmp    802ee5 <insert_sorted_with_merge_freeList+0x59b>
  802edd:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee0:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802ee5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee8:	a3 48 41 80 00       	mov    %eax,0x804148
  802eed:	8b 45 08             	mov    0x8(%ebp),%eax
  802ef0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ef7:	a1 54 41 80 00       	mov    0x804154,%eax
  802efc:	40                   	inc    %eax
  802efd:	a3 54 41 80 00       	mov    %eax,0x804154

		break;//8
  802f02:	e9 18 02 00 00       	jmp    80311f <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  802f07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f0a:	8b 50 0c             	mov    0xc(%eax),%edx
  802f0d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f10:	8b 40 08             	mov    0x8(%eax),%eax
  802f13:	01 c2                	add    %eax,%edx
  802f15:	8b 45 08             	mov    0x8(%ebp),%eax
  802f18:	8b 40 08             	mov    0x8(%eax),%eax
  802f1b:	39 c2                	cmp    %eax,%edx
  802f1d:	0f 85 c4 01 00 00    	jne    8030e7 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  802f23:	8b 45 08             	mov    0x8(%ebp),%eax
  802f26:	8b 50 0c             	mov    0xc(%eax),%edx
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	8b 40 08             	mov    0x8(%eax),%eax
  802f2f:	01 c2                	add    %eax,%edx
  802f31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f34:	8b 00                	mov    (%eax),%eax
  802f36:	8b 40 08             	mov    0x8(%eax),%eax
  802f39:	39 c2                	cmp    %eax,%edx
  802f3b:	0f 85 a6 01 00 00    	jne    8030e7 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  802f41:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f45:	0f 84 9c 01 00 00    	je     8030e7 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  802f4b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f4e:	8b 50 0c             	mov    0xc(%eax),%edx
  802f51:	8b 45 08             	mov    0x8(%ebp),%eax
  802f54:	8b 40 0c             	mov    0xc(%eax),%eax
  802f57:	01 c2                	add    %eax,%edx
  802f59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f5c:	8b 00                	mov    (%eax),%eax
  802f5e:	8b 40 0c             	mov    0xc(%eax),%eax
  802f61:	01 c2                	add    %eax,%edx
  802f63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f66:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  802f69:	8b 45 08             	mov    0x8(%ebp),%eax
  802f6c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  802f73:	8b 45 08             	mov    0x8(%ebp),%eax
  802f76:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  802f7d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f81:	75 17                	jne    802f9a <insert_sorted_with_merge_freeList+0x650>
  802f83:	83 ec 04             	sub    $0x4,%esp
  802f86:	68 b4 3b 80 00       	push   $0x803bb4
  802f8b:	68 32 01 00 00       	push   $0x132
  802f90:	68 d7 3b 80 00       	push   $0x803bd7
  802f95:	e8 d0 d3 ff ff       	call   80036a <_panic>
  802f9a:	8b 15 48 41 80 00    	mov    0x804148,%edx
  802fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa3:	89 10                	mov    %edx,(%eax)
  802fa5:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa8:	8b 00                	mov    (%eax),%eax
  802faa:	85 c0                	test   %eax,%eax
  802fac:	74 0d                	je     802fbb <insert_sorted_with_merge_freeList+0x671>
  802fae:	a1 48 41 80 00       	mov    0x804148,%eax
  802fb3:	8b 55 08             	mov    0x8(%ebp),%edx
  802fb6:	89 50 04             	mov    %edx,0x4(%eax)
  802fb9:	eb 08                	jmp    802fc3 <insert_sorted_with_merge_freeList+0x679>
  802fbb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fbe:	a3 4c 41 80 00       	mov    %eax,0x80414c
  802fc3:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc6:	a3 48 41 80 00       	mov    %eax,0x804148
  802fcb:	8b 45 08             	mov    0x8(%ebp),%eax
  802fce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd5:	a1 54 41 80 00       	mov    0x804154,%eax
  802fda:	40                   	inc    %eax
  802fdb:	a3 54 41 80 00       	mov    %eax,0x804154
	    ptr->prev_next_info.le_next->sva = 0;
  802fe0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fe3:	8b 00                	mov    (%eax),%eax
  802fe5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  802fec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fef:	8b 00                	mov    (%eax),%eax
  802ff1:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  802ff8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffb:	8b 00                	mov    (%eax),%eax
  802ffd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803000:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803004:	75 17                	jne    80301d <insert_sorted_with_merge_freeList+0x6d3>
  803006:	83 ec 04             	sub    $0x4,%esp
  803009:	68 49 3c 80 00       	push   $0x803c49
  80300e:	68 36 01 00 00       	push   $0x136
  803013:	68 d7 3b 80 00       	push   $0x803bd7
  803018:	e8 4d d3 ff ff       	call   80036a <_panic>
  80301d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803020:	8b 00                	mov    (%eax),%eax
  803022:	85 c0                	test   %eax,%eax
  803024:	74 10                	je     803036 <insert_sorted_with_merge_freeList+0x6ec>
  803026:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803029:	8b 00                	mov    (%eax),%eax
  80302b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80302e:	8b 52 04             	mov    0x4(%edx),%edx
  803031:	89 50 04             	mov    %edx,0x4(%eax)
  803034:	eb 0b                	jmp    803041 <insert_sorted_with_merge_freeList+0x6f7>
  803036:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803039:	8b 40 04             	mov    0x4(%eax),%eax
  80303c:	a3 3c 41 80 00       	mov    %eax,0x80413c
  803041:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803044:	8b 40 04             	mov    0x4(%eax),%eax
  803047:	85 c0                	test   %eax,%eax
  803049:	74 0f                	je     80305a <insert_sorted_with_merge_freeList+0x710>
  80304b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80304e:	8b 40 04             	mov    0x4(%eax),%eax
  803051:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803054:	8b 12                	mov    (%edx),%edx
  803056:	89 10                	mov    %edx,(%eax)
  803058:	eb 0a                	jmp    803064 <insert_sorted_with_merge_freeList+0x71a>
  80305a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80305d:	8b 00                	mov    (%eax),%eax
  80305f:	a3 38 41 80 00       	mov    %eax,0x804138
  803064:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803067:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80306d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803070:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803077:	a1 44 41 80 00       	mov    0x804144,%eax
  80307c:	48                   	dec    %eax
  80307d:	a3 44 41 80 00       	mov    %eax,0x804144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  803082:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803086:	75 17                	jne    80309f <insert_sorted_with_merge_freeList+0x755>
  803088:	83 ec 04             	sub    $0x4,%esp
  80308b:	68 b4 3b 80 00       	push   $0x803bb4
  803090:	68 37 01 00 00       	push   $0x137
  803095:	68 d7 3b 80 00       	push   $0x803bd7
  80309a:	e8 cb d2 ff ff       	call   80036a <_panic>
  80309f:	8b 15 48 41 80 00    	mov    0x804148,%edx
  8030a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030a8:	89 10                	mov    %edx,(%eax)
  8030aa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030ad:	8b 00                	mov    (%eax),%eax
  8030af:	85 c0                	test   %eax,%eax
  8030b1:	74 0d                	je     8030c0 <insert_sorted_with_merge_freeList+0x776>
  8030b3:	a1 48 41 80 00       	mov    0x804148,%eax
  8030b8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8030bb:	89 50 04             	mov    %edx,0x4(%eax)
  8030be:	eb 08                	jmp    8030c8 <insert_sorted_with_merge_freeList+0x77e>
  8030c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030c3:	a3 4c 41 80 00       	mov    %eax,0x80414c
  8030c8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030cb:	a3 48 41 80 00       	mov    %eax,0x804148
  8030d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8030d3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030da:	a1 54 41 80 00       	mov    0x804154,%eax
  8030df:	40                   	inc    %eax
  8030e0:	a3 54 41 80 00       	mov    %eax,0x804154

	    break;//9
  8030e5:	eb 38                	jmp    80311f <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8030e7:	a1 40 41 80 00       	mov    0x804140,%eax
  8030ec:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030ef:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030f3:	74 07                	je     8030fc <insert_sorted_with_merge_freeList+0x7b2>
  8030f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030f8:	8b 00                	mov    (%eax),%eax
  8030fa:	eb 05                	jmp    803101 <insert_sorted_with_merge_freeList+0x7b7>
  8030fc:	b8 00 00 00 00       	mov    $0x0,%eax
  803101:	a3 40 41 80 00       	mov    %eax,0x804140
  803106:	a1 40 41 80 00       	mov    0x804140,%eax
  80310b:	85 c0                	test   %eax,%eax
  80310d:	0f 85 ef f9 ff ff    	jne    802b02 <insert_sorted_with_merge_freeList+0x1b8>
  803113:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803117:	0f 85 e5 f9 ff ff    	jne    802b02 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  80311d:	eb 00                	jmp    80311f <insert_sorted_with_merge_freeList+0x7d5>
  80311f:	90                   	nop
  803120:	c9                   	leave  
  803121:	c3                   	ret    
  803122:	66 90                	xchg   %ax,%ax

00803124 <__udivdi3>:
  803124:	55                   	push   %ebp
  803125:	57                   	push   %edi
  803126:	56                   	push   %esi
  803127:	53                   	push   %ebx
  803128:	83 ec 1c             	sub    $0x1c,%esp
  80312b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80312f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  803133:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803137:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  80313b:	89 ca                	mov    %ecx,%edx
  80313d:	89 f8                	mov    %edi,%eax
  80313f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803143:	85 f6                	test   %esi,%esi
  803145:	75 2d                	jne    803174 <__udivdi3+0x50>
  803147:	39 cf                	cmp    %ecx,%edi
  803149:	77 65                	ja     8031b0 <__udivdi3+0x8c>
  80314b:	89 fd                	mov    %edi,%ebp
  80314d:	85 ff                	test   %edi,%edi
  80314f:	75 0b                	jne    80315c <__udivdi3+0x38>
  803151:	b8 01 00 00 00       	mov    $0x1,%eax
  803156:	31 d2                	xor    %edx,%edx
  803158:	f7 f7                	div    %edi
  80315a:	89 c5                	mov    %eax,%ebp
  80315c:	31 d2                	xor    %edx,%edx
  80315e:	89 c8                	mov    %ecx,%eax
  803160:	f7 f5                	div    %ebp
  803162:	89 c1                	mov    %eax,%ecx
  803164:	89 d8                	mov    %ebx,%eax
  803166:	f7 f5                	div    %ebp
  803168:	89 cf                	mov    %ecx,%edi
  80316a:	89 fa                	mov    %edi,%edx
  80316c:	83 c4 1c             	add    $0x1c,%esp
  80316f:	5b                   	pop    %ebx
  803170:	5e                   	pop    %esi
  803171:	5f                   	pop    %edi
  803172:	5d                   	pop    %ebp
  803173:	c3                   	ret    
  803174:	39 ce                	cmp    %ecx,%esi
  803176:	77 28                	ja     8031a0 <__udivdi3+0x7c>
  803178:	0f bd fe             	bsr    %esi,%edi
  80317b:	83 f7 1f             	xor    $0x1f,%edi
  80317e:	75 40                	jne    8031c0 <__udivdi3+0x9c>
  803180:	39 ce                	cmp    %ecx,%esi
  803182:	72 0a                	jb     80318e <__udivdi3+0x6a>
  803184:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803188:	0f 87 9e 00 00 00    	ja     80322c <__udivdi3+0x108>
  80318e:	b8 01 00 00 00       	mov    $0x1,%eax
  803193:	89 fa                	mov    %edi,%edx
  803195:	83 c4 1c             	add    $0x1c,%esp
  803198:	5b                   	pop    %ebx
  803199:	5e                   	pop    %esi
  80319a:	5f                   	pop    %edi
  80319b:	5d                   	pop    %ebp
  80319c:	c3                   	ret    
  80319d:	8d 76 00             	lea    0x0(%esi),%esi
  8031a0:	31 ff                	xor    %edi,%edi
  8031a2:	31 c0                	xor    %eax,%eax
  8031a4:	89 fa                	mov    %edi,%edx
  8031a6:	83 c4 1c             	add    $0x1c,%esp
  8031a9:	5b                   	pop    %ebx
  8031aa:	5e                   	pop    %esi
  8031ab:	5f                   	pop    %edi
  8031ac:	5d                   	pop    %ebp
  8031ad:	c3                   	ret    
  8031ae:	66 90                	xchg   %ax,%ax
  8031b0:	89 d8                	mov    %ebx,%eax
  8031b2:	f7 f7                	div    %edi
  8031b4:	31 ff                	xor    %edi,%edi
  8031b6:	89 fa                	mov    %edi,%edx
  8031b8:	83 c4 1c             	add    $0x1c,%esp
  8031bb:	5b                   	pop    %ebx
  8031bc:	5e                   	pop    %esi
  8031bd:	5f                   	pop    %edi
  8031be:	5d                   	pop    %ebp
  8031bf:	c3                   	ret    
  8031c0:	bd 20 00 00 00       	mov    $0x20,%ebp
  8031c5:	89 eb                	mov    %ebp,%ebx
  8031c7:	29 fb                	sub    %edi,%ebx
  8031c9:	89 f9                	mov    %edi,%ecx
  8031cb:	d3 e6                	shl    %cl,%esi
  8031cd:	89 c5                	mov    %eax,%ebp
  8031cf:	88 d9                	mov    %bl,%cl
  8031d1:	d3 ed                	shr    %cl,%ebp
  8031d3:	89 e9                	mov    %ebp,%ecx
  8031d5:	09 f1                	or     %esi,%ecx
  8031d7:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  8031db:	89 f9                	mov    %edi,%ecx
  8031dd:	d3 e0                	shl    %cl,%eax
  8031df:	89 c5                	mov    %eax,%ebp
  8031e1:	89 d6                	mov    %edx,%esi
  8031e3:	88 d9                	mov    %bl,%cl
  8031e5:	d3 ee                	shr    %cl,%esi
  8031e7:	89 f9                	mov    %edi,%ecx
  8031e9:	d3 e2                	shl    %cl,%edx
  8031eb:	8b 44 24 08          	mov    0x8(%esp),%eax
  8031ef:	88 d9                	mov    %bl,%cl
  8031f1:	d3 e8                	shr    %cl,%eax
  8031f3:	09 c2                	or     %eax,%edx
  8031f5:	89 d0                	mov    %edx,%eax
  8031f7:	89 f2                	mov    %esi,%edx
  8031f9:	f7 74 24 0c          	divl   0xc(%esp)
  8031fd:	89 d6                	mov    %edx,%esi
  8031ff:	89 c3                	mov    %eax,%ebx
  803201:	f7 e5                	mul    %ebp
  803203:	39 d6                	cmp    %edx,%esi
  803205:	72 19                	jb     803220 <__udivdi3+0xfc>
  803207:	74 0b                	je     803214 <__udivdi3+0xf0>
  803209:	89 d8                	mov    %ebx,%eax
  80320b:	31 ff                	xor    %edi,%edi
  80320d:	e9 58 ff ff ff       	jmp    80316a <__udivdi3+0x46>
  803212:	66 90                	xchg   %ax,%ax
  803214:	8b 54 24 08          	mov    0x8(%esp),%edx
  803218:	89 f9                	mov    %edi,%ecx
  80321a:	d3 e2                	shl    %cl,%edx
  80321c:	39 c2                	cmp    %eax,%edx
  80321e:	73 e9                	jae    803209 <__udivdi3+0xe5>
  803220:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803223:	31 ff                	xor    %edi,%edi
  803225:	e9 40 ff ff ff       	jmp    80316a <__udivdi3+0x46>
  80322a:	66 90                	xchg   %ax,%ax
  80322c:	31 c0                	xor    %eax,%eax
  80322e:	e9 37 ff ff ff       	jmp    80316a <__udivdi3+0x46>
  803233:	90                   	nop

00803234 <__umoddi3>:
  803234:	55                   	push   %ebp
  803235:	57                   	push   %edi
  803236:	56                   	push   %esi
  803237:	53                   	push   %ebx
  803238:	83 ec 1c             	sub    $0x1c,%esp
  80323b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  80323f:	8b 74 24 34          	mov    0x34(%esp),%esi
  803243:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803247:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80324b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80324f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803253:	89 f3                	mov    %esi,%ebx
  803255:	89 fa                	mov    %edi,%edx
  803257:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80325b:	89 34 24             	mov    %esi,(%esp)
  80325e:	85 c0                	test   %eax,%eax
  803260:	75 1a                	jne    80327c <__umoddi3+0x48>
  803262:	39 f7                	cmp    %esi,%edi
  803264:	0f 86 a2 00 00 00    	jbe    80330c <__umoddi3+0xd8>
  80326a:	89 c8                	mov    %ecx,%eax
  80326c:	89 f2                	mov    %esi,%edx
  80326e:	f7 f7                	div    %edi
  803270:	89 d0                	mov    %edx,%eax
  803272:	31 d2                	xor    %edx,%edx
  803274:	83 c4 1c             	add    $0x1c,%esp
  803277:	5b                   	pop    %ebx
  803278:	5e                   	pop    %esi
  803279:	5f                   	pop    %edi
  80327a:	5d                   	pop    %ebp
  80327b:	c3                   	ret    
  80327c:	39 f0                	cmp    %esi,%eax
  80327e:	0f 87 ac 00 00 00    	ja     803330 <__umoddi3+0xfc>
  803284:	0f bd e8             	bsr    %eax,%ebp
  803287:	83 f5 1f             	xor    $0x1f,%ebp
  80328a:	0f 84 ac 00 00 00    	je     80333c <__umoddi3+0x108>
  803290:	bf 20 00 00 00       	mov    $0x20,%edi
  803295:	29 ef                	sub    %ebp,%edi
  803297:	89 fe                	mov    %edi,%esi
  803299:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80329d:	89 e9                	mov    %ebp,%ecx
  80329f:	d3 e0                	shl    %cl,%eax
  8032a1:	89 d7                	mov    %edx,%edi
  8032a3:	89 f1                	mov    %esi,%ecx
  8032a5:	d3 ef                	shr    %cl,%edi
  8032a7:	09 c7                	or     %eax,%edi
  8032a9:	89 e9                	mov    %ebp,%ecx
  8032ab:	d3 e2                	shl    %cl,%edx
  8032ad:	89 14 24             	mov    %edx,(%esp)
  8032b0:	89 d8                	mov    %ebx,%eax
  8032b2:	d3 e0                	shl    %cl,%eax
  8032b4:	89 c2                	mov    %eax,%edx
  8032b6:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032ba:	d3 e0                	shl    %cl,%eax
  8032bc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8032c0:	8b 44 24 08          	mov    0x8(%esp),%eax
  8032c4:	89 f1                	mov    %esi,%ecx
  8032c6:	d3 e8                	shr    %cl,%eax
  8032c8:	09 d0                	or     %edx,%eax
  8032ca:	d3 eb                	shr    %cl,%ebx
  8032cc:	89 da                	mov    %ebx,%edx
  8032ce:	f7 f7                	div    %edi
  8032d0:	89 d3                	mov    %edx,%ebx
  8032d2:	f7 24 24             	mull   (%esp)
  8032d5:	89 c6                	mov    %eax,%esi
  8032d7:	89 d1                	mov    %edx,%ecx
  8032d9:	39 d3                	cmp    %edx,%ebx
  8032db:	0f 82 87 00 00 00    	jb     803368 <__umoddi3+0x134>
  8032e1:	0f 84 91 00 00 00    	je     803378 <__umoddi3+0x144>
  8032e7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8032eb:	29 f2                	sub    %esi,%edx
  8032ed:	19 cb                	sbb    %ecx,%ebx
  8032ef:	89 d8                	mov    %ebx,%eax
  8032f1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8032f5:	d3 e0                	shl    %cl,%eax
  8032f7:	89 e9                	mov    %ebp,%ecx
  8032f9:	d3 ea                	shr    %cl,%edx
  8032fb:	09 d0                	or     %edx,%eax
  8032fd:	89 e9                	mov    %ebp,%ecx
  8032ff:	d3 eb                	shr    %cl,%ebx
  803301:	89 da                	mov    %ebx,%edx
  803303:	83 c4 1c             	add    $0x1c,%esp
  803306:	5b                   	pop    %ebx
  803307:	5e                   	pop    %esi
  803308:	5f                   	pop    %edi
  803309:	5d                   	pop    %ebp
  80330a:	c3                   	ret    
  80330b:	90                   	nop
  80330c:	89 fd                	mov    %edi,%ebp
  80330e:	85 ff                	test   %edi,%edi
  803310:	75 0b                	jne    80331d <__umoddi3+0xe9>
  803312:	b8 01 00 00 00       	mov    $0x1,%eax
  803317:	31 d2                	xor    %edx,%edx
  803319:	f7 f7                	div    %edi
  80331b:	89 c5                	mov    %eax,%ebp
  80331d:	89 f0                	mov    %esi,%eax
  80331f:	31 d2                	xor    %edx,%edx
  803321:	f7 f5                	div    %ebp
  803323:	89 c8                	mov    %ecx,%eax
  803325:	f7 f5                	div    %ebp
  803327:	89 d0                	mov    %edx,%eax
  803329:	e9 44 ff ff ff       	jmp    803272 <__umoddi3+0x3e>
  80332e:	66 90                	xchg   %ax,%ax
  803330:	89 c8                	mov    %ecx,%eax
  803332:	89 f2                	mov    %esi,%edx
  803334:	83 c4 1c             	add    $0x1c,%esp
  803337:	5b                   	pop    %ebx
  803338:	5e                   	pop    %esi
  803339:	5f                   	pop    %edi
  80333a:	5d                   	pop    %ebp
  80333b:	c3                   	ret    
  80333c:	3b 04 24             	cmp    (%esp),%eax
  80333f:	72 06                	jb     803347 <__umoddi3+0x113>
  803341:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803345:	77 0f                	ja     803356 <__umoddi3+0x122>
  803347:	89 f2                	mov    %esi,%edx
  803349:	29 f9                	sub    %edi,%ecx
  80334b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80334f:	89 14 24             	mov    %edx,(%esp)
  803352:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803356:	8b 44 24 04          	mov    0x4(%esp),%eax
  80335a:	8b 14 24             	mov    (%esp),%edx
  80335d:	83 c4 1c             	add    $0x1c,%esp
  803360:	5b                   	pop    %ebx
  803361:	5e                   	pop    %esi
  803362:	5f                   	pop    %edi
  803363:	5d                   	pop    %ebp
  803364:	c3                   	ret    
  803365:	8d 76 00             	lea    0x0(%esi),%esi
  803368:	2b 04 24             	sub    (%esp),%eax
  80336b:	19 fa                	sbb    %edi,%edx
  80336d:	89 d1                	mov    %edx,%ecx
  80336f:	89 c6                	mov    %eax,%esi
  803371:	e9 71 ff ff ff       	jmp    8032e7 <__umoddi3+0xb3>
  803376:	66 90                	xchg   %ax,%ax
  803378:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80337c:	72 ea                	jb     803368 <__umoddi3+0x134>
  80337e:	89 d9                	mov    %ebx,%ecx
  803380:	e9 62 ff ff ff       	jmp    8032e7 <__umoddi3+0xb3>
