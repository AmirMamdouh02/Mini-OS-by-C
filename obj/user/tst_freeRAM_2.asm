
obj/user/tst_freeRAM_2:     file format elf32-i386


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
  800031:	e8 ac 05 00 00       	call   8005e2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
	char a;
	short b;
	int c;
};
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec b0 00 00 00    	sub    $0xb0,%esp





	int Mega = 1024*1024;
  800043:	c7 45 f4 00 00 10 00 	movl   $0x100000,-0xc(%ebp)
	int kilo = 1024;
  80004a:	c7 45 f0 00 04 00 00 	movl   $0x400,-0x10(%ebp)
	char minByte = 1<<7;
  800051:	c6 45 ef 80          	movb   $0x80,-0x11(%ebp)
	char maxByte = 0x7F;
  800055:	c6 45 ee 7f          	movb   $0x7f,-0x12(%ebp)
	short minShort = 1<<15 ;
  800059:	66 c7 45 ec 00 80    	movw   $0x8000,-0x14(%ebp)
	short maxShort = 0x7FFF;
  80005f:	66 c7 45 ea ff 7f    	movw   $0x7fff,-0x16(%ebp)
	int minInt = 1<<31 ;
  800065:	c7 45 e4 00 00 00 80 	movl   $0x80000000,-0x1c(%ebp)
	int maxInt = 0x7FFFFFFF;
  80006c:	c7 45 e0 ff ff ff 7f 	movl   $0x7fffffff,-0x20(%ebp)

	void* ptr_allocations[20] = {0};
  800073:	8d 95 4c ff ff ff    	lea    -0xb4(%ebp),%edx
  800079:	b9 14 00 00 00       	mov    $0x14,%ecx
  80007e:	b8 00 00 00 00       	mov    $0x0,%eax
  800083:	89 d7                	mov    %edx,%edi
  800085:	f3 ab                	rep stos %eax,%es:(%edi)
	{
		//Load "fib" & "fos_helloWorld" programs into RAM
		cprintf("Loading Fib & fos_helloWorld programs into RAM...");
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	68 00 38 80 00       	push   $0x803800
  80008f:	e8 3e 09 00 00       	call   8009d2 <cprintf>
  800094:	83 c4 10             	add    $0x10,%esp
		int32 envIdFib = sys_create_env("fib", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  800097:	a1 20 50 80 00       	mov    0x805020,%eax
  80009c:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000a2:	a1 20 50 80 00       	mov    0x805020,%eax
  8000a7:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000ad:	89 c1                	mov    %eax,%ecx
  8000af:	a1 20 50 80 00       	mov    0x805020,%eax
  8000b4:	8b 40 74             	mov    0x74(%eax),%eax
  8000b7:	52                   	push   %edx
  8000b8:	51                   	push   %ecx
  8000b9:	50                   	push   %eax
  8000ba:	68 32 38 80 00       	push   $0x803832
  8000bf:	e8 bd 1f 00 00       	call   802081 <sys_create_env>
  8000c4:	83 c4 10             	add    $0x10,%esp
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
		int freeFrames = sys_calculate_free_frames() ;
  8000ca:	e8 40 1d 00 00       	call   801e0f <sys_calculate_free_frames>
  8000cf:	89 45 d8             	mov    %eax,-0x28(%ebp)
		int32 envIdHelloWorld = sys_create_env("fos_helloWorld", (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8000d2:	a1 20 50 80 00       	mov    0x805020,%eax
  8000d7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8000dd:	a1 20 50 80 00       	mov    0x805020,%eax
  8000e2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8000e8:	89 c1                	mov    %eax,%ecx
  8000ea:	a1 20 50 80 00       	mov    0x805020,%eax
  8000ef:	8b 40 74             	mov    0x74(%eax),%eax
  8000f2:	52                   	push   %edx
  8000f3:	51                   	push   %ecx
  8000f4:	50                   	push   %eax
  8000f5:	68 36 38 80 00       	push   $0x803836
  8000fa:	e8 82 1f 00 00       	call   802081 <sys_create_env>
  8000ff:	83 c4 10             	add    $0x10,%esp
  800102:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		int helloWorldFrames = freeFrames - sys_calculate_free_frames() ;
  800105:	8b 5d d8             	mov    -0x28(%ebp),%ebx
  800108:	e8 02 1d 00 00       	call   801e0f <sys_calculate_free_frames>
  80010d:	29 c3                	sub    %eax,%ebx
  80010f:	89 d8                	mov    %ebx,%eax
  800111:	89 45 d0             	mov    %eax,-0x30(%ebp)
		env_sleep(2000);
  800114:	83 ec 0c             	sub    $0xc,%esp
  800117:	68 d0 07 00 00       	push   $0x7d0
  80011c:	e8 b5 33 00 00       	call   8034d6 <env_sleep>
  800121:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800124:	83 ec 0c             	sub    $0xc,%esp
  800127:	68 45 38 80 00       	push   $0x803845
  80012c:	e8 a1 08 00 00       	call   8009d2 <cprintf>
  800131:	83 c4 10             	add    $0x10,%esp

		//Load and run "fos_add"
		cprintf("Loading fos_add program into RAM...");
  800134:	83 ec 0c             	sub    $0xc,%esp
  800137:	68 50 38 80 00       	push   $0x803850
  80013c:	e8 91 08 00 00       	call   8009d2 <cprintf>
  800141:	83 c4 10             	add    $0x10,%esp
		int32 envIdFOSAdd= sys_create_env("fos_add", (myEnv->page_WS_max_size), (myEnv->SecondListSize),(myEnv->percentage_of_WS_pages_to_be_removed));
  800144:	a1 20 50 80 00       	mov    0x805020,%eax
  800149:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  80014f:	a1 20 50 80 00       	mov    0x805020,%eax
  800154:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  80015a:	89 c1                	mov    %eax,%ecx
  80015c:	a1 20 50 80 00       	mov    0x805020,%eax
  800161:	8b 40 74             	mov    0x74(%eax),%eax
  800164:	52                   	push   %edx
  800165:	51                   	push   %ecx
  800166:	50                   	push   %eax
  800167:	68 74 38 80 00       	push   $0x803874
  80016c:	e8 10 1f 00 00       	call   802081 <sys_create_env>
  800171:	83 c4 10             	add    $0x10,%esp
  800174:	89 45 cc             	mov    %eax,-0x34(%ebp)
		env_sleep(2000);
  800177:	83 ec 0c             	sub    $0xc,%esp
  80017a:	68 d0 07 00 00       	push   $0x7d0
  80017f:	e8 52 33 00 00       	call   8034d6 <env_sleep>
  800184:	83 c4 10             	add    $0x10,%esp
		cprintf("[DONE]\n\n");
  800187:	83 ec 0c             	sub    $0xc,%esp
  80018a:	68 45 38 80 00       	push   $0x803845
  80018f:	e8 3e 08 00 00       	call   8009d2 <cprintf>
  800194:	83 c4 10             	add    $0x10,%esp
		cprintf("running fos_add program...\n\n");
  800197:	83 ec 0c             	sub    $0xc,%esp
  80019a:	68 7c 38 80 00       	push   $0x80387c
  80019f:	e8 2e 08 00 00       	call   8009d2 <cprintf>
  8001a4:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdFOSAdd);
  8001a7:	83 ec 0c             	sub    $0xc,%esp
  8001aa:	ff 75 cc             	pushl  -0x34(%ebp)
  8001ad:	e8 ed 1e 00 00       	call   80209f <sys_run_env>
  8001b2:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  8001b5:	83 ec 0c             	sub    $0xc,%esp
  8001b8:	68 99 38 80 00       	push   $0x803899
  8001bd:	e8 10 08 00 00       	call   8009d2 <cprintf>
  8001c2:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 88 13 00 00       	push   $0x1388
  8001cd:	e8 04 33 00 00       	call   8034d6 <env_sleep>
  8001d2:	83 c4 10             	add    $0x10,%esp

		//Allocate 2 MB
		ptr_allocations[0] = malloc(2*Mega-kilo);
  8001d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001d8:	01 c0                	add    %eax,%eax
  8001da:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8001dd:	83 ec 0c             	sub    $0xc,%esp
  8001e0:	50                   	push   %eax
  8001e1:	e8 8b 17 00 00       	call   801971 <malloc>
  8001e6:	83 c4 10             	add    $0x10,%esp
  8001e9:	89 85 4c ff ff ff    	mov    %eax,-0xb4(%ebp)
		char *byteArr = (char *) ptr_allocations[0];
  8001ef:	8b 85 4c ff ff ff    	mov    -0xb4(%ebp),%eax
  8001f5:	89 45 c8             	mov    %eax,-0x38(%ebp)
		int lastIndexOfByte = (2*Mega-kilo)/sizeof(char) - 1;
  8001f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8001fb:	01 c0                	add    %eax,%eax
  8001fd:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800200:	48                   	dec    %eax
  800201:	89 45 c4             	mov    %eax,-0x3c(%ebp)
		byteArr[0] = minByte ;
  800204:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800207:	8a 55 ef             	mov    -0x11(%ebp),%dl
  80020a:	88 10                	mov    %dl,(%eax)
		byteArr[lastIndexOfByte] = maxByte ;
  80020c:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80020f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800212:	01 c2                	add    %eax,%edx
  800214:	8a 45 ee             	mov    -0x12(%ebp),%al
  800217:	88 02                	mov    %al,(%edx)

		//Allocate another 2 MB
		ptr_allocations[1] = malloc(2*Mega-kilo);
  800219:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80021c:	01 c0                	add    %eax,%eax
  80021e:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 47 17 00 00       	call   801971 <malloc>
  80022a:	83 c4 10             	add    $0x10,%esp
  80022d:	89 85 50 ff ff ff    	mov    %eax,-0xb0(%ebp)
		short *shortArr = (short *) ptr_allocations[1];
  800233:	8b 85 50 ff ff ff    	mov    -0xb0(%ebp),%eax
  800239:	89 45 c0             	mov    %eax,-0x40(%ebp)
		int lastIndexOfShort = (2*Mega-kilo)/sizeof(short) - 1;
  80023c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80023f:	01 c0                	add    %eax,%eax
  800241:	2b 45 f0             	sub    -0x10(%ebp),%eax
  800244:	d1 e8                	shr    %eax
  800246:	48                   	dec    %eax
  800247:	89 45 bc             	mov    %eax,-0x44(%ebp)
		shortArr[0] = minShort;
  80024a:	8b 55 c0             	mov    -0x40(%ebp),%edx
  80024d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800250:	66 89 02             	mov    %ax,(%edx)
		shortArr[lastIndexOfShort] = maxShort;
  800253:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800256:	01 c0                	add    %eax,%eax
  800258:	89 c2                	mov    %eax,%edx
  80025a:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80025d:	01 c2                	add    %eax,%edx
  80025f:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800263:	66 89 02             	mov    %ax,(%edx)

		//Allocate all remaining RAM (Here: it requires to free some RAM by removing exited program (fos_add))
		freeFrames = sys_calculate_free_frames() ;
  800266:	e8 a4 1b 00 00       	call   801e0f <sys_calculate_free_frames>
  80026b:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[2] = malloc(freeFrames*PAGE_SIZE);
  80026e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800271:	c1 e0 0c             	shl    $0xc,%eax
  800274:	83 ec 0c             	sub    $0xc,%esp
  800277:	50                   	push   %eax
  800278:	e8 f4 16 00 00       	call   801971 <malloc>
  80027d:	83 c4 10             	add    $0x10,%esp
  800280:	89 85 54 ff ff ff    	mov    %eax,-0xac(%ebp)
		int *intArr = (int *) ptr_allocations[2];
  800286:	8b 85 54 ff ff ff    	mov    -0xac(%ebp),%eax
  80028c:	89 45 b8             	mov    %eax,-0x48(%ebp)
		int lastIndexOfInt = (freeFrames*PAGE_SIZE)/sizeof(int) - 1;
  80028f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800292:	c1 e0 0c             	shl    $0xc,%eax
  800295:	c1 e8 02             	shr    $0x2,%eax
  800298:	48                   	dec    %eax
  800299:	89 45 b4             	mov    %eax,-0x4c(%ebp)
		intArr[0] = minInt;
  80029c:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80029f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8002a2:	89 10                	mov    %edx,(%eax)
		intArr[lastIndexOfInt] = maxInt;
  8002a4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8002b1:	01 c2                	add    %eax,%edx
  8002b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002b6:	89 02                	mov    %eax,(%edx)

		//Allocate 7 KB after freeing some RAM
		ptr_allocations[3] = malloc(7*kilo);
  8002b8:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002bb:	89 d0                	mov    %edx,%eax
  8002bd:	01 c0                	add    %eax,%eax
  8002bf:	01 d0                	add    %edx,%eax
  8002c1:	01 c0                	add    %eax,%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	83 ec 0c             	sub    $0xc,%esp
  8002c8:	50                   	push   %eax
  8002c9:	e8 a3 16 00 00       	call   801971 <malloc>
  8002ce:	83 c4 10             	add    $0x10,%esp
  8002d1:	89 85 58 ff ff ff    	mov    %eax,-0xa8(%ebp)
		struct MyStruct *structArr = (struct MyStruct *) ptr_allocations[3];
  8002d7:	8b 85 58 ff ff ff    	mov    -0xa8(%ebp),%eax
  8002dd:	89 45 b0             	mov    %eax,-0x50(%ebp)
		int lastIndexOfStruct = (7*kilo)/sizeof(struct MyStruct) - 1;
  8002e0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8002e3:	89 d0                	mov    %edx,%eax
  8002e5:	01 c0                	add    %eax,%eax
  8002e7:	01 d0                	add    %edx,%eax
  8002e9:	01 c0                	add    %eax,%eax
  8002eb:	01 d0                	add    %edx,%eax
  8002ed:	c1 e8 03             	shr    $0x3,%eax
  8002f0:	48                   	dec    %eax
  8002f1:	89 45 ac             	mov    %eax,-0x54(%ebp)
		structArr[0].a = minByte; structArr[0].b = minShort; structArr[0].c = minInt;
  8002f4:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002f7:	8a 55 ef             	mov    -0x11(%ebp),%dl
  8002fa:	88 10                	mov    %dl,(%eax)
  8002fc:	8b 55 b0             	mov    -0x50(%ebp),%edx
  8002ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800302:	66 89 42 02          	mov    %ax,0x2(%edx)
  800306:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800309:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80030c:	89 50 04             	mov    %edx,0x4(%eax)
		structArr[lastIndexOfStruct].a = maxByte; structArr[lastIndexOfStruct].b = maxShort; structArr[lastIndexOfStruct].c = maxInt;
  80030f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800312:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800319:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80031c:	01 c2                	add    %eax,%edx
  80031e:	8a 45 ee             	mov    -0x12(%ebp),%al
  800321:	88 02                	mov    %al,(%edx)
  800323:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800326:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80032d:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800330:	01 c2                	add    %eax,%edx
  800332:	66 8b 45 ea          	mov    -0x16(%ebp),%ax
  800336:	66 89 42 02          	mov    %ax,0x2(%edx)
  80033a:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80033d:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800344:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800347:	01 c2                	add    %eax,%edx
  800349:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80034c:	89 42 04             	mov    %eax,0x4(%edx)

		cprintf("running fos_helloWorld program...\n\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 b0 38 80 00       	push   $0x8038b0
  800357:	e8 76 06 00 00       	call   8009d2 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp
		sys_run_env(envIdHelloWorld);
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	ff 75 d4             	pushl  -0x2c(%ebp)
  800365:	e8 35 1d 00 00       	call   80209f <sys_run_env>
  80036a:	83 c4 10             	add    $0x10,%esp

		cprintf("please be patient ...\n");
  80036d:	83 ec 0c             	sub    $0xc,%esp
  800370:	68 99 38 80 00       	push   $0x803899
  800375:	e8 58 06 00 00       	call   8009d2 <cprintf>
  80037a:	83 c4 10             	add    $0x10,%esp
		env_sleep(5000);
  80037d:	83 ec 0c             	sub    $0xc,%esp
  800380:	68 88 13 00 00       	push   $0x1388
  800385:	e8 4c 31 00 00       	call   8034d6 <env_sleep>
  80038a:	83 c4 10             	add    $0x10,%esp

		//Allocate the remaining RAM + extra RAM by the size of helloWorld program (Here: it requires to free some RAM by removing exited & loaded program(s) (fos_helloWorld & fib))
		freeFrames = sys_calculate_free_frames() ;
  80038d:	e8 7d 1a 00 00       	call   801e0f <sys_calculate_free_frames>
  800392:	89 45 d8             	mov    %eax,-0x28(%ebp)
		ptr_allocations[4] = malloc((freeFrames + helloWorldFrames)*PAGE_SIZE);
  800395:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800398:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80039b:	01 d0                	add    %edx,%eax
  80039d:	c1 e0 0c             	shl    $0xc,%eax
  8003a0:	83 ec 0c             	sub    $0xc,%esp
  8003a3:	50                   	push   %eax
  8003a4:	e8 c8 15 00 00       	call   801971 <malloc>
  8003a9:	83 c4 10             	add    $0x10,%esp
  8003ac:	89 85 5c ff ff ff    	mov    %eax,-0xa4(%ebp)
		int *intArr2 = (int *) ptr_allocations[4];
  8003b2:	8b 85 5c ff ff ff    	mov    -0xa4(%ebp),%eax
  8003b8:	89 45 a8             	mov    %eax,-0x58(%ebp)
		int lastIndexOfInt2 = ((freeFrames + helloWorldFrames)*PAGE_SIZE)/sizeof(int) - 1;
  8003bb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8003be:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003c1:	01 d0                	add    %edx,%eax
  8003c3:	c1 e0 0c             	shl    $0xc,%eax
  8003c6:	c1 e8 02             	shr    $0x2,%eax
  8003c9:	48                   	dec    %eax
  8003ca:	89 45 a4             	mov    %eax,-0x5c(%ebp)
		intArr2[0] = minInt;
  8003cd:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003d0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8003d3:	89 10                	mov    %edx,(%eax)
		intArr2[lastIndexOfInt2] = maxInt;
  8003d5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8003d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003df:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8003e2:	01 c2                	add    %eax,%edx
  8003e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003e7:	89 02                	mov    %eax,(%edx)

		//Allocate 8 B after freeing the RAM
		ptr_allocations[5] = malloc(8);
  8003e9:	83 ec 0c             	sub    $0xc,%esp
  8003ec:	6a 08                	push   $0x8
  8003ee:	e8 7e 15 00 00       	call   801971 <malloc>
  8003f3:	83 c4 10             	add    $0x10,%esp
  8003f6:	89 85 60 ff ff ff    	mov    %eax,-0xa0(%ebp)
		int *intArr3 = (int *) ptr_allocations[5];
  8003fc:	8b 85 60 ff ff ff    	mov    -0xa0(%ebp),%eax
  800402:	89 45 a0             	mov    %eax,-0x60(%ebp)
		int lastIndexOfInt3 = 8/sizeof(int) - 1;
  800405:	c7 45 9c 01 00 00 00 	movl   $0x1,-0x64(%ebp)
		intArr3[0] = minInt;
  80040c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80040f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800412:	89 10                	mov    %edx,(%eax)
		intArr3[lastIndexOfInt3] = maxInt;
  800414:	8b 45 9c             	mov    -0x64(%ebp),%eax
  800417:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80041e:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800421:	01 c2                	add    %eax,%edx
  800423:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800426:	89 02                	mov    %eax,(%edx)

		//Check that the values are successfully stored
		if (byteArr[0] 	!= minByte 	|| byteArr[lastIndexOfByte] 	!= maxByte) panic("Wrong allocation: stored values are wrongly changed!");
  800428:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80042b:	8a 00                	mov    (%eax),%al
  80042d:	3a 45 ef             	cmp    -0x11(%ebp),%al
  800430:	75 0f                	jne    800441 <_main+0x409>
  800432:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800435:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800438:	01 d0                	add    %edx,%eax
  80043a:	8a 00                	mov    (%eax),%al
  80043c:	3a 45 ee             	cmp    -0x12(%ebp),%al
  80043f:	74 14                	je     800455 <_main+0x41d>
  800441:	83 ec 04             	sub    $0x4,%esp
  800444:	68 d4 38 80 00       	push   $0x8038d4
  800449:	6a 62                	push   $0x62
  80044b:	68 09 39 80 00       	push   $0x803909
  800450:	e8 c9 02 00 00       	call   80071e <_panic>
		if (shortArr[0] != minShort || shortArr[lastIndexOfShort] 	!= maxShort) panic("Wrong allocation: stored values are wrongly changed!");
  800455:	8b 45 c0             	mov    -0x40(%ebp),%eax
  800458:	66 8b 00             	mov    (%eax),%ax
  80045b:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  80045f:	75 15                	jne    800476 <_main+0x43e>
  800461:	8b 45 bc             	mov    -0x44(%ebp),%eax
  800464:	01 c0                	add    %eax,%eax
  800466:	89 c2                	mov    %eax,%edx
  800468:	8b 45 c0             	mov    -0x40(%ebp),%eax
  80046b:	01 d0                	add    %edx,%eax
  80046d:	66 8b 00             	mov    (%eax),%ax
  800470:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  800474:	74 14                	je     80048a <_main+0x452>
  800476:	83 ec 04             	sub    $0x4,%esp
  800479:	68 d4 38 80 00       	push   $0x8038d4
  80047e:	6a 63                	push   $0x63
  800480:	68 09 39 80 00       	push   $0x803909
  800485:	e8 94 02 00 00       	call   80071e <_panic>
		if (intArr[0] 	!= minInt 	|| intArr[lastIndexOfInt] 		!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  80048a:	8b 45 b8             	mov    -0x48(%ebp),%eax
  80048d:	8b 00                	mov    (%eax),%eax
  80048f:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800492:	75 16                	jne    8004aa <_main+0x472>
  800494:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  800497:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80049e:	8b 45 b8             	mov    -0x48(%ebp),%eax
  8004a1:	01 d0                	add    %edx,%eax
  8004a3:	8b 00                	mov    (%eax),%eax
  8004a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004a8:	74 14                	je     8004be <_main+0x486>
  8004aa:	83 ec 04             	sub    $0x4,%esp
  8004ad:	68 d4 38 80 00       	push   $0x8038d4
  8004b2:	6a 64                	push   $0x64
  8004b4:	68 09 39 80 00       	push   $0x803909
  8004b9:	e8 60 02 00 00       	call   80071e <_panic>
		if (intArr2[0] 	!= minInt 	|| intArr2[lastIndexOfInt2] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004be:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004c1:	8b 00                	mov    (%eax),%eax
  8004c3:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004c6:	75 16                	jne    8004de <_main+0x4a6>
  8004c8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  8004cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004d2:	8b 45 a8             	mov    -0x58(%ebp),%eax
  8004d5:	01 d0                	add    %edx,%eax
  8004d7:	8b 00                	mov    (%eax),%eax
  8004d9:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8004dc:	74 14                	je     8004f2 <_main+0x4ba>
  8004de:	83 ec 04             	sub    $0x4,%esp
  8004e1:	68 d4 38 80 00       	push   $0x8038d4
  8004e6:	6a 65                	push   $0x65
  8004e8:	68 09 39 80 00       	push   $0x803909
  8004ed:	e8 2c 02 00 00       	call   80071e <_panic>
		if (intArr3[0] 	!= minInt 	|| intArr3[lastIndexOfInt3] 	!= maxInt) panic("Wrong allocation: stored values are wrongly changed!");
  8004f2:	8b 45 a0             	mov    -0x60(%ebp),%eax
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8004fa:	75 16                	jne    800512 <_main+0x4da>
  8004fc:	8b 45 9c             	mov    -0x64(%ebp),%eax
  8004ff:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800506:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800509:	01 d0                	add    %edx,%eax
  80050b:	8b 00                	mov    (%eax),%eax
  80050d:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  800510:	74 14                	je     800526 <_main+0x4ee>
  800512:	83 ec 04             	sub    $0x4,%esp
  800515:	68 d4 38 80 00       	push   $0x8038d4
  80051a:	6a 66                	push   $0x66
  80051c:	68 09 39 80 00       	push   $0x803909
  800521:	e8 f8 01 00 00       	call   80071e <_panic>

		if (structArr[0].a != minByte 	|| structArr[lastIndexOfStruct].a != maxByte) 	panic("Wrong allocation: stored values are wrongly changed!");
  800526:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800529:	8a 00                	mov    (%eax),%al
  80052b:	3a 45 ef             	cmp    -0x11(%ebp),%al
  80052e:	75 16                	jne    800546 <_main+0x50e>
  800530:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800533:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  80053a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80053d:	01 d0                	add    %edx,%eax
  80053f:	8a 00                	mov    (%eax),%al
  800541:	3a 45 ee             	cmp    -0x12(%ebp),%al
  800544:	74 14                	je     80055a <_main+0x522>
  800546:	83 ec 04             	sub    $0x4,%esp
  800549:	68 d4 38 80 00       	push   $0x8038d4
  80054e:	6a 68                	push   $0x68
  800550:	68 09 39 80 00       	push   $0x803909
  800555:	e8 c4 01 00 00       	call   80071e <_panic>
		if (structArr[0].b != minShort 	|| structArr[lastIndexOfStruct].b != maxShort) 	panic("Wrong allocation: stored values are wrongly changed!");
  80055a:	8b 45 b0             	mov    -0x50(%ebp),%eax
  80055d:	66 8b 40 02          	mov    0x2(%eax),%ax
  800561:	66 3b 45 ec          	cmp    -0x14(%ebp),%ax
  800565:	75 19                	jne    800580 <_main+0x548>
  800567:	8b 45 ac             	mov    -0x54(%ebp),%eax
  80056a:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  800571:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800574:	01 d0                	add    %edx,%eax
  800576:	66 8b 40 02          	mov    0x2(%eax),%ax
  80057a:	66 3b 45 ea          	cmp    -0x16(%ebp),%ax
  80057e:	74 14                	je     800594 <_main+0x55c>
  800580:	83 ec 04             	sub    $0x4,%esp
  800583:	68 d4 38 80 00       	push   $0x8038d4
  800588:	6a 69                	push   $0x69
  80058a:	68 09 39 80 00       	push   $0x803909
  80058f:	e8 8a 01 00 00       	call   80071e <_panic>
		if (structArr[0].c != minInt 	|| structArr[lastIndexOfStruct].c != maxInt) 	panic("Wrong allocation: stored values are wrongly changed!");
  800594:	8b 45 b0             	mov    -0x50(%ebp),%eax
  800597:	8b 40 04             	mov    0x4(%eax),%eax
  80059a:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80059d:	75 17                	jne    8005b6 <_main+0x57e>
  80059f:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8005a2:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
  8005a9:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8005ac:	01 d0                	add    %edx,%eax
  8005ae:	8b 40 04             	mov    0x4(%eax),%eax
  8005b1:	3b 45 e0             	cmp    -0x20(%ebp),%eax
  8005b4:	74 14                	je     8005ca <_main+0x592>
  8005b6:	83 ec 04             	sub    $0x4,%esp
  8005b9:	68 d4 38 80 00       	push   $0x8038d4
  8005be:	6a 6a                	push   $0x6a
  8005c0:	68 09 39 80 00       	push   $0x803909
  8005c5:	e8 54 01 00 00       	call   80071e <_panic>


	}

	cprintf("Congratulations!! test freeRAM (1) completed successfully.\n");
  8005ca:	83 ec 0c             	sub    $0xc,%esp
  8005cd:	68 20 39 80 00       	push   $0x803920
  8005d2:	e8 fb 03 00 00       	call   8009d2 <cprintf>
  8005d7:	83 c4 10             	add    $0x10,%esp

	return;
  8005da:	90                   	nop
}
  8005db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8005de:	5b                   	pop    %ebx
  8005df:	5f                   	pop    %edi
  8005e0:	5d                   	pop    %ebp
  8005e1:	c3                   	ret    

008005e2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005e2:	55                   	push   %ebp
  8005e3:	89 e5                	mov    %esp,%ebp
  8005e5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005e8:	e8 02 1b 00 00       	call   8020ef <sys_getenvindex>
  8005ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005f3:	89 d0                	mov    %edx,%eax
  8005f5:	c1 e0 03             	shl    $0x3,%eax
  8005f8:	01 d0                	add    %edx,%eax
  8005fa:	01 c0                	add    %eax,%eax
  8005fc:	01 d0                	add    %edx,%eax
  8005fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800605:	01 d0                	add    %edx,%eax
  800607:	c1 e0 04             	shl    $0x4,%eax
  80060a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80060f:	a3 20 50 80 00       	mov    %eax,0x805020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800614:	a1 20 50 80 00       	mov    0x805020,%eax
  800619:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80061f:	84 c0                	test   %al,%al
  800621:	74 0f                	je     800632 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800623:	a1 20 50 80 00       	mov    0x805020,%eax
  800628:	05 5c 05 00 00       	add    $0x55c,%eax
  80062d:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800632:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800636:	7e 0a                	jle    800642 <libmain+0x60>
		binaryname = argv[0];
  800638:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063b:	8b 00                	mov    (%eax),%eax
  80063d:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  800642:	83 ec 08             	sub    $0x8,%esp
  800645:	ff 75 0c             	pushl  0xc(%ebp)
  800648:	ff 75 08             	pushl  0x8(%ebp)
  80064b:	e8 e8 f9 ff ff       	call   800038 <_main>
  800650:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800653:	e8 a4 18 00 00       	call   801efc <sys_disable_interrupt>
	cprintf("**************************************\n");
  800658:	83 ec 0c             	sub    $0xc,%esp
  80065b:	68 74 39 80 00       	push   $0x803974
  800660:	e8 6d 03 00 00       	call   8009d2 <cprintf>
  800665:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800668:	a1 20 50 80 00       	mov    0x805020,%eax
  80066d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800673:	a1 20 50 80 00       	mov    0x805020,%eax
  800678:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80067e:	83 ec 04             	sub    $0x4,%esp
  800681:	52                   	push   %edx
  800682:	50                   	push   %eax
  800683:	68 9c 39 80 00       	push   $0x80399c
  800688:	e8 45 03 00 00       	call   8009d2 <cprintf>
  80068d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800690:	a1 20 50 80 00       	mov    0x805020,%eax
  800695:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80069b:	a1 20 50 80 00       	mov    0x805020,%eax
  8006a0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006a6:	a1 20 50 80 00       	mov    0x805020,%eax
  8006ab:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b1:	51                   	push   %ecx
  8006b2:	52                   	push   %edx
  8006b3:	50                   	push   %eax
  8006b4:	68 c4 39 80 00       	push   $0x8039c4
  8006b9:	e8 14 03 00 00       	call   8009d2 <cprintf>
  8006be:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c1:	a1 20 50 80 00       	mov    0x805020,%eax
  8006c6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006cc:	83 ec 08             	sub    $0x8,%esp
  8006cf:	50                   	push   %eax
  8006d0:	68 1c 3a 80 00       	push   $0x803a1c
  8006d5:	e8 f8 02 00 00       	call   8009d2 <cprintf>
  8006da:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006dd:	83 ec 0c             	sub    $0xc,%esp
  8006e0:	68 74 39 80 00       	push   $0x803974
  8006e5:	e8 e8 02 00 00       	call   8009d2 <cprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006ed:	e8 24 18 00 00       	call   801f16 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006f2:	e8 19 00 00 00       	call   800710 <exit>
}
  8006f7:	90                   	nop
  8006f8:	c9                   	leave  
  8006f9:	c3                   	ret    

008006fa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800700:	83 ec 0c             	sub    $0xc,%esp
  800703:	6a 00                	push   $0x0
  800705:	e8 b1 19 00 00       	call   8020bb <sys_destroy_env>
  80070a:	83 c4 10             	add    $0x10,%esp
}
  80070d:	90                   	nop
  80070e:	c9                   	leave  
  80070f:	c3                   	ret    

00800710 <exit>:

void
exit(void)
{
  800710:	55                   	push   %ebp
  800711:	89 e5                	mov    %esp,%ebp
  800713:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800716:	e8 06 1a 00 00       	call   802121 <sys_exit_env>
}
  80071b:	90                   	nop
  80071c:	c9                   	leave  
  80071d:	c3                   	ret    

0080071e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80071e:	55                   	push   %ebp
  80071f:	89 e5                	mov    %esp,%ebp
  800721:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800724:	8d 45 10             	lea    0x10(%ebp),%eax
  800727:	83 c0 04             	add    $0x4,%eax
  80072a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80072d:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800732:	85 c0                	test   %eax,%eax
  800734:	74 16                	je     80074c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800736:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80073b:	83 ec 08             	sub    $0x8,%esp
  80073e:	50                   	push   %eax
  80073f:	68 30 3a 80 00       	push   $0x803a30
  800744:	e8 89 02 00 00       	call   8009d2 <cprintf>
  800749:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80074c:	a1 00 50 80 00       	mov    0x805000,%eax
  800751:	ff 75 0c             	pushl  0xc(%ebp)
  800754:	ff 75 08             	pushl  0x8(%ebp)
  800757:	50                   	push   %eax
  800758:	68 35 3a 80 00       	push   $0x803a35
  80075d:	e8 70 02 00 00       	call   8009d2 <cprintf>
  800762:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800765:	8b 45 10             	mov    0x10(%ebp),%eax
  800768:	83 ec 08             	sub    $0x8,%esp
  80076b:	ff 75 f4             	pushl  -0xc(%ebp)
  80076e:	50                   	push   %eax
  80076f:	e8 f3 01 00 00       	call   800967 <vcprintf>
  800774:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800777:	83 ec 08             	sub    $0x8,%esp
  80077a:	6a 00                	push   $0x0
  80077c:	68 51 3a 80 00       	push   $0x803a51
  800781:	e8 e1 01 00 00       	call   800967 <vcprintf>
  800786:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800789:	e8 82 ff ff ff       	call   800710 <exit>

	// should not return here
	while (1) ;
  80078e:	eb fe                	jmp    80078e <_panic+0x70>

00800790 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800790:	55                   	push   %ebp
  800791:	89 e5                	mov    %esp,%ebp
  800793:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800796:	a1 20 50 80 00       	mov    0x805020,%eax
  80079b:	8b 50 74             	mov    0x74(%eax),%edx
  80079e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a1:	39 c2                	cmp    %eax,%edx
  8007a3:	74 14                	je     8007b9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007a5:	83 ec 04             	sub    $0x4,%esp
  8007a8:	68 54 3a 80 00       	push   $0x803a54
  8007ad:	6a 26                	push   $0x26
  8007af:	68 a0 3a 80 00       	push   $0x803aa0
  8007b4:	e8 65 ff ff ff       	call   80071e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007c7:	e9 c2 00 00 00       	jmp    80088e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d9:	01 d0                	add    %edx,%eax
  8007db:	8b 00                	mov    (%eax),%eax
  8007dd:	85 c0                	test   %eax,%eax
  8007df:	75 08                	jne    8007e9 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007e1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007e4:	e9 a2 00 00 00       	jmp    80088b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007f7:	eb 69                	jmp    800862 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007f9:	a1 20 50 80 00       	mov    0x805020,%eax
  8007fe:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800804:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800807:	89 d0                	mov    %edx,%eax
  800809:	01 c0                	add    %eax,%eax
  80080b:	01 d0                	add    %edx,%eax
  80080d:	c1 e0 03             	shl    $0x3,%eax
  800810:	01 c8                	add    %ecx,%eax
  800812:	8a 40 04             	mov    0x4(%eax),%al
  800815:	84 c0                	test   %al,%al
  800817:	75 46                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800819:	a1 20 50 80 00       	mov    0x805020,%eax
  80081e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800824:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800827:	89 d0                	mov    %edx,%eax
  800829:	01 c0                	add    %eax,%eax
  80082b:	01 d0                	add    %edx,%eax
  80082d:	c1 e0 03             	shl    $0x3,%eax
  800830:	01 c8                	add    %ecx,%eax
  800832:	8b 00                	mov    (%eax),%eax
  800834:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800837:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80083a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80083f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800841:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800844:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	01 c8                	add    %ecx,%eax
  800850:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800852:	39 c2                	cmp    %eax,%edx
  800854:	75 09                	jne    80085f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800856:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80085d:	eb 12                	jmp    800871 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80085f:	ff 45 e8             	incl   -0x18(%ebp)
  800862:	a1 20 50 80 00       	mov    0x805020,%eax
  800867:	8b 50 74             	mov    0x74(%eax),%edx
  80086a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80086d:	39 c2                	cmp    %eax,%edx
  80086f:	77 88                	ja     8007f9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800871:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800875:	75 14                	jne    80088b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	68 ac 3a 80 00       	push   $0x803aac
  80087f:	6a 3a                	push   $0x3a
  800881:	68 a0 3a 80 00       	push   $0x803aa0
  800886:	e8 93 fe ff ff       	call   80071e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80088b:	ff 45 f0             	incl   -0x10(%ebp)
  80088e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800891:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800894:	0f 8c 32 ff ff ff    	jl     8007cc <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80089a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008a8:	eb 26                	jmp    8008d0 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008aa:	a1 20 50 80 00       	mov    0x805020,%eax
  8008af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008b8:	89 d0                	mov    %edx,%eax
  8008ba:	01 c0                	add    %eax,%eax
  8008bc:	01 d0                	add    %edx,%eax
  8008be:	c1 e0 03             	shl    $0x3,%eax
  8008c1:	01 c8                	add    %ecx,%eax
  8008c3:	8a 40 04             	mov    0x4(%eax),%al
  8008c6:	3c 01                	cmp    $0x1,%al
  8008c8:	75 03                	jne    8008cd <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008ca:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008cd:	ff 45 e0             	incl   -0x20(%ebp)
  8008d0:	a1 20 50 80 00       	mov    0x805020,%eax
  8008d5:	8b 50 74             	mov    0x74(%eax),%edx
  8008d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008db:	39 c2                	cmp    %eax,%edx
  8008dd:	77 cb                	ja     8008aa <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008e2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008e5:	74 14                	je     8008fb <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008e7:	83 ec 04             	sub    $0x4,%esp
  8008ea:	68 00 3b 80 00       	push   $0x803b00
  8008ef:	6a 44                	push   $0x44
  8008f1:	68 a0 3a 80 00       	push   $0x803aa0
  8008f6:	e8 23 fe ff ff       	call   80071e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008fb:	90                   	nop
  8008fc:	c9                   	leave  
  8008fd:	c3                   	ret    

008008fe <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008fe:	55                   	push   %ebp
  8008ff:	89 e5                	mov    %esp,%ebp
  800901:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800904:	8b 45 0c             	mov    0xc(%ebp),%eax
  800907:	8b 00                	mov    (%eax),%eax
  800909:	8d 48 01             	lea    0x1(%eax),%ecx
  80090c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80090f:	89 0a                	mov    %ecx,(%edx)
  800911:	8b 55 08             	mov    0x8(%ebp),%edx
  800914:	88 d1                	mov    %dl,%cl
  800916:	8b 55 0c             	mov    0xc(%ebp),%edx
  800919:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	8b 00                	mov    (%eax),%eax
  800922:	3d ff 00 00 00       	cmp    $0xff,%eax
  800927:	75 2c                	jne    800955 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800929:	a0 24 50 80 00       	mov    0x805024,%al
  80092e:	0f b6 c0             	movzbl %al,%eax
  800931:	8b 55 0c             	mov    0xc(%ebp),%edx
  800934:	8b 12                	mov    (%edx),%edx
  800936:	89 d1                	mov    %edx,%ecx
  800938:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093b:	83 c2 08             	add    $0x8,%edx
  80093e:	83 ec 04             	sub    $0x4,%esp
  800941:	50                   	push   %eax
  800942:	51                   	push   %ecx
  800943:	52                   	push   %edx
  800944:	e8 05 14 00 00       	call   801d4e <sys_cputs>
  800949:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80094c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80094f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	8b 40 04             	mov    0x4(%eax),%eax
  80095b:	8d 50 01             	lea    0x1(%eax),%edx
  80095e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800961:	89 50 04             	mov    %edx,0x4(%eax)
}
  800964:	90                   	nop
  800965:	c9                   	leave  
  800966:	c3                   	ret    

00800967 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800967:	55                   	push   %ebp
  800968:	89 e5                	mov    %esp,%ebp
  80096a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800970:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800977:	00 00 00 
	b.cnt = 0;
  80097a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800981:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800984:	ff 75 0c             	pushl  0xc(%ebp)
  800987:	ff 75 08             	pushl  0x8(%ebp)
  80098a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800990:	50                   	push   %eax
  800991:	68 fe 08 80 00       	push   $0x8008fe
  800996:	e8 11 02 00 00       	call   800bac <vprintfmt>
  80099b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80099e:	a0 24 50 80 00       	mov    0x805024,%al
  8009a3:	0f b6 c0             	movzbl %al,%eax
  8009a6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009ac:	83 ec 04             	sub    $0x4,%esp
  8009af:	50                   	push   %eax
  8009b0:	52                   	push   %edx
  8009b1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009b7:	83 c0 08             	add    $0x8,%eax
  8009ba:	50                   	push   %eax
  8009bb:	e8 8e 13 00 00       	call   801d4e <sys_cputs>
  8009c0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009c3:	c6 05 24 50 80 00 00 	movb   $0x0,0x805024
	return b.cnt;
  8009ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d0:	c9                   	leave  
  8009d1:	c3                   	ret    

008009d2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009d2:	55                   	push   %ebp
  8009d3:	89 e5                	mov    %esp,%ebp
  8009d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009d8:	c6 05 24 50 80 00 01 	movb   $0x1,0x805024
	va_start(ap, fmt);
  8009df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e8:	83 ec 08             	sub    $0x8,%esp
  8009eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8009ee:	50                   	push   %eax
  8009ef:	e8 73 ff ff ff       	call   800967 <vcprintf>
  8009f4:	83 c4 10             	add    $0x10,%esp
  8009f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009fd:	c9                   	leave  
  8009fe:	c3                   	ret    

008009ff <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009ff:	55                   	push   %ebp
  800a00:	89 e5                	mov    %esp,%ebp
  800a02:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a05:	e8 f2 14 00 00       	call   801efc <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a0a:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	83 ec 08             	sub    $0x8,%esp
  800a16:	ff 75 f4             	pushl  -0xc(%ebp)
  800a19:	50                   	push   %eax
  800a1a:	e8 48 ff ff ff       	call   800967 <vcprintf>
  800a1f:	83 c4 10             	add    $0x10,%esp
  800a22:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a25:	e8 ec 14 00 00       	call   801f16 <sys_enable_interrupt>
	return cnt;
  800a2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a2d:	c9                   	leave  
  800a2e:	c3                   	ret    

00800a2f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a2f:	55                   	push   %ebp
  800a30:	89 e5                	mov    %esp,%ebp
  800a32:	53                   	push   %ebx
  800a33:	83 ec 14             	sub    $0x14,%esp
  800a36:	8b 45 10             	mov    0x10(%ebp),%eax
  800a39:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a3c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a42:	8b 45 18             	mov    0x18(%ebp),%eax
  800a45:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a4d:	77 55                	ja     800aa4 <printnum+0x75>
  800a4f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a52:	72 05                	jb     800a59 <printnum+0x2a>
  800a54:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a57:	77 4b                	ja     800aa4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a59:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a5c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a5f:	8b 45 18             	mov    0x18(%ebp),%eax
  800a62:	ba 00 00 00 00       	mov    $0x0,%edx
  800a67:	52                   	push   %edx
  800a68:	50                   	push   %eax
  800a69:	ff 75 f4             	pushl  -0xc(%ebp)
  800a6c:	ff 75 f0             	pushl  -0x10(%ebp)
  800a6f:	e8 18 2b 00 00       	call   80358c <__udivdi3>
  800a74:	83 c4 10             	add    $0x10,%esp
  800a77:	83 ec 04             	sub    $0x4,%esp
  800a7a:	ff 75 20             	pushl  0x20(%ebp)
  800a7d:	53                   	push   %ebx
  800a7e:	ff 75 18             	pushl  0x18(%ebp)
  800a81:	52                   	push   %edx
  800a82:	50                   	push   %eax
  800a83:	ff 75 0c             	pushl  0xc(%ebp)
  800a86:	ff 75 08             	pushl  0x8(%ebp)
  800a89:	e8 a1 ff ff ff       	call   800a2f <printnum>
  800a8e:	83 c4 20             	add    $0x20,%esp
  800a91:	eb 1a                	jmp    800aad <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a93:	83 ec 08             	sub    $0x8,%esp
  800a96:	ff 75 0c             	pushl  0xc(%ebp)
  800a99:	ff 75 20             	pushl  0x20(%ebp)
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aa4:	ff 4d 1c             	decl   0x1c(%ebp)
  800aa7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800aab:	7f e6                	jg     800a93 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800aad:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab0:	bb 00 00 00 00       	mov    $0x0,%ebx
  800ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800abb:	53                   	push   %ebx
  800abc:	51                   	push   %ecx
  800abd:	52                   	push   %edx
  800abe:	50                   	push   %eax
  800abf:	e8 d8 2b 00 00       	call   80369c <__umoddi3>
  800ac4:	83 c4 10             	add    $0x10,%esp
  800ac7:	05 74 3d 80 00       	add    $0x803d74,%eax
  800acc:	8a 00                	mov    (%eax),%al
  800ace:	0f be c0             	movsbl %al,%eax
  800ad1:	83 ec 08             	sub    $0x8,%esp
  800ad4:	ff 75 0c             	pushl  0xc(%ebp)
  800ad7:	50                   	push   %eax
  800ad8:	8b 45 08             	mov    0x8(%ebp),%eax
  800adb:	ff d0                	call   *%eax
  800add:	83 c4 10             	add    $0x10,%esp
}
  800ae0:	90                   	nop
  800ae1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ae4:	c9                   	leave  
  800ae5:	c3                   	ret    

00800ae6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800ae6:	55                   	push   %ebp
  800ae7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ae9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800aed:	7e 1c                	jle    800b0b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800aef:	8b 45 08             	mov    0x8(%ebp),%eax
  800af2:	8b 00                	mov    (%eax),%eax
  800af4:	8d 50 08             	lea    0x8(%eax),%edx
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	89 10                	mov    %edx,(%eax)
  800afc:	8b 45 08             	mov    0x8(%ebp),%eax
  800aff:	8b 00                	mov    (%eax),%eax
  800b01:	83 e8 08             	sub    $0x8,%eax
  800b04:	8b 50 04             	mov    0x4(%eax),%edx
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	eb 40                	jmp    800b4b <getuint+0x65>
	else if (lflag)
  800b0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b0f:	74 1e                	je     800b2f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b11:	8b 45 08             	mov    0x8(%ebp),%eax
  800b14:	8b 00                	mov    (%eax),%eax
  800b16:	8d 50 04             	lea    0x4(%eax),%edx
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	89 10                	mov    %edx,(%eax)
  800b1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b21:	8b 00                	mov    (%eax),%eax
  800b23:	83 e8 04             	sub    $0x4,%eax
  800b26:	8b 00                	mov    (%eax),%eax
  800b28:	ba 00 00 00 00       	mov    $0x0,%edx
  800b2d:	eb 1c                	jmp    800b4b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b32:	8b 00                	mov    (%eax),%eax
  800b34:	8d 50 04             	lea    0x4(%eax),%edx
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	89 10                	mov    %edx,(%eax)
  800b3c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3f:	8b 00                	mov    (%eax),%eax
  800b41:	83 e8 04             	sub    $0x4,%eax
  800b44:	8b 00                	mov    (%eax),%eax
  800b46:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b4b:	5d                   	pop    %ebp
  800b4c:	c3                   	ret    

00800b4d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b4d:	55                   	push   %ebp
  800b4e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b50:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b54:	7e 1c                	jle    800b72 <getint+0x25>
		return va_arg(*ap, long long);
  800b56:	8b 45 08             	mov    0x8(%ebp),%eax
  800b59:	8b 00                	mov    (%eax),%eax
  800b5b:	8d 50 08             	lea    0x8(%eax),%edx
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	89 10                	mov    %edx,(%eax)
  800b63:	8b 45 08             	mov    0x8(%ebp),%eax
  800b66:	8b 00                	mov    (%eax),%eax
  800b68:	83 e8 08             	sub    $0x8,%eax
  800b6b:	8b 50 04             	mov    0x4(%eax),%edx
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	eb 38                	jmp    800baa <getint+0x5d>
	else if (lflag)
  800b72:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b76:	74 1a                	je     800b92 <getint+0x45>
		return va_arg(*ap, long);
  800b78:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7b:	8b 00                	mov    (%eax),%eax
  800b7d:	8d 50 04             	lea    0x4(%eax),%edx
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	89 10                	mov    %edx,(%eax)
  800b85:	8b 45 08             	mov    0x8(%ebp),%eax
  800b88:	8b 00                	mov    (%eax),%eax
  800b8a:	83 e8 04             	sub    $0x4,%eax
  800b8d:	8b 00                	mov    (%eax),%eax
  800b8f:	99                   	cltd   
  800b90:	eb 18                	jmp    800baa <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b92:	8b 45 08             	mov    0x8(%ebp),%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	8d 50 04             	lea    0x4(%eax),%edx
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	89 10                	mov    %edx,(%eax)
  800b9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba2:	8b 00                	mov    (%eax),%eax
  800ba4:	83 e8 04             	sub    $0x4,%eax
  800ba7:	8b 00                	mov    (%eax),%eax
  800ba9:	99                   	cltd   
}
  800baa:	5d                   	pop    %ebp
  800bab:	c3                   	ret    

00800bac <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bac:	55                   	push   %ebp
  800bad:	89 e5                	mov    %esp,%ebp
  800baf:	56                   	push   %esi
  800bb0:	53                   	push   %ebx
  800bb1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb4:	eb 17                	jmp    800bcd <vprintfmt+0x21>
			if (ch == '\0')
  800bb6:	85 db                	test   %ebx,%ebx
  800bb8:	0f 84 af 03 00 00    	je     800f6d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bbe:	83 ec 08             	sub    $0x8,%esp
  800bc1:	ff 75 0c             	pushl  0xc(%ebp)
  800bc4:	53                   	push   %ebx
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	ff d0                	call   *%eax
  800bca:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bcd:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd0:	8d 50 01             	lea    0x1(%eax),%edx
  800bd3:	89 55 10             	mov    %edx,0x10(%ebp)
  800bd6:	8a 00                	mov    (%eax),%al
  800bd8:	0f b6 d8             	movzbl %al,%ebx
  800bdb:	83 fb 25             	cmp    $0x25,%ebx
  800bde:	75 d6                	jne    800bb6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800be4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800beb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bf2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bf9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c00:	8b 45 10             	mov    0x10(%ebp),%eax
  800c03:	8d 50 01             	lea    0x1(%eax),%edx
  800c06:	89 55 10             	mov    %edx,0x10(%ebp)
  800c09:	8a 00                	mov    (%eax),%al
  800c0b:	0f b6 d8             	movzbl %al,%ebx
  800c0e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c11:	83 f8 55             	cmp    $0x55,%eax
  800c14:	0f 87 2b 03 00 00    	ja     800f45 <vprintfmt+0x399>
  800c1a:	8b 04 85 98 3d 80 00 	mov    0x803d98(,%eax,4),%eax
  800c21:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c23:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c27:	eb d7                	jmp    800c00 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c29:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c2d:	eb d1                	jmp    800c00 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c39:	89 d0                	mov    %edx,%eax
  800c3b:	c1 e0 02             	shl    $0x2,%eax
  800c3e:	01 d0                	add    %edx,%eax
  800c40:	01 c0                	add    %eax,%eax
  800c42:	01 d8                	add    %ebx,%eax
  800c44:	83 e8 30             	sub    $0x30,%eax
  800c47:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800c4d:	8a 00                	mov    (%eax),%al
  800c4f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c52:	83 fb 2f             	cmp    $0x2f,%ebx
  800c55:	7e 3e                	jle    800c95 <vprintfmt+0xe9>
  800c57:	83 fb 39             	cmp    $0x39,%ebx
  800c5a:	7f 39                	jg     800c95 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c5c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c5f:	eb d5                	jmp    800c36 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c61:	8b 45 14             	mov    0x14(%ebp),%eax
  800c64:	83 c0 04             	add    $0x4,%eax
  800c67:	89 45 14             	mov    %eax,0x14(%ebp)
  800c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6d:	83 e8 04             	sub    $0x4,%eax
  800c70:	8b 00                	mov    (%eax),%eax
  800c72:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c75:	eb 1f                	jmp    800c96 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7b:	79 83                	jns    800c00 <vprintfmt+0x54>
				width = 0;
  800c7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c84:	e9 77 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c89:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c90:	e9 6b ff ff ff       	jmp    800c00 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c95:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c9a:	0f 89 60 ff ff ff    	jns    800c00 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ca3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800ca6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cad:	e9 4e ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cb2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cb5:	e9 46 ff ff ff       	jmp    800c00 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cba:	8b 45 14             	mov    0x14(%ebp),%eax
  800cbd:	83 c0 04             	add    $0x4,%eax
  800cc0:	89 45 14             	mov    %eax,0x14(%ebp)
  800cc3:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc6:	83 e8 04             	sub    $0x4,%eax
  800cc9:	8b 00                	mov    (%eax),%eax
  800ccb:	83 ec 08             	sub    $0x8,%esp
  800cce:	ff 75 0c             	pushl  0xc(%ebp)
  800cd1:	50                   	push   %eax
  800cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd5:	ff d0                	call   *%eax
  800cd7:	83 c4 10             	add    $0x10,%esp
			break;
  800cda:	e9 89 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cdf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ce2:	83 c0 04             	add    $0x4,%eax
  800ce5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ce8:	8b 45 14             	mov    0x14(%ebp),%eax
  800ceb:	83 e8 04             	sub    $0x4,%eax
  800cee:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf0:	85 db                	test   %ebx,%ebx
  800cf2:	79 02                	jns    800cf6 <vprintfmt+0x14a>
				err = -err;
  800cf4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cf6:	83 fb 64             	cmp    $0x64,%ebx
  800cf9:	7f 0b                	jg     800d06 <vprintfmt+0x15a>
  800cfb:	8b 34 9d e0 3b 80 00 	mov    0x803be0(,%ebx,4),%esi
  800d02:	85 f6                	test   %esi,%esi
  800d04:	75 19                	jne    800d1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d06:	53                   	push   %ebx
  800d07:	68 85 3d 80 00       	push   $0x803d85
  800d0c:	ff 75 0c             	pushl  0xc(%ebp)
  800d0f:	ff 75 08             	pushl  0x8(%ebp)
  800d12:	e8 5e 02 00 00       	call   800f75 <printfmt>
  800d17:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d1a:	e9 49 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d1f:	56                   	push   %esi
  800d20:	68 8e 3d 80 00       	push   $0x803d8e
  800d25:	ff 75 0c             	pushl  0xc(%ebp)
  800d28:	ff 75 08             	pushl  0x8(%ebp)
  800d2b:	e8 45 02 00 00       	call   800f75 <printfmt>
  800d30:	83 c4 10             	add    $0x10,%esp
			break;
  800d33:	e9 30 02 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d38:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3b:	83 c0 04             	add    $0x4,%eax
  800d3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800d41:	8b 45 14             	mov    0x14(%ebp),%eax
  800d44:	83 e8 04             	sub    $0x4,%eax
  800d47:	8b 30                	mov    (%eax),%esi
  800d49:	85 f6                	test   %esi,%esi
  800d4b:	75 05                	jne    800d52 <vprintfmt+0x1a6>
				p = "(null)";
  800d4d:	be 91 3d 80 00       	mov    $0x803d91,%esi
			if (width > 0 && padc != '-')
  800d52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d56:	7e 6d                	jle    800dc5 <vprintfmt+0x219>
  800d58:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d5c:	74 67                	je     800dc5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d61:	83 ec 08             	sub    $0x8,%esp
  800d64:	50                   	push   %eax
  800d65:	56                   	push   %esi
  800d66:	e8 0c 03 00 00       	call   801077 <strnlen>
  800d6b:	83 c4 10             	add    $0x10,%esp
  800d6e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d71:	eb 16                	jmp    800d89 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d73:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d77:	83 ec 08             	sub    $0x8,%esp
  800d7a:	ff 75 0c             	pushl  0xc(%ebp)
  800d7d:	50                   	push   %eax
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	ff d0                	call   *%eax
  800d83:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d86:	ff 4d e4             	decl   -0x1c(%ebp)
  800d89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d8d:	7f e4                	jg     800d73 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d8f:	eb 34                	jmp    800dc5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d91:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d95:	74 1c                	je     800db3 <vprintfmt+0x207>
  800d97:	83 fb 1f             	cmp    $0x1f,%ebx
  800d9a:	7e 05                	jle    800da1 <vprintfmt+0x1f5>
  800d9c:	83 fb 7e             	cmp    $0x7e,%ebx
  800d9f:	7e 12                	jle    800db3 <vprintfmt+0x207>
					putch('?', putdat);
  800da1:	83 ec 08             	sub    $0x8,%esp
  800da4:	ff 75 0c             	pushl  0xc(%ebp)
  800da7:	6a 3f                	push   $0x3f
  800da9:	8b 45 08             	mov    0x8(%ebp),%eax
  800dac:	ff d0                	call   *%eax
  800dae:	83 c4 10             	add    $0x10,%esp
  800db1:	eb 0f                	jmp    800dc2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800db3:	83 ec 08             	sub    $0x8,%esp
  800db6:	ff 75 0c             	pushl  0xc(%ebp)
  800db9:	53                   	push   %ebx
  800dba:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbd:	ff d0                	call   *%eax
  800dbf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dc2:	ff 4d e4             	decl   -0x1c(%ebp)
  800dc5:	89 f0                	mov    %esi,%eax
  800dc7:	8d 70 01             	lea    0x1(%eax),%esi
  800dca:	8a 00                	mov    (%eax),%al
  800dcc:	0f be d8             	movsbl %al,%ebx
  800dcf:	85 db                	test   %ebx,%ebx
  800dd1:	74 24                	je     800df7 <vprintfmt+0x24b>
  800dd3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dd7:	78 b8                	js     800d91 <vprintfmt+0x1e5>
  800dd9:	ff 4d e0             	decl   -0x20(%ebp)
  800ddc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de0:	79 af                	jns    800d91 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800de2:	eb 13                	jmp    800df7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800de4:	83 ec 08             	sub    $0x8,%esp
  800de7:	ff 75 0c             	pushl  0xc(%ebp)
  800dea:	6a 20                	push   $0x20
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	ff d0                	call   *%eax
  800df1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800df4:	ff 4d e4             	decl   -0x1c(%ebp)
  800df7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800dfb:	7f e7                	jg     800de4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800dfd:	e9 66 01 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e02:	83 ec 08             	sub    $0x8,%esp
  800e05:	ff 75 e8             	pushl  -0x18(%ebp)
  800e08:	8d 45 14             	lea    0x14(%ebp),%eax
  800e0b:	50                   	push   %eax
  800e0c:	e8 3c fd ff ff       	call   800b4d <getint>
  800e11:	83 c4 10             	add    $0x10,%esp
  800e14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e20:	85 d2                	test   %edx,%edx
  800e22:	79 23                	jns    800e47 <vprintfmt+0x29b>
				putch('-', putdat);
  800e24:	83 ec 08             	sub    $0x8,%esp
  800e27:	ff 75 0c             	pushl  0xc(%ebp)
  800e2a:	6a 2d                	push   $0x2d
  800e2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2f:	ff d0                	call   *%eax
  800e31:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e3a:	f7 d8                	neg    %eax
  800e3c:	83 d2 00             	adc    $0x0,%edx
  800e3f:	f7 da                	neg    %edx
  800e41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e44:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e47:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e4e:	e9 bc 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e53:	83 ec 08             	sub    $0x8,%esp
  800e56:	ff 75 e8             	pushl  -0x18(%ebp)
  800e59:	8d 45 14             	lea    0x14(%ebp),%eax
  800e5c:	50                   	push   %eax
  800e5d:	e8 84 fc ff ff       	call   800ae6 <getuint>
  800e62:	83 c4 10             	add    $0x10,%esp
  800e65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e6b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e72:	e9 98 00 00 00       	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e77:	83 ec 08             	sub    $0x8,%esp
  800e7a:	ff 75 0c             	pushl  0xc(%ebp)
  800e7d:	6a 58                	push   $0x58
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	ff d0                	call   *%eax
  800e84:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e87:	83 ec 08             	sub    $0x8,%esp
  800e8a:	ff 75 0c             	pushl  0xc(%ebp)
  800e8d:	6a 58                	push   $0x58
  800e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e92:	ff d0                	call   *%eax
  800e94:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e97:	83 ec 08             	sub    $0x8,%esp
  800e9a:	ff 75 0c             	pushl  0xc(%ebp)
  800e9d:	6a 58                	push   $0x58
  800e9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea2:	ff d0                	call   *%eax
  800ea4:	83 c4 10             	add    $0x10,%esp
			break;
  800ea7:	e9 bc 00 00 00       	jmp    800f68 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eac:	83 ec 08             	sub    $0x8,%esp
  800eaf:	ff 75 0c             	pushl  0xc(%ebp)
  800eb2:	6a 30                	push   $0x30
  800eb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb7:	ff d0                	call   *%eax
  800eb9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ebc:	83 ec 08             	sub    $0x8,%esp
  800ebf:	ff 75 0c             	pushl  0xc(%ebp)
  800ec2:	6a 78                	push   $0x78
  800ec4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec7:	ff d0                	call   *%eax
  800ec9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ecc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ecf:	83 c0 04             	add    $0x4,%eax
  800ed2:	89 45 14             	mov    %eax,0x14(%ebp)
  800ed5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed8:	83 e8 04             	sub    $0x4,%eax
  800edb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800edd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ee7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800eee:	eb 1f                	jmp    800f0f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef0:	83 ec 08             	sub    $0x8,%esp
  800ef3:	ff 75 e8             	pushl  -0x18(%ebp)
  800ef6:	8d 45 14             	lea    0x14(%ebp),%eax
  800ef9:	50                   	push   %eax
  800efa:	e8 e7 fb ff ff       	call   800ae6 <getuint>
  800eff:	83 c4 10             	add    $0x10,%esp
  800f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f08:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f0f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f16:	83 ec 04             	sub    $0x4,%esp
  800f19:	52                   	push   %edx
  800f1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f1d:	50                   	push   %eax
  800f1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800f21:	ff 75 f0             	pushl  -0x10(%ebp)
  800f24:	ff 75 0c             	pushl  0xc(%ebp)
  800f27:	ff 75 08             	pushl  0x8(%ebp)
  800f2a:	e8 00 fb ff ff       	call   800a2f <printnum>
  800f2f:	83 c4 20             	add    $0x20,%esp
			break;
  800f32:	eb 34                	jmp    800f68 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f34:	83 ec 08             	sub    $0x8,%esp
  800f37:	ff 75 0c             	pushl  0xc(%ebp)
  800f3a:	53                   	push   %ebx
  800f3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f3e:	ff d0                	call   *%eax
  800f40:	83 c4 10             	add    $0x10,%esp
			break;
  800f43:	eb 23                	jmp    800f68 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f45:	83 ec 08             	sub    $0x8,%esp
  800f48:	ff 75 0c             	pushl  0xc(%ebp)
  800f4b:	6a 25                	push   $0x25
  800f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800f50:	ff d0                	call   *%eax
  800f52:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f55:	ff 4d 10             	decl   0x10(%ebp)
  800f58:	eb 03                	jmp    800f5d <vprintfmt+0x3b1>
  800f5a:	ff 4d 10             	decl   0x10(%ebp)
  800f5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800f60:	48                   	dec    %eax
  800f61:	8a 00                	mov    (%eax),%al
  800f63:	3c 25                	cmp    $0x25,%al
  800f65:	75 f3                	jne    800f5a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f67:	90                   	nop
		}
	}
  800f68:	e9 47 fc ff ff       	jmp    800bb4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f6d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5d                   	pop    %ebp
  800f74:	c3                   	ret    

00800f75 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f75:	55                   	push   %ebp
  800f76:	89 e5                	mov    %esp,%ebp
  800f78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800f7e:	83 c0 04             	add    $0x4,%eax
  800f81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f84:	8b 45 10             	mov    0x10(%ebp),%eax
  800f87:	ff 75 f4             	pushl  -0xc(%ebp)
  800f8a:	50                   	push   %eax
  800f8b:	ff 75 0c             	pushl  0xc(%ebp)
  800f8e:	ff 75 08             	pushl  0x8(%ebp)
  800f91:	e8 16 fc ff ff       	call   800bac <vprintfmt>
  800f96:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f99:	90                   	nop
  800f9a:	c9                   	leave  
  800f9b:	c3                   	ret    

00800f9c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f9c:	55                   	push   %ebp
  800f9d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa2:	8b 40 08             	mov    0x8(%eax),%eax
  800fa5:	8d 50 01             	lea    0x1(%eax),%edx
  800fa8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fab:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb1:	8b 10                	mov    (%eax),%edx
  800fb3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb6:	8b 40 04             	mov    0x4(%eax),%eax
  800fb9:	39 c2                	cmp    %eax,%edx
  800fbb:	73 12                	jae    800fcf <sprintputch+0x33>
		*b->buf++ = ch;
  800fbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc0:	8b 00                	mov    (%eax),%eax
  800fc2:	8d 48 01             	lea    0x1(%eax),%ecx
  800fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fc8:	89 0a                	mov    %ecx,(%edx)
  800fca:	8b 55 08             	mov    0x8(%ebp),%edx
  800fcd:	88 10                	mov    %dl,(%eax)
}
  800fcf:	90                   	nop
  800fd0:	5d                   	pop    %ebp
  800fd1:	c3                   	ret    

00800fd2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fd2:	55                   	push   %ebp
  800fd3:	89 e5                	mov    %esp,%ebp
  800fd5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fdb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe4:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe7:	01 d0                	add    %edx,%eax
  800fe9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ff3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800ff7:	74 06                	je     800fff <vsnprintf+0x2d>
  800ff9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ffd:	7f 07                	jg     801006 <vsnprintf+0x34>
		return -E_INVAL;
  800fff:	b8 03 00 00 00       	mov    $0x3,%eax
  801004:	eb 20                	jmp    801026 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801006:	ff 75 14             	pushl  0x14(%ebp)
  801009:	ff 75 10             	pushl  0x10(%ebp)
  80100c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  80100f:	50                   	push   %eax
  801010:	68 9c 0f 80 00       	push   $0x800f9c
  801015:	e8 92 fb ff ff       	call   800bac <vprintfmt>
  80101a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  80101d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801020:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801023:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801026:	c9                   	leave  
  801027:	c3                   	ret    

00801028 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801028:	55                   	push   %ebp
  801029:	89 e5                	mov    %esp,%ebp
  80102b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  80102e:	8d 45 10             	lea    0x10(%ebp),%eax
  801031:	83 c0 04             	add    $0x4,%eax
  801034:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  801037:	8b 45 10             	mov    0x10(%ebp),%eax
  80103a:	ff 75 f4             	pushl  -0xc(%ebp)
  80103d:	50                   	push   %eax
  80103e:	ff 75 0c             	pushl  0xc(%ebp)
  801041:	ff 75 08             	pushl  0x8(%ebp)
  801044:	e8 89 ff ff ff       	call   800fd2 <vsnprintf>
  801049:	83 c4 10             	add    $0x10,%esp
  80104c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  80104f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801052:	c9                   	leave  
  801053:	c3                   	ret    

00801054 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801054:	55                   	push   %ebp
  801055:	89 e5                	mov    %esp,%ebp
  801057:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80105a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801061:	eb 06                	jmp    801069 <strlen+0x15>
		n++;
  801063:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801066:	ff 45 08             	incl   0x8(%ebp)
  801069:	8b 45 08             	mov    0x8(%ebp),%eax
  80106c:	8a 00                	mov    (%eax),%al
  80106e:	84 c0                	test   %al,%al
  801070:	75 f1                	jne    801063 <strlen+0xf>
		n++;
	return n;
  801072:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801075:	c9                   	leave  
  801076:	c3                   	ret    

00801077 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801077:	55                   	push   %ebp
  801078:	89 e5                	mov    %esp,%ebp
  80107a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80107d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801084:	eb 09                	jmp    80108f <strnlen+0x18>
		n++;
  801086:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801089:	ff 45 08             	incl   0x8(%ebp)
  80108c:	ff 4d 0c             	decl   0xc(%ebp)
  80108f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801093:	74 09                	je     80109e <strnlen+0x27>
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8a 00                	mov    (%eax),%al
  80109a:	84 c0                	test   %al,%al
  80109c:	75 e8                	jne    801086 <strnlen+0xf>
		n++;
	return n;
  80109e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010a1:	c9                   	leave  
  8010a2:	c3                   	ret    

008010a3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8010a3:	55                   	push   %ebp
  8010a4:	89 e5                	mov    %esp,%ebp
  8010a6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8010af:	90                   	nop
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	8d 50 01             	lea    0x1(%eax),%edx
  8010b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8010b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010c2:	8a 12                	mov    (%edx),%dl
  8010c4:	88 10                	mov    %dl,(%eax)
  8010c6:	8a 00                	mov    (%eax),%al
  8010c8:	84 c0                	test   %al,%al
  8010ca:	75 e4                	jne    8010b0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010cc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010cf:	c9                   	leave  
  8010d0:	c3                   	ret    

008010d1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010d1:	55                   	push   %ebp
  8010d2:	89 e5                	mov    %esp,%ebp
  8010d4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010dd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010e4:	eb 1f                	jmp    801105 <strncpy+0x34>
		*dst++ = *src;
  8010e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e9:	8d 50 01             	lea    0x1(%eax),%edx
  8010ec:	89 55 08             	mov    %edx,0x8(%ebp)
  8010ef:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010f2:	8a 12                	mov    (%edx),%dl
  8010f4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f9:	8a 00                	mov    (%eax),%al
  8010fb:	84 c0                	test   %al,%al
  8010fd:	74 03                	je     801102 <strncpy+0x31>
			src++;
  8010ff:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801102:	ff 45 fc             	incl   -0x4(%ebp)
  801105:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801108:	3b 45 10             	cmp    0x10(%ebp),%eax
  80110b:	72 d9                	jb     8010e6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80110d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801110:	c9                   	leave  
  801111:	c3                   	ret    

00801112 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801112:	55                   	push   %ebp
  801113:	89 e5                	mov    %esp,%ebp
  801115:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801118:	8b 45 08             	mov    0x8(%ebp),%eax
  80111b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80111e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801122:	74 30                	je     801154 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801124:	eb 16                	jmp    80113c <strlcpy+0x2a>
			*dst++ = *src++;
  801126:	8b 45 08             	mov    0x8(%ebp),%eax
  801129:	8d 50 01             	lea    0x1(%eax),%edx
  80112c:	89 55 08             	mov    %edx,0x8(%ebp)
  80112f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801132:	8d 4a 01             	lea    0x1(%edx),%ecx
  801135:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801138:	8a 12                	mov    (%edx),%dl
  80113a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80113c:	ff 4d 10             	decl   0x10(%ebp)
  80113f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801143:	74 09                	je     80114e <strlcpy+0x3c>
  801145:	8b 45 0c             	mov    0xc(%ebp),%eax
  801148:	8a 00                	mov    (%eax),%al
  80114a:	84 c0                	test   %al,%al
  80114c:	75 d8                	jne    801126 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80114e:	8b 45 08             	mov    0x8(%ebp),%eax
  801151:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801154:	8b 55 08             	mov    0x8(%ebp),%edx
  801157:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80115a:	29 c2                	sub    %eax,%edx
  80115c:	89 d0                	mov    %edx,%eax
}
  80115e:	c9                   	leave  
  80115f:	c3                   	ret    

00801160 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801160:	55                   	push   %ebp
  801161:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801163:	eb 06                	jmp    80116b <strcmp+0xb>
		p++, q++;
  801165:	ff 45 08             	incl   0x8(%ebp)
  801168:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	84 c0                	test   %al,%al
  801172:	74 0e                	je     801182 <strcmp+0x22>
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 10                	mov    (%eax),%dl
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	8a 00                	mov    (%eax),%al
  80117e:	38 c2                	cmp    %al,%dl
  801180:	74 e3                	je     801165 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	0f b6 d0             	movzbl %al,%edx
  80118a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80118d:	8a 00                	mov    (%eax),%al
  80118f:	0f b6 c0             	movzbl %al,%eax
  801192:	29 c2                	sub    %eax,%edx
  801194:	89 d0                	mov    %edx,%eax
}
  801196:	5d                   	pop    %ebp
  801197:	c3                   	ret    

00801198 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801198:	55                   	push   %ebp
  801199:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  80119b:	eb 09                	jmp    8011a6 <strncmp+0xe>
		n--, p++, q++;
  80119d:	ff 4d 10             	decl   0x10(%ebp)
  8011a0:	ff 45 08             	incl   0x8(%ebp)
  8011a3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8011a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011aa:	74 17                	je     8011c3 <strncmp+0x2b>
  8011ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8011af:	8a 00                	mov    (%eax),%al
  8011b1:	84 c0                	test   %al,%al
  8011b3:	74 0e                	je     8011c3 <strncmp+0x2b>
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 10                	mov    (%eax),%dl
  8011ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bd:	8a 00                	mov    (%eax),%al
  8011bf:	38 c2                	cmp    %al,%dl
  8011c1:	74 da                	je     80119d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011c3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c7:	75 07                	jne    8011d0 <strncmp+0x38>
		return 0;
  8011c9:	b8 00 00 00 00       	mov    $0x0,%eax
  8011ce:	eb 14                	jmp    8011e4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d3:	8a 00                	mov    (%eax),%al
  8011d5:	0f b6 d0             	movzbl %al,%edx
  8011d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011db:	8a 00                	mov    (%eax),%al
  8011dd:	0f b6 c0             	movzbl %al,%eax
  8011e0:	29 c2                	sub    %eax,%edx
  8011e2:	89 d0                	mov    %edx,%eax
}
  8011e4:	5d                   	pop    %ebp
  8011e5:	c3                   	ret    

008011e6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011e6:	55                   	push   %ebp
  8011e7:	89 e5                	mov    %esp,%ebp
  8011e9:	83 ec 04             	sub    $0x4,%esp
  8011ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ef:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011f2:	eb 12                	jmp    801206 <strchr+0x20>
		if (*s == c)
  8011f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f7:	8a 00                	mov    (%eax),%al
  8011f9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011fc:	75 05                	jne    801203 <strchr+0x1d>
			return (char *) s;
  8011fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801201:	eb 11                	jmp    801214 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801203:	ff 45 08             	incl   0x8(%ebp)
  801206:	8b 45 08             	mov    0x8(%ebp),%eax
  801209:	8a 00                	mov    (%eax),%al
  80120b:	84 c0                	test   %al,%al
  80120d:	75 e5                	jne    8011f4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80120f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801214:	c9                   	leave  
  801215:	c3                   	ret    

00801216 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801216:	55                   	push   %ebp
  801217:	89 e5                	mov    %esp,%ebp
  801219:	83 ec 04             	sub    $0x4,%esp
  80121c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80121f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801222:	eb 0d                	jmp    801231 <strfind+0x1b>
		if (*s == c)
  801224:	8b 45 08             	mov    0x8(%ebp),%eax
  801227:	8a 00                	mov    (%eax),%al
  801229:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80122c:	74 0e                	je     80123c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80122e:	ff 45 08             	incl   0x8(%ebp)
  801231:	8b 45 08             	mov    0x8(%ebp),%eax
  801234:	8a 00                	mov    (%eax),%al
  801236:	84 c0                	test   %al,%al
  801238:	75 ea                	jne    801224 <strfind+0xe>
  80123a:	eb 01                	jmp    80123d <strfind+0x27>
		if (*s == c)
			break;
  80123c:	90                   	nop
	return (char *) s;
  80123d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801240:	c9                   	leave  
  801241:	c3                   	ret    

00801242 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801242:	55                   	push   %ebp
  801243:	89 e5                	mov    %esp,%ebp
  801245:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801248:	8b 45 08             	mov    0x8(%ebp),%eax
  80124b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80124e:	8b 45 10             	mov    0x10(%ebp),%eax
  801251:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801254:	eb 0e                	jmp    801264 <memset+0x22>
		*p++ = c;
  801256:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801259:	8d 50 01             	lea    0x1(%eax),%edx
  80125c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80125f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801262:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801264:	ff 4d f8             	decl   -0x8(%ebp)
  801267:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80126b:	79 e9                	jns    801256 <memset+0x14>
		*p++ = c;

	return v;
  80126d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801270:	c9                   	leave  
  801271:	c3                   	ret    

00801272 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801272:	55                   	push   %ebp
  801273:	89 e5                	mov    %esp,%ebp
  801275:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801278:	8b 45 0c             	mov    0xc(%ebp),%eax
  80127b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80127e:	8b 45 08             	mov    0x8(%ebp),%eax
  801281:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801284:	eb 16                	jmp    80129c <memcpy+0x2a>
		*d++ = *s++;
  801286:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801289:	8d 50 01             	lea    0x1(%eax),%edx
  80128c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80128f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801292:	8d 4a 01             	lea    0x1(%edx),%ecx
  801295:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801298:	8a 12                	mov    (%edx),%dl
  80129a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80129c:	8b 45 10             	mov    0x10(%ebp),%eax
  80129f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8012a5:	85 c0                	test   %eax,%eax
  8012a7:	75 dd                	jne    801286 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8012a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8012ac:	c9                   	leave  
  8012ad:	c3                   	ret    

008012ae <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8012ae:	55                   	push   %ebp
  8012af:	89 e5                	mov    %esp,%ebp
  8012b1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8012b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8012ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012c6:	73 50                	jae    801318 <memmove+0x6a>
  8012c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012ce:	01 d0                	add    %edx,%eax
  8012d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012d3:	76 43                	jbe    801318 <memmove+0x6a>
		s += n;
  8012d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8012d8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012db:	8b 45 10             	mov    0x10(%ebp),%eax
  8012de:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012e1:	eb 10                	jmp    8012f3 <memmove+0x45>
			*--d = *--s;
  8012e3:	ff 4d f8             	decl   -0x8(%ebp)
  8012e6:	ff 4d fc             	decl   -0x4(%ebp)
  8012e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012ec:	8a 10                	mov    (%eax),%dl
  8012ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8012fc:	85 c0                	test   %eax,%eax
  8012fe:	75 e3                	jne    8012e3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801300:	eb 23                	jmp    801325 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801302:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801305:	8d 50 01             	lea    0x1(%eax),%edx
  801308:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80130b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80130e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801311:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801314:	8a 12                	mov    (%edx),%dl
  801316:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801318:	8b 45 10             	mov    0x10(%ebp),%eax
  80131b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80131e:	89 55 10             	mov    %edx,0x10(%ebp)
  801321:	85 c0                	test   %eax,%eax
  801323:	75 dd                	jne    801302 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801325:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801328:	c9                   	leave  
  801329:	c3                   	ret    

0080132a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80132a:	55                   	push   %ebp
  80132b:	89 e5                	mov    %esp,%ebp
  80132d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801330:	8b 45 08             	mov    0x8(%ebp),%eax
  801333:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801336:	8b 45 0c             	mov    0xc(%ebp),%eax
  801339:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80133c:	eb 2a                	jmp    801368 <memcmp+0x3e>
		if (*s1 != *s2)
  80133e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801341:	8a 10                	mov    (%eax),%dl
  801343:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801346:	8a 00                	mov    (%eax),%al
  801348:	38 c2                	cmp    %al,%dl
  80134a:	74 16                	je     801362 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80134c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80134f:	8a 00                	mov    (%eax),%al
  801351:	0f b6 d0             	movzbl %al,%edx
  801354:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801357:	8a 00                	mov    (%eax),%al
  801359:	0f b6 c0             	movzbl %al,%eax
  80135c:	29 c2                	sub    %eax,%edx
  80135e:	89 d0                	mov    %edx,%eax
  801360:	eb 18                	jmp    80137a <memcmp+0x50>
		s1++, s2++;
  801362:	ff 45 fc             	incl   -0x4(%ebp)
  801365:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801368:	8b 45 10             	mov    0x10(%ebp),%eax
  80136b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80136e:	89 55 10             	mov    %edx,0x10(%ebp)
  801371:	85 c0                	test   %eax,%eax
  801373:	75 c9                	jne    80133e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801375:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80137a:	c9                   	leave  
  80137b:	c3                   	ret    

0080137c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80137c:	55                   	push   %ebp
  80137d:	89 e5                	mov    %esp,%ebp
  80137f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801382:	8b 55 08             	mov    0x8(%ebp),%edx
  801385:	8b 45 10             	mov    0x10(%ebp),%eax
  801388:	01 d0                	add    %edx,%eax
  80138a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80138d:	eb 15                	jmp    8013a4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80138f:	8b 45 08             	mov    0x8(%ebp),%eax
  801392:	8a 00                	mov    (%eax),%al
  801394:	0f b6 d0             	movzbl %al,%edx
  801397:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139a:	0f b6 c0             	movzbl %al,%eax
  80139d:	39 c2                	cmp    %eax,%edx
  80139f:	74 0d                	je     8013ae <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8013a1:	ff 45 08             	incl   0x8(%ebp)
  8013a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8013aa:	72 e3                	jb     80138f <memfind+0x13>
  8013ac:	eb 01                	jmp    8013af <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8013ae:	90                   	nop
	return (void *) s;
  8013af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8013b2:	c9                   	leave  
  8013b3:	c3                   	ret    

008013b4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8013b4:	55                   	push   %ebp
  8013b5:	89 e5                	mov    %esp,%ebp
  8013b7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8013ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013c8:	eb 03                	jmp    8013cd <strtol+0x19>
		s++;
  8013ca:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d0:	8a 00                	mov    (%eax),%al
  8013d2:	3c 20                	cmp    $0x20,%al
  8013d4:	74 f4                	je     8013ca <strtol+0x16>
  8013d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d9:	8a 00                	mov    (%eax),%al
  8013db:	3c 09                	cmp    $0x9,%al
  8013dd:	74 eb                	je     8013ca <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013df:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e2:	8a 00                	mov    (%eax),%al
  8013e4:	3c 2b                	cmp    $0x2b,%al
  8013e6:	75 05                	jne    8013ed <strtol+0x39>
		s++;
  8013e8:	ff 45 08             	incl   0x8(%ebp)
  8013eb:	eb 13                	jmp    801400 <strtol+0x4c>
	else if (*s == '-')
  8013ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f0:	8a 00                	mov    (%eax),%al
  8013f2:	3c 2d                	cmp    $0x2d,%al
  8013f4:	75 0a                	jne    801400 <strtol+0x4c>
		s++, neg = 1;
  8013f6:	ff 45 08             	incl   0x8(%ebp)
  8013f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801400:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801404:	74 06                	je     80140c <strtol+0x58>
  801406:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80140a:	75 20                	jne    80142c <strtol+0x78>
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	8a 00                	mov    (%eax),%al
  801411:	3c 30                	cmp    $0x30,%al
  801413:	75 17                	jne    80142c <strtol+0x78>
  801415:	8b 45 08             	mov    0x8(%ebp),%eax
  801418:	40                   	inc    %eax
  801419:	8a 00                	mov    (%eax),%al
  80141b:	3c 78                	cmp    $0x78,%al
  80141d:	75 0d                	jne    80142c <strtol+0x78>
		s += 2, base = 16;
  80141f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801423:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80142a:	eb 28                	jmp    801454 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80142c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801430:	75 15                	jne    801447 <strtol+0x93>
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3c 30                	cmp    $0x30,%al
  801439:	75 0c                	jne    801447 <strtol+0x93>
		s++, base = 8;
  80143b:	ff 45 08             	incl   0x8(%ebp)
  80143e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801445:	eb 0d                	jmp    801454 <strtol+0xa0>
	else if (base == 0)
  801447:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80144b:	75 07                	jne    801454 <strtol+0xa0>
		base = 10;
  80144d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801454:	8b 45 08             	mov    0x8(%ebp),%eax
  801457:	8a 00                	mov    (%eax),%al
  801459:	3c 2f                	cmp    $0x2f,%al
  80145b:	7e 19                	jle    801476 <strtol+0xc2>
  80145d:	8b 45 08             	mov    0x8(%ebp),%eax
  801460:	8a 00                	mov    (%eax),%al
  801462:	3c 39                	cmp    $0x39,%al
  801464:	7f 10                	jg     801476 <strtol+0xc2>
			dig = *s - '0';
  801466:	8b 45 08             	mov    0x8(%ebp),%eax
  801469:	8a 00                	mov    (%eax),%al
  80146b:	0f be c0             	movsbl %al,%eax
  80146e:	83 e8 30             	sub    $0x30,%eax
  801471:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801474:	eb 42                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801476:	8b 45 08             	mov    0x8(%ebp),%eax
  801479:	8a 00                	mov    (%eax),%al
  80147b:	3c 60                	cmp    $0x60,%al
  80147d:	7e 19                	jle    801498 <strtol+0xe4>
  80147f:	8b 45 08             	mov    0x8(%ebp),%eax
  801482:	8a 00                	mov    (%eax),%al
  801484:	3c 7a                	cmp    $0x7a,%al
  801486:	7f 10                	jg     801498 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801488:	8b 45 08             	mov    0x8(%ebp),%eax
  80148b:	8a 00                	mov    (%eax),%al
  80148d:	0f be c0             	movsbl %al,%eax
  801490:	83 e8 57             	sub    $0x57,%eax
  801493:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801496:	eb 20                	jmp    8014b8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801498:	8b 45 08             	mov    0x8(%ebp),%eax
  80149b:	8a 00                	mov    (%eax),%al
  80149d:	3c 40                	cmp    $0x40,%al
  80149f:	7e 39                	jle    8014da <strtol+0x126>
  8014a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a4:	8a 00                	mov    (%eax),%al
  8014a6:	3c 5a                	cmp    $0x5a,%al
  8014a8:	7f 30                	jg     8014da <strtol+0x126>
			dig = *s - 'A' + 10;
  8014aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ad:	8a 00                	mov    (%eax),%al
  8014af:	0f be c0             	movsbl %al,%eax
  8014b2:	83 e8 37             	sub    $0x37,%eax
  8014b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8014b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014bb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014be:	7d 19                	jge    8014d9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014c0:	ff 45 08             	incl   0x8(%ebp)
  8014c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014c6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014ca:	89 c2                	mov    %eax,%edx
  8014cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014cf:	01 d0                	add    %edx,%eax
  8014d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014d4:	e9 7b ff ff ff       	jmp    801454 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014d9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014de:	74 08                	je     8014e8 <strtol+0x134>
		*endptr = (char *) s;
  8014e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8014e6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014ec:	74 07                	je     8014f5 <strtol+0x141>
  8014ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014f1:	f7 d8                	neg    %eax
  8014f3:	eb 03                	jmp    8014f8 <strtol+0x144>
  8014f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014f8:	c9                   	leave  
  8014f9:	c3                   	ret    

008014fa <ltostr>:

void
ltostr(long value, char *str)
{
  8014fa:	55                   	push   %ebp
  8014fb:	89 e5                	mov    %esp,%ebp
  8014fd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801500:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801507:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80150e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801512:	79 13                	jns    801527 <ltostr+0x2d>
	{
		neg = 1;
  801514:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80151b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80151e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801521:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801524:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801527:	8b 45 08             	mov    0x8(%ebp),%eax
  80152a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80152f:	99                   	cltd   
  801530:	f7 f9                	idiv   %ecx
  801532:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801535:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801538:	8d 50 01             	lea    0x1(%eax),%edx
  80153b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80153e:	89 c2                	mov    %eax,%edx
  801540:	8b 45 0c             	mov    0xc(%ebp),%eax
  801543:	01 d0                	add    %edx,%eax
  801545:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801548:	83 c2 30             	add    $0x30,%edx
  80154b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80154d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801550:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801555:	f7 e9                	imul   %ecx
  801557:	c1 fa 02             	sar    $0x2,%edx
  80155a:	89 c8                	mov    %ecx,%eax
  80155c:	c1 f8 1f             	sar    $0x1f,%eax
  80155f:	29 c2                	sub    %eax,%edx
  801561:	89 d0                	mov    %edx,%eax
  801563:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801566:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801569:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80156e:	f7 e9                	imul   %ecx
  801570:	c1 fa 02             	sar    $0x2,%edx
  801573:	89 c8                	mov    %ecx,%eax
  801575:	c1 f8 1f             	sar    $0x1f,%eax
  801578:	29 c2                	sub    %eax,%edx
  80157a:	89 d0                	mov    %edx,%eax
  80157c:	c1 e0 02             	shl    $0x2,%eax
  80157f:	01 d0                	add    %edx,%eax
  801581:	01 c0                	add    %eax,%eax
  801583:	29 c1                	sub    %eax,%ecx
  801585:	89 ca                	mov    %ecx,%edx
  801587:	85 d2                	test   %edx,%edx
  801589:	75 9c                	jne    801527 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80158b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801592:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801595:	48                   	dec    %eax
  801596:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801599:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80159d:	74 3d                	je     8015dc <ltostr+0xe2>
		start = 1 ;
  80159f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8015a6:	eb 34                	jmp    8015dc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8015a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ae:	01 d0                	add    %edx,%eax
  8015b0:	8a 00                	mov    (%eax),%al
  8015b2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8015b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8015b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015bb:	01 c2                	add    %eax,%edx
  8015bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015c3:	01 c8                	add    %ecx,%eax
  8015c5:	8a 00                	mov    (%eax),%al
  8015c7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	01 c2                	add    %eax,%edx
  8015d1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015d4:	88 02                	mov    %al,(%edx)
		start++ ;
  8015d6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015d9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015e2:	7c c4                	jl     8015a8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015ea:	01 d0                	add    %edx,%eax
  8015ec:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015ef:	90                   	nop
  8015f0:	c9                   	leave  
  8015f1:	c3                   	ret    

008015f2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015f2:	55                   	push   %ebp
  8015f3:	89 e5                	mov    %esp,%ebp
  8015f5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015f8:	ff 75 08             	pushl  0x8(%ebp)
  8015fb:	e8 54 fa ff ff       	call   801054 <strlen>
  801600:	83 c4 04             	add    $0x4,%esp
  801603:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801606:	ff 75 0c             	pushl  0xc(%ebp)
  801609:	e8 46 fa ff ff       	call   801054 <strlen>
  80160e:	83 c4 04             	add    $0x4,%esp
  801611:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801614:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80161b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801622:	eb 17                	jmp    80163b <strcconcat+0x49>
		final[s] = str1[s] ;
  801624:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801627:	8b 45 10             	mov    0x10(%ebp),%eax
  80162a:	01 c2                	add    %eax,%edx
  80162c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80162f:	8b 45 08             	mov    0x8(%ebp),%eax
  801632:	01 c8                	add    %ecx,%eax
  801634:	8a 00                	mov    (%eax),%al
  801636:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801638:	ff 45 fc             	incl   -0x4(%ebp)
  80163b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801641:	7c e1                	jl     801624 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801643:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80164a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801651:	eb 1f                	jmp    801672 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801653:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801656:	8d 50 01             	lea    0x1(%eax),%edx
  801659:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80165c:	89 c2                	mov    %eax,%edx
  80165e:	8b 45 10             	mov    0x10(%ebp),%eax
  801661:	01 c2                	add    %eax,%edx
  801663:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801666:	8b 45 0c             	mov    0xc(%ebp),%eax
  801669:	01 c8                	add    %ecx,%eax
  80166b:	8a 00                	mov    (%eax),%al
  80166d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80166f:	ff 45 f8             	incl   -0x8(%ebp)
  801672:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801675:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801678:	7c d9                	jl     801653 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80167a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80167d:	8b 45 10             	mov    0x10(%ebp),%eax
  801680:	01 d0                	add    %edx,%eax
  801682:	c6 00 00             	movb   $0x0,(%eax)
}
  801685:	90                   	nop
  801686:	c9                   	leave  
  801687:	c3                   	ret    

00801688 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801688:	55                   	push   %ebp
  801689:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80168b:	8b 45 14             	mov    0x14(%ebp),%eax
  80168e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801694:	8b 45 14             	mov    0x14(%ebp),%eax
  801697:	8b 00                	mov    (%eax),%eax
  801699:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8016a3:	01 d0                	add    %edx,%eax
  8016a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016ab:	eb 0c                	jmp    8016b9 <strsplit+0x31>
			*string++ = 0;
  8016ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b0:	8d 50 01             	lea    0x1(%eax),%edx
  8016b3:	89 55 08             	mov    %edx,0x8(%ebp)
  8016b6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8016b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bc:	8a 00                	mov    (%eax),%al
  8016be:	84 c0                	test   %al,%al
  8016c0:	74 18                	je     8016da <strsplit+0x52>
  8016c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c5:	8a 00                	mov    (%eax),%al
  8016c7:	0f be c0             	movsbl %al,%eax
  8016ca:	50                   	push   %eax
  8016cb:	ff 75 0c             	pushl  0xc(%ebp)
  8016ce:	e8 13 fb ff ff       	call   8011e6 <strchr>
  8016d3:	83 c4 08             	add    $0x8,%esp
  8016d6:	85 c0                	test   %eax,%eax
  8016d8:	75 d3                	jne    8016ad <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016da:	8b 45 08             	mov    0x8(%ebp),%eax
  8016dd:	8a 00                	mov    (%eax),%al
  8016df:	84 c0                	test   %al,%al
  8016e1:	74 5a                	je     80173d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8016e6:	8b 00                	mov    (%eax),%eax
  8016e8:	83 f8 0f             	cmp    $0xf,%eax
  8016eb:	75 07                	jne    8016f4 <strsplit+0x6c>
		{
			return 0;
  8016ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8016f2:	eb 66                	jmp    80175a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8016f7:	8b 00                	mov    (%eax),%eax
  8016f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8016fc:	8b 55 14             	mov    0x14(%ebp),%edx
  8016ff:	89 0a                	mov    %ecx,(%edx)
  801701:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801708:	8b 45 10             	mov    0x10(%ebp),%eax
  80170b:	01 c2                	add    %eax,%edx
  80170d:	8b 45 08             	mov    0x8(%ebp),%eax
  801710:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801712:	eb 03                	jmp    801717 <strsplit+0x8f>
			string++;
  801714:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801717:	8b 45 08             	mov    0x8(%ebp),%eax
  80171a:	8a 00                	mov    (%eax),%al
  80171c:	84 c0                	test   %al,%al
  80171e:	74 8b                	je     8016ab <strsplit+0x23>
  801720:	8b 45 08             	mov    0x8(%ebp),%eax
  801723:	8a 00                	mov    (%eax),%al
  801725:	0f be c0             	movsbl %al,%eax
  801728:	50                   	push   %eax
  801729:	ff 75 0c             	pushl  0xc(%ebp)
  80172c:	e8 b5 fa ff ff       	call   8011e6 <strchr>
  801731:	83 c4 08             	add    $0x8,%esp
  801734:	85 c0                	test   %eax,%eax
  801736:	74 dc                	je     801714 <strsplit+0x8c>
			string++;
	}
  801738:	e9 6e ff ff ff       	jmp    8016ab <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80173d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80173e:	8b 45 14             	mov    0x14(%ebp),%eax
  801741:	8b 00                	mov    (%eax),%eax
  801743:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80174a:	8b 45 10             	mov    0x10(%ebp),%eax
  80174d:	01 d0                	add    %edx,%eax
  80174f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801755:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80175a:	c9                   	leave  
  80175b:	c3                   	ret    

0080175c <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80175c:	55                   	push   %ebp
  80175d:	89 e5                	mov    %esp,%ebp
  80175f:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801762:	a1 04 50 80 00       	mov    0x805004,%eax
  801767:	85 c0                	test   %eax,%eax
  801769:	74 1f                	je     80178a <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  80176b:	e8 1d 00 00 00       	call   80178d <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801770:	83 ec 0c             	sub    $0xc,%esp
  801773:	68 f0 3e 80 00       	push   $0x803ef0
  801778:	e8 55 f2 ff ff       	call   8009d2 <cprintf>
  80177d:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801780:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801787:	00 00 00 
	}
}
  80178a:	90                   	nop
  80178b:	c9                   	leave  
  80178c:	c3                   	ret    

0080178d <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80178d:	55                   	push   %ebp
  80178e:	89 e5                	mov    %esp,%ebp
  801790:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801793:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  80179a:	00 00 00 
  80179d:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8017a4:	00 00 00 
  8017a7:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8017ae:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8017b1:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8017b8:	00 00 00 
  8017bb:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8017c2:	00 00 00 
  8017c5:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8017cc:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  8017cf:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  8017d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017d9:	c1 e8 0c             	shr    $0xc,%eax
  8017dc:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  8017e1:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8017e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8017eb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8017f0:	2d 00 10 00 00       	sub    $0x1000,%eax
  8017f5:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  8017fa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801801:	a1 20 51 80 00       	mov    0x805120,%eax
  801806:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  80180a:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  80180d:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801814:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801817:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80181a:	01 d0                	add    %edx,%eax
  80181c:	48                   	dec    %eax
  80181d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801820:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801823:	ba 00 00 00 00       	mov    $0x0,%edx
  801828:	f7 75 e4             	divl   -0x1c(%ebp)
  80182b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80182e:	29 d0                	sub    %edx,%eax
  801830:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801833:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  80183a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80183d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801842:	2d 00 10 00 00       	sub    $0x1000,%eax
  801847:	83 ec 04             	sub    $0x4,%esp
  80184a:	6a 07                	push   $0x7
  80184c:	ff 75 e8             	pushl  -0x18(%ebp)
  80184f:	50                   	push   %eax
  801850:	e8 3d 06 00 00       	call   801e92 <sys_allocate_chunk>
  801855:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801858:	a1 20 51 80 00       	mov    0x805120,%eax
  80185d:	83 ec 0c             	sub    $0xc,%esp
  801860:	50                   	push   %eax
  801861:	e8 b2 0c 00 00       	call   802518 <initialize_MemBlocksList>
  801866:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801869:	a1 4c 51 80 00       	mov    0x80514c,%eax
  80186e:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801871:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801875:	0f 84 f3 00 00 00    	je     80196e <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  80187b:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80187f:	75 14                	jne    801895 <initialize_dyn_block_system+0x108>
  801881:	83 ec 04             	sub    $0x4,%esp
  801884:	68 15 3f 80 00       	push   $0x803f15
  801889:	6a 36                	push   $0x36
  80188b:	68 33 3f 80 00       	push   $0x803f33
  801890:	e8 89 ee ff ff       	call   80071e <_panic>
  801895:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801898:	8b 00                	mov    (%eax),%eax
  80189a:	85 c0                	test   %eax,%eax
  80189c:	74 10                	je     8018ae <initialize_dyn_block_system+0x121>
  80189e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018a1:	8b 00                	mov    (%eax),%eax
  8018a3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018a6:	8b 52 04             	mov    0x4(%edx),%edx
  8018a9:	89 50 04             	mov    %edx,0x4(%eax)
  8018ac:	eb 0b                	jmp    8018b9 <initialize_dyn_block_system+0x12c>
  8018ae:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018b1:	8b 40 04             	mov    0x4(%eax),%eax
  8018b4:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8018b9:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018bc:	8b 40 04             	mov    0x4(%eax),%eax
  8018bf:	85 c0                	test   %eax,%eax
  8018c1:	74 0f                	je     8018d2 <initialize_dyn_block_system+0x145>
  8018c3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018c6:	8b 40 04             	mov    0x4(%eax),%eax
  8018c9:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8018cc:	8b 12                	mov    (%edx),%edx
  8018ce:	89 10                	mov    %edx,(%eax)
  8018d0:	eb 0a                	jmp    8018dc <initialize_dyn_block_system+0x14f>
  8018d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018d5:	8b 00                	mov    (%eax),%eax
  8018d7:	a3 48 51 80 00       	mov    %eax,0x805148
  8018dc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018df:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8018e5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018e8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8018ef:	a1 54 51 80 00       	mov    0x805154,%eax
  8018f4:	48                   	dec    %eax
  8018f5:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  8018fa:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8018fd:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801904:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801907:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  80190e:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801912:	75 14                	jne    801928 <initialize_dyn_block_system+0x19b>
  801914:	83 ec 04             	sub    $0x4,%esp
  801917:	68 40 3f 80 00       	push   $0x803f40
  80191c:	6a 3e                	push   $0x3e
  80191e:	68 33 3f 80 00       	push   $0x803f33
  801923:	e8 f6 ed ff ff       	call   80071e <_panic>
  801928:	8b 15 38 51 80 00    	mov    0x805138,%edx
  80192e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801931:	89 10                	mov    %edx,(%eax)
  801933:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801936:	8b 00                	mov    (%eax),%eax
  801938:	85 c0                	test   %eax,%eax
  80193a:	74 0d                	je     801949 <initialize_dyn_block_system+0x1bc>
  80193c:	a1 38 51 80 00       	mov    0x805138,%eax
  801941:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801944:	89 50 04             	mov    %edx,0x4(%eax)
  801947:	eb 08                	jmp    801951 <initialize_dyn_block_system+0x1c4>
  801949:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80194c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801951:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801954:	a3 38 51 80 00       	mov    %eax,0x805138
  801959:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80195c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801963:	a1 44 51 80 00       	mov    0x805144,%eax
  801968:	40                   	inc    %eax
  801969:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  80196e:	90                   	nop
  80196f:	c9                   	leave  
  801970:	c3                   	ret    

00801971 <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801971:	55                   	push   %ebp
  801972:	89 e5                	mov    %esp,%ebp
  801974:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801977:	e8 e0 fd ff ff       	call   80175c <InitializeUHeap>
		if (size == 0) return NULL ;
  80197c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801980:	75 07                	jne    801989 <malloc+0x18>
  801982:	b8 00 00 00 00       	mov    $0x0,%eax
  801987:	eb 7f                	jmp    801a08 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801989:	e8 d2 08 00 00       	call   802260 <sys_isUHeapPlacementStrategyFIRSTFIT>
  80198e:	85 c0                	test   %eax,%eax
  801990:	74 71                	je     801a03 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801992:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801999:	8b 55 08             	mov    0x8(%ebp),%edx
  80199c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80199f:	01 d0                	add    %edx,%eax
  8019a1:	48                   	dec    %eax
  8019a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8019a5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019a8:	ba 00 00 00 00       	mov    $0x0,%edx
  8019ad:	f7 75 f4             	divl   -0xc(%ebp)
  8019b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019b3:	29 d0                	sub    %edx,%eax
  8019b5:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  8019b8:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  8019bf:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  8019c6:	76 07                	jbe    8019cf <malloc+0x5e>
					return NULL ;
  8019c8:	b8 00 00 00 00       	mov    $0x0,%eax
  8019cd:	eb 39                	jmp    801a08 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  8019cf:	83 ec 0c             	sub    $0xc,%esp
  8019d2:	ff 75 08             	pushl  0x8(%ebp)
  8019d5:	e8 e6 0d 00 00       	call   8027c0 <alloc_block_FF>
  8019da:	83 c4 10             	add    $0x10,%esp
  8019dd:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  8019e0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8019e4:	74 16                	je     8019fc <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  8019e6:	83 ec 0c             	sub    $0xc,%esp
  8019e9:	ff 75 ec             	pushl  -0x14(%ebp)
  8019ec:	e8 37 0c 00 00       	call   802628 <insert_sorted_allocList>
  8019f1:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  8019f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8019f7:	8b 40 08             	mov    0x8(%eax),%eax
  8019fa:	eb 0c                	jmp    801a08 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  8019fc:	b8 00 00 00 00       	mov    $0x0,%eax
  801a01:	eb 05                	jmp    801a08 <malloc+0x97>
				}
		}
	return 0;
  801a03:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a08:	c9                   	leave  
  801a09:	c3                   	ret    

00801a0a <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801a0a:	55                   	push   %ebp
  801a0b:	89 e5                	mov    %esp,%ebp
  801a0d:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801a10:	8b 45 08             	mov    0x8(%ebp),%eax
  801a13:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801a16:	83 ec 08             	sub    $0x8,%esp
  801a19:	ff 75 f4             	pushl  -0xc(%ebp)
  801a1c:	68 40 50 80 00       	push   $0x805040
  801a21:	e8 cf 0b 00 00       	call   8025f5 <find_block>
  801a26:	83 c4 10             	add    $0x10,%esp
  801a29:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801a2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a2f:	8b 40 0c             	mov    0xc(%eax),%eax
  801a32:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801a35:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a38:	8b 40 08             	mov    0x8(%eax),%eax
  801a3b:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801a3e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a42:	0f 84 a1 00 00 00    	je     801ae9 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801a48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801a4c:	75 17                	jne    801a65 <free+0x5b>
  801a4e:	83 ec 04             	sub    $0x4,%esp
  801a51:	68 15 3f 80 00       	push   $0x803f15
  801a56:	68 80 00 00 00       	push   $0x80
  801a5b:	68 33 3f 80 00       	push   $0x803f33
  801a60:	e8 b9 ec ff ff       	call   80071e <_panic>
  801a65:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a68:	8b 00                	mov    (%eax),%eax
  801a6a:	85 c0                	test   %eax,%eax
  801a6c:	74 10                	je     801a7e <free+0x74>
  801a6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a71:	8b 00                	mov    (%eax),%eax
  801a73:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a76:	8b 52 04             	mov    0x4(%edx),%edx
  801a79:	89 50 04             	mov    %edx,0x4(%eax)
  801a7c:	eb 0b                	jmp    801a89 <free+0x7f>
  801a7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a81:	8b 40 04             	mov    0x4(%eax),%eax
  801a84:	a3 44 50 80 00       	mov    %eax,0x805044
  801a89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a8c:	8b 40 04             	mov    0x4(%eax),%eax
  801a8f:	85 c0                	test   %eax,%eax
  801a91:	74 0f                	je     801aa2 <free+0x98>
  801a93:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801a96:	8b 40 04             	mov    0x4(%eax),%eax
  801a99:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a9c:	8b 12                	mov    (%edx),%edx
  801a9e:	89 10                	mov    %edx,(%eax)
  801aa0:	eb 0a                	jmp    801aac <free+0xa2>
  801aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aa5:	8b 00                	mov    (%eax),%eax
  801aa7:	a3 40 50 80 00       	mov    %eax,0x805040
  801aac:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801aaf:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801ab5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ab8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801abf:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801ac4:	48                   	dec    %eax
  801ac5:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801aca:	83 ec 0c             	sub    $0xc,%esp
  801acd:	ff 75 f0             	pushl  -0x10(%ebp)
  801ad0:	e8 29 12 00 00       	call   802cfe <insert_sorted_with_merge_freeList>
  801ad5:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801ad8:	83 ec 08             	sub    $0x8,%esp
  801adb:	ff 75 ec             	pushl  -0x14(%ebp)
  801ade:	ff 75 e8             	pushl  -0x18(%ebp)
  801ae1:	e8 74 03 00 00       	call   801e5a <sys_free_user_mem>
  801ae6:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801ae9:	90                   	nop
  801aea:	c9                   	leave  
  801aeb:	c3                   	ret    

00801aec <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801aec:	55                   	push   %ebp
  801aed:	89 e5                	mov    %esp,%ebp
  801aef:	83 ec 38             	sub    $0x38,%esp
  801af2:	8b 45 10             	mov    0x10(%ebp),%eax
  801af5:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801af8:	e8 5f fc ff ff       	call   80175c <InitializeUHeap>
	if (size == 0) return NULL ;
  801afd:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801b01:	75 0a                	jne    801b0d <smalloc+0x21>
  801b03:	b8 00 00 00 00       	mov    $0x0,%eax
  801b08:	e9 b2 00 00 00       	jmp    801bbf <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801b0d:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801b14:	76 0a                	jbe    801b20 <smalloc+0x34>
		return NULL;
  801b16:	b8 00 00 00 00       	mov    $0x0,%eax
  801b1b:	e9 9f 00 00 00       	jmp    801bbf <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801b20:	e8 3b 07 00 00       	call   802260 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b25:	85 c0                	test   %eax,%eax
  801b27:	0f 84 8d 00 00 00    	je     801bba <smalloc+0xce>
	struct MemBlock *b = NULL;
  801b2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801b34:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801b3b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801b41:	01 d0                	add    %edx,%eax
  801b43:	48                   	dec    %eax
  801b44:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801b47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b4a:	ba 00 00 00 00       	mov    $0x0,%edx
  801b4f:	f7 75 f0             	divl   -0x10(%ebp)
  801b52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801b55:	29 d0                	sub    %edx,%eax
  801b57:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801b5a:	83 ec 0c             	sub    $0xc,%esp
  801b5d:	ff 75 e8             	pushl  -0x18(%ebp)
  801b60:	e8 5b 0c 00 00       	call   8027c0 <alloc_block_FF>
  801b65:	83 c4 10             	add    $0x10,%esp
  801b68:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801b6b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801b6f:	75 07                	jne    801b78 <smalloc+0x8c>
			return NULL;
  801b71:	b8 00 00 00 00       	mov    $0x0,%eax
  801b76:	eb 47                	jmp    801bbf <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801b78:	83 ec 0c             	sub    $0xc,%esp
  801b7b:	ff 75 f4             	pushl  -0xc(%ebp)
  801b7e:	e8 a5 0a 00 00       	call   802628 <insert_sorted_allocList>
  801b83:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801b86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b89:	8b 40 08             	mov    0x8(%eax),%eax
  801b8c:	89 c2                	mov    %eax,%edx
  801b8e:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801b92:	52                   	push   %edx
  801b93:	50                   	push   %eax
  801b94:	ff 75 0c             	pushl  0xc(%ebp)
  801b97:	ff 75 08             	pushl  0x8(%ebp)
  801b9a:	e8 46 04 00 00       	call   801fe5 <sys_createSharedObject>
  801b9f:	83 c4 10             	add    $0x10,%esp
  801ba2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801ba5:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801ba9:	78 08                	js     801bb3 <smalloc+0xc7>
		return (void *)b->sva;
  801bab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bae:	8b 40 08             	mov    0x8(%eax),%eax
  801bb1:	eb 0c                	jmp    801bbf <smalloc+0xd3>
		}else{
		return NULL;
  801bb3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bb8:	eb 05                	jmp    801bbf <smalloc+0xd3>
			}

	}return NULL;
  801bba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801bbf:	c9                   	leave  
  801bc0:	c3                   	ret    

00801bc1 <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801bc1:	55                   	push   %ebp
  801bc2:	89 e5                	mov    %esp,%ebp
  801bc4:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801bc7:	e8 90 fb ff ff       	call   80175c <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801bcc:	e8 8f 06 00 00       	call   802260 <sys_isUHeapPlacementStrategyFIRSTFIT>
  801bd1:	85 c0                	test   %eax,%eax
  801bd3:	0f 84 ad 00 00 00    	je     801c86 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801bd9:	83 ec 08             	sub    $0x8,%esp
  801bdc:	ff 75 0c             	pushl  0xc(%ebp)
  801bdf:	ff 75 08             	pushl  0x8(%ebp)
  801be2:	e8 28 04 00 00       	call   80200f <sys_getSizeOfSharedObject>
  801be7:	83 c4 10             	add    $0x10,%esp
  801bea:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801bed:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801bf1:	79 0a                	jns    801bfd <sget+0x3c>
    {
    	return NULL;
  801bf3:	b8 00 00 00 00       	mov    $0x0,%eax
  801bf8:	e9 8e 00 00 00       	jmp    801c8b <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801bfd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801c04:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801c0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801c0e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c11:	01 d0                	add    %edx,%eax
  801c13:	48                   	dec    %eax
  801c14:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801c17:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c1a:	ba 00 00 00 00       	mov    $0x0,%edx
  801c1f:	f7 75 ec             	divl   -0x14(%ebp)
  801c22:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801c25:	29 d0                	sub    %edx,%eax
  801c27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801c2a:	83 ec 0c             	sub    $0xc,%esp
  801c2d:	ff 75 e4             	pushl  -0x1c(%ebp)
  801c30:	e8 8b 0b 00 00       	call   8027c0 <alloc_block_FF>
  801c35:	83 c4 10             	add    $0x10,%esp
  801c38:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801c3b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c3f:	75 07                	jne    801c48 <sget+0x87>
				return NULL;
  801c41:	b8 00 00 00 00       	mov    $0x0,%eax
  801c46:	eb 43                	jmp    801c8b <sget+0xca>
			}
			insert_sorted_allocList(b);
  801c48:	83 ec 0c             	sub    $0xc,%esp
  801c4b:	ff 75 f0             	pushl  -0x10(%ebp)
  801c4e:	e8 d5 09 00 00       	call   802628 <insert_sorted_allocList>
  801c53:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c59:	8b 40 08             	mov    0x8(%eax),%eax
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	50                   	push   %eax
  801c60:	ff 75 0c             	pushl  0xc(%ebp)
  801c63:	ff 75 08             	pushl  0x8(%ebp)
  801c66:	e8 c1 03 00 00       	call   80202c <sys_getSharedObject>
  801c6b:	83 c4 10             	add    $0x10,%esp
  801c6e:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801c71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801c75:	78 08                	js     801c7f <sget+0xbe>
			return (void *)b->sva;
  801c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7a:	8b 40 08             	mov    0x8(%eax),%eax
  801c7d:	eb 0c                	jmp    801c8b <sget+0xca>
			}else{
			return NULL;
  801c7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801c84:	eb 05                	jmp    801c8b <sget+0xca>
			}
    }}return NULL;
  801c86:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c8b:	c9                   	leave  
  801c8c:	c3                   	ret    

00801c8d <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801c8d:	55                   	push   %ebp
  801c8e:	89 e5                	mov    %esp,%ebp
  801c90:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801c93:	e8 c4 fa ff ff       	call   80175c <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801c98:	83 ec 04             	sub    $0x4,%esp
  801c9b:	68 64 3f 80 00       	push   $0x803f64
  801ca0:	68 03 01 00 00       	push   $0x103
  801ca5:	68 33 3f 80 00       	push   $0x803f33
  801caa:	e8 6f ea ff ff       	call   80071e <_panic>

00801caf <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801cb5:	83 ec 04             	sub    $0x4,%esp
  801cb8:	68 8c 3f 80 00       	push   $0x803f8c
  801cbd:	68 17 01 00 00       	push   $0x117
  801cc2:	68 33 3f 80 00       	push   $0x803f33
  801cc7:	e8 52 ea ff ff       	call   80071e <_panic>

00801ccc <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801ccc:	55                   	push   %ebp
  801ccd:	89 e5                	mov    %esp,%ebp
  801ccf:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cd2:	83 ec 04             	sub    $0x4,%esp
  801cd5:	68 b0 3f 80 00       	push   $0x803fb0
  801cda:	68 22 01 00 00       	push   $0x122
  801cdf:	68 33 3f 80 00       	push   $0x803f33
  801ce4:	e8 35 ea ff ff       	call   80071e <_panic>

00801ce9 <shrink>:

}
void shrink(uint32 newSize)
{
  801ce9:	55                   	push   %ebp
  801cea:	89 e5                	mov    %esp,%ebp
  801cec:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801cef:	83 ec 04             	sub    $0x4,%esp
  801cf2:	68 b0 3f 80 00       	push   $0x803fb0
  801cf7:	68 27 01 00 00       	push   $0x127
  801cfc:	68 33 3f 80 00       	push   $0x803f33
  801d01:	e8 18 ea ff ff       	call   80071e <_panic>

00801d06 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801d06:	55                   	push   %ebp
  801d07:	89 e5                	mov    %esp,%ebp
  801d09:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801d0c:	83 ec 04             	sub    $0x4,%esp
  801d0f:	68 b0 3f 80 00       	push   $0x803fb0
  801d14:	68 2c 01 00 00       	push   $0x12c
  801d19:	68 33 3f 80 00       	push   $0x803f33
  801d1e:	e8 fb e9 ff ff       	call   80071e <_panic>

00801d23 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
  801d26:	57                   	push   %edi
  801d27:	56                   	push   %esi
  801d28:	53                   	push   %ebx
  801d29:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  801d2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d32:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d35:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d38:	8b 7d 18             	mov    0x18(%ebp),%edi
  801d3b:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801d3e:	cd 30                	int    $0x30
  801d40:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801d43:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801d46:	83 c4 10             	add    $0x10,%esp
  801d49:	5b                   	pop    %ebx
  801d4a:	5e                   	pop    %esi
  801d4b:	5f                   	pop    %edi
  801d4c:	5d                   	pop    %ebp
  801d4d:	c3                   	ret    

00801d4e <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801d4e:	55                   	push   %ebp
  801d4f:	89 e5                	mov    %esp,%ebp
  801d51:	83 ec 04             	sub    $0x4,%esp
  801d54:	8b 45 10             	mov    0x10(%ebp),%eax
  801d57:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801d5a:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  801d61:	6a 00                	push   $0x0
  801d63:	6a 00                	push   $0x0
  801d65:	52                   	push   %edx
  801d66:	ff 75 0c             	pushl  0xc(%ebp)
  801d69:	50                   	push   %eax
  801d6a:	6a 00                	push   $0x0
  801d6c:	e8 b2 ff ff ff       	call   801d23 <syscall>
  801d71:	83 c4 18             	add    $0x18,%esp
}
  801d74:	90                   	nop
  801d75:	c9                   	leave  
  801d76:	c3                   	ret    

00801d77 <sys_cgetc>:

int
sys_cgetc(void)
{
  801d77:	55                   	push   %ebp
  801d78:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801d7a:	6a 00                	push   $0x0
  801d7c:	6a 00                	push   $0x0
  801d7e:	6a 00                	push   $0x0
  801d80:	6a 00                	push   $0x0
  801d82:	6a 00                	push   $0x0
  801d84:	6a 01                	push   $0x1
  801d86:	e8 98 ff ff ff       	call   801d23 <syscall>
  801d8b:	83 c4 18             	add    $0x18,%esp
}
  801d8e:	c9                   	leave  
  801d8f:	c3                   	ret    

00801d90 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801d90:	55                   	push   %ebp
  801d91:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801d93:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d96:	8b 45 08             	mov    0x8(%ebp),%eax
  801d99:	6a 00                	push   $0x0
  801d9b:	6a 00                	push   $0x0
  801d9d:	6a 00                	push   $0x0
  801d9f:	52                   	push   %edx
  801da0:	50                   	push   %eax
  801da1:	6a 05                	push   $0x5
  801da3:	e8 7b ff ff ff       	call   801d23 <syscall>
  801da8:	83 c4 18             	add    $0x18,%esp
}
  801dab:	c9                   	leave  
  801dac:	c3                   	ret    

00801dad <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801dad:	55                   	push   %ebp
  801dae:	89 e5                	mov    %esp,%ebp
  801db0:	56                   	push   %esi
  801db1:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801db2:	8b 75 18             	mov    0x18(%ebp),%esi
  801db5:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801db8:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801dbb:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dbe:	8b 45 08             	mov    0x8(%ebp),%eax
  801dc1:	56                   	push   %esi
  801dc2:	53                   	push   %ebx
  801dc3:	51                   	push   %ecx
  801dc4:	52                   	push   %edx
  801dc5:	50                   	push   %eax
  801dc6:	6a 06                	push   $0x6
  801dc8:	e8 56 ff ff ff       	call   801d23 <syscall>
  801dcd:	83 c4 18             	add    $0x18,%esp
}
  801dd0:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801dd3:	5b                   	pop    %ebx
  801dd4:	5e                   	pop    %esi
  801dd5:	5d                   	pop    %ebp
  801dd6:	c3                   	ret    

00801dd7 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801dd7:	55                   	push   %ebp
  801dd8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801dda:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ddd:	8b 45 08             	mov    0x8(%ebp),%eax
  801de0:	6a 00                	push   $0x0
  801de2:	6a 00                	push   $0x0
  801de4:	6a 00                	push   $0x0
  801de6:	52                   	push   %edx
  801de7:	50                   	push   %eax
  801de8:	6a 07                	push   $0x7
  801dea:	e8 34 ff ff ff       	call   801d23 <syscall>
  801def:	83 c4 18             	add    $0x18,%esp
}
  801df2:	c9                   	leave  
  801df3:	c3                   	ret    

00801df4 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801df4:	55                   	push   %ebp
  801df5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801df7:	6a 00                	push   $0x0
  801df9:	6a 00                	push   $0x0
  801dfb:	6a 00                	push   $0x0
  801dfd:	ff 75 0c             	pushl  0xc(%ebp)
  801e00:	ff 75 08             	pushl  0x8(%ebp)
  801e03:	6a 08                	push   $0x8
  801e05:	e8 19 ff ff ff       	call   801d23 <syscall>
  801e0a:	83 c4 18             	add    $0x18,%esp
}
  801e0d:	c9                   	leave  
  801e0e:	c3                   	ret    

00801e0f <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801e0f:	55                   	push   %ebp
  801e10:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801e12:	6a 00                	push   $0x0
  801e14:	6a 00                	push   $0x0
  801e16:	6a 00                	push   $0x0
  801e18:	6a 00                	push   $0x0
  801e1a:	6a 00                	push   $0x0
  801e1c:	6a 09                	push   $0x9
  801e1e:	e8 00 ff ff ff       	call   801d23 <syscall>
  801e23:	83 c4 18             	add    $0x18,%esp
}
  801e26:	c9                   	leave  
  801e27:	c3                   	ret    

00801e28 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801e28:	55                   	push   %ebp
  801e29:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801e2b:	6a 00                	push   $0x0
  801e2d:	6a 00                	push   $0x0
  801e2f:	6a 00                	push   $0x0
  801e31:	6a 00                	push   $0x0
  801e33:	6a 00                	push   $0x0
  801e35:	6a 0a                	push   $0xa
  801e37:	e8 e7 fe ff ff       	call   801d23 <syscall>
  801e3c:	83 c4 18             	add    $0x18,%esp
}
  801e3f:	c9                   	leave  
  801e40:	c3                   	ret    

00801e41 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801e41:	55                   	push   %ebp
  801e42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801e44:	6a 00                	push   $0x0
  801e46:	6a 00                	push   $0x0
  801e48:	6a 00                	push   $0x0
  801e4a:	6a 00                	push   $0x0
  801e4c:	6a 00                	push   $0x0
  801e4e:	6a 0b                	push   $0xb
  801e50:	e8 ce fe ff ff       	call   801d23 <syscall>
  801e55:	83 c4 18             	add    $0x18,%esp
}
  801e58:	c9                   	leave  
  801e59:	c3                   	ret    

00801e5a <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801e5a:	55                   	push   %ebp
  801e5b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801e5d:	6a 00                	push   $0x0
  801e5f:	6a 00                	push   $0x0
  801e61:	6a 00                	push   $0x0
  801e63:	ff 75 0c             	pushl  0xc(%ebp)
  801e66:	ff 75 08             	pushl  0x8(%ebp)
  801e69:	6a 0f                	push   $0xf
  801e6b:	e8 b3 fe ff ff       	call   801d23 <syscall>
  801e70:	83 c4 18             	add    $0x18,%esp
	return;
  801e73:	90                   	nop
}
  801e74:	c9                   	leave  
  801e75:	c3                   	ret    

00801e76 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801e76:	55                   	push   %ebp
  801e77:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801e79:	6a 00                	push   $0x0
  801e7b:	6a 00                	push   $0x0
  801e7d:	6a 00                	push   $0x0
  801e7f:	ff 75 0c             	pushl  0xc(%ebp)
  801e82:	ff 75 08             	pushl  0x8(%ebp)
  801e85:	6a 10                	push   $0x10
  801e87:	e8 97 fe ff ff       	call   801d23 <syscall>
  801e8c:	83 c4 18             	add    $0x18,%esp
	return ;
  801e8f:	90                   	nop
}
  801e90:	c9                   	leave  
  801e91:	c3                   	ret    

00801e92 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801e92:	55                   	push   %ebp
  801e93:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801e95:	6a 00                	push   $0x0
  801e97:	6a 00                	push   $0x0
  801e99:	ff 75 10             	pushl  0x10(%ebp)
  801e9c:	ff 75 0c             	pushl  0xc(%ebp)
  801e9f:	ff 75 08             	pushl  0x8(%ebp)
  801ea2:	6a 11                	push   $0x11
  801ea4:	e8 7a fe ff ff       	call   801d23 <syscall>
  801ea9:	83 c4 18             	add    $0x18,%esp
	return ;
  801eac:	90                   	nop
}
  801ead:	c9                   	leave  
  801eae:	c3                   	ret    

00801eaf <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801eaf:	55                   	push   %ebp
  801eb0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801eb2:	6a 00                	push   $0x0
  801eb4:	6a 00                	push   $0x0
  801eb6:	6a 00                	push   $0x0
  801eb8:	6a 00                	push   $0x0
  801eba:	6a 00                	push   $0x0
  801ebc:	6a 0c                	push   $0xc
  801ebe:	e8 60 fe ff ff       	call   801d23 <syscall>
  801ec3:	83 c4 18             	add    $0x18,%esp
}
  801ec6:	c9                   	leave  
  801ec7:	c3                   	ret    

00801ec8 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801ec8:	55                   	push   %ebp
  801ec9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801ecb:	6a 00                	push   $0x0
  801ecd:	6a 00                	push   $0x0
  801ecf:	6a 00                	push   $0x0
  801ed1:	6a 00                	push   $0x0
  801ed3:	ff 75 08             	pushl  0x8(%ebp)
  801ed6:	6a 0d                	push   $0xd
  801ed8:	e8 46 fe ff ff       	call   801d23 <syscall>
  801edd:	83 c4 18             	add    $0x18,%esp
}
  801ee0:	c9                   	leave  
  801ee1:	c3                   	ret    

00801ee2 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801ee2:	55                   	push   %ebp
  801ee3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801ee5:	6a 00                	push   $0x0
  801ee7:	6a 00                	push   $0x0
  801ee9:	6a 00                	push   $0x0
  801eeb:	6a 00                	push   $0x0
  801eed:	6a 00                	push   $0x0
  801eef:	6a 0e                	push   $0xe
  801ef1:	e8 2d fe ff ff       	call   801d23 <syscall>
  801ef6:	83 c4 18             	add    $0x18,%esp
}
  801ef9:	90                   	nop
  801efa:	c9                   	leave  
  801efb:	c3                   	ret    

00801efc <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801efc:	55                   	push   %ebp
  801efd:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	6a 00                	push   $0x0
  801f05:	6a 00                	push   $0x0
  801f07:	6a 00                	push   $0x0
  801f09:	6a 13                	push   $0x13
  801f0b:	e8 13 fe ff ff       	call   801d23 <syscall>
  801f10:	83 c4 18             	add    $0x18,%esp
}
  801f13:	90                   	nop
  801f14:	c9                   	leave  
  801f15:	c3                   	ret    

00801f16 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801f16:	55                   	push   %ebp
  801f17:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801f19:	6a 00                	push   $0x0
  801f1b:	6a 00                	push   $0x0
  801f1d:	6a 00                	push   $0x0
  801f1f:	6a 00                	push   $0x0
  801f21:	6a 00                	push   $0x0
  801f23:	6a 14                	push   $0x14
  801f25:	e8 f9 fd ff ff       	call   801d23 <syscall>
  801f2a:	83 c4 18             	add    $0x18,%esp
}
  801f2d:	90                   	nop
  801f2e:	c9                   	leave  
  801f2f:	c3                   	ret    

00801f30 <sys_cputc>:


void
sys_cputc(const char c)
{
  801f30:	55                   	push   %ebp
  801f31:	89 e5                	mov    %esp,%ebp
  801f33:	83 ec 04             	sub    $0x4,%esp
  801f36:	8b 45 08             	mov    0x8(%ebp),%eax
  801f39:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801f3c:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801f40:	6a 00                	push   $0x0
  801f42:	6a 00                	push   $0x0
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	50                   	push   %eax
  801f49:	6a 15                	push   $0x15
  801f4b:	e8 d3 fd ff ff       	call   801d23 <syscall>
  801f50:	83 c4 18             	add    $0x18,%esp
}
  801f53:	90                   	nop
  801f54:	c9                   	leave  
  801f55:	c3                   	ret    

00801f56 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801f56:	55                   	push   %ebp
  801f57:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801f59:	6a 00                	push   $0x0
  801f5b:	6a 00                	push   $0x0
  801f5d:	6a 00                	push   $0x0
  801f5f:	6a 00                	push   $0x0
  801f61:	6a 00                	push   $0x0
  801f63:	6a 16                	push   $0x16
  801f65:	e8 b9 fd ff ff       	call   801d23 <syscall>
  801f6a:	83 c4 18             	add    $0x18,%esp
}
  801f6d:	90                   	nop
  801f6e:	c9                   	leave  
  801f6f:	c3                   	ret    

00801f70 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801f70:	55                   	push   %ebp
  801f71:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801f73:	8b 45 08             	mov    0x8(%ebp),%eax
  801f76:	6a 00                	push   $0x0
  801f78:	6a 00                	push   $0x0
  801f7a:	6a 00                	push   $0x0
  801f7c:	ff 75 0c             	pushl  0xc(%ebp)
  801f7f:	50                   	push   %eax
  801f80:	6a 17                	push   $0x17
  801f82:	e8 9c fd ff ff       	call   801d23 <syscall>
  801f87:	83 c4 18             	add    $0x18,%esp
}
  801f8a:	c9                   	leave  
  801f8b:	c3                   	ret    

00801f8c <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801f8c:	55                   	push   %ebp
  801f8d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801f8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f92:	8b 45 08             	mov    0x8(%ebp),%eax
  801f95:	6a 00                	push   $0x0
  801f97:	6a 00                	push   $0x0
  801f99:	6a 00                	push   $0x0
  801f9b:	52                   	push   %edx
  801f9c:	50                   	push   %eax
  801f9d:	6a 1a                	push   $0x1a
  801f9f:	e8 7f fd ff ff       	call   801d23 <syscall>
  801fa4:	83 c4 18             	add    $0x18,%esp
}
  801fa7:	c9                   	leave  
  801fa8:	c3                   	ret    

00801fa9 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fa9:	55                   	push   %ebp
  801faa:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fac:	8b 55 0c             	mov    0xc(%ebp),%edx
  801faf:	8b 45 08             	mov    0x8(%ebp),%eax
  801fb2:	6a 00                	push   $0x0
  801fb4:	6a 00                	push   $0x0
  801fb6:	6a 00                	push   $0x0
  801fb8:	52                   	push   %edx
  801fb9:	50                   	push   %eax
  801fba:	6a 18                	push   $0x18
  801fbc:	e8 62 fd ff ff       	call   801d23 <syscall>
  801fc1:	83 c4 18             	add    $0x18,%esp
}
  801fc4:	90                   	nop
  801fc5:	c9                   	leave  
  801fc6:	c3                   	ret    

00801fc7 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801fc7:	55                   	push   %ebp
  801fc8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801fca:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  801fd0:	6a 00                	push   $0x0
  801fd2:	6a 00                	push   $0x0
  801fd4:	6a 00                	push   $0x0
  801fd6:	52                   	push   %edx
  801fd7:	50                   	push   %eax
  801fd8:	6a 19                	push   $0x19
  801fda:	e8 44 fd ff ff       	call   801d23 <syscall>
  801fdf:	83 c4 18             	add    $0x18,%esp
}
  801fe2:	90                   	nop
  801fe3:	c9                   	leave  
  801fe4:	c3                   	ret    

00801fe5 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
  801fe8:	83 ec 04             	sub    $0x4,%esp
  801feb:	8b 45 10             	mov    0x10(%ebp),%eax
  801fee:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801ff1:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801ff4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801ff8:	8b 45 08             	mov    0x8(%ebp),%eax
  801ffb:	6a 00                	push   $0x0
  801ffd:	51                   	push   %ecx
  801ffe:	52                   	push   %edx
  801fff:	ff 75 0c             	pushl  0xc(%ebp)
  802002:	50                   	push   %eax
  802003:	6a 1b                	push   $0x1b
  802005:	e8 19 fd ff ff       	call   801d23 <syscall>
  80200a:	83 c4 18             	add    $0x18,%esp
}
  80200d:	c9                   	leave  
  80200e:	c3                   	ret    

0080200f <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80200f:	55                   	push   %ebp
  802010:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802012:	8b 55 0c             	mov    0xc(%ebp),%edx
  802015:	8b 45 08             	mov    0x8(%ebp),%eax
  802018:	6a 00                	push   $0x0
  80201a:	6a 00                	push   $0x0
  80201c:	6a 00                	push   $0x0
  80201e:	52                   	push   %edx
  80201f:	50                   	push   %eax
  802020:	6a 1c                	push   $0x1c
  802022:	e8 fc fc ff ff       	call   801d23 <syscall>
  802027:	83 c4 18             	add    $0x18,%esp
}
  80202a:	c9                   	leave  
  80202b:	c3                   	ret    

0080202c <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80202c:	55                   	push   %ebp
  80202d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80202f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802032:	8b 55 0c             	mov    0xc(%ebp),%edx
  802035:	8b 45 08             	mov    0x8(%ebp),%eax
  802038:	6a 00                	push   $0x0
  80203a:	6a 00                	push   $0x0
  80203c:	51                   	push   %ecx
  80203d:	52                   	push   %edx
  80203e:	50                   	push   %eax
  80203f:	6a 1d                	push   $0x1d
  802041:	e8 dd fc ff ff       	call   801d23 <syscall>
  802046:	83 c4 18             	add    $0x18,%esp
}
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80204e:	8b 55 0c             	mov    0xc(%ebp),%edx
  802051:	8b 45 08             	mov    0x8(%ebp),%eax
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	52                   	push   %edx
  80205b:	50                   	push   %eax
  80205c:	6a 1e                	push   $0x1e
  80205e:	e8 c0 fc ff ff       	call   801d23 <syscall>
  802063:	83 c4 18             	add    $0x18,%esp
}
  802066:	c9                   	leave  
  802067:	c3                   	ret    

00802068 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	6a 00                	push   $0x0
  802073:	6a 00                	push   $0x0
  802075:	6a 1f                	push   $0x1f
  802077:	e8 a7 fc ff ff       	call   801d23 <syscall>
  80207c:	83 c4 18             	add    $0x18,%esp
}
  80207f:	c9                   	leave  
  802080:	c3                   	ret    

00802081 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  802081:	55                   	push   %ebp
  802082:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802084:	8b 45 08             	mov    0x8(%ebp),%eax
  802087:	6a 00                	push   $0x0
  802089:	ff 75 14             	pushl  0x14(%ebp)
  80208c:	ff 75 10             	pushl  0x10(%ebp)
  80208f:	ff 75 0c             	pushl  0xc(%ebp)
  802092:	50                   	push   %eax
  802093:	6a 20                	push   $0x20
  802095:	e8 89 fc ff ff       	call   801d23 <syscall>
  80209a:	83 c4 18             	add    $0x18,%esp
}
  80209d:	c9                   	leave  
  80209e:	c3                   	ret    

0080209f <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80209f:	55                   	push   %ebp
  8020a0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8020a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8020a5:	6a 00                	push   $0x0
  8020a7:	6a 00                	push   $0x0
  8020a9:	6a 00                	push   $0x0
  8020ab:	6a 00                	push   $0x0
  8020ad:	50                   	push   %eax
  8020ae:	6a 21                	push   $0x21
  8020b0:	e8 6e fc ff ff       	call   801d23 <syscall>
  8020b5:	83 c4 18             	add    $0x18,%esp
}
  8020b8:	90                   	nop
  8020b9:	c9                   	leave  
  8020ba:	c3                   	ret    

008020bb <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8020bb:	55                   	push   %ebp
  8020bc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8020be:	8b 45 08             	mov    0x8(%ebp),%eax
  8020c1:	6a 00                	push   $0x0
  8020c3:	6a 00                	push   $0x0
  8020c5:	6a 00                	push   $0x0
  8020c7:	6a 00                	push   $0x0
  8020c9:	50                   	push   %eax
  8020ca:	6a 22                	push   $0x22
  8020cc:	e8 52 fc ff ff       	call   801d23 <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	6a 00                	push   $0x0
  8020e3:	6a 02                	push   $0x2
  8020e5:	e8 39 fc ff ff       	call   801d23 <syscall>
  8020ea:	83 c4 18             	add    $0x18,%esp
}
  8020ed:	c9                   	leave  
  8020ee:	c3                   	ret    

008020ef <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8020ef:	55                   	push   %ebp
  8020f0:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8020f2:	6a 00                	push   $0x0
  8020f4:	6a 00                	push   $0x0
  8020f6:	6a 00                	push   $0x0
  8020f8:	6a 00                	push   $0x0
  8020fa:	6a 00                	push   $0x0
  8020fc:	6a 03                	push   $0x3
  8020fe:	e8 20 fc ff ff       	call   801d23 <syscall>
  802103:	83 c4 18             	add    $0x18,%esp
}
  802106:	c9                   	leave  
  802107:	c3                   	ret    

00802108 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802108:	55                   	push   %ebp
  802109:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80210b:	6a 00                	push   $0x0
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 04                	push   $0x4
  802117:	e8 07 fc ff ff       	call   801d23 <syscall>
  80211c:	83 c4 18             	add    $0x18,%esp
}
  80211f:	c9                   	leave  
  802120:	c3                   	ret    

00802121 <sys_exit_env>:


void sys_exit_env(void)
{
  802121:	55                   	push   %ebp
  802122:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802124:	6a 00                	push   $0x0
  802126:	6a 00                	push   $0x0
  802128:	6a 00                	push   $0x0
  80212a:	6a 00                	push   $0x0
  80212c:	6a 00                	push   $0x0
  80212e:	6a 23                	push   $0x23
  802130:	e8 ee fb ff ff       	call   801d23 <syscall>
  802135:	83 c4 18             	add    $0x18,%esp
}
  802138:	90                   	nop
  802139:	c9                   	leave  
  80213a:	c3                   	ret    

0080213b <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80213b:	55                   	push   %ebp
  80213c:	89 e5                	mov    %esp,%ebp
  80213e:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  802141:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802144:	8d 50 04             	lea    0x4(%eax),%edx
  802147:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80214a:	6a 00                	push   $0x0
  80214c:	6a 00                	push   $0x0
  80214e:	6a 00                	push   $0x0
  802150:	52                   	push   %edx
  802151:	50                   	push   %eax
  802152:	6a 24                	push   $0x24
  802154:	e8 ca fb ff ff       	call   801d23 <syscall>
  802159:	83 c4 18             	add    $0x18,%esp
	return result;
  80215c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80215f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802162:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802165:	89 01                	mov    %eax,(%ecx)
  802167:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80216a:	8b 45 08             	mov    0x8(%ebp),%eax
  80216d:	c9                   	leave  
  80216e:	c2 04 00             	ret    $0x4

00802171 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  802171:	55                   	push   %ebp
  802172:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802174:	6a 00                	push   $0x0
  802176:	6a 00                	push   $0x0
  802178:	ff 75 10             	pushl  0x10(%ebp)
  80217b:	ff 75 0c             	pushl  0xc(%ebp)
  80217e:	ff 75 08             	pushl  0x8(%ebp)
  802181:	6a 12                	push   $0x12
  802183:	e8 9b fb ff ff       	call   801d23 <syscall>
  802188:	83 c4 18             	add    $0x18,%esp
	return ;
  80218b:	90                   	nop
}
  80218c:	c9                   	leave  
  80218d:	c3                   	ret    

0080218e <sys_rcr2>:
uint32 sys_rcr2()
{
  80218e:	55                   	push   %ebp
  80218f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  802191:	6a 00                	push   $0x0
  802193:	6a 00                	push   $0x0
  802195:	6a 00                	push   $0x0
  802197:	6a 00                	push   $0x0
  802199:	6a 00                	push   $0x0
  80219b:	6a 25                	push   $0x25
  80219d:	e8 81 fb ff ff       	call   801d23 <syscall>
  8021a2:	83 c4 18             	add    $0x18,%esp
}
  8021a5:	c9                   	leave  
  8021a6:	c3                   	ret    

008021a7 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8021a7:	55                   	push   %ebp
  8021a8:	89 e5                	mov    %esp,%ebp
  8021aa:	83 ec 04             	sub    $0x4,%esp
  8021ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8021b3:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8021b7:	6a 00                	push   $0x0
  8021b9:	6a 00                	push   $0x0
  8021bb:	6a 00                	push   $0x0
  8021bd:	6a 00                	push   $0x0
  8021bf:	50                   	push   %eax
  8021c0:	6a 26                	push   $0x26
  8021c2:	e8 5c fb ff ff       	call   801d23 <syscall>
  8021c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8021ca:	90                   	nop
}
  8021cb:	c9                   	leave  
  8021cc:	c3                   	ret    

008021cd <rsttst>:
void rsttst()
{
  8021cd:	55                   	push   %ebp
  8021ce:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8021d0:	6a 00                	push   $0x0
  8021d2:	6a 00                	push   $0x0
  8021d4:	6a 00                	push   $0x0
  8021d6:	6a 00                	push   $0x0
  8021d8:	6a 00                	push   $0x0
  8021da:	6a 28                	push   $0x28
  8021dc:	e8 42 fb ff ff       	call   801d23 <syscall>
  8021e1:	83 c4 18             	add    $0x18,%esp
	return ;
  8021e4:	90                   	nop
}
  8021e5:	c9                   	leave  
  8021e6:	c3                   	ret    

008021e7 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8021e7:	55                   	push   %ebp
  8021e8:	89 e5                	mov    %esp,%ebp
  8021ea:	83 ec 04             	sub    $0x4,%esp
  8021ed:	8b 45 14             	mov    0x14(%ebp),%eax
  8021f0:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8021f3:	8b 55 18             	mov    0x18(%ebp),%edx
  8021f6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8021fa:	52                   	push   %edx
  8021fb:	50                   	push   %eax
  8021fc:	ff 75 10             	pushl  0x10(%ebp)
  8021ff:	ff 75 0c             	pushl  0xc(%ebp)
  802202:	ff 75 08             	pushl  0x8(%ebp)
  802205:	6a 27                	push   $0x27
  802207:	e8 17 fb ff ff       	call   801d23 <syscall>
  80220c:	83 c4 18             	add    $0x18,%esp
	return ;
  80220f:	90                   	nop
}
  802210:	c9                   	leave  
  802211:	c3                   	ret    

00802212 <chktst>:
void chktst(uint32 n)
{
  802212:	55                   	push   %ebp
  802213:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802215:	6a 00                	push   $0x0
  802217:	6a 00                	push   $0x0
  802219:	6a 00                	push   $0x0
  80221b:	6a 00                	push   $0x0
  80221d:	ff 75 08             	pushl  0x8(%ebp)
  802220:	6a 29                	push   $0x29
  802222:	e8 fc fa ff ff       	call   801d23 <syscall>
  802227:	83 c4 18             	add    $0x18,%esp
	return ;
  80222a:	90                   	nop
}
  80222b:	c9                   	leave  
  80222c:	c3                   	ret    

0080222d <inctst>:

void inctst()
{
  80222d:	55                   	push   %ebp
  80222e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  802230:	6a 00                	push   $0x0
  802232:	6a 00                	push   $0x0
  802234:	6a 00                	push   $0x0
  802236:	6a 00                	push   $0x0
  802238:	6a 00                	push   $0x0
  80223a:	6a 2a                	push   $0x2a
  80223c:	e8 e2 fa ff ff       	call   801d23 <syscall>
  802241:	83 c4 18             	add    $0x18,%esp
	return ;
  802244:	90                   	nop
}
  802245:	c9                   	leave  
  802246:	c3                   	ret    

00802247 <gettst>:
uint32 gettst()
{
  802247:	55                   	push   %ebp
  802248:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80224a:	6a 00                	push   $0x0
  80224c:	6a 00                	push   $0x0
  80224e:	6a 00                	push   $0x0
  802250:	6a 00                	push   $0x0
  802252:	6a 00                	push   $0x0
  802254:	6a 2b                	push   $0x2b
  802256:	e8 c8 fa ff ff       	call   801d23 <syscall>
  80225b:	83 c4 18             	add    $0x18,%esp
}
  80225e:	c9                   	leave  
  80225f:	c3                   	ret    

00802260 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802260:	55                   	push   %ebp
  802261:	89 e5                	mov    %esp,%ebp
  802263:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802266:	6a 00                	push   $0x0
  802268:	6a 00                	push   $0x0
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	6a 2c                	push   $0x2c
  802272:	e8 ac fa ff ff       	call   801d23 <syscall>
  802277:	83 c4 18             	add    $0x18,%esp
  80227a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80227d:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802281:	75 07                	jne    80228a <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802283:	b8 01 00 00 00       	mov    $0x1,%eax
  802288:	eb 05                	jmp    80228f <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80228a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80228f:	c9                   	leave  
  802290:	c3                   	ret    

00802291 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802291:	55                   	push   %ebp
  802292:	89 e5                	mov    %esp,%ebp
  802294:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802297:	6a 00                	push   $0x0
  802299:	6a 00                	push   $0x0
  80229b:	6a 00                	push   $0x0
  80229d:	6a 00                	push   $0x0
  80229f:	6a 00                	push   $0x0
  8022a1:	6a 2c                	push   $0x2c
  8022a3:	e8 7b fa ff ff       	call   801d23 <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
  8022ab:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8022ae:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8022b2:	75 07                	jne    8022bb <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8022b4:	b8 01 00 00 00       	mov    $0x1,%eax
  8022b9:	eb 05                	jmp    8022c0 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8022bb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022c0:	c9                   	leave  
  8022c1:	c3                   	ret    

008022c2 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8022c2:	55                   	push   %ebp
  8022c3:	89 e5                	mov    %esp,%ebp
  8022c5:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022c8:	6a 00                	push   $0x0
  8022ca:	6a 00                	push   $0x0
  8022cc:	6a 00                	push   $0x0
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 2c                	push   $0x2c
  8022d4:	e8 4a fa ff ff       	call   801d23 <syscall>
  8022d9:	83 c4 18             	add    $0x18,%esp
  8022dc:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8022df:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8022e3:	75 07                	jne    8022ec <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8022e5:	b8 01 00 00 00       	mov    $0x1,%eax
  8022ea:	eb 05                	jmp    8022f1 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8022ec:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8022f1:	c9                   	leave  
  8022f2:	c3                   	ret    

008022f3 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8022f3:	55                   	push   %ebp
  8022f4:	89 e5                	mov    %esp,%ebp
  8022f6:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8022f9:	6a 00                	push   $0x0
  8022fb:	6a 00                	push   $0x0
  8022fd:	6a 00                	push   $0x0
  8022ff:	6a 00                	push   $0x0
  802301:	6a 00                	push   $0x0
  802303:	6a 2c                	push   $0x2c
  802305:	e8 19 fa ff ff       	call   801d23 <syscall>
  80230a:	83 c4 18             	add    $0x18,%esp
  80230d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  802310:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802314:	75 07                	jne    80231d <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802316:	b8 01 00 00 00       	mov    $0x1,%eax
  80231b:	eb 05                	jmp    802322 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80231d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802322:	c9                   	leave  
  802323:	c3                   	ret    

00802324 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802324:	55                   	push   %ebp
  802325:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802327:	6a 00                	push   $0x0
  802329:	6a 00                	push   $0x0
  80232b:	6a 00                	push   $0x0
  80232d:	6a 00                	push   $0x0
  80232f:	ff 75 08             	pushl  0x8(%ebp)
  802332:	6a 2d                	push   $0x2d
  802334:	e8 ea f9 ff ff       	call   801d23 <syscall>
  802339:	83 c4 18             	add    $0x18,%esp
	return ;
  80233c:	90                   	nop
}
  80233d:	c9                   	leave  
  80233e:	c3                   	ret    

0080233f <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80233f:	55                   	push   %ebp
  802340:	89 e5                	mov    %esp,%ebp
  802342:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802343:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802346:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802349:	8b 55 0c             	mov    0xc(%ebp),%edx
  80234c:	8b 45 08             	mov    0x8(%ebp),%eax
  80234f:	6a 00                	push   $0x0
  802351:	53                   	push   %ebx
  802352:	51                   	push   %ecx
  802353:	52                   	push   %edx
  802354:	50                   	push   %eax
  802355:	6a 2e                	push   $0x2e
  802357:	e8 c7 f9 ff ff       	call   801d23 <syscall>
  80235c:	83 c4 18             	add    $0x18,%esp
}
  80235f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802362:	c9                   	leave  
  802363:	c3                   	ret    

00802364 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802364:	55                   	push   %ebp
  802365:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802367:	8b 55 0c             	mov    0xc(%ebp),%edx
  80236a:	8b 45 08             	mov    0x8(%ebp),%eax
  80236d:	6a 00                	push   $0x0
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	52                   	push   %edx
  802374:	50                   	push   %eax
  802375:	6a 2f                	push   $0x2f
  802377:	e8 a7 f9 ff ff       	call   801d23 <syscall>
  80237c:	83 c4 18             	add    $0x18,%esp
}
  80237f:	c9                   	leave  
  802380:	c3                   	ret    

00802381 <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  802381:	55                   	push   %ebp
  802382:	89 e5                	mov    %esp,%ebp
  802384:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802387:	83 ec 0c             	sub    $0xc,%esp
  80238a:	68 c0 3f 80 00       	push   $0x803fc0
  80238f:	e8 3e e6 ff ff       	call   8009d2 <cprintf>
  802394:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802397:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  80239e:	83 ec 0c             	sub    $0xc,%esp
  8023a1:	68 ec 3f 80 00       	push   $0x803fec
  8023a6:	e8 27 e6 ff ff       	call   8009d2 <cprintf>
  8023ab:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8023ae:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8023b2:	a1 38 51 80 00       	mov    0x805138,%eax
  8023b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8023ba:	eb 56                	jmp    802412 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8023bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8023c0:	74 1c                	je     8023de <print_mem_block_lists+0x5d>
  8023c2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023c5:	8b 50 08             	mov    0x8(%eax),%edx
  8023c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023cb:	8b 48 08             	mov    0x8(%eax),%ecx
  8023ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8023d1:	8b 40 0c             	mov    0xc(%eax),%eax
  8023d4:	01 c8                	add    %ecx,%eax
  8023d6:	39 c2                	cmp    %eax,%edx
  8023d8:	73 04                	jae    8023de <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8023da:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8023de:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e1:	8b 50 08             	mov    0x8(%eax),%edx
  8023e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023e7:	8b 40 0c             	mov    0xc(%eax),%eax
  8023ea:	01 c2                	add    %eax,%edx
  8023ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8023ef:	8b 40 08             	mov    0x8(%eax),%eax
  8023f2:	83 ec 04             	sub    $0x4,%esp
  8023f5:	52                   	push   %edx
  8023f6:	50                   	push   %eax
  8023f7:	68 01 40 80 00       	push   $0x804001
  8023fc:	e8 d1 e5 ff ff       	call   8009d2 <cprintf>
  802401:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802404:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802407:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80240a:	a1 40 51 80 00       	mov    0x805140,%eax
  80240f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802412:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802416:	74 07                	je     80241f <print_mem_block_lists+0x9e>
  802418:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80241b:	8b 00                	mov    (%eax),%eax
  80241d:	eb 05                	jmp    802424 <print_mem_block_lists+0xa3>
  80241f:	b8 00 00 00 00       	mov    $0x0,%eax
  802424:	a3 40 51 80 00       	mov    %eax,0x805140
  802429:	a1 40 51 80 00       	mov    0x805140,%eax
  80242e:	85 c0                	test   %eax,%eax
  802430:	75 8a                	jne    8023bc <print_mem_block_lists+0x3b>
  802432:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802436:	75 84                	jne    8023bc <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802438:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80243c:	75 10                	jne    80244e <print_mem_block_lists+0xcd>
  80243e:	83 ec 0c             	sub    $0xc,%esp
  802441:	68 10 40 80 00       	push   $0x804010
  802446:	e8 87 e5 ff ff       	call   8009d2 <cprintf>
  80244b:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80244e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802455:	83 ec 0c             	sub    $0xc,%esp
  802458:	68 34 40 80 00       	push   $0x804034
  80245d:	e8 70 e5 ff ff       	call   8009d2 <cprintf>
  802462:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802465:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802469:	a1 40 50 80 00       	mov    0x805040,%eax
  80246e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802471:	eb 56                	jmp    8024c9 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802473:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802477:	74 1c                	je     802495 <print_mem_block_lists+0x114>
  802479:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80247c:	8b 50 08             	mov    0x8(%eax),%edx
  80247f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802482:	8b 48 08             	mov    0x8(%eax),%ecx
  802485:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802488:	8b 40 0c             	mov    0xc(%eax),%eax
  80248b:	01 c8                	add    %ecx,%eax
  80248d:	39 c2                	cmp    %eax,%edx
  80248f:	73 04                	jae    802495 <print_mem_block_lists+0x114>
			sorted = 0 ;
  802491:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802495:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802498:	8b 50 08             	mov    0x8(%eax),%edx
  80249b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80249e:	8b 40 0c             	mov    0xc(%eax),%eax
  8024a1:	01 c2                	add    %eax,%edx
  8024a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024a6:	8b 40 08             	mov    0x8(%eax),%eax
  8024a9:	83 ec 04             	sub    $0x4,%esp
  8024ac:	52                   	push   %edx
  8024ad:	50                   	push   %eax
  8024ae:	68 01 40 80 00       	push   $0x804001
  8024b3:	e8 1a e5 ff ff       	call   8009d2 <cprintf>
  8024b8:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8024bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024be:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8024c1:	a1 48 50 80 00       	mov    0x805048,%eax
  8024c6:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8024c9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024cd:	74 07                	je     8024d6 <print_mem_block_lists+0x155>
  8024cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8024d2:	8b 00                	mov    (%eax),%eax
  8024d4:	eb 05                	jmp    8024db <print_mem_block_lists+0x15a>
  8024d6:	b8 00 00 00 00       	mov    $0x0,%eax
  8024db:	a3 48 50 80 00       	mov    %eax,0x805048
  8024e0:	a1 48 50 80 00       	mov    0x805048,%eax
  8024e5:	85 c0                	test   %eax,%eax
  8024e7:	75 8a                	jne    802473 <print_mem_block_lists+0xf2>
  8024e9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8024ed:	75 84                	jne    802473 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8024ef:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8024f3:	75 10                	jne    802505 <print_mem_block_lists+0x184>
  8024f5:	83 ec 0c             	sub    $0xc,%esp
  8024f8:	68 4c 40 80 00       	push   $0x80404c
  8024fd:	e8 d0 e4 ff ff       	call   8009d2 <cprintf>
  802502:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802505:	83 ec 0c             	sub    $0xc,%esp
  802508:	68 c0 3f 80 00       	push   $0x803fc0
  80250d:	e8 c0 e4 ff ff       	call   8009d2 <cprintf>
  802512:	83 c4 10             	add    $0x10,%esp

}
  802515:	90                   	nop
  802516:	c9                   	leave  
  802517:	c3                   	ret    

00802518 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802518:	55                   	push   %ebp
  802519:	89 e5                	mov    %esp,%ebp
  80251b:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80251e:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802525:	00 00 00 
  802528:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80252f:	00 00 00 
  802532:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802539:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80253c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802543:	e9 9e 00 00 00       	jmp    8025e6 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802548:	a1 50 50 80 00       	mov    0x805050,%eax
  80254d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802550:	c1 e2 04             	shl    $0x4,%edx
  802553:	01 d0                	add    %edx,%eax
  802555:	85 c0                	test   %eax,%eax
  802557:	75 14                	jne    80256d <initialize_MemBlocksList+0x55>
  802559:	83 ec 04             	sub    $0x4,%esp
  80255c:	68 74 40 80 00       	push   $0x804074
  802561:	6a 3d                	push   $0x3d
  802563:	68 97 40 80 00       	push   $0x804097
  802568:	e8 b1 e1 ff ff       	call   80071e <_panic>
  80256d:	a1 50 50 80 00       	mov    0x805050,%eax
  802572:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802575:	c1 e2 04             	shl    $0x4,%edx
  802578:	01 d0                	add    %edx,%eax
  80257a:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802580:	89 10                	mov    %edx,(%eax)
  802582:	8b 00                	mov    (%eax),%eax
  802584:	85 c0                	test   %eax,%eax
  802586:	74 18                	je     8025a0 <initialize_MemBlocksList+0x88>
  802588:	a1 48 51 80 00       	mov    0x805148,%eax
  80258d:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802593:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802596:	c1 e1 04             	shl    $0x4,%ecx
  802599:	01 ca                	add    %ecx,%edx
  80259b:	89 50 04             	mov    %edx,0x4(%eax)
  80259e:	eb 12                	jmp    8025b2 <initialize_MemBlocksList+0x9a>
  8025a0:	a1 50 50 80 00       	mov    0x805050,%eax
  8025a5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025a8:	c1 e2 04             	shl    $0x4,%edx
  8025ab:	01 d0                	add    %edx,%eax
  8025ad:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8025b2:	a1 50 50 80 00       	mov    0x805050,%eax
  8025b7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025ba:	c1 e2 04             	shl    $0x4,%edx
  8025bd:	01 d0                	add    %edx,%eax
  8025bf:	a3 48 51 80 00       	mov    %eax,0x805148
  8025c4:	a1 50 50 80 00       	mov    0x805050,%eax
  8025c9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8025cc:	c1 e2 04             	shl    $0x4,%edx
  8025cf:	01 d0                	add    %edx,%eax
  8025d1:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8025d8:	a1 54 51 80 00       	mov    0x805154,%eax
  8025dd:	40                   	inc    %eax
  8025de:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8025e3:	ff 45 f4             	incl   -0xc(%ebp)
  8025e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025e9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8025ec:	0f 82 56 ff ff ff    	jb     802548 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  8025f2:	90                   	nop
  8025f3:	c9                   	leave  
  8025f4:	c3                   	ret    

008025f5 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  8025f5:	55                   	push   %ebp
  8025f6:	89 e5                	mov    %esp,%ebp
  8025f8:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  8025fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8025fe:	8b 00                	mov    (%eax),%eax
  802600:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802603:	eb 18                	jmp    80261d <find_block+0x28>

		if(tmp->sva == va){
  802605:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802608:	8b 40 08             	mov    0x8(%eax),%eax
  80260b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80260e:	75 05                	jne    802615 <find_block+0x20>
			return tmp ;
  802610:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802613:	eb 11                	jmp    802626 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802615:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802618:	8b 00                	mov    (%eax),%eax
  80261a:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  80261d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802621:	75 e2                	jne    802605 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802623:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802626:	c9                   	leave  
  802627:	c3                   	ret    

00802628 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802628:	55                   	push   %ebp
  802629:	89 e5                	mov    %esp,%ebp
  80262b:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  80262e:	a1 40 50 80 00       	mov    0x805040,%eax
  802633:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802636:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80263b:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  80263e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802642:	75 65                	jne    8026a9 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802644:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802648:	75 14                	jne    80265e <insert_sorted_allocList+0x36>
  80264a:	83 ec 04             	sub    $0x4,%esp
  80264d:	68 74 40 80 00       	push   $0x804074
  802652:	6a 62                	push   $0x62
  802654:	68 97 40 80 00       	push   $0x804097
  802659:	e8 c0 e0 ff ff       	call   80071e <_panic>
  80265e:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802664:	8b 45 08             	mov    0x8(%ebp),%eax
  802667:	89 10                	mov    %edx,(%eax)
  802669:	8b 45 08             	mov    0x8(%ebp),%eax
  80266c:	8b 00                	mov    (%eax),%eax
  80266e:	85 c0                	test   %eax,%eax
  802670:	74 0d                	je     80267f <insert_sorted_allocList+0x57>
  802672:	a1 40 50 80 00       	mov    0x805040,%eax
  802677:	8b 55 08             	mov    0x8(%ebp),%edx
  80267a:	89 50 04             	mov    %edx,0x4(%eax)
  80267d:	eb 08                	jmp    802687 <insert_sorted_allocList+0x5f>
  80267f:	8b 45 08             	mov    0x8(%ebp),%eax
  802682:	a3 44 50 80 00       	mov    %eax,0x805044
  802687:	8b 45 08             	mov    0x8(%ebp),%eax
  80268a:	a3 40 50 80 00       	mov    %eax,0x805040
  80268f:	8b 45 08             	mov    0x8(%ebp),%eax
  802692:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802699:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80269e:	40                   	inc    %eax
  80269f:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8026a4:	e9 14 01 00 00       	jmp    8027bd <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  8026a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8026ac:	8b 50 08             	mov    0x8(%eax),%edx
  8026af:	a1 44 50 80 00       	mov    0x805044,%eax
  8026b4:	8b 40 08             	mov    0x8(%eax),%eax
  8026b7:	39 c2                	cmp    %eax,%edx
  8026b9:	76 65                	jbe    802720 <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  8026bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8026bf:	75 14                	jne    8026d5 <insert_sorted_allocList+0xad>
  8026c1:	83 ec 04             	sub    $0x4,%esp
  8026c4:	68 b0 40 80 00       	push   $0x8040b0
  8026c9:	6a 64                	push   $0x64
  8026cb:	68 97 40 80 00       	push   $0x804097
  8026d0:	e8 49 e0 ff ff       	call   80071e <_panic>
  8026d5:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8026db:	8b 45 08             	mov    0x8(%ebp),%eax
  8026de:	89 50 04             	mov    %edx,0x4(%eax)
  8026e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8026e4:	8b 40 04             	mov    0x4(%eax),%eax
  8026e7:	85 c0                	test   %eax,%eax
  8026e9:	74 0c                	je     8026f7 <insert_sorted_allocList+0xcf>
  8026eb:	a1 44 50 80 00       	mov    0x805044,%eax
  8026f0:	8b 55 08             	mov    0x8(%ebp),%edx
  8026f3:	89 10                	mov    %edx,(%eax)
  8026f5:	eb 08                	jmp    8026ff <insert_sorted_allocList+0xd7>
  8026f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8026fa:	a3 40 50 80 00       	mov    %eax,0x805040
  8026ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802702:	a3 44 50 80 00       	mov    %eax,0x805044
  802707:	8b 45 08             	mov    0x8(%ebp),%eax
  80270a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802710:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802715:	40                   	inc    %eax
  802716:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  80271b:	e9 9d 00 00 00       	jmp    8027bd <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802720:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802727:	e9 85 00 00 00       	jmp    8027b1 <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  80272c:	8b 45 08             	mov    0x8(%ebp),%eax
  80272f:	8b 50 08             	mov    0x8(%eax),%edx
  802732:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802735:	8b 40 08             	mov    0x8(%eax),%eax
  802738:	39 c2                	cmp    %eax,%edx
  80273a:	73 6a                	jae    8027a6 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  80273c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802740:	74 06                	je     802748 <insert_sorted_allocList+0x120>
  802742:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802746:	75 14                	jne    80275c <insert_sorted_allocList+0x134>
  802748:	83 ec 04             	sub    $0x4,%esp
  80274b:	68 d4 40 80 00       	push   $0x8040d4
  802750:	6a 6b                	push   $0x6b
  802752:	68 97 40 80 00       	push   $0x804097
  802757:	e8 c2 df ff ff       	call   80071e <_panic>
  80275c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80275f:	8b 50 04             	mov    0x4(%eax),%edx
  802762:	8b 45 08             	mov    0x8(%ebp),%eax
  802765:	89 50 04             	mov    %edx,0x4(%eax)
  802768:	8b 45 08             	mov    0x8(%ebp),%eax
  80276b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80276e:	89 10                	mov    %edx,(%eax)
  802770:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802773:	8b 40 04             	mov    0x4(%eax),%eax
  802776:	85 c0                	test   %eax,%eax
  802778:	74 0d                	je     802787 <insert_sorted_allocList+0x15f>
  80277a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80277d:	8b 40 04             	mov    0x4(%eax),%eax
  802780:	8b 55 08             	mov    0x8(%ebp),%edx
  802783:	89 10                	mov    %edx,(%eax)
  802785:	eb 08                	jmp    80278f <insert_sorted_allocList+0x167>
  802787:	8b 45 08             	mov    0x8(%ebp),%eax
  80278a:	a3 40 50 80 00       	mov    %eax,0x805040
  80278f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802792:	8b 55 08             	mov    0x8(%ebp),%edx
  802795:	89 50 04             	mov    %edx,0x4(%eax)
  802798:	a1 4c 50 80 00       	mov    0x80504c,%eax
  80279d:	40                   	inc    %eax
  80279e:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  8027a3:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8027a4:	eb 17                	jmp    8027bd <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  8027a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027a9:	8b 00                	mov    (%eax),%eax
  8027ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8027ae:	ff 45 f0             	incl   -0x10(%ebp)
  8027b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027b4:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8027b7:	0f 8c 6f ff ff ff    	jl     80272c <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8027bd:	90                   	nop
  8027be:	c9                   	leave  
  8027bf:	c3                   	ret    

008027c0 <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8027c0:	55                   	push   %ebp
  8027c1:	89 e5                	mov    %esp,%ebp
  8027c3:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  8027c6:	a1 38 51 80 00       	mov    0x805138,%eax
  8027cb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  8027ce:	e9 7c 01 00 00       	jmp    80294f <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  8027d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027d6:	8b 40 0c             	mov    0xc(%eax),%eax
  8027d9:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027dc:	0f 86 cf 00 00 00    	jbe    8028b1 <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8027e2:	a1 48 51 80 00       	mov    0x805148,%eax
  8027e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  8027ea:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8027ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8027f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8027f3:	8b 55 08             	mov    0x8(%ebp),%edx
  8027f6:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  8027f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027fc:	8b 50 08             	mov    0x8(%eax),%edx
  8027ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802802:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802805:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802808:	8b 40 0c             	mov    0xc(%eax),%eax
  80280b:	2b 45 08             	sub    0x8(%ebp),%eax
  80280e:	89 c2                	mov    %eax,%edx
  802810:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802813:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802816:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802819:	8b 50 08             	mov    0x8(%eax),%edx
  80281c:	8b 45 08             	mov    0x8(%ebp),%eax
  80281f:	01 c2                	add    %eax,%edx
  802821:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802824:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802827:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80282b:	75 17                	jne    802844 <alloc_block_FF+0x84>
  80282d:	83 ec 04             	sub    $0x4,%esp
  802830:	68 09 41 80 00       	push   $0x804109
  802835:	68 83 00 00 00       	push   $0x83
  80283a:	68 97 40 80 00       	push   $0x804097
  80283f:	e8 da de ff ff       	call   80071e <_panic>
  802844:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802847:	8b 00                	mov    (%eax),%eax
  802849:	85 c0                	test   %eax,%eax
  80284b:	74 10                	je     80285d <alloc_block_FF+0x9d>
  80284d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802850:	8b 00                	mov    (%eax),%eax
  802852:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802855:	8b 52 04             	mov    0x4(%edx),%edx
  802858:	89 50 04             	mov    %edx,0x4(%eax)
  80285b:	eb 0b                	jmp    802868 <alloc_block_FF+0xa8>
  80285d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802860:	8b 40 04             	mov    0x4(%eax),%eax
  802863:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802868:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80286b:	8b 40 04             	mov    0x4(%eax),%eax
  80286e:	85 c0                	test   %eax,%eax
  802870:	74 0f                	je     802881 <alloc_block_FF+0xc1>
  802872:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802875:	8b 40 04             	mov    0x4(%eax),%eax
  802878:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80287b:	8b 12                	mov    (%edx),%edx
  80287d:	89 10                	mov    %edx,(%eax)
  80287f:	eb 0a                	jmp    80288b <alloc_block_FF+0xcb>
  802881:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802884:	8b 00                	mov    (%eax),%eax
  802886:	a3 48 51 80 00       	mov    %eax,0x805148
  80288b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80288e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802894:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802897:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80289e:	a1 54 51 80 00       	mov    0x805154,%eax
  8028a3:	48                   	dec    %eax
  8028a4:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  8028a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8028ac:	e9 ad 00 00 00       	jmp    80295e <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  8028b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028b4:	8b 40 0c             	mov    0xc(%eax),%eax
  8028b7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8028ba:	0f 85 87 00 00 00    	jne    802947 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  8028c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c4:	75 17                	jne    8028dd <alloc_block_FF+0x11d>
  8028c6:	83 ec 04             	sub    $0x4,%esp
  8028c9:	68 09 41 80 00       	push   $0x804109
  8028ce:	68 87 00 00 00       	push   $0x87
  8028d3:	68 97 40 80 00       	push   $0x804097
  8028d8:	e8 41 de ff ff       	call   80071e <_panic>
  8028dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e0:	8b 00                	mov    (%eax),%eax
  8028e2:	85 c0                	test   %eax,%eax
  8028e4:	74 10                	je     8028f6 <alloc_block_FF+0x136>
  8028e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028e9:	8b 00                	mov    (%eax),%eax
  8028eb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8028ee:	8b 52 04             	mov    0x4(%edx),%edx
  8028f1:	89 50 04             	mov    %edx,0x4(%eax)
  8028f4:	eb 0b                	jmp    802901 <alloc_block_FF+0x141>
  8028f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028f9:	8b 40 04             	mov    0x4(%eax),%eax
  8028fc:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802901:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802904:	8b 40 04             	mov    0x4(%eax),%eax
  802907:	85 c0                	test   %eax,%eax
  802909:	74 0f                	je     80291a <alloc_block_FF+0x15a>
  80290b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80290e:	8b 40 04             	mov    0x4(%eax),%eax
  802911:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802914:	8b 12                	mov    (%edx),%edx
  802916:	89 10                	mov    %edx,(%eax)
  802918:	eb 0a                	jmp    802924 <alloc_block_FF+0x164>
  80291a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80291d:	8b 00                	mov    (%eax),%eax
  80291f:	a3 38 51 80 00       	mov    %eax,0x805138
  802924:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802927:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802937:	a1 44 51 80 00       	mov    0x805144,%eax
  80293c:	48                   	dec    %eax
  80293d:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802945:	eb 17                	jmp    80295e <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802947:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80294a:	8b 00                	mov    (%eax),%eax
  80294c:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  80294f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802953:	0f 85 7a fe ff ff    	jne    8027d3 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802959:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80295e:	c9                   	leave  
  80295f:	c3                   	ret    

00802960 <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802960:	55                   	push   %ebp
  802961:	89 e5                	mov    %esp,%ebp
  802963:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802966:	a1 38 51 80 00       	mov    0x805138,%eax
  80296b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  80296e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802975:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  80297c:	a1 38 51 80 00       	mov    0x805138,%eax
  802981:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802984:	e9 d0 00 00 00       	jmp    802a59 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802989:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298c:	8b 40 0c             	mov    0xc(%eax),%eax
  80298f:	3b 45 08             	cmp    0x8(%ebp),%eax
  802992:	0f 82 b8 00 00 00    	jb     802a50 <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802998:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80299b:	8b 40 0c             	mov    0xc(%eax),%eax
  80299e:	2b 45 08             	sub    0x8(%ebp),%eax
  8029a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  8029a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029a7:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029aa:	0f 83 a1 00 00 00    	jae    802a51 <alloc_block_BF+0xf1>
				differsize = differance ;
  8029b0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8029b3:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  8029b6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  8029bc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8029c0:	0f 85 8b 00 00 00    	jne    802a51 <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  8029c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8029ca:	75 17                	jne    8029e3 <alloc_block_BF+0x83>
  8029cc:	83 ec 04             	sub    $0x4,%esp
  8029cf:	68 09 41 80 00       	push   $0x804109
  8029d4:	68 a0 00 00 00       	push   $0xa0
  8029d9:	68 97 40 80 00       	push   $0x804097
  8029de:	e8 3b dd ff ff       	call   80071e <_panic>
  8029e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e6:	8b 00                	mov    (%eax),%eax
  8029e8:	85 c0                	test   %eax,%eax
  8029ea:	74 10                	je     8029fc <alloc_block_BF+0x9c>
  8029ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ef:	8b 00                	mov    (%eax),%eax
  8029f1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029f4:	8b 52 04             	mov    0x4(%edx),%edx
  8029f7:	89 50 04             	mov    %edx,0x4(%eax)
  8029fa:	eb 0b                	jmp    802a07 <alloc_block_BF+0xa7>
  8029fc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029ff:	8b 40 04             	mov    0x4(%eax),%eax
  802a02:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 40 04             	mov    0x4(%eax),%eax
  802a0d:	85 c0                	test   %eax,%eax
  802a0f:	74 0f                	je     802a20 <alloc_block_BF+0xc0>
  802a11:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a14:	8b 40 04             	mov    0x4(%eax),%eax
  802a17:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a1a:	8b 12                	mov    (%edx),%edx
  802a1c:	89 10                	mov    %edx,(%eax)
  802a1e:	eb 0a                	jmp    802a2a <alloc_block_BF+0xca>
  802a20:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a23:	8b 00                	mov    (%eax),%eax
  802a25:	a3 38 51 80 00       	mov    %eax,0x805138
  802a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a2d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802a33:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a36:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a3d:	a1 44 51 80 00       	mov    0x805144,%eax
  802a42:	48                   	dec    %eax
  802a43:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802a48:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a4b:	e9 0c 01 00 00       	jmp    802b5c <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802a50:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802a51:	a1 40 51 80 00       	mov    0x805140,%eax
  802a56:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802a59:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a5d:	74 07                	je     802a66 <alloc_block_BF+0x106>
  802a5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a62:	8b 00                	mov    (%eax),%eax
  802a64:	eb 05                	jmp    802a6b <alloc_block_BF+0x10b>
  802a66:	b8 00 00 00 00       	mov    $0x0,%eax
  802a6b:	a3 40 51 80 00       	mov    %eax,0x805140
  802a70:	a1 40 51 80 00       	mov    0x805140,%eax
  802a75:	85 c0                	test   %eax,%eax
  802a77:	0f 85 0c ff ff ff    	jne    802989 <alloc_block_BF+0x29>
  802a7d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802a81:	0f 85 02 ff ff ff    	jne    802989 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802a87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802a8b:	0f 84 c6 00 00 00    	je     802b57 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802a91:	a1 48 51 80 00       	mov    0x805148,%eax
  802a96:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802a99:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802a9c:	8b 55 08             	mov    0x8(%ebp),%edx
  802a9f:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802aa2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802aa5:	8b 50 08             	mov    0x8(%eax),%edx
  802aa8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802aab:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802aae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ab1:	8b 40 0c             	mov    0xc(%eax),%eax
  802ab4:	2b 45 08             	sub    0x8(%ebp),%eax
  802ab7:	89 c2                	mov    %eax,%edx
  802ab9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802abc:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802ac2:	8b 50 08             	mov    0x8(%eax),%edx
  802ac5:	8b 45 08             	mov    0x8(%ebp),%eax
  802ac8:	01 c2                	add    %eax,%edx
  802aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802acd:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802ad0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ad4:	75 17                	jne    802aed <alloc_block_BF+0x18d>
  802ad6:	83 ec 04             	sub    $0x4,%esp
  802ad9:	68 09 41 80 00       	push   $0x804109
  802ade:	68 af 00 00 00       	push   $0xaf
  802ae3:	68 97 40 80 00       	push   $0x804097
  802ae8:	e8 31 dc ff ff       	call   80071e <_panic>
  802aed:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af0:	8b 00                	mov    (%eax),%eax
  802af2:	85 c0                	test   %eax,%eax
  802af4:	74 10                	je     802b06 <alloc_block_BF+0x1a6>
  802af6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802af9:	8b 00                	mov    (%eax),%eax
  802afb:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802afe:	8b 52 04             	mov    0x4(%edx),%edx
  802b01:	89 50 04             	mov    %edx,0x4(%eax)
  802b04:	eb 0b                	jmp    802b11 <alloc_block_BF+0x1b1>
  802b06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b09:	8b 40 04             	mov    0x4(%eax),%eax
  802b0c:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802b11:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b14:	8b 40 04             	mov    0x4(%eax),%eax
  802b17:	85 c0                	test   %eax,%eax
  802b19:	74 0f                	je     802b2a <alloc_block_BF+0x1ca>
  802b1b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b1e:	8b 40 04             	mov    0x4(%eax),%eax
  802b21:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802b24:	8b 12                	mov    (%edx),%edx
  802b26:	89 10                	mov    %edx,(%eax)
  802b28:	eb 0a                	jmp    802b34 <alloc_block_BF+0x1d4>
  802b2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b2d:	8b 00                	mov    (%eax),%eax
  802b2f:	a3 48 51 80 00       	mov    %eax,0x805148
  802b34:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b37:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3d:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b40:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b47:	a1 54 51 80 00       	mov    0x805154,%eax
  802b4c:	48                   	dec    %eax
  802b4d:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802b52:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802b55:	eb 05                	jmp    802b5c <alloc_block_BF+0x1fc>
	}

	return NULL;
  802b57:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b5c:	c9                   	leave  
  802b5d:	c3                   	ret    

00802b5e <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802b5e:	55                   	push   %ebp
  802b5f:	89 e5                	mov    %esp,%ebp
  802b61:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802b64:	a1 38 51 80 00       	mov    0x805138,%eax
  802b69:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802b6c:	e9 7c 01 00 00       	jmp    802ced <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b74:	8b 40 0c             	mov    0xc(%eax),%eax
  802b77:	3b 45 08             	cmp    0x8(%ebp),%eax
  802b7a:	0f 86 cf 00 00 00    	jbe    802c4f <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802b80:	a1 48 51 80 00       	mov    0x805148,%eax
  802b85:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802b88:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802b8b:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802b8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802b91:	8b 55 08             	mov    0x8(%ebp),%edx
  802b94:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 50 08             	mov    0x8(%eax),%edx
  802b9d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802ba0:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba6:	8b 40 0c             	mov    0xc(%eax),%eax
  802ba9:	2b 45 08             	sub    0x8(%ebp),%eax
  802bac:	89 c2                	mov    %eax,%edx
  802bae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb1:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802bb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bb7:	8b 50 08             	mov    0x8(%eax),%edx
  802bba:	8b 45 08             	mov    0x8(%ebp),%eax
  802bbd:	01 c2                	add    %eax,%edx
  802bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc2:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802bc5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bc9:	75 17                	jne    802be2 <alloc_block_NF+0x84>
  802bcb:	83 ec 04             	sub    $0x4,%esp
  802bce:	68 09 41 80 00       	push   $0x804109
  802bd3:	68 c4 00 00 00       	push   $0xc4
  802bd8:	68 97 40 80 00       	push   $0x804097
  802bdd:	e8 3c db ff ff       	call   80071e <_panic>
  802be2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802be5:	8b 00                	mov    (%eax),%eax
  802be7:	85 c0                	test   %eax,%eax
  802be9:	74 10                	je     802bfb <alloc_block_NF+0x9d>
  802beb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bee:	8b 00                	mov    (%eax),%eax
  802bf0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802bf3:	8b 52 04             	mov    0x4(%edx),%edx
  802bf6:	89 50 04             	mov    %edx,0x4(%eax)
  802bf9:	eb 0b                	jmp    802c06 <alloc_block_NF+0xa8>
  802bfb:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802bfe:	8b 40 04             	mov    0x4(%eax),%eax
  802c01:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802c06:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c09:	8b 40 04             	mov    0x4(%eax),%eax
  802c0c:	85 c0                	test   %eax,%eax
  802c0e:	74 0f                	je     802c1f <alloc_block_NF+0xc1>
  802c10:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c13:	8b 40 04             	mov    0x4(%eax),%eax
  802c16:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802c19:	8b 12                	mov    (%edx),%edx
  802c1b:	89 10                	mov    %edx,(%eax)
  802c1d:	eb 0a                	jmp    802c29 <alloc_block_NF+0xcb>
  802c1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c22:	8b 00                	mov    (%eax),%eax
  802c24:	a3 48 51 80 00       	mov    %eax,0x805148
  802c29:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c2c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c32:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c35:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c3c:	a1 54 51 80 00       	mov    0x805154,%eax
  802c41:	48                   	dec    %eax
  802c42:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802c47:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c4a:	e9 ad 00 00 00       	jmp    802cfc <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802c4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c52:	8b 40 0c             	mov    0xc(%eax),%eax
  802c55:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c58:	0f 85 87 00 00 00    	jne    802ce5 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802c5e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c62:	75 17                	jne    802c7b <alloc_block_NF+0x11d>
  802c64:	83 ec 04             	sub    $0x4,%esp
  802c67:	68 09 41 80 00       	push   $0x804109
  802c6c:	68 c8 00 00 00       	push   $0xc8
  802c71:	68 97 40 80 00       	push   $0x804097
  802c76:	e8 a3 da ff ff       	call   80071e <_panic>
  802c7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c7e:	8b 00                	mov    (%eax),%eax
  802c80:	85 c0                	test   %eax,%eax
  802c82:	74 10                	je     802c94 <alloc_block_NF+0x136>
  802c84:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c87:	8b 00                	mov    (%eax),%eax
  802c89:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c8c:	8b 52 04             	mov    0x4(%edx),%edx
  802c8f:	89 50 04             	mov    %edx,0x4(%eax)
  802c92:	eb 0b                	jmp    802c9f <alloc_block_NF+0x141>
  802c94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c97:	8b 40 04             	mov    0x4(%eax),%eax
  802c9a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c9f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca2:	8b 40 04             	mov    0x4(%eax),%eax
  802ca5:	85 c0                	test   %eax,%eax
  802ca7:	74 0f                	je     802cb8 <alloc_block_NF+0x15a>
  802ca9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cac:	8b 40 04             	mov    0x4(%eax),%eax
  802caf:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802cb2:	8b 12                	mov    (%edx),%edx
  802cb4:	89 10                	mov    %edx,(%eax)
  802cb6:	eb 0a                	jmp    802cc2 <alloc_block_NF+0x164>
  802cb8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cbb:	8b 00                	mov    (%eax),%eax
  802cbd:	a3 38 51 80 00       	mov    %eax,0x805138
  802cc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cc5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ccb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cce:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802cd5:	a1 44 51 80 00       	mov    0x805144,%eax
  802cda:	48                   	dec    %eax
  802cdb:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce3:	eb 17                	jmp    802cfc <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802ce5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ce8:	8b 00                	mov    (%eax),%eax
  802cea:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802ced:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802cf1:	0f 85 7a fe ff ff    	jne    802b71 <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802cf7:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802cfc:	c9                   	leave  
  802cfd:	c3                   	ret    

00802cfe <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802cfe:	55                   	push   %ebp
  802cff:	89 e5                	mov    %esp,%ebp
  802d01:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802d04:	a1 38 51 80 00       	mov    0x805138,%eax
  802d09:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802d0c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802d11:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802d14:	a1 44 51 80 00       	mov    0x805144,%eax
  802d19:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802d1c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802d20:	75 68                	jne    802d8a <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802d22:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802d26:	75 17                	jne    802d3f <insert_sorted_with_merge_freeList+0x41>
  802d28:	83 ec 04             	sub    $0x4,%esp
  802d2b:	68 74 40 80 00       	push   $0x804074
  802d30:	68 da 00 00 00       	push   $0xda
  802d35:	68 97 40 80 00       	push   $0x804097
  802d3a:	e8 df d9 ff ff       	call   80071e <_panic>
  802d3f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802d45:	8b 45 08             	mov    0x8(%ebp),%eax
  802d48:	89 10                	mov    %edx,(%eax)
  802d4a:	8b 45 08             	mov    0x8(%ebp),%eax
  802d4d:	8b 00                	mov    (%eax),%eax
  802d4f:	85 c0                	test   %eax,%eax
  802d51:	74 0d                	je     802d60 <insert_sorted_with_merge_freeList+0x62>
  802d53:	a1 38 51 80 00       	mov    0x805138,%eax
  802d58:	8b 55 08             	mov    0x8(%ebp),%edx
  802d5b:	89 50 04             	mov    %edx,0x4(%eax)
  802d5e:	eb 08                	jmp    802d68 <insert_sorted_with_merge_freeList+0x6a>
  802d60:	8b 45 08             	mov    0x8(%ebp),%eax
  802d63:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d68:	8b 45 08             	mov    0x8(%ebp),%eax
  802d6b:	a3 38 51 80 00       	mov    %eax,0x805138
  802d70:	8b 45 08             	mov    0x8(%ebp),%eax
  802d73:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d7a:	a1 44 51 80 00       	mov    0x805144,%eax
  802d7f:	40                   	inc    %eax
  802d80:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802d85:	e9 49 07 00 00       	jmp    8034d3 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802d8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d8d:	8b 50 08             	mov    0x8(%eax),%edx
  802d90:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d93:	8b 40 0c             	mov    0xc(%eax),%eax
  802d96:	01 c2                	add    %eax,%edx
  802d98:	8b 45 08             	mov    0x8(%ebp),%eax
  802d9b:	8b 40 08             	mov    0x8(%eax),%eax
  802d9e:	39 c2                	cmp    %eax,%edx
  802da0:	73 77                	jae    802e19 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802da2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802da5:	8b 00                	mov    (%eax),%eax
  802da7:	85 c0                	test   %eax,%eax
  802da9:	75 6e                	jne    802e19 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802dab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802daf:	74 68                	je     802e19 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802db1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802db5:	75 17                	jne    802dce <insert_sorted_with_merge_freeList+0xd0>
  802db7:	83 ec 04             	sub    $0x4,%esp
  802dba:	68 b0 40 80 00       	push   $0x8040b0
  802dbf:	68 e0 00 00 00       	push   $0xe0
  802dc4:	68 97 40 80 00       	push   $0x804097
  802dc9:	e8 50 d9 ff ff       	call   80071e <_panic>
  802dce:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802dd4:	8b 45 08             	mov    0x8(%ebp),%eax
  802dd7:	89 50 04             	mov    %edx,0x4(%eax)
  802dda:	8b 45 08             	mov    0x8(%ebp),%eax
  802ddd:	8b 40 04             	mov    0x4(%eax),%eax
  802de0:	85 c0                	test   %eax,%eax
  802de2:	74 0c                	je     802df0 <insert_sorted_with_merge_freeList+0xf2>
  802de4:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802de9:	8b 55 08             	mov    0x8(%ebp),%edx
  802dec:	89 10                	mov    %edx,(%eax)
  802dee:	eb 08                	jmp    802df8 <insert_sorted_with_merge_freeList+0xfa>
  802df0:	8b 45 08             	mov    0x8(%ebp),%eax
  802df3:	a3 38 51 80 00       	mov    %eax,0x805138
  802df8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dfb:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e00:	8b 45 08             	mov    0x8(%ebp),%eax
  802e03:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e09:	a1 44 51 80 00       	mov    0x805144,%eax
  802e0e:	40                   	inc    %eax
  802e0f:	a3 44 51 80 00       	mov    %eax,0x805144
  802e14:	e9 ba 06 00 00       	jmp    8034d3 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  802e19:	8b 45 08             	mov    0x8(%ebp),%eax
  802e1c:	8b 50 0c             	mov    0xc(%eax),%edx
  802e1f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e22:	8b 40 08             	mov    0x8(%eax),%eax
  802e25:	01 c2                	add    %eax,%edx
  802e27:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e2a:	8b 40 08             	mov    0x8(%eax),%eax
  802e2d:	39 c2                	cmp    %eax,%edx
  802e2f:	73 78                	jae    802ea9 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  802e31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e34:	8b 40 04             	mov    0x4(%eax),%eax
  802e37:	85 c0                	test   %eax,%eax
  802e39:	75 6e                	jne    802ea9 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  802e3b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e3f:	74 68                	je     802ea9 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802e41:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802e45:	75 17                	jne    802e5e <insert_sorted_with_merge_freeList+0x160>
  802e47:	83 ec 04             	sub    $0x4,%esp
  802e4a:	68 74 40 80 00       	push   $0x804074
  802e4f:	68 e6 00 00 00       	push   $0xe6
  802e54:	68 97 40 80 00       	push   $0x804097
  802e59:	e8 c0 d8 ff ff       	call   80071e <_panic>
  802e5e:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802e64:	8b 45 08             	mov    0x8(%ebp),%eax
  802e67:	89 10                	mov    %edx,(%eax)
  802e69:	8b 45 08             	mov    0x8(%ebp),%eax
  802e6c:	8b 00                	mov    (%eax),%eax
  802e6e:	85 c0                	test   %eax,%eax
  802e70:	74 0d                	je     802e7f <insert_sorted_with_merge_freeList+0x181>
  802e72:	a1 38 51 80 00       	mov    0x805138,%eax
  802e77:	8b 55 08             	mov    0x8(%ebp),%edx
  802e7a:	89 50 04             	mov    %edx,0x4(%eax)
  802e7d:	eb 08                	jmp    802e87 <insert_sorted_with_merge_freeList+0x189>
  802e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e82:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e87:	8b 45 08             	mov    0x8(%ebp),%eax
  802e8a:	a3 38 51 80 00       	mov    %eax,0x805138
  802e8f:	8b 45 08             	mov    0x8(%ebp),%eax
  802e92:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e99:	a1 44 51 80 00       	mov    0x805144,%eax
  802e9e:	40                   	inc    %eax
  802e9f:	a3 44 51 80 00       	mov    %eax,0x805144
  802ea4:	e9 2a 06 00 00       	jmp    8034d3 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  802ea9:	a1 38 51 80 00       	mov    0x805138,%eax
  802eae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802eb1:	e9 ed 05 00 00       	jmp    8034a3 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  802eb6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb9:	8b 00                	mov    (%eax),%eax
  802ebb:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  802ebe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ec2:	0f 84 a7 00 00 00    	je     802f6f <insert_sorted_with_merge_freeList+0x271>
  802ec8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ecb:	8b 50 0c             	mov    0xc(%eax),%edx
  802ece:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed1:	8b 40 08             	mov    0x8(%eax),%eax
  802ed4:	01 c2                	add    %eax,%edx
  802ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ed9:	8b 40 08             	mov    0x8(%eax),%eax
  802edc:	39 c2                	cmp    %eax,%edx
  802ede:	0f 83 8b 00 00 00    	jae    802f6f <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  802ee4:	8b 45 08             	mov    0x8(%ebp),%eax
  802ee7:	8b 50 0c             	mov    0xc(%eax),%edx
  802eea:	8b 45 08             	mov    0x8(%ebp),%eax
  802eed:	8b 40 08             	mov    0x8(%eax),%eax
  802ef0:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  802ef2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802ef5:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  802ef8:	39 c2                	cmp    %eax,%edx
  802efa:	73 73                	jae    802f6f <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  802efc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f00:	74 06                	je     802f08 <insert_sorted_with_merge_freeList+0x20a>
  802f02:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f06:	75 17                	jne    802f1f <insert_sorted_with_merge_freeList+0x221>
  802f08:	83 ec 04             	sub    $0x4,%esp
  802f0b:	68 28 41 80 00       	push   $0x804128
  802f10:	68 f0 00 00 00       	push   $0xf0
  802f15:	68 97 40 80 00       	push   $0x804097
  802f1a:	e8 ff d7 ff ff       	call   80071e <_panic>
  802f1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f22:	8b 10                	mov    (%eax),%edx
  802f24:	8b 45 08             	mov    0x8(%ebp),%eax
  802f27:	89 10                	mov    %edx,(%eax)
  802f29:	8b 45 08             	mov    0x8(%ebp),%eax
  802f2c:	8b 00                	mov    (%eax),%eax
  802f2e:	85 c0                	test   %eax,%eax
  802f30:	74 0b                	je     802f3d <insert_sorted_with_merge_freeList+0x23f>
  802f32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f35:	8b 00                	mov    (%eax),%eax
  802f37:	8b 55 08             	mov    0x8(%ebp),%edx
  802f3a:	89 50 04             	mov    %edx,0x4(%eax)
  802f3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802f40:	8b 55 08             	mov    0x8(%ebp),%edx
  802f43:	89 10                	mov    %edx,(%eax)
  802f45:	8b 45 08             	mov    0x8(%ebp),%eax
  802f48:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802f4b:	89 50 04             	mov    %edx,0x4(%eax)
  802f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f51:	8b 00                	mov    (%eax),%eax
  802f53:	85 c0                	test   %eax,%eax
  802f55:	75 08                	jne    802f5f <insert_sorted_with_merge_freeList+0x261>
  802f57:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f5f:	a1 44 51 80 00       	mov    0x805144,%eax
  802f64:	40                   	inc    %eax
  802f65:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  802f6a:	e9 64 05 00 00       	jmp    8034d3 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  802f6f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f74:	8b 50 0c             	mov    0xc(%eax),%edx
  802f77:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f7c:	8b 40 08             	mov    0x8(%eax),%eax
  802f7f:	01 c2                	add    %eax,%edx
  802f81:	8b 45 08             	mov    0x8(%ebp),%eax
  802f84:	8b 40 08             	mov    0x8(%eax),%eax
  802f87:	39 c2                	cmp    %eax,%edx
  802f89:	0f 85 b1 00 00 00    	jne    803040 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  802f8f:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f94:	85 c0                	test   %eax,%eax
  802f96:	0f 84 a4 00 00 00    	je     803040 <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  802f9c:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fa1:	8b 00                	mov    (%eax),%eax
  802fa3:	85 c0                	test   %eax,%eax
  802fa5:	0f 85 95 00 00 00    	jne    803040 <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  802fab:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802fb0:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fb6:	8b 4a 0c             	mov    0xc(%edx),%ecx
  802fb9:	8b 55 08             	mov    0x8(%ebp),%edx
  802fbc:	8b 52 0c             	mov    0xc(%edx),%edx
  802fbf:	01 ca                	add    %ecx,%edx
  802fc1:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  802fc4:	8b 45 08             	mov    0x8(%ebp),%eax
  802fc7:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  802fce:	8b 45 08             	mov    0x8(%ebp),%eax
  802fd1:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  802fd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fdc:	75 17                	jne    802ff5 <insert_sorted_with_merge_freeList+0x2f7>
  802fde:	83 ec 04             	sub    $0x4,%esp
  802fe1:	68 74 40 80 00       	push   $0x804074
  802fe6:	68 ff 00 00 00       	push   $0xff
  802feb:	68 97 40 80 00       	push   $0x804097
  802ff0:	e8 29 d7 ff ff       	call   80071e <_panic>
  802ff5:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  802ffe:	89 10                	mov    %edx,(%eax)
  803000:	8b 45 08             	mov    0x8(%ebp),%eax
  803003:	8b 00                	mov    (%eax),%eax
  803005:	85 c0                	test   %eax,%eax
  803007:	74 0d                	je     803016 <insert_sorted_with_merge_freeList+0x318>
  803009:	a1 48 51 80 00       	mov    0x805148,%eax
  80300e:	8b 55 08             	mov    0x8(%ebp),%edx
  803011:	89 50 04             	mov    %edx,0x4(%eax)
  803014:	eb 08                	jmp    80301e <insert_sorted_with_merge_freeList+0x320>
  803016:	8b 45 08             	mov    0x8(%ebp),%eax
  803019:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80301e:	8b 45 08             	mov    0x8(%ebp),%eax
  803021:	a3 48 51 80 00       	mov    %eax,0x805148
  803026:	8b 45 08             	mov    0x8(%ebp),%eax
  803029:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803030:	a1 54 51 80 00       	mov    0x805154,%eax
  803035:	40                   	inc    %eax
  803036:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  80303b:	e9 93 04 00 00       	jmp    8034d3 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  803040:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803043:	8b 50 08             	mov    0x8(%eax),%edx
  803046:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803049:	8b 40 0c             	mov    0xc(%eax),%eax
  80304c:	01 c2                	add    %eax,%edx
  80304e:	8b 45 08             	mov    0x8(%ebp),%eax
  803051:	8b 40 08             	mov    0x8(%eax),%eax
  803054:	39 c2                	cmp    %eax,%edx
  803056:	0f 85 ae 00 00 00    	jne    80310a <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  80305c:	8b 45 08             	mov    0x8(%ebp),%eax
  80305f:	8b 50 0c             	mov    0xc(%eax),%edx
  803062:	8b 45 08             	mov    0x8(%ebp),%eax
  803065:	8b 40 08             	mov    0x8(%eax),%eax
  803068:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  80306a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80306d:	8b 00                	mov    (%eax),%eax
  80306f:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803072:	39 c2                	cmp    %eax,%edx
  803074:	0f 84 90 00 00 00    	je     80310a <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  80307a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80307d:	8b 50 0c             	mov    0xc(%eax),%edx
  803080:	8b 45 08             	mov    0x8(%ebp),%eax
  803083:	8b 40 0c             	mov    0xc(%eax),%eax
  803086:	01 c2                	add    %eax,%edx
  803088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80308b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80308e:	8b 45 08             	mov    0x8(%ebp),%eax
  803091:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803098:	8b 45 08             	mov    0x8(%ebp),%eax
  80309b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8030a2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8030a6:	75 17                	jne    8030bf <insert_sorted_with_merge_freeList+0x3c1>
  8030a8:	83 ec 04             	sub    $0x4,%esp
  8030ab:	68 74 40 80 00       	push   $0x804074
  8030b0:	68 0b 01 00 00       	push   $0x10b
  8030b5:	68 97 40 80 00       	push   $0x804097
  8030ba:	e8 5f d6 ff ff       	call   80071e <_panic>
  8030bf:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8030c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8030c8:	89 10                	mov    %edx,(%eax)
  8030ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8030cd:	8b 00                	mov    (%eax),%eax
  8030cf:	85 c0                	test   %eax,%eax
  8030d1:	74 0d                	je     8030e0 <insert_sorted_with_merge_freeList+0x3e2>
  8030d3:	a1 48 51 80 00       	mov    0x805148,%eax
  8030d8:	8b 55 08             	mov    0x8(%ebp),%edx
  8030db:	89 50 04             	mov    %edx,0x4(%eax)
  8030de:	eb 08                	jmp    8030e8 <insert_sorted_with_merge_freeList+0x3ea>
  8030e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8030e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030eb:	a3 48 51 80 00       	mov    %eax,0x805148
  8030f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030fa:	a1 54 51 80 00       	mov    0x805154,%eax
  8030ff:	40                   	inc    %eax
  803100:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803105:	e9 c9 03 00 00       	jmp    8034d3 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  80310a:	8b 45 08             	mov    0x8(%ebp),%eax
  80310d:	8b 50 0c             	mov    0xc(%eax),%edx
  803110:	8b 45 08             	mov    0x8(%ebp),%eax
  803113:	8b 40 08             	mov    0x8(%eax),%eax
  803116:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  803118:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80311b:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  80311e:	39 c2                	cmp    %eax,%edx
  803120:	0f 85 bb 00 00 00    	jne    8031e1 <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  803126:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80312a:	0f 84 b1 00 00 00    	je     8031e1 <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  803130:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803133:	8b 40 04             	mov    0x4(%eax),%eax
  803136:	85 c0                	test   %eax,%eax
  803138:	0f 85 a3 00 00 00    	jne    8031e1 <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  80313e:	a1 38 51 80 00       	mov    0x805138,%eax
  803143:	8b 55 08             	mov    0x8(%ebp),%edx
  803146:	8b 52 08             	mov    0x8(%edx),%edx
  803149:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  80314c:	a1 38 51 80 00       	mov    0x805138,%eax
  803151:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803157:	8b 4a 0c             	mov    0xc(%edx),%ecx
  80315a:	8b 55 08             	mov    0x8(%ebp),%edx
  80315d:	8b 52 0c             	mov    0xc(%edx),%edx
  803160:	01 ca                	add    %ecx,%edx
  803162:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80316f:	8b 45 08             	mov    0x8(%ebp),%eax
  803172:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803179:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80317d:	75 17                	jne    803196 <insert_sorted_with_merge_freeList+0x498>
  80317f:	83 ec 04             	sub    $0x4,%esp
  803182:	68 74 40 80 00       	push   $0x804074
  803187:	68 17 01 00 00       	push   $0x117
  80318c:	68 97 40 80 00       	push   $0x804097
  803191:	e8 88 d5 ff ff       	call   80071e <_panic>
  803196:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80319c:	8b 45 08             	mov    0x8(%ebp),%eax
  80319f:	89 10                	mov    %edx,(%eax)
  8031a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031a4:	8b 00                	mov    (%eax),%eax
  8031a6:	85 c0                	test   %eax,%eax
  8031a8:	74 0d                	je     8031b7 <insert_sorted_with_merge_freeList+0x4b9>
  8031aa:	a1 48 51 80 00       	mov    0x805148,%eax
  8031af:	8b 55 08             	mov    0x8(%ebp),%edx
  8031b2:	89 50 04             	mov    %edx,0x4(%eax)
  8031b5:	eb 08                	jmp    8031bf <insert_sorted_with_merge_freeList+0x4c1>
  8031b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ba:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8031bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031c2:	a3 48 51 80 00       	mov    %eax,0x805148
  8031c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8031d1:	a1 54 51 80 00       	mov    0x805154,%eax
  8031d6:	40                   	inc    %eax
  8031d7:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8031dc:	e9 f2 02 00 00       	jmp    8034d3 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  8031e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8031e4:	8b 50 08             	mov    0x8(%eax),%edx
  8031e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ea:	8b 40 0c             	mov    0xc(%eax),%eax
  8031ed:	01 c2                	add    %eax,%edx
  8031ef:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8031f2:	8b 40 08             	mov    0x8(%eax),%eax
  8031f5:	39 c2                	cmp    %eax,%edx
  8031f7:	0f 85 be 00 00 00    	jne    8032bb <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  8031fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803200:	8b 40 04             	mov    0x4(%eax),%eax
  803203:	8b 50 08             	mov    0x8(%eax),%edx
  803206:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803209:	8b 40 04             	mov    0x4(%eax),%eax
  80320c:	8b 40 0c             	mov    0xc(%eax),%eax
  80320f:	01 c2                	add    %eax,%edx
  803211:	8b 45 08             	mov    0x8(%ebp),%eax
  803214:	8b 40 08             	mov    0x8(%eax),%eax
  803217:	39 c2                	cmp    %eax,%edx
  803219:	0f 84 9c 00 00 00    	je     8032bb <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  80321f:	8b 45 08             	mov    0x8(%ebp),%eax
  803222:	8b 50 08             	mov    0x8(%eax),%edx
  803225:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803228:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  80322b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80322e:	8b 50 0c             	mov    0xc(%eax),%edx
  803231:	8b 45 08             	mov    0x8(%ebp),%eax
  803234:	8b 40 0c             	mov    0xc(%eax),%eax
  803237:	01 c2                	add    %eax,%edx
  803239:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80323c:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80323f:	8b 45 08             	mov    0x8(%ebp),%eax
  803242:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803249:	8b 45 08             	mov    0x8(%ebp),%eax
  80324c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803253:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803257:	75 17                	jne    803270 <insert_sorted_with_merge_freeList+0x572>
  803259:	83 ec 04             	sub    $0x4,%esp
  80325c:	68 74 40 80 00       	push   $0x804074
  803261:	68 26 01 00 00       	push   $0x126
  803266:	68 97 40 80 00       	push   $0x804097
  80326b:	e8 ae d4 ff ff       	call   80071e <_panic>
  803270:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803276:	8b 45 08             	mov    0x8(%ebp),%eax
  803279:	89 10                	mov    %edx,(%eax)
  80327b:	8b 45 08             	mov    0x8(%ebp),%eax
  80327e:	8b 00                	mov    (%eax),%eax
  803280:	85 c0                	test   %eax,%eax
  803282:	74 0d                	je     803291 <insert_sorted_with_merge_freeList+0x593>
  803284:	a1 48 51 80 00       	mov    0x805148,%eax
  803289:	8b 55 08             	mov    0x8(%ebp),%edx
  80328c:	89 50 04             	mov    %edx,0x4(%eax)
  80328f:	eb 08                	jmp    803299 <insert_sorted_with_merge_freeList+0x59b>
  803291:	8b 45 08             	mov    0x8(%ebp),%eax
  803294:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803299:	8b 45 08             	mov    0x8(%ebp),%eax
  80329c:	a3 48 51 80 00       	mov    %eax,0x805148
  8032a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8032ab:	a1 54 51 80 00       	mov    0x805154,%eax
  8032b0:	40                   	inc    %eax
  8032b1:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  8032b6:	e9 18 02 00 00       	jmp    8034d3 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  8032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032be:	8b 50 0c             	mov    0xc(%eax),%edx
  8032c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032c4:	8b 40 08             	mov    0x8(%eax),%eax
  8032c7:	01 c2                	add    %eax,%edx
  8032c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032cc:	8b 40 08             	mov    0x8(%eax),%eax
  8032cf:	39 c2                	cmp    %eax,%edx
  8032d1:	0f 85 c4 01 00 00    	jne    80349b <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  8032d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8032da:	8b 50 0c             	mov    0xc(%eax),%edx
  8032dd:	8b 45 08             	mov    0x8(%ebp),%eax
  8032e0:	8b 40 08             	mov    0x8(%eax),%eax
  8032e3:	01 c2                	add    %eax,%edx
  8032e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032e8:	8b 00                	mov    (%eax),%eax
  8032ea:	8b 40 08             	mov    0x8(%eax),%eax
  8032ed:	39 c2                	cmp    %eax,%edx
  8032ef:	0f 85 a6 01 00 00    	jne    80349b <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  8032f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8032f9:	0f 84 9c 01 00 00    	je     80349b <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  8032ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803302:	8b 50 0c             	mov    0xc(%eax),%edx
  803305:	8b 45 08             	mov    0x8(%ebp),%eax
  803308:	8b 40 0c             	mov    0xc(%eax),%eax
  80330b:	01 c2                	add    %eax,%edx
  80330d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803310:	8b 00                	mov    (%eax),%eax
  803312:	8b 40 0c             	mov    0xc(%eax),%eax
  803315:	01 c2                	add    %eax,%edx
  803317:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80331a:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  80331d:	8b 45 08             	mov    0x8(%ebp),%eax
  803320:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  803327:	8b 45 08             	mov    0x8(%ebp),%eax
  80332a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  803331:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803335:	75 17                	jne    80334e <insert_sorted_with_merge_freeList+0x650>
  803337:	83 ec 04             	sub    $0x4,%esp
  80333a:	68 74 40 80 00       	push   $0x804074
  80333f:	68 32 01 00 00       	push   $0x132
  803344:	68 97 40 80 00       	push   $0x804097
  803349:	e8 d0 d3 ff ff       	call   80071e <_panic>
  80334e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803354:	8b 45 08             	mov    0x8(%ebp),%eax
  803357:	89 10                	mov    %edx,(%eax)
  803359:	8b 45 08             	mov    0x8(%ebp),%eax
  80335c:	8b 00                	mov    (%eax),%eax
  80335e:	85 c0                	test   %eax,%eax
  803360:	74 0d                	je     80336f <insert_sorted_with_merge_freeList+0x671>
  803362:	a1 48 51 80 00       	mov    0x805148,%eax
  803367:	8b 55 08             	mov    0x8(%ebp),%edx
  80336a:	89 50 04             	mov    %edx,0x4(%eax)
  80336d:	eb 08                	jmp    803377 <insert_sorted_with_merge_freeList+0x679>
  80336f:	8b 45 08             	mov    0x8(%ebp),%eax
  803372:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803377:	8b 45 08             	mov    0x8(%ebp),%eax
  80337a:	a3 48 51 80 00       	mov    %eax,0x805148
  80337f:	8b 45 08             	mov    0x8(%ebp),%eax
  803382:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803389:	a1 54 51 80 00       	mov    0x805154,%eax
  80338e:	40                   	inc    %eax
  80338f:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  803394:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803397:	8b 00                	mov    (%eax),%eax
  803399:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  8033a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033a3:	8b 00                	mov    (%eax),%eax
  8033a5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  8033ac:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033af:	8b 00                	mov    (%eax),%eax
  8033b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  8033b4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8033b8:	75 17                	jne    8033d1 <insert_sorted_with_merge_freeList+0x6d3>
  8033ba:	83 ec 04             	sub    $0x4,%esp
  8033bd:	68 09 41 80 00       	push   $0x804109
  8033c2:	68 36 01 00 00       	push   $0x136
  8033c7:	68 97 40 80 00       	push   $0x804097
  8033cc:	e8 4d d3 ff ff       	call   80071e <_panic>
  8033d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033d4:	8b 00                	mov    (%eax),%eax
  8033d6:	85 c0                	test   %eax,%eax
  8033d8:	74 10                	je     8033ea <insert_sorted_with_merge_freeList+0x6ec>
  8033da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033dd:	8b 00                	mov    (%eax),%eax
  8033df:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8033e2:	8b 52 04             	mov    0x4(%edx),%edx
  8033e5:	89 50 04             	mov    %edx,0x4(%eax)
  8033e8:	eb 0b                	jmp    8033f5 <insert_sorted_with_merge_freeList+0x6f7>
  8033ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033ed:	8b 40 04             	mov    0x4(%eax),%eax
  8033f0:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8033f8:	8b 40 04             	mov    0x4(%eax),%eax
  8033fb:	85 c0                	test   %eax,%eax
  8033fd:	74 0f                	je     80340e <insert_sorted_with_merge_freeList+0x710>
  8033ff:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803402:	8b 40 04             	mov    0x4(%eax),%eax
  803405:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803408:	8b 12                	mov    (%edx),%edx
  80340a:	89 10                	mov    %edx,(%eax)
  80340c:	eb 0a                	jmp    803418 <insert_sorted_with_merge_freeList+0x71a>
  80340e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803411:	8b 00                	mov    (%eax),%eax
  803413:	a3 38 51 80 00       	mov    %eax,0x805138
  803418:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80341b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803421:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803424:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80342b:	a1 44 51 80 00       	mov    0x805144,%eax
  803430:	48                   	dec    %eax
  803431:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  803436:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80343a:	75 17                	jne    803453 <insert_sorted_with_merge_freeList+0x755>
  80343c:	83 ec 04             	sub    $0x4,%esp
  80343f:	68 74 40 80 00       	push   $0x804074
  803444:	68 37 01 00 00       	push   $0x137
  803449:	68 97 40 80 00       	push   $0x804097
  80344e:	e8 cb d2 ff ff       	call   80071e <_panic>
  803453:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803459:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80345c:	89 10                	mov    %edx,(%eax)
  80345e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803461:	8b 00                	mov    (%eax),%eax
  803463:	85 c0                	test   %eax,%eax
  803465:	74 0d                	je     803474 <insert_sorted_with_merge_freeList+0x776>
  803467:	a1 48 51 80 00       	mov    0x805148,%eax
  80346c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80346f:	89 50 04             	mov    %edx,0x4(%eax)
  803472:	eb 08                	jmp    80347c <insert_sorted_with_merge_freeList+0x77e>
  803474:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803477:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80347c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80347f:	a3 48 51 80 00       	mov    %eax,0x805148
  803484:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803487:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80348e:	a1 54 51 80 00       	mov    0x805154,%eax
  803493:	40                   	inc    %eax
  803494:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803499:	eb 38                	jmp    8034d3 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  80349b:	a1 40 51 80 00       	mov    0x805140,%eax
  8034a0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8034a3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034a7:	74 07                	je     8034b0 <insert_sorted_with_merge_freeList+0x7b2>
  8034a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034ac:	8b 00                	mov    (%eax),%eax
  8034ae:	eb 05                	jmp    8034b5 <insert_sorted_with_merge_freeList+0x7b7>
  8034b0:	b8 00 00 00 00       	mov    $0x0,%eax
  8034b5:	a3 40 51 80 00       	mov    %eax,0x805140
  8034ba:	a1 40 51 80 00       	mov    0x805140,%eax
  8034bf:	85 c0                	test   %eax,%eax
  8034c1:	0f 85 ef f9 ff ff    	jne    802eb6 <insert_sorted_with_merge_freeList+0x1b8>
  8034c7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8034cb:	0f 85 e5 f9 ff ff    	jne    802eb6 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  8034d1:	eb 00                	jmp    8034d3 <insert_sorted_with_merge_freeList+0x7d5>
  8034d3:	90                   	nop
  8034d4:	c9                   	leave  
  8034d5:	c3                   	ret    

008034d6 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  8034d6:	55                   	push   %ebp
  8034d7:	89 e5                	mov    %esp,%ebp
  8034d9:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  8034dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8034df:	89 d0                	mov    %edx,%eax
  8034e1:	c1 e0 02             	shl    $0x2,%eax
  8034e4:	01 d0                	add    %edx,%eax
  8034e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034ed:	01 d0                	add    %edx,%eax
  8034ef:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034f6:	01 d0                	add    %edx,%eax
  8034f8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8034ff:	01 d0                	add    %edx,%eax
  803501:	c1 e0 04             	shl    $0x4,%eax
  803504:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  803507:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80350e:	8d 45 e8             	lea    -0x18(%ebp),%eax
  803511:	83 ec 0c             	sub    $0xc,%esp
  803514:	50                   	push   %eax
  803515:	e8 21 ec ff ff       	call   80213b <sys_get_virtual_time>
  80351a:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80351d:	eb 41                	jmp    803560 <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80351f:	8d 45 e0             	lea    -0x20(%ebp),%eax
  803522:	83 ec 0c             	sub    $0xc,%esp
  803525:	50                   	push   %eax
  803526:	e8 10 ec ff ff       	call   80213b <sys_get_virtual_time>
  80352b:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80352e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  803531:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803534:	29 c2                	sub    %eax,%edx
  803536:	89 d0                	mov    %edx,%eax
  803538:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  80353b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80353e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803541:	89 d1                	mov    %edx,%ecx
  803543:	29 c1                	sub    %eax,%ecx
  803545:	8b 55 d8             	mov    -0x28(%ebp),%edx
  803548:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80354b:	39 c2                	cmp    %eax,%edx
  80354d:	0f 97 c0             	seta   %al
  803550:	0f b6 c0             	movzbl %al,%eax
  803553:	29 c1                	sub    %eax,%ecx
  803555:	89 c8                	mov    %ecx,%eax
  803557:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  80355a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80355d:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  803560:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803563:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  803566:	72 b7                	jb     80351f <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  803568:	90                   	nop
  803569:	c9                   	leave  
  80356a:	c3                   	ret    

0080356b <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  80356b:	55                   	push   %ebp
  80356c:	89 e5                	mov    %esp,%ebp
  80356e:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  803571:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  803578:	eb 03                	jmp    80357d <busy_wait+0x12>
  80357a:	ff 45 fc             	incl   -0x4(%ebp)
  80357d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  803580:	3b 45 08             	cmp    0x8(%ebp),%eax
  803583:	72 f5                	jb     80357a <busy_wait+0xf>
	return i;
  803585:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  803588:	c9                   	leave  
  803589:	c3                   	ret    
  80358a:	66 90                	xchg   %ax,%ax

0080358c <__udivdi3>:
  80358c:	55                   	push   %ebp
  80358d:	57                   	push   %edi
  80358e:	56                   	push   %esi
  80358f:	53                   	push   %ebx
  803590:	83 ec 1c             	sub    $0x1c,%esp
  803593:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  803597:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80359b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80359f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8035a3:	89 ca                	mov    %ecx,%edx
  8035a5:	89 f8                	mov    %edi,%eax
  8035a7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  8035ab:	85 f6                	test   %esi,%esi
  8035ad:	75 2d                	jne    8035dc <__udivdi3+0x50>
  8035af:	39 cf                	cmp    %ecx,%edi
  8035b1:	77 65                	ja     803618 <__udivdi3+0x8c>
  8035b3:	89 fd                	mov    %edi,%ebp
  8035b5:	85 ff                	test   %edi,%edi
  8035b7:	75 0b                	jne    8035c4 <__udivdi3+0x38>
  8035b9:	b8 01 00 00 00       	mov    $0x1,%eax
  8035be:	31 d2                	xor    %edx,%edx
  8035c0:	f7 f7                	div    %edi
  8035c2:	89 c5                	mov    %eax,%ebp
  8035c4:	31 d2                	xor    %edx,%edx
  8035c6:	89 c8                	mov    %ecx,%eax
  8035c8:	f7 f5                	div    %ebp
  8035ca:	89 c1                	mov    %eax,%ecx
  8035cc:	89 d8                	mov    %ebx,%eax
  8035ce:	f7 f5                	div    %ebp
  8035d0:	89 cf                	mov    %ecx,%edi
  8035d2:	89 fa                	mov    %edi,%edx
  8035d4:	83 c4 1c             	add    $0x1c,%esp
  8035d7:	5b                   	pop    %ebx
  8035d8:	5e                   	pop    %esi
  8035d9:	5f                   	pop    %edi
  8035da:	5d                   	pop    %ebp
  8035db:	c3                   	ret    
  8035dc:	39 ce                	cmp    %ecx,%esi
  8035de:	77 28                	ja     803608 <__udivdi3+0x7c>
  8035e0:	0f bd fe             	bsr    %esi,%edi
  8035e3:	83 f7 1f             	xor    $0x1f,%edi
  8035e6:	75 40                	jne    803628 <__udivdi3+0x9c>
  8035e8:	39 ce                	cmp    %ecx,%esi
  8035ea:	72 0a                	jb     8035f6 <__udivdi3+0x6a>
  8035ec:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8035f0:	0f 87 9e 00 00 00    	ja     803694 <__udivdi3+0x108>
  8035f6:	b8 01 00 00 00       	mov    $0x1,%eax
  8035fb:	89 fa                	mov    %edi,%edx
  8035fd:	83 c4 1c             	add    $0x1c,%esp
  803600:	5b                   	pop    %ebx
  803601:	5e                   	pop    %esi
  803602:	5f                   	pop    %edi
  803603:	5d                   	pop    %ebp
  803604:	c3                   	ret    
  803605:	8d 76 00             	lea    0x0(%esi),%esi
  803608:	31 ff                	xor    %edi,%edi
  80360a:	31 c0                	xor    %eax,%eax
  80360c:	89 fa                	mov    %edi,%edx
  80360e:	83 c4 1c             	add    $0x1c,%esp
  803611:	5b                   	pop    %ebx
  803612:	5e                   	pop    %esi
  803613:	5f                   	pop    %edi
  803614:	5d                   	pop    %ebp
  803615:	c3                   	ret    
  803616:	66 90                	xchg   %ax,%ax
  803618:	89 d8                	mov    %ebx,%eax
  80361a:	f7 f7                	div    %edi
  80361c:	31 ff                	xor    %edi,%edi
  80361e:	89 fa                	mov    %edi,%edx
  803620:	83 c4 1c             	add    $0x1c,%esp
  803623:	5b                   	pop    %ebx
  803624:	5e                   	pop    %esi
  803625:	5f                   	pop    %edi
  803626:	5d                   	pop    %ebp
  803627:	c3                   	ret    
  803628:	bd 20 00 00 00       	mov    $0x20,%ebp
  80362d:	89 eb                	mov    %ebp,%ebx
  80362f:	29 fb                	sub    %edi,%ebx
  803631:	89 f9                	mov    %edi,%ecx
  803633:	d3 e6                	shl    %cl,%esi
  803635:	89 c5                	mov    %eax,%ebp
  803637:	88 d9                	mov    %bl,%cl
  803639:	d3 ed                	shr    %cl,%ebp
  80363b:	89 e9                	mov    %ebp,%ecx
  80363d:	09 f1                	or     %esi,%ecx
  80363f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803643:	89 f9                	mov    %edi,%ecx
  803645:	d3 e0                	shl    %cl,%eax
  803647:	89 c5                	mov    %eax,%ebp
  803649:	89 d6                	mov    %edx,%esi
  80364b:	88 d9                	mov    %bl,%cl
  80364d:	d3 ee                	shr    %cl,%esi
  80364f:	89 f9                	mov    %edi,%ecx
  803651:	d3 e2                	shl    %cl,%edx
  803653:	8b 44 24 08          	mov    0x8(%esp),%eax
  803657:	88 d9                	mov    %bl,%cl
  803659:	d3 e8                	shr    %cl,%eax
  80365b:	09 c2                	or     %eax,%edx
  80365d:	89 d0                	mov    %edx,%eax
  80365f:	89 f2                	mov    %esi,%edx
  803661:	f7 74 24 0c          	divl   0xc(%esp)
  803665:	89 d6                	mov    %edx,%esi
  803667:	89 c3                	mov    %eax,%ebx
  803669:	f7 e5                	mul    %ebp
  80366b:	39 d6                	cmp    %edx,%esi
  80366d:	72 19                	jb     803688 <__udivdi3+0xfc>
  80366f:	74 0b                	je     80367c <__udivdi3+0xf0>
  803671:	89 d8                	mov    %ebx,%eax
  803673:	31 ff                	xor    %edi,%edi
  803675:	e9 58 ff ff ff       	jmp    8035d2 <__udivdi3+0x46>
  80367a:	66 90                	xchg   %ax,%ax
  80367c:	8b 54 24 08          	mov    0x8(%esp),%edx
  803680:	89 f9                	mov    %edi,%ecx
  803682:	d3 e2                	shl    %cl,%edx
  803684:	39 c2                	cmp    %eax,%edx
  803686:	73 e9                	jae    803671 <__udivdi3+0xe5>
  803688:	8d 43 ff             	lea    -0x1(%ebx),%eax
  80368b:	31 ff                	xor    %edi,%edi
  80368d:	e9 40 ff ff ff       	jmp    8035d2 <__udivdi3+0x46>
  803692:	66 90                	xchg   %ax,%ax
  803694:	31 c0                	xor    %eax,%eax
  803696:	e9 37 ff ff ff       	jmp    8035d2 <__udivdi3+0x46>
  80369b:	90                   	nop

0080369c <__umoddi3>:
  80369c:	55                   	push   %ebp
  80369d:	57                   	push   %edi
  80369e:	56                   	push   %esi
  80369f:	53                   	push   %ebx
  8036a0:	83 ec 1c             	sub    $0x1c,%esp
  8036a3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8036a7:	8b 74 24 34          	mov    0x34(%esp),%esi
  8036ab:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036af:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  8036b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8036b7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  8036bb:	89 f3                	mov    %esi,%ebx
  8036bd:	89 fa                	mov    %edi,%edx
  8036bf:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8036c3:	89 34 24             	mov    %esi,(%esp)
  8036c6:	85 c0                	test   %eax,%eax
  8036c8:	75 1a                	jne    8036e4 <__umoddi3+0x48>
  8036ca:	39 f7                	cmp    %esi,%edi
  8036cc:	0f 86 a2 00 00 00    	jbe    803774 <__umoddi3+0xd8>
  8036d2:	89 c8                	mov    %ecx,%eax
  8036d4:	89 f2                	mov    %esi,%edx
  8036d6:	f7 f7                	div    %edi
  8036d8:	89 d0                	mov    %edx,%eax
  8036da:	31 d2                	xor    %edx,%edx
  8036dc:	83 c4 1c             	add    $0x1c,%esp
  8036df:	5b                   	pop    %ebx
  8036e0:	5e                   	pop    %esi
  8036e1:	5f                   	pop    %edi
  8036e2:	5d                   	pop    %ebp
  8036e3:	c3                   	ret    
  8036e4:	39 f0                	cmp    %esi,%eax
  8036e6:	0f 87 ac 00 00 00    	ja     803798 <__umoddi3+0xfc>
  8036ec:	0f bd e8             	bsr    %eax,%ebp
  8036ef:	83 f5 1f             	xor    $0x1f,%ebp
  8036f2:	0f 84 ac 00 00 00    	je     8037a4 <__umoddi3+0x108>
  8036f8:	bf 20 00 00 00       	mov    $0x20,%edi
  8036fd:	29 ef                	sub    %ebp,%edi
  8036ff:	89 fe                	mov    %edi,%esi
  803701:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803705:	89 e9                	mov    %ebp,%ecx
  803707:	d3 e0                	shl    %cl,%eax
  803709:	89 d7                	mov    %edx,%edi
  80370b:	89 f1                	mov    %esi,%ecx
  80370d:	d3 ef                	shr    %cl,%edi
  80370f:	09 c7                	or     %eax,%edi
  803711:	89 e9                	mov    %ebp,%ecx
  803713:	d3 e2                	shl    %cl,%edx
  803715:	89 14 24             	mov    %edx,(%esp)
  803718:	89 d8                	mov    %ebx,%eax
  80371a:	d3 e0                	shl    %cl,%eax
  80371c:	89 c2                	mov    %eax,%edx
  80371e:	8b 44 24 08          	mov    0x8(%esp),%eax
  803722:	d3 e0                	shl    %cl,%eax
  803724:	89 44 24 04          	mov    %eax,0x4(%esp)
  803728:	8b 44 24 08          	mov    0x8(%esp),%eax
  80372c:	89 f1                	mov    %esi,%ecx
  80372e:	d3 e8                	shr    %cl,%eax
  803730:	09 d0                	or     %edx,%eax
  803732:	d3 eb                	shr    %cl,%ebx
  803734:	89 da                	mov    %ebx,%edx
  803736:	f7 f7                	div    %edi
  803738:	89 d3                	mov    %edx,%ebx
  80373a:	f7 24 24             	mull   (%esp)
  80373d:	89 c6                	mov    %eax,%esi
  80373f:	89 d1                	mov    %edx,%ecx
  803741:	39 d3                	cmp    %edx,%ebx
  803743:	0f 82 87 00 00 00    	jb     8037d0 <__umoddi3+0x134>
  803749:	0f 84 91 00 00 00    	je     8037e0 <__umoddi3+0x144>
  80374f:	8b 54 24 04          	mov    0x4(%esp),%edx
  803753:	29 f2                	sub    %esi,%edx
  803755:	19 cb                	sbb    %ecx,%ebx
  803757:	89 d8                	mov    %ebx,%eax
  803759:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  80375d:	d3 e0                	shl    %cl,%eax
  80375f:	89 e9                	mov    %ebp,%ecx
  803761:	d3 ea                	shr    %cl,%edx
  803763:	09 d0                	or     %edx,%eax
  803765:	89 e9                	mov    %ebp,%ecx
  803767:	d3 eb                	shr    %cl,%ebx
  803769:	89 da                	mov    %ebx,%edx
  80376b:	83 c4 1c             	add    $0x1c,%esp
  80376e:	5b                   	pop    %ebx
  80376f:	5e                   	pop    %esi
  803770:	5f                   	pop    %edi
  803771:	5d                   	pop    %ebp
  803772:	c3                   	ret    
  803773:	90                   	nop
  803774:	89 fd                	mov    %edi,%ebp
  803776:	85 ff                	test   %edi,%edi
  803778:	75 0b                	jne    803785 <__umoddi3+0xe9>
  80377a:	b8 01 00 00 00       	mov    $0x1,%eax
  80377f:	31 d2                	xor    %edx,%edx
  803781:	f7 f7                	div    %edi
  803783:	89 c5                	mov    %eax,%ebp
  803785:	89 f0                	mov    %esi,%eax
  803787:	31 d2                	xor    %edx,%edx
  803789:	f7 f5                	div    %ebp
  80378b:	89 c8                	mov    %ecx,%eax
  80378d:	f7 f5                	div    %ebp
  80378f:	89 d0                	mov    %edx,%eax
  803791:	e9 44 ff ff ff       	jmp    8036da <__umoddi3+0x3e>
  803796:	66 90                	xchg   %ax,%ax
  803798:	89 c8                	mov    %ecx,%eax
  80379a:	89 f2                	mov    %esi,%edx
  80379c:	83 c4 1c             	add    $0x1c,%esp
  80379f:	5b                   	pop    %ebx
  8037a0:	5e                   	pop    %esi
  8037a1:	5f                   	pop    %edi
  8037a2:	5d                   	pop    %ebp
  8037a3:	c3                   	ret    
  8037a4:	3b 04 24             	cmp    (%esp),%eax
  8037a7:	72 06                	jb     8037af <__umoddi3+0x113>
  8037a9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  8037ad:	77 0f                	ja     8037be <__umoddi3+0x122>
  8037af:	89 f2                	mov    %esi,%edx
  8037b1:	29 f9                	sub    %edi,%ecx
  8037b3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  8037b7:	89 14 24             	mov    %edx,(%esp)
  8037ba:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  8037be:	8b 44 24 04          	mov    0x4(%esp),%eax
  8037c2:	8b 14 24             	mov    (%esp),%edx
  8037c5:	83 c4 1c             	add    $0x1c,%esp
  8037c8:	5b                   	pop    %ebx
  8037c9:	5e                   	pop    %esi
  8037ca:	5f                   	pop    %edi
  8037cb:	5d                   	pop    %ebp
  8037cc:	c3                   	ret    
  8037cd:	8d 76 00             	lea    0x0(%esi),%esi
  8037d0:	2b 04 24             	sub    (%esp),%eax
  8037d3:	19 fa                	sbb    %edi,%edx
  8037d5:	89 d1                	mov    %edx,%ecx
  8037d7:	89 c6                	mov    %eax,%esi
  8037d9:	e9 71 ff ff ff       	jmp    80374f <__umoddi3+0xb3>
  8037de:	66 90                	xchg   %ax,%ax
  8037e0:	39 44 24 04          	cmp    %eax,0x4(%esp)
  8037e4:	72 ea                	jb     8037d0 <__umoddi3+0x134>
  8037e6:	89 d9                	mov    %ebx,%ecx
  8037e8:	e9 62 ff ff ff       	jmp    80374f <__umoddi3+0xb3>
