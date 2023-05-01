
obj/user/tst_quicksort_freeHeap:     file format elf32-i386


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
  800031:	e8 30 08 00 00       	call   800866 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
uint32 CheckSorted(int *Elements, int NumOfElements);

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv);

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 44 01 00 00    	sub    $0x144,%esp


	//int InitFreeFrames = sys_calculate_free_frames() ;
	char Line[255] ;
	char Chose ;
	int Iteration = 0 ;
  800042:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	do
	{

		Iteration++ ;
  800049:	ff 45 f0             	incl   -0x10(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

	sys_disable_interrupt();
  80004c:	e8 35 23 00 00       	call   802386 <sys_disable_interrupt>
		readline("Enter the number of elements: ", Line);
  800051:	83 ec 08             	sub    $0x8,%esp
  800054:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  80005a:	50                   	push   %eax
  80005b:	68 e0 3b 80 00       	push   $0x803be0
  800060:	e8 73 12 00 00       	call   8012d8 <readline>
  800065:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800068:	83 ec 04             	sub    $0x4,%esp
  80006b:	6a 0a                	push   $0xa
  80006d:	6a 00                	push   $0x0
  80006f:	8d 85 c5 fe ff ff    	lea    -0x13b(%ebp),%eax
  800075:	50                   	push   %eax
  800076:	e8 c3 17 00 00       	call   80183e <strtol>
  80007b:	83 c4 10             	add    $0x10,%esp
  80007e:	89 45 ec             	mov    %eax,-0x14(%ebp)

		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  800081:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800084:	c1 e0 02             	shl    $0x2,%eax
  800087:	83 ec 0c             	sub    $0xc,%esp
  80008a:	50                   	push   %eax
  80008b:	e8 6b 1d 00 00       	call   801dfb <malloc>
  800090:	83 c4 10             	add    $0x10,%esp
  800093:	89 45 e8             	mov    %eax,-0x18(%ebp)
		uint32 num_disk_tables = 1;  //Since it is created with the first array, so it will be decremented in the 1st case only
  800096:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
		int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  80009d:	a1 24 50 80 00       	mov    0x805024,%eax
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	50                   	push   %eax
  8000a6:	e8 88 03 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  8000ab:	83 c4 10             	add    $0x10,%esp
  8000ae:	89 45 e0             	mov    %eax,-0x20(%ebp)
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  8000b1:	e8 e3 21 00 00       	call   802299 <sys_calculate_free_frames>
  8000b6:	89 c3                	mov    %eax,%ebx
  8000b8:	e8 f5 21 00 00       	call   8022b2 <sys_calculate_modified_frames>
  8000bd:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8000c0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8000c3:	29 c2                	sub    %eax,%edx
  8000c5:	89 d0                	mov    %edx,%eax
  8000c7:	89 45 dc             	mov    %eax,-0x24(%ebp)

		Elements[NumOfElements] = 10 ;
  8000ca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000cd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8000d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8000d7:	01 d0                	add    %edx,%eax
  8000d9:	c7 00 0a 00 00 00    	movl   $0xa,(%eax)
		//		cprintf("Free Frames After Allocation = %d\n", sys_calculate_free_frames()) ;
		cprintf("Choose the initialization method:\n") ;
  8000df:	83 ec 0c             	sub    $0xc,%esp
  8000e2:	68 00 3c 80 00       	push   $0x803c00
  8000e7:	e8 6a 0b 00 00       	call   800c56 <cprintf>
  8000ec:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000ef:	83 ec 0c             	sub    $0xc,%esp
  8000f2:	68 23 3c 80 00       	push   $0x803c23
  8000f7:	e8 5a 0b 00 00       	call   800c56 <cprintf>
  8000fc:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000ff:	83 ec 0c             	sub    $0xc,%esp
  800102:	68 31 3c 80 00       	push   $0x803c31
  800107:	e8 4a 0b 00 00       	call   800c56 <cprintf>
  80010c:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n") ;
  80010f:	83 ec 0c             	sub    $0xc,%esp
  800112:	68 40 3c 80 00       	push   $0x803c40
  800117:	e8 3a 0b 00 00       	call   800c56 <cprintf>
  80011c:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  80011f:	83 ec 0c             	sub    $0xc,%esp
  800122:	68 50 3c 80 00       	push   $0x803c50
  800127:	e8 2a 0b 00 00       	call   800c56 <cprintf>
  80012c:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  80012f:	e8 da 06 00 00       	call   80080e <getchar>
  800134:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  800137:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80013b:	83 ec 0c             	sub    $0xc,%esp
  80013e:	50                   	push   %eax
  80013f:	e8 82 06 00 00       	call   8007c6 <cputchar>
  800144:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800147:	83 ec 0c             	sub    $0xc,%esp
  80014a:	6a 0a                	push   $0xa
  80014c:	e8 75 06 00 00       	call   8007c6 <cputchar>
  800151:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800154:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800158:	74 0c                	je     800166 <_main+0x12e>
  80015a:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  80015e:	74 06                	je     800166 <_main+0x12e>
  800160:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800164:	75 b9                	jne    80011f <_main+0xe7>
	sys_enable_interrupt();
  800166:	e8 35 22 00 00       	call   8023a0 <sys_enable_interrupt>
		int  i ;
		switch (Chose)
  80016b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80016f:	83 f8 62             	cmp    $0x62,%eax
  800172:	74 1d                	je     800191 <_main+0x159>
  800174:	83 f8 63             	cmp    $0x63,%eax
  800177:	74 2b                	je     8001a4 <_main+0x16c>
  800179:	83 f8 61             	cmp    $0x61,%eax
  80017c:	75 39                	jne    8001b7 <_main+0x17f>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80017e:	83 ec 08             	sub    $0x8,%esp
  800181:	ff 75 ec             	pushl  -0x14(%ebp)
  800184:	ff 75 e8             	pushl  -0x18(%ebp)
  800187:	e8 02 05 00 00       	call   80068e <InitializeAscending>
  80018c:	83 c4 10             	add    $0x10,%esp
			break ;
  80018f:	eb 37                	jmp    8001c8 <_main+0x190>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  800191:	83 ec 08             	sub    $0x8,%esp
  800194:	ff 75 ec             	pushl  -0x14(%ebp)
  800197:	ff 75 e8             	pushl  -0x18(%ebp)
  80019a:	e8 20 05 00 00       	call   8006bf <InitializeDescending>
  80019f:	83 c4 10             	add    $0x10,%esp
			break ;
  8001a2:	eb 24                	jmp    8001c8 <_main+0x190>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  8001a4:	83 ec 08             	sub    $0x8,%esp
  8001a7:	ff 75 ec             	pushl  -0x14(%ebp)
  8001aa:	ff 75 e8             	pushl  -0x18(%ebp)
  8001ad:	e8 42 05 00 00       	call   8006f4 <InitializeSemiRandom>
  8001b2:	83 c4 10             	add    $0x10,%esp
			break ;
  8001b5:	eb 11                	jmp    8001c8 <_main+0x190>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  8001b7:	83 ec 08             	sub    $0x8,%esp
  8001ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8001bd:	ff 75 e8             	pushl  -0x18(%ebp)
  8001c0:	e8 2f 05 00 00       	call   8006f4 <InitializeSemiRandom>
  8001c5:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  8001c8:	83 ec 08             	sub    $0x8,%esp
  8001cb:	ff 75 ec             	pushl  -0x14(%ebp)
  8001ce:	ff 75 e8             	pushl  -0x18(%ebp)
  8001d1:	e8 fd 02 00 00       	call   8004d3 <QuickSort>
  8001d6:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  8001d9:	83 ec 08             	sub    $0x8,%esp
  8001dc:	ff 75 ec             	pushl  -0x14(%ebp)
  8001df:	ff 75 e8             	pushl  -0x18(%ebp)
  8001e2:	e8 fd 03 00 00       	call   8005e4 <CheckSorted>
  8001e7:	83 c4 10             	add    $0x10,%esp
  8001ea:	89 45 d8             	mov    %eax,-0x28(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ed:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8001f1:	75 14                	jne    800207 <_main+0x1cf>
  8001f3:	83 ec 04             	sub    $0x4,%esp
  8001f6:	68 5c 3c 80 00       	push   $0x803c5c
  8001fb:	6a 57                	push   $0x57
  8001fd:	68 7e 3c 80 00       	push   $0x803c7e
  800202:	e8 9b 07 00 00       	call   8009a2 <_panic>
		else
		{
			cprintf("===============================================\n") ;
  800207:	83 ec 0c             	sub    $0xc,%esp
  80020a:	68 9c 3c 80 00       	push   $0x803c9c
  80020f:	e8 42 0a 00 00       	call   800c56 <cprintf>
  800214:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  800217:	83 ec 0c             	sub    $0xc,%esp
  80021a:	68 d0 3c 80 00       	push   $0x803cd0
  80021f:	e8 32 0a 00 00       	call   800c56 <cprintf>
  800224:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  800227:	83 ec 0c             	sub    $0xc,%esp
  80022a:	68 04 3d 80 00       	push   $0x803d04
  80022f:	e8 22 0a 00 00       	call   800c56 <cprintf>
  800234:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  800237:	83 ec 0c             	sub    $0xc,%esp
  80023a:	68 36 3d 80 00       	push   $0x803d36
  80023f:	e8 12 0a 00 00       	call   800c56 <cprintf>
  800244:	83 c4 10             	add    $0x10,%esp
		free(Elements) ;
  800247:	83 ec 0c             	sub    $0xc,%esp
  80024a:	ff 75 e8             	pushl  -0x18(%ebp)
  80024d:	e8 42 1c 00 00       	call   801e94 <free>
  800252:	83 c4 10             	add    $0x10,%esp


		///Testing the freeHeap according to the specified scenario
		if (Iteration == 1)
  800255:	83 7d f0 01          	cmpl   $0x1,-0x10(%ebp)
  800259:	75 7b                	jne    8002d6 <_main+0x29e>
		{
			InitFreeFrames -= num_disk_tables;
  80025b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80025e:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800261:	89 45 dc             	mov    %eax,-0x24(%ebp)
			if (!(NumOfElements == 1000 && Chose == 'a'))
  800264:	81 7d ec e8 03 00 00 	cmpl   $0x3e8,-0x14(%ebp)
  80026b:	75 06                	jne    800273 <_main+0x23b>
  80026d:	80 7d f7 61          	cmpb   $0x61,-0x9(%ebp)
  800271:	74 14                	je     800287 <_main+0x24f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 4c 3d 80 00       	push   $0x803d4c
  80027b:	6a 6a                	push   $0x6a
  80027d:	68 7e 3c 80 00       	push   $0x803c7e
  800282:	e8 1b 07 00 00       	call   8009a2 <_panic>

			numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800287:	a1 24 50 80 00       	mov    0x805024,%eax
  80028c:	83 ec 0c             	sub    $0xc,%esp
  80028f:	50                   	push   %eax
  800290:	e8 9e 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800295:	83 c4 10             	add    $0x10,%esp
  800298:	89 45 e0             	mov    %eax,-0x20(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80029b:	e8 f9 1f 00 00       	call   802299 <sys_calculate_free_frames>
  8002a0:	89 c3                	mov    %eax,%ebx
  8002a2:	e8 0b 20 00 00       	call   8022b2 <sys_calculate_modified_frames>
  8002a7:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  8002aa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8002ad:	29 c2                	sub    %eax,%edx
  8002af:	89 d0                	mov    %edx,%eax
  8002b1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8002b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8002b7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8002ba:	0f 84 05 01 00 00    	je     8003c5 <_main+0x38d>
  8002c0:	68 9c 3d 80 00       	push   $0x803d9c
  8002c5:	68 c1 3d 80 00       	push   $0x803dc1
  8002ca:	6a 6e                	push   $0x6e
  8002cc:	68 7e 3c 80 00       	push   $0x803c7e
  8002d1:	e8 cc 06 00 00       	call   8009a2 <_panic>
		}
		else if (Iteration == 2 )
  8002d6:	83 7d f0 02          	cmpl   $0x2,-0x10(%ebp)
  8002da:	75 72                	jne    80034e <_main+0x316>
		{
			if (!(NumOfElements == 5000 && Chose == 'b'))
  8002dc:	81 7d ec 88 13 00 00 	cmpl   $0x1388,-0x14(%ebp)
  8002e3:	75 06                	jne    8002eb <_main+0x2b3>
  8002e5:	80 7d f7 62          	cmpb   $0x62,-0x9(%ebp)
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
				panic("Please ensure the number of elements and the initialization method of this test");
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 4c 3d 80 00       	push   $0x803d4c
  8002f3:	6a 73                	push   $0x73
  8002f5:	68 7e 3c 80 00       	push   $0x803c7e
  8002fa:	e8 a3 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  8002ff:	a1 24 50 80 00       	mov    0x805024,%eax
  800304:	83 ec 0c             	sub    $0xc,%esp
  800307:	50                   	push   %eax
  800308:	e8 26 01 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  80030d:	83 c4 10             	add    $0x10,%esp
  800310:	89 45 d0             	mov    %eax,-0x30(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  800313:	e8 81 1f 00 00       	call   802299 <sys_calculate_free_frames>
  800318:	89 c3                	mov    %eax,%ebx
  80031a:	e8 93 1f 00 00       	call   8022b2 <sys_calculate_modified_frames>
  80031f:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  800322:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800325:	29 c2                	sub    %eax,%edx
  800327:	89 d0                	mov    %edx,%eax
  800329:	89 45 cc             	mov    %eax,-0x34(%ebp)
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  80032c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80032f:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  800332:	0f 84 8d 00 00 00    	je     8003c5 <_main+0x38d>
  800338:	68 9c 3d 80 00       	push   $0x803d9c
  80033d:	68 c1 3d 80 00       	push   $0x803dc1
  800342:	6a 77                	push   $0x77
  800344:	68 7e 3c 80 00       	push   $0x803c7e
  800349:	e8 54 06 00 00       	call   8009a2 <_panic>
		}
		else if (Iteration == 3 )
  80034e:	83 7d f0 03          	cmpl   $0x3,-0x10(%ebp)
  800352:	75 71                	jne    8003c5 <_main+0x38d>
		{
			if (!(NumOfElements == 300000 && Chose == 'c'))
  800354:	81 7d ec e0 93 04 00 	cmpl   $0x493e0,-0x14(%ebp)
  80035b:	75 06                	jne    800363 <_main+0x32b>
  80035d:	80 7d f7 63          	cmpb   $0x63,-0x9(%ebp)
  800361:	74 14                	je     800377 <_main+0x33f>
				panic("Please ensure the number of elements and the initialization method of this test");
  800363:	83 ec 04             	sub    $0x4,%esp
  800366:	68 4c 3d 80 00       	push   $0x803d4c
  80036b:	6a 7c                	push   $0x7c
  80036d:	68 7e 3c 80 00       	push   $0x803c7e
  800372:	e8 2b 06 00 00       	call   8009a2 <_panic>

			int numOFEmptyLocInWS = CheckAndCountEmptyLocInWS(myEnv);
  800377:	a1 24 50 80 00       	mov    0x805024,%eax
  80037c:	83 ec 0c             	sub    $0xc,%esp
  80037f:	50                   	push   %eax
  800380:	e8 ae 00 00 00       	call   800433 <CheckAndCountEmptyLocInWS>
  800385:	83 c4 10             	add    $0x10,%esp
  800388:	89 45 c8             	mov    %eax,-0x38(%ebp)
			int CurrFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames() - numOFEmptyLocInWS;
  80038b:	e8 09 1f 00 00       	call   802299 <sys_calculate_free_frames>
  800390:	89 c3                	mov    %eax,%ebx
  800392:	e8 1b 1f 00 00       	call   8022b2 <sys_calculate_modified_frames>
  800397:	8d 14 03             	lea    (%ebx,%eax,1),%edx
  80039a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80039d:	29 c2                	sub    %eax,%edx
  80039f:	89 d0                	mov    %edx,%eax
  8003a1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
			//cprintf("numOFEmptyLocInWS = %d\n", numOFEmptyLocInWS );
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
  8003a4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  8003a7:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  8003aa:	74 19                	je     8003c5 <_main+0x38d>
  8003ac:	68 9c 3d 80 00       	push   $0x803d9c
  8003b1:	68 c1 3d 80 00       	push   $0x803dc1
  8003b6:	68 81 00 00 00       	push   $0x81
  8003bb:	68 7e 3c 80 00       	push   $0x803c7e
  8003c0:	e8 dd 05 00 00       	call   8009a2 <_panic>
		}
		///========================================================================
	sys_disable_interrupt();
  8003c5:	e8 bc 1f 00 00       	call   802386 <sys_disable_interrupt>
		Chose = 0 ;
  8003ca:	c6 45 f7 00          	movb   $0x0,-0x9(%ebp)
		while (Chose != 'y' && Chose != 'n')
  8003ce:	eb 42                	jmp    800412 <_main+0x3da>
		{
			cprintf("Do you want to repeat (y/n): ") ;
  8003d0:	83 ec 0c             	sub    $0xc,%esp
  8003d3:	68 d6 3d 80 00       	push   $0x803dd6
  8003d8:	e8 79 08 00 00       	call   800c56 <cprintf>
  8003dd:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8003e0:	e8 29 04 00 00       	call   80080e <getchar>
  8003e5:	88 45 f7             	mov    %al,-0x9(%ebp)
			cputchar(Chose);
  8003e8:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8003ec:	83 ec 0c             	sub    $0xc,%esp
  8003ef:	50                   	push   %eax
  8003f0:	e8 d1 03 00 00       	call   8007c6 <cputchar>
  8003f5:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  8003f8:	83 ec 0c             	sub    $0xc,%esp
  8003fb:	6a 0a                	push   $0xa
  8003fd:	e8 c4 03 00 00       	call   8007c6 <cputchar>
  800402:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  800405:	83 ec 0c             	sub    $0xc,%esp
  800408:	6a 0a                	push   $0xa
  80040a:	e8 b7 03 00 00       	call   8007c6 <cputchar>
  80040f:	83 c4 10             	add    $0x10,%esp
			assert(CurrFreeFrames - InitFreeFrames == 0) ;
		}
		///========================================================================
	sys_disable_interrupt();
		Chose = 0 ;
		while (Chose != 'y' && Chose != 'n')
  800412:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800416:	74 06                	je     80041e <_main+0x3e6>
  800418:	80 7d f7 6e          	cmpb   $0x6e,-0x9(%ebp)
  80041c:	75 b2                	jne    8003d0 <_main+0x398>
			Chose = getchar() ;
			cputchar(Chose);
			cputchar('\n');
			cputchar('\n');
		}
	sys_enable_interrupt();
  80041e:	e8 7d 1f 00 00       	call   8023a0 <sys_enable_interrupt>

	} while (Chose == 'y');
  800423:	80 7d f7 79          	cmpb   $0x79,-0x9(%ebp)
  800427:	0f 84 1c fc ff ff    	je     800049 <_main+0x11>
}
  80042d:	90                   	nop
  80042e:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800431:	c9                   	leave  
  800432:	c3                   	ret    

00800433 <CheckAndCountEmptyLocInWS>:

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
  800433:	55                   	push   %ebp
  800434:	89 e5                	mov    %esp,%ebp
  800436:	83 ec 18             	sub    $0x18,%esp
	int numOFEmptyLocInWS = 0, i;
  800439:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  800440:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800447:	eb 74                	jmp    8004bd <CheckAndCountEmptyLocInWS+0x8a>
	{
		if (myEnv->__uptr_pws[i].empty)
  800449:	8b 45 08             	mov    0x8(%ebp),%eax
  80044c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800452:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800455:	89 d0                	mov    %edx,%eax
  800457:	01 c0                	add    %eax,%eax
  800459:	01 d0                	add    %edx,%eax
  80045b:	c1 e0 03             	shl    $0x3,%eax
  80045e:	01 c8                	add    %ecx,%eax
  800460:	8a 40 04             	mov    0x4(%eax),%al
  800463:	84 c0                	test   %al,%al
  800465:	74 05                	je     80046c <CheckAndCountEmptyLocInWS+0x39>
		{
			numOFEmptyLocInWS++;
  800467:	ff 45 f4             	incl   -0xc(%ebp)
  80046a:	eb 4e                	jmp    8004ba <CheckAndCountEmptyLocInWS+0x87>
		}
		else
		{
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
  80046c:	8b 45 08             	mov    0x8(%ebp),%eax
  80046f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800475:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800478:	89 d0                	mov    %edx,%eax
  80047a:	01 c0                	add    %eax,%eax
  80047c:	01 d0                	add    %edx,%eax
  80047e:	c1 e0 03             	shl    $0x3,%eax
  800481:	01 c8                	add    %ecx,%eax
  800483:	8b 00                	mov    (%eax),%eax
  800485:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800488:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80048b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800490:	89 45 e8             	mov    %eax,-0x18(%ebp)
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
  800493:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800496:	85 c0                	test   %eax,%eax
  800498:	79 20                	jns    8004ba <CheckAndCountEmptyLocInWS+0x87>
  80049a:	81 7d e8 ff ff ff 9f 	cmpl   $0x9fffffff,-0x18(%ebp)
  8004a1:	77 17                	ja     8004ba <CheckAndCountEmptyLocInWS+0x87>
				panic("freeMem didn't remove its page(s) from the WS");
  8004a3:	83 ec 04             	sub    $0x4,%esp
  8004a6:	68 f4 3d 80 00       	push   $0x803df4
  8004ab:	68 a0 00 00 00       	push   $0xa0
  8004b0:	68 7e 3c 80 00       	push   $0x803c7e
  8004b5:	e8 e8 04 00 00       	call   8009a2 <_panic>
}

int CheckAndCountEmptyLocInWS(volatile struct Env *myEnv)
{
	int numOFEmptyLocInWS = 0, i;
	for (i = 0 ; i < myEnv->page_WS_max_size; i++)
  8004ba:	ff 45 f0             	incl   -0x10(%ebp)
  8004bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8004c0:	8b 50 74             	mov    0x74(%eax),%edx
  8004c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004c6:	39 c2                	cmp    %eax,%edx
  8004c8:	0f 87 7b ff ff ff    	ja     800449 <CheckAndCountEmptyLocInWS+0x16>
			uint32 va = ROUNDDOWN(myEnv->__uptr_pws[i].virtual_address,PAGE_SIZE) ;
			if (va >= USER_HEAP_START && va < (USER_HEAP_MAX))
				panic("freeMem didn't remove its page(s) from the WS");
		}
	}
	return numOFEmptyLocInWS;
  8004ce:	8b 45 f4             	mov    -0xc(%ebp),%eax

}
  8004d1:	c9                   	leave  
  8004d2:	c3                   	ret    

008004d3 <QuickSort>:

///Quick sort
void QuickSort(int *Elements, int NumOfElements)
{
  8004d3:	55                   	push   %ebp
  8004d4:	89 e5                	mov    %esp,%ebp
  8004d6:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  8004d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004dc:	48                   	dec    %eax
  8004dd:	50                   	push   %eax
  8004de:	6a 00                	push   $0x0
  8004e0:	ff 75 0c             	pushl  0xc(%ebp)
  8004e3:	ff 75 08             	pushl  0x8(%ebp)
  8004e6:	e8 06 00 00 00       	call   8004f1 <QSort>
  8004eb:	83 c4 10             	add    $0x10,%esp
}
  8004ee:	90                   	nop
  8004ef:	c9                   	leave  
  8004f0:	c3                   	ret    

008004f1 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  8004f1:	55                   	push   %ebp
  8004f2:	89 e5                	mov    %esp,%ebp
  8004f4:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  8004f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fa:	3b 45 14             	cmp    0x14(%ebp),%eax
  8004fd:	0f 8d de 00 00 00    	jge    8005e1 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800503:	8b 45 10             	mov    0x10(%ebp),%eax
  800506:	40                   	inc    %eax
  800507:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80050a:	8b 45 14             	mov    0x14(%ebp),%eax
  80050d:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800510:	e9 80 00 00 00       	jmp    800595 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800515:	ff 45 f4             	incl   -0xc(%ebp)
  800518:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80051b:	3b 45 14             	cmp    0x14(%ebp),%eax
  80051e:	7f 2b                	jg     80054b <QSort+0x5a>
  800520:	8b 45 10             	mov    0x10(%ebp),%eax
  800523:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052a:	8b 45 08             	mov    0x8(%ebp),%eax
  80052d:	01 d0                	add    %edx,%eax
  80052f:	8b 10                	mov    (%eax),%edx
  800531:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800534:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80053b:	8b 45 08             	mov    0x8(%ebp),%eax
  80053e:	01 c8                	add    %ecx,%eax
  800540:	8b 00                	mov    (%eax),%eax
  800542:	39 c2                	cmp    %eax,%edx
  800544:	7d cf                	jge    800515 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  800546:	eb 03                	jmp    80054b <QSort+0x5a>
  800548:	ff 4d f0             	decl   -0x10(%ebp)
  80054b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80054e:	3b 45 10             	cmp    0x10(%ebp),%eax
  800551:	7e 26                	jle    800579 <QSort+0x88>
  800553:	8b 45 10             	mov    0x10(%ebp),%eax
  800556:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80055d:	8b 45 08             	mov    0x8(%ebp),%eax
  800560:	01 d0                	add    %edx,%eax
  800562:	8b 10                	mov    (%eax),%edx
  800564:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800567:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80056e:	8b 45 08             	mov    0x8(%ebp),%eax
  800571:	01 c8                	add    %ecx,%eax
  800573:	8b 00                	mov    (%eax),%eax
  800575:	39 c2                	cmp    %eax,%edx
  800577:	7e cf                	jle    800548 <QSort+0x57>

		if (i <= j)
  800579:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80057c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80057f:	7f 14                	jg     800595 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800581:	83 ec 04             	sub    $0x4,%esp
  800584:	ff 75 f0             	pushl  -0x10(%ebp)
  800587:	ff 75 f4             	pushl  -0xc(%ebp)
  80058a:	ff 75 08             	pushl  0x8(%ebp)
  80058d:	e8 a9 00 00 00       	call   80063b <Swap>
  800592:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800595:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800598:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80059b:	0f 8e 77 ff ff ff    	jle    800518 <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  8005a1:	83 ec 04             	sub    $0x4,%esp
  8005a4:	ff 75 f0             	pushl  -0x10(%ebp)
  8005a7:	ff 75 10             	pushl  0x10(%ebp)
  8005aa:	ff 75 08             	pushl  0x8(%ebp)
  8005ad:	e8 89 00 00 00       	call   80063b <Swap>
  8005b2:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  8005b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005b8:	48                   	dec    %eax
  8005b9:	50                   	push   %eax
  8005ba:	ff 75 10             	pushl  0x10(%ebp)
  8005bd:	ff 75 0c             	pushl  0xc(%ebp)
  8005c0:	ff 75 08             	pushl  0x8(%ebp)
  8005c3:	e8 29 ff ff ff       	call   8004f1 <QSort>
  8005c8:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  8005cb:	ff 75 14             	pushl  0x14(%ebp)
  8005ce:	ff 75 f4             	pushl  -0xc(%ebp)
  8005d1:	ff 75 0c             	pushl  0xc(%ebp)
  8005d4:	ff 75 08             	pushl  0x8(%ebp)
  8005d7:	e8 15 ff ff ff       	call   8004f1 <QSort>
  8005dc:	83 c4 10             	add    $0x10,%esp
  8005df:	eb 01                	jmp    8005e2 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  8005e1:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  8005e2:	c9                   	leave  
  8005e3:	c3                   	ret    

008005e4 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  8005e4:	55                   	push   %ebp
  8005e5:	89 e5                	mov    %esp,%ebp
  8005e7:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  8005ea:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8005f1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8005f8:	eb 33                	jmp    80062d <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  8005fa:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8005fd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800604:	8b 45 08             	mov    0x8(%ebp),%eax
  800607:	01 d0                	add    %edx,%eax
  800609:	8b 10                	mov    (%eax),%edx
  80060b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80060e:	40                   	inc    %eax
  80060f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	01 c8                	add    %ecx,%eax
  80061b:	8b 00                	mov    (%eax),%eax
  80061d:	39 c2                	cmp    %eax,%edx
  80061f:	7e 09                	jle    80062a <CheckSorted+0x46>
		{
			Sorted = 0 ;
  800621:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  800628:	eb 0c                	jmp    800636 <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  80062a:	ff 45 f8             	incl   -0x8(%ebp)
  80062d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800630:	48                   	dec    %eax
  800631:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800634:	7f c4                	jg     8005fa <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  800636:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800639:	c9                   	leave  
  80063a:	c3                   	ret    

0080063b <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  80063b:	55                   	push   %ebp
  80063c:	89 e5                	mov    %esp,%ebp
  80063e:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  800641:	8b 45 0c             	mov    0xc(%ebp),%eax
  800644:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	01 d0                	add    %edx,%eax
  800650:	8b 00                	mov    (%eax),%eax
  800652:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  800655:	8b 45 0c             	mov    0xc(%ebp),%eax
  800658:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80065f:	8b 45 08             	mov    0x8(%ebp),%eax
  800662:	01 c2                	add    %eax,%edx
  800664:	8b 45 10             	mov    0x10(%ebp),%eax
  800667:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80066e:	8b 45 08             	mov    0x8(%ebp),%eax
  800671:	01 c8                	add    %ecx,%eax
  800673:	8b 00                	mov    (%eax),%eax
  800675:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  800677:	8b 45 10             	mov    0x10(%ebp),%eax
  80067a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	01 c2                	add    %eax,%edx
  800686:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800689:	89 02                	mov    %eax,(%edx)
}
  80068b:	90                   	nop
  80068c:	c9                   	leave  
  80068d:	c3                   	ret    

0080068e <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  80068e:	55                   	push   %ebp
  80068f:	89 e5                	mov    %esp,%ebp
  800691:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800694:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80069b:	eb 17                	jmp    8006b4 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  80069d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006a0:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006aa:	01 c2                	add    %eax,%edx
  8006ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006af:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006b1:	ff 45 fc             	incl   -0x4(%ebp)
  8006b4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ba:	7c e1                	jl     80069d <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  8006bc:	90                   	nop
  8006bd:	c9                   	leave  
  8006be:	c3                   	ret    

008006bf <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  8006bf:	55                   	push   %ebp
  8006c0:	89 e5                	mov    %esp,%ebp
  8006c2:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8006cc:	eb 1b                	jmp    8006e9 <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  8006ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006d1:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8006d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8006db:	01 c2                	add    %eax,%edx
  8006dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e0:	2b 45 fc             	sub    -0x4(%ebp),%eax
  8006e3:	48                   	dec    %eax
  8006e4:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  8006e6:	ff 45 fc             	incl   -0x4(%ebp)
  8006e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8006ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8006ef:	7c dd                	jl     8006ce <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  8006f1:	90                   	nop
  8006f2:	c9                   	leave  
  8006f3:	c3                   	ret    

008006f4 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  8006f4:	55                   	push   %ebp
  8006f5:	89 e5                	mov    %esp,%ebp
  8006f7:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  8006fa:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  8006fd:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800702:	f7 e9                	imul   %ecx
  800704:	c1 f9 1f             	sar    $0x1f,%ecx
  800707:	89 d0                	mov    %edx,%eax
  800709:	29 c8                	sub    %ecx,%eax
  80070b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  80070e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800715:	eb 1e                	jmp    800735 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  800717:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80071a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800721:	8b 45 08             	mov    0x8(%ebp),%eax
  800724:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  800727:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80072a:	99                   	cltd   
  80072b:	f7 7d f8             	idivl  -0x8(%ebp)
  80072e:	89 d0                	mov    %edx,%eax
  800730:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  800732:	ff 45 fc             	incl   -0x4(%ebp)
  800735:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800738:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80073b:	7c da                	jl     800717 <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  80073d:	90                   	nop
  80073e:	c9                   	leave  
  80073f:	c3                   	ret    

00800740 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  800740:	55                   	push   %ebp
  800741:	89 e5                	mov    %esp,%ebp
  800743:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  800746:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  80074d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800754:	eb 42                	jmp    800798 <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  800756:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800759:	99                   	cltd   
  80075a:	f7 7d f0             	idivl  -0x10(%ebp)
  80075d:	89 d0                	mov    %edx,%eax
  80075f:	85 c0                	test   %eax,%eax
  800761:	75 10                	jne    800773 <PrintElements+0x33>
			cprintf("\n");
  800763:	83 ec 0c             	sub    $0xc,%esp
  800766:	68 22 3e 80 00       	push   $0x803e22
  80076b:	e8 e6 04 00 00       	call   800c56 <cprintf>
  800770:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  800773:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800776:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80077d:	8b 45 08             	mov    0x8(%ebp),%eax
  800780:	01 d0                	add    %edx,%eax
  800782:	8b 00                	mov    (%eax),%eax
  800784:	83 ec 08             	sub    $0x8,%esp
  800787:	50                   	push   %eax
  800788:	68 24 3e 80 00       	push   $0x803e24
  80078d:	e8 c4 04 00 00       	call   800c56 <cprintf>
  800792:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800795:	ff 45 f4             	incl   -0xc(%ebp)
  800798:	8b 45 0c             	mov    0xc(%ebp),%eax
  80079b:	48                   	dec    %eax
  80079c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80079f:	7f b5                	jg     800756 <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  8007a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8007a4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ae:	01 d0                	add    %edx,%eax
  8007b0:	8b 00                	mov    (%eax),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	50                   	push   %eax
  8007b6:	68 29 3e 80 00       	push   $0x803e29
  8007bb:	e8 96 04 00 00       	call   800c56 <cprintf>
  8007c0:	83 c4 10             	add    $0x10,%esp

}
  8007c3:	90                   	nop
  8007c4:	c9                   	leave  
  8007c5:	c3                   	ret    

008007c6 <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  8007c6:	55                   	push   %ebp
  8007c7:	89 e5                	mov    %esp,%ebp
  8007c9:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  8007cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007cf:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007d2:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007d6:	83 ec 0c             	sub    $0xc,%esp
  8007d9:	50                   	push   %eax
  8007da:	e8 db 1b 00 00       	call   8023ba <sys_cputc>
  8007df:	83 c4 10             	add    $0x10,%esp
}
  8007e2:	90                   	nop
  8007e3:	c9                   	leave  
  8007e4:	c3                   	ret    

008007e5 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  8007e5:	55                   	push   %ebp
  8007e6:	89 e5                	mov    %esp,%ebp
  8007e8:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007eb:	e8 96 1b 00 00       	call   802386 <sys_disable_interrupt>
	char c = ch;
  8007f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8007f3:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  8007f6:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  8007fa:	83 ec 0c             	sub    $0xc,%esp
  8007fd:	50                   	push   %eax
  8007fe:	e8 b7 1b 00 00       	call   8023ba <sys_cputc>
  800803:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800806:	e8 95 1b 00 00       	call   8023a0 <sys_enable_interrupt>
}
  80080b:	90                   	nop
  80080c:	c9                   	leave  
  80080d:	c3                   	ret    

0080080e <getchar>:

int
getchar(void)
{
  80080e:	55                   	push   %ebp
  80080f:	89 e5                	mov    %esp,%ebp
  800811:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800814:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80081b:	eb 08                	jmp    800825 <getchar+0x17>
	{
		c = sys_cgetc();
  80081d:	e8 df 19 00 00       	call   802201 <sys_cgetc>
  800822:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  800825:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800829:	74 f2                	je     80081d <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  80082b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80082e:	c9                   	leave  
  80082f:	c3                   	ret    

00800830 <atomic_getchar>:

int
atomic_getchar(void)
{
  800830:	55                   	push   %ebp
  800831:	89 e5                	mov    %esp,%ebp
  800833:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800836:	e8 4b 1b 00 00       	call   802386 <sys_disable_interrupt>
	int c=0;
  80083b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  800842:	eb 08                	jmp    80084c <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  800844:	e8 b8 19 00 00       	call   802201 <sys_cgetc>
  800849:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  80084c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800850:	74 f2                	je     800844 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  800852:	e8 49 1b 00 00       	call   8023a0 <sys_enable_interrupt>
	return c;
  800857:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80085a:	c9                   	leave  
  80085b:	c3                   	ret    

0080085c <iscons>:

int iscons(int fdnum)
{
  80085c:	55                   	push   %ebp
  80085d:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  80085f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  800864:	5d                   	pop    %ebp
  800865:	c3                   	ret    

00800866 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800866:	55                   	push   %ebp
  800867:	89 e5                	mov    %esp,%ebp
  800869:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80086c:	e8 08 1d 00 00       	call   802579 <sys_getenvindex>
  800871:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800874:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800877:	89 d0                	mov    %edx,%eax
  800879:	c1 e0 03             	shl    $0x3,%eax
  80087c:	01 d0                	add    %edx,%eax
  80087e:	01 c0                	add    %eax,%eax
  800880:	01 d0                	add    %edx,%eax
  800882:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800889:	01 d0                	add    %edx,%eax
  80088b:	c1 e0 04             	shl    $0x4,%eax
  80088e:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800893:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800898:	a1 24 50 80 00       	mov    0x805024,%eax
  80089d:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8008a3:	84 c0                	test   %al,%al
  8008a5:	74 0f                	je     8008b6 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8008a7:	a1 24 50 80 00       	mov    0x805024,%eax
  8008ac:	05 5c 05 00 00       	add    $0x55c,%eax
  8008b1:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8008b6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8008ba:	7e 0a                	jle    8008c6 <libmain+0x60>
		binaryname = argv[0];
  8008bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bf:	8b 00                	mov    (%eax),%eax
  8008c1:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  8008c6:	83 ec 08             	sub    $0x8,%esp
  8008c9:	ff 75 0c             	pushl  0xc(%ebp)
  8008cc:	ff 75 08             	pushl  0x8(%ebp)
  8008cf:	e8 64 f7 ff ff       	call   800038 <_main>
  8008d4:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8008d7:	e8 aa 1a 00 00       	call   802386 <sys_disable_interrupt>
	cprintf("**************************************\n");
  8008dc:	83 ec 0c             	sub    $0xc,%esp
  8008df:	68 48 3e 80 00       	push   $0x803e48
  8008e4:	e8 6d 03 00 00       	call   800c56 <cprintf>
  8008e9:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8008ec:	a1 24 50 80 00       	mov    0x805024,%eax
  8008f1:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8008f7:	a1 24 50 80 00       	mov    0x805024,%eax
  8008fc:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800902:	83 ec 04             	sub    $0x4,%esp
  800905:	52                   	push   %edx
  800906:	50                   	push   %eax
  800907:	68 70 3e 80 00       	push   $0x803e70
  80090c:	e8 45 03 00 00       	call   800c56 <cprintf>
  800911:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800914:	a1 24 50 80 00       	mov    0x805024,%eax
  800919:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80091f:	a1 24 50 80 00       	mov    0x805024,%eax
  800924:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80092a:	a1 24 50 80 00       	mov    0x805024,%eax
  80092f:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800935:	51                   	push   %ecx
  800936:	52                   	push   %edx
  800937:	50                   	push   %eax
  800938:	68 98 3e 80 00       	push   $0x803e98
  80093d:	e8 14 03 00 00       	call   800c56 <cprintf>
  800942:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800945:	a1 24 50 80 00       	mov    0x805024,%eax
  80094a:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800950:	83 ec 08             	sub    $0x8,%esp
  800953:	50                   	push   %eax
  800954:	68 f0 3e 80 00       	push   $0x803ef0
  800959:	e8 f8 02 00 00       	call   800c56 <cprintf>
  80095e:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800961:	83 ec 0c             	sub    $0xc,%esp
  800964:	68 48 3e 80 00       	push   $0x803e48
  800969:	e8 e8 02 00 00       	call   800c56 <cprintf>
  80096e:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800971:	e8 2a 1a 00 00       	call   8023a0 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800976:	e8 19 00 00 00       	call   800994 <exit>
}
  80097b:	90                   	nop
  80097c:	c9                   	leave  
  80097d:	c3                   	ret    

0080097e <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80097e:	55                   	push   %ebp
  80097f:	89 e5                	mov    %esp,%ebp
  800981:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800984:	83 ec 0c             	sub    $0xc,%esp
  800987:	6a 00                	push   $0x0
  800989:	e8 b7 1b 00 00       	call   802545 <sys_destroy_env>
  80098e:	83 c4 10             	add    $0x10,%esp
}
  800991:	90                   	nop
  800992:	c9                   	leave  
  800993:	c3                   	ret    

00800994 <exit>:

void
exit(void)
{
  800994:	55                   	push   %ebp
  800995:	89 e5                	mov    %esp,%ebp
  800997:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80099a:	e8 0c 1c 00 00       	call   8025ab <sys_exit_env>
}
  80099f:	90                   	nop
  8009a0:	c9                   	leave  
  8009a1:	c3                   	ret    

008009a2 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8009a2:	55                   	push   %ebp
  8009a3:	89 e5                	mov    %esp,%ebp
  8009a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8009a8:	8d 45 10             	lea    0x10(%ebp),%eax
  8009ab:	83 c0 04             	add    $0x4,%eax
  8009ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8009b1:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8009b6:	85 c0                	test   %eax,%eax
  8009b8:	74 16                	je     8009d0 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8009ba:	a1 5c 51 80 00       	mov    0x80515c,%eax
  8009bf:	83 ec 08             	sub    $0x8,%esp
  8009c2:	50                   	push   %eax
  8009c3:	68 04 3f 80 00       	push   $0x803f04
  8009c8:	e8 89 02 00 00       	call   800c56 <cprintf>
  8009cd:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8009d0:	a1 00 50 80 00       	mov    0x805000,%eax
  8009d5:	ff 75 0c             	pushl  0xc(%ebp)
  8009d8:	ff 75 08             	pushl  0x8(%ebp)
  8009db:	50                   	push   %eax
  8009dc:	68 09 3f 80 00       	push   $0x803f09
  8009e1:	e8 70 02 00 00       	call   800c56 <cprintf>
  8009e6:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	83 ec 08             	sub    $0x8,%esp
  8009ef:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f2:	50                   	push   %eax
  8009f3:	e8 f3 01 00 00       	call   800beb <vcprintf>
  8009f8:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  8009fb:	83 ec 08             	sub    $0x8,%esp
  8009fe:	6a 00                	push   $0x0
  800a00:	68 25 3f 80 00       	push   $0x803f25
  800a05:	e8 e1 01 00 00       	call   800beb <vcprintf>
  800a0a:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800a0d:	e8 82 ff ff ff       	call   800994 <exit>

	// should not return here
	while (1) ;
  800a12:	eb fe                	jmp    800a12 <_panic+0x70>

00800a14 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800a1a:	a1 24 50 80 00       	mov    0x805024,%eax
  800a1f:	8b 50 74             	mov    0x74(%eax),%edx
  800a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a25:	39 c2                	cmp    %eax,%edx
  800a27:	74 14                	je     800a3d <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800a29:	83 ec 04             	sub    $0x4,%esp
  800a2c:	68 28 3f 80 00       	push   $0x803f28
  800a31:	6a 26                	push   $0x26
  800a33:	68 74 3f 80 00       	push   $0x803f74
  800a38:	e8 65 ff ff ff       	call   8009a2 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800a3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800a44:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800a4b:	e9 c2 00 00 00       	jmp    800b12 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800a50:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a53:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800a5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800a5d:	01 d0                	add    %edx,%eax
  800a5f:	8b 00                	mov    (%eax),%eax
  800a61:	85 c0                	test   %eax,%eax
  800a63:	75 08                	jne    800a6d <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800a65:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800a68:	e9 a2 00 00 00       	jmp    800b0f <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800a6d:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800a74:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800a7b:	eb 69                	jmp    800ae6 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800a7d:	a1 24 50 80 00       	mov    0x805024,%eax
  800a82:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800a88:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800a8b:	89 d0                	mov    %edx,%eax
  800a8d:	01 c0                	add    %eax,%eax
  800a8f:	01 d0                	add    %edx,%eax
  800a91:	c1 e0 03             	shl    $0x3,%eax
  800a94:	01 c8                	add    %ecx,%eax
  800a96:	8a 40 04             	mov    0x4(%eax),%al
  800a99:	84 c0                	test   %al,%al
  800a9b:	75 46                	jne    800ae3 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800a9d:	a1 24 50 80 00       	mov    0x805024,%eax
  800aa2:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800aa8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800aab:	89 d0                	mov    %edx,%eax
  800aad:	01 c0                	add    %eax,%eax
  800aaf:	01 d0                	add    %edx,%eax
  800ab1:	c1 e0 03             	shl    $0x3,%eax
  800ab4:	01 c8                	add    %ecx,%eax
  800ab6:	8b 00                	mov    (%eax),%eax
  800ab8:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800abb:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800abe:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800ac3:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800ac5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800acf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad2:	01 c8                	add    %ecx,%eax
  800ad4:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800ad6:	39 c2                	cmp    %eax,%edx
  800ad8:	75 09                	jne    800ae3 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800ada:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800ae1:	eb 12                	jmp    800af5 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800ae3:	ff 45 e8             	incl   -0x18(%ebp)
  800ae6:	a1 24 50 80 00       	mov    0x805024,%eax
  800aeb:	8b 50 74             	mov    0x74(%eax),%edx
  800aee:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800af1:	39 c2                	cmp    %eax,%edx
  800af3:	77 88                	ja     800a7d <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800af5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800af9:	75 14                	jne    800b0f <CheckWSWithoutLastIndex+0xfb>
			panic(
  800afb:	83 ec 04             	sub    $0x4,%esp
  800afe:	68 80 3f 80 00       	push   $0x803f80
  800b03:	6a 3a                	push   $0x3a
  800b05:	68 74 3f 80 00       	push   $0x803f74
  800b0a:	e8 93 fe ff ff       	call   8009a2 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800b0f:	ff 45 f0             	incl   -0x10(%ebp)
  800b12:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b15:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800b18:	0f 8c 32 ff ff ff    	jl     800a50 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800b1e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b25:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800b2c:	eb 26                	jmp    800b54 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800b2e:	a1 24 50 80 00       	mov    0x805024,%eax
  800b33:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b39:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800b3c:	89 d0                	mov    %edx,%eax
  800b3e:	01 c0                	add    %eax,%eax
  800b40:	01 d0                	add    %edx,%eax
  800b42:	c1 e0 03             	shl    $0x3,%eax
  800b45:	01 c8                	add    %ecx,%eax
  800b47:	8a 40 04             	mov    0x4(%eax),%al
  800b4a:	3c 01                	cmp    $0x1,%al
  800b4c:	75 03                	jne    800b51 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800b4e:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b51:	ff 45 e0             	incl   -0x20(%ebp)
  800b54:	a1 24 50 80 00       	mov    0x805024,%eax
  800b59:	8b 50 74             	mov    0x74(%eax),%edx
  800b5c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b5f:	39 c2                	cmp    %eax,%edx
  800b61:	77 cb                	ja     800b2e <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800b63:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800b66:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800b69:	74 14                	je     800b7f <CheckWSWithoutLastIndex+0x16b>
		panic(
  800b6b:	83 ec 04             	sub    $0x4,%esp
  800b6e:	68 d4 3f 80 00       	push   $0x803fd4
  800b73:	6a 44                	push   $0x44
  800b75:	68 74 3f 80 00       	push   $0x803f74
  800b7a:	e8 23 fe ff ff       	call   8009a2 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800b7f:	90                   	nop
  800b80:	c9                   	leave  
  800b81:	c3                   	ret    

00800b82 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800b82:	55                   	push   %ebp
  800b83:	89 e5                	mov    %esp,%ebp
  800b85:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800b88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b8b:	8b 00                	mov    (%eax),%eax
  800b8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800b90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b93:	89 0a                	mov    %ecx,(%edx)
  800b95:	8b 55 08             	mov    0x8(%ebp),%edx
  800b98:	88 d1                	mov    %dl,%cl
  800b9a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800b9d:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ba4:	8b 00                	mov    (%eax),%eax
  800ba6:	3d ff 00 00 00       	cmp    $0xff,%eax
  800bab:	75 2c                	jne    800bd9 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800bad:	a0 28 50 80 00       	mov    0x805028,%al
  800bb2:	0f b6 c0             	movzbl %al,%eax
  800bb5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bb8:	8b 12                	mov    (%edx),%edx
  800bba:	89 d1                	mov    %edx,%ecx
  800bbc:	8b 55 0c             	mov    0xc(%ebp),%edx
  800bbf:	83 c2 08             	add    $0x8,%edx
  800bc2:	83 ec 04             	sub    $0x4,%esp
  800bc5:	50                   	push   %eax
  800bc6:	51                   	push   %ecx
  800bc7:	52                   	push   %edx
  800bc8:	e8 0b 16 00 00       	call   8021d8 <sys_cputs>
  800bcd:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800bd0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bd3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800bd9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800bdc:	8b 40 04             	mov    0x4(%eax),%eax
  800bdf:	8d 50 01             	lea    0x1(%eax),%edx
  800be2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be5:	89 50 04             	mov    %edx,0x4(%eax)
}
  800be8:	90                   	nop
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800bf4:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800bfb:	00 00 00 
	b.cnt = 0;
  800bfe:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800c05:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800c08:	ff 75 0c             	pushl  0xc(%ebp)
  800c0b:	ff 75 08             	pushl  0x8(%ebp)
  800c0e:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c14:	50                   	push   %eax
  800c15:	68 82 0b 80 00       	push   $0x800b82
  800c1a:	e8 11 02 00 00       	call   800e30 <vprintfmt>
  800c1f:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800c22:	a0 28 50 80 00       	mov    0x805028,%al
  800c27:	0f b6 c0             	movzbl %al,%eax
  800c2a:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800c30:	83 ec 04             	sub    $0x4,%esp
  800c33:	50                   	push   %eax
  800c34:	52                   	push   %edx
  800c35:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800c3b:	83 c0 08             	add    $0x8,%eax
  800c3e:	50                   	push   %eax
  800c3f:	e8 94 15 00 00       	call   8021d8 <sys_cputs>
  800c44:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800c47:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  800c4e:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800c54:	c9                   	leave  
  800c55:	c3                   	ret    

00800c56 <cprintf>:

int cprintf(const char *fmt, ...) {
  800c56:	55                   	push   %ebp
  800c57:	89 e5                	mov    %esp,%ebp
  800c59:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800c5c:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  800c63:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	83 ec 08             	sub    $0x8,%esp
  800c6f:	ff 75 f4             	pushl  -0xc(%ebp)
  800c72:	50                   	push   %eax
  800c73:	e8 73 ff ff ff       	call   800beb <vcprintf>
  800c78:	83 c4 10             	add    $0x10,%esp
  800c7b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800c7e:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800c81:	c9                   	leave  
  800c82:	c3                   	ret    

00800c83 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800c83:	55                   	push   %ebp
  800c84:	89 e5                	mov    %esp,%ebp
  800c86:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800c89:	e8 f8 16 00 00       	call   802386 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800c8e:	8d 45 0c             	lea    0xc(%ebp),%eax
  800c91:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800c94:	8b 45 08             	mov    0x8(%ebp),%eax
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	ff 75 f4             	pushl  -0xc(%ebp)
  800c9d:	50                   	push   %eax
  800c9e:	e8 48 ff ff ff       	call   800beb <vcprintf>
  800ca3:	83 c4 10             	add    $0x10,%esp
  800ca6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800ca9:	e8 f2 16 00 00       	call   8023a0 <sys_enable_interrupt>
	return cnt;
  800cae:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800cb1:	c9                   	leave  
  800cb2:	c3                   	ret    

00800cb3 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800cb3:	55                   	push   %ebp
  800cb4:	89 e5                	mov    %esp,%ebp
  800cb6:	53                   	push   %ebx
  800cb7:	83 ec 14             	sub    $0x14,%esp
  800cba:	8b 45 10             	mov    0x10(%ebp),%eax
  800cbd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cc0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800cc6:	8b 45 18             	mov    0x18(%ebp),%eax
  800cc9:	ba 00 00 00 00       	mov    $0x0,%edx
  800cce:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd1:	77 55                	ja     800d28 <printnum+0x75>
  800cd3:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800cd6:	72 05                	jb     800cdd <printnum+0x2a>
  800cd8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800cdb:	77 4b                	ja     800d28 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800cdd:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800ce0:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800ce3:	8b 45 18             	mov    0x18(%ebp),%eax
  800ce6:	ba 00 00 00 00       	mov    $0x0,%edx
  800ceb:	52                   	push   %edx
  800cec:	50                   	push   %eax
  800ced:	ff 75 f4             	pushl  -0xc(%ebp)
  800cf0:	ff 75 f0             	pushl  -0x10(%ebp)
  800cf3:	e8 68 2c 00 00       	call   803960 <__udivdi3>
  800cf8:	83 c4 10             	add    $0x10,%esp
  800cfb:	83 ec 04             	sub    $0x4,%esp
  800cfe:	ff 75 20             	pushl  0x20(%ebp)
  800d01:	53                   	push   %ebx
  800d02:	ff 75 18             	pushl  0x18(%ebp)
  800d05:	52                   	push   %edx
  800d06:	50                   	push   %eax
  800d07:	ff 75 0c             	pushl  0xc(%ebp)
  800d0a:	ff 75 08             	pushl  0x8(%ebp)
  800d0d:	e8 a1 ff ff ff       	call   800cb3 <printnum>
  800d12:	83 c4 20             	add    $0x20,%esp
  800d15:	eb 1a                	jmp    800d31 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800d17:	83 ec 08             	sub    $0x8,%esp
  800d1a:	ff 75 0c             	pushl  0xc(%ebp)
  800d1d:	ff 75 20             	pushl  0x20(%ebp)
  800d20:	8b 45 08             	mov    0x8(%ebp),%eax
  800d23:	ff d0                	call   *%eax
  800d25:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800d28:	ff 4d 1c             	decl   0x1c(%ebp)
  800d2b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800d2f:	7f e6                	jg     800d17 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800d31:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800d34:	bb 00 00 00 00       	mov    $0x0,%ebx
  800d39:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800d3c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800d3f:	53                   	push   %ebx
  800d40:	51                   	push   %ecx
  800d41:	52                   	push   %edx
  800d42:	50                   	push   %eax
  800d43:	e8 28 2d 00 00       	call   803a70 <__umoddi3>
  800d48:	83 c4 10             	add    $0x10,%esp
  800d4b:	05 34 42 80 00       	add    $0x804234,%eax
  800d50:	8a 00                	mov    (%eax),%al
  800d52:	0f be c0             	movsbl %al,%eax
  800d55:	83 ec 08             	sub    $0x8,%esp
  800d58:	ff 75 0c             	pushl  0xc(%ebp)
  800d5b:	50                   	push   %eax
  800d5c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5f:	ff d0                	call   *%eax
  800d61:	83 c4 10             	add    $0x10,%esp
}
  800d64:	90                   	nop
  800d65:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800d68:	c9                   	leave  
  800d69:	c3                   	ret    

00800d6a <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800d6a:	55                   	push   %ebp
  800d6b:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800d6d:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800d71:	7e 1c                	jle    800d8f <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800d73:	8b 45 08             	mov    0x8(%ebp),%eax
  800d76:	8b 00                	mov    (%eax),%eax
  800d78:	8d 50 08             	lea    0x8(%eax),%edx
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	89 10                	mov    %edx,(%eax)
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	8b 00                	mov    (%eax),%eax
  800d85:	83 e8 08             	sub    $0x8,%eax
  800d88:	8b 50 04             	mov    0x4(%eax),%edx
  800d8b:	8b 00                	mov    (%eax),%eax
  800d8d:	eb 40                	jmp    800dcf <getuint+0x65>
	else if (lflag)
  800d8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d93:	74 1e                	je     800db3 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800d95:	8b 45 08             	mov    0x8(%ebp),%eax
  800d98:	8b 00                	mov    (%eax),%eax
  800d9a:	8d 50 04             	lea    0x4(%eax),%edx
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
  800da0:	89 10                	mov    %edx,(%eax)
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	8b 00                	mov    (%eax),%eax
  800da7:	83 e8 04             	sub    $0x4,%eax
  800daa:	8b 00                	mov    (%eax),%eax
  800dac:	ba 00 00 00 00       	mov    $0x0,%edx
  800db1:	eb 1c                	jmp    800dcf <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800db3:	8b 45 08             	mov    0x8(%ebp),%eax
  800db6:	8b 00                	mov    (%eax),%eax
  800db8:	8d 50 04             	lea    0x4(%eax),%edx
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	89 10                	mov    %edx,(%eax)
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	8b 00                	mov    (%eax),%eax
  800dc5:	83 e8 04             	sub    $0x4,%eax
  800dc8:	8b 00                	mov    (%eax),%eax
  800dca:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800dcf:	5d                   	pop    %ebp
  800dd0:	c3                   	ret    

00800dd1 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800dd1:	55                   	push   %ebp
  800dd2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800dd4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800dd8:	7e 1c                	jle    800df6 <getint+0x25>
		return va_arg(*ap, long long);
  800dda:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddd:	8b 00                	mov    (%eax),%eax
  800ddf:	8d 50 08             	lea    0x8(%eax),%edx
  800de2:	8b 45 08             	mov    0x8(%ebp),%eax
  800de5:	89 10                	mov    %edx,(%eax)
  800de7:	8b 45 08             	mov    0x8(%ebp),%eax
  800dea:	8b 00                	mov    (%eax),%eax
  800dec:	83 e8 08             	sub    $0x8,%eax
  800def:	8b 50 04             	mov    0x4(%eax),%edx
  800df2:	8b 00                	mov    (%eax),%eax
  800df4:	eb 38                	jmp    800e2e <getint+0x5d>
	else if (lflag)
  800df6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfa:	74 1a                	je     800e16 <getint+0x45>
		return va_arg(*ap, long);
  800dfc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dff:	8b 00                	mov    (%eax),%eax
  800e01:	8d 50 04             	lea    0x4(%eax),%edx
  800e04:	8b 45 08             	mov    0x8(%ebp),%eax
  800e07:	89 10                	mov    %edx,(%eax)
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	8b 00                	mov    (%eax),%eax
  800e0e:	83 e8 04             	sub    $0x4,%eax
  800e11:	8b 00                	mov    (%eax),%eax
  800e13:	99                   	cltd   
  800e14:	eb 18                	jmp    800e2e <getint+0x5d>
	else
		return va_arg(*ap, int);
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	8b 00                	mov    (%eax),%eax
  800e1b:	8d 50 04             	lea    0x4(%eax),%edx
  800e1e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e21:	89 10                	mov    %edx,(%eax)
  800e23:	8b 45 08             	mov    0x8(%ebp),%eax
  800e26:	8b 00                	mov    (%eax),%eax
  800e28:	83 e8 04             	sub    $0x4,%eax
  800e2b:	8b 00                	mov    (%eax),%eax
  800e2d:	99                   	cltd   
}
  800e2e:	5d                   	pop    %ebp
  800e2f:	c3                   	ret    

00800e30 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800e30:	55                   	push   %ebp
  800e31:	89 e5                	mov    %esp,%ebp
  800e33:	56                   	push   %esi
  800e34:	53                   	push   %ebx
  800e35:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e38:	eb 17                	jmp    800e51 <vprintfmt+0x21>
			if (ch == '\0')
  800e3a:	85 db                	test   %ebx,%ebx
  800e3c:	0f 84 af 03 00 00    	je     8011f1 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800e42:	83 ec 08             	sub    $0x8,%esp
  800e45:	ff 75 0c             	pushl  0xc(%ebp)
  800e48:	53                   	push   %ebx
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	ff d0                	call   *%eax
  800e4e:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800e51:	8b 45 10             	mov    0x10(%ebp),%eax
  800e54:	8d 50 01             	lea    0x1(%eax),%edx
  800e57:	89 55 10             	mov    %edx,0x10(%ebp)
  800e5a:	8a 00                	mov    (%eax),%al
  800e5c:	0f b6 d8             	movzbl %al,%ebx
  800e5f:	83 fb 25             	cmp    $0x25,%ebx
  800e62:	75 d6                	jne    800e3a <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800e64:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800e68:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800e6f:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800e76:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800e7d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800e84:	8b 45 10             	mov    0x10(%ebp),%eax
  800e87:	8d 50 01             	lea    0x1(%eax),%edx
  800e8a:	89 55 10             	mov    %edx,0x10(%ebp)
  800e8d:	8a 00                	mov    (%eax),%al
  800e8f:	0f b6 d8             	movzbl %al,%ebx
  800e92:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800e95:	83 f8 55             	cmp    $0x55,%eax
  800e98:	0f 87 2b 03 00 00    	ja     8011c9 <vprintfmt+0x399>
  800e9e:	8b 04 85 58 42 80 00 	mov    0x804258(,%eax,4),%eax
  800ea5:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800ea7:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800eab:	eb d7                	jmp    800e84 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800ead:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800eb1:	eb d1                	jmp    800e84 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800eb3:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800eba:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ebd:	89 d0                	mov    %edx,%eax
  800ebf:	c1 e0 02             	shl    $0x2,%eax
  800ec2:	01 d0                	add    %edx,%eax
  800ec4:	01 c0                	add    %eax,%eax
  800ec6:	01 d8                	add    %ebx,%eax
  800ec8:	83 e8 30             	sub    $0x30,%eax
  800ecb:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800ece:	8b 45 10             	mov    0x10(%ebp),%eax
  800ed1:	8a 00                	mov    (%eax),%al
  800ed3:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800ed6:	83 fb 2f             	cmp    $0x2f,%ebx
  800ed9:	7e 3e                	jle    800f19 <vprintfmt+0xe9>
  800edb:	83 fb 39             	cmp    $0x39,%ebx
  800ede:	7f 39                	jg     800f19 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800ee0:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800ee3:	eb d5                	jmp    800eba <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800ee5:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee8:	83 c0 04             	add    $0x4,%eax
  800eeb:	89 45 14             	mov    %eax,0x14(%ebp)
  800eee:	8b 45 14             	mov    0x14(%ebp),%eax
  800ef1:	83 e8 04             	sub    $0x4,%eax
  800ef4:	8b 00                	mov    (%eax),%eax
  800ef6:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800ef9:	eb 1f                	jmp    800f1a <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800efb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800eff:	79 83                	jns    800e84 <vprintfmt+0x54>
				width = 0;
  800f01:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800f08:	e9 77 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800f0d:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800f14:	e9 6b ff ff ff       	jmp    800e84 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800f19:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800f1a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800f1e:	0f 89 60 ff ff ff    	jns    800e84 <vprintfmt+0x54>
				width = precision, precision = -1;
  800f24:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f27:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f2a:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800f31:	e9 4e ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800f36:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800f39:	e9 46 ff ff ff       	jmp    800e84 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800f3e:	8b 45 14             	mov    0x14(%ebp),%eax
  800f41:	83 c0 04             	add    $0x4,%eax
  800f44:	89 45 14             	mov    %eax,0x14(%ebp)
  800f47:	8b 45 14             	mov    0x14(%ebp),%eax
  800f4a:	83 e8 04             	sub    $0x4,%eax
  800f4d:	8b 00                	mov    (%eax),%eax
  800f4f:	83 ec 08             	sub    $0x8,%esp
  800f52:	ff 75 0c             	pushl  0xc(%ebp)
  800f55:	50                   	push   %eax
  800f56:	8b 45 08             	mov    0x8(%ebp),%eax
  800f59:	ff d0                	call   *%eax
  800f5b:	83 c4 10             	add    $0x10,%esp
			break;
  800f5e:	e9 89 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800f63:	8b 45 14             	mov    0x14(%ebp),%eax
  800f66:	83 c0 04             	add    $0x4,%eax
  800f69:	89 45 14             	mov    %eax,0x14(%ebp)
  800f6c:	8b 45 14             	mov    0x14(%ebp),%eax
  800f6f:	83 e8 04             	sub    $0x4,%eax
  800f72:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800f74:	85 db                	test   %ebx,%ebx
  800f76:	79 02                	jns    800f7a <vprintfmt+0x14a>
				err = -err;
  800f78:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800f7a:	83 fb 64             	cmp    $0x64,%ebx
  800f7d:	7f 0b                	jg     800f8a <vprintfmt+0x15a>
  800f7f:	8b 34 9d a0 40 80 00 	mov    0x8040a0(,%ebx,4),%esi
  800f86:	85 f6                	test   %esi,%esi
  800f88:	75 19                	jne    800fa3 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800f8a:	53                   	push   %ebx
  800f8b:	68 45 42 80 00       	push   $0x804245
  800f90:	ff 75 0c             	pushl  0xc(%ebp)
  800f93:	ff 75 08             	pushl  0x8(%ebp)
  800f96:	e8 5e 02 00 00       	call   8011f9 <printfmt>
  800f9b:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800f9e:	e9 49 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800fa3:	56                   	push   %esi
  800fa4:	68 4e 42 80 00       	push   $0x80424e
  800fa9:	ff 75 0c             	pushl  0xc(%ebp)
  800fac:	ff 75 08             	pushl  0x8(%ebp)
  800faf:	e8 45 02 00 00       	call   8011f9 <printfmt>
  800fb4:	83 c4 10             	add    $0x10,%esp
			break;
  800fb7:	e9 30 02 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800fbc:	8b 45 14             	mov    0x14(%ebp),%eax
  800fbf:	83 c0 04             	add    $0x4,%eax
  800fc2:	89 45 14             	mov    %eax,0x14(%ebp)
  800fc5:	8b 45 14             	mov    0x14(%ebp),%eax
  800fc8:	83 e8 04             	sub    $0x4,%eax
  800fcb:	8b 30                	mov    (%eax),%esi
  800fcd:	85 f6                	test   %esi,%esi
  800fcf:	75 05                	jne    800fd6 <vprintfmt+0x1a6>
				p = "(null)";
  800fd1:	be 51 42 80 00       	mov    $0x804251,%esi
			if (width > 0 && padc != '-')
  800fd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fda:	7e 6d                	jle    801049 <vprintfmt+0x219>
  800fdc:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800fe0:	74 67                	je     801049 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800fe2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fe5:	83 ec 08             	sub    $0x8,%esp
  800fe8:	50                   	push   %eax
  800fe9:	56                   	push   %esi
  800fea:	e8 12 05 00 00       	call   801501 <strnlen>
  800fef:	83 c4 10             	add    $0x10,%esp
  800ff2:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800ff5:	eb 16                	jmp    80100d <vprintfmt+0x1dd>
					putch(padc, putdat);
  800ff7:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800ffb:	83 ec 08             	sub    $0x8,%esp
  800ffe:	ff 75 0c             	pushl  0xc(%ebp)
  801001:	50                   	push   %eax
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
  801005:	ff d0                	call   *%eax
  801007:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  80100a:	ff 4d e4             	decl   -0x1c(%ebp)
  80100d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801011:	7f e4                	jg     800ff7 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801013:	eb 34                	jmp    801049 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  801015:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  801019:	74 1c                	je     801037 <vprintfmt+0x207>
  80101b:	83 fb 1f             	cmp    $0x1f,%ebx
  80101e:	7e 05                	jle    801025 <vprintfmt+0x1f5>
  801020:	83 fb 7e             	cmp    $0x7e,%ebx
  801023:	7e 12                	jle    801037 <vprintfmt+0x207>
					putch('?', putdat);
  801025:	83 ec 08             	sub    $0x8,%esp
  801028:	ff 75 0c             	pushl  0xc(%ebp)
  80102b:	6a 3f                	push   $0x3f
  80102d:	8b 45 08             	mov    0x8(%ebp),%eax
  801030:	ff d0                	call   *%eax
  801032:	83 c4 10             	add    $0x10,%esp
  801035:	eb 0f                	jmp    801046 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  801037:	83 ec 08             	sub    $0x8,%esp
  80103a:	ff 75 0c             	pushl  0xc(%ebp)
  80103d:	53                   	push   %ebx
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
  801041:	ff d0                	call   *%eax
  801043:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801046:	ff 4d e4             	decl   -0x1c(%ebp)
  801049:	89 f0                	mov    %esi,%eax
  80104b:	8d 70 01             	lea    0x1(%eax),%esi
  80104e:	8a 00                	mov    (%eax),%al
  801050:	0f be d8             	movsbl %al,%ebx
  801053:	85 db                	test   %ebx,%ebx
  801055:	74 24                	je     80107b <vprintfmt+0x24b>
  801057:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80105b:	78 b8                	js     801015 <vprintfmt+0x1e5>
  80105d:	ff 4d e0             	decl   -0x20(%ebp)
  801060:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801064:	79 af                	jns    801015 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801066:	eb 13                	jmp    80107b <vprintfmt+0x24b>
				putch(' ', putdat);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	ff 75 0c             	pushl  0xc(%ebp)
  80106e:	6a 20                	push   $0x20
  801070:	8b 45 08             	mov    0x8(%ebp),%eax
  801073:	ff d0                	call   *%eax
  801075:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  801078:	ff 4d e4             	decl   -0x1c(%ebp)
  80107b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80107f:	7f e7                	jg     801068 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801081:	e9 66 01 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  801086:	83 ec 08             	sub    $0x8,%esp
  801089:	ff 75 e8             	pushl  -0x18(%ebp)
  80108c:	8d 45 14             	lea    0x14(%ebp),%eax
  80108f:	50                   	push   %eax
  801090:	e8 3c fd ff ff       	call   800dd1 <getint>
  801095:	83 c4 10             	add    $0x10,%esp
  801098:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80109b:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  80109e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010a1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010a4:	85 d2                	test   %edx,%edx
  8010a6:	79 23                	jns    8010cb <vprintfmt+0x29b>
				putch('-', putdat);
  8010a8:	83 ec 08             	sub    $0x8,%esp
  8010ab:	ff 75 0c             	pushl  0xc(%ebp)
  8010ae:	6a 2d                	push   $0x2d
  8010b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010b3:	ff d0                	call   *%eax
  8010b5:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8010b8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8010bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8010be:	f7 d8                	neg    %eax
  8010c0:	83 d2 00             	adc    $0x0,%edx
  8010c3:	f7 da                	neg    %edx
  8010c5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010c8:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8010cb:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010d2:	e9 bc 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8010d7:	83 ec 08             	sub    $0x8,%esp
  8010da:	ff 75 e8             	pushl  -0x18(%ebp)
  8010dd:	8d 45 14             	lea    0x14(%ebp),%eax
  8010e0:	50                   	push   %eax
  8010e1:	e8 84 fc ff ff       	call   800d6a <getuint>
  8010e6:	83 c4 10             	add    $0x10,%esp
  8010e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010ec:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8010ef:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8010f6:	e9 98 00 00 00       	jmp    801193 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8010fb:	83 ec 08             	sub    $0x8,%esp
  8010fe:	ff 75 0c             	pushl  0xc(%ebp)
  801101:	6a 58                	push   $0x58
  801103:	8b 45 08             	mov    0x8(%ebp),%eax
  801106:	ff d0                	call   *%eax
  801108:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80110b:	83 ec 08             	sub    $0x8,%esp
  80110e:	ff 75 0c             	pushl  0xc(%ebp)
  801111:	6a 58                	push   $0x58
  801113:	8b 45 08             	mov    0x8(%ebp),%eax
  801116:	ff d0                	call   *%eax
  801118:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	6a 58                	push   $0x58
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	ff d0                	call   *%eax
  801128:	83 c4 10             	add    $0x10,%esp
			break;
  80112b:	e9 bc 00 00 00       	jmp    8011ec <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801130:	83 ec 08             	sub    $0x8,%esp
  801133:	ff 75 0c             	pushl  0xc(%ebp)
  801136:	6a 30                	push   $0x30
  801138:	8b 45 08             	mov    0x8(%ebp),%eax
  80113b:	ff d0                	call   *%eax
  80113d:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801140:	83 ec 08             	sub    $0x8,%esp
  801143:	ff 75 0c             	pushl  0xc(%ebp)
  801146:	6a 78                	push   $0x78
  801148:	8b 45 08             	mov    0x8(%ebp),%eax
  80114b:	ff d0                	call   *%eax
  80114d:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801150:	8b 45 14             	mov    0x14(%ebp),%eax
  801153:	83 c0 04             	add    $0x4,%eax
  801156:	89 45 14             	mov    %eax,0x14(%ebp)
  801159:	8b 45 14             	mov    0x14(%ebp),%eax
  80115c:	83 e8 04             	sub    $0x4,%eax
  80115f:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801161:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801164:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  80116b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801172:	eb 1f                	jmp    801193 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  801174:	83 ec 08             	sub    $0x8,%esp
  801177:	ff 75 e8             	pushl  -0x18(%ebp)
  80117a:	8d 45 14             	lea    0x14(%ebp),%eax
  80117d:	50                   	push   %eax
  80117e:	e8 e7 fb ff ff       	call   800d6a <getuint>
  801183:	83 c4 10             	add    $0x10,%esp
  801186:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801189:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  80118c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801193:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801197:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80119a:	83 ec 04             	sub    $0x4,%esp
  80119d:	52                   	push   %edx
  80119e:	ff 75 e4             	pushl  -0x1c(%ebp)
  8011a1:	50                   	push   %eax
  8011a2:	ff 75 f4             	pushl  -0xc(%ebp)
  8011a5:	ff 75 f0             	pushl  -0x10(%ebp)
  8011a8:	ff 75 0c             	pushl  0xc(%ebp)
  8011ab:	ff 75 08             	pushl  0x8(%ebp)
  8011ae:	e8 00 fb ff ff       	call   800cb3 <printnum>
  8011b3:	83 c4 20             	add    $0x20,%esp
			break;
  8011b6:	eb 34                	jmp    8011ec <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8011b8:	83 ec 08             	sub    $0x8,%esp
  8011bb:	ff 75 0c             	pushl  0xc(%ebp)
  8011be:	53                   	push   %ebx
  8011bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8011c2:	ff d0                	call   *%eax
  8011c4:	83 c4 10             	add    $0x10,%esp
			break;
  8011c7:	eb 23                	jmp    8011ec <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8011c9:	83 ec 08             	sub    $0x8,%esp
  8011cc:	ff 75 0c             	pushl  0xc(%ebp)
  8011cf:	6a 25                	push   $0x25
  8011d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d4:	ff d0                	call   *%eax
  8011d6:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8011d9:	ff 4d 10             	decl   0x10(%ebp)
  8011dc:	eb 03                	jmp    8011e1 <vprintfmt+0x3b1>
  8011de:	ff 4d 10             	decl   0x10(%ebp)
  8011e1:	8b 45 10             	mov    0x10(%ebp),%eax
  8011e4:	48                   	dec    %eax
  8011e5:	8a 00                	mov    (%eax),%al
  8011e7:	3c 25                	cmp    $0x25,%al
  8011e9:	75 f3                	jne    8011de <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8011eb:	90                   	nop
		}
	}
  8011ec:	e9 47 fc ff ff       	jmp    800e38 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8011f1:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8011f2:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8011f5:	5b                   	pop    %ebx
  8011f6:	5e                   	pop    %esi
  8011f7:	5d                   	pop    %ebp
  8011f8:	c3                   	ret    

008011f9 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8011f9:	55                   	push   %ebp
  8011fa:	89 e5                	mov    %esp,%ebp
  8011fc:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8011ff:	8d 45 10             	lea    0x10(%ebp),%eax
  801202:	83 c0 04             	add    $0x4,%eax
  801205:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  801208:	8b 45 10             	mov    0x10(%ebp),%eax
  80120b:	ff 75 f4             	pushl  -0xc(%ebp)
  80120e:	50                   	push   %eax
  80120f:	ff 75 0c             	pushl  0xc(%ebp)
  801212:	ff 75 08             	pushl  0x8(%ebp)
  801215:	e8 16 fc ff ff       	call   800e30 <vprintfmt>
  80121a:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  80121d:	90                   	nop
  80121e:	c9                   	leave  
  80121f:	c3                   	ret    

00801220 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801220:	55                   	push   %ebp
  801221:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801223:	8b 45 0c             	mov    0xc(%ebp),%eax
  801226:	8b 40 08             	mov    0x8(%eax),%eax
  801229:	8d 50 01             	lea    0x1(%eax),%edx
  80122c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80122f:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801232:	8b 45 0c             	mov    0xc(%ebp),%eax
  801235:	8b 10                	mov    (%eax),%edx
  801237:	8b 45 0c             	mov    0xc(%ebp),%eax
  80123a:	8b 40 04             	mov    0x4(%eax),%eax
  80123d:	39 c2                	cmp    %eax,%edx
  80123f:	73 12                	jae    801253 <sprintputch+0x33>
		*b->buf++ = ch;
  801241:	8b 45 0c             	mov    0xc(%ebp),%eax
  801244:	8b 00                	mov    (%eax),%eax
  801246:	8d 48 01             	lea    0x1(%eax),%ecx
  801249:	8b 55 0c             	mov    0xc(%ebp),%edx
  80124c:	89 0a                	mov    %ecx,(%edx)
  80124e:	8b 55 08             	mov    0x8(%ebp),%edx
  801251:	88 10                	mov    %dl,(%eax)
}
  801253:	90                   	nop
  801254:	5d                   	pop    %ebp
  801255:	c3                   	ret    

00801256 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  801256:	55                   	push   %ebp
  801257:	89 e5                	mov    %esp,%ebp
  801259:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  80125c:	8b 45 08             	mov    0x8(%ebp),%eax
  80125f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801262:	8b 45 0c             	mov    0xc(%ebp),%eax
  801265:	8d 50 ff             	lea    -0x1(%eax),%edx
  801268:	8b 45 08             	mov    0x8(%ebp),%eax
  80126b:	01 d0                	add    %edx,%eax
  80126d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801270:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  801277:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80127b:	74 06                	je     801283 <vsnprintf+0x2d>
  80127d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801281:	7f 07                	jg     80128a <vsnprintf+0x34>
		return -E_INVAL;
  801283:	b8 03 00 00 00       	mov    $0x3,%eax
  801288:	eb 20                	jmp    8012aa <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80128a:	ff 75 14             	pushl  0x14(%ebp)
  80128d:	ff 75 10             	pushl  0x10(%ebp)
  801290:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801293:	50                   	push   %eax
  801294:	68 20 12 80 00       	push   $0x801220
  801299:	e8 92 fb ff ff       	call   800e30 <vprintfmt>
  80129e:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  8012a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8012a4:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  8012a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8012aa:	c9                   	leave  
  8012ab:	c3                   	ret    

008012ac <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8012ac:	55                   	push   %ebp
  8012ad:	89 e5                	mov    %esp,%ebp
  8012af:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8012b2:	8d 45 10             	lea    0x10(%ebp),%eax
  8012b5:	83 c0 04             	add    $0x4,%eax
  8012b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8012bb:	8b 45 10             	mov    0x10(%ebp),%eax
  8012be:	ff 75 f4             	pushl  -0xc(%ebp)
  8012c1:	50                   	push   %eax
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	ff 75 08             	pushl  0x8(%ebp)
  8012c8:	e8 89 ff ff ff       	call   801256 <vsnprintf>
  8012cd:	83 c4 10             	add    $0x10,%esp
  8012d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8012d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8012d6:	c9                   	leave  
  8012d7:	c3                   	ret    

008012d8 <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  8012d8:	55                   	push   %ebp
  8012d9:	89 e5                	mov    %esp,%ebp
  8012db:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  8012de:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012e2:	74 13                	je     8012f7 <readline+0x1f>
		cprintf("%s", prompt);
  8012e4:	83 ec 08             	sub    $0x8,%esp
  8012e7:	ff 75 08             	pushl  0x8(%ebp)
  8012ea:	68 b0 43 80 00       	push   $0x8043b0
  8012ef:	e8 62 f9 ff ff       	call   800c56 <cprintf>
  8012f4:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8012f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  8012fe:	83 ec 0c             	sub    $0xc,%esp
  801301:	6a 00                	push   $0x0
  801303:	e8 54 f5 ff ff       	call   80085c <iscons>
  801308:	83 c4 10             	add    $0x10,%esp
  80130b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  80130e:	e8 fb f4 ff ff       	call   80080e <getchar>
  801313:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801316:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80131a:	79 22                	jns    80133e <readline+0x66>
			if (c != -E_EOF)
  80131c:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801320:	0f 84 ad 00 00 00    	je     8013d3 <readline+0xfb>
				cprintf("read error: %e\n", c);
  801326:	83 ec 08             	sub    $0x8,%esp
  801329:	ff 75 ec             	pushl  -0x14(%ebp)
  80132c:	68 b3 43 80 00       	push   $0x8043b3
  801331:	e8 20 f9 ff ff       	call   800c56 <cprintf>
  801336:	83 c4 10             	add    $0x10,%esp
			return;
  801339:	e9 95 00 00 00       	jmp    8013d3 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  80133e:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801342:	7e 34                	jle    801378 <readline+0xa0>
  801344:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80134b:	7f 2b                	jg     801378 <readline+0xa0>
			if (echoing)
  80134d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801351:	74 0e                	je     801361 <readline+0x89>
				cputchar(c);
  801353:	83 ec 0c             	sub    $0xc,%esp
  801356:	ff 75 ec             	pushl  -0x14(%ebp)
  801359:	e8 68 f4 ff ff       	call   8007c6 <cputchar>
  80135e:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801361:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801364:	8d 50 01             	lea    0x1(%eax),%edx
  801367:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80136a:	89 c2                	mov    %eax,%edx
  80136c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80136f:	01 d0                	add    %edx,%eax
  801371:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801374:	88 10                	mov    %dl,(%eax)
  801376:	eb 56                	jmp    8013ce <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  801378:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  80137c:	75 1f                	jne    80139d <readline+0xc5>
  80137e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801382:	7e 19                	jle    80139d <readline+0xc5>
			if (echoing)
  801384:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801388:	74 0e                	je     801398 <readline+0xc0>
				cputchar(c);
  80138a:	83 ec 0c             	sub    $0xc,%esp
  80138d:	ff 75 ec             	pushl  -0x14(%ebp)
  801390:	e8 31 f4 ff ff       	call   8007c6 <cputchar>
  801395:	83 c4 10             	add    $0x10,%esp

			i--;
  801398:	ff 4d f4             	decl   -0xc(%ebp)
  80139b:	eb 31                	jmp    8013ce <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  80139d:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8013a1:	74 0a                	je     8013ad <readline+0xd5>
  8013a3:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8013a7:	0f 85 61 ff ff ff    	jne    80130e <readline+0x36>
			if (echoing)
  8013ad:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8013b1:	74 0e                	je     8013c1 <readline+0xe9>
				cputchar(c);
  8013b3:	83 ec 0c             	sub    $0xc,%esp
  8013b6:	ff 75 ec             	pushl  -0x14(%ebp)
  8013b9:	e8 08 f4 ff ff       	call   8007c6 <cputchar>
  8013be:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  8013c1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013c4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c7:	01 d0                	add    %edx,%eax
  8013c9:	c6 00 00             	movb   $0x0,(%eax)
			return;
  8013cc:	eb 06                	jmp    8013d4 <readline+0xfc>
		}
	}
  8013ce:	e9 3b ff ff ff       	jmp    80130e <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  8013d3:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  8013d4:	c9                   	leave  
  8013d5:	c3                   	ret    

008013d6 <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  8013d6:	55                   	push   %ebp
  8013d7:	89 e5                	mov    %esp,%ebp
  8013d9:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8013dc:	e8 a5 0f 00 00       	call   802386 <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  8013e1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8013e5:	74 13                	je     8013fa <atomic_readline+0x24>
		cprintf("%s", prompt);
  8013e7:	83 ec 08             	sub    $0x8,%esp
  8013ea:	ff 75 08             	pushl  0x8(%ebp)
  8013ed:	68 b0 43 80 00       	push   $0x8043b0
  8013f2:	e8 5f f8 ff ff       	call   800c56 <cprintf>
  8013f7:	83 c4 10             	add    $0x10,%esp

	i = 0;
  8013fa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801401:	83 ec 0c             	sub    $0xc,%esp
  801404:	6a 00                	push   $0x0
  801406:	e8 51 f4 ff ff       	call   80085c <iscons>
  80140b:	83 c4 10             	add    $0x10,%esp
  80140e:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801411:	e8 f8 f3 ff ff       	call   80080e <getchar>
  801416:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  801419:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80141d:	79 23                	jns    801442 <atomic_readline+0x6c>
			if (c != -E_EOF)
  80141f:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  801423:	74 13                	je     801438 <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  801425:	83 ec 08             	sub    $0x8,%esp
  801428:	ff 75 ec             	pushl  -0x14(%ebp)
  80142b:	68 b3 43 80 00       	push   $0x8043b3
  801430:	e8 21 f8 ff ff       	call   800c56 <cprintf>
  801435:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  801438:	e8 63 0f 00 00       	call   8023a0 <sys_enable_interrupt>
			return;
  80143d:	e9 9a 00 00 00       	jmp    8014dc <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  801442:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  801446:	7e 34                	jle    80147c <atomic_readline+0xa6>
  801448:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  80144f:	7f 2b                	jg     80147c <atomic_readline+0xa6>
			if (echoing)
  801451:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801455:	74 0e                	je     801465 <atomic_readline+0x8f>
				cputchar(c);
  801457:	83 ec 0c             	sub    $0xc,%esp
  80145a:	ff 75 ec             	pushl  -0x14(%ebp)
  80145d:	e8 64 f3 ff ff       	call   8007c6 <cputchar>
  801462:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  801465:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801468:	8d 50 01             	lea    0x1(%eax),%edx
  80146b:	89 55 f4             	mov    %edx,-0xc(%ebp)
  80146e:	89 c2                	mov    %eax,%edx
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	01 d0                	add    %edx,%eax
  801475:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801478:	88 10                	mov    %dl,(%eax)
  80147a:	eb 5b                	jmp    8014d7 <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  80147c:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801480:	75 1f                	jne    8014a1 <atomic_readline+0xcb>
  801482:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801486:	7e 19                	jle    8014a1 <atomic_readline+0xcb>
			if (echoing)
  801488:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80148c:	74 0e                	je     80149c <atomic_readline+0xc6>
				cputchar(c);
  80148e:	83 ec 0c             	sub    $0xc,%esp
  801491:	ff 75 ec             	pushl  -0x14(%ebp)
  801494:	e8 2d f3 ff ff       	call   8007c6 <cputchar>
  801499:	83 c4 10             	add    $0x10,%esp
			i--;
  80149c:	ff 4d f4             	decl   -0xc(%ebp)
  80149f:	eb 36                	jmp    8014d7 <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  8014a1:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  8014a5:	74 0a                	je     8014b1 <atomic_readline+0xdb>
  8014a7:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  8014ab:	0f 85 60 ff ff ff    	jne    801411 <atomic_readline+0x3b>
			if (echoing)
  8014b1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8014b5:	74 0e                	je     8014c5 <atomic_readline+0xef>
				cputchar(c);
  8014b7:	83 ec 0c             	sub    $0xc,%esp
  8014ba:	ff 75 ec             	pushl  -0x14(%ebp)
  8014bd:	e8 04 f3 ff ff       	call   8007c6 <cputchar>
  8014c2:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  8014c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8014c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014cb:	01 d0                	add    %edx,%eax
  8014cd:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  8014d0:	e8 cb 0e 00 00       	call   8023a0 <sys_enable_interrupt>
			return;
  8014d5:	eb 05                	jmp    8014dc <atomic_readline+0x106>
		}
	}
  8014d7:	e9 35 ff ff ff       	jmp    801411 <atomic_readline+0x3b>
}
  8014dc:	c9                   	leave  
  8014dd:	c3                   	ret    

008014de <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8014de:	55                   	push   %ebp
  8014df:	89 e5                	mov    %esp,%ebp
  8014e1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8014e4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8014eb:	eb 06                	jmp    8014f3 <strlen+0x15>
		n++;
  8014ed:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8014f0:	ff 45 08             	incl   0x8(%ebp)
  8014f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	84 c0                	test   %al,%al
  8014fa:	75 f1                	jne    8014ed <strlen+0xf>
		n++;
	return n;
  8014fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8014ff:	c9                   	leave  
  801500:	c3                   	ret    

00801501 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801501:	55                   	push   %ebp
  801502:	89 e5                	mov    %esp,%ebp
  801504:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801507:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80150e:	eb 09                	jmp    801519 <strnlen+0x18>
		n++;
  801510:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801513:	ff 45 08             	incl   0x8(%ebp)
  801516:	ff 4d 0c             	decl   0xc(%ebp)
  801519:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80151d:	74 09                	je     801528 <strnlen+0x27>
  80151f:	8b 45 08             	mov    0x8(%ebp),%eax
  801522:	8a 00                	mov    (%eax),%al
  801524:	84 c0                	test   %al,%al
  801526:	75 e8                	jne    801510 <strnlen+0xf>
		n++;
	return n;
  801528:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80152b:	c9                   	leave  
  80152c:	c3                   	ret    

0080152d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80152d:	55                   	push   %ebp
  80152e:	89 e5                	mov    %esp,%ebp
  801530:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
  801536:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801539:	90                   	nop
  80153a:	8b 45 08             	mov    0x8(%ebp),%eax
  80153d:	8d 50 01             	lea    0x1(%eax),%edx
  801540:	89 55 08             	mov    %edx,0x8(%ebp)
  801543:	8b 55 0c             	mov    0xc(%ebp),%edx
  801546:	8d 4a 01             	lea    0x1(%edx),%ecx
  801549:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80154c:	8a 12                	mov    (%edx),%dl
  80154e:	88 10                	mov    %dl,(%eax)
  801550:	8a 00                	mov    (%eax),%al
  801552:	84 c0                	test   %al,%al
  801554:	75 e4                	jne    80153a <strcpy+0xd>
		/* do nothing */;
	return ret;
  801556:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801559:	c9                   	leave  
  80155a:	c3                   	ret    

0080155b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80155b:	55                   	push   %ebp
  80155c:	89 e5                	mov    %esp,%ebp
  80155e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801567:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80156e:	eb 1f                	jmp    80158f <strncpy+0x34>
		*dst++ = *src;
  801570:	8b 45 08             	mov    0x8(%ebp),%eax
  801573:	8d 50 01             	lea    0x1(%eax),%edx
  801576:	89 55 08             	mov    %edx,0x8(%ebp)
  801579:	8b 55 0c             	mov    0xc(%ebp),%edx
  80157c:	8a 12                	mov    (%edx),%dl
  80157e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801580:	8b 45 0c             	mov    0xc(%ebp),%eax
  801583:	8a 00                	mov    (%eax),%al
  801585:	84 c0                	test   %al,%al
  801587:	74 03                	je     80158c <strncpy+0x31>
			src++;
  801589:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80158c:	ff 45 fc             	incl   -0x4(%ebp)
  80158f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801592:	3b 45 10             	cmp    0x10(%ebp),%eax
  801595:	72 d9                	jb     801570 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801597:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80159a:	c9                   	leave  
  80159b:	c3                   	ret    

0080159c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80159c:	55                   	push   %ebp
  80159d:	89 e5                	mov    %esp,%ebp
  80159f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8015a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  8015a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015ac:	74 30                	je     8015de <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  8015ae:	eb 16                	jmp    8015c6 <strlcpy+0x2a>
			*dst++ = *src++;
  8015b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b3:	8d 50 01             	lea    0x1(%eax),%edx
  8015b6:	89 55 08             	mov    %edx,0x8(%ebp)
  8015b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015bc:	8d 4a 01             	lea    0x1(%edx),%ecx
  8015bf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8015c2:	8a 12                	mov    (%edx),%dl
  8015c4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8015c6:	ff 4d 10             	decl   0x10(%ebp)
  8015c9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015cd:	74 09                	je     8015d8 <strlcpy+0x3c>
  8015cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015d2:	8a 00                	mov    (%eax),%al
  8015d4:	84 c0                	test   %al,%al
  8015d6:	75 d8                	jne    8015b0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8015d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015db:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8015de:	8b 55 08             	mov    0x8(%ebp),%edx
  8015e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015e4:	29 c2                	sub    %eax,%edx
  8015e6:	89 d0                	mov    %edx,%eax
}
  8015e8:	c9                   	leave  
  8015e9:	c3                   	ret    

008015ea <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8015ea:	55                   	push   %ebp
  8015eb:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8015ed:	eb 06                	jmp    8015f5 <strcmp+0xb>
		p++, q++;
  8015ef:	ff 45 08             	incl   0x8(%ebp)
  8015f2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8015f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f8:	8a 00                	mov    (%eax),%al
  8015fa:	84 c0                	test   %al,%al
  8015fc:	74 0e                	je     80160c <strcmp+0x22>
  8015fe:	8b 45 08             	mov    0x8(%ebp),%eax
  801601:	8a 10                	mov    (%eax),%dl
  801603:	8b 45 0c             	mov    0xc(%ebp),%eax
  801606:	8a 00                	mov    (%eax),%al
  801608:	38 c2                	cmp    %al,%dl
  80160a:	74 e3                	je     8015ef <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  80160c:	8b 45 08             	mov    0x8(%ebp),%eax
  80160f:	8a 00                	mov    (%eax),%al
  801611:	0f b6 d0             	movzbl %al,%edx
  801614:	8b 45 0c             	mov    0xc(%ebp),%eax
  801617:	8a 00                	mov    (%eax),%al
  801619:	0f b6 c0             	movzbl %al,%eax
  80161c:	29 c2                	sub    %eax,%edx
  80161e:	89 d0                	mov    %edx,%eax
}
  801620:	5d                   	pop    %ebp
  801621:	c3                   	ret    

00801622 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801622:	55                   	push   %ebp
  801623:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801625:	eb 09                	jmp    801630 <strncmp+0xe>
		n--, p++, q++;
  801627:	ff 4d 10             	decl   0x10(%ebp)
  80162a:	ff 45 08             	incl   0x8(%ebp)
  80162d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801630:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801634:	74 17                	je     80164d <strncmp+0x2b>
  801636:	8b 45 08             	mov    0x8(%ebp),%eax
  801639:	8a 00                	mov    (%eax),%al
  80163b:	84 c0                	test   %al,%al
  80163d:	74 0e                	je     80164d <strncmp+0x2b>
  80163f:	8b 45 08             	mov    0x8(%ebp),%eax
  801642:	8a 10                	mov    (%eax),%dl
  801644:	8b 45 0c             	mov    0xc(%ebp),%eax
  801647:	8a 00                	mov    (%eax),%al
  801649:	38 c2                	cmp    %al,%dl
  80164b:	74 da                	je     801627 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80164d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801651:	75 07                	jne    80165a <strncmp+0x38>
		return 0;
  801653:	b8 00 00 00 00       	mov    $0x0,%eax
  801658:	eb 14                	jmp    80166e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80165a:	8b 45 08             	mov    0x8(%ebp),%eax
  80165d:	8a 00                	mov    (%eax),%al
  80165f:	0f b6 d0             	movzbl %al,%edx
  801662:	8b 45 0c             	mov    0xc(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	0f b6 c0             	movzbl %al,%eax
  80166a:	29 c2                	sub    %eax,%edx
  80166c:	89 d0                	mov    %edx,%eax
}
  80166e:	5d                   	pop    %ebp
  80166f:	c3                   	ret    

00801670 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801670:	55                   	push   %ebp
  801671:	89 e5                	mov    %esp,%ebp
  801673:	83 ec 04             	sub    $0x4,%esp
  801676:	8b 45 0c             	mov    0xc(%ebp),%eax
  801679:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80167c:	eb 12                	jmp    801690 <strchr+0x20>
		if (*s == c)
  80167e:	8b 45 08             	mov    0x8(%ebp),%eax
  801681:	8a 00                	mov    (%eax),%al
  801683:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801686:	75 05                	jne    80168d <strchr+0x1d>
			return (char *) s;
  801688:	8b 45 08             	mov    0x8(%ebp),%eax
  80168b:	eb 11                	jmp    80169e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80168d:	ff 45 08             	incl   0x8(%ebp)
  801690:	8b 45 08             	mov    0x8(%ebp),%eax
  801693:	8a 00                	mov    (%eax),%al
  801695:	84 c0                	test   %al,%al
  801697:	75 e5                	jne    80167e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801699:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80169e:	c9                   	leave  
  80169f:	c3                   	ret    

008016a0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8016a0:	55                   	push   %ebp
  8016a1:	89 e5                	mov    %esp,%ebp
  8016a3:	83 ec 04             	sub    $0x4,%esp
  8016a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016a9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8016ac:	eb 0d                	jmp    8016bb <strfind+0x1b>
		if (*s == c)
  8016ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b1:	8a 00                	mov    (%eax),%al
  8016b3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8016b6:	74 0e                	je     8016c6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8016b8:	ff 45 08             	incl   0x8(%ebp)
  8016bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8016be:	8a 00                	mov    (%eax),%al
  8016c0:	84 c0                	test   %al,%al
  8016c2:	75 ea                	jne    8016ae <strfind+0xe>
  8016c4:	eb 01                	jmp    8016c7 <strfind+0x27>
		if (*s == c)
			break;
  8016c6:	90                   	nop
	return (char *) s;
  8016c7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016ca:	c9                   	leave  
  8016cb:	c3                   	ret    

008016cc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8016cc:	55                   	push   %ebp
  8016cd:	89 e5                	mov    %esp,%ebp
  8016cf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8016d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8016d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8016db:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8016de:	eb 0e                	jmp    8016ee <memset+0x22>
		*p++ = c;
  8016e0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016e3:	8d 50 01             	lea    0x1(%eax),%edx
  8016e6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8016e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016ec:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8016ee:	ff 4d f8             	decl   -0x8(%ebp)
  8016f1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8016f5:	79 e9                	jns    8016e0 <memset+0x14>
		*p++ = c;

	return v;
  8016f7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016fa:	c9                   	leave  
  8016fb:	c3                   	ret    

008016fc <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8016fc:	55                   	push   %ebp
  8016fd:	89 e5                	mov    %esp,%ebp
  8016ff:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801702:	8b 45 0c             	mov    0xc(%ebp),%eax
  801705:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801708:	8b 45 08             	mov    0x8(%ebp),%eax
  80170b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80170e:	eb 16                	jmp    801726 <memcpy+0x2a>
		*d++ = *s++;
  801710:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801713:	8d 50 01             	lea    0x1(%eax),%edx
  801716:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801719:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80171c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80171f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801722:	8a 12                	mov    (%edx),%dl
  801724:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801726:	8b 45 10             	mov    0x10(%ebp),%eax
  801729:	8d 50 ff             	lea    -0x1(%eax),%edx
  80172c:	89 55 10             	mov    %edx,0x10(%ebp)
  80172f:	85 c0                	test   %eax,%eax
  801731:	75 dd                	jne    801710 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801733:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801736:	c9                   	leave  
  801737:	c3                   	ret    

00801738 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801738:	55                   	push   %ebp
  801739:	89 e5                	mov    %esp,%ebp
  80173b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80173e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801741:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801744:	8b 45 08             	mov    0x8(%ebp),%eax
  801747:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80174a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80174d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801750:	73 50                	jae    8017a2 <memmove+0x6a>
  801752:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801755:	8b 45 10             	mov    0x10(%ebp),%eax
  801758:	01 d0                	add    %edx,%eax
  80175a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80175d:	76 43                	jbe    8017a2 <memmove+0x6a>
		s += n;
  80175f:	8b 45 10             	mov    0x10(%ebp),%eax
  801762:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801765:	8b 45 10             	mov    0x10(%ebp),%eax
  801768:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80176b:	eb 10                	jmp    80177d <memmove+0x45>
			*--d = *--s;
  80176d:	ff 4d f8             	decl   -0x8(%ebp)
  801770:	ff 4d fc             	decl   -0x4(%ebp)
  801773:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801776:	8a 10                	mov    (%eax),%dl
  801778:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80177b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80177d:	8b 45 10             	mov    0x10(%ebp),%eax
  801780:	8d 50 ff             	lea    -0x1(%eax),%edx
  801783:	89 55 10             	mov    %edx,0x10(%ebp)
  801786:	85 c0                	test   %eax,%eax
  801788:	75 e3                	jne    80176d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80178a:	eb 23                	jmp    8017af <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80178c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80178f:	8d 50 01             	lea    0x1(%eax),%edx
  801792:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801795:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801798:	8d 4a 01             	lea    0x1(%edx),%ecx
  80179b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80179e:	8a 12                	mov    (%edx),%dl
  8017a0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8017a2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017a5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017a8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017ab:	85 c0                	test   %eax,%eax
  8017ad:	75 dd                	jne    80178c <memmove+0x54>
			*d++ = *s++;

	return dst;
  8017af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8017b2:	c9                   	leave  
  8017b3:	c3                   	ret    

008017b4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8017b4:	55                   	push   %ebp
  8017b5:	89 e5                	mov    %esp,%ebp
  8017b7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8017ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8017bd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8017c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8017c6:	eb 2a                	jmp    8017f2 <memcmp+0x3e>
		if (*s1 != *s2)
  8017c8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017cb:	8a 10                	mov    (%eax),%dl
  8017cd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017d0:	8a 00                	mov    (%eax),%al
  8017d2:	38 c2                	cmp    %al,%dl
  8017d4:	74 16                	je     8017ec <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8017d6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8017d9:	8a 00                	mov    (%eax),%al
  8017db:	0f b6 d0             	movzbl %al,%edx
  8017de:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017e1:	8a 00                	mov    (%eax),%al
  8017e3:	0f b6 c0             	movzbl %al,%eax
  8017e6:	29 c2                	sub    %eax,%edx
  8017e8:	89 d0                	mov    %edx,%eax
  8017ea:	eb 18                	jmp    801804 <memcmp+0x50>
		s1++, s2++;
  8017ec:	ff 45 fc             	incl   -0x4(%ebp)
  8017ef:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8017f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8017f8:	89 55 10             	mov    %edx,0x10(%ebp)
  8017fb:	85 c0                	test   %eax,%eax
  8017fd:	75 c9                	jne    8017c8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8017ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801804:	c9                   	leave  
  801805:	c3                   	ret    

00801806 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801806:	55                   	push   %ebp
  801807:	89 e5                	mov    %esp,%ebp
  801809:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80180c:	8b 55 08             	mov    0x8(%ebp),%edx
  80180f:	8b 45 10             	mov    0x10(%ebp),%eax
  801812:	01 d0                	add    %edx,%eax
  801814:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801817:	eb 15                	jmp    80182e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801819:	8b 45 08             	mov    0x8(%ebp),%eax
  80181c:	8a 00                	mov    (%eax),%al
  80181e:	0f b6 d0             	movzbl %al,%edx
  801821:	8b 45 0c             	mov    0xc(%ebp),%eax
  801824:	0f b6 c0             	movzbl %al,%eax
  801827:	39 c2                	cmp    %eax,%edx
  801829:	74 0d                	je     801838 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80182b:	ff 45 08             	incl   0x8(%ebp)
  80182e:	8b 45 08             	mov    0x8(%ebp),%eax
  801831:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801834:	72 e3                	jb     801819 <memfind+0x13>
  801836:	eb 01                	jmp    801839 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801838:	90                   	nop
	return (void *) s;
  801839:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80183c:	c9                   	leave  
  80183d:	c3                   	ret    

0080183e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80183e:	55                   	push   %ebp
  80183f:	89 e5                	mov    %esp,%ebp
  801841:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801844:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80184b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801852:	eb 03                	jmp    801857 <strtol+0x19>
		s++;
  801854:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801857:	8b 45 08             	mov    0x8(%ebp),%eax
  80185a:	8a 00                	mov    (%eax),%al
  80185c:	3c 20                	cmp    $0x20,%al
  80185e:	74 f4                	je     801854 <strtol+0x16>
  801860:	8b 45 08             	mov    0x8(%ebp),%eax
  801863:	8a 00                	mov    (%eax),%al
  801865:	3c 09                	cmp    $0x9,%al
  801867:	74 eb                	je     801854 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801869:	8b 45 08             	mov    0x8(%ebp),%eax
  80186c:	8a 00                	mov    (%eax),%al
  80186e:	3c 2b                	cmp    $0x2b,%al
  801870:	75 05                	jne    801877 <strtol+0x39>
		s++;
  801872:	ff 45 08             	incl   0x8(%ebp)
  801875:	eb 13                	jmp    80188a <strtol+0x4c>
	else if (*s == '-')
  801877:	8b 45 08             	mov    0x8(%ebp),%eax
  80187a:	8a 00                	mov    (%eax),%al
  80187c:	3c 2d                	cmp    $0x2d,%al
  80187e:	75 0a                	jne    80188a <strtol+0x4c>
		s++, neg = 1;
  801880:	ff 45 08             	incl   0x8(%ebp)
  801883:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80188a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80188e:	74 06                	je     801896 <strtol+0x58>
  801890:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801894:	75 20                	jne    8018b6 <strtol+0x78>
  801896:	8b 45 08             	mov    0x8(%ebp),%eax
  801899:	8a 00                	mov    (%eax),%al
  80189b:	3c 30                	cmp    $0x30,%al
  80189d:	75 17                	jne    8018b6 <strtol+0x78>
  80189f:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a2:	40                   	inc    %eax
  8018a3:	8a 00                	mov    (%eax),%al
  8018a5:	3c 78                	cmp    $0x78,%al
  8018a7:	75 0d                	jne    8018b6 <strtol+0x78>
		s += 2, base = 16;
  8018a9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8018ad:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8018b4:	eb 28                	jmp    8018de <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8018b6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018ba:	75 15                	jne    8018d1 <strtol+0x93>
  8018bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8018bf:	8a 00                	mov    (%eax),%al
  8018c1:	3c 30                	cmp    $0x30,%al
  8018c3:	75 0c                	jne    8018d1 <strtol+0x93>
		s++, base = 8;
  8018c5:	ff 45 08             	incl   0x8(%ebp)
  8018c8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8018cf:	eb 0d                	jmp    8018de <strtol+0xa0>
	else if (base == 0)
  8018d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8018d5:	75 07                	jne    8018de <strtol+0xa0>
		base = 10;
  8018d7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8018de:	8b 45 08             	mov    0x8(%ebp),%eax
  8018e1:	8a 00                	mov    (%eax),%al
  8018e3:	3c 2f                	cmp    $0x2f,%al
  8018e5:	7e 19                	jle    801900 <strtol+0xc2>
  8018e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ea:	8a 00                	mov    (%eax),%al
  8018ec:	3c 39                	cmp    $0x39,%al
  8018ee:	7f 10                	jg     801900 <strtol+0xc2>
			dig = *s - '0';
  8018f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018f3:	8a 00                	mov    (%eax),%al
  8018f5:	0f be c0             	movsbl %al,%eax
  8018f8:	83 e8 30             	sub    $0x30,%eax
  8018fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8018fe:	eb 42                	jmp    801942 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801900:	8b 45 08             	mov    0x8(%ebp),%eax
  801903:	8a 00                	mov    (%eax),%al
  801905:	3c 60                	cmp    $0x60,%al
  801907:	7e 19                	jle    801922 <strtol+0xe4>
  801909:	8b 45 08             	mov    0x8(%ebp),%eax
  80190c:	8a 00                	mov    (%eax),%al
  80190e:	3c 7a                	cmp    $0x7a,%al
  801910:	7f 10                	jg     801922 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801912:	8b 45 08             	mov    0x8(%ebp),%eax
  801915:	8a 00                	mov    (%eax),%al
  801917:	0f be c0             	movsbl %al,%eax
  80191a:	83 e8 57             	sub    $0x57,%eax
  80191d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801920:	eb 20                	jmp    801942 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801922:	8b 45 08             	mov    0x8(%ebp),%eax
  801925:	8a 00                	mov    (%eax),%al
  801927:	3c 40                	cmp    $0x40,%al
  801929:	7e 39                	jle    801964 <strtol+0x126>
  80192b:	8b 45 08             	mov    0x8(%ebp),%eax
  80192e:	8a 00                	mov    (%eax),%al
  801930:	3c 5a                	cmp    $0x5a,%al
  801932:	7f 30                	jg     801964 <strtol+0x126>
			dig = *s - 'A' + 10;
  801934:	8b 45 08             	mov    0x8(%ebp),%eax
  801937:	8a 00                	mov    (%eax),%al
  801939:	0f be c0             	movsbl %al,%eax
  80193c:	83 e8 37             	sub    $0x37,%eax
  80193f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801942:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801945:	3b 45 10             	cmp    0x10(%ebp),%eax
  801948:	7d 19                	jge    801963 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80194a:	ff 45 08             	incl   0x8(%ebp)
  80194d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801950:	0f af 45 10          	imul   0x10(%ebp),%eax
  801954:	89 c2                	mov    %eax,%edx
  801956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801959:	01 d0                	add    %edx,%eax
  80195b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80195e:	e9 7b ff ff ff       	jmp    8018de <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801963:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801964:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801968:	74 08                	je     801972 <strtol+0x134>
		*endptr = (char *) s;
  80196a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80196d:	8b 55 08             	mov    0x8(%ebp),%edx
  801970:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801972:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801976:	74 07                	je     80197f <strtol+0x141>
  801978:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80197b:	f7 d8                	neg    %eax
  80197d:	eb 03                	jmp    801982 <strtol+0x144>
  80197f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801982:	c9                   	leave  
  801983:	c3                   	ret    

00801984 <ltostr>:

void
ltostr(long value, char *str)
{
  801984:	55                   	push   %ebp
  801985:	89 e5                	mov    %esp,%ebp
  801987:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80198a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801991:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801998:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80199c:	79 13                	jns    8019b1 <ltostr+0x2d>
	{
		neg = 1;
  80199e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8019a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019a8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8019ab:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8019ae:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8019b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8019b9:	99                   	cltd   
  8019ba:	f7 f9                	idiv   %ecx
  8019bc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8019bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019c2:	8d 50 01             	lea    0x1(%eax),%edx
  8019c5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8019c8:	89 c2                	mov    %eax,%edx
  8019ca:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019cd:	01 d0                	add    %edx,%eax
  8019cf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8019d2:	83 c2 30             	add    $0x30,%edx
  8019d5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8019d7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019da:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019df:	f7 e9                	imul   %ecx
  8019e1:	c1 fa 02             	sar    $0x2,%edx
  8019e4:	89 c8                	mov    %ecx,%eax
  8019e6:	c1 f8 1f             	sar    $0x1f,%eax
  8019e9:	29 c2                	sub    %eax,%edx
  8019eb:	89 d0                	mov    %edx,%eax
  8019ed:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8019f0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8019f3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8019f8:	f7 e9                	imul   %ecx
  8019fa:	c1 fa 02             	sar    $0x2,%edx
  8019fd:	89 c8                	mov    %ecx,%eax
  8019ff:	c1 f8 1f             	sar    $0x1f,%eax
  801a02:	29 c2                	sub    %eax,%edx
  801a04:	89 d0                	mov    %edx,%eax
  801a06:	c1 e0 02             	shl    $0x2,%eax
  801a09:	01 d0                	add    %edx,%eax
  801a0b:	01 c0                	add    %eax,%eax
  801a0d:	29 c1                	sub    %eax,%ecx
  801a0f:	89 ca                	mov    %ecx,%edx
  801a11:	85 d2                	test   %edx,%edx
  801a13:	75 9c                	jne    8019b1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801a15:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801a1c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801a1f:	48                   	dec    %eax
  801a20:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801a23:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801a27:	74 3d                	je     801a66 <ltostr+0xe2>
		start = 1 ;
  801a29:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801a30:	eb 34                	jmp    801a66 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801a32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a35:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a38:	01 d0                	add    %edx,%eax
  801a3a:	8a 00                	mov    (%eax),%al
  801a3c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801a3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801a42:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a45:	01 c2                	add    %eax,%edx
  801a47:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801a4a:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a4d:	01 c8                	add    %ecx,%eax
  801a4f:	8a 00                	mov    (%eax),%al
  801a51:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801a53:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801a56:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a59:	01 c2                	add    %eax,%edx
  801a5b:	8a 45 eb             	mov    -0x15(%ebp),%al
  801a5e:	88 02                	mov    %al,(%edx)
		start++ ;
  801a60:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801a63:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801a66:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801a69:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801a6c:	7c c4                	jl     801a32 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801a6e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801a71:	8b 45 0c             	mov    0xc(%ebp),%eax
  801a74:	01 d0                	add    %edx,%eax
  801a76:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801a79:	90                   	nop
  801a7a:	c9                   	leave  
  801a7b:	c3                   	ret    

00801a7c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801a7c:	55                   	push   %ebp
  801a7d:	89 e5                	mov    %esp,%ebp
  801a7f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801a82:	ff 75 08             	pushl  0x8(%ebp)
  801a85:	e8 54 fa ff ff       	call   8014de <strlen>
  801a8a:	83 c4 04             	add    $0x4,%esp
  801a8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801a90:	ff 75 0c             	pushl  0xc(%ebp)
  801a93:	e8 46 fa ff ff       	call   8014de <strlen>
  801a98:	83 c4 04             	add    $0x4,%esp
  801a9b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801a9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801aa5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801aac:	eb 17                	jmp    801ac5 <strcconcat+0x49>
		final[s] = str1[s] ;
  801aae:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801ab1:	8b 45 10             	mov    0x10(%ebp),%eax
  801ab4:	01 c2                	add    %eax,%edx
  801ab6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801ab9:	8b 45 08             	mov    0x8(%ebp),%eax
  801abc:	01 c8                	add    %ecx,%eax
  801abe:	8a 00                	mov    (%eax),%al
  801ac0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801ac2:	ff 45 fc             	incl   -0x4(%ebp)
  801ac5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ac8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801acb:	7c e1                	jl     801aae <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801acd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801ad4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801adb:	eb 1f                	jmp    801afc <strcconcat+0x80>
		final[s++] = str2[i] ;
  801add:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801ae0:	8d 50 01             	lea    0x1(%eax),%edx
  801ae3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801ae6:	89 c2                	mov    %eax,%edx
  801ae8:	8b 45 10             	mov    0x10(%ebp),%eax
  801aeb:	01 c2                	add    %eax,%edx
  801aed:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801af0:	8b 45 0c             	mov    0xc(%ebp),%eax
  801af3:	01 c8                	add    %ecx,%eax
  801af5:	8a 00                	mov    (%eax),%al
  801af7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801af9:	ff 45 f8             	incl   -0x8(%ebp)
  801afc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801aff:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b02:	7c d9                	jl     801add <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801b04:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b07:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0a:	01 d0                	add    %edx,%eax
  801b0c:	c6 00 00             	movb   $0x0,(%eax)
}
  801b0f:	90                   	nop
  801b10:	c9                   	leave  
  801b11:	c3                   	ret    

00801b12 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801b12:	55                   	push   %ebp
  801b13:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801b15:	8b 45 14             	mov    0x14(%ebp),%eax
  801b18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801b1e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b21:	8b 00                	mov    (%eax),%eax
  801b23:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b2a:	8b 45 10             	mov    0x10(%ebp),%eax
  801b2d:	01 d0                	add    %edx,%eax
  801b2f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b35:	eb 0c                	jmp    801b43 <strsplit+0x31>
			*string++ = 0;
  801b37:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3a:	8d 50 01             	lea    0x1(%eax),%edx
  801b3d:	89 55 08             	mov    %edx,0x8(%ebp)
  801b40:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801b43:	8b 45 08             	mov    0x8(%ebp),%eax
  801b46:	8a 00                	mov    (%eax),%al
  801b48:	84 c0                	test   %al,%al
  801b4a:	74 18                	je     801b64 <strsplit+0x52>
  801b4c:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4f:	8a 00                	mov    (%eax),%al
  801b51:	0f be c0             	movsbl %al,%eax
  801b54:	50                   	push   %eax
  801b55:	ff 75 0c             	pushl  0xc(%ebp)
  801b58:	e8 13 fb ff ff       	call   801670 <strchr>
  801b5d:	83 c4 08             	add    $0x8,%esp
  801b60:	85 c0                	test   %eax,%eax
  801b62:	75 d3                	jne    801b37 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801b64:	8b 45 08             	mov    0x8(%ebp),%eax
  801b67:	8a 00                	mov    (%eax),%al
  801b69:	84 c0                	test   %al,%al
  801b6b:	74 5a                	je     801bc7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801b6d:	8b 45 14             	mov    0x14(%ebp),%eax
  801b70:	8b 00                	mov    (%eax),%eax
  801b72:	83 f8 0f             	cmp    $0xf,%eax
  801b75:	75 07                	jne    801b7e <strsplit+0x6c>
		{
			return 0;
  801b77:	b8 00 00 00 00       	mov    $0x0,%eax
  801b7c:	eb 66                	jmp    801be4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801b7e:	8b 45 14             	mov    0x14(%ebp),%eax
  801b81:	8b 00                	mov    (%eax),%eax
  801b83:	8d 48 01             	lea    0x1(%eax),%ecx
  801b86:	8b 55 14             	mov    0x14(%ebp),%edx
  801b89:	89 0a                	mov    %ecx,(%edx)
  801b8b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801b92:	8b 45 10             	mov    0x10(%ebp),%eax
  801b95:	01 c2                	add    %eax,%edx
  801b97:	8b 45 08             	mov    0x8(%ebp),%eax
  801b9a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801b9c:	eb 03                	jmp    801ba1 <strsplit+0x8f>
			string++;
  801b9e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801ba1:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba4:	8a 00                	mov    (%eax),%al
  801ba6:	84 c0                	test   %al,%al
  801ba8:	74 8b                	je     801b35 <strsplit+0x23>
  801baa:	8b 45 08             	mov    0x8(%ebp),%eax
  801bad:	8a 00                	mov    (%eax),%al
  801baf:	0f be c0             	movsbl %al,%eax
  801bb2:	50                   	push   %eax
  801bb3:	ff 75 0c             	pushl  0xc(%ebp)
  801bb6:	e8 b5 fa ff ff       	call   801670 <strchr>
  801bbb:	83 c4 08             	add    $0x8,%esp
  801bbe:	85 c0                	test   %eax,%eax
  801bc0:	74 dc                	je     801b9e <strsplit+0x8c>
			string++;
	}
  801bc2:	e9 6e ff ff ff       	jmp    801b35 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801bc7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801bc8:	8b 45 14             	mov    0x14(%ebp),%eax
  801bcb:	8b 00                	mov    (%eax),%eax
  801bcd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801bd4:	8b 45 10             	mov    0x10(%ebp),%eax
  801bd7:	01 d0                	add    %edx,%eax
  801bd9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801bdf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801be4:	c9                   	leave  
  801be5:	c3                   	ret    

00801be6 <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  801be6:	55                   	push   %ebp
  801be7:	89 e5                	mov    %esp,%ebp
  801be9:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801bec:	a1 04 50 80 00       	mov    0x805004,%eax
  801bf1:	85 c0                	test   %eax,%eax
  801bf3:	74 1f                	je     801c14 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801bf5:	e8 1d 00 00 00       	call   801c17 <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  801bfa:	83 ec 0c             	sub    $0xc,%esp
  801bfd:	68 c4 43 80 00       	push   $0x8043c4
  801c02:	e8 4f f0 ff ff       	call   800c56 <cprintf>
  801c07:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  801c0a:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801c11:	00 00 00 
	}
}
  801c14:	90                   	nop
  801c15:	c9                   	leave  
  801c16:	c3                   	ret    

00801c17 <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  801c17:	55                   	push   %ebp
  801c18:	89 e5                	mov    %esp,%ebp
  801c1a:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  801c1d:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  801c24:	00 00 00 
  801c27:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  801c2e:	00 00 00 
  801c31:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  801c38:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  801c3b:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  801c42:	00 00 00 
  801c45:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  801c4c:	00 00 00 
  801c4f:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  801c56:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  801c59:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  801c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801c63:	c1 e8 0c             	shr    $0xc,%eax
  801c66:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  801c6b:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  801c72:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c75:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801c7a:	2d 00 10 00 00       	sub    $0x1000,%eax
  801c7f:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801c84:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801c8b:	a1 20 51 80 00       	mov    0x805120,%eax
  801c90:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801c94:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801c97:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801c9e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801ca1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801ca4:	01 d0                	add    %edx,%eax
  801ca6:	48                   	dec    %eax
  801ca7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801caa:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cad:	ba 00 00 00 00       	mov    $0x0,%edx
  801cb2:	f7 75 e4             	divl   -0x1c(%ebp)
  801cb5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801cb8:	29 d0                	sub    %edx,%eax
  801cba:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801cbd:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801cc4:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801cc7:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801ccc:	2d 00 10 00 00       	sub    $0x1000,%eax
  801cd1:	83 ec 04             	sub    $0x4,%esp
  801cd4:	6a 07                	push   $0x7
  801cd6:	ff 75 e8             	pushl  -0x18(%ebp)
  801cd9:	50                   	push   %eax
  801cda:	e8 3d 06 00 00       	call   80231c <sys_allocate_chunk>
  801cdf:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801ce2:	a1 20 51 80 00       	mov    0x805120,%eax
  801ce7:	83 ec 0c             	sub    $0xc,%esp
  801cea:	50                   	push   %eax
  801ceb:	e8 b2 0c 00 00       	call   8029a2 <initialize_MemBlocksList>
  801cf0:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801cf3:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801cf8:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801cfb:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801cff:	0f 84 f3 00 00 00    	je     801df8 <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801d05:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801d09:	75 14                	jne    801d1f <initialize_dyn_block_system+0x108>
  801d0b:	83 ec 04             	sub    $0x4,%esp
  801d0e:	68 e9 43 80 00       	push   $0x8043e9
  801d13:	6a 36                	push   $0x36
  801d15:	68 07 44 80 00       	push   $0x804407
  801d1a:	e8 83 ec ff ff       	call   8009a2 <_panic>
  801d1f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d22:	8b 00                	mov    (%eax),%eax
  801d24:	85 c0                	test   %eax,%eax
  801d26:	74 10                	je     801d38 <initialize_dyn_block_system+0x121>
  801d28:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d2b:	8b 00                	mov    (%eax),%eax
  801d2d:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d30:	8b 52 04             	mov    0x4(%edx),%edx
  801d33:	89 50 04             	mov    %edx,0x4(%eax)
  801d36:	eb 0b                	jmp    801d43 <initialize_dyn_block_system+0x12c>
  801d38:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d3b:	8b 40 04             	mov    0x4(%eax),%eax
  801d3e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801d43:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d46:	8b 40 04             	mov    0x4(%eax),%eax
  801d49:	85 c0                	test   %eax,%eax
  801d4b:	74 0f                	je     801d5c <initialize_dyn_block_system+0x145>
  801d4d:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d50:	8b 40 04             	mov    0x4(%eax),%eax
  801d53:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801d56:	8b 12                	mov    (%edx),%edx
  801d58:	89 10                	mov    %edx,(%eax)
  801d5a:	eb 0a                	jmp    801d66 <initialize_dyn_block_system+0x14f>
  801d5c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d5f:	8b 00                	mov    (%eax),%eax
  801d61:	a3 48 51 80 00       	mov    %eax,0x805148
  801d66:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d69:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801d6f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d72:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801d79:	a1 54 51 80 00       	mov    0x805154,%eax
  801d7e:	48                   	dec    %eax
  801d7f:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801d84:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d87:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801d8e:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801d91:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801d98:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801d9c:	75 14                	jne    801db2 <initialize_dyn_block_system+0x19b>
  801d9e:	83 ec 04             	sub    $0x4,%esp
  801da1:	68 14 44 80 00       	push   $0x804414
  801da6:	6a 3e                	push   $0x3e
  801da8:	68 07 44 80 00       	push   $0x804407
  801dad:	e8 f0 eb ff ff       	call   8009a2 <_panic>
  801db2:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801db8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801dbb:	89 10                	mov    %edx,(%eax)
  801dbd:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801dc0:	8b 00                	mov    (%eax),%eax
  801dc2:	85 c0                	test   %eax,%eax
  801dc4:	74 0d                	je     801dd3 <initialize_dyn_block_system+0x1bc>
  801dc6:	a1 38 51 80 00       	mov    0x805138,%eax
  801dcb:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801dce:	89 50 04             	mov    %edx,0x4(%eax)
  801dd1:	eb 08                	jmp    801ddb <initialize_dyn_block_system+0x1c4>
  801dd3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801dd6:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801ddb:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801dde:	a3 38 51 80 00       	mov    %eax,0x805138
  801de3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801de6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ded:	a1 44 51 80 00       	mov    0x805144,%eax
  801df2:	40                   	inc    %eax
  801df3:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801df8:	90                   	nop
  801df9:	c9                   	leave  
  801dfa:	c3                   	ret    

00801dfb <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801dfb:	55                   	push   %ebp
  801dfc:	89 e5                	mov    %esp,%ebp
  801dfe:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801e01:	e8 e0 fd ff ff       	call   801be6 <InitializeUHeap>
		if (size == 0) return NULL ;
  801e06:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801e0a:	75 07                	jne    801e13 <malloc+0x18>
  801e0c:	b8 00 00 00 00       	mov    $0x0,%eax
  801e11:	eb 7f                	jmp    801e92 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801e13:	e8 d2 08 00 00       	call   8026ea <sys_isUHeapPlacementStrategyFIRSTFIT>
  801e18:	85 c0                	test   %eax,%eax
  801e1a:	74 71                	je     801e8d <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801e1c:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801e23:	8b 55 08             	mov    0x8(%ebp),%edx
  801e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801e29:	01 d0                	add    %edx,%eax
  801e2b:	48                   	dec    %eax
  801e2c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e32:	ba 00 00 00 00       	mov    $0x0,%edx
  801e37:	f7 75 f4             	divl   -0xc(%ebp)
  801e3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e3d:	29 d0                	sub    %edx,%eax
  801e3f:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801e42:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801e49:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801e50:	76 07                	jbe    801e59 <malloc+0x5e>
					return NULL ;
  801e52:	b8 00 00 00 00       	mov    $0x0,%eax
  801e57:	eb 39                	jmp    801e92 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801e59:	83 ec 0c             	sub    $0xc,%esp
  801e5c:	ff 75 08             	pushl  0x8(%ebp)
  801e5f:	e8 e6 0d 00 00       	call   802c4a <alloc_block_FF>
  801e64:	83 c4 10             	add    $0x10,%esp
  801e67:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801e6a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801e6e:	74 16                	je     801e86 <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801e70:	83 ec 0c             	sub    $0xc,%esp
  801e73:	ff 75 ec             	pushl  -0x14(%ebp)
  801e76:	e8 37 0c 00 00       	call   802ab2 <insert_sorted_allocList>
  801e7b:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801e7e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e81:	8b 40 08             	mov    0x8(%eax),%eax
  801e84:	eb 0c                	jmp    801e92 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801e86:	b8 00 00 00 00       	mov    $0x0,%eax
  801e8b:	eb 05                	jmp    801e92 <malloc+0x97>
				}
		}
	return 0;
  801e8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e92:	c9                   	leave  
  801e93:	c3                   	ret    

00801e94 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801e94:	55                   	push   %ebp
  801e95:	89 e5                	mov    %esp,%ebp
  801e97:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801e9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801e9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801ea0:	83 ec 08             	sub    $0x8,%esp
  801ea3:	ff 75 f4             	pushl  -0xc(%ebp)
  801ea6:	68 40 50 80 00       	push   $0x805040
  801eab:	e8 cf 0b 00 00       	call   802a7f <find_block>
  801eb0:	83 c4 10             	add    $0x10,%esp
  801eb3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801eb6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801eb9:	8b 40 0c             	mov    0xc(%eax),%eax
  801ebc:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801ebf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ec2:	8b 40 08             	mov    0x8(%eax),%eax
  801ec5:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801ec8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ecc:	0f 84 a1 00 00 00    	je     801f73 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801ed2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801ed6:	75 17                	jne    801eef <free+0x5b>
  801ed8:	83 ec 04             	sub    $0x4,%esp
  801edb:	68 e9 43 80 00       	push   $0x8043e9
  801ee0:	68 80 00 00 00       	push   $0x80
  801ee5:	68 07 44 80 00       	push   $0x804407
  801eea:	e8 b3 ea ff ff       	call   8009a2 <_panic>
  801eef:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ef2:	8b 00                	mov    (%eax),%eax
  801ef4:	85 c0                	test   %eax,%eax
  801ef6:	74 10                	je     801f08 <free+0x74>
  801ef8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801efb:	8b 00                	mov    (%eax),%eax
  801efd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f00:	8b 52 04             	mov    0x4(%edx),%edx
  801f03:	89 50 04             	mov    %edx,0x4(%eax)
  801f06:	eb 0b                	jmp    801f13 <free+0x7f>
  801f08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f0b:	8b 40 04             	mov    0x4(%eax),%eax
  801f0e:	a3 44 50 80 00       	mov    %eax,0x805044
  801f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f16:	8b 40 04             	mov    0x4(%eax),%eax
  801f19:	85 c0                	test   %eax,%eax
  801f1b:	74 0f                	je     801f2c <free+0x98>
  801f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f20:	8b 40 04             	mov    0x4(%eax),%eax
  801f23:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801f26:	8b 12                	mov    (%edx),%edx
  801f28:	89 10                	mov    %edx,(%eax)
  801f2a:	eb 0a                	jmp    801f36 <free+0xa2>
  801f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f2f:	8b 00                	mov    (%eax),%eax
  801f31:	a3 40 50 80 00       	mov    %eax,0x805040
  801f36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f39:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801f3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801f42:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801f49:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801f4e:	48                   	dec    %eax
  801f4f:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801f54:	83 ec 0c             	sub    $0xc,%esp
  801f57:	ff 75 f0             	pushl  -0x10(%ebp)
  801f5a:	e8 29 12 00 00       	call   803188 <insert_sorted_with_merge_freeList>
  801f5f:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801f62:	83 ec 08             	sub    $0x8,%esp
  801f65:	ff 75 ec             	pushl  -0x14(%ebp)
  801f68:	ff 75 e8             	pushl  -0x18(%ebp)
  801f6b:	e8 74 03 00 00       	call   8022e4 <sys_free_user_mem>
  801f70:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801f73:	90                   	nop
  801f74:	c9                   	leave  
  801f75:	c3                   	ret    

00801f76 <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801f76:	55                   	push   %ebp
  801f77:	89 e5                	mov    %esp,%ebp
  801f79:	83 ec 38             	sub    $0x38,%esp
  801f7c:	8b 45 10             	mov    0x10(%ebp),%eax
  801f7f:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801f82:	e8 5f fc ff ff       	call   801be6 <InitializeUHeap>
	if (size == 0) return NULL ;
  801f87:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801f8b:	75 0a                	jne    801f97 <smalloc+0x21>
  801f8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801f92:	e9 b2 00 00 00       	jmp    802049 <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801f97:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801f9e:	76 0a                	jbe    801faa <smalloc+0x34>
		return NULL;
  801fa0:	b8 00 00 00 00       	mov    $0x0,%eax
  801fa5:	e9 9f 00 00 00       	jmp    802049 <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801faa:	e8 3b 07 00 00       	call   8026ea <sys_isUHeapPlacementStrategyFIRSTFIT>
  801faf:	85 c0                	test   %eax,%eax
  801fb1:	0f 84 8d 00 00 00    	je     802044 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801fb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801fbe:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801fc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fc8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801fcb:	01 d0                	add    %edx,%eax
  801fcd:	48                   	dec    %eax
  801fce:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801fd1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fd4:	ba 00 00 00 00       	mov    $0x0,%edx
  801fd9:	f7 75 f0             	divl   -0x10(%ebp)
  801fdc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801fdf:	29 d0                	sub    %edx,%eax
  801fe1:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801fe4:	83 ec 0c             	sub    $0xc,%esp
  801fe7:	ff 75 e8             	pushl  -0x18(%ebp)
  801fea:	e8 5b 0c 00 00       	call   802c4a <alloc_block_FF>
  801fef:	83 c4 10             	add    $0x10,%esp
  801ff2:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801ff5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801ff9:	75 07                	jne    802002 <smalloc+0x8c>
			return NULL;
  801ffb:	b8 00 00 00 00       	mov    $0x0,%eax
  802000:	eb 47                	jmp    802049 <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  802002:	83 ec 0c             	sub    $0xc,%esp
  802005:	ff 75 f4             	pushl  -0xc(%ebp)
  802008:	e8 a5 0a 00 00       	call   802ab2 <insert_sorted_allocList>
  80200d:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  802010:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802013:	8b 40 08             	mov    0x8(%eax),%eax
  802016:	89 c2                	mov    %eax,%edx
  802018:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  80201c:	52                   	push   %edx
  80201d:	50                   	push   %eax
  80201e:	ff 75 0c             	pushl  0xc(%ebp)
  802021:	ff 75 08             	pushl  0x8(%ebp)
  802024:	e8 46 04 00 00       	call   80246f <sys_createSharedObject>
  802029:	83 c4 10             	add    $0x10,%esp
  80202c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  80202f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  802033:	78 08                	js     80203d <smalloc+0xc7>
		return (void *)b->sva;
  802035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802038:	8b 40 08             	mov    0x8(%eax),%eax
  80203b:	eb 0c                	jmp    802049 <smalloc+0xd3>
		}else{
		return NULL;
  80203d:	b8 00 00 00 00       	mov    $0x0,%eax
  802042:	eb 05                	jmp    802049 <smalloc+0xd3>
			}

	}return NULL;
  802044:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802049:	c9                   	leave  
  80204a:	c3                   	ret    

0080204b <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  80204b:	55                   	push   %ebp
  80204c:	89 e5                	mov    %esp,%ebp
  80204e:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  802051:	e8 90 fb ff ff       	call   801be6 <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  802056:	e8 8f 06 00 00       	call   8026ea <sys_isUHeapPlacementStrategyFIRSTFIT>
  80205b:	85 c0                	test   %eax,%eax
  80205d:	0f 84 ad 00 00 00    	je     802110 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  802063:	83 ec 08             	sub    $0x8,%esp
  802066:	ff 75 0c             	pushl  0xc(%ebp)
  802069:	ff 75 08             	pushl  0x8(%ebp)
  80206c:	e8 28 04 00 00       	call   802499 <sys_getSizeOfSharedObject>
  802071:	83 c4 10             	add    $0x10,%esp
  802074:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  802077:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80207b:	79 0a                	jns    802087 <sget+0x3c>
    {
    	return NULL;
  80207d:	b8 00 00 00 00       	mov    $0x0,%eax
  802082:	e9 8e 00 00 00       	jmp    802115 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  802087:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  80208e:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  802095:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802098:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80209b:	01 d0                	add    %edx,%eax
  80209d:	48                   	dec    %eax
  80209e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8020a1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020a4:	ba 00 00 00 00       	mov    $0x0,%edx
  8020a9:	f7 75 ec             	divl   -0x14(%ebp)
  8020ac:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8020af:	29 d0                	sub    %edx,%eax
  8020b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  8020b4:	83 ec 0c             	sub    $0xc,%esp
  8020b7:	ff 75 e4             	pushl  -0x1c(%ebp)
  8020ba:	e8 8b 0b 00 00       	call   802c4a <alloc_block_FF>
  8020bf:	83 c4 10             	add    $0x10,%esp
  8020c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  8020c5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8020c9:	75 07                	jne    8020d2 <sget+0x87>
				return NULL;
  8020cb:	b8 00 00 00 00       	mov    $0x0,%eax
  8020d0:	eb 43                	jmp    802115 <sget+0xca>
			}
			insert_sorted_allocList(b);
  8020d2:	83 ec 0c             	sub    $0xc,%esp
  8020d5:	ff 75 f0             	pushl  -0x10(%ebp)
  8020d8:	e8 d5 09 00 00       	call   802ab2 <insert_sorted_allocList>
  8020dd:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  8020e0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8020e3:	8b 40 08             	mov    0x8(%eax),%eax
  8020e6:	83 ec 04             	sub    $0x4,%esp
  8020e9:	50                   	push   %eax
  8020ea:	ff 75 0c             	pushl  0xc(%ebp)
  8020ed:	ff 75 08             	pushl  0x8(%ebp)
  8020f0:	e8 c1 03 00 00       	call   8024b6 <sys_getSharedObject>
  8020f5:	83 c4 10             	add    $0x10,%esp
  8020f8:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  8020fb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8020ff:	78 08                	js     802109 <sget+0xbe>
			return (void *)b->sva;
  802101:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802104:	8b 40 08             	mov    0x8(%eax),%eax
  802107:	eb 0c                	jmp    802115 <sget+0xca>
			}else{
			return NULL;
  802109:	b8 00 00 00 00       	mov    $0x0,%eax
  80210e:	eb 05                	jmp    802115 <sget+0xca>
			}
    }}return NULL;
  802110:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
  80211a:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  80211d:	e8 c4 fa ff ff       	call   801be6 <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  802122:	83 ec 04             	sub    $0x4,%esp
  802125:	68 38 44 80 00       	push   $0x804438
  80212a:	68 03 01 00 00       	push   $0x103
  80212f:	68 07 44 80 00       	push   $0x804407
  802134:	e8 69 e8 ff ff       	call   8009a2 <_panic>

00802139 <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  802139:	55                   	push   %ebp
  80213a:	89 e5                	mov    %esp,%ebp
  80213c:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  80213f:	83 ec 04             	sub    $0x4,%esp
  802142:	68 60 44 80 00       	push   $0x804460
  802147:	68 17 01 00 00       	push   $0x117
  80214c:	68 07 44 80 00       	push   $0x804407
  802151:	e8 4c e8 ff ff       	call   8009a2 <_panic>

00802156 <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  802156:	55                   	push   %ebp
  802157:	89 e5                	mov    %esp,%ebp
  802159:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  80215c:	83 ec 04             	sub    $0x4,%esp
  80215f:	68 84 44 80 00       	push   $0x804484
  802164:	68 22 01 00 00       	push   $0x122
  802169:	68 07 44 80 00       	push   $0x804407
  80216e:	e8 2f e8 ff ff       	call   8009a2 <_panic>

00802173 <shrink>:

}
void shrink(uint32 newSize)
{
  802173:	55                   	push   %ebp
  802174:	89 e5                	mov    %esp,%ebp
  802176:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802179:	83 ec 04             	sub    $0x4,%esp
  80217c:	68 84 44 80 00       	push   $0x804484
  802181:	68 27 01 00 00       	push   $0x127
  802186:	68 07 44 80 00       	push   $0x804407
  80218b:	e8 12 e8 ff ff       	call   8009a2 <_panic>

00802190 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  802190:	55                   	push   %ebp
  802191:	89 e5                	mov    %esp,%ebp
  802193:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  802196:	83 ec 04             	sub    $0x4,%esp
  802199:	68 84 44 80 00       	push   $0x804484
  80219e:	68 2c 01 00 00       	push   $0x12c
  8021a3:	68 07 44 80 00       	push   $0x804407
  8021a8:	e8 f5 e7 ff ff       	call   8009a2 <_panic>

008021ad <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8021ad:	55                   	push   %ebp
  8021ae:	89 e5                	mov    %esp,%ebp
  8021b0:	57                   	push   %edi
  8021b1:	56                   	push   %esi
  8021b2:	53                   	push   %ebx
  8021b3:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8021b6:	8b 45 08             	mov    0x8(%ebp),%eax
  8021b9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8021bf:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8021c2:	8b 7d 18             	mov    0x18(%ebp),%edi
  8021c5:	8b 75 1c             	mov    0x1c(%ebp),%esi
  8021c8:	cd 30                	int    $0x30
  8021ca:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  8021cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8021d0:	83 c4 10             	add    $0x10,%esp
  8021d3:	5b                   	pop    %ebx
  8021d4:	5e                   	pop    %esi
  8021d5:	5f                   	pop    %edi
  8021d6:	5d                   	pop    %ebp
  8021d7:	c3                   	ret    

008021d8 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  8021d8:	55                   	push   %ebp
  8021d9:	89 e5                	mov    %esp,%ebp
  8021db:	83 ec 04             	sub    $0x4,%esp
  8021de:	8b 45 10             	mov    0x10(%ebp),%eax
  8021e1:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  8021e4:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8021e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8021eb:	6a 00                	push   $0x0
  8021ed:	6a 00                	push   $0x0
  8021ef:	52                   	push   %edx
  8021f0:	ff 75 0c             	pushl  0xc(%ebp)
  8021f3:	50                   	push   %eax
  8021f4:	6a 00                	push   $0x0
  8021f6:	e8 b2 ff ff ff       	call   8021ad <syscall>
  8021fb:	83 c4 18             	add    $0x18,%esp
}
  8021fe:	90                   	nop
  8021ff:	c9                   	leave  
  802200:	c3                   	ret    

00802201 <sys_cgetc>:

int
sys_cgetc(void)
{
  802201:	55                   	push   %ebp
  802202:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  802204:	6a 00                	push   $0x0
  802206:	6a 00                	push   $0x0
  802208:	6a 00                	push   $0x0
  80220a:	6a 00                	push   $0x0
  80220c:	6a 00                	push   $0x0
  80220e:	6a 01                	push   $0x1
  802210:	e8 98 ff ff ff       	call   8021ad <syscall>
  802215:	83 c4 18             	add    $0x18,%esp
}
  802218:	c9                   	leave  
  802219:	c3                   	ret    

0080221a <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80221a:	55                   	push   %ebp
  80221b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  80221d:	8b 55 0c             	mov    0xc(%ebp),%edx
  802220:	8b 45 08             	mov    0x8(%ebp),%eax
  802223:	6a 00                	push   $0x0
  802225:	6a 00                	push   $0x0
  802227:	6a 00                	push   $0x0
  802229:	52                   	push   %edx
  80222a:	50                   	push   %eax
  80222b:	6a 05                	push   $0x5
  80222d:	e8 7b ff ff ff       	call   8021ad <syscall>
  802232:	83 c4 18             	add    $0x18,%esp
}
  802235:	c9                   	leave  
  802236:	c3                   	ret    

00802237 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  802237:	55                   	push   %ebp
  802238:	89 e5                	mov    %esp,%ebp
  80223a:	56                   	push   %esi
  80223b:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  80223c:	8b 75 18             	mov    0x18(%ebp),%esi
  80223f:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802242:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802245:	8b 55 0c             	mov    0xc(%ebp),%edx
  802248:	8b 45 08             	mov    0x8(%ebp),%eax
  80224b:	56                   	push   %esi
  80224c:	53                   	push   %ebx
  80224d:	51                   	push   %ecx
  80224e:	52                   	push   %edx
  80224f:	50                   	push   %eax
  802250:	6a 06                	push   $0x6
  802252:	e8 56 ff ff ff       	call   8021ad <syscall>
  802257:	83 c4 18             	add    $0x18,%esp
}
  80225a:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80225d:	5b                   	pop    %ebx
  80225e:	5e                   	pop    %esi
  80225f:	5d                   	pop    %ebp
  802260:	c3                   	ret    

00802261 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  802261:	55                   	push   %ebp
  802262:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  802264:	8b 55 0c             	mov    0xc(%ebp),%edx
  802267:	8b 45 08             	mov    0x8(%ebp),%eax
  80226a:	6a 00                	push   $0x0
  80226c:	6a 00                	push   $0x0
  80226e:	6a 00                	push   $0x0
  802270:	52                   	push   %edx
  802271:	50                   	push   %eax
  802272:	6a 07                	push   $0x7
  802274:	e8 34 ff ff ff       	call   8021ad <syscall>
  802279:	83 c4 18             	add    $0x18,%esp
}
  80227c:	c9                   	leave  
  80227d:	c3                   	ret    

0080227e <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80227e:	55                   	push   %ebp
  80227f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802281:	6a 00                	push   $0x0
  802283:	6a 00                	push   $0x0
  802285:	6a 00                	push   $0x0
  802287:	ff 75 0c             	pushl  0xc(%ebp)
  80228a:	ff 75 08             	pushl  0x8(%ebp)
  80228d:	6a 08                	push   $0x8
  80228f:	e8 19 ff ff ff       	call   8021ad <syscall>
  802294:	83 c4 18             	add    $0x18,%esp
}
  802297:	c9                   	leave  
  802298:	c3                   	ret    

00802299 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  802299:	55                   	push   %ebp
  80229a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80229c:	6a 00                	push   $0x0
  80229e:	6a 00                	push   $0x0
  8022a0:	6a 00                	push   $0x0
  8022a2:	6a 00                	push   $0x0
  8022a4:	6a 00                	push   $0x0
  8022a6:	6a 09                	push   $0x9
  8022a8:	e8 00 ff ff ff       	call   8021ad <syscall>
  8022ad:	83 c4 18             	add    $0x18,%esp
}
  8022b0:	c9                   	leave  
  8022b1:	c3                   	ret    

008022b2 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8022b2:	55                   	push   %ebp
  8022b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	6a 00                	push   $0x0
  8022bd:	6a 00                	push   $0x0
  8022bf:	6a 0a                	push   $0xa
  8022c1:	e8 e7 fe ff ff       	call   8021ad <syscall>
  8022c6:	83 c4 18             	add    $0x18,%esp
}
  8022c9:	c9                   	leave  
  8022ca:	c3                   	ret    

008022cb <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  8022cb:	55                   	push   %ebp
  8022cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  8022ce:	6a 00                	push   $0x0
  8022d0:	6a 00                	push   $0x0
  8022d2:	6a 00                	push   $0x0
  8022d4:	6a 00                	push   $0x0
  8022d6:	6a 00                	push   $0x0
  8022d8:	6a 0b                	push   $0xb
  8022da:	e8 ce fe ff ff       	call   8021ad <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	ff 75 0c             	pushl  0xc(%ebp)
  8022f0:	ff 75 08             	pushl  0x8(%ebp)
  8022f3:	6a 0f                	push   $0xf
  8022f5:	e8 b3 fe ff ff       	call   8021ad <syscall>
  8022fa:	83 c4 18             	add    $0x18,%esp
	return;
  8022fd:	90                   	nop
}
  8022fe:	c9                   	leave  
  8022ff:	c3                   	ret    

00802300 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802300:	55                   	push   %ebp
  802301:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802303:	6a 00                	push   $0x0
  802305:	6a 00                	push   $0x0
  802307:	6a 00                	push   $0x0
  802309:	ff 75 0c             	pushl  0xc(%ebp)
  80230c:	ff 75 08             	pushl  0x8(%ebp)
  80230f:	6a 10                	push   $0x10
  802311:	e8 97 fe ff ff       	call   8021ad <syscall>
  802316:	83 c4 18             	add    $0x18,%esp
	return ;
  802319:	90                   	nop
}
  80231a:	c9                   	leave  
  80231b:	c3                   	ret    

0080231c <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  80231c:	55                   	push   %ebp
  80231d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	ff 75 10             	pushl  0x10(%ebp)
  802326:	ff 75 0c             	pushl  0xc(%ebp)
  802329:	ff 75 08             	pushl  0x8(%ebp)
  80232c:	6a 11                	push   $0x11
  80232e:	e8 7a fe ff ff       	call   8021ad <syscall>
  802333:	83 c4 18             	add    $0x18,%esp
	return ;
  802336:	90                   	nop
}
  802337:	c9                   	leave  
  802338:	c3                   	ret    

00802339 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  802339:	55                   	push   %ebp
  80233a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  80233c:	6a 00                	push   $0x0
  80233e:	6a 00                	push   $0x0
  802340:	6a 00                	push   $0x0
  802342:	6a 00                	push   $0x0
  802344:	6a 00                	push   $0x0
  802346:	6a 0c                	push   $0xc
  802348:	e8 60 fe ff ff       	call   8021ad <syscall>
  80234d:	83 c4 18             	add    $0x18,%esp
}
  802350:	c9                   	leave  
  802351:	c3                   	ret    

00802352 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  802352:	55                   	push   %ebp
  802353:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  802355:	6a 00                	push   $0x0
  802357:	6a 00                	push   $0x0
  802359:	6a 00                	push   $0x0
  80235b:	6a 00                	push   $0x0
  80235d:	ff 75 08             	pushl  0x8(%ebp)
  802360:	6a 0d                	push   $0xd
  802362:	e8 46 fe ff ff       	call   8021ad <syscall>
  802367:	83 c4 18             	add    $0x18,%esp
}
  80236a:	c9                   	leave  
  80236b:	c3                   	ret    

0080236c <sys_scarce_memory>:

void sys_scarce_memory()
{
  80236c:	55                   	push   %ebp
  80236d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80236f:	6a 00                	push   $0x0
  802371:	6a 00                	push   $0x0
  802373:	6a 00                	push   $0x0
  802375:	6a 00                	push   $0x0
  802377:	6a 00                	push   $0x0
  802379:	6a 0e                	push   $0xe
  80237b:	e8 2d fe ff ff       	call   8021ad <syscall>
  802380:	83 c4 18             	add    $0x18,%esp
}
  802383:	90                   	nop
  802384:	c9                   	leave  
  802385:	c3                   	ret    

00802386 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  802386:	55                   	push   %ebp
  802387:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  802389:	6a 00                	push   $0x0
  80238b:	6a 00                	push   $0x0
  80238d:	6a 00                	push   $0x0
  80238f:	6a 00                	push   $0x0
  802391:	6a 00                	push   $0x0
  802393:	6a 13                	push   $0x13
  802395:	e8 13 fe ff ff       	call   8021ad <syscall>
  80239a:	83 c4 18             	add    $0x18,%esp
}
  80239d:	90                   	nop
  80239e:	c9                   	leave  
  80239f:	c3                   	ret    

008023a0 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8023a0:	55                   	push   %ebp
  8023a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 00                	push   $0x0
  8023ab:	6a 00                	push   $0x0
  8023ad:	6a 14                	push   $0x14
  8023af:	e8 f9 fd ff ff       	call   8021ad <syscall>
  8023b4:	83 c4 18             	add    $0x18,%esp
}
  8023b7:	90                   	nop
  8023b8:	c9                   	leave  
  8023b9:	c3                   	ret    

008023ba <sys_cputc>:


void
sys_cputc(const char c)
{
  8023ba:	55                   	push   %ebp
  8023bb:	89 e5                	mov    %esp,%ebp
  8023bd:	83 ec 04             	sub    $0x4,%esp
  8023c0:	8b 45 08             	mov    0x8(%ebp),%eax
  8023c3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  8023c6:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8023ca:	6a 00                	push   $0x0
  8023cc:	6a 00                	push   $0x0
  8023ce:	6a 00                	push   $0x0
  8023d0:	6a 00                	push   $0x0
  8023d2:	50                   	push   %eax
  8023d3:	6a 15                	push   $0x15
  8023d5:	e8 d3 fd ff ff       	call   8021ad <syscall>
  8023da:	83 c4 18             	add    $0x18,%esp
}
  8023dd:	90                   	nop
  8023de:	c9                   	leave  
  8023df:	c3                   	ret    

008023e0 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  8023e0:	55                   	push   %ebp
  8023e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  8023e3:	6a 00                	push   $0x0
  8023e5:	6a 00                	push   $0x0
  8023e7:	6a 00                	push   $0x0
  8023e9:	6a 00                	push   $0x0
  8023eb:	6a 00                	push   $0x0
  8023ed:	6a 16                	push   $0x16
  8023ef:	e8 b9 fd ff ff       	call   8021ad <syscall>
  8023f4:	83 c4 18             	add    $0x18,%esp
}
  8023f7:	90                   	nop
  8023f8:	c9                   	leave  
  8023f9:	c3                   	ret    

008023fa <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8023fa:	55                   	push   %ebp
  8023fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8023fd:	8b 45 08             	mov    0x8(%ebp),%eax
  802400:	6a 00                	push   $0x0
  802402:	6a 00                	push   $0x0
  802404:	6a 00                	push   $0x0
  802406:	ff 75 0c             	pushl  0xc(%ebp)
  802409:	50                   	push   %eax
  80240a:	6a 17                	push   $0x17
  80240c:	e8 9c fd ff ff       	call   8021ad <syscall>
  802411:	83 c4 18             	add    $0x18,%esp
}
  802414:	c9                   	leave  
  802415:	c3                   	ret    

00802416 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  802416:	55                   	push   %ebp
  802417:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802419:	8b 55 0c             	mov    0xc(%ebp),%edx
  80241c:	8b 45 08             	mov    0x8(%ebp),%eax
  80241f:	6a 00                	push   $0x0
  802421:	6a 00                	push   $0x0
  802423:	6a 00                	push   $0x0
  802425:	52                   	push   %edx
  802426:	50                   	push   %eax
  802427:	6a 1a                	push   $0x1a
  802429:	e8 7f fd ff ff       	call   8021ad <syscall>
  80242e:	83 c4 18             	add    $0x18,%esp
}
  802431:	c9                   	leave  
  802432:	c3                   	ret    

00802433 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802433:	55                   	push   %ebp
  802434:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802436:	8b 55 0c             	mov    0xc(%ebp),%edx
  802439:	8b 45 08             	mov    0x8(%ebp),%eax
  80243c:	6a 00                	push   $0x0
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	52                   	push   %edx
  802443:	50                   	push   %eax
  802444:	6a 18                	push   $0x18
  802446:	e8 62 fd ff ff       	call   8021ad <syscall>
  80244b:	83 c4 18             	add    $0x18,%esp
}
  80244e:	90                   	nop
  80244f:	c9                   	leave  
  802450:	c3                   	ret    

00802451 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  802451:	55                   	push   %ebp
  802452:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  802454:	8b 55 0c             	mov    0xc(%ebp),%edx
  802457:	8b 45 08             	mov    0x8(%ebp),%eax
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	52                   	push   %edx
  802461:	50                   	push   %eax
  802462:	6a 19                	push   $0x19
  802464:	e8 44 fd ff ff       	call   8021ad <syscall>
  802469:	83 c4 18             	add    $0x18,%esp
}
  80246c:	90                   	nop
  80246d:	c9                   	leave  
  80246e:	c3                   	ret    

0080246f <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80246f:	55                   	push   %ebp
  802470:	89 e5                	mov    %esp,%ebp
  802472:	83 ec 04             	sub    $0x4,%esp
  802475:	8b 45 10             	mov    0x10(%ebp),%eax
  802478:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80247b:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80247e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802482:	8b 45 08             	mov    0x8(%ebp),%eax
  802485:	6a 00                	push   $0x0
  802487:	51                   	push   %ecx
  802488:	52                   	push   %edx
  802489:	ff 75 0c             	pushl  0xc(%ebp)
  80248c:	50                   	push   %eax
  80248d:	6a 1b                	push   $0x1b
  80248f:	e8 19 fd ff ff       	call   8021ad <syscall>
  802494:	83 c4 18             	add    $0x18,%esp
}
  802497:	c9                   	leave  
  802498:	c3                   	ret    

00802499 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  802499:	55                   	push   %ebp
  80249a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80249c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80249f:	8b 45 08             	mov    0x8(%ebp),%eax
  8024a2:	6a 00                	push   $0x0
  8024a4:	6a 00                	push   $0x0
  8024a6:	6a 00                	push   $0x0
  8024a8:	52                   	push   %edx
  8024a9:	50                   	push   %eax
  8024aa:	6a 1c                	push   $0x1c
  8024ac:	e8 fc fc ff ff       	call   8021ad <syscall>
  8024b1:	83 c4 18             	add    $0x18,%esp
}
  8024b4:	c9                   	leave  
  8024b5:	c3                   	ret    

008024b6 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8024b6:	55                   	push   %ebp
  8024b7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8024b9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8024bc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8024c2:	6a 00                	push   $0x0
  8024c4:	6a 00                	push   $0x0
  8024c6:	51                   	push   %ecx
  8024c7:	52                   	push   %edx
  8024c8:	50                   	push   %eax
  8024c9:	6a 1d                	push   $0x1d
  8024cb:	e8 dd fc ff ff       	call   8021ad <syscall>
  8024d0:	83 c4 18             	add    $0x18,%esp
}
  8024d3:	c9                   	leave  
  8024d4:	c3                   	ret    

008024d5 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  8024d5:	55                   	push   %ebp
  8024d6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  8024d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8024db:	8b 45 08             	mov    0x8(%ebp),%eax
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 00                	push   $0x0
  8024e2:	6a 00                	push   $0x0
  8024e4:	52                   	push   %edx
  8024e5:	50                   	push   %eax
  8024e6:	6a 1e                	push   $0x1e
  8024e8:	e8 c0 fc ff ff       	call   8021ad <syscall>
  8024ed:	83 c4 18             	add    $0x18,%esp
}
  8024f0:	c9                   	leave  
  8024f1:	c3                   	ret    

008024f2 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8024f2:	55                   	push   %ebp
  8024f3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8024f5:	6a 00                	push   $0x0
  8024f7:	6a 00                	push   $0x0
  8024f9:	6a 00                	push   $0x0
  8024fb:	6a 00                	push   $0x0
  8024fd:	6a 00                	push   $0x0
  8024ff:	6a 1f                	push   $0x1f
  802501:	e8 a7 fc ff ff       	call   8021ad <syscall>
  802506:	83 c4 18             	add    $0x18,%esp
}
  802509:	c9                   	leave  
  80250a:	c3                   	ret    

0080250b <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80250b:	55                   	push   %ebp
  80250c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  80250e:	8b 45 08             	mov    0x8(%ebp),%eax
  802511:	6a 00                	push   $0x0
  802513:	ff 75 14             	pushl  0x14(%ebp)
  802516:	ff 75 10             	pushl  0x10(%ebp)
  802519:	ff 75 0c             	pushl  0xc(%ebp)
  80251c:	50                   	push   %eax
  80251d:	6a 20                	push   $0x20
  80251f:	e8 89 fc ff ff       	call   8021ad <syscall>
  802524:	83 c4 18             	add    $0x18,%esp
}
  802527:	c9                   	leave  
  802528:	c3                   	ret    

00802529 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  802529:	55                   	push   %ebp
  80252a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  80252c:	8b 45 08             	mov    0x8(%ebp),%eax
  80252f:	6a 00                	push   $0x0
  802531:	6a 00                	push   $0x0
  802533:	6a 00                	push   $0x0
  802535:	6a 00                	push   $0x0
  802537:	50                   	push   %eax
  802538:	6a 21                	push   $0x21
  80253a:	e8 6e fc ff ff       	call   8021ad <syscall>
  80253f:	83 c4 18             	add    $0x18,%esp
}
  802542:	90                   	nop
  802543:	c9                   	leave  
  802544:	c3                   	ret    

00802545 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  802545:	55                   	push   %ebp
  802546:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  802548:	8b 45 08             	mov    0x8(%ebp),%eax
  80254b:	6a 00                	push   $0x0
  80254d:	6a 00                	push   $0x0
  80254f:	6a 00                	push   $0x0
  802551:	6a 00                	push   $0x0
  802553:	50                   	push   %eax
  802554:	6a 22                	push   $0x22
  802556:	e8 52 fc ff ff       	call   8021ad <syscall>
  80255b:	83 c4 18             	add    $0x18,%esp
}
  80255e:	c9                   	leave  
  80255f:	c3                   	ret    

00802560 <sys_getenvid>:

int32 sys_getenvid(void)
{
  802560:	55                   	push   %ebp
  802561:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  802563:	6a 00                	push   $0x0
  802565:	6a 00                	push   $0x0
  802567:	6a 00                	push   $0x0
  802569:	6a 00                	push   $0x0
  80256b:	6a 00                	push   $0x0
  80256d:	6a 02                	push   $0x2
  80256f:	e8 39 fc ff ff       	call   8021ad <syscall>
  802574:	83 c4 18             	add    $0x18,%esp
}
  802577:	c9                   	leave  
  802578:	c3                   	ret    

00802579 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  802579:	55                   	push   %ebp
  80257a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80257c:	6a 00                	push   $0x0
  80257e:	6a 00                	push   $0x0
  802580:	6a 00                	push   $0x0
  802582:	6a 00                	push   $0x0
  802584:	6a 00                	push   $0x0
  802586:	6a 03                	push   $0x3
  802588:	e8 20 fc ff ff       	call   8021ad <syscall>
  80258d:	83 c4 18             	add    $0x18,%esp
}
  802590:	c9                   	leave  
  802591:	c3                   	ret    

00802592 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802592:	55                   	push   %ebp
  802593:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802595:	6a 00                	push   $0x0
  802597:	6a 00                	push   $0x0
  802599:	6a 00                	push   $0x0
  80259b:	6a 00                	push   $0x0
  80259d:	6a 00                	push   $0x0
  80259f:	6a 04                	push   $0x4
  8025a1:	e8 07 fc ff ff       	call   8021ad <syscall>
  8025a6:	83 c4 18             	add    $0x18,%esp
}
  8025a9:	c9                   	leave  
  8025aa:	c3                   	ret    

008025ab <sys_exit_env>:


void sys_exit_env(void)
{
  8025ab:	55                   	push   %ebp
  8025ac:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8025ae:	6a 00                	push   $0x0
  8025b0:	6a 00                	push   $0x0
  8025b2:	6a 00                	push   $0x0
  8025b4:	6a 00                	push   $0x0
  8025b6:	6a 00                	push   $0x0
  8025b8:	6a 23                	push   $0x23
  8025ba:	e8 ee fb ff ff       	call   8021ad <syscall>
  8025bf:	83 c4 18             	add    $0x18,%esp
}
  8025c2:	90                   	nop
  8025c3:	c9                   	leave  
  8025c4:	c3                   	ret    

008025c5 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  8025c5:	55                   	push   %ebp
  8025c6:	89 e5                	mov    %esp,%ebp
  8025c8:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  8025cb:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025ce:	8d 50 04             	lea    0x4(%eax),%edx
  8025d1:	8d 45 f8             	lea    -0x8(%ebp),%eax
  8025d4:	6a 00                	push   $0x0
  8025d6:	6a 00                	push   $0x0
  8025d8:	6a 00                	push   $0x0
  8025da:	52                   	push   %edx
  8025db:	50                   	push   %eax
  8025dc:	6a 24                	push   $0x24
  8025de:	e8 ca fb ff ff       	call   8021ad <syscall>
  8025e3:	83 c4 18             	add    $0x18,%esp
	return result;
  8025e6:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8025e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8025ec:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8025ef:	89 01                	mov    %eax,(%ecx)
  8025f1:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8025f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8025f7:	c9                   	leave  
  8025f8:	c2 04 00             	ret    $0x4

008025fb <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8025fb:	55                   	push   %ebp
  8025fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8025fe:	6a 00                	push   $0x0
  802600:	6a 00                	push   $0x0
  802602:	ff 75 10             	pushl  0x10(%ebp)
  802605:	ff 75 0c             	pushl  0xc(%ebp)
  802608:	ff 75 08             	pushl  0x8(%ebp)
  80260b:	6a 12                	push   $0x12
  80260d:	e8 9b fb ff ff       	call   8021ad <syscall>
  802612:	83 c4 18             	add    $0x18,%esp
	return ;
  802615:	90                   	nop
}
  802616:	c9                   	leave  
  802617:	c3                   	ret    

00802618 <sys_rcr2>:
uint32 sys_rcr2()
{
  802618:	55                   	push   %ebp
  802619:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80261b:	6a 00                	push   $0x0
  80261d:	6a 00                	push   $0x0
  80261f:	6a 00                	push   $0x0
  802621:	6a 00                	push   $0x0
  802623:	6a 00                	push   $0x0
  802625:	6a 25                	push   $0x25
  802627:	e8 81 fb ff ff       	call   8021ad <syscall>
  80262c:	83 c4 18             	add    $0x18,%esp
}
  80262f:	c9                   	leave  
  802630:	c3                   	ret    

00802631 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  802631:	55                   	push   %ebp
  802632:	89 e5                	mov    %esp,%ebp
  802634:	83 ec 04             	sub    $0x4,%esp
  802637:	8b 45 08             	mov    0x8(%ebp),%eax
  80263a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  80263d:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  802641:	6a 00                	push   $0x0
  802643:	6a 00                	push   $0x0
  802645:	6a 00                	push   $0x0
  802647:	6a 00                	push   $0x0
  802649:	50                   	push   %eax
  80264a:	6a 26                	push   $0x26
  80264c:	e8 5c fb ff ff       	call   8021ad <syscall>
  802651:	83 c4 18             	add    $0x18,%esp
	return ;
  802654:	90                   	nop
}
  802655:	c9                   	leave  
  802656:	c3                   	ret    

00802657 <rsttst>:
void rsttst()
{
  802657:	55                   	push   %ebp
  802658:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80265a:	6a 00                	push   $0x0
  80265c:	6a 00                	push   $0x0
  80265e:	6a 00                	push   $0x0
  802660:	6a 00                	push   $0x0
  802662:	6a 00                	push   $0x0
  802664:	6a 28                	push   $0x28
  802666:	e8 42 fb ff ff       	call   8021ad <syscall>
  80266b:	83 c4 18             	add    $0x18,%esp
	return ;
  80266e:	90                   	nop
}
  80266f:	c9                   	leave  
  802670:	c3                   	ret    

00802671 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  802671:	55                   	push   %ebp
  802672:	89 e5                	mov    %esp,%ebp
  802674:	83 ec 04             	sub    $0x4,%esp
  802677:	8b 45 14             	mov    0x14(%ebp),%eax
  80267a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  80267d:	8b 55 18             	mov    0x18(%ebp),%edx
  802680:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802684:	52                   	push   %edx
  802685:	50                   	push   %eax
  802686:	ff 75 10             	pushl  0x10(%ebp)
  802689:	ff 75 0c             	pushl  0xc(%ebp)
  80268c:	ff 75 08             	pushl  0x8(%ebp)
  80268f:	6a 27                	push   $0x27
  802691:	e8 17 fb ff ff       	call   8021ad <syscall>
  802696:	83 c4 18             	add    $0x18,%esp
	return ;
  802699:	90                   	nop
}
  80269a:	c9                   	leave  
  80269b:	c3                   	ret    

0080269c <chktst>:
void chktst(uint32 n)
{
  80269c:	55                   	push   %ebp
  80269d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  80269f:	6a 00                	push   $0x0
  8026a1:	6a 00                	push   $0x0
  8026a3:	6a 00                	push   $0x0
  8026a5:	6a 00                	push   $0x0
  8026a7:	ff 75 08             	pushl  0x8(%ebp)
  8026aa:	6a 29                	push   $0x29
  8026ac:	e8 fc fa ff ff       	call   8021ad <syscall>
  8026b1:	83 c4 18             	add    $0x18,%esp
	return ;
  8026b4:	90                   	nop
}
  8026b5:	c9                   	leave  
  8026b6:	c3                   	ret    

008026b7 <inctst>:

void inctst()
{
  8026b7:	55                   	push   %ebp
  8026b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8026ba:	6a 00                	push   $0x0
  8026bc:	6a 00                	push   $0x0
  8026be:	6a 00                	push   $0x0
  8026c0:	6a 00                	push   $0x0
  8026c2:	6a 00                	push   $0x0
  8026c4:	6a 2a                	push   $0x2a
  8026c6:	e8 e2 fa ff ff       	call   8021ad <syscall>
  8026cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8026ce:	90                   	nop
}
  8026cf:	c9                   	leave  
  8026d0:	c3                   	ret    

008026d1 <gettst>:
uint32 gettst()
{
  8026d1:	55                   	push   %ebp
  8026d2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  8026d4:	6a 00                	push   $0x0
  8026d6:	6a 00                	push   $0x0
  8026d8:	6a 00                	push   $0x0
  8026da:	6a 00                	push   $0x0
  8026dc:	6a 00                	push   $0x0
  8026de:	6a 2b                	push   $0x2b
  8026e0:	e8 c8 fa ff ff       	call   8021ad <syscall>
  8026e5:	83 c4 18             	add    $0x18,%esp
}
  8026e8:	c9                   	leave  
  8026e9:	c3                   	ret    

008026ea <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  8026ea:	55                   	push   %ebp
  8026eb:	89 e5                	mov    %esp,%ebp
  8026ed:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8026f0:	6a 00                	push   $0x0
  8026f2:	6a 00                	push   $0x0
  8026f4:	6a 00                	push   $0x0
  8026f6:	6a 00                	push   $0x0
  8026f8:	6a 00                	push   $0x0
  8026fa:	6a 2c                	push   $0x2c
  8026fc:	e8 ac fa ff ff       	call   8021ad <syscall>
  802701:	83 c4 18             	add    $0x18,%esp
  802704:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802707:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80270b:	75 07                	jne    802714 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  80270d:	b8 01 00 00 00       	mov    $0x1,%eax
  802712:	eb 05                	jmp    802719 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802714:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802719:	c9                   	leave  
  80271a:	c3                   	ret    

0080271b <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80271b:	55                   	push   %ebp
  80271c:	89 e5                	mov    %esp,%ebp
  80271e:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802721:	6a 00                	push   $0x0
  802723:	6a 00                	push   $0x0
  802725:	6a 00                	push   $0x0
  802727:	6a 00                	push   $0x0
  802729:	6a 00                	push   $0x0
  80272b:	6a 2c                	push   $0x2c
  80272d:	e8 7b fa ff ff       	call   8021ad <syscall>
  802732:	83 c4 18             	add    $0x18,%esp
  802735:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802738:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  80273c:	75 07                	jne    802745 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  80273e:	b8 01 00 00 00       	mov    $0x1,%eax
  802743:	eb 05                	jmp    80274a <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  802745:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80274a:	c9                   	leave  
  80274b:	c3                   	ret    

0080274c <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  80274c:	55                   	push   %ebp
  80274d:	89 e5                	mov    %esp,%ebp
  80274f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802752:	6a 00                	push   $0x0
  802754:	6a 00                	push   $0x0
  802756:	6a 00                	push   $0x0
  802758:	6a 00                	push   $0x0
  80275a:	6a 00                	push   $0x0
  80275c:	6a 2c                	push   $0x2c
  80275e:	e8 4a fa ff ff       	call   8021ad <syscall>
  802763:	83 c4 18             	add    $0x18,%esp
  802766:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802769:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  80276d:	75 07                	jne    802776 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  80276f:	b8 01 00 00 00       	mov    $0x1,%eax
  802774:	eb 05                	jmp    80277b <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  802776:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80277b:	c9                   	leave  
  80277c:	c3                   	ret    

0080277d <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  80277d:	55                   	push   %ebp
  80277e:	89 e5                	mov    %esp,%ebp
  802780:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802783:	6a 00                	push   $0x0
  802785:	6a 00                	push   $0x0
  802787:	6a 00                	push   $0x0
  802789:	6a 00                	push   $0x0
  80278b:	6a 00                	push   $0x0
  80278d:	6a 2c                	push   $0x2c
  80278f:	e8 19 fa ff ff       	call   8021ad <syscall>
  802794:	83 c4 18             	add    $0x18,%esp
  802797:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80279a:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  80279e:	75 07                	jne    8027a7 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8027a0:	b8 01 00 00 00       	mov    $0x1,%eax
  8027a5:	eb 05                	jmp    8027ac <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8027a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8027ac:	c9                   	leave  
  8027ad:	c3                   	ret    

008027ae <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8027ae:	55                   	push   %ebp
  8027af:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8027b1:	6a 00                	push   $0x0
  8027b3:	6a 00                	push   $0x0
  8027b5:	6a 00                	push   $0x0
  8027b7:	6a 00                	push   $0x0
  8027b9:	ff 75 08             	pushl  0x8(%ebp)
  8027bc:	6a 2d                	push   $0x2d
  8027be:	e8 ea f9 ff ff       	call   8021ad <syscall>
  8027c3:	83 c4 18             	add    $0x18,%esp
	return ;
  8027c6:	90                   	nop
}
  8027c7:	c9                   	leave  
  8027c8:	c3                   	ret    

008027c9 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8027c9:	55                   	push   %ebp
  8027ca:	89 e5                	mov    %esp,%ebp
  8027cc:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8027cd:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8027d0:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8027d3:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8027d9:	6a 00                	push   $0x0
  8027db:	53                   	push   %ebx
  8027dc:	51                   	push   %ecx
  8027dd:	52                   	push   %edx
  8027de:	50                   	push   %eax
  8027df:	6a 2e                	push   $0x2e
  8027e1:	e8 c7 f9 ff ff       	call   8021ad <syscall>
  8027e6:	83 c4 18             	add    $0x18,%esp
}
  8027e9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8027ec:	c9                   	leave  
  8027ed:	c3                   	ret    

008027ee <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  8027ee:	55                   	push   %ebp
  8027ef:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  8027f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8027f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8027f7:	6a 00                	push   $0x0
  8027f9:	6a 00                	push   $0x0
  8027fb:	6a 00                	push   $0x0
  8027fd:	52                   	push   %edx
  8027fe:	50                   	push   %eax
  8027ff:	6a 2f                	push   $0x2f
  802801:	e8 a7 f9 ff ff       	call   8021ad <syscall>
  802806:	83 c4 18             	add    $0x18,%esp
}
  802809:	c9                   	leave  
  80280a:	c3                   	ret    

0080280b <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80280b:	55                   	push   %ebp
  80280c:	89 e5                	mov    %esp,%ebp
  80280e:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802811:	83 ec 0c             	sub    $0xc,%esp
  802814:	68 94 44 80 00       	push   $0x804494
  802819:	e8 38 e4 ff ff       	call   800c56 <cprintf>
  80281e:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  802821:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  802828:	83 ec 0c             	sub    $0xc,%esp
  80282b:	68 c0 44 80 00       	push   $0x8044c0
  802830:	e8 21 e4 ff ff       	call   800c56 <cprintf>
  802835:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  802838:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  80283c:	a1 38 51 80 00       	mov    0x805138,%eax
  802841:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802844:	eb 56                	jmp    80289c <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802846:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80284a:	74 1c                	je     802868 <print_mem_block_lists+0x5d>
  80284c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80284f:	8b 50 08             	mov    0x8(%eax),%edx
  802852:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802855:	8b 48 08             	mov    0x8(%eax),%ecx
  802858:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80285b:	8b 40 0c             	mov    0xc(%eax),%eax
  80285e:	01 c8                	add    %ecx,%eax
  802860:	39 c2                	cmp    %eax,%edx
  802862:	73 04                	jae    802868 <print_mem_block_lists+0x5d>
			sorted = 0 ;
  802864:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  802868:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80286b:	8b 50 08             	mov    0x8(%eax),%edx
  80286e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802871:	8b 40 0c             	mov    0xc(%eax),%eax
  802874:	01 c2                	add    %eax,%edx
  802876:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802879:	8b 40 08             	mov    0x8(%eax),%eax
  80287c:	83 ec 04             	sub    $0x4,%esp
  80287f:	52                   	push   %edx
  802880:	50                   	push   %eax
  802881:	68 d5 44 80 00       	push   $0x8044d5
  802886:	e8 cb e3 ff ff       	call   800c56 <cprintf>
  80288b:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  80288e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802891:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802894:	a1 40 51 80 00       	mov    0x805140,%eax
  802899:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80289c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028a0:	74 07                	je     8028a9 <print_mem_block_lists+0x9e>
  8028a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8028a5:	8b 00                	mov    (%eax),%eax
  8028a7:	eb 05                	jmp    8028ae <print_mem_block_lists+0xa3>
  8028a9:	b8 00 00 00 00       	mov    $0x0,%eax
  8028ae:	a3 40 51 80 00       	mov    %eax,0x805140
  8028b3:	a1 40 51 80 00       	mov    0x805140,%eax
  8028b8:	85 c0                	test   %eax,%eax
  8028ba:	75 8a                	jne    802846 <print_mem_block_lists+0x3b>
  8028bc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8028c0:	75 84                	jne    802846 <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  8028c2:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  8028c6:	75 10                	jne    8028d8 <print_mem_block_lists+0xcd>
  8028c8:	83 ec 0c             	sub    $0xc,%esp
  8028cb:	68 e4 44 80 00       	push   $0x8044e4
  8028d0:	e8 81 e3 ff ff       	call   800c56 <cprintf>
  8028d5:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  8028d8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  8028df:	83 ec 0c             	sub    $0xc,%esp
  8028e2:	68 08 45 80 00       	push   $0x804508
  8028e7:	e8 6a e3 ff ff       	call   800c56 <cprintf>
  8028ec:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  8028ef:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8028f3:	a1 40 50 80 00       	mov    0x805040,%eax
  8028f8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8028fb:	eb 56                	jmp    802953 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8028fd:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802901:	74 1c                	je     80291f <print_mem_block_lists+0x114>
  802903:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802906:	8b 50 08             	mov    0x8(%eax),%edx
  802909:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80290c:	8b 48 08             	mov    0x8(%eax),%ecx
  80290f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802912:	8b 40 0c             	mov    0xc(%eax),%eax
  802915:	01 c8                	add    %ecx,%eax
  802917:	39 c2                	cmp    %eax,%edx
  802919:	73 04                	jae    80291f <print_mem_block_lists+0x114>
			sorted = 0 ;
  80291b:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  80291f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802922:	8b 50 08             	mov    0x8(%eax),%edx
  802925:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802928:	8b 40 0c             	mov    0xc(%eax),%eax
  80292b:	01 c2                	add    %eax,%edx
  80292d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802930:	8b 40 08             	mov    0x8(%eax),%eax
  802933:	83 ec 04             	sub    $0x4,%esp
  802936:	52                   	push   %edx
  802937:	50                   	push   %eax
  802938:	68 d5 44 80 00       	push   $0x8044d5
  80293d:	e8 14 e3 ff ff       	call   800c56 <cprintf>
  802942:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802945:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802948:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  80294b:	a1 48 50 80 00       	mov    0x805048,%eax
  802950:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802953:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802957:	74 07                	je     802960 <print_mem_block_lists+0x155>
  802959:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80295c:	8b 00                	mov    (%eax),%eax
  80295e:	eb 05                	jmp    802965 <print_mem_block_lists+0x15a>
  802960:	b8 00 00 00 00       	mov    $0x0,%eax
  802965:	a3 48 50 80 00       	mov    %eax,0x805048
  80296a:	a1 48 50 80 00       	mov    0x805048,%eax
  80296f:	85 c0                	test   %eax,%eax
  802971:	75 8a                	jne    8028fd <print_mem_block_lists+0xf2>
  802973:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802977:	75 84                	jne    8028fd <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  802979:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80297d:	75 10                	jne    80298f <print_mem_block_lists+0x184>
  80297f:	83 ec 0c             	sub    $0xc,%esp
  802982:	68 20 45 80 00       	push   $0x804520
  802987:	e8 ca e2 ff ff       	call   800c56 <cprintf>
  80298c:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  80298f:	83 ec 0c             	sub    $0xc,%esp
  802992:	68 94 44 80 00       	push   $0x804494
  802997:	e8 ba e2 ff ff       	call   800c56 <cprintf>
  80299c:	83 c4 10             	add    $0x10,%esp

}
  80299f:	90                   	nop
  8029a0:	c9                   	leave  
  8029a1:	c3                   	ret    

008029a2 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  8029a2:	55                   	push   %ebp
  8029a3:	89 e5                	mov    %esp,%ebp
  8029a5:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  8029a8:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  8029af:	00 00 00 
  8029b2:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  8029b9:	00 00 00 
  8029bc:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  8029c3:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8029c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8029cd:	e9 9e 00 00 00       	jmp    802a70 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  8029d2:	a1 50 50 80 00       	mov    0x805050,%eax
  8029d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029da:	c1 e2 04             	shl    $0x4,%edx
  8029dd:	01 d0                	add    %edx,%eax
  8029df:	85 c0                	test   %eax,%eax
  8029e1:	75 14                	jne    8029f7 <initialize_MemBlocksList+0x55>
  8029e3:	83 ec 04             	sub    $0x4,%esp
  8029e6:	68 48 45 80 00       	push   $0x804548
  8029eb:	6a 3d                	push   $0x3d
  8029ed:	68 6b 45 80 00       	push   $0x80456b
  8029f2:	e8 ab df ff ff       	call   8009a2 <_panic>
  8029f7:	a1 50 50 80 00       	mov    0x805050,%eax
  8029fc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8029ff:	c1 e2 04             	shl    $0x4,%edx
  802a02:	01 d0                	add    %edx,%eax
  802a04:	8b 15 48 51 80 00    	mov    0x805148,%edx
  802a0a:	89 10                	mov    %edx,(%eax)
  802a0c:	8b 00                	mov    (%eax),%eax
  802a0e:	85 c0                	test   %eax,%eax
  802a10:	74 18                	je     802a2a <initialize_MemBlocksList+0x88>
  802a12:	a1 48 51 80 00       	mov    0x805148,%eax
  802a17:	8b 15 50 50 80 00    	mov    0x805050,%edx
  802a1d:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  802a20:	c1 e1 04             	shl    $0x4,%ecx
  802a23:	01 ca                	add    %ecx,%edx
  802a25:	89 50 04             	mov    %edx,0x4(%eax)
  802a28:	eb 12                	jmp    802a3c <initialize_MemBlocksList+0x9a>
  802a2a:	a1 50 50 80 00       	mov    0x805050,%eax
  802a2f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a32:	c1 e2 04             	shl    $0x4,%edx
  802a35:	01 d0                	add    %edx,%eax
  802a37:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a3c:	a1 50 50 80 00       	mov    0x805050,%eax
  802a41:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a44:	c1 e2 04             	shl    $0x4,%edx
  802a47:	01 d0                	add    %edx,%eax
  802a49:	a3 48 51 80 00       	mov    %eax,0x805148
  802a4e:	a1 50 50 80 00       	mov    0x805050,%eax
  802a53:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802a56:	c1 e2 04             	shl    $0x4,%edx
  802a59:	01 d0                	add    %edx,%eax
  802a5b:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802a62:	a1 54 51 80 00       	mov    0x805154,%eax
  802a67:	40                   	inc    %eax
  802a68:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  802a6d:	ff 45 f4             	incl   -0xc(%ebp)
  802a70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a73:	3b 45 08             	cmp    0x8(%ebp),%eax
  802a76:	0f 82 56 ff ff ff    	jb     8029d2 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802a7c:	90                   	nop
  802a7d:	c9                   	leave  
  802a7e:	c3                   	ret    

00802a7f <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802a7f:	55                   	push   %ebp
  802a80:	89 e5                	mov    %esp,%ebp
  802a82:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802a85:	8b 45 08             	mov    0x8(%ebp),%eax
  802a88:	8b 00                	mov    (%eax),%eax
  802a8a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802a8d:	eb 18                	jmp    802aa7 <find_block+0x28>

		if(tmp->sva == va){
  802a8f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a92:	8b 40 08             	mov    0x8(%eax),%eax
  802a95:	3b 45 0c             	cmp    0xc(%ebp),%eax
  802a98:	75 05                	jne    802a9f <find_block+0x20>
			return tmp ;
  802a9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802a9d:	eb 11                	jmp    802ab0 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802a9f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802aa2:	8b 00                	mov    (%eax),%eax
  802aa4:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  802aa7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  802aab:	75 e2                	jne    802a8f <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802aad:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802ab0:	c9                   	leave  
  802ab1:	c3                   	ret    

00802ab2 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802ab2:	55                   	push   %ebp
  802ab3:	89 e5                	mov    %esp,%ebp
  802ab5:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  802ab8:	a1 40 50 80 00       	mov    0x805040,%eax
  802abd:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802ac0:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802ac5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  802ac8:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802acc:	75 65                	jne    802b33 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802ace:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802ad2:	75 14                	jne    802ae8 <insert_sorted_allocList+0x36>
  802ad4:	83 ec 04             	sub    $0x4,%esp
  802ad7:	68 48 45 80 00       	push   $0x804548
  802adc:	6a 62                	push   $0x62
  802ade:	68 6b 45 80 00       	push   $0x80456b
  802ae3:	e8 ba de ff ff       	call   8009a2 <_panic>
  802ae8:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802aee:	8b 45 08             	mov    0x8(%ebp),%eax
  802af1:	89 10                	mov    %edx,(%eax)
  802af3:	8b 45 08             	mov    0x8(%ebp),%eax
  802af6:	8b 00                	mov    (%eax),%eax
  802af8:	85 c0                	test   %eax,%eax
  802afa:	74 0d                	je     802b09 <insert_sorted_allocList+0x57>
  802afc:	a1 40 50 80 00       	mov    0x805040,%eax
  802b01:	8b 55 08             	mov    0x8(%ebp),%edx
  802b04:	89 50 04             	mov    %edx,0x4(%eax)
  802b07:	eb 08                	jmp    802b11 <insert_sorted_allocList+0x5f>
  802b09:	8b 45 08             	mov    0x8(%ebp),%eax
  802b0c:	a3 44 50 80 00       	mov    %eax,0x805044
  802b11:	8b 45 08             	mov    0x8(%ebp),%eax
  802b14:	a3 40 50 80 00       	mov    %eax,0x805040
  802b19:	8b 45 08             	mov    0x8(%ebp),%eax
  802b1c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b23:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b28:	40                   	inc    %eax
  802b29:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802b2e:	e9 14 01 00 00       	jmp    802c47 <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  802b33:	8b 45 08             	mov    0x8(%ebp),%eax
  802b36:	8b 50 08             	mov    0x8(%eax),%edx
  802b39:	a1 44 50 80 00       	mov    0x805044,%eax
  802b3e:	8b 40 08             	mov    0x8(%eax),%eax
  802b41:	39 c2                	cmp    %eax,%edx
  802b43:	76 65                	jbe    802baa <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  802b45:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802b49:	75 14                	jne    802b5f <insert_sorted_allocList+0xad>
  802b4b:	83 ec 04             	sub    $0x4,%esp
  802b4e:	68 84 45 80 00       	push   $0x804584
  802b53:	6a 64                	push   $0x64
  802b55:	68 6b 45 80 00       	push   $0x80456b
  802b5a:	e8 43 de ff ff       	call   8009a2 <_panic>
  802b5f:	8b 15 44 50 80 00    	mov    0x805044,%edx
  802b65:	8b 45 08             	mov    0x8(%ebp),%eax
  802b68:	89 50 04             	mov    %edx,0x4(%eax)
  802b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  802b6e:	8b 40 04             	mov    0x4(%eax),%eax
  802b71:	85 c0                	test   %eax,%eax
  802b73:	74 0c                	je     802b81 <insert_sorted_allocList+0xcf>
  802b75:	a1 44 50 80 00       	mov    0x805044,%eax
  802b7a:	8b 55 08             	mov    0x8(%ebp),%edx
  802b7d:	89 10                	mov    %edx,(%eax)
  802b7f:	eb 08                	jmp    802b89 <insert_sorted_allocList+0xd7>
  802b81:	8b 45 08             	mov    0x8(%ebp),%eax
  802b84:	a3 40 50 80 00       	mov    %eax,0x805040
  802b89:	8b 45 08             	mov    0x8(%ebp),%eax
  802b8c:	a3 44 50 80 00       	mov    %eax,0x805044
  802b91:	8b 45 08             	mov    0x8(%ebp),%eax
  802b94:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b9a:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802b9f:	40                   	inc    %eax
  802ba0:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802ba5:	e9 9d 00 00 00       	jmp    802c47 <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802baa:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802bb1:	e9 85 00 00 00       	jmp    802c3b <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  802bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  802bb9:	8b 50 08             	mov    0x8(%eax),%edx
  802bbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bbf:	8b 40 08             	mov    0x8(%eax),%eax
  802bc2:	39 c2                	cmp    %eax,%edx
  802bc4:	73 6a                	jae    802c30 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  802bc6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bca:	74 06                	je     802bd2 <insert_sorted_allocList+0x120>
  802bcc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802bd0:	75 14                	jne    802be6 <insert_sorted_allocList+0x134>
  802bd2:	83 ec 04             	sub    $0x4,%esp
  802bd5:	68 a8 45 80 00       	push   $0x8045a8
  802bda:	6a 6b                	push   $0x6b
  802bdc:	68 6b 45 80 00       	push   $0x80456b
  802be1:	e8 bc dd ff ff       	call   8009a2 <_panic>
  802be6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802be9:	8b 50 04             	mov    0x4(%eax),%edx
  802bec:	8b 45 08             	mov    0x8(%ebp),%eax
  802bef:	89 50 04             	mov    %edx,0x4(%eax)
  802bf2:	8b 45 08             	mov    0x8(%ebp),%eax
  802bf5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802bf8:	89 10                	mov    %edx,(%eax)
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 40 04             	mov    0x4(%eax),%eax
  802c00:	85 c0                	test   %eax,%eax
  802c02:	74 0d                	je     802c11 <insert_sorted_allocList+0x15f>
  802c04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c07:	8b 40 04             	mov    0x4(%eax),%eax
  802c0a:	8b 55 08             	mov    0x8(%ebp),%edx
  802c0d:	89 10                	mov    %edx,(%eax)
  802c0f:	eb 08                	jmp    802c19 <insert_sorted_allocList+0x167>
  802c11:	8b 45 08             	mov    0x8(%ebp),%eax
  802c14:	a3 40 50 80 00       	mov    %eax,0x805040
  802c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c1c:	8b 55 08             	mov    0x8(%ebp),%edx
  802c1f:	89 50 04             	mov    %edx,0x4(%eax)
  802c22:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802c27:	40                   	inc    %eax
  802c28:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  802c2d:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802c2e:	eb 17                	jmp    802c47 <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  802c30:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c33:	8b 00                	mov    (%eax),%eax
  802c35:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  802c38:	ff 45 f0             	incl   -0x10(%ebp)
  802c3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c3e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802c41:	0f 8c 6f ff ff ff    	jl     802bb6 <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802c47:	90                   	nop
  802c48:	c9                   	leave  
  802c49:	c3                   	ret    

00802c4a <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  802c4a:	55                   	push   %ebp
  802c4b:	89 e5                	mov    %esp,%ebp
  802c4d:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  802c50:	a1 38 51 80 00       	mov    0x805138,%eax
  802c55:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  802c58:	e9 7c 01 00 00       	jmp    802dd9 <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  802c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c60:	8b 40 0c             	mov    0xc(%eax),%eax
  802c63:	3b 45 08             	cmp    0x8(%ebp),%eax
  802c66:	0f 86 cf 00 00 00    	jbe    802d3b <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802c6c:	a1 48 51 80 00       	mov    0x805148,%eax
  802c71:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  802c74:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802c77:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  802c7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c7d:	8b 55 08             	mov    0x8(%ebp),%edx
  802c80:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802c83:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c86:	8b 50 08             	mov    0x8(%eax),%edx
  802c89:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802c8c:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802c8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c92:	8b 40 0c             	mov    0xc(%eax),%eax
  802c95:	2b 45 08             	sub    0x8(%ebp),%eax
  802c98:	89 c2                	mov    %eax,%edx
  802c9a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c9d:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802ca0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ca3:	8b 50 08             	mov    0x8(%eax),%edx
  802ca6:	8b 45 08             	mov    0x8(%ebp),%eax
  802ca9:	01 c2                	add    %eax,%edx
  802cab:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802cae:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802cb1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802cb5:	75 17                	jne    802cce <alloc_block_FF+0x84>
  802cb7:	83 ec 04             	sub    $0x4,%esp
  802cba:	68 dd 45 80 00       	push   $0x8045dd
  802cbf:	68 83 00 00 00       	push   $0x83
  802cc4:	68 6b 45 80 00       	push   $0x80456b
  802cc9:	e8 d4 dc ff ff       	call   8009a2 <_panic>
  802cce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cd1:	8b 00                	mov    (%eax),%eax
  802cd3:	85 c0                	test   %eax,%eax
  802cd5:	74 10                	je     802ce7 <alloc_block_FF+0x9d>
  802cd7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cda:	8b 00                	mov    (%eax),%eax
  802cdc:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802cdf:	8b 52 04             	mov    0x4(%edx),%edx
  802ce2:	89 50 04             	mov    %edx,0x4(%eax)
  802ce5:	eb 0b                	jmp    802cf2 <alloc_block_FF+0xa8>
  802ce7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cea:	8b 40 04             	mov    0x4(%eax),%eax
  802ced:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802cf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cf5:	8b 40 04             	mov    0x4(%eax),%eax
  802cf8:	85 c0                	test   %eax,%eax
  802cfa:	74 0f                	je     802d0b <alloc_block_FF+0xc1>
  802cfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802cff:	8b 40 04             	mov    0x4(%eax),%eax
  802d02:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802d05:	8b 12                	mov    (%edx),%edx
  802d07:	89 10                	mov    %edx,(%eax)
  802d09:	eb 0a                	jmp    802d15 <alloc_block_FF+0xcb>
  802d0b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d0e:	8b 00                	mov    (%eax),%eax
  802d10:	a3 48 51 80 00       	mov    %eax,0x805148
  802d15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d18:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d21:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d28:	a1 54 51 80 00       	mov    0x805154,%eax
  802d2d:	48                   	dec    %eax
  802d2e:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802d33:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d36:	e9 ad 00 00 00       	jmp    802de8 <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802d3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d3e:	8b 40 0c             	mov    0xc(%eax),%eax
  802d41:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d44:	0f 85 87 00 00 00    	jne    802dd1 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802d4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802d4e:	75 17                	jne    802d67 <alloc_block_FF+0x11d>
  802d50:	83 ec 04             	sub    $0x4,%esp
  802d53:	68 dd 45 80 00       	push   $0x8045dd
  802d58:	68 87 00 00 00       	push   $0x87
  802d5d:	68 6b 45 80 00       	push   $0x80456b
  802d62:	e8 3b dc ff ff       	call   8009a2 <_panic>
  802d67:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d6a:	8b 00                	mov    (%eax),%eax
  802d6c:	85 c0                	test   %eax,%eax
  802d6e:	74 10                	je     802d80 <alloc_block_FF+0x136>
  802d70:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d73:	8b 00                	mov    (%eax),%eax
  802d75:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d78:	8b 52 04             	mov    0x4(%edx),%edx
  802d7b:	89 50 04             	mov    %edx,0x4(%eax)
  802d7e:	eb 0b                	jmp    802d8b <alloc_block_FF+0x141>
  802d80:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d83:	8b 40 04             	mov    0x4(%eax),%eax
  802d86:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802d8b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d8e:	8b 40 04             	mov    0x4(%eax),%eax
  802d91:	85 c0                	test   %eax,%eax
  802d93:	74 0f                	je     802da4 <alloc_block_FF+0x15a>
  802d95:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d98:	8b 40 04             	mov    0x4(%eax),%eax
  802d9b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802d9e:	8b 12                	mov    (%edx),%edx
  802da0:	89 10                	mov    %edx,(%eax)
  802da2:	eb 0a                	jmp    802dae <alloc_block_FF+0x164>
  802da4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da7:	8b 00                	mov    (%eax),%eax
  802da9:	a3 38 51 80 00       	mov    %eax,0x805138
  802dae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802db7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dba:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802dc1:	a1 44 51 80 00       	mov    0x805144,%eax
  802dc6:	48                   	dec    %eax
  802dc7:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dcf:	eb 17                	jmp    802de8 <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd4:	8b 00                	mov    (%eax),%eax
  802dd6:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802dd9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ddd:	0f 85 7a fe ff ff    	jne    802c5d <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802de3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802de8:	c9                   	leave  
  802de9:	c3                   	ret    

00802dea <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802dea:	55                   	push   %ebp
  802deb:	89 e5                	mov    %esp,%ebp
  802ded:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802df0:	a1 38 51 80 00       	mov    0x805138,%eax
  802df5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802df8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802dff:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802e06:	a1 38 51 80 00       	mov    0x805138,%eax
  802e0b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802e0e:	e9 d0 00 00 00       	jmp    802ee3 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802e13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e16:	8b 40 0c             	mov    0xc(%eax),%eax
  802e19:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e1c:	0f 82 b8 00 00 00    	jb     802eda <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802e22:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e25:	8b 40 0c             	mov    0xc(%eax),%eax
  802e28:	2b 45 08             	sub    0x8(%ebp),%eax
  802e2b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802e2e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e31:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802e34:	0f 83 a1 00 00 00    	jae    802edb <alloc_block_BF+0xf1>
				differsize = differance ;
  802e3a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802e3d:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802e40:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e43:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802e46:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802e4a:	0f 85 8b 00 00 00    	jne    802edb <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802e50:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e54:	75 17                	jne    802e6d <alloc_block_BF+0x83>
  802e56:	83 ec 04             	sub    $0x4,%esp
  802e59:	68 dd 45 80 00       	push   $0x8045dd
  802e5e:	68 a0 00 00 00       	push   $0xa0
  802e63:	68 6b 45 80 00       	push   $0x80456b
  802e68:	e8 35 db ff ff       	call   8009a2 <_panic>
  802e6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e70:	8b 00                	mov    (%eax),%eax
  802e72:	85 c0                	test   %eax,%eax
  802e74:	74 10                	je     802e86 <alloc_block_BF+0x9c>
  802e76:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e79:	8b 00                	mov    (%eax),%eax
  802e7b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e7e:	8b 52 04             	mov    0x4(%edx),%edx
  802e81:	89 50 04             	mov    %edx,0x4(%eax)
  802e84:	eb 0b                	jmp    802e91 <alloc_block_BF+0xa7>
  802e86:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e89:	8b 40 04             	mov    0x4(%eax),%eax
  802e8c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802e91:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e94:	8b 40 04             	mov    0x4(%eax),%eax
  802e97:	85 c0                	test   %eax,%eax
  802e99:	74 0f                	je     802eaa <alloc_block_BF+0xc0>
  802e9b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e9e:	8b 40 04             	mov    0x4(%eax),%eax
  802ea1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ea4:	8b 12                	mov    (%edx),%edx
  802ea6:	89 10                	mov    %edx,(%eax)
  802ea8:	eb 0a                	jmp    802eb4 <alloc_block_BF+0xca>
  802eaa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ead:	8b 00                	mov    (%eax),%eax
  802eaf:	a3 38 51 80 00       	mov    %eax,0x805138
  802eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb7:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ebd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ec7:	a1 44 51 80 00       	mov    0x805144,%eax
  802ecc:	48                   	dec    %eax
  802ecd:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802ed2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed5:	e9 0c 01 00 00       	jmp    802fe6 <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802eda:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802edb:	a1 40 51 80 00       	mov    0x805140,%eax
  802ee0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802ee3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ee7:	74 07                	je     802ef0 <alloc_block_BF+0x106>
  802ee9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eec:	8b 00                	mov    (%eax),%eax
  802eee:	eb 05                	jmp    802ef5 <alloc_block_BF+0x10b>
  802ef0:	b8 00 00 00 00       	mov    $0x0,%eax
  802ef5:	a3 40 51 80 00       	mov    %eax,0x805140
  802efa:	a1 40 51 80 00       	mov    0x805140,%eax
  802eff:	85 c0                	test   %eax,%eax
  802f01:	0f 85 0c ff ff ff    	jne    802e13 <alloc_block_BF+0x29>
  802f07:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802f0b:	0f 85 02 ff ff ff    	jne    802e13 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802f11:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802f15:	0f 84 c6 00 00 00    	je     802fe1 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802f1b:	a1 48 51 80 00       	mov    0x805148,%eax
  802f20:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802f23:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f26:	8b 55 08             	mov    0x8(%ebp),%edx
  802f29:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802f2c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f2f:	8b 50 08             	mov    0x8(%eax),%edx
  802f32:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f35:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802f38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f3b:	8b 40 0c             	mov    0xc(%eax),%eax
  802f3e:	2b 45 08             	sub    0x8(%ebp),%eax
  802f41:	89 c2                	mov    %eax,%edx
  802f43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f46:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802f49:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f4c:	8b 50 08             	mov    0x8(%eax),%edx
  802f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  802f52:	01 c2                	add    %eax,%edx
  802f54:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f57:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802f5a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802f5e:	75 17                	jne    802f77 <alloc_block_BF+0x18d>
  802f60:	83 ec 04             	sub    $0x4,%esp
  802f63:	68 dd 45 80 00       	push   $0x8045dd
  802f68:	68 af 00 00 00       	push   $0xaf
  802f6d:	68 6b 45 80 00       	push   $0x80456b
  802f72:	e8 2b da ff ff       	call   8009a2 <_panic>
  802f77:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f7a:	8b 00                	mov    (%eax),%eax
  802f7c:	85 c0                	test   %eax,%eax
  802f7e:	74 10                	je     802f90 <alloc_block_BF+0x1a6>
  802f80:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f83:	8b 00                	mov    (%eax),%eax
  802f85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802f88:	8b 52 04             	mov    0x4(%edx),%edx
  802f8b:	89 50 04             	mov    %edx,0x4(%eax)
  802f8e:	eb 0b                	jmp    802f9b <alloc_block_BF+0x1b1>
  802f90:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f93:	8b 40 04             	mov    0x4(%eax),%eax
  802f96:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802f9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802f9e:	8b 40 04             	mov    0x4(%eax),%eax
  802fa1:	85 c0                	test   %eax,%eax
  802fa3:	74 0f                	je     802fb4 <alloc_block_BF+0x1ca>
  802fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fa8:	8b 40 04             	mov    0x4(%eax),%eax
  802fab:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802fae:	8b 12                	mov    (%edx),%edx
  802fb0:	89 10                	mov    %edx,(%eax)
  802fb2:	eb 0a                	jmp    802fbe <alloc_block_BF+0x1d4>
  802fb4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fb7:	8b 00                	mov    (%eax),%eax
  802fb9:	a3 48 51 80 00       	mov    %eax,0x805148
  802fbe:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fc1:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802fc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fca:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802fd1:	a1 54 51 80 00       	mov    0x805154,%eax
  802fd6:	48                   	dec    %eax
  802fd7:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802fdc:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802fdf:	eb 05                	jmp    802fe6 <alloc_block_BF+0x1fc>
	}

	return NULL;
  802fe1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802fe6:	c9                   	leave  
  802fe7:	c3                   	ret    

00802fe8 <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802fe8:	55                   	push   %ebp
  802fe9:	89 e5                	mov    %esp,%ebp
  802feb:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802fee:	a1 38 51 80 00       	mov    0x805138,%eax
  802ff3:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802ff6:	e9 7c 01 00 00       	jmp    803177 <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802ffb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ffe:	8b 40 0c             	mov    0xc(%eax),%eax
  803001:	3b 45 08             	cmp    0x8(%ebp),%eax
  803004:	0f 86 cf 00 00 00    	jbe    8030d9 <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  80300a:	a1 48 51 80 00       	mov    0x805148,%eax
  80300f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  803012:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803015:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  803018:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80301b:	8b 55 08             	mov    0x8(%ebp),%edx
  80301e:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  803021:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803024:	8b 50 08             	mov    0x8(%eax),%edx
  803027:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80302a:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  80302d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803030:	8b 40 0c             	mov    0xc(%eax),%eax
  803033:	2b 45 08             	sub    0x8(%ebp),%eax
  803036:	89 c2                	mov    %eax,%edx
  803038:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80303b:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  80303e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803041:	8b 50 08             	mov    0x8(%eax),%edx
  803044:	8b 45 08             	mov    0x8(%ebp),%eax
  803047:	01 c2                	add    %eax,%edx
  803049:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80304c:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  80304f:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803053:	75 17                	jne    80306c <alloc_block_NF+0x84>
  803055:	83 ec 04             	sub    $0x4,%esp
  803058:	68 dd 45 80 00       	push   $0x8045dd
  80305d:	68 c4 00 00 00       	push   $0xc4
  803062:	68 6b 45 80 00       	push   $0x80456b
  803067:	e8 36 d9 ff ff       	call   8009a2 <_panic>
  80306c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80306f:	8b 00                	mov    (%eax),%eax
  803071:	85 c0                	test   %eax,%eax
  803073:	74 10                	je     803085 <alloc_block_NF+0x9d>
  803075:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803078:	8b 00                	mov    (%eax),%eax
  80307a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80307d:	8b 52 04             	mov    0x4(%edx),%edx
  803080:	89 50 04             	mov    %edx,0x4(%eax)
  803083:	eb 0b                	jmp    803090 <alloc_block_NF+0xa8>
  803085:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803088:	8b 40 04             	mov    0x4(%eax),%eax
  80308b:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803090:	8b 45 ec             	mov    -0x14(%ebp),%eax
  803093:	8b 40 04             	mov    0x4(%eax),%eax
  803096:	85 c0                	test   %eax,%eax
  803098:	74 0f                	je     8030a9 <alloc_block_NF+0xc1>
  80309a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80309d:	8b 40 04             	mov    0x4(%eax),%eax
  8030a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8030a3:	8b 12                	mov    (%edx),%edx
  8030a5:	89 10                	mov    %edx,(%eax)
  8030a7:	eb 0a                	jmp    8030b3 <alloc_block_NF+0xcb>
  8030a9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030ac:	8b 00                	mov    (%eax),%eax
  8030ae:	a3 48 51 80 00       	mov    %eax,0x805148
  8030b3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030b6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8030bc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030bf:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030c6:	a1 54 51 80 00       	mov    0x805154,%eax
  8030cb:	48                   	dec    %eax
  8030cc:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  8030d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8030d4:	e9 ad 00 00 00       	jmp    803186 <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  8030d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030dc:	8b 40 0c             	mov    0xc(%eax),%eax
  8030df:	3b 45 08             	cmp    0x8(%ebp),%eax
  8030e2:	0f 85 87 00 00 00    	jne    80316f <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  8030e8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8030ec:	75 17                	jne    803105 <alloc_block_NF+0x11d>
  8030ee:	83 ec 04             	sub    $0x4,%esp
  8030f1:	68 dd 45 80 00       	push   $0x8045dd
  8030f6:	68 c8 00 00 00       	push   $0xc8
  8030fb:	68 6b 45 80 00       	push   $0x80456b
  803100:	e8 9d d8 ff ff       	call   8009a2 <_panic>
  803105:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803108:	8b 00                	mov    (%eax),%eax
  80310a:	85 c0                	test   %eax,%eax
  80310c:	74 10                	je     80311e <alloc_block_NF+0x136>
  80310e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803111:	8b 00                	mov    (%eax),%eax
  803113:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803116:	8b 52 04             	mov    0x4(%edx),%edx
  803119:	89 50 04             	mov    %edx,0x4(%eax)
  80311c:	eb 0b                	jmp    803129 <alloc_block_NF+0x141>
  80311e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803121:	8b 40 04             	mov    0x4(%eax),%eax
  803124:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803129:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80312c:	8b 40 04             	mov    0x4(%eax),%eax
  80312f:	85 c0                	test   %eax,%eax
  803131:	74 0f                	je     803142 <alloc_block_NF+0x15a>
  803133:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803136:	8b 40 04             	mov    0x4(%eax),%eax
  803139:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80313c:	8b 12                	mov    (%edx),%edx
  80313e:	89 10                	mov    %edx,(%eax)
  803140:	eb 0a                	jmp    80314c <alloc_block_NF+0x164>
  803142:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803145:	8b 00                	mov    (%eax),%eax
  803147:	a3 38 51 80 00       	mov    %eax,0x805138
  80314c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803155:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803158:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80315f:	a1 44 51 80 00       	mov    0x805144,%eax
  803164:	48                   	dec    %eax
  803165:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  80316a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80316d:	eb 17                	jmp    803186 <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  80316f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803172:	8b 00                	mov    (%eax),%eax
  803174:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  803177:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80317b:	0f 85 7a fe ff ff    	jne    802ffb <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  803181:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  803186:	c9                   	leave  
  803187:	c3                   	ret    

00803188 <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  803188:	55                   	push   %ebp
  803189:	89 e5                	mov    %esp,%ebp
  80318b:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  80318e:	a1 38 51 80 00       	mov    0x805138,%eax
  803193:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  803196:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80319b:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  80319e:	a1 44 51 80 00       	mov    0x805144,%eax
  8031a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  8031a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8031aa:	75 68                	jne    803214 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8031ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031b0:	75 17                	jne    8031c9 <insert_sorted_with_merge_freeList+0x41>
  8031b2:	83 ec 04             	sub    $0x4,%esp
  8031b5:	68 48 45 80 00       	push   $0x804548
  8031ba:	68 da 00 00 00       	push   $0xda
  8031bf:	68 6b 45 80 00       	push   $0x80456b
  8031c4:	e8 d9 d7 ff ff       	call   8009a2 <_panic>
  8031c9:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8031cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d2:	89 10                	mov    %edx,(%eax)
  8031d4:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d7:	8b 00                	mov    (%eax),%eax
  8031d9:	85 c0                	test   %eax,%eax
  8031db:	74 0d                	je     8031ea <insert_sorted_with_merge_freeList+0x62>
  8031dd:	a1 38 51 80 00       	mov    0x805138,%eax
  8031e2:	8b 55 08             	mov    0x8(%ebp),%edx
  8031e5:	89 50 04             	mov    %edx,0x4(%eax)
  8031e8:	eb 08                	jmp    8031f2 <insert_sorted_with_merge_freeList+0x6a>
  8031ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8031ed:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8031f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031f5:	a3 38 51 80 00       	mov    %eax,0x805138
  8031fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8031fd:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803204:	a1 44 51 80 00       	mov    0x805144,%eax
  803209:	40                   	inc    %eax
  80320a:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  80320f:	e9 49 07 00 00       	jmp    80395d <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  803214:	8b 45 f0             	mov    -0x10(%ebp),%eax
  803217:	8b 50 08             	mov    0x8(%eax),%edx
  80321a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80321d:	8b 40 0c             	mov    0xc(%eax),%eax
  803220:	01 c2                	add    %eax,%edx
  803222:	8b 45 08             	mov    0x8(%ebp),%eax
  803225:	8b 40 08             	mov    0x8(%eax),%eax
  803228:	39 c2                	cmp    %eax,%edx
  80322a:	73 77                	jae    8032a3 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  80322c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80322f:	8b 00                	mov    (%eax),%eax
  803231:	85 c0                	test   %eax,%eax
  803233:	75 6e                	jne    8032a3 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  803235:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  803239:	74 68                	je     8032a3 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  80323b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80323f:	75 17                	jne    803258 <insert_sorted_with_merge_freeList+0xd0>
  803241:	83 ec 04             	sub    $0x4,%esp
  803244:	68 84 45 80 00       	push   $0x804584
  803249:	68 e0 00 00 00       	push   $0xe0
  80324e:	68 6b 45 80 00       	push   $0x80456b
  803253:	e8 4a d7 ff ff       	call   8009a2 <_panic>
  803258:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  80325e:	8b 45 08             	mov    0x8(%ebp),%eax
  803261:	89 50 04             	mov    %edx,0x4(%eax)
  803264:	8b 45 08             	mov    0x8(%ebp),%eax
  803267:	8b 40 04             	mov    0x4(%eax),%eax
  80326a:	85 c0                	test   %eax,%eax
  80326c:	74 0c                	je     80327a <insert_sorted_with_merge_freeList+0xf2>
  80326e:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803273:	8b 55 08             	mov    0x8(%ebp),%edx
  803276:	89 10                	mov    %edx,(%eax)
  803278:	eb 08                	jmp    803282 <insert_sorted_with_merge_freeList+0xfa>
  80327a:	8b 45 08             	mov    0x8(%ebp),%eax
  80327d:	a3 38 51 80 00       	mov    %eax,0x805138
  803282:	8b 45 08             	mov    0x8(%ebp),%eax
  803285:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80328a:	8b 45 08             	mov    0x8(%ebp),%eax
  80328d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803293:	a1 44 51 80 00       	mov    0x805144,%eax
  803298:	40                   	inc    %eax
  803299:	a3 44 51 80 00       	mov    %eax,0x805144
  80329e:	e9 ba 06 00 00       	jmp    80395d <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  8032a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a6:	8b 50 0c             	mov    0xc(%eax),%edx
  8032a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8032ac:	8b 40 08             	mov    0x8(%eax),%eax
  8032af:	01 c2                	add    %eax,%edx
  8032b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032b4:	8b 40 08             	mov    0x8(%eax),%eax
  8032b7:	39 c2                	cmp    %eax,%edx
  8032b9:	73 78                	jae    803333 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  8032bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8032be:	8b 40 04             	mov    0x4(%eax),%eax
  8032c1:	85 c0                	test   %eax,%eax
  8032c3:	75 6e                	jne    803333 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  8032c5:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8032c9:	74 68                	je     803333 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  8032cb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032cf:	75 17                	jne    8032e8 <insert_sorted_with_merge_freeList+0x160>
  8032d1:	83 ec 04             	sub    $0x4,%esp
  8032d4:	68 48 45 80 00       	push   $0x804548
  8032d9:	68 e6 00 00 00       	push   $0xe6
  8032de:	68 6b 45 80 00       	push   $0x80456b
  8032e3:	e8 ba d6 ff ff       	call   8009a2 <_panic>
  8032e8:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	89 10                	mov    %edx,(%eax)
  8032f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f6:	8b 00                	mov    (%eax),%eax
  8032f8:	85 c0                	test   %eax,%eax
  8032fa:	74 0d                	je     803309 <insert_sorted_with_merge_freeList+0x181>
  8032fc:	a1 38 51 80 00       	mov    0x805138,%eax
  803301:	8b 55 08             	mov    0x8(%ebp),%edx
  803304:	89 50 04             	mov    %edx,0x4(%eax)
  803307:	eb 08                	jmp    803311 <insert_sorted_with_merge_freeList+0x189>
  803309:	8b 45 08             	mov    0x8(%ebp),%eax
  80330c:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803311:	8b 45 08             	mov    0x8(%ebp),%eax
  803314:	a3 38 51 80 00       	mov    %eax,0x805138
  803319:	8b 45 08             	mov    0x8(%ebp),%eax
  80331c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803323:	a1 44 51 80 00       	mov    0x805144,%eax
  803328:	40                   	inc    %eax
  803329:	a3 44 51 80 00       	mov    %eax,0x805144
  80332e:	e9 2a 06 00 00       	jmp    80395d <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803333:	a1 38 51 80 00       	mov    0x805138,%eax
  803338:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80333b:	e9 ed 05 00 00       	jmp    80392d <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  803340:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803343:	8b 00                	mov    (%eax),%eax
  803345:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  803348:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80334c:	0f 84 a7 00 00 00    	je     8033f9 <insert_sorted_with_merge_freeList+0x271>
  803352:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803355:	8b 50 0c             	mov    0xc(%eax),%edx
  803358:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80335b:	8b 40 08             	mov    0x8(%eax),%eax
  80335e:	01 c2                	add    %eax,%edx
  803360:	8b 45 08             	mov    0x8(%ebp),%eax
  803363:	8b 40 08             	mov    0x8(%eax),%eax
  803366:	39 c2                	cmp    %eax,%edx
  803368:	0f 83 8b 00 00 00    	jae    8033f9 <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  80336e:	8b 45 08             	mov    0x8(%ebp),%eax
  803371:	8b 50 0c             	mov    0xc(%eax),%edx
  803374:	8b 45 08             	mov    0x8(%ebp),%eax
  803377:	8b 40 08             	mov    0x8(%eax),%eax
  80337a:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  80337c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80337f:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  803382:	39 c2                	cmp    %eax,%edx
  803384:	73 73                	jae    8033f9 <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  803386:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80338a:	74 06                	je     803392 <insert_sorted_with_merge_freeList+0x20a>
  80338c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803390:	75 17                	jne    8033a9 <insert_sorted_with_merge_freeList+0x221>
  803392:	83 ec 04             	sub    $0x4,%esp
  803395:	68 fc 45 80 00       	push   $0x8045fc
  80339a:	68 f0 00 00 00       	push   $0xf0
  80339f:	68 6b 45 80 00       	push   $0x80456b
  8033a4:	e8 f9 d5 ff ff       	call   8009a2 <_panic>
  8033a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ac:	8b 10                	mov    (%eax),%edx
  8033ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b1:	89 10                	mov    %edx,(%eax)
  8033b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b6:	8b 00                	mov    (%eax),%eax
  8033b8:	85 c0                	test   %eax,%eax
  8033ba:	74 0b                	je     8033c7 <insert_sorted_with_merge_freeList+0x23f>
  8033bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033bf:	8b 00                	mov    (%eax),%eax
  8033c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c4:	89 50 04             	mov    %edx,0x4(%eax)
  8033c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8033ca:	8b 55 08             	mov    0x8(%ebp),%edx
  8033cd:	89 10                	mov    %edx,(%eax)
  8033cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8033d5:	89 50 04             	mov    %edx,0x4(%eax)
  8033d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8033db:	8b 00                	mov    (%eax),%eax
  8033dd:	85 c0                	test   %eax,%eax
  8033df:	75 08                	jne    8033e9 <insert_sorted_with_merge_freeList+0x261>
  8033e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8033e4:	a3 3c 51 80 00       	mov    %eax,0x80513c
  8033e9:	a1 44 51 80 00       	mov    0x805144,%eax
  8033ee:	40                   	inc    %eax
  8033ef:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  8033f4:	e9 64 05 00 00       	jmp    80395d <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  8033f9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8033fe:	8b 50 0c             	mov    0xc(%eax),%edx
  803401:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803406:	8b 40 08             	mov    0x8(%eax),%eax
  803409:	01 c2                	add    %eax,%edx
  80340b:	8b 45 08             	mov    0x8(%ebp),%eax
  80340e:	8b 40 08             	mov    0x8(%eax),%eax
  803411:	39 c2                	cmp    %eax,%edx
  803413:	0f 85 b1 00 00 00    	jne    8034ca <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  803419:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80341e:	85 c0                	test   %eax,%eax
  803420:	0f 84 a4 00 00 00    	je     8034ca <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  803426:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80342b:	8b 00                	mov    (%eax),%eax
  80342d:	85 c0                	test   %eax,%eax
  80342f:	0f 85 95 00 00 00    	jne    8034ca <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  803435:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80343a:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  803440:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803443:	8b 55 08             	mov    0x8(%ebp),%edx
  803446:	8b 52 0c             	mov    0xc(%edx),%edx
  803449:	01 ca                	add    %ecx,%edx
  80344b:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  80344e:	8b 45 08             	mov    0x8(%ebp),%eax
  803451:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  803458:	8b 45 08             	mov    0x8(%ebp),%eax
  80345b:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803462:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803466:	75 17                	jne    80347f <insert_sorted_with_merge_freeList+0x2f7>
  803468:	83 ec 04             	sub    $0x4,%esp
  80346b:	68 48 45 80 00       	push   $0x804548
  803470:	68 ff 00 00 00       	push   $0xff
  803475:	68 6b 45 80 00       	push   $0x80456b
  80347a:	e8 23 d5 ff ff       	call   8009a2 <_panic>
  80347f:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803485:	8b 45 08             	mov    0x8(%ebp),%eax
  803488:	89 10                	mov    %edx,(%eax)
  80348a:	8b 45 08             	mov    0x8(%ebp),%eax
  80348d:	8b 00                	mov    (%eax),%eax
  80348f:	85 c0                	test   %eax,%eax
  803491:	74 0d                	je     8034a0 <insert_sorted_with_merge_freeList+0x318>
  803493:	a1 48 51 80 00       	mov    0x805148,%eax
  803498:	8b 55 08             	mov    0x8(%ebp),%edx
  80349b:	89 50 04             	mov    %edx,0x4(%eax)
  80349e:	eb 08                	jmp    8034a8 <insert_sorted_with_merge_freeList+0x320>
  8034a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a3:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ab:	a3 48 51 80 00       	mov    %eax,0x805148
  8034b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b3:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034ba:	a1 54 51 80 00       	mov    0x805154,%eax
  8034bf:	40                   	inc    %eax
  8034c0:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  8034c5:	e9 93 04 00 00       	jmp    80395d <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  8034ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cd:	8b 50 08             	mov    0x8(%eax),%edx
  8034d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d3:	8b 40 0c             	mov    0xc(%eax),%eax
  8034d6:	01 c2                	add    %eax,%edx
  8034d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8034db:	8b 40 08             	mov    0x8(%eax),%eax
  8034de:	39 c2                	cmp    %eax,%edx
  8034e0:	0f 85 ae 00 00 00    	jne    803594 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  8034e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e9:	8b 50 0c             	mov    0xc(%eax),%edx
  8034ec:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ef:	8b 40 08             	mov    0x8(%eax),%eax
  8034f2:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  8034f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f7:	8b 00                	mov    (%eax),%eax
  8034f9:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  8034fc:	39 c2                	cmp    %eax,%edx
  8034fe:	0f 84 90 00 00 00    	je     803594 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  803504:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803507:	8b 50 0c             	mov    0xc(%eax),%edx
  80350a:	8b 45 08             	mov    0x8(%ebp),%eax
  80350d:	8b 40 0c             	mov    0xc(%eax),%eax
  803510:	01 c2                	add    %eax,%edx
  803512:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803515:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803518:	8b 45 08             	mov    0x8(%ebp),%eax
  80351b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803522:	8b 45 08             	mov    0x8(%ebp),%eax
  803525:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  80352c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803530:	75 17                	jne    803549 <insert_sorted_with_merge_freeList+0x3c1>
  803532:	83 ec 04             	sub    $0x4,%esp
  803535:	68 48 45 80 00       	push   $0x804548
  80353a:	68 0b 01 00 00       	push   $0x10b
  80353f:	68 6b 45 80 00       	push   $0x80456b
  803544:	e8 59 d4 ff ff       	call   8009a2 <_panic>
  803549:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80354f:	8b 45 08             	mov    0x8(%ebp),%eax
  803552:	89 10                	mov    %edx,(%eax)
  803554:	8b 45 08             	mov    0x8(%ebp),%eax
  803557:	8b 00                	mov    (%eax),%eax
  803559:	85 c0                	test   %eax,%eax
  80355b:	74 0d                	je     80356a <insert_sorted_with_merge_freeList+0x3e2>
  80355d:	a1 48 51 80 00       	mov    0x805148,%eax
  803562:	8b 55 08             	mov    0x8(%ebp),%edx
  803565:	89 50 04             	mov    %edx,0x4(%eax)
  803568:	eb 08                	jmp    803572 <insert_sorted_with_merge_freeList+0x3ea>
  80356a:	8b 45 08             	mov    0x8(%ebp),%eax
  80356d:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803572:	8b 45 08             	mov    0x8(%ebp),%eax
  803575:	a3 48 51 80 00       	mov    %eax,0x805148
  80357a:	8b 45 08             	mov    0x8(%ebp),%eax
  80357d:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803584:	a1 54 51 80 00       	mov    0x805154,%eax
  803589:	40                   	inc    %eax
  80358a:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  80358f:	e9 c9 03 00 00       	jmp    80395d <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803594:	8b 45 08             	mov    0x8(%ebp),%eax
  803597:	8b 50 0c             	mov    0xc(%eax),%edx
  80359a:	8b 45 08             	mov    0x8(%ebp),%eax
  80359d:	8b 40 08             	mov    0x8(%eax),%eax
  8035a0:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  8035a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a5:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  8035a8:	39 c2                	cmp    %eax,%edx
  8035aa:	0f 85 bb 00 00 00    	jne    80366b <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  8035b0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8035b4:	0f 84 b1 00 00 00    	je     80366b <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  8035ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bd:	8b 40 04             	mov    0x4(%eax),%eax
  8035c0:	85 c0                	test   %eax,%eax
  8035c2:	0f 85 a3 00 00 00    	jne    80366b <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  8035c8:	a1 38 51 80 00       	mov    0x805138,%eax
  8035cd:	8b 55 08             	mov    0x8(%ebp),%edx
  8035d0:	8b 52 08             	mov    0x8(%edx),%edx
  8035d3:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  8035d6:	a1 38 51 80 00       	mov    0x805138,%eax
  8035db:	8b 15 38 51 80 00    	mov    0x805138,%edx
  8035e1:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8035e4:	8b 55 08             	mov    0x8(%ebp),%edx
  8035e7:	8b 52 0c             	mov    0xc(%edx),%edx
  8035ea:	01 ca                	add    %ecx,%edx
  8035ec:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8035ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8035f2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8035f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8035fc:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803603:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803607:	75 17                	jne    803620 <insert_sorted_with_merge_freeList+0x498>
  803609:	83 ec 04             	sub    $0x4,%esp
  80360c:	68 48 45 80 00       	push   $0x804548
  803611:	68 17 01 00 00       	push   $0x117
  803616:	68 6b 45 80 00       	push   $0x80456b
  80361b:	e8 82 d3 ff ff       	call   8009a2 <_panic>
  803620:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803626:	8b 45 08             	mov    0x8(%ebp),%eax
  803629:	89 10                	mov    %edx,(%eax)
  80362b:	8b 45 08             	mov    0x8(%ebp),%eax
  80362e:	8b 00                	mov    (%eax),%eax
  803630:	85 c0                	test   %eax,%eax
  803632:	74 0d                	je     803641 <insert_sorted_with_merge_freeList+0x4b9>
  803634:	a1 48 51 80 00       	mov    0x805148,%eax
  803639:	8b 55 08             	mov    0x8(%ebp),%edx
  80363c:	89 50 04             	mov    %edx,0x4(%eax)
  80363f:	eb 08                	jmp    803649 <insert_sorted_with_merge_freeList+0x4c1>
  803641:	8b 45 08             	mov    0x8(%ebp),%eax
  803644:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803649:	8b 45 08             	mov    0x8(%ebp),%eax
  80364c:	a3 48 51 80 00       	mov    %eax,0x805148
  803651:	8b 45 08             	mov    0x8(%ebp),%eax
  803654:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80365b:	a1 54 51 80 00       	mov    0x805154,%eax
  803660:	40                   	inc    %eax
  803661:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803666:	e9 f2 02 00 00       	jmp    80395d <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  80366b:	8b 45 08             	mov    0x8(%ebp),%eax
  80366e:	8b 50 08             	mov    0x8(%eax),%edx
  803671:	8b 45 08             	mov    0x8(%ebp),%eax
  803674:	8b 40 0c             	mov    0xc(%eax),%eax
  803677:	01 c2                	add    %eax,%edx
  803679:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80367c:	8b 40 08             	mov    0x8(%eax),%eax
  80367f:	39 c2                	cmp    %eax,%edx
  803681:	0f 85 be 00 00 00    	jne    803745 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  803687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80368a:	8b 40 04             	mov    0x4(%eax),%eax
  80368d:	8b 50 08             	mov    0x8(%eax),%edx
  803690:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803693:	8b 40 04             	mov    0x4(%eax),%eax
  803696:	8b 40 0c             	mov    0xc(%eax),%eax
  803699:	01 c2                	add    %eax,%edx
  80369b:	8b 45 08             	mov    0x8(%ebp),%eax
  80369e:	8b 40 08             	mov    0x8(%eax),%eax
  8036a1:	39 c2                	cmp    %eax,%edx
  8036a3:	0f 84 9c 00 00 00    	je     803745 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  8036a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036ac:	8b 50 08             	mov    0x8(%eax),%edx
  8036af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b2:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  8036b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036b8:	8b 50 0c             	mov    0xc(%eax),%edx
  8036bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8036be:	8b 40 0c             	mov    0xc(%eax),%eax
  8036c1:	01 c2                	add    %eax,%edx
  8036c3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036c6:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  8036c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8036cc:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8036d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8036d6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8036dd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8036e1:	75 17                	jne    8036fa <insert_sorted_with_merge_freeList+0x572>
  8036e3:	83 ec 04             	sub    $0x4,%esp
  8036e6:	68 48 45 80 00       	push   $0x804548
  8036eb:	68 26 01 00 00       	push   $0x126
  8036f0:	68 6b 45 80 00       	push   $0x80456b
  8036f5:	e8 a8 d2 ff ff       	call   8009a2 <_panic>
  8036fa:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803700:	8b 45 08             	mov    0x8(%ebp),%eax
  803703:	89 10                	mov    %edx,(%eax)
  803705:	8b 45 08             	mov    0x8(%ebp),%eax
  803708:	8b 00                	mov    (%eax),%eax
  80370a:	85 c0                	test   %eax,%eax
  80370c:	74 0d                	je     80371b <insert_sorted_with_merge_freeList+0x593>
  80370e:	a1 48 51 80 00       	mov    0x805148,%eax
  803713:	8b 55 08             	mov    0x8(%ebp),%edx
  803716:	89 50 04             	mov    %edx,0x4(%eax)
  803719:	eb 08                	jmp    803723 <insert_sorted_with_merge_freeList+0x59b>
  80371b:	8b 45 08             	mov    0x8(%ebp),%eax
  80371e:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803723:	8b 45 08             	mov    0x8(%ebp),%eax
  803726:	a3 48 51 80 00       	mov    %eax,0x805148
  80372b:	8b 45 08             	mov    0x8(%ebp),%eax
  80372e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803735:	a1 54 51 80 00       	mov    0x805154,%eax
  80373a:	40                   	inc    %eax
  80373b:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  803740:	e9 18 02 00 00       	jmp    80395d <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  803745:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803748:	8b 50 0c             	mov    0xc(%eax),%edx
  80374b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80374e:	8b 40 08             	mov    0x8(%eax),%eax
  803751:	01 c2                	add    %eax,%edx
  803753:	8b 45 08             	mov    0x8(%ebp),%eax
  803756:	8b 40 08             	mov    0x8(%eax),%eax
  803759:	39 c2                	cmp    %eax,%edx
  80375b:	0f 85 c4 01 00 00    	jne    803925 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  803761:	8b 45 08             	mov    0x8(%ebp),%eax
  803764:	8b 50 0c             	mov    0xc(%eax),%edx
  803767:	8b 45 08             	mov    0x8(%ebp),%eax
  80376a:	8b 40 08             	mov    0x8(%eax),%eax
  80376d:	01 c2                	add    %eax,%edx
  80376f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803772:	8b 00                	mov    (%eax),%eax
  803774:	8b 40 08             	mov    0x8(%eax),%eax
  803777:	39 c2                	cmp    %eax,%edx
  803779:	0f 85 a6 01 00 00    	jne    803925 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  80377f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803783:	0f 84 9c 01 00 00    	je     803925 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  803789:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80378c:	8b 50 0c             	mov    0xc(%eax),%edx
  80378f:	8b 45 08             	mov    0x8(%ebp),%eax
  803792:	8b 40 0c             	mov    0xc(%eax),%eax
  803795:	01 c2                	add    %eax,%edx
  803797:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80379a:	8b 00                	mov    (%eax),%eax
  80379c:	8b 40 0c             	mov    0xc(%eax),%eax
  80379f:	01 c2                	add    %eax,%edx
  8037a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8037a4:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  8037a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8037aa:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  8037b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8037b4:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  8037bb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8037bf:	75 17                	jne    8037d8 <insert_sorted_with_merge_freeList+0x650>
  8037c1:	83 ec 04             	sub    $0x4,%esp
  8037c4:	68 48 45 80 00       	push   $0x804548
  8037c9:	68 32 01 00 00       	push   $0x132
  8037ce:	68 6b 45 80 00       	push   $0x80456b
  8037d3:	e8 ca d1 ff ff       	call   8009a2 <_panic>
  8037d8:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8037de:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e1:	89 10                	mov    %edx,(%eax)
  8037e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8037e6:	8b 00                	mov    (%eax),%eax
  8037e8:	85 c0                	test   %eax,%eax
  8037ea:	74 0d                	je     8037f9 <insert_sorted_with_merge_freeList+0x671>
  8037ec:	a1 48 51 80 00       	mov    0x805148,%eax
  8037f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8037f4:	89 50 04             	mov    %edx,0x4(%eax)
  8037f7:	eb 08                	jmp    803801 <insert_sorted_with_merge_freeList+0x679>
  8037f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8037fc:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803801:	8b 45 08             	mov    0x8(%ebp),%eax
  803804:	a3 48 51 80 00       	mov    %eax,0x805148
  803809:	8b 45 08             	mov    0x8(%ebp),%eax
  80380c:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803813:	a1 54 51 80 00       	mov    0x805154,%eax
  803818:	40                   	inc    %eax
  803819:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  80381e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803821:	8b 00                	mov    (%eax),%eax
  803823:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  80382a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80382d:	8b 00                	mov    (%eax),%eax
  80382f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  803836:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803839:	8b 00                	mov    (%eax),%eax
  80383b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  80383e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803842:	75 17                	jne    80385b <insert_sorted_with_merge_freeList+0x6d3>
  803844:	83 ec 04             	sub    $0x4,%esp
  803847:	68 dd 45 80 00       	push   $0x8045dd
  80384c:	68 36 01 00 00       	push   $0x136
  803851:	68 6b 45 80 00       	push   $0x80456b
  803856:	e8 47 d1 ff ff       	call   8009a2 <_panic>
  80385b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80385e:	8b 00                	mov    (%eax),%eax
  803860:	85 c0                	test   %eax,%eax
  803862:	74 10                	je     803874 <insert_sorted_with_merge_freeList+0x6ec>
  803864:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803867:	8b 00                	mov    (%eax),%eax
  803869:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80386c:	8b 52 04             	mov    0x4(%edx),%edx
  80386f:	89 50 04             	mov    %edx,0x4(%eax)
  803872:	eb 0b                	jmp    80387f <insert_sorted_with_merge_freeList+0x6f7>
  803874:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803877:	8b 40 04             	mov    0x4(%eax),%eax
  80387a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80387f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803882:	8b 40 04             	mov    0x4(%eax),%eax
  803885:	85 c0                	test   %eax,%eax
  803887:	74 0f                	je     803898 <insert_sorted_with_merge_freeList+0x710>
  803889:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80388c:	8b 40 04             	mov    0x4(%eax),%eax
  80388f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803892:	8b 12                	mov    (%edx),%edx
  803894:	89 10                	mov    %edx,(%eax)
  803896:	eb 0a                	jmp    8038a2 <insert_sorted_with_merge_freeList+0x71a>
  803898:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80389b:	8b 00                	mov    (%eax),%eax
  80389d:	a3 38 51 80 00       	mov    %eax,0x805138
  8038a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  8038ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038ae:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8038b5:	a1 44 51 80 00       	mov    0x805144,%eax
  8038ba:	48                   	dec    %eax
  8038bb:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  8038c0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8038c4:	75 17                	jne    8038dd <insert_sorted_with_merge_freeList+0x755>
  8038c6:	83 ec 04             	sub    $0x4,%esp
  8038c9:	68 48 45 80 00       	push   $0x804548
  8038ce:	68 37 01 00 00       	push   $0x137
  8038d3:	68 6b 45 80 00       	push   $0x80456b
  8038d8:	e8 c5 d0 ff ff       	call   8009a2 <_panic>
  8038dd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8038e3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038e6:	89 10                	mov    %edx,(%eax)
  8038e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8038eb:	8b 00                	mov    (%eax),%eax
  8038ed:	85 c0                	test   %eax,%eax
  8038ef:	74 0d                	je     8038fe <insert_sorted_with_merge_freeList+0x776>
  8038f1:	a1 48 51 80 00       	mov    0x805148,%eax
  8038f6:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8038f9:	89 50 04             	mov    %edx,0x4(%eax)
  8038fc:	eb 08                	jmp    803906 <insert_sorted_with_merge_freeList+0x77e>
  8038fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803901:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803906:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803909:	a3 48 51 80 00       	mov    %eax,0x805148
  80390e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803911:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803918:	a1 54 51 80 00       	mov    0x805154,%eax
  80391d:	40                   	inc    %eax
  80391e:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  803923:	eb 38                	jmp    80395d <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  803925:	a1 40 51 80 00       	mov    0x805140,%eax
  80392a:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80392d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803931:	74 07                	je     80393a <insert_sorted_with_merge_freeList+0x7b2>
  803933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803936:	8b 00                	mov    (%eax),%eax
  803938:	eb 05                	jmp    80393f <insert_sorted_with_merge_freeList+0x7b7>
  80393a:	b8 00 00 00 00       	mov    $0x0,%eax
  80393f:	a3 40 51 80 00       	mov    %eax,0x805140
  803944:	a1 40 51 80 00       	mov    0x805140,%eax
  803949:	85 c0                	test   %eax,%eax
  80394b:	0f 85 ef f9 ff ff    	jne    803340 <insert_sorted_with_merge_freeList+0x1b8>
  803951:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803955:	0f 85 e5 f9 ff ff    	jne    803340 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  80395b:	eb 00                	jmp    80395d <insert_sorted_with_merge_freeList+0x7d5>
  80395d:	90                   	nop
  80395e:	c9                   	leave  
  80395f:	c3                   	ret    

00803960 <__udivdi3>:
  803960:	55                   	push   %ebp
  803961:	57                   	push   %edi
  803962:	56                   	push   %esi
  803963:	53                   	push   %ebx
  803964:	83 ec 1c             	sub    $0x1c,%esp
  803967:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  80396b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  80396f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803973:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  803977:	89 ca                	mov    %ecx,%edx
  803979:	89 f8                	mov    %edi,%eax
  80397b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  80397f:	85 f6                	test   %esi,%esi
  803981:	75 2d                	jne    8039b0 <__udivdi3+0x50>
  803983:	39 cf                	cmp    %ecx,%edi
  803985:	77 65                	ja     8039ec <__udivdi3+0x8c>
  803987:	89 fd                	mov    %edi,%ebp
  803989:	85 ff                	test   %edi,%edi
  80398b:	75 0b                	jne    803998 <__udivdi3+0x38>
  80398d:	b8 01 00 00 00       	mov    $0x1,%eax
  803992:	31 d2                	xor    %edx,%edx
  803994:	f7 f7                	div    %edi
  803996:	89 c5                	mov    %eax,%ebp
  803998:	31 d2                	xor    %edx,%edx
  80399a:	89 c8                	mov    %ecx,%eax
  80399c:	f7 f5                	div    %ebp
  80399e:	89 c1                	mov    %eax,%ecx
  8039a0:	89 d8                	mov    %ebx,%eax
  8039a2:	f7 f5                	div    %ebp
  8039a4:	89 cf                	mov    %ecx,%edi
  8039a6:	89 fa                	mov    %edi,%edx
  8039a8:	83 c4 1c             	add    $0x1c,%esp
  8039ab:	5b                   	pop    %ebx
  8039ac:	5e                   	pop    %esi
  8039ad:	5f                   	pop    %edi
  8039ae:	5d                   	pop    %ebp
  8039af:	c3                   	ret    
  8039b0:	39 ce                	cmp    %ecx,%esi
  8039b2:	77 28                	ja     8039dc <__udivdi3+0x7c>
  8039b4:	0f bd fe             	bsr    %esi,%edi
  8039b7:	83 f7 1f             	xor    $0x1f,%edi
  8039ba:	75 40                	jne    8039fc <__udivdi3+0x9c>
  8039bc:	39 ce                	cmp    %ecx,%esi
  8039be:	72 0a                	jb     8039ca <__udivdi3+0x6a>
  8039c0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  8039c4:	0f 87 9e 00 00 00    	ja     803a68 <__udivdi3+0x108>
  8039ca:	b8 01 00 00 00       	mov    $0x1,%eax
  8039cf:	89 fa                	mov    %edi,%edx
  8039d1:	83 c4 1c             	add    $0x1c,%esp
  8039d4:	5b                   	pop    %ebx
  8039d5:	5e                   	pop    %esi
  8039d6:	5f                   	pop    %edi
  8039d7:	5d                   	pop    %ebp
  8039d8:	c3                   	ret    
  8039d9:	8d 76 00             	lea    0x0(%esi),%esi
  8039dc:	31 ff                	xor    %edi,%edi
  8039de:	31 c0                	xor    %eax,%eax
  8039e0:	89 fa                	mov    %edi,%edx
  8039e2:	83 c4 1c             	add    $0x1c,%esp
  8039e5:	5b                   	pop    %ebx
  8039e6:	5e                   	pop    %esi
  8039e7:	5f                   	pop    %edi
  8039e8:	5d                   	pop    %ebp
  8039e9:	c3                   	ret    
  8039ea:	66 90                	xchg   %ax,%ax
  8039ec:	89 d8                	mov    %ebx,%eax
  8039ee:	f7 f7                	div    %edi
  8039f0:	31 ff                	xor    %edi,%edi
  8039f2:	89 fa                	mov    %edi,%edx
  8039f4:	83 c4 1c             	add    $0x1c,%esp
  8039f7:	5b                   	pop    %ebx
  8039f8:	5e                   	pop    %esi
  8039f9:	5f                   	pop    %edi
  8039fa:	5d                   	pop    %ebp
  8039fb:	c3                   	ret    
  8039fc:	bd 20 00 00 00       	mov    $0x20,%ebp
  803a01:	89 eb                	mov    %ebp,%ebx
  803a03:	29 fb                	sub    %edi,%ebx
  803a05:	89 f9                	mov    %edi,%ecx
  803a07:	d3 e6                	shl    %cl,%esi
  803a09:	89 c5                	mov    %eax,%ebp
  803a0b:	88 d9                	mov    %bl,%cl
  803a0d:	d3 ed                	shr    %cl,%ebp
  803a0f:	89 e9                	mov    %ebp,%ecx
  803a11:	09 f1                	or     %esi,%ecx
  803a13:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  803a17:	89 f9                	mov    %edi,%ecx
  803a19:	d3 e0                	shl    %cl,%eax
  803a1b:	89 c5                	mov    %eax,%ebp
  803a1d:	89 d6                	mov    %edx,%esi
  803a1f:	88 d9                	mov    %bl,%cl
  803a21:	d3 ee                	shr    %cl,%esi
  803a23:	89 f9                	mov    %edi,%ecx
  803a25:	d3 e2                	shl    %cl,%edx
  803a27:	8b 44 24 08          	mov    0x8(%esp),%eax
  803a2b:	88 d9                	mov    %bl,%cl
  803a2d:	d3 e8                	shr    %cl,%eax
  803a2f:	09 c2                	or     %eax,%edx
  803a31:	89 d0                	mov    %edx,%eax
  803a33:	89 f2                	mov    %esi,%edx
  803a35:	f7 74 24 0c          	divl   0xc(%esp)
  803a39:	89 d6                	mov    %edx,%esi
  803a3b:	89 c3                	mov    %eax,%ebx
  803a3d:	f7 e5                	mul    %ebp
  803a3f:	39 d6                	cmp    %edx,%esi
  803a41:	72 19                	jb     803a5c <__udivdi3+0xfc>
  803a43:	74 0b                	je     803a50 <__udivdi3+0xf0>
  803a45:	89 d8                	mov    %ebx,%eax
  803a47:	31 ff                	xor    %edi,%edi
  803a49:	e9 58 ff ff ff       	jmp    8039a6 <__udivdi3+0x46>
  803a4e:	66 90                	xchg   %ax,%ax
  803a50:	8b 54 24 08          	mov    0x8(%esp),%edx
  803a54:	89 f9                	mov    %edi,%ecx
  803a56:	d3 e2                	shl    %cl,%edx
  803a58:	39 c2                	cmp    %eax,%edx
  803a5a:	73 e9                	jae    803a45 <__udivdi3+0xe5>
  803a5c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  803a5f:	31 ff                	xor    %edi,%edi
  803a61:	e9 40 ff ff ff       	jmp    8039a6 <__udivdi3+0x46>
  803a66:	66 90                	xchg   %ax,%ax
  803a68:	31 c0                	xor    %eax,%eax
  803a6a:	e9 37 ff ff ff       	jmp    8039a6 <__udivdi3+0x46>
  803a6f:	90                   	nop

00803a70 <__umoddi3>:
  803a70:	55                   	push   %ebp
  803a71:	57                   	push   %edi
  803a72:	56                   	push   %esi
  803a73:	53                   	push   %ebx
  803a74:	83 ec 1c             	sub    $0x1c,%esp
  803a77:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  803a7b:	8b 74 24 34          	mov    0x34(%esp),%esi
  803a7f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803a83:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  803a87:	89 44 24 0c          	mov    %eax,0xc(%esp)
  803a8b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803a8f:	89 f3                	mov    %esi,%ebx
  803a91:	89 fa                	mov    %edi,%edx
  803a93:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803a97:	89 34 24             	mov    %esi,(%esp)
  803a9a:	85 c0                	test   %eax,%eax
  803a9c:	75 1a                	jne    803ab8 <__umoddi3+0x48>
  803a9e:	39 f7                	cmp    %esi,%edi
  803aa0:	0f 86 a2 00 00 00    	jbe    803b48 <__umoddi3+0xd8>
  803aa6:	89 c8                	mov    %ecx,%eax
  803aa8:	89 f2                	mov    %esi,%edx
  803aaa:	f7 f7                	div    %edi
  803aac:	89 d0                	mov    %edx,%eax
  803aae:	31 d2                	xor    %edx,%edx
  803ab0:	83 c4 1c             	add    $0x1c,%esp
  803ab3:	5b                   	pop    %ebx
  803ab4:	5e                   	pop    %esi
  803ab5:	5f                   	pop    %edi
  803ab6:	5d                   	pop    %ebp
  803ab7:	c3                   	ret    
  803ab8:	39 f0                	cmp    %esi,%eax
  803aba:	0f 87 ac 00 00 00    	ja     803b6c <__umoddi3+0xfc>
  803ac0:	0f bd e8             	bsr    %eax,%ebp
  803ac3:	83 f5 1f             	xor    $0x1f,%ebp
  803ac6:	0f 84 ac 00 00 00    	je     803b78 <__umoddi3+0x108>
  803acc:	bf 20 00 00 00       	mov    $0x20,%edi
  803ad1:	29 ef                	sub    %ebp,%edi
  803ad3:	89 fe                	mov    %edi,%esi
  803ad5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  803ad9:	89 e9                	mov    %ebp,%ecx
  803adb:	d3 e0                	shl    %cl,%eax
  803add:	89 d7                	mov    %edx,%edi
  803adf:	89 f1                	mov    %esi,%ecx
  803ae1:	d3 ef                	shr    %cl,%edi
  803ae3:	09 c7                	or     %eax,%edi
  803ae5:	89 e9                	mov    %ebp,%ecx
  803ae7:	d3 e2                	shl    %cl,%edx
  803ae9:	89 14 24             	mov    %edx,(%esp)
  803aec:	89 d8                	mov    %ebx,%eax
  803aee:	d3 e0                	shl    %cl,%eax
  803af0:	89 c2                	mov    %eax,%edx
  803af2:	8b 44 24 08          	mov    0x8(%esp),%eax
  803af6:	d3 e0                	shl    %cl,%eax
  803af8:	89 44 24 04          	mov    %eax,0x4(%esp)
  803afc:	8b 44 24 08          	mov    0x8(%esp),%eax
  803b00:	89 f1                	mov    %esi,%ecx
  803b02:	d3 e8                	shr    %cl,%eax
  803b04:	09 d0                	or     %edx,%eax
  803b06:	d3 eb                	shr    %cl,%ebx
  803b08:	89 da                	mov    %ebx,%edx
  803b0a:	f7 f7                	div    %edi
  803b0c:	89 d3                	mov    %edx,%ebx
  803b0e:	f7 24 24             	mull   (%esp)
  803b11:	89 c6                	mov    %eax,%esi
  803b13:	89 d1                	mov    %edx,%ecx
  803b15:	39 d3                	cmp    %edx,%ebx
  803b17:	0f 82 87 00 00 00    	jb     803ba4 <__umoddi3+0x134>
  803b1d:	0f 84 91 00 00 00    	je     803bb4 <__umoddi3+0x144>
  803b23:	8b 54 24 04          	mov    0x4(%esp),%edx
  803b27:	29 f2                	sub    %esi,%edx
  803b29:	19 cb                	sbb    %ecx,%ebx
  803b2b:	89 d8                	mov    %ebx,%eax
  803b2d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  803b31:	d3 e0                	shl    %cl,%eax
  803b33:	89 e9                	mov    %ebp,%ecx
  803b35:	d3 ea                	shr    %cl,%edx
  803b37:	09 d0                	or     %edx,%eax
  803b39:	89 e9                	mov    %ebp,%ecx
  803b3b:	d3 eb                	shr    %cl,%ebx
  803b3d:	89 da                	mov    %ebx,%edx
  803b3f:	83 c4 1c             	add    $0x1c,%esp
  803b42:	5b                   	pop    %ebx
  803b43:	5e                   	pop    %esi
  803b44:	5f                   	pop    %edi
  803b45:	5d                   	pop    %ebp
  803b46:	c3                   	ret    
  803b47:	90                   	nop
  803b48:	89 fd                	mov    %edi,%ebp
  803b4a:	85 ff                	test   %edi,%edi
  803b4c:	75 0b                	jne    803b59 <__umoddi3+0xe9>
  803b4e:	b8 01 00 00 00       	mov    $0x1,%eax
  803b53:	31 d2                	xor    %edx,%edx
  803b55:	f7 f7                	div    %edi
  803b57:	89 c5                	mov    %eax,%ebp
  803b59:	89 f0                	mov    %esi,%eax
  803b5b:	31 d2                	xor    %edx,%edx
  803b5d:	f7 f5                	div    %ebp
  803b5f:	89 c8                	mov    %ecx,%eax
  803b61:	f7 f5                	div    %ebp
  803b63:	89 d0                	mov    %edx,%eax
  803b65:	e9 44 ff ff ff       	jmp    803aae <__umoddi3+0x3e>
  803b6a:	66 90                	xchg   %ax,%ax
  803b6c:	89 c8                	mov    %ecx,%eax
  803b6e:	89 f2                	mov    %esi,%edx
  803b70:	83 c4 1c             	add    $0x1c,%esp
  803b73:	5b                   	pop    %ebx
  803b74:	5e                   	pop    %esi
  803b75:	5f                   	pop    %edi
  803b76:	5d                   	pop    %ebp
  803b77:	c3                   	ret    
  803b78:	3b 04 24             	cmp    (%esp),%eax
  803b7b:	72 06                	jb     803b83 <__umoddi3+0x113>
  803b7d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803b81:	77 0f                	ja     803b92 <__umoddi3+0x122>
  803b83:	89 f2                	mov    %esi,%edx
  803b85:	29 f9                	sub    %edi,%ecx
  803b87:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  803b8b:	89 14 24             	mov    %edx,(%esp)
  803b8e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803b92:	8b 44 24 04          	mov    0x4(%esp),%eax
  803b96:	8b 14 24             	mov    (%esp),%edx
  803b99:	83 c4 1c             	add    $0x1c,%esp
  803b9c:	5b                   	pop    %ebx
  803b9d:	5e                   	pop    %esi
  803b9e:	5f                   	pop    %edi
  803b9f:	5d                   	pop    %ebp
  803ba0:	c3                   	ret    
  803ba1:	8d 76 00             	lea    0x0(%esi),%esi
  803ba4:	2b 04 24             	sub    (%esp),%eax
  803ba7:	19 fa                	sbb    %edi,%edx
  803ba9:	89 d1                	mov    %edx,%ecx
  803bab:	89 c6                	mov    %eax,%esi
  803bad:	e9 71 ff ff ff       	jmp    803b23 <__umoddi3+0xb3>
  803bb2:	66 90                	xchg   %ax,%ax
  803bb4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  803bb8:	72 ea                	jb     803ba4 <__umoddi3+0x134>
  803bba:	89 d9                	mov    %ebx,%ecx
  803bbc:	e9 62 ff ff ff       	jmp    803b23 <__umoddi3+0xb3>
