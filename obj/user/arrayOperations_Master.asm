
obj/user/arrayOperations_Master:     file format elf32-i386


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
  800031:	e8 2b 07 00 00       	call   800761 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);
void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var);

void
_main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	81 ec 88 00 00 00    	sub    $0x88,%esp
	/*[1] CREATE SHARED ARRAY*/
	int ret;
	char Chose;
	char Line[30];
	//2012: lock the interrupt
	sys_disable_interrupt();
  800041:	e8 3b 22 00 00       	call   802281 <sys_disable_interrupt>
		cprintf("\n");
  800046:	83 ec 0c             	sub    $0xc,%esp
  800049:	68 c0 3a 80 00       	push   $0x803ac0
  80004e:	e8 fe 0a 00 00       	call   800b51 <cprintf>
  800053:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800056:	83 ec 0c             	sub    $0xc,%esp
  800059:	68 c2 3a 80 00       	push   $0x803ac2
  80005e:	e8 ee 0a 00 00       	call   800b51 <cprintf>
  800063:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!   ARRAY OOERATIONS   !!!\n");
  800066:	83 ec 0c             	sub    $0xc,%esp
  800069:	68 e0 3a 80 00       	push   $0x803ae0
  80006e:	e8 de 0a 00 00       	call   800b51 <cprintf>
  800073:	83 c4 10             	add    $0x10,%esp
		cprintf("!!!!!!!!!!!!!!!!!!!!!!!!!!!!\n");
  800076:	83 ec 0c             	sub    $0xc,%esp
  800079:	68 c2 3a 80 00       	push   $0x803ac2
  80007e:	e8 ce 0a 00 00       	call   800b51 <cprintf>
  800083:	83 c4 10             	add    $0x10,%esp
		cprintf("\n");
  800086:	83 ec 0c             	sub    $0xc,%esp
  800089:	68 c0 3a 80 00       	push   $0x803ac0
  80008e:	e8 be 0a 00 00       	call   800b51 <cprintf>
  800093:	83 c4 10             	add    $0x10,%esp

		readline("Enter the number of elements: ", Line);
  800096:	83 ec 08             	sub    $0x8,%esp
  800099:	8d 45 82             	lea    -0x7e(%ebp),%eax
  80009c:	50                   	push   %eax
  80009d:	68 00 3b 80 00       	push   $0x803b00
  8000a2:	e8 2c 11 00 00       	call   8011d3 <readline>
  8000a7:	83 c4 10             	add    $0x10,%esp

		//Create the shared array & its size
		int *arrSize = smalloc("arrSize", sizeof(int) , 0) ;
  8000aa:	83 ec 04             	sub    $0x4,%esp
  8000ad:	6a 00                	push   $0x0
  8000af:	6a 04                	push   $0x4
  8000b1:	68 1f 3b 80 00       	push   $0x803b1f
  8000b6:	e8 b6 1d 00 00       	call   801e71 <smalloc>
  8000bb:	83 c4 10             	add    $0x10,%esp
  8000be:	89 45 f4             	mov    %eax,-0xc(%ebp)
		*arrSize = strtol(Line, NULL, 10) ;
  8000c1:	83 ec 04             	sub    $0x4,%esp
  8000c4:	6a 0a                	push   $0xa
  8000c6:	6a 00                	push   $0x0
  8000c8:	8d 45 82             	lea    -0x7e(%ebp),%eax
  8000cb:	50                   	push   %eax
  8000cc:	e8 68 16 00 00       	call   801739 <strtol>
  8000d1:	83 c4 10             	add    $0x10,%esp
  8000d4:	89 c2                	mov    %eax,%edx
  8000d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000d9:	89 10                	mov    %edx,(%eax)
		int NumOfElements = *arrSize;
  8000db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000de:	8b 00                	mov    (%eax),%eax
  8000e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
		int *Elements = smalloc("arr", sizeof(int) * NumOfElements , 0) ;
  8000e3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8000e6:	c1 e0 02             	shl    $0x2,%eax
  8000e9:	83 ec 04             	sub    $0x4,%esp
  8000ec:	6a 00                	push   $0x0
  8000ee:	50                   	push   %eax
  8000ef:	68 27 3b 80 00       	push   $0x803b27
  8000f4:	e8 78 1d 00 00       	call   801e71 <smalloc>
  8000f9:	83 c4 10             	add    $0x10,%esp
  8000fc:	89 45 ec             	mov    %eax,-0x14(%ebp)

		cprintf("Chose the initialization method:\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 2c 3b 80 00       	push   $0x803b2c
  800107:	e8 45 0a 00 00       	call   800b51 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 4e 3b 80 00       	push   $0x803b4e
  800117:	e8 35 0a 00 00       	call   800b51 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 5c 3b 80 00       	push   $0x803b5c
  800127:	e8 25 0a 00 00       	call   800b51 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  80012f:	83 ec 0c             	sub    $0xc,%esp
  800132:	68 6b 3b 80 00       	push   $0x803b6b
  800137:	e8 15 0a 00 00       	call   800b51 <cprintf>
  80013c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80013f:	83 ec 0c             	sub    $0xc,%esp
  800142:	68 7b 3b 80 00       	push   $0x803b7b
  800147:	e8 05 0a 00 00       	call   800b51 <cprintf>
  80014c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80014f:	e8 b5 05 00 00       	call   800709 <getchar>
  800154:	88 45 eb             	mov    %al,-0x15(%ebp)
			cputchar(Chose);
  800157:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80015b:	83 ec 0c             	sub    $0xc,%esp
  80015e:	50                   	push   %eax
  80015f:	e8 5d 05 00 00       	call   8006c1 <cputchar>
  800164:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800167:	83 ec 0c             	sub    $0xc,%esp
  80016a:	6a 0a                	push   $0xa
  80016c:	e8 50 05 00 00       	call   8006c1 <cputchar>
  800171:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800174:	80 7d eb 61          	cmpb   $0x61,-0x15(%ebp)
  800178:	74 0c                	je     800186 <_main+0x14e>
  80017a:	80 7d eb 62          	cmpb   $0x62,-0x15(%ebp)
  80017e:	74 06                	je     800186 <_main+0x14e>
  800180:	80 7d eb 63          	cmpb   $0x63,-0x15(%ebp)
  800184:	75 b9                	jne    80013f <_main+0x107>

	//2012: unlock the interrupt
	sys_enable_interrupt();
  800186:	e8 10 21 00 00       	call   80229b <sys_enable_interrupt>

	int  i ;
	switch (Chose)
  80018b:	0f be 45 eb          	movsbl -0x15(%ebp),%eax
  80018f:	83 f8 62             	cmp    $0x62,%eax
  800192:	74 1d                	je     8001b1 <_main+0x179>
  800194:	83 f8 63             	cmp    $0x63,%eax
  800197:	74 2b                	je     8001c4 <_main+0x18c>
  800199:	83 f8 61             	cmp    $0x61,%eax
  80019c:	75 39                	jne    8001d7 <_main+0x19f>
	{
	case 'a':
		InitializeAscending(Elements, NumOfElements);
  80019e:	83 ec 08             	sub    $0x8,%esp
  8001a1:	ff 75 f0             	pushl  -0x10(%ebp)
  8001a4:	ff 75 ec             	pushl  -0x14(%ebp)
  8001a7:	e8 9b 03 00 00       	call   800547 <InitializeAscending>
  8001ac:	83 c4 10             	add    $0x10,%esp
		break ;
  8001af:	eb 37                	jmp    8001e8 <_main+0x1b0>
	case 'b':
		InitializeDescending(Elements, NumOfElements);
  8001b1:	83 ec 08             	sub    $0x8,%esp
  8001b4:	ff 75 f0             	pushl  -0x10(%ebp)
  8001b7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ba:	e8 b9 03 00 00       	call   800578 <InitializeDescending>
  8001bf:	83 c4 10             	add    $0x10,%esp
		break ;
  8001c2:	eb 24                	jmp    8001e8 <_main+0x1b0>
	case 'c':
		InitializeSemiRandom(Elements, NumOfElements);
  8001c4:	83 ec 08             	sub    $0x8,%esp
  8001c7:	ff 75 f0             	pushl  -0x10(%ebp)
  8001ca:	ff 75 ec             	pushl  -0x14(%ebp)
  8001cd:	e8 db 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001d2:	83 c4 10             	add    $0x10,%esp
		break ;
  8001d5:	eb 11                	jmp    8001e8 <_main+0x1b0>
	default:
		InitializeSemiRandom(Elements, NumOfElements);
  8001d7:	83 ec 08             	sub    $0x8,%esp
  8001da:	ff 75 f0             	pushl  -0x10(%ebp)
  8001dd:	ff 75 ec             	pushl  -0x14(%ebp)
  8001e0:	e8 c8 03 00 00       	call   8005ad <InitializeSemiRandom>
  8001e5:	83 c4 10             	add    $0x10,%esp
	}

	//Create the check-finishing counter
	int numOfSlaveProgs = 3 ;
  8001e8:	c7 45 e4 03 00 00 00 	movl   $0x3,-0x1c(%ebp)
	int *numOfFinished = smalloc("finishedCount", sizeof(int), 1) ;
  8001ef:	83 ec 04             	sub    $0x4,%esp
  8001f2:	6a 01                	push   $0x1
  8001f4:	6a 04                	push   $0x4
  8001f6:	68 84 3b 80 00       	push   $0x803b84
  8001fb:	e8 71 1c 00 00       	call   801e71 <smalloc>
  800200:	83 c4 10             	add    $0x10,%esp
  800203:	89 45 e0             	mov    %eax,-0x20(%ebp)
	*numOfFinished = 0 ;
  800206:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800209:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

	/*[2] RUN THE SLAVES PROGRAMS*/
	int32 envIdQuickSort = sys_create_env("slave_qs", (myEnv->page_WS_max_size),(myEnv->SecondListSize) ,(myEnv->percentage_of_WS_pages_to_be_removed));
  80020f:	a1 20 50 80 00       	mov    0x805020,%eax
  800214:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80021a:	a1 20 50 80 00       	mov    0x805020,%eax
  80021f:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800225:	89 c1                	mov    %eax,%ecx
  800227:	a1 20 50 80 00       	mov    0x805020,%eax
  80022c:	8b 40 74             	mov    0x74(%eax),%eax
  80022f:	52                   	push   %edx
  800230:	51                   	push   %ecx
  800231:	50                   	push   %eax
  800232:	68 92 3b 80 00       	push   $0x803b92
  800237:	e8 ca 21 00 00       	call   802406 <sys_create_env>
  80023c:	83 c4 10             	add    $0x10,%esp
  80023f:	89 45 dc             	mov    %eax,-0x24(%ebp)
	int32 envIdMergeSort = sys_create_env("slave_ms", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800242:	a1 20 50 80 00       	mov    0x805020,%eax
  800247:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80024d:	a1 20 50 80 00       	mov    0x805020,%eax
  800252:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  800258:	89 c1                	mov    %eax,%ecx
  80025a:	a1 20 50 80 00       	mov    0x805020,%eax
  80025f:	8b 40 74             	mov    0x74(%eax),%eax
  800262:	52                   	push   %edx
  800263:	51                   	push   %ecx
  800264:	50                   	push   %eax
  800265:	68 9b 3b 80 00       	push   $0x803b9b
  80026a:	e8 97 21 00 00       	call   802406 <sys_create_env>
  80026f:	83 c4 10             	add    $0x10,%esp
  800272:	89 45 d8             	mov    %eax,-0x28(%ebp)
	int32 envIdStats = sys_create_env("slave_stats", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800275:	a1 20 50 80 00       	mov    0x805020,%eax
  80027a:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  800280:	a1 20 50 80 00       	mov    0x805020,%eax
  800285:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80028b:	89 c1                	mov    %eax,%ecx
  80028d:	a1 20 50 80 00       	mov    0x805020,%eax
  800292:	8b 40 74             	mov    0x74(%eax),%eax
  800295:	52                   	push   %edx
  800296:	51                   	push   %ecx
  800297:	50                   	push   %eax
  800298:	68 a4 3b 80 00       	push   $0x803ba4
  80029d:	e8 64 21 00 00       	call   802406 <sys_create_env>
  8002a2:	83 c4 10             	add    $0x10,%esp
  8002a5:	89 45 d4             	mov    %eax,-0x2c(%ebp)

	if (envIdQuickSort == E_ENV_CREATION_ERROR || envIdMergeSort == E_ENV_CREATION_ERROR || envIdStats == E_ENV_CREATION_ERROR)
  8002a8:	83 7d dc ef          	cmpl   $0xffffffef,-0x24(%ebp)
  8002ac:	74 0c                	je     8002ba <_main+0x282>
  8002ae:	83 7d d8 ef          	cmpl   $0xffffffef,-0x28(%ebp)
  8002b2:	74 06                	je     8002ba <_main+0x282>
  8002b4:	83 7d d4 ef          	cmpl   $0xffffffef,-0x2c(%ebp)
  8002b8:	75 14                	jne    8002ce <_main+0x296>
		panic("NO AVAILABLE ENVs...");
  8002ba:	83 ec 04             	sub    $0x4,%esp
  8002bd:	68 b0 3b 80 00       	push   $0x803bb0
  8002c2:	6a 4b                	push   $0x4b
  8002c4:	68 c5 3b 80 00       	push   $0x803bc5
  8002c9:	e8 cf 05 00 00       	call   80089d <_panic>

	sys_run_env(envIdQuickSort);
  8002ce:	83 ec 0c             	sub    $0xc,%esp
  8002d1:	ff 75 dc             	pushl  -0x24(%ebp)
  8002d4:	e8 4b 21 00 00       	call   802424 <sys_run_env>
  8002d9:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdMergeSort);
  8002dc:	83 ec 0c             	sub    $0xc,%esp
  8002df:	ff 75 d8             	pushl  -0x28(%ebp)
  8002e2:	e8 3d 21 00 00       	call   802424 <sys_run_env>
  8002e7:	83 c4 10             	add    $0x10,%esp
	sys_run_env(envIdStats);
  8002ea:	83 ec 0c             	sub    $0xc,%esp
  8002ed:	ff 75 d4             	pushl  -0x2c(%ebp)
  8002f0:	e8 2f 21 00 00       	call   802424 <sys_run_env>
  8002f5:	83 c4 10             	add    $0x10,%esp

	/*[3] BUSY-WAIT TILL FINISHING THEM*/
	while (*numOfFinished != numOfSlaveProgs) ;
  8002f8:	90                   	nop
  8002f9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002fc:	8b 00                	mov    (%eax),%eax
  8002fe:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800301:	75 f6                	jne    8002f9 <_main+0x2c1>

	/*[4] GET THEIR RESULTS*/
	int *quicksortedArr = NULL;
  800303:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
	int *mergesortedArr = NULL;
  80030a:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
	int *mean = NULL;
  800311:	c7 45 c8 00 00 00 00 	movl   $0x0,-0x38(%ebp)
	int *var = NULL;
  800318:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
	int *min = NULL;
  80031f:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
	int *max = NULL;
  800326:	c7 45 bc 00 00 00 00 	movl   $0x0,-0x44(%ebp)
	int *med = NULL;
  80032d:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
	quicksortedArr = sget(envIdQuickSort, "quicksortedArr") ;
  800334:	83 ec 08             	sub    $0x8,%esp
  800337:	68 e3 3b 80 00       	push   $0x803be3
  80033c:	ff 75 dc             	pushl  -0x24(%ebp)
  80033f:	e8 02 1c 00 00       	call   801f46 <sget>
  800344:	83 c4 10             	add    $0x10,%esp
  800347:	89 45 d0             	mov    %eax,-0x30(%ebp)
	mergesortedArr = sget(envIdMergeSort, "mergesortedArr") ;
  80034a:	83 ec 08             	sub    $0x8,%esp
  80034d:	68 f2 3b 80 00       	push   $0x803bf2
  800352:	ff 75 d8             	pushl  -0x28(%ebp)
  800355:	e8 ec 1b 00 00       	call   801f46 <sget>
  80035a:	83 c4 10             	add    $0x10,%esp
  80035d:	89 45 cc             	mov    %eax,-0x34(%ebp)
	mean = sget(envIdStats, "mean") ;
  800360:	83 ec 08             	sub    $0x8,%esp
  800363:	68 01 3c 80 00       	push   $0x803c01
  800368:	ff 75 d4             	pushl  -0x2c(%ebp)
  80036b:	e8 d6 1b 00 00       	call   801f46 <sget>
  800370:	83 c4 10             	add    $0x10,%esp
  800373:	89 45 c8             	mov    %eax,-0x38(%ebp)
	var = sget(envIdStats,"var") ;
  800376:	83 ec 08             	sub    $0x8,%esp
  800379:	68 06 3c 80 00       	push   $0x803c06
  80037e:	ff 75 d4             	pushl  -0x2c(%ebp)
  800381:	e8 c0 1b 00 00       	call   801f46 <sget>
  800386:	83 c4 10             	add    $0x10,%esp
  800389:	89 45 c4             	mov    %eax,-0x3c(%ebp)
	min = sget(envIdStats,"min") ;
  80038c:	83 ec 08             	sub    $0x8,%esp
  80038f:	68 0a 3c 80 00       	push   $0x803c0a
  800394:	ff 75 d4             	pushl  -0x2c(%ebp)
  800397:	e8 aa 1b 00 00       	call   801f46 <sget>
  80039c:	83 c4 10             	add    $0x10,%esp
  80039f:	89 45 c0             	mov    %eax,-0x40(%ebp)
	max = sget(envIdStats,"max") ;
  8003a2:	83 ec 08             	sub    $0x8,%esp
  8003a5:	68 0e 3c 80 00       	push   $0x803c0e
  8003aa:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003ad:	e8 94 1b 00 00       	call   801f46 <sget>
  8003b2:	83 c4 10             	add    $0x10,%esp
  8003b5:	89 45 bc             	mov    %eax,-0x44(%ebp)
	med = sget(envIdStats,"med") ;
  8003b8:	83 ec 08             	sub    $0x8,%esp
  8003bb:	68 12 3c 80 00       	push   $0x803c12
  8003c0:	ff 75 d4             	pushl  -0x2c(%ebp)
  8003c3:	e8 7e 1b 00 00       	call   801f46 <sget>
  8003c8:	83 c4 10             	add    $0x10,%esp
  8003cb:	89 45 b8             	mov    %eax,-0x48(%ebp)

	/*[5] VALIDATE THE RESULTS*/
	uint32 sorted = CheckSorted(quicksortedArr, NumOfElements);
  8003ce:	83 ec 08             	sub    $0x8,%esp
  8003d1:	ff 75 f0             	pushl  -0x10(%ebp)
  8003d4:	ff 75 d0             	pushl  -0x30(%ebp)
  8003d7:	e8 14 01 00 00       	call   8004f0 <CheckSorted>
  8003dc:	83 c4 10             	add    $0x10,%esp
  8003df:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT quick-sorted correctly") ;
  8003e2:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  8003e6:	75 14                	jne    8003fc <_main+0x3c4>
  8003e8:	83 ec 04             	sub    $0x4,%esp
  8003eb:	68 18 3c 80 00       	push   $0x803c18
  8003f0:	6a 66                	push   $0x66
  8003f2:	68 c5 3b 80 00       	push   $0x803bc5
  8003f7:	e8 a1 04 00 00       	call   80089d <_panic>
	sorted = CheckSorted(mergesortedArr, NumOfElements);
  8003fc:	83 ec 08             	sub    $0x8,%esp
  8003ff:	ff 75 f0             	pushl  -0x10(%ebp)
  800402:	ff 75 cc             	pushl  -0x34(%ebp)
  800405:	e8 e6 00 00 00       	call   8004f0 <CheckSorted>
  80040a:	83 c4 10             	add    $0x10,%esp
  80040d:	89 45 b4             	mov    %eax,-0x4c(%ebp)
	if(sorted == 0) panic("The array is NOT merge-sorted correctly") ;
  800410:	83 7d b4 00          	cmpl   $0x0,-0x4c(%ebp)
  800414:	75 14                	jne    80042a <_main+0x3f2>
  800416:	83 ec 04             	sub    $0x4,%esp
  800419:	68 40 3c 80 00       	push   $0x803c40
  80041e:	6a 68                	push   $0x68
  800420:	68 c5 3b 80 00       	push   $0x803bc5
  800425:	e8 73 04 00 00       	call   80089d <_panic>
	int correctMean, correctVar ;
	ArrayStats(Elements, NumOfElements, &correctMean , &correctVar);
  80042a:	8d 85 78 ff ff ff    	lea    -0x88(%ebp),%eax
  800430:	50                   	push   %eax
  800431:	8d 85 7c ff ff ff    	lea    -0x84(%ebp),%eax
  800437:	50                   	push   %eax
  800438:	ff 75 f0             	pushl  -0x10(%ebp)
  80043b:	ff 75 ec             	pushl  -0x14(%ebp)
  80043e:	e8 b6 01 00 00       	call   8005f9 <ArrayStats>
  800443:	83 c4 10             	add    $0x10,%esp
	int correctMin = quicksortedArr[0];
  800446:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800449:	8b 00                	mov    (%eax),%eax
  80044b:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int last = NumOfElements-1;
  80044e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800451:	48                   	dec    %eax
  800452:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int middle = (NumOfElements-1)/2;
  800455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800458:	48                   	dec    %eax
  800459:	89 c2                	mov    %eax,%edx
  80045b:	c1 ea 1f             	shr    $0x1f,%edx
  80045e:	01 d0                	add    %edx,%eax
  800460:	d1 f8                	sar    %eax
  800462:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int correctMax = quicksortedArr[last];
  800465:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800468:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80046f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800472:	01 d0                	add    %edx,%eax
  800474:	8b 00                	mov    (%eax),%eax
  800476:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int correctMed = quicksortedArr[middle];
  800479:	8b 45 a8             	mov    -0x58(%ebp),%eax
  80047c:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800483:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800486:	01 d0                	add    %edx,%eax
  800488:	8b 00                	mov    (%eax),%eax
  80048a:	89 45 a0             	mov    %eax,-0x60(%ebp)
	//cprintf("Array is correctly sorted\n");
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", *mean, *var, *min, *max, *med);
	//cprintf("mean = %d, var = %d\nmin = %d, max = %d, med = %d\n", correctMean, correctVar, correctMin, correctMax, correctMed);

	if(*mean != correctMean || *var != correctVar|| *min != correctMin || *max != correctMax || *med != correctMed)
  80048d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800490:	8b 10                	mov    (%eax),%edx
  800492:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  800498:	39 c2                	cmp    %eax,%edx
  80049a:	75 2d                	jne    8004c9 <_main+0x491>
  80049c:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80049f:	8b 10                	mov    (%eax),%edx
  8004a1:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  8004a7:	39 c2                	cmp    %eax,%edx
  8004a9:	75 1e                	jne    8004c9 <_main+0x491>
  8004ab:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8004ae:	8b 00                	mov    (%eax),%eax
  8004b0:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  8004b3:	75 14                	jne    8004c9 <_main+0x491>
  8004b5:	8b 45 bc             	mov    -0x44(%ebp),%eax
  8004b8:	8b 00                	mov    (%eax),%eax
  8004ba:	3b 45 a4             	cmp    -0x5c(%ebp),%eax
  8004bd:	75 0a                	jne    8004c9 <_main+0x491>
  8004bf:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004c2:	8b 00                	mov    (%eax),%eax
  8004c4:	3b 45 a0             	cmp    -0x60(%ebp),%eax
  8004c7:	74 14                	je     8004dd <_main+0x4a5>
		panic("The array STATS are NOT calculated correctly") ;
  8004c9:	83 ec 04             	sub    $0x4,%esp
  8004cc:	68 68 3c 80 00       	push   $0x803c68
  8004d1:	6a 75                	push   $0x75
  8004d3:	68 c5 3b 80 00       	push   $0x803bc5
  8004d8:	e8 c0 03 00 00       	call   80089d <_panic>

	cprintf("Congratulations!! Scenario of Using the Shared Variables [Create & Get] completed successfully!!\n\n\n");
  8004dd:	83 ec 0c             	sub    $0xc,%esp
  8004e0:	68 98 3c 80 00       	push   $0x803c98
  8004e5:	e8 67 06 00 00       	call   800b51 <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp

	return;
  8004ed:	90                   	nop
}
  8004ee:	c9                   	leave  
  8004ef:	c3                   	ret    

008004f0 <CheckSorted>:


uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8004f0:	55                   	push   %ebp
  8004f1:	89 e5                	mov    %esp,%ebp
  8004f3:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8004f6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8004fd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800504:	eb 33                	jmp    800539 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  800506:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800509:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800510:	8b 45 08             	mov    0x8(%ebp),%eax
  800513:	01 d0                	add    %edx,%eax
  800515:	8b 10                	mov    (%eax),%edx
  800517:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80051a:	40                   	inc    %eax
  80051b:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800522:	8b 45 08             	mov    0x8(%ebp),%eax
  800525:	01 c8                	add    %ecx,%eax
  800527:	8b 00                	mov    (%eax),%eax
  800529:	39 c2                	cmp    %eax,%edx
  80052b:	7e 09                	jle    800536 <CheckSorted+0x46>
		{
			Sorted = 0 ;
  80052d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800534:	eb 0c                	jmp    800542 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800536:	ff 45 f8             	incl   -0x8(%ebp)
  800539:	8b 45 0c             	mov    0xc(%ebp),%eax
  80053c:	48                   	dec    %eax
  80053d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800540:	7f c4                	jg     800506 <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800542:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800545:	c9                   	leave  
  800546:	c3                   	ret    

00800547 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800547:	55                   	push   %ebp
  800548:	89 e5                	mov    %esp,%ebp
  80054a:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80054d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800554:	eb 17                	jmp    80056d <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800556:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800559:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800560:	8b 45 08             	mov    0x8(%ebp),%eax
  800563:	01 c2                	add    %eax,%edx
  800565:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800568:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80056a:	ff 45 fc             	incl   -0x4(%ebp)
  80056d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800570:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800573:	7c e1                	jl     800556 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800575:	90                   	nop
  800576:	c9                   	leave  
  800577:	c3                   	ret    

00800578 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800578:	55                   	push   %ebp
  800579:	89 e5                	mov    %esp,%ebp
  80057b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80057e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800585:	eb 1b                	jmp    8005a2 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800587:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80058a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800591:	8b 45 08             	mov    0x8(%ebp),%eax
  800594:	01 c2                	add    %eax,%edx
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	2b 45 fc             	sub    -0x4(%ebp),%eax
  80059c:	48                   	dec    %eax
  80059d:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80059f:	ff 45 fc             	incl   -0x4(%ebp)
  8005a2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005a8:	7c dd                	jl     800587 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8005aa:	90                   	nop
  8005ab:	c9                   	leave  
  8005ac:	c3                   	ret    

008005ad <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8005ad:	55                   	push   %ebp
  8005ae:	89 e5                	mov    %esp,%ebp
  8005b0:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8005b3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8005b6:	b8 56 55 55 55       	mov    $0x55555556,%eax
  8005bb:	f7 e9                	imul   %ecx
  8005bd:	c1 f9 1f             	sar    $0x1f,%ecx
  8005c0:	89 d0                	mov    %edx,%eax
  8005c2:	29 c8                	sub    %ecx,%eax
  8005c4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  8005c7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8005ce:	eb 1e                	jmp    8005ee <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  8005d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005d3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005da:	8b 45 08             	mov    0x8(%ebp),%eax
  8005dd:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8005e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005e3:	99                   	cltd   
  8005e4:	f7 7d f8             	idivl  -0x8(%ebp)
  8005e7:	89 d0                	mov    %edx,%eax
  8005e9:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8005eb:	ff 45 fc             	incl   -0x4(%ebp)
  8005ee:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8005f1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8005f4:	7c da                	jl     8005d0 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
		//cprintf("Elements[%d] = %d\n",i, Elements[i]);
	}

}
  8005f6:	90                   	nop
  8005f7:	c9                   	leave  
  8005f8:	c3                   	ret    

008005f9 <ArrayStats>:

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
  8005f9:	55                   	push   %ebp
  8005fa:	89 e5                	mov    %esp,%ebp
  8005fc:	53                   	push   %ebx
  8005fd:	83 ec 10             	sub    $0x10,%esp
	int i ;
	*mean =0 ;
  800600:	8b 45 10             	mov    0x10(%ebp),%eax
  800603:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800609:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  800610:	eb 20                	jmp    800632 <ArrayStats+0x39>
	{
		*mean += Elements[i];
  800612:	8b 45 10             	mov    0x10(%ebp),%eax
  800615:	8b 10                	mov    (%eax),%edx
  800617:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80061a:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800621:	8b 45 08             	mov    0x8(%ebp),%eax
  800624:	01 c8                	add    %ecx,%eax
  800626:	8b 00                	mov    (%eax),%eax
  800628:	01 c2                	add    %eax,%edx
  80062a:	8b 45 10             	mov    0x10(%ebp),%eax
  80062d:	89 10                	mov    %edx,(%eax)

void ArrayStats(int *Elements, int NumOfElements, int *mean, int *var)
{
	int i ;
	*mean =0 ;
	for (i = 0 ; i < NumOfElements ; i++)
  80062f:	ff 45 f8             	incl   -0x8(%ebp)
  800632:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800635:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800638:	7c d8                	jl     800612 <ArrayStats+0x19>
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
  80063a:	8b 45 10             	mov    0x10(%ebp),%eax
  80063d:	8b 00                	mov    (%eax),%eax
  80063f:	99                   	cltd   
  800640:	f7 7d 0c             	idivl  0xc(%ebp)
  800643:	89 c2                	mov    %eax,%edx
  800645:	8b 45 10             	mov    0x10(%ebp),%eax
  800648:	89 10                	mov    %edx,(%eax)
	*var = 0;
  80064a:	8b 45 14             	mov    0x14(%ebp),%eax
  80064d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	for (i = 0 ; i < NumOfElements ; i++)
  800653:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80065a:	eb 46                	jmp    8006a2 <ArrayStats+0xa9>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
  80065c:	8b 45 14             	mov    0x14(%ebp),%eax
  80065f:	8b 10                	mov    (%eax),%edx
  800661:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800664:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066b:	8b 45 08             	mov    0x8(%ebp),%eax
  80066e:	01 c8                	add    %ecx,%eax
  800670:	8b 08                	mov    (%eax),%ecx
  800672:	8b 45 10             	mov    0x10(%ebp),%eax
  800675:	8b 00                	mov    (%eax),%eax
  800677:	89 cb                	mov    %ecx,%ebx
  800679:	29 c3                	sub    %eax,%ebx
  80067b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80067e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800685:	8b 45 08             	mov    0x8(%ebp),%eax
  800688:	01 c8                	add    %ecx,%eax
  80068a:	8b 08                	mov    (%eax),%ecx
  80068c:	8b 45 10             	mov    0x10(%ebp),%eax
  80068f:	8b 00                	mov    (%eax),%eax
  800691:	29 c1                	sub    %eax,%ecx
  800693:	89 c8                	mov    %ecx,%eax
  800695:	0f af c3             	imul   %ebx,%eax
  800698:	01 c2                	add    %eax,%edx
  80069a:	8b 45 14             	mov    0x14(%ebp),%eax
  80069d:	89 10                	mov    %edx,(%eax)
	{
		*mean += Elements[i];
	}
	*mean /= NumOfElements;
	*var = 0;
	for (i = 0 ; i < NumOfElements ; i++)
  80069f:	ff 45 f8             	incl   -0x8(%ebp)
  8006a2:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8006a5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006a8:	7c b2                	jl     80065c <ArrayStats+0x63>
	{
		*var += (Elements[i] - *mean)*(Elements[i] - *mean);
	}
	*var /= NumOfElements;
  8006aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ad:	8b 00                	mov    (%eax),%eax
  8006af:	99                   	cltd   
  8006b0:	f7 7d 0c             	idivl  0xc(%ebp)
  8006b3:	89 c2                	mov    %eax,%edx
  8006b5:	8b 45 14             	mov    0x14(%ebp),%eax
  8006b8:	89 10                	mov    %edx,(%eax)
}
  8006ba:	90                   	nop
  8006bb:	83 c4 10             	add    $0x10,%esp
  8006be:	5b                   	pop    %ebx
  8006bf:	5d                   	pop    %ebp
  8006c0:	c3                   	ret    

008006c1 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8006c1:	55                   	push   %ebp
  8006c2:	89 e5                	mov    %esp,%ebp
  8006c4:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8006c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ca:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006cd:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006d1:	83 ec 0c             	sub    $0xc,%esp
  8006d4:	50                   	push   %eax
  8006d5:	e8 db 1b 00 00       	call   8022b5 <sys_cputc>
  8006da:	83 c4 10             	add    $0x10,%esp
}
  8006dd:	90                   	nop
  8006de:	c9                   	leave  
  8006df:	c3                   	ret    

008006e0 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8006e0:	55                   	push   %ebp
  8006e1:	89 e5                	mov    %esp,%ebp
  8006e3:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006e6:	e8 96 1b 00 00       	call   802281 <sys_disable_interrupt>
	char c = ch;
  8006eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ee:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8006f1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8006f5:	83 ec 0c             	sub    $0xc,%esp
  8006f8:	50                   	push   %eax
  8006f9:	e8 b7 1b 00 00       	call   8022b5 <sys_cputc>
  8006fe:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800701:	e8 95 1b 00 00       	call   80229b <sys_enable_interrupt>
}
  800706:	90                   	nop
  800707:	c9                   	leave  
  800708:	c3                   	ret    

00800709 <getchar>:

int
getchar(void)
{
  800709:	55                   	push   %ebp
  80070a:	89 e5                	mov    %esp,%ebp
  80070c:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  80070f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800716:	eb 08                	jmp    800720 <getchar+0x17>
	{
		c = sys_cgetc();
  800718:	e8 df 19 00 00       	call   8020fc <sys_cgetc>
  80071d:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800720:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800724:	74 f2                	je     800718 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  800726:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800729:	c9                   	leave  
  80072a:	c3                   	ret    

0080072b <atomic_getchar>:

int
atomic_getchar(void)
{
  80072b:	55                   	push   %ebp
  80072c:	89 e5                	mov    %esp,%ebp
  80072e:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800731:	e8 4b 1b 00 00       	call   802281 <sys_disable_interrupt>
	int c=0;
  800736:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80073d:	eb 08                	jmp    800747 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  80073f:	e8 b8 19 00 00       	call   8020fc <sys_cgetc>
  800744:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  800747:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80074b:	74 f2                	je     80073f <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  80074d:	e8 49 1b 00 00       	call   80229b <sys_enable_interrupt>
	return c;
  800752:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800755:	c9                   	leave  
  800756:	c3                   	ret    

00800757 <iscons>:

int iscons(int fdnum)
{
  800757:	55                   	push   %ebp
  800758:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80075a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80075f:	5d                   	pop    %ebp
  800760:	c3                   	ret    

00800761 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800761:	55                   	push   %ebp
  800762:	89 e5                	mov    %esp,%ebp
  800764:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800767:	e8 08 1d 00 00       	call   802474 <sys_getenvindex>
  80076c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80076f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800772:	89 d0                	mov    %edx,%eax
  800774:	c1 e0 03             	shl    $0x3,%eax
  800777:	01 d0                	add    %edx,%eax
  800779:	01 c0                	add    %eax,%eax
  80077b:	01 d0                	add    %edx,%eax
  80077d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800784:	01 d0                	add    %edx,%eax
  800786:	c1 e0 04             	shl    $0x4,%eax
  800789:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80078e:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800793:	a1 20 50 80 00       	mov    0x805020,%eax
  800798:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80079e:	84 c0                	test   %al,%al
  8007a0:	74 0f                	je     8007b1 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8007a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007a7:	05 5c 05 00 00       	add    $0x55c,%eax
  8007ac:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8007b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8007b5:	7e 0a                	jle    8007c1 <libmain+0x60>
		binaryname = argv[0];
  8007b7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007ba:	8b 00                	mov    (%eax),%eax
  8007bc:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8007c1:	83 ec 08             	sub    $0x8,%esp
  8007c4:	ff 75 0c             	pushl  0xc(%ebp)
  8007c7:	ff 75 08             	pushl  0x8(%ebp)
  8007ca:	e8 69 f8 ff ff       	call   800038 <_main>
  8007cf:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8007d2:	e8 aa 1a 00 00       	call   802281 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8007d7:	83 ec 0c             	sub    $0xc,%esp
  8007da:	68 14 3d 80 00       	push   $0x803d14
  8007df:	e8 6d 03 00 00       	call   800b51 <cprintf>
  8007e4:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8007e7:	a1 20 50 80 00       	mov    0x805020,%eax
  8007ec:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8007f2:	a1 20 50 80 00       	mov    0x805020,%eax
  8007f7:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8007fd:	83 ec 04             	sub    $0x4,%esp
  800800:	52                   	push   %edx
  800801:	50                   	push   %eax
  800802:	68 3c 3d 80 00       	push   $0x803d3c
  800807:	e8 45 03 00 00       	call   800b51 <cprintf>
  80080c:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80080f:	a1 20 50 80 00       	mov    0x805020,%eax
  800814:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80081a:	a1 20 50 80 00       	mov    0x805020,%eax
  80081f:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800825:	a1 20 50 80 00       	mov    0x805020,%eax
  80082a:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800830:	51                   	push   %ecx
  800831:	52                   	push   %edx
  800832:	50                   	push   %eax
  800833:	68 64 3d 80 00       	push   $0x803d64
  800838:	e8 14 03 00 00       	call   800b51 <cprintf>
  80083d:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800840:	a1 20 50 80 00       	mov    0x805020,%eax
  800845:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  80084b:	83 ec 08             	sub    $0x8,%esp
  80084e:	50                   	push   %eax
  80084f:	68 bc 3d 80 00       	push   $0x803dbc
  800854:	e8 f8 02 00 00       	call   800b51 <cprintf>
  800859:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  80085c:	83 ec 0c             	sub    $0xc,%esp
  80085f:	68 14 3d 80 00       	push   $0x803d14
  800864:	e8 e8 02 00 00       	call   800b51 <cprintf>
  800869:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80086c:	e8 2a 1a 00 00       	call   80229b <sys_enable_interrupt>

	// exit gracefully
	exit();
  800871:	e8 19 00 00 00       	call   80088f <exit>
}
  800876:	90                   	nop
  800877:	c9                   	leave  
  800878:	c3                   	ret    

00800879 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800879:	55                   	push   %ebp
  80087a:	89 e5                	mov    %esp,%ebp
  80087c:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  80087f:	83 ec 0c             	sub    $0xc,%esp
  800882:	6a 00                	push   $0x0
  800884:	e8 b7 1b 00 00       	call   802440 <sys_destroy_env>
  800889:	83 c4 10             	add    $0x10,%esp
}
  80088c:	90                   	nop
  80088d:	c9                   	leave  
  80088e:	c3                   	ret    

0080088f <exit>:

void
exit(void)
{
  80088f:	55                   	push   %ebp
  800890:	89 e5                	mov    %esp,%ebp
  800892:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800895:	e8 0c 1c 00 00       	call   8024a6 <sys_exit_env>
}
  80089a:	90                   	nop
  80089b:	c9                   	leave  
  80089c:	c3                   	ret    

0080089d <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80089d:	55                   	push   %ebp
  80089e:	89 e5                	mov    %esp,%ebp
  8008a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8008a3:	8d 45 10             	lea    0x10(%ebp),%eax
  8008a6:	83 c0 04             	add    $0x4,%eax
  8008a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8008ac:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008b1:	85 c0                	test   %eax,%eax
  8008b3:	74 16                	je     8008cb <_panic+0x2e>
		cprintf("%s: ", argv0);
  8008b5:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8008ba:	83 ec 08             	sub    $0x8,%esp
  8008bd:	50                   	push   %eax
  8008be:	68 d0 3d 80 00       	push   $0x803dd0
  8008c3:	e8 89 02 00 00       	call   800b51 <cprintf>
  8008c8:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8008cb:	a1 00 50 80 00       	mov    0x805000,%eax
  8008d0:	ff 75 0c             	pushl  0xc(%ebp)
  8008d3:	ff 75 08             	pushl  0x8(%ebp)
  8008d6:	50                   	push   %eax
  8008d7:	68 d5 3d 80 00       	push   $0x803dd5
  8008dc:	e8 70 02 00 00       	call   800b51 <cprintf>
  8008e1:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8008e4:	8b 45 10             	mov    0x10(%ebp),%eax
  8008e7:	83 ec 08             	sub    $0x8,%esp
  8008ea:	ff 75 f4             	pushl  -0xc(%ebp)
  8008ed:	50                   	push   %eax
  8008ee:	e8 f3 01 00 00       	call   800ae6 <vcprintf>
  8008f3:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8008f6:	83 ec 08             	sub    $0x8,%esp
  8008f9:	6a 00                	push   $0x0
  8008fb:	68 f1 3d 80 00       	push   $0x803df1
  800900:	e8 e1 01 00 00       	call   800ae6 <vcprintf>
  800905:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800908:	e8 82 ff ff ff       	call   80088f <exit>

	// should not return here
	while (1) ;
  80090d:	eb fe                	jmp    80090d <_panic+0x70>

0080090f <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80090f:	55                   	push   %ebp
  800910:	89 e5                	mov    %esp,%ebp
  800912:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800915:	a1 20 50 80 00       	mov    0x805020,%eax
  80091a:	8b 50 74             	mov    0x74(%eax),%edx
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	39 c2                	cmp    %eax,%edx
  800922:	74 14                	je     800938 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800924:	83 ec 04             	sub    $0x4,%esp
  800927:	68 f4 3d 80 00       	push   $0x803df4
  80092c:	6a 26                	push   $0x26
  80092e:	68 40 3e 80 00       	push   $0x803e40
  800933:	e8 65 ff ff ff       	call   80089d <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800938:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80093f:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800946:	e9 c2 00 00 00       	jmp    800a0d <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  80094b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80094e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800955:	8b 45 08             	mov    0x8(%ebp),%eax
  800958:	01 d0                	add    %edx,%eax
  80095a:	8b 00                	mov    (%eax),%eax
  80095c:	85 c0                	test   %eax,%eax
  80095e:	75 08                	jne    800968 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800960:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800963:	e9 a2 00 00 00       	jmp    800a0a <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800968:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80096f:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800976:	eb 69                	jmp    8009e1 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800978:	a1 20 50 80 00       	mov    0x805020,%eax
  80097d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800983:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800986:	89 d0                	mov    %edx,%eax
  800988:	01 c0                	add    %eax,%eax
  80098a:	01 d0                	add    %edx,%eax
  80098c:	c1 e0 03             	shl    $0x3,%eax
  80098f:	01 c8                	add    %ecx,%eax
  800991:	8a 40 04             	mov    0x4(%eax),%al
  800994:	84 c0                	test   %al,%al
  800996:	75 46                	jne    8009de <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800998:	a1 20 50 80 00       	mov    0x805020,%eax
  80099d:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8009a3:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009a6:	89 d0                	mov    %edx,%eax
  8009a8:	01 c0                	add    %eax,%eax
  8009aa:	01 d0                	add    %edx,%eax
  8009ac:	c1 e0 03             	shl    $0x3,%eax
  8009af:	01 c8                	add    %ecx,%eax
  8009b1:	8b 00                	mov    (%eax),%eax
  8009b3:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8009b6:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8009b9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8009be:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8009c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009c3:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	01 c8                	add    %ecx,%eax
  8009cf:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8009d1:	39 c2                	cmp    %eax,%edx
  8009d3:	75 09                	jne    8009de <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8009d5:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8009dc:	eb 12                	jmp    8009f0 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8009de:	ff 45 e8             	incl   -0x18(%ebp)
  8009e1:	a1 20 50 80 00       	mov    0x805020,%eax
  8009e6:	8b 50 74             	mov    0x74(%eax),%edx
  8009e9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8009ec:	39 c2                	cmp    %eax,%edx
  8009ee:	77 88                	ja     800978 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  8009f0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8009f4:	75 14                	jne    800a0a <CheckWSWithoutLastIndex+0xfb>
			panic(
  8009f6:	83 ec 04             	sub    $0x4,%esp
  8009f9:	68 4c 3e 80 00       	push   $0x803e4c
  8009fe:	6a 3a                	push   $0x3a
  800a00:	68 40 3e 80 00       	push   $0x803e40
  800a05:	e8 93 fe ff ff       	call   80089d <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800a0a:	ff 45 f0             	incl   -0x10(%ebp)
  800a0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a10:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800a13:	0f 8c 32 ff ff ff    	jl     80094b <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800a19:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a20:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800a27:	eb 26                	jmp    800a4f <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800a29:	a1 20 50 80 00       	mov    0x805020,%eax
  800a2e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a34:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a37:	89 d0                	mov    %edx,%eax
  800a39:	01 c0                	add    %eax,%eax
  800a3b:	01 d0                	add    %edx,%eax
  800a3d:	c1 e0 03             	shl    $0x3,%eax
  800a40:	01 c8                	add    %ecx,%eax
  800a42:	8a 40 04             	mov    0x4(%eax),%al
  800a45:	3c 01                	cmp    $0x1,%al
  800a47:	75 03                	jne    800a4c <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800a49:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a4c:	ff 45 e0             	incl   -0x20(%ebp)
  800a4f:	a1 20 50 80 00       	mov    0x805020,%eax
  800a54:	8b 50 74             	mov    0x74(%eax),%edx
  800a57:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a5a:	39 c2                	cmp    %eax,%edx
  800a5c:	77 cb                	ja     800a29 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a61:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800a64:	74 14                	je     800a7a <CheckWSWithoutLastIndex+0x16b>
		panic(
  800a66:	83 ec 04             	sub    $0x4,%esp
  800a69:	68 a0 3e 80 00       	push   $0x803ea0
  800a6e:	6a 44                	push   $0x44
  800a70:	68 40 3e 80 00       	push   $0x803e40
  800a75:	e8 23 fe ff ff       	call   80089d <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800a7a:	90                   	nop
  800a7b:	c9                   	leave  
  800a7c:	c3                   	ret    

00800a7d <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800a7d:	55                   	push   %ebp
  800a7e:	89 e5                	mov    %esp,%ebp
  800a80:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800a83:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a86:	8b 00                	mov    (%eax),%eax
  800a88:	8d 48 01             	lea    0x1(%eax),%ecx
  800a8b:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a8e:	89 0a                	mov    %ecx,(%edx)
  800a90:	8b 55 08             	mov    0x8(%ebp),%edx
  800a93:	88 d1                	mov    %dl,%cl
  800a95:	8b 55 0c             	mov    0xc(%ebp),%edx
  800a98:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800a9c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a9f:	8b 00                	mov    (%eax),%eax
  800aa1:	3d ff 00 00 00       	cmp    $0xff,%eax
  800aa6:	75 2c                	jne    800ad4 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800aa8:	a0 24 50 80 00       	mov    0x805024,%al
  800aad:	0f b6 c0             	movzbl %al,%eax
  800ab0:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ab3:	8b 12                	mov    (%edx),%edx
  800ab5:	89 d1                	mov    %edx,%ecx
  800ab7:	8b 55 0c             	mov    0xc(%ebp),%edx
  800aba:	83 c2 08             	add    $0x8,%edx
  800abd:	83 ec 04             	sub    $0x4,%esp
  800ac0:	50                   	push   %eax
  800ac1:	51                   	push   %ecx
  800ac2:	52                   	push   %edx
  800ac3:	e8 0b 16 00 00       	call   8020d3 <sys_cputs>
  800ac8:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800acb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ace:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ad7:	8b 40 04             	mov    0x4(%eax),%eax
  800ada:	8d 50 01             	lea    0x1(%eax),%edx
  800add:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ae0:	89 50 04             	mov    %edx,0x4(%eax)
}
  800ae3:	90                   	nop
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
  800ae9:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800aef:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800af6:	00 00 00 
	b.cnt = 0;
  800af9:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800b00:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800b03:	ff 75 0c             	pushl  0xc(%ebp)
  800b06:	ff 75 08             	pushl  0x8(%ebp)
  800b09:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b0f:	50                   	push   %eax
  800b10:	68 7d 0a 80 00       	push   $0x800a7d
  800b15:	e8 11 02 00 00       	call   800d2b <vprintfmt>
  800b1a:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800b1d:	a0 24 50 80 00       	mov    0x805024,%al
  800b22:	0f b6 c0             	movzbl %al,%eax
  800b25:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800b2b:	83 ec 04             	sub    $0x4,%esp
  800b2e:	50                   	push   %eax
  800b2f:	52                   	push   %edx
  800b30:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800b36:	83 c0 08             	add    $0x8,%eax
  800b39:	50                   	push   %eax
  800b3a:	e8 94 15 00 00       	call   8020d3 <sys_cputs>
  800b3f:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800b42:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  800b49:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800b4f:	c9                   	leave  
  800b50:	c3                   	ret    

00800b51 <cprintf>:

int cprintf(const char *fmt, ...) {
  800b51:	55                   	push   %ebp
  800b52:	89 e5                	mov    %esp,%ebp
  800b54:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800b57:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  800b5e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b61:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b64:	8b 45 08             	mov    0x8(%ebp),%eax
  800b67:	83 ec 08             	sub    $0x8,%esp
  800b6a:	ff 75 f4             	pushl  -0xc(%ebp)
  800b6d:	50                   	push   %eax
  800b6e:	e8 73 ff ff ff       	call   800ae6 <vcprintf>
  800b73:	83 c4 10             	add    $0x10,%esp
  800b76:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800b79:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800b7c:	c9                   	leave  
  800b7d:	c3                   	ret    

00800b7e <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800b7e:	55                   	push   %ebp
  800b7f:	89 e5                	mov    %esp,%ebp
  800b81:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800b84:	e8 f8 16 00 00       	call   802281 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800b89:	8d 45 0c             	lea    0xc(%ebp),%eax
  800b8c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	83 ec 08             	sub    $0x8,%esp
  800b95:	ff 75 f4             	pushl  -0xc(%ebp)
  800b98:	50                   	push   %eax
  800b99:	e8 48 ff ff ff       	call   800ae6 <vcprintf>
  800b9e:	83 c4 10             	add    $0x10,%esp
  800ba1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ba4:	e8 f2 16 00 00       	call   80229b <sys_enable_interrupt>
	return cnt;
  800ba9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800bac:	c9                   	leave  
  800bad:	c3                   	ret    

00800bae <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800bae:	55                   	push   %ebp
  800baf:	89 e5                	mov    %esp,%ebp
  800bb1:	53                   	push   %ebx
  800bb2:	83 ec 14             	sub    $0x14,%esp
  800bb5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bbb:	8b 45 14             	mov    0x14(%ebp),%eax
  800bbe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800bc1:	8b 45 18             	mov    0x18(%ebp),%eax
  800bc4:	ba 00 00 00 00       	mov    $0x0,%edx
  800bc9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bcc:	77 55                	ja     800c23 <printnum+0x75>
  800bce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800bd1:	72 05                	jb     800bd8 <printnum+0x2a>
  800bd3:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800bd6:	77 4b                	ja     800c23 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800bd8:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800bdb:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800bde:	8b 45 18             	mov    0x18(%ebp),%eax
  800be1:	ba 00 00 00 00       	mov    $0x0,%edx
  800be6:	52                   	push   %edx
  800be7:	50                   	push   %eax
  800be8:	ff 75 f4             	pushl  -0xc(%ebp)
  800beb:	ff 75 f0             	pushl  -0x10(%ebp)
  800bee:	e8 69 2c 00 00       	call   80385c <__udivdi3>
  800bf3:	83 c4 10             	add    $0x10,%esp
  800bf6:	83 ec 04             	sub    $0x4,%esp
  800bf9:	ff 75 20             	pushl  0x20(%ebp)
  800bfc:	53                   	push   %ebx
  800bfd:	ff 75 18             	pushl  0x18(%ebp)
  800c00:	52                   	push   %edx
  800c01:	50                   	push   %eax
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	ff 75 08             	pushl  0x8(%ebp)
  800c08:	e8 a1 ff ff ff       	call   800bae <printnum>
  800c0d:	83 c4 20             	add    $0x20,%esp
  800c10:	eb 1a                	jmp    800c2c <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800c12:	83 ec 08             	sub    $0x8,%esp
  800c15:	ff 75 0c             	pushl  0xc(%ebp)
  800c18:	ff 75 20             	pushl  0x20(%ebp)
  800c1b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1e:	ff d0                	call   *%eax
  800c20:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800c23:	ff 4d 1c             	decl   0x1c(%ebp)
  800c26:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800c2a:	7f e6                	jg     800c12 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800c2c:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800c2f:	bb 00 00 00 00       	mov    $0x0,%ebx
  800c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3a:	53                   	push   %ebx
  800c3b:	51                   	push   %ecx
  800c3c:	52                   	push   %edx
  800c3d:	50                   	push   %eax
  800c3e:	e8 29 2d 00 00       	call   80396c <__umoddi3>
  800c43:	83 c4 10             	add    $0x10,%esp
  800c46:	05 14 41 80 00       	add    $0x804114,%eax
  800c4b:	8a 00                	mov    (%eax),%al
  800c4d:	0f be c0             	movsbl %al,%eax
  800c50:	83 ec 08             	sub    $0x8,%esp
  800c53:	ff 75 0c             	pushl  0xc(%ebp)
  800c56:	50                   	push   %eax
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	ff d0                	call   *%eax
  800c5c:	83 c4 10             	add    $0x10,%esp
}
  800c5f:	90                   	nop
  800c60:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800c63:	c9                   	leave  
  800c64:	c3                   	ret    

00800c65 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800c65:	55                   	push   %ebp
  800c66:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800c68:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c6c:	7e 1c                	jle    800c8a <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800c6e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c71:	8b 00                	mov    (%eax),%eax
  800c73:	8d 50 08             	lea    0x8(%eax),%edx
  800c76:	8b 45 08             	mov    0x8(%ebp),%eax
  800c79:	89 10                	mov    %edx,(%eax)
  800c7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7e:	8b 00                	mov    (%eax),%eax
  800c80:	83 e8 08             	sub    $0x8,%eax
  800c83:	8b 50 04             	mov    0x4(%eax),%edx
  800c86:	8b 00                	mov    (%eax),%eax
  800c88:	eb 40                	jmp    800cca <getuint+0x65>
	else if (lflag)
  800c8a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800c8e:	74 1e                	je     800cae <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800c90:	8b 45 08             	mov    0x8(%ebp),%eax
  800c93:	8b 00                	mov    (%eax),%eax
  800c95:	8d 50 04             	lea    0x4(%eax),%edx
  800c98:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9b:	89 10                	mov    %edx,(%eax)
  800c9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca0:	8b 00                	mov    (%eax),%eax
  800ca2:	83 e8 04             	sub    $0x4,%eax
  800ca5:	8b 00                	mov    (%eax),%eax
  800ca7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cac:	eb 1c                	jmp    800cca <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800cae:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb1:	8b 00                	mov    (%eax),%eax
  800cb3:	8d 50 04             	lea    0x4(%eax),%edx
  800cb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb9:	89 10                	mov    %edx,(%eax)
  800cbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbe:	8b 00                	mov    (%eax),%eax
  800cc0:	83 e8 04             	sub    $0x4,%eax
  800cc3:	8b 00                	mov    (%eax),%eax
  800cc5:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800cca:	5d                   	pop    %ebp
  800ccb:	c3                   	ret    

00800ccc <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ccc:	55                   	push   %ebp
  800ccd:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ccf:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cd3:	7e 1c                	jle    800cf1 <getint+0x25>
		return va_arg(*ap, long long);
  800cd5:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd8:	8b 00                	mov    (%eax),%eax
  800cda:	8d 50 08             	lea    0x8(%eax),%edx
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	89 10                	mov    %edx,(%eax)
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	8b 00                	mov    (%eax),%eax
  800ce7:	83 e8 08             	sub    $0x8,%eax
  800cea:	8b 50 04             	mov    0x4(%eax),%edx
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	eb 38                	jmp    800d29 <getint+0x5d>
	else if (lflag)
  800cf1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf5:	74 1a                	je     800d11 <getint+0x45>
		return va_arg(*ap, long);
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8b 00                	mov    (%eax),%eax
  800cfc:	8d 50 04             	lea    0x4(%eax),%edx
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	89 10                	mov    %edx,(%eax)
  800d04:	8b 45 08             	mov    0x8(%ebp),%eax
  800d07:	8b 00                	mov    (%eax),%eax
  800d09:	83 e8 04             	sub    $0x4,%eax
  800d0c:	8b 00                	mov    (%eax),%eax
  800d0e:	99                   	cltd   
  800d0f:	eb 18                	jmp    800d29 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800d11:	8b 45 08             	mov    0x8(%ebp),%eax
  800d14:	8b 00                	mov    (%eax),%eax
  800d16:	8d 50 04             	lea    0x4(%eax),%edx
  800d19:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1c:	89 10                	mov    %edx,(%eax)
  800d1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d21:	8b 00                	mov    (%eax),%eax
  800d23:	83 e8 04             	sub    $0x4,%eax
  800d26:	8b 00                	mov    (%eax),%eax
  800d28:	99                   	cltd   
}
  800d29:	5d                   	pop    %ebp
  800d2a:	c3                   	ret    

00800d2b <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800d2b:	55                   	push   %ebp
  800d2c:	89 e5                	mov    %esp,%ebp
  800d2e:	56                   	push   %esi
  800d2f:	53                   	push   %ebx
  800d30:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d33:	eb 17                	jmp    800d4c <vprintfmt+0x21>
			if (ch == '\0')
  800d35:	85 db                	test   %ebx,%ebx
  800d37:	0f 84 af 03 00 00    	je     8010ec <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800d3d:	83 ec 08             	sub    $0x8,%esp
  800d40:	ff 75 0c             	pushl  0xc(%ebp)
  800d43:	53                   	push   %ebx
  800d44:	8b 45 08             	mov    0x8(%ebp),%eax
  800d47:	ff d0                	call   *%eax
  800d49:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800d4c:	8b 45 10             	mov    0x10(%ebp),%eax
  800d4f:	8d 50 01             	lea    0x1(%eax),%edx
  800d52:	89 55 10             	mov    %edx,0x10(%ebp)
  800d55:	8a 00                	mov    (%eax),%al
  800d57:	0f b6 d8             	movzbl %al,%ebx
  800d5a:	83 fb 25             	cmp    $0x25,%ebx
  800d5d:	75 d6                	jne    800d35 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800d5f:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800d63:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800d6a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800d71:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800d78:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800d7f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d82:	8d 50 01             	lea    0x1(%eax),%edx
  800d85:	89 55 10             	mov    %edx,0x10(%ebp)
  800d88:	8a 00                	mov    (%eax),%al
  800d8a:	0f b6 d8             	movzbl %al,%ebx
  800d8d:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800d90:	83 f8 55             	cmp    $0x55,%eax
  800d93:	0f 87 2b 03 00 00    	ja     8010c4 <vprintfmt+0x399>
  800d99:	8b 04 85 38 41 80 00 	mov    0x804138(,%eax,4),%eax
  800da0:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800da2:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800da6:	eb d7                	jmp    800d7f <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800da8:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800dac:	eb d1                	jmp    800d7f <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800dae:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800db5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800db8:	89 d0                	mov    %edx,%eax
  800dba:	c1 e0 02             	shl    $0x2,%eax
  800dbd:	01 d0                	add    %edx,%eax
  800dbf:	01 c0                	add    %eax,%eax
  800dc1:	01 d8                	add    %ebx,%eax
  800dc3:	83 e8 30             	sub    $0x30,%eax
  800dc6:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800dc9:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcc:	8a 00                	mov    (%eax),%al
  800dce:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800dd1:	83 fb 2f             	cmp    $0x2f,%ebx
  800dd4:	7e 3e                	jle    800e14 <vprintfmt+0xe9>
  800dd6:	83 fb 39             	cmp    $0x39,%ebx
  800dd9:	7f 39                	jg     800e14 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ddb:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800dde:	eb d5                	jmp    800db5 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800de0:	8b 45 14             	mov    0x14(%ebp),%eax
  800de3:	83 c0 04             	add    $0x4,%eax
  800de6:	89 45 14             	mov    %eax,0x14(%ebp)
  800de9:	8b 45 14             	mov    0x14(%ebp),%eax
  800dec:	83 e8 04             	sub    $0x4,%eax
  800def:	8b 00                	mov    (%eax),%eax
  800df1:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800df4:	eb 1f                	jmp    800e15 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800df6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfa:	79 83                	jns    800d7f <vprintfmt+0x54>
				width = 0;
  800dfc:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800e03:	e9 77 ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800e08:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800e0f:	e9 6b ff ff ff       	jmp    800d7f <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800e14:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800e15:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e19:	0f 89 60 ff ff ff    	jns    800d7f <vprintfmt+0x54>
				width = precision, precision = -1;
  800e1f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800e22:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800e25:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800e2c:	e9 4e ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800e31:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800e34:	e9 46 ff ff ff       	jmp    800d7f <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800e39:	8b 45 14             	mov    0x14(%ebp),%eax
  800e3c:	83 c0 04             	add    $0x4,%eax
  800e3f:	89 45 14             	mov    %eax,0x14(%ebp)
  800e42:	8b 45 14             	mov    0x14(%ebp),%eax
  800e45:	83 e8 04             	sub    $0x4,%eax
  800e48:	8b 00                	mov    (%eax),%eax
  800e4a:	83 ec 08             	sub    $0x8,%esp
  800e4d:	ff 75 0c             	pushl  0xc(%ebp)
  800e50:	50                   	push   %eax
  800e51:	8b 45 08             	mov    0x8(%ebp),%eax
  800e54:	ff d0                	call   *%eax
  800e56:	83 c4 10             	add    $0x10,%esp
			break;
  800e59:	e9 89 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800e5e:	8b 45 14             	mov    0x14(%ebp),%eax
  800e61:	83 c0 04             	add    $0x4,%eax
  800e64:	89 45 14             	mov    %eax,0x14(%ebp)
  800e67:	8b 45 14             	mov    0x14(%ebp),%eax
  800e6a:	83 e8 04             	sub    $0x4,%eax
  800e6d:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800e6f:	85 db                	test   %ebx,%ebx
  800e71:	79 02                	jns    800e75 <vprintfmt+0x14a>
				err = -err;
  800e73:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800e75:	83 fb 64             	cmp    $0x64,%ebx
  800e78:	7f 0b                	jg     800e85 <vprintfmt+0x15a>
  800e7a:	8b 34 9d 80 3f 80 00 	mov    0x803f80(,%ebx,4),%esi
  800e81:	85 f6                	test   %esi,%esi
  800e83:	75 19                	jne    800e9e <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800e85:	53                   	push   %ebx
  800e86:	68 25 41 80 00       	push   $0x804125
  800e8b:	ff 75 0c             	pushl  0xc(%ebp)
  800e8e:	ff 75 08             	pushl  0x8(%ebp)
  800e91:	e8 5e 02 00 00       	call   8010f4 <printfmt>
  800e96:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800e99:	e9 49 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800e9e:	56                   	push   %esi
  800e9f:	68 2e 41 80 00       	push   $0x80412e
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	ff 75 08             	pushl  0x8(%ebp)
  800eaa:	e8 45 02 00 00       	call   8010f4 <printfmt>
  800eaf:	83 c4 10             	add    $0x10,%esp
			break;
  800eb2:	e9 30 02 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800eb7:	8b 45 14             	mov    0x14(%ebp),%eax
  800eba:	83 c0 04             	add    $0x4,%eax
  800ebd:	89 45 14             	mov    %eax,0x14(%ebp)
  800ec0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ec3:	83 e8 04             	sub    $0x4,%eax
  800ec6:	8b 30                	mov    (%eax),%esi
  800ec8:	85 f6                	test   %esi,%esi
  800eca:	75 05                	jne    800ed1 <vprintfmt+0x1a6>
				p = "(null)";
  800ecc:	be 31 41 80 00       	mov    $0x804131,%esi
			if (width > 0 && padc != '-')
  800ed1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ed5:	7e 6d                	jle    800f44 <vprintfmt+0x219>
  800ed7:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800edb:	74 67                	je     800f44 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800edd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ee0:	83 ec 08             	sub    $0x8,%esp
  800ee3:	50                   	push   %eax
  800ee4:	56                   	push   %esi
  800ee5:	e8 12 05 00 00       	call   8013fc <strnlen>
  800eea:	83 c4 10             	add    $0x10,%esp
  800eed:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ef0:	eb 16                	jmp    800f08 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ef2:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ef6:	83 ec 08             	sub    $0x8,%esp
  800ef9:	ff 75 0c             	pushl  0xc(%ebp)
  800efc:	50                   	push   %eax
  800efd:	8b 45 08             	mov    0x8(%ebp),%eax
  800f00:	ff d0                	call   *%eax
  800f02:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800f05:	ff 4d e4             	decl   -0x1c(%ebp)
  800f08:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f0c:	7f e4                	jg     800ef2 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f0e:	eb 34                	jmp    800f44 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800f10:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f14:	74 1c                	je     800f32 <vprintfmt+0x207>
  800f16:	83 fb 1f             	cmp    $0x1f,%ebx
  800f19:	7e 05                	jle    800f20 <vprintfmt+0x1f5>
  800f1b:	83 fb 7e             	cmp    $0x7e,%ebx
  800f1e:	7e 12                	jle    800f32 <vprintfmt+0x207>
					putch('?', putdat);
  800f20:	83 ec 08             	sub    $0x8,%esp
  800f23:	ff 75 0c             	pushl  0xc(%ebp)
  800f26:	6a 3f                	push   $0x3f
  800f28:	8b 45 08             	mov    0x8(%ebp),%eax
  800f2b:	ff d0                	call   *%eax
  800f2d:	83 c4 10             	add    $0x10,%esp
  800f30:	eb 0f                	jmp    800f41 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800f32:	83 ec 08             	sub    $0x8,%esp
  800f35:	ff 75 0c             	pushl  0xc(%ebp)
  800f38:	53                   	push   %ebx
  800f39:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3c:	ff d0                	call   *%eax
  800f3e:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800f41:	ff 4d e4             	decl   -0x1c(%ebp)
  800f44:	89 f0                	mov    %esi,%eax
  800f46:	8d 70 01             	lea    0x1(%eax),%esi
  800f49:	8a 00                	mov    (%eax),%al
  800f4b:	0f be d8             	movsbl %al,%ebx
  800f4e:	85 db                	test   %ebx,%ebx
  800f50:	74 24                	je     800f76 <vprintfmt+0x24b>
  800f52:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f56:	78 b8                	js     800f10 <vprintfmt+0x1e5>
  800f58:	ff 4d e0             	decl   -0x20(%ebp)
  800f5b:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800f5f:	79 af                	jns    800f10 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f61:	eb 13                	jmp    800f76 <vprintfmt+0x24b>
				putch(' ', putdat);
  800f63:	83 ec 08             	sub    $0x8,%esp
  800f66:	ff 75 0c             	pushl  0xc(%ebp)
  800f69:	6a 20                	push   $0x20
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	ff d0                	call   *%eax
  800f70:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800f73:	ff 4d e4             	decl   -0x1c(%ebp)
  800f76:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f7a:	7f e7                	jg     800f63 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800f7c:	e9 66 01 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800f81:	83 ec 08             	sub    $0x8,%esp
  800f84:	ff 75 e8             	pushl  -0x18(%ebp)
  800f87:	8d 45 14             	lea    0x14(%ebp),%eax
  800f8a:	50                   	push   %eax
  800f8b:	e8 3c fd ff ff       	call   800ccc <getint>
  800f90:	83 c4 10             	add    $0x10,%esp
  800f93:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f96:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800f9f:	85 d2                	test   %edx,%edx
  800fa1:	79 23                	jns    800fc6 <vprintfmt+0x29b>
				putch('-', putdat);
  800fa3:	83 ec 08             	sub    $0x8,%esp
  800fa6:	ff 75 0c             	pushl  0xc(%ebp)
  800fa9:	6a 2d                	push   $0x2d
  800fab:	8b 45 08             	mov    0x8(%ebp),%eax
  800fae:	ff d0                	call   *%eax
  800fb0:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800fb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800fb6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800fb9:	f7 d8                	neg    %eax
  800fbb:	83 d2 00             	adc    $0x0,%edx
  800fbe:	f7 da                	neg    %edx
  800fc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fc3:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800fc6:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800fcd:	e9 bc 00 00 00       	jmp    80108e <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800fd2:	83 ec 08             	sub    $0x8,%esp
  800fd5:	ff 75 e8             	pushl  -0x18(%ebp)
  800fd8:	8d 45 14             	lea    0x14(%ebp),%eax
  800fdb:	50                   	push   %eax
  800fdc:	e8 84 fc ff ff       	call   800c65 <getuint>
  800fe1:	83 c4 10             	add    $0x10,%esp
  800fe4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fe7:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800fea:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800ff1:	e9 98 00 00 00       	jmp    80108e <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800ff6:	83 ec 08             	sub    $0x8,%esp
  800ff9:	ff 75 0c             	pushl  0xc(%ebp)
  800ffc:	6a 58                	push   $0x58
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	ff d0                	call   *%eax
  801003:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801006:	83 ec 08             	sub    $0x8,%esp
  801009:	ff 75 0c             	pushl  0xc(%ebp)
  80100c:	6a 58                	push   $0x58
  80100e:	8b 45 08             	mov    0x8(%ebp),%eax
  801011:	ff d0                	call   *%eax
  801013:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801016:	83 ec 08             	sub    $0x8,%esp
  801019:	ff 75 0c             	pushl  0xc(%ebp)
  80101c:	6a 58                	push   $0x58
  80101e:	8b 45 08             	mov    0x8(%ebp),%eax
  801021:	ff d0                	call   *%eax
  801023:	83 c4 10             	add    $0x10,%esp
			break;
  801026:	e9 bc 00 00 00       	jmp    8010e7 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  80102b:	83 ec 08             	sub    $0x8,%esp
  80102e:	ff 75 0c             	pushl  0xc(%ebp)
  801031:	6a 30                	push   $0x30
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	ff d0                	call   *%eax
  801038:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  80103b:	83 ec 08             	sub    $0x8,%esp
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	6a 78                	push   $0x78
  801043:	8b 45 08             	mov    0x8(%ebp),%eax
  801046:	ff d0                	call   *%eax
  801048:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  80104b:	8b 45 14             	mov    0x14(%ebp),%eax
  80104e:	83 c0 04             	add    $0x4,%eax
  801051:	89 45 14             	mov    %eax,0x14(%ebp)
  801054:	8b 45 14             	mov    0x14(%ebp),%eax
  801057:	83 e8 04             	sub    $0x4,%eax
  80105a:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  80105c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801066:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  80106d:	eb 1f                	jmp    80108e <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80106f:	83 ec 08             	sub    $0x8,%esp
  801072:	ff 75 e8             	pushl  -0x18(%ebp)
  801075:	8d 45 14             	lea    0x14(%ebp),%eax
  801078:	50                   	push   %eax
  801079:	e8 e7 fb ff ff       	call   800c65 <getuint>
  80107e:	83 c4 10             	add    $0x10,%esp
  801081:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801084:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801087:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  80108e:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801092:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801095:	83 ec 04             	sub    $0x4,%esp
  801098:	52                   	push   %edx
  801099:	ff 75 e4             	pushl  -0x1c(%ebp)
  80109c:	50                   	push   %eax
  80109d:	ff 75 f4             	pushl  -0xc(%ebp)
  8010a0:	ff 75 f0             	pushl  -0x10(%ebp)
  8010a3:	ff 75 0c             	pushl  0xc(%ebp)
  8010a6:	ff 75 08             	pushl  0x8(%ebp)
  8010a9:	e8 00 fb ff ff       	call   800bae <printnum>
  8010ae:	83 c4 20             	add    $0x20,%esp
			break;
  8010b1:	eb 34                	jmp    8010e7 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8010b3:	83 ec 08             	sub    $0x8,%esp
  8010b6:	ff 75 0c             	pushl  0xc(%ebp)
  8010b9:	53                   	push   %ebx
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	ff d0                	call   *%eax
  8010bf:	83 c4 10             	add    $0x10,%esp
			break;
  8010c2:	eb 23                	jmp    8010e7 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8010c4:	83 ec 08             	sub    $0x8,%esp
  8010c7:	ff 75 0c             	pushl  0xc(%ebp)
  8010ca:	6a 25                	push   $0x25
  8010cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010cf:	ff d0                	call   *%eax
  8010d1:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8010d4:	ff 4d 10             	decl   0x10(%ebp)
  8010d7:	eb 03                	jmp    8010dc <vprintfmt+0x3b1>
  8010d9:	ff 4d 10             	decl   0x10(%ebp)
  8010dc:	8b 45 10             	mov    0x10(%ebp),%eax
  8010df:	48                   	dec    %eax
  8010e0:	8a 00                	mov    (%eax),%al
  8010e2:	3c 25                	cmp    $0x25,%al
  8010e4:	75 f3                	jne    8010d9 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8010e6:	90                   	nop
		}
	}
  8010e7:	e9 47 fc ff ff       	jmp    800d33 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8010ec:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8010ed:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8010f0:	5b                   	pop    %ebx
  8010f1:	5e                   	pop    %esi
  8010f2:	5d                   	pop    %ebp
  8010f3:	c3                   	ret    

008010f4 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8010fa:	8d 45 10             	lea    0x10(%ebp),%eax
  8010fd:	83 c0 04             	add    $0x4,%eax
  801100:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801103:	8b 45 10             	mov    0x10(%ebp),%eax
  801106:	ff 75 f4             	pushl  -0xc(%ebp)
  801109:	50                   	push   %eax
  80110a:	ff 75 0c             	pushl  0xc(%ebp)
  80110d:	ff 75 08             	pushl  0x8(%ebp)
  801110:	e8 16 fc ff ff       	call   800d2b <vprintfmt>
  801115:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801118:	90                   	nop
  801119:	c9                   	leave  
  80111a:	c3                   	ret    

0080111b <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  80111b:	55                   	push   %ebp
  80111c:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  80111e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801121:	8b 40 08             	mov    0x8(%eax),%eax
  801124:	8d 50 01             	lea    0x1(%eax),%edx
  801127:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112a:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  80112d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801130:	8b 10                	mov    (%eax),%edx
  801132:	8b 45 0c             	mov    0xc(%ebp),%eax
  801135:	8b 40 04             	mov    0x4(%eax),%eax
  801138:	39 c2                	cmp    %eax,%edx
  80113a:	73 12                	jae    80114e <sprintputch+0x33>
		*b->buf++ = ch;
  80113c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80113f:	8b 00                	mov    (%eax),%eax
  801141:	8d 48 01             	lea    0x1(%eax),%ecx
  801144:	8b 55 0c             	mov    0xc(%ebp),%edx
  801147:	89 0a                	mov    %ecx,(%edx)
  801149:	8b 55 08             	mov    0x8(%ebp),%edx
  80114c:	88 10                	mov    %dl,(%eax)
}
  80114e:	90                   	nop
  80114f:	5d                   	pop    %ebp
  801150:	c3                   	ret    

00801151 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801151:	55                   	push   %ebp
  801152:	89 e5                	mov    %esp,%ebp
  801154:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801157:	8b 45 08             	mov    0x8(%ebp),%eax
  80115a:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80115d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801160:	8d 50 ff             	lea    -0x1(%eax),%edx
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	01 d0                	add    %edx,%eax
  801168:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80116b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801172:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801176:	74 06                	je     80117e <vsnprintf+0x2d>
  801178:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80117c:	7f 07                	jg     801185 <vsnprintf+0x34>
		return -E_INVAL;
  80117e:	b8 03 00 00 00       	mov    $0x3,%eax
  801183:	eb 20                	jmp    8011a5 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801185:	ff 75 14             	pushl  0x14(%ebp)
  801188:	ff 75 10             	pushl  0x10(%ebp)
  80118b:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80118e:	50                   	push   %eax
  80118f:	68 1b 11 80 00       	push   $0x80111b
  801194:	e8 92 fb ff ff       	call   800d2b <vprintfmt>
  801199:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80119c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119f:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8011a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8011a5:	c9                   	leave  
  8011a6:	c3                   	ret    

008011a7 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8011a7:	55                   	push   %ebp
  8011a8:	89 e5                	mov    %esp,%ebp
  8011aa:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8011ad:	8d 45 10             	lea    0x10(%ebp),%eax
  8011b0:	83 c0 04             	add    $0x4,%eax
  8011b3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8011b6:	8b 45 10             	mov    0x10(%ebp),%eax
  8011b9:	ff 75 f4             	pushl  -0xc(%ebp)
  8011bc:	50                   	push   %eax
  8011bd:	ff 75 0c             	pushl  0xc(%ebp)
  8011c0:	ff 75 08             	pushl  0x8(%ebp)
  8011c3:	e8 89 ff ff ff       	call   801151 <vsnprintf>
  8011c8:	83 c4 10             	add    $0x10,%esp
  8011cb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8011ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8011d1:	c9                   	leave  
  8011d2:	c3                   	ret    

008011d3 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8011d3:	55                   	push   %ebp
  8011d4:	89 e5                	mov    %esp,%ebp
  8011d6:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8011d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011dd:	74 13                	je     8011f2 <readline+0x1f>
		cprintf("%s", prompt);
  8011df:	83 ec 08             	sub    $0x8,%esp
  8011e2:	ff 75 08             	pushl  0x8(%ebp)
  8011e5:	68 90 42 80 00       	push   $0x804290
  8011ea:	e8 62 f9 ff ff       	call   800b51 <cprintf>
  8011ef:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8011f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8011f9:	83 ec 0c             	sub    $0xc,%esp
  8011fc:	6a 00                	push   $0x0
  8011fe:	e8 54 f5 ff ff       	call   800757 <iscons>
  801203:	83 c4 10             	add    $0x10,%esp
  801206:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801209:	e8 fb f4 ff ff       	call   800709 <getchar>
  80120e:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801211:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801215:	79 22                	jns    801239 <readline+0x66>
			if (c != -E_EOF)
  801217:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80121b:	0f 84 ad 00 00 00    	je     8012ce <readline+0xfb>
				cprintf("read error: %e\n", c);
  801221:	83 ec 08             	sub    $0x8,%esp
  801224:	ff 75 ec             	pushl  -0x14(%ebp)
  801227:	68 93 42 80 00       	push   $0x804293
  80122c:	e8 20 f9 ff ff       	call   800b51 <cprintf>
  801231:	83 c4 10             	add    $0x10,%esp
			return;
  801234:	e9 95 00 00 00       	jmp    8012ce <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801239:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  80123d:	7e 34                	jle    801273 <readline+0xa0>
  80123f:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  801246:	7f 2b                	jg     801273 <readline+0xa0>
			if (echoing)
  801248:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80124c:	74 0e                	je     80125c <readline+0x89>
				cputchar(c);
  80124e:	83 ec 0c             	sub    $0xc,%esp
  801251:	ff 75 ec             	pushl  -0x14(%ebp)
  801254:	e8 68 f4 ff ff       	call   8006c1 <cputchar>
  801259:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  80125c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80125f:	8d 50 01             	lea    0x1(%eax),%edx
  801262:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801265:	89 c2                	mov    %eax,%edx
  801267:	8b 45 0c             	mov    0xc(%ebp),%eax
  80126a:	01 d0                	add    %edx,%eax
  80126c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80126f:	88 10                	mov    %dl,(%eax)
  801271:	eb 56                	jmp    8012c9 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801273:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801277:	75 1f                	jne    801298 <readline+0xc5>
  801279:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80127d:	7e 19                	jle    801298 <readline+0xc5>
			if (echoing)
  80127f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801283:	74 0e                	je     801293 <readline+0xc0>
				cputchar(c);
  801285:	83 ec 0c             	sub    $0xc,%esp
  801288:	ff 75 ec             	pushl  -0x14(%ebp)
  80128b:	e8 31 f4 ff ff       	call   8006c1 <cputchar>
  801290:	83 c4 10             	add    $0x10,%esp

			i--;
  801293:	ff 4d f4             	decl   -0xc(%ebp)
  801296:	eb 31                	jmp    8012c9 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801298:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  80129c:	74 0a                	je     8012a8 <readline+0xd5>
  80129e:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8012a2:	0f 85 61 ff ff ff    	jne    801209 <readline+0x36>
			if (echoing)
  8012a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8012ac:	74 0e                	je     8012bc <readline+0xe9>
				cputchar(c);
  8012ae:	83 ec 0c             	sub    $0xc,%esp
  8012b1:	ff 75 ec             	pushl  -0x14(%ebp)
  8012b4:	e8 08 f4 ff ff       	call   8006c1 <cputchar>
  8012b9:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8012bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8012bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012c2:	01 d0                	add    %edx,%eax
  8012c4:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8012c7:	eb 06                	jmp    8012cf <readline+0xfc>
		}
	}
  8012c9:	e9 3b ff ff ff       	jmp    801209 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8012ce:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8012cf:	c9                   	leave  
  8012d0:	c3                   	ret    

008012d1 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8012d1:	55                   	push   %ebp
  8012d2:	89 e5                	mov    %esp,%ebp
  8012d4:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8012d7:	e8 a5 0f 00 00       	call   802281 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8012dc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e0:	74 13                	je     8012f5 <atomic_readline+0x24>
		cprintf("%s", prompt);
  8012e2:	83 ec 08             	sub    $0x8,%esp
  8012e5:	ff 75 08             	pushl  0x8(%ebp)
  8012e8:	68 90 42 80 00       	push   $0x804290
  8012ed:	e8 5f f8 ff ff       	call   800b51 <cprintf>
  8012f2:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012f5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012fc:	83 ec 0c             	sub    $0xc,%esp
  8012ff:	6a 00                	push   $0x0
  801301:	e8 51 f4 ff ff       	call   800757 <iscons>
  801306:	83 c4 10             	add    $0x10,%esp
  801309:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80130c:	e8 f8 f3 ff ff       	call   800709 <getchar>
  801311:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801314:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801318:	79 23                	jns    80133d <atomic_readline+0x6c>
			if (c != -E_EOF)
  80131a:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  80131e:	74 13                	je     801333 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801320:	83 ec 08             	sub    $0x8,%esp
  801323:	ff 75 ec             	pushl  -0x14(%ebp)
  801326:	68 93 42 80 00       	push   $0x804293
  80132b:	e8 21 f8 ff ff       	call   800b51 <cprintf>
  801330:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801333:	e8 63 0f 00 00       	call   80229b <sys_enable_interrupt>
			return;
  801338:	e9 9a 00 00 00       	jmp    8013d7 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80133d:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801341:	7e 34                	jle    801377 <atomic_readline+0xa6>
  801343:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134a:	7f 2b                	jg     801377 <atomic_readline+0xa6>
			if (echoing)
  80134c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801350:	74 0e                	je     801360 <atomic_readline+0x8f>
				cputchar(c);
  801352:	83 ec 0c             	sub    $0xc,%esp
  801355:	ff 75 ec             	pushl  -0x14(%ebp)
  801358:	e8 64 f3 ff ff       	call   8006c1 <cputchar>
  80135d:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801360:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801363:	8d 50 01             	lea    0x1(%eax),%edx
  801366:	89 55 f4             	mov    %edx,-0xc(%ebp)
  801369:	89 c2                	mov    %eax,%edx
  80136b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801373:	88 10                	mov    %dl,(%eax)
  801375:	eb 5b                	jmp    8013d2 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801377:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137b:	75 1f                	jne    80139c <atomic_readline+0xcb>
  80137d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801381:	7e 19                	jle    80139c <atomic_readline+0xcb>
			if (echoing)
  801383:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801387:	74 0e                	je     801397 <atomic_readline+0xc6>
				cputchar(c);
  801389:	83 ec 0c             	sub    $0xc,%esp
  80138c:	ff 75 ec             	pushl  -0x14(%ebp)
  80138f:	e8 2d f3 ff ff       	call   8006c1 <cputchar>
  801394:	83 c4 10             	add    $0x10,%esp
			i--;
  801397:	ff 4d f4             	decl   -0xc(%ebp)
  80139a:	eb 36                	jmp    8013d2 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  80139c:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a0:	74 0a                	je     8013ac <atomic_readline+0xdb>
  8013a2:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a6:	0f 85 60 ff ff ff    	jne    80130c <atomic_readline+0x3b>
			if (echoing)
  8013ac:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b0:	74 0e                	je     8013c0 <atomic_readline+0xef>
				cputchar(c);
  8013b2:	83 ec 0c             	sub    $0xc,%esp
  8013b5:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b8:	e8 04 f3 ff ff       	call   8006c1 <cputchar>
  8013bd:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8013c0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c6:	01 d0                	add    %edx,%eax
  8013c8:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8013cb:	e8 cb 0e 00 00       	call   80229b <sys_enable_interrupt>
			return;
  8013d0:	eb 05                	jmp    8013d7 <atomic_readline+0x106>
		}
	}
  8013d2:	e9 35 ff ff ff       	jmp    80130c <atomic_readline+0x3b>
}
  8013d7:	c9                   	leave  
  8013d8:	c3                   	ret    

008013d9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013d9:	55                   	push   %ebp
  8013da:	89 e5                	mov    %esp,%ebp
  8013dc:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013e6:	eb 06                	jmp    8013ee <strlen+0x15>
		n++;
  8013e8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013eb:	ff 45 08             	incl   0x8(%ebp)
  8013ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f1:	8a 00                	mov    (%eax),%al
  8013f3:	84 c0                	test   %al,%al
  8013f5:	75 f1                	jne    8013e8 <strlen+0xf>
		n++;
	return n;
  8013f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013fa:	c9                   	leave  
  8013fb:	c3                   	ret    

008013fc <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013fc:	55                   	push   %ebp
  8013fd:	89 e5                	mov    %esp,%ebp
  8013ff:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801402:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801409:	eb 09                	jmp    801414 <strnlen+0x18>
		n++;
  80140b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80140e:	ff 45 08             	incl   0x8(%ebp)
  801411:	ff 4d 0c             	decl   0xc(%ebp)
  801414:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801418:	74 09                	je     801423 <strnlen+0x27>
  80141a:	8b 45 08             	mov    0x8(%ebp),%eax
  80141d:	8a 00                	mov    (%eax),%al
  80141f:	84 c0                	test   %al,%al
  801421:	75 e8                	jne    80140b <strnlen+0xf>
		n++;
	return n;
  801423:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801426:	c9                   	leave  
  801427:	c3                   	ret    

00801428 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801428:	55                   	push   %ebp
  801429:	89 e5                	mov    %esp,%ebp
  80142b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80142e:	8b 45 08             	mov    0x8(%ebp),%eax
  801431:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801434:	90                   	nop
  801435:	8b 45 08             	mov    0x8(%ebp),%eax
  801438:	8d 50 01             	lea    0x1(%eax),%edx
  80143b:	89 55 08             	mov    %edx,0x8(%ebp)
  80143e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801441:	8d 4a 01             	lea    0x1(%edx),%ecx
  801444:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801447:	8a 12                	mov    (%edx),%dl
  801449:	88 10                	mov    %dl,(%eax)
  80144b:	8a 00                	mov    (%eax),%al
  80144d:	84 c0                	test   %al,%al
  80144f:	75 e4                	jne    801435 <strcpy+0xd>
		/* do nothing */;
	return ret;
  801451:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801454:	c9                   	leave  
  801455:	c3                   	ret    

00801456 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  801456:	55                   	push   %ebp
  801457:	89 e5                	mov    %esp,%ebp
  801459:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  80145c:	8b 45 08             	mov    0x8(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801462:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801469:	eb 1f                	jmp    80148a <strncpy+0x34>
		*dst++ = *src;
  80146b:	8b 45 08             	mov    0x8(%ebp),%eax
  80146e:	8d 50 01             	lea    0x1(%eax),%edx
  801471:	89 55 08             	mov    %edx,0x8(%ebp)
  801474:	8b 55 0c             	mov    0xc(%ebp),%edx
  801477:	8a 12                	mov    (%edx),%dl
  801479:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  80147b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80147e:	8a 00                	mov    (%eax),%al
  801480:	84 c0                	test   %al,%al
  801482:	74 03                	je     801487 <strncpy+0x31>
			src++;
  801484:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801487:	ff 45 fc             	incl   -0x4(%ebp)
  80148a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80148d:	3b 45 10             	cmp    0x10(%ebp),%eax
  801490:	72 d9                	jb     80146b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801492:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801495:	c9                   	leave  
  801496:	c3                   	ret    

00801497 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801497:	55                   	push   %ebp
  801498:	89 e5                	mov    %esp,%ebp
  80149a:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8014a3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014a7:	74 30                	je     8014d9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8014a9:	eb 16                	jmp    8014c1 <strlcpy+0x2a>
			*dst++ = *src++;
  8014ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ae:	8d 50 01             	lea    0x1(%eax),%edx
  8014b1:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014b7:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014ba:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014bd:	8a 12                	mov    (%edx),%dl
  8014bf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014c1:	ff 4d 10             	decl   0x10(%ebp)
  8014c4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014c8:	74 09                	je     8014d3 <strlcpy+0x3c>
  8014ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cd:	8a 00                	mov    (%eax),%al
  8014cf:	84 c0                	test   %al,%al
  8014d1:	75 d8                	jne    8014ab <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014d6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014d9:	8b 55 08             	mov    0x8(%ebp),%edx
  8014dc:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014df:	29 c2                	sub    %eax,%edx
  8014e1:	89 d0                	mov    %edx,%eax
}
  8014e3:	c9                   	leave  
  8014e4:	c3                   	ret    

008014e5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014e5:	55                   	push   %ebp
  8014e6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014e8:	eb 06                	jmp    8014f0 <strcmp+0xb>
		p++, q++;
  8014ea:	ff 45 08             	incl   0x8(%ebp)
  8014ed:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f3:	8a 00                	mov    (%eax),%al
  8014f5:	84 c0                	test   %al,%al
  8014f7:	74 0e                	je     801507 <strcmp+0x22>
  8014f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fc:	8a 10                	mov    (%eax),%dl
  8014fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  801501:	8a 00                	mov    (%eax),%al
  801503:	38 c2                	cmp    %al,%dl
  801505:	74 e3                	je     8014ea <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801507:	8b 45 08             	mov    0x8(%ebp),%eax
  80150a:	8a 00                	mov    (%eax),%al
  80150c:	0f b6 d0             	movzbl %al,%edx
  80150f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801512:	8a 00                	mov    (%eax),%al
  801514:	0f b6 c0             	movzbl %al,%eax
  801517:	29 c2                	sub    %eax,%edx
  801519:	89 d0                	mov    %edx,%eax
}
  80151b:	5d                   	pop    %ebp
  80151c:	c3                   	ret    

0080151d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80151d:	55                   	push   %ebp
  80151e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801520:	eb 09                	jmp    80152b <strncmp+0xe>
		n--, p++, q++;
  801522:	ff 4d 10             	decl   0x10(%ebp)
  801525:	ff 45 08             	incl   0x8(%ebp)
  801528:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80152b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80152f:	74 17                	je     801548 <strncmp+0x2b>
  801531:	8b 45 08             	mov    0x8(%ebp),%eax
  801534:	8a 00                	mov    (%eax),%al
  801536:	84 c0                	test   %al,%al
  801538:	74 0e                	je     801548 <strncmp+0x2b>
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8a 10                	mov    (%eax),%dl
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	8a 00                	mov    (%eax),%al
  801544:	38 c2                	cmp    %al,%dl
  801546:	74 da                	je     801522 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  801548:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80154c:	75 07                	jne    801555 <strncmp+0x38>
		return 0;
  80154e:	b8 00 00 00 00       	mov    $0x0,%eax
  801553:	eb 14                	jmp    801569 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  801555:	8b 45 08             	mov    0x8(%ebp),%eax
  801558:	8a 00                	mov    (%eax),%al
  80155a:	0f b6 d0             	movzbl %al,%edx
  80155d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801560:	8a 00                	mov    (%eax),%al
  801562:	0f b6 c0             	movzbl %al,%eax
  801565:	29 c2                	sub    %eax,%edx
  801567:	89 d0                	mov    %edx,%eax
}
  801569:	5d                   	pop    %ebp
  80156a:	c3                   	ret    

0080156b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  80156b:	55                   	push   %ebp
  80156c:	89 e5                	mov    %esp,%ebp
  80156e:	83 ec 04             	sub    $0x4,%esp
  801571:	8b 45 0c             	mov    0xc(%ebp),%eax
  801574:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801577:	eb 12                	jmp    80158b <strchr+0x20>
		if (*s == c)
  801579:	8b 45 08             	mov    0x8(%ebp),%eax
  80157c:	8a 00                	mov    (%eax),%al
  80157e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801581:	75 05                	jne    801588 <strchr+0x1d>
			return (char *) s;
  801583:	8b 45 08             	mov    0x8(%ebp),%eax
  801586:	eb 11                	jmp    801599 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801588:	ff 45 08             	incl   0x8(%ebp)
  80158b:	8b 45 08             	mov    0x8(%ebp),%eax
  80158e:	8a 00                	mov    (%eax),%al
  801590:	84 c0                	test   %al,%al
  801592:	75 e5                	jne    801579 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801594:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 04             	sub    $0x4,%esp
  8015a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8015a7:	eb 0d                	jmp    8015b6 <strfind+0x1b>
		if (*s == c)
  8015a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ac:	8a 00                	mov    (%eax),%al
  8015ae:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015b1:	74 0e                	je     8015c1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015b3:	ff 45 08             	incl   0x8(%ebp)
  8015b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b9:	8a 00                	mov    (%eax),%al
  8015bb:	84 c0                	test   %al,%al
  8015bd:	75 ea                	jne    8015a9 <strfind+0xe>
  8015bf:	eb 01                	jmp    8015c2 <strfind+0x27>
		if (*s == c)
			break;
  8015c1:	90                   	nop
	return (char *) s;
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c5:	c9                   	leave  
  8015c6:	c3                   	ret    

008015c7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015c7:	55                   	push   %ebp
  8015c8:	89 e5                	mov    %esp,%ebp
  8015ca:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8015d6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015d9:	eb 0e                	jmp    8015e9 <memset+0x22>
		*p++ = c;
  8015db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015de:	8d 50 01             	lea    0x1(%eax),%edx
  8015e1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015e4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015e9:	ff 4d f8             	decl   -0x8(%ebp)
  8015ec:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015f0:	79 e9                	jns    8015db <memset+0x14>
		*p++ = c;

	return v;
  8015f2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
  8015fa:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801600:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801603:	8b 45 08             	mov    0x8(%ebp),%eax
  801606:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801609:	eb 16                	jmp    801621 <memcpy+0x2a>
		*d++ = *s++;
  80160b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80160e:	8d 50 01             	lea    0x1(%eax),%edx
  801611:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801614:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801617:	8d 4a 01             	lea    0x1(%edx),%ecx
  80161a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80161d:	8a 12                	mov    (%edx),%dl
  80161f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801621:	8b 45 10             	mov    0x10(%ebp),%eax
  801624:	8d 50 ff             	lea    -0x1(%eax),%edx
  801627:	89 55 10             	mov    %edx,0x10(%ebp)
  80162a:	85 c0                	test   %eax,%eax
  80162c:	75 dd                	jne    80160b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80162e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801631:	c9                   	leave  
  801632:	c3                   	ret    

00801633 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801633:	55                   	push   %ebp
  801634:	89 e5                	mov    %esp,%ebp
  801636:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801639:	8b 45 0c             	mov    0xc(%ebp),%eax
  80163c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801645:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801648:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80164b:	73 50                	jae    80169d <memmove+0x6a>
  80164d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801650:	8b 45 10             	mov    0x10(%ebp),%eax
  801653:	01 d0                	add    %edx,%eax
  801655:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801658:	76 43                	jbe    80169d <memmove+0x6a>
		s += n;
  80165a:	8b 45 10             	mov    0x10(%ebp),%eax
  80165d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801660:	8b 45 10             	mov    0x10(%ebp),%eax
  801663:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801666:	eb 10                	jmp    801678 <memmove+0x45>
			*--d = *--s;
  801668:	ff 4d f8             	decl   -0x8(%ebp)
  80166b:	ff 4d fc             	decl   -0x4(%ebp)
  80166e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801671:	8a 10                	mov    (%eax),%dl
  801673:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801676:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801678:	8b 45 10             	mov    0x10(%ebp),%eax
  80167b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80167e:	89 55 10             	mov    %edx,0x10(%ebp)
  801681:	85 c0                	test   %eax,%eax
  801683:	75 e3                	jne    801668 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801685:	eb 23                	jmp    8016aa <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801687:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80168a:	8d 50 01             	lea    0x1(%eax),%edx
  80168d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801690:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801693:	8d 4a 01             	lea    0x1(%edx),%ecx
  801696:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801699:	8a 12                	mov    (%edx),%dl
  80169b:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  80169d:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016a3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016a6:	85 c0                	test   %eax,%eax
  8016a8:	75 dd                	jne    801687 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
  8016b2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016be:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016c1:	eb 2a                	jmp    8016ed <memcmp+0x3e>
		if (*s1 != *s2)
  8016c3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c6:	8a 10                	mov    (%eax),%dl
  8016c8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016cb:	8a 00                	mov    (%eax),%al
  8016cd:	38 c2                	cmp    %al,%dl
  8016cf:	74 16                	je     8016e7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016d4:	8a 00                	mov    (%eax),%al
  8016d6:	0f b6 d0             	movzbl %al,%edx
  8016d9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016dc:	8a 00                	mov    (%eax),%al
  8016de:	0f b6 c0             	movzbl %al,%eax
  8016e1:	29 c2                	sub    %eax,%edx
  8016e3:	89 d0                	mov    %edx,%eax
  8016e5:	eb 18                	jmp    8016ff <memcmp+0x50>
		s1++, s2++;
  8016e7:	ff 45 fc             	incl   -0x4(%ebp)
  8016ea:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016f3:	89 55 10             	mov    %edx,0x10(%ebp)
  8016f6:	85 c0                	test   %eax,%eax
  8016f8:	75 c9                	jne    8016c3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
  801704:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801707:	8b 55 08             	mov    0x8(%ebp),%edx
  80170a:	8b 45 10             	mov    0x10(%ebp),%eax
  80170d:	01 d0                	add    %edx,%eax
  80170f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801712:	eb 15                	jmp    801729 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801714:	8b 45 08             	mov    0x8(%ebp),%eax
  801717:	8a 00                	mov    (%eax),%al
  801719:	0f b6 d0             	movzbl %al,%edx
  80171c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80171f:	0f b6 c0             	movzbl %al,%eax
  801722:	39 c2                	cmp    %eax,%edx
  801724:	74 0d                	je     801733 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801726:	ff 45 08             	incl   0x8(%ebp)
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
  80172c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80172f:	72 e3                	jb     801714 <memfind+0x13>
  801731:	eb 01                	jmp    801734 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801733:	90                   	nop
	return (void *) s;
  801734:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801737:	c9                   	leave  
  801738:	c3                   	ret    

00801739 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801739:	55                   	push   %ebp
  80173a:	89 e5                	mov    %esp,%ebp
  80173c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80173f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801746:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80174d:	eb 03                	jmp    801752 <strtol+0x19>
		s++;
  80174f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801752:	8b 45 08             	mov    0x8(%ebp),%eax
  801755:	8a 00                	mov    (%eax),%al
  801757:	3c 20                	cmp    $0x20,%al
  801759:	74 f4                	je     80174f <strtol+0x16>
  80175b:	8b 45 08             	mov    0x8(%ebp),%eax
  80175e:	8a 00                	mov    (%eax),%al
  801760:	3c 09                	cmp    $0x9,%al
  801762:	74 eb                	je     80174f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801764:	8b 45 08             	mov    0x8(%ebp),%eax
  801767:	8a 00                	mov    (%eax),%al
  801769:	3c 2b                	cmp    $0x2b,%al
  80176b:	75 05                	jne    801772 <strtol+0x39>
		s++;
  80176d:	ff 45 08             	incl   0x8(%ebp)
  801770:	eb 13                	jmp    801785 <strtol+0x4c>
	else if (*s == '-')
  801772:	8b 45 08             	mov    0x8(%ebp),%eax
  801775:	8a 00                	mov    (%eax),%al
  801777:	3c 2d                	cmp    $0x2d,%al
  801779:	75 0a                	jne    801785 <strtol+0x4c>
		s++, neg = 1;
  80177b:	ff 45 08             	incl   0x8(%ebp)
  80177e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801785:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801789:	74 06                	je     801791 <strtol+0x58>
  80178b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80178f:	75 20                	jne    8017b1 <strtol+0x78>
  801791:	8b 45 08             	mov    0x8(%ebp),%eax
  801794:	8a 00                	mov    (%eax),%al
  801796:	3c 30                	cmp    $0x30,%al
  801798:	75 17                	jne    8017b1 <strtol+0x78>
  80179a:	8b 45 08             	mov    0x8(%ebp),%eax
  80179d:	40                   	inc    %eax
  80179e:	8a 00                	mov    (%eax),%al
  8017a0:	3c 78                	cmp    $0x78,%al
  8017a2:	75 0d                	jne    8017b1 <strtol+0x78>
		s += 2, base = 16;
  8017a4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8017a8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017af:	eb 28                	jmp    8017d9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017b1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017b5:	75 15                	jne    8017cc <strtol+0x93>
  8017b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ba:	8a 00                	mov    (%eax),%al
  8017bc:	3c 30                	cmp    $0x30,%al
  8017be:	75 0c                	jne    8017cc <strtol+0x93>
		s++, base = 8;
  8017c0:	ff 45 08             	incl   0x8(%ebp)
  8017c3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017ca:	eb 0d                	jmp    8017d9 <strtol+0xa0>
	else if (base == 0)
  8017cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017d0:	75 07                	jne    8017d9 <strtol+0xa0>
		base = 10;
  8017d2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017dc:	8a 00                	mov    (%eax),%al
  8017de:	3c 2f                	cmp    $0x2f,%al
  8017e0:	7e 19                	jle    8017fb <strtol+0xc2>
  8017e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e5:	8a 00                	mov    (%eax),%al
  8017e7:	3c 39                	cmp    $0x39,%al
  8017e9:	7f 10                	jg     8017fb <strtol+0xc2>
			dig = *s - '0';
  8017eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ee:	8a 00                	mov    (%eax),%al
  8017f0:	0f be c0             	movsbl %al,%eax
  8017f3:	83 e8 30             	sub    $0x30,%eax
  8017f6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017f9:	eb 42                	jmp    80183d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	8a 00                	mov    (%eax),%al
  801800:	3c 60                	cmp    $0x60,%al
  801802:	7e 19                	jle    80181d <strtol+0xe4>
  801804:	8b 45 08             	mov    0x8(%ebp),%eax
  801807:	8a 00                	mov    (%eax),%al
  801809:	3c 7a                	cmp    $0x7a,%al
  80180b:	7f 10                	jg     80181d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80180d:	8b 45 08             	mov    0x8(%ebp),%eax
  801810:	8a 00                	mov    (%eax),%al
  801812:	0f be c0             	movsbl %al,%eax
  801815:	83 e8 57             	sub    $0x57,%eax
  801818:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80181b:	eb 20                	jmp    80183d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80181d:	8b 45 08             	mov    0x8(%ebp),%eax
  801820:	8a 00                	mov    (%eax),%al
  801822:	3c 40                	cmp    $0x40,%al
  801824:	7e 39                	jle    80185f <strtol+0x126>
  801826:	8b 45 08             	mov    0x8(%ebp),%eax
  801829:	8a 00                	mov    (%eax),%al
  80182b:	3c 5a                	cmp    $0x5a,%al
  80182d:	7f 30                	jg     80185f <strtol+0x126>
			dig = *s - 'A' + 10;
  80182f:	8b 45 08             	mov    0x8(%ebp),%eax
  801832:	8a 00                	mov    (%eax),%al
  801834:	0f be c0             	movsbl %al,%eax
  801837:	83 e8 37             	sub    $0x37,%eax
  80183a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80183d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801840:	3b 45 10             	cmp    0x10(%ebp),%eax
  801843:	7d 19                	jge    80185e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801845:	ff 45 08             	incl   0x8(%ebp)
  801848:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80184b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80184f:	89 c2                	mov    %eax,%edx
  801851:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801854:	01 d0                	add    %edx,%eax
  801856:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801859:	e9 7b ff ff ff       	jmp    8017d9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80185e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80185f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801863:	74 08                	je     80186d <strtol+0x134>
		*endptr = (char *) s;
  801865:	8b 45 0c             	mov    0xc(%ebp),%eax
  801868:	8b 55 08             	mov    0x8(%ebp),%edx
  80186b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80186d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801871:	74 07                	je     80187a <strtol+0x141>
  801873:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801876:	f7 d8                	neg    %eax
  801878:	eb 03                	jmp    80187d <strtol+0x144>
  80187a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80187d:	c9                   	leave  
  80187e:	c3                   	ret    

0080187f <ltostr>:

void
ltostr(long value, char *str)
{
  80187f:	55                   	push   %ebp
  801880:	89 e5                	mov    %esp,%ebp
  801882:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801885:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80188c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801893:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801897:	79 13                	jns    8018ac <ltostr+0x2d>
	{
		neg = 1;
  801899:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8018a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018a3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8018a6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8018a9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8018af:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018b4:	99                   	cltd   
  8018b5:	f7 f9                	idiv   %ecx
  8018b7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018ba:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018bd:	8d 50 01             	lea    0x1(%eax),%edx
  8018c0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018c3:	89 c2                	mov    %eax,%edx
  8018c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018c8:	01 d0                	add    %edx,%eax
  8018ca:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018cd:	83 c2 30             	add    $0x30,%edx
  8018d0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018d2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018d5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018da:	f7 e9                	imul   %ecx
  8018dc:	c1 fa 02             	sar    $0x2,%edx
  8018df:	89 c8                	mov    %ecx,%eax
  8018e1:	c1 f8 1f             	sar    $0x1f,%eax
  8018e4:	29 c2                	sub    %eax,%edx
  8018e6:	89 d0                	mov    %edx,%eax
  8018e8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018eb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ee:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018f3:	f7 e9                	imul   %ecx
  8018f5:	c1 fa 02             	sar    $0x2,%edx
  8018f8:	89 c8                	mov    %ecx,%eax
  8018fa:	c1 f8 1f             	sar    $0x1f,%eax
  8018fd:	29 c2                	sub    %eax,%edx
  8018ff:	89 d0                	mov    %edx,%eax
  801901:	c1 e0 02             	shl    $0x2,%eax
  801904:	01 d0                	add    %edx,%eax
  801906:	01 c0                	add    %eax,%eax
  801908:	29 c1                	sub    %eax,%ecx
  80190a:	89 ca                	mov    %ecx,%edx
  80190c:	85 d2                	test   %edx,%edx
  80190e:	75 9c                	jne    8018ac <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801910:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801917:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80191a:	48                   	dec    %eax
  80191b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80191e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801922:	74 3d                	je     801961 <ltostr+0xe2>
		start = 1 ;
  801924:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80192b:	eb 34                	jmp    801961 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80192d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801930:	8b 45 0c             	mov    0xc(%ebp),%eax
  801933:	01 d0                	add    %edx,%eax
  801935:	8a 00                	mov    (%eax),%al
  801937:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80193a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80193d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801940:	01 c2                	add    %eax,%edx
  801942:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801945:	8b 45 0c             	mov    0xc(%ebp),%eax
  801948:	01 c8                	add    %ecx,%eax
  80194a:	8a 00                	mov    (%eax),%al
  80194c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80194e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801951:	8b 45 0c             	mov    0xc(%ebp),%eax
  801954:	01 c2                	add    %eax,%edx
  801956:	8a 45 eb             	mov    -0x15(%ebp),%al
  801959:	88 02                	mov    %al,(%edx)
		start++ ;
  80195b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80195e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801961:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801964:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801967:	7c c4                	jl     80192d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801969:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80196c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196f:	01 d0                	add    %edx,%eax
  801971:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801974:	90                   	nop
  801975:	c9                   	leave  
  801976:	c3                   	ret    

00801977 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801977:	55                   	push   %ebp
  801978:	89 e5                	mov    %esp,%ebp
  80197a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80197d:	ff 75 08             	pushl  0x8(%ebp)
  801980:	e8 54 fa ff ff       	call   8013d9 <strlen>
  801985:	83 c4 04             	add    $0x4,%esp
  801988:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80198b:	ff 75 0c             	pushl  0xc(%ebp)
  80198e:	e8 46 fa ff ff       	call   8013d9 <strlen>
  801993:	83 c4 04             	add    $0x4,%esp
  801996:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801999:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8019a0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8019a7:	eb 17                	jmp    8019c0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8019a9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8019af:	01 c2                	add    %eax,%edx
  8019b1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b7:	01 c8                	add    %ecx,%eax
  8019b9:	8a 00                	mov    (%eax),%al
  8019bb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019bd:	ff 45 fc             	incl   -0x4(%ebp)
  8019c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019c3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019c6:	7c e1                	jl     8019a9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019d6:	eb 1f                	jmp    8019f7 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019db:	8d 50 01             	lea    0x1(%eax),%edx
  8019de:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019e1:	89 c2                	mov    %eax,%edx
  8019e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8019e6:	01 c2                	add    %eax,%edx
  8019e8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019eb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019ee:	01 c8                	add    %ecx,%eax
  8019f0:	8a 00                	mov    (%eax),%al
  8019f2:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019f4:	ff 45 f8             	incl   -0x8(%ebp)
  8019f7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019fa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019fd:	7c d9                	jl     8019d8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019ff:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801a02:	8b 45 10             	mov    0x10(%ebp),%eax
  801a05:	01 d0                	add    %edx,%eax
  801a07:	c6 00 00             	movb   $0x0,(%eax)
}
  801a0a:	90                   	nop
  801a0b:	c9                   	leave  
  801a0c:	c3                   	ret    

00801a0d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a0d:	55                   	push   %ebp
  801a0e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a10:	8b 45 14             	mov    0x14(%ebp),%eax
  801a13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a19:	8b 45 14             	mov    0x14(%ebp),%eax
  801a1c:	8b 00                	mov    (%eax),%eax
  801a1e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a25:	8b 45 10             	mov    0x10(%ebp),%eax
  801a28:	01 d0                	add    %edx,%eax
  801a2a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a30:	eb 0c                	jmp    801a3e <strsplit+0x31>
			*string++ = 0;
  801a32:	8b 45 08             	mov    0x8(%ebp),%eax
  801a35:	8d 50 01             	lea    0x1(%eax),%edx
  801a38:	89 55 08             	mov    %edx,0x8(%ebp)
  801a3b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a3e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a41:	8a 00                	mov    (%eax),%al
  801a43:	84 c0                	test   %al,%al
  801a45:	74 18                	je     801a5f <strsplit+0x52>
  801a47:	8b 45 08             	mov    0x8(%ebp),%eax
  801a4a:	8a 00                	mov    (%eax),%al
  801a4c:	0f be c0             	movsbl %al,%eax
  801a4f:	50                   	push   %eax
  801a50:	ff 75 0c             	pushl  0xc(%ebp)
  801a53:	e8 13 fb ff ff       	call   80156b <strchr>
  801a58:	83 c4 08             	add    $0x8,%esp
  801a5b:	85 c0                	test   %eax,%eax
  801a5d:	75 d3                	jne    801a32 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a5f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a62:	8a 00                	mov    (%eax),%al
  801a64:	84 c0                	test   %al,%al
  801a66:	74 5a                	je     801ac2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a68:	8b 45 14             	mov    0x14(%ebp),%eax
  801a6b:	8b 00                	mov    (%eax),%eax
  801a6d:	83 f8 0f             	cmp    $0xf,%eax
  801a70:	75 07                	jne    801a79 <strsplit+0x6c>
		{
			return 0;
  801a72:	b8 00 00 00 00       	mov    $0x0,%eax
  801a77:	eb 66                	jmp    801adf <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a79:	8b 45 14             	mov    0x14(%ebp),%eax
  801a7c:	8b 00                	mov    (%eax),%eax
  801a7e:	8d 48 01             	lea    0x1(%eax),%ecx
  801a81:	8b 55 14             	mov    0x14(%ebp),%edx
  801a84:	89 0a                	mov    %ecx,(%edx)
  801a86:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a8d:	8b 45 10             	mov    0x10(%ebp),%eax
  801a90:	01 c2                	add    %eax,%edx
  801a92:	8b 45 08             	mov    0x8(%ebp),%eax
  801a95:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a97:	eb 03                	jmp    801a9c <strsplit+0x8f>
			string++;
  801a99:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9f:	8a 00                	mov    (%eax),%al
  801aa1:	84 c0                	test   %al,%al
  801aa3:	74 8b                	je     801a30 <strsplit+0x23>
  801aa5:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa8:	8a 00                	mov    (%eax),%al
  801aaa:	0f be c0             	movsbl %al,%eax
  801aad:	50                   	push   %eax
  801aae:	ff 75 0c             	pushl  0xc(%ebp)
  801ab1:	e8 b5 fa ff ff       	call   80156b <strchr>
  801ab6:	83 c4 08             	add    $0x8,%esp
  801ab9:	85 c0                	test   %eax,%eax
  801abb:	74 dc                	je     801a99 <strsplit+0x8c>
			string++;
	}
  801abd:	e9 6e ff ff ff       	jmp    801a30 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ac2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  801ac6:	8b 00                	mov    (%eax),%eax
  801ac8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801acf:	8b 45 10             	mov    0x10(%ebp),%eax
  801ad2:	01 d0                	add    %edx,%eax
  801ad4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801ada:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801adf:	c9                   	leave  
  801ae0:	c3                   	ret    

00801ae1 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801ae1:	55                   	push   %ebp
  801ae2:	89 e5                	mov    %esp,%ebp
  801ae4:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801ae7:	a1 04 50 80 00       	mov    0x805004,%eax
  801aec:	85 c0                	test   %eax,%eax
  801aee:	74 1f                	je     801b0f <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801af0:	e8 1d 00 00 00       	call   801b12 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801af5:	83 ec 0c             	sub    $0xc,%esp
  801af8:	68 a4 42 80 00       	push   $0x8042a4
  801afd:	e8 4f f0 ff ff       	call   800b51 <cprintf>
  801b02:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801b05:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801b0c:	00 00 00 
	}
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
  801b15:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801b18:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801b1f:	00 00 00 
  801b22:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801b29:	00 00 00 
  801b2c:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801b33:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801b36:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801b3d:	00 00 00 
  801b40:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801b47:	00 00 00 
  801b4a:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801b51:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801b54:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801b5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b5e:	c1 e8 0c             	shr    $0xc,%eax
  801b61:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801b66:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801b6d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b70:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801b75:	2d 00 10 00 00       	sub    $0x1000,%eax
  801b7a:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801b7f:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801b86:	a1 20 51 80 00       	mov    0x805120,%eax
  801b8b:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801b8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801b92:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801b99:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801b9c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801b9f:	01 d0                	add    %edx,%eax
  801ba1:	48                   	dec    %eax
  801ba2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801ba5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801ba8:	ba 00 00 00 00       	mov    $0x0,%edx
  801bad:	f7 75 e4             	divl   -0x1c(%ebp)
  801bb0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801bb3:	29 d0                	sub    %edx,%eax
  801bb5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801bb8:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801bbf:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801bc2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801bc7:	2d 00 10 00 00       	sub    $0x1000,%eax
  801bcc:	83 ec 04             	sub    $0x4,%esp
  801bcf:	6a 07                	push   $0x7
  801bd1:	ff 75 e8             	pushl  -0x18(%ebp)
  801bd4:	50                   	push   %eax
  801bd5:	e8 3d 06 00 00       	call   802217 <sys_allocate_chunk>
  801bda:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801bdd:	a1 20 51 80 00       	mov    0x805120,%eax
  801be2:	83 ec 0c             	sub    $0xc,%esp
  801be5:	50                   	push   %eax
  801be6:	e8 b2 0c 00 00       	call   80289d <initialize_MemBlocksList>
  801beb:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801bee:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801bf3:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801bf6:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801bfa:	0f 84 f3 00 00 00    	je     801cf3 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801c00:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801c04:	75 14                	jne    801c1a <initialize_dyn_block_system+0x108>
  801c06:	83 ec 04             	sub    $0x4,%esp
  801c09:	68 c9 42 80 00       	push   $0x8042c9
  801c0e:	6a 36                	push   $0x36
  801c10:	68 e7 42 80 00       	push   $0x8042e7
  801c15:	e8 83 ec ff ff       	call   80089d <_panic>
  801c1a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c1d:	8b 00                	mov    (%eax),%eax
  801c1f:	85 c0                	test   %eax,%eax
  801c21:	74 10                	je     801c33 <initialize_dyn_block_system+0x121>
  801c23:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c26:	8b 00                	mov    (%eax),%eax
  801c28:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c2b:	8b 52 04             	mov    0x4(%edx),%edx
  801c2e:	89 50 04             	mov    %edx,0x4(%eax)
  801c31:	eb 0b                	jmp    801c3e <initialize_dyn_block_system+0x12c>
  801c33:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c36:	8b 40 04             	mov    0x4(%eax),%eax
  801c39:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801c3e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c41:	8b 40 04             	mov    0x4(%eax),%eax
  801c44:	85 c0                	test   %eax,%eax
  801c46:	74 0f                	je     801c57 <initialize_dyn_block_system+0x145>
  801c48:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c4b:	8b 40 04             	mov    0x4(%eax),%eax
  801c4e:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801c51:	8b 12                	mov    (%edx),%edx
  801c53:	89 10                	mov    %edx,(%eax)
  801c55:	eb 0a                	jmp    801c61 <initialize_dyn_block_system+0x14f>
  801c57:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c5a:	8b 00                	mov    (%eax),%eax
  801c5c:	a3 48 51 80 00       	mov    %eax,0x805148
  801c61:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c64:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801c6a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c6d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801c74:	a1 54 51 80 00       	mov    0x805154,%eax
  801c79:	48                   	dec    %eax
  801c7a:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801c7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c82:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801c89:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801c8c:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801c93:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801c97:	75 14                	jne    801cad <initialize_dyn_block_system+0x19b>
  801c99:	83 ec 04             	sub    $0x4,%esp
  801c9c:	68 f4 42 80 00       	push   $0x8042f4
  801ca1:	6a 3e                	push   $0x3e
  801ca3:	68 e7 42 80 00       	push   $0x8042e7
  801ca8:	e8 f0 eb ff ff       	call   80089d <_panic>
  801cad:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801cb3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cb6:	89 10                	mov    %edx,(%eax)
  801cb8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cbb:	8b 00                	mov    (%eax),%eax
  801cbd:	85 c0                	test   %eax,%eax
  801cbf:	74 0d                	je     801cce <initialize_dyn_block_system+0x1bc>
  801cc1:	a1 38 51 80 00       	mov    0x805138,%eax
  801cc6:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801cc9:	89 50 04             	mov    %edx,0x4(%eax)
  801ccc:	eb 08                	jmp    801cd6 <initialize_dyn_block_system+0x1c4>
  801cce:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cd1:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801cd6:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801cd9:	a3 38 51 80 00       	mov    %eax,0x805138
  801cde:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ce1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ce8:	a1 44 51 80 00       	mov    0x805144,%eax
  801ced:	40                   	inc    %eax
  801cee:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801cf3:	90                   	nop
  801cf4:	c9                   	leave  
  801cf5:	c3                   	ret    

00801cf6 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801cf6:	55                   	push   %ebp
  801cf7:	89 e5                	mov    %esp,%ebp
  801cf9:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801cfc:	e8 e0 fd ff ff       	call   801ae1 <InitializeUHeap>
		if (size == 0) return NULL ;
  801d01:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801d05:	75 07                	jne    801d0e <malloc+0x18>
  801d07:	b8 00 00 00 00       	mov    $0x0,%eax
  801d0c:	eb 7f                	jmp    801d8d <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801d0e:	e8 d2 08 00 00       	call   8025e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d13:	85 c0                	test   %eax,%eax
  801d15:	74 71                	je     801d88 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801d17:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801d1e:	8b 55 08             	mov    0x8(%ebp),%edx
  801d21:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d24:	01 d0                	add    %edx,%eax
  801d26:	48                   	dec    %eax
  801d27:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801d2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d2d:	ba 00 00 00 00       	mov    $0x0,%edx
  801d32:	f7 75 f4             	divl   -0xc(%ebp)
  801d35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d38:	29 d0                	sub    %edx,%eax
  801d3a:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801d3d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801d44:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801d4b:	76 07                	jbe    801d54 <malloc+0x5e>
					return NULL ;
  801d4d:	b8 00 00 00 00       	mov    $0x0,%eax
  801d52:	eb 39                	jmp    801d8d <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801d54:	83 ec 0c             	sub    $0xc,%esp
  801d57:	ff 75 08             	pushl  0x8(%ebp)
  801d5a:	e8 e6 0d 00 00       	call   802b45 <alloc_block_FF>
  801d5f:	83 c4 10             	add    $0x10,%esp
  801d62:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801d65:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801d69:	74 16                	je     801d81 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801d6b:	83 ec 0c             	sub    $0xc,%esp
  801d6e:	ff 75 ec             	pushl  -0x14(%ebp)
  801d71:	e8 37 0c 00 00       	call   8029ad <insert_sorted_allocList>
  801d76:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801d79:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d7c:	8b 40 08             	mov    0x8(%eax),%eax
  801d7f:	eb 0c                	jmp    801d8d <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801d81:	b8 00 00 00 00       	mov    $0x0,%eax
  801d86:	eb 05                	jmp    801d8d <malloc+0x97>
				}
		}
	return 0;
  801d88:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d8d:	c9                   	leave  
  801d8e:	c3                   	ret    

00801d8f <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801d8f:	55                   	push   %ebp
  801d90:	89 e5                	mov    %esp,%ebp
  801d92:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801d95:	8b 45 08             	mov    0x8(%ebp),%eax
  801d98:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801d9b:	83 ec 08             	sub    $0x8,%esp
  801d9e:	ff 75 f4             	pushl  -0xc(%ebp)
  801da1:	68 40 50 80 00       	push   $0x805040
  801da6:	e8 cf 0b 00 00       	call   80297a <find_block>
  801dab:	83 c4 10             	add    $0x10,%esp
  801dae:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801db1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801db4:	8b 40 0c             	mov    0xc(%eax),%eax
  801db7:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801dba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801dbd:	8b 40 08             	mov    0x8(%eax),%eax
  801dc0:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801dc3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dc7:	0f 84 a1 00 00 00    	je     801e6e <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801dcd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801dd1:	75 17                	jne    801dea <free+0x5b>
  801dd3:	83 ec 04             	sub    $0x4,%esp
  801dd6:	68 c9 42 80 00       	push   $0x8042c9
  801ddb:	68 80 00 00 00       	push   $0x80
  801de0:	68 e7 42 80 00       	push   $0x8042e7
  801de5:	e8 b3 ea ff ff       	call   80089d <_panic>
  801dea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ded:	8b 00                	mov    (%eax),%eax
  801def:	85 c0                	test   %eax,%eax
  801df1:	74 10                	je     801e03 <free+0x74>
  801df3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801df6:	8b 00                	mov    (%eax),%eax
  801df8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801dfb:	8b 52 04             	mov    0x4(%edx),%edx
  801dfe:	89 50 04             	mov    %edx,0x4(%eax)
  801e01:	eb 0b                	jmp    801e0e <free+0x7f>
  801e03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e06:	8b 40 04             	mov    0x4(%eax),%eax
  801e09:	a3 44 50 80 00       	mov    %eax,0x805044
  801e0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e11:	8b 40 04             	mov    0x4(%eax),%eax
  801e14:	85 c0                	test   %eax,%eax
  801e16:	74 0f                	je     801e27 <free+0x98>
  801e18:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e1b:	8b 40 04             	mov    0x4(%eax),%eax
  801e1e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801e21:	8b 12                	mov    (%edx),%edx
  801e23:	89 10                	mov    %edx,(%eax)
  801e25:	eb 0a                	jmp    801e31 <free+0xa2>
  801e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e2a:	8b 00                	mov    (%eax),%eax
  801e2c:	a3 40 50 80 00       	mov    %eax,0x805040
  801e31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e34:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801e44:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801e49:	48                   	dec    %eax
  801e4a:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801e4f:	83 ec 0c             	sub    $0xc,%esp
  801e52:	ff 75 f0             	pushl  -0x10(%ebp)
  801e55:	e8 29 12 00 00       	call   803083 <insert_sorted_with_merge_freeList>
  801e5a:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801e5d:	83 ec 08             	sub    $0x8,%esp
  801e60:	ff 75 ec             	pushl  -0x14(%ebp)
  801e63:	ff 75 e8             	pushl  -0x18(%ebp)
  801e66:	e8 74 03 00 00       	call   8021df <sys_free_user_mem>
  801e6b:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801e6e:	90                   	nop
  801e6f:	c9                   	leave  
  801e70:	c3                   	ret    

00801e71 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801e71:	55                   	push   %ebp
  801e72:	89 e5                	mov    %esp,%ebp
  801e74:	83 ec 38             	sub    $0x38,%esp
  801e77:	8b 45 10             	mov    0x10(%ebp),%eax
  801e7a:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801e7d:	e8 5f fc ff ff       	call   801ae1 <InitializeUHeap>
	if (size == 0) return NULL ;
  801e82:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801e86:	75 0a                	jne    801e92 <smalloc+0x21>
  801e88:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8d:	e9 b2 00 00 00       	jmp    801f44 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801e92:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801e99:	76 0a                	jbe    801ea5 <smalloc+0x34>
		return NULL;
  801e9b:	b8 00 00 00 00       	mov    $0x0,%eax
  801ea0:	e9 9f 00 00 00       	jmp    801f44 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801ea5:	e8 3b 07 00 00       	call   8025e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801eaa:	85 c0                	test   %eax,%eax
  801eac:	0f 84 8d 00 00 00    	je     801f3f <smalloc+0xce>
	struct MemBlock *b = NULL;
  801eb2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801eb9:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801ec0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ec3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec6:	01 d0                	add    %edx,%eax
  801ec8:	48                   	dec    %eax
  801ec9:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801ecc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801ecf:	ba 00 00 00 00       	mov    $0x0,%edx
  801ed4:	f7 75 f0             	divl   -0x10(%ebp)
  801ed7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801eda:	29 d0                	sub    %edx,%eax
  801edc:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801edf:	83 ec 0c             	sub    $0xc,%esp
  801ee2:	ff 75 e8             	pushl  -0x18(%ebp)
  801ee5:	e8 5b 0c 00 00       	call   802b45 <alloc_block_FF>
  801eea:	83 c4 10             	add    $0x10,%esp
  801eed:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801ef0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ef4:	75 07                	jne    801efd <smalloc+0x8c>
			return NULL;
  801ef6:	b8 00 00 00 00       	mov    $0x0,%eax
  801efb:	eb 47                	jmp    801f44 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801efd:	83 ec 0c             	sub    $0xc,%esp
  801f00:	ff 75 f4             	pushl  -0xc(%ebp)
  801f03:	e8 a5 0a 00 00       	call   8029ad <insert_sorted_allocList>
  801f08:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801f0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f0e:	8b 40 08             	mov    0x8(%eax),%eax
  801f11:	89 c2                	mov    %eax,%edx
  801f13:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801f17:	52                   	push   %edx
  801f18:	50                   	push   %eax
  801f19:	ff 75 0c             	pushl  0xc(%ebp)
  801f1c:	ff 75 08             	pushl  0x8(%ebp)
  801f1f:	e8 46 04 00 00       	call   80236a <sys_createSharedObject>
  801f24:	83 c4 10             	add    $0x10,%esp
  801f27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801f2a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801f2e:	78 08                	js     801f38 <smalloc+0xc7>
		return (void *)b->sva;
  801f30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801f33:	8b 40 08             	mov    0x8(%eax),%eax
  801f36:	eb 0c                	jmp    801f44 <smalloc+0xd3>
		}else{
		return NULL;
  801f38:	b8 00 00 00 00       	mov    $0x0,%eax
  801f3d:	eb 05                	jmp    801f44 <smalloc+0xd3>
			}

	}return NULL;
  801f3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801f44:	c9                   	leave  
  801f45:	c3                   	ret    

00801f46 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801f46:	55                   	push   %ebp
  801f47:	89 e5                	mov    %esp,%ebp
  801f49:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f4c:	e8 90 fb ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801f51:	e8 8f 06 00 00       	call   8025e5 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801f56:	85 c0                	test   %eax,%eax
  801f58:	0f 84 ad 00 00 00    	je     80200b <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801f5e:	83 ec 08             	sub    $0x8,%esp
  801f61:	ff 75 0c             	pushl  0xc(%ebp)
  801f64:	ff 75 08             	pushl  0x8(%ebp)
  801f67:	e8 28 04 00 00       	call   802394 <sys_getSizeOfSharedObject>
  801f6c:	83 c4 10             	add    $0x10,%esp
  801f6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801f72:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801f76:	79 0a                	jns    801f82 <sget+0x3c>
    {
    	return NULL;
  801f78:	b8 00 00 00 00       	mov    $0x0,%eax
  801f7d:	e9 8e 00 00 00       	jmp    802010 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801f82:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801f89:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801f90:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801f93:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801f96:	01 d0                	add    %edx,%eax
  801f98:	48                   	dec    %eax
  801f99:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801f9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801f9f:	ba 00 00 00 00       	mov    $0x0,%edx
  801fa4:	f7 75 ec             	divl   -0x14(%ebp)
  801fa7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801faa:	29 d0                	sub    %edx,%eax
  801fac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801faf:	83 ec 0c             	sub    $0xc,%esp
  801fb2:	ff 75 e4             	pushl  -0x1c(%ebp)
  801fb5:	e8 8b 0b 00 00       	call   802b45 <alloc_block_FF>
  801fba:	83 c4 10             	add    $0x10,%esp
  801fbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801fc0:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801fc4:	75 07                	jne    801fcd <sget+0x87>
				return NULL;
  801fc6:	b8 00 00 00 00       	mov    $0x0,%eax
  801fcb:	eb 43                	jmp    802010 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801fcd:	83 ec 0c             	sub    $0xc,%esp
  801fd0:	ff 75 f0             	pushl  -0x10(%ebp)
  801fd3:	e8 d5 09 00 00       	call   8029ad <insert_sorted_allocList>
  801fd8:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801fdb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fde:	8b 40 08             	mov    0x8(%eax),%eax
  801fe1:	83 ec 04             	sub    $0x4,%esp
  801fe4:	50                   	push   %eax
  801fe5:	ff 75 0c             	pushl  0xc(%ebp)
  801fe8:	ff 75 08             	pushl  0x8(%ebp)
  801feb:	e8 c1 03 00 00       	call   8023b1 <sys_getSharedObject>
  801ff0:	83 c4 10             	add    $0x10,%esp
  801ff3:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801ff6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801ffa:	78 08                	js     802004 <sget+0xbe>
			return (void *)b->sva;
  801ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fff:	8b 40 08             	mov    0x8(%eax),%eax
  802002:	eb 0c                	jmp    802010 <sget+0xca>
			}else{
			return NULL;
  802004:	b8 00 00 00 00       	mov    $0x0,%eax
  802009:	eb 05                	jmp    802010 <sget+0xca>
			}
    }}return NULL;
  80200b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802010:	c9                   	leave  
  802011:	c3                   	ret    

00802012 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802012:	55                   	push   %ebp
  802013:	89 e5                	mov    %esp,%ebp
  802015:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802018:	e8 c4 fa ff ff       	call   801ae1 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  80201d:	83 ec 04             	sub    $0x4,%esp
  802020:	68 18 43 80 00       	push   $0x804318
  802025:	68 03 01 00 00       	push   $0x103
  80202a:	68 e7 42 80 00       	push   $0x8042e7
  80202f:	e8 69 e8 ff ff       	call   80089d <_panic>

00802034 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802034:	55                   	push   %ebp
  802035:	89 e5                	mov    %esp,%ebp
  802037:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80203a:	83 ec 04             	sub    $0x4,%esp
  80203d:	68 40 43 80 00       	push   $0x804340
  802042:	68 17 01 00 00       	push   $0x117
  802047:	68 e7 42 80 00       	push   $0x8042e7
  80204c:	e8 4c e8 ff ff       	call   80089d <_panic>

00802051 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802051:	55                   	push   %ebp
  802052:	89 e5                	mov    %esp,%ebp
  802054:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802057:	83 ec 04             	sub    $0x4,%esp
  80205a:	68 64 43 80 00       	push   $0x804364
  80205f:	68 22 01 00 00       	push   $0x122
  802064:	68 e7 42 80 00       	push   $0x8042e7
  802069:	e8 2f e8 ff ff       	call   80089d <_panic>

0080206e <shrink>:

}
void shrink(uint32 newSize)
{
  80206e:	55                   	push   %ebp
  80206f:	89 e5                	mov    %esp,%ebp
  802071:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802074:	83 ec 04             	sub    $0x4,%esp
  802077:	68 64 43 80 00       	push   $0x804364
  80207c:	68 27 01 00 00       	push   $0x127
  802081:	68 e7 42 80 00       	push   $0x8042e7
  802086:	e8 12 e8 ff ff       	call   80089d <_panic>

0080208b <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  80208b:	55                   	push   %ebp
  80208c:	89 e5                	mov    %esp,%ebp
  80208e:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802091:	83 ec 04             	sub    $0x4,%esp
  802094:	68 64 43 80 00       	push   $0x804364
  802099:	68 2c 01 00 00       	push   $0x12c
  80209e:	68 e7 42 80 00       	push   $0x8042e7
  8020a3:	e8 f5 e7 ff ff       	call   80089d <_panic>

008020a8 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8020a8:	55                   	push   %ebp
  8020a9:	89 e5                	mov    %esp,%ebp
  8020ab:	57                   	push   %edi
  8020ac:	56                   	push   %esi
  8020ad:	53                   	push   %ebx
  8020ae:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8020b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8020b4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020b7:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020ba:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020bd:	8b 7d 18             	mov    0x18(%ebp),%edi
  8020c0:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8020c3:	cd 30                	int    $0x30
  8020c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8020c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8020cb:	83 c4 10             	add    $0x10,%esp
  8020ce:	5b                   	pop    %ebx
  8020cf:	5e                   	pop    %esi
  8020d0:	5f                   	pop    %edi
  8020d1:	5d                   	pop    %ebp
  8020d2:	c3                   	ret    

008020d3 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8020d3:	55                   	push   %ebp
  8020d4:	89 e5                	mov    %esp,%ebp
  8020d6:	83 ec 04             	sub    $0x4,%esp
  8020d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8020dc:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8020df:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8020e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8020e6:	6a 00                	push   $0x0
  8020e8:	6a 00                	push   $0x0
  8020ea:	52                   	push   %edx
  8020eb:	ff 75 0c             	pushl  0xc(%ebp)
  8020ee:	50                   	push   %eax
  8020ef:	6a 00                	push   $0x0
  8020f1:	e8 b2 ff ff ff       	call   8020a8 <syscall>
  8020f6:	83 c4 18             	add    $0x18,%esp
}
  8020f9:	90                   	nop
  8020fa:	c9                   	leave  
  8020fb:	c3                   	ret    

008020fc <sys_cgetc>:

int
sys_cgetc(void)
{
  8020fc:	55                   	push   %ebp
  8020fd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8020ff:	6a 00                	push   $0x0
  802101:	6a 00                	push   $0x0
  802103:	6a 00                	push   $0x0
  802105:	6a 00                	push   $0x0
  802107:	6a 00                	push   $0x0
  802109:	6a 01                	push   $0x1
  80210b:	e8 98 ff ff ff       	call   8020a8 <syscall>
  802110:	83 c4 18             	add    $0x18,%esp
}
  802113:	c9                   	leave  
  802114:	c3                   	ret    

00802115 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  802115:	55                   	push   %ebp
  802116:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  802118:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211b:	8b 45 08             	mov    0x8(%ebp),%eax
  80211e:	6a 00                	push   $0x0
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	52                   	push   %edx
  802125:	50                   	push   %eax
  802126:	6a 05                	push   $0x5
  802128:	e8 7b ff ff ff       	call   8020a8 <syscall>
  80212d:	83 c4 18             	add    $0x18,%esp
}
  802130:	c9                   	leave  
  802131:	c3                   	ret    

00802132 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802132:	55                   	push   %ebp
  802133:	89 e5                	mov    %esp,%ebp
  802135:	56                   	push   %esi
  802136:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  802137:	8b 75 18             	mov    0x18(%ebp),%esi
  80213a:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80213d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802140:	8b 55 0c             	mov    0xc(%ebp),%edx
  802143:	8b 45 08             	mov    0x8(%ebp),%eax
  802146:	56                   	push   %esi
  802147:	53                   	push   %ebx
  802148:	51                   	push   %ecx
  802149:	52                   	push   %edx
  80214a:	50                   	push   %eax
  80214b:	6a 06                	push   $0x6
  80214d:	e8 56 ff ff ff       	call   8020a8 <syscall>
  802152:	83 c4 18             	add    $0x18,%esp
}
  802155:	8d 65 f8             	lea    -0x8(%ebp),%esp
  802158:	5b                   	pop    %ebx
  802159:	5e                   	pop    %esi
  80215a:	5d                   	pop    %ebp
  80215b:	c3                   	ret    

0080215c <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  80215c:	55                   	push   %ebp
  80215d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  80215f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802162:	8b 45 08             	mov    0x8(%ebp),%eax
  802165:	6a 00                	push   $0x0
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	52                   	push   %edx
  80216c:	50                   	push   %eax
  80216d:	6a 07                	push   $0x7
  80216f:	e8 34 ff ff ff       	call   8020a8 <syscall>
  802174:	83 c4 18             	add    $0x18,%esp
}
  802177:	c9                   	leave  
  802178:	c3                   	ret    

00802179 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802179:	55                   	push   %ebp
  80217a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  80217c:	6a 00                	push   $0x0
  80217e:	6a 00                	push   $0x0
  802180:	6a 00                	push   $0x0
  802182:	ff 75 0c             	pushl  0xc(%ebp)
  802185:	ff 75 08             	pushl  0x8(%ebp)
  802188:	6a 08                	push   $0x8
  80218a:	e8 19 ff ff ff       	call   8020a8 <syscall>
  80218f:	83 c4 18             	add    $0x18,%esp
}
  802192:	c9                   	leave  
  802193:	c3                   	ret    

00802194 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802194:	55                   	push   %ebp
  802195:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 00                	push   $0x0
  80219d:	6a 00                	push   $0x0
  80219f:	6a 00                	push   $0x0
  8021a1:	6a 09                	push   $0x9
  8021a3:	e8 00 ff ff ff       	call   8020a8 <syscall>
  8021a8:	83 c4 18             	add    $0x18,%esp
}
  8021ab:	c9                   	leave  
  8021ac:	c3                   	ret    

008021ad <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8021b0:	6a 00                	push   $0x0
  8021b2:	6a 00                	push   $0x0
  8021b4:	6a 00                	push   $0x0
  8021b6:	6a 00                	push   $0x0
  8021b8:	6a 00                	push   $0x0
  8021ba:	6a 0a                	push   $0xa
  8021bc:	e8 e7 fe ff ff       	call   8020a8 <syscall>
  8021c1:	83 c4 18             	add    $0x18,%esp
}
  8021c4:	c9                   	leave  
  8021c5:	c3                   	ret    

008021c6 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8021c6:	55                   	push   %ebp
  8021c7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8021c9:	6a 00                	push   $0x0
  8021cb:	6a 00                	push   $0x0
  8021cd:	6a 00                	push   $0x0
  8021cf:	6a 00                	push   $0x0
  8021d1:	6a 00                	push   $0x0
  8021d3:	6a 0b                	push   $0xb
  8021d5:	e8 ce fe ff ff       	call   8020a8 <syscall>
  8021da:	83 c4 18             	add    $0x18,%esp
}
  8021dd:	c9                   	leave  
  8021de:	c3                   	ret    

008021df <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8021df:	55                   	push   %ebp
  8021e0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8021e2:	6a 00                	push   $0x0
  8021e4:	6a 00                	push   $0x0
  8021e6:	6a 00                	push   $0x0
  8021e8:	ff 75 0c             	pushl  0xc(%ebp)
  8021eb:	ff 75 08             	pushl  0x8(%ebp)
  8021ee:	6a 0f                	push   $0xf
  8021f0:	e8 b3 fe ff ff       	call   8020a8 <syscall>
  8021f5:	83 c4 18             	add    $0x18,%esp
	return;
  8021f8:	90                   	nop
}
  8021f9:	c9                   	leave  
  8021fa:	c3                   	ret    

008021fb <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8021fb:	55                   	push   %ebp
  8021fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8021fe:	6a 00                	push   $0x0
  802200:	6a 00                	push   $0x0
  802202:	6a 00                	push   $0x0
  802204:	ff 75 0c             	pushl  0xc(%ebp)
  802207:	ff 75 08             	pushl  0x8(%ebp)
  80220a:	6a 10                	push   $0x10
  80220c:	e8 97 fe ff ff       	call   8020a8 <syscall>
  802211:	83 c4 18             	add    $0x18,%esp
	return ;
  802214:	90                   	nop
}
  802215:	c9                   	leave  
  802216:	c3                   	ret    

00802217 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  802217:	55                   	push   %ebp
  802218:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80221a:	6a 00                	push   $0x0
  80221c:	6a 00                	push   $0x0
  80221e:	ff 75 10             	pushl  0x10(%ebp)
  802221:	ff 75 0c             	pushl  0xc(%ebp)
  802224:	ff 75 08             	pushl  0x8(%ebp)
  802227:	6a 11                	push   $0x11
  802229:	e8 7a fe ff ff       	call   8020a8 <syscall>
  80222e:	83 c4 18             	add    $0x18,%esp
	return ;
  802231:	90                   	nop
}
  802232:	c9                   	leave  
  802233:	c3                   	ret    

00802234 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802234:	55                   	push   %ebp
  802235:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  802237:	6a 00                	push   $0x0
  802239:	6a 00                	push   $0x0
  80223b:	6a 00                	push   $0x0
  80223d:	6a 00                	push   $0x0
  80223f:	6a 00                	push   $0x0
  802241:	6a 0c                	push   $0xc
  802243:	e8 60 fe ff ff       	call   8020a8 <syscall>
  802248:	83 c4 18             	add    $0x18,%esp
}
  80224b:	c9                   	leave  
  80224c:	c3                   	ret    

0080224d <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  80224d:	55                   	push   %ebp
  80224e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 00                	push   $0x0
  802256:	6a 00                	push   $0x0
  802258:	ff 75 08             	pushl  0x8(%ebp)
  80225b:	6a 0d                	push   $0xd
  80225d:	e8 46 fe ff ff       	call   8020a8 <syscall>
  802262:	83 c4 18             	add    $0x18,%esp
}
  802265:	c9                   	leave  
  802266:	c3                   	ret    

00802267 <sys_scarce_memory>:

void sys_scarce_memory()
{
  802267:	55                   	push   %ebp
  802268:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 00                	push   $0x0
  802272:	6a 00                	push   $0x0
  802274:	6a 0e                	push   $0xe
  802276:	e8 2d fe ff ff       	call   8020a8 <syscall>
  80227b:	83 c4 18             	add    $0x18,%esp
}
  80227e:	90                   	nop
  80227f:	c9                   	leave  
  802280:	c3                   	ret    

00802281 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802281:	55                   	push   %ebp
  802282:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802284:	6a 00                	push   $0x0
  802286:	6a 00                	push   $0x0
  802288:	6a 00                	push   $0x0
  80228a:	6a 00                	push   $0x0
  80228c:	6a 00                	push   $0x0
  80228e:	6a 13                	push   $0x13
  802290:	e8 13 fe ff ff       	call   8020a8 <syscall>
  802295:	83 c4 18             	add    $0x18,%esp
}
  802298:	90                   	nop
  802299:	c9                   	leave  
  80229a:	c3                   	ret    

0080229b <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80229b:	55                   	push   %ebp
  80229c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 00                	push   $0x0
  8022a8:	6a 14                	push   $0x14
  8022aa:	e8 f9 fd ff ff       	call   8020a8 <syscall>
  8022af:	83 c4 18             	add    $0x18,%esp
}
  8022b2:	90                   	nop
  8022b3:	c9                   	leave  
  8022b4:	c3                   	ret    

008022b5 <sys_cputc>:


void
sys_cputc(const char c)
{
  8022b5:	55                   	push   %ebp
  8022b6:	89 e5                	mov    %esp,%ebp
  8022b8:	83 ec 04             	sub    $0x4,%esp
  8022bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8022be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8022c1:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8022c5:	6a 00                	push   $0x0
  8022c7:	6a 00                	push   $0x0
  8022c9:	6a 00                	push   $0x0
  8022cb:	6a 00                	push   $0x0
  8022cd:	50                   	push   %eax
  8022ce:	6a 15                	push   $0x15
  8022d0:	e8 d3 fd ff ff       	call   8020a8 <syscall>
  8022d5:	83 c4 18             	add    $0x18,%esp
}
  8022d8:	90                   	nop
  8022d9:	c9                   	leave  
  8022da:	c3                   	ret    

008022db <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8022db:	55                   	push   %ebp
  8022dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8022de:	6a 00                	push   $0x0
  8022e0:	6a 00                	push   $0x0
  8022e2:	6a 00                	push   $0x0
  8022e4:	6a 00                	push   $0x0
  8022e6:	6a 00                	push   $0x0
  8022e8:	6a 16                	push   $0x16
  8022ea:	e8 b9 fd ff ff       	call   8020a8 <syscall>
  8022ef:	83 c4 18             	add    $0x18,%esp
}
  8022f2:	90                   	nop
  8022f3:	c9                   	leave  
  8022f4:	c3                   	ret    

008022f5 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8022f5:	55                   	push   %ebp
  8022f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8022f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	ff 75 0c             	pushl  0xc(%ebp)
  802304:	50                   	push   %eax
  802305:	6a 17                	push   $0x17
  802307:	e8 9c fd ff ff       	call   8020a8 <syscall>
  80230c:	83 c4 18             	add    $0x18,%esp
}
  80230f:	c9                   	leave  
  802310:	c3                   	ret    

00802311 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802311:	55                   	push   %ebp
  802312:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802314:	8b 55 0c             	mov    0xc(%ebp),%edx
  802317:	8b 45 08             	mov    0x8(%ebp),%eax
  80231a:	6a 00                	push   $0x0
  80231c:	6a 00                	push   $0x0
  80231e:	6a 00                	push   $0x0
  802320:	52                   	push   %edx
  802321:	50                   	push   %eax
  802322:	6a 1a                	push   $0x1a
  802324:	e8 7f fd ff ff       	call   8020a8 <syscall>
  802329:	83 c4 18             	add    $0x18,%esp
}
  80232c:	c9                   	leave  
  80232d:	c3                   	ret    

0080232e <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80232e:	55                   	push   %ebp
  80232f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802331:	8b 55 0c             	mov    0xc(%ebp),%edx
  802334:	8b 45 08             	mov    0x8(%ebp),%eax
  802337:	6a 00                	push   $0x0
  802339:	6a 00                	push   $0x0
  80233b:	6a 00                	push   $0x0
  80233d:	52                   	push   %edx
  80233e:	50                   	push   %eax
  80233f:	6a 18                	push   $0x18
  802341:	e8 62 fd ff ff       	call   8020a8 <syscall>
  802346:	83 c4 18             	add    $0x18,%esp
}
  802349:	90                   	nop
  80234a:	c9                   	leave  
  80234b:	c3                   	ret    

0080234c <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  80234c:	55                   	push   %ebp
  80234d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80234f:	8b 55 0c             	mov    0xc(%ebp),%edx
  802352:	8b 45 08             	mov    0x8(%ebp),%eax
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	52                   	push   %edx
  80235c:	50                   	push   %eax
  80235d:	6a 19                	push   $0x19
  80235f:	e8 44 fd ff ff       	call   8020a8 <syscall>
  802364:	83 c4 18             	add    $0x18,%esp
}
  802367:	90                   	nop
  802368:	c9                   	leave  
  802369:	c3                   	ret    

0080236a <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80236a:	55                   	push   %ebp
  80236b:	89 e5                	mov    %esp,%ebp
  80236d:	83 ec 04             	sub    $0x4,%esp
  802370:	8b 45 10             	mov    0x10(%ebp),%eax
  802373:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  802376:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802379:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80237d:	8b 45 08             	mov    0x8(%ebp),%eax
  802380:	6a 00                	push   $0x0
  802382:	51                   	push   %ecx
  802383:	52                   	push   %edx
  802384:	ff 75 0c             	pushl  0xc(%ebp)
  802387:	50                   	push   %eax
  802388:	6a 1b                	push   $0x1b
  80238a:	e8 19 fd ff ff       	call   8020a8 <syscall>
  80238f:	83 c4 18             	add    $0x18,%esp
}
  802392:	c9                   	leave  
  802393:	c3                   	ret    

00802394 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802394:	55                   	push   %ebp
  802395:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802397:	8b 55 0c             	mov    0xc(%ebp),%edx
  80239a:	8b 45 08             	mov    0x8(%ebp),%eax
  80239d:	6a 00                	push   $0x0
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	52                   	push   %edx
  8023a4:	50                   	push   %eax
  8023a5:	6a 1c                	push   $0x1c
  8023a7:	e8 fc fc ff ff       	call   8020a8 <syscall>
  8023ac:	83 c4 18             	add    $0x18,%esp
}
  8023af:	c9                   	leave  
  8023b0:	c3                   	ret    

008023b1 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8023b1:	55                   	push   %ebp
  8023b2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8023b4:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8023b7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8023bd:	6a 00                	push   $0x0
  8023bf:	6a 00                	push   $0x0
  8023c1:	51                   	push   %ecx
  8023c2:	52                   	push   %edx
  8023c3:	50                   	push   %eax
  8023c4:	6a 1d                	push   $0x1d
  8023c6:	e8 dd fc ff ff       	call   8020a8 <syscall>
  8023cb:	83 c4 18             	add    $0x18,%esp
}
  8023ce:	c9                   	leave  
  8023cf:	c3                   	ret    

008023d0 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8023d0:	55                   	push   %ebp
  8023d1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8023d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8023d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8023d9:	6a 00                	push   $0x0
  8023db:	6a 00                	push   $0x0
  8023dd:	6a 00                	push   $0x0
  8023df:	52                   	push   %edx
  8023e0:	50                   	push   %eax
  8023e1:	6a 1e                	push   $0x1e
  8023e3:	e8 c0 fc ff ff       	call   8020a8 <syscall>
  8023e8:	83 c4 18             	add    $0x18,%esp
}
  8023eb:	c9                   	leave  
  8023ec:	c3                   	ret    

008023ed <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8023ed:	55                   	push   %ebp
  8023ee:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8023f0:	6a 00                	push   $0x0
  8023f2:	6a 00                	push   $0x0
  8023f4:	6a 00                	push   $0x0
  8023f6:	6a 00                	push   $0x0
  8023f8:	6a 00                	push   $0x0
  8023fa:	6a 1f                	push   $0x1f
  8023fc:	e8 a7 fc ff ff       	call   8020a8 <syscall>
  802401:	83 c4 18             	add    $0x18,%esp
}
  802404:	c9                   	leave  
  802405:	c3                   	ret    

00802406 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802406:	55                   	push   %ebp
  802407:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802409:	8b 45 08             	mov    0x8(%ebp),%eax
  80240c:	6a 00                	push   $0x0
  80240e:	ff 75 14             	pushl  0x14(%ebp)
  802411:	ff 75 10             	pushl  0x10(%ebp)
  802414:	ff 75 0c             	pushl  0xc(%ebp)
  802417:	50                   	push   %eax
  802418:	6a 20                	push   $0x20
  80241a:	e8 89 fc ff ff       	call   8020a8 <syscall>
  80241f:	83 c4 18             	add    $0x18,%esp
}
  802422:	c9                   	leave  
  802423:	c3                   	ret    

00802424 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802424:	55                   	push   %ebp
  802425:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  802427:	8b 45 08             	mov    0x8(%ebp),%eax
  80242a:	6a 00                	push   $0x0
  80242c:	6a 00                	push   $0x0
  80242e:	6a 00                	push   $0x0
  802430:	6a 00                	push   $0x0
  802432:	50                   	push   %eax
  802433:	6a 21                	push   $0x21
  802435:	e8 6e fc ff ff       	call   8020a8 <syscall>
  80243a:	83 c4 18             	add    $0x18,%esp
}
  80243d:	90                   	nop
  80243e:	c9                   	leave  
  80243f:	c3                   	ret    

00802440 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802440:	55                   	push   %ebp
  802441:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802443:	8b 45 08             	mov    0x8(%ebp),%eax
  802446:	6a 00                	push   $0x0
  802448:	6a 00                	push   $0x0
  80244a:	6a 00                	push   $0x0
  80244c:	6a 00                	push   $0x0
  80244e:	50                   	push   %eax
  80244f:	6a 22                	push   $0x22
  802451:	e8 52 fc ff ff       	call   8020a8 <syscall>
  802456:	83 c4 18             	add    $0x18,%esp
}
  802459:	c9                   	leave  
  80245a:	c3                   	ret    

0080245b <sys_getenvid>:

int32 sys_getenvid(void)
{
  80245b:	55                   	push   %ebp
  80245c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 00                	push   $0x0
  802464:	6a 00                	push   $0x0
  802466:	6a 00                	push   $0x0
  802468:	6a 02                	push   $0x2
  80246a:	e8 39 fc ff ff       	call   8020a8 <syscall>
  80246f:	83 c4 18             	add    $0x18,%esp
}
  802472:	c9                   	leave  
  802473:	c3                   	ret    

00802474 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802474:	55                   	push   %ebp
  802475:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802477:	6a 00                	push   $0x0
  802479:	6a 00                	push   $0x0
  80247b:	6a 00                	push   $0x0
  80247d:	6a 00                	push   $0x0
  80247f:	6a 00                	push   $0x0
  802481:	6a 03                	push   $0x3
  802483:	e8 20 fc ff ff       	call   8020a8 <syscall>
  802488:	83 c4 18             	add    $0x18,%esp
}
  80248b:	c9                   	leave  
  80248c:	c3                   	ret    

0080248d <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80248d:	55                   	push   %ebp
  80248e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802490:	6a 00                	push   $0x0
  802492:	6a 00                	push   $0x0
  802494:	6a 00                	push   $0x0
  802496:	6a 00                	push   $0x0
  802498:	6a 00                	push   $0x0
  80249a:	6a 04                	push   $0x4
  80249c:	e8 07 fc ff ff       	call   8020a8 <syscall>
  8024a1:	83 c4 18             	add    $0x18,%esp
}
  8024a4:	c9                   	leave  
  8024a5:	c3                   	ret    

008024a6 <sys_exit_env>:


void sys_exit_env(void)
{
  8024a6:	55                   	push   %ebp
  8024a7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 00                	push   $0x0
  8024b1:	6a 00                	push   $0x0
  8024b3:	6a 23                	push   $0x23
  8024b5:	e8 ee fb ff ff       	call   8020a8 <syscall>
  8024ba:	83 c4 18             	add    $0x18,%esp
}
  8024bd:	90                   	nop
  8024be:	c9                   	leave  
  8024bf:	c3                   	ret    

008024c0 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8024c0:	55                   	push   %ebp
  8024c1:	89 e5                	mov    %esp,%ebp
  8024c3:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8024c6:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024c9:	8d 50 04             	lea    0x4(%eax),%edx
  8024cc:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8024cf:	6a 00                	push   $0x0
  8024d1:	6a 00                	push   $0x0
  8024d3:	6a 00                	push   $0x0
  8024d5:	52                   	push   %edx
  8024d6:	50                   	push   %eax
  8024d7:	6a 24                	push   $0x24
  8024d9:	e8 ca fb ff ff       	call   8020a8 <syscall>
  8024de:	83 c4 18             	add    $0x18,%esp
	return result;
  8024e1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8024e4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8024e7:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8024ea:	89 01                	mov    %eax,(%ecx)
  8024ec:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8024ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8024f2:	c9                   	leave  
  8024f3:	c2 04 00             	ret    $0x4

008024f6 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8024f6:	55                   	push   %ebp
  8024f7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	ff 75 10             	pushl  0x10(%ebp)
  802500:	ff 75 0c             	pushl  0xc(%ebp)
  802503:	ff 75 08             	pushl  0x8(%ebp)
  802506:	6a 12                	push   $0x12
  802508:	e8 9b fb ff ff       	call   8020a8 <syscall>
  80250d:	83 c4 18             	add    $0x18,%esp
	return ;
  802510:	90                   	nop
}
  802511:	c9                   	leave  
  802512:	c3                   	ret    

00802513 <sys_rcr2>:
uint32 sys_rcr2()
{
  802513:	55                   	push   %ebp
  802514:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802516:	6a 00                	push   $0x0
  802518:	6a 00                	push   $0x0
  80251a:	6a 00                	push   $0x0
  80251c:	6a 00                	push   $0x0
  80251e:	6a 00                	push   $0x0
  802520:	6a 25                	push   $0x25
  802522:	e8 81 fb ff ff       	call   8020a8 <syscall>
  802527:	83 c4 18             	add    $0x18,%esp
}
  80252a:	c9                   	leave  
  80252b:	c3                   	ret    

0080252c <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  80252c:	55                   	push   %ebp
  80252d:	89 e5                	mov    %esp,%ebp
  80252f:	83 ec 04             	sub    $0x4,%esp
  802532:	8b 45 08             	mov    0x8(%ebp),%eax
  802535:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  802538:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  80253c:	6a 00                	push   $0x0
  80253e:	6a 00                	push   $0x0
  802540:	6a 00                	push   $0x0
  802542:	6a 00                	push   $0x0
  802544:	50                   	push   %eax
  802545:	6a 26                	push   $0x26
  802547:	e8 5c fb ff ff       	call   8020a8 <syscall>
  80254c:	83 c4 18             	add    $0x18,%esp
	return ;
  80254f:	90                   	nop
}
  802550:	c9                   	leave  
  802551:	c3                   	ret    

00802552 <rsttst>:
void rsttst()
{
  802552:	55                   	push   %ebp
  802553:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  802555:	6a 00                	push   $0x0
  802557:	6a 00                	push   $0x0
  802559:	6a 00                	push   $0x0
  80255b:	6a 00                	push   $0x0
  80255d:	6a 00                	push   $0x0
  80255f:	6a 28                	push   $0x28
  802561:	e8 42 fb ff ff       	call   8020a8 <syscall>
  802566:	83 c4 18             	add    $0x18,%esp
	return ;
  802569:	90                   	nop
}
  80256a:	c9                   	leave  
  80256b:	c3                   	ret    

0080256c <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  80256c:	55                   	push   %ebp
  80256d:	89 e5                	mov    %esp,%ebp
  80256f:	83 ec 04             	sub    $0x4,%esp
  802572:	8b 45 14             	mov    0x14(%ebp),%eax
  802575:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802578:	8b 55 18             	mov    0x18(%ebp),%edx
  80257b:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80257f:	52                   	push   %edx
  802580:	50                   	push   %eax
  802581:	ff 75 10             	pushl  0x10(%ebp)
  802584:	ff 75 0c             	pushl  0xc(%ebp)
  802587:	ff 75 08             	pushl  0x8(%ebp)
  80258a:	6a 27                	push   $0x27
  80258c:	e8 17 fb ff ff       	call   8020a8 <syscall>
  802591:	83 c4 18             	add    $0x18,%esp
	return ;
  802594:	90                   	nop
}
  802595:	c9                   	leave  
  802596:	c3                   	ret    

00802597 <chktst>:
void chktst(uint32 n)
{
  802597:	55                   	push   %ebp
  802598:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80259a:	6a 00                	push   $0x0
  80259c:	6a 00                	push   $0x0
  80259e:	6a 00                	push   $0x0
  8025a0:	6a 00                	push   $0x0
  8025a2:	ff 75 08             	pushl  0x8(%ebp)
  8025a5:	6a 29                	push   $0x29
  8025a7:	e8 fc fa ff ff       	call   8020a8 <syscall>
  8025ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8025af:	90                   	nop
}
  8025b0:	c9                   	leave  
  8025b1:	c3                   	ret    

008025b2 <inctst>:

void inctst()
{
  8025b2:	55                   	push   %ebp
  8025b3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8025b5:	6a 00                	push   $0x0
  8025b7:	6a 00                	push   $0x0
  8025b9:	6a 00                	push   $0x0
  8025bb:	6a 00                	push   $0x0
  8025bd:	6a 00                	push   $0x0
  8025bf:	6a 2a                	push   $0x2a
  8025c1:	e8 e2 fa ff ff       	call   8020a8 <syscall>
  8025c6:	83 c4 18             	add    $0x18,%esp
	return ;
  8025c9:	90                   	nop
}
  8025ca:	c9                   	leave  
  8025cb:	c3                   	ret    

008025cc <gettst>:
uint32 gettst()
{
  8025cc:	55                   	push   %ebp
  8025cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8025cf:	6a 00                	push   $0x0
  8025d1:	6a 00                	push   $0x0
  8025d3:	6a 00                	push   $0x0
  8025d5:	6a 00                	push   $0x0
  8025d7:	6a 00                	push   $0x0
  8025d9:	6a 2b                	push   $0x2b
  8025db:	e8 c8 fa ff ff       	call   8020a8 <syscall>
  8025e0:	83 c4 18             	add    $0x18,%esp
}
  8025e3:	c9                   	leave  
  8025e4:	c3                   	ret    

008025e5 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8025e5:	55                   	push   %ebp
  8025e6:	89 e5                	mov    %esp,%ebp
  8025e8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8025eb:	6a 00                	push   $0x0
  8025ed:	6a 00                	push   $0x0
  8025ef:	6a 00                	push   $0x0
  8025f1:	6a 00                	push   $0x0
  8025f3:	6a 00                	push   $0x0
  8025f5:	6a 2c                	push   $0x2c
  8025f7:	e8 ac fa ff ff       	call   8020a8 <syscall>
  8025fc:	83 c4 18             	add    $0x18,%esp
  8025ff:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802602:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802606:	75 07                	jne    80260f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802608:	b8 01 00 00 00       	mov    $0x1,%eax
  80260d:	eb 05                	jmp    802614 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80260f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802614:	c9                   	leave  
  802615:	c3                   	ret    

00802616 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802616:	55                   	push   %ebp
  802617:	89 e5                	mov    %esp,%ebp
  802619:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80261c:	6a 00                	push   $0x0
  80261e:	6a 00                	push   $0x0
  802620:	6a 00                	push   $0x0
  802622:	6a 00                	push   $0x0
  802624:	6a 00                	push   $0x0
  802626:	6a 2c                	push   $0x2c
  802628:	e8 7b fa ff ff       	call   8020a8 <syscall>
  80262d:	83 c4 18             	add    $0x18,%esp
  802630:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802633:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802637:	75 07                	jne    802640 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802639:	b8 01 00 00 00       	mov    $0x1,%eax
  80263e:	eb 05                	jmp    802645 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802640:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802645:	c9                   	leave  
  802646:	c3                   	ret    

00802647 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802647:	55                   	push   %ebp
  802648:	89 e5                	mov    %esp,%ebp
  80264a:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80264d:	6a 00                	push   $0x0
  80264f:	6a 00                	push   $0x0
  802651:	6a 00                	push   $0x0
  802653:	6a 00                	push   $0x0
  802655:	6a 00                	push   $0x0
  802657:	6a 2c                	push   $0x2c
  802659:	e8 4a fa ff ff       	call   8020a8 <syscall>
  80265e:	83 c4 18             	add    $0x18,%esp
  802661:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802664:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802668:	75 07                	jne    802671 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80266a:	b8 01 00 00 00       	mov    $0x1,%eax
  80266f:	eb 05                	jmp    802676 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802671:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802676:	c9                   	leave  
  802677:	c3                   	ret    

00802678 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802678:	55                   	push   %ebp
  802679:	89 e5                	mov    %esp,%ebp
  80267b:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80267e:	6a 00                	push   $0x0
  802680:	6a 00                	push   $0x0
  802682:	6a 00                	push   $0x0
  802684:	6a 00                	push   $0x0
  802686:	6a 00                	push   $0x0
  802688:	6a 2c                	push   $0x2c
  80268a:	e8 19 fa ff ff       	call   8020a8 <syscall>
  80268f:	83 c4 18             	add    $0x18,%esp
  802692:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802695:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802699:	75 07                	jne    8026a2 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  80269b:	b8 01 00 00 00       	mov    $0x1,%eax
  8026a0:	eb 05                	jmp    8026a7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8026a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8026a7:	c9                   	leave  
  8026a8:	c3                   	ret    

008026a9 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8026a9:	55                   	push   %ebp
  8026aa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8026ac:	6a 00                	push   $0x0
  8026ae:	6a 00                	push   $0x0
  8026b0:	6a 00                	push   $0x0
  8026b2:	6a 00                	push   $0x0
  8026b4:	ff 75 08             	pushl  0x8(%ebp)
  8026b7:	6a 2d                	push   $0x2d
  8026b9:	e8 ea f9 ff ff       	call   8020a8 <syscall>
  8026be:	83 c4 18             	add    $0x18,%esp
	return ;
  8026c1:	90                   	nop
}
  8026c2:	c9                   	leave  
  8026c3:	c3                   	ret    

008026c4 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8026c4:	55                   	push   %ebp
  8026c5:	89 e5                	mov    %esp,%ebp
  8026c7:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8026c8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8026cb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8026ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026d4:	6a 00                	push   $0x0
  8026d6:	53                   	push   %ebx
  8026d7:	51                   	push   %ecx
  8026d8:	52                   	push   %edx
  8026d9:	50                   	push   %eax
  8026da:	6a 2e                	push   $0x2e
  8026dc:	e8 c7 f9 ff ff       	call   8020a8 <syscall>
  8026e1:	83 c4 18             	add    $0x18,%esp
}
  8026e4:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8026e7:	c9                   	leave  
  8026e8:	c3                   	ret    

008026e9 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8026e9:	55                   	push   %ebp
  8026ea:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8026ec:	8b 55 0c             	mov    0xc(%ebp),%edx
  8026ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	52                   	push   %edx
  8026f9:	50                   	push   %eax
  8026fa:	6a 2f                	push   $0x2f
  8026fc:	e8 a7 f9 ff ff       	call   8020a8 <syscall>
  802701:	83 c4 18             	add    $0x18,%esp
}
  802704:	c9                   	leave  
  802705:	c3                   	ret    

00802706 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802706:	55                   	push   %ebp
  802707:	89 e5                	mov    %esp,%ebp
  802709:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  80270c:	83 ec 0c             	sub    $0xc,%esp
  80270f:	68 74 43 80 00       	push   $0x804374
  802714:	e8 38 e4 ff ff       	call   800b51 <cprintf>
  802719:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  80271c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802723:	83 ec 0c             	sub    $0xc,%esp
  802726:	68 a0 43 80 00       	push   $0x8043a0
  80272b:	e8 21 e4 ff ff       	call   800b51 <cprintf>
  802730:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802733:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802737:	a1 38 51 80 00       	mov    0x805138,%eax
  80273c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80273f:	eb 56                	jmp    802797 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802741:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802745:	74 1c                	je     802763 <print_mem_block_lists+0x5d>
  802747:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80274a:	8b 50 08             	mov    0x8(%eax),%edx
  80274d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802750:	8b 48 08             	mov    0x8(%eax),%ecx
  802753:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802756:	8b 40 0c             	mov    0xc(%eax),%eax
  802759:	01 c8                	add    %ecx,%eax
  80275b:	39 c2                	cmp    %eax,%edx
  80275d:	73 04                	jae    802763 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  80275f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802763:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802766:	8b 50 08             	mov    0x8(%eax),%edx
  802769:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80276c:	8b 40 0c             	mov    0xc(%eax),%eax
  80276f:	01 c2                	add    %eax,%edx
  802771:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802774:	8b 40 08             	mov    0x8(%eax),%eax
  802777:	83 ec 04             	sub    $0x4,%esp
  80277a:	52                   	push   %edx
  80277b:	50                   	push   %eax
  80277c:	68 b5 43 80 00       	push   $0x8043b5
  802781:	e8 cb e3 ff ff       	call   800b51 <cprintf>
  802786:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80278c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80278f:	a1 40 51 80 00       	mov    0x805140,%eax
  802794:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802797:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80279b:	74 07                	je     8027a4 <print_mem_block_lists+0x9e>
  80279d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a0:	8b 00                	mov    (%eax),%eax
  8027a2:	eb 05                	jmp    8027a9 <print_mem_block_lists+0xa3>
  8027a4:	b8 00 00 00 00       	mov    $0x0,%eax
  8027a9:	a3 40 51 80 00       	mov    %eax,0x805140
  8027ae:	a1 40 51 80 00       	mov    0x805140,%eax
  8027b3:	85 c0                	test   %eax,%eax
  8027b5:	75 8a                	jne    802741 <print_mem_block_lists+0x3b>
  8027b7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8027bb:	75 84                	jne    802741 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8027bd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8027c1:	75 10                	jne    8027d3 <print_mem_block_lists+0xcd>
  8027c3:	83 ec 0c             	sub    $0xc,%esp
  8027c6:	68 c4 43 80 00       	push   $0x8043c4
  8027cb:	e8 81 e3 ff ff       	call   800b51 <cprintf>
  8027d0:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8027d3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8027da:	83 ec 0c             	sub    $0xc,%esp
  8027dd:	68 e8 43 80 00       	push   $0x8043e8
  8027e2:	e8 6a e3 ff ff       	call   800b51 <cprintf>
  8027e7:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8027ea:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8027ee:	a1 40 50 80 00       	mov    0x805040,%eax
  8027f3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8027f6:	eb 56                	jmp    80284e <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8027f8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8027fc:	74 1c                	je     80281a <print_mem_block_lists+0x114>
  8027fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802801:	8b 50 08             	mov    0x8(%eax),%edx
  802804:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802807:	8b 48 08             	mov    0x8(%eax),%ecx
  80280a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80280d:	8b 40 0c             	mov    0xc(%eax),%eax
  802810:	01 c8                	add    %ecx,%eax
  802812:	39 c2                	cmp    %eax,%edx
  802814:	73 04                	jae    80281a <print_mem_block_lists+0x114>
			sorted = 0 ;
  802816:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80281a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80281d:	8b 50 08             	mov    0x8(%eax),%edx
  802820:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802823:	8b 40 0c             	mov    0xc(%eax),%eax
  802826:	01 c2                	add    %eax,%edx
  802828:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80282b:	8b 40 08             	mov    0x8(%eax),%eax
  80282e:	83 ec 04             	sub    $0x4,%esp
  802831:	52                   	push   %edx
  802832:	50                   	push   %eax
  802833:	68 b5 43 80 00       	push   $0x8043b5
  802838:	e8 14 e3 ff ff       	call   800b51 <cprintf>
  80283d:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802840:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802843:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802846:	a1 48 50 80 00       	mov    0x805048,%eax
  80284b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80284e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802852:	74 07                	je     80285b <print_mem_block_lists+0x155>
  802854:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802857:	8b 00                	mov    (%eax),%eax
  802859:	eb 05                	jmp    802860 <print_mem_block_lists+0x15a>
  80285b:	b8 00 00 00 00       	mov    $0x0,%eax
  802860:	a3 48 50 80 00       	mov    %eax,0x805048
  802865:	a1 48 50 80 00       	mov    0x805048,%eax
  80286a:	85 c0                	test   %eax,%eax
  80286c:	75 8a                	jne    8027f8 <print_mem_block_lists+0xf2>
  80286e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802872:	75 84                	jne    8027f8 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802874:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802878:	75 10                	jne    80288a <print_mem_block_lists+0x184>
  80287a:	83 ec 0c             	sub    $0xc,%esp
  80287d:	68 00 44 80 00       	push   $0x804400
  802882:	e8 ca e2 ff ff       	call   800b51 <cprintf>
  802887:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80288a:	83 ec 0c             	sub    $0xc,%esp
  80288d:	68 74 43 80 00       	push   $0x804374
  802892:	e8 ba e2 ff ff       	call   800b51 <cprintf>
  802897:	83 c4 10             	add    $0x10,%esp

}
  80289a:	90                   	nop
  80289b:	c9                   	leave  
  80289c:	c3                   	ret    

0080289d <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  80289d:	55                   	push   %ebp
  80289e:	89 e5                	mov    %esp,%ebp
  8028a0:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8028a3:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8028aa:	00 00 00 
  8028ad:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8028b4:	00 00 00 
  8028b7:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8028be:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8028c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8028c8:	e9 9e 00 00 00       	jmp    80296b <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8028cd:	a1 50 50 80 00       	mov    0x805050,%eax
  8028d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028d5:	c1 e2 04             	shl    $0x4,%edx
  8028d8:	01 d0                	add    %edx,%eax
  8028da:	85 c0                	test   %eax,%eax
  8028dc:	75 14                	jne    8028f2 <initialize_MemBlocksList+0x55>
  8028de:	83 ec 04             	sub    $0x4,%esp
  8028e1:	68 28 44 80 00       	push   $0x804428
  8028e6:	6a 3d                	push   $0x3d
  8028e8:	68 4b 44 80 00       	push   $0x80444b
  8028ed:	e8 ab df ff ff       	call   80089d <_panic>
  8028f2:	a1 50 50 80 00       	mov    0x805050,%eax
  8028f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028fa:	c1 e2 04             	shl    $0x4,%edx
  8028fd:	01 d0                	add    %edx,%eax
  8028ff:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802905:	89 10                	mov    %edx,(%eax)
  802907:	8b 00                	mov    (%eax),%eax
  802909:	85 c0                	test   %eax,%eax
  80290b:	74 18                	je     802925 <initialize_MemBlocksList+0x88>
  80290d:	a1 48 51 80 00       	mov    0x805148,%eax
  802912:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802918:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  80291b:	c1 e1 04             	shl    $0x4,%ecx
  80291e:	01 ca                	add    %ecx,%edx
  802920:	89 50 04             	mov    %edx,0x4(%eax)
  802923:	eb 12                	jmp    802937 <initialize_MemBlocksList+0x9a>
  802925:	a1 50 50 80 00       	mov    0x805050,%eax
  80292a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80292d:	c1 e2 04             	shl    $0x4,%edx
  802930:	01 d0                	add    %edx,%eax
  802932:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802937:	a1 50 50 80 00       	mov    0x805050,%eax
  80293c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80293f:	c1 e2 04             	shl    $0x4,%edx
  802942:	01 d0                	add    %edx,%eax
  802944:	a3 48 51 80 00       	mov    %eax,0x805148
  802949:	a1 50 50 80 00       	mov    0x805050,%eax
  80294e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802951:	c1 e2 04             	shl    $0x4,%edx
  802954:	01 d0                	add    %edx,%eax
  802956:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80295d:	a1 54 51 80 00       	mov    0x805154,%eax
  802962:	40                   	inc    %eax
  802963:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802968:	ff 45 f4             	incl   -0xc(%ebp)
  80296b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802971:	0f 82 56 ff ff ff    	jb     8028cd <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802977:	90                   	nop
  802978:	c9                   	leave  
  802979:	c3                   	ret    

0080297a <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  80297a:	55                   	push   %ebp
  80297b:	89 e5                	mov    %esp,%ebp
  80297d:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802980:	8b 45 08             	mov    0x8(%ebp),%eax
  802983:	8b 00                	mov    (%eax),%eax
  802985:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802988:	eb 18                	jmp    8029a2 <find_block+0x28>

		if(tmp->sva == va){
  80298a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80298d:	8b 40 08             	mov    0x8(%eax),%eax
  802990:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802993:	75 05                	jne    80299a <find_block+0x20>
			return tmp ;
  802995:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802998:	eb 11                	jmp    8029ab <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  80299a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80299d:	8b 00                	mov    (%eax),%eax
  80299f:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  8029a2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8029a6:	75 e2                	jne    80298a <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  8029a8:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8029ab:	c9                   	leave  
  8029ac:	c3                   	ret    

008029ad <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  8029ad:	55                   	push   %ebp
  8029ae:	89 e5                	mov    %esp,%ebp
  8029b0:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  8029b3:	a1 40 50 80 00       	mov    0x805040,%eax
  8029b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  8029bb:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  8029c3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029c7:	75 65                	jne    802a2e <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  8029c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8029cd:	75 14                	jne    8029e3 <insert_sorted_allocList+0x36>
  8029cf:	83 ec 04             	sub    $0x4,%esp
  8029d2:	68 28 44 80 00       	push   $0x804428
  8029d7:	6a 62                	push   $0x62
  8029d9:	68 4b 44 80 00       	push   $0x80444b
  8029de:	e8 ba de ff ff       	call   80089d <_panic>
  8029e3:	8b 15 40 50 80 00    	mov    0x805040,%edx
  8029e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8029ec:	89 10                	mov    %edx,(%eax)
  8029ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8029f1:	8b 00                	mov    (%eax),%eax
  8029f3:	85 c0                	test   %eax,%eax
  8029f5:	74 0d                	je     802a04 <insert_sorted_allocList+0x57>
  8029f7:	a1 40 50 80 00       	mov    0x805040,%eax
  8029fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8029ff:	89 50 04             	mov    %edx,0x4(%eax)
  802a02:	eb 08                	jmp    802a0c <insert_sorted_allocList+0x5f>
  802a04:	8b 45 08             	mov    0x8(%ebp),%eax
  802a07:	a3 44 50 80 00       	mov    %eax,0x805044
  802a0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a0f:	a3 40 50 80 00       	mov    %eax,0x805040
  802a14:	8b 45 08             	mov    0x8(%ebp),%eax
  802a17:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a1e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a23:	40                   	inc    %eax
  802a24:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802a29:	e9 14 01 00 00       	jmp    802b42 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802a2e:	8b 45 08             	mov    0x8(%ebp),%eax
  802a31:	8b 50 08             	mov    0x8(%eax),%edx
  802a34:	a1 44 50 80 00       	mov    0x805044,%eax
  802a39:	8b 40 08             	mov    0x8(%eax),%eax
  802a3c:	39 c2                	cmp    %eax,%edx
  802a3e:	76 65                	jbe    802aa5 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802a40:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802a44:	75 14                	jne    802a5a <insert_sorted_allocList+0xad>
  802a46:	83 ec 04             	sub    $0x4,%esp
  802a49:	68 64 44 80 00       	push   $0x804464
  802a4e:	6a 64                	push   $0x64
  802a50:	68 4b 44 80 00       	push   $0x80444b
  802a55:	e8 43 de ff ff       	call   80089d <_panic>
  802a5a:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802a60:	8b 45 08             	mov    0x8(%ebp),%eax
  802a63:	89 50 04             	mov    %edx,0x4(%eax)
  802a66:	8b 45 08             	mov    0x8(%ebp),%eax
  802a69:	8b 40 04             	mov    0x4(%eax),%eax
  802a6c:	85 c0                	test   %eax,%eax
  802a6e:	74 0c                	je     802a7c <insert_sorted_allocList+0xcf>
  802a70:	a1 44 50 80 00       	mov    0x805044,%eax
  802a75:	8b 55 08             	mov    0x8(%ebp),%edx
  802a78:	89 10                	mov    %edx,(%eax)
  802a7a:	eb 08                	jmp    802a84 <insert_sorted_allocList+0xd7>
  802a7c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a7f:	a3 40 50 80 00       	mov    %eax,0x805040
  802a84:	8b 45 08             	mov    0x8(%ebp),%eax
  802a87:	a3 44 50 80 00       	mov    %eax,0x805044
  802a8c:	8b 45 08             	mov    0x8(%ebp),%eax
  802a8f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a95:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802a9a:	40                   	inc    %eax
  802a9b:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802aa0:	e9 9d 00 00 00       	jmp    802b42 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802aa5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802aac:	e9 85 00 00 00       	jmp    802b36 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802ab1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ab4:	8b 50 08             	mov    0x8(%eax),%edx
  802ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aba:	8b 40 08             	mov    0x8(%eax),%eax
  802abd:	39 c2                	cmp    %eax,%edx
  802abf:	73 6a                	jae    802b2b <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802ac1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ac5:	74 06                	je     802acd <insert_sorted_allocList+0x120>
  802ac7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802acb:	75 14                	jne    802ae1 <insert_sorted_allocList+0x134>
  802acd:	83 ec 04             	sub    $0x4,%esp
  802ad0:	68 88 44 80 00       	push   $0x804488
  802ad5:	6a 6b                	push   $0x6b
  802ad7:	68 4b 44 80 00       	push   $0x80444b
  802adc:	e8 bc dd ff ff       	call   80089d <_panic>
  802ae1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ae4:	8b 50 04             	mov    0x4(%eax),%edx
  802ae7:	8b 45 08             	mov    0x8(%ebp),%eax
  802aea:	89 50 04             	mov    %edx,0x4(%eax)
  802aed:	8b 45 08             	mov    0x8(%ebp),%eax
  802af0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802af3:	89 10                	mov    %edx,(%eax)
  802af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af8:	8b 40 04             	mov    0x4(%eax),%eax
  802afb:	85 c0                	test   %eax,%eax
  802afd:	74 0d                	je     802b0c <insert_sorted_allocList+0x15f>
  802aff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b02:	8b 40 04             	mov    0x4(%eax),%eax
  802b05:	8b 55 08             	mov    0x8(%ebp),%edx
  802b08:	89 10                	mov    %edx,(%eax)
  802b0a:	eb 08                	jmp    802b14 <insert_sorted_allocList+0x167>
  802b0c:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0f:	a3 40 50 80 00       	mov    %eax,0x805040
  802b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b17:	8b 55 08             	mov    0x8(%ebp),%edx
  802b1a:	89 50 04             	mov    %edx,0x4(%eax)
  802b1d:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b22:	40                   	inc    %eax
  802b23:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802b28:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802b29:	eb 17                	jmp    802b42 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2e:	8b 00                	mov    (%eax),%eax
  802b30:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802b33:	ff 45 f0             	incl   -0x10(%ebp)
  802b36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b39:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802b3c:	0f 8c 6f ff ff ff    	jl     802ab1 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802b42:	90                   	nop
  802b43:	c9                   	leave  
  802b44:	c3                   	ret    

00802b45 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802b45:	55                   	push   %ebp
  802b46:	89 e5                	mov    %esp,%ebp
  802b48:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802b4b:	a1 38 51 80 00       	mov    0x805138,%eax
  802b50:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802b53:	e9 7c 01 00 00       	jmp    802cd4 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802b58:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b5b:	8b 40 0c             	mov    0xc(%eax),%eax
  802b5e:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b61:	0f 86 cf 00 00 00    	jbe    802c36 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802b67:	a1 48 51 80 00       	mov    0x805148,%eax
  802b6c:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b72:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802b75:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b78:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7b:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802b7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b81:	8b 50 08             	mov    0x8(%eax),%edx
  802b84:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b87:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802b8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b8d:	8b 40 0c             	mov    0xc(%eax),%eax
  802b90:	2b 45 08             	sub    0x8(%ebp),%eax
  802b93:	89 c2                	mov    %eax,%edx
  802b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b98:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802b9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9e:	8b 50 08             	mov    0x8(%eax),%edx
  802ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  802ba4:	01 c2                	add    %eax,%edx
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802bac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bb0:	75 17                	jne    802bc9 <alloc_block_FF+0x84>
  802bb2:	83 ec 04             	sub    $0x4,%esp
  802bb5:	68 bd 44 80 00       	push   $0x8044bd
  802bba:	68 83 00 00 00       	push   $0x83
  802bbf:	68 4b 44 80 00       	push   $0x80444b
  802bc4:	e8 d4 dc ff ff       	call   80089d <_panic>
  802bc9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bcc:	8b 00                	mov    (%eax),%eax
  802bce:	85 c0                	test   %eax,%eax
  802bd0:	74 10                	je     802be2 <alloc_block_FF+0x9d>
  802bd2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bd5:	8b 00                	mov    (%eax),%eax
  802bd7:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bda:	8b 52 04             	mov    0x4(%edx),%edx
  802bdd:	89 50 04             	mov    %edx,0x4(%eax)
  802be0:	eb 0b                	jmp    802bed <alloc_block_FF+0xa8>
  802be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be5:	8b 40 04             	mov    0x4(%eax),%eax
  802be8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802bed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bf0:	8b 40 04             	mov    0x4(%eax),%eax
  802bf3:	85 c0                	test   %eax,%eax
  802bf5:	74 0f                	je     802c06 <alloc_block_FF+0xc1>
  802bf7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfa:	8b 40 04             	mov    0x4(%eax),%eax
  802bfd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c00:	8b 12                	mov    (%edx),%edx
  802c02:	89 10                	mov    %edx,(%eax)
  802c04:	eb 0a                	jmp    802c10 <alloc_block_FF+0xcb>
  802c06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c09:	8b 00                	mov    (%eax),%eax
  802c0b:	a3 48 51 80 00       	mov    %eax,0x805148
  802c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c13:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c19:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c23:	a1 54 51 80 00       	mov    0x805154,%eax
  802c28:	48                   	dec    %eax
  802c29:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802c2e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c31:	e9 ad 00 00 00       	jmp    802ce3 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802c36:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c39:	8b 40 0c             	mov    0xc(%eax),%eax
  802c3c:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c3f:	0f 85 87 00 00 00    	jne    802ccc <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802c45:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c49:	75 17                	jne    802c62 <alloc_block_FF+0x11d>
  802c4b:	83 ec 04             	sub    $0x4,%esp
  802c4e:	68 bd 44 80 00       	push   $0x8044bd
  802c53:	68 87 00 00 00       	push   $0x87
  802c58:	68 4b 44 80 00       	push   $0x80444b
  802c5d:	e8 3b dc ff ff       	call   80089d <_panic>
  802c62:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c65:	8b 00                	mov    (%eax),%eax
  802c67:	85 c0                	test   %eax,%eax
  802c69:	74 10                	je     802c7b <alloc_block_FF+0x136>
  802c6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c6e:	8b 00                	mov    (%eax),%eax
  802c70:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c73:	8b 52 04             	mov    0x4(%edx),%edx
  802c76:	89 50 04             	mov    %edx,0x4(%eax)
  802c79:	eb 0b                	jmp    802c86 <alloc_block_FF+0x141>
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 40 04             	mov    0x4(%eax),%eax
  802c81:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c89:	8b 40 04             	mov    0x4(%eax),%eax
  802c8c:	85 c0                	test   %eax,%eax
  802c8e:	74 0f                	je     802c9f <alloc_block_FF+0x15a>
  802c90:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c93:	8b 40 04             	mov    0x4(%eax),%eax
  802c96:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c99:	8b 12                	mov    (%edx),%edx
  802c9b:	89 10                	mov    %edx,(%eax)
  802c9d:	eb 0a                	jmp    802ca9 <alloc_block_FF+0x164>
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 00                	mov    (%eax),%eax
  802ca4:	a3 38 51 80 00       	mov    %eax,0x805138
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802cb2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cb5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cbc:	a1 44 51 80 00       	mov    0x805144,%eax
  802cc1:	48                   	dec    %eax
  802cc2:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802cc7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cca:	eb 17                	jmp    802ce3 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802ccc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ccf:	8b 00                	mov    (%eax),%eax
  802cd1:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802cd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cd8:	0f 85 7a fe ff ff    	jne    802b58 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802cde:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ce3:	c9                   	leave  
  802ce4:	c3                   	ret    

00802ce5 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802ce5:	55                   	push   %ebp
  802ce6:	89 e5                	mov    %esp,%ebp
  802ce8:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802ceb:	a1 38 51 80 00       	mov    0x805138,%eax
  802cf0:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802cf3:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802cfa:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802d01:	a1 38 51 80 00       	mov    0x805138,%eax
  802d06:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802d09:	e9 d0 00 00 00       	jmp    802dde <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802d0e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d11:	8b 40 0c             	mov    0xc(%eax),%eax
  802d14:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d17:	0f 82 b8 00 00 00    	jb     802dd5 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802d1d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d20:	8b 40 0c             	mov    0xc(%eax),%eax
  802d23:	2b 45 08             	sub    0x8(%ebp),%eax
  802d26:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802d29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d2c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802d2f:	0f 83 a1 00 00 00    	jae    802dd6 <alloc_block_BF+0xf1>
				differsize = differance ;
  802d35:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802d38:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802d41:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d45:	0f 85 8b 00 00 00    	jne    802dd6 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802d4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4f:	75 17                	jne    802d68 <alloc_block_BF+0x83>
  802d51:	83 ec 04             	sub    $0x4,%esp
  802d54:	68 bd 44 80 00       	push   $0x8044bd
  802d59:	68 a0 00 00 00       	push   $0xa0
  802d5e:	68 4b 44 80 00       	push   $0x80444b
  802d63:	e8 35 db ff ff       	call   80089d <_panic>
  802d68:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6b:	8b 00                	mov    (%eax),%eax
  802d6d:	85 c0                	test   %eax,%eax
  802d6f:	74 10                	je     802d81 <alloc_block_BF+0x9c>
  802d71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d74:	8b 00                	mov    (%eax),%eax
  802d76:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d79:	8b 52 04             	mov    0x4(%edx),%edx
  802d7c:	89 50 04             	mov    %edx,0x4(%eax)
  802d7f:	eb 0b                	jmp    802d8c <alloc_block_BF+0xa7>
  802d81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d84:	8b 40 04             	mov    0x4(%eax),%eax
  802d87:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8f:	8b 40 04             	mov    0x4(%eax),%eax
  802d92:	85 c0                	test   %eax,%eax
  802d94:	74 0f                	je     802da5 <alloc_block_BF+0xc0>
  802d96:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d99:	8b 40 04             	mov    0x4(%eax),%eax
  802d9c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d9f:	8b 12                	mov    (%edx),%edx
  802da1:	89 10                	mov    %edx,(%eax)
  802da3:	eb 0a                	jmp    802daf <alloc_block_BF+0xca>
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 00                	mov    (%eax),%eax
  802daa:	a3 38 51 80 00       	mov    %eax,0x805138
  802daf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db2:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbb:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc2:	a1 44 51 80 00       	mov    0x805144,%eax
  802dc7:	48                   	dec    %eax
  802dc8:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	e9 0c 01 00 00       	jmp    802ee1 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802dd5:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802dd6:	a1 40 51 80 00       	mov    0x805140,%eax
  802ddb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802dde:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802de2:	74 07                	je     802deb <alloc_block_BF+0x106>
  802de4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802de7:	8b 00                	mov    (%eax),%eax
  802de9:	eb 05                	jmp    802df0 <alloc_block_BF+0x10b>
  802deb:	b8 00 00 00 00       	mov    $0x0,%eax
  802df0:	a3 40 51 80 00       	mov    %eax,0x805140
  802df5:	a1 40 51 80 00       	mov    0x805140,%eax
  802dfa:	85 c0                	test   %eax,%eax
  802dfc:	0f 85 0c ff ff ff    	jne    802d0e <alloc_block_BF+0x29>
  802e02:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e06:	0f 85 02 ff ff ff    	jne    802d0e <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802e0c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802e10:	0f 84 c6 00 00 00    	je     802edc <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802e16:	a1 48 51 80 00       	mov    0x805148,%eax
  802e1b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802e1e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e21:	8b 55 08             	mov    0x8(%ebp),%edx
  802e24:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802e27:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e2a:	8b 50 08             	mov    0x8(%eax),%edx
  802e2d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e30:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802e33:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e36:	8b 40 0c             	mov    0xc(%eax),%eax
  802e39:	2b 45 08             	sub    0x8(%ebp),%eax
  802e3c:	89 c2                	mov    %eax,%edx
  802e3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e41:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802e44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e47:	8b 50 08             	mov    0x8(%eax),%edx
  802e4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802e4d:	01 c2                	add    %eax,%edx
  802e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802e52:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802e55:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802e59:	75 17                	jne    802e72 <alloc_block_BF+0x18d>
  802e5b:	83 ec 04             	sub    $0x4,%esp
  802e5e:	68 bd 44 80 00       	push   $0x8044bd
  802e63:	68 af 00 00 00       	push   $0xaf
  802e68:	68 4b 44 80 00       	push   $0x80444b
  802e6d:	e8 2b da ff ff       	call   80089d <_panic>
  802e72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e75:	8b 00                	mov    (%eax),%eax
  802e77:	85 c0                	test   %eax,%eax
  802e79:	74 10                	je     802e8b <alloc_block_BF+0x1a6>
  802e7b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e7e:	8b 00                	mov    (%eax),%eax
  802e80:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802e83:	8b 52 04             	mov    0x4(%edx),%edx
  802e86:	89 50 04             	mov    %edx,0x4(%eax)
  802e89:	eb 0b                	jmp    802e96 <alloc_block_BF+0x1b1>
  802e8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e8e:	8b 40 04             	mov    0x4(%eax),%eax
  802e91:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e96:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802e99:	8b 40 04             	mov    0x4(%eax),%eax
  802e9c:	85 c0                	test   %eax,%eax
  802e9e:	74 0f                	je     802eaf <alloc_block_BF+0x1ca>
  802ea0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ea3:	8b 40 04             	mov    0x4(%eax),%eax
  802ea6:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802ea9:	8b 12                	mov    (%edx),%edx
  802eab:	89 10                	mov    %edx,(%eax)
  802ead:	eb 0a                	jmp    802eb9 <alloc_block_BF+0x1d4>
  802eaf:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eb2:	8b 00                	mov    (%eax),%eax
  802eb4:	a3 48 51 80 00       	mov    %eax,0x805148
  802eb9:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ebc:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ec2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ec5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ecc:	a1 54 51 80 00       	mov    0x805154,%eax
  802ed1:	48                   	dec    %eax
  802ed2:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802ed7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802eda:	eb 05                	jmp    802ee1 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802edc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802ee1:	c9                   	leave  
  802ee2:	c3                   	ret    

00802ee3 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802ee3:	55                   	push   %ebp
  802ee4:	89 e5                	mov    %esp,%ebp
  802ee6:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802ee9:	a1 38 51 80 00       	mov    0x805138,%eax
  802eee:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802ef1:	e9 7c 01 00 00       	jmp    803072 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802ef6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef9:	8b 40 0c             	mov    0xc(%eax),%eax
  802efc:	3b 45 08             	cmp    0x8(%ebp),%eax
  802eff:	0f 86 cf 00 00 00    	jbe    802fd4 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802f05:	a1 48 51 80 00       	mov    0x805148,%eax
  802f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802f0d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f10:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f16:	8b 55 08             	mov    0x8(%ebp),%edx
  802f19:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802f1c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f1f:	8b 50 08             	mov    0x8(%eax),%edx
  802f22:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f25:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802f28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f2b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f2e:	2b 45 08             	sub    0x8(%ebp),%eax
  802f31:	89 c2                	mov    %eax,%edx
  802f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f36:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802f39:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f3c:	8b 50 08             	mov    0x8(%eax),%edx
  802f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f42:	01 c2                	add    %eax,%edx
  802f44:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f47:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802f4a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f4e:	75 17                	jne    802f67 <alloc_block_NF+0x84>
  802f50:	83 ec 04             	sub    $0x4,%esp
  802f53:	68 bd 44 80 00       	push   $0x8044bd
  802f58:	68 c4 00 00 00       	push   $0xc4
  802f5d:	68 4b 44 80 00       	push   $0x80444b
  802f62:	e8 36 d9 ff ff       	call   80089d <_panic>
  802f67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f6a:	8b 00                	mov    (%eax),%eax
  802f6c:	85 c0                	test   %eax,%eax
  802f6e:	74 10                	je     802f80 <alloc_block_NF+0x9d>
  802f70:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f73:	8b 00                	mov    (%eax),%eax
  802f75:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f78:	8b 52 04             	mov    0x4(%edx),%edx
  802f7b:	89 50 04             	mov    %edx,0x4(%eax)
  802f7e:	eb 0b                	jmp    802f8b <alloc_block_NF+0xa8>
  802f80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f83:	8b 40 04             	mov    0x4(%eax),%eax
  802f86:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f8e:	8b 40 04             	mov    0x4(%eax),%eax
  802f91:	85 c0                	test   %eax,%eax
  802f93:	74 0f                	je     802fa4 <alloc_block_NF+0xc1>
  802f95:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802f98:	8b 40 04             	mov    0x4(%eax),%eax
  802f9b:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802f9e:	8b 12                	mov    (%edx),%edx
  802fa0:	89 10                	mov    %edx,(%eax)
  802fa2:	eb 0a                	jmp    802fae <alloc_block_NF+0xcb>
  802fa4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fa7:	8b 00                	mov    (%eax),%eax
  802fa9:	a3 48 51 80 00       	mov    %eax,0x805148
  802fae:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fb1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fb7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fc1:	a1 54 51 80 00       	mov    0x805154,%eax
  802fc6:	48                   	dec    %eax
  802fc7:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802fcc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802fcf:	e9 ad 00 00 00       	jmp    803081 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802fd4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802fd7:	8b 40 0c             	mov    0xc(%eax),%eax
  802fda:	3b 45 08             	cmp    0x8(%ebp),%eax
  802fdd:	0f 85 87 00 00 00    	jne    80306a <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802fe3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802fe7:	75 17                	jne    803000 <alloc_block_NF+0x11d>
  802fe9:	83 ec 04             	sub    $0x4,%esp
  802fec:	68 bd 44 80 00       	push   $0x8044bd
  802ff1:	68 c8 00 00 00       	push   $0xc8
  802ff6:	68 4b 44 80 00       	push   $0x80444b
  802ffb:	e8 9d d8 ff ff       	call   80089d <_panic>
  803000:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803003:	8b 00                	mov    (%eax),%eax
  803005:	85 c0                	test   %eax,%eax
  803007:	74 10                	je     803019 <alloc_block_NF+0x136>
  803009:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80300c:	8b 00                	mov    (%eax),%eax
  80300e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803011:	8b 52 04             	mov    0x4(%edx),%edx
  803014:	89 50 04             	mov    %edx,0x4(%eax)
  803017:	eb 0b                	jmp    803024 <alloc_block_NF+0x141>
  803019:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80301c:	8b 40 04             	mov    0x4(%eax),%eax
  80301f:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803024:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803027:	8b 40 04             	mov    0x4(%eax),%eax
  80302a:	85 c0                	test   %eax,%eax
  80302c:	74 0f                	je     80303d <alloc_block_NF+0x15a>
  80302e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803031:	8b 40 04             	mov    0x4(%eax),%eax
  803034:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803037:	8b 12                	mov    (%edx),%edx
  803039:	89 10                	mov    %edx,(%eax)
  80303b:	eb 0a                	jmp    803047 <alloc_block_NF+0x164>
  80303d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803040:	8b 00                	mov    (%eax),%eax
  803042:	a3 38 51 80 00       	mov    %eax,0x805138
  803047:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803050:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803053:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80305a:	a1 44 51 80 00       	mov    0x805144,%eax
  80305f:	48                   	dec    %eax
  803060:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  803065:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803068:	eb 17                	jmp    803081 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  803072:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803076:	0f 85 7a fe ff ff    	jne    802ef6 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  80307c:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803081:	c9                   	leave  
  803082:	c3                   	ret    

00803083 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803083:	55                   	push   %ebp
  803084:	89 e5                	mov    %esp,%ebp
  803086:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  803089:	a1 38 51 80 00       	mov    0x805138,%eax
  80308e:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  803091:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803096:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  803099:	a1 44 51 80 00       	mov    0x805144,%eax
  80309e:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8030a1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8030a5:	75 68                	jne    80310f <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8030a7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030ab:	75 17                	jne    8030c4 <insert_sorted_with_merge_freeList+0x41>
  8030ad:	83 ec 04             	sub    $0x4,%esp
  8030b0:	68 28 44 80 00       	push   $0x804428
  8030b5:	68 da 00 00 00       	push   $0xda
  8030ba:	68 4b 44 80 00       	push   $0x80444b
  8030bf:	e8 d9 d7 ff ff       	call   80089d <_panic>
  8030c4:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	89 10                	mov    %edx,(%eax)
  8030cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8030d2:	8b 00                	mov    (%eax),%eax
  8030d4:	85 c0                	test   %eax,%eax
  8030d6:	74 0d                	je     8030e5 <insert_sorted_with_merge_freeList+0x62>
  8030d8:	a1 38 51 80 00       	mov    0x805138,%eax
  8030dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8030e0:	89 50 04             	mov    %edx,0x4(%eax)
  8030e3:	eb 08                	jmp    8030ed <insert_sorted_with_merge_freeList+0x6a>
  8030e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8030ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f0:	a3 38 51 80 00       	mov    %eax,0x805138
  8030f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030ff:	a1 44 51 80 00       	mov    0x805144,%eax
  803104:	40                   	inc    %eax
  803105:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  80310a:	e9 49 07 00 00       	jmp    803858 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  80310f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803112:	8b 50 08             	mov    0x8(%eax),%edx
  803115:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803118:	8b 40 0c             	mov    0xc(%eax),%eax
  80311b:	01 c2                	add    %eax,%edx
  80311d:	8b 45 08             	mov    0x8(%ebp),%eax
  803120:	8b 40 08             	mov    0x8(%eax),%eax
  803123:	39 c2                	cmp    %eax,%edx
  803125:	73 77                	jae    80319e <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  803127:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80312a:	8b 00                	mov    (%eax),%eax
  80312c:	85 c0                	test   %eax,%eax
  80312e:	75 6e                	jne    80319e <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  803130:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803134:	74 68                	je     80319e <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  803136:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80313a:	75 17                	jne    803153 <insert_sorted_with_merge_freeList+0xd0>
  80313c:	83 ec 04             	sub    $0x4,%esp
  80313f:	68 64 44 80 00       	push   $0x804464
  803144:	68 e0 00 00 00       	push   $0xe0
  803149:	68 4b 44 80 00       	push   $0x80444b
  80314e:	e8 4a d7 ff ff       	call   80089d <_panic>
  803153:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803159:	8b 45 08             	mov    0x8(%ebp),%eax
  80315c:	89 50 04             	mov    %edx,0x4(%eax)
  80315f:	8b 45 08             	mov    0x8(%ebp),%eax
  803162:	8b 40 04             	mov    0x4(%eax),%eax
  803165:	85 c0                	test   %eax,%eax
  803167:	74 0c                	je     803175 <insert_sorted_with_merge_freeList+0xf2>
  803169:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80316e:	8b 55 08             	mov    0x8(%ebp),%edx
  803171:	89 10                	mov    %edx,(%eax)
  803173:	eb 08                	jmp    80317d <insert_sorted_with_merge_freeList+0xfa>
  803175:	8b 45 08             	mov    0x8(%ebp),%eax
  803178:	a3 38 51 80 00       	mov    %eax,0x805138
  80317d:	8b 45 08             	mov    0x8(%ebp),%eax
  803180:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803185:	8b 45 08             	mov    0x8(%ebp),%eax
  803188:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80318e:	a1 44 51 80 00       	mov    0x805144,%eax
  803193:	40                   	inc    %eax
  803194:	a3 44 51 80 00       	mov    %eax,0x805144
  803199:	e9 ba 06 00 00       	jmp    803858 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  80319e:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a1:	8b 50 0c             	mov    0xc(%eax),%edx
  8031a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a7:	8b 40 08             	mov    0x8(%eax),%eax
  8031aa:	01 c2                	add    %eax,%edx
  8031ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031af:	8b 40 08             	mov    0x8(%eax),%eax
  8031b2:	39 c2                	cmp    %eax,%edx
  8031b4:	73 78                	jae    80322e <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8031b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031b9:	8b 40 04             	mov    0x4(%eax),%eax
  8031bc:	85 c0                	test   %eax,%eax
  8031be:	75 6e                	jne    80322e <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8031c0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031c4:	74 68                	je     80322e <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8031c6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ca:	75 17                	jne    8031e3 <insert_sorted_with_merge_freeList+0x160>
  8031cc:	83 ec 04             	sub    $0x4,%esp
  8031cf:	68 28 44 80 00       	push   $0x804428
  8031d4:	68 e6 00 00 00       	push   $0xe6
  8031d9:	68 4b 44 80 00       	push   $0x80444b
  8031de:	e8 ba d6 ff ff       	call   80089d <_panic>
  8031e3:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ec:	89 10                	mov    %edx,(%eax)
  8031ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f1:	8b 00                	mov    (%eax),%eax
  8031f3:	85 c0                	test   %eax,%eax
  8031f5:	74 0d                	je     803204 <insert_sorted_with_merge_freeList+0x181>
  8031f7:	a1 38 51 80 00       	mov    0x805138,%eax
  8031fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ff:	89 50 04             	mov    %edx,0x4(%eax)
  803202:	eb 08                	jmp    80320c <insert_sorted_with_merge_freeList+0x189>
  803204:	8b 45 08             	mov    0x8(%ebp),%eax
  803207:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80320c:	8b 45 08             	mov    0x8(%ebp),%eax
  80320f:	a3 38 51 80 00       	mov    %eax,0x805138
  803214:	8b 45 08             	mov    0x8(%ebp),%eax
  803217:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80321e:	a1 44 51 80 00       	mov    0x805144,%eax
  803223:	40                   	inc    %eax
  803224:	a3 44 51 80 00       	mov    %eax,0x805144
  803229:	e9 2a 06 00 00       	jmp    803858 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80322e:	a1 38 51 80 00       	mov    0x805138,%eax
  803233:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803236:	e9 ed 05 00 00       	jmp    803828 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  80323b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323e:	8b 00                	mov    (%eax),%eax
  803240:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  803243:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  803247:	0f 84 a7 00 00 00    	je     8032f4 <insert_sorted_with_merge_freeList+0x271>
  80324d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803250:	8b 50 0c             	mov    0xc(%eax),%edx
  803253:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803256:	8b 40 08             	mov    0x8(%eax),%eax
  803259:	01 c2                	add    %eax,%edx
  80325b:	8b 45 08             	mov    0x8(%ebp),%eax
  80325e:	8b 40 08             	mov    0x8(%eax),%eax
  803261:	39 c2                	cmp    %eax,%edx
  803263:	0f 83 8b 00 00 00    	jae    8032f4 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  803269:	8b 45 08             	mov    0x8(%ebp),%eax
  80326c:	8b 50 0c             	mov    0xc(%eax),%edx
  80326f:	8b 45 08             	mov    0x8(%ebp),%eax
  803272:	8b 40 08             	mov    0x8(%eax),%eax
  803275:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  803277:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80327a:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  80327d:	39 c2                	cmp    %eax,%edx
  80327f:	73 73                	jae    8032f4 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  803281:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803285:	74 06                	je     80328d <insert_sorted_with_merge_freeList+0x20a>
  803287:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80328b:	75 17                	jne    8032a4 <insert_sorted_with_merge_freeList+0x221>
  80328d:	83 ec 04             	sub    $0x4,%esp
  803290:	68 dc 44 80 00       	push   $0x8044dc
  803295:	68 f0 00 00 00       	push   $0xf0
  80329a:	68 4b 44 80 00       	push   $0x80444b
  80329f:	e8 f9 d5 ff ff       	call   80089d <_panic>
  8032a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032a7:	8b 10                	mov    (%eax),%edx
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	89 10                	mov    %edx,(%eax)
  8032ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8032b1:	8b 00                	mov    (%eax),%eax
  8032b3:	85 c0                	test   %eax,%eax
  8032b5:	74 0b                	je     8032c2 <insert_sorted_with_merge_freeList+0x23f>
  8032b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032ba:	8b 00                	mov    (%eax),%eax
  8032bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8032bf:	89 50 04             	mov    %edx,0x4(%eax)
  8032c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8032c8:	89 10                	mov    %edx,(%eax)
  8032ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8032d0:	89 50 04             	mov    %edx,0x4(%eax)
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	8b 00                	mov    (%eax),%eax
  8032d8:	85 c0                	test   %eax,%eax
  8032da:	75 08                	jne    8032e4 <insert_sorted_with_merge_freeList+0x261>
  8032dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8032df:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8032e4:	a1 44 51 80 00       	mov    0x805144,%eax
  8032e9:	40                   	inc    %eax
  8032ea:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  8032ef:	e9 64 05 00 00       	jmp    803858 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  8032f4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8032f9:	8b 50 0c             	mov    0xc(%eax),%edx
  8032fc:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803301:	8b 40 08             	mov    0x8(%eax),%eax
  803304:	01 c2                	add    %eax,%edx
  803306:	8b 45 08             	mov    0x8(%ebp),%eax
  803309:	8b 40 08             	mov    0x8(%eax),%eax
  80330c:	39 c2                	cmp    %eax,%edx
  80330e:	0f 85 b1 00 00 00    	jne    8033c5 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  803314:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803319:	85 c0                	test   %eax,%eax
  80331b:	0f 84 a4 00 00 00    	je     8033c5 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  803321:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803326:	8b 00                	mov    (%eax),%eax
  803328:	85 c0                	test   %eax,%eax
  80332a:	0f 85 95 00 00 00    	jne    8033c5 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803330:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803335:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80333b:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80333e:	8b 55 08             	mov    0x8(%ebp),%edx
  803341:	8b 52 0c             	mov    0xc(%edx),%edx
  803344:	01 ca                	add    %ecx,%edx
  803346:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  803349:	8b 45 08             	mov    0x8(%ebp),%eax
  80334c:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  803353:	8b 45 08             	mov    0x8(%ebp),%eax
  803356:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80335d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803361:	75 17                	jne    80337a <insert_sorted_with_merge_freeList+0x2f7>
  803363:	83 ec 04             	sub    $0x4,%esp
  803366:	68 28 44 80 00       	push   $0x804428
  80336b:	68 ff 00 00 00       	push   $0xff
  803370:	68 4b 44 80 00       	push   $0x80444b
  803375:	e8 23 d5 ff ff       	call   80089d <_panic>
  80337a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803380:	8b 45 08             	mov    0x8(%ebp),%eax
  803383:	89 10                	mov    %edx,(%eax)
  803385:	8b 45 08             	mov    0x8(%ebp),%eax
  803388:	8b 00                	mov    (%eax),%eax
  80338a:	85 c0                	test   %eax,%eax
  80338c:	74 0d                	je     80339b <insert_sorted_with_merge_freeList+0x318>
  80338e:	a1 48 51 80 00       	mov    0x805148,%eax
  803393:	8b 55 08             	mov    0x8(%ebp),%edx
  803396:	89 50 04             	mov    %edx,0x4(%eax)
  803399:	eb 08                	jmp    8033a3 <insert_sorted_with_merge_freeList+0x320>
  80339b:	8b 45 08             	mov    0x8(%ebp),%eax
  80339e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033a6:	a3 48 51 80 00       	mov    %eax,0x805148
  8033ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033b5:	a1 54 51 80 00       	mov    0x805154,%eax
  8033ba:	40                   	inc    %eax
  8033bb:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  8033c0:	e9 93 04 00 00       	jmp    803858 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  8033c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033c8:	8b 50 08             	mov    0x8(%eax),%edx
  8033cb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ce:	8b 40 0c             	mov    0xc(%eax),%eax
  8033d1:	01 c2                	add    %eax,%edx
  8033d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d6:	8b 40 08             	mov    0x8(%eax),%eax
  8033d9:	39 c2                	cmp    %eax,%edx
  8033db:	0f 85 ae 00 00 00    	jne    80348f <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  8033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e4:	8b 50 0c             	mov    0xc(%eax),%edx
  8033e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ea:	8b 40 08             	mov    0x8(%eax),%eax
  8033ed:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  8033ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033f2:	8b 00                	mov    (%eax),%eax
  8033f4:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  8033f7:	39 c2                	cmp    %eax,%edx
  8033f9:	0f 84 90 00 00 00    	je     80348f <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  8033ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803402:	8b 50 0c             	mov    0xc(%eax),%edx
  803405:	8b 45 08             	mov    0x8(%ebp),%eax
  803408:	8b 40 0c             	mov    0xc(%eax),%eax
  80340b:	01 c2                	add    %eax,%edx
  80340d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803410:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803413:	8b 45 08             	mov    0x8(%ebp),%eax
  803416:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80341d:	8b 45 08             	mov    0x8(%ebp),%eax
  803420:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803427:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80342b:	75 17                	jne    803444 <insert_sorted_with_merge_freeList+0x3c1>
  80342d:	83 ec 04             	sub    $0x4,%esp
  803430:	68 28 44 80 00       	push   $0x804428
  803435:	68 0b 01 00 00       	push   $0x10b
  80343a:	68 4b 44 80 00       	push   $0x80444b
  80343f:	e8 59 d4 ff ff       	call   80089d <_panic>
  803444:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80344a:	8b 45 08             	mov    0x8(%ebp),%eax
  80344d:	89 10                	mov    %edx,(%eax)
  80344f:	8b 45 08             	mov    0x8(%ebp),%eax
  803452:	8b 00                	mov    (%eax),%eax
  803454:	85 c0                	test   %eax,%eax
  803456:	74 0d                	je     803465 <insert_sorted_with_merge_freeList+0x3e2>
  803458:	a1 48 51 80 00       	mov    0x805148,%eax
  80345d:	8b 55 08             	mov    0x8(%ebp),%edx
  803460:	89 50 04             	mov    %edx,0x4(%eax)
  803463:	eb 08                	jmp    80346d <insert_sorted_with_merge_freeList+0x3ea>
  803465:	8b 45 08             	mov    0x8(%ebp),%eax
  803468:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80346d:	8b 45 08             	mov    0x8(%ebp),%eax
  803470:	a3 48 51 80 00       	mov    %eax,0x805148
  803475:	8b 45 08             	mov    0x8(%ebp),%eax
  803478:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80347f:	a1 54 51 80 00       	mov    0x805154,%eax
  803484:	40                   	inc    %eax
  803485:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80348a:	e9 c9 03 00 00       	jmp    803858 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  80348f:	8b 45 08             	mov    0x8(%ebp),%eax
  803492:	8b 50 0c             	mov    0xc(%eax),%edx
  803495:	8b 45 08             	mov    0x8(%ebp),%eax
  803498:	8b 40 08             	mov    0x8(%eax),%eax
  80349b:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  80349d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034a0:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8034a3:	39 c2                	cmp    %eax,%edx
  8034a5:	0f 85 bb 00 00 00    	jne    803566 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  8034ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034af:	0f 84 b1 00 00 00    	je     803566 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  8034b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034b8:	8b 40 04             	mov    0x4(%eax),%eax
  8034bb:	85 c0                	test   %eax,%eax
  8034bd:	0f 85 a3 00 00 00    	jne    803566 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8034c3:	a1 38 51 80 00       	mov    0x805138,%eax
  8034c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8034cb:	8b 52 08             	mov    0x8(%edx),%edx
  8034ce:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  8034d1:	a1 38 51 80 00       	mov    0x805138,%eax
  8034d6:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8034dc:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8034df:	8b 55 08             	mov    0x8(%ebp),%edx
  8034e2:	8b 52 0c             	mov    0xc(%edx),%edx
  8034e5:	01 ca                	add    %ecx,%edx
  8034e7:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8034ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ed:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8034f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8034f7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8034fe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803502:	75 17                	jne    80351b <insert_sorted_with_merge_freeList+0x498>
  803504:	83 ec 04             	sub    $0x4,%esp
  803507:	68 28 44 80 00       	push   $0x804428
  80350c:	68 17 01 00 00       	push   $0x117
  803511:	68 4b 44 80 00       	push   $0x80444b
  803516:	e8 82 d3 ff ff       	call   80089d <_panic>
  80351b:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803521:	8b 45 08             	mov    0x8(%ebp),%eax
  803524:	89 10                	mov    %edx,(%eax)
  803526:	8b 45 08             	mov    0x8(%ebp),%eax
  803529:	8b 00                	mov    (%eax),%eax
  80352b:	85 c0                	test   %eax,%eax
  80352d:	74 0d                	je     80353c <insert_sorted_with_merge_freeList+0x4b9>
  80352f:	a1 48 51 80 00       	mov    0x805148,%eax
  803534:	8b 55 08             	mov    0x8(%ebp),%edx
  803537:	89 50 04             	mov    %edx,0x4(%eax)
  80353a:	eb 08                	jmp    803544 <insert_sorted_with_merge_freeList+0x4c1>
  80353c:	8b 45 08             	mov    0x8(%ebp),%eax
  80353f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803544:	8b 45 08             	mov    0x8(%ebp),%eax
  803547:	a3 48 51 80 00       	mov    %eax,0x805148
  80354c:	8b 45 08             	mov    0x8(%ebp),%eax
  80354f:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803556:	a1 54 51 80 00       	mov    0x805154,%eax
  80355b:	40                   	inc    %eax
  80355c:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803561:	e9 f2 02 00 00       	jmp    803858 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  803566:	8b 45 08             	mov    0x8(%ebp),%eax
  803569:	8b 50 08             	mov    0x8(%eax),%edx
  80356c:	8b 45 08             	mov    0x8(%ebp),%eax
  80356f:	8b 40 0c             	mov    0xc(%eax),%eax
  803572:	01 c2                	add    %eax,%edx
  803574:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803577:	8b 40 08             	mov    0x8(%eax),%eax
  80357a:	39 c2                	cmp    %eax,%edx
  80357c:	0f 85 be 00 00 00    	jne    803640 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803582:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803585:	8b 40 04             	mov    0x4(%eax),%eax
  803588:	8b 50 08             	mov    0x8(%eax),%edx
  80358b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80358e:	8b 40 04             	mov    0x4(%eax),%eax
  803591:	8b 40 0c             	mov    0xc(%eax),%eax
  803594:	01 c2                	add    %eax,%edx
  803596:	8b 45 08             	mov    0x8(%ebp),%eax
  803599:	8b 40 08             	mov    0x8(%eax),%eax
  80359c:	39 c2                	cmp    %eax,%edx
  80359e:	0f 84 9c 00 00 00    	je     803640 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  8035a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035a7:	8b 50 08             	mov    0x8(%eax),%edx
  8035aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035ad:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  8035b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b3:	8b 50 0c             	mov    0xc(%eax),%edx
  8035b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8035b9:	8b 40 0c             	mov    0xc(%eax),%eax
  8035bc:	01 c2                	add    %eax,%edx
  8035be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035c1:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8035c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8035c7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8035ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8035d1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8035d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8035dc:	75 17                	jne    8035f5 <insert_sorted_with_merge_freeList+0x572>
  8035de:	83 ec 04             	sub    $0x4,%esp
  8035e1:	68 28 44 80 00       	push   $0x804428
  8035e6:	68 26 01 00 00       	push   $0x126
  8035eb:	68 4b 44 80 00       	push   $0x80444b
  8035f0:	e8 a8 d2 ff ff       	call   80089d <_panic>
  8035f5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8035fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fe:	89 10                	mov    %edx,(%eax)
  803600:	8b 45 08             	mov    0x8(%ebp),%eax
  803603:	8b 00                	mov    (%eax),%eax
  803605:	85 c0                	test   %eax,%eax
  803607:	74 0d                	je     803616 <insert_sorted_with_merge_freeList+0x593>
  803609:	a1 48 51 80 00       	mov    0x805148,%eax
  80360e:	8b 55 08             	mov    0x8(%ebp),%edx
  803611:	89 50 04             	mov    %edx,0x4(%eax)
  803614:	eb 08                	jmp    80361e <insert_sorted_with_merge_freeList+0x59b>
  803616:	8b 45 08             	mov    0x8(%ebp),%eax
  803619:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80361e:	8b 45 08             	mov    0x8(%ebp),%eax
  803621:	a3 48 51 80 00       	mov    %eax,0x805148
  803626:	8b 45 08             	mov    0x8(%ebp),%eax
  803629:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803630:	a1 54 51 80 00       	mov    0x805154,%eax
  803635:	40                   	inc    %eax
  803636:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  80363b:	e9 18 02 00 00       	jmp    803858 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803640:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803643:	8b 50 0c             	mov    0xc(%eax),%edx
  803646:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803649:	8b 40 08             	mov    0x8(%eax),%eax
  80364c:	01 c2                	add    %eax,%edx
  80364e:	8b 45 08             	mov    0x8(%ebp),%eax
  803651:	8b 40 08             	mov    0x8(%eax),%eax
  803654:	39 c2                	cmp    %eax,%edx
  803656:	0f 85 c4 01 00 00    	jne    803820 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  80365c:	8b 45 08             	mov    0x8(%ebp),%eax
  80365f:	8b 50 0c             	mov    0xc(%eax),%edx
  803662:	8b 45 08             	mov    0x8(%ebp),%eax
  803665:	8b 40 08             	mov    0x8(%eax),%eax
  803668:	01 c2                	add    %eax,%edx
  80366a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80366d:	8b 00                	mov    (%eax),%eax
  80366f:	8b 40 08             	mov    0x8(%eax),%eax
  803672:	39 c2                	cmp    %eax,%edx
  803674:	0f 85 a6 01 00 00    	jne    803820 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  80367a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80367e:	0f 84 9c 01 00 00    	je     803820 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  803684:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803687:	8b 50 0c             	mov    0xc(%eax),%edx
  80368a:	8b 45 08             	mov    0x8(%ebp),%eax
  80368d:	8b 40 0c             	mov    0xc(%eax),%eax
  803690:	01 c2                	add    %eax,%edx
  803692:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803695:	8b 00                	mov    (%eax),%eax
  803697:	8b 40 0c             	mov    0xc(%eax),%eax
  80369a:	01 c2                	add    %eax,%edx
  80369c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80369f:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8036a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8036a5:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8036ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8036af:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8036b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036ba:	75 17                	jne    8036d3 <insert_sorted_with_merge_freeList+0x650>
  8036bc:	83 ec 04             	sub    $0x4,%esp
  8036bf:	68 28 44 80 00       	push   $0x804428
  8036c4:	68 32 01 00 00       	push   $0x132
  8036c9:	68 4b 44 80 00       	push   $0x80444b
  8036ce:	e8 ca d1 ff ff       	call   80089d <_panic>
  8036d3:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8036d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036dc:	89 10                	mov    %edx,(%eax)
  8036de:	8b 45 08             	mov    0x8(%ebp),%eax
  8036e1:	8b 00                	mov    (%eax),%eax
  8036e3:	85 c0                	test   %eax,%eax
  8036e5:	74 0d                	je     8036f4 <insert_sorted_with_merge_freeList+0x671>
  8036e7:	a1 48 51 80 00       	mov    0x805148,%eax
  8036ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8036ef:	89 50 04             	mov    %edx,0x4(%eax)
  8036f2:	eb 08                	jmp    8036fc <insert_sorted_with_merge_freeList+0x679>
  8036f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8036f7:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8036fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ff:	a3 48 51 80 00       	mov    %eax,0x805148
  803704:	8b 45 08             	mov    0x8(%ebp),%eax
  803707:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80370e:	a1 54 51 80 00       	mov    0x805154,%eax
  803713:	40                   	inc    %eax
  803714:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803719:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80371c:	8b 00                	mov    (%eax),%eax
  80371e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  803725:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803728:	8b 00                	mov    (%eax),%eax
  80372a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803734:	8b 00                	mov    (%eax),%eax
  803736:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  803739:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80373d:	75 17                	jne    803756 <insert_sorted_with_merge_freeList+0x6d3>
  80373f:	83 ec 04             	sub    $0x4,%esp
  803742:	68 bd 44 80 00       	push   $0x8044bd
  803747:	68 36 01 00 00       	push   $0x136
  80374c:	68 4b 44 80 00       	push   $0x80444b
  803751:	e8 47 d1 ff ff       	call   80089d <_panic>
  803756:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803759:	8b 00                	mov    (%eax),%eax
  80375b:	85 c0                	test   %eax,%eax
  80375d:	74 10                	je     80376f <insert_sorted_with_merge_freeList+0x6ec>
  80375f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803762:	8b 00                	mov    (%eax),%eax
  803764:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803767:	8b 52 04             	mov    0x4(%edx),%edx
  80376a:	89 50 04             	mov    %edx,0x4(%eax)
  80376d:	eb 0b                	jmp    80377a <insert_sorted_with_merge_freeList+0x6f7>
  80376f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803772:	8b 40 04             	mov    0x4(%eax),%eax
  803775:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80377a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80377d:	8b 40 04             	mov    0x4(%eax),%eax
  803780:	85 c0                	test   %eax,%eax
  803782:	74 0f                	je     803793 <insert_sorted_with_merge_freeList+0x710>
  803784:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803787:	8b 40 04             	mov    0x4(%eax),%eax
  80378a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80378d:	8b 12                	mov    (%edx),%edx
  80378f:	89 10                	mov    %edx,(%eax)
  803791:	eb 0a                	jmp    80379d <insert_sorted_with_merge_freeList+0x71a>
  803793:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803796:	8b 00                	mov    (%eax),%eax
  803798:	a3 38 51 80 00       	mov    %eax,0x805138
  80379d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8037a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037a9:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8037b0:	a1 44 51 80 00       	mov    0x805144,%eax
  8037b5:	48                   	dec    %eax
  8037b6:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8037bb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8037bf:	75 17                	jne    8037d8 <insert_sorted_with_merge_freeList+0x755>
  8037c1:	83 ec 04             	sub    $0x4,%esp
  8037c4:	68 28 44 80 00       	push   $0x804428
  8037c9:	68 37 01 00 00       	push   $0x137
  8037ce:	68 4b 44 80 00       	push   $0x80444b
  8037d3:	e8 c5 d0 ff ff       	call   80089d <_panic>
  8037d8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e1:	89 10                	mov    %edx,(%eax)
  8037e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037e6:	8b 00                	mov    (%eax),%eax
  8037e8:	85 c0                	test   %eax,%eax
  8037ea:	74 0d                	je     8037f9 <insert_sorted_with_merge_freeList+0x776>
  8037ec:	a1 48 51 80 00       	mov    0x805148,%eax
  8037f1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8037f4:	89 50 04             	mov    %edx,0x4(%eax)
  8037f7:	eb 08                	jmp    803801 <insert_sorted_with_merge_freeList+0x77e>
  8037f9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8037fc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803801:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803804:	a3 48 51 80 00       	mov    %eax,0x805148
  803809:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80380c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803813:	a1 54 51 80 00       	mov    0x805154,%eax
  803818:	40                   	inc    %eax
  803819:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  80381e:	eb 38                	jmp    803858 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803820:	a1 40 51 80 00       	mov    0x805140,%eax
  803825:	89 45 f4             	mov    %eax,-0xc(%ebp)
  803828:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80382c:	74 07                	je     803835 <insert_sorted_with_merge_freeList+0x7b2>
  80382e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803831:	8b 00                	mov    (%eax),%eax
  803833:	eb 05                	jmp    80383a <insert_sorted_with_merge_freeList+0x7b7>
  803835:	b8 00 00 00 00       	mov    $0x0,%eax
  80383a:	a3 40 51 80 00       	mov    %eax,0x805140
  80383f:	a1 40 51 80 00       	mov    0x805140,%eax
  803844:	85 c0                	test   %eax,%eax
  803846:	0f 85 ef f9 ff ff    	jne    80323b <insert_sorted_with_merge_freeList+0x1b8>
  80384c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803850:	0f 85 e5 f9 ff ff    	jne    80323b <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  803856:	eb 00                	jmp    803858 <insert_sorted_with_merge_freeList+0x7d5>
  803858:	90                   	nop
  803859:	c9                   	leave  
  80385a:	c3                   	ret    
  80385b:	90                   	nop

0080385c <__udivdi3>:
  80385c:	55                   	push   %ebp
  80385d:	57                   	push   %edi
  80385e:	56                   	push   %esi
  80385f:	53                   	push   %ebx
  803860:	83 ec 1c             	sub    $0x1c,%esp
  803863:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803867:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80386b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80386f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803873:	89 ca                	mov    %ecx,%edx
  803875:	89 f8                	mov    %edi,%eax
  803877:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80387b:	85 f6                	test   %esi,%esi
  80387d:	75 2d                	jne    8038ac <__udivdi3+0x50>
  80387f:	39 cf                	cmp    %ecx,%edi
  803881:	77 65                	ja     8038e8 <__udivdi3+0x8c>
  803883:	89 fd                	mov    %edi,%ebp
  803885:	85 ff                	test   %edi,%edi
  803887:	75 0b                	jne    803894 <__udivdi3+0x38>
  803889:	b8 01 00 00 00       	mov    $0x1,%eax
  80388e:	31 d2                	xor    %edx,%edx
  803890:	f7 f7                	div    %edi
  803892:	89 c5                	mov    %eax,%ebp
  803894:	31 d2                	xor    %edx,%edx
  803896:	89 c8                	mov    %ecx,%eax
  803898:	f7 f5                	div    %ebp
  80389a:	89 c1                	mov    %eax,%ecx
  80389c:	89 d8                	mov    %ebx,%eax
  80389e:	f7 f5                	div    %ebp
  8038a0:	89 cf                	mov    %ecx,%edi
  8038a2:	89 fa                	mov    %edi,%edx
  8038a4:	83 c4 1c             	add    $0x1c,%esp
  8038a7:	5b                   	pop    %ebx
  8038a8:	5e                   	pop    %esi
  8038a9:	5f                   	pop    %edi
  8038aa:	5d                   	pop    %ebp
  8038ab:	c3                   	ret    
  8038ac:	39 ce                	cmp    %ecx,%esi
  8038ae:	77 28                	ja     8038d8 <__udivdi3+0x7c>
  8038b0:	0f bd fe             	bsr    %esi,%edi
  8038b3:	83 f7 1f             	xor    $0x1f,%edi
  8038b6:	75 40                	jne    8038f8 <__udivdi3+0x9c>
  8038b8:	39 ce                	cmp    %ecx,%esi
  8038ba:	72 0a                	jb     8038c6 <__udivdi3+0x6a>
  8038bc:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8038c0:	0f 87 9e 00 00 00    	ja     803964 <__udivdi3+0x108>
  8038c6:	b8 01 00 00 00       	mov    $0x1,%eax
  8038cb:	89 fa                	mov    %edi,%edx
  8038cd:	83 c4 1c             	add    $0x1c,%esp
  8038d0:	5b                   	pop    %ebx
  8038d1:	5e                   	pop    %esi
  8038d2:	5f                   	pop    %edi
  8038d3:	5d                   	pop    %ebp
  8038d4:	c3                   	ret    
  8038d5:	8d 76 00             	lea    0x0(%esi),%esi
  8038d8:	31 ff                	xor    %edi,%edi
  8038da:	31 c0                	xor    %eax,%eax
  8038dc:	89 fa                	mov    %edi,%edx
  8038de:	83 c4 1c             	add    $0x1c,%esp
  8038e1:	5b                   	pop    %ebx
  8038e2:	5e                   	pop    %esi
  8038e3:	5f                   	pop    %edi
  8038e4:	5d                   	pop    %ebp
  8038e5:	c3                   	ret    
  8038e6:	66 90                	xchg   %ax,%ax
  8038e8:	89 d8                	mov    %ebx,%eax
  8038ea:	f7 f7                	div    %edi
  8038ec:	31 ff                	xor    %edi,%edi
  8038ee:	89 fa                	mov    %edi,%edx
  8038f0:	83 c4 1c             	add    $0x1c,%esp
  8038f3:	5b                   	pop    %ebx
  8038f4:	5e                   	pop    %esi
  8038f5:	5f                   	pop    %edi
  8038f6:	5d                   	pop    %ebp
  8038f7:	c3                   	ret    
  8038f8:	bd 20 00 00 00       	mov    $0x20,%ebp
  8038fd:	89 eb                	mov    %ebp,%ebx
  8038ff:	29 fb                	sub    %edi,%ebx
  803901:	89 f9                	mov    %edi,%ecx
  803903:	d3 e6                	shl    %cl,%esi
  803905:	89 c5                	mov    %eax,%ebp
  803907:	88 d9                	mov    %bl,%cl
  803909:	d3 ed                	shr    %cl,%ebp
  80390b:	89 e9                	mov    %ebp,%ecx
  80390d:	09 f1                	or     %esi,%ecx
  80390f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803913:	89 f9                	mov    %edi,%ecx
  803915:	d3 e0                	shl    %cl,%eax
  803917:	89 c5                	mov    %eax,%ebp
  803919:	89 d6                	mov    %edx,%esi
  80391b:	88 d9                	mov    %bl,%cl
  80391d:	d3 ee                	shr    %cl,%esi
  80391f:	89 f9                	mov    %edi,%ecx
  803921:	d3 e2                	shl    %cl,%edx
  803923:	8b 44 24 08          	mov    0x8(%esp),%eax
  803927:	88 d9                	mov    %bl,%cl
  803929:	d3 e8                	shr    %cl,%eax
  80392b:	09 c2                	or     %eax,%edx
  80392d:	89 d0                	mov    %edx,%eax
  80392f:	89 f2                	mov    %esi,%edx
  803931:	f7 74 24 0c          	divl   0xc(%esp)
  803935:	89 d6                	mov    %edx,%esi
  803937:	89 c3                	mov    %eax,%ebx
  803939:	f7 e5                	mul    %ebp
  80393b:	39 d6                	cmp    %edx,%esi
  80393d:	72 19                	jb     803958 <__udivdi3+0xfc>
  80393f:	74 0b                	je     80394c <__udivdi3+0xf0>
  803941:	89 d8                	mov    %ebx,%eax
  803943:	31 ff                	xor    %edi,%edi
  803945:	e9 58 ff ff ff       	jmp    8038a2 <__udivdi3+0x46>
  80394a:	66 90                	xchg   %ax,%ax
  80394c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803950:	89 f9                	mov    %edi,%ecx
  803952:	d3 e2                	shl    %cl,%edx
  803954:	39 c2                	cmp    %eax,%edx
  803956:	73 e9                	jae    803941 <__udivdi3+0xe5>
  803958:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80395b:	31 ff                	xor    %edi,%edi
  80395d:	e9 40 ff ff ff       	jmp    8038a2 <__udivdi3+0x46>
  803962:	66 90                	xchg   %ax,%ax
  803964:	31 c0                	xor    %eax,%eax
  803966:	e9 37 ff ff ff       	jmp    8038a2 <__udivdi3+0x46>
  80396b:	90                   	nop

0080396c <__umoddi3>:
  80396c:	55                   	push   %ebp
  80396d:	57                   	push   %edi
  80396e:	56                   	push   %esi
  80396f:	53                   	push   %ebx
  803970:	83 ec 1c             	sub    $0x1c,%esp
  803973:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803977:	8b 74 24 34          	mov    0x34(%esp),%esi
  80397b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80397f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803983:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803987:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  80398b:	89 f3                	mov    %esi,%ebx
  80398d:	89 fa                	mov    %edi,%edx
  80398f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803993:	89 34 24             	mov    %esi,(%esp)
  803996:	85 c0                	test   %eax,%eax
  803998:	75 1a                	jne    8039b4 <__umoddi3+0x48>
  80399a:	39 f7                	cmp    %esi,%edi
  80399c:	0f 86 a2 00 00 00    	jbe    803a44 <__umoddi3+0xd8>
  8039a2:	89 c8                	mov    %ecx,%eax
  8039a4:	89 f2                	mov    %esi,%edx
  8039a6:	f7 f7                	div    %edi
  8039a8:	89 d0                	mov    %edx,%eax
  8039aa:	31 d2                	xor    %edx,%edx
  8039ac:	83 c4 1c             	add    $0x1c,%esp
  8039af:	5b                   	pop    %ebx
  8039b0:	5e                   	pop    %esi
  8039b1:	5f                   	pop    %edi
  8039b2:	5d                   	pop    %ebp
  8039b3:	c3                   	ret    
  8039b4:	39 f0                	cmp    %esi,%eax
  8039b6:	0f 87 ac 00 00 00    	ja     803a68 <__umoddi3+0xfc>
  8039bc:	0f bd e8             	bsr    %eax,%ebp
  8039bf:	83 f5 1f             	xor    $0x1f,%ebp
  8039c2:	0f 84 ac 00 00 00    	je     803a74 <__umoddi3+0x108>
  8039c8:	bf 20 00 00 00       	mov    $0x20,%edi
  8039cd:	29 ef                	sub    %ebp,%edi
  8039cf:	89 fe                	mov    %edi,%esi
  8039d1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  8039d5:	89 e9                	mov    %ebp,%ecx
  8039d7:	d3 e0                	shl    %cl,%eax
  8039d9:	89 d7                	mov    %edx,%edi
  8039db:	89 f1                	mov    %esi,%ecx
  8039dd:	d3 ef                	shr    %cl,%edi
  8039df:	09 c7                	or     %eax,%edi
  8039e1:	89 e9                	mov    %ebp,%ecx
  8039e3:	d3 e2                	shl    %cl,%edx
  8039e5:	89 14 24             	mov    %edx,(%esp)
  8039e8:	89 d8                	mov    %ebx,%eax
  8039ea:	d3 e0                	shl    %cl,%eax
  8039ec:	89 c2                	mov    %eax,%edx
  8039ee:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039f2:	d3 e0                	shl    %cl,%eax
  8039f4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8039f8:	8b 44 24 08          	mov    0x8(%esp),%eax
  8039fc:	89 f1                	mov    %esi,%ecx
  8039fe:	d3 e8                	shr    %cl,%eax
  803a00:	09 d0                	or     %edx,%eax
  803a02:	d3 eb                	shr    %cl,%ebx
  803a04:	89 da                	mov    %ebx,%edx
  803a06:	f7 f7                	div    %edi
  803a08:	89 d3                	mov    %edx,%ebx
  803a0a:	f7 24 24             	mull   (%esp)
  803a0d:	89 c6                	mov    %eax,%esi
  803a0f:	89 d1                	mov    %edx,%ecx
  803a11:	39 d3                	cmp    %edx,%ebx
  803a13:	0f 82 87 00 00 00    	jb     803aa0 <__umoddi3+0x134>
  803a19:	0f 84 91 00 00 00    	je     803ab0 <__umoddi3+0x144>
  803a1f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803a23:	29 f2                	sub    %esi,%edx
  803a25:	19 cb                	sbb    %ecx,%ebx
  803a27:	89 d8                	mov    %ebx,%eax
  803a29:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803a2d:	d3 e0                	shl    %cl,%eax
  803a2f:	89 e9                	mov    %ebp,%ecx
  803a31:	d3 ea                	shr    %cl,%edx
  803a33:	09 d0                	or     %edx,%eax
  803a35:	89 e9                	mov    %ebp,%ecx
  803a37:	d3 eb                	shr    %cl,%ebx
  803a39:	89 da                	mov    %ebx,%edx
  803a3b:	83 c4 1c             	add    $0x1c,%esp
  803a3e:	5b                   	pop    %ebx
  803a3f:	5e                   	pop    %esi
  803a40:	5f                   	pop    %edi
  803a41:	5d                   	pop    %ebp
  803a42:	c3                   	ret    
  803a43:	90                   	nop
  803a44:	89 fd                	mov    %edi,%ebp
  803a46:	85 ff                	test   %edi,%edi
  803a48:	75 0b                	jne    803a55 <__umoddi3+0xe9>
  803a4a:	b8 01 00 00 00       	mov    $0x1,%eax
  803a4f:	31 d2                	xor    %edx,%edx
  803a51:	f7 f7                	div    %edi
  803a53:	89 c5                	mov    %eax,%ebp
  803a55:	89 f0                	mov    %esi,%eax
  803a57:	31 d2                	xor    %edx,%edx
  803a59:	f7 f5                	div    %ebp
  803a5b:	89 c8                	mov    %ecx,%eax
  803a5d:	f7 f5                	div    %ebp
  803a5f:	89 d0                	mov    %edx,%eax
  803a61:	e9 44 ff ff ff       	jmp    8039aa <__umoddi3+0x3e>
  803a66:	66 90                	xchg   %ax,%ax
  803a68:	89 c8                	mov    %ecx,%eax
  803a6a:	89 f2                	mov    %esi,%edx
  803a6c:	83 c4 1c             	add    $0x1c,%esp
  803a6f:	5b                   	pop    %ebx
  803a70:	5e                   	pop    %esi
  803a71:	5f                   	pop    %edi
  803a72:	5d                   	pop    %ebp
  803a73:	c3                   	ret    
  803a74:	3b 04 24             	cmp    (%esp),%eax
  803a77:	72 06                	jb     803a7f <__umoddi3+0x113>
  803a79:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803a7d:	77 0f                	ja     803a8e <__umoddi3+0x122>
  803a7f:	89 f2                	mov    %esi,%edx
  803a81:	29 f9                	sub    %edi,%ecx
  803a83:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803a87:	89 14 24             	mov    %edx,(%esp)
  803a8a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a8e:	8b 44 24 04          	mov    0x4(%esp),%eax
  803a92:	8b 14 24             	mov    (%esp),%edx
  803a95:	83 c4 1c             	add    $0x1c,%esp
  803a98:	5b                   	pop    %ebx
  803a99:	5e                   	pop    %esi
  803a9a:	5f                   	pop    %edi
  803a9b:	5d                   	pop    %ebp
  803a9c:	c3                   	ret    
  803a9d:	8d 76 00             	lea    0x0(%esi),%esi
  803aa0:	2b 04 24             	sub    (%esp),%eax
  803aa3:	19 fa                	sbb    %edi,%edx
  803aa5:	89 d1                	mov    %edx,%ecx
  803aa7:	89 c6                	mov    %eax,%esi
  803aa9:	e9 71 ff ff ff       	jmp    803a1f <__umoddi3+0xb3>
  803aae:	66 90                	xchg   %ax,%ax
  803ab0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803ab4:	72 ea                	jb     803aa0 <__umoddi3+0x134>
  803ab6:	89 d9                	mov    %ebx,%ecx
  803ab8:	e9 62 ff ff ff       	jmp    803a1f <__umoddi3+0xb3>
