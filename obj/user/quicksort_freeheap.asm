
obj/user/quicksort_freeheap:     file format elf32-i386


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
  800031:	e8 b4 05 00 00       	call   8005ea <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
void QuickSort(int *Elements, int NumOfElements);
void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex);
uint32 CheckSorted(int *Elements, int NumOfElements);

void _main(void)
{	
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	53                   	push   %ebx
  80003c:	81 ec 24 01 00 00    	sub    $0x124,%esp
	char Chose ;
	char Line[255] ;
	int Iteration = 0 ;
  800042:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	do
	{
		int InitFreeFrames = sys_calculate_free_frames() + sys_calculate_modified_frames();
  800049:	e8 cf 1f 00 00       	call   80201d <sys_calculate_free_frames>
  80004e:	89 c3                	mov    %eax,%ebx
  800050:	e8 e1 1f 00 00       	call   802036 <sys_calculate_modified_frames>
  800055:	01 d8                	add    %ebx,%eax
  800057:	89 45 f0             	mov    %eax,-0x10(%ebp)

		Iteration++ ;
  80005a:	ff 45 f4             	incl   -0xc(%ebp)
		//		cprintf("Free Frames Before Allocation = %d\n", sys_calculate_free_frames()) ;

		//	sys_disable_interrupt();

		readline("Enter the number of elements: ", Line);
  80005d:	83 ec 08             	sub    $0x8,%esp
  800060:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800066:	50                   	push   %eax
  800067:	68 60 39 80 00       	push   $0x803960
  80006c:	e8 eb 0f 00 00       	call   80105c <readline>
  800071:	83 c4 10             	add    $0x10,%esp
		int NumOfElements = strtol(Line, NULL, 10) ;
  800074:	83 ec 04             	sub    $0x4,%esp
  800077:	6a 0a                	push   $0xa
  800079:	6a 00                	push   $0x0
  80007b:	8d 85 e1 fe ff ff    	lea    -0x11f(%ebp),%eax
  800081:	50                   	push   %eax
  800082:	e8 3b 15 00 00       	call   8015c2 <strtol>
  800087:	83 c4 10             	add    $0x10,%esp
  80008a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		int *Elements = malloc(sizeof(int) * NumOfElements) ;
  80008d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800090:	c1 e0 02             	shl    $0x2,%eax
  800093:	83 ec 0c             	sub    $0xc,%esp
  800096:	50                   	push   %eax
  800097:	e8 e3 1a 00 00       	call   801b7f <malloc>
  80009c:	83 c4 10             	add    $0x10,%esp
  80009f:	89 45 e8             	mov    %eax,-0x18(%ebp)
		cprintf("Choose the initialization method:\n") ;
  8000a2:	83 ec 0c             	sub    $0xc,%esp
  8000a5:	68 80 39 80 00       	push   $0x803980
  8000aa:	e8 2b 09 00 00       	call   8009da <cprintf>
  8000af:	83 c4 10             	add    $0x10,%esp
		cprintf("a) Ascending\n") ;
  8000b2:	83 ec 0c             	sub    $0xc,%esp
  8000b5:	68 a3 39 80 00       	push   $0x8039a3
  8000ba:	e8 1b 09 00 00       	call   8009da <cprintf>
  8000bf:	83 c4 10             	add    $0x10,%esp
		cprintf("b) Descending\n") ;
  8000c2:	83 ec 0c             	sub    $0xc,%esp
  8000c5:	68 b1 39 80 00       	push   $0x8039b1
  8000ca:	e8 0b 09 00 00       	call   8009da <cprintf>
  8000cf:	83 c4 10             	add    $0x10,%esp
		cprintf("c) Semi random\n");
  8000d2:	83 ec 0c             	sub    $0xc,%esp
  8000d5:	68 c0 39 80 00       	push   $0x8039c0
  8000da:	e8 fb 08 00 00       	call   8009da <cprintf>
  8000df:	83 c4 10             	add    $0x10,%esp
		do
		{
			cprintf("Select: ") ;
  8000e2:	83 ec 0c             	sub    $0xc,%esp
  8000e5:	68 d0 39 80 00       	push   $0x8039d0
  8000ea:	e8 eb 08 00 00       	call   8009da <cprintf>
  8000ef:	83 c4 10             	add    $0x10,%esp
			Chose = getchar() ;
  8000f2:	e8 9b 04 00 00       	call   800592 <getchar>
  8000f7:	88 45 e7             	mov    %al,-0x19(%ebp)
			cputchar(Chose);
  8000fa:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  8000fe:	83 ec 0c             	sub    $0xc,%esp
  800101:	50                   	push   %eax
  800102:	e8 43 04 00 00       	call   80054a <cputchar>
  800107:	83 c4 10             	add    $0x10,%esp
			cputchar('\n');
  80010a:	83 ec 0c             	sub    $0xc,%esp
  80010d:	6a 0a                	push   $0xa
  80010f:	e8 36 04 00 00       	call   80054a <cputchar>
  800114:	83 c4 10             	add    $0x10,%esp
		} while (Chose != 'a' && Chose != 'b' && Chose != 'c');
  800117:	80 7d e7 61          	cmpb   $0x61,-0x19(%ebp)
  80011b:	74 0c                	je     800129 <_main+0xf1>
  80011d:	80 7d e7 62          	cmpb   $0x62,-0x19(%ebp)
  800121:	74 06                	je     800129 <_main+0xf1>
  800123:	80 7d e7 63          	cmpb   $0x63,-0x19(%ebp)
  800127:	75 b9                	jne    8000e2 <_main+0xaa>
		//sys_enable_interrupt();
		int  i ;
		switch (Chose)
  800129:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  80012d:	83 f8 62             	cmp    $0x62,%eax
  800130:	74 1d                	je     80014f <_main+0x117>
  800132:	83 f8 63             	cmp    $0x63,%eax
  800135:	74 2b                	je     800162 <_main+0x12a>
  800137:	83 f8 61             	cmp    $0x61,%eax
  80013a:	75 39                	jne    800175 <_main+0x13d>
		{
		case 'a':
			InitializeAscending(Elements, NumOfElements);
  80013c:	83 ec 08             	sub    $0x8,%esp
  80013f:	ff 75 ec             	pushl  -0x14(%ebp)
  800142:	ff 75 e8             	pushl  -0x18(%ebp)
  800145:	e8 c8 02 00 00       	call   800412 <InitializeAscending>
  80014a:	83 c4 10             	add    $0x10,%esp
			break ;
  80014d:	eb 37                	jmp    800186 <_main+0x14e>
		case 'b':
			InitializeDescending(Elements, NumOfElements);
  80014f:	83 ec 08             	sub    $0x8,%esp
  800152:	ff 75 ec             	pushl  -0x14(%ebp)
  800155:	ff 75 e8             	pushl  -0x18(%ebp)
  800158:	e8 e6 02 00 00       	call   800443 <InitializeDescending>
  80015d:	83 c4 10             	add    $0x10,%esp
			break ;
  800160:	eb 24                	jmp    800186 <_main+0x14e>
		case 'c':
			InitializeSemiRandom(Elements, NumOfElements);
  800162:	83 ec 08             	sub    $0x8,%esp
  800165:	ff 75 ec             	pushl  -0x14(%ebp)
  800168:	ff 75 e8             	pushl  -0x18(%ebp)
  80016b:	e8 08 03 00 00       	call   800478 <InitializeSemiRandom>
  800170:	83 c4 10             	add    $0x10,%esp
			break ;
  800173:	eb 11                	jmp    800186 <_main+0x14e>
		default:
			InitializeSemiRandom(Elements, NumOfElements);
  800175:	83 ec 08             	sub    $0x8,%esp
  800178:	ff 75 ec             	pushl  -0x14(%ebp)
  80017b:	ff 75 e8             	pushl  -0x18(%ebp)
  80017e:	e8 f5 02 00 00       	call   800478 <InitializeSemiRandom>
  800183:	83 c4 10             	add    $0x10,%esp
		}

		QuickSort(Elements, NumOfElements);
  800186:	83 ec 08             	sub    $0x8,%esp
  800189:	ff 75 ec             	pushl  -0x14(%ebp)
  80018c:	ff 75 e8             	pushl  -0x18(%ebp)
  80018f:	e8 c3 00 00 00       	call   800257 <QuickSort>
  800194:	83 c4 10             	add    $0x10,%esp

		//		PrintElements(Elements, NumOfElements);

		uint32 Sorted = CheckSorted(Elements, NumOfElements);
  800197:	83 ec 08             	sub    $0x8,%esp
  80019a:	ff 75 ec             	pushl  -0x14(%ebp)
  80019d:	ff 75 e8             	pushl  -0x18(%ebp)
  8001a0:	e8 c3 01 00 00       	call   800368 <CheckSorted>
  8001a5:	83 c4 10             	add    $0x10,%esp
  8001a8:	89 45 e0             	mov    %eax,-0x20(%ebp)

		if(Sorted == 0) panic("The array is NOT sorted correctly") ;
  8001ab:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  8001af:	75 14                	jne    8001c5 <_main+0x18d>
  8001b1:	83 ec 04             	sub    $0x4,%esp
  8001b4:	68 dc 39 80 00       	push   $0x8039dc
  8001b9:	6a 45                	push   $0x45
  8001bb:	68 fe 39 80 00       	push   $0x8039fe
  8001c0:	e8 61 05 00 00       	call   800726 <_panic>
		else
		{ 
			cprintf("===============================================\n") ;
  8001c5:	83 ec 0c             	sub    $0xc,%esp
  8001c8:	68 18 3a 80 00       	push   $0x803a18
  8001cd:	e8 08 08 00 00       	call   8009da <cprintf>
  8001d2:	83 c4 10             	add    $0x10,%esp
			cprintf("Congratulations!! The array is sorted correctly\n") ;
  8001d5:	83 ec 0c             	sub    $0xc,%esp
  8001d8:	68 4c 3a 80 00       	push   $0x803a4c
  8001dd:	e8 f8 07 00 00       	call   8009da <cprintf>
  8001e2:	83 c4 10             	add    $0x10,%esp
			cprintf("===============================================\n\n") ;
  8001e5:	83 ec 0c             	sub    $0xc,%esp
  8001e8:	68 80 3a 80 00       	push   $0x803a80
  8001ed:	e8 e8 07 00 00       	call   8009da <cprintf>
  8001f2:	83 c4 10             	add    $0x10,%esp
		}

		//		cprintf("Free Frames After Calculation = %d\n", sys_calculate_free_frames()) ;

		cprintf("Freeing the Heap...\n\n") ;
  8001f5:	83 ec 0c             	sub    $0xc,%esp
  8001f8:	68 b2 3a 80 00       	push   $0x803ab2
  8001fd:	e8 d8 07 00 00       	call   8009da <cprintf>
  800202:	83 c4 10             	add    $0x10,%esp

		//freeHeap() ;

		///========================================================================
		//sys_disable_interrupt();
		cprintf("Do you want to repeat (y/n): ") ;
  800205:	83 ec 0c             	sub    $0xc,%esp
  800208:	68 c8 3a 80 00       	push   $0x803ac8
  80020d:	e8 c8 07 00 00       	call   8009da <cprintf>
  800212:	83 c4 10             	add    $0x10,%esp
		Chose = getchar() ;
  800215:	e8 78 03 00 00       	call   800592 <getchar>
  80021a:	88 45 e7             	mov    %al,-0x19(%ebp)
		cputchar(Chose);
  80021d:	0f be 45 e7          	movsbl -0x19(%ebp),%eax
  800221:	83 ec 0c             	sub    $0xc,%esp
  800224:	50                   	push   %eax
  800225:	e8 20 03 00 00       	call   80054a <cputchar>
  80022a:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80022d:	83 ec 0c             	sub    $0xc,%esp
  800230:	6a 0a                	push   $0xa
  800232:	e8 13 03 00 00       	call   80054a <cputchar>
  800237:	83 c4 10             	add    $0x10,%esp
		cputchar('\n');
  80023a:	83 ec 0c             	sub    $0xc,%esp
  80023d:	6a 0a                	push   $0xa
  80023f:	e8 06 03 00 00       	call   80054a <cputchar>
  800244:	83 c4 10             	add    $0x10,%esp
		//sys_enable_interrupt();

	} while (Chose == 'y');
  800247:	80 7d e7 79          	cmpb   $0x79,-0x19(%ebp)
  80024b:	0f 84 f8 fd ff ff    	je     800049 <_main+0x11>

}
  800251:	90                   	nop
  800252:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800255:	c9                   	leave  
  800256:	c3                   	ret    

00800257 <QuickSort>:

///Quick sort 
void QuickSort(int *Elements, int NumOfElements)
{
  800257:	55                   	push   %ebp
  800258:	89 e5                	mov    %esp,%ebp
  80025a:	83 ec 08             	sub    $0x8,%esp
	QSort(Elements, NumOfElements, 0, NumOfElements-1) ;
  80025d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800260:	48                   	dec    %eax
  800261:	50                   	push   %eax
  800262:	6a 00                	push   $0x0
  800264:	ff 75 0c             	pushl  0xc(%ebp)
  800267:	ff 75 08             	pushl  0x8(%ebp)
  80026a:	e8 06 00 00 00       	call   800275 <QSort>
  80026f:	83 c4 10             	add    $0x10,%esp
}
  800272:	90                   	nop
  800273:	c9                   	leave  
  800274:	c3                   	ret    

00800275 <QSort>:


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
  800275:	55                   	push   %ebp
  800276:	89 e5                	mov    %esp,%ebp
  800278:	83 ec 18             	sub    $0x18,%esp
	if (startIndex >= finalIndex) return;
  80027b:	8b 45 10             	mov    0x10(%ebp),%eax
  80027e:	3b 45 14             	cmp    0x14(%ebp),%eax
  800281:	0f 8d de 00 00 00    	jge    800365 <QSort+0xf0>

	int i = startIndex+1, j = finalIndex;
  800287:	8b 45 10             	mov    0x10(%ebp),%eax
  80028a:	40                   	inc    %eax
  80028b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80028e:	8b 45 14             	mov    0x14(%ebp),%eax
  800291:	89 45 f0             	mov    %eax,-0x10(%ebp)

	while (i <= j)
  800294:	e9 80 00 00 00       	jmp    800319 <QSort+0xa4>
	{
		while (i <= finalIndex && Elements[startIndex] >= Elements[i]) i++;
  800299:	ff 45 f4             	incl   -0xc(%ebp)
  80029c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80029f:	3b 45 14             	cmp    0x14(%ebp),%eax
  8002a2:	7f 2b                	jg     8002cf <QSort+0x5a>
  8002a4:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8002b1:	01 d0                	add    %edx,%eax
  8002b3:	8b 10                	mov    (%eax),%edx
  8002b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8002b8:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c2:	01 c8                	add    %ecx,%eax
  8002c4:	8b 00                	mov    (%eax),%eax
  8002c6:	39 c2                	cmp    %eax,%edx
  8002c8:	7d cf                	jge    800299 <QSort+0x24>
		while (j > startIndex && Elements[startIndex] <= Elements[j]) j--;
  8002ca:	eb 03                	jmp    8002cf <QSort+0x5a>
  8002cc:	ff 4d f0             	decl   -0x10(%ebp)
  8002cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002d2:	3b 45 10             	cmp    0x10(%ebp),%eax
  8002d5:	7e 26                	jle    8002fd <QSort+0x88>
  8002d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8002da:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8002e4:	01 d0                	add    %edx,%eax
  8002e6:	8b 10                	mov    (%eax),%edx
  8002e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8002f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f5:	01 c8                	add    %ecx,%eax
  8002f7:	8b 00                	mov    (%eax),%eax
  8002f9:	39 c2                	cmp    %eax,%edx
  8002fb:	7e cf                	jle    8002cc <QSort+0x57>

		if (i <= j)
  8002fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800300:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800303:	7f 14                	jg     800319 <QSort+0xa4>
		{
			Swap(Elements, i, j);
  800305:	83 ec 04             	sub    $0x4,%esp
  800308:	ff 75 f0             	pushl  -0x10(%ebp)
  80030b:	ff 75 f4             	pushl  -0xc(%ebp)
  80030e:	ff 75 08             	pushl  0x8(%ebp)
  800311:	e8 a9 00 00 00       	call   8003bf <Swap>
  800316:	83 c4 10             	add    $0x10,%esp
{
	if (startIndex >= finalIndex) return;

	int i = startIndex+1, j = finalIndex;

	while (i <= j)
  800319:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80031c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80031f:	0f 8e 77 ff ff ff    	jle    80029c <QSort+0x27>
		{
			Swap(Elements, i, j);
		}
	}

	Swap( Elements, startIndex, j);
  800325:	83 ec 04             	sub    $0x4,%esp
  800328:	ff 75 f0             	pushl  -0x10(%ebp)
  80032b:	ff 75 10             	pushl  0x10(%ebp)
  80032e:	ff 75 08             	pushl  0x8(%ebp)
  800331:	e8 89 00 00 00       	call   8003bf <Swap>
  800336:	83 c4 10             	add    $0x10,%esp

	QSort(Elements, NumOfElements, startIndex, j - 1);
  800339:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80033c:	48                   	dec    %eax
  80033d:	50                   	push   %eax
  80033e:	ff 75 10             	pushl  0x10(%ebp)
  800341:	ff 75 0c             	pushl  0xc(%ebp)
  800344:	ff 75 08             	pushl  0x8(%ebp)
  800347:	e8 29 ff ff ff       	call   800275 <QSort>
  80034c:	83 c4 10             	add    $0x10,%esp
	QSort(Elements, NumOfElements, i, finalIndex);
  80034f:	ff 75 14             	pushl  0x14(%ebp)
  800352:	ff 75 f4             	pushl  -0xc(%ebp)
  800355:	ff 75 0c             	pushl  0xc(%ebp)
  800358:	ff 75 08             	pushl  0x8(%ebp)
  80035b:	e8 15 ff ff ff       	call   800275 <QSort>
  800360:	83 c4 10             	add    $0x10,%esp
  800363:	eb 01                	jmp    800366 <QSort+0xf1>
}


void QSort(int *Elements,int NumOfElements, int startIndex, int finalIndex)
{
	if (startIndex >= finalIndex) return;
  800365:	90                   	nop

	Swap( Elements, startIndex, j);

	QSort(Elements, NumOfElements, startIndex, j - 1);
	QSort(Elements, NumOfElements, i, finalIndex);
}
  800366:	c9                   	leave  
  800367:	c3                   	ret    

00800368 <CheckSorted>:

uint32 CheckSorted(int *Elements, int NumOfElements)
{
  800368:	55                   	push   %ebp
  800369:	89 e5                	mov    %esp,%ebp
  80036b:	83 ec 10             	sub    $0x10,%esp
	uint32 Sorted = 1 ;
  80036e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  800375:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80037c:	eb 33                	jmp    8003b1 <CheckSorted+0x49>
	{
		if (Elements[i] > Elements[i+1])
  80037e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800381:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800388:	8b 45 08             	mov    0x8(%ebp),%eax
  80038b:	01 d0                	add    %edx,%eax
  80038d:	8b 10                	mov    (%eax),%edx
  80038f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800392:	40                   	inc    %eax
  800393:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80039a:	8b 45 08             	mov    0x8(%ebp),%eax
  80039d:	01 c8                	add    %ecx,%eax
  80039f:	8b 00                	mov    (%eax),%eax
  8003a1:	39 c2                	cmp    %eax,%edx
  8003a3:	7e 09                	jle    8003ae <CheckSorted+0x46>
		{
			Sorted = 0 ;
  8003a5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
			break;
  8003ac:	eb 0c                	jmp    8003ba <CheckSorted+0x52>

uint32 CheckSorted(int *Elements, int NumOfElements)
{
	uint32 Sorted = 1 ;
	int i ;
	for (i = 0 ; i < NumOfElements - 1; i++)
  8003ae:	ff 45 f8             	incl   -0x8(%ebp)
  8003b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003b4:	48                   	dec    %eax
  8003b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8003b8:	7f c4                	jg     80037e <CheckSorted+0x16>
		{
			Sorted = 0 ;
			break;
		}
	}
	return Sorted ;
  8003ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8003bd:	c9                   	leave  
  8003be:	c3                   	ret    

008003bf <Swap>:

///Private Functions


void Swap(int *Elements, int First, int Second)
{
  8003bf:	55                   	push   %ebp
  8003c0:	89 e5                	mov    %esp,%ebp
  8003c2:	83 ec 10             	sub    $0x10,%esp
	int Tmp = Elements[First] ;
  8003c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	01 d0                	add    %edx,%eax
  8003d4:	8b 00                	mov    (%eax),%eax
  8003d6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	Elements[First] = Elements[Second] ;
  8003d9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003dc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8003e6:	01 c2                	add    %eax,%edx
  8003e8:	8b 45 10             	mov    0x10(%ebp),%eax
  8003eb:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8003f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8003f5:	01 c8                	add    %ecx,%eax
  8003f7:	8b 00                	mov    (%eax),%eax
  8003f9:	89 02                	mov    %eax,(%edx)
	Elements[Second] = Tmp ;
  8003fb:	8b 45 10             	mov    0x10(%ebp),%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	8b 45 08             	mov    0x8(%ebp),%eax
  800408:	01 c2                	add    %eax,%edx
  80040a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80040d:	89 02                	mov    %eax,(%edx)
}
  80040f:	90                   	nop
  800410:	c9                   	leave  
  800411:	c3                   	ret    

00800412 <InitializeAscending>:

void InitializeAscending(int *Elements, int NumOfElements)
{
  800412:	55                   	push   %ebp
  800413:	89 e5                	mov    %esp,%ebp
  800415:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800418:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80041f:	eb 17                	jmp    800438 <InitializeAscending+0x26>
	{
		(Elements)[i] = i ;
  800421:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800424:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80042b:	8b 45 08             	mov    0x8(%ebp),%eax
  80042e:	01 c2                	add    %eax,%edx
  800430:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800433:	89 02                	mov    %eax,(%edx)
}

void InitializeAscending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800435:	ff 45 fc             	incl   -0x4(%ebp)
  800438:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80043b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80043e:	7c e1                	jl     800421 <InitializeAscending+0xf>
	{
		(Elements)[i] = i ;
	}

}
  800440:	90                   	nop
  800441:	c9                   	leave  
  800442:	c3                   	ret    

00800443 <InitializeDescending>:

void InitializeDescending(int *Elements, int NumOfElements)
{
  800443:	55                   	push   %ebp
  800444:	89 e5                	mov    %esp,%ebp
  800446:	83 ec 10             	sub    $0x10,%esp
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  800449:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800450:	eb 1b                	jmp    80046d <InitializeDescending+0x2a>
	{
		Elements[i] = NumOfElements - i - 1 ;
  800452:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800455:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80045c:	8b 45 08             	mov    0x8(%ebp),%eax
  80045f:	01 c2                	add    %eax,%edx
  800461:	8b 45 0c             	mov    0xc(%ebp),%eax
  800464:	2b 45 fc             	sub    -0x4(%ebp),%eax
  800467:	48                   	dec    %eax
  800468:	89 02                	mov    %eax,(%edx)
}

void InitializeDescending(int *Elements, int NumOfElements)
{
	int i ;
	for (i = 0 ; i < NumOfElements ; i++)
  80046a:	ff 45 fc             	incl   -0x4(%ebp)
  80046d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800470:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800473:	7c dd                	jl     800452 <InitializeDescending+0xf>
	{
		Elements[i] = NumOfElements - i - 1 ;
	}

}
  800475:	90                   	nop
  800476:	c9                   	leave  
  800477:	c3                   	ret    

00800478 <InitializeSemiRandom>:

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
  800478:	55                   	push   %ebp
  800479:	89 e5                	mov    %esp,%ebp
  80047b:	83 ec 10             	sub    $0x10,%esp
	int i ;
	int Repetition = NumOfElements / 3 ;
  80047e:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  800481:	b8 56 55 55 55       	mov    $0x55555556,%eax
  800486:	f7 e9                	imul   %ecx
  800488:	c1 f9 1f             	sar    $0x1f,%ecx
  80048b:	89 d0                	mov    %edx,%eax
  80048d:	29 c8                	sub    %ecx,%eax
  80048f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0 ; i < NumOfElements ; i++)
  800492:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800499:	eb 1e                	jmp    8004b9 <InitializeSemiRandom+0x41>
	{
		Elements[i] = i % Repetition ;
  80049b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80049e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a8:	8d 0c 02             	lea    (%edx,%eax,1),%ecx
  8004ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004ae:	99                   	cltd   
  8004af:	f7 7d f8             	idivl  -0x8(%ebp)
  8004b2:	89 d0                	mov    %edx,%eax
  8004b4:	89 01                	mov    %eax,(%ecx)

void InitializeSemiRandom(int *Elements, int NumOfElements)
{
	int i ;
	int Repetition = NumOfElements / 3 ;
	for (i = 0 ; i < NumOfElements ; i++)
  8004b6:	ff 45 fc             	incl   -0x4(%ebp)
  8004b9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8004bc:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8004bf:	7c da                	jl     80049b <InitializeSemiRandom+0x23>
	{
		Elements[i] = i % Repetition ;
	}

}
  8004c1:	90                   	nop
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <PrintElements>:

void PrintElements(int *Elements, int NumOfElements)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	83 ec 18             	sub    $0x18,%esp
	int i ;
	int NumsPerLine = 20 ;
  8004ca:	c7 45 f0 14 00 00 00 	movl   $0x14,-0x10(%ebp)
	for (i = 0 ; i < NumOfElements-1 ; i++)
  8004d1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  8004d8:	eb 42                	jmp    80051c <PrintElements+0x58>
	{
		if (i%NumsPerLine == 0)
  8004da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004dd:	99                   	cltd   
  8004de:	f7 7d f0             	idivl  -0x10(%ebp)
  8004e1:	89 d0                	mov    %edx,%eax
  8004e3:	85 c0                	test   %eax,%eax
  8004e5:	75 10                	jne    8004f7 <PrintElements+0x33>
			cprintf("\n");
  8004e7:	83 ec 0c             	sub    $0xc,%esp
  8004ea:	68 e6 3a 80 00       	push   $0x803ae6
  8004ef:	e8 e6 04 00 00       	call   8009da <cprintf>
  8004f4:	83 c4 10             	add    $0x10,%esp
		cprintf("%d, ",Elements[i]);
  8004f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8004fa:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800501:	8b 45 08             	mov    0x8(%ebp),%eax
  800504:	01 d0                	add    %edx,%eax
  800506:	8b 00                	mov    (%eax),%eax
  800508:	83 ec 08             	sub    $0x8,%esp
  80050b:	50                   	push   %eax
  80050c:	68 e8 3a 80 00       	push   $0x803ae8
  800511:	e8 c4 04 00 00       	call   8009da <cprintf>
  800516:	83 c4 10             	add    $0x10,%esp

void PrintElements(int *Elements, int NumOfElements)
{
	int i ;
	int NumsPerLine = 20 ;
	for (i = 0 ; i < NumOfElements-1 ; i++)
  800519:	ff 45 f4             	incl   -0xc(%ebp)
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	48                   	dec    %eax
  800520:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  800523:	7f b5                	jg     8004da <PrintElements+0x16>
	{
		if (i%NumsPerLine == 0)
			cprintf("\n");
		cprintf("%d, ",Elements[i]);
	}
	cprintf("%d\n",Elements[i]);
  800525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800528:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80052f:	8b 45 08             	mov    0x8(%ebp),%eax
  800532:	01 d0                	add    %edx,%eax
  800534:	8b 00                	mov    (%eax),%eax
  800536:	83 ec 08             	sub    $0x8,%esp
  800539:	50                   	push   %eax
  80053a:	68 ed 3a 80 00       	push   $0x803aed
  80053f:	e8 96 04 00 00       	call   8009da <cprintf>
  800544:	83 c4 10             	add    $0x10,%esp
}
  800547:	90                   	nop
  800548:	c9                   	leave  
  800549:	c3                   	ret    

0080054a <cputchar>:
#include <inc/lib.h>


void
cputchar(int ch)
{
  80054a:	55                   	push   %ebp
  80054b:	89 e5                	mov    %esp,%ebp
  80054d:	83 ec 18             	sub    $0x18,%esp
	char c = ch;
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  800556:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80055a:	83 ec 0c             	sub    $0xc,%esp
  80055d:	50                   	push   %eax
  80055e:	e8 db 1b 00 00       	call   80213e <sys_cputc>
  800563:	83 c4 10             	add    $0x10,%esp
}
  800566:	90                   	nop
  800567:	c9                   	leave  
  800568:	c3                   	ret    

00800569 <atomic_cputchar>:


void
atomic_cputchar(int ch)
{
  800569:	55                   	push   %ebp
  80056a:	89 e5                	mov    %esp,%ebp
  80056c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80056f:	e8 96 1b 00 00       	call   80210a <sys_disable_interrupt>
	char c = ch;
  800574:	8b 45 08             	mov    0x8(%ebp),%eax
  800577:	88 45 f7             	mov    %al,-0x9(%ebp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	//sys_cputs(&c, 1);

	sys_cputc(c);
  80057a:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80057e:	83 ec 0c             	sub    $0xc,%esp
  800581:	50                   	push   %eax
  800582:	e8 b7 1b 00 00       	call   80213e <sys_cputc>
  800587:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  80058a:	e8 95 1b 00 00       	call   802124 <sys_enable_interrupt>
}
  80058f:	90                   	nop
  800590:	c9                   	leave  
  800591:	c3                   	ret    

00800592 <getchar>:

int
getchar(void)
{
  800592:	55                   	push   %ebp
  800593:	89 e5                	mov    %esp,%ebp
  800595:	83 ec 18             	sub    $0x18,%esp

	//return sys_cgetc();
	int c=0;
  800598:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  80059f:	eb 08                	jmp    8005a9 <getchar+0x17>
	{
		c = sys_cgetc();
  8005a1:	e8 df 19 00 00       	call   801f85 <sys_cgetc>
  8005a6:	89 45 f4             	mov    %eax,-0xc(%ebp)
getchar(void)
{

	//return sys_cgetc();
	int c=0;
	while(c == 0)
  8005a9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005ad:	74 f2                	je     8005a1 <getchar+0xf>
	{
		c = sys_cgetc();
	}
	return c;
  8005af:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005b2:	c9                   	leave  
  8005b3:	c3                   	ret    

008005b4 <atomic_getchar>:

int
atomic_getchar(void)
{
  8005b4:	55                   	push   %ebp
  8005b5:	89 e5                	mov    %esp,%ebp
  8005b7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8005ba:	e8 4b 1b 00 00       	call   80210a <sys_disable_interrupt>
	int c=0;
  8005bf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	while(c == 0)
  8005c6:	eb 08                	jmp    8005d0 <atomic_getchar+0x1c>
	{
		c = sys_cgetc();
  8005c8:	e8 b8 19 00 00       	call   801f85 <sys_cgetc>
  8005cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
int
atomic_getchar(void)
{
	sys_disable_interrupt();
	int c=0;
	while(c == 0)
  8005d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8005d4:	74 f2                	je     8005c8 <atomic_getchar+0x14>
	{
		c = sys_cgetc();
	}
	sys_enable_interrupt();
  8005d6:	e8 49 1b 00 00       	call   802124 <sys_enable_interrupt>
	return c;
  8005db:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <iscons>:

int iscons(int fdnum)
{
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
	// used by readline
	return 1;
  8005e3:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8005e8:	5d                   	pop    %ebp
  8005e9:	c3                   	ret    

008005ea <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005ea:	55                   	push   %ebp
  8005eb:	89 e5                	mov    %esp,%ebp
  8005ed:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005f0:	e8 08 1d 00 00       	call   8022fd <sys_getenvindex>
  8005f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005f8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005fb:	89 d0                	mov    %edx,%eax
  8005fd:	c1 e0 03             	shl    $0x3,%eax
  800600:	01 d0                	add    %edx,%eax
  800602:	01 c0                	add    %eax,%eax
  800604:	01 d0                	add    %edx,%eax
  800606:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80060d:	01 d0                	add    %edx,%eax
  80060f:	c1 e0 04             	shl    $0x4,%eax
  800612:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800617:	a3 24 50 80 00       	mov    %eax,0x805024

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80061c:	a1 24 50 80 00       	mov    0x805024,%eax
  800621:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800627:	84 c0                	test   %al,%al
  800629:	74 0f                	je     80063a <libmain+0x50>
		binaryname = myEnv->prog_name;
  80062b:	a1 24 50 80 00       	mov    0x805024,%eax
  800630:	05 5c 05 00 00       	add    $0x55c,%eax
  800635:	a3 00 50 80 00       	mov    %eax,0x805000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  80063a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80063e:	7e 0a                	jle    80064a <libmain+0x60>
		binaryname = argv[0];
  800640:	8b 45 0c             	mov    0xc(%ebp),%eax
  800643:	8b 00                	mov    (%eax),%eax
  800645:	a3 00 50 80 00       	mov    %eax,0x805000

	// call user main routine
	_main(argc, argv);
  80064a:	83 ec 08             	sub    $0x8,%esp
  80064d:	ff 75 0c             	pushl  0xc(%ebp)
  800650:	ff 75 08             	pushl  0x8(%ebp)
  800653:	e8 e0 f9 ff ff       	call   800038 <_main>
  800658:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80065b:	e8 aa 1a 00 00       	call   80210a <sys_disable_interrupt>
	cprintf("**************************************\n");
  800660:	83 ec 0c             	sub    $0xc,%esp
  800663:	68 0c 3b 80 00       	push   $0x803b0c
  800668:	e8 6d 03 00 00       	call   8009da <cprintf>
  80066d:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800670:	a1 24 50 80 00       	mov    0x805024,%eax
  800675:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80067b:	a1 24 50 80 00       	mov    0x805024,%eax
  800680:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800686:	83 ec 04             	sub    $0x4,%esp
  800689:	52                   	push   %edx
  80068a:	50                   	push   %eax
  80068b:	68 34 3b 80 00       	push   $0x803b34
  800690:	e8 45 03 00 00       	call   8009da <cprintf>
  800695:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800698:	a1 24 50 80 00       	mov    0x805024,%eax
  80069d:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  8006a3:	a1 24 50 80 00       	mov    0x805024,%eax
  8006a8:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8006ae:	a1 24 50 80 00       	mov    0x805024,%eax
  8006b3:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8006b9:	51                   	push   %ecx
  8006ba:	52                   	push   %edx
  8006bb:	50                   	push   %eax
  8006bc:	68 5c 3b 80 00       	push   $0x803b5c
  8006c1:	e8 14 03 00 00       	call   8009da <cprintf>
  8006c6:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006c9:	a1 24 50 80 00       	mov    0x805024,%eax
  8006ce:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006d4:	83 ec 08             	sub    $0x8,%esp
  8006d7:	50                   	push   %eax
  8006d8:	68 b4 3b 80 00       	push   $0x803bb4
  8006dd:	e8 f8 02 00 00       	call   8009da <cprintf>
  8006e2:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006e5:	83 ec 0c             	sub    $0xc,%esp
  8006e8:	68 0c 3b 80 00       	push   $0x803b0c
  8006ed:	e8 e8 02 00 00       	call   8009da <cprintf>
  8006f2:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006f5:	e8 2a 1a 00 00       	call   802124 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006fa:	e8 19 00 00 00       	call   800718 <exit>
}
  8006ff:	90                   	nop
  800700:	c9                   	leave  
  800701:	c3                   	ret    

00800702 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800702:	55                   	push   %ebp
  800703:	89 e5                	mov    %esp,%ebp
  800705:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800708:	83 ec 0c             	sub    $0xc,%esp
  80070b:	6a 00                	push   $0x0
  80070d:	e8 b7 1b 00 00       	call   8022c9 <sys_destroy_env>
  800712:	83 c4 10             	add    $0x10,%esp
}
  800715:	90                   	nop
  800716:	c9                   	leave  
  800717:	c3                   	ret    

00800718 <exit>:

void
exit(void)
{
  800718:	55                   	push   %ebp
  800719:	89 e5                	mov    %esp,%ebp
  80071b:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  80071e:	e8 0c 1c 00 00       	call   80232f <sys_exit_env>
}
  800723:	90                   	nop
  800724:	c9                   	leave  
  800725:	c3                   	ret    

00800726 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800726:	55                   	push   %ebp
  800727:	89 e5                	mov    %esp,%ebp
  800729:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  80072c:	8d 45 10             	lea    0x10(%ebp),%eax
  80072f:	83 c0 04             	add    $0x4,%eax
  800732:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800735:	a1 5c 51 80 00       	mov    0x80515c,%eax
  80073a:	85 c0                	test   %eax,%eax
  80073c:	74 16                	je     800754 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80073e:	a1 5c 51 80 00       	mov    0x80515c,%eax
  800743:	83 ec 08             	sub    $0x8,%esp
  800746:	50                   	push   %eax
  800747:	68 c8 3b 80 00       	push   $0x803bc8
  80074c:	e8 89 02 00 00       	call   8009da <cprintf>
  800751:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800754:	a1 00 50 80 00       	mov    0x805000,%eax
  800759:	ff 75 0c             	pushl  0xc(%ebp)
  80075c:	ff 75 08             	pushl  0x8(%ebp)
  80075f:	50                   	push   %eax
  800760:	68 cd 3b 80 00       	push   $0x803bcd
  800765:	e8 70 02 00 00       	call   8009da <cprintf>
  80076a:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80076d:	8b 45 10             	mov    0x10(%ebp),%eax
  800770:	83 ec 08             	sub    $0x8,%esp
  800773:	ff 75 f4             	pushl  -0xc(%ebp)
  800776:	50                   	push   %eax
  800777:	e8 f3 01 00 00       	call   80096f <vcprintf>
  80077c:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80077f:	83 ec 08             	sub    $0x8,%esp
  800782:	6a 00                	push   $0x0
  800784:	68 e9 3b 80 00       	push   $0x803be9
  800789:	e8 e1 01 00 00       	call   80096f <vcprintf>
  80078e:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800791:	e8 82 ff ff ff       	call   800718 <exit>

	// should not return here
	while (1) ;
  800796:	eb fe                	jmp    800796 <_panic+0x70>

00800798 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800798:	55                   	push   %ebp
  800799:	89 e5                	mov    %esp,%ebp
  80079b:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80079e:	a1 24 50 80 00       	mov    0x805024,%eax
  8007a3:	8b 50 74             	mov    0x74(%eax),%edx
  8007a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007a9:	39 c2                	cmp    %eax,%edx
  8007ab:	74 14                	je     8007c1 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8007ad:	83 ec 04             	sub    $0x4,%esp
  8007b0:	68 ec 3b 80 00       	push   $0x803bec
  8007b5:	6a 26                	push   $0x26
  8007b7:	68 38 3c 80 00       	push   $0x803c38
  8007bc:	e8 65 ff ff ff       	call   800726 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8007c1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007c8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007cf:	e9 c2 00 00 00       	jmp    800896 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007d7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007de:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e1:	01 d0                	add    %edx,%eax
  8007e3:	8b 00                	mov    (%eax),%eax
  8007e5:	85 c0                	test   %eax,%eax
  8007e7:	75 08                	jne    8007f1 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007e9:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007ec:	e9 a2 00 00 00       	jmp    800893 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007f1:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007f8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007ff:	eb 69                	jmp    80086a <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800801:	a1 24 50 80 00       	mov    0x805024,%eax
  800806:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80080c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80080f:	89 d0                	mov    %edx,%eax
  800811:	01 c0                	add    %eax,%eax
  800813:	01 d0                	add    %edx,%eax
  800815:	c1 e0 03             	shl    $0x3,%eax
  800818:	01 c8                	add    %ecx,%eax
  80081a:	8a 40 04             	mov    0x4(%eax),%al
  80081d:	84 c0                	test   %al,%al
  80081f:	75 46                	jne    800867 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800821:	a1 24 50 80 00       	mov    0x805024,%eax
  800826:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80082c:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80082f:	89 d0                	mov    %edx,%eax
  800831:	01 c0                	add    %eax,%eax
  800833:	01 d0                	add    %edx,%eax
  800835:	c1 e0 03             	shl    $0x3,%eax
  800838:	01 c8                	add    %ecx,%eax
  80083a:	8b 00                	mov    (%eax),%eax
  80083c:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80083f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800842:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800847:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800849:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084c:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800853:	8b 45 08             	mov    0x8(%ebp),%eax
  800856:	01 c8                	add    %ecx,%eax
  800858:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80085a:	39 c2                	cmp    %eax,%edx
  80085c:	75 09                	jne    800867 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80085e:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800865:	eb 12                	jmp    800879 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800867:	ff 45 e8             	incl   -0x18(%ebp)
  80086a:	a1 24 50 80 00       	mov    0x805024,%eax
  80086f:	8b 50 74             	mov    0x74(%eax),%edx
  800872:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800875:	39 c2                	cmp    %eax,%edx
  800877:	77 88                	ja     800801 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800879:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80087d:	75 14                	jne    800893 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80087f:	83 ec 04             	sub    $0x4,%esp
  800882:	68 44 3c 80 00       	push   $0x803c44
  800887:	6a 3a                	push   $0x3a
  800889:	68 38 3c 80 00       	push   $0x803c38
  80088e:	e8 93 fe ff ff       	call   800726 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800893:	ff 45 f0             	incl   -0x10(%ebp)
  800896:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800899:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80089c:	0f 8c 32 ff ff ff    	jl     8007d4 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  8008a2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008a9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8008b0:	eb 26                	jmp    8008d8 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8008b2:	a1 24 50 80 00       	mov    0x805024,%eax
  8008b7:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8008bd:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8008c0:	89 d0                	mov    %edx,%eax
  8008c2:	01 c0                	add    %eax,%eax
  8008c4:	01 d0                	add    %edx,%eax
  8008c6:	c1 e0 03             	shl    $0x3,%eax
  8008c9:	01 c8                	add    %ecx,%eax
  8008cb:	8a 40 04             	mov    0x4(%eax),%al
  8008ce:	3c 01                	cmp    $0x1,%al
  8008d0:	75 03                	jne    8008d5 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008d2:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008d5:	ff 45 e0             	incl   -0x20(%ebp)
  8008d8:	a1 24 50 80 00       	mov    0x805024,%eax
  8008dd:	8b 50 74             	mov    0x74(%eax),%edx
  8008e0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008e3:	39 c2                	cmp    %eax,%edx
  8008e5:	77 cb                	ja     8008b2 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008ea:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008ed:	74 14                	je     800903 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008ef:	83 ec 04             	sub    $0x4,%esp
  8008f2:	68 98 3c 80 00       	push   $0x803c98
  8008f7:	6a 44                	push   $0x44
  8008f9:	68 38 3c 80 00       	push   $0x803c38
  8008fe:	e8 23 fe ff ff       	call   800726 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800903:	90                   	nop
  800904:	c9                   	leave  
  800905:	c3                   	ret    

00800906 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800906:	55                   	push   %ebp
  800907:	89 e5                	mov    %esp,%ebp
  800909:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  80090c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090f:	8b 00                	mov    (%eax),%eax
  800911:	8d 48 01             	lea    0x1(%eax),%ecx
  800914:	8b 55 0c             	mov    0xc(%ebp),%edx
  800917:	89 0a                	mov    %ecx,(%edx)
  800919:	8b 55 08             	mov    0x8(%ebp),%edx
  80091c:	88 d1                	mov    %dl,%cl
  80091e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800921:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800925:	8b 45 0c             	mov    0xc(%ebp),%eax
  800928:	8b 00                	mov    (%eax),%eax
  80092a:	3d ff 00 00 00       	cmp    $0xff,%eax
  80092f:	75 2c                	jne    80095d <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800931:	a0 28 50 80 00       	mov    0x805028,%al
  800936:	0f b6 c0             	movzbl %al,%eax
  800939:	8b 55 0c             	mov    0xc(%ebp),%edx
  80093c:	8b 12                	mov    (%edx),%edx
  80093e:	89 d1                	mov    %edx,%ecx
  800940:	8b 55 0c             	mov    0xc(%ebp),%edx
  800943:	83 c2 08             	add    $0x8,%edx
  800946:	83 ec 04             	sub    $0x4,%esp
  800949:	50                   	push   %eax
  80094a:	51                   	push   %ecx
  80094b:	52                   	push   %edx
  80094c:	e8 0b 16 00 00       	call   801f5c <sys_cputs>
  800951:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800954:	8b 45 0c             	mov    0xc(%ebp),%eax
  800957:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80095d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800960:	8b 40 04             	mov    0x4(%eax),%eax
  800963:	8d 50 01             	lea    0x1(%eax),%edx
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	89 50 04             	mov    %edx,0x4(%eax)
}
  80096c:	90                   	nop
  80096d:	c9                   	leave  
  80096e:	c3                   	ret    

0080096f <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80096f:	55                   	push   %ebp
  800970:	89 e5                	mov    %esp,%ebp
  800972:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800978:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80097f:	00 00 00 
	b.cnt = 0;
  800982:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800989:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80098c:	ff 75 0c             	pushl  0xc(%ebp)
  80098f:	ff 75 08             	pushl  0x8(%ebp)
  800992:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800998:	50                   	push   %eax
  800999:	68 06 09 80 00       	push   $0x800906
  80099e:	e8 11 02 00 00       	call   800bb4 <vprintfmt>
  8009a3:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  8009a6:	a0 28 50 80 00       	mov    0x805028,%al
  8009ab:	0f b6 c0             	movzbl %al,%eax
  8009ae:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8009b4:	83 ec 04             	sub    $0x4,%esp
  8009b7:	50                   	push   %eax
  8009b8:	52                   	push   %edx
  8009b9:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8009bf:	83 c0 08             	add    $0x8,%eax
  8009c2:	50                   	push   %eax
  8009c3:	e8 94 15 00 00       	call   801f5c <sys_cputs>
  8009c8:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009cb:	c6 05 28 50 80 00 00 	movb   $0x0,0x805028
	return b.cnt;
  8009d2:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009d8:	c9                   	leave  
  8009d9:	c3                   	ret    

008009da <cprintf>:

int cprintf(const char *fmt, ...) {
  8009da:	55                   	push   %ebp
  8009db:	89 e5                	mov    %esp,%ebp
  8009dd:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009e0:	c6 05 28 50 80 00 01 	movb   $0x1,0x805028
	va_start(ap, fmt);
  8009e7:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009ea:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f0:	83 ec 08             	sub    $0x8,%esp
  8009f3:	ff 75 f4             	pushl  -0xc(%ebp)
  8009f6:	50                   	push   %eax
  8009f7:	e8 73 ff ff ff       	call   80096f <vcprintf>
  8009fc:	83 c4 10             	add    $0x10,%esp
  8009ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800a02:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a05:	c9                   	leave  
  800a06:	c3                   	ret    

00800a07 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800a07:	55                   	push   %ebp
  800a08:	89 e5                	mov    %esp,%ebp
  800a0a:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800a0d:	e8 f8 16 00 00       	call   80210a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800a12:	8d 45 0c             	lea    0xc(%ebp),%eax
  800a15:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800a18:	8b 45 08             	mov    0x8(%ebp),%eax
  800a1b:	83 ec 08             	sub    $0x8,%esp
  800a1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a21:	50                   	push   %eax
  800a22:	e8 48 ff ff ff       	call   80096f <vcprintf>
  800a27:	83 c4 10             	add    $0x10,%esp
  800a2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a2d:	e8 f2 16 00 00       	call   802124 <sys_enable_interrupt>
	return cnt;
  800a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a35:	c9                   	leave  
  800a36:	c3                   	ret    

00800a37 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a37:	55                   	push   %ebp
  800a38:	89 e5                	mov    %esp,%ebp
  800a3a:	53                   	push   %ebx
  800a3b:	83 ec 14             	sub    $0x14,%esp
  800a3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800a41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a44:	8b 45 14             	mov    0x14(%ebp),%eax
  800a47:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a4a:	8b 45 18             	mov    0x18(%ebp),%eax
  800a4d:	ba 00 00 00 00       	mov    $0x0,%edx
  800a52:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a55:	77 55                	ja     800aac <printnum+0x75>
  800a57:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a5a:	72 05                	jb     800a61 <printnum+0x2a>
  800a5c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a5f:	77 4b                	ja     800aac <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a61:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a64:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a67:	8b 45 18             	mov    0x18(%ebp),%eax
  800a6a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a6f:	52                   	push   %edx
  800a70:	50                   	push   %eax
  800a71:	ff 75 f4             	pushl  -0xc(%ebp)
  800a74:	ff 75 f0             	pushl  -0x10(%ebp)
  800a77:	e8 68 2c 00 00       	call   8036e4 <__udivdi3>
  800a7c:	83 c4 10             	add    $0x10,%esp
  800a7f:	83 ec 04             	sub    $0x4,%esp
  800a82:	ff 75 20             	pushl  0x20(%ebp)
  800a85:	53                   	push   %ebx
  800a86:	ff 75 18             	pushl  0x18(%ebp)
  800a89:	52                   	push   %edx
  800a8a:	50                   	push   %eax
  800a8b:	ff 75 0c             	pushl  0xc(%ebp)
  800a8e:	ff 75 08             	pushl  0x8(%ebp)
  800a91:	e8 a1 ff ff ff       	call   800a37 <printnum>
  800a96:	83 c4 20             	add    $0x20,%esp
  800a99:	eb 1a                	jmp    800ab5 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a9b:	83 ec 08             	sub    $0x8,%esp
  800a9e:	ff 75 0c             	pushl  0xc(%ebp)
  800aa1:	ff 75 20             	pushl  0x20(%ebp)
  800aa4:	8b 45 08             	mov    0x8(%ebp),%eax
  800aa7:	ff d0                	call   *%eax
  800aa9:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800aac:	ff 4d 1c             	decl   0x1c(%ebp)
  800aaf:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800ab3:	7f e6                	jg     800a9b <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800ab5:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800ab8:	bb 00 00 00 00       	mov    $0x0,%ebx
  800abd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ac0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800ac3:	53                   	push   %ebx
  800ac4:	51                   	push   %ecx
  800ac5:	52                   	push   %edx
  800ac6:	50                   	push   %eax
  800ac7:	e8 28 2d 00 00       	call   8037f4 <__umoddi3>
  800acc:	83 c4 10             	add    $0x10,%esp
  800acf:	05 14 3f 80 00       	add    $0x803f14,%eax
  800ad4:	8a 00                	mov    (%eax),%al
  800ad6:	0f be c0             	movsbl %al,%eax
  800ad9:	83 ec 08             	sub    $0x8,%esp
  800adc:	ff 75 0c             	pushl  0xc(%ebp)
  800adf:	50                   	push   %eax
  800ae0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae3:	ff d0                	call   *%eax
  800ae5:	83 c4 10             	add    $0x10,%esp
}
  800ae8:	90                   	nop
  800ae9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800aec:	c9                   	leave  
  800aed:	c3                   	ret    

00800aee <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800aee:	55                   	push   %ebp
  800aef:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800af1:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800af5:	7e 1c                	jle    800b13 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	8b 00                	mov    (%eax),%eax
  800afc:	8d 50 08             	lea    0x8(%eax),%edx
  800aff:	8b 45 08             	mov    0x8(%ebp),%eax
  800b02:	89 10                	mov    %edx,(%eax)
  800b04:	8b 45 08             	mov    0x8(%ebp),%eax
  800b07:	8b 00                	mov    (%eax),%eax
  800b09:	83 e8 08             	sub    $0x8,%eax
  800b0c:	8b 50 04             	mov    0x4(%eax),%edx
  800b0f:	8b 00                	mov    (%eax),%eax
  800b11:	eb 40                	jmp    800b53 <getuint+0x65>
	else if (lflag)
  800b13:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b17:	74 1e                	je     800b37 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800b19:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1c:	8b 00                	mov    (%eax),%eax
  800b1e:	8d 50 04             	lea    0x4(%eax),%edx
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	89 10                	mov    %edx,(%eax)
  800b26:	8b 45 08             	mov    0x8(%ebp),%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	83 e8 04             	sub    $0x4,%eax
  800b2e:	8b 00                	mov    (%eax),%eax
  800b30:	ba 00 00 00 00       	mov    $0x0,%edx
  800b35:	eb 1c                	jmp    800b53 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b37:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3a:	8b 00                	mov    (%eax),%eax
  800b3c:	8d 50 04             	lea    0x4(%eax),%edx
  800b3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b42:	89 10                	mov    %edx,(%eax)
  800b44:	8b 45 08             	mov    0x8(%ebp),%eax
  800b47:	8b 00                	mov    (%eax),%eax
  800b49:	83 e8 04             	sub    $0x4,%eax
  800b4c:	8b 00                	mov    (%eax),%eax
  800b4e:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b53:	5d                   	pop    %ebp
  800b54:	c3                   	ret    

00800b55 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b55:	55                   	push   %ebp
  800b56:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b58:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b5c:	7e 1c                	jle    800b7a <getint+0x25>
		return va_arg(*ap, long long);
  800b5e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b61:	8b 00                	mov    (%eax),%eax
  800b63:	8d 50 08             	lea    0x8(%eax),%edx
  800b66:	8b 45 08             	mov    0x8(%ebp),%eax
  800b69:	89 10                	mov    %edx,(%eax)
  800b6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6e:	8b 00                	mov    (%eax),%eax
  800b70:	83 e8 08             	sub    $0x8,%eax
  800b73:	8b 50 04             	mov    0x4(%eax),%edx
  800b76:	8b 00                	mov    (%eax),%eax
  800b78:	eb 38                	jmp    800bb2 <getint+0x5d>
	else if (lflag)
  800b7a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b7e:	74 1a                	je     800b9a <getint+0x45>
		return va_arg(*ap, long);
  800b80:	8b 45 08             	mov    0x8(%ebp),%eax
  800b83:	8b 00                	mov    (%eax),%eax
  800b85:	8d 50 04             	lea    0x4(%eax),%edx
  800b88:	8b 45 08             	mov    0x8(%ebp),%eax
  800b8b:	89 10                	mov    %edx,(%eax)
  800b8d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b90:	8b 00                	mov    (%eax),%eax
  800b92:	83 e8 04             	sub    $0x4,%eax
  800b95:	8b 00                	mov    (%eax),%eax
  800b97:	99                   	cltd   
  800b98:	eb 18                	jmp    800bb2 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b9d:	8b 00                	mov    (%eax),%eax
  800b9f:	8d 50 04             	lea    0x4(%eax),%edx
  800ba2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ba5:	89 10                	mov    %edx,(%eax)
  800ba7:	8b 45 08             	mov    0x8(%ebp),%eax
  800baa:	8b 00                	mov    (%eax),%eax
  800bac:	83 e8 04             	sub    $0x4,%eax
  800baf:	8b 00                	mov    (%eax),%eax
  800bb1:	99                   	cltd   
}
  800bb2:	5d                   	pop    %ebp
  800bb3:	c3                   	ret    

00800bb4 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800bb4:	55                   	push   %ebp
  800bb5:	89 e5                	mov    %esp,%ebp
  800bb7:	56                   	push   %esi
  800bb8:	53                   	push   %ebx
  800bb9:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bbc:	eb 17                	jmp    800bd5 <vprintfmt+0x21>
			if (ch == '\0')
  800bbe:	85 db                	test   %ebx,%ebx
  800bc0:	0f 84 af 03 00 00    	je     800f75 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800bc6:	83 ec 08             	sub    $0x8,%esp
  800bc9:	ff 75 0c             	pushl  0xc(%ebp)
  800bcc:	53                   	push   %ebx
  800bcd:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd0:	ff d0                	call   *%eax
  800bd2:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bd5:	8b 45 10             	mov    0x10(%ebp),%eax
  800bd8:	8d 50 01             	lea    0x1(%eax),%edx
  800bdb:	89 55 10             	mov    %edx,0x10(%ebp)
  800bde:	8a 00                	mov    (%eax),%al
  800be0:	0f b6 d8             	movzbl %al,%ebx
  800be3:	83 fb 25             	cmp    $0x25,%ebx
  800be6:	75 d6                	jne    800bbe <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800be8:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bec:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bf3:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bfa:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800c01:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800c08:	8b 45 10             	mov    0x10(%ebp),%eax
  800c0b:	8d 50 01             	lea    0x1(%eax),%edx
  800c0e:	89 55 10             	mov    %edx,0x10(%ebp)
  800c11:	8a 00                	mov    (%eax),%al
  800c13:	0f b6 d8             	movzbl %al,%ebx
  800c16:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800c19:	83 f8 55             	cmp    $0x55,%eax
  800c1c:	0f 87 2b 03 00 00    	ja     800f4d <vprintfmt+0x399>
  800c22:	8b 04 85 38 3f 80 00 	mov    0x803f38(,%eax,4),%eax
  800c29:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c2b:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c2f:	eb d7                	jmp    800c08 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c31:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c35:	eb d1                	jmp    800c08 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c37:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c3e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c41:	89 d0                	mov    %edx,%eax
  800c43:	c1 e0 02             	shl    $0x2,%eax
  800c46:	01 d0                	add    %edx,%eax
  800c48:	01 c0                	add    %eax,%eax
  800c4a:	01 d8                	add    %ebx,%eax
  800c4c:	83 e8 30             	sub    $0x30,%eax
  800c4f:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c52:	8b 45 10             	mov    0x10(%ebp),%eax
  800c55:	8a 00                	mov    (%eax),%al
  800c57:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c5a:	83 fb 2f             	cmp    $0x2f,%ebx
  800c5d:	7e 3e                	jle    800c9d <vprintfmt+0xe9>
  800c5f:	83 fb 39             	cmp    $0x39,%ebx
  800c62:	7f 39                	jg     800c9d <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c64:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c67:	eb d5                	jmp    800c3e <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c69:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6c:	83 c0 04             	add    $0x4,%eax
  800c6f:	89 45 14             	mov    %eax,0x14(%ebp)
  800c72:	8b 45 14             	mov    0x14(%ebp),%eax
  800c75:	83 e8 04             	sub    $0x4,%eax
  800c78:	8b 00                	mov    (%eax),%eax
  800c7a:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c7d:	eb 1f                	jmp    800c9e <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c83:	79 83                	jns    800c08 <vprintfmt+0x54>
				width = 0;
  800c85:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c8c:	e9 77 ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c91:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c98:	e9 6b ff ff ff       	jmp    800c08 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c9d:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c9e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ca2:	0f 89 60 ff ff ff    	jns    800c08 <vprintfmt+0x54>
				width = precision, precision = -1;
  800ca8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800cab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800cae:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800cb5:	e9 4e ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800cba:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800cbd:	e9 46 ff ff ff       	jmp    800c08 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800cc2:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc5:	83 c0 04             	add    $0x4,%eax
  800cc8:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccb:	8b 45 14             	mov    0x14(%ebp),%eax
  800cce:	83 e8 04             	sub    $0x4,%eax
  800cd1:	8b 00                	mov    (%eax),%eax
  800cd3:	83 ec 08             	sub    $0x8,%esp
  800cd6:	ff 75 0c             	pushl  0xc(%ebp)
  800cd9:	50                   	push   %eax
  800cda:	8b 45 08             	mov    0x8(%ebp),%eax
  800cdd:	ff d0                	call   *%eax
  800cdf:	83 c4 10             	add    $0x10,%esp
			break;
  800ce2:	e9 89 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800ce7:	8b 45 14             	mov    0x14(%ebp),%eax
  800cea:	83 c0 04             	add    $0x4,%eax
  800ced:	89 45 14             	mov    %eax,0x14(%ebp)
  800cf0:	8b 45 14             	mov    0x14(%ebp),%eax
  800cf3:	83 e8 04             	sub    $0x4,%eax
  800cf6:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cf8:	85 db                	test   %ebx,%ebx
  800cfa:	79 02                	jns    800cfe <vprintfmt+0x14a>
				err = -err;
  800cfc:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cfe:	83 fb 64             	cmp    $0x64,%ebx
  800d01:	7f 0b                	jg     800d0e <vprintfmt+0x15a>
  800d03:	8b 34 9d 80 3d 80 00 	mov    0x803d80(,%ebx,4),%esi
  800d0a:	85 f6                	test   %esi,%esi
  800d0c:	75 19                	jne    800d27 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800d0e:	53                   	push   %ebx
  800d0f:	68 25 3f 80 00       	push   $0x803f25
  800d14:	ff 75 0c             	pushl  0xc(%ebp)
  800d17:	ff 75 08             	pushl  0x8(%ebp)
  800d1a:	e8 5e 02 00 00       	call   800f7d <printfmt>
  800d1f:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800d22:	e9 49 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d27:	56                   	push   %esi
  800d28:	68 2e 3f 80 00       	push   $0x803f2e
  800d2d:	ff 75 0c             	pushl  0xc(%ebp)
  800d30:	ff 75 08             	pushl  0x8(%ebp)
  800d33:	e8 45 02 00 00       	call   800f7d <printfmt>
  800d38:	83 c4 10             	add    $0x10,%esp
			break;
  800d3b:	e9 30 02 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d40:	8b 45 14             	mov    0x14(%ebp),%eax
  800d43:	83 c0 04             	add    $0x4,%eax
  800d46:	89 45 14             	mov    %eax,0x14(%ebp)
  800d49:	8b 45 14             	mov    0x14(%ebp),%eax
  800d4c:	83 e8 04             	sub    $0x4,%eax
  800d4f:	8b 30                	mov    (%eax),%esi
  800d51:	85 f6                	test   %esi,%esi
  800d53:	75 05                	jne    800d5a <vprintfmt+0x1a6>
				p = "(null)";
  800d55:	be 31 3f 80 00       	mov    $0x803f31,%esi
			if (width > 0 && padc != '-')
  800d5a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d5e:	7e 6d                	jle    800dcd <vprintfmt+0x219>
  800d60:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d64:	74 67                	je     800dcd <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d66:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d69:	83 ec 08             	sub    $0x8,%esp
  800d6c:	50                   	push   %eax
  800d6d:	56                   	push   %esi
  800d6e:	e8 12 05 00 00       	call   801285 <strnlen>
  800d73:	83 c4 10             	add    $0x10,%esp
  800d76:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d79:	eb 16                	jmp    800d91 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d7b:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d7f:	83 ec 08             	sub    $0x8,%esp
  800d82:	ff 75 0c             	pushl  0xc(%ebp)
  800d85:	50                   	push   %eax
  800d86:	8b 45 08             	mov    0x8(%ebp),%eax
  800d89:	ff d0                	call   *%eax
  800d8b:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d8e:	ff 4d e4             	decl   -0x1c(%ebp)
  800d91:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d95:	7f e4                	jg     800d7b <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d97:	eb 34                	jmp    800dcd <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d99:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d9d:	74 1c                	je     800dbb <vprintfmt+0x207>
  800d9f:	83 fb 1f             	cmp    $0x1f,%ebx
  800da2:	7e 05                	jle    800da9 <vprintfmt+0x1f5>
  800da4:	83 fb 7e             	cmp    $0x7e,%ebx
  800da7:	7e 12                	jle    800dbb <vprintfmt+0x207>
					putch('?', putdat);
  800da9:	83 ec 08             	sub    $0x8,%esp
  800dac:	ff 75 0c             	pushl  0xc(%ebp)
  800daf:	6a 3f                	push   $0x3f
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	ff d0                	call   *%eax
  800db6:	83 c4 10             	add    $0x10,%esp
  800db9:	eb 0f                	jmp    800dca <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800dbb:	83 ec 08             	sub    $0x8,%esp
  800dbe:	ff 75 0c             	pushl  0xc(%ebp)
  800dc1:	53                   	push   %ebx
  800dc2:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc5:	ff d0                	call   *%eax
  800dc7:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800dca:	ff 4d e4             	decl   -0x1c(%ebp)
  800dcd:	89 f0                	mov    %esi,%eax
  800dcf:	8d 70 01             	lea    0x1(%eax),%esi
  800dd2:	8a 00                	mov    (%eax),%al
  800dd4:	0f be d8             	movsbl %al,%ebx
  800dd7:	85 db                	test   %ebx,%ebx
  800dd9:	74 24                	je     800dff <vprintfmt+0x24b>
  800ddb:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ddf:	78 b8                	js     800d99 <vprintfmt+0x1e5>
  800de1:	ff 4d e0             	decl   -0x20(%ebp)
  800de4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800de8:	79 af                	jns    800d99 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dea:	eb 13                	jmp    800dff <vprintfmt+0x24b>
				putch(' ', putdat);
  800dec:	83 ec 08             	sub    $0x8,%esp
  800def:	ff 75 0c             	pushl  0xc(%ebp)
  800df2:	6a 20                	push   $0x20
  800df4:	8b 45 08             	mov    0x8(%ebp),%eax
  800df7:	ff d0                	call   *%eax
  800df9:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dfc:	ff 4d e4             	decl   -0x1c(%ebp)
  800dff:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800e03:	7f e7                	jg     800dec <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800e05:	e9 66 01 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800e0a:	83 ec 08             	sub    $0x8,%esp
  800e0d:	ff 75 e8             	pushl  -0x18(%ebp)
  800e10:	8d 45 14             	lea    0x14(%ebp),%eax
  800e13:	50                   	push   %eax
  800e14:	e8 3c fd ff ff       	call   800b55 <getint>
  800e19:	83 c4 10             	add    $0x10,%esp
  800e1c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e1f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e28:	85 d2                	test   %edx,%edx
  800e2a:	79 23                	jns    800e4f <vprintfmt+0x29b>
				putch('-', putdat);
  800e2c:	83 ec 08             	sub    $0x8,%esp
  800e2f:	ff 75 0c             	pushl  0xc(%ebp)
  800e32:	6a 2d                	push   $0x2d
  800e34:	8b 45 08             	mov    0x8(%ebp),%eax
  800e37:	ff d0                	call   *%eax
  800e39:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e3f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e42:	f7 d8                	neg    %eax
  800e44:	83 d2 00             	adc    $0x0,%edx
  800e47:	f7 da                	neg    %edx
  800e49:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4c:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e4f:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e56:	e9 bc 00 00 00       	jmp    800f17 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e5b:	83 ec 08             	sub    $0x8,%esp
  800e5e:	ff 75 e8             	pushl  -0x18(%ebp)
  800e61:	8d 45 14             	lea    0x14(%ebp),%eax
  800e64:	50                   	push   %eax
  800e65:	e8 84 fc ff ff       	call   800aee <getuint>
  800e6a:	83 c4 10             	add    $0x10,%esp
  800e6d:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e70:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e73:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e7a:	e9 98 00 00 00       	jmp    800f17 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e7f:	83 ec 08             	sub    $0x8,%esp
  800e82:	ff 75 0c             	pushl  0xc(%ebp)
  800e85:	6a 58                	push   $0x58
  800e87:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8a:	ff d0                	call   *%eax
  800e8c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e8f:	83 ec 08             	sub    $0x8,%esp
  800e92:	ff 75 0c             	pushl  0xc(%ebp)
  800e95:	6a 58                	push   $0x58
  800e97:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9a:	ff d0                	call   *%eax
  800e9c:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e9f:	83 ec 08             	sub    $0x8,%esp
  800ea2:	ff 75 0c             	pushl  0xc(%ebp)
  800ea5:	6a 58                	push   $0x58
  800ea7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eaa:	ff d0                	call   *%eax
  800eac:	83 c4 10             	add    $0x10,%esp
			break;
  800eaf:	e9 bc 00 00 00       	jmp    800f70 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800eb4:	83 ec 08             	sub    $0x8,%esp
  800eb7:	ff 75 0c             	pushl  0xc(%ebp)
  800eba:	6a 30                	push   $0x30
  800ebc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebf:	ff d0                	call   *%eax
  800ec1:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ec4:	83 ec 08             	sub    $0x8,%esp
  800ec7:	ff 75 0c             	pushl  0xc(%ebp)
  800eca:	6a 78                	push   $0x78
  800ecc:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecf:	ff d0                	call   *%eax
  800ed1:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ed4:	8b 45 14             	mov    0x14(%ebp),%eax
  800ed7:	83 c0 04             	add    $0x4,%eax
  800eda:	89 45 14             	mov    %eax,0x14(%ebp)
  800edd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ee0:	83 e8 04             	sub    $0x4,%eax
  800ee3:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ee5:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ee8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800eef:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ef6:	eb 1f                	jmp    800f17 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ef8:	83 ec 08             	sub    $0x8,%esp
  800efb:	ff 75 e8             	pushl  -0x18(%ebp)
  800efe:	8d 45 14             	lea    0x14(%ebp),%eax
  800f01:	50                   	push   %eax
  800f02:	e8 e7 fb ff ff       	call   800aee <getuint>
  800f07:	83 c4 10             	add    $0x10,%esp
  800f0a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f0d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800f10:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800f17:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800f1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f1e:	83 ec 04             	sub    $0x4,%esp
  800f21:	52                   	push   %edx
  800f22:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f25:	50                   	push   %eax
  800f26:	ff 75 f4             	pushl  -0xc(%ebp)
  800f29:	ff 75 f0             	pushl  -0x10(%ebp)
  800f2c:	ff 75 0c             	pushl  0xc(%ebp)
  800f2f:	ff 75 08             	pushl  0x8(%ebp)
  800f32:	e8 00 fb ff ff       	call   800a37 <printnum>
  800f37:	83 c4 20             	add    $0x20,%esp
			break;
  800f3a:	eb 34                	jmp    800f70 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f3c:	83 ec 08             	sub    $0x8,%esp
  800f3f:	ff 75 0c             	pushl  0xc(%ebp)
  800f42:	53                   	push   %ebx
  800f43:	8b 45 08             	mov    0x8(%ebp),%eax
  800f46:	ff d0                	call   *%eax
  800f48:	83 c4 10             	add    $0x10,%esp
			break;
  800f4b:	eb 23                	jmp    800f70 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f4d:	83 ec 08             	sub    $0x8,%esp
  800f50:	ff 75 0c             	pushl  0xc(%ebp)
  800f53:	6a 25                	push   $0x25
  800f55:	8b 45 08             	mov    0x8(%ebp),%eax
  800f58:	ff d0                	call   *%eax
  800f5a:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f5d:	ff 4d 10             	decl   0x10(%ebp)
  800f60:	eb 03                	jmp    800f65 <vprintfmt+0x3b1>
  800f62:	ff 4d 10             	decl   0x10(%ebp)
  800f65:	8b 45 10             	mov    0x10(%ebp),%eax
  800f68:	48                   	dec    %eax
  800f69:	8a 00                	mov    (%eax),%al
  800f6b:	3c 25                	cmp    $0x25,%al
  800f6d:	75 f3                	jne    800f62 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f6f:	90                   	nop
		}
	}
  800f70:	e9 47 fc ff ff       	jmp    800bbc <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f75:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f76:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f79:	5b                   	pop    %ebx
  800f7a:	5e                   	pop    %esi
  800f7b:	5d                   	pop    %ebp
  800f7c:	c3                   	ret    

00800f7d <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f7d:	55                   	push   %ebp
  800f7e:	89 e5                	mov    %esp,%ebp
  800f80:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f83:	8d 45 10             	lea    0x10(%ebp),%eax
  800f86:	83 c0 04             	add    $0x4,%eax
  800f89:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f8c:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8f:	ff 75 f4             	pushl  -0xc(%ebp)
  800f92:	50                   	push   %eax
  800f93:	ff 75 0c             	pushl  0xc(%ebp)
  800f96:	ff 75 08             	pushl  0x8(%ebp)
  800f99:	e8 16 fc ff ff       	call   800bb4 <vprintfmt>
  800f9e:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800fa1:	90                   	nop
  800fa2:	c9                   	leave  
  800fa3:	c3                   	ret    

00800fa4 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800fa4:	55                   	push   %ebp
  800fa5:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faa:	8b 40 08             	mov    0x8(%eax),%eax
  800fad:	8d 50 01             	lea    0x1(%eax),%edx
  800fb0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb3:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	8b 10                	mov    (%eax),%edx
  800fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbe:	8b 40 04             	mov    0x4(%eax),%eax
  800fc1:	39 c2                	cmp    %eax,%edx
  800fc3:	73 12                	jae    800fd7 <sprintputch+0x33>
		*b->buf++ = ch;
  800fc5:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc8:	8b 00                	mov    (%eax),%eax
  800fca:	8d 48 01             	lea    0x1(%eax),%ecx
  800fcd:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fd0:	89 0a                	mov    %ecx,(%edx)
  800fd2:	8b 55 08             	mov    0x8(%ebp),%edx
  800fd5:	88 10                	mov    %dl,(%eax)
}
  800fd7:	90                   	nop
  800fd8:	5d                   	pop    %ebp
  800fd9:	c3                   	ret    

00800fda <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fda:	55                   	push   %ebp
  800fdb:	89 e5                	mov    %esp,%ebp
  800fdd:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fe0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe3:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fec:	8b 45 08             	mov    0x8(%ebp),%eax
  800fef:	01 d0                	add    %edx,%eax
  800ff1:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ff4:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800ffb:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fff:	74 06                	je     801007 <vsnprintf+0x2d>
  801001:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801005:	7f 07                	jg     80100e <vsnprintf+0x34>
		return -E_INVAL;
  801007:	b8 03 00 00 00       	mov    $0x3,%eax
  80100c:	eb 20                	jmp    80102e <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  80100e:	ff 75 14             	pushl  0x14(%ebp)
  801011:	ff 75 10             	pushl  0x10(%ebp)
  801014:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801017:	50                   	push   %eax
  801018:	68 a4 0f 80 00       	push   $0x800fa4
  80101d:	e8 92 fb ff ff       	call   800bb4 <vprintfmt>
  801022:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801025:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801028:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80102b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80102e:	c9                   	leave  
  80102f:	c3                   	ret    

00801030 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  801030:	55                   	push   %ebp
  801031:	89 e5                	mov    %esp,%ebp
  801033:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801036:	8d 45 10             	lea    0x10(%ebp),%eax
  801039:	83 c0 04             	add    $0x4,%eax
  80103c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	ff 75 f4             	pushl  -0xc(%ebp)
  801045:	50                   	push   %eax
  801046:	ff 75 0c             	pushl  0xc(%ebp)
  801049:	ff 75 08             	pushl  0x8(%ebp)
  80104c:	e8 89 ff ff ff       	call   800fda <vsnprintf>
  801051:	83 c4 10             	add    $0x10,%esp
  801054:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801057:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    

0080105c <readline>:
#include <inc/lib.h>

//static char buf[BUFLEN];

void readline(const char *prompt, char* buf)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 18             	sub    $0x18,%esp
		int i, c, echoing;

	if (prompt != NULL)
  801062:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801066:	74 13                	je     80107b <readline+0x1f>
		cprintf("%s", prompt);
  801068:	83 ec 08             	sub    $0x8,%esp
  80106b:	ff 75 08             	pushl  0x8(%ebp)
  80106e:	68 90 40 80 00       	push   $0x804090
  801073:	e8 62 f9 ff ff       	call   8009da <cprintf>
  801078:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80107b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801082:	83 ec 0c             	sub    $0xc,%esp
  801085:	6a 00                	push   $0x0
  801087:	e8 54 f5 ff ff       	call   8005e0 <iscons>
  80108c:	83 c4 10             	add    $0x10,%esp
  80108f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801092:	e8 fb f4 ff ff       	call   800592 <getchar>
  801097:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80109a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80109e:	79 22                	jns    8010c2 <readline+0x66>
			if (c != -E_EOF)
  8010a0:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8010a4:	0f 84 ad 00 00 00    	je     801157 <readline+0xfb>
				cprintf("read error: %e\n", c);
  8010aa:	83 ec 08             	sub    $0x8,%esp
  8010ad:	ff 75 ec             	pushl  -0x14(%ebp)
  8010b0:	68 93 40 80 00       	push   $0x804093
  8010b5:	e8 20 f9 ff ff       	call   8009da <cprintf>
  8010ba:	83 c4 10             	add    $0x10,%esp
			return;
  8010bd:	e9 95 00 00 00       	jmp    801157 <readline+0xfb>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8010c2:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8010c6:	7e 34                	jle    8010fc <readline+0xa0>
  8010c8:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8010cf:	7f 2b                	jg     8010fc <readline+0xa0>
			if (echoing)
  8010d1:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8010d5:	74 0e                	je     8010e5 <readline+0x89>
				cputchar(c);
  8010d7:	83 ec 0c             	sub    $0xc,%esp
  8010da:	ff 75 ec             	pushl  -0x14(%ebp)
  8010dd:	e8 68 f4 ff ff       	call   80054a <cputchar>
  8010e2:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8010e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8010e8:	8d 50 01             	lea    0x1(%eax),%edx
  8010eb:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8010ee:	89 c2                	mov    %eax,%edx
  8010f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010f3:	01 d0                	add    %edx,%eax
  8010f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8010f8:	88 10                	mov    %dl,(%eax)
  8010fa:	eb 56                	jmp    801152 <readline+0xf6>
		} else if (c == '\b' && i > 0) {
  8010fc:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801100:	75 1f                	jne    801121 <readline+0xc5>
  801102:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801106:	7e 19                	jle    801121 <readline+0xc5>
			if (echoing)
  801108:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  80110c:	74 0e                	je     80111c <readline+0xc0>
				cputchar(c);
  80110e:	83 ec 0c             	sub    $0xc,%esp
  801111:	ff 75 ec             	pushl  -0x14(%ebp)
  801114:	e8 31 f4 ff ff       	call   80054a <cputchar>
  801119:	83 c4 10             	add    $0x10,%esp

			i--;
  80111c:	ff 4d f4             	decl   -0xc(%ebp)
  80111f:	eb 31                	jmp    801152 <readline+0xf6>
		} else if (c == '\n' || c == '\r') {
  801121:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801125:	74 0a                	je     801131 <readline+0xd5>
  801127:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80112b:	0f 85 61 ff ff ff    	jne    801092 <readline+0x36>
			if (echoing)
  801131:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801135:	74 0e                	je     801145 <readline+0xe9>
				cputchar(c);
  801137:	83 ec 0c             	sub    $0xc,%esp
  80113a:	ff 75 ec             	pushl  -0x14(%ebp)
  80113d:	e8 08 f4 ff ff       	call   80054a <cputchar>
  801142:	83 c4 10             	add    $0x10,%esp

			buf[i] = 0;
  801145:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801148:	8b 45 0c             	mov    0xc(%ebp),%eax
  80114b:	01 d0                	add    %edx,%eax
  80114d:	c6 00 00             	movb   $0x0,(%eax)
			return;
  801150:	eb 06                	jmp    801158 <readline+0xfc>
		}
	}
  801152:	e9 3b ff ff ff       	jmp    801092 <readline+0x36>
	while (1) {
		c = getchar();
		if (c < 0) {
			if (c != -E_EOF)
				cprintf("read error: %e\n", c);
			return;
  801157:	90                   	nop
			buf[i] = 0;
			return;
		}
	}

}
  801158:	c9                   	leave  
  801159:	c3                   	ret    

0080115a <atomic_readline>:

void atomic_readline(const char *prompt, char* buf)
{
  80115a:	55                   	push   %ebp
  80115b:	89 e5                	mov    %esp,%ebp
  80115d:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  801160:	e8 a5 0f 00 00       	call   80210a <sys_disable_interrupt>
	int i, c, echoing;

	if (prompt != NULL)
  801165:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801169:	74 13                	je     80117e <atomic_readline+0x24>
		cprintf("%s", prompt);
  80116b:	83 ec 08             	sub    $0x8,%esp
  80116e:	ff 75 08             	pushl  0x8(%ebp)
  801171:	68 90 40 80 00       	push   $0x804090
  801176:	e8 5f f8 ff ff       	call   8009da <cprintf>
  80117b:	83 c4 10             	add    $0x10,%esp

	i = 0;
  80117e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	echoing = iscons(0);
  801185:	83 ec 0c             	sub    $0xc,%esp
  801188:	6a 00                	push   $0x0
  80118a:	e8 51 f4 ff ff       	call   8005e0 <iscons>
  80118f:	83 c4 10             	add    $0x10,%esp
  801192:	89 45 f0             	mov    %eax,-0x10(%ebp)
	while (1) {
		c = getchar();
  801195:	e8 f8 f3 ff ff       	call   800592 <getchar>
  80119a:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if (c < 0) {
  80119d:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8011a1:	79 23                	jns    8011c6 <atomic_readline+0x6c>
			if (c != -E_EOF)
  8011a3:	83 7d ec 07          	cmpl   $0x7,-0x14(%ebp)
  8011a7:	74 13                	je     8011bc <atomic_readline+0x62>
				cprintf("read error: %e\n", c);
  8011a9:	83 ec 08             	sub    $0x8,%esp
  8011ac:	ff 75 ec             	pushl  -0x14(%ebp)
  8011af:	68 93 40 80 00       	push   $0x804093
  8011b4:	e8 21 f8 ff ff       	call   8009da <cprintf>
  8011b9:	83 c4 10             	add    $0x10,%esp
			sys_enable_interrupt();
  8011bc:	e8 63 0f 00 00       	call   802124 <sys_enable_interrupt>
			return;
  8011c1:	e9 9a 00 00 00       	jmp    801260 <atomic_readline+0x106>
		} else if (c >= ' ' && i < BUFLEN-1) {
  8011c6:	83 7d ec 1f          	cmpl   $0x1f,-0x14(%ebp)
  8011ca:	7e 34                	jle    801200 <atomic_readline+0xa6>
  8011cc:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  8011d3:	7f 2b                	jg     801200 <atomic_readline+0xa6>
			if (echoing)
  8011d5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8011d9:	74 0e                	je     8011e9 <atomic_readline+0x8f>
				cputchar(c);
  8011db:	83 ec 0c             	sub    $0xc,%esp
  8011de:	ff 75 ec             	pushl  -0x14(%ebp)
  8011e1:	e8 64 f3 ff ff       	call   80054a <cputchar>
  8011e6:	83 c4 10             	add    $0x10,%esp
			buf[i++] = c;
  8011e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8011ec:	8d 50 01             	lea    0x1(%eax),%edx
  8011ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
  8011f2:	89 c2                	mov    %eax,%edx
  8011f4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011f7:	01 d0                	add    %edx,%eax
  8011f9:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8011fc:	88 10                	mov    %dl,(%eax)
  8011fe:	eb 5b                	jmp    80125b <atomic_readline+0x101>
		} else if (c == '\b' && i > 0) {
  801200:	83 7d ec 08          	cmpl   $0x8,-0x14(%ebp)
  801204:	75 1f                	jne    801225 <atomic_readline+0xcb>
  801206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80120a:	7e 19                	jle    801225 <atomic_readline+0xcb>
			if (echoing)
  80120c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801210:	74 0e                	je     801220 <atomic_readline+0xc6>
				cputchar(c);
  801212:	83 ec 0c             	sub    $0xc,%esp
  801215:	ff 75 ec             	pushl  -0x14(%ebp)
  801218:	e8 2d f3 ff ff       	call   80054a <cputchar>
  80121d:	83 c4 10             	add    $0x10,%esp
			i--;
  801220:	ff 4d f4             	decl   -0xc(%ebp)
  801223:	eb 36                	jmp    80125b <atomic_readline+0x101>
		} else if (c == '\n' || c == '\r') {
  801225:	83 7d ec 0a          	cmpl   $0xa,-0x14(%ebp)
  801229:	74 0a                	je     801235 <atomic_readline+0xdb>
  80122b:	83 7d ec 0d          	cmpl   $0xd,-0x14(%ebp)
  80122f:	0f 85 60 ff ff ff    	jne    801195 <atomic_readline+0x3b>
			if (echoing)
  801235:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801239:	74 0e                	je     801249 <atomic_readline+0xef>
				cputchar(c);
  80123b:	83 ec 0c             	sub    $0xc,%esp
  80123e:	ff 75 ec             	pushl  -0x14(%ebp)
  801241:	e8 04 f3 ff ff       	call   80054a <cputchar>
  801246:	83 c4 10             	add    $0x10,%esp
			buf[i] = 0;
  801249:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80124c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80124f:	01 d0                	add    %edx,%eax
  801251:	c6 00 00             	movb   $0x0,(%eax)
			sys_enable_interrupt();
  801254:	e8 cb 0e 00 00       	call   802124 <sys_enable_interrupt>
			return;
  801259:	eb 05                	jmp    801260 <atomic_readline+0x106>
		}
	}
  80125b:	e9 35 ff ff ff       	jmp    801195 <atomic_readline+0x3b>
}
  801260:	c9                   	leave  
  801261:	c3                   	ret    

00801262 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801262:	55                   	push   %ebp
  801263:	89 e5                	mov    %esp,%ebp
  801265:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  801268:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80126f:	eb 06                	jmp    801277 <strlen+0x15>
		n++;
  801271:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  801274:	ff 45 08             	incl   0x8(%ebp)
  801277:	8b 45 08             	mov    0x8(%ebp),%eax
  80127a:	8a 00                	mov    (%eax),%al
  80127c:	84 c0                	test   %al,%al
  80127e:	75 f1                	jne    801271 <strlen+0xf>
		n++;
	return n;
  801280:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801283:	c9                   	leave  
  801284:	c3                   	ret    

00801285 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  801285:	55                   	push   %ebp
  801286:	89 e5                	mov    %esp,%ebp
  801288:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80128b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801292:	eb 09                	jmp    80129d <strnlen+0x18>
		n++;
  801294:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801297:	ff 45 08             	incl   0x8(%ebp)
  80129a:	ff 4d 0c             	decl   0xc(%ebp)
  80129d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a1:	74 09                	je     8012ac <strnlen+0x27>
  8012a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a6:	8a 00                	mov    (%eax),%al
  8012a8:	84 c0                	test   %al,%al
  8012aa:	75 e8                	jne    801294 <strnlen+0xf>
		n++;
	return n;
  8012ac:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012af:	c9                   	leave  
  8012b0:	c3                   	ret    

008012b1 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  8012b1:	55                   	push   %ebp
  8012b2:	89 e5                	mov    %esp,%ebp
  8012b4:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  8012b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ba:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  8012bd:	90                   	nop
  8012be:	8b 45 08             	mov    0x8(%ebp),%eax
  8012c1:	8d 50 01             	lea    0x1(%eax),%edx
  8012c4:	89 55 08             	mov    %edx,0x8(%ebp)
  8012c7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8012ca:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012cd:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8012d0:	8a 12                	mov    (%edx),%dl
  8012d2:	88 10                	mov    %dl,(%eax)
  8012d4:	8a 00                	mov    (%eax),%al
  8012d6:	84 c0                	test   %al,%al
  8012d8:	75 e4                	jne    8012be <strcpy+0xd>
		/* do nothing */;
	return ret;
  8012da:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8012dd:	c9                   	leave  
  8012de:	c3                   	ret    

008012df <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8012df:	55                   	push   %ebp
  8012e0:	89 e5                	mov    %esp,%ebp
  8012e2:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8012e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012e8:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8012eb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012f2:	eb 1f                	jmp    801313 <strncpy+0x34>
		*dst++ = *src;
  8012f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f7:	8d 50 01             	lea    0x1(%eax),%edx
  8012fa:	89 55 08             	mov    %edx,0x8(%ebp)
  8012fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801300:	8a 12                	mov    (%edx),%dl
  801302:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801304:	8b 45 0c             	mov    0xc(%ebp),%eax
  801307:	8a 00                	mov    (%eax),%al
  801309:	84 c0                	test   %al,%al
  80130b:	74 03                	je     801310 <strncpy+0x31>
			src++;
  80130d:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  801310:	ff 45 fc             	incl   -0x4(%ebp)
  801313:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801316:	3b 45 10             	cmp    0x10(%ebp),%eax
  801319:	72 d9                	jb     8012f4 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  80131b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80131e:	c9                   	leave  
  80131f:	c3                   	ret    

00801320 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  801320:	55                   	push   %ebp
  801321:	89 e5                	mov    %esp,%ebp
  801323:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801326:	8b 45 08             	mov    0x8(%ebp),%eax
  801329:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  80132c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801330:	74 30                	je     801362 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801332:	eb 16                	jmp    80134a <strlcpy+0x2a>
			*dst++ = *src++;
  801334:	8b 45 08             	mov    0x8(%ebp),%eax
  801337:	8d 50 01             	lea    0x1(%eax),%edx
  80133a:	89 55 08             	mov    %edx,0x8(%ebp)
  80133d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801340:	8d 4a 01             	lea    0x1(%edx),%ecx
  801343:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  801346:	8a 12                	mov    (%edx),%dl
  801348:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  80134a:	ff 4d 10             	decl   0x10(%ebp)
  80134d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801351:	74 09                	je     80135c <strlcpy+0x3c>
  801353:	8b 45 0c             	mov    0xc(%ebp),%eax
  801356:	8a 00                	mov    (%eax),%al
  801358:	84 c0                	test   %al,%al
  80135a:	75 d8                	jne    801334 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  80135c:	8b 45 08             	mov    0x8(%ebp),%eax
  80135f:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801362:	8b 55 08             	mov    0x8(%ebp),%edx
  801365:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801368:	29 c2                	sub    %eax,%edx
  80136a:	89 d0                	mov    %edx,%eax
}
  80136c:	c9                   	leave  
  80136d:	c3                   	ret    

0080136e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  80136e:	55                   	push   %ebp
  80136f:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801371:	eb 06                	jmp    801379 <strcmp+0xb>
		p++, q++;
  801373:	ff 45 08             	incl   0x8(%ebp)
  801376:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801379:	8b 45 08             	mov    0x8(%ebp),%eax
  80137c:	8a 00                	mov    (%eax),%al
  80137e:	84 c0                	test   %al,%al
  801380:	74 0e                	je     801390 <strcmp+0x22>
  801382:	8b 45 08             	mov    0x8(%ebp),%eax
  801385:	8a 10                	mov    (%eax),%dl
  801387:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138a:	8a 00                	mov    (%eax),%al
  80138c:	38 c2                	cmp    %al,%dl
  80138e:	74 e3                	je     801373 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801390:	8b 45 08             	mov    0x8(%ebp),%eax
  801393:	8a 00                	mov    (%eax),%al
  801395:	0f b6 d0             	movzbl %al,%edx
  801398:	8b 45 0c             	mov    0xc(%ebp),%eax
  80139b:	8a 00                	mov    (%eax),%al
  80139d:	0f b6 c0             	movzbl %al,%eax
  8013a0:	29 c2                	sub    %eax,%edx
  8013a2:	89 d0                	mov    %edx,%eax
}
  8013a4:	5d                   	pop    %ebp
  8013a5:	c3                   	ret    

008013a6 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  8013a6:	55                   	push   %ebp
  8013a7:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  8013a9:	eb 09                	jmp    8013b4 <strncmp+0xe>
		n--, p++, q++;
  8013ab:	ff 4d 10             	decl   0x10(%ebp)
  8013ae:	ff 45 08             	incl   0x8(%ebp)
  8013b1:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  8013b4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013b8:	74 17                	je     8013d1 <strncmp+0x2b>
  8013ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8013bd:	8a 00                	mov    (%eax),%al
  8013bf:	84 c0                	test   %al,%al
  8013c1:	74 0e                	je     8013d1 <strncmp+0x2b>
  8013c3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c6:	8a 10                	mov    (%eax),%dl
  8013c8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cb:	8a 00                	mov    (%eax),%al
  8013cd:	38 c2                	cmp    %al,%dl
  8013cf:	74 da                	je     8013ab <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8013d1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013d5:	75 07                	jne    8013de <strncmp+0x38>
		return 0;
  8013d7:	b8 00 00 00 00       	mov    $0x0,%eax
  8013dc:	eb 14                	jmp    8013f2 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8013de:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e1:	8a 00                	mov    (%eax),%al
  8013e3:	0f b6 d0             	movzbl %al,%edx
  8013e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013e9:	8a 00                	mov    (%eax),%al
  8013eb:	0f b6 c0             	movzbl %al,%eax
  8013ee:	29 c2                	sub    %eax,%edx
  8013f0:	89 d0                	mov    %edx,%eax
}
  8013f2:	5d                   	pop    %ebp
  8013f3:	c3                   	ret    

008013f4 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8013f4:	55                   	push   %ebp
  8013f5:	89 e5                	mov    %esp,%ebp
  8013f7:	83 ec 04             	sub    $0x4,%esp
  8013fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fd:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801400:	eb 12                	jmp    801414 <strchr+0x20>
		if (*s == c)
  801402:	8b 45 08             	mov    0x8(%ebp),%eax
  801405:	8a 00                	mov    (%eax),%al
  801407:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80140a:	75 05                	jne    801411 <strchr+0x1d>
			return (char *) s;
  80140c:	8b 45 08             	mov    0x8(%ebp),%eax
  80140f:	eb 11                	jmp    801422 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801411:	ff 45 08             	incl   0x8(%ebp)
  801414:	8b 45 08             	mov    0x8(%ebp),%eax
  801417:	8a 00                	mov    (%eax),%al
  801419:	84 c0                	test   %al,%al
  80141b:	75 e5                	jne    801402 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80141d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801422:	c9                   	leave  
  801423:	c3                   	ret    

00801424 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801424:	55                   	push   %ebp
  801425:	89 e5                	mov    %esp,%ebp
  801427:	83 ec 04             	sub    $0x4,%esp
  80142a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80142d:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801430:	eb 0d                	jmp    80143f <strfind+0x1b>
		if (*s == c)
  801432:	8b 45 08             	mov    0x8(%ebp),%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80143a:	74 0e                	je     80144a <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80143c:	ff 45 08             	incl   0x8(%ebp)
  80143f:	8b 45 08             	mov    0x8(%ebp),%eax
  801442:	8a 00                	mov    (%eax),%al
  801444:	84 c0                	test   %al,%al
  801446:	75 ea                	jne    801432 <strfind+0xe>
  801448:	eb 01                	jmp    80144b <strfind+0x27>
		if (*s == c)
			break;
  80144a:	90                   	nop
	return (char *) s;
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80144e:	c9                   	leave  
  80144f:	c3                   	ret    

00801450 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801450:	55                   	push   %ebp
  801451:	89 e5                	mov    %esp,%ebp
  801453:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801456:	8b 45 08             	mov    0x8(%ebp),%eax
  801459:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80145c:	8b 45 10             	mov    0x10(%ebp),%eax
  80145f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801462:	eb 0e                	jmp    801472 <memset+0x22>
		*p++ = c;
  801464:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801467:	8d 50 01             	lea    0x1(%eax),%edx
  80146a:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80146d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801470:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801472:	ff 4d f8             	decl   -0x8(%ebp)
  801475:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801479:	79 e9                	jns    801464 <memset+0x14>
		*p++ = c;

	return v;
  80147b:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80147e:	c9                   	leave  
  80147f:	c3                   	ret    

00801480 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801480:	55                   	push   %ebp
  801481:	89 e5                	mov    %esp,%ebp
  801483:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801486:	8b 45 0c             	mov    0xc(%ebp),%eax
  801489:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801492:	eb 16                	jmp    8014aa <memcpy+0x2a>
		*d++ = *s++;
  801494:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801497:	8d 50 01             	lea    0x1(%eax),%edx
  80149a:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80149d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014a0:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014a3:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8014a6:	8a 12                	mov    (%edx),%dl
  8014a8:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  8014aa:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ad:	8d 50 ff             	lea    -0x1(%eax),%edx
  8014b0:	89 55 10             	mov    %edx,0x10(%ebp)
  8014b3:	85 c0                	test   %eax,%eax
  8014b5:	75 dd                	jne    801494 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8014b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8014ba:	c9                   	leave  
  8014bb:	c3                   	ret    

008014bc <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8014bc:	55                   	push   %ebp
  8014bd:	89 e5                	mov    %esp,%ebp
  8014bf:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8014c2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8014ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d1:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014d4:	73 50                	jae    801526 <memmove+0x6a>
  8014d6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8014d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014dc:	01 d0                	add    %edx,%eax
  8014de:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8014e1:	76 43                	jbe    801526 <memmove+0x6a>
		s += n;
  8014e3:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e6:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8014e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8014ec:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8014ef:	eb 10                	jmp    801501 <memmove+0x45>
			*--d = *--s;
  8014f1:	ff 4d f8             	decl   -0x8(%ebp)
  8014f4:	ff 4d fc             	decl   -0x4(%ebp)
  8014f7:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014fa:	8a 10                	mov    (%eax),%dl
  8014fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ff:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801501:	8b 45 10             	mov    0x10(%ebp),%eax
  801504:	8d 50 ff             	lea    -0x1(%eax),%edx
  801507:	89 55 10             	mov    %edx,0x10(%ebp)
  80150a:	85 c0                	test   %eax,%eax
  80150c:	75 e3                	jne    8014f1 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80150e:	eb 23                	jmp    801533 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801510:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801513:	8d 50 01             	lea    0x1(%eax),%edx
  801516:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801519:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80151c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80151f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801522:	8a 12                	mov    (%edx),%dl
  801524:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801526:	8b 45 10             	mov    0x10(%ebp),%eax
  801529:	8d 50 ff             	lea    -0x1(%eax),%edx
  80152c:	89 55 10             	mov    %edx,0x10(%ebp)
  80152f:	85 c0                	test   %eax,%eax
  801531:	75 dd                	jne    801510 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801533:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801536:	c9                   	leave  
  801537:	c3                   	ret    

00801538 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  801538:	55                   	push   %ebp
  801539:	89 e5                	mov    %esp,%ebp
  80153b:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  80153e:	8b 45 08             	mov    0x8(%ebp),%eax
  801541:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801544:	8b 45 0c             	mov    0xc(%ebp),%eax
  801547:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80154a:	eb 2a                	jmp    801576 <memcmp+0x3e>
		if (*s1 != *s2)
  80154c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80154f:	8a 10                	mov    (%eax),%dl
  801551:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801554:	8a 00                	mov    (%eax),%al
  801556:	38 c2                	cmp    %al,%dl
  801558:	74 16                	je     801570 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80155a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80155d:	8a 00                	mov    (%eax),%al
  80155f:	0f b6 d0             	movzbl %al,%edx
  801562:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801565:	8a 00                	mov    (%eax),%al
  801567:	0f b6 c0             	movzbl %al,%eax
  80156a:	29 c2                	sub    %eax,%edx
  80156c:	89 d0                	mov    %edx,%eax
  80156e:	eb 18                	jmp    801588 <memcmp+0x50>
		s1++, s2++;
  801570:	ff 45 fc             	incl   -0x4(%ebp)
  801573:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801576:	8b 45 10             	mov    0x10(%ebp),%eax
  801579:	8d 50 ff             	lea    -0x1(%eax),%edx
  80157c:	89 55 10             	mov    %edx,0x10(%ebp)
  80157f:	85 c0                	test   %eax,%eax
  801581:	75 c9                	jne    80154c <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801583:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801588:	c9                   	leave  
  801589:	c3                   	ret    

0080158a <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80158a:	55                   	push   %ebp
  80158b:	89 e5                	mov    %esp,%ebp
  80158d:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801590:	8b 55 08             	mov    0x8(%ebp),%edx
  801593:	8b 45 10             	mov    0x10(%ebp),%eax
  801596:	01 d0                	add    %edx,%eax
  801598:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80159b:	eb 15                	jmp    8015b2 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80159d:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a0:	8a 00                	mov    (%eax),%al
  8015a2:	0f b6 d0             	movzbl %al,%edx
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	0f b6 c0             	movzbl %al,%eax
  8015ab:	39 c2                	cmp    %eax,%edx
  8015ad:	74 0d                	je     8015bc <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8015af:	ff 45 08             	incl   0x8(%ebp)
  8015b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b5:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8015b8:	72 e3                	jb     80159d <memfind+0x13>
  8015ba:	eb 01                	jmp    8015bd <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8015bc:	90                   	nop
	return (void *) s;
  8015bd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
  8015c5:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8015c8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8015cf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015d6:	eb 03                	jmp    8015db <strtol+0x19>
		s++;
  8015d8:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8015db:	8b 45 08             	mov    0x8(%ebp),%eax
  8015de:	8a 00                	mov    (%eax),%al
  8015e0:	3c 20                	cmp    $0x20,%al
  8015e2:	74 f4                	je     8015d8 <strtol+0x16>
  8015e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e7:	8a 00                	mov    (%eax),%al
  8015e9:	3c 09                	cmp    $0x9,%al
  8015eb:	74 eb                	je     8015d8 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8015ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8015f0:	8a 00                	mov    (%eax),%al
  8015f2:	3c 2b                	cmp    $0x2b,%al
  8015f4:	75 05                	jne    8015fb <strtol+0x39>
		s++;
  8015f6:	ff 45 08             	incl   0x8(%ebp)
  8015f9:	eb 13                	jmp    80160e <strtol+0x4c>
	else if (*s == '-')
  8015fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fe:	8a 00                	mov    (%eax),%al
  801600:	3c 2d                	cmp    $0x2d,%al
  801602:	75 0a                	jne    80160e <strtol+0x4c>
		s++, neg = 1;
  801604:	ff 45 08             	incl   0x8(%ebp)
  801607:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80160e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801612:	74 06                	je     80161a <strtol+0x58>
  801614:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801618:	75 20                	jne    80163a <strtol+0x78>
  80161a:	8b 45 08             	mov    0x8(%ebp),%eax
  80161d:	8a 00                	mov    (%eax),%al
  80161f:	3c 30                	cmp    $0x30,%al
  801621:	75 17                	jne    80163a <strtol+0x78>
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
  801626:	40                   	inc    %eax
  801627:	8a 00                	mov    (%eax),%al
  801629:	3c 78                	cmp    $0x78,%al
  80162b:	75 0d                	jne    80163a <strtol+0x78>
		s += 2, base = 16;
  80162d:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801631:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  801638:	eb 28                	jmp    801662 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80163a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163e:	75 15                	jne    801655 <strtol+0x93>
  801640:	8b 45 08             	mov    0x8(%ebp),%eax
  801643:	8a 00                	mov    (%eax),%al
  801645:	3c 30                	cmp    $0x30,%al
  801647:	75 0c                	jne    801655 <strtol+0x93>
		s++, base = 8;
  801649:	ff 45 08             	incl   0x8(%ebp)
  80164c:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801653:	eb 0d                	jmp    801662 <strtol+0xa0>
	else if (base == 0)
  801655:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801659:	75 07                	jne    801662 <strtol+0xa0>
		base = 10;
  80165b:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801662:	8b 45 08             	mov    0x8(%ebp),%eax
  801665:	8a 00                	mov    (%eax),%al
  801667:	3c 2f                	cmp    $0x2f,%al
  801669:	7e 19                	jle    801684 <strtol+0xc2>
  80166b:	8b 45 08             	mov    0x8(%ebp),%eax
  80166e:	8a 00                	mov    (%eax),%al
  801670:	3c 39                	cmp    $0x39,%al
  801672:	7f 10                	jg     801684 <strtol+0xc2>
			dig = *s - '0';
  801674:	8b 45 08             	mov    0x8(%ebp),%eax
  801677:	8a 00                	mov    (%eax),%al
  801679:	0f be c0             	movsbl %al,%eax
  80167c:	83 e8 30             	sub    $0x30,%eax
  80167f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801682:	eb 42                	jmp    8016c6 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801684:	8b 45 08             	mov    0x8(%ebp),%eax
  801687:	8a 00                	mov    (%eax),%al
  801689:	3c 60                	cmp    $0x60,%al
  80168b:	7e 19                	jle    8016a6 <strtol+0xe4>
  80168d:	8b 45 08             	mov    0x8(%ebp),%eax
  801690:	8a 00                	mov    (%eax),%al
  801692:	3c 7a                	cmp    $0x7a,%al
  801694:	7f 10                	jg     8016a6 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	8a 00                	mov    (%eax),%al
  80169b:	0f be c0             	movsbl %al,%eax
  80169e:	83 e8 57             	sub    $0x57,%eax
  8016a1:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8016a4:	eb 20                	jmp    8016c6 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	8a 00                	mov    (%eax),%al
  8016ab:	3c 40                	cmp    $0x40,%al
  8016ad:	7e 39                	jle    8016e8 <strtol+0x126>
  8016af:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b2:	8a 00                	mov    (%eax),%al
  8016b4:	3c 5a                	cmp    $0x5a,%al
  8016b6:	7f 30                	jg     8016e8 <strtol+0x126>
			dig = *s - 'A' + 10;
  8016b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8016bb:	8a 00                	mov    (%eax),%al
  8016bd:	0f be c0             	movsbl %al,%eax
  8016c0:	83 e8 37             	sub    $0x37,%eax
  8016c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8016c6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016c9:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016cc:	7d 19                	jge    8016e7 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8016ce:	ff 45 08             	incl   0x8(%ebp)
  8016d1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016d8:	89 c2                	mov    %eax,%edx
  8016da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016dd:	01 d0                	add    %edx,%eax
  8016df:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8016e2:	e9 7b ff ff ff       	jmp    801662 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8016e7:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8016e8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016ec:	74 08                	je     8016f6 <strtol+0x134>
		*endptr = (char *) s;
  8016ee:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016f1:	8b 55 08             	mov    0x8(%ebp),%edx
  8016f4:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8016f6:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016fa:	74 07                	je     801703 <strtol+0x141>
  8016fc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016ff:	f7 d8                	neg    %eax
  801701:	eb 03                	jmp    801706 <strtol+0x144>
  801703:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801706:	c9                   	leave  
  801707:	c3                   	ret    

00801708 <ltostr>:

void
ltostr(long value, char *str)
{
  801708:	55                   	push   %ebp
  801709:	89 e5                	mov    %esp,%ebp
  80170b:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80170e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801715:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80171c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801720:	79 13                	jns    801735 <ltostr+0x2d>
	{
		neg = 1;
  801722:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801729:	8b 45 0c             	mov    0xc(%ebp),%eax
  80172c:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80172f:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801732:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801735:	8b 45 08             	mov    0x8(%ebp),%eax
  801738:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80173d:	99                   	cltd   
  80173e:	f7 f9                	idiv   %ecx
  801740:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801743:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801746:	8d 50 01             	lea    0x1(%eax),%edx
  801749:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80174c:	89 c2                	mov    %eax,%edx
  80174e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801751:	01 d0                	add    %edx,%eax
  801753:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801756:	83 c2 30             	add    $0x30,%edx
  801759:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80175b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80175e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801763:	f7 e9                	imul   %ecx
  801765:	c1 fa 02             	sar    $0x2,%edx
  801768:	89 c8                	mov    %ecx,%eax
  80176a:	c1 f8 1f             	sar    $0x1f,%eax
  80176d:	29 c2                	sub    %eax,%edx
  80176f:	89 d0                	mov    %edx,%eax
  801771:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801774:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801777:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80177c:	f7 e9                	imul   %ecx
  80177e:	c1 fa 02             	sar    $0x2,%edx
  801781:	89 c8                	mov    %ecx,%eax
  801783:	c1 f8 1f             	sar    $0x1f,%eax
  801786:	29 c2                	sub    %eax,%edx
  801788:	89 d0                	mov    %edx,%eax
  80178a:	c1 e0 02             	shl    $0x2,%eax
  80178d:	01 d0                	add    %edx,%eax
  80178f:	01 c0                	add    %eax,%eax
  801791:	29 c1                	sub    %eax,%ecx
  801793:	89 ca                	mov    %ecx,%edx
  801795:	85 d2                	test   %edx,%edx
  801797:	75 9c                	jne    801735 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801799:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  8017a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8017a3:	48                   	dec    %eax
  8017a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  8017a7:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8017ab:	74 3d                	je     8017ea <ltostr+0xe2>
		start = 1 ;
  8017ad:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8017b4:	eb 34                	jmp    8017ea <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8017b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017b9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017bc:	01 d0                	add    %edx,%eax
  8017be:	8a 00                	mov    (%eax),%al
  8017c0:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8017c3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8017c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017c9:	01 c2                	add    %eax,%edx
  8017cb:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8017ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017d1:	01 c8                	add    %ecx,%eax
  8017d3:	8a 00                	mov    (%eax),%al
  8017d5:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8017d7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8017da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017dd:	01 c2                	add    %eax,%edx
  8017df:	8a 45 eb             	mov    -0x15(%ebp),%al
  8017e2:	88 02                	mov    %al,(%edx)
		start++ ;
  8017e4:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8017e7:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8017ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8017ed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8017f0:	7c c4                	jl     8017b6 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8017f2:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8017f5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8017f8:	01 d0                	add    %edx,%eax
  8017fa:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8017fd:	90                   	nop
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
  801803:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801806:	ff 75 08             	pushl  0x8(%ebp)
  801809:	e8 54 fa ff ff       	call   801262 <strlen>
  80180e:	83 c4 04             	add    $0x4,%esp
  801811:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801814:	ff 75 0c             	pushl  0xc(%ebp)
  801817:	e8 46 fa ff ff       	call   801262 <strlen>
  80181c:	83 c4 04             	add    $0x4,%esp
  80181f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801822:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801829:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801830:	eb 17                	jmp    801849 <strcconcat+0x49>
		final[s] = str1[s] ;
  801832:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801835:	8b 45 10             	mov    0x10(%ebp),%eax
  801838:	01 c2                	add    %eax,%edx
  80183a:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80183d:	8b 45 08             	mov    0x8(%ebp),%eax
  801840:	01 c8                	add    %ecx,%eax
  801842:	8a 00                	mov    (%eax),%al
  801844:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801846:	ff 45 fc             	incl   -0x4(%ebp)
  801849:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80184c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80184f:	7c e1                	jl     801832 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801851:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801858:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80185f:	eb 1f                	jmp    801880 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801861:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801864:	8d 50 01             	lea    0x1(%eax),%edx
  801867:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80186a:	89 c2                	mov    %eax,%edx
  80186c:	8b 45 10             	mov    0x10(%ebp),%eax
  80186f:	01 c2                	add    %eax,%edx
  801871:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801874:	8b 45 0c             	mov    0xc(%ebp),%eax
  801877:	01 c8                	add    %ecx,%eax
  801879:	8a 00                	mov    (%eax),%al
  80187b:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80187d:	ff 45 f8             	incl   -0x8(%ebp)
  801880:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801883:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801886:	7c d9                	jl     801861 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801888:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80188b:	8b 45 10             	mov    0x10(%ebp),%eax
  80188e:	01 d0                	add    %edx,%eax
  801890:	c6 00 00             	movb   $0x0,(%eax)
}
  801893:	90                   	nop
  801894:	c9                   	leave  
  801895:	c3                   	ret    

00801896 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801896:	55                   	push   %ebp
  801897:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801899:	8b 45 14             	mov    0x14(%ebp),%eax
  80189c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  8018a2:	8b 45 14             	mov    0x14(%ebp),%eax
  8018a5:	8b 00                	mov    (%eax),%eax
  8018a7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8018ae:	8b 45 10             	mov    0x10(%ebp),%eax
  8018b1:	01 d0                	add    %edx,%eax
  8018b3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018b9:	eb 0c                	jmp    8018c7 <strsplit+0x31>
			*string++ = 0;
  8018bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8018be:	8d 50 01             	lea    0x1(%eax),%edx
  8018c1:	89 55 08             	mov    %edx,0x8(%ebp)
  8018c4:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8018c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018ca:	8a 00                	mov    (%eax),%al
  8018cc:	84 c0                	test   %al,%al
  8018ce:	74 18                	je     8018e8 <strsplit+0x52>
  8018d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8018d3:	8a 00                	mov    (%eax),%al
  8018d5:	0f be c0             	movsbl %al,%eax
  8018d8:	50                   	push   %eax
  8018d9:	ff 75 0c             	pushl  0xc(%ebp)
  8018dc:	e8 13 fb ff ff       	call   8013f4 <strchr>
  8018e1:	83 c4 08             	add    $0x8,%esp
  8018e4:	85 c0                	test   %eax,%eax
  8018e6:	75 d3                	jne    8018bb <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8018e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8018eb:	8a 00                	mov    (%eax),%al
  8018ed:	84 c0                	test   %al,%al
  8018ef:	74 5a                	je     80194b <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8018f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f4:	8b 00                	mov    (%eax),%eax
  8018f6:	83 f8 0f             	cmp    $0xf,%eax
  8018f9:	75 07                	jne    801902 <strsplit+0x6c>
		{
			return 0;
  8018fb:	b8 00 00 00 00       	mov    $0x0,%eax
  801900:	eb 66                	jmp    801968 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801902:	8b 45 14             	mov    0x14(%ebp),%eax
  801905:	8b 00                	mov    (%eax),%eax
  801907:	8d 48 01             	lea    0x1(%eax),%ecx
  80190a:	8b 55 14             	mov    0x14(%ebp),%edx
  80190d:	89 0a                	mov    %ecx,(%edx)
  80190f:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801916:	8b 45 10             	mov    0x10(%ebp),%eax
  801919:	01 c2                	add    %eax,%edx
  80191b:	8b 45 08             	mov    0x8(%ebp),%eax
  80191e:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801920:	eb 03                	jmp    801925 <strsplit+0x8f>
			string++;
  801922:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801925:	8b 45 08             	mov    0x8(%ebp),%eax
  801928:	8a 00                	mov    (%eax),%al
  80192a:	84 c0                	test   %al,%al
  80192c:	74 8b                	je     8018b9 <strsplit+0x23>
  80192e:	8b 45 08             	mov    0x8(%ebp),%eax
  801931:	8a 00                	mov    (%eax),%al
  801933:	0f be c0             	movsbl %al,%eax
  801936:	50                   	push   %eax
  801937:	ff 75 0c             	pushl  0xc(%ebp)
  80193a:	e8 b5 fa ff ff       	call   8013f4 <strchr>
  80193f:	83 c4 08             	add    $0x8,%esp
  801942:	85 c0                	test   %eax,%eax
  801944:	74 dc                	je     801922 <strsplit+0x8c>
			string++;
	}
  801946:	e9 6e ff ff ff       	jmp    8018b9 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80194b:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80194c:	8b 45 14             	mov    0x14(%ebp),%eax
  80194f:	8b 00                	mov    (%eax),%eax
  801951:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801958:	8b 45 10             	mov    0x10(%ebp),%eax
  80195b:	01 d0                	add    %edx,%eax
  80195d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801963:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801968:	c9                   	leave  
  801969:	c3                   	ret    

0080196a <InitializeUHeap>:
//============================== GIVEN FUNCTIONS ===================================//
//==================================================================================//

int FirstTimeFlag = 1;
void InitializeUHeap()
{
  80196a:	55                   	push   %ebp
  80196b:	89 e5                	mov    %esp,%ebp
  80196d:	83 ec 08             	sub    $0x8,%esp
	if(FirstTimeFlag)
  801970:	a1 04 50 80 00       	mov    0x805004,%eax
  801975:	85 c0                	test   %eax,%eax
  801977:	74 1f                	je     801998 <InitializeUHeap+0x2e>
	{
		initialize_dyn_block_system();
  801979:	e8 1d 00 00 00       	call   80199b <initialize_dyn_block_system>
		cprintf("DYNAMIC BLOCK SYSTEM IS INITIALIZED\n");
  80197e:	83 ec 0c             	sub    $0xc,%esp
  801981:	68 a4 40 80 00       	push   $0x8040a4
  801986:	e8 4f f0 ff ff       	call   8009da <cprintf>
  80198b:	83 c4 10             	add    $0x10,%esp
#if UHP_USE_BUDDY
		initialize_buddy();
		cprintf("BUDDY SYSTEM IS INITIALIZED\n");
#endif
		FirstTimeFlag = 0;
  80198e:	c7 05 04 50 80 00 00 	movl   $0x0,0x805004
  801995:	00 00 00 
	}
}
  801998:	90                   	nop
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <initialize_dyn_block_system>:

//=================================
// [1] INITIALIZE DYNAMIC ALLOCATOR:
//=================================
void initialize_dyn_block_system()
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
  80199e:	83 ec 28             	sub    $0x28,%esp
	//[1] Initialize two lists (AllocMemBlocksList & FreeMemBlocksList) [Hint: use LIST_INIT()]
	//[2] Dynamically allocate the array of MemBlockNodes at VA USER_DYN_BLKS_ARRAY
	//	  (remember to set MAX_MEM_BLOCK_CNT with the chosen size of the array)
	//[3] Initialize AvailableMemBlocksList by filling it with the MemBlockNodes
	//[4] Insert a new MemBlock with the heap size into the FreeMemBlocksList
	LIST_INIT(&AllocMemBlocksList);
  8019a1:	c7 05 40 50 80 00 00 	movl   $0x0,0x805040
  8019a8:	00 00 00 
  8019ab:	c7 05 44 50 80 00 00 	movl   $0x0,0x805044
  8019b2:	00 00 00 
  8019b5:	c7 05 4c 50 80 00 00 	movl   $0x0,0x80504c
  8019bc:	00 00 00 
	LIST_INIT(&FreeMemBlocksList);
  8019bf:	c7 05 38 51 80 00 00 	movl   $0x0,0x805138
  8019c6:	00 00 00 
  8019c9:	c7 05 3c 51 80 00 00 	movl   $0x0,0x80513c
  8019d0:	00 00 00 
  8019d3:	c7 05 44 51 80 00 00 	movl   $0x0,0x805144
  8019da:	00 00 00 
	uint32 uheap_size=(USER_HEAP_MAX - USER_HEAP_START);
  8019dd:	c7 45 f4 00 00 00 20 	movl   $0x20000000,-0xc(%ebp)
	MAX_MEM_BLOCK_CNT=uheap_size/PAGE_SIZE;
  8019e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8019e7:	c1 e8 0c             	shr    $0xc,%eax
  8019ea:	a3 20 51 80 00       	mov    %eax,0x805120

	MemBlockNodes=(struct MemBlock *)USER_DYN_BLKS_ARRAY;
  8019ef:	c7 45 f0 00 00 e0 7f 	movl   $0x7fe00000,-0x10(%ebp)
  8019f6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8019f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8019fe:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a03:	a3 50 50 80 00       	mov    %eax,0x805050
		uint32 MEMsize=sizeof(struct MemBlock);
  801a08:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)

		uint32 Tsize=MAX_MEM_BLOCK_CNT*MEMsize;
  801a0f:	a1 20 51 80 00       	mov    0x805120,%eax
  801a14:	0f af 45 ec          	imul   -0x14(%ebp),%eax
  801a18:	89 45 e8             	mov    %eax,-0x18(%ebp)
		Tsize=ROUNDUP(Tsize,PAGE_SIZE);
  801a1b:	c7 45 e4 00 10 00 00 	movl   $0x1000,-0x1c(%ebp)
  801a22:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801a25:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  801a28:	01 d0                	add    %edx,%eax
  801a2a:	48                   	dec    %eax
  801a2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  801a2e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a31:	ba 00 00 00 00       	mov    $0x0,%edx
  801a36:	f7 75 e4             	divl   -0x1c(%ebp)
  801a39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801a3c:	29 d0                	sub    %edx,%eax
  801a3e:	89 45 e8             	mov    %eax,-0x18(%ebp)
		sys_allocate_chunk(USER_DYN_BLKS_ARRAY, Tsize, PERM_WRITEABLE|PERM_PRESENT|PERM_USER);
  801a41:	c7 45 dc 00 00 e0 7f 	movl   $0x7fe00000,-0x24(%ebp)
  801a48:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801a4b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  801a50:	2d 00 10 00 00       	sub    $0x1000,%eax
  801a55:	83 ec 04             	sub    $0x4,%esp
  801a58:	6a 07                	push   $0x7
  801a5a:	ff 75 e8             	pushl  -0x18(%ebp)
  801a5d:	50                   	push   %eax
  801a5e:	e8 3d 06 00 00       	call   8020a0 <sys_allocate_chunk>
  801a63:	83 c4 10             	add    $0x10,%esp

		initialize_MemBlocksList(MAX_MEM_BLOCK_CNT);
  801a66:	a1 20 51 80 00       	mov    0x805120,%eax
  801a6b:	83 ec 0c             	sub    $0xc,%esp
  801a6e:	50                   	push   %eax
  801a6f:	e8 b2 0c 00 00       	call   802726 <initialize_MemBlocksList>
  801a74:	83 c4 10             	add    $0x10,%esp
				struct MemBlock *block= LIST_LAST(&AvailableMemBlocksList);
  801a77:	a1 4c 51 80 00       	mov    0x80514c,%eax
  801a7c:	89 45 d8             	mov    %eax,-0x28(%ebp)
				if(block!= NULL){
  801a7f:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801a83:	0f 84 f3 00 00 00    	je     801b7c <initialize_dyn_block_system+0x1e1>
				LIST_REMOVE(&AvailableMemBlocksList,block);
  801a89:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801a8d:	75 14                	jne    801aa3 <initialize_dyn_block_system+0x108>
  801a8f:	83 ec 04             	sub    $0x4,%esp
  801a92:	68 c9 40 80 00       	push   $0x8040c9
  801a97:	6a 36                	push   $0x36
  801a99:	68 e7 40 80 00       	push   $0x8040e7
  801a9e:	e8 83 ec ff ff       	call   800726 <_panic>
  801aa3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801aa6:	8b 00                	mov    (%eax),%eax
  801aa8:	85 c0                	test   %eax,%eax
  801aaa:	74 10                	je     801abc <initialize_dyn_block_system+0x121>
  801aac:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801aaf:	8b 00                	mov    (%eax),%eax
  801ab1:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ab4:	8b 52 04             	mov    0x4(%edx),%edx
  801ab7:	89 50 04             	mov    %edx,0x4(%eax)
  801aba:	eb 0b                	jmp    801ac7 <initialize_dyn_block_system+0x12c>
  801abc:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801abf:	8b 40 04             	mov    0x4(%eax),%eax
  801ac2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  801ac7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801aca:	8b 40 04             	mov    0x4(%eax),%eax
  801acd:	85 c0                	test   %eax,%eax
  801acf:	74 0f                	je     801ae0 <initialize_dyn_block_system+0x145>
  801ad1:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ad4:	8b 40 04             	mov    0x4(%eax),%eax
  801ad7:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801ada:	8b 12                	mov    (%edx),%edx
  801adc:	89 10                	mov    %edx,(%eax)
  801ade:	eb 0a                	jmp    801aea <initialize_dyn_block_system+0x14f>
  801ae0:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801ae3:	8b 00                	mov    (%eax),%eax
  801ae5:	a3 48 51 80 00       	mov    %eax,0x805148
  801aea:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801aed:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801af3:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801af6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801afd:	a1 54 51 80 00       	mov    0x805154,%eax
  801b02:	48                   	dec    %eax
  801b03:	a3 54 51 80 00       	mov    %eax,0x805154
				block->size=USER_HEAP_MAX-USER_HEAP_START;
  801b08:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b0b:	c7 40 0c 00 00 00 20 	movl   $0x20000000,0xc(%eax)
				//cprintf("block size %x \n",block->size);
				//...
				block->sva=USER_HEAP_START;
  801b12:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b15:	c7 40 08 00 00 00 80 	movl   $0x80000000,0x8(%eax)
				//cprintf("block sva %x \n",block->sva);
				//cprintf("tsize %x \n",Tsize);
				//...
				LIST_INSERT_HEAD(&FreeMemBlocksList,block);
  801b1c:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  801b20:	75 14                	jne    801b36 <initialize_dyn_block_system+0x19b>
  801b22:	83 ec 04             	sub    $0x4,%esp
  801b25:	68 f4 40 80 00       	push   $0x8040f4
  801b2a:	6a 3e                	push   $0x3e
  801b2c:	68 e7 40 80 00       	push   $0x8040e7
  801b31:	e8 f0 eb ff ff       	call   800726 <_panic>
  801b36:	8b 15 38 51 80 00    	mov    0x805138,%edx
  801b3c:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b3f:	89 10                	mov    %edx,(%eax)
  801b41:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b44:	8b 00                	mov    (%eax),%eax
  801b46:	85 c0                	test   %eax,%eax
  801b48:	74 0d                	je     801b57 <initialize_dyn_block_system+0x1bc>
  801b4a:	a1 38 51 80 00       	mov    0x805138,%eax
  801b4f:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801b52:	89 50 04             	mov    %edx,0x4(%eax)
  801b55:	eb 08                	jmp    801b5f <initialize_dyn_block_system+0x1c4>
  801b57:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b5a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  801b5f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b62:	a3 38 51 80 00       	mov    %eax,0x805138
  801b67:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b6a:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801b71:	a1 44 51 80 00       	mov    0x805144,%eax
  801b76:	40                   	inc    %eax
  801b77:	a3 44 51 80 00       	mov    %eax,0x805144

				}


}
  801b7c:	90                   	nop
  801b7d:	c9                   	leave  
  801b7e:	c3                   	ret    

00801b7f <malloc>:
//=================================
// [2] ALLOCATE SPACE IN USER HEAP:
//=================================

void* malloc(uint32 size)
{
  801b7f:	55                   	push   %ebp
  801b80:	89 e5                	mov    %esp,%ebp
  801b82:	83 ec 18             	sub    $0x18,%esp
	//==============================================================
		//DON'T CHANGE THIS CODE========================================
		InitializeUHeap();
  801b85:	e8 e0 fd ff ff       	call   80196a <InitializeUHeap>
		if (size == 0) return NULL ;
  801b8a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801b8e:	75 07                	jne    801b97 <malloc+0x18>
  801b90:	b8 00 00 00 00       	mov    $0x0,%eax
  801b95:	eb 7f                	jmp    801c16 <malloc+0x97>
		//==============================================================
		//==============================================================

		//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] malloc
		// your code is here, remove the panic and write your code
		if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801b97:	e8 d2 08 00 00       	call   80246e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801b9c:	85 c0                	test   %eax,%eax
  801b9e:	74 71                	je     801c11 <malloc+0x92>
		size = ROUNDUP(size , PAGE_SIZE);
  801ba0:	c7 45 f4 00 10 00 00 	movl   $0x1000,-0xc(%ebp)
  801ba7:	8b 55 08             	mov    0x8(%ebp),%edx
  801baa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801bad:	01 d0                	add    %edx,%eax
  801baf:	48                   	dec    %eax
  801bb0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801bb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bb6:	ba 00 00 00 00       	mov    $0x0,%edx
  801bbb:	f7 75 f4             	divl   -0xc(%ebp)
  801bbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801bc1:	29 d0                	sub    %edx,%eax
  801bc3:	89 45 08             	mov    %eax,0x8(%ebp)
				struct MemBlock *mem_block = NULL;
  801bc6:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
				if ((USER_HEAP_MAX-USER_HEAP_START) < size){
  801bcd:	81 7d 08 00 00 00 20 	cmpl   $0x20000000,0x8(%ebp)
  801bd4:	76 07                	jbe    801bdd <malloc+0x5e>
					return NULL ;
  801bd6:	b8 00 00 00 00       	mov    $0x0,%eax
  801bdb:	eb 39                	jmp    801c16 <malloc+0x97>
				}
					mem_block = alloc_block_FF(size);
  801bdd:	83 ec 0c             	sub    $0xc,%esp
  801be0:	ff 75 08             	pushl  0x8(%ebp)
  801be3:	e8 e6 0d 00 00       	call   8029ce <alloc_block_FF>
  801be8:	83 c4 10             	add    $0x10,%esp
  801beb:	89 45 ec             	mov    %eax,-0x14(%ebp)
				if (mem_block != NULL){
  801bee:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  801bf2:	74 16                	je     801c0a <malloc+0x8b>
					insert_sorted_allocList(mem_block);
  801bf4:	83 ec 0c             	sub    $0xc,%esp
  801bf7:	ff 75 ec             	pushl  -0x14(%ebp)
  801bfa:	e8 37 0c 00 00       	call   802836 <insert_sorted_allocList>
  801bff:	83 c4 10             	add    $0x10,%esp
					//LIST_INSERT_HEAD(&AllocMemBlocksList , mem_block);
					return (void *)mem_block->sva ;
  801c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801c05:	8b 40 08             	mov    0x8(%eax),%eax
  801c08:	eb 0c                	jmp    801c16 <malloc+0x97>
					//int s = allocate_chunk(ptr_page_directory , mem_block->sva , size , PERM_WRITEABLE);

				}else{
					return NULL;
  801c0a:	b8 00 00 00 00       	mov    $0x0,%eax
  801c0f:	eb 05                	jmp    801c16 <malloc+0x97>
				}
		}
	return 0;
  801c11:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801c16:	c9                   	leave  
  801c17:	c3                   	ret    

00801c18 <free>:
//	We can use sys_free_user_mem(uint32 virtual_address, uint32 size); which
//		switches to the kernel mode, calls free_user_mem() in
//		"kern/mem/chunk_operations.c", then switch back to the user mode here
//	the free_user_mem function is empty, make sure to implement it.
void free(void* virtual_address)
{
  801c18:	55                   	push   %ebp
  801c19:	89 e5                	mov    %esp,%ebp
  801c1b:	83 ec 18             	sub    $0x18,%esp
	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
	// your code is here, remove the panic and write your code

	//TODO: [PROJECT MS3] [USER HEAP - USER SIDE] free
		// your code is here, remove the panic and write your code
	uint32 add=(uint32)virtual_address;
  801c1e:	8b 45 08             	mov    0x8(%ebp),%eax
  801c21:	89 45 f4             	mov    %eax,-0xc(%ebp)
	//if(add<USER_HEAP_MAX&&add>USER_HEAP_START){
		struct MemBlock *block=find_block(&AllocMemBlocksList,add);
  801c24:	83 ec 08             	sub    $0x8,%esp
  801c27:	ff 75 f4             	pushl  -0xc(%ebp)
  801c2a:	68 40 50 80 00       	push   $0x805040
  801c2f:	e8 cf 0b 00 00       	call   802803 <find_block>
  801c34:	83 c4 10             	add    $0x10,%esp
  801c37:	89 45 f0             	mov    %eax,-0x10(%ebp)
		uint32 size = block->size;
  801c3a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c3d:	8b 40 0c             	mov    0xc(%eax),%eax
  801c40:	89 45 ec             	mov    %eax,-0x14(%ebp)
		uint32 sva = block->sva;
  801c43:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c46:	8b 40 08             	mov    0x8(%eax),%eax
  801c49:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(block!=NULL){
  801c4c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c50:	0f 84 a1 00 00 00    	je     801cf7 <free+0xdf>
			LIST_REMOVE(&AllocMemBlocksList,block);
  801c56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801c5a:	75 17                	jne    801c73 <free+0x5b>
  801c5c:	83 ec 04             	sub    $0x4,%esp
  801c5f:	68 c9 40 80 00       	push   $0x8040c9
  801c64:	68 80 00 00 00       	push   $0x80
  801c69:	68 e7 40 80 00       	push   $0x8040e7
  801c6e:	e8 b3 ea ff ff       	call   800726 <_panic>
  801c73:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c76:	8b 00                	mov    (%eax),%eax
  801c78:	85 c0                	test   %eax,%eax
  801c7a:	74 10                	je     801c8c <free+0x74>
  801c7c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c7f:	8b 00                	mov    (%eax),%eax
  801c81:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801c84:	8b 52 04             	mov    0x4(%edx),%edx
  801c87:	89 50 04             	mov    %edx,0x4(%eax)
  801c8a:	eb 0b                	jmp    801c97 <free+0x7f>
  801c8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c8f:	8b 40 04             	mov    0x4(%eax),%eax
  801c92:	a3 44 50 80 00       	mov    %eax,0x805044
  801c97:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801c9a:	8b 40 04             	mov    0x4(%eax),%eax
  801c9d:	85 c0                	test   %eax,%eax
  801c9f:	74 0f                	je     801cb0 <free+0x98>
  801ca1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801ca4:	8b 40 04             	mov    0x4(%eax),%eax
  801ca7:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801caa:	8b 12                	mov    (%edx),%edx
  801cac:	89 10                	mov    %edx,(%eax)
  801cae:	eb 0a                	jmp    801cba <free+0xa2>
  801cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cb3:	8b 00                	mov    (%eax),%eax
  801cb5:	a3 40 50 80 00       	mov    %eax,0x805040
  801cba:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cbd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  801cc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801cc6:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  801ccd:	a1 4c 50 80 00       	mov    0x80504c,%eax
  801cd2:	48                   	dec    %eax
  801cd3:	a3 4c 50 80 00       	mov    %eax,0x80504c
			insert_sorted_with_merge_freeList(block);
  801cd8:	83 ec 0c             	sub    $0xc,%esp
  801cdb:	ff 75 f0             	pushl  -0x10(%ebp)
  801cde:	e8 29 12 00 00       	call   802f0c <insert_sorted_with_merge_freeList>
  801ce3:	83 c4 10             	add    $0x10,%esp
			sys_free_user_mem(sva,size);
  801ce6:	83 ec 08             	sub    $0x8,%esp
  801ce9:	ff 75 ec             	pushl  -0x14(%ebp)
  801cec:	ff 75 e8             	pushl  -0x18(%ebp)
  801cef:	e8 74 03 00 00       	call   802068 <sys_free_user_mem>
  801cf4:	83 c4 10             	add    $0x10,%esp
		}
	//}
	//you need to call sys_free_user_mem()
	//refer to the project presentation and documentation for details
}
  801cf7:	90                   	nop
  801cf8:	c9                   	leave  
  801cf9:	c3                   	ret    

00801cfa <smalloc>:

//=================================
// [4] ALLOCATE SHARED VARIABLE:
//=================================
void* smalloc(char *sharedVarName, uint32 size, uint8 isWritable)
{	//==============================================================
  801cfa:	55                   	push   %ebp
  801cfb:	89 e5                	mov    %esp,%ebp
  801cfd:	83 ec 38             	sub    $0x38,%esp
  801d00:	8b 45 10             	mov    0x10(%ebp),%eax
  801d03:	88 45 d4             	mov    %al,-0x2c(%ebp)
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801d06:	e8 5f fc ff ff       	call   80196a <InitializeUHeap>
	if (size == 0) return NULL ;
  801d0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801d0f:	75 0a                	jne    801d1b <smalloc+0x21>
  801d11:	b8 00 00 00 00       	mov    $0x0,%eax
  801d16:	e9 b2 00 00 00       	jmp    801dcd <smalloc+0xd3>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] smalloc()
	// Write your code here, remove the panic and write your code
	//panic("smalloc() is not implemented yet...!!");
	if(size>USER_HEAP_MAX-USER_HEAP_START){
  801d1b:	81 7d 0c 00 00 00 20 	cmpl   $0x20000000,0xc(%ebp)
  801d22:	76 0a                	jbe    801d2e <smalloc+0x34>
		return NULL;
  801d24:	b8 00 00 00 00       	mov    $0x0,%eax
  801d29:	e9 9f 00 00 00       	jmp    801dcd <smalloc+0xd3>
	}
	if (sys_isUHeapPlacementStrategyFIRSTFIT()){
  801d2e:	e8 3b 07 00 00       	call   80246e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801d33:	85 c0                	test   %eax,%eax
  801d35:	0f 84 8d 00 00 00    	je     801dc8 <smalloc+0xce>
	struct MemBlock *b = NULL;
  801d3b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	uint32 sizee = ROUNDUP(size , PAGE_SIZE);
  801d42:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  801d49:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d4c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801d4f:	01 d0                	add    %edx,%eax
  801d51:	48                   	dec    %eax
  801d52:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801d55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d58:	ba 00 00 00 00       	mov    $0x0,%edx
  801d5d:	f7 75 f0             	divl   -0x10(%ebp)
  801d60:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801d63:	29 d0                	sub    %edx,%eax
  801d65:	89 45 e8             	mov    %eax,-0x18(%ebp)

		b =alloc_block_FF(sizee);
  801d68:	83 ec 0c             	sub    $0xc,%esp
  801d6b:	ff 75 e8             	pushl  -0x18(%ebp)
  801d6e:	e8 5b 0c 00 00       	call   8029ce <alloc_block_FF>
  801d73:	83 c4 10             	add    $0x10,%esp
  801d76:	89 45 f4             	mov    %eax,-0xc(%ebp)
		if (b == NULL){
  801d79:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801d7d:	75 07                	jne    801d86 <smalloc+0x8c>
			return NULL;
  801d7f:	b8 00 00 00 00       	mov    $0x0,%eax
  801d84:	eb 47                	jmp    801dcd <smalloc+0xd3>
		}
		insert_sorted_allocList(b);
  801d86:	83 ec 0c             	sub    $0xc,%esp
  801d89:	ff 75 f4             	pushl  -0xc(%ebp)
  801d8c:	e8 a5 0a 00 00       	call   802836 <insert_sorted_allocList>
  801d91:	83 c4 10             	add    $0x10,%esp
	int s = sys_createSharedObject(sharedVarName , size , isWritable ,(void *)b->sva );
  801d94:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801d97:	8b 40 08             	mov    0x8(%eax),%eax
  801d9a:	89 c2                	mov    %eax,%edx
  801d9c:	0f b6 45 d4          	movzbl -0x2c(%ebp),%eax
  801da0:	52                   	push   %edx
  801da1:	50                   	push   %eax
  801da2:	ff 75 0c             	pushl  0xc(%ebp)
  801da5:	ff 75 08             	pushl  0x8(%ebp)
  801da8:	e8 46 04 00 00       	call   8021f3 <sys_createSharedObject>
  801dad:	83 c4 10             	add    $0x10,%esp
  801db0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(s>=0){
  801db3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801db7:	78 08                	js     801dc1 <smalloc+0xc7>
		return (void *)b->sva;
  801db9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801dbc:	8b 40 08             	mov    0x8(%eax),%eax
  801dbf:	eb 0c                	jmp    801dcd <smalloc+0xd3>
		}else{
		return NULL;
  801dc1:	b8 00 00 00 00       	mov    $0x0,%eax
  801dc6:	eb 05                	jmp    801dcd <smalloc+0xd3>
			}

	}return NULL;
  801dc8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801dcd:	c9                   	leave  
  801dce:	c3                   	ret    

00801dcf <sget>:
//========================================
// [5] SHARE ON ALLOCATED SHARED VARIABLE:
//========================================
void* sget(int32 ownerEnvID, char *sharedVarName)
{
  801dcf:	55                   	push   %ebp
  801dd0:	89 e5                	mov    %esp,%ebp
  801dd2:	83 ec 28             	sub    $0x28,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801dd5:	e8 90 fb ff ff       	call   80196a <InitializeUHeap>
	//==============================================================

	//TODO: [PROJECT MS3] [SHARING - USER SIDE] sget()
	// Write your code here, remove the panic and write your code
	//panic("sget() is not implemented yet...!!");
	if(sys_isUHeapPlacementStrategyFIRSTFIT()){
  801dda:	e8 8f 06 00 00       	call   80246e <sys_isUHeapPlacementStrategyFIRSTFIT>
  801ddf:	85 c0                	test   %eax,%eax
  801de1:	0f 84 ad 00 00 00    	je     801e94 <sget+0xc5>
    int q=sys_getSizeOfSharedObject(ownerEnvID,sharedVarName);
  801de7:	83 ec 08             	sub    $0x8,%esp
  801dea:	ff 75 0c             	pushl  0xc(%ebp)
  801ded:	ff 75 08             	pushl  0x8(%ebp)
  801df0:	e8 28 04 00 00       	call   80221d <sys_getSizeOfSharedObject>
  801df5:	83 c4 10             	add    $0x10,%esp
  801df8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if(q<0)
  801dfb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  801dff:	79 0a                	jns    801e0b <sget+0x3c>
    {
    	return NULL;
  801e01:	b8 00 00 00 00       	mov    $0x0,%eax
  801e06:	e9 8e 00 00 00       	jmp    801e99 <sget+0xca>
    }
    else
    {
	struct MemBlock *b = NULL;
  801e0b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
		uint32 ttttt = ROUNDUP(q , PAGE_SIZE);
  801e12:	c7 45 ec 00 10 00 00 	movl   $0x1000,-0x14(%ebp)
  801e19:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801e1c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801e1f:	01 d0                	add    %edx,%eax
  801e21:	48                   	dec    %eax
  801e22:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801e25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e28:	ba 00 00 00 00       	mov    $0x0,%edx
  801e2d:	f7 75 ec             	divl   -0x14(%ebp)
  801e30:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801e33:	29 d0                	sub    %edx,%eax
  801e35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			b =alloc_block_FF(ttttt);
  801e38:	83 ec 0c             	sub    $0xc,%esp
  801e3b:	ff 75 e4             	pushl  -0x1c(%ebp)
  801e3e:	e8 8b 0b 00 00       	call   8029ce <alloc_block_FF>
  801e43:	83 c4 10             	add    $0x10,%esp
  801e46:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (b == NULL){
  801e49:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  801e4d:	75 07                	jne    801e56 <sget+0x87>
				return NULL;
  801e4f:	b8 00 00 00 00       	mov    $0x0,%eax
  801e54:	eb 43                	jmp    801e99 <sget+0xca>
			}
			insert_sorted_allocList(b);
  801e56:	83 ec 0c             	sub    $0xc,%esp
  801e59:	ff 75 f0             	pushl  -0x10(%ebp)
  801e5c:	e8 d5 09 00 00       	call   802836 <insert_sorted_allocList>
  801e61:	83 c4 10             	add    $0x10,%esp
		int s=sys_getSharedObject(ownerEnvID,sharedVarName,(void *)b->sva);
  801e64:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e67:	8b 40 08             	mov    0x8(%eax),%eax
  801e6a:	83 ec 04             	sub    $0x4,%esp
  801e6d:	50                   	push   %eax
  801e6e:	ff 75 0c             	pushl  0xc(%ebp)
  801e71:	ff 75 08             	pushl  0x8(%ebp)
  801e74:	e8 c1 03 00 00       	call   80223a <sys_getSharedObject>
  801e79:	83 c4 10             	add    $0x10,%esp
  801e7c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(s>=0){
  801e7f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801e83:	78 08                	js     801e8d <sget+0xbe>
			return (void *)b->sva;
  801e85:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801e88:	8b 40 08             	mov    0x8(%eax),%eax
  801e8b:	eb 0c                	jmp    801e99 <sget+0xca>
			}else{
			return NULL;
  801e8d:	b8 00 00 00 00       	mov    $0x0,%eax
  801e92:	eb 05                	jmp    801e99 <sget+0xca>
			}
    }}return NULL;
  801e94:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801e99:	c9                   	leave  
  801e9a:	c3                   	ret    

00801e9b <realloc>:
//  Hint: you may need to use the sys_move_user_mem(...)
//		which switches to the kernel mode, calls move_user_mem(...)
//		in "kern/mem/chunk_operations.c", then switch back to the user mode here
//	the move_user_mem() function is empty, make sure to implement it.
void *realloc(void *virtual_address, uint32 new_size)
{
  801e9b:	55                   	push   %ebp
  801e9c:	89 e5                	mov    %esp,%ebp
  801e9e:	83 ec 08             	sub    $0x8,%esp
	//==============================================================
	//DON'T CHANGE THIS CODE========================================
	InitializeUHeap();
  801ea1:	e8 c4 fa ff ff       	call   80196a <InitializeUHeap>
	//==============================================================
	// [USER HEAP - USER SIDE] realloc
	// Write your code here, remove the panic and write your code
	panic("realloc() is not implemented yet...!!");
  801ea6:	83 ec 04             	sub    $0x4,%esp
  801ea9:	68 18 41 80 00       	push   $0x804118
  801eae:	68 03 01 00 00       	push   $0x103
  801eb3:	68 e7 40 80 00       	push   $0x8040e7
  801eb8:	e8 69 e8 ff ff       	call   800726 <_panic>

00801ebd <sfree>:
//	use sys_freeSharedObject(...); which switches to the kernel mode,
//	calls freeSharedObject(...) in "shared_memory_manager.c", then switch back to the user mode here
//	the freeSharedObject() function is empty, make sure to implement it.

void sfree(void* virtual_address)
{
  801ebd:	55                   	push   %ebp
  801ebe:	89 e5                	mov    %esp,%ebp
  801ec0:	83 ec 08             	sub    $0x8,%esp
	//TODO: [PROJECT MS3 - BONUS] [SHARING - USER SIDE] sfree()

	// Write your code here, remove the panic and write your code
	panic("sfree() is not implemented yet...!!");
  801ec3:	83 ec 04             	sub    $0x4,%esp
  801ec6:	68 40 41 80 00       	push   $0x804140
  801ecb:	68 17 01 00 00       	push   $0x117
  801ed0:	68 e7 40 80 00       	push   $0x8040e7
  801ed5:	e8 4c e8 ff ff       	call   800726 <_panic>

00801eda <expand>:

//==================================================================================//
//========================== MODIFICATION FUNCTIONS ================================//
//==================================================================================//
void expand(uint32 newSize)
{
  801eda:	55                   	push   %ebp
  801edb:	89 e5                	mov    %esp,%ebp
  801edd:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801ee0:	83 ec 04             	sub    $0x4,%esp
  801ee3:	68 64 41 80 00       	push   $0x804164
  801ee8:	68 22 01 00 00       	push   $0x122
  801eed:	68 e7 40 80 00       	push   $0x8040e7
  801ef2:	e8 2f e8 ff ff       	call   800726 <_panic>

00801ef7 <shrink>:

}
void shrink(uint32 newSize)
{
  801ef7:	55                   	push   %ebp
  801ef8:	89 e5                	mov    %esp,%ebp
  801efa:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801efd:	83 ec 04             	sub    $0x4,%esp
  801f00:	68 64 41 80 00       	push   $0x804164
  801f05:	68 27 01 00 00       	push   $0x127
  801f0a:	68 e7 40 80 00       	push   $0x8040e7
  801f0f:	e8 12 e8 ff ff       	call   800726 <_panic>

00801f14 <freeHeap>:

}
void freeHeap(void* virtual_address)
{
  801f14:	55                   	push   %ebp
  801f15:	89 e5                	mov    %esp,%ebp
  801f17:	83 ec 08             	sub    $0x8,%esp
	panic("Not Implemented");
  801f1a:	83 ec 04             	sub    $0x4,%esp
  801f1d:	68 64 41 80 00       	push   $0x804164
  801f22:	68 2c 01 00 00       	push   $0x12c
  801f27:	68 e7 40 80 00       	push   $0x8040e7
  801f2c:	e8 f5 e7 ff ff       	call   800726 <_panic>

00801f31 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801f31:	55                   	push   %ebp
  801f32:	89 e5                	mov    %esp,%ebp
  801f34:	57                   	push   %edi
  801f35:	56                   	push   %esi
  801f36:	53                   	push   %ebx
  801f37:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801f3a:	8b 45 08             	mov    0x8(%ebp),%eax
  801f3d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801f40:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801f43:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801f46:	8b 7d 18             	mov    0x18(%ebp),%edi
  801f49:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801f4c:	cd 30                	int    $0x30
  801f4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801f51:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801f54:	83 c4 10             	add    $0x10,%esp
  801f57:	5b                   	pop    %ebx
  801f58:	5e                   	pop    %esi
  801f59:	5f                   	pop    %edi
  801f5a:	5d                   	pop    %ebp
  801f5b:	c3                   	ret    

00801f5c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801f5c:	55                   	push   %ebp
  801f5d:	89 e5                	mov    %esp,%ebp
  801f5f:	83 ec 04             	sub    $0x4,%esp
  801f62:	8b 45 10             	mov    0x10(%ebp),%eax
  801f65:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801f68:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801f6c:	8b 45 08             	mov    0x8(%ebp),%eax
  801f6f:	6a 00                	push   $0x0
  801f71:	6a 00                	push   $0x0
  801f73:	52                   	push   %edx
  801f74:	ff 75 0c             	pushl  0xc(%ebp)
  801f77:	50                   	push   %eax
  801f78:	6a 00                	push   $0x0
  801f7a:	e8 b2 ff ff ff       	call   801f31 <syscall>
  801f7f:	83 c4 18             	add    $0x18,%esp
}
  801f82:	90                   	nop
  801f83:	c9                   	leave  
  801f84:	c3                   	ret    

00801f85 <sys_cgetc>:

int
sys_cgetc(void)
{
  801f85:	55                   	push   %ebp
  801f86:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801f88:	6a 00                	push   $0x0
  801f8a:	6a 00                	push   $0x0
  801f8c:	6a 00                	push   $0x0
  801f8e:	6a 00                	push   $0x0
  801f90:	6a 00                	push   $0x0
  801f92:	6a 01                	push   $0x1
  801f94:	e8 98 ff ff ff       	call   801f31 <syscall>
  801f99:	83 c4 18             	add    $0x18,%esp
}
  801f9c:	c9                   	leave  
  801f9d:	c3                   	ret    

00801f9e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801f9e:	55                   	push   %ebp
  801f9f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801fa1:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fa4:	8b 45 08             	mov    0x8(%ebp),%eax
  801fa7:	6a 00                	push   $0x0
  801fa9:	6a 00                	push   $0x0
  801fab:	6a 00                	push   $0x0
  801fad:	52                   	push   %edx
  801fae:	50                   	push   %eax
  801faf:	6a 05                	push   $0x5
  801fb1:	e8 7b ff ff ff       	call   801f31 <syscall>
  801fb6:	83 c4 18             	add    $0x18,%esp
}
  801fb9:	c9                   	leave  
  801fba:	c3                   	ret    

00801fbb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801fbb:	55                   	push   %ebp
  801fbc:	89 e5                	mov    %esp,%ebp
  801fbe:	56                   	push   %esi
  801fbf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801fc0:	8b 75 18             	mov    0x18(%ebp),%esi
  801fc3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801fc6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801fc9:	8b 55 0c             	mov    0xc(%ebp),%edx
  801fcc:	8b 45 08             	mov    0x8(%ebp),%eax
  801fcf:	56                   	push   %esi
  801fd0:	53                   	push   %ebx
  801fd1:	51                   	push   %ecx
  801fd2:	52                   	push   %edx
  801fd3:	50                   	push   %eax
  801fd4:	6a 06                	push   $0x6
  801fd6:	e8 56 ff ff ff       	call   801f31 <syscall>
  801fdb:	83 c4 18             	add    $0x18,%esp
}
  801fde:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801fe1:	5b                   	pop    %ebx
  801fe2:	5e                   	pop    %esi
  801fe3:	5d                   	pop    %ebp
  801fe4:	c3                   	ret    

00801fe5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801fe5:	55                   	push   %ebp
  801fe6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801fe8:	8b 55 0c             	mov    0xc(%ebp),%edx
  801feb:	8b 45 08             	mov    0x8(%ebp),%eax
  801fee:	6a 00                	push   $0x0
  801ff0:	6a 00                	push   $0x0
  801ff2:	6a 00                	push   $0x0
  801ff4:	52                   	push   %edx
  801ff5:	50                   	push   %eax
  801ff6:	6a 07                	push   $0x7
  801ff8:	e8 34 ff ff ff       	call   801f31 <syscall>
  801ffd:	83 c4 18             	add    $0x18,%esp
}
  802000:	c9                   	leave  
  802001:	c3                   	ret    

00802002 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  802002:	55                   	push   %ebp
  802003:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  802005:	6a 00                	push   $0x0
  802007:	6a 00                	push   $0x0
  802009:	6a 00                	push   $0x0
  80200b:	ff 75 0c             	pushl  0xc(%ebp)
  80200e:	ff 75 08             	pushl  0x8(%ebp)
  802011:	6a 08                	push   $0x8
  802013:	e8 19 ff ff ff       	call   801f31 <syscall>
  802018:	83 c4 18             	add    $0x18,%esp
}
  80201b:	c9                   	leave  
  80201c:	c3                   	ret    

0080201d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80201d:	55                   	push   %ebp
  80201e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  802020:	6a 00                	push   $0x0
  802022:	6a 00                	push   $0x0
  802024:	6a 00                	push   $0x0
  802026:	6a 00                	push   $0x0
  802028:	6a 00                	push   $0x0
  80202a:	6a 09                	push   $0x9
  80202c:	e8 00 ff ff ff       	call   801f31 <syscall>
  802031:	83 c4 18             	add    $0x18,%esp
}
  802034:	c9                   	leave  
  802035:	c3                   	ret    

00802036 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  802036:	55                   	push   %ebp
  802037:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  802039:	6a 00                	push   $0x0
  80203b:	6a 00                	push   $0x0
  80203d:	6a 00                	push   $0x0
  80203f:	6a 00                	push   $0x0
  802041:	6a 00                	push   $0x0
  802043:	6a 0a                	push   $0xa
  802045:	e8 e7 fe ff ff       	call   801f31 <syscall>
  80204a:	83 c4 18             	add    $0x18,%esp
}
  80204d:	c9                   	leave  
  80204e:	c3                   	ret    

0080204f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80204f:	55                   	push   %ebp
  802050:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  802052:	6a 00                	push   $0x0
  802054:	6a 00                	push   $0x0
  802056:	6a 00                	push   $0x0
  802058:	6a 00                	push   $0x0
  80205a:	6a 00                	push   $0x0
  80205c:	6a 0b                	push   $0xb
  80205e:	e8 ce fe ff ff       	call   801f31 <syscall>
  802063:	83 c4 18             	add    $0x18,%esp
}
  802066:	c9                   	leave  
  802067:	c3                   	ret    

00802068 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  802068:	55                   	push   %ebp
  802069:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80206b:	6a 00                	push   $0x0
  80206d:	6a 00                	push   $0x0
  80206f:	6a 00                	push   $0x0
  802071:	ff 75 0c             	pushl  0xc(%ebp)
  802074:	ff 75 08             	pushl  0x8(%ebp)
  802077:	6a 0f                	push   $0xf
  802079:	e8 b3 fe ff ff       	call   801f31 <syscall>
  80207e:	83 c4 18             	add    $0x18,%esp
	return;
  802081:	90                   	nop
}
  802082:	c9                   	leave  
  802083:	c3                   	ret    

00802084 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  802084:	55                   	push   %ebp
  802085:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  802087:	6a 00                	push   $0x0
  802089:	6a 00                	push   $0x0
  80208b:	6a 00                	push   $0x0
  80208d:	ff 75 0c             	pushl  0xc(%ebp)
  802090:	ff 75 08             	pushl  0x8(%ebp)
  802093:	6a 10                	push   $0x10
  802095:	e8 97 fe ff ff       	call   801f31 <syscall>
  80209a:	83 c4 18             	add    $0x18,%esp
	return ;
  80209d:	90                   	nop
}
  80209e:	c9                   	leave  
  80209f:	c3                   	ret    

008020a0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8020a0:	55                   	push   %ebp
  8020a1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8020a3:	6a 00                	push   $0x0
  8020a5:	6a 00                	push   $0x0
  8020a7:	ff 75 10             	pushl  0x10(%ebp)
  8020aa:	ff 75 0c             	pushl  0xc(%ebp)
  8020ad:	ff 75 08             	pushl  0x8(%ebp)
  8020b0:	6a 11                	push   $0x11
  8020b2:	e8 7a fe ff ff       	call   801f31 <syscall>
  8020b7:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ba:	90                   	nop
}
  8020bb:	c9                   	leave  
  8020bc:	c3                   	ret    

008020bd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8020bd:	55                   	push   %ebp
  8020be:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8020c0:	6a 00                	push   $0x0
  8020c2:	6a 00                	push   $0x0
  8020c4:	6a 00                	push   $0x0
  8020c6:	6a 00                	push   $0x0
  8020c8:	6a 00                	push   $0x0
  8020ca:	6a 0c                	push   $0xc
  8020cc:	e8 60 fe ff ff       	call   801f31 <syscall>
  8020d1:	83 c4 18             	add    $0x18,%esp
}
  8020d4:	c9                   	leave  
  8020d5:	c3                   	ret    

008020d6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8020d6:	55                   	push   %ebp
  8020d7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8020d9:	6a 00                	push   $0x0
  8020db:	6a 00                	push   $0x0
  8020dd:	6a 00                	push   $0x0
  8020df:	6a 00                	push   $0x0
  8020e1:	ff 75 08             	pushl  0x8(%ebp)
  8020e4:	6a 0d                	push   $0xd
  8020e6:	e8 46 fe ff ff       	call   801f31 <syscall>
  8020eb:	83 c4 18             	add    $0x18,%esp
}
  8020ee:	c9                   	leave  
  8020ef:	c3                   	ret    

008020f0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8020f0:	55                   	push   %ebp
  8020f1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8020f3:	6a 00                	push   $0x0
  8020f5:	6a 00                	push   $0x0
  8020f7:	6a 00                	push   $0x0
  8020f9:	6a 00                	push   $0x0
  8020fb:	6a 00                	push   $0x0
  8020fd:	6a 0e                	push   $0xe
  8020ff:	e8 2d fe ff ff       	call   801f31 <syscall>
  802104:	83 c4 18             	add    $0x18,%esp
}
  802107:	90                   	nop
  802108:	c9                   	leave  
  802109:	c3                   	ret    

0080210a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80210a:	55                   	push   %ebp
  80210b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80210d:	6a 00                	push   $0x0
  80210f:	6a 00                	push   $0x0
  802111:	6a 00                	push   $0x0
  802113:	6a 00                	push   $0x0
  802115:	6a 00                	push   $0x0
  802117:	6a 13                	push   $0x13
  802119:	e8 13 fe ff ff       	call   801f31 <syscall>
  80211e:	83 c4 18             	add    $0x18,%esp
}
  802121:	90                   	nop
  802122:	c9                   	leave  
  802123:	c3                   	ret    

00802124 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  802124:	55                   	push   %ebp
  802125:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  802127:	6a 00                	push   $0x0
  802129:	6a 00                	push   $0x0
  80212b:	6a 00                	push   $0x0
  80212d:	6a 00                	push   $0x0
  80212f:	6a 00                	push   $0x0
  802131:	6a 14                	push   $0x14
  802133:	e8 f9 fd ff ff       	call   801f31 <syscall>
  802138:	83 c4 18             	add    $0x18,%esp
}
  80213b:	90                   	nop
  80213c:	c9                   	leave  
  80213d:	c3                   	ret    

0080213e <sys_cputc>:


void
sys_cputc(const char c)
{
  80213e:	55                   	push   %ebp
  80213f:	89 e5                	mov    %esp,%ebp
  802141:	83 ec 04             	sub    $0x4,%esp
  802144:	8b 45 08             	mov    0x8(%ebp),%eax
  802147:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80214a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80214e:	6a 00                	push   $0x0
  802150:	6a 00                	push   $0x0
  802152:	6a 00                	push   $0x0
  802154:	6a 00                	push   $0x0
  802156:	50                   	push   %eax
  802157:	6a 15                	push   $0x15
  802159:	e8 d3 fd ff ff       	call   801f31 <syscall>
  80215e:	83 c4 18             	add    $0x18,%esp
}
  802161:	90                   	nop
  802162:	c9                   	leave  
  802163:	c3                   	ret    

00802164 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  802164:	55                   	push   %ebp
  802165:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  802167:	6a 00                	push   $0x0
  802169:	6a 00                	push   $0x0
  80216b:	6a 00                	push   $0x0
  80216d:	6a 00                	push   $0x0
  80216f:	6a 00                	push   $0x0
  802171:	6a 16                	push   $0x16
  802173:	e8 b9 fd ff ff       	call   801f31 <syscall>
  802178:	83 c4 18             	add    $0x18,%esp
}
  80217b:	90                   	nop
  80217c:	c9                   	leave  
  80217d:	c3                   	ret    

0080217e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80217e:	55                   	push   %ebp
  80217f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  802181:	8b 45 08             	mov    0x8(%ebp),%eax
  802184:	6a 00                	push   $0x0
  802186:	6a 00                	push   $0x0
  802188:	6a 00                	push   $0x0
  80218a:	ff 75 0c             	pushl  0xc(%ebp)
  80218d:	50                   	push   %eax
  80218e:	6a 17                	push   $0x17
  802190:	e8 9c fd ff ff       	call   801f31 <syscall>
  802195:	83 c4 18             	add    $0x18,%esp
}
  802198:	c9                   	leave  
  802199:	c3                   	ret    

0080219a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80219a:	55                   	push   %ebp
  80219b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80219d:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8021a3:	6a 00                	push   $0x0
  8021a5:	6a 00                	push   $0x0
  8021a7:	6a 00                	push   $0x0
  8021a9:	52                   	push   %edx
  8021aa:	50                   	push   %eax
  8021ab:	6a 1a                	push   $0x1a
  8021ad:	e8 7f fd ff ff       	call   801f31 <syscall>
  8021b2:	83 c4 18             	add    $0x18,%esp
}
  8021b5:	c9                   	leave  
  8021b6:	c3                   	ret    

008021b7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021b7:	55                   	push   %ebp
  8021b8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8021c0:	6a 00                	push   $0x0
  8021c2:	6a 00                	push   $0x0
  8021c4:	6a 00                	push   $0x0
  8021c6:	52                   	push   %edx
  8021c7:	50                   	push   %eax
  8021c8:	6a 18                	push   $0x18
  8021ca:	e8 62 fd ff ff       	call   801f31 <syscall>
  8021cf:	83 c4 18             	add    $0x18,%esp
}
  8021d2:	90                   	nop
  8021d3:	c9                   	leave  
  8021d4:	c3                   	ret    

008021d5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8021d5:	55                   	push   %ebp
  8021d6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8021d8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8021db:	8b 45 08             	mov    0x8(%ebp),%eax
  8021de:	6a 00                	push   $0x0
  8021e0:	6a 00                	push   $0x0
  8021e2:	6a 00                	push   $0x0
  8021e4:	52                   	push   %edx
  8021e5:	50                   	push   %eax
  8021e6:	6a 19                	push   $0x19
  8021e8:	e8 44 fd ff ff       	call   801f31 <syscall>
  8021ed:	83 c4 18             	add    $0x18,%esp
}
  8021f0:	90                   	nop
  8021f1:	c9                   	leave  
  8021f2:	c3                   	ret    

008021f3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8021f3:	55                   	push   %ebp
  8021f4:	89 e5                	mov    %esp,%ebp
  8021f6:	83 ec 04             	sub    $0x4,%esp
  8021f9:	8b 45 10             	mov    0x10(%ebp),%eax
  8021fc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8021ff:	8b 4d 14             	mov    0x14(%ebp),%ecx
  802202:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  802206:	8b 45 08             	mov    0x8(%ebp),%eax
  802209:	6a 00                	push   $0x0
  80220b:	51                   	push   %ecx
  80220c:	52                   	push   %edx
  80220d:	ff 75 0c             	pushl  0xc(%ebp)
  802210:	50                   	push   %eax
  802211:	6a 1b                	push   $0x1b
  802213:	e8 19 fd ff ff       	call   801f31 <syscall>
  802218:	83 c4 18             	add    $0x18,%esp
}
  80221b:	c9                   	leave  
  80221c:	c3                   	ret    

0080221d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  80221d:	55                   	push   %ebp
  80221e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  802220:	8b 55 0c             	mov    0xc(%ebp),%edx
  802223:	8b 45 08             	mov    0x8(%ebp),%eax
  802226:	6a 00                	push   $0x0
  802228:	6a 00                	push   $0x0
  80222a:	6a 00                	push   $0x0
  80222c:	52                   	push   %edx
  80222d:	50                   	push   %eax
  80222e:	6a 1c                	push   $0x1c
  802230:	e8 fc fc ff ff       	call   801f31 <syscall>
  802235:	83 c4 18             	add    $0x18,%esp
}
  802238:	c9                   	leave  
  802239:	c3                   	ret    

0080223a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80223a:	55                   	push   %ebp
  80223b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  80223d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802240:	8b 55 0c             	mov    0xc(%ebp),%edx
  802243:	8b 45 08             	mov    0x8(%ebp),%eax
  802246:	6a 00                	push   $0x0
  802248:	6a 00                	push   $0x0
  80224a:	51                   	push   %ecx
  80224b:	52                   	push   %edx
  80224c:	50                   	push   %eax
  80224d:	6a 1d                	push   $0x1d
  80224f:	e8 dd fc ff ff       	call   801f31 <syscall>
  802254:	83 c4 18             	add    $0x18,%esp
}
  802257:	c9                   	leave  
  802258:	c3                   	ret    

00802259 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  802259:	55                   	push   %ebp
  80225a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80225c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80225f:	8b 45 08             	mov    0x8(%ebp),%eax
  802262:	6a 00                	push   $0x0
  802264:	6a 00                	push   $0x0
  802266:	6a 00                	push   $0x0
  802268:	52                   	push   %edx
  802269:	50                   	push   %eax
  80226a:	6a 1e                	push   $0x1e
  80226c:	e8 c0 fc ff ff       	call   801f31 <syscall>
  802271:	83 c4 18             	add    $0x18,%esp
}
  802274:	c9                   	leave  
  802275:	c3                   	ret    

00802276 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  802276:	55                   	push   %ebp
  802277:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  802279:	6a 00                	push   $0x0
  80227b:	6a 00                	push   $0x0
  80227d:	6a 00                	push   $0x0
  80227f:	6a 00                	push   $0x0
  802281:	6a 00                	push   $0x0
  802283:	6a 1f                	push   $0x1f
  802285:	e8 a7 fc ff ff       	call   801f31 <syscall>
  80228a:	83 c4 18             	add    $0x18,%esp
}
  80228d:	c9                   	leave  
  80228e:	c3                   	ret    

0080228f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80228f:	55                   	push   %ebp
  802290:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  802292:	8b 45 08             	mov    0x8(%ebp),%eax
  802295:	6a 00                	push   $0x0
  802297:	ff 75 14             	pushl  0x14(%ebp)
  80229a:	ff 75 10             	pushl  0x10(%ebp)
  80229d:	ff 75 0c             	pushl  0xc(%ebp)
  8022a0:	50                   	push   %eax
  8022a1:	6a 20                	push   $0x20
  8022a3:	e8 89 fc ff ff       	call   801f31 <syscall>
  8022a8:	83 c4 18             	add    $0x18,%esp
}
  8022ab:	c9                   	leave  
  8022ac:	c3                   	ret    

008022ad <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8022ad:	55                   	push   %ebp
  8022ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8022b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8022b3:	6a 00                	push   $0x0
  8022b5:	6a 00                	push   $0x0
  8022b7:	6a 00                	push   $0x0
  8022b9:	6a 00                	push   $0x0
  8022bb:	50                   	push   %eax
  8022bc:	6a 21                	push   $0x21
  8022be:	e8 6e fc ff ff       	call   801f31 <syscall>
  8022c3:	83 c4 18             	add    $0x18,%esp
}
  8022c6:	90                   	nop
  8022c7:	c9                   	leave  
  8022c8:	c3                   	ret    

008022c9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8022c9:	55                   	push   %ebp
  8022ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8022cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8022cf:	6a 00                	push   $0x0
  8022d1:	6a 00                	push   $0x0
  8022d3:	6a 00                	push   $0x0
  8022d5:	6a 00                	push   $0x0
  8022d7:	50                   	push   %eax
  8022d8:	6a 22                	push   $0x22
  8022da:	e8 52 fc ff ff       	call   801f31 <syscall>
  8022df:	83 c4 18             	add    $0x18,%esp
}
  8022e2:	c9                   	leave  
  8022e3:	c3                   	ret    

008022e4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8022e4:	55                   	push   %ebp
  8022e5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8022e7:	6a 00                	push   $0x0
  8022e9:	6a 00                	push   $0x0
  8022eb:	6a 00                	push   $0x0
  8022ed:	6a 00                	push   $0x0
  8022ef:	6a 00                	push   $0x0
  8022f1:	6a 02                	push   $0x2
  8022f3:	e8 39 fc ff ff       	call   801f31 <syscall>
  8022f8:	83 c4 18             	add    $0x18,%esp
}
  8022fb:	c9                   	leave  
  8022fc:	c3                   	ret    

008022fd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8022fd:	55                   	push   %ebp
  8022fe:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  802300:	6a 00                	push   $0x0
  802302:	6a 00                	push   $0x0
  802304:	6a 00                	push   $0x0
  802306:	6a 00                	push   $0x0
  802308:	6a 00                	push   $0x0
  80230a:	6a 03                	push   $0x3
  80230c:	e8 20 fc ff ff       	call   801f31 <syscall>
  802311:	83 c4 18             	add    $0x18,%esp
}
  802314:	c9                   	leave  
  802315:	c3                   	ret    

00802316 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  802316:	55                   	push   %ebp
  802317:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  802319:	6a 00                	push   $0x0
  80231b:	6a 00                	push   $0x0
  80231d:	6a 00                	push   $0x0
  80231f:	6a 00                	push   $0x0
  802321:	6a 00                	push   $0x0
  802323:	6a 04                	push   $0x4
  802325:	e8 07 fc ff ff       	call   801f31 <syscall>
  80232a:	83 c4 18             	add    $0x18,%esp
}
  80232d:	c9                   	leave  
  80232e:	c3                   	ret    

0080232f <sys_exit_env>:


void sys_exit_env(void)
{
  80232f:	55                   	push   %ebp
  802330:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  802332:	6a 00                	push   $0x0
  802334:	6a 00                	push   $0x0
  802336:	6a 00                	push   $0x0
  802338:	6a 00                	push   $0x0
  80233a:	6a 00                	push   $0x0
  80233c:	6a 23                	push   $0x23
  80233e:	e8 ee fb ff ff       	call   801f31 <syscall>
  802343:	83 c4 18             	add    $0x18,%esp
}
  802346:	90                   	nop
  802347:	c9                   	leave  
  802348:	c3                   	ret    

00802349 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  802349:	55                   	push   %ebp
  80234a:	89 e5                	mov    %esp,%ebp
  80234c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80234f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802352:	8d 50 04             	lea    0x4(%eax),%edx
  802355:	8d 45 f8             	lea    -0x8(%ebp),%eax
  802358:	6a 00                	push   $0x0
  80235a:	6a 00                	push   $0x0
  80235c:	6a 00                	push   $0x0
  80235e:	52                   	push   %edx
  80235f:	50                   	push   %eax
  802360:	6a 24                	push   $0x24
  802362:	e8 ca fb ff ff       	call   801f31 <syscall>
  802367:	83 c4 18             	add    $0x18,%esp
	return result;
  80236a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80236d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  802370:	8b 55 fc             	mov    -0x4(%ebp),%edx
  802373:	89 01                	mov    %eax,(%ecx)
  802375:	89 51 04             	mov    %edx,0x4(%ecx)
}
  802378:	8b 45 08             	mov    0x8(%ebp),%eax
  80237b:	c9                   	leave  
  80237c:	c2 04 00             	ret    $0x4

0080237f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80237f:	55                   	push   %ebp
  802380:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  802382:	6a 00                	push   $0x0
  802384:	6a 00                	push   $0x0
  802386:	ff 75 10             	pushl  0x10(%ebp)
  802389:	ff 75 0c             	pushl  0xc(%ebp)
  80238c:	ff 75 08             	pushl  0x8(%ebp)
  80238f:	6a 12                	push   $0x12
  802391:	e8 9b fb ff ff       	call   801f31 <syscall>
  802396:	83 c4 18             	add    $0x18,%esp
	return ;
  802399:	90                   	nop
}
  80239a:	c9                   	leave  
  80239b:	c3                   	ret    

0080239c <sys_rcr2>:
uint32 sys_rcr2()
{
  80239c:	55                   	push   %ebp
  80239d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80239f:	6a 00                	push   $0x0
  8023a1:	6a 00                	push   $0x0
  8023a3:	6a 00                	push   $0x0
  8023a5:	6a 00                	push   $0x0
  8023a7:	6a 00                	push   $0x0
  8023a9:	6a 25                	push   $0x25
  8023ab:	e8 81 fb ff ff       	call   801f31 <syscall>
  8023b0:	83 c4 18             	add    $0x18,%esp
}
  8023b3:	c9                   	leave  
  8023b4:	c3                   	ret    

008023b5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8023b5:	55                   	push   %ebp
  8023b6:	89 e5                	mov    %esp,%ebp
  8023b8:	83 ec 04             	sub    $0x4,%esp
  8023bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8023be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8023c1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8023c5:	6a 00                	push   $0x0
  8023c7:	6a 00                	push   $0x0
  8023c9:	6a 00                	push   $0x0
  8023cb:	6a 00                	push   $0x0
  8023cd:	50                   	push   %eax
  8023ce:	6a 26                	push   $0x26
  8023d0:	e8 5c fb ff ff       	call   801f31 <syscall>
  8023d5:	83 c4 18             	add    $0x18,%esp
	return ;
  8023d8:	90                   	nop
}
  8023d9:	c9                   	leave  
  8023da:	c3                   	ret    

008023db <rsttst>:
void rsttst()
{
  8023db:	55                   	push   %ebp
  8023dc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8023de:	6a 00                	push   $0x0
  8023e0:	6a 00                	push   $0x0
  8023e2:	6a 00                	push   $0x0
  8023e4:	6a 00                	push   $0x0
  8023e6:	6a 00                	push   $0x0
  8023e8:	6a 28                	push   $0x28
  8023ea:	e8 42 fb ff ff       	call   801f31 <syscall>
  8023ef:	83 c4 18             	add    $0x18,%esp
	return ;
  8023f2:	90                   	nop
}
  8023f3:	c9                   	leave  
  8023f4:	c3                   	ret    

008023f5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8023f5:	55                   	push   %ebp
  8023f6:	89 e5                	mov    %esp,%ebp
  8023f8:	83 ec 04             	sub    $0x4,%esp
  8023fb:	8b 45 14             	mov    0x14(%ebp),%eax
  8023fe:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  802401:	8b 55 18             	mov    0x18(%ebp),%edx
  802404:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  802408:	52                   	push   %edx
  802409:	50                   	push   %eax
  80240a:	ff 75 10             	pushl  0x10(%ebp)
  80240d:	ff 75 0c             	pushl  0xc(%ebp)
  802410:	ff 75 08             	pushl  0x8(%ebp)
  802413:	6a 27                	push   $0x27
  802415:	e8 17 fb ff ff       	call   801f31 <syscall>
  80241a:	83 c4 18             	add    $0x18,%esp
	return ;
  80241d:	90                   	nop
}
  80241e:	c9                   	leave  
  80241f:	c3                   	ret    

00802420 <chktst>:
void chktst(uint32 n)
{
  802420:	55                   	push   %ebp
  802421:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  802423:	6a 00                	push   $0x0
  802425:	6a 00                	push   $0x0
  802427:	6a 00                	push   $0x0
  802429:	6a 00                	push   $0x0
  80242b:	ff 75 08             	pushl  0x8(%ebp)
  80242e:	6a 29                	push   $0x29
  802430:	e8 fc fa ff ff       	call   801f31 <syscall>
  802435:	83 c4 18             	add    $0x18,%esp
	return ;
  802438:	90                   	nop
}
  802439:	c9                   	leave  
  80243a:	c3                   	ret    

0080243b <inctst>:

void inctst()
{
  80243b:	55                   	push   %ebp
  80243c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  80243e:	6a 00                	push   $0x0
  802440:	6a 00                	push   $0x0
  802442:	6a 00                	push   $0x0
  802444:	6a 00                	push   $0x0
  802446:	6a 00                	push   $0x0
  802448:	6a 2a                	push   $0x2a
  80244a:	e8 e2 fa ff ff       	call   801f31 <syscall>
  80244f:	83 c4 18             	add    $0x18,%esp
	return ;
  802452:	90                   	nop
}
  802453:	c9                   	leave  
  802454:	c3                   	ret    

00802455 <gettst>:
uint32 gettst()
{
  802455:	55                   	push   %ebp
  802456:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  802458:	6a 00                	push   $0x0
  80245a:	6a 00                	push   $0x0
  80245c:	6a 00                	push   $0x0
  80245e:	6a 00                	push   $0x0
  802460:	6a 00                	push   $0x0
  802462:	6a 2b                	push   $0x2b
  802464:	e8 c8 fa ff ff       	call   801f31 <syscall>
  802469:	83 c4 18             	add    $0x18,%esp
}
  80246c:	c9                   	leave  
  80246d:	c3                   	ret    

0080246e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  80246e:	55                   	push   %ebp
  80246f:	89 e5                	mov    %esp,%ebp
  802471:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802474:	6a 00                	push   $0x0
  802476:	6a 00                	push   $0x0
  802478:	6a 00                	push   $0x0
  80247a:	6a 00                	push   $0x0
  80247c:	6a 00                	push   $0x0
  80247e:	6a 2c                	push   $0x2c
  802480:	e8 ac fa ff ff       	call   801f31 <syscall>
  802485:	83 c4 18             	add    $0x18,%esp
  802488:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  80248b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  80248f:	75 07                	jne    802498 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802491:	b8 01 00 00 00       	mov    $0x1,%eax
  802496:	eb 05                	jmp    80249d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  802498:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80249d:	c9                   	leave  
  80249e:	c3                   	ret    

0080249f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  80249f:	55                   	push   %ebp
  8024a0:	89 e5                	mov    %esp,%ebp
  8024a2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024a5:	6a 00                	push   $0x0
  8024a7:	6a 00                	push   $0x0
  8024a9:	6a 00                	push   $0x0
  8024ab:	6a 00                	push   $0x0
  8024ad:	6a 00                	push   $0x0
  8024af:	6a 2c                	push   $0x2c
  8024b1:	e8 7b fa ff ff       	call   801f31 <syscall>
  8024b6:	83 c4 18             	add    $0x18,%esp
  8024b9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8024bc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8024c0:	75 07                	jne    8024c9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8024c2:	b8 01 00 00 00       	mov    $0x1,%eax
  8024c7:	eb 05                	jmp    8024ce <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8024c9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ce:	c9                   	leave  
  8024cf:	c3                   	ret    

008024d0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8024d0:	55                   	push   %ebp
  8024d1:	89 e5                	mov    %esp,%ebp
  8024d3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8024d6:	6a 00                	push   $0x0
  8024d8:	6a 00                	push   $0x0
  8024da:	6a 00                	push   $0x0
  8024dc:	6a 00                	push   $0x0
  8024de:	6a 00                	push   $0x0
  8024e0:	6a 2c                	push   $0x2c
  8024e2:	e8 4a fa ff ff       	call   801f31 <syscall>
  8024e7:	83 c4 18             	add    $0x18,%esp
  8024ea:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8024ed:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8024f1:	75 07                	jne    8024fa <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8024f3:	b8 01 00 00 00       	mov    $0x1,%eax
  8024f8:	eb 05                	jmp    8024ff <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8024fa:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8024ff:	c9                   	leave  
  802500:	c3                   	ret    

00802501 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  802501:	55                   	push   %ebp
  802502:	89 e5                	mov    %esp,%ebp
  802504:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802507:	6a 00                	push   $0x0
  802509:	6a 00                	push   $0x0
  80250b:	6a 00                	push   $0x0
  80250d:	6a 00                	push   $0x0
  80250f:	6a 00                	push   $0x0
  802511:	6a 2c                	push   $0x2c
  802513:	e8 19 fa ff ff       	call   801f31 <syscall>
  802518:	83 c4 18             	add    $0x18,%esp
  80251b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  80251e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  802522:	75 07                	jne    80252b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  802524:	b8 01 00 00 00       	mov    $0x1,%eax
  802529:	eb 05                	jmp    802530 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  80252b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802530:	c9                   	leave  
  802531:	c3                   	ret    

00802532 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  802532:	55                   	push   %ebp
  802533:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  802535:	6a 00                	push   $0x0
  802537:	6a 00                	push   $0x0
  802539:	6a 00                	push   $0x0
  80253b:	6a 00                	push   $0x0
  80253d:	ff 75 08             	pushl  0x8(%ebp)
  802540:	6a 2d                	push   $0x2d
  802542:	e8 ea f9 ff ff       	call   801f31 <syscall>
  802547:	83 c4 18             	add    $0x18,%esp
	return ;
  80254a:	90                   	nop
}
  80254b:	c9                   	leave  
  80254c:	c3                   	ret    

0080254d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  80254d:	55                   	push   %ebp
  80254e:	89 e5                	mov    %esp,%ebp
  802550:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  802551:	8b 5d 14             	mov    0x14(%ebp),%ebx
  802554:	8b 4d 10             	mov    0x10(%ebp),%ecx
  802557:	8b 55 0c             	mov    0xc(%ebp),%edx
  80255a:	8b 45 08             	mov    0x8(%ebp),%eax
  80255d:	6a 00                	push   $0x0
  80255f:	53                   	push   %ebx
  802560:	51                   	push   %ecx
  802561:	52                   	push   %edx
  802562:	50                   	push   %eax
  802563:	6a 2e                	push   $0x2e
  802565:	e8 c7 f9 ff ff       	call   801f31 <syscall>
  80256a:	83 c4 18             	add    $0x18,%esp
}
  80256d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802570:	c9                   	leave  
  802571:	c3                   	ret    

00802572 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802572:	55                   	push   %ebp
  802573:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  802575:	8b 55 0c             	mov    0xc(%ebp),%edx
  802578:	8b 45 08             	mov    0x8(%ebp),%eax
  80257b:	6a 00                	push   $0x0
  80257d:	6a 00                	push   $0x0
  80257f:	6a 00                	push   $0x0
  802581:	52                   	push   %edx
  802582:	50                   	push   %eax
  802583:	6a 2f                	push   $0x2f
  802585:	e8 a7 f9 ff ff       	call   801f31 <syscall>
  80258a:	83 c4 18             	add    $0x18,%esp
}
  80258d:	c9                   	leave  
  80258e:	c3                   	ret    

0080258f <print_mem_block_lists>:
//===========================
// PRINT MEM BLOCK LISTS:
//===========================

void print_mem_block_lists()
{
  80258f:	55                   	push   %ebp
  802590:	89 e5                	mov    %esp,%ebp
  802592:	83 ec 18             	sub    $0x18,%esp
	cprintf("\n=========================================\n");
  802595:	83 ec 0c             	sub    $0xc,%esp
  802598:	68 74 41 80 00       	push   $0x804174
  80259d:	e8 38 e4 ff ff       	call   8009da <cprintf>
  8025a2:	83 c4 10             	add    $0x10,%esp
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
  8025a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nFreeMemBlocksList:\n");
  8025ac:	83 ec 0c             	sub    $0xc,%esp
  8025af:	68 a0 41 80 00       	push   $0x8041a0
  8025b4:	e8 21 e4 ff ff       	call   8009da <cprintf>
  8025b9:	83 c4 10             	add    $0x10,%esp
	uint8 sorted = 1 ;
  8025bc:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &FreeMemBlocksList)
  8025c0:	a1 38 51 80 00       	mov    0x805138,%eax
  8025c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8025c8:	eb 56                	jmp    802620 <print_mem_block_lists+0x91>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  8025ca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8025ce:	74 1c                	je     8025ec <print_mem_block_lists+0x5d>
  8025d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025d3:	8b 50 08             	mov    0x8(%eax),%edx
  8025d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025d9:	8b 48 08             	mov    0x8(%eax),%ecx
  8025dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8025df:	8b 40 0c             	mov    0xc(%eax),%eax
  8025e2:	01 c8                	add    %ecx,%eax
  8025e4:	39 c2                	cmp    %eax,%edx
  8025e6:	73 04                	jae    8025ec <print_mem_block_lists+0x5d>
			sorted = 0 ;
  8025e8:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8025ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025ef:	8b 50 08             	mov    0x8(%eax),%edx
  8025f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025f5:	8b 40 0c             	mov    0xc(%eax),%eax
  8025f8:	01 c2                	add    %eax,%edx
  8025fa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8025fd:	8b 40 08             	mov    0x8(%eax),%eax
  802600:	83 ec 04             	sub    $0x4,%esp
  802603:	52                   	push   %edx
  802604:	50                   	push   %eax
  802605:	68 b5 41 80 00       	push   $0x8041b5
  80260a:	e8 cb e3 ff ff       	call   8009da <cprintf>
  80260f:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  802612:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802615:	89 45 f0             	mov    %eax,-0x10(%ebp)
	cprintf("\n=========================================\n");
	struct MemBlock* blk ;
	struct MemBlock* lastBlk = NULL ;
	cprintf("\nFreeMemBlocksList:\n");
	uint8 sorted = 1 ;
	LIST_FOREACH(blk, &FreeMemBlocksList)
  802618:	a1 40 51 80 00       	mov    0x805140,%eax
  80261d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802620:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802624:	74 07                	je     80262d <print_mem_block_lists+0x9e>
  802626:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802629:	8b 00                	mov    (%eax),%eax
  80262b:	eb 05                	jmp    802632 <print_mem_block_lists+0xa3>
  80262d:	b8 00 00 00 00       	mov    $0x0,%eax
  802632:	a3 40 51 80 00       	mov    %eax,0x805140
  802637:	a1 40 51 80 00       	mov    0x805140,%eax
  80263c:	85 c0                	test   %eax,%eax
  80263e:	75 8a                	jne    8025ca <print_mem_block_lists+0x3b>
  802640:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802644:	75 84                	jne    8025ca <print_mem_block_lists+0x3b>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;
  802646:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  80264a:	75 10                	jne    80265c <print_mem_block_lists+0xcd>
  80264c:	83 ec 0c             	sub    $0xc,%esp
  80264f:	68 c4 41 80 00       	push   $0x8041c4
  802654:	e8 81 e3 ff ff       	call   8009da <cprintf>
  802659:	83 c4 10             	add    $0x10,%esp

	lastBlk = NULL ;
  80265c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	cprintf("\nAllocMemBlocksList:\n");
  802663:	83 ec 0c             	sub    $0xc,%esp
  802666:	68 e8 41 80 00       	push   $0x8041e8
  80266b:	e8 6a e3 ff ff       	call   8009da <cprintf>
  802670:	83 c4 10             	add    $0x10,%esp
	sorted = 1 ;
  802673:	c6 45 ef 01          	movb   $0x1,-0x11(%ebp)
	LIST_FOREACH(blk, &AllocMemBlocksList)
  802677:	a1 40 50 80 00       	mov    0x805040,%eax
  80267c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80267f:	eb 56                	jmp    8026d7 <print_mem_block_lists+0x148>
	{
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
  802681:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802685:	74 1c                	je     8026a3 <print_mem_block_lists+0x114>
  802687:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80268a:	8b 50 08             	mov    0x8(%eax),%edx
  80268d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802690:	8b 48 08             	mov    0x8(%eax),%ecx
  802693:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802696:	8b 40 0c             	mov    0xc(%eax),%eax
  802699:	01 c8                	add    %ecx,%eax
  80269b:	39 c2                	cmp    %eax,%edx
  80269d:	73 04                	jae    8026a3 <print_mem_block_lists+0x114>
			sorted = 0 ;
  80269f:	c6 45 ef 00          	movb   $0x0,-0x11(%ebp)
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
  8026a3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026a6:	8b 50 08             	mov    0x8(%eax),%edx
  8026a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026ac:	8b 40 0c             	mov    0xc(%eax),%eax
  8026af:	01 c2                	add    %eax,%edx
  8026b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026b4:	8b 40 08             	mov    0x8(%eax),%eax
  8026b7:	83 ec 04             	sub    $0x4,%esp
  8026ba:	52                   	push   %edx
  8026bb:	50                   	push   %eax
  8026bc:	68 b5 41 80 00       	push   $0x8041b5
  8026c1:	e8 14 e3 ff ff       	call   8009da <cprintf>
  8026c6:	83 c4 10             	add    $0x10,%esp
		lastBlk = blk;
  8026c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026cc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!sorted)	cprintf("\nFreeMemBlocksList is NOT SORTED!!\n") ;

	lastBlk = NULL ;
	cprintf("\nAllocMemBlocksList:\n");
	sorted = 1 ;
	LIST_FOREACH(blk, &AllocMemBlocksList)
  8026cf:	a1 48 50 80 00       	mov    0x805048,%eax
  8026d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8026d7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026db:	74 07                	je     8026e4 <print_mem_block_lists+0x155>
  8026dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8026e0:	8b 00                	mov    (%eax),%eax
  8026e2:	eb 05                	jmp    8026e9 <print_mem_block_lists+0x15a>
  8026e4:	b8 00 00 00 00       	mov    $0x0,%eax
  8026e9:	a3 48 50 80 00       	mov    %eax,0x805048
  8026ee:	a1 48 50 80 00       	mov    0x805048,%eax
  8026f3:	85 c0                	test   %eax,%eax
  8026f5:	75 8a                	jne    802681 <print_mem_block_lists+0xf2>
  8026f7:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8026fb:	75 84                	jne    802681 <print_mem_block_lists+0xf2>
		if (lastBlk && blk->sva < lastBlk->sva + lastBlk->size)
			sorted = 0 ;
		cprintf("[%x, %x)-->", blk->sva, blk->sva + blk->size) ;
		lastBlk = blk;
	}
	if (!sorted)	cprintf("\nAllocMemBlocksList is NOT SORTED!!\n") ;
  8026fd:	80 7d ef 00          	cmpb   $0x0,-0x11(%ebp)
  802701:	75 10                	jne    802713 <print_mem_block_lists+0x184>
  802703:	83 ec 0c             	sub    $0xc,%esp
  802706:	68 00 42 80 00       	push   $0x804200
  80270b:	e8 ca e2 ff ff       	call   8009da <cprintf>
  802710:	83 c4 10             	add    $0x10,%esp
	cprintf("\n=========================================\n");
  802713:	83 ec 0c             	sub    $0xc,%esp
  802716:	68 74 41 80 00       	push   $0x804174
  80271b:	e8 ba e2 ff ff       	call   8009da <cprintf>
  802720:	83 c4 10             	add    $0x10,%esp

}
  802723:	90                   	nop
  802724:	c9                   	leave  
  802725:	c3                   	ret    

00802726 <initialize_MemBlocksList>:

//===============================
// [1] INITIALIZE AVAILABLE LIST:
//===============================
void initialize_MemBlocksList(uint32 numOfBlocks)
{
  802726:	55                   	push   %ebp
  802727:	89 e5                	mov    %esp,%ebp
  802729:	83 ec 18             	sub    $0x18,%esp
	LIST_INIT(&AvailableMemBlocksList);
  80272c:	c7 05 48 51 80 00 00 	movl   $0x0,0x805148
  802733:	00 00 00 
  802736:	c7 05 4c 51 80 00 00 	movl   $0x0,0x80514c
  80273d:	00 00 00 
  802740:	c7 05 54 51 80 00 00 	movl   $0x0,0x805154
  802747:	00 00 00 

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  80274a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  802751:	e9 9e 00 00 00       	jmp    8027f4 <initialize_MemBlocksList+0xce>
LIST_INSERT_HEAD(&AvailableMemBlocksList , &(MemBlockNodes[i]));
  802756:	a1 50 50 80 00       	mov    0x805050,%eax
  80275b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80275e:	c1 e2 04             	shl    $0x4,%edx
  802761:	01 d0                	add    %edx,%eax
  802763:	85 c0                	test   %eax,%eax
  802765:	75 14                	jne    80277b <initialize_MemBlocksList+0x55>
  802767:	83 ec 04             	sub    $0x4,%esp
  80276a:	68 28 42 80 00       	push   $0x804228
  80276f:	6a 3d                	push   $0x3d
  802771:	68 4b 42 80 00       	push   $0x80424b
  802776:	e8 ab df ff ff       	call   800726 <_panic>
  80277b:	a1 50 50 80 00       	mov    0x805050,%eax
  802780:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802783:	c1 e2 04             	shl    $0x4,%edx
  802786:	01 d0                	add    %edx,%eax
  802788:	8b 15 48 51 80 00    	mov    0x805148,%edx
  80278e:	89 10                	mov    %edx,(%eax)
  802790:	8b 00                	mov    (%eax),%eax
  802792:	85 c0                	test   %eax,%eax
  802794:	74 18                	je     8027ae <initialize_MemBlocksList+0x88>
  802796:	a1 48 51 80 00       	mov    0x805148,%eax
  80279b:	8b 15 50 50 80 00    	mov    0x805050,%edx
  8027a1:	8b 4d f4             	mov    -0xc(%ebp),%ecx
  8027a4:	c1 e1 04             	shl    $0x4,%ecx
  8027a7:	01 ca                	add    %ecx,%edx
  8027a9:	89 50 04             	mov    %edx,0x4(%eax)
  8027ac:	eb 12                	jmp    8027c0 <initialize_MemBlocksList+0x9a>
  8027ae:	a1 50 50 80 00       	mov    0x805050,%eax
  8027b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027b6:	c1 e2 04             	shl    $0x4,%edx
  8027b9:	01 d0                	add    %edx,%eax
  8027bb:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8027c0:	a1 50 50 80 00       	mov    0x805050,%eax
  8027c5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027c8:	c1 e2 04             	shl    $0x4,%edx
  8027cb:	01 d0                	add    %edx,%eax
  8027cd:	a3 48 51 80 00       	mov    %eax,0x805148
  8027d2:	a1 50 50 80 00       	mov    0x805050,%eax
  8027d7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8027da:	c1 e2 04             	shl    $0x4,%edx
  8027dd:	01 d0                	add    %edx,%eax
  8027df:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8027e6:	a1 54 51 80 00       	mov    0x805154,%eax
  8027eb:	40                   	inc    %eax
  8027ec:	a3 54 51 80 00       	mov    %eax,0x805154
void initialize_MemBlocksList(uint32 numOfBlocks)
{
	LIST_INIT(&AvailableMemBlocksList);

	int i ;
	for (i = 0 ; i < numOfBlocks ; i++ ){
  8027f1:	ff 45 f4             	incl   -0xc(%ebp)
  8027f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8027f7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8027fa:	0f 82 56 ff ff ff    	jb     802756 <initialize_MemBlocksList+0x30>

//	//TODO: [PROJECT MS1] [DYNAMIC ALLOCATOR] initialize_MemBlocksList
//	// Write your code here, remove the panic and write your code
//	panic("initialize_MemBlocksList() is not implemented yet...!!");

}
  802800:	90                   	nop
  802801:	c9                   	leave  
  802802:	c3                   	ret    

00802803 <find_block>:

//===============================
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
  802803:	55                   	push   %ebp
  802804:	89 e5                	mov    %esp,%ebp
  802806:	83 ec 10             	sub    $0x10,%esp
	struct MemBlock *tmp = blockList->lh_first;
  802809:	8b 45 08             	mov    0x8(%ebp),%eax
  80280c:	8b 00                	mov    (%eax),%eax
  80280e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while(tmp!=NULL){
  802811:	eb 18                	jmp    80282b <find_block+0x28>

		if(tmp->sva == va){
  802813:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802816:	8b 40 08             	mov    0x8(%eax),%eax
  802819:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80281c:	75 05                	jne    802823 <find_block+0x20>
			return tmp ;
  80281e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802821:	eb 11                	jmp    802834 <find_block+0x31>
		}
		tmp = tmp->prev_next_info.le_next;
  802823:	8b 45 fc             	mov    -0x4(%ebp),%eax
  802826:	8b 00                	mov    (%eax),%eax
  802828:	89 45 fc             	mov    %eax,-0x4(%ebp)
// [2] FIND BLOCK:
//===============================
struct MemBlock *find_block(struct MemBlock_List *blockList, uint32 va)
{
	struct MemBlock *tmp = blockList->lh_first;
	while(tmp!=NULL){
  80282b:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80282f:	75 e2                	jne    802813 <find_block+0x10>
		if(tmp->sva == va){
			return tmp ;
		}
		tmp = tmp->prev_next_info.le_next;
	}
	return tmp ;
  802831:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  802834:	c9                   	leave  
  802835:	c3                   	ret    

00802836 <insert_sorted_allocList>:
//=========================================



void insert_sorted_allocList(struct MemBlock *blockToInsert)
{
  802836:	55                   	push   %ebp
  802837:	89 e5                	mov    %esp,%ebp
  802839:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
  80283c:	a1 40 50 80 00       	mov    0x805040,%eax
  802841:	89 45 f4             	mov    %eax,-0xc(%ebp)
   int n=LIST_SIZE(&(AllocMemBlocksList));
  802844:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802849:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if(n==0){
  80284c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802850:	75 65                	jne    8028b7 <insert_sorted_allocList+0x81>
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
  802852:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802856:	75 14                	jne    80286c <insert_sorted_allocList+0x36>
  802858:	83 ec 04             	sub    $0x4,%esp
  80285b:	68 28 42 80 00       	push   $0x804228
  802860:	6a 62                	push   $0x62
  802862:	68 4b 42 80 00       	push   $0x80424b
  802867:	e8 ba de ff ff       	call   800726 <_panic>
  80286c:	8b 15 40 50 80 00    	mov    0x805040,%edx
  802872:	8b 45 08             	mov    0x8(%ebp),%eax
  802875:	89 10                	mov    %edx,(%eax)
  802877:	8b 45 08             	mov    0x8(%ebp),%eax
  80287a:	8b 00                	mov    (%eax),%eax
  80287c:	85 c0                	test   %eax,%eax
  80287e:	74 0d                	je     80288d <insert_sorted_allocList+0x57>
  802880:	a1 40 50 80 00       	mov    0x805040,%eax
  802885:	8b 55 08             	mov    0x8(%ebp),%edx
  802888:	89 50 04             	mov    %edx,0x4(%eax)
  80288b:	eb 08                	jmp    802895 <insert_sorted_allocList+0x5f>
  80288d:	8b 45 08             	mov    0x8(%ebp),%eax
  802890:	a3 44 50 80 00       	mov    %eax,0x805044
  802895:	8b 45 08             	mov    0x8(%ebp),%eax
  802898:	a3 40 50 80 00       	mov    %eax,0x805040
  80289d:	8b 45 08             	mov    0x8(%ebp),%eax
  8028a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8028a7:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8028ac:	40                   	inc    %eax
  8028ad:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8028b2:	e9 14 01 00 00       	jmp    8029cb <insert_sorted_allocList+0x195>
    struct MemBlock *temp =AllocMemBlocksList.lh_first;
   int n=LIST_SIZE(&(AllocMemBlocksList));
    if(n==0){
    		//LIST_INIT(&AllocMemBlocksList);
    	        LIST_INSERT_HEAD(&(AllocMemBlocksList),blockToInsert);
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
  8028b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ba:	8b 50 08             	mov    0x8(%eax),%edx
  8028bd:	a1 44 50 80 00       	mov    0x805044,%eax
  8028c2:	8b 40 08             	mov    0x8(%eax),%eax
  8028c5:	39 c2                	cmp    %eax,%edx
  8028c7:	76 65                	jbe    80292e <insert_sorted_allocList+0xf8>
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
  8028c9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8028cd:	75 14                	jne    8028e3 <insert_sorted_allocList+0xad>
  8028cf:	83 ec 04             	sub    $0x4,%esp
  8028d2:	68 64 42 80 00       	push   $0x804264
  8028d7:	6a 64                	push   $0x64
  8028d9:	68 4b 42 80 00       	push   $0x80424b
  8028de:	e8 43 de ff ff       	call   800726 <_panic>
  8028e3:	8b 15 44 50 80 00    	mov    0x805044,%edx
  8028e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8028ec:	89 50 04             	mov    %edx,0x4(%eax)
  8028ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8028f2:	8b 40 04             	mov    0x4(%eax),%eax
  8028f5:	85 c0                	test   %eax,%eax
  8028f7:	74 0c                	je     802905 <insert_sorted_allocList+0xcf>
  8028f9:	a1 44 50 80 00       	mov    0x805044,%eax
  8028fe:	8b 55 08             	mov    0x8(%ebp),%edx
  802901:	89 10                	mov    %edx,(%eax)
  802903:	eb 08                	jmp    80290d <insert_sorted_allocList+0xd7>
  802905:	8b 45 08             	mov    0x8(%ebp),%eax
  802908:	a3 40 50 80 00       	mov    %eax,0x805040
  80290d:	8b 45 08             	mov    0x8(%ebp),%eax
  802910:	a3 44 50 80 00       	mov    %eax,0x805044
  802915:	8b 45 08             	mov    0x8(%ebp),%eax
  802918:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80291e:	a1 4c 50 80 00       	mov    0x80504c,%eax
  802923:	40                   	inc    %eax
  802924:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  802929:	e9 9d 00 00 00       	jmp    8029cb <insert_sorted_allocList+0x195>
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  80292e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  802935:	e9 85 00 00 00       	jmp    8029bf <insert_sorted_allocList+0x189>

    	    	if(blockToInsert->sva < temp->sva){
  80293a:	8b 45 08             	mov    0x8(%ebp),%eax
  80293d:	8b 50 08             	mov    0x8(%eax),%edx
  802940:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802943:	8b 40 08             	mov    0x8(%eax),%eax
  802946:	39 c2                	cmp    %eax,%edx
  802948:	73 6a                	jae    8029b4 <insert_sorted_allocList+0x17e>
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
  80294a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80294e:	74 06                	je     802956 <insert_sorted_allocList+0x120>
  802950:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802954:	75 14                	jne    80296a <insert_sorted_allocList+0x134>
  802956:	83 ec 04             	sub    $0x4,%esp
  802959:	68 88 42 80 00       	push   $0x804288
  80295e:	6a 6b                	push   $0x6b
  802960:	68 4b 42 80 00       	push   $0x80424b
  802965:	e8 bc dd ff ff       	call   800726 <_panic>
  80296a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80296d:	8b 50 04             	mov    0x4(%eax),%edx
  802970:	8b 45 08             	mov    0x8(%ebp),%eax
  802973:	89 50 04             	mov    %edx,0x4(%eax)
  802976:	8b 45 08             	mov    0x8(%ebp),%eax
  802979:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80297c:	89 10                	mov    %edx,(%eax)
  80297e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802981:	8b 40 04             	mov    0x4(%eax),%eax
  802984:	85 c0                	test   %eax,%eax
  802986:	74 0d                	je     802995 <insert_sorted_allocList+0x15f>
  802988:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80298b:	8b 40 04             	mov    0x4(%eax),%eax
  80298e:	8b 55 08             	mov    0x8(%ebp),%edx
  802991:	89 10                	mov    %edx,(%eax)
  802993:	eb 08                	jmp    80299d <insert_sorted_allocList+0x167>
  802995:	8b 45 08             	mov    0x8(%ebp),%eax
  802998:	a3 40 50 80 00       	mov    %eax,0x805040
  80299d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029a0:	8b 55 08             	mov    0x8(%ebp),%edx
  8029a3:	89 50 04             	mov    %edx,0x4(%eax)
  8029a6:	a1 4c 50 80 00       	mov    0x80504c,%eax
  8029ab:	40                   	inc    %eax
  8029ac:	a3 4c 50 80 00       	mov    %eax,0x80504c
    	    			break;
  8029b1:	90                   	nop
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8029b2:	eb 17                	jmp    8029cb <insert_sorted_allocList+0x195>

    	    	if(blockToInsert->sva < temp->sva){
    	    		LIST_INSERT_BEFORE(&(AllocMemBlocksList),temp,blockToInsert);
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
  8029b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029b7:	8b 00                	mov    (%eax),%eax
  8029b9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    	    }else if (blockToInsert->sva > AllocMemBlocksList.lh_last->sva ){
    	        LIST_INSERT_TAIL( &(AllocMemBlocksList) , blockToInsert);
    	    }
    	    else {
    	int i;
    	for(i=0; i<n ; i++){
  8029bc:	ff 45 f0             	incl   -0x10(%ebp)
  8029bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029c2:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  8029c5:	0f 8c 6f ff ff ff    	jl     80293a <insert_sorted_allocList+0x104>
    	    			break;
    	    			}
    	    			temp=temp->prev_next_info.le_next;
    	}
    }
}
  8029cb:	90                   	nop
  8029cc:	c9                   	leave  
  8029cd:	c3                   	ret    

008029ce <alloc_block_FF>:

//=========================================
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
  8029ce:	55                   	push   %ebp
  8029cf:	89 e5                	mov    %esp,%ebp
  8029d1:	83 ec 18             	sub    $0x18,%esp
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
  8029d4:	a1 38 51 80 00       	mov    0x805138,%eax
  8029d9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while (pointertempp!= NULL){
  8029dc:	e9 7c 01 00 00       	jmp    802b5d <alloc_block_FF+0x18f>
        if (pointertempp->size > size){
  8029e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8029e4:	8b 40 0c             	mov    0xc(%eax),%eax
  8029e7:	3b 45 08             	cmp    0x8(%ebp),%eax
  8029ea:	0f 86 cf 00 00 00    	jbe    802abf <alloc_block_FF+0xf1>
            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  8029f0:	a1 48 51 80 00       	mov    0x805148,%eax
  8029f5:	89 45 f0             	mov    %eax,-0x10(%ebp)
            struct MemBlock *newBlock = ptrnew;
  8029f8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8029fb:	89 45 ec             	mov    %eax,-0x14(%ebp)
             newBlock->size = size;
  8029fe:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a01:	8b 55 08             	mov    0x8(%ebp),%edx
  802a04:	89 50 0c             	mov    %edx,0xc(%eax)
             newBlock->sva = pointertempp->sva ;
  802a07:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a0a:	8b 50 08             	mov    0x8(%eax),%edx
  802a0d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a10:	89 50 08             	mov    %edx,0x8(%eax)
              pointertempp->size = pointertempp->size - size;
  802a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a16:	8b 40 0c             	mov    0xc(%eax),%eax
  802a19:	2b 45 08             	sub    0x8(%ebp),%eax
  802a1c:	89 c2                	mov    %eax,%edx
  802a1e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a21:	89 50 0c             	mov    %edx,0xc(%eax)
              pointertempp->sva =pointertempp->sva + size ;
  802a24:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a27:	8b 50 08             	mov    0x8(%eax),%edx
  802a2a:	8b 45 08             	mov    0x8(%ebp),%eax
  802a2d:	01 c2                	add    %eax,%edx
  802a2f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802a32:	89 50 08             	mov    %edx,0x8(%eax)
            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802a35:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802a39:	75 17                	jne    802a52 <alloc_block_FF+0x84>
  802a3b:	83 ec 04             	sub    $0x4,%esp
  802a3e:	68 bd 42 80 00       	push   $0x8042bd
  802a43:	68 83 00 00 00       	push   $0x83
  802a48:	68 4b 42 80 00       	push   $0x80424b
  802a4d:	e8 d4 dc ff ff       	call   800726 <_panic>
  802a52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a55:	8b 00                	mov    (%eax),%eax
  802a57:	85 c0                	test   %eax,%eax
  802a59:	74 10                	je     802a6b <alloc_block_FF+0x9d>
  802a5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a5e:	8b 00                	mov    (%eax),%eax
  802a60:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a63:	8b 52 04             	mov    0x4(%edx),%edx
  802a66:	89 50 04             	mov    %edx,0x4(%eax)
  802a69:	eb 0b                	jmp    802a76 <alloc_block_FF+0xa8>
  802a6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a6e:	8b 40 04             	mov    0x4(%eax),%eax
  802a71:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802a76:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a79:	8b 40 04             	mov    0x4(%eax),%eax
  802a7c:	85 c0                	test   %eax,%eax
  802a7e:	74 0f                	je     802a8f <alloc_block_FF+0xc1>
  802a80:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a83:	8b 40 04             	mov    0x4(%eax),%eax
  802a86:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802a89:	8b 12                	mov    (%edx),%edx
  802a8b:	89 10                	mov    %edx,(%eax)
  802a8d:	eb 0a                	jmp    802a99 <alloc_block_FF+0xcb>
  802a8f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a92:	8b 00                	mov    (%eax),%eax
  802a94:	a3 48 51 80 00       	mov    %eax,0x805148
  802a99:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802a9c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802aa2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aa5:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802aac:	a1 54 51 80 00       	mov    0x805154,%eax
  802ab1:	48                   	dec    %eax
  802ab2:	a3 54 51 80 00       	mov    %eax,0x805154
                    return newBlock ;
  802ab7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802aba:	e9 ad 00 00 00       	jmp    802b6c <alloc_block_FF+0x19e>
                    }
        else if (pointertempp->size == size){
  802abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ac2:	8b 40 0c             	mov    0xc(%eax),%eax
  802ac5:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ac8:	0f 85 87 00 00 00    	jne    802b55 <alloc_block_FF+0x187>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
  802ace:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802ad2:	75 17                	jne    802aeb <alloc_block_FF+0x11d>
  802ad4:	83 ec 04             	sub    $0x4,%esp
  802ad7:	68 bd 42 80 00       	push   $0x8042bd
  802adc:	68 87 00 00 00       	push   $0x87
  802ae1:	68 4b 42 80 00       	push   $0x80424b
  802ae6:	e8 3b dc ff ff       	call   800726 <_panic>
  802aeb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802aee:	8b 00                	mov    (%eax),%eax
  802af0:	85 c0                	test   %eax,%eax
  802af2:	74 10                	je     802b04 <alloc_block_FF+0x136>
  802af4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802af7:	8b 00                	mov    (%eax),%eax
  802af9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802afc:	8b 52 04             	mov    0x4(%edx),%edx
  802aff:	89 50 04             	mov    %edx,0x4(%eax)
  802b02:	eb 0b                	jmp    802b0f <alloc_block_FF+0x141>
  802b04:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b07:	8b 40 04             	mov    0x4(%eax),%eax
  802b0a:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b12:	8b 40 04             	mov    0x4(%eax),%eax
  802b15:	85 c0                	test   %eax,%eax
  802b17:	74 0f                	je     802b28 <alloc_block_FF+0x15a>
  802b19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b1c:	8b 40 04             	mov    0x4(%eax),%eax
  802b1f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802b22:	8b 12                	mov    (%edx),%edx
  802b24:	89 10                	mov    %edx,(%eax)
  802b26:	eb 0a                	jmp    802b32 <alloc_block_FF+0x164>
  802b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b2b:	8b 00                	mov    (%eax),%eax
  802b2d:	a3 38 51 80 00       	mov    %eax,0x805138
  802b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b35:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802b3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b3e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802b45:	a1 44 51 80 00       	mov    0x805144,%eax
  802b4a:	48                   	dec    %eax
  802b4b:	a3 44 51 80 00       	mov    %eax,0x805144
                        return  pointertempp;
  802b50:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b53:	eb 17                	jmp    802b6c <alloc_block_FF+0x19e>
                }
        pointertempp = pointertempp->prev_next_info.le_next;
  802b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b58:	8b 00                	mov    (%eax),%eax
  802b5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
// [4] ALLOCATE BLOCK BY FIRST FIT:
//=========================================
struct MemBlock *alloc_block_FF(uint32 size)
{
    struct MemBlock *pointertempp = FreeMemBlocksList.lh_first  ;
    while (pointertempp!= NULL){
  802b5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802b61:	0f 85 7a fe ff ff    	jne    8029e1 <alloc_block_FF+0x13>
                        LIST_REMOVE(&(FreeMemBlocksList),pointertempp);
                        return  pointertempp;
                }
        pointertempp = pointertempp->prev_next_info.le_next;
    }
    return 0 ;
  802b67:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802b6c:	c9                   	leave  
  802b6d:	c3                   	ret    

00802b6e <alloc_block_BF>:

//=========================================
// [5] ALLOCATE BLOCK BY BEST FIT:
//=========================================
struct MemBlock *alloc_block_BF(uint32 size)
{
  802b6e:	55                   	push   %ebp
  802b6f:	89 e5                	mov    %esp,%ebp
  802b71:	83 ec 28             	sub    $0x28,%esp
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
  802b74:	a1 38 51 80 00       	mov    0x805138,%eax
  802b79:	89 45 f4             	mov    %eax,-0xc(%ebp)
	struct MemBlock *pointer2 = NULL;
  802b7c:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	uint32 differsize= 999999999;
  802b83:	c7 45 ec ff c9 9a 3b 	movl   $0x3b9ac9ff,-0x14(%ebp)

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802b8a:	a1 38 51 80 00       	mov    0x805138,%eax
  802b8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802b92:	e9 d0 00 00 00       	jmp    802c67 <alloc_block_BF+0xf9>
		if (elementiterator->size >= size){
  802b97:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802b9a:	8b 40 0c             	mov    0xc(%eax),%eax
  802b9d:	3b 45 08             	cmp    0x8(%ebp),%eax
  802ba0:	0f 82 b8 00 00 00    	jb     802c5e <alloc_block_BF+0xf0>
			uint32 differance = elementiterator->size - size ;
  802ba6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ba9:	8b 40 0c             	mov    0xc(%eax),%eax
  802bac:	2b 45 08             	sub    0x8(%ebp),%eax
  802baf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			if (differance < differsize){
  802bb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bb5:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  802bb8:	0f 83 a1 00 00 00    	jae    802c5f <alloc_block_BF+0xf1>
				differsize = differance ;
  802bbe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  802bc1:	89 45 ec             	mov    %eax,-0x14(%ebp)
				pointer2 = elementiterator ;
  802bc4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bc7:	89 45 f0             	mov    %eax,-0x10(%ebp)
				if (differsize == 0){
  802bca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802bce:	0f 85 8b 00 00 00    	jne    802c5f <alloc_block_BF+0xf1>
					LIST_REMOVE(&(FreeMemBlocksList), elementiterator);
  802bd4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802bd8:	75 17                	jne    802bf1 <alloc_block_BF+0x83>
  802bda:	83 ec 04             	sub    $0x4,%esp
  802bdd:	68 bd 42 80 00       	push   $0x8042bd
  802be2:	68 a0 00 00 00       	push   $0xa0
  802be7:	68 4b 42 80 00       	push   $0x80424b
  802bec:	e8 35 db ff ff       	call   800726 <_panic>
  802bf1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bf4:	8b 00                	mov    (%eax),%eax
  802bf6:	85 c0                	test   %eax,%eax
  802bf8:	74 10                	je     802c0a <alloc_block_BF+0x9c>
  802bfa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802bfd:	8b 00                	mov    (%eax),%eax
  802bff:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c02:	8b 52 04             	mov    0x4(%edx),%edx
  802c05:	89 50 04             	mov    %edx,0x4(%eax)
  802c08:	eb 0b                	jmp    802c15 <alloc_block_BF+0xa7>
  802c0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c0d:	8b 40 04             	mov    0x4(%eax),%eax
  802c10:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c18:	8b 40 04             	mov    0x4(%eax),%eax
  802c1b:	85 c0                	test   %eax,%eax
  802c1d:	74 0f                	je     802c2e <alloc_block_BF+0xc0>
  802c1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c22:	8b 40 04             	mov    0x4(%eax),%eax
  802c25:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802c28:	8b 12                	mov    (%edx),%edx
  802c2a:	89 10                	mov    %edx,(%eax)
  802c2c:	eb 0a                	jmp    802c38 <alloc_block_BF+0xca>
  802c2e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c31:	8b 00                	mov    (%eax),%eax
  802c33:	a3 38 51 80 00       	mov    %eax,0x805138
  802c38:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c3b:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802c41:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c44:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802c4b:	a1 44 51 80 00       	mov    0x805144,%eax
  802c50:	48                   	dec    %eax
  802c51:	a3 44 51 80 00       	mov    %eax,0x805144
					return elementiterator;
  802c56:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c59:	e9 0c 01 00 00       	jmp    802d6a <alloc_block_BF+0x1fc>
				}
			}
		}
		else {
			continue ;
  802c5e:	90                   	nop
{
	struct MemBlock *elementiterator = FreeMemBlocksList.lh_first;
	struct MemBlock *pointer2 = NULL;
	uint32 differsize= 999999999;

	LIST_FOREACH(elementiterator , &(FreeMemBlocksList)){
  802c5f:	a1 40 51 80 00       	mov    0x805140,%eax
  802c64:	89 45 f4             	mov    %eax,-0xc(%ebp)
  802c67:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c6b:	74 07                	je     802c74 <alloc_block_BF+0x106>
  802c6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802c70:	8b 00                	mov    (%eax),%eax
  802c72:	eb 05                	jmp    802c79 <alloc_block_BF+0x10b>
  802c74:	b8 00 00 00 00       	mov    $0x0,%eax
  802c79:	a3 40 51 80 00       	mov    %eax,0x805140
  802c7e:	a1 40 51 80 00       	mov    0x805140,%eax
  802c83:	85 c0                	test   %eax,%eax
  802c85:	0f 85 0c ff ff ff    	jne    802b97 <alloc_block_BF+0x29>
  802c8b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802c8f:	0f 85 02 ff ff ff    	jne    802b97 <alloc_block_BF+0x29>
		}
		else {
			continue ;
		}
	}
	if (pointer2 != NULL){
  802c95:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  802c99:	0f 84 c6 00 00 00    	je     802d65 <alloc_block_BF+0x1f7>
		struct MemBlock *blockToUpdate = LIST_FIRST(&(AvailableMemBlocksList));
  802c9f:	a1 48 51 80 00       	mov    0x805148,%eax
  802ca4:	89 45 e8             	mov    %eax,-0x18(%ebp)
		blockToUpdate->size = size ;
  802ca7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802caa:	8b 55 08             	mov    0x8(%ebp),%edx
  802cad:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToUpdate->sva = pointer2->sva;
  802cb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cb3:	8b 50 08             	mov    0x8(%eax),%edx
  802cb6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cb9:	89 50 08             	mov    %edx,0x8(%eax)
		pointer2->size = pointer2->size -size;
  802cbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cbf:	8b 40 0c             	mov    0xc(%eax),%eax
  802cc2:	2b 45 08             	sub    0x8(%ebp),%eax
  802cc5:	89 c2                	mov    %eax,%edx
  802cc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cca:	89 50 0c             	mov    %edx,0xc(%eax)
		pointer2->sva = pointer2->sva + size ;
  802ccd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cd0:	8b 50 08             	mov    0x8(%eax),%edx
  802cd3:	8b 45 08             	mov    0x8(%ebp),%eax
  802cd6:	01 c2                	add    %eax,%edx
  802cd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802cdb:	89 50 08             	mov    %edx,0x8(%eax)
		LIST_REMOVE(&(AvailableMemBlocksList), blockToUpdate);
  802cde:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  802ce2:	75 17                	jne    802cfb <alloc_block_BF+0x18d>
  802ce4:	83 ec 04             	sub    $0x4,%esp
  802ce7:	68 bd 42 80 00       	push   $0x8042bd
  802cec:	68 af 00 00 00       	push   $0xaf
  802cf1:	68 4b 42 80 00       	push   $0x80424b
  802cf6:	e8 2b da ff ff       	call   800726 <_panic>
  802cfb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802cfe:	8b 00                	mov    (%eax),%eax
  802d00:	85 c0                	test   %eax,%eax
  802d02:	74 10                	je     802d14 <alloc_block_BF+0x1a6>
  802d04:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d07:	8b 00                	mov    (%eax),%eax
  802d09:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d0c:	8b 52 04             	mov    0x4(%edx),%edx
  802d0f:	89 50 04             	mov    %edx,0x4(%eax)
  802d12:	eb 0b                	jmp    802d1f <alloc_block_BF+0x1b1>
  802d14:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d17:	8b 40 04             	mov    0x4(%eax),%eax
  802d1a:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802d1f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d22:	8b 40 04             	mov    0x4(%eax),%eax
  802d25:	85 c0                	test   %eax,%eax
  802d27:	74 0f                	je     802d38 <alloc_block_BF+0x1ca>
  802d29:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d2c:	8b 40 04             	mov    0x4(%eax),%eax
  802d2f:	8b 55 e8             	mov    -0x18(%ebp),%edx
  802d32:	8b 12                	mov    (%edx),%edx
  802d34:	89 10                	mov    %edx,(%eax)
  802d36:	eb 0a                	jmp    802d42 <alloc_block_BF+0x1d4>
  802d38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d3b:	8b 00                	mov    (%eax),%eax
  802d3d:	a3 48 51 80 00       	mov    %eax,0x805148
  802d42:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d45:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802d4b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d4e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802d55:	a1 54 51 80 00       	mov    0x805154,%eax
  802d5a:	48                   	dec    %eax
  802d5b:	a3 54 51 80 00       	mov    %eax,0x805154
		return blockToUpdate;
  802d60:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802d63:	eb 05                	jmp    802d6a <alloc_block_BF+0x1fc>
	}

	return NULL;
  802d65:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802d6a:	c9                   	leave  
  802d6b:	c3                   	ret    

00802d6c <alloc_block_NF>:
//=========================================
// [7] ALLOCATE BLOCK BY NEXT FIT:
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
  802d6c:	55                   	push   %ebp
  802d6d:	89 e5                	mov    %esp,%ebp
  802d6f:	83 ec 18             	sub    $0x18,%esp
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
  802d72:	a1 38 51 80 00       	mov    0x805138,%eax
  802d77:	89 45 f4             	mov    %eax,-0xc(%ebp)
	    while (updated!= NULL){
  802d7a:	e9 7c 01 00 00       	jmp    802efb <alloc_block_NF+0x18f>
	        if (updated->size > size){
  802d7f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802d82:	8b 40 0c             	mov    0xc(%eax),%eax
  802d85:	3b 45 08             	cmp    0x8(%ebp),%eax
  802d88:	0f 86 cf 00 00 00    	jbe    802e5d <alloc_block_NF+0xf1>
	            struct MemBlock *ptrnew =LIST_FIRST(&(AvailableMemBlocksList));
  802d8e:	a1 48 51 80 00       	mov    0x805148,%eax
  802d93:	89 45 f0             	mov    %eax,-0x10(%ebp)
	            struct MemBlock *newBlock = ptrnew;
  802d96:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802d99:	89 45 ec             	mov    %eax,-0x14(%ebp)
	             newBlock->size = size;
  802d9c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802d9f:	8b 55 08             	mov    0x8(%ebp),%edx
  802da2:	89 50 0c             	mov    %edx,0xc(%eax)
	             newBlock->sva =updated->sva ;
  802da5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802da8:	8b 50 08             	mov    0x8(%eax),%edx
  802dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dae:	89 50 08             	mov    %edx,0x8(%eax)
	              updated->size = updated->size - size;
  802db1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802db4:	8b 40 0c             	mov    0xc(%eax),%eax
  802db7:	2b 45 08             	sub    0x8(%ebp),%eax
  802dba:	89 c2                	mov    %eax,%edx
  802dbc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dbf:	89 50 0c             	mov    %edx,0xc(%eax)
	              updated->sva =updated->sva + size ;
  802dc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dc5:	8b 50 08             	mov    0x8(%eax),%edx
  802dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  802dcb:	01 c2                	add    %eax,%edx
  802dcd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802dd0:	89 50 08             	mov    %edx,0x8(%eax)
	            LIST_REMOVE(&(AvailableMemBlocksList),newBlock );
  802dd3:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802dd7:	75 17                	jne    802df0 <alloc_block_NF+0x84>
  802dd9:	83 ec 04             	sub    $0x4,%esp
  802ddc:	68 bd 42 80 00       	push   $0x8042bd
  802de1:	68 c4 00 00 00       	push   $0xc4
  802de6:	68 4b 42 80 00       	push   $0x80424b
  802deb:	e8 36 d9 ff ff       	call   800726 <_panic>
  802df0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802df3:	8b 00                	mov    (%eax),%eax
  802df5:	85 c0                	test   %eax,%eax
  802df7:	74 10                	je     802e09 <alloc_block_NF+0x9d>
  802df9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802dfc:	8b 00                	mov    (%eax),%eax
  802dfe:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e01:	8b 52 04             	mov    0x4(%edx),%edx
  802e04:	89 50 04             	mov    %edx,0x4(%eax)
  802e07:	eb 0b                	jmp    802e14 <alloc_block_NF+0xa8>
  802e09:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e0c:	8b 40 04             	mov    0x4(%eax),%eax
  802e0f:	a3 4c 51 80 00       	mov    %eax,0x80514c
  802e14:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e17:	8b 40 04             	mov    0x4(%eax),%eax
  802e1a:	85 c0                	test   %eax,%eax
  802e1c:	74 0f                	je     802e2d <alloc_block_NF+0xc1>
  802e1e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e21:	8b 40 04             	mov    0x4(%eax),%eax
  802e24:	8b 55 ec             	mov    -0x14(%ebp),%edx
  802e27:	8b 12                	mov    (%edx),%edx
  802e29:	89 10                	mov    %edx,(%eax)
  802e2b:	eb 0a                	jmp    802e37 <alloc_block_NF+0xcb>
  802e2d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e30:	8b 00                	mov    (%eax),%eax
  802e32:	a3 48 51 80 00       	mov    %eax,0x805148
  802e37:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e3a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802e40:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e43:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802e4a:	a1 54 51 80 00       	mov    0x805154,%eax
  802e4f:	48                   	dec    %eax
  802e50:	a3 54 51 80 00       	mov    %eax,0x805154
	                    return newBlock ;
  802e55:	8b 45 ec             	mov    -0x14(%ebp),%eax
  802e58:	e9 ad 00 00 00       	jmp    802f0a <alloc_block_NF+0x19e>
	                    }
	        else if (updated->size == size){
  802e5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e60:	8b 40 0c             	mov    0xc(%eax),%eax
  802e63:	3b 45 08             	cmp    0x8(%ebp),%eax
  802e66:	0f 85 87 00 00 00    	jne    802ef3 <alloc_block_NF+0x187>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
  802e6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802e70:	75 17                	jne    802e89 <alloc_block_NF+0x11d>
  802e72:	83 ec 04             	sub    $0x4,%esp
  802e75:	68 bd 42 80 00       	push   $0x8042bd
  802e7a:	68 c8 00 00 00       	push   $0xc8
  802e7f:	68 4b 42 80 00       	push   $0x80424b
  802e84:	e8 9d d8 ff ff       	call   800726 <_panic>
  802e89:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e8c:	8b 00                	mov    (%eax),%eax
  802e8e:	85 c0                	test   %eax,%eax
  802e90:	74 10                	je     802ea2 <alloc_block_NF+0x136>
  802e92:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802e95:	8b 00                	mov    (%eax),%eax
  802e97:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802e9a:	8b 52 04             	mov    0x4(%edx),%edx
  802e9d:	89 50 04             	mov    %edx,0x4(%eax)
  802ea0:	eb 0b                	jmp    802ead <alloc_block_NF+0x141>
  802ea2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ea5:	8b 40 04             	mov    0x4(%eax),%eax
  802ea8:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802ead:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eb0:	8b 40 04             	mov    0x4(%eax),%eax
  802eb3:	85 c0                	test   %eax,%eax
  802eb5:	74 0f                	je     802ec6 <alloc_block_NF+0x15a>
  802eb7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802eba:	8b 40 04             	mov    0x4(%eax),%eax
  802ebd:	8b 55 f4             	mov    -0xc(%ebp),%edx
  802ec0:	8b 12                	mov    (%edx),%edx
  802ec2:	89 10                	mov    %edx,(%eax)
  802ec4:	eb 0a                	jmp    802ed0 <alloc_block_NF+0x164>
  802ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ec9:	8b 00                	mov    (%eax),%eax
  802ecb:	a3 38 51 80 00       	mov    %eax,0x805138
  802ed0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ed3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  802ed9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802edc:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802ee3:	a1 44 51 80 00       	mov    0x805144,%eax
  802ee8:	48                   	dec    %eax
  802ee9:	a3 44 51 80 00       	mov    %eax,0x805144
	                        return  updated;
  802eee:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef1:	eb 17                	jmp    802f0a <alloc_block_NF+0x19e>
	                }
	        updated = updated->prev_next_info.le_next;
  802ef3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  802ef6:	8b 00                	mov    (%eax),%eax
  802ef8:	89 45 f4             	mov    %eax,-0xc(%ebp)
//=========================================
struct MemBlock *alloc_block_NF(uint32 size)

{
	struct MemBlock *updated= FreeMemBlocksList.lh_first  ;
	    while (updated!= NULL){
  802efb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  802eff:	0f 85 7a fe ff ff    	jne    802d7f <alloc_block_NF+0x13>
	                        LIST_REMOVE(&(FreeMemBlocksList),updated);
	                        return  updated;
	                }
	        updated = updated->prev_next_info.le_next;
	    }
	    return 0 ;
  802f05:	b8 00 00 00 00       	mov    $0x0,%eax
	}
  802f0a:	c9                   	leave  
  802f0b:	c3                   	ret    

00802f0c <insert_sorted_with_merge_freeList>:

//===================================================
// [8] INSERT BLOCK (SORTED WITH MERGE) IN FREE LIST:
//===================================================
void insert_sorted_with_merge_freeList(struct MemBlock *blockToInsert)
{
  802f0c:	55                   	push   %ebp
  802f0d:	89 e5                	mov    %esp,%ebp
  802f0f:	83 ec 28             	sub    $0x28,%esp
struct MemBlock *ptr=FreeMemBlocksList.lh_first;
  802f12:	a1 38 51 80 00       	mov    0x805138,%eax
  802f17:	89 45 f4             	mov    %eax,-0xc(%ebp)
struct MemBlock *elementnxt ;
struct MemBlock *lastptr=FreeMemBlocksList.lh_last;
  802f1a:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802f1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
  802f22:	a1 44 51 80 00       	mov    0x805144,%eax
  802f27:	89 45 ec             	mov    %eax,-0x14(%ebp)
if(size_of_free == 0){
  802f2a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802f2e:	75 68                	jne    802f98 <insert_sorted_with_merge_freeList+0x8c>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  802f30:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802f34:	75 17                	jne    802f4d <insert_sorted_with_merge_freeList+0x41>
  802f36:	83 ec 04             	sub    $0x4,%esp
  802f39:	68 28 42 80 00       	push   $0x804228
  802f3e:	68 da 00 00 00       	push   $0xda
  802f43:	68 4b 42 80 00       	push   $0x80424b
  802f48:	e8 d9 d7 ff ff       	call   800726 <_panic>
  802f4d:	8b 15 38 51 80 00    	mov    0x805138,%edx
  802f53:	8b 45 08             	mov    0x8(%ebp),%eax
  802f56:	89 10                	mov    %edx,(%eax)
  802f58:	8b 45 08             	mov    0x8(%ebp),%eax
  802f5b:	8b 00                	mov    (%eax),%eax
  802f5d:	85 c0                	test   %eax,%eax
  802f5f:	74 0d                	je     802f6e <insert_sorted_with_merge_freeList+0x62>
  802f61:	a1 38 51 80 00       	mov    0x805138,%eax
  802f66:	8b 55 08             	mov    0x8(%ebp),%edx
  802f69:	89 50 04             	mov    %edx,0x4(%eax)
  802f6c:	eb 08                	jmp    802f76 <insert_sorted_with_merge_freeList+0x6a>
  802f6e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f71:	a3 3c 51 80 00       	mov    %eax,0x80513c
  802f76:	8b 45 08             	mov    0x8(%ebp),%eax
  802f79:	a3 38 51 80 00       	mov    %eax,0x805138
  802f7e:	8b 45 08             	mov    0x8(%ebp),%eax
  802f81:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  802f88:	a1 44 51 80 00       	mov    0x805144,%eax
  802f8d:	40                   	inc    %eax
  802f8e:	a3 44 51 80 00       	mov    %eax,0x805144



	}
	}
	}
  802f93:	e9 49 07 00 00       	jmp    8036e1 <insert_sorted_with_merge_freeList+0x7d5>
int size_of_free =LIST_SIZE(&(FreeMemBlocksList));
if(size_of_free == 0){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else if((lastptr->sva + lastptr->size) < blockToInsert->sva
  802f98:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802f9b:	8b 50 08             	mov    0x8(%eax),%edx
  802f9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fa1:	8b 40 0c             	mov    0xc(%eax),%eax
  802fa4:	01 c2                	add    %eax,%edx
  802fa6:	8b 45 08             	mov    0x8(%ebp),%eax
  802fa9:	8b 40 08             	mov    0x8(%eax),%eax
  802fac:	39 c2                	cmp    %eax,%edx
  802fae:	73 77                	jae    803027 <insert_sorted_with_merge_freeList+0x11b>
		&& lastptr->prev_next_info.le_next==NULL
  802fb0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  802fb3:	8b 00                	mov    (%eax),%eax
  802fb5:	85 c0                	test   %eax,%eax
  802fb7:	75 6e                	jne    803027 <insert_sorted_with_merge_freeList+0x11b>
		&&size_of_free!=0 ){
  802fb9:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  802fbd:	74 68                	je     803027 <insert_sorted_with_merge_freeList+0x11b>
	LIST_INSERT_TAIL(&(FreeMemBlocksList),blockToInsert);
  802fbf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  802fc3:	75 17                	jne    802fdc <insert_sorted_with_merge_freeList+0xd0>
  802fc5:	83 ec 04             	sub    $0x4,%esp
  802fc8:	68 64 42 80 00       	push   $0x804264
  802fcd:	68 e0 00 00 00       	push   $0xe0
  802fd2:	68 4b 42 80 00       	push   $0x80424b
  802fd7:	e8 4a d7 ff ff       	call   800726 <_panic>
  802fdc:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  802fe2:	8b 45 08             	mov    0x8(%ebp),%eax
  802fe5:	89 50 04             	mov    %edx,0x4(%eax)
  802fe8:	8b 45 08             	mov    0x8(%ebp),%eax
  802feb:	8b 40 04             	mov    0x4(%eax),%eax
  802fee:	85 c0                	test   %eax,%eax
  802ff0:	74 0c                	je     802ffe <insert_sorted_with_merge_freeList+0xf2>
  802ff2:	a1 3c 51 80 00       	mov    0x80513c,%eax
  802ff7:	8b 55 08             	mov    0x8(%ebp),%edx
  802ffa:	89 10                	mov    %edx,(%eax)
  802ffc:	eb 08                	jmp    803006 <insert_sorted_with_merge_freeList+0xfa>
  802ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  803001:	a3 38 51 80 00       	mov    %eax,0x805138
  803006:	8b 45 08             	mov    0x8(%ebp),%eax
  803009:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80300e:	8b 45 08             	mov    0x8(%ebp),%eax
  803011:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  803017:	a1 44 51 80 00       	mov    0x805144,%eax
  80301c:	40                   	inc    %eax
  80301d:	a3 44 51 80 00       	mov    %eax,0x805144
  803022:	e9 ba 06 00 00       	jmp    8036e1 <insert_sorted_with_merge_freeList+0x7d5>

}
else if((blockToInsert->size + blockToInsert->sva) < ptr->sva
  803027:	8b 45 08             	mov    0x8(%ebp),%eax
  80302a:	8b 50 0c             	mov    0xc(%eax),%edx
  80302d:	8b 45 08             	mov    0x8(%ebp),%eax
  803030:	8b 40 08             	mov    0x8(%eax),%eax
  803033:	01 c2                	add    %eax,%edx
  803035:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803038:	8b 40 08             	mov    0x8(%eax),%eax
  80303b:	39 c2                	cmp    %eax,%edx
  80303d:	73 78                	jae    8030b7 <insert_sorted_with_merge_freeList+0x1ab>
		&& ptr->prev_next_info.le_prev==NULL
  80303f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803042:	8b 40 04             	mov    0x4(%eax),%eax
  803045:	85 c0                	test   %eax,%eax
  803047:	75 6e                	jne    8030b7 <insert_sorted_with_merge_freeList+0x1ab>
		&&size_of_free!=0 ){
  803049:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80304d:	74 68                	je     8030b7 <insert_sorted_with_merge_freeList+0x1ab>
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);
  80304f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803053:	75 17                	jne    80306c <insert_sorted_with_merge_freeList+0x160>
  803055:	83 ec 04             	sub    $0x4,%esp
  803058:	68 28 42 80 00       	push   $0x804228
  80305d:	68 e6 00 00 00       	push   $0xe6
  803062:	68 4b 42 80 00       	push   $0x80424b
  803067:	e8 ba d6 ff ff       	call   800726 <_panic>
  80306c:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803072:	8b 45 08             	mov    0x8(%ebp),%eax
  803075:	89 10                	mov    %edx,(%eax)
  803077:	8b 45 08             	mov    0x8(%ebp),%eax
  80307a:	8b 00                	mov    (%eax),%eax
  80307c:	85 c0                	test   %eax,%eax
  80307e:	74 0d                	je     80308d <insert_sorted_with_merge_freeList+0x181>
  803080:	a1 38 51 80 00       	mov    0x805138,%eax
  803085:	8b 55 08             	mov    0x8(%ebp),%edx
  803088:	89 50 04             	mov    %edx,0x4(%eax)
  80308b:	eb 08                	jmp    803095 <insert_sorted_with_merge_freeList+0x189>
  80308d:	8b 45 08             	mov    0x8(%ebp),%eax
  803090:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803095:	8b 45 08             	mov    0x8(%ebp),%eax
  803098:	a3 38 51 80 00       	mov    %eax,0x805138
  80309d:	8b 45 08             	mov    0x8(%ebp),%eax
  8030a0:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8030a7:	a1 44 51 80 00       	mov    0x805144,%eax
  8030ac:	40                   	inc    %eax
  8030ad:	a3 44 51 80 00       	mov    %eax,0x805144
  8030b2:	e9 2a 06 00 00       	jmp    8036e1 <insert_sorted_with_merge_freeList+0x7d5>

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8030b7:	a1 38 51 80 00       	mov    0x805138,%eax
  8030bc:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8030bf:	e9 ed 05 00 00       	jmp    8036b1 <insert_sorted_with_merge_freeList+0x7a5>

		elementnxt = ptr->prev_next_info.le_next;
  8030c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030c7:	8b 00                	mov    (%eax),%eax
  8030c9:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
  8030cc:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8030d0:	0f 84 a7 00 00 00    	je     80317d <insert_sorted_with_merge_freeList+0x271>
  8030d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030d9:	8b 50 0c             	mov    0xc(%eax),%edx
  8030dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8030df:	8b 40 08             	mov    0x8(%eax),%eax
  8030e2:	01 c2                	add    %eax,%edx
  8030e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8030e7:	8b 40 08             	mov    0x8(%eax),%eax
  8030ea:	39 c2                	cmp    %eax,%edx
  8030ec:	0f 83 8b 00 00 00    	jae    80317d <insert_sorted_with_merge_freeList+0x271>
		                    && (blockToInsert->size + blockToInsert->sva)
  8030f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8030f5:	8b 50 0c             	mov    0xc(%eax),%edx
  8030f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8030fb:	8b 40 08             	mov    0x8(%eax),%eax
  8030fe:	01 c2                	add    %eax,%edx
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
  803100:	8b 45 e8             	mov    -0x18(%ebp),%eax
  803103:	8b 40 08             	mov    0x8(%eax),%eax
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){

		elementnxt = ptr->prev_next_info.le_next;
		if (elementnxt != NULL &&(ptr->size + ptr->sva) < blockToInsert->sva
		                    && (blockToInsert->size + blockToInsert->sva)
  803106:	39 c2                	cmp    %eax,%edx
  803108:	73 73                	jae    80317d <insert_sorted_with_merge_freeList+0x271>
		                            < elementnxt->sva) { // no merge and insert between 2 blocks
		     LIST_INSERT_AFTER(&(FreeMemBlocksList), ptr, blockToInsert);
  80310a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  80310e:	74 06                	je     803116 <insert_sorted_with_merge_freeList+0x20a>
  803110:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803114:	75 17                	jne    80312d <insert_sorted_with_merge_freeList+0x221>
  803116:	83 ec 04             	sub    $0x4,%esp
  803119:	68 dc 42 80 00       	push   $0x8042dc
  80311e:	68 f0 00 00 00       	push   $0xf0
  803123:	68 4b 42 80 00       	push   $0x80424b
  803128:	e8 f9 d5 ff ff       	call   800726 <_panic>
  80312d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803130:	8b 10                	mov    (%eax),%edx
  803132:	8b 45 08             	mov    0x8(%ebp),%eax
  803135:	89 10                	mov    %edx,(%eax)
  803137:	8b 45 08             	mov    0x8(%ebp),%eax
  80313a:	8b 00                	mov    (%eax),%eax
  80313c:	85 c0                	test   %eax,%eax
  80313e:	74 0b                	je     80314b <insert_sorted_with_merge_freeList+0x23f>
  803140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803143:	8b 00                	mov    (%eax),%eax
  803145:	8b 55 08             	mov    0x8(%ebp),%edx
  803148:	89 50 04             	mov    %edx,0x4(%eax)
  80314b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80314e:	8b 55 08             	mov    0x8(%ebp),%edx
  803151:	89 10                	mov    %edx,(%eax)
  803153:	8b 45 08             	mov    0x8(%ebp),%eax
  803156:	8b 55 f4             	mov    -0xc(%ebp),%edx
  803159:	89 50 04             	mov    %edx,0x4(%eax)
  80315c:	8b 45 08             	mov    0x8(%ebp),%eax
  80315f:	8b 00                	mov    (%eax),%eax
  803161:	85 c0                	test   %eax,%eax
  803163:	75 08                	jne    80316d <insert_sorted_with_merge_freeList+0x261>
  803165:	8b 45 08             	mov    0x8(%ebp),%eax
  803168:	a3 3c 51 80 00       	mov    %eax,0x80513c
  80316d:	a1 44 51 80 00       	mov    0x805144,%eax
  803172:	40                   	inc    %eax
  803173:	a3 44 51 80 00       	mov    %eax,0x805144

		         break;
  803178:	e9 64 05 00 00       	jmp    8036e1 <insert_sorted_with_merge_freeList+0x7d5>
		            }



		else if((FreeMemBlocksList.lh_last->size + FreeMemBlocksList.lh_last->sva)==blockToInsert->sva
  80317d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  803182:	8b 50 0c             	mov    0xc(%eax),%edx
  803185:	a1 3c 51 80 00       	mov    0x80513c,%eax
  80318a:	8b 40 08             	mov    0x8(%eax),%eax
  80318d:	01 c2                	add    %eax,%edx
  80318f:	8b 45 08             	mov    0x8(%ebp),%eax
  803192:	8b 40 08             	mov    0x8(%eax),%eax
  803195:	39 c2                	cmp    %eax,%edx
  803197:	0f 85 b1 00 00 00    	jne    80324e <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last !=NULL
  80319d:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031a2:	85 c0                	test   %eax,%eax
  8031a4:	0f 84 a4 00 00 00    	je     80324e <insert_sorted_with_merge_freeList+0x342>
				&&FreeMemBlocksList.lh_last->prev_next_info.le_next==NULL
  8031aa:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031af:	8b 00                	mov    (%eax),%eax
  8031b1:	85 c0                	test   %eax,%eax
  8031b3:	0f 85 95 00 00 00    	jne    80324e <insert_sorted_with_merge_freeList+0x342>
			 ){

	FreeMemBlocksList.lh_last->size=FreeMemBlocksList.lh_last ->size+blockToInsert->size;
  8031b9:	a1 3c 51 80 00       	mov    0x80513c,%eax
  8031be:	8b 15 3c 51 80 00    	mov    0x80513c,%edx
  8031c4:	8b 4a 0c             	mov    0xc(%edx),%ecx
  8031c7:	8b 55 08             	mov    0x8(%ebp),%edx
  8031ca:	8b 52 0c             	mov    0xc(%edx),%edx
  8031cd:	01 ca                	add    %ecx,%edx
  8031cf:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size =0;
  8031d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8031d5:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva =0;
  8031dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8031df:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8031e6:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8031ea:	75 17                	jne    803203 <insert_sorted_with_merge_freeList+0x2f7>
  8031ec:	83 ec 04             	sub    $0x4,%esp
  8031ef:	68 28 42 80 00       	push   $0x804228
  8031f4:	68 ff 00 00 00       	push   $0xff
  8031f9:	68 4b 42 80 00       	push   $0x80424b
  8031fe:	e8 23 d5 ff ff       	call   800726 <_panic>
  803203:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803209:	8b 45 08             	mov    0x8(%ebp),%eax
  80320c:	89 10                	mov    %edx,(%eax)
  80320e:	8b 45 08             	mov    0x8(%ebp),%eax
  803211:	8b 00                	mov    (%eax),%eax
  803213:	85 c0                	test   %eax,%eax
  803215:	74 0d                	je     803224 <insert_sorted_with_merge_freeList+0x318>
  803217:	a1 48 51 80 00       	mov    0x805148,%eax
  80321c:	8b 55 08             	mov    0x8(%ebp),%edx
  80321f:	89 50 04             	mov    %edx,0x4(%eax)
  803222:	eb 08                	jmp    80322c <insert_sorted_with_merge_freeList+0x320>
  803224:	8b 45 08             	mov    0x8(%ebp),%eax
  803227:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80322c:	8b 45 08             	mov    0x8(%ebp),%eax
  80322f:	a3 48 51 80 00       	mov    %eax,0x805148
  803234:	8b 45 08             	mov    0x8(%ebp),%eax
  803237:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80323e:	a1 54 51 80 00       	mov    0x805154,%eax
  803243:	40                   	inc    %eax
  803244:	a3 54 51 80 00       	mov    %eax,0x805154

	break;
  803249:	e9 93 04 00 00       	jmp    8036e1 <insert_sorted_with_merge_freeList+0x7d5>
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
  80324e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803251:	8b 50 08             	mov    0x8(%eax),%edx
  803254:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803257:	8b 40 0c             	mov    0xc(%eax),%eax
  80325a:	01 c2                	add    %eax,%edx
  80325c:	8b 45 08             	mov    0x8(%ebp),%eax
  80325f:	8b 40 08             	mov    0x8(%eax),%eax
  803262:	39 c2                	cmp    %eax,%edx
  803264:	0f 85 ae 00 00 00    	jne    803318 <insert_sorted_with_merge_freeList+0x40c>
			&& (blockToInsert->size + blockToInsert->sva
  80326a:	8b 45 08             	mov    0x8(%ebp),%eax
  80326d:	8b 50 0c             	mov    0xc(%eax),%edx
  803270:	8b 45 08             	mov    0x8(%ebp),%eax
  803273:	8b 40 08             	mov    0x8(%eax),%eax
  803276:	01 c2                	add    %eax,%edx
					!=ptr->prev_next_info.le_next->sva ) ){
  803278:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80327b:	8b 00                	mov    (%eax),%eax
  80327d:	8b 40 08             	mov    0x8(%eax),%eax
	break;
	}


	else if((ptr->sva + ptr->size ) ==blockToInsert->sva
			&& (blockToInsert->size + blockToInsert->sva
  803280:	39 c2                	cmp    %eax,%edx
  803282:	0f 84 90 00 00 00    	je     803318 <insert_sorted_with_merge_freeList+0x40c>
					!=ptr->prev_next_info.le_next->sva ) ){
		ptr->size =ptr->size +blockToInsert->size;
  803288:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80328b:	8b 50 0c             	mov    0xc(%eax),%edx
  80328e:	8b 45 08             	mov    0x8(%ebp),%eax
  803291:	8b 40 0c             	mov    0xc(%eax),%eax
  803294:	01 c2                	add    %eax,%edx
  803296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803299:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80329c:	8b 45 08             	mov    0x8(%ebp),%eax
  80329f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  8032a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032a9:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  8032b0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8032b4:	75 17                	jne    8032cd <insert_sorted_with_merge_freeList+0x3c1>
  8032b6:	83 ec 04             	sub    $0x4,%esp
  8032b9:	68 28 42 80 00       	push   $0x804228
  8032be:	68 0b 01 00 00       	push   $0x10b
  8032c3:	68 4b 42 80 00       	push   $0x80424b
  8032c8:	e8 59 d4 ff ff       	call   800726 <_panic>
  8032cd:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8032d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8032d6:	89 10                	mov    %edx,(%eax)
  8032d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8032db:	8b 00                	mov    (%eax),%eax
  8032dd:	85 c0                	test   %eax,%eax
  8032df:	74 0d                	je     8032ee <insert_sorted_with_merge_freeList+0x3e2>
  8032e1:	a1 48 51 80 00       	mov    0x805148,%eax
  8032e6:	8b 55 08             	mov    0x8(%ebp),%edx
  8032e9:	89 50 04             	mov    %edx,0x4(%eax)
  8032ec:	eb 08                	jmp    8032f6 <insert_sorted_with_merge_freeList+0x3ea>
  8032ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f1:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8032f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8032f9:	a3 48 51 80 00       	mov    %eax,0x805148
  8032fe:	8b 45 08             	mov    0x8(%ebp),%eax
  803301:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803308:	a1 54 51 80 00       	mov    0x805154,%eax
  80330d:	40                   	inc    %eax
  80330e:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  803313:	e9 c9 03 00 00       	jmp    8036e1 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((blockToInsert->size + blockToInsert->sva )
  803318:	8b 45 08             	mov    0x8(%ebp),%eax
  80331b:	8b 50 0c             	mov    0xc(%eax),%edx
  80331e:	8b 45 08             	mov    0x8(%ebp),%eax
  803321:	8b 40 08             	mov    0x8(%eax),%eax
  803324:	01 c2                	add    %eax,%edx
			== ptr->sva && ptr!=NULL
  803326:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803329:	8b 40 08             	mov    0x8(%eax),%eax
		blockToInsert->sva=0;
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);

		break;
	}
	else if((blockToInsert->size + blockToInsert->sva )
  80332c:	39 c2                	cmp    %eax,%edx
  80332e:	0f 85 bb 00 00 00    	jne    8033ef <insert_sorted_with_merge_freeList+0x4e3>
			== ptr->sva && ptr!=NULL
  803334:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803338:	0f 84 b1 00 00 00    	je     8033ef <insert_sorted_with_merge_freeList+0x4e3>
			&&ptr->prev_next_info.le_prev==NULL)
  80333e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803341:	8b 40 04             	mov    0x4(%eax),%eax
  803344:	85 c0                	test   %eax,%eax
  803346:	0f 85 a3 00 00 00    	jne    8033ef <insert_sorted_with_merge_freeList+0x4e3>
		{
		FreeMemBlocksList.lh_first->sva=blockToInsert->sva;
  80334c:	a1 38 51 80 00       	mov    0x805138,%eax
  803351:	8b 55 08             	mov    0x8(%ebp),%edx
  803354:	8b 52 08             	mov    0x8(%edx),%edx
  803357:	89 50 08             	mov    %edx,0x8(%eax)
		FreeMemBlocksList.lh_first->size=FreeMemBlocksList.lh_first->size+blockToInsert->size;
  80335a:	a1 38 51 80 00       	mov    0x805138,%eax
  80335f:	8b 15 38 51 80 00    	mov    0x805138,%edx
  803365:	8b 4a 0c             	mov    0xc(%edx),%ecx
  803368:	8b 55 08             	mov    0x8(%ebp),%edx
  80336b:	8b 52 0c             	mov    0xc(%edx),%edx
  80336e:	01 ca                	add    %ecx,%edx
  803370:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  803373:	8b 45 08             	mov    0x8(%ebp),%eax
  803376:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  80337d:	8b 45 08             	mov    0x8(%ebp),%eax
  803380:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803387:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80338b:	75 17                	jne    8033a4 <insert_sorted_with_merge_freeList+0x498>
  80338d:	83 ec 04             	sub    $0x4,%esp
  803390:	68 28 42 80 00       	push   $0x804228
  803395:	68 17 01 00 00       	push   $0x117
  80339a:	68 4b 42 80 00       	push   $0x80424b
  80339f:	e8 82 d3 ff ff       	call   800726 <_panic>
  8033a4:	8b 15 48 51 80 00    	mov    0x805148,%edx
  8033aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8033ad:	89 10                	mov    %edx,(%eax)
  8033af:	8b 45 08             	mov    0x8(%ebp),%eax
  8033b2:	8b 00                	mov    (%eax),%eax
  8033b4:	85 c0                	test   %eax,%eax
  8033b6:	74 0d                	je     8033c5 <insert_sorted_with_merge_freeList+0x4b9>
  8033b8:	a1 48 51 80 00       	mov    0x805148,%eax
  8033bd:	8b 55 08             	mov    0x8(%ebp),%edx
  8033c0:	89 50 04             	mov    %edx,0x4(%eax)
  8033c3:	eb 08                	jmp    8033cd <insert_sorted_with_merge_freeList+0x4c1>
  8033c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033c8:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8033cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d0:	a3 48 51 80 00       	mov    %eax,0x805148
  8033d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033d8:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8033df:	a1 54 51 80 00       	mov    0x805154,%eax
  8033e4:	40                   	inc    %eax
  8033e5:	a3 54 51 80 00       	mov    %eax,0x805154

		break;
  8033ea:	e9 f2 02 00 00       	jmp    8036e1 <insert_sorted_with_merge_freeList+0x7d5>
	}

	else if(blockToInsert->sva + blockToInsert->size == ptr->sva
  8033ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f2:	8b 50 08             	mov    0x8(%eax),%edx
  8033f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8033f8:	8b 40 0c             	mov    0xc(%eax),%eax
  8033fb:	01 c2                	add    %eax,%edx
  8033fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803400:	8b 40 08             	mov    0x8(%eax),%eax
  803403:	39 c2                	cmp    %eax,%edx
  803405:	0f 85 be 00 00 00    	jne    8034c9 <insert_sorted_with_merge_freeList+0x5bd>
		&&ptr->prev_next_info.le_prev->sva + ptr->prev_next_info.le_prev->size !=blockToInsert->sva
  80340b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80340e:	8b 40 04             	mov    0x4(%eax),%eax
  803411:	8b 50 08             	mov    0x8(%eax),%edx
  803414:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803417:	8b 40 04             	mov    0x4(%eax),%eax
  80341a:	8b 40 0c             	mov    0xc(%eax),%eax
  80341d:	01 c2                	add    %eax,%edx
  80341f:	8b 45 08             	mov    0x8(%ebp),%eax
  803422:	8b 40 08             	mov    0x8(%eax),%eax
  803425:	39 c2                	cmp    %eax,%edx
  803427:	0f 84 9c 00 00 00    	je     8034c9 <insert_sorted_with_merge_freeList+0x5bd>

			){


		ptr->sva=blockToInsert->sva;
  80342d:	8b 45 08             	mov    0x8(%ebp),%eax
  803430:	8b 50 08             	mov    0x8(%eax),%edx
  803433:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803436:	89 50 08             	mov    %edx,0x8(%eax)
		ptr->size=ptr->size + blockToInsert->size ;
  803439:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80343c:	8b 50 0c             	mov    0xc(%eax),%edx
  80343f:	8b 45 08             	mov    0x8(%ebp),%eax
  803442:	8b 40 0c             	mov    0xc(%eax),%eax
  803445:	01 c2                	add    %eax,%edx
  803447:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80344a:	89 50 0c             	mov    %edx,0xc(%eax)
		blockToInsert->size=0;
  80344d:	8b 45 08             	mov    0x8(%ebp),%eax
  803450:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
		blockToInsert->sva=0;
  803457:	8b 45 08             	mov    0x8(%ebp),%eax
  80345a:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
		LIST_INSERT_HEAD(&(AvailableMemBlocksList),blockToInsert);
  803461:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803465:	75 17                	jne    80347e <insert_sorted_with_merge_freeList+0x572>
  803467:	83 ec 04             	sub    $0x4,%esp
  80346a:	68 28 42 80 00       	push   $0x804228
  80346f:	68 26 01 00 00       	push   $0x126
  803474:	68 4b 42 80 00       	push   $0x80424b
  803479:	e8 a8 d2 ff ff       	call   800726 <_panic>
  80347e:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803484:	8b 45 08             	mov    0x8(%ebp),%eax
  803487:	89 10                	mov    %edx,(%eax)
  803489:	8b 45 08             	mov    0x8(%ebp),%eax
  80348c:	8b 00                	mov    (%eax),%eax
  80348e:	85 c0                	test   %eax,%eax
  803490:	74 0d                	je     80349f <insert_sorted_with_merge_freeList+0x593>
  803492:	a1 48 51 80 00       	mov    0x805148,%eax
  803497:	8b 55 08             	mov    0x8(%ebp),%edx
  80349a:	89 50 04             	mov    %edx,0x4(%eax)
  80349d:	eb 08                	jmp    8034a7 <insert_sorted_with_merge_freeList+0x59b>
  80349f:	8b 45 08             	mov    0x8(%ebp),%eax
  8034a2:	a3 4c 51 80 00       	mov    %eax,0x80514c
  8034a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034aa:	a3 48 51 80 00       	mov    %eax,0x805148
  8034af:	8b 45 08             	mov    0x8(%ebp),%eax
  8034b2:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  8034b9:	a1 54 51 80 00       	mov    0x805154,%eax
  8034be:	40                   	inc    %eax
  8034bf:	a3 54 51 80 00       	mov    %eax,0x805154

		break;//8
  8034c4:	e9 18 02 00 00       	jmp    8036e1 <insert_sorted_with_merge_freeList+0x7d5>
	}
	else if((ptr->size + ptr->sva) == blockToInsert->sva
  8034c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034cc:	8b 50 0c             	mov    0xc(%eax),%edx
  8034cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034d2:	8b 40 08             	mov    0x8(%eax),%eax
  8034d5:	01 c2                	add    %eax,%edx
  8034d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8034da:	8b 40 08             	mov    0x8(%eax),%eax
  8034dd:	39 c2                	cmp    %eax,%edx
  8034df:	0f 85 c4 01 00 00    	jne    8036a9 <insert_sorted_with_merge_freeList+0x79d>
			&& blockToInsert->size+blockToInsert->sva == ptr->prev_next_info.le_next->sva
  8034e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8034e8:	8b 50 0c             	mov    0xc(%eax),%edx
  8034eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8034ee:	8b 40 08             	mov    0x8(%eax),%eax
  8034f1:	01 c2                	add    %eax,%edx
  8034f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8034f6:	8b 00                	mov    (%eax),%eax
  8034f8:	8b 40 08             	mov    0x8(%eax),%eax
  8034fb:	39 c2                	cmp    %eax,%edx
  8034fd:	0f 85 a6 01 00 00    	jne    8036a9 <insert_sorted_with_merge_freeList+0x79d>
			&&ptr!=NULL)
  803503:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  803507:	0f 84 9c 01 00 00    	je     8036a9 <insert_sorted_with_merge_freeList+0x79d>
	{

	    ptr->size =ptr->size + blockToInsert->size + ptr->prev_next_info.le_next->size;
  80350d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803510:	8b 50 0c             	mov    0xc(%eax),%edx
  803513:	8b 45 08             	mov    0x8(%ebp),%eax
  803516:	8b 40 0c             	mov    0xc(%eax),%eax
  803519:	01 c2                	add    %eax,%edx
  80351b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80351e:	8b 00                	mov    (%eax),%eax
  803520:	8b 40 0c             	mov    0xc(%eax),%eax
  803523:	01 c2                	add    %eax,%edx
  803525:	8b 45 f4             	mov    -0xc(%ebp),%eax
  803528:	89 50 0c             	mov    %edx,0xc(%eax)
	    blockToInsert->sva = 0;
  80352b:	8b 45 08             	mov    0x8(%ebp),%eax
  80352e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    blockToInsert->size = 0;
  803535:	8b 45 08             	mov    0x8(%ebp),%eax
  803538:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), blockToInsert);
  80353f:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  803543:	75 17                	jne    80355c <insert_sorted_with_merge_freeList+0x650>
  803545:	83 ec 04             	sub    $0x4,%esp
  803548:	68 28 42 80 00       	push   $0x804228
  80354d:	68 32 01 00 00       	push   $0x132
  803552:	68 4b 42 80 00       	push   $0x80424b
  803557:	e8 ca d1 ff ff       	call   800726 <_panic>
  80355c:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803562:	8b 45 08             	mov    0x8(%ebp),%eax
  803565:	89 10                	mov    %edx,(%eax)
  803567:	8b 45 08             	mov    0x8(%ebp),%eax
  80356a:	8b 00                	mov    (%eax),%eax
  80356c:	85 c0                	test   %eax,%eax
  80356e:	74 0d                	je     80357d <insert_sorted_with_merge_freeList+0x671>
  803570:	a1 48 51 80 00       	mov    0x805148,%eax
  803575:	8b 55 08             	mov    0x8(%ebp),%edx
  803578:	89 50 04             	mov    %edx,0x4(%eax)
  80357b:	eb 08                	jmp    803585 <insert_sorted_with_merge_freeList+0x679>
  80357d:	8b 45 08             	mov    0x8(%ebp),%eax
  803580:	a3 4c 51 80 00       	mov    %eax,0x80514c
  803585:	8b 45 08             	mov    0x8(%ebp),%eax
  803588:	a3 48 51 80 00       	mov    %eax,0x805148
  80358d:	8b 45 08             	mov    0x8(%ebp),%eax
  803590:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803597:	a1 54 51 80 00       	mov    0x805154,%eax
  80359c:	40                   	inc    %eax
  80359d:	a3 54 51 80 00       	mov    %eax,0x805154
	    ptr->prev_next_info.le_next->sva = 0;
  8035a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035a5:	8b 00                	mov    (%eax),%eax
  8035a7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
	    ptr->prev_next_info.le_next->size = 0;
  8035ae:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035b1:	8b 00                	mov    (%eax),%eax
  8035b3:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
	 struct MemBlock *temp =ptr->prev_next_info.le_next;
  8035ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8035bd:	8b 00                	mov    (%eax),%eax
  8035bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    LIST_REMOVE(&(FreeMemBlocksList),temp);
  8035c2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8035c6:	75 17                	jne    8035df <insert_sorted_with_merge_freeList+0x6d3>
  8035c8:	83 ec 04             	sub    $0x4,%esp
  8035cb:	68 bd 42 80 00       	push   $0x8042bd
  8035d0:	68 36 01 00 00       	push   $0x136
  8035d5:	68 4b 42 80 00       	push   $0x80424b
  8035da:	e8 47 d1 ff ff       	call   800726 <_panic>
  8035df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035e2:	8b 00                	mov    (%eax),%eax
  8035e4:	85 c0                	test   %eax,%eax
  8035e6:	74 10                	je     8035f8 <insert_sorted_with_merge_freeList+0x6ec>
  8035e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035eb:	8b 00                	mov    (%eax),%eax
  8035ed:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8035f0:	8b 52 04             	mov    0x4(%edx),%edx
  8035f3:	89 50 04             	mov    %edx,0x4(%eax)
  8035f6:	eb 0b                	jmp    803603 <insert_sorted_with_merge_freeList+0x6f7>
  8035f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8035fb:	8b 40 04             	mov    0x4(%eax),%eax
  8035fe:	a3 3c 51 80 00       	mov    %eax,0x80513c
  803603:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803606:	8b 40 04             	mov    0x4(%eax),%eax
  803609:	85 c0                	test   %eax,%eax
  80360b:	74 0f                	je     80361c <insert_sorted_with_merge_freeList+0x710>
  80360d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803610:	8b 40 04             	mov    0x4(%eax),%eax
  803613:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  803616:	8b 12                	mov    (%edx),%edx
  803618:	89 10                	mov    %edx,(%eax)
  80361a:	eb 0a                	jmp    803626 <insert_sorted_with_merge_freeList+0x71a>
  80361c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80361f:	8b 00                	mov    (%eax),%eax
  803621:	a3 38 51 80 00       	mov    %eax,0x805138
  803626:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
  80362f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803632:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  803639:	a1 44 51 80 00       	mov    0x805144,%eax
  80363e:	48                   	dec    %eax
  80363f:	a3 44 51 80 00       	mov    %eax,0x805144
	    LIST_INSERT_HEAD(&(AvailableMemBlocksList), temp);
  803644:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  803648:	75 17                	jne    803661 <insert_sorted_with_merge_freeList+0x755>
  80364a:	83 ec 04             	sub    $0x4,%esp
  80364d:	68 28 42 80 00       	push   $0x804228
  803652:	68 37 01 00 00       	push   $0x137
  803657:	68 4b 42 80 00       	push   $0x80424b
  80365c:	e8 c5 d0 ff ff       	call   800726 <_panic>
  803661:	8b 15 48 51 80 00    	mov    0x805148,%edx
  803667:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366a:	89 10                	mov    %edx,(%eax)
  80366c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80366f:	8b 00                	mov    (%eax),%eax
  803671:	85 c0                	test   %eax,%eax
  803673:	74 0d                	je     803682 <insert_sorted_with_merge_freeList+0x776>
  803675:	a1 48 51 80 00       	mov    0x805148,%eax
  80367a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80367d:	89 50 04             	mov    %edx,0x4(%eax)
  803680:	eb 08                	jmp    80368a <insert_sorted_with_merge_freeList+0x77e>
  803682:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803685:	a3 4c 51 80 00       	mov    %eax,0x80514c
  80368a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80368d:	a3 48 51 80 00       	mov    %eax,0x805148
  803692:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  803695:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
  80369c:	a1 54 51 80 00       	mov    0x805154,%eax
  8036a1:	40                   	inc    %eax
  8036a2:	a3 54 51 80 00       	mov    %eax,0x805154

	    break;//9
  8036a7:	eb 38                	jmp    8036e1 <insert_sorted_with_merge_freeList+0x7d5>
		&&size_of_free!=0 ){
	LIST_INSERT_HEAD(&(FreeMemBlocksList),blockToInsert);

}
else{
	LIST_FOREACH(ptr,&(FreeMemBlocksList)){
  8036a9:	a1 40 51 80 00       	mov    0x805140,%eax
  8036ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8036b1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036b5:	74 07                	je     8036be <insert_sorted_with_merge_freeList+0x7b2>
  8036b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8036ba:	8b 00                	mov    (%eax),%eax
  8036bc:	eb 05                	jmp    8036c3 <insert_sorted_with_merge_freeList+0x7b7>
  8036be:	b8 00 00 00 00       	mov    $0x0,%eax
  8036c3:	a3 40 51 80 00       	mov    %eax,0x805140
  8036c8:	a1 40 51 80 00       	mov    0x805140,%eax
  8036cd:	85 c0                	test   %eax,%eax
  8036cf:	0f 85 ef f9 ff ff    	jne    8030c4 <insert_sorted_with_merge_freeList+0x1b8>
  8036d5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  8036d9:	0f 85 e5 f9 ff ff    	jne    8030c4 <insert_sorted_with_merge_freeList+0x1b8>



	}
	}
	}
  8036df:	eb 00                	jmp    8036e1 <insert_sorted_with_merge_freeList+0x7d5>
  8036e1:	90                   	nop
  8036e2:	c9                   	leave  
  8036e3:	c3                   	ret    

008036e4 <__udivdi3>:
  8036e4:	55                   	push   %ebp
  8036e5:	57                   	push   %edi
  8036e6:	56                   	push   %esi
  8036e7:	53                   	push   %ebx
  8036e8:	83 ec 1c             	sub    $0x1c,%esp
  8036eb:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8036ef:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8036f3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8036f7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8036fb:	89 ca                	mov    %ecx,%edx
  8036fd:	89 f8                	mov    %edi,%eax
  8036ff:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  803703:	85 f6                	test   %esi,%esi
  803705:	75 2d                	jne    803734 <__udivdi3+0x50>
  803707:	39 cf                	cmp    %ecx,%edi
  803709:	77 65                	ja     803770 <__udivdi3+0x8c>
  80370b:	89 fd                	mov    %edi,%ebp
  80370d:	85 ff                	test   %edi,%edi
  80370f:	75 0b                	jne    80371c <__udivdi3+0x38>
  803711:	b8 01 00 00 00       	mov    $0x1,%eax
  803716:	31 d2                	xor    %edx,%edx
  803718:	f7 f7                	div    %edi
  80371a:	89 c5                	mov    %eax,%ebp
  80371c:	31 d2                	xor    %edx,%edx
  80371e:	89 c8                	mov    %ecx,%eax
  803720:	f7 f5                	div    %ebp
  803722:	89 c1                	mov    %eax,%ecx
  803724:	89 d8                	mov    %ebx,%eax
  803726:	f7 f5                	div    %ebp
  803728:	89 cf                	mov    %ecx,%edi
  80372a:	89 fa                	mov    %edi,%edx
  80372c:	83 c4 1c             	add    $0x1c,%esp
  80372f:	5b                   	pop    %ebx
  803730:	5e                   	pop    %esi
  803731:	5f                   	pop    %edi
  803732:	5d                   	pop    %ebp
  803733:	c3                   	ret    
  803734:	39 ce                	cmp    %ecx,%esi
  803736:	77 28                	ja     803760 <__udivdi3+0x7c>
  803738:	0f bd fe             	bsr    %esi,%edi
  80373b:	83 f7 1f             	xor    $0x1f,%edi
  80373e:	75 40                	jne    803780 <__udivdi3+0x9c>
  803740:	39 ce                	cmp    %ecx,%esi
  803742:	72 0a                	jb     80374e <__udivdi3+0x6a>
  803744:	3b 44 24 08          	cmp    0x8(%esp),%eax
  803748:	0f 87 9e 00 00 00    	ja     8037ec <__udivdi3+0x108>
  80374e:	b8 01 00 00 00       	mov    $0x1,%eax
  803753:	89 fa                	mov    %edi,%edx
  803755:	83 c4 1c             	add    $0x1c,%esp
  803758:	5b                   	pop    %ebx
  803759:	5e                   	pop    %esi
  80375a:	5f                   	pop    %edi
  80375b:	5d                   	pop    %ebp
  80375c:	c3                   	ret    
  80375d:	8d 76 00             	lea    0x0(%esi),%esi
  803760:	31 ff                	xor    %edi,%edi
  803762:	31 c0                	xor    %eax,%eax
  803764:	89 fa                	mov    %edi,%edx
  803766:	83 c4 1c             	add    $0x1c,%esp
  803769:	5b                   	pop    %ebx
  80376a:	5e                   	pop    %esi
  80376b:	5f                   	pop    %edi
  80376c:	5d                   	pop    %ebp
  80376d:	c3                   	ret    
  80376e:	66 90                	xchg   %ax,%ax
  803770:	89 d8                	mov    %ebx,%eax
  803772:	f7 f7                	div    %edi
  803774:	31 ff                	xor    %edi,%edi
  803776:	89 fa                	mov    %edi,%edx
  803778:	83 c4 1c             	add    $0x1c,%esp
  80377b:	5b                   	pop    %ebx
  80377c:	5e                   	pop    %esi
  80377d:	5f                   	pop    %edi
  80377e:	5d                   	pop    %ebp
  80377f:	c3                   	ret    
  803780:	bd 20 00 00 00       	mov    $0x20,%ebp
  803785:	89 eb                	mov    %ebp,%ebx
  803787:	29 fb                	sub    %edi,%ebx
  803789:	89 f9                	mov    %edi,%ecx
  80378b:	d3 e6                	shl    %cl,%esi
  80378d:	89 c5                	mov    %eax,%ebp
  80378f:	88 d9                	mov    %bl,%cl
  803791:	d3 ed                	shr    %cl,%ebp
  803793:	89 e9                	mov    %ebp,%ecx
  803795:	09 f1                	or     %esi,%ecx
  803797:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80379b:	89 f9                	mov    %edi,%ecx
  80379d:	d3 e0                	shl    %cl,%eax
  80379f:	89 c5                	mov    %eax,%ebp
  8037a1:	89 d6                	mov    %edx,%esi
  8037a3:	88 d9                	mov    %bl,%cl
  8037a5:	d3 ee                	shr    %cl,%esi
  8037a7:	89 f9                	mov    %edi,%ecx
  8037a9:	d3 e2                	shl    %cl,%edx
  8037ab:	8b 44 24 08          	mov    0x8(%esp),%eax
  8037af:	88 d9                	mov    %bl,%cl
  8037b1:	d3 e8                	shr    %cl,%eax
  8037b3:	09 c2                	or     %eax,%edx
  8037b5:	89 d0                	mov    %edx,%eax
  8037b7:	89 f2                	mov    %esi,%edx
  8037b9:	f7 74 24 0c          	divl   0xc(%esp)
  8037bd:	89 d6                	mov    %edx,%esi
  8037bf:	89 c3                	mov    %eax,%ebx
  8037c1:	f7 e5                	mul    %ebp
  8037c3:	39 d6                	cmp    %edx,%esi
  8037c5:	72 19                	jb     8037e0 <__udivdi3+0xfc>
  8037c7:	74 0b                	je     8037d4 <__udivdi3+0xf0>
  8037c9:	89 d8                	mov    %ebx,%eax
  8037cb:	31 ff                	xor    %edi,%edi
  8037cd:	e9 58 ff ff ff       	jmp    80372a <__udivdi3+0x46>
  8037d2:	66 90                	xchg   %ax,%ax
  8037d4:	8b 54 24 08          	mov    0x8(%esp),%edx
  8037d8:	89 f9                	mov    %edi,%ecx
  8037da:	d3 e2                	shl    %cl,%edx
  8037dc:	39 c2                	cmp    %eax,%edx
  8037de:	73 e9                	jae    8037c9 <__udivdi3+0xe5>
  8037e0:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8037e3:	31 ff                	xor    %edi,%edi
  8037e5:	e9 40 ff ff ff       	jmp    80372a <__udivdi3+0x46>
  8037ea:	66 90                	xchg   %ax,%ax
  8037ec:	31 c0                	xor    %eax,%eax
  8037ee:	e9 37 ff ff ff       	jmp    80372a <__udivdi3+0x46>
  8037f3:	90                   	nop

008037f4 <__umoddi3>:
  8037f4:	55                   	push   %ebp
  8037f5:	57                   	push   %edi
  8037f6:	56                   	push   %esi
  8037f7:	53                   	push   %ebx
  8037f8:	83 ec 1c             	sub    $0x1c,%esp
  8037fb:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  8037ff:	8b 74 24 34          	mov    0x34(%esp),%esi
  803803:	8b 7c 24 38          	mov    0x38(%esp),%edi
  803807:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80380b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80380f:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  803813:	89 f3                	mov    %esi,%ebx
  803815:	89 fa                	mov    %edi,%edx
  803817:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80381b:	89 34 24             	mov    %esi,(%esp)
  80381e:	85 c0                	test   %eax,%eax
  803820:	75 1a                	jne    80383c <__umoddi3+0x48>
  803822:	39 f7                	cmp    %esi,%edi
  803824:	0f 86 a2 00 00 00    	jbe    8038cc <__umoddi3+0xd8>
  80382a:	89 c8                	mov    %ecx,%eax
  80382c:	89 f2                	mov    %esi,%edx
  80382e:	f7 f7                	div    %edi
  803830:	89 d0                	mov    %edx,%eax
  803832:	31 d2                	xor    %edx,%edx
  803834:	83 c4 1c             	add    $0x1c,%esp
  803837:	5b                   	pop    %ebx
  803838:	5e                   	pop    %esi
  803839:	5f                   	pop    %edi
  80383a:	5d                   	pop    %ebp
  80383b:	c3                   	ret    
  80383c:	39 f0                	cmp    %esi,%eax
  80383e:	0f 87 ac 00 00 00    	ja     8038f0 <__umoddi3+0xfc>
  803844:	0f bd e8             	bsr    %eax,%ebp
  803847:	83 f5 1f             	xor    $0x1f,%ebp
  80384a:	0f 84 ac 00 00 00    	je     8038fc <__umoddi3+0x108>
  803850:	bf 20 00 00 00       	mov    $0x20,%edi
  803855:	29 ef                	sub    %ebp,%edi
  803857:	89 fe                	mov    %edi,%esi
  803859:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  80385d:	89 e9                	mov    %ebp,%ecx
  80385f:	d3 e0                	shl    %cl,%eax
  803861:	89 d7                	mov    %edx,%edi
  803863:	89 f1                	mov    %esi,%ecx
  803865:	d3 ef                	shr    %cl,%edi
  803867:	09 c7                	or     %eax,%edi
  803869:	89 e9                	mov    %ebp,%ecx
  80386b:	d3 e2                	shl    %cl,%edx
  80386d:	89 14 24             	mov    %edx,(%esp)
  803870:	89 d8                	mov    %ebx,%eax
  803872:	d3 e0                	shl    %cl,%eax
  803874:	89 c2                	mov    %eax,%edx
  803876:	8b 44 24 08          	mov    0x8(%esp),%eax
  80387a:	d3 e0                	shl    %cl,%eax
  80387c:	89 44 24 04          	mov    %eax,0x4(%esp)
  803880:	8b 44 24 08          	mov    0x8(%esp),%eax
  803884:	89 f1                	mov    %esi,%ecx
  803886:	d3 e8                	shr    %cl,%eax
  803888:	09 d0                	or     %edx,%eax
  80388a:	d3 eb                	shr    %cl,%ebx
  80388c:	89 da                	mov    %ebx,%edx
  80388e:	f7 f7                	div    %edi
  803890:	89 d3                	mov    %edx,%ebx
  803892:	f7 24 24             	mull   (%esp)
  803895:	89 c6                	mov    %eax,%esi
  803897:	89 d1                	mov    %edx,%ecx
  803899:	39 d3                	cmp    %edx,%ebx
  80389b:	0f 82 87 00 00 00    	jb     803928 <__umoddi3+0x134>
  8038a1:	0f 84 91 00 00 00    	je     803938 <__umoddi3+0x144>
  8038a7:	8b 54 24 04          	mov    0x4(%esp),%edx
  8038ab:	29 f2                	sub    %esi,%edx
  8038ad:	19 cb                	sbb    %ecx,%ebx
  8038af:	89 d8                	mov    %ebx,%eax
  8038b1:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8038b5:	d3 e0                	shl    %cl,%eax
  8038b7:	89 e9                	mov    %ebp,%ecx
  8038b9:	d3 ea                	shr    %cl,%edx
  8038bb:	09 d0                	or     %edx,%eax
  8038bd:	89 e9                	mov    %ebp,%ecx
  8038bf:	d3 eb                	shr    %cl,%ebx
  8038c1:	89 da                	mov    %ebx,%edx
  8038c3:	83 c4 1c             	add    $0x1c,%esp
  8038c6:	5b                   	pop    %ebx
  8038c7:	5e                   	pop    %esi
  8038c8:	5f                   	pop    %edi
  8038c9:	5d                   	pop    %ebp
  8038ca:	c3                   	ret    
  8038cb:	90                   	nop
  8038cc:	89 fd                	mov    %edi,%ebp
  8038ce:	85 ff                	test   %edi,%edi
  8038d0:	75 0b                	jne    8038dd <__umoddi3+0xe9>
  8038d2:	b8 01 00 00 00       	mov    $0x1,%eax
  8038d7:	31 d2                	xor    %edx,%edx
  8038d9:	f7 f7                	div    %edi
  8038db:	89 c5                	mov    %eax,%ebp
  8038dd:	89 f0                	mov    %esi,%eax
  8038df:	31 d2                	xor    %edx,%edx
  8038e1:	f7 f5                	div    %ebp
  8038e3:	89 c8                	mov    %ecx,%eax
  8038e5:	f7 f5                	div    %ebp
  8038e7:	89 d0                	mov    %edx,%eax
  8038e9:	e9 44 ff ff ff       	jmp    803832 <__umoddi3+0x3e>
  8038ee:	66 90                	xchg   %ax,%ax
  8038f0:	89 c8                	mov    %ecx,%eax
  8038f2:	89 f2                	mov    %esi,%edx
  8038f4:	83 c4 1c             	add    $0x1c,%esp
  8038f7:	5b                   	pop    %ebx
  8038f8:	5e                   	pop    %esi
  8038f9:	5f                   	pop    %edi
  8038fa:	5d                   	pop    %ebp
  8038fb:	c3                   	ret    
  8038fc:	3b 04 24             	cmp    (%esp),%eax
  8038ff:	72 06                	jb     803907 <__umoddi3+0x113>
  803901:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  803905:	77 0f                	ja     803916 <__umoddi3+0x122>
  803907:	89 f2                	mov    %esi,%edx
  803909:	29 f9                	sub    %edi,%ecx
  80390b:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  80390f:	89 14 24             	mov    %edx,(%esp)
  803912:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  803916:	8b 44 24 04          	mov    0x4(%esp),%eax
  80391a:	8b 14 24             	mov    (%esp),%edx
  80391d:	83 c4 1c             	add    $0x1c,%esp
  803920:	5b                   	pop    %ebx
  803921:	5e                   	pop    %esi
  803922:	5f                   	pop    %edi
  803923:	5d                   	pop    %ebp
  803924:	c3                   	ret    
  803925:	8d 76 00             	lea    0x0(%esi),%esi
  803928:	2b 04 24             	sub    (%esp),%eax
  80392b:	19 fa                	sbb    %edi,%edx
  80392d:	89 d1                	mov    %edx,%ecx
  80392f:	89 c6                	mov    %eax,%esi
  803931:	e9 71 ff ff ff       	jmp    8038a7 <__umoddi3+0xb3>
  803936:	66 90                	xchg   %ax,%ax
  803938:	39 44 24 04          	cmp    %eax,0x4(%esp)
  80393c:	72 ea                	jb     803928 <__umoddi3+0x134>
  80393e:	89 d9                	mov    %ebx,%ecx
  803940:	e9 62 ff ff ff       	jmp    8038a7 <__umoddi3+0xb3>
